Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A40CCFA13
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20108E0010; Wed,  5 Nov 2025 16:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7C68E0002; Wed,  5 Nov 2025 16:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE73C8E0010; Wed,  5 Nov 2025 16:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7E0C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55CBBB9AFD
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:28 +0000 (UTC)
X-FDA: 84077781816.25.9DD374B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A427F1C0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LTjEW+Lp;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jsS0D1ZkHtkf2RkO8oWUbGdG/MMM9S/GrtgH5Fheqs=;
	b=3+wFA9hidPuv3o8H1nobsJh28hf1yg0ORyJWa9MXlekhS5JPjr2v/OHctEO7yy5qcYdw4f
	NpciRgNRFvh3TV1RWYCRwrHNfFD0/DuPMOTtR1XNi7vDeLjyeg7eHRSKKR8YVZTc5RTDjB
	LX3AQjPFxEdbas6Y4rBfU5a8kE7EjL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LTjEW+Lp;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376666; a=rsa-sha256;
	cv=none;
	b=seAV7Yi1shrwcpAgKuXV3ILqozEerQx5VCbsR+1pNHZuiNvNFDi7lAGG6SjdAcGklXeHve
	ZyPXQhBFU2PYVABS+pqVcDZJbjRb/sY8APl6OFsSiCnb2u6g+yneR5zfSR9h+fsCoZ7+Hg
	TgQh6358qgulnVpsh5exTj0GYGc2rJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB333417B1;
	Wed,  5 Nov 2025 21:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C864C116B1;
	Wed,  5 Nov 2025 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376665;
	bh=QDY6OFwPCpaj5eQjhmw6Wwop/7HtBl8sFRDTAL/mseY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTjEW+LpKe78Iwb5IpUCFicQk91WKrouEhNOVkCIWNJWT/IUfA+/1BuMRMTE/GSNf
	 +H7F8egVjXkx/lSP96kC+SuuJLTGF/8XU6ILZHU9JyBzgy3HxvUFPliaEIO6h0Pw4Q
	 NVPHhj8BuptnLIKmapcvKpE/aGeO4jSutNhuT0C4PABWjnpD9Q5cuNIdyWXg3giORC
	 Fi9PFedNEfYKwdFXqkXdRc0iWC1GJiQi2RRoWyt+ov+H9uiPm/BOjklQPfkM6OtIbG
	 I2NCBOxhuNhTQcrNQ8aEH7WXQtqQYaJPe3rmjJTxzn9fdSN39b2M5jDqPW6Yafqx0c
	 MhWXAmuKuHXaw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 03/31] memcg: Prepare to protect against concurrent isolated cpuset change
Date: Wed,  5 Nov 2025 22:03:19 +0100
Message-ID: <20251105210348.35256-4-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A427F1C0012
X-Stat-Signature: m4yrfaaqnhpu61jin655uckomu87c84s
X-Rspam-User: 
X-HE-Tag: 1762376666-4927
X-HE-Meta: U2FsdGVkX19oPXe4V6F4rcSGN0Um/vDRjE788DnYRZGKMNWO9hFK/ugC6syI/l8QLjbW48X/GM1tr6M7LQMKk/1UNLEuKM5fZ+tGC9NsT9hgO36eLZBvQsKtCV2yqkPQCjw3fBRu+xYCKxnDYBqo2LTKx2dIVrnfHbADJILVFX/h1m8gucEaUjHf8Oqg3J8weAKAyLrzok8ai7NamZ2D+kRd2lWRMNspkrj5MZsGJrzSVVv9VzuuTibX496sHFDNvKwcvolMBcj84TlHEi+lQtr6SCn1SQM+uTxAN1McgvUoNPgcAgR2+HVvViSmezQyOUbbUkRC9RE7cT4IRUnYnc6Np5Spe6SJlNRbjsix2Ah8IXwVlBcAg7edoInEdLkPh60jQcy6NArAow+OF0/xiryZ155ojHhqRiUR7mFMeLpUn9fYyKi8M2BoLG7XMnvxjz88g/as61RE6QfcT7FuQDjmsONnEtq1WrCBsRAL+S8DepH/ovG3kiQRie5B5x7Jam4x9RH3hZe2SCCl8nJXN3LxaTWBQXQ88iyBd3cisgWRf3d3lzYQO011oLyTOzVhQIKK/Zod51fVBCn5QBBdlRbT+IivbW/INa45xp1CgAq2aTQZPfflJP7/Q8MmjGm/QrpGP6lkridereqslLUxhVa+OjQu00Mx08u+VBoFRIHdadKIu3yA9y1FW4DA2wWv9ebzO9+/U5LW28lC6wfjedBuXevaydtu0fNhX7/nhpXsaUml4zYliPD72klG6naSaflHVsTXvl/rIPy0kATURNBC+LQkUHG1c5gJ527c+g7uvvmFMT1ybooZrULiEb9e89u0WBP2xuQB9jt/Bd+7t9oRLCf5NhUSnY0RH+2STruFy7e4hukFt18qXZYAh5aoj+RCH39hgdyJpZFtdNs7g+cqlpnCrcFUC9XRk5Q9RZ0F+mgQu77/m3DkgMamfkeKE54dnuwOmETn+1JXzTr
 AzRgfsY6
 MSzAQoIwpWX/2ryzST0iqBGMEY3R4QmQnk947kdZTzDbKfT9dJxLA6UR/sOCzmzN3q5ibHrZIubsUZ3Leqtt8PqPdA94iRjuzycrw7b7BLKyVlceTXxldYCvLqGhIqhlAGaDygs9Cr3GIYUAeJv+2Ye6PlNHDEwuavspaVAI0cr8FkBj/xUoqWq/1z7yAjm/NyNzlE7geu44wDaKTXwWG7WsVLtSCy0LM50atS8vZc2zq9sDLQD8bjZXM9wQKP7jioIlwPQF0PzqSB+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against memcg workqueue to make sure
that no asynchronous draining is pending or executing on a newly made
isolated CPU, target and queue a drain work under the same RCU critical
section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..1033e52ab6cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1971,6 +1971,13 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static void schedule_drain_work(int cpu, struct work_struct *work)
+{
+	guard(rcu)();
+	if (!cpu_is_isolated(cpu))
+		schedule_work_on(cpu, work);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2000,8 +2007,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &memcg_st->work);
+			else
+				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2010,8 +2017,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &obj_st->work);
+			else
+				schedule_drain_work(cpu, &obj_st->work);
 		}
 	}
 	migrate_enable();
-- 
2.51.0


