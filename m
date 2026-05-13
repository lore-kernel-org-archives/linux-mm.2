Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FD8CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0456F6B009D; Wed, 13 May 2026 14:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D046B009E; Wed, 13 May 2026 14:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75006B009F; Wed, 13 May 2026 14:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D27EA6B009D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:39:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F60EA01CB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:39:31 +0000 (UTC)
X-FDA: 84763259742.08.361C186
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2ABA280002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:39:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoODkc69;
	spf=pass (imf02.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778697569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROcBtD9Wr7UD9hLCfUAUnfLLz4HmQcTljHWV4B5LJ+A=;
	b=36Dgy2c/JF6Lk1iw5LV4sRZkyFzADJOVO7/anWaAcYKMKdIVIxE37I3VRIiPCWjuKbyvb7
	iL2+s3aWNeTqCLeiGa/THn15vo+rxi30wSUBF+D1KZEuqdhR2TL/e4m3tjIaNiFTT42ePH
	1Jab3DY4+3AcMBSfVs0LXSQWX229ntg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778697569; a=rsa-sha256;
	cv=none;
	b=sQjzJKzcY2im4zhJx6CppDI0SuY704ed6gFHbQ5gQmIGzvy+WLEJCjLhBVix5LaZpVDoSk
	+cyWoO7pVsyQuRNMKKlwDhLjJ5WTLWOGUG68u48KfF/tUo2HaaVJCXPBxXellR5vEEJN5K
	UDxNn8syDYhdks2F+EGf2ySbV50SvmA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoODkc69;
	spf=pass (imf02.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778697568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROcBtD9Wr7UD9hLCfUAUnfLLz4HmQcTljHWV4B5LJ+A=;
	b=DoODkc69N/QjV5pHH1gkaev4P6ExGlhu9CaTDXlQbanlinHJ+BPBtehLYHQdKWVPSJMrpz
	+jpCLHoubs2VGScI09Uo3ktJtjb7q9I32b2jdi1sW6apZvcOOjiwBRo3J4d4Kn5fTZLdyJ
	1znGh7lTUdXbcYpD4T+HNuJzvzt1FgE=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-uaKEOnfrMVOVzDcOiDGcAQ-1; Wed, 13 May 2026 14:39:27 -0400
X-MC-Unique: uaKEOnfrMVOVzDcOiDGcAQ-1
X-Mimecast-MFC-AGG-ID: uaKEOnfrMVOVzDcOiDGcAQ_1778697566
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65e0d38adcbso247227d50.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 11:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778697566; x=1779302366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ROcBtD9Wr7UD9hLCfUAUnfLLz4HmQcTljHWV4B5LJ+A=;
        b=nWEtNzNsD9s390yWKz+l9DgcQTFTNFiDz+VOLRxhrBO6EImrNhDBLlUa/+sABo5oD9
         tXKNEBmeWSLCgCGR3W/jXRASk7gsTOCvkepyUFWJonPCxuGwukpt37XwxZyVioLuMkcV
         /ob/CCtD+2bEzJzxgSJ3Pw408qTdefucKd0d9b02pPudx1MvxsaSAvi/uMnkwr/Vhz8P
         PPgcl+C/wfayRMZROwCfuuT3dAvCj0F5rs2wZ6nY2fn1udsIMtYO0Zz4LHADlrHeOxrp
         HvJwR9icoy8T3OS/s2uX6VqMtd1P1KeIJo98lrS6/3KB8ecSqsfz6YJff5lJJNdZqD4X
         71Mw==
X-Forwarded-Encrypted: i=1; AFNElJ86zy/a6KZdz9Zq2Dm6SGkuPQqthQAbyZY5t2wdl4XfuQATSiaR2Z5ccoYs4pGh2LSHsAkxqlP2Vg==@kvack.org
X-Gm-Message-State: AOJu0YxP0g8IXG1Zbhf+XbMpAZBCkWzrb8rT9Q2uuzjcseztBz7ZArI/
	M8803kHlY/8/DjBzPG3/5A/an8XmYgFs5cQ/ET4d/W9GjikYLMolc+nXl6TkzZy21m8rAbSuyJZ
	mJy838WA4pBgf8iijA3bFxMcd21LgJFUILtAQzs+wcZpHhE2QRgG9DY9iGofWXGpmAfnQQeVmpI
	o2fpfphe+FOmA2FZNa6rtbYfNgg28=
X-Gm-Gg: Acq92OG9QjnrxG62zPJ6nFARuh+UEuuuc7xXv1V7GwINBMHhocy+SCM1WtqF+nta0oN
	CUJORwPq8+L5AuuqqwH+zIIVqzvNtonqVSo5/Omn2ExzzcybxADbpA5BqNihKAzM07wu5VpJ910
	P76SB2qtFxGX10ixb+ugyIogDYXscEFWGsmrW8d8K+VunmVuIupXVUujrupT3z1pgS/wlI1671Z
	hqcfA==
X-Received: by 2002:a05:690c:c50c:b0:7bd:b048:868 with SMTP id 00721157ae682-7c6a96520e4mr46024267b3.8.1778697566248;
        Wed, 13 May 2026 11:39:26 -0700 (PDT)
X-Received: by 2002:a05:690c:c50c:b0:7bd:b048:868 with SMTP id
 00721157ae682-7c6a96520e4mr46023727b3.8.1778697565577; Wed, 13 May 2026
 11:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CADSE00KZMJFYJ92XZa=r9EeJJRGT=SNChwOW-_jTznc7F79xGw@mail.gmail.com>
 <CABdmKX3R5faNgFva-HHVhtTcxJ0_BK9Rei3iTQcA+SRwdKv1Aw@mail.gmail.com>
In-Reply-To: <CABdmKX3R5faNgFva-HHVhtTcxJ0_BK9Rei3iTQcA+SRwdKv1Aw@mail.gmail.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 13 May 2026 20:39:13 +0200
X-Gm-Features: AVHnY4J21kmZlUCM-w5PvXODvvzSq2oNDCUeY291YyLwyrvx79YmoPZ2KHgaokM
Message-ID: <CADSE00KO3gKEOEQ6dEwjgjbYGNotZJ-SRNYjhvqp74dJfu-msg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: "T.J. Mercier" <tjmercier@google.com>
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q1LfHxXtkMFWP7s_dS2vN29szff2tfZtLAV-mruX6uQ_1778697566
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2ABA280002
X-Rspam-User: 
X-Stat-Signature: shidgq1xd8zm9jj8dusr5sprsfaqc9sq
X-HE-Tag: 1778697568-984541
X-HE-Meta: U2FsdGVkX1+EU6FrRlgyDRr0/jWRrfvt89naV1vbW+PvyZXB7ndT1feIeQEZ+tKVO1fNAmIt1KJEdbgWkcEzDjgdSlQ6Aqs5+qnX0qldhwSe3lJgnxWemRsCQFEgh/VW3jr5KP6uLcOg/TIpZftpit4YVlrOZKS8ASpPPTitj0co/mpNwfUtPgJAlqchFa2R15DfnUQXdWyyZ7Xo3JSq4AHodx1wFprcajGGTctxe9uUpU2oFe/c3QZiRT2Gzabo9uMntUd9Y2cOFrlFSlSxVI61upZbmDu84azimSVMLsT25wxHnFsYXy91PPE4Vy2HZITaqJlJrSA0Q/mVQhYLrDKA0314ezxqvMmykW9oFKdsgCBNhwSPAgdGPzn2Gk9gT7gpu6XnMrzE4CsQzBpPrARK4Ifd3+QZuV9EEsJjoOf8OMdgkklVLQZXXDMiWbL2ftKLC1OVnKtFmxsGEKedvCbYw9CcN5i9qiUiyoszMaqgpC0LyiQMYKMcVPsK0b/YiDK682HHXxXtH1ePZXsxlspjgkHQX4wq7/T4IUBTi536MawXWs3drrprMDTzbmPuDbCrZ8FWVGdkAyDiC0IHfQxai09Hh/xvlqdlmZFn2C/yIhqGDVlT0xFSDoH9uih61rNnDznuEnGPEs9QlyUJXsG2AK/PPf3VhKZBcVE9NakTQqz2dyGBKZRgJEahPk3yoN/+zDrBkL38QkEB3ChHMR2PzL5mqpf0CbUEksn1HG/0use5oj7hxEqnp8R2+VxxUujOiz0TWubLy6Qe+WlVfpiMwwaVKe3TiDBfguOM3srEiUzFahlES7rZKW8r+/+HY8qde95XC+N+mnHbMS9VQkaqLWXkDWX0kHESe0VOBP7pg5FToYeZP1OHDQ1XcAbC1a+tfi7YTO803nXb+ZQXZBGTCHqubMPZ+xBHNSgTqlXENrA/TpYptN/aGq755gPrHiKhDvrh9qY4+EzUy9H
 j0kgP2cT
 aTiVYwEq6SUjnC+729AKuZY31uVtKSeOBPcYBlptOBBnyZpjBe0A5LHHuIjwG259LtAiTlPEt+X3uzzappuB+0FiP5QSOQhzcQu3P98/FBzEmutk8VyUTkqo+5Jn049GDg5tUlOk5uhBMkyHMk2fbng87h6o3tYPjULoPa9mtP2bNbOz+9apwVdjA5dPzAQPfB/pUr8MB/lPsE3KEfm8lcwi9VHpsrYYzagte9MNkcwmPFNa3kF2s6nfVJWrOr8m21uG3rh1gLnr0PBUz23H8WhSuaNFnVaIlhQD/sfAp1F36umrUziSfb/BGIoTdBtXs9ccDZApHsSwFJb3vGsFfuL6mUKoj8xphSXtcV7qZr2JdzoyrKjrey8zBjz81Hk0G0UBdUTdrl4tElSNF9tkxIyxjvwYdRgqBYumVuZhByalghvAKYVrd4rqPKJA93gfJlcF3B6Uiv49UQiGMo1VSzgbtgzAXQpLk3Zk8Y54XDkF/yAiHeux78V7ZxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 6:39=E2=80=AFPM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Wed, May 13, 2026 at 5:41=E2=80=AFAM Albert Esteve <aesteve@redhat.com=
> wrote:
> >
> > On Tue, May 12, 2026 at 12:14=E2=80=AFPM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> > >
> > > On 5/12/26 11:10, Albert Esteve wrote:
> > > > On embedded platforms a central process often allocates dma-buf
> > > > memory on behalf of client applications. Without a way to
> > > > attribute the charge to the requesting client's cgroup, the
> > > > cost lands on the allocator, making per-cgroup memory limits
> > > > ineffective for the actual consumers.
> > > >
> > > > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> > > > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > > > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > > > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > > > the mem_accounting module parameter enabled, the buffer is charged
> > > > to the allocator's own cgroup.
> > > >
> > > > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account f=
or
> > > > system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> > > > page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> > > > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and rout=
e
> > > > all accounting through a single MEMCG_DMABUF path.
> > > >
> > > > Usage examples:
> > > >
> > > >   1. Central allocator charging to a client at allocation time.
> > > >      The allocator knows the client's PID (e.g., from binder's
> > > >      sender_pid) and uses pidfd to attribute the charge:
> > > >
> > > >        pid_t client_pid =3D txn->sender_pid;
> > > >        int pidfd =3D pidfd_open(client_pid, 0);
> > > >
> > > >        struct dma_heap_allocation_data alloc =3D {
> > > >            .len             =3D buffer_size,
> > > >            .fd_flags        =3D O_RDWR | O_CLOEXEC,
> > > >            .charge_pid_fd   =3D pidfd,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        close(pidfd);
> > > >        /* alloc.fd is now charged to client's cgroup */
> > > >
> > > >   2. Default allocation (no pidfd, mem_accounting=3D1).
> > > >      When charge_pid_fd is not set and the mem_accounting module
> > > >      parameter is enabled, the buffer is charged to the allocator's
> > > >      own cgroup:
> > > >
> > > >        struct dma_heap_allocation_data alloc =3D {
> > > >            .len      =3D buffer_size,
> > > >            .fd_flags =3D O_RDWR | O_CLOEXEC,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        /* charged to current process's cgroup */
> > > >
> > > > Current limitations:
> > > >
> > > >  - Single-owner model: a dma-buf carries one memcg charge regardles=
s of
> > > >    how many processes share it. Means only the first owner (and exp=
orter)
> > > >    of the shared buffer bears the charge.
> > > >  - Only memcg accounting supported. While this makes sense for syst=
em
> > > >    heap buffers, other heaps (e.g., CMA heaps) will require selecti=
vely
> > > >    charging also for the dmem controller.
> > >
> > > Well that doesn't looks soo bad, it at least seems to tackle the prob=
lem at hand for Android and some of other embedded use cases.
> > >
> > > I'm just not sure if this is future prove and will work for all use c=
ases, e.g. cloud gaming, native context for automotive etc...
> > >
> > > Essentially the problem boils down to two limitations:
> > > 1) a piece of memory can only be charged to one cgroup, the framework=
 doesn't has a concept of charging shared memory to multiple groups
> > > 2) when memory references in the form of file descriptors are passed =
between applications we have no way of changing the accounting to a differe=
nt cgroup
> > >
> > > The passing of the memory reference already has a well defined uAPI a=
nd if we could solve those two limitations we not only solve the problem wi=
thout introducing new uAPI (with potential new security risks) but also sol=
ve it for all other use cases which uses file descriptors as well as. E.g. =
memfd, accel and GPU drivers etc...
> >
> > Honestly, adding a hook to fd-passing uAPI to manage charge transfers
> > sounds like a promising solution requiring no uAPI changes. However,
> > it still does not cover all paths, e.g., dup() or fork(). And shared
> > memory sounds like a hard one to tackle, where deciding the best
> > policy is more a per-usecase thing and would probably require
> > userspace configuration.
>
> I'm curious if anyone knows of a use case where FDs aren't involved at
> all? It's possible to fork() or clone() with only a dmabuf mapping and
> no FD. That sounds strange, and I'm not sure there's a real usecase
> for transferring ownership with that approach, but figured I'd at
> least pose the question.

Yeah, that's a good point. I do not really have a usecase myself for
fork(), just thought of it as a posible gap/uncovered path.

>
> > All in all, charge_pid_fd covers a
> > well-defined and immediately practical subset. The UAPI cost is small
> > and the mechanism is explicit about what it does and doesn't solve. A
> > general solution, if it ever converges, would likely supersede
> > charge_pid_fd for most cases, which is a fine outcome if it solves the
> > problem more completely.
> >
> > Either way, if you have a specific approach in mind for solving any of
> > the above limitations, I'd be happy to look into it further.
> >
> > BR,
> > Albert.
> >
> > >
> > > On the other hand it is really nice to finally see this tackled for a=
t least DMA-buf heaps. On the GPU side I have seen just another try of a dr=
iver doing some kind of special driver specific accounting to solve this ju=
st a few weeks ago. And to be honest such single driver island approach hav=
e the tendency to break more often that they are working correctly.
> > >
> > > Regards,
> > > Christian.
> > >
> > > >
> > > > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > > > ---
> > > >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> > > >  drivers/dma-buf/dma-buf.c               | 16 ++++---------
> > > >  drivers/dma-buf/dma-heap.c              | 42 +++++++++++++++++++++=
+++++++++---
> > > >  drivers/dma-buf/heaps/system_heap.c     |  2 --
> > > >  include/uapi/linux/dma-heap.h           |  6 +++++
> > > >  5 files changed, 53 insertions(+), 18 deletions(-)
> > > >
> > > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentatio=
n/admin-guide/cgroup-v2.rst
> > > > index 8bdbc2e866430..824d269531eb1 100644
> > > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > > @@ -1636,8 +1636,9 @@ The following nested keys are defined.
> > > >               structures.
> > > >
> > > >         dmabuf (npn)
> > > > -             Amount of memory used for exported DMA buffers alloca=
ted by the cgroup.
> > > > -             Stays with the allocating cgroup regardless of how th=
e buffer is shared.
> > > > +             Amount of memory used for exported DMA buffers alloca=
ted by or on
> > > > +             behalf of the cgroup. Stays with the allocating cgrou=
p regardless
> > > > +             of how the buffer is shared.
> > > >
> > > >         workingset_refault_anon
> > > >               Number of refaults of previously evicted anonymous pa=
ges.
> > > > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > > > index ce02377f48908..23fb758b78297 100644
> > > > --- a/drivers/dma-buf/dma-buf.c
> > > > +++ b/drivers/dma-buf/dma-buf.c
> > > > @@ -181,8 +181,11 @@ static void dma_buf_release(struct dentry *den=
try)
> > > >        */
> > > >       BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
> > > >
> > > > -     mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->=
size) / PAGE_SIZE);
> > > > -     mem_cgroup_put(dmabuf->memcg);
> > > > +     if (dmabuf->memcg) {
> > > > +             mem_cgroup_uncharge_dmabuf(dmabuf->memcg,
> > > > +                                       PAGE_ALIGN(dmabuf->size) / =
PAGE_SIZE);
> > > > +             mem_cgroup_put(dmabuf->memcg);
> > > > +     }
> > > >
> > > >       dmabuf->ops->release(dmabuf);
> > > >
> > > > @@ -764,13 +767,6 @@ struct dma_buf *dma_buf_export(const struct dm=
a_buf_export_info *exp_info)
> > > >               dmabuf->resv =3D resv;
> > > >       }
> > > >
> > > > -     dmabuf->memcg =3D get_mem_cgroup_from_mm(current->mm);
> > > > -     if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabu=
f->size) / PAGE_SIZE,
> > > > -                                   GFP_KERNEL)) {
> > > > -             ret =3D -ENOMEM;
> > > > -             goto err_memcg;
> > > > -     }
> > > > -
> > > >       file->private_data =3D dmabuf;
> > > >       file->f_path.dentry->d_fsdata =3D dmabuf;
> > > >       dmabuf->file =3D file;
> > > > @@ -781,8 +777,6 @@ struct dma_buf *dma_buf_export(const struct dma=
_buf_export_info *exp_info)
> > > >
> > > >       return dmabuf;
> > > >
> > > > -err_memcg:
> > > > -     mem_cgroup_put(dmabuf->memcg);
> > > >  err_file:
> > > >       fput(file);
> > > >  err_module:
> > > > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.=
c
> > > > index ac5f8685a6494..ff6e259afcdc0 100644
> > > > --- a/drivers/dma-buf/dma-heap.c
> > > > +++ b/drivers/dma-buf/dma-heap.c
> > > > @@ -7,13 +7,17 @@
> > > >   */
> > > >
> > > >  #include <linux/cdev.h>
> > > > +#include <linux/cgroup.h>
> > > >  #include <linux/device.h>
> > > >  #include <linux/dma-buf.h>
> > > >  #include <linux/dma-heap.h>
> > > > +#include <linux/memcontrol.h>
> > > > +#include <linux/sched/mm.h>
> > > >  #include <linux/err.h>
> > > >  #include <linux/export.h>
> > > >  #include <linux/list.h>
> > > >  #include <linux/nospec.h>
> > > > +#include <linux/pidfd.h>
> > > >  #include <linux/syscalls.h>
> > > >  #include <linux/uaccess.h>
> > > >  #include <linux/xarray.h>
> > > > @@ -55,10 +59,12 @@ MODULE_PARM_DESC(mem_accounting,
> > > >                "Enable cgroup-based memory accounting for dma-buf h=
eap allocations (default=3Dfalse).");
> > > >
> > > >  static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len=
,
> > > > -                              u32 fd_flags,
> > > > -                              u64 heap_flags)
> > > > +                              u32 fd_flags, u64 heap_flags,
> > > > +                              struct mem_cgroup *charge_to)
> > > >  {
> > > >       struct dma_buf *dmabuf;
> > > > +     unsigned int nr_pages;
> > > > +     struct mem_cgroup *memcg =3D charge_to;
> > > >       int fd;
> > > >
> > > >       /*
> > > > @@ -73,6 +79,22 @@ static int dma_heap_buffer_alloc(struct dma_heap=
 *heap, size_t len,
> > > >       if (IS_ERR(dmabuf))
> > > >               return PTR_ERR(dmabuf);
> > > >
> > > > +     nr_pages =3D len / PAGE_SIZE;
> > > > +
> > > > +     if (memcg)
> > > > +             css_get(&memcg->css);
> > > > +     else if (mem_accounting)
> > > > +             memcg =3D get_mem_cgroup_from_mm(current->mm);
> > > > +
> > > > +     if (memcg) {
> > > > +             if (!mem_cgroup_charge_dmabuf(memcg, nr_pages, GFP_KE=
RNEL)) {
> > > > +                     mem_cgroup_put(memcg);
> > > > +                     dma_buf_put(dmabuf);
> > > > +                     return -ENOMEM;
> > > > +             }
> > > > +             dmabuf->memcg =3D memcg;
> > > > +     }
> > > > +
> > > >       fd =3D dma_buf_fd(dmabuf, fd_flags);
> > > >       if (fd < 0) {
> > > >               dma_buf_put(dmabuf);
> > > > @@ -102,6 +124,9 @@ static long dma_heap_ioctl_allocate(struct file=
 *file, void *data)
> > > >  {
> > > >       struct dma_heap_allocation_data *heap_allocation =3D data;
> > > >       struct dma_heap *heap =3D file->private_data;
> > > > +     struct mem_cgroup *memcg =3D NULL;
> > > > +     struct task_struct *task;
> > > > +     unsigned int pidfd_flags;
> > > >       int fd;
> > > >
> > > >       if (heap_allocation->fd)
> > > > @@ -113,9 +138,20 @@ static long dma_heap_ioctl_allocate(struct fil=
e *file, void *data)
> > > >       if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
> > > >               return -EINVAL;
> > > >
> > > > +     if (heap_allocation->charge_pid_fd) {
> > > > +             task =3D pidfd_get_task(heap_allocation->charge_pid_f=
d, &pidfd_flags);
> > > > +             if (IS_ERR(task))
> > > > +                     return PTR_ERR(task);
> > > > +
> > > > +             memcg =3D get_mem_cgroup_from_mm(task->mm);
> > > > +             put_task_struct(task);
> > > > +     }
> > > > +
> > > >       fd =3D dma_heap_buffer_alloc(heap, heap_allocation->len,
> > > >                                  heap_allocation->fd_flags,
> > > > -                                heap_allocation->heap_flags);
> > > > +                                heap_allocation->heap_flags,
> > > > +                                memcg);
> > > > +     mem_cgroup_put(memcg);
> > > >       if (fd < 0)
> > > >               return fd;
> > > >
> > > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/=
heaps/system_heap.c
> > > > index 03c2b87cb1112..95d7688167b93 100644
> > > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > > @@ -385,8 +385,6 @@ static struct page *alloc_largest_available(uns=
igned long size,
> > > >               if (max_order < orders[i])
> > > >                       continue;
> > > >               flags =3D order_flags[i];
> > > > -             if (mem_accounting)
> > > > -                     flags |=3D __GFP_ACCOUNT;
> > > >               page =3D alloc_pages(flags, orders[i]);
> > > >               if (!page)
> > > >                       continue;
> > > > diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma=
-heap.h
> > > > index a4cf716a49fa6..e02b0f8cbc6a1 100644
> > > > --- a/include/uapi/linux/dma-heap.h
> > > > +++ b/include/uapi/linux/dma-heap.h
> > > > @@ -29,6 +29,10 @@
> > > >   *                   handle to the allocated dma-buf
> > > >   * @fd_flags:                file descriptor flags used when alloc=
ating
> > > >   * @heap_flags:              flags passed to heap
> > > > + * @charge_pid_fd:   optional pidfd of the process whose cgroup sh=
ould be
> > > > + *                   charged for this allocation; 0 means charge t=
he calling
> > > > + *                   process's cgroup
> > > > + * @__padding:               reserved, must be zero
> > > >   *
> > > >   * Provided by userspace as an argument to the ioctl
> > > >   */
> > > > @@ -37,6 +41,8 @@ struct dma_heap_allocation_data {
> > > >       __u32 fd;
> > > >       __u32 fd_flags;
> > > >       __u64 heap_flags;
> > > > +     __u32 charge_pid_fd;
> > > > +     __u32 __padding;
> > > >  };
> > > >
> > > >  #define DMA_HEAP_IOC_MAGIC           'H'
> > > >
> > >
> >
>


