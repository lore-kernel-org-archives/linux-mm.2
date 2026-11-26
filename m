Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725A8606A336
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FaXIHAJq
Received: by kanga.kvack.org (Postfix)
	id 3B7A46B05B1; Thu, 26 Nov 2026 14:08:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368BE6B05B2; Thu, 26 Nov 2026 14:08:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2305C6B05B3; Thu, 26 Nov 2026 14:08:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E46A06B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:08:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5282E40540
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:08:53 +0000 (UTC)
X-FDA: 85478207346.08.708BC7E
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F6FD80009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:08:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FaXIHAJq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795720131;
	b=OldTcW4XWbJ/TXDhIap55bnhpR893seUpf0kOxARd/+bs9FpMLtNqGfPzGPKPQol+pmQWd
	pTRBXp3DLaPKjUN38+SfYjW5S4WB8s4HVxEtCHsx2PvgNvWaD8wZPO0bgsfPjOdFZGJK6B
	xG7LwkHAaiaoSDNRqjfmygYwqdq3EeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795720131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ewvhhUgD+3DTi6q55eZEV6TlKSbwabUrukp4E4TfKM=;
	b=znz2A3M/4Cf9RQSirvrRox8P2OstdHlIrkvzqTQFVYXLUiVRK6TNaC2vm4jnhnDCtX+Zrj
	rEL4HiLGyV7qeS7FYjJr6oZSr+OkQyJMF/bRMnPq2KS1LD9gyGQP9r6aX/cjsA/139ivS5
	NuOAh6aw65a5R7zvbm1QZ87CyOe6cCo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FaXIHAJq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-386d1859e1cso1750953eec.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795720130; x=1796324930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ewvhhUgD+3DTi6q55eZEV6TlKSbwabUrukp4E4TfKM=;
        b=FaXIHAJqkB8oWbGxFCs0+6cdlA5WuA7SnsHRmitaAPjm+czOtWaDGDfXi1W787jKiW
         XQ2bh6iIUzukQ9GCrLgT/hXO3b6qlcHiRUjC45F9b/MwyjXUk9bA8ZDzOkrx7mpfpwjZ
         l8ICOqc84vNyhdDnybLDVAqCRlYvNaLdh8kf0iCUgYqeh59+kuDF8zDjBxf0sp+MyIax
         O5VCFwQTief0OtflNFNMBINriqJ9r5HDOeewi4KeHWz7viTUbQbuANHIHZYN6dpLaVxF
         3SLj+VOckEBPyaTuqm52FeylSaMaxC7vDQgD9fbSQEJ4pVyjPNk9+gOqreiSR6jGlfkm
         I0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795720130; x=1796324930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ewvhhUgD+3DTi6q55eZEV6TlKSbwabUrukp4E4TfKM=;
        b=x27eh0jmeDxF06OLKDJh8+CqxaPuuRo26hqgwVXwnsQzqaYWqTkNWSv4Ftr6H16BTQ
         Y5aM/zeHubw4y+aG+HHr05/ODwV9clbL+zu5YNzYCIAFx7XGkPeq2m3Ad4B1r8vEk+hv
         WLlurl11Lv7O/CEjGXc9FsRpgvcGlOgzksaytQRVGoGCTmW7lWWjRoorIHOsU1JFgKl4
         43BkgjHfX4rvfTxkloGT0czYHGOXO8bpTXSKblrcRKL6pKzI0XbgQWewY2QvdjqeINey
         JjGjDgP4e2o11V3Iil99zc3GS4E8llQs8Hg/tXWnhN5tOh3N1uvPCCM5fMueHBhBiiy/
         GpTA==
X-Forwarded-Encrypted: i=1; AL+hErGziPxl5B885Piq73nKuAAcQJO3C1okXBggHRzmOa8Up2f2Sc7yQeKwHzlJbd8rTXo4nP/f255Hrg==@kvack.org
X-Gm-Message-State: APuU4Z84wwU/dJEDdzPCqbvZzbgFGhZVCf+F268yz9qo0GTVKYDc5ZYD
	9QrZ7F+D3vRMGHDV+IbK6fsl6zQDRkP5fZW2kTaRK+c9AzpiLw7cJiK5
X-Gm-Gg: AZFdTZeTFZmVJxg39++6dsYTr9qSVy1YQh8k51XKhwkzl8iMK09CcEX01mW7SJ/hRFp
	89SPdIPZuEV+5n2Fex/MOlzNbcgQXVVdpe1Da1bmNK5Qb9NTDQuICKMDIKCZM9mOGrz545cRZrd
	dwJS2UJec/7wGjrXPcAUlfd5+VBBI8UnlkFu17QRK5/4t0m+xnG67CM3Y6wCPgYb8FuK92pjA5z
	9y22NUIHPAYD2lnajzQ3ak5G9M29Ksn9nptbaDWfO1/rYOupElKEC1hRHsgcAt/OebFtpwcEGcb
	/PEEFRxVwk9Ae0NbBCOwStpDrGoqXX118oj2r0lJauK0PzdQWdXSFzd3mvdnrqXPg+eJMhqufaX
	9Kabwrs7hUPBvYtqJ6V1lz0Voactoz6eXaFd5lrB06qKuQ+UwrknHwzMq1+UDLN3r9ZOIFIec0A
	EqChla/XbhsETyOgMd3yLEcFdvhD+s7DnVdeG0qi4DiXmWlEyXg7gPdA/W06Wa6K4v3+g+qVSyA
	GlJkr18G4M0qvCzcbWWTuzfKklHQS01VJuSQOzXBLnHxGz+m29NiG8OS1Ynr1ZvlwWei3L2i64c
	Ml2vTpHUw+8o61q+2Ux4Vcole1uGwg0gxxDtUM9ZPgQBSnaJfF4MWtfDHSzpvKULrwX7k0Adw5y
	D1G1dTj8NMzE=
X-Received: by 2002:a05:693c:20ce:20b0:381:761b:f335 with SMTP id 5a478bee46e88-3856f94eda0mr23029896eec.6.1795720130090;
        Thu, 26 Nov 2026 11:08:50 -0800 (PST)
Received: from dev-oss-0.tail8d7c7c.ts.net (c-73-70-201-200.hsd1.ca.comcast.net. [73.70.201.200])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd46c5sm81307145eec.11.2026.11.26.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:08:49 -0800 (PST)
From: Qian Xiao <heyheyco@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Qian Xiao <heyheyco@gmail.com>
Subject: [PATCH v2] xarray: fix index jumping backwards in xas_find_marked()
Date: Thu, 26 Nov 2026 11:08:47 -0800
Message-ID: <20261126190847.3064508-1-heyheyco@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124213424.2224554-1-heyheyco@gmail.com>
References: <20261124213424.2224554-1-heyheyco@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F6FD80009
X-Stat-Signature: 98b6w5bpusnbsyx138krsooaw7cxum3d
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795720131-849047
X-HE-Meta: U2FsdGVkX199aDw2nWkzNFC70yzmNbDNsUxUSsb/tj9b5sbRQn2NwenrZgfIAPKgMoM0hC0Dx14MTBnhv34qpvMof/wIKkG1TOzgVGC8zidlRlfAFrzqMVWgf4CmCITCu5KjiuYajVAx1PclRQO7z6oCAQ6W2U6y4nv6MWIuDesJBbH0B+SsJygoUWlngXDY2910Foasgm0wDY9+wyX+QdJYdbszPi2L0AkjJATZYjOcA+i2Qk0sDjxcLiYmkWYXdODfD5odBw3b6DyxSyjHk8PJXM+aFXmyM529duSAVSb3Mi6lSa6dCqMcm86WJ6NckoNCOiwJUPqvarf3DyrMMM6+jGGKrDCiLmR9BOgYMbIimk+qxzFhYxYrUX9M/X1vMhwEdJyKlSDx7VVEyMyMuB5RbRksqdeA87Eeezt7QRTGCeI7+isjIb8Ubts1DTFJjS9uf4SZPvKT/MQCSrM4Q1Sb8JWYMhBWaQOGYVUrt8Hi1cRsYF2LrG9dJLFK1s9J/rJLz/9y3RHK8BZ7t2UTYcsw8kDz/ZhwfUWmEKRhbuITW48Nz5w+o6ZiWFFiKxwgHBA6SYAUSTqVi79OU3B+GKPiXQWbI7oupS01KM9wuewRE7UmZoo0SNEfcIMelUXAvyRqsBnxN0NzEsj3QcsZzOSgC+2/RGM4lKnMC2CEs0VUCOySd6kzLMaiYqmNEyITBxr+7VBSyN0MmiZmvEO92UnpPMS8ronn4Rl/u6ccpsSTMFF1sj23GeEA9aMfd/0Sa271FMXg/wWNSNaUcWZyu4gn0d/9dpkaVPScz2oYkCEbq4UUSmiw6p1LS4wSbHNGSM0FoV0OxcBqvnUAWx/8Q6FUaQaeB5lbVRt4YePh5ogrLAiy4P5aYc28v+Kdf5ORlhQwhzQR7+gHzhbfwoENjOA08DMc18utt47ywUIYBv0NUw4ZsX6XvmsQXzyKcTI2JtwM3KI9/2u6DGtrL3S
 4fqMIvHU
 EYmwPjbhxEJay898r13o1Sf8zifU1muuC7+syo9RfGB1ExPPyJNLfK3JV1AEY5HvEx2KwNrBnMjtjv7gMC3TzyLdg0CRr2VWGxj6OLIRrpIXz4YKzHO/pwpbicylq+/PYEbNSxh9W19zJFk5R4scdsW3hYa0b6UYL0E+HnsCK1alHCmeLGp+1TlB8vGilzvSBZzaYSwa+inobD9WsTTq2xqlSDXEQ9+NOUjK6wvEtOR+m6LUjxq7/1AygiLREA7nl15fCHwAHYF1o1D8N3NsVT/jAJa/bUO3vH20zSKXvRzHC8rHhGhBR33MsThh37oogUPPspw2ctu8SRvKeV6jFCFEInvVSk1fxuK5qzYwo+7s8o3uyACFRsPgmP9+qTCFLEVG1T3tVVhhWMgWFou2QIUHgWyzzvMME25nFL2qxjT6uEzrpP+VKruIqAxxh7d4NMnq7g648pXBtU9vkIHKQJWSMQK/NzJGGjjpXdmg2vsZv8StIl8CBIlV/4okAdqa1NgDuPReUexNlKMgFuzUsMLeUWhSetWoo4+nUKFdzZL6UPm0Ev07rnSdJ739rJjD1zy/ADO9pRlHIyXG94tVzh5Tw3LZgOZCRJrGi3JpXm84+nyoX7Qd9OXKf8c0XQqmaFs/uIwfzVt39TI7TjtSLwHJMxFTp1Em4E467vag3dnoT1LGd0FQHaxenHMNnZQuzwW/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_find() keeps xa_index when a lookup starts inside a multi-index
entry stored in a non-leaf node, and aligns xa_offset with that index
before advancing. xas_find_marked() still does neither.

Walking from a sibling slot to the canonical slot calls
xas_move_index(), so a start index such as 127 becomes 0. After the
cursor has been walked, xa_offset can also stay on the canonical slot
while xa_index is inside a later slot of the same entry. The next
xas_find_marked() then recomputes xa_index from the stale offset. If
the entry is split, the call returns a marked entry below the index
already reached. xas_find() returns the following entry in the same
situation.

Resolve the sibling without moving xa_index. Before advancing a cursor
that has already been walked, set xa_offset from xa_index the same way
xas_find() does. xas_next_marked() uses that path when the offset and
index disagree, as xas_next_entry() already does. xas_pause() aligns
xa_offset before its existing calculation, so the resume index stays at
the end of the entry.

If the tree changes while a sibling is being resolved, do not descend
into a node that does not contain xa_index, and do not let
xas_move_index() decrease xa_index. Return XA_RETRY_ENTRY instead.
Callers that use xas_retry() restart from the same index.

The userspace XArray test suite passed. The kernel was not built.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qian Xiao <heyheyco@gmail.com>
---
v2:
- Use the slow path in xas_next_marked() when the offset and index disagree.
- Align xa_offset in xas_pause() so the resume index stays at the end of
  the entry.
- Return XA_RETRY_ENTRY when a concurrent change would descend into the
  wrong node or decrease xa_index.

 include/linux/xarray.h |   3 +-
 lib/test_xarray.c      | 165 +++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c           |  23 +++++-
 3 files changed, 187 insertions(+), 4 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..8c42d899d94c 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1778,7 +1778,8 @@ static inline void *xas_next_marked(struct xa_state *xas, unsigned long max,
 	void *entry;
 	unsigned int offset;
 
-	if (unlikely(xas_not_node(node) || node->shift))
+	if (unlikely(xas_not_node(node) || node->shift ||
+			xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)))
 		return xas_find_marked(xas, max, mark);
 	offset = xas_find_chunk(xas, true, mark);
 	xas->xa_offset = offset;
diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 615f7730a5bd..02e6843d0227 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1316,6 +1316,170 @@ static noinline void check_multi_find_4(struct xarray *xa)
 #endif
 }
 
+static noinline void check_multi_find_marked_nonleaf(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	unsigned int order = XA_CHUNK_SHIFT + 1;
+	unsigned long next = 1UL << order;
+	unsigned long start = next - 1;
+	XA_STATE(xas, xa, start);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* Multi-index entry in two slots of a non-leaf node, both marked. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	xa_set_mark(xa, next, XA_MARK_0);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Split the multi-index entry after a lookup begins inside it. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	xa_set_mark(xa, next, XA_MARK_0);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), order, GFP_KERNEL);
+	if (xas_error(&split)) {
+		XA_BUG_ON(xa, true);
+		goto out;
+	}
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), order);
+	for (i = 0; i < next; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+
+	/* Nothing marked past the index already walked. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_load(&xas);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	rcu_read_unlock();
+
+	xas_set(&split, 0);
+	xas_split_alloc(&split, xa_mk_index(0), order, GFP_KERNEL);
+	if (xas_error(&split)) {
+		XA_BUG_ON(xa, true);
+		goto out;
+	}
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), order);
+	for (i = 0; i < next; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+
+	/* Pausing resumes at the next marked entry, without repeating. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	xa_set_mark(xa, next, XA_MARK_0);
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	xas_pause(&xas);
+	XA_BUG_ON(xa, xas.xa_index != next);
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+
+	/*
+	 * A leaf multi-index entry.  The next step must not use a canonical
+	 * slot left behind by the first lookup.
+	 */
+	if (XA_CHUNK_SHIFT > 2) {
+		unsigned int leaf_order = 2;
+		unsigned long leaf_next = 1UL << leaf_order;
+		unsigned long leaf_start = leaf_next - 1;
+
+		xa_store_order(xa, 0, leaf_order, xa_mk_index(0), GFP_KERNEL);
+		xa_set_mark(xa, 0, XA_MARK_0);
+		XA_BUG_ON(xa, xa_store_index(xa, leaf_next, GFP_KERNEL) != NULL);
+		xa_set_mark(xa, leaf_next, XA_MARK_0);
+
+		xas_set(&xas, leaf_start);
+		rcu_read_lock();
+		entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+		XA_BUG_ON(xa, entry != xa_mk_index(0));
+		XA_BUG_ON(xa, xas.xa_index != leaf_start);
+		rcu_read_unlock();
+
+		xas_set(&split, 0);
+		xas_split_alloc(&split, xa_mk_index(0), leaf_order, GFP_KERNEL);
+		if (xas_error(&split)) {
+			XA_BUG_ON(xa, true);
+			goto out;
+		}
+		xas_lock(&split);
+		xas_split(&split, xa_mk_index(0), leaf_order);
+		for (i = 0; i < leaf_next; i++)
+			__xa_store(xa, i, xa_mk_index(i), 0);
+		xas_unlock(&split);
+
+		rcu_read_lock();
+		entry = xas_next_marked(&xas, ULONG_MAX, XA_MARK_0);
+		XA_BUG_ON(xa, entry != xa_mk_index(leaf_next));
+		XA_BUG_ON(xa, xas.xa_index != leaf_next);
+		rcu_read_unlock();
+	}
+
+out:
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1440,6 +1604,7 @@ static noinline void check_find(struct xarray *xa)
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
 	check_multi_find_4(xa);
+	check_multi_find_marked_nonleaf(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 48f440d114e1..eadb39894913 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1283,6 +1283,9 @@ void xas_pause(struct xa_state *xas)
 	if (xas_invalid(xas))
 		return;
 
+	if (node && xas->xa_offset != get_offset(xas->xa_index, node))
+		xas->xa_offset = get_offset(xas->xa_index, node);
+
 	xas->xa_node = XAS_RESTART;
 	if (node) {
 		unsigned long offset = xas->xa_offset;
@@ -1495,6 +1498,14 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 		xas->xa_offset = xas->xa_index >> xas->xa_node->shift;
 	}
 
+	if (advance &&
+	    xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
+	}
+
 	while (xas->xa_index <= max) {
 		if (unlikely(xas->xa_offset == XA_CHUNK_SIZE)) {
 			xas->xa_offset = xas->xa_node->offset + 1;
@@ -1507,14 +1518,18 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 
 		if (!advance) {
 			entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
-			if (xa_is_sibling(entry)) {
+			if (xa_is_sibling(entry))
 				xas->xa_offset = xa_to_sibling(entry);
-				xas_move_index(xas, xas->xa_offset);
-			}
 		}
 
 		offset = xas_find_chunk(xas, advance, mark);
 		if (offset > xas->xa_offset) {
+			unsigned long index = xas->xa_index;
+
+			index &= ~XA_CHUNK_MASK << xas->xa_node->shift;
+			index += offset << xas->xa_node->shift;
+			if (index < xas->xa_index)
+				return XA_RETRY_ENTRY;
 			advance = false;
 			xas_move_index(xas, offset);
 			/* Mind the wrap */
@@ -1532,6 +1547,8 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 			continue;
 		if (!xa_is_node(entry))
 			return entry;
+		if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node))
+			return XA_RETRY_ENTRY;
 		xas->xa_node = xa_to_node(entry);
 		xas_set_offset(xas);
 	}
-- 
2.53.0


