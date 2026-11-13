Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3280C606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9E86B05C5; Fri, 13 Nov 2026 01:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479A86B05D2; Fri, 13 Nov 2026 01:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3691D6B05D7; Fri, 13 Nov 2026 01:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13FCA6B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:30:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A6F04027F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:30:04 +0000 (UTC)
X-FDA: 85429120728.04.60CB082
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E968160004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:30:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of yebin@huaweicloud.com designates 124.71.94.104 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794551402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NkQR6xi/cOvZ4ZlPp1im5E9H9HVf96cud9Xc0osY690=;
	b=n6ZLzMGzmMXCZ7dnxY7Xit5vsRh4wW1lNsyJtdGme5vp6BFLIc4vhTsmZu02N4/7MlLtYF
	pObFCDMqHmdNv5UdGP7hEOEKoVidK62no3294hi58v4B8z6NneUmNbxyTV0/43+/QSkDxg
	kMF0lM1iKUE8gnAZp9vKMIlG7mIsdg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794551402;
	b=aCYF471M/5h3UuFvQa7w6Et8LFQ20wR4YEFnM8EPJNTgFEIPLdUa5lxx0kDrAwT3rdvmn8
	rUjg2ql9Y8SdBFHJ0UXLWdPe7c66aKUywYYIBAuCdmhZO84yVPSSNnh0vx53350xfBN3rP
	ua3liuT5xq+LFcv2JKNWbVcbTDtfWpE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of yebin@huaweicloud.com designates 124.71.94.104 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jQnQv23xTz1rqn9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:29:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3108F4056E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:29:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCn4O9grvZqx2urEA--.25877S4;
	Fri, 13 Nov 2026 14:29:54 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org
Cc: yebin10@huawei.com
Subject: [PATCH] mm: page_alloc: add nid to mm_page_alloc tracepoint
Date: Fri, 13 Nov 2026 14:20:07 +0800
Message-Id: <20261113062007.95040-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn4O9grvZqx2urEA--.25877S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1xJFW3WFyfGr4rArWrZrb_yoW8Xr4Dpa
	1kAryqgFZ7Ww4a9ay8Zwn0yry3u3y8uF42yFyFga4jya4fXr90yrsrKw4qvr9Yy3y2k3sr
	JFWqy34rJ3Wqv3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-Stat-Signature: 1p1o51w11zhnjt6jk4cnijpuobrmerhu
X-Rspamd-Queue-Id: 3E968160004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794551400-266871
X-HE-Meta: U2FsdGVkX180h3yrd2SpssQ2X9KsZYDfJdQg2byWrUzmzG2MRGnwzR58ox/oh+IRz94UEXmAfAinufzTUWYQrCc/X+HV4YutVWXgQhojADEijI+mlN6f+kJEtczbHkyK7ctxBlq/SEDBWWimM2FLCLp2enxPXmSvRV5bOxUuMcLF67t3DgsY0b3pRFG2ADdJA2qEZ7mf+Do51hYMLIKKn/VTf24gW4FeGX79QLOaLwTfgrh1gzWDaihwDWQfsGtrplw0CWfN1nzskiVzWrYlpsh3d12+GcBsq4QTqP4HJFjmqVSVnv6p2fV9uJUji9cb74GCEhdN2TucX/mkB3nD3fUaiyk01uADkkQGT81F583TWvjWCNbOx7xBRlG3NxYmckoH4AII5WWrtzwsLiDek+NglqVX+wbNeM0BpJlTcOtX3LSyS2KVGT9oHDtok0kEcjhkCzy6rD4cq8VmLZUjizH4erhxDdnZ1aUZt3NSM7z9lVU5Ki47wWA2FfybryAxBZ50J/zeDbTAKkvLfdg074H9LEM8eHBpc6EW0BXBAd3NqqDR9RXZRecEfL4ilsyx4s0FhVer7kQzQ4APCBVnhIShQJNl2GjzTKaR77aqgLzmU7PaKISaa/nlbtWFm2CAp9i/bzso2mXF8wK0ZMCSN+/r/kwUJSYy0BiUVBHcrmEnFRcYQcXVDM+v/1Y/HlA8pLhyndxigXo9Ek4xCVcoxXXrWQzrFVtu2cNda++DQQ+3450NsJN1/ZzDtvSnKYX0B/V0LJQxEf2OKZlF2j1QkMxIvsJLcI0eFElzjoRCyjv+SiBoggT/f0ehIKcnOZetG0WWC2NOnDAOfiyv+DP26/2Zp35PWCst4jUwxtn/WMWi/NvsN3dDA2uciwImls1KEkwlbYa+cHpNzFe9/ibqTf7pkU6V6fuKJRGHYY1Sx9ZZwUj8AxeFgKrA6IOAhLU/cG4xw6fvysCdOgkXBx+
 /z7uZTZR
 8KpJKtlMHr7qdPJCWho+ehaP1OudMK1YCHzws5pUOSDkgN3zjvYZAD/v/vdvi7qwVE2z5VCQ+VP6yJwofKBO68TTAMVi7lEmp5gn1Ome32cvzQZQ6hMG855K6MWlfUNs9N+lhCee05EZJPbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Bin <yebin10@huawei.com>

Add the NUMA node id to the mm_page_alloc trace event so that page
allocations can be attributed to a specific node directly from the
trace, without having to look up the pfn separately.

The nid is derived from the allocated page, or set to -1 when no page
is available (e.g. failed allocations).

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 include/trace/events/kmem.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..8bf4e992d8bb 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -189,6 +189,7 @@ TRACE_EVENT(mm_page_alloc,
 		__field(	unsigned int,	order		)
 		__field(	unsigned long,	gfp_flags	)
 		__field(	int,		migratetype	)
+		__field(	int,		nid		)
 	),
 
 	TP_fast_assign(
@@ -196,13 +197,15 @@ TRACE_EVENT(mm_page_alloc,
 		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->migratetype	= migratetype;
+		__entry->nid		= page ? page_to_nid(page) : -1;
 	),
 
-	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d nid=%d gfp_flags=%s",
 		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
 		__entry->migratetype,
+		__entry->nid,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-- 
2.34.1


