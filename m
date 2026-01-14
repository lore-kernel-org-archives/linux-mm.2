Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0858CD31A0C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 04:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720C26B0089; Tue, 13 Jan 2026 23:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAEA6B008C; Tue, 13 Jan 2026 23:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8016B0092; Tue, 13 Jan 2026 23:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA6D6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:20:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED8D0587C4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:20:01 +0000 (UTC)
X-FDA: 84329266602.30.88C4859
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B02DC000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:20:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ee9idtSQ;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768364400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxeqQvnZbeUxm2rmH1In1OgW9xKfSYGFaWwGO1Z49co=;
	b=bZusOMHZEl4te3GsZqJ3nbom+NtrZmZClkLjvqvenbsVnE/Ijuwmiid9vgAJpRIjodo+ox
	uUfX9yHkB2izgAXjkD2Qvfc9O3YrMBaUpvfbn0NuMsQGh6bL+F5VLvWKepZfGS5y3w03ru
	vSPT1eM/5I8XEtP0f/j6j7iaFCXffbo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ee9idtSQ;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768364400; a=rsa-sha256;
	cv=none;
	b=Ybb6jSucHkCuM6vOPUns680WTtLSKxR/DbKKHW/DMFKxA8aju9G8Qvw9futMEcF3wvKUiO
	8XFkGW1iEyjWht745VUs5GL6KGMEPGqrrxj00agdJcPM/WKgyoTyiE2IV2WHR6p89BgBYG
	kWk6MmyWoad1j5khPx9zEwkwlh9tGLY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jxeqQvnZbeUxm2rmH1In1OgW9xKfSYGFaWwGO1Z49co=; b=ee9idtSQgUTHRWt9707M2qVZni
	ZFAby3K+K8qceQTZAOefoQnUlPMTjqjNwV1bAP2224bg0JdLcIeTQWjeBB+A6P9B0Jz3Z1OgxueMh
	PmumtQUBZoLu5UmIBREUclae2XGYveWp3VECZ2+FSfZBCtolSqbzy5JUC4U0Ua+Npa5UclrTm16Ox
	Ta699XrmiftixI0M7ZH0VfnmDORL02NfBe9Zwyx1WzxqHDzwM6z+GVV2B3+ILWPi85OtfemuIGnQH
	Ibm1GkatwpwfO8n1T1Z6kk1dJ/mO6+2TI1CV5qHZ+m3GKth9YyPelI13MwzkMIkop5tjljtDFvqdV
	q6sSNM0g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfsMO-00000005fdK-2Wct;
	Wed, 14 Jan 2026 04:19:56 +0000
Date: Wed, 14 Jan 2026 04:19:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: wang.yaxin@zte.com.cn
Cc: akpm@linux-foundation.org, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, david@kernel.org, vbabka@suse.cz,
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	xu.xin16@zte.com.cn, yang.yang29@zte.com.cn, fan.yu9@zte.com.cn,
	he.peilin@zte.com.cn, tu.qiang35@zte.com.cn, qiu.yutan@zte.com.cn,
	jiang.kun2@zte.com.cn, lu.zhongjun@zte.com.cn
Subject: Re: [PATCH linux-next] mm/madvise: prefer VMA lock for MADV_REMOVE
Message-ID: <aWcZbJ-YPUQA0CJB@casper.infradead.org>
References: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4B02DC000D
X-Stat-Signature: yyqrgzyqhp6fh9isrs6rhd56j74ke1d3
X-HE-Tag: 1768364400-55116
X-HE-Meta: U2FsdGVkX1+JvQ0KsHup0tUwLebCoXnzfsrqgBw2PDhnAi3pSsAnGdpiMFS5yoOAHKwTLUNfzQMwLB8l8WlCI5hkOobGqWFW3a7HXmzqmdZj0xhc5SzpPcT7Segr1MMwFVdG2VCBqUlkXJVU5ErES5MNCVrjyf6rwqknkDNZPFRX0sAzAcTsyrZioK0T/7H5PexLdcZs4DvQeZBdiUMOvICOO0ZvQk0Wz7EQAlo6+vtHZMsP5+LSE5zNUJMs3pKdUr7+gWIxwaD1oLQ+XFufQTxktW/bxn4S3Bwen5stSCKzz1A5LNsROZcgGfIMpbIyBTqe5FvliNwqs5cJ/pFxCp4nSsTrq3zxmM01BkzwZ+yzZiplK/kmjBOMeIrrA/mPg9OKb9E7iCGtAkygA61JEh+93RMBQBz6zzfXuuuKS2C5pm86vGB8RzKtTLUCnPuLhL6hltAQ1/qUaTiSplfY6cOz1bbvcQXUHaMtsAL1AihOBJNP0VXD9Yyc3YG+owdYgb7f8nzdcJLA2fhoViIx5NzVrFwUTyjcd1QEOYtf8dtj2BReeQiM8P/eqHU4qVRPEdQXBTosXx266gX95IZKkgDRAM8xE/5gVhWvNa7CIFzQE7sTq0sGFVXK1n3TNJwfvbRcECmq7taLchNGB9x795bOmVmAW0dhyx8efMlPNHeX+fd/klbFPzDd6tZ64c9NZHlRdkonk908zRLrv+kU38FseqTyEKPGT9u+JXtiTv+GVQOT911k2XGfsv03ViutuwUO6oRnqRVaxX/Bzuwu15Wq9cSDfvSsqrrRPmhoCyppx7kC9fTVtMhXqNkk1ZZ0LyGfplTOr63Wnmw4ohFR8TODplXXmS7X+vSqaXfCQS85CFwan41A1xvGEAtHO0PBrobjD+u7VkSKMZfEiDNDhW6ZjUtwbv7hOgj5h43aHmbFuVz5df8zTtSE4RS6mQZBC/RFsLK1SaHn7NRz0cT
 2szClgsL
 OqAVPA4hgIVvekbgxFKSJFOuqoVMWkOl/wed15daehUWNWKDKdrzolXOtOAoG1lcXU+YwteGmPrucb/FQHexNq0NeKKH8GFt2UdCI9ALp1JoYibQkqlVFwD/KUoH2OLu0fpvxhVjfo8yi/TLAturpXboMjzqqkgKBej3ppI4CR0v3M2LAL/pzFK3FVYCL+ZIkhd4S3IVBJTH8oQqvjk7scCvYy3cPl7kDx1OosXyIdQP2TO4oCWc2O3wYLeq98PuA7spTaXmzJxJLWnelvthTs19nUuC/J2bAHtw642W1rEFSHCDo3ijjRwLt24KBTxnLwpE+iuoHq/bspWyDM6C4kAjESy+TN6tmrSnoFRJtJDV6gNLUiJbzr06rwJOU2aEZNTb0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:24:17AM +0800, wang.yaxin@zte.com.cn wrote:
> From: Jiang Kun <jiang.kun2@zte.com.cn>
> 
> MADV_REMOVE currently runs under the process-wide mmap_read_lock() and
> temporarily drops and reacquires it around filesystem hole-punching.
> For single-VMA, local-mm, non-UFFD-armed ranges we can safely operate
> under the finer-grained per-VMA read lock to reduce contention and lock
> hold time, while preserving semantics.

Oh, and do you have any performance measurements?  You're introducing
complexity, so it'd be good to quantify what performance we're getting
in return for this complexity.  A real workload would be best, but even
an artificial benchmark would be better than nothing.

