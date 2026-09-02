Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B87C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F5A6B0099; Wed,  2 Sep 2026 16:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39046B009B; Wed,  2 Sep 2026 16:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27476B009D; Wed,  2 Sep 2026 16:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A80256B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:48:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 331A11C19D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:48:09 +0000 (UTC)
X-FDA: 85170009498.25.177171A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9464A14000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:48:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ketJLARj;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788382087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsMn3/y0ByvC1uXtR6xF4fWxSc3am3y8Xh2THPJZMyg=;
	b=QvMg9+/2+lX1md0TrrF3WdtO41EmkBsZeTqGl3+MJVuj2/lg5fW7OVmISBu+eeZr6oOgsg
	/7qe+8PFv/68ZJ14hNy7YppkLpGmJQ9QumoRquGFqHpE+eWmxXOWFIGAYK1Www/GGxcT4r
	bIu+MgfGjXQ27wbHM/5XbmTVnCs5V5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788382087;
	b=8ITlNKK96p1+9jH48YGSgIFJ+T6xPDkQAtci/5vc6+6v3osM7lpROmO3sN+r4dIS5kot+n
	wa9M1eym4JSd0Sb3UxyENvAidrpVGZieXxGQGrFgU/EuCfMRNan12uiYO0X3TbfZ4BvMjs
	vacWdzV6GidC63lbLGZPLdobEqXuTjk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ketJLARj;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788382086; x=1819918086;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LsMn3/y0ByvC1uXtR6xF4fWxSc3am3y8Xh2THPJZMyg=;
  b=ketJLARjgHSYkzCrJJRPcOTJytmQqpJE86bAweuoeOsk989Jf2HPjAcO
   JQh5ONS708U0TMDK0HXPw1JKVzhGp008a1WtrOcJMx3z+dPu0/cyJOsRf
   YtSrs3atSUCkTMA8Bm7eyw0dDUaSLXXR15ceuVf0RytH7nQ35jLjSrW4x
   wo5YSfB+ErenSQHF19xBv2w8eJaBSMf0Q21nRODLCE5U8ky+zTi4JijQG
   spCySYLDOjFsiVTngtXfYJe/C363AKr5H+3lpvWOlB6LoOVikW61E0DUk
   gC1+fLnlbyyc3grT564mAuAjAKWHELCTTvS4NdBCbVA4ImbVsWRIeRrxg
   g==;
X-CSE-ConnectionGUID: HZJRvp/bRbOkdd3ffEuGaQ==
X-CSE-MsgGUID: MGSr5HbwQuCRN0bDvPXe9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="88777073"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="88777073"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 13:48:05 -0700
X-CSE-ConnectionGUID: 7lG7cHPvSjGN3cya1Kgtcw==
X-CSE-MsgGUID: iKbUXdDDS3i4/Eh3uQmPpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="268192165"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.110.134]) ([10.125.110.134])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 13:48:04 -0700
Message-ID: <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
Date: Wed, 2 Sep 2026 13:48:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9464A14000B
X-Stat-Signature: 1e8hodj999orayeuw1bcsby4cfkk14pg
X-HE-Tag: 1788382086-445117
X-HE-Meta: U2FsdGVkX18rUEXlFN3jX9sM64tLY0TQPPBLaHOApUyc10ns08mtsEK+ZiQ376qJxjb98zk1hLZJua+c1f5kBQmd9zsxORULgUvWGO7MHFQPaFLIKTjHIcgqATUHxla+66Kjo+0Fw5M2VnOFOyEnbY9lu5YgmV6OYI0QQUky0iEi6qviieIjvGL/99gIf5R1RKrgK2VZU8TrFns+p1GuHR2eQd34y5i3z4KvbAEK56/cMrTKsWwyhXU2rhyL999/2TyAgRvL4hCwtND4vGXAwXG95Eh3XJBzDN1hYbcrOCm6nMVOpUuZLzA+BYBT49RN3T1moSFT/Ys/b4C5ijT2q7Eg+VBN+D3pvgkF1deYlzcthTkUyjX3x+BVR0e6fmrXv2KN51wPboFuskzqCA+bJE0VbOiIvF02rCQWxTtuEClTo9eSyko7n0WviOyGtfCz9pmfAmXxk0S2cS3TbW0eYELLVvT1ZsdPCRj8qZKS29mLnuV6gxyCWLID23Tm1XccMd4Q+y5KZwC1ZSGbvGWMfq8gia+UCHjQPbsWM6DPe3ODCWeOwjv55tgb+eWlUDE9a19BdXOm4Xectwet8QPh7Wiu/4gj4PHVA/o+HClbYwsx3MdzV5aEXDJxVm7+5+O4vXVRu5EUkGCE9IrDgNVx2euctslFUD3RDtUsYCX/7+QpFgXgdAXCG6di/M2HVApgEFWVAiVIejoJsmG//ti9faSxjynD7wq36J8hxeVXpaq+gU5kneCy6SVb14XW+WMgV0HGVock/1owDpRj730TmRHRLRQGvU1uaIPq1v/80loibvDdXFI4CvLcviD9otW+EQW1IuTq4WkS4X4DfBiJjWSc+ePN+p18sEs47B7/lMWEzB8FAZtuJEeJPW5tGLBf5WdFsMuImMu/qLj+q8F0956bHcXgyyPdAUl46VVXjdd8X/mWldyTw4KEdk2r8XDZttlOtQXOp7PTTYlhF+x
 Z93mJVye
 285grNtNlnb2rvrZ9wZ+uhjvI2+QRwkWIfJTUxwOb+Bale4ENUgsEwC7Dw50fL7brHQKX9bAX5DAxBQaroOMVP6GB89B+yfZEeG08oMhyL1rsZRLrlBSSNE8MLwJu/8v6SuOATikNxFtlrAZpG9GxWoMw1b4OY5CUODlKlbFLRgM8gepUDXrBVytvrBOYGaoDSTuJYQKJsjTVt/CiXGcj1y1tXXnFSdyiWIWlS+7P6GjllkwKFs1Aiq4gwk0vTWN5elPahY9OfH6gXhHQWHd8VEjBaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 04:56, Yeoreum Yun wrote:
> Instead of using hard-coded integer in effective_prot_pXd(), use
> pgtable level enum.

Does this actually *do* anything? ;)

I guess it's nice to have a wee bit of type safety from the enum and it
means that you don't have to *know* which level number a PUD is, for
example.

Either way:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>


