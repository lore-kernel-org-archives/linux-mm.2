Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C481099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 03:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4C26B009F; Fri, 20 Mar 2026 23:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85976B00A0; Fri, 20 Mar 2026 23:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9ABA6B00A1; Fri, 20 Mar 2026 23:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C81EF6B009F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 23:35:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 685F858C02
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:35:21 +0000 (UTC)
X-FDA: 84568654842.30.4A24686
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id BFF7F14000E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:35:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vk5LwKOV;
	spf=pass (imf23.hostedemail.com: domain of 39hG-aQgKCGcGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=39hG-aQgKCGcGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774064119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoMBtlhfnp9XRcs7RdoT2ynBQbMVoKkeC7D17jrPW5U=;
	b=eyGRglRLkP3WrgXfmRztNWflbNK9ZW5wnTXmh7dUA+EegjQwkp02mIQXYrGDFBLAumcKat
	jEeLoDRTEAkWPszCsj6/pw8oOdscbVIFt9sVQoGCleX8Xi0pzGhRlccRHlggjFEu2Ubnjb
	Kv3xqLb25LLSK3ZvdKQRFjBBMgj9NGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774064119; a=rsa-sha256;
	cv=none;
	b=y9N2cqjLbEgOwYa4/LpymLMDJUt/JqdeilVpzlS7h5eGrlefVWTCCCHnHffkuIjRTv+f9Q
	mDJLnb6bEHUjInJGfoius1NavjIxylznli4W4zL6sXOMwKYI/weuGCs9fNkdkSIR/aCVrI
	MRJHzEeFSgEJPlx7G3Y7qOadTnQQNyE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vk5LwKOV;
	spf=pass (imf23.hostedemail.com: domain of 39hG-aQgKCGcGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=39hG-aQgKCGcGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12a77b008deso14507754c88.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774064118; x=1774668918; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AoMBtlhfnp9XRcs7RdoT2ynBQbMVoKkeC7D17jrPW5U=;
        b=vk5LwKOVj8qU2f7J92hGHx3hG4ZE3tCTrolQLs5yS6BUT93tVL/oxW0fDDGxjxlVlZ
         nBmJyqskN+NF5VduDAZ7MK7rzhhcEKC8CrQLdT92wvoloeeCStvrIaUExQWZOrgmthni
         f4Ednm1EiEIaAbjdhckKGw4GsVzOO/Tt8W0D/bS3IRf3w9vnJJ2thfQtW7VkYeW11CKl
         EioVxC5i64nmREs60IhNVsr9JwE87BB6Am/xgLfndiTgxiwiYIaEdqgyn1VZsV9BvJvh
         6XDSbDun5hBQNSX4/ZVlt+2cBg3OxfiMKIKanCvKCjzCI4a1R1IQev2ClboV0Cy227Nc
         1etw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774064118; x=1774668918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AoMBtlhfnp9XRcs7RdoT2ynBQbMVoKkeC7D17jrPW5U=;
        b=VnXd2+2Gmebal3HCX6qciFD9Uxk13/r+e4unFaaDEPcYtBHTbSctHhhcTNiIHDMhkW
         6nbOsjWlKD5lIijlaw4AmCVzc3S3ok30hmbsB0Z+zB5ATFaY+OVrCj2ilTRdT1AEoTiW
         6EsZ7tBHEx+Cad5+yLZtK4nvPQU3jzQQYN+7k2ig4YotcdlLcUKQGTJdjFrttaYNkPtR
         YOgPi5SNXUjpeH3L0cDpDl+M6DNovuCdrkgsJYAK+RHiqh6b5cLoX469Cq4yknUPsbCv
         6308xM52mLczwQhihYj1CLKsxq0TjFvtp4QoJzCno59XgYACM32hQVb7zQzuMaVZQRNB
         LDJw==
X-Forwarded-Encrypted: i=1; AJvYcCULEVEuDD1hKTeq0CfLfj+4kpalQJjlsxQ51fPTQ/H7oWMtiFmTp3KlapeFUnZEtIIsZfED9pjAyw==@kvack.org
X-Gm-Message-State: AOJu0YxF1nh4V9CIIomEZD5EAbTSQmHOMAblA/KQzNPSF+6dwN/XjpDl
	czq8IO9H7S9a8KoPubdZrLbuqmnNayAUIAS9yp9pwrtjp+vUSs+6EaAGfPst1hqP5sot1wVP0qN
	hMfcZpiL+lxDmJg==
X-Received: from dlak23.prod.google.com ([2002:a05:701b:2917:b0:128:d29c:ddaa])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2525:b0:128:cedb:33c6 with SMTP id a92af1059eb24-12a7266088amr3054155c88.16.1774064118178;
 Fri, 20 Mar 2026 20:35:18 -0700 (PDT)
Date: Sat, 21 Mar 2026 03:34:13 +0000
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260318221957.2979346-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260321033500.2558070-1-bingjiao@google.com>
Subject: [PATCH v4] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	rientjes@google.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, zhengqi.arch@bytedance.com, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wjaurofc8srj9ea4yao63kjqts5tybbk
X-Rspam-User: 
X-Rspamd-Queue-Id: BFF7F14000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1774064119-351507
X-HE-Meta: U2FsdGVkX1/nfC11qfU/pGMKcIdvaSByxGj4ohxE6RuIIiGXEuM5/AmU7nHbdXmAj8dY8y5xNb+QOw3N552x7Z1XezT6CaJb1nonCo2t9RBmj6wMIDaHbu8z+y0PPCPEyd97PRJrOI3tnQF+Nw1/Si4N8WHcPh6/i70VOSR/LBjZAdRes3RztYYWQXvpO8GxoUjP0tN7V+6ppqVeTWMCzMbOGa9TqRNb8Be753OzW8FT9P+ZZCG5ZcfmU6/KENLW5QUQxEp731foiucdaKn7cw4zds5Aly1wnL7TpcAMvE6iGGlEf81+HqmQ8XgbKjPhJGMnBnIVu4MAVSOVQaZKuygODmlTVYSsplhaqTMU1R4sZOFmMw+wFBtp4PHdx1qRfdf3gKlj8e4n/1Hi12eIhleuqHRoWGNBQ76p2gA3rVBdjyLwzGIx2kMGkYyJ0rWEwQzCGSmaw9jPOFV612k9NxHq2yJKYw8iknF2v+xUcgPcY/gAqMGWM9zesyfUEgExdiqdU+BXz2q9BWuwwJb1XGq47FfLUgPVyA6vQK1jBauAiKYJt0HyNEHCuZpOn4kVUwNDFtIX9GNFuwyGr0ehMS458YTukFQlJBYZOXgZbkZuzAFP0jupCiRqBW4P0RqGcjaKU2sdkFFxrxfu0BJG7FhZJ50S+IOFoMP4tsbF0PfugL+eKwb4JoXQIMiCxsVbVgEQxs1qh7R53wRbp6L8Im2rHHCxnBcPXMCX+USFuczf5eSXATAZsMst2CDq+H5LbzA5fQz1Z10Cujx/2HOR+rn02MbAPi9OAeuzDZs/t1SZfNRK1Uvc7+iUzNesknaacrjAxIbxSP5j+CMZvLZiZdIqKy/qAGZsUJrvQbJ0qhvLTDbf3ErICIiRg14yC21ZsNNpM/IEulm//qqzfjKNqO+G/jLzIwIj+ST3WY6u/CjSSIpV02gWfcg4dVzAtQwB3fCSa6zZSUn6Wkx9AJx
 0zKqRuEQ
 t7qiSMBu4a3RhvMgrela6GTlWkXCtEyWSw1T0C1Xnk6uv5zAoOtDFZ5ZF2wNjO/7R6m0Gxl+K6wznSRQSQJa5jjxwAFvR+yB7QI5SQiSGUojWKnxNuZ3QbSBrjp4KeLqbyy+3et3blyEgBB0dlARGfMghrgOVrHKEbBaPKG3SyZTRv0htJyuivGv4o5PBxJaAiQXK1hqwyUIuFsdEnxuapeKGtpfXOElDJYF67AvpGsxCZ0/dFdhJV5wqbkE/hhntydE0KReKYksYoxKWigC2/CPwEWnYs3zr9O6NMj5WtUuMmL077FTpo5mArH+8G5oC38+SDLfvgnAP5AObHFjAzx7ljIStFQ5MMYG4yse2v7VxWGKzN4r0eBFNHr2lbgQIInEZGz/Is+8DiDmqOM5jYhmyfaHJEJ8dYf+bpSe9xfbUUn6QTlA2e3QvHQRxhfCMGJUJ2A+DjC4pRo1xVa1wwsUCGxwUkNW4bEPI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_charge_memcg(), the 'reclaim_options' variable is initialized
once at the start of the function. However, the function contains a
retry loop. If reclaim_options were modified during an iteration
(e.g., by encountering a memsw limit), the modified state would
persist into subsequent retries.

This leads to incorrect reclaim behavior. Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
is reached. After reclaimation attemps, a subsequent retry may
successfully charge memcg->memsw but fail on the memcg->memory charge.
In this case, swapping should be permitted, but the carried-over state
prevents it.

This issue was identified during code reading of try_charge_memcg()
while analyzing memsw limit behavior in tiered-memory systems;
no production failures have been reported yet.

Fix by moving the initialization of 'reclaim_options' inside the
retry loop, ensuring a clean state for every reclaim attempt.

Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
v4:
- Clarify in the commit message that the issue was found via
  code reading (Michal).
- Add ACKs (Michal and Johannes).

 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..303ac622d22d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;

+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
--
2.53.0.959.g497ff81fa9-goog


