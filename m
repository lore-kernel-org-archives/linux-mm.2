Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DEC10F3DFA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D856B00A5; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15ABE6B00A4; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78CB6B00A0; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D08796B009F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B655139BC0
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:37 +0000 (UTC)
X-FDA: 84596519154.24.B2A8FA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 807598000E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m30IZSSt;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8MdgYC89FNXCETYLCu1UZnVZstwWFf+XYywSCGgz4A=;
	b=nuuium+Lm6dvYcCxt2Exvu3FnNMkzEgQY7dnZEHiV4YCZdj5/oqhQsotBXk1zZR9i3wZYA
	dO64GclX8uxrmtw+koPRA27/7C/aT9jfcpEieY1Wgy+cKxr9RX/UN+idEwscKaIw/NZByT
	nyIW8gFLWr4CvCV/ZkVIlPxdv8TiCLM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m30IZSSt;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727555; a=rsa-sha256;
	cv=none;
	b=1EDjcywwRFsqOUpwDsImtrdaOeIrsrZLZU3cFeRh3HV3rVXZa5tDsgNpo8P03o7ZLaEWYM
	H4isnvLLpq0OGJ5VEj1ZpX8KZfHbEiTpXQPCYq7Rae53dqx89lGE0gvNDC+/HUkIWjvYYt
	HwctbIkk/iIzwPwZL++OPF0/rCF/PWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E11445AA;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C727C2BCB7;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=9RYTKEAJRgR1YdnkgRQ1TL6l1lNmoU9ISlURLEfdnOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m30IZSStpoMQAFUGwaOgmsw4ZwFX45+LZcRMyl3QI/3+RagpckMezSfJX7J2/22iw
	 cqP2t6MlKoHYPIulg/Z39xYqxGedJJB6mqlU2td6SXhGd0kfZVNuqnShX4/FdnhcHZ
	 oAYe0PdOl//iaFu+9eT7w2oG/e4T3yC3YxcLpGYmUjSb1pVppHKrUshi+8drg8QpC9
	 23Mpq8iFiPezNIAgkqeE+lcuVWIv/ndft3zOLqeuWXwRKvWshlQ19wKwCScTJcSLsR
	 ViwJncWuy7OLtPW197RzbqdyOtWUbH85v1rGLCCov39JVY3wRm1bE3S39Y5pyruoVk
	 T249p7idh6sxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810D110F3DF9;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:32 +0800
Subject: [PATCH v2 06/12] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-6-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=936;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6K0YJ01vwTDlwxdVK6T6C7w8M/m2BxZNiHO5rSzz1FE=;
 b=8DgFu7uQ3AkTL1Pq/A9upGeJPa79VkafPA7++cGACubDswHq0qwjZ+vbUYGkcJ7y7NOk/SXTx
 9JwMempDtZXB5nOiT7OH7aDm9f783s+i8S83OrtP7RixGD+8N4asqOh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 807598000E
X-Stat-Signature: z5355g494gqu9wh18ecnem4gj3sdi1qg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774727555-810595
X-HE-Meta: U2FsdGVkX1+tic2yJxTuc6HlFe8yW0sPLaD1Q4J0M+JPQYe0QPkX2GxAL46yOFLBitAt1Gizvz1WCD8zVLn9DuNuP+po5RAyQjzfcrj0R6891BPc7u5S6mUbb2qD/M3Smlb9Ud+pFuyIBQrBRHAA29XBqrzXzOqtloergkl+ELwyjwRKXd4MyF/nxbyIjyRjkl8fOf2XUJIJC95H96C72AfySEEZ+wKZSxbqnLb5W7sUP2+P+qQH8UeMjWVwEiEKJBajQPvH+mMcVsuCaBNiw2wG9W4sHD0EP+dz45Exs/Lw31nvR8Py8x70nzdmPs0Mu1kcg89bIswR8/ndM+Tv9V6GwRxx96z65PI/GLAuM5aqT8Evb1Ul4kRYh+x4NsQJZ4WPEpsx3EFAUzqgywBJMjpBXeZRLSdxJp9FfEfYacFCC2lKyovWa3OtuZWQbVWfXp7XTMQdnzze2+bplpWLzD3u3CbDMAgwAXtxGG7ug61/F2T36gUiUiffZvBhEKHtOyvoAJ9wY/pFiDJ2t2v0+f4dP1irlcUVXHCMTetpXooFKUh4TtI5L4Beh3+uFltzChiU5sli0jVwE1ciBNtqOvzXpCdh6Sm8ZKlKAw95po/8mFNE06uneR3RL1HrkgbZLlJbL2MFzDjEPkqB63FPKQYEMBhmW1m4GNrXs8/Y452sB0BOLN0lTTegPNErgt5Kqr2HJC3lvwsz7zBqTViX4Pbqnt98a51azDa6yHyzEP4/On+XnwQkR0TkaVVwsX0E4eXfkKuiZ9XGV0GUbNsrvddb2C/ItW6+vdFRQONM7cKQSZN8VwVZcMUNa5JgbxXGj8oI1nCcXUfr4DHKj5Ys1ocHF3RFczv9HYZyuDEXtAHnwJ+3Mr6sjEL2av1h/1zbV3+40kkUf4sn38ldgqOsuWnVguX06X5LRrxzJDI8g1BgGj/iRhKQGbm//ueVImDn0+Uhjsu/fFphKB3S5h9
 xkI1jvz7
 IKrgBxprSP/mZwzGmhNyNNTJKOGfG9ip3/liJNUQkg8x31S6nsJk1VMRnXkZwVhqywgG0Nw8AjCbQPxHH92tFkVqWF4F+bpuwg6vI56y4sHdibKKorjK84idS7bKfzMwT2juKm8evt9ewiFpuvA3sD85oYVKSxwYFNPvhazL3SPUsHATkzE4vcTKA/AzYlQE6jMBgCByh2xsSzZkkW20gQfz7/OMHImXL6Rtorh4DVpEawVUg4qbnqM16EEAUtjqJKqylGBnd+2BGCRjsOkDEpL8kKwKaCOYrNsAkx22FAgWYJ0Zxf+OzGVxW9cXLkbhsV1WVwzHMqYe6gWwlR/d3zxSj6dz7bofajeLGkX2AvY9ZBaurKnjw7FoUkt+D1mW11ib+m/nDc7dZXvrRvjbyCRGCSKZS61uF04aJTWtQIbO8by4A7k6MGN8X/kARO4L4dVurd2AdYzyC79uKrgC5waereEiUI4OkiIWMZrXHd9t7yaCubB16ffP9lHERErXxqItT1IbCJZwakyYG7XrRPPx9qJHdxaKbC/KWbccD+s6Egxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c5361efa6776..e3ca38d0c4cd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5004,7 +5004,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.53.0



