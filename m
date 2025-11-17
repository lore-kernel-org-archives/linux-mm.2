Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BFACEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2E98E0015; Mon, 17 Nov 2025 17:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5932C8E0002; Mon, 17 Nov 2025 17:47:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4340C8E0015; Mon, 17 Nov 2025 17:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 320708E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0264EB806E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:22 +0000 (UTC)
X-FDA: 84121586766.01.6EC368D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 146951A0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MohOxIjf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 396UbaQsKCAIcemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=396UbaQsKCAIcemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419641; a=rsa-sha256;
	cv=none;
	b=GuOkzUz2G0f5yJJ2AzpJ94d6kdsQrCC1Dojj3IBPx1I6ezFddD1S5cSxZ3jfPODP6ucXb1
	fT2gs0e5HCqOG8S3aQOINX+5Yhbt1PQ4xCj4J3Z6hd2yayvEw1h9LF7cPP5vbpRGQZOBKR
	9CmmOAnP+QjhMJ8jEac9DVXzKf8h27Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MohOxIjf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 396UbaQsKCAIcemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=396UbaQsKCAIcemgtng0vpiiqqing.eqonkpwz-oomxcem.qti@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h49/4ez8nB53RwngFZBAQKZZnMeHtus1TaIAc+Tmfyk=;
	b=j8Mm3ka8GSYtTr2oJtANNAY+t8Up5cGZ43lsrhUrQEbVP7FV1ro6a0IFoXhb/XKQtPHbED
	D1jZZfhWlp4tXcKtlvVN2KJ3sw+5oWh+6sifQbDUWz6zuYIHfmW2T/CLrSNG91kHx0mBcz
	kcpUmmM9O1mQqXRs6VXEN8w4FmBo+SE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29809acd049so80454445ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763419640; x=1764024440; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h49/4ez8nB53RwngFZBAQKZZnMeHtus1TaIAc+Tmfyk=;
        b=MohOxIjfcfm5gCa7cxNeUZswDaYidmeifqCZyS4XyqfjCg5rmzD41kpdNFD+E0Tc/W
         oDGzraI4dz0x0in7Gji8feodK2mvJGIS9lGrF/39WiIFwtHSpVyQM5Z56mLzuX6eclYW
         IyWLctedyS2dv6/gMW1n9Hjzqc4FNwiwNkcDnCpnuj9GFpiQYUXv9XcyVDzGq3+YXpAO
         IlGnUW0BFHbnBgjiA+ayEPZGITBDjLtYDwwIentBG766KeHNXV/OwXhUsQmmiYnD/n3P
         At55iy6M1Zu/WKajeIUCAdrx36UO/3TsEii+tWjP1BlQq3DPcD24ngm9MdMJxSdcQMOp
         0HRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763419640; x=1764024440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h49/4ez8nB53RwngFZBAQKZZnMeHtus1TaIAc+Tmfyk=;
        b=IH4XkrAwGsdKg+aDp5Ed41cjwLVRxshjNNovay0I0NRSXKjy2outR+j4m0ud5nxD1l
         Jn8t+SpDMvpC4KjtljmlcrwKkeFdkmfFpqyNuj33VU5g591lro5F1ATu1fA972vqP5sQ
         /6Ul9HDuAXsE7ObF2ZGk0XkGgWKOqdDl8gchiJB34MEv9Vj6cuvKsEdIY7mcp1a9Xjpx
         pXnc2nH6+Co4qGObwE4jLww4CsUyhQaJGDudn0jVZrysWBS9zgRKAacVhP+gUmxse2gR
         SSqNlOKATR6R9jkDzIDab8QfPTEx+3a/raPwp2sjW1P5m/+xWd2dqCU61Y7iSdIfl7e8
         ZGYg==
X-Forwarded-Encrypted: i=1; AJvYcCV+//j8tcuUghNzf85dFsXv5j85nhyeoH6ljOgXXXIk2/6Y1xeVsM3c1TI+OVIuay2LpqY6I6oSkA==@kvack.org
X-Gm-Message-State: AOJu0Yx91G0UFp7PQqP1JMpe0BZrRaoML+B+0+FEuGQHgUZx2WrekKCf
	TK+lu2LHMDMO9HAXRpgPpTFuHtwhfCmFJqF8K2AuQk+yIEzMsATUQqkvH/OeA+sxw6BzoeAHqcZ
	ZoTine2UXAkDoRgh8roA4i8WsCg==
X-Google-Smtp-Source: AGHT+IHWA3n4fRLuQQDbvqes2g4fdvBQx26NqKHJhSXAuqe2xxxf8ttHYK65SO+WREJuuBGajBPt+OclghSCG+uvxQ==
X-Received: from plok14.prod.google.com ([2002:a17:903:3bce:b0:297:ecd0:777a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f691:b0:295:6a9:cb62 with SMTP id d9443c01a7336-2986a73b4a7mr170440805ad.35.1763419639915;
 Mon, 17 Nov 2025 14:47:19 -0800 (PST)
Date: Mon, 17 Nov 2025 14:47:00 -0800
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117224701.1279139-4-ackerleytng@google.com>
Subject: [RFC PATCH 3/4] XArray: Support splitting for arbitrarily large entries
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 146951A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8fsskjrdhj76h91gdscoicbgqiy351kd
X-Rspam-User: 
X-HE-Tag: 1763419640-504456
X-HE-Meta: U2FsdGVkX1/cudsk8TmH01uxuc+Hz4GOWF9O7QZSLu/sZQrmvCrsseIyB3WdT0otC9lz1P6k3lq7XD7Y4eV97hb7GEGFxQirTTiSKPD6xLZh+7BdRdLEf1Pz3/J1MxPSk0+JbCb5tjaKouHS83HJFEc4ewdUuxQ1z2NVQopVCAzboGUGIw117kOTc6X8va8IaV761lMBPlaxA/TCm6hfIoHVv9LCE6amuVE9X0mpIrIjC5vO+CWZ0z9ifmz6nimX2ERE3GClDRiHhSDRnGRV30XgcCbu5qzyFRyjsYPtghQvpUlfZlZjd9TYLtLh5jM63dvyGNkYtFUEjfVPTw29TUrUIzGQ8wFbaJUIzPjpVXEfM5cSVUwAEJBnYyNSiZO6W+/TNI9NazjpMyaTp+53UqQVu5IyIWKeSFViKrr8sMM9d+ZT2yVtYNXBItIYGu6XXKca1dEQr0LJAA1c/8QG2S2+FqX3zQLdrobAmuURvo2z1lhR7RApy+SzO0tOUhQjD1AXabaHK5sX4pzB7n+/NwBWPH045YQdu8G9KltteXzUQsGG6iPqEeDHC7ZDQd/XS0S5LaUauflucKs0p4mR/LUaUtwe+6Tc4WeFXJUs3hFmjURH7zdd5AJH21YmpNmmUjWkxMZQFnRAGZcC7veZuF2HSS0AV9jzM0HJ0l5+TAJ34dLRw5hVu13J8IhRYX5aKmaZROUCpxcd2VzqMzr6zLJ5M7dLc1r11h1Y4mj7dEQslj08TFF2hSZ9QQX8z/V8n8XHgU0xhbWTL/Nl89jd/3uMA14sBnB7p+RnLDipkVwiL9ZDDFrEh2yRdFAyLkg+IELo1tnRm1HiNaFSFNYfrt5jK713PqC5Qrs1dkKu/9/3R5Hdt2pC122PVCJ8fNmAV58rMOurypREuuwW8uzOUnmbntdrN1AQeoA2FtySmld7CkzHCTsbaqF6Gjb4VW1bjhHJlBpwg6kZCPr5B/w
 sAT7e+3X
 e5D/qQWmmcnT40ncvZ+lT5TzeVzYXVxLaUG1d9tG0hT2tzvssEa2nxdPUlGGdRDEvf3IgeOnPLegNlRiKoiUcW7v9uZj2Sgf6U9QxvcVUczjx2fHGYtLoEUuZkdBqrqTWm6RexDaSwgBgzShK3AniB3e5i6sG9o5bd/neSr6CdQ3yzvTN4skYpPMHwX+XpOP9KKg9t7sv0T0hLEVKwfu+3Cw0jjZsgwmT7QwRdL/Q0hLttBaIIY05loO3vMFJbhaemkiBcZR5DE9cyudoFaGGEyLpCKlJ7i84d3rss8mqJlq0L6ECwyKy9VguHrHXsuSd+nHf/61Rdne3SglJ2HTyuXxWD0LumPRTBI/IcZ+PEOtxp1Wf0cKGxNFR6RyzgdtXefxaPHU+YF7ARS6Y4FkbhXir4YIp3mGEpuRTxu5CHEOdTElD5bPRTausX08HBHB4JhTDFz0N6RHvn/aw2gOuAUhFLT3Yj2ZB7y0jL7fmPReSZyDTE2xSjb6ZpzY36KAOcr4pfUmNX/T3cZjWeK3CYje9MRKtlWZtAmiN40oHcMh6OPPqBkmi6hWWNp6i2cXu5ugVs9YMmMeubHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing xas_split() function primarily supports splitting an entry
into multiple siblings within the current node, or creating child nodes for
one level below.

It does not handle scenarios where the requested split order requires
wiring up multiple levels of new intermediate nodes to form a deeper
subtree. This limits the xas_split() from splitting arbitrarily large
entries.

This commit extends xas_split() to build subtrees of XArray nodes and then
set these subtrees as children of the node where the split is requested.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---

I had a recursive implementation which I believe was easier to understand, but I
went with a iterative implementation using a stack because I was concerned about
stack depths in the kernel. Let me know if the recursive implementation is
preferred!

Feedback is always appreciated, and I'd specifically like feedback on:

+ RCU-related handling
+ Handling of xas_update() calls
+ Use of node_set_marks() - can/should that be refactored to be node-focused,
  rather than in some cases also updating the child?
+ Can/should xas_split_alloc() read entry using xas_load(), rather than rely on
  void *entry passed as an argument?


 lib/xarray.c | 158 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 121 insertions(+), 37 deletions(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index b7c44a75bb03..6fdace2e73df 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1105,52 +1105,136 @@ EXPORT_SYMBOL_GPL(xas_split_alloc);
 void xas_split(struct xa_state *xas, void *entry, unsigned int order)
 {
 	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
-	unsigned int offset, marks;
+	struct xa_node *node_to_split;
+	unsigned int offset_to_split;
+	struct xa_node *stack;
 	struct xa_node *node;
-	void *curr = xas_load(xas);
-	int values = 0;
+	unsigned int offset;
+	unsigned int marks;
+	unsigned int i;
+	void *sibling;

-	node = xas->xa_node;
-	if (xas_top(node))
+	xas_load(xas);
+	node_to_split = xas->xa_node;
+	if (xas_top(node_to_split))
 		return;

-	marks = node_get_marks(node, xas->xa_offset);
+	marks = node_get_marks(node_to_split, xas->xa_offset);

-	offset = xas->xa_offset + sibs;
-	do {
-		if (xas->xa_shift < node->shift) {
-			struct xa_node *child = xas->xa_alloc;
-
-			xas->xa_alloc = rcu_dereference_raw(child->parent);
-			__xas_init_node_for_split(xas, child, entry);
-			child->shift = node->shift - XA_CHUNK_SHIFT;
-			child->offset = offset;
-			child->count = XA_CHUNK_SIZE;
-			child->nr_values = xa_is_value(entry) ?
-					XA_CHUNK_SIZE : 0;
-			RCU_INIT_POINTER(child->parent, node);
-			node_set_marks(node, offset, child, xas->xa_sibs,
-					marks);
-			rcu_assign_pointer(node->slots[offset],
-					xa_mk_node(child));
-			if (xa_is_value(curr))
-				values--;
-			xas_update(xas, child);
+	/* Horizontal split: just fill in values in existing node. */
+	if (node_to_split->shift == xas->xa_shift) {
+		offset = xas->xa_offset;
+
+		for (i = offset; i < offset + sibs + 1; i++) {
+			if ((i & xas->xa_sibs) == 0) {
+				node_set_marks(node_to_split, i, NULL, 0, marks);
+				rcu_assign_pointer(node_to_split->slots[i], entry);
+
+				sibling = xa_mk_sibling(i);
+			} else {
+				rcu_assign_pointer(node_to_split->slots[i], sibling);
+			}
+		}
+
+		xas_update(xas, node_to_split);
+		return;
+	}
+
+	/*
+	 * Vertical split: build tree bottom-up, so that on any RCU lookup (on
+	 * the original tree), the tree is consistent.
+	 */
+	offset_to_split = get_offset(xas->xa_index, node_to_split);
+	stack = NULL;
+	offset = 0;
+	for (;;) {
+		unsigned int next_offset;
+
+		if (stack &&
+		    stack->shift == node_to_split->shift - XA_CHUNK_SHIFT &&
+		    stack->offset == offset_to_split + sibs)
+			break;
+
+		if (stack && stack->offset == XA_CHUNK_SIZE - 1) {
+			unsigned int child_shift;
+
+			node = xas->xa_alloc;
+			xas->xa_alloc = rcu_dereference_raw(node->parent);
+
+			child_shift = stack->shift;
+			for (i = 0; i < XA_CHUNK_SIZE; i++) {
+				struct xa_node *child = stack;
+
+				stack = child->parent;
+
+				node_set_marks(node, child->offset, NULL, 0, marks);
+
+				RCU_INIT_POINTER(child->parent, node);
+				RCU_INIT_POINTER(node->slots[child->offset], xa_mk_node(child));
+			}
+
+			node->array = xas->xa;
+			node->count = XA_CHUNK_SIZE;
+			node->nr_values = 0;
+			node->shift = child_shift + XA_CHUNK_SHIFT;
+			node->offset = 0;
+			if (node->shift == node_to_split->shift - XA_CHUNK_SHIFT)
+				node->offset = offset_to_split;
+			if (stack && stack->shift == node->shift)
+				node->offset = stack->offset + 1;
+
+			next_offset = 0;
+
+			xas_update(xas, node);
 		} else {
-			unsigned int canon = offset - xas->xa_sibs;
+			node = xas->xa_alloc;
+			xas->xa_alloc = rcu_dereference_raw(node->parent);

-			node_set_marks(node, canon, NULL, 0, marks);
-			rcu_assign_pointer(node->slots[canon], entry);
-			while (offset > canon)
-				rcu_assign_pointer(node->slots[offset--],
-						xa_mk_sibling(canon));
-			values += (xa_is_value(entry) - xa_is_value(curr)) *
-					(xas->xa_sibs + 1);
+			for (i = 0; i < XA_CHUNK_SIZE; i++) {
+				if ((i & xas->xa_sibs) == 0) {
+					node_set_marks(node, i, NULL, 0, marks);
+					RCU_INIT_POINTER(node->slots[i], entry);
+
+					sibling = xa_mk_sibling(i);
+				} else {
+					RCU_INIT_POINTER(node->slots[i], sibling);
+				}
+			}
+
+			node->array = xas->xa;
+			node->count = XA_CHUNK_SIZE;
+			node->nr_values = xa_is_value(entry) ? XA_CHUNK_SIZE : 0;
+			node->shift = xas->xa_shift;
+			node->offset = offset;
+			if (node->shift == node_to_split->shift - XA_CHUNK_SHIFT)
+				node->offset = offset_to_split;
+			if (stack && stack->shift == node->shift)
+				node->offset = stack->offset + 1;
+
+			next_offset = offset + 1;
 		}
-	} while (offset-- > xas->xa_offset);

-	node->nr_values += values;
-	xas_update(xas, node);
+		node->parent = stack;
+		stack = node;
+
+		offset = next_offset;
+	}
+
+	/* Combine all the new nodes on the stack into node_to_split. */
+	for (i = 0; i < sibs + 1; i++) {
+		node = stack;
+		stack = node->parent;
+
+		node_set_marks(node_to_split, node->offset, NULL, 0, marks);
+
+		rcu_assign_pointer(node->parent, node_to_split);
+		rcu_assign_pointer(node_to_split->slots[node->offset], xa_mk_node(node));
+	}
+
+	WARN_ON(stack);
+
+	node_to_split->nr_values -= xa_is_value(entry) ? sibs + 1 : 0;
+	xas_update(xas, node_to_split);
 }
 EXPORT_SYMBOL_GPL(xas_split);

--
2.52.0.rc1.455.g30608eb744-goog

