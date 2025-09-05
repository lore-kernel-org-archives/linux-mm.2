Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF11CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A168E000B; Fri,  5 Sep 2025 05:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E198E0001; Fri,  5 Sep 2025 05:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0589A8E000B; Fri,  5 Sep 2025 05:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAE398E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:03:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 948CA1A0627
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:36 +0000 (UTC)
X-FDA: 83854608432.29.B3D79FD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id A29D72000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GZ6MqH6n;
	spf=pass (imf03.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzCSgcP8J/wJxN3+pA5atn3uFy0f4CbQVghrsqERdgY=;
	b=5tZMM1pF2JDrxpMDKxWbtBMT/yxRDD0Ih7vQssxvUh1lbNIDp79PfPJh4QTq4Ds/99ddf7
	ohEOMErMYR1sU9fSIT6zyc1ox1WgljjyWmkjJDzw0rxEsjrm9PC1TC1w0HIc4U1SRMh7lO
	Q6vYMlIpRaePERVOg94PMLmnMqek3zc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GZ6MqH6n;
	spf=pass (imf03.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063014; a=rsa-sha256;
	cv=none;
	b=bMpelg4/4gqFYIrzljm4Njt4V/dfR6LkMumkKHeX3Xq9JcJMNTttstiEiHXcKDyWPiZsT0
	LCdgJxTQ9zC4Q7ym2/oECIR1irklG58R2CEnA2pkIJFY9SHI7wiRSaQzsXV/9476B72Eb2
	9WnDuHVQwHxf8efKhwO47wdCQLFSc+E=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so11900475e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063013; x=1757667813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzCSgcP8J/wJxN3+pA5atn3uFy0f4CbQVghrsqERdgY=;
        b=GZ6MqH6nMpMABELOPu4LCIEBFyKrWZLrbqZx9U35xcrGjh6LyuMMvBVGJmtuQIo26S
         gc8d4bhPnucNIWdio6uWYRaPH1U8D8SSGiWj26BRoOFupzCI6winGaup1/AHEemtauJu
         cyLVbd1UYugeUBs1HE5ls034DcQHcq4aAn4U2x70G8KEfDwCLjc0WASJZXNj+ppJmZTD
         MxYmRO8YUAuuqg9r371y+h9PT+ZTuoxj6pxcGECiurYB61bzxHvj1ku2DmqiRjVIOvx6
         3q5Zk4Oc/vNTTu7M8Df/ku9WsyZRD1N7qmGQSfPmCpDI8h9IymzX15YTV89RD96pG4dI
         IwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063013; x=1757667813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzCSgcP8J/wJxN3+pA5atn3uFy0f4CbQVghrsqERdgY=;
        b=LJHLXn+JGd47jEX3O1B5nr6hUzg2/KundjH+SKtOlohK7H2p+G23Xq7lN0Q9b8w7tt
         2m2gUawjTKRSbg/7NpE0I9LJUgX4ZAc3eL7Hc0HxzJo2X+0m+nr302R4mzEKYQ0r0UBw
         m9wb5WVlsoLFyAolaQn4IMloxVtf8kv/0cUyK5/spbbjuo6rlKI2hfbjFzXhNuz05ajS
         rNyh2cMey15kGEAxoEupLgiqW4a/Qcvx0CY4M7vxyD94WeX+XDSQslxKvJcbbYM2fMkY
         4kg4iMwmLnfRDU0m+i9d0eWoAC30iHSjnjcKH42WChJJVRejtTeb2uqzYQ8ftf36HhZP
         mNWA==
X-Forwarded-Encrypted: i=1; AJvYcCVxeHJIzLe8QkjWre9zd1giFROx53Lxf4x1ZPnXgNlidMOOYRi/Qsjen1UpigeReBEN+DwWTUOkHQ==@kvack.org
X-Gm-Message-State: AOJu0YwkPcbyfZEgYlUfn7cioiaGiPzNmuDi3MCXtzNaW27EYLCHJDYz
	n40OODZCnDP8FsKvuPo6JXuB9XNLnoGpHxT8nzR7QBYFqcz98pE9olPEP8JoyWkcWpA=
X-Gm-Gg: ASbGncuuB5rLeMnwPDT3CUBV+WLt/FQ+blwh8Ulm6jjYffCSVziGH7jFpS6TftXU/Gw
	CAIPYG24SZMl47At3KWv3EO2ZCcPBtmDIisM3fc8JuMNNvX1Osb47jdFITOt4dFmT1vEt2fv+TJ
	qQMnvsFz0sX27ZVg1g5mQwAWaJEToNeGU9eNV+6guVQVAC8dqND6LKRaXUR0eNTRpQJm6IzdMZx
	o95Bu71ww71hBUz8BaluHhuh+JBFMSOJekWZCoQpRP2OEGImGNPMmv4iXvTdRhXKmhpj4EC+4Ih
	OOp/nOOrbjJ+aqUN4RTTI705tiWvwphmKL8Svwq3pl5Q/upSkR5d2OKMAC4dD0X+I3S/RHSosAn
	iB0rjnBG+i9eE9Ac0bLem3mW1FQ30ZwcubX/wB09NliismmU0Y8uuB+L/GTRSZT2YRVN1
X-Google-Smtp-Source: AGHT+IHTJr8AjxhM97DIyH1nX6frQj5Bab2I9iIRm2poKuO46hcNcueAX4sXHhcrkhFS4FnEzpATPA==
X-Received: by 2002:a05:600c:a0a:b0:456:1824:4808 with SMTP id 5b1f17b1804b1-45b855aeb67mr166210085e9.32.1757063013132;
        Fri, 05 Sep 2025 02:03:33 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm3614543f8f.62.2025.09.05.02.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:32 -0700 (PDT)
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
Subject: [PATCH 1/3] mm: replace use of system_unbound_wq with system_dfl_wq
Date: Fri,  5 Sep 2025 11:03:21 +0200
Message-ID: <20250905090323.103401-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090323.103401-1-marco.crivellari@suse.com>
References: <20250905090323.103401-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5obc8suxk8niwfg89cy1xcp34uxgkhtt
X-Rspam-User: 
X-Rspamd-Queue-Id: A29D72000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1757063014-85646
X-HE-Meta: U2FsdGVkX1+2IVYjQr3XRQhAWkIvNGtT/EK6VxjjI62tXxZnoem6iQ3iOCeADxrvhBA7atznwn+trMxdF1c2wWwetSerll9rkNwD4wL5RpHA1YGCb0VlsMZsRAdzKOFDs2fPQ0FtQ3kQfmpflHgFxLRWFwtpoUfy8tZS61dtjKIXnltkZA3gIE80SUuijvrmhxgnB9eSjHP+fGE7kuKzXWfEXh7v/JDe+sMTdTVvZ+BkRUKVxYLRz0GGWICSenjTz4Udc8CET50UOMBLHWyz0ChE4F/ChSAu3LKifmWNMrVOSHFyimooju3upq/s9tJrGgPLPnZrm3QHwZzY8YQoNoL3X08TtMfIMf9WAmJDPr/X8qSV9FrcmJkY59bKbgdqDNb/QPEpAbnXAImNSa8p0aqyXQy8X42ryDogckRNEuX+/kdrdCyNyWydJQWadFgo19jpxm3h1Bbjvpe8UtpHiHeSee/wqmTH2RXHMgQNiGphroqPUEP16F703kQJPw3+8d4L2ViaGOFGUbuBSps4v/wVlsPwn5yJuY51SA5FYkUYEou/KO0VzP5m1sZhK4LJzNoieiPy502Rvd44t+DuAAZa5PrOUC9PYMXOt3WO0bVIp7yz4Edny33BSq3R1EDXW2+jz82a0XQ9LmhiFqNRMoB1wkdjXRFhpUTkNzubEwrAkSa0bR6PTK+Zyu2ikLsFxGCvY8YDDHuz16j5MipJb9f88TgzoAxBEv0vzR1l3wt7dEq7mlqEHiw4AZHAjmMH4dYjGFLwEE0t3hNJB64+EOR1hx48+vI2jhFSrPKtGGCXjqV0H/0GcewDB6iKAIV2qZkgFTT59KY4JyN5o++5fXhZubN2PpubT80S8WjvjcfHvygJNDWsUDCsqwel45hTPns6CTw/xRoMygjNMfSp2HACUOrp+ieYPE3Vdhdt5FwRx9hufZMCfK433/hRAurzpUUYJ7VSJal3yuMkefa
 zfCntc8H
 ve+VvPU7JEz8ltiiL6ICvm4jVKJZ+7fqAynVZitsOcnxVV8aX4Nj98PgMqNWHznQHTE93nqw9tRQQnmOZ7dzj77QgCaw1hLUkALeiDGAKtvv+zIbBtiPbdpiBtwluKnnoLkze67vXtGyy3AET6RFzilTf2SxWWyB5NjFw95Cyu+2w39Jmiop/kP0/Ud3umImUyx/7bgUASHgoXidFYlYShMhaMFZKXaC7z7fcfG/A3T7/0VqtG3/7dRJuQ1k0v5P8VgivviLge4SqaDjQ0pPgwb3E5DnlK5RjN8DmJMQ982r/awt4LVDSZV5XM/5kdfG0lgwR0vWxNwRGZxC1tzepnD1yGC/YiCalhPh3AVgE2pwdTbyKdph3oEHOx1wm9YYjpf74FCcph1gckJVIrXOwz6wQVw==
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

system_unbound_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

Adding system_dfl_wq to encourage its use when unbound work should be used.

queue_work() / queue_delayed_work() / mod_delayed_work() will now use the
new unbound wq: whether the user still use the old wq a warn will be
printed along with a wq redirect to the new one.

The old system_unbound_wq will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 mm/kfence/core.c | 6 +++---
 mm/memcontrol.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 783904d8c5ef..e9f9fdcfe052 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -934,7 +934,7 @@ void wb_memcg_offline(struct mem_cgroup *memcg)
 	memcg_cgwb_list->next = NULL;	/* prevent new wb's */
 	spin_unlock_irq(&cgwb_lock);
 
-	queue_work(system_unbound_wq, &cleanup_offline_cgwbs_work);
+	queue_work(system_dfl_wq, &cleanup_offline_cgwbs_work);
 }
 
 /**
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 102048821c22..f26d87d59296 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -854,7 +854,7 @@ static void toggle_allocation_gate(struct work_struct *work)
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	queue_delayed_work(system_unbound_wq, &kfence_timer,
+	queue_delayed_work(system_dfl_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
 
@@ -900,7 +900,7 @@ static void kfence_init_enable(void)
 		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
@@ -996,7 +996,7 @@ static int kfence_enable_late(void)
 		return kfence_init_late();
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 	pr_info("re-enabled\n");
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 421740f1bcdc..c2944bc83378 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -651,7 +651,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	__mem_cgroup_flush_stats(root_mem_cgroup, true);
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
+	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
@@ -3732,7 +3732,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		goto offline_kmem;
 
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
-		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
+		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-- 
2.51.0


