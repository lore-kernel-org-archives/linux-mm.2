Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A618CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7394E6B0088; Sun, 18 Oct 2026 02:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8BC6B008C; Sun, 18 Oct 2026 02:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFBB6B0092; Sun, 18 Oct 2026 02:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8486B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:53:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A01721A04A9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:53:57 +0000 (UTC)
X-FDA: 85334832114.14.F4F4E91
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6EE7F40002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:53:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UvbPSOhA;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792306435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTG94Lje/uoNU27h4mFItRaWkk5l9jV/oJEBqbQGKlA=;
	b=4UZZ1BNTSQaYdn2eH6s2nDJ+WxO5ZFtxmk2KhSTEA1CeQZDFInGb/IdSgJcnf5zLWk2RR2
	i3LWYAkao8/9YIB/1zigehSns/fGEDAaxm0TSVw/Gl8nr9YKC17+zVPeo7DCpf/+x2+sPn
	8Mp9+zO43wERbLG4GcK7NzBQPiibXH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792306435;
	b=kLr8EFlc0n2h95xccW0g+bqi2kl4JB26xzrAZI7T1cjLsw0NrUfAYICeVVgYajbeVfAAT6
	IEJMSLVwsTofiUhHwJ/SlRFTIaWcm6bn8MGzGXM3pqB/LjFTil0m1v9OiIo4Ilf13tug/o
	yMF2+L+mRCQZ56Fh02Dy2dg8UyJm+ws=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UvbPSOhA;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vwLPtYmKSLRm3Ywxe7ILm7ay94IJmx9l0s4awNjJZjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792306434; v=1; x=1792911234;
 b=UvbPSOhA6qn9W+7+DeyKPEq++igEA9eI7khdKL6e9i5aBUjqoxazOxLK+ViIgSTCMe7JQUgM
 Ddl2J02Dp8U76o0MatwQEJhWba4fsU8J2T5DRwUHcEZEo7Iu7Tae1rSh6EeZRkKRSzUbulKjQc4
 mOxH++6phaOuv/lHXey8thjg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 123d8aeeb9113a82;
	Sun, 18 Oct 2026 06:53:53 +0000
X-Mizu-Trace-ID: 123d8aeeb9113a82
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 05/10] mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
Date: Sun, 18 Oct 2026 14:53:48 +0800
Message-ID: <20261018065348.18713-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-5-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-5-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EE7F40002
X-Stat-Signature: a7kdtma67m9ij69owjjtw65io7eo8kzs
X-Rspamd-Server: rspam05
X-HE-Tag: 1792306435-508742
X-HE-Meta: U2FsdGVkX1+gnTl8lxEOpd1JlSKI78TyFApw8pFhe8c4hLzJ8mZYNmqQ+8D9aAnyLf2sPyd7BR6GmrXNEtJodxfkz0ksKYUQ5t5HrVRCZH6v+o/U2Lxm1uLyaEp4KsPiXomUZlplRiUqsMiYElYeiyMRgnMq/iqtp+J3XvoQEWn3xDaKNOCDJek2O8IFOxO8Q32kiuzlQdPTneRTOw/1akyJdWc1WEftSs4JbrfxwROf4pVbjYbfO/9ebafvanLvaaUFWEqdYrJsfw2J+MzYJo5a+mi2Rp9w/IjRUL+C5xDNbVdD6r+VQKxS5oyvFGTIudg26ouVZvThBk0M2qWVuEqdChGvLqkhKi2lJhUA8NLZYxtmSZbCrcC6GHUjJMxeJDYSi79lLpZE+wJ75G5BMs3oykCjyMyyIvHCdQd0/RvbolsjKbvaohTCUD1B89wEzPJZXfhhsbSbDjcOpbC2BDzmIs2803Hs363e+VttyX+H/Sy6vf/HPEUjJZyQRM2bwJtnb5FHkDCBtzSFXztQYtNSEGoqb3IYV2xxNEMIF0XR/s2DdGSfiSvxijQYHNQ56Iuxi+VFIPyW9O1iOrLepGWExu7Npu9vMy0smgMmZegJRfk8L1rsPhw4OR/lrbf/M0NoFUR92nwZ32UiAK4EaYBxmh4AsXKGizjX2bVBEfm93EnzIG/Ym9UafPn1OUALqjDyUcvhsuK82kjDNcVznISULXvCjDgnFB5sridj3FpGOCkhgRQNYd8QCpqZcuJVqGdHpO2WU7ZCZjBVwwcmvfRylDhQtBsHvNVOMiOgGHOE00AuFlU6WCDVa6W/TkQCDVrXcP6I/qNpsNSAhTaVr3dM/KWjldEAVdlobTQIUUHE/nvioj6Y5hynOTTpBXi7hjegq7r+GfsXn0MN6IA3ILVafDEVl99FDzQtKcc06pDdGotkp3Own5U/KZXcog7zXFK1htGlb52WWWXh77a
 oRGF/z7Q
 zi+5kzNHKsahU+lWMZLgtDVb8quzGggl1Kuc/WidCjbG7rYJ4UygF3F7BTJLmRfGYOtutYmMfZhG+X8YIWd6bQ9jImO7jlw2R8KRroReNWGvIygl22DqiOROF3NPiBbuXfTBclk7l0JKatGx51+ddQkwrc7Vq3Cott3cWX8c35B7sdhQYjAaJVlsjY0//AS8+h+9riiSKnmJ5cm/RGlYOS4uGq2AC+Dk2EjxzVL3PK8if9E+kK0Hs7o1hsWQiGKJ3pgJEbZEyG6WWkULhOaXe0cv4KVVMVz9mYElQj0T6lLP9RhzFko//gxqX5wmeukkiO4zE60GLDmgcZQMsA2mG1IjF5ZlZJKP9+ynWTjyPEK75BzZ/dUrdltgzcBxNh/eEEyDBeLcudwFGHal0uKxDgCleaEUf0Q0EimolWWz4jQm6TjG5M1rixb9/BRhQst8MDURkYD7b9Uqxb+UsqEVNlN44eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:11PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>Since commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
>VMAs") the lock of a private hugetlb VMA that owns a reservation is the
>rw_sema of its resv_map.  The hugetlb_vma_*lock*() helpers find it through
>vma->vm_private_data, anew for every lock and every unlock.
>
>At the end of mremap() the old VMA has to let go of the resv_map, which
>now belongs to the new VMA: clear_vma_resv_huge_pages() stores NULL into
>vm_private_data.  mremap() holds mmap_lock for writing and has write
>locked the VMA, which keeps away everybody who comes through the mm.  It
>does not keep away those who find the VMA through the file.  For hole
>punch and truncation hugetlb_vmdelete_list() does
>
>	hugetlb_vma_trylock_write(vma);		locks resv_map->rw_sema
>	unmap_hugepage_range(vma, ...);
>						vm_private_data = NULL
>	hugetlb_vma_unlock_write(vma);		no resv_map: does nothing
>
>and the rw_sema stays write locked for ever:
>
>  WARNING: lock held when returning to user space!
>  mremap_punch/116 is leaving the kernel with locks still held!
>  locks held by mremap_punch/116: 1, last CPU#1:
>   #0: (&resv_map->rw_sema){+.+.}-{4:4}, at:
>                                       hugetlb_vmdelete_list+0x46/0x160
>
>The next fault in the new VMA sleeps in hugetlb_vma_lock_read(),
>uninterruptibly, and it holds its entry of hugetlb_fault_mutex_table[].
>That table is global, so a fault of any other process on a page that
>hashes to the same entry sleeps uninterruptibly as well.
>
>All those who take the lock of a private VMA without taking the mmap/vma
>lock are affected: rmap walks. So hold i_mmap_rwsem around the clearing
>of the resv_map.
>
>No change of behaviour, other than that mremap() of a hugetlb VMA takes
>i_mmap_rwsem once more.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
>Reported-by: Chris Mason <mason@kernel.org>
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ david: avoid local variable, move and refine comment, description cleanups+simplifications ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

