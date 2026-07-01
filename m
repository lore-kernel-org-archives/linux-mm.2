Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99A5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811D66B00AD; Tue, 30 Jun 2026 21:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E94E6B00AE; Tue, 30 Jun 2026 21:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7274A6B00AF; Tue, 30 Jun 2026 21:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 417486B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8E4A8BF00
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:24 +0000 (UTC)
X-FDA: 84938459928.21.36046A9
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD72F180009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pA6m5Vb8;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869002;
	b=r/1ZDdmZvrVqI2K6VDjHdOHEtMEM0TdxQGOiR/frp15oxJHaNsfRLeJiQXgN1s2NDHrF9S
	wXzyoSxTUsTJKQuD1YHaJINubsKK50+uqr/q7/5LWStAV80BGelphxx0pSHQ7ihyy4sPR9
	HwmXGcutI7upQ3oX/hi6ETGW0/otl9A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=aWQ4LteqPr7JQjR/G9xeUQ/1anDc/cFqBX3sl5e8mS/+mEom2FZbJItzWQSMQZ35GOFYJj
	yu1FlUxV2Dhjk6dxK/2yzaSWVBd8lRk+RKMHF+gY22iQIk5KE2RMNsRCXQ+TxjcYu4oSYe
	WKgPHafk3LFS5nEvNKxkQudUSqQsqMw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pA6m5Vb8;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782869001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=pA6m5Vb8KmRiyGsfhZrTgKQYfEpC++IIFH5Ly2vt2JZ6mpCZrbVvVGCO/Nlw14adeoXSc3
	tFWLbSEPGGDTRuQ8ctN3wHUfRJevqO/EWiOcW0+rUBajSkN7jsxxx21iPHjjTVGmvi6syg
	v39BgAuIcEaWMGMCl1oslYt2oU05+GY=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Wed,  1 Jul 2026 09:22:30 +0800
Message-ID: <20260701012239.315262-5-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 6f4prrcz3qxfzjtfd3pm9x5t6fgrintq
X-Rspamd-Queue-Id: BD72F180009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782869002-987508
X-HE-Meta: U2FsdGVkX1+JycbRzzu7Oaq9cQ9Yu5WspV4rAFELnLInDSr7c6buXdWTbCIw6u12fcE+IV1XnAiDn3j4xdnN3tGQL+awHo7PCbLNHRw2/OQdi2SunWxvbdLMwDBlOIqjrw/LvRErTTGnfleotJM5QjmqhTyoXPcGeKDj8ozM7R20dTUWdVcyFUnsB8ggCRDoJ/xDaCaF7Orz5/KjPCtjTsSCYUi8wzRn9ZZf8kEcWgUMiGFxCfzy4TeiV7eIWl699IEd3slb4JfzaH27yth2FUgc0TsY24sxoScuaodNFG9hOpGjYE7yDYj2b4VX/7COVp+4iyAjIfSxxFS25ggZdrDoP5PRsJyYoWtMBelQtaVKHeS48dOAIaHmyIpvVMkC+DMKePkcbz0phQA2MG9JJySE0I+gfYpdZ1xPnfeKAjaeLsgJRadnLHsvX85HF+Am3EOhwtLx0SW1SfmbN+KsfIosq7nSx/W8sYJ1B4kj/OVbV+qIC5WHvpyS4YFahYCOeeDu9IGjNoPiO2T6hekxf5dutInc7cTxzhQ0gQ78xJzYWZUcx/KMTuChtiChrEDNkd62A8r5o55mc2hNspM4o6oIi/ebBOlL4+a8v2RRh28ms4pOf3K503mDWGgt9YrYudgB6b40ISQVy0vrXNjgLz9F9yl0TqwWfNpcDrabHwBRff2ZJI2/9STOcGeGVJ3eOzCLMVNNSUC6EmxQMILuO/4Cu8SIny3HyEUx/mRtewJK2X5UPBgtBZIJzESaBNEq6mq3HgehsbNVryziC/zeY6W1l/4kSsDldy7bpiYtGiIHvDGpweZqf+Kfb2thTR5MsCV2M7IrsUkEBVNBX83w7KbPY/ir2zTH7mZ5Qr741g8B9hLNVAtVPhxc3wdPl2VlFUKFXosy6a2P4HAn7VcnIXOfqiEQU1HR2+fl8hdQkn3Zkpf5wBN5xGvpzMabjmcoezV5oFyZsfxj5zJQCtt
 e1astsAy
 W5K5zsQyB+MFXEryUaNu0QznChD9ZRbLLukf6l5PJj4E17IvqhjpB1Bqw8/yiwWT3tPACGDLF3vf4d4W6FuPdd7kWZplqTGrrOppshzYLLDEOA7djEHNrmnyZUwQzyNKXj/6jCQj51Dbw9LwaT+WSXfazSiqOUf0NkjjopdqddyUF9fadJjcMxssyjta2lXtGxdD3bg08vB9Adj9RLqpb5s3A71V2Wz0+mz2ksSNgvqwthqyZ9cWhFjuoa4pFB5aNZX3bd1V2xg2Qk9o+2cK6dUumhDSR+QKOUp9ZbyA4rudcRdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
entire body via #ifdef inside the function, which leaves a no-op
{ return ret; } when the config is disabled.  Hoist the #ifdef to the
top level so the real implementation and the empty stub are two clearly
separated definitions.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 4e352941a6e2..fe2bf2274d8a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -522,13 +522,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -556,10 +556,16 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-- 
2.43.0


