Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBE0CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD368E0007; Sun, 21 Sep 2025 11:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4DD8E0001; Sun, 21 Sep 2025 11:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411AB8E0007; Sun, 21 Sep 2025 11:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6F08E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:12:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1DAA867C7
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:12:32 +0000 (UTC)
X-FDA: 83913598944.05.AD2FD2C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5B2DFA000C
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:12:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWEVhUGXH+wwy8esjuOV38rc3aSK1MNzzF9YuAlqG90=;
	b=oDLWFL27V56rKfkvB2L/nTJJ1JOfnkx6c8C6beAH2iClwxE729QHx6kP99aby0s/+PbA4G
	DORjuOWUFtrrrQToWGa797zI0E7guADv5Z9Ge2mwpDbMZlC8aXEh1jMHFQgC+eH7bFwWoL
	W0/wU/5/T6FIP0wk05yPDhPrQ5qEZNw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467550; a=rsa-sha256;
	cv=none;
	b=52KDPOi6KTq7FhNwbCJGQj5525BagRZ4npy1shzMNGRdyLt8FoFbryvyjwMITSjRFjmq78
	uwJ7OJro24p7hEGlho6y1IgBlUb2BdKXBgom0RLSHy9qlQMHO4KTO+7c3EWH1kamNNt9x0
	Lyr/vqFbarg+R4EOfoga+j5g5HwWRSg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cV8qZ0F03z5BNRd;
	Sun, 21 Sep 2025 23:12:26 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 58LFCIUF056594;
	Sun, 21 Sep 2025 23:12:18 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:12:21 +0800 (CST)
Date: Sun, 21 Sep 2025 23:12:21 +0800 (CST)
X-Zmail-TransId: 2afb68d015d563a-061cf
X-Mailer: Zmail v1.0
Message-ID: <20250921231221760ia5tTTBoELVcZzeH5Pl2Z@zte.com.cn>
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
References: 20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>
Cc: <shakeel.butt@linux.dev>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
        <roman.gushchin@linux.dev>, <david@redhat.com>,
        <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgMy82XSBtZW1jZzogc2hvdyBrc21fbWVyZ2luZ19wYWdlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58LFCIUF056594
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 21 Sep 2025 23:12:26 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D015DA.000/4cV8qZ0F03z5BNRd
X-Rspamd-Queue-Id: 5B2DFA000C
X-Stat-Signature: crg6gjkyxekzqdxy4cykwdbmqdug7wp9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758467550-359094
X-HE-Meta: U2FsdGVkX1+AEHdmfkmWXDqMQhgmwFpry9jbkBUTpsIyottOBzLrpe4n6eVgoHrq+DchOMUv3ezzSbRSPlxSDlVcDqLnt4pzUp3VT5W8g4j05z7TZUcNwpc4aqGWBHAYKwHgD3M6sKcUJJnlpHyyWS6PkSicS4kq49NRsBA5q5CAR9ti3qZwVCBsSAyIOCofKawIE4faU5mA4+4XIzD7O2OsXDzTScNc2s7pWjQaKxeOA6NF3GKpH2W7qz3/Okoc1y2egqiaHbhd5tC+5rqGnSuYKnHmqe5Z5MYxDcDAOQY0oonCb+3CasFLyRv/HkSGFBKRyy82ikLgl6Er7dr8mlzZv1HcUEjrLwiOAV42JFZ1nh32kALCgN/kpJQ86Jk3OW2Mg8z2U4tWQV8snMqIx7rLVMErfc1EqcXVdZ2lKD5Ataj63nAMN4US8PHDvjVN/0r9NyB9LPKiZraouBSPvDxdudEkoDYx+U7dIahVVKOeo47OWNGuO75AAUbsBT519lbpmSOL4VGQTDSSbRwcp79aROJA8mkP1Mi39khDZ31im33pK+1uCVqKt2F6UDgBA4I0ShXKt1/x5Bo29A+ft5qNnVMhf/6w/4rw3WKNFsb7p7HGURDKm7ZObCMzQaxE4XLu46W5+Ycu9qI6ENjeq7cdl1y5FqxC4UxeZLllli63w9EUN+tHiP5op867o99UxndtVfwyTT9GL1U2MnPBtWP/wQAPqTN5rDg1yBt3gt532GV8dkec2jS7mOKh56p50ZPCNU7jaBDEbQ2c1csqTyvqAIj+ISD3Ic/hdyW7mtJdElR+kxnKGAuV9btiM2JDLwjHRVR21N1C7EofPCZ9Ohn0R1JBvzLoO9uuLzE99i6DnJ/JTf70UNhq6OQ/W7zNBmdzidCcTEmCFuVjDBaUQtVzF52ddKNmI9uOQhkjG3269OznkTNZrhdg8aWrjdIIWqBLnrycgnc5NRkmeNI
 zJChKNLM
 bASf8eA2kQ3QSnar/zV0QEXOCOJK7r9VFlJ/yHFdgF2/fMXhgC5BnG3g8MtIKlxIrttAfrpb9gLxYE9EgmW6V2by/WKITXdYJ6gtb64dLAQB01IbzSO791th7uUBG2T55NyYjj+moJfjR9hyUux6hb72mZbMgIvFJOvCv/ryVLcEzJpuJNGA4aiZlJmtPi2YzoNKCayMm77S9zNHOMVnfpVxsfSjexj56B3QGC2rnHhrWShuj+jEkXuok1aIV6an0Myxqa9ruGXMSZNVgSC8SpOzSv3+BDxcX1qTTy1fTY4tzNUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Users can obtain ksm_merging_pages of a cgroup just by:

    'cat /sys/fs/cgroup/memory.stat | grep ksm_merging_pages

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2fb4198458a4..e49f4b86ffb0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3313,6 +3313,7 @@ long ksm_process_profit(struct mm_struct *mm)
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
 	long ksm_zero_pages;
+	unsigned long ksm_merging_pages;
 };

 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -3324,6 +3325,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
+		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
 		mmput(mm);
 	}

@@ -3339,16 +3341,20 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
 		/* Just use the global counters when root memcg */
 		ksm_stat.ksm_rmap_items = ksm_rmap_items;
 		ksm_stat.ksm_zero_pages = atomic_long_read(&ksm_zero_pages);
+		ksm_stat.ksm_merging_pages = ksm_pages_shared +
+					     ksm_pages_sharing;
 	} else {
 		/* Initialization */
 		ksm_stat.ksm_rmap_items = 0;
 		ksm_stat.ksm_zero_pages = 0;
+		ksm_stat.ksm_merging_pages = 0;
 		/* Summing all processes'ksm statistic items */
 		mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
 	}
 	/* Print memcg ksm statistic items */
 	seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
 	seq_buf_printf(s, "ksm_zero_pages %lu\n", ksm_stat.ksm_zero_pages);
+	seq_buf_printf(s, "ksm_merging_pages %lu\n", ksm_stat.ksm_merging_pages);
 }
 #endif

-- 
2.25.1

