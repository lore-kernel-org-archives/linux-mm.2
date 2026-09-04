Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14B1C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22806B0095; Fri,  4 Sep 2026 00:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D851E6B0096; Fri,  4 Sep 2026 00:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75FC6B0098; Fri,  4 Sep 2026 00:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3E3A6B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:38:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 388DA1A0178
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:38:35 +0000 (UTC)
X-FDA: 85174823790.22.2C6009E
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	by imf16.hostedemail.com (Postfix) with ESMTP id B83F5180005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:38:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xK0iwBCb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4engrMNNsNmi0Sa+tnBKv+aAI6wCm0Hhdb4ovtrCCMI=;
	b=XY97STPC5ogwJVZVckekptXgjFr/2hPI++uTON7BeK9oZaeWvcZfFiizrJ/vDpWGTRJn2r
	T2V7Lp5L8RA2lhGfPTrSytL7HpE/vQ85eaVqkIBt0LuMcfFClSPl1IM+mANdcaSMPGrRSU
	CNUD2KMtca+J0sKXwnZcAzCpm3Ayq10=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xK0iwBCb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496713;
	b=aV42y7w4UzZ/gdkwgqnzeBS2SUy+crppODSUFtOEcomzj6mqTyGFIcp+c2l8zp9RgiExkP
	YBtbGlTobtHsSdilw+Cbqt8AaiD8sJnCc++mCV8+nE8UcTYj+rxIzGsVkaeDbPYwZ6nlBA
	o5OfkVfwJsshueJZAk7YKiHLW7qG1+U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L0UbUp06gHwMCscwdZqV33gNL+S92LZBbhBL0xy2W/M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788496709; v=1; x=1789101509;
 b=xK0iwBCbdHfKgAND7PRnB4XIAU+7tPDSe2fYmlc+5+WBhvWs/NpDE5rmaI3tUxF9npdi4nG+
 AyZWkzgT2wG/8h0aFMbYiZTH8/fIr20Qb/m7OTOLJj+W5Md9vVEE87/nyjXibl4KssFO5nUCxkZ
 f/Xjo1aQ6KI1MzrCJHt5RKNs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5081a0fd8578ea85;
	Fri, 04 Sep 2026 04:38:29 +0000
X-Mizu-Trace-ID: 5081a0fd8578ea85
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 12:38:25 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <appLQR3JAFOZERJt@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
 <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
 <apeWczinE0zVkDAG@fedora>
 <CAGsJ_4z6SKTUeV2=OH67QPm4+JE_Lvw0rRsd3=H5F8EX=swBYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z6SKTUeV2=OH67QPm4+JE_Lvw0rRsd3=H5F8EX=swBYg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: reft6d6ugho3nqrfy6ezcgpfgcbamdx9
X-Rspamd-Queue-Id: B83F5180005
X-HE-Tag: 1788496712-570702
X-HE-Meta: U2FsdGVkX191bg0jHib1x/vlo1cPb9oDgNDENCbqkXN4gj5FiZ5GesBDvrBohc2zigtb3YFbOt1cSjY5Z7MhFh2HLp4stagMXV6OZ/ixFeK8YQiUspCxWm1f0JUVEm7sZFH4ElEW4ueQKpohmoYwiu5/q29Twk3KWwlMQLdeeGGfqucvwchoZQT3f3EBbOeaoacJgdmn+a6TjV1UOSzA9rALGV7QucJTYRd0whwR+LpvOPx8QwdrgJrYiLlxErUxqbFXryoiCey3MYF016Updmo/DfPbaUxqxZ2ZekMEDwtaHQGCk0la/LJI76jii7aWoAS3an54pcbisuoJoRqz7mjXVcQDJdcMdwFrFnkznYXRWA2lShdZ5Vh85YatCUd248CjMwAIUUg8B+CfArP2Q9spqQYlTR6aOIzt199O38ywQqAJR1oEb4RyhrsAnhuvOCRzY7b9oFYoYEUwMNMTFbvcy/bS2Z6iZC+YCjCQvN2ztcgnbDLvOsMrKN54cJbkQjZBJVle+9TzEH/9034hia4ELiss6420OYUADsy241M23MW80B+GHwumbjidDFr6yzIvJS+Bk5ghIno4oDME3waNzArIx+55n2/KFk7S5eNssdxoT6KdVS7lMzHWlRbEBtqjIBC4CL2th3IwqSFl5VUKX9h44/4BVzTXvqKanEllHrrIszXYrqlP/mIIw4wLt7q+a0rRoXruEJQZcZR7nPPEDiUHTqogC741gO1z5tyhbGE/MOIZ9r+yDeS7tEYKjsdAhurj3DnV9+858WhbyDC9FZr1qwl5N3wFVFStvEbudh0QF/zXqNfGuA+qi+SAmArNByMiXJYwACi6fIjEUCNeuLAr7uXrDr6c178RZRCMzI9nvMGs5NQMc9SN9sJXgKZ6+cVGMV9B0wuyxPHmcWgw+OSUuV4ZTBH67RHBBxsTjn0AOwQosczBTLxJ8meAf2vKGd7+E/vdEnL+gkD
 D0uhN/G3
 /rOJAcD9GhH/0Ix3uEAZPdArN02wI29zGMehD1zTedf7l+1am5JmeGhY1fPcCUcVaNT4MI2GSZsBN+NPuuenpfOah8A4JRqJM9s+KIfvxjLjRDl70APCVX+RY0T3GcEOkrXbn6JNkOEbXBNrU2LhYPQJT+emI4KG5gwTDD15kWWsbaxFMlJzAmq69dbkPp60b70BMIN3W+ogUJ9yPCFGmF5+X/5M+ONI/AbrrWYfAIt2oMhB9aqm95S53i6w9ca4H1b/NKTrQFkQjH39zet3gjaO0PuGERBw8G81Jx+olgPuxtEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/04/26 at 11:41am, Barry Song wrote:
> On Wed, Sep 2, 2026 at 11:22 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 09/02/26 at 07:53am, Barry Song wrote:
> > > On Tue, Sep 1, 2026 at 2:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> > > >
> > > > The aging walks into every PUD and runs the PMD-level Bloom filter
> > > > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > > > up:
> > > >  - walk_pmd_range() now reports whether it found any young leaf entries,
> > > >  - walk_pud_range() records that in the PUD filter, and
> > > >  - on subsequent generations, skips the whole 1GB subtree when the filter
> > > >    says it had none last generation.
> > > >
> > > > The double-buffered filter flips with each new iteration, so newly hot or
> > > > migrated-in pages are re-checked promptly rather than suppressed
> > > > indefinitely. force_scan walks bypass the PUD test, so manual aging and
> > > > newly added mm's always rescan and re-populate the filter.
> > > >
> > > > To keep hot regions marked, also report the covering PUD from the rmap
> > > > feedback path (lru_gen_look_around()), so regions whose hotness is only
> > > > observed by eviction will be re-scanned.
> > > >
> > > > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > > > ---
> > > >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
> > > >  1 file changed, 47 insertions(+), 5 deletions(-)
> > > [...]
> > > > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> > > >         lazy_mmu_mode_disable();
> > > >
> > > >         /* feedback from rmap walkers to page table walkers */
> > > > -       if (mm_state && suitable_to_scan(i, young))
> > > > +       if (mm_state && suitable_to_scan(i, young)) {
> > > > +               /* the PUD entry covering the young PTEs scanned above */
> > > > +               pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> > > > +                                                    pvmw->address), pvmw->address);
> > > > +
> > > >                 update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > > > +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > > > +       }
> > >
> > >
> > > Hi Baoquan,
> > >
> > > I am really not against this idea, and I believe it can benefit
> > > NUMA cases.
> > >
> > > That said, I might be being overly cautious, but I'm a bit concerned
> > > that this re-walk of the page tables could slightly hurt machines that
> > > don't benefit from the PUD filter at all. For example, Android devices
> > > typically have relatively small amounts of memory, so a PUD covers a
> > > really large range of their address space, which is unlikely to be
> > > useful on an 8 GB Android device. Also, `lru_gen_look_around()` is a
> > > really hot path. On Android, we've observed that it can consume a
> > > significant amount of CPU.
> > >
> > > Is there any possibility of implementing this in a low-cost way?
> >
> > I made a draft patch, could you help check and test if it's performing
> > better on Andriod device?
> >
> 
> Hi Baoquan,
> 
> Actually, it is quite difficult to run the latest kernel, or even a
> patch against the latest kernel, on an Android device. However, I can
> run it on my x86 PC, for example, by setting `mem=4096M` or `mem=8192M`
> in the bootargs to simulate a low-end phone.
> 
> I may run kernel-build on it and collect the perf data. Once I have
> the data, I'll get back to you.
> 
> On the other hand, you could also investigate this in parallel by
> emulating a low-end device. :-)

Sure, I will test and investigate from my side. Thank you very much for
the effort on testing and investigation.


