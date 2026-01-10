Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04063D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140526B00A1; Fri,  9 Jan 2026 23:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4A96B00A4; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1186B00A3; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 997CA6B009E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55466135D5F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.03.D2A67B5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F61580013
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=I22B2mc1;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FG22dGTQn9arEKy7RAkcNwMcoAOPOCF9+5yic6HqZ3A=;
	b=khcvMY/7LY8UnenpdLStzFEqslPjJAHYUesUCYWmbD01Fle5vRxUNqfPB7/k+9t8SJVtsI
	2iOUW2e1yeQm76a7KNQjh0EPgpt6cSRJncqp8UHfqzzIuAdgeTC+CEEAzK4PzlGOaRSdXf
	XHWOw7RgNqHB5dupzT7SaI/k2cUhPnA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=I22B2mc1;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=c7Iq4FqX3hHJvcy33X6l3b3OH1Y7WTeoLBfe+dp+aOuIgMHA2mmT11N5sZ7Ex6kXEzc0t/
	p0gsrMej04rZ0ZgdiZXy/aXxiv8NDcjKUp1c31Lkkn2j4nlDQq32jvOjoeSq1/bVoOxMU8
	TtaPj/9AqBrlPfftIuHTVQ5PgPt6EFo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FG22dGTQn9arEKy7RAkcNwMcoAOPOCF9+5yic6HqZ3A=; b=I22B2mc10P0NblsrYHwgUXsHoq
	P4jKS1TQaWbO2FMIiN5/ZAIZmASvGnV19AMyUa8iI4VzAEqXXPphq+j4n9oQeiAXrGNTK1pvOhDcG
	p7lVVYdoS6mtT/4voowpR1gV2Iz0TSYnRJVfchF8xtAXwmjE+ztiVDckGM8IVMhWf0mv2EIc6r9mB
	dqEqFa1gohVw3az/3xdOpWauCJxDD5w5hPdTCBeE+seEu0PG+zbkBB4+Or+Yrdqm431zzV/1BOBTH
	5VHuSn11VGESC/F007GJdw5QeeKg/CdiwVvqxvkMeO1uu3wFkGYjjEU+SU4DdbyZwICnrCpWnkbs+
	Af9eiCzg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085ZO-3DkR;
	Sat, 10 Jan 2026 04:02:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 04/15] turn thread_cache static-duration
Date: Sat, 10 Jan 2026 04:02:06 +0000
Message-ID: <20260110040217.1927971-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F61580013
X-Stat-Signature: 41zjo15cdjs6feq7u7nzm594xdxteq4n
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768017660-64226
X-HE-Meta: U2FsdGVkX19W8SsAFLVqch1mTVLfDg181yqx0ZnGCCcE9PGOQ1/RbWb/Wj/4DmedsksiQu+mILuNKrGOtVRYtKxkvJ13yHI0X6+d64S6AS5OAKmsh6aXtj029ORG/MZCu26AykCyixt6c/2JArXaL3osOktIDM4QzJcoBICCW1ro5a+OtAd7bzT3WtV/QXgbnBqwHmlSB5cFG+irbqBlsE2Ey1rvw75TWU5FOWz1eLV/3xw6lZraw1/EyfDw/pI8mHY3eQI5RxsoLeChT+pJz/kLiyLldz5QKqiAGurn+C0Yeu8ogB9hWifeWB7vmQdYq4+jLYd7mMQfLBIbTPEim1vvkqTFlnROp/XAECvOZuOYYwtsz6mdKSXYcag6xzhXxSxsZbxGRAvAbmOrSfnYyhYZA71RLPnKHeaVvC8Fcy5Ts9O5R1wDOgZbjx5L4I8OibNbQtYhe8guPZKjbTh0kdYITbl7SMu1VNxBCDZqaxB9NsbPuzLpDBkuPtJSWW1q/BJQP3vDkqliYOxqrSMKZCgU1mIhHFBeO8o11lg4Yw5GyK5OeOZXtxas/maeXV+aDclaxxx9RBvLqHDm0sFeCKJTtEFj4mlqewWpHtSttZXMv2RyW9FG4lcySms6ZdgAuD4cEsT076dJtrXjYK2eyR0rhqDOmyU0NYbKXU8CP57mrk6fifzFqacdApXjDlD9g4weolo5xbtG3kKMqaoYzsDKEZ8SzzI+TyIsJBE9A/h4ETFrmOlAq8+WQcIKekPlU14V3MVjzdMKhXbNHQeiBOxYA06Y+r/xgJwu6YleU10eslCpCdgC5z/OJrIba4a2wZekxZQ1Hl0apHo6BZqxR5bSBoYabjmKcfhiRtE1U+PIdzAPeQPFljiPXi76Cz7iUTxznzYgferEKbId26RS12m+Tye2YPbFINvx9YuFAR7I3XsHrp+VE8T1tY9NAR+rQvx2wc656zXCNnE6Yhh
 eL1OhISc
 CGGOzEnvPXyLZTdFF94H27g7OS+eWP6GbEBTcV2aRFnixp5VBQBI9HLU/un1bIRFNnC5strJ6wUWeKYNHfwET6Mh5TJMNgRh+BrHwspcRIAvM6lrR0vyffbRJi7BeGQ8sQUyogV+YQx4p59MZpmCkTkBUo5p3v6JYq0uraAKRBDf4oBB/jO/aXIyb0tmNi+NMTrIpkMTHn7Vz2l7jylxSTsdd+1XX+5OyiuEYb6tz8E39YiDsfQtzvguPxx+zXzpcVW0eqTnsDPrCAUq0o6kcwatGj+lHjO3gEMvTfWfEFUvoRnyiVuc0OLPJe0020vZfMben1QKJdVAZqnrDn3dUye+2CNG3A3LkYkx/UIhEl2moGJIODg7LSvtxwN5+DdjHQpMwhYyQ7AHglKEhriVp8W9GgcBAWiJREIYJvwwU0W9CB1MU41yMxyfZku4p/aQhTMdyUHcrrPEYfbGOnLBuDBZGzuW2iOgFYjqw9iq/WswactYDIJDftRv1MPEFMk53vNGuAOT5AX9/Esv8Gb08E2Jlt6F5Xh05iADI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... and make is SLAB_PANIC instead of simulating it with BUG_ON() -
the boot is not going to get to kernel threads, nevermind userland...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/fork.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..ddd2558f9431 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -108,6 +108,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/slab-static.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -422,7 +423,8 @@ static void free_thread_stack(struct task_struct *tsk)
 
 #else /* !(THREAD_SIZE >= PAGE_SIZE) */
 
-static struct kmem_cache *thread_stack_cache;
+static struct kmem_cache_opaque __thread_stack_cache;
+#define thread_stack_cache to_kmem_cache(&__thread_stack_cache)
 
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
@@ -453,10 +455,10 @@ static void free_thread_stack(struct task_struct *tsk)
 
 void thread_stack_cache_init(void)
 {
-	thread_stack_cache = kmem_cache_create_usercopy("thread_stack",
-					THREAD_SIZE, THREAD_SIZE, 0, 0,
+	kmem_cache_setup_usercopy(thread_stack_cache, "thread_stack",
+					THREAD_SIZE, THREAD_SIZE,
+					SLAB_PANIC, 0,
 					THREAD_SIZE, NULL);
-	BUG_ON(thread_stack_cache == NULL);
 }
 
 #endif /* THREAD_SIZE >= PAGE_SIZE */
-- 
2.47.3


