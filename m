Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B32CD4F47
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 08:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4EE6B0088; Sat, 16 May 2026 04:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065036B008A; Sat, 16 May 2026 04:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E960A6B008C; Sat, 16 May 2026 04:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D744E6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 04:40:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 676838CED5
	for <linux-mm@kvack.org>; Sat, 16 May 2026 08:40:12 +0000 (UTC)
X-FDA: 84772635864.06.70305FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 65D5820009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 08:40:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tvbS/DGA";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778920810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1upjbCNeWkySpC2wmpGFkK7rJ7Wnn6KsVqLnsbw7FJY=;
	b=wl1MPQ/QX4dh/oliSU22Dp7dnZ0VRJ+7HNSKA1AM/4t47lSfFJHNBHwDvxgtn7LQOQVNB7
	+BFIIc8nYytXVxvK/lAln6Ss1Iskfcsj4dDeLuq7ZpOk8SNAtokdTtIKeQAnUKRcwGLl3J
	YBLYJUaOb+Lsog2K1i/ATJa/fgG+9qU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tvbS/DGA";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778920810; a=rsa-sha256;
	cv=none;
	b=OglpV93btSdern6qzFvgFsaH+AZObtSC4c2B+e+QhbBW/71tc1LEoeLf3BPgnMkEoJ2XuC
	l1XcOsAn4e5/iPOw9f5VxG85eRgjfhBBaqyk0McoHWe+SwhPW37D9DyQo1iW40tarC5GG2
	WCK9QXD5Lf7kFSdEOwQPejLvRsbr04s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47233416A4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 08:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20469C19425
	for <linux-mm@kvack.org>; Sat, 16 May 2026 08:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778920809;
	bh=y+cssOF3JI3QPMolzFAOadB7Do4nnXYRXVDNACSVwkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tvbS/DGAmwukiGZJwJxkLpU8q18SbF1usZs165c2E4z129+TCBxQRgO79D6/d3FSG
	 grpo2HrkUzRjYbo0B4eFX7NXzK9MoowEVLeS9obWh7xDVirpHEvDgivl2EkoK4f/pB
	 U49SOqLzMpvXoF+I16XeKoGVcQNa/dLpyXTmFs+7/p1Mj5e/scwaeMaJmyJrt020Hb
	 R7ygS24p4zLcx/nztB1ztLZYDvK28yIUhhvX8nyVsN4OcDHppEEFQWEqjDxEi30oIn
	 tfv+FPDDCN/QDDn71qq28hU0HK2L/ojYnDxhEaNoHt0HpFJPfBu170/5vnRJpUHIR0
	 iJ79PgQ2bpPPw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso11442896d6.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 01:40:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/ASdCfag1BCFpznP3VWyeAlEf63vX68N5SnUL5Jyl42SXU2JKGaBmZflxwFdF6E3oSimddrmveVg==@kvack.org
X-Gm-Message-State: AOJu0Yw4gTrvU9JM3cxB0alK2ZHyL/Cw3rWxlBcbDxja7OAxvSBSI5/A
	LCIsmSGiNiD4u/iWBdXYQ+/5+EbG/XVQCXxFO3uVeMHhkH04gdu3091m8vRJRraYjeapzsuyVCd
	ox1WQERuE5DBjtpdLB1jKBBELJJ4kl8s=
X-Received: by 2002:a05:6214:484a:b0:8b1:f2e9:2996 with SMTP id
 6a1803df08f44-8ca0f6f9b30mr88104796d6.15.1778920808440; Sat, 16 May 2026
 01:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
In-Reply-To: <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 16 May 2026 16:39:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
X-Gm-Features: AVHnY4KGpLFyShwsPFT2_ko1YKgIHsQeEWpI94e5tOAyYvyldimzi4eq_T9PySo
Message-ID: <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: "T.J. Mercier" <tjmercier@google.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
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
X-Stat-Signature: 8fpwd18ewaauu1qhyukh74bt8oiho149
X-Rspamd-Queue-Id: 65D5820009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778920810-590284
X-HE-Meta: U2FsdGVkX18S7Er70uXG9gHtiXiSJJBaBcWKUuIn2+NOCigobU8ntAH3+Jg7FxeOJ2pKEJFbKLJ1TVRb5k+lVnnAeaKs9jNlIu7gs6yAv5Lz5bcUoUSVzChxT56mz1r9g1dUB47l0/ulBWNMHOVd/kGByXOqkqGHGdfqFLqfUCTvCCvWS59KNzWrmn7CSjZ7CSEA1W+x+JgP4Iga8iB43JvyPWUl7kDGtF4BhvFlroRM8xnxxGzBev4fM2q8NpUSx/toEesom19WsHihwyNAJRUkJMDcjhYocNT1O6tI3TTyEqr1KAf2vtXvs0rDKz90WpA+UE6wfTEsb/VhE2Pj+iw0cOkEGnKcf4RYgwkecUWz+n1ghaxi+/TDGkNsPOwQ9068DlAyrEz1RNxE2T8Jav7PPLt201L8cJkQ0qsMzEcoe2LHsH+kBjFqeLx87DY0wlzhNWK+1jJwNOVYaeslFHbZHviqV7xGGQAHUdlR6yX7lw1VepCQEKT6Z9uS4AHP5+ub8KnArsGBL3HZfsFuEdxQaBJt+OwCcWiTmNyBPPo4sSep8lejAraAGYiw1YP8mktZHy/EH6UsBaU4RQ2PiuVktQtys1OzJzKn4c0DDOGgDD5ilfp+sEaDMEhuUnSljlATj4e4oM7gsAXfCYhO1Gyjh864EaYBhvHdFLfvnYJvBwjjbvB9qhS/QcI2t2IGI0mKJtAQ/DBt0Ijq8XK71QQwCSCAax6Mbwv3mCvYXlEc0sffPEjmpfYZXq1VCqRzSTWKMM5w1PAlbw/S7Avxdm6P7OXDQN/JHrAoymnxqkKUIuyRTDNN9/BgZDGeTUP9RuZnvlNaR0NZObJ84HxUNps0HDMMyxgQ9onlRLpPLiX5DisTso30aqNqCKDIjCZKiVs4hsPOXka1mKkUFJRHHKfQpjOmSs4RYXquMvDNPOxk1Nk0iZHH1Jn3PMNmjgYkOcjlOrZRMjabUQFiapQ
 aK/aZ4I8
 YDLFuULgxdCX5sJAGHuZlK/EcewiG7lmb4ZRK3elFBsCd18OOFgoKi9L3XbIkHyKWnJXtHpF2ZKC8iLBcPbldLvwjpvuMZVXKDjYLviXjuk/7SdcF9gC4CZPOjJE+wt27ymH8TxRsDDlEo3f6QWTaMMGnUBtMMqPCNmr3L2yWdT0qpArlWN5z8KCntrhsOq021Z8WRUYQzWC+v3xLHEtuHWrQcfpXEApWC3rabDtTeTDApgo/neJFXkdprcL1nazVQ0qqsY992A8VM75SAVQh69h2xDCXbZkqREgMXoCV2wcRVKu1fta66zDn43VEy6g3COUA29pDvN4k8zzQjz3XsH1feZcsjgCh+WQuFWUakCO7h0hsfQl55K6PA7KBJwMFAmy717wX2K129lFp9wIGkMjsvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 2:54=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Tue, May 12, 2026 at 3:14=E2=80=AFAM Christian K=C3=B6nig
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
>
> Yeah I think this might work. I know of 3 cases, and it trivially
> solves the first two. The third requires some work on our end to
> extend our userspace interfaces to include the pidfd but it seems
> doable. I'm checking with our graphics folks.
>
> 1) Direct allocation from user (e.g. app -> allocation ioctl on
> /dev/dma_heap/foo)
> No changes required to userspace. mem_accounting=3D1 charges the app.
>
> 2) Single hop remote allocation (e.g. app -> AHardwareBuffer_allocate
> -> gralloc)
> gralloc has the caller's pid as described in the commit message. Open
> a pidfd and pass it in the dma_heap_allocation_data.
>
> 3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
> SurfaceFlinger -> gralloc)
> In this case gralloc knows SurfaceFlinger's pid, but not the app's. So
> we need to add the app's pidfd to the SurfaceFlinger -> gralloc
> interface, or transfer the memcg charge from SurfaceFlinger to the app
> after the allocation.
> It'd be nice to avoid the charge transfer option entirely, but if we
> need it that doesn't seem so bad in this case because it's a bulk
> charge for the entire dmabuf rather than per-page. So the exporter
> doesn't need to get involved (we wouldn't need a new dma_buf_op) and
> we wouldn't have to worry about looping and locking for each page.
>

Hi T.J.,

Your description of the three different cases sounds very interesting.
It helps me understand how difficult it can be to correctly charge
dma-buf in the current user scenarios.

I=E2=80=99m wondering where I can find Android userspace code that transfer=
s
the PID of RPC callers. Do we have any existing sample code in Android
for this?

> > I'm just not sure if this is future prove and will work for all use cas=
es, e.g. cloud gaming, native context for automotive etc...

Thanks
Barry

