Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919471091911
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25B06B057D; Thu, 19 Mar 2026 15:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6B36B057E; Thu, 19 Mar 2026 15:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5336B057F; Thu, 19 Mar 2026 15:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEAE26B057D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:26:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C80716072D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:26:27 +0000 (UTC)
X-FDA: 84563794014.16.B76E12F
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62574140005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:26:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cD2myvLb;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773948385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STbYRptw5mPVfwcJPai4/18g1DT8t9j5hz3bTmCzNvY=;
	b=IuO8ofCgA18kWS/eKFXulxxpJsdF8BrS6iopRBnIIQbFmbkxI8mnSa8OO2ZKrmtssRBJy+
	hj+5UBaCNyGhFJ7Me0JYZS475GlAGaT03zisC2qVWxuHIEyc0KaJ9bl7Ihy4dBVuTavHj2
	Ow2Hih/yCyzskhVzcFXJN0RkJYj+1CA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cD2myvLb;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773948385; a=rsa-sha256;
	cv=pass;
	b=ZqdvAOvsWii0D7muHKHr1ix4x3HB4jdg8jg7Q/vvS2ogNZ7h7ifmif74Rq69On7KLK07sk
	2Ysiw6vm8rrqjcFc1uQGXiHf97XbybFNJOegiYBVI1LkZX11DCeMbI1tVgDGsR8LeOWq/A
	Ah9gLBlUm+/DNagJ5Jfy/Eq4Q1v3ITA=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b45bb7548so875241f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773948384; cv=none;
        d=google.com; s=arc-20240605;
        b=hdyChiCAkti9DUPzDEWvBqQm1fjQdOlVK4kzqQ7Jej+PRNhxXYr5okjzXUQWEeQBpu
         S+sxd6jmusjPjCb1388+ZRtutNUJX53DQjkJ2XSuDfiz80lk9+pZVukKMCORBKeTkAy1
         Jj00/x10hCwh4eQMnG546fF/5nkHq5IgCavvAUqT4hZmBJ3WLHIwMHKWwNamA876exIe
         1niypBJKN7FcomeOKRMGKDbntWECrF7RXs67QpwxhgidKMdfzYuB2abPqamtwIXkGeIA
         PTcu2VFzLVWeRHJJjX9tvHVXagfMqZVh5yvYjr91uu4lvQTDkSUf3PqXKANtMPAOvEdh
         kH0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=STbYRptw5mPVfwcJPai4/18g1DT8t9j5hz3bTmCzNvY=;
        fh=BLjMLDqkt73RCLfV3dS8X/zVnzlfMW6TMyWWPf0DtTs=;
        b=N7EJh62jI/vhEcUffiTS/kYeeK+2ddm1c6yNpK+THFIQs7nHkvRL7mIHpiyUOMlxmg
         7ehcBII262f+oY7dZEBUjStYszqvtimygzCKDC1BHIWYeQIi5DL6CMRsYlBA3Yr86lOt
         l5lr3PBVJ8bD4RdPU/uSnwm+u2z1CIsTL6QcWAw41DXn7GO91X1KIo2cveQIj9GXu0u/
         dXHP5G3BrizhqD+gKBFMqqIb8ofyp/K7fZdSnKaOkYpjt3x/L4wxmr5VUQ2K4k6/g5kc
         RbQsQRVD3PnqSVP7/xkZsqYpnDI12HGB/dZ7JYeQgJhTGVcSqT2C6bLrV5QUShuKDbmY
         N0xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773948384; x=1774553184; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STbYRptw5mPVfwcJPai4/18g1DT8t9j5hz3bTmCzNvY=;
        b=cD2myvLbhmXCBRGaf/GVQtjyD0xtctj3q0iSbr0NaAniHYmPrKp2XqWK32xYHkRx2Q
         Gc/qAPI6LT0UOI9fVpf9xI01GYO9EaeKDGSym+D/mwCg4pyxjckFK5qKr1m5WE/7qo/n
         cDDKhTreXz9X1ASRxT8sdK7WTJ3nw+Y3KPmpLKn95vYH2q2+hHXZxk/KCsOW4LYWbYL9
         6DuFMgIaSzFMIyCd6ZxfkEpOybgHCxzsvQXbWRG0Rb3JPZZRviYBmU6e6dgQKCUFgDUk
         q2cQHroxBoSDFOEBMNK2WFrlUYJjTUcw4DLQZFczOOlVWIibtqSS9hX21avfxar8XvkF
         u11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773948384; x=1774553184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=STbYRptw5mPVfwcJPai4/18g1DT8t9j5hz3bTmCzNvY=;
        b=Dok2Z+BUo0Kasvtcke0IHa4Vzduvfi66u5MjreQTkyIY++DAjR1D18p6g4oD//K5h3
         SSTyQHB2ytyzeT/SyjmPBhVqQb++Li6d1web+37yd7CGPsVtveg82IyGdkxAlZwuT2pI
         VomMtLCul7Uv6BEmhFpIQ1PZ95zIXC3QGm0Xz+Rgzj5Z+9e+6buj7iHUuJkUVokIHm/n
         7D6byGIMxdHDrpYP8vaWJavGmuddamycKg0Kfde99z9/791s3/8+8t5zvxXGYwyS7vwL
         y9L1c2qAwT+bePZB11sxxcLdzMRaqArozXUTwVp21gSa0+my0N+l/FLzf6vNQg7Q0IdK
         oXGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4tniqB/E5czyDMaobSs79yKgDHXiBmOrNXyzYok0rEQ93Caa+KraK0ttdsI1HuWZPaJZd3xlEjA==@kvack.org
X-Gm-Message-State: AOJu0YyE6vK2hozsAfiM1BAwN0QuM8GmsL7NVACuvfl1sa6hfD7/9SAZ
	1xw8BZEwvsqSW+CxvNHiSW+3FtQD9l2mBCsp+hoR9h7OIhR3eywG5Uo7AcFt7+m/je1wdlyCak9
	QQoqyoVuyzuHDxQe1eRZR/8b/ryedHLs=
X-Gm-Gg: ATEYQzxkCPgPMQLPD2/Jr93YuhqjSIPeOcDCChmIN/GpXKuBy+5mYTFH+UDaZbHcNOn
	w2UP3Ct0xZDjAmEitsV1BpQ8PkRFHpFcsHxqWTRknNj4n25Wm/xR8PT/w+PaLHtE1QJmajqekGC
	a12/4JZkcvD9z2Gt4pNVLmxCfqKZp4QNr+uM4hg+YCYkafIv1RNDQaZE4YJyMC3HJ6PCNO/NtsU
	+bfiL0OMZFoIk3IzGq/X1FFOsBaBFKdJFWJW+cLsH15oQsNEmGC4Uer+J06GzOXupsxb/+sJEl6
	W7R8v4X6cH9mXdYgz+RrMZLDQVODtf2ogPhvHEOQNOGcckQEtw==
X-Received: by 2002:a5d:590e:0:b0:43b:4352:1bd8 with SMTP id
 ffacd0b85a97d-43b6428ba33mr631337f8f.53.1773948383714; Thu, 19 Mar 2026
 12:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com> <20260318222953.441758-10-nphamcs@gmail.com>
 <20260319075621.GR3738010@noisy.programming.kicks-ass.net> <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com>
In-Reply-To: <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Mar 2026 12:26:11 -0700
X-Gm-Features: AaiRm529wWFONjiD2biQuzKZu-r4Xpu1F03-qQuQMU-V-fDEyZaMmWMBQx2xjec
Message-ID: <CAKEwX=Mp3=E_nVhFFvdyKWjHtdp6TB=edp9-x4OajZp6MPRwrA@mail.gmail.com>
Subject: Re: [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each
 swapped out page
To: Peter Zijlstra <peterz@infradead.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 62574140005
X-Rspamd-Server: rspam07
X-Stat-Signature: kudo8pt773y6kyo76sh3w1nmu4e89c1j
X-Rspam-User: 
X-HE-Tag: 1773948385-276602
X-HE-Meta: U2FsdGVkX18ult5P9P42JJM/DgbBeJwJrQQS0tj+lzM63WSFJ7NlfXfCzu3HAvQ5PdhSzQ7DcMY1+qj2iyFwykieLDNlkaJsYLZUpKvP/7gQhT9hWfYBeRlhGyj4TdonLd4vtWreEHHwYJPy3dFiA0KpzD82D7R0h1yHtBhRsUdDF5XXk1+ypZoPN80sjV7n98QE+2YAAV7RqGpbLAV7yrtj01OwIuCXlQehLBAtO5q+1SKgmdL/xCFeWbQL79AXWbX6imBm60jw8hMyHflubzwraaRtrRPtD9VBwNWvOiCfBP5Thp1toE9eT4K9nW3Ffkv06NaZh3gOk+3TpsmHUFh1YE4hxZqUKTuTlxMo2GuziQiBN/NCgf5md9Bc6o9IGaDI+H7JVeUZN0a45efEuT+97Cnl8lSLhibdsuaFuR9wEdF9I7EZCmVDvpSzaxACqZM1xOZW7++1pvTT845eTbUJ5aHlMsSFFqlMQRiyAxqbjpdNdqXLk0iSOC1GJFUeEBUbTHaDl+eOMupw4iEJGtqtyT4ijHyy38JhoyU0/ouOfsFe8KJj0MHW6nNHdrJZLA70cSiOg2R1Us5JeiOT7yn4Ogv72bLfDluouaiS2gYVHFLrqaXSw0CK8r2W5ln/TcRPlNhg4g+5dilSuM1IQM4cMjHTXXj0akOVg3rOJfOeI+VnQV4Sw5MaDoDMQqq4td4KuogAGDqoJVOwF0mHrjP4AdM0qeGrLtqhHhpB4QM9R9pS/Er85znVjlscsJWfwoJFs3FJTsZIlbdMa1p0bp2S8ZAAEcRKTzo3k4038KFydASXEuwlaRsWeHoN8mRIgI3czruLExKSEhBO6bYO8987QXxiMG32r+EPfCicWIbobGrnuqEqstWZiYrAyO/xjXhHZTRvtKYIYN9g7XIv1pSZnNbtzql5CkTFOt7LbE65GRsF2Gyu07570UCfObzl+TsLEyYXVLjA6GnHqDr
 OKjCsL5t
 uCnkbnqUimMqdwND3uG/0T6kEoNEXnJxyAyOHskzJjnTrwY0bGS4xE0G8rsGE12NnjzXzTSlfyBB/SF2nnQ0IvcMDEPOgoeLafM1WD9VMWXHEGhrwBuyZfhpBY59Cg+R8nN/JpIhw4EpbYVT8Tply7Mcwd0iXzg5SHOsIW/pNzatYesOn+7XO6mfHGmTcaeBm8RzRSgddwpqimEfRu+ewyaax8SVBi21+ewxYXW/Y4bI/zQ/rcXgW86ASNlOZIVE/FZZp7u3R1d0s7wZeLCjJY2283Pb91jGJbfXiQjXHQNf36q6R1RMvr0vIK9VG4Owu4NDx5kOnWS3Y/WrP2Lbbiz7s+f08ueBi/i6/mNYPmm6WTmPnZ74cjCyTO3OzyoD8GSP9rAA5se4+74ahioArO/CFim1wo5mQQWtwk2KKcIetLoCxZAOiXNmmXXiZMPqeXRDosqIeCpb7Xq2G0Qa1rg/geCAvM49TW5ZCTYYZRHmyeWzkT/jBW0QF6yQ/tpys7b7/dkuE8wqZzhaCEUsHa1BVxJtCUj9Y6AcivB5IODsO33o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Thu, Mar 19, 2026 at 12:56=E2=80=AFAM Peter Zijlstra <peterz@infradead=
.org> wrote:
> >
> > On Wed, Mar 18, 2026 at 03:29:40PM -0700, Nhat Pham wrote:
> > > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> > > index 62cd7b35a29c9..85cb45022e796 100644
> > > --- a/include/linux/cpuhotplug.h
> > > +++ b/include/linux/cpuhotplug.h
> > > @@ -86,6 +86,7 @@ enum cpuhp_state {
> > >       CPUHP_FS_BUFF_DEAD,
> > >       CPUHP_PRINTK_DEAD,
> > >       CPUHP_MM_MEMCQ_DEAD,
> > > +     CPUHP_MM_VSWAP_DEAD,
> > >       CPUHP_PERCPU_CNT_DEAD,
> > >       CPUHP_RADIX_DEAD,
> > >       CPUHP_PAGE_ALLOC,
> >
> > > +static int vswap_cpu_dead(unsigned int cpu)
> > > +{
> > > +     struct vswap_cluster *cluster;
> > > +     int order;
> > > +
> > > +     rcu_read_lock();
> >
> > nit:
> >         guard(rcu)();
> >
> > > +     for (order =3D 0; order < SWAP_NR_ORDERS; order++) {
> > > +             cluster =3D per_cpu(percpu_vswap_cluster.clusters[order=
], cpu);
> > > +             if (cluster) {
> > > +                     per_cpu(percpu_vswap_cluster.clusters[order], c=
pu) =3D NULL;
> > > +                     spin_lock(&cluster->lock);
> >
> > This breaks on PREEMPT_RT as this is ran with IRQs disabled. This must
> > be a raw_spinlock_t.
> >
> > > +                     cluster->cached =3D false;
> > > +                     if (refcount_dec_and_test(&cluster->refcnt))
> > > +                             vswap_cluster_free(cluster);
> >
> > And this... below.
> >
> > > +                     spin_unlock(&cluster->lock);
> > > +             }
> > > +     }
> > > +     rcu_read_unlock();
> > > +
> > > +     return 0;
> > > +}
> >
> > > +static void vswap_cluster_free(struct vswap_cluster *cluster)
> > > +{
> > > +     VM_WARN_ON(cluster->count || cluster->cached);
> > > +     VM_WARN_ON(!spin_is_locked(&cluster->lock));
> >
> > This is terrible, please use:
> >
> >         lockdep_assert_held(&cluster->lock);
> >
> > > +     xa_lock(&vswap_cluster_map);
> >
> > This is again broken, this cannot be from a DEAD callback with IRQs
> > disabled.
> >
> > > +     list_del_init(&cluster->list);
> > > +     __xa_erase(&vswap_cluster_map, cluster->id);
> >
> > Strictly speaking this can end up in xas_alloc(), which is again, not
> > allowed in a DEAD callback.
>
> I see. I'll take a look at this. Thanks for pointing this out, Peter!

Hmm seems like we can just defer-free on the cpu_dead path, and that
should be safe?

Right now, if a cluster is cached on a CPU, we know that it's not
cached on any other CPU, and it's not on any other partial lists.
Maybe can call_rcu() here to defer-free it. Hopefully cpu dead is rare
enough of an event that we dont have a backlog of free deferrals :)

The other alternative is workqueue (with some careful rcu handling in
the free callback), but that seems unnecessary.

