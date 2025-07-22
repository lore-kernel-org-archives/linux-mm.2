Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F26C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A146B00A9; Tue, 22 Jul 2025 10:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A717C6B00AA; Tue, 22 Jul 2025 10:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987966B00AB; Tue, 22 Jul 2025 10:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88D916B00A9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:28:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AAA5B89FF
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:28:28 +0000 (UTC)
X-FDA: 83692131096.12.8A3780B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3ED6410000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:28:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BAjCveCT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194506; a=rsa-sha256;
	cv=none;
	b=VUPKCh7fLt/KjHCjH+0PWd00bfmhoSJbEYa/K93IK5XK20NbxT3HdkhpYTi+NM6aiMAAaO
	cK6EpY95cUaG7cIgwf48rQLKfDn0jc5JopM7UHdLpNia+dcxMIHCtBgZvOx3IodNf1N0Nx
	QO20TvGYiMLBG2Nbtql6pTiYJnXxocw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BAjCveCT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNPU8c8beemVTbgRqwMWW8DR9+SjGj585iJkI75Tkao=;
	b=xCtx5vm1TAT9yQvTgU0k1FNrifIJPvO8A6deFtB3sq+b97b2hxKNA1E5rJNmONtqEm2HV3
	J2zfPVahaG7/ZePvPuBZWFONG0k7luHSXUzET0sVomWF4H8uKgOFVYfCKI6NSlQ+rZsdWv
	cAUabDeUQlMEvC3M0CKFEsWF+2ronnY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753194505; x=1784730505;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=CMfdm9bpoW6wxCW8WngkMggnv8KINp/BSbU+OViMmvQ=;
  b=BAjCveCT6k9LQvSR10NaptBLu/luKyuqc/9OqbczRiPiyjRLbE4s0FUj
   xfXI/Sv3bEfLcvv7LQshQqu+AxJpo4s+pWUxcUBp8BJ9+oMkZP1NS1tS4
   +DlNS4NBDyu3rn1/BqvWNuXiWQqA/WE/WL4ABSE88t+VGCjKJNV4l30ib
   YNRO34aOrgip5FVHTAMK3uRJcgPSkI+xSGgfdWsn9SE2iXlOib+1wnpat
   cus+27NMcvjXHCr3rbfv8o0psKCY9XXIKboYQ+J/9464His+iR5vs3OTH
   E8YWI6c1zPgH4RkWk0ZnY8Q8iQAaUuYg++7s1zBMNH5Gyh+qeyGqxspb+
   w==;
X-CSE-ConnectionGUID: Naf0QVKFTayZhIBcGmWmYQ==
X-CSE-MsgGUID: NROlBR6kQziHMRgFbyDK9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="65709126"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="65709126"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:28:23 -0700
X-CSE-ConnectionGUID: 5acaJGK5Tm2vQvo6sRx0lQ==
X-CSE-MsgGUID: MJKyMwlDRwWPoO8Bms4RAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="158827953"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:28:09 -0700
Message-ID: <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Date: Tue, 22 Jul 2025 22:28:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
Content-Language: en-US
In-Reply-To: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3ED6410000B
X-Stat-Signature: raw5pprx3fm1gwfi147us3kp9poif491
X-HE-Tag: 1753194505-798490
X-HE-Meta: U2FsdGVkX19FHGmK7dOd/CL6poBiH9ORVCBOLQQdaRQMlsi1a0JDAUnY8piW531WIHuL58BeSIkDn7+vkO0AtUNW4AQ5h/5HQkdJbfl+z+Hsb54AsSgkAWNwosf5hR1gGzkpxZVIBbMxxYlycXUlPzn4RRvk+Gx0wLM8IRh6Q9o/eMazxBgFe0jEbRQ5UWOOfpx8EpJoiGPeG7t4MCS1Z1MyS8pHZC/fWqmHkExCLdPl4wm3YZ806FXwYuwNwG0/XNDDJIxZXOrH85prEKXONll/MBPCHw6Mzlg5jjIt7lf2WymQzK2pW+Jc2DQzUhD/1PmXcdSCyEYA0jkc4ZCZPeCzBLmo1Wd5R82yvokpp9nOiOCYS5+A5WBcLB7ReK8s9eE3znGFJA5EjqKNi8cYyT8LmTdAnRzEuJGQblwqDdHmEJQbApz+p/wXeB4Pjh50hzbK8fY/47+IRsJ6ZPagr/pbqZljIfu4BEs8D7CBOybOzrpOXc3GcGU/MhodDoOVnzda1GkUkDG6b/mdN2CWlVtnc54IGbMZ6FPnZet4s30hvyHqeVNcHqGFmjFEB7TWLzSTYTdOs70UiJLs/xP0kHEpbsX+CPNQPE/ma/e9SNb7RdwaNUT6SRnCOjVHp44tY8GkZ1F1opoMOx0dbn+4H2gZ7PTjxOMVUkdp02GIBkKhLJcEru2nM9rHAHgom5vTVtp1/HiJvpcVEeEpVJ0l6fUSf1tyOyYuOrdwgGcKoXHH6b/6qdobyRis8nuV9wpKOqp+94BxeZJizUYXZANmGB8eUhRUz2J7uCQkEteQl+G/q3Zc9MnF13qZzkZ9XQft1p7ocaeJTBYegkAlAvMmWJQm85rlcAWRuMe77t0SddHfwUeTj4kcD+WzabviMipOg4GJVu6QJl0jIX+beLx5QstiCb5FTG2HREW+Jxl4bIR4ssrYPY7PdOYZxSxGRWDmaqSpx+KI+AAsFfiJs6k
 NM38URsn
 ZXGO3KekSIMKoM7yI9S7dvB0kgrO162rbah+jLbeAQZGGZCCr9cyiqrjTkKz5YphX9yf/zD9YaeMWSw2g3Iv8qzZsWVXNRdADHDqW7pX3BeqGIzxQ56GSLiVB+zKfXrD2W6t7f8OVp/eMRrEl2OO/35mMd+3VbUF+GRAEsepBLpRmwz/sguIzNuSJM+2rjqlSgLplUewINRP5x8RZxncZJmDrxJ/ChUxuM7bG1Wrd/iUa4HOQtA/bbFA50UMoIO+CZrizkpMYN72Xu/OsQ5YHmTlwakSfG1mpJY7HZ8zanqrAZVztBumvJjbcGG4RcfyXxzWTpL91yTlkV7SpGpy1Yi1VEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>> +/*
>> + * CoCo VMs with hardware support that use guest_memfd only for 
>> backing private
>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping 
>> enabled.
>> + */
>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
> 
> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
> 
> Actually, QEMU can use gmem with mmap support as the normal memory even 
> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd 
> on KVM_SET_USER_MEMORY_REGION2.
> 
> Since the gmem is mmapable, QEMU can pass the userspace addr got from 
> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It 
> works well for non-coco VMs on x86.

one more findings.

I tested with QEMU by creating normal (non-private) memory with mmapable 
guest memfd, and enforcily passing the fd of the gmem to struct 
kvm_userspace_memory_region2 when QEMU sets up memory region.

It hits the kvm_gmem_bind() error since QEMU tries to back different GPA 
region with the same gmem.

So, the question is do we want to allow the multi-binding for 
shared-only gmem?

> Then it seems feasible to use gmem with mmap for the shared memory of 
> TDX, and an additional gmem without mmap for the private memory. i.e.,
> For struct kvm_userspace_memory_region, the @userspace_addr is passed 
> with the uaddr returned from gmem0 with mmap, while @guest_memfd is 
> passed with another gmem1 fd without mmap.
> 
> However, it fails actually, because the kvm_arch_suports_gmem_mmap() 
> returns false for TDX VMs, which means userspace cannot allocate gmem 
> with mmap just for shared memory for TDX.
> 
> SO my question is do we want to support such case?
> 


