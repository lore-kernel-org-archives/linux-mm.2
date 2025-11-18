Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A05CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED3B8E0017; Mon, 17 Nov 2025 22:55:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D508E0002; Mon, 17 Nov 2025 22:55:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0650C8E0017; Mon, 17 Nov 2025 22:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E37C98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:55:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8730485E8F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:55:09 +0000 (UTC)
X-FDA: 84122362338.30.161FE46
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 916FAA0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:55:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FBKTg2TB;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763438107; a=rsa-sha256;
	cv=none;
	b=fZW4KolbnRkRSvogs32tDJcgh+vR7IW16QgrlLnLxQ1kb06O+x5d1sh7W/JdRZ3qkKczoC
	nQYZQloaAPW1aKpAB91P7R3aypAfXZQmYt5zge8XZZ0KPvrNj0QNqo4U2dsiIHT1PkvDsA
	mRtpT6AOiErme4u49dwGsts8d82u9kA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FBKTg2TB;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763438107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skgPOZZQd9xc8fmG59fpZy24V3xOREPCSLrN+c1B0bM=;
	b=3mQ9Q+OXGDmjFlD3stee5+lt2/ZmtKnUB3n9bepae00EAWEn9MgMeM3hAxpM6Z5s25gP2g
	N4VCJ6arlZv1h5LYpiWEXSjE/f/x8w+zGqxo2ZtZixQ5MixpZqm8bUwRP27Q2t+kjwBR68
	sw0vwl7Y/XsB/fgdzYZ6GfQWTGICDug=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-644f90587e5so1203561a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763438106; x=1764042906; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=skgPOZZQd9xc8fmG59fpZy24V3xOREPCSLrN+c1B0bM=;
        b=FBKTg2TBnWIGD5jVQjvtkF8fnC4XGJhNjK67l9qKDlSPGv2JAesu5GQGH/xu86ZGBe
         qZ26rMREjlygWmszkztUbCDwRZRk40v1J0nem4chGy1fKhpcvzF0ZGCKevYZh3lvaaVS
         dFm1kYbdDifeYSkO0f6nEnkmBB/6UKPbhmo0O/45H8kmXgugMftFzVlmwdVbwScdJX/e
         DN5Gs6JwVqc6QhvmPoILq1AWGkA7KCfU+rW4toVNguPAIQjZbsSHbKv9wUOKZCsQXLNE
         SPz09bzSWojUgmOBwnfjxHbxNokFWTuHxmt0QkLtOhlNe8EK/R3HzaiZ27aPMHdsNbND
         eQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763438106; x=1764042906;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skgPOZZQd9xc8fmG59fpZy24V3xOREPCSLrN+c1B0bM=;
        b=rg6MnegISrrQTAZUPfPAcZp9DSZYyxVt4JjboqA81nN40hesLT969GWpESBGvg2LgM
         vkJqk034pdQ1Zxxkj8aTP4oXIk7v91YAb58205nXNkBR5SCXQzLeFvY5dO/MiNCjxmWp
         beFaw4yU8+WiqFjD7UfZRRcvGnLF6jWWSWRBlLooIXxUSG0FWYBKmRKvN+wNaucPnEPT
         54Dr24YjhMc8PasyinUcL8Y54ZBDg2EPxWKjTPNMxQXnVc1LMwau4HocLgAucKVAhoYQ
         L+f8Zk9Ed4+au63u7nUxD+5xH0fDZBoLX7nZG0350ja9d0D1sQQxE8pfNSI9DgxxpwQO
         uy5g==
X-Forwarded-Encrypted: i=1; AJvYcCVoyrKpu3CLcKZ7OYunqOeQw+a2+L4MwxbKcRgkAObrX2kpBA0Pl7RDSQbpbfgT0ACYU8s26ZbW3Q==@kvack.org
X-Gm-Message-State: AOJu0Yw88zUtW9WAwSRG56Njr+B6lvweyBPgWqqiTvB8+q8/Xgjl6zGR
	Cm8hgWTPHbbRE4531kEDGwRknk97tttPqmEnZJtIW7bS5f/WN9+z0SDBUyR1WmjiA51Id6NgWZ8
	yAIpr4P/MV4m6I3OOLjmcW6DdcrZ+pswo1DxuGalCpw==
X-Gm-Gg: ASbGnctJSDvDs/ue9DD3HQhniyvWd+I6ndeFg78it5Ja/H1R5sb+VoTH+cZpjHxNh+u
	ZFV9/cNs4aynj3njyOxTMffgz7x++bIfDsrheTDqScmZ1skHkQ4wspsJ5kXBq2XnjRTp/8rU/Gs
	vWumiafUaMrEV87v3wwlYXOAgigPGaUMoXh1G+hvLav0gbQIcRRRTYSvSTaNykcVHL4GX1hGFIE
	z5wGnvpfgQoA11D6wQlfS8CvApQ0+0Vjr20eU5wFK6eeEVGAJYuXO9CyOZuyyCKmEjC2dDAlrrd
	7G8=
X-Google-Smtp-Source: AGHT+IGpZOWjW5LZWKY0Iok3QDFR7NYQQcE+w3n/xTVgTcedHnVbwsy/RegtbkWq0MjsVKCBcc+Ff3JZMy+ys8CEjC0=
X-Received: by 2002:a05:6402:5056:b0:640:ebca:e66f with SMTP id
 4fb4d7f45d1cf-64350ec0198mr11607004a12.34.1763438105963; Mon, 17 Nov 2025
 19:55:05 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-9-pasha.tatashin@soleen.com> <aRrtRfJaaIHw5DZN@kernel.org>
In-Reply-To: <aRrtRfJaaIHw5DZN@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 22:54:29 -0500
X-Gm-Features: AWmQ_bkZQMN1UOxORLYbivUdr8-ENGLbMFsVRw8DEyZxpK5fJGoXi0eN_5cEvNg
Message-ID: <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com>
Subject: Re: [PATCH v6 08/20] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 916FAA0006
X-Stat-Signature: nn5dm6m6n55pr6u3dw8ck7eeo37wc9wd
X-Rspam-User: 
X-HE-Tag: 1763438107-50797
X-HE-Meta: U2FsdGVkX1/jvx8n+TcI9pFkgb9ECDfKgYD8xx2YUEVqiIQ0WYGV2eXoiQpatTBzsHWqadNmafo4spoBV599VhVDIvYM7gV3ox2nCNa+pREsL5IMiCVf7llrffljX/yH+Os6dwJxuAXbcJhK7LaFbdxWqy4gC2RDWaazpShf87kt9xMAem+KlgBNGmYnRJ8Xop+j2aaDyHJ++9eomikWr/4azvmL/wXhzJPzZJ2Cj8i28MlII1X2AEYgzLfwu9VsL4kj+jgRMB49RrrARtSNrpwgAuiELaLY0aWmVc3LvMVsyrTYrvknDNmIKdVmXw6NxVeyThc7pVgdti7tDKwhih3h1/qfd4vBd1IZUR0S5Wfmhg5CR2C8vRfHSa94dILrDTMih2czcEKMDRTBqTfwTWaEew399RxqdYBGcwnLSTEL11wmwfb0ov+42Pz2RCSuph3Kdf4Uc157qlTczxifHWRTGNdCzBSFU4faXyVJ0DDRMbey5QxVAxqoIHJ2LukrGJGIvWnsH/jXsIxG4rLrNYdRqARgNY0TPQLHqQJwyGT1GQoFdver5OrGfqK9tNNd2Y2d85iroU4bp5rTfZ/LrymMQ5CxuZNad9BjbrdLpCzWxB5Ke5PpVoMqNLY5J6+wyFU7wnXnzUO9l+d2EAzgdGab3f6V0oum38WSEUVCtxNTYkFxgOzOSBQZOEXdyjT9bGVpBd6xD0GMnt2JBE+cQagGnew5ZnZqQGVwUWQpDpY9MIjYqpMHdTObVxZraWM1+KJY2uGee8aCeV6O715kIoTJldXZy+Ml32+1IsKjS0VvTCVy1RsTUz9YbRIyDwvh+pw9JxPCTsO2vModihrtE/wF087qPl1fuoTR7SARfzxCz8gl73VI/UUzp9NbvPljXZAMKoVYMXexgswO6MAM1spA0QxPdXgh0qSZ1enqsalO4Imeudd4m/ciEEsMbhcC2Tap+wVjd/cHPVFnjlJ
 p2Sw4XiF
 CS7fRXT03rSzXV4Xo6tHG5VGQkIN+fbw0tpvUnD+wCihN+rPDDJXY9BTW1xJ0WFFBJNo3gI2lzAxQIe1UKLo7Y5aXmtoGKwmHMeLWboC14jBTSr2mTe6zZdIAyi2zLR0ZaYfpzGdk6y+4tYQ56svaI1DUGpz02QTWLHmeahIHNCOs1+YW9Y77xuLqRdIF8xKcU6Numk++hCDe8ex2JKEOYvx8RcHoYfIXufEva3+TMMVbP1F7z62FzZEMu6/ubv0aro2F7F8FJF3bfeWORq7zrqlqL0tfBLPnR/PPkaZYaE9t8IYBDZcoDvDwv/yuwxeCkf0QFYXXQIhNmLyBXW+HIiu07QRpiweu0rg/rNoJX4KsNtfnUdEcrB54RePRQyMEP4pk9oClpU1Jy83p7EXIvemq2HBvDC1ZT16xIbECjnBRuzE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> The concept makes sense to me, but it's hard to review the implementation
> without an actual user.

There are three users: we will have HugeTLB support that is going to
be posted as RFC in a few weeks. Also, in two weeks we are going to
have an updated VFIO and IOMMU series posted both using FLBs. In the
mean time, this series provides an FLB in-kernel test that verifies
that multiple FLBs can be attached to File-Handlers, and the basic
interfaces are working.


> > +struct liveupdate_flb {
> > +     const struct liveupdate_flb_ops *ops;
> > +     const char compatible[LIVEUPDATE_FLB_COMPAT_LENGTH];
> > +     struct list_head list;
> > +     void *internal;
>
> Can't list be a part of internal?

Yes, I moved it inside internal, and also, I removed
liveupdate_init_flb function (do that automatically now), and use the
__private as you suggested earlier, and also removed the kmalloc() for
the internal data, so FLBs can be safely used early in boot.

> And don't we usually call this .private rather than .internal?

Renamed.

>
> >  };
> >
> >  #ifdef CONFIG_LIVEUPDATE
> > @@ -111,6 +187,17 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
> >  int liveupdate_get_token_outgoing(struct liveupdate_session *s,
> >                                 struct file *file, u64 *tokenp);
> >
> > +/* Before using FLB for the first time it should be initialized */
> > +int liveupdate_init_flb(struct liveupdate_flb *flb);
> > +
> > +int liveupdate_register_flb(struct liveupdate_file_handler *h,
> > +                         struct liveupdate_flb *flb);
>
> While these are obvious ...
>
> > +
> > +int liveupdate_flb_incoming_locked(struct liveupdate_flb *flb, void **objp);
> > +void liveupdate_flb_incoming_unlock(struct liveupdate_flb *flb, void *obj);
> > +int liveupdate_flb_outgoing_locked(struct liveupdate_flb *flb, void **objp);
> > +void liveupdate_flb_outgoing_unlock(struct liveupdate_flb *flb, void *obj);
> > +
>
> ... it's not very clear what these APIs are for and how they are going to be
> used.

Global resource that is accessible either while a file is getting
preserved or anytime during boot.

>
> >  #else /* CONFIG_LIVEUPDATE */
>
> ...
>
> > +int liveupdate_register_flb(struct liveupdate_file_handler *h,
> > +                         struct liveupdate_flb *flb)
> > +{
> > +     struct luo_flb_internal *internal = flb->internal;
> > +     struct luo_flb_link *link __free(kfree) = NULL;
> > +     static DEFINE_MUTEX(register_flb_lock);
> > +     struct liveupdate_flb *gflb;
> > +     struct luo_flb_link *iter;
> > +
> > +     if (!liveupdate_enabled())
> > +             return -EOPNOTSUPP;
> > +
> > +     if (WARN_ON(!h || !flb || !internal))
> > +             return -EINVAL;
> > +
> > +     if (WARN_ON(!flb->ops->preserve || !flb->ops->unpreserve ||
> > +                 !flb->ops->retrieve || !flb->ops->finish)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     /*
> > +      * Once session/files have been deserialized, FLBs cannot be registered,
> > +      * it is too late. Deserialization uses file handlers, and FLB registers
> > +      * to file handlers.
> > +      */
> > +     if (WARN_ON(luo_session_is_deserialized()))
> > +             return -EBUSY;
> > +
> > +     /*
> > +      * File handler must already be registered, as it is initializes the
> > +      * flb_list
> > +      */
> > +     if (WARN_ON(list_empty(&h->list)))
> > +             return -EINVAL;
> > +
> > +     link = kzalloc(sizeof(*link), GFP_KERNEL);
> > +     if (!link)
> > +             return -ENOMEM;
> > +
> > +     guard(mutex)(&register_flb_lock);
> > +
> > +     /* Check that this FLB is not already linked to this file handler */
> > +     list_for_each_entry(iter, &h->flb_list, list) {
> > +             if (iter->flb == flb)
> > +                     return -EEXIST;
> > +     }
> > +
> > +     /* Is this FLB linked to global list ? */
>
> Maybe:
>
>         /*
>          * If this FLB is not linked to global list it's first time the FLB
>          * is registered
>          */

Done


> > +/**
> > + * liveupdate_flb_incoming_unlock - Unlock an incoming FLB object.
> > + * @flb: The FLB definition.
> > + * @obj: The object that was returned by the _locked call (used for validation).
> > + *
> > + * Releases the internal lock acquired by liveupdate_flb_incoming_locked().
> > + */
> > +void liveupdate_flb_incoming_unlock(struct liveupdate_flb *flb, void *obj)
> > +{
> > +     struct luo_flb_internal *internal = flb->internal;
> > +
> > +     lockdep_assert_held(&internal->incoming.lock);
> > +     internal->incoming.obj = obj;
>
> The comment says obj is for validation and here it's assigned to flb.
> Something is off here :)

Thank you for catching stale comment, fixed.

> > +     mutex_unlock(&internal->incoming.lock);
> > +}
> > +
> > +/**
> > + * liveupdate_flb_outgoing_locked - Lock and retrieve the outgoing FLB object.
> > + * @flb:  The FLB definition.
> > + * @objp: Output parameter; will be populated with the live shared object.
> > + *
> > + * Acquires the FLB's internal lock and returns a pointer to its shared live
> > + * object for the outgoing (pre-reboot) path.
> > + *
> > + * This function assumes the object has already been created by the FLB's
> > + * .preserve() callback, which is triggered when the first dependent file
> > + * is preserved.
> > + *
> > + * The caller MUST call liveupdate_flb_outgoing_unlock() to release the lock.
> > + *
> > + * Return: 0 on success, or a negative errno on failure.
> > + */
> > +int liveupdate_flb_outgoing_locked(struct liveupdate_flb *flb, void **objp)
> > +{
> > +     struct luo_flb_internal *internal = flb->internal;
> > +
> > +     if (!liveupdate_enabled())
> > +             return -EOPNOTSUPP;
> > +
> > +     if (WARN_ON(!internal))
> > +             return -EINVAL;
> > +
> > +     mutex_lock(&internal->outgoing.lock);
> > +
> > +     /* The object must exist if any file is being preserved */
> > +     if (WARN_ON_ONCE(!internal->outgoing.obj)) {
> > +             mutex_unlock(&internal->outgoing.lock);
> > +             return -ENOENT;
> > +     }
>
> _incoming_locked() and outgoing_locked() are nearly identical, it seems we
> can have the common part in a
> static liveupdate_flb_locked(struct luo_flb_state *state).
>
> liveupdate_flb_incoming_locked() will be oneline wrapper and
> liveupdate_flb_outgoing_locked() will have this WARN_ON if obj is NULL.

Done

