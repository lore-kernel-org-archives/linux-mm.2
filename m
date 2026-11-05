Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06E6606D833
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cwt/ENdp
Received: by kanga.kvack.org (Postfix)
	id 6B4F56B05B9; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E476B05BA; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553F36B05BB; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3565F6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B46E012047A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:10 +0000 (UTC)
X-FDA: 85400602140.08.4765C1C
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf24.hostedemail.com (Postfix) with ESMTP id D63C7180003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="cwt/ENdp";
	spf=pass (imf24.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Idn+SmsO2M3f0YI+n9T3ryw9MvtjbedDGjimEeioACw=;
	b=5BoDjZfgHlVaEAQPSwOrqT4U3b09ll6OHHGk8LYGaOJFw6FwIEl3s59+T+Xd8iyVN5DnB5
	1vr8BnKTK0j3+zmnDnSb14y/gdcNjbh2hmf/JfQdMaMtphSXAPv4jPbUXwYcH/sE9I9lhB
	CO8dHZadXDtsWcTeOrQwRwYzhNbbgo0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="cwt/ENdp";
	spf=pass (imf24.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872389;
	b=hY4QfSFoN4Cnjoh2tWhUgJGjDjiLcqVT+GVfkNK2wxTfYvXv1EDWEW2tYgcWSe6pJ853gd
	pDTXBycv0Puo/f9cILwChHHTU4+SikeoaZVjcl04I3kdyyFS3ff/txuO4H8VV1D7cPwDIn
	Tmj81oqOH4yUQxkbRuv8iSpglH+SjBg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872385; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Idn+SmsO2M3f0YI+n9T3ryw9MvtjbedDGjimEeioACw=;
	b=cwt/ENdpsNSpqxL/yIjsjtB/jVOB5EEk9RidqDu2Va6s+SyPjDnnVASOuIaW/NhlENCx8FRZ/XURN4Xi1x8E8IC6RuiYyE2S3AMBXMJzrKMCfh/TOYAhM90JJ9+RsqertZnemTRZXM8aIWJ4AT/GDOqUwZ14Ls7oMsKN1V9G0j0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XE8JNsH_1793872384;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XE8JNsH_1793872384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:53:04 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: catalin.marinas@arm.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: kmemleak: reschedule while reading reports
Date: Thu,  5 Nov 2026 17:52:50 +0800
Message-ID: <70139bdb8c7a61913d5081671fcc2af37348fffd.1793871596.git.tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1793871596.git.tongweilin@linux.alibaba.com>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wkbj8ifdn3jxnuip4eppdfz66imgtbua
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D63C7180003
X-HE-Tag: 1793872387-965161
X-HE-Meta: U2FsdGVkX1/vw5F9YyHxI5D1qaZVyognxjB/Vgil4+n5KLX+XvB+pEO/G3F3gCVKkSSsaEkEpeJkM3BM18UIKPmeY+PwhzLoIAqDGvsj6EDtjTP7nSo50Xt69MZ+p4MsDuhs9iLck0lw+Ko09fg8PpqTqH2l1xdyI6FQ65VN6CEwYDd7dGtFpS/lBAhzzOYg7Ylk7k/0scgN+LBxHKnIbHBYlCNyq5PzDqaxNFyxupGnL+u0wJFEIMIqZFlGzzUUjaefN2VmhNtoHKVmoqCL8sNfXfuXp+1PxAY6lmNwN+vkrbydfrgDdDLBz05JRL0njr+e1Iw0MC6ercdIaSDyxTveKI4xLC0eRimb+6mz9qxS6ptjqTQpsmoYirf8XIVkVK/ALF2fcKfofsJHYiBKDrnmbSwTgnHNhdaFXPtk0fXpjdfJZr47TQh7a2RsmJKu8/cYwSNNv2CWBFs5D/AZ7SCd3SFivFYCsk//+UfuzubdfDrcMIA4o2TAvb/gcZBFPpwsXPTcxm6yVKUAh/7CMAKArls4uxysKIg+AkNqdJuEvX1eh6Rchx85PHY0BkY80ZUgkQw5preWMbBJ6gwb0J30SaqWXXxsVKLP1j49S2wT9hmr3pTukl7Rpw8gU5+aLo3y4T8Zx1vDBZUpp7BmM8LjSTJA+SBEbrAERBEmLp4wFg0ym/DGCzsMRR4ICOBHz9q3b0puQauhULRBA0wBmkpo2jQ6+nB/gV93exp1vUIIHncVTJV3zONInQQs1AGPBNtQZCLrfMMF1f43IJ3qoZ+Yjh8q9+RtMKw5J5ltAvt9hmpIGJS1uvR6hMlXXACAPwM5Ktf8NfrkL5FWhuQh5W/P9wIniebxsrrMxXRN3FlI0LKn2AmkJAU4EQ7oJYqWuwniki7MX2m9TJNw0YNxnU9/EJf4YaXVpifLKGCL5U8+edgZiIi59FXgT1CEztswCFa6ZIq7cbRNCVdlcHP
 OU1Kc5+7
 YevGvSVMKoSptImKDKdpq6z9kodLpHw4uHMbVmQ3amhoCf2TAOCIb1O2DP6j9SWM6zkWeBTPzrPPlbVto0xnpLLz5r/UoTHcighl7fwLmjaZ2nLWCxReSx9K14f1ueuSh5GbkyWamXo0OdulhNUrsl2pcq6eqQG86TKSmBYBRBg4WO1LUULZtx1iZWuRc97gX5ySoAdUILCRF6kDD3kGPZSFMSETG+Y8eTWF2cdhFGjzuPXizyysIhLUYWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reading a kmemleak report walks all tracked objects under RCU, even
when the report is empty. On large debug kernels this can stall RCU.

Use kmemleak_cond_resched() in both seq traversal loops. Request a break
when need_resched() is set and periodically every 256 positions, since
preemption can clear need_resched() without ending the RCU read-side
critical section.

The helper pins a linked cursor and defers its removal across RCU breaks.
Already removed cursors remain under RCU to protect their forward links.
This allows RCU grace periods to progress during long report reads.

Fixes: f5886c7f96f2 ("kmemleak: Protect the seq start/next/stop sequence by rcu_read_lock()")
Assisted-by: LLM
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 mm/kmemleak.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d959d11f6..0fe7d336c 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2216,6 +2216,9 @@ static void stop_scan_thread(void)
 	}
 }
 
+/* Also break RCU periodically when preemption clears need_resched(). */
+#define KMEMLEAK_SEQ_RESCHED_INTERVAL 256
+
 /*
  * Iterate over the object_list and return the first valid object at or after
  * the required position with its use_count incremented. The function triggers
@@ -2233,6 +2236,9 @@ static void *kmemleak_seq_start(struct seq_file *seq, loff_t *pos)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		if (need_resched() || !(n % KMEMLEAK_SEQ_RESCHED_INTERVAL))
+			kmemleak_cond_resched(object);
+
 		if (n-- > 0)
 			continue;
 		if (get_object(object))
@@ -2256,6 +2262,9 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	++(*pos);
 
 	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
+		if (need_resched() || !(*pos % KMEMLEAK_SEQ_RESCHED_INTERVAL))
+			kmemleak_cond_resched(obj);
+
 		if (get_object(obj)) {
 			next_obj = obj;
 			break;

