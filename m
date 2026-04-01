Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A05BD2ED0A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F946B0005; Wed,  1 Apr 2026 09:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8E96B0088; Wed,  1 Apr 2026 09:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9596B008A; Wed,  1 Apr 2026 09:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69A226B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:58:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E333F5A12F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:58:19 +0000 (UTC)
X-FDA: 84610141518.30.0E91AF5
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id EEB2018000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:58:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eEl96zUq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775051898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9rsyYcZRgU9Y9m6EjiMjdPnpAaVlNNPh8zFmHNh1W+Y=;
	b=x2dRs9jTHYEP6zPStUVTEH7otMSzAjQGD9vxeXqUIx1djtamaE63MKRVyhe7DKCFRAqS4B
	jh52zW4ie3B5p5YFAbSk2IILMMndT2Nsbq+aj6IqCaOyJ/Ha7POrbB4xcBxr0smfiXSDoM
	SjjlMRaUtAxKe8hRU10XXDJjxnnE2XY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eEl96zUq;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775051898; a=rsa-sha256;
	cv=none;
	b=dOVQbwdRi6+y5odrxj2A/jaL13rLlyj8N7MTn347xvU4jgrP3E8WKRfXeUoIHacAEXL15V
	U4j92W0FkIUOE6mqp/gjGV20lhbaqNTagp8YxZwYp+c5htvtCNm95wI15ZaCGNLtB8AxoK
	3tpJtNpt0BqP8kIwKwzPlkf3IAFZzns=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=9rsyYcZRgU9Y9m6EjiMjdPnpAaVlNNPh8zFmHNh1W+Y=; b=eEl96zUqmHHS1O9aRrxCfAaKv9
	JrEUCGHVx+qFR1lRPq0vQlz7VCPIg4LmnNQCyb66NevKQx6uGjACgUNlJEiiL4vt+UuKKv/yDDNxa
	thOn2n4P0MBaDfQ9T0Vt1+ra9tVFA2Yq2KdmjMLoZhttG/JxASTpBAg1A3G6xWADSZQVYM6vJkEDv
	uaZW3o/77EfL0o83jzyEpZoTRstcFk5CnG7c1La5MuWq7TfWwWvn4KLQJeCbhmUkckSBlDWZ7mwHF
	ZqyY3L2tWn6vVj9tNt8oiJwU4ILGRE+uLDFQPEkw5yeqzj1wSqRprOOc8WRtvtfVYx0R9ZVJ5chVM
	adzGMDhg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7w55-0032AU-02;
	Wed, 01 Apr 2026 13:58:01 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 06:57:50 -0700
Subject: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-B4-Tracking: v=1; b=H4sIAF4kzWkC/yXMQQqDMBBG4asM/9rAaINIrlK6SO2kjqAtmSgF8
 e6iXb7F9zaYZBVDoA1ZVjX9zAhUV4R+iPNbnL4QCA03LXuu3TpZicWx74STxHTzHhXhmyXp7xr
 dH/+25TlKX06NfT8AO4oC3WoAAAA=
X-Change-ID: 20260401-vmstat-048e0feaf344
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
 shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3632; i=leitao@debian.org;
 h=from:subject:message-id; bh=pwRxG9GAAJufRx8H+Z8Qgyqr6YmcWMfzUDBj8VjAQ5k=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzSRlU90iOKhLZPrjg3oQM3wcL26xI35lLkGCj
 o6bzf91b2mJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0kZQAKCRA1o5Of/Hh3
 bWjWD/9J6ejSbwu8LItrXR9+TD9jdyZbhREGu5RimJOjV1uq6J9iyGpmCky3hjifppp6vavFufC
 R4RhwNNTVEr6RoDOMcGuAJBqYM5s0o+6MHAWerGVlP/VhQJSDD78QAqLTIgPgWtguELNn5ExkrL
 lE9caYxKayZVcSS2QsJoyz4yYr21tFAyBrkHrDJXDOCtwlkG9FVUlhzGK/amoQabsCkYzMtrXsn
 9miNeGaI7TdB7RabwfyCPTmx0BE3/Tx59/CrLQ53NAfLY/U7tEPV4LRHJ6F8F8XkB4LNnT2Hta3
 Dbdw5Fp6wvFZObjkldlUtI+JVWiCviYEXwrC2VV7vXDxQx0pQ5cDVbuyYfw4mHp2joS3q65kon0
 vwtdiVzV6b6HP9BYvbo2M+TxqVfM0R273GbPJpgm1fIXz3O9wqEh7bliRijCV3HXYF3fZWikpJz
 MTm6oMVwI6olQW94MDOh77za8UcDQO5GNSOBpUJed7HzJfJzi2Lxuph0yeOWZ6XDXuvjFt0ne85
 zSzUQvEjzZPXXYB6T/QYGSuYxd7OUlH2sGkQS6tKzeqkQg+75kLsYNyOrWOdyC7uj7pnmYN+Bvu
 S3GKHPG3UXjo6vc8JfsFPUsJR8wDftC52LamyOaExTDmJj+xFNEgwsH3QwnMUBV6CIiAha+XBft
 L6qxrkuHkSQMiAA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: EEB2018000E
X-Stat-Signature: 99t5uacc1xcdpisxz7utzzs5nnmue5wc
X-Rspamd-Server: rspam06
X-HE-Tag: 1775051897-280669
X-HE-Meta: U2FsdGVkX18zN7ARyiKZuBbiCJ/v3RruCw5JOeyU8wAsX1tI9H7IuyRQrOrnAd6JaZYUYB5Fw3A76jndblcvLuc85b12ZXjxU0yGooG2uUr9LM6tFDRWh4142M2pGmtX21NPmsUsBACPPHPk6WI4gOXGuBntccz2VvW8fyhuXt/Zo1z8NvrFbeGjcsL30A5RmsNhILfLTGEa8rcCTipzV+tVC0VH19E6480LX9qbu3NztAcBYRmzKlpyImmF4+/xjGD1sOZX6LLSGk5wqS1mGBGOlyUsc+6d+XZUHzJDPFlDCJbQunaA2GeqSLRwTRu2A1F8mgkdYxrUg8NVT5zJ0+uMejFAjmKPYQg7iWVzXtKlc0Z+gmbAAg6Ezt7X/t9RpALc2XAiaSXIrHR9rutY5PKph1/LQdv9Ui7aktEvWuIf+RdJAlDmQMOKFEkZToW8l5XuV7+H6XTmmWCZb9kPGiG9GVL6YEIbySO+rnA26An+2TCpg1DLy3uZrjdOx43P7iHTcLGE0bApRsR6kpbABvTlgJUf665lwwdChNj6eTEzwbldVW6ucIhc1C6wKzqbjhD6mUhcSdyMZUgkt6zM68W8/ipqB4weP87HQq9cLHqR5iTiUEATSND6akwa0sPHigdpBUVPxnmDTXCv/7zu+xYB6ehSgS7tf1dfy9HHFOeKmlvpUr/qLXPFI4f1tHyC1n2MgTP+aR08M5FseqiYxEJKPbKTULDD2mWOevaGy+4/+z+zr092TLnJVLmoC+Bs/qJYPyxP75icYFVFzyjpL0lES0AjavWOQW+eWZw/8YvfuebxMCfrPuJKmgk/adguWNNXH5f+2263N6b3dLvm7czzSerO8pWbLHLOZZymxhQlCgwEmKV9mxLBpf5ZTuLfYkdyp/+yT2aQAGS6Up6eHq8NMM3Mj7uqEYMzSo42jX+KJbi1feg2+s6nV3ONhWJIq6eH9BGIL8TjOPp3kjQ
 jbpB+VMx
 HO9EAeZrzKYy8t62ZMxFS/nmGBY9x2wTV26FtuX88YgfVcm0fhBaPqQxPv9b2OllD1r5tb2aC/br529EcXGO2kNJaAzBWorUbJlsybfNmj3OeCLnFGSpBW3z1pYNqbHyaLJf6nTTFcrDlZ6EBzXCruEdsfjiRxzKJIJQqi5unuF6vEzkdOmJYex3Ju+9loWUosWa/X43ba3XSLU/obippn23RPdY6T0/Ez1Z5k0Dcgt/Kyjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmstat_update uses round_jiffies_relative() when re-queuing itself,
which aligns all CPUs' timers to the same second boundary.  When many
CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
free_pcppages_bulk() simultaneously, serializing on zone->lock and
hitting contention.

Introduce vmstat_spread_delay() which distributes each CPU's
vmstat_update evenly across the stat interval instead of aligning them.

This does not increase the number of timer interrupts — each CPU still
fires once per interval. The timers are simply staggered rather than
aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
wake idle CPUs regardless of scheduling; the spread only affects CPUs
that are already active

`perf lock contention` shows 7.5x reduction in zone->lock contention
(872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
system under memory pressure.

Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
memory allocation bursts.  Lock contention was measured with:

  perf lock contention -a -b -S free_pcppages_bulk

Results with KASAN enabled:

  free_pcppages_bulk contention (KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      872 |      117 |
  | Total wait   | 199.43ms | 80.76ms  |
  | Max wait     |   4.19ms | 35.76ms  |
  +--------------+----------+----------+

Results without KASAN:

  free_pcppages_bulk contention (no KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      240 |      133 |
  | Total wait   |  34.01ms | 24.61ms  |
  | Max wait     |   965us  |  1.35ms  |
  +--------------+----------+----------+

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/vmstat.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd..2e94bd765606 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
 }
 #endif /* CONFIG_PROC_FS */
 
+/*
+ * Return a per-cpu delay that spreads vmstat_update work across the stat
+ * interval.  Without this, round_jiffies_relative() aligns every CPU's
+ * timer to the same second boundary, causing a thundering-herd on
+ * zone->lock when multiple CPUs drain PCP pages simultaneously via
+ * decay_pcp_high() -> free_pcppages_bulk().
+ */
+static unsigned long vmstat_spread_delay(void)
+{
+	unsigned long interval = sysctl_stat_interval;
+	unsigned int nr_cpus = num_online_cpus();
+
+	if (nr_cpus <= 1)
+		return round_jiffies_relative(interval);
+
+	/*
+	 * Spread per-cpu vmstat work evenly across the interval.  Don't
+	 * use round_jiffies_relative() here -- it would snap every CPU
+	 * back to the same second boundary, defeating the spread.
+	 */
+	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
+}
+
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
@@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
 		 */
 		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
-				round_jiffies_relative(sysctl_stat_interval));
+				vmstat_spread_delay());
 	}
 }
 

---
base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
change-id: 20260401-vmstat-048e0feaf344

Best regards,
--  
Breno Leitao <leitao@debian.org>


