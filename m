Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A813CCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AF38E0008; Sun, 21 Sep 2025 11:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBA98E0001; Sun, 21 Sep 2025 11:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14728E0008; Sun, 21 Sep 2025 11:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE2028E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:14:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A8BC119B73
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:14:43 +0000 (UTC)
X-FDA: 83913604446.22.B1FB7E2
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf21.hostedemail.com (Postfix) with ESMTP id D06C61C000A
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:14:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDB2UOccXKckWELAVwstEUEYP4QQe+WhGb4TKCbjt4A=;
	b=KOz3Bs8HI4bbxzEXrYXQV+/qtMN+u04j5LDKf4B4gn4HIPxWxSDmWIm+0VMFNRgympQ86w
	ZB5Y2dF9qjiuBVEen/eBDfxbFnIx8yzGRdjcFm2uuUOw+ta9V0Hv0Fu9sB82S4sTXKPOdQ
	s1ylE0JWOAIDIvlQiPUq9Po8CJvQJZA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467681; a=rsa-sha256;
	cv=none;
	b=pN5nF9gHXJbEuCfgiz++qlVnOcP3HRrja71WnYhIjfGTpCZpqXe48u+9fIqj/yxWXGpg7T
	IdqPp+ID6XWfpe066twtK7+uJFvlh3rW8WimtuK8RAJh3ComfL7A+TCl8ytrbguzaGU1jV
	VDinZZHcThN0GjLg9nzdFV835g6l1yQ=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cV8sq4ggvz4xPS7;
	Sun, 21 Sep 2025 23:14:23 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 58LFEKLb056996;
	Sun, 21 Sep 2025 23:14:20 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:14:23 +0800 (CST)
Date: Sun, 21 Sep 2025 23:14:23 +0800 (CST)
X-Zmail-TransId: 2afc68d0164f141-02cd9
X-Mailer: Zmail v1.0
Message-ID: <202509212314234220Nz2yHDfXTgwoTRJwuZTs@zte.com.cn>
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
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgNS82XSBtZW1jZzogYWRkIHBlci1tZW1jZyBrc21fcHJvZml0?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58LFEKLb056996
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 21 Sep 2025 23:14:23 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D0164F.000/4cV8sq4ggvz4xPS7
X-Rspamd-Queue-Id: D06C61C000A
X-Stat-Signature: nff7yk88scit7jxmpi9btektxhgchkiw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758467680-313570
X-HE-Meta: U2FsdGVkX19V63/NtgUHzmCZDvkVBdX/Tfr/okhogCKTM1jRr9Y7I04pwmFO+v7WjA+wI/3nZS8xlJ9JVcHnaBxtpxs2rAn/tEJlpKEVLd4xCSWxZM5KfNQt5f7ON0OHYjCzCzQZrDgqmYDJ/L/oO4EhsXGfwyWQBU4fYPr6eXG4TJShTxB98YBcudnGZHnpCmRE7y4rerNINpJGOSoEAXl42zId1qSfPnZtYFfVEn4r7tHwQi+DOxJ/UvHYxJHka4iSNplSrljXoGoAkaSD45mY4TxXUPwsIemBkd8q8/vszsNexPW8hbtFOSAFANGrL1sLup711KcLeX/dtZSbFO9CgVeL9dT7e2+EGbhRHuAS5BJZPTXEoiVelNDBLyQ3BHNHadeVNvs7v1ryEycgxdPqBoFFWPLp+KwRLZyZz5NsWa6MhCNxIzCbE41UEEb3wGfwD2Gz2+/e0+qJ0WGUabkSXYNkoF8UR59NdfxQnKp/+fQQ2fKrUqi6eiv2j5ZAFO/aAhwYe1HDHDwvtsOp4Rvk0fcKySqX1QSSArhC1FOvOOjBWOwZWWQCJq15YO0E2kAa8r//weez9+DO460Yd/0BmmmJ3TLxlWAUxK9fwv7CTQi7D/yopz24MnqYIvQr4Exfsa56PeTcDm9Zkt8KVeaXRwEX4HfTr+MvYE8o1GbkJo9+X9yNZVuqebn6cGx6nVefnrvEJuNbvt43d+loY+5oY3MdYgjtuBdmJd79O6FxJSakYYfgNpuxDv1tWWH89WnTst2GCEE9qwcazQkK+Y5Q3K3/UyjM4hkg/zOytWs2ftB1f0mUIhKfo41nI2LiOOOTQuxGDp8KqP9/1BQl8lpACsffBDwfwBAwnusRqagjzqIchdVy+MpGy0HOECEAF2xFdpG6dkDifSywM/el58UUeSBy8ozuX7eYoO/UKkG8/f7Mikq7i4hhjbRTeGGY2LTUq1RkmmwkubgN2Jw
 QzpN59L6
 bhw+JIlp3ZoyUCsfg+5ZlxbgIk1S2zJ0iGuTnyKWB+g8A0MLx38zfkGu2X5VYIGqNNuan8kkB1g8XLs8oJMQ1Z9wFg8T/Os8Bh5DFnHpkTWNY7F8vQ2jdym7zVrumD+Mnm1xaELwyUfeuNAntFYSldeXCDtUmjHA0aII94xDhZyrsGPRcRtZbo9doPG9nOyk65w3wCWdPjwBZScunc2cDzZ+yJt6IoBHB1nI9SHTEdFaU4y0CIyBnfCJVzqr24J9k/wYWsceyRB6etjrcxl0p+7a+EiihnTPPBPkGYwvCCB3l5dw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Users can obtain ksm_profit of a cgroup just by:

    'cat /sys/fs/cgroup/memory.stat | grep ksm_profit

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index a68d4b37b503..55329398797f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3307,11 +3307,18 @@ long ksm_process_profit(struct mm_struct *mm)
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }

+static inline long ksm_general_profit(void)
+{
+	return (ksm_pages_sharing + atomic_long_read(&ksm_zero_pages)) * PAGE_SIZE -
+		ksm_rmap_items * sizeof(struct ksm_rmap_item);
+}
+
 #ifdef CONFIG_MEMCG
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
 	long ksm_zero_pages;
 	unsigned long ksm_merging_pages;
+	long ksm_profit;
 };

 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -3324,6 +3331,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
+		ksm_stat->ksm_profit += ksm_process_profit(mm);
 		mmput(mm);
 	}

@@ -3341,11 +3349,13 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
 		ksm_stat.ksm_zero_pages = atomic_long_read(&ksm_zero_pages);
 		ksm_stat.ksm_merging_pages = ksm_pages_shared +
 					     ksm_pages_sharing;
+		ksm_stat.ksm_profit = ksm_general_profit();
 	} else {
 		/* Initialization */
 		ksm_stat.ksm_rmap_items = 0;
 		ksm_stat.ksm_zero_pages = 0;
 		ksm_stat.ksm_merging_pages = 0;
+		ksm_stat.ksm_profit = 0;
 		/* Summing all processes'ksm statistic items */
 		mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
 	}
@@ -3353,6 +3363,7 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
 	seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
 	seq_buf_printf(s, "ksm_zero_pages %lu\n", ksm_stat.ksm_zero_pages);
 	seq_buf_printf(s, "ksm_merging_pages %lu\n", ksm_stat.ksm_merging_pages);
+	seq_buf_printf(s, "ksm_profit %lu\n", ksm_stat.ksm_profit);
 }
 #endif

@@ -3647,12 +3658,7 @@ KSM_ATTR_RO(ksm_zero_pages);
 static ssize_t general_profit_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
-	long general_profit;
-
-	general_profit = (ksm_pages_sharing + atomic_long_read(&ksm_zero_pages)) * PAGE_SIZE -
-				ksm_rmap_items * sizeof(struct ksm_rmap_item);
-
-	return sysfs_emit(buf, "%ld\n", general_profit);
+	return sysfs_emit(buf, "%ld\n", ksm_general_profit());
 }
 KSM_ATTR_RO(general_profit);

-- 
2.25.1

