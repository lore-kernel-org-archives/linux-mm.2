Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A8EC98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A486B0088; Thu, 24 Sep 2026 15:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B396B008A; Thu, 24 Sep 2026 15:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40C36B008C; Thu, 24 Sep 2026 15:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B18616B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28D8C1A03F5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:15 +0000 (UTC)
X-FDA: 85249598910.16.EF1EF4D
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id D506F2000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cv37usSj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jsWl44I1dmzcvpx2K9acVp0XZIbfEoMe87Zw7D+9n9s=;
	b=VONGhFj0egIoSwvx2F5dxAAdGJKRQfGOjAhwyJgOCONzDDB7nN7GbxH+JTM4QRvExmzvea
	xntdtNF5VwSKHx73IbD2Tqz0edUwz/i0j+m2dyDOuWvi1ai+Vh0OSKjETESt3g/4IKJ7lz
	k6MhexeRQAVTRhXt/t7laG07tXBkvXY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cv37usSj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277073;
	b=5Cl3WepYtme6mfeyRKuatEdtt+gfi/84fI0TS14YnnTXwaqxo36+sUmZBSUuQs++r+tKM6
	Z1lBR/Wkxxd6daVkwWXwrbotWHGKT7z0l1dDla9z+G+zQxjoO/Zo3b2fOWoftRedp8Baal
	dQKdrm/iKX0mBdcmdIWgSq2q5GldHAw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aokq8/mgd5M7W02EfB3QkSeXjSOcvcPW/ytOsAssmRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790277070; v=1; x=1790881870;
 b=cv37usSjtQSsfCxoHjYH3pYe5JoWEB4Ku/EIhV7gbRNE2CpMd7YEITDzrLVD/gDnTJ05kwkn
 H/Rcgcz59N9opFoVJGm7XCJOxSzguO0q8bzDb/rS9GtU2rFKvgyMJLRS3Y+llnyPEJnPLXDh+Rq
 MyV8Fcrv9x32AsOvj/eKob1o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 45bc5b5e94a1dbe1;
	Thu, 24 Sep 2026 19:11:10 +0000
X-Mizu-Trace-ID: 45bc5b5e94a1dbe1
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	david@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	weixugc@google.com,
	yuanchu@google.com,
	hannes@cmpxchg.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm: remove the unused zone->unaccepted_cleanup
Date: Thu, 24 Sep 2026 12:11:03 -0700
Message-ID: <20260924191103.3475117-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D506F2000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ujzdzjuybsss73ta73dhxkb4wbfkch1a
X-HE-Tag: 1790277071-493265
X-HE-Meta: U2FsdGVkX19OiWj/YgVzUcUtucZ4DrHmhGjbLH0uqdbWRBvzHBqT3mX5LPIbq22bWInDmBb4yl3ZAHCtVsl96ym2YuMiZKNCnD5N0sm7kb2mYtAUwXcySepqQnGXYukil1vT3Dkk9PsQGHEDD5NDUpc4OfIyF7Is4voaOpfBoe2DVPKp3rgMsbqeLuMAEpw/DQFsaeevuuOv9Stp8jxB9vgX6Z8nA/dVY2pd+y+KtIRg+7MvhJI77/HZHYzXRyJROxt9oqoKhrykCr2E7s0tIVIGmNuHbZPJiqiTJ1DKPZB1eZyveR8BOC7Qy1sxEfgFVWd+3tJ8p3lzaLULcIAvlTkHkXnejbHovQw+QTr7QPezDxE+22HVRoBlUdfp9fTADYi1xd4xwaAQ+/WczhvkIptPkUUoxPUUUBRQnsKJJJHRKznC4MGT46u8zWYqhtj67zbRfGfVjNOvIboR3uvSXXJ4o7OfJkk58i6sliaLaolwxBHZPWHVejPRnKB4C/wmzz8V5TQk+cqjjUhjcRMruypq93UorBDal947pOJf2lTRLf7aNrOeqiknDqxAXMCdpyGKlWIAdkrODVzdg/fng3qC2S6fasCpUr7Sybi9lmYzmbsOGKpZXmfuWkPNowZ1ZS0PVDD1zMsp/nK1hCJ9Pz6uOj1YK3wkrI/rFfFlAGUDsuKWKiI22WhZH9jSl6L6IvIl1DRuuGgGEA3kGZnpNPz2Gh2ZxH/2P/XYPWM7Boc+P7uJyVLa5M+xXnzKd184KF+5t0XsttlRDsdvdK+I8AOnr2dVIUgEJ67XYKqusq7HvNasA8rFNWNNIpcPGnhQfM3G8J1usp4NTGvll86x7czxtx+G0q87rkyxj6sLJYl/qJ3sifROWOGIf2Z9BR7CiMGjp3Gd4WJzRzKfRh3QObLqQb8H5LF0a5Fa/PsK1a6xeR7xX5n1nlrprR0Z92hPtKkXL/M/bsvui0JOS+8
 y8t4LygD
 G5+Dpz5Z+7maJAqI0Nr6KeEbgG5X9bGbILa98EiA6ScGHEXE7uwFPn7DWHHj71EHOpWtb+s8vTI8ODFQ7D3MSV5wFHQDqz3+Cgtui/viDKx9OKeRagLKU4EIXRNodME4hmfJRMu3y7PM8uXLUqpZT5LM21T7gWO7WbRElwoKqPSvL/deYTkSTY7tPopVPDTlN1mm1xzu2yyxXywC8tpkQTZPd6V0WM0qlAsm8VSgkutm8EdBlSZ0pX5gFwHfCJX98tFuZuxViWwf9RLtoqZsxV09U5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
memory handling") removed the zones_with_unaccepted_pages static key and
the work that decremented it, but left the work_struct behind in struct
zone. Nothing uses it anymore, so let's remove it.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 65e2e0249b04f..e9d3845d10554 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1100,9 +1100,6 @@ struct zone {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
 	struct list_head	unaccepted_pages;
-
-	/* To be called once the last page in the zone is accepted */
-	struct work_struct	unaccepted_cleanup;
 #endif
 
 	/* zone flags, see below */
-- 
2.53.0-Meta


