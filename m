Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D6CFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292A76B0093; Tue, 28 Apr 2026 03:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C676B0095; Tue, 28 Apr 2026 03:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097056B0096; Tue, 28 Apr 2026 03:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3ED36B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:11:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 937451C0627
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:32 +0000 (UTC)
X-FDA: 84707094024.30.F7ADFBF
Received: from mail-m82134.xmail.ntesmail.com (mail-m82134.xmail.ntesmail.com [156.224.82.134])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53435180004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.134 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNw6KKXkGAwy4ArXwv2aEqQp+dZ3QR8LJ81k4Kw8rIY=;
	b=WOhTOTBbGQ+MP1BrXllvJk/J5VXumQbD385jSiuaS/jvmScDkhe2UQTegJpUcPagoa8w+5
	ItR9OUhpBC4j5T69/lBRumehKXoNXg45O9sXTpMP6gNUeeQBhFTQOfY8bBEFuY2F+p1DNc
	QnqJUD5/nF2/F29i/X7PIyw+GntR/9w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.134 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360290; a=rsa-sha256;
	cv=none;
	b=SX1RF9CyID/P+lFYwHlRVe42pnSJdXTxcq71aIgJjjBruNNG4yob4aTNOmeUJ5E/xAKNsg
	ltlt7Sgf21bRLaSlxWktNyC2b+1oYFmb3rtTNHuTc79SKlOEI68q7lGxDrTLqnxSjEnTk7
	+JJb8lF1LOXpxJGmZYIiNGz/9vVDLQw=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 197b49302;
	Tue, 28 Apr 2026 15:11:26 +0800 (GMT+08:00)
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
Subject: [PATCH v3 2/4] mm/page_owner: add print_mode filter
Date: Tue, 28 Apr 2026 15:11:10 +0800
Message-Id: <20260428071112.1420380-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428071112.1420380-1-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd2edb2230229kunmb0c223f1156f19
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTkgdVhgYQkpNHxgeShhIH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53435180004
X-Stat-Signature: u1brmbqpk64hohij98domnxghbjwjcx1
X-HE-Tag: 1777360289-582301
X-HE-Meta: U2FsdGVkX1/4GNbuuCr535t8Z7/AS+cbXbX/7Id/GjrM2CFCTrutyGW7TNfRvSYBFAvfS+ep2yPXfNOv9QlQahi7gIoBAQ6+mS96yyoMElku5o9SuTtwXrxTHH3AIEFsZoFbKg+N8hYZfJQ711EMZYxD3r7SqI+g3IxvE4T5lbJy0gikbt9fnT+ydIx9jXNnrH6lj24eOIpOwHnVkA9BVzpd3wvaRDBCy+BOotP29ttq5Xd5zsTMtgFnoI2ZdaB6bmBUtBzqiYwlVK05BIUvl3S0hVWm3if2csCISEeK8YVXE5L88FW5Alh+F70XnKiQNY7lSh0nDuGfxxUogGnUiHj5n+FzhHRHcah53JxdzCDnr81/iNKqO08z8UHsgykd2b/0xm4AjgGOPQWvGpI2Q2r6pYhoHPYdfLGZGlZlb2jVcUVJYRetaIy3BkOw23Cf3SlBiHizkcEFykfQLEeYbm7agO3WCgz1Q6j7zigDmJJtNPb5USuBh7MSXth+JdAeo+ZCg3IxNXJI6o7g7iP1IEjsaGeISy2omAkWqr79tbdXdIRwlfnU80IAku8+XK1FfbtGt4xADgYZ9OUcd5AHsgrdRvQbscnaOe50DFyUat3I57d3R5veHn2FwXweQfbcF7X+BOt43me9JJZXyrxtbvd0QLGviJnEUGiCDZ2OdaB5QKZC/GouPL1J2hUqKMPG+fRQHkcOxpR+ThNXPHKFRkl1kp+rx0A2bz034GYHEpe9gMbb5MIQNfxp2eCnHxUc8trrsrBs3fvFVtq5WsWSl86LQ/1Hcnsw2IET53mAk94AVuwOfrNoMEMoTt4UUUKPX7TiQkOOKdMlWUbKAVY/rZnKbOswd0LBw++zr/WJJUoFA0N8V2HW7hPkWuN/ESixJsSJqgseenx2NDdD5vD9Hrxr8VGisR5fpIDS6wu4SBdvijTkaR2wuo2lWkhoVSXYFa3iq3e/YApZibPqOMm
 CUyDl8pV
 Qu8ejozIl5wefXBNEl6rvS6S2SXWeWQCmH14Kn6UCs6AQ6sJM/jZWXKgM5HzH779Rhr/qe7CvN7v2WyxBhfiZBGbgpZ8YYEirnTbvSVZQx2bsSXJOAX0aRufYGQ5xHjoIvvnRc32pwMkraH94gr+actFxUspEmjqvSJIGv++as57/lKOhbIK/auY1ewqbA87Stf/s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add print_mode functionality to reduce page_owner output size by
printing only the stack handle instead of the full stack trace.

Example output with print_mode enabled:
  Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
  pid 1, tgid 1 (systemd), ts 349667370 ns
  PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
  Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
lastcpupid=0x1ffff)
  handle: 17432583
  Charged to memcg /

Print mode significantly reduces output size while preserving all
other page allocation information. The correspondence between handles
and stack traces can be obtained through the show_stacks_handles interface.

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v2:
- Renamed from 'compact mode' to 'print_mode' for better clarity
- Use enum values (0=full_stack, 1=stack_handle) instead of boolean
- Update debugfs filename from 'compact' to 'print_mode'

Changes in v3:
- No code changes
---
 mm/page_owner.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5884d883837e..6d87b6948cfa 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	/* Print mode: full stack or stack handle */
+	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	} else {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	}
 	if (ret >= count)
 		goto err;
 
@@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static int page_owner_print_mode_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(owner_filter.print_mode);
+	return 0;
+}
+
+static int page_owner_print_mode_set(void *data, u64 val)
+{
+	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
+		return -EINVAL;
+	WRITE_ONCE(owner_filter.print_mode, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
+			&page_owner_print_mode_get,
+			&page_owner_print_mode_set, "%lld");
+
 
 static int __init pageowner_init(void)
 {
@@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
+			    &page_owner_print_mode_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


