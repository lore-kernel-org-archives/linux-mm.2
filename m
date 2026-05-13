Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C7ACD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D374C6B0005; Wed, 13 May 2026 07:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E8C6B008A; Wed, 13 May 2026 07:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24466B0092; Wed, 13 May 2026 07:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE6156B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:39:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 408001608D3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:39:26 +0000 (UTC)
X-FDA: 84762201132.11.64FB59F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDA5AA0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:39:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QYDdNVK4;
	spf=pass (imf25.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS/2FuqLU5pwunCNcA3n2Q2AppnYr82PFc8PIbH39/U=;
	b=8K132aJ2Coku5BWz/+W2DsIpzYsps0Ujb7NFIF7TTHuFiQRvaZt5SgWenOMZzfFtbo7AOT
	tR/0ebgRIV03J9Bz/AGZD/myLGfMnVPUvEhmOPP0DuJ9ZSBmTOIBG51oxE17S8KlCo3538
	h/Ui8O2LDCAGc04EDDBqzopXbxZ2Vmg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QYDdNVK4;
	spf=pass (imf25.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672364; a=rsa-sha256;
	cv=none;
	b=Wi2Dl4lDdHCK8jETEox0r8SRJS5aZnnkl/eOvCXuMJw6L1JcPSOQ/f0vxScPkw6AfVd0ro
	4d4Mx2lWhkSLaoeX9auUn/GtJD73zrSmTK1L4XmS2vb3iNVoaRlytEFqIOX+z7tw709mVs
	KIgcVsmVRvvrEy2z1kEQ/CemR4XDvCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778672363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hS/2FuqLU5pwunCNcA3n2Q2AppnYr82PFc8PIbH39/U=;
	b=QYDdNVK45+cTMBxo7gKEMf2E6l7ovu6Sky8fiOCDDvp5M4R93+ftYzFNeby5O7Tz3QapEY
	8qnGA3ktxX47MqLvVazvSFc8TEDkaGPnUhS1pfMTxaxHBCB2gLlQYqG3dQL2HQLy6G9/R+
	fPAkJqDt2y2Wo21EgI2EcXoZd9hm4q8=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641--I1yntL5O5i_e7I6xsxZXQ-1; Wed, 13 May 2026 07:39:20 -0400
X-MC-Unique: -I1yntL5O5i_e7I6xsxZXQ-1
X-Mimecast-MFC-AGG-ID: -I1yntL5O5i_e7I6xsxZXQ_1778672360
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7bd5c421975so80842347b3.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 04:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778672360; x=1779277160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hS/2FuqLU5pwunCNcA3n2Q2AppnYr82PFc8PIbH39/U=;
        b=iU1mbwxlqQDY7l683ysj5hRmPdor09ZWoNwXzQ5AQ8F5Omes5WPUpzWfOJTjQzJpDe
         BObNmADaPL30JB9USTqczSuAp7U28CyJpPJl2M//WI7F54HDC4uBbi+eG6XM1sRuTwyd
         ugSqBlvCGSutTH4PA7LYmV6QwLWr0yFj/OT6pCnOtEPgubSoR/RIgAz1bHUyXYVgj+x0
         y7UGuY1Ji5iYZkaf/fyePpUkH5WOnsPnKAaWw1aE2lFOZSq3fx+zzASdzV+GPy57fsAT
         Yjmh0tBX7+O1ungiWwnBSSl8uiljrQ/+nxTy5lAd9plvJJR9MOAppxxcf5lOOi/UsRYy
         gCmA==
X-Forwarded-Encrypted: i=1; AFNElJ/c7LEbfgTEQwB8t5TmONTnwM9+G+BLx36S/OG2xeSOPcW1/GG7I0wJnl1xKoXo0SboxKMUNKQLcQ==@kvack.org
X-Gm-Message-State: AOJu0YzXg/CFHVieRRV90EYb5nghINWBDf3PxCU/1iChOGJDAgp3jcOM
	oNlCYpUUSU9QkBUufHZgNdPVZzJCGcv62oUQwW9YJcTMNfGZUs0XgaYsSGmCf5a6et7ZFrDT/MR
	UsBwqzMwCNlEZ0ry7mfbmQERYVDsFakLePkaBk7wQUytF6SyhyQkmKmafaWvHbgGrN+FCyMmHxK
	OXhcPsCtptmNFjwFsMNDF/dG7nyq4=
X-Gm-Gg: Acq92OEgzHD9jd8yu32yZHXdKFU3l7z2hlDWlgNYPfZoNK+zZG3lEp7W5HIKZKokemm
	xsAGb2/4gST7/ouFNesTuHjD4lsvRCmsKnv1Uv8HYDiWBY0JhQ+0DMn4d3W0zRooYWQ+zx8JmiG
	k9EJdFj079dG1pTcTPYJPWvSXPvvVzT+WZMzhZ3SOaMSbX6oD4sKQfkhdy3N4C005g96Y+bZajy
	lFTrA==
X-Received: by 2002:a05:690c:ec9:b0:79b:73dc:d30b with SMTP id 00721157ae682-7c6ab5e7f27mr28940007b3.8.1778672359870;
        Wed, 13 May 2026 04:39:19 -0700 (PDT)
X-Received: by 2002:a05:690c:ec9:b0:79b:73dc:d30b with SMTP id
 00721157ae682-7c6ab5e7f27mr28939637b3.8.1778672359313; Wed, 13 May 2026
 04:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
In-Reply-To: <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 13 May 2026 13:39:07 +0200
X-Gm-Features: AVHnY4I5m32D5Cdj2nVcdFoZWX746xqo3L8u6WpqbwAq2rXYLtU6Dq-6Gs38REw
Message-ID: <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: cnIaIN-9LyJkDCr3_D95lrnsmRmAk8_-ypsJ4GnvxbA_1778672360
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qamjrp19mofhmfy8xmwh3bf7kqifga48
X-Rspamd-Queue-Id: CDA5AA0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778672363-144576
X-HE-Meta: U2FsdGVkX19MN86DN5ZroDTXFW0Ld1/zGsI6oM0Dn24OwioEUYW8+5wvZKAz1cqHGYupCtMechVLZbXtjGfKkfJSYlMr1L07Uhj3/gd5oO5MJ0mmzDWlq8VYQLMfbYc1HDvO7Jn9Oqrllsx8RA2rnb2GGd1fllfmKxJd52TYY4ayg3pPUfZWKfuCcRpdof/ZRReeTTeUXXXDNLLgC/6PrT8EJirb5Z2awMRc42npED7wz81BQuRvZmq3U0W3X8wfNbrDtxgGGDQn8sohu/WkMEAvnTk4ng/gh+n+r9P5SikQt4wpJ540t3FriPuWiYrY4JimN5eLSaI32F6nXSgYQbKHz7dorQg3VUGPQCfv067ZCQKpzIdXYEV4Lx95cv0dlzibQr3x/yEKYyC7JoQp3R4mKTmjJbpZNCLYCQPM/IFUwhBS3Wj/qiZGFEKCfNsBuA31yJb0HD+KaExx7DOIcXMkAIPMt+LLgLBvdYo6h8Fk2+2diRdLGEuSyWQgBEauS5xo5g688VknX253DzIahfv4z5TbuTTnk7P2Jfjbr2c+/dpNrHzXEdRWNbD7cDNziZUbDq69gqATpSX6CeY65AJiFyWccLS9rtgrKI1j4v+whuRF3DuHdWLtnPkdEVeOzEEvHCgGuu2VCAp2jXiyy1kVXMBPTr1wwBWG5G4wouPegDaOQyIIhnL1afGLRkA/8/Lgq413leNeNnMlPd2D6xw+1l/YRhkgJ6v+tuSQaWQH36UsmDx+ZaEWGQ3z1DK16bV0w0rBIl2cIsje6OKOqOCF8iFlNw08x3P6HuB5Uo0CF684Sytb0riec7wnptsEdmEvZ0CGxiAKb+yWY5cCvka6+XKlot6AihipfhKm902ags4qlRMRk90cxJ9Nij9nltMp8jsJLw2piXQGil3H5yUJ9+6JeWr51T/ppQ7JTj0FRKHUOxuwBwJEqDwYlIc79PTeF/mk0S6czEu3PTv
 3WLLLPGo
 y1LPua0FnRyQKTYQPXOvQm9SHw/ALKDwrb1p0RSats0ZyhVnVZh2XFyKU6IDAuG6+RggQBUfVT5A/J/4qynSxVaNqQ8S1u3Mu4aaMdduUPaLSnBBNkbpxPM2cQdGYPFyJ4zRzoQr5ayst+DNHzM1ygypFNkF3Z9IVoSDdMS1/8lhv4h3KTRUPMvaRwAjQrgNmz9Sk9jNQvHyvXtBRXi28bdnNfzFEpjd6iCQev0wZeWsvtRg1q7Et1TMBuv9KAJXI/amlOofq53nZjoB6XRtZD4SkgQbYvSFPyTo9tUg9Gir9QEWckXm4n3NR+yJkPPkxMi8WRorXobRytidB/G8nEicuO5RH0a6FSabCVn6nmUTm/hAuUIWew7/OBAjMpkaRbIMwg/8OPQlqUPTyKyub9B+jnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 8:53=E2=80=AFPM T.J. Mercier <tjmercier@google.com>=
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
> > I'm just not sure if this is future prove and will work for all use cas=
es, e.g. cloud gaming, native context for automotive etc...
> >
> > Essentially the problem boils down to two limitations:
> > 1) a piece of memory can only be charged to one cgroup, the framework d=
oesn't has a concept of charging shared memory to multiple groups
>
> Yup, memcg already has this problem with pagecache and shmem.
>
> > 2) when memory references in the form of file descriptors are passed be=
tween applications we have no way of changing the accounting to a different=
 cgroup
> >
> > The passing of the memory reference already has a well defined uAPI and=
 if we could solve those two limitations we not only solve the problem with=
out introducing new uAPI (with potential new security risks) but also solve=
 it for all other use cases which uses file descriptors as well as. E.g. me=
mfd, accel and GPU drivers etc...
> >
> > On the other hand it is really nice to finally see this tackled for at =
least DMA-buf heaps.
>
> I have a question about this part. Albert I guess you are interested
> only in accounting dmabuf-heap allocations, or do you expect to add
> __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
> non-dmabuf-heap exporters?

We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
controller are on the radar for follow-up/parallel work (there will be
dragons and will surely need discussion). For DRM and V4L2 the
long-term intent is migration to heaps, which would make direct
accounting on those paths unnecessary. udmabufs are already
memcg-charged, so adding a separate MEMCG_DMABUF would double count.
Are there any other exporters you had in mind that would benefit from
this approach?

BR,
Albert.

>
> > On the GPU side I have seen just another try of a driver doing some kin=
d of special driver specific accounting to solve this just a few weeks ago.=
 And to be honest such single driver island approach have the tendency to b=
reak more often that they are working correctly.
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


