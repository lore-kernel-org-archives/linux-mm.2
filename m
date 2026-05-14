Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F82CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E47E6B008C; Thu, 14 May 2026 17:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E0B6B0092; Thu, 14 May 2026 17:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DEE6B0093; Thu, 14 May 2026 17:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3CF26B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E4941C0138
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:54 +0000 (UTC)
X-FDA: 84767373348.17.1A1E33B
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 099C8100003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=amptX5dC;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ot8e9s9wEWPY8e0IKULsGPR22o/8zTD5eyv3hI7CBS8=;
	b=z0G7bEktJS2pDuMiQyrZDSDCKXaeOqCce1fUPDLkZmUKGCs1/gsQWQQn4TVeJbtFqr4PrK
	KNGUgNy/C9GBW0d8dwhu86TuSl1QvA0FQMAfRv+YKHTNRr4O404mfyuuqYzxrRnXzjLYWL
	g1MNCceg+fvQq63iOX/OC3e4r3fJeLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795512; a=rsa-sha256;
	cv=none;
	b=iu/jaVyYMSWOOKKxUaqIqBhs+bDdl5reQIiaC3zkjDOOGuKRI7d0a9vevdQ9WiKfxynrzT
	+GfifHkdVJDovptG8L+CQIZqLa1p5MnuR/Ow5V1cGp+8c3hMHJTgKJ9+WL/fqg02G3TGBT
	5rnvIbVdLmWXXZtHHi072Udbp7cbMOc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=amptX5dC;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgZjR788995
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ot8e
	9s9wEWPY8e0IKULsGPR22o/8zTD5eyv3hI7CBS8=; b=amptX5dCAhpcnMGmuHLT
	GYOn8Vyq1JSUuTaRKvpBtp4cP8ObZJDxT/CCcaLdO9j67TZKns3IqaI0gwDxMfri
	sZ71s+48zMDhznNI5m8HKE7ePWk5fVxvvLhKPxt12xJjWv2nss7XbWFa1XgLyRi9
	0AR6y6+jHz3Wg9TYx6OVohvAKySgnHEfrYfXp/EjQT+S3qyxvM+il3WnRtGDbqTR
	09uaHzbDh9rC22KUjg/cc46V0pl8mR8vESanql4dUBrPmKGzKGzbzU9nqubUXNNS
	Cz6BtlC8kk8av73Apy9e4SkRvFAgB+t3i9HIV8Ns3CfPiJApjoJggTBJSr0ZVtxD
	kQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m299h80-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:50 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90fdd724bf1so570997885a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 14:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795510; x=1779400310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ot8e9s9wEWPY8e0IKULsGPR22o/8zTD5eyv3hI7CBS8=;
        b=pV2yToRPFXFkjc6k9vImxjGOjCqBMkIiwOslQP3jGepVoy56KpTP1BCypFKzVbrwEQ
         +yXGzbHZakAP8JTW9n9enlmlh4wwVazoCekcryrekpZaGhyy28Pe8Visajp2oZpqtmjn
         cqwZWFNsfMHBSWnsuHs12/VtdwV4KpNJqB8vwNMt302NHm9AojoSloiX9cLR/Wn22VId
         x7ndz1G0ZZU+76THL8CBYi7gNgK2Dme5mJfkzSeBKGPlINZB1PzrjOUKWyYzWA8v22eC
         a/AIxPyRb7VbPYCiH50umK3n0A1kw4CufwYSQsXB6+pMFtsuF5rkAiAJ1LpDtDm1aADL
         3OKA==
X-Forwarded-Encrypted: i=1; AFNElJ+HCG5nSB2m65uQiGZB1tEo7M4mH2zJ9+XWxqD3BN7J2VIfHl95UZJChVEoAYz1962Lc0hPblWdxw==@kvack.org
X-Gm-Message-State: AOJu0YwiD97Y1LC2xI+6mXTNzDG+QtbXlON+ekSzRctfyccj4ELGjBCw
	o3qzFgit3arWgZEZkd6L/p6swkr3YKkvnMuKBc4FwB3kienqvnToA4yZGcLdkmudgO058FU6grB
	aEWfCBckzzJSzYnZ6/wkb1yvvHzMIkUepNHFpDErsH0IlN0Jk
X-Gm-Gg: Acq92OHMrEelR+mpuH7FNegagObIR+RR/xaRf0avNEG5TvLsFVr4QdJcngxaRBgGtQn
	AaqCtXbuiNlCWlea1XfQK5G5h2mPZ3xtGC06SHKcg7GQeoUyg5Ep9DD/JXRTns7KBc+wQs+EQ+s
	PUQYJWYGNSj8VrujC7poag2N8KLo0xsve3Op6fqkBzX5qYkS5qEGyZAU8lss/h2EM4uaZxQyyUL
	1oPcqRqAjQYX5SN1T1CrQfI32anp1SklXRt8V1iz098lh2IJetKjOa3hi8qxobYF6C7As2hHe6g
	7gMj4PfDILTecrbJR1IpT0082+FaAaEn5FHOK5w1YMRxCR9ueCcIOTb81/xiHxcizozNBbx68/J
	tr/TlVFR/zFM7dRlfP6+5RN8Ti7ZrNmulmSB9YjFur/E=
X-Received: by 2002:a05:620a:7112:b0:8f0:7516:da99 with SMTP id af79cd13be357-911ce90bc41mr243015485a.60.1778795510070;
        Thu, 14 May 2026 14:51:50 -0700 (PDT)
X-Received: by 2002:a05:620a:7112:b0:8f0:7516:da99 with SMTP id af79cd13be357-911ce90bc41mr243010885a.60.1778795509581;
        Thu, 14 May 2026 14:51:49 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:49 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:14 -0400
Subject: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=9111;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=oc6U7NpIca6DPcliabejSR7QvsWIVWFdwf+uh6U3Rsg=;
 b=at5gcGpC3+Y/wzEruMkgdaBcuT4Jo3oZWqaJdg6p+Uy1AWNOkr00RFSEU5rxarBI4k5fCGW3W
 OHd6hHEUgR8AKdSok87SSLXOCUi+S4svySklPkFKz3mCi8gj+YE2QgR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: t9DYDSwNj_Ur_gEDs2OB67Ij53J9Zur9
X-Proofpoint-GUID: t9DYDSwNj_Ur_gEDs2OB67Ij53J9Zur9
X-Authority-Analysis: v=2.4 cv=Wuob99fv c=1 sm=1 tr=0 ts=6a0643f6 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=OwvvbMMXozzxZtH9MBEA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX4kXUV5GgZDW/
 uYw0enM03AC3Oy3XDgiDH5fV/eE1X8DfD57V1xtnL4rTKVWR2qEq+VlimIVUTl5+oZCUDGwDoW5
 fgUDS9koJEbnjSMbZ1dsARiIbECrvobhqVZ7GWJz7tGhOLkKT/ESWRz/m9Tkx1sYDCOxkE/O5xB
 ev3ke3zBECLBeU4xBgVxu9W5+4QcoKKK2n3Sg3715fpAhxjGuJBxLxNe5uIAKqTbM2qVHY3OBS3
 j6R9ougzRZxiWxXPwQIXJaSoB4ozoYsD7V6Q4YSGsA+sIwKoM1xQTS/5EqLnbvLIVcmNix+Srio
 Fuhl61yvAHcE9FjvInoAG2DWCjzwhHHXyuxSY2Bw/EHBnf+PUoPwNke86EiZNKY8wHP0Em0h0FW
 amUwxCpKiKYCeluStHueWfmxW4A7NBpgU5lbYWl73+rUuW3Sl49fd61D1jfvRt5cVybnMCHv8o0
 QrXeH4gG9OD6zIu2IAA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0 impostorscore=10
 phishscore=0 lowpriorityscore=10 priorityscore=1501 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 099C8100003
X-Stat-Signature: qhiep9ixenfsyu9aiyc9smfqnmo6snyj
X-Rspam-User: 
X-HE-Tag: 1778795511-324436
X-HE-Meta: U2FsdGVkX1+5msS0EUQnSqlwlpw43f7WRKVYCiGU5qlHOWnUQfGRUnekXuf6SIIilzPxEMTPxCWJangQ4DVCWaJNn+rJ5bwj4TDnjOkRn7/Bw6mV+YwViAmQNCdnPBa9IEvNR3xCP5NZ+rbgn6p5JN4im32qxCqQu0BdHhBwmkXE7OlhYrBUBgkqnLYvpACgsHZ7eOXmCdOQwpl8eI90C/XxuG25YP14clAi8hMokZEkfiCw0lpA8bwoQKhd+LJk0Pbdkxxpv7PspEg9LIUAAc6x3WAguDE1or4LL5FOOlJup/VTTrupI6qY3JcZuBjuUOj6Ze2AsTLdz0bzHMgaORm/tWb0AR0KUExsDkZXz0O2SrKLNRYwjrXcEs+EABHcB1WjasoN7/UkrWg05kJReHmkaFrcZiNzzGCba9v+ZS0pf23mASTRGO8fTA51VJraxjADcIkD/gU9F4T9u+u+RUcFRAvya6m9GMjTfUOTFGditP16PefxqGS9tn8m2B2/Fx7IpMza3/GmI3TO2yrE3hYxTJogN7tubH7TXXWLNeeScEHQt3MwBTW5Ijr9sMqla0p2n9Hq/c8cbSrFrBwdb8b5r3SEvfKInNiyQxtfxoubBHfTf2ZjXiuh1mHyuo1PHUaLrEedRBNdZwAOrgmVBqvuf/H3Aj39y1X+EL7WMPKFBKjaS7oJmBFeojeCzVib51RMWJNDwYDDwcM5uEiavPBQsP6gedH+43VjS4iXPiVChIh1SXD+e9A12SfJY7D7CDpoxos8szvxR+Q5a2NBOwaq8pvRVKUfYmlujNXrDtrngN0y4ITPGzxlacHvl2fi+fRpMHmPKpg4p4ipxCwc2ByzDV/We3lBieJFgaiNZXzmzA7/fvBB1pzP5lMseH1F3DyL8HTuchEcOVP3GZ7w282wFtTBMrawvX4OMMx0d3ubU1OveZ/GoaV/U1EFrjy/C2+t/jAxJh5HEw7Eb9g
 dXfh/So7
 gqg704pNyCd0SrOznhpfwLf0ix4dt7terQxaexLGqDACwDujGKd2lN9U3styD3Ye+02Fwh3vw5KiBYR5ZlWFLjsO0RhuEnHQPYUUknjKtfRLObbJbAcdsDT6lrGcWOjp4D2Anz2PEplkf5sWAef8tqLjgezMgOjEO/+/eljmBle2Nva6vFYhNuyXYCi4Fjk3E17LAcOAsacv5pXIs30o3j/c1WIPSERPfb/4oMA2ZaOQRQN9jYaMghA/33PfUd90ArzntN/ujtIyWLbu1efKcCPkAWu2njmiYNcf/7vfxPponUsA9AYKGmKJsme7xXVEx4FEt2fq+bs6bgV+WRscN0+9B/piEK09XgNWg6SeCSP+TSE6nExpDZOxoe2rvQua/E/aXRdHBRqrgFuUfrPhdagFSWuY8s4Xrpg5LPopMzHTeBFQ+LevhjH2vp9o4f/z/N3l46LYAJwRBVF8XwrVBdfLlZsoEn0+7uXBNWuYjcQO6/uv8ICXD7AqYfgSQ6ykksvyUQrho278xkQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some bio completion handlers need to run from preemptible task context,
but bio_endio() may be called from IRQ context (e.g., buffer_head
writeback). Callers need a way to ensure their callback eventually runs
from a sleepable context. Add infrastructure for that, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     in advance that its callback needs task context (e.g., dropbehind
     writeback). bio_endio() sees the flag and offloads completion to a
     worker automatically.

  2. bio_complete_in_task(), a helper that completion callbacks can
     invoke from within bi_end_io() when the deferral decision is
     dynamic (e.g., fserror reporting).

Both share a per-CPU batch list drained by a delayed work item on a
WQ_PERCPU workqueue. Producers push the bio onto the local CPU's batch
and schedule the work item, which then dispatches each bio's bi_end_io()
from task context. The delayed work item uses a 1-jiffie delay to allow
batches of completions to accumulate before processing.

Both methods are gated on bio_in_atomic(), which returns true in any
context where a sleeping bi_end_io() is unsafe, including
non-preemptible task context. This logic is copied from commit
c99fab6e80b7 ("erofs: fix atomic context detection when
!CONFIG_DEBUG_LOCK_ALLOC").

Two CPU hotplug callbacks are used to drain remaining bios from the
departing CPU's batch, while maintaining the per-CPU behavior. The
CPUHP_AP_ONLINE_DYN callback disables the per-CPU delayed work while the
CPU is still online, preventing it from running on an unbound worker
later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
the work item and CPU offline.

Link: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 147 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/bio.h       |  32 ++++++++++
 include/linux/blk_types.h |   1 +
 3 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b8972dba68a0..6864ee737400 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,6 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
+#include <linux/local_lock.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1717,6 +1718,79 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+/*
+ * Infrastructure for deferring bio completions to task-context via a per-CPU
+ * workqueue. Triggered either by the BIO_COMPLETE_IN_TASK bio flag (static
+ * decision at submit time) or by calling bio_complete_in_task() from
+ * bi_end_io() (dynamic decision at completion time).
+ */
+
+struct bio_complete_batch {
+	local_lock_t lock;
+	struct bio_list list;
+	struct delayed_work work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct bio_complete_batch *batch =
+		container_of(dw, struct bio_complete_batch, work);
+
+	while (1) {
+		struct bio_list list;
+		struct bio *bio;
+
+		local_lock_irq(&bio_complete_batch.lock);
+		list = batch->list;
+		bio_list_init(&batch->list);
+		local_unlock_irq(&bio_complete_batch.lock);
+
+		if (bio_list_empty(&list))
+			break;
+
+		while ((bio = bio_list_pop(&list)))
+			bio->bi_end_io(bio);
+
+		if (need_resched()) {
+			bool is_empty;
+
+			local_lock_irq(&bio_complete_batch.lock);
+			is_empty = bio_list_empty(&batch->list);
+			local_unlock_irq(&bio_complete_batch.lock);
+			if (!is_empty)
+				mod_delayed_work_on(batch->cpu,
+						    bio_complete_wq,
+						    &batch->work, 0);
+			break;
+		}
+	}
+}
+
+void __bio_complete_in_task(struct bio *bio)
+{
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+	bool was_empty;
+
+	local_lock_irqsave(&bio_complete_batch.lock, flags);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	was_empty = bio_list_empty(&batch->list);
+	bio_list_add(&batch->list, bio);
+	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
+
+	if (was_empty)
+		mod_delayed_work_on(batch->cpu, bio_complete_wq,
+				    &batch->work, 1);
+}
+EXPORT_SYMBOL_GPL(__bio_complete_in_task);
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
+		__bio_complete_in_task(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1977,6 +2053,51 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+static int bio_complete_batch_cpu_online(unsigned int cpu)
+{
+	enable_delayed_work(&per_cpu(bio_complete_batch, cpu).work);
+	return 0;
+}
+
+/*
+ * Disable this CPU's delayed work so that it cannot run on an unbound worker
+ * after the CPU is offlined.
+ */
+static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
+{
+	disable_delayed_work_sync(&per_cpu(bio_complete_batch, cpu).work);
+	return 0;
+}
+
+/*
+ * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
+ * is canceled so no locking is needed.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->list)))
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
+static void __init bio_complete_batch_init(int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+
+	bio_list_init(&batch->list);
+	INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
+	batch->cpu = cpu;
+
+	if (!cpu_online(cpu))
+		disable_delayed_work_sync(&batch->work);
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1991,6 +2112,30 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i)
+		bio_complete_batch_init(i);
+
+	bio_complete_wq = alloc_workqueue("bio_complete",
+					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	/*
+	 * bio task-context completion draining on hot-unplugged CPUs:
+	 *
+	 *   1. Stop the per-CPU delayed work while the CPU is still online, so
+	 *      that it cannot run on an unbound worker later.
+	 *   2. Drain leftover bios added between worker disabling and CPU
+	 *      offlining.
+	 */
+	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+				  "block/bio:complete:online",
+				  bio_complete_batch_cpu_online,
+				  bio_complete_batch_cpu_down_prep);
+	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
+				  "block/bio:complete:dead",
+				  NULL, bio_complete_batch_cpu_dead);
+
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 97d747320b35..c0214d6c28d6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -369,6 +369,38 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
+void __bio_complete_in_task(struct bio *bio);
+
+/**
+ * bio_complete_in_task - ensure a bio is completed in preemptible task context
+ * @bio: bio to complete
+ *
+ * If called from non-task context, offload the bio completion to a worker
+ * thread and return %true. Else return %false and do nothing.
+ */
+static inline bool bio_complete_in_task(struct bio *bio)
+{
+	if (!bio_in_atomic())
+		return false;
+	__bio_complete_in_task(bio);
+	return true;
+}
+
 extern void bio_endio(struct bio *);
 
 static inline void bio_io_error(struct bio *bio)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d49d97a050d0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 

-- 
2.39.5


