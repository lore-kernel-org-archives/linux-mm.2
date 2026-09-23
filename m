Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BD1C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A216B0088; Wed, 23 Sep 2026 06:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAFB6B0092; Wed, 23 Sep 2026 06:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2119A6B0093; Wed, 23 Sep 2026 06:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 002B36B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:47:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AD5B406F1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:47:14 +0000 (UTC)
X-FDA: 85244699988.28.1899703
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84789140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:47:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oltc4gXy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790160432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDDF6SKtt0mSiUPfmFFg2n4tvXakbgPe2tlV1YMzcgU=;
	b=Zh7T5Yx/WK2hxIi3GnhOaAWpAtZGGV6Q+uZ8aN9E5HgxMSypEctSGz4RfJxuaWKclLq29/
	Pcvsk7fqnGaqrFvgNZ4hEeYDVlB/dQG+OSS96POmlZ+XK4Q+4PLwGutRpZM63Q6+tm3RrO
	apda4ZrpXpa18I33erC8lb776sOZ/kM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oltc4gXy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790160432;
	b=gwG0D9azqpDgaTn5u4RMg1PnGgyZXbBCSqtBnzHrNL6/7S9KuHF8XlIeVjAHqIfDDcegC2
	hKaIKHjnsxaRNLzn0FMvW9Gkf7RAovJNSNa6C0yvcvxDXhslRyEvEgzsQdujrq3oKYDukD
	j38JSqI3pD5OSTc9l3n3ImsHpv9F1Y4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27861143D;
	Wed, 23 Sep 2026 03:47:08 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C63FC3F86C;
	Wed, 23 Sep 2026 03:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790160431; bh=jBpobpGD6Ea5rJoVfzQTN7ysJ2G/gw8VNJRkAAGh20k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oltc4gXy8tuCEPLl8q04CzNR/M2uenYDnBnMu3UBGTi3Torjd7pC1U7F1T5SRjm/s
	 GrTdEKfdLYGY7NiOGO8bqTXh4rBHevv/UctDKm6ABR5WXJmD4pDTY5K/wSUsXaFHCc
	 SKzG87M596tYPnIzCnJR5XLCEGs7yh3k4BQ1yPDY=
Date: Wed, 23 Sep 2026 11:47:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: kmemleak: scan the struct page array in
 MAX_SCAN_SIZE batches
Message-ID: <arOuLEZfEqmce4iO@arm.com>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
 <20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org>
 <arJPsqUSHGiitXQR@arm.com>
 <20260922183921.b30bc1c3ba9443e021910851@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922183921.b30bc1c3ba9443e021910851@linux-foundation.org>
X-Stat-Signature: jhrg6h7z53r6wwjwgop5regnnx65g74z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84789140007
X-HE-Tag: 1790160432-893827
X-HE-Meta: U2FsdGVkX19dAmoRxqO3CYjDroSGAKE/NgxHYRHmXP0SSwFlfg/aWQSE69jSAu7Ue4Hl8JVmT5YoofSgYBsfho5FcEoipwRU0o0LuktwWnC/rLm2anFKBhLXry8I2cpBC3FC4P66FBCoVUo3fxVRjs5xQkR1slESGuuS657ZAC685DOV8hK1a58QgN6CE78X5PL1ndcQdw8A3ZmJF5m+4Jd10cMhUdklkcQ6iIyY0yrvyPgQMB61fY3xOE5zss2GPNZufnj3/+Jh6TIydsLownvOsObEI42gg0t65CKUk/HlpGhbjOQnCBPU0UBgiLlL/f+sCJvoa36uNv3vwLSzY8k3b4TeCABstuG031HprBf5O9epNmtbWMQu98C4N622L08lEpajzuDoCvXIqZblz1L41LNry2NIbetZfzKXmiNW36ACTYdBLzdZwTPEKIQ69Mv7UHyxTXR5g6YuQ/LcnOPfDvL/BFhRR5Ofp8MZu9FhsVthIBPBVnuuFDkJEcaforqr4WDt5A8x4OQ3O6MWMKYGES7LSTENJ2u6L8SJD4l8ihvo2lXRge8klPABxwCoYaE0zJInSYfomSrLwQgUQrEasHtmlFifsqG+o6m2a8B809Cma08lo3oVYfR44FgS2udZhTqW8mJVSz6YpvFqRCBUCfoeX40MVyGHdV1I+sVLzBZMOk+mKYvAMHhzULuRWYzChsm4/zqsXmCBRRWqotczvf8g4tyHiHmw3acSvNmvOHQ2nTOB1VgxtXbIsp+x80hJeHfqnrEC3rlkTkQsP739U0KAEQL2oW59g1iSoq2BlQr4qZelHyBchzKzLImzcTGZcNXGbxGERsQKnSo+hr+f/YYSQjO6imrctyPpspBMTHiRlYb1/vW9WOP1TmGYR5NUriu2wL6PsFG7LtOGn4+QDMVSxFU7/DrFgkunuzlMrPNkZRVtSORRI1onPOBKGkejdbYHTgVbvhf/yuP
 LEl62Jn0
 Kvu+zsaOEehVYzS27Kric3glSzSJcYJTZAATGAJkUBsNHRWqh3XuGSqBTtq3+FuROoRp0oCFGaEYreRm6wOBDrnj5BW2JNpkZIPtjqB+oLR4RwZo9pGVmYSL/pydnMHwRszvjPwNnsTWRcNuwuwTwkkRX4bDu2gPn3GbNmc8p8XFHhqqTbTGtKjlYtBWtMT4r9KlxoyoKDYOxbSCCPsvEwomrPmXyi21mdrF1TYmsaN6XpekJeGQjYA5n4qlkgdI4AcevmqhTXPeXGNJ/Tn53nhn1OxTtUNkafsQO4fZjGBBd/A52E5ETDmxVLJmTh7GsJy8NHD4w65REuGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:39:21PM -0700, Andrew Morton wrote:
> On Tue, 22 Sep 2026 10:51:46 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Mon, Sep 21, 2026 at 05:30:27AM -0700, Breno Leitao wrote:
> > > scan_zone_pages() scans the struct page array one page per scan_block()
> > > call:
> > > 
> > > 	if (scan_block(page, page + 1, NULL))
> > > 
> > > scan_block() takes kmemleak_lock with interrupts disabled for the
> > > duration of the call, so this acquires the lock once per online PFN to
> > > scan a single struct page.
> > > 
> > > Gather runs of adjacent eligible struct pages and pass each run to
> > > scan_block() in one call, capped at MAX_SCAN_SIZE.
> > > 
> > > The longest kmemleak_lock is now held is MAX_SCAN_SIZE worth of words,
> > 
> > Remove an 'is'.
> 
> That was actually correct, but it doesn't read well.

Ah, yes, you can read it in a correct way as well ;).

> > Also, MAX_SCAN_SIZE worth of bytes rather than words.
> 
> edited, thanks.
> 
> How's this?
> 
> : The longest kmemleak_lock hold duration is now MAX_SCAN_SIZE worth of
> : bytes.  The same bound scan_large_block() already applies to the data
> : sections and the per-CPU areas.

Looks good. Thanks!

-- 
Catalin

