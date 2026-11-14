Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265EF606A8B8
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RuqtfxfB
Received: by kanga.kvack.org (Postfix)
	id 4A9276B05C8; Sat, 14 Nov 2026 09:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459E96B05C9; Sat, 14 Nov 2026 09:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348CB6B05CA; Sat, 14 Nov 2026 09:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 025BE6B05C8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:52:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 859988041E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:30 +0000 (UTC)
X-FDA: 85434015660.19.7CBC29A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEF1640005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RuqtfxfB;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTRaNJjnhz2jjoFCzuWRnC9Bci53/lYdl7KWMCnuH+8=;
	b=dAhCsiWuBRUiBZ69oMR+9bQZ0v5pGP5LdDF9fc/wdw6QmAb10SDJ1kMCA7BhwgkJ5bTYjt
	EnizJp56pF/J3xa8E4MKvnEhCjMweOQltIGX/gII6BuuunIaxPwcnkbEwXTYC+EVtaTsVx
	gtq34T5kqSz8PPwYaw3yrypaT58ai7M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RuqtfxfB;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667948;
	b=5C321vJlv7FiH1ZFro3krjxuws+f8/8nqej0pyFoPkgJvaM1nYbVBIjgshqyHZNEm2XMot
	Zp9Gstw9NkE1KTpFJhK82xwIr1ypmDh5jSZOfMYm2VPzs5TuRySnIFU8z3kWmJDXO1T2pS
	5+dvQSPQjr0Selr83d5SZCmo2v7sR9I=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso1320287a91.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667947; x=1795272747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oTRaNJjnhz2jjoFCzuWRnC9Bci53/lYdl7KWMCnuH+8=;
        b=RuqtfxfB3cdUlxVyqMV7BsxUa9cQr7hqElyFfsfYG3aJYV4Pk0kQmzuJ4tGQx8ztxI
         xbsacbJjSi6V8Gc7q4sv1apn24ZjV51GtT4WofBFigzw1xpkkzRnuIZ7gTEXFSsAWG5z
         d3wmubuFDkVVjYe5TAsC7rUdqcCTVR16YNJucKi/XH6+GcS2LXfAc1s0q8ndiAaaXqht
         oLjM95WlmS2gDrCz4RMY/XmFfnyOYh0mqkVUWkVBJZ/Tab+kTeumuBnwAXuKZp4nVyn/
         8yUlp0Ym2B/G7j5e7QYwoM6sLzEeb3yXpvUNNNfzk3wIKLLDD79clhE2icA++sTK+zmk
         Jo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667947; x=1795272747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oTRaNJjnhz2jjoFCzuWRnC9Bci53/lYdl7KWMCnuH+8=;
        b=Y3OcHBif8BZvyDOshg82d7QwZaxdujQt7XzQGppZeaQGsm1PL2X2A8WGWsp2hYXZO2
         VAayMo59D2KnGQLu1H8zyWMip7oyGufv0bUd6cWO15zTvoYwZyQsRsKLTkTtHy0WqUwX
         +/AW7TMrs5st3EBKJKq8gdkKxiQx6cK64zLfhiLyINuxklfVgZQ598dOzR5Fz59pD85y
         njKp8pcRcQd6Aa48tXlRvcnnvRqNvwPmgVVGUBigDfc3io7MoHtGBorDejVJgqVzqPyi
         KJNPkTd3n4mZZh4X5mxzUyBfmQHrMVEfBK3bA7yFUsfYzqaMY+rTNwMnUC6H5G55IWPa
         5j/w==
X-Gm-Message-State: APuU4Z9pL4oKBk/aG0YU2rHtlDaWZ2z0ZmqtJ9j31Z9Ih4B63pzytowG
	H6NPOXJaId4mtZm9TJOePwstml7tPnHmJ9DYaS6OxsMYGw0bQUfAm5Sj8ev63Q==
X-Gm-Gg: AYBFou1caKX9nuireCD8mt5zw2tPOQFT5GpnUcVOli3itS0jYyf9/ZPghe2A8vCeWTK
	uvAPwKhHrY1WjGXs5ygiMD6gJ9gboEBfmLsDIEAmPHNC5o+hwbsQtYExwQQ9rH+Skl8VCxZL2wK
	7amj5PWDWD/49D7Kaej5dfiB+B76Tr/a/DS5uftHWFZQiC4lCZoRqRLO7iiSlbw6LCDSn7XIIia
	5QvUcD6Vl9f7bjovuHJ0d9oRaj/CKXZA8gZmM4rl5DOFu7LsNjEFMnKpDhRF9/YeysU6Ok3gU72
	2n/82dqJHZbRzx7YBwvQZIHmcY11HKcbZAw927i/QxRhLUbL3TM5ZWDBmVhzFIsNzDQ6vCLsUIh
	xgxf/OP9ZHgcgci5y8Y7l8m1/8j3PKp6EkNFtiqx6buXi1ZN2Sb5C86Ue7CNyeTltgQXK08s/uG
	Cpjs73QdLr5T6Z2lfjN4usNGFFuP3Sz3pu5cTFHx6a4OWGvv4yMFyKX5VsD4ls98Iv8xW6XVcDd
	RaZ+qcUzAFUxAIyeg4JjrV49fcRQIeZKIhcsTfTRH9rzsjpnyUNa2ELOlXeqrQegefT8pWUdJfu
	TCRbr9jj+migPsq2AM1TLdrouBJ7OiRq7JijmTnT39yQZ5wz5TUD6dJzQtb2Kd9RPaQj
X-Received: by 2002:a17:90a:c88b:b0:3ac:8741:e2e4 with SMTP id 98e67ed59e1d1-3b1b0a4e341mr5623665a91.52.1794667947352;
        Sat, 14 Nov 2026 06:52:27 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3f09b92sm4082810a91.4.2026.11.14.06.52.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:52:27 -0800 (PST)
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
Subject: [RFC PATCH v4 15/18] mm/swap: reuse per-CPU queue readers across priority changes
Date: Sat, 14 Nov 2026 22:52:15 +0800
Message-ID: <c7ee52cc6aa423b40c67d4c24dcb9d30b7e07824.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5cz81odxrfjgwktub5khbpayjshrrjm8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AEF1640005
X-HE-Tag: 1794667948-608058
X-HE-Meta: U2FsdGVkX19LgO4EUQdv1ieuCaNBv//ZYfcjvmwENlkplfpmMEUs5vx/tOlrk6whFUFytH3kHZh6OfloszWE/HfBA/IoI/vMtZ4ttwHWcc4oOQvresGUppuehqOz71X2IfJwCiS36qvRJGOBz3IjBGwD3VP60o9XB2ykEVzgMV9Cw/xHbId242kS+TliW1gzuElUjJHDE197RLncwfjjbydzRDQ21jdTDMq828OX47QA/DlwNT5InfbyLF6Ix4e4/EVdJPPaMf1HxdOLY0QM/kp1o8uoYJEfsLz82qrBu+QI2UIYOMFs9AzEt4vgshLU6jH1HSVN1QFrZjR2jJW1yKKlJmIn+MY2K+YY2GP0xW0hMflZxZ0oj1VBQUJqFr26YHNSaoXYb20A76QI4CsZUWFrLM7cLXnIWhKNyK4C+FHYdCZK/V9qqeByws2kuBX9eGoae8lxPQ8SwmURj3lY8Gqg6AgNhSE40vWhpwZc1jbg0vZllMkJ3lfaO/RDTIHid8uGnullhwFdJiUAMaBX0XNkEmw4WJCpT52GKXQoqyyBgTF1IrBJHEl4yYIy67EaFliFCy7DcTRs3sW+iQYLWGfc3PQgiwlerq8yN5d+qqPSwc76LMbbaPsPzvpmffqEh4pccBa7rVzRN63TJ+wqLHAqE9sR0ltuyLZopR4m4IMv85PuY3fbmyEa+HG6oJzaFg0JT8O1R6TDQNHiOF8cPlBiLmJ4qHOcQap+BS2Rrrb0KPJpDG1plkiMnuXAPznxX1WC0Irm+sb/Q0i4dLyBGqW4yVxnsUSxcuVZk07bLFZ6qse6DjB8TgBW5j/5P9U+e24gu8rU3B+glyxdvK4A5sPcxik/kNC84DmwA0UcgYNe1jLUDOlJzdcDkJTxNin/aBXcxYYm6vEigItn4mOANl9lSttZJo30HcPqQcB0RkmtPHPwLi2FvboRdxzll6dBOc+i1v7XIin1ScQyzdt
 bISFn8dA
 eMXwWJtB9L57NJc6YU8eNug1Ouj4X4fq2Bg4yvDGvfJBrIFQA9XRUKn8PS+Y9CAR7H5lnscSQW3nruzxHU5IWHYfiY2/arUo0XSj0D7YaUSQeJuWjRpOMe1EU4kS9QpfOrWbaGPgqyVfRDvvP7AEO+GkNB0/gTQIes0vFnCnAz2Nf85ExB9ih3QjvdydjdAISkKBZJeYS7Y8HoKG3lhvZ3fXIKuw8BMGyb/1QubrW7Rkams10C32OH2hlL8M30EUluDP8KCclQnESEC/TCoa0S26vgHSwIzc1ZWUZzJawh71qnYC1a/+hapkCrTsVAyvGCnlg8bRLhk2sIAFPKvGGF6YbcH+/vzWMK8WVi6wdlFD7I3A451MqClXqr9tPusA4oHcoNouEJ7mlRNvH87dkkySXwlqBjaCle0GADvJAapvig3rd7VLrBK1iroCFft03DxXwCKGuruMn8r1NHSFqoCG475Lp2aUhBXyiopIdEsT17gVj8pW9a0N6FyFwIIVttLdDpKlmB+fkDX0zMi+/kpgePW9iTHzq9DiHLWFjX438SwrKa8vW/FPaoXps5mdzv1Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Inserting a new priority allocates a replacement per-CPU reader array
even when earlier ring removal left enough storage. An unnecessary
allocation can add swapon work or fail despite sufficient capacity.

Track the installed reader capacity and retain its high-water mark
until the queue becomes empty. Reuse existing storage when the new ring
fits, initializing every valid ring index for the new topology. Prepare
larger storage outside the writer only when growth is required and
recheck capacity under the writer before publishing.

Preserve the existing prepare/install ownership and failure rollback
protocol. Device removal continues to avoid per-CPU shrinking allocation
under the writer.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bd098114ee4b..5e5c1aef010f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -202,6 +202,8 @@ struct swap_queue_cursor {
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
+/* Keep the high-water capacity until the last priority ring is removed. */
+static unsigned int swap_queue_readers_capacity;
 
 static inline bool swap_device_masked(struct swap_info_struct *si)
 {
@@ -241,7 +243,7 @@ static bool swap_queue_needs_readers(int prio)
 			return false;
 	}
 
-	return true;
+	return swap_queue_len >= swap_queue_readers_capacity;
 }
 
 /*
@@ -289,13 +291,15 @@ static void swap_queue_reset_readers(void)
 	}
 }
 
-static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers)
+static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers,
+				       unsigned int capacity)
 {
 	int cpu;
 
 	lockdep_assert_held_write(&swapon_rwsem);
 	free_percpu(swap_queue_readers);
 	swap_queue_readers = readers;
+	swap_queue_readers_capacity = capacity;
 	if (!readers)
 		return;
 
@@ -432,7 +436,8 @@ static int swap_queue_add(struct swap_info_struct *si,
 	}
 
 	/* No ring at this priority: insert a new one at pos. */
-	if (!*readers || nr_readers <= swap_queue_len)
+	if (swap_queue_len >= swap_queue_readers_capacity &&
+	    (!*readers || nr_readers <= swap_queue_len))
 		goto failed;
 	new_queue = kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), gfp);
 	if (!new_queue)
@@ -460,8 +465,12 @@ static int swap_queue_add(struct swap_info_struct *si,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_queue);
 
-	swap_queue_install_readers(*readers);
-	*readers = NULL;
+	if (swap_queue_len > swap_queue_readers_capacity) {
+		swap_queue_install_readers(*readers, nr_readers);
+		*readers = NULL;
+	} else {
+		swap_queue_reset_readers();
+	}
 	return 0;
 
 add_to_ring:
@@ -504,10 +513,9 @@ static void swap_queue_del(struct swap_info_struct *si)
 	}
 
 	/*
-	 * Shrinking the small topology arrays is optional. Keep reader storage
-	 * until a new priority is inserted or the queue is empty: per-CPU
-	 * allocation must not run under this writer's noreclaim scope, which
-	 * can grant backing pages reserve access.
+	 * Shrinking the small topology arrays is optional. Keep reader capacity
+	 * until the queue is empty: per-CPU allocation must not run under this
+	 * writer's noreclaim scope, which can grant backing pages reserve access.
 	 */
 	gfp = GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -550,7 +558,7 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue = NULL;
 		}
 		if (!swap_queue_len)
-			swap_queue_install_readers(NULL);
+			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
 

