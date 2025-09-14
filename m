Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15911CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713A68E000A; Sun, 14 Sep 2025 06:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C48A8E0001; Sun, 14 Sep 2025 06:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601BA8E000A; Sun, 14 Sep 2025 06:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2168E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:08:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D52B785A0E
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:08:02 +0000 (UTC)
X-FDA: 83887430004.19.8EDBBE6
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2EB9D40002
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:07:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGAAGGpNqN53b/yNQq3WgKSRX9Y7epIOW8u0GWTnNhM=;
	b=229mCxBx/IKc5oOPJ9CWDFdY7ewgtIxwnmyyY3pxbnZs+4xMmlpZoOamX7jR0IGLN8Ynjo
	hlNHn1w5R95jvFt2ACDiRS4ABIylHGYjtDmLKpWVjqT1rrgmqNojneIxfelj98EAosXP8H
	PhESDkhHlVa9ooVo72mdzkqOxS9+G9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844480; a=rsa-sha256;
	cv=none;
	b=FybtHrgkzzIS2HFnr4SOY9v6WuwFvFfS07kn+6s7bkCZ/NV8FGfP1K6m/NJNnnGJUM5i/o
	cm9Tf8xgDLnOBp61YO+jqXlDeCU5169qDHcw8zlkXo3w0PhKSx8L6cmOEidiFopWFc5pWY
	oFJHl6iU1M4LkFeYJ1nGA2cHty7vKoM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPkPT2RjZz8Xs6w;
	Sun, 14 Sep 2025 18:07:57 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 58EA7nNc099870;
	Sun, 14 Sep 2025 18:07:49 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:07:50 +0800 (CST)
Date: Sun, 14 Sep 2025 18:07:50 +0800 (CST)
X-Zmail-TransId: 2af968c693f6eb9-673c6
X-Mailer: Zmail v1.0
Message-ID: <20250914180750448qMRz3iTon78DoExPyZusD@zte.com.cn>
In-Reply-To: <20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn>
References: 20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <shakeel.butt@linux.dev>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
        <roman.gushchin@linux.dev>, <david@redhat.com>,
        <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDQvNV0gbWVtY2c6IGFkZCBwZXItbWVtY2cga3NtX3Byb2ZpdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58EA7nNc099870
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 14 Sep 2025 18:07:57 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C693FD.000/4cPkPT2RjZz8Xs6w
X-Stat-Signature: 6ubfw8wjzr33wk1fo8jszeufh1sbmjoh
X-Rspamd-Queue-Id: 2EB9D40002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757844479-876956
X-HE-Meta: U2FsdGVkX197+FEKAJghhoRD0MIbS1KLlUDE+3fBKnVK8FEF+3QHKZBBBDpn04jyRjUfoBUugPBeMIkt69Vh3O2D/vLl/REifs3TRdyN6/Mcq9R9xmHuF867tRUpRHmP2jf92NUAaNte3d+pVPe+otMOb1GBHfdSq+CIPdhXfKSNOYglk6vGtJDSfpZtoWpo1HOntG3b5Vfh9XB6t7ziH66CrRRuqm+r+H8M+ORuBXNVI31hf69N/Bro433SNM7rNQ0Qs96MZgGixkEyJQxNwPF6EMAr1Si1UFjj+cNDLdzizK8CvFxoQr3x52GR0xPi7oOPVltv4J3+1RpfjdSbzOhmiqJ+strkdTLT7AR8/JXKIbvnHEWBJq2pA+ykMhvWc9MEnP02zpKh5P/R5thz/2hO2gBFlpujsdJqxyKqSB3G4jwr0aJ7M6/WEGaf8nHL7jOQq19MvjMagzIZDLseGDHBZ4z9oDV6YOKR+DAl2CJSSfyMCUOhjqW/JU5pAULj6mvsv+BwcupbCgS90dbD3qO2ZJ9DNjJvo9q7UJZFj6R12VyyEIU9eAtbigS4BmjDfnd7xkIDsonZO4dC68O8aohsA+gUX1j8qkiJAKJoIJX4uibkJQVLv1X3s/xwz8Vv+HErkgqnu7Mz8v81fQG53mpsEvXDe+ZlqNKdyY9DneiPKm4F28naU7JyldSJajirdCwHug2H3vAN+RPz1L3jwBbxnGiYc72QRwqI72CAvesbtywN8tF14/kgfyYrhmXvLaSBGs1r7PdaP0gUvxFChWw4ivbafRlig+XE6bg5h5EImTyBwgTZGDPRXzNgmraX0hmS4ID9m/xnduFYCaAMzsB2vyoShiQX9s6R5aozE4RkE03MqrPOuP4KYOG/DG3TA7X22hZf+X2hd8kDhkE+midQD/Gl+MvQwKcwvBjzxRsQv8314TbcBchiY2CNpdOKOqlQL+5DdmbxQ+mp43y
 2gAVeKkz
 3Hu2tWHTJK6w8OR/41c5RaHNGzNomtcnwiGEqUPmrcaTOXj0tLLzkmc6AvBkazLNxJwqsZd7aUmER4CvWcCn5AOmZfNX4yiRHTiDXxVtnpqCVgCt6HJiBXBbfc/PJabu446QtScjfANOBGNhYaqLKMz1CXJUH8i+T4zBO2olT69k6NWBQIIwnoy7PzUKu9ZAoOBbFK5Ttkm6B7qrI0tkjD/6jYUxYJVrcMEMHxsJxSGH1WnQgEbk7a21ZVuIiXJZCszYd+TUXq1MNWFr6fndCaLah3cK3zLrjC0nIO9EU4mKuaX0=
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
index 4cc47ad1e887..c01567a3d5ca 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3308,11 +3308,18 @@ long ksm_process_profit(struct mm_struct *mm)
 }
 #endif /* CONFIG_PROC_FS */

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
@@ -3325,6 +3332,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
+		ksm_stat->ksm_profit += ksm_process_profit(mm);
 		mmput(mm);
 	}

@@ -3342,11 +3350,13 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
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
@@ -3354,6 +3364,7 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
 	seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
 	seq_buf_printf(s, "ksm_zero_pages %lu\n", ksm_stat.ksm_zero_pages);
 	seq_buf_printf(s, "ksm_merging_pages %lu\n", ksm_stat.ksm_merging_pages);
+	seq_buf_printf(s, "ksm_profit %lu\n", ksm_stat.ksm_profit);
 }
 #endif

@@ -3648,12 +3659,7 @@ KSM_ATTR_RO(ksm_zero_pages);
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

