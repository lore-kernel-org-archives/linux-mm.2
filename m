Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B68CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB638E0134; Wed, 27 Aug 2025 05:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BB48E0105; Wed, 27 Aug 2025 05:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A858E0134; Wed, 27 Aug 2025 05:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5068E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:55:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64DD6160425
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:55:48 +0000 (UTC)
X-FDA: 83822080776.03.918984D
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEA05160008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:55:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756288546; a=rsa-sha256;
	cv=none;
	b=N5FM6VyRDd2QuPrYcZ8VkWeWqcsDsPL4AIQMhkl/aUckQ87HWMB+A5H34IM+0mR3Vj485u
	RInzcOmSO7EEukQ+hyyamMovasQ7QEFsLzIfIDEgoFw4Gx72+1ZjpmQ3IP/83rT0hVp+fs
	N42iDJ6JF8wNvc4DXck7oegjU/KFfGQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756288546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5yJOYyrxfWPA9HnhzxFbksXpLb/m//V68LvDtzigScg=;
	b=5wF4cD2wPGXT6+jgdXeSWO5TqrtyOYCA2khIN5i5ZDb6wvgM/ZzeDVoj8fOhTnOmmxBrGH
	KAVNyk/IBKoA3HV7bm9XGHdWfg/PeR61vabYXOuWvdW0Wd1lRyVI5wmPDDGJHsyJSvAzn6
	gWp0vJv86Lvu6OAfiAtUTJwwS0PCjRo=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cBfzH59XmzYmb0f;
	Wed, 27 Aug 2025 17:55:23 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 17:55:40 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 17:55:39 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <liam.howlett@oracle.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <surenb@google.com>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite order
Date: Wed, 27 Aug 2025 17:55:35 +0800
Message-ID: <20250827095535.13979-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
References: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEA05160008
X-Stat-Signature: xoumr4nqim3gb11je19gyhqfcsm3rexn
X-Rspam-User: 
X-HE-Tag: 1756288545-523189
X-HE-Meta: U2FsdGVkX1+aQl9/x0poTE9syUn06Cxs4UJniWImeFgfQ8sl+bEeEu9gEv3MMClvMYtMQttvKY/I8POucYS913AgDm1DWfPiumKuEycqqhmc1FnqWzpC3a211Ukm1pvMzXpyzhifrbvr6ylFFYoUm7JPP0l1a67/4YVLZGVcrx5tOBbmkoYuPfgLpVAi4BCOlJd0Tri4xajQCeQfr6b7Fi51xMVoCeV5YH/exjkZTJOhO+7scNkWCjq0LgKNR917s/KBwHTRxxsQiwnojBYhQLavFI6ytaR//5JyzmEw8v3AkuzQomFr3daoNQtsf8wV7A4AUOcOhWMqJvLdHGqVHtSYpQ8MEgfSgJCq02VSS/Gg3wqlXWNBkSu+FTWQaCfpa8Mmfuf04udIxGksvMSGYJQT1d23erVGKh+Zbth76sr24dqR0SSMxtmTVb58bbsFRR8fbUbmyrYDbNDmZba1DUBaN/UziDyqQYAy0B4ltCPuCr6FpgNfQQCEhV6TRWFI8IBpy8rrNE6qBeGRekOtkFoobJhtBh99Mw4Fi3JV8ErecevhVqhKn7j3fpTjRhV2OB1SWks07A54cU2ljr+zeCERIzQprfM0M35qN6ntqA4sCrsEMqMCUXOv4kNY69NNPJHyrWlewg7YaxCSVHBgiT8AYqunV9lbSH2ku565VQv3zqH2UMhkzoxx/CWqfdb2QP/yWJ71fcrHgSLeBhV6nbNkNzn5vILhE+GnRqpa49XMWYjv83QqtLDMQWcb6NDu2XFFX6YGfIMb7J4rbf2yV9vHfuICsrmc2lNxOV1DW9YZ2j2g3MnA5xX+ywLxoI3uJW1pGWvuuyqSvO8JhokomfDG4+NjdK/anU+ZxDKmRjM1qYwbir2Xh92ELkagoqBU5q0H/LkmwtPZ8FYY1u2UnGGPr9pyWYkIFwXxNaEfd3fYPRxr8k2XgEOFXaoqXEL4EhBg85QVaWYp73Sn99I
 iYRTAd2y
 Z6lPT2ezzQzKHNGaeiLsc/Xwu8wZU1A5UnOmN6HvUykVwQcMglF3dFlA+c+BfF1gNAmbGRvO8mTRssTW826r7WQVYtkJAydCxtWq88vLqb4pTbCU6YsRh64myHl4jjM5pNjaTpDiMKbXcFXIIbRcoKx/kUjkj0y5RaR+Zvo4kOptoASWEGNfjKgclBJNNPps4870Yr7WAXSylxybe/vNt1hKLIRL1telw85oW2/0ytLsVBZ6I7i5QDWkwwZo6oOwypGkcSHXfnjdE9CIhipgg6qA0Or1xP3NDdFhXDdQUvCL7S2Jl4GF3J7z+LQPrYeAGZlSesHP6vk2Vomc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> + Cc Suren since he has worked on the exit_mmap() path a lot.
 
Thank you for your assistance. I realize now that I should have
Cc Suren earlier.

> * Shakeel Butt <shakeel.butt@linux.dev> [250826 18:26]:
> > On Tue, Aug 26, 2025 at 11:21:13AM -0400, Liam R. Howlett wrote:
> > > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 09:50]:
> > > > On Tue, Aug 26, 2025 at 09:37:22AM -0400, Liam R. Howlett wrote:
> > > > > I really don't think this is worth doing.  We're avoiding a race between
> > > > > oom and a task unmap - the MMF bits should be used to avoid this race -
> > > > > or at least mitigate it.
> > > > 
> > > > Yes for sure, as explored at length in previous discussions this feels like
> > > > we're papering over cracks here.
> > > > 
> > > > _However_, I'm sort of ok with a minimalistic fix that solves the proximate
> > > > issue even if it is that, as long as it doesn't cause issues in doing so.
> > > > 
> > > > So this is my take on the below and why I'm open to it!
> > > > 
> > > > >
> > > > > They are probably both under the read lock, but considering how rare it
> > > > > would be, would a racy flag check be enough - it is hardly critical to
> > > > > get right.  Either would reduce the probability.
> > > > 
> > > > Zongjinji - I'm stil not sure that you've really indicated _why_ you're
> > > > seeing such a tight and unusual race. Presumably some truly massive number
> > > > of tasks being OOM'd and unmapping but... yeah that seems odd anyway.
> > > > 
> > > > But again, if we can safely fix this in a way that doesn't hurt stuff too
> > > > much I'm ok with it (of course, these are famous last words in the kernel
> > > > often...!)
> > > > 
> > > > Liam - are you open to a solution on the basis above, or do you feel we
> > > > ought simply to fix the underlying issue here?
> > > 
> > > At least this is a benign race. 
> > 
> > Is this really a race or rather a contention? IIUC exit_mmap and the oom
> > reaper are trying to unmap the address space of the oom-killed process
> > and can compete on page table locks. If both are running concurrently on
> > two cpus then the contention can continue for whole address space and
> > can slow down the actual memory freeing. Making oom reaper traverse in
> > opposite direction can drastically reduce the contention and faster
> > memory freeing.
> 
> It is two readers of the vma tree racing to lock the page tables for
> each vma, so I guess you can see it as contention as well.. but since
> the pte is a split lock, I see it as racing through vmas to see who hits
> which lock first.  The smart money is on the oom killer as it skips some
> vmas :)
> 
> If it were just contention, then the loop direction wouldn't matter..
> but I do see your point.
> 
> > > I'd think using MMF_ to reduce the race
> > > would achieve the same goal with less risk - which is why I bring it up.
> > > 
> > 
> > With MMF_ flag, are you suggesting oom reaper to skip the unmapping of
> > the oom-killed process?
> 
> Yes, specifically move the MMF_OOM_SKIP flag to earlier in the exit
> path to reduce the possibility of the race/contention.
> 
> > 
> > > Really, both methods should be low risk, so I'm fine with either way.
> > > 
> > > But I am interested in hearing how this race is happening enough to
> > > necessitate a fix.  Reversing the iterator is a one-spot fix - if this
> > > happens elsewhere then we're out of options.  Using the MMF_ flags is
> > > more of a scalable fix, if it achieves the same results.
> > 
> > On the question of if this is a rare situaion and worth the patch. I
> > would say this scenario is not that rare particularly on low memory
> > devices and on highly utilized overcommitted systems. Memory pressure
> > and oom-kills are norm on such systems. The point of oom reaper is to
> > bring the system out of the oom situation quickly and having two cpus
> > unmapping the oom-killed process can potentially bring the system out of
> > oom situation faster.
> 
> The exit_mmap() path used to run the oom reaper if it was an oom victim,
> until recently [1].  The part that makes me nervous is the exit_mmap()
> call to mmu_notifier_release(mm), while the oom reaper uses an
> mmu_notifier.  I am not sure if there is an issue in ordering on any of
> the platforms of such things.  Or the associated cost of the calls.
> 
> I mean, it's already pretty crazy that we have this in the exit:
> mmap_read_lock()
>    tlb_gather_mmu_fullmm()
>      unmap vmas..
> mmap_read_unlock()
> mmap_write_lock()
>    tlb_finish_mmu()..
> 
> So not only do we now have two tasks iterating over the vmas, but we
> also have mmu notifiers and tlb calls happening across the ranges..  At
> least doing all the work on a single cpu means that the hardware view is
> consistent.  But I don't see this being worse than a forward race?
> 
> As it is written here, we'll have one CPU working in one direction while
> the other works in the other, until both hit the end of the VMAs.  Only
> when both tasks stop iterating the vmas can the exit continue since it
> requires the write lock.
> 
> So the tlb_finish_mmu() in exit_mmap() will always be called after
> tlb_finish_mmu() on each individual vma has run in the
> __oom_reap_task_mm() context (when the race happens).
> 
> There is also a window here, between the exit_mmap() dropping the read
> lock, setting MMF_OOM_SKIP, and taking the lock - where the oom killer
> will iterate through a list of vmas with zero memory to free and delay
> the task exiting.  That is, wasting cpu and stopping the memory
> associated with the mm_struct (vmas and such) from being freed.
> 
> I'm also not sure on the cpu cache effects of what we are doing and how
> much that would play into the speedup.  My guess is that it's
> insignificant compared to the time we spend under the pte, but we have
> no numbers to go on.
> 
> So I'd like to know how likely the simultaneous runs are and if there is
> a measurable gain?

Since process killing events are very frequent on Android, the likelihood of
exit_mmap and reaper work (not only OOM, but also some proactive reaping
actions such as process_mrelease) occurring at the same time is much higher.
When lmkd kills a process, it actively reaps the process using
process_mrelease, similar to the way the OOM reaper works. Surenb may be
able to clarify this point, as he is the author of lmkd.

I referenced this data in link[1], and I should have included it in the cover
letter. The attached test data was collected on Android. Before testing, in
order to simulate the OOM kill process, I intercepted the kill signal and added
the killed process to the OOM reaper queue.

The reproduction steps are as follows:
1. Start a process.
2. Kill the process.
3. Capture a perfetto trace.

Below are the load benefit data, measured by process running time:

Note: #RxComputationT, vdp:vidtask:m, and tp-background are threads of the
same process, and they are the last threads to exit.

Thread             TID         State        Wall duration (ms)          total running
# with oom reaper but traverse reverse
#RxComputationT    13708       Running      60.690572
oom_reaper         81          Running      46.492032                   107.182604

# with oom reaper
vdp:vidtask:m      14040       Running      81.848297
oom_reaper         81          Running      69.32                       151.168297

# without oom reaper
tp-background      12424       Running      106.021874                  106.021874

Compared to reaping when a process is killed, it provides approximately
30% load benefit.
Compared to not performing reap when a process is killed, it can release
memory earlier, with 40% faster memory release.

[1] https://lore.kernel.org/all/20250815163207.7078-1-zhongjinji@honor.com/

> I agree, that at face value, two cpus should be able to split the work..
> but I don't know about the notifier or the holding up the mm_struct
> associated memory.  And it could slow things down by holding up an
> exiting task.
> 
> > 
> > I think the patch (with your suggestions) is simple enough and I don't
> > see any risk in including it.
> > 
> 
> Actually, the more I look at this, the worse I feel about it..  Am I
> overreacting?
> 
> Thanks,
> Liam
> 
> [1] https://elixir.bootlin.com/linux/v6.0.19/source/mm/mmap.c#L3085

