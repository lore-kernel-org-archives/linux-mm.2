Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05647D19510
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 19:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE2D6B0088; Mon, 26 Jan 2026 14:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C016B0089; Mon, 26 Jan 2026 14:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0693C6B008A; Mon, 26 Jan 2026 14:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5EE46B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:38:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D1781408B1
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:38:09 +0000 (UTC)
X-FDA: 84375125898.17.F9D616A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 162F71A0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:38:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YkOaj0qE;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769456288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHTeqDUB2gh/CQfkj2zxMXfvAoeqsGGyUjMjxOv0Sn0=;
	b=lvJ77d9FK19O0q9dHdv6kE+ixe4bZz/n89Rkd4AtjvZmygDyTXkoNuQpp+RKgcmLsgfVRO
	0hDRiiqS1XZ7R2qU0CXTQb2rZpnvzTsliMLQsTl80NS1G0dNojXUCrZ75HipeVAXQrIloT
	H+YS5v4HpVwE7qm+5QZlpzsLFtJFDX4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YkOaj0qE;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769456288; a=rsa-sha256;
	cv=none;
	b=u6hzh9VQVuzRfFMCSZ3q+UrVB5Dpmc3gkULmtYPv1ecqERbT4oTKG/g7OUumt55cj7eD+6
	ca4YQcUPAy/BEgDPic5RQik84OGG0u5cCs7FpBFHvNG+lMLSHCDAAVm/nDKBcOARuEGwEw
	u1hZu5dvfa16nuBygQlaUSvt6qSyPUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EA9360121;
	Mon, 26 Jan 2026 19:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5B9C116C6;
	Mon, 26 Jan 2026 19:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769456287;
	bh=R9PbN9ntS2LDukuVYwI34djTXDghM47LTWOybDJ3vlQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YkOaj0qEK+Bj67GnpQv4Jl03pawuX3A8+7L9FQ86c8qsWyl/hI7VAjvGfW9K61tLj
	 QzzneJTYBFhga2+e0+BUXvjQsxlT2WILRSNokESaiSJsDlcNWNcxm5XabjH5Yf+Al/
	 /HaCH5yeko51GgcUsOKs9LpWNrcQ0q1UKf725TYo=
Date: Mon, 26 Jan 2026 11:38:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn
 <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
Message-Id: <20260126113806.5b0942a6fd0a3554ae5e21fd@linux-foundation.org>
In-Reply-To: <c09f2c10-516c-43b9-81a6-cc77e5f78ba8@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
	<7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
	<ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
	<c09f2c10-516c-43b9-81a6-cc77e5f78ba8@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 162F71A0007
X-Stat-Signature: egaadxc31c1ok55fe7n5x68sdeh9a8mw
X-Rspam-User: 
X-HE-Tag: 1769456287-292560
X-HE-Meta: U2FsdGVkX1/qUQxl8nadhfH89pmleRwvzVJ1I7eejbffDPFN+gsQOK64AYz15Uw/PXsMD0UuA0eBFou/Y6AlsSTKNykzzh9r68lY16A/9Ok/obq5//o171voFM/uNeKwvrSgkk7Yy8swI36BBxoCbP2z8W6WglpXwtmbe0TEVzNz0G28+iJS+gLKIzXNGd5zp65VaXVly33cWL4nHpq87P8Uyl7R1Bhka3WuIGQPnMGRiabRL8Eqg+4lzY9tcIiMtXj1zH6GDir6OjeTlfgpCS7tAg6OOuwUay9QGzLug5EAdFY9jNXpJ/5FXmnyj61gm0uQEbznzeRplcnU99wAJOdkanhgKpte4q3w67wsnbL49eI6Rs6vRyjdwyA4rb7B35tixKg84GISGOaqD4uyHhof7k/2vygykP/CB/6kRt/gUMdBbRt3el3GnXnBUnBDQCkPRNf5/h+n2TEl+96WU+Zzu3GROnePGDl2vVBukfzI7YfXoHmxMarjxKMBHnGwDFiUguADfFwIM0rsYysY+b3Vd3QeJMf6XlInsv0oClfpwsYs2mz+qv4VPo1ZLFFUp6u4x/ab0LIkDxq1a9AV8iVhsXUQR1ZZOHSLN0gk6Sov0W8wRHjcV38ebIXGgmaZz6/f0vxoNW7vRkDU8OH3ZkL6BAL84oQH/GPnPL9au0SHiAAxE96x6b3BlVjuHeEJ3OQXKA6OrfXWJdlohGnFmHXLjMh2oFThxLkEC8n8XKb0sMFIeBcyXq5E96Tm5jj4juqtyaiXZkyqVexhSmQjsnrNaK5RW5IlhLS3rxQbToSFUC8lCxNMjSwxpvb+7eV0dcoJy2qEf4fMT0NgjlvO4FH1S7Ho9V+fwxbvTH503CizGMrF10H2hiiWddWGz4YuyAizrHe49P0Ls/JmlUeEK+G153v/KAdkyTPeOlYPDuOvBn5I+FYpiurEQtDpZkWTcSvagssn5RirAHJhWMn
 1WNTWyK2
 zMvBhj1HvzIYbfzxeca5vJSEJ6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 16:09:24 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Andrew - could we change the commit message to:
> 
> -->
> 
> It is confusing to have __vma_start_exclude_readers() return 0, 1 or an
> error (but only when waiting for readers in TASK_KILLABLE state), and
> having the return value be stored in a stack variable called 'locked' is
> further confusion.
> 
> More generally, we are doing a lot of rather finnicky things during the
> acquisition of a state in which readers are excluded and moving out of this
> state, including tracking whether we are detached or not or whether an
> error occurred.
> 
> We are implementing logic in __vma_start_exclude_readers() that effectively
> acts as if 'if one caller calls us do X, if another then do Y', which is
> very confusing from a control flow perspective.
> 
> Introducing the shared helper object state helps us avoid this, as we can
> now handle the 'an error arose but we're detached' condition correctly in
> both callers - a warning if not detaching, and treating the situation as if
> no error arose in the case of a VMA detaching.
> 
> This also acts to help document what's going on and allows us to add some
> more logical debug asserts.
> 
> Also update vma_mark_detached() to add a guard clause for the likely
> 'already detached' state (given we hold the mmap write lock), and add a
> comment about ephemeral VMA read lock reference count increments to clarify
> why we are entering/exiting an exclusive locked state here.
> 
> Finally, separate vma_mark_detached() into its fast-path component and make
> it inline, then place the slow path for excluding readers in mmap_lock.c.
> 
> No functional change intended.

Pasted in.

> <--
> 
> Please as per Vlasta's comments below? Thanks!
> 
> Also could you sed the patch with:
> 
> s/__vma_exit_exclusive_locked/__vma_end_exclude_readers/
> s/__vma_[enter, exit]_exclusive_locked/__vma_[start, end]_exclude_readers/
> 
> As per Vlasta's comments below?
>
> As I have clearly forgotten to do this bit myself... doh!
> 
> Also at the bottom there is one small correction to a comment there too.

I added this -fix:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
Date: Fri, 23 Jan 2026 20:12:17 +0000

fix function naming in comments, add comment per Vlastimil per Lorenzo

Link: https://lkml.kernel.org/r/7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 mm/mmap_lock.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
+++ a/include/linux/mm_types.h
@@ -1011,12 +1011,12 @@ struct vm_area_struct {
 	 * decrementing it again.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
-	 * __vma_exit_exclusive_locked() completion which will decrement the
+	 * __vma_end_exclude_readers() completion which will decrement the
 	 * reference count to zero. IMPORTANT - at this stage no further readers
 	 * can increment the reference count. It can only be reduced.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
-	 * an attached VMA and has yet to invoke __vma_exit_exclusive_locked(),
+	 * an attached VMA and has yet to invoke __vma_end_exclude_readers(),
 	 * OR a thread is detaching a VMA and is waiting on a single spurious
 	 * reader in order to decrement the reference count. IMPORTANT - as
 	 * above, no further readers can increment the reference count.
--- a/mm/mmap_lock.c~mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
+++ a/mm/mmap_lock.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-/* State shared across __vma_[enter, exit]_exclusive_locked(). */
+/* State shared across __vma_[start, end]_exclude_readers. */
 struct vma_exclude_readers_state {
 	/* Input parameters. */
 	struct vm_area_struct *vma;
@@ -100,7 +100,7 @@ static unsigned int get_target_refcnt(st
  *
  * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
  * function may also return -EINTR to indicate a fatal signal was received while
- * waiting.
+ * waiting.  Otherwise, the function returns 0.
  */
 static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)
 {
_


