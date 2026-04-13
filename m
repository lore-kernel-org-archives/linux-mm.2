Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453ACEBFD08
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD176B0089; Mon, 13 Apr 2026 03:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5869B6B008A; Mon, 13 Apr 2026 03:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E836B0092; Mon, 13 Apr 2026 03:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 310466B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:33:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04CF4E422D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:33:30 +0000 (UTC)
X-FDA: 84652717422.10.DE90C00
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95D9E40003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:33:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776065609; a=rsa-sha256;
	cv=none;
	b=lXmYJuPTeP6txcJjWGWO12mFjX6k2YtzkfKagxBvH9QMKXgaYxBj3q0NzOaBGCkbHI8d8p
	GEMxbcvdB3r9aywNz13PBuBqUl/BE/duRlBLTVbCbrZXAsPdCPCCUd0+SLYOqM9t7fLn0v
	hap1kQ9NjZpyai0O3MNw7UgsAGu7+KI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776065609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voBaRtONobUaLtIrPR+qQxAuLy+mfQeQJgyYCCRKQ2c=;
	b=uEaYNcvDnnBJC7ESetNC1wdVtp/6wUHDuOCJIc25559tS/1TZHamsbuOu9OcRN566+Ntwo
	05UDgemldSA4Yf2I/BKdRrcooMB7bGEPBPZw7DhYxcRiR/a39rbi07QF1gJoW/4XxvpWgt
	p8YuMM6hPHBorstsQO/lAcy52dN4Ods=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Apr 2026 16:33:25 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 13 Apr 2026 16:33:25 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chuanhua Han <hanchuanhua@oppo.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] mm, swap: fix swapin race that causes inaccurate
 memcg accounting
Message-ID: <adycRemx6QmSOX8n@yjaykim-PowerEdge-T330>
References: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95D9E40003
X-Stat-Signature: sukdizrw5bzt9rcfcaxbddz8tbswz5wb
X-Rspam-User: 
X-HE-Tag: 1776065608-597758
X-HE-Meta: U2FsdGVkX182iWFSQCxt/4YRfqJwMo54r0h33+F9zjPJu0u4hF69vm/281zc83gkja9T3kqVC+uX60h0Zpo4cnqg/upr/eK8t9AVKewu5hfX6ouC/SDh9kThGsfDx20LxPefVYORrF+JkwqR5MkdjpxeYcn5Zm7EsbNePuyP+1NX5dOsDH9yvDnwQhLrr9jdAfZrKdCSnXNSiuZpkx/zGOp5AOLFQ0uwDr5qcs9rbhK+mUPxZI4h6VmLmmuflReLWubyHnZNZn+sRblMWwRcWrQo1e8cV1VviIOC7Cuzmg5WAV09tAAiylz5Z8DlJ4sEYWALx488noFwxz40g9v3xyhGI0Ea+wUJCRLDA/P4UTvgsSXj2QZx9xFlq05zU0u+ks0MMSIhT0vdbVJsfzuv26O8Sb46IL9Pjur4DSFaH9OaI16KIFUfkOXgc+iZZ3YB9mWukJI3AaTFtElnq9HK3gz4VzWhzfFzH0dLr8R4UDAip0ea2XQF1Bamt1cK4PvCp2iLYwYTKVSXvqG9XzoQ7ev84bzYIWd9mLDCY91GwEIt26wFysxBrFw0ECWu5nUuRDFrKo5ZJSs+5JYyhvP6nzlYRq5PhrQQgEZ+xanctMgiyku4ZMAq6vCsYApknKD8WMa8k2YrKnjps+3W2yZREg7LDDktMBVshRTWs6QfI5d40UcI4xRWnZu6rtXy5HvEUkFAgTWvL81ZmoD79S6XSckGofjGCm/G7u2X8gzo3kRU7r4NsObsIVP77XRNxvWhuUdlEJQ358ThfHKSELQGy/PdZnYmYn7KYaB93nYCUFnmK8WhvO8S9KgCwu8j32jw6/sLSCEwthso7yipbuRtfgKspF5aT3gYNx7lVtOvuB2B0W4nVcCgzs6PVRMK05HrQEdzzHuO+N0cNk/uM0gBxMiHu6cN/xgOwj0/HxB5YG0J5B0pz2TChhUiilMxvNTkWulw0y+6i6e4QiGfT6T
 0G2zHFKr
 vJ94WJPO5B9sOb9C9y+vxWg8gumeWNpncQYr/5ZRtftHhQrErsGTIVEjGXU46f2B2JL29ekQyjUAMa48bZXwT/Bd1xQSe9wpJGSpv+3juNwDH3DjEMBZCtrNZtYttF+dBHwobdWrxQIgDGfuiitPxe6iTPSpAHTNV2jcrWkXcWxcSX56oxpxp+Dux1Mmuw9NfGkE2ruSCHNjRIma+JveolEQ6Qo/+9Hvwb+C9fKmbZ+gZGvnRKKxs1eOYwI24/ofU1bFaMCywT/yEsyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:55:41PM +0800, Kairui Song via B4 Relay wrote:
> While doing code inspection, I noticed there is a long-existing issue
> THP swapin may got charged into the wrong memcg since commit
> 242d12c981745 ("mm: support large folios swap-in for sync io devices").
> And a recent fix made it a bit worse.
> 
> The error seem not serious. The worst that could happen is slightly
> inaccurate memcg accounting as the charge will go to an unexpected but
> somehow still relevant memcg. The chance is seems extremely low.
> This issue will be fixed (and found during the rebase of) swap table P4
> but may worth a separate fix. Sending as RFC first in case I'm missing
> anything, or I'm overlooking the result, or overthinking about it.
> 
> And recent commit 9acbe135588e ("mm/swap: fix swap cache memcg
> accounting") extended this issue for ordinary swap too (see patch 1 in
> this series). The chance is still extremely low and doesn't seem to have
> a significant negative result.
> 
> The problem occurs when swapin tries to allocate and charge a swapin
> folio without holding any lock or pinning the swap slot first. It's
> possible that the page table or mapping may change. Another thread may
> swap in and free these memory, the swap slots are also freed. Then if
> another mem cgroup faulted these memory again, thing get messy.
> 
> Usually, this is still fine since the user of the charged folio -
> swapin, anon or shmem, will double check if the page table or mapping
> is still the same and abort if not. But the PTE or mapping entry could
> got swapped out again using the same swap entry. Now the page table or
> mapping does look the same. But the swapout is done after the resource
> is owned by another cgroup (e.g. by MADV & realloc), then, back to the
> initial caller the start the swapin and charged the folio, it can keep
> using the old charged folio, which means we chaged into a wrong cgroup.
> 
> The problem is similar to what we fixed with commit 13ddaf26be324
> ("mm/swap: fix race when skipping swapcache"). There is no data
> corruption since IO is guarded by swap cache or the old HAS_CACHE
> bit in commit 242d12c981745 ("mm: support large folios swap-in for sync
> io devices").
> 
> The chance should be extremely low, it requires multiple cgroups to hit
> a set of rare time windows in a row together, so far I haven't found a
> good way to reproduce it, but in theory it is possible, and at least
> looks risky:
> 
> CPU0 (memcg0 runnig)                | CPU1 (also memcg0 running)
>                                     |
> do_swap_page() of entry X           |
> <direct swapin path>                |
> <alloc folio A, charge into memcg0> |
> ... interrupted ...                 |
>                                     | do_swap_page() of same entry X
>                                     | <finish swapin>
>                                     | set_pte_at() - a folio installed
>                                     | <frees the folio with MADV_FREE>
>                                     | <migrate to another *memcg1*>
>                                     | <fault and install another folio>
>                                     |   the folio belong to *memcg 1*
>                                     | <swapout the using same entry X>
> ... continue ...                    |   now entry X belongs to *memcg 1*
> pte_same() <- Check pass, PTE seems |
>               unchanged, but now    |
>               belong to memcg1.     |
> set_pte_at() <- folio A installed,  |
>                 memcg0 is charged.  |
> 
> The folio got charged to memcg0, but it really should be charged to
> memcg1 as the PTE / folio is owned by memcg1 before the last swapout.
> Fortunately there is no leak, swap accounting will still be uncharging
> memcg1. memcg0 is not completely irrelevant as it's true that it is now
> memcg1 faulting this folio. Shmem may have similar issue.
> 
> Patch 1 fixes this issue for order 0 / non-SYNCHRONOUS_IO swapin, Patch
> 2 fixes this issue for SYNCHRONOUS_IO swapin.
> 
> If we consider this problem trivial, I suggest we fix it for order 0
> swapin first since that's a more common and recent issue since a recent
> commit.
> 
> SYNCHRONOUS_IO fix seems also good, but it changes the current fallback
> logic. Instead of fallback to next order it will fallback to order 0
> directly. That should be fine though. This issue can be fixed / cleaned
> up in a better way with swap table P4 as demostrated previously by
> allocating the folio in swap cache directly with proper fallback and a
> more compat loop for error handling:
> 
> https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-4-104795d19815@tencent.com/

Hello Kairui,

Nice catch!

I have reviewed the proposed patches, and LGTM :D
(For 1/2, flattening the if-statement depth slightly could help readability.
However, since this is planned to be refactored as part of the P4 swap table work,
I think it is fine as is.)

I mostly agree with your rationale.

> memcg0 is not completely irrelevant as it's true that it is now
> memcg1 faulting this folio. Shmem may have similar issue.

That said, I would like to leave one small comment.

My understanding is that if we account based on the folio that was
allocated while running in memcg0 (on CPU 0), then having
set_pte_at() install it with memcg0 already charged may still be
considered acceptable from a acceptable coarse-grained synchronization perspective.
(cuz folio is alloced at the time of "memcg 1 epoch")

Let's think of the situation below

  CPU 0 (memcg0)                 CPU 1
  ---------------------------    -----------------------------
  charge folio to memcg0
  allocate / prepare folio
                                   task migrates to memcg1
  ...
  set_pte_at() installs PTE
  (folio is already charged to memcg0)

In this flow, the charge follows the allocation context (memcg0),
even though the actual PTE installation happens after migration
to memcg1.

I understand that we cannot strictly guarantee correctness without
fully synchronized migration, so this region inherently has some
ambiguity. In that sense, the patch is addressing a corner of that
problem space.

But, I largely agree with your argument (the rationale is sound,
and the change is not intrusive).

I would have no further concerns if the following hold:

- There is a tangible benefit to modifying this patch.
- There is no meaningful behavioral difference between charging
  earlier (current behavior) and charging later (proposed change),
  (e.g especially when memcg limits are hit.)

If those assumptions are correct, I am fully on board.

Best Regards,
Youngjun Park

