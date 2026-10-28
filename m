Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8C2606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=QTh47pKM;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ENUkJ2DX
Received: by kanga.kvack.org (Postfix)
	id 174B66B05B7; Wed, 28 Oct 2026 09:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C1E6B05B8; Wed, 28 Oct 2026 09:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A6D6B05B9; Wed, 28 Oct 2026 09:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD88B6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:27:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E5A140CB3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:02 +0000 (UTC)
X-FDA: 85372110684.08.C6AD280
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53C924000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q Th47pK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ENUkJ2DX;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPBl/TT297QWcJPsiMtRAhK9ex6xiqI4q5OAsNfIr+U=;
	b=K9ekHxBrWNkhf0khvUnUfwGgC9AJPDtxwujD8InRaqF9ELd9kEfT3/txtHNN+P226QLuFf
	vFwfsNr3zOEw0dHFpOUw9AKNY33fDk5n88gV0Jzs6d3QbBkha9E1ZsMM+z1gP7RpCyYNd6
	k/uLD0l3RREFklitrHW6o3BXc0d7AgA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q Th47pK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ENUkJ2DX;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194020;
	b=GuZr2NK9FrBG/sRJ6/0AFGi+8y68/tfWSB/S4iJmDd7TfIEbXDhVeoOz8SyfCR2GYreerE
	JvY6sAPfNet7Jog/rTCDQm1LHkOxTyeFkX2KzQahJtkKqcSX3GZLrPLeK0WIfY/EgHJ4VW
	ZjosfmejcaI6mKd4eB85LdcB1alA5Mo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id B1B2D1301F43
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:26:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Oct 2026 09:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793194015; x=
	1793201215; bh=bPBl/TT297QWcJPsiMtRAhK9ex6xiqI4q5OAsNfIr+U=; b=Q
	Th47pKMOnlSG/WbxDKcncgeh2HA6+Xta9Srtio3EEbJsTh7kToHiYdyj+tq3bIZ2
	h/rRDlJxOlI2yDHm6XkfAZ82dhARXDBdRcDu0AJc04XT2ShH4mjNd0RAbfw4U8k1
	TwYAZkRrY6R8kRSLWJ5HTIJi5aLsvcASwmuO9OJs/jytfLtohktsWRtHRRw+nd5r
	/Q6TxRjohP44PKXq9PvPvZisZqaDpoLd7XdXHBOzKDQurAj1d94OmOUWfycL42+7
	Btsiteyz2WzqG0nuXmZ/iE2Gw+26ZM9xIOdvb3Sdn2haplf5lumkUDM7PXgC7V6q
	LlOQEhASqktq8z8PDIvFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793194015; x=1793201215; bh=b
	PBl/TT297QWcJPsiMtRAhK9ex6xiqI4q5OAsNfIr+U=; b=ENUkJ2DXKtXx67EXB
	QjEP3r/z/RPVejwiT2klvwN8NX6EQsh4yjp8A4/c2dJSCWpmPe+BNgEXYLZoAaCO
	LBElrgOqENM+imLF6J2T+gRuNgioJdb8BPdXqQsGLItwE3n1V6qe+YvwdVE9lGd0
	98UhV2rFJOKMYmBakPnU7Fgb88UL0Rso0eA8MehCxaKcNmJgqNjh3bFWyr1utrwu
	2Fy/RjRshngLrSv2jj0C8JdkzhTHBuuCy+rTt/lWygjE1CVJA2qRyUEP1qZ4N42Z
	ker8hL0OE+x8vdhulV47I138G8x56IVFgP3wmX+2+VxWHO0Iy8hSTh1gbFSmCMp7
	s+I/Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793194015; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:BfadJ8P6QbmgnrJPtPYzz+8/fQxIuzu/hrS6ZwayWCE0W2v
	HTy3qmYXLSRIqzV/HlneXYuL+UXBObqFtxZNTUSVPMUyFAnGDx9NsEUaynTs2y6n
	0P/u3sIlN6db5a9uVgTGk5PjR7e9lo5x667Io1G7n+3beM7KhaTKLX0dgAELY/R8
	I+LkqNsa+I44jkT3vrkEyDlZnYdF9UYEUFcxlzPJ6HHg1AliIOqz+16nr5GnbT6l
	8GXC2R1tFWEpmgXLljko0qGfnRu4RuQrbn+5nrjKEjaMBePtr2Os10TBxZQTQZR0
	6gf5FF6Omgy0GexICp0EYShfBJ5MSBauKv4lGMw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GLqNLZ09BjO+5GlxoIsP/P8imHBEP/XFGgpFBQFZfK4=:w4hNMgamSCLsZ2GiWnuSrgYZvJ+R/7Ja86P8/2iYPcI=;
X-ME-Sender: <xms:H_jhajUqN6NZ7pxKohBZs8JECxQTDU5XNZlkMYWdeBU6qi_NTuznvg>
    <xme:H_jhaspN9dSEKcYAqsQf5LAr6nIg-8Rh08su7v84Gn-vBEzOUMjP5-wPcReSSELXj
    lz3hFaWea9frG1afJ7nkBxwfBQGAgWSIe8o-JOn7OeB3AbhiL7RyArE>
X-ME-Received: <xmr:H_jhaiVwFSlmbAD5NolQkk4CMa2uclPXraxB4T9W_jVKw6U7jIHndTwLdTM>
X-ME-Proxy-Cause: dmFkZTELN6uMNbG6eK5P9IZD2oO5y8V4rZBhmUqip2GpWbRq1Hza3mk8lUqGh4ls3IYTuD
    S7oGUlqzuuDVpdfnTZ5sBQ7yDEX+pPK1fLFZOef6ULoH3Nstq/UficFbAacHtGzpOeoZLa
    LXcMLdzI+ZmdYi30aOP/TFPgthANg5JiytuQ3Zn01ttsdCtmjxmhDJdh3vvNg0rMtWYd6n
    8S9/K9z5gJhsuqQDkdKNxdkwBkPlP4+zDzwW5tgFc6fs8f/OGu5PZQ1aPHSOlTXP5NQjjJ
    MvxYSxvQKF/2wh7AuNTRD0taXw/eXU2UNtlrTiQzr5hAhUwTDjshuhQDp3TSanoUaabNmD
    6HEOk7XwjyCP4GiXGg7bDXvr6nxQi2UFBoUtHoRxiWzT8P0zCT69zWo0dhCPMGU6qB9ObZ
    qw4vpQPc0NZ4LqN/0LE8cPPTylOhRzBWyjtGitrdOMYA1pLJXja3NAWhlB+RsTvOPhvcDB
    cLeeRMVXhxpoz0ePlp537MuS19SfY91JA0jDlwnoPJHXEUCLBaihBwcF2slCH9pN8tCuFd
    JrH8cQu2AQpxXy2k5TyDFBo6z3GWLkZvXL7nHZaEnfT33YETLOwLbaRGA1Wq2btd9pu/n9
    NT79V2ObSx982r8EznQ3UqsZPrHDYOGxfRm1ddjNLNPKhALMC5LX1h6OowzA
X-ME-Proxy: <xmx:H_jhasBD2IuzgpznCgppmXj_rCFAxtA0UDlo-9VGzkldqUc_CnLLrQ>
    <xmx:H_jhamUUROtDpfqQxS4baZEBYxTgLIHcdGUAOMYbqgSmy97XzpW4iA>
    <xmx:H_jhaq8FsCMLPhVHhONAiU99afYog3RRSKql4jcW5jRbZiRokY2V1Q>
    <xmx:H_jhasn9JYGzs9z8xKCqNgS0sIPH4xGDee-8pN5Nnb6theoc7mNoHw>
    <xmx:H_jhapKreZANtLOjHJGF2sj1EEeL9Jkk4ne8E4gISjCrG3U7qVGKyuy6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 09:26:54 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/3] mm: page_alloc: make the high-order watermark check honour ALLOC_NOFRAGMENT
Date: Wed, 28 Oct 2026 13:26:36 +0000
Message-ID: <20261028132638.2560361-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028132638.2560361-1-kirill@shutemov.name>
References: <20261028132638.2560361-1-kirill@shutemov.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53C924000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uof5nx4on7yhr6ite9fzbeh3buifk855
X-HE-Tag: 1793194020-187847
X-HE-Meta: U2FsdGVkX1+wHIk/EbpJeDflLf0zR4aZ4s3RvC5oZhtF8jisRnKFBj9QyFIdc61R1op95IGSi/VOOdWUHe6Nr6TyDrP/l6KaiGzsMu+N4BQnW0jjF1IZzi+rodGFFed8/VNnXaRTy9K09dJaBzHjAJ6UT2UkCeElh7o7vSAa9tRq17M1h9g+A0Z//LtyhLk4r4Dw6ZnGmGbqXw8YtL7kzD2zjOYmQkGAEhWWNrkcVWQyuPmN8e31ZIHjY3TvevjGUsamrQj94AglEXIdaxohB0+R733efMmkOALBw7PjFPz1QFJvuLiixDwUEcX2bwDbl/U9RAtsz/jmN7YP8UUuKwfuTSYbkJhizlYJYgNE2kq3pne/2u+PF46OOVeooY8660tpQUXB0vXG/GPSk21gQC7whu3gr+o55qIK0idF4a5ZungBMR4skYPFINpMPucXHwOZyayaKTLJdX04oPhuwMfqcXDhyYbRxGGERXo1z640a9gDexLlxvBxYtfPjrD2i+wDBDf0FRUcA9N+FGyhydYXxPZlwyKB7Ar5IiiY+4Ua/1FmbE81P6QkUnhlurxd76zc4D4Eof+RoTLeSvbnM0Bqtq0lja5qYIMl5uNNdxVpdbVUVkJu3WwypNprHDmA1BD1LNK+TU40KOBJfb5903PQJ+OIb3i1Ej3ffjpnGbFJA/iez0BQ/uEVWnKHPwXY1jz5jjUzJJvAbC3Ef0SS82wBP4HJb7WS37nzAjxaeLz9+Yos+D8gE3KhesuDMAcN6tSG2dP13CVgDGBW1WAj8W0Q7j61pwDD4IJni8uU65CNCFQ98YuZ24R5FVoMmS61lSmvVI1iwCaTv5bOBhyA+LV7LGnWc8BmoClwVFO0lfK7Tqr7sDC0fz/AaYnZkJ/XoUjlOjec1IandbvNwJU2Qr8+lu0svcPAN+OPlHMV3uS3MSbPGMVdUXEvNAtn+pEJGfEJn3IcsVySFz0ZcyF
 BkygpZDL
 f08Wx2w1BQ4ZSsfnVUIo6b1ejvA6CQRdfKUUHY5IA/DYXiN5AqV3HqNmRpxfEzvfLtEHxIBFKLxudHoZNsgtnErudaLVAkJX2A5AfFCiuQbBze6MJLeHGP3Ia0GhcnIUt5o9L4p0S9v8nQ2F+kprS6v5W3stg0lZ7tTKRy/ciBS9lo5s4e8ZKjUbEOw+gth4MO3qy/auH3CKcwbQy5e0NJX7Y5mg54kpu46Qi3eXGLlFZJpqRgf1Ce2uOBV8hIFUFvwLY7k2s2xrIfxOgyhPPuMcQpjohbiBBF4RUNxgGyfXKoBkfWmLmFmI8qZ0rn9qC8wZYNMTpQ+Jr4//nU4DKboP+8DVkUtaALi+3dnevMWqrzDuA1Pw5uGXdkjQWUrJgvpffbxABHtTsQYex34ccyxNPi3VKqxBYlOoT2iV2asl71Vf0IOVfrjDA69oIc5qNQWjwg+MxfHXlWcZyL6vQoAnvo3FV+rnqFjdo0b3K6rsxUs218jVPFUtzRTTsJz9Ev5kRfW2S+K5hBe5KiG5K9OZhgR0fdL15/kvejLzPgSt3iomYKFMXWGK7v3xn4uyNmYEKdlh8oiVbqHRhhqDWiTKkp5yV7z5YD26mUEnqIyNs7IGuf3r2cphirA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

With defrag_mode, every slowpath allocation carries ALLOC_NOFRAGMENT.  A
request below pageblock_order may take a page of its own migratetype or
claim a whole free block, but not steal from another migratetype's block.
The high-order part of the watermark check still accepts a free page of
any migratetype.

Under memory pressure, movable allocations take free movable pages as
soon as reclaim frees them.  Free space in unmovable and reclaimable
pageblocks is off-limits to them under ALLOC_NOFRAGMENT, and builds up.
The free pages of order 4 and up end up mostly in those pageblocks.

A 64K mTHP fault cannot take them, but direct compaction's up-front check
counts them and returns COMPACT_SUCCESS without compacting anything.  The
allocation then fails.  Because compaction "succeeded", it is never
deferred, and every fault stalls in it again before falling back to small
pages.

Dev Jain's benchmark faults 64K mTHPs under swap pressure, in a 7G VM
with only the 64K size enabled.  With defrag_mode, those faults stall in
compaction 18 times as often and get about a third of the folios
(medians of 15 runs):

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + this patch
    compact_stall                      1690          30669          2607
    compact_fail                        621          30531           906
    64K faults allocated              20750           7391         11538
    64K faults falling back to 4K       725          13832          9945

Make __zone_watermark_ok_mt() skip other migratetypes' free lists below
pageblock_order for an ALLOC_NOFRAGMENT request.  Give
__compact_finished() the same rule for its fallback test, so that
compaction, once it runs, stops on a page the request can take.

The allocator fast path gets the same answer.  A zone whose large free
pages all belong to other migratetypes now fails the watermark check,
where before rmqueue failed, and the allocator moves on to the next zone.

should_reclaim_retry() keeps counting free pages of every migratetype.
It does not ask whether the allocation can be served now, but whether
reclaim and compaction can still make progress, and they work across
migratetypes to free a whole pageblock the allocation can claim.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/compaction.c |  5 +++++
 mm/page_alloc.c | 21 ++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6c553d0e90f8..7b2267bbf115 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2365,6 +2365,11 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 			!free_area_empty(area, MIGRATE_CMA))
 			return COMPACT_SUCCESS;
 #endif
+		/* Under ALLOC_NOFRAGMENT it may only claim a whole block */
+		if ((cc->alloc_flags & ALLOC_NOFRAGMENT) &&
+		    order < pageblock_order)
+			continue;
+
 		/*
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 963f39734d38..7605ee60df5c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3589,6 +3589,11 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
  * will return true of the order-0 watermark is reached and there is at least
  * one free page of a suitable size. Checking now avoids taking the zone lock
  * to check in the allocation paths if no pages are free.
+ *
+ * Under ALLOC_NOFRAGMENT, a request below pageblock_order can take another
+ * migratetype's page only by claiming the whole block, so only free pages of
+ * @migratetype count below pageblock_order.  Without ALLOC_NOFRAGMENT,
+ * @migratetype is not used.
  */
 bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			    unsigned long mark, int highest_zoneidx,
@@ -3651,6 +3656,9 @@ bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+			    mt != migratetype && o < pageblock_order)
+				continue;
 			if (!free_area_empty(area, mt))
 				return true;
 		}
@@ -3680,8 +3688,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages)
 {
+	/* Serving an ALLOC_NOFRAGMENT request needs __zone_watermark_ok_mt() */
+	VM_WARN_ON_ONCE(order && order < pageblock_order &&
+			(alloc_flags & ALLOC_NOFRAGMENT));
 	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
-				      alloc_flags, free_pages, MIGRATE_MOVABLE);
+				      alloc_flags & ~ALLOC_NOFRAGMENT,
+				      free_pages, MIGRATE_MOVABLE);
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
@@ -4688,10 +4700,13 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 
 		/*
 		 * Would the allocation succeed if we reclaimed all
-		 * reclaimable pages?
+		 * reclaimable pages?  Count free pages of every migratetype:
+		 * reclaim and compaction work across migratetypes to free a
+		 * whole pageblock, which the allocation can then claim.
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
-				ac->highest_zoneidx, alloc_flags, available);
+				ac->highest_zoneidx,
+				alloc_flags & ~ALLOC_NOFRAGMENT, available);
 		trace_reclaim_retry_zone(z, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
-- 
2.54.0


