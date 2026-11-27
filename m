Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D51F606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YIQYFrkd
Received: by kanga.kvack.org (Postfix)
	id 42CDA6B05B0; Fri, 27 Nov 2026 17:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404CF6B05B2; Fri, 27 Nov 2026 17:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F33B6B05B3; Fri, 27 Nov 2026 17:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B924D6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:21:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CF36A7FF2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:21:16 +0000 (UTC)
X-FDA: 85482320952.11.764C1D1
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F3E4A0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:21:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YIQYFrkd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818074;
	b=HjJWhtGQFs6X+dRa3bDH4lAeCiiVQPw5CFP8X1BumS5nXbhlWKr2zM7BC9bEwYbrRoCiei
	H6buGD/EEkBIL4/nOwkiAcB6ulbs+6+ly9LS9TphzmVGsd7ws0xYW2YWtmnaJgRBKfUmsk
	STBn8ImCzKtTUADoDRXzoRqshpaKZdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ad9yIn1xRY7zD6+qEAblcHr91kNMMVHlVCdY6zTmPc=;
	b=4SxtwX5jON2lNKV7yn6DjhoadZoGHE0pShd2+fI3eB61w2O3daQlZ8v8GCAWia0oRBz6Xb
	qO4ihgUupqJ3FzP8pIxoHypLcHmgKu0nT7m0KpdkiRphHC3VSbuTVMQ9IThPx9yxrPzAmL
	8Sra7mpXifVDe1pHkWtlsat+HkhG4r8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YIQYFrkd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-380c28f9e35so9375042eec.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795818073; x=1796422873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Ad9yIn1xRY7zD6+qEAblcHr91kNMMVHlVCdY6zTmPc=;
        b=YIQYFrkdxcTUGuNVgbM8KUw/gOR4luvexU29zrVJkpKRJxBY1zNuMuC8e4M5SwFESi
         +nWyv6OElYiW/5WhqdqnH0ZGZKDH9ErYeIQzjHCpSo0drtEfkvijLewdr8U9/5o9NNhu
         28OMYLN6HCjMeUkK36OWXVJM8MfUmexTa4f9wFBBP75fCfYBpgv5jwVCVzR1l4FcF/Y0
         0LRARLWnwANo2l5hqrtnrmrG/idRqNPNS7icw4mcbcSOKSQ4/ts0QxB38TanurA4TSzk
         v/7UeqXrATtn1hXB1X9ye39K2CbFKF7VmZfZSWEtXge9pBCtq49pCfcW7XxcSzR8Jl2I
         HSUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795818073; x=1796422873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Ad9yIn1xRY7zD6+qEAblcHr91kNMMVHlVCdY6zTmPc=;
        b=GD1sTZvGMv2loUzP/wp4Fr25bjHg1i66aDkahPf9hTsFWlyYCyncOY1CJf52GamgZt
         QKZrBiRIZoDNfkqsMLGVZ+XdzphwlIxqVIljWtAzV/g25UOjPCVVUiFXlfzBeH3VCjiL
         fY8xq/FntFC67ri7tQMD/9RmS0xykedRR+6KvpJ7BP7GszrQEFhpxWwLGJFBlfLKqW43
         swIVHqVfvC06F29kBmvq8FRygw60ajzLQRVEf36qOfORPVGVX785nHD9SptUiYddG0J3
         YCjQUFc6fXRz0JyYCDTatGnPMN2uABBexhon7pZJ7c/AWA2LzOPRNCjbPDjeEtIP3O7U
         ophQ==
X-Forwarded-Encrypted: i=1; AL+hErGU3QO7XqMR3mk2pB5g6DAkA1AaRG4bp4N4Mka9/sp3BrdAMYLTNhPH93rmIjT4PFbwKmUFIbkNoA==@kvack.org
X-Gm-Message-State: APuU4Z95/z48hUf8nFI0U4FwCrZUmK9P7t92mPBZ5dsw5pGkc0adR6mr
	0NzT6vzXEGMxmHL8Oy2w9S8R/q2TWghuNTpftAdq+RBAUbLhcNuhWhWv
X-Gm-Gg: AZFdTZeWU6xG/mmWYkyAbFWUEq2RZ9ZUjUuRjPBsqUYyCX2CukyhmKyVgig0+ODTNnx
	1OE3p60FS8sZ4eBWyHuXKhhUz+Nqzvpx7bJbr0g++5mNaxQ3aVQYc4kXEwBk2DwS1j1UevLVdMz
	wxIPPwG8HFcEnUqSFLPpaTGQdxzvYp1RBWYLD0Gev0TKtXSBVCzcim7KGUpEfBDPCnCyjz+NoA5
	2vvdsyEcI21VrUd/mO9N3jmrfmqo2sT5fdbjd+XhHSZl7gVaFldsHhBVXpROemBLw63TunKcgn5
	0FmRad2G1oCslPaHYN6vI9h09JsKZtGG833Bz7f3Fofnqe/fJlbkqWhfplXwqchX3zxT5gJHym5
	dczwxqyAQQPj80maLGG0thOfkjVjysWXEb076opa6AuAPicz6YWiiuNyYNYmU6RMqzynXKEIksN
	9uaxUrb0Tcx/iMDHoDFv43TPEt4bCdYkYQxEgef7n43dZpySxmXu5ZYF4WPhr/T5+RedPPJfj5C
	gRzEsd0QPWn/+ZlCjd7WzaTywbSlkZrhqb3UyHP1roXV8e8Q77aB9aihjl5Yh+rLgAMEHcWhyDb
	4Wy3ZtBU0p73rhk2pKbxrw1CCeUZUw1TSi8L04MmLB9PhpbOjNmkAHfn3gV6QP6JnW5Is7arLVl
	vEUWrNqDLz88=
X-Received: by 2002:a05:7301:a0b:b0:386:a416:6c91 with SMTP id 5a478bee46e88-386a4166fdemr19591656eec.20.1795818072796;
        Fri, 27 Nov 2026 14:21:12 -0800 (PST)
Received: from dev-oss-0.tail8d7c7c.ts.net (c-73-70-201-200.hsd1.ca.comcast.net. [73.70.201.200])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672c6f31sm74080760eec.15.2026.11.27.14.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 14:21:12 -0800 (PST)
From: Qian Xiao <heyheyco@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Qian Xiao <heyheyco@gmail.com>
Subject: [PATCH v3] xarray: fix index jumping backwards in xas_find_marked()
Date: Fri, 27 Nov 2026 14:21:09 -0800
Message-ID: <20261127222110.3755894-1-heyheyco@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126190847.3064508-1-heyheyco@gmail.com>
References: <20261126190847.3064508-1-heyheyco@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F3E4A0007
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qgszupci4maj4z1emet9585i9ute3ebe
X-HE-Tag: 1795818074-525411
X-HE-Meta: U2FsdGVkX19rt/99CVibj5GDdQKuQ7LGAxi33pzz8UP6/RrAGOVQJvyLHpapFmGEDRZM/uWZ6uMXfox+18eFPsFU5cZS3Qri9vS2uSNtgHKhQFX9npo9YVMRw1TE8R+U+sMESxslZhoynkkZUSFdop9Ky97jqwTbcmxZIHXyLRF2pJ/NCdgszrskzKNiX5d4nP83XmHfjoj2DXGxRzSLhsAcz5ZBQC5NHJCvo9soho37TKz+olYlzTKjEhmiwZwfV6q8qteHMzoxn7iFsZMzXXwfC7vvdTuOlwkhPv54ddL4lEiCIn/3qyXF2905auyBLFFe6RmOkjzxMbE5jY0p4m8uP7eVydCMLZ3Xy7bYpE/Cfmd2aEH3nMLBqJzlBi7Zw4Y2IwZfLXpP7N1pzfEfMZireZ0yHd+lWvm2d/mzLpdx2XX1kB5zE97YCryKk96hVljNaPorvL4TGbtU//dm6UXwgHaTEt8DiAhFFqwdmEuRALCCERnXZGzNJiDPlIxabhvxPaYdsLs59dJypewW0iN9ij1/JqB+Zs23uy32stupyPxM8NSc6qSmAGZCIxY4fwxTKwz2TTK5sE49wnivITjOnuZfxWoCOdu4X27yThOuPGvhel+YX5Y3w2JDPy8rHl9RPz/QfE9n9VsosNpcXN/d31RnIU7mM2Aip+LrcDlx3R7mBVrRPgHo4FmgNbeResqyszDQxB0aGd0zs0FqAqTgIzch+MVGTnO6c1MHWY2M6RUkew9SA95Ep3dHxU06fC03XD4TEbgrvrM+DRWOEPkGufYDaxjJAq53Z6le1HCrVuQCzALvTbsav1DjeTua1keuVD+oo+FSvFNc23quUpeGCxBTGAUgZo3DGNTpoGOyeQgxF8T/MqtS3JuEf4FfLy6MCl6akeJS0JtVXFPtP8ak3k2UO2o+rkvn9Kvvp+nziaAoIlO+ykQr5cWqRB/gQACHXz010Ux19B1sJYk
 mKBeaVQZ
 PJv/kqtHFOLKsqCQY7F9RTNVothIPHYazgzphJd7bHRPdvVXBSdhGRZ3Rvk1Z7pZAksFHujvl/Db0nAObmMIA0OA7E30Msxu0l1vT7S6SRQidOQg0IzvqosEtCMSNtHYZCbWVr98eH3EzJ27x/KNzoEkwwSe8GY78KAcYllHXGqMld7YhTu+bSdrnUUBqkb2l+OR2284P/NeqNcuM4CPjsfiE44q7o4DSq70QMCNGh1zgQIf0ISzI2iSEencXDjeESGvrv9Qh7Qn44x2W9XVdYxcPz0g9TxKA/Lmp6KxFAK7h4tc4A99/psYtGfmWzipurXU6WeeJCBNWevLqaiTdpZ8WQkJeeXvJWc1dy8usGZzyQM1ucJ7+bbpIVfp2D+1so8+tbH2fhuHcEUgTmDN4mAcsefIzwgfXT6Ih0rTcXQRBV/ArMpdJLyxT01vvKDVXCm+GSOHMjsmnfIR129Xf8PGH5m0p60wfDG7kh1Qj1ZirNH5FL012r3zcoFMHUNpXWR9HPVewky/be56Hag0mG6p6fdGIIRfwMVnSWn2sXbw/5l6a0TDQQjRLzo/fqNzKKrESThf/kgqGcS9Xe7L67T9GdXzlza+Q9Wf33rbBlOodUe4FxMjENDW0RnjxV1uetcfja71i3gD/OfhT/ZD/pAZIoo1Ni5x1obPuZRxTVJ5YapbUozfuQieNvZxkpPvtVuG4
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
into a node that does not contain xa_index, and do not move xa_index
backwards. Compare the next marked slot with get_offset() instead of
recomputing xa_index with a 32-bit shift. Return XA_RETRY_ENTRY.
xa_find_after() handles that retry before xas_sibling(), so a rewind
that then retries restarts the walk. Callers that use xas_retry()
restart from the same index.

The userspace XArray test suite passed. The kernel was not built.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qian Xiao <heyheyco@gmail.com>
---
v3:
- Compare the next marked slot with get_offset() instead of shifting
  in 32-bit arithmetic.
- Handle XA_RETRY_ENTRY in xa_find_after() before xas_sibling().

v2:
- Use the slow path in xas_next_marked() when the offset and index disagree.
- Align xa_offset in xas_pause() so the resume index stays at the end of
  the entry.
- Return XA_RETRY_ENTRY when a concurrent change would descend into the
  wrong node or decrease xa_index.

 include/linux/xarray.h |   3 +-
 lib/test_xarray.c      | 165 +++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c           |  24 ++++--
 3 files changed, 186 insertions(+), 6 deletions(-)

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
index 48f440d114e1..9f29a064849f 100644
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
@@ -1507,14 +1518,14 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 
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
+			if (offset <= get_offset(xas->xa_index, xas->xa_node))
+				return XA_RETRY_ENTRY;
 			advance = false;
 			xas_move_index(xas, offset);
 			/* Mind the wrap */
@@ -1532,6 +1543,8 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 			continue;
 		if (!xa_is_node(entry))
 			return entry;
+		if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node))
+			return XA_RETRY_ENTRY;
 		xas->xa_node = xa_to_node(entry);
 		xas_set_offset(xas);
 	}
@@ -2258,12 +2271,13 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp,
 		else
 			entry = xas_find(&xas, max);
 
+		if (xas_retry(&xas, entry))
+			continue;
 		if (xas_invalid(&xas))
 			break;
 		if (xas_sibling(&xas))
 			continue;
-		if (!xas_retry(&xas, entry))
-			break;
+		break;
 	}
 	rcu_read_unlock();
 
-- 
2.53.0


