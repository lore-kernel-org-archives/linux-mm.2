Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F188B606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MVCvOmDO
Received: by kanga.kvack.org (Postfix)
	id 7DD186B0627; Thu, 12 Nov 2026 19:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DFB6B0629; Thu, 12 Nov 2026 19:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656FF6B062A; Thu, 12 Nov 2026 19:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 383D16B0627
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:22:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F348C0F99
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:22:23 +0000 (UTC)
X-FDA: 85428194166.30.3F69CA7
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id A86A240007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:22:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MVCvOmDO;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794529341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XX5CDk81th6KGJ05rM9qF5DM1I+16UZB6M36vnln6PU=;
	b=SST8O9cBUH/v2+KSpK+0nclmwDBhUL2QkU858lfTkbQwYtsMllxty6abFjrAFa0lrLzjXI
	gizZoBB1Ohf2pXsZ2LCflXV6Dw6tJFFE3azDAxKJkiqCgUXtq4+PNUswvQR90WZZVbBono
	Y9yfmc0oiTJ2WIYj2Fg0HqT8Onb0qPA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794529341;
	b=FwRD8nxWQ0ZsQCScBzxVtroZD29MbuKFfVWRjiVgRWDB5trTN/bTfxk5Z1rZWKes8EcEix
	hrcJf/g+JgOSY3IXLjRt0YzeNxnhzU+Ff4slwTIfU8xw8+tUecrRowVNRMCgskyWMC6SVl
	8H5pC2PMnrM7x/umbPs2Wz6tdiiXphM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MVCvOmDO;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so4693635e9.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794529340; cv=none;
        d=google.com; s=arc-20260327;
        b=j98sKHpgQXwGXYW4egIPdqaGCk7m/OAbbL2MeaMI8Limws2SReNi2zBaxQR1GDzEuC
         eRaj7FKEHfTqa7z/jbNoazO1RLlPM6NAqkeY4tx5Puwi5Ri2BXPhFOb6R4yo+K5Bx3gd
         e3BsZ2oG28oMRP8IsRBXSnBByHo0yxRkZ+hooP0okr1OvpUi5Pfa92HQQi2caDqv8ycQ
         JM8j04CRZ40wn9qERV6GnpMhEY4U5LH4Q61FkEENtDxyDxuQJsFyrtus3gWXcYGJsl7A
         nKh6jqzzogZhSRbXDk097p/q00YiExU6qz0az5jza8lTdPPwh3B3ae5nzQo2fiN0Wi9w
         yUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XX5CDk81th6KGJ05rM9qF5DM1I+16UZB6M36vnln6PU=;
        fh=IaELfy57wdKHJPp3ZmKezQiuCTSYFYOX3OHsaPB98o8=;
        b=cbK/G/NlHup8FttS1STAmxmsLUMu4OIxp3yXwJ5Og+GSTceCg37dK+FTSu2g+qy3go
         uHaxTFyR09bSYykLgqTF9X7PhGrUnxGwyR4MMCUTKkn/oLlTIxAlpcJGzEtxhu6nZxAI
         //+lprAIABTZnwlZnw8hA5Jyr591a/wOqYy5p71dtIfJa7WcrthNNzQ6g0fzGp54YMuD
         NC5yZeNuklviDx1kIFEXBUqcHj3LiD9vE3MeMVpk5vytS8fU6s/FLkk6G1y1Si6IsjqD
         rFzDXUsN3k8r0KH+t13RyovbvYFKC8LYkluiBNefmttDjOsNVN2br9JNophIi3RFSmP/
         W0YA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794529340; x=1795134140; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XX5CDk81th6KGJ05rM9qF5DM1I+16UZB6M36vnln6PU=;
        b=MVCvOmDO4Kl5nMldmo8tbF+aZh2yvAWlU02IXQrTGOIFAmSTvoCUC6Xgu5/kPd9iMV
         p0whsh5tLKuKYw1AOFZp+c3L9tzkrZWeqteEy1FeHu6iWpe9nbjosJuf7S5a66ZrRSSY
         NphrH1eWJln8Eh4v4q0jYTIst+aEQ0MqkV0/Gx23mgduZD76/twQ8viQsUt3d3cNYnk2
         YiNbPplEya5ABl5FC9sEMNjD8BSWxegFrRPzvaH0tU8kosmQIwSDxCMxN+wqzhzsnLNp
         UEk1v7i9LNii63el3x9J2V9UbbwF/zBHmud5ORckkV22xTjp4o9KmKOXiqDSitfkxN/r
         CiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794529340; x=1795134140;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XX5CDk81th6KGJ05rM9qF5DM1I+16UZB6M36vnln6PU=;
        b=Bc3L/6M0aSVedBxWfhhifEt+HJ6G9QAHjnx7ij7FVQAAD3v1luvbWi+J4LRxHDEtgC
         Beryr1tOnMoA0riDg1kOlGyZ/fEYW9klwgPp8TXLzNApx3ktRIJ17OvaDMSQWr+3S5Yx
         +PAqRPxeBES6qkE2l8gIN6D9vnN6RHvhn5og46Zqcd+oDhmW0w/qZ3pBHQUInLzWoRXN
         PmxcrNhVoJ1miassROFEVRNnq7GuDNQmIWApW0JoIqhg/pte+pjC2ZwBeyms5vxE7O4M
         t60eqdhnZc1GxW4U4Wx3UdKKHZr8PeEM1f81wjexzA3MbJ7k+Cvr+4FVCMsJOZEtTU6M
         V40g==
X-Forwarded-Encrypted: i=1; AL+hErGxDtQywCdXT61rtCko9nthVLU1yCqCOYZcMHbA4TgNqxcHa5wG9fyL5maopbNEa0+pU/qO9Wy7LA==@kvack.org
X-Gm-Message-State: APuU4Z+QT7sELqM9GZgiRuW3GSEjz3adPeInwL0vyKPPRugZ3u/Z3szS
	mYvR4ChIlss0B8hCgLf9zfHTrWWw36v/PkzKgDKjYWasjc7/d3REB0y6v6DxD1QyQDqEcGbSXJT
	A4rHpNjFt9X2BrMP1cDoH69ASAr9BifQ=
X-Gm-Gg: AYBFou3TeDpOkCJ8p5qIrfzCPFhyTKiaPRuHO8T1rzYU+vGaTrZ//5q508+kA5Dsyl/
	dpRqQ63mHBJPDx4B/BRTq0i5RNuKjwyqN+ybsNt3ZSfsiiSJxNaRlElSN+ADlSPDsCyfk6PrG1r
	kAg75JYVc6ybXKnj6x647jsIwUroTfC7dJxjYQBOoetYxovyN2Cmloq9mkYWG+S3jxqVVkqdZm9
	R/MnX6Ua4jZB5xxv+58Jhuf0SQ35D7G0HYpw4nK1QL/+NgQn2Rm71M6+TWwG64kzj8DkGkvRN+k
	bcQYMPdliOJRMUO8Fi4dPIL2K/eZSOZP3yg7z5HLSGvH6hczhg9ha+JWBzEnSVGPpmJpH/YMr2F
	2Cw/4lwit14dKVDp+OiDoVEuIgsjX8qCUSo8C8TgdutDL71J+VVrPWGrUhaCmNWWyrGaW3QjNYU
	Paz3UpLTYS194y/TyS5QnQpWj/je/5HJx3ypqzC5Y=
X-Received: by 2002:a05:6000:2388:b0:48c:414f:cc12 with SMTP id
 ffacd0b85a97d-49c72306b9emr2108990f8f.40.1794529340174; Thu, 12 Nov 2026
 16:22:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-3-joannelkoong@gmail.com> <sashiko-outbox-206041@kernel.org>
 <CAJnrk1aQrRE78wqd2yZWS2Sk8MiCHd9x0dveZBh5LHE5w75nkg@mail.gmail.com> <avSqMxGjwYPrQLlV@localhost.localdomain>
In-Reply-To: <avSqMxGjwYPrQLlV@localhost.localdomain>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Nov 2026 16:22:08 -0800
X-Gm-Features: AclHuK_k_bmCepdQWwN9flpYp_ThMtbbs9t9wCfxy4WdI4tskUDaThwNWD8_PFU
Message-ID: <CAJnrk1YbqyCfA26M184RWL__vjo3G=_MJ8k-AEf8vCqvKBsmew@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node counters
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	yosry@kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, damon@lists.linux.dev, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: numtqqpw9sg5shsj7k7bh6dugx7jton4
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A86A240007
X-Rspam-User: 
X-HE-Tag: 1794529341-464817
X-HE-Meta: U2FsdGVkX18JKiBohNAiUW3CVvFV73kDKNljbZurJh7c0iZMZBAERZWeb3d1NDeqTDRj907/1KUWzQEqTq7UfYKHdtWY7XfBQJwDHAURNYJ0HNtumly6kz4Y+6YbYCNcbJqqwAWgU2/QliyS7K9WKJvSBl8/4nUCWMKcKQidZuUzemiA/qP6d3QAkMMH3pnGlChaciwPuYoZLkhNQ9UpBpwOs/Nq5syrPQca1m+qknq4k+0/h10fyR3yeo/v6Qt6oAbq6EDlLmTjLiZHkNRhZByK78axJOx0INGplDgP6dIa3Mr8S09nl2lOE6qwAtXBamN5vS5lEWSEqT+rivg/01ku1UAGT6Z1nTcVbU9SDixPbarlA4TqGfWII5A0xCARR7fjtCQtiTPl/1n4TB8FdLsqTQdRdoRa+4lYvzpKxTOuQh17TzWPcJZ55khGmf4gIGrY7Fh6cjrOsE4nKp5xppXZarNOC4GHQeQYXkbWbqN3nw8VOY3ZAV7ARB3AMpf5mEAYPv3lRva4cu9sDUTV2jAGm6Tv917gnOZFIDWKh5aLW5PXQTCeuLW9bZt3CK/CYoXs9FLalUHcElmgd/vkT0nzmbenZotWeGdYcqQgObIOf4DsMaazfABYMW50aXB+EDyD0YwzqGb2KiikWNeX91tCatLEuGJM21inEJR9QhMRYlvf2FVeCEInmKcue+/ICcu+AMo8KIaNxvW6p5KHOqRs96NAlodJ2jHyQEzU8aY0nOaJdWYUqT5YWBC8A4AKdoSbADQLB8LvjWkecJ42Y6hMzYIFDfWOeB6AqQyzOnehLOzRzfFdlbgQdvdwNiNy2vL9NgetyS/t8YphLCDIWz3L+Tn895ihFSOKp8TEMA/7MAUcve5+de+96/F3DKMJWQjD6ip4NIO24Vocz+Q+qk42x0BMYx13mMxObQaAu5miPsHcQ32DOlkhJZXdzqMkeqnnd97ywpR8Htadgnb
 ncWaf5OE
 m6LNpkAkaQTA3UNC2BxoXd/UPQQ8O5XJ2CGG9w0BVhkjdjSVSkXxs9BAuQLky3LG4K30761XwXIKeSQGCl3lcXALmlACVaAR9m4g+MccB9b0PnvhlWv/CRsFUYSZDnQBRJyz6MBiNvdQlaAM5AYO35YkzSv78qFfRjjK4tCMCT8CL3DxiHxu85AOnToks4mvqq2qAvk/t214Y65Fdgg815f1OvGQSwyBzVNPlnH7SKaIDPsEbHWq4qUpNYKAIaumKt+C8KuqqWA0Tp1hUs7dGkmZ9uNmCLXE/oO3NmNCDMlZfSJfHAxhebadA7Was+VoP++W/iDNZFZFl1D2ntPIXOInh2Ywz6ksUAeqSCH5gcMUZrf4/C+BGZ1zO3RXBM0pJ8V2/GIWZILY/1C3TbVFKj2O0evKEo1oArAqRCKWBxpDI+oxzJrPwrtehxnARq0AD0x3E98xd19DtOi43wMkF68EA73sQ0ysKTqf6nhULbyMl+Oea+KENp6DTl0ciBq51ibvnn3RSqNTfmGQV+afqvZDYXi1WGQzKFZWQPhf3pw+N5Rg89Nsai/HnqQb3bph4QpaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 9:47=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Tue, Nov 10, 2026 at 03:10:54PM -0800, Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > On Mon, Nov 9, 2026 at 6:23=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> > >
> > > Thank you for your contribution! Sashiko AI review found 1 potential
> > > issue to consider:
> > > - [Medium] mm: memcg: node_stat_includes_unaccounted() omits file and
> > >   writeback stats
> > > --
> > >
> > > commit d2ba314724a8ba015e3bf2a30f155f1beba25a8c
> > > Author: Joanne Koong <joannelkoong@gmail.com>
> > >
> > > mm: memcg: read root lruvec stats from the node counters
> > >
> > > This commit changes lruvec_page_state() and lruvec_page_state_monoton=
ic()
> > > to read per-node vmstat counters instead of rstat values for the root
> > > memcg when querying stats that only track memory charged to a memcg.
> > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 1ebc9330aeae5..2575bf2ba0ea6 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > >
> > > [ ... ]
> > >
> > > > @@ -504,13 +511,52 @@ struct lruvec_stats {
> > > >       long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> > > >  };
> > > >
> > > > +/*
> > > > + * Whether the node counter for @idx can also count memory that is=
n't charged
> > > > + * to a memcg (eg kernel memory that isn't accounted). For these s=
tats, the
> > > > + * node counter can be larger than the root memcg's value, so the =
root memcg
> > > > + * has to read its rstat value instead.
> > > > + */
> > > > +static bool node_stat_includes_unaccounted(enum node_stat_item idx=
)
> > > > +{
> > > > +     switch (idx) {
> > > > +     case NR_SLAB_RECLAIMABLE_B:
> > > > +     case NR_SLAB_UNRECLAIMABLE_B:
> > > > +     case WORKINGSET_NODERECLAIM:
> > > > +     case NR_VMALLOC:
> > > > +     case NR_KERNEL_STACK_KB:
> > > > +     case NR_PAGETABLE:
> > > > +     case NR_SECONDARY_PAGETABLE:
> > > > +#ifdef CONFIG_HUGETLB_PAGE
> > > > +     case NR_HUGETLB:
> > > > +#endif
> > > > +             return true;
> > > > +     default:
> > > > +             return false;
> > > > +     }
> > > > +}
> > >
> > > [Severity: Medium]
> > > Should node_stat_includes_unaccounted() also include NR_FILE_PAGES,
> > > NR_FILE_MAPPED, and NR_WRITEBACK?
> > >
> > > For NR_FILE_PAGES, swapcache operations such as __swap_cache_add_foli=
o(),
> > > __swap_cache_del_folio(), and __swap_cache_alloc() update NR_FILE_PAG=
ES
> > > only in the node counter while accounting swapcache in the lruvec und=
er
> > > NR_SWAPCACHE:
> > >
> > > mm/swap_state.c:__swap_cache_add_folio() {
> > >         ...
> > >         node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> > >         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> > >         ...
> > > }
> > >
> > > Reading node_page_state(pgdat, NR_FILE_PAGES) for the root lruvec
> > > therefore includes all swapcache pages, which inflates the "file" cou=
nter
> > > in the root cgroup's memory.numa_stat (double-counting swapcache alon=
gside
> > > "swapcached") and causes it to diverge from memory.stat even after a
> > > flush.
> > >
> > > Similarly, __folio_mod_stat() -> lruvec_stat_mod_folio() updates the =
node
> > > NR_FILE_MAPPED counter without updating memcg rstat whenever an uncha=
rged
> > > folio (folio_memcg(folio) =3D=3D NULL, such as a driver mapping or a
> > > root-cgroup __GFP_ACCOUNT kernel folio) is mapped into userspace, and
> > > nfs_folio_mark_unstable() and nfs_folio_clear_commit() update
> > > NR_WRITEBACK only in the node counter for unstable NFS pages awaiting
> > > server COMMIT.
> > >
> > > --
> > > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/2026111001532=
1.611093-1-joannelkoong@gmail.com?part=3D2
> >
> > Thanks, this is a good point about the folio stats.
> >
> > Hmm... I wonder if we should go with an allowlist instead of a
> > denylist. The allowlist is longer (31 stats vs 11) but would be more
> > resilient to failures (a stat missing from the allowlist just reads
> > the rstat value whereas a stat missing from the denylist will silently
> > report the wrong value) for any stats added in the future. Any
> > thoughts?
>
> I agree the opposite predicate would be more robust and potentially
> easier to review (review only the _listed_ cases, not the "unknown"
> complement).

Hi Michal,

Thanks for taking a look at this! I'll switch to the allowlist for v3.

>
> Also, instead of
>
>        if (something && !mem_cgroup_is_root(eviction_memcg))
>                 mem_cgroup_flush_stats_ratelimited(eviction_memcg);
>
> I'd consider
>
>        if (something)
>                 mem_cgroup_flush_stats_ratelimited_opt(eviction_memcg,
>                 1UL<<NR_ACTIVE_ANON|
>                 1UL<<NR_INACTIVE_ANON| ... );
>
> and collect the exceptional handling in memcontrol.c:
>
>         void mem_cgroup_flush_stats_ratelimited_opt(struct mem_cgroup *me=
mcg, unsigned long needs)
>         {
>                 if ((needs & ~node_stat_equivalent) =3D=3D 0 &&
>                         mem_cgroup_is_root(mem_cgroup))
>                         return;
>                 ...
>
> This way in-kernel flushers will be expicitly annotated so that
> potential mismatch is more obvious to spot (and it adds possibility of
> future optimizations).
>
> (This is all only a concept, it may turn out uglier when worked out to
> details...)

I think there's a few cases where this doesn't map neatly
unfortunately (eg global and root reclaim reading the LRU sizes of the
root memcg but still needing the root flush since they also need to
read the rstat values of their children memcgs). The mask would also
have to be a bitmap given that node_stat_item has more than 64
entries, which makes it a bit more cumbersome.

I wonder though if the same idea could be conveyed by having the
callers use a shared helper function like
"mem_cgroup_flush_lru_stats()" with the root special-casing logic kept
in that function in memcontrol.c. Then the call sites would look
something like:

  if (flush)
          mem_cgroup_flush_lru_stats_ratelimited(eviction_memcg);

instead of

  if (flush && !mem_cgroup_is_root(eviction_memcg))
          mem_cgroup_flush_stats_ratelimited(eviction_memcg);

which seems easier / more coherent to read. I'll give this a try for v3!

Thanks,
Joanne

