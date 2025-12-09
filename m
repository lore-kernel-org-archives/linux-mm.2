Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBB3D3B7F8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 13:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D335B6B0007; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B036B000C; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CD06B0007; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE966B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9EF913B3B8
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:59 +0000 (UTC)
X-FDA: 84199985478.25.41C622C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A81E4000A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765286278; a=rsa-sha256;
	cv=none;
	b=YcummYu8xR7RCw2agp5iQWj+GqxCFrGp+5BHUM0Xh6mtzegehZ1W/vNSitAinP6OzX39BS
	Tw1mBnHfQccnkj2/Kjs3XqVNvJ3oAcD7mRsxmrAglvakLKIHZvNQmlfnTb21LtVFJDBvwN
	0zcqM0kSz3iZbkXCfUeIuk8P0VA/OgU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765286278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Zgg0673AtA7f6FW1mGjSzMBVDcI2ROd6PjS1t8xU8=;
	b=s3qHMsESLLqUZuY9gGtR6t3bC6LG4jQrbd84+K3Xyj0kk8GE8+mhEd7usgDD6KkZmiHfcl
	jssoJ2ECxFPg/zDlCaU6429OIDNJ5bH4iTLPnxfV4XisnTA0fEe5c+OaLFMWWjfJcu0S6Y
	5vFQIUyV0xkMujEhZ3FYdyfVWRU0eJc=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQfWj4PrtzKHLwK
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:16:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 302541A1A74
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:17:48 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP1 (Coremail) with SMTP id cCh0CgAnYn5wIThpE+mPBA--.4181S3;
	Tue, 09 Dec 2025 21:17:48 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Date: Tue,  9 Dec 2025 13:02:50 +0000
Message-Id: <20251209130251.1988615-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209130251.1988615-1-chenridong@huaweicloud.com>
References: <20251209130251.1988615-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnYn5wIThpE+mPBA--.4181S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1fZF1fWrW8Jw4fJFW5ZFb_yoW5XFW5pF
	sak3ZxZa1rJ398Wr4akFyDur9ava1Iqay5t3s7tryfZwnxtwn0q347t3yrAFW5CF97Xrnr
	Xws0yw1xGFWYkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxAqzxv26xkF
	7I0En4kS14v26r4a6rW5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0piKsU_UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 1A81E4000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: z1sigkbqnhphce3c3uyu4p5ihupn388y
X-HE-Tag: 1765286273-780210
X-HE-Meta: U2FsdGVkX1/8WM80EH6akOT8jJHEUnzSIgTdIGwY+YnFrRveaDmEayNTHN8RyTpggZNKVCalKKcbvx4cbWpXRB0A2HpoB3f+AvpNXK9OsOTCbSxkaWDLLcp/b19loXLnLEf7gyItJlnmQ7/44sfwMre1W8eAHOsAS9xcfo5FliwkzoB9SHU8TEbFIkIvAIdFao/kTLu9F2cNyuAftazvLp/dag/v3neBI6V8HmAyu6BxaXBUqeL3g9TjzoiwBttFNN6Og4AHc397A4Va9QkKCEK94pB476NtW/+JShjNvacDa9KGs7ivGNvNHP/ArLRJ+d8CLFoQHB/ndzvOQ4aCseGOYPBCELoCPMQ3TTDL18+Rxw7UDqaeBXiE1TnD598lsg1LSmRaU/VgI/8OqFGUPpM4e8x0RvN0W2IpNdSSbtiVTLjwT1gbTyWkKTRLVn6zroIVS7vT26I1qYDkRFZrYnYqfWSMIASPYRyWKDerrB7Qdo6KKdBTzaJgE6icJxShqp4aEIjp8A2yyUs2LCifOhSJVYUyKU4ykHhpLC/+USEFEq1T2FxZtnn8HI8vfk68J5bjZWWihopKkXxkoIm3Dm5rsV971TGzR5o2WMB+RDz4UkePexk1seldI0NthLR7L1b10SIklsIz/A0WjEMNSo1Hmji4De/Gjku3RTlZkq94GOPjIxSOFYxCspgeV0Td5PNqf5RNz4g/SAtx3Smh1xa51tmmN4Yk+tzpxdYqBc+Mw2KZX1+c4ECvGlObBDa1dvMyobY3u3LuJ7YqgwAi37fMrBnpbK5TUse9gJJWp3gvwOHekcy3OrX0ZIOtPBks58gJkPuNqO8r4iG/V8XxaKvXvt0ZR4vcJssKRxrwB3IYa5MlQLa6CRBZBVR6IozXq95Lc36DhSTnTM3iXlLv+XkZ0eJBL+w42pKA0dUPAmdVF1yMEUpu0HBiWLvYJHEjIWjIRvpJ9Cb+msn9eiu
 CvIFCeK7
 8j9IvIygulxBcDMUN2SQ6CyAEuV8n92uSwx7aV921yPUas+i0vu7DKT+I4gdTrFu5lMYUF6UAvYzP+yNou0aoCW/78EAIrzY0pUPd1YMQMSstJG0pwLiKkD7CwXmYqQ1rps1a2eGfsWZ/IK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Currently, mem_cgroup_usage is only used for v1, just move it to
memcontrol-v1.c

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/memcontrol-v1.c | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h |  2 --
 mm/memcontrol.c    | 22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..0b50cb122ff3 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 }
 #endif
 
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	unsigned long val;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/*
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
+		 */
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
+		if (swap)
+			val += total_swap_pages - get_nr_swap_pages();
+	} else {
+		if (!swap)
+			val = page_counter_read(&memcg->memory);
+		else
+			val = page_counter_read(&memcg->memsw);
+	}
+	return val;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..e92b21af92b1 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2e49f4ec9e0..dbe7d8f93072 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	unsigned long val;
-
-	if (mem_cgroup_is_root(memcg)) {
-		/*
-		 * Approximate root's usage from global state. This isn't
-		 * perfect, but the root usage was always an approximation.
-		 */
-		val = global_node_page_state(NR_FILE_PAGES) +
-			global_node_page_state(NR_ANON_MAPPED);
-		if (swap)
-			val += total_swap_pages - get_nr_swap_pages();
-	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
-	}
-	return val;
-}
-
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
-- 
2.34.1


