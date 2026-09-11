Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055CEC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0369A6B00AB; Fri, 11 Sep 2026 04:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C206B00AC; Fri, 11 Sep 2026 04:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64A16B00AD; Fri, 11 Sep 2026 04:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C50D56B00AB
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42E12C0147
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:50 +0000 (UTC)
X-FDA: 85200737580.12.5C1CF0E
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50F521C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gx060nBe;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x85G6XSZMPbShpb2Stt/88wFe29r9gOddAkxFMBCHY=;
	b=dNZFChTTxc2ezkyzXzhCFhJMQ2P1tyVjsfLLr3TUz20CI/JZPt5CMTVG2B2gxJVvpucDdr
	2z2avi2cheLiXgKc4MvEDyRON1A6nITJpnlpbRr6qNUS+BzsyTw9Aw0igtbFfPRzyyTNm+
	uHzyBhHTRusYYE2FBGnjBhW3SOoxcU4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gx060nBe;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113708;
	b=xgX0yheKTWqp9sThGBHIDCoeArzOdrUu0rheb1mGhdPoc3V33pOPOzZxmSM4zRdAQ8zBY1
	L6esIFpLde8OkpAiPV5frRoVLU3jUEdmVWhz2gfG1jKcbslSEd1XSMd651OW2VAhd0udml
	VOxYsA/myK2W235slMLWZGPkx/JdQWU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fjfBBGmsJJ56y0JVyIG84X0Pp//85lfIIw3IuGHXEuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113707; v=1; x=1789718507;
 b=Gx060nBeVY1D62r9dKfL9BMU0V0CMYMZUncAc5m9CHjz1sagu5U9bVjq0u4T/tawn1Ndmgg9
 ivKZt4cQZfl9dWtxUnSIuOKYRDbJ82DnlRm4as2mWvQPHKUtLWUJpL9zgivmT7qmlSZnhjIwFsw
 ZvAUZXRiFoJCWVtWnS6qRafc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 243d01929788e07c;
	Fri, 11 Sep 2026 08:01:46 +0000
X-Mizu-Trace-ID: 243d01929788e07c
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v5 3/4] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Fri, 11 Sep 2026 16:00:50 +0800
Message-ID: <9ffdbdfc96312e3e13cb8f056bfe26649492d949.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 50F521C0007
X-Stat-Signature: n8moottzdnqf8m9u668k6k5c6zdd8org
X-Rspam-User: 
X-HE-Tag: 1789113708-264846
X-HE-Meta: U2FsdGVkX19oyVkQZ2E5/0IsuYsE7H+0aCIY9wAjn4pWJquIJjaUrPj2UnXvtze2TC+KFJgTLJpWnnb60Fu14cdUa1oEZZBSfaDf+A5aEZmCbX0TUdpNWmDmRGA9riQhG8vk0orVU6UK1+i39qJPtL9aWuyY/Qo0VgDg5kxIDZK6UjSZx9mHUydBoZnwgdj45ffKnbA/ul9pp4VjTGSsWVTmO3KITfKBhHLCczY4PuLwgxCJqa8/Ebmk110Kmuv31xx3VPxZbMz5lF9k26OKAhN2h8/gNXF63AFK26V1j2oHFd838ZGMT0qY2uiUBobSsdwbHdS9VyhV4sPdhvtywm6+CDtwcqZCbkXgL6UeMswHSJNwdkqCyaAeUAmpb+hxB7sy4R84+s7D5EhG0O5PoifHTsMLrLNF+fFljmpH5e5DNgGZToSOQ72UVA/SiVrkwE7HuItbLRpxFpZ6TiTER1LPWnHsXU85Yn6cFI1eA5hzhwyX9o89yQppTIn90zcIOBXWVq8xvxGNE0sIBBVGX5t5ybonDR7gG695Bd+6iBh/j6tWYRZA40n6t2cFFfLsJ5ZWGy4resGuAPqvbVLDDmd153eM9H0i0s1Qf3zFKG37mQkA6egCocTwje8anQbeDxBXW0OKJk4NN8x/IiGIBarxytq+lK2UIp/nTOOIMTeNdVaHWxskfQ92esNXo+XJ1ou4A7HW4538s+EWAlKEFWJ5KXvjfiQk6QhZULCyDUTWYrpABeqG3SSG3Pc9Od28vqZTIaA2r1CNHbWHgASdzb3x0bFNL+lsnhCCwLGAW0aGZQm1TniXXZcHQftnU0ZVZlWzDquA6mzP4WhZp4iH8p6EHSO85xGXbmipG20N4fJ3OJjq7on6etKk95ZQFLkYTgb5PaLrdv2UrPZ2B/BPw7PY3icHhdsysQrnJZTCLZUTOj8dEn5RzCGMckvWwKQ5BKqENywsrHr9aaGlXxx
 17OCEBfx
 7xrNJCBUtrEnooXTHsi+BBJ0uQUE1bjCdlBdMExJCAIji0Nyrc8aL8XPCQsnL0ztUYyvzhIeXhfKFkXU89u0KwxdPbYy/ixd1yP2TLmt82bHmLJECQ1/FCOhO3HXvr8RhCbpT2KQ7+C8InGsET0AHX0KVTkosFBq71lMN9NH5r+0lYL1D34PTahs9Q0/lhHQBEaN/YR1g9O0+0pP1xXu6CilFEIV0iWl5ccHdqkGjuzgbTUEFVaeLv2as7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ace9fe2b46084..9995f3d2aae1b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -853,6 +853,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -864,6 +875,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.43.0


