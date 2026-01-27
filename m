Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F5ED25958
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1888E6B0089; Tue, 27 Jan 2026 02:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132AA6B008A; Tue, 27 Jan 2026 02:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A8C6B008C; Tue, 27 Jan 2026 02:25:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0E726B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:25:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 697C1C2C40
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:25:12 +0000 (UTC)
X-FDA: 84376907664.20.5F1B03D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE281A0007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:25:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nwHlpVjA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769498710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8SgAV9h1Zn5PVX1BsKjC6XEOwdgXQQ1A2jF1T2bUkU=;
	b=Egv+1pjO7kXqAhGDBEEqDD+GwJt/mTurBeaHYsElC5olJMjYeCsPm5UF9ko4o6rM8QYPia
	F2s+Kug9ZszJqA/MSMw1XD9f8oO1uuMgCddI0ZxH9z/adTHIisn3FdKRGwnXhNrWMLfQRE
	M30iUobGpwEbtID1EiSZOd3Ws7i4SE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769498710; a=rsa-sha256;
	cv=none;
	b=4IupSFbROFonEml6wryP61cSdCivwHwOl501SnhoeqQyCwBaiz7oFFdPqtQPkfdL0QoADd
	sqq2gfMPuW5y1d5gSPKNIzfjmtDQKsWQK8fGGNceLmfnA9wZUEFYu93iWlc7gFucibmHBx
	gqbFnx7ZsY+uH/wqDKJ5KDb5QXsQ08Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nwHlpVjA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BADC2400F1;
	Tue, 27 Jan 2026 07:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF86C116C6;
	Tue, 27 Jan 2026 07:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769498709;
	bh=NM/XyGcuu3oC40AjWHvNWgcayap1TyIPrLlqNMwrM1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nwHlpVjAUt4dHIEIKRYYNtICbchdIO4PS4BHoBalmKmLFKuaBGTgx0x57HuhDNT03
	 QJZP41o3Q0bN1Wla3i3pM/m16YT6ZP3gPIubbAakGqvBDIrbRRYKpMcAcIifJeEH4t
	 ce9W9LgL69U2JPtrQHEPwjtZ+FY13GlL98uHYUW4vm5b+rTsBM+YWfGXNlCQLGOavc
	 ae2wD7gP2t2o+NnORLMcHB1+aeatGIjHuGRLba+fppZAAlBPPeTVgecBh7R9DUYFki
	 iacaQc++NTBBkdWDmFfN8Geel4YHv1vxCzF1d6E9eADcVmoJmaKJlC+zr3NY77bluZ
	 sehFo4vHlyz3Q==
Date: Tue, 27 Jan 2026 09:25:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v5 1/4] kho: add size parameter to kho_add_subtree()
Message-ID: <aXhoTWqxIGNglgdV@kernel.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-1-7cd0f69ab204@debian.org>
 <aXhn8ieKtj3T3FCc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXhn8ieKtj3T3FCc@kernel.org>
X-Rspamd-Queue-Id: BE281A0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1mxzw41kzqpser1hzyhure6hqq1s8wxb
X-HE-Tag: 1769498710-16573
X-HE-Meta: U2FsdGVkX1+OS0oSnQ0qxjnI356YjADpjLRIGeJ0MVKLm6Cg15WupT7oepjjwg0RfdkZP4t9EdUQQgUZL/9fEp1dfI1Gvyt0Y9ZHWGvIouT42Vn8Yi1E0UQ9jEggndFeIplJitLGWeALjZ4/m6Lv+dG7W8mU/d5wu+lNZKMVhVe1o/3CaaEgdf18F5+tps0zFrd2RKYRsZkprAZeyN3Hu1ByQiU1cmR7jQ3LF/wLQto8G2OIKiuPkcpTxCBmGc0qt9ZCZqJ0i8CrHtIkB8Wy9AxNz0D13xBgx79wUQfC5Q48dmLvuVPj/P7UeLMJBEwUvJvMOGb0i9Q1jsUnqRYhXiMU1KLAh4ZXpXz3DaNy2mUOnQwKfhFmBTDB2fr+I6dul6J5yZZchUarYdkLPFiWfVUI9gBJBNUSoe1xy7W9fRGcYLriVgxGXgmz4ThMFcgdzrz+cSY6MuCpYnqmSogHItUvmF23Ep2GmtmdFrb8YclGtxlUy6hQeIbBTfgwU4pLH9Ql63lnb0kuJPbfZDWzLZRjzPX+ctkSM5d25YNG5NX4kKYHphml+BcAg6JTo376zhnn9mVU8rI7CWECXkAZ9Ipol8koaNmPEljUBmilztB2wD/s6nppSGnkGkHo8Obdg7TpV0tUBKjhzKJ28zVI3P8XCDpQeAAoQ14FrE85LJX8nBPjn1UuGmMX/7eEgHZDTp/cgcRR8Kd2whNtABwGG7tGR6pZvxXuiB0mlCAlOUdLnwi+0HJxcLfudoXiccEoKZJKuRrXAT1Bih9/BArIQEECK60WTsK8EFq7nPtuq27n13mHfxuPQXUBhndRzY7/u2bdKksTd95qYZFANus5Fem2Q0oI2IeSHFgLzeSa1vGPgQ4gXNSg33UhakSqogxj6Sdv8Aa4pgTAPnXDrWkz5ElZt9NPSltEmiIgS4ph1mBtSEDOHUbkyO3QhKSmWk//eFgEmp8XLJAlqVtmzHI
 ipI8wjrL
 E4Ec5lC+8D6GMTCtXWiP+PGgcwKKcVbrMZUnFYHg6yzRfaZMluMOYlr7sGt3ZbGpZLxa573kkFi4rl3id5xKuzeDFXIyRm9SY6FWVhisUllX0BDyaSg9fbzLkoF5dSmlDdPlJKYm40Z5kkJFoe0pBaUv9PfRt5ZKMvtSiFzsjSn0G99aF6btuztFu29GAmFhlGeheRbz2E6Z4FTd1xF2Zx53F+9NLASxWx9HgUg1Guy/jahZ0WD1kkcsPKMi9tZ/onCSDe1KqJ61wWlApS9wKVjU5jO/872PgwpBvaP7fYv1rieoTPzC+CBxSSLLLhYzFCLZ8+wEqMoR2vXPtsO3qfRZNPNuxI7meYGzA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:23:38AM +0200, Mike Rapoport wrote:
> On Mon, Jan 26, 2026 at 08:07:23AM -0800, Breno Leitao wrote:
> > kho_add_subtree() assumes the fdt argument is always an FDT and calls
> > fdt_totalsize() on it in the debugfs code path. This assumption will
> > break if a caller passes arbitrary data instead of an FDT.
> > 
> > When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> > calls __kho_debugfs_fdt_add(), which executes:
> > 
> >     f->wrapper.size = fdt_totalsize(fdt);
> > 
> > Fix this by adding an explicit size parameter to kho_add_subtree() so
> > callers specify the blob size. This allows subtrees to contain
> > arbitrary data formats, not just FDTs. Update all callers:
> > 
> >   - memblock.c: use fdt_totalsize(fdt)
> >   - luo_core.c: use fdt_totalsize(fdt_out)
> >   - test_kho.c: use fdt_totalsize()
> >   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
> > 
> > Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
> > for the root and sub-FDTs it processes, since these are known to be
> > actual FDT blobs.
> > 
> > Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> > ---
> >  include/linux/kexec_handover.h              |  4 ++--
> >  kernel/liveupdate/kexec_handover.c          |  8 +++++---
> >  kernel/liveupdate/kexec_handover_debugfs.c  | 15 +++++++++------
> >  kernel/liveupdate/kexec_handover_internal.h |  5 +++--
> >  kernel/liveupdate/luo_core.c                |  3 ++-
> >  lib/test_kho.c                              |  3 ++-
> >  mm/memblock.c                               |  2 +-
> >  7 files changed, 24 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> > index ac4129d1d7416..abb1d324f42d0 100644
> > --- a/include/linux/kexec_handover.h
> > +++ b/include/linux/kexec_handover.h
> > @@ -32,7 +32,7 @@ void kho_restore_free(void *mem);
> >  struct folio *kho_restore_folio(phys_addr_t phys);
> >  struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
> >  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> > -int kho_add_subtree(const char *name, void *fdt);
> > +int kho_add_subtree(const char *name, void *fdt, size_t size);
> 
> I'd rename 'void *fdt' to 'void *blob' to make it clearer that subtree isn't
> necessary an FDT.

Scratch that, I didn't look at the second patch :)

> And s/fdt/blob/ in debugfs function names.
> All this could be a separate cleanup.
> 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely yours,
Mike.

