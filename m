Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D759F103E2FF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22F06B0088; Wed, 11 Mar 2026 22:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2446B0089; Wed, 11 Mar 2026 22:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFEB26B008A; Wed, 11 Mar 2026 22:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D02BF6B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:13:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69E7AC2079
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:13:35 +0000 (UTC)
X-FDA: 84535789590.14.A59B6BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8E4D180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:13:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=djFkYE6e;
	spf=pass (imf24.hostedemail.com: domain of geliang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=geliang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773281613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBsOpKFkHS7ubnnJQdQOExZEASFZmud3Qds4Zf2FV/4=;
	b=Ug+eARa4zrwMC7fArK2yJ+PFPoryf/64kzlxtpcrqfubFSA3FCyNw9ZNXoAnJJQpr9rto0
	mBPvQ9XOl+4CXKxAnptYPho3S4vOOddX+q+x1ZJFogL34H4e748XmCC6Nx4RJ84BlzuG2m
	DNN0zQli0MD8isxunkq1pt5Mmsv4GEM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=djFkYE6e;
	spf=pass (imf24.hostedemail.com: domain of geliang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=geliang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773281613; a=rsa-sha256;
	cv=none;
	b=ODsFDRKMr5Wrcbdp2s5b+Hz64Kt3MzAe4z4q8MKDfURvzhB7ILwJq35qhHJCMdxfY0z++d
	QNQvqa8ISyaT/E8GGuMRkJ5rxt/pwxvCVuE+ExERtBCfdBkCo9uVy/yOE4/9WTpszSFD+m
	4rT9S/tiFwNF5sdlktJhLrt0crxcsqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36EDE60054;
	Thu, 12 Mar 2026 02:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F6BC4CEF7;
	Thu, 12 Mar 2026 02:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773281612;
	bh=bj6bK1jUpBJKQkuhmgklQGNZhsC4H7mdJjIH7ByGS5Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=djFkYE6ewFuGV1fZ80Uc6aIP5vETw+2A1gQk5UekKIJut58vOf1Rd98l5a5mmRcSQ
	 aE7jWu4BuaUaVl0WueUq/Rxb+CVPTQqyY0WkCMaMTNFlOGd/eGijZygBVCQEHcOvEo
	 zA7PvAJuZMGxfHu1yOso7j+AaOu++FVJjmqeh2jNRi0P56DJmUQHqXKAGMqZnqCLgt
	 Fg2/i9i5MSZQHoXITHSSP9QRRqVERq2u9lEAZwKCDImTH/f3fC7fAZHOdtipU0yfXg
	 Iuslu4n6lJP7Dm6r57AmFgG9cqTYgUDMFxj4kvOYL2gYgu+eygVPFixe2HpxQ/0zo3
	 L8Dk8C4EqOrsQ==
Message-ID: <5310108ca290e5387a2da16f87386962fefbc13d.camel@kernel.org>
Subject: Re: [PATCH v4] mm/swap: strengthen locking assertions and
 invariants in cluster allocation
From: Geliang Tang <geliang@kernel.org>
To: Chris Li <chrisl@kernel.org>, Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Date: Thu, 12 Mar 2026 10:13:26 +0800
In-Reply-To: <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
References: <20260311022241.177801-1-hui.zhu@linux.dev>
	 <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8E4D180002
X-Rspamd-Server: rspam07
X-Stat-Signature: tx9wxu7ijqnw7bqgq3zmmk96pf559tuj
X-Rspam-User: 
X-HE-Tag: 1773281613-462725
X-HE-Meta: U2FsdGVkX1/dvjMJPBTNr/Q1bNRUPrTbtNUD7h2QNr7mDdsU76kvd1GgX9UTjP1AgFvZlYQ0X7zUs1YeWXhDkW91sqSiiWPdKilsqpI7zwsBI8y01TNaGJfxhmXWVUDM4RQQQTg5qD7vMKvvnNHOlMCPkn5idN8KcOPGVz2xh4NJFkpNcrEIw8lu+zNO6xu3KEOecR5KHiHp/hvm96Hlove1sPxgIkTW5yf4kSoS5okRbz2Q6TtEAENwPczuhqpF26y44P8pwSMzv8QQ+VcGtU+ncz0u8xDQXCCxMMdcGBD9xaqclNQQI3PcmNozUvK79w8//Mgg+v8usfHLVCeonBSPBjrYKc0oDo4c/GGuIiK6zVu1pWED4wHDdCfKgJ57juhm22cmcqDndSsO/obWAa7BwwW0HKXAJJ6RyZGT1b6VFdTgBOEqCCdKujNgv9GHn5JG4wXccvizR0rvo0lmmbCPO9EwUJdesj67YHwCQcbyss5KAB8t9CxfBViEVThNPtI8Fk++Qsr4Dr/6Ij8p8TUrqwcDDTW1XAey74xj/gQZYj3ZuwMUl/7quTVhcY9lzTmZXtvL1rE8/rbCnJ7NB/fNrPBEBzpIFnd0as4uQMdWLJ2x4/SszOfYH0EOaIHFAS00RCW8pGo4waYKybzf/LHWVqh3ntTB8qRHxWmrKA8fJEbjAHOqU2AGgGpos0wxBayHF0CtK82MXIgNOQsgN1vvg5b1MuQd/SLJyaLoSOZzTlvPHCQfyPqdPDecpmaLGEV/sJBL5oeLaSuk/IklxHnMyMEL6tKIYIuyMZxG8WxOH/SVxxl3Kw0Jf0gbJPqos4B+HCG+OiWDGyjT+L+1opwyExFxQCSJ/6xugU5GlJYt96Z3n+wBNXOaBXxwEkEczya29U+x5XjrCwkM41V4SswA5oFN3Tyz8e1AvQViDe+h/2IgmuM9XhGrtW4J3AAlO9qvLhgQ1iYnyvcklQk
 KM6SaXL0
 lch79SzSRc5A6vJ1TlfoHyEBu7pblxRP+xWk753iSPmY5Opg9DTbAUP+akz3hs/9ETT8ZjtFNgrqPrjNSiUmHksCG7favnY5aGSvThGCnlD2cYTg3KegcrfzDvbiMPvVfBdsh9RBC78OkG8YmENmHN4bocElJ/wgcSsWzBnHGatF5MCoWEmvcWW7KEEAhPVEc+80t7HGcYZaqfTLjZoeiRHk1oUG7ye40V0eXRuBLzRBEe+N3nJixp9UjXfa1QZC+tMMs8WXLK55xQo9YCAbLkoKFJl1YL927fjNuPbouDKJ3dic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

On Wed, 2026-03-11 at 10:34 -0700, Chris Li wrote:
> On Tue, Mar 10, 2026 at 7:23 PM Hui Zhu <hui.zhu@linux.dev> wrote:
> > 
> > From: Hui Zhu <zhuhui@kylinos.cn>
> > 
> > The swap_cluster_alloc_table() function requires several locks to
> > be held
> > by its callers: ci->lock, the per-CPU swap_cluster lock, and, for
> > non-solid-state devices (non-SWP_SOLIDSTATE), the si-
> > >global_cluster_lock.
> > 
> > While most call paths (e.g., via cluster_alloc_swap_entry() or
> > alloc_swap_scan_list()) correctly acquire these locks before
> > invocation,
> > the path through swap_reclaim_work() ->
> > swap_reclaim_full_clusters() ->
> > isolate_lock_cluster() is distinct. This path operates exclusively
> > on
> > si->full_clusters, where the swap allocation tables are guaranteed
> > to be
> > already allocated. Consequently, isolate_lock_cluster() should
> > never
> > trigger a call to swap_cluster_alloc_table() for these clusters.
> > 
> > Strengthen the locking and state assertions to formalize these
> > invariants:
> > 
> > 1. Add a lockdep_assert_held() for si->global_cluster_lock in
> >    swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
> > 2. Reorder existing lockdep assertions in
> > swap_cluster_alloc_table() to
> >    match the actual lock acquisition order (per-CPU lock, then
> > global lock,
> >    then cluster lock).
> > 3. Add a VM_WARN_ON_ONCE() in isolate_lock_cluster() to ensure that
> > table
> >    allocations are only attempted for clusters being isolated from
> > the
> >    free list. Attempting to allocate a table for a cluster from
> > other
> >    lists (like the full list during reclaim) indicates a violation
> > of
> >    subsystem invariants.
> > 
> > These changes ensure locking consistency and help catch potential
> > synchronization or logic issues during development.
> > 
> > Changelog:
> > v4:
> > According to the comments of Barry Song, remove redundant comment.
> > v3:
> > According to the comments of Kairui Song, squash patches and fix
> > logic
> > bug in isolate_lock_cluster() where flags were cleared before
> > check.
> > v2:
> > According to the comments of YoungJun Park, Kairui Song and Chris
> > Li,
> > change acquire locks in swap_reclaim_work() to adds a VM_WARN_ON in
> > isolate_lock_cluster().
> > According to the comments of YoungJun Park, add code in patch 2 to
> > Change
> > the order of lockdep_assert_held() to match the actual lock
> > acquisition
> > order.
> > 
> > Reviewed-by: Youngjun Park <youngjun.park@lge.com>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> 
> Acked-by: Chris Li <chrisl@kernel.org>

Acked-by: Geliang Tang <geliang@kernel.org>

Thanks,
-Geliang

> 
> > ---
> >  mm/swapfile.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 94af29d1de88..e25cdb0046d8 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct
> > swap_info_struct *si,
> >          * Only cluster isolation from the allocator does table
> > allocation.
> >          * Swap allocator uses percpu clusters and holds the local
> > lock.
> >          */
> > -       lockdep_assert_held(&ci->lock);
> >         lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)-
> > >lock);
> > +       if (!(si->flags & SWP_SOLIDSTATE))
> > +               lockdep_assert_held(&si->global_cluster_lock);
> > +       lockdep_assert_held(&ci->lock);
> > 
> >         /* The cluster must be free and was just isolated from the
> > free list. */
> >         VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> > @@ -577,6 +579,7 @@ static struct swap_cluster_info
> > *isolate_lock_cluster(
> >                 struct swap_info_struct *si, struct list_head
> > *list)
> >  {
> >         struct swap_cluster_info *ci, *found = NULL;
> > +       u8 flags;
> 
> Nit pick: consider initializing the value. The flags assignment
> occurs
> in a conditional block. The compiler might or might not realize the
> "flags" assigned only if "found" is also assigned, and might complain
> that flags can be used without initialization.
> 
> > 
> >         spin_lock(&si->lock);
> >         list_for_each_entry(ci, list, list) {
> > @@ -589,6 +592,7 @@ static struct swap_cluster_info
> > *isolate_lock_cluster(
> >                           ci->flags != CLUSTER_FLAG_FULL);
> > 
> >                 list_del(&ci->list);
> > +               flags = ci->flags;
> 
> If VM debug is disabled, this variable is not used after its value is
> assigned. Please test it with gcc and llvm (VM debug disabled) to
> ensure it doesn't generate any warnings. I don't expect it to be, I
> just want to make sure.
> 
> Chris
> 
> >                 ci->flags = CLUSTER_FLAG_NONE;
> >                 found = ci;
> >                 break;
> > @@ -597,6 +601,7 @@ static struct swap_cluster_info
> > *isolate_lock_cluster(
> > 
> >         if (found && !cluster_table_is_alloced(found)) {
> >                 /* Only an empty free cluster's swap table can be
> > freed. */
> > +               VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
> >                 VM_WARN_ON_ONCE(list != &si->free_clusters);
> >                 VM_WARN_ON_ONCE(!cluster_is_empty(found));
> >                 return swap_cluster_alloc_table(si, found);
> > --
> > 2.43.0
> > 
> > 

