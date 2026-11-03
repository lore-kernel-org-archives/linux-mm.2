Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0929A606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=bVMjVqIW
Received: by kanga.kvack.org (Postfix)
	id 6C39E6B05BD; Tue,  3 Nov 2026 03:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655C86B05BE; Tue,  3 Nov 2026 03:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562DE6B05BF; Tue,  3 Nov 2026 03:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3234B6B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA0F2C0304
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:26 +0000 (UTC)
X-FDA: 85393060452.26.A7B94C5
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D94B40011
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=bVMjVqIW;
	spf=pass (imf04.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
	b=oV2FGVztRk5JW9W/bgBPaipAWwM2Y8MHo1alPC7aX+xMRoE5hcAX8xd2U8Xtn283ku+pta
	EGu0gO7J40TBVbbZoHhyC0dlBJZErKBoBHGIfgLm8I/960OwVNE0GfvPiHdKg4WQjBrU/P
	uc/GseWGnCyDedttDOy0PqaB8xxnD34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692824;
	b=JWHtMrCx2rxe5JviltJ4lykgjpmHmvNScdjU+J2rDSl5OgTmI8KwIO0zuQIJ4zvtQYeFfR
	ofBJiCC9DMKeAFaI0vHN+aWXuZADU05V8/p+xHG7pFRbAqMR8PfjqRv6cxuy/wP6TwWk4Y
	WOMMqe6/BfQaXBiQxfC7+0UTi9GoIx8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=bVMjVqIW;
	spf=pass (imf04.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EEEB73F91E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692823;
	bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=bVMjVqIWABxrR+4aYgkhHXaSCQmMUB/uTW9ysCsu9Cx5ROygs7Hd8wGlzjvvmMHtH
	 a3oJuDnbYs1n0oSw31qooRA6P5JUWVQHGhj2LdSuRGNOegnxXcKOUF2pDEYhO9VA9+
	 MqqXh8adNPtpFuQ9rhInCtXEzJdRiSiw3/JSrPcJA5u4xoPWQcIuHiGsqJAiqjnwBa
	 9wGBdxHHFDr2Kr8f2ccFZs6Gcb0MSBQVZMKXYyflvrqJAYXF6SWYPwesAdS1H1GAcA
	 mTkb9Y5zEs+HftMIJp07ry83eB3cRYDPAQK808UTQ710GCWQn8EvetdCpj1UmbqumS
	 QpICK1ZU4JY5lm61OgUmvKweFhz+gAc/yfagl7hsezRkqy4DfzP1BtojH/wXxR9Uyt
	 /lCnWVwHcNs7Io5XzP3KaHByUC62UTT8oeKBo7xI87nBadzJxu53xdL1LCqzxsPQqT
	 VAkLpuXH/xt6TtSp1tpU7ondq/1If0fS4RT0cmXd67IKLzARLaUm3vnULX1jxyEXQf
	 fDU26ks/7L0uz6Wpxz3OO0JloYnqdvh0b24v3v6qU5rsgNAXtSl5Hdy7KMGusW5Y5x
	 0KBJ/w4iq6adlQgV7XKCn881zLwwP2rCU96jRlB36uHGP/KL4HkjM5ZQQEtNdXfC7p
	 bu6w+/CJPTHzoWFNCy0XDe9M=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so8806787eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692821; x=1794297621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
        b=N0TTqECrrt/p9IaP3DTD1uNBT/zoWuk9B3kh8B/uZuLixk3Wm4XXrOzSoVtScz7I6Z
         FkG288MnDbHulI2EBJp/WyIPVycVj+c0/VA7TMQPRMOBWcRnaTu3vO8PKpXI4v8fxhLm
         iofxBbFSe2XKVXggMpQInJ9fA5+MCILOYU+dknE2F18G+Kb4F+Fc9MBtHE4ejc0ml18V
         lQmpB/JWgCWoC1TWbt3Bao2wxKpY0qjJh7BqMrIDcskPu8wnbpfMxuI5ermNjCfJLZIG
         ebtAnBmKFDszKGNYSNm5y3Fd4ak+pB3NOGlVMVuw4IKoq84Ov8oHWhC+/9ciRENI+njd
         8Sxg==
X-Forwarded-Encrypted: i=1; AKwUvBwwe515JNehO1/KigT9vJrml6v6H4htjJMp1MCIMG+GdwxcRsh48NOccJNDcElkl1TCKirzxXenXw==@kvack.org
X-Gm-Message-State: APuU4Z/0qcj3eaijauHDMaxP/iRuJj/lvyTQL3axGe0DLmkNxhch36e/
	bOtA4C3AvrG3/A8IMs/Bp3kNektwlYz0mSAdSWNNDGGXKZBvcHRhLS1/oXen9bCVirZnU7vHJaz
	EUh1WSmiDVVDLG4ykeBFVus7JG3pyHBbEuVSYdof0HstS3px/XnDVCdyiSapu9El5lMuV
X-Gm-Gg: AYBFou00RD7Ie2VAZsrvVgPn8jAb7gxNFSy/VLolfOZQkiPB7ZHXkU1WXG+9Ta4C2BW
	J96YxZFR23oSJrbmoUoqe5GLNcluSOOIME0l4/S7gPI46Lk1HP0Q3eaHRdyBV88HEkWa2Orm1nC
	5f/MXSXCrtFPZpsVS2id7u6PJ7PyFhfkBWKxNE/6/GeODASBYueMmOVfe8543g2LwdKjE/fg20O
	cVXlK8gtnTCd4ei32N+/fMPGqfBOkE+LtvSfKP20k9dXvof2Z6+wCfHwjr+39d4k+jnZyZDHofQ
	nOXyvPqdC3AKNsVxGVfQIWueEbcGUq9Lzq9VciSl4gEMD1CQ7gH9Me+EEUMkBhYDl84Etl+ZT92
	K2pDY2Wzzahn/uBupEZVfHGsoXomZch3M2Nvv2o2J1eAFykjXCG2maUb6t/jPi/mfCh2Ltpa+ns
	hX/jWEQQMPWWlKCjCipg==
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr18896005eec.25.1793692820675;
        Tue, 03 Nov 2026 00:00:20 -0800 (PST)
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr18895911eec.25.1793692819841;
        Tue, 03 Nov 2026 00:00:19 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:19 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 1/6] sched/isolation: Consider nohz_full CPUs isolated in cpu_is_isolated() again
Date: Tue,  3 Nov 2026 20:59:35 +1300
Message-ID: <20261103075940.110308-2-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D94B40011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ir3c1rdnady5hh53gzmt79sugu55si5k
X-Rspam-User: 
X-HE-Tag: 1793692824-716443
X-HE-Meta: U2FsdGVkX19486Tjv5H3X2Bgbf4GDRL3MNz+OnwBj6h7sgdf+2rF1mtkzxeGGD8yZxZXXlb2lXFd3Y4pALW9lzlb1ITW9rYfy+Jo7tsG0Ke7inMAP4V9IZF38hJkC0rByccPr0gwO106om+Cr4GIBkX+2L8lw6w8PHFQ+S21c8B172JuS8CyHxn3LiQa00UUyTsI9WICbgHAXtZQvIRHxmlnTQeEetCfICzAD6lSzwLY0qNFjGHOPW7syRj4727wJf8lLHkGRw0mpzGe3DZO8d/BRZ1y5VD3BGrKNMiidQBadcO78ZjwOSk0uAyHtI3CU2RhzL4+NOUifwHFfxQASQ/kjy4cLZn/Suq9Ivw0/fdccxFxHQXpqTMryDeIxxMQTCqAyrtAsqiU+AtHCaGB5f+NSwLZKF4ZD0EFFnrNr+bgWSr7nwSc902Vq3WTupziBiKzP49uKgFH/9kON2e16MMWas+6fzMlFtI84eeV3/1C7rqqqOF63ps2aJ6yTKzsus6+ef8lPI90wMl3gn49MJY3o3WURgZC9szi/1i3VVHXRULr+6h3C5RefbTicMh7oJ/Gy4XMs6phhqlTbq3m3qk6iCnzJaZEzJXVKrENmlfIqLmWledqFSy0kKHSRbOAUYqOE7izljJXHIkvOmXQLUbQVjTD4FZGCYAQRwIy2rCU0yE887Uu/Ic+TnFS2t1op+yXr/q0bhdVIdF1Losdibsdf6t7hlZt7e1UiRJBNNGgM+cW089JFzBVawd7AeVtZtsct0Mbt1jGawCNtr7HNlwo6idz35ZCiQBCCuJk2kf8yqaCGxXHyOmmikUuIjikhXH/KM1IZG+LqDDOxIebET8MOqQ2AEes28QSfWKYrtISLhnH7PmDlApXXRSrF2d3dED0dXQyej5WQoUsrhCas3wmJns3wcjZFn5qD+2uhL8HB5PUrzHArxxZkQJXt51Jr6H+T5PpJuq4xuKcUBu
 Wk5iqVh6
 OoUKLD39THoAsD/HhKd2MBy7P1CBk/eHGfWsXj9z0FdNC9jS4Mhgez3ToUb6cLx/eiJvWxW4FqFQxtVNCeegbqgF9s/LdMeRphAd2EgwuITnnmTnUh+HrGEO9dXJnSjgnG1eWCvySY7UXMIC+Dx1RTMGM9YBE/k8odws42fvQsyn81Nq4lxNNEtccs77dEP4fELtur6uxHIfagpgMcP6Ko6nqS6tv5r4zpyr4kL0AvVj4Y2YNAVZB5kt4E3JRLZ0krqTpBxAT7yfyoXvJYBy9WiF169hY3oFOyiYVuGpOzbCXf2CF8Beg+t12BmIecYjySNjEF5dfhfELp02au2HNPbfDN6cP81ooUwRYCFsK+kc7aWElndiPflTHLlSe0xoUtMgLfu0Hz2rJgTamJZ3sPDIItZhHsZIQBzxIz1UiCAfqQlmK7g8zJpzJFl0S+/xqKDfoqHM0fQDnpQMqKsXUkk3Ofd57bIYJTV0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Commit 1c3329df409b ("sched/isolation: Remove HK_TYPE_TICK test from
cpu_is_isolated()") reduced cpu_is_isolated() to a HK_TYPE_DOMAIN test on
the assumption that "it doesn't make sense to use nohz_full without also
isolating the related CPUs from the domain topology", i.e. that every
nohz_full CPU is also domain isolated.

The kernel does not enforce that assumption. "nohz_full=<list>" and
"isolcpus=nohz,<list>" are accepted and documented on their own, and
deployments exist that deliberately keep the nohz_full CPUs inside the
scheduler domains, for example the AWS c8a.metal-48xl systems of
LP: #2165410, booted with

  isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178

On such a system cpu_is_isolated() is now false for every CPU and all of
its users silently lost their isolation awareness compared to v6.8, which
also tested HK_TYPE_TICK:

  - fs/buffer.c bh_lru_install() caches buffer_heads on the nohz_full
    CPUs again, so has_bh_in_lru() makes __lru_add_drain_all() queue
    drain work on them;
  - mm/vmstat.c vmstat_shepherd() queues vmstat_update on them again;
  - mm/memcontrol.c schedule_drain_work() queues memcg stock drains on
    them again;
  - block/blk-mq.c keeps them in hctx->cpumask.

Per-CPU work queued on a nohz_full CPU that runs a SCHED_FIFO busy loop
never executes, and the flush_work() callers hang behind it. This is one
half of the PID 1 D-state stall described in LP: #2165410.

Test HK_TYPE_KERNEL_NOISE (the housekeeping type set by nohz_full= and
isolcpus=nohz, of which HK_TYPE_TICK is an alias) in addition to
HK_TYPE_DOMAIN, and use the housekeeping_cpu() wrapper so that systems
without any CPU isolation keep paying nothing but a patched-out static
branch. On systems where the nohz_full CPUs are also domain isolated
nothing changes.

Fixes: 1c3329df409b ("sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 include/linux/sched/isolation.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a2..294c508b0018 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -84,9 +84,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+/*
+ * A CPU is isolated if it has been taken out of the scheduler domains
+ * (isolcpus=domain or a cpuset isolated partition) or out of kernel noise
+ * (nohz_full= or isolcpus=nohz). The latter does not imply the former:
+ * the kernel accepts nohz_full CPUs that are still part of the scheduler
+ * domains, and deferred per-CPU work must not target those CPUs either.
+ */
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
+	return !housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
+	       !housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.55.0


