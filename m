Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B59EB26FF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04B56B0088; Tue, 10 Feb 2026 14:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2436B0089; Tue, 10 Feb 2026 14:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0C56B008A; Tue, 10 Feb 2026 14:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B842C6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:04:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7251E16077D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:04:58 +0000 (UTC)
X-FDA: 84429474276.17.309FA21
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94EC41C0003
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:04:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyzfv1Lc;
	spf=pass (imf21.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770750296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zA1TNrRJqKyG8q/TmmtSKmp3ptZDT+TpaazJ5Y0UgEs=;
	b=atFhrmoMUX7SDsrffFG3RyYqn/4WELhxz7JCzFt4CpETa6S0Nb+tW9bYanqIZQvsgfUKP2
	38yPRlTWHQ4Twe+EDG+fm2i6KaTVqDJTzkwPplWnKXF2UpTA7awQ5Q2uj4pB0Bgq0paGDv
	eGv8hxaoNNmmau0yjVl+JdNWlyrGjX0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyzfv1Lc;
	spf=pass (imf21.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770750296; a=rsa-sha256;
	cv=pass;
	b=nzUT4oDwBWfnFWOmeUJxixJVC+HO5gRkaCbW119UcsqGK5pxYRHAMjovTXjwV8rjm6xLhC
	OjqGlpI49iNu5/4UNrsN9O0A8GO+CaFRQXXOPxK/wOEKgAwnIgqeKVipbOQPaRIQQ6O3MR
	ntcLfzMQYnKJbH7SfSTwpQlwqbNJg7w=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35480b0827bso96488a91.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:04:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770750295; cv=none;
        d=google.com; s=arc-20240605;
        b=kMDak/GBmNrrvqSmBZPuUYvTxkWlln4jHju7Dw0e6EqzbDY/TIuhvwCsgNsyjMnWTA
         sPXxslgQXcNaOwRzQJ6tEduCskY1g69JjPzK5Bn0CB4Vy3zSv8fc5YHpQWgySVgeLZ/s
         3Apciqdmyso4QqzOwkCF8SBlWx9wGbupqYFObgGLFpWW3OeUNW2sFTbA+dkZ7JeAklcP
         94RLexSVPXZjqwp8RVZMZAlWgzn2mQTWZGTPU6ZqgWiCx9LSEFLEY6sKDdAM2LimTB7j
         gbN0l46FYOPMJQGt9xbQoaSHxyAlX0/AAq2sP2Img27QGuo/+WTtbqdMJsa4rtsRxGQf
         Ws1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zA1TNrRJqKyG8q/TmmtSKmp3ptZDT+TpaazJ5Y0UgEs=;
        fh=9bRoNBlsPuLQBYh5tQiU8DhjjCrl3R8+O9kELlhqVag=;
        b=aOW+KmUvxnAi0S0fEjtPlQb3wOidrQrDdYOXqEhBHxJv56vBrh3CZGdVUmuTHfouPJ
         CcFzcufehbc6o0jauFMy3UrS3cb0HaDm7YjjDNn93kdqcrth1qgZW18brx6uMLf7QmGL
         5EzrZ4hBanpQ7Y34cd1orJq4JVPThEPk/fUK+HMkH4qp8cVnJXCmzwlc4SbGnbP+PmYX
         iUzNuxikWM/P5V7FMvbfGukMEqbHTxmlDGdzY64DVnMhC8LzOWWHmndUUEft3GV+CC8T
         zMzNTfjQKOgZWMV/nY29pRzn+nEffZW7zHNcQs6N3naDi5VzcZn9rKJwmXDw9D0qhhSP
         puOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770750295; x=1771355095; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA1TNrRJqKyG8q/TmmtSKmp3ptZDT+TpaazJ5Y0UgEs=;
        b=kyzfv1Lco9H0S4EgpYHri4nSt1LUoaDBmVD6JJUHOczHhGIIAV0IoV+xpOX5ag4tvo
         evfxLkqXTRkumtF1bbSzPpY43pNiPD0MwaEYLmx8JrKtbKmnpZNikRSZvYtLs8KJL/8H
         L8j6OsEzrgujG8Q+3HRHZTn45MMWNUhXGRS8LNMmJu2PW45olIrgXZcAMxiqLay6+0NE
         ny8Db4yfveHj1RXLJlAj6wL/aYae8AwGPn+I/lKGDILMaHS3TPatEZGA5J/6zT/vSMjT
         dT5Pw9vV+oJsWGSdjlNjfMJYexG0BMrS8EqnfpmITW6Uk8uSfYmMCooWLuakb70jy6EK
         ImTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770750295; x=1771355095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zA1TNrRJqKyG8q/TmmtSKmp3ptZDT+TpaazJ5Y0UgEs=;
        b=TvunKfoPHKtcSBEXR3Hy55oNq22+W2cjctbd4yzXRLvjzsumFs10MUHe33B2tMklCw
         A53aJsl3GVwtIhzILkdHeHyJxWUOxufxHktLyq6OMG/QvEbiikTCrz+FS2df9Kb3fLIv
         ulbLN14i81rhA3PcP38rtgiBdySjpoks1VUCvntvghT5SL/3otKN5igDHSrgFUff7Bus
         cuIu0plDhMzh3WN1J2uTNfhoaMyIbDe0Ij5kQ6lFazvvsNbryEjT+2DRVt9oNt+6HHQA
         Ks+XyC2xyD6OlzmdSkXONjsOuZBQD6aDW4g96kfbTmrkXcXskwsgUNVilu61hhw911EP
         IqoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKCfEtk/uy3ALpzpFAvnVE7bNzHOtTraTqlEwJlJkGZIc6rgw58HmcaRiNlQJKDk1ggDePXnKrjg==@kvack.org
X-Gm-Message-State: AOJu0YwBI2YGroel6pkJ77cg46t3JjEq6/h7PbYF/rzv8pQYQ+OikKL1
	Qm9PeK5M4SxnV7pW4/C3vCoNUcALey9pFcEb6wEHdnesfFFUVnP44VXC7YGsPkzeZqQAQqYrAMW
	Svo3v8guN4nrlW4CZT1tAbpYxJqAJbmI=
X-Gm-Gg: AZuq6aJfKWaWyIikqI71ak09v1MHkwNp2trOvANDMPh4aSt4jDrM4vxspunsAPJTvhS
	QsIwr388sfj1hHkqp+7dOvo+Iz8lbFzs4MiR+l8qSvR72yzW6yMOBhaG2ZEKlzXwS4Ee1yx6OVT
	mNH6f1Ax0ykORTn03cXi+c7oyMk30aR3Vrebf2OGYqCGHLuYhqlwY0W3eU4D9yxZ68J+AXQyZE8
	SNzuSVlYCuBYtRAFfD/GPMVGg9nE90fVFPWZ7oY5MO5PAY15B7iJDF+Hi5xfw6tdMLG19dIdBL6
	LJRsDMJHoF+M5BkSk2pBc1U=
X-Received: by 2002:a17:90a:c2c8:b0:356:26c5:aaa9 with SMTP id
 98e67ed59e1d1-3566615404amr2614078a91.2.1770750295328; Tue, 10 Feb 2026
 11:04:55 -0800 (PST)
MIME-Version: 1.0
References: <20260129215340.3742283-1-andrii@kernel.org> <87qzqsa1br.ffs@tglx>
In-Reply-To: <87qzqsa1br.ffs@tglx>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 10 Feb 2026 11:04:42 -0800
X-Gm-Features: AZwV_QioTD-2tB90VI5wBvuDYhjyIi8I9OHw4H2v3xPsXfvoZ1RNWowMJzaHBTc
Message-ID: <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
Subject: Re: [BUG] [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
To: Thomas Gleixner <tglx@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com, 
	shakeel.butt@linux.dev, syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com, 
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com, 
	Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: odjxcnps7qxga7oqqxtijjkekod5484f
X-Rspamd-Queue-Id: 94EC41C0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770750296-228282
X-HE-Meta: U2FsdGVkX18yXalmkyf3OMo29RXDQ8S3EgxbPyhMNU+Ksg9I/e6CvDoVtubQW/4vtOg4wFiexgUX8NtqY+ZQNJfhcGLFnDzm+Up1jgo5ybEg6X8hRPCc7k5KDqEV2OZ3itqpJYfUmNGGiKr0Q0xw1fXx4nOUl3dkI6rmuTtpv4rZ9Crxx1oxu3nfjZHI8nz8aSWjEF+OLCAFmy1WI5xarXdQ6KPWcOoJaKBMKtcohU+5rSBqBsETxzBsOnBsQ2Nb74MheqjMYkGHizjAUsTrVsVgreA2tpyT9DUcHU1cyA8JkjmfjN5st51HdbilgGbpDP4Xw9hC6iISCjPNxm67XSDfS4md4A8crczowMEOXGMgg1/kE4weMJVrhfrpyunQtdjhoMQsc8eqKqHPxMZ1dlCP8XWFw9tG5fiSX3wo2nRFMuyTtxif15F2rgSHMdreQjA9ObQUgUa6iEjQB23xx3FPZzGsvm24WE2MVKnN7IGTz8ompf61Wc3EO2bkVio09xIBC9CET7sHoaDojS3biUNIKffZnvoyBL4JAKkRwKS6Ns3kWRUduxC+1a4i28CBg3BY6GGivLkd8zcGsPNhl+/K8ZFb4g+c8uXASIZGhZ+XEdeLia9vUav1TNGtIMycQt5TlIFBVOMLySt8ZG37Da6mrvK8k6FjATaW2KzW1NiYLtXH2Ul+dPtY1KHtTxJA9nTboVix//8Nk4DSZEwsW1QSGmP4lSlqLOL5i+mxzEwS4xmzGn0ND+7jUbC4dKsyuQLQ8hvcsc+kVAppRG1Wp1FIEFHunyZx2JnlcHhRBNd1B2M52NrovdE7fmTcaqu2n4K4SvDmo7nHZB0dn+FLzn1x+MpG4+pqm/d3EHyATlLoGC/PKHv3ViYjVok0gmgn5EuPclzD+f6VmQDV+zTS/LbPaXzhSFn74Tn+zfbdmpOWOJaIMP59ZZwQsB2YJyJs9K+8R902jG2popir8uY
 ClUiAMTc
 tuolk8GZVYuJWhTMryjvFF2QPxCVg86sMjgsGHsprYapJkFRCIRqTPLTgWI0jF2HQsqkfhIE6+8gz9HmePM9xF5vVM1vNc6Q/Cp0l1uEOe2dnaAv+5SUMozY6hDKeMPrEt9hsdnw+q8f6XgSIWeswPvnzXR7hGjeYHdHvPkNH+Hyk3UPtqhpzAkgwK4TzHAk90OGsWsz3Gz5Q7EIF/T8+0wBlSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 10:41=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> =
wrote:
>
> On Thu, Jan 29 2026 at 13:53, Andrii Nakryiko wrote:
> >       /* unlock vma or mmap_lock, and put mm_struct before copying data=
 to user */
> >       query_vma_teardown(&lock_ctx);
> >       mmput(mm);
> >
> > +     if (karg.build_id_size) {
> > +             __u32 build_id_sz;
> > +
> > +             if (vm_file)
> > +                     err =3D build_id_parse_file(vm_file, build_id_buf=
, &build_id_sz);
> > +             else
> > +                     err =3D -ENOENT;
> > +             if (err) {
> > +                     karg.build_id_size =3D 0;
> > +             } else {
> > +                     if (karg.build_id_size < build_id_sz) {
> > +                             err =3D -ENAMETOOLONG;
> > +                             goto out;
>
> Introduces a double mmput() here.
>
> > +                     }
> > +                     karg.build_id_size =3D build_id_sz;
> > +             }
> > +     }
> > +
> > +     if (vm_file)
> > +             fput(vm_file);
> > +
> >       if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_n=
ame_addr),
> >                                              name, karg.vma_name_size))=
 {
> >               kfree(name_buf);
> > @@ -798,6 +808,8 @@ static int do_procmap_query(struct mm_struct *mm, v=
oid __user *uarg)
> >  out:
> >       query_vma_teardown(&lock_ctx);
> >       mmput(mm);
> > +     if (vm_file)
> > +             fput(vm_file);
> >       kfree(name_buf);
> >       return err;
>
> See:
>
>         https://lore.kernel.org/all/698aaf3c.050a0220.3b3015.0088.GAE@goo=
gle.com/T/#u
>

Ah, silly mistake on my part, thanks for the heads up, I'll send a fix shor=
tly

> Thanks
>
>         tglx

