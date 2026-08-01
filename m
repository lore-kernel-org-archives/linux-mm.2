Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005E1C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58966B007B; Sat,  1 Aug 2026 02:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C083B6B0088; Sat,  1 Aug 2026 02:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FC56B008A; Sat,  1 Aug 2026 02:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0EF6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:18:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D480120225
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:18:27 +0000 (UTC)
X-FDA: 85051696254.07.8B50F61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FB21180004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:18:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLUXONCv;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOOJhpkv1VdpNyc5aU2dKvgUhW+HxzIMR1wOtifdQ5U=;
	b=5hHayr0pSA2Zt3DhD1Qkhp9IEDM91bLdQ51zFLmwmgM1XSUirQstY12UeLfEO2eMVeecpN
	uuk3A0A5bF8oYNgODfENrG4HmIzyNY7Cc9ed1JNeAHPb5SisnoyNoo+SIGwP5xudiGJHF/
	cPB6yLnSNLUQ/iU0HAUAL6LoA8nRbpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565105;
	b=m6mW51JBqdo9Fo44xwVxNfAuS9DRdFwYVkPO9yqm3FSe6pM4EDlZEndVVmIsEN6XOeRR5h
	35fYoyxMpec+bL42TRsZsjYQtCuIiJMJjv0o5r/eeCiC00LUgpCi0qQ4wb7yoEC6BcHvdl
	vB+0qQhCWAyR8HSEzfgyOiea810Sz1I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLUXONCv;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86F7C441FD
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAE21F0155E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785565103;
	bh=kOOJhpkv1VdpNyc5aU2dKvgUhW+HxzIMR1wOtifdQ5U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WLUXONCvON7GVKh4t/cOGkkmr4g2Jz1XPfTXLqAsxOdGUj/0wmrONuVGxyaQtLN3a
	 mofg+qd3+gRyFzD3XJL0pvjup/J65i4eYciEU6SnVV2WSj+cdtZ+gAOBA5iIGntdn/
	 ufW9RCKTxEaxyxtRsycT4D1GDsUBO/p+IyVakVqafkG6ODDWPbBN3RkPHkR5+al7pM
	 q9c9FgzFnvxm8rEdm2Y75vj0/6WWkkJDSYRLQPM5CgoNlox9WCSgjKUb4NzoTGbiGw
	 ZxcWufAkh+w+KsU9+D7U4JrOU8a2FnWdByFdtqWI22WO8QsSU50u2ITpc41WiHOBnx
	 W1XWTfhaHZyBg==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e6c4a867cso115830385a.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:18:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoEUo8gISeh9uUmeqWPhkcZa2whrAqAtPeeqYFYkYi2E7yxEomjEJhzCAmcF+7Syv03VaLG3Me5hg==@kvack.org
X-Gm-Message-State: AOJu0Yz8xIQDCDwsWNvojJkthiJUgcFt860Swm7AHZJOnEBZKoaz4y/R
	n4yTimQatDQFMKoqwpgcrzN3msfs66bHMev9Nn9jpkLVMach6u58/dHFKiR8bqzB2atVfE6MXOL
	T7qGVLdT+1ZRIzeqic77+YNmccMD5lo4=
X-Received: by 2002:a05:620a:d87:b0:931:57a:8252 with SMTP id
 af79cd13be357-934a08b7aadmr501992885a.20.1785565102587; Fri, 31 Jul 2026
 23:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260731083843.37811-1-baohua@kernel.org> <20260731083843.37811-3-baohua@kernel.org>
In-Reply-To: <20260731083843.37811-3-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 1 Aug 2026 14:18:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xxO-yAxcynYHdbR-PcYUtKQXKMxq9W2xnm7QasEqg75A@mail.gmail.com>
X-Gm-Features: AUfX_my5ZgUcc4zh-_yVbGyP_sFgY7URq9Y5fcNeCdYUxpMGtm-FQ6UHGCJZciU
Message-ID: <CAGsJ_4xxO-yAxcynYHdbR-PcYUtKQXKMxq9W2xnm7QasEqg75A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/6] mm: mglru: let scan_folios() scan both
 reclaimable generations
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, weixugc@google.com, 
	yuanchu@google.com, chenridong@xiaomi.com, zhangbo56@xiaomi.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2FB21180004
X-Stat-Signature: yeatosyg8gpiy6on7nq7foox5aash69r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785565105-791575
X-HE-Meta: U2FsdGVkX19D2m2TK3Re3LeKXQZA/1fN3Whvtvoqr/haFd3CWyC9QpcBVVxFD+ezm+J+wBeqsAIu7FFCZi2KiKnccxAQnO1oBsOM6RvyrxZex+3oAgILrEODUVM9h5NZUkP3OaEPYevGW+JRsJewqQwBWdcf41iUtT2xdTQgJU0LiW4VNk0vVtzCZbP1b5f8WR/SKpR0Q0N5LactjWsUpYNkjTr6c55XaOjebAJEmpRMwb5eCtvjPFXbXR/VR5teur0EuIBLC7ywZ/w8xk6VxfeIwRmNx5F5cfTwFbQFYg4qAalpIGoW53YYGE29TN9LNOaOXRQlmGQsVM3ZySB3gyLjX6JhLA5WX2z476ufvibv/ggjeKJAla/yo0sukIaiSgwNEowErhwHhgMjZV4WKy3jscry6dGAn+MIH2FfVgqod34hhFO0Ua6RBoCejKe7ucH2USyBOKlf6Ri/IiFnmVBz0EQuo6QVjcXQuq/7UyJqIzyFRbYj7fgTzFltkfu5FOhhbpBvWms7R/MaVobpj8rJXOxY5AAJETs5KIHSteOb7jOEqxD3UdNL9IhDOG8JSlYpZmFMOWe5V2qWRpYBYosHq3Xqyy7h8fWgo/6jutL00msHDKn7vI1tQJzUogsF4x7w8cw+5wZeFkkItegA9aFVKEpNI5a4A8QG840o1ovAVupIvvtn5BriVnUEzV0TRt7XOFtUtCDFu41p3IuWu6NvYPiZzr9x1zjC2fmxQKACZ+tLaevOc+fCqGxbNR+aat3Q59Am3fAd10vJaHmruGWkZidNq3AVlDMzV31RPjtY34/li0612pd5I0C/H15Krw4tL2DWWPmoKwkYFMJbKIl1LE+cH3wP2vZSxQz9ncgO2tKqEYEuNLkDCbBJirYZGLgYxSAR2fRvuTfK9MTXcUORW4auV5Xq56vGuCqOBB/RxNr9okFvefJn0hwwGQNa7FeDlDIjqFtq7PSneS8
 J44IWdIc
 qhpu/PIrLk8ytMulCJzCwaMfUdbBFQAW5RTaaOPUfzjL313j3E/x+IVAVfxILKDkb1CXL+kYwBNtscglNlrscI/ybjVS1IJ8GuQ50Qm+8QRC9ZkVTCs1Y13X17eh1gCMuazcFN163XyLw3gGb2rnKlOgpwg9fVADoCgTg8kFZSkQDtLuzmRVi1aRtll1EyfNo0fzC8dj82E1DHkJIwrQn95WLhnJlU3OsnBEUolUPL4sjAYJVWxXN1QYPUBlLemg2C5rPfXY18zzLhPiyy4Dp1ue2pbCKEgVrDeEiCJ9l28ekSVxM6W9SrqaA0QOHOiTqsTZeof+/KO4HH8KR3uFlahhu8hSyUBHnhDKlB2gfZSOgnnP+gMxWDsv7V7ib/84kitxPBc6Nv3i7b4VGzvNJ1csBQ2xZCs1oni76JLTMlTeAM7DzhJaenfPDRI1XO+/UMLzudBsJHPBbgMWtmDmmhWGGXHxBqlpK3yi0y4wcz58qgjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 4:39=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> When we have four generations, and scan_folios() exhausts the oldest
> one while the second-oldest still contains reclaimable folios, the
> current implementation doesn't move on to scan the second-oldest
> generation. Instead, it returns, leaving that generation with no
> chance to be scanned at the current sc->priority.
>
> This doesn't seem right. Rather than breaking out and starting a
> larger next iteration, let's let scan_folios() continue scanning the
> second-oldest generation directly.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ce027c271e9b..31947fa60f18 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4718,6 +4718,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         int skipped =3D 0;
>         unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       unsigned long min_seq =3D lrugen->min_seq[type];
>
>         VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
> @@ -4725,8 +4726,8 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
>                 return 0;
>
> -       gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> -
> +next_gen:
> +       gen =3D lru_gen_from_seq(min_seq);
>         for (i =3D MAX_NR_ZONES; i > 0; i--) {
>                 LIST_HEAD(moved);
>                 int skipped_zone =3D 0;
> @@ -4768,6 +4769,14 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                         break;
>         }
>
> +       /*
> +        * This generation is exhausted across all zones, but the scan
> +        * target has not been reached yet. Continue with the next
> +        * reclaimable generation.
> +        */
> +       if (i =3D=3D 0 && ++min_seq + MIN_NR_GENS <=3D lrugen->max_seq)
> +               goto next_gen;

https://sashiko.dev/#/patchset/20260731083843.37811-1-baohua%40kernel.org

=E2=80=9CDoes this cause all folios from the next generation to be skipped?
When we increment the local min_seq and jump to next_gen, the global
lrugen->min_seq[type] remains unchanged. When sort_folio() is called for
these newer-generation folios, won't it misidentify them as concurrently
promoted?
mm/vmscan.c:sort_folio() {
...
/* promoted */
if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
     list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
    return true;
}
...
}
Because gen now differs from the global lrugen->min_seq[type], won't this
unconditionally return true, moving the folio to the head of the list inste=
ad
of isolating it, and wasting CPU cycles while falsely inflating the sorted
metric?=E2=80=9D

Good catch. One way to fix it is to update
lrugen->min_seq[type] as well in scan_folios():

       /*
        * This generation is exhausted across all zones, but the scan
        * target has not been reached yet. Continue with the next
        * reclaimable generation.
        */
       if (!reached_scan_target && ++min_seq + MIN_NR_GENS <=3D lrugen->max=
_seq) {
               reset_ctrl_pos(lruvec, type, true);
               WRITE_ONCE(lrugen->min_seq[type], min_seq);
               goto next_gen;
       }

But this seems overly complicated, so I'd like to drop this patch
in RFC v4 and instead rely on the outer loop to retry the remaining
reclaimable generations.

The current issue is that when a reclaim type has four generations,
scan_folios() may finish scanning the oldest generation while the
second-oldest generation still contains reclaimable folios.
However, it won't continue scanning that generation in the same
reclaim round.

Thanks
Barry

