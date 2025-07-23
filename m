Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5F1C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCA68E0029; Wed, 23 Jul 2025 10:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D3B8E0002; Wed, 23 Jul 2025 10:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E218E0029; Wed, 23 Jul 2025 10:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1AF88E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:46:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E7C1BAE4B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:24 +0000 (UTC)
X-FDA: 83695805088.12.6A075BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04E4A10000C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dzz5oM/+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753281982; a=rsa-sha256;
	cv=none;
	b=CsLF/+u1NrPmEwdupJtq/5RFOZ1vhGin82wnm0GKbTgH+v1bA/yxqo361Q3xnfjuneRt3N
	UIi7urO7haZfu1RXCs7bg2ChFnV+PUfm/7OowJ2+Uv414+U1MFPuVt7NO9jdhaTjqOUIa2
	nFhO/GkugAqsGFS6S4mH7BKDqjEf2WY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dzz5oM/+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753281982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQGgiEKZ9BLW6U6k5xk1iAQnETQ+XftQ9J9xgQIohlk=;
	b=wh4sqlbojVOrbSz1d1BRKpfN/TI3RtUAtv0r/G6bk8XtmFNH7OzMc/noOHq7MoVeeaEXNd
	bPZ7zH+wRC5GiGzctUsNXZEk2JCpnlCqjDcbKe9+ArbFOojU9RbbPcQdfiVLymKAA2+HEm
	SaUFfNJFzMIgoiE/PufwPUPvNg6EEok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753281981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CQGgiEKZ9BLW6U6k5xk1iAQnETQ+XftQ9J9xgQIohlk=;
	b=dzz5oM/+V7X+IVJRY4lc8xiKmacNgCF83lt7amG3LlxN2Ik54beNLkkgnoWmyIcGAVQtg/
	CTcc01ZN39cUZ5sKu7u0zrIFj2jUupJf39d4X+hCdJqbjBbTBq3lvWNu1bQvepJcxOIUXN
	EdqGOcwqH6x0TjXYuTx7iWn9N79OGaA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-ua4Uf1DbOnmJ9oKRxli1ew-1; Wed, 23 Jul 2025 10:46:19 -0400
X-MC-Unique: ua4Uf1DbOnmJ9oKRxli1ew-1
X-Mimecast-MFC-AGG-ID: ua4Uf1DbOnmJ9oKRxli1ew_1753281978
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso111175e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281978; x=1753886778;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CQGgiEKZ9BLW6U6k5xk1iAQnETQ+XftQ9J9xgQIohlk=;
        b=CAtdTq8PPczZ7AGgNALmSyeL06Bib+sgX41fMQJ7wClcrsREJASlYuUZ8G8c8u491B
         LErhHeJk6TpqoNDEEP88n1PkY3/R9YkxmPFtkM871DyjzNKMjMrnCEhBPRDqfaynRSyz
         btFODtQGY0AvzCn7X/BE+nk8uCB6hOeB0lxqMWiXyVcXNLWw4ZrTnRTW3qGFbt2RIiJn
         cc0qb88xmq1ZVB+EYWqRomSIGBHrUCW303cBDNm/WkBreBG+Kf/QN6kz8s+lehaiXtlI
         KH0uL7R+0wcwYsbEIx8tT70pFW3leR+WILCRCWg3pGJAojviLIYqDbvSs3pdnvxKljOP
         q4Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUE6t7a0Haci2DayBFZOBzWCdVVKjKx6IaNlpUlhsWUKVTyTFgx5ZqUJy7z4Ymo2obIVUCK4KEKCg==@kvack.org
X-Gm-Message-State: AOJu0Yznz7QdFP4wYJW+9+yWrpWwKHtYO4OCPPPJqPA9EvIWIJ5qPX+6
	ODtTazOwwcq1v1F/Fb8x9jtVLl+2Yg2SDAZtCif5/JYVRLGMIwQQAMiNXbsuCQzqKEV7gm62OLE
	GWUn9RjIHtwfpYi4ewyoBnwKz5crlxSvsSmBs0yUyo5x1rQd7aAy8
X-Gm-Gg: ASbGncv8ExJM6k8Iu/s+CLAjc6PVQ45qqIFwHbj2yaOFqg9pGd5CNhz7YbpUB9PRYLE
	o4rfQDMk30PUmWa6TXIH3JAIF7DRuyrQRTrXbDkktlOpSgIpZlatKnJyHM127wTfWEpDETmsLf1
	jdR8gK6O0okGLAeSGQdzUcWPxf/Ln2mcYwnIWqFLvTMlgnbJwN5uUKRq7RVc7/i9UVcjk9HGNmB
	arbz+zHgALYkhXgAQq5irwR7etjd5+ZBON31Z92ygyFwbUuTADE/nQb+b303TVF+ti1uj0lS+iV
	pV8Caj9D+XG6Eb8I+G+MLWYtPcKiUi5u72UV6gnwpk6X+XGiGkew0j4EqdMvGYPfUnM/xteOFPv
	Tnete4py1iTdm3fHocwhv9jDvDCFFoPvS1QbyH1sN/KkuYc2qMSYtM/hk9/hFeQBMyrw=
X-Received: by 2002:a05:600c:8b71:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-45868b44016mr26972975e9.12.1753281977805;
        Wed, 23 Jul 2025 07:46:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1KNSe2SVxUroDZ225ZV5Nc1b5biPHfGPJZG9qryQi+RFiYP2ispLZdQ4B+jpEa22Ey3+fGQ==
X-Received: by 2002:a05:600c:8b71:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-45868b44016mr26972145e9.12.1753281977097;
        Wed, 23 Jul 2025 07:46:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691b0f59sm25842795e9.29.2025.07.23.07.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 07:46:16 -0700 (PDT)
Message-ID: <3d310152-34dd-4e44-92e8-a4e94c6480ad@redhat.com>
Date: Wed, 23 Jul 2025 16:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com>
 <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com>
 <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com>
 <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com>
 <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
 <aID1JoOGRZ8HIkc9@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aID1JoOGRZ8HIkc9@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xw1vs5Ju3z7hdjB0R8Bb4wX9ytRWIdnRDS3Q4Tip06A_1753281978
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04E4A10000C
X-Stat-Signature: pdyk4nsse7zyndqo1jr9wqu68muqq6bp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753281981-987582
X-HE-Meta: U2FsdGVkX1+kUCTmzLoSMM8mjmgEIMRl/rch+dEzkQVLHa16fu1NaABdXcw1KGjZIZH1hiJ74bMo78yROEUOPoFf/dkwvF7D6gupF3wceJDmfgGULoXmmxww+xk3jHq46ViJDy2DIM8N/nH+d31ew84NjPyOScDGZ6SJClduqZwHiRhLkWJuYv9KdNwmTaEh75Z01hjOqewW+UajLfL9l4GB2dMaHJvZUvYxZ9L7dibpDMK3Qn65LU2CC3Tk6KFKQcVBtEuN+6YHrJxuUAgz1G8y1Zld+FaF+ZMoy3R7lNBcNnjeyjyfGdKPX8JGn2G2z4EbVUYI7sgwGxj/+BdEqe7easkjhsvIBeDgkIL5brdS0NdVeYjK4sb094Y+O3r0pMnvYae5Ng8oAU98IO6UzpoA0JkrmDNJjY2+VKDpUCClgAfxVxQqtZp0AkuBBZ/TM7nnKiogS8Ua70AUWM+fpEwvPb1hgakQ0fj1fQHhMeY2EBwZw0hjTVU+NfBiQWEvak9RFDZS+27M5cHiRexPMMZGt+Gp2ph0PQq6V3IdN3tDXXZlVr2aHaxs3pO9FnI1ojFiqBWXetBVQ97DvqIggD4e4i+tHApbX8SRcIxu9d0lpynyvnpuML5UrTkN6IW9BOb2CHGbc+vRbohIre5ozGCvDX7tozBwiZ3QOvhxhi7XC/7YJOr011C7R12RKPCqHt7s5W9N+epkA/GGYBIKt9ZT42pJ952NnfMGGWqw4dLlep4mm1iCxxVDjd3hCJh8b/PQ3FWMSVMrcTiyvW6eocB1iCgner+z1rZTveyLAGG8RlsNv4wIgxB6ifjgvnP/w5A5v15D4thfVhMUelU+e/ndSHsGgO/+ps9ryK/eY4aIa+upivysdVibfV2OfN8+rAY5DDZS6tgfZ+pK8bOy1fke5DvABhma84nc88agPKFhG4DKrFuJE4Sh4ns0w6B6MaLzJ+O1DenMJZxA49Q
 VeEe4WZz
 FpHIzWydY6kctTONU7KwMJDDWd6VPnNjCkBioygmKd+PbxiE3df2Ybd4MWeJtr0SIWC94zEW26EmkHQv42odI6KlyHh1GVpzxySgDAaivq+oU+gVwiEu85j8QrFc0pHQ0XxmyAyqJgfYRABc7TdxlVzwwnMNEiP8leLE2KJfN0cFDcZ7RtDuKAI5l7VH/vXGwN9712A+ZyBYHmc0/Kv3p7H/OGAjAaK8kz5/W+d4pPQPagrwIxfRlWxryxMR6RGsd93nQZ/mhtI5n9IQU3POHjPpNcFGTy0phOoxJzLBW2ZFdJhya2XoGV7frEQIbnXxVqNvd/KzZ/j6TgWjwe7Ne+5e2vesul7iI3xUZVgDrAKBmlwjqRcOm4l6QQ6uz+F8g6JzN0sc92bdwuW/h7OIMEQofcSwHw26o7uyQihdsNh3afGwPJtdKz41+Z86u3TY/s7xZ7ZUQZiDJ0+N3/8b9wJ76z3kBpHLETyvLwWOkmkqAwSEivVGtYLR0F6jkLIY4acgBzi824dZANQsqOpr4btzfhCIzt2zP0zFPZXWEHyOQLMc7aCNtYAqb2eOje7q4SD00EShkBZnAnV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 16:43, Sean Christopherson wrote:
> On Wed, Jul 23, 2025, Vishal Annapurve wrote:
>> 2) Userspace brings a mappable guest_memfd to back guest private
>> memory (passed as guest_memfd field in the
>> KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
>> faults via guest_memfd so if userspace brings in VMAs that point to
>> different physical memory then there would be a discrepancy between
>> what guest and userspace/KVM (going through HVAs) sees for shared
>> memory ranges. I am not sure if KVM needs to enforce anything here,
> 
> We agreed (I think in a guest_memfd call?) that KVM won't enforce anything,
Right. We'll document it but not sanity check it at KVM slot creation 
time. If the VMM does something stupid, not our problem.

-- 
Cheers,

David / dhildenb


