Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF6E9C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B016B008C; Thu, 24 Sep 2026 12:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BF76B0092; Thu, 24 Sep 2026 12:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B746B0093; Thu, 24 Sep 2026 12:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381576B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:45:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A745E140436
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:45:23 +0000 (UTC)
X-FDA: 85249231326.18.2AF3D97
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 521614000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:45:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GMiw5tz6;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790268321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHS9Xe1DpFOEFYQ+9r+YNg2kAgLLd5UgFHt7eRxptR4=;
	b=bwT5ZGm2/p9o6a4ZaPNMV7thV0TRhlo+GF0LIXr1gC0jFTv+4HDPkzYj+23eOZKxgrSf8Y
	GQ/kvAVKXwTAf+3hDlSU3mNMolrPUxk9wpae399k0i4c+viwlFmzF5WJ/uPTmVYJxijdQU
	9w6VoxR8xzLfSfhGAiSMQ4DvdWyk0uk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790268321;
	b=BzQ4uEmU8DPJoesGTjo5zxVjdq12VZPfZFbfsgBGFLTcuT8SnvTL4QwT2j9CzAToHTw/E3
	s2YSTmz7LX6/ed7WzKqajZqiDbAUY91Qiq8LLSwmYbRu3J/DKv0YU0RE1IZ/pSJ1KnP25f
	BkUDtrMYPBLqu5OQPq1V+QD08gz1dbQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GMiw5tz6;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790268320; x=1821804320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dOwzsZfUDWDXxAicpHvqhDWiERIbgkLI4r+aHPRf2+I=;
  b=GMiw5tz6uE5o1UlxF9d1YxOYGih61yZGvjxOdChSgSgoVzwfqRdCHLIS
   hOQtvJWCNLu9MaZhq5OsEfXiYvsI+MJZW4gkuu7ZgbfAk0my3nADICZx3
   xK8BXAVLJqimo/pLec2U6GKLpSF2aIzBM1tAYO536woNIHYsIVPqsiW3G
   QnyqQ47sjp7Kii5W4goE+ZMSgeKiO4v1kXORsmsYjVFC0B7keydy+NDFa
   yHkt1HB57U3lI4kx4fAOZHdh+yGwU8qhzWqPhXFZVYolYQo4cOBrk28Lf
   HEFVuqSGw224nQzYPozHA+thbOCoXnEzvXzfOvR/NxXixtACjESf96+lx
   g==;
X-CSE-ConnectionGUID: rarbAcrlQzG0H7xx4sq/aQ==
X-CSE-MsgGUID: IvubriqZRW6QNyapJng5KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="102406492"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="102406492"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 09:45:19 -0700
X-CSE-ConnectionGUID: qXta5HAHQNatWNIbbRzIAQ==
X-CSE-MsgGUID: g7ZDVadRRGiSjshv5IHkcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="282168792"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.110.171]) ([10.125.110.171])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 09:45:18 -0700
Message-ID: <05a08cb7-f507-4a15-bc32-4770962e2753@intel.com>
Date: Thu, 24 Sep 2026 09:45:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Toshi Kani <toshi.kani@hpe.com>, linux-mm@kvack.org,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <e1f8a64a-e4b5-4c1b-b83d-50425a7621a4@intel.com>
 <20260924051011.21237-1-mikhail.v.gavrilov@gmail.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260924051011.21237-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 521614000A
X-Stat-Signature: ibkjwnqme7euapwdtrb7gt7rk3j3rgj6
X-Rspam-User: 
X-HE-Tag: 1790268320-860584
X-HE-Meta: U2FsdGVkX18CnEFDZdmkxW/EFjatDsBoPda8aXUb+cvNDvFLM/8iwmWB3+p35iGqFTC6yzY4we3aM2Xkxd5LFdfma39Uno5jvZ/FgPVvDgWPxQdNKSx9T3UxXl4A2hDQgODq6mtBswYBhiEAHEQnamUjDvtNHXxsfUh4WZiVVSiNI4WM0/SEHudpKZ6Z10Eg2NDlg2Rr8rSkpXAGTyJykWtuDZeg17RONQh6KwE7+68IFszXR/syTEQ4xpjaBNyNofxcnZoW/sHfxbI5U/Zh69/fCa9G02znQcRCtiuekGO8iEyW6H9Hwv7bBHFXkKfQYqQjRrPrBNEb+S3OymqmOxLCeEHGQJGY4EfRxzTAgarDSq54l9CMfrNvHV9QPSRVKUKq5XJMTTdCpzLo8dxYi3HvfO+Rpwlqh3NxGYFmvPwykcohw5xjJAUQk1kXFEu8aNe/LiPowXD5U6UJ5qobRK9LXSMG5fsO7KiDbwHXLjQx8KFH8wVrAQTiZrIR80qyXSyKAIWtVk05gL7ZR9fFlYViP9NNmVKGbc5LgBYMTK/pc5Vfhz6UMPrczUIg3aSRdK87YWqHgApvzD1JHSPo30R5Olm4e1u/22ORpsGJqA3RhTUO8uF3UvxHEURwgEaKSGoqFXa6ReqczPdAKo0JuqYM/ALn7gSR2bGPFMHWXD3mvjfw40IbGUV9xN9iEg1T0CmS5OvGCkpPk/gXl6/xeVcd6ONMpOvQEk5+XI2EP6XTZDXL9+rkr5GP8Pm6eMbvoDNXMxhMrxeK6zlVf/3mthble7HqSnnO3MoKoNQTyJYpQhhoif7zhyHwNd5VHXmLHahOhhqAQlDnRhyY265Dn2aEclB1vysLsBoA8GJUUwppadgqwOpo/eCfIBnWeFzelTCH1yHCO+RCSrsjFVCgeHBzaCFEU4snQbLt/LcPGzKFVBzGrvV67l89h/ZtW3rMK6x7bljwYapjQvC/gfN
 2Tr4plh5
 AnuOPseVExTzFXNHlAXcBVO2RZG+gcQjZ+Shek0Df5QaTbZI2Biz/6pwx/6SLwLWlanxcHuIBhypLnYPmNm42mTS/dVhPGyRzPUeyDNhscf+i6MtP4MLU4EVVjxAbKaly9KBTGriZnqXpDzRjtZ8OLxcpqNh5GoamNgfwj6Je94Vwjq3hY88l5idQIdsbIltjPxp+ksEM/AfQJXNo4TjEXJ1KF7KmuE5oErpH5oC8aeKGa8/mX7dOKDe61mSLlt3TThmKP8Lw224ZDktYLAA5xiZddXIlg6qh8hhAl6QE7yYvTjcInPSSBkfiD1B7E2QCfdYobomz+wOPwTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 22:10, Mikhail Gavrilov wrote:
> On 9/23/26 16:07, Dave Hansen wrote:
>> There are a few things we need to figure out like having
>> pmd_free_pte_page() return 'int' when it doesn't ever fail, the
>> comments, and the reverse Christmas tree.
> 
> One data point for the return value: the x86-PAE pmd_free_pte_page()
> does fail.  It returns pmd_none(*pmd), and vmap_try_huge_pmd() relies
> on that to keep ioremap() from replacing an existing PTE table there
> (the comment above it is about the sync'd PMD entries).  Huge PMD vmap
> is enabled on PAE whenever the CPU has PSE.

Oh, that's just kinda silly. We should just zap that version and huge
PMD vmap on 32-bit.

> pud_free_pmd_page() has no such case: the PUD level is 64-bit only on
> x86, and with v2 applied the x86-64 version, like the arm64, riscv and
> powerpc ones, always returns 1.

Yeah, all the ones for CPUs from this millennium are OK.

>> I'll dig into it a bit tomorrow and see what I come up with.
> 
> Thanks.  This box reaches pud_free_pmd_page() on every boot I have
> checked, so I can run whatever you come up with through the same
> boot-time kprobe and reproducer check.

I think I'll just take your version since you actually, you know,
compiled it and all. ;)

