Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE23C79FB8
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA976B0099; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42746B009D; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB6D6B0099; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858F86B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C79494010B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:08:57 +0000 (UTC)
X-FDA: 85193497914.24.1C53D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C57FA1C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:08:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxMdyjOD;
	spf=pass (imf21.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788941335;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PImYBE3rQ98v9zt2QBZLZLPhZGLOhfwMmdArgUH/Lxo=;
	b=AntEU/GSZo4VznEZDf0Y9VNpHmX3pk4d8lApy6FaLAbq5eApWSfgui4CKM6QfiGaLoNNDE
	NTkf+UVM5XasV4+fw/ZmPp/GQM6BUJ17HAQtIGQl0h2ZsjTxUnmyd7n7rGXfu3VwFFCg3q
	e5YJAT+AFR73D8c+4XsQL39f5sG69oY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788941335;
	b=6utup/RF/8MPQYw2incwnxnppG5CBZQCdy6HeXFv91gUc4UXYHO8u9tX5Mi22onZvebx08
	9G5PU+x8c9NfSEXdqgzOklKt1mxWyZ2/daa4mvX/A4PUlF21oEiazN+o+tzs+XRHC5hv2Q
	7Tri7zrG9JwJ1ftCoX+b87P/1lbv9Z4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxMdyjOD;
	spf=pass (imf21.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 594C844795;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D460C2BCFB;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788941334;
	bh=bGStaMYU8yIvPfBkyTgjETA7IHiwhxaw5cb0hq+LHYU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IxMdyjODlodjPzETN0ZlTlWGQwo1BDrgoaRYlv+FQ6s3kEotmNPwNfdrAryO9JNFd
	 PmF3eUBC8xARPcWNJDdAK2WkIWwHzpHNjHMoCxIOrzwftFYbl0cBEdb/KhzeJgJRWB
	 YdWJjnmvsnMnbBhfYkWGO6eZPCi2GOQQA+2tp+bL4ptYoPHhDxCDuPzYE52re2tRPm
	 kGy2mFaZz6fvEoxKw5BtwZOQfReE/pDGCtNmrhciwJUGkY1hRfeNosMb1JxLEOZ4zz
	 no0sbkZF2Bh49F53Vb8ilWVud1xJM/L4xqR+TAsiIV8WruXvRLeos0QSsgUfNZbBla
	 XUdySNqJ60IXg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A84DC79FB8;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Wed, 09 Sep 2026 16:08:53 +0800
Subject: [PATCH 3/3] mm: page_counter: drop protection fields from struct
 page_counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-descriptive-name-v1-3-1828961cb01a@tencent.com>
References: <20260909-descriptive-name-v1-0-1828961cb01a@tencent.com>
In-Reply-To: <20260909-descriptive-name-v1-0-1828961cb01a@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Jingxiang Zeng <jingxiangzeng.cas@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linuszeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788941332; l=1787;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=shz9WUAjddH3Alsemp6w1PbzeLYHyRzk5zeGNg7NEjM=;
 b=2xbTnqKMfvIkkyGThb5sZPBIowVjmF2rt6clRF6E2moyVUbPwRWuAbXWnddNr77RCDf9wUlxB
 Bi7dxyJ1ndxAb4B78hc5cPxuy0anDb/3ZihIS8QvYsge+PRe+X+8kCI
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Stat-Signature: c1qb89tqtpxpsy35p4fgypmgs818mffc
X-Rspam-User: 
X-Rspamd-Queue-Id: C57FA1C0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788941335-749047
X-HE-Meta: U2FsdGVkX18KFKLhaAv6Y9d/FjTicIi8qsQ9FVmFB3p+hsDyD4QbHf1NqgTjYfH8DrxThYvdyaMXEBhft4GEumBaYoaKtWzLytT3zxhGltG2p/kUlnJS36/Wej2Gd0j06qWP0aquKb97PeK0/faG1AG5wWlosiK4kp5St04TOIwNv56uqEbui+mbMFwStYwTdUvWfsWoM8QM07XP99qrg45ao5IVKDMXu9t/+qUlrU6ni+P6P67ogfL9h1bNVkqm95TgPxJZPn41AwMHsmtcVs+HolI5NPDrJrQD65m3Ms0vj7wvFx10eGXBm7SPAaxoQX/qbVayMKEhgsRKu5bFP1dFLHVJW/W0M4JQNMrOT++uwrbtlpFPuY/8F15xUAxqs3zVUsv3bENYcNgXXXQmnCdF7t4T7D8TQmscmFMu4L+lTkxZ/jgB3unOPK2qdUHkoJFZAsXfZWDlejE9OuwVq2eeTeVtMGFQGmwphcsEMQkM8yOYod3PORzPTu5psij9Hbgr8D4xA/LVnkvdXCFLxGXwDQQuNWZOSioj88ekmwBFV746qOm+zv3MPkNue50qTHIf9EJG2NYDM/+QohCyMGTqbuZj2VFOAbGvzm5wY0T+Bd34O+aMAQOY5O0tUCBlM/HpzA7/Zr53+jdiaTeWc4H2Tb9/2WbzOlo1AoBXNCC2O2bHhPt9vtnvIpk6T+5/nt6HE3jvWZe3z8Xw8gxdiWzNkeuQyXHwNFW8mQAwR3XCjI0iNUt9rypJwHyZ6APeyf+r8hMU++BHO8Jgp7aA6+2wKXw3E/TqlnNhzcltDlvwXF2K5CEw67U1Bgr2lFnTmEdy126nibM43OqaJId7TNmRdBK1Wdy4uct+4NbV7ncDlH6ZkFobSIjMa4oHAEzQpCygc8WDAK0Jv3hfno22gRcesuJyeaB0RUYg+H3vtdSm0p74fzaA+D8Di2Bert/XLHQ4H9ebtpTCno4cIr9
 ndZ/Gden
 zyA5PsoRQXW+QSt4qW9wdbnFSZJaDT3gb5GT0W4Q5raNRw0D9HV8R/Emw9jYAKsXnhm5obJbh5O/lUI7CCpR72ll6V+mAV+G0WR77m3wlAZ++dgTubxCvXDTlg02N88FJd/mlGLTECMU08duevl4hixYu+lb3QsEvFWEep6TpIohNmqzD62VRLWpPkUQH9PW8/syMav7DgyxJagmFwa5EkxabrdsJHLEGstpsh0frZ2/72Ft/z3souXV6V0zjWhpNycaS/qb8u61oWxYu3MfW3cUk8XJgvmu5CAwvbVlDBZZt1IrYo688/nj6AWZhSmTEZaSmQh0fiaPCqZt9TQR/9J41VwVeHWOjlJStG3qk5bSBvPGo8oka2wfgy6a+TLONLsoJ8SpHdbzab0pBer8cowaOi/HDKaUAM3VSgCjUWhgizsV2V31RjNzZdm+NG6wRbrVsTPaKjnAq4VMiJMDEkIP79MUyWSZNEvrv16ass1ndaULSrzZOCuOSPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: linuszeng <linuszeng@tencent.com>

The protection state now lives in struct page_counter_protection, so
remove the emin/min_usage/children_min_usage, elow/low_usage/
children_low_usage, min, low and protection_support fields from struct
page_counter.

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.
---
 include/linux/page_counter.h | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index b81f16702764..a4dd461523af 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -43,27 +43,11 @@ struct page_counter {
 
 	CACHELINE_PADDING(_pad1_);
 
-	/* effective memory.min and memory.min usage tracking */
-	unsigned long emin;
-	atomic_long_t min_usage;
-	atomic_long_t children_min_usage;
-
-	/* effective memory.low and memory.low usage tracking */
-	unsigned long elow;
-	atomic_long_t low_usage;
-	atomic_long_t children_low_usage;
-
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
-	CACHELINE_PADDING(_pad2_);
-
-	bool protection_support;
 	bool track_failcnt;
-	unsigned long min;
-	unsigned long low;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
@@ -73,6 +57,9 @@ struct page_counter {
 	 * support memory.min/memory.low (swap, memsw, kmem, tcpmem, ...).
 	 */
 	struct page_counter_protection *prot;
+
+	/* Keep all the read most fields in a separete cacheline. */
+	CACHELINE_PADDING(_pad2_);
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32

-- 
2.43.7



