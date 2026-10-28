Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C56606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H7KAiFG5
Received: by kanga.kvack.org (Postfix)
	id 3E30A6B05B5; Wed, 28 Oct 2026 09:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAB26B05B6; Wed, 28 Oct 2026 09:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9256B05B7; Wed, 28 Oct 2026 09:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00DE46B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:47:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7910080C8F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:47:02 +0000 (UTC)
X-FDA: 85372161084.03.572589B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8AF0120005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:47:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H7KAiFG5;
	spf=pass (imf29.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195220;
	b=UJKVSEUdYgCQlFYG7Og/270W9KUAogd41Ncxafrtsmy9hZ+nkbP7uKZuxucVxuhf63I6AS
	VLXohImApNPIokHGQqFCG7LL1iazYkNztoO1ZrrBsPePOyOmvfc98t1y8W7SfneoPWAy7T
	6pTZfo5uKF3ok7KfdA6e5Txl568FKO0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H7KAiFG5;
	spf=pass (imf29.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyFRVqblmLXE8qjlBr7bz/X+uC/PuqAiTQQAhFFS2yY=;
	b=EtP55ElaN+KKuhgHn4HoenP95uzeK//tEKglhOVNFNFRMBBiMaSHlWTer7sWPOSX7Kv7zN
	NHgYrkMd9DhB8UvxtEMacYv1o2u64nhLX7jaRg7YfZOXznAJlNNKNDu1up0mLa2XqARze5
	mXKMhvfRQ39AlW5udqzV79qmkhfEsB4=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e985106c0cso8322115ad.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195219; x=1793800019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyFRVqblmLXE8qjlBr7bz/X+uC/PuqAiTQQAhFFS2yY=;
        b=H7KAiFG587Oiq4i2hznTcUg2HjX9dgRb8tWagopCP2oe6QdRKfS3gVQP/1nVnSbUjI
         LYZxVcntAZdYbmmGYh8bfyVGPvzEYUdzkehVDoUaT0FXOxg4xJsnQTgWWnonCPYDlnH1
         StxkuRXKqy8XXJXWGFnnDPmzxKzQAt5MQIuwpI+T63IzrdWbRwLa2SrypUYsSeYp2sRR
         UQPykqw9vkmMIYUfnKKwGweUx2FwafO2efWDSt81RWYEZEtnunuUWPh3wn66V4LEtstx
         R+yffhNBJ1gVai2fc/1xl/oiMkcA5Zad+abI7hndmL5VhMePTJpfl3m3V5kL5Ss+QWk0
         YE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195219; x=1793800019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyFRVqblmLXE8qjlBr7bz/X+uC/PuqAiTQQAhFFS2yY=;
        b=KpcAG/vUwk8T05aJ0n3z3LW+HYCB/NDwJfe4sijNPoITiyjLFgtL3LgUfPMvFuAAgv
         KIcZS2j89A0E99a536TERqhD+QBWIScZoiNSEmWcP6yVruSDYMPrzMtUdktV/vOoGLNW
         2T/bMvfZhmGdHU/N32U1cwmBs9gDx+KcVAUBAfmWIOpcRV6m6pIZM8f2CVXjoHNmxVnC
         GGysFQZu+YTDOiKK49bB3i6zemN93s4p+cSmjXJop/f5vC1GyK1H+wWs/QgXn6B+EGOV
         3KGGQBAxV4aNQjxEL5Excnmc28OhrlTz8B+e3Y1BKcOrGgX9IOmXZGDIWwf+VYMJxQSB
         r8qA==
X-Forwarded-Encrypted: i=1; AKwUvBxylvFnTq0nzkrjCBfDLZUpEr+gWCPK13ZRuvS9zj6V6OzZsqajMND6k7gjvMAAJhJQTb9bqu+g8w==@kvack.org
X-Gm-Message-State: AFq9FYIUM2FnNnZXWxUbF5hcsJg42pldVVv8vaasjvoEDtrmQedscsbO
	vnHxoVH7zVZNSq/aNKIHQvWqP3ZgmnYupEv5qN1HUDzw0Nz8WTlQRmFC
X-Gm-Gg: AYBFou11nFSQDreF3xXjMkp+tmmn395qCvR9ti8f0nuUcv+5wIwA0dxEridPamX74uv
	xn99PgUTOob6rc+mnrC+UiC9DrH5TrvcCOQ9ofPqEicICrIq0maQZ2SbykSFCBcVKyy5EX2xi6O
	oHuLLqbBRIBCWJZ033Cg4ZREGT/+BLJex4Kpvzy0hsTjYfPbw0c++BzbEoyfCLpJDaR9dURKEcY
	CZ+oBLh3hye7QKEtXXxkgygb0xvXS/lPQJiLLmT64+hpqHN5Vqf7zPncRwuKn/vZJcdhAX+t8mC
	SrwgWUvJjZw4vZK4JuCTChb70ikx+eUIUQOiNysQzQXyc2sUDY89XG9Pq7oljPbyfyVvOtmsUTZ
	iR/wRu39/9Yrimfc9gzGNqXlReKLfUrjDvs2uZX99qZfB5wyj3kS3Tn1jbKDLH5mOhHFDyC3xqB
	w7N4EHfo+tn+j+dC3vc0jNoQxx1+XI/7LfndCv3WegQ8ilmMpmC533+XCHsFFwd7kTI0h2MF5eR
	cRZpQjnSDSrwXPBTkImNDqoik38tt828Dg3rAZ09EOIvUGA7bi6AoZY4tn51tYn4OMIP9N7fdWF
	FTRIjC3SZFbBeQqPj5tIvYB1gpXasak7mf7vn/t0kTfm4A==
X-Received: by 2002:a17:903:40c6:b0:2d6:e9f3:9305 with SMTP id d9443c01a7336-2eb0012ec15mr23435175ad.5.1793195219458;
        Wed, 28 Oct 2026 06:46:59 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6ca1bb2sm22014585ad.68.2026.10.28.06.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:46:58 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 2/2] mm/slab: don't queue the page cache work under krcp->lock
Date: Wed, 28 Oct 2026 21:46:47 +0800
Message-ID: <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8AF0120005
X-Stat-Signature: n7simpdnzhqfwm56ub1n5dwyxd9w18i3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793195220-253639
X-HE-Meta: U2FsdGVkX19IIwZ39ze56UHJZUkpxDXxh58X2axzsRtEjxfCMNN0zaVWfKL0PuoK6wKq5RtHchScH4WCLquYz6vZQTlkDKg8j5v/jHTzZRnV5M26au/pmhnKsoUXCWbg/e2pwg3RIgFr704+BaSzaDdUOdotrxYOmH+QHNMHjG57NfDTIcxOmZlPPC86vr+fmYUxd6t8i8ipvPy4v79jXplQ4uXuaPA57sGQlpPBRs7VJeHNUkSOnMLbO7U3223ijcCxFyRtFQrrFBvrPf0KxVrvYiWtdqF8rCfop6+xEf7vYz3OZQ7hiD7IA49kPKNStMtyNNfx+s1c0NQLYg8dEzqcCrr+5WYwjTbuvdDhKU4qrcmCihBDBxgffJ9SWqVsAMlb9MWcXyLA33JQGT7O3HPYeK7CSrQyLtbIfjadlw5ETkGm4hE0JVTAU40h5mxPICXTl3Kyk8clb4t7dz1tTESc7uLci+jZAKd6on0NrZDcQR3LsX7tPPMswBdeVEUKEcqOc9/Q0BxKwr39MoId7dJ4r1XLoRl7LkzH+ceY92KdhZV3f9y3sGGxpy7u58oPFzCG1czdws4cAy6CeIsdSsFAjON9CB5u7dbI8KbP+t/2Pt/8az6Huoys4HtNcM3dTpRONnc2OfJOfaLewPIaUn28oma6Z1+K9eojLwbL0tF3Ud7KGMzGRQX30Xh/KAWwdQgD0jUEuqLMcnWHKD4PH/kW6uH+U9jW1n//wy5MjlmTmm7hWQ4sLOsfREvz6dHtViT2zWgEog+CLGFJXllalLpDk+N8y5c4N8pojDyTMwElM7aEjderGD9MWjXK8NbD+4tmnQq1td9JBvYUns4z/x/5XTryopMsUvZI58MCkb4nUIz+/U+AfcRi4YZFh4ou4EguIomZidIzC5kAnGap8QL3xz3AH1p1xixQLsDD4+6ei35wfG72xG3raU+L4JTnJNzfbbQMNMhu1HJhaWy
 8pP9IPRd
 08i18gWyj0l3S7k6g28LERdJeNgb7TiWGbLPJ9jNeoJ/HH6y5DR38cJaIK9k2TqoTODZiOUGunVDNpo+rV0bwggNG1HvyHy1gbmrRysCD2CRwLNLnAcoOZP+C4zS3R2ChPJEYPgsCUA7J0WL8Ep3eQ7OTdHDQG609AWGg5pOWTy6Iu7A791ngUtc9VHCHYvVlo/QpA9YyEAw0Je9QAA5y+8W2IhJ73Mo6DXk3rbTGl29Zd+/gMy+jz4Vjvtf1JoDt10oSBaDDAGjo9VWjGfxtT9NMl/pQuLAa1RjS/OQ3uN2d9U2ch1fZRCAKuAFSpE/8n9VaGbqT/F0W3Ky92o81RE/KlohqM1tdf6n3l9A3yjXa9ptpgV1NpYOMw7OxMvy/4d5tJhRtDrWVO7ahNuEWckdrdHVePF/KfGgL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
callers that may hold more, such as set_cpus_allowed_force() under
pi_lock, so it kicks the refill work from an hrtimer.  Under memory
pressure it instead queues the work with a delay of
rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
queues it at once, taking pool->lock under krcp->lock.

With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
pi_lock after a drop_caches makes lockdep report:

  Chain exists of:
    &pool->lock --> &p->pi_lock --> krc.lock

Use the hrtimer when the delay is 0.

Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 mm/slab_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 3729aa7a6156..ef5ff0a20249 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
 
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
 			!atomic_xchg(&krcp->work_in_progress, 1)) {
-		if (atomic_read(&krcp->backoff_page_cache_fill)) {
+		/*
+		 * A zero delay would queue the work right here, under
+		 * krcp->lock and possibly the caller's pi_lock, so let the
+		 * hrtimer do it.
+		 */
+		if (atomic_read(&krcp->backoff_page_cache_fill) &&
+		    rcu_delay_page_cache_fill_msec) {
 			queue_delayed_work(rcu_reclaim_wq,
 				&krcp->page_cache_work,
 					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
-- 
2.43.0


