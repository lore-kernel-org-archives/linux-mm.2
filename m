Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67F0F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEF96B0005; Tue, 21 Apr 2026 12:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFE66B0089; Tue, 21 Apr 2026 12:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B511D6B008A; Tue, 21 Apr 2026 12:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD726B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:31:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61BD1160BEF
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:31:12 +0000 (UTC)
X-FDA: 84683102784.01.2F388C9
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A82C2000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:31:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QfNohA8+;
	spf=pass (imf03.hostedemail.com: domain of 3TKbnaQYKCI09vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TKbnaQYKCI09vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776789070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjgkwxA0RLtfuWNBMEJF4TxxPjAXkNJh9XTaeAVjQ5Q=;
	b=XFqs36Lz5+kw8zrgBF8iJNuTfN2ddG0YlMXVy8rxZZtcdgNpJ9yXVNGmr0oEm4qUUWLISA
	U5WfuIX8ikvBBtqFjiPqMZrvbKiYFvAm+UhzJQyN2siKQU/vTBYGoZXd6Bm5gGF1UY/6Ly
	NX93yMmBZNNgPJjP1kcAfnS7Faoq2C0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QfNohA8+;
	spf=pass (imf03.hostedemail.com: domain of 3TKbnaQYKCI09vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TKbnaQYKCI09vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776789070; a=rsa-sha256;
	cv=none;
	b=LsexM06m5GVGwU+H/h9Q738kE5UU+lDAxOTuV8TFaRLdjjkzadDUa20cyxbDujGOYRJvo8
	wbZJyt57lkkMGCniVPjysETlznw+/LJKV9bZMo0ejH8XROkS2Aphq/K+B80rXNfZjiSmWN
	B6sZVGxyYEqMGa6yLPMN0UyPi7XZWFc=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa5ecd760so1848068b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776789069; x=1777393869; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjgkwxA0RLtfuWNBMEJF4TxxPjAXkNJh9XTaeAVjQ5Q=;
        b=QfNohA8+N82osA+D87j+5YBLFJ7LPplPcGgsS6weUl9Lb83IXiEQhWalFQQllTHHQT
         dpt9DYK20jWIgx7RX73Met76sAtA/pPfewcS5xMGIUB5uGw/OI60ByhmF2xO+aCU9phq
         aE1sPoNT2NpDdECTtW/wMQLuLVMr101AxUpgGVOn82CexILVvUfvKsVdpOjbNriCLxJ/
         OknGGfRIt4fRQPz59dPlS3UJUMNhWV0oD3geVHKyRibH79HSlLPHZzmsNDPW2KJ+Y5aS
         /blhu4lqROxHFM64lCl7uT9W4JyP2N2aLIy3YQCLO2zXHlfBq2eyRqf3Y8/kHTGlmLDh
         vSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789069; x=1777393869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjgkwxA0RLtfuWNBMEJF4TxxPjAXkNJh9XTaeAVjQ5Q=;
        b=ocdgCh4FJ29gyAu4zytn8IzUoWVUk+Ps4jBt5eOTufln2cfaESeBnw3tnzNsCxgcQf
         7xgzmJYpUI16gAXMpLui9ktWE16Is6PyvfYSwn2kzgFInpmfDeDr/XjIEsUsVlo5xFRq
         bf3eiRKc7kwVBFdst4EC79o/EdNYcvN09z8FCwoXjSRmHA1bC2rpP2ZGLrOjkvL3uKwj
         BhB2lvuzkDqYEqmM3XPcmgdS1xwo5biP++zRDrcPk9aWlJV4gpC2oi6f99x7YyOaHd8h
         4hPuWrXksbFkdbMMYeTFz2oof00XdHbrh+NqqPfrcHqF2WaHlb35z+mK8p2wFFMqetsG
         9oMg==
X-Forwarded-Encrypted: i=1; AFNElJ8C/N+OD3U33cPcwdWT+XESOa4nd0Ms/5OxfaTEDkxzEhZ5BHB6lYbjm71NlPXB8K2BqBB5SdFt+g==@kvack.org
X-Gm-Message-State: AOJu0YzEyUYn4NKJMjW9wD+0oOqOmjfSTxM6cNl1eZb7B3mVLSQsiiG/
	wA7KluopiepAd/OwM5qakylKxf6LPmDmVMC3lCTTxnwu8/u8Xr4vkbPlCpmCbMz8Ro42Wpv3+qq
	ETlrc6w==
X-Received: from pfbhk7.prod.google.com ([2002:a05:6a00:8787:b0:82f:f2d:5b4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d8d:b0:82c:1cd0:2f5e
 with SMTP id d2e1a72fcca58-82f8c96eb30mr20038023b3a.44.1776789068848; Tue, 21
 Apr 2026 09:31:08 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:31:07 -0700
In-Reply-To: <20260410151746.61150-11-kalyazin@amazon.com>
Mime-Version: 1.0
References: <20260410151746.61150-1-kalyazin@amazon.com> <20260410151746.61150-11-kalyazin@amazon.com>
Message-ID: <aeemS2wm38Cm4qAf@google.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Derek Manwaring <derekmn@amazon.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A82C2000E
X-Stat-Signature: sgqj4jdow9g6bkhhyia339fuoki3fg5a
X-Rspam-User: 
X-HE-Tag: 1776789070-94735
X-HE-Meta: U2FsdGVkX1/yvVqc1s4zV+bouwoiT+2fO3P4SXqscw3f16OgvUWZsFUaoIyocFvsdvE8+raJxcl26TFNseIyqafv/EM5CFMot+PoFwmXBQl3zgl8DIhHnPSvxKbzORuUj3iKazItUvyHZOerdXL28/eO7Sj+3P0sbjIRMP4cnmPBv0JMJSzea6QL/VuZXyMbfWS4fcU30n/6dImABvo1IAicQOOxFEEgJCTlL0a0aE/6yaLISNxlOHaMa2IA6/82A/qdVZ3wepyBXeAjz6+XSv1mXPrMZ99gCoSRTHbH4kBdZlk8cunL1oy9Ojc04Y3HIAMYgmjWYB+TkA/MNOuJJZHrBU3cztzDbXtrDGreLKwF5MEX7evVhnLIjDEkhjNkLDr4mpKNy8Uz1Wyu0V0q/AAEFfCevFMx4w3DAh1XGMFHpwFyXmCJ4oc58KuBQGzjpqOqPiju/mhkZ85z10iCWM7+ROSlyK3eMObCCo3mprhf89BdsyxOiNsQxgsxWVDZtkm0o17vCavgV9UDUPuM5UsjBnF6hV/jXssYt/QV2Zh/KM0XiSw1orjM12IYAawdFF8IjNVRnv63zAw+tGwm5V9KkSrQhrjdpXkEZYZjhmz2uGPg+Tem7xZEb9x4mnM6beJATNZmZGaFh0pfWu/06hriAVjQYUwUlKBWSxosIXDDZkX7W9sS+KSKW2cwqleJI+9OKpDJuS1BkN/NGhgVRZ3ZLQcVXoVpaAOPf2qkCg/+37KYAg9km0gy7fCjnZYWGIpYVgwMlW/Xzw+MC2aaUcKL+mNwZ9SNw4XH85Wn+wmj3cevBRT+v465YgC2DCsfwaKvkhLjNw0uJVp4C5+XNOAB8dwQAJsbxJkOl5IcGHEEbwEfufo1qPh3p7EBXIR4Cv3vk6Bp1fu/TB2bJ4povhmMgR5FNA032QltVh/+FbUHHifZ08Kij53eHjAFmaqJBf0cdYNJFBlXFW1dmrg
 MJCc8I6V
 FbiH/T38j/nVoBEcjvyLFzfelZGQTqXiAeVddLA3JNkRCSGzYlFBHA2ZdoxKlmDRrDqHwz9ZwinTidFVIedHUYkI3kICl4GgOOsP+SMAuRAKbUVeB9JU5UL97n6hQIaC2IB3onD7Pp29DutdGtV3FtM1hhmk/3ng5GsZNUDw41+35l/jbGHmB3UTletQWOiqEMrQYIFtEUukM4a4jmy/2HkZ7XMekWphzIbNtc2zJ5B+YzaNviD+TtXfE4yPOudcCSYTlcqYVX+ZbTSyWPN6TAQDrq3ZVezcV2lbSZh3MKyg7nhznk8+DvRh3aH3ZLAExzaWwsEirUqycwm/UToC3LJCFxrqvB/Sm3nYDgRUtaiItHfRti34f2mTCtc8T2dM6tNpTSHBFjxARQWtJ7HZ3TXnZrCxq5GPcz7f0cJN/eCI8xHgw1KaptycphHfuPSmLxhpfsQcMuXEmg0KxbfQy0vALzJefEw4o5BgIa15GWgJDXnSgEGhVajI7WtHaiTmHM4nXrNUbvF08Ur1gzmqaUCKPQr07dimHk6YeqHA3VJ9w6RxCNhxuCJwtsgS0N1lidi1V8iSjZgF9m5TKeCK/moroqE8+o8LgzMWByCVZowxReoIRIUVxhItsqlHhPlhLoXkjET5F3Gmom4bGe1vweDhLnklTHeqBdqX9aNIc065ThuerWGnmE1ahBXHT4Kk/lBrYsTNyhpYl1d0PyNFA0FqJnWNqtc0WOsJPIh/Hj452srJfCnYq+0EzATPiiMGfzL/PCfoQc/hDNRoFXtRnXn2tijHIH3YYVZ/EE26sE60Fy4VzgFfAjpu8p/S6Fc/7ZRJH8atIGi4TvxDBjljkP0ggXoUGQbEsUBT4fr6whp1pjViLAvme5bi7ja1qi98XT+BJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026, Nikita Kalyazin wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Direct map entries are zapped right before guest or userspace mappings
> of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> kvm_gmem_get_pfn() [called from the KVM MMU code].

...

> +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> +
> +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> +{
> +	return ((u64)folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> +}
> +
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	int r = 0;
> +
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (WARN_ON_ONCE(!(GMEM_I(folio_inode(folio))->flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)))
> +		return -EINVAL;
> +
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		goto out;
> +
> +	r = folio_zap_direct_map(folio);
> +	if (!r)
> +		folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +
> +out:
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{
> +	folio_restore_direct_map(folio);
> +	folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +}

Making guest_memfd responsible for zapping and restoring the direct map on a per-
folio basis feels wrong given the addition of AS_NO_DIRECT_MAP.  I especially don't
like that the "rules" for when an AS_NO_DIRECT_MAP folio has a direct map will vary
based on the owner, and even within an owner (e.g. guest_memfd) will be ad hoc.

E.g. as per the series to add guest_memfd write() support[*]:

  When direct map removal is implemented [2]
   - write() will not be allowed to access pages that have already
     been removed from direct map
   - on completion, write() will remove the populated pages from
     direct map

That's pretty gross ABI, because with KVM_GMEM_FOLIO_NO_DIRECT_MAP, userspace can
write() exactly once.  To re-write memory, I assume userspace would need to do a
PUNCH_HOLE or truncate.

What's preventing us from handling this automagically in e.g. filemap_add_folio()
and filemap_remove_folio()?  Then the usage rules are pretty straightforward: the
kernel must *always* assume the direct map is invalid for folios from
AS_NO_DIRECT_MAP mappings.

Then if KVM needs to utilize a kernel mapping, e.g. in kvm_gmem_populate(), KVM
could use dedicated variants of kmap_local_xxx() to deal with a local mapping for
a folio/page without a direct map.  Or, KVM could simply disallow the specific
sequence that would require KVM to do the memcpy (I'm pretty sure we can do that
with in-place shared=>private conversion support).

I realize that could throw a big wrench into write() performance, but IMO, before
merging either series, we need a complete story for exactly how this will all fit
together, in a maintainable fashion and with sane ABI.

[*] https://lore.kernel.org/all/20251114151828.98165-1-kalyazin@amazon.com

