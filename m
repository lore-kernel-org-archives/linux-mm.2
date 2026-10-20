Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180CF606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KxchpydK
Received: by kanga.kvack.org (Postfix)
	id 2558E6B0518; Tue, 20 Oct 2026 12:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CFB6B051A; Tue, 20 Oct 2026 12:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A4C6B051B; Tue, 20 Oct 2026 12:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7B316B0518
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:11:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CB1C140243
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:11:21 +0000 (UTC)
X-FDA: 85343494362.17.B4C1BD0
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DE7640005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:11:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxchpydK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=huqzC5+NT3FshAWG+VCDlCjNdmPkTgAm4Cdkwvrtsao=;
	b=Rw6rG3HHcXrELC2YNKi4aSguQrYc+Ly2MytL+fK0oQjcQQrSoGY4I6CDq3XwVeJhc9Sxo3
	Qoercid788etfusIjXLdfUqWQ+UEUGC4dHXWJGZQ0MOszQ5Y/9ZQUuZbsO7MTyHWL7WT8V
	/x/EFT9HA7x0a93xdqF7V/Hu8xzMwIU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxchpydK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792512680;
	b=I5DARv6qSg+pkYcQ89ap6fWTAsSqAmxQbOx0yT7K2C80Uxs8O2hSxXIEWkhmV1NaBHzA91
	Y55s1EJ+b4axGt9DFpK7/JRmi6F04ULs31dMbml/zUZSSL9V1cMIt1Ul3BUV52bTHyPlvZ
	XBZSDyecp5wWlamtDQIikMwYwqHgUgg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5DMNnG7wdUv/ycP5u/+jKq6/Rsp8gxxgXmoGG4r9E2U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792512673; v=1; x=1793117473;
 b=KxchpydK44ePQ0NtdzuBPvgT78NaO8w+F/dELBS8s3G8mCSxvctbmlxBzIpnEUeO5ZDXdksN
 FCgPoXxOdTVjUFnKFHotD9i8vaomQAPUWnz1LSwnrQTXRTenmhf+QmnfULQ0UFLRJP7J61r+3GX
 zdMMssIE7aEDCSHe3dcLINgU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 99dbf0fb378e6f72;
	Tue, 20 Oct 2026 16:11:13 +0000
X-Mizu-Trace-ID: 99dbf0fb378e6f72
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] mm/page_alloc: clear page tag refs when onlining hotplugged memory
Date: Wed, 21 Oct 2026 00:10:53 +0800
Message-ID: <20261020161053.59879-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DE7640005
X-Stat-Signature: n3gcu8xrm9hur4b5hbbwh66ajd1qnehr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792512675-491779
X-HE-Meta: U2FsdGVkX1+MoPFRj3V7kyyueb3Yg/DDIqYrTJZC1Jw/zIM0mXuABA2vVdQ02aWgwlmehnfqhWD0seGJGffn0rHNTpwbZdvWoqOZhm3DVWpWNJG3kEZrIv0hCAgdTB4GDhpHQP5F0znYAVjlqXgEJVtqDZsr3kA/1LToLWKqleNwkDJtM/72FSrP9FW+L+yRue9ufegB6wXXsq72w2qmhe+TUrWCxMpVSkTG+wHoj11pqSz63sVQ5qn1Hcls15u2/gViRACAYPbBBkbs14uRzyId3bzf9LAofaaCfE9ljibyKjVPhzlzhP1gQPCxdlKMqWG6dl6grkPiBaXgGsjsE1T8XnArzg+editxA+HU9ShhTAAzkc/BhqSG8NX+ylcixcMm7TFV6GqMeSY05eYsblvcQWqD1xxXKv7R8MqwVXJx8bJ0DOB+CcFR0vTbmMz9l4BLvaQ3IQIUEu41nWrqoLjBKw0A2IqT4bkqEiV09uRccpD7h18VjxlOO+JM6oi8As+q7nIAM9oWrzsurejgC2OWW6cUSQoFXDZdxEsB7OzyD9VElLBMxGUpgF3h/dCAcYq4zyZpx1b1SkWse9m0QUagITQoZ30RPEAD32xE5OcR/o7vN+friuA0T/VokFkmtirFedJmx2mOb+sqHOaQjo3oGEpuaqLPIihgIByohufs0CxKzAEDLv0kI9yCmicqMhGYXM9egQ2UKWstopSaCjZs+qlQeiQ30ENfzTYRyY93DZ42Gxn8jK/6b1111rhB5Mz+SMeb4/k7f8vLAG3XVPgKk/8NNZtjDeP6jsodv5RX+DNi4ZrolTk5gfwCcEwzcvCDLZgQjOYclnG+tl82p/mzsLut/P+ZpAK4+iEGPPWbIUMuaoU5Pu0bj/SFNhiJjnTkHOl4Xftx1oBfAtXXwtR7wmy2BDaooyXd0hawjOH5dErxQxTg96bDFkKt8lZeMCCybQt9lzRg2SgNBnI
 UM7+Mxxi
 7AsIrhbOmTNlkDWmJEmwFuMOGWjcA0rQ37yiDnqowqrpT5tfPJOXijZB+3PNUN1yuMilGri4Kz3tE7BwRxCjKFios5OSOBFaovi1Z0l9d+tXfjn6j98PP5idgiTaJRNxnJMa1YQshPv3RDsoHSSRJcqotCLMAsAJbeon89KP96fCwUCfEOS6f+9ZvX//RCa+YtvhtHHsFxMyy0S/fdnBKAukQ9SAouADEvKdw+I6iRg3OXlH0ijCqL13UIlG+J3PwOF6JrtPMuFKiW6A/BIeedjnoBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
  Call trace:
   __pgalloc_tag_sub+0x1fc/0x254 (P)
   __free_pages_ok+0x14c/0x6ac
   __free_pages_core+0xa8/0x188
   generic_online_page+0x14/0x20
   online_pages+0x220/0x3b0
   memory_subsys_online+0xfc/0x198
   device_online+0x58/0xe0
   state_store+0xf0/0xf8

Onlined pages enter the buddy allocator without ever being allocated, so
their allocation tag references are NULL.  The free path expects a valid
tag or a CODETAG_EMPTY mark and warns otherwise.  Other paths feeding
never-allocated pages into the buddy (memblock_free_pages(),
init_cma_reserved_pageblock(), free_reserved_pages()) mark them with
clear_page_tag_ref() first; the hotplug onlining path was missed.

Mark the pages as not tagged in the MEMINIT_HOTPLUG branch of
__free_pages_core(), where PageOffline and the refcount are already
reset.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e71e514ea18d..9561f2cd873e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1604,6 +1604,7 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
 			set_page_count(p, 0);
+			clear_page_tag_ref(p);
 		}
 
 		adjust_managed_page_count(page, nr_pages);
-- 
2.56.0


