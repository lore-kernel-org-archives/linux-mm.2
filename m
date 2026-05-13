Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E7CCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FE46B00B9; Wed, 13 May 2026 12:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5065A6B00BC; Wed, 13 May 2026 12:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6116B00BD; Wed, 13 May 2026 12:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6076B00B9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFA311C01F8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:35:47 +0000 (UTC)
X-FDA: 84762947934.26.6C79338
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC33BA0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:35:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pcWg97Iz;
	spf=pass (imf15.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778690145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zj0jmb9V6uocZqGLBP2x2wTsHN3iLoSffmt/99lGtBQ=;
	b=1EqOGBbA+sHN4PUoN6etIJW3LqgOKpLFUXkca1OlXxbDjYhJDkQKB99RBxd33I9kZREg/5
	953wa681n2NhzfH7CNug1wVxfNNyyKdM/ZCxVYjUXRfJaPKhXnb2dccxIca9oywsqJYtRg
	Yw8TlETl1H0otdnJSg9+rnXcrs9bXu8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pcWg97Iz;
	spf=pass (imf15.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778690145; a=rsa-sha256;
	cv=pass;
	b=koHQBBMygOANhf5gZvwI5qOBH7r92LVuQ0oAm4EmdGjrLtaCd1mlpRjEUYlhlE2RZcBPtz
	cAc3V1ows+0J40CBU72EPptvMsTSaYoqwldv989fU4DlALA8bX7UpR59GAYUai2050Cd11
	nyoukjMzQ2wQ1PUUjZ27Fx8Kam1Vz6o=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48d1c670255so3465e9.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778690144; cv=none;
        d=google.com; s=arc-20240605;
        b=IxgH2/86qDPgVvyEvSPMLijJg+vMcjxHhXxyDHMcw4fgjbVL/xs3TbB4z1HrWdmT/8
         m+80jqe2Ifn2SKUrBUpZuJA0WmRukyi0K8ppf1HMlNDCxo3U/laPHfHhj2muhrV/2JNc
         yoYvLuXSaqDAGOKdoAEz4dmE0whb4vvZImHpePw7MhktxtMxSz0lwUazeJvdVCdIivQf
         wyS7ASCHvmwRmBwE0QgYh9n3wue7+KuI/Q40BmPQC2fiS2vCVdnNOFgb31lOVuROVslu
         I4z/KiKCIp04/b1OLmB10y+GGcYrFc4gdhGEq1lDri67peE62ap9TdbbyayNDkcOyDPj
         jarA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zj0jmb9V6uocZqGLBP2x2wTsHN3iLoSffmt/99lGtBQ=;
        fh=6DsAb8WI3/bTg5XQmCJctF7cTOMJh6ONCj8TxbyXwzk=;
        b=UpnpssYlnxFBD9IniwSbdcVs5F3VirzDgW66dxFIVP1mrM5hYmncCZYNO6Ph6AWHCS
         4tQdjVt5Y4l1/zp6Z3qmqIHTUgAS04oyExqi8O+GwZw+EoS4PjYHRED5M6+0sxpqFZgt
         dTmxNQc0/uVkqWLvlF6bGfUDHs32iDt7qRVoHp2xfO4ioUsi6hRl3EmQyqPLquWbsXkA
         tuhKHZtaIX8drKWoqeujgrd5GdjKZIf4GovV/c81eul9+IeSVftZOGCzNYAqeB9Y1z+z
         984SGgqPQtVOmRzPU2LRQ5riDm/SyaUfdKul1BhOz8CYI6uI9Vf5/a6LKzNpsd07kaCJ
         QVbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778690144; x=1779294944; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zj0jmb9V6uocZqGLBP2x2wTsHN3iLoSffmt/99lGtBQ=;
        b=pcWg97IzmNtgcEmQPRDGX3U4ry9N0v9EJQ++MPG/khcYKBJIQwk2VZjAq4qSxwSM4R
         WvLsVkcOzJRdHEqsOqJYB/Ui0QSeoTyK/m/vABwHwxtqIplK8Bjspm3jy79f2+Mgkrjx
         d9cgpVue0KWjTTtWjBdqdhfeKVXR5WV/6cusr0x+MgbarsILeMguLpXm8sTw3DfSL3kI
         SnNhWS3nSJ1jLXA7awI6Btw0tbdXybcpXAbVAC9ZKJ139nsasB53KzGLXJbXgKVNiLad
         LvbKprSR7g0bkvFVE+I0yEkFa+vhkYVchSGDfVWTW0mUlBWLwG9nSYV07qeHd++qx7JE
         0B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690144; x=1779294944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zj0jmb9V6uocZqGLBP2x2wTsHN3iLoSffmt/99lGtBQ=;
        b=nirur6r8mymEPEnyWbkeGj+baoIQ1NLpuKrc10n4YRkoYPH8htZmq2qsHzRST7VD4d
         T0Y4+wf1Y3mUt3bvcEy3kxMocmSagxLD+IPMOdYK7+edI5Y8VCqfPyha3bO/2gfGVX+S
         +LNi+/45D1D6JV/vwDf5AT5apTbq9r1KUOns7dwWwjdHlYqCb4f2bLeOJOmwGu20t8Nm
         QSHdzXVq0V25+iaxnWBhUNABMlmT2gBG7eYrHkW+kR6ZEip1o53Zsdz95jmSh97L1uxw
         e/ImGAcOv7GzQAd0tg0h7knmqLAOwD9NkZQq5mr2oa2JCWMwxj0kxe0I3+KolSjBmaH2
         UqIw==
X-Forwarded-Encrypted: i=1; AFNElJ9681UwlqzotSfPnOiGTIqn4ul9JgybSa3d7RUrlUg0q+ruaQW8QdGarZnl4RFtNNv6RshhGsMXQQ==@kvack.org
X-Gm-Message-State: AOJu0YxXYGcbaPMGw9qzEIeTmt7jz24Wxokzx+GY0HL//75kG0fB4c3G
	lNR8hz3/1bEo5TlxW1k4YJpW60dNyhDnTMiQ9dm8zOhMgnbfialmtVAlAc3x5UqbJs9zs9HUiii
	Cju0rqrX4aOSdDTfiR1cKgzajE7H8ROJu/4HojOkF
X-Gm-Gg: Acq92OFRLia40OzFVd0uOtJSxlnuQ9j1BmV5c7dnzLsuj+kLgeD7m+TXBSpz/teUH92
	6MA1PHJ3J5sN47W1HtSo5oYbmh7xnmbWSaAi9AqC8/wjOkf4J10CKCdiy1YVDVFpQQjfsFlaWQX
	z6MJyo6+SP0eVAEzbV16JP6Qe9g9/0TT7vMIIulVNY+B1o1lkEr39fj0LsymQhqQk8SRvFSXoiM
	n8UyvVNGrCqI3azMrBx0jG99w9fLBUrIUkLvn5SVgKHmQa2PIrsbiBkpG/TkgdMMU+WNHUa5IPK
	O4c/wIDSpymyJAh7oblxjGMRdsT97gK9CISVIuiRPsIYX3dv4oBIXTG2YbbjXAwYqgGrX2Sdy7q
	wzT/9
X-Received: by 2002:a05:600c:498a:b0:48a:5d55:c194 with SMTP id
 5b1f17b1804b1-48fcaebf633mr637765e9.7.1778690143587; Wed, 13 May 2026
 09:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
In-Reply-To: <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 13 May 2026 09:35:30 -0700
X-Gm-Features: AVHnY4Iz5pSM22PHb1EjHxZSE2q7iQu1xvmkgoj7rmjnAMtDWn75b0gWmoJdQQM
Message-ID: <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
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
X-Stat-Signature: 6zyyjmhfw8rgqpk1s1dfu5g8yafyqxkg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC33BA0007
X-Rspam-User: 
X-HE-Tag: 1778690145-744036
X-HE-Meta: U2FsdGVkX18OL/O5eH/9TeheqmCmmjDYfJsq9CAcAO6DdepUqeQsS2bzGmo1i6mlhUgAPUhRepyo2KBAUAlZEgJ0rEcBHG2nt61jxDJ+QqBLZ76lQl9euRZeANtuIiqBruzYHOoS9kiuNRVeZ/NEs8eNbuXTw7g8XuLRdaCXUIANOpmQUuHM8wCWi5uEk/nfKX1ii89XJQ/oBGVY8UjX5N95/Zs/jpdSZbFBB6y0w63B984KuL5zCLr7rgQmFRG//V/QtgqTZ+uAZknUJlzrolsdSf6frMOMdmYTILCa3d97rx5WvvZcACqVvmA7J+V47VLMBf0D/zfLegyhEyrMCGe6ovdTIF1+sVnwUoI1o/iZoWvXtxN2U3lRYb7Qvxst91x2utnrjacH3eMJpU7g16V0at+oxgusWBIGWf2cqjLkrbXbEIahTzlIT83cldTUH2MWtE7G598C99T7/FgdEjqEwbZdZmGx5jsiKFyeOBX0pDvrFoWqVDK9BsVRTPMyWcAbKJwr0HNYZx4RJ7ICI6+k4WaKfwvGJjmA3GO+TVrnCvbexVUPv35ZD0pua3gQnin0G6ntXOHDorfagqiOM1ruzbxVdg6sNJawsOS9+fWEdXfveVfopsMyqAZZMqq+538vpGoQIBjF4yIqWKhm0cqL1MtzQhhstWMi0om2W4i1KpOo3zlHkQU48JSYXlcu9d4yPPCtyUNQEF96qTNOSlUTuYwkjxL3NuzTdRZdhzmwoiNrB4XKnAebRM9O/P5+uCuKvH0QpscvGq8+SZGWuJ7nnOrtBMWDpVYliAlBuXLz44l1M70YOFOYrCrhk803GNDXBIJ/b76lodrof+Mm/qUtSSIbIPd5JB1vVjQCwHKQmjmXu6bsYxqnmitk+PEm+n41nKCLiupsXekj1QgfmnJETMaYK/lIvohbFhIW12DQdVLaxz7DtqG5F6ffDMfUOdjluoaTGP7+yoi1/HO
 lek3f6cV
 SRLbOlYaYlKf9jd0Blw56RXRxLJPcmlccsKT0dGndBA/X0D5TqydDpU1Rk4UoaC+woRzlUebazfbicSpDivTMGvrr/7NkUe6k2TTM63yEqyvefPpENIVS6VKnCFe1gFOnrXbKV3msDa8/a+2kLphSrxCKZ8vvlopiLmweJLujgyCOwLGh/H8Ux6U7HvNtAicQBFprjzKjL7FRZQXF7xpgta5LpkIV4bYpBrWJt3b7jhP6jQUVeYW1cvWrFuSO2B6FUgEIze0+onbKnGuKWqC+UJMUvpQYWIavdmCltIKzY/fSoCGkFRugTNO5KaXcIe516llNhuYFqaLVI2df9Wvr49IAwcHWzQ5I9VdW9cQAg4OoiHXtGyTJ/UInalGVXQn0teDx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 4:39=E2=80=AFAM Albert Esteve <aesteve@redhat.com> =
wrote:
>
> On Tue, May 12, 2026 at 8:53=E2=80=AFPM T.J. Mercier <tjmercier@google.co=
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
> > > I'm just not sure if this is future prove and will work for all use c=
ases, e.g. cloud gaming, native context for automotive etc...
> > >
> > > Essentially the problem boils down to two limitations:
> > > 1) a piece of memory can only be charged to one cgroup, the framework=
 doesn't has a concept of charging shared memory to multiple groups
> >
> > Yup, memcg already has this problem with pagecache and shmem.
> >
> > > 2) when memory references in the form of file descriptors are passed =
between applications we have no way of changing the accounting to a differe=
nt cgroup
> > >
> > > The passing of the memory reference already has a well defined uAPI a=
nd if we could solve those two limitations we not only solve the problem wi=
thout introducing new uAPI (with potential new security risks) but also sol=
ve it for all other use cases which uses file descriptors as well as. E.g. =
memfd, accel and GPU drivers etc...
> > >
> > > On the other hand it is really nice to finally see this tackled for a=
t least DMA-buf heaps.
> >
> > I have a question about this part. Albert I guess you are interested
> > only in accounting dmabuf-heap allocations, or do you expect to add
> > __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
> > non-dmabuf-heap exporters?
>
> We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
> controller are on the radar for follow-up/parallel work (there will be
> dragons and will surely need discussion). For DRM and V4L2 the
> long-term intent is migration to heaps, which would make direct
> accounting on those paths unnecessary.

Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
guess this would only leave the odd non-DRM driver with the need to
add their own accounting calls, which I don't expect would be a big
problem.

> udmabufs are already
> memcg-charged, so adding a separate MEMCG_DMABUF would double count.
> Are there any other exporters you had in mind that would benefit from
> this approach?
>
> BR,
> Albert.
>
> >
> > > On the GPU side I have seen just another try of a driver doing some k=
ind of special driver specific accounting to solve this just a few weeks ag=
o. And to be honest such single driver island approach have the tendency to=
 break more often that they are working correctly.
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

