Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80A1C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428456B0096; Tue, 22 Jul 2025 11:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8BF6B0098; Tue, 22 Jul 2025 11:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A06A6B009B; Tue, 22 Jul 2025 11:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 143286B0096
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:24:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A71CC58F79
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:24:19 +0000 (UTC)
X-FDA: 83692271838.19.2DB1265
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 199B41C000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:24:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GSlpTl+G;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rx5E9H0SC0/ybWC8xu2y/OKAH1d8PpGj5fdVT0GTL0Q=;
	b=uNRiTYx/mrdDRGSUFuuu9LVmVJkeHUpc0bolhRrX+XvWCObl9BPUwxCH6uQ8/FFD9giriE
	LtTnw07WONGH+9OlHBm4LAMuu2nEXZVli045m7oRRFW/V5mLu1sVaK8jOVyDlzyQU3E0/1
	Zf+6L6jjOhpIGL06dCqpd+MxIpSQFdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197857; a=rsa-sha256;
	cv=none;
	b=5MYHW+iOAe5YUK84yp6LvHQZGIiVZAed5u8cLuDzJs+OScgHuOx1Ccp9GqMWF5ZEtyhdTv
	gZ02c8247C40RPGaTkjrVMUY/XTWedZJOL5B5y3kHi9JKpeXxbu0WKRH2nCly4aTBwbVsh
	dJ448YFN9TQC/Wrw5r6KBpwmuZEhAuY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GSlpTl+G;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753197855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rx5E9H0SC0/ybWC8xu2y/OKAH1d8PpGj5fdVT0GTL0Q=;
	b=GSlpTl+GMcYURyT2A7TkIl5jv0Urv2KBx7GdYDdqJtcjLapVylfedUYBH1Fgr2c/7I7j7T
	GP2qztsKhB07vG94IaveZhpe95t8gQBBgcruJviyVIsWHkhwLH7Vaq6QPgrX1A7nLvFhH4
	S4RkC0CP+qNDUcS9AG02hofgLaan/G0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-u4eQ9MtAMVqDyGzFRAherg-1; Tue, 22 Jul 2025 11:24:12 -0400
X-MC-Unique: u4eQ9MtAMVqDyGzFRAherg-1
X-Mimecast-MFC-AGG-ID: u4eQ9MtAMVqDyGzFRAherg_1753197850
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-456175dba68so45235845e9.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197850; x=1753802650;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Rx5E9H0SC0/ybWC8xu2y/OKAH1d8PpGj5fdVT0GTL0Q=;
        b=NGijaqo3/qMKQdEbxfPKPE41eu8Cz8Js96qj1sDeqo/ywpOJLeIK0TnPbf33qnxGS8
         wBVC/zAbutcEDs4+qGpBjsVCCGuoWj06CUvA6W6ILKRsfWWIQ1YYkPr7mLIx/KhRUHRB
         6nF/GGqRaARV5Af7BIxWSONNY106TGZZoHn9tJnBJwjtRXJNhU5u6OXh2avnPjaIMV74
         Q9xbk/G/7gXWADgPXE+m0HL5GZ7cwuTJGy3x56EKF088IzxQ/UxBLV3YE0LdJVhSQIRK
         YRPrNnbJP6fLinNQC9A5joaT2APVy0SGxrCdVGG7sSaDodb5xqq93llUOEIn+qMT3EcR
         H4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlzbmUetMqLH0XeQRq2tSmYwFUXkSR3Vky580rt6HwZNAxd/eBgBgeHQoudKTvv0y+Rs7kcJoYSw==@kvack.org
X-Gm-Message-State: AOJu0YyvqTJvViRmEuYGJLisXtNftkFry4bI9oXekmBALiUm0lKFyu4w
	QNFXfUrWhj056YVkOV/sZE9I7iqR2CKwU6fVTSC9R0uc8RpvBKw/guny7/F4i2ABkmFcS4rauEY
	BDEFPGT9RRnR0+lmxFueJvWoFlPsCOVIlUJBQEZH8K21OZEkHuO7v
X-Gm-Gg: ASbGncuU5JOqZ7dD4m5rvG8kZhQ24HYhrnG791/45npSKhX+AR8VKfiJUV2sXDI8rIr
	cyECk1QHwUUExOnmxoYDl6CfG4IYXCLGPGuz6lsyMwRYRx3zKyxmYtZjpiAJtGZ3mNcTwimSvP7
	Hnc8aNsjzLJdeoRwzEQRUYhRCELsXg0RsGOSCvZAv+Ev7zAG1MZQBIK5dU9eSgjR544Z44XZ+Ci
	M48BqVWkGjKHki7dmJlmXvzHwZ3UkZquOKg7NxgUVDoMe0Ht0h6GlXfriFnhIsqB2o1RLFo9PHJ
	Kq09yYJ7NCXlyEQpvcpIuZWhX12+ujXwVI9GxwUjT2LS7oFuxU+4fZtdFgCgRBwFkuaiRjgHuwl
	f+7Ckg3KkQdC/JxXGicjlojRzhgIiwMbCpMZk/ZxOjNAy5f+tLtTF3zPwvb5TxjImp94=
X-Received: by 2002:a05:600c:468b:b0:456:2419:dc05 with SMTP id 5b1f17b1804b1-4562e33db7fmr263466385e9.12.1753197850355;
        Tue, 22 Jul 2025 08:24:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOsjO7fjOeuKEDb3sg67N0CFru6e9rNRczL4vElOqdWtp9KxYPog3BjoVMTfLEZMaSXLXdOA==
X-Received: by 2002:a05:600c:468b:b0:456:2419:dc05 with SMTP id 5b1f17b1804b1-4562e33db7fmr263465705e9.12.1753197849746;
        Tue, 22 Jul 2025 08:24:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b73f76esm131398455e9.18.2025.07.22.08.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:24:09 -0700 (PDT)
Message-ID: <e7573f7d-971e-491a-930d-fccb16274224@redhat.com>
Date: Tue, 22 Jul 2025 17:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 6/7] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
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
 <20250713174339.13981-9-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-9-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XHzbxBpbaQtquZQqBCQoAPYT4wgJ9z7w2gcET7MRRiw_1753197850
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 199B41C000D
X-Stat-Signature: z78uhd9sqmd1pexa56rb8ot54dcf3kii
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753197856-217997
X-HE-Meta: U2FsdGVkX19X4Bxnu9iKirlu+VUPw1LaYs9FvKYyD5i2NSF0PCK/RoQBvasGbIkitXODjWnAfkQwh/J5rW9qnKVKUue3S/DzL14YK6k80NCwEhIlhS66IbTK9o5VhnkbwYU2F4molMVOXWshSJn51utDCiFmA1Xcz3HHEqiGJ6VhflqUcgEWDPDW6Tn1iHCh4GB2SNKTVzGQK0J4WsVj3ohXyNUU5I5JTD6DAVmdVjy2y6nQF150Q8yzlprlOYhH4iWmSJ31dhwosoYfBFEUYSkRe80EkgRfSHSEZospYt4tWefVP61bn0XJ69D3KDnl4HFPAtlAzbv5ol+Hikt5kMbdKTprfl5YApFTwZHkUloDFFJEHeK55KXvguyZ+h9+kdPqBTnzPSbla4ZT52LtRRmLSkKAgtB60mgsgoGcemvPTzpaiuxEsuebbHKWWR0jIO3ULLt+TljiBQIFMVAQ71sCaX++Z0755hYyVWe+QJKDjFRGZw4s6GPeg9FLXmDNPpoNLRRIJnCT/rH8LM/vD6HRLd2VoKmpTut67deXS11iEYdMdzxa/m9sNt+rgdYHdGoL0yX7JQsdcogBOoIQSPIb5gu2BIDMrNZu7kj5cQAY8w3iYVENosOcAQ3uG/oqjrW6EwYbT0vv+8qS22lX39zBr70SLzqqFJ2hQseStXWmSiQi04QxEucIobFCaWTX6HylP9edsGsJ1OLH+KFnTfDM4wPdGKwBCuPovCpHH6XoOdxFwgBZKmna4JNxFt14LSB2mKCE2tA30YrFzoRM+8fiSRucHXJG2Ho0cKzf4cUkLlH4b834+K6Q74f9GpE9eXWv8UsZNambAQtbagmA9TgLeF7kHhhWI33BqkQBzbt59fIbo/+ESeHX735+XPM26+pz1fv+wJopZGlhdUzYxKr8/NFtHspht+I0Gzlg5DBsicOg75Rv0t1U6pw45wnemWfM+BPz3/Zljo0rXdv
 R5OkYtGR
 19jemz4UV84IGd9fxit1Cyq1T0q/hr6raHUkaqyYcC02H1fDI1rCG/suhkD1B5ZmicXK+ZPWbKKdmCGJGimqZBuiVCZd8R1Gql0YM86upBL30RSJ/7u7dCsg0ugcNeA/4EDQsLJraOmYDtdDysKSLNjNZ6RGRvcjlGKKVD2XlwONSrV1zb6mVQuWADbKz8nDd5yXBweH7L7b5EZHRGZhNCGP06CkJJfnC7px4sB/XBelSWFEJvjGvZmk2ixs/G/9F1qrvCfV0B8WTG1sSE+ODLNe6EQxjkjJzz6okE6ucgQScsqnMUKNOop7SyH9gI9PEMOoYRU+rnblqBIINZ29/M9+0SFdV+ajSq8keOPeydhA0/jHghqF/EY+0/Bsjk+52u0qshS+pSJ/8heY+4b0ZByrR1F5g2s1SxFhUvvcbPodidfjd1I24kRaqbm84s4CSs9N1Koo2n8ZejeFnBp5QrlZrIxJ20bWTP8obW/bX4yHON6/Q3ARlGjH4FUzzMfqksu1RcZlGqlUif5IfR7fP04CywNPmOOt02G0XGtnXVl+Zh5IJ479TBGQdDoX5/CgB7u0GHEbS7sHjGOWaDJ9f0qvEQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.07.25 19:43, Shivank Garg wrote:
> Previously, guest-memfd allocations followed local NUMA node id in absence
> of process mempolicy, resulting in arbitrary memory allocation.
> Moreover, mbind() couldn't be used  by the VMM as guest memory wasn't
> mapped into userspace when allocation occurred.
> 
> Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
> operation. This allows the VMM to map the memory and use mbind() to set the
> desired NUMA policy. The policy is stored in the inode structure via
> kvm_gmem_inode_info, as memory policy is a property of the memory (struct
> inode) itself. The policy is then retrieved via mpol_shared_policy_lookup()
> and passed to filemap_grab_folio_mpol() to ensure that allocations follow
> the specified memory policy.
> 
> This enables the VMM to control guest memory NUMA placement by calling
> mbind() on the mapped memory regions, providing fine-grained control over
> guest memory allocation across NUMA nodes.
> 
> The policy change only affect future allocations and does not migrate
> existing memory. This matches mbind(2)'s default behavior which affects
> only new allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL
> flags, which are not supported for guest_memfd as it is unmovable.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


