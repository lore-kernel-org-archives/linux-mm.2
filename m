Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F337D37E34
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD8B6B0095; Wed, 14 Jan 2026 08:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7AA6B0099; Wed, 14 Jan 2026 08:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA5D6B009B; Wed, 14 Jan 2026 08:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 578D66B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:40:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C1C61BCD7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:40:15 +0000 (UTC)
X-FDA: 84330678390.21.56FB6FF
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1CEB2000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:40:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHREANDV;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5nEm7X8GKJZArjA3XXNFLR3YBACGijl/GdrWDkzdOs=;
	b=kir3EbKyQKaq/Jy+IEkXpXmYlzZ1Y9moMExAqD7QI+9SjX2lp7OD7DBZH7wN9iVRBW8rWl
	Wmda1FjMjeGM/Uy1xiC9YNOJg7IkesWG4TxQRPkRaHv3EbuhxzLYl9dL4k3js6lD86qKva
	W9d8d2SH1daUAn92VAexSwqi6FVr80k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHREANDV;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398013; a=rsa-sha256;
	cv=none;
	b=QpQKZbujsx2Xdi8C935zOM7ZfZsZvr87m5f91c7M+R2+U1c6bbA3iWddODr4F/wrfZWwtK
	3m/TIViNEQVhUJP51dsS+ya5elzfWZuTsam1Fmb2tsQou+Y9LphdSk96xQyLaWoP/tNucx
	FvDUsVnOvPrIhZ4+mT0TdiOTmUN4Y4A=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee2715254so4713295e9.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768398011; x=1769002811; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5nEm7X8GKJZArjA3XXNFLR3YBACGijl/GdrWDkzdOs=;
        b=dHREANDVzEP7TNY7zTsG45SR1PhTkqC24qaBiPVXiF8DSGs5I4ZAf65HbwmXT1UAOA
         sAfIhJdEsaiEq/RZjLU4CAr30/LLqkc5XhmFSv9KezlmHJa7508PaddVFHly0J023Q3T
         ZphziZ6EAiRqSnBGo+EKfB8wwA+ykLIpI7pO+d0l0fmaeKO0+K50SaG+6Fu1qJLkuKGf
         bUcLNR36bFO6EINOmXcxwwt4SnZG8X4qT6Y8c3Aq7BsQsS8u59a5ZTJyR0yzXxUBvaUy
         hhYPiDdeHhRp6i/bSUeziEbsY6CUyNLdjX3TNfcO8EivGHf6YdIO7OqF1ZbqaTpciPv/
         JAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768398011; x=1769002811;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5nEm7X8GKJZArjA3XXNFLR3YBACGijl/GdrWDkzdOs=;
        b=V2Rk0jfdwxdMMNT5EXXw9i1YlXqLxMOBqNV9/Dae+cNk7zT9UxDdPRslL+mQ2aDbYi
         0DHh3Djybz3hzDiRbAUpryu/rr8ajjc+qIfg3wJQ0JJ4JIveBZaajTZhHnKIIovHacfK
         /ztQER6hd6RoBXrGj/cm3U7zsRWGm484GS4yC91fNLejF1Y38ExCwOnOzrCbMPEVI6I1
         5GEq+RyexnokAaRUsLcc/ruw6DaxmttcZWnXNVswyoGMimGDWiytcYH+Vcrvqs4QMf+k
         iUw2Kmy8jhSNQi1BkUkyAOiohaslH31aQfINqtX8kL2xc03oo/rIPPQtQaz23E5nIJUX
         Nz1g==
X-Forwarded-Encrypted: i=1; AJvYcCXs5bqrviNA2o7p3mtTdNBD3DRZgXHKD9FzWyIiyx1pisPFhDkizJym9RzSTRTZEtrKbRQAPsxRiw==@kvack.org
X-Gm-Message-State: AOJu0YzzM83fGxx35rmFdb2MELOVVBst9x31U7lqahv6cV/6fTcVWzuy
	vSXYn2H9IBC22emzTJDgJsV6dh9uUWzvcr32XaMFnhbhAc8qRzAruVfZBPvFPC45fG8=
X-Gm-Gg: AY/fxX7AXoa9KjodhdYyyg5gS2+QyydqZ+hj/qDGcRM/AL8NKz8CIYwuPtm88SIw52B
	+HWpNphNal+s4A+rJ7siHWcFSIhaeq05BRYubWoI7XgCDHJmnXy6t2AdCfvjsoVO9Zv+YAhD2bw
	3MqDDJGZsg0QNW1tz01Xslo+1fBeQMOEOu6stA3Mkfw4pM43X2XWvDEDkDSLhpkGjx9GSkB8tvE
	ztJsD1IUWL9XHhVcLHIkl4j126fAne3FO4uBKDi+QTYB3IL6BnTwBuIRnCT4oVGIB+WVGc/ThtW
	J0uFIiSpkVXvQdohAyA/BfB/In+arTJO4HbQe2mJrGsmj2LYy5++mK460ZNlN4uwfOq5AhASMyy
	LxJpbscXMXsoUs+3jrWIxcLgkPbobzLvpTO1zMUQdibKLtU3EXl6pkumkZU3QFPGlD+kT1pgik7
	rdffGA53vGFLp/kLphQfAxfHxJFTUk6NIDh0A=
X-Received: by 2002:a05:600c:c16a:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-47ee334d0aemr36493285e9.17.1768398011351;
        Wed, 14 Jan 2026 05:40:11 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee27dffcdsm21221875e9.6.2026.01.14.05.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 05:40:10 -0800 (PST)
Date: Wed, 14 Jan 2026 14:40:09 +0100
From: Michal Hocko <mhocko@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aWecuccS9tGZgXe1@tiehlicka>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
 <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
 <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: jatcka655gry634dkeutfdeimxxttfoz
X-Rspamd-Queue-Id: F1CEB2000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768398012-634158
X-HE-Meta: U2FsdGVkX199Gaa0NOhOsXlrwMxPTZmdN7aO5a1oHSVfMrZzIgK++8zU9jEC2Q7xxcj6jVk5mj9vZIW6709Xr96V/UXxCEpHfBkR/LlaX/kIixgyB8tjGPTXsx3UTL0/wr+xG/vxiKa/uloUY7ZafHg2Hom9WW29BUfFYCSnMrHfcmCHY4B8VcUwVmNxciCMHgCjcSV/aIBZzprV1i+5QNbAIBmbsZ4enxqrQlTJA/PF64I0DoAo0Jk1FRYXOLXjvXySgIuBChNGfQp9sdI1wfJslTTyCYWP3nf4QnpUscJgeWMzt3Od1972xozhNCLVMfKT2UwdmMpT8HGaulvkt1pfs7lnSVQsW/HHDUq4AMCYhNzKKqB9HD0iLMU2koTu7cYqxIpcY7ARudGbe2Reo0R3tREX+bbljeZc/Xf8IpsrHgKk6GMvCjt4cf2WGIcWs+/pUamhMtVxIf3FyCLWN1yqER2gy/IM2xpYv477lezjcG1Nu80Jse+ausAfbKLdzUjEvNts4hellynWXJUyxQFILRrl8GqfwSo+SItHSawbwgrcCT9bjt19FqOvIpXFdvqJWZk/uUaeIlowX2gs688tJldTV3h6svuoiETK2aNq+tAsfAvfORHl9UcFYVTdcJfUJ/ye3Xa9A/nqY04GfwYTxque05BZdKkpja8RY89Kpl9G0vHniZgm10yQNgP/cpWgCyPADpVMQ6DAMFupjDgiW+tt+pDBIobT68lZxbnpH0hv+4U+55ivK5KOrRODK+PRZuXvsb4yWyD/Z2tgJk5grXflQD3NRteBMn86EqEZL3p7Z1/FPQ3nEsBhRZ7AEuicmjBXGirhkybGHNCcAthm6uu4aI4S6/Br17/+hGjF9Zc2dox2XBf2F+Gshocm/wfUIHdbcF+lWAYt11oUaB9zZStWq8t4vVehhDJXYkYr3wlN2x8EXSbxSNyksyCsfMdBBK92sKS/NI1l2Fv
 Z0yPnFTx
 +Hq9kH/XOqKgvVT8Osrfi6cfDWBDdKPjlEU5I8JBz3L99Sy99ddb7OgzdEHxL6OU/RDx2bVxm3x5BRElEcGH4CLXlUSdvBol3agSqf378GrfL206a0LZ/Tir+cjh1p7Yswm5R4f+aRznjLgzuew1jvuIyw3XGg85lXcXmAzqMPPHS5rmuvZ2F/ZX8tW5jMEK5u2n40hKnWhV0cKImdk+ueEHPt0WubtyTcm9sp9LbbO4vgXNmM2PKeLJdwKevkavmKP3ZZt1kEix1TjMdZo/wyz2gOnHJryTXkJc6nBbaUBqoKJB0xcDzPoS/ftq7zVykqWGUUdASFQ5dweAJpN/W0nKoqFRprmrd5tH4AV9eq06GkMfLGTD0rR/8FbO0ApGtWmLT3BLQWnWkL2gChOMmX17ae+6Vnix8npXjY14FPtavSs3ay1n1oe2UMEz7q9GlacnECB64zniENInbU9w5K1jpfM1HckUUuIACQfiGPyU+s30IF9vHPsR4i2Z6KJqVxUapz7tdFwwkUomzitzYlMH/XoohL4egvlUW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 21:51:28, Akinobu Mita wrote:
> 2026年1月13日(火) 22:40 Michal Hocko <mhocko@suse.com>:
> >
> > On Tue 13-01-26 17:14:53, Akinobu Mita wrote:
> > > On systems with multiple memory-tiers consisting of DRAM and CXL memory,
> > > the OOM killer is not invoked properly.
> > >
> > > Here's the command to reproduce:
> > >
> > > $ sudo swapoff -a
> > > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> > >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> > >
> > > The memory usage is the number of workers specified with the --memrate
> > > option multiplied by the buffer size specified with the --memrate-bytes
> > > option, so please adjust it so that it exceeds the total size of the
> > > installed DRAM and CXL memory.
> > >
> > > If swap is disabled, you can usually expect the OOM killer to terminate
> > > the stress-ng process when memory usage approaches the installed memory
> > > size.
> > >
> > > However, if multiple memory-tiers exist (multiple
> > > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
> > > /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
> > > invoked and the system will become inoperable, regardless of whether MGLRU
> > > is enabled or not.
> > >
> > > This issue can be reproduced using NUMA emulation even on systems with
> > > only DRAM.  You can create two-fake memory-tiers by booting a single-node
> > > system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
> > > parameters.
> > >
> > > The reason for this issue is that memory allocations do not directly
> > > trigger the oom-killer, assuming that if the target node has an underlying
> > > memory tier, it can always be reclaimed by demotion.
> >
> > Why don't we fall back to no demotion mode in this case? I mean we have
> > shrink_folio_list:
> >         if (!list_empty(&demote_folios)) {
> >                 /* Folios which weren't demoted go back on @folio_list */
> >                 list_splice_init(&demote_folios, folio_list);
> >
> >                 /*
> >                  * goto retry to reclaim the undemoted folios in folio_list if
> >                  * desired.
> >                  *
> >                  * Reclaiming directly from top tier nodes is not often desired
> >                  * due to it breaking the LRU ordering: in general memory
> >                  * should be reclaimed from lower tier nodes and demoted from
> >                  * top tier nodes.
> >                  *
> >                  * However, disabling reclaim from top tier nodes entirely
> >                  * would cause ooms in edge scenarios where lower tier memory
> >                  * is unreclaimable for whatever reason, eg memory being
> >                  * mlocked or too hot to reclaim. We can disable reclaim
> >                  * from top tier nodes in proactive reclaim though as that is
> >                  * not real memory pressure.
> >                  */
> >                 if (!sc->proactive) {
> >                         do_demote_pass = false;
> >                         goto retry;
> >                 }
> >         }
> >
> > to handle this situation no?
> 
> can_demote() is called from four places.
> I tried modifying the patch to change the behavior only when can_demote()
> is called from shrink_folio_list(), but the problem was not fixed
> (oom did not occur).
> 
> Similarly, changing the behavior of can_demote() when called from
> can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages(),
> but not when called from get_swappiness(), did not fix the problem either
> (oom did not occur).
> 
> Conversely, changing the behavior only when called from get_swappiness(),
> but not changing the behavior of can_reclaim_anon_pages(),
> shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> (oom did occur).
> 
> Therefore, it appears that the behavior of get_swappiness() is important
> in this issue.

You have said that there is no swap configured in the system, right?
That would imply that anonymous pages are not reclaimable at all (see
can_reclaim_anon_pages)?

-- 
Michal Hocko
SUSE Labs

