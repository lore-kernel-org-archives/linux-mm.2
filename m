Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9034CCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2346B0088; Tue,  6 Oct 2026 05:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773AB6B008C; Tue,  6 Oct 2026 05:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AFA6B0095; Tue,  6 Oct 2026 05:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA736B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:18:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9801C05C9
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:18:22 +0000 (UTC)
X-FDA: 85291650444.12.3A54CF9
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE1F940006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:18:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=WNw2pdea;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=dA9ZmQMZ;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278300;
	b=lly9E1BJHIyC0qw5Ba0ouUlo80mrDc6hWQvl1nfdSBG0gud04QH4QlNnX6+2aGR2yM9c/5
	YyFyT4OfNVECdD59jaGrbb3r8epws+Bx14CFWB6ArIhPRo2z6ROn+KLxgRQHQ+yaYYuJVu
	wSTk7s5rFHgq4OmLc1fv1kMVDSLon8U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=WNw2pdea;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=dA9ZmQMZ;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DXfWVFdzWMRQ9iDD9vys1E4C/WVQnOS4eiTK9NNyV7w=;
	b=AXlcu67uYJO37P4pbNQU+fowLEJ8XZ93CZIf/UBLWCZC7ToO/FF7+cdVtuqcWVvvuRlBw6
	0FgPTmmLBkHMK4xOC4plmmhuF6B1fyYBneZUMeMN5vA8ME9PQmHGyiwZgavCStZtyPC1Mw
	F6hOaPuA7X9sQPXq3qsHpBQCbdwvld8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 23E19EC0A5B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:18:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 06 Oct 2026 05:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1791278300; x=1791364700; bh=DXfWVFdzWM
	RQ9iDD9vys1E4C/WVQnOS4eiTK9NNyV7w=; b=WNw2pdeaeXsaGx0RdVa/2ybV1I
	i0kYr5JHbwx42HD1CsH6vU5/uuzsu52sFyYAwNAr/JpEfJRSeN2sEQa+Wa+bUPHf
	9l/FAiJCt3XYdMBcWA2rckzkKklmmSpVCPN8DSKEFjFttmu1ofRhsRdoSUeBkOXZ
	Q2GSDSxOTXe6UTyg9CkSdR9uin/PG9Fs44dYWkABJg/xLjLFksVnsmM8ntKUBDay
	s+STgROt8QFYMNftURtwRWALOhpAyDEZ736TqFZwnm+mgWdbYhQAAPetpqgvED+W
	3F/mprGIJDvWMu8NSb4c6yUxjn2hTIjRX+8JVZSUq1+HOmke7Di+HLdIVc4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791278300; x=1791364700; bh=DXfWVFdzWMRQ9iDD9vys1E4C/WVQnOS4eiT
	K9NNyV7w=; b=dA9ZmQMZunaw5m+Zqq5upeHCNTdOTYD8Y0E2l0bnInjQoxPUQZk
	F/CVhSeFSmj8wIdr0Jj9aTteSFw3lmldfGk9ArplbbZPHQqaba3JE392MH9//55j
	GK0ltTLNpwExwwyNjeN4ylfH8zmLL7qxKopOX5co1Ji9BNiqhPoiLXs0G1djQyQR
	ZIs+OXzelnKDUA164yV2J0YAjFa+NNiC1uBrN+gifUVfDr3+PEwSa7i4bbtulWSu
	9UjkiAA9U5KhMyRv2Xzlr0Y57Cd+kx5s0PHDUmqqtGUpTY7aMZqbJ/9LB6ua1w0s
	cZa/ezH/ti3PRkoR/6T5zSGpkf8UNLtrGeQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791278300; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:YWP27w6cU5ZkivU3cwEtaZN+M6XW4Jly/SzgpEwyCkY5sQO
	rUpKSaFUB2r956QFtH1RjRfslnP0L0/D30yNcEwcWp0Kl0o5LO4JdugYjeGABbEW
	zmQJwvDwGu9XFWcB5yOFv/e1/AgwvVKqgqI1keqUmb/jpGsA3/9U/VgmudA78L/i
	qPDIcuUWaD0lHNFXCwFFguulGmZtggDAECNyI3dkqNZWqSoZSV13ncvDoGGpP8fJ
	jUoS2y1wkMkUGRQAX8mdWdQx2Qqohyvlarx7lF3IATRmEo3N/PKjpnsx7CYY+qo9
	CI0g4pPXgRn1Ps1CkCFyb1HBMcZJFOZnotcVNKQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:QDpJV8Oq7lWRbr6spM/JoUgxKo98Gu54C4fUNAZI4XE=:EqQ0/J4tZYzickGSAfp5bYZsGiez5BeTtSqzTBhlLDU=;
X-ME-Sender: <xms:27zEaufGpKAPDwZ9o9NPciYhIYidk9UU_VdslPy92UTAhRTI7qAbFA>
    <xme:27zEavwJYnZ2luobfbJD1ARP-Xf-vlnPZULMKcrL0KNZsenDmpF5qQ1D1oG-JGZcv
    D-_N7dIIv1_GF1kQQgDNDJKh_ryZZSgFXXMP0rHXYK0c52mNVW1fAqH>
X-ME-Received: <xmr:27zEavKysVNLTiE22ZvSie6OVxviGJfXe0UozMoXnV9wwK-UaXxRMiNU8LY>
X-ME-Proxy-Cause: dmFkZTEuV6x5p6Svnun/6xCsopXC4rEFNWzJaopYoywZiN/3Cowgwzd2kSQ6tf5nAaAbkg
    iJfB8ZihjWJSQSH0IuxjM7kUFs6mKJnYy1kcZnMAAnlrLvM2nZO81kTuo1y1XaDU007RRC
    y3s7bHR2O+wSXZD4NxZazeJ4UjF9kMNb5CgjHI8hdTGnm9fGcxkUJWNv2hcK4mNFd8mq+e
    KSWYy4FVbJptwwa8mHyOxcGAefpVbo74bpDDKJSnO7v8q8RmU9bP/ZbvX5KismatCwEHWN
    OTmPDbADDBs86XqF+utj91mCqx6mNxXzLEyPyOWDKXxaG9abXsyhz5A6a4dAGt112qgWkp
    xhEgPikzTZa8MNdXYRxnWyeS7W13MMyrg15fyvQqjBD3Ab8U7UBVhP7cUytnIV/Fv08yAI
    1giqYnUMEl6nxZjS5dD7KJKkEMXw0t7+Sd1vTG8FEDZeOUn8TXFN6QYDY51PEZBow4AE/b
    Iiz5XWuWLMncrj14lAw2Jy5G3hAiig9NnBBv+UuAyYBIYkw4TkrzFegImwSkBEwus+ieyU
    84FYyyaY/Uws80jNKn9daP6PXXKQH2jzT895wiMimU8lKYT3eVl72OQ9RoGBw1m881Ka07
    4dry5c0qFqFl12tK7sadtzn3vkz61dRoKyOyE21F7Zo6hwRMhVm9umYQYLhA
X-ME-Proxy: <xmx:27zEaov8OdDdJZpfD7JAGE_ZmPsBgcF_Hypw6ESKOgFjeCTI4HEAOQ>
    <xmx:27zEahTxCjA3s5bq-XDfpbIFxOGkui2gnvxjsANBwRE4wKaijiKWFQ>
    <xmx:27zEapTbNr9t2EMowGO-ktBRw11GiHMCUnhsIPme8TCuD4XUE3bD6A>
    <xmx:27zEatqRDu52mZuKID7KnVHlx7uP1eolBLNtnOV_ArA6IVy63i2Enw>
    <xmx:3LzEattnvOFbvRLehzqrBcwPwdH5OwTYNFU6itAntCcfiN1pvD7qn6nu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Oct 2026 05:18:19 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Tue,  6 Oct 2026 10:18:13 +0100
Message-ID: <20261006091815.897133-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5x46xqtmobkf8nu1hi8o9euts494nn9z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AE1F940006
X-HE-Tag: 1791278300-130497
X-HE-Meta: U2FsdGVkX1+pENjS052WrHfURJKYr9XyN1toBy5UrlEXiyE/MXOfI74ve4BhhgYNMhYt/ytoCRn8ZBETkNnLh2uny7y36OyvyOJfO9d0/Pk1llYEt4zXoBoMI65fjNUoNPWLfz6GIOM1a+EH5zaPVi57z8xOAGvxBMsmWbX2noYnStthm08oet0e6/3JmcEmxUCvf9iFLDmBmtnSpVg4SStxES/kH71jXglEW9JqRXRTY/+hX7MowQWPsENc+1ZINAaintOYU5DLv8OEwlKg5dafMeT5k6tNPTRkEocYLqORMBo7LVo9FpttBL6Q7RUXZKimtlsUrjbB/Ho64mWEIf1DJRb2/YtkK2YYDOl00QJXaQfj8jUUHd3pTjNZRDFFocTTTsk5oJNX9P5HjNp5cDt9BHQb8XZXkbxxTfnobpGDad4YBauXOppYRwER4PmZz9sRO17UExYAdy7lJq7Ze3ly1kAuoJFBGAsRcVMh67Fu4ILzKrP/lPjaaR7L+cIki9fAQ4+yVKsZE0VvPCI9M7D1/q9kV4B2s1hddAckle3/FZ6pR1L1wvT7/hNC/px9Ls87x/5HK5wC6tPFEExg+8fmeI8Dnd42wbMt6wYCIqQXGljraWx+I+JzLFAGiAGPlwqDvtxbwomu+pohXkKvoNxAur9waNEK2XSTUagiYVcdXFkWofzwp8San9Kc+dpn7PQsGf7mAJf0pTJXIIeRY1deDdA+js+MWFsgA7Ngbid1kVsZ6rv/YKdpFe2JQvPKdgIvzq7P/DMMeEe9pufuk8Gw6PE7aIXV015PZZOWP/WjdVht8mk1OhdaX2N5pf6FTb7yO5KLpjlEEAfc9cLhvqoTpYobPErZFrIIkF4pzv6Ei27EuYOdHReBE1bu2GRuqKf148uhn0eE27Dyn0tA6pBQeyBSnAZ8nCbyzAVCPjdZSAYPV5UezzrcTnweOI5vMxLtMIgfbnICdZ7KYdT
 Yuwfqdax
 dTYcS8CnLY37BW7bNmGgL50DApguiPAxP5zdTckb1ZZxDJfrQesHX/GogIPPbfdytgH+ZCC2oeymrsH+v6i4LM8Ur1MFJd9Z19UGLhescp0ZJmBivpy1LNg063kDRACFG+JDkhJ4X4VJ5gtjk6alz7eYLyidxJGmAYkVRJIc236HeKEnQrkha0NLjLP0ofrty1eXl/uMeVRDEOMgU4HVjOXcZR4q91ZixtMLRzsJHrf+gti8LL2OR6xMoyHs8JIQHZumfL31dYWjgHl8gjvoZ3ItebQQxH6/maJ6+b+rZ0QhCKK2NNyh6jPoDJ/i/pGXdEJqTCFpHyaeIHML63cRgg+PG9jZ9XwgDfeDN9kv01z7DUPsyV2vDX8E8wu7hGMcYo1z7gOGFVxuDvYeUZty53n8cLkQw/KpuFog4krCACi2xKUi/4i+DS11zctMymbuco/gWzfz7lXwFdhn8Hla5M01AJbnPEzK5Qrbz5iLhgIcUeMDRg9Nvohk97XpMB91RnRPpnjO1vwnXJ6BWtdrtbEjAKwnXvDFyfz61KxQhrs9e+HAHcIxehIlH6wdFPpzQZk8l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
storm in defrag_mode"), direct reclaim and compaction for non-movable
requests under defrag_mode run at pageblock_order, to produce the whole
blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
still use the request order. An order-0 request can therefore retry
indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:

- Reclaim at pageblock_order gives up after one pass as soon as a zone
  looks compaction_ready(), and do_try_to_free_pages() then returns 1
  even though nothing was reclaimed. It returns before the retry that
  would reclaim memory.low-protected cgroups, so when most memory is
  protected, the pass that did run finds next to nothing.

- Compaction at pageblock_order fails or is deferred.

- should_reclaim_retry() takes the reported progress as progress for
  the order-0 request and resets no_progress_loops. The request
  retries.

Order 1-3 requests loop the same way, and should_compact_retry() also
checks their pageblock_order compaction result against the request
order.

On a production host (64G, defrag_mode, memory.low covering most of the
workload), 95% of direct reclaim runs were order-9 runs that returned 1
with nothing reclaimed, at up to 60k runs per second. Across ~200M
should_reclaim_retry() calls in a day, no_progress_loops never left 0.
The spinning allocations were SLUB slab refills for inode and dentry
caches. The time spent registers as memory pressure, and pressure-based
OOM killing takes down both workloads and system services.

For promoted requests:

- Reclaim progress does not reset no_progress_loops, as for costly
  orders.

- should_compact_retry() checks the compaction result at the promoted
  order and does not retry COMPACT_SKIPPED, since the request can fall
  back. The compaction priority floor and the COMPACT_SUCCESS retry
  limit stay those of the request order, so a non-costly request still
  gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.

When the fallback is taken, reset the retry counters, so that the
fallback attempt gets a full retry budget before the OOM killer is
considered.

__alloc_pages_slowpath() computes the promoted order once per iteration
and passes it to direct reclaim, direct compaction and the two retry
helpers next to the request order, so no callee has to recompute it.
Harry Yoo asked for the two orders to be explicit rather than derived
in each callee.

In a VM reproducer (32G, defrag_mode, inode churn under memory.low):

                                        before    after
    should_reclaim_retry() calls           63M     293k
    peak memory pressure (PSI some avg10)  99%      12%

File creation runs 5.7x faster.

Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
v2:
 - keep the compaction priority floor and the COMPACT_SUCCESS retry
   limit on the request order, so non-costly requests still escalate to
   SYNC_FULL before falling back (Harry Yoo, Johannes Weiner)
 - compute the promoted order once in __alloc_pages_slowpath() and pass
   it to direct reclaim, direct compaction and the retry helpers, instead
   of each of them deriving it (Harry Yoo)

 mm/page_alloc.c | 123 ++++++++++++++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 45 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..41830d230f06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4127,6 +4127,32 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+/*
+ * If fallbacks are not permitted (defrag_mode), we either need to
+ * reclaim space in a block of matching type, or clear out an entire
+ * block to allow __rmqueue_claim() to convert.
+ *
+ * Reclaim by itself is primarily freeing space in movable blocks,
+ * since that's where the LRU pages live. So this works for movable
+ * requests, but not for others.
+ *
+ * For those, promote the order of reclaim and compaction to help make
+ * blocks, instead of spinning in reclaim alone unproductively. Retry
+ * decisions based on the outcome of that work - reclaim progress and
+ * compaction results - must account for the promotion as well, so
+ * __alloc_pages_slowpath() computes the promoted order once and passes
+ * it alongside the request order.
+ */
+static inline unsigned int nofrag_promote_order(unsigned int order,
+						unsigned int alloc_flags,
+						const struct alloc_context *ac)
+{
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		return max(order, pageblock_order);
+
+	return order;
+}
+
 /*
  * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
@@ -4137,8 +4163,9 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 /* Try memory compaction for high-order allocations before reclaim */
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum compact_priority prio, enum compact_result *compact_result)
+		unsigned int compact_order, unsigned int alloc_flags,
+		const struct alloc_context *ac, enum compact_priority prio,
+		enum compact_result *compact_result)
 {
 	struct page *page = NULL;
 	unsigned long pflags;
@@ -4149,22 +4176,6 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		.order = order,
 		.page = NULL,
 	};
-	int compact_order = order;
-
-	/*
-	 * If fallbacks are not permitted (defrag_mode), we either
-	 * need to reclaim space in a block of matching type, or clear
-	 * out an entire block to allow __rmqueue_claim() to convert.
-	 *
-	 * Reclaim by itself is primarily freeing space in movable
-	 * blocks, since that's where the LRU pages live. So this
-	 * works for movable requests, but not for others.
-	 *
-	 * For those, promote the order to help make blocks, instead
-	 * of spinning in reclaim alone unproductively.
-	 */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		compact_order = max(order, pageblock_order);
 
 	if (!compact_order)
 		return NULL;
@@ -4246,7 +4257,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 static inline bool
 should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
-		     int alloc_flags,
+		     int compact_order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4257,7 +4268,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 	int retries = *compaction_retries;
 	enum compact_priority priority = *compact_priority;
 
-	if (!order)
+	if (!compact_order)
 		return false;
 
 	if (fatal_signal_pending(current))
@@ -4266,10 +4277,14 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
+	 *
+	 * Promoted requests have exhausted their reclaim retries at
+	 * this point, and they can fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
-						   gfp_mask);
+		if (compact_order == order)
+			ret = compaction_zonelist_suitable(ac, order, alloc_flags,
+							   gfp_mask);
 		goto out;
 	}
 
@@ -4314,8 +4329,9 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum compact_priority prio, enum compact_result *compact_result)
+		unsigned int compact_order, unsigned int alloc_flags,
+		const struct alloc_context *ac, enum compact_priority prio,
+		enum compact_result *compact_result)
 {
 	*compact_result = COMPACT_SKIPPED;
 	return NULL;
@@ -4323,7 +4339,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 static inline bool
 should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
-		     int alloc_flags,
+		     int compact_order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4462,17 +4478,12 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-		unsigned int alloc_flags, const struct alloc_context *ac,
-		unsigned long *did_some_progress)
+		unsigned int reclaim_order, unsigned int alloc_flags,
+		const struct alloc_context *ac, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
-	int reclaim_order = order;
-
-	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		reclaim_order = max(order, pageblock_order);
 
 	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
@@ -4638,8 +4649,9 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
  */
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
-		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, int *no_progress_loops)
+		     unsigned int reclaim_order, struct alloc_context *ac,
+		     int alloc_flags, bool did_some_progress,
+		     int *no_progress_loops)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -4648,9 +4660,17 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
 	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
+	 * always increment the no progress counter for them.
+	 *
+	 * The same goes for requests whose reclaim is promoted to make whole
+	 * blocks. At that order, reclaim also reports progress when it backs
+	 * off for compaction without freeing anything.
+	 *
+	 * The watermark check below stays at the request order: it asks
+	 * whether the request itself could succeed after reclaim.
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
+	    reclaim_order == order)
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -4790,6 +4810,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
+	unsigned int reclaim_order;
 	unsigned long did_some_progress;
 	enum compact_priority compact_priority;
 	enum compact_result compact_result;
@@ -4934,17 +4955,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* If allocation has taken excessively long, warn about it */
 	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 
+	/* The order reclaim and compaction work at, see nofrag_promote_order() */
+	reclaim_order = nofrag_promote_order(order, alloc_flags, ac);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
-		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
-							ac, &did_some_progress);
+		page = __alloc_pages_direct_reclaim(gfp_mask, order, reclaim_order,
+						    alloc_flags, ac,
+						    &did_some_progress);
 		if (page)
 			goto got_pg;
 	}
 
 	/* Try direct compaction and then allocating */
-	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
-					compact_priority, &compact_result);
+	page = __alloc_pages_direct_compact(gfp_mask, order, reclaim_order,
+					    alloc_flags, ac, compact_priority,
+					    &compact_result);
 	if (page)
 		goto got_pg;
 
@@ -4996,8 +5022,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	    check_retry_zonelist(zonelist_iter_cookie))
 		goto restart;
 
-	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, &no_progress_loops))
+	if (should_reclaim_retry(gfp_mask, order, reclaim_order, ac,
+				 alloc_flags, did_some_progress > 0,
+				 &no_progress_loops))
 		goto retry;
 
 	/*
@@ -5007,14 +5034,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * of free memory (see __compaction_suitable)
 	 */
 	if (did_some_progress > 0 && can_compact &&
-	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
-				 compact_result, &compact_priority,
+	    should_compact_retry(gfp_mask, ac, order, reclaim_order,
+				 alloc_flags, compact_result, &compact_priority,
 				 &compaction_retries))
 		goto retry;
 
-	/* Reclaim/compaction failed to prevent the fallback */
+	/*
+	 * Reclaim/compaction failed to prevent the fallback. The retry
+	 * budget was spent on making blocks, not on the request itself;
+	 * give the fallback a fresh one before considering OOM.
+	 */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
+		no_progress_loops = 0;
+		compaction_retries = 0;
 		goto retry;
 	}
 
-- 
2.54.0


