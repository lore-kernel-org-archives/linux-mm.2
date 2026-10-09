Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B396CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8CD6B008C; Fri,  9 Oct 2026 16:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A1C6B0092; Fri,  9 Oct 2026 16:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6513C6B0095; Fri,  9 Oct 2026 16:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38AC76B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:54:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45A211C394B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:54:09 +0000 (UTC)
X-FDA: 85304290218.12.0C93469
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id AFAE8C0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:54:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Bq5o/Re0";
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791579247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6n6u+AjYHZQm6Rh+FNl/nInGnvdYxE69vaLWbYX1iM=;
	b=dswWbuZr3WXfzlw0MsAbojpeYDHMnIVBIWykICOZFh8USXyiesch13qi6dzmlUMYrwxni/
	dqb+5VqAja4EQmPEITkxdaPKHXYG8Q/47C5A1TWtx0I2AKzIs1P1AWQxzmLm6BnEG12/zB
	n9B+an2XFhdj4ZMrfF8zVESUllCvQKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791579247;
	b=yHBOoV94099F16wwe+TpbsE3AFQZWbF9JXRX75qDblwTS7Zrh8BSPOaUHWXdnludZ7QY2n
	M0APB1bCQ+OMlwmdeLbpUXqLrzyl63JlKZ+A8EAxvo7wCjb8BInmH33khNfoZXHIRk5yHs
	VGAApHyrd4ZXT5PkQ1TxMVBQ+zXqxg4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Bq5o/Re0";
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791579247; x=1823115247;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fgRH35rAuwoizyE2+gu+S5LdhmVsIiCJBTDh5HoaPno=;
  b=Bq5o/Re0dHET/rClEY+sRDEm631x1uqM+gLgROEdKDy/UVTRLF+/Nlx3
   nIJCCF0gVqNHhGSLhrM8ku51Ysg5TLHPf7rMyzv4VflQF1ThCRqvYJKz9
   iOnYeEDadkdjMX0aMCUJZ9bNaGLFJ4mwI5pPe6rtpIBS1on0HFhkWFhbv
   trDjhQu9vPLEDqUVGBOWwJWmk4dyUBEeu75Q7XowX3nWTbPYJqkVBeca+
   M2My/3FiKTyvGeC8wOKsTJtIXj9Fyt6gXf7+2oOKpbd8N3rQnI3xRMt0c
   rQ0e8y5t8f1f7kIc8XNyYxZYAUFJOGc6XfLQDtWsFhuZZwhaT7brzJBCC
   A==;
X-CSE-ConnectionGUID: Ksbs5/mfRhqLluTCtpCNsA==
X-CSE-MsgGUID: wLlr1XaIQIaiT0f/Dozm/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="394183"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="394183"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:54:05 -0700
X-CSE-ConnectionGUID: ODAsJhCnT+6lgKOO/0TUvg==
X-CSE-MsgGUID: Eg6tPTM3Qn6fnZyd6dbigw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="752675"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.84]) ([10.125.109.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:54:02 -0700
Message-ID: <bd47fc12-f1cf-4994-8b42-45fc68944072@intel.com>
Date: Fri, 9 Oct 2026 13:54:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, david@kernel.org,
 osalvador@suse.de, dave.hansen@linux.intel.com, luto@kernel.org,
 peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261008073021.2512665-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFAE8C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: f5zbg6goxhgarjtmbr4jjmxoe17m37gd
X-HE-Tag: 1791579245-263511
X-HE-Meta: U2FsdGVkX18Vg4caI4T7Ehe4CfZR+3NZx2TtUbJ1mPP7Ej1sa1Z9xMROfGMHlv5ESVzF2GtP4PHzeeL8rC+DAi29g7EMUVsrR+dH0veJN5hFUvdpMReTk093qEzCmO7XCQ5fmd/TLRrLDLYL8dSV5pUuDfUrDWgMxOIxYbXW+uzTO2g0J3UZGGradpaSXw5/UzyGhanBJAccc5UzuhhN67E1eL9Sapz5y4Jk3M+Z0le7uHztvSgHc0oBNxNi6MtDa5D2cfgdmXv2fRARaNv2MCYuQ3Qu5uaOz5sLAl2WvqF7eyVXOdKcBCCTS+iXobmn+cJbzBuSF+D/yqBD+/qzOZ+4ocN02tf5NSiABzvIxWdWFQk7nAoc26kN83HoD0evNKr2f3+bSg3sAWbRZK8k4Ks8tDIrVWJsFcHXf4EkbKj7x5H9CNHpRpKhTjlN5wbvQWXBdp4sTiuyaoyvo1X+eOdOU3l0OHuZdhfRpt5bNczqZ1iDR2LxPov1zfU4i3qNV+insJjpJvuakC/Xm7GXOfAxAD9y6S5G3/AN/HalMfdg83BFkMM4TsIsiFzFf2IClVDk0ovI7Lo/mDRZeyiIsKF2gfuHW1KMZUlAUDidanm2GZFxrtyzsXGLH2x30PjMC+yGmA5c2zZy1vnWf+IOdm8akPsT4cXpZGKMcjNkcrb/n9teKr1Q4kA1YJmC+SJkVkrt7uoaiFhM3BMWkHInSJHfrHmiqoQCuwTSF5LhZcN9teWF4uSqbCswXfzi2SuAqUIJ7m4Xk5TIq3Q7+F0qPLgRzfXU8oFKTKofbyihIkZcm8i9AN3eMUzXcOXSfIAu2GQP93qYnGzN4QlUsTdz9iutBPSEXjVlIYzpAHg/6KuYUaqVt3qlLSGr/XkBsgL8iF2dThOdsnBsayBokiv84W5XEAHa5k2AL/n1H0b/4AL9U4lHWQGheg27TUK7UoosInV9w6M2Oq3gC5XQrT6
 dZ45LPwU
 ee4bxiRHh8L7PILQgxsrFpcFxk9uqtXc1bxpWQWzuF0ckjVLSkbDHSwQYvcqVYdfcv2QoMtFqp3LE9sZiAmeFviNIkQx22t3azc5AYBHgQ6zlWJJrfphdqtmNVlOWNveiYiDLsZ+xYALQjk1zkxeniTFywjhFLx37CiigHRF11uopLd/SAI0p0JChZnaJQU/rYe1Usp1CgAbmGM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 00:30, Muchun Song wrote:
> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> tables.
> 
> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when splitting
> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
> table, so a later memory hot-remove eventually frees that table through
> free_pagetable(). That path currently calls pagetable_free() directly
> without decrementing NR_PAGETABLE.
> 
> Use PageTable() to identify constructor-backed tables and run the
> matching destructor before freeing them. Keep reserved and
> constructor-free tables on their existing paths. This also prepares
> vmemmap teardown for generic runtime allocations through the normal
> pgalloc helpers.

Could you please take some time and trim the bits out of this changelog
that the LLM inserted but that are not super relevant? For instance, I'm
not sure what the first paragraph is trying to say. It is apparently
missing some context.

FWIW, I really don't like the LLM changelogs on their own. They almost
inevitably need human editing to make them usable. I really, really
expect humans that are sending x86 patches to spend some human
brainpower on them. In fact, I expect folks with:

	Assisted-by: LLM

to be sending _impeccable_ changelogs in v1 because their LLM saved them
so much time that they can spend gobs on their changelogs. More than
ever. ;)

Oh, and it's an x86 crime that we have:

	free_pagetable()
and
	pagetable_free()

Any work that makes that coherent would be much appreciated.

