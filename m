Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4D6C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C846B0095; Thu, 23 Jul 2026 22:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ECE46B0096; Thu, 23 Jul 2026 22:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401A96B0099; Thu, 23 Jul 2026 22:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 180036B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:18:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BAB040221
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:18:06 +0000 (UTC)
X-FDA: 85022060172.23.EB71022
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA6E3180004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:18:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m6LyyPZe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784859485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dkDxI/YU4h74RWLt0j/KtkqxL8bNC1CurQ3sW+7Nc40=;
	b=kfpIwKBsTc66yBQ9e4e+4H+Ue+w7nmQYQLXrLzgOAkOQ/V9D1N1u1uiMT+GPK5YMNTz+RE
	80MI47w2X4fRgbtCo8LQzPLbsvxTlCPhx0HR5uIprW4B/7WNvzyRV5WjvfRG5IvCd+Jzvn
	NjIRGvsHdMJoiQgD/dqzZy3oYgVt6ss=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m6LyyPZe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784859485;
	b=q1IVS4wa6BhmVcWZbFCZIwK7FABP85iu9NPww97g4UkxXuorN/vvS6uothfCRyXeUkeg3r
	Djk842LB2ZNi9HPDP29VjxJ+nG3XVv4tcv+3JiNrgsoxLgkw5m1N63GSZHPXIr9KMUy/+M
	LOgn7RaqEXFaKNp6YTYmXINxLW/4RxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784859482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dkDxI/YU4h74RWLt0j/KtkqxL8bNC1CurQ3sW+7Nc40=;
	b=m6LyyPZeNG8i5rjVFkZXPlsO0v9FnA42zs3OT99CGDpyOYelE39pPRuFwb2gnhWuxVFMi5
	fWw090Je9B4PLWam00PonOTRKdW/2S9MztGP9S/nourLMlqjLDNLuCKWh+CnH9S1UymNES
	SQMQVCqlWejoODsnz7GdinNbRZ0xZls=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800
Message-Id: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA6E3180004
X-Rspam-User: 
X-Stat-Signature: uafjzwg1sb7igh934tuqd3eg8xhqa38i
X-HE-Tag: 1784859484-329806
X-HE-Meta: U2FsdGVkX1+aKBQyoQCqKRfspmZ791tQ0i5i0mrOnTRTRznPqBy3Y2bEQxh71j1Ppf5/ZB66ZT2WyXvshPTl2lIGOjaUwzRaBCRfUTTBffYzf3gqVg/XO6G9xXeVVZ2/Bj19UyYio4Wdlhx3ooZUbuSQHN9QPhxRoCFcQ4lOjQk0HcQr9i96wPtXqfs8a4X/qILdRcChDNabBWk1Psvun1AB+lQ31+KkrzW6BP4swVNk6IuEsrJpSMEFY6HuE7Qb0vbEzsCq2kkbtRbqUiF5mpVPV/51hRN5ZGjWe7m1ioEzN+jJ/Q01m9FqYhDn5IQL8ldcpgovGx85ESBnwp5BuRcD5NQHLpeCG7qbp/A2GONJ6vbaNIZS4LrV0OLAS3sViugcpYfOPPCxCvMBSVsDLzCKU2HCWErC4Cs7E09lMq1WjtZ+F58z/z0euiGxfakEmLoBAH/5Ga5F3CPIBU03eC100kNVyQdVfmmFaZcOiKuh6bllZsVHn/xb8Hr/MxwnBJrs5IeRtZgZKWSU6GMjqK1JxJnO8YNfMfdEjZFlalw3IewTr05oNa0i/b2ETNRWv3P7yTW34NlRa2303Hl4Uju4Q18jcdmQwcz+KTHmzNVz+s7uFOu7XTBTqE21/8smSTk7yy+8H3pLJQ7GZ+J3F9hfQQxiqbATbZ2QBos9aR87qZrubnmMi7BuEPyG848/KKZtdZgQ4nqzh6kDRfiS6xyrOVE178UG+EmBZP2wFOPxlaVpBsgTnPBgYaXPsKUWIqXelnVeV/ihYeVxaiNCKW+vQ70sRGsURdkJeRhGuaq+CNOypROazU/ckcglttPUcL+R4xrsPcWKh4zapWeNGlAxvUIL1BFpoaDzTEJtlNBiV5uvWaUaqVoty4J4j3mHOoLZRJMNkip1yMt8sJV8/vZKWWc3H+WBHutGeeaHtPvPUPh4ISwVUy8k4/Ii9Do56hAeW3E+0ywdOqcmwo3
 bJsrAleM
 HXQV8umGXVtzyA6xNmXnFpziijfm09A7bESGFyS3Y406JiKwNCBvkBrx3qzXBdNG/RwFBqMfPmnfuLzSd4s8jR9Nr+ZfFSiVhZpC4iQZzArj/3pnKyaAv1vTS7dXa0ryjWEWpNG29UAlxPuLz8nxg1j7/CIA4bEaGPHdCsALex0+5xEANC15x3B2DJjFkkCtflDNn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently.
Both handlers store the new limit before synchronous reclaim, but
continue to use the writer's local target in the reclaim loop. If another
writer raises or removes the limit, the first writer can continue
reclaiming toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted. The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer
still compares usage against its stale target and records another OOM
event.

Check the current limit at the start of each reclaim iteration and stop
if it no longer matches the writer's target.

Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Reproducer:

Populate a cgroup with anonymous memory and disable swapping. Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter. With the patch, it returns normally.

 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..638bdc766616 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
-- 
2.25.1

