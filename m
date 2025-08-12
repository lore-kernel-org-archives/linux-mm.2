Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120A2CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A978E0109; Tue, 12 Aug 2025 05:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933288E00E5; Tue, 12 Aug 2025 05:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F1E8E0109; Tue, 12 Aug 2025 05:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7973B8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:14:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27EBB1160A0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:14:06 +0000 (UTC)
X-FDA: 83767543692.30.FAA05BE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id D67D3C0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:14:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JDZl3Ha0;
	spf=none (imf28.hostedemail.com: domain of tony.lindgren@linux.intel.com has no SPF policy when checking 192.198.163.9) smtp.mailfrom=tony.lindgren@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754990044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yU+dxph8tzbHyl5V/XOI/2SZl8RGZjchTu5SsZs/p8=;
	b=bpH0cZb51PQQ8rajBib80RWlVTVMyObAWAHAfDiVWcis6PmOFwFA7LznK7Md32BohEt8NQ
	KltkQTKiPJaQDAB17oI41Ca4+K/Neiv4eLRWCno7ym+80XgVx96QEVMOgdng2Q2EMtud6G
	i8RjgKjar1sc+d85bh5qHRr2kd/2/BI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JDZl3Ha0;
	spf=none (imf28.hostedemail.com: domain of tony.lindgren@linux.intel.com has no SPF policy when checking 192.198.163.9) smtp.mailfrom=tony.lindgren@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754990044; a=rsa-sha256;
	cv=none;
	b=YJFzIiGaLjSQEJfSWFEaXcXZzu49FFvZvMgFTnGRcal3mjJValcw8gU79wWo6YCWM3ulnF
	uHugX2ioFxTuvOwzZR9oqgUuS84MRtccFCXBlTuPqFVo+9XAV7U2deTvcModPlMqMW5FdL
	WvEMFNGU93ZkIxKd+HfUQwJvJ2qrTt8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754990044; x=1786526044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3mrPt0k6oW37kVZVWbgrQe36tlhm9WafzeCVJIhfXxE=;
  b=JDZl3Ha0BCRexFYyqqpN8n+U37sXtHsBK+vdAm/8jiobQw9DcChSIFYK
   tN/XHukQ4xKYfcmvy6UFhL9rMdafUb3zyiRgALiRTtxaPmOGdFf/r1uvr
   t8QZn+1z6+Xhyz9iwoGfYyd7s3H8NbSm2QhJnvUjsnmigB2j25KkjN/ij
   KJk8AD/Pt5b+qpTd3NSqIwK2banqMrGAA9uFP/Xz17hlA6dAF62FB26Fr
   c0wXzYDG3DicacysfQLSFSDe3M+srN1oUG+xP4cKM5yRRTj5+pJm1wQeV
   PNrzI18pJY5peeVk3Jt3ACVKL3TyEK3zyZ7UPVwXnsryjj2gCtmHes/yO
   A==;
X-CSE-ConnectionGUID: d6eUHgbkSwSoU0EMgzQsBQ==
X-CSE-MsgGUID: 0E3yx6igRsS1ZbKRgkRzEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="67965355"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="67965355"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 02:14:02 -0700
X-CSE-ConnectionGUID: wxjRK0m0SJGHwZm8ovjW8g==
X-CSE-MsgGUID: DmYbdTZ1Qkq8kRQ6zTZidw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166943956"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.246.8])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 02:13:33 -0700
Date: Tue, 12 Aug 2025 12:13:26 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com,
	ajones@ventanamicro.com, akpm@linux-foundation.org,
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org,
	aou@eecs.berkeley.edu, bfoster@redhat.com,
	binbin.wu@linux.intel.com, brauner@kernel.org,
	catalin.marinas@arm.com, chao.p.peng@intel.com,
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com,
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, graf@amazon.com,
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz,
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	kirill.shutemov@intel.com, liam.merwick@oracle.com,
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name,
	maz@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mpe@ellerman.id.au, muchun.song@linux.dev, nikunj@amd.com,
	nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com,
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com,
	pdurrant@amazon.co.uk, peterx@redhat.com, pgonda@google.com,
	pvorel@suse.cz, qperret@google.com, quic_cvanscha@quicinc.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com,
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com,
	rientjes@google.com, roypat@amazon.co.uk, rppt@kernel.org,
	seanjc@google.com, shuah@kernel.org, steven.price@arm.com,
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
	thomas.lendacky@amd.com, usama.arif@bytedance.com,
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org,
	willy@infradead.org, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v2 32/51] KVM: guest_memfd: Support guestmem_hugetlb
 as custom allocator
Message-ID: <aJsFtq-vLmCWHT06@tlindgre-MOBL1>
References: <cover.1747264138.git.ackerleytng@google.com>
 <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
X-Rspamd-Queue-Id: D67D3C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xf1q571wmwbw781qse6aw3gfgqugduww
X-HE-Tag: 1754990043-559000
X-HE-Meta: U2FsdGVkX19vw9n4fWUIOPG34OvMhA5gL5LYCrE29pfEVjCG3KS92un3tV0tIBMi5+BRBHxKe6JiHxa9aSrrE670AUETgskCMj6M88GoA8rZY0XgHV6EbdKgGnuInKAHNdDC+q7BkNdqcEn7YkazadXuAplht0O+itrW9RROYZhbpSCLD6txolDist4zjEf58eUCbHTBbdZBwN91OQux52ensEzq7p93KkAPq6WsGlxznGLvZBiKvlz2qflAt3lUZ8+addBmY2IYxEqW9z8RASUj563FJ8YSuZf7VVF53T/ZAYK/gppItgbSAEhhkEbikzn9FxpOClVFeg2uw5XWEORh8xHllX+4h30EnQE8VyEOgjjys2GBo2zieKhGwhkVFFYk6MA1mSs0NIOwpwE8QT9VkyV0j8ZO4mnhf24ygvXJCBPw0SRZFKGo/re85OVjyrTIBZ8Go8Kd06GmeqUj0+tgHiof0tHJYMOIINc2rdHDwS5hZS/br3Eq0qU4cvXe/Z04oEVztGj1rfeKKF2ZtsmRDycS9D8CtgYmP3mnQQfdHJ51yCLOEvLFw03+y4xcLB775OfmdI+d08MyqTutxP3XBaCuUyK/pWFKq8e1TPbcH3nGTtiEJFP9i8qpenJHKTz7FUMJKxZ/5dJvMnFFzTmv/y7x3yQU48iVEbvq4KqQWNweg/bYPMomKbJ16I1bpkifRHqhBtfbjDLb3oJdUb4zxH/HDLvSn8p68zG3UVRGD/YpYj41DoTZqLxg0CFbaFm6L+rj4/5mpFiqt4N2rWHPDhABeLp/Xt2coqI4ackLfFKtfagk8QCayG/3qvGJo2iylOi39sV801xiOOMdzIlCuSY1YzSvUC4QgrUZRK9zmM2mkM6SI9fDJz5hFJgupE0PAEswtpER5MchbMBcBeCtuu8nOzOP3IWMRNu5P7bkAHMg5aEqJmMVj/5/8xlT+Zvf4fuLosQ7v42KwWi
 OsprtffJ
 A81iu+ptxntR6f85/YgJWw64LH2WOedLtvSaYLvf/iugyE6hAnc0Dv3TF8luHsK/ZoORRUFaFZnYrdOSc8Wd6mDInnF7MaIynYxLHpm8VzqHcXukH0v2iMdc8PrBix/nZDMmqfj0nQUUopmwlhF/WVczCHoySj9VtSHhM+sJkTeFJku3x+3yaY+kdi6K9OOXzHPBJCJGP628c226I4lSjtEuy161IgvqciEOJrn0IVd56b4b/4qIxZ6TxJECO+njXJyOT+Ao9fF7+poas6dyg4VLQUWjAUVxZPHDSroUxAHLF3rY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, May 14, 2025 at 04:42:11PM -0700, Ackerley Tng wrote:
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -133,3 +133,8 @@ config KVM_GMEM_SHARED_MEM
>         select KVM_GMEM
>         bool
>         prompt "Enables in-place shared memory for guest_memfd"
> +
> +config KVM_GMEM_HUGETLB
> +       select KVM_PRIVATE_MEM
> +       depends on GUESTMEM_HUGETLB
> +       bool "Enables using a custom allocator with guest_memfd, see CONFIG_GUESTMEM_HUGETLB"

For v3, this needs s/KVM_PRIVATE_MEM/KVM_GMEM/ assuming the patches are
based on "KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM".

Also probably good idea to run some make randconfig builds on the series to
check the various Kconfig changes and inline functions for build errors.

Regards,

Tony

