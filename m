Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAD6CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAA1E6B0005; Wed, 13 May 2026 08:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59976B008A; Wed, 13 May 2026 08:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B223B6B008C; Wed, 13 May 2026 08:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F54D6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:41:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E94B1A0BCB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:41:51 +0000 (UTC)
X-FDA: 84762358422.24.F28E053
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCA5140010
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:41:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=glLcNvJA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778676109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOEhaYXxHcDCT/VWabJKKAhll1HKQfDPQhsQeGsErgM=;
	b=W2dfaDLPWSoImG3hKlQDGtHkF3gK+0ZU5aBxrzBqIUKFYY00XsVvub+YoU4s8Xhf2/59jw
	U6Hl5sZP+nWvYp3J/YMqVXAwbSFoOyVLciwydm0zpdcAWVY116tzvJ2y4OogYibVZdCnBr
	uyLZJHgRq8ohlnm4biQhaRJ+KIG4ITY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778676109; a=rsa-sha256;
	cv=none;
	b=Cohm316M3iRS+Nif0HDxpdVF2Cp944WjUIV0y/kyHZRKeAQ2GeW7wDx+Sxxxc7+cuRWqUQ
	p+5seMnq6EwIq510nD/tLSh0myRvgaZY02G2+h0z+iguUmzji3ePAeUIQWmd4R3xm2Uh3q
	6LplV2IKJbgbYvGZQbpedzcUHkW8ne0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=glLcNvJA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778676108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zOEhaYXxHcDCT/VWabJKKAhll1HKQfDPQhsQeGsErgM=;
	b=glLcNvJAbuHXqjFH+IUwikIaFk6ryv03dLyEoBu+0uZzJsVl5RhfTvQyJGhrrlfKdY71E0
	RHKHlfKzZHRXAvI+C66XebmYW9eJRYPDDBKTdlc7uGvPtj7xondSBhT/LMs721Uk7EMJ3q
	KcwUzIh3G9O9gObhLHUHmhFU6nUpwjs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-FEBlPnlWO1-swPqW8DdHng-1; Wed, 13 May 2026 08:41:47 -0400
X-MC-Unique: FEBlPnlWO1-swPqW8DdHng-1
X-Mimecast-MFC-AGG-ID: FEBlPnlWO1-swPqW8DdHng_1778676106
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bd795b6288so134717787b3.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778676106; x=1779280906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zOEhaYXxHcDCT/VWabJKKAhll1HKQfDPQhsQeGsErgM=;
        b=Rj40KqA1M7SWOa5YHY5IgLQBsCovpb0pw3IUeAXRHcGMRM14X/taOmnN8pF1VuVSa4
         xD0AyFkG/cknyxCOjRJrKVKD//LUrRLHJUrQnKy+6hRI9v1RQDjVtc3gZUR32xeXwJcx
         /AOU0vEHI/YZs32iqrVU6w5SjVZUtEtGD43Inyg5Di8ayypeW+fVtLBwpDhTVkQ2Phv5
         ZJq+zCS7xcV98y6cO/f6UFEC1XbXdidCpKFf8JM/QyKlU3uVkM4xXYSqlvJP+roULwzX
         ownFPIlwcPhXhW6lo6kMkq29JhuvKvK+7vm68rS8RfcTZRYTmfAqH2cb2IIeP9o71Z5r
         ZyqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9uWXw1th5UN7frL/MojU2E+Ix5Bbv8hTUsTJbT4T4drTiwsqxB1+L2ULi7SYZ0psPUWlOBhDS4pw==@kvack.org
X-Gm-Message-State: AOJu0YxZpqIxCgh4pvFDdegGSy7C7QmylWBJJbrpHwgvwMu9I8/3h2Rc
	kQnmmUDC2//eF/fyvzJxuHw6cJ4Wtrg4zZDkj3zjf2z/wj5RxAIIWkoO8GZog91EFxBjrgTAiFx
	EuD+jSHR+c/LBAyEUePIPxJ9Oa47ndfwKQBcbc0A/TdnA4SHF9A/n8erSPhZzru1543pVYxaWJK
	+XfxkqIIrXruFjTyd+PbPheJ1wkSk=
X-Gm-Gg: Acq92OHDe4zP8xOGq1PTOClgLOjER4mUS94kWYW2npPP2use5Kp8iLorRi/X0bdquFG
	pIrABXYHtIFlbx+2l39sBP4HMUvmecOH0yjBVKHePRzPHIyxTIh75/Ua8nWo0t1uNcbMR221JSD
	1Dhz92eBKHnJV9BY7rY/O/uHCRPAy90RZWjJN+hBdJEVe0+dqaQzepHB6R9MsZhyIV5HoFjhOYC
	9vs1w==
X-Received: by 2002:a05:690c:348a:b0:7bf:ff7:ea71 with SMTP id 00721157ae682-7c69ae49726mr25053417b3.17.1778676106268;
        Wed, 13 May 2026 05:41:46 -0700 (PDT)
X-Received: by 2002:a05:690c:348a:b0:7bf:ff7:ea71 with SMTP id
 00721157ae682-7c69ae49726mr25053037b3.17.1778676105682; Wed, 13 May 2026
 05:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com> <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
In-Reply-To: <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 13 May 2026 14:41:33 +0200
X-Gm-Features: AVHnY4I5gWDDEj4SX_HuB44fjlMWKZYdMLtmbKqRDSeay77iEzEWghV7sNPOxmY
Message-ID: <CADSE00KZMJFYJ92XZa=r9EeJJRGT=SNChwOW-_jTznc7F79xGw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8yS80orSHDIV8opz4h9moOCpAhTO5qjAKjo2F-Xw4gg_1778676106
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCA5140010
X-Stat-Signature: cfmxqpbz6p3ikm8raoddopynbu7dmdd4
X-Rspam-User: 
X-HE-Tag: 1778676108-407367
X-HE-Meta: U2FsdGVkX18r377uDCjgo2DLnryiAB+6a+JphcZrxgNfhh3hyPzn0JXAjDbUPYVhjnbChG2Fw7Dy5j2aIcFmiy7IoY+5Vg9gk9XhVnsUX8Exy24ljAjJ/wGR2nxEptFe8efk650r62Pn0qj7ByeDBGF8TxP3oStSG+DdZN8+VjA2ellugGeht+vXR4RA4U9vNobatdKfkYuNdnt3oAeQZxL1byLSl52PjLh82gE62ClHSjx/JhunnF1FRmyRvcCfN1BuJ0U6WHtGQL/UmTpgfC/uvKj/fB88bfi3LtCoaEzWIjInFXfD7dmAS9k6p5Pi/aJrA5d/CMwGWO19C6zC5Iwz0ooCDQ+k05Xud+PuF0g4PT9I54CKP6kbui8MBbsBj2FLNZckWFUn4WXpA2rps1mH/fOeDPGlN4gYI1iTyJXZebxNB1TQBG2oQ8YrWDieCYqmGUkfpcJxw09Kv9dqicj7A6oujYEwekemWrbFiACi3QCHFuYCSltaY8mPZilS28XIGnP2/ADsF9SuSaHvD62lNkyxirNaXrxcfPmYkbl7ijj/8ptcOnNfS0AjF+qH3VZ3qRTse7WOJFcu42S/pFYcTRPrey1PQIx4qOeo7uhZHN1FPtWqhYOELcrHwJGCUO/bbSLgFUNHYl02quIBllivTv0E1KDt5PCFmDpxyjWeH0rqdiwStAh97L1ehiWTxzIOhbz0nnuWDVyFi0Op+JLjB2/NZ1zC7mb9u3IB9HIzYqXxfT9cItiGyCZwaHY8dxOM9bhr1QsX+Pjv7Jg740CUmhuw/CqPNGgxhDPxTCwYx6gMct6HHWM5+87Z4NIbrufbEbPt1Xz2cEExhdnzpjs2cnWtF+ih2Fo5Mq1r1oZiGnbAk+A2rtU9hAVYjG2rmxKOzwvVHguTCm1x3tye7CqWfYmzxX/JWBEsolUZN8xKcWeBzW2dv7DZfNvHBYayofD7NHaN9G38J/RTpa2
 8sSRrm/a
 SpFaKelcarvL6Xk5wDB6q4jMal+VWdRwDxzSDROH4ZA6IpLkrW7/dRS/B0iAkrOHE4ZWmcjUbSIM9j057/j2t+kefz1rGhfk2Xnz47SzPikxxESOOT+1LlycicHblm1/v/Nn9S49omsZa1gqhuD1vladWt0wGoGDgDpp0qol7bFxYL0HPL5cqg/2rupOfQIolcmoSO93Q/ZsmD0hkZdRnB9mfgP5m5oZYjP+c2no4gNBz8k5Vm9TeXY5lMrCCJp7KKp5hjlEDZ7qx8mu523FJFc5Ap8F/OVOpUNIz4ZQ0leo5l1cD3F0j1gy+LC7dtcNVvj1NasZaOj7IpksxQTii8QFxc7I8RtUVLm4lu+vtwJFiazrFCMbsK3teNKSyVE0f+Zh0Zb47cSFPmzxBt10DNiw/zg+jqsWEidIIncnOURk1eJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 12:14=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/12/26 11:10, Albert Esteve wrote:
> > On embedded platforms a central process often allocates dma-buf
> > memory on behalf of client applications. Without a way to
> > attribute the charge to the requesting client's cgroup, the
> > cost lands on the allocator, making per-cgroup memory limits
> > ineffective for the actual consumers.
> >
> > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > the mem_accounting module parameter enabled, the buffer is charged
> > to the allocator's own cgroup.
> >
> > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account for
> > system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> > page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and route
> > all accounting through a single MEMCG_DMABUF path.
> >
> > Usage examples:
> >
> >   1. Central allocator charging to a client at allocation time.
> >      The allocator knows the client's PID (e.g., from binder's
> >      sender_pid) and uses pidfd to attribute the charge:
> >
> >        pid_t client_pid =3D txn->sender_pid;
> >        int pidfd =3D pidfd_open(client_pid, 0);
> >
> >        struct dma_heap_allocation_data alloc =3D {
> >            .len             =3D buffer_size,
> >            .fd_flags        =3D O_RDWR | O_CLOEXEC,
> >            .charge_pid_fd   =3D pidfd,
> >        };
> >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> >        close(pidfd);
> >        /* alloc.fd is now charged to client's cgroup */
> >
> >   2. Default allocation (no pidfd, mem_accounting=3D1).
> >      When charge_pid_fd is not set and the mem_accounting module
> >      parameter is enabled, the buffer is charged to the allocator's
> >      own cgroup:
> >
> >        struct dma_heap_allocation_data alloc =3D {
> >            .len      =3D buffer_size,
> >            .fd_flags =3D O_RDWR | O_CLOEXEC,
> >        };
> >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> >        /* charged to current process's cgroup */
> >
> > Current limitations:
> >
> >  - Single-owner model: a dma-buf carries one memcg charge regardless of
> >    how many processes share it. Means only the first owner (and exporte=
r)
> >    of the shared buffer bears the charge.
> >  - Only memcg accounting supported. While this makes sense for system
> >    heap buffers, other heaps (e.g., CMA heaps) will require selectively
> >    charging also for the dmem controller.
>
> Well that doesn't looks soo bad, it at least seems to tackle the problem =
at hand for Android and some of other embedded use cases.
>
> I'm just not sure if this is future prove and will work for all use cases=
, e.g. cloud gaming, native context for automotive etc...
>
> Essentially the problem boils down to two limitations:
> 1) a piece of memory can only be charged to one cgroup, the framework doe=
sn't has a concept of charging shared memory to multiple groups
> 2) when memory references in the form of file descriptors are passed betw=
een applications we have no way of changing the accounting to a different c=
group
>
> The passing of the memory reference already has a well defined uAPI and i=
f we could solve those two limitations we not only solve the problem withou=
t introducing new uAPI (with potential new security risks) but also solve i=
t for all other use cases which uses file descriptors as well as. E.g. memf=
d, accel and GPU drivers etc...

Honestly, adding a hook to fd-passing uAPI to manage charge transfers
sounds like a promising solution requiring no uAPI changes. However,
it still does not cover all paths, e.g., dup() or fork(). And shared
memory sounds like a hard one to tackle, where deciding the best
policy is more a per-usecase thing and would probably require
userspace configuration. All in all, charge_pid_fd covers a
well-defined and immediately practical subset. The UAPI cost is small
and the mechanism is explicit about what it does and doesn't solve. A
general solution, if it ever converges, would likely supersede
charge_pid_fd for most cases, which is a fine outcome if it solves the
problem more completely.

Either way, if you have a specific approach in mind for solving any of
the above limitations, I'd be happy to look into it further.

BR,
Albert.

>
> On the other hand it is really nice to finally see this tackled for at le=
ast DMA-buf heaps. On the GPU side I have seen just another try of a driver=
 doing some kind of special driver specific accounting to solve this just a=
 few weeks ago. And to be honest such single driver island approach have th=
e tendency to break more often that they are working correctly.
>
> Regards,
> Christian.
>
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> >  drivers/dma-buf/dma-buf.c               | 16 ++++---------
> >  drivers/dma-buf/dma-heap.c              | 42 +++++++++++++++++++++++++=
+++++---
> >  drivers/dma-buf/heaps/system_heap.c     |  2 --
> >  include/uapi/linux/dma-heap.h           |  6 +++++
> >  5 files changed, 53 insertions(+), 18 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 8bdbc2e866430..824d269531eb1 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1636,8 +1636,9 @@ The following nested keys are defined.
> >               structures.
> >
> >         dmabuf (npn)
> > -             Amount of memory used for exported DMA buffers allocated =
by the cgroup.
> > -             Stays with the allocating cgroup regardless of how the bu=
ffer is shared.
> > +             Amount of memory used for exported DMA buffers allocated =
by or on
> > +             behalf of the cgroup. Stays with the allocating cgroup re=
gardless
> > +             of how the buffer is shared.
> >
> >         workingset_refault_anon
> >               Number of refaults of previously evicted anonymous pages.
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index ce02377f48908..23fb758b78297 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -181,8 +181,11 @@ static void dma_buf_release(struct dentry *dentry)
> >        */
> >       BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
> >
> > -     mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size=
) / PAGE_SIZE);
> > -     mem_cgroup_put(dmabuf->memcg);
> > +     if (dmabuf->memcg) {
> > +             mem_cgroup_uncharge_dmabuf(dmabuf->memcg,
> > +                                       PAGE_ALIGN(dmabuf->size) / PAGE=
_SIZE);
> > +             mem_cgroup_put(dmabuf->memcg);
> > +     }
> >
> >       dmabuf->ops->release(dmabuf);
> >
> > @@ -764,13 +767,6 @@ struct dma_buf *dma_buf_export(const struct dma_bu=
f_export_info *exp_info)
> >               dmabuf->resv =3D resv;
> >       }
> >
> > -     dmabuf->memcg =3D get_mem_cgroup_from_mm(current->mm);
> > -     if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->s=
ize) / PAGE_SIZE,
> > -                                   GFP_KERNEL)) {
> > -             ret =3D -ENOMEM;
> > -             goto err_memcg;
> > -     }
> > -
> >       file->private_data =3D dmabuf;
> >       file->f_path.dentry->d_fsdata =3D dmabuf;
> >       dmabuf->file =3D file;
> > @@ -781,8 +777,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf=
_export_info *exp_info)
> >
> >       return dmabuf;
> >
> > -err_memcg:
> > -     mem_cgroup_put(dmabuf->memcg);
> >  err_file:
> >       fput(file);
> >  err_module:
> > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> > index ac5f8685a6494..ff6e259afcdc0 100644
> > --- a/drivers/dma-buf/dma-heap.c
> > +++ b/drivers/dma-buf/dma-heap.c
> > @@ -7,13 +7,17 @@
> >   */
> >
> >  #include <linux/cdev.h>
> > +#include <linux/cgroup.h>
> >  #include <linux/device.h>
> >  #include <linux/dma-buf.h>
> >  #include <linux/dma-heap.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/err.h>
> >  #include <linux/export.h>
> >  #include <linux/list.h>
> >  #include <linux/nospec.h>
> > +#include <linux/pidfd.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/xarray.h>
> > @@ -55,10 +59,12 @@ MODULE_PARM_DESC(mem_accounting,
> >                "Enable cgroup-based memory accounting for dma-buf heap =
allocations (default=3Dfalse).");
> >
> >  static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
> > -                              u32 fd_flags,
> > -                              u64 heap_flags)
> > +                              u32 fd_flags, u64 heap_flags,
> > +                              struct mem_cgroup *charge_to)
> >  {
> >       struct dma_buf *dmabuf;
> > +     unsigned int nr_pages;
> > +     struct mem_cgroup *memcg =3D charge_to;
> >       int fd;
> >
> >       /*
> > @@ -73,6 +79,22 @@ static int dma_heap_buffer_alloc(struct dma_heap *he=
ap, size_t len,
> >       if (IS_ERR(dmabuf))
> >               return PTR_ERR(dmabuf);
> >
> > +     nr_pages =3D len / PAGE_SIZE;
> > +
> > +     if (memcg)
> > +             css_get(&memcg->css);
> > +     else if (mem_accounting)
> > +             memcg =3D get_mem_cgroup_from_mm(current->mm);
> > +
> > +     if (memcg) {
> > +             if (!mem_cgroup_charge_dmabuf(memcg, nr_pages, GFP_KERNEL=
)) {
> > +                     mem_cgroup_put(memcg);
> > +                     dma_buf_put(dmabuf);
> > +                     return -ENOMEM;
> > +             }
> > +             dmabuf->memcg =3D memcg;
> > +     }
> > +
> >       fd =3D dma_buf_fd(dmabuf, fd_flags);
> >       if (fd < 0) {
> >               dma_buf_put(dmabuf);
> > @@ -102,6 +124,9 @@ static long dma_heap_ioctl_allocate(struct file *fi=
le, void *data)
> >  {
> >       struct dma_heap_allocation_data *heap_allocation =3D data;
> >       struct dma_heap *heap =3D file->private_data;
> > +     struct mem_cgroup *memcg =3D NULL;
> > +     struct task_struct *task;
> > +     unsigned int pidfd_flags;
> >       int fd;
> >
> >       if (heap_allocation->fd)
> > @@ -113,9 +138,20 @@ static long dma_heap_ioctl_allocate(struct file *f=
ile, void *data)
> >       if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
> >               return -EINVAL;
> >
> > +     if (heap_allocation->charge_pid_fd) {
> > +             task =3D pidfd_get_task(heap_allocation->charge_pid_fd, &=
pidfd_flags);
> > +             if (IS_ERR(task))
> > +                     return PTR_ERR(task);
> > +
> > +             memcg =3D get_mem_cgroup_from_mm(task->mm);
> > +             put_task_struct(task);
> > +     }
> > +
> >       fd =3D dma_heap_buffer_alloc(heap, heap_allocation->len,
> >                                  heap_allocation->fd_flags,
> > -                                heap_allocation->heap_flags);
> > +                                heap_allocation->heap_flags,
> > +                                memcg);
> > +     mem_cgroup_put(memcg);
> >       if (fd < 0)
> >               return fd;
> >
> > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heap=
s/system_heap.c
> > index 03c2b87cb1112..95d7688167b93 100644
> > --- a/drivers/dma-buf/heaps/system_heap.c
> > +++ b/drivers/dma-buf/heaps/system_heap.c
> > @@ -385,8 +385,6 @@ static struct page *alloc_largest_available(unsigne=
d long size,
> >               if (max_order < orders[i])
> >                       continue;
> >               flags =3D order_flags[i];
> > -             if (mem_accounting)
> > -                     flags |=3D __GFP_ACCOUNT;
> >               page =3D alloc_pages(flags, orders[i]);
> >               if (!page)
> >                       continue;
> > diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-hea=
p.h
> > index a4cf716a49fa6..e02b0f8cbc6a1 100644
> > --- a/include/uapi/linux/dma-heap.h
> > +++ b/include/uapi/linux/dma-heap.h
> > @@ -29,6 +29,10 @@
> >   *                   handle to the allocated dma-buf
> >   * @fd_flags:                file descriptor flags used when allocatin=
g
> >   * @heap_flags:              flags passed to heap
> > + * @charge_pid_fd:   optional pidfd of the process whose cgroup should=
 be
> > + *                   charged for this allocation; 0 means charge the c=
alling
> > + *                   process's cgroup
> > + * @__padding:               reserved, must be zero
> >   *
> >   * Provided by userspace as an argument to the ioctl
> >   */
> > @@ -37,6 +41,8 @@ struct dma_heap_allocation_data {
> >       __u32 fd;
> >       __u32 fd_flags;
> >       __u64 heap_flags;
> > +     __u32 charge_pid_fd;
> > +     __u32 __padding;
> >  };
> >
> >  #define DMA_HEAP_IOC_MAGIC           'H'
> >
>


