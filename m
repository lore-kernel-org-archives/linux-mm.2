Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE84CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0778E0005; Wed, 10 Sep 2025 18:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78C28E0001; Wed, 10 Sep 2025 18:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4D28E0005; Wed, 10 Sep 2025 18:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8921A8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:33:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3108713A879
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:33:19 +0000 (UTC)
X-FDA: 83874792918.07.77AF878
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23045180004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:33:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KWRxDXVt;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757543597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3a//xGijpXNAuGudMzhJ5QIbcnpcApxjy+dhMPgQAYk=;
	b=KGNqd2t1Fh0BEW9A2dn3lQi5RQNEv1jvEqVRlRwKfUeXlCPlHs/KA2JpqxL6Z504DfNkLB
	MNbSaTTqWhR9qTHZE4NlPQdoo2msUf57xLW+1EqIqi4i6G0KO3lxpmYMmfeGS0UoT7xjDY
	/eZ6DJ37ErtrVhly7JYma2d72bva5W4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KWRxDXVt;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757543597; a=rsa-sha256;
	cv=none;
	b=UOtfCriYu90FxA9HVT6c7TBhRc+DexJg+leOb4PnWck+cI7+/sOASHsKRAwxwMRcrowa2b
	vkbq2MmGSxAjXeT88FZOWO/ZFyPwpcjF6fUaq27emDWMJeoMIPjAoAWSstzTLiHr+15OLz
	xNFFMGg+DwJfud3KrZ8wzIQu+T7x4Zw=
Date: Wed, 10 Sep 2025 15:33:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757543594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a//xGijpXNAuGudMzhJ5QIbcnpcApxjy+dhMPgQAYk=;
	b=KWRxDXVt7y9s6wE+N5w0wSQ5Ynzy9bk1e3X8QxXkENMXrCSlAwlUuk55Uxkl7/O4MIj/U6
	WOOIegzy9yno5PLguEzQTbqb/YbwxIUIgLlP9lb3pIv+4Hi6+YBzVJ8Vagftl5Oea5XNB3
	z7oywdV/N8xCxnl9VbYwRvcPo0Pr4co=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, Hao Jia <jiahao1@lixiang.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, 
	Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Fushuai Wang <wangfushuai@baidu.com>, "open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async
 release
Message-ID: <lsg5toahtv3odhjslxn5zd6huih7ziaei6vjj3u4wybbesjup4@i6tytlo4uczo>
References: <20250909065349.574894-1-liulei.rjpt@vivo.com>
 <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
 <qisfqncqgkgxh2nj5axafunlfjen6oiciobcrmpus6l3xwrbyj@blxv73pbhzez>
 <CAJuCfpF1deAfZfWQZkAdws9FDNsmZp3KMQap-LqcX1NzOoknhA@mail.gmail.com>
 <CABdmKX2386gYbF5BXzbJ3awybF+edGAfGgFguhAbppejYMKGZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX2386gYbF5BXzbJ3awybF+edGAfGgFguhAbppejYMKGZA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 23045180004
X-Stat-Signature: 4991zhmkc9dypqc6ekwn1kinzcr978mr
X-HE-Tag: 1757543596-686894
X-HE-Meta: U2FsdGVkX19B4JJmMItJgAZDOdszExTBlk26wb319xfBJXh3GDk3GQn5T0l/NfxfBtWks1Rd0tNaOl1X+DUVQkdDoN7N9mpJ6oSYylRFs8UPQptK1Ug5ZWcgV01uw34EweF+3D6ZbCdmSxScRT22d2z+de0xnepKAxRjL32C2yhrMwsKFWCztOoX0ODfUZxMhE728m0aCt1DHLlnwz7Z+1o6auMPnimUqGdGaA2J4BTSVyguBbBSS+TQ5DZ+QK/KAiWd/EW49SHWS8zbyqm5vYzpDKyGJ6ZL4r8MuTO5JtePahFurOVPSATJ23p+25lUKmpHAm3/ek2CX0MEKuKL9tsKt6bKljwn2/CLGhGdknFEZfACOzAxKGP9LnLSu9Qdh+aM22IAcjjAGxc8SQkXC5jiV/DEoQWooIw1BuTSsbjMrxBLBSjwe2XFXpCUfA+Pp3mpgxQBNXo+12oAw7gwkTvyNiYo+urPRjQiGBw+F8N/EoallSNB6zBtxEy0lRzGZY+p3thMFubEzgT7W5/EVZFvUSUABIUppPjH1/qGilLJPMCYXUrLn9N60/h1/Oe3hwUTktBril+APo921tEzyRZg92dfRLOCEmii5KTl2DTrqvUEs+gdmGZZmyOYPs2yjTnjYQ0e6VRdSaTBUDMdWCnN4OHwwJfOanQGW7+tEyOgrkNvzRe31vBMhFEH3HQvGLhcZRNTvXD08/OtiVuixLCvixhiIgeVXadSf4EZ+6UOSwlj5TJ7tqFi9SvPeBkeu6X7vDva/pzAG2NxcXs7jS0vR7vY3YsS5v2ktZnwvzUXmdrJqYFoPn4zADYuVuuQzKgBUy5tYnFfRXao80+GRQfajSNv8Nk++ChJ7IGsp3aGiLhNjOTkOlfkJ2G3FJ8iamu0R2MjPp6AL8U7+N24+8X+ycmcK38gGR9f9SqUMz8ngaIqQoijwKEnW05OwQ3El/rteyjXc+6xCPtRntL
 SdW5h9yv
 DiONtWGC6NKOAxpWXyWx8/ahQXVxuiprjidXcqEptdbqQRMaeop+Mg2t7gMCFRQxLA/msBinEs46URrY1gEXh4MNdkFpEuqnyi6r2qz3rvZTkLaeYspkk8cAXO8+uECtxhc37wth5tG2+boAJeLKFr3DKbekhgmPt61kta83NqtPcm2EptvS+PPY8ofKyY3ojOT5J1ynnbjHF3R+QTzn3BAKhq7TR3ZpYT/UAijwgxrbBJhnbI+U6yi5yWhSU7AxBMS4MAxvh2LKaEaN8HPoFOPKadA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 03:10:29PM -0700, T.J. Mercier wrote:
> On Wed, Sep 10, 2025 at 1:41 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Wed, Sep 10, 2025 at 1:10 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > On Tue, Sep 09, 2025 at 12:48:02PM -0700, Suren Baghdasaryan wrote:
> > > > On Tue, Sep 9, 2025 at 12:21 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > >
> > > > > On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > > > > > 1. Problem Scenario
> > > > > > On systems with ZRAM and swap enabled, simultaneous process exits create
> > > > > > contention. The primary bottleneck occurs during swap entry release
> > > > > > operations, causing exiting processes to monopolize CPU resources. This
> > > > > > leads to scheduling delays for high-priority processes.
> > > > > >
> > > > > > 2. Android Use Case
> > > > > > During camera launch, LMKD terminates background processes to free memory.
> > > > >
> > > > > How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> > > >
> > > > SIGKILL
> > > >
> > > > >
> > > > > > Exiting processes compete for CPU cycles, delaying the camera preview
> > > > > > thread and causing visible stuttering - directly impacting user
> > > > > > experience.
> > > > >
> > > > > Since the exit/kill is due to low memory situation, punting the memory
> > > > > freeing to a low priority async mechanism will help in improving user
> > > > > experience. Most probably the application (camera preview here) will get
> > > > > into global reclaim and will compete for CPU with the async memory
> > > > > freeing.
> > > > >
> > > > > What we really need is faster memory freeing and we should explore all
> > > > > possible ways. As others suggested fix/improve the bottleneck in the
> > > > > memory freeing path. In addition I think we should explore parallelizing
> > > > > this as well.
> > > > >
> > > > > On Android, I suppose most of the memory is associated with single or
> > > > > small set of processes and parallelizing memory freeing would be
> > > > > challenging. BTW is LMKD using process_mrelease() to release the killed
> > > > > process memory?
> > > >
> > > > Yes, LMKD has a reaper thread which wakes up and calls
> > > > process_mrelease() after the main LMKD thread issued SIGKILL.
> > > >
> > >
> > > Thanks Suren. I remember Android is planning to use Apps in cgroup. Is
> > > that still the plan? I am actually looking into cgroup.kill, beside
> > > sending SIGKILL, putting the processes of the target cgroup in the oom
> > > reaper list. In addition, making oom reaper able to reap processes in
> > > parallel. I am hoping that functionality to be useful to Android as
> > > well.
> >
> > Yes, cgroups v2 with per-app hierarchy is already enabled on Android
> > as of about a year or so ago. The first usecase was the freezer. TJ
> > (CC'ing him here) also changed how ActivityManager Service (AMS) kills
> > process groups to use cgroup.kill (think when you force-stop an app
> > that's what will happen). LMKD has not been changed to use cgroup.kill
> > but that might be worth doing now. TJ, WDYT?
> 
> Sounds like it's worth trying here [1].
> 
> One potential downside of cgroup.kill is that it requires taking the
> cgroup_mutex, which is one of our most heavily contended locks.

Oh let me look into that and see if we can remove cgroup_mutex from that
interface.

> 
> We already have logic that waits for exits in libprocessgroup's
> KillProcessGroup [2], but I don't think LMKD needs or wants that from
> its main thread. I think we'll still want process_mrelease [3] from
> LMKD's reaper thread.

I imagine once kernel oom reaper can work on killed processes
transparently, it would be much easier to let it do the job instead of
manual process_mrelease() on all the processes in a cgroup.

> 
> [1] https://cs.android.com/android/platform/superproject/main/+/main:system/memory/lmkd/reaper.cpp;drc=88ca1a4963004011669da415bc421b846936071f;l=233
> [2] https://cs.android.com/android/platform/superproject/main/+/main:system/core/libprocessgroup/processgroup.cpp;drc=61197364367c9e404c7da6900658f1b16c42d0da;l=537
> [3] https://cs.android.com/android/platform/superproject/main/+/main:system/memory/lmkd/reaper.cpp;drc=88ca1a4963004011669da415bc421b846936071f;l=123
> 
> Shakeel could we not also invoke the oom reaper's help for regular
> kill(SIGKILL)s?

I don't see why this can not be done. I will take a look.

