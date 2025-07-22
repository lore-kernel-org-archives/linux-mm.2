Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A40C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A229F6B0088; Tue, 22 Jul 2025 11:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA5C6B008C; Tue, 22 Jul 2025 11:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E98F6B0089; Tue, 22 Jul 2025 11:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC208E0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:50:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49EAA140463
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:50:53 +0000 (UTC)
X-FDA: 83692338786.13.D6703D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C906CA0008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:50:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZEEiVkRe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753199450; a=rsa-sha256;
	cv=none;
	b=TVrnJ4R3L//nRzcLcED3lf8mHwb9DhV7ZX0gaWLKxS9/BT/zRzLC7ZAzKBOOm280t0s4Wy
	YcDnAnnh2tHleU5XwExfII2N87ivqNkGoz7gSYDYrmdao+VVBynJ4T3y4Sd5TaLouj/2d3
	A72mZl1vPzHZtRcsHdtnMTWKXmMiaDs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZEEiVkRe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753199450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d39bdqnItomRQBDSV5BhuZCnSF482IcxM6Ke6+QbMc=;
	b=2+3acEDIx2uGCR7wCBDOP+vJOAn75klmcmN0e/Co7kQSXpDabypOc3JHD0oBNUIfoC2RHT
	8Nt2PctrpgsUWHUbbrsk3oHHHYHPCqXpuQEfQxkOV7U182pcIvXsl33Y4BQwMGRRQP6ITv
	j2ME6IIF+/20oeWRECJCv4W2X8+tJqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753199450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1d39bdqnItomRQBDSV5BhuZCnSF482IcxM6Ke6+QbMc=;
	b=ZEEiVkReRFg5Oy2GLoqlHmAvLQ7uvznVOkzffkiS0LEvFqoTTWSQ80XGXagBZwPKrUODod
	x/mOk2v/MQtmiY5kQkZMQbcDnwhFaPQ0V+QCg2PQ/EJpNUab6YYWC+vBjwVL8CHR5Bgh7U
	isGpsdQzUDXVu5LP9+q2CxSrsH62wfs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-2t7O13IiMUStSW6jpanBDg-1; Tue, 22 Jul 2025 11:50:46 -0400
X-MC-Unique: 2t7O13IiMUStSW6jpanBDg-1
X-Mimecast-MFC-AGG-ID: 2t7O13IiMUStSW6jpanBDg_1753199445
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so2182997f8f.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199445; x=1753804245;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1d39bdqnItomRQBDSV5BhuZCnSF482IcxM6Ke6+QbMc=;
        b=htDDdXS1w8YCCLklIUbQjMY5sSP3CUzC7wl84+ISy3fhaqE1erePO+6vjO2yaNwaLP
         RAvMSE1ROV9YjYaq693xUfyj5olOxyOaB1k1Uc6kOqiCJy5ow2OByCp/4GER7z84owDH
         UPsN//qEwOn6N4OLMpyTMcCymnRNU+8jUyzxiUjpUOjdCAID0oVs+YuhfwMXNrrYDA2y
         wV6k+UaAvMXIkbp+wvkEb+4oAsIk0yloVRZGn5RrhREWfDfJh6sIA5aVEZMzYGpBtEWy
         HjArnwSIyH2S6KxFV1Kd/OGuHUrfnHiNvpLKjjMXlDfknW/+9QMUp9D8hby1ei0XGwTu
         Q2dw==
X-Forwarded-Encrypted: i=1; AJvYcCVh/JZMiktWmYRdOxBwDqV0t6eDnljqoqHagvhkBH1zJwpfs+919bGtVfzK0g8MwFiWMziuJx1thA==@kvack.org
X-Gm-Message-State: AOJu0YxgoAMqzDxpDOEjajrQztdtBFhzmsf1O7DfiTcApj8QBviILqvV
	V7GY8I9o75zwg0l1bqGubBIByrwtV/91vQwknmjVyXfVHggbcVnUBWWXqYprh36ZBpyaBQWjPy0
	H7zwOftPyTYhA+2XS5GmPiQCrH/rmyPU9QJshvpkkZscEah38+IS9
X-Gm-Gg: ASbGncsXlxXQBdbNdTE/6QaBeoyHCLfKvb5rm+cDsXpiix5tJRqV2OndnVvdF+xpdhk
	dqCqKYWNQgw6701aFfNzNHvBBdaTeZ7urwkh6q+A5bV4TNXzMVDihNUAFzYn+pG5ZuMqy/fFp78
	UInnhrMAo0djybj+U1LpEcx1tBpGRF+doCxTfVVg6v2PyTk1eqq/QExfTVE4jbKxQmn8nKBHVzp
	xZ120VnIMHJyvfSineTov/xq/yPfQTkNf7JKIJiPT/E33VHmNzeEokUJknEtzkIvTUyxBuUrUIC
	vm4hq8e1Hq0TP5vYLpseEm2ULO7LvMS8XZmhYYOdY3A5UyqdPvheNP1iPTMlq8Kp3W/5C1MkEhm
	MJPEKycPkG4cwLAZNgdumQpHl3hi10kSt6D/Msw7tyRWpBDo1y4TX0NZSSTLkcibROx8=
X-Received: by 2002:a05:6000:985:b0:3a4:ea8f:efe4 with SMTP id ffacd0b85a97d-3b61b0f1bd1mr10419407f8f.18.1753199445449;
        Tue, 22 Jul 2025 08:50:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGm2frdCNOY1aH4JiQzplVhsf9wX7Yke0loRi54J0nEvdnAMQE71SJU05PcYhh7A1tnkUVGXQ==
X-Received: by 2002:a05:6000:985:b0:3a4:ea8f:efe4 with SMTP id ffacd0b85a97d-3b61b0f1bd1mr10419384f8f.18.1753199444899;
        Tue, 22 Jul 2025 08:50:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5d018sm13686920f8f.90.2025.07.22.08.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:50:44 -0700 (PDT)
Message-ID: <e7fee2b0-eb71-4556-a99b-ba9b44491519@redhat.com>
Date: Tue, 22 Jul 2025 17:50:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
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
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com>
 <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fjzRAkX1aVzOfdzpwJga60GQqEF8kFOP67ZeoZJYdsk_1753199445
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C906CA0008
X-Stat-Signature: qx5ue85bg7ch5pxj6n7rajq7so7moed4
X-HE-Tag: 1753199450-452152
X-HE-Meta: U2FsdGVkX19piO3JT3yD4B4D2cNZwtj531PKysPyaGKxYxEFerOqBIP9j4xBIxSRhbKNq67dUgrXi4aybxW4cwTpUmNOGytsnFBtRXsrW2nFADnFJsNtFH2lP4Qw0rXfDSk9KaNsJJCcV9YmnfFa6p37nS79j5An5Nvm5VWoT4nTJUgyplR67MgnG3cpC/oOwa/TisEpYlfyeErL5N2aZ+Opq6mkYqJZLzw0AqeDAdMDe3xZn2vusdk1eIhH4ff6Chm53zpVDzS4RAtcG/dN37RUUyg2hHRCY4LVTcISGOeMEJzwfuXO/ekDJYzEILuJ0VFjkC33pF2ql73hWLN3NlHX+e3UMcnMEfwkLPLaqjZ3/DEtOBA2368eNVHkZfHrI+LgkEwNZgdl+lSu91tCnw/eZtMmlq/CkEFCwZLWRNzaz5pYvs7wH1xX4UxW1sRJrJiy9fUaC4C04ae0sRS7jePnQRq0ZQxgzlZXgBWAWV7+iNZxlkbQrYh7uOAHoCO2mdJkENmzqszNOtzlobbMDtqw+kzSKbkdeWJwsYfj/UPx9VXPRzoP42+K4RiHiAJFeDPR8Dy3ga5D0wVcaUTbi+G6jzn9F1orVtdKG1cSJAHddZEhnasQZBvuQzIlnbOrBG48WMEYdJr6ZFNpDGskVQLf7jo21fl80P7SzFcMrHT5KraKGhtjAACVIeoxgFHohZljYjbp/Le85SjX3v2elpthOOD7xuVH7+MeMiF9FoyohNK/4nz6HHqWIeRxpFf3mQ3NgfqhM6qYXgDr1Vaxhh2MHCRl3mT+jCKAN/AAetq5T0UU5rirpUuBEbnWivMgttI4yVzW23RTJ+GlxxLn9J/ScP3WBwPvu6jR5LJ+U33dP8x2oRspt2JVekAeULNf79eYTsj8v4dkV4GhUHRPAYYa7WwsSA5mXUZx/NJzf6x4DMIzoLON3h+nWFZQQxtTxeECgck8EayGcRDcBA+
 +LBI16R9
 siTQDBI8QnV9L2zvDwKpELm6QmP3zUq5OrPqyI8NeJjF0LWoptzGovYoMAiL/0qh91Ybms4K98OTuHnxLLs7iwJ2/v0HCjEYzxq4Vqs7nBh7EEwoOkot0eoxf/0xgTq5bm4QQtYqrb8eua0hsCLqujLWlqnFkjcZPozpkrxCIuxOq5/Wp0v70FJwX6hGyvlIyNPCNK91dHGsSn5/b3MB1Q9Yj2BogkNJUxs97BQKFG1v7iAxokGdHku73Lr01KrmMXnVpDPMWDHkhq0CByZzfY961Vm5Ir4CEwcZNMXttju7nxYhOlSCgLL5/L2hj9tkj0cdvky4wtRICQLqJ0AM+KxqHONXTz9G/pmr0frbcSU5YI1mEd/DGRzp+OfQ/p1OPfmqG1Ca7awm4JsoP4KmJ4r+fFWuoUOkzCiYBK3iBxtVGWXKFZqSYhPw8Giaqt00V7EgMN9Y4XrqYGl5kHj0x3h+d7BoTXJVtaC98/CkM4UM5id1e00pV9KLrnyluA2WcYbC23ZkAdPozMJPpGSzmAMX3tgtXoAl0b1FJ+DYuZl8B0piFgY/zmBLtXJyl/1IVyw1iPyzPWOaqB5R//mx++Rvo5hQ3bNkQXep9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 17:31, Xiaoyao Li wrote:
> On 7/22/2025 10:37 PM, Sean Christopherson wrote:
>> On Tue, Jul 22, 2025, Xiaoyao Li wrote:
>>> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
>>>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>>>> +/*
>>>>> + * CoCo VMs with hardware support that use guest_memfd only for
>>>>> backing private
>>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
>>>>> enabled.
>>>>> + */
>>>>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>>>>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>>>>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>>>
>>>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>>>
>>>> Actually, QEMU can use gmem with mmap support as the normal memory even
>>>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>>>> on KVM_SET_USER_MEMORY_REGION2.
>>>>
>>>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>>>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>>>> works well for non-coco VMs on x86.
>>>
>>> one more findings.
>>>
>>> I tested with QEMU by creating normal (non-private) memory with mmapable
>>> guest memfd, and enforcily passing the fd of the gmem to struct
>>> kvm_userspace_memory_region2 when QEMU sets up memory region.
>>>
>>> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
>>> region with the same gmem.
>>>
>>> So, the question is do we want to allow the multi-binding for shared-only
>>> gmem?
>>
>> Can you elaborate, maybe with code?  I don't think I fully understand the setup.
> 
> well, I haven't fully sorted it out. Just share what I get so far.
> 
> the problem hit when SMM is enabled (which is enabled by default).
> 
> - The trace of "-machine q35,smm=off":
> 
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000
> size=0x80000000 ua=0x7f57b3fff000 guest_memfd=15
> guest_memfd_offset=0x80000000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000
> size=0x400000 ua=0x7f5840a00000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x2 gpa=0xc0000
> size=0x20000 ua=0x7f5841000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x2 gpa=0xe0000
> size=0x20000 ua=0x7f5840de0000 guest_memfd=-1
> guest_memfd_offset=0x3e0000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000
> size=0x7ff00000 ua=0x7f57340ff000 guest_memfd=15
> guest_memfd_offset=0x100000 ret=0
> 
> - The trace of "-machine q35"
> 
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000
> ua=0x7f8faffff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000
> size=0x80000000 ua=0x7f902ffff000 guest_memfd=15
> guest_memfd_offset=0x80000000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000
> size=0x400000 ua=0x7f90bd000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x4 gpa=0xfeda0000
> size=0x20000 ua=0x7f8fb009f000 guest_memfd=15 guest_memfd_offset=0xa0000
> ret=-22
> qemu-system-x86_64: kvm_set_user_memory_region:
> KVM_SET_USER_MEMORY_REGION2 failed, slot=3, start=0xfeda0000,
> size=0x20000, flags=0x4, guest_memfd=15, guest_memfd_offset=0xa0000:
> Invalid argument
> kvm_set_phys_mem: error registering slot: Invalid argument

Weird. When splitting regions (I think that is what's happening), QEMU 
should first remove the old slots to then insert the new slots.

Otherwise there would be GPA overlaps as well?

-- 
Cheers,

David / dhildenb


