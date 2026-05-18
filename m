Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66050CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9781D6B0005; Mon, 18 May 2026 17:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9501F6B0088; Mon, 18 May 2026 17:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F596B008C; Mon, 18 May 2026 17:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2BA6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:13:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0712312098C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:13:16 +0000 (UTC)
X-FDA: 84781791192.18.64F0C80
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id D977BC0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:13:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nm0Wzxs3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779138794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdtUTbNXCNhmI+LuqRwGM1avFF2CHCXidccR+1bE1AI=;
	b=k+gdhqEPXF0SY4rrF4ZFLPI2CZOoBQLSNqaquLjZ0PeC4ogPNBA81pypTWx7anCvfnLhCx
	Ore3FvsSRWXAMdIkJYbWE7GydN53AirL7Nqvx3l2eous53iqzTye9A0DVy6otpEWhA6qpT
	i6fvS+BtBrSZXjjbnVY2h+AQfLXD2/g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779138794; a=rsa-sha256;
	cv=pass;
	b=JiR9ubOxsjMh2DbJm+YfMbnvz2iP9JE8BePbVoCoQZHppFhZtX0Sqo2euDA4MRMUK+q3oc
	LXOhhBM984CQ3iMuHn/xWdmEjWSAv+zG+va+YHjpc6PziHt9jq5benrAb0DGcUVo0rHOLf
	NNYXJ/aFlEZs8WWruIk8hKrQxhPejmU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nm0Wzxs3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so1235e9.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:13:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779138792; cv=none;
        d=google.com; s=arc-20240605;
        b=HYEzb+m+pRdY0G4XrMeSztLQ9n71tKRUHryn+1iZJwDTfD8LeXif9Q4j2e4d+0y7SO
         zBHslSjBTu3hxQRaF9MXfHGkjomvAOdV8MGFLjmPdeURyjKdfzGC00iFUQe36As45e2G
         bCi0PtzIgSMANVl+3muCWCJe/fjD11ALcdeXdv1DwRX5z5ivolVftPw2GUS81Ux2DrhU
         EBEwpdGE1pwJjT4ekLqH7O4O62Tawf5B0Vu52EDik1cW8I76rt+ubcCJ1jNMOiJFQ9IO
         /qy7ofc2DruFNeISkkV6qU1w2u1J3PGQ1zKYKhO3AlmP1CkoQnnCqgALy43fasCh4JGi
         Ja4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TdtUTbNXCNhmI+LuqRwGM1avFF2CHCXidccR+1bE1AI=;
        fh=G5tOpVErHb024pUxRKKFg1sOzQTjXnzaGL3IpFtTklM=;
        b=UUiLfiJVdB9Xg1i1vYaZarXR3/9PZR212H4zBbvHJy0kDJVMHThvTrkkSBf0Ztn99F
         2H8xLaXVWK7SQC4fmjTn81P53hR2/KccVTd5ECxMrykuNOLIE6Iv8Bj0C1q7EzYGLITA
         LVoSalDwAZ7L4YZDEek9Klk56dWea6dmQKvZJNQHkIBqLOJnfUIQOj7kgfi4T5PxKBWN
         c3fevkyFg5kzvL/RNAU7I0JupkUaVF1PBexXwjbmFYNloXghZK4aNzd6hNWF82BfuQPo
         Kg/xjuoO7ZtRGlZYC7ylPzjiOIjhB3IPeP1m6+IGcdM+i8r41yxrKOmQKWl82ltEzMkn
         TI6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779138792; x=1779743592; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TdtUTbNXCNhmI+LuqRwGM1avFF2CHCXidccR+1bE1AI=;
        b=Nm0Wzxs3j5xN9XQCjHcX8krsn8ewMZ6jr5RUtyQ8/RHC/FtiYw1+L98FsOC/rvgy8y
         Ogs1McAUhV5SoUhqDZRZPD82EaO6dV6oPOpMascx3m4s/Pv7JuKFpSwtdsNmfl34qAis
         dZ/JYPtODnrxzXfTA8ln2jmHswOH60/JWXQIhkmw6xMPRGprZu3vXElNKhkACRRFRB8B
         h6/q/wkJIt7PgADBMR2qXUB9b56ODwinCMKuQfYVTne3v20OyLH+Jdv7PvpAnZ/95aiI
         vF2+lgiZGHfgIVzZP/WDhbkJd5oIf0ohOQ9uKJM0strbGpwKO1p4yIrz1FvVvmusi1V/
         Ylbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779138792; x=1779743592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TdtUTbNXCNhmI+LuqRwGM1avFF2CHCXidccR+1bE1AI=;
        b=AuM5IgbQ5XF/zSiZvVVZGLHcErpD8NN+sRdc/sVvvbg4rBA36MjDNOjg4d7qKHYZrG
         nEx0ARK0/D8GBRgz7TnO/HDdOYC5Q1gwZc/onPrhq2TPxtw+SAbBhtB2H/Ub3YWj0y1q
         QWZMNE16mqcZ34IYW396BacFDPLg559gLdWXv/1vTL1dM3xa/0YZ0O6kUjObkUMG4OUL
         f2QX+5onIC822/Y5r5FJ4SPIIoDo/TZqR1tkU6m3t5B7ccmwRDYC/0ZfSiPEzaDs5Rhc
         n6VLbVrcxqkSWGuWay5M9QLwkNKwc5iAkskx0I/wOYiWtA2uF8RnrymCK57MyUWj8CwP
         nF0A==
X-Forwarded-Encrypted: i=1; AFNElJ93ilgUXUEeLLTtEp0DUxM6BxmEjhiHTZj6D8uuGB6S7TEUZkiYP3Mamx5CIpT3dco2Xuhwa+FYcg==@kvack.org
X-Gm-Message-State: AOJu0Yy718TSp5geSIVEzDfHoonBqffUOulP8b8RDfuqKJEqFPLBaFoe
	WHANbiOhm/DZk5BU7JMCnE+8SPnCHUeB1Kn/R7U7BVq+JQZVC52m+OfSstDub07ARyORstotDwn
	CNkPrWs2CBzhV1873TjFLaSBa9ggrUPilN801kY9p
X-Gm-Gg: Acq92OGXU7rooukHROcwNmI3LAEYJV4LZLjoqeAWUOyKg83pt487pi1ONxLICh24zWZ
	9moQhKW46zWYZIIZZS++Ue2EQxEPHshemBYyqdRbS2Jg6OZeSrvDnorqZN2qZMaLIGquj8KgW89
	pMjds0GpiDBXpacuKD3rYZHkvMJhfJC+1/qPrRo2VsGrVKn+/1Q0s/VP+iMeFU611Fj9pj6ovGq
	pc4fBalSerKnt7Dv7Zem/z1Z2jlWyR+sndh9WrVtKMu3RkZKKHjRoGn3SZZjrgn/D6I6qLGyfRN
	o8hXXi0iVSPh313lXTw9TkOd0LHHVfn23dlcnbTwmpyLqAs3
X-Received: by 2002:a05:600c:5650:b0:48a:5aa3:ac1e with SMTP id
 5b1f17b1804b1-48ffd828c95mr2422185e9.3.1779138791895; Mon, 18 May 2026
 14:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 14:12:59 -0700
X-Gm-Features: AVHnY4L4foI9pbyItEwrt04ziyQl1Xw6iN4loxWK62AYv0ZIBdafhEyOwVCgdmg
Message-ID: <CABdmKX0gqg309hcXcOHSj_yTg0h1zwDL34GDk8mX3wp4YoyfDg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Barry Song <baohua@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D977BC0007
X-Stat-Signature: 18kjws6y7e3enb5kbmyiob6h47ec7reo
X-Rspam-User: 
X-HE-Tag: 1779138793-490901
X-HE-Meta: U2FsdGVkX18vBaOMQCI+jeXYnEaJV3t6lbKcqHXF+ya9SLzks0Gc5HFqALtzS/aJrEMFAb5gs/S4eWzicchBOM+sHgwT2IIpgok/XbQR6q8M1Oj+UofHObeVtI9JNh+d0KUBs+D5IT53rd7/+vSGOoHxSbfeq/d1jaLDqmaMuyIuZsS7ThYesvQX7/YaLP70ZnVVA5CnJONs2nbea1FkRcluMW7TzVuFL/IO1RfuDEJ9DnLoiqrqOQqD/uHEilgB0QagvCRoRDlCxj7X597nCmfVd8PHApq+GsrDiYV1KVAjO3fbVKryLtZ2d1N+cfbpdp9dUAiLjFxDDOwr1DFRJJ4szDNFWIVAeI71/1zu/w7YGaw65+uRDYk885rim33J4D1Zreib01gIOVOK+jj6qzrQhZw6mu+BbXpHLBKfTjdXyG8EvexTeag8tpKJ65CkxqlFZriSSZcBraobtgTeeaoMObUKf5vJgtAySZ8dJwQyCN7uW6DQUTdzX/KMZHyhNEiKDleb5CsMczj7kq5RMpkvNMjYu0Vnls97QrhdsYQAqLmU8TcdsW8KdL01vyvpKcluK4oykygepLXH71LUcEniDIG6qaWCJ8zZ6j98tUC9kldw2HkzowOdFjCa0BYdySf4Vxm5U+8skBC7EyogVRDd0rjBwRMCPTfxHTrIDHo1JriC0w48Gv84M7V6Jg3xGQa7r7bYO7LQaGMYzyT7sf3GtDMYPfBtTyangn+UJWLX73tQHoxE2sUiIwrUMeCoEm8PKZgNlDF4AzVFpQquAL4kZiSu+bqYV3rzaoFfFPcdqN8+SUREpbaWVIGlWOHNYPG/b6oaj+kevtIj2ZQXLdxPT6x9ZH8+hNicWnDEhe/GkXmijNynXkxBTEfHq4k6gW8TIic/q2MidrB8B7bzn/oCd9/7jYupMEOutW1C1ZpBQceu1yIThC5wOpARhtKMpzRnDERnejCOf1AeaGT
 sMdu+Tou
 LxuuLp1FgUVyMPpZA3//sX+aU+bvMAhQma1auooQ0uDcYglzpEaK0+tMe26YGKf7jl5wE/bRfjQ0kyQJlMePVtK1ko8SSdRLqkSi/kvuvIlVoKOS1oGKnYa4kejsnZMGu/lx6VqMvakOwhZ7DINOJ4A/k7jDx8kI02fxAv3iks/OGYIFOBtnMdD7X/XMCJZPVreOQXS7mRRN6Y8u3dmxbkMacd4E1li2YQenihICBOLOPGUNY4FjoPIF2CaITJ9nfTuZoM384U62W/+LeAWbBlcONwONUUk+5AOFxeQRYBdSisJyLJKtIiIouhIb5GXswm709dIh1XjQvI6WfCozz+wHgGXlJWz0P9sK8zXIaA51rA9Sd2O/+G9jhFa6dyONEwmn+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 1:40=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, May 13, 2026 at 2:54=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> >
> > On Tue, May 12, 2026 at 3:14=E2=80=AFAM Christian K=C3=B6nig
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
> >
> > Yeah I think this might work. I know of 3 cases, and it trivially
> > solves the first two. The third requires some work on our end to
> > extend our userspace interfaces to include the pidfd but it seems
> > doable. I'm checking with our graphics folks.
> >
> > 1) Direct allocation from user (e.g. app -> allocation ioctl on
> > /dev/dma_heap/foo)
> > No changes required to userspace. mem_accounting=3D1 charges the app.
> >
> > 2) Single hop remote allocation (e.g. app -> AHardwareBuffer_allocate
> > -> gralloc)
> > gralloc has the caller's pid as described in the commit message. Open
> > a pidfd and pass it in the dma_heap_allocation_data.
> >
> > 3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
> > SurfaceFlinger -> gralloc)
> > In this case gralloc knows SurfaceFlinger's pid, but not the app's. So
> > we need to add the app's pidfd to the SurfaceFlinger -> gralloc
> > interface, or transfer the memcg charge from SurfaceFlinger to the app
> > after the allocation.
> > It'd be nice to avoid the charge transfer option entirely, but if we
> > need it that doesn't seem so bad in this case because it's a bulk
> > charge for the entire dmabuf rather than per-page. So the exporter
> > doesn't need to get involved (we wouldn't need a new dma_buf_op) and
> > we wouldn't have to worry about looping and locking for each page.
> >
>
> Hi T.J.,
>
> Your description of the three different cases sounds very interesting.
> It helps me understand how difficult it can be to correctly charge
> dma-buf in the current user scenarios.
>
> I=E2=80=99m wondering where I can find Android userspace code that transf=
ers
> the PID of RPC callers. Do we have any existing sample code in Android
> for this?

Hi Barry,

In Java android.os.Binder.getCallingPid() will provide it. Here


> > > I'm just not sure if this is future prove and will work for all use c=
ases, e.g. cloud gaming, native context for automotive etc...
>
> Thanks
> Barry

