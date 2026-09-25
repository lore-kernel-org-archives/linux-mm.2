Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF10C98325
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8E86B008C; Fri, 25 Sep 2026 11:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A546B0092; Fri, 25 Sep 2026 11:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80666B0093; Fri, 25 Sep 2026 11:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D63F6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:41:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 939ED1606E3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:41:42 +0000 (UTC)
X-FDA: 85252699644.25.1F8283B
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67C95C0010
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:41:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pj4+CrKU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790350900;
	b=rDevZXeDmBrnzA2WqpXttQ+KTJkVjgJ3rQBIM6UsghT+RpxhDwHKxX00sHV7gweKS0VLMn
	e++XoV+o0wp6ZOR56gn7L+vnL9Y31wN1MFWei7wIcqUT4qPOKCH+rk0aVev60ScqjAbLKb
	Hk9NhoUBjkrHI2drcksK9dsEKCmJTzA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pj4+CrKU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790350900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIiTdCRmfuDk3fuKkf/gmUjp83CRXZD1qvI7wHqMTnI=;
	b=l0K19twYYs3nJ9NP2zPDTRXif3/Q2a7gKKOd5xoShS5nGRMOWAjLCIfti5U5wm1RezB0up
	24zGocwvmt2QKbgg9aQIJ8a4I1V2wyKf3sltNJn4/PaRU2u8o4FPgn6lVhFlOl2uRRcMwK
	INPU70evc2UyDOiJfoNwjB2QfjGre4Q=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910ca5aa8so96020885a.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790350899; x=1790955699; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rIiTdCRmfuDk3fuKkf/gmUjp83CRXZD1qvI7wHqMTnI=;
        b=pj4+CrKUG9CFebUgaRIIIw8u/5TUGSV2n13AHTM4CPZEx7ZJlO6E3Mlw0vVzIT7/LB
         boUqT6/wpe1vuzf/wJgImmybLUVpwvdySRnAFRbOv9cvt7Y3wmoQ5e0icav4zEJMb2Q9
         FN3Fd3ytENteR25ajMZ+FkRKEJKstYkf89jK2llrEVYlBzj8Ep+Z0/Jf0riWCIcn+qyt
         TctEspd70ssjQCaJZvQv3mAhMM2M0XYlvs7eKpE82HbJiSmI3FQ8/sejRrxNsst6hN2T
         lpgkWg5gcUhp8U+kKv0YINcfEmGt9diuyWYdzOFay/P6dGROfLGmEqn8/meiNwQd63lv
         cbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350899; x=1790955699;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rIiTdCRmfuDk3fuKkf/gmUjp83CRXZD1qvI7wHqMTnI=;
        b=eYA7E/m9xC/wuUk4FUtq1X+MEz7cQC8dhrj5u6FvOUlWh6WkPYxWQuIZR0XplxeGPo
         YKFuv7U1/PV5ZHe+//jTzWMSBdMByIoHkSl6bv0rHu/dS65JTh2TEbY/eIInEYSpsxHJ
         0SvG2DyRv363gwH0+7oTHXfRRQeuZNExaCxtMT65R+se2gBN+aTcNG8OotoevSuGySHT
         wqtMeZ3a+I7zsBO6iJ+d+aPAG9wtql1dGCXixG117fJ6ymxKSj4PLXzemzrqA/jRBAjC
         TdNFP5mBDRvfRNrzZHN+koV0yc1SB8v+Go2MTkak7EckFn4SHnsQKDwyfrpVx3whsf3T
         v8fQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1n/IyvVN530egyLqgxe3pwp0+l+ahTitrJYKJdsqMhKGeBa9wBY7I/tAMnxcsOKmKbhIG766XwQ==@kvack.org
X-Gm-Message-State: AFuF++ldnfL2t7NjP4kjxDsxRFIl+3G3hWB6Ojuo0gc1tHXNQkW3kAy3
	SNgwNJ8pzIZvHHHkuoswM4y8NqbqMSB9uvKlzJhvoKKcw+qYaK2Rhs/zEzPddeSq1gstFqYHsfM
	IgcFk
X-Gm-Gg: AYBFou3Tye/JisSiNhb9diSXjo/T6cXO0IHsFZ9pj+vH5F1Ez3Ot2kTGZURJxkRIqRS
	e1QgGAof8bbEWo5c9up8INW6C5LF+RJDsvL91cAtNvvjKNvV1lFBSLvrHF8WFlnSKx0PmKIxpLy
	nS7/Pc+9ysBkIM5A5yO6qZ6U0xwvVjE1BP/EIfcxm2Yi8iMOBPC0cKt1XOVrP5NB89FejivlGxM
	MakPJqGh8eqhvk6VuoG9G+FSVUfyNTnycf42qzTWCvLqEh8XCzrDzzMa0/HZwDNbX5XNrT9qrfs
	LmhKb3sxWLAYEV/gTrG0Dtf695kIYHEe3CzQMpe75XtU2GKdF78bZGCQVPdnoO4hhkhqZvmhisO
	DzrZWBzoBXac3PR1VoNuT/bd0U7EslbF+pAUaEC0gY16ubl2FC4HEiVxFGuzx5tB18CLjTN6R0l
	PDqRtbts8s8hUf3FXXdFYki6+YG0E9zaAMMmn7Q8zSNj7sPgFnU0+LWMjLmm5rWSzLxesh
X-Received: by 2002:a05:620a:2720:b0:939:feaa:949c with SMTP id af79cd13be357-93c43ca0f79mr497616285a.36.1790350899351;
        Fri, 25 Sep 2026 08:41:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44652fa3sm205736385a.4.2026.09.25.08.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:41:35 -0700 (PDT)
Date: Fri, 25 Sep 2026 11:41:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <araWKyJ5MENBwXCL@cmpxchg.org>
References: <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>
X-Rspamd-Server: rspam06
X-Stat-Signature: kfx43k67eqsg443pp3ha41hr9i5wh6kq
X-Rspam-User: 
X-Rspamd-Queue-Id: 67C95C0010
X-HE-Tag: 1790350900-970798
X-HE-Meta: U2FsdGVkX1/uLeOnYfqhNwjIovzG25hM0TTegjImLJXi0hMI13G/52p6z1mfwi1ZC5sTlQdGeMBX4p2CiPvIBOs6vj6OZL6hwIYmnJnNYHuCQUt2a2vKx3IG7E3HMR24OtxATiB/htjG/9vXEulppI7PKCXHjS+RIUPSjtUrU75WJGt8y4HzU9GSDIErSrXWMttW27hm5mWytKiTui9CtIIB2qzFB8fDDAr0obFEhFEODlo/to9gnC8C/iegUrcNao48vQ8Go4QVD1yzSNvSKlEMTQcu3iWSYdOJeWZQbg3jD6GCB0o7y5nc0QhdyCad3n/XpwFoX2m8C1eNoByXJMzQTX6OBNTw0xV9S0YHkGEw3hrD/dXVq3164bCdKn3TWqmj5tkOYYG2Yc1FZElEn0Z06Z4ZHHp0NMDnLVnlAKTD07jaUfSbNwgZgTXLQrsiMUxfboJZ6zSli3LpY8Ofx4h3UmJRgUEKTWCvDdrz6ZudTFOTDjc4dtt+CM232u3k2rHtqpdlQISockWug0nfTMZ3LaLAR4xNTQWKTfKOu5IQTa9S2e65PFzntpTDIa1zhCIKopbUtYbT2wLvUDNRZdOrNLmvYWNhYGnmXnF1iMos+HVmkd+uuR4FYGVfoCRBsG8agSF7ZUvRct+GqVyHm1QKe62ih927OVhLv8hVsh9zbMYW/eK5vGVC47ASHPoWVRUz/anIdV536NfRpAH9uc3cbxs5dqqjRsBGKN2OQ2qqJ3aHwTEOZWlVO43FQAcZwKKFivZ2M9YL5KDKV053dlRa9Qk3tNBKBSWSEmlA6VensLd00CSl8pjmgnLDbuPmTIVxPVDHAwpGSGlEmK2XR2VFHplVWHcMK1OLMageCuhMTBqtYXSOC64beo8QhCvaIxjrVO9bffw1KPN7xW57rtkNFbKGvdy+8p4emiWjipp8RpSusa2VpAIB5KuZdPqs24POqG4THJeouAmMqAD
 ixSPkzOC
 5kRP7dBu6fyhAgVd1wO6E2EtuNwzkqx2MD8991PK5OGVv4s5Xo0t8KKq9hAc9Quvv645C0ibJ9amHuNbZovUH+iKWVra7llL14kXDYW9Q+sKxKcDeghxEKwI0Lm4NxUoodVg3gOLD5Kn+1P+WLC/ZGdypqj5SVoWHm60VEjG214f/fjYsj3H9iQOL1VakHgw+zLUeB5MCulcXHZZiXH0cGRpurAFXDSpWNVbu5E8c+YaBKixH5yi2XLEhsdNeRPhpSb+Qf87NQZ+xq1qNXr6mSJpuKuv7RyPBvfTpHhf5IwBWctRfXIW3BxvvjlHDBqdHor3MXaAAHXgBrJorDEHqDvAdQzrv7ZXxwrNqjGNscS7luk4BgqI9qVnVRjHWAT7inw/S+Zr0gY8QsrCdJ+v69fgVmwKCo6LZF5uCsFyo258e07guc1hEqp9R4xkPyoS2UBfhUvIGikAvBfB+Ck87T/jj0dC3XjC8OWnCPb2uvTK9/4z3IJ9jDbGcn220e5pJhYPG5eY5Uj5D18xCPUWLhEXZEfarO2Te+OEMaEH3l2FrX4ZxxNZUtHU5fzF1LadrpPR0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > It seems you are talking about a different topic: the vswap charging issue.
> > There is a golden rule that we should follow: don't break existing
> > users. At least with the same persistence, this rule should apply
> > universally.
> > In the swap tiers discussion, the UAPI was such a big deal that we
> > couldn't implement new UAPI. On the other hand here we argue for
> > liberally changing user-space visible behavior.
> > 
> > BTW, I already shared that changing swap counter charging will break
> > our and others' existing deployments.
> 
> Hi all
> 
> As I read the threads and try to clean up the requirement, just
> realized that I forgot and ignored something previously. I think I can
> share a few things here.
> 
> I also see that Rik mentioning that:
> 
> > It adds up anonymous, file, accounted slab, and
> > (after compression) zswap memory use for a cgroup,
> > and can be limited with all the usual cgroup
> > limits.
> 
> That's very true, and that's also the one reason we can't
> migrate some workload to zswap easily (at least yet) :D
> See below.
> 
> The discussion on this can be saw two years before (I know
> things are different for V2, so see below):
> https://lore.kernel.org/linux-mm/CAMgjq7AYA91f4g-bknUZOMg6hApTD-X5LqjcTBN2u-Lu8pjs+w@mail.gmail.com/
> 
> An minor update for that, memsw in V1 serves pretty well (we also
> modded that part and would try push to upstream if doable), and as
> memsw is missing in V2, we can still workaround that using
> memory.current and memory.swap.current. BUt missing the offloaded
> part in memory.swap seems a problem.
> 
> First a little bit off topic, I'll be really happy if we can make
> both compressed memory and swap as separate counters (I even once
> tried to implement a zpool accounting to account compressed memory
> in some unified way, but, well, zpool got killed before I post
> that :P), or at least a way to do that, e.g. something like nokmem.

Thanks for your thoughtful email, Kairui.

> Due to our real usage:
> 
> With compressed memory staying in a separate counter (which
> we manged to do that with ZRAM) the memory.current + memory.swap
> (or, memsw for cgv1) could be the exactly planned or sold size of a
> container, the scheduler (e.g. from k8s level) is fully aware of
> the packing rate of a host based on this reading. and can make
> scheduling decisions based on that. And can control it by
> adjusting the limit two combined.
> 
> But with compression as a fixed part in memory.current, first the
> compression rate is totally uncontrollable, both the user and us
> will be fully *unaware* of how much memory they can *actually* use,
> that makes the planning really awkward. memory.max stops being the
> bound of what we planned or sold, anything compressed lets the raw
> footprint go past it by however much the compression ratio happens
> to give, so what we oversold is bounded by the workload's data and
> not by anything we configure. We can substract the zswap reading
> though with adaption, however it's hard to change the performance,
> OOM behavior or reclaim behavior:
> 
> As you may considering compression is trading CPU time with memory,
> then two things here: the user could use more memory than we expected
> by burning the CPU. And, some users has a leaking application, the
> application could goes super slow or experiencing high CPU usage due
> to memory being compressed. They really just want to get OOM killed
> in time when ever the application leaks beyound a threshold (and
> yes that is a real and actually practical model for many applications).
> And, we can't simply disable memory compression for them.
> 
> In many cases we just want a best effort compression to make space
> for low priority tasks, and do not want ordinary containers to use
> compression at the cost of lose of performance. While still has
> a fixed limit as usual. So simply disable memory compression is also
> not the plan, we do need compression to make place for other
> applications, we just don't want their real raw usage to exceed
> memory.max, and we can dynamically adjust memory.swap.max to
> control the oversold part, compression or physical.
> 
> And this is not about residency, so memory.min/low don't help here:
> it's about overselling, and about not leaving a container thrashing in
> compress/decompress loops instead of being killed.
> 
> And if the memory compression is really fully transparent (not
> doable by software), yeah, that's great as there is nothing to do
> with reclaim.  But, for now, we have to go through page fault / folio
> allocation / map it again. So For example, if we already have
> memory.max == memory.current or under high pressure, then now
> doing any read from the compressed part would need to some
> require further eviction first to make place for the decompressed
> new data, this is not like any kind of "real" memory, something
> feels not right here.
> 
> Another thing is that I think we has been assuming that physical
> swap is slower than compressed memory, which is not always true either.
> They all need to be read through page fault, the page fault could
> be the real blocker here rather than IO or de-compression.
> 
> I also want to separate two things that I think got bundled together
> here: not requiring a physical slot behind a compressed entry, and not
> charging the raw size to the swap counter. The first one is great, yeah,
> and it's exactly the part we want, it's what makes compression usable
> without provisioning disk. The second one is a policy change, maybe it's
> not needed for the first stage, charging a cgroup for the
> memories it has offloaded doesn't require any slot to exist behind them.
> If someone wants to run memory compression with no disk at all,
> memory.swap.max defaults to max, so that still works fine, right?

I think what we found out over the course of this discussion is that
people have been using memory.swap.max in two ways. Regardless of what
we do, we will "break" one side.

(1) The usecase you're describing. Use memory.swap.max, combined with
memory.max, to set a "total", predictable footprint of in-use
application address space. You can mmap whatever you want, but the
number of unique pages you can touch is limited to this sum. And you
can control residency vs non-residency through the invididual values
of those settings. If compressed entries are not included, this
usecase will break.

(2) The use case we have. Use memory.swap.max to divide a finite space
in storage. We only have so much space on disk, and we need to manage
fair access. Note that this isn't about speed. We have a mix of
containers where some use writeback and others do not. The ones who
write back to the swapfile need to be able to get their fair share -
not more, not less. Including something that doesn't actually consume
this separate finite resource is also a behavioral change that would
break that usecase. And arguably it's a deviation from how the control
was intended and from the broader cgroup design philosophy.

I think we need to build tools to support both cases. But somebody
will have to change how they're doing things... :/

