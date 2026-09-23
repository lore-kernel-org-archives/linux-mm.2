Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9344EC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CC96B0088; Wed, 23 Sep 2026 18:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4AA6B008A; Wed, 23 Sep 2026 18:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAC46B0092; Wed, 23 Sep 2026 18:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDDD6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:54:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6C7D4016A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:54:01 +0000 (UTC)
X-FDA: 85246531482.13.1E73411
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4AA06180009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:53:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U1vJSph6;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ds+76vTdCbwjnb0atzNeoZhsT+OZsIQWk/I5GzQS5qM=;
	b=WWE/lHAalwz1PKSRXBZbgkyzz0KUv/KTG674WqOmIiv9WDZlS8Oi2mBTV/tL2HopZQapPF
	W1c42B7z+nSWLCwk+uA9hSPezAk6pYLI3oeQ7VPFQ8lTi0dqr2o9+Q1Fhkg1weWlCFmQae
	6Xt3O3961Z3fR9v0KnUuAqopFsGROeY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U1vJSph6;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204039;
	b=SV226pC59iGAhYc0Xc2YvmYMrBj4s0hVvh71FC0jDR0uY8eA6yrsZgHzpeLafG/fbpERpM
	ke6MqR4rwLhqNsMcsxxG+U7it5ahBQvX7XqcV775uaYvbsSkRyivkFvMviRI1ZTZo0xsTz
	Kr2drIe/JjJb3OEWxve2jmMq84PYLHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790204040; x=1821740040;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=1x5MXmFtxzmm1q9H8+jB/OdaeToUC4yW6b3h02ycNzY=;
  b=U1vJSph6mIxLQ/SjvG2oq+fvqptxPbeYT7D0eM99Ofb+ex3LA0ZHPtkp
   ulHSfZZ4gmY45I00F+e4JlatoXa0U+oXKUgF++HAHvpjYlp3ZgaGruCEK
   qY1hBRyi9kO9jskd9iIV+S7VvHCBFFrzzPEK3gnzvwUgSdVWp9UuVzr10
   5CkPlpq0iEWgQDlWP0bwRatA1G/brxF6lsO1GKHDHMG91xTkG/ziim35P
   um+NORFt+mBSH/LiCNwgeMStGL7N2qtWJ4OF/uVXUZFnW/IrkGGpYUgf5
   gbP1EAZDy3bE2s4AU/fDBYPJQmwzaCp4r4MvamyqPeIbY00fwqdskOuvU
   w==;
X-CSE-ConnectionGUID: YkKf8iypTBK3WWV6ZdnvFg==
X-CSE-MsgGUID: dSP8p+U0TvSyTOEVVrz2TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="101610189"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="101610189"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 15:53:58 -0700
X-CSE-ConnectionGUID: vNzfkoyZQLaCeP30fIQpAQ==
X-CSE-MsgGUID: fHRdLffWTyaGJCv0Sjqmdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="281899357"
Received: from cooperst-gp06.amr.corp.intel.com (HELO [10.125.110.104]) ([10.125.110.104])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 15:53:57 -0700
Content-Type: multipart/mixed; boundary="------------8ltgeDxBJN0BN2U8yZ01aJMF"
Message-ID: <e11449f0-d9ad-4d1b-ab21-2be7d71fe335@intel.com>
Date: Wed, 23 Sep 2026 15:53:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: avoid a reclaiming allocation in
 pud_free_pmd_page()
To: Pedro Falcato <pfalcato@suse.de>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
 linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
 <arQbFrGiilXn7ABD@pedro-suse.lan>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <arQbFrGiilXn7ABD@pedro-suse.lan>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4AA06180009
X-Stat-Signature: bbxisw35qxsyxgyxyhe6oq8nm8mx99r8
X-Rspam-User: 
X-HE-Tag: 1790204039-707990
X-HE-Meta: U2FsdGVkX18aoy0kNV8J2OFh9l89cKpM2SQXi8djNo7mSbGJP1PENSyw7zFAHsRn5YzioWMkcLoujVI4xHahNM+VirzVvYn7v1Mqx75FV9qm3YHDZ4oXrXmBCqJ0AAbCU4rNs8Ge1Xsw2WLmDwQ6Pt5paqcowLdvOF8Jb5aDpsf+e1UPIGcn/niocK5SFoWqUUCDnLyC3GpyfWQ3/aU9FPrQ0730HDV6kp/s9M5o3NXHPZ2Uho2l81doI9mTfmyLTNta7kFIywZMbn1R8ZrmzuaABr1MH1UdPCvGl3oP5zv9Irjx3NV24gdrUaDcsc/5gLoC2gF9aGwkNgRjnM4rUjFxqqRMAl2G9SvT+4Iv6SCAP5199urHfln0ZOZb/0rOSkoCuO2nf+/yz3412BLSuFyay4X+pGj0zuQsGUU+7vivMHfoNkrBtvdSjcOFRKFZUGvpBlCLyvQ9GkhzvsG7HgzDdmwqIgGjFaOfVTJF+899mqWtYF0fXossiwQobWqhEyM2DI4hha1k10N5sghhsQTZ5fkad1I99sLyFkKxQDaxa9LVdqnfCD/CkjEpjwjTI07GoqWcoRbb0j7+yWN2GvP0poJORAB1TjS+Z3zF+3uijsnrk8sR5B0w4cB6+p0hLvPY9U5AhS8j9y5+0oT3Of6YH87BaOuwQWpGgoOIQe/+ubZYSS25CM5iFRebKA6tD3hIw4H3yLtIeTdVfHE3QJGpkFtKPlnH+C5SA4QPxmepNFqBrx47WEgQce6VCZW+uJEV2IgySlfH+CpD3YUwX07jMXNAuPrnpv2Aqea8aKV+YPCKriNQyI/ABZKFgQk4NmMHSsRBs6Xec/ICrH/qvWwXwmnxkLvupnBAOLZKXBMyNqqZ9h54yUlmngrcUNoybnXRmnDlHqihXn/wEdY1U8x6mjn9rZkCysDHDv8PyoV5FURKahVGe+bBXec6yv6L2jkbti51V+W4ER77uDf
 uUt8xRpT
 F/PDlf+3PkaUyiRpaM6n9/oVm1WwgvhW3AiZshNejOJEAtuIjAMEkjfA1r7JE4I/idut7ZC50z0tx92Dh1BQR+HvZjw66/jqksB/oBiSeYNKneVQ6UtZpZpSbq+pFAljx1B5a3at3BajSDDBzb2ASMiQvhIAtQ6Idw41qRhNBGVYhq3suf+7jyKcM+xzt4ZD6xqE0HvJhT+Uy+9LX3fApn3JtSMTg64gusSjbvERwuF1SD0ik/dNlSm4QEin1C4dY3k1d0R/YbFsbq2fHlkW5CllpbG/jTg1mM/gqgPhwRkXrtv8gmufhUFNdp2Qb56GzyTQGpOxQaj/a3oq1l/zzAs4K460lSAJIsiOcfiEb2uXPbri6DjCONVPd7faGtAD/UoycOWULYdWZIiDFGtU2SS2+10Bsa+qg9N8fphKhuBDxOAua2NQ7Zy65Tunb1rhz2WJTD1c2zj5iN8mm1YqxysIpb7PPT4xRGN4+T87xgdKnp80yAey2jP/tA0UzxtwoJYnX170jOqIBTDNu/fsyKEs4t8e3ma03VMqJK9QHwEgm4m6fEhEyeVsZhQFyVri2TMTjqnpA4/+9dWlvl/ga4TmbCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------8ltgeDxBJN0BN2U8yZ01aJMF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/23/26 11:38, Pedro Falcato wrote:
> So, the question is: why the heck do we need a copy? PMD is still allocated
> by the time we flush the TLB. Why doesn't a simple pud_clear() + flush_tlb +
> free over the pmd Just Work? Am I missing something? The git log isn't
> clueing me in.

Yeah, the original changelog in here:

	commit 5e0fb5df2ee871b841f96f9cb6a7f2784e96aa4e
	Author: Toshi Kani <toshi.kani@hpe.com>
	Date:   Wed Jun 27 08:13:48 2018 -0600

	    x86/mm: Add TLB purge to free pmd/pte page interfaces

is a bit vague about what it is doing. I think there might have been
some confusion around speculation:

	speculation may cache pud/pmd entries (paging-structure
	caches) when they have P-bit set

Because, as far as I know, you can't have establish an entry in the TLB,
period, if Accessed==0. I think the changelog imagines a world where the
CPU is establishing TLB entries from Present=1,Accessed=0 PTEs. That
just doesn't happen.

There are only two ways the CPU can find a page table entry to cache in
the TLB and start setting Accessed bits:

 1. It walks down from CR3 and finds the entry
 2. It starts from a mid-level cache and finds the entry

This takes care of a walk from CR3 (#1):

	pud_clear(pud);

and this takes care of the mid-level caches (#2):

	/* INVLPG to clear all paging-structure caches */
	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);

I don't think there's anything else to do. Right?

I think that means we can do something like the completely untested
attached patch.

Looks like Mikhail came to basically the same conclusion.
--------------8ltgeDxBJN0BN2U8yZ01aJMF
Content-Type: text/x-patch; charset=UTF-8;
 name="pud_free_pmd_page-simplify.patch"
Content-Disposition: attachment; filename="pud_free_pmd_page-simplify.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2FyY2gveDg2L21tL3BndGFibGUuYyB8ICAgMzAgKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMjAg
ZGVsZXRpb25zKC0pCgpkaWZmIC1wdU4gYXJjaC94ODYvbW0vcGd0YWJsZS5jfnB1ZF9mcmVl
X3BtZF9wYWdlLXNpbXBsaWZ5IGFyY2gveDg2L21tL3BndGFibGUuYwotLS0gYS9hcmNoL3g4
Ni9tbS9wZ3RhYmxlLmN+cHVkX2ZyZWVfcG1kX3BhZ2Utc2ltcGxpZnkJMjAyNi0wOS0yMyAx
NTozMDozMi4wMzU2MTA0NzUgLTA3MDAKKysrIGIvYXJjaC94ODYvbW0vcGd0YWJsZS5jCTIw
MjYtMDktMjMgMTU6MzY6NTYuNjYzNzQ3NTg2IC0wNzAwCkBAIC0xLDQgKzEsNCBAQAotLy8g
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKK3B1ZF9mcmVlX3BtZF9wYWdlLXNp
bXBsaWZ5Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKICNpbmNsdWRlIDxs
aW51eC9tbS5oPgogI2luY2x1ZGUgPGxpbnV4L2dmcC5oPgogI2luY2x1ZGUgPGxpbnV4L2h1
Z2V0bGIuaD4KQEAgLTcxMSw0NCArNzExLDM0IEBAIGludCBwbWRfY2xlYXJfaHVnZShwbWRf
dCAqcG1kKQogICogQGFkZHI6IFZpcnR1YWwgYWRkcmVzcyBhc3NvY2lhdGVkIHdpdGggUFVE
CiAgKgogICogQ29udGV4dDogVGhlIFBVRCByYW5nZSBoYXMgYmVlbiB1bm1hcHBlZCBhbmQg
VExCIHB1cmdlZC4KLSAqIFJldHVybjogMSBpZiBjbGVhcmluZyB0aGUgZW50cnkgc3VjY2Vl
ZGVkLiAwIG90aGVyd2lzZS4KICAqCiAgKiBOT1RFOiBDYWxsZXJzIG11c3QgYWxsb3cgYSBz
aW5nbGUgcGFnZSBhbGxvY2F0aW9uLgogICovCi1pbnQgcHVkX2ZyZWVfcG1kX3BhZ2UocHVk
X3QgKnB1ZCwgdW5zaWduZWQgbG9uZyBhZGRyKQordm9pZCBwdWRfZnJlZV9wbWRfcGFnZShw
dWRfdCAqcHVkLCB1bnNpZ25lZCBsb25nIGFkZHIpCiB7Ci0JcG1kX3QgKnBtZCwgKnBtZF9z
djsKIAlzdHJ1Y3QgcHRkZXNjICpwdDsKKwlwbWRfdCAqcG1kOwogCWludCBpOwogCiAJcG1k
ID0gcHVkX3BndGFibGUoKnB1ZCk7Ci0JcG1kX3N2ID0gKHBtZF90ICopX19nZXRfZnJlZV9w
YWdlKEdGUF9LRVJORUwpOwotCWlmICghcG1kX3N2KQotCQlyZXR1cm4gMDsKLQotCWZvciAo
aSA9IDA7IGkgPCBQVFJTX1BFUl9QTUQ7IGkrKykgewotCQlwbWRfc3ZbaV0gPSBwbWRbaV07
Ci0JCWlmICghcG1kX25vbmUocG1kW2ldKSkKLQkJCXBtZF9jbGVhcigmcG1kW2ldKTsKLQl9
CiAKIAlwdWRfY2xlYXIocHVkKTsKIAotCS8qIElOVkxQRyB0byBjbGVhciBhbGwgcGFnaW5n
LXN0cnVjdHVyZSBjYWNoZXMgKi8KKwkvKgorCSAqICdwbWQnIGFuZCBhbGwgaXRzIGRlc2Nl
bmRlbnRzIGFyZSB1bnJlYWNoYWJsZQorCSAqIHZpYSBub3JtYWwgcGFnZSB3YWxrcy4gTWFr
ZSB0aGVtIHVucmVhY2hhYmxlCisJICogaW4gY2FjaGVkIG1pZC1sZXZlbCB3YWxrcyB0b286
CisJICovCiAJZmx1c2hfdGxiX2tlcm5lbF9yYW5nZShhZGRyLCBhZGRyICsgUEFHRV9TSVpF
LTEpOwogCiAJZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BNRDsgaSsrKSB7Ci0JCWlmICgh
cG1kX25vbmUocG1kX3N2W2ldKSkgewotCQkJcHQgPSBwYWdlX3B0ZGVzYyhwbWRfcGFnZShw
bWRfc3ZbaV0pKTsKKwkJaWYgKCFwbWRfbm9uZShwbWRbaV0pKSB7CisJCQlwdCA9IHBhZ2Vf
cHRkZXNjKHBtZF9wYWdlKHBtZFtpXSkpOwogCQkJcGFnZXRhYmxlX2R0b3JfZnJlZShwdCk7
CiAJCX0KIAl9CiAKLQlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpcG1kX3N2KTsKLQogCXBt
ZF9mcmVlKCZpbml0X21tLCBwbWQpOwotCi0JcmV0dXJuIDE7CiB9CiAKIC8qKgpfCg==

--------------8ltgeDxBJN0BN2U8yZ01aJMF--

