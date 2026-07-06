Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8A1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B1A6B00C8; Mon,  6 Jul 2026 04:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBB96B00C9; Mon,  6 Jul 2026 04:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B38B6B00CB; Mon,  6 Jul 2026 04:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1596B00C8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:12:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C99E2120349
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:12:26 +0000 (UTC)
X-FDA: 84957634692.27.B53C379
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26F0CA000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:12:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I/Wy0pxw";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3Z2NLagoKCLQlcWbUlXsWWaiiafY.Wigfchor-ggepUWe.ila@flex--richardycc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Z2NLagoKCLQlcWbUlXsWWaiiafY.Wigfchor-ggepUWe.ila@flex--richardycc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YTUcwDBT/FSZkcadsKiSFZz3W4ZAzpY+Pf+uj15ZIZg=;
	b=pQ0WM6AHFFVQEy4vKmM+U5xs2NHqR69zvqhoj65YM38bGXRVMB1OdfAxNXw/kNwUbSYzK0
	7jFO7VHVmV9mNRwTx/kXQUYrq49cicpbb8wZavd4Cp0nTNEu65iRjTla2YwZYsdbzNvT6B
	w6wcKNGbrbIP85U/FHWYAsHJrXczgmM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I/Wy0pxw";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3Z2NLagoKCLQlcWbUlXsWWaiiafY.Wigfchor-ggepUWe.ila@flex--richardycc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Z2NLagoKCLQlcWbUlXsWWaiiafY.Wigfchor-ggepUWe.ila@flex--richardycc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325545;
	b=EkjyQmSWIkmJAGFtdqHP9K0C7ylmBh30HLr2txPm19Ch/5D6YoHRdooxEE6SfekLX0BdUS
	4w6+QpEQMPDZ+MqOupERakukypCaB+YRZOV7py4zJVd67CkczCTK9Laky9y8x7G2QNg19O
	w2jJaPiHpbbd4loBoNnAX+sxkOzuNqo=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c894391f000so6923740a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783325544; x=1783930344; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YTUcwDBT/FSZkcadsKiSFZz3W4ZAzpY+Pf+uj15ZIZg=;
        b=I/Wy0pxwMo8KbMlgCx8UQIDTfsRlVVCuk7FXlR8ZUbzAtYvBxftB9nJfoNXHVGtrqy
         5qXqXm5mZLvWWGzCdgL4/x2j/ViINfvyIlzTSdE91yKRC5qSZUpLKmfn5n7EALaNN4wx
         TDqd+l2ROBb06tPYbMyOXVfbL++v2Y1wPobuTRIvnKJoPi259qrhYhpq/UAUzXIfRwVe
         dYTPPi/pgsGxjKYOgSfa5UKOrnrXml9tlSx04U08j9yPPff/32X7b00I4a7x5GzFeouh
         kV/df63MNrEpUOCosolM+MVIhUPHf7dd8Ogknpy4vc5w+hS+a1Co8ynM/g6giOSQsLKS
         a24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783325544; x=1783930344;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTUcwDBT/FSZkcadsKiSFZz3W4ZAzpY+Pf+uj15ZIZg=;
        b=Qg/Wt9yzy5RPz2cblfwoYdEntsNvm1O5NQ4St5zjPJadBA5MeP2P7h629GTU9fM7jC
         e1ezmo3+zVeqDR6tFzfUeW2UP2W19YPh48DBFOprVvtzyz7PsFg3M5YEAQvYFVTuRW/K
         pkzDXB5tpDMAFZsMjXP+c9LTo4sbFG02k5LBu6XTMnDFj7lBYcT8SH2cci19M/RuJljT
         3wMpW79NUqYotrSrHGkxVdGAg3n9apFCceLknUFeRMUuQLOaJ5lsHgtS+y0Tv07kLmca
         wfnkl7WSpmDq7wBSTpqzj4TstDkAaHq23v3bo90cSea7cvSgXW128DjSfoNrEOKRuN1z
         lfvQ==
X-Forwarded-Encrypted: i=1; AHgh+RqweXrw4lYfK8cLcr+RbFQpvpDOieeufORU1xdIxK6EodVHuEUvRvyEnr/FfTX5T5TqKgpzbFif9w==@kvack.org
X-Gm-Message-State: AOJu0YzXHLKhv9+NWBT8ks9pu/VUv8GxbwRg0mEt+ILpIgbb8gqmrWAX
	FxzrA6cgSmbQt2Hsimefc1GQpcuwx8SGpgtP+goRBWblXquGarXt9j76BupT0qhmIX7zRnsYUwx
	YV7OAuBesHNCgO0i/HG9A
X-Received: from pght24.prod.google.com ([2002:a63:eb18:0:b0:c99:aff5:7078])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:32a2:b0:3b3:241f:66c4 with SMTP id adf61e73a8af0-3c03e4512ebmr9943428637.28.1783325543600;
 Mon, 06 Jul 2026 01:12:23 -0700 (PDT)
Date: Mon,  6 Jul 2026 08:12:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706081218.3438762-1-richardycc@google.com>
Subject: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26F0CA000B
X-Stat-Signature: x6kywhnzjstzqr53pphgq8yjwcpzuwka
X-HE-Tag: 1783325545-271567
X-HE-Meta: U2FsdGVkX195gVcWMoPYbcx+c/lJLXnFuv16dOk3UZRiIR2gDvawnuR+J73KyMZvykXPsQUh1d+jJm9xA8bgafVkj+OwF71ktbBCqAlHJs3meZCLlYZ3pu8gcf5i/8n3/vv4P3fea7gN7cJZn8TRchqczY0gPidgkvT3NSYWOO95q/7aJi392e3ogg86wP4/G55k6ycrhQJzd//l1JrghA8fGr5KeeoLuwUBWLXScjOfYBsasC6amNt1wfRyzGAiwXNH9STYx9+oV4/r+y6vmpt6ujdo3UnyfYX1E4PVPgljf9XB1Eaj/jY9TmC3x0ld4IOwAFg83d/L0bD3G53eSGnJOYccwYQowHlj/MFPD1ortwhk7LYrRiHdgEZuF1QyjGrAQ6oXA8+pkwyvAZeKz3aq/8QK2/IaCa4m5oL3bZU7iGDozHTJkJ4tFeHR/TMs9+d0tLZkZQIyDGjMd1VAfop+HGS8DJTLL0qLogmzY7OXU1f2S75Ky4X5HKycD06K9IAEEBss0cnas/vF5Dt/SCy5qjkrJ/7sXRvEWZITevygFOFPc81uY4AlBKWF+eU215aIn3f6t+hjJHlJqaiCV2i20CVPEro3BUWjfcIyH5LLQHrWfigNBrPE5coq1lZrMj0eyxYtjfIYn7tPAFBd8W/3bkMbxeG43tjrJ3Yd3Zwt1b6qUlGa3DM94rfoEXZcaY9FVG7cJafKtSe2UJlcvw0KC1rRDmoW6AycCoUtAfzFU1i/cELWvdJ9w/252fsO4JUNim7ncfARvHUL03y/k0CZjI3R7NKiAJwVZd/Cx/9vMxhLi3WUfbP4olvD420MuS7Y0tWldqfy8I7qkOjf2yGjUcg5crMl3pNamuvlqvrjK+V+NL1EOIho9fdP3FKKI33Afj/D3F3fQPdSWiOpCdAEXKSc0Itm/T+7pOF8Ab5pKxXIJweqRm4/aUdVIxYyX4arBH1RW2LE4NfPI2z
 EXeVUIwM
 QNX1YoEcIzBC9OE1g3TNEa/rhxwybf3LddeEexKq+EUOcy5N01LuSKHVaH5Ka9XfxqqhGUvaS3Nvgt4sbeATsjnN+NYWfby3hIxTfINSPXd41T8JO8AdXufZTuIzLybEjIg4KSdt9MXvuOPN0JS6+8GIgvQ2As/SNTB1h6KgackR0xd3tCI65ERJV+q5L21jeyLfOxHnm2vSuLKtYKfV8V1ncjBNFiAc5rN/eVYL6RdISZPdQearMqIYc0oEi4ddCocCqklmd8oi0g17lc2kpLJeVbkZ09ViZWf3r+PQhc9Jn7JOlJa9CbGrQVEmqbCqB8iljdOzwgrlVQdzMv8Ozyk39NESLVbZIJCzRw9s4ojEr6RkbtBTD6KVa0ITkN7Xsx+NqOm4wTmdyS2y/d9klhH8/5OjmZaspOyZbVXbBpSeifCmvuiqmXvcfYtjgBlJbo8fpJ+LmX8NISSEgE6E4eg0Tv1hXpSqZiQEl9ZM0pXlhdjjC49/DC5KWJLbR/uFTTCsoq3XCj1vhMSCEIYnfUICII6jnhHKJAnlNrInHQo88ZQTMQNgJ5a0yw3VqzFbqsgUMZ9KLEZPdtttVa8xynDx9TtA/j8lB6dO3HAElNXyVwns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proactive reclaim (via memory.reclaim or node reclaim) checks for pending
signals in its outer loop in user_proactive_reclaim(). However, the inner
reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting folios=
 in
try_to_shrink_lruvec() can run for a long time before returning to the
outer loop, especially on systems with many cgroups or large memory sizes.

This latency in responding to signals can block the freezer (both cgroup
freezer and system suspend), leading to freezer timeouts. This issue was
specifically observed on Android when attempting to freeze background
cgroups while proactive reclaim was active.

Add a signal_pending() check to should_abort_scan() for proactive reclaim
paths. Since should_abort_scan() is called within the inner scanning and
eviction loops, this allows proactive reclaim to abort early and return to
the outer loop, ensuring the task can enter the refrigerator in a timely
manner.

This check is limited to proactive reclaim (sc->proactive) to avoid
affecting reactive reclaim paths, and wrapped in unlikely() as it is a
slow path.

Signed-off-by: Richard Chang <richardycc@google.com>
---
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
2.55.0.rc2.803.g1fd1e6609c-goog


