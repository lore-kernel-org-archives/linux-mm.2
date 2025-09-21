Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B347BCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1518A8E0006; Sun, 21 Sep 2025 11:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102F88E0001; Sun, 21 Sep 2025 11:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0179C8E0006; Sun, 21 Sep 2025 11:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5D798E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:11:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C20DC0364
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:11:31 +0000 (UTC)
X-FDA: 83913596382.17.4246BCA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1AAC1C0004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:11:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+GCdkiaoGRnihVN9BHpFs7DSjTSP7lrIeI8ZHJhi8Y=;
	b=BzzQg5xkkMBVFbl8X8X8raNcZOXph8bLGjVPSgFntwzNbxjugbn7YCn2/dAIyHNDxw83x0
	TIvql58o68XwG9y79FGCkiqQw8kPx8K3oY60v0fpK911Pz2y0sImYtS1T74M6bpwH2vXKq
	5A+8+Ny2k1fALdvn9McjmwfuWYShaRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467489; a=rsa-sha256;
	cv=none;
	b=eih68rBTZhNw3qRkuFTVqIvMKQw9QIqhdYNVi1h+5tRSppmMN4NaK7doiLvIbebmkLUeDZ
	qG/rGDlXzPFs4XnLkxU/IjqRdWr3mJLiRQt7C4721gA7IciJBsThuVIXmuyidbRF5y/zIU
	P9dknkTnayXVpuuQm5EY1By2N9xGIQc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cV8pP6LXGz8Xs6w;
	Sun, 21 Sep 2025 23:11:25 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 58LFBFuk071467;
	Sun, 21 Sep 2025 23:11:15 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:11:18 +0800 (CST)
Date: Sun, 21 Sep 2025 23:11:18 +0800 (CST)
X-Zmail-TransId: 2afb68d01596a55-055eb
X-Mailer: Zmail v1.0
Message-ID: <20250921231118775bX0EITd4B9qu_9qEeGPkr@zte.com.cn>
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
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgMi82XSBtZW1jZzogc2hvdyBrc21femVyb19wYWdlcyBjb3VudCBpbiBtZW1vcnkuc3RhdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58LFBFuk071467
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 21 Sep 2025 23:11:25 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D0159D.001/4cV8pP6LXGz8Xs6w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1AAC1C0004
X-Stat-Signature: 9ntr5mp9yzpi4aznpn9xkq3bcrbdg6gk
X-Rspam-User: 
X-HE-Tag: 1758467488-424220
X-HE-Meta: U2FsdGVkX1+jB4T5RuiOhvXal5sZAVE0Bfmax38JmNK55+eox/bhYDXl4uFgRImhRYlPEt7kXKdeeu2KP2A83TbN4GoYqtKdcWbs8YiK/HNqME6sBk+UeAlAil7EKw6Q9YswxCYXoz1xdmsrlSDympE6YrZFWolJGWltlaL3gOkdR3zSq5ErgPuoIwjpJ9xcn1Vg7YMqh4xK0PMR+lspL9hoIcNg1miWTVhPDd1NgVRTavJrR8Fmn3ODPwf9fb2sj5zES8njBXSYTTvHhgvl4zGtBvfpEzOlm5y21j7W7COiLn+qzbkY76AyZgP4QoQsj9W1hWSJ+7BKWP3GrE0tG63QfC1QBNYgxTubtsufkizBA73XUOdbEn1YOW2Pd/KzQwVbz9pfieBJSbVe8c6a3bN6/J+x4McTDexPoEJng6skWhJjSvVYnFThaarM0nVZs9mEPheohCrTOTkp4qCMRhumqnvhQJ4637Ze25fZj5TSiMChaeml3wdhbx8T1XOz3E0MRAIZhj6KjzY0GdDuWN+HgffCAl/3GbkonOYSpeyxrtSR3fTCBDxyHvxrLpz6GaDmt5ktmTfiVGT6LL+EfHgvlzeCqE3Fkm2HuYRWCY74vgDy2AC5lmTArCxeg7r1XoYy/qTIDMDz3ZDTYKgNV7HkSwZ14MTB342yRq4k/qS/W7gLyOkbgxKgsefhumDnZkYpBgPLt34x9ieRaewM1FWALAje5Fjao49l6Pyw79Fsc66/hJPcNyJvDzlF65wLSfRvsk5/NZK8NcleKwGCXcvCHnAvcO1hGv17G8zld+qb1f2iy0wmjv9zZjqORtMavhbeX/dZVjBOBamvqLZWX9UL+LnqYvsYNGlF2P0irU8558wB8FY96dLBmoggyYHBiAXULKIj9GAm0qBeVDU4A1XIz3TgLN1F6kjHIF1qPblAWLi9WlYZD/9VqqUDeZXbSMd1/YDk9CvTCUJ0T2L
 4Rdb9llY
 n8CcbjE6uskG2ezD1PbrDMjW0/OjVt2mcqKVXNSkqisfC2byaw2Txm+eCOGt46n/3xjokIiVeNzIUbyTH5KdS6AAp57Hl6ylrYWkkeUfaq872XwXnG8ji6M7mVj5yCCa+2aCN6ABjoV9Lo8Zbh5pKg20I1ZYD7l2175OzfXLMCBLK3+0d+yHTt38Je74oMvxeiNzhrFRZ6sojGXENyZJg1JyRNvwA1JozUlqn4rDEbMBG1yfbo3pwWwEtQeg6ClgjCCkZkptW2Goui9hGd0XMVOMOAThCaC+wPPAPLN64RQS/USM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Users can obtain ksm_zero_pages of a cgroup just by:

    'cat /sys/fs/cgroup/memory.stat | grep ksm_zero_pages

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index be0efa0f8f2b..2fb4198458a4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3312,6 +3312,7 @@ long ksm_process_profit(struct mm_struct *mm)
 #ifdef CONFIG_MEMCG
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
+	long ksm_zero_pages;
 };

 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -3322,6 +3323,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 	mm = get_task_mm(task);
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		mmput(mm);
 	}

@@ -3336,14 +3338,17 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
 	if (mem_cgroup_is_root(memcg)) {
 		/* Just use the global counters when root memcg */
 		ksm_stat.ksm_rmap_items = ksm_rmap_items;
+		ksm_stat.ksm_zero_pages = atomic_long_read(&ksm_zero_pages);
 	} else {
 		/* Initialization */
 		ksm_stat.ksm_rmap_items = 0;
+		ksm_stat.ksm_zero_pages = 0;
 		/* Summing all processes'ksm statistic items */
 		mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
 	}
 	/* Print memcg ksm statistic items */
 	seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
+	seq_buf_printf(s, "ksm_zero_pages %lu\n", ksm_stat.ksm_zero_pages);
 }
 #endif

-- 
2.25.1

