Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E855CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E326B0005; Sun,  3 May 2026 08:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F3A6B008A; Sun,  3 May 2026 08:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BCA6B008C; Sun,  3 May 2026 08:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8796D6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:35:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3739C1C0915
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:35:34 +0000 (UTC)
X-FDA: 84726054588.23.F4A7898
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5CB4FC0003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:35:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mnKOyOFU;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777811732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=814WAN/LXF+0RpMK87ve3wk+gkrkIJkpXaVoqtCsqF0=;
	b=Lz4IZ6XjsBQTcuC+2BxyKzT+iFd39IaXacdUJ2MfUENRNF5wxbP3C1JsIuX/VOHbxlXQ9K
	5GEemoOJmT90Ob8GeGgQa0neBOboG9pkJuP6eKHo4YzP6iRFKb17p3hL8pJvuv+VIawDV0
	uLSnd8nrHYUJPfASC1wmLqAFIk/Adqg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mnKOyOFU;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777811732; a=rsa-sha256;
	cv=none;
	b=EPaMYWDg7GN1SCs6GqcQGl0nj4OaWllA0FohPyA5n6VHDrixVTJCnnRhPpkG0Xiu1U9Q2x
	TIb8hSQoxu6wyiM/usveiDT+O2/2Zxm7Mu1+cxEaLY2kz/Ql7zEEWNqSrev1NxJDEkF6cr
	ht6w2kRfcf/evuS64pEWDg3sGVleJJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=814WAN/LXF+0RpMK87ve3wk+gkrkIJkpXaVoqtCsqF0=; b=mnKOyOFUCVHyehHoI0Hn5txKbB
	ei1JzNeaP8NMbSLzW0P7kwqrI2D3vcUfVMlqkH4Pc5+3+tX2ADIVqzy7vXCAkq9Rp1TnvWG3LTeoe
	sztvTzH4VwPuERcrfVHtUOkPMborFiEOB29SxEUfLjeWmYynRlaAInXZjY/Rmw+oBT+TsTUME1ErO
	kq05I1SpXYwovWCZdy+IpwE7eOW0GlvlzXNHJOdnMiQBq2YtebDbKdiI+CircgDcxPJhOmAKznP/O
	rKdrdg54mJnWJXhQKZQ+lI/kxx3wA0TpGXsg6P388tSW8Wp1hDaZBa1rJJgA9LOe5y9FJgUu7+ArF
	HiSIGzwg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wJW2b-0000000Gzy1-29vQ;
	Sun, 03 May 2026 12:35:21 +0000
Date: Sun, 3 May 2026 13:35:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "qiwu.chen" <qiwuchen55@gmail.com>
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, kasong@tencent.com,
	mhocko@kernel.org, hannes@cmpxchg.org, david@kernel.org,
	ljs@kernel.org, baohua@kernel.org, mhiramat@kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH] mm: vmscan: rework lru_shrink and write_folio tracepoints
Message-ID: <afdBCWopkfF2ow-Z@casper.infradead.org>
References: <20260503085705.3276-1-qiwu.chen@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503085705.3276-1-qiwu.chen@transsion.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CB4FC0003
X-Rspamd-Server: rspam06
X-Stat-Signature: mk6t9tc5eb4utih7zr39s54rpxfqpbe9
X-HE-Tag: 1777811732-76246
X-HE-Meta: U2FsdGVkX19LiFINtfFhY3mREysrZZhVxyqQjtL3C91LolBtPjfthZl9uD8MRZg+XFf5/LHyjSWkRwOBBcgjpNGpafL+D3b/B+iPz7Kshx6/AigK9VPWKl2Px9IXjfa4FlQy85JoHKvqDTzAtvo0zdgZxq4JJ1wCJe0XeFAU0mrl2xkASzxcuJY/3aj9jr8+XDhjXCxa0XCvyhgwO+6x+bxhdexUGkzOWfb5uJp4NyRkDBgybDymIkg8QhQKxZ2BZm9OXvp2ziwcYHNacqrfGMkYAiywW7LI3lY1W4IoC9V6LxDHFn6iRMBYBeCU5Nk2J1j2N3YYvt/jkBw29KFo6hfcm8k5LCG8h9mG2nejc+H3EBcXM2WPU4kOkk0MkPXT1koPs5OTuSkYmu2VTOQBTLLuD0G1fvLfhopZ8sybnrLApaZok24qSBr136KqKnXD5dWh6L/dBH+oBBVKINl7SFbOHRArkESIWKWof6GbCygCeisUKpk3QEPUEiIAQ8UTG4SBTce0vVoeHCTRPDaLq7acGPGS5PsNT1eLKbX2XLzPVluKVlUiMqtEkrJox3kxCVjvof67Uwy5np3DrAf9A3U3HhCDt+U5tajMPicGgKwLOkpN3uRSLpx7Slxm6NWEGl+OT6QRrtin8qb162GkOhN2sN6/kJLWJoWe265V8LXGMLTaGCmiWEDhMjfD5ozNNNWzmuQn8IMMQ5XjNMKYFegBWDEppViLv1FxfbCC4w8S+5Lidt7qOM+iMA95K/pE/BMXyPLV+9U+gqWynkSWRkjko+P2ox6M1LIQJX01NCMAJzKC0tHtUDHOfimEyMEdPVe2J5xzQiedXR4Veq0uEjxHUHZOTjB9SrcPklt7Sy0goTDFjosYgLaqxZufsPjLdeQrmkXuflwfSHmtEkGgnEWWWu5MO9yYSKoHvcP6/uJJAazXq8sH0/rdIXZxhSg9qHkRPdcWOBZ3MNPu6k1
 EJIrmKrx
 EKbPZZk3Do4/P4qt4CJrm2DU4qczcXlkfYAaW5iwlY3gtNS2PS6ERcXWxtsN31iR+njT9IdFFYUIe2EOixzmvYtbIk3XNykiq0/KJbPiCrC51SIcn9FHkB3WWoQgjy1v1dCuRFZDf9b5qB8HTdq2YoGzHLmeUrNreuLWu8vPcDfiXD2G0N7NfOmVWDh4CqQn8KVVcAMmHhFyevboC8hy88Pe/Ve2O3fT/KIvf6qwRLzSN/qjk+Ej2MLkqSjOdu84HTWipFGQgE8vyDZfc9ucWBFR2UW8kr7eu5LTIjXhTlTbgjp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 04:57:05PM +0800, qiwu.chen wrote:
> Currently, reclaim_flags always contains RECLAIM_WB_ASYNC in lru_shrink
> tracepoints since commit 41ac1999c3e35 ("mm: vmscan: do not stall on
> writeback during memory compaction"), which is useless for debugging
> memory pressure issues. Other RECLAIM_WB_* flags are not used anywhere
> else, so they can be directly removed.
> This patch reworks the lru_shrink and write_folio tracepoints for better
> correlation and analysis:
>  - traces each folio lru type instead of reclaim_flags.
>  - traces each lru_shrink with reason.

You also removed the printing of the folio's PFN.  Was this deliberate?
If so, it merits a mention in the commit description.

Also if you are going to do this (and I suspect we should do this!)
we don't need to do the folio -> pfn -> page conversion.  We can just
store the folio pointer and print out the folio pointer.


