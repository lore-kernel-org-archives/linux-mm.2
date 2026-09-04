Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20601C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4236B0088; Fri,  4 Sep 2026 15:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74546B008A; Fri,  4 Sep 2026 15:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62D46B008C; Fri,  4 Sep 2026 15:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79B646B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:44:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2F2EA01D6
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:44:24 +0000 (UTC)
X-FDA: 85177106448.09.AEDCA49
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE49440007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:44:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=RhhaNau0;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf07.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788551063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdqcgDWDRYb5T8iNF+ov3y6T/OLrNQ3mp3fJFvYbja8=;
	b=uDv025fNZgn30RJJpksHqE+Wh/f8nnOFIDi3WNyTC+GZIgdHn41w/JC48CYEnCY3c/yFj9
	D8X/CF3soUQAGzkH2raiMNVHDIGVd/yHRyNTmdp8uqs5i53YJmW0Xc4xWNQwpzFoQpU5kC
	E5/OtB/L7OsAMgFOehww76HAzyOhbL0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=RhhaNau0;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf07.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788551063;
	b=SQOlJpx/ZP5dObvUMZ35eaY17qABHMWERHMeZUYQZpKz4Ij6qF9JbBgJbtyPb0A+zZjj4Z
	PKdwY4+8uQG6dXogHQkMJp2dYnQ8Mx9WryqdmvInBdXzzS0J+i07p3gM1VmQ3s74dBu1O/
	Nfx1boEC4Zw1hE6ZVXqU0tqZtizHQVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788551021;
	bh=vdqcgDWDRYb5T8iNF+ov3y6T/OLrNQ3mp3fJFvYbja8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=RhhaNau0fa+aaa2LN9UTf4RipfNRGsy+X2+SsOL7yyKuV+/UAvgGbvA9QoMq1N0jf
	 aorgj/GZMsDJRnQ6OhQrhYzjtrqpSY+tiuNSuniH/GNpyenIFMNUQjZ9+MMJeup2+D
	 2qKlnZufC2tKwdlad1AxCzYuJlAC9TYO7F8rQF9w=
X-QQ-mid: zesmtpgz5t1788551001tce9aa63b
X-QQ-Originating-IP: SC4xcQ2AUZyWLQjL7sMo/Lm5tVZSsV3X7Qmh2D24Kws=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 05 Sep 2026 03:43:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 861377282768174038
EX-QQ-RecipientCnt: 15
From: Wentao Guan <guanwentao@uniontech.com>
To: qinyuntan@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@fromorbit.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	xlpang@linux.alibaba.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers
Date: Sat,  5 Sep 2026 03:43:15 +0800
Message-Id: <20260904194315.9954-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OSNvDVUIgTHKtshHkV92EO0D5G0J3Gtov2NKa7SqgCGjuhy7MI1WrrWZ
	1IVZAEZa0vxo4w5gG8/jWtVhovjtBjJRQsQWr8QDqt9qlKXxixGcx+h/y48tzvJWg9Oor3Z
	Zo8RBO2w2l5NkEO/CZnnp4+z03R7zyZHvvaV+o2LBslplyZF1Y5Kr95Gslid6a3zPjb711y
	M3/7kWzZvPmTpJNxfv0fCuG5HVkpH2TZ6Cjgr4y1LrNNQ+krHIvvdItCcm9ba+jTHqLFECD
	F/pWDOnIxW9WQmBxVWhsdUMXryfmMgAstGHpnEqcqKTT7VckQYUs5FKPfGsGVtKFl6L1W0u
	OP/AsBlasLbD2j84ejzDWZt5pgszzZ+GEJJzYeLPLTUsUReHpvr1Nt2OL1kfgNXkUTHPhHR
	wfJH9HGJVxeaSR6zBnV5/4/v3+1etgCKkEfg0KtGjr6KOX8+r5oD7+Ll/kNK/O1KHu8tbT/
	AUX7APS1tqQfDNeQpDKEJghAe8WEtLvyBIdxKRqEKzvfe1M3vJKs9UOmPmVlUzWWVmM3oiF
	c1mriYH3KoNzS788mtxFo+T6lWqh45kZriQiqQJRTQUdpHsIvq81WqeLKUJ5GdwQXdMdvbd
	XBkrcuXYDmRe673VJOCUVx+eV4oQnDnDFliu9bvexTpMrO1RlghTIdN8kU6/Jm4IGACaCRn
	J9s1vWZS6l6JaE7XEBK1oo3V0aNrtXEKRpuNe6XAybUCdRAKsR82APPOYplhdR9AkQLwM2A
	eVQstSlmYfnGW+eueOC8N5cip2h/WU9QqV2XY0nrtOSIjr3vOUDF+knTCOEq+W8G1CmKWDB
	F7a8jmrb8N6ACItn8jDut9r71LjD3UD+8nkstJjiUlaaqlYzwBmhdUJEkHb0N2mz0kc/uMu
	/WGiBr9cNeuW4fkimffudUzs8miQPFszozoFGsKZi8MGuoOioeCINJDQ0NRMGJa8pFh97wF
	58xkAAeveF3QYV82Ib1tGysk3SUIOcgpby/4yjBrSOMXNWR9eIvyuElVQSUZM0ce7+KiYbA
	x2tSFVaV/oo5YWA1raNguSSwzhlU12wzSnK+OpvZakiBuG6tYNKwhqCmprasOgAxNior/Pw
	7yOahdIAejXIquKJtrYbpXqqBw0PXV30Q==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE49440007
X-Stat-Signature: bkhw4bk8fj1y1szpz7o1y88q76anb45g
X-Rspam-User: 
X-HE-Tag: 1788551060-173345
X-HE-Meta: U2FsdGVkX1957TOV8JZjunFGw0697al/uJbCrfnjj9N9IodSwDcyt7emyer8F9p60UyOTXODIQO0nL6DhDN6O9Ck6MTz9H/07V5Shfkjkm3FTqJ2dfOtZc4BMqrwEl/jejJCO/1vOUa430NVQDbQoJL+UJieasqK7xQ++ZVnJG426beAAPrX4ylJmcpVigHZ+nmkTn+F73X0H9MQ6rPe4nbAcxgL7MIRbdUc1xMM1CtNRdokab2LoiilM7pZSaIYI74wsz6Oo2QZDnNFPBHmdouQJLNDiIeIvMKaIe1/bNrzG8OPNGUVp9daf1L3hggFYmJu+iZLUKNM9+fNZiPajOUNBjDjBJ2UmQjFk+bcLIC4gLzf5EzIkZn1PS3l4yLHVob7yhYHRlEIgCjlAVLrcz0QYIWwOyEdJnQiqP2k5kSzBQB3CPyQJ/PAh5lYmiSfebzQvByiFpIXo/Ba+bmwUZ4UohoJABfZM/gE0HwAPxDNMI9KUB+mbhMe6Wj5YTsm1c3qMnrDBvZyPcQmsOwvmdGHdQoX+hgAGwHo6i44TzBRE8TeDUBEIlKThSJDBYQtyGDnG7psMVSYqVjr31zxzL7nYkvM7D0X+xHczISh4nuzfQ5Ri/pr3f+ANZq9aa7Q99SKOpEcB3e92YsGfdI8FZLeyLxunSLt+H1cpQWUShJFO65ep/64Vzh4tmoJrCa4QoWyFpMJJoQgsKOqk9QmI8BvRd1GN8TqKGNR8Q1ngZ0GHau2ykQ1KgdjlDv0SshodEqhjFU0fdX/mHTX/Rt0xatCrjx4nGmLSJFF8MnuhqozEEUz/Lnsv5FRP8RTNtwMMrBkAvsW+gaeha391SpDD+FMevAYj68kPiIcarygKeNNCbv7ISdFDhYeeJXYJE6Wg4i8JdeFhQBW/6XEzb+lufalaQ7m+bOk92afAtKg0TXLkZIzzZ9GlSlA/OPTiKGINBCnOALz9U+pQfW5OGj
 ob+HCO9i
 7ONYHG7z3sDBZ+8lieAgdYi27fQcsVimVyP/wcypVUaX8WGeLywHGDM03z6/NMeu72KkMR/9Eo3slssrhd/JhETO/yuABJsMsJBe3SVPm6xb+BMpq8l9Uh7zhPnMHZMYOBoo7c08wON+3RbNK+ps8tl4EPDZD/G5FaLBW4wIB3qiYKSjAF8m1J7GLtIhJH6lSU7jUp28khrhYzrzZxQ/wEdXFasc4MTXItZZC5+e6kMsI8aqz2HIMNht7MJ3x5hzglKkwUo58NG3dUmRfXqAI+f+mFBfgp7QjhkPyp1TMxiHWaWpK3pO9GqqHQPylSVBlwyrsQh/oTgkbrDkWGBYaOJhoGRrPH2yK1cecMU1AFXx+oFSJj7rsuAKM7NZB9Bj3XayI9PAIMVrGA4XOdipphuymyfg/kUZgiQDWayNw2GS/xpfX+PpfrrU1YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Sep 1, 2026, at 19:51, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
>
> With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
> back to a non-memcg-aware shrinker.  On this fallback path,
> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
> valid id belonging to whichever memcg-aware shrinker registers first.
>
> __list_lru_init() copies shrinker->id unconditionally, so every
> list_lru backed by such a fallback shrinker (thp-deferred_split,
> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
> up with lru->shrinker_id == 0 instead of -1.
>
> Under nokmem the list_lru collapses to the shared per-node lists, but
> __list_lru_add() still calls set_shrinker_bit() against the memcg of
> the added object.  Most list_lru users are unaffected because their
> objects resolve to a NULL memcg without kmem accounting, but the THP
> deferred split queue holds user folios, which are charged regardless
> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
> shrinker_nr_max stays 0 and every memcg's shrinker_info has
> map_nr_max == 0, so the first folio added by khugepaged triggers on
> every boot:
>
>  WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
>
> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
> and expand the maps, there is no warning; instead bit 0 is set
> spuriously for an unrelated shrinker.
>
> shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
> and all readers inside mm/shrinker.c already check the flag before
> using the id.  Make __list_lru_init() do the same and fall back to -1,
> so set_shrinker_bit() is never reached with a bogus id.  The stale
> shrinker->id itself is left as is; cleaning that up is a separate
> topic.
>
> Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Tested-by: Wentao Guan <guanwentao@uniontech.com>

The patch solved my problem in link:
https://lore.kernel.org/linux-mm/20260904190028.21542-1-guanwentao@uniontech.com/

Thanks
Wentao Guan

