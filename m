Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828E1606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aBXWkUP9
Received: by kanga.kvack.org (Postfix)
	id A6E0D6B05C8; Tue,  3 Nov 2026 03:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45AE6B05C9; Tue,  3 Nov 2026 03:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934626B05CA; Tue,  3 Nov 2026 03:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 708E36B05C8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E182C1C3362
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:58 +0000 (UTC)
X-FDA: 85393061796.09.A7FC0F4
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE11740004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=aBXWkUP9;
	spf=pass (imf12.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
	b=vWNurNrZriugdeRSrz78now9Zv6QZg3GQmDy9vcBcrnMZXK/EyOx64urLolvVxBUtd8CsO
	jZw5hxMEzWOxOSh2rh3VAtMJZ7Bgr1sWHAgxgRB0h0i85QfVPXd/BmuVH6i1OIq/xDN9Nl
	1qex1INKzR7o9e5Nbuwz8k1BNTSiNqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692857;
	b=k+24S/FdLxnBnpAY9xcUR11JPmF3oZgYAfDYFFbRQzojet18sdYNkcoOZwCjay3exfT1Cb
	XnfxIi4anHeisZTUDbDluCRuLRpdo6OtpfoQOJl5DxJieo/4sMBTTDujjskriHMjkWwMfZ
	Uisoj2WElkj3HCKNumeUjvfhoWDk0uY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=aBXWkUP9;
	spf=pass (imf12.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C92F83F60D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692855;
	bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=aBXWkUP9q41s8F4rawwetX2HntceBR69rrDT+JIkZEmMbpRGvFQVMJsjQcH0JIgEX
	 J5cRmXjo0XzXJGbQAwqLzwewAIS4mHk+K+17oC4Fptsk7bQDlZwlpxbV3MLNByAHCb
	 8aTlqyP5Vd/BUHFsOU97+tb6PJJzyFZ4CBZwsNa/qZwBFm76YC7ytpc0opscAtRWzM
	 KMVONE3pyqAn1iN/Wuix7mNrr23NlNYuLUuPUdPNABjEY4GiGVdna7SRLlojx2hotA
	 a/3o9SNfwcjfyneXLgb01y5DjcCCB8mGzxFYBjMSwXE2xJH5dNQH5LgYguOJNrp44D
	 zPsR35En38yAFkykjizzT4U8yIacJvLUTylIRAk1C41NFOGMX9jkCPrS0qM4IkQNR5
	 rePvv4C8/oU7kiqCj2/KEJ5MHVMiVjED02lKtYpucF4Ram8siEvmCKPO+KTY3vmNKJ
	 gUeCganuYdEhVo7AHv4R8NobPJLRwFlOBCJa6OeZ+JeIq+HL9EgWJYl/X5L7O2pMhA
	 GCOUoHgchPTK9UVBlC/gbT1FgPM5yRFf08dAub7vDTZMfQBaK/w12CYN5MiY2Tfy2i
	 EdjL60VCz5LTrd8JjBHMYkIrQiG2zbkI/ZxpII7j8Xq7xHbwtwWyRYlV6FSb9qZ+qL
	 7x7kOUOXtbOdZu2zVwtIEghA=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c3c370b17so6581585eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692854; x=1794297654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
        b=W3CO5okqLhiyq2ZZeF3k7Nql9LGRpzZNl5pk+99jkBNkkDhy1NC+OfJ0u4Ex+bnl9G
         YVbemhjUccArcXvZOCx/e+NigpJkqUOm+TkW/s9H11mJqnSe0xNw2B+ECLihCpECXBdf
         5MZrrniKfMkJlxQJqW77VoKf/MMJZFFtlvJ/Fny4F8dPrKXNAgrpUkGYELimXRyS5lUZ
         7A586ppX4ku0ta2gYgnei0AngVXxJkTDxO0DZ6whVWOO1atTFk58KGpAyDQxP3XVnRHL
         Q3DflqNAPrlya19DWFgTAWiHgQiHl16Zf6pCXYZxbS3t+lkuAA120RrsA+NU9+asc0CN
         rFrg==
X-Forwarded-Encrypted: i=1; AKwUvByLShX9iOGdK9ZvNw3pOfgvFmWaokj4EdTm/S227fLP8eedDxY/LPR4B9et2nfZ0tPrE2E7zN7JdA==@kvack.org
X-Gm-Message-State: APuU4Z/GZ7t+KfOGOUMN8cEkf6pk7VTTHRsmbLiPEp5Xh1CkwYMWPaFJ
	jLIZghqwxLpo8YHO8r7Xo82bhx3SeLziZ5yF5RxOpz4+XRshRCyTzn4iTQ0cmtfNh5hWOCfDUKM
	Fs0ppj15U0c+r1Vfpp/j6YbjlZq/hl63Gy28v8iAssH+jdpHMcK7ay872udsuJ6pLLbsK
X-Gm-Gg: AYBFou0tuQSK+ESx1gtx7cGbffF/9a1KQAQVS1dLbJbL+wQn58UbRZYtljaIyMGkXVt
	SaQYLv0Nf5tyfrvNOxwHjuTZltnY21GliQKkNehiz4WPZlDqOQ95VhOA31K0YjU1l1VyVEtAloj
	g9kzhVaXH8NU2pItZgAHrjr3IwukSi/P2PTkwiyKWRI1D9zjaNAIaG65CoNqraUcww+AzQNRybI
	/01CkNiNcQEevaS8zrVtMb83qLqZ82K3PQSthN242Nsu3v+EmBpvqe2jkMyF9q0Wi+ExvWYOvq3
	yLUIzfm06Oz1GgKZYairrrEcjqLZ75kGhogDJh9k9OrXr7QW6ehx3IjXsU6NfJcBYHAm4v3WDT7
	r9pJfnVv6i584kz4tQ/RJPqDMGKIfBMu9TlVAACANxTGIobA32MFRL5POT4d1fEfXcXgaSiuAvk
	Db0SUdwTjg5fWz0SGQIw==
X-Received: by 2002:a05:7300:5988:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36a42426236mr18638142eec.41.1793692853878;
        Tue, 03 Nov 2026 00:00:53 -0800 (PST)
X-Received: by 2002:a05:7300:5988:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36a42426236mr18638097eec.41.1793692853176;
        Tue, 03 Nov 2026 00:00:53 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:52 -0800 (PST)
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
Subject: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs become isolated
Date: Tue,  3 Nov 2026 20:59:38 +1300
Message-ID: <20261103075940.110308-5-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE11740004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7dwai77mkanxaj6ku59wodgm18dy7hjx
X-Rspam-User: 
X-HE-Tag: 1793692856-608768
X-HE-Meta: U2FsdGVkX1+0GA0nJYSg986mOJSA4fx7IiKGGQ/PFp1TCAbfxQRy1Yls292obPPSJ9uCz+UPY+qrBSo2GzEM1qSBPgvUe62LLqxihfhYN93/Ghz+xuntgaQM6AvZh8h/0EJjcEVcptubuw77DxvRNp/I4R2xSVPzOZYD3exL0z1j/R2uXDmMzRdNoVLAIH+O8/Nmn6OL8lxgaPCSpyLuKHTB81sgskVnZcrFev7SCrkjno8266qM3F2VsQepUhD5r0Bb9K5UZkc+2j91G654A7ydDYb/ITSUWeYBW8EzPzVjGX4+435+/srzzWEeUUzm6QMu66zRMyccxSu0M4LHAoVeQ3hDS88iHFzWSO1Smr5alVBMdqP5pH5I6QJjNCoNBUby8/MuHrU2YBWf+6GFWc/n4mjon/9FmhKt1ZR1Bcr71WCxUOeQQwSAdRTbDbVntPXY0NvLewWPbi9QDyxGHcembQq61gcCNLSgepLJFQ5pQQE2BNjS9Gc7yj96zAquaXOhO7ihIwUXFDvFINC0NAxhZlgMMsIpHNTCyXicamxicCuTL0QVIEZwwudr2tArqPKODdSbq/y5G4sJ6TKtqOjYT4OiaMvWTkrKrrksLmixIdta/sKgZFUOMjcEn88/YIDXmS4hoNoDj73PjCaSLIDeTOAjpP8Yqhe9af/osWq3K7LKrSEWuqnJ2lw1a9fOBBR6SYnkEtTN09Z3qSbySVZg1TzukeZIR7MyNqKkTqnDKmTWOON1fUbjBkPwSXpKiZ0J8hYtyocCv0kc2u45NGd424o8+bbkuJIeerYoi14tgFSi9MWYPYOZfiQkfCn1CZG4Kd48g7eAQEy31ZWxumKhS1pBYCl6njWdOoyArvoUDSg5sZIX8hEfOKCU1GY+OV+qasHSMHNq5nTih0p/iJbrrJuSe6jqfiqu9VngXt2/uQafn/gPYpn100EDNmAtLONA2Ck3uUZUm/CyXoW
 a3SDtrK4
 oUo1MGjfM5QXF1q/MkaLxnWQ0sc2gTWhDHsIi2qLuN/8c8nCmZ8Falt9RxjCKbi/iiXqFvMyj5wYni2/EZtTGxTe6btObgir4rLyyDVbvhAJdItmWaQsKL/DJiZXb+Biw3vWkqm4a+5Ztl4Rb/nWSKukJREQ+49o5wp5yUjCgh0NroHToJsKfsn9GOVJvWC3Nj7QC1cIevCkhU1UDk3A2AyK5VkIeKK5IVwqOoLMdhGSIBW1p0ljvqliKbUTOm8Kr9sr2Q2+qY1u/0JGdDMXSUQwNPfmas+Zgzu+pf1EjASePDFDIoINflfOA2gdU3Ux+z1OvcGvtYfoSGPVAe48Pm0MsqnH4eqEknVZD/i+lADzI0OsF4m5fLWBY+Wo4ENXBU5PbNs22A51xoct7jgHCYHGT53X7jsJAMquUQfcSk3L5rb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
that __lru_add_drain_all() never has to queue work on them. Boot time
isolation (isolcpus=, nohz_full=) takes effect before any folio is
batched, but a cpuset isolated partition can be created at runtime and
the affected CPUs may still hold folios in their batches from before.
Those would linger until the CPU happens to drain locally, and the next
lru_add_drain_all() would fall back to queueing work on the now isolated
CPU, which is exactly what must be avoided.

Drain all batches once from housekeeping_update(), right after the
HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
workqueue flushes that exist for the same reason, so that newly isolated
CPUs start out with empty batches.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/sched/isolation.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..17d8171fe97b 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/llist.h>
 #include <linux/pci.h>
+#include <linux/swap.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -149,6 +150,13 @@ int housekeeping_update(struct cpumask *isol_mask)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+	/*
+	 * Folios batched on the newly isolated CPUs before the update would
+	 * otherwise linger in their per-CPU LRU batches, since isolated CPUs
+	 * stop batching from now on (see lru_batching_bypassed()) and remote
+	 * draining is exactly what must be avoided on them.
+	 */
+	lru_add_drain_all();
 
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(HK_TYPE_DOMAIN));
 	WARN_ON_ONCE(err < 0);
-- 
2.55.0


