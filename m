Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29D1F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A0A6B0089; Mon,  9 Mar 2026 11:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6139C6B008A; Mon,  9 Mar 2026 11:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540816B008C; Mon,  9 Mar 2026 11:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4466B6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:40:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D34A6B6FA5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:40:18 +0000 (UTC)
X-FDA: 84526936116.08.F5E2B21
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE3F82000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:40:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HNX5zIrr;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773070817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BH5jW73g8Nbb+MOjYtZX3x5WWXhBibQwMiTFmg8NspM=;
	b=LunyG49oPPCVfOOrxhRQ5s2kh2MBBjFIaDBphoH1fvHbgSI/4K4Qt5nFCwuWgEDhF6y20K
	eYfATRNgJCeS3ycj3R4l77xG4L+dP9r0p7aft1HjR9hM+Dd9mo0qrT1kDO1tg6bHnLau8O
	6RFdG9PvgC5l/MQiL2wQj6B+JFkY1JM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HNX5zIrr;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773070817; a=rsa-sha256;
	cv=none;
	b=CknqS2jSuAFGNN9raQK2d826ojcCK9O9QuBQPNqHi+OkdXm9NKq5rM7YK6L105K5AaNE9H
	wzTLGsY4DCjwHP54ZMNWKp4kmyqpkgMMSBnjez6+7dyxUS62yl4x+qcs94cMrSfIhAHLo1
	hIHRb/IGj7hIn9LS8MmYSgRkK2PGSE0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BH5jW73g8Nbb+MOjYtZX3x5WWXhBibQwMiTFmg8NspM=; b=HNX5zIrrNTdc66q+DRzxzxmDJh
	aC+4Ui7AidvvtENeSLq1FUXKwWB0VMSnDToWmHjVpUYPQmLC6/xFedb1FOJEiIWjLls8fEtBbGcmx
	RH+PakbfC8kUJOCJM2sRAOCYYvmbgH/ISeP973YAcPe7tCVy392sdlYBCWxTObifkis+favDEVuE1
	wZIl304YuROD6csuFgI9Z49+rXJ7oDmnoWnJpWDF1jqkNuv+LTKa3rRQ3kRiA5hghMH+YwFjeD7CQ
	02v3UuDQ6kTLCSdaVs1bRdaASzR9XI5mXRer/cAJNiQYcgj/lYVEQhgo+zcHR9cZvM2G0H9YLIngr
	8dxwxjVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzciM-00000006AaX-0gpX;
	Mon, 09 Mar 2026 15:40:14 +0000
Date: Mon, 9 Mar 2026 15:40:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Xie Yuanbin <qq570070308@gmail.com>
Cc: rppt@kernel.org, david.laight.linux@gmail.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	morbo@google.com, justinstitt@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Message-ID: <aa7p3eQfEuh2wObQ@casper.infradead.org>
References: <20260309153811.40958-1-qq570070308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309153811.40958-1-qq570070308@gmail.com>
X-Stat-Signature: h3nmiab1bsrgzjy6dtfcjomsrwzgzh83
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DE3F82000B
X-HE-Tag: 1773070816-718588
X-HE-Meta: U2FsdGVkX193spBl5s6SgEZL553hz2A7JvxC9x5qWWMUgZLs1LhJdYSesUSQZEYHihAcQshoVn9gCW0hzOpaGDi80KT0IWRR3TARKBEjdmMwAD6T2Cy6JrrRWSf+lCyGEO2UKV9bpsWuECA3uNxQdWJrACuT+Y9GR0zksjGr3UT27/qEpQ2aVnRdK2OY0Q1QDnlQdGJp/hJ7z6RbYNBkZFacQ1VsTzb7r4Rx8LK21uoOuTggkTZOTmo4NwXvpmUu4aOHwQ7D3bwzmmjAr3vNPJj7ijx2zzmFqhz2/9Xgm/RUTxiUsbo1YVFa+K582BGuhdkpKJJUIUrqW3C0M9eHtU0eTlFgOJgoqwJGsOoDvkIQD6LIcaVITSQI7prLQLrtZEaESSmqEvZfBGVJVGdQdfjZM5yoT4Hv/gj70EEGJ5XMdkuzDFpuURQjDqcbXO8xAdcLyOTYzwtLPGolE29yVT6iYufOcluzNcKs5WpwwnM0CAC1G0vBVOU2exYJinAqv933JcTrMhSS/aKKIubaZppphwT6Xw2IgJT0juSecAbba34Xn0KKuogCWjjUghQvtmduMzU4rxy00PUKDkzc1F/pAlLDl01XQE6BQcw4HTvxVrdn5OT2S3t57Y2rPa3YXWS/DlU4n/5f380tA7kA8q4gTM37mPVG+7bxQJBjm/kwKTxiKJ2D8xaiqlMyEqGEfVH1NsZDmf24dB50Xm7+kLgkvBQhDlQ9htZ69vDoQ31/MKuk2y/5OG5XM+OF+bxkNiSuHFe19xgLLqol2IfSojOxGR2xHtstjllba66JKUxGAv0lV9sWBsXLtVFYy1yfbfnn2L6WTd2We1iWQFvyI69C50gS7XJUlvcQ9n8ZcqLy8x7ZVTOiXPTmEVLDNMFpD1kBH+lNMh9N53IGLDwhYKtl4xqx6gT7FOARrK4EKtCN/z+XThV9UQyGyaQGjPm5gP34MVUeC/N/++CRhNc
 wS0HuCtR
 QOF4650insmaB+zRmZoCcMBpcd0h1H8v1Fuis6+gtfkkuMMnhOPo1YCAlzC+SS0kMbPkgR5j6MxfSMyhmHH7pxo6ykaxfiSGN2nM4BDK+glQp2FobrwdbSUb826d7rQntdl/7S7B3+pd/w+ylP83GVXrA5yunuIshFnVbQBIxkHDICpAz7vadsx/66SkaIfCSepxeFx8pr/wqM2E9XPK1zd0eDIqr3F7Wou8bGCWdHbJpigk0u1CvRGCLd8kxmCk7cznz1htTNoTIOXW1LEhEpAoAyA72PRPR4Cz3T2AfEUGU7e8vLDXhMCGz9BQfEEwBzoh0N2KVqhpX+m2wAqSRdnWBvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:38:11PM +0800, Xie Yuanbin wrote:
> As shown in the commit message of commit 242b872239f6a7deacbc
> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
> the code "unlikely(a && b)" may generate poor assembly code if it is
> actually "unlikely(a) && unlikely(b)" or "unlikely(a) && b".

Why fix this in multiple places in the kernel instead of once in clang?

