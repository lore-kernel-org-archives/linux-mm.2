Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B3ACA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37916B0095; Wed, 30 Sep 2026 20:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE366B0096; Wed, 30 Sep 2026 20:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDE76B0098; Wed, 30 Sep 2026 20:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663446B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:14:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 470ACA6186
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:42 +0000 (UTC)
X-FDA: 85272136404.23.988FDE3
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6897418000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EgghkpQ1;
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790813680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esyIJ2uenCkgUW4Bg5yqCYNzAMp/sriEEB194HG2gS8=;
	b=00XYn4YGm+EL5xnFJVawmTE38W7Mv7ILfJ4CjWu8WKOL0cP3jAYURWCYskMLhsdqi1zY8y
	OH5YgF3LAK0sz8JWLBi63QfBVQNB5sNXdevDyO6KUHh9AyklLP3qUYDnsMjMu89zN7fujh
	uqLQxaGbEvEB+QUYsIkEtQOzYtdhMsc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EgghkpQ1;
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790813680;
	b=MweCGkNY+ak2zvcP8/5KYTC3TJDwzDpyb2jGt8zT3fes2sGNx3aR62VbFQ9pY3OTrE9Uzs
	U40Z9egxKONs3CL9clOO2jwPzLfAoUm1D2yFtlmGmvKBqbUDF4uYxxlZCXfFgqicjgzlaJ
	NN7O/BsREwRRRkeH2/WZiKUvDU6sPuY=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85f0fc1fd8eso2951923b3a.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790813679; x=1791418479; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=esyIJ2uenCkgUW4Bg5yqCYNzAMp/sriEEB194HG2gS8=;
        b=EgghkpQ1Xx5XHiGkGMRDRBRLKTSwqo5qjGh5CaIPupsyeiIuYHiZXTEnRhwDG2/Bbp
         nv4GPiw0pTJ99hgP8SOnv/q4MWPjRPpASaeCykr1NWzjJJnJxwaWdZMv4MKKpJdQtL1Q
         2tarxh6q15Be1pnA5si1UndF1Qr55NgR3bCQ+MuWjGdyk5AeLqpUI7CFd1LjnpQx2h2f
         djwWWHTxyyEHM+fZfBa5D/eHxnmO+6f6P5lLkqOHtWw2PTqaIgt50v5RJq0Lyhi9CaqT
         x/LjNf6BgmnnyzJ6Kbofbiye6pNfE6qKj5k6B10eoskw3WsZiHT3/nEG76HAAdsPEv3B
         WD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790813679; x=1791418479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=esyIJ2uenCkgUW4Bg5yqCYNzAMp/sriEEB194HG2gS8=;
        b=xxLeQBqLd4s7OA9IOjF/IrM3YVnG8fFocc3eDIBt8Pn1/sc+dllemlM10SI/2U1c1i
         K/8PaXZEVmoZV8FUchodZv5j+nGmIrpftvdVXN+P0E6EcS/aBLhyAIWMCjdrOWhodVC0
         QEpwyl8LFvFxA2+ERFxX6nJCV6HhS8D/EJy+uDDP/6fwT5lHyqNJNe9IJmSVC5gYpr3A
         idOgd1d4luh9FhJG6Q9ddKdHDha1BgJh6i3KVE9LXaUTKpYfoSC6Bu93/W+qv5wV8vOl
         N9q4ydIm7TVnRNCEg9+4pYP0umDGSM4FSAv3+1Z73zHmW3LvNhcCYg7s4i37rEWz5GK1
         gIxA==
X-Forwarded-Encrypted: i=1; AKwUvBwJ02K46enSsJpgKMLXjBVlIwoJYs60Fa2CalYAAO6e4hIGLs4saiJqz2gPdztTdsSSpAbO2GiDjg==@kvack.org
X-Gm-Message-State: AFuF++nhZaCuj0sfcettIUZ7vfJ0tn4z3GM4q8ZC3SfYJObalbG8BcVU
	uEhtlcnXWabrmKGICbfN8T0PtJQgTk606SCy8TdmNmFlgjDg/fNWddMQ
X-Gm-Gg: AYBFou2Stt5dpcgC3Vi+rnFTJHvihdKwQfjGH/LllCwE/1vyXrgNOahf7Hw34qDjApL
	dUNPnKBVHLGqyoqJkwdGvj75GjyeLsA+vbrJgwRwjH8hxHM8nH0fgxYqC0hyL3h7b8ie6iQL6Eh
	QqQ7QaeeEnRfPtUS0JDLZuGzyQD0UaMujlhZ9Vpw2LfpZSaN2ZFqmyqn/e5DT+DY0jlE3z7PQmp
	pvi0tdxGhKxH3SaDXypKIlMlHEByY0s2PiliQXWlx7HiFL/DYoqFmckJad1rvVy7FSMULSAlTgj
	gbm/GjXzMoX+l1ur8OVLpt0lF7tO5pKHtbjDmdsl/HN0ppi+LgUg/I13hy3tU0JrccHAMVAW1MX
	+eH4ipcAKFFR+ZzxMjmbLqw30i7hlNyEOhgdzy3tBK1ew+ZLHftxGMSzuWlJ3ABSZSIPzm7o/Kd
	EL1lKYeoHVBGuyyJf67OVdZ9qIrDKzNW4LcPywoZFtewSy9cb+EKXqBxk+bGGifQSZc3eJ18iMr
	80AupI9QGzLdx17
X-Received: by 2002:a05:6a00:148b:b0:877:b053:2e04 with SMTP id d2e1a72fcca58-887498012a0mr2291130b3a.2.1790813679163;
        Wed, 30 Sep 2026 17:14:39 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818814b2bsm253287b3a.19.2026.09.30.17.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 17:14:38 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v2 3/4] mm: compaction: skip isolating large folios that already satisfy mTHP
Date: Thu,  1 Oct 2026 08:14:11 +0800
Message-Id: <20261001001412.3837085-4-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6897418000B
X-Rspam-User: 
X-Stat-Signature: fsk1fx1qwgqt64y51tt7xdcygitjnwcg
X-HE-Tag: 1790813680-175911
X-HE-Meta: U2FsdGVkX1+CPokSC1m/WrMcyqrOpiUn2Ne1Cfy+euoS1YkYR9HPVoNH5Zf1zgIBuufIcOguXGtBa12RGL1FhVg5p7KAqqeJQJNuZA5D9fXAhtgAzz1clwhWIIe0G1ppPSdTMPg/kqwpjkY1Knuk0Jkz3GCCF9Onjdwad1PjlICnWohIlhvpkwMKJDbCH0s0s5O5Shwlq8CWA9eUGdCw2HycRy6a/20LmHSAUdVPtIdQ/iQwl3FMWag8pYJfRE2VDM0N83SugXyYIdUqhYchytIO9vSkh7AZHJN+wV0dUBerhb25Q7niEWXjqZ9sWOqnc0FxFFgDot1SiPUsFBb7rz4XRa1qmw4aUHygu4aiv+O0UA++j6EPRffIT7XVzCKiqZMOzRtat9q0Jh08p1s0Qy2NL96twt8XgjPialAKmHo7T3jWMJNVc0kGfyBAfUv75uzAqA55s5ZG7VBiF0zoVZPKMuffg8Y96Elz0aNb6KHU6vztNhMAGPRpjvvtjAuCnGyRqIQn9LxmUgUa/ElG0LMMUJT5N5uXCfGPbpYtzAz65Mz8EWts5agXJvpUw5fJg4M2DxSK2S7GCRF+0j8vteBXv2qP2iHDCADK00rTj79Yo2TBdc4tTStvyfdV/JXuJHJv0rb7+/dRKxnUtBxFN7DPKjOxiDMD+uQc8YHc0u72JqucJMM1PhRdj36YmUnnEMIpHg3fWpH6t81Td8sGx4aEitoFNoKLtCkAaNBqZ8fKnFE8d0DKsvTSQAMAC+G7DegnZCeeJLQwNMbHAlj7XAvSKtNYMa1HkdDpd+36sccGlCfzGXNaaobwZuuiz+Z1b47u0JjufMMwJ9BEGTYCAvD6CevF2/bPGE2JAILntm6T6U+HBdZKTVlNW0IQggOsGBDTmGc27XBFhwzEQlaIfN4mfHxlgdiQ9bE6kacp4V1yzTdAuGcq9tiE9KJKv53wyQehM7w4skPaMw35Dfh
 PwwaN9QO
 JIP1LaOOwWPB0IsXFKQI7BoRxFowAMARDsi989/IRXmfqTEMoJFTdOUFhtTAQx3PwKFOb13tFwJdJihoxDb4UiguzMnA9uc/QXowsFNbBNc30e+6s4JZYEHM4FVCsdZlMuXYElDqfCArftzzTnIJpzsu71OBoE4YenSkn11ScCmkA713nlb0LrAyK0dY47XabARBB7eCZKpjDW5ogLI+iVcrGL43XzIsrYQpwS0kBRPuHladx+ix5f+FzAV155gbdphjUqZ535Q326X1/z0Td7JYSYvrtbb4UVhj231DVnORlYnzobHgaQApQP8SqJGJ2sHzSpIOfICDEgx6zEVBix+sNM+dqnqY4JNB7ILIy6N4ZRiRdDfNcy0q+Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When proactive compaction is triggered via compact_memory and mTHP
always-enabled orders are configured, skip isolating folios whose order
is >= the maximum always-enabled mTHP order. These folios already satisfy
mTHP allocation requirements and migrating them is unnecessary overhead.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3928a5483efc..0ff454ee5604 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,6 +82,15 @@ static inline bool is_via_compact_memory(int order) { return false; }
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #endif
 
+static inline bool mthp_always_enabled(void)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return !!READ_ONCE(huge_anon_orders_always);
+#else
+	return false;
+#endif
+}
+
 static inline int compact_hpage_order(void)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -839,6 +848,12 @@ static bool skip_isolation_on_order(int order, int target_order)
 	 */
 	if (!is_via_compact_memory(target_order) && order >= target_order)
 		return true;
+
+	/* We are compacting for multi-size THP allocation */
+	if (is_via_compact_memory(target_order) && order >= compact_hpage_order() &&
+	    mthp_always_enabled())
+		return true;
+
 	/*
 	 * We limit memory compaction to pageblocks and won't try
 	 * creating free blocks of memory that are larger than that.
-- 
2.34.1


