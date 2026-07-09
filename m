Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4849BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4A76B0093; Thu,  9 Jul 2026 03:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BFB6B0095; Thu,  9 Jul 2026 03:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B4E6B0096; Thu,  9 Jul 2026 03:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E93F6B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:23:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B7EF14040C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:23:22 +0000 (UTC)
X-FDA: 84968397444.17.28842DA
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC39F80004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:23:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jryRixbA;
	spf=pass (imf30.hostedemail.com: domain of 3Z0xPagoKCJYH8270H3O226EE6B4.2ECB8DKN-CCAL02A.EH6@flex--richardycc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Z0xPagoKCJYH8270H3O226EE6B4.2ECB8DKN-CCAL02A.EH6@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783581800;
	b=rFxM9jxjYItArIIm0A/vy0/STFGPEj4yjE7KZdiOqOczexfd12qdHCgd/SXdinRjIqcKTf
	Xi2Ojc+S/5Mu1AMJIm0BBTkSaevSlkjO4Pki+EZEt9tcvxDNhTiWRkZoGG9234hnlCxvdq
	u8lESD9rt2FLW9INgYtbUmWJRbzV7vI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jryRixbA;
	spf=pass (imf30.hostedemail.com: domain of 3Z0xPagoKCJYH8270H3O226EE6B4.2ECB8DKN-CCAL02A.EH6@flex--richardycc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Z0xPagoKCJYH8270H3O226EE6B4.2ECB8DKN-CCAL02A.EH6@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783581800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TSgsShlAlS/YHIH2eE10SQokZv8lmk2KYUHn6cAnAI=;
	b=79ZarlmC+kybUISV2Wzg8JQTxKtHLw0I8sdx1O0Q+foRjBPl0dGGYOBwyZqdbN3V+g6yjX
	PgGzMjiqG8aIpboqFFoURvAXdQ0Wg8g6jDRtIKSLNe28XImMPNctngTBtUgcJCPdtLm76S
	h749lnlD6MpY8jGhd25Ev2h5cO7/D1k=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8484ba00601so1203997b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783581800; x=1784186600; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1TSgsShlAlS/YHIH2eE10SQokZv8lmk2KYUHn6cAnAI=;
        b=jryRixbA3MNQBdPQa/21WE46vxKXYuqNBGB6d711f6XIMgfIWaqTiJlLw84UkMql31
         RBp9Is9JTEe9D8XGSsq7XVvDcc3LHRdqnLRFKEbC8m1kZu7qoUuCpbYhSO4VKXKWfq7C
         B2ahHDQXvrESC6/NJ67xH5F3Z4JP2Sv8IYeRyepkJrDWC54bTRrZ19spmp645+HZQKCy
         0LVw1ci6ZDCwFEOrAiYK5Wrx9BhuQakGXLnXUjtIXK+6etzjJFugCysLmkS3LjeReZOU
         vnepQL+tI3GLC/77nA5ObDBwOZ4cIUtCyaSsMFb7gHetxpyYijpYlRsw4pFQALCypYmS
         SJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783581800; x=1784186600;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1TSgsShlAlS/YHIH2eE10SQokZv8lmk2KYUHn6cAnAI=;
        b=dZlO916MqyKCyPtO9KynOwh25OYCD1/1C07ITDZsz8r9sXlAggoEKcenyaiytdSrum
         yaX/XtNZ/ozbHacT1G+0DDPehCVet+uNfhfuMn5cxfq23ls5aKiIUMsIaTJzCSrKv3G8
         aI4NmnaiVugA+T4qf8p992GsitZBlrJRbaFk+RvqMVPUkXXtDWMnCmJvRcCaQ2gUTg7h
         OvFj1sKSx5DGtIj+1mABI8KXCvQbghHZhAFfRzI7CL3nkDq43XbSMd/XLgk80WLvFUjj
         qM+bXr22YDJ24BRahS0eZIXchRFOzmIB2RX0BQ4PBrPp9pEb054MPfIN72Ate3h0hSPt
         IkUA==
X-Forwarded-Encrypted: i=1; AHgh+RodVCAjWzHYMeKAzvqDSUkVO7jRJob7QghY+cABj4i/dkvDIfbAzLolZHNeTeyw6eZNjRfuLVmN6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy3YlcaCtxWtTieeYqrZTcgzp65dAceuhmTkAdGR5CDKcvC852S
	QBSM6GED85FiQ35TMTrokOPYSaDlpivZTNohhS+Xw8MCL0Uk/4wnY9oD2mqT1lNq8YoJYB+iYc3
	omSHakEe57Pc2n7vJgl3V
X-Received: from pfblj3.prod.google.com ([2002:a05:6a00:71c3:b0:848:50ed:208e])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:748a:b0:848:469d:b7b2 with SMTP id d2e1a72fcca58-848469dbc0dmr4324674b3a.77.1783581799210;
 Thu, 09 Jul 2026 00:23:19 -0700 (PDT)
Date: Thu,  9 Jul 2026 07:22:31 +0000
In-Reply-To: <ak5-qwmpXrYi5md6@linux.dev>
Mime-Version: 1.0
References: <ak5-qwmpXrYi5md6@linux.dev>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260709072231.3163082-1-richardycc@google.com>
Subject: [PATCH v2] mm: vmscan: abort proactive reclaim early when freezing
 for suspend
From: Richard Chang <richardycc@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC39F80004
X-Stat-Signature: 3xjhy9jpz8sz663qz67fp381r5nr3bmq
X-HE-Tag: 1783581800-63109
X-HE-Meta: U2FsdGVkX18Qf8Ax2jP4glDvDItgHeHNbyUbQQgcpt6ausNFyHe0az5Zct54t/BetqlS1MZh4CKRi97pUbf3gjX56kf24saiN8u242koUDilIJzsKImXeFjxkauvrHNvAnZTRlr1GHesYdJ754Y8N0W3rBzD6M0BQ+BuJ9vNhsHMVNNE8aaysDbqhtrs37V8uEeSOEWFbTKZdWwIcey0s1AiPPk4tI7LcbVTRsZGtB1wJzHPxvpI9RJRcmm2jwOtEM68vp+DPdSdgXKfldDxPwKsIfo6GORueTUl9o60vcMSjM772SUm2s2b3aWoe9b0K8WTe7oMqFjG04222uir8Pd98fJeYF9Pi4h1XbwWaf8P6gjFN1u00EBA9qcS9Aktn345l9ys4Qe5IT2OVTlX/2qxko0Aj0GtPjOuucy3IR/wP2s6pTtdlZ3+BZ3tsCK8Xk/6uPIeK0NvlEGcBq3sRg4sSbGVwfxMQyCJvEOMhjFARkFeAJJ9cxjNsf4qjeb5WlwxFtgEhHa4NDnLvvtaaI3ITrT764M3ChcGFHG6JxkTl4iDXChekHIabd9flwevdTYgLT4GWUl/JbRY+MNt7vkROBYHAon3IjkrnfI7XDenhbp5B+ggWrxoBz50m+8mtp4Fcw55/9odfdn7M+WDnki+vfWEUXohZVdR9xKfBnppK9DSiV89Id6qW+88K6oY6Uu9nAItmPEl32KpXilGzhpTPexoRNyfDgk3yAf/Fjy0a5QujunRcuLJvj1we67Wesp2lc3O+/PRrcYxApCnUr4oOhesAaLxrCnOy4/5vuoVs8x1AqDR0l7RK9pIHKFWduFkqdxPvmmTDKRxxnqBygVsCCZS29J/nNKzg+vIRVHpfYhq+u1YBSpGfnOv0bAv3ExUX5/kOco5Bs4L2f5lfE+8SKphedc7FjEP081RxgtvHoEEr6Lpk3UHp4zZTtEsjSs2S9tkW1B+fsHqngE
 U7kutvi7
 pteLUVHi7q9cHY20A9IY/5BCZW17+iRK6b9zAIPjqZjEzIWTrSzrYCgcKJoD0INHuKvSlowpQQMixn5uyz1tXVXhFntDXTMlea8o60fSISrLP+BcNCGA7OvZh90NoO9jKwof/6pFGHs1eRtW11zrx3aq8EGOa/JAUGDuivwLIP1TunqUaD1pBi5QP09/VPvqdcSJSUnH2NqSTH+J9wkV/RJdSWIxRrtCt14tP4r98E3Sq4t4XY5Zg8KsxLqf6Nej3tjbiyTck7GuzNk07wzRHHAQ/7DJ8mh5epx1Ayi/5Ok7r0464q+RJFCoLxct/dbTYPQae+vsa1yleMdXLV2xG1WIenrWSj457sB7722gs7R8DA7SERSMxGnQOTVH6GhFmhY1aFc35KPc4KOKqaiIq+q0Ljwkzv2tGDHvNMO7QaGWeap+qZAUDO0piZ2M/ai7mR9deeFOqxPIoHFYne+YnebwavEqykSWraqnqmPiNuON0fu20C5Q/VqkJP/UWR8VALhdbumO3LarAL5nUdhCqtSuPsXmaE3EkqOUAHc8c0TDRqFGlaFFPdxvxxQnuqf9K9alnI7FCb+iQly9GgVuYeQJm4/ss9V2vgJX0Yn9h1vloUtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proactive reclaim (triggered via memory.reclaim or node sysfs)
checks for pending signals in its outer loop in
user_proactive_reclaim(). However, the inner reclaim
loops=E2=80=94specifically scanning cgroups in shrink_many() and
evicting/aging folios in try_to_shrink_lruvec()=E2=80=94can run for a long
time before returning to the outer loop, especially on systems with
many cgroups or large memory sizes.

During system suspend, the PM freezer attempts to freeze all the tasks
by sending signals. Because the inner loops do not check for pending
signals, the proactive reclaim task can remain stuck in kernel space
for seconds, failing to enter the refrigerator in a timely manner. This
leads to suspend failures due to freeze timeouts, a behavior observed
on Android devices.

This latency issue is specific to proactive reclaim because of its
large, user-defined reclaim targets (could be gigabytes). Since commit
287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
proactive reclaim uses larger decaying batch sizes (starting at 1/4
of the remaining target) to maintain throughput. This keeps the task
in the reclaim loop with a large target for a single syscall
invocation. In contrast, reactive reclaim (global/memcg) has small
targets (SWAP_CLUSTER_MAX, typically 32 pages), allowing to yield or
check signals between attempts quickly.

To fix this, add a signal_pending() check to should_abort_scan() for
proactive reclaim paths. Since should_abort_scan() is called within
the inner scanning and eviction loops, this allows proactive reclaim to
abort early and return to the outer loop, ensuring the task can enter
the refrigerator and allow suspend to proceed.

The check is limited to proactive reclaim (sc->proactive) to avoid
affecting reactive reclaim paths, and wrapped in unlikely() as it
is a slow path.

Signed-off-by: Richard Chang <richardycc@google.com>
---
v2: Update the commit message

 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..fb472e924fc7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruvec, =
struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
=20
+	if (unlikely(sc->proactive && signal_pending(current)))
+		return true;
+
 	if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
=20
--=20
2.55.0.795.g602f6c329a-goog


