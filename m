Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0717CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111426B00A2; Tue, 12 May 2026 14:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1566B00A6; Tue, 12 May 2026 14:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA8B6B00A7; Tue, 12 May 2026 14:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D29AF6B00A2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:53:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89CB71405D4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:53:28 +0000 (UTC)
X-FDA: 84759666096.03.94938EF
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 74EF3C0019
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:53:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fgZgdrIZ;
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778612006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrEiWuJQdbxBBI+NqMaHT087xAKAEKai4Pv5jifgOpI=;
	b=0X2dTaVfz+mD1Z3odAe7xWT5ZRi8kWV5vsCqRJ7mQbadjwABUp46ENI2OHx9ZALlLHwnf2
	YB+LKQ6qN+VCwGRxqNsqKOEDi/tWrhDRhesnJOp/TCCTa6Y180l2NZMTicicvQHgUY9AFS
	a0eV99mW3H5TJebLRA9OrxPSndC3ggo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fgZgdrIZ;
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778612006; a=rsa-sha256;
	cv=pass;
	b=NgifDHvMAc1Hnmiv70ahxFB57vVivXsbgpNjUAyidSNy5ULrp2hIHE1AxpaWf/dGL62li6
	pJTUZKvoSdemd44KglVKSTKcN2PpYF4TRyulfFVROURp1CwYq/va1QjMdr7WD2WUl8k4Mo
	E+PuG9mM+Zlnl/nNCWWdqhbkgoNte58=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so2705e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778612005; cv=none;
        d=google.com; s=arc-20240605;
        b=K6fG6ZjHhMkVQjJqZ18Z6L60fO486u1AhXz6xZMZEPFMR2VUUkcesggINM9AcKUH0n
         kLCqlE0E9Iox4/gQEFwzstHewHXNwoEMF3RGhEQMohkxwBLOo1pabtR1GZv4D6HZKHL3
         kqtNMZdmNHQ8rxFTpAwNxK8f8If6DDA6XlzeMF2Jj4O8aHViNPaqqsVoHM3HkFfdMPXl
         gypj+DqdsLkq3LGVn+0HmzQUPC4DXQoNBl/+2n5w8YILPVdYXuirMpWwunPHjZDc3ZL6
         OTATyJobouz76Y5tywipQ2Ph5CfbBDgb0I5u/eG5QHxI1b6t8OKz11DrL3hRSjclD8/3
         4bAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TrEiWuJQdbxBBI+NqMaHT087xAKAEKai4Pv5jifgOpI=;
        fh=CnmUV8UEHEuwV+RWMHppXZ78eharquoCg3OdSPh1srM=;
        b=ab0fZTqJP5AZVtX0oUKr8Yto92fpWbJlcVST53H/ac3jJJ71gmFGd2OzNUd0z3llL2
         RLDBaxADN6DvKPPlNBqnCt3Bjlm4MMI/bAKeyyKdVbaVE5G6dYwmSbSTaBL18YFKG/OH
         OHAHSXA5A401YFyhlfsx8fKhF0WXDqAqrO+5Ee1NY2SWe3Wu324rMfEiadtwt6Q21Yt1
         o9xaMOt1ACeZeMxKpd2gaj1PlacaSknciWyQ9ZfpFsBgdibkqvBbt9ef2GLVICS/ckF1
         b+oOCcbQ8sLlzk688EhNuT3fYwEmBWOoG4/UadnGqWXVGEuR5MRT7e5n7ZS5dbLIn3rP
         J/yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778612005; x=1779216805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrEiWuJQdbxBBI+NqMaHT087xAKAEKai4Pv5jifgOpI=;
        b=fgZgdrIZzJRj7jy5OZCnWb3okW2cNn4BPFBIdN4K+irs5Xmix83+yPNmj8OETKF/oT
         cMZ8oyVQr54saWPa32fwF+nfSrR2bMvGhx5n/T4dF5gynYs55aQfsSSeUI4uIzpLfdmJ
         z5IZfIHVDsz4B8AGa/ZzutZoJwZsV4fp8sktU2vfwHZ3a6G2pa+RKR/h1ptJolSC+rb4
         Wle9pb9y1fkYRfxYlf/OllwQAf3wvWevSbB/eLG4A7RXQtz9K37En+OjLT4CxLHxrvrp
         3vTMa3Du/rdROy61zy5omsZWnfwYnzJ9Nqs97BM9piNC94bXHHkLnSP9FqMcka+Ew1No
         yWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778612005; x=1779216805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TrEiWuJQdbxBBI+NqMaHT087xAKAEKai4Pv5jifgOpI=;
        b=qZ8aZDa5RrxDxnVUZuErb9tSxocOS+/0g8+HajUlLaRC/UBeVQkB2qM+oY9Px2Bc7X
         1mAEmzBQQN3tjTAg27zXQ768SQ3TbLORf1ovYS3/DFGwAF9OdAkIBDJGV4Y5USrC3NPL
         NDdk9shjZWzeaGNLx4iuxKQP/s7SC+fbG7bMxS15CUkx9b9iVy+nHbXK0dGxXzyEz6rd
         Cn3FAJwcNW9OlzIgoDjnuOaRuAHvGhELyfDHgCKnVM7MDE5G356QzL5UcXGWTSqGpWuu
         qbGOyNBQ/RLGZQFLuG+/eMYYAaVDFwNkRIsOGw1eFzaKB/fhJoJR7XYOt9BlHqW2mHP0
         JCAg==
X-Forwarded-Encrypted: i=1; AFNElJ/jNiw/v8yx9RbmZl5U7F9vtNvmelhnJD3y1jWNmneZIcJdXTAPIVH/C90bv05JiHt4bBf/1Imzag==@kvack.org
X-Gm-Message-State: AOJu0Yx1W9KnetMy0oSoSqRnP5ZggjBmZPE3MHcQJoRk3kty7hbzR0pO
	/jZg37mcmsawHSbPVc5ziIyZE8PF16FZJArrpB516jlQadbb76p9bu56/iBIhwPZA9SR83xEvYV
	4LEi1/Lqyjy+M4qdjKDoSOruBc7JNdcsWl1IQIMuR
X-Gm-Gg: Acq92OF/ZiPiZJAMFcCvNNlhp4cfWInlZ+gDonb68FBoiZzfF0OENGBP2EeOkdhAh+0
	FyYoJ6O3/JQqth58K16MCtjn55iJ/5B5flgTiIisyXRV7LgdQ8aApOMH0s7KntKPqklH7Ok7Zia
	vzPOESrUl9pDEc3CrPExe5YW5a2UxCVYy7uaWYf5icVbWB1Xo8epl7E7MPYsRcjKK4IGOXXuYnP
	f1Anqfg7/TBxxMVWSQ3e650iSPicFFL8xwtYE3KRmmv1buwFWj/jzjGThz97DrjXymSrzLsIjWs
	baHDwc4Aarq+qAcGGqWC2DSM2u2BQfRwozrOxw6smP7Eo8k1Iut5r2udJVOUoTM53BXamQbYxKe
	hbKF8
X-Received: by 2002:a05:600c:37ce:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-48fc912731amr162315e9.2.1778612004394; Tue, 12 May 2026
 11:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com> <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
In-Reply-To: <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 12 May 2026 11:53:12 -0700
X-Gm-Features: AVHnY4JXtRqPsXET8uL03o5gs-ClmvUux85Yh-qyEMDfOBbZC2p2MhMEibIFp7A
Message-ID: <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74EF3C0019
X-Stat-Signature: 3dmywx97pjxuj514pnw8kot1y3oj3366
X-HE-Tag: 1778612006-596746
X-HE-Meta: U2FsdGVkX185miwEkMrO0BVGBTpve2Aw6bT9/SkdZ84dGEawrHfao4Do4aM2pZpgr5BHkWu02Ccv+SK4VnuO1d4fVXc96GWzWIwOPXo5Ew+lRHcF8brBmcktLKV/zvEtohTQoqPkxEmSFhttGyM2rM+iDl9T3LeeezKhk/53q3OMQoICSasWr7sDo2ALdEPcp+uEaSYXJPFogDBoXUrQBAx41ib7nrfK9UvlmFpR1FA+rQPbAP6BQ4VFOqabgc6OKFWQ58F0YtILdoRKC7iM49dlXw3rxBJtLyqC8YQJ8Uubmj4iz4irMzODFYXeSWWG4/I/11d/Gr+P0UYFuoEmlokaC0E8HRV2+wn+RNiSTnNzafHAqdbdD1Z1cU96Rsky96iDjA7ebXrvbTOJiStDW+nm3345colNTfosLJV2zFkTjrDEoU0HetKiinSPnQBkPm1TSSfjdmTrg3vtfXj6QLNTBXlxFzXxxjHtKqUpEa/sBvglQelpjU8jOnjoNbB4UfhtBllwobr9k056hmopuNFzQ7HVT8cUSUGR4GmMlKvunJbqpkuodMfIUldaZP0JUcj1lJS9WcNuijLopYVlWpSDhgO3seCNKM7ntjAbBRf0hnKkDDt8hS1F3lmbcfXhIkzxO+tbDyzl/tDgD5/3x0FkXFUDfPF2wA4IwmsC3rSCjkMzbxWAVdKPFVDNdP1ldttZZgdlGE5YjcWV1QkqHU312BuP4YItevS8Rpk14OouwamtpzWj7yfIxv4lbP3bWDKORWILsZCcmYfU6gIPD5a7UJIdLdn5vLQWTW5OKonvhJKuOPJ7SIlScYb/ZPU7UOtPRD5429wzVmp4AdI74q2c4SYonggi+w/Fjc0sILWOb7P0cMpd5IWWlupYGlTdASjme5hfUm5XURLW8iDCxGYlWK1iTbJtacNsPcEGAmXOoQF6LYfqDJumcLl2VY+ebz6Ia8NXAaXUgczJD+T
 ghksCDnE
 4HiKZCVAWM6/Og8ZAXhr5WKtpBVmW1/3iQlxvewm9gEwfchFvJERRlwgWwsr7BNAJGry1M4Zn918zdq15bsmzf5Tq0mdFfNdFtNaqaNeS3VA/ajdtFCXgmjSdKGsMJ/Y44pI0S6vNT/olbE5sxIy4NSShOk4rKE8phQkvZPRxsWYbTnp9fJ9i3kgqohHBa16ycxwl3Re9yJY/gq6vV/9fH/TzdYABt8I3VjLXb+3OE6MPUhz8n56b9jFsILdAOfMgQTaaDCrVPhuLEhJv36/pnR+wDXw6QsIFJENHonfjgvm3PmdiqHpBG9LvzNmQAyYzrfZsaSE+vTjrQTmXXSifAyxOSsC2wzOK9QubcvVy9R9YKfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 3:14=E2=80=AFAM Christian K=C3=B6nig
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

Yeah I think this might work. I know of 3 cases, and it trivially
solves the first two. The third requires some work on our end to
extend our userspace interfaces to include the pidfd but it seems
doable. I'm checking with our graphics folks.

1) Direct allocation from user (e.g. app -> allocation ioctl on
/dev/dma_heap/foo)
No changes required to userspace. mem_accounting=3D1 charges the app.

2) Single hop remote allocation (e.g. app -> AHardwareBuffer_allocate
-> gralloc)
gralloc has the caller's pid as described in the commit message. Open
a pidfd and pass it in the dma_heap_allocation_data.

3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
SurfaceFlinger -> gralloc)
In this case gralloc knows SurfaceFlinger's pid, but not the app's. So
we need to add the app's pidfd to the SurfaceFlinger -> gralloc
interface, or transfer the memcg charge from SurfaceFlinger to the app
after the allocation.
It'd be nice to avoid the charge transfer option entirely, but if we
need it that doesn't seem so bad in this case because it's a bulk
charge for the entire dmabuf rather than per-page. So the exporter
doesn't need to get involved (we wouldn't need a new dma_buf_op) and
we wouldn't have to worry about looping and locking for each page.

> I'm just not sure if this is future prove and will work for all use cases=
, e.g. cloud gaming, native context for automotive etc...
>
> Essentially the problem boils down to two limitations:
> 1) a piece of memory can only be charged to one cgroup, the framework doe=
sn't has a concept of charging shared memory to multiple groups

Yup, memcg already has this problem with pagecache and shmem.

> 2) when memory references in the form of file descriptors are passed betw=
een applications we have no way of changing the accounting to a different c=
group
>
> The passing of the memory reference already has a well defined uAPI and i=
f we could solve those two limitations we not only solve the problem withou=
t introducing new uAPI (with potential new security risks) but also solve i=
t for all other use cases which uses file descriptors as well as. E.g. memf=
d, accel and GPU drivers etc...
>
> On the other hand it is really nice to finally see this tackled for at le=
ast DMA-buf heaps.

I have a question about this part. Albert I guess you are interested
only in accounting dmabuf-heap allocations, or do you expect to add
__GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
non-dmabuf-heap exporters?

> On the GPU side I have seen just another try of a driver doing some kind =
of special driver specific accounting to solve this just a few weeks ago. A=
nd to be honest such single driver island approach have the tendency to bre=
ak more often that they are working correctly.
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

