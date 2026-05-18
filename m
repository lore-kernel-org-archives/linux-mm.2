Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE43CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD266B0093; Mon, 18 May 2026 19:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795076B0095; Mon, 18 May 2026 19:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684D06B0096; Mon, 18 May 2026 19:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 55A3C6B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:39:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDBA5A0B2B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:32 +0000 (UTC)
X-FDA: 84782159784.01.44C2B21
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBBE7C0003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PXTKYMKQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itOYKoJgfjMZD3HtReaYbMSuntrxVom1KXxY5d6gQNg=;
	b=MTprb+t8k/C0I6BRcP4hmntIAfpKDxZUXqQFup/DKGO/s7hYCsfJ+hcCE3Ln6L7FdqHw72
	SPahBQ9aQ5ZVleujnFvUyF9ZovCOWi8aAeGhTY+xB7a/mD/GoHQdzkOE3yFyP5T/m3Nyfh
	rdQBcjEE9RQKA8AzhURUBjl3cmwHL5E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147571; a=rsa-sha256;
	cv=pass;
	b=Gmw8kBfOytR4EMYrewxPWLuzdURrovB28NVTR1Ms6WJGQvay3Lak0e9mdjGxtOJbO7UaXk
	v02guacFp5NcteBkFRDjgaQkbMGsNhO+bkMzuLkRN19f63cfAynESsGW2fNsg9kqEOJtn7
	TdWT+DHScPdx5bUDEDNmr8DNpwOjYIc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PXTKYMKQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48d1c670255so595e9.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147569; cv=none;
        d=google.com; s=arc-20240605;
        b=ELCfNb/h92x/79R7aQR+iNF5U2sBQy/X58iR0pn5OUhm4QadbqIHck7D4hZeJRC+9I
         cKlZNU3gvhp6uqtiXhNPcu9U2bzVu7+lqvdwTzPEQMGCBpbWnUfKKQXRP+4rZu2k3BGt
         7x4ownR3/mkMNSg7Aib/ol/F13xxpJMy0g1Mg0D6i4MEUe71PW+/UVW9LlUSmf7PnYyk
         elvSn5OgvPhwKCOhu4ek+HMfW5y76IvP6JZkNlAXdrKWi4xTHYu5qbrvm3Ay29hoqvkG
         z9SJw3GMDzlcW5yDWLAl2J1Cz2kuAfZUZ0Gb1TXT6QZ4k4GCO/7p+6dRLghjmxeQQASi
         Ks3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=itOYKoJgfjMZD3HtReaYbMSuntrxVom1KXxY5d6gQNg=;
        fh=6oZzvclnErpiw9pkfSSNcjG3bKmKRGUQx7LonG1l7O8=;
        b=ToYPHm1co1WP4pUPgblYbRjmZccMIzMZcDpaNQoCn2jZ0m8VGUVQQTsfo1Quqx+7IG
         N7MHALqEERSBg+JrXeKgBpLygS/D2CMIB6MpmcuV9YbhoV0gUUkngTx/SmUS8H/tTlRN
         vhIbMygWZ60GRRKm9oP2GCAGVz/Y2t3ZsOVfWyAbevkQY0IbRJJHp1NB3YKDYI+pwM9+
         SKcq5vbhOqAsdO0bCqsfMKwuFkpaI9W1bDbJpF+8BZpiFGNPn6EUfymcXOT4SmQkxrGU
         FTCuT+a7NGn1fuaPCy56NvxpI3fIp4EeBFjv+iCvADef4ygf5R+6RVSmwmmuicP4hD2z
         YtlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147569; x=1779752369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itOYKoJgfjMZD3HtReaYbMSuntrxVom1KXxY5d6gQNg=;
        b=PXTKYMKQCuUIrDA3/aixYjdh67H2yAL6G7JCJYFr6lTUHckez3jur26AXwVBkZ0JC0
         /fM7DIkv0mNcoazW7B6hfhq5qhHzSOjFA70S+6OkzeewEUn9x/7sTW0bk/cgTulTOlMY
         ptAGqc6jb/IWTwtATWRC+cveWL+j8S5S5QMxyrvqCsfuEYJS5UdXzg8wBKqkVCz+pBFT
         Z4rvt8iRTnCOYUlT4SgiddVdVggYdiUZcOEQO4yHlFMNb3JH3Ql0ZbzRpR7EypLl/ete
         VzPC+rVBm1gphmL7xZ0ohBBY1hcmaizPoKunXRerWNtKswwxpJseOjLx4zMGpu99vznH
         uBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147569; x=1779752369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=itOYKoJgfjMZD3HtReaYbMSuntrxVom1KXxY5d6gQNg=;
        b=jumaEbM6dOEF1+ZJ2tR62yLeRT8OA2CNBJdB0x5iF55UqNOV4c+JCL4/FBX2cvrpna
         GArvJMZ+qkHLW0tcK74BbmO3hSS8iP0k0u6wcZtLYqeC1XkyY37o0KA6ou0vCEGbMTL7
         vLIsC/yS1rhvMmDlu4FHgw56rjfGQ3EVk9jfTbq4lUxIiGyXoUTdiFd9pPi/OumauuDB
         6CMbc2WdCiP6XAUqRSv7L2hMHKvYPP7UJ9xJ2UM2XfpJ6depCFvuOA2cj3HPAtrzVkCZ
         RIKYgZqrUK8a8lrXoubX4oPnXsKioC9CzPfj85QLq+N6D0Qws48fFQ463s7fQh7dqQBX
         IiKA==
X-Forwarded-Encrypted: i=1; AFNElJ++nxp2j8Y5h9fUWBazMbVdmSQ0ZFURwRqMV8sXN+6kIuuBnJuSsm9FymxqSJZRKmXp/cqt0PcJOg==@kvack.org
X-Gm-Message-State: AOJu0YyGZPTcnCLcQ4A8kT7LDuJPs03MGkekQzhtrQ+qYJ1my56fk+Io
	V8FzdxAj3MGCCN14zdVMFwLLk7qCugCsmfso/RexU7P9sfyFXPBlc75/Rg7A75zBsTjgS8HoXvs
	ECst3D6c4VUKUBU5TYvwS9IRotnvgP1bUnNGqhYF7
X-Gm-Gg: Acq92OGKrp2lDm/2AvXxNKB9nDqw19YBT7EKa4Q/rTIflkpIYw/h805iBpqfpKw0Vqi
	xMxGdpwIyxpt3bbd7kgg6s/+zs6mpTx4c4EXbORm1MMsOqznR4xrdd4t7IoF8KXCEO0NSGvY1bY
	vDZqwBTFU/QNrUmoKS3YPw68cJ9tWGAvkH7nfz5vPht4knR5kM/BotRaZHbGQZX05dzYrA6ebxj
	V6vPeEVc0OyHLtGTWWj7UHAYaNeBNYM1PWOYYkdXE1dyK8/lJmu1V5/dESgk7BlMaR6Nttx3iKe
	0Lzh/k75aoclZufNuoGcSNUL3OZ7yG1XssRWiY+fM4pNkP4m
X-Received: by 2002:a05:600c:828f:b0:485:1a54:9407 with SMTP id
 5b1f17b1804b1-48ffa06d607mr3320695e9.0.1779147569161; Mon, 18 May 2026
 16:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <CAGsJ_4xfznffbjOaNKwnN6oZk_H6pqOzYqd1zx4Q9XrocdzV8A@mail.gmail.com>
 <CADSE00LjJcL8P5M-UPEpzZijU70uEmUirnin29N8YR5W5D-oFg@mail.gmail.com> <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
In-Reply-To: <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 16:39:14 -0700
X-Gm-Features: AVHnY4JenMsTlW8PdrNyXvGhnvZE3E4HsfXXDBDrw2kB1e9N8h1WWqyjOLM9WZU
Message-ID: <CABdmKX2+PqZJc588dL7Yp7hYDnfXw7LRCKfLJ6n5=faKBvWBWg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Barry Song <baohua@kernel.org>
Cc: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBBE7C0003
X-Stat-Signature: 34geo11z5or8hiudxfd3ohtqg6xw6tok
X-Rspam-User: 
X-HE-Tag: 1779147570-347969
X-HE-Meta: U2FsdGVkX18oZsdUPnFXmglCg1UsDjsom4K3D1mT9m0KpLCjfBpK6v5zUe6dO4y6eY7nVC9Llu5v0mtZSBoMAnR+qNAvHNDqvpNCBmd86ck+1fEsqJzew+OfHPr7K9DXIL7sHA35V6ltAaJGD1C9hWwgGaZu5CiJGK7J2syfVV6fZACRklXFzLXLjJ63geNcNvEiuVxNjrbwmeTW+q5Oa7EV2XBCAy/VEIrC5JC5T+HazK+mfoL3u73HZBNe2o1G4kCRobeWxXPZrPwtwEBvrQ0DlJ6X46K8wO5h/rARREspXYWAVmB1XYidJB7dY/TJV/diB+UvuDnUlwlNlp+702rbTTM3DWTCr19U7r/MYrTuafG2PwnsD4bPxHB3/xP/x7Ds6izvhKkfZni3b9oitb4IJqT24rbSiV9rQl0B8+IFdZznvRAAglHGUobDbNrkoyPp+CT6bhQtUqoEBDmEom0yldZ1q8/JCxVfuMA7EuOEJMO2gZD6Dx7rHrXSAyn0q5uXVolc3s7oB2DIt7Ey7njK+E/vfDGByNw3ZTcpHIKuI3pSeQUqnDNYWTs63zgrPlZMGIigeG0upw1s4dAEujnIlqeWlYhahRMOqqvXQCF6knhgGAAg+G6Nt6kcGMHjCwCSrGx/iWvIrST+RNHljIK6TAH9XexEt9zS7i3Re0BmtRmfLNnkSv5VnRDFtiuClw1uXR4PVyDQ4JFJKLKY/tGOV9UCAJZANQ0PnkeQgclilJGTgljJpvXvQS0B2qu8ulNxLoXZvx1Tuvo6TFdveZ7IeZAJy4KXJncfc3gumOyjzt3oOP/lLztngIjbfs4gzZGUW0H2ublk7Ytx0qWXLUJPe7z3KF9iWvjBm9+CIhoTjIIvjrBHYb1hcD/KzoygBz9+c78MPpM2nlUITVLDhKcXJ2j+bsT+dQR5KDA46zKQeXXxI0Un9GOyPhZ3gRCHVqKS9mvhqoj2i7c5tI7
 zWWyHFYk
 KyMrjzMvH+zvn5s9l5axz5r8ZMeV9tmQ3t+fdZ3eA9Z9Rnb8sJB4Yk+l270eWc75nTO3CarBauCyWSNidnSDJtBxBhi55pUXtxdg272iu/+iaYdqWUViF+nJsv6GlupZH+Y/jm+jaIW8AMc3GsOF6PkqgGeqwKxpuptrpu+ddCw8wZ/HQ1ZMv9eyitsvraGQjm7XCJkd6c+3ypBEzCJOfxb027RXXUylnJ137zKBLKdTdW+zdYondt5XiLR1iusv/u1FCC5gz6yXQ+cc/8ecRdMsPTKYTHkpLKfb09dgAWX2pUQa1f1VHWWyDHglC36q6btlFg7fJCmK3emsYY7VCVUBKlrmMiWrRhOKLAjRzFG3WER0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 3:43=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Mon, May 18, 2026 at 8:16=E2=80=AFPM Albert Esteve <aesteve@redhat.com=
> wrote:
> >
> > On Sat, May 16, 2026 at 9:37=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> > >
> > > On Tue, May 12, 2026 at 5:18=E2=80=AFPM Albert Esteve <aesteve@redhat=
.com> wrote:
> > > >
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
> > > [...]
> > >
> > > > -               if (mem_accounting)
> > > > -                       flags |=3D __GFP_ACCOUNT;
> > >
> > > Hi Albert,
> > >
> > > would it be better to move this and its description to patch 1? It
> > > looks like patch 1 already introduces the double accounting changes,
> > > and patch 2 is mainly just supporting remote charging.
> >
> > Hi Barry,
> >
> > Thanks for looking into this series! Yes, in my head I was trying to
> > keep patch 1, which was taken from a previous, different series, and
> > then diverge from it starting with patch 2. This would clarify the
> > difference between the two. But I can see it just added some confusion
> > (for example, patch 1 charges on dma_buf_export() and then it is moved
> > to dma_heap_buffer_alloc() in patch 2). I will reorganize it better
> > for the next version, including your suggestion.
>
> Yep, I understand the situation now. I also understand
> that you were referring to T.J.'s patch, which caused
> some back-and-forth confusion for readers when reading
> patches 1 and 2.

Albert, please don't feel obligated to keep my patch intact if
integrating it into other patches simplifies the series.

> > > Also, mem_accounting is only used by system_heap.c; has this patchset
> > > also eliminated its need?
> >
> > No, mem_accounting is still handled in this patch for the general case
> > where no `charge_pid_fd` is used. See dma_heap_buffer_alloc() code:
> >
> > +       if (memcg)
> > +               css_get(&memcg->css);
> > +       else if (mem_accounting)
> > +               memcg =3D get_mem_cgroup_from_mm(current->mm);
>
> I see. What feels a bit odd to me is that mem_accounting
> could either be dropped (with unconditional charging), or
> it should cover both remote and local charge cases.
>
> I don=E2=80=99t have a strong opinion here=E2=80=94it just feels a bit
> strange, since its description is quite generic for memcg:
>
> "Enable cgroup-based memory accounting for dma-buf heap
> allocations (default=3Dfalse)."
>
> Best Regards
> Barry

