Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB56C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE356B00B2; Wed,  1 Jul 2026 02:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E9C6B00B4; Wed,  1 Jul 2026 02:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6DD6B00B5; Wed,  1 Jul 2026 02:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C65DE6B00B2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56AFDC15DB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:56 +0000 (UTC)
X-FDA: 84939187032.08.1AB6BE1
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB33A12000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z4H/80xX";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886314;
	b=Oe59f2UOJLef76fsyrqUC1HZuJzDFhXhPyQjSTkLmeY/M57Nj0+59fQXk++wsLc7mWtVJA
	uCxrHgWzJMqzcVEdtnqsxugRIKuxZBgnq2Onpe283NGHbMbMtmFCxJvnuEMVf26g20FjFT
	AJtL7p7jPtSiZrtm5iwBukyaXOF83ak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=OJadojX+7yjzCRz1acpB9F4q0Wad+tjjUDvG5KpcwE6/t3QT+QRytK66aen/qMOrrieCR5
	9xJz/+A7EYKOgtQ8p6HqNam6HfE7GVKgEHnvLWChe+64exdvr9jCDFO7MMeEGYVcqBfnvM
	eTBXaBbEGaHggoXsSBXn9eEbkBJnpO8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z4H/80xX";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=Z4H/80xXWQy56FJTP5kbbA4s1lU5ZH1vNNgTvKiNlhCbzF0p8sDAcTdcdRhfq0B6Rm+cUA
	QCL787QjTUFHcjte5KLUpysA4V4qJKwg8W5sWXlgsLE2XLGyn5AuMB9KDtS96imfGi5E6P
	D1plP1mXTPt+svIfZxM92+C5Dsc8YrA=
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
Subject: [PATCH v5 6/9] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Wed,  1 Jul 2026 14:10:49 +0800
Message-ID: <20260701061101.344679-7-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB33A12000A
X-Stat-Signature: bo7kccm3oafskri3bu5cpbznd5n6or98
X-HE-Tag: 1782886314-414363
X-HE-Meta: U2FsdGVkX1+XiN8jXLA7yArlbaz0G3s47n5Ue8PlLVTH40FnxmqMp/jsxsh0ug5510+YTJuYaMGcEHVlVF/I7hGAwTd7GZtFOBuA56I5+WN6SOvSUq1JHrN36XSLOC4jMN2TSnomTHvJf8S9qQUyY6LFVzdlOinJZpVPsuT3jg6f26J25F9CqT3asXY4ggvYD7Eo0rd6AdTvNdd1t6kOBX2FFs0bsivehgrADH6iG4KWEUT287HTxs4+NGMzGADqz2cVoKItKWEs++B4joWj9roYppjbv3Tz5mnZ8vCBv4JEyyk6AloiQqTWp2QE2WXnnP5Xb8/pwRP2SEmf8XbLswlILRYDNhi1LdXPbD1R1nKVNVomaskWUAEDtvKABYzgrY1IjjwdNg+7BdbLFciTBc9e5+IpD13UZbachshOCjtjFeE+Jnf5X67e9A6XydhBfT5eNrO0kQxhDevZlqf5pxZ2CxXi90q+CqW17hA3byf+BWVYW17DE0NpcB5VOrTPVe/K/Mld/Ut52666F9O2pjszIlUfKusSA0nRWjdSYLyTw4lwKukHY0vpzDh7bhPAw03cbKgcAEG4PKGkhOQBdmssjyrY8nodAxDw8IY7i2Nii/vV8rfORMslawlh4TInFXzseedHgLDaGt4Ufp0I6yKKTsw700/Em7PuW9y/zQ7MlRAcbl7mYEFkPrpOHXnTX9UXgGOsXeI8QIpuE6NybPxAkAc8zsAVuqYXn8EA+iPjNfhMacgsFjESWbzfXyXZ2hMYNz9+M5j29+JxcZWRBGmyJYfq0jw3UDLyWXb5/GK8SY/nF7qZVTxATuPIl2LGQB9pBOHKXAGhmxvdrWN4lW8dkoXetkQYJcLYRqwui6HWRIiQDUEG+QsTahnAtUfC2Y4MiPFhB0VcaoOw9wQflfkHlMtGT6yJeXAPI8in6jSqZUlYoRmKtOpQ4dVL/cr2BRv+6mpJ0RZeUXf+V+f
 3DOuW7WT
 a698imcdxG8ZKML0l8+JxjPDTvZbcFLnbj4I3m0G++BkV1gjL6/cNNtNDnSQsYW/5nrKozRgvayTZzB8qGuCULTeqQC3xpEMibo1pKOavLRloKmNBFy0gp3HcKuT0J1o647+Ic7Pll3yUh7vjIIxoWTdFaNPlWrNvd4t9n8iPqTJzgyU3L8Q3VYZc+2aysMZYfYnX9LcwoWF/Bidi9zhYKSQzzcO9l/wI09nGuopsRhHDNzq0MPUptxip3rXULH+wppm+X7cfnqsFU5KOFSNJ/qs/gv9hX++240rP27n3FjvEqDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The free_ts_nsec field is a free-event timestamp, but it was printed
in the allocation summary line alongside ts_nsec (allocation time).
Move it to the free section where it logically belongs, together with
free_pid and free_tgid.  This also makes __dump_page_owner() consistent
with print_page_owner(), which only prints ts_nsec in the allocation
summary.

The output now groups all free-related information (pid, tgid,
timestamp, stack trace) in one place.

No functional change except output formatting.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7520718f63f1..84eb44459478 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -653,10 +653,10 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -668,8 +668,9 @@ void __dump_page_owner(const struct page *page)
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
-- 
2.43.0


