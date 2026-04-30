Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64122CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0B66B00A5; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7271E6B00A4; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE946B00A5; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4261D6B00A2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07FDBC09E7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:04 +0000 (UTC)
X-FDA: 84716346288.22.DC8DF31
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E39C1C0008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N2FPmWXa;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWSfXutrQQEBLYlyfIL/K5SplHsx+P2yivojM0MS/kg=;
	b=e2z50f+RkiwUHB4ZDYg++XNAZPTQISPa5Xvdbm9eTRlQqw9BKGd+5ion4ZncwfcOMhBVV9
	6ue7fqc2w4zh3pAwjlS9NXokkSSvqYk0IweGAnOmd+kkW+EyLPiEjWSNaH7z16tLKObtRe
	T6P7fWOTHrPh5Aj8t3s+Z+eYp9zapNw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N2FPmWXa;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580582; a=rsa-sha256;
	cv=none;
	b=y5XrP+ZTymW71+AweB8LkkPltafp2T8j2bg13sDYcFFzBnX4M4BJdlZF0Ss5lxSfAYwWoe
	pMuJpGD1AeAuEO6ReTbY4ULIgI7U1opv/R+XAXTtEzvAoMN8H3FX6iWwY2EiH9vuH+4l1Z
	/UYzb09n6o/r9ikuexeifvKxhk6fVBQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NWSfXutrQQEBLYlyfIL/K5SplHsx+P2yivojM0MS/kg=; b=N2FPmWXapbfw75FON2bKPPYt8V
	Sq8AoC4LFxV8MVx1fThjY0Z4sqVSZGh80LVywj0WNCGIjw9CLjYOWTpmXPpSujkSsYYqh4vVr8b8Y
	pylGdDOfLqoXs+XDsznRRBhP8Vm6J+uoSQ2VrQi/ckCY7ji7AoRXIkwjEvR4KCTsAJKxxNzCnJ7vq
	KKbv5i/91ySsRqtzXoB0F4WKKj2RTMunsRK3OzoRoMDf2gnE4dZvErhSaRlG7eLCk5OXtnbUYkU5M
	MP46ivr27PJvf30USvpd5MNzpsfQ7sFnXuDJ//RrrOXZcFDNbKBkTLYPaKPPDLouU+V0KZ3KaKNJ6
	EfgSAzaA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1blZ;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 37/45] =?UTF-8?q?mm/slub:=20kvmalloc=20=E2=80=94=20add?= =?UTF-8?q?=20=5F=5FGFP=5FNORETRY=20to=20large-kmalloc=20attempt?=
Date: Thu, 30 Apr 2026 16:21:06 -0400
Message-ID: <20260430202233.111010-38-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8c3omwgtgx4b8j861gapodkoqde8kwg4
X-Rspamd-Queue-Id: 5E39C1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777580582-126320
X-HE-Meta: U2FsdGVkX18iG5Ye5mObOVX1MkBknYFea5IvSzx+xNUWh3Fwp+ng+iGerkcZhTyJEExpRTjs3Pe5J9aiFKL2U+KmpgqO9vxXVYK9HLrhxzbK8c8wqfL76iDlmRrm5DG/z6zGfXuKQfZYk3YWxyQC7SjzEk87cibKPlIP9OVkILznhLA2bTzGd71WPnGAn5L3FZNmUGt+/suB9uNGVgxLy3neLFJhkVuCP93ue8wOZWw7r8sb9VbtT/pkeHY9mwvdtdOyQP5SP+WRxacIqlNX26aZ9I7vmFxgjrRYkwL1cHW0FGqbtah5yMccOX4P6ZP9XqOqg06T0dGdFN2J/XWF413J3P4PHf52/dzl65fEmnLiUL3kn+9kJAfic0wMaHxTeZrS2+v4/IUsGOtXb7wXMPEu9TjhvwS3+JpwbtJoRqfoy6Azm2SVOIL/wNVfcQp0YeK2lelbigy/lVCL709N52OShzGPfwhyFNK++29VaoQE8WjrL3ABPGlzs8dhMBi5FaXfP0sKdGbTNscSP+itRCbmqCqEH2BWv3+XIAI83YmZ8hKhCGQnuNth72zPyj9E1dEeEK1iYQ6Z5MtwfmEhx7Rsg2ecwTyAQon4yKfpftn4I+fwSndXcyxA/ToDLpF3zj8XgWsPuzP9wCkne5UKiLlSDNR68qnnLZVR9uDYS/a1bszhgQFYdNL6brP3Vsl3gazafke3vaHlK27LCCGG+mb1BzqP3hwgNImhfvaDZLf1AlX1y9liomy9DsEk2mKy+Yu/31hMQTwV6/L+zKxzbppSosCb3mmXTy8UppQ4XYRtKS4WSr/fceqKIhwHikFCTwfvo8PyT5xwZsjb5OhPmnnF9XKjLmleIk9GKmT2c7vaV64/zgyPyvdd4CJ4993NYXvQzRn7qIEVRxRyVWVAr9dQ76kNsvh2tja0GydSgufhuSNnRK6Crk/XfZufV9aPoRbhd1z7No/xfuvP9cU
 G8+6wZ5R
 JEBmM5/GswLPNjSFOzegRSGq8i/JYYO5qtxyUQCZnwvMQqxQciSZhXMS0/PrVnPUEYibwMQ69DsFyJp3zFPx7iN0wT5YRY632oJr4Brg4cdYD/1vujBTIdJil9ivsmGRtDkoHO+2Hw0cNzjTsozk7u166v/1Ozvi04g1YDou0wJYZfLGlkQ7PXcKtANCl7HPdG1nOMGzFIUq6wIJH5epvUwv9IjeICTUu8m680Fj4oWWiymNDNJkvQOeAWEJGaH89L9DlSR/EXqZq6/+GZuxdplCr3raj166kEAJzxnAhQkme+5z/Lf/F+iFCQsSze8PRG5LJpXomPyICnYuUaY9OzoUVTGkvZ4NjzyFA+byhq3OkeHFrrzkKJvEupE2K5Fxd+V65dyR/Tsknwfw3cloQf4no4S0jbMoiaz1oM0ggSME4sMCp5iQ9PY6bIVSH8P9AJKV+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

kvmalloc's contract is "try contiguous physical memory first; fall
back to vmalloc on failure." For size > PAGE_SIZE, kmalloc_gfp_adjust
already strips __GFP_DIRECT_RECLAIM and adds __GFP_NOWARN to make
the kmalloc attempt non-disruptive. But the page allocator's atomic-
allocation retry chain in get_page_from_freelist (no __GFP_DIRECT_RECLAIM
path) progressively relaxes ALLOC_NOFRAGMENT — first adding
ALLOC_NOFRAG_TAINTED_OK, then dropping ALLOC_NOFRAGMENT entirely —
because atomic allocations have no slowpath escape and need every
chance to succeed.

For kvmalloc-large, this is wrong: there IS a slowpath escape (the
vmalloc fallback). Tainting a previously-clean superpageblock to
satisfy the kmalloc attempt costs more than letting it fail and
calling vmalloc — the SPB stays tainted for the rest of the workload's
lifetime, blocking 1 GiB hugepage allocation from that region.

Add __GFP_NORETRY in the same conditional that strips __GFP_DIRECT_RECLAIM.
The page allocator's NORETRY-skip exit (mm/page_alloc.c) treats this
as the documented "caller has a fallback" signal and returns NULL
immediately instead of relaxing ALLOC_NOFRAGMENT. kvmalloc then runs
its existing vmalloc fallback as designed.

kvmalloc's documented contract already disallows callers passing
__GFP_NORETRY directly (see the comment block above
__kvmalloc_node_noprof), so adding it internally cannot surprise
any existing caller.

Observed on a 247 GB devvm running the page-superblock v18
series: a `below` process reading a /proc/sys file via
kvmalloc(buf, GFP_USER) tainted a fresh clean SPB at
boot+~47 min via __kmalloc_large_node → alloc_pages_mpol. A
tls-cert-validator did the same a minute later. Both were "best
effort" allocations with vmalloc as their existing fallback — they
should not have been tainting clean SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/slub.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..fa422d245a53 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6703,13 +6703,24 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 	 * However make sure that larger requests are not too disruptive - i.e.
 	 * do not direct reclaim unless physically continuous memory is preferred
 	 * (__GFP_RETRY_MAYFAIL mode). We still kick in kswapd/kcompactd to
-	 * start working in the background
+	 * start working in the background.
+	 *
+	 * Also signal __GFP_NORETRY: the vmalloc fallback IS our retry path,
+	 * so the page allocator should not go to extreme lengths (e.g.
+	 * tainting a previously-clean superpageblock from the page-superblock
+	 * series) just to satisfy the kmalloc attempt. The atomic-allocation
+	 * relaxation logic in get_page_from_freelist treats __GFP_NORETRY as
+	 * "caller has a fallback" and returns NULL early instead of dropping
+	 * ALLOC_NOFRAGMENT. kvmalloc's documented contract already disallows
+	 * callers passing __GFP_NORETRY directly, so adding it here is safe.
 	 */
 	if (size > PAGE_SIZE) {
 		flags |= __GFP_NOWARN;
 
-		if (!(flags & __GFP_RETRY_MAYFAIL))
+		if (!(flags & __GFP_RETRY_MAYFAIL)) {
 			flags &= ~__GFP_DIRECT_RECLAIM;
+			flags |= __GFP_NORETRY;
+		}
 
 		/* nofail semantic is implemented by the vmalloc fallback */
 		flags &= ~__GFP_NOFAIL;
-- 
2.52.0


