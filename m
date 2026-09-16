Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4DDC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8816B6B0099; Wed, 16 Sep 2026 04:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859496B009B; Wed, 16 Sep 2026 04:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7701E6B009D; Wed, 16 Sep 2026 04:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5046B6B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:25:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7460DA5CBB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:55 +0000 (UTC)
X-FDA: 85218942270.29.F4E750E
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86373180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ACNpOlIz;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547153;
	b=RCzKKQdfO8f1BoT4vjQhEVO0XRqaj5VyuKEpib0tjq284RWYdDQP5zzmZVU41HSu/JyYy0
	JX5m6ZSY2vQ+Hu3lShkzvoV6H/jCOJN2yFZlknuqshzd51Coc3Z3lm7O3DTmFT146QPmdH
	CeMCNaatzam//ujFKz+uXOwBsoSllxQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ACNpOlIz;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2ktMOrJkrDwgj+T0H+wkoH9GzX4oQBoNSGRK9rac5k=;
	b=HPSEfLMmOIwl71LN8RysDD9aqOIwtlXim+acC0aNmOdsLHIfoCBoQj9EG1DG0H1+/YD7Gj
	1bLjz+RvLV9toDRT7T21G9yzj3MCXo848bvXC33xH8Arh/2QAesTM6ZxyEkOAms+EK3kSJ
	XsChSfXnvvN6LadEcjrY55WqJYI5HOQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jFgYLuMhSLSQE34QZ7YWi1qBRpOmgxt6A18X041cY7s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547152; v=1; x=1790151952;
 b=ACNpOlIziJcMJjVV9bgvUAjoiPUr5hhT/e+mnH4Aj2rGohMGrWaSh8nOrIxFAcU+1lmoZxEW
 9pAvzI4Nhu+KbjVCzY/TBzU3wLJnNl79CeHuw3/is7OSmOWtMX4F9tN5pkHmNUAhUUVguVXyo28
 p7ytLlGQmIOTrc6bx8DyL888=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ee530d7fdc31aba6;
	Wed, 16 Sep 2026 08:25:52 +0000
X-Mizu-Trace-ID: ee530d7fdc31aba6
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 16 Sep 2026 16:25:30 +0800
Subject: [PATCH 3/3] mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc
 addresses
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-vmalloc_dump_obj-v1-3-7aa402d224df@linux.dev>
References: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
In-Reply-To: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86373180004
X-Stat-Signature: b4ap9uyg41xr9sm9emf7eqtg5kxzbzte
X-Rspam-User: 
X-HE-Tag: 1789547153-627065
X-HE-Meta: U2FsdGVkX1+3qBF+ePUilhPJaqGkJ8+MkXhUUtH6rv5knCXUajMTYrg+2jkDopeZXxREsCbeuYJXjnRcDkZxCnbr/R5JM4i6bRyucRA/daDgBJsEP+KFpTbXkyJrlX90+C2UPlh8ESx/9QKTAsZ+ye5zSSE1ZzfVtPDkvmdMoy2DXcPXLKyqu2J5LvswRtEVoOI9l7oqNfX8lNX02rL8r2k7a4dgihn3psMockk3ZQUvZQhDUio20yUhooBxLl6FLfIiuBS+YrB0KKXJ1zzM8L35r68RCPDgUgkOeXz/OFgjuJ3DZ311OzFRX7mnGyX9/pLPWmjR4FFZ4tYyMlWD4VnCumw7uXzOkrIraC+yIQdfS6/ApIK/bGzBIoy6y70eGuESb/UJgzW8BSR9wuzlbtfQhxpayiiiIIKoCDAz8KkynvWE7dTtu5aLRdK0XsIk0yTnY2IbfpR/m4zecbbOWqPqcS7h6MmrqVCxeuKfJastKglE0SkPZ/woeELKr5f685Cdb42VxfDM+piktTpLFSujBLojDwwcuUXNA81x+y1ufc5mnPkjOWmnnPMTgUk3IAE9WvJ5xCmDeXfxslwWusXUZ/V8PFDno1moCjNSUnP/5Z5WRBG9Q+Q7NYvqqHQgoq1aBHfDBuGJIGjaikjTi0jiseL+Zr2bV/ZkKJwX5mTMo7BALHfgM2BRKtV5n7B0h57DXOGE1ARyd4XkeEUdiAUouhQ7ShsGefiCk0jvA0bS15NJ3fWpudq83Zp950yaBQcEQG6ksdFNQPUAjEAC1tBaGjOchJs9WMi4b1twuQ+u/hJurNSPEdnJImiNPEIr14co6t1qdRk5tgf+VytB03G9x+pO1L1aSF+2n9adti04XD1AEIVy7ubc21q/YFQB6dG9e7G+Is6LxnxzecekabAEiydfa8T5Ryn0ODXwSxd4vzUEy9c1vxeOkSmT7Unah/sWxFbt6g1Du/VD5v3
 rhcY/HMd
 9QTUPnsBITrc28JDPBJAuRnnNi92/G2AEpiRfmU9hrun03vO/XnwGAHANojKHxbbNJu3V4FMlCs/Xz6WXqxd3FcJUhOTPALUE7cO6SqCIUnFPtsVHrvB+G7WYKj92iT2GmxKmR/p5F5zxsZlruJ2iDPc2T+mD9lhjYzTj8w8eA+q1QxQCFToDN1JsJkn4MnJiLk0omuV/bqyORKMwFUX0hSLC4rb8/fgXMWimWSke3AN2XcC9fgx642YvyCjeQ2qhsKcGEZfYNQKow1KBFVzUCks+OG6Pdcs/ds2JyjXlZYYF0jN8SKPQTLsVRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() unconditionally searches all vmap nodes even when
called with a non-vmalloc address (e.g. a slab or stack pointer from
mem_dump_obj()).  Add an is_vmalloc_addr() check at the entry to
avoid the unnecessary per-node trylock and rb-tree traversal.

The KASAN caller already gates on is_vmalloc_addr(), but mem_dump_obj()
calls vmalloc_dump_obj() before the fallback type check, so the guard
in the callee covers both paths without requiring caller changes.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 30c610f678dc..b3e706fde202 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,6 +5277,9 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
+	if (!is_vmalloc_addr(object))
+		return false;
+
 	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 
 	/*

-- 
2.25.1


