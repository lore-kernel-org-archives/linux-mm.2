Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2FBFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236996B008A; Tue, 28 Apr 2026 03:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E1D6B0093; Tue, 28 Apr 2026 03:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1250D6B0095; Tue, 28 Apr 2026 03:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 012716B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:01:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5C18A04BF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:01:30 +0000 (UTC)
X-FDA: 84707068740.03.CF2EF5E
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id BBCDFA000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:01:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eWDcf934;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTLVQg4AUPoFhh0/dMQ7jJusBiykhYrOEzhYSb0BkVI=;
	b=KolLWk7Q5dKntp7H7QMoqh4nSi8RhNz4e+NlU07DYIqFyfmuFbUOUnG2pZGswt6U0+eRN2
	v3kvcDJOjwx6KUAe1yR6hKLMp8tTq52YTHvj34+1NGj3y72N9we3vVUMHkneq9HG+EBrVP
	+7utC8uw1tEIb6i4f4/JmqGP9cQQg2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359688; a=rsa-sha256;
	cv=none;
	b=cyoGVUdHnWVK0zDngGsp2sZvXQ9IKQASyJxPrwoxPexv4x2N91uYG7FIJXQi9bkPq/53cz
	aXcwKUggpYmuKgzCM+9Jw56UpC5moMYeDRk9UNeUmlD0OL0CeZxo3Ob27irJ9uL2tNf5Vx
	tGvmU2QCNEruKRNDY2sH668LWbmxNgU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eWDcf934;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891f625344so99414995e9.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777359687; x=1777964487; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CTLVQg4AUPoFhh0/dMQ7jJusBiykhYrOEzhYSb0BkVI=;
        b=eWDcf934MBz/ioQ8mLODitiFfvyc34/txSVXrgPEfJNoxAkPswWw8tQIEfWME4Drmp
         7dJd3j+ib4JXuQjHV67fgxXSdL5xWbZWvW7JgElODm3NwMjoTHI2Tnj8kDM89yhQk9lh
         eFLVPvMBD3M5TnHEs5sOVMC6nlMrzVtCPi6seWuwFVrQHnUTtICfuahrkrWVGoRgbozy
         RPDofrkvx0GcLGXJ+yqpCKARJU9sUaiFFu11zi2zVVRp7gIwy96tUYBda4NLH/Of1Jt9
         jrI4+velQA5f1NORspBH3h+swlKHJVsvnN/ZyaOxhjBt9iPnw9i53PcdlkAp5QAVL41j
         hkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777359687; x=1777964487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTLVQg4AUPoFhh0/dMQ7jJusBiykhYrOEzhYSb0BkVI=;
        b=PV6dwN3Npq/O8/N9psvQgl8AA1+CWeI5uG9heMM6Az8qc3ldWXJBryEHdQ4qfR+Yy3
         BN39LtNzyDTu7Y38jeAkg25g14KVAGSs2sxI8SSnex72pBS7NlIiJHvdcUWE8vzpL/ep
         E6ujusmLpIUrKLWFXeuH7smIWzmBtUmwhjqvL3D1TCNGZeZ2MtLXA9S/hWRv/roU0Z83
         x15ubjEKatrhk/ZVRcdeuojGBt9WIEZ85Iwfi3z5DTejRCzveE28MWpt5X9o21xFcjbo
         kqaAni9s4xcsGS33OG7y/PplZmvC74RrjN1aLbHvCzC7c80/1oYzWiLuAhZ9WUgTObiP
         AJ+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8CrMdWufGtl08qQVqa0f1A8TiK+Hk+mh7HuMzZCldCmFkYoH0rsinR0i0JZRR1ke9P7k+muDLo+Q==@kvack.org
X-Gm-Message-State: AOJu0YxTjoYqcAP8jEZFD7Ar+ofYHQ9+tdfDKWTb9bBnAOkgUio4hz2b
	iBv2igH3SQKkUepuUAkgzpRxTpaG/3WV6bnlwahsbfEgSb6yi7W4oG0eFcXzGP/j8fQ=
X-Gm-Gg: AeBDieubH9hXDJ2ESvqgjpgCFw9XrsLG7ZUJILWLwS0VfReMV1O0LirFo8rJFKveGqK
	/K2raVJ3yhOUz48kSpMVM2cy7NIQUJWSymkE1BYMrXIbz5QScgkPv/XzwzAjOLr+w6DdPPcA4zV
	DtKeI0bRl3iCbkzH3wCSOPHQrsfGh6p0FUqW1fqpbvcY314q2opEz1+dyFAAtqKBM6UfDOCobr1
	d7jll4cGfO7j5sh0GwLMltD/0ZtXnfjdCGcXlrJJHQdsJujDcwj7rfl0O8G9Rn+WzATE9a2X1Mi
	AdYslaBAWSUOnPRI1JyMankHLQ8IM+xYppAPiCPTsLe7K8lH7eWnbbzjC4jI0L/9abIEvSOJTrG
	9xg0xTx2igKBV5dS4z+JWueFMa2C0JCMbp1U9SsnF8Wq/+Z+GXOGABGw4xYULYi3ywtyGcjFUgH
	RW8chliP9wwZR7tBXQoOyR2XXTwk8KPyRcYVKIvDASvCZ2TY8/Jt/Y2mdxng==
X-Received: by 2002:a05:600c:a403:b0:486:f893:56c6 with SMTP id 5b1f17b1804b1-48a78a391b9mr13790805e9.10.1777359686867;
        Tue, 28 Apr 2026 00:01:26 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a773efe04sm37690385e9.12.2026.04.28.00.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 00:01:26 -0700 (PDT)
Date: Tue, 28 Apr 2026 09:01:25 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afBbRUaGnE8WZIkY@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
 <ae_dRZ95dCDTTxaQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae_dRZ95dCDTTxaQ@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BBCDFA000F
X-Stat-Signature: gcpysb3sb56xhqtxxi99cd56c9q4eghb
X-Rspam-User: 
X-HE-Tag: 1777359688-274738
X-HE-Meta: U2FsdGVkX1+eM+yhLU0rxp16o/qDAYM3F6hvUbsq4LWGWQ95LBstcnLqFwsq3rZ1E+aY+KTzYwGAraSsaq76Q5ux/6GJdM+a84o0R73rmjHoV9eCQn9kOzIOUfaCxbH+h63MyBY+Vc84Fz0PNL/RCKfvLbZPRCGz2YgWIe+6S7scz1IWiAtQkR5oar66zf68bgk/vWt+nvOUb4LIef/bI8WIKQQCjphmyR/IPVEixUPjH5ghByu6ALsPG9cMc3CFxHeTR0vwVdvtwYKluWVv8cr77GkZXYOykrWRF3XZP7t8KtLBX3mplR60lEYJdhc4GdJkNDqHc4Ot9em/g0cEGm6krCbU79Ssc4TI8laWW9yLZ0C1JUlzbdKUuLBiJSnuwybGeUW8OoPo9ZqoA7kSv2BifIt3gDbmgImQS/u5DwpHu+D3ULY99wgIng4ISsCJ6QC+Qx/iJATvZWKV4uuYeS5EQeDmmqJAG3lqPvosMHV0p89WzCG9s5LtijabgIAQtQJumJwkmRdbIgBoFCuAOtBtcwkGsUr8nT4VLHFMdgeUfTtdReVm/PUpmatUv7OaijOr1l1eKw0lzObjCfGAp5nNhjnsR0ocBPV3967qTigvIG9rEj+GBlWTBwD1zS2KCQ8C68zvz1nCi6dit5Fe1J6otMmG5r22eeDfg8uSLwR1/RdVzuXmZe3Chq6TldpfsYNqMq9L2ZR8eH8Qd5PfsejuQc444kRPUrMpNkiSX8VAqW0z02VQUq/70hlNRJRvT/OFrV1juRu8nSYpDChOVvUzINKNMSHnmMGYrLPWeJsogFAFR43hMnldVJMXdfPrXTxDdFi7zHA8AVwxA9kt8FR+BZnmVtg+hF+AXEUpfbX08rsJ+Ag8vAvbyQDec3R6dPf73u54QQigpTa6BeW4Lmux66o43Sn9y3R7Mn+qmbEda36R6pyWL0P9B+j1fGIRYjOvrLRmaHKDWNmI5Ub
 KIOz5h/4
 p7k237zAyf4JUiOUNNKIcdy5jJ+BN8Ww3+FIIuAl+mL6tkxK8IscCqtSLAiTMw4rA6sGY0KV+585fZllxeND+b7Vf4tI28pgCMF5vC9uqUxtba8VXtq2jo36bNcgHKCXhksOyHYFlviW4j6wHBQ6A4sW+7fagtFvGXdyiZxA+o9QacghJ3x4S/9DoyM76okvbVpYIzFl/P/gHeCJMHMajlZayVw88ESFWrlbeGS1D4F8SpuoD9D0ENNOVQg5KfmPdZiwy9WtllNwHa9Pt1xssMFKR9a5AUSX+bAyKVMAOjA1IgcKni6Sz2kMymH2SWJYLUk7S4wi+/zPPp2fGwC7nmZJM/lUP150/GKGZfa8IQUPq7H4rjvctKaHbopHbEZ6mzv5P+vb1zds8QnoMlbiAxSigg5i4gx16kpOfJjLA1xflo3siT3Ne8ORasGRfikhNX91w+Atjt0TMGMbjOTKhY69mCVZr44IcGNxS9wNaNWyvG/RB1c3ps6R6rgsr0AxhSWuAsHtvkPPvWUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-04-26 15:03:49, Minchan Kim wrote:
> On Mon, Apr 27, 2026 at 09:02:39AM +0200, Michal Hocko wrote:
> > On Fri 24-04-26 15:49:19, Minchan Kim wrote:
> > > On Fri, Apr 24, 2026 at 09:57:20AM +0200, Michal Hocko wrote:
> > > > On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> > > > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > > > prior to the call. This separation introduces a scheduling race window
> > > > > where the victim task may receive the signal and enter the exit path
> > > > > before the reaper can invoke process_mrelease().
> > > > > 
> > > > > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > > > > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > > > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > > > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > > > > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > > > > VM accesses) frequently delay this teardown indefinitely, defeating the
> > > > > purpose of expedited reclamation.
> > > > > 
> > > > > This delay keeps memory pressure high, forcing the system to unnecessarily
> > > > > kill additional innocent background apps before the memory from the first
> > > > > victim is recovered.
> > > > 
> > > > Thanks, this makes the motivation much more clear and usecase very
> > > > sound.
> > > > 
> > > > > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > > > > an integrated auto-kill mode. When specified, process_mrelease() directly
> > > > > injects a SIGKILL into the target task.
> > > > > 
> > > > > To solve the race condition deterministically, we grab the mm reference
> > > > > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > > > > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > > > > victim from calling exit_mmap() in its own exit path.
> > > > 
> > > > Why is this needed? Address space tear down is an operation that can run
> > > > from several execution contexts.
> > > 
> > > Agreed.
> > > 
> > > > 
> > > > > This ensures that
> > > > > the memory is reclaimed synchronously and deterministically by the reaper
> > > > > in the context of process_mrelease(), avoiding delays caused by
> > > > > non-deterministic scheduling of the victim task.
> > > > 
> > > > The memory is still reclaimed synchronously from the mrelease context.
> > > > This is really confusing.
> > > > 
> > > > Please also explain why do you need to do all that ugly
> > > > task_will_free_mem hoops. Why cannot you simply kill the task if
> > > > task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).
> > > 
> > > I wanted to handle shared address spaces.
> > > Even though we are okay with the target task not being in a SIGKILL
> > > state yet (since we are about to kill it), we must ensure that all
> > > *other* processes sharing the same mm are also dying.
> > 
> > Then just bail out when the mm is shared accross thread groups, rather
> > than kill just one of them. Or kill all of them. There is no reason to
> > play around that on the task_will_free_mem level.
> 
> Kiling unrelated processes just because they share an mm is too radicical.

Well, that depends on what you try to achieve. The global OOM killer
does kill all tasks sharing the mm.

> Thinking about quick check whether mm is shared.
> 
> An idea:
> 
> `atomic_read(&mm->mm_users) > task->signal->nr_threads` to detect sharing
> across thread groups without looping like task_will_free_mem.

We have MMF_MULTIPROCESS. Can you use that?

-- 
Michal Hocko
SUSE Labs

