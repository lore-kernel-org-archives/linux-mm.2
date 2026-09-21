Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919F0C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BDF6B00AA; Mon, 21 Sep 2026 16:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC156B00AC; Mon, 21 Sep 2026 16:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F06F6B00AA; Mon, 21 Sep 2026 16:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F94B6B00AA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 088C08028E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:46 +0000 (UTC)
X-FDA: 85238837292.01.76F51A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F18AA0010
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/21wIT5";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020844;
	b=OJKcJyeCI19Xwmd/YVCBE47+9QLoD+n/a3evShhdynt/AHsAvYQModPBoyqbkcKzx05sEo
	KoxJfjY0YdvbIps8H9tC2N97b/qsr+8Tu1NvpYz9vC1v+k0U//pHh2/aHUWtp2dLWcEMZv
	5hnOXuPOXQInFXx3GxfQhyS9iCHNlKI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/21wIT5";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y62DVnMDdavAiYdaSQq1B6ymlLgshs+nlcdsOqXOLNo=;
	b=hzWnU2tdesXRGeH1eFYD5/1eRAwTjCK5cY5vyKLC6FBq2t/z0lvS69fSM0DenuxruWtE9H
	Z3z5/MXlnvwMCc0M63SO/rXYoMw+fBDQZFSPzdcF646E5AGshrk4OjajlRQGXn9K7FgLdn
	ghYk8NeF4SPSQEjUdKKeLUz1j8puB9c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A15140095;
	Mon, 21 Sep 2026 20:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF4B1F00899;
	Mon, 21 Sep 2026 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020843;
	bh=y62DVnMDdavAiYdaSQq1B6ymlLgshs+nlcdsOqXOLNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n/21wIT5DeOj0tDR10PV6a4TVmuf60zaeenrhNhRg3XkB2L3EFMMQpfrQPZU4O3cn
	 7cM9mxkE2KJRADMKeYoBo0kRy1TN/yvVfquwu7TsbYnRsL0u6KUytogk/JTcM3M76W
	 eKY/mdS0K+GGpPP95F8qt/P3cRCTvrTuC3q+4vS27DKAN3EcUm6Ong/KC6trt3v79S
	 vmLsPsF/iI/n4rok4KMmDye1qKWnWYa19FxP0Y3FqZ/VhwV8jKRRxFJmf5U5f1dOad
	 A1xy2vUEou15k3S5lbCjf6dRv9e4jRDF6ZLttGqtmSLc026V7phMcqmvBG6R7CtJN+
	 +2jvHiPg71Nrw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:01 +0200
Subject: [PATCH v2 09/13] scripts/gdb: mm.py: remove fallbacks for
 SECTION_HAS_MEM_MAP and SECTION_IS_EARLY
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-9-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1344; i=david@kernel.org;
 h=from:subject:message-id; bh=jwQvu4qZS6XE1lcAS+1uGAzJgDZ5r8Nhr1JAmrC9v1A=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rS9XfrH56DO7yuLD8a/lj7zzGK/7GEn1y3ayqLHL
 iyOqMxZ3lHCwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE6p4wfBVQfSBYV7YgY+e0
 TAXW9gOOi04yqZw/JL50vWPyl2ybVob/idcrC7aKht2MUA15Faec3itQIvishkMytb931eSZa+w
 YAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2F18AA0010
X-Rspam-User: 
X-Stat-Signature: 1an9runfyybaqg8eixg7gfmfyorftfui
X-HE-Tag: 1790020844-537385
X-HE-Meta: U2FsdGVkX1+gViPpTikjYQsHirdWpk7L2CUDWM6JO47xl89hw1EKNm8ACNargmaXcvv3I1DRdS45/GsRQnycL0vkuFYY260D41xql9VdhScgu8LUaLd+acOarQKhTVNT3yu1+/F0Vmu0tI6h/PC/r5Nr9WWsKJyDb+HxgVCaZ7wU3u5BiyxL/bNAuaA8J413HQUI7UL4bpaiF1M6P97gSslbIzysT+ZwjFXiktICb3GoDONnTI99QXhEKYMNJ6Lqm+wX46AJuQdDjjTghC+J9RI9rHW+sMrNJd0ILtfXDcGRyvvQ2wwkICE4hyoymehpcuW0aGDKBcX3LJNk5In2oBXY/BDOoP1P+0r28LvNOnVhJ9t8bKawIs7AQdzQu7fOdyvrSOEI15T68WUgMgGfGxwgySMhuBSyUPlsIwqqOJA6uNhnWaM4N56n5j+xlwJh8YHwV8d0Lr20FAa71Lhwct62PuLZuiOTDte8Wz+rQVe+LE3Tmi9fTsVGwi+taq4TpYRLTzbMy/TPs2dc0VNqwfDyuLQ2M4tyJVQCxXOySnlQYgnwBSenfmNxyaZnqLmysKCwSfCRUa7eeRRP9RZN7nWw2ra0yyKMC6YlQPuP2GaUBSJyZUUsPjR36Ysuo/8mHQUQb8UMXY3+vA63ZP1hm5ZWltzlvBQeFcRMXZHXZwbCgcRVZ9RWB/ZCScpUMHz+1IMxR8o/S6+3j476UWHAICFWugU17wvKUSQlZPT0sn0Z+/98ZdJ/IGMpB+MHX1ZYMMmj/21LUvgXFbj0p0ITJRL57iqXMIbWySRxq0IkDOB0GcmQdX3wZcA4uZuTadL7UGnFZdajf1xF8/Ym786wNSXSNjheuS/b2vW2gB6e4WmF7DNEKclbuOQTmBsmq1renx890BbC5Bda3Gh3QUp8dFQcUVOzB/6We9IqD5dtdjUz1LZ9nCvV9uUU67KUxCndUM5lHyZdhK+9Oaig2gy
 nVi1s7qW
 p+N/sbj/EPOCp7iMM5U1e0dLnRJpzuGatZ670ge/aQnHu4L8GA/+75njqY94181FQrgTAmW+/9I50gtRiOS2jOzYSHRDnYQPivfl8umkfkgHDa3Q5KZbhM6ge7tS0SBLzrIvbks/qmc0StWkhur2ExvlxESEwd1XE2i88aQz8JLxmsaTRLXKFcL7GTTAMmXwn7nSDkGnvPbPH+Mt0uS52kcomjV/EIXw1ToUFLc3qxOp5dE4apbmgBVdkeBH6D1nNefWXWJsXPKVFGW1LymYN0D2gcCDXAaqS/tCsWJvWEi44N7gG91oaUR+q0plllSEauZop
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason to handle the absence of the corresponding BIT
values. So let's remove the fallbacks.

Link: https://lore.kernel.org/r/vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 scripts/gdb/linux/mm.py | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index 193a88d763abf..7398105ff3f67 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -71,12 +71,8 @@ class x86_page_ops():
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
 
-        try:
-            self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
-            self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
-        except:
-            self.SECTION_HAS_MEM_MAP = 1 << 0
-            self.SECTION_IS_EARLY = 1 << 3
+        self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
+        self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
 
         self.SUBSECTION_SHIFT = 21
         self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)

-- 
2.43.0


