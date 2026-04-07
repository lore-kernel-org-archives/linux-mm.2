Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD96FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D1F6B0099; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026E96B009B; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45776B0099; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0DE76B0098
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4708D13B957
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.29.22CD0DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A0F81C0011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gXZ5Jr+y;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rw2Y/TAR96TYDVh5o+sXYSB6sFS2azlBNLPX901YzII=;
	b=wFaf5exKt5IRm++yhawkSBr5yDpLntnI+7rpdMbRNDRasFA0jFslhEskrDOpMONx5s7rnY
	wGjdPxCvgn75N7Uggre1J2c+s/fHNTyNPRZkYqa+azC7NuHAjdjsiVrOBJfCyr38ekuaAz
	M0wXb0VmhOWFsensgjIzYy1r/B6NOXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=WZrJWx1BFfzOHF0pqyeGW4rIPNGYXruXQcNdnXCqq8xEO1d1dcscgQgowB5uLgsHburvsg
	VqrY0c2cZYVBAWIUvfwqUH3NNmBt83eJa4yeAEyAu15WMdKOsPzCpWoojrArc6Rnz6+g0+
	ddc+S/n/i5nPA1lnXGDmFgIXxnYgP/c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gXZ5Jr+y;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9389A40689;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74B38C2BCB7;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=ztVO6NbikqAF1UlcRZLjXHar939TgkRFnRH80QPPGLA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gXZ5Jr+ybcDOrxB0xUP+vcfHXd4uwEXxY6Y1hc9hpS8UWcX3umJG2ULPBWOP+MaRN
	 NIROfoLWcC0gqT1EVQISMdIM31CBABXbhF1hpbOqGVy62/+rTZLwgGlVKH8eJdAYTD
	 N67PBggw5z4v4irWWrZ9AyzeU7bjVrBlcqvZ57XZRjCXda3BwEjuajF+MAu9e59uCo
	 7YWOreC8FiIy22RIpOFDFoUbQJbGgQSs2gYYy+6UqTLb3dQ+MLZ8EhjVzGiPiLHayJ
	 944cvF5NlkUjPmkasPqkCXxjhB0bCAAS5HRtz8/zv83haseOCw7gYURlQRR17oFZ7D
	 U1XNYxteHuzsw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A25CFEEF2D;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:35 +0800
Subject: [PATCH v4 06/14] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-6-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
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
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=994;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=X9Gq2uPvlNZqVyS5yzKBjUAw6aqnZAcV2BEvNpvNlls=;
 b=lyFH3Gn5CA0OabEA/Rt9iUfEdmXNiUxSdscoLOFciogLnVjX6lMOEwOJkWYYMQK9HQ02TbJJC
 3FgG3UhlKPaC3WaVymdDnSuUqsq0Xu0+p3ymA2qhmsWNPox0E5UyEGZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 2A0F81C0011
X-Stat-Signature: hqdhx9hfcf14me467iuedoxzjgti6g3f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775563494-735112
X-HE-Meta: U2FsdGVkX19j2jlP/mm526IOltk/WtVqg9QYR8DtPvlm7c7dbGj9h1kKwR/wNUbJiVkixzeXcHk+38zHe/zKGDHrD1QB6xWcE3qluQnbP6mAExx11V6/LpHKT5BRn0ZPe/URT+auvzO1rkVIpgW0De+gqOv4PCzyvAjCRS4XQHBnaLvpvi2HxhFK/P4kBsj71JXyRugUptUO7CwXcjj9G/pWVn01MkqbvBs2GJ+Uy9v1+GFxmDlNMmy3WIJk3K8GtnE7qZmNDI23W77Ikd8hDt0oDTWbq5OhvKFM8xKc3Jy7QKVyhCau5zJqroThuT73hslbuR9a76N17FAYi8CKvzqyQY1Qqm+Bo+opMJeRP+TMA0QmXHb/0ZXdyIZcFkdMsUzxZpcrr3p25A9j/JRpjIjziC1TE9R+A7TwKhTzg6ZVy39d8QOOIUxXfeFB9I4WTAUs1XVAX/v1x0UkHFtyTlG+/BZx0esF4HN+3brlhQE96jq86j04sfyzV4dcjmqmj155tFmF34IWcJW5rOeF02H+4y1Xx3cSZaf0GFLFvXCWvIOqLYk9XDojH9WOjlVkid4aRJm6yYo5Uy2X5l6T8rKVKrZ/t5JQEMplBWuT/aHxlHP1KMxrD/8eHGXRWbCdr8++qoYqNbTQeUaZ2XQ736vNUtG9/SSsAbFE/vJXiT/3fixG0Me0ZoxpoJ9/KWbuogHMIYqfp0b7sJtKOOOUvWZs8zltFEmNnLnmZt6PQ56ra2e9veGYTXYtl+r4DVLvohrQhhI1UHgNV0jcLkIYm96guskOWks0eW/ENk2COtDgyXb+leyF+8Z6U4SPGJfQHhJPl5IcxD5oOyhQHawyz6IK0ppZBfjwTpzR5y3bX9q7bRrBQHMMXL+br7gxfziuJrDQQXSnqeK9grG9cVDxkopt5gPyGIIxQl8L/2WpxkBfGJWbhGEbqQZnj+GUrzc+Sfj14P5GYA7GUzpUSvD
 omb0upgk
 8PKd/BJ1BBsdat7hpnld65qUO6qLENhF9oqaqRd1Up+EIp0OKl+MQaEpwOP+0BktZYucFFRb3m2v/2LzJKpmQwcNVVwPpbatahS3e/ONEXSO93Gnzz2Wcx5SE9KaOkaiR9zlOgGY08mHAf52UGcCo5aDkOR97EIjzS2G7M5xBl3mIK3e5sNGj0BfNj6xKnub8AxX/kDFdhbjFYa5N6+jY9NhN+6c4ORSstRxdMpkXQ4S2RjYZIl1nMmxxBSeWaV21OXSLhDBRkjCkGwo6rFn/PQdrqzrMsIyMnu2CS5M08B4ihPDgr/73O8Ql7LT+0zCK4HfSxQtwNN5yJnpKL5iHw5m/YQa1+RR2gBxvRobb4sPizeZDQQAOSsuX0tPaxucXdKml2elAHqla9o8exsvRady+OT4WcvsOq0B5uMtJT6yzW/CTHFG7X7nUt7JDfap+Tri9uvPu52/U5aaB3WIud7wPyL8pzKe2D7lZv3YGBrRAzbeAdt8WDSy4OeT5wW4alh4JmLv0LXhOroNSOJkgRq3pYVMQhcTiUqk53YfG7vogBFw=
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d3fd5bb56cce..c673830f4ba8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5003,7 +5003,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.53.0



