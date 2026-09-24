Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C621C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723726B0092; Thu, 24 Sep 2026 14:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA566B0093; Thu, 24 Sep 2026 14:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6100E6B0095; Thu, 24 Sep 2026 14:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37FC76B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:47:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FAB9A0492
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:42 +0000 (UTC)
X-FDA: 85249539564.13.2F4F7FF
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBCB414000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EJS6RQyB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyMImCapnMHOINq3vX15RaJqk3Q56SggRfqHnR6MQ8I=;
	b=To8cZAaUwe9tMJjBJZXck0fl0OdFD1hwTpNQhSEysN8iirccyYJBWtfvAC4NUHRMJGBqhg
	owOS3kW/em4K12FGAU4YkXJOWYqwUeL8k9yETjElyFfkvp6I8SxoZ/QAZlusAAzXNLWhV4
	dcljqmwZ8Y5sH1LSe8LHN+NVZR2LlrU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EJS6RQyB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275661;
	b=EADWhp+JTGPcAKoWF38iCpmpmDw0a6AowrWHRg9UexKTl4ExDqCOdOnFsyZ9i96n8d1oH2
	8km7OXHZV8lBnAoMoXdVxH6UgZLYm4TuBTtG1gOWEgYVkfN1Vvhw0HlAmEQnovk4HHCh1s
	H4CsdLc1ImtJoiPsigb8NA7uxM+hgZw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KWYgNto++ozYhoROAlYfWUaWx+IZSfR+cITBgAkMrPk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275659; v=1; x=1790880459;
 b=EJS6RQyBvI4kdMwid/t72yspTC/ft+HdunWq1xt3FKePia8hnUzLZ68YpPb9/P2zkUmXJGvL
 wUfhJq3osfiuo/AR/PgmGj3w7nkSOgsc6sejcP+fJ4fbmohnKqD14o5U4Qca5HQdyy/0G3cLXRT
 BDXlFlZSf9HlNtyOkwp5gdm8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 44910fe0e13f3b28;
	Thu, 24 Sep 2026 18:47:38 +0000
X-Mizu-Trace-ID: 44910fe0e13f3b28
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
Subject: [RFC PATCH 1/7] cgroup: add cgroup_account_system_time()
Date: Thu, 24 Sep 2026 11:47:05 -0700
Message-ID: <20260924184714.912181-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: in8c4ep3q5i7sxzripsthgkcdrzmnqtk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BBCB414000A
X-HE-Tag: 1790275660-655166
X-HE-Meta: U2FsdGVkX1+Q51FnQGiomqMN62o6Gd0N509/By357WC6a7/Yg26WkmahC0q4f78MbCVlx1B176jukdieqAgQ6mjuBQHiUBZ2hKZUGN/v4fq/+MYnH4qZulS3P8PXE68TPvxZ6LY//qG99uM53WFXm4eibLmhHB24ccp6mwE30ACyj7ZQhWwAUBG/w/TPLhc10zmpudfntQRLVSuCasZqjZr4TRWGz+JGWVay2ZN1mUy1jISOdDA3494CVNl8+O72KcfRUw+OBUNNpJ19pY8XsOOlDlASpJMuUx23Ia3OX8rE1ZKJ54tZRhDWz1tRY3N7XfYSaIAMvfMTd2YZj4CFRgqnKDgEQlLsrmxTSEl9TTocFEKP+9Aq7FenS+cYpGSBIvWgKj3uqWcmiCQR1xtQAPRdf2+3uadnr5w3S6f1sw5F9a2AD/n6HJkCkXenUEMFTj52S2Y7UfgVuP6zQlnPOeWjGja3LXVtPrRpENfeYkh0jlpDn3lcdjH98CO0br6ZvVkqUwuks/Mfd8UL2wQZNYex8/cM/pWTT/SXY3d6k5mudNd3eRsOTO8pAU9ZhRF2YhjxR5USE2QxJuIuwlSK7DyygiQRO6MueghXMkYwDSHFQGbWFqHDycijSJhQSKxdVnbMxkPdQaBjfCBy2OQPS3/Dz5mrNejhDsbOtJNDA6xpGaiVolIRNyGBsoJsPcqspRlbzJBrLjyvT24++3+Ap468aCeCwkI+z1mHkSctNmcwCGBeGtLiqmo7Ur2UQ3qqrawgEQ/lwfUTCVXfUpbZIvSeTTEEG/NB8QAJCgCKVCtd9+jBH3DYm8w9EuCEDrpRHK8ghWZlLaV01oGLVfBFrLnjOfBd0ohMRfN8tJIBd24BMi/Viq7vKEfnvPV62ZDGFh7c9Y4W2gbBmDZ5CABkOG2o7KaQgzhj3Xmp+b5oeep1bKzJcgkjD+0tFPQTYrUThSFJhz+NgiJIuNHnNWi
 2xeuLO+u
 g5vVQFtb+HzHPP5DAOQ10wuUtWBDm2Az+0lHdhuT2JzDfpbjXYyKyRlElh59ZXvoW2HZba7odafOujU+3Nfja4ghVvqPikjm5aH/+Ws8lZYnZ2JHqpLlWK9tG7qFZ04DEeGa44np3EhyE0fDZrRJaLwqaBvyt1iU4ssFDSwQshuufz91HFWRioz3S/Gb6Ov3mdG/nMyEUwqX5Xj66Ht473kuDSrXsx0ojdVutTiMQQy5iUQhoGTxDGMseU47c+zJ9XmbyezTaaU/DZwqswrFHnndXrkRid29DtQa+uxHylyb/7ZT/Hi1SEZHLeQHPIGR9aTzsbSEOfnqBvciVLoWrYzU0lgLFNin4QIv8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper that charges some kernel CPU time to a cgroup's cpu.stat.
The next patch uses it for the time a kernel thread spends working for
another cgroup.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/cgroup.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2afb4cb2bb4f..7b19ded2578d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -868,6 +868,17 @@ void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec);
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
 				    enum cpu_usage_stat index, u64 delta_exec);
 
+/* Charge @delta_exec of kernel CPU time to @cgrp. */
+static inline void cgroup_account_system_time(struct cgroup *cgrp,
+					      u64 delta_exec)
+{
+	if (cgroup_parent(cgrp)) {
+		__cgroup_account_cputime(cgrp, delta_exec);
+		__cgroup_account_cputime_field(cgrp, CPUTIME_SYSTEM,
+					       delta_exec);
+	}
+}
+
 static inline void cgroup_account_cputime(struct task_struct *task,
 					  u64 delta_exec)
 {
@@ -900,6 +911,8 @@ static inline void cgroup_account_cputime(struct task_struct *task,
 static inline void cgroup_account_cputime_field(struct task_struct *task,
 						enum cpu_usage_stat index,
 						u64 delta_exec) {}
+static inline void cgroup_account_system_time(struct cgroup *cgrp,
+					      u64 delta_exec) {}
 
 #endif	/* CONFIG_CGROUPS */
 
-- 
2.53.0-Meta


