Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69CDC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 16:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE316B0095; Thu, 20 Aug 2026 12:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7384D6B009B; Thu, 20 Aug 2026 12:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601036B009D; Thu, 20 Aug 2026 12:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9986B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:53:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 905FD401A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:53:56 +0000 (UTC)
X-FDA: 85122244872.29.1360197
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E9DE180003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:53:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CiQXfyz1;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787244834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UA+E7U+5uWMkJ311FqBxxgW5arKUl27n9hdqgLsqnU=;
	b=beyOQ+0AVK/Hgkr3uTMADPqAqs/FyZ55I+5ToQXCZuxB9STAWtEgslWRhgWdQ1h7j0g6Yc
	8NZ2VScGll6y11Ae4IHkT+qJZMamzxw4Xs8cF7GO/9jd35HpEVQE2Ici1Vkhyr55hmk0OF
	ZL8lrR+IPIJUralk4T0gFkwlr7qZFYU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CiQXfyz1;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787244834;
	b=MG7SBdFMzsGnumaP+BK6Zr/O4G2aUz0GJuq0K33bBIXYbRiqQTtipevGnppd13AJdqpZJD
	Eyi+FJPHeC0pIyGwDgdeltJS3I7Gp4crUkekaqoSYV7w7mWpgDWC+LzVKUjvo9eloNVGNA
	d7ZZJzLLPhlBHqqzQBucj+DznTEXeEk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=S7ONTvPc0AWI+FMhf0XWlwa4LGzte/bD1qitLf+XJMM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787244832; v=1; x=1787849632;
 b=CiQXfyz1MeO0xhtEbS/v2P2F7gEEtMu4pyCMo2sEvWauuiAX0wkJ8zw2dOpy/PPlaAVKTmFA
 OF8IWfCfQ92hbkEmof1D8gASJY/u/iCiZ/BOiEuY8XMJqOYnWL0YEnYV8cuNUjIcyvWxEzWKk5Y
 Wh3O8wypWt89N+/tlo7uDQl4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id ca54f914b327986e;
	Thu, 20 Aug 2026 16:53:52 +0000
X-Mizu-Trace-ID: ca54f914b327986e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: pfalcato@suse.de
Cc: kas@kernel.org,
	usama.arif@linux.dev,
	hughd@google.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	stable@vger.kernel.org,
	willy@infradead.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio on zap
Date: Fri, 21 Aug 2026 00:53:34 +0800
Message-Id: <20260820165334.36401-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aocFPRgqieScf_yo@pedro-suse.lan>
References: <aocFPRgqieScf_yo@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E9DE180003
X-Stat-Signature: sz31gxogormxabpumxth56tho5wtp98b
X-Rspam-User: 
X-HE-Tag: 1787244834-564062
X-HE-Meta: U2FsdGVkX1/g3NCoGJ/OiV8yUNCXEAAn6BSsr2na3eqeCTAtRn15t8uZUJEF0COMjwUi7XGtb3Pcxv+1f7e/4JpS2k6voD310msZwcPe3oBkWtdrhDmVaFU4wPAfviH4jEXef2V1HZdsm6Swxr3XELEmfywV+erSQF2iDUrB1AWofouZWbf00KWY9unv9/XR8Og5NRdKzgD9Mf+F51kQ0RSMXokWQ+oGp+I6ccNzUQ0XgNThNXO/jSsmrXCEZ/70Jm5TwlHkrgyoVH4z2ss0FW5JuJ5r2CMMr/i4Dh5oetO34ByQkzGpR1WY/k7hBm/IZxhOHWk6LolekW6nP3lOhVZYHD1tJLeJfn2GkfLX3bUqSqpZ2U+b9ZDWaW/keEkngtS4jm+gaK9MEShLJBQbPIfVHEhhE47+nHKjSLdkSXkvTQobnTtQU7LYWtYk1zr8zFdjMHyk9FIjIU7el9DDlG/C6RRUG4cpJbIn8g2pIGowcSKIMZdO9dFZwT/kXWJV+Hy7w1IADd0HKkYD53RvQ08a4o6gq0wYcywIBrIULV9E68bJffL+sXZe3FbnVDEXW3kCGenfnMoBtofcBDhawjFFxF4i0bzI6qqGXsDmhnotDWVG9wWGwnyu7pJ45+d7E2IZhFX8bvdXW9Su8MquavbY64ge02MjFap8wkcNfUtVvtBX+oQG5TUveBB0QjvRiv6RYUNi/48zg5e9YMe058gS8vFQrEVpbh6ieKgK82b83NAJC5iimmXvNCFTDKXefxW1fPAL1q0gSPicJU5dThtp4kHhr3TgasU61+0RuHHt0f0KQKbeDw75hW2t7el7fU2y+KAe87+DFUOSeQxEscWUVhd7FE9nG9RvaD3NqDtYzMuiugiNQvTu+RjLSszzqwMlm7gKFy+ptR9gM+g5s6bsFSIbBrZJY1WYxCeR3nxf2DGWDlnA1dnPcL2vm0WJzPP59Mnt1zWS6NkKEPL
 bmlC3BoW
 r32w2tHWlSYcxeoai0XZ7yqo39EFecIyrD6FpXG1Ykm8Z03S/XSqP2WPtaW90Sj6ivPrSi0DV85SoECGw+MOp3NTQfgPkrufn2L+3/Ux31wTZnZDIuI71IdUe0XGpK+/2daSJBT8LBzZD0hQMgLazpaCot3u6XCgM5ZlFNV/86jqP4qH/BIHrOXvhloF99meR8fimd+wLu3+3MCxoQnrCE6AG27IshO5zV5JdGX3ReXpIu3E+xTNCsuEiXvTt0LKfYCKTQzISIov8g/osNp9GkNNOT8yUTKmnxQ9+kPEY4rOzoXCEXO86qf0roMpOFRybya5FWTRHbcG/yO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>For some context: we were discussing (off-list) the recent report that
>systemd-journald had horrible write amplification, worsed quite a bit
>by large folios. At the moment, there is quite a lot of write amplification,
>but _only_ on mmap writes (if you look at the write(2) paths, you'll see
>write_begin and write_end which tactically only dirty what you actually wrote
>to, block-wise in the BHs or iomap IFS). This doesn't need to be true.
>
>What we conjured up was the following: since WP faults always happen on PTEs,
>you can simply dirty the block(s) corresponding to that particular PTE (which
>naturally points to a page inside the folio, whether it is large or not, doesn't
>matter). That way, you can avoid fully dirtying the folio's blocks. This is
>something that ATM isn't done by any filesystem, but it really should.
>
>Obviously this whole idea is thwarted if we keep writable shared file folios
>PMD-mapped - you can't get meaningful write notifications apart from "someone
>wrote to this folio", which isn't particularly useful once folios get 2M+ large.
>So PMD-mapping on a shared-write fault is antithetical to getting useful,
>granular write notifications to filesystems.

Just checking I got it right ... for a PMD-order file folio:

read-only mapping  -> PMD-mapped
writable mapping   -> PTE-mapped

Then ->page_mkwrite() could dirty only blocks corresponding to faulting
PTE, avoiding whole-folio write amplification.

Is that what you have in mind?

Cheers, Lance

