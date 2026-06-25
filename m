Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B21CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366856B010E; Thu, 25 Jun 2026 07:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DA06B0110; Thu, 25 Jun 2026 07:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A1F6B0111; Thu, 25 Jun 2026 07:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED4A66B010E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C8221A0648
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:17 +0000 (UTC)
X-FDA: 84918218994.05.B6A1ED6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B925080018
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=D2IeGfHB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387075;
	b=dTyTzog5KXR+RwSVLbhxNVohvLl8YVHKVlAIi/jWPzP7ZTujt+fBiuQszpDOCk9/D5wXnz
	jEO/luKNX80OS6B42jsgNVvDgEePzTLTf4EUr4bSjnWtQe7ao2Xn7aWN4lhs14QJFvst5y
	HBBXNAtAP6X1uKLPFFLVkEUKrIfU9do=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=XEN+Z6x3fAUfpvR0fBzUjUy5rFJWdiR+3VTZQXKtpa8=;
	b=7D+XKZNnDazttB5044Vt4o9dFdWy2Pa4UYFdXyETNLyCYCTODQ4Sx4D4t5UL0TLLcxiz2G
	qyF+RhBYUQIhT3oJie1aJAh5XxgphXn3STKcX1ZS93STbjXgsfHSqbmeqSaN3dkBTjQop0
	TyUBH5i8IWFtm3uyb8OEtGauyW2WNGQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=D2IeGfHB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FB70405AB;
	Thu, 25 Jun 2026 11:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505C41F00A3D;
	Thu, 25 Jun 2026 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387074;
	bh=XEN+Z6x3fAUfpvR0fBzUjUy5rFJWdiR+3VTZQXKtpa8=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=D2IeGfHBENw6G7hjJ4A2QPYazloD83/qaxJ5f5l3UY7cx95TtXNI0uPS4LrIhtdt1
	 n8Grcdrr7loAPyNblmmQDr7wHicADQ0C8e0mmckjOU2+OKuaouruvFmx5dobbwqrqs
	 ZwZk+ZKNpr3rIRaFWORHfNA6cLwcACkrliHdR9bo=
Subject: Patch "mm: propagate VM_SOFTDIRTY on merge" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,david@kernel.org,elaidya225@gmail.com,gorcunov@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,pfalcato@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-10-elaidya225@gmail.com>
Message-ID: <2026062548-unfocused-passport-11f5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B925080018
X-Rspam-User: 
X-Stat-Signature: qezs3dnotzok1i6qdkhhy8fmxfa4gd3e
X-HE-Tag: 1782387075-489989
X-HE-Meta: U2FsdGVkX18QGUnDADRj5ATmwDIdLM7lGxHHuaB6nSCyyWTWigXbJk1Rwa9rovlze+kMIUBvZpbfTpPuZoSJiAMq8l+9QufjZb5wKGmG/3guzdhz9Q7seU3OXkEpHorlfALl+AQMrCSGF2nRJC4NLln6/Mz3tYimx925OCMiEDXHyCruambdr2oXR3NSWAoPkT6vy1BU5NE1lBWJu0BvqeiYV5smpaj6vbiQYz/VFl8uZLQRrLSQJNLs7Mh3YY2LwH8j6AA9jGYykTRW3MD+7ZqN1kp39nJt/lxtaqyLUlerekOQhP3vxgISTIvz7eupJXCaQYmk2NP7hwoXCZ54VIpNX+4PCK6FxDxcWzXg7g22qmUkn/roKviPVQd5ZHYfDGQhA4gj19HSo1VYdN6KpP/sXIRgo352PWpLLrseVgBzG+VXn5EGrBL5hUrDa37NkrBoapWykZq3rhnVHQmuwNtD2+lHy/vZX/TkLKwJ+9BRQy/RqHHTnE98OZtq7G+pUlKfo4RiSCXh1pQUGSyquF5eJdRjhNTaSaoCCGV8PpNrUUGfBHVpqfW1e4VksWU8uvTlJ30UGnljpl1o0TQGnbF8GPVTh5mCKdrr0a6kJb7WCmEC3Fu8zXw1mbQ21aiuw1Ls46w8Dj96icyACOM89f/ni08wAfx38MO78hODnnPKuf2JddZhswQmLwYjN7EbpN/DRxprJwnegvSD0k0LPLktAxA+FR1VVlx4KQKEk4GbxU2RTEldnBhbJziYf8NUK3MN7m1FgXuTLZTBknQjgM1MZh8J0CuuOnUuzghHajEjq5uotHJs+7weOiPdlsFlIUx94xcOxSRONXTLkUYP+owkMgLha6CjYytnIBH465yqnyz052f7doDYtCoKLD/uhSQX8Ds1a4IcEVEosTDfZiYKeoOK2H9WDmZfAk5/RAn4NiIvEg3TjwLIncBvk5V/VrB4G1f1/zlhJV6Qr+p
 XYQtFSkM
 FmBLnEUQae8BKatkn6n30bdqUCTWyUCV1iFlIhfTENLJiw++Frz/cf6c4Jtn4FyDOf7Sm0sqEm6G9U7A+ClDE7VdavRAks8PjmCh9fzfURwo0I7bpy94UpSXGZexCYFI79lDo/LTu5W/y6WHUMiZm14wLsu3Ll5Fkd01e3u9NWsTvIbj5yTVHgmJnU79GEIeLLDYeq4Z+Lu6ST46FatavEQN3UeMfk7/7nC1GEAEl2J7DhbbaBnKAX5i1eY7SvSfzuGLtktM8ybFP3fE/SWnF+BVpulGbciAcAveOv5kJBKbv6GmHaUbnmM882w2zm3Fnqma6C/5HyPFE3ekefH+VNwA7ytmnWdgNQ7haFjyycZoeafdukcQCp7Ubg1I9x6PnPoRT07k4ljKttImLIiPZ7Nvpz3eDpAwB1hNZZ4D/8da1JvlCNZkkuPIO9Jx567RMGfOepA0qvIryPpDdtWDqKEVyFMHgMwBYbXWY6zqzuDUFPS33HWbiZ5cUBGO9ohU/TE9iMh5RdNUi+Ffhm7K5wi3MnmzMx/Omg4wMDS6JM9DsIrGSvOC3nWqM+xbN7kJLRWkzxOjTI9THzXwpprHzha6qqP0R37H5W2mVYY3SOBoqw6i8iCWym9ljGgIpNCxKOqcDjxArSDKgjeGLbt6n3Q+jUr7m9245/0LYZJdKNIuzuHQacoNyc3pFHcHTwXjX41oS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: propagate VM_SOFTDIRTY on merge

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-propagate-vm_softdirty-on-merge.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247755-greg=kroah.com@vger.kernel.org Fri May 15 14:06:04 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:18 +0300
Subject: mm: propagate VM_SOFTDIRTY on merge
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Jann Horn <jannh@google.com>, Liam Howlett <liam.howlett@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-10-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 6707915e030a3258868355f989b80140c1a45bbe upstream.

Patch series "make VM_SOFTDIRTY a sticky VMA flag", v2.

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Now we have the concept of making VMA flags 'sticky', that is that they
both don't prevent merge and, importantly, are propagated to merged VMAs,
this seems a sensible alternative to the existing special-casing of
VM_SOFTDIRTY.

We additionally add a self-test that demonstrates that this logic behaves
as expected.

This patch (of 2):

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes
of merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

[akpm@linux-foundation.org: update comments, per Lorenzo]
  Link: https://lkml.kernel.org/r/0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local
Link: https://lkml.kernel.org/r/cover.1763399675.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Andrey Vagin <avagin@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
Fixes: 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h               |   15 +++++++--------
 tools/testing/vma/vma_internal.h |   18 ++++++------------
 2 files changed, 13 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -515,28 +515,27 @@ extern unsigned int kobjsize(const void
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -122,28 +122,22 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
- * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
- *                  mapped page tables may contain metadata not described by the
- *                  VMA and thus any merged VMA may also contain this metadata,
- *                  and thus we must make this flag sticky.
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

