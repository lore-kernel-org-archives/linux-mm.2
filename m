Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAAD60A261F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vCxSjBFm
Received: by kanga.kvack.org (Postfix)
	id 964676B05C6; Sat, 14 Nov 2026 09:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9144E6B05C7; Sat, 14 Nov 2026 09:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8047A6B05C8; Sat, 14 Nov 2026 09:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603806B05C6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:52:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB71A8041C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:17 +0000 (UTC)
X-FDA: 85434015114.07.9354FB6
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2130EC0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vCxSjBFm;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667936;
	b=MTw7h6gxFwQsrFuEIZE7SDIRSiYDqVs/IvwXWSVFguWy/YCRM0J3WYDTTpgBtbFMCJKaJ4
	f03aXOJZNPf+RBVcjxun93/hf4NaCw3dgyiIZJ5JfP1F3WRzSRfe5RqSFpEGocy6LeUxPW
	YwCieIy+4TPil1/n6hTwECJWDvfgoiE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vCxSjBFm;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
	b=o+amqq2QGg9wtMnjBFFG6lIRGbAKpDe73scvt1hC1SWjBH5JnRmLHnQgpmhcWzWtownZED
	q8Lcaa5jUunlZNE/5M1FzqM5O5VORrY3APLkukixsF4M73YpS0hV+/CgxtJozOB3E90weq
	zc/ech3gO/lZDxKsOLrCmI/SaG+W1DE=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdddc79a4afso463254a12.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667935; x=1795272735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
        b=vCxSjBFmbFpnOPseQUk8GJuqlOk98sX+o66VUknkHznKHm06ZTiky9UGYll7sbZntv
         wzEk12jfBeoU6+4WbY/JCSD0OdODl54r84As8mYGOVG3+g2G2fwaQsK4zaF4MjeKuOfK
         6biBBPIeqyBb5YnvO8Ypxqww5YCxqHL+HLwURVlItUbbsUB6q1ppmiA68bsc7Eazh+4p
         D7SXyb6AgL+cgmqVTVzNXv4uAy0C5VpieWz5xOzKizetpPUeQslj7v4PcUWpZLxx6F9k
         C01BBL7q2B/8GvAr6WSGcRb2br/5G2So9dV4wQanXeRb5smQGSe4fwHT6BGfd2Csbi6S
         2tSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667935; x=1795272735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
        b=Uh4Te4ym9Gb5XTx0/xIzIK3DLFt+y37WQYlKptaDanpbP6bfG2VbLUyP0T3h92UO5n
         lyIDrDo+nTeOH0GOsh3uN77mek7jRKGIexyQVsX/tPC9wRIHIoC6/PVN/BxZfDGaqHKC
         /jw7ksjm+L1/39PMtH3dsjSv6vXHco3NZ4I0Nx3M7q7y1E1TV+lEQWWYbiCA4chVNt5X
         8afSJft/pTJwiNwPYWlh8iadfJDymCwOb9mv+Ww9GJx7dWABJjeT05lftyPBttNqZKde
         j3FbOZ+UTlbKF6CjcLY5Oir2m8/MdC8NqVMRVDnkVqE425Jy99qI1Veh14E2GhulGSym
         lDFQ==
X-Gm-Message-State: APuU4Z/p1eC1jKXIvKq4C9LNv3i8t6y+pcoErgixuP7VdsGGbde7ey6a
	CQIlBo8WGoOlWBr8wetx09BrMGSF9JwvBbzQYU5LSUggt7na3SWRwMSrtZCcdA==
X-Gm-Gg: AYBFou3Tsv5JTnwAG4rnaBA9zzD9zxWGU/a9YRe4pH9E+Jq3eAy+DdN1E5F5tX2L1VC
	kO8mnS5B1pEsb7xH2BcLjeIma42fMGNbIh5nERNHnOkwTTTgwi3r2Fl3N6UFIeWRUdvJrBhNn9v
	c9+N1qCPoWFrg4gk9y+MhBN9qach16djb3NNRjxh/E1ZqLm+4Ucv7kcuMenv+7WyBXMRkdIo9al
	j/rx7s3elb5TnTm4sSEzJmNmXQ2GqyfkE4P357Pkf48JfjRvVQHK9lo+lkN5mPdr1sn+/hR/9zi
	rbpt2kzfFH3hRnbCVK/vkUWy4fLXJmjINFQGLDhiGAaENIbKMzDiuMz/fsBNF9t1DwB3oEmI81M
	Yx/bQ+WIWaeyQwEdK+CgDqU4LaRKYw3i6+cv5boGBogVg712vEtlJ4yAlqiEic8fHVQSAdgn8o7
	FgtNpT1LrDFZbqPG3akmkvfouc+b4vYKTJZNKBmy66BTkW2GM8URrIkX8pAonKRTTs8XXKQ1Qox
	p67LmdZd52p93FkHX2GDQInk3rFuOCTNuiMy3ZryP4C2glfmLm82o+RGvBwTbPvsa++tIHyc3yf
	7xvb/xcpNAdGnDGbdSDgOTWKR41tUN+h7rQgIXd0HblADkxDAB3KLiQsmatubTM0SQ2T
X-Received: by 2002:a17:902:f70b:b0:2ed:537d:f00 with SMTP id d9443c01a7336-2ee0dc95988mr49994515ad.56.1794667934899;
        Sat, 14 Nov 2026 06:52:14 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f224370sm21342815ad.0.2026.11.14.06.52.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:52:14 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 14/18] lib/plist.c: remove requeue function
Date: Sat, 14 Nov 2026 22:51:58 +0800
Message-ID: <f513864653d62e4ce8095af9fc1275081d1d1c81.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dztd48eskdnf4rdgquwpqrhdfje3ys4a
X-Rspamd-Queue-Id: 2130EC0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794667935-119079
X-HE-Meta: U2FsdGVkX18CHy7SGN40HJu05uQP7PdPLYYz0bbkG8N6650QmDw5ZD6DADQkxoKFuQX0L8FkHhuOqH3wvMMACT7Q7WGSG4yCmpF6/9XBOAzoQg/1bQQeZ9uAsUpLWwiV2mDzEzKnp2bp76vDvP74huWMopqvhKrpTDEI7eQysDY1XEj/VpNoIFKqlJaek+Q5uI/7d9jKZ0obHihktTxOcBw3a7reWqbD65yDKJEXQvuPTIumA+bMdh6MDSCdzsDSkOZeZL1myduaOgn1XAoRw2G963MYTd4iSLjPweLRJ5Ka7f8no/IWlCdvQjqshL+8ak09BZZalzYwFq1GLus2+UvH9FmSIsTSn8N0ackSq8DJu+qj5+kj96gnlcryJ1oRM7GeYx6NhzoZu1EwMDLU9d+SqFzlgA+p13fim49l6Pm3eYSP9x12LmeSVBcIz7p6d1ZoIPCUWKugKF1kinwDqj4iJkStxyxSQehK2SUWyylDIGSF/pz2O8hPxn/LgMHhwNbt/9CPi9CbdsPXdu8oFzaOk8/QY4zkQ1Q+knxFbhgvS5AzedurcpjEbKXu77sEWSqzbBHfwRtbndQIPMKUouP31SWk04qLHawCGrKnlZCbOipvrkA6owkv+xasPbbkWtwutoV47Zgax7HSw3sBMVaY7XNtuDNlpi3NDSfWU5uqSJYP7adR8NOkMl4XuTZv4Tssry+Jf2JaA8qzvG3BYU/9HMSwsD+37asDWioaZzCJHxPlfPKfuTW4rRMlcTdJj9CN+wfoWMh8qfVKo0y2SpAXfdI4PHxGhL9IMXRQt4YTOYKkLPH7G3cYrfh494cp346NlDUaCyXUSqBmCQFwRGaZA6jFNhNukj/SqRjdiWChBivpCWOoS2ecGy694mdAPyRJL+5S3LyKP3JVcu0uAG9+swMQIlAfDcAWuUDx6+JW2OPaBwjNnX1U01EY9IPS7Q/9KxLkXGdD82mZ8JC
 7udaXMbj
 6oJSxc+XyDAMmFRzFPYveEpQtrMEr71hlAQ9hJ0nrvwlAKeb53MZtoJKurjfEfx0rw6QvROCp4pRZ+bUDLs0GlNQyTLfl3prh+o2hwEMDmHHqXyF8PBlQ/z2+m1KhD0a42yfem+WZPKj/fnmAh6xvqalh1GE4YLkNNyT1kJZ6Qhxk9TMW/ASYE6tORQV5UeQFkFrbgI5OurPF/CC/zEAA/HAE9vaLzUafq1KJRR2ikM8MPLYfhWPC8Oc6h6xDkTzrpxLH5JKhs+JyglUpdaRoGXCL+3aX1tUv4WdEaGEDpVkLjD/I4kSoxqnifZQblUMURk2Nf/5pi5Q9GP7/uKINe/NHfdfB5jmwxTDUa38a+ZdMiNS3hSWIbsm9Zeua2XixrMVN4vmrRaKj9rvi5YQSlrtZRNqBi1y0VzWZWcyz/lmJVUVC7uiagQYCig4ezhRJ1pLhK2cmsg/VbTNZIjyfCEzrdoz5jcITrZ6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Now the last user of plist requeue is gone, this function can be
removed.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/plist.h |  2 --
 lib/plist.c           | 71 -------------------------------------------
 2 files changed, 73 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 16cf4355b5c1..73d359c1a053 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -132,8 +132,6 @@ static inline void plist_node_init(struct plist_node *node, int prio)
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
-extern void plist_requeue(struct plist_node *node, struct plist_head *head);
-
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff --git a/lib/plist.c b/lib/plist.c
index b0273533c04d..b05ae7ffea87 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -142,65 +142,6 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-/**
- * plist_requeue - Requeue @node at end of same-prio entries.
- *
- * This is essentially an optimized plist_del() followed by
- * plist_add().  It moves an entry already in the plist to
- * after any other same-priority entries.
- *
- * @node:	&struct plist_node pointer - entry to be moved
- * @head:	&struct plist_head pointer - list head
- */
-void plist_requeue(struct plist_node *node, struct plist_head *head)
-{
-	struct plist_node *iter;
-	struct list_head *node_next = &head->node_list;
-
-	plist_check_head(head);
-	BUG_ON(plist_head_empty(head));
-	BUG_ON(plist_node_empty(node));
-
-	if (node == plist_last(head))
-		return;
-
-	iter = plist_next(node);
-
-	if (node->prio != iter->prio)
-		return;
-
-	plist_del(node, head);
-
-	/*
-	 * After plist_del(), iter is the replacement of the node.  If the node
-	 * was on prio_list, take shortcut to find node_next instead of looping.
-	 *
-	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
-	 * round to the first one; in that case node_next is the list head.
-	 */
-	if (!list_empty(&iter->prio_list)) {
-		struct plist_node *first = plist_first(head);
-
-		if (iter->prio_list.next == &first->prio_list)
-			goto queue;
-		iter = list_entry(iter->prio_list.next, struct plist_node,
-				  prio_list);
-		node_next = &iter->node_list;
-		goto queue;
-	}
-
-	plist_for_each_continue(iter, head) {
-		if (node->prio != iter->prio) {
-			node_next = &iter->node_list;
-			break;
-		}
-	}
-queue:
-	list_add_tail(&node->node_list, node_next);
-
-	plist_check_head(head);
-}
-
 #ifdef CONFIG_DEBUG_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -238,14 +179,6 @@ static void __init plist_test_check(int nr_expect)
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
-static void __init plist_test_requeue(struct plist_node *node)
-{
-	plist_requeue(node, &test_head);
-
-	if (node != plist_last(&test_head))
-		BUG_ON(node->prio == plist_next(node)->prio);
-}
-
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -269,10 +202,6 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
-		if (!plist_node_empty(test_node + i)) {
-			plist_test_requeue(test_node + i);
-			plist_test_check(nr_expect);
-		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {

