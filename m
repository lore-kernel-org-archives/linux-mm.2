Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EAE1C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA0E6B00B4; Mon,  7 Sep 2026 04:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005AF6B00B5; Mon,  7 Sep 2026 04:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36AB6B00B6; Mon,  7 Sep 2026 04:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C05756B00B4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48A2E806C1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:57 +0000 (UTC)
X-FDA: 85186285674.26.4B34DA2
Received: from mail-m82137.xmail.ntesmail.com (mail-m82137.xmail.ntesmail.com [156.224.82.137])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA8A61C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.137 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769615;
	b=frM8XiPG0Nn7bWHUi1c3DGfhTvetG5uYjg49Sq9xwpyvqSWWqo4SYjUsaB7IGWJcaxZuJC
	/8lsFGHaMpC1FQn5QbLQnDvS5F/w+pRmGN25U0vrgETM3fnxr6Stn9OQBwEXeyOxEbYFde
	va3ub3UQusDvQf6GbUoJU5Zf49b7MtE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.137 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Yb8MKT2vz2LKrYbS96Z0MsIaXqgc4ON5sHmyIy/v/w=;
	b=JZRqtBxo1m84weCFZM83AXCwkTfM5N/PnHFztG1uBrTkkKTe115bdZwYfR352aCunjhVau
	YisWSAOJoWkRlNRRXvl/MWs2dotIlrUJJ9EXrcfo9HERiMM3y2kj26QlPu7cEeM4yx4rwJ
	r4kW8DM6utYunZ7Hdk2K52GcOcBqqPw=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa0a6;
	Mon, 7 Sep 2026 16:26:50 +0800 (GMT+08:00)
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
Subject: [PATCH v3 8/8] Documentation: page_owner: Document PID/TGID/COMM and cgroup filters
Date: Mon,  7 Sep 2026 16:26:20 +0800
Message-Id: <20260907082620.2083838-9-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa2b300229kunm225d16da162d27
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSx9PVh9JHk9MQh5MGUxLGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Stat-Signature: 4xg5q3qpccsu8u4fz5q5mxz8ngdfcgmg
X-Rspamd-Queue-Id: EA8A61C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788769614-969183
X-HE-Meta: U2FsdGVkX1+spCMZfcwaStnTmfhSR3bOw7EmAnrqmS0eVGFRIZq3ID9zFOe49rdJEjQNOW5e9wMzmh7+ozWN3ZAlxM6LXKB7VRmFoTafk6zNnodaaf+e7HB7G+scFrN9gtIl4oIXLu2tWCuE72zSqpam5lhiiKNYcssnJshEZqXnyD4ccdEY1Ozuouq6DRmN8txQsPghRf/RLjMaPceDPpP4ZpzDlRKYXMT+S4hArPIP7Wm3Xf/dz2/NAAZwyh7pao5DrwgdNx1NaMftKoayjvlom2oIIFIaHbQXACuykusRLxoNzV0jaRCFEPzfRT4fCgHezlM13DsNYY1acZopl5XNcQyn2oj4TEhwMD9Duxo5IDdFIAdUV6ECpWgNDuDhn4iwUkVy0kJ4Z1wLxnCdY0b5B1+uPEj+RwjkJYGSZ7RFLcnH+ECdlP98qeTfl78FNuC2MOS3hnUY1dciRb2eKqfdvqcWWb7yyN0nDOxjlkNQnM7APoybwq8rzspyCbehswvR2Ab7XzlYU42ybqKk/0debz2heIQyRbqZip7FGTF28sDjlmrJqE269FLi5nESsxkWvp2CzXYvCLaMFyeYraYGcWbG5NjSzs0RTL+FWZTxW/iY8Kna3vvktAPwvnOQarfl5TFkqhxMzS8Qo0fKBXJYjrBzIzbeVZ3CFFPtDMMwqLtnc8+xUK2SDsWqGbqqO7SF5x/baQNNnRNM3XoaBp7g/nuMTnVK2u5ih1MEEQvDYA+F5IJv5BaWR+M+Vf77/G3L1heXhTPu5YFmYaAJhCkpBoBvM3QqXd6mRI8m7+CEI5Ol2+iHZthMLOR9WaG6Fx2bzjq0UTRrBoYK8MocAwl+f3FKja8kdFgX6U+qqimWac/67LYNyj5nOArL28uRZIyrik1Hbbd6ZbJpvJQhKGWdPkRouMaq7QH1yrBs0dsnS7LHHC0a/mK915WfelA3RBBZuvHUHvitACz522Q
 O6JduTj3
 hguC4DfeyfCTlv1fGmXhF4AoL0jczEKAsliWXqiRqaCsqRSrEPJjnZ6eXnVSf5EeHZ0w23R1wc47e4gNG5BTNwXXWuVVZirZgaebBf11f8sfB5HdHOlSsj0ss0082ty0MpBVF7TFDK7gw5ElgheNdmjBgX5rgSobhPaIU2QiJbx8ijnc=
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
Changes in v3:
- No change.

Changes in v2:
- Quote the wildcard pattern in the -c example.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-9-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-9-zhen.ni@easystack.cn/
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


