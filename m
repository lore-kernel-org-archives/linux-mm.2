Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4400ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BFF18E0020; Mon,  1 Sep 2025 04:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970EE8E001E; Mon,  1 Sep 2025 04:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839548E0020; Mon,  1 Sep 2025 04:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7CE8E001E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AD171A0708
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:41 +0000 (UTC)
X-FDA: 83840020362.13.9680466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5213280007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5iytukq;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Iw9Hce2h0SaUWDOX1MFDwF186//GNl3RxkuDrJ69ko=;
	b=GbLPeGiubtYlo9HsQrOv722u6QysUwUINA0mNn8on5fTY4HxuQRUi0aF8WBRmdiMe9SZhA
	HQr0oMkV8rmxEEYgaQm6h6CX63Rz0U1KsooTXGWglFdaJHW0MW0Vb8vNiCT+MztLXm2to5
	FK9Nt2eyO8pCHB/XVHK5SuzsDf84dPo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5iytukq;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715679; a=rsa-sha256;
	cv=none;
	b=3DqCsMWKt/YLLi5p1vrUXUHzrRRvE2JdKPY4O7KGvcs+SeLNiPaEnH9TGk8wJK62dbuL5U
	7PK7Q1V1VM4iQJKcaX+kRW+pD7Z5QxAd8l4wQU58EACgS+VsMTtPJUMI0/sn0CUhXiSQZj
	NMm4Yh2pn3JtgoZ+TalnFvu+UbO2pqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6634244E6E;
	Mon,  1 Sep 2025 08:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8653C4CEF8;
	Mon,  1 Sep 2025 08:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756715678;
	bh=s7gDD17wyPWHQKbzFBz1JNHLt2wfCsHSqppGZ+0gGnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5iytukqVhx8KXkeeNxWYS3iT9qtiWj5ahsGclE358EQFNX0SghXLbqK9QR5HgNMh
	 SPbUz3nsEgsm8W939duAv+3aIjoKZ0q7Hx9RVKbIkvE0nmFUxH7b8ZPqCkfwlfG4z8
	 GGDMg37upT/s2kA4ON8tWNt5cRBdJdlWqGssqcKYQeCdRJ+vl2Ca4RBQOJLue0zbeQ
	 lqWYLLnOZvQE+mphW+5qaXI5a9CTRsPwvp9FsGsKtlF/dYwQpL7eT13qE3NP2+QaAv
	 5yd2KJoSjoUdNAq3dONOix1WwKl6cVgywQaXjRKLBIfIrRCKzgsojIl5Eh03oe6xao
	 Tvz//iPPdH0Xw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 2/4] mm/mm_init: deferred_init_memmap: use a job per zone
Date: Mon,  1 Sep 2025 11:34:21 +0300
Message-ID: <20250901083423.3061349-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901083423.3061349-1-rppt@kernel.org>
References: <20250901083423.3061349-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mdzxxwxjnq7xnnepg3hwkxkuk8tnqho6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5213280007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756715679-51315
X-HE-Meta: U2FsdGVkX1/Kl2MXhrEJaYssS9LPOVaOusTIWuCDBAOOLd16YHvdfZ5mX7eznJ1Qus0BZ62pmuIBzQCkH18XTHrjJvqzkqiAAXDn7LZBHNB/EJUDyxDzAiJJcefq0NOgRtOzhBcS0ARbBRbzyf7liXh7y6gLJIdwZ/Wxg0x2HgX9HXJE+AQdUyt0Zk1cGXzbO14K9eU9QX/zyY4QaU6xSBIINcuEIRLDnyxClhY4iaVOwUfflIBMl/ZGQajPQLn8OHe5+oN3muNXEvqiqGdpX7JNjjc8q8DdiXfgXwpDm6plwgCFeq2rUf2OVvwk6qIPyBdU1lnI+g2ih36rKX134x/0nRJWLj7K3mcfAHmEQ/KdrONBYn7uZZT+DgCKQkFLqXQby01xCSJSCZCjx+rkJj0fi2p7uhqTFCJKzTlUTQqzd8B+9nv8NG7SG5EdCYl3xYTvA7A/swPJDPYFdi4t3eIbDlKZK7MtKzr2cdlUn0S2Aq+9gg8BzDIIMIKe1NH4CrbRyhCkizgRJITAMGkjb5UPmb83ppjaKj98y7RND6KVrU0ZmODYfZY4oMG0iWHniA4K/19LoPOG/xUulu6LftiXD37J2pZkfH0AM9riWU5VJAfXwBBtlYUjIKrueNJN7sNxj9mjXQxtRCvqDraxYtVN8qo6OIXr8WhzcjpP7eiS7yy+c1bzgqkufHGOKowzb535OMPWDXrduWAVpGLlBDDnkUNfomXyznWHW1blQb755Ehbns5p82m4HfhexNRNipwJGfH3eJUeUA7fOIAJktkjo1TzQSmdfCi6MqeqkJq7Y+mb+9dqdRSbnFAlYVdk/5ptur62HxLZlJlDBpL9oplHwLTyCyLfsjT3UuTJbv7CRJ4nYhyPSzNQPj5851RAcsfyBVY2qVkuWDvzDJzVG1IKKSkX9Up167JxIdx3v4ABJnnOn9ifgk6nbAZGLjI57iQkeoXKN8sgej3n2w0
 exIwVh8g
 K+OloeZqMQSzFrbqobXXAoHVjNW+6l88HtTRYGCX7CZLhMmGDWjYqCEMnfWM8LHG02580VwIBxpMEiruVjz2Y5ylSfuaV5rT+LJlsNiKxKQ5EW0TEKK/+qnKF/8YDg+YSxSIARawT+3NtDbwC5wHA6cx5wyI8Va/isy6uOA+w6ANGkC0OIfcO9UIUuYyi7v89Sewr0Oz9zWaSbWEYMIkkF8mV1NYVRZKy6/4pI5mpEVnB6F29ZrNjMe+fLxoTgvgquX/nhlwS2FMRwe2aNphdxUnUd9DKSQHnJXoG/XP6n+9tqq0Tg4R55UaMhXkrPVjVrlY69klyb8tY9n1CbAazzgfYnC7MmYQ4PyC/pfvYdObqUKWpSPeHqOwhebINor+bTVLRF9qL2UMLcVMl3SQT2p6+Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

deferred_init_memmap() loops over free memory ranges and creates a
padata_mt_job for every free range that intersects with the zone being
initialized.

padata_do_multithreaded() then splits every such range to several chunks
and runs a thread that initializes struct pages in that chunk using
deferred_init_memmap_chunk(). The number of threads is limited by amount of
the CPUs on the node (or 1 for memoryless nodes).

Looping through free memory ranges is then repeated in
deferred_init_memmap_chunk() first to find the first range that should be
initialized and then to traverse the ranges until the end of the chunk is
reached.

Remove the loop over free memory regions in deferred_init_memmap() and pass
the entire zone to padata_do_multithreaded() so that it will be divided to
several chunks by the parallelization code.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Link: https://lore.kernel.org/r/20250818064615.505641-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index e73f313dc375..57b256ea9e6c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2179,12 +2179,10 @@ static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
-	unsigned long spfn = 0, epfn = 0;
-	unsigned long first_init_pfn, flags;
+	int max_threads = deferred_page_init_max_threads(cpumask);
+	unsigned long first_init_pfn, last_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int max_threads;
-	u64 i = 0;
 
 	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
@@ -2212,24 +2210,20 @@ static int __init deferred_init_memmap(void *data)
 
 	/* Only the highest zone is deferred */
 	zone = pgdat->node_zones + pgdat->nr_zones - 1;
-
-	max_threads = deferred_page_init_max_threads(cpumask);
-
-	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
-		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
-		struct padata_mt_job job = {
-			.thread_fn   = deferred_init_memmap_job,
-			.fn_arg      = zone,
-			.start       = spfn,
-			.size        = first_init_pfn - spfn,
-			.align       = PAGES_PER_SECTION,
-			.min_chunk   = PAGES_PER_SECTION,
-			.max_threads = max_threads,
-			.numa_aware  = false,
-		};
-
-		padata_do_multithreaded(&job);
-	}
+	last_pfn = SECTION_ALIGN_UP(zone_end_pfn(zone));
+
+	struct padata_mt_job job = {
+		.thread_fn   = deferred_init_memmap_job,
+		.fn_arg      = zone,
+		.start       = first_init_pfn,
+		.size        = last_pfn - first_init_pfn,
+		.align       = PAGES_PER_SECTION,
+		.min_chunk   = PAGES_PER_SECTION,
+		.max_threads = max_threads,
+		.numa_aware  = false,
+	};
+
+	padata_do_multithreaded(&job);
 
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(pgdat->nr_zones < MAX_NR_ZONES && populated_zone(++zone));
-- 
2.50.1


