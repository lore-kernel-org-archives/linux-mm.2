Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15FE4CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C2F6B0088; Thu,  1 Oct 2026 14:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D3F6B008A; Thu,  1 Oct 2026 14:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63626B008C; Thu,  1 Oct 2026 14:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB866B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:42:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A6ABA0484
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:42:59 +0000 (UTC)
X-FDA: 85274929278.16.D1765CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D1CD8000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:42:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sip89Hr+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790880177;
	b=3ArodsXv2QeHC4PBH6MMstYUVncy/Exk5DODxqGXxEeA5f+I/j/2FfeD2uVcIehAuObkun
	xHVUEQvI94GT+z0thtfSjTTDIMTe4WDwdp2JBS4gADlsfsLHIYty3Nz3i41VftYMMTHF88
	V11Tbi6xR7fLRIU6KyOUkY/vbuUvXfI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sip89Hr+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790880177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=uwZ2rsWGvMJKClUG1hn9YbZEiJLt9Kacj4MriMozc3I=;
	b=pYs8aAF3MWg9wnfRz31xGtkwNA10hJs3fCX6bMOkFQK7ZAl4SOhQzmSvSOKqe2OvVt3UiE
	+gK/XyjUBb++kEMZEHv+EoyJcpnn7vjMxFuE/7tVrwSBpUJ/hfhPWoyk8TUH0DQ6OYoELn
	CQN3J92qmksT7kMhsnwXUCuzWRxnFoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7E0D60218;
	Thu,  1 Oct 2026 18:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396861F000FF;
	Thu,  1 Oct 2026 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880176;
	bh=uwZ2rsWGvMJKClUG1hn9YbZEiJLt9Kacj4MriMozc3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Sip89Hr+ljBrGcOlZuTFng6Yqymu0XsVLS6Q+f1OX0DDrRQnrOKfRUf3xbLFMK5Rr
	 MGzF7i7XGQBNseZmtpyyiB/Co3VpFaNBPSf2A74ffOjYSaMlwK3tDSZvpKMzRupD6R
	 O7Xg0CYiEN8k4Xxe1v/zA5BBufzoFWLjZrfaDx9f6akDG7TpDC3QSzRxH0HaqePBFW
	 mrBwdm3/WvWzMp44+0w5Tij93tXGXbnQFnhTGYdA2kAKzrhgE/Rj8tO8MEMa0uEMIc
	 K9C0k4xw42SyxBL5TIQKuefJfoCPrIhOgScPhNRWq6O8+nWwnBdTqR5KUA+FCO5nOa
	 bXT1IZ1Ueruuw==
Date: Thu, 01 Oct 2026 08:42:55 -1000
Message-ID: <31a871a07fccc99e953a2d633fc51edc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <ar2kvmCPR9q31V8M@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
	<bda525506b3fb3e61da28a112f28abba@kernel.org>
	<arw4rjVkm2ob9ioL@linux.dev>
	<bc6815954b8d08e75deadd43e1a2192c@kernel.org>
	<ar2kvmCPR9q31V8M@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: j9o5rbjpczb4ku3mjeki65m8miusmtef
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D1CD8000B
X-HE-Tag: 1790880177-756747
X-HE-Meta: U2FsdGVkX18e1eOKXFsLTR8/wqmAFjIuV0fxdkA7PaFNlLi1RIGItjfasQFX1N6GZErxF65xF+AoCgn/Z1XBt6uC+mvHsX2ArkoL0utVSjXtKhVG8mSiFMJJD3HzzxkwJe3G7d/VSRNB563sB/qN4LLUFHDP7oiACnbazxjfJbktbQKfG8+CBVm2ZdLoxkqQVDWFIbpOffJiGf96ZxDk7ZjSwXZBsXDDIvTkd8BXfV0uf8TQf5hb6xPfW3WMAU0U86xX3/MLICGNTatJjcKiB2tAM5uaEOinXvFvXl7hZdmGjDGAu7y57/14fOIqNW6nzV7cup5c7k6EMlzljHVcRL8FgOcUxMe8dz5RJ+BD9Ly3D1sEKFOKpkUUQMKMX9id5rw2QJrc4KOuBkNl+C9y9U5R9gh4Qhk+s6R5jl3QUogPDi7iAs9iOa+ln4FnkUFPcZ4ZOBpS8TcLvH5rxQuBkF3lXeeJH1rTwGg3IeIG28scnCUEo2bv7yr8aWOVFDDf9MqbHjXqCeT1jMevXLZziu2C+WOeXwnOd+KZdCw/zpdY6I0OWcnKTOdRPhz5IORaFgetsWWBaU45BJ0A0HhHKUF+9nWw2d/umro6UBnZmbdeXJa8ILozQS2DF8j1XCmkm8mCXaQ+I9BeZMHW7p6viV+uhEczeWuZfykc002McJjsCeI1FuVX2lSrhcfK1Ts3elx5VxCgAWu/+6FDMAD8rqj5KMnR3fNNHJj6qqfoCWVxwEySqx/4x1HPt0kaDSwOaD1FImWTmU5y1sjJ5sZIf7jkoOkq4OsO2x6q6X1ExoohZissg3NOZZYVeCQSrCqDLg7sIUE2kMKJyQe49jPCvqtYsfZb04uijK2gTYmihjgMEm+Y43Pb0mZDMB1scezJ2t8MkDs3hCiDlUASM/vrrpuh0OvH8+H9E/s06bJC2n+FiCSTQT+SzLGOifFJ7AXKEIRDZhGDP/tr3bDtoMH
 pT0OV9T9
 K1bLVHgMKUbsu3AOvX8Ap3WBqAFWKDBFKucLC29A+3e8KqkqBXWPXSXCOFiGBpTwzVS70xKJgw4IYJzXSvoD3e3oYysO52+KOMtwSH2TOipZvkTA0Sc9QXYxbfJ5yj/sOHOk33eJykrMZbQtRG7nfq7XWQBWbWpJMK5K2E//OJ0ovMsb0a1WlSO3ZuKsXEVQsoSNGW9wkpYGd75nNFscGDTa8ypFo+BgQwYHiPjKJOvWYMndi+nJtZULtJNg8FDLSh68F81K8Eg4gtfDW9+lKRc4zuD9ghitDKi+RMgH3m1evFQ9NMbjtVcF8+pcIJJR0KFFrlOX7AEddETxOP5hzbS9Matkm9m/8+JhqVzJUHi9C/BQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Wed, Sep 30, 2026 at 06:00:41PM -0700, Shakeel Butt wrote:
> mlock(), madvise(POPULATE), fadvise(WILLNEED) are the obvious ones where large
> amount of memory can be allocated before returning to userspace.

These are explicit bulk memory operations running in the calling task's own
context, so they can be special-cased. Each is a loop with points between
chunks where no locks are held, and the same over-high handler the
return-to-userspace path runs can run there. That keeps the throttling on
the task which asked for the memory and can't cause priority inversions. The
set of such paths is small and obvious, so I don't think it'd be onerous to
maintain.

> > This doesn't seem like a policy problem.
>
> What is "This" in the above statement?

The whole thing, how memory.high should be enforced when the overrun happens
inside the kernel or from a kthread.

> Here if you meant that default behavior of memory.high should work for most (if
> not all) users then we are on same page. If some user want memory.high reclaim
> to happen in a separate thread instead of return-to-userspace or synchronously,
> this proposal provides mechanism through BPF to such users to achieve their
> goals.

I think there's a common reasonable solution here, which is deciding by who
the charge is for. A task charging for itself gets return-to-userspace
enforcement plus the checks in the explicit bulk operations above. A kthread
or anything else charging on behalf of a cgroup shouldn't be throttled for
the cgroup's overrun. The overrun is attributed to the cgroup, async reclaim
is kicked, and the cgroup's own tasks absorb the throttling on their next
return to userspace. The in-charge synchronous fallback goes away. Each case
has one reasonable answer, so I don't see a policy choice to expose here.

Thanks.

--
tejun

