Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10EBE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 21:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Df9onYlZ
Received: by kanga.kvack.org (Postfix)
	id 2650B6B0867; Tue, 24 Nov 2026 16:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2168C6B0869; Tue, 24 Nov 2026 16:34:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BBF6B086A; Tue, 24 Nov 2026 16:34:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD4496B0867
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:34:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 651031A0C80
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:34:14 +0000 (UTC)
X-FDA: 85471316028.29.52A5416
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F232100002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:34:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Df9onYlZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795556052;
	b=gt0tcvt/j+B3ZAUnmAFlLkXB63+nbWpy5eim1oHVA2vXtNi+iK6ELB4Yyk0IjKyS1FyVM1
	9a/fdTBGm6JSj88jt34ad7nqdbPjRDLvliAQha2Cv+25i+lwOoKwDckWQylfIBnM+wl9uW
	ByVZwZZkLgVlGcDS+Onv6M9PohWgp2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795556052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
	b=hAURHyOqCTN832i1rRvDrZcNl3I0hVLlbOda/2zflt0WRz4YYGUChEQz6mfh6YxlxEg7VO
	UgHtuMm0Kf0m99ckDsHKDZNqoOVQIHpcice6lCglf+Mx0DqQVOeZk3FA4yxVK+zK+s+4PB
	0aRxsMptdI0EtuApKWlf9fMknPIFhLM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Df9onYlZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a2761c69fbso5515753c88.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795556051; x=1796160851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
        b=Df9onYlZibFIg0TsByhJoz09Cay5kTuNNdIGTSlveB0wHSN/yK1peeZU318SFXTBOA
         tX9pp+DiYJlwBYUYpVOuOCKscF0F+FtC+OCEMhacd1s/5UXCb5r1Vm3p35GLZtNcj+Q9
         qsdNzm7v9g8bI4HvHjhuoXTYcN7LDfx8iYabt85EclISJNh+fr3eCYsWqvg9bJmGTcYr
         xxeymv0SphnAm7RYjlEQCUg0YZcB5iRXqK/SuICOlLYXufjM9yexA1JYrs61JIDRd5WQ
         CyoMrsB6afeLcq+7SOohk72A2o/QoDaJhp0j9dABzdhTWWxKylau5F9ttZ+imh3f/3Uo
         8pEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795556051; x=1796160851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
        b=isvzGPm+ObqgmmpEC9ixcYMRxVPMAjG3KMnB7+gG0qTzIlosDSunAY8PzoggVYNsNd
         q5IaYnqJIPE0BZ4bVKib9Kqh4IOjjVZ3PgbFY1GePU9Jc56fpyD5Z2GjsIBGqIJBL9Fs
         7Vltt47V/LOUsWpULrNbVhQvv+W4rjb62UHkvQ0R/9EllPj3w6mMORRSA4SWcHpmA/Yh
         l1DVFRkaoPEqfzkjx0saqr0I2UQ/5D7ECYtJdG7GL8EKZ7BQUjqzuoMhZ/KoN2Kd1Mfn
         d7h0yes7v7Auuv4ZXBsbT4SvrUK0pQHzehn1qFZlioFQAsxts8JyujZZSc59jwXfoTDW
         X1aw==
X-Forwarded-Encrypted: i=1; AL+hErE3VIWOs58GbKIkO6DfiQxW1cGlISFbqQLyaBcSkkWOoGHmsix1ygDaB2vkIJ8biCj1WCsvp5wzTQ==@kvack.org
X-Gm-Message-State: APuU4Z/teNo2BPR/YbkCCzbVO27QHIK//dgeZcSlJd/RjWqSvBtxxjDn
	0nDm2J642nLaJcRbHGWqM6kWe6uDyyilBrWcshMxi5Smeed0xL1I8DBu
X-Gm-Gg: AZFdTZfSNoru7p7G0Gh1JjBXU8VZ7Laf9EgS+ta8GphViQvXBOULbXy+9EqTa8MsLQJ
	VmreWyiJfNp6oyZFtWJ5/YdzO7J64lsPMi01aUr9I5o+SQ8dWkIGKvGS6itdQ9wtb5lHWkr47i1
	BE/RDFDMTJbL2FRH+SnM3AARQs7lVww3F4ecOdLxPPbtuRB2Bc5QwPrAGjzXvCNIf2DCVnKEGzD
	Aqa5LdKiwjWXItR+8ZnL5SxtIf5K4m4aI8lWjI86PkaC1fRFlaZcEyQW/5ndSWM7DYJ6NUmn3nA
	p07LAHlAtZB43BW32chICNRdA2hW6VuDkIa1M4+XdVnJ6jpuPFJMhY0hFCl171a8/GgHUHCuvOa
	BTHUMKf8g9DtoAjtHlwgLsdy6sXjxDsJFmF1joK8sdPwe49rQreEFMjc52lHT9heeUi8f5YNLLV
	XyLrUTjwE+rn6a00xEUm2n/4CT87jVKUj4e6k8uRmjIZK5c2j5M/gswQ1quy//AfVaPucvvtgAw
	JFppzbaBfeSu6BwCWkbQy/vzRb3aViJd3ThetA69WML+8x85S0aArZqaRVoeI5Z60zFxOqqTsZi
	rcB4YgjNbuBZwCAYGywA+KWO7IKyU8YQ/YbA249gSM0/74iGELYfDQ4HtjSXy29fUdV4HlwulQT
	Mkm0NwKKeLVc=
X-Received: by 2002:a05:7022:b0c8:b0:1b2:6855:998a with SMTP id a92af1059eb24-1b556911007mr14191850c88.34.1795556051100;
        Tue, 24 Nov 2026 13:34:11 -0800 (PST)
Received: from dev-oss-0.tail8d7c7c.ts.net (c-73-70-201-200.hsd1.ca.comcast.net. [73.70.201.200])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm43704981c88.7.2026.11.24.13.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 13:34:10 -0800 (PST)
From: Qian Xiao <heyheyco@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Qian Xiao <heyheyco@gmail.com>
Subject: [PATCH] xarray: fix index jumping backwards in xas_find_marked()
Date: Tue, 24 Nov 2026 13:34:09 -0800
Message-ID: <20261124213409.2224472-1-heyheyco@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: mby759bmgkikhd6o6r7bbiemexi4zocr
X-Rspamd-Queue-Id: 9F232100002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795556052-798747
X-HE-Meta: U2FsdGVkX18pWPeSdl/nxZ0/XRAmMbxNCzaUiD4QYRNTMzy4HSxFJUJmp+/Uz3hNFX7w+n44gZ5mOZb+jndNZzQTtSYTccBtnFJtXtAosmLP/+8eHvgVM5hmOeMLA6QG8ocCUc7OMjh0SKQ+s5RbN64pzVk/3R+5EyQiXcLQyj20ajs9b8/j2TR9tMr2fv/PL5Mfkfi5b9mlfYK5ZJdO64kjAw58s8xX4kKEvtIDmz9k0RbJ5fQYMouE7H/7hIR/fdIaMl9dR+ziZvLU+0VuU7ekKsUTN6FtfnznqLjc7nzvEtsR0sdVsGe2x8yO4PvSzbP1NMR+9glZil4+b24FsOEsVKE65wjVFXTQwVLoI2/PzLm4wJlf9Sy2o3IhSINae2sG7k3Qtp2bLJkompaD1Brtg3IXHW/90srhc6Vq9qvYGiFeIdJI4yFdVNQZzcVdQ7We2pUbqnZavpbkEyAkNFga5kl8G3UN/Z+xeTDvWld6Pml9H284IJsHO8ngqtQyBrY0dY/XYhPwGLoiviCvhPjaj9CrLVopxRdqTkYyAdDMIyYA1RPW8aPzgiQKfyah6s3hlar8neR56lrgkd1KJVnjIG1fLDViUljTRcV3rUWlLVB4YZiW5pYSUWBNEscL0otB2qh4sbKMgXAPKNRigqfW7b+5RbSarZ8ysVrZoAPdZ0C69To+ABnseWZZxh6Q9QfVmZaga0Vfw8QiUvTJJqHvE13uSLQ1K+FAxRUmtGyN2HMTyO7wXpgKwxIx4a1jkGB6Mf3d58Meqm9GkcnEGnv3El4wjPpmNiU2k7ioZ7Zg44WNHOVpyybYyPuJ6PQb7SiI3LMbNgApVnxHgxebHI7XJO/iKB9bf6BL3z03MGpWbZXNJhy+1TSf+ivFVgjd1xGzUHr6nEtJli9IlCrPCdJr166sBkFIcqt0ungn40wdllGqxSpUKIGM31UJH2ihD7GcTt99vLtZ6s9cZx8
 pHpiXDU2
 +IfZfkPDRp9KU4UgUTZUo9pmBy3lK0Qgfi1tK36DesXlE/D2RvK+OsNt/RvcGQr3GueKoJh7us25b+6IE884NfV9rtD/Jc9TOcfhSzMqnaFJHKYqg070TAQYtaJCORlJL4Yozb7qcUoM07q7b46VJTiwsW4MbxkVxhucq3UNF08lJSq+HFQlv3KCPjV6Un8cVeco93cW5Y7J/NEjbTCknF8pd7psbVqNo+NW1IdSfPZHLRq4PKmAPdLKNcfaLwFvKVKShnoKD+nxIHayJHXkDMJhoHFrZsjlJkkC9rHopOPeK7h1DNMLsI9j8o7rH+ek0z8O719pqapeYyzzKee1OIPUE5qEcyDY3sS/PuRGDLnDtk2i/1flsNrXK7mEgJM2uVqGdOonYbzGAqD6gqcIXr4cobn2n/bUHXGaSW5AZBEd4nU0srUVrrSQUtBtdeV7pffXsLKULclcKnFbTY0xkt3cnfriLjH9eNbSMu42P/92LpHRJYvK48jo+u5O5MCte1tzCzt1nHahkPqTIc8AajD4qyiBfc0G7yTRXYpVnec0vmOKPzKJkHiAiVKv2s2fILqviGbyNEKW8Kn99domdmhGbrqoFPXZCUxlWj/VH59H1yXMxNQ+vMQIpxgtka1wUlyafzlIPT/Fs/x3auZDB4WrCRQkGfe7unNccKp3/jBE0r+5+zSc1vvl3MuCCG1gn4JFK
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
xas_find() does. Keep skipping sibling entries at the return site.

The userspace XArray test suite passed. The kernel was not built.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qian Xiao <heyheyco@gmail.com>
---
 lib/test_xarray.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |  12 ++++--
 2 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 615f7730a5bd..ddc392d42d29 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1316,6 +1316,109 @@ static noinline void check_multi_find_4(struct xarray *xa)
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
+out:
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1440,6 +1543,7 @@ static noinline void check_find(struct xarray *xa)
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
 	check_multi_find_4(xa);
+	check_multi_find_marked_nonleaf(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 48f440d114e1..4d943791a7b4 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1495,6 +1495,14 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
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
@@ -1507,10 +1515,8 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 
 		if (!advance) {
 			entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
-			if (xa_is_sibling(entry)) {
+			if (xa_is_sibling(entry))
 				xas->xa_offset = xa_to_sibling(entry);
-				xas_move_index(xas, xas->xa_offset);
-			}
 		}
 
 		offset = xas_find_chunk(xas, advance, mark);
-- 
2.53.0


