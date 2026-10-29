Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDEA2606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IsO8Jxrx
Received: by kanga.kvack.org (Postfix)
	id B57DF6B05B5; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09B56B05B9; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A454F6B05BA; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9246B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8E71160459
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:57 +0000 (UTC)
X-FDA: 85376691834.25.E2CB9C2
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1017540009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IsO8Jxrx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
	b=iGyy40HnamE0l1LU/KSrL0tCkoz2q6Ja2+a1LcZ1b5GTslUx+1iRBMynO8yMIsHZCaUD3F
	CRQIydyGGhxpm3wwNFqCsxRA1Te7mBGFxLsTEoabjcbTsuMgSTt/XGWg/9pyrsTT5zqz/H
	aeMfIL3u2jJWnIf7OB3TEjPMRwlrKZY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IsO8Jxrx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303096;
	b=CoJZDTk11z1HO2BXv9s9biQP/pf3uAs8F2TzFKgb0bn/HYlLTeHBRrcMg9KKplMNh5D2Ux
	cPcqnvx5TEB9gqZEMTlAUHuFh1zQrgAOeBMSVYMtc5GuS3FWkLfN/p64F6JpmfXkXYjxyA
	IUcGuY2g+v89u33X0/qI8Wo+XFVWSZM=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ada8bc8575so4363860a91.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303095; x=1793907895; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
        b=IsO8JxrxNKXP7Y+Zfyh7b6ULMVORJ8c4Ve/Tj2/XwkIGbz4Ywpyla051eJKU7OQ0YS
         gmnvw0vWjz84q2U5uhL1Td0ahGvuxkQ8m+JfMaQNihzVsrNfN3HN6o9tDm4QEPswUI7z
         1Mf52yMTrxuSGnplEFRYtGfauyspbTmv/8BtD1mvWMNR0m802EKMvQF2jUWRVxH8kKz0
         v27vgnh0kmf9VKlX7Jp2TbYgkrbcPfwfrr0viD+gpidR9XwD6+hxzxqF8ylQMfHrCsAm
         KqGEyFqRaBa+SU55IyCMQFK3D1QpA9Sgb4ktgLDh3m+GKpPnb8HeiCuSEjPgf1X5PzwO
         piLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303095; x=1793907895;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
        b=JO4GsfBoH56cbGDEB0YALXWwipc/74OqpgYm4pTpJlKEo9l78z2rKAoV7pMkG6G85M
         26/6Q7Jsaci5emUOFGtmej6Qwax3Whsn8makb2C7ue2SoAqjLYS+7Md7fndQp6Jhs3a+
         arUuOdB6RCS6fzvR95iCQTe1QaPcqZsXZmHRoc9/1CDpWESjgeFn/NVLtBc2yiwmM47/
         1V5wXiP+f2AqSPPDFvgiJ1Vwr3qPWfU5dozO6rczbnlHURnPsorGw1hwWNozlsw2yWXh
         iKa33gG8IFzcGAi69eeFoc4/kHafEqhY1IDM6kFflYRfJQ3/qZLe130mcSLc/eExLZRj
         alVg==
X-Forwarded-Encrypted: i=1; AKwUvBwzBklEU+KqMivLXJzZ7Ydc87x8v300RX/xW2O+Km8/WaWx+RXm/bjL8uOFYgG4IR59Uk4qikrADw==@kvack.org
X-Gm-Message-State: AFq9FYIE3Cw1JcVxAiXR8T7HBGpnMayHbr1lGC7YoESplB/Njlzlk8mM
	Owj/BOvw4lmYpUblkY39aDSDVMHLIASnPfee9xpX1e5kGL8IYEo9H8GAweWppsbOT0OmXvUTCLQ
	vMYDAQA==
X-Received: from pjso24.prod.google.com ([2002:a17:90a:c098:b0:3a8:837d:95c7])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2891:b0:3ab:2c2b:1026
 with SMTP id 98e67ed59e1d1-3ae580a1c9dmr5741824a91.34.1793303094831; Thu, 29
 Oct 2026 12:44:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:12 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-2-kuniyu@google.com>
Subject: [PATCH v3 1/4] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1017540009
X-Stat-Signature: c7e8hayxwhhe4thy4g6hps7m1w84s1g6
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793303095-41884
X-HE-Meta: U2FsdGVkX18NuYzQk6zoDkUJ4vJJ3hADfzNyB7EMyxt78ATrvUnF1zz4wY0Uz/7CLCebmPGtvF7g6NA7wJ/6zGdsPqeWomP/AB47g3333pEBq0U69SW4qbHO7JLxHNYAEo567AhgUCxSP+ghjEjvhIrxPtO6RXwdi35hTYme5vmNCzyvPHlfvw1++OI5qLWr8rtxl+XTuApCOlR0Z0WaJ8XIXTFpEISp3FGNPS1/PV1eT1O/W2Vr2mu2xwhD+cNwB6dURho4LRgaTzJLniswIl3OJDbOPNwAQUK8COecIQtjG1sutg039MgOcvvYs1cYCqXzGQb1SgSb9gdxAGoEcPjTXCkfjjfagXxqbZd+gEUNcq9I409kR0/q7d9k4nHTWrDc6jc0HZc+fMMgD3w+Bi+Csz8pb8ZzWcHnd7k3JuTD3OCBDmnQOjLvTL4N/aAq4RPOPpF27SOyoE7Ahxz6Vick44g39ylGBSsq62B/Ifoatu6mqNRYmcbv+1rqNi07zf1Vl5Brdrp4CjV2vsoQxDJ0XTrGbo98bLmUDfJ5nPfXvppdzpUf7ks+FEhoIma/ISGg5T5usOsZYu/T/eu42GrpYymn3Jo4G5KOgW9dxpCjPqRcVojwmREgP8AFpbQMx911OItOog4KaQZyZdQ3YFF7n83N9xU2yEq5YYMUaqFmktrRW+B+AiF5T3d1LMUecM338TDyiwq/H5BhgBHRGs09gzccRI7CCG2Giskopv/2Aob7yPYl6wlnKfpBE9CJWck3AEmWLeZOC6uxpVlQY4u+2doNaapRJJUTk3tqKBtCfUyh7Q61Uc5NG2+k0t4AvU4cS56Gu6py8oM6pLAl67k12kJgyln850hiDo4QfvRkBSRMfBoMp6kR+Uv+XTWme3WMrHLSCfXbE7nQm9HtxxfJYsgO4Srb3KFSz1MXWeeyNIO3qNTlOCQhIdLYzPHXoF+9LsfSAzUNYtsba9M
 5+ThUN6K
 oo/fnjezJqNnPdxn/PwwyfdR/jSFoduTH66hMb+I3wMulhTdZsQM7xs/N05WOBGetMdpd37TpCMXxbCMnaRAeNK/qbGA99AWLwtCpXewW9tokVtyLMPmd3NMAeMB0MPMdOnzzfH9I+ZvFCaNRAgjDPRVu0aBTqcfD/wluO+pjA1DuoiMXSWBgWR9VZNrbO7H4vLHW7D6adtCwJXXYa9EMOznpt+88c2eSDlO2wJ0MkeC3dWvgzNiWiSiQtZgMfMMx17jSwwn5dfDkgkpE0F85hBAMYs0bCqEnj073JHaPobMrlhFejGdGX4GMzIxVncp87ehLNRlJ8mUWkIzN5rgvbhGkvrizmUlT9D36adc7HD49u3hC+eeUdPTcqVJlrAd+TDesw+HUvAtnxX/XCASQd1ZNCHSLm+Kl8TRKA4NuRaD2eVr405jqdXt1dYXhzOvhUJfaG8qyvdQM7M2TKUQshfB4bWJLMCTdpkKi2G5upi+rSloDJ4ZgYEVH1uNvSNjLogOS7EbXb2ZbXjYYWDQRsUFkFGWB6+5UDk+2cHE7/cnZpILMZ+ll7lyFBtvEu859YS7m+a09gVeCftPzmuWhDXY97vthKw1hBP5HaBxtCQeLcEr/biHyAfLeniY6/3MOSb6N6woLCToSdjiauMJ0mJn/vwLyL0uW7oxp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

this_cpu_ptr(&memcg_stock)->{cached[],nr_pages[]} are always
modified under local_lock(&memcg_stock.lock).

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
v3: Be more specific in sentence 1
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
2.56.0.317.g454f8302e1-goog


