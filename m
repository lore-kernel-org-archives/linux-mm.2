Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45575C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E796B00CA; Mon, 20 Jul 2026 15:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAAC6B00CC; Mon, 20 Jul 2026 15:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D70C6B00CD; Mon, 20 Jul 2026 15:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDC86B00CA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49271A068C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:54 +0000 (UTC)
X-FDA: 85010160228.18.6BCE1A3
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8325A140014
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aajWgICw;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
	b=oF8t3HZ6BJWfdeS/sBqLoJBwejaiysZEurbUdr+BBOstqEbz4GnYnfBmagB0D6euOFTBa5
	nxQf4aK73l0Nc4/S3Q6ZDmrb7b0bqROa7mL+nMxiz2KaJ7VjL4Mjrx9gfokPzMDCjqPchb
	uVh0H2VsaE9CVvjf286oPT7jqOKs8kM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aajWgICw;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576152;
	b=ODwlx6JCMRsjHvQHFC3Gt0t6cLayijkCYkGEwFncw6wQcTOd0+CjYzvLWTa6rOL2cAgFB6
	6wXol3+sKVRcTiBTMA58vvZdeGxvDDw/n+kHDTfqxA//pbxqqTW0YgO9+uEBKrEJUIzYdG
	gidMYjkQv9TwbAFKasIsWNRNIcLHQbs=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92ed3993c1eso439442585a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576151; x=1785180951; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=aajWgICwHMymDxI66SyWpsYQkMx26bhEHOzoCf1UT4VpU5WiBYFV890QMjk07QbALb
         oi0myrEjuHhSNcH9dGDbp+SW9oEwAFmXJq6ba+zLRQqqosTfAljBS94AF6DBRJ5w3A+b
         pr5FnKqf9BM8YdJbikDqY5c3R3kYjbyHrbBO4WACjQFd9B7TB6amVPDqsJ1Y5X/tFvB3
         zjxplVDMCHTlOS0I+e+sRz00ZcBlb/qKLnqJ3cKMeeAxvn+TK9KxIYmJ/cv2qkG5d7KZ
         xPFtJ7hnE1DcBGQaWIA4lNT3VadYv8dO8PT4gdViDRouWQyj8SKzLAzpMVu/Q/w7oklq
         oPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576151; x=1785180951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=DumlI0Y4rPQr89gVv46fQNUc1YNsM3BSFUFZR7fAvUkAbPZm6A9X+fYbgk4vgTdRft
         zeoFTgYSq4R4foNPd/nRiNywHahUDUBWwzvAT6yqropuEgUjscsUAHBnZY/iwDYvP86Z
         OCfKMf6TNQ+CvPY765fgmYhfyoOoXJSyXvJkoDE3DllY/g7fgOw+ew6TLVeXpjjwdKWP
         XmPGzS7OJ8U67CR4rWpP0X3h62JlkPiakeR73ZT1x8tBfga9z6R65rE6aecYNsOehtFh
         kuBFaSc9g/AAwAgTCpBMPtgqXmMq91jY7e0FWJN6oMETyaLcDDUjVVt2+d7Jak+mmNLg
         BJ4A==
X-Gm-Message-State: AOJu0YxPBadKU7iFfH5FQuMR0I6qZ8mgaPKRRQMDJfp+c3fbqQdGq4Pe
	BqX7/HK6lOugiWG1W+0+W9wbxPbaKh8eRvEtcyOP8Xhd0bJ8Frokcun8kHJf+IFwrTZhGodxXQh
	jt1Uj
X-Gm-Gg: AfdE7clLLdZIDj7OotXoeNr/OQA6p/EwSD0oH3JTEMfpbZDHLfP+oTXFGz21hq6tCdu
	pSfiNz8g+USDUqh2Ygp/If27MmnChqljDmxKS3rKJUSXeI/z4lXWTWec9zGGh5SOQL+AYqe+doV
	ZFMzgOL8cfLyn2DQGZaRdu8azSO/6HIcVRovj4IrA1qEsEYt8FTdDQfaxA+ZEEqQ2nsKGtoBJev
	w84DoUhcVmWoKneeL5gwdG3S+x9MnixNKrXEyy4WIJ2mO0qEdg4E1L8xPQCHV5ku8IyxBqTD8MC
	DgPE0XEpIo56iBql2Bomi2mpggoTE45KGGXn4wFW+CbDjLgXKvfRBBNys3a2XnKpAJEiS/JzbZN
	UBBvdA+RvEH19Fu4baVH0b8SeJKoLahWv1SRJrtXN0l+0CkSamLqcftD6s1Tar+gYl4lFi+tUrZ
	DTzX2CdyBvK5QOZq8kAduLb3U+l35j5EyVP+dkSOHaT3K/m2Q6hxDEZV9Rm5kz+U0=
X-Received: by 2002:a05:620a:370e:b0:930:9a84:d90b with SMTP id af79cd13be357-930b416db01mr1583254785a.50.1784576151483;
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
Date: Mon, 20 Jul 2026 15:34:22 -0400
Message-ID: <20260720193431.3841992-29-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8325A140014
X-Rspam-User: 
X-Stat-Signature: hqrkddwissw7u3fhe5phxm9tum8ym51w
X-HE-Tag: 1784576152-465278
X-HE-Meta: U2FsdGVkX1+Qi5a8k/RJSEF2VVn8k9QEx20HVH38wUdoUCWYjcC62CqGDyHTW91Uvg2FEwX8cjTToveRB2fpwwV1J6Dd4zLD2+/pOSYzzDT3MxEJZdhvcsqPfQjZUweTVRv4Xn99KTEW2a+BRPn0OxJfVQqxqAHvTkA1GlhIX0V71hNgyzAyKY3r0KYFM4yXvYfprSRI+9F6Av34W4lIP1+jofeRQZQD9e+H1+Zn8cQf8MGbTq9gZtgYsMxeMscsEeb+8KHlG5NhEEAwI7V+7BkiH2Eoi5GBBIQPnfPX/hHVXXiXXp9K4pze6Jc3cULoTiofHTxuYm9LMMDJcntRhlQykW/4I1n5Hq+EH8NvwTeaZZJLy1oMr67vMCpk/mZY8LOiYbuOseNCKiMkNn8QZKD6MyoHOmnXn9FAJQx0q+GaJeY0B2UgK2M7sl122zUZXUAE+8l22YgODsBrzHeNJh7xk4yT7ImCjenZBkKwfAJ7KjL65YZs02QPogedIc7zCT05gwxXRykxdgCSlmen3JZNvBIZND9fY0fM9k1naoUe8tXOI+o7obCU7XDOjLemcH2YbDjKUN42pEiWrTLozHbqBwSVGI7EXB65wH0L6wuHQRLmwqDLpLJByXdkJEmHK1uovnhYIzkeBngfDPvwIFXgdgY48mEeFR+k6oMG6xSqE9gftypL5IprtbqmvajVORiCKsCHq+qIc+D6GaMNqmc/F2iDOrvJXU7ha4rMwJ4tijShxZQe1skcKFdCIroXALunPIEQvpzwdT4zzdQtddhqv6OJaTKHzn9abZZVLWx2j8k9+TwIR0/Hxn7X4Sdze0fKPr9lY6kHrARPiDhdH9pwvLvI4qNjDCyD9MfsRHDdTIzO/rZv8kAk8201NCh6lfUAQoVQdA6dGslPHdh23daC1X0eg0A2UGviZAjc7LwYvlQ9BsIUhIGz/+hE3c3ePmS5/qiEU2XyLLSnDqP
 00xlwkJw
 vhJeiBzX1RjNRjawpYkEIwvGpK1xl1AH2+ArRI61TwHkG/gF1X/M73RR8BvMeXwo/UmzO1EAwJuw66i6l+3sO1hxP7XSkCyRTs8iNOWb2wwa8NFjglaDJEa2JuH87j4Fx0m9ucdml7WS38Cu3NCz1GxXAn5Fb07vg5fCwkOVxAQ6ddiJWII0Weq0eMbfNIw6zWVq2cfdWzSLH6RHtzg/zBKsLtusbUauAKQ2fkai4pmBbyyHr7nd9WhO3SfSHGG2Db0rZr2Kcup696ZJ/vv4nFAWjycLPRQXwZowU53Nfe4pNLkLkxun0HImTTeR/BYpLzeBI8QclunNZVZRi3/ebydpmb/5+w1oTAq45QBXQ7MBfbMKRPRUcwir0uKXf6ugXz2wHMO1B9pVwoKFaQ7hzjdMKwfgpKAMXJroYidNEAebtTWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
node's folios for the purpose of hotunplugging memory.

Without this, hotunplug fails if any folio on the node is allocated.

Add node_allows_hotunplug() - which returns true for any normal node
and private nodes with CAP_HOTUNPLUG.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c          |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 655fe9ec5cb61..7b617b1fa9c28 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -14,6 +14,7 @@ struct page;
  */
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
+#define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -97,6 +98,26 @@ static inline bool node_allows_user_numa(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_hotunplug - may hot-unplug migrate this node's folios?
+ * @nid: the node to test
+ *
+ * True for normal nodes and private nodes opted into CAP_HOTUNPLUG.
+ */
+static inline bool node_allows_hotunplug(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_HOTUNPLUG);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -124,6 +145,11 @@ static inline bool node_allows_user_numa(int nid)
 	return true;
 }
 
+static inline bool node_allows_hotunplug(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f42ed303366c..e9573f90e0dcd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1943,8 +1943,8 @@ static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
-		/* Private node folios cannot migrate, fail outright */
-		if (folio_is_private_node(folio)) {
+		/* Fail outright on private nodes w/o hotunplug support */
+		if (!node_allows_hotunplug(folio_nid(folio))) {
 			pr_info_ratelimited("memory offline refused: node %d pfn %lx\n",
 					    folio_nid(folio), pfn);
 			folio_put(folio);
-- 
2.53.0-Meta


