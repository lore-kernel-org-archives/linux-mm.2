Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6B2CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC09E6B0005; Mon, 18 May 2026 18:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F636B0088; Mon, 18 May 2026 18:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85386B008C; Mon, 18 May 2026 18:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6EA96B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:43:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56E031C097C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:43:42 +0000 (UTC)
X-FDA: 84782019084.11.C050568
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 500C040007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:43:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTTN3vFX;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779144220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceEjnDoj+j7X2sHRJhcA+t9mc3xq9mU5ytWqyqRZdeU=;
	b=0lawGsOtjlnqa2JSBS7NTgmM856U5ApvlwMcdMRkUzydfqm1aOVfIaDc6P5HjMxDmD6/hn
	92m4yfStE5C1jO6bvN1MdmXr5To/H7Oa2Vf9zMo0xJyv8lqgdbk247Z3llI9bvVgpMCVEr
	telhGZl7dA7+hQH+AOSdcpx8lTyPeRg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTTN3vFX;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779144220; a=rsa-sha256;
	cv=none;
	b=ERGF3y4jy6q0lW/vHKVpoPMOxRkat9qcB9jyOf3EjAtwSZP3DwPTEFSUJa1T2YZlvX3MP3
	vkB/v9qXAoIe5VC9QSMK97sA0+ixbtR6QN+1K4gFT8beS8FM7YCUHFlqDb7S6qTbi6a2aR
	0jWQz1pC/8QMmS7FYjNa/pIiWRHwOOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA428445BD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF6CC2BCFF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779144218;
	bh=ZqxlUv6AphBiZDSxvrCBSCRC+/VdjzoWlIzND7rNfMs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nTTN3vFXwxkfBS/2diN6IbZTP+fnH/T8FI57XIZGAO3FwpjPhvbx8RkqrZbC8ZFny
	 w0CTYVupfTF1PxaWyksrncAABDZgMf0CsrWEZVJcONhx0u5eRQSHUJkzEAgUfxTlTc
	 TjcJu1uys5Rz/+NZlGn4OJMjLDyVvp2Bgid8g+MEj2FoR02tepl95QTjFwWDxfmbnU
	 iJlYDCPdbch72+TN2b/JFGuDSuckVFSTYqbjgXo+Fc/WDdFIpj4UDZEsy0DroMLdDd
	 WUNA1Mf58ShT5mhH7O13rSyfQeSo1ya9ZPgbrV5tATX4E9HRL35JIGM6VKgNHc8EzH
	 Mnkq9OHVwsW8Q==
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-628086439b6so2570552137.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 15:43:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8OVLkWooBlmMTKQ9mNMcDn+htKw+M4zXK/QnSjb7oup+NsRBMSUEHKtjYbG0rW8urR0TaNce0C3A==@kvack.org
X-Gm-Message-State: AOJu0Yy5SdRV1JXJSoEX+4n2vU8MqpNk1jt4FWT4xSKUF5/CkYBdJ72h
	bGUh7LQAmMGDWlCwQxNvDEKZ9YMsqFGbP1mRz1VrUqFvsa83msW6hnuE83LGQNePocS07BRYN3G
	J+prD0XKp2eWn/UiPDcwKbA21Yj1Zzjs=
X-Received: by 2002:a05:6102:1497:b0:632:eef7:4b7f with SMTP id
 ada2fe7eead31-63a3f38ed3dmr9090434137.22.1779144217888; Mon, 18 May 2026
 15:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <CAGsJ_4xfznffbjOaNKwnN6oZk_H6pqOzYqd1zx4Q9XrocdzV8A@mail.gmail.com> <CADSE00LjJcL8P5M-UPEpzZijU70uEmUirnin29N8YR5W5D-oFg@mail.gmail.com>
In-Reply-To: <CADSE00LjJcL8P5M-UPEpzZijU70uEmUirnin29N8YR5W5D-oFg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 19 May 2026 06:43:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
X-Gm-Features: AVHnY4KEVuNU5LGUxbEGufPnQvVfof22PSDgrj8C9uNhmMZb-wsisqSstH9JT8s
Message-ID: <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mptfdckgq5uaoxndg3top457pbgw65zd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 500C040007
X-Rspam-User: 
X-HE-Tag: 1779144220-977139
X-HE-Meta: U2FsdGVkX19FFFc6eo5y7vcJZhSTTK+E9khaMz5MobOtswiRtmetGX3H9yM/aia6fIJdKL+UNAwgIS+8vNIXW73NaKYbf6J4O2TFSlVh8SMp6InS+DOsqf6RHM+oHMaZHKMwWUhgyVuTNNQonKcwULSwp0zX3bhw0VBTyI0Mw3skQI1vuOL5U1viQq7rJuqMMywhvbEUFBVSgsBWIiANteHNb3ehF/4HDf+tyerteLmp3Ww6LscaS3y1RvVj6gq+ti4ls2Ep9ZSrDsdMOmYCi9olS4g9gaVnRieGFAo61ZjyizwbCYirXBYdA9b6P2aqmzl71nT2zTCsiRdSYsMIpYhe/XS6USqMcCLSxvl/ymB6Db63TldketnPeF/I+NkK6jbBuy1sFdoceYW2Hr11tjNdPZ8vRsj6tluovKpK1ejqM4QTseg0gWWLXOAKNfZ7mUcCH1VVBd3Ol/GpGI19jcfyKTPGmxf5dBIRQmMrvRoKxsbaP7B+YVzPSbDv5F2jsavT5Nt5DJSlkJ3SisicqoLWffNFiifcnzLxz83N/3TKZmlK/K/f9147YRPVjO2DRg/MzDnNhl7utr/7lw4Cd1ZzsQOVk81XmWK7x5VEm0mE7aCOjqOhwwwY4kS8yYM8eqyuAzKJSPar90Qji1YRp/h2nZ6q3hLqOFlOVIVt2Nhx31qRodTxa0ziYuVSHOZahTSnarer+WG1RPUqUI2eHsb9BOGr+NjUW260SKrzV2MM7BzTCKDTRHcwVCU3ajt4oOGaW1L6YV1czUSbOYs0WsAkU2HnF6mPahH2bj217pSWWWdMLCXpm8hghozdzZGOOEPLGUYJcY8LvFumql6dl7z5wQUfFKjjQ2EXEcRpvDHSkbcuVFqV/i2eP/6SsVr4oHLRqza6fzi6d6TAse/AAIwOUowO8/ksQSMUxzOVwTzyQWXIgQzNRMu+iGDjkPmJGk5hlfJAJxKpGWSTXDf
 AMQAHbhd
 sQW89hoNrKkTuGpUdnKLaW86llY7kTKmVXvjdw5OowvIcMjpflyFU7k38TDJJdePAROJUS38DXYTzl9mlSxLBkqWD/rWHNX17e4WBznPh+qg/XUHnvzmtu3HG+vt+pEdg2NaZVxCTTaAjsIOapI4iXcA1XJrPinK/xEIanT/oBpx5AsSpPLJ3FIzrQ1h6D/zG//x1X8USrR46IdAfzz5x9sJxaiwKWMbOCpK3PCFTjxSklq6Q5b0XhsSVvvMJGccXeXmyY1ape4M8iMEO13QoAuPJX+vkKInF08w077jFu5XqJ7LsyM528UvOQJHI0+++JK/rR+n6pPkE3RyEdxyoOj9DSLJ+jTkO1dZjU0x04PoxERt3VP6s6GsvZ13p9orQck+2wxwFPOA0p+LFNj3fyBcIQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:16=E2=80=AFPM Albert Esteve <aesteve@redhat.com> =
wrote:
>
> On Sat, May 16, 2026 at 9:37=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Tue, May 12, 2026 at 5:18=E2=80=AFPM Albert Esteve <aesteve@redhat.c=
om> wrote:
> > >
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
> > [...]
> >
> > > -               if (mem_accounting)
> > > -                       flags |=3D __GFP_ACCOUNT;
> >
> > Hi Albert,
> >
> > would it be better to move this and its description to patch 1? It
> > looks like patch 1 already introduces the double accounting changes,
> > and patch 2 is mainly just supporting remote charging.
>
> Hi Barry,
>
> Thanks for looking into this series! Yes, in my head I was trying to
> keep patch 1, which was taken from a previous, different series, and
> then diverge from it starting with patch 2. This would clarify the
> difference between the two. But I can see it just added some confusion
> (for example, patch 1 charges on dma_buf_export() and then it is moved
> to dma_heap_buffer_alloc() in patch 2). I will reorganize it better
> for the next version, including your suggestion.

Yep, I understand the situation now. I also understand
that you were referring to T.J.'s patch, which caused
some back-and-forth confusion for readers when reading
patches 1 and 2.

>
> >
> > Also, mem_accounting is only used by system_heap.c; has this patchset
> > also eliminated its need?
>
> No, mem_accounting is still handled in this patch for the general case
> where no `charge_pid_fd` is used. See dma_heap_buffer_alloc() code:
>
> +       if (memcg)
> +               css_get(&memcg->css);
> +       else if (mem_accounting)
> +               memcg =3D get_mem_cgroup_from_mm(current->mm);

I see. What feels a bit odd to me is that mem_accounting
could either be dropped (with unconditional charging), or
it should cover both remote and local charge cases.

I don=E2=80=99t have a strong opinion here=E2=80=94it just feels a bit
strange, since its description is quite generic for memcg:

"Enable cgroup-based memory accounting for dma-buf heap
allocations (default=3Dfalse)."

Best Regards
Barry

