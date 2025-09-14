Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A299BCAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED708E0006; Sun, 14 Sep 2025 06:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4E28E0001; Sun, 14 Sep 2025 06:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAD08E0006; Sun, 14 Sep 2025 06:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B34E08E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:06:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FF31C02CD
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:06:06 +0000 (UTC)
X-FDA: 83887425132.15.7630533
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf10.hostedemail.com (Postfix) with ESMTP id A02A2C0008
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:06:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wB6akkzILTnfYzPRN/S/XA+9L6OTUVRM339bXz9tVbU=;
	b=eAHk94d6X+O7EDg9FuUm2yOG3Gz3fw9pm5tsOZkM6gfauKNsk8E0xV4tr/JsopsVkeW9d8
	A7N3Dvc3a3bfAIDgRbmkPszgH3W9Fkqgb55w0INAXSzk9b7BiZHBSSGqxIC6hBBYqwjh5U
	42fQmTDTzjotCLXNQl64wE93tyC4/mU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844364; a=rsa-sha256;
	cv=none;
	b=8PGHlCEfOOeP3hmf9eszUthHeAn9VnajE5y8yegll+5h1FhYNFD0ZA7uJviERPTgpFf065
	OJthMTx72+r7yYiM2ccKcuC33UJaz7gqa1jV3bYDDJXK6NTL+tABcW7S+2pz2s46dWHWx/
	hb0Qs/RNngGsrEp5A6Rfl1NQa6QwdEg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cPkM325p2z4xPT5;
	Sun, 14 Sep 2025 18:05:51 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 58EA5e4P099229;
	Sun, 14 Sep 2025 18:05:40 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:05:43 +0800 (CST)
Date: Sun, 14 Sep 2025 18:05:43 +0800 (CST)
X-Zmail-TransId: 2af968c693778a4-65db2
X-Mailer: Zmail v1.0
Message-ID: <20250914180543238RmGhd2wFVDA1pXX_I9Rrb@zte.com.cn>
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
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvNV0gbWVtY2c6IHNob3cga3NtX3plcm9fcGFnZXMgY291bnQgaW4gbWVtb3J5LnN0YXQ=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58EA5e4P099229
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 14 Sep 2025 18:05:51 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C6937F.000/4cPkM325p2z4xPT5
X-Stat-Signature: kjmsyzy3z4h7fikixdkxsmg7a8fsicgn
X-Rspam-User: 
X-Rspamd-Queue-Id: A02A2C0008
X-Rspamd-Server: rspam10
X-HE-Tag: 1757844363-288234
X-HE-Meta: U2FsdGVkX1/bhSdHeCaJrUKGx5M5xDrMELpoLTcz/SaHGz5lfFlXXqA99uSaCAQlz4Y6cmo1hiOFvJ3KV8FQTmDjOeUQz/vqWj7lLcnVTRS4YPQgQgV+mtqwywYPTnfoIDvADFNKMZziGP4PCNRdQkqWEhul9Nb+Ub4OhM930/RVfyIxHrQEAj4mMcJjITR3MI+SkX7bA7t53uXykya9E1BxhtYp0rDbKM7nR1VndbCPnhrXaULRAxsJKB64tluiDHWJ6yZWypKNkAFSIJaTkoBkgpeNF9rD89YHhSlebgNBM8prnz5ymYtEQSWPWEjMTQbHcyawZHNnfOCag5GU6LuAjuhoQ8Q0KUjITNzL1IgLO5xtJLkagbvAenNol0AZcCdOSDBtQiM+97Vzl6lYINnD3rQTegLNfwsYcdlgcLXL7yw1psdvjdjf3EUtKU1fJ90E1WNt9ogshAoxX0kDOal9ZGN0rH2BHTOeFBkg1J3giioPPUNP7E2RGXoLaajnaKiUKrprio2KNVg4EYXh1cutjscGZM72pYquzmroOZ0KkRTyEGpsNA0uhgPwVsxT/lOjkW8b3FnvM5hhI2rzgBj+cuIcQH+tinemdvcFY+GBuv2eia1OIfia+sEcbAICZLJUkkPShTHgwnax7frn93EgNdwmCXFk+8kbv7HbZM3Lpmx6tpMzvbAbDDxsCqeCWUjGfBygX1V4iOSJoQCZOT/el7yU9y0giSyShctpSwHTy87IXcOkPGOvnp/vprDjyH9VMczR+4ZMBL8UkNHajpENlhVIn/pv98oYwV8oJXEFgQbmCgqci+plK6DZMmoTmn66NRnmmbWUzxvx3ft2RoMuqjuEiSkJxiK4fSH5/C7Tb0bQUMi+5Ey7SRUh6IBq2lkvkdAM2w7FUC031KPwZUL8mm9V9fefWjgqZGjZc97NJp/EG2AdDLkjHt+dQqVg90siqFKZWDY+wxBBvOo
 e3O8knPh
 AMXqCmZ8+IiB8mnia/VNNwWpyUPc8VQGp6kJ0m7YWA99YxWcOJyLla6TBBZpRQ7hmf8E0/fQsQMKBMtE6BM3iB4jWWisNNBA1yrkR7D29ED7uGydHzHDhslB13JxtFHEne5VxiTWRg9q3fgHlK4qYvHHjbkSaFasDAK+oOHq+k+L/zc1s2wHBB6DssfczKidI4a8bXyKWjbPOKvmguuRyM+4SpDAwg8JyxClclfS+pigzVoSLkjXgHIBtbqrcHF0ir+4vUDeJbBYF4cmtIBWWyfHCwoIXCmVUv7vxbpg4/s3Lfo4=
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
index b533f0edaf96..5832159214f8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3311,6 +3311,7 @@ long ksm_process_profit(struct mm_struct *mm)
 #ifdef CONFIG_MEMCG
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
+	long ksm_zero_pages;
 };

 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -3321,6 +3322,7 @@ static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
 	mm = get_task_mm(task);
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		mmput(mm);
 	}

@@ -3335,14 +3337,17 @@ void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
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

