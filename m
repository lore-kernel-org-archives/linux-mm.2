Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED4ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C738E0002; Wed, 10 Sep 2025 16:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433B78E0001; Wed, 10 Sep 2025 16:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370DF8E0002; Wed, 10 Sep 2025 16:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 236458E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:11:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2BACC01F5
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:11:01 +0000 (UTC)
X-FDA: 83874434322.23.35567AE
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2A93100004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:10:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYzwEVRQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757535060; a=rsa-sha256;
	cv=none;
	b=4QLFfedtWAoTyJeh+fA7WqAanSEIOAvZIrJRdRawDXiXa+THUcAhYLKNEV14xtMMqvyVus
	nCVnJHaqY80iAzbdUD+g9RKYkcj1IHh34iKM/lawu3erJnNijzaFgJsNdGf9+Haq/RHrj8
	bxCpNX8fowFLaCHFn0Owexf4kGUUYMk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYzwEVRQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757535060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hroFfDYim2M+I/skY/6mfFB67MLHNWA5J2KjItQQBug=;
	b=AlBn0mx6hhwCMSj28WA0fFvyLZ+cn+3fypVNaaGlQemdh4M9P4H2yfxT6QZJU5RFYqB+al
	4epKwtM1zCRqY/aufE8tOW2IqkjomISgG4zT+msYr1HxrYxLdI4jcW7PGQdPAY+tRnG8WZ
	g+bjpF08J/PCNfHgUws+DgJOKi0hXGA=
Date: Wed, 10 Sep 2025 13:10:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757535057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hroFfDYim2M+I/skY/6mfFB67MLHNWA5J2KjItQQBug=;
	b=wYzwEVRQKupEK0mCQ9z8hXiGFJmQcdgWnSF2QejHrWUqwPc9FmKhqCW8nLgEiBdbTXahBI
	C0nyztrs4gxTVU0gdhZCitVEdqtLNht7iWU+G5fa/ysQ4BRBtKRFuCzKrwUamQKF9m7dKA
	Md7kHIiRsVdnyAQ0xIaDbBPdwTre8vk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
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
Message-ID: <qisfqncqgkgxh2nj5axafunlfjen6oiciobcrmpus6l3xwrbyj@blxv73pbhzez>
References: <20250909065349.574894-1-liulei.rjpt@vivo.com>
 <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2A93100004
X-Stat-Signature: ww5me8wsn3mk1gzqxmktqz3khtahm8tn
X-Rspam-User: 
X-HE-Tag: 1757535059-747853
X-HE-Meta: U2FsdGVkX18US3sYqFyraDHEizcy+AhtSrflg/jc1eL0i0wvAhviILPcF2u54jClTr22tC7wcWYmEAEw5bqLUBEm2NaC+CZx8GlbA6OZJmsZ0YdVZLCJ5Ja8wVHD6XWd7Dfjd6pgemJcrmLoSP1FklfSddwJHKhA1UZ9RrufLiyr2ohZXwJAysXSRiBc3pUQKV2Z/7Gb8cabIQbPTsDpBRQtC63i3CrElUCPk0AjTdmbJAPqTnGuvD+dwdDdO3psHzqfemah6hnrygNPNdOGwv148Tzcfk0c5P0m0aoC+WX/VbFD+mff+687o4z/UD4OmBcs7b/qlxRl3a68CnjIHosX5J2HBHXugLLvVaLTJ3Cm/3yj9d/THA1b69g+bQ5Sc9A/UHO2oJyMHoZh/MbbEGxDfkePwOO23LHmP2guh7Lcit8VIugXsSbgJZNzUtVmlHoHyx5lDAkU80k9qVOoqTmBUN44q7qrMrf2UYENMSplayj1lLhuUd0OPo+GJu7uYwmHGo1VFfSUey8tlqizSQH5UcVy1so/K2HFgFVfE9Wb0/Z53Z3EUc1CQB//wN6vluUdUbS/tD55iYuJ2e9NFvEIHl0Y3XZRGRAb+blvUCBPW/b4JUbPtSH0FQ2hxb9o/alYXt+YNSJE17iQdvl/jTBN9bar8ULtW4re/FEfkL3COxkza56Ru82TnMqbIqMlKYzCrNLpzZgoKalJ2+/B4njOLkxOYBfFPetXt1pRAheMvrHOA7BjTL0T+Nsq7p7+khj+zK9tjljHBJRolUHIXU6Lan6Os5xyr++DAkqE0Cc3gxZUU2rUz5y5JZsj3vOTDS4PfKx6uFEGEqNSlTywtTnEqD1/g7oDthEDdeXIgyoAHEmiESfj2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 12:48:02PM -0700, Suren Baghdasaryan wrote:
> On Tue, Sep 9, 2025 at 12:21 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > > 1. Problem Scenario
> > > On systems with ZRAM and swap enabled, simultaneous process exits create
> > > contention. The primary bottleneck occurs during swap entry release
> > > operations, causing exiting processes to monopolize CPU resources. This
> > > leads to scheduling delays for high-priority processes.
> > >
> > > 2. Android Use Case
> > > During camera launch, LMKD terminates background processes to free memory.
> >
> > How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> 
> SIGKILL
> 
> >
> > > Exiting processes compete for CPU cycles, delaying the camera preview
> > > thread and causing visible stuttering - directly impacting user
> > > experience.
> >
> > Since the exit/kill is due to low memory situation, punting the memory
> > freeing to a low priority async mechanism will help in improving user
> > experience. Most probably the application (camera preview here) will get
> > into global reclaim and will compete for CPU with the async memory
> > freeing.
> >
> > What we really need is faster memory freeing and we should explore all
> > possible ways. As others suggested fix/improve the bottleneck in the
> > memory freeing path. In addition I think we should explore parallelizing
> > this as well.
> >
> > On Android, I suppose most of the memory is associated with single or
> > small set of processes and parallelizing memory freeing would be
> > challenging. BTW is LMKD using process_mrelease() to release the killed
> > process memory?
> 
> Yes, LMKD has a reaper thread which wakes up and calls
> process_mrelease() after the main LMKD thread issued SIGKILL.
> 

Thanks Suren. I remember Android is planning to use Apps in cgroup. Is
that still the plan? I am actually looking into cgroup.kill, beside
sending SIGKILL, putting the processes of the target cgroup in the oom
reaper list. In addition, making oom reaper able to reap processes in
parallel. I am hoping that functionality to be useful to Android as
well.
> >

