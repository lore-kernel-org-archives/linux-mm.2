Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC18C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8136B00AE; Thu,  3 Sep 2026 00:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A166B00B0; Thu,  3 Sep 2026 00:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E729D6B00B2; Thu,  3 Sep 2026 00:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7EF96B00AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F34C1C20C6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:48 +0000 (UTC)
X-FDA: 85171145136.16.0E370D8
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D75C40008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf01.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hcVnk4l5Xr/fF7T11rzi5fdcoD2NdB9YJrmlW077gQw=;
	b=kjzOFWTdfP13Qzrv7Ic7RiJp1Al5Tuu7A9JubOmdGudPCVVSe+QujONUc0qHoy72HvCMMM
	l4zcEhWIRE3aXM2wlIZDE0kxFOZgBl7XTcwTdv5ymTqYIewBNxjFxBoCJZwkPgSmPpp2MI
	kJZvmVjgihOuoLHrleEcf4gE98Ezu0w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf01.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409126;
	b=PQgV7F+ZddlcEgBbPZ0+V9vgtRBDMTuIDRLJM77RrLnZuokwveg4bJfMibRXPKUpgduQfP
	XZVr87bWzMAUv2QjuZvgZlauhjBHEPXu1qh/UKJZtjjm1DhWjQFhXiN/QcmjFGlMQTHKOL
	wc45c9MtUQQuXEofWvp+NKZAha/kFzg=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3bc;
	Thu, 3 Sep 2026 12:18:41 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 8/8] Documentation: page_owner: Document PID/TGID/COMM and cgroup filters
Date: Thu,  3 Sep 2026 12:18:19 +0800
Message-Id: <20260903041819.1776630-9-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d8ab40229kunm7336907a330cc
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTkpPVkwaGE9NSx8dTUpISVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: rbycwhbg9weyoccoar95kdkwmku6xyji
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D75C40008
X-Rspam-User: 
X-HE-Tag: 1788409125-694024
X-HE-Meta: U2FsdGVkX1/4OElOnQNGn9xzgLDA9oE1binWqg3SEz6u3zG9ROaVuYTslqkpuPo+QdVacFwKjZTIjtuAApe/1rZhYsUuec8KwuQaxAEGcgmGVjoD+xQaj4jiw8M7bvBaRyZA+Ly7JgNRw2HI4Wd92YFRq2UUJ7jmmw0O9NWWqGS1+yTCUCDgPai80lhh3dCEK3lhjsV9KNWcHJC5C6gPC1Hdu7SZ+Qys5y5G9RFkumCY+1wnE4uTcfygWI0dd/nJkAa2oKkwmjNo+N4HrCwrpN7nUe8qAzp3ZouFJVVWdmieJUioJ3DuTaTpeYe2M62/jfjv/c6jmIACSV3d4qhDpEpXTBZFs42K27QvrlyI7QSwsXUIRAy/9JE8UFWqq2DbLma0+h0nwOVaVdHy18+j2pLK+jy25sevIV2QCYw8/pU1US0yhrhr6hQwVd1mGNwFSqvMzzEVVpxh5z2QVXZwEYS2AHctgyh6Rc7mPdN/6KeVuLaCBm6bP8x5atm93OGMwr9wgrb7vmEGUtVts+Pzlcn8wrfIcYfUtn0m06xGjnY5eYjSrFhIgQokEwXqCOEmpRoq6eB/5HZExTve39pwVe6MDPjagIcKnH5TZ+X/Mk3WPwLzdyul3tg5gOzBils0MCqfqiG8hhNWdD5xd9442ewNNLU99sxEa8Qy/8Mf2iIlsx6LiXAChdKqmTWcTzAc3weykfP5wTQOgg3qPehBKsPyiGotM+bh/ZcXscpGbENRu+f/xFKTwjbwh3VK+AST+NEayvtoxqGd81x1snC6SROm4s7F2gzJ1y77pYs3r44q7E/op5IP44rZGn8H8Wi8IwBO83aJjqoIs9Frwtxdh5+I/ilvUfsGnPBBP0Kxs4id211kweGDCFfJnxb4IuPLgsPRGYni+CboXIY0c1BB6B50YzfN+Hb7rPPLoa8R+Lh8nnl/yNH+Z2F04IensI2CTVwra/DkNNNMzH2exwe
 jQaDrk2Z
 SCEQuBoKksFKwHLnXMsWqc/p6GNRUs+ykD8KV7EqzPlDcuoTG7zw6G4Zj5WwMRNgFpCDqC4N89qkjfVxXlWjAvNo+DvFBgEc5dAtvW4nd4yuDRwt0q2p5YQ11LgzD+MLGZbZZN1Jt2U1K1VLbl5Pj1GzKtcPnmPl5pvCy6uwD3LQqvqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update page_owner.rst to document process and cgroup filtering
support in page_owner_filter tool. Add usage examples for PID, TGID,
COMM (with wildcard support), and cgroup filters along with their
respective limits.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- Quote the wildcard pattern in the -c example.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-9-zhen.ni@easystack.cn/
---
 Documentation/mm/page_owner.rst | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index a6bd3fe6423a..493f38db0677 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -283,7 +283,7 @@ page_owner supports filtering output at the kernel level before reading,
 which reduces the amount of data that needs to be processed in userspace.
 
 The page_owner_filter tool provides a convenient interface for this filtering
-capability. It supports two types of filters:
+capability. It supports the following types of filters:
 
 1. **print_mode filter**: Control what information is printed for each page
 	- ``stack``: Print full stack traces (default, compatible with existing usage)
@@ -300,6 +300,16 @@ capability. It supports two types of filters:
 	- Ranges: ``-n 0-3``
 	- Mixed format: ``-n 0,2-3,5``
 
+3. **Process filters**: Filter pages by process identifiers
+	- Filter by process ID: ``-p PID_LIST`` (comma-separated, max 16)
+	- Filter by thread group ID: ``-t TGID_LIST`` (comma-separated, max 16)
+	- Filter by task command name: ``-c COMM_LIST`` (comma-separated, max 8)
+	- Name matching supports wildcards: ``*``, ``?``, ``[a-z]``
+
+4. **Cgroup (memcg) filter**: Filter pages by memory cgroup
+	- Filter by cgroup path: ``-g CGROUP``
+	- Useful for containerized environments and multi-tenant systems
+
 Usage examples::
 
 	# Filter by print mode
@@ -310,9 +320,19 @@ Usage examples::
 	./page_owner_filter -n 0
 	./page_owner_filter -n 0-3
 
+	# Filter by process
+	./page_owner_filter -p 1234
+	./page_owner_filter -t 1,2,3
+	./page_owner_filter -c 'python*'
+
+	# Filter by cgroup
+	./page_owner_filter -g system.slice
+	./page_owner_filter -g kubepods/besteffort/pod123
+
 	# Combined filters
 	./page_owner_filter -m stack -n 0,1,2
 	./page_owner_filter -m handle -n 0,2-3
+	./page_owner_filter -g user.slice -c bash -n 0
 
 	# Save to file
 	./page_owner_filter -m handle -o filtered_output.txt
@@ -323,6 +343,9 @@ reduce output size by ~66% (84MB vs 244MB) and improve read performance by ~4.4x
 compared to full stack output.
 
 The NUMA node filter is useful for NUMA-aware memory allocation analysis and debugging.
+Process filters help isolate memory allocations for specific processes or tasks.
+The cgroup filter is essential for containerized environments where you need to
+analyze memory usage per container or service.
 
 Behind the scenes, page_owner_filter opens /sys/kernel/debug/page_owner and
 writes filter commands before reading the filtered output. The filtering uses
-- 
2.20.1


