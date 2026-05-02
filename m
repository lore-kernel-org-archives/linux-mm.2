Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA7ECD3423
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 15:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5F46B0005; Sat,  2 May 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65C46B008A; Sat,  2 May 2026 11:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55276B008C; Sat,  2 May 2026 11:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2BD66B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:57:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 503751C0428
	for <linux-mm@kvack.org>; Sat,  2 May 2026 15:57:43 +0000 (UTC)
X-FDA: 84722935206.17.8162841
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D356120003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 15:57:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e9pc0bW5;
	spf=pass (imf29.hostedemail.com: domain of mohamedaymanworkspace@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mohamedaymanworkspace@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777737461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RcVZiQ30W1huw4BV8djFk9EqcnFjYr+6xdWEC/QCnS0=;
	b=bciN4AUeLP++tItMXBpRT/dW8LJVFYeJquizoorjvlLy2EwaHf+Jkg+9xKMqaw+tN82Rpq
	VTJX9cXo484cagOp0tdEatqjE04spoSRBXg6hZnh8vkvZ5LpahAjDJ3sD7pCY5BSHPoGSR
	Ggx7XKA6qHbZbiRG6FZBtDaKGzAU7u8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e9pc0bW5;
	spf=pass (imf29.hostedemail.com: domain of mohamedaymanworkspace@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mohamedaymanworkspace@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777737461; a=rsa-sha256;
	cv=none;
	b=NfunxKnKI+ssu/Z+kumf1aOJtJ1yLd96FiuEkrErAEf2aYL+5R0Nl+a0LJ5soe/PY0Na49
	4u4HeYJ4y/li/C6GG/Hhhpr7UkXkuTdzevDIH8ngF6o6gdPY/z60gQeHu07Pd3aO/yYuUE
	IeVAX6kZbXp5Yhl1XWl3En8d8zEZ1Cs=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so40898545e9.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777737460; x=1778342260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RcVZiQ30W1huw4BV8djFk9EqcnFjYr+6xdWEC/QCnS0=;
        b=e9pc0bW5pX40HPxVxrnXctfZEz4LiEMeON14KNtjqhKScPsyCxQcgAyj8fcm9sXUM/
         98dUZjWC8UcV98ffBvgQjQBVDkH2dowKwxAMZkv/JusN4Ot2boohjwrUUDIwYT1qYNXV
         1JUkf2TggeBxR5HyPi/NwJCbatHe7TfwiF3IcC7zAHpPAkqCrmfuxofaeMcDIwt5boGD
         wnCerrAplHXi920ryDVZmEDuE2RVKJSbBb3haa4dD9kYoLMCg4QzmM5uV96zCcEnA1+H
         GYYmMix5JQGP41a8STVdJhG3vHaderhJfAxZ2ieR9YZuIIivijYLOfEb+ZYgIeXCDMiL
         M/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777737460; x=1778342260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcVZiQ30W1huw4BV8djFk9EqcnFjYr+6xdWEC/QCnS0=;
        b=GuK4cZBua6N1nrm7ULEo3pVQ7gLG1YWfu3j+FO8jloG3Ox+dMTQRRDyM8R75edrBC+
         w4J2dZqOYZxQ31CaYqouvWkYKrgNPab1BOZG9tPCGw8ETSIzyNcJpQd2zc7vxZpTMY0m
         VbrXdeWS/00v5IqeMA8tOYrgDYaCA3lQR1Sbk/D0Yp+x7zO/sTEhrsPzLtLb5vmZLien
         k12nMxGV2UbxDLc2DCdfLxrTPmdCFrh8NNV+qsGOVBJ2cYfmoK2Xw8C7ne8cpje9sEvD
         IPHwYetoQoDbPSar+mwAWwUxlGBp7ATwvoHl/LV0SGJazlNlmQHUJavL2xWaVudkXVPd
         UrqQ==
X-Forwarded-Encrypted: i=1; AFNElJ8tT5180eUxGudoqtbDU3zkP3nVLwsRC1GelTuwRLXZY12U5r7v6Z8IDAcnIEa9VGQMYl/o16CpyA==@kvack.org
X-Gm-Message-State: AOJu0YxCGJf4/f7SP9kd5UV1Z2cz/T/hQoUESav4k4LgMOwf0dxeFUeK
	EAGJNZmyZ/4B01/Qh10RslgxWnDTxUo9CyR2uoE6j5sUWpvCl8d6zST9
X-Gm-Gg: AeBDievrIWEp10YUZrAXvZ8p6f4JQ27StqoT97Q6zIHA+KQ1ajhPLxvdCZzKgLjv4aE
	PlVROBdPO1yhetS+ND/FHFwmeepZwKYHAnz4Eeh3AZLtOB15mAKP+xQy2h6O3zis5+0n6Y7+ODQ
	HLV2+QFya+21ZM6o3NuDOGMjyG0SuNaVibqACzZ+vMk3EMvxSnqJ+hMKyroGjnVQsZDa276T2A4
	J6AWzmj3iiUlF5R6meAUpVxHqTHCOEHkz9WTQ6vZrUx5sG1n0c8EPTCJvqo/mAmsBQkaKwDn+WH
	LQtaijM0tJLZeQnl75nrpxgjyfnhzCUzV+9CBpHIyeX6r9gj8bdcQ8R2TCVKDH2yw3at/1POWcl
	m/EChiT8p15lP9YZahx2uWqbNRBT1hXMbjZfHklLLzfWLhGlXLgVEP8KT+229aTeVhQbH/3FhyQ
	TB9GKqGloHq5QYvqRaXXbpg2xKn7p6xSr1j1Vpr8aaHP0zJPuqUxlgnDwvoX7rAr4xnxawhi4r
X-Received: by 2002:a05:600c:a118:b0:488:ffad:6728 with SMTP id 5b1f17b1804b1-48a9865f342mr36104835e9.19.1777737459692;
        Sat, 02 May 2026 08:57:39 -0700 (PDT)
Received: from ST.. ([196.221.137.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb3427fsm228091245e9.0.2026.05.02.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 08:57:39 -0700 (PDT)
From: Mohamed Ayman <mohamedaymanworkspace@gmail.com>
To: Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-mm@kvack.org (open list:EXEC & BINFMT API, ELF),
	linux-kernel@vger.kernel.org (open list:SCHEDULER)
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Yiming Qian <yimingqian591@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE),
	linux-kernel@vger.kernel.org (open list:SCHEDULER)
Subject: [PATCH] futex: Drop CLONE_THREAD requirement for private default hash alloc
Date: Sat,  2 May 2026 18:57:29 +0300
Message-Id: <20260502155730.430232-1-mohamedaymanworkspace@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dj6dbfydy5baqy385on4jzh3ie16xtpi
X-Rspamd-Queue-Id: 8D356120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777737461-747434
X-HE-Meta: U2FsdGVkX18KQgfrW3EnFJszDfdeKs1gTByASMQneqNtcyqhV2OnzBVOLPn2Cg2FtZgE4cIoa1K/nAW3niKZWhdu0Rm9o2DyYFTXiePGK/zt65OLa7KCFwo44txnCTm95ub3LmBLauoEIjqiiYDnFMYYMK+EaOWD2GcLlvRt8jprItQV6Wh+zaL9MyUEWnmz3apC122euocnfRhNcPVtCtQES1WOfAJaweLYuWu9MpeL317FZOBg/HgIZyYXDVUPpd/R1oSklj01z7SUL18S0lWmmAZkHO5+TW79KQWlaxOPhcBD66nYBvoG0yq75Sf2BD8BkDKSNjMLBj6J4A/StUnAdAn3RvmLuQT/iGeBzrCUehM7vvDZbEyymwSMyjUNL/foayaDNA7YpfRZihCiVG9tY8Vtbjyt1LRmIx2lu3mQA9+RAKuF41QdGbPPT8AcRaSpMcal/GvgHGD/1tiE+3c3P8yg1A25lrrX48ueb+BhnlbGocMDVBRAYRNRQLsCt8gL2/2c1tFUSycA9F+Ops0bg7x4fCYTQqZJ16Q0d6fNR21KFAq0hD/ERO+Tkj6rw4MN3DwVm5q3Vg1gtgLyR4GEg+HNHL4aKkvglkiZcSeengQCoDlpmP/zlwLVbgmfvPzXSZzsjsZnkUM5AFatfeRJFl1OrdyOE+2H1Dl8KZgdYCcu1T6o7sWCFIBnA/fD1/zot4x1GMUUIc5nNWViz5muGGcdDJJjdem6LUHtXCBKz+xLlQ3adqq3xZ/q4bSXPDULWalRv1pFhdmcEywhyiK8l1bLdSBKcELaZUulZTdRORsrwzP8KAfoBdQQ/smEZc4MDoMCmnoJymJG3DxJxYfTTUOfUnUZdTdhRxF3M0HkqyahOAtzo02Bni7g8lg4/AZVO7oA6fOKVyfbN3TS7wS1sE2pKXjEdDGIfyOox58723L03n1ntQHUsb7Y9KRpEr6IgGRZKUhTiwunkrW
 cHkLWMCP
 en620JzAkquWUWv/rDqSDO6fj6Iy/LEanURjEwrm6crskIOXCOnCXTaB66kAkxpSIfBSkdm0FgdAwuMX0TAyHwE/yj8FivUn1SLggspoO104KxHkSmcVOqwrGegXuRqXM40a86dejXYqm8iipaOx7jviOfRoU7YHlwp7Vv2DcO1ryisU5HWWEQkO4n97U3fSeedF+vpfNN6ISQ3AG2fGxkC+KY5BFCnLUfguCooUAaxAxJxO/RqK3pIp+sENtIkaf057ZKNRKFSspSHGJ8tKZIOIVdmaI/5IAwXVCNgd2KfRWidEPbe/JRuIKZa6NyFIULbgB4aOBnwiv6kRrU407FD+XJRpoFOzBud7dfymRb6KpC7awePcENjzXCnaoYR4eh2URXHZhYTo5hNFR1D6EnG7eztZDi/n6lTIh7rctrbG+ZOUYTYIe3JvReSstVTAkzR7Ad/HKRflF7cCOCa1OaqPUaN3S5V3WYqNayIII63SEfuYwHQiGgESlYB7xUB8s6dyzz82+4h7E7jMbNcHdIus2V5EXoEfRJCTBT5kNJjpS8Qaksmgdeq7LL8ONcjycCRFC1etR4Wg0wWwucpP/T+mIfr8gUWZNv0/mpcmJ1CRPdMCpbJNMtnn6WPtYw0zwqjgOo8zMiMpfAoWOOgVv80ZXMfZiHLttSKOgcOQwo+fLKio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Davidlohr Bueso <dave@stgolabs.net>

Currently need_futex_hash_allocate_default() depends on strict pthread
semantics, abusing CLONE_THREAD.  This breaks the non-concurrency
assumptions when doing the mm->futex_ref pcpu allocations, leading to
bugs[0] when sharing the mm in other ways; ie:

    BUG: KASAN: slab-use-after-free in futex_hash_put

... where the +1 bias can end up on a percpu counter that mm->futex_ref
no longer points at.

Loosen the check to cover any CLONE_VM clone, except vfork().  Excluding
vfork keeps the existing paths untouched (no overhead), and we can't
race in the first place: either the parent is suspended and the child
runs alone, or mm->futex_ref is already allocated from an earlier
CLONE_VM.

Link: https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOkt9p2wwYQwAbMh=PifC=VsiBM6A@mail.gmail.com/ [0]
Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/fork.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f1ad69c6dc2d..5f3fdfdb14c7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1951,9 +1951,11 @@ static void rv_task_fork(struct task_struct *p)
 
 static bool need_futex_hash_allocate_default(u64 clone_flags)
 {
-	if ((clone_flags & (CLONE_THREAD | CLONE_VM)) != (CLONE_THREAD | CLONE_VM))
-		return false;
-	return true;
+	/*
+	 * Allocate a default futex hash for any sibling that will
+	 * share the parent's mm, except vfork.
+	 */
+	return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
 }
 
 /*
@@ -2380,10 +2382,6 @@ __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_cancel_cgroup;
 
-	/*
-	 * Allocate a default futex hash for the user process once the first
-	 * thread spawns.
-	 */
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-- 
2.34.1


