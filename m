Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA3E606D825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Rk3NA4/h
Received: by kanga.kvack.org (Postfix)
	id 5F1166B05B3; Fri,  6 Nov 2026 10:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1E76B05B4; Fri,  6 Nov 2026 10:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B79F6B05B5; Fri,  6 Nov 2026 10:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17E736B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:22:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68FDF160D87
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:22:00 +0000 (UTC)
X-FDA: 85405059600.30.89FE9B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0361B40015
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:21:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rk3NA4/h";
	spf=pass (imf17.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rxOFc+cZPr208SIBHT4IjzKUbYQTfkbGhsqB2LqDE4=;
	b=1TXE6f6RQ54VchqcNLhDq9wL1VNMav2yBqMirbI9zIn1sxJen8fx9tdHTKhoSCVQ+RNXiC
	oCrS++pL/6eA/i6VcVPFaZEKOporm9M78Npgqi8KKIJUZTkrT9cdb8uNQF5UbyHnl1oSsc
	efNjlAK11AOs5ZlsfdgNsuMGO5Ext+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978518;
	b=TaRxTADF9xu7efNgvrv4L3IUY84vZMthr66ZxFj31htGaoCuZ4E227hh867McEbsatg96o
	Qi3jeI6E2RKnEf4+fveAb+Q1a9AyJIywJfrdn+vba1bqy/YNPAWltIC3E36LXCOQjZsPhN
	da6iWWGXkx5dVYlnhZRHB7Aew4T8VTk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rk3NA4/h";
	spf=pass (imf17.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793978517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1rxOFc+cZPr208SIBHT4IjzKUbYQTfkbGhsqB2LqDE4=;
	b=Rk3NA4/heY1NOD1ZtAodRhwOGY0RgmwEXwLPxqrrpIvXf7PPr+9lmtBCSDupKv856LrUvg
	3wAxjIh9KoJbY9hFCSAgpgxqW2PuULDoAqIm7OSPgD6PUnoJSNhScMTdIUYt5gM4ODP69I
	7XqJqvWv4rfP6moZMtgTord8cPu0GJs=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-wZZr-AqAO627E4bVBCNFgg-1; Fri, 06 Nov 2026 10:21:54 -0500
X-MC-Unique: wZZr-AqAO627E4bVBCNFgg-1
X-Mimecast-MFC-AGG-ID: wZZr-AqAO627E4bVBCNFgg_1793978512
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-547ae874949so870221b6e.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 07:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793978512; x=1794583312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1rxOFc+cZPr208SIBHT4IjzKUbYQTfkbGhsqB2LqDE4=;
        b=wUH0fSxOzEvWz7YuztskDRkZ/C9ghHdscv1SvkkRZ/adUlsyhLpv7eqGTpP5iI0OZh
         xqCcl55aLyrkzlxk3c3aaeE57MRHWqR1q4CjO5+yLTIG/T02NQetHd5NmNTLIJg6npfk
         4wBE6oInGwQqDom80TpMn8lnPrw2/finZfmB8lQND1ZtJF5EBVHxs0nEvh6pc6O1rK5k
         JDSO4Z4o7XLlTNoHWjJ0iMqwRt0ztig40ZnpJU87VLg1mA79isNYsmNJmoSKHuujfI8U
         0aT4jWHZH8sv6sicBe8r7tF/C0RWVMxWaBNnfLwDR9YKR4qaw1aGogzEBfCdjZGayZQu
         sAag==
X-Forwarded-Encrypted: i=1; AKwUvBxoc5P14inOfqfecs+4nilAvLkS/QYC4biqu7+1Kk2XXQZ+sHRFyZ3JWKvd7jsRvMTmpetY/IgFXQ==@kvack.org
X-Gm-Message-State: APuU4Z/QG4L136BfwEIO4u4LSBiDfY+FICntjf54DDuvGySucUPF96tJ
	FE5MeMGlYgZ5YnZWPmT9jIURQ0Aoo8w/dziZWaz22piN0O0YfVQvWjp26H1U7OMPB02SKcnGWDS
	0luA+nj8V5eJgq95C7gM6CaF1IcnwtA3L6Fz9tqr+6bQunr/4vyitNQMTvyWXGqNNuSizVr1nyQ
	lDqxLcg6Fw/P9lALMnfzAHw1O3Mf8=
X-Gm-Gg: AYBFou1ZJfPBDb5dJhXvDnWdvPb3yGNDJc3izLgdC3HPSVQRD2xwBrdGjgTfil/K6Gh
	ClXiT1TGIGFg/j86fkFqzbyWAWNaJFr5VsURvJoRrsMRudc5euFcFye1cXZie7HEA+Xr0rhG7bA
	1kfo1qiNHZL51u7J0Tyeomvtfxyy4L4/JVsAgzLp28NZKR/lB+sHbkQsRA
X-Received: by 2002:a05:6808:181f:b0:4d7:17d5:6c9b with SMTP id 5614622812f47-567e098b040mr2230467b6e.9.1793978512051;
        Fri, 06 Nov 2026 07:21:52 -0800 (PST)
X-Received: by 2002:a05:6808:181f:b0:4d7:17d5:6c9b with SMTP id
 5614622812f47-567e098b040mr2230427b6e.9.1793978511464; Fri, 06 Nov 2026
 07:21:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com> <fb40349c-18d2-45d6-9278-8f20e1b8dc74@amd.com>
In-Reply-To: <fb40349c-18d2-45d6-9278-8f20e1b8dc74@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Fri, 6 Nov 2026 16:21:40 +0100
X-Gm-Features: AclHuK8xPUV12Kp92h3MGmY0EG1MyX4e69V4l27RPz6qll1dAX1c6CSJcZPwZjc
Message-ID: <CADSE00+NL-tyQVaTiS0Xdin7f-P_2c84P0qs-X66VqYze0-kGQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE
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
	Stephen Smalley <stephen.smalley.work@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SrDWDmOmgWTVgeeSVHccv2FzXmAkI3sAocRxQIYJXQg_1793978512
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: aug6mdhbwmqwkz5rrjw3mjjsf6f87da1
X-Rspamd-Queue-Id: 0361B40015
X-Rspam-User: 
X-HE-Tag: 1793978517-77350
X-HE-Meta: U2FsdGVkX1+W/EUBhKF5Io5uLQVS7YvOLEDKScudAhmSRB+oUtJeF3wcplWqIOJDlA8r1Snh1+cSt4kcoHS6dDuX7/MNb7dXT+wqu82mrgnVmTTvLrT5GJzW6Mmbm1/B4Xf1vbMRZJGjlnEkr9wDj8b80/rRo9yfwp744F1JP4Ztt5V4v26n65S9t/OITnN0tVerjG/BkbyGSlqtfJUSA05lTvNSaewMKfX3wBzBtLHhnnFHHZjRB2HxPuyX+7jdTJjywuLxN0StFygyPaUUH3GwmdCvugVhfgQM1rwjuWq+Hr/9P2WFQ4/7ntJNmHATYKDPRRWhdM7WYq2Z7fMO+Y6UDylMmSUdYDfYsH0Q59g4+UwQTu9FsBh9ZMw71zhd7XOc0ZtaQWRy4v9YQVLEodKP3t+ncWG+noVRrIXXwUX8/CkSyp68lbNmFRclp4gmnmGnu7ohRg80krHxN8ARyWoa++8g0BxdFGhUZzkxjUTntuQXOufNs03p7aruG5xHlOxUtNOEVWUBISpHvIpCbAIiwJXy3su7iGfA5fbezpxUR3Ipr6NvMG+hY08uT25Yk8lxEVYw9bxmjM6dbV+lLSQ+w9ieQD2Ss8m3AyvEa6FQ62qcEkeZdy8DTDNVRbJEG6d5Qdjxt2s/vje0vtUcnsV+jEcpY1pKjsij2YOxk6KvvgCYJyBVH9+R2JkP4yB6A0ij8TNEDpNLRQ79drirAGrJ79Y/sTVeLMRqCV7qPC6QeDHlxlwZo89enx+IqymxtwRUUr/xT6FZWE3JAxDNuZethZc4IIwxiPFTGSzNENDffJqUq7KNXL/U4rCVVXW8/kKvssyyvS7VaVYbwTHOxfRlXaAhk+7QZxmib70D8hNBTzrxaseXPuCqnRPPEBeP9+gBkLV0RYtNE2ZHrRg9v8yxbf5ijGOwZNsrid/G3hbp2sujsvab7FGoo/SVUoFGwM3T73iltP6EJCU9agH
 laoWwg2A
 hUSnclZ86sOLuzIC9Hz4MfgG4Lvz6q9j1ngCJXtXCsFR+mt3Ci+wyEEJoAiIwG6U2frhvDFx1hwRBlNFlqjaIX5pa6e5cr6trxxPxy6upG1+Iw+MfUyD8SoAL7CwHasD8DtayGA5SZ0iJvLn1ATsUIbTuRdfj/0TViSBFCVGM9C8qqAliUS1HKcNYwlY+0qrBXjatDcCXDBgdilrZYtEmpHBpeia+PV2iSgdlUjGXfR9E4TbaEDJZwmh2WXRw8Q188frb/RdLfpU/Ag6TFZLrDVh2pkzqMl6e+zUZT1zuUs4YZm2aHxd7wMDgl+0i2tGYUsxcvtSO76GQMN0IBvdWjEVJ+fm350tgy75Xg79nL4A2wUOXcnmO7HUhAEpHfgnJa+vo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 2:52=E2=80=AFPM Christian K=C3=B6nig <christian.koen=
ig@amd.com> wrote:
>
> On 11/4/26 12:09, Albert Esteve wrote:
> > dma-heap already supports charging a specific cgroup at allocation
> > time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> > originate from any exporter (DRM, V4L2, etc.), and the allocator may
> > not know the final owner at allocation time.
> >
> > Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> > to a different cgroup after allocation. The target is identified by
> > charge_fd, which may be a cgroupfd or a pidfd.
> >
> > The transfer charges the new cgroup before uncharging the old one,
> > preserving the original charge on failure. Concurrent transfers are
> > serialized by the dma-buf reservation lock, so lockdep covers the
> > locking order of the charge path early. The transfer implementation
> > is generic (mem_cgroup_transfer_charge) and not dma-buf specific, so
> > it can be reused by other subsystems.
> >
> > Not all dma-buf exporters back their buffers with reclaimable system
> > memory. Some represent device registers, VRAM, or carved-out pools
> > where size is not a meaningful memory cost. The xfer ioctl returns
> > -EOPNOTSUPP for buffers whose memcg is not set. Exporters opt in by
> > passing a memcg through dma_buf_export_info at export time. Currently
> > only the system heap sets it, other exporters can opt in as needed.
> >
> > Usage example:
> >   int cg_fd =3D open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECT=
ORY);
> >
> >   struct dma_buf_transfer_charge xfer =3D {
> >       .charge_fd =3D cg_fd,
> >   };
> >   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >   /* charge now on app1's cgroup */
> >   close(cg_fd);
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  drivers/dma-buf/dma-buf.c    | 42 ++++++++++++++++++++++++++++++++++++=
++++++
> >  include/linux/dma-buf.h      |  3 ++-
> >  include/linux/memcontrol.h   | 13 +++++++++++++
> >  include/uapi/linux/dma-buf.h | 26 ++++++++++++++++++++++++++
> >  mm/memcontrol.c              | 42 ++++++++++++++++++++++++++++++++++++=
++++++
> >  5 files changed, 125 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 837666273550..3bd26fbb1109 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_bu=
f *dmabuf,
> >  }
> >  #endif
> >
> > +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_char=
ge */
> > +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> > +                             const void __user *user_data)
> > +{
> > +     struct dma_buf_transfer_charge arg;
> > +     struct mem_cgroup *memcg;
> > +     unsigned int nr_pages =3D PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> > +     int ret =3D 0;
> > +
> > +     if (copy_from_user(&arg, user_data, sizeof(arg)))
> > +             return -EFAULT;
> > +
> > +     if (!IS_ENABLED(CONFIG_MEMCG))
> > +             return 0;
> > +
> > +     if (arg.flags !=3D 0)
> > +             return -EINVAL;
> > +
> > +     memcg =3D mem_cgroup_get_from_fd(arg.charge_fd);
> > +     if (IS_ERR(memcg))
> > +             return PTR_ERR(memcg);
> > +
> > +     dma_resv_lock(dmabuf->resv, NULL);
> > +
> > +     if (!dmabuf->memcg) {
> > +             ret =3D -EOPNOTSUPP;
> > +             goto out;
> > +     }
> > +
> > +     if (dmabuf->memcg !=3D memcg &&
> > +         !mem_cgroup_transfer_charge(&dmabuf->memcg, memcg, MEMCG_DMAB=
UF, nr_pages))
>
> Please move the calculation of nr_pages after taking the dma_resv_lock().
>
> We currently don't have anybody dynamically changing DMA-buf sizes but ju=
st to be on the save side.

Sounds like a good defensive option. I was also tempted to move it.
Will do for v5.

>
> With that done Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.co=
m>

Thanks!

BR,
Albert.

>
> Regards,
> Christian.
>
> > +             ret =3D -ENOMEM;
> > +
> > +out:
> > +     dma_resv_unlock(dmabuf->resv);
> > +     mem_cgroup_put(memcg);
> > +     return ret;
> > +}
> > +
> >  static long dma_buf_ioctl(struct file *file,
> >                         unsigned int cmd, unsigned long arg)
> >  {
> > @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> >               return dma_buf_import_sync_file(dmabuf, (const void __use=
r *)arg);
> >  #endif
> >
> > +     case DMA_BUF_IOCTL_XFER_CHARGE:
> > +             return dma_buf_xfer_charge(dmabuf, (const void __user *)a=
rg);
> > +
> >       default:
> >               return -ENOTTY;
> >       }
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index 85dd747c9b36..b01149d26b44 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -507,7 +507,8 @@ struct dma_buf_attachment {
> >   * @priv:    Attach private data of allocator to this buffer
> >   * @memcg:   memcg to charge for this buffer's memory. Set only for
> >   *           buffers backed by system memory where @size reflects the
> > - *           actual allocation in bytes.
> > + *           actual allocation in bytes. Enables charge transfer via
> > + *           DMA_BUF_IOCTL_XFER_CHARGE.
> >   *
> >   * This structure holds the information required to export the buffer.=
 Used
> >   * with dma_buf_export() only.
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index f8ec751b7d7b..af02d9777fe9 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -676,6 +676,11 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
> >  bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> >                              unsigned int nr_pages);
> >
> > +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> > +                             struct mem_cgroup *new_memcg,
> > +                             enum memcg_stat_item item,
> > +                             unsigned int nr_pages);
> > +
> >  void __mem_cgroup_uncharge(struct folio *folio);
> >
> >  /**
> > @@ -1197,6 +1202,14 @@ static inline void mem_cgroup_cancel_dmabuf(stru=
ct mem_cgroup *memcg,
> >  {
> >  }
> >
> > +static inline bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_=
memcg,
> > +                                           struct mem_cgroup *new_memc=
g,
> > +                                           enum memcg_stat_item item,
> > +                                           unsigned int nr_pages)
> > +{
> > +     return true;
> > +}
> > +
> >  static inline void mem_cgroup_uncharge(struct folio *folio)
> >  {
> >  }
> > diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.=
h
> > index e827c9d20c5d..0aaf2e7d593b 100644
> > --- a/include/uapi/linux/dma-buf.h
> > +++ b/include/uapi/linux/dma-buf.h
> > @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >       __s32 fd;
> >  };
> >
> > +/**
> > + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> > + *
> > + * Any holder of a dma-buf file descriptor can perform a
> > + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> > + * cost to a specific cgroup, or move it from one cgroup to
> > + * another.  The ioctl charges the new cgroup before uncharging
> > + * the old one atomically.  On failure the original charge is
> > + * preserved.  If the buffer has no existing memcg charge, the
> > + * ioctl returns -EOPNOTSUPP.
> > + */
> > +struct dma_buf_transfer_charge {
> > +     /** @flags: Reserved, must be zero */
> > +     __u32 flags; /* unused for now */
> > +     /**
> > +      * @charge_fd: File descriptor identifying the target cgroup.
> > +      *
> > +      * May be either a pidfd, in which case the charge moves to the
> > +      * memory cgroup of the referenced process, or a cgroupfd obtaine=
d
> > +      * by opening a cgroup v2 directory, in which case the charge mov=
es
> > +      * directly to that cgroup's memory controller.
> > +      */
> > +     __u32 charge_fd;
> > +};
> > +
> >  #define DMA_BUF_BASE         'b'
> >  #define DMA_BUF_IOCTL_SYNC   _IOW(DMA_BUF_BASE, 0, struct dma_buf_sync=
)
> >
> > @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >  #define DMA_BUF_SET_NAME_B   _IOW(DMA_BUF_BASE, 1, __u64)
> >  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE       _IOWR(DMA_BUF_BASE, 2, st=
ruct dma_buf_export_sync_file)
> >  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE       _IOW(DMA_BUF_BASE, 3, str=
uct dma_buf_import_sync_file)
> > +#define DMA_BUF_IOCTL_XFER_CHARGE    _IOW(DMA_BUF_BASE, 4, struct dma_=
buf_transfer_charge)
> >
> >  #endif
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17fdefc56b97..3e717b5663c8 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5752,6 +5752,48 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup =
*memcg, unsigned int nr_pages)
> >  }
> >  EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> >
> > +/**
> > + * mem_cgroup_transfer_charge - move a charge between memcgs
> > + * @ptr_memcg: pointer to the memcg to transfer from
> > + * @new_memcg: target memcg; caller must hold a reference
> > + * @item: stat counter to adjust
> > + * @nr_pages: number of pages to transfer
> > + *
> > + * Transfers @nr_pages of charge from *@ptr_memcg to @new_memcg and, o=
n
> > + * success, stores @new_memcg in *@ptr_memcg.
> > + *
> > + * Updates to *@ptr_memcg must be serialized by the caller.
> > + * Returns %true on success, %false if the charge against @new_memcg
> > + * failed.
> > + */
> > +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> > +                             struct mem_cgroup *new_memcg,
> > +                             enum memcg_stat_item item,
> > +                             unsigned int nr_pages)
> > +{
> > +     struct mem_cgroup *old_memcg =3D *ptr_memcg;
> > +
> > +     if (!new_memcg || mem_cgroup_disabled())
> > +             return true;
> > +
> > +     if (try_charge(new_memcg, GFP_KERNEL, nr_pages))
> > +             return false;
> > +
> > +     mod_memcg_state(new_memcg, item, nr_pages);
> > +     css_get(&new_memcg->css);
> > +     *ptr_memcg =3D new_memcg;
> > +
> > +     if (old_memcg) {
> > +             /* Uncharge old cgroup */
> > +             mod_memcg_state(old_memcg, item, -nr_pages);
> > +             if (!mem_cgroup_is_root(old_memcg))
> > +                     refill_stock(old_memcg, nr_pages);
> > +             mem_cgroup_put(old_memcg);
> > +     }
> > +
> > +     return true;
> > +}
> > +
> >  /**
> >   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >   * @dmabuf: buffer to uncharge
> >
>


