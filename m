Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA18C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC926B0088; Fri, 25 Jul 2025 11:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4D46B0089; Fri, 25 Jul 2025 11:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2995C6B0092; Fri, 25 Jul 2025 11:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14DC36B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:13:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6C3C5B6FA
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:13:36 +0000 (UTC)
X-FDA: 83703131232.08.70AAA28
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5AB680009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:13:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KAIGvhBQ;
	spf=pass (imf30.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753456414; a=rsa-sha256;
	cv=none;
	b=oVG6vO7aoy8JkKWRB5S9o6tJL7DLzI1ftLtTfbQypR8cFMEZC7eeUVE7bkOzJanPEoEQnM
	yS/epzh/GsXPtE39AasFmi1yu2uBtwd7tgvdNST6Nks9GoUJUzMkgOqT7dHmypdPJR8NV1
	XycuTWIbn64cq2ZfF6CaooisjiwHrHE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KAIGvhBQ;
	spf=pass (imf30.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753456414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wklAwsg9boDSe8pLyzo6TCDF/q9eqUG+mPx7Qgw+xVE=;
	b=ARCOzSxILL08smFloy275zUiofnW6Ngbc6oUR7TMGxzVaOa70pimxwG7l8dhobEHxXRRQm
	EjE/iOPgzU8QhVcQsKnbygLBC7jCikb1Y5aH4RzNaOcNpL29kqHvycAer9YBN2os+Y2w0C
	llLis/90VhIhStxy/VbM33cKJMV/ZYA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753456413; x=1784992413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G0r5tZJJ2DdnPw+tHoSqb+0jE/QYBRuw9Ad6PZ6f45o=;
  b=KAIGvhBQfpecl3lf5malPn946Kpz3G+O2RlE3xCWOmESC8D2/WmsFwYQ
   4PilPmglhFZNDoAEmZSXpCAbdAZE7wyO0agpiwM2nWYTCeuiqRC8I8QR6
   BiZwOO6VWxMVKsYnEc2Z7nebXfWa6Bz7dPy4+IrW13GjjeLi5FICPDckQ
   2ApnvjNhpUGIY6l62+MgTMCj3O5kh4Vjc2e/nMRxhoFAIPwmqxB45Yea/
   h1pE/eZleNdF6QhPG7+Df6JbsEThWnlzPX476YudURA+iZnw0CXvUkl80
   KSG2cZHnIKnFC4mLXtIBBq90YhvPemFwFu7KdPPBKaSwQDavfV3qD7ivs
   g==;
X-CSE-ConnectionGUID: zu4CE7iwRUKFnrvk2pOqNA==
X-CSE-MsgGUID: OxEqY6yCRW+jOyHqRWv7BQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55005366"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55005366"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 08:13:31 -0700
X-CSE-ConnectionGUID: hPjDrZYZQOK8o9DuLcPc8A==
X-CSE-MsgGUID: hhduVdRDT8KCUOMdux2CBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160695227"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 08:13:17 -0700
Message-ID: <da2237a8-c271-47b7-b658-fe0746f4100e@intel.com>
Date: Fri, 25 Jul 2025 23:13:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
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
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-6-tabba@google.com>
 <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
 <aIK2p9TgiNeQOI4s@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aIK2p9TgiNeQOI4s@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5AB680009
X-Stat-Signature: d9tq4usfubcjz4nijh3w4ufdxqoyw31n
X-HE-Tag: 1753456413-572530
X-HE-Meta: U2FsdGVkX1/XE/L/VeKcxdNoLJVJWF9g5b0XqVM9Hb4WR4UWM4rHjA3jMwhw5atKQN+j5RsFFukfJDcRL2WXKtD9J/gXpxZnwOIBD6jVHBTSK0nfW6cI9cD/wQZqHQiaqQjRrZwVeeUR6sHL1oBwCTQg13NHQkDoE3X8TnkAtTYtKIEZRYJdVk/CrKkayR/6UzdGV8awxIK2X/C6P7jpfZsmrNfjrxloRF8UlZ+L3F4GmCvWfnmkpxj1fELnKoQ8Ae4lVYlEl+6IHzhJOSHNcDTGdGPGmUJGKkV13hsFG+PWx2Dp4isSrgRmf4sjMjjBA01pS7knioV94FyeNZ80Ws45a/664xmvLVtVtQQXIo0sJHOcCfrsIK7GGy5SsOmrfY4NEJ5vjhxPGChNgzN5BCQlfV75YCENszoZTOH1TbFKAka5xAi/zqjaxNFXOopwM7zML24swYR3T3bJ4uMWRu/n05NDGQWRK26Dq23pB5RYDCh3PcN3xacBi4m1rQelv9SyXBOzbBqNa9fOHch5X/bGvlrBHNsGdvxX+VMWKhDDnkEFPGAW5GJ2+82KvUjXeWOaOUUa4oInE3Owe3d0giBCKwbcMTW261BrAMHVkwxcOuUhnC3kEzCQOYPnKEgZYGinFuhUq51lpjB1cJAAB/NfK9mO6flFm+6Cwtg72g6i9ArPiQo7Sc5geKz2C2D821FcQDlqLfkfpa5X3jxtN2NOoavUfl7Vl1PZJnuaMB7Im8rDoogl7Xvrjjccs3Z4uMSUXEu9HAFaNC3Bsso2v6q1ACkSWedMnI3JVjyhDzzJoHRUiLOS1MuQMyj6zvhQcok99IRG311+E3VXnhDdHVZytO5cyi0AjQW/pVlHGKRp+ZnXe+9BxvscgTTV1Y0iLpSU1K0NhdXD6c9al8Ul5MD0I86CQoz0DDRUz6UvYtMQKawHFisRJeqPA/4cv5wSPY8yIIrMQ+BXWCRJca7
 djxYwXz3
 2ZGwz+DSvBnrAbTDTbgXCVg1eYN99nAVu2RNPs+aheXaKlVw89eVBcITYBhn0skLykW6UmujzspMb6da0CplDNp+aswXygt73ajVnyy2JX+uskzPiHGWneWr/qsBmhttuUDDNwqeFQkTuwUhxbOzMsti/K+YBiQxiOdqOYY4XbmLANWXS3ubEnCUDaWSY4HDdSl91ZfSRBu1dqUdVw5dnFmA/H8nyWxV4TNse2gVGKSwm0bz4WdSviPjMUrbQv3s8uJQo+92x3xzao26b/36CPD8EiNGzfoYK8tsKeTxOKeyGFEM+/HNbF+gYL96VliKLVgdD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/2025 6:41 AM, Sean Christopherson wrote:
> On Wed, Jul 23, 2025, Xiaoyao Li wrote:
>> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
>>> The original name was vague regarding its functionality. This Kconfig
>>> option specifically enables and gates the kvm_gmem_populate() function,
>>> which is responsible for populating a GPA range with guest data.
>>>
>>> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
>>> option: to enable arch-specific guest_memfd population mechanisms. It
>>> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
>>> options.
>>>
>>> This improves clarity for developers and ensures the name accurately
>>> reflects the functionality it controls, especially as guest_memfd
>>> support expands beyond purely "private" memory scenarios.
>>>
>>> Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
>>> function. Therefore, ensure that the correct configuration is selected
>>> when KVM_SW_PROTECTED_VM is enabled.
>>
>> the changelog needs to be enhanced. At least it doesn't talk about
>> KVM_X86_PRIVATE_MEM at all.
>>
>> If Sean is going to queue this version, I think he can help refine it when
>> queuing.
> 
> My bad, I simply forgot.  How's this?

looks good to me.

> --
> 
> The original name was vague regarding its functionality. This Kconfig
> option specifically enables and gates the kvm_gmem_populate() function,
> which is responsible for populating a GPA range with guest data.
> 
> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> option: to enable arch-specific guest_memfd population mechanisms. It
> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> options.
> 
> This improves clarity for developers and ensures the name accurately
> reflects the functionality it controls, especially as guest_memfd
> support expands beyond purely "private" memory scenarios.
> 
> Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
> minimize the churn, and to hopefully make it easier to see what features
> require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
> for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
> software-protected VMs.
> 
> As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
> for all 64-bit KVM builds, at which point the intermedidate config will
> become obsolete and can/will be dropped.
> 


