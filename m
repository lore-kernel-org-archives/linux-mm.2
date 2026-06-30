Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84109C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9D26B00AF; Tue, 30 Jun 2026 15:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2637E6B00B0; Tue, 30 Jun 2026 15:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152366B00B1; Tue, 30 Jun 2026 15:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6F656B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6064DC2BE6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:01 +0000 (UTC)
X-FDA: 84937516482.24.62C17FA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD41D100002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Z2x+VgVu;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846539;
	b=MVBBcn/MuNPFrtzcAj9EjjEjdAUHirq32Rt/70wS4FfKFy1Q2oljS4EIWzjtcLGdrvzEKy
	y0qKzMVVvc7CticKHGEwDgsAYjdQrHOEwcfBLfcxZZBgUi5RrzwzqKMdEkVK4nBk45buRQ
	d5P+oiFjkEvM36OzCzExXjeTJTuLJJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+gaCNHAQ/zwxessi7PExTqAzXXTvnSqt6SMtkrDO5w=;
	b=IWZ4PVy603O5kyaYN5L6yvSBkQPtJEap+EYVujAZQNPFnyIKhYXGpzwZfw8hZ5uLcGuLJP
	EBFiK82OoP6ywwIbe4Jd7RN+FWYChES3mEx1PBUzEG+PyGYMb1IBoh67/LV+bsZBTSDMuD
	ECOjwyeMLKe6pArnqzvwlcwZNPd+Tbw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Z2x+VgVu;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q+gaCNHAQ/zwxessi7PExTqAzXXTvnSqt6SMtkrDO5w=; b=Z2x+VgVuIPZvb5yx1paacQgFau
	gvViUCsS03jpTeGVhn412PKdCqxRp6EX+huFqr/ejMxX1b1mn9Kh8V9m1GyJ0eBc93od9sdsnoNYQ
	NkB2JWwq9Xq0Lwk8J5le3q4tsdwg6PAJF+IG6XUlDPoPZ0NR0tO7hkE4B0cQ805QSFGff/PRHaSHh
	A//4p/OvhaAHctNFSdGIgRdnFP7BNtVvXLG7e/dJnHO/mcW+y7EW0bLvn+qaP0Y7jDRLzo0glD9Tj
	YRy/DiPeaE8Z3PRF0Wc5b2rqn0tTDXNyoHt2Yd8LJ2lwBooMdObeM5fh53tdpL9DKMMM4Zm1MkRX7
	wG1mcZGQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpK-000000005sp-3ENG;
	Tue, 30 Jun 2026 19:08:58 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 07/19] maple_tree: Clarify comments on mas_nomem()
Date: Tue, 30 Jun 2026 15:08:31 -0400
Message-ID: <20260630190843.3563858-8-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n6mexaxecjkpzem8nwmwb6nmx1c3azw7
X-Rspamd-Queue-Id: DD41D100002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782846539-500554
X-HE-Meta: U2FsdGVkX1/Z1uvqh3pd7cO73j8zQcg9jkv22cnMaV6jkxtravveGzjNIS369zhJIYwixnxW4soWP+wSv1rM3NdeR67thazpY2r8YRfYFjNpkObVBiGgqS1rG+82ea74Y1ialuGjFPwZ9NteqHl4FL1lJavKX1URjHmfk5RTysN6rg6eV4M7AknTWU5D95RzTMqnTdvLX/rdGnEnhiCvr4FX6txsFQwNGLfff3AePhOPQb+Mz1QJewj+dZ2WbHqYb9vX6X66ithL+w2Y+/esrnQd2I7BMsePGCuAy999INbmYIJlLGxUHUCHBRvhtXQL3P2k6jP2gKY0s32/1saFuNChVGdAVnNDtS4gGncL60CQAjcCD8w0rAs6hqF8FBtPl5FQhS81vBAc6ECIbeUfL+j5Vhrj61YZLGvc+nfLkMRX4O0e80Gb3lic0REDjJgXeAOPNJoGDNiAYOLyvrxXY7pO4N7IpR74CCoR0dtnaMcHMZxeTpxp4v+sEiOWW4flxNxXHyOoaayqu7UkEsjxdI0+vR0wyG+TPqyMHWo84q3fpEV/3xPvV46bKoeL/dTJ7DYL9jVNjuuugm2l0TITasubGlYvU6Xb+TRQW2xPfy/pj9OVaOjAeqKk1uyVGk98Gt57zQ9OUAbJkzN41Jyv8K6nOswkbHB9CrkPjQsUWiqcDkz41LirfqRrdXYZdZ9bU1nUwXnkVQcABMbL0igB9KZS4FhLf5ZYJtRyfSnyM69Yy9v3BYh7W8yGJfHoEOej/nMLyU1g30DuvrAJr1k+xxkWsshdU/EOumZzC4wvr9vrI9iV/E5WlygiRvnmoCOE9GXAfNQnZ7EKQX3sy38F2ZaaC5f/fDnvu/YGQyKGRBlTTry6EfcIgaqB/RyxZ/yNdCqlFBZFdsMYixoeU3HqD7RKp71q2RLWmYLXfgF4KklzZ3JlMbT2K9sSNIA0j9vQ298W/nwE5ss/HrWtyGM
 Oc4HUjfl
 llKHojKVkfeGGhj+HcH1WRt0Nf++7aY6U+g4eGlmwzWEWM9vZTPB/XEZwUNBRY4Dc0nJln1syM8g/QT+TQo8JpDkYyHPxdVT1FdoVFur2sZgpz5jGqgqSqbKiDlM4Iwta3qBKqWVF+nsgZSyFnP3UIuBhoAAV7rcmW0ZQFkNJyGuYIHnD2tOYVFU4J739CjyDBdpHc50GZiUPU9hotdMeo+1eXlOC22hz2sEy3AunQkVhzHd7Xo393bc2zf/5jKDfrCjWVcCmnRYgavIgOy4BVtIHmWAwmZfhD0hR9KnZ9eqCamayoajFSGgvxaykzVBKSorF1oeNLWJTHNFW1VdVPmYZxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a
retry of the operation.  Note that since the lock may have been dropped,
the operation is retried from the start - including potentially
allocating more memory.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 97849db132e7a..3886b856d6e3a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5676,10 +5676,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
 /**
  * mas_nomem() - Check if there was an error allocating and do the allocation
- * if necessary If there are allocations, then free them.
+ * if necessary.
+ *
  * @mas: The maple state
  * @gfp: The GFP_FLAGS to use for allocations
- * Return: true on allocation, false otherwise.
+ * Return: False on no memory.  True otherwise (partial success as well)
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
@@ -5695,6 +5696,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
+	/*
+	 * Return false on zero forward progress.  Partial allocations are kept
+	 * so the retry path will attempt to get the rest.
+	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-- 
2.47.3


