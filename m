Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5385F606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R4wf0Dg7
Received: by kanga.kvack.org (Postfix)
	id 765BD6B05B3; Thu, 12 Nov 2026 05:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716CB6B05B4; Thu, 12 Nov 2026 05:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE056B05D2; Thu, 12 Nov 2026 05:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32BCF6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:46:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C423E140543
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:46:49 +0000 (UTC)
X-FDA: 85426138938.12.E40F2AC
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9178140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:46:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R4wf0Dg7;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794480407;
	b=KsfuyppFW2GW0/R7kVldB2QtwwNNjzPDd0naN1y97d8HiV0ZLYIJQ8nSOVbaWKgFuK9REQ
	mFv/MpklY95HS+MEMFJFEYkYbMPC5CR4g/RCirWN8CcQFzOFJ1jFhJprx+g3eNiJTBMSwF
	IRDkGSTFenmKcoe5FbuULTWNh/UI5XE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R4wf0Dg7;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QBtBT+o3rO37DxnYZQOL08ixkrSHvdpIDT59FAHrq8=;
	b=B3tx7B2qFtJRPD04Q2pmGbx4I3K+TixQTjyUyZ5L21l5YUatqxaH1v/yJD9TN5SKHOi9/F
	1ezn3qtjUDMHG9Fy/DioTj7bOPe9rzl5Lx9cYW2eYABm9WFIz2eL1oPYfwXjV9g2V5bZHE
	9j8iX5LW5BvkhTDQRfYcCbK3J0z3umM=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4395d31228so554991266b.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:46:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794480406; cv=none;
        d=google.com; s=arc-20260327;
        b=hh1sV9iH6gou+db9g6pFpFt/VzLqFJRNVm/XBeby5IpH0ooNRootwrYCQMngoA3ZzM
         fISA/liGuN0njlNLiz8IYx6D3qOO6+G4RrKTUHXANX6zRbXD9UW4qn2eNV0l4m9+UPBa
         xrxMj5e+NNOqeZKPgZSfuDP1RuR0fowiW2/0Ja4/orHg0w0upK+l/ftw7AYgmaE6kqo1
         8tEfUveWhKBYJtm/IWDJ/0gTL2eA5Su8k7m/LfK5EWI6Jo3lMz5YY1xTR2fwouhTJcqH
         6aD4OfqBtTL5rHfnUcJFDCf+BgabZVwCahs95RwYnHF1ujTKVjn5MOL2gcwCy8DqfGeP
         /xqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8QBtBT+o3rO37DxnYZQOL08ixkrSHvdpIDT59FAHrq8=;
        fh=KKex3/0Eh9jBgJHjusQtfgcjnBqirMJfhU86RNZmjbg=;
        b=hEZ5QkuSmp1RJ6fwrCQykAcSdaSYd4/mG8/0CdyEp8gKWhhfg/mOUVrAxa9EcCm1Sj
         eBTsESJmE83DIGB7k9jXLBteVmo99rk9yLrKSProAtPAb2vbzbkeDZK+jcKfaFXrr0xn
         WglW3gzrMZlZYh3GA20CZ+dEn44VpvA7e3M1lj5S63SxUnPnBvwGmyoWD9/2Zulud6cr
         TWzKl2CKzjZdKhvz++/Seo+DPt4wpmClRhpu5GIIrvrWiwVCVzfqXTqAsGXLltFILiUx
         t0W7Gy8hagBKCx50Ykygp3lppCccsJmcvwUFC63UIqOxLFy055gzxSFUUBEmOpYIOsgk
         8BQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794480406; x=1795085206; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8QBtBT+o3rO37DxnYZQOL08ixkrSHvdpIDT59FAHrq8=;
        b=R4wf0Dg7CbC7aq5IWatjN0bq/3uSUUJo+djmEt2J5mRtywF+Viv5UCe3+uiHeK3vr3
         4zlLZsi4f+/4MklOvT/flefGED31BmP4AxvHjDc9HvMAJZo+lDStxOMS8AHwAgGo6vE9
         ghBL6QrzwwHxyGtDUcDPRehtEedZAorf2rD5v5qNXqK2QvLu0tr0EvjJl7SyoXJ2ZNXr
         L5mqNswQ9/18/bvoVC45+D9yK5b8Xtg0YK8waxRki17oNqDT5ge+yMO8Q2ZtsNPue2HY
         XYWFU7VeyP+WQ8xBT7EFuObY4dQdftYvyHZfidtpHKLw0WHcrCwvEd4ePjkGqAL216cd
         MvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480406; x=1795085206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8QBtBT+o3rO37DxnYZQOL08ixkrSHvdpIDT59FAHrq8=;
        b=J3B3QEikjQ5n9hWjuebM3MOcEcnFdvU73CHm0nPqd6Z2PsOWgrsxCuGo8GUMcEObKi
         XWcHYWiXtHHf3Lwv3FeAt2huhkRfvGTX47+nG8nyoYHlvSj4Ax2TaEE+GrQcPf0IJ/En
         j9dOXQpiqzSjFfT4ZAv1Tsbu4aZ0ZXOGq7eT3RfvS9l7Rm5UEz6W2IjeRFPIOujJVeFw
         I+IDq6nR0uCUqsNxGH08vtPhjqHJLRe9Ky6u29hP90tL56Owg1qZDbWrNnzEOH/mBgLY
         Z5bqeMXxYACx4gfCP1/U7k6U2yvvWmHWq3/cUGuROB4I+qyACO8YGWrRA+DWc6FLVEDy
         a3aA==
X-Forwarded-Encrypted: i=1; AL+hErH3fMeXp6ozO20hcjxbnJbsRtP37K+ckVHEYCAzi+mSaPPLgEIOxsT2bQzvorqVnic8fpUxbu7Izw==@kvack.org
X-Gm-Message-State: APuU4Z+AQDWsFwrXTUkA2x1a1/991g2NYzqKHkWDjIChC5xGrQ/y3Kvm
	+WCWdPYYpbenXOfSfOgHlYZadHTH+l9xL9/wVqPMGZvPmtZSfjrW6Sspnp3ntU5D2UQNp8ug/iw
	+5tS6nZJVXdCW1G4ZdTWJFqfdFoqJSb8=
X-Gm-Gg: AYBFou3rilqjAG+KV7aVCITINxc698wd38NxuB09qFXlBg+DW+wYkLR2ZdzS/GN97Ri
	iPCZk853lM1gQ0FEeuqWb1G+aqTH5BNmajE1uimKd1qcMTIpHbjJrCGw492skOxwVNCngF8YFCd
	Fh9Pk1rB28d7evKIJ+A3YbXytmlTLji3Jxw4kMt9prTFHrRWhgycFDTMHn0C94e9aOGNvrwUFJt
	HPP3N8s4ui8uGPsnCDVVzxi6kyVMDD4hodLdN03mTs/vlHhSIjcXc+aiJYzAxEe5bdoc7xrWkwk
	Qw7IboZg802NMWjlhuVRcVJg8DgP0i2cFbTjbHvpEWXOXJKK4bY/STW6bEbRnFCgV/zlc52D6eH
	iiTcTa5aNrZQScR7Myyvx8MZ2JSAscHksmd59u9In53iy4ALpnbzOrkiQ82f5qn8a4QFE4Q==
X-Received: by 2002:a17:907:7b8d:b0:c4d:f63:642 with SMTP id
 a640c23a62f3a-c5066d17394mr478995166b.33.1794480406021; Thu, 12 Nov 2026
 02:46:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-15-baohua@kernel.org>
 <sashiko-outbox-210422@kernel.org> <CAGsJ_4ykeDu9XyyiNs9HBp2w--Pm7=oqs0=M5cPiypQ1qq9yTg@mail.gmail.com>
In-Reply-To: <CAGsJ_4ykeDu9XyyiNs9HBp2w--Pm7=oqs0=M5cPiypQ1qq9yTg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 18:46:09 +0800
X-Gm-Features: AclHuK-JjTgqqSOMfmvA3EUP83OxBZ_PwNcD_srQodizlEEwitzYsKZH5muhsqo
Message-ID: <CAMgjq7Cx0Z6mxQXKJN5KfRYbMNMD1qOy4Yrt51prbGz+=2F+2w@mail.gmail.com>
Subject: Re: [PATCH v7 14/16] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
To: Barry Song <baohua@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	hannes@cmpxchg.org, hui.zhu@linux.dev, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9178140002
X-Stat-Signature: udmqhwpt7xe4bsw1sf7pp8zqidojanqe
X-Rspam-User: 
X-HE-Tag: 1794480407-645488
X-HE-Meta: U2FsdGVkX1/NSk2FD9Vc3kX+u8DIpXjPJ/vK0yZvHe3VxS9Jh17To/zVtzT+odaxvzs6C/VUXCY0C7a+/456PjGsIaM+Z2XuaM5cKgrYC3L3TDRXSkIs4mybgwnCIYEGbJRW1kgwb7+TnLYETOooaYhAAdpf/8jMUm4RsQ29lltDz6BmKGuOjE8H1yxlkra2cqZ81k+EjT684oq2siY6dFthQBqexBw2Z+55kHFNJNu870eAGW3H20X+vAt9dJMKss3b6anzIwwegM1PXZN3MxmkAhSaVp+XVLoMXljjhUShR3CI3BVcXytg6hqIsiDqp3ljBGZ8LugqmOnB/pKIuZxcy+DjZeGnfYVGcnGZwbeoBAS1gc4s32SkUBOXjAC8NoNFbgP5+di8gxzpIQe7f6zdLm9SLd1fUkQUjt/3abIDMkJBedUIas6GmP979vPb4H7FCeVCPYACX/P7tSBSeVfVRG8XgX61Fvsh+8mdWYA1OJxQOtNcKsxJCA/jcjr89qS/YRSib1XU+Ze0J/veeTUFMGa0CdqLeHeJJfs2yybmBk6y8Qc6ixA2wHvuEGvwVSRJvcw+xyU69YhbvO6q3ChG1t4ZPYQKEFoTqbdhDPxmuDpgzMgW0YC4bHfxL2PFdWRyI46VjWHsQtVIHm/0t9Rjn+VyGEn87jRoOen3UaLi9/DjZiT3uFNIzUn590/ojIT+tIzrPafFQx8Nzw2OEYATNc6jNFSeaD3xEL7jsDOpAJ4zFeesnwgysxMs4lzPQcMWArTGZM5hcI/e7Y/GGwRIBX8ZAmRFm2cy/rppn4T5cCHw8f1hX6al+DaT1rbOM+wxd0fJ3SPhe2aGHvnRDWUxZ9Ovc2N2r22Wzq1CDpKbP9cQ4WLb+Od2fnrqoOOKAaZhawqk8sU8zWhk2NxdEpq8qZ8J3cOir/WuSn9IJfjddiwPycy7HQqFy6OdAgGiF+PM4tu1Ip807+O/Vnh
 M4oUTeKG
 QzJgLeYB8njYgqpWfI+ZzIwSK8dt17bnGOzXbft0/rIQXhvmxQQpD817KJ4UnjLEwwx2CDw8oX1TpU0guuT/ObhUtPqEUcwtfNlgNsoVWtjAmlmaM/LIz2QjDrRQn1rFKkUQHDCu50Hs8Rv9/9vRJNUG7CKZk1/Nq+1kruWB9ZvYtpPIQ7ZbRXAEzAR8sa/4INjcf4iqp06dSkuquIma+T8b3wtLzs0ofRFw1X6hMfhM3OMIbAEBxFkZlVrRx6fDAzW6IF46hmw8iiIWmoilN+2WJTKapsCwQiCA8SEVb5/3ARCUe5MW7SvvfaviWqcd8fEv9DmXH3jiNNZtsOIUj1Uk3pDE+cAlzgN+JU5gUJaSKs3+ECcKUB2wcTBPZHquA1uNuE19xh6gpDJIW1priN/BHix7jumLTX0W3i8wActLILILdwvV/RZuuYhxypyZzU85/tXpfd/rIygtVbvry768Y61UF4lHQYy67E+nA/6rxoAVLBOF3EzQXkB3f8LVbI4LZM3CsrlDk1U07xdE4XTEQDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 6:32=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issues to consider:
> > - [High] mm/mglru: commit Author and Signed-off-by use handle instead o=
f
> >   real name
> > - [Medium] mm/mglru: zero sc.priority in run_eviction() skews
> >   lru_gen_balance_scan()
> > --
> >
> > commit 8a29a76d461ffd04769caa1f7ed98ca18efe1fb3
> > Author: lyugaofei <lyugaofei@xiaomi.com>
> >
> > > mm/mglru: Avoid prolonged anon reclaim with swappiness=3D200
> > >
> > > It has been observed that swappiness=3D200 can significantly slow dow=
n
> > > reclaim on some machines, with some workloads running 3x slower
> > > under MGLRU than under CLRU.
> > >
> > > This is because swappiness=3D200 currently results in file_factor=3D0=
.
> > > Give file reclaim a small factor at lower priorities, for example,
> > > when sc->priority < DEF_PRIORITY / 2.
> > >
> > > Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> > > Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> >
> > [Severity: High]
> > Per Documentation/process/submitting-patches.rst, both the commit Autho=
r
> > and the Signed-off-by trailer must use a known real full human name rat=
her
> > than an account handle ("lyugaofei").
>
> Let me change it to:
> Gaofei Lyu <lyugaofei@xiaomi.com>
>
> >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 2030c15c06674..a92b14190d733 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4889,8 +4889,8 @@ static int get_tier_idx(struct lruvec *lruvec, =
int type)
> > >   * We don't calculate the scan cost, MGLRU uses lazy promotion, whic=
h will
> > >   * cancel the scan budget natually.
> > >   */
> > > -static void lru_gen_balance_scan(struct lruvec *lruvec, int swappine=
ss,
> > > -             unsigned long total_scan, unsigned long nr[])
> > > +static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_=
control *sc,
> > > +             int swappiness, unsigned long total_scan, unsigned long=
 nr[])
> > >  {
> > >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > >       u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
> > > @@ -4947,7 +4947,12 @@ static void lru_gen_balance_scan(struct lruvec=
 *lruvec, int swappiness,
> > >       file_weight =3D nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias=
;
> > >
> > >       anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * =
anon_weight;
> > > -     file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) * refault_ra=
te[LRU_GEN_ANON] * file_weight;
> > > +     if (swappiness =3D=3D MAX_SWAPPINESS)
> > > +             file_factor =3D sc->priority < DEF_PRIORITY / 2 ?
> > > +                           refault_rate[LRU_GEN_ANON] * file_weight =
: 0;
> > > +     else
> > > +             file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) *
> > > +                           refault_rate[LRU_GEN_ANON] * file_weight;
> >
> > [ ... ]
> >
> > > @@ -5891,7 +5896,7 @@ static int run_eviction(struct lruvec *lruvec, =
unsigned long seq, struct scan_co
> > >                       return 0;
> > >
> > >               lruvec_evictable_size(lruvec, sc, swappiness, nr_to_sca=
n);
> > > -             lru_gen_balance_scan(lruvec, swappiness,
> > > +             lru_gen_balance_scan(lruvec, sc, swappiness,
> > >                                    nr_to_reclaim - sc->nr_reclaimed, =
nr_to_scan);
> > >
> > >               if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappine=
ss, MAX_LRU_BATCH))
> >
> > [Severity: Medium]
> > Does passing sc from run_eviction() into lru_gen_balance_scan() cause
> > swappiness=3D200 via debugfs proactive reclaim to always calculate a no=
n-zero
> > file_factor?
> >
> > lru_gen_seq_write() initializes sc on the stack without setting .priori=
ty
> > to DEF_PRIORITY, leaving sc.priority zero-initialized when passed to
> > run_cmd() -> run_eviction().  In lru_gen_balance_scan(), sc->priority <
> > DEF_PRIORITY / 2 (0 < 6) is then unconditionally true, so proactive
> > eviction with swappiness=3D200 always reclaims file pages instead of
> > preferring anonymous memory.
>
> Well, I'm getting tons of complaints about
> lru_gen_seq_write(), even though it's just a debug
> interface that probably very few people actually use.
>
> If anyone is actually using it, please let me know.
> Otherwise, I think we should consider removing it in the
> long term. Both memcg and node already have proactive
> reclaim interfaces, so this one seems redundant and
> difficult to maintain.

For now I think we just be really lenient about that interface, e.g.g
keep it at DEF_PRIORITY like in previous version

> All Sashiko comments seem to suggest:
>
> @@ -5955,6 +5956,7 @@ static ssize_t lru_gen_seq_write(struct file
> *file, const char __user *src,
>         struct blk_plug plug;
>         int err =3D -EINVAL;
>         struct scan_control sc =3D {
> +               .priority =3D DEF_PRIORITY,
>                 .may_writepage =3D true,
>                 .may_unmap =3D true,
>                 .may_swap =3D true,
>
> But I think this approach could introduce its own problems.
> Suppose we have four generations for both file and anon,
> and users use the debugfs interface to reclaim the oldest
> generation.
>
> 1. Even at DEF_PRIORITY, we can currently scan up to
> lrugen->max_seq - MIN_NR_GENS, which means the
> second-oldest generation can also be reclaimed. This
> somehow violates the user's request to reclaim only the
> oldest generation.
>
> 2. With swappiness=3D1 or 200, if we run out of the
> preferred file or anon type in the oldest generation,
> we can fall back to the other type and reclaim all of
> its oldest generation, as we did before scan-budget mode
> was introduced. With the new approach, however, we stick
> to the preferred type at DEF_PRIORITY and don't fall
> back to the other type. As a result, evict_folio_lists()
> can return 0 earlier than it would with the fallback
> approach.
>
> I guess the only way to address all these issues is to add
> a separate reclaim path for requests from
> lru_gen_seq_write(), with evict_folio_lists() handling
> these requests differently from regular reclaim to preserve
> the old behavior before this patchset introduced the
> budget-based model.
>
> Something like the following, though it would be very ugly:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4fe516d33703..24c6abe37189 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4745,7 +4745,8 @@ static bool isolate_folio(struct lruvec *lruvec,
> struct folio *folio, struct sca
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
>                        struct list_head *list, int *isolatedp,
> -                      unsigned long *scanned_seq)
> +                      unsigned long *scanned_seq,
> +                      bool cmd_proactive)
>  {
>         enum node_stat_item item;
>         int zone_idx;
> @@ -4768,7 +4769,9 @@ static int scan_folios(unsigned long nr_to_scan,
> struct lruvec *lruvec,
>          * newest generation when under severe pressure, so hot folios ar=
e
>          * not evicted as soon as priority is raised.
>          */
> -       if (sc->priority =3D=3D DEF_PRIORITY)
> +       if (unlikely(cmd_proactive))
> +               seq =3D lrugen->min_seq[type];
> +       else if (sc->priority =3D=3D DEF_PRIORITY)
>                 seq =3D lrugen->max_seq - MIN_NR_GENS;
>         else if (sc->priority > DEF_PRIORITY / 2)
>                 seq =3D lrugen->max_seq - 1;
> @@ -4966,7 +4969,8 @@ static void lru_gen_balance_scan(struct lruvec
> *lruvec, struct scan_control *sc,
>  }
>
>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> -                       struct scan_control *sc, int type, int swappiness=
)
> +                       struct scan_control *sc, int type, int swappiness=
,
> +                       bool cmd_proactive)
>  {
>         LIST_HEAD(list);
>         LIST_HEAD(clean);
> @@ -4990,7 +4994,7 @@ static int evict_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>
>         tier =3D get_tier_idx(lruvec, type);
>         scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                             type, tier, &list, &isolated, &scanned_seq)=
;
> +                             type, tier, &list, &isolated,
> &scanned_seq, cmd_proactive);
>         nr_isolated =3D isolated;
>         if (nr_isolated)
>                 __mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> @@ -5177,11 +5181,13 @@ static bool should_abort_scan(struct lruvec
> *lruvec, struct scan_control *sc)
>  }
>
>  static long evict_folio_lists(unsigned long nr_to_scan[], struct
> lruvec *lruvec,
> -                            struct scan_control *sc, int swappiness,
> unsigned long max_batch)
> +                            struct scan_control *sc, int swappiness,
> unsigned long max_batch,
> +                            bool cmd_proactive)
>  {
>         int type;
>         unsigned long batch, scanned, total_scanned =3D 0;
>
> +retry:
>         /*
>          * Scan both types with the given budgets; the caller checks if
>          * reclaim is satisfied after each pass.
> @@ -5191,8 +5197,13 @@ static long evict_folio_lists(unsigned long
> nr_to_scan[], struct lruvec *lruvec,
>                         continue;
>
>                 batch =3D min(nr_to_scan[type], max_batch);
> -               scanned =3D evict_folios(batch, lruvec, sc, type, swappin=
ess);
> +               scanned =3D evict_folios(batch, lruvec, sc, type,
> swappiness, cmd_proactive);
>
> +               /* if it is a debugfs proactive reclaim, lend budget
> to the other type */
> +               if (!scanned && cmd_proactive && swappiness &&
> swappiness <=3D MAX_SWAPPINESS) {
> +               if (!scanned && cmd_proactive && swappiness &&
> swappiness <=3D MAX_SWAPPINESS) {
> +                       nr_to_scan[!type] +=3D nr_to_scan[type];
> +                       goto retry;
> +               }
>                 nr_to_scan[type] -=3D min(nr_to_scan[type], scanned);
>                 total_scanned +=3D scanned;
>         }
> @@ -5240,7 +5251,7 @@ static bool try_to_shrink_lruvec(struct lruvec
> *lruvec, struct scan_control *sc)
>
>                 orig_anon =3D nr[LRU_GEN_ANON];
>                 orig_file =3D nr[LRU_GEN_FILE];
> -               scanned =3D evict_folio_lists(nr, lruvec, sc,
> swappiness, MIN_LRU_BATCH);
> +               scanned =3D evict_folio_lists(nr, lruvec, sc,
> swappiness, MIN_LRU_BATCH, false);
>
>                 if (should_abort_scan(lruvec, sc))
>                         break;
> @@ -5896,7 +5907,7 @@ static int run_eviction(struct lruvec *lruvec,
> unsigned long seq, struct scan_co
>                 lru_gen_balance_scan(lruvec, sc, swappiness,
>                                      nr_to_reclaim - sc->nr_reclaimed,
> nr_to_scan);
>
> -               if (!evict_folio_lists(nr_to_scan, lruvec, sc,
> swappiness, MAX_LRU_BATCH))
> +               if (!evict_folio_lists(nr_to_scan, lruvec, sc,
> swappiness, MAX_LRU_BATCH, true))
>                         return 0;
>
>                 cond_resched();
>
> However, this would make the code much more complex and
> probably isn't worth the effort for a rarely used debugfs
> interface, especially given that we already have proactive
> reclaim interfaces for both memcg and nodes.
>
> So perhaps we should simply set .priority =3D DEF_PRIORITY
> and live with the two less significant issues described
> above.

I agree with this, actually maybe later we can use something in
scan_control like an extra field, CLRU has a lot of special tweaks in
that, which also needs to be sorted.

