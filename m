Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B32AE937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D09B6B00A1; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5C46B00A0; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BDC6B00A1; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 365146B00A1
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAC4513C0E4
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
X-FDA: 84650486928.27.6B3F8A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18A94100002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NEVK8l/Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Kz5pzTI/QRKx+s0sELYLEXSg5i3WmbnohwFefcqfsg=;
	b=SUhxGVErYcvnTRlAjkFfUFTrsbSXuGOYAOtovWEAHWhbUwNRRMrinVZmSi9dBaoObwaBAY
	MN1AJA59wmuGfcV+alPPCO+4AiOmZat1kY5YBvsBAN4wv3r1CEl9UrT25PsWyD1G3tSdC9
	JxpgeaiClmkfNsXLBIjFhi7zP95mu20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012503; a=rsa-sha256;
	cv=none;
	b=pXJCMW9vNu/7SHj0kSKnmNmnzcZfaOn4yQbdw0YKxhREFl6SUd+0uPfyKcYsrcr5ANEFTI
	s+zLr3SjIHjpE8ZbfAr5n2OjVKqfSorC4aBE6T8CvdBHumP/nNliIAiDUE4Us2G65BtRhq
	tghnMa3950xfkk7Ty50KXjKGf36EN38=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NEVK8l/Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9DCF6184C;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81EABC4AF15;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=oHmrzr8wi9GlAl3Ja/rW+v7cpNZs1wYuqzM8tpEID4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NEVK8l/Qx22tpE9XikCL2DPAKPXH00I4F4+Uhl2PwvIYTsKMWGFMGmUBl/pJHmTO3
	 ixh/1M3+GSOvJaCUkzZrrfzygArhoiNtQYwP5IGjTuaeS3n+bYJWvHIVHf1Q2KdbLt
	 X1+414y5LFwca2itL3JxkidXnpbUfsgGoIUKOWS1AIOAQx8IFAgcOGWXnZZpdUrBSA
	 s2vg7Q5YEgaOUHfAiY6+i8qpwDy6hrXmKFpk7JTEiOfxwWKm7rTJk/N+M8xvDShPe0
	 XPDCRPaN4aDDjPxOscCRlZjUTboTn8JOp3nRJs6OEc5oMC1dUi4f76Z4NXgiq3QbJq
	 owh3cjGyHT6iw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76261E937F2;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:27 +0800
Subject: [PATCH v5 13/14] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-13-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=1037;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4jCESMjGGJsoUesOniTyg/KeGpgULItGaxuoRO86zSM=;
 b=o5S6aT951G1YUPUxSOT4cQ/sdMDzmFkFRmZZqWI/D6b9o0qILFMa3J4GCiB8cgvvpt536euSX
 zngfkM+CCCoCveBBR8zPIuXZfqeJdPa63Rv7f466qplLtUbaNobVEXl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 18A94100002
X-Stat-Signature: 8h5my7gna4qbgnbmqhmdiezznnre11sy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776012502-755263
X-HE-Meta: U2FsdGVkX18454Krq60i+o6TDHrLggpINNL7IK2DiaSeEw/J8E4Lu2tRuGaU35Q6bA4JCTdy/Nl1qIcpZXn1CcmLJBxYeTTSuR151NMSisaS7FDt7KPsFnc1VzBQJ49bhRayPD5JHAz3MVo92D38YjRKwQUlbzBukhqGCrQ8T6jB/M3hPBiI9r4ee5+o5LHttqnVXb47puzOjawWOtWuHrezcXfdzbPpMK+hjkO7mCpDJatOeFjhhJQk3yF5X6uM0+4qGeYRQ7i6aclmix1d74kXZnTrFwSHn+hNcb4DzjlS4uYxtsrfHC1tKy/UOWeAzZU6b7scWhSBhKSocv9vY8HYeW3x1nh9yh1Cj1j79jUqXwMrOaHQlnEpH3Y/35Czd5+2X9CdOOThHrdLQBPFfL5nqzqxWJBD0J6cZ6mwS42G4MNzigkviQtHYS+3MyWrST4MPYsF34PtVZNJOZ3DhILbwd6oH+OdPTBZ3bQ36+BByeXO4lp/8am2n/Bo0nqG3VoFP3oggcGsmD/OGxDVG8vJLYupko3t1r85Dpk4sNj9pM/8AYlnpILP73uaYji2T02YqX10agMJrKGfuJhCm15O5mEnbYw0yx8IeOUePdHLzqDKe4pIbHhw6fFUHk8gouK5q+UppRiBvAa/B/+f6ByBXZvm9AfunIBfz7Ys2Ckg/okQgfcYphWy4bvCIk6Wk+EIWUa+/OGDMGSFOkbsOuVNMSq1aHGedoSlyMrNxJX9rrPMe3HlejWggUxRQkmEYQKnZjKqsvBCWRX3ACiz0VHQuR0IhxJSV+ZbO/MbGBh32yBs/voW5U8nLlrCk52Hql+S+GOX3LRq82uhcy3TB+8cgY29wv7o8rcShRgzjg9m4aiVZEPDdjUA6WdhoE3zWj8QhgOWBE1nVAFl61TfBZa2MQZfUDrl5DBGicIdY5pH6tzo65s1QovHEFlkl/fbAp82nukiZFdS5JBvybx
 Z1XoV4+u
 tAmgfQ9Vqsqw4UAEw0FOBV35ZfAJq0XpqDfpcusJmLXqWfW8+UoxGxYysed6Zc/4EGhXCHvL3GEN+2O0AiWlCnXKeTBfKPq1RH72X9Ir31436g5eHLeOHrji/7o3gokC3sj/9W4crYo4i3yTvVAnaZVXbHrXv5wwdjdp+frJNGk3SEMO+fIqYm6KFjKbcewvBu4Mpz7TNU/2b/R9zyeMTM6bbFbi3c5vy+5K2odNnzJtG5YNKJM0pZatgdnWmbMDi/L8OZCQhkfVvDI97Hjx0cM9tJrgHeoxyHA4lf2JKRfdKmQDFERyllhILsvA1WTti+9+1+MNeyM21ssnjfW04Z3VJzntJvQGzdNJRY8YLSWLoWUdGF+gIRyT8CBItPzQ0ycSrb0y70N9nQhqOtMZ8zDupfSm0OlZRU4iadvwiONC/gQRQ8Gl7S5HPagrJ9YCgcSMEfeoSEDhPzOEZXCZlBcgsVnZGqND+jo0v0OMS8htnWy9KwM6IUPfJTfrZ4kzQIHIDWj4V83gs4UE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b0b66c03d4dc..a431f94ff3a3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;

-- 
2.53.0



