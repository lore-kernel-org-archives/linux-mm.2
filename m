Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC27606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LdXX69ub
Received: by kanga.kvack.org (Postfix)
	id EA3A66B05B2; Wed, 28 Oct 2026 14:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53A36B05B3; Wed, 28 Oct 2026 14:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF47B6B05B4; Wed, 28 Oct 2026 14:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E4B6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6E1A1401E4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:40 +0000 (UTC)
X-FDA: 85372926240.17.CD93C3A
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 376E5C000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LdXX69ub;
	spf=pass (imf22.hostedemail.com: domain of 3_UPiagYKCGwUeXSieQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3_UPiagYKCGwUeXSieQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
	b=lBl+9A50CPOcu4mdvo5xAcxD8Gjn+vlhB7YWdhoXMuhuLGGu4rlps7Zk1VMB4vO1hpv66D
	xAYTDvjm0Q6OAzocDVNhT7wzViD7LTRV2kY4ScIwEzHhUxATropCDGoR7j3iKWQkTQe/nF
	dLynLqoJUlsMfiGy97AeOyXHngLY1WE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LdXX69ub;
	spf=pass (imf22.hostedemail.com: domain of 3_UPiagYKCGwUeXSieQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3_UPiagYKCGwUeXSieQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213439;
	b=y+c0syjGNug0IODLtEoqW0j6ys/YOQ+Cpu7AAPDdvCZcuWmz0HLSLx+IyxD2W+emucqaNg
	416RmCmu1jKsi/VK6XAn7vY+G8jaeQ4KIq8DBgf1nyEnFDfYKP5X+Wmf7+4glwE+mPuzQl
	mI8nC532TDT6z/uXbAOMFfKd7r0YUoQ=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso1526822a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213438; x=1793818238; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
        b=LdXX69ub0rEh+HWpmM9k0eTfZexR9OUOQvXx+yZ0OekO/S0AJ/7Uo8WvHJtUrklNou
         72d1M17FhtN48vI7o8Cn9zlWpj5L/MH51WHb7x87zXyiYT+1fxwB4/lNwfxOo1XOPq3e
         3301HeJ21lHQ2wKaBD6ZTSvNR0ghBcicFUCNTLUgk5281tyTqFbRJCs1nJsZmE/hAHJr
         p9pE9LXTz99dXkOpg5iwuvMEAGqsq38BSv6GSh5SRRL6aXCFvzLfi90ls+DMALocJYHm
         hF3DoqxhaIzuMoF8F/7s8KGZ3OWHO25H7Hrfpxd8JxIXM3GVLIdFFboOSICxObSNliBo
         Ek8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213438; x=1793818238;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
        b=nDfC9UTnaTlbmuGitXbTdYqGPaZbW+DHjEPSVIYRklhzQs/vWGd/YNWic+kcVcoaw6
         e6Ag9IxhCLlniAKitrY8A00VPR6rS7x/HN+zIPeSUxqdh3m36bX/354+LllGQp21G+eW
         W8n+EVV/y00RieVUGd2ejHNque6YqRpO+nGuD8xWToDht1tIFshgoK3SZiuC6mLIQf6K
         z/J+3W6IgAbltKX6fLiheSMBNnBi6NOu0MuZRWFb1ku8B7tMzzuy7enhQ2VUg14UVSG3
         En9UyHH9LW9SINHlfKpFRhCaw4jySRggrG0ZwJ+axwxgi0BD74rIKvoqc9BKL9Jmrs54
         jDLg==
X-Forwarded-Encrypted: i=1; AKwUvBy06NPBgQmIchLdMsoXiJ+fG4Li77z5ovGxGGj/lM0n8p37+OJo/RBNOu7gR6D0CZ0gqcjhYYIsGw==@kvack.org
X-Gm-Message-State: AFq9FYLwdrngACwJNE+HWtLQ2CXqfTpvjhwSU7ocUaS3dHJRzhkSL3t9
	fiGAco05tq3SSdv+VdOxPUdVE1BfOyDZeedZY2bFMgQD7Onn5fbCVyEAmPKsOZzdnwUz3SOHbOA
	qTI7Asg==
X-Received: from pgbm14-n1.prod.google.com ([2002:a05:6a02:618e:10b0:cd8:b247:590f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9d8f:b0:3d3:aec2:4dcd
 with SMTP id adf61e73a8af0-3e9023310b2mr2741331637.25.1793213437872; Wed, 28
 Oct 2026 11:50:37 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:13 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-2-kuniyu@google.com>
Subject: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 376E5C000A
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rc6qje56169tcbpy1gpbm9uwe5bgue6f
X-HE-Tag: 1793213439-379197
X-HE-Meta: U2FsdGVkX1+DJDkbrI+QrECIC05YHyVTx4YDGN2AurcGerOJpMrvL3xkY15lfLQ1qddlgfVRn+w4GYsKId8fWnEroD075ShG3u28TdPtcJSjmN9bTytWaYdtJsAyv94NtHwRE9KVYGMs/fmGauf45NEBcZ5pz2KafqmxWQzIwnVuOrIAacDlEbHL7yJCr7AHjvNzCOXX+KoPwNjBrkb1uEiHrZi1GtdOObWIGD98l6dr4E+A892gQxdAMwWgAs5QJOHU0hy3FzRhmqocqiUsw99PD5wnG3+c+Fq5K3EmbIylYIbdUxWLhtMk6LeKYIJQ8Q2o5UshrnP6gZvcxA4kGLxZDLgi/sarNlzNJtLDnswQwOR1ej/00dmngLphjvLw9gowzHczxSM9DtAuBABC8HjCTDMbM2H3FvumrMltvIfmtsmR9XhXjKgP04vSOy5zs5N/pMYIhHTy0OZWeJfo6MB+0tOwkvz+7c3PH7dMMbHgfeR3eCcl7CyR6waagzIjNqfirmEoS7k/8W7HTSymomjRhFeoGZh2P283WUWwQXZoWoOEkoC/Sgv7QKmXVGiW7FkWnX6XGjPmCFqtBZVjBTQ+29R/wyrwPK8EBE1JpOZpJzT/WJc3l5xG2yGAEIbSwZ0k2nK6nDNn+duN3gkAhqtTXaDo4gZ7ZZR79T81zNvlb1JBHUBnFnBARFkzQ2pJDYPzCuUN1wK8Equc2FCg2BYX9oDuI2g0oIccGsdiEa8BB9bxceyFgGJ5Ih3Stj+BcUA1aJaRmq40h5zHRyuBA5ha1i0MsrMB4Fn4tnwLmnHlv1/S1TWOYOvAzGmBWwnieau/sYOtg2fj11QFH1OnuLMkXqqR9Aw6jfQ81WI+obhDzmEnkr+SAAzyCoMldRo7b2FzFtyAj8ghJrJqalHysQ/AOknUzFmQqRsU0uDMjk9uMoeG55ss0K7actQKUEvbsFp3uEAdi4YS9VOMI6U
 bD3HaHNB
 dt0oKCoF3uqX3YyI5MBLyrrJHnbO78XqGyz1nWB9ksgSk1vLd61wEYT1g2pprljj83SBvc6GBQFKkvvxyPfpuanp+f3jTnBOXrXYxnTG0cn5AZ6BqAAgdBjg9q44qFMAvNFRmd+W71wKz/f01Eat8yZsShsf9fv2YAs/Z7gzjlttwRXJ5kaJKuAkRix7Cgg+SNg1M1UTPChpZbfJqxlZGrwzYd2814WI8VH49UnYNUYcVHvaEu7FmwjVZ5Qvt38cSOy8vf0nojo8+X1JHoS0a5P1TDya/J9d3Ir9tpXfLsKnT0hYdFW8LszM9WWYaSMDZ74/I9Xde2wRJ+iRJT9Tj/pS3fQths615ebOvlhUNmwW7gcp3ztmhfcRUQvtTkYspfI+7n9/HCIZNXMBKuGYnMdGu3Xsq43NpQmhOQqOxfqRagl1EoTw4rXizQwIq5K4wdK6FS0rZuQ8hDU4xDSF6EcqGeW0HK51GAm5W6Jkmd32oQ4V+SGYhMnWlWZq9k/QUWuGkF15n+L3Fu5pCrIu/ELB0XKE/k00KpKn3KhyGM06v/csxiZeleOVENW/tY1bWFwZ57A7k0rCUiE7CC5y7i1iiCvAMD1vsKkZy5UidBw/mQNfKk61CwXXn92o9i7PSvaNrM5fwFhK57Pgsan47aEODDvUfgVe2FJHk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

this_cpu_ptr(&memcg_stock) is always modified under
local_lock(&memcg_stock.lock).

Unlike is_memcg_drain_needed() under RCU, consume_stock(),
drain_stock(), and refill_stock() do not need READ_ONCE().

Especially, in refill_stock(), READ_ONCE() is used twice for
stock->cached[i], which forces the compiler to emit two volatile
loads from stock->cached[i].

Let's remove the unnecessary READ_ONCE() and eliminate the
redundant loads in refill_stock():

Before:

  cached = READ_ONCE(stock->cached[i]);
   4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
  if (memcg == READ_ONCE(stock->cached[i])) {
   48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
   0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>

After:

  cached = stock->cached[i];
   4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
  if (memcg == stock->cached[i]) {
   4c 39 cb             	cmpq	%r9, %rbx
   0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..8a401550dfaa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2164,10 +2164,10 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	stock = this_cpu_ptr(&memcg_stock);
 
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
+		if (memcg != stock->cached[i])
 			continue;
 
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
+		stock_pages = stock->nr_pages[i];
 		if (stock_pages >= nr_pages) {
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
@@ -2197,13 +2197,13 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_stock(struct memcg_stock_pcp *stock, int i)
 {
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	struct mem_cgroup *old = stock->cached[i];
 	uint8_t stock_pages;
 
 	if (!old)
 		return;
 
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
+	stock_pages = stock->nr_pages[i];
 	if (stock_pages) {
 		memcg_uncharge(old, stock_pages);
 		WRITE_ONCE(stock->nr_pages[i], 0);
@@ -2284,11 +2284,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
+		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+		if (memcg == stock->cached[i]) {
+			stock_pages = stock->nr_pages[i] + nr_pages;
 			if (stock_pages > MEMCG_STOCK_HIGH) {
 				memcg_uncharge(memcg,
 					       stock_pages - MEMCG_STOCK_LOW);
-- 
2.56.0.313.g2479322e68-goog


