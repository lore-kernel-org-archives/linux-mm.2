Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77755CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F278E0005; Wed, 10 Sep 2025 16:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36FF8E0001; Wed, 10 Sep 2025 16:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D138E0005; Wed, 10 Sep 2025 16:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B142C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:12:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BB7C1401F7
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:12:18 +0000 (UTC)
X-FDA: 83874437556.13.6F08BAE
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id B89A41C0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:12:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RiMLFgPL;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757535136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gR5yuuzaP05+dnCBzQFX9tuMWKZshj48LMZ7zdf2Gm0=;
	b=BTJJ5ZEhnH3uh/6AODwWgCrcEGUB2buBNEBrXwkwpbma3rL3U0p0vb0e1lUIIz6AX9BOvF
	/76PlcTH3OGdHDjU9h1xVpQ0RxbcCj1qfYxLDMeXrly56/Z0WHyQ/MB0S0XOrtkAqX4mZf
	DVNWlOP3LaWsb/3T2w9VCcIOBUQX8V8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757535136; a=rsa-sha256;
	cv=none;
	b=e/n+/60Gh/75Hw7BAC+axAlBo2/IXsM1EZhjOqC/zNPNxuNERn2g/IPINyUgVzGj5okK8f
	jKoRTLWtKqkkwbzpC4LEeccQeH0Usv2pctzdaDsQ6CUL5pCtVVICVaYUFKPKeKjIBIRitA
	oVtkQASErGkUzp7e96qFFzzQuLqE/wY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RiMLFgPL;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 10 Sep 2025 13:12:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757535134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gR5yuuzaP05+dnCBzQFX9tuMWKZshj48LMZ7zdf2Gm0=;
	b=RiMLFgPL2eLugE3IfLCZDeAqKTtRLfUqMUjt0lINJzqe3IK5Hy+nwR33Xz4+ABuS3RzqR8
	GdhQ2MZQm0CbXP7aQOJLvOd/mIm7InoprUnNwSnFMbkOjO6IC9TvzAyKmDM0A21EjLA8so
	kmmOUhrW17f9pHzyHX7FLHPot7il8Oo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
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
Message-ID: <uwqrobr5xqtvav73srbe6v2nccgtoy2456vpgzemwex26lwsq7@2g74vl5oomfx>
References: <20250909065349.574894-1-liulei.rjpt@vivo.com>
 <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
 <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B89A41C0012
X-Stat-Signature: ueqd9gmrp7qwcnc37zrrozy17chbd179
X-Rspam-User: 
X-HE-Tag: 1757535136-359889
X-HE-Meta: U2FsdGVkX18zOJhfpuoABrDX5V/AxNwtHchvNt3KFRjNlxTaUGkmS4IGK/i+vpCZiKvKsAlC7c0z8DUZo0AtZpfJ9z7m1VCBaSs9iww7NTzuJTCB4bTgz6oAktpnFx1xEO6t0vVW96CwaOY07H/6mnISphnKBIJANKiEYl1xQa+D3duxR1ViHpx61QuUjCmZMXpudYmzEvlnBfbouA0gu35hVvCSbFGmWM4OYjrfPdNDHfq+d/+M6CFuKL7i4Yf7MuxUAoP3eFAD8obupyOGRjQIBLdBP86KXGpQcqrz0ZD4dCoidwsn332/YaUHHuGxHKmb0jCpniM0jzfMGuhM+TfMHA5x3nVQ/bym3tFHfBlyDZp+U7dS/mZxg/GHrALOWJ879zqqG6guXvjvIdSptpubO7VizMCJ26h2cB5Kpo4fvfP3vh/Im2L089TKxbFyGLUm/JJa0CoCkWuZ4371AjIgWxwCVC3Jewg0pHXoUA1DHRXzhcaCsdEZmoyECGLVsWtdUjHvzt+KS/MprHxrZ0vsS+hHsNumAqkvM1NYlSQumb8EbAEtzGZTX9D4pf+0YRBI5WWLS6+AaXluOUPwDhKkax3jCI8e1B2lPkzqKfdQHpC+YNBMDKXZcPoYApgy63CQktV8jONCuVXeJryWpOHqlxTsV0l3TgKaFmIeDbwGC/gptHY1AtVlo2RtB+CikOQY9w6NAbA6F/YdXxbXMawbgExD34F3x4anmiXtUC3FkadJwRUrQZCbU9RyXXP5Z3S5z9vto7cN77hl/63wNf4ZtGb93gMvYtL6PWsKF81vkorWOA3BopcgQoa+HsFJGEzZiHoAyLBZ/7IDiytnWe9h3a9Qc03x2+vY/PUhaP45hNZT0ri1Eb1EychVDIuqh3wSQ6jWe78fX6WzDWZJHBvWUiWEqD9EXkX/W4hiu/hWxe5B5nddw7XM9ZDk+IOQ3fN9rv5PWklmm0rAdr/
 x/DLIUkn
 Jok7dGWVHuPQsmT3iXqzyGhOjXiXv+oSJs1M/0quuvEsjlx5x/Bba7qKe/wNK3oHvo0wYE+TwAFhalrpuYFsmZI50EHDhV/t3ORX1o1qdyYkdfaLLBAiJglGdkJcmVIE3YKur75V9E7IgsgfhjuoBIaNU4TkVOET2qbU6RaUKZiiYwIWczHJCdKJief92ISmi07UgWuiA5Fzl8E6l0X3SyKMupQWm/Zn2e+ImAofZt+Q6iO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:14:04PM +0800, Lei Liu wrote:
> 
> On 2025/9/10 3:48, Suren Baghdasaryan wrote:
> > On Tue, Sep 9, 2025 at 12:21 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > > > 1. Problem Scenario
> > > > On systems with ZRAM and swap enabled, simultaneous process exits create
> > > > contention. The primary bottleneck occurs during swap entry release
> > > > operations, causing exiting processes to monopolize CPU resources. This
> > > > leads to scheduling delays for high-priority processes.
> > > > 
> > > > 2. Android Use Case
> > > > During camera launch, LMKD terminates background processes to free memory.
> > > How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> > SIGKILL
> > 
> > > > Exiting processes compete for CPU cycles, delaying the camera preview
> > > > thread and causing visible stuttering - directly impacting user
> > > > experience.
> > > Since the exit/kill is due to low memory situation, punting the memory
> > > freeing to a low priority async mechanism will help in improving user
> > > experience. Most probably the application (camera preview here) will get
> > > into global reclaim and will compete for CPU with the async memory
> > > freeing.
> > > 
> > > What we really need is faster memory freeing and we should explore all
> > > possible ways. As others suggested fix/improve the bottleneck in the
> > > memory freeing path. In addition I think we should explore parallelizing
> > > this as well.
> > > 
> > > On Android, I suppose most of the memory is associated with single or
> > > small set of processes and parallelizing memory freeing would be
> > > challenging. BTW is LMKD using process_mrelease() to release the killed
> > > process memory?
> > Yes, LMKD has a reaper thread which wakes up and calls
> > process_mrelease() after the main LMKD thread issued SIGKILL.
> 
> Hi Suren
> 
> our current issue is that after lmkd kills a process,|exit_mm|takes
> considerable time. The interface you provided might help quickly free
> memory, potentially allowing us to release some memory from processes before
> lmkd kills them. This could be a good idea.
> 
> We will take your suggestion into consideration.

But LMKD already does the process_mrelease(). Is that not happening on
your setup?

