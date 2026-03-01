Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4C3FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3638F6B008A; Sat, 28 Feb 2026 20:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA1D6B0093; Sat, 28 Feb 2026 20:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2105D6B0095; Sat, 28 Feb 2026 20:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0EACE6B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:35:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB0FD13ABC6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:35:00 +0000 (UTC)
X-FDA: 84495775560.06.2B5451A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1ACC480010
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:34:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K15GfRyG;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=No1Rlw5Z/5YVusT2vEKJQCkpttbrqz6fxRzUlIkqIlM=;
	b=pcpUSrxuBT4lVGVB2G+qW+0Kwtg5Dj9hGH6jROdFZ2N2SQXh0ig7FvdpL8YBKE4U48Ro8F
	PtaWEBAtJCh1fs82ZdPhZYVmWxYA3jcC88yY5Q5gOsMrATSPj9hrLFm8dOM+pdCKasoh9w
	w/axz4pYLo14R/783gcUQf0OcgTeJIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328899; a=rsa-sha256;
	cv=none;
	b=6dZIIuEeVfIGGRc5XegonVff2ViLzrEeP0nnqsPT9KeM+POntkf1T6DKe93IX90O5dKPeg
	9554h03OOdqTCxG5AbSAMr+MfKIrNslFw7rld7L84CQWW07Q4TbfzOMZ+5Q1egbMund9G5
	0agS2ImY+eObGK97qVFbbALlh9UdhzQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K15GfRyG;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F78D6012A;
	Sun,  1 Mar 2026 01:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F1AC19421;
	Sun,  1 Mar 2026 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328898;
	bh=P5OHEuIAYXzcT4K/YlOBcPV+HDpDVi/KKJ18ucbm0J4=;
	h=From:To:Cc:Subject:Date:From;
	b=K15GfRyG7ZweUGIeml9tHNQK+uRqb7MHz+nn+1IIGjT1Gc/Em8zM9BNbrCRWwqjzX
	 HL7zlpEwzZlSmTYODx9szaKri5A69EeG8fj5Fb7JFUAQ+tJ/ydf/AsSUG2E7okjsEm
	 QiKvTR+3kqzC/L1wxlGgrG0uA8+wNa0mWouW4m1RXFq+Cu1BsViEbPZC7T9FZrwQ4j
	 A6kmedgDweKe5OiYT2VrA9lww5LT3VxPpUMqe246QK/nxSYchyKOX6ltS+4ZVG2htH
	 8u551/fqLWsieofpWVmWKzkuPgK6WNJX9FpVF+iFKFeh1IlaQtMkpVvzyIE1lae+25
	 Kz4z6/YD1c/hg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:34:55 -0500
Message-ID: <20260301013456.1694526-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1ACC480010
X-Stat-Signature: xig45y9hg4qhaw9euw18jkgbniercks7
X-HE-Tag: 1772328898-975901
X-HE-Meta: U2FsdGVkX197Mu9D002wLm9ZlGxB4kmAf7sqEBM/XQ6A4otHulJnGmibI5CdnD0aCPJwPFwm4eJC/eN7AxqgRl0/RSJrwUfhWiQ/lenXk1RmgfpfjKSuzrJ/7A07D53em/ejoULOnyg8fdysr3lAEXCgljoXOiCUzzWvHaXx1i8cQxe8YsCSivhuNWxHRj65FFpkhj2A2knpi23ZibHH7lDXnAm21efF74j6/l2zJpR4Je/Ue0/X9fabCVDyP7SKXoKOw9ylHH9mMYzKFBAEk3tnYgmqvnH+ECaIUW5kiVEm2csbb9BgjpKPncOPbQapMNtQK83LG1CD+byl7CxwRKVVbih7cOhdFmqh8dKMenHE+fQtPqxK7kQc1xb1JOWXQCOgjxXK7wW+eRlE1yX46NXG85SRtnsyONPdtlVRgvIBkmznNDPvmUvNdUP4CJwhMYeBwwPrGcHlUxQTBOzoNBi/57lQ6C17C6uxgEX1IjaX3OWpnPTRYO7SyTgdhrNQWVb6fWwGIHBBm2XUTVU+sHcDUMH1teK3BQPKUwPu+p7tIeZgMnQrdvAug5vmjFpnhoHU/TwJ5YUAcG2uUf68itqLTuFjGcvIs4wxcqXFk1XjLcwDEiVmIx6TQK0blSNUXc2sAzvyoJVLXzSGu1iZMwOejrGYsnUNhF9/z8WQofcS0w//fGA1Z426mga92L1LmR8UMhJc7QWOsfz3fDB+rwojyO5AnUtV6n82NKpY7xjHcyxKye4pgpVv+q5RNibvx3Ot8s64nDLnXQcz43rmtHhHFk1u/kUux+uZdg2axXO/ChMJsQiFL48gJRSEL20Gwb5h77ZckfGAEMtKtpcSuKhww0BLR+fIs/zvGJ73pIJmjBDnbd8lRmyaSWeFGml6swMEKCYu3/JI0gr6v5C2/Hv9K3U79Hi8qNh27URVFX+bC7bOdvPkkcY9SrEJUgPsw/br5WzmiRq7zsglXix
 QwsivBIN
 +BdwqOTErsJBPG3X43VH4sSQ/uPUX5qDBdj3Zs0GQ9cVvhhsgeK9AkCQEoyItFqbz5bIQW09oCV2YJrIqM4CmO0XNKnpgAQzyBAnyslR5P7SjhDbAD1kkelgczB+QmqwPEAQbOjQfqdfmYPICpkwyhmoOn3OI81p1fjKhoyiWgKWlbIEyo4p+Hf9BIJhoUcZr9py4qaUoH8sI5csq9NyqRAUNAUAcz3QJYqePffquhy//NaEFyhwP5yBiavNRsrSCpfy8W0GLZMiCG76NNi4rHZAzC3DnNZFm+9PRPNKVfOUUPmw+zsk6Zgp4jH6b+SWfUzyz5AVURmcaVqyxUS3+mDCfPBGqb6NVJmh8uiyrxl7ZOTZkgmF+CtppJxKMoT7RotiiZyWjQ4yWavdbY3VjltQU14OE4XYVviXJynS7c0in0FzKD2dCD0JjItanfyuFfQfDJpH86Qlq8NVy/3PG5KPNbdmmZdqtrg9QwcmQLal941QM8FeD7jUD0oPNT+tgAxFBVXwMqefwo+VbWq5UbZXa3MinrLtfZ30uVLket/jFAluA0IiO3hn8wn0BqQKDM0hQP2T8PqeIlEJreYmCmkx2iop01MIryD9OKPnxwop/g7yzpWqXcV8YXk3t/Dox+WNAMD7M6/dfpLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
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





