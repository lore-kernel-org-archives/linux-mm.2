Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2574EC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 04:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C35A6B0088; Mon, 20 Jul 2026 00:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0747F6B008A; Mon, 20 Jul 2026 00:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F9D6B0093; Mon, 20 Jul 2026 00:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A99EE6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 00:41:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D22F4070A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:41:58 +0000 (UTC)
X-FDA: 85007907516.08.C7A4E95
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE90240003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:41:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=daabBydF;
	spf=pass (imf12.hostedemail.com: domain of 3EqddagoKCDEeVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3EqddagoKCDEeVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784522516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLiAEzbb/58guk3k33Zhp39Nox+evK3TgGMevuJwNcI=;
	b=pTBWJSV90zq7iquIRDgTFSc4dCkpGcL5wDPfqRvBBSCOu6FzpVwgfCHjVNj+cjlx47b94I
	WcM/w27MYBj1FfmsEuTKHm7PGIt/qeaSU5OTZJvPFyR2Cs3ufW7LLR6LYK8QqjwcCOUhBB
	5lteZIQbW+pR0VPhyr7DNqkNLSd/49k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=daabBydF;
	spf=pass (imf12.hostedemail.com: domain of 3EqddagoKCDEeVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3EqddagoKCDEeVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784522516;
	b=ySsMi2uBi7ooY8APtPNX8twlMNW/mBmHQ9CC88UrvSysIIjYpliArBp0VwM4VVgBGtDAbG
	yyA3/0g3Q4vZFyr2mMsrUUAI/n7ecTBvhe9VhV31mQc7imgCB3TMVAVPm1geeqpHSe2Qzz
	V8TPEn+zJjmzxPfpYOVJ/zx5gmQASN0=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so6881912a12.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784522515; x=1785127315; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mLiAEzbb/58guk3k33Zhp39Nox+evK3TgGMevuJwNcI=;
        b=daabBydFWB7vzn8czG+LbWnbb0cu+fwSxky0SGULiy0biuOkfsNLSZwVRWqdh1plVz
         YTsTvdXoHBGR+CeUPDabUQb6iMFlfyHQVLs4PK5X7UI1rv3RHTzpR7Nc2PuekFPfNemK
         2aQZkLdHDGUGWK1TQkO/4gyjaYQUGQ2F88LaFyfHhmqcytKcPshvc+EoFSx2dRUAWXVn
         Dpsg5Gk4zDOGRUyZTtTiyr/oFZTlV4wO0Viqm+idS/0pVDwYb2oQVNfqNqTqdzL9L77I
         DMqoizukszvPAgUdkLXZAVPFgY3HaDjn32lRQWghKEvxB7Pxgiyl9E31VIIO340aUQzK
         RR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784522515; x=1785127315;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mLiAEzbb/58guk3k33Zhp39Nox+evK3TgGMevuJwNcI=;
        b=qqD6c9kKZ3A+ILWSK9KZsCZiw35yjJdlP7kTNmaTot1gKEnvaRPqwHwPh41UMmj5+2
         ws/QGKvuBgJ0JbB96u7hv4Xd9IMh6fssnMAxZl2MtZMS2k14NcRqCoaFeWsG3F1j2c1Z
         YmMIIM7GkRvAsuCgoPcAQ1ddeZiGgpR/NZ/IfOXkt/gFmNIkvpDhRAl/m1GfGkesQd4E
         qIRdxiRvaDb1Hgn91Ao+8LjOeNebnz5/HVqfIBcfTwePSMX/SR7tcbXkqgXszAWXl0Mn
         L22s97bpifjHvilkIOd65IDyue1OGY23Mbv03mX1S0DMkHyiG+R8CReHQS5GS7e+ApEn
         DPow==
X-Forwarded-Encrypted: i=1; AHgh+RqfR53EBRh131mhExYLCd/XDYHWaSb3br4x1zUjCBFRNGPjgejAvjFB6I3SHDw5M5QiHhJQhCzVYw==@kvack.org
X-Gm-Message-State: AOJu0YwLPUgzL8e5M6ltbH/QRq5VL3qYYWWqlH+op8YGnEFsPWKR94Gc
	aOzjLxAlJDFc8rqn+GvTtwLjp38ZY7SGHgL8TjPVuZ4KdM9sgRLuzbMGdms9FGcSrOXo07QHSnY
	CdZIYQID8F0zksZ3YP03g
X-Received: from pggj9.prod.google.com ([2002:a63:cf09:0:b0:ca8:d31f:3177])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:918e:b0:3bf:6c04:a819 with SMTP id adf61e73a8af0-3c3ad9e7e87mr12965689637.58.1784522514920;
 Sun, 19 Jul 2026 21:41:54 -0700 (PDT)
Date: Mon, 20 Jul 2026 04:41:03 +0000
In-Reply-To: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
Mime-Version: 1.0
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720044103.905191-1-richardycc@google.com>
Subject: [PATCH v4] mm: vmscan: abort proactive reclaim early when freezing
 for suspend
From: Richard Chang <richardycc@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Richard Chang <richardycc@google.com>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE90240003
X-Stat-Signature: gb5aetisdkwrk4dw3dtmrnee6ndrb575
X-HE-Tag: 1784522516-297958
X-HE-Meta: U2FsdGVkX1/nIIx0IgvtR3zO5GqMfW6r+/Haf+QK7tt0H21VsIWaI72ruvqteKzAknxMcKpw14PRO46hJPQnOYPO7vS7yVRK2puzT0I97uYxSFZH2qLtVOI7Doyv0GWvRL5nI28WCt7DPZ1CSduYfnOqEiax+jQXsTsU8vGYzNBJM4pLVUSOso+gNRHU03QgxkCIKkcbYHSbPCm/A3VlVFbzzrZiqATLGBGHhtRgda3QOmsDeeeGzuBdg/czSfd5LpdzkACeUXHDQSEnkJjRIj4y4YcGEHFVaWlSfFtrQurnRNuXUbL7X1hhGcAdTFbYzfYlI6xSx/5Xgqp3DULSASFQr7eWT4jVTrfELJGLBvF75jUUL9YVf7WHc0xcOGwlFqWgzh2KqpS7fN7+BEVXfH7IGsEqyHe6TmdrEw8d2Vm9kGC5dW+I9MVHoE0JRtA6C7BzmICCkhzp0qHbaXL+kqQq2s3tfyWiNoAND1ca4U9UhpgiVbiKDUAUiH10wdUspBHcUM8eQqjm0oVlqKWHc6pgAqX3+YL6Z9AY25umthjrtD3B3NkM1rI426IfMknD7UH0WKo4HAMo04+hlcboPnY/nZhc9I5JMUAZZX47R6dyHG1nDGJKCR1mahY7/eoEfGN0NWR8Qw5li7UxzlvVWs59vrQnkhoqXQOi2L9IFjP3qAQ9sqoqwsR+e9SsXZCVuTXR+U1zq1hIIG9DrCW9GjTtmzWNsSJyGoixI8xTmlYABKUN68jKapJZxdvK0K/ox7KX/ErTCz+i4rt5OEw1j3INObU2W6GKKAc6CeFttvKi9DDEK3PuRm6pxtlTxIbFlaB4iMiSE9dxRquIRrTvnbXxoS6S8MfnkNYIVQF45sxXFoMNZk8DRqz9xkj3h+zC7G2KwnM80JaiS3F5G7jMqQzSKZ0a6OyNaKRFfCYQjrksZyO1ANLYG7luzQHQOtBpXGba0kT4KKMKGRxoL2k
 pSgSs1NO
 1xwjxkrI1ktMVBtw6fHwwucQY8TtJ/Bpv3tB3v6czo+2V/U3rXzsNuGIHTZU3PUzz8RfhvSd149772m0Jtn/pCjWFHopRol4HpRB4PRkBTD165pTu9m2kt8cozNdvUnfAthUFwXoDNoLpZF6/33rcRkoRnRf/CnorqMDoJMYCOGAlo/ieYynqmMzXL7wRs4/khXN0YOLYr8iUcQgz0O2H1Iy1/PYcufQwbZKwvrQqhpgjnEzKe+DSAAoLMv/3KhpWvl4f2t+sH2VXycYyJ6LTKZplgVHXmg6VoeLZaEb0vy6+0WsoxAtOx3k5aC2iwUORwudA7lFUy13kF4Z9D75e3ElIg2uW40rr4CikFiIUQ1JitIlQarOfohIKZ243dfyLKRd/oNZEFM0r4y9jDR2vC8ZnGHD/DyURGuKAIAjIEvfOGhSkmFXY62nMzXxfc7AzL/L/ypqHCwvqQbp4+z1LK7AjgKFs/D64EWr6DaxVeFMksDTidrmbdTChJrb2taVc8fsIGrrLKzRRvlAyZJpriX5xtBdT63WkONuadsK7k7KVBUKGTc2aILgvEs17aGyaID5TrIpgB0zKzLXOIqk8VzcTUSZ6eRv0N5Itog/uS2vPKUlZztEwcgcqMH9qNrWWd5TC9P2yiI93oxwevb/cKnGDcTa5A4ZUzq3pZK/nPO0jycfsAntO6QbP69N/uDoSUSbT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proactive reclaim (triggered via memory.reclaim or node sysfs) checks
for pending signals in its outer loop in user_proactive_reclaim().
However, the inner reclaim loops=E2=80=94specifically scanning cgroups in
shrink_many() and evicting/aging folios in try_to_shrink_lruvec()=E2=80=94c=
an
run for a long time before returning to the outer loop, especially on
systems with many cgroups or large memory sizes.

During system suspend, the PM freezer attempts to freeze all tasks by
sending fake signals (setting TIF_SIGPENDING). Because the inner loops
do not check for pending signals, the proactive reclaim task can remain
stuck in kernel space for seconds, failing to enter the refrigerator in
a timely manner. This leads to suspend failures due to freeze timeouts,
a behavior observed on Android devices.

This latency issue is specific to proactive reclaim because of its
large, user-defined reclaim targets (could be gigabytes). Since commit
287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
proactive reclaim uses larger decaying batch sizes (starting at 1/4 of
the remaining target) to maintain throughput. This keeps the task in
the inner reclaim loop for extended periods. In contrast, reactive
reclaim (global/memcg) uses small targets (SWAP_CLUSTER_MAX, typically
32 pages), allowing it to return to the outer loop and check signals
frequently.

To fix this, add a signal_pending() check to should_abort_scan() for
proactive reclaim paths. Since should_abort_scan() is called within
the inner scanning and eviction loops, this allows proactive reclaim to
abort early and return to the outer loop in user_proactive_reclaim().

Additionally, return -ERESTARTSYS instead of -EINTR in
user_proactive_reclaim(). When interrupted by system suspend, returning
-ERESTARTSYS allows the task to enter the refrigerator and automatically
restart the syscall upon resume, making the freezer transparent to
userspace. For real signals, the signal layer will either restart the
syscall (if SA_RESTART is set) or return -EINTR to userspace.

This fix specifically targets Multi-Gen LRU (MGLRU). Classic LRU's scan
targets per iteration are strictly bounded by get_scan_count(), which
ensures it returns to the outer loop more frequently.

The check in should_abort_scan() is limited to proactive reclaim
(sc->proactive) to avoid inadvertently affecting reactive reclaim paths,
and is wrapped in unlikely() as it is a slow path.

Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Richard Chang <richardycc@google.com>
---
v2: Update the commit message
v3: Return -ERESTARTSYS instead of -EINTR in user_proactive_reclaim
v4: Clarify -ERESTARTSYS vs SA_RESTART behavior

 mm/vmscan.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..5aa4becacb7f 100644
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
@@ -7909,8 +7912,15 @@ int user_proactive_reclaim(char *buf,
 		unsigned long batch_size =3D (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
=20
+		/*
+		 * Return -ERESTARTSYS to allow the freezer to interrupt the
+		 * task. The syscall will be transparently restarted upon
+		 * resume. For real signals, it either restarts the syscall
+		 * (if SA_RESTART is set) or is converted to -EINTR by the
+		 * signal layer.
+		 */
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
=20
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
--=20
2.55.0.229.g6434b31f56-goog


