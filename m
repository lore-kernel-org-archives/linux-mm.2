Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7597C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9976B0093; Fri, 17 Jul 2026 14:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D16D6B0095; Fri, 17 Jul 2026 14:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EA86B0096; Fri, 17 Jul 2026 14:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7A406B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:13:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52CA212021C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:13:53 +0000 (UTC)
X-FDA: 84999067146.10.AB4F564
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83970C000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:13:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NjkAxano;
	spf=pass (imf28.hostedemail.com: domain of 33XBaagoKCIIxoingxj4iimuumrk.iusrot03-ssq1giq.uxm@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=33XBaagoKCIIxoingxj4iimuumrk.iusrot03-ssq1giq.uxm@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312031;
	b=gkatGD85Ovmi1HILJiVyhwrZe+kDgyyeaN06H8W+DSOmWFXVH5PdEYveMxYEsWCtUVtY1u
	ZreoEUJX2DXJQIyNNDhT8GRKZf4WDQ4Uan/4KBN6yeE0yIJ7BLLoKsXKCs1A57DrQK30Hp
	38nwOyNzO11CCFzhkntJpg96LHAid/w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NjkAxano;
	spf=pass (imf28.hostedemail.com: domain of 33XBaagoKCIIxoingxj4iimuumrk.iusrot03-ssq1giq.uxm@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=33XBaagoKCIIxoingxj4iimuumrk.iusrot03-ssq1giq.uxm@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzR5yi4vNnqKjqnWTIp3P+wY0LhTYyDpxLzWSmq5mOY=;
	b=z7LYQYxo0QfssPL/6tX2SPx9CNEj584F4Jm75gRqcyTbzZhLXyJ/oJUo/dAfNV73M0ZRi7
	1f23XBayXyKreKnGLd7MkY7a7VZhxlRwgP4UuDSrNnMfucTtt9+6H+pCEZXYdOUM9Jn4aF
	EgWp8XbGlvMxNlCusGkGdjvUKdznlq4=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-cab3e9cd922so3890151a12.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784312030; x=1784916830; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kzR5yi4vNnqKjqnWTIp3P+wY0LhTYyDpxLzWSmq5mOY=;
        b=NjkAxanoYzwCZh/rrujhMP4XLB6u7X1svs3VNqvQ/yJzFOxRMVaKkCaB/oEvyF3FYH
         UWB0fS3lLjyqq3BHWjPHVbKnCu2aXXCMj+5nh1iYsuvPzqLK4w0R/tUY/QF194EHKA/2
         FBAOnCMPxRkjLOmXB7avz2kedkjMbrL3neWcWBitKDYWp6IlSDWN1TtmUugJafh5bGZO
         yC9a9x6CKYsbki42x2Xkz00cwIbVT+cQm7f6GgcC0OPLeYZEn4msvpkjNwq20cti+pGE
         yuA1IQ9FmntJ8bBdT9pkvwrbTCvmsyyrBQKQrg+rIG5TDtiIE1LAB7WiCgBea+I7j5Ix
         mgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784312030; x=1784916830;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kzR5yi4vNnqKjqnWTIp3P+wY0LhTYyDpxLzWSmq5mOY=;
        b=h2MN1KqOV51zatau5WCZtEXLNNvX2LP3s6++j7hxvfXFFvxBerFdVdFBX+5awH57Vp
         iNy7N2DdbYZO3sf7lLXUEcT3jizUJrLsdB3g92c3ysWO/yBHPDdMqKFWVi6TH6ZYLvNj
         9aVLYXx9Ir8Sw6Us+fnP4uvEItI6onaXTZrPebMTXNzU31AEFWlvfh+TPtgN/f6MWauM
         ekQEPmYTi/tqL+9Vw1nd077z+tTYvzK/ghYswQtme0Dz/IACjoHBaUDPlJ/9jMVVH7mF
         pMKsE1pTd9TyAKiOXC2bYJrLdgYTnHWz+FgcWG9w19zRZcPJteWRqz+T2OtyOAiJ6Ter
         UeyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/J8Cp53mB1evkfEAc299MMa7hXvIVv50K5MFMEraGbLZE1us+xPvGgm58mykbQ2jTrBrhy4GyrA==@kvack.org
X-Gm-Message-State: AOJu0Yw0yl1YyMDuSCL9vQCkdSDlVdNygvq/NGEpe+6ASHk1pN8HHUUG
	71XA7polixtSiRroRk5/LU2N7x+GLBGKVpcak31EUDDY4u9nOG51RRd78bk6DsmrGiCgdA9qiwT
	0jQ5z2ZiDYMHx1jQkBWFH
X-Received: from pglr4.prod.google.com ([2002:a63:5144:0:b0:c85:6deb:ee45])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:141:b0:3bf:7994:ddc6 with SMTP id adf61e73a8af0-3c3ad7a8867mr4405282637.25.1784312029786;
 Fri, 17 Jul 2026 11:13:49 -0700 (PDT)
Date: Fri, 17 Jul 2026 18:12:52 +0000
In-Reply-To: <CALC_0q8ntqjCwC6CBN_0h_z9-_+pDp8-pqQgZ39O2s8ke==9cQ@mail.gmail.com>
Mime-Version: 1.0
References: <CALC_0q8ntqjCwC6CBN_0h_z9-_+pDp8-pqQgZ39O2s8ke==9cQ@mail.gmail.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717181252.2277818-1-richardycc@google.com>
Subject: [PATCH v3] mm: vmscan: abort proactive reclaim early when freezing
 for suspend
From: Richard Chang <richardycc@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Richard Chang <richardycc@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83970C000C
X-Stat-Signature: 54d73uxu9tdh9ghrd15skr5px64m3ycy
X-HE-Tag: 1784312031-700772
X-HE-Meta: U2FsdGVkX18nEGWa5sOctOwjGMbJ2hZ8jqwVhruPSoXr/W1ApoWAgsgCKzRYJgGUTtU7vJ72hhMLcMSpRBbtlxTJoYNTiYqNXgx1nXt90S9tAvvc9kMA3Fs1Q+StPDMOSRAo7ISbGw2G8aVENTPL3mCeFy3YKtbNgjnJ0Bi9ga+nYE40x4UOfwKL450X84kE5h9O+fa004bWEeADmgd1QRYHMhK64uUD0eegags8aU/FV9RMe+VGMI9RQIpNWCx9K1XACUJWjYl48nSGKv/bFkwPtZyyYQGaN/xxwXBflqzS2hhL9l1IYV0gt9eHI/Lru+luKdgrqK+piGKSffqc967GLFB6lOcwA1keHp+TdYFqh4SNtClxJftvZy+S8mxD6y54e/25RD/3IczuJLbsfvYHxKaleItrV94Wrui4nqYXdGqxsaP+6K9IcwrFhKAgeCuXGhgT7D87qmI8z+dhpr0IDWo1zb5i8Nn1grMmkn/bWIs8IITvEfLlS5R3NlZOauriZVilqrjR/966m+XAcbLdPMP6YKKXXtRnHPpcZtMnXMzDnGKy0z0qE1jCHulKChiddM1EZFhhj+4aGUL9OKwJ0CsFTnjT91rQohTxXBxZNiGgqxClBUNmpDay6mLLBYYvatXPwxeH9XZh6Pf4UEqeu2x52rxfOvYZzjZnNQnxy+6It/FkumqNSOeeocVV3YnKjGcMXf6b6oyXfUnzaNCyZs038wFBD06MxDbOT9hJQqZb3lUtHDK9W284yu8wADiUWi+S54M4KcDmtsZ5EkIQHPRNrGfxrR2pEVbhk7TO9eCUGMmD/CfmVhRrMWgyAmkZwbMJTOskQQJU5Puzoop+JJFGujxCmbam6IK6igNBTrEZaQ1SNtIUZEMvAVBeiJ2UPwUJ/dO285oK/YUwfQj+zuDTNgM80lr78BwZz0CMCpcMaoLb0j6nzusKUxtWGDQ9+1veVdvvRfM/xly
 M4N54UA6
 jNus+owJv22YI3AnNUL8pMOTlsQm+zC8QdQ0/y2mavqKvCgU+jL7N7Ozyh/AcfxloXq+HGUgtO6eeqgpag3OY3NCQ9IGnH1LQtBML6TP0BUnQn0Bp1x7ceZhsvnG76VUIq41x+v0ZBcqXAMrzXMfiSDIMr520M7GALIQ81W16tvsH4gzu1jR7GF64pW+2eyqMx+5DE5Eq1ONP9+m0q/+zqZ2rshN07Q06HwtOqmtGGigBriYD6p8rrKN36iX8tksd19P4PDsXHk1Rfmttx5XL0KwcQ2HLhJREhU5dGRrfGnGuvK+P0LUYG8ulFGCVDsF2caVsXPCzQ+XiFUTeWO4v5GmGHdobEBETnvakg3k9jwEXH9bYMayF/lX0kfYgxNMjEy2qeWJdLmz8YC4jXWD4CxVxyIQy3dceuqIGp8EtZU3qbr/flNNv3tMlFgWiqX/Nzo+X0XbF1/jix50ZNLvWL3RCjXxSiUO+6KguNSppJl/ry4ko5NASafUL1Gn4gM+y7NSBpayA796NThVOgdasDI5HyB8lYo24kbi7oxNRdYtbbfVh3ForZo9o7C6fKKS3x03kcN30NMk8JCPnx5TURLMi9uXovrfNcNyTdk8Nmws2ywHZIIoJkdxSZH0Me+S0N2x8Ls3SN4xff9KmYWGUlJYrbDQc+3hz7QvT
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
userspace. If interrupted by an unhandled real signal (e.g. SIGINT),
the kernel signal layer automatically converts -ERESTARTSYS to -EINTR.

This fix specifically targets Multi-Gen LRU (MGLRU). Classic LRU's scan
targets per iteration are strictly bounded by get_scan_count(), which
ensures it returns to the outer loop more frequently.

The check in should_abort_scan() is limited to proactive reclaim
(sc->proactive) to avoid inadvertently affecting reactive reclaim paths,
and is wrapped in unlikely() as it is a slow path.

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Richard Chang <richardycc@google.com>
---
v2: Update the commit message
v3: Return -ERESTARTSYS instead of -EINTR in user_proactive_reclaim

 mm/vmscan.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..0fda811fcb05 100644
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
@@ -7909,8 +7912,14 @@ int user_proactive_reclaim(char *buf,
 		unsigned long batch_size =3D (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
=20
+		/*
+		 * Return -ERESTARTSYS to allow the freezer to interrupt the
+		 * task. The syscall will be transparently restarted upon
+		 * resume. Real signals (e.g. SIGINT) will be automatically
+		 * converted to -EINTR by the signal layer.
+		 */
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
=20
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
--=20
2.55.0.229.g6434b31f56-goog


