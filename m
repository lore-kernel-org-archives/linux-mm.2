Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFDDCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0212D8E0013; Tue,  9 Sep 2025 15:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C048E0001; Tue,  9 Sep 2025 15:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79438E0013; Tue,  9 Sep 2025 15:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D42758E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:21:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FEB013BA59
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:21:44 +0000 (UTC)
X-FDA: 83870681328.25.C4222FF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8AD4D14000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:21:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sjzUsVGa;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhDQjk6n0b5bB/spcc+8InBhRg7fkfv65TLASLNaXE4=;
	b=45DtO8SqCA1RAiXObmnCd80mmeGQf7dqekI1aHelYBQkT/yKPJlno/MX+gMkkxacRFxAc/
	A/3wxoNVQZ9pqGchr5nEnPnyECNB9g/PDe+tAW1ACzzG8v25DJ99uDyTyvEnOk+7H4z2tn
	kK43fggrFbqUeqZEz8/pwi0b0wl+8D8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sjzUsVGa;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757445702; a=rsa-sha256;
	cv=none;
	b=dw6ENvDE8VcxgRvsusNgy3VWtZfBMdDB7jhJwTBLo5sgIPE/yw0btfKqtYz9yY/VTD4umf
	Ccw+nj9D9zaiYdODqI78ioA3EUAoyBhIweNPAVDx+iwNUBSdjbMi9eEF90yxU0YTwzxZO0
	FMSIJPXIPLdvXFHMRKFidagG3jc6V2M=
Date: Tue, 9 Sep 2025 12:21:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757445700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EhDQjk6n0b5bB/spcc+8InBhRg7fkfv65TLASLNaXE4=;
	b=sjzUsVGa+0Di1xSEmIyz3313s89ajDdufhXMbunOadULSjuGrqlV1+dUTeKDCX0cEMdtg3
	mq2f5ijUy/Y1oS9jDCXjYtvQ2whw5Zh6dd+VIEnk5BPwyjuhfN7VxxPrY8YCBpOBjpNU8S
	TR20eItydveGrPGMF/97uWA74Xnm5tE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
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
Message-ID: <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
References: <20250909065349.574894-1-liulei.rjpt@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909065349.574894-1-liulei.rjpt@vivo.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8AD4D14000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1h6tz8eir5mfzwjgdyxz4oof3uoqnrj7
X-HE-Tag: 1757445702-921319
X-HE-Meta: U2FsdGVkX1/NmvbpjJyYlJ7hb0+pVfV7M8t+3dMzBaQvvRjFsOUXcU6n/5XFEBPvrF2HvSbSYm6vIBix6GNz8fC0HwDjKTUtJHVIB5VVbNJcUo6lawmdlnpWh4Cso7ojMnfmmczBBpmr/ZXk78XSYSrFXlDOrQbdXEy+AI1zFlRG/7fjq5bemcxuXdsoCYJYIh+tT7VDdfHV8otPJG6VIJxxdwHHdEn5BosaVE4xUba2G+aFxDEnLw8g/JtrJUWJs2mkXxi76QrMnYPA7rZQL+VnfYwz95XoxyIP6+UmHtLjpVSGXVGw+No0okvjC0GS+QmzS/cztUeEtpg9WA8RZy8GOKvTy6vO7Sb+FZ87e/JJEpH2VnKqn6I/e/0CPuJ+sg/0QSBaffJ6bDBPkcLHe0S5T+GyfyLN7uOdB/4MQuX2EYzkch3I1aBgL36euNOQMox+MdO+qGJce49GCGRYg9OAzmuYQqjCOqDsDPl3trVwrBHeBA1AtNcfU5LsiXt3zN94LtACXW30Xmi67baM0WqJMyTfvFakVnK/kUcOxMjVdtFhScg9TgN5BsOwxEFChtcP58dZq+6qshAeCM6bIGGOdIEYPwT+FZGUtc1OWU9j4Cf5ufetzPVghJ++ilyFtMwIZsO+AjpuyDjB4LyjQ8b+z3GlAZtUuJ78L0YlgUWmoJpwUKYhiEJK9T+uS1yZd19wRpx7M6XdKYJ/U/avwFR4gqlBanvJM00MseXYT66dsAnvSfx5CFL8IAdJ6AhsFP2Pk9OXXCClUM3tC9qmuKnwRkFaJjim6WkRo+qlyrcBF6Xsvw0ZB/QPtmYOEFJjkc5LI9tgt9kPzfNJH9bWYPW9Y67/zlAxEQTshkBLKY2QKLItZ6EGCUtHuKGme3GqTUhMQOwSK3IhwSsKdJndmXZ2wrArhZpt+9IeXg3VYoSUKT86g0DBqWkTf7I/hjQwJbu599CzBUI9JW44kp5
 SEo3J6Wx
 NyuXTK2ul0HvipNMt0uh3BFLV5XaB8OvFgCI1XzpF8fAFFkh4neWoLy2aa7pXiLY2pQRXgO1n4AYN9IHsH74tDeLGifWiJh/KkpR/n9XExz2nEibLFMJxCwhLSbf0VMHmM8VbxjvGMTkobk2P7tHxKKyVWSBIDrlhn0qy5ZXQQV17jMI6wXayXoQau7hjXo3hOdC1VGoRL7WMBl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> 1. Problem Scenario
> On systems with ZRAM and swap enabled, simultaneous process exits create
> contention. The primary bottleneck occurs during swap entry release
> operations, causing exiting processes to monopolize CPU resources. This
> leads to scheduling delays for high-priority processes.
> 
> 2. Android Use Case
> During camera launch, LMKD terminates background processes to free memory.

How does LMKD trigger the kills? SIGKILL or cgroup.kill?

> Exiting processes compete for CPU cycles, delaying the camera preview
> thread and causing visible stuttering - directly impacting user
> experience.

Since the exit/kill is due to low memory situation, punting the memory
freeing to a low priority async mechanism will help in improving user
experience. Most probably the application (camera preview here) will get
into global reclaim and will compete for CPU with the async memory
freeing.

What we really need is faster memory freeing and we should explore all
possible ways. As others suggested fix/improve the bottleneck in the
memory freeing path. In addition I think we should explore parallelizing
this as well.

On Android, I suppose most of the memory is associated with single or
small set of processes and parallelizing memory freeing would be
challenging. BTW is LMKD using process_mrelease() to release the killed
process memory? 

