Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832F9C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 06:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBC56B0088; Sun, 13 Sep 2026 02:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C856B008C; Sun, 13 Sep 2026 02:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2A46B0092; Sun, 13 Sep 2026 02:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCB46B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 02:30:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 171D4A54FB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:30:48 +0000 (UTC)
X-FDA: 85207765776.03.1F57612
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06ECB100003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:30:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789281046;
	b=d1mTMz4weDoMQKQAGRqtAOxkJeQ7TYJw4Jkzm8u1k0rm47ee9vc29+IF4nQl7IYTKWsQjX
	bNd++qO948w1jjVQCY8wFz5Y057IYEwjCgqSuEiWSbwZ+2yTZMX3Zj06mcGrX5//1tDrGv
	CseoKWj3oNuWgq57QdoD9zw3Sp9f140=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789281046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=qYKYK7b/QquRhyG8h0UK0SMzX2THzVa2mJFJmJdN+HE=;
	b=4e711UA8zHr82qKheuv8MUdpsViCNEy8MbssZkTx3avou3a6//Ys9KGXeQz+kgRtisPh84
	E685FzgphubyPjJGetpsobCVxcpkPZNT5vOEaie5s3Cjg//XPWnAhFAfgNmxzr4NzOsy9C
	wzOvJ4RsUcGp6ftFkooDqLU1clL/90Q=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6431ec6c0f68c77b;
	Sun, 13 Sep 2026 06:30:42 +0000
X-Mizu-Trace-ID: 6431ec6c0f68c77b
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	chrisl@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Date: Sun, 13 Sep 2026 14:30:31 +0800
Message-ID: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06ECB100003
X-Stat-Signature: b81suiatfwszucmr9u9dqgt8jc1zu8bn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789281043-69993
X-HE-Meta: U2FsdGVkX18HsDWYvgMKfE/zU3xQJgai4jh7t4ft4dbv/3f7SoTb2JG/1L40g/iZSbUomTTFHY93XN/kO4sE8qQCO4R7kohwLeMBufgx2ASFBpBFI9PfeO1YhfATP0JIkvuWuX2OFn1/cPjaAltdk+0bF1+DeqA0+i9hJjhUtdhjmg9JNwboAHvEToH+qk1e+Yy+0+xxfgC9/AvXiU4TZqx9HoZMm6JmLLp/TE+1CIPKxcV3mDy0rM2EdXdSv6M1d6fpwzv7sPSDHXx/lg6HNarL4xttRa0YQNYmFB5lqBtJnKFlv7b0pltrJrDO3EgN62oipaAkSl339jjtfUm5ZHUFQ8CTxBO4RuCx7NKmF5AMwgvUXzCBoH/QonHizugiQhRNiIW8INR9BepsYKVQzO7h4p2gMatzZaPvPfL0kkkNaWOs6NaBzwBnux70IlnDLuYpzM3bgALi3rTeH+hvTuONirLsaaupix8lq6FbQoUAJGYbgdcvxztACd7Thrkv1YuOWJ7AcB/mLzZKOm95vi60CMlvfgN7dNSoPWaUXyYPwNCVjSVdbYCh7JnQ7tF82744FrmEjwwKcDsdhBx+INMcZ+2/I8MGsIQflJDzMuM2/2eH1Ltzg9t9r/kiYELdJyVQ5/HsA4Qy7GXEirRwF9bdOfbrNOwxM54B6cJFasnNZ77/qZ3Hncg5y+ieF5+FxeE8ndw3xSnvnainbOE2v1nTrOXh8vCI9pWy4md1iEDg7Y8J4qeFasol91ol11J5juxgnwY6BEWYytxDD1T/gI7DTzIeu/bOhw8TuBGjVPfPZF2UPqul4PxDdaX1vF8nw6NgjOEIEUAnLmoNt1FnjDW29YXXs7Dt3M/SbsGymlcDSNFDX2D63yNL3qqJtD4igdGrz0mr0MqaWzE5kQIToCyK28NTm5w7hiOnG6CP54+2PidSD5CDienOQNBpEnPmAbPB7eH+AGd3GcTVicY
 JlTDC9gl
 AkRbavyKLVnzxbmeVDAA01ZIOx2oRpjbeeuvOeQp1lB6Bo4P63Gojy4I0b0yXlR43AP9Tr5BCLjakvsn0nehqW5CouvxdnZqJnA7g4WMSYeGXdTKH1nwS5aSHG6mvliycfnF4JtgFyxVtrn7LuJ5UJ3jRbZYsdG4uXc0U5kEb2KThgc/kHdOw2LCHzHPDsYinVwBjjnP2wPsSj/rvk60WxDAIM49YSNywczmgqu2YsrSTiJWK4sJpCEs5qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
Independent of xswap; affects all swap devices.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
Note:
This is taken from xswap patchset. Nhat suggested this is a fix, should
be sent out independently.

 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..b9948d4657d2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -998,7 +998,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-- 
2.54.0


