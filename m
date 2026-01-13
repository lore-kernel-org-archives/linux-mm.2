Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CFCD0C85F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280E26B0092; Tue, 13 Jan 2026 06:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB456B0093; Tue, 13 Jan 2026 06:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022536B0095; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E65BC6B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2438C15DB
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:49 +0000 (UTC)
X-FDA: 84326763738.07.80730D0
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id B539D20004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W+Hs5M5y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304807; a=rsa-sha256;
	cv=none;
	b=mM0HEYmWBeWVYEU+g7GjJoDs6P3afN7JSULD/4/QyNYd8Pu61LbQnvyTTWvZVylo/exq7H
	XY8p1y7c1nKyhMhI0t8WCqAY0oCCKNrzZ+xuKFvNNFO1kxDVAuU1kftJdE7uGsr3UbaplE
	AOXqcIzQa7pCCntb/DDH5rbJ6Yclq7U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W+Hs5M5y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0S/SnAeLJoRLsh1t6R81w3NJ1tQDzEXUcdPd54JMaI=;
	b=DY0x2j7x2BITRwBS7syRaiirLaflasEQPDrFAlbyQTLJy1R8m5nylYAy7xyFqVCbuY37wM
	+7uOOhD84bpTGn9ND1qB4q7giFBjtGiAlnRj0bcLxgsw3pRkkD1OEmFdGKuK1Gslyamwmw
	tXYSj0dc0pWxerU2MsWmaa57VY7CahM=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so71431785e9.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768304806; x=1768909606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0S/SnAeLJoRLsh1t6R81w3NJ1tQDzEXUcdPd54JMaI=;
        b=W+Hs5M5yBABfVrPeeaHZ9JTuNSNQcGc9+myOwbfGHMx2xcHtKYMfYarDSWVrHkLJMW
         NP/dqdVHvmCwuCViRlArtme/RwT8Y9yrRYAnGvYNmqGvJqQvfXwmuLV3aoLNeACDthvS
         aEABB3tAs7thExkvubgVymIeQkyuveqvy49on+r8sdRAtz4py/ZTx6TokWg4I/3/Z0mU
         B/Qpxlk8KJCI4PV5cKzEe0ejo9gemNIVYd7Vhvivsnfsbz/qzcGOscqneD/9W34OKOS9
         AIeojTX96SKWS7/XlGchqHzKlvYZUDsmVhFFHfjy0hRdLFZGwbfISZvTsd14sC56/ssz
         tXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768304806; x=1768909606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0S/SnAeLJoRLsh1t6R81w3NJ1tQDzEXUcdPd54JMaI=;
        b=OUecMrFxTDqnqypMr6vkMIhnf0UbJMZTv14gwctfEzqiWKhdfbbMm9Sh1QL2Eq1h/h
         G98n5QtzuJKKYMYEqcFlzN5gAdLL/MG8J7+LXE0DdUhy+/I5+7dY18VKuZFEDFBchBdI
         IXKDIvHLQnkydj78ZjEgmtTN4Pldxw4tVK0JFnWz6eyxWQWG6Zaj1lyPnFGe9bvotwLH
         sGslk7aiXCVUurd2uzml4CYPmlR59qSfEfj0MEqcYmf0LlMwrJpvqDVqsx6ztbBOvbFB
         kcBxEGVIAARjtozdV1Q02KScRx2fYigD5qFKGzHnckurvBlNX+qZmRCv54IAQuI/8gY8
         dfrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXDQHEWNrNjygLHpYRdUjabIsCsRf/rsjamXxl2TC+6ncLjykGyCn7BHi7ZYIRee+Mb3ID7IRr5g==@kvack.org
X-Gm-Message-State: AOJu0YwpN2CnX5WahFJh6SoexER3haiWoeZCwB1MXVGaKQ5jkpCIL+yD
	5VAEpBBWoW08Zgtg7Ti6l7RSJMt3km6Hx6EVuKDh+0EWWdK8GpVWF688KaavLAxpGlo=
X-Gm-Gg: AY/fxX4Du6zVAVAM6Z7/QEEzXYd9lR3uWjgXmXqhv4uF9H2eXa41mycb8bpA8wEXKdt
	qu/GNd5Myk7sBUVHKKJB780OdiN1zvKKWiKHySq9tvqWbhuK5ctYjLBpDiCe5AgmHRj9TC7QpJi
	9hDW2IQQzXhnkvvJLniJiAf6ssCGR+kt1HVkc5Go9wiodP7g8VnFLoqkJcIb4y4DpfpO/N0bwyd
	yMHGGjZAo67Hr7LnwHItIU6XWlFpicZgJnqyhXkw72MSto1EFx+9ibVamEoDePkzodSn/yPgiui
	n8tM+YrunkphvEb/zvrSwcJgJ2VEwpdGgnjJ0E9lpRS7ruF2PAfGdm+y7hyt3HoId5Nbes77OpV
	t/STshjZ1eaKpcH3shECTvAvRedSlQhOBNjF15oKq8amRCpPS0ezfrRz04Bz7DPGjp2vScjj1tj
	bklMYlhwFVS8R39w==
X-Google-Smtp-Source: AGHT+IFfQ3vfNS1KrR5j/vlrP2qTME5cFlcr9bwTQ2CUBP5eugSGv0mozZL3cEl6WxjgzorKvMpipw==
X-Received: by 2002:a05:600c:8b58:b0:477:89d5:fdac with SMTP id 5b1f17b1804b1-47d84b49d53mr236881675e9.31.1768304806355;
        Tue, 13 Jan 2026 03:46:46 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6953fasm391850225e9.5.2026.01.13.03.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:46:46 -0800 (PST)
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
Subject: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 12:46:30 +0100
Message-ID: <20260113114630.152942-4-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113114630.152942-1-marco.crivellari@suse.com>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sahdd87temja5cizjedfqx81xroqn5cb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B539D20004
X-HE-Tag: 1768304807-177132
X-HE-Meta: U2FsdGVkX1+ZvJo4W6yCSjOhotRD3krGsNcWD/UBHlVquvcBbXKeuyO5YmhSDnEKibh81LTrsO2gCaHoCdFe0QD5wq55MbJxiXd/feYhyfcKBFQvpSetkJCqDfW3lTWIGcGVETmHCudZOGZYhcMIfahfFSq2dYdgB/kJnC0SnaCqJQC5RGNPLKPB36mvl/euopp6iZKcGPD2dSfR0AXG5p7tjKTaX1K8diIMpHwb6NYFsTptlZ6LQUWm68ZM2TtM77IvUT1V2Iyss9R5z6u+kOxWma8sy1UAiH3fzdX41gek4aAFGgsvCQ1XYDnWtBTdh2xwwQxCwtvysbzgYdMLU4z0cV9y5C658eFcFbs+BgjiS2e42Yb8WOsU1Q50Ni9TNWZM/qgTbADsrDErnSUd2Zsad5Mj1qTSVdOpYCYbem0EH500pMdxYGnHPsWVzode5ZMNCtpmZUvM7XJ36gtnHYYtAxHDgytqQV9QU3kV6l7te2vKlYPEkWbS8zgZBa3CdJ6vGvcICWt+Xyam0yfx0YLjxt4uqDNw/AiLkOy4Noe6JazDMuy6QRQlzx1VcBFfwk8Y5TnhFvAaW0oU+maEzTj6S8eocI7JydOUJIvdISkNqIf3IR4O8uqcK2ZjZUlfoqk2biosFC8zY6c5xtd05kNHYcKpkuOxhtLwmHbVT3NebdaSGzkfkgPotu4sGk9aO5O2d1Ga/fPbSmhAmd/jGLXfM+S9QDCkF4RfCRcVow96LujAEUTkT0rY4F8MlyH/fBfH1ql6rEN6FQISwHG7gymhaHzhCe8fefW/rVpb1bMKbmxMBB6H+Tt9b0TPRB3eutlHSgFgvUzQFt9zWZNuWuPH8OeozKs/5S24YjTF+EJJhhIdL8B7yVJm3ssuX+628W4bJJ6vKe+9JhiFFpJvG44Gi6u7gjK/SKNclZYWHnuB7XXEAL5H9V3rMu2fA36lWzET2P7xI6DTf35kFkJ
 xkwZ6PV7
 AEgW0gHaigHgYnnmc+Ikb93r4IWA6okPL41ZaBfgcwx0mMcbVDHrGvSxv8wAmAD4uXm5thcL58gRQvy+0UkwVvXKSI4blkchv7+pDgijwVpZaCkA8vrgcnMOra8zmwpVFL9gIP7q0jM1REyHCxtCLalzOXTDD6uiw9F+hR4biiwrJb80DLClhqyKRZyBD4rcjC8ccNHQMJQoM4AiC1e5riZm63dnmyaB7JZ2otRYWps3NSF8GN1lxzZ7zgO4Zg3HYU77Lrx20nPvatdmKbhQ4z3Gayh/KFIKsaUPQKICZ4Lpg52Ng7egLvdIim1lAB4OYTjS1zrHKjMsejfwlTHZ2Ic98ZLKBYxd+OSuIZmwtKm9opJch+ZZhTVmr51yAGLLL8mq+Gvb+EnTXnlrMwCWvGyCDBgqOsLMGmKRKWNm2CXFqjBbWX5nMCLWWn0sHeo5kPv3xkl6xVR2ZzStjyW3OLYQ+aHZwdlsyQvYEy3/1v4P/ysDsm5oc56FvUVKOtjXzJv92gFBUYFPNAqo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 mm/slub.c        | 4 +++-
 mm/vmstat.c      | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4c6f0b85a24e..861fee5e48b7 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -974,7 +974,7 @@ static int __init cgwb_init(void)
 	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
-	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
+	cgwb_release_wq = alloc_workqueue("cgwb_release", WQ_PERCPU, 1);
 	if (!cgwb_release_wq)
 		return -ENOMEM;
 
diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..bbaa247dce2a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+#ifndef CONFIG_SLUB_TINY
+	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
+				  0);
 	WARN_ON(!flushwq);
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..580b5ad293d6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2274,7 +2274,8 @@ void __init init_mm_internals(void)
 {
 	int ret __maybe_unused;
 
-	mm_percpu_wq = alloc_workqueue("mm_percpu_wq", WQ_MEM_RECLAIM, 0);
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq",
+				       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 #ifdef CONFIG_SMP
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_VMSTAT_DEAD, "mm/vmstat:dead",
-- 
2.52.0


