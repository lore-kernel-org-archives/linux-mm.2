Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0B1109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162666B0005; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113536B0089; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D1C6B008A; Wed, 25 Mar 2026 15:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD8DF6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8497713BAE5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:45 +0000 (UTC)
X-FDA: 84585577650.24.EFE2D73
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9370910001B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=W1TdmHAg;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774467043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCcp+9kU8miIdEe20LAeTwI4JkSmuzG2q+hEwpZi3Vg=;
	b=6wvi8cPAuU4OnNwfOSPlGUT3WjxMJbgFfPXO0TZdCBHjcJ1gjfnbmaoenW/5gGwt3K3RSr
	1OIVvFIdZSwuD9ENLEXKpCcMuuXPfE/dpi3NcJccl6RwR98q4pn45FlypqZPlBeU1M2rIK
	ax+HcI7g1k1J8UC3+cPDOR/RjpKRCU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774467043; a=rsa-sha256;
	cv=none;
	b=Jx44DBu/Gbk0zK85ud935gpZQ5qd6xIIZE3SEm4Sd1/JPFE2SCHH9NphLKXoCtP+aKKmmV
	PZLTfKSFhL3x4/oBstwFU6F+1qMb1bEMgPfdcViasRhM/fx0DS83sPcemew8oZ+3iWhHQa
	d9E7a1G9dYU2GUMNrEw9lNDznXoTS+A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=W1TdmHAg;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PJSfZ6937217
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=hCcp
	+9kU8miIdEe20LAeTwI4JkSmuzG2q+hEwpZi3Vg=; b=W1TdmHAgxdl1P3Jt415K
	mDMuXC1UZ38fH1pCdmPKkiGohuKsIY1BtpAKPFqF+lIJQhgQdYdxNmq0tBln+Sxi
	fPo2lZn/xTrr7aF03NAH5D7o5dhQ7+BnqTNuev7JxaZBdfr7G70Mgv6aC67YHW6I
	jiNkss/3Gc3BnDCLsPz4kOq4H0P3arP/tm4ywo+FaBzzT+wYpZi3+xYTVHK+aRCm
	JPQkw9rJlEHkxRJkqF13de3U36pc5j9+MK4SNkjL0L6/hXAbd+/klpJMM5KCVdqx
	7xFJfUckpL/QeBuUOmtLU/DH2jbtDRoN06GcP8GdoC+DVlnJMZbwsJFM28SMa1+f
	IA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d4h98ayhj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:41 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-509044f54aaso8550261cf.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467041; x=1775071841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hCcp+9kU8miIdEe20LAeTwI4JkSmuzG2q+hEwpZi3Vg=;
        b=bNTzUyu0JVGsskbK0C8/q/AjHmaFHto/sW8Y4y1BEgpc6qLythxJ1AtvlMHP3XM4EK
         Tsmmj2COtIZBtismo7m5jC3+twQdu9GcIqK1PO/6cXMU/PfhGEv1s3vTqa3wc13DHt+p
         hXabSuR6eYviv+hJG3ylPFd77En8VxJT9MXyI6inhmD0x5VesrV+aFCbtEYQXH60JqZK
         rmmzclXZPOIJ3QdiDK+MjNafQI9+aiGNAtqlzTqmcKQ48zdieg6gin8YXgIGyOp6RiFB
         EdaxvI0uxNPuTaVS95K4/sbjmX+eeY65CYaCPCZ7UMRY1AUYi/fSWvWIGIul6319NEsD
         LzKg==
X-Forwarded-Encrypted: i=1; AJvYcCWHNlrqVKvJtypiCLqAMuXy/evGF+HSWgiZ1eFZ2gCMbtgEFHTYahGV0PqqwVwz+bpk4xMJ4fjFjA==@kvack.org
X-Gm-Message-State: AOJu0YzFJZA4NCpbcVUe68CqsNFuc0vLF/BIAGQrZzEqc9q+vFrrbddH
	L2DLpETuvnUfX7hQcEwyhCcKjbMl+nEDkCN6rGg7UU8091hRm4SqKGvOPxUPBviM865JyZgvWdY
	tJtlB0DiuiZhe1HiNAtSwqD5dzVBSi+eZbVBTVQQ9kxKiBkKw
X-Gm-Gg: ATEYQzwS6AfFiWSDCZR/pJTPCOGFfVkNi6z5oET7Efk9dxezg9rUftsBCcdJL+QVlzh
	dJL5rasEXDlHWC6yOXEugygcNni5i435zF0ojBAgsEPmCKUrxcF5ZWEeDLVTzo4sPPUTxlbNcHy
	R6SZxrEH5Nj1kgLPZkCZpZnaWWKWTMaVum4k6cG4bOfp1GAqNIGJOI/XwFqgBm8140VBn5yHrKW
	aSvwLoHX5NM0hTq+peemF3WxyACFuIoumE/Cbk+EPKi8m1Ymj4gpJ4Y7vtN8gEmqPv9PneVymXc
	uxUlsZfe4NvVzBN07bKCv9iGibiA+m4iFHn+0r++owL4WBzHXZJvXsSi8vTty2EFIgzdXXEpG0N
	Vk/JsfwSHXZoK9yYbHv+odybymBrj39ywb+rwaA==
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr57540531cf.24.1774467040642;
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr57539811cf.24.1774467040081;
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Mar 2026 14:43:00 -0400
Subject: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
In-Reply-To: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=4684;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/KDtCfPcROGMHktI+sYIoy1sJXxmr+t5YwMIoFyxNlk=;
 b=yUgCWQ4ZcEeNTx5iojZlwuLJ75/zRFsFdFta96TVVGE0YTzeH6B4RKXjHrIwyFGw3hTK3rhgt
 gf2gbHu8FZ6CWKrHyJPeTOd+yuu9FyglPNZhfk8bDp7xeu7U5SJLlSh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfX8G1FnaZfuLpZ
 gS/tgsxftQ3fEz7RT6brUXQ517wIeCbDQdR47hbiHoztkotH2XtSovh9HuwqnfsGpPvrbZUruZx
 Ja+TITFHZnht1NlyhkESeKuDvOn9Y22sLBEfOiMZTVUOqjR9koIBM86WGLKodgoTth6qrZUw0bR
 zItUPDbUKFvRs9JDblr/g6Pmir5XVuo46sfHDXcTVgFiPSyZQLnhY4icQLK/EAa7o5ofFHD65K3
 i4xoY+sdeM8pGW0azhf1FPkg+TWahX9zST1aDvM70QfS9K+a9tIe/IeIPaRfr9rZTxSyMQELybF
 cFeVRAbtodhPPwFu6J4zBkeLGyRmgdZHdRdxIWaMkcArf3v3WOnkOh1sbzxuGwdUJF+238myhV7
 GQ2rmzp0praG99Z4pXvAuCWGoY7w2dCuUJvnDBN9DIijIUJAxCw4E8kSZnruH6pm/SaGoZX//iD
 tWmJzbTiu5NsPONrQuA==
X-Proofpoint-ORIG-GUID: GrB5QuzMAfKfIxHoOksLWb3SvaG-NeaR
X-Proofpoint-GUID: GrB5QuzMAfKfIxHoOksLWb3SvaG-NeaR
X-Authority-Analysis: v=2.4 cv=Ht572kTS c=1 sm=1 tr=0 ts=69c437e1 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=JfrnYn6hAAAA:8 a=QQSmTEQkt36Rj1JXOw4A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 lowpriorityscore=10 bulkscore=10
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250142
X-Rspamd-Queue-Id: 9370910001B
X-Stat-Signature: g1uwhh9odcr85ckmpomwhgxrq31ke3fg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774467042-640100
X-HE-Meta: U2FsdGVkX1/9EZSz3fOvurF7ss8apkNeO1hXWPAiCFCAb+YeU7Y04eqblcD5SZSQ2odUTdmGXAe194fx8xy0FYCVxiQWZbJ1yMPG4poljL5FPnhlmq39FeW+5eK6EaTiMZ76viHpgtF1igcOt8opYzx6k1ytncFoAzUTnZYa2FYsFbRXlfy/bc5HHa57+XNwq4GpuWxAgErLbB3A5kvtuz+cireQRfNjojeBQbC5nvEOsiMmV2VR1w96QTJMsMz7Lkd4os8B9Yt0YtYSzqbLODUhwBaskbpfQhx2EUd1k8jEwTp1u7INwopVk6zatdqJbx66RPXrAAW/3T8VyWYXjeORk8jlu0X8WYkHxxx4aFtCCuhjjVZGCsGHWMH9afIWnr0cVMERnlR5vunNTzPP3CUP/Vot5qz6nkzee2YEgxEZrpYzT6KlfYni5J5xoETDIyNVu1/87F1ZV8J5LdXNBJ781y7qfBN6FSSsynCyGWxSWo9ZTwtjQK8Ru84ei0zVia0O0jD8aKMjuqzp3MrdfdoLOBRMSFG2SsqX6hFKdzWv9EjmIKEaVglKSFoNnVyJUrfMHn48Pww/MGXfCgbUDPzrj0SR149EylOm+UVzoryv+zNV9RV/x4+XLC7xuOoNKp05fTkzDJC4gEyGLoQc/Zbzruz0k/6k7SSFXsl5iEtYmYqMPQxPOLJXC/erj7wQkjD3++XUxfwHgxh/h+SAabEivzPvb1GNgeK6fS08noIhvab8PHwmGKUWbiK7yQwXnww952p8QNrvmKreifSDKqqI6rdfbRXtUf2MIH0eFWEIogZrhr5GkdypuTVStERbbxgqM41qd2Unw8736UTT48RNCWNO0yMOlkXZmn3lqlaSgCAzNigqN6OXS6P4hJ8BT39JEcCN0QlrysUFk60DcRdQujQnWl70zKOt5hrCcLxwOrlcLXSxyk6IS5uR4Za04in3sQzzUOAWiwGbr3i
 wFe+StUh
 PtQg4feeqnOsv5TZY/39bLld+18udcfVJBAZ9DX+fwNdd4PGQeAi5/DSv+cflQfJzOptemfSyDrA0OeH0Rojx8fxMYCx6g0E9LWkjXrebrE0TW9XWtgHTSNUuLA1c+rwSxnotK3QHLgzQfBuqLUl5OMQIv7MaixM6mFrpbdFIthLUoBPYHyNxl/UcWbjS+3I9VLpNcgQ3i14yesSPgjaAPMV1ECHOj/tPiHkK0AG2JBEBlFiowfvayy+hB0Yvd+NwW+4IagMytlaAMA4O1dd3h0lxmZWZQVEDgJphVyevSUpkvHxu3YlcXlMwrB0HRA8YvFD0zG0QqTr6eh9gPTBz2qbuIfJyOtqq3Hnf1D3gJeHi+8JRQLjKbC1CtHzZEfyZ0JEFaUm7FHvyTE53hBtn67GNMSfvln03Al10b5myYukooL91NbSa+lHnGSyppxNjTbTEm4vwzlGFhbLNjm12QO5CoFp+lLuUzqf/WDyXRF3j4d3Z2/NP/YCGuHfl/gs2uqd8FLpvVGroWSO5oaCcXE/7C0A4xs2DNmDy
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
queues the bio to a per-cpu list and schedules a work item to call
bi_end_io() from task context. A CPU hotplug dead callback drains any
remaining bios from the departing CPU's batch.

This will be used to enable RWF_DONTCACHE for block devices, and could
be used for other subsystems like fscrypt that need task-context bio
completion.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  1 +
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 8203bb7455a9..69ee0d93041f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -18,6 +18,7 @@
 #include <linux/highmem.h>
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
+#include <linux/local_lock.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+struct bio_complete_batch {
+	local_lock_t lock;
+	struct bio_list list;
+	struct work_struct work;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct bio_complete_batch *batch;
+	struct bio_list list;
+
+again:
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+	bio_list_init(&batch->list);
+	local_unlock_irq(&bio_complete_batch.lock);
+
+	while (!bio_list_empty(&list)) {
+		struct bio *bio = bio_list_pop(&list);
+		bio->bi_end_io(bio);
+	}
+
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	if (!bio_list_empty(&batch->list)) {
+		local_unlock_irq(&bio_complete_batch.lock);
+
+		if (!need_resched())
+			goto again;
+
+		schedule_work_on(smp_processor_id(), &batch->work);
+		return;
+	}
+	local_unlock_irq(&bio_complete_batch.lock);
+}
+
+static void bio_queue_completion(struct bio *bio)
+{
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+
+	local_lock_irqsave(&bio_complete_batch.lock, flags);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	bio_list_add(&batch->list, bio);
+	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
+
+	schedule_work_on(smp_processor_id(), &batch->work);
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1788,7 +1843,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		bio_queue_completion(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1974,6 +2031,21 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+/*
+ * Drain a dead CPU's deferred bio completions. The CPU is dead so no locking
+ * is needed -- no new bios will be queued to it.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->list)))
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1988,6 +2060,16 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i) {
+		struct bio_complete_batch *batch =
+			per_cpu_ptr(&bio_complete_batch, i);
+
+		bio_list_init(&batch->list);
+		INIT_WORK(&batch->work, bio_complete_work_fn);
+	}
+
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
+				NULL, bio_complete_batch_cpu_dead);
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
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


