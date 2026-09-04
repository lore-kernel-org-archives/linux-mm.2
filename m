Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2EACC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F7D6B008A; Fri,  4 Sep 2026 08:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0866B008C; Fri,  4 Sep 2026 08:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF106B0092; Fri,  4 Sep 2026 08:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 757C46B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:13:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 079A11C2C40
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:13:12 +0000 (UTC)
X-FDA: 85175969424.24.7458220
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37DE44000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:13:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P82unSEa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788523990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VePVaPZTkw+6DtNuaRA17uIRjgsuoVwzCjlWsl2fbEQ=;
	b=7UvcDcYr6dgTEDyX/VI44BFTXJM1QLywdl6VvfD1nQ2br/Yti2BQFuzUQSU/HNMycl2OBq
	Cnfih8YgzGDKf0CijhzfXVRKzTztXEzdhL9eqiuEyk+X2Ej4AaCmkOTSlGb7oO+XhweKu7
	Q4tyVQ+5pVJacW93UsklYe5UmK/Uny0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P82unSEa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788523990;
	b=iOuerQDCgL51H0qlr3MNBkIOByJNeHNNyeyrok3h57JfB0G+wKSIK0GZmWnXvusu9JT5tJ
	DzBbzfV7yTxBwRXnh/1NVtqFYWVsacSaiG4UdsRIQa2ZDeiX5cfNteYi+bL2la/iMMCtEW
	Cqfj0k5XMiV9O2iTPRYkXFgU/4eESh4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48441fa5c37so607937f8f.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 05:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788523989; x=1789128789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VePVaPZTkw+6DtNuaRA17uIRjgsuoVwzCjlWsl2fbEQ=;
        b=P82unSEa13cG85VjhOtqEg1YsM1My9QxWa4H+0tED2u4gyCEKnCVjLwOfKPoGn8zhA
         MI7vb9OubOSoTVMnbA9Jg2G8cR9iVDtPJ/Mu/8IGusbI/zfgDwrQq6zTUZGxkTbqjwoD
         YOs2C/MPJabpnaNCyZL37f8aKMZiFHqvshvUzME3+ka4icftHdZXx/Q9R7dggOBTyuV8
         c7yDUWCxVDi5VbH98sjAQtztpUobYx0KzASmHm1d50uLG1Z+ixDviIiTbWFP52qfo8ys
         iGySwqvMpvRSg7h+TZsh/ExpFRX5jLqpoovLYwYZtK/FjwtgfyBRpfAW9YwISn67SZ9z
         Ap8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788523989; x=1789128789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VePVaPZTkw+6DtNuaRA17uIRjgsuoVwzCjlWsl2fbEQ=;
        b=HXh9XSJAUPo54GQ7O/OMUvTovfXIzmXTW9416/K7IZYE7tE8thqDjtgmQ66DVRrCEo
         UEpNddtIzAY0W1+LnEs4c2+6bxl++VrpPWMEdfUfsOXY7DPfJiW0vHm8uq3Hd6BeAiCS
         5uzw+Pu4/RzyOz+JWHD5bGFBXVC9xedOZ3usjdrxqFgS38qd1KUUwpEtQFbY9HYIAUOD
         FzPOhSkblnzmpsacPVS4YLAcmlj6ttsJI2xMOWhHvJ5ndVOzuuIyZOXqu5edPPYyP7x1
         HgWtJzeTSnxSAjUtx1BBH7r9yewQLYfcC2WmuVWN8xgeEiCv6me3g/ivOj+0+HbRL0Fw
         ApxA==
X-Forwarded-Encrypted: i=1; AKwUvBx2h/RtPbmoTtuntuGvZCP5tOIL1pgEsztQxnZFe7jOigFA3n3ewCmujGyln+bP7lbIqE0al3SmNQ==@kvack.org
X-Gm-Message-State: AFuF++lrDF/DkAPT2YCQ39WkfGYQ6c8csdCSF1jS4lmmVn3YTI4jxa8k
	2wyqcBfVhvImXk4pGjk/L+aXdgE44X5i7gCjU6qbAXX1qLlUPGs8sxkc
X-Gm-Gg: AYBFou2xmet/NC9COhrTR5NTnASksAiuKQdldvSZYF7VBp7TgdNfIesG72RJNXqcue3
	onrlg1p/Bb/sDv9D6eRhyTBWoED0sUW4It9SFjtWxd+4rutYSaWUuIsaYiDs0wUz2D/+wLU17ue
	7F7noJUm17lMaCI7XBLbz7qnhvR4btwP2SHohZigKuAIFJ+ib7EG9wxMj3rQT1+yU8afoShAVq5
	FDWcfS1iw6vc+jXWQipo7MgvevtgZ7n46ZWUsKY8ykBo7Pvm6awMVC4Lar004midmTd5DsFZdnp
	Br8/8F7eHNFiDWUmcP6u3pPIAjJsCcndpAAGwUYoA9uMIsz+0FGCSyzDjfdXnstE6rBGMzJ1XBY
	oFSdyzRLo47bQuCuzLiz5mKZ375d+XDTZziioLXqNEayahYdMZIuK3bb3j2tgG7VDXoL2ArQ/am
	OAdPCBg+CgE+6Y/zKucyGq7HMpDM/lbTpL1TS1KuBv8KuDpvuH3hyEdoIAIuVifAPWPRShue/1k
	oQkjWI3LZ/yucMgkOBMh4LTvZenivMC3Qdb4xcU0jCOhkp1/M4iqS4TdE20jesBWY1QYqD5p09k
	KjAYJh0K6M0W1GFjgCl1pJbOEQZS4J2Xfnk2hOtnIyn/8mNX212OA+5utNSz7Hb7HqAaepYwfnM
	AGBYwKsV+G2YSQGYTQ9HZ3ju3rCXl
X-Received: by 2002:a05:6000:1863:b0:482:e6b5:61c with SMTP id ffacd0b85a97d-48587098310mr8284636f8f.8.1788523988455;
        Fri, 04 Sep 2026 05:13:08 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883c6ba4sm6681622f8f.25.2026.09.04.05.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:13:08 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b72767277f29b6407083@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] xarray: fix index jumping backwards in xas_find()
Date: Fri,  4 Sep 2026 14:12:59 +0200
Message-ID: <20260904121301.200049-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <app_o87YogZExbwm@kernel.org>
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org> <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org> <app_o87YogZExbwm@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 63wc1amyb87jfoj7krwouxdjnynqr8ii
X-Rspamd-Queue-Id: 37DE44000C
X-HE-Tag: 1788523990-234778
X-HE-Meta: U2FsdGVkX19L72TpiMguKdtxi3q8SP7M6kIiDtJL/gYuQDNFwZWpVO+nChJcCuJ94CNTubZU7uQCvTKdgoZCvLjgAwIqTLlZ5ipxscXdrcDnvchRNonFxlVK5b3VUcyhxvlTA3N0SO6T/pLxJTQEGzzbRZDONJzw0B7JsmwL1EKDrgxM6SDfdKRS7+dSGwDQUGBq+rFTSUWyZl9r/5cvD6BBZNq5Rb3PcldglWX1Ivo+mgJREvOdlQLTZrPrMM+emYoaT7PAd+lTMtbE7liwdzRP3xfNWyD6dQZieH9qupNQWZA2r7mVrD2X8irjdmZZYRSbzYg9Nn8UOfmy9uQqD3f+8F8INEOd/qm4HgYqPWsI/hdu+gSH7HVmSYxcLxNaPYXvnlNuwOFj16CpLKL1o+Rw12TpSARYLGEbOf/1dTg9TLZFAob8aDAsfPgDcXxGEe2nlYEU3uS41pIcg65UTJg2dsQxNPhyEr8oB6cGM2so33Ar1KD+m7YgC6DdNNXqVBb/02ofL9XpO6hQfdStna2ZfYldM9EGatkOKTgErW8SKlMklpmgqzcHHL4hmna5jJq4OpKZUYDf5t+cRGPxukDYkikkzjiCWoLfxJfyJu68zIHxEMVEhk4F9KEvo99mX6lekhN/7unt5lOtLi4SSLO9dK0jBJmr4jxiHhzAb1xOJITiAiXRUzYsLG6ltzehvYnXTwN0ZXWGnrmLGaOWP65+HWEHkLzoSA39lxsB2t+vWGren5uhUxdq3BmNUgz6eCIZzj5xzvgMR2mhIu9aRGS694uImh3uJj6wov9XdnqXxY7xGndZa/Xe5ZlkcFYM5B4OO/Eexwa1zPoMlUbBROQG8KHl19YnWgvaaMiafnGQFnlF4Uk3ymHpgcqfLPe2mHmYKMmf3ZzcA3mrVDX2xUZPz6XKfl4IYZVASFMedstjQOBTw8QnuZT9CFQIc+n7P8Mu3zkX5tAMlxQss6K
 NEjo8EIT
 sqrdM0uHCamSqHRHAKtCrUMI0kjZuMjgF1W2HAp0MFN4b5mv5K2wpdhB6FfJST4vq+1i4xn7Uf2LjD3WnH0ES/MtcjTiWSaMqvb3KejgI4BPf9Cxp5lGPF/Pjb1Lf9WJKVsJH71lyUUzqktneQwB8hJep0RPajvWChKXdAIx3l4oEHjZKi0eSyW/2hwUIAqtCWtadGhD/RlrIY0ywjYfyz02KTQPZN1LxCZhY3vFaVnXTVbsh/34SAIfUcFmDrp8HByVYBArZdcScQBOl80XLEdnf6cAYxGO9rECd0UA+07Wv34fVj+/8PkaotLzrTh2pi1DecyySNriRRy9eyduvkEc/sKkUeE7J0ZFYGT7iIw8nL5jTHoEiMCdDikMuRyR2IMiZWzgOByd+u04Hkl4PbytPr8FXbqELhTbvaPs5ncP7Cx1lLJi39KyjQI3DGfQ8Mqm4eJ2NoLwoVgthEcObosj2z0yxHkAddZi23TPnwk6RxLYxEwGkfSWtTV39s+Utya+dBu5uF2eAT0sdUNv8iq2Rfj6PHXQtnZpYI0TVlrvhfcqgFgGQ99G5+eBtxZ5SyUWyGCfV60clHkdaqJPzOQVODUO7pn3Z4KTS9q16XUT55lOIVkDUyc4hDoO+x7TEtt+x+bspPoJsS5dK8XcxNA8pzGa2liDAbf10OSJxt/O+UXoYxLo4sNKR1zuD82Qf5bhw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bug in the XArray iterator xas_find() causes the iterator's index
(xas->xa_index) to jump backwards when iterating over a multi-index entry
(like a THP) that resides in a non-leaf node and is concurrently split.

When iterating over a multi-index entry in a non-leaf node, xas_load() sets
xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
the requested index. When the caller subsequently wants to advance to the
next entry, xas_find() is called. xas_find() attempts to synchronize
xas->xa_offset with xas->xa_index before advancing. However, the fixup
logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
Because the THP resides in a non-leaf node, the fixup is skipped.

As a result, xas_find() simply increments xas->xa_offset and recalculates
xas->xa_index based on this new offset. This causes xas->xa_index to jump
backwards. If the THP was concurrently split, the entry at the new offset
is a node pointer, so xas_find() descends into it and returns the folio at
the backwards index. The caller (filemap_map_pages()) then calculates the
PTE pointer based on this backwards index, resulting in an invalid memory
access such as an out-of-bounds read or use-after-free on a page-table page
freed via tlb_remove_table_rcu().

A userspace access that faults in a file-backed mapping can trigger this
path. When the index moves backwards, filemap_map_pages() can calculate a
PTE outside the page locked for fault-around and dereference a freed
page-table page, resulting in a KASAN-detected use-after-free read.

To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
xas->xa_node). If it does not and the node is a non-leaf node, set
xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
Also add test cases in test_xarray to verify xas_find() behavior when
iterating over and splitting multi-index entries.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Cc: <stable@vger.kernel.org>
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
Changes in v2:
- Derive the regression-test geometry from XA_CHUNK_SHIFT so it works with
  both the userspace harness (SHIFT=3) and the kernel (SHIFT=6).
- Check the xas_split_alloc() result before calling xas_split().
- Describe the userspace-triggered use-after-free and add the stable Cc.

v1: https://lore.kernel.org/all/2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org/

Tests:
- Applied with git am to linux-mm commit b0266eddcb10 (the base of the
  reported CI run).
- Ubuntu 24.04 x86_64 mm-ci host tests: memblock, VMA, Maple tree, XArray,
  Radix tree and IDA, Multiorder XArray, and IDR all passed.
- Userspace XArray tests with ASan/UBSan passed for SHIFT=3 and SHIFT=6.
- The built-in XArray test suite passed under generic KASAN.

 lib/test_xarray.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |  8 ++++--
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa..615f7730a5bd 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1247,6 +1247,75 @@ static noinline void check_multi_find_3(struct xarray *xa)
 	}
 }
 
+static noinline void check_multi_find_4(struct xarray *xa)
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
+	/* Multi-index entry in two slots of a non-leaf node. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, next);
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Split the multi-index entry after a lookup begins inside it. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
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
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
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
@@ -1370,6 +1439,7 @@ static noinline void check_find(struct xarray *xa)
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
+	check_multi_find_4(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..980324d686bd 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1406,9 +1406,11 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-	} else if (!xas->xa_node->shift &&
-		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
-		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
 	}
 
 	xas_next_offset(xas);

base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.53.0

