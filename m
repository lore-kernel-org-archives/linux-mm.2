Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5B4CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255E38E000D; Fri,  5 Sep 2025 05:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191EA8E0001; Fri,  5 Sep 2025 05:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7E78E000D; Fri,  5 Sep 2025 05:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB59F8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:03:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A7EF13BD42
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:38 +0000 (UTC)
X-FDA: 83854608516.06.BED8946
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4A5A2000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fr2HPgLr;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYtBCkO9DqKzKcyS43porMi3LTjby1/YOgTfwITaJ5Q=;
	b=yWkS7EiD2NNkuJvk84kuaJpmmf6F/lwxTO9sgnADI+/9t4+7vzZacLAoVbPLGgxZ/7NXNu
	gpWsPnbcLFNJHLn31fMzeOUAJwXmCeFYevw7S1gF3vj0Dm0u1EIffykr2PT0T9odj+U5cG
	Ek+Oesmz+GlfWPexFAI+d4fb9dxaSUc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fr2HPgLr;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063016; a=rsa-sha256;
	cv=none;
	b=fV/kjKFrZHULARGEnnTql0WYciwfHeoijEPkNV4YHM3n9pe9rBLYXwp3izkxrsP3SnN5u7
	AcNp0i+Gm/BcxqBCKD09yygbDD4gElZTpGaRxt06VTL5+vZiucS1CMBOcPwX4+zn5Bk9iM
	nuI00JBI6c+CKMzRh8uqKe2U8I2UDqo=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3cdc54cabb1so742883f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063015; x=1757667815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYtBCkO9DqKzKcyS43porMi3LTjby1/YOgTfwITaJ5Q=;
        b=fr2HPgLrUJb8syJWDK71FBea0jnBbVXl+gSjTKNhCkKuEFI3jwoxl/EN1B6SGF5kIZ
         wHn04jZg+GBEI5RsTbZKXSNsSR3+OsJOJwYrsmJUQpDcgFBU349xYed6jPry9RtRDfyS
         cCs2Q0qGNTkc1mhYOY4Ks10jlTXL6/7cgqml7Xd/xH0i52RcwvHCSwAO/WpZkKmocSFk
         P9N+TiToOYzTa/tWQXbZmzl3weLC2NfNdk6WeSioFRyS4EnDU/6h/dEw9CKhUhfp2F2P
         CxIZHrT5+GHbETMOvbpOBcpVOdBjeFLHDuTAwMWdMPiKxzt0VQaYS5UxZ2iUeq8t5To2
         6rFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063015; x=1757667815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dYtBCkO9DqKzKcyS43porMi3LTjby1/YOgTfwITaJ5Q=;
        b=mSOQgkbDzial2gB7bFZXsF/xrNmvDeZqtSXlFiPcXTnSXg0POQDpZ/TH8qeGpuBeId
         qZT0juGeAHwbvV5nSDR4D4P/D66aWq+QYGnqLKERvfGGsdZXxppJQ25p7pUpefYFGG+K
         V9Eiq63w3HQQ75bui0YHnUMX19414zT89OWYwdUsFwUR07orYv1pJOMhy/BVzEMfxFZH
         XePXRZkDBdXdGGxoTiCIfAbcwuOaesUnGF5zc3wzbo0jLR8VRcGIF5aJWXRfyxTGxAvr
         jSqO3To1rw+fSpeqka2rWOvOpb76VRybTyPURJTJa1+0ArFnG5buPO66AeZ+Ip41iKl7
         zp6w==
X-Forwarded-Encrypted: i=1; AJvYcCUftlYiLCHogPdXTvB/Y7wD2H3fa+OelOpa4fpc8IDFSYGTcY5MqgDAQ8IVrqf3VHbr649m3Yb7iQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5ZHwNRDMzyLyJ/LnM25ltcrFmeAx2J0f3c37LLABTVp6JaNfi
	vCutmq0ZJnWHS+gaIJlRYymLsSaHO+eGdrKQg56Dow4EWgJnnD3WSDrFzUyFm3hHk3s=
X-Gm-Gg: ASbGnctpKpkDYDZdN6r95eGBXG8Z8zHCxXV6VnLDuh/8WRRjcp9hMe2KHMVd7N5n6WL
	lBgcsf+v3XWMhv39iCDwJEOgvQ5DSdIRHxq9bRYQJnRQ4fkTO7JablLrdAdq2Og9k2PNWa7komA
	Oxve2lLk0/tF2AfXxEdc9ovmhUacMaUsSBiSuxabnT56CYmquGYKKiU1ItkZmRZ0MNb/N1Wfgey
	SKkUxbzl1v6mIU1WkVi8WQ03kFG4pHUs2ggp7BGLasRJsh12JJPNRR7AmJTShDHYNy/AiL5ih8M
	mdu0O/12tPlmKh6alDk8FpV6Xg20CXGvzliMqeca5VDuXa6E5UpNLWIoy3NZmOkbs9UJrSS6Bdr
	4AxZko48ACpFYaYx/XwXDfbb6htvEp1dutmCYnefP7IDY6i/Ml9y/mkRi8Q==
X-Google-Smtp-Source: AGHT+IEjaLZymkByczPO22uKZMFn/gyrcDISUwcAhC9QIjk27LsuQ5PsAm7XYe1kQO+OONf4843osQ==
X-Received: by 2002:a05:6000:2586:b0:3cd:c10d:3b6b with SMTP id ffacd0b85a97d-3d1de4b9891mr17256852f8f.27.1757063015005;
        Fri, 05 Sep 2025 02:03:35 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm3614543f8f.62.2025.09.05.02.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:34 -0700 (PDT)
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
Subject: [PATCH 3/3] mm: WQ_PERCPU added to alloc_workqueue users
Date: Fri,  5 Sep 2025 11:03:23 +0200
Message-ID: <20250905090323.103401-4-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090323.103401-1-marco.crivellari@suse.com>
References: <20250905090323.103401-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4A5A2000E
X-Stat-Signature: qw4ego9sgiunp7rdwzksnd55fyffrkgp
X-Rspam-User: 
X-HE-Tag: 1757063016-717823
X-HE-Meta: U2FsdGVkX197OXDNB4yGlZ9X1fwLh5onqE6rIM/E0y48/fe6PyuGeOAHT+K4B6BDnYEMj267lqcjVH9hnPA6lX2xnsBPMcKDUBAcFVt4nQEJBpeCQjna0S1VzdUOsbTy76dsufPVJa8Bp6Z8X1LMYctzOBthJ0u1MO1/AeqRhG6T7ybFDN4KszPQKuKI4hxnpA5ZpoFgspGDMS+vJ4k5e9Izbc4wo6axW4+Kd67kll5U8+OlyqZa4oNnc4p8NC07mK7hcWwg6/Ei2uvAyNJbIDVDyEgXJyRGWEnlIYlWUizu/jA/zfQWGjkZnS3UjxA9Sne7CMtHLRT76uarxhR4WqXaHdE3nnPwwka+U6WXTgI4/Vzk8xfyYfnTBnbzI2cxJvcVxF9AfpQpbTDfMm/OwY8XJkKh8KD/oQjkD8zZKqD1ZEgTeTnNGJHna+Y7oHLQBYqUno46a+0HycwMIqdG/39aNTHRciwObcGob0zeDWmkbAaNAn+6uVZrwopjLhXOyL6QEWvgvYnOeM45AdO0BLwmlgQqUaoZgYCVvxuYUf3D0yOhKX7hIv0xOG+K7QF9se+Zb3hhwQ8ccP4ux49+TC3cDec460T9cndbuk31yz96tX15z4emVjvJhyfYPGFsNtXZliTSM45AKc5GBpZLYmJbVtm7vdeUTi8grrc7/+Wp6wOT1TW9aetSSlWYF76nAbyL+0UUppFqt8dWXK9//E3k5QoQw6/9bJFjdDH4VfZqUq9Him2/HB8LKXI+dU7nFuSzQfa9C2Z4mNMPVRw9ZoAMSCjvbCJSiQwNt3IKwOfQYwj/0TBm8u2irFqp7FA4m8pZ9kNLqvylNxfP/FC//TxyTlmSfo/Zf94pVr1tVqrbLLOwHAL5h+1Cl8uQkQX726Ld0x13fVMP02erzxVDJ8WTxWB2sMV8Osct6sPII3sgMUCDjP0tHDurMVgMQBvMgonqzPdHSur1H1cDKVP
 UKN9AY4f
 kgIDUy4f9hBYFfTzpPc0TpGlxfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This patch adds a new WQ_PERCPU flag to all the mm subsystem users to
explicitly request the use of the per-CPU behavior. Both flags coexist
for one release cycle to allow callers to transition their calls.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

All existing users have been updated accordingly.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 mm/slub.c        | 3 ++-
 mm/vmstat.c      | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7e672424f928..3b392de6367e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -969,7 +969,7 @@ static int __init cgwb_init(void)
 	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
-	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
+	cgwb_release_wq = alloc_workqueue("cgwb_release", WQ_PERCPU, 1);
 	if (!cgwb_release_wq)
 		return -ENOMEM;
 
diff --git a/mm/slub.c b/mm/slub.c
index b46f87662e71..cac9d5d7c924 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6364,7 +6364,8 @@ void __init kmem_cache_init(void)
 void __init kmem_cache_init_late(void)
 {
 #ifndef CONFIG_SLUB_TINY
-	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
+				  0);
 	WARN_ON(!flushwq);
 #endif
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4c268ce39ff2..57bf76b1d9d4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2244,7 +2244,8 @@ void __init init_mm_internals(void)
 {
 	int ret __maybe_unused;
 
-	mm_percpu_wq = alloc_workqueue("mm_percpu_wq", WQ_MEM_RECLAIM, 0);
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq",
+				       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 #ifdef CONFIG_SMP
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_VMSTAT_DEAD, "mm/vmstat:dead",
-- 
2.51.0


