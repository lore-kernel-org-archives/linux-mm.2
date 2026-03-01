Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2B7FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F05E6B0005; Sat, 28 Feb 2026 20:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0036B008C; Sat, 28 Feb 2026 20:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7286B0092; Sat, 28 Feb 2026 20:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 398716B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:24:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BB6213AA9F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:24:10 +0000 (UTC)
X-FDA: 84495748260.28.F879521
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D65CF2000C
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:24:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pE/Seyic";
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RJU+nBVJv97LG4AvXLwbe6wbBEomOUTgf1rBOZHOnuA=;
	b=7Gofrf90Usl8n+d50RrnupPHk7scXfxEf+2yaa2fXyToMWXL5dSAAsncWiJUUf7tZXuzrZ
	qsI8v6L1UC8T84bYx3JGj2fA3DhiLz7KSWROcBvoxq45eFZr1yJE0aqPXzehyFc3/B7kwl
	ua1Tt7Mml2cuBmwvNE34TgXnx50qPnw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pE/Seyic";
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328248; a=rsa-sha256;
	cv=none;
	b=leEAnT7kt12mAOFF0hKpprvT6uZo1uYjZtuPhRbas+/V09np2ztjdhSI3T/MLe5qQAwISU
	exncbzAf8dGcCLRht/W80A0VTRNeBAeKPiE3jj9RHJ4ZRRRNL1EkM0C0MIy6ZOBd53zFln
	eJG7In8xhwaWa9W9fRme0nnhk/IwL2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E78D8438C0;
	Sun,  1 Mar 2026 01:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160B6C19421;
	Sun,  1 Mar 2026 01:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328246;
	bh=KksfMdpxkyvIDXGgasBLEr4mx4viiP1gKKA5/7q133g=;
	h=From:To:Cc:Subject:Date:From;
	b=pE/SeyicvqVRcvFLSGyp4xr8jEVdlYn4uZrIOdR0gF1lG9xyvdyg4wA199PFfPAw1
	 OoTFGLJuHdKEUWmClEVu7qWgo9i24KHrygJLe9gpsBgh2JkO+HiCZPinJebyWWY7wP
	 9UCUn/ldTgc4Mr1FhwOd4SFYz+R9hEgOwvbz4j0ouqINRM9IJiqyeNmamGiyFUq6Y9
	 GwQt/zecTU5PR4pip+Lq3Jj24USK/mA1mz5/YSjU/snVmOm+copxrt9P7IIxOX/PLv
	 OyIbCF1KGK8zJk2UI9HtYqwZ1mPmD1CzPQtoJv/9VfoDRqjJM8K7zTEsHMnWBfTeuK
	 Cnj/wFYWwOXQw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:24:04 -0500
Message-ID: <20260301012404.1680833-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D65CF2000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3ozg5g14uz7xisahk3wh5iekhdu7815x
X-Rspam-User: 
X-HE-Tag: 1772328247-461192
X-HE-Meta: U2FsdGVkX1+rlOHWl3OKEz12CbulTITeokaCD9NvpujNwobxsPgV3vXvBf4jRw5Pabug4vqMVs5w7QjTIUDxd7+iNLx2pND6egOufuzk79bKo5GUJm55MpBG+3huI4c81Dl1OxGD+deZ/qDn7SKuM+VW/jDlUyyZqCI0Q3YEdqgQY+2fY5BzgDDd+vrrXSpVCKEolhQciPsGL8fQnJT6YC2lph/QxCcicAoYcKZZ84Yap2Cc2f8M+UJIGNhot1oF/KcRSe/oI160pgyASsoyyZDCpZJw0ksvhYQdBeYah4N4FoXWORUJCYq540/xXea9ZLgrdONKshPHme31Wid3neWCYJf1AXTWydHIft/73Sr7+TLDjVycF/Rgi/MrdzNTUAZsr6wRMOehEkv0ZMz9NT3W8pfZ4lE4kGJZzg1hRPkN/qOR2i7t889Hh+b8qGNNOXkU2ZR/qfnNBrBbEJ7rM/znrjLMs6EyQPjsob3FnhnpykfS9R98zKxvphcOzDhQAJl+fpj7/J3eA0x2IhGVggZNAthxBNScYp1c5A18FFNwd+WSm5P4YLy2Nexb8I9dKYJFBtz3EUi42F0hXvcCbABaw20JH0kb8hg/CyXyjzTOQtwYUJQ8Mif0fgcRmPUd0bK6ZcSkYsOUP3YLUJb/wnuR17/t2+pOslBnqp4szJTwFOlDe4UjBngARjBkNtgPn6jZx5WaJEs3sYSlZKc1lyfv/gq9uw0nXCKzoi+ch/xgQhapzlkcwkh459JZK8PDKW1oA8fsQxtRtMsVISN3AgBUj8YxTmNVb7xE3+0nRv2veqZeJ2tW9oPdFg3mSznyTMXYL8rP0cUeCOlBa5GiHMACkL/yj/pbe3fCtASoMORjdTO0sw4mjrR5X0CuE2GY0vUhFhgLk6TsevHFWzecnVd1oMFVJuikoOqM50vox3J0x21UW4YCJTbbNla3yLKZhbbW36syUI2NELd28oi
 okV9MHFw
 q9Nv0543zV9VnT90x73XpLWAEtC4PgBG31Jqh4IsPqj4sy8td4rdtLzAj6CPu+ZuXtXBvvnpWPStxPtKFgPhCIdKpxoMMbhFMK6ljYl6ClpidpEpsHcBecOMSzmPoo7UL0QS1kTMwc/blzej89yYPAtj75DOS5iKjFywTG+s7Htqts7sK/3yET5BRXAjHqryG0yHs7cFmJdVzwrUtuzBgEnSyZKNVWFtlGLkNtjdR/ClwtTpnmOgWtnEplv2umeIZAOTREiuvWv8FwaixnyF0Jh9976KgxEZAr4uwOD0vHZSZl7Ewwl8mXKyCdXRv58hKbLLcu0R8ZD4QHdHMLE4WnMdw/ZudZV8nStp/LW8HidRInnYukYdBGVfSIY9NbE8/i/szoiZ+khnashmBohSe+ism2C7sWg0Ape6JBR6qS8YpWqEubGiY/z5iDJIOSwYfZ0s9tcCnfMdqIbNZA/OBKFJHN0R70aklVf1C0d2T60Hmycnb1UJQUTv89YEBB6+IlceDQ9yr80hozj9wKvUMMW8M3wmIXxgI2LT4wrjPdKtfI5j1NcU5ZTVY4/YAj9Z38rF9DRlDWIwyM0T9LlOhEifFW/AF5adgamWfyhjEz3ghiXUI0XGeI6vHH5ARWaKn+tiqyWHBEYb4MQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5747435e0fd474c24530ef1a6822f47e7d264b27 Mon Sep 17 00:00:00 2001
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 12 Jan 2026 16:06:12 +0530
Subject: [PATCH] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

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
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 32d6ee92d4ff8..ca4c653286870 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2273,11 +2273,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
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
@@ -2287,6 +2290,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
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
2.51.0





