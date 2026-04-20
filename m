Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E7BF588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7BE6B00BA; Mon, 20 Apr 2026 08:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF866B00BB; Mon, 20 Apr 2026 08:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B9C6B00BC; Mon, 20 Apr 2026 08:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75B1D6B00BA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:54:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 494A91A09A5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:54:14 +0000 (UTC)
X-FDA: 84678927228.16.22FC205
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F2B71C0014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:54:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q8W8bT8B;
	spf=pass (imf21.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21qwcfMPBqAFoGsY5GMYgj3M1yvirBqTjEWNooxl2kM=;
	b=L9MwmBff57XtAyd9A+S8VwEddaIQAjj1JEYfOPDDbFI7bAEeDLyvyA3PD6UfsVG9syhw2A
	rcpdc2VrZ2VX8kxgStYD7AJPOCYEZqjpOWnlOWytk48Y0RZOTxr38OmgCYNnpAW34c33Uy
	L78xkJXfnbjKnn+XR96B5IR6h5Q6nb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689652; a=rsa-sha256;
	cv=none;
	b=pdirgN3bckuRHCNcu3YVjUoHXdr9zVmMELCdq5EYVcmkIGuQiGuYawpZb8ycNjDFcJlH1k
	aVZ8CKPYpPBcOdRz5TtSuDMsuwXaLJE/ogY5SAJSX2mlsTidA9U/zl2MyZsfUCQBaiJgMQ
	GK95NpeWo6w5pRqnuJM5wcSwfgK+uWk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q8W8bT8B;
	spf=pass (imf21.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35fbca04006so1605147a91.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776689651; x=1777294451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21qwcfMPBqAFoGsY5GMYgj3M1yvirBqTjEWNooxl2kM=;
        b=q8W8bT8BqXSreHspdAixopjc1fD83IJ1zaewhCfJutIreg1UXJguSXheVlKcw0sDxN
         sVmmssTcT2s663l3RPGxUXV1tuV4smTGDQf5e5h36r+PVc+bhtCUWtwMoXpX0qyXM9l0
         8SNXdxPuGdmrtlthCUus3ZDP9u9kSHo7koWJxQcJkQKdf1GrjK0jFxSnEEa6d1UrJCvO
         0kdqRCPS823l1bmkIzAhzMYnq+9n9yLvlldLoz5rgRQoHh51FpYMdUhyJ54C57KZUy2Q
         ROdbrLF873A22TJUHSe4NZUKNzjtVWnuJePamsBF1kzEyD3akdFnCprSuKFB4F6PdN0J
         syrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689651; x=1777294451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=21qwcfMPBqAFoGsY5GMYgj3M1yvirBqTjEWNooxl2kM=;
        b=pmlVWC0eiHkjKkNUHhhM+YeJf1dVn7b8O+iSidmCtN/a6/u3AB0+mfM7UxeEoesf+T
         Jom+Abt61XeYqESbPFjTjLT+RUz63IPDfxX2Y1Dr4sDdXYTpA2P8N7ygHL8g/kXKKeUe
         uBB3BKIzj1uRJbMWhObe11GA1zG7IgFCwWcHVmZm3zRoce+bAawREMuvY2V3wlm/mUcA
         BOaPVsfjVHIxXqlYvviLG+zD58a3InHUe5TOaLu5LA30xdPAdcEjztThXrPIXiBs3CAK
         Iwr72+CJ058HFnD6sS4CNZWGFCvvri7WLgn8ZmrCHpoD916paXey3rSWZmIW92jw5ypG
         4MTA==
X-Gm-Message-State: AOJu0YwcqCtEI93DvGm66uHQTXDlf+uPUgMqGOpd4tSsINLxJHF4JEQI
	qHMli9LdldDwENh4NmbbZSpeNTBGy2zIDHfiIMMv5FB0MyjA0TJ6d5/3L13VcsgZ
X-Gm-Gg: AeBDieu8qP/KLYkDTIGF/HmR8Y3cUGQjVUoKnaE90maeH21y3TAt5gkvibCh+Q4SRce
	TjMSd0NH2BFAF5Uo2V+CdktGchW/7PqiK2WPDE35q9tDP0h2oN+UzF7EizUHpyr14fhqlXMvCCf
	7bc0wUOzVNeki+tc4PQjg/VgmRr3OZiyhMpxiNCyi3nOOyXTyWdIOvSihaYnCl91AM1Bk7wV6QC
	2ykewepL1tMdwV6jWkDJEH9fMgfTQdiCAnrO2GT8T87W362zgjx9XcwHC9B4Q4GdGzO5bEqp5u8
	UilHZvT/IAVOTPew5zS2Pff+LctuEorMHfogB33WAtIUPskLlgvOqYuvBPResg2NpJifubA0kqa
	OnODXJcs2S/yPSXnpE9rbwVBFajGaG3e4VwLnUoY4HEpoBG4eNos5x/iRYymeFPqMDdIge1IY5l
	cMxXV2Vgl19TtgRRl7uSLCxJx2fGDgU8Hm3hEIwT3bRwpJJ6tHShRIAQ==
X-Received: by 2002:a17:902:e746:b0:2b0:60b2:4f8 with SMTP id d9443c01a7336-2b5f9f01725mr164450995ad.15.1776689650901;
        Mon, 20 Apr 2026 05:54:10 -0700 (PDT)
Received: from localhost.tail66efb9.ts.net ([240e:3b5:d06f:a890::1000])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab2112csm98517395ad.62.2026.04.20.05.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:54:10 -0700 (PDT)
From: Junxi Qian <qjx1298677004@gmail.com>
To: linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Mon, 20 Apr 2026 20:54:05 +0800
Message-Id: <20260420125405.362137-1-qjx1298677004@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260420085332.178473-1-qjx1298677004@gmail.com>
References: <20260420085332.178473-1-qjx1298677004@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F2B71C0014
X-Rspamd-Server: rspam07
X-Stat-Signature: bghh7i34nbyu1g1bc8egsfb3q6qtc51t
X-Rspam-User: 
X-HE-Tag: 1776689652-611234
X-HE-Meta: U2FsdGVkX19oFpl9coGCR/fP1r/EPiyi8QlbI8bMOVsITR29b1mlwZ2wruKeDUYktSH8C4jKjy+r1OdxuZUJHru5MorZkhg9z02gvvzw+IVsScS+my7B630lOtQh/Gmn1IaaKpH7A3c78m1QZ/xWXCmBpKiNiOJ8DqJdurDwoQJqtHj70UDlD8CtZ8ixpbC4McPOXUzMVK1xyOI2VYTSxhuXkHmqnWtXCGpScInobbA6p42pfIDw3pCzesbWD1pGOXjKn7oYd6iIP1bLSJZrSf+swdEDBdPkxtK7L39No3qwambVXbBZLaAi0fSlqlOxj9/J97k3LDNOUL16xWY9aHoRowAYIHr+Fbh3z8MCTiXRxVOHRXe6imUmW7hF9GoFCaojs73rCmNHw3mnsG/aBpvVReVVq7oxgM4LT5rV7Mgmc/IFxE5vA5I0XMLRAmXvlSvBteqp6Qkb1kSznlUsHEKhpU/XjIc5HdrdmEw0ikEm20evYxGjkNg5wXsQtMw1UhvAcJD1iqD0vvwqnRcsa0J3GzJDVkQd8LLVyiYpWGoW4zwTY8Ym+f2Q3P47hmH1nD8i9qZi011028d5vKbvMAP9ORCjIVwMt+3mBXQEahiJyObr2uyFEb89d0km3Bv2d+HzgGNXIigtsF31WhphWZBXx8ZjyHLTK5CMkwe1MxInPLgJqxgzcfrEvKSJbFGqZc5SBDYUL/5FHVvDqrXCrPwRhJAksDmP6xxGGDnq9uib8pCIh24ixw1QjTPE52kIVaqCh8kZxXqE5UxsHI+2Y9R1+qXMGoybz0LqfM20xndPAyfw72ysSbC7NVkynCHr476zbmdSi293+Cio8RasXwsizc81S62N9939R91h0igy4ODX37XnyKsqVBGGkka+Q+Hw7TYox9sfmt3xg2nFbdlOvT+GotIKmRxPTYZdo5mWfvY97l4masU6KWJZOQ1WfrHZaL8mA4Tf11TuNEX
 pRLWegk2
 cUk9QXqvtAKlzECGFvdQGxqsj258GxJ9Uw4dqMPXdsWSIV9tlS6PX4Po+AG7d+06O36Pf4zECycmeX+PcmQbcyKPhvT9LfSvoUrn4+tx0G1eVVyRV3KGFLWfok8cwL9vXPoiR0yM4+tvfIF8FwDZVj3k2wToezd07C8INGxdaCKYhEC2cQuzgljZ+D4seGrOebLULxsr7sxIsxkh6yMv313lMuzr4K5nRTNsKr7YWHBVCNZ+GqG0RnLGgDZsDR6vQwtn5/k9Hbtp/GJ1YAgZrgHOVU3WQLWGd0lN7Pej17pwRYncTAPb+OIL+vjbPbQu+NSuwopRIA4HxHiBFNn1/aPBel3VLPsh7c+AFMpYQ8sx9Dnor0F+BP339tapm5ucshJ2fQ45F9w0wBnmy7NONUnWD1APzu8fPPc3l7Avthn7LtOPYjpLhxMzHV8A3glxpdkri4B/zAJSUm1U4m+a3ww4P6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_path_store() and path_store() free and replace their respective
string pointers without holding damon_sysfs_lock. This creates a race
with the kdamond thread, which reads these pointers in
damon_sysfs_add_scheme_filters() and damos_sysfs_add_quota_score()
via damon_call() during a "commit" operation.

The race window is as follows:
  Thread A (commit):  holds damon_sysfs_lock, triggers damon_call()
  kdamond thread:     reads sysfs_filter->memcg_path in
                      damon_sysfs_memcg_path_to_id()
  Thread B (sysfs):   calls memcg_path_store() WITHOUT lock,
                      kfree(filter->memcg_path), replaces pointer

Since Thread B does not hold damon_sysfs_lock, the kdamond thread can
observe a freed pointer, resulting in a use-after-free when
damon_sysfs_memcg_path_eq() dereferences it for string comparison.

Similarly, memcg_path_show() and path_show() read the string pointers
without holding the lock, so a concurrent store can free the string
just before sysfs_emit() dereferences it, causing a use-after-free.

KASAN reports the following on v7.0.0-rc5 with CONFIG_KASAN=y:

  ==================================================================
  BUG: KASAN: double-free in memcg_path_store+0x6e/0xc0

  Free of addr ffff888100a086c0 by task exp/149

  CPU: 1 UID: 0 PID: 149 Comm: exp Not tainted 7.0.0-rc5-gd38efd7c139a #18 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x55/0x70
   print_report+0xcb/0x5d0
   kasan_report_invalid_free+0x94/0xc0
   check_slab_allocation+0xde/0x110
   kfree+0x114/0x3b0
   memcg_path_store+0x6e/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0
   do_syscall_64+0xfc/0x580
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 147 on cpu 0 at 12.364295s:
   kasan_save_stack+0x24/0x50
   kasan_save_track+0x17/0x60
   __kasan_kmalloc+0x7f/0x90
   __kmalloc_noprof+0x191/0x490
   memcg_path_store+0x32/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0

  Freed by task 150 on cpu 0 at 13.373810s:
   kasan_save_stack+0x24/0x50
   kasan_save_track+0x17/0x60
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x137/0x3b0
   memcg_path_store+0x6e/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0

  The buggy address belongs to the object at ffff888100a086c0
   which belongs to the cache kmalloc-8 of size 8
  ==================================================================

Fix this by holding damon_sysfs_lock while swapping the path pointer
in both memcg_path_store() and path_store(), and while reading the
path pointer in memcg_path_show() and path_show(). The actual kfree()
is moved outside the lock since the old pointer is no longer reachable
once replaced.

Fixes: 490a43d07f16 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>

---
Changes in v2:
- Also protect memcg_path_show() and path_show() with damon_sysfs_lock,
  since sysfs show and store callbacks can run concurrently and a
  lockless read in show can race with the kfree in store. (Sashiko AI)

 mm/damon/sysfs-schemes.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966da..1a890e2a4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	ssize_t len;
 
-	return sysfs_emit(buf, "%s\n",
+	mutex_lock(&damon_sysfs_lock);
+	len = sysfs_emit(buf, "%s\n",
 			filter->memcg_path ? filter->memcg_path : "");
+	mutex_unlock(&damon_sysfs_lock);
+
+	return len;
 }
 
 static ssize_t memcg_path_store(struct kobject *kobj,
@@ -543,15 +548,20 @@ static ssize_t memcg_path_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
-				   GFP_KERNEL);
+	char *path, *old;
 
+	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
-	kfree(filter->memcg_path);
+
+	mutex_lock(&damon_sysfs_lock);
+	old = filter->memcg_path;
 	filter->memcg_path = path;
+	mutex_unlock(&damon_sysfs_lock);
+
+	kfree(old);
 	return count;
 }
 
@@ -1187,8 +1197,13 @@ static ssize_t path_show(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	ssize_t len;
 
-	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_lock(&damon_sysfs_lock);
+	len = sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+
+	return len;
 }
 
 static ssize_t path_store(struct kobject *kobj,
@@ -1196,15 +1211,20 @@ static ssize_t path_store(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
-	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
-				   GFP_KERNEL);
+	char *path, *old;
 
+	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
-	kfree(goal->path);
+
+	mutex_lock(&damon_sysfs_lock);
+	old = goal->path;
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+
+	kfree(old);
 	return count;
 }
 
-- 
2.34.1


