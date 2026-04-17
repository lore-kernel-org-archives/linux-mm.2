Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C3AF8E49B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357436B0088; Thu, 16 Apr 2026 21:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E366B008A; Thu, 16 Apr 2026 21:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B6D6B008C; Thu, 16 Apr 2026 21:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150C46B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:16:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95CF2BC64E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:16:21 +0000 (UTC)
X-FDA: 84666282162.03.536F70F
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7204A000C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:16:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2vwZOzA;
	spf=pass (imf25.hostedemail.com: domain of gality369@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=gality369@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=asg74WJhLQYJ7UIfGwSHS141GuqqTNXs+jX/zqQ3Kx4=;
	b=QwV08wYslTOy6zaUgjRZdMVyfvuGKwKPDg0AG+NHyW7KOdobQvykC/vXQ9JHRt3KtuMYB+
	BPOm10YaUv2AMXf6/O8TdSYJBpZiUhydnOcZ4yFHCa7eySuTGdlaZpNTLuE37xNkpfjbRD
	kaVSUA51m7Ex7eHVd72s4/LKWJ9t3lY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2vwZOzA;
	spf=pass (imf25.hostedemail.com: domain of gality369@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=gality369@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388579; a=rsa-sha256;
	cv=none;
	b=lb6/btkHg960sEHLVVbfoLCAtxDcCU3uHtCnru8b3y9FBTHUqR2onOy+tIYr6j2VeTRHUI
	ZAvAkPXxZILN1Q6nZeMf9DUyMeie14eXziU4PHAZgAaoM/WUClcWdQ1QLEBULTYuUo44ta
	YwxXelA4IkBjSQlNIzw5SAxLlggf1Fo=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35fb16e56efso110655a91.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776388579; x=1776993379; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=asg74WJhLQYJ7UIfGwSHS141GuqqTNXs+jX/zqQ3Kx4=;
        b=r2vwZOzA/pdGvgI2Vl9Lf39cBPmtGasotKBtqc9eiyRdRkwTgXaX2hFebqBytAXZkR
         Nkd1zabMp6KEF99xftatFkDIOWFltvHo+cah66lSR5FEXKKecX6HFFNY07l3GfawMmNH
         KJugkserfofp3JODDixhfcK8NXB/48cbGxifcLPfcIO01s9qaRdfEoBGU7q3Ilmooiwf
         0fPHKNH1ehDHNthkwRtqbIqYWcd0UKDu4KINqeaI44Kbj8FiZL4k2KeNXzY4IV/SrRDl
         MkzoOo4MHjwkb/nSUVjEzwDMSeaJwQ49W6QXOehX4A2E4qHNSaKhC0KlKxScRnR3bUkz
         qGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776388579; x=1776993379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asg74WJhLQYJ7UIfGwSHS141GuqqTNXs+jX/zqQ3Kx4=;
        b=JubD9EJ8NKyfPOeBTREE9KUs9a3P5u6DdRAzfYLlEwG/WVRmMXEHS+WUWuLQoPZHIu
         9usj/yNWUvBuT/9gThcJ3vAUu3XGPpOXMT7fae8Piqjsl0qZeCY5fnA8lpsBBeepzlqb
         mnLhmq8DiijqNyENtpSFhImZaY2lPxyzzx4qcskf3PoELj3xuaijwq4YA7Shsr0yLP0P
         br8L5A3m5P8J/9b+zIs2Wi2JR+1/eL7pOaKpm2NX54cGvgcziFj5lNKMH7qE+0AvpwRR
         CUy75qJ5Nskl10zhVYaodvv7u2SybqvHDkCMtJBUep4t802wHqQ3t+Y+bdZEIv+LQ7rU
         YU5w==
X-Gm-Message-State: AOJu0YzoZJFvIaF49D931xaaErVFiNjNhIwqXqyY3KSlCb/P5y5EWodM
	Yj8AvGng/6od5uW+5tGIcACsuugizy/jRrvFTj3xM/wMvbiIpKsLdDMT
X-Gm-Gg: AeBDietzc11Q1bIUwqRbloCs+eIEQba2QglSujJwGEazHEQQuKXCN14JQaklwM6EnUU
	kiyRi2AOxOE7A4WMyDM89sHhU+cwZKQ+/PQ3gZhvz3JHkwfi3AfdDZ5V3Igj29tKKlxP/BriBpf
	apH7b5GWXdBq5Mo/mKyczxTcRa5LfdpBg7TZAwzF2mMo6MYhjPFP0ulVZcf29VmKaVHxGgYOkEy
	EvA6pLu8uOoGt19DQaDa9fwB/HevoOvJh1XpLXDBRQ9v3jfGAmgLQYVt4cCJTyzMyZuldGq1vKA
	eBtU3vPVpK+DMoMYTeg0es2pkdxO0IzB0RvzAbErZPMiTnSs55HrPCZ28EZlC/M8Pa55n94Dc58
	DqoCMpmOqv6BbI0Zb9nerG7PHbdoezvyuRt6lyd85LKBNYBFqB9DPPFxjQm0qbHuMcZJv3Ndi+5
	J/szNiLq9kGiXOb7LmwbEN8CzZtc9N+R4TcjFRpUGXTDT+9oGofhbsLGoo3xjlQdAIOgie6Lqqc
	nxV2ETH7g==
X-Received: by 2002:a17:90b:5583:b0:35b:8d89:7199 with SMTP id 98e67ed59e1d1-36140468a44mr642291a91.15.1776388578362;
        Thu, 16 Apr 2026 18:16:18 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36141990bb6sm87274a91.17.2026.04.16.18.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:16:17 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] mm: prepare anon_vma before swapin rmap
Date: Fri, 17 Apr 2026 09:16:06 +0800
Message-ID: <20260417011606.1089985-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7204A000C
X-Stat-Signature: wqmd1wwd7qs17iwxu1daoxpma3a7uzc9
X-Rspam-User: 
X-HE-Tag: 1776388579-75791
X-HE-Meta: U2FsdGVkX1+iML17d0PEi7dU/XuDd+HQBIGckO8ehF+0gPlWjyLNWvHa7bX0j7FeTLLcsluZGPXUx8qUtRNMqgKwD1M01QCcmSOrB4hAvdtx5ZjaZyBoubMa/P6weLmGCN5v7t3msXaZ9Y7AkGIDa5KcsHJweAQLC1VqgyJ9RilH0okxLtXOsAnTyTMlADBPVk9+1fxnm6NS5vw2gUiHvDiFekCEKPr38ZEMaU1RfBas08/8Y9r8PmIMVH+iBDUkdi8gQHnJFFIuvQKuwsmnwVM9M++sqlJgYV2QFOgm7RePcMM5vdeCMt/WczbA2MIbN+EWZiEVAUzpa/v7cRbWXGtxfKDvkAhIHCv49fAh6vsukHUBMzBRGuwzGsi4x+UnS8nwVNQ7PSrdbNJjbcD8zHsbArAUsMxeZstLXktXMAlNZfUBraO9HjMZXpF7BMhYQa7JYEX/yQYljZV23Bbx7kXYwGvnl9Iq6sPeYvhthIhS2m66+5CKLWJvV3cKnRGOAkgKUKrjBhYOqW5zY9NrYO3ukdltSd0SecCnjffYjuhhav82DyQQpsYFxlQyz/0DRg0XFyc6cMMeJD0mULf7nAVBus1m7ONfKzBfiisnQIw7k6Z3O1Dcn7/z6aPNMot6Xody7B2notXvxJm67BzIIDDGCCnc6PJS4Yl3VN0GCzDOpr5B8NnDE/4P4rpF4WNylWVy92Ejymbb46l9S2lqgHoVRK6E1lw7bbFsbxxReaJwScdcVq9jiRB4uMAsi2RFZCX0KuPSEWkz9+kfTYD2pmRmDlcPda/CLmZFsUZsWqW2tN7YjyFDOreJzKMW+3UjYJAKcwh3iCLpLjUasv/wAfgyI2xEoWWvqMSL+unb7uuF9vfGDDSVOhq3qaUbNXm+6odGn8h2v8WXnQ+7FMfLr1l8DY6yuexIm+7/PjeGzhdVO3lnpxDo2Vrd1IYMry13bKd+p1ffXxwG/4frMlW
 +y29/LoF
 j7MQwL2VAyyWHw6qyGuT8vgv9kVWi6rpMRrCAUcXo2umR7AjtLLXpJnlXPjofbkt0ArOooufun3tpTwS6oLOhxuM1UppKM938o1eNnygq4Zwd545Nb41NX78Kc/J/Kg6FMEQsWKF+9K/IWDSAo0qhN0noAtpnZxZZ7xIqR7N/5x59r2RSxookEjnDC3J5ixRfEsFXBxiIrAsRSzki4g6B8XFqT1NWrb4Q4lfgmXXGbAbe+OCUckRBsTjGMs31e8oTdFS+sakC4F0EEgVoiuYid5NDmOFaVlvYGCQvy2X4gPIGVMpdTQ7Ti4RHAB09B/SiaZpltGqV/GQvJ4C9QZ10cPOXQ7oB5HAzSTBimta1QciGZH99vSfAf16d/byidPTcOTj/PBYa/uRzhIQ+r3NzKqmf7RK4JlX2kicBpXxyH16mIRCi4YSjj4UEtwMj6m2CP52wXYA0lK98PnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[BUG]
madvise(MADV_HWPOISON) can fault a swap entry back in through
get_user_pages_fast() and hit:

kernel BUG at mm/rmap.c:1364!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:__folio_set_anon mm/rmap.c:1364 [inline]
RIP: 0010:folio_add_new_anon_rmap+0x41d/0xc10 mm/rmap.c:1553
Call Trace:
 do_swap_page+0x14c5/0x5c30 mm/memory.c:4963
 handle_pte_fault mm/memory.c:6198 [inline]
 __handle_mm_fault+0x1512/0x22f0 mm/memory.c:6336
 handle_mm_fault+0x42f/0x820 mm/memory.c:6505
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x4b3/0x3400 mm/gup.c:1428
 __get_user_pages_locked mm/gup.c:1692 [inline]
 __gup_longterm_locked+0x945/0x14b0 mm/gup.c:2476
 gup_fast_fallback+0x8a3/0x2440 mm/gup.c:3220
 get_user_pages_fast+0x64/0xb0 mm/gup.c:3298
 madvise_inject_error mm/madvise.c:1456 [inline]
 madvise_do_behavior+0x503/0x860 mm/madvise.c:1875
 do_madvise+0x17e/0x210 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xae/0x120 mm/madvise.c:1985
 ...

[CAUSE]
Commit a373baed5a9d ("mm: delay the check for a NULL anon_vma") moved
anon_vma preparation out of the generic fault path and into the fault
handlers that actually need to install anonymous rmap state.

do_swap_page() was left behind. It can still restore anonymous mappings
via folio_add_new_anon_rmap() or folio_add_anon_rmap_ptes(), but it does
not call vmf_anon_prepare() first. On a VMA-lock fault this can leave
vma->anon_vma NULL all the way down to __folio_set_anon(), which BUG_ONs
on that violated invariant.

[FIX]
Prepare the faulting VMA's anon_vma once do_swap_page() has confirmed it
is handling a real swap entry, before any swapin path can install
anonymous rmap state.

vmf_anon_prepare() already handles the retry rules for VMA-lock faults,
and when anon_vma is already present this stays a single likely branch in
the swap fault hot path.

Fixes: a373baed5a9d ("mm: delay the check for a NULL anon_vma")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
I can reproduce this issue deterministically on v6.18, but I have not
been able to reproduce it with the same setup on next-20260415.

However, I have not identified a change that clearly explains the
difference. From code inspection, do_swap_page() still appears able to
reach folio_add_new_anon_rmap()/folio_add_anon_rmap_ptes() without a
prior vmf_anon_prepare(), while __folio_set_anon() still BUG_ONs if
vma->anon_vma is NULL. So although I could not reproduce the issue on
next-20260415, I also could not confirm that it has been fixed there.
Recent changes around the swap fault path may have affected the
reproduction conditions, but I may also be missing another relevant
change.
---
mm/memory.c | 5 +++++
1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..a64bc9826cc5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4850,6 +4850,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 	}
 
+	/* Swapin installs anonymous rmap state into the faulting VMA. */
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		goto out;
+
 	/* Prevent swapoff from happening to us. */
 	si = get_swap_device(entry);
 	if (unlikely(!si))
-- 
2.49.0

