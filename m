Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111CD1091912
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D726B0569; Thu, 19 Mar 2026 15:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE0C6B056B; Thu, 19 Mar 2026 15:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F45C6B056D; Thu, 19 Mar 2026 15:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31D186B0569
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:43:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7E2F140729
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:43:20 +0000 (UTC)
X-FDA: 84563836560.15.25F33CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E0CB180006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:43:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLZMn7KA;
	spf=pass (imf16.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773949399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDZigNyNGK52AXOwJDPGjVfVC2EYBV5uLNNJQN6FK+M=;
	b=yipUVVv4PTd5YzqCm5iGR86r805OfuFfbkbfdC7jBz6UDZuCknG5fXB179MC82stKtaOCv
	5/7icgkucB03CXY69paeeyCCcWSdvO1W6Xg+VliBPGRc4KGHpw+Y2vK5bOsCjg3cg7/6p8
	l3YTGacfl5ucYCRLcGs/Dc6qlHfFq/Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLZMn7KA;
	spf=pass (imf16.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773949399; a=rsa-sha256;
	cv=none;
	b=BEqr6tkMaj6NLlb93o6wMZY/5gjlSzodcSMJTbYwWQH5PsdDB8aDiW2gUXRIodtvNTROi+
	qfbhjf1RsMlYvIGQVPcbuyT2VgT1TsswJM2mS1I/3wm5QpLPiXsTzvQpdFu91ubADBK6WM
	bX+HmFcaP7oesUoC0RSeyFJk45RRpUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A36260097;
	Thu, 19 Mar 2026 19:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B01C19424;
	Thu, 19 Mar 2026 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773949398;
	bh=qFUNBaFcauqJNkia+FJ9ooLZtYVwfF0oiSXnhIQtmuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLZMn7KA++G0+Wly/p3EpL9zqxKe0qYTayOo+i7GlkAbp6El+s8w5g6j50qRIrzsB
	 NkYFV0FK9f+79Kwz7dUXZr3STxNt5tUWMW6dq2PHEnf5xMBp23MmsxaVCGiCXzZBAh
	 BPZE9ukoxmE0oFJs0649LDIW8p/c9gV26lJ6zB0oyHIoU94AmQkwKqVibLnI7BFNHs
	 dVynjwklYnOFd51/LcSdDtWwK7k+hxUyMZqO2SO9KzG+Z6bJKIX/ePnDWYu0mV3V01
	 beLgsDaB37hJvQwaKJqq4PS62EwPUOrYwkr8HsflP1mT0Mv6NQ1d7TZ4YVxQ3Z/phR
	 TO3qHn/VTYYxw==
Date: Thu, 19 Mar 2026 12:43:16 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not slot_free() written-back slots
Message-ID: <abxR1Pm-JksGZYly@google.com>
References: <20260319034912.1894770-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319034912.1894770-1-senozhatsky@chromium.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E0CB180006
X-Stat-Signature: ux5jmexmferuf6eibuz43tqt4b6akjpo
X-Rspam-User: 
X-HE-Tag: 1773949399-881513
X-HE-Meta: U2FsdGVkX18guv3QGk7x/drv5UGKvz4Alhdb1082xzXPJls+xngzS+oVcSiKQnm9uwxQOOr3a9HYhEDQBpxedpFb9agI1rCIzwY0wSvVqWwl1wf+UMRA9kvkqJgbqzFQnlt4kVIPDnhCrdDlD0iJEdpmDFWumw+DRXYXEu7p+pVEhGUle9iTNQZaq82WefASyHi6xMwl8eEtYBH8mpMOHWqLDsuigXNt+fgidu6KnQrhSlug1lYICh95vYtYQLbo8Cx5x6YAAC1481r+SYligneZcvAZ0oWYGVVBmu+bjgcYWR1rqNifwdNlUKyI+jPCQF4Y/bmKON2Ze7qJnTkAsx/rSVIkRUDI+lrbKpO0u0m7cs27fteIgsK7yhPnszIdl7moh5D9dsh0G6wma/pkQ6q3NeIq1VYFfnYAe3K1IV0JPBIFWWbyWqlSFGPtWNUt0a9Au29SxyPct3aGiVr45dGknqV6w4eVCTFBw/lQ1YghkaRz1+XFqFaIIt9RGRCAA/r5Hpwgf80AWNFe9W6CJjV8MkPqL8/QHmrAAN+LA6EdejQ1zzrnw8aExRFQ1XVRkU2EfNru8jHHGU1aKXdtwTrRyEl/BYAR7UjqfjE4ATaiNwbSUByf7nJJrW10tcPznszK1EBGA+rEdWFejyQtg7fQ79PSmOkyQ5jlhRUMI9U0xEwpgwCVdKd7CO4mS8jszv8VZOpWmDUma6vQkiW2pmQSIiIDgCMvY+4D2rJPLGfNXAPX4n4xbKame3BuMtNrEV1pWC3yv4S0q6fmFfVNDm7ot7RWF9iwmt7dLgqUY+x2017LKDAri0XCiNnndMYJrYUoOqaZ7F+xVOtkoCSMHvMcXPxjW3iZX7UjEm+dS6+gSLCMkIMJy4gc62EvO80Fr49bjX2xxXkww4ERCL01Ffcm2iAO5YIZyDl8BfGrPGbR7snd0N79UJlz0vagfTCVSPTIJ10AUt9O67uzf87
 oD4QkRwn
 5t3KoB3R7GIhykFQC5It756XZmN38C5zf+OrTi1WbP7cpFCVt9fJ3iSQrJBa7zAR0UezJQBB+dQX1bAfIG0prlwAZw5N6WG5W21CaXIjjP2ghIjne43deXxfHscu1HZfRGz32GI8GWRg66+vTsaOreO4L9xWpNAnbnuUPMYKGAwyR1KJQExkJHZnyOQwvrjvRyiiZwLlHH9K0kHwyMT6Mj/17beIyeZuD8qOnrmGfLmej9VeR7fIcZghpp1LRED8tpnooKdClcg1dtgRzmYc/aqtwo4DVra6yqltcSguTFuZ+MF/qrQxDJGnJapdh4efZJQYB95a5LTSBt972lTivv+XUPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 12:44:56PM +0900, Sergey Senozhatsky wrote:
> slot_free() basically completely resets the slots by clearing
> all of its flags and attributes.  While zram_writeback_complete()
> restores some of flags back (those that are necessary for async
> read decompression) we still lose a lot of slot's metadata.  For
> example, slot's ac-time, or ZRAM_INCOMPRESSIBLE.
> 
> Do not slot_free() on writeback, instead clear only those
> flags/attrs that we need to clear.
> 
> Fixes: d38fab605c667 ("zram: introduce compressed data writeback")
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Minchan Kim <minchan@kernel.org>

With small nit about the description in previous comment,

