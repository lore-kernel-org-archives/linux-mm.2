Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35D9C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEB36B009E; Thu, 27 Aug 2026 23:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F676B009F; Thu, 27 Aug 2026 23:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9676D6B00A0; Thu, 27 Aug 2026 23:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70EF26B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0841E40321
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:09 +0000 (UTC)
X-FDA: 85149209418.14.4A9E647
Received: from mail-m82139.xmail.ntesmail.com (mail-m82139.xmail.ntesmail.com [156.224.82.139])
	by imf18.hostedemail.com (Postfix) with ESMTP id 898AC1C0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.139 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zG5rWkeFSTxDndaN+4Cvw/kz4uOclj9tnTbbKaNxO9E=;
	b=m0jzqprG/EZ6JbniZyhk96RKO9tzoiEKfiHSktkDPIBA0ETAWOpyw1U3yb7vEyPekR4U67
	ZILHisjJjz1F4m9E0EqO9Y6sTAydwbtVpwYCPlBLKNl5ZzCY0ukNJ+ctLyUcTklaKtV7UD
	XxmbnXfT2LJeaJN+eaJ4wX+rGAXaJtE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886847;
	b=If0rRyExsW7gaChM44VCxUuZwTMWmWt1XBOg+SAlHZ+HYWFoy18BIZAz7phLIqUOdH3lr6
	e7Fhk3UEK1FXUvijLhag2q25YPdMOEmgoCM2za1AYyWgMgItPTriO6tNx971sIQwHQH32N
	4WCH4/99/a84n6uCVcuEdW9RZITfAAU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.139 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20dbd;
	Fri, 28 Aug 2026 11:14:02 +0800 (GMT+08:00)
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
Subject: [PATCH 8/8] Documentation: page_owner: Document PID/TGID/COMM and cgroup filters
Date: Fri, 28 Aug 2026 11:13:39 +0800
Message-Id: <20260828031339.1270699-9-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c31140229kunma81ef96712a363
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTEpLVkpMS0pKT0tNTkJNSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 898AC1C0006
X-Stat-Signature: ap8ybo9mf9kpkwtjarhn63e37moe3bk9
X-HE-Tag: 1787886846-668999
X-HE-Meta: U2FsdGVkX1/1g8guuyxjtewdtc/HTGMaznNX7Do6zj7LsmVdUN4HMDTfgOR8BrfAUmzQAwpmM4ROX3Ai8eDrmlstp8tvtIqgdebGIIFBWf2OvjZUCnpJ1fUhJC9ly2hefAFhUIxmCDDW7gKWCYK3mIhJ7X1vgeshFoUPDrUxEjTab3yZ1P06+j6XC7N9R83NN1kkvWHkFqR41Bc08sU/maEfeGFB3g6VXbu6GuMvq97u2VxZCwnNHd3+WsA9SA0TzKUO4lIKTyFyUvulpaS2cTGzuE8IqvBWAzyi21uBIo42VtzPuvRjgnvKvQLKqJaMvqO6VvDVRXIebmpSm2u8NImOF43/ugFOHTyXJsZ6lC7OYdOiDxg03Zt029calX3q/S0kWLx64+HSRpxw+3J0ppNJ8vn7Woi/8Y0CeO51SVL4IkvYz6y+3AmUa7ftcbnsu9TloywrUtVMD2lzleY/MBKz8tX1SA4R1+GDKQxdr7dQfMCp9nJCVNeHCFAAKCtSYMgrY8Sd7mHR0OigeUpr6VXy46IyXaevMTpyoRaOLdLjWMCytOULWlbHJiKfDvVjYE1kxNt6o6ashhiBolCyn8GbX6HIfRdNccu8ki/7lxYk4C+l1ISOGef72Z6JadnFNqAhXRgmK3nd3Zh+HZoHt8VEkz5xE3FuXFUKfqAdwi4kOhAVT97Z/oq2l8QHFIbU4RPqv/4Xdej8YSuDbOBDOruFuKzl+MmOViNjZiVmSWtOF3dsWGba8sOidIAZAHvoEcy1kMQmKpyGAogiOY1EGfU7/kQx089DHTfkPcfeAXcgVmIpL7wEOzYms6P9wae6F006sVMnam17gmpUpspm4wTOEYH/6QviAjT1ju4d+NC+HGc6xLsLDSFknsBjrlgmCUe+nGQeX30lUjQLBDgx8PJEXHkCghFX8m489iOJeEH863uoKxQDA8HUbY2IV9EYMncrVUfcrSkfg9bHjBC
 fUrhBp9p
 WMpifWimLYE3Ylb2UQYn3cXRNQCZwox0wWID082sl5MQWTR/nhw588atW4jTCBJi28+9m1agmKYs2F7NQAZld0jul/3kf4WnQ6sU0PBtEgJnetRBsHH8vBzToZj1OihsoBFzGxab2CUij9f9Vg15AmHZhAg==
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
 Documentation/mm/page_owner.rst | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index a6bd3fe6423a..c8a7e6c242c5 100644
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
+	./page_owner_filter -c python*
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


