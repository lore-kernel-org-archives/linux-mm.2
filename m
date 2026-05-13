Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C917CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D6C6B008C; Wed, 13 May 2026 12:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644AA6B0096; Wed, 13 May 2026 12:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534696B0098; Wed, 13 May 2026 12:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF086B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:39:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB003C1905
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:39:26 +0000 (UTC)
X-FDA: 84762957132.20.2915172
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA1D9C000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:39:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J9MPKKbW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778690364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOVJmPkMMtutEBgPE85iBoY/7XAmkTfBx4YFHq1zHJQ=;
	b=LoCoVpKR4YpR0I3u0lm22Q3o6mMLsxHUzA1xh1b5FJMiJFoi6KJFW80wmCTzXvcIHNcjp0
	Fif1YNjxEtRr8LpzRgZnx+TtZKTkYtWbxC1q1LYHnsnEzuEUbUtqobu5JTXOA45Q4OTaaR
	9wwudwF3+16rKj9X2xJLDL6fxTXXo8Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778690364; a=rsa-sha256;
	cv=pass;
	b=SFk/ijXWUP8AZbx8j3XuwpBnC6qvGawzexzTSgubsLkr02084t+Ts/nOHWmlnzxKyeJJj9
	tFm8+6itS7H6hwKtknUsiwas9El3khyJiCPyBBprEbIhc8uv5XspaJ1T0x4mxmLeRoTulh
	1M0po1lwPGimMDVMQ7f4qWK/HoQnGdw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J9MPKKbW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48d1c670255so4575e9.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778690363; cv=none;
        d=google.com; s=arc-20240605;
        b=MYy1c6F8AP4NIl6FG77Ph1yKVwikHd/Ee180yvYvwk/wYLakTo2WU5ocQvtI8KwDYp
         2Wx0lWd2MHBdiKamZhAHeQEBNpwCsg3NgoFuhpUshbn2OR8rTQNiXHT7zZCo3NCBhFNE
         wfeyWSkV2iNTsMG+O6XRYs/H+UH4FMDr0X4fAK0e/iHgIQ0m9rASzhPE+U3jRDK8eCEd
         lKV6HgF5AuyIMP1tJADKdPr4XRYekfw9D/hQfXMu/2zNNNdk8qJ1UuGqfi3mEE5jfK6u
         Uc+HwR1QeGKW3ryo9fqVwLoYFKsSpUwS5QXytDBImPslaplczgSSKwcaKathyRV42KbK
         +Y0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hOVJmPkMMtutEBgPE85iBoY/7XAmkTfBx4YFHq1zHJQ=;
        fh=zCtsefW7Uj+HpEecP1Wm3oAypaARRk6OTH1BUrnmp1U=;
        b=MwqiAiTQCENgz4bkXIiAfNwm3oTjJ56Cu6MyaiiqfXeoX5Yqkt+OMy0M6Y73omxMzF
         MSTySnkbErcdmHdWdY0+hVQstxT8ognECycDGKHR7t0AAjBmWtU8S788g5BIja0k/p/j
         gDKLqgZPkdT7AdDbtWoY7CP2uPD1YIpWErPbXKogcuF0K+DZo5ztsuNUJopOlUEzT98Y
         t7suokulrOlyGqq2WWdIk6vxgkpiD7QD1ZfVQ21ip3wnIiqiSKWpidbL6fZ+hAUXwsHu
         U/V248KvS/CJkKVD2cM8Y7e2fBcM5d35Ent/Su7RKCgIH8PGImls+JhjYXWycoByZuE2
         QlJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778690363; x=1779295163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOVJmPkMMtutEBgPE85iBoY/7XAmkTfBx4YFHq1zHJQ=;
        b=J9MPKKbWoKsf21zFE+hz2M4iw2JUmT51kOvX7Tnc/gsZ3Kmqa1c3wa13S1W6ixXHpJ
         cFCBiur6jETpZW+Tu2oLQSp2I4mnxig/YHWPRPOEQ5U5oQBK0JJgGeTXMKcCsdLBEIIg
         uxYwirp0U0eXyV6vT5ubmlqbP3HSKoZNLYdg4qELVeR+ldRivCTZJ6oaDRyWNsgTGNma
         J1qKYi1KngjMQNhYKTIbWvs4Q9qDrLrjDFlVwyaSjxuMhn+UcMXMDouaa5VQz7KCmj9W
         jyO92Wt58PfN91UcMCePfe4XU/lhVw6tz16vMoerfm+vkfNGPo7Pnlo5sLud34LKwJUI
         mtew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690363; x=1779295163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hOVJmPkMMtutEBgPE85iBoY/7XAmkTfBx4YFHq1zHJQ=;
        b=pjGL+tI/Ll+K77WkHTcfBTa7fL25Y2XMzwX+7wj3y8T23LJ4VfDm5JDo+ekzEtSFym
         E8ifv12NMsNbiyGe7XOcC1gko0wjNkKazaHFABBOXgzLYiDM8bbRXqI8F8bOdyxgJlVy
         1Ql6R0KLR3w9wY4kmFiA1mXCbWq1eD8udaW0cmu4m+VN+GVEqiEVMHNYX51qIRNYKiYv
         4k5dbIrHdo37d9sI0jecJ/kPPTuEX49zK9/ZncL1FyG5GmKjuB7UkQUgUYz+qbxPOULS
         uFg3yv3ZYAujnj2sGKXyIXYDu41B2ZC1U6M8nocWYlTudlKy1SrYoWHPximDaxS3Deho
         0CPg==
X-Forwarded-Encrypted: i=1; AFNElJ/2m+I9EP0ZvEOYO99QqAyU7Lz0MkHLfUleMDDn8NH71h09u2EMmv4c2z0urjrH8OyYrUxNDb1TUw==@kvack.org
X-Gm-Message-State: AOJu0YzHiLyDOXYfm8FyBghPG9LqCm5/xqvtIgDr5CJQa0k7O5xbzXVt
	6A4vs61RRXXNzsFSDsKZmdqwT64EIuxp2PVuoRvr2ZYuc34jFs7XzGmmG8dxy4innDsc0nd0CHS
	Vdt13d1GMYifWbrltJ8plpMvRfoHGjsRj5lbkljBL
X-Gm-Gg: Acq92OGmExt2YEqW7Ql2A+cjR8W3bzb9vwY35j4tyBc/w+oSDF3r5xpTkxOE/Il9A5Q
	axDmeJLgGHWsov2AXgf7Sots5vVkJKxQhmeREed3YYMV3L08Wp3I20e680eve5r8NosJ6XITnsL
	zGgWhT3CVF680zmn6Ec6CX9UIYfo/TM8KEePr8ogf8YZJK56UVdi4rECNyvKf0GAYNHCmeRGdIe
	A2MXgTE6HBHkq4rt+94N8RfKtAzBSi1VU/ym7WoJxQOOFbQt4IXC7fivCpy7taqE6HpgwSLtdBs
	qsJDYjmj3aqApJVTIvKmbcVhKRHfMMI30qfWBeiFFgkBQx5rEHIKf/y0/Sy46RuaExLdOIIEkwj
	wCinw
X-Received: by 2002:a05:600d:8486:20b0:477:86fd:fb49 with SMTP id
 5b1f17b1804b1-48fc919a43dmr965705e9.10.1778690362738; Wed, 13 May 2026
 09:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CADSE00KZMJFYJ92XZa=r9EeJJRGT=SNChwOW-_jTznc7F79xGw@mail.gmail.com>
In-Reply-To: <CADSE00KZMJFYJ92XZa=r9EeJJRGT=SNChwOW-_jTznc7F79xGw@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 13 May 2026 09:39:10 -0700
X-Gm-Features: AVHnY4Le2GUGE4TjoBj6HdQ1GbUQChjLautyZmM4nJTx4rLM4Wl1vLSY-yCAZrQ
Message-ID: <CABdmKX3R5faNgFva-HHVhtTcxJ0_BK9Rei3iTQcA+SRwdKv1Aw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Albert Esteve <aesteve@redhat.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mripard@kernel.org, echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AA1D9C000C
X-Rspamd-Server: rspam04
X-Stat-Signature: gammm6fmukws9gykmq66wdm9648xpfaq
X-HE-Tag: 1778690364-461313
X-HE-Meta: U2FsdGVkX19xuLOQ91F+GEbYSznFyDsZkNnbFwL0ARScAnWXNNUA75d1WRnb/oWv4EebkI4Or1tZn+rcotONLy+Rby52QqPWLezSi0hpx9SI2zjrfxFvGsPLlrKGVvPby2kvoLTATqBeMMM4d8oibv4ceFi3hSXqxns6aSP4z6Fb77JXvi1BC8CJ5Y9OCFS0jA4EurK/TfVYWe+1SpRAiYYohOUHLJAAJkkb+0MeuHimQx1eQZvSExeWnDeu7D4BIYbT8qC0lSInSL9p3+Q8mdt4XZJ9hC2/9BZANNobFri2tFlapY5dPq0nWKV8eM180mqwzvoeSdachaC5sCE4Mb8NF3M84cnI/Z5bHGL2XnKXhEB9WdT6sLjaaIaSCtexT451FyS2fpmbeOsU+beoJ+ohGhb+I25eSpbM5ZwWiQecOAISJ9m6c42+P+l+wW54Yd1vboGOnkluFS8jaJtwVbfbLaBXHmP7lNKl2t8TOXfP+0QefsmQ/dY2hc0RQVNb+OUfgg0Qc/jAmCxTvQM9A0VB5PKsOPhbejkurjjPMUv0t5YvKcVYoAVVVaxLjnk0fadcAps8B7aI5slST0+vXJBQusRwd2ITfINT+bOzKCNZdzCJzNyEI0kUdXg3IFfR9SlbrJ7Ov5H9x2k7TBUSMpGgIePUDn38okQXHzvipF53Zp/fojRXpFopxeiiNOOLdke/CQ7ShpG5NXEMY5sL3K/rVZQi4pAP1ZhY16nY5LoXQ5oaCd7/T5HSggWvWwJB4HwwDlkb3pir+1YePKb2ydxL1mmosn3WSQRPcwav+ZpNfbZShIkkqA/Ky7BcGCqelWFhDxpbSeNiRYexZPWOw9TZr/G7gY8B+ODsRxuP63/Mnzhj2s+3F2IEOC2bBB6Jq7Hkkd6uBvQVMvMwc3IryYfFAgWmbqwKOlG4sYGQOtXldz1ll9Jg/tYNYqUNJlzgGUqHGghVCCRf8A6iAJx
 tN3cLRIk
 6GtgU9/rKXLeGXA03xJppjiNxmj7i6dNy8MV2zW/COOmDB/GyBpvUXBABP4y40culxUkHk1QJ+P0a/ferUOur7K/rxaH/DzjL7N6Lmqzhqwgf7jR/URlSBIgHGFADUPZ7lqcDH/ACcBcn7CSB1SgwWj0Y3PJ3e3jkjB95KdFQAx6KEmcz4YN0agiRIQCgDFk9f2B2RlTx2lxMSRbljgK5/dZV9OMLPYBvOotCPeCZXwWr0bBNeuHhO9KkLm1ZuKgmBFpHTs/Z8v21G2Sa2kLC65mDJU8PEU/GQDfBCkkx2F/TwXllKFYxENNBFaq4H6P3nAA2aRRoKmQWdgCmnR61ZnyrFl7sifDi6Hk5M2oC70CQyFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 5:41=E2=80=AFAM Albert Esteve <aesteve@redhat.com> =
wrote:
>
> On Tue, May 12, 2026 at 12:14=E2=80=AFPM Christian K=C3=B6nig
> <christian.koenig@amd.com> wrote:
> >
> > On 5/12/26 11:10, Albert Esteve wrote:
> > > On embedded platforms a central process often allocates dma-buf
> > > memory on behalf of client applications. Without a way to
> > > attribute the charge to the requesting client's cgroup, the
> > > cost lands on the allocator, making per-cgroup memory limits
> > > ineffective for the actual consumers.
> > >
> > > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> > > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > > the mem_accounting module parameter enabled, the buffer is charged
> > > to the allocator's own cgroup.
> > >
> > > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account for
> > > system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> > > page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> > > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and route
> > > all accounting through a single MEMCG_DMABUF path.
> > >
> > > Usage examples:
> > >
> > >   1. Central allocator charging to a client at allocation time.
> > >      The allocator knows the client's PID (e.g., from binder's
> > >      sender_pid) and uses pidfd to attribute the charge:
> > >
> > >        pid_t client_pid =3D txn->sender_pid;
> > >        int pidfd =3D pidfd_open(client_pid, 0);
> > >
> > >        struct dma_heap_allocation_data alloc =3D {
> > >            .len             =3D buffer_size,
> > >            .fd_flags        =3D O_RDWR | O_CLOEXEC,
> > >            .charge_pid_fd   =3D pidfd,
> > >        };
> > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > >        close(pidfd);
> > >        /* alloc.fd is now charged to client's cgroup */
> > >
> > >   2. Default allocation (no pidfd, mem_accounting=3D1).
> > >      When charge_pid_fd is not set and the mem_accounting module
> > >      parameter is enabled, the buffer is charged to the allocator's
> > >      own cgroup:
> > >
> > >        struct dma_heap_allocation_data alloc =3D {
> > >            .len      =3D buffer_size,
> > >            .fd_flags =3D O_RDWR | O_CLOEXEC,
> > >        };
> > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > >        /* charged to current process's cgroup */
> > >
> > > Current limitations:
> > >
> > >  - Single-owner model: a dma-buf carries one memcg charge regardless =
of
> > >    how many processes share it. Means only the first owner (and expor=
ter)
> > >    of the shared buffer bears the charge.
> > >  - Only memcg accounting supported. While this makes sense for system
> > >    heap buffers, other heaps (e.g., CMA heaps) will require selective=
ly
> > >    charging also for the dmem controller.
> >
> > Well that doesn't looks soo bad, it at least seems to tackle the proble=
m at hand for Android and some of other embedded use cases.
> >
> > I'm just not sure if this is future prove and will work for all use cas=
es, e.g. cloud gaming, native context for automotive etc...
> >
> > Essentially the problem boils down to two limitations:
> > 1) a piece of memory can only be charged to one cgroup, the framework d=
oesn't has a concept of charging shared memory to multiple groups
> > 2) when memory references in the form of file descriptors are passed be=
tween applications we have no way of changing the accounting to a different=
 cgroup
> >
> > The passing of the memory reference already has a well defined uAPI and=
 if we could solve those two limitations we not only solve the problem with=
out introducing new uAPI (with potential new security risks) but also solve=
 it for all other use cases which uses file descriptors as well as. E.g. me=
mfd, accel and GPU drivers etc...
>
> Honestly, adding a hook to fd-passing uAPI to manage charge transfers
> sounds like a promising solution requiring no uAPI changes. However,
> it still does not cover all paths, e.g., dup() or fork(). And shared
> memory sounds like a hard one to tackle, where deciding the best
> policy is more a per-usecase thing and would probably require
> userspace configuration.

I'm curious if anyone knows of a use case where FDs aren't involved at
all? It's possible to fork() or clone() with only a dmabuf mapping and
no FD. That sounds strange, and I'm not sure there's a real usecase
for transferring ownership with that approach, but figured I'd at
least pose the question.

> All in all, charge_pid_fd covers a
> well-defined and immediately practical subset. The UAPI cost is small
> and the mechanism is explicit about what it does and doesn't solve. A
> general solution, if it ever converges, would likely supersede
> charge_pid_fd for most cases, which is a fine outcome if it solves the
> problem more completely.
>
> Either way, if you have a specific approach in mind for solving any of
> the above limitations, I'd be happy to look into it further.
>
> BR,
> Albert.
>
> >
> > On the other hand it is really nice to finally see this tackled for at =
least DMA-buf heaps. On the GPU side I have seen just another try of a driv=
er doing some kind of special driver specific accounting to solve this just=
 a few weeks ago. And to be honest such single driver island approach have =
the tendency to break more often that they are working correctly.
> >
> > Regards,
> > Christian.
> >
> > >
> > > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> > >  drivers/dma-buf/dma-buf.c               | 16 ++++---------
> > >  drivers/dma-buf/dma-heap.c              | 42 +++++++++++++++++++++++=
+++++++---
> > >  drivers/dma-buf/heaps/system_heap.c     |  2 --
> > >  include/uapi/linux/dma-heap.h           |  6 +++++
> > >  5 files changed, 53 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/=
admin-guide/cgroup-v2.rst
> > > index 8bdbc2e866430..824d269531eb1 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1636,8 +1636,9 @@ The following nested keys are defined.
> > >               structures.
> > >
> > >         dmabuf (npn)
> > > -             Amount of memory used for exported DMA buffers allocate=
d by the cgroup.
> > > -             Stays with the allocating cgroup regardless of how the =
buffer is shared.
> > > +             Amount of memory used for exported DMA buffers allocate=
d by or on
> > > +             behalf of the cgroup. Stays with the allocating cgroup =
regardless
> > > +             of how the buffer is shared.
> > >
> > >         workingset_refault_anon
> > >               Number of refaults of previously evicted anonymous page=
s.
> > > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > > index ce02377f48908..23fb758b78297 100644
> > > --- a/drivers/dma-buf/dma-buf.c
> > > +++ b/drivers/dma-buf/dma-buf.c
> > > @@ -181,8 +181,11 @@ static void dma_buf_release(struct dentry *dentr=
y)
> > >        */
> > >       BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
> > >
> > > -     mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->si=
ze) / PAGE_SIZE);
> > > -     mem_cgroup_put(dmabuf->memcg);
> > > +     if (dmabuf->memcg) {
> > > +             mem_cgroup_uncharge_dmabuf(dmabuf->memcg,
> > > +                                       PAGE_ALIGN(dmabuf->size) / PA=
GE_SIZE);
> > > +             mem_cgroup_put(dmabuf->memcg);
> > > +     }
> > >
> > >       dmabuf->ops->release(dmabuf);
> > >
> > > @@ -764,13 +767,6 @@ struct dma_buf *dma_buf_export(const struct dma_=
buf_export_info *exp_info)
> > >               dmabuf->resv =3D resv;
> > >       }
> > >
> > > -     dmabuf->memcg =3D get_mem_cgroup_from_mm(current->mm);
> > > -     if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf-=
>size) / PAGE_SIZE,
> > > -                                   GFP_KERNEL)) {
> > > -             ret =3D -ENOMEM;
> > > -             goto err_memcg;
> > > -     }
> > > -
> > >       file->private_data =3D dmabuf;
> > >       file->f_path.dentry->d_fsdata =3D dmabuf;
> > >       dmabuf->file =3D file;
> > > @@ -781,8 +777,6 @@ struct dma_buf *dma_buf_export(const struct dma_b=
uf_export_info *exp_info)
> > >
> > >       return dmabuf;
> > >
> > > -err_memcg:
> > > -     mem_cgroup_put(dmabuf->memcg);
> > >  err_file:
> > >       fput(file);
> > >  err_module:
> > > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> > > index ac5f8685a6494..ff6e259afcdc0 100644
> > > --- a/drivers/dma-buf/dma-heap.c
> > > +++ b/drivers/dma-buf/dma-heap.c
> > > @@ -7,13 +7,17 @@
> > >   */
> > >
> > >  #include <linux/cdev.h>
> > > +#include <linux/cgroup.h>
> > >  #include <linux/device.h>
> > >  #include <linux/dma-buf.h>
> > >  #include <linux/dma-heap.h>
> > > +#include <linux/memcontrol.h>
> > > +#include <linux/sched/mm.h>
> > >  #include <linux/err.h>
> > >  #include <linux/export.h>
> > >  #include <linux/list.h>
> > >  #include <linux/nospec.h>
> > > +#include <linux/pidfd.h>
> > >  #include <linux/syscalls.h>
> > >  #include <linux/uaccess.h>
> > >  #include <linux/xarray.h>
> > > @@ -55,10 +59,12 @@ MODULE_PARM_DESC(mem_accounting,
> > >                "Enable cgroup-based memory accounting for dma-buf hea=
p allocations (default=3Dfalse).");
> > >
> > >  static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
> > > -                              u32 fd_flags,
> > > -                              u64 heap_flags)
> > > +                              u32 fd_flags, u64 heap_flags,
> > > +                              struct mem_cgroup *charge_to)
> > >  {
> > >       struct dma_buf *dmabuf;
> > > +     unsigned int nr_pages;
> > > +     struct mem_cgroup *memcg =3D charge_to;
> > >       int fd;
> > >
> > >       /*
> > > @@ -73,6 +79,22 @@ static int dma_heap_buffer_alloc(struct dma_heap *=
heap, size_t len,
> > >       if (IS_ERR(dmabuf))
> > >               return PTR_ERR(dmabuf);
> > >
> > > +     nr_pages =3D len / PAGE_SIZE;
> > > +
> > > +     if (memcg)
> > > +             css_get(&memcg->css);
> > > +     else if (mem_accounting)
> > > +             memcg =3D get_mem_cgroup_from_mm(current->mm);
> > > +
> > > +     if (memcg) {
> > > +             if (!mem_cgroup_charge_dmabuf(memcg, nr_pages, GFP_KERN=
EL)) {
> > > +                     mem_cgroup_put(memcg);
> > > +                     dma_buf_put(dmabuf);
> > > +                     return -ENOMEM;
> > > +             }
> > > +             dmabuf->memcg =3D memcg;
> > > +     }
> > > +
> > >       fd =3D dma_buf_fd(dmabuf, fd_flags);
> > >       if (fd < 0) {
> > >               dma_buf_put(dmabuf);
> > > @@ -102,6 +124,9 @@ static long dma_heap_ioctl_allocate(struct file *=
file, void *data)
> > >  {
> > >       struct dma_heap_allocation_data *heap_allocation =3D data;
> > >       struct dma_heap *heap =3D file->private_data;
> > > +     struct mem_cgroup *memcg =3D NULL;
> > > +     struct task_struct *task;
> > > +     unsigned int pidfd_flags;
> > >       int fd;
> > >
> > >       if (heap_allocation->fd)
> > > @@ -113,9 +138,20 @@ static long dma_heap_ioctl_allocate(struct file =
*file, void *data)
> > >       if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
> > >               return -EINVAL;
> > >
> > > +     if (heap_allocation->charge_pid_fd) {
> > > +             task =3D pidfd_get_task(heap_allocation->charge_pid_fd,=
 &pidfd_flags);
> > > +             if (IS_ERR(task))
> > > +                     return PTR_ERR(task);
> > > +
> > > +             memcg =3D get_mem_cgroup_from_mm(task->mm);
> > > +             put_task_struct(task);
> > > +     }
> > > +
> > >       fd =3D dma_heap_buffer_alloc(heap, heap_allocation->len,
> > >                                  heap_allocation->fd_flags,
> > > -                                heap_allocation->heap_flags);
> > > +                                heap_allocation->heap_flags,
> > > +                                memcg);
> > > +     mem_cgroup_put(memcg);
> > >       if (fd < 0)
> > >               return fd;
> > >
> > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/he=
aps/system_heap.c
> > > index 03c2b87cb1112..95d7688167b93 100644
> > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > @@ -385,8 +385,6 @@ static struct page *alloc_largest_available(unsig=
ned long size,
> > >               if (max_order < orders[i])
> > >                       continue;
> > >               flags =3D order_flags[i];
> > > -             if (mem_accounting)
> > > -                     flags |=3D __GFP_ACCOUNT;
> > >               page =3D alloc_pages(flags, orders[i]);
> > >               if (!page)
> > >                       continue;
> > > diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-h=
eap.h
> > > index a4cf716a49fa6..e02b0f8cbc6a1 100644
> > > --- a/include/uapi/linux/dma-heap.h
> > > +++ b/include/uapi/linux/dma-heap.h
> > > @@ -29,6 +29,10 @@
> > >   *                   handle to the allocated dma-buf
> > >   * @fd_flags:                file descriptor flags used when allocat=
ing
> > >   * @heap_flags:              flags passed to heap
> > > + * @charge_pid_fd:   optional pidfd of the process whose cgroup shou=
ld be
> > > + *                   charged for this allocation; 0 means charge the=
 calling
> > > + *                   process's cgroup
> > > + * @__padding:               reserved, must be zero
> > >   *
> > >   * Provided by userspace as an argument to the ioctl
> > >   */
> > > @@ -37,6 +41,8 @@ struct dma_heap_allocation_data {
> > >       __u32 fd;
> > >       __u32 fd_flags;
> > >       __u64 heap_flags;
> > > +     __u32 charge_pid_fd;
> > > +     __u32 __padding;
> > >  };
> > >
> > >  #define DMA_HEAP_IOC_MAGIC           'H'
> > >
> >
>

