Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403D8C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288026B00A1; Wed,  5 Aug 2026 21:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8DE6B00A2; Wed,  5 Aug 2026 21:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03AFD6B00A3; Wed,  5 Aug 2026 21:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94B916B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88553C0626
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:01 +0000 (UTC)
X-FDA: 85069068042.05.0D9E665
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id D7DEF18000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qQkgBzaZ;
	spf=pass (imf24.hostedemail.com: domain of 3Xt9zagcKCEcs7n1lj1pxxpun.lxvurw36-vvt4jlt.x0p@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Xt9zagcKCEcs7n1lj1pxxpun.lxvurw36-vvt4jlt.x0p@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76HG6LbYfiqFkSfWGWloaRFtKjCX3Ei98IA8lOxBOao=;
	b=fXsVitdpFdaEumnGc3hw6yxRhqMBjONQND9M27aiNoCrAPlDOtrTHgOwrJv5n6GVeHjcB3
	dqRl8oVGpTgk21BYVLD6TZPIpC4qcS4fqDMjbIrbj69YbRH/nxOY4d0FZ91cUNIDYv2BYl
	8WUHeoclPdjhcAsxocs3rPm/HOegj/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978719;
	b=bmC/+1qW/kboYAU/cVAUHF8Bbz7zB4sB0vSPI3I+UV6LR/tE0pANKKhREfuy+oZ97XJUgo
	ZmHMKE6GxCQxG9n6M5B+DNkfC6lShkrvkONt95l10E6i7cY500ctzG6eaFbmqJ9EbgCT0Z
	bjyB52T0IzIZWpRV8Ni8yhmFL4zrqgg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qQkgBzaZ;
	spf=pass (imf24.hostedemail.com: domain of 3Xt9zagcKCEcs7n1lj1pxxpun.lxvurw36-vvt4jlt.x0p@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Xt9zagcKCEcs7n1lj1pxxpun.lxvurw36-vvt4jlt.x0p@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso2078212a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978719; x=1786583519; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=76HG6LbYfiqFkSfWGWloaRFtKjCX3Ei98IA8lOxBOao=;
        b=qQkgBzaZTD64lrD9YJqgMxsYh+eMfFvtPmdZDz4f427laDC6G58f1ftuiwmSSx8GFn
         ccCl77mbtQ69yq5FYwFArIEv8FT5YAGo/j+52mUR3vNUnBDZb1uhdjvTknJ/d362GWkQ
         McXEjaMISyehgCh4iVBiDlg1xv63Zty3vbe44SoMxbsq0wXcXb8eEI0fHLjhTs9+TKbi
         KDKigNTCgAWJlXpi3yeGxiMWo2cnWZHeEnteOymp5V5RjLg0VBybDqHngKvRSqjd0T5I
         tGSNl6sYbh0V0YmoBcyAsEzkMx/VbHud0mx/ojvwxVyXEK3Cmymew5ArdIjliSYYIBA9
         A0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978719; x=1786583519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=76HG6LbYfiqFkSfWGWloaRFtKjCX3Ei98IA8lOxBOao=;
        b=o3OMV2sxQo8KY8T7w8AePdyOi0uWYIOgN1U93AQZ2JlH/MdBHY4DtqRF8QFs/1brVn
         A5ypNYQrZvwgRkxH8VZbrOn/xve6jo0Tmv9mB1rlFF6CfiwugnZqbMVWfLZ6pAksqISU
         svEoS+Wu4MW1a7roU30d4KJMI48yWMnPnlwf5+PxgrN3N5qgUc81O33V94KzkDTO/UEH
         bjgi/Xzz6y2n9elL2Zy8bkF1h+k88D6EzTXNAMRXbPlRDTy9/mIeRk45XUJGMFri25rV
         jo+P9NtSfbfju7vxz1tTm8dTC9OXOZ3RVXtnUVmY5XY3NdIMAjFb2UA8n5/CU47vW1aN
         BJIQ==
X-Forwarded-Encrypted: i=1; AHgh+RplxvvFdoxII1o7gz8AmEl0GVjoJUGikQZTjVJW90tLZ7otKHenOkXCdLSK6TIv21ru+pUyH9k61Q==@kvack.org
X-Gm-Message-State: AOJu0YxRItDVePNPVqNFrgjcVAOfVS8QIFatvKajAq9X+jSxElkPkT8R
	ilLi5YODupMRnKEs8Re3dXU5gxtQ5bnVH+rKnr4Hbdalp5DocTBcOSLEwUQQYW6P3OzREkYHOqB
	iJXXtG2w2Ag==
X-Received: from dltt12.prod.google.com ([2002:a05:701a:c96c:b0:13b:92c7:dcf7])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f9a:b0:3c3:875d:c538
 with SMTP id adf61e73a8af0-3cb85dbce51mr12099734637.8.1785978718458; Wed, 05
 Aug 2026 18:11:58 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:05 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-5-jyescas@google.com>
Subject: [RFC PATCH v2 04/16] mm: Define function to create a dir for each
 online node
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7DEF18000C
X-Stat-Signature: td6hiuxrkfa94c6equmcypgurs9uahhi
X-Rspam-User: 
X-HE-Tag: 1785978719-720630
X-HE-Meta: U2FsdGVkX19N8lIClDN0/4leeO0i9+FZZrUAEFP3+F0HEIqTBk558QqTkEZzSBaZcpUR2b9E8+HL291mJJraOYf81hhHXO/M4U5IdGKykq+Z/7XVLGR1ZcY7CPE9i0bBV1WpQATFlZ++bC03H54+XQK8GenZ/oeIqzrENoO1tEhPUBEY+5m0TouxebkOarv8NyiD5DZWa+npb1+vkhjSavBOC+7Sws+rraJEWzitTbXFuaN1i3a8fBt7sGOAPzaky8mp+w+FzPnFUAWOQdSCsy6W5o+yrx4fofcVUotvJc/y1tS9DiLJvwlqliCoswMx9UeQaDaQGugCc9m3+s7VuBtUQXV0sXY4qCOXjWPLFJgRJhBs56kCNXmcNSwk5lQQRYshsmnsY2WpA50/NNHkIoQkOSk0AzL6dWioCm5ovEZbwrluNdXHrc7yagaytD1cDUk5JiHPkGb3Iz5rseFRS6T7tzU/RZoPJ4gjVl+QimVNEbGdCKRkR0PBztiCjpFNuj2krHFkwFW/lsDGs60kjTdZlH1vb2042rEA3WDLNEV6Z/BXNryZpMgcE4JdCCe3tMoHirPp99WEyjF6dUQIAoeQNgbns1KE0dHOFkqI3Rfu747VYs67ZJrU+IM1eiMwwhNPiVQ8WzM18iQn4JLoo+fuDEfW00wa7uuhni9bKPAHdUezdHJqtv21RcU6Ijkg12PQdnh0UPNm/79otTD35Xy4uRNte21tnoJQWRj9+7V48D+gG/Q2zoO4yYOTC1lpTFZukV/KTZVFh157JF5Z6uUjMzw+Yp0983z++HrgSpaKuDJFSMy38or3WxBd1VFDrbfRaxMZqVisN15ScuSfq9+qY2YHtm4xb/pNYGkUsIcm6tABDD1ufBXNE9CPfbmmTSGQ480OXyK3qcqP7wyYkKLZptc16GHByyQjk8qcozJZj9xY/RMX0MWLeGVKUdGMrQrJZkKtgBXFo5a0MP5
 +ipyAXXz
 Vu7s1ubQqANrk+9oQpnCYMBbbCSGdEbpjx4PtuUbwRU5La+LxtOhZjyMytFwdqzIViJlVTNVFCdExkMyIhFgTBNc5oZgmSNTvdEdUFhlxWZQZJo0lgaGqXkeNoVDUz9HiT/o6vFscLCvxVhkl2uvhcKeQZPbEoWQEKan5OK7bhaSpk+zRSvXL7gZmkc1mConOPx1BTzJE5IwBY2ZOVEQkxJWF6bg1QogYzgTsE35mc7ClzbdAY/p8wAWfaL8WnbJiXwoPgYv9toxPaYAHlqQvuLtbsVcwbrBxS6NRHLyGQOujhAzIN450paBfbHHbVXyTP7wrnOOwO1q2QoBYN3scD5ec24XFoaZQQ4bFvipe6qcx1dygKHChmhecdQ+QYGJErbZjriny6mz3QDCZUiznvsAW3DK25JYUYgCfcprfHel8xfPS0TFmGuzRfQv4mVOpg/7RuQDAscx8GRbrCq3Zo/gVR+/KUqcPJU40Wh58QW7ZngTzkSfzGT+PLNlaLTrcFOaXuTYJWOEHst2pspNQfBIepbmbvPz3CoQ8gaeCx5Hh4OUReeDd7FPSYuCNAGEVCxTVgWKOx2zqDPU6T3nyrWWbbgDWBoED0jIK70s153o0jqkU1TfUy4FDQGwXeKm0YTs7XrRz+bhumNzAcqnEf4XbzDrnFDE+fRpA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each online node
in the system.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Fix comments.
	- Use for_each_node_state(nid, N_MEMORY) instead.

 mm/page_alloc_hogger.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 175f479c487b..5765ecc43567 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -89,6 +89,7 @@
 #include <linux/gfp_types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/nodemask.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
 
@@ -125,6 +126,26 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_nodes_subdirs() - Creates a directory for each node that contains
+ * memory.
+ */
+static inline int create_nodes_subdirs(struct dentry *mmdir)
+{
+	struct dentry *nodedir;
+	int nid;
+	char dirname[12];
+
+	for_each_node_state(nid, N_MEMORY) {
+		snprintf(dirname, sizeof(dirname), "node-%d", nid);
+		nodedir = debugfs_create_dir(dirname, mmdir);
+		if (IS_ERR(nodedir))
+			return PTR_ERR(nodedir);
+	}
+
+	return 0;
+}
+
 static int __init page_alloc_hogger_debugfs_init(void)
 {
 	int ret;
@@ -154,8 +175,15 @@ static int __init page_alloc_hogger_debugfs_init(void)
 		goto clean_page_alloc_cache;
 	}
 
+	ret = create_nodes_subdirs(mmdir);
+	if (ret)
+		goto clean_dir;
+
 	return 0;
 
+clean_dir:
+	debugfs_remove_recursive(mmdir);
+
 clean_page_alloc_cache:
 	kmem_cache_destroy(page_alloc_cache);
 
-- 
2.55.0.629.g250fe7f194-goog


