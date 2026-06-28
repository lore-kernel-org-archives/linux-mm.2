Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A21DC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 13:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576F06B008A; Sun, 28 Jun 2026 09:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EFE6B0092; Sun, 28 Jun 2026 09:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B446B0093; Sun, 28 Jun 2026 09:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9EA6B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:58:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46C3DA03D4
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:58:46 +0000 (UTC)
X-FDA: 84929477052.01.2F9E448
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7CF9CC0009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:58:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JOiyPULg;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782655124;
	b=2jMDB6eArrusTopLelg/ldE1phpBJ/kiYWCKNLiTLPhdgA9J2FNw90D4h01VLsNDrmuzxN
	URNl3MCoI8pK6ui0d74vrIRWDs+H1/kRXuQIgXZD4MAkXPBu5RTpmn/qWlqxEgHXpTwu1/
	L0WRxEp/opEOElqXSt9rtZPt7Ht+zC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782655124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1Vq7rP3yWIzcBizeF84kYYKahUZZehGsPTSqAJ3DtE=;
	b=Pm8iWv/ZmaDq/0rB6hrFnPYxK2cvhe4JgMOIDDiJNUURFZ1QaXZuMwBnBxR5yW+tIaxEZx
	96pjrQN8nfX593mPsWnwW8Hph3rt4zMgbi6VkQV+HedFNcZlUNiMDLkJ0Ew7bq44Ala6vO
	U4e7v0WmE2e7+DblFL0lIu+A7QEDUAc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JOiyPULg;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so1125159b3a.1
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782655123; x=1783259923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1Vq7rP3yWIzcBizeF84kYYKahUZZehGsPTSqAJ3DtE=;
        b=JOiyPULghagCUyJwsLutD2xRMe9SC/i9E7KKZQjAgHVQE+F2VXjnTVpYN78DGcdWGA
         93lk+dyw9uwO4G8tc/RYzSpWzUZmQPgDrftoB0KmMKLLu+5hawN16nPY9q/V0y73h4j1
         Owdodrm3U0XYvNPjzxYqrwfw9XSt7U4+OJJmafEtOE4fV3q3IjNO8BIkIvAaw2kG24dJ
         wFov/ao070Z8npVuJWRJiNcmuoxf/8oAGJ67AMYWG3PJWAYTWXLHm4TWhx9MhCgyle5F
         yEgQgszrugoVOmNeX1XJVCPljbFEt3KjirFFuis0MM/NenJKFDQ5u4GM4oaS9P6h47eu
         Y7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782655123; x=1783259923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M1Vq7rP3yWIzcBizeF84kYYKahUZZehGsPTSqAJ3DtE=;
        b=Ve0UJhr2kSvu49Mi5zUbiVTv0PMNuLj+Ss/XhB+O6NBhg82pDY2OPKuV/zrW3U4jxz
         4hTz+Mzq6KpPUQJDjyKsFL16o4LKO7QPAzfgvkGMTAaZVDkY60CocFrjX+5c8kQTHdmL
         XATRkjkHsBe3Lbwqftn0y0tWGYcE9tsbnzkP9lX+IR/mRkQt60xIm4XpWk8HMVPFie9K
         ZoWhS8brZ9esnIY2dY/4Mvf9h8oqaaLA4qS/2mpdBKvtJdqHgz3W5kZrLxQWKk/YAhZx
         ccPp15u6+HWlaTvJRMGSgTKBYzVvrVG4lpbSSHDTINAdVAowZAniGKuJGguzp+GiAcIZ
         ljlA==
X-Forwarded-Encrypted: i=1; AFNElJ+JtqN2FLGKxOLK44WAEwLuZU2XpBQhW6+J15JOgfI3MHJZ/FcyASpfxE7CSEiuFyhb1LmDOD3iAA==@kvack.org
X-Gm-Message-State: AOJu0YxFlmUrnMn5BeNG+k7M+3DGnFElLgARMkn4uRc+x7b88n5iikxn
	yA17gyqKDy5fxziUaLyZ5Cm+au3jZNv8iwlvda4/yLrBIdDWruQAHvWv
X-Gm-Gg: AfdE7cmG9rc26DZufBG69f7lmBURu90Wwh6SUOr5/W/so4Qfd4S8+RisxK+F1q/SJN5
	QnyRegyxFds0ZQS7oWClYMz4Nk3BKcUBFTwruyB9DxusIsaRS2L4htKD/nisBnEMK2PlV6/5Ays
	DlmZYLnWC/ZC38HGH3HWC6M1StlWVSJfzIl8gKvsTLVgB8uuwiZ/aoiTkuIOBrfx+q1RU0u5H01
	kqGWJynK8qfM6KZqBBMeAIRkjON2icszqjxS3FtH1sIXHUjqyME09unBDLbQfYfYhxyEjK6xxwT
	wk7HVGl1Acr/T0/YrIUC16YvD44cyN5z4cw5IuFAiUf+JNpBIJxJf8/YMLOSiTMQyRIN2JV2yko
	yj8W/c9fX3GjsY4MQWKNgTi+CJDQiechDjzCwaGiT9to/ZEdjdZPq2F/1vjUS++k94WtHd11rXY
	ytHLTq4BA=
X-Received: by 2002:a05:6a00:6f62:b0:846:5d1f:56d4 with SMTP id d2e1a72fcca58-8465d1f5b49mr1556078b3a.14.1782655123402;
        Sun, 28 Jun 2026 06:58:43 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23d7sm10041108b3a.30.2026.06.28.06.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 06:58:42 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
Date: Sun, 28 Jun 2026 22:58:15 +0900
Message-ID: <20260628135828.1393120-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628135828.1393120-1-ekffu200098@gmail.com>
References: <20260628135828.1393120-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: whf4tambu97zg3ny7twhqo1tf4973koz
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CF9CC0009
X-HE-Tag: 1782655124-930269
X-HE-Meta: U2FsdGVkX1+VDvwLVc63cFLdlFxcH0g1Xg7aqwlYAmnnWkSWahnruvVocglYWKXnlcMsxa8GroNwN5gAfNMuwvkEG+joXJPyPDPpchq9Y7c5vUkJ6FEaimsiCT/5JSAMRb7FHV83Lv8Ue9+llYrs4uExOu+ffsfMz48+9Ro2U+G7Q/jQ4mz+1CFTRWyduidGnME3d5YjEtkdfa6pJqTElvbBsMGgnE7W6/KGg0vmlJTEazYiTbHIDkKsGA1F0oQu3qjAP9fvJP/Gs4DC/6ojHPVMQ1FKjOvZSGke+srnk3+ZlA4hc9OY1PBil2tXx9ReFHB7QKu2aTNTxoX2fDRidIwOIpt/xxVWx8xhJj7AI9D5W23IGMP6N47c53Y86k6LNVm/QU2dCPeJyOjN2+uFDQToEytTLIkwSOtSQz6QVVByNx3/LqqkBgmbJF5aJUZRg3slu12uI+86GxOHdvpcUlatrGDwsEiR5fVCeJ510t/Ff9rlU1Ws3F+8azljX+eA4pHxYXacprpQtisgYDnU2BBotmr+LFfjKfpDr6i6QmSfV52E65oElhiizDsbwLSV00xba94VguNG/KONNOytKuOKkNzhXtZ505uNw+/rBia5+kM0GMqbSdrEzDKb5lJiJE1m8HNIcwfB9wLIv5ZETF5fj3awVirXdTakg3RgkUeLycq1+qkOs0gYE4LlEZLjB/gn1mmEHN0pZDFWW3Fp8jK+OBKSKA8QnWucqbi99vggwkYnxgByjpwuQQvaNfFngZwTOziG7BN3cQcN9KKOPVbA/EUN6aLlWUtjtEYSkU2CY2suX4uLcn3uX2gR7lXdlsZxdJF1mrLKr/Paqpy1EFJyBlnsWUE8u6iN9Sq+Ukie+hHQGkcOuUqC6ueMy1wlYLIycVSx445h2sv5COtWMZHsGz/R9yUyHGSdUDaSJ2hicD/zPJLqgxh22L6oES4w19cL22wJbKDCt3Qjkpl
 tnwwKU1t
 6UUPARVaWphFEEbnAXdpMp8MZboC/dBXeAdU3c/vSAiNJVYNf19JyVkZCO/5UZg1FxuOu/S9jSfrvUf7+YNRmWHVnIntMsKqujUUqcxNdMEn1HLI/RlTdwZUBObTT/th4ju9y3pw/riIAG4dqyKviQTEUUq3ARkCMeZo0aT0YiCm/QLk9+2z1Bq9rNR9xFyD7S4mJRHiKEmtSUfI6LiGwt9HfktwUGrDNsmYzUmnxJtJa0JKXiOwwalxX7CYgxzSOkxuNQjDfArCpxlktUD98RMg7ROka/ubevhwWF3FvLLn/uRLjm9iFcV/p0XIKFNz8VmtMkQXAnZ/yy2oMeWhAf4W5H5TPdPZadFfvj8bqEkwwLvkCMGLPjO4pyFMyNqf7AD8ygQmuGDXF3W7IhHnuwRtukxf376HWsGzkmlaZbc8xG5ZEETS5HUK/Y2BmnVQstlXuKxdk5EAxVDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every existing numa_add_memblk() caller separately marks the new node in
numa_nodes_parsed with node_set(). Set the node in numa_add_memblk() itself
on a successful add, so this no longer depends on each caller.

numa_add_memblk_to() now returns -EINVAL for an out-of-range node id, so a
zero return implies @nid was valid. No existing caller passes an 
invalid one, so existing callers are unaffected.

The per-caller node_set() calls are removed in later patches.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 3c3c4eac3514..2d92ca38c02a 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -135,14 +135,17 @@ EXPORT_SYMBOL(__node_distance);
 static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 				     struct numa_meminfo *mi)
 {
-	/* ignore zero length blks */
-	if (start == end)
-		return 0;
-
 	/* whine about and ignore invalid blks */
-	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
+	if (nid < 0 || nid >= MAX_NUMNODES) {
 		pr_warn("Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
 			nid, start, end - 1);
+		return -EINVAL;
+	}
+
+	/* ignore zero length or invalid blks */
+	if (start >= end) {
+		pr_warn("Warning: invalid memblk node size %d [mem %#010Lx-%#010Lx]\n",
+			nid, start, end - 1);
 		return 0;
 	}
 
@@ -193,13 +196,20 @@ static void __init numa_move_tail_memblk(struct numa_meminfo *dst, int idx,
  * @end: End address of the new memblk
  *
  * Add a new memblk to the default numa_meminfo.
+ * On success @nid is also set in numa_nodes_parsed.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
 int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	int ret;
+
+	ret = numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	if (!ret)
+		node_set(nid, numa_nodes_parsed);
+
+	return ret;
 }
 
 /**
-- 
2.43.0


