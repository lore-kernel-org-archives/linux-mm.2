Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75110CAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7448E0007; Sun, 14 Sep 2025 06:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C679E8E0001; Sun, 14 Sep 2025 06:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4B28E0007; Sun, 14 Sep 2025 06:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A83B98E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:07:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DD4DC02D8
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:07:07 +0000 (UTC)
X-FDA: 83887427694.20.978A535
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id 96BA340006
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:07:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqDjKOwk9VCJuA81gDnJe6Uu/b2OwopPLPkpWYavjuc=;
	b=fVTxZrWzqToJ75TqPJ9yQ/P8mXf+/qb2zE/DVkkcGxzu1RkCXH0oagO7gAgMtc5bNabQR0
	1DYKNvn+TYmCygZ+JPa0wxQJmzm2kpQD2qIKf+BF5tepDCL2f8oz1HYGLDikKVFpMAVVrZ
	KamEpzVja7tcxsqsDSMXpnjyiFpzGZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844424; a=rsa-sha256;
	cv=none;
	b=IHutbk+i2IuQdEzK97+r7CH63s/9olQ2AZbuy61u+1qK81pAgCZyyQq5Rd+d8hqxRZQNMQ
	DHUXCQdtPuWmv5VJDZLixwgJV5evK+2qpv1p8VA+lRYzde3oh+uyofQvU5QebdOtcVW7/r
	XSkEEXxLLO9a8XuF0+oF74g8d80jrKA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPkNN28VMz8Xs71;
	Sun, 14 Sep 2025 18:07:00 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 58EA6nPp099586;
	Sun, 14 Sep 2025 18:06:49 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:06:51 +0800 (CST)
Date: Sun, 14 Sep 2025 18:06:51 +0800 (CST)
X-Zmail-TransId: 2af968c693bb4ca-669d7
X-Mailer: Zmail v1.0
Message-ID: <20250914180651981vC9sC806WA8UGn7FNbL7N@zte.com.cn>
In-Reply-To: <20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn>
References: 20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>,
        <david@redhat.com>, <chengming.zhou@linux.dev>,
        <muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDMvNV0gbWVtY2c6IHNob3cga3NtX21lcmdpbmdfcGFnZXMgaW4gbWVtb3J5LnN0YXQ=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58EA6nPp099586
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 14 Sep 2025 18:07:00 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C693C4.000/4cPkNN28VMz8Xs71
X-Rspamd-Queue-Id: 96BA340006
X-Stat-Signature: eghjizrke1qmpmqah1bmu16fxmbm1xew
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757844423-405198
X-HE-Meta: U2FsdGVkX19WeCepvInrVmpyuZdsFzWPiOEBr/UnovvLFrJC/LiRn9ozbRiYcd49pfkVxstUcMUX5Iv8OPF7NCnlaho3qApThB9ywXvWddSD3yZLAS+Eb/GDXMF9t4uh9EtjgoEZ8si/anwv/G25zjR6giGG6HRz+/TjIxUVlLX88YFHcdXWi3eIKu90NTZYrvDT7ZEMwa5CMIlc7FGLAYjjfQUSl9xQ6PPgVpPEQtoSMJKgOo6ur7Ceo7CpQ+PM2KPdIu0MR0y+xrBiCJTWsK+UqTxI/5MMKk0Oyx2iPNyt5Ibp99/DE2b+R5as4PK/rLMgRdoameWNzDvqgGYLs7sHNYwxegJoG6BkfRXa7P6TJTAqzBmHGfx1w87OUTv426PXD+ztN0/690fnBcs1IXrHWxzeYI2bLiFyZXLHKOJe/YkFo9lHfgJsBTwso6ElQiwNUfmmFbHDsdeK2/I4QEEXKbXzK7lzjamYZiCAOpbrEA+byvdTxHMm6IOdfGU0tPsFnL7p2HvUS8LyrQegoM8ZzcUk8nDfX3aJgLLY1QNMKZLsybAHVD7m3d5bCCnjShm4i/m/p6uEpdoOsfCRV8tTLOOiCBKdikorq+ZEThSBP8zLDO8nCy05C08lWkqCpVKFZqijfSiLqK89Wq6L2mqng0z+8deM4GXCEoFX9vDaXWGbpQfCFSf+zCCZ2HUgpwQab5uKP9zvzXKOQ6hcL7acw1nEj/nKegjVTJmX7kniYsGutvhNN7Y6ZVFR4QbaHbo1UIm3wPC3uLoFEbK8rbRQfroAzRh4BNcFX5FgzKKzNhp9wMPv3nshwWM/iCyUf542TSks+3kru9+OYr/ICSpNikSjzJ/ioABBYAmjQwkqxh5IPw7dFLCJNOZ5VuWFpOqhi1sco08NGj5XfRNAcJCKPdkxvpQC
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
index 5832159214f8..4cc47ad1e887 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3312,6 +3312,7 @@ long ksm_process_profit(struct mm_struct *mm)
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
 	long ksm_zero_pages;
+	unsigned long ksm_merging_pages;
 };

 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -3323,6 +3324,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
+		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
 		mmput(mm);
 	}

@@ -3338,16 +3340,20 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
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

