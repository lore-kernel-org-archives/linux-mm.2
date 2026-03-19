Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE991091930
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B0D6B04AB; Thu, 19 Mar 2026 19:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ADF6B04AE; Thu, 19 Mar 2026 19:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7412B6B04AF; Thu, 19 Mar 2026 19:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 661AC6B04AB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:28:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AF011B88CC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:28:14 +0000 (UTC)
X-FDA: 84564403308.10.524AB9B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05A954000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:28:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bu5GRGgO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773962892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9OWBtdlQRn2CWoGv55axZFQst3AHYCAYnvEd326GJU=;
	b=l3NHNM+IqDijEsazjLzcZE8TvQUFRHW/pa4dpzIEWPHJuw0/81edacYQWjERVIQZqbDd2C
	HWlQFuFBIlp0+w0GP5jFGyMSgCvzR/FG+16hjKm05j9opCE7Et9UXr9RpmoyTb8FkRhmof
	B58viHdIeclSPOoSBxvhfVphrklrHuU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773962892; a=rsa-sha256;
	cv=pass;
	b=THH56JH0I287sxEVxVbcbiUN8pNDDFd0StaDOpZyh3Zezbt6GCS/LBfzGjux7Bi8geUn4N
	KohOUL7ERXafEWvnqAy/igmc1l+ZrVvRMHv0WKrSDk5IUW45j2urLs+5/q6IZYJ+PLtqsQ
	P6/SAqRKGtg6tY3f8ulzZLtRyQiUvDU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bu5GRGgO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b4fd681c2so1250446f8f.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:28:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773962890; cv=none;
        d=google.com; s=arc-20240605;
        b=e9csZbboL73tUJePkrtDQ6A592N3K5E6/dFQACywvBii0sW6ZAZWsUTqBfAC3jcIzE
         83+tH6HVd16vsFwymxnKxjKPYyeLMpePQ0PQfIhfPFIg0CJJufd3ukxoqijCbbJmJdgc
         GCRw0lVEosb/pH+BM65Q2S//i7poHLjbWFRN7xHwiwWnLKjSSCI6+YQs+ge9iWQRdx0j
         eBdmODGkt+LWqv/DAPZEbVvnf9TY4JIVQ0IPDUXHdCJZLW5x97bJpvWi2KsXLQdMl+s5
         wXyonNPcIyJ9SVYwgvJ+DUUSw8gbfodw7vcAZLfS57qzBIPhLiMq1msCajmJCvLSFTW7
         Skwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K9OWBtdlQRn2CWoGv55axZFQst3AHYCAYnvEd326GJU=;
        fh=qXI8Lldpr0YOpIsEQq8xbgBwXWfn0wKl6aHzOPMsrbc=;
        b=NwAZrUyoHwLq96CwGggoCh3dH0OaXAyq9V8hyK8FlWsck0Yh0KqK76Dmf9pYSxPlMc
         8RRAb9V64EaJjfjM7GQRD/Msu+fk7fT4i73IfhzyTqQ9p+39HAAoAQbSPq0mXMUBQJAI
         kOIuIaFpfq0LJeTTHsmcd6+GgCbJh9qhGsvbbj8EtE4vVCZzKoIot9Cae5KyFhjxUXjr
         suE0eIwa6LC2fQDNSMRVlMQfcpEfigI0flM93d/CC+mrA9isFGX1TCyn8HK06s2n37as
         3fftmmDRNSTt8Kxyi2/JdDrwG+PD8NzeNgvuDDLiMU6oD0lst58GAH+IbfUdtOOKU1S6
         im3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773962890; x=1774567690; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9OWBtdlQRn2CWoGv55axZFQst3AHYCAYnvEd326GJU=;
        b=Bu5GRGgOk/cYSFGYH9BTSIDsyJN0np45MAxdUC9caxLaSWqSyYxxOgYArmqo+xYjXE
         YYDRtInwenIr+XK49l/NsWlNBwcL99JtIms7fO0u9692B/+RRtYt5z8KDc09L97yQydf
         JLta2YjrWjVdlzioTzr/q/kiAzPCEf0CwO9zuq/sWse22LaUBS6RL1dDbLkglUJl8Fzy
         YaqIhVjtkDzK3IlSb1skGU2gLSC1Qp83gMoSCgIsRzh9yYX71sUI/3vZk3e7VseBr7Ll
         zZVO0gEFJmrR/M2bfIADBa4DPvO7jkWy8KTtwxnsfsG2rlIVuBU2i7vA+DULPbGKoSVx
         Ywag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773962890; x=1774567690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K9OWBtdlQRn2CWoGv55axZFQst3AHYCAYnvEd326GJU=;
        b=Dp2AlAcqqs444PCppAIBEszTy0A3ZcSiWWm78mPj43WanF9Gd+rz1gr3MZKLwRWR8+
         i3EjvcRmP7TQlT8mwlsOZhIhRrUChHFCi+PDZxV1AqIWC+zDMbfA7P1xQeEbipXFipUf
         YpfJIII1MD5IIIf8A46SloCdyZ6gSi81qjFiMSafEzWhTUj66u3Xc7MFcNUXuUDfRgOk
         3t3HSWeoTdblrLSHAeXler6ikxOtW5ZmLgC+5QuisXar5VBwfjEGJhQwaE3S+aC9iRNH
         c1ZJdSKMqvatiwXnT6ml9FrYwI9G9ulpwhLjBgxHTHBgIr+FdOo8vytl+zfDSZ2rfjQx
         cGtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVLOn64iKfwn1UlYp6fENHNdCoCN1XcYjHF+1Y++Io0Nvb73AwFBJF3FGP+ddzIs8/mmLIJSeE6g==@kvack.org
X-Gm-Message-State: AOJu0YyhyQFxxlioWLw7VBi9QFOIEuF9uuiGlZLt9jdI0l9fxZaP48Od
	8Quu2KxNKeHi9yWJf/a9Z1CzyHQDjh+YPQprTBSMQqEzwgPvfJW+Q6xZePTL8zn3npEYntuXmHE
	siZXdXk8CEkuW649g/HHH8VAjULkDCPA=
X-Gm-Gg: ATEYQzwBpV3b3EDWILARL276WUjNuqCbxpfUwCZGllNSY56Utls+I5vf8J/xHIU39o8
	ODBnGN6TbqOaJzYWEmba+qZGzcyE9t+wVlFbdpw1lzPqSYFy/AK7lww14O7VvCxdHQaSnHO3KHd
	oggJb0E5/SFkh6wYa3gMVTeh1f5gPRL/xuN5341+uY4qw/ig31xhXK/sXbZYKNsjEZj3tkurWRY
	Rhuft5DIUhsfFpvjMwyBmhGj8ckmNLQoFTbhmQFUUn9teAsTdtD0qbAljfVhLoYIdSWJAH0UQ9J
	s83xc8/xyzbpbyO4PZcpcxWdcRVqEKeezH89JaE=
X-Received: by 2002:a05:6000:420c:b0:439:c62a:6dc2 with SMTP id
 ffacd0b85a97d-43b6427973bmr1895992f8f.41.1773962890359; Thu, 19 Mar 2026
 16:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com> <20260318222953.441758-10-nphamcs@gmail.com>
 <20260319075621.GR3738010@noisy.programming.kicks-ass.net>
 <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com> <20260319210319.GK3738786@noisy.programming.kicks-ass.net>
In-Reply-To: <20260319210319.GK3738786@noisy.programming.kicks-ass.net>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Mar 2026 16:27:59 -0700
X-Gm-Features: AaiRm51gvauVsANsKDMAP1QUJ1JVBGH5RQXhUw4QEOuff8EZUUd-LXduXX7csLg
Message-ID: <CAKEwX=N_oAjYy3pKzXG+oq9arhNrmPVBm6gvVC_Hx2Utvjfr7A@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: 8cui8yb9q1cgpj3xq1d67149fet78dzf
X-Rspamd-Queue-Id: 05A954000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773962891-607028
X-HE-Meta: U2FsdGVkX1+PBtPVi4DOEjiJOr7y7BDuE7Qlp7LcVhxfiXboLqAbvgvDZJOwW459bLUhK66X/77jKUwaKCF4bweBE4Tip5J5IYLOOg38okevonnfh5z0ATT34hGWvNaE+MZXnCqHeVYi0tvjG4oolQhjZzOKM9wl/asXWVsXnbG4xkAsJK5aTbC3yUgIJXKddgL7eXNRIdkOzN6NVtblJg01D9PNj41ycY0yi5cIrr46xZXhIvoBSfnHbQ9ypLpzzgfmXEUwD4Sj+yFjUMvDGBeNQrxojUPerCP3u5xzzCPqy7JzyZhU0Yq3aUllaMIAeXfiast4cmqlirFjd1zJV+00/uYkgEdHysWY57NkWoIuI5kEeqsei1rrEtDrlzc7Jq5Y1JZK/dmqQ8bJORYgYgqFYTYf6vB7l8KmWjJAqB6SEm4Ydq9n2rRkVaVW7rq3lEonWPBWq9xp/gaAMNEwknqhWoD2gzlKjMktbOF32fe4yNJ9diS7F3/Yr3xYbpOlNxIFB+M3fVSHxvtWR3U7tz6c66GC8cvNan1eDrNN8MLxH87ojFJu9vrkGS63A79GL0oPOZc6Zu7IfHNJjMRqpGeg2rfuNun3a/uoySs1HQJk9AAy9D1qwiVcnUeV7IBAOw7Q8vzIioPLU5NQQcX5QAdi4DpEwP3xl21T/E7tvYbOgbd1qj7mJtSyl1MAouLJRA5ldOBtqU2MVmk6sosjyJD3fve1eGXyTY2pfq/yHteg2OhukQLpP4dlHLxVyxjiSHxiItA+HQbSQL/9FH3q6Qj9PmXPjYNlM0MNfkGiFFc2lNC+9L6ZVWp13e1pbOuvfgySBGtAFx3DRHqzmINAZcBhPEEsloTJSV9RRxoW2s29lJTJx5bbuuRGMOCK/ClqGfYj1jtyu36PZ4KmEYI1kuEaNE7hgSng9+DFUrE8tZhTZ2bLhDzJLM6+tJw/vbK4rDtjlbRzHptN9k6DF79
 9Jh0nYyo
 swHLV8bKxQ7GJWik+peCEVmFCZiAJ1lR8omR2zI32ln/Hbl1d30RvQ9k6QLh2T1WLBuhd2EZhWJ2YqCtKrB3OEkoKOgN0iFO/An4IHTI323XTUzLs/57uEo0QYCE1rwjg7ICrbPhgPfsMJ2fa1fvNglUK2Z8tG25+2iJsMlgQpGa2p+0bnRboqYUZtwX8KxIRuBaNrAj4k6ifrO2wGo4h6yS/gMfNP++cXbtf4nXbFLfTrUQFuk0pb+Lds/kQogqskxBiD70sDVxQo2H30pFVtq8TYgoX9YGo7xYFHhSWhg4icyCxU/mrZpPOvbuDzhbBEOaWVxHYVzYuvKg8uxGIoge0UmlM3AJw2WWWtk6Dy3wkwSBHHmrYAjwxS26N0Nz4FR+VYQn9/GhLQyqU4OXSusYJBs2p0+DojgEmk683VkfsLvx4jwYug/8rOGZakdOIF1XmBmN1WVLRma8J0s+ex33llN9W3ORAP7/dO/ZRPIauZghr5EjdCf86nEba8E/mh6/ikM8mSOrYJmlnOHsVuxgGwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 2:03=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Thu, Mar 19, 2026 at 11:37:19AM -0700, Nhat Pham wrote:
> > On Thu, Mar 19, 2026 at 12:56=E2=80=AFAM Peter Zijlstra <peterz@infrade=
ad.org> wrote:
> > >
> > > On Wed, Mar 18, 2026 at 03:29:40PM -0700, Nhat Pham wrote:
> > > > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.=
h
> > > > index 62cd7b35a29c9..85cb45022e796 100644
> > > > --- a/include/linux/cpuhotplug.h
> > > > +++ b/include/linux/cpuhotplug.h
> > > > @@ -86,6 +86,7 @@ enum cpuhp_state {
> > > >       CPUHP_FS_BUFF_DEAD,
> > > >       CPUHP_PRINTK_DEAD,
> > > >       CPUHP_MM_MEMCQ_DEAD,
> > > > +     CPUHP_MM_VSWAP_DEAD,
> > > >       CPUHP_PERCPU_CNT_DEAD,
> > > >       CPUHP_RADIX_DEAD,
> > > >       CPUHP_PAGE_ALLOC,
> > >
> > > > +static int vswap_cpu_dead(unsigned int cpu)
> > > > +{
> > > > +     struct vswap_cluster *cluster;
> > > > +     int order;
> > > > +
> > > > +     rcu_read_lock();
> > >
> > > nit:
> > >         guard(rcu)();
> > >
> > > > +     for (order =3D 0; order < SWAP_NR_ORDERS; order++) {
> > > > +             cluster =3D per_cpu(percpu_vswap_cluster.clusters[ord=
er], cpu);
> > > > +             if (cluster) {
> > > > +                     per_cpu(percpu_vswap_cluster.clusters[order],=
 cpu) =3D NULL;
> > > > +                     spin_lock(&cluster->lock);
> > >
> > > This breaks on PREEMPT_RT as this is ran with IRQs disabled. This mus=
t
> > > be a raw_spinlock_t.
> > >
> > > > +                     cluster->cached =3D false;
> > > > +                     if (refcount_dec_and_test(&cluster->refcnt))
> > > > +                             vswap_cluster_free(cluster);
> > >
> > > And this... below.
> > >
> > > > +                     spin_unlock(&cluster->lock);
> > > > +             }
> > > > +     }
> > > > +     rcu_read_unlock();
> > > > +
> > > > +     return 0;
> > > > +}
> > >
> > > > +static void vswap_cluster_free(struct vswap_cluster *cluster)
> > > > +{
> > > > +     VM_WARN_ON(cluster->count || cluster->cached);
> > > > +     VM_WARN_ON(!spin_is_locked(&cluster->lock));
> > >
> > > This is terrible, please use:
> > >
> > >         lockdep_assert_held(&cluster->lock);
> > >
> > > > +     xa_lock(&vswap_cluster_map);
> > >
> > > This is again broken, this cannot be from a DEAD callback with IRQs
> > > disabled.
> > >
> > > > +     list_del_init(&cluster->list);
> > > > +     __xa_erase(&vswap_cluster_map, cluster->id);
> > >
> > > Strictly speaking this can end up in xas_alloc(), which is again, not
> > > allowed in a DEAD callback.
> >
> > I see. I'll take a look at this. Thanks for pointing this out, Peter!
>
> Oh, I think I might have confused DEAD and DYING here. DYING is the
> tricky one, DEAD should be okay. Sorry about that.

No worries at all. Thanks for help taking a look - the other comment
regarding lock-checking still hold regardless, and will be amended in
the next version :)

I'll stare at it a bit more while the context of this portion of the
code is still in my head.

