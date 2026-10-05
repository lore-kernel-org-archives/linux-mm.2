Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A505CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E481A6B008C; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1906B0093; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE756B008C; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 897B86B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1636AA01FA
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:48:06 +0000 (UTC)
X-FDA: 85288550172.01.1A488FC
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2FB2A000E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:48:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=Qk3H8B7y;
	spf=pass (imf25.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791204484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1LzhEkvulvfv08c4ES348Zk38ai3A9e9wWaPaOVj18=;
	b=ONUR6/hAVJ+2umUsGY46O1vMnixI6ju++8ksEvpqO4cGkV5rI/Q6RxzTV6/iD+xbMn/ZVG
	aWnwW+o7S0fvAQW+ImuKvJTqAQJVOeMllGEbJQ3A6cYS8t0g7K5Ws17yZCnQiBCWi9tMTX
	aWUyTALfAP6BHz8zc8rj7Tkg1BMGhDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791204484;
	b=62XY8GONwwWKPAm2rLb7VoNRAJNopIWNcQKdbf95cBJnZPfKBI0ibn9GsoinHrdRHoIni+
	aY5YVERDzcC4UGyO32Y4eNF9Gf54x1GxmvN6mjJL6eaVks+LL9bzNWzl5QiqJruY0SPnwT
	+X82YikDbEoNwdsaU5hSh31V8OnvDYo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=Qk3H8B7y;
	spf=pass (imf25.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1791204480;
	bh=Ar0z0+alqyvvWJZL6lxOGlhOZBgSDcNzH0BkqwPUC4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Qk3H8B7y2LHxrqbe41B/4T2Gm25AnI8Qhiv3olkEVMSls9BDv6OBmMYB89DBfhGeY
	 ewea/7CBB2kgYcsGsjz7ako9NGE0IaibJyTVEC7WbV3OIpXClHRkGP100rymvwyHOn
	 KmmF+/Uw69EAVhwmiL+eZNhUMx4bss7O0kw0SLYs=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 12922120B35;
	Mon,  5 Oct 2026 15:48:00 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Mon, 05 Oct 2026 12:47:28 +0000
Subject: [PATCH v3 2/2] test_maple_tree: test maple_range_64 node in RCU
 mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-fix-maple-tree-range64-rcu-v3-2-ebe7fb278e20@cslab.ece.ntua.gr>
References: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
In-Reply-To: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2FB2A000E
X-Rspam-User: 
X-Stat-Signature: yporjqbs3zktyozyzkxzg5ihb447irri
X-HE-Tag: 1791204483-799371
X-HE-Meta: U2FsdGVkX1+iaWuqtkr909o5TewncMVdDCSJZj014sqVor6vH7R5/Obd6xFGv/YYzlg43LSIRZwb3XJiyLV6PuEvFnMvDst7/AwpvdO3ScvYdP/sygiaLEKFueJi/mLdf9zlNPdiGIBxosC08zqkiCORFectOeszAmpFpaqLkFLpegv4D+tMcK0QWidQYP9Plyl3MtiVOlRzVU12uh8vvbzJ5OKD2TzGfJOBPwL9Mc5k3M8avxS++JHjzOQWkTLN/0XT3zqQL/754fUbPZujRth/lAaaUL/RdyehmI4wl3Y0h42WBSCGYX38+ZE7/at75UPM5y1t+3rpQo3+/rZgznTRF7NiIt9ebWyh3Rtyp4n76nnClMoT9a0xP89lC+CKGmq9xTHpUTCPYRpeDJRSlkzxoMHjYECDBJ4uth99zrPw59OETJ15ELkazdZ64B+AVikwCjmTSBUTOqujKusp4mo7z4tod7HZi4Wp2j11P07Q1xIyMzoa+uGycT6fuUc1u5dc+YYhD9vF6Hb8KR/DmP4ugOw19A7jq2nvdCjaA56YuRXxOxpygOOhoXbuHqcORlatgtfQ7u5FUtZYFckCmtyR3+J4mDAiQ8mLl7338MDWCBLQa/a1i3ermkqf96jtpXxrFf/KuNgg1dlRVUiEwpEv49cHcG0IVF/qoQrotZgYBh1gZJ9Znpkvc+erfjF9vGHsHvAZ5DfG6m6lnkk2iteDriCIedD2IKfQPeUlyQj6WqWAvgO7K04bj6dicvOj3JlyH2acWo+ZFnJsrQfB7KLCMLPlVYInIX8XRNdjkD62eKiSJ1m2t9P7H8gMs7mzBnXT28PRw6sFm+7BBAi9pBU1Is6gR9tnWWJMpDF9oGJls3Ei238W36kAabFVvpIzR5TMIrKKJ0VPvo+fwQFBYBkM1C6+cWYWvVZMDTdgipbiattKyDN012hlUpAF2pwzqFiAel6lO2QYo0pl6H4
 LKWRydik
 xFMCH39wlVLu3hQhmQ3cAErbqbJBTZW8zSqNO0yC5401UfXewxOz7K1gtx8FljtNQ459+NoKu2W2ZB7sI1ab6YO2qYm/wBHZVp/7iNuT8iM8b08dn5G8rJ8PPmX81NjK4VEEnUWmsXGx6byjJgBMq9qgPg0M019hyJDHZ+he4cnb+0jZiL3hUCXexZRd+lCVq/QWuD8g9f+KJvfwR084KUet0JHOgKhpehf8zGGycKYwPcEYcmEElCelm6r5abGbPwL5nXSq3DLQTzNtIGZ0iBVUuSz450znMVM1zO4H4uxwiQj1FytqZBiPAOLbu/MUeeh0sRr/19H8rV5YjrT4kJ43qKA4CmlF0lObpvse+YsLxOQplQrtqj5kP5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a test that builds two maple_range_64 trees in RCU
mode.  The first tree has a root that is a full maple_range_64 node and
ensures that the destruction under RCU does not misinterpret the last
slot as metadata. 226 insertions produce such a root on a 64-bit build.

The second tree is a height 3 tree whose root holds 15 child pointers
and metadata in its last slot, so every slot is non-zero and ensures
that the destruction under RCU does not descend into the metadata slot.
3166 insertions produce such a tree on a 64-bit build.

Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index b9367c61e8b50d107ab972fc5222fb6a531fad87..fb40e193a3cb76f0eb02af3aa4a38630692a4a9b 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3710,6 +3710,36 @@ static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
 	MT_BUG_ON(mt, ret != 1);
 }
 
+static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
+{
+	unsigned long i;
+	unsigned long nr_entries = 226; /* Build a full maple_range_64 root node */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	nr_entries = 3166; /* Height 3. Root has 15 children + metadata */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -3999,6 +4029,8 @@ static int __init maple_tree_seed(void)
 	alloc_cyclic_testing(&tree);
 	mtree_destroy(&tree);
 
+	check_range64_in_rcu(&tree);
+
 
 #if defined(BENCH)
 skip:

-- 
2.47.3


