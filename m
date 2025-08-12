Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10533C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870EC900002; Tue, 12 Aug 2025 04:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846D8900003; Tue, 12 Aug 2025 04:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7541B900002; Tue, 12 Aug 2025 04:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37A38E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:03:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5875D140241
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:03:55 +0000 (UTC)
X-FDA: 83767366830.05.5EBBDC7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id EDEC3C0004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:03:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AKILUHKy
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754985833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CwQGyWvOHVXHPBd11JgAdDfsb3+1bTz5ROp4j0wtVw=;
	b=6po63vKGsGPlDClDf2+6E2TpNm8w3EYuT3AzwmHOPGKJMbY3tfKvp2anixPtqwwcizOlb0
	NNP/RoZvq0qsDtmmjn79aMNIVaNvyUaCffr3YI+C2QfTbA3Lb/xOjgwdzGWWnfgvLxPkC8
	wAbBLGO+CnzCo7XDi9iJer+cStqL2SI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AKILUHKy;
	spf=none (imf22.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754985833; a=rsa-sha256;
	cv=none;
	b=E8nrWn5kPeLOnfXc7IPQ8QCVW4nAJk8qOiMUtkwxIp4uOyTvaS7B6qH2RJx7UW5hRbo4wY
	JLg+2RB3KcevJF/67FqJ7qnGfI0qIOUlbBuVWbbUHFBrjTUZuje+QEi9GwLzsVrD7YJWLA
	B9r2RymfGEGH6yYTpIWOwsWbwPV8JOI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6CwQGyWvOHVXHPBd11JgAdDfsb3+1bTz5ROp4j0wtVw=; b=AKILUHKytLeXOyjtjZI9RuxTnr
	l2NlRe6nl+wEIOnwOiw5aw81SfIgoQewKOSde84U8v3S2NFIAIdXsEJ/teHxKjonC6erHM70cy6g5
	UuO4laOxqFQ50XPNe7cyHCn2mbcsI2DtXD1HjvDd58kxESiD4+iNafWOzsf/vgohuKYq+pfI1iaf/
	zVFCIYBPutsqMAHljcWKPP2VbiozpqPyj/J4QawF0qhWN9KK2PqYjDwSHIW+ELFxlpYaGRAQmT/83
	gx9iX+CvSrHJQqwageiLqhasB5Hvsw1o7SHrOSVS4QbNumsMPgKMNG2Ynq4wYlpFlau9p9rqpderJ
	kAsOhy+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uljz5-0000000AC8Y-16gB;
	Tue, 12 Aug 2025 08:03:51 +0000
Date: Tue, 12 Aug 2025 01:03:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v1 03/10] mm: add folio_end_writeback_pages() helper
Message-ID: <aJr1Z5ERIsrBBpK5@infradead.org>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-4-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801002131.255068-4-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: EDEC3C0004
X-Rspam-User: 
X-Stat-Signature: 4ab3azxojaz1dco783tmpmygpjkrchjp
X-Rspamd-Server: rspam09
X-HE-Tag: 1754985832-330211
X-HE-Meta: U2FsdGVkX184cRb5auOmA2eqXLDeflSnvg+ZHDJlBX6ta1HsZ5ZToUex+oH+F//zQXDxfWDGjBoYfMEzSkOLW0ozIUJFade0d68g0o3EB6QFK2U9j+8MZjjfuOSlTzIqh3sfohi5lDTeIR10ZYLz/TUIp5KB2PL6RNGbg4vwC+4aPeHCMWJwSWEdvLda0wu+XZ5Vp2sZiqUVzC7PDX5aurUiW0YO2ljmti43LvX8lb2EiXOtS3DpD7N8u+HdzyPebUbKjrJhMxSyLX507Py6WlvaqA52EaDWODWS+fu2EZRzgoRP8hwnXkW0W6tDDjA1ZP0xus+dowaQyDMVB2Kl33Hke0A6N2vH0uI4+8pHestzebXrkDo/R2UUp+X2wycupwZSduUiA6DilHO6G26bl4Y7AGwKIDnb6vqWtDomqh8AFzJW9PycBG+n7eTjULaVm8V0OGn8AAVhgN+W/Y6I7FKur03O7KAYbwCdFho6qZPP4kW1WRiPc5eqr4yx78xaTYoBfMpJRu96Q2zNEUqFpdgoWtcBTtOJ0PGhxT1xu7c55WqtK1XJ2/phibURQ7Ko6alb2y//QFz1QyzlOP5jvGWN72e5ECbHH3xgnn680nOzkdX/WDu2CJoylyCCJ5p48BL7U+iT8re+gjrSGvrFpmcemN0pGC7iDCDHCZ2CyhvNbcwSCPnMJMdtCRbPMev57mZruDf4Swrzvb2bOeqp7GzaUTp4ZcXVZ6JSG0UReF6KWuepiL8imw44Tb75s+1BbVITtP2XikydS64FP45LqZU1hRLry7e3W99Nb+v3YC+ujey+Yoy4swWRBmbLdMqjPnw9QDw9RXyBIzuq1rWNErkmY/C6smWPWet8rb4peBDmqkx489KxNlJuEJQG0YDJAP7gJB4uMCgS1YsHyl8aPtbknqCohEowlr3z+YvAetvfHMzdXv31tyqUTYVmqZsvAOffChUYlO5K3PiPnty
 5AXqTFX2
 za+6Zra3KZsfYIeNkLkfpxRaaWkePRwvHbhlt6smPIQFuK/QnmIaZ4spSrJp3OSBqna3qwvvYGC5CNFDaxgGE5fQNaetSbWzPSMbYHf7R9dQoU28MJ/JPK5sanko2cygJwLzLga4G1nRnmQgrz7qYbCO4n5oPIY8AMrQ/WZNw7pxiOpdq3vlTLj58Y+HpKxm3bfNy4gVqcuhEzijn/yUY8VnYzr9Z5IKTMIn7aSIrbrQUT7adFNw0k9VvlhAJ9WTHqrQ1qPyjPdw2MBcgxEu33pg0ZxFtnMqBgrLw4ZMDVWXm3tl/ONTOmJZCtEr0Krvl0CcfnQdP1QTCZ3Dlk4w0sYKkGW48RZXiiuonIiYgL6E6w8X1Q8945q09TM8UdkInPXQWkcWe2j2S24z2EvoDQvnO6QW7wkBRjgOJXzDzLjiaQv5aC1nZGTjCOl0l/cFT4oLDWo3GGccbnqj4mKOGc9ez5IDYxG4uRBSp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 05:21:24PM -0700, Joanne Koong wrote:
> -/**
> - * folio_end_writeback - End writeback against a folio.
> - * @folio: The folio.
> - *
> - * The folio must actually be under writeback.
> - *
> - * Context: May be called from process or interrupt context.
> - */
> -void folio_end_writeback(struct folio *folio)
> +void folio_end_writeback_pages(struct folio *folio, long nr_pages)

Please keep the kerneldoc comment for the now more complicated function.


