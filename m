Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C11CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 17:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCAE6B0088; Sun, 18 Oct 2026 13:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CDE6B008C; Sun, 18 Oct 2026 13:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182BD6B0092; Sun, 18 Oct 2026 13:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB5A66B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:47:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 012011C1DB6
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:47:25 +0000 (UTC)
X-FDA: 85336478892.11.BAF138C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C19440004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:47:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xvp1L8UB;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792345644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsDYzNlJTjk7An950ACgs6r7S95dyvCKvzejzrWXnlE=;
	b=gnsC3x1oK+bNwtOSN6L7S/LaKMK/FL9UxBcu3Iog5AGFQcYtMJW733MdKQ8BjIMLPb1JA3
	T+f3apOCPHAfmtKjA1TYnTo6PnwAgZxn85SpA5NlJyz4nLQ7Zq78ng73IZD3njPrD7i/mQ
	5XgOQqGl8DENCqYQDct5vlRG/rUKlRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792345644;
	b=So7FUviKcFS63EAWVDNLZtzQkw+5udxkD9XDmv6fHnS7iw8eDa0CJ1j2LnJM5IRks02Noj
	oMGfdzLZyWmNt16+vMQte8W4akJRDz8A/zrXPXordXanMZbZFcbkfkk3cfelI4JU8XR4Sz
	7u7mV052FipQr9baKPR/5Bsi4/GfGiQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xvp1L8UB;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53D5140275;
	Sun, 18 Oct 2026 17:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591581F000C5;
	Sun, 18 Oct 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792345643;
	bh=fsDYzNlJTjk7An950ACgs6r7S95dyvCKvzejzrWXnlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xvp1L8UBQQYsPmtQFrQub9XAbqf9iDcVQ+qyKH5+p7SFyZs1l8uTScA/1lA/AHsDe
	 /3Kopk3QpcxV2WchBztW/d9Opf5XxbbgkjROYpNLLCxZIpXTGfN2piULxAdppf9UDR
	 jyya202bY54VvLq3yylAdy81XwP32gxuy1TuWsrFL5IIX8s7utOyzQcuKwZ7V0NA8g
	 xy6+mQQqJxUPbT+tgxfVMg/iyFw4PuitiB3ri5EcPcJgzommE9FpcQWzXljFNLEJ2+
	 /GR7UTb8nd8y1Pve7xgBlDO+ebUiQDiT58yva/kufBfQ1pjV/dZSdf2tQJC+fpzVzP
	 DSXayftAfhoHA==
From: Chuck Lever <cel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 00/10] NFSD: keep direct-mode I/O out of the page cache
Date: Sun, 18 Oct 2026 13:47:18 -0400
Message-ID: <179234561005.678493.856092392865379039.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C19440004
X-Rspamd-Server: rspam08
X-Stat-Signature: siqqa4uuxnk9zxoik8mk3m4ssf5c1rbj
X-HE-Tag: 1792345644-747499
X-HE-Meta: U2FsdGVkX1+YG7NGmZKKT4OclsjiQGeTSF0Jjn3tN4+5ou9oQ/mGC4PXbzGjFyb6yVOlUPkGZ6YjXYue+Z6xhA3Mj1pco8RckcH4ffZsvuigOxc9HxWo7LVkuRx8oQVshiGUGCg+HKwNbcoXbWTSlE9mhVz8THnF8aEZCqN1dFTKQzjx+YJzA9HmzR1Zqgnr+yINdvbUPw3OavRPLha9YH5O/XtdT/Qhy9jbFOUGVTnlQ5HUcEmNwim8d/dQ4Iv8wtz6p9j0btDr/XxovCZq4Om4ZLU2iPwAohxgGuQNTekyFAAru5AxIdmd1n9Hn9AkFF7nTH5K0BL7bVqypfHr4uMGiQzBWr/VWiA0FbTo9HTJFWa/QAzz4PfrEsSneU3idXnnODDiFqF9EaGAlpNrUUlI9gDtG+x+L2XmfVfuPgqA8hD+H8FHjpUVyRGFYYGYCuYk4JSOWogkarA9C5aptpUjeJdMc/GTiHHilBTuwLuhLuYUA/L67Hd5XTRDDr/T20pOaIsNR/R7ORo9JKUPFON6ux3gc5wHYaTI23GNXEWDZAUx7YKA5x6tLI0YfFSyRsPZDiTWR44COrp0GMYFXaKGPk4SwdfexkewJwm4JCYAfBtpJXAicIDYhKRNzM1U3LtVtQ9YlgM4artN4f6Z38B+gAZO6SxmhWJJQko1FsV4nmwNkJpj1z3zpd6LQsHflcjUCkP1uFWQG5vA+Kc1T9nuj6QUSi5gDlwSL4ts4ankYLVZuluMUxWVCvU4uIPN4iAhYnDHZtrdwzrsVO5RnRnkyG6YBXXWuuQaHHoCqW3JTtp4w28dQ4A8a9j4Le8cUEOstDl99O5wFZFjtcpBD0kzNbed0fOm7LNbTmvpxyElb1HnFBQqG2mrEsjQXhej/0h4h9/mi0KmWyHvTPc4TdA3mvfpx7XZDaHYYZs9aDtNoQ3og7Pth/YF4XhFubgvlE/c4OkAaOFDUwKNJHa
 17UGaEza
 o1N0a/XQxJXMVUnDWEqawrx1doHMCZfukj0KD5ZaY7/p7WWsMG4A5XKSqJsB/DZ99ZJX4wUI78/2aXPehrhSnFQLo0UApYltvG145GFr3eIP2qnn5PJNo4c8iO+N+4vC8aXJvXNOUBIAXZ8MebJgXKl6EJSPA6CkcEwkTp61/LjORkxbr/dIa5d7HWWHJQxChzwARGDoccMRDbnsxnEKyHjnjWKL2OduTfMt2X8Ca/9lgggtYR/HPvAFKPH3f0LjUaIrKORDkduiWDcdBl2Ovbsdy6ONSJpWZEgAwpKgvBIwC9bQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:32:59 -0400, Mike Snitzer wrote:
> This series refines the heuristics NFSD_IO_DIRECT already uses, mostly
> on the WRITE path and in one corner of the READ path: the io_cache_write
> and io_cache_read modes where an aligned request goes to the filesystem
> as O_DIRECT, with DONTCACHE for the parts a misaligned WRITE cannot issue
> directly.
> 
> It does not knowingly undercut anything the existing upstream code is
> built on.  An aligned WRITE is still one O_DIRECT write and an aligned
> READ is still one O_DIRECT read.  A misaligned WRITE is still split into
> a direct middle and buffered ends, and by default those ends are still
> DONTCACHE where the filesystem supports it.  io_cache_read and
> io_cache_write mean what they did, and nothing new is asked of the
> filesystem.  What changes is where the split is cut and when it is worth
> making, which READs are worth expanding, how often a synchronous WRITE
> is persisted, and what happens to the page two misaligned WRITEs share.
> 
> [...]

Applied to nfsd-testing, thanks!

[01/10] NFSD: cut a misaligned direct-mode WRITE at page boundaries
        commit: 80728157d1bd1bfba745ead39a0459622d1f5017
[02/10] NFSD: mark the direct middle of a split WRITE IOCB_DONTCACHE as well
        commit: c5d5ac48860343d7741ceb5c9024509b4aa7e2ad
[03/10] NFSD: only split a direct-mode WRITE for a worthwhile direct middle
        commit: fcd8823db80e218372d9c5ec6bc207e915ea4863
[04/10] NFSD: add direct_misaligned_dontcache debugfs knob
        commit: b99724228837563893326517a589565e0fbcf45b
[05/10] NFSD: do not use direct I/O for a READ smaller than its alignment
        commit: dae8320b4dc640d9ee99b1cd7f2e5da910828982
[06/10] NFSD: persist a synchronous direct-mode WRITE once, after all of its segments
        commit: b4e06bef38843c8b909d0b4317dfaaf87dba6d72

--
Chuck Lever


