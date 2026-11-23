Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FB5606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=F6zmSO74
Received: by kanga.kvack.org (Postfix)
	id 4545D6B05C4; Mon, 23 Nov 2026 08:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3127B6B05C5; Mon, 23 Nov 2026 08:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2017D6B05C6; Mon, 23 Nov 2026 08:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E10486B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72D56C08CC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:09 +0000 (UTC)
X-FDA: 85466522778.04.A908261
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97998120005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=F6zmSO74;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441927;
	b=hx6ymKAoG61N3/mweKJeiGFuZtvPrBszCgGEWqhPTz62Ef64KEE4J5co7I49AQ4glA4f3l
	1ikSBRsNkRXrxGfoZ7TIpjzJXxBEhriOBpsmAq5fHtUyfzb6CbmgMs5itARbasVF0SF8d2
	ggK+So4aRhQfaGO2cihNrWMon+hLt+o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hN4yemycesflqKXqm8D59iST16TmA2LaImFy+AHGkgk=;
	b=bBgsWbqu+yBoK5FO3Onkx15yRP5v3KLTXDtu3DF9VMwNphedMH1EkoYNV0L8g7uvZaMgk8
	HHYp46FRNjGLOKQ9chvvXNsVeavzt1ah/T81ZFCzwazSt6EgNK2yyq8UIj0PInjV4rfSxF
	Ry3H1XHgIVYxFddxEKONKhud1gEIjp0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=F6zmSO74;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so32697895e9.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441926; x=1796046726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hN4yemycesflqKXqm8D59iST16TmA2LaImFy+AHGkgk=;
        b=F6zmSO74tFNCOmbk4AS18lij4QuVDhwiJ5w3hp0sT9PqbsT80CJRGG9UsRp4lKkBHv
         HsoM8KuafKVoPDBo2IBDAJMJnyBx9kLmZK/rZM6d7jomOHxKSN2eW1R+U3m/9Dh9v1iD
         Tp0MPYD5w/v/pHZKu5hOz8GGjnkBUCNUy1bRy/T2XTJbJUbTpSQlTx0LZ0Jr8etS8NIf
         B60Qa2t/2mJDmhyJLtYhCQV2nlILG9yDYBe39BvdjkMVNV9kH8m2Ny4mZsV3+9QmU8ug
         WqBQYdJAx1L9EWDEVL/kGpfIopYFMLp6OtRdA55WuQh/jvzjIdyhyXQCyaia91PABGNC
         kc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441926; x=1796046726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hN4yemycesflqKXqm8D59iST16TmA2LaImFy+AHGkgk=;
        b=b+bEyL3cShd7+FNMeN2LhLCkLiooalXxqPRmOnMfqaK+G8w/25DnKZW+oH/xD40KeD
         Fg1OmQ0/xMj86j4o/08bFmlaTKzqX3TvFVDMBhwY8dwaln0mjHl8OqyzVnLwWKDBD+jj
         bhihupzfjEoDfno0mjxkGh//Yk7H9/pC7/Tp2NVwCAYuW+ckHNHlOvNlwDMpIPyeRSyX
         FKZpMRpoouJQj6o0em5JGjtC69qwmyfo01NakzZzwHULuHjitkWOmPlNuwYiw+W/+kDX
         4nn+NKIR+GrQ8l/DY1x2RxjVDf4rwUTC6wZwR2cbN5Tl5s+XfBHBRWEhZx2Fr/LZjI0r
         xXVg==
X-Forwarded-Encrypted: i=1; AL+hErEbvmuC6JuCf9domEvdAeAbFQjKIvgRiNnun/iOjxxT1ngWzg7EhsCDJEWuB5/c8RSA9qH0eB3vDw==@kvack.org
X-Gm-Message-State: APuU4Z9LpnaTvdLIjIWmJa24tZ9lFCzMpRWYuZpNMVx2NydnqgYjtvMT
	PinYJ7dycsFf5hfnB6RcMCgyF8GpgUCJ4/nZ2IFDIXbi8xa/7t0Oi940fzYTZ/+5NFs=
X-Gm-Gg: AZFdTZfl3PEgSxqDCfYLlRZmlI+5AfI7mWBZBnDPz9UuhbLFwGZ6bP5eIen6izbvMY0
	vX/J6LI4+DKvheh5sl9IIRr6b+9U4TyQvVDQk9BMvvJxKV9u0tIkZiiadyGy5Bb6WeL4M7yEBhK
	Y1djaEKUyLjzJfG1hi0NhKv/hfxaYPjI0FXuUJf7xa7IpGurJCx7MHSaPBSQUDaiIvUaTtChCwf
	MljCBVliWwnuHSzTl05Bub1F3S3hmAsa4k7aXbK2O+3MEqbyhoKRLf8FhNXLtGNywmF+CKPDKzz
	mPIPFfjYcXQDcrhcwJiNMHS2ZYB+EdXX+J96Uns9ga3P3Bgxw/46AaVW13tqiWR81xD9mUjcBgZ
	7lKpeopTbWIPfnKNt6V2miKph29tB1swADmFqsPyCJFZKMcyLBkuGJmDeH5UXugXck5wLnEd7oR
	Lv7roHHqWLTbcmn8xu9HqUgok4cV0ce2khj4LKvynB9H5jcjD156KcYm/aR0Ct3EeYpxaLf7GmB
	rj6F6T70XKEJr2UrGkclUXMNN+//psjDCGg39VaLVIn96FKsF0chO2qiZzl3fmR07fibn8sNmWC
	upa08VwssFuM2MUEAwxamedvRnncZ+Qx312NGqos81tLqDOWAjvfaPQsNGEi4iS2DX9skS6ne3b
	qRsq8OYnlnAyI6cN4EUH43F2/ckIJ+to=
X-Received: by 2002:a05:600c:3b9e:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4bb88820687mr277263185e9.29.1795441926279;
        Mon, 23 Nov 2026 05:52:06 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:06 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v4 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
Date: Mon, 23 Nov 2026 14:51:57 +0100
Message-ID: <20261123135200.4086519-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123135200.4086519-1-max.kellermann@ionos.com>
References: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5pennejh4ha7iqfjor4x14hyziiwttxs
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97998120005
X-HE-Tag: 1795441927-499952
X-HE-Meta: U2FsdGVkX1/oLt6bGz/Yn0TPGCf2vPlrL8lMuvHHPYkSj7qaVQkhutr843ACSTfmSpMOstLlWGctLpifT7wn1gKN0/BHHbXNF+iuAQLixWpiRyEbqZmzLhXxJL7fBH+G7bBmJDFI0uXiurub0u2ZX6eeGUx10m0hU/hjN/YHx3AmqovkMBrlORj4Qm+nxPs3hHmKkdoPptyo3tFnYmz77IDelWePu6NUGRopjIuCvo9b56cSMB7KtWUX3by3Ce3RdlpwUOKlS29BVggJUclBKAW7ucGVZi8eJv4sdDMVX+Amgd2BuWdCnWaBP7zVe+GJ+5VJp5zMT9KYjHw0/Ov7Rqkh6LbnV9+606FJt88r2SImL6/n2PADakCwWOnAq16/8r31OPyGWp7Nwc6AL+hohdumM+6UjV991xKI7Me4gq/a9aqZmmjuf59D+c+OhzPJ3SzMQoa4L4rg08sS8zhDD/5sZf6O834S4r4rX/N5AvDtY6Mq7WWQaM4a5NRQsg9UvuTw+/ijrEXeu3ie8Vzs6keKGdSbrYK4cx1RsA7R7A79zoaYUL9hL/C1RwGXGpu6m/TJdXKplFuTdwvY0LzmEox3aJ713oHto3eTwSQOnn/RBkwuYsqHIc9/X1x+cOXzWcGUqhIa/pXWFGcITR3YVWpaxuH3WfWWzpUAv9q9l/+QggCx8JQ+GA+dn3c6e5ZtjrK377oD4e82MjX5Ufuv3FTK727fQmhCLeBO1jDfuXRQ5j71nFtEE7/UlILm3N/nEoocd+vGCG3tpA8agyOz4NHFPj6NBM1aF9NBlQW3k+rZFQ7HBtQXKssxC+kuXhnpqXQZs2Qof197UXMFwRamRae1oUnyjLXeKJVpX182Ko3E07qhUkMl0haZkBW98Estsp4aTHWNj7pqq5/+vmsSV2VKXxBmbzmkC3smUtZo86oSnuhS3dbB3URmXhNfJwM82RwV6izju/MJERoxYls
 mZzLUti+
 Wk246rXv9c8vdfZvTxQ7LBE8o0mbkROuWUVFfDtwovsbglxy+D7TEsg/4QpEiZZONDaMZV7LjGYjlOC3DCeaGx//kaztpfUDVSxw6fW/p05608FgjlKHkEplkDXg9dRIacWAb7uRqbjemSfmITMz5teT/S3izVCCNF0mVo3mGa0hYQo2XQTEKF8j3zAE0QsEQc2y/SEJWLMisxeNcYVNRlFDdoRoxCgAPAFdJf1SVo8L7oXAP/A5AQjW4DHPqweEYXp/JvUgYz/YYHczyjh9s7GNTdijndStRdfcljzRti13l4UPNBlV2R8u2fUjhr06Hg+HjjoaCpIm6kv0mUZVxvh4E3aN7+cfSzfe65g259estGGnJHj3raV8zkk8yMOxcaypkdjvZ4fIHPok4b4V0SIMTemzL1cS6wpeGkwrKe00EIFfzMZ0vVYt7vBKqqv7z/0pgh4P7YEh5Iw7ARlMr/Ji2fUR2rr4GL0X8btNrgeCaAXXl1SOM7jI390/4KLpnRl7QZNCF4J2zx2eWR23GgTAkxUg/AFlEpewIiiyeEGcVCMzOJo6+LtYVlIeZipRKXQkG6BkNKj6WZtxJkrsuksj9pe9GnnTiO8AKgZ97nhIYT3Xwn6uXH6UBOQTDtbDrFBfb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Preparation for the following patch that adds tail caching.

For simplicity, hlist_nulls_del_init_rcu() is now always used, which
is also valid during rotation, because the entry is immediately
reinserted under `memcg_lru.lock`.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..1d63647e3710 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4429,6 +4429,26 @@ enum {
 	MEMCG_LRU_YOUNG,
 };
 
+static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
+			      struct lru_gen_folio *lrugen,
+			      int gen, int bin)
+{
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
+	lockdep_assert_held(&memcg_lru->lock);
+
+	hlist_nulls_add_tail_rcu(&lrugen->list, head);
+}
+
+static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
+			      struct lru_gen_folio *lrugen,
+			      int gen)
+{
+	lockdep_assert_held(&memcg_lru->lock);
+
+	hlist_nulls_del_init_rcu(&lrugen->list);
+}
+
 static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 {
 	int seg;
@@ -4455,8 +4475,8 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-	hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
+	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4487,7 +4507,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 		lruvec->lrugen.gen = gen;
 
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen, bin);
 		pgdat->memcg_lru.nr_memcgs[gen]++;
 
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
@@ -4510,7 +4530,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
+		lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
-- 
2.53.0


