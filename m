Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC24EF436B7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43B26B0123; Fri, 17 Apr 2026 11:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BBF6B0125; Fri, 17 Apr 2026 11:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE35C6B0126; Fri, 17 Apr 2026 11:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC496B0123
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:47:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CB1C1B7299
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:47:00 +0000 (UTC)
X-FDA: 84668476200.02.D5EB83D
Received: from mail-m82140.xmail.ntesmail.com (mail-m82140.xmail.ntesmail.com [156.224.82.140])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FC9E140010
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.140 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776440818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLKBtpIC4AJoiJzUmKKpOwcAvpnZwlCkIwAO5OA981A=;
	b=zEkR7n6NbG1uXTX24beLC/SWJADW/hfsr1JE6aOpxV1uUzouABYX5B+GQVE6qe+XLdT4d/
	UA4lMoB+9Aj39ALz5Im7zOGwTH4uSPsHWxeNo2rbTUSWK9k0HtiHOkpwcSsNJJC6pNeoL4
	vaUvYRxIzP+pPxuizrU7qVcDe9BHobg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776440818; a=rsa-sha256;
	cv=none;
	b=fMUaG+W+R3UQO05SeyTIP2iWFJgRJ04abiFo8a9NxbEEIVfcpuVFJlYhkNSRah/XENF6P4
	8aKAdUvXgSjZYG0AxChjKVLOgRlnmrCwIvN4f2AQlyXVepIeiPa0ccCtOUpLLRuWuDbL39
	b/tI1NlLpg5AAT1RXZ/76Jle5lZHf3U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.140 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 190e229f9;
	Fri, 17 Apr 2026 23:46:52 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 2/3] mm/page_owner: add compact mode filter
Date: Fri, 17 Apr 2026 23:46:37 +0800
Message-Id: <20260417154638.22370-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260417154638.22370-1-zhen.ni@easystack.cn>
References: <20260417154638.22370-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d9c1fa39c0229kunm7c3615e318e5a6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSB4ZVksZSk5KTB9KTB8eH1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Stat-Signature: 97mouqg78t1e7y7tdi473f5ye1pqun8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FC9E140010
X-Rspamd-Server: rspam05
X-HE-Tag: 1776440817-487658
X-HE-Meta: U2FsdGVkX1+NOMUYQbDxoAwTK2uPRg89n39tRXErLyrAxHfsZsybNMm0tXxZ7jKyDh3JxB4fIz1La+KtyV/11a4k1R/xSoWeaGCK6NF4OfAVo92wAw8Rb6Ruk+fqPYiqCW7C6VJyov1tEjxHTg4ctGmNV5AqDQhUbW6uwpTOTxCIatTOX6X8D0EqYoQgcD1lypUzmS07hc+azse7Lc9KXRL/DT1f7ZPuf/dxFIp2Pvx+NFip+K6f0CVf7gEBfLgrbkIHiP0Nhwu7NgdW79+3JGFCNH6VLaI4ZEdutc/LmudIbSCCxLEFG4+8OPjjHHs/0CTSol8rdIL5xhzgGVH45ltL37IHykW51nfPH/Q8I02B28WANt7QdqPnHV6m4GV54MP8VaYY8sq4hJTWLeqULwsTr9HWvlBA9IVI5z1lAHvYCLSoZ5EUE6oBfBZTKrkibqtn10uSZ+k2K9l0Xw656mSC7Mf9gXETH7/U0gBtdzfOY28nbpFyBPxHvQvCVENV+L+zRMvnM6RslykJ1HrSzll32MB34jQsP4WbonUT6FoQvMyo4d9cktxtHX7x4L6JzLXbfbxhdFuvugkqgOSSEKcIi91qcCzSeYoHK+EYxsNTiKmQ0cNKGxDOxj853P97KVQmSNnYpPxxKWn8eqtHqpr7bM5DeUMfTZVTEvETNn+0DFMb5MiGHWHJM5faZC2Tn0tq3mlserZL9S0dXzBvU+B8nZW7WOWA9vtb1sx0FlXRKhIAa2r6pF6UY50pJ9a0lHf/BHCCsGKUo8w3G2v6ObXcclTaGPim/C2I+D6WFnyLD0Bphx8y/BKSPoT4cXTo65+iMH0UH8r/gBeCNgKIiE3l4FR+/BeJwvYrUZAf7ciHR/aDuLSPUodHJuyY9oOmufuewMCQIGSu4wbUZA2VMtRwcdV4v6Q/QNn2pVARWUXLJVsc2LPk37RRzSYuF5x0DJ1csXBCm4e1rp0cWuk
 9nSTpH9y
 UTcZBj6ON45KICpmi+2MSpdMwcfLFSmEG7rv98GoqEt8pOa3h3AFh41qT8xRU7ln/4zfuJ+akVzBogb+0dJCzwUJVkJdvNsJCmQdc+lj++IUxUDLBEFAwJJWc/AUf/lq61c5FG0LgOfzB9KzOQZ+on/Jc/thp02CL9zSOH1hLlvOocqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add compact mode functionality to reduce page_owner output size by
printing only the stack handle instead of the full stack trace.

Example output:
  Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
  pid 1, tgid 1 (systemd), ts 349667370 ns
  PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
  Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
lastcpupid=0x1ffff)
  handle: 17432583
  Charged to memcg /

Compact mode significantly reduces output size while preserving all
other page allocation information, making it easier to analyze large
volumes of page owner data.The correspondence between handles and stack
traces can be obtained through the show_stacks_handles interface.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 6811439bf9e4..214b58eef3d8 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -585,7 +585,14 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	/* Compact mode: print handle instead of full stack trace */
+	if (READ_ONCE(owner_filter.compact)) {
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	} else {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	}
+
 	if (ret >= count)
 		goto err;
 
@@ -980,6 +987,24 @@ static int page_owner_threshold_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static int page_owner_compact_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(owner_filter.compact);
+	return 0;
+}
+
+static int page_owner_compact_set(void *data, u64 val)
+{
+	if (val != 0 && val != 1)
+		return -EINVAL;
+	WRITE_ONCE(owner_filter.compact, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_compact_fops,
+			&page_owner_compact_get,
+			&page_owner_compact_set, "%lld");
+
 
 static int __init pageowner_init(void)
 {
@@ -993,6 +1018,8 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("compact", 0600, filter_dir, NULL,
+			    &page_owner_compact_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


