Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25752C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5F86B009D; Thu, 24 Sep 2026 14:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266EB6B009F; Thu, 24 Sep 2026 14:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E766B00A0; Thu, 24 Sep 2026 14:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE18A6B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62E6AA66E1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:48:04 +0000 (UTC)
X-FDA: 85249540488.10.9667589
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8125B40006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:48:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hAD3XP6R;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/kZABDU8cK6a3kV+TCEZT4x9rOimF4qC6zdNvt/dLk=;
	b=TCxD5lBsVGi5moLhCLn6l5eMGppvZC58gVoZ76ksBl/Sa9pMlZx/BmmxykJa9oqdjpbYva
	RQpqjT52u34PkuGHqa1ZLrwZO0wCdqlXKF/YSbte/2zRTGufxC0oJeyShmp8TheeTUfHpe
	cNna3zcF0Dj4w6m3xiuPEP0UpNG61Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275682;
	b=sVEZskPgt8sYbhDop5v80b9PhdtxeN4V9LFRhGEr8h8F+4DMxvhaePWsWcFHzx7OCXmpax
	3NhHCI4GUGV5E6YjKFQS8zJBqkMRNZtkzU7j/yD0g/eEmPi2bFamPwMVFu55zkm/E1z/vh
	bsvbfjjGN+MjdS1WaIHlCx9ENKVQicQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hAD3XP6R;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vhv2GOBN4FsPRGu+ZsZgfVd3kVqXyiVymVSJNtKa9ts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275681; v=1; x=1790880481;
 b=hAD3XP6R9aGJHbBjel4SliVEZcMmOYmFPVeqheIfk61X6C9KBVu4XThcsfqnyJlMIG2ZFEX9
 aDJl9pxnpOwbXl/I+ZtGK3bajDqSoSSRrqXncelufYFwCDezVY75FqacEmQR5bNYGQsRNCTVoVP
 RSRvVn/dR3AJshcwNK3lsVC8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57a02f3e5119bc77;
	Thu, 24 Sep 2026 18:48:01 +0000
X-Mizu-Trace-ID: 57a02f3e5119bc77
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	kernel-team@meta.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/7] memcg: charge high_work reclaim to the memcg
Date: Thu, 24 Sep 2026 11:47:10 -0700
Message-ID: <20260924184714.912181-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8125B40006
X-Stat-Signature: nh3xrbpy1eo1isehymmnpjp7t3ygozuz
X-HE-Tag: 1790275682-721119
X-HE-Meta: U2FsdGVkX1/nrbHXNKykpFBYWTnkY7qUmhaDuf3SLVK/UjD148Ct05zI6GyQEsO3Z0KHIzA6jSv9WVlzuZyRscU/CxyG/PRmVTFLzV9HQuNknCKLfk/CVA6ZpWhuvgIW/ngGPRVQgrW32v9KAB8JBPFqd1crm9rtXzzJvsqX+xlvib/nSpBQr5VeCj5q5lV/0OJrs6QeRvExCzeZd69yL1z3lBIF703mVODNrC7ZNy5Hef9YaNAjF4Tep10aCs8zWIZZnx/jCBX6kdFEYhQaQlfiAAaze6iGypce+OhrJIacU4LYp8ALbUk/gqoIxnwk1yQT4GHx+aB4sYe343OLNhaerum2g8PF4zLQhZIBGg5LX2vR1UFkd4mqFGIqtnEnweHOMKSUsDsHMiZaMV9GuauK3cSilDXsFBJceDRRRAsNzma6RrcpvJhcHGSFNsQfECn6eDgxbezeTapt50ybfyk3cKRqOZW+qilDzzXPtOeq+ITdCf/r0z3zwo9C33Khf3CKInBPhtJ7daB3CmB6Er0n4XGTtGbELACdIiBCD1G8M6GJ9DzPstgGlZG1qiglK0t/X5giF4Z5ZnWw12gwZxEQJ0pR+P1Gsfo9rllh4cti16HX1OfUmhy9wP7+P5B+UMD2iOwpZJBUKSFLbHRQW7UaFB3llXbnKGAmbzX8T+eKHnzXFsd0DwavcXsUxZi6SgyWgFIVL3ac8pshgp0vCaVSSkqruPM9SEZLDDL3MIzOuuVDcGQ5Z7irxIT8u2V/jhCays2aD84+Wc1vnbQ5hcdeAreabHQg6U5RWcvlMIWAwhOZ1scJlF5QR8c+g3FJaIrfOOUZoeuWOegTN75qUCCa9qa0zl8aoPIvrQlWNS4V0A/VgM9QNp3bBoIa6+a/MYFZdweLS0ELZ1w7TbHuOMYwiPsdJVS7keIXHb2bOSd7P+VSNvNkx0ADUzI7ZkjBGVwJd1ejzPD2C+L2T6K
 xQGH/abD
 IsfUOgesHa6aUNtunWvM+XQ71rSRrfejjM3VyTxJMopk5HGERRbQjAuSaEMz2ejUEH3icODQDrF5Fb4FnSc4S8H+/D6WTiYvXG77qNWc1Duvod+qZQPpmaLCDqDbZuy9hDI4HyO4yN8qGezft+rv3F6HDaNy01kgmhm9VdMyQS82R1oZPNv0t1C9QgGr63LSUpAmv8l+5cdPR8O7VPniJhXN90bL69CynOIp6v3S3YmevDz/hp5SBTpV5oHKM40rvIA6CaW+I6rJwP7D05NJU1qjk1lpk8q0HizTcjeH5VzjQQlbv0TKYOImG10M6JWnI/BGhxaNP5jkZ+Va3FonRF4WJC4PgEF3JqU+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a charge from IRQ context puts a memcg over memory.high, the
reclaim runs later from high_work on a kworker. The kworker is in the
root cgroup, so the reclaim does not show up in the memcg's cpu.stat
or memory.pressure, and does not count against its cpu.max.

Run the reclaim under set_active_cgroup(). Its CPU time and memory
stalls are then charged to the memcg's cgroup, and its CPU time comes
out of that cgroup's cpu.max quota.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..f1d0ba8b48cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2456,9 +2456,14 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 static void high_work_func(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
+	struct cgroup *old;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+
+	/* Charge the reclaim to the memcg's cgroup, not to the root. */
+	old = set_active_cgroup(memcg->css.cgroup);
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	set_active_cgroup(old);
 }
 
 static void high_irq_work_func(struct irq_work *work)
-- 
2.53.0-Meta


