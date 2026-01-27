Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04075D25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B57C6B00AC; Mon, 26 Jan 2026 21:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FD16B00AE; Mon, 26 Jan 2026 21:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8876B00AF; Mon, 26 Jan 2026 21:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 470766B00AC
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E75F9C2D7C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:19 +0000 (UTC)
X-FDA: 84376202358.20.DF7D454
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41B97180004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMfJCSSQ;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEVQFK1CrN96TOQDcyO6X4A15QdAoRxZUpYERHQ3KZk=;
	b=76qf5ohjl8/anLnO8xzw4MFh2k5TRU9l04SzdPiKxsRZHuZLJoQPz30OrMoV84e4eWG2TU
	tcur9sCy2QAhekeLpvGZSdJvrpzGUXyz7mZDOZN8z+oL+a6IjkRQhfRIworcXBqWwG+JrR
	ugPXYiZukcklzz2Ybp3zzOkiJBoQ52k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMfJCSSQ;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481918; a=rsa-sha256;
	cv=none;
	b=FPLVFvEe5plk7xmI4NhIOCpNU1wombSPKEJN+yxFT6PPYso4MAA0Ex2i7clyqI4OVm0kDU
	TV6b//gMjMJXenLrIKJM2vgbkY/WkJZzdU5nJ/kvfMgWGgp53EBa490NXOt7Ma0fP70pKL
	ezuku/M5JukB0PfDeoJUVtTPGsPYgvc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FEVQFK1CrN96TOQDcyO6X4A15QdAoRxZUpYERHQ3KZk=;
	b=KMfJCSSQf2P4ZrLUijVUpTvZRdY8hJlZWg5fUctzU6XA6R1FwG/I3xdXLLAANwqQTt/t36
	GGuU0FtZ13SPc7efjbHnzSqGimTuBtLyBvAMBKNvtYrc1v1hyaFCZNEz+RlmguXGZFbCgi
	ZX/9xw+Dj0mu/vZh5Y1XMhlXp4j9vi0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 14/17] sched: psi: add cgroup_id field to psi_group structure
Date: Mon, 26 Jan 2026 18:44:17 -0800
Message-ID: <20260127024421.494929-15-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7ksbosduwidhhjr743ac6cddzeczfw61
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41B97180004
X-HE-Tag: 1769481918-848087
X-HE-Meta: U2FsdGVkX1+dn/r5LtlsLDGYwTJ1m6VgMsOTtUnC3pgjfwa7xYvp7Pq0XioWbthuQGU63tCr/FilPRfR783PmkXBwxxFIcj1s9az6+cWOJzhU1J9zFuLlGw/Be7BgcqNJwdTKQYaVq9SS7IUtz6uS//BKT7OZqa0+96th4g59MGqBm/8CZWgiX4f1r/atKM7Ugz+A/bcQkM8QfdYQnvbCLqXxCTdMnnZIwcHqntAJxAHepfH+o04x4docXSuajIl8gDzMeqqIbVRt81K6v7AFNLyHB2Ot+Kx+/ll3nSX59QhwWP8mxTJc55HCEVX+yevnjRXDJWxz2F+bxo/99YSKyC7dUHwyJxOEjfq0SHZS1NFD7AdvdwR3O8CEYsVyrLB5NRL98TL4CeuIutZRwVeVFFlIAqH5N6TuBtqs1PZ57j+5dz7X9PQdeRg/aH/efgZFUDol4ngyUgFuITewI0C+PueDCNgbqlFerY1s53jyDnW8jjy1zhPND/A9uRHttBpH4XW02dYChuQRf1HhdIrWxs4KckmqmICp4Vi7hPxSe8Yd2u9Y5Q0RJ6hsIUn+3UNcKAdXCbu2DUzw2MFhyNjUe5WpEHMwZ9fg/gsmKwaHJBJVLef3YdpjwLLfG6+1XwCYzxYeKaBKt8yAb2WteBavHvNahayzVM7ovOjUirEGHPSxdWK8ptOhlblPQQT3LyRj/NejZGH/PzQnoAVyrm9tTe4AZqGjZO2UCIyfcThM7edCtF4vtawnSk7suJfi5GSXUHu8cKwKd4pjM/sMtjnwioGdQDrfq/CTC1rVSsZ1BDtqCyMacmU5RjhxadP7vQuc++k0SW4cLR7LhQpm354qeQwv5srkT5nz31ZjbnTK+jWWSJJJxuC+vIZJZvGekElMgMmIoii1qRUiN9sq42AIUWyba0K6trtcSShEWvtm2/sFHxgLUzbn4qt61E7kqi2lEfcj12n8h3+Wwtq1JB
 Qu/+tnRg
 WdUWAM2Y59no6IqzfF7hw+lgR8ztT+qdca9T8PkCUMAbEfe2mJhpqhnRIgurtl65sL6ns6nSUDAnIvoUBASZQIYo55sLfjko8epa/N+PQeNyBXoggW+2nirTM/qdbhXhxFbXAgOJfmQD8CbvwUlCfu+SaD/nyx2ntptSHrAOUvGMSDJZct83bj0eAfXUps0y/ffdxuQ7rYxWog80VqlJPWcmsHcBklIc6YE0Sf4f7Ua5Xg5LqW/OG+gnhCF3w1kyksuNjyP0epFipIoTRhAn2ONPlbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To allow a more efficient filtering of cgroups in the psi work
tracepoint handler, let's add a u64 cgroup_id field to the psi_group
structure. For system PSI, 0 will be used.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/psi_types.h | 4 ++++
 kernel/sched/psi.c        | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index dd10c22299ab..749a08d48abd 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -159,6 +159,10 @@ struct psi_trigger {
 
 struct psi_group {
 	struct psi_group *parent;
+
+	/* Cgroup id for cgroup PSI, 0 for system PSI */
+	u64 cgroup_id;
+
 	bool enabled;
 
 	/* Protects data used by the aggregator */
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 72757ba2ed96..cf1ec4dc242b 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1124,6 +1124,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (!cgroup->psi)
 		return -ENOMEM;
 
+	cgroup->psi->cgroup_id = cgroup_id(cgroup);
 	cgroup->psi->pcpu = alloc_percpu(struct psi_group_cpu);
 	if (!cgroup->psi->pcpu) {
 		kfree(cgroup->psi);
-- 
2.52.0


