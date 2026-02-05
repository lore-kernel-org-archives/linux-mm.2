Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AA4E91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6066B0092; Thu,  5 Feb 2026 04:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B076B009B; Thu,  5 Feb 2026 04:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786156B00A4; Thu,  5 Feb 2026 04:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 621A76B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E02C1C88
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:21 +0000 (UTC)
X-FDA: 84409811682.04.51152D9
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 496A81C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rub8sARC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0u4X3qGXgYyNfrzLzU8BizQ+vhvSMeoi5s8ySDp/8o=;
	b=NIZIB8vQuWIt9sTNIDfVttovxIf7SIpAov3LQ29U/NJGHf4xLTeEqQhTU/N+jduFn9j0le
	5tKraHxNwKlvJk76/sZFymPMPDrb+dJ0tVBR7uicIcLjSDcihr2YyURR6M00BKOdnewTga
	6MHy1LPyvcar1jEgiv0m/COjDpyuIM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282139; a=rsa-sha256;
	cv=none;
	b=5e97SecxbTNoNKHJiO8Th+dUJsLElyN1128HzH3Sjo6zFCsPgtGi7scQGayskG9D+uT5JQ
	6ILgdqsDgl3yAcC/l5iMbdwtF3VaWxEfXQp8Eul9cDF++UiyiBII3/SudQuRH0dw53MguF
	0TkI+yy0StP7CLhTXquJgCga4+Z2AE8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rub8sARC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z0u4X3qGXgYyNfrzLzU8BizQ+vhvSMeoi5s8ySDp/8o=;
	b=Rub8sARCWUqqz8QIAScGUeh64VvqACia5l5MPo9Zu8Clf00z7wJNF9NkdlvFCQxPeg1KjV
	3OlN/oT7NUtlT0Nvv9dPHaB9RbwEpWbREDl3Vdn132CHhDA9TTY70o6MPC50P9xWmezg/p
	BpSvAxenj2HHM8+I+hvB473ZaCBAXCg=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 09/31] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Thu,  5 Feb 2026 17:01:28 +0800
Message-ID: <fc5551a4e252dcac2ee4904706bb2a2513177854.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 496A81C0004
X-Stat-Signature: iou6z87khkisd3i683jbd8a1w53irbaw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770282139-636197
X-HE-Meta: U2FsdGVkX19eJhLdJbHyd56C1UPfMda0nFKXZx3iGgEmz8x8OhIm5tVnP7GhtxS7XX38DIhWeLKHmk+FFnuzRMp8QXnIWh5NJdcMY1mh234k7Ibx7uWycE3PXS2e/eR/DbLYwKoxzn/4Sm7Z+obs0STDK39FPXatQvr5QYKb+seFxHf+v81XibCU7lWuVB9EbPpe4fZIe0aBpTtsfAqVFICGziv7rYRNkxwwcbiNbQfpq+lLldmh6xtzHGmFdKmO5gyHXaQxI+ciFrlQe+8XUX3d4l1VMcihwZlMhZ9Lr3OZfSzoUK0ol2PvJb8GNchepciwvePfUqNru8tBFX0BO4ZW1xl2Fna2rkDJ4jelgSPYy+yjJkQ2x8ECV18HQCXcd/uJR//Cl/b/PM9TvXVo1I3c/ELk8tM5EdHxGMHhqQe7AtKoLv6zWjOMtP+q+Fm09cv67Pidk5cj/XgexQaV8NhZViXc7Px8keRQRNFKY1abWE6M60xhDDYPfkjllpmfmU7vtLGqsn4OBGUkRr4AI6licQo30xUjwk4UEVODWFosXB0vFy+oDtuYgtJx2gxaVlagsne2RHc4JsOoFR2Fsqa6zvCbDjxlGIT+I8+bh75A0aXqwdnt7m+dyZHei13Ns2k7L/v6iqBYod6YFdatIC79462J1q0YDaIXXhIPyxSYh4Q18hhWGbRGd/k6P3PrhruLbpoJyu/ptjM8OoqGNoTOHipgynuQM0fpZew8jBG8TiDpiuw2Jlcw2uivCj1WTbpPIwZYXaR1a82PqntaGSMjp+no9XMvzpD9eX+mbyiWJQLM/W1LOI/uNNKsni2RCl/0y/lLa4E9W3G8A1mnq01EbuZrnJh1+SoTfNOUBF0tN5j18X7bCPJvINwKzFDqktJSQgimZ0jtATHUx0EOaoog1IXqctGnVAvzovffRPQc9MEiN0rIrqoSN/+imjbrv2SVW656uZYLHfADcoz
 huQ/sxMN
 sPb0A5GBs+Hm0cymb5HL+ZEaN6PF15FJMQFIPhIBA7JJGE4M+16ytQBQ1CwhxINfOLgFvhKuwOM550FPiUV+Wt6Emw5FSuzXlPeZHn5XLHzVZaG30YklbLxdlBbe/q+bKlPH+SHimOEyo6DoZ93+PuXNC5lRqhqo+h572hEN3lXvEW88Xv3LIlBjFsXqWBVmH0DHY4Nk9HGnpaWVDsIX7k/G+Xwqr63dlBkhZwXsnLYMe+JAix01C5tJQ3QJy/ngAI4inesXSx1Hg9xl/zU7YvXl8BM7sVPckxED7x+2hVARfXdXkv3Ue2o6O/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b67791690ed33..d80b635cff162 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -926,8 +926,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -948,6 +947,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


