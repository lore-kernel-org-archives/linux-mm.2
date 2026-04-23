Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D31FDEE28
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE05B6B0088; Thu, 23 Apr 2026 19:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68426B008A; Thu, 23 Apr 2026 19:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A320A6B008C; Thu, 23 Apr 2026 19:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5346B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:22:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 076FA405E4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:22:47 +0000 (UTC)
X-FDA: 84691397574.13.D8D762D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2D971C0007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:22:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KVEZRzes;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776986565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qrl5DuY964r431GzzKhM3dUIK9ZIwCgWiRsK2oapjHI=;
	b=mae9yErsDnyJa5wGORw2ok9zeLBN4+LZZqx1lqhulOegOIkGpZo2AskNEdxbizfnJR4bt7
	LMWf+E47HUTBF6l7hgpsjCunLK8D3szicyA2dtvjpkeiEB6ouNAqq9fdZTFs/7uoMMMIsA
	DqFX5iFNBDGgYQwcWgECgPzamgwrT8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776986565; a=rsa-sha256;
	cv=none;
	b=sWyqohVvAIXDoHvIsan9ynH4HAogkramqgL+UO6ce6TUF/0qkIHX2lbunifJpzPxu8e7yk
	BpuI9x0juTOwTg1OT1EamdgSJuwkA1n5E81DlxPsHLYLpnNkUCVNIRe3uUk+qLHogH5XzD
	agdkAFATX/TE11PPzVxBgCmJqAU+cgo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KVEZRzes;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4716261119
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BFBC2BCC6
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776986563;
	bh=xC1cM4/xWo02JuXQUTbedXabMRfxquPFymsW2iEQgfk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KVEZRzesKn+Nd2QkcpKDycKSdOmE/9FtHb0enMYwVDznPocvf3Kg8ZNW36i9hV00+
	 PI6+v1DOBp080LxU/ceTfpG1mbqhWsgKDxOXRR2vIfLNtNA00vn3vVzVaQhNjWZYxf
	 ZH+NOqkd5tbK/ZRHig2SIfP4x++JkJ7/4cTpp1HSzkU5vSFsIXHXy94jfQoMgkmqQf
	 W30glHLI5svmJWTbJADZJ+hWoTevo7RKd7DK6p8ef4AN8m9MlILq4C2YnmwFL51uk9
	 qjiqZqI4Tfon22VQWCS7ZSC27+SX5aRrDkM1OaFsJIKNwxeC1qERNdTGLB22J959zs
	 pPdCh+JSXr1wg==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8aca4e14411so87866576d6.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:22:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YymmHe1QWdqHZPLGzsZLtDdkyyodgmtg3iMYX0wz9Wd7hfW6zAk
	H2WoO6okb04acQ5g8pOJRokHBaTXfEmKKuRfVf0pceiAMXIOH3YavhcnByUNORqsIyqcxLGYzZJ
	eRPL4Y4nRAomLMPmFr/D6SiRyHr/QsBw=
X-Received: by 2002:a05:6214:c23:b0:89c:4e50:1921 with SMTP id
 6a1803df08f44-8b0280cc080mr466214036d6.26.1776986562964; Thu, 23 Apr 2026
 16:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
In-Reply-To: <20260423164307.29805-1-jp.kobryn@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Apr 2026 07:22:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
X-Gm-Features: AQROBzC7H4sAIHXGtYrwHb2kohpLs_eyTnnCFoFAVjwVmr6SKP4U6FmT6Vy9fJA
Message-ID: <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add drain
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org, 
	mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, riel@surriel.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3depxjqcpc498p3wkcagmias1r74t73o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D971C0007
X-Rspam-User: 
X-HE-Tag: 1776986565-861378
X-HE-Meta: U2FsdGVkX19XDikGNp78ZzihtLUpr1sbeL16XG31kkzq6belycYec09WGRvP6crRywliJ7HvEWlEcLYcOl0Mrc050So01KQEo9YUJ+zSg5d4sgJC1yFHmYWEnXyeZYJx3AI7GRRezb/y8Kzb2U4g0YbYZxt9RAJcA/HJibN8I1+MWZ0zaRObMtBq5Jr6MENWj6h6w/FtimGCwV1RdbvNlLX+D9M5FnETyHpr7sURvzSkyYxEEiwSnm57v70u570+PReer2Diz+VHq+BAxs1eWvtTGJvJ3lESf6jkfiLoyDTXuKii6GYJg0s4OzN6YoytfI5BR5TQjDHDABnJdApd26X0SVXjKgcTwQThV1bktafdm2lSk5hzk3glNIf8W5KP8wEYM+o3Nq0qBCMxb+Gt8ZVQJtyJDTsW26nR5ACY0HnzDJo+CnTZoGAH7juY+0odc2hm5TJ9adc0pea3FRpiLQ7U/snaEP6O6mp4rTMfSdpMHHMBSJyPfylAOvzfg0XEkxw2Xjawddgf7LpK9jeDoQyoFVdtDK82S4Kz+iBg4gBqKxx608kLkYWgnqaybe0fxULL0XNTttD0uFNbB2Xo59q42ry5kpEGrCErftTZrw8YfRdAnJ+sEKiUxvxSwZoAFXgpA/6iabi+c2kYkc3ozPuXkth9D4fRTrdmPG08BbRjriwHflVxnyY5pf/NwPBAOF456Av+/Hcj3IQAYJh8iJefzdzd5hyaGAO4OPD2oJMktWMNLXhbk8YzFKbtsQEVKhRE1JEKrSnerm2KGKHDvX2cJPjBHdhLNGHqFq6ZfLUWfRF/LSoUQGwE2Z1h8+q0wVD8gSPYz7RulZQ3AJwN6mrbnxfQp21SIUU7tUoldhzmo54j4SjEYPfACbldgwUGZPwVHgw42yHvs4zTIHWEAAQiyRohm2INHRytShov9cW9Xxz+REHcYW+IxbT04rSNifyskIaRQFdrysBhfrb
 ra05H2gh
 v+WgkEo6KqWxSZaw6sCP1OJxhK1UcI0GhYCSxBr1IEY+qnBG+ywq/Xk76I6QcB7+F+oI/zMS06Cbb+rob8rWTHqt5BGFzLgAc1z5nDNMYPSU5wiWmib6j5vj2n5EURZRm4ZtIPVuUCsPaIW6miEHBrw1l6Dpj/1MWhl5+gP41LyJ1QoiWLRmMCMEY+Wsu9/gifVlFMEDKLfy0e9oJiOg5tfTKXqOPzsMSxHnhCYs+qYLeZY1NrrB14OLvJP10cx+TCsDdYj1EUgwmmzqkMDF7TkwqDZnLK5h68TRUzZH9AnN983x4Z95QUTsrCID0WBdR0MV82Wlwa697PpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:43=E2=80=AFAM JP Kobryn (Meta) <jp.kobryn@linux.=
dev> wrote:
>
> Of all observable lruvec lock contention in our fleet, we find that ~24%
> occurs when dead folios are present in lru_add batches at drain time. Thi=
s
> is wasteful in the sense that the folio is added to the LRU just to be
> immediately removed via folios_put_refs(), incurring two unnecessary lock
> acquisitions.
>
> Eliminate this overhead by preemptively cleaning up dead folios before th=
ey
> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> remaining refcount is the batch ref. When dead folios are found, move the=
m
> off the add batch and onto a temporary batch to be freed.
>
> During A/B testing on one of our prod instagram workloads (high-frequency
> short-lived requests), the patch intercepted almost all dead folios befor=
e
> they entered the LRU. Data collected using the mm_lru_insertion tracepoin=
t
> shows the effectiveness of the patch:
>
> Per-host LRU add averages at 95% CPU load
> (60 hosts each side, 3 x 60s intervals)
>
>             dead folios/min  total folios/min   dead %
> unpatched:        1,297,785        19,341,986  6.7097%
> patched:                 14        19,039,996  0.0001%
>
> Within this workload, we save ~2.6M lock acquisitions per minute per host
> as a result.
>
> System-wide memory stats improved on the patched side also at 95% CPU loa=
d:
>  - direct reclaim scanning reduced 7%
>  - allocation stalls reduced 5.2%
>  - compaction stalls reduced 12.3%
>  - page frees reduced 4.9%
>
> No regressions were observed in requests served per second or request tai=
l
> latency (p99). Both metrics showed directional improvement at higher CPU
> utilization (comparing 85% to 95%).
>
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Hi JP,
I=E2=80=99m seeing a large number of "BAD page" bugs.
Not sure if it=E2=80=99s related, but reverting this patch
seems to fix the issue.

[ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
[ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
index:0x724884c20 pfn:0x3a5417
[ 2869.365983] flags:
0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=3D0|zone=3D2|lastc=
pupid=3D0x1fffff)
[ 2869.365985] raw: 0017ffffc0020908 0000000000000000 dead000000000122
0000000000000000
[ 2869.365986] raw: 0000000724884c20 0000000000000000 00000000ffffffff
0000000000000000
[ 2869.365986] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[ 2869.366037] CPU: 11 UID: 0 PID: 179413 Comm: uname Tainted: G S  B
             7.0.0mglruswappiness+ #401 PREEMPT(full)
[ 2869.366039] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE
[ 2869.366039] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H470D4-P1, BIOS P2.00 04/01/2021
[ 2869.366040] Call Trace:
[ 2869.366041]  <TASK>
[ 2869.366041]  dump_stack_lvl+0x76/0xa0
[ 2869.366043]  dump_stack+0x10/0x20
[ 2869.366044]  bad_page+0x79/0x120
[ 2869.366046]  free_unref_folios+0x85b/0x960
[ 2869.366048]  ? __pfx_lru_add+0x10/0x10
[ 2869.366049]  folio_batch_move_lru+0x260/0x2d0
[ 2869.366051]  __folio_batch_add_and_move+0x7f/0x110
[ 2869.366052]  folio_add_lru+0x49/0x60
[ 2869.366053]  folio_add_lru_vma+0x7b/0xb0
[ 2869.366054]  map_anon_folio_pte_nopf+0xb8/0x170
[ 2869.366055]  do_anonymous_page+0x5fa/0x960
[ 2869.366056]  ? __pte_offset_map+0x1c/0x140
[ 2869.366058]  __handle_mm_fault+0xbb6/0x1010
[ 2869.366059]  ? mt_find+0xe8/0x560
[ 2869.366061]  handle_mm_fault+0x1b0/0x370
[ 2869.366063]  do_user_addr_fault+0x2c8/0x870
[ 2869.366064]  exc_page_fault+0x7d/0x1d0
[ 2869.366065]  asm_exc_page_fault+0x27/0x30
[ 2869.366066] RIP: 0010:rep_movs_alternative+0x11/0x90
[ 2869.366068] Code: c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 90 90 90
90 90 90 90 90 90 90 90 90 48 83 f9 40 73 44 83 f9 08 73 25 85 c9 74
0f 8a 06 <88> 07 48 ff c7 48 ff c6 48 ff c9 75 f1 c3 cc cc cc cc 66 66
2e 0f
[ 2869.366069] RSP: 0018:ffffccb46a837a78 EFLAGS: 00050202
[ 2869.366070] RAX: 0000000000000078 RBX: 00007ffee44638d0 RCX: 00000000000=
00007
[ 2869.366071] RDX: 0000000000000000 RSI: ffffffff8d0d1d90 RDI: 00007ffee44=
638c9
[ 2869.366072] RBP: ffffccb46a837a80 R08: 00007ffffffff000 R09: 00000000000=
00000
[ 2869.366072] R10: ffff8c7769873600 R11: 0000000000000000 R12: ffff8c77865=
63800
[ 2869.366073] R13: ffff8c76c6668480 R14: ffff8c76cfe3ba40 R15: ffff8c770f4=
19c00
[ 2869.366074]  ? arch_align_stack+0x3f/0x60
[ 2869.366076]  ? _copy_to_user+0x31/0x60
[ 2869.366078]  load_elf_binary+0xda1/0x1800
[ 2869.366080]  bprm_execve+0x2d7/0x590
[ 2869.366083]  do_execveat_common.isra.0+0x15c/0x1c0
[ 2869.366084]  __x64_sys_execve+0x3e/0x70
[ 2869.366085]  x64_sys_call+0xd91/0x26e0
[ 2869.366087]  do_syscall_64+0xe7/0x560
[ 2869.366088]  ? folio_add_lru+0x49/0x60
[ 2869.366089]  ? folio_add_lru_vma+0x7b/0xb0
[ 2869.366090]  ? set_ptes.isra.0+0x3b/0x90
[ 2869.366091]  ? do_wp_page+0x85d/0xed0
[ 2869.366092]  ? __handle_mm_fault+0xafe/0x1010
[ 2869.366094]  ? do_sigaction+0x165/0x4c0
[ 2869.366096]  ? _copy_to_user+0x31/0x60
[ 2869.366098]  ? __x64_sys_rt_sigaction+0xb7/0x110
[ 2869.366100]  ? x64_sys_call+0x880/0x26e0
[ 2869.366101]  ? do_syscall_64+0x11b/0x560
[ 2869.366102]  ? do_syscall_64+0x9c/0x560
[ 2869.366103]  ? clear_bhb_loop+0x30/0x80
[ 2869.366104]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Thanks
Barry

