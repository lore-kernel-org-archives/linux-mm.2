Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468C2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DEF6B0005; Wed, 20 May 2026 01:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CECC6B0088; Wed, 20 May 2026 01:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3B96B008A; Wed, 20 May 2026 01:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 384AC6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:18:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A028540164
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:18:27 +0000 (UTC)
X-FDA: 84786642654.13.AC3A75B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5A574000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:18:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EH7Dr2J0;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779254306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/E4hFESlDCdSBASIA3b9qAiiFnYXUPh4BPJLjM7N8tU=;
	b=A3En0rVcBPSbJ4WEWslmR0sSqopJ1oHWSABi9QzL5HiC4Hqm5U0uu7zc13AAohuyLT23HI
	0Nzm8fueHk7BtnmCeoBO3kwjUcHfBAr9VUQ4eXInkcnsDd0Kf6kjAwxg77PNji6hBo4mUj
	hOR8IlN2OYaguPz4ekoxI0C+nbFsQE0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779254306; a=rsa-sha256;
	cv=none;
	b=viNhMSXwEoJrpcoeg/kLKWOsJq/PN6VO5X78Xgd8dnTtTzQrE/2CLmiQTy8Hf/cLX8RuBl
	XUOocDAMy9zVggaNP7I2omryVv+ggrUoAYTBJ9gjrhOvRmP75qI0gB2X01yOCSq/coibM8
	XN+D2wBp43kWN0YlDuG1MWvHhDjDt50=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EH7Dr2J0;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779254303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/E4hFESlDCdSBASIA3b9qAiiFnYXUPh4BPJLjM7N8tU=;
	b=EH7Dr2J04zATUyPgXeEnCfnrz1SI2JtndYoYjIc2DbUJOrvYi2SL/4ajiiSfEzoyfl23+2
	mS5OechCDtfChNNuivnaHzfjVq+wJF6luh7kW608rpIAfsHb+Vd3LVC+YeDdVd6XCSF5de
	b/ql8gIaL1HakD3QojO5/nQ23N0JwEA=
From: Leon Hwang <leon.hwang@linux.dev>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in transhuge.rst
Date: Wed, 20 May 2026 13:17:51 +0800
Message-ID: <20260520051751.74396-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5A574000B
X-Stat-Signature: hwz745p38m5njrrr3grrq8ya3bs5is61
X-Rspam-User: 
X-HE-Tag: 1779254305-690752
X-HE-Meta: U2FsdGVkX1+FvcIYmKIdoqSWeOsdnbDtUTOzItKqZKeVRNpfe5Tbdq9NgcLQTQvx0xrdKHoUhPhLZ5BuEhjIw3D32baiaiQQUAThhvb0vfOAh2QcxRDtPIv6OyfRAkiHfdbLfX2jL15H19XVunBZsFGPV7qwxVkDTt3+hjJwaPj+XOBK0Nb6x1ptk4nh1rXOvGC5DU1vXdjYRV7e1bLFkcCtQwNww2tZVZ/oHcd2VkkoU80uYHn5F26UfIPfcd+M5y17BPMpZlxegmkm249Rmh4m2vFCmel5t1xs63ZqhoXEMuOk57ZeaoqLwqPhYEUohsDGAStjqu4h+cNM7Bc/L5Opc8os23JsqArhL1Y4NpbgK6EVJb4tfzVsoAGhNWhosI4nAXF4bGzBsBSQWbdaOsUVRixr20QkS/2ruVi7aMZNtFU/pGuwlgrJqnlG2tiJi+ixgdw+FaSLshx3V9hecVV3QmCJhZAP+S+zuhFQqqLJbwqbGonHQhw84yuXr7WoqZQ79++om7gFMqL69t21JNFCmCQcZWPomhHxcJsJTbwJUF1NK8VL3026nJ/T93OSzzBHBrOjXYLcFBt8EqErJdG8Q5YrfPboFfGAkygOZB0mXVXa15atC9FMmZRDTP4NU5fHLOwekxhRzR5BiK8O82uHxyj661v8x7esOyLyCY7s2WcleOuL2FJk/JHSq1Mi8oyOeyzh2jCl9/BNtDLYA5tpeNpBGRmIQm8faEthDJHSAHBqXsXtPo7tIW5DgMyQYhN9O/8pfxgxBXZe+thr7RY/mUlJykD7o1jpnVOF60sFiDjTvxNYNu8SVhcGT87c2spqf0IfsyafBuwojn2fzgb3FLIGRTUdO9Fbjgro6FJqjrjzVUVZLtCOQTIbcU3MOrQkDuaREQweZkh1Hosl3o4NYj2rUUk8pOGW5qUq4jYe+aOH9raN54jDGNgJ6YAh3kz/3VLV8jUT2PBr2VH
 2iXyskWR
 StkWoO8Ynngo3qCBO3t//w3C6uA+w9lAmeykH8qP4jTB3b/yRCSuw4esTROfQLEsoboMeoekyN3/ZnLipzJp+bmTWFRjpYtRZne/yFXYnPQehYSGw1kFZz1gPnO4DV+LVF/OhvaWpI8nzGsMHDX3BdbwZa7HF+W4X+2snZPciRVa77XCaxwYJxLofYllGjQd3sNXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix these two typos:

1. approporiately -> appropriately
2. presure -> pressure

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 Documentation/admin-guide/mm/transhuge.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index fc0127a36ef6..78a1b341a3b5 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -57,7 +57,7 @@ prominent because the size of each page isn't as huge as the PMD-sized
 variant and there is less memory to clear in each page fault. Some
 architectures also employ TLB compression mechanisms to squeeze more
 entries in when a set of PTEs are virtually and physically contiguous
-and approporiately aligned. In this case, TLB misses will occur less
+and appropriately aligned. In this case, TLB misses will occur less
 often.
 
 THP can be enabled system wide or restricted to certain tasks or even
@@ -211,7 +211,7 @@ PMD-mappable transparent hugepage::
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
 All THPs at fault and collapse time will be added to _deferred_list,
-and will therefore be split under memory presure if they are considered
+and will therefore be split under memory pressure if they are considered
 "underused". A THP is underused if the number of zero-filled pages in
 the THP is above max_ptes_none (see below). It is possible to disable
 this behaviour by writing 0 to shrink_underused, and enable it by writing
-- 
2.54.0


