Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CF5CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FAE8E001B; Mon, 17 Nov 2025 23:14:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7618E0002; Mon, 17 Nov 2025 23:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D058E001B; Mon, 17 Nov 2025 23:14:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1216C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:14:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A293F4D41B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:14:19 +0000 (UTC)
X-FDA: 84122410638.23.C85AA7B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id A109E80009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:14:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NnwvD0Vb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763439257; a=rsa-sha256;
	cv=none;
	b=J4XaROI8f606GItyv/RVQJHoL963qZRbbZ8BMSkahjSDnlGgR/gB6UKniKUMJiZnl/0/1L
	W3UjaXpQcvVRbl4s6CsfvIV3yiVf/Fe/XkYynq/AyL0zEww/JyW9Aih6+cMMP1V8zDmbSg
	SRZJ8KBI2GulhJzwtz8xBtl1na7kGBk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NnwvD0Vb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763439257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07HeZKjyOA8sg+0j8XO2NQGRkS4H44zMUY+FSrwKOW8=;
	b=JUSB9AaTwgB+tLVTqFtMvpOzXW4FVA6ufywIfQyfjpmyxgqJ22JPDZ/roEmnD/nCzQ+/y+
	7h/usnS2q0eM/1fyQ+jsFjM3US3VQmNrPTVyDpvnJB1lrvRGrTHrxl1ufW58oifHa6k+rq
	CZ5ZIi5t0caIoAXZvb5FVbChVgQnqx0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so8718436a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763439256; x=1764044056; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=07HeZKjyOA8sg+0j8XO2NQGRkS4H44zMUY+FSrwKOW8=;
        b=NnwvD0VbUop4jrSh1J8NpwazXoXNhjhJgYlfTf4KcRz23fTAH+tL6LJnSwu1uGS4Wg
         sKVI9JAAmfr8ISSEZdkGMLrZsxkV6TYMmfqvZuL6mMdgox38fm7vUIvrzxq4kOfPJED3
         K0nLqWgClBYeG6cIIEcN7MSSTozzGH4WJebvALZ0SgY+xwuyUwoh7Z47bokp903jknux
         KRt9PxKpfClAX8bwEKdgL2b8nbvNmn2EJhOJM3igWDcujCAlUWdTTGe/Jv7Or6uYNJ1Z
         RTk2JBbzEEQ+vkwKEIBL2ek91+fX0an/m01SwxxyA/Opvpgs0r8gZpNQKtXEz9/GjQ0I
         hOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763439256; x=1764044056;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07HeZKjyOA8sg+0j8XO2NQGRkS4H44zMUY+FSrwKOW8=;
        b=IjDnUJa9/YKlEftrWiNJBZ5WanxKtzZoPWe+jToKbv6mKx8F5V28tKq7+QQd3pvysg
         b4jEtve73em2MJQp55H2CvJIrZc7SXdff68TcPN3Pb0Ube8/W34OrQ7GvegNDKZ6BqpX
         l2FuGhgrz6EY1xOi0z4Y7w660tbNumQDK05J8SPNCOIOoyOonJvSuPsGxv3iw/hFQIP3
         ZnnqcM1jH6sC5roooJgcY0yEuE5gupJRDxyy/Vcxfr0GbyBT+AE83yZ+Q/09+e93tKb6
         E8WEpJ0RXGb6Xt6cgEq9VLIBeKu4tfdey3gKDgjMlymKnaisLgqnVz91Ev+ztgLOHX15
         hHFA==
X-Forwarded-Encrypted: i=1; AJvYcCWlSGZtHuwHg8uAHTTJZL0Lpnoqfe+/bAFe6lctHU0oDUfz9rUBiL9UI9GIz5EjQlIzCTtlCh6cKQ==@kvack.org
X-Gm-Message-State: AOJu0YzpXnJXHUcnBP9fTxjqOohkCqJRUrPfbBOLr2sikoN6QQGuliF0
	K0FtXCVoN1LgMdLmIt8TulvYNCZEOqrrYET7a8oSP69tc2RQ5DiEICWCupSAKvGyZOuCDuH9gZE
	F+25DSgk9UlenrxiUA6ysV5Tk0zPbp9Ff+JjJxyPXrw==
X-Gm-Gg: ASbGncvLB74mn8pFbIXzvVJowBGt5EJNJq4CbWSFrAFdUJsH9uXbnfKXXf8KoDqfVjm
	zfLDTY+nFzZ4O5FAo+ssA9EyqmNyvNUod4nh7dwlHIZ8zg7QTnD5X01CdTvmjVbfoQuByHp2tA/
	CBKsCAchEJZGKPIyAJwfF0th/fK4iHWkqvdjeI+NwXgSlHu+zz2h5Itd9hk3JArNKkQcVn8pmbz
	uKVkv1/XoHjALOJR9hkKYMQlMnmBQ2pRXCNuHJDBPMI/b9zWrQYYbif1UMsMW0895Ow
X-Google-Smtp-Source: AGHT+IF7odRYhWUKE4hEH/yqZovWuRxLWp+QjpvspuEPYgC7PACIvotSh+56pMkd5f5Wg4bGjW+/7/Gip+y+Hfcb0Tw=
X-Received: by 2002:a05:6402:1445:b0:640:e75a:f95d with SMTP id
 4fb4d7f45d1cf-64350e06df6mr15371153a12.15.1763439255422; Mon, 17 Nov 2025
 20:14:15 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-13-pasha.tatashin@soleen.com> <aRr0CQsV16usRW1J@kernel.org>
In-Reply-To: <aRr0CQsV16usRW1J@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 23:13:39 -0500
X-Gm-Features: AWmQ_blVntX9altpCY4SXrXyEKO7X1UIHIxI-cPMY5rvalxcvtOdur6QxS28SKk
Message-ID: <CA+CK2bC7O4B=R7Wb2wZ7QYH2_Ujo-REXVqUX1ukfPJ-XDubtLA@mail.gmail.com>
Subject: Re: [PATCH v6 12/20] mm: shmem: allow freezing inode mapping
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
X-Rspamd-Queue-Id: A109E80009
X-Stat-Signature: 14i7u3ifee98djcerdrogb1s55t1yup4
X-Rspam-User: 
X-HE-Tag: 1763439257-232469
X-HE-Meta: U2FsdGVkX1+/KLA/8SEKxtuhNVU1XhmsErH31jpOwID+tI5QhtUQ5NTJ/wTUUFyKhdX/buveF9KNt76wEA3GxT1nuJvG69tKWeJ9nI5zPpMq3xwwQJ36MR3XbT+tYy8Ivs3QRDxZM3jb8yEL7rvsMoF2xpr9VJMJ9z7FtJ2Yv2fOFH0kXhn1ms1uSWVA/oyzZkvIChB7j8xlFChuQc5qhbPHPqWGucwvy9Proju5tu0fW2fILY1v2vMDWyrdMd+M6vm4uMFCV+oTr5pmYkjAfzWrYW14zz2ocotJ6Rbz2Vhsr/mLfxTPtLO5aRZ1yMU6rIZWPFLWJRPKqdkXH68hHigiPtQY6RHbiOcW41lLlPRxuIRM0HKud21hUMz7vl45Y4a42h2jzXmj7x75gkCsxjzeA96Vjeh9hM5zmZ8R0tL076KL11PRGgtfJuNdX0WdM2bmLoWM1P1pi5PS/9xBGOM/4bLx1T++eWdMZO0+9Xpv3c7fR287TyBB55bXACFtMmX8YUfvO/xB7aKqo0rALhjhc5IXctdKbmzb/aHz+W1X5AjaFYE78jyEc0r3PFwLSNgFwPfrNfWsDC1R7ysFcAAhX9y/SbQwuIg/bODR3MkGhvsmN+L2DeSY5OLcF4TVswk1fWyfZGu+HVAp1kO2VLzDJd3QA2CD3lhnGF7UTm82ldkzOFiNKRDWLCbIFciFeCwu28PxC/FnVHZX948NJJxTmHrWEfo1lrR8FF49aYC2P+CfrFqlga4CRU7n74zGW2z/AD4DCK66xDW4q9yf2kS+fjbkeR9wVTik8GhGehiwhk0zWWrAC/NeQ6AezpyokHEEDCZ6QfpZKX9DZhP2utvGb/Bmn/GaLbspIQlahu99fViKCY1eJwcs493k/JywezNWI6mecb51gfnygFAbv06NNaiOVQtOWn8h7YNty/+pF8c86wKxJ8hh9kRy7C4/eOak+yritdGk0IBijDm
 ah5yQLnZ
 kF6mBsRQW/MFnzZNk+qV4r73v71Iy8W+axxBBMPYMFDm2NJy0ort4vRvFL/Xja9LNR1xf7hh9eWLdjpQVQNF2y+DAAw9zEqO+e6e5jsnotiuIFlvoExSUSUP5lo4kHnGfYZ2zrOsd6aItpW4byH5XXG9jTofMVtX9rbE1d19zGDC4jzICNF+Rbl/4nyqQDXBzwrHJyhkufRGhUhII4oSHlD/WzSExdeDAhaKr/wRrjf6rHGe/3A51U/feeczeJyz29GA0al8ppw2lEkiefKIiNvyKvZxp990GbLEiagU7VozX8Ws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +/* Must be called with inode lock taken exclusive. */
> > +static inline void shmem_i_mapping_freeze(struct inode *inode, bool freeze)
>
> _mapping usually refers to operations on struct address_space.
> It seems that all shmem methods that take inode are just shmem_<operation>,
> so shmem_freeze() looks more appropriate.

Done, renamed to shmem_freeze()

>
> > +{
> > +     if (freeze)
> > +             SHMEM_I(inode)->flags |= SHMEM_F_MAPPING_FROZEN;
> > +     else
> > +             SHMEM_I(inode)->flags &= ~SHMEM_F_MAPPING_FROZEN;
> > +}
> > +
> >  /*
> >   * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
> >   * beyond i_size's notion of EOF, which fallocate has committed to reserving:
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 1d5036dec08a..05c3db840257 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1292,7 +1292,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
> >               loff_t newsize = attr->ia_size;
> >
> >               /* protected by i_rwsem */
> > -             if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
> > +             if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
>
> A corner case: if newsize == oldsize this will be a false positive

Added a fix.

Thanks,
Pasha

>
> > +                 (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
> >                   (newsize > oldsize && (info->seals & F_SEAL_GROW)))
> >                       return -EPERM;
> >
> > @@ -3289,6 +3290,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
> >                       return -EPERM;
> >       }
> >
> > +     if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
> > +                  pos + len > inode->i_size))
> > +             return -EPERM;
> > +
> >       ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
> >       if (ret)
> >               return ret;
> > @@ -3662,6 +3667,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
> >
> >       inode_lock(inode);
> >
> > +     if (info->flags & SHMEM_F_MAPPING_FROZEN) {
> > +             error = -EPERM;
> > +             goto out;
> > +     }
> > +
> >       if (mode & FALLOC_FL_PUNCH_HOLE) {
> >               struct address_space *mapping = file->f_mapping;
> >               loff_t unmap_start = round_up(offset, PAGE_SIZE);
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >
>
> --
> Sincerely yours,
> Mike.

