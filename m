Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95176FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65DC6B0005; Fri, 24 Apr 2026 15:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16E66B008A; Fri, 24 Apr 2026 15:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55DE6B0092; Fri, 24 Apr 2026 15:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C59506B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:15:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E4E41C0139
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:23 +0000 (UTC)
X-FDA: 84694402926.16.1AEEA78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8797DC0014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqMFc8Um;
	spf=pass (imf28.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PR4QGlHov9amBKeqa5ZNXFME/qGJlG+ZZv/2bCOXjYA=;
	b=wqMqPeUBu04znItXRfwF9o3NYL9anVHHDfqObOT21+jg3uTfqDSQUPeQ5X90TBXB0hxEGr
	AwkrTvNkFVSWiZmGjd8kG1Z6dfDCuB3b3LLg4j/wFqKUIRU/HVflagp/tXcCSqrWzh/8Bm
	brM2Fw0zAjxvkAAT4V1I7C4jO/Inu9w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqMFc8Um;
	spf=pass (imf28.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058121; a=rsa-sha256;
	cv=none;
	b=q9g3MBvYwmf34uOCGCHAbkYQhsiZ3VfwJ1Akk8kHjKxI86GYWd0Zgp3q86cQyTTsVy+iD8
	fMIyV1JK7NbNSup798HMFiwRIl138nJUqBQ3zOgfva6kjRME1JCGIk1e7lz4RpZY6ADoTh
	1uElkikSLHKtfY18olGvIVbN27ZN+Js=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDF7D600AE;
	Fri, 24 Apr 2026 19:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC6DC19425;
	Fri, 24 Apr 2026 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058120;
	bh=elAiMYYB8thnLDPWGWuzFWDG9U2HmB7k3ICkW3UnRss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqMFc8Ummu0HNQYO0qnqYhFMafW5AXr1X1GDRJ7ovxKkZyWFWtJKmS2mWc4jHDW1D
	 YLptaVzHms+E8S11zRFdecHEn7H4PsyF+GZxHXAuTuBCxSL8ALxMUlrQUu0QUPLFIJ
	 jF3AQsgzAKV9C6siKoTwRRxC0xQKhVVbkyYvp61FIZ5L2sOLM9vXGxvV8i0M9jLU+H
	 G6T1uQjLRLF8ciQ+VDJgJtttVdDtWSV2OmIo0IAtFVvBu3WxAh5Sc0w60jiqnE8OGb
	 sYgZ1Aca5NVmjdLZGq2HdClqASNSDiJM40TcOLWWW/594ed2rJ54G70Ga59yuNZvlw
	 Pkhr4HzGB/jnA==
Date: Fri, 24 Apr 2026 12:15:18 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <aevBRh08X4UTMUj9@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8797DC0014
X-Rspam-User: 
X-Stat-Signature: 7ugz715dfwz7no5pw5dhzcmookqs5epd
X-HE-Tag: 1777058121-800673
X-HE-Meta: U2FsdGVkX19O8MRADM5nfQ/6Q2QHhgWgly7G7cTVLw/gh0r0ImGA39CG3TduGQgyONNWlLQNVXQimPyGIdnJWjXzxDxLxuZAz21KSudR8lhuDyW9yetDqOcZFsxrULN6Zu5XUJEKTNRSW7rxX45MIf71erFx2A7EKqEOLSvt7k+HskvG4drZ51oLukVR7tVHxObiB4/Ji6vQqw/kbtwT5TdYNvsW4XCbjLaVF5jzoyuSL32CsAIzSkzl23+JKXLdpxZF3N2yexP489wYR8rHfiqmkq4RIDquijWdt9wvai3Mc1LtTfxk0x+D5vEIhv8Wrg45aoZXZUr1WIkFVYFaq1B4i0xrSexJgllHJmipVbIQjOls2n4LKgqJT3rEApznHqgv2GHuCd7SeoZBP44YtKffPjEXCotE8vmwaU0ndHU0wrheouYJC37xOBwkrIgWVKk+9hVlov1A7Jr/aPqqpjQR2L2PF9h+lMluGKMn76CIeEOJIrluy/cKY7YIRshLiZcjPpYNsfeoIfkdDl2I26aQrybuvVW9iH9lvWLh/i9BXp7+tVRRfbEuY586Mx9j80H35v3KPKMLlstisG5XKYHOaGZuRWqyGKWb6akWqP+G6d5+usPbS/Pql7iW0Eerj78N16bstNcQaSjeawFMpdopd5OPKjIxuGpAcriqsWNagvhD4SaBlE31kd9KBoJtqMDYgrVm2KG8EMe+7LANps/DFwCoi9fAwH546PUq6Vw9nCU2W7WsKL/g0yuituIAhD4nhDqTuh4QZj5Q+LILEx7lrvoKJYM1Sws4rlVGPxWPhI8Lp0Z0kXGuGgovI+27TbVmsif9W2ta7P44o2VtMjscQ8K/2dV5YTCCIVojRqiVhrhGhByjzG5w8QS0EgRvQUiO33ZTBlPUF3tBkn/8zKZfJLl8PMiXqzwHlhm3BqAPrm2qqy/6Hhjl5esQvqSviJf7KvgyvpSQ393lxFi
 p2ChlVMc
 zm+9T69oeCSDi9PmaevOFkvz/48YQ+R2CzdvTgV+flgindcyIgVE026mfhjlmt2CKfhDcQYieCommQt1/CM+vydPKZQdspOp7cOJf9b+1GAonQVtvm+Szgc/7lEUQ6wuxY/XJZtXqKJvIZXWq2qarE9I5hW6QhaMhHyWMrGunGFZBsjW61jd6WrPkt8fDuFbsEyoL9I/ljtQ67OlHF+YXZfsJ+H2ZmE6bAz4+ClwxBfgMI6fiowCwzbjRdvPP3WR7VRJxWIpfvaOxezH6M1TRbrlbhV0wBhINE6P+jOdw4yTeMS6EDQ/0kvpnnj8CIoYWcfg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> On 4/24/26 09:51, Michal Hocko wrote:
> > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> >> For the process_mrelease reclaim, skip LRU handling for exclusive
> >> file-backed folios since they will be freed soon so pointless
> >> to move around in the LRU.
> >>
> >> This avoids costly LRU movement which accounts for a significant portion
> >> of the time during unmap_page_range.
> >>
> >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> >>      exit_mm
> >>      __mmput
> >>      exit_mmap
> >>      unmap_vmas
> >>    - unmap_page_range
> >>       - 55.75% folio_mark_accessed
> >>          + 48.79% __folio_batch_add_and_move
> >>            4.23% workingset_activation
> >>       + 12.94% folio_remove_rmap_ptes
> >>       + 9.86% page_table_check_clear
> >>       + 3.34% tlb_flush_mmu
> >>         1.06% __page_table_check_pte_clear
> >>
> >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > 
> > As pointed out in the previous version of the patch. I really dislike
> > this to be mrelease or OOM specific. Behavior. You do not explain why
> > this needs to be this way, except for the performance reasons. My main
> > question is still unanswered (and NAK before this is sorted out). Why
> > this cannot be applied in general for _any_ exiting task. As you argue
> > the memory will just likely go away so why to bother?
> 
> I think there was a lengthy discussion involving Johannes from a previous series.
> 
> That should be linked here indeed.

How about this?

    mm: process_mrelease: skip LRU movement for exclusive file folios

    During process_mrelease() or OOM reaping, unmapping file-backed folios
    spends a significant portion of CPU time in folio_mark_accessed() to
    maintain accurate LRU state (~55% of unmap time as shown in the profile
    below).

    This patch skips LRU handling for exclusive file-backed folios during
    such emergency memory reclaim.

    One might ask why this optimization shouldn't be applied to any exiting
    task in general. The reason is that for a normal, orderly exit or just
    pure kill, it is worth paying the CPU cost to preserve the active state
    of clean file folios in case they are reused soon. Preserving cache hits
    is beneficial for overall system performance.

    However, process_mrelease() and OOM reaping are emergency operations
    triggered under extreme memory pressure. In these scenarios, the highest
    priority is to recover memory as quickly as possible to avoid further
    kills or system jank. Spending half of the unmap time on LRU maintenance
    for pages belonging to a victim process is a bad trade-off. If speeding up
    the victim's reclaim by avoiding LRU movement and evicting cache negatively
    affects the workflow (due to immediate restart), it implies a sub-optimal
    kill target selection by the userspace policy (e.g., LMKD), rather than
    a problem in this expedited APIs.

    Therefore, we choose to prioritize immediate CPU savings and faster
    memory recovery over potential future cache hits for the specific victim's
    files.

    Profile showing the overhead of folio_mark_accessed during unmap:

    -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
         exit_mm
         __mmput
         exit_mmap
         unmap_vmas
       - unmap_page_range
          - 55.75% folio_mark_accessed
             + 48.79% __folio_batch_add_and_move
               4.23% workingset_activation
          + 12.94% folio_remove_rmap_ptes
          + 9.86% page_table_check_clear
          + 3.34% tlb_flush_mmu
            1.06% __page_table_check_pte_clear

    Signed-off-by: Minchan Kim <minchan@kernel.org>

