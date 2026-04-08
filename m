Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBEF10FC454
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AED6B0088; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF6A6B008A; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B856B0092; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 292C76B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D501813A78A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:11 +0000 (UTC)
X-FDA: 84636931302.16.D007F5F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F82F20008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HzKTHYw5;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775689749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqJ0a3t8jS6c/vIHutzSVyyVpnCMDCW4Tg6feS4OXSE=;
	b=KLKAgWG62QSZhz/hnB6gZFOrtiV2Gr89Lc8T1+2xKXCqPyrPMVzF8HheuCUtO8autU2Z4C
	dR8jk2RtCRPpAjWisvzIjaj9BQRiIQb7mqmJACkijBZ7Q/U/45H1RXb+fNnuwEAjOZ2LIZ
	UPbnj5afPLHgH4rmaP2huuIOCCA37/0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HzKTHYw5;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775689749; a=rsa-sha256;
	cv=none;
	b=FXHny3d6S4H5d8H7Y79u7GI76aXjPLk7153g4WwkJkI4mFtqRIVC5gbyUnfrfjSRJ8BLWi
	l94QB5CmJsBCYflk/Ht8BJYPzUy5J81QxvcRBm/Zvw9nSId53wWmJ6XwvfH/MXgZHOgSt4
	Q+28PNuppwbhxGQcOs/mm5K2uHQtFog=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Muova2297518
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 19:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=oqJ0
	a3t8jS6c/vIHutzSVyyVpnCMDCW4Tg6feS4OXSE=; b=HzKTHYw5S6TceESdnFDi
	2PNZkSYBxbwNoM6vCZD02Bn52JxAF3fmiLb5Zl0DXAZ027SkvzDtmLqsSh0agOZ2
	FMQHkv37L2/YC6T0QQZhV32Hyng6vCTFHZtnQ/qFXH+1N6AqwlmlDpk0rs1t+HS1
	y/u4YeZFNMsff/0FZv2/u9Elb9b6m4+NJg/ZuHU1Fu2C85UakQ/0j2hh8ZzKxko6
	86QeTWgfNfGnr6RScYrZDvHWFk2B77v1WjT6IELF6h/oVvFbLOxxceGdmgCkZohz
	4Kfajmxx6+h0eire1jm052vY07QegjnGepZ4S2NQ8O3Q5A/He8G7moK9ISs5vDn6
	nw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mgu63-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:09:08 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d4adfc84fbso33853785a.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775689748; x=1776294548;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oqJ0a3t8jS6c/vIHutzSVyyVpnCMDCW4Tg6feS4OXSE=;
        b=AH7FyYh7377yAdocV4k1UT8/uRu/9gRYamZUKD/H5XGXf9kxWM+QP42+44EctcMKct
         qcgGkhJqshl5l5Jw8nKVlVRwI3WkWFhPaFCz2eQEAAgAqBhaSLdH6aXUgDwg6ZvSif/x
         AcLndyoVf4obvV9tw492nXxFh+lRN6cZRYyo6k9N2QEZFabjBmDJ9+xBXgzTLhgr3mCR
         bxvggMi8Qln/Ww+Ca2zDUppOGyjVSN2khr7k64QsxeS8Bo+RG0ZKIie3rKC6Mn2vFxFk
         ayxXCvMvdVnYh+q8PCSdj1LXZKsKu4Ny25zoRLMK5bQFA3/vVwXTOOV0L4qyVVXeS34M
         GOAA==
X-Forwarded-Encrypted: i=1; AJvYcCU27ZByEEvF3620XY8N8UuUFtYELiNvrQSE72JTI1qAw13UB1f0VPXICx78YNEuE0OBJuDUMuzquA==@kvack.org
X-Gm-Message-State: AOJu0YyYVEZJW3feZZuBBDDGulsxKPK7URSTewP5BXqHOyAapmxcNlT4
	GpLNDy5FuRhVTiHwdxuTjLAXBdhB6denp60gjQWM5ss39lyyPj0mmneAD8K2bhZ9GwfxNX1gai9
	dD73w9qPzMMLuErzUorvhQ7tw9rKeXKPdFbMaXoOytZw0+cMv
X-Gm-Gg: AeBDieswfgQauHkEOQCJarZp6i1D3beZQLYX5KSrLdDVk/42EO2+IP8wCM1eSuLowNI
	iFp05Mis03hitgun73Drc0Bp5GIzpLVXqMcOp8JW4pGvQdUSWXe95bhiKWYPNG5X12yYYyCm1WK
	x/p/0ng+UzX4YSokFHzA+H0a8RP6f/4dUSK/gxSrlLmsk0t4qmnWEIDgBPj0FsMETCAmLyxPFOC
	Wnfub2TituHLFVDNYDob2iG773Uq32Wxsn4Z7QYWC+iWcPhpKbRekhnSzHxMXbcBHtCvpFx7Qeh
	K2yfgCPwc8/hMaJhrNGzMy8K2KvC0+ADRvbC9XRRVb2tdlJiQ2e+DOi/JlbaM9qZ4vxAPF+tQMn
	49Qid75iiMVI91fAWcxxYdJ4BtDQfkgfv
X-Received: by 2002:a05:620a:288c:b0:8cf:e015:afee with SMTP id af79cd13be357-8dc3d5637abmr251837085a.41.1775689747764;
        Wed, 08 Apr 2026 16:09:07 -0700 (PDT)
X-Received: by 2002:a05:620a:288c:b0:8cf:e015:afee with SMTP id af79cd13be357-8dc3d5637abmr251831985a.41.1775689747307;
        Wed, 08 Apr 2026 16:09:07 -0700 (PDT)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dc1514d382sm125665485a.4.2026.04.08.16.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:09:06 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 08 Apr 2026 19:08:49 -0400
Subject: [PATCH RFC v5 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-blk-dontcache-v5-1-0f080c20a96f@columbia.edu>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775689745; l=5340;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=NLsrsfzymzUrMVWpo0v5CWjs+5vL2gt0uuiGjvhOdbM=;
 b=u66r3JWWGQoqmnanaB2/ADYIPFPR9XzOSNkajI3Qmqzv2OFXZ3a1f4nowuwzVHTLchKqwLvP3
 C8IK+oGI7fzBnCtSgWvUg1tgEQWCLKJKma5i/Qp7RNIk3ZGfLD8QeKY
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 2MPpOD90rYUuRBKFnJGmzf8i91d1PbPJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxNCBTYWx0ZWRfX9BfYU8jNTiWi
 G5CFCUdhGYvbcEwMcRf5qeWKm6z39NUih5zyf6Lccf8okq7qAtqQNZJnWF3BVC0V2bfi5UiSmi1
 6i24ze5AOSlaCBL4GmAeglKWl9Fa2s8s1GNyAm0kyASD8XRGzpvJroNcOd9GtrZiozXMzmDxZCH
 N4NVs0sU+06piAm6m05zOtWwzfm4hYvO7D9f41OCTORf52NFr98CwowE/CLQFEWIRPm9g53F6nr
 sEuwYtcl0BBK1t28BpwtYSQltPe2GMoMDYSAki7ogTPj3cvSKs53oHJgMYNGBKAnPlG7NmgFePs
 yzpJlAnOVuYs4j1+BgzNnxWj0dqj8hkIUIV3wFZ69AW03rxUA//Vmy06yXpF7kINEw5I/au/ZjB
 I9mdUohzSsLP9HRJkyHSuWKwcVuB4mh3hlssc+MdA93qUzgvPbhocBhmD3ShTU4nRBNAFrbjhz+
 XnBBekfV+oyQh6T6Kmw==
X-Proofpoint-ORIG-GUID: 2MPpOD90rYUuRBKFnJGmzf8i91d1PbPJ
X-Authority-Analysis: v=2.4 cv=X7Fi7mTe c=1 sm=1 tr=0 ts=69d6e014 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=JfrnYn6hAAAA:8 a=ignxIbPQDb6uhq8P750A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080214
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F82F20008
X-Stat-Signature: 9a1kdccwjpb3663hnnije3err77edy8u
X-Rspamd-Server: rspam06
X-HE-Tag: 1775689749-66637
X-HE-Meta: U2FsdGVkX19U31KKsld+VTW8rMvn1pYUvceSSFUuCpPBGrwO9Jpb+KUs8/iG/7rohCb1eEweDmYBR4N3Qw8NWB5g309ZdwqTQezmXFUQSrSL4Rf10REv65DE4heo1xr+y7UdjKevGKQXj0jYQsMmny1yxkcgTGq79jimsq60nmiIRTfz7tHWvWI3LIJioBODnR7WuGCXO3c145JqQM6040X3cpIJ3tYlvoydSuirDdTYfZU/R9zHE80IMgceUfMeyzCCu8iMlVdy6a0yJHMhm92M+k3ErYuZen5PvHkhZvCa8BbBK4MuYoT+Bsht1Zqq2Bz5Ilj/TVikFR2LqQYS6IUx2uCzwzHrV4I3rXGqBVOgaHqB6RpyAHUV08e0zreCpuPoylZioYabTSVc6E4fyzUJfrfmpcmZxC9MzRtbnrLfA+Iuh2TnUzaxdBGK48AGreE4peNOOmBqRjbsCczNdpD75Hz05ds9xne3bkRiIhRnV4ofgjGP3RALL7tCzUneZzqX/wIodeP9Cguk14Qzpj9JZiucknQvIlKehAGtV0zx/HGC6DepUVlH/qqS4D+McJoHKUrRKMJ0UuSbLtHkwGpBB5qdW42GBLVZDXB4azxjcAEvn7lMJt0kSIwJqRMEzooH2B/tCtmUr9b1Cij6j0nNqZee1v0RoQlBQzsoVcHef8qi6Y39Fi15WJV+hHZQkcC6eM/QGX0LMgObkvnD+Ei2E/LYgONxuOzoEvkvYPMC9eF2QhQ26xj7WbQorTK6O5jFeC6CeP1z9GvvHAanKhriRR3OBvI0ck/GUN8vHb7LqzRD316oqpnt2ulKmA3pViynYsPkJug6obLKWDA+/bn3qZLMmSaBQVtCRy7bqPuykmojGf5/pBNmhaRo7+VCLd7vL4PYp4cfXD4PC5QwwSlbDuUx2QFF6Gvhkblj66vmBZqLjWB7PW3yifgV7i29taRSMekgT2nAwaw98JB
 R4YbUUHY
 RZfUJBBQ/0d+9l16SlKOiucfJV0yyaZfAzcFZRP6v66hDFX41IOcrqeJuAIH2tp8TgQoBU73T06Bj4e52Kx0fwHSgHdnqrzw+JZXNCXehPgA49TVjNmYPaaS59gpgel3c2hSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some bio completion handlers need to run in task context but bio_endio()
can be called from IRQ context (e.g. buffer_head writeback). Add a
BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
task-context completion of their bi_end_io callback.

When bio_endio() sees this flag and is running in non-task context, it
queues the bio to a per-cpu lockless list and schedules a delayed work
item to call bi_end_io() from task context.  The delayed work uses a
1-jiffie delay to allow batches of completions to accumulate before
processing. A CPU hotplug dead callback drains any remaining bios from
the departing CPU's batch.

This will be used to enable RWF_DONTCACHE for block devices, and could
be used for other subsystems like fscrypt that need task-context bio
completion.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 83 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  7 +++-
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8203bb7455a9..21b403eb1c04 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -18,6 +18,7 @@
 #include <linux/highmem.h>
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
+#include <linux/llist.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1714,6 +1715,51 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+struct bio_complete_batch {
+	struct llist_head list;
+	struct delayed_work work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct bio_complete_batch *batch =
+		container_of(dw, struct bio_complete_batch, work);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	do {
+		node = llist_del_all(&batch->list);
+		if (!node)
+			break;
+
+		node = llist_reverse_order(node);
+		llist_for_each_entry_safe(bio, next, node, bi_llist)
+			bio->bi_end_io(bio);
+
+		if (need_resched()) {
+			if (!llist_empty(&batch->list))
+				mod_delayed_work_on(batch->cpu,
+						    bio_complete_wq,
+						    &batch->work, 0);
+			break;
+		}
+	} while (1);
+}
+
+static void bio_queue_completion(struct bio *bio)
+{
+	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
+
+	if (llist_add(&bio->bi_llist, &batch->list))
+		mod_delayed_work_on(batch->cpu, bio_complete_wq,
+				    &batch->work, 1);
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1788,7 +1834,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		bio_queue_completion(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1974,6 +2022,24 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+/*
+ * Drain a dead CPU's deferred bio completions.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	node = llist_del_all(&batch->list);
+	node = llist_reverse_order(node);
+	llist_for_each_entry_safe(bio, next, node, bi_llist)
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1988,6 +2054,21 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i) {
+		struct bio_complete_batch *batch =
+			per_cpu_ptr(&bio_complete_batch, i);
+
+		init_llist_head(&batch->list);
+		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
+		batch->cpu = i;
+	}
+
+	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
+				NULL, bio_complete_batch_cpu_dead);
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..0b55159d110d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/ktime.h>
 #include <linux/rw_hint.h>
+#include <linux/llist.h>
 
 struct bio_set;
 struct bio;
@@ -208,7 +209,10 @@ typedef unsigned int blk_qc_t;
  * stacking drivers)
  */
 struct bio {
-	struct bio		*bi_next;	/* request queue link */
+	union {
+		struct bio	*bi_next;	/* request queue link */
+		struct llist_node bi_llist;	/* deferred completion */
+	};
 	struct block_device	*bi_bdev;
 	blk_opf_t		bi_opf;		/* bottom bits REQ_OP, top bits
 						 * req_flags.
@@ -322,6 +326,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 

-- 
2.39.5


