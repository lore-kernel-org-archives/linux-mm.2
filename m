Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EABC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3706B0096; Fri, 11 Sep 2026 11:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53EF6B0098; Fri, 11 Sep 2026 11:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9909F6B0099; Fri, 11 Sep 2026 11:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA976B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:47:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABBFF1C0CD8
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:47:54 +0000 (UTC)
X-FDA: 85201912068.19.FB3B0A2
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8BA03A0011
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:47:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMVX98qN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789141673;
	b=oNZE3QG97Zp1jY85Hu6Tg5wXblpzR/Vww43RGU6tWaSx6Y7jEB847LuPjy6gBFE4LogV6V
	tyUerGinQjGjnuBgmYjWQYhHMztQ8csmV2OEkiBLPmUQcmRFGhmlSOyLnG5n89aoLXclWS
	+KtL+ahJxfGOPeHbFqQh/cvZt0yyOsk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMVX98qN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789141673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mw9opfOMB3dc75dXEFi6/zB3WIELWle4wCvOjsHcss=;
	b=ZuBAwIOXAeozzKNUCGefkiwurwexnEIe3dLX60gSndncyRmtCTjBFx3vKQQODAVTs45nJx
	VMCFbYsfcLr095Z2MliUg6Cjc/OrPHahg60TheKXD2CIeey1EDLffyBJmdGySnjtoLsh1x
	UlzdF4rLyeAMu4Mh78+CUZj0Sqf7DB4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3mw9opfOMB3dc75dXEFi6/zB3WIELWle4wCvOjsHcss=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789141668; v=1; x=1789746468;
 b=lMVX98qNzhtgsB96w3biKLxvhF5fYLRHW1uYUzs/eZXKfUlJWqOtM8bhpELc4nyRiAeLrMQ0
 Zpa8En8ziw9KF7eTBQ58oBqaH0aareXMCuEKMgOSaxrAIIz8IqDBtlZqeSj0+dCrXxYZEKhoccq
 ObGRlZAS0UF4ALZjSRED439Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bbdea84a56ccda99;
	Fri, 11 Sep 2026 15:47:47 +0000
X-Mizu-Trace-ID: bbdea84a56ccda99
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org,
	ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Fri, 11 Sep 2026 23:47:32 +0800
Message-Id: <20260911154732.31220-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
References: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BA03A0011
X-Stat-Signature: diy31584wd1z4fzago3f5cerz7b1b9px
X-HE-Tag: 1789141669-934903
X-HE-Meta: U2FsdGVkX19cFigqW3T4EQteXQOz0+Axt2v8II+oRw2/BH/0t2HctmScuN666S4Gjyir0sTUgB4jvuBLDhbI7OFZLfmz/YBOGK9J/UdDkEibZEXk9OK6DzgKwKRqL/CxyYrEmArhfl81WHHpXtvyQKKLayieIdYqe+kJO1Oqfsc6mqONULFJLmt7y4t+U4sanOoeeqtHQ2k4Q3t3TSuAI2Kg84Ze+ajErK+RyPR2JkGIslSpQalusOOjSY8NNR2zb4GblPifAboGJr+t4ogtFhOAAr3TZkoE5Kz5+vdabTxTZf1pwjbLYWG6Qq/q+XtASqUIjdFd78cdfVfwFSfqmv+PUDh7qMugovId+zKGvw50ILMTlZ/NdsLjBgnkyAr5nfF67salBCRnQVD3ek6NTK60NmSNU0Secz7kUmLFvgTPh5HGsoMYX//+/WctVjN10Is0EdSuomdig4f32mcgKycSGHgJIGRvcblbb1IrlSEEt5GCMkQ80Oq/VuLAmaJMgFeiEvx3wvrDy2cWZmMYez5QuCgcEhcfOjC5fXl95oAqijb+bd5CuZLWO5z1DE6mJOpvIvOan4vTcGDFCVnF7uG+Z1bT+D2sT2vV5UxhNj0PgDUEiPiAWFF7ZH+QKHZfHwoEgQQxQUFWvXQahDNlSZ4Qa2elMFxN/5JvAV7DlAv5CBbe1/NvwnVOAWEuFIl8ttUAgdX5qYOWPis2LBDGTTHH0+3F1dDOzfv0FgFmQlkSUkJbPN9o2qLuk4MndO2jg8ZL9gU2jn8IfqfUdtIlce2nIf9nS2SCjnCE1r5Hm1Erqn3YXIWhs4CCVoprR0lz8PEIXDPrSjJpa9gl08f00sDde1hkCRJ+J8wT0XqCQrLcv2U3RTT7IOSJ1ZYJK0072W3M3Q46LMGiYijSSsE2frYYuk1K5W1RokEY2nVNn6/iFh+MESs1zb53yARZZjo8yFK6GtUSif1c29ZyCy1
 nMUY1tjK
 W8E6wtNROl3HMRORkGi8MY4l+U38QQMw9P0Dr0+S5nVkDk6LnyoP1OyvHaKrGRsgsjpJdrWivIwEesKxeqL/LwYJl2zE1tNRl10vs7ErftDzc6v/1ojHv3iLwaPdBvtzVZUVo54DxtI+0JtcgxWbxrZ6FeHHByM6mK8dzc/e16LsslSLSsuOgARGwjXrj6WO4+LnpNc+DC6gbmLukijkhHpo62zXuUS/TfGIvUpA0N8rG0lYc642MeG31xMd/RF3M+VSovakJ3kUtMSXeRqw+hkoUIgeKeIPdNAyi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Sep 11, 2026 at 12:04:33PM +0800, Baolin Wang wrote:
>According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
>ignore any THP or mTHP interface settings.
>
>However, after commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
>into shmem_allowable_huge_orders()"), performing MADV_COLLAPSE on shmem
>will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
>(although that is the default), which can cause MADV_COLLAPSE to fail
>unexpectedly.
>
>Fix this by returning the result of shmem_huge_global_enabled() directly
>when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
>shmem THP/mTHP settings.
>
>Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
>Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---

With the Fixes tag corrected as Kiryl suggested, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

