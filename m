Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD38FC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06D96B00AD; Sat, 27 Jun 2026 03:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B79F6B00AE; Sat, 27 Jun 2026 03:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E6A6B00AF; Sat, 27 Jun 2026 03:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64E606B00AD
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:25:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E554F1206BD
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:13 +0000 (UTC)
X-FDA: 84924856506.23.7B683CA
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53FCB140003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WjYVRNgZ;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545112;
	b=bLN602n3azUtPMqn96Cp9QK/JXO5C1DURg0d3TG9TPi1uz+lkEkoUV9Sut2D/ELgvGQolz
	omgzy83u73rscEWYtC/4JfjwIKHVeYy9qQ1xf0JBDwCBZeMIngxF1ouO4MCbo/9AUSs+8H
	Q48v8unu6Db8gRFzm1pZ6xmei2O8G64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZvZGSG5jOLMYDPRs7s32jMDvXNepxeOOwA2iwapnr8=;
	b=ISYx2NCFwBI/MQxP+Olh3lXFVh7AI8xZ53iE3LMFABiEtBxmibg0sdHHUpOHFwdMeAe7kg
	BvE5fbQLbctUykmmR4ND6bCDkhw/iyH2aCjTNEQGFNpw1XAYGNIeJtQWeY6nGaxFiEhMP3
	Igm9LPUszS65bh5zZybfXFXmtrzeAnY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WjYVRNgZ;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZvZGSG5jOLMYDPRs7s32jMDvXNepxeOOwA2iwapnr8=;
	b=WjYVRNgZ1rp8XgvNn6uHLbOrxBaeWPDTSaN8urjXkQjMfJFhWZWFviydpWd051AkZ7TWAs
	JARDOOz8tENGDeJbvOAyLqRQNL85Y8CInSUt5GILQ3OiMm+vj7ejNPKDq2uKB6Aj7CB4m+
	rvrQ/IjlD4ZdHiqfc8bFTH/OY8PVd8s=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 4/8] mm: add reserved THP quota helpers
Date: Sat, 27 Jun 2026 15:21:52 +0800
Message-ID: <b6256043b68022678e97b2541fafa441a57c0408.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53FCB140003
X-Stat-Signature: chta4d75x4n31rjdhsrxb7p7wun1a684
X-HE-Tag: 1782545112-450038
X-HE-Meta: U2FsdGVkX19lWBpbNAmVgtrJkUQfr0s9H+8O2Liz3RkV20pfIXXIbf2KB+VcMFAPbxmvHBBsKf3r3kghWwq97VIQpSZFIzPe9fbuZOUg6Ypb9sX751yI6eOSWTjtfU1AZGaFA2SxySbQhnDnzKYgCeEAsFuOgfBNcQPP0RMb5afj6kvE6wK0utAxhFkdvWYGl1JcIcyGiPxcvOu4b8xa1V67pDd9NkYzGlMTocJuQTDQ3x49icZgq7sRZmD8YUcAdCwXWBIm4398sJjWmmqb+DK2KjGmCb/USslo+CiRWn97ekxQksv1WhaxM9pMIGBCsHFkGXX8G5sAnG7AjiEFTU0gB75YRJQEIXAh6TVMyv8K4a0a4fG8oN8TXXexpM5TWyV/JyOIP2LR2WAWkaUoiKg58cKP58HmXjGLSJnzEIXOZQisEEVdaFFFHha+pmXfVn4mtwL69yPjCGeXPfcssm6OR0PAamRf4+NBtGb8eW193iS0CazRxv08r3MZ8z1N9q/XkTmAKNepInq9GrKuCywmUeW+rE3mSJq6xUbVNP/5UG8B/geiJ+tylq9UlRbO7NScUjnMcKk40Ke48LNY1bJ1+aX5yTVydAbUO25flAjRfbundpyX3gb17ElWt5gmSqoIbWs+Ji2YNtLp0n7U7R/KIlNZzOD5vpEyj+RF9UKmlEAbBa+XcFWJGid764E3tXc1Zvo03VcGBi301BV10hFg15UzaWvXMj5Qh0eqqLfcerw919IDDTHi+VjOq5YSrTUxWMDm8orYjMWESMHL7AcTPQhY7klO7IPueXFqdhKiMbQrK3qidGQB/ScLtuAGq8vbAz9fu3fJsJaHfxSdB03fO55FgQM4sJI4Uy8I3HZFscAJNdMGYolcPk/jIgWkfNaWXL4Lv5CcfEG9O61A/J3yXJJm9GSkepIf9NydRylMYSzkMc4hps9uQ0q1O/3VnZHdErPDjK0EFHXSlRV
 fdsbA78F
 yXwTTf23gemRMpdoJJac6GBHE2kJfl3WIucWLIXmInk8rpJwx3jukktBoPipkF9gr5W2thoLQQANyT1pLVS9wq2VVTELeZRm+Sn7I7AOdFzWYiN96cL6QzdRrlIFQqkTmW9wyrTB4F1MzYUIKCekut+US4rzvR8N3PsVfJMs2gvAzU/wY0m3ug3MM/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Add quota management helpers reserved_thp_charge() and
reserved_thp_uncharge().

These functions are used to safely update the reserved_thp_used counter
and check the quota limit during the allocation and freeing of reserved
THPs.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/internal.h     |  3 +++
 mm/reserved_thp.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 3826c88b3804c..4b2a13d353772 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1953,5 +1953,8 @@ bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
 unsigned long reserved_thp_pageblocks(unsigned long nr_hpages);
+unsigned long reserved_thp_hpage_nr(unsigned long start, unsigned long end);
+int reserved_thp_charge(unsigned long nr_hpages);
+void reserved_thp_uncharge(unsigned long nr_hpages);
 
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/reserved_thp.c b/mm/reserved_thp.c
index 1eee4f39b9d69..931c539c15a70 100644
--- a/mm/reserved_thp.c
+++ b/mm/reserved_thp.c
@@ -39,6 +39,41 @@ static int __init setup_reserved_thp_nr(char *str)
 }
 early_param("thp_reserved_nr", setup_reserved_thp_nr);
 
+unsigned long reserved_thp_hpage_nr(unsigned long start, unsigned long end)
+{
+	return (end - start) >> HPAGE_PMD_SHIFT;
+}
+
+int reserved_thp_charge(unsigned long nr_hpages)
+{
+	int ret = 0;
+
+	if (!nr_hpages)
+		return 0;
+
+	spin_lock(&reserved_thp_lock);
+	if (nr_hpages > reserved_thp_total - reserved_thp_used)
+		ret = -ENOMEM;
+	else
+		reserved_thp_used += nr_hpages;
+	spin_unlock(&reserved_thp_lock);
+
+	return ret;
+}
+
+void reserved_thp_uncharge(unsigned long nr_hpages)
+{
+	if (!nr_hpages)
+		return;
+
+	spin_lock(&reserved_thp_lock);
+	if (WARN_ON_ONCE(nr_hpages > reserved_thp_used))
+		reserved_thp_used = 0;
+	else
+		reserved_thp_used -= nr_hpages;
+	spin_unlock(&reserved_thp_lock);
+}
+
 static ssize_t total_hpages_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
-- 
2.54.0


