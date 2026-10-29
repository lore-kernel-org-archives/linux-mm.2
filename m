Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88F1606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OlQzv0eW
Received: by kanga.kvack.org (Postfix)
	id A6E496B05B4; Thu, 29 Oct 2026 15:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DB86B05B5; Thu, 29 Oct 2026 15:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AC76B05B6; Thu, 29 Oct 2026 15:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55C436B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:45:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94F2CC04E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:59 +0000 (UTC)
X-FDA: 85376691918.27.E1F33D6
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEDC41C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OlQzv0eW;
	spf=pass (imf20.hostedemail.com: domain of 3OKLjagYKCGkRbUPfbNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--kuniyu.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3OKLjagYKCGkRbUPfbNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303097;
	b=1qgrQozkn9D5lmczscYh+XCIqASKWTATgwPh2M60Gqh1Sj9J1rP262pz1ZR115PX2wmf1R
	4nBpo6RYQD7tZJhLaKeaV16niHwriThzct9swwiyONei6d4NAWxnL9RZJw+wHevkVM8LXD
	wL8V1JYph8RM2rLFyjCD1d1au46CKk0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OlQzv0eW;
	spf=pass (imf20.hostedemail.com: domain of 3OKLjagYKCGkRbUPfbNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--kuniyu.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3OKLjagYKCGkRbUPfbNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
	b=Hg9SNZnCrZ40CRFkHb0Sc0lbJT+72+FWjmUqkX2lLIGKbQ2kjG6dlpfuBUNU+0Q+AXK44s
	hZGuQu7zkVKoIcFeqd+2eNxNpg3rqsdE0F82GIlwo+PTUei8g69083vvKzbfPuVKVDRIXc
	U96Ow5t2UJyweQDnXZxnExD2X7OIS4k=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a06bc723b1so3080343b3a.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303097; x=1793907897; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
        b=OlQzv0eWu1yIA9QdVaVI/kEjCrqtNuxilPFaxq3Zb9EnvYezsUHeXPHhEmTpsulueK
         ckRu2QMWI4YenXioZNtO4ng3aHiFjC42wm96CEddpqBLaNR+Uwbb0jTOGMciVAWYT9dS
         bq57FQtOa3HAO5fvzJstgttSIaQ3n29NUSufggzTrJSWgGB5Lgr3n/6eVbPh6M2162zb
         lqJGXnrUPypBW0/loYdHXw0jvs/qV0YRQfriFTnQjtvCMpgzp9BjYtdyUvc2Rs7MaQm2
         wPX1+2HU4DnvsCygxVF81ieYWl4Yud44lRwf7iz0XvwMF+ImITfX7cam906xjQ24W35/
         Ttew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303097; x=1793907897;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
        b=UhK71GNO7/EBGKSPpsG3Y1fWqH/40s9H/ueUU/bauvW28a28H2eKf+FSQMHpRSME/i
         wdp5uzNk53QfIgASlcn5q9M0UmV5tV3GHCS7dFrpOgrNRQrsqDx0vS3DMxzSacqGX/vI
         N1VaWNy0tw+jLhKZXl7hrq3wsmpHF18fwkynLTOvrRSTBcKGA14cRnPtMVuCiLtG8ICl
         keqrLM7imgyh731TrgloLl558xSd+nh/1HLT47fmi4u57xti2CBeCRAt69SDRzdVrghn
         X/Py1KE1HyukZn0g/S1bkn5pg4u6f1KQb+rkDLB2OuGaorVX/FSQ9FkhXUfkTfpUVnO1
         566g==
X-Forwarded-Encrypted: i=1; AKwUvBx5DmB+Ur6BsvFfinFXC7BGvIxXR/m99qfHn4IYUDxrd+wVkkULxsMIjMoojW55jg59lzqhg0kRBg==@kvack.org
X-Gm-Message-State: AFq9FYJcibOIVh9e4L3TFzXNB2mkSTRxCuZezno9OBvDSguURO7wI2jo
	CdQ/Rw7T41pgu5j66dQHHy4rtUukE7X2IZ6YipgPdz+hM14KgE4YyaEV/+i2hveNmJ8gZfS4ECh
	b5SReHg==
X-Received: from pfbic1.prod.google.com ([2002:a05:6a00:8a01:b0:887:137f:baf8])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ad0:b0:878:34d7:6a30
 with SMTP id d2e1a72fcca58-8a9bcd05c51mr141067b3a.36.1793303096363; Thu, 29
 Oct 2026 12:44:56 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:14 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-4-kuniyu@google.com>
Subject: [PATCH v3 3/4] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kjz9co7k5trik5keogbosq53nhca9xm9
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DEDC41C0009
X-Rspam-User: 
X-HE-Tag: 1793303097-670404
X-HE-Meta: U2FsdGVkX18SLE2PTHVFbUvfZoZwRHlPFGYX6eDs0yzWUDaImN9dPx9XNXDs570vfeM/CjOemOgQmDv6zLaS8ZtJDAfPbWkCRzTP9AeatBuLz7aFF94hWiv97w4cLLpB88RieUQ7pp+Ocbl+eQegVZoNSKEtNGyN71MX/WATU/zTjZ4GA4Wfkfnj8kCypbI4X8rsO2skFde2QX80Yizbpn8hgItg6UFn+vtSmW05Mk+c3T9ErkqpOLJV/KaY+JFJ9iuKXgRSN9GQBjlAi6YvFB0+D1dHBvfrK5NoQYUu04pgDmrzlKRVTamVeLQClbE7gV28CtyK6vfM+0V+quVsFt5sPyAfejHxNxq2DK8YOA6tMx0YmEdJHK18UcJ5Vnyl7StPTMox4WlZONFbcW8yuxuhRl2WUHUWMPSyEdnoXMiTtfS+UDzkV1mdMxpFfqTGp1sBFyHHNwWDTGyYolnoOTWKOctxlPoL5f4R9Z6yGDO3aZ+pi7Hkr/GQGDfAb4BVHLc/uqUnd2nJYfljU8NDRyZWLTNrZb0x/QY2IADSCbcjEOcVXCaEN7bbm5rtwddro/GOsZH2DGvtpJ9z4+MFUGfmo1oRgXs7G0TUBUvhciL5prIswvskHG3hXO44YqSPH+2D8PNGrSuD+ppFqPJhlRGvrAsCUwdVEewSdDz5cfRSLAAh5/NVv7Pw1ZfhBVsrQ9kthwOrB7uJXOmot4xq9uIuOZpKb9mySAq3Oa4u6tURGw8+0gS1YYm68qbiw1qFFOqn/QwcltBvG48tVnPBmbDV9C52lvUOd5N5MOMinfHySW8rsNqaCUeEOhRZlxI2FJ32wOVSJEIA8RAwtxWCx1QLrj47LCLo48TVIS4NbVaqcuh+cKBnFfSrAQLkE4UEyx2u7MB2XDXGw1Sxy8k2gs7B6/mx0y726GBe28Kmt9OZLs3PsIa0FGEaIQqilXOQi7gH5DqRTkMVc7YX8FT
 +LAUmrmd
 SUTEwN/pC+hpa5JGWHpmEUPoNmIy5fzjihW0nZ6QAqNYbyoCxZtbHMq8rfQ6RyczWSJR7UxZ+SgTOgsCM/ozfgXGhLRixOePO9484vBQ9kR+ssvQJCVIPBbC5rhmUEU8VtQudkD4qsGAgq/63+KxYvObW8ogGqcynJTyfdOH9Q6LwezyXGYi+wTUzFsT8m1tOhX+2TNWIwVJtxSnuxC0c5+rQaNh/hxrldDAApLGy97vAzHGlAlh187sOqA8SHAcUye7Ned0YGsrBycf43BtoCGkah0oIEKmMOydlKFovRmA5z8m3rPnAiaioeGetQ1AmZA0x6j5qN2+CkG/b+tvk/3W2RJxaJChkK3AvS+yK6Ut+Pd3d4ITCtWlnSWveLbTRaXZXPXsS4gJxnB1GfJYEOwCKytIIaZnrLeRCpoSCtnwYll0DG2wz6HYkHeeajeYN5fdE9o2QgKEkpi6C1b8yV8Zu0K+JFkG1/nV8DednJ9napaviEIbqmqkRYYFsQpODIYnr7yRb/4nD/EIx/707lgtg/9REfmkU1V/AL4U+oWqWRyDi3j+acD2maLuEwHEO1zKaOODnt/PxxqEMwj8lfDEmG6ouCVuycqBoF0lcPgsAZrK2If0XZO9QMjm6F7XY9uTO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
consume_stock() (!stock_pages) or trimming a slot in refill_stock()
(stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages)
are all slow paths.

Without unlikely() annotations (when building without FDO, or
when an FDO profile does not cover a caller), Clang 23 treats
these branches as likely and inlines css_put() in consume_stock()
and memcg_uncharge() in refill_stock() right into the middle of
the hot path.

Consequently, the fast path has to jump over the inlined slow
path and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
   7ab8: 01 c6                   addl    %eax, %esi
  if (stock_pages > MEMCG_STOCK_HIGH) {
   7aba: 83 fe 41                cmpl    $0x41, %esi
   7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
   7abf: 41 89 f7                movl    %esi, %r15d
   7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
   7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
   7acd: 4c 89 fe                movq    %r15, %rsi
   7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
   7ad5: be 20 00 00 00          movl    $0x20, %esi
   7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
  local_unlock(&memcg_stock.lock);
   7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
   7b7c: 01 c6                   addl    %eax, %esi
  if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
   7b7e: 83 fe 41                cmpl    $0x41, %esi
   7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
  local_unlock(&memcg_stock.lock);
   7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   7b97: 5b                      popq    %rbx
   7b98: 41 5e                   popq    %r14
   7b9a: 41 5f                   popq    %r15
   7b9c: 5d                      popq    %rbp
   7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
   7ba3: 83 c6 e0                addl    $-0x20, %esi
   7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
   7bab: be 20 00 00 00          movl    $0x20, %esi
   7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v3: Mention Clang 23 and restore asm output
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6666acc9cee8..a04b44656b38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2157,8 +2157,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2168,12 +2168,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2273,8 +2273,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2293,7 +2293,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (stock_pages > MEMCG_STOCK_HIGH) {
+		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
 			memcg_uncharge(memcg,
 				       stock_pages - MEMCG_STOCK_LOW);
 			stock_pages = MEMCG_STOCK_LOW;
-- 
2.56.0.317.g454f8302e1-goog


