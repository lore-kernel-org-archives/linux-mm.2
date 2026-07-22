Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCF5C44533
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78116B0092; Wed, 22 Jul 2026 03:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F916B0093; Wed, 22 Jul 2026 03:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0FA6B0095; Wed, 22 Jul 2026 03:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F58A6B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:48:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECECA403BC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:34 +0000 (UTC)
X-FDA: 85015635348.17.9FB0438
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 668CF1C0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H2llrjcQ;
	spf=pass (imf20.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706511;
	b=owwX5Yjn4Jmh/5hbzj75sFERvI+AFk5t+9/l7ewdVVelgRPVxqavzlOnj2/uaGge/zbZRc
	GmSH4zHNXP4lU1OGvlLxusRefZ1OeEbhCs/ihJ+Y5CK7XA0cjSa9Xm+nq2EgnzgyPKpO4W
	IiQeJKQ+x0eAIKAOY8TbypnzqvWXlnI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H2llrjcQ;
	spf=pass (imf20.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+SVszRD0Hy0NMbJMz4R0jwnOEB3Hazg4a4qbEeUlZs=;
	b=oahXWSbiNIy1jQDYHkLZ8kOIaW8nTE0uKE1f5FkOeG4RN/lJAzyvNBZveWCzgiL/h3Wz2S
	YraJujjKgYyAzVgrFXtenPRrlf8XofocDU7hXLgS52o7wIUK3o9m4tNSTu6vtRquqi4qOs
	53JeCeTQNW4ZMV8+vpD6To1TX+ZnsqI=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5C0EU1271586;
	Wed, 22 Jul 2026 07:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=q+SVszRD0Hy0NMbJM
	z4R0jwnOEB3Hazg4a4qbEeUlZs=; b=H2llrjcQ45kPBAFp85fxROUXG6XGXv5zd
	ZPL75X/IN+wmf5hHCPry9st57wVl9cxlOrVSlqPYnhSyOx0/VmlXLT38JG8fgPOI
	sj8TS04wUT8grgFnbw/vQozo86YMzl1uOykTimNlfBgSJk1KVPnwKd3rXbU5qC7c
	NByovbpjSoriGceuqWTzRjxU3PRUsDxfc840VM2Kx5tVVeY2Fi+JS+1HwuCbmr9W
	H9jqR4zw8vxhieNuvPAuCzwE49NymbOUUam0EN1IB6KluHhMg1Zq07UYPYveWSYS
	fdxGcvl7j9QZzrhRcPMIOs51f/LcfS5WiX7VjV/lODcjnqp06OItQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77agvxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M7YdHs025677;
	Wed, 22 Jul 2026 07:48:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgye031-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M7mKir42598754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 07:48:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 721A5200CB;
	Wed, 22 Jul 2026 07:48:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6E5F200C7;
	Wed, 22 Jul 2026 07:48:16 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 07:48:16 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH 1/2] mm/memory_hotplug: bound offline retry loops with a configurable limit
Date: Wed, 22 Jul 2026 13:18:10 +0530
Message-ID: <20260722074811.378283-2-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722074811.378283-1-aboorvad@linux.ibm.com>
References: <20260722074811.378283-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pkhTd_16EluoY8tLFUPZrTKOJvkWpufK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfXxHt0Z688QQyZ
 9GuK0Sc6vh/v+M+N2lIGjUJfqNJWV7jwZfLtVPq5RrJSwobld1o9mJOjD+JGRvSzubiKXtR5tWO
 H8WzJeUySMhYFFuOrpDNtNd0hCuWzDk=
X-Proofpoint-GUID: bxHTMwvfEkE9Dn5DcR6t9yZI0KCsbuFt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfX2790NWheW0MH
 pPM4vRXlTels4V+flZvFKgtK8WwSePrsAzT8cFJhgz9d017YD4GtfuZdSa53MUECXftZVH2UanR
 2FGfzljB6spCD1BuNnpBaWgm5EdvcM5xZBgaDKSqMdjuc+Bl66i9LJmjSYXX3/gwPfEEsFv3rYp
 qXGHMx4dpni2tE01cI8oleg5NLOf7ox4d43VksCrzvPP8mKUC4H77y6CM1c5+fDb2TPUuFgC4vQ
 wRqwFBT1kDQ/rWnpZhve5jV1ceV7T/qGdAPfQurI+95A0/aE2j6OZDtPUhZXuJQN6c4SNo2evwf
 pfUADq5HjfScvDUGTFaKChZqkw0D+OTbzXrRdgMcXwNgityjgolMBKwexmE60yQ1IaRRCeViJyA
 81dct9X7mKisBbifQVpn7w3YK+MNZpvj3UjSkc4ae4GR3ZJySdwT1EksjhU+ZAoR3/PCNlwYaq5
 2U5eQ0vhOkWZFYD4cfA==
X-Authority-Analysis: v=2.4 cv=K7AS2SWI c=1 sm=1 tr=0 ts=6a6075c7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=_mUAl5CdPfijK7iri6sA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220070
X-Stat-Signature: 44nrzuidd4d7dttk8z5snumgpqjfrzt4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 668CF1C0007
X-Rspam-User: 
X-HE-Tag: 1784706511-278185
X-HE-Meta: U2FsdGVkX19N4OuUuSS1ZkHMMflf5eR0ATIGGp3mNdGxStlWdIqjZEClnKDSOa/KmSCgssYBh8jae4FLbvu0uXJxsiy3Yy4im3yosT7fWM2Ez0mYZx1Ol5FZc+pUJNoq1h5VrHqVYuYHRTTW9/Cg2Xad/ilP10L24bqNijoDboFbM3PD9MoOvUvtkxrurPEayT0sdaVLI84QEjj1JUpzpEMfehgynsGywq6Y1HWRFqceBzBiqYAJ8aZ4euZt9CD3ldDkcTZ7LmJhNXbRObDG3rEBbbdMibyLuZgmWTeWHr/gkPw3Dsq4OgRciN6GYHqL1+q31IRQDiWW12xluGDiXomaPTPUlrbPvc6fTcTOUb91dS8jrLv3UDZLAT2A9potkn6fvF5/T+Tkmg+01DEWgNXQ0dg69u800dlpbTYrwxrvNwR8637ZDr+Gyr7XqIDvObEcrMFnAnuGIpxPli8eUuDKK7475w+KDXPm63P8ZqLvnAQGXb2ZYv0ME58MX1eSy1XS/+WbvOP3EMNMnr1QVQKgLjIoGDM9e7iaen6CZmDzKztV1Ziqb705pbtAMIQWgJaoooYhyAxsJtCEjU5OYfUBVJVTINBfqMqvgt8jIcuagQC7pIm5G2Kt/E0p3ybPJBOkoK2d+iPBFcuQdIsN1eH0JiA06uoGC3aOmN0nWS6vMJmeEjucT5Tfe4hPZN5l3/OXIjtxoX9pPxWVHfOykb4Oe+TqNexK7lhjQyvq3fNBKVQ23h05ZEaggqZzbUtsKF2DKoKy0b8VxgeTkLvIpIfRmx24EWbhqzpyaPHh9JVl6iSw50HT4qVytWmpPuOU1ptcq3o99pSB1W0z65rOqOidx7ppMJNr0kekDOZkorClfoa/a7EzJ0OrUTof00ozRR0X1crRETho7SiS3Lt/xTRR02OmyXsuVd27LUZRWQe4nQsbWJ2nlutv6Wt54JPLF/17LI8V0Y62hYpmDhZ
 sztAYxQ8
 9V0auroY0DnrJAFmVzSSVzcGh3zQkMRQYVzLTRFM4gc+P2zE6E23bFLpEdJmeJoKJx3P1O6CljYsoKeV5bsoRWPDuFawMzHU3Z8X0QMXxBdVLVm+WC1nMbRoppeKkf4HUK4q5qvtIZMiWbgXk10F3ZY1WS55o3k9gai24NbEDcEOTH4o0xVnoqv6G2sA10zsxlm/0/LnMjL54Mc1VpKloyNb9G3cYP/BSBn7Heb7W2aByeXg7xULzqEotgfPgU00tIqgf/mqoxUhwzaMYAfKgSlAs4S+fOI6HCKc70NB2EsICDg4HF1nw6ZR4TEb5it2IysQuWUyOlkLr4/ftrrvK8Rw7uFx18kobcyhTUQk2k+WIY+tLb7nJQhINE29SlJ91uxyP5h7u1eX8Puvf/eu72RTdQW31FMUNBWQK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

offline_pages() migrates and isolates pages in two nested loops with no
upper bound.  A page that can never be migrated or freed (a long-term
pin, or a slab page that raced into the range) keeps the loop spinning
and the offline never returns.  This is a known issue, noted in the code
("TODO: fatal migration failures should bail out") and in the admin
guide ("memory offlining might retry for a long time (or even forever),
until aborted by the user").

The only escape is signal_pending(current), which works when userspace
drives the offline but not for in-kernel callers.  ACPI DIMM hot-unplug
(kacpi_hotplug_wq) and similar in-kernel hotplug paths run offline_pages()
on ordered workqueues where signal_pending() can never become true, so a
stuck offline wedges the workqueue and blocks all later hotplug events
with no way to abort it.

Add an opt-in backstop: a counter at the top of the inner migration loop
bounds the number of passes over the range.  The check sits in the inner
loop because that is where a stuck page spins; since every outer pass
runs the inner loop at least once, this bounds both loops.  On the limit
offline_pages() fails with -EBUSY and dump_page()s the stuck page.

The parameter (memory_hotplug.offline_migrate_max_passes) defaults to 0
(unlimited, today's behaviour) and is re-read every pass, so an offline
that is already stuck can be rescued at runtime by writing a non-zero
value.  Such callers already handle -EBUSY, so no caller changes are
needed.

Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 .../admin-guide/kernel-parameters.txt         | 14 +++++++
 .../admin-guide/mm/memory-hotplug.rst         | 26 ++++++++++++-
 mm/memory_hotplug.c                           | 38 +++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 53f08950a630..90b67c457c2a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3980,6 +3980,20 @@ Kernel parameters
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
+	memory_hotplug.offline_migrate_max_passes=
+			[KNL] Maximum number of migration passes
+			for memory offlining.
+			Format: <integer>
+			default: 0 (no limit, historical behaviour)
+			When non-zero, memory offlining gives up with
+			-EBUSY after this many migration passes over
+			the range, instead of retrying forever on a
+			stuck page.  Each pass scans the range and
+			migrates what it can.
+			The parameter is re-read on every pass, so an
+			offline request that is already stuck can be
+			rescued at runtime by writing the parameter.
+
 	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 0207f8725142..79b45109c408 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -224,7 +224,10 @@ increases memory offlining reliability; still, memory offlining can fail in
 some corner cases.
 
 Further, memory offlining might retry for a long time (or even forever), until
-aborted by the user.
+aborted by the user.  The ``memory_hotplug.offline_migrate_max_passes``
+parameter can be used to bound the number of retry passes, making an offline
+request that cannot make progress fail with ``-EBUSY`` instead of retrying
+indefinitely (see `Module Parameters`_).
 
 Offlining of a memory block can be triggered via::
 
@@ -547,6 +550,27 @@ The following module parameters are currently defined:
 				 possible.
 
 				 Parameter availability depends on CONFIG_NUMA.
+``offline_migrate_max_passes``	 read-write: Maximum number of migration
+				 passes for a single memory offline
+				 request.  Memory offlining retries to
+				 migrate and isolate pages until it succeeds;
+				 a page that can never be migrated or freed
+				 makes it retry forever.  When this parameter
+				 is non-zero, an offline request gives up
+				 with ``-EBUSY`` after the configured number
+				 of migration passes and the memory block
+				 stays online.
+
+				 The parameter is re-read on every pass, so
+				 an offline request that is already stuck
+				 retrying can be rescued at runtime by
+				 writing a non-zero value, without a reboot.
+
+				 The default is "0", meaning no limit (the
+				 historical behaviour).
+
+				 Parameter availability depends on
+				 CONFIG_MEMORY_HOTREMOVE.
 ================================ ===============================================
 
 ZONE_MOVABLE
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..9067829349a0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1785,6 +1785,12 @@ bool mhp_range_allowed(u64 start, u64 size, bool need_mapping)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+/* Max offline_pages() migration passes before -EBUSY; 0 = retry forever. */
+static unsigned int offline_migrate_max_passes __read_mostly;
+module_param(offline_migrate_max_passes, uint, 0644);
+MODULE_PARM_DESC(offline_migrate_max_passes,
+	"Max migration passes before memory offline gives up (0 = no limit)");
+
 /*
  * Scan pfn range [start,end) to find movable/migratable pages (LRU and
  * hugetlb folio, movable_ops pages). Will skip over most unmovable
@@ -1966,6 +1972,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	struct node_notify node_arg = {
 		.nid = NUMA_NO_NODE,
 	};
+	unsigned int max_passes;
+	unsigned int pass = 0;
 	unsigned long flags;
 	char *reason;
 	int ret;
@@ -2062,6 +2070,36 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 				goto failed_removal_isolated;
 			}
 
+			/*
+			 * A page that can never be migrated (e.g. a
+			 * long-term pin) makes this loop retry forever.
+			 * Give up after the configured number of passes.
+			 * The limit is re-read on every pass so that an
+			 * offline request that is already stuck here can
+			 * be aborted at runtime by writing the parameter,
+			 * which matters for in-kernel callers (e.g. ACPI
+			 * DIMM hot-unplug) that run on kworkers and can
+			 * never be aborted by a signal.
+			 */
+			max_passes = READ_ONCE(offline_migrate_max_passes);
+			if (max_passes && pass++ >= max_passes) {
+				pr_warn("memory offlining [mem %#010llx-%#010llx]: giving up after %u passes\n",
+					(unsigned long long)start_pfn << PAGE_SHIFT,
+					((unsigned long long)end_pfn << PAGE_SHIFT) - 1,
+					pass - 1);
+				/*
+				 * Dump the page we last stopped at as a
+				 * diagnostic hint: usually the stuck page,
+				 * but just the range start after a restart.
+				 */
+				if (pfn >= start_pfn && pfn < end_pfn)
+					dump_page(pfn_to_page(pfn),
+						  "memory offline retry limit");
+				ret = -EBUSY;
+				reason = "retry limit exceeded";
+				goto failed_removal_isolated;
+			}
+
 			cond_resched();
 
 			ret = scan_movable_pages(pfn, end_pfn, &pfn);
-- 
2.54.0


