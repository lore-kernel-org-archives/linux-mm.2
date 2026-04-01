Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1284ED3514F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5406C6B0005; Wed,  1 Apr 2026 04:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5185D6B0088; Wed,  1 Apr 2026 04:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DDA6B0089; Wed,  1 Apr 2026 04:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C8F6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:14:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6560E1606F5
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:14:51 +0000 (UTC)
X-FDA: 84609275982.21.724AC34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B8F8440009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:14:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=urrgNB4v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031289; a=rsa-sha256;
	cv=none;
	b=S+GRbCqKV9zZQVexJyFwVg7XuuEOwhXUGvCqZM4g5SOVk3Xbw9QFUaiAuHM6xI+OlSN0go
	dBFCwugE2uH1PujAl3H7pQ7P236kZJKKUfGNR027Q+k8sK3WwnrIupFrVmxWiewlN5Tq4g
	0KvhXuj/DyUP89jjuHv99+UaRMmdcB8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=urrgNB4v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GktzSnMJl8Ijyyr3l1owjiRLvmZas5MqD4wkLR/ZTI=;
	b=N9dyrhzOh+eyyAdJkvA0htj1aIlrxuRTTZNzRavUPe4J4+89bAbdwCcxpp+4euZnGL9lXM
	6L/wWOs3l6MSFUMa+U1ShnL9p0dUID2BlcuIr8HIJjVESn6fTVHvWADlNlL2eiLm7veQQI
	7QG2jRGA+k9ep/FVYat/JoW+524shrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9EFA600AD;
	Wed,  1 Apr 2026 08:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7E4C4CEF7;
	Wed,  1 Apr 2026 08:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775031288;
	bh=iQ8EvU3tv/4pbsm6CfejJfK6S/sdYvvsil2MY6ruHb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=urrgNB4v0h8P+iqymJ0YNB/+FOuzKEHPJOFOhpxTBlP48HAYopSHr9sh4n8Tkb5rk
	 deGiFiB/CP54/VZ8aHeVfkDp94GgVjaxW0falDt7bA+7b7tg6R/C9sLuwx5P2+ThSF
	 mxqah6eI+pjxCO+jEUHG9gQ+qe7uBwrxixxjc+qfod3tZezhS4QtvaxODbZ4Nm+7pa
	 wTv4z1OFfVdx9lyGj8u/UIUnbzxw7RDm+djdReNBr9fkrPwC4k9kbP6D4cMGSI8gEw
	 npH0PSYoPcoAAp8RRv0ITWaMMXpF+kq9SvpQ70UVYCVSelRWGkj0AJBhU3V5/ixZkR
	 R+ynnXZubZ8AQ==
Date: Wed, 1 Apr 2026 09:14:35 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
 <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
 <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
 <CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
X-Stat-Signature: m7bhyizixr8qio3dg1qguaygs7iqncqr
X-Rspamd-Queue-Id: B8F8440009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775031289-201756
X-HE-Meta: U2FsdGVkX1/JKnzmYNJdm5HwoJk2q2EVCGLRaY2nLryVi/X6U4nyMV1FlEV+SkbMgjx4J26HEvsryxb/lJtEOjNzGjykThFOIDQCKT8Z9PVcZ1EX/KedLUYqlyDJ9GGVXeUV3gf8Z4x3kuEYF9nd6UyIoOUgYL/l9CGq8wGBcqmd5nBuOXJIE6xdGZlv/FivjU9THVJmbrNGTd7EE1ZMGd2ZuEiv8gF+uVtETgM3VNww9BiFnqkG2rN2dorzGEmErwC1WcJwQMlwinh1IYqazfaemEmjfd/JjhR1i+9MxB+B+Lf3m7RAewS75w3mwZCeLfz41lR7kQJj0YPY14xUZt+8GX9vLxJBL3MZcrfv7ctZnAtbZsxmfS1l9h41CZNe8SwmJJkFigHFNc07kSnrrL41D2C2HPNeZuL34mnO20DGdgSzGyb2mnwHEW4yIE10g6PvGu267MPZQXWu+Al1C0Z6jOo6dVSwvio+m1ZGkiiMDO0f92aT8QigsLY3i6IPYvpydwSWLciuvIXHkb8l16//cAnvOYHecwGU2rILlFLcC+VkvclhL1cPV53aErAPh4IINe8Xv5xu/Szf9MamRc3+iV5GmkFwFxBehFCjHHMO1hoOhuevO9kwnXoy1agyb2jtmA52dZX9GBvw0y1RcQeg/1IKUXHQH7bknydudc2lMqTbzcF2CLQ3EhShF5dMAUF0Wwc5kkuTT3HLfkVzn5mGC79CiSV3gpChYl1OfjH0U4gC/NnF3KFjLk8Hjh1PoJVmqjewoaAN3tiYFgvzF4WgzNFw+c6ki2L8I7rmqb4f/HbP8SW5rwFeSs8Ce6ASaUpD+GcVYRwVIRNcBN1C81Tw3EWU6xDFopKkvjJYPOZD7JGEaagvoZq+XXWjUqKoiswl4ImbKLd0pVDlSY7qVYh5tazL2ZIoFuM68U+DK5X/JixVJlPqeY43MFG6Qo4mFjx7jyWXLl+M1IqKnga
 1IETYLAr
 DRTKTDfw5LLCYxqJjSEWmp3xgIBmTrVeSAzpCz5nqOTZ2xTe0zk6x1VXXYFWVFqJ9mgM2enN1ufGVaJZXtTICo2j2gOte70ctvXmk91hbxtnighpT6mchcfhUdWP52sp5cPRUHirXMkR6PHodpIjvtg4nWK0nrjEMjJ6usdOy7Wku6SYfp6NEtYUQN3jnSudQdtAy+lR0mL27SWooxkDMkWj3EXiSzHzQjk98kkrqnnrydzpXiqYuuoumd3caa2WtSMIYMpNFPrhRRx16biRlZ4Q9WyWiZPQo7qbSaXGp9ONW8hjrMSX85eMWN1+Vml2ZwIll7um03VizCU58upb9awlGnwAuyc4ovuIxnFq+M4GzXs/KNofdEzAzAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 03:09:08PM -0600, Nico Pache wrote:
> On Tue, Mar 31, 2026 at 3:04 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 3/31/26 22:50, David Hildenbrand (Arm) wrote:
> > > On 3/31/26 22:06, Lorenzo Stoakes (Oracle) wrote:
> > >> On Tue, Mar 31, 2026 at 10:00:58PM +0200, David Hildenbrand (Arm) wrote:
> > >>>
> > >>> Right.
> > >>>
> > >>> The original code used
> > >>>
> > >>>     bool mmap_locked = true;
> > >>>
> > >>> If the fix get squashed, maybe we should revert to that handling to
> > >>> minimize the churn?
> > >>
> > >> Well collapse_single_pmd() and all descendents would need to be updated to
> > >> invert the boolean, not sure it's worth it.
> > >
> > > The code is confusing me.
> > >
> > > In the old code, collapse_single_pmd() was called with "mmap_locked ==
> > > true" and set "mmap_locked=false".
> > >
> > > Now we call it with "mmap_unlocked=false" and it sets "mmap_unlocked=true".
> > >
> > > So far so good.
> > >
> > > However, collapse_scan_pmd() consumed "mmap_locked", now it effectively
> > > consumes "mmap_unlocked".
> >
> > Okay, I'm too confused for today and give up :)
> >
> > FWIW, this is the effective change, and the effective changes to
> > mmap_unlocked and lock_dropped ... confuse me:
>
> basically all the logic was inverted.

Yup.

> >  out_maybelock:
> >         /* Caller expects us to hold mmap_lock on return */
> > -       if (!mmap_locked)
> > +       if (mmap_unlocked) {
> > +               *lock_dropped = false;
>
> Lorenzo, is this correct? At first glance, shouldn't this be
> `locked_dropped = true`?

It is :) you're looking at the old code from your patch maybe?

I include my fix-patch again below to make life easier, but that code is:

+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped = false;
+			mmap_unlocked = false;
+			*lock_dropped = true;

Having one on top of the other is causing the confusion :)

I also asked Claude to check this btw for correctness. I'm pretty confident it's
ok.

Cheers, Lorenzo

----8<----
From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Tue, 31 Mar 2026 13:11:18 +0100
Subject: [PATCH] mm/khugepaged: fix issue with tracking lock

We are incorrectly treating lock_dropped to track both whether the lock is
currently held and whether or not the lock was ever dropped.

Update this change to account for this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/khugepaged.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d21348b85a59..b8452dbdb043 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
+	bool mmap_unlocked = false;

 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;

-		if (*lock_dropped) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped = false;
+			mmap_unlocked = false;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}

-		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
+		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);

 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,

 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (*lock_dropped)
+	if (mmap_unlocked) {
+		*lock_dropped = true;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
--
2.53.0

