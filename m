Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40DB606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UtOFRBsC
Received: by kanga.kvack.org (Postfix)
	id C92956B0A6D; Wed, 25 Nov 2026 11:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43A36B0A6F; Wed, 25 Nov 2026 11:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B321A6B0A70; Wed, 25 Nov 2026 11:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89F686B0A6D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:14:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C0DC1A0ECF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:14:19 +0000 (UTC)
X-FDA: 85474138638.25.30F3ECA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA4381C0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:14:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtOFRBsC;
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795623257;
	b=HrwQrHaUhx3/ds4PSrFbQ2GmIVXV/Z8sVgzubMjvehlZbSyxvo2nBb/pJGkpMvPAPrDZZ0
	+3rYHcK4uyh9VZ2QeONtnt1BdxhZZsOvAT3ovrlXjuK/joQ78KQ+a/1RcsfSVrKh/iZx/D
	iMTm7sKdXAWcpC5iIgC2e01K32R4TQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdER2mkFO0wbjr2+rc/aRUmp4/Sc5QyLtaG22Ye9JSE=;
	b=BVns2YeFx3QxOBlLKpfKwFzF8Ti3ATBR7ZAPbj47Ca9zmy9LC2FIgtN3VPyZeJKN72tm/5
	AhXfPDs9IYB2R12fUpoEfR9XwHZt+3Jd2IneRH9TzaDu6VSHEtd8rYzQ8qpahqnwuP2lCQ
	N32gGlZEJJ5ATQl6OI1H9rytTmkVjAo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtOFRBsC;
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795623256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdER2mkFO0wbjr2+rc/aRUmp4/Sc5QyLtaG22Ye9JSE=;
	b=UtOFRBsCKAK3E8Bsu3A8rziiu4/aqAhE/qioSN+enl9xu6asu7MYmZxBpWnwgM6JAJ10eH
	GeuaMt0x+rQF7dmkSzy8byorSs4CqhqwSkdzDKJ4NU36OhlMRXg42v6WqTsD7ri9JlJGwU
	zmrSWBx/pnkzJtxscC6RhgstvSiYf98=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-VSs_GyTwPhO7JFHqdApumA-1; Wed, 25 Nov 2026 16:14:14 +0000
X-MC-Unique: VSs_GyTwPhO7JFHqdApumA-1
X-Mimecast-MFC-AGG-ID: VSs_GyTwPhO7JFHqdApumA_1795623253
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-492f39f29c4so6266123fac.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:14:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795623253; x=1796228053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LdER2mkFO0wbjr2+rc/aRUmp4/Sc5QyLtaG22Ye9JSE=;
        b=mdCDTg8I2oDtPXv5Go70I/2ns4OMvltUX52MEBTvW5jU2FtlJrNAQKdXRlKAeAZfEd
         so8OeEh/zJRecrdk5dC+65CmI2oZ10ytb7kmevQc+iJwf3aga5Py4XMkJjKibHpycVgI
         UfhEfSAHOmua1gCuyy4a/zNC+N4DYSvWryfjJBj0PYh+yhVTeyOoFsgBpY3amFlCzoxB
         6wBfKpPc+oaqN9csXBauGNBg2V3a3H1VqGezP6LcqHnkOimsDGuETbtWCrosR0zhZ2qz
         AyDRdHUVW3HITLgdyATOrv2njHon6ixFp15oFzQt3aKJ6OJyDsciw9GMrli0a5aFxewU
         Aoxw==
X-Forwarded-Encrypted: i=1; AL+hErHOUXu+bSP8N8qKsKxRRDqurA/W/DJxv1smnRFg9bsnolRxxDKE8DmNUf3ZFuVEiWZ5eGS8g+3QFg==@kvack.org
X-Gm-Message-State: APuU4Z/m8aZgkjDloc6CCRsqkf7lcHZnsWrHbIk0I2IU8XxBVmEmOHR2
	6FHTc5dKVl3ipE42kXkyy9mXu/Q0e2pPg76rcxStZe/sKDhV9q6tV7cfI0JR/9BYbTopWXhEnJI
	Myj6G+bhrlMoPg/9xZN8JZRgSw8KpsD/yfRQAWFmMGWXPqyqaHK7pdtsBY8F3OJWPY8N73cKWrs
	t4Rv26BT5HB0LMBT+QKrWJnVoU8Sc=
X-Gm-Gg: AZFdTZeem5c6xOrVDtQSofbQdLGFd2OF9WD9SSfETnzm6B95cpB9AsrDTEWyeVNI8TG
	1/fzjXnCoJHDYvhnawdFBUMX6T35a+3cOriMc/OJewaOLzCaWrq4eFQBg818i23lU+BTS3HZUp7
	MaV9RbFxQSOdrrTCR3dAa7x/gqXOCm2GXf6jjU0armx2Kw/ZSlMHyXZHzf
X-Received: by 2002:a05:6808:c3cb:b0:577:2888:47b3 with SMTP id 5614622812f47-57a0ac33d63mr20058857b6e.44.1795623253378;
        Wed, 25 Nov 2026 08:14:13 -0800 (PST)
X-Received: by 2002:a05:6808:c3cb:b0:577:2888:47b3 with SMTP id
 5614622812f47-57a0ac33d63mr20058815b6e.44.1795623252854; Wed, 25 Nov 2026
 08:14:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-2-dce12fa03ad6@redhat.com> <sashiko-outbox-233444@kernel.org>
In-Reply-To: <sashiko-outbox-233444@kernel.org>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 25 Nov 2026 17:13:58 +0100
X-Gm-Features: Aa3M54qC4BhV46Zvi5xNNVUyWvQwOqnECHDuj67-iKiUZ4P0AUQ6JhGMrN001Kw
Message-ID: <CADSE00KEAYZ+saAoTY81VNhNyevsWFD_nSDNgsPVfvvLBsE5vQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] dma-heap: charge dma-buf memory via explicit memcg
To: sashiko-reviews@lists.linux.dev
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
	Stephen Smalley <stephen.smalley.work@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org, media-ci@linuxtv.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3THFiGd-3ZF_QkEpul2z1atpdTIbTR5mpZCRTjf_mgA_1795623253
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA4381C0005
X-Stat-Signature: n1d5afc11ffsce4yooq6sc5yy3xmqypy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795623256-920300
X-HE-Meta: U2FsdGVkX18JXN0elhgl+b5zHv71IwP6wzNRZUi5FDNshNx3+4UqUezRgy5WssxHKX3DTjrtixrKKZL3VpqPanvHT5E44JSFYpKYn4lpflPk3Q+8z/l1d550/Afx15SqMgl60ATHrYt+g9xb/q/liEWFykh9PDXZgEtyrddg5HofKNkjvVqs28jcf83D3elEFcpnoePD11JihX9GKo5I0ImPJJoKiMeGLt5o3vwFTVCqqXkZ4jbFMXksVXSe6wry33sv3Gl5weexFsv7K2ziyneewgGRRGADxQnl31Zd6PxSHxTU+oyrqOK0yEMpO0c91N8jg5JiZlFPK5ggDqi8RMoBOK5PjiFTlErMLgzihaHopRgbVXd/6OK7hKSebfWHh5gHeIMK4iezBSEfbSp/RL7iriq52JFduV/WDJTFp9IMJFK/tt36KzeDGLDCEODfDqsPpnYVbZISeWJb9Np5m57N5IWRCqx5UWO4Ba0jDreod0xtEqJdHhGRKaaX030U/SIsSNueoPZAoKPfQDDN2rUYj1TLJf4wzlmWYZdYH3qcCqgmFUKwQynjaiGNLh6SQr0DEzdNALE/HJn8qIX+BooyuMI0IlA7przMdj+phqNWitCjblILXDOz6D47fluoMWJ5aqPV1NrQAM8H/XxyDIb2WY/P0wF5FSITFOg8ScwSat8BfSCc6gkl7s+FjQwbgplbk0b2e3X/VjLNzgWzSNY6lZP9wWFsBxlzt1bLkftlBg6DvNOQUfkevH/1QRaun/ZPuZbS9A2GDMbolpWTdIGDYn3SyQ39O5hIVQeLnoqr0+VIlEAn1GzY4GTStDWBJvhaHipuX+tYNBsih9G8fEUsZqJBWJRf7PAXx+vh0Hk5KhLez0fppbUZBhf/ovZUgyfgR6Z/0qoUH/WPrtCNr0rQ4R9KgXXgn2RzxPxxEYf8vo9doI5WGpNXPG5VLwexK7TJtR0zIqWrWuKkccC
 2rbRqvUx
 fixp8g68m3fg4zl0womf5f4vp8VnhWrUw62rKolxVmcEx0a7BfNBFkndZRERyzAUecwVKzGogKD9tYSWxmKoC/N5ZESeK7qGi+CjPdxj3L/5bHuKLPKyn4OUX6RNzUMx2Z4wgR4iuBhB/qrCT9gnHg6RioUdR3XofS0xlR5PX8DCetncRSnSKVw7NV/MUaqn0z0ktH3dKn/9K0XyTLeLsiwBJrqP9/qkmDPpHi1AlI3nG0iSYXEvn1txTYNFocUhysmSvdK5sATH5pP3MHBbPPuZooxq/WRVs7kSXfkruGi1aoLS9C/17Mp0YpTIdalGXPqpq+CWlc40+JRVFSQKzeDUJfpVE53feTf5nv8eAB/1gh+wLvkzaF2jVH6NI5yjv+wAgABU+KfqA/XH2cCga9cnxMFZ2R0GOvdE1D9ea68wHPhkFuvCfdBOFYM6FhcduTUcKjfqdrgaqpUPM8ac5wKCNwv4gUyjZdXhsa5Ffc7cLKOLIlUjbVIW6A6Xndq4Zlyabsjn7spKx1JPSdLbgCFshv1oqDWmg1L5VbZD0j1+JXE0sJ0ZAAp+bm8GpM06Z04kzEIByYbllSo3bkYyq7vEd6htHB9+UXzFZxD48N3eVj4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 2:05=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm: memcontrol: task_css() race with migration in
>   get_obj_cgroup_from_fd()
> --
>
> commit 62e5304eba9bb9d84f6229eddf1a9273649483b8
> Author: Albert Esteve <aesteve@redhat.com>
>
> dma-heap: charge dma-buf memory via explicit memcg
>
> This commit adds a charge_fd field to struct dma_heap_allocation_data so
> DMA_HEAP_IOCTL_ALLOC can resolve a target cgroupfd or pidfd via
> get_obj_cgroup_from_fd() and charge system heap allocations to that
> cgroup.
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e4a9af2fdaa3b..7826bc21bea9e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> [ ... ]
> > @@ -3171,6 +3172,88 @@ struct obj_cgroup *get_obj_cgroup_from_folio(con=
st struct folio *folio)
> >       return objcg;
> >  }
> >
> [ ... ]
> > +struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
> > +{
> > +     struct cgroup_subsys_state *css;
> > +     struct obj_cgroup *objcg;
> > +     struct mem_cgroup *memcg;
> > +     struct task_struct *task;
> > +     unsigned int pidfd_flags;
> > +
> > +     if (mem_cgroup_disabled())
> > +             return ERR_PTR(-EOPNOTSUPP);
> > +
> > +     CLASS(fd_raw, f)(fd);
> > +     if (fd_empty(f))
> > +             return ERR_PTR(-EBADF);
> > +
> > +     css =3D css_tryget_online_from_dir(fd_file(f)->f_path.dentry,
> > +                                      &memory_cgrp_subsys);
> > +     if (!IS_ERR(css) && !cgroup_on_dfl(css->cgroup)) {
> > +             css_put(css);
> > +             css =3D ERR_PTR(-EBADF);
> > +     }
> > +
> > +     if (IS_ERR(css)) {
> > +             if (PTR_ERR(css) !=3D -EBADF)
> > +                     return ERR_CAST(css);
> > +
> > +             /* fd is a pidfd */
> > +             task =3D pidfd_get_task(fd, &pidfd_flags);
> > +             if (IS_ERR(task))
> > +                     return ERR_CAST(task);
> > +
> > +             rcu_read_lock();
> > +             css =3D task_css(task, memory_cgrp_id);
> > +             put_task_struct(task);
> > +             if (!css || !css_tryget_online(css)) {
> > +                     rcu_read_unlock();
> > +                     return ERR_PTR(-ENOENT);
> > +             }
> > +             rcu_read_unlock();
> > +     }
>
> [Severity: Low]
> Can the pidfd lookup in get_obj_cgroup_from_fd() spuriously fail with
> -ENOENT when the target task is concurrently migrated or has an exited
> thread-group leader?
>
> Between task_css() and css_tryget_online(), the task can be migrated to
> another cgroup and its previous cgroup offlined, causing the one-shot
> css_tryget_online() on the stale css to fail.  Also, pidfd_get_task() on
> a process pidfd returns the thread-group leader, which in a
> multi-threaded process may already have PF_EXITING set and remain
> attached to an offline css even while its obj_cgroup has been reparented
> to an online ancestor that get_obj_cgroup_from_memcg() walks up to:
>
> include/linux/cgroup.h:task_get_css() {
>         rcu_read_lock();
>         while (true) {
>                 css =3D task_css(task, subsys_id);
>                 /*
>                  * Can't use css_tryget_online() here.  A task which has
>                  * PF_EXITING set may stay associated with an offline css=
.
>                  * If such task calls this function, css_tryget_online()
>                  * will keep failing.
>                  */
>                 if (likely(css_tryget(css)))
>                         break;
>                 cpu_relax();
>         }
>         rcu_read_unlock();
>         return css;
> }

Valid. I will apply this for the next version.

>
> Using task_get_css(task, memory_cgrp_id) before put_task_struct(task)
> would avoid both failure modes.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-v2_20230=
123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com?part=3D2
>


