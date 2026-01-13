Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2EAD0C857
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3FC6B008A; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9293B6B008C; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762416B0092; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64BF36B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 201E48AF00
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:48 +0000 (UTC)
X-FDA: 84326763696.27.B449AC3
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F537140003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IxbDeUoW;
	spf=pass (imf09.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTBOAHx8kC/AltJ4R9arhM2oz1nWe3b17NlGYVc9Kto=;
	b=fCcde3pcePn3XA9VXmko/HQBTahttvLNV5AOS0GJxzz/2n8h0BvKb7pXcWr1BnyCU+LkvU
	r4JTOoz6gc/p234sc/4f9QbeZH8doip1D+BC9k2x79Melql90AuuNkaOyzKH15qjJou6gD
	yxrrQwFd8MiP40EvV/Wg3lbFMuauqRI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IxbDeUoW;
	spf=pass (imf09.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304806; a=rsa-sha256;
	cv=none;
	b=IoxdFygvFjfX8dlcNU7Rzd/zkt03Ybg8v/FEy9QxDyJ9URMT5AK91pZ1k8ZnjVitDy+4Rn
	wiiUzFXsTLL8M1CAyuXnbABItDFDYQ8yqxofWtq6bLasn/JU11y2g83eF0NXY1/EUBidPa
	0FY3DgOGt5Yuix6r46HEuaSr9NdllmY=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso68240615e9.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768304805; x=1768909605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTBOAHx8kC/AltJ4R9arhM2oz1nWe3b17NlGYVc9Kto=;
        b=IxbDeUoWprMnNCYdT7uqvEuq8deB0gyiCbZPIFnXENeNQ5U+/eBdqfy1zIrhITVaXo
         5/gCZnxP8aErr8t0Ae9PD3HoYQYh1MAO5sNMM8HD8kkDQ06E6o5+zN7HEB5PlIBcGT8D
         4J9sBY+g7JU3SZk0ScnTQazEtR3CwlSZfFBhKQJYuW/6H3HizHjS6lPi7M6sKtk2qMgd
         0A71G7SKkl6VHGrQw/XTI6ugNVyxJtoYvIZDJw1aFcJH1adeQETk5X7nm09uRKgu+T7G
         O0h1On0SQXjy9IJVmaxecK5+SKWe17bojz9fusSdtoLTUaVm5tJWyJED/VX+fOkBgvuQ
         cZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768304805; x=1768909605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BTBOAHx8kC/AltJ4R9arhM2oz1nWe3b17NlGYVc9Kto=;
        b=gitJiJSH4wTyiV8CLevs7gwiYHbtFOdx7EgOj7Thh7w3Qe8FcGTkZ4qCMtNu0YpMaK
         5yq1Inoi3aIoJWMPKbVpztupOODOyn3d+UiGTVUjuVzIN2DxhpJM1xRbO56GhGS0s9Mo
         eMvV00M8/jntT2MyGJEjPVMNqKq3AQqcOLkLD7WDTlWuqsOpObViYpekzC9B39ERjTJZ
         67hwbBFnM0yyTClAWNEZEH7TtkniyLQSatPCo0fOtZxVLgY7Xp6/KrwAU2KAbnvhH4ko
         aXQCV0PAGj+mMiY4OeNhLe59x80vDeBAAoNlIESBzDEcmn4il2bU6k7tciEYLpB7xNAD
         WyxA==
X-Forwarded-Encrypted: i=1; AJvYcCUGpvvf7oLlGng/6YRi+cqBNLysFvZAJDRnpvt2XCc+dWcfNVgY2DN9q+3RlEo572oUZsgnA2MMIg==@kvack.org
X-Gm-Message-State: AOJu0Yxa66CM6+H9wOqNmUZq5nf0u9MipwSqj2CVx2/mEII8Us4f/zh4
	adnoWT284HysgZs/6iFyji2PVK0CovgP9qFDwMwndlH42q9S5T264aRRJSK15BvDXTc=
X-Gm-Gg: AY/fxX42JakSq7oi0Ehxs2/+a60xQkFOXjGc/98Vk5UXxI+d0xx5lNPn0GT4IfElat4
	KxwABYkXkVoeO483ae/sGOAwhrwFn1RgRXT+iyRV9Dh3SmuvuKI06H1U7NcUVJsc8+PdNq4M0/T
	3X3v2nWf77GDmKMt89QLtXSOoididnj/L+wF275aL0IS5wGycCHOOsIYgFrREI7cgcsVAPWzH/m
	3LEmnjuYnmjGuVjUeJ9cF0MAsl8qxSkWBEeHgxAk2sjI1NUd3B5NU513VRS659pwMdI5UiFHhWg
	WjWQrL0ulv0smvrJu/IJP9qkAFRd0IMUYZs8+q1kPMn/pc7hiv98GeR0Co8Il/iEsfOMPLUiOv9
	5AfKOFEE2lt/DmKhqATodTVhSOnz0CIXg5g42NHHaJrM30KQX/dMWgDppC5nf1v2xNBpUjlghcQ
	eLBu9r/VQnq6w74ktoLqoPzNVV
X-Google-Smtp-Source: AGHT+IHrIN7h8sV/YRAvc8mKLxh4bW7VACxa553D0Xs9BN+wwOTnKHRzUIKMY9+nEdhfaWK+hmeA5A==
X-Received: by 2002:a05:600c:470c:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-47d84b0aa1cmr231912065e9.7.1768304804715;
        Tue, 13 Jan 2026 03:46:44 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6953fasm391850225e9.5.2026.01.13.03.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:46:44 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/3] mm: Replace use of system_unbound_wq with system_dfl_wq
Date: Tue, 13 Jan 2026 12:46:28 +0100
Message-ID: <20260113114630.152942-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113114630.152942-1-marco.crivellari@suse.com>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F537140003
X-Stat-Signature: 4b1mtebx8zzosytw3gsn1itoeew1r18b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768304805-996406
X-HE-Meta: U2FsdGVkX1+Lyn/Q5GMtaSgw/5rZ13ifVUWUfsORIgStGpp3H/GUYrNYY7V9zEtMGD7kdB7OBYiwb5Iyf9ZAyQs1CFXXJcWaMmlJklLgL+paH8gEF9PMXGX3yTj2QJnPrWtw2K8QT6TWDBDsq/FD3iI6RQGd2Cyw10uu5EC7N4SsllobbroTqeAwH1a/CauE5TQPh1k2SC7zhjZcluUd//SJ5NP8Gc3I1O3phm8i/raz3uMqUAKbiSKgh8PQO5y37kpUKZ/HTsz7lQ57mk6z+d20koXzCah8GH7tFFn7JQbSPdR9huLod/cOIapaFrjmE5F92ncAUqtNpUbuQtZb4x3m/+Rwcl0qB9XAubP2JJb+sI3auw3cJ1i0szRSrROtkCS25Nc4/rKJSSihqklDNhMSx0iaL9rNwXIiYksS5Mqhm2xfOufgm7qdk0vmO6hLLGtXHikB9ZzxAnshNBWtXB7WKsK8w/qyqyGisi15YaHLMQ2SiaNbRxIFl1rFxzq/j9lfJailkR3j3it3FJ16CFghgmNi0Fvf5w7BTz919K8BbdM3K5AOY1vG+Js0ZhVWxGnSVRUG6mPz4+4GOOomXtU/Z7NjorP16nocnhqGxM4W0BXT+qwNsEqpCGD42Sl7VvZVX+qcHxE/Eshio5mFw/sUSC0X2VkcvVBqGygG+6q2Iqft5Asx13GwjJZN6CQHKaAAyRoSWTyfZ6jkLrWRiPTbzjg5iWztMoOzEMYjJc6yYZNKLQOq0rmLK59aKAfQFI/Ifc83CDKLwBFz7uYAS0xooLbjkzay5Ui+lvVvUPFWbF5mWCZ7hPvympfcQ4MU743S2+vpKwZ7Ym3lZn72Con/m8TaHDMb9OngNENZhhVsg1vPN8x9cx6pXbhY0quoVNwONS2ZQdFdqPbbNjN3rIPi1qwlmr1iz5zHRCT7Y+z39BLDbdzobzjcveXycxfq87luzqgltxxVs5PFIkC
 /uCkpkCz
 gyAiuMN0U3jZde/RVD2ZrkBoBUPt+xpWbgSJM292qde2+qy1iG8BLIzdm+hJl1TSomRIXJaBOWm65HrlGt1VItRrzSragnSeaaoQr5zX24R2O5uj9Z9/HUp/rpUuazqc5V9h5f/TaT8+Ur4FgYieKzDsQjftSHdAJxl6uJVKek2aFnvG/jjT5gy9A9+iImuxDag6OSs0jZY/wHAwtp7ArxK0jI/qUW8vAbg7rdIOdekEmvSvlfmK3OSdatAM1ALv0Is+EpxTgHrDMq2Jbpa6gZTj6eld1xSLXuBuPcBgtv5OY4F8qxldEzO9dOgMOGUIQzgA+Th1kvDLnKjt3DdxyS5vNFpJeAD2D2tmlDc54pS//G+pWxpqn0SGDLfahD/1I5qdIB8o165DLhJmbeF1jZWsMuSe8SIYuswaXdgVCwz+9+ixezq9EwI1Rxv05AVRox/xk5ro3rASekizWyKo68MUwzwJhrkRLKKzpvuBlu5Ga8G0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch continues the effort to refactor workqueue APIs, which has begun
with the changes introducing new workqueues and a new alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior of
workqueues to become unbound by default so that their workload placement is
optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better named
new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 mm/kfence/core.c | 6 +++---
 mm/memcontrol.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c5740c6d37a2..2f65b5416228 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -939,7 +939,7 @@ void wb_memcg_offline(struct mem_cgroup *memcg)
 	memcg_cgwb_list->next = NULL;	/* prevent new wb's */
 	spin_unlock_irq(&cgwb_lock);
 
-	queue_work(system_unbound_wq, &cleanup_offline_cgwbs_work);
+	queue_work(system_dfl_wq, &cleanup_offline_cgwbs_work);
 }
 
 /**
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 577a1699c553..36cc78ede411 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -878,7 +878,7 @@ static void toggle_allocation_gate(struct work_struct *work)
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	queue_delayed_work(system_unbound_wq, &kfence_timer,
+	queue_delayed_work(system_dfl_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
 
@@ -928,7 +928,7 @@ static void kfence_init_enable(void)
 #endif
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
@@ -1024,7 +1024,7 @@ static int kfence_enable_late(void)
 		return kfence_init_late();
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 	pr_info("re-enabled\n");
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..6b69b8ee023b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -644,7 +644,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	__mem_cgroup_flush_stats(root_mem_cgroup, true);
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
+	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
@@ -3872,7 +3872,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		goto offline_kmem;
 
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
-		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
+		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-- 
2.52.0


