Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3535AC9EC7A
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0126B0088; Mon, 12 Jan 2026 07:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D726B0089; Mon, 12 Jan 2026 07:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F336B008A; Mon, 12 Jan 2026 07:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 433876B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:09:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA4DCC36C6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:09:22 +0000 (UTC)
X-FDA: 84323191764.27.64B08B8
Received: from mail3-163.sinamail.sina.com.cn (mail3-163.sinamail.sina.com.cn [202.108.3.163])
	by imf16.hostedemail.com (Postfix) with ESMTP id C3F12180002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:09:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=LUeYm8YZ;
	spf=pass (imf16.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768219761; a=rsa-sha256;
	cv=none;
	b=N8JOsLbr717crFhuNr5gR2PbgQlMFsSF1eQeic7n7XGUd4cs3RAz11050IsXV2+NulZimX
	P8CZBW6VT4rGv9U8Zbh3ZsG2jAwCfKcHbKIq+28zheSTX0i08YOf0BJRaOYiYNJrPiwFwA
	W/DcLYe2LJLmtXGrEyT42usJ0W/ACIw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=LUeYm8YZ;
	spf=pass (imf16.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.163 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768219761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG1JE0U8CdbsXhCDVRa7lpjBkh8iHi0X7zDNv0cjvGQ=;
	b=pviF9LpQag7J6J+JAcEhS54wdKSgi+iX7MYZp2Ps8CSf0wZQvEUzaX77Mmey7R/KAuGGah
	0430CRiHSh1rLJyo3c2MPJxTUozaJkYiXKH20eNv6w7mWRUKxXy3AmIs2BjO0Gaecfs4ER
	gbaRgDRhXYaCovOMG1W61yy1mIqNQvE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1768219760;
	bh=lG1JE0U8CdbsXhCDVRa7lpjBkh8iHi0X7zDNv0cjvGQ=;
	h=From:Subject:Date:Message-ID;
	b=LUeYm8YZJ49TYJlQoy2eZ5Lda4jC23SItRcBk4PYEKNN8GRQ7UC0vspMs6oWQfdNI
	 xVtdKeXmuExGyTxkE/eljn8oiyL9FqApNvHL9twPI3hE1nPe7JWp/QlSZCOpKFUUAq
	 ZHgNSNPs6stL5kZrGle6IGB72C4FXzKTP1aIGlUE=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.160])
	by sina.com (10.54.253.34) with ESMTP
	id 6964E46900005249; Mon, 12 Jan 2026 20:09:14 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7763946291959
X-SMAIL-UIID: 0345F1A97CE046EA83CE27B384789124-20260112-200914-1
From: Hillf Danton <hdanton@sina.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
Date: Mon, 12 Jan 2026 20:08:42 +0800
Message-ID: <20260112120904.2172-1-hdanton@sina.com>
In-Reply-To: <20260112103612.627247-1-kartikey406@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3F12180002
X-Stat-Signature: z5r6f18mci6ssk7ar6xewywj33dndnww
X-Rspam-User: 
X-HE-Tag: 1768219759-429891
X-HE-Meta: U2FsdGVkX192s8V/Y8zTP+s1pVevrdyUhx2Q9qgYp5Y5kKC5kJPx/kTfkncaIHe8sRkhAl/LU63LaAzTNmueN1nZ8fOI1rsWMRYE0vTOTuaWmaRWH7hI4iezic0+M5u0cnTdiyMV7kERA9WY+u6hRTzq67m5C8YB8ruIRFS4LEnnk24HG8lz2xCQ74x4tY2vUQ5sy1+AruDNeScNCdWHG/V6pVNcIKIEzRd+mWodCPjwVQTrut8RA3kLWMZNesH6ayNMaYRtf3916WM9vWAdVo7obLo8x2itbmDxfedSlnMBnqcr5lmf8+tG9x6gDlsKSOM+pFSrnL+vO0PceOQ0NjBCtcbRezwHVqjeyVn73KpkqaWnJNSKZE4nHAXcO9AHkV/r6m/3dk86dFg9ZJ0zuJQf37XbLOG83+kEz7tUzxkLTTrp/4hkK7OEO6zJTUR+nv/i4rkHD0IxTyPH3wz8iGYII3eEJ1isdfpzlKlovIAv7L86UZW73+pOncUuGYQJEv6tzWLbnaTPMkXG3dTtqFMwF8TYNQ6wPPuB1nIX5zWT5DwikEcKSt26cav0awXkjwYeaDh6W7YrOf1M3saixC0kduVhjy+AUdLO5RE/40gVEA8qFbHIJFaftMbZtk1/oW4U410D6wVK29ArkYGFteQ5SHLbJjC4dF41XJtaqDcn4TdgDJFDMXJBTNui0DsDytQ1D2S0zbX9wVdO0STtzIAqc1jdYNejByDj6bRdeZ+FGpbnTJXMvgVmtESIoPCCDcnJvTjVMwG3ij/bhP5G7vH73NquqQwJg5bN+74vO7fl5BqQtrurv27QW4pamH//pSv173RDyuxRh4DkFrjK9xwtW6QF/pOYVsMSRcjCWc6XcYGmMNy5z4HZmFU3nc5YktR6/mMIPhHtqVnvpxX+773sswAIFcVm2kaIronaTuCGXoSsqi8finX3T7T25id63VJ6CCdZdd07Jff11Ng
 ck72wbwK
 uNlBQmdrLuAjWmFbjDMjcYhICA2BRW/dcFt7IKdBJfDXLRhkA7l1FQ2oTHeeC2oCs/mUvXBzyvSX+rFxq8BNRnf1U25/sfuZpkUg5JKAefzlp3AIAuQA0prTfq2oVms53WHtgW+KmdfeLnt8blOkP7RyZSZSJLo8X+21ZLIp70WfEYsREuJwsMIMHbOJICR9XLjWZRAx3n4Srs8v/uaJRuXiuGRzqB9nyjVgyij1R0ElvGQ1Hjwy1mGO+f9FxOCYNuaGoruY9+WXkU8Kc1D58ioSw0u3H0ZDDQJgfOfxVie7rjZiUmUdzXkTrrGRUjWITSiAOyFIx9uJHu/lNHZMyoYMjdjzU1obX8Vf6b8oGEiGFxvs9QjeMsBMRVHxsnt1doRFrzX3+kBTmSzp41iPdD9zuIOCcAdvJuz59szte0IayW5arf+bi0MzeyXPN7g3W39ObWgPF5rDdUDhRAsZHNv0wD5hBzUMk6t61cJ6CzD0cF1WUFpBk8ZKCvwPfHcXOHvR7d1rpYYegIkkPeHR+lS+oZ14KQMthNu5+V8AYabBaMZMnYNN1lKPGQrdLW/UrYPG6precQGiZS5sfG9qnKlfZiiuNL57XDdBEvUYsvOy+P7UnKZCOaafgqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU
read locks. Processing a large purge_list without rescheduling can
cause the task to hold CPU for extended periods (10+ seconds), leading
to RCU stalls and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs
stack unwinding under RCU read lock. Without yielding, this creates
an unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with
a batch count of 32 as a guaranteed upper bound to prevent worst-case
stalls even under light load.

Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2: Use a macro for batch size (suggested by Uladzislau Rezki)
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..51e58701565d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2268,11 +2268,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2282,6 +2285,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.43.0

