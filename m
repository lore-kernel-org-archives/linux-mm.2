Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E52CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169236B0092; Mon, 18 May 2026 17:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140E16B0093; Mon, 18 May 2026 17:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057986B0095; Mon, 18 May 2026 17:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E85576B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:17:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91D03120A2B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:17:42 +0000 (UTC)
X-FDA: 84781802364.22.E72AF26
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87C1D40003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:17:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jou0mJw1;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779139060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=log57cx8SdjIr5w2o2XwNSf2dPRv6imxY1LxmZJSaF0=;
	b=G9eoM3Uj7Lu2Vjmrt0sJRgss7pNyaEP4XeQ8RR0HIGBxrmlNZffY3IzaZaTwL+9zNorC/Z
	vGJKaFLEPzZgREf72zcxPu6AxXb0REV1bX9chYGFBAQ+USlN/uBFt3hBTND4gaZvsY9aki
	xRYVicKhUYipD+AlKwOXLWW3Mv4zI2E=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jou0mJw1;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779139060; a=rsa-sha256;
	cv=pass;
	b=PCUg7UXSfTSpO9/ps08blX/1WHrYbMzgineMZvpduERikkB0AWybJ5k2WqoB3aQUJpgnDE
	TrtqZB4U1bomx8ZObBKSvGkBQpOMuNu2pS49Gtjlqozf9S3aSnV1V/CVfjK4F2dLuZONfZ
	H2KSsELiClghMbp6T3oX6Yy/Y0fodaA=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48d1c670255so625e9.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779139059; cv=none;
        d=google.com; s=arc-20240605;
        b=QdmGv8RxuJIHlltxmI1eVOetxkJcNv8HnajOKsN7xexvro+cm7/DytC39E4RRLHfUc
         HrHoBXpVDQd3d3Dv6INdMkUtEuuxBlXepZMZxhSWfzacgcprTbmiCbWAykmSSSaU2As7
         yEQoM+COOHOwKbk3yXAYlBXP/PtTt2UOEeefcW5DZrh/bhVW6KIvkE43GykrwAxanB7L
         NqWvSPSUC2ChFeculA6nyS8vZlUbeOXuxieZgo23L76tPZZF+//Qe5NEcpLp6ZeAmGe4
         Glx8z2ZkPN4n6cPerRP2qbrj+KaMx1OsOZ3xGDm/1aj6FW665arovZ+V79Fu8l63opmn
         //5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=log57cx8SdjIr5w2o2XwNSf2dPRv6imxY1LxmZJSaF0=;
        fh=PUzt3H8bicBadlYGq1+I8yG4JQIF4r5V9NvI6ItYCvg=;
        b=YIZxLdwBId4S/M39PCs4zHAtMK2xGoIgKI2H4pq7llVdMSwTbWXPRIB4hVTOdrkSlr
         Hwrf8O7rAR7n0mDq4Rfhnb5ZME2dJMt8ANjBz71aFjRCQQ4Py0e9vi8sqV5yLYYnMdLj
         FeKKO1NChLRz6c2DPpXfujh6S2DalagU+doStlEZs1BEcGjIpLe6HetYJUnjKySsdgUD
         zyFufJcCwMlN6w+oPOI0CB4Ul6/Imr76R5E0tn5Wt2kJwMmsB82UymF+Cw1xuTh06wmt
         tsQuXWPuGQ71jkugXRHGHfYzyzXN+3h/fueRcxizc5IhgiJUhvOrrugcMKx/R+dOUHKh
         Iu2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779139059; x=1779743859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=log57cx8SdjIr5w2o2XwNSf2dPRv6imxY1LxmZJSaF0=;
        b=Jou0mJw1VVQ9+O8P7Ze4s3d2TfbYKNahVPKTlvMxDble1tXllK+FmwmnY3cKTrnF2X
         UU9UxgsaSWUosDksWLY75jwOGkBpTgl3ZG5BkvsQoCOe4KipZYSrcDKBwjlKAGRHM01R
         GadOIZbKkM03XqPALxqmlxpoLUNP2CrC2m1/322SfV7WGw+Nu9xJWDBvYW+LqA3WLEVA
         SD5TeD/jklWSOLUkicG8jXRTkWEPGLs04N+sQxpQZDw9nqvi1izQiuRvwrG/98WwSlRH
         JKXh0irsv7VGYY60nRapkP+IqK6NvKLegcYrt2HpIoV3FaC/b7CUNocVMqohZVkzEQQR
         GZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779139059; x=1779743859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=log57cx8SdjIr5w2o2XwNSf2dPRv6imxY1LxmZJSaF0=;
        b=q4yihL9yjHHMahNHSdsnKxNutz3ZyPdraUsuUI/SkFvzESMybQCnx8QzI+zsA1DN8e
         Eygd5KHX7TTCvky/34vdb3/m3IYsKxQQCpBBprzYX2Y4BDd0tC87pSmhT/CFV4LHDRqe
         tTt6X8IRSS8+h3mmciXGBXekeJA6npqQ3HWWAVmduSDA4w9sHnga9Lu/8d3x4nGd9uYW
         dGa9Qihm1a8zKSYLBYpA44hkpj+vceKQVqE6tUuA6b5MtWEegBelECeVhCbZb+axDLCR
         h9U92Gwbjul+ysnYY9vAeu8DujxbUrnMUGV8ezsqgxEBSvu2vm2tJDIdIRKXhP5JeOic
         XY3A==
X-Forwarded-Encrypted: i=1; AFNElJ9Ldo1nqgNTMs91auJRxveGMxFfslE29VqFOnb/fP10l6x2IN/+rbpZxO9Tpurugfql5Ya1OYiwOA==@kvack.org
X-Gm-Message-State: AOJu0YxSLAo8JQKcnx6UwT1U2uqV5eILjXxED7x/NN74POa93xJeMqJJ
	2xK4svYjENjwcOCHodaVzNWMbKDfiDL8LRc6st4kVoLy4BdF6NvSm0Cp8rm828/d4WX9D+VfLAL
	R/zFsX30/vw3pYP+LXKTfh+fEd9Y/QTIQ/JilmXFM
X-Gm-Gg: Acq92OH1TsOXjGicvjPbVsl3P8L8djNpI6BSnqDtuKHkhpTjtPw4HhZAvbZzXrw7z4N
	MmKcQu+wVxlkNdJCLKycuXlFasbaa5B+VOCqAArQN6bnUkbSCx/7bZkbIYD3QaHOsWOIB3JZEoC
	fZpzPTpfXud+CJmrz14tPWSha6rlNw1IsgaB5ihMeVjcfRZdA+lWH0rSiTL50yske6llsI2rDp2
	8ipYBjxdknMBLdlIudDAoOYYa5x1LcGby/2tNLZZKUyc+I/rJuctq1/dgklCKcFjTAAQ9X3N30g
	0YpwUn3YQqfTAL/dg8FOhnV5T2osP55QzEY+FQI/yHAIvMCAPntJaWjQwDE=
X-Received: by 2002:a05:600c:5888:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-48ffa5a3865mr1584195e9.2.1779139058579; Mon, 18 May 2026
 14:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CAGsJ_4zjrFJYQQsLThTGXR6g+2PXzeAhjyDpLHfDFqVViWvyBQ@mail.gmail.com> <CABdmKX0gqg309hcXcOHSj_yTg0h1zwDL34GDk8mX3wp4YoyfDg@mail.gmail.com>
In-Reply-To: <CABdmKX0gqg309hcXcOHSj_yTg0h1zwDL34GDk8mX3wp4YoyfDg@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 14:17:26 -0700
X-Gm-Features: AVHnY4KTHXYs5nrbWVXYvXQ9l6M2g--DIK3-AK3RR8R_cqbjNyBgiR1O8BbuYxI
Message-ID: <CABdmKX3wwgovwS-V8rVC3=+EZcTvPs_cttpQb1w6WemwLAVhsw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C1D40003
X-Rspamd-Server: rspam06
X-Stat-Signature: fhxnd75yscqfrj8ft55e9rxtgst4pyjr
X-HE-Tag: 1779139060-218782
X-HE-Meta: U2FsdGVkX19vth03pT/Bwrm+pR2rSlpdU41xIybDWAmv/+n/iFjlI6PGSS4QRGP1Bsapa598BHfkhB6mywVXIUExWT2slZU25iuAE9SBXalp2KEiTYWN0/GYyU1IYMyIIanP32wk7c08GNm0j0WsxLSeiZFOSLPJkIGvT/bG6/iRix7hrjSxMmG2yz0aO6OZR/KVtf7N0evX/VIP2GofDiu+CadBbeGZG+eRPzttOEOgLw8XKV0iMHbDKUbVvuSyXPq+i114nt+HqhTi5GF0Q7nvRWc2jVwsv0TwWwE5P4FFKz/gutbX7ev/B+NZlxLZ9YM0paPQRh9sr/7j/JwuG5isZyMYZ5AZc0W0OWUN7UYbft32cvzjVEteLB7NJJCFzSfB6Y8VltG5XOcr7cOaobKTZl8OuzdyCo6mmdMGGlCvHdrJZvcrvVkLOSu+flBoFEzCK2GuiojE14qqLO70sSS0yoWGOyHJYxhU9MezDGD+L3gurtSyn+BRuljmA1aV1GZxzLMCSgnMRAY4p+RxURMZUOzN7ib6p/auT2layBtTGQMhvQEy5smvtJuZGx3bO/UQ7ocpefPWHVz7oEUSCiqFrMdoIokjcT4OJSm8wV/dIDjOaFGCx/BfLwjp8GzxviBdtFSrIvfU4+RaCpWQp01tT5bkVBtm5HAZdlUjCOVZ6Jv8dzxLiSwm5Imk6GpWlEvW4NGdsAke7TXs/HJ0FbTFOWxTu7aA0GOPvpYnWMhf/XDLD81D6orVdnU5WCFUKNMbrwNBJRQNR1vaGv+N9JlfcdI1kuoMSDoQbBwwbxjtFOdj34uVKsrfTUM3eYIlASKpZkWkWhRLqTJqKibM14eyNFcJz9Dmtj6dvM0Hacso+oSFMG1JTPavxuB6dlfM77tjuiBVKht2xikp3ascd7Y6Yiv4MqhyBQf6SkVq20JNczeH7NqVQ4+EcADrPxRt5sW1h5bmNdoBvIZVPBY
 X8zCk/Ts
 03tU3Sujpxp6ATvuPDNgLigTngXh0Qxl+1PD8KX08WwEnBVuBPrBLrEsi+NvpWcJZKwGRoOqaigw2h+OjGYOOwXqlbWhlC43asjKZStZp4KOthkb16BPnjanvy2uSmJ+8ac5ce1CVBqvM/kdc0MN3Xu1+bG6FI4p0/8B4u4iY2lKEb+TRbupaqgvo23ew2lh3FNsjgDpVRBsDBhPMA2Pjj3Byu7AVzITNyLt7d2IkQj6HxwmQj3p+R20diU1Fg+E5DtML51upJgopBzzvvFTfSBWV4h4pLsLXTVUlE6+6l6uYxmBsoqv+DvS4IQ1CmOu3/qwBBt9AnquHBoEa1Rk565JQcSa4+EzYA0k4byylIEM6uTi9bh7RHr4plbQl4+vrjs3vRkwBoimUGjIQ1q5WylrwjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 2:12=E2=80=AFPM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Sat, May 16, 2026 at 1:40=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Wed, May 13, 2026 at 2:54=E2=80=AFAM T.J. Mercier <tjmercier@google.=
com> wrote:
> > >
> > > On Tue, May 12, 2026 at 3:14=E2=80=AFAM Christian K=C3=B6nig
> > > <christian.koenig@amd.com> wrote:
> > > >
> > > > On 5/12/26 11:10, Albert Esteve wrote:
> > > > > On embedded platforms a central process often allocates dma-buf
> > > > > memory on behalf of client applications. Without a way to
> > > > > attribute the charge to the requesting client's cgroup, the
> > > > > cost lands on the allocator, making per-cgroup memory limits
> > > > > ineffective for the actual consumers.
> > > > >
> > > > > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> > > > > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > > > > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > > > > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > > > > the mem_accounting module parameter enabled, the buffer is charge=
d
> > > > > to the allocator's own cgroup.
> > > > >
> > > > > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account=
 for
> > > > > system heap allocation in memcg") adds __GFP_ACCOUNT to system-he=
ap
> > > > > page allocations. Keeping __GFP_ACCOUNT would charge the same pag=
es
> > > > > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and ro=
ute
> > > > > all accounting through a single MEMCG_DMABUF path.
> > > > >
> > > > > Usage examples:
> > > > >
> > > > >   1. Central allocator charging to a client at allocation time.
> > > > >      The allocator knows the client's PID (e.g., from binder's
> > > > >      sender_pid) and uses pidfd to attribute the charge:
> > > > >
> > > > >        pid_t client_pid =3D txn->sender_pid;
> > > > >        int pidfd =3D pidfd_open(client_pid, 0);
> > > > >
> > > > >        struct dma_heap_allocation_data alloc =3D {
> > > > >            .len             =3D buffer_size,
> > > > >            .fd_flags        =3D O_RDWR | O_CLOEXEC,
> > > > >            .charge_pid_fd   =3D pidfd,
> > > > >        };
> > > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > > >        close(pidfd);
> > > > >        /* alloc.fd is now charged to client's cgroup */
> > > > >
> > > > >   2. Default allocation (no pidfd, mem_accounting=3D1).
> > > > >      When charge_pid_fd is not set and the mem_accounting module
> > > > >      parameter is enabled, the buffer is charged to the allocator=
's
> > > > >      own cgroup:
> > > > >
> > > > >        struct dma_heap_allocation_data alloc =3D {
> > > > >            .len      =3D buffer_size,
> > > > >            .fd_flags =3D O_RDWR | O_CLOEXEC,
> > > > >        };
> > > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > > >        /* charged to current process's cgroup */
> > > > >
> > > > > Current limitations:
> > > > >
> > > > >  - Single-owner model: a dma-buf carries one memcg charge regardl=
ess of
> > > > >    how many processes share it. Means only the first owner (and e=
xporter)
> > > > >    of the shared buffer bears the charge.
> > > > >  - Only memcg accounting supported. While this makes sense for sy=
stem
> > > > >    heap buffers, other heaps (e.g., CMA heaps) will require selec=
tively
> > > > >    charging also for the dmem controller.
> > > >
> > > > Well that doesn't looks soo bad, it at least seems to tackle the pr=
oblem at hand for Android and some of other embedded use cases.
> > >
> > > Yeah I think this might work. I know of 3 cases, and it trivially
> > > solves the first two. The third requires some work on our end to
> > > extend our userspace interfaces to include the pidfd but it seems
> > > doable. I'm checking with our graphics folks.
> > >
> > > 1) Direct allocation from user (e.g. app -> allocation ioctl on
> > > /dev/dma_heap/foo)
> > > No changes required to userspace. mem_accounting=3D1 charges the app.
> > >
> > > 2) Single hop remote allocation (e.g. app -> AHardwareBuffer_allocate
> > > -> gralloc)
> > > gralloc has the caller's pid as described in the commit message. Open
> > > a pidfd and pass it in the dma_heap_allocation_data.
> > >
> > > 3) Double hop remote allocation (e.g. app -> dequeueBuffer ->
> > > SurfaceFlinger -> gralloc)
> > > In this case gralloc knows SurfaceFlinger's pid, but not the app's. S=
o
> > > we need to add the app's pidfd to the SurfaceFlinger -> gralloc
> > > interface, or transfer the memcg charge from SurfaceFlinger to the ap=
p
> > > after the allocation.
> > > It'd be nice to avoid the charge transfer option entirely, but if we
> > > need it that doesn't seem so bad in this case because it's a bulk
> > > charge for the entire dmabuf rather than per-page. So the exporter
> > > doesn't need to get involved (we wouldn't need a new dma_buf_op) and
> > > we wouldn't have to worry about looping and locking for each page.
> > >
> >
> > Hi T.J.,
> >
> > Your description of the three different cases sounds very interesting.
> > It helps me understand how difficult it can be to correctly charge
> > dma-buf in the current user scenarios.
> >
> > I=E2=80=99m wondering where I can find Android userspace code that tran=
sfers
> > the PID of RPC callers. Do we have any existing sample code in Android
> > for this?
>
> Hi Barry,
>
> In Java android.os.Binder.getCallingPid() will provide it. Here

... let me try again

Here are some examples from the framework code:

https://cs.android.com/search?q=3DgetCallingPid%20f:ActivityManager&sq=3D&s=
s=3Dandroid%2Fplatform%2Fsuperproject

In native code we have AIBinder_getCallingPid and
android::IPCThreadState::self()->getCallingPid() (or
android::hardware::IPCThreadState::self()->getCallingPid() for HIDL)

https://cs.android.com/search?q=3DgetCallingPid%20l:cpp%20-f:prebuilt&ss=3D=
android%2Fplatform%2Fsuperproject

