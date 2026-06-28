Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FCBC43602
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA5F6B0088; Sun, 28 Jun 2026 18:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9442B6B0099; Sun, 28 Jun 2026 18:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880B16B009F; Sun, 28 Jun 2026 18:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDB56B0088
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D338B1A04E5
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
X-FDA: 84930693414.15.D2A7171
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1107D2000E
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Do8CglHv;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684086;
	b=A5IE1JIwCpnaA9kDDMdo5PaGLtmszydZkT8TbFogUPsLBd3Bqm4UpUl6XYXyEwcY/HmK24
	wpBNRKhxEU7haXT8eG+UUcLe1OaVefoxC7ZF5y8xKwqDi2dsLB8BF+4pBSNnB3p0pc2bul
	YVtATtR/fOyeZ3AsfBLmhKZCd9SIX7g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2RwMvGvcXDxhpeE3Fm2y1VL7VUt3RWHHkP0dXl44lw=;
	b=b3TwiRJIw7Qto1/wkGx1S+9pbD/0x40zOUjU1FMPAeg3ttHcp2rDq/vjgLc0ZsAUuKbHpG
	sIc3iGd6w++bPFfVZmRtXhjte8oz4nzni5NHNoX2fCWIrwVYXS/a/5+ztGcRJA1L2DGXaY
	bixYwI1tzPtZSa93OY3p/OxNVySgPrI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Do8CglHv;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C6D641991;
	Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE29C1F000E9;
	Sun, 28 Jun 2026 22:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684085;
	bh=b2RwMvGvcXDxhpeE3Fm2y1VL7VUt3RWHHkP0dXl44lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Do8CglHvvd6hU5kWZSRwGWzN4Hz8HtwGTGz1/VwmuA1/bhV09vN2ju/H+Eq0CAWxa
	 +EVWFfLdCkGb9nd2DQ0Q0RMHsp4xITyCG0iZ0fkugh5EeUdcm68io3mihgCdyig8XW
	 Noj92cdiKk0FZvVErunjGBHmsdhAwovibuM4CdLVAuBBPSD45PP+cIlKhtxHhr4ymi
	 lRi+19TfEdyvkj0Stp7HxfoLNSQ5+FXFsLqGth6fydPqlxG9nqXKTEH2HRor8dZHFb
	 VLEnR10QeLiZeCQqnSSGD2CscOEg9MQBTpP2ex8vxCcspd4jeMmU8NF0tF4I/bVnfH
	 alZMsleQGlk1A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
Date: Sun, 28 Jun 2026 15:01:10 -0700
Message-ID: <20260628220121.97360-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dja6bnj5tenh8mqfzabfdom1x5agjq8f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1107D2000E
X-HE-Tag: 1782684085-619494
X-HE-Meta: U2FsdGVkX1/Hr4WhqCshA/k12CF9Y8PhSHDBWNz4ei5mTlTiHTjKAruyMBjKUSE9zwMF5xZzDWgLa+a0umZSSVSZrkZvJw9rt8YgyTr41i+n+6XaL0CSbX1vOtCU4EjCJT3Gw4QHn46Ak+ZeCXQN+TdMjpODYQapsE1oRap5nlQ3qSbftQh3GpfvQ5ut7dpgdSTNx9gUcPIIQTu701Ht2THvjjOBEefhcHg58fUVd9wbnIb+gd+LYbBw/uOP3mzvn9qhgMK0LKRSA/N3dr+oPplVH9V2poT/mBTiyEWktwC4avR0rmiA7amChSpTf5quku7t2sVnH4wpn4LAd1J6EJUL8Zcq+dV7BEi7feFjO7LhFU/kXIaxz0oC48R9sDu59xrZN9wUhMVVzs7TkLG+XSwnON0meoOZCJXrWuCgHwSu9xF7A8ko1QHIwHAWy2zeyrhM1PGHnriZXytIhZJjbxhZA7+X/9BIzDkpfRPkPotuvNIU8roboaP7zWBGLfImRKhht66ovvYU+H+gnjpBiAP1xWwbmJBrODWpzWJUU24xmrF23FuvSxHF3JIBLu/ZIjJ9g5LoDON3Gq8VLE9a0QGqPxGXvOQS8jcv9N+F9Y6qQ4UuOsTRfk29TE2/HtZO2fpzipFuSPlrME91nYgfmHhFnHuutm5zFa/tdJpXZoDzIEb3O33m6a/OxRHc/oT7nb1QqBJGmydpwKQR4HzKUUYlKunLWHl8u7jzJdOQzhQoM9/BjAs/phzm9vGI8h0bdCnR5LPFS+PWtxQAyviEcZzJ3XOo+IAtc4ZCfgfY+msz27KdtbeHDY1rFU/oXByipyr+WaDrQGmtfHdtkIc4xcZeEy5OKsvJf4S+mk8k/2xvJAmHioA8HW2dBpKC4nboOVCR+Lwxje04VYY38VNQfPTt3kHCETK8KzSosJ/4SNcTbbov5kn2uxQAFVvAo4/JEr8f7LFE33ZTqopw7r1
 t8jhZKeO
 8/5t6PKVIS53kHXDFf3OU5NaKqfzmIPlRcKAgRWN3Au1OcULoNQnc2r2aliGq3H3EZBOg/w0s/DIk6B8VxKmS2RuDPhqQltHA22gCOusAyJnJ08vmgCrwDyR5Re9Sy1ls52+uQ9EwQk7d0qLP+fwhCNqe/xcZJhs3xyskc9Qqslv5SAy7Q3TPoNwIoeZsbxcMrtjhSKpLERTzV5l/s63sZmqmvUjbzC/sKZX2UHG0RfR1XlOaf2mfb9Bz+bjMfcQ1vLY5INIG98eHKu+CcQKeZDl48g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for normal creation paths of target, context and kdamond
directories, and error paths of context and kdamond directories by
adding kobject_del() calls.

Note that this fix for target directories is not complete since it has a
similar issue in the damon_sysfs_targets_add_dirs() error path.  Because
the normal path issue and the error path issue are introduced by
different commits, this commit is fixing only the normal path issue.  A
commit for the error path will be added next.

Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index a9e187158067d..38f3b02481f0a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -331,6 +331,7 @@ static void damon_sysfs_targets_rm_dirs(struct damon_sysfs_targets *targets)
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1640,6 +1641,7 @@ static void damon_sysfs_contexts_rm_dirs(struct damon_sysfs_contexts *contexts)
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -1678,13 +1680,15 @@ static int damon_sysfs_contexts_add_dirs(struct damon_sysfs_contexts *contexts,
 
 		err = damon_sysfs_context_add_dirs(context);
 		if (err)
-			goto out;
+			goto del_out;
 
 		contexts_arr[i] = context;
 		contexts->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&context->kobj);
 out:
 	damon_sysfs_contexts_rm_dirs(contexts);
 	kobject_put(&context->kobj);
@@ -2499,6 +2503,7 @@ static void damon_sysfs_kdamonds_rm_dirs(struct damon_sysfs_kdamonds *kdamonds)
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
@@ -2553,13 +2558,15 @@ static int damon_sysfs_kdamonds_add_dirs(struct damon_sysfs_kdamonds *kdamonds,
 
 		err = damon_sysfs_kdamond_add_dirs(kdamond);
 		if (err)
-			goto out;
+			goto del_out;
 
 		kdamonds_arr[i] = kdamond;
 		kdamonds->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&kdamond->kobj);
 out:
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	kobject_put(&kdamond->kobj);
-- 
2.47.3

