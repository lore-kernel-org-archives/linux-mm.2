Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920CCECD995
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71406B0089; Thu,  5 Feb 2026 13:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F2C6B008A; Thu,  5 Feb 2026 13:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D9E6B0092; Thu,  5 Feb 2026 13:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDC36B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:25:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A9BF8C182
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:25:44 +0000 (UTC)
X-FDA: 84411231408.03.51B4A85
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 494C620002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:25:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770315942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNmwi1z8jZDjnrZLEVDb5PYedyOIG7zSKo+esztDpAw=;
	b=ppBAnjXWhw84xlpif5wdLB1vhqJxgSrSg6LYaGK9LU0bZqoMQFUmsEIar8+PMrduCXcGbr
	HzjEDPPzOD1nB67bpk7sgA2YaLyQm2S3Fe/HlWzIDsy4wz4m/CS6MHlkBKmh67HPBrhEB6
	6ymjReTuMYZ7h8defITIADYSmQvh2gM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770315942; a=rsa-sha256;
	cv=none;
	b=MxlgOFQ2RncNemjlAuWSNhz2sAWMS5qCIu3j4XCQCgr97V9YkaQ53YJA/cY8Vl3ex6Ush+
	CKd/AUeFmwumczMG7zc9YrS3eBOoTlDyHyq1OIES7GqcsGaHXRyn6bLHJ54F+ABo+8Zj3O
	v/qcc7m6IM3+1oMSxR1siqAVmAsnTv8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7851A339;
	Thu,  5 Feb 2026 10:25:34 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 037653F632;
	Thu,  5 Feb 2026 10:25:38 -0800 (PST)
Date: Thu, 5 Feb 2026 18:25:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYTgoFQjEs_5WyC-@arm.com>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
 <aYSp0--x_QgyiUWL@arm.com>
 <aYTVAeMm5cFnuAL7@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYTVAeMm5cFnuAL7@willie-the-truck>
X-Stat-Signature: 5btbfkfsjsdzcd988qtypow5w98zimxr
X-Rspamd-Queue-Id: 494C620002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770315941-720895
X-HE-Meta: U2FsdGVkX1+R7HURMJKLVyfCvPE+z3nH77XxEyotwv3MMsA1n7k2Xhn9f/7Kzl3120Lb+8Af3DjqEN6kj3fj4kiBszDuWTDzoqfEAJW3BCuIOlIo3tq6aGrS6yB8bl5bOkOZtJ0hSyCVkj3HOtmSrytui7k3SvggjTcfgyUV98AgwwsL2xJ+EoHY+hA1QL3A5NQGHtoSsdg9hVKPLCMdpt3/0TdiNyaCBExPedcSQ1KyNZuez+P9mpFLI99IID4SG1/Gh/CvkV5b7McmNTnTkB7QTbUj4snWXvQiht8nWZCsAFtCvJyNn4OhIUgjiFS07u+h/LmTZZoWNxx3wFT7vtO+BQTecQ3aSdrBrBUqoWg8Vt9EZnRYn/WVwNZHnD9dXrfOUPbRf09DUuk5zsqB074btWhkSeX+lXK++YSiG+Jzx935UgIfHXSAezeOqCDM6kGY0NnY2bSlEEUh4gJ/GezGGMKMKFmVmeuAbrZWZZVy/7ilY/s3jLW5zO8NINpQNTYdsmTsD6uDSBqo3l5coaKqDkUDoTKBk3fbcWLt6npXr+GLpjwHORPjYfYJbyLlUIe0jCJH4XSKJRuZ4wjvOJf8zrHGjkE46tA4jo7l67sR2lDCt1wmxtZSh3lpaa1Qpt1wrAqrG1NjHqdsKIodf8EI+C4xQAT1m/otUGza5LiQt/s15H2TT825YkfNF94Ail7xCEWykFvjvRu+rAFcyjRfFRuGoNUrClK/HeIVYQ254Eo/xOsuVCwjspXtgWwlJjzan9YA7CgdtCUY12RSxZHHpFLO7nhU0T5CehaJnAsCztqJJX3Ku2DJQripqe+OSJf8ptvtiPaFvhvP3wJOghXGOPdFjlm0Gm353QZ1CHMn6sJJbohDXsLZT94nofGOiibBSBMshr/JVeIXUc5SwhQkkfJyOh+9ma1RSDWhtaC4HKjmv5yK8tKoYFKUGilPY8DibNdXNOl/VQmivbY
 gocY0GhE
 sMC9Uhm5wri63Qe4Hpjm5YODv69le62wwax+T5ody/3odyOUBruDb6dpiJ7kG5u5raxl5e38PMxtZEN8WN8IZxmC94g0jsNSElIfEQUfqoQ0W9wOgLCod+4iCysuLgoOr4IJN76DD7iS9UBNzER6NMqbK9nAY5AE/tw590tWI0zFJnoz4OXdqJ+8MtDRme32pupC/OFe+aAvA7B//4I0rH9D7cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 05:36:01PM +0000, Will Deacon wrote:
> On Thu, Feb 05, 2026 at 02:31:47PM +0000, Catalin Marinas wrote:
> > On Thu, Feb 05, 2026 at 03:23:27PM +0800, Jinjiang Tu wrote:
> > > 在 2026/2/3 17:23, Will Deacon 写道:
> > > > On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> > > > > 在 2026/2/2 22:55, Will Deacon 写道:
> > > > > > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > > > > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > > > > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > > > > > +{
> > > > > > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > > > > > +
> > > > > > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > > > > > +}
> > > > > > 
> > > > > > Do we really need another arch helper here?
> > [...]
> > > > My point is that we already have the helper: ioremap_prot(). Just fix
> > > > that for arm64 and cc the other arch maintainers if you're not sure how
> > > > to fix it for them. What we don't need to do is add an additional helper.
> > > 
> > > ioremap_prot() may be called outside of arch/arm64 in the future, and I think
> > > most of the cases will not pass a user prot to ioremap_prot().
> > > 
> > > generic_access_phys() is a special case, so I want to limit the modification to
> > > generic_access_phys() only.
> > 
> > Or we can just have an ioremap_user_prot() (or some more meaningful
> > name), defined by default as ioremap_prot(). It's still introducing a
> > new macro though, unless we go and rename it on all architectures.
> 
> ioremap_prot() has exactly one caller outside of arch code and that is
> generic_access_phys(). We should just fix the arm64 implementation of
> ioremap_prot() and not introduce any new macros. If a new caller comes
> along later, we can figure out what to do then. We could shout if the
> prot isn't a user prot so we detect the problem.

I was more worried about out of tree drivers using it since it's an
EXPORT_SYMBOL(). We should remove the export anyway given that we have
only a fixed number of memory types programmed in MAIR and all have
corresponding ioremap wrappers already.

So yes, just fixing it in ioremap_prot() works for me if we also remove
the export, just in case there are dodgy drivers out there.

-- 
Catalin

