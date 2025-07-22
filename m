Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8409DC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9DC6B00B8; Tue, 22 Jul 2025 10:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189F46B00B9; Tue, 22 Jul 2025 10:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AA26B00BA; Tue, 22 Jul 2025 10:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE70E6B00B8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:40:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70282B9573
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:40:49 +0000 (UTC)
X-FDA: 83692162218.04.9CDAFB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDB3A1A0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:40:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aTsctFXi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195247; a=rsa-sha256;
	cv=none;
	b=otHeX0YBANCTbqIxQSQQdjYUsCIdT4OcKHYtPIa/98orcpBvojqQFfANGaqKdoPCVDU3pI
	BqqfXPyZDYqcc0xd26ejHCjAA5vsL8v5hpEirQUDojBM5smGxJmbI0UwI4F3TKzbg0fp/z
	UJzYCtLFIN1veQegf3g87Uxy94VvlGo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aTsctFXi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLkgHc/8d7d4QDAstqhqEvMayi/3ZoWX1vWISlyZq0E=;
	b=el2DSh4E7+XejpvGv8Yd+pHR8gtTfOCHJOd1r9t8gHRASpzm9MM2W1uM+ukC8GgI3c8c4a
	6KJF1zCzhq9ggLaiqIZ7pVQzhEQ1xFSHSc1essh1rgixAxtoZ71vrQ2FlSmghSfeAy+e1l
	0TrXPE7VLiXdyyPjTAbz4F0F8NorTr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753195246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KLkgHc/8d7d4QDAstqhqEvMayi/3ZoWX1vWISlyZq0E=;
	b=aTsctFXiGnyVTnHYF6sxaFtg/KMMuq9sv/r9b0h3fiWcWdGmaXipO3zimcAHqr1g+P531R
	M5r7002tB2koMb3sUKLlDf6BtPnsmy/pKtB0wUPotM4f1oToPxZcrbkuVxrHKmLOR9nR6o
	q1Rq5WF/85fN9acxvJbvIwfUxRSMp9U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-tGCKfJv9PIOYQiRv_S5x5g-1; Tue, 22 Jul 2025 10:40:38 -0400
X-MC-Unique: tGCKfJv9PIOYQiRv_S5x5g-1
X-Mimecast-MFC-AGG-ID: tGCKfJv9PIOYQiRv_S5x5g_1753195236
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so30542035e9.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195236; x=1753800036;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KLkgHc/8d7d4QDAstqhqEvMayi/3ZoWX1vWISlyZq0E=;
        b=RqDcxZSEi7RAtH9Fg0bvgcvYy/Emx6rqe79x6b+5AfzXOfGD67xhaYPjmP8mwKcIIW
         Qkf3xRzuGVQ2jGuvAwUn0LqtVXOG39FIvdJPwiWUprkJT3kOz+kBYB9P/WkulABmVONI
         Zg/vAk/iptZ4nVoeZlB3+Gi2DCGPHSZLkeP8nLhnPzN6ASP1hA5b29FF3/USrmlifVIa
         SrBTODerCeKejqsGg9gUEJp1n3F2NeYc4B7/BVI1sGG82X3rYAgmeKiX3DU4qxTO7X3X
         bQGqnd7Rfg50HIh1REoM8+3tSyCxsFuwTMY0gor9vlSgFEsU2PBljmSf7rXrz+YFBp+7
         FAIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4rOsP+2FxzK7O/HPJ04skvFM073MNZQX5jyTodbPyPOV6WttwnIhQ9Mg9YuyO+4Ssdxl3C5xxjQ==@kvack.org
X-Gm-Message-State: AOJu0YxwFUvoe7hxWy7XzeAebvPhLb3BtZBnK49QzS13R+KSo/rCJgAW
	K5ALsPHsYVMs00tlIB5L1z9hvp2dcRVhnMTRlxsERwxc1te1uJ1kDrHJzgDB1UqXdwkLy+JUr6H
	X/pZBg3hd1ReOG5GAvpaBvMeY1rckwJFiAN+BIJL226Jkfi4P4+4P
X-Gm-Gg: ASbGncssudD8HYrJ6bRTV/7I7RInuK5p71g9d1bbTUN5yFfE0FoCLLNn9YirSvrJzVQ
	FLgN71djLUQHrdw4kMpH3O0bRuRkbKswRcI0FH/KMIablsLfD4W+O1vEvBvmnUxtVxbbCYkA6kI
	oaFq+rS3Y8aTL7W0gTht29VcaoVWIhxLYwUQLbNbrW8tw7oXgMFZiASzfRn5UcZZWIlzMQ3vw56
	05G71ldsPoZ7lwhWi5XbySm+5t5rUp8aRdcYlzSrdo4F/+EVk+ykXpff0XESNKJL9NmxO8wS7xJ
	TI6Bnq5PHRBpqpUVdpoIbaIDsOExKAaeGStFCCqKKe4BDxKfE+63SanEEyePXYQi3byUqZ6zBSq
	gVURBO3pdJmR5BjUkhOiY9m8yvTAOmUA23F33qGuCLGxLHdpU234bqS0CKGXmoYYAgcg=
X-Received: by 2002:a05:600c:3596:b0:445:1984:2479 with SMTP id 5b1f17b1804b1-4562e031df5mr212332625e9.5.1753195235942;
        Tue, 22 Jul 2025 07:40:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECMtNli8iBCH8Jdtpg8WMwaAxwFDlddcCQOBvhQ52M/6+c870zweXxX/J/td5+Uj+75e/P8Q==
X-Received: by 2002:a05:600c:3596:b0:445:1984:2479 with SMTP id 5b1f17b1804b1-4562e031df5mr212331795e9.5.1753195235265;
        Tue, 22 Jul 2025 07:40:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b73fa43sm131117765e9.21.2025.07.22.07.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 07:40:34 -0700 (PDT)
Message-ID: <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
Date: Tue, 22 Jul 2025 16:40:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
To: Shivank Garg <shivankg@amd.com>, seanjc@google.com, vbabka@suse.cz,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-2-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fu49Dn-9HkZdlW-aL6l-95VCRoSNX1qNS8KQwcfSVbg_1753195236
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDB3A1A0005
X-Stat-Signature: r1wob85pdggu5ii4bxgorqoyzf7gtu9p
X-HE-Tag: 1753195246-375596
X-HE-Meta: U2FsdGVkX193V45t1tyEuDZyYoqvgOiev7fBEMDAoabWeBiE35gHMzoO/DSy0ffFxHMQHbodPWs9jW3BQLXWI3evBQluXRmnmooejKMVI2CdzlF8OEKy+znMQsFaoRkeYzBWJG3ejr2OjEzUULzvFd/m1u/DtVY/bUhXIYyZeuj2QtCBvC/SMcWcK2oeBWQimwXBQE+kSj2g282SrKDHp3t9bbL00zeNDbpsVaRSPh9atXhLP0dbgyKnFxMNtU4uWRmWgHPkQsMmzdCSwYLAOp9dxs93mM3GQL3qp1+ti8OW4yvCJqWLcdnrtSc7VIm2/cZa2LGOb+j5KSfHPez/toBFOejnydOooIUzQjppyUdKyQVaD3abZbPgzGGHPYQu4Y25LUkMGGrfBg808mIxcsU0+DikWnnWH38R2vtXmH1I5Glfq0LdcgOLTnXMVcP2pi8vGEgolG4tKiehRzHbaj0JAdkVlIJJDsKpOXPF6OHjL3VVr8UyE/Ryi5W5AT1dTqS/B+RosvQT0IzZTbMnrCy/hij//aUYUKQVXs4nSS76vOmpe10V/2ZV14XtDGhmnzAyxb6FIMGf6t0B+0NN1dGupJs1eM+LtCBro/lMAmaSOAsknI8lqV31dsa9FM+qEQdH9ijvKSrarb8ysBivulT30ovnDvhPnPKPx21Bb1ygexHPiyFKx2CMW2xZCnwM08mbriDjlMMYmesWWjWq0AkT34HtJrIYetrK2ZvVTkJAzCQdfD3Q7P7nnIAs2N5FkpQPo5D1iTCGdyotBcW7/1poyMMnVFKX9GggiYfbQBCEf25WINsFDQtthNuNUdc8U9I/LC8SkjhNFnAnMVJZoOqepxn5GfiKWJhvmB1Rz5r0kwXy8gqqRAwP4WKrNghU0FuOZK6FS69/s4R7uRTN0l5t7menkMJy8XNzMcVe27UvGcFrFdrGnZowiyKi1brBk/jME2pKfaSRNvQA979
 p85j6DPF
 gJ1yXuMMvmZLPlaEEjulH2IbOhr5cKcHaYuuaw7gxBDcMQpROSw3QVlZR24f+pgIqD1z7HFS4LDJPF1gw0nFE7UmGEpUd4SIJmy4h0dNPpTluP4cBT70Ys/peYi5nw1oHyOkwQYk2no2jGYbN2CsdptZ/CvoFvlA9Tg7R/zcfpwvaZJwPzHezzDX/5BYOn18N/LWsNM1VOzOmhH/hbSJgAb5Yo9FsglD4YiHwaFTBcnohXAha1Xu3OC2a8OhOcKv2H/v1VzinkiJ5YxZmbDHikRApr3ZpgrEL8aUc2r95NxzF9EVm25VHeIesY7JcAQ3GgslZiqtnmUu2Di4ZQmQNfZjOSONfPg6SCd9FbAI8M9nI/VcyWDnjpHRzTha7PgG+HIKRKJWk43u3YUpOxct+hyAGlxUbYK9RzbvMv9QEKx3BwI18KxYk4IxkyBd8XbE59W+kU6e/nZrHkfHmUZoOZ3Q3BVgBng9brIqQYwkAKo+qzSzNxvmR/4QASN00jE4IZqhjHUpet0I7pNPag5MzR1/giG54mMgNBnLaHpn64uZfIEMSjFp6zBtkEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.07.25 19:43, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work that
> enabled host-mapping for guest_memfd memory [1].
> 
> == Background ==
> KVM's guest-memfd memory backend currently lacks support for NUMA policy
> enforcement, causing guest memory allocations to be distributed across host
> nodes  according to kernel's default behavior, irrespective of any policy
> specified by the VMM. This limitation arises because conventional userspace
> NUMA control mechanisms like mbind(2) don't work since the memory isn't
> directly mapped to userspace when allocations occur.
> Fuad's work [1] provides the necessary mmap capability, and this series
> leverages it to enable mbind(2).
> 
> == Implementation ==
> 
> This series implements proper NUMA policy support for guest-memfd by:
> 
> 1. Adding mempolicy-aware allocation APIs to the filemap layer.
> 2. Introducing custom inodes (via a dedicated slab-allocated inode cache,
>     kvm_gmem_inode_info) to store NUMA policy and metadata for guest memory.
> 3. Implementing get/set_policy vm_ops in guest_memfd to support NUMA
>     policy.
> 
> With these changes, VMMs can now control guest memory placement by mapping
> guest_memfd file descriptor and using mbind(2) to specify:
> - Policy modes: default, bind, interleave, or preferred
> - Host NUMA nodes: List of target nodes for memory allocation
> 
> These Policies affect only future allocations and do not migrate existing
> memory. This matches mbind(2)'s default behavior which affects only new
> allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL flags (Not
> supported for guest_memfd as it is unmovable by design).
> 
> == Upstream Plan ==
> Phased approach as per David's guest_memfd extension overview [2] and
> community calls [3]:
> 
> Phase 1 (this series):
> 1. Focuses on shared guest_memfd support (non-CoCo VMs).
> 2. Builds on Fuad's host-mapping work.

Just to clarify: this is based on Fuad's stage 1 and should probably still be
tagged "RFC" until stage-1 is finally upstream.

(I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
still feasible looking at the never-ending review)

I'm surprised to see that

commit cbe4134ea4bc493239786220bd69cb8a13493190
Author: Shivank Garg <shivankg@amd.com>
Date:   Fri Jun 20 07:03:30 2025 +0000

     fs: export anon_inode_make_secure_inode() and fix secretmem LSM bypass
     
was merged with the kvm export

	EXPORT_SYMBOL_GPL_FOR_MODULES(anon_inode_make_secure_inode, "kvm");

I thought I commented that this is something to done separately and not really
"fix" material.

Anyhow, good for this series, no need to touch that.

-- 
Cheers,

David / dhildenb


