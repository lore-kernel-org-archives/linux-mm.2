Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E063ACC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255556B0088; Thu,  2 Apr 2026 01:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEBC6B0089; Thu,  2 Apr 2026 01:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A69C6B008A; Thu,  2 Apr 2026 01:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E97A96B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:27:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9486E8BA4F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:27:47 +0000 (UTC)
X-FDA: 84612483774.03.F085A2E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCF7F40009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:27:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=306nTQxK;
	spf=none (imf01.hostedemail.com: domain of BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775107665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zTGBJY6hQ0zMeJQBjpowApqHyqRrKXxjo6V6st3wsk=;
	b=XeILyVqfaS1QZ+FuJwVp0mWsjKgaFfKTfdYf0I2uoup64h0u+vUmHhYuzJ8xN9+snpTlKC
	mXDwnuCh5vY+jFy0HTpFScUg2CLHOKLkugIKTGKEEu/+cosv09+eLwUXoved047Y3nxP1u
	5DUFrEnuCoYmXj5cY4jXNV28C6qpoxU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=306nTQxK;
	spf=none (imf01.hostedemail.com: domain of BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775107665; a=rsa-sha256;
	cv=none;
	b=cYNjq1LIJrscWbR90WLuhhmLZrDmI5i72FuIMQeEGj2HMxDRsk91eNK+0tRgVyfsSiyDm5
	pNhRq9YS+BMVa4T6u7nshRctfUvag8O7xuRGRX2AKHwbyrP5vIHo34OUpdg4xXo2TBccTb
	kUUSwJywh2tppaQU75PDFOrTTCRko0o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=+zTGBJY6hQ0zMeJQBjpowApqHyqRrKXxjo6V6st3wsk=; b=306nTQxKHjO9BgmuzmqBLF66EF
	XXR1rQ0dxmCenfIox2XxXf+dRDdKc1Z7KezTOEOH1pHmE/6O6Zh2xcMC1GEFPWHjsBhaKWvPiJAOS
	lyyNV3mNqLy21C8nIk+h2JwGYGwE3TRRiUdPcgzkim6RrLvWR8r74qHQN2dEtV5NHQKH80G0SDQfN
	6WimEMBvKdCChiBBB+RKN7Zogiw7RjkFFQzezFLrRXGIEQCStmGGlR4lUKrkXx1gmVTxsm0TOgjCf
	5/UYFUr4t6hYh7DtA4vQ+MWaEUXKtptcrhb5bvTjEE0Ul0/pzJCWNEjOkxZ1cTA2RT0oocNCeAiT7
	7rsOiudg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8Aaf-0000000GoIg-1hFS;
	Thu, 02 Apr 2026 05:27:37 +0000
Date: Wed, 1 Apr 2026 22:27:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <msnitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm: add atomic flush guard for IOCB_DONTCACHE
 writeback
Message-ID: <ac3-SU7BElHJVCEL@infradead.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
 <20260401-dontcache-v1-2-1f5746fab47a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401-dontcache-v1-2-1f5746fab47a@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: DCF7F40009
X-Stat-Signature: bhhwkzu4m136w6auecktmcrcteebjsn8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775107665-530463
X-HE-Meta: U2FsdGVkX1+0eVxYY3cLiv4sdTcxqp0SoZrKFPq9MWsTYBcxSqjxdYbIAfV507aiYISXz4e90qgBzR6lOb68IaNPcZjXR+um4zjCnY1Jae65v4AyCIDklOIZoZq7Thgo/OIGgP15D5GvhreSNPEhWgzdw36tCubp+LEeB5amR0qk+/5vdUituKY2obKijGnMnL/Dpwa6TCjy9gFN8aZfzmTw/yrhH1lsiaWfKWfC64glCRD5oRrJQnZ36AJmS9YPfAkyVaghFqiV3zrTuO1Q2BGCo/ROvc/xajdz8sffs4Irey2PGyCHuXhmiY6zzcYy/+YQHjxPYRj2khxUt5DQ5i+NEK+OKLhrg4M9oFS4/6ajM2JSv6bWgJBZ3ZjRxN473+64Wt5wReCo2cP7K+7CAEgMSqo9nAcoaNEusEB87XTir9chOVzPWIp97H7178OOGq15D3vO4kplg104TkEGSW9S58Oo0KjmmDcr9/zzTLO/0vtmrL8oIZVk5DqiTEalj+aC3ML+5BSS3xRaxL060Hfpd8IKWy+22Xr5W5bWhH3CNCQmRdD6OMtJyGVfxI1ayK2bWd0OZGKSjJ8LvziAdb1icX1MCj4jINUPgE8wr9iS7cAGwDu0sgvyk1flqvN9HZp7KVdwfv5fh5KPBe68fXjvxidjTu3QJ2yx4R1d6b7Nyh5JTrPokP6wKI3Y8TfjHwuzuf+bhhZAeCQXpJXFrF0ViHkMFIjstp5glMLLCrgMBNbYE+TZs06+8of38EizEp4AJRyaKEXi2XVE7hAljeo/gZDhpgQXu5lfWmBL9NTq75Vbk3DtFV8HVP7u1jiAWsGEK7VQ2dPa2P68sHSYkfvDo9HgRlYROa7eHLBobEuXamkG2/AOmOJBPtSgM740U2KzZlVZ/+Pbij32ZJhBo6ntqSdERntpwPmKRRAWh6nInZfchypdFyvu6OIi0sbKN9oxiG885djA2vVWVAk
 q4Sm9OqM
 MVKy/C1VNmBL0pHULatznllM32OJS9N+dKpMkajZb1ZuXIccAprZR9G6e1xyMssI3e2+a5m4R93o2h1v8aG/BneQ+CGnLk0XaL49FtyiTdJL7AqJrfc5IRmsLkuguRv3FpA/VqTVVQpJRDF+y2doevgvwhyi69oOJYhi4Ckxr829Rl3Byo89bCnAL9Ei0OylhCxeqEhed791oRbHJyBvtAIRP52vHJe060eRJOYqHavnFOS5itLaxYsLN8QLs0JNuxknK/tBszhAXY+32Ys4rx48ilchU4ufBMKi4C6y+D5KFOjbgliWELewkG4+0E5r2+E3BQVirePBuZTb4CcUyBvnhI3mlHTV/0yocNepv6oOc7Og1tGuFSHbFkOWbq5lg8gJQJt6/YEqZf+2FVoGZ8Pe9RrD7L8uPHbwb4bNXESF0A1A8No6e94yOPgNr3y4oESHNJnb0wLkUQZdpq4LigXZEU7fJjb3mkwbipUEF6DXdxfky+EBjHZpDY3z2fvb79hr02iUW/k6DtVTHLa+MSRsO/Jvjay0/Oko2bUKZX//Jo4csOd+aOVdo+fgkb0pWZEiW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:10:59PM -0400, Jeff Layton wrote:
> When the PAGECACHE_TAG_WRITEBACK tag clears after a round of writeback
> completes, all concurrent IOCB_DONTCACHE writers see the tag clear
> simultaneously and submit proportional flushes at once — a thundering
> herd that causes p99.9 tail latency spikes.
> 
> Add an AS_DONTCACHE_FLUSHING flag to the address_space and use
> test_and_set_bit() to ensure at most one IOCB_DONTCACHE writer
> flushes at a time.  Other writers that find the bit set skip their
> flush entirely.  The bit is cleared when the flush completes.

This sounds like a bad reimplementation of the single writeback thread
:)

Have you considered stopping to do in-caller writeback for
IOCB_DONTCACHE vs just leaving it to the writeback daeon?

Either by totally disabling the writeback and just leaving the
dropbehind bit, or by queuing up wb_writeback_work instances for
the ranges, or by just increasing the pressure for the writeback
daemon.  Note that with all schemes including the one in this patch
we might eventually run into writeback scalability limits, which
will require multiple writeback workers.


