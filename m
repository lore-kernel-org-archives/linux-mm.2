Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4B6CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68EF8E000A; Sun, 21 Sep 2025 11:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D409F8E0001; Sun, 21 Sep 2025 11:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D5F8E000A; Sun, 21 Sep 2025 11:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B64CE8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:15:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4092E869BC
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:15:30 +0000 (UTC)
X-FDA: 83913606420.28.D41B07A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id D292A100019
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:15:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp7nmvs6dapjdarZq8sU6jXjvc94w+yI/ZAt46a5lKY=;
	b=sD7B18/6s1yBDrT3gfr1LWUc5QKtp2vRrQsCLxDTmmSJxJkfGEFnhtOYxSeqjO/us5p4Mh
	ZZPcjIEChZuJE2KVzl6DpY6C1ri0bxXrS6CfTCs4cDThMlPvgqVIhWy/qL+7Hluhh6JkqT
	H/Y7bdeboQH90bo8dMbwpX2xQVxnu9I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467728; a=rsa-sha256;
	cv=none;
	b=R69DOv5CSrXjgecCNEUFNBh9mdjWeODewiRXtUsskk3KrR2LtQYztUixzIV/4nd8rwT7z+
	FKatiyfa03fvVFAa2WQBPXfnz9ObaTyy1AZLR5Y0wYzy+CqBx/Qf30PFFeNnZkvl+CcHMB
	64QAIM+9VVVgRuSuipddRxvLgSlQS7g=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cV8v10dxDz5PM35;
	Sun, 21 Sep 2025 23:15:25 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 58LFFFLK072474;
	Sun, 21 Sep 2025 23:15:15 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:15:18 +0800 (CST)
Date: Sun, 21 Sep 2025 23:15:18 +0800 (CST)
X-Zmail-TransId: 2afa68d01686f1c-20a97
X-Mailer: Zmail v1.0
Message-ID: <202509212315188885yTwMVyN-Xn_6tuRc3Zi7@zte.com.cn>
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
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgNi82XSBEb2N1bWVudGF0aW9uOiBhZGQgS1NNIHN0YXRpc3RpYyBjb3VudGVyc8KgZGVzY3JpcHRpb24=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58LFFFLK072474
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 21 Sep 2025 23:15:25 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D0168D.000/4cV8v10dxDz5PM35
X-Rspamd-Queue-Id: D292A100019
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8mdhifzt191s41hxnnr8ck1hw6cq1kqp
X-HE-Tag: 1758467727-231175
X-HE-Meta: U2FsdGVkX1+7OzBdAQ15cOl28rcLbq/lni8laA4U2cLP0hPGTE7tJ5CyVx5XVLc1FqHPIilhUKQfmoeQLz3caPpAnsE7jNV17MNqV3ApVKyvAMyof17+LtB/4GjhnZnM4dafqyx0nyhsQWsR1hZ4+1rLSk0CrASY3BjejlzSevXiZiMb3yGcKviqKSeGEpg84Ct03LqtB1cNl8O3zQaOV0nsvNRljihRJl8b34Fp8S5hZSK3ER5Q53iuY5PU4db7+AT9tXPnHoho478kzvSS4d3ZzufqELnfi1dmuKs+e4LsgfpbLNyWlornJH0/u/W53pbihvGzjNlvoGZEMPEhyupTuba97eAAYxtyy75WpXLMtBgQzgaBaav61UpXCOJDTz2Kviwikk3P7dP7/XjdY6SIU7gs3Qy7FJ89hg+POH6tjDAWhDiapJOJi1k/6QErxbM76WUxRagFjjaUSjhHjSNRIiRbndL9PmzfcRCZWQQHruc67PUzvXYDGWxd6xvVJRWOag/DAwOXOHihm8jyzehHLK7RjDs6qR1JqqzeCTiyNzPqg49ACjBdWKHexqmn+uGxCzm+jcPH0fioGirMTRx6q+cSEOlB5JApM/4LxBqDXvgmmZfTAmqzozZ9b/yRktONIso3zX3cLq13indK4K6GTypNr/VwN+VRbwSCXOXRzhNWrOrkgVyH/KhwLkhnQIleS4ZL+OjIDmvoO368ljoYr92nIHmgThadWxe6kCW1BVMWlE5S7/IqtCrdT8/174CS2KhDR9qm8YYQ9pms1rMLQvE+VxrHUK3ex1PhXuqAOejsEyYDmJYHa3zqUlEI2Z/5emzrdQBeG9pupEzo789SXiqwwF4Tr+2sWe8io4V1I/zZwfY4ApPPgrXM3xmT3PGZu77UnvBBeeXnfokxQ7xWOfAlZpm6wn1Vi6to0M/Ju68RLW2P+lWU+IlMCPKrwJSQHVC8UNV10K4vMbR
 dK+uySxO
 OgLPo36qvP+JZS4qjMoRMCU7OM4tj11DD3h/PZqTnJj6SiBqta+IpskxBhlZFCkcAk+F47Lt0y/PEOBJK98RX8lbVkfMsHz6VPEniFFVTpYfVk4j4ANveA7YJ8xZv1oV7GnpxklZQpREcRnJtx+YYBgN6gGyGpO6J9QT/MIKENts8y/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>
This add KSM-related statistic counters description in cgroup-v2.rst,
including "ksm_rmap_items", "ksm_zero_pages", "ksm_merging_pages" and
"ksm_profit".

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a1e3d431974c..c8c4faa4e3fd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1776,6 +1776,23 @@ The following nested keys are defined.
 		up if hugetlb usage is accounted for in memory.current (i.e.
 		cgroup is mounted with the memory_hugetlb_accounting option).

+	  ksm_rmap_items
+		Number of ksm_rmap_item structures in use. The structure
+		ksm_rmap_item stores the reverse mapping information for virtual
+		addresses.  KSM will generate a ksm_rmap_item for each
+		ksm-scanned page of the process.
+
+	  ksm_zero_pages
+		Number of empty pages are merged with kernel zero pages by KSM,
+		which is only useful when /sys/kernel/mm/ksm/use_zero_pages.
+
+	  ksm_merging_pages
+		Number of pages of this process are involved in KSM merging
+		(not including ksm_zero_pages).
+
+	  ksm_profit
+		Amount of profitable memory that KSM brings (Saved bytes).
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.

-- 
2.25.1

