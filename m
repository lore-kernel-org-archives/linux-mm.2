Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C98EE2084
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 12:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC9F6B0088; Fri,  6 Feb 2026 07:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6932C6B0093; Fri,  6 Feb 2026 07:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B87C6B0088; Fri,  6 Feb 2026 07:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45D8E6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:08:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1152A1BBEE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:08:25 +0000 (UTC)
X-FDA: 84413909370.18.F5B98F7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id DBB001C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:08:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770379703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayN1nEXbKph78i6N6fCvUEeK9hz4SxZBfGel9uBR0AU=;
	b=qKitOcOsT39nsQsEZNs2uIhGF1blV0F48teW1SgMpm9Ek79gfF3Eh5b669mJoj19dFlWcg
	LIYOPL9qwGWt0F+hrcHAprkS12DS1+Siw1XT+4LTyHQ7bimHct2q4hhMOTJpcArFpL4oS7
	0yzcigmSrpwo2pLaypNBToreXdZ8Nb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770379703; a=rsa-sha256;
	cv=none;
	b=XUaGoMxau/AkEPlrD3Ix+aCx7vfcfXd7pZOmg/wyLM2p4pzwlz1ua17Hf1tUU9kvtArFap
	bNprKTwLEP0NHeIM+qiGMjpzETR5KpHY0Cvm9sdC25ilgTyapmasjEuZqADzfG+VikAyb+
	Lh6L0eiT1Nw+fsh1/4swiylcNwXkvxk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 534AA339;
	Fri,  6 Feb 2026 04:08:15 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 181903F632;
	Fri,  6 Feb 2026 04:08:19 -0800 (PST)
Date: Fri, 6 Feb 2026 12:08:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYXZsRpmQIb7q83D@arm.com>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
 <aYSp0--x_QgyiUWL@arm.com>
 <aYTVAeMm5cFnuAL7@willie-the-truck>
 <aYTgoFQjEs_5WyC-@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYTgoFQjEs_5WyC-@arm.com>
X-Rspamd-Queue-Id: DBB001C0006
X-Stat-Signature: mtddxfi9kxggfcfdtwzx5yo9k5pnn4om
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770379702-131822
X-HE-Meta: U2FsdGVkX1+EOw798AUca6sB/I8l98+17Iz2hwjgdE0Eu15NT5iNfTnwMd5qoh/ZYPgdvWCRmPuKN2U0TVwwYnmlZ5oM5bm7JAHntlCoQlGPfuAuJDNUgC1SoZ4QtmkvBM7zknjlHHK0tdnEwLcbBBwYHC22GcHiQYb/phZB4GfvhT4nswL1D0SKfVHecc2Tdi3dKs8VtlH9Tk4fv/Oc0srBYcqwy404Ori/G5+hDv5Iob951Io/36vOPbztbbqb+A0lzQin8+xEE6eD98VnA/U8KQmOBTkI2huXz39B3cvPh+s3XxIfFzAsOTC92iK8lY/EX8FdNZYRwycnwp6pRpL7RLH3VHYkCmxc2tWzf02x7Vzw2TNVv+3dpLVeTSv1xwIduUEomTe+11SMvCF31hPSWS4o0153/okj/KKmfsr3H69ede7J/l2IrMqyg0/+sz5o4Pakgu4FuwTAq03bs4FOnkQvRMHP5oqyr6UbIMU3whcOd9HPMfwG6Vk+ZMxNhSOFaPluPGl0Blx+oUi6wFSrU7QkIdLoM5vvEade33bOWemsZJ0kSTbNgE6iLMlpqJwNQUtewDvNKJ0AtZbkn6M9DcojzQ5In3lyxp94zw9xg1OC4MB8xq1q5BQc6pRZOGE3pgBh5NOJjnX5TxHoxju48OTj6MQHC+ZeJQugoyWn8Jq5bXEtNkp5kRCedZ/muAcBgwkp9gLKMT2S9cLueVn15X/8mXcTO/+xEXj5bJ4Fn2/sexN9MRRY4YStepM6PeWQ49jKPmmNKg04BehSHYFEHI5p1useFeYTHOwI6zYjYTJn+X46cjSlpPvb6Qd5/VkrQOs5WZiWd6oh4xJEpgergP2zQL60Ae7ESLlxst54TkBUTBjDJyCaU57L5Yn/HJUjxMlWFvSH2+g6qJwdzwSx1MjKqiPnuug8bOPkuYXVX8so70+Kd9L8/LoJWfzoaaalqpPqq13EMfDJMDm
 1bULQQar
 2MDxYm8pWCJy2cXuyxVLPQkMXFroLOahTvQfbm//KbFbf230s4G1nTAU+m2IzrKKTo8SluvAnyFufqQVfe85T57mqJX4fIy31oVHhBe9fKOdV0MO6isv7YzrGPk8MYL4B8guZNwsRJ80KASTZbiqVmfn/MVQDEmzHazJhhzuD7yyH755ivTmlvORsYua8ZvGKrXH5pCdJdFzWuUratNkIi3NKcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 06:25:36PM +0000, Catalin Marinas wrote:
> On Thu, Feb 05, 2026 at 05:36:01PM +0000, Will Deacon wrote:
> > On Thu, Feb 05, 2026 at 02:31:47PM +0000, Catalin Marinas wrote:
> > > On Thu, Feb 05, 2026 at 03:23:27PM +0800, Jinjiang Tu wrote:
> > > > 在 2026/2/3 17:23, Will Deacon 写道:
> > > > > On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> > > > > > 在 2026/2/2 22:55, Will Deacon 写道:
> > > > > > > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > > > > > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > > > > > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > > > > > > +{
> > > > > > > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > > > > > > +
> > > > > > > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > > > > > > +}
> > > > > > > 
> > > > > > > Do we really need another arch helper here?
> > > [...]
> > > > > My point is that we already have the helper: ioremap_prot(). Just fix
> > > > > that for arm64 and cc the other arch maintainers if you're not sure how
> > > > > to fix it for them. What we don't need to do is add an additional helper.
> > > > 
> > > > ioremap_prot() may be called outside of arch/arm64 in the future, and I think
> > > > most of the cases will not pass a user prot to ioremap_prot().
> > > > 
> > > > generic_access_phys() is a special case, so I want to limit the modification to
> > > > generic_access_phys() only.
> > > 
> > > Or we can just have an ioremap_user_prot() (or some more meaningful
> > > name), defined by default as ioremap_prot(). It's still introducing a
> > > new macro though, unless we go and rename it on all architectures.
> > 
> > ioremap_prot() has exactly one caller outside of arch code and that is
> > generic_access_phys(). We should just fix the arm64 implementation of
> > ioremap_prot() and not introduce any new macros. If a new caller comes
> > along later, we can figure out what to do then. We could shout if the
> > prot isn't a user prot so we detect the problem.
> 
> I was more worried about out of tree drivers using it since it's an
> EXPORT_SYMBOL(). We should remove the export anyway given that we have
> only a fixed number of memory types programmed in MAIR and all have
> corresponding ioremap wrappers already.
> 
> So yes, just fixing it in ioremap_prot() works for me if we also remove
> the export, just in case there are dodgy drivers out there.

Ah, removing the export would break KMI if backported (unless GKI won't
merge it) since all the other ioremap_* macros use ioremap_prot(). Well,
not a problem for stable/LTS in general, just for GKI.

I would still introduce a new ioremap_user_prot() to make the intent
clearer. In its implementation we could skip the ioremap_prot_hook().
For generic_access_phys(), do we even care about encrypted/decrypted
pgprot?

-- 
Catalin

