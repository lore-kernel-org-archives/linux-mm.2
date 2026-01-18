Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45499C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 11:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835DB6B0089; Sun, 18 Jan 2026 06:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3926B008A; Sun, 18 Jan 2026 06:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB7F6B008C; Sun, 18 Jan 2026 06:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9EE6B0089
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:00:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A358D1F40
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:00:52 +0000 (UTC)
X-FDA: 84344791944.24.24DB428
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D55B18000A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:00:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fVcvTQcD;
	spf=pass (imf24.hostedemail.com: domain of 3YL1saQkKCN8BMJDFSZIMHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3YL1saQkKCN8BMJDFSZIMHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768734050; a=rsa-sha256;
	cv=none;
	b=Pw+C3aSHFM9czRKq9ZVRxw/idUtvRyAdRGCGotCyC6wcunYN+ntTFt8HZOHck6uowi7x6T
	L2Ob1iG2ALwPOIMJqmmQ8mWL7m1SbIP7WicKKrw56zhGMvyaPjnwF4xuDfliFS9hwh4oN5
	zh0rAoeTbtb6sBrwRATHoo/yiOUdDJA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fVcvTQcD;
	spf=pass (imf24.hostedemail.com: domain of 3YL1saQkKCN8BMJDFSZIMHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3YL1saQkKCN8BMJDFSZIMHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768734050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wUST9cPr8T30JHIuQSYsAwA2N754vQ1EOIK7UDUsXC0=;
	b=mP6rHaioWSkRqp5Fs5iBuNy5Lf3VXotJl09ql6YFlc91LM0PAUvhr8z3RSuCZUesKBTZM2
	/8hj2MDWYXHkdAwUleu5GAHHKNDh0vLDrgpOEndh3AtFjfxWYiVOkRCRKmwLyUGHt0ERWS
	pjDhr+tJDD6b2kc3unGQx1xzhdVHvv0=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4801d21c280so19766305e9.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768734049; x=1769338849; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wUST9cPr8T30JHIuQSYsAwA2N754vQ1EOIK7UDUsXC0=;
        b=fVcvTQcDIGMnEFtClkzaypBmUzRM7Ied5zBmHw0we5iby+hTQjOCzZzlzzzIRhnsVN
         cyDXxhkrQjRdvcR3aBMrdT31iExRWp50KqQL2dOvosJF+l3LwmJ8Kag3ipdOq/SgeP9M
         k+gj151d1JAnudumCXWCLBHTLe5jkepEfkVqmwrmIItsUWwDjRuH8RfNPASQD/koOWy+
         hUmPH5SDGMf0SYzHh8hgMT/7gfZnezmrbIR/mnO7WvYlXOd3fCtwLM7zPcfDp17hS31t
         PxRlMok8Ga5ZUCor8jGa6bo0jhOBG/5TCcFzWKT9sQkFeg0ulHoa6OFm0uIHqc7lmLg1
         TgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768734049; x=1769338849;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wUST9cPr8T30JHIuQSYsAwA2N754vQ1EOIK7UDUsXC0=;
        b=bJY2GfWvt3yXq8+cVFSge5Llf6ffqRlOl5f6PEZz2lAfe5qfWN6RouuJ2Gtg5sWVHg
         4hBgJxNdUGLuLQfKoXlZVBh9yuYT515a/wnwMi72c0YzhmVX9RjvemVJnh9Y8CdvM57e
         SxYxg4fhiwI6BOKnv4+5FBDHvbCSRVa052T78WIz20qR0TnA8y+R7lGoDSiEiNS8dWKx
         AO3sMc95GqlGnoZjPb09Ch/uicuvlRK1fecHyxu61S6yzX8D4Lz2ybTkHFR66hOW90hr
         cK47RDIFCGyrHD9DpUWorpYGoCFZdgPbN2nQ2FqXRrk10lIhkXGBQJhaQ4DQoUvAZ5XI
         wGeA==
X-Forwarded-Encrypted: i=1; AJvYcCW34f2tsxRwRN9VNBTs38SvKwHMLhpoea6bh5UUunS1+casIMEvflPAWOORWQqZ5JJ0D5e6gh2rjg==@kvack.org
X-Gm-Message-State: AOJu0Ywk3PXzKrAtw1SlTxilrTRmUH8o+39X+W+BmitTv4vyA+lsTQJ5
	Hs/lxWlsmoWsHKlX0LzAHYZLK0VfcRcupUX928IS+oerZkNeHZM6QbLtnina6wG4VKXTH9pgAUB
	mBBa738sRE5VPTEQ6Ww==
X-Received: from wmpd39.prod.google.com ([2002:a05:600c:4c27:b0:479:2d82:5535])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b78:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-4801e30a790mr107192225e9.8.1768734048426;
 Sun, 18 Jan 2026 03:00:48 -0800 (PST)
Date: Sun, 18 Jan 2026 11:00:41 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFi9bGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQ0ML3dzEYt281IoS3ZT8ZF0jA0Nzw5Q0C0PzpBQloJaCotS0zAqwcdG xtbUAJP5ixV4AAAA=
X-Change-Id: 20260118-mas-next-doc-20171df817bd
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1892; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=u9J/bJGSNnPdIKbJhrrHpNL0yNKiZTldG8Rd++APQeY=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpbL1ae0lcj1GOZmP+tMN0ODnOJCFvuv+EfebbH
 GMWaZgr9juJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWy9WgAKCRAEWL7uWMY5
 Rj5KD/4uV7ym/gmcwhBGHx24jiAXaPv/6im5InPLkxj6/orReLPeTNGRm59SXtP6qzxQDVa9bYz
 El8i+3Sw0WW5++kWKs17YIVtrkuIxUQQpycJvmZA2H5JW5Z4GgUCl/a5VjysNyamV09cBfLzolr
 VI15GPc+AT8siWnb6OSGWHYkzBV918u5WUwNQmJ+TSpjSr3wyU7fPxGZX0jUhrkbRU5FxEZiJwJ
 JulbvajrxFbBPsofsKGsW0bO5rbdKEz7sR5vmxKdLm2lgXJ2yBr7xVI/T71n10brWHdKEj7Y+Ls
 BH4c5WJmrLY0eMHwTv9Ua8GugxazsuLxWBq1xfRQ914F6yXz7tX49hIpZXHgHaFejqQ+AVrpIO6
 8otogA7oPyxlwdLpafD9Qxxek37RkMWE6hwyYnXw4YBhlszbA54krA0KDtzqaU/ScMgY1M9LAyQ
 ts9BHH5pokO6kSqDCOCTNQfT+WvOiUdAJiTxhl1wAC5J171Ey8Fcv1+GU66hmOosOShbQQbktHL
 7NOo6Hh/jsYl5Y7XTrppL41oM6Pz+1cRgDG23cPhGgevHaJzd4tO6p/lnzG1BpMkByiERuRtYKW
 JQRM+YXkBD1OEhva1UxgFnQFOZe2tqnp76nZWpBd4GNh8cY2GjpwXHY6yQZm1y5VxLT//EXjL+l Ok175H6aFWMTXpQ==
X-Mailer: b4 0.14.2
Message-ID: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
Subject: [PATCH] maple_tree: update mas_next[_range] docs
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D55B18000A
X-Stat-Signature: zf4fx7c6dc9ypesrak9pnnidsznaginc
X-Rspam-User: 
X-HE-Tag: 1768734049-861921
X-HE-Meta: U2FsdGVkX19Tyf6KoGYtHQhTf9jdJPeMffSDsGrMVJtSkkZRUP8uegfJRYPffAYbAZ09ASFgeppnImC5azyrOPlvqlH60gAAMbwgixblvB0YkuwbXRXF6DqzZ/VZ67lrzYfRdNGL5fmlq5dd7ev6RmClX2uiJpOU9MWT4XP2Uz4BxY1Nj+Ujidq+ikF0bkdP0/toFlZRsX3bv8/tImbvn9n2sUVPI8nh9bQyQlc8rtDDqIX/D6mGlxEEk0+fXPqMG2xSOe6L0U6cpIz2weOhgs9rjZ7aRNDXGbHX2jJLU0iGR25uqtp1RYGWlAMDxinQeSLr4IjpvqRd5BS7ZBAwjAXgMtZ1wn13woseFF5r5yD38CA5xORLlF1TYzz0vpDJF4Oa+VI0UUodbncczUpgze8aDNC0f3OBJy1mUZqfoFVgFnOPqknyGQqjZh+4bRB80bPOFwQxuXlziTOIFeS/6PxXuIxObZyamk67bos8JyBlmlgMy/GFqLAhG7g6n4oqnpNnkx63Av8DNkXFAp2vjcWRPJk8ImH7ptKqqW91jLYUla1Sc+GipaA4nv4BEIPpg0OU3rhrR5XK0UNeqH8na8kTgjGj2aojAuH9NE8ne8zEK/FjsfyetnPvJwy7fPlE9kbcHhzJz6qda9hM5fIRIuBOnfSym9dIJHWq06E87bsecoZ0RvciDKSdWF/Ftygq88lC6scisWGblkxjgfb81Gu2jaorgomCTQzfaFwhnprgh0GRWTZhpRVqw4V81FSHG+6qDL8KpKTR1DHHYIit11L9KUPGo75awPa3JbpGPNvQdma3HcBIE9kZlpucs+dklF616kr+KCJiD09fA4BtCegROax5gn7wFN4Eh1XgVTLiqzlG2FVQg/6Tuz0f0vu5nu5g1KcqaAbSexwd5QnyDNugIAH2//fdm2PDSJF4ZaabInT/mazqvGQ1TiWPy8j8ujnko2y+AU5ITr+ApZP
 vBeeUHgl
 cJVv7+b92MwyN1sdf4rwErn+97Ye85uNMokvX2sqhht1ZoViNB1PhgAXK0LzpzyKefOE9sunG7fslGfBkbRan5/vao90FmDxDz9kcnmbJqJMqD/3S0r2AKoWgK70XLu0108xkxMo0rFoopSvzaMZr0bhiAQ0s9uqwYCoCgF51jkrLYG+DhKZ/QQYZSe4KcW/tzZeojhLhxL1qfqtXhAcEF2zBTAMaD5CM7PR2mQtpLsJuXwaQAr0JZvkeoWAOSLckuisGVScwpqOAJiUFYF5GBpBdu3kCTbVMhItYLK1SJK3roDI+BSQ9jcYPc7/X8/STitKZKgoKXtELVIB2uzawszmgvkDgBz47xvL/SAu5Hcwsk4/0OQHxg9ai7Cy8TjIWlj78SFhdWOz+6H73UglAqoGUd1xdgDXlsumQH7mZrj2LC6qmr+HUPcLAbbaNKz2CL3xXNrIJ8gNUExuoNaqPMl5LRM8EBrIEl6SaMqNGgLbkXK1sdNrT3B79EijA6ZVpcODx9zPQmXzH6S20smlT6dvMGh5MRkgGjKNKBh6m0XsMkZQxhXlmE+x6FV48n5K36/WZzwS1NsUDo7fzMB9QySfZAvmMz56wvzzwSS1dYraksbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If you read the docs, it sounds like the difference between these
functions is whether mas->index and mas->last are updated. However, if
you read the implementation, you will instead find that the difference
is whether NULL entries are skipped.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 lib/maple_tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c95000188d3ba461418e09445be78098578e..fe0f0440cd84e7a0fe946d5371e651d153f40d21 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5293,13 +5293,14 @@ static bool mas_next_setup(struct ma_state *mas, unsigned long max,
 }
 
 /**
- * mas_next() - Get the next entry.
+ * mas_next() - Advance the maple state to the next range, skipping zero entries.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
  * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
- * Can return the zero entry.
+ * Skips entries reserved with XA_ZERO_ENTRY.
  *
  * Return: The next entry or %NULL
  */
@@ -5316,11 +5317,12 @@ void *mas_next(struct ma_state *mas, unsigned long max)
 EXPORT_SYMBOL_GPL(mas_next);
 
 /**
- * mas_next_range() - Advance the maple state to the next range
+ * mas_next_range() - Advance the maple state to the next range.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
- * Sets @mas->index and @mas->last to the range.
+ * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
  * Can return the zero entry.
  *

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20260118-mas-next-doc-20171df817bd

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


