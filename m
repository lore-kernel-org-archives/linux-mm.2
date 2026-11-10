Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE6460A260F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1olGJcW
Received: by kanga.kvack.org (Postfix)
	id 2DC566B05C5; Tue, 10 Nov 2026 15:21:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3F76B05C6; Tue, 10 Nov 2026 15:21:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F08F6B05C7; Tue, 10 Nov 2026 15:21:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04BA76B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95F11140991
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:39 +0000 (UTC)
X-FDA: 85420329918.24.C511D1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E43761C000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1olGJcW;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342098;
	b=WZ8qadZA1y4gtg9nUfwhX4xmi0+9CHFZvi1zc6Dk8UP44Ff5apACwqcBltyqAq7uXWSLva
	1XAMipuTJwF3ltmozX4VEv1FLaJ34PipLPciELqhxBaBT0n2SUd6T+2haMyjN23nOUIEsS
	rwLybxeZuZGCQ31StgeaWRb6liWNO+I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1olGJcW;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpSsC6eHA17zXSkm9xogF1qAqxxkKO+eDjMPRSKEUa8=;
	b=7p5ScrnC9DDkSkiQ727AaXQfvMuAS6tw155nqfoIqAMWo3fskJW4ai81drS25mVw9AdOjt
	d7X6+Z2YZCucbZDlrBPh7avjID7h2G0TDUtFwj6icKTBFYvpl2vB5dCJRliOJfSNWFtN+7
	uhMrErkUXk6phi1Y3zR7IkHTOxGQo0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73182601DF;
	Tue, 10 Nov 2026 20:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740101F008A1;
	Tue, 10 Nov 2026 20:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342097;
	bh=vpSsC6eHA17zXSkm9xogF1qAqxxkKO+eDjMPRSKEUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1olGJcWb+1DuQiRIqlvQtmiFzXY8mMkYsK+/jgjpcG8q6M+7TH8tH6eOsb8r5reg
	 rZY80I2i3xENqep5AjQtcGiUB8SkMAR6xTvZRI1clyWM8QnkXCKe2v1AUuWLdWhrCK
	 hUhymLkVLquKL1tTW11hEim8Rgeh/AmAxSzMjGMv+2IjO9Lx6AVXMljKCxqr8Qh97D
	 ujXZsfzWsQ8oD8270gCI5aWFfXLKMy8OSsr5cPUv41l5eN50RKaLNK4oWlOPMnVTpa
	 yixl7sdn5p50BC/bgEnyp0OMwD2v/fNk2B2YSX38yfcAAIJ1uugSnCdPfgpE//uvOO
	 nk8QH7W6wyEZQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v6 12/15] mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Wed, 11 Nov 2026 04:20:22 +0800
Message-Id: <20261110202025.25736-13-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uobpj7dw34k67r7ihdeasjydg35h3ad
X-Rspamd-Queue-Id: E43761C000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342097-135925
X-HE-Meta: U2FsdGVkX1/2KK/veOls7RbDMcT5gTohTRMMl6a9Qg6ec3HU2o/C6R+orjlDUloPNxN/qSBVOfYRO8Sdbw7ch3YvTnRCIQd2WJHrZLcvRuZLPt2XlaIQJv5yBbllZuZuDPklieUSaCPY7hT4pInznI065C7O9ZsQ8bkrr2DnvZRp5zDn+EU+lFtZXWaQDLshyOb+YC81wBdCZ7nCIcS6qqa/UbUX2n72x+oIY9H7Agr5ceDm959zju9RaZr5vJEtTzj/mE/HTDh0xmiRUv8fYHz/kVcgbxnQhXwrdggGjg8F+YPivVZiHxtIJq9S+IcbTMQS7TIJvT9+xCGVzjc+DgxliSk7+Rnf+QNUgu4T+dsMwzBoVcQZokVXMnNSZoTcf7jdrjwc7tnBts2VOd8k4/rctCBH7kjszCLw1xLaDwYMxIidtblLLIJLdAuDHZuKaZ1aLhp9YfxPbCBT//B3yBg7nyS4Riu3I/FyDmRbx4bjdN9BICoXK9UMoe3DoAK+ryfj9uIrBfIDdCpzUBO16AU1sJJATq9QyYyliZKg+GTJZW/Z9wxMTOlWccCHVZP+qj5+eoyWheoSTJL7DuGLubPLtcMvCIuiOnAEiv1Xg/27ZpHj8jjRwQe2r/aS3lKM3d1g4C8Bhq/BsSqDLE5Li6WdX/Gde2Mxzik74ntzgMu/139saYKrwd5p6Qge+0BgPMaqe3kwxVbfLQqNyb2E6ezMYGa30FzECzazODwXf8powz/ImVdbE40XOKOLhvRAZJ57QRrJJsd8kqsQVx96EDvTrhm+ip17C10FfYlzh7x/xjMaVnF1drFrSEYYSAW8iNcJ69KjOVe0MILRIiVDzMNngLvQ86JK1k1uWfz7au4bZpmhZAMu2Wsd5t4v9S1e8zigv6HQt560jx7Vcw0Ktm1rMJXE3QKZHVQVghM45szO5M2vnBUHzou+dRd6WSAEjUy3a5i3/+cBa9B8cHh
 4Cm26yxG
 itwM4zkY/S1/krjC4y+rJJgJOl+FELIwALFbCqeBH+AC2CEF0tQjmSlF4sdYJTR9bThV9Zd22ejXI7AQEplCsE5w/UA6ytkmUAIVQ3F0wUkQ923pXZqSIAK4r6kRJm5h35cBFDldbH84Kv+byq2hkvdlqekbzitjPiq7xzx7IonGI43tUmm8A7xY95FZxznPDmbyS8xwEjMWeIhlLRwCUOIHcwrqXMXyCtcUVj03MUj93qhJLYhbzPwPNeoDqAEeq9qxtFbUnbUaK9qKpFqXoI1ucoPZEge0Wl6r6Thk/5nG8KKcd1s+R4ZbpT5roatxDEl8foLoKhsfzv2zT6K6I3tv5pUxTd/4vuMHP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bfc9789a999a..34faabe617ae 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3911,7 +3911,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.34.1


