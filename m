Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769FFF8A14A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91786B008A; Thu, 16 Apr 2026 05:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D417A6B008C; Thu, 16 Apr 2026 05:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EFC6B0092; Thu, 16 Apr 2026 05:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8EDA6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8308F1A0831
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:37 +0000 (UTC)
X-FDA: 84663848514.15.0F92CB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E98681A0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/9v/hAV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5KS9l6n4I7mmCdXQ2QTl5v6hbhoz3OFSKVaznJfxLo=;
	b=c4oTV2EGyVSIoxc0Tz/MKv921ihNGd6qiFoNwDFxmKVUhBCrN4DP/Mazs3MKouY7geba8K
	BuxHzuy7o0pK8HfDDA8Qw3xZdNckFEYuXFSMgZnyPOxbjR/2zltXJZizDOVgANEtKoLkRe
	ciizBRw4eEKt4x8QUqynQEU+yrNSDgM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/9v/hAV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330635; a=rsa-sha256;
	cv=none;
	b=6zWk9MixwtuIlj782qy5ofEOYNomSJsfpOG9Opg3qXO30CGmHt49ptlbYE9KSl5gw3qW0h
	+fJqTaDm9UG0XP/dOn4qT2OdrTC8vUUucg/CT2Vi5KcH0HBHGYvdtNUWG02vsrjZl6nsqk
	dvVkQnHqliwr+oBtD6/6oVtamSi3zrg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A23060127;
	Thu, 16 Apr 2026 09:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB48C2BCB9;
	Thu, 16 Apr 2026 09:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330634;
	bh=FbfsKh65NpkUNC5s76FTA/U0ULodFRvJ0QEyCbw2wT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/9v/hAVivpxbOOVVZ1g0Qn0EgFbx17lYu2siYtiroVkoHu8cHgHh5fPt4GcUKFjN
	 TioMsCrJ7V4ygW/z0e60zQrBCVXU6ipFREYWCK4A11Zyg1cBAIk9yrNQgy5KU5g9dO
	 0rOKY0R7QUbp7YoawRK43fruKeHvG3ZwQd981T6nPjN3N1lefD4j67n947jawb5+fi
	 YBrhhc8R+qwSWshHs/cBSiDIbNLz9q9UNc26jxP9YzUGHdC0RjfGQy1uLQbqkSyaXN
	 UsWBrN+r1F+FXDRTEWjeiBTPZw4az3F7g+l0uHAOjJbA/bMWg5Q00E7Cc6Hu/sFcaU
	 iud6Xyg1AMP6g==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/8] fs/dcache: use rcu_ptr instead of rcu_head for external names
Date: Thu, 16 Apr 2026 18:10:16 +0900
Message-ID: <20260416091022.36823-3-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E98681A0003
X-Stat-Signature: xpfqpwpwg9qnnyswbjjfbmr5u3chpkgn
X-Rspam-User: 
X-HE-Tag: 1776330635-785144
X-HE-Meta: U2FsdGVkX19UWBa3z3V9dYE//SZz/jFpfU6yAve3/C9nol1trZ45jjtJH3Mvj+B3tIdYGTDPPO9M1tuTL54fjoEyKBy7VrdCvxXTD/g2ounLT6UxSWnkdySIR/NPhEyVIToWOGVap+OV8VXKIBgXoOs9yJJx+9JIprHTk4IPBhPpikLy6ZBHkp2tcfY85+nAjReBQzKL5WhwPmitqilTpfbbsB94s6AHXpe7MUJvBLgrdWsESZLYigUMXopC2EdhtUiC3/ddXdePfJ/IZUEsUnDH5upyPO5hB7aevXozMZhzhi7otuaQw8y76JB38mbZ57txC6nIW5JYUlRvJ8dRDrghoa7mH2ocJmK8XHx3NPRuNA/8zgba1+oV548caRFhWPzqSse9YWVLSf/oJZTYdxadtwhHMCkDJkzZ4KsKC7jasY16pVacvCdX+aMLyxQ1KcttkFUSw0tVdDzQN/KoB121aFRWZgJUKlmgyivZ80RMToSA72Q+Rr8UtH7PnFAwBn1IaBiGVX1VyXVJhj6v4UZWJvGecgxdD7BpNMeJ64lgDjt205uglVPOcsh0oeg960xIYjM0powhqeXIhnyVhr7DLAkyxXWYCyJb6Hgl4y1FXFD0zS26kSAbjnq3NmJeiDZ/oO7Tyizye3FXYok7+tYvvADGimRgHU2OgSNp7F5BtLKJvW95B9XY5fw3d5sO7TIlu2bVsF2yOMCr0bGP6+jDIzjvtKqnPYr/bG162/6ix+VJGoqv5hkScQKu+csXdw4yoye8TuyzDFqu4Djo6CI7As/7MrCevLc6gDJx2cQcxjyTt6splPHIQTg/8jDsZLcHLifh6+TVNBjpKL43KS/nGZ5d4oYxR2bCUKQ/YGR3Jsi9VFdI+FgViW4IEONyMbAKhFh+OFYb5LCveeKdjRNkQB3P54/kPxPceAd7XHtlYyjK9EAB8p9sfc7otqxetqDZ4uu8FOfrI1XUL1q
 JttwLH5G
 wYkHQQcb8wdanQoEXtKN+hu8QgnXjlc9VvmaSTrxxvF0HMvHBIRtyZoUfAAR1bzUSIcwmwAkfQ4iQfCZ8L+jaQx/SGaFRsQs4+Uua1+Urd2bsFx/eQJH86WQO8bHgo0NFX6+z/1+4NrqrxvFsDG6y/nhGAXvJr8TsoxwFngg5xrW92+ZGqkqrZC9DgAOgckz0K5nbm4t40odzV7zBNd6ihFyJLJZ5MzZFI5Wr+8vax/bFmIGttjhAYVKSJ/lCYQve65UWj4HPjlF+iGHlBqfscXg80+2jFvpH4KNpnztIZXCh6u8RBkhCQITKvT7hn9757Drngw0W0mgDKT+zzQGO1Ak4Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a file name length exceeds 31 (DCACHE_INLINE_LEN-1),
struct external_name is dynamically allocated. Because only kfree_rcu()
is used to free the objects, struct rcu_ptr is enough and saves a pointer
per object.

Under the author's home directory, there are 230k unique file names that
are longer than 31. Some memory saving benefit is expected.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 fs/dcache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7ba1801d8132..fa37e3964b38 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -325,12 +325,12 @@ static inline int dentry_cmp(const struct dentry *dentry, const unsigned char *c
 /*
  * long names are allocated separately from dentry and never modified.
  * Refcounted, freeing is RCU-delayed.  See take_dentry_name_snapshot()
- * for the reason why ->count and ->head can't be combined into a union.
+ * for the reason why ->count and ->rcu can't be combined into a union.
  * dentry_string_cmp() relies upon ->name[] being word-aligned.
  */
 struct external_name {
 	atomic_t count;
-	struct rcu_head head;
+	struct rcu_ptr rcu;
 	unsigned char name[] __aligned(sizeof(unsigned long));
 };
 
@@ -393,7 +393,7 @@ void release_dentry_name_snapshot(struct name_snapshot *name)
 		struct external_name *p;
 		p = container_of(name->name.name, struct external_name, name[0]);
 		if (unlikely(atomic_dec_and_test(&p->count)))
-			kfree_rcu(p, head);
+			kfree_rcu(p, rcu);
 	}
 }
 EXPORT_SYMBOL(release_dentry_name_snapshot);
@@ -2863,7 +2863,7 @@ static void copy_name(struct dentry *dentry, struct dentry *target)
 		dentry->__d_name.hash_len = target->__d_name.hash_len;
 	}
 	if (old_name && likely(atomic_dec_and_test(&old_name->count)))
-		kfree_rcu(old_name, head);
+		kfree_rcu(old_name, rcu);
 }
 
 /*
-- 
2.43.0


