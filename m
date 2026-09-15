Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFC9C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5C36B0092; Tue, 15 Sep 2026 05:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77176B0099; Tue, 15 Sep 2026 05:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66486B009B; Tue, 15 Sep 2026 05:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71EC16B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:07:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37C98120378
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:07:51 +0000 (UTC)
X-FDA: 85215419142.25.46D7AFB
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B08D40009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:07:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FV28+kEv;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789463269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TwWP/MlWLXdLm6RBuOTRTjXHdybTzxOxvT40BpicUW4=;
	b=5Ecr4l/cowexBrHYQefyK2d+GqORGR5Z9MzZHcbsu4YDCLGVeeWeFjEK//Nmeiyc0Xs8hR
	gGC8RDM7OasJN2uwXCJY5af7XRsmhYF4xC3GdPfPkekw5PKWtJCOqznoYgsOlzCALWoBM+
	LR9t4FNnziRsGkyA+90UyPm5lFm6+Yk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789463269;
	b=63MyWmErYEGQz+39pzzO5lSFKXaD38VucFjyY8UW9qTNt03AvSNVhr7sm3eAH2NR6XrdRL
	6RZDSEcXj4ke5mblLM1w1EQJ/xaGKS5iaZFlHTj/BzgjdnYasVpu7w0kIcgll8szbW1P6k
	x+MhbuzscDiFEG3RXSanVcWbFGKn43Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FV28+kEv;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a99391ffb2so5229874a12.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789463267; x=1790068067; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TwWP/MlWLXdLm6RBuOTRTjXHdybTzxOxvT40BpicUW4=;
        b=FV28+kEv7gRbx+dT/4rGgN6p86RYkp/wRO4Tz0XnREDzzIdwUAyMst/In8GKynBoe+
         WVzQeqsKiE70+hx9TfZKZAPAnPiRhS4d1b21Ge1NAl/os8DfnaeeUWJeHOXSe/gsL0WZ
         dirqKbjGUODAd+8HqRPcjAHCPqzVExGDT2bz2a2i/hUndm++vp/MzSu5fZtc9Xchr5fv
         YjCHrSrC5j9fwtLNHRZjUFvWRRujdrh1XReVw1GuSalAwXd/wKUC6lXcdK+4F8OYVPll
         fC0m9xgbodcKtXknumBf48PrmeAFPW6Di/L4JB1FFp6hH9oAt9Fhk/IhEKK72iifoJAs
         kubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463267; x=1790068067;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TwWP/MlWLXdLm6RBuOTRTjXHdybTzxOxvT40BpicUW4=;
        b=DULH65yCA1s53BrKeIckcH0fuSxGfiloODyurb6wL9f7ES9GHvFOsUz825mZnwtPhs
         GUaNYCIWSjXQj09NA82UJd3TaJxBJgAEbG7oU5JutzLixvSa5Q3AUOMrt6O9o5l1cUUT
         hAuni6Hy0+MyRI92FDO2kbPPo/fxi4ONg9B9SiSrAoL/uMK1HanBXKYhUotw8GPY7Qe+
         AMfB82otk+WluZSA7w7zV9qUOyjmONPyNdA+/DOU4tGUjwlSlt41D3yoH/fJjdRl8rSb
         o3VB8YXsCNYvCACVvZdqcXB1MbOSVMoCvBBohEc9/DE3jrE6AKs6hLO8pVCe5Zd0pV3X
         xqfg==
X-Forwarded-Encrypted: i=1; AKwUvByYL2aFDz6G0tj9TbM09DLXiBN4H9OC+bODKS3kHEPdrpVp7vk0DWA5seLU7LC0DVudj9UkdKH6yw==@kvack.org
X-Gm-Message-State: AFuF++mz0Y0FCkYnT4dMwPWgZfJmuZuQxw04kEMwbwg3FxyZbYxHtmui
	+CebYg0xGOl/fIv84+PFbanLew/mvxJx0C6ZUxChKJPB1CBWB3j4guRX3UHLr2scQFk=
X-Gm-Gg: AYBFou1cTc3gLvN1QVpTZBq87dsqhhjOQSuUXDCJ8ShdkxSgA/BWDJmQDzBeRrkiNxi
	UQGAG/IIbHPnlc3M64MUEF2uCDg1+Dq+k1CFDJYLt2K8ILtsKxVpYxGDz8//JmpD4kK7olCi4CP
	oEvYGqZ0jQ9D5LsbQygUNL9mgoQCRd3r465xLwtZEmAvbesgmOIyWGY43dy7nHuaB2WThMq6ZDe
	Pv7IvVojw4p3zgRwP7IAcWt+uxrLZV/2XtlAtJtT7CgsmuZoBH0Wz60XX5BJfUNRAhfII05Rpc9
	60a8j7BcOJ7H47bgtSxCXSaN5tPCDl5LgsMOably8Pjoh2n3hjYss5ilSKZLst9FMT8jRbl+Gdk
	+gJhaYkBjSH+DiqgEkVdYt94iA8S2BdWlAiZD0cp1//oVpaFy+7wmW+U/CB78Z1i8x+63pwf9Pc
	w+uDAzuJc67BGsE9Avt0CNNpgZtrSu7F1Hk7hhsCLpsiAJW5r9p9pR5fUrxrcb
X-Received: by 2002:a05:6402:914:b0:6a9:bf3e:595b with SMTP id 4fb4d7f45d1cf-6a9f624e89dmr4274759a12.17.1789463267551;
        Tue, 15 Sep 2026 02:07:47 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b58f8528sm5417319a12.5.2026.09.15.02.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:07:47 -0700 (PDT)
Date: Tue, 15 Sep 2026 11:07:46 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
Message-ID: <aqkK4kR2_tYxTnty@tiehlicka>
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
 <aqg-oG2HDIUeK5Us@tiehlicka>
 <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
 <aqjsPW92SgcHONKO@tiehlicka>
 <3c8d1d8e-0e67-4d1a-b73d-4eadd6266aa6@linux.dev>
 <aqkAbBpYheX2DEHg@tiehlicka>
 <e018e3a0-349a-4f36-90e0-8fafb001da43@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e018e3a0-349a-4f36-90e0-8fafb001da43@linux.dev>
X-Stat-Signature: ojdeqaenmgpw44hbxmwrmaoyydzkhn6g
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B08D40009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789463269-550645
X-HE-Meta: U2FsdGVkX18mZPqpEkQP+D9DiS3zPGkS/WYahBuRFzhwRY6zRlcre8BylCpL1dlvzKJFZd8Q54K3Y3oAMKvz8Emg3DE7yYSohuWjoItV8bxkqvsHUimGhsa1eLO4skpKcTNkhFqGfsoJUbWxYMVBH1g3bPpl12gN6RU3gFoXiE87+qobUrjPCsySnrH9wbm4b4h3VFRe14pOCGfUsKpXLWSc1NvY1hrT+ZqzgcGe74FcLfjtN5eD9C/V8MotT4gyk0MCPBYLHkkPsl+SeERDjymtwR68EQHtW1C5FJM2R2Cr2zchCDtxGR7GKFrLkzuywwuRxaWV+ncj4ucul6wJvA2Sn1EFqT2ren49BmdanAZ4o0bPmSOdqQ/pdQ+nLLdFE3ulSzZszc9ToeqsP8jrAAafjzRaQ8NspHvv/8nFKHgUsxeshMHAR13RdF2y4B/aUnFBE5xTU/hvKMPPgo9CI2og2kABqFWBN/HQSZlhxLfoGkSFnElL2IfcfGnAlfzx5MAbai7n8Eq2oCgdrOvqSCGwP3flZfmpnLRzSQquZS65oCsAnZGvetCVWiCal76y/Zipakt4UkS3hE70MbXXqniHPbapYgSJ/tWpf5UzfC+v+l508pTVjiCU3ulCUr9G0Gs+nkM0FtR6+Qxa9McEOtrCHDVp2VVmA6Pzmgb599gd3eRXEfh6xHqdu1QHIuR8egeYZ75+ckDLeYydjwpza1HC9kRlxLdev1xopb+BtRKT0cOcOM77WjnjmYQxrQm0iDbTPmoHBQ/2ABq/4U8Mc+1JBSopjIKct7aGZLJrVUoQg4Rs75ubuT+Zt+BjSMzcGY27RF0Fp/l5+C7++R1++NyV3dW5C8DihR/Ueu1iEwH0EukNUyWPbYRFRvrweFm1vBt+QZPeFQvCKNKCYwi+hhW7sZEpElhcN9zp/DtkFB6gtONd7wG5JclTW5oRbSYIqvne+oSzSLB64iD+Htp
 NPvRMisq
 hjkmob3qD8Gnwvz2bIcWx7z/0H2tbFHLWs6a69jw2tpSt2beprsGmkLMY8mtqXI0fVG/bMP9enFOhPVInLblqOzboRD6/3L2hY402gkfu67PcZE1GIV2nQ34lyiNyDeHqrjoClcJO/Pfb7AqFVCWaPeW40Lnwta+YwykTPD7t6gJ0BZ7/TRbESLljd3GdCqT+Cirfxfba5E2lioHSuSuzI4HdjYhmckWHL5xxB/fWTHi8mrhaqe4+qBR/45ocMjnY2J11RIumQOhbSez4+NMubMNTpiMHZtKdqi3RxL3iDWzaotvfYfZdWQApYxpATmyIIy4CknWLHe/kDqwqaXPOyOVrvbJJ0rG8O3Qtah8Vc+PbBNeowWi6eQfefvcwwup6ZElpN8dhHpZ/0HetoRhlwu2h8xTliebbjnrwsbAPuzEr5MjbZioQs7iysON0znO1YTmP1reC8/yrB11TWqdtE/aJRBtXJgfw8rLlW+hdOhsCF8hB9Ebo9iKs9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 15-09-26 16:44:40, Jiayuan Chen wrote:
> 
> On 9/15/26 4:23 PM, Michal Hocko wrote:
> > On Tue 15-09-26 16:13:11, Jiayuan Chen wrote:
> > > On 9/15/26 2:57 PM, Michal Hocko wrote:
> > > > On Mon 14-09-26 20:35:33, Andrew Morton wrote:
> > > > > On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > > > > 
> > > > > > > Call Trace:
> > > > > > >    <TASK>
> > > > > > >    __schedule+0x487/0x1870
> > > > > > >    schedule+0x28/0xb0
> > > > > > >    schedule_preempt_disabled+0x16/0x30
> > > > > > >    rwsem_down_write_slowpath+0x1d4/0x750
> > > > > > >    down_write+0x60/0x70
> > > > > > >    __ksm_exit+0xb4/0x230
> > > > > > >    __mmput+0x12c/0x150
> > > > > > >    mmput+0x1e/0x30
> > > > > > >    do_exit+0x283/0xa30
> > > > > > >    do_group_exit+0x34/0x90
> > > > > > >    get_signal+0x952/0x960
> > > > > > >    arch_do_signal_or_restart+0x41/0x250
> > > > > > >    exit_to_user_mode_loop+0xd3/0x560
> > > > > > >    do_syscall_64+0x385/0x470
> > > > > > >    </TASK>
> > > > > > > 
> > > > > > > KSM is just the one LTP happened to hit: __khugepaged_exit() has the
> > > > > > > same write lock cycle ahead of exit_mmap().
> > > > > > Why is this a practical problem we need to care about? It is kind of
> > > > > > natural that the oom victim exit path might race with the oom reaper. They
> > > > > > share the same lock that is mutualy exclusive. The whole point of the
> > > > > > reaper is to ensure there is a forward progress achieved. So before we
> > > > > > start modifying this let's talk about any practical/real life problems.
> > > Hi Michal, Andrew
> > > 
> > > Agreed, the hung task warning itself is harmless, especially for a dying
> > > task. The real problems are what sits behind it.
> > > 
> > > With a 500G swapped-out victim the reap takes ~600s, and for all of it:
> > > 
> > > 1. The victim cannot exit. __ksm_exit() needs mmap_lock for write and
> > >   queues behind the reaper, so the process stays alive in D state for
> > >   10 minutes and whoever waits for it (parent, container runtime)
> > >   waits too.
> > > 
> > > 2. ksmd and khugepaged stall. Once that writer is queued, their
> > >   mmap_read_lock() on this mm queues as well, so both daemons stop
> > >   for the whole system for the same ~600s.
> > Right. But why is that a problem we need to fix? OOM reaper is taking a
> > prortion of the exit time by doing the leg work of tearing down the
> > address space. Exiting task would need to do the same so it is unlikely
> > to terminate much faster.
> 
> Hi Michal
> 
> Sorry, the subject is misleading.
> 
> The total work is the same. But with the patch the reaper and exit_mmap()
> free the memory at the same time, so it takes about half as long: 264s
> instead of ~600s here.

OK, I see your point, now. But rather than making the reapeing more tricky
and less predictable with I would rather try to find a way to remove
those bararriers.

> The hung task warning is not the point either. If that were all, masking
> it as Andrew suggested would be enough.
> 
> The warning showed that ksmd and khugepaged stop for the whole reap, and
> that only happens with the reaper. A plain exit takes the write lock in
> __ksm_exit() / __khugepaged_exit() first, which also removes the mm from
> their lists, and only then holds the read lock in unmap_vmas(), so nobody
> waits on it. With the reaper holding the read lock, the exit's write lock
> waits behind it, and every mmap_read_lock() on this mm waits too, ksmd's
> included.
> 
> So the patch is really about the reaper not holding mmap_lock for the whole
> reap.

The reason why the reaper was implemented this way is that it allows an
easier and better predictable behavior. You get your lock and nothing
stops you to finish. 

Write lock holders should be really rare for a dying task (unless it is
stuck somewhere in the kernel call path) and as already said
ksm/khugpaged is known barrier that might be held back without any known
downside so far. Tearing could be faster when running parallel but keep
in mind that the purpose of the reaper is not to make exit path faster
but instead it guarantees to finish unmapping.

So please make sure you exaplain why blocking ksm/khugepaged barriers is
problematic from the correctness POV and also whether it is feasible to
drop those (that would be great IMHO). Also, and this will be important,
how do you guarantee that the reaper will keep its current guarantees
when the lock is dropped along the way.

-- 
Michal Hocko
SUSE Labs

