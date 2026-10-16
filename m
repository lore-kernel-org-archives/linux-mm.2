Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F04CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83446B0088; Fri, 16 Oct 2026 02:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33F26B008A; Fri, 16 Oct 2026 02:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922ED6B008C; Fri, 16 Oct 2026 02:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7FD6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:55:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 457A9140149
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:55:01 +0000 (UTC)
X-FDA: 85327577202.19.AE570FA
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 340AF1C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:54:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gNWOHQfg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792133699;
	b=MOtU85KkMjpRRdxkQmdHGwFBsgliVPO0cQNlGscHn+gtzgy0SzBCB1gsSvE59eqThtclAH
	vX6+FBFwPI2qsTQefwk+8i7X5ej3Vob896n9SKEDYm21IHAPwxhELSTv4ptGPIgg5CiXO9
	67A1JigESfMT+Hsgva395KBXKaTMGFA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gNWOHQfg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792133699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4FUcPRLKbuW4HkGF1Z/uZ9MIZyrAfZgEtA7+269nGA=;
	b=VG+7hf05m7wBV8jFjqOTb5BJ2N+IrUmSXfjlc5Rvv8hRXi1YvOCCdSFKIkIjlXpA+S0nU3
	A7rZAtNuj7LECPF1C5kz7Eaz8+aqsGJCufha7HegOSiLkcPQaxsj71SjU54KDfvF46rDTb
	QMXPVXFWCotCIzPF3CYhPpEmTDhZ6JA=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48df54150dfso886139f8f.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792133698; x=1792738498; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F4FUcPRLKbuW4HkGF1Z/uZ9MIZyrAfZgEtA7+269nGA=;
        b=gNWOHQfg69T38wl0+fwNaZ0lM/NXe6zjsK8iSGTkbbzc6PxEiGXIMM7j1Lw53FQQ47
         jwpLeFQ0l6MP8lmy0Kqva7XlRN3kmkpcTodKO364XHplYSqlxsfPfvRo/wmGPp24Lfg0
         uShZUrSAGIYfA9LVp/PXqyECPEstGLsTY0Y0ILU8u6VjBaJqpkmSprFc0LEJ0eqpvNHi
         oOLZSsATgGIwf0DEFbvI6cbpo2dztyEaKGc950MZfW0FhYEA4zmujxplZaHQSoTECTn5
         OJd2ATuAk4DZYQwo/dcMfMFMYx0wNxqGTL6L4i8zGZTm9Q9R4G96mSvxxaSN4OgPJ0pI
         K7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792133698; x=1792738498;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F4FUcPRLKbuW4HkGF1Z/uZ9MIZyrAfZgEtA7+269nGA=;
        b=wUK5Z54xcUxEGKSucS4NYUNqTAEzp6UswB1XWCIXwSaN7kXYhMnaUpwFzY7WFuLjA3
         O9+qt39xstOKm7ZD86PjbySjnkp/ltBxpVNlnmsMsyD4VuHF4Flt+C9Tf2ysJC4t9xR9
         //KbYYRF6DFWJWntK79CedbDRafSDCo8mPua18l5oQ71nIR2jGmVcDtkMrE9aVLrL/uI
         evErUOTKCGcd+izI2Jgoa4nz1LmsxpmvwnrYiG/YyE9JN290oZnHcj9dH5983V+hutnq
         pR+MpyTczkUp47kLH9wku5bwazrBGf82u6fWUY6RmHWSyV6Z9NY31k4Hnk7ZVZ2Cuc0M
         tBsA==
X-Forwarded-Encrypted: i=1; AKwUvByJM4uBw6fQZHczy6RcSIOA8pOnTu3WouS3g3aVmnwDgOQOo9cjeac4Q5cixP6eDxmPpT7jt7SABw==@kvack.org
X-Gm-Message-State: AFq9FYI3HqY2oCkWtyCDaWZJrsB2En9+ICykiT0Yyp/coUMpMsAsssK/
	Tn7qbfqhOFbqMk6tBAo6UINFXistltwTmsNUE8VnL9TR1m55O1bR13q3tGRYlmVSPqM=
X-Gm-Gg: AYBFou1QSXrEBpZ70sVj5Kqlm+OfwoqYvjbYJQHaxeeEYhdLmuZuxeMUrSuOlDIzjG5
	l4wbA7GGkQSir8FnPv0hvxdNHLStsF8y4mgBK4EslH4dpV+AVdEi8OWuwpiR37aGg1GlEpxrN7J
	wPGpYiHx5tX97g6/6jX6hPV+SsllxtNwx+CI7BTzGkKfo9R/rHRYBkSmj83G0G/jq7rJ2l1N3iz
	qQHJDgWf09ac7P+/fkZh4C5pck4gpm42Muw8NtcQAzYPFtdjbtJPBcN9U4QWPCWLBNMLeTrjX7H
	j1N0FOrNJ2L1DPSdws5d6cctGNrBog4gPn/VSszuSnTOSepres0FcwJOBLpUhOCOKKDJWo9ykMh
	dXlvnCeqkNAU7ATIFd5ta7foHUPJXSkoDMUnjHv8/bpCMHhlGG8I3mxaFTzLCEHEcVB8fD174lJ
	cyiejAn504+b8qraLmvkxxoCnGlcL3pFw53k9o1JvGURdwl9S/yMDwORTFZjHsXdo9WyQ2HEeih
	uCG0TuJgQyd
X-Received: by 2002:a05:6000:3106:b0:488:8bc1:a2eb with SMTP id ffacd0b85a97d-48dca34316amr34701413f8f.39.1792133697666;
        Thu, 15 Oct 2026 23:54:57 -0700 (PDT)
Received: from localhost (109-81-30-108.rct.o2.cz. [109.81.30.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd50d080sm3121319f8f.53.2026.10.15.23.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:54:57 -0700 (PDT)
Date: Fri, 16 Oct 2026 08:54:56 +0200
From: Michal Hocko <mhocko@suse.com>
To: Alexis Bouzigues <BouziguesAlexis@johndeere.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"liam@infradead.org" <liam@infradead.org>,
	"ljs@kernel.org" <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Message-ID: <atHKQFi0ckwxLa-P@tiehlicka>
References: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
 <as80Rpm-VHhP14aK@tiehlicka>
 <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atB63fzpLyfWpzPn@tiehlicka>
 <BY3PR05MB826006B6F1E2D97E247104BFA09B2@BY3PR05MB8260.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR05MB826006B6F1E2D97E247104BFA09B2@BY3PR05MB8260.namprd05.prod.outlook.com>
X-Stat-Signature: xhuko7zmptnbqdz1pmgrjwubi3bnx67f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 340AF1C0003
X-HE-Tag: 1792133699-441365
X-HE-Meta: U2FsdGVkX1+th1pseHSMTDz1Kptd5WOz44TPwH2GDYnEGVlHgO+RBnEURWOSVmxT+I7Lkdza96I3FWUCqOv8Q4PHc4Y2uiLHYWzN8NA543ykEXMoj9BAfEF9bL2/NQ9WYVh2FHpVMS4sG/aZO91teOu74xiUdUvOL4Luq1pldld9D6/rBYPDHs528kkz+DUp3mqN98KWGBGRj6V7bKTuiB/T0Fzlia26hLQolwYL/IPO8IlcrFhaatAvgblHKC97jyL45q7Zihx40uTDilT8X87+4Ej42Cr47myjSargtNSfv+Z6BGdJCXBhnhpxvAg9sx/EVnzLbIFgUgYxLO6IF3REE6pBAmR/6CT55qhh/KgS2yO94qAn0LzxYBEt6+8G2BUu6ZnFP4vSmwKa3sPyXzVMDw+ETdwR3z90/LAl+bxleBq4zNuomv+MIp3dS58YdWG9agJpCZnPtnQbaBAfJlGgLEptQ5+8FJlGg1MczCp/ZQWponWn9lcQFSMHvYCVGTpSj+eedpUbdSlchYYMC5A7T/itH4PDmAgmSTAer9wIw+TqS422hVWauT5Bm176S7yV7MRjTYQoJMPNGDaR9GlkqVqyU1H6kdDYeaSQM1UoG4k/ITPfxB3eHiDBpZbqKIPVJBeJCPuld1VKHOWVqUjRPFhHeHowsJvju5mLBThlAoUrcWROuF7HIG0joOB4qQ2isjjwULHg5r3AH6HnuPrFrWtvstngZUIJsOOd3Qgxh+BFIp6BV/UWbzC/WwTkNYZW0Swy4RGINiS/N4qIJHSpAPO1TudbpwfGepELn70EEJubfLqowIgXCOLf8why57omT2zltkZWg/dzc57dacBNl7G4MYONtxXy5KEU43LZ9hbJooHdis3pww10E6FZMeonrHjSUhcW0ngeDZOADdoSeDwh5q5Wy15l38gmOccYTK1hokXQxXryiBesku0MskdCllbliAinHMzEhRr
 TezocVWH
 Y/mC9xSQk2JswU15k0ogVymZiGV5W3YqPkpy17P/QqzNXJXDqQmt1eWiL+IOrIsQ+qCOOCSJ+4jGSubrYUEP+/cPJPMEMgOyg/2xitmTf7FrZyrWcaYqML2K366lVos4ZFSJRqsl1qY9S96vr2BwI+lyIWPxA5yIXotQynSYfo1QITeUh8x1cPAWEf/DhS78o4XiIW8KjGGFy3qtKtohLFNT1DVXZZ1A0f7E8jtnDdezXsJAodvkm+c6OFJ0rcJNkR9EyvICfVTYqMbXt3QqFpgTRF8RqgRKJQiKG5OkLWTCopjBHjxFN8X6av4d+2BK1D2WwOTYc9Zr/J4Gg2BuKYZrj0dWBbyPpQEqm6JuWfDOiCoXR6Bn5+Aj2cvYHi2wgQE5DZi7p4VXbkuTWU5QP/QihNDFq5J/imxI6lFfXaSGqC1Op5qISwyWZucvfz4D12noitWWbkJyWKFF7RUYleNjLoh7jvAWWnuo4N5JYTx8Uj2xY73sXZU6AvdTHzzdzrG9rHQYTmQt94jQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-10-26 00:42:39, Alexis Bouzigues wrote:
> On Thu, Oct 15, 2026 at 09:03:57AM +0200, Michal Hocko wrote:
> > Are you really looking into the code or just relying on an LLM?
> > Go and check to learn that the oom reaper is only compiled in with
> > CONFIG_MMU=y
> 
> Hello,
> 
> Sorry about that, my earlier message used "reap" in the sense of
> cleaning up the exited child in zombie state (waitpid), not in the sense
> of oom-reaper.

OK, this is what confused me indeed. Especially along with the changelog
explicitly mentioning coordination with the oom reaper
: Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")

The whole oom reaper chnages should have no impact on the nommu OOM
workflow.

> I also went through the code in detail today manually using a 
> backtrace from the reproducer. I set a breakpoint at oom_evaluate_task 
> (containing the MMF_OOM_SKIP check) ran the reproducer on v7.3-rc7
> through qemu-system-arm with gdb. I iterated to confirm the
> breakpoint keeps getting hit.
> 
> Here is a backtrace of the reproducer when the parent PID is livelocked:
> 
>     oom_evaluate_task                  mm/oom_kill.c:354
>     select_bad_process                 mm/oom_kill.c:373
>     out_of_memory                      mm/oom_kill.c:1155
>     __alloc_pages_may_oom              mm/page_alloc.c:4113
>     __alloc_pages_slowpath             mm/page_alloc.c:5030
>     __alloc_frozen_pages_noprof        mm/page_alloc.c:5449
>     __alloc_pages_noprof               mm/page_alloc.c:5471
>     alloc_pages_node_noprof            mm/page_alloc.c:5485
>     alloc_pages_noprof                 include/linux/gfp.h:284
>     get_free_pages_noprof              mm/page_alloc.c:5507
>     alloc_pages_exact_noprof           mm/page_alloc.c:5641
>     do_mmap_private                    mm/nommu.c:959
>     do_mmap                            mm/nommu.c:1182
>     vm_mmap_pgoff                      mm/util.c:581
>     ksys_mmap_pgoff                    mm/nommu.c:1287
> 
> 
> Inside oom_evaluate_task(), when the task is the zombie child pid
> victim, without MMF_OOM_SKIP it aborts the loop from select_bad_process()
> and sets oc->chosen to -1, preventing the oom killer from calling
> oom_kill_process on oc->chosen

Correc.

> Since oc->chosen is not NULL, it does not hit the deadlock branch in
> out_of_memory instead it returns !!oc->chosen (1).
> 
> Returning to __alloc_pages_may_oom(), out_of_memory(&oc) evaluates
> non-zero, so did_some_progress from __alloc_pages_slowpath gets set
> to 1.
> 
> Then in __alloc_pages_slowpath(), since did_some_progress was set
> to 1, it jumps to the retry label
> 
> As long as the system is out of memory, __alloc_pages_may_oom and 
> out_of_memory will get called, meaning that oom killer does not make
> progress and that the parent PID busy spins in the allocation.

Correct. The question is why killing the child, which has passed
exit_mmap stage sucessfully didn't help.

> If the MMF_OOM_SKIP bit were to be set for the child zombie process, then
> oom_evaluate_task would not abort and would select the parent, meaning the
> oom killer can now call oom_kill_process on oc->chosen and progress.
> 
> So setting MMF_OOM_SKIP as soon as its memory gets freed (in exit_mmap)
> would guard against the parent's mmap stalling oom killer, since
> oom_evaluate_task would rule the child out and proceed.

right MMF_OOM_SKIP will help to hide the killed child process. The
question is whether this is just working around a propblem or it is a
correct solution/workaround. There is absolutely no guarantee of a
forward progress for nommu (due to missing oom_reaper) and overall
nommu OOM handling is rather fragile and there is an implicit assumption
that memory usage in this platform is very carefully scrutinized to make
sure this doesn't really happen.

So the main question you should focus on to explain is whether your
specific example is  
	a) a corner case of a valid nommu application or  this is 
	   a theoretical problem
	b) why this doesn't break otherwise very fragile nommu oom
	   handling
Thanks!
-- 
Michal Hocko
SUSE Labs

