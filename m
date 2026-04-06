Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67014F46C79
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986416B0005; Mon,  6 Apr 2026 15:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9371D6B0088; Mon,  6 Apr 2026 15:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825866B0089; Mon,  6 Apr 2026 15:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 700786B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:48:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A7788BA22
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:48:12 +0000 (UTC)
X-FDA: 84629167224.24.F2492FE
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf20.hostedemail.com (Postfix) with ESMTP id EAE791C0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:48:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aXV3sGKL;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775504890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+p9huaeZyNc20m6cFvaCZ1I+Q193UaM95oPQNTrZk8=;
	b=GkHxtriV5pQ+2oK3H7R6AMJo/CtBoGi7qB470eNMBqJFqlUJFypKfnAdS4WU637uQmUX/A
	J0uDhuJfXzEQnGHMFcP4ZormxmJhIUoD0wXd5kv2vFq/5dmWEzOADqntvvnMWLbDJrXEGD
	qRePR4ulTtTXjTJDohHhJRdtDLz15xI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aXV3sGKL;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775504890; a=rsa-sha256;
	cv=pass;
	b=FwFaE2tAjNloCN/Cz9GCpDYZ0PdC8lcKkpgs7H8kYmtGVS9ES/dyTlMZQyj0FoHwtavDp0
	aCwjxrgsMrHaTSnLYki3P2NVKsv6/HpCexYEHgHZM/k7RdYYRY1QxkVrFGWSrcAWbP1xZa
	F8zkkJIjYgNa8fwjvix4WO3uG4Gx3uU=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-12776bebe9fso9830286c88.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 12:48:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775504889; cv=none;
        d=google.com; s=arc-20240605;
        b=bEytj61NbWUgvXgAetcqwCb13GDE2vNDw9KTTYD9YqaRIr0BY7X/G8TARzboneRKna
         3zziX2B3NXvkm2HHDD6REfiUK6AlPYX4XozS6qIJqyuVzOiOc5adVraPaSnkE9FKVnoV
         7uBrMWovgFGHCf5AQIXJaZCZHVVynB5gm5ggHHO7CetzYzJrr0s8rkkciJeb62D54OZo
         a8Yswywy789baySFsLuDFDCVgt60IJ9vtjE4LQdz5DUGQX13RxRbVkLD6UCdoCaEUwBV
         xo8jyvdTrnxfmGGidQHiKUhfQ6GDPZud3tsXEMsh8VVg/hXXcSrat8BuzPjx391ry6Ev
         bTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n+p9huaeZyNc20m6cFvaCZ1I+Q193UaM95oPQNTrZk8=;
        fh=8LsvrT5SV08SLkqkSHiA5lkyCnKT2E5X6YnuY3AFFHw=;
        b=eiPzyyS/ynAUtuyrSCoKrj8R5ovvsMV7q95m7re+U4hbmJMgIED4xTbVxaG5IkkmJf
         BFQji2kol933mFpnfJxZkIziLOTuWQAWwslbZu7sAR0vqfRTxdzmeFzkTc3NF+xEMrUK
         PRlmhlHkz2ggmQflvVRUJWMSNUGUNnmx76npljx5Ky0J0CIvu+f3TkJRFOgwTUv46x1V
         26kaIWUQyJJO+FiXJuKe1SubCYh+Ghw+Ar0yTTdWWH5u/JvS8J7LbTFUJtodzdEQfO4u
         17GKUOFkporiO3IRMsGNI257FTrtuYGen0rY/JJxgw3HyzIvfKBNtmR4ONO/1KHCQt0R
         mnSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775504889; x=1776109689; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+p9huaeZyNc20m6cFvaCZ1I+Q193UaM95oPQNTrZk8=;
        b=aXV3sGKLlqQvvMAcYPivB1Jb9MQr9wUXuVggDcatqv4O95j9+Wk32nxAM+flc1NLI2
         gC6vVzyFnxAotkBniQtPMr6vuFQJ72sgOJ7fg9Z5swTNfygL/R7Ny4Kt3+OnPPkLaKuZ
         CunIvBWDNYPfYArCXmzlezugRauO/0/vAK85PoYS8qh7h4pdaXiYaqR6E15f6D66zlVt
         wcyRT+dPhLATIXK5cE4M1/IumcCzw5Tozr1grPk9cFT8FqeLC4qiJ0NKVPK9CjFndxxZ
         uSNAZvSLPh/D1yFXFTddkpIUemVm6V5ie1sD5b78XINC2Jd87lDGxoAgK9ncaSuuZ20D
         rrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775504889; x=1776109689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n+p9huaeZyNc20m6cFvaCZ1I+Q193UaM95oPQNTrZk8=;
        b=Bc0OC+XjI5Figd5gA0Ro43w0Td7T8EeuNevaLolhQxfnwK7H6sx3fbIcxppZ2Nz4Ze
         8Ae6E9l0CyZ1ECKuqLYgoXXNWjs8qpfrGgAxfDizn5fwOf9vV8JhPltNL+yIdJvTmIdP
         WgvVBdwrVFgzNTbm6a+dXN2XULWnlGLJSmHlBHf4UWdQiH5BHExQqbvK8TzwEWmib+qz
         NNSHOcCGdQ20lZiWpm4WTxP1FAh4/ZjBaGn3Y3/3v8SM0ra7g+IkJiYDnzpgLUSM7Eau
         N+NjsWr8Zq8Q7flYVItMl/vbkBL2E7yXV5Yv2EKI7vVxudg/9UdEPMOZhVq4ph/6uUQI
         ONzw==
X-Forwarded-Encrypted: i=1; AJvYcCU/96J2m8YzRIqj3mx0b9mowcCnzXQd0UFHBKBa21sAtjoLjajmEU7o/0U0crZkWwW+82C5/duISw==@kvack.org
X-Gm-Message-State: AOJu0YzmgpJ5zjNaA9GL93OlrjY7sxG/eQQLKAz9ol8/oEHiof8t0nCM
	GyUn/xIB87taqkQj8rfDvCdnACC1JW63lO5L5BcHv9n3fLIAaLzsmKnCTlR374vUoLQOHu6x7e/
	mgJ4pAcsK/DBPNN0gZDxby/DK3TGejQ==
X-Gm-Gg: AeBDietF0Xk1/xnZS8+yuEPPTQu3FomQ2gr9uxUe4UlfuNPYEeUVdNVPTxRHxznKM+e
	0H4r/vkRJriH57U/9YTOuRsAcIbyCN30OJj/hogGbNajIfUPjcNkgzhLPHYlaloybZtPDaAMH4t
	KRSm6gr5oO4C1EiiE6keGDbPG5Jo4XOrAAVMsckAScwIKaZ+0Enj1wWFzp58MtiDnb/aWxjzHF6
	Fr+G3OXOhOKxNG2jyilwWcsLswQpQrlXg8Pwv7bpdtIaRVY9ehQq3NnA6KyEoQteeL2szHmILP+
	ZQJ/0b8=
X-Received: by 2002:a05:7022:ea2f:b0:11a:e426:911a with SMTP id
 a92af1059eb24-12bfb70b6aamr7852006c88.15.1775504888403; Mon, 06 Apr 2026
 12:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260405184247.2690-2-ravis.opensrc@gmail.com> <20260405224550.76218-1-sj@kernel.org>
In-Reply-To: <20260405224550.76218-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 6 Apr 2026 12:47:56 -0700
X-Gm-Features: AQROBzBpPbsPlwve819G7eO28GC1duFxJHiGRdlflbmAq_VezuBZJYhpR-us9Gg
Message-ID: <CALa+Y14oWqu5+DbkENy7GgBjc=dCbFTaoOCr1i4=9CN-ZNRgEA@mail.gmail.com>
Subject: Re: (sashiko review) [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp
 and node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAE791C0003
X-Stat-Signature: gueaantgawzr71g5b8gghoks8rx9d3jj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775504889-22752
X-HE-Meta: U2FsdGVkX19xSfWTQfIyKqd2E3jdoizgaDnVutjZxkxq9esQ/z4D1YQFgwFl/JbJGsDW60As5Gz1i3RciXKV1MlPMDI2/pPt7V0AKs8KwvVftCdRBs53oRt2k/9q6dgdc4RB8ndPf3Dk2fRmzzLo/+3DYDuUdui0SZ3iDhGdYFrXnmk6DE8Fw8oiXeLB+Jw8ruwv1F14OHm/O/RaveHg38pV2j5v4pKHATjKo7t2AaZm2piKZRJubkof7X4TmC74E1sHuzboor6kNdkkszJjbNIEFkGc6SF3EWZaTyZj6RHAV+wuvdXTOUuh5daH8zCJXIalGS39N5TepyV2/vNX97vXzW3IpfkEATXlU/aPVhFH6ucIIY5c4vbN6hO/Xi8LVuh6M6AqVrqeYjomj447fQQOygNIUEWA4QOm6UsZr5i/4zT9CK+Y25RJGGFuyo7mCgOP7hPlpO+zD1NlvmyfFgXulpyrfeBOD6y2b22BZt3dJpVTkpFhBbfs5U3n0St0Ex2l9+cMyvvemjk141EgVFOdBsdjC1fM/wwXb5tUWQeICIl88PS/5SkQxLw6+ATG/KbWllhHT4DscqWZ9en3nZ6agALWOUnsKXDeIGJZtaHgEjeEKh1jrWfLOvo4OLBNsx5hBCMJejRhllmKFBR0QYszeSOjC547O6z2tRu6htjJ+ZaU89dHt3a1zc4VvWgipLVA3sFFsD5jBDlHB3NWYhw4FAHXbIyFkPMFTPge+zWPaSufUf1qJrPTshyUZzkbmyPsQ3PlYDcVWjtc3V7aJOqlH6UYrpsVme5k22lOBEN6QmykODt7ibJLulNlXG/X3VVTvC4HcupERmoyPHegrxsDVdLPirI25onIaNtcKPg+i7C6sjIGDjAmnE5G5yyIci/GzUPKst/uIhZeOHpr/9663EbCLkbvf6sJfmyTiaKtzCFGTOzrfIzSYfb4yC0noHG54m75eg30BP+LAhU
 0xfldrTD
 smZUDie6atOJc/6QLZ79sxiAVcux91Wofw9rqj9Ha1OMSZD7RNFrZb8F+beIqrkReX060o60upPUtuRAWOGqRvOTD+YZE10HR7/d4t2DKp55EwhMTHIV9K99AC8jZTy/6ldq2rsLNw4l/zEMPds4n4USVJZ620zIIvn0ZIJiBY/Ojt4QpLJjrjfqNJDdK6T6ZFmqYaBC5KeleZ9rE44CIFpRGEpxJVZSVkamBah8TKg6aRf+10CSXjWbPtFyKR25uX66juxFZf7+zNmghgnM+2fw4jQic8L8dd5kCLp2ZZ3fxOybut+03453eHP9UNKbVHNHUQdfDk/DGkVE/88GxqR4LqW/NbBUzeprrDYAZ78wRs8EYjpZTaCKnXWmRV+t1Vus4xif3nCu51rD80YQ2hFsgVCDNQg4t7I2KxSBTVXxwQS98QxS3r6D1YH3hjxFC3BnqQo4Cm+501edmrBNkZPC+x4DhBRIAkM0WQjUr5j2E6mcs8MYuc6fJIR6sDMK0Oq9gCyHOvrzZN0gof0k2ttKb+YsVegAnbQPsGPOL2cNl3Z46p/WumurYk7EKjmysc92ehQ9+DoMfhZXRz/oZNokYR6w1dOLinasaVAQKR8rPNuBFzLLWc9+VT0AyakPhhIve
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 5, 2026 at 3:45=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
>
> Ravi, thank you for reposting this patch after the rebase.  This time sas=
hiko
> was able to review this, and found good points including things that dese=
rve
> another revision of this patch.
>
> Forwarding full sashiko review in a reply format with my inline comments =
below,
> for sharing details of my view and doing followup discussions via mails. =
 Ravi,
> could you please reply?
>

Thanks SJ, providing your comments on top of sashiko's review is very helpf=
ul.

> > # review url: https://sashiko.dev/#/patchset/20260405184247.2690-2-ravi=
s.opensrc@gmail.com
> > # start of sashiko.dev inline review
> > commit 5f6ea8da06d136b84d97827777acf2b07047d42c
> > Author: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metr=
ics
> >
> > This commit adds quota goal metrics for tracking scheme-eligible and
> > ineligible memory distribution across NUMA nodes. It iterates over
> > scheme-eligible regions and uses damon_get_folio() to determine placeme=
nt.
> >
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> >
> > [ ... ]
> >
> > > +static unsigned long damos_calc_eligible_bytes(struct damon_ctx *c,
> > > +           struct damos *s, int nid, unsigned long *total)
> > > +{
> > > +   struct damon_target *t;
> > > +   struct damon_region *r;
> > > +   unsigned long total_eligible =3D 0;
> > > +   unsigned long node_eligible =3D 0;
> >
> > Can total_eligible and node_eligible overflow on 32-bit architectures?
> > Since these accumulators track raw physical bytes, regions spanning mul=
tiple
> > gigabytes might wrap around the 32-bit unsigned long limit. Would it be
> > safer to use u64 or track the counts in pages instead?
>
> Makes sense.  Ravi, could we update these to use phys_addr_t?

Agreed. I'll update total_eligible, node_eligible, and the function
return type to use phys_addr_t throughout damos_calc_eligible_bytes().

>
> >
> > > +
> > > +   damon_for_each_target(t, c) {
> > > +           damon_for_each_region(r, t) {
> > > +                   phys_addr_t addr, end_addr;
> > > +
> > > +                   if (!__damos_valid_target(r, s))
> > > +                           continue;
> >
> > Should this loop also check damos_core_filter_out()? By only checking
> > __damos_valid_target(), it seems memory explicitly excluded by user-def=
ined
> > region filters (like target ID or memcg limits) is still counted as
> > eligible, which might inflate the total and affect the quota tuning loo=
p.
>
> No, we intentionally defined "eligible" based on only the access pattern.=
  We
> may be able to extend this to apply filters in future, if we find a use c=
ase.
> But, for now, I'd suggest keeping this as is for now.
>

Got it. Will keep it as is.

> >
> > > +
> > > +                   /* Convert from core address units to physical by=
tes */
> > > +                   addr =3D r->ar.start * c->addr_unit;
> > > +                   end_addr =3D r->ar.end * c->addr_unit;
> > > +                   while (addr < end_addr) {
> >
> > Could this unbounded loop cause CPU soft lockups? Since DAMON regions c=
an
> > span hundreds of gigabytes, executing millions of folio lookups sequent=
ially
> > without a cond_resched() could monopolize the CPU.
>
> Good point.  Most DAMOS action implementations are also doing cond_resche=
d()
> per region.  Ravi, could we add cond_resched() per region to this functio=
n,
> too?

Will add cond_resched() at the end of each region's processing.

>
> >
> > > +                           struct folio *folio;
> > > +                           unsigned long folio_sz, counted;
> > > +
> > > +                           folio =3D damon_get_folio(PHYS_PFN(addr))=
;
> >
> > What happens if this metric is assigned to a DAMON context configured f=
or
> > virtual address space monitoring? If the context uses DAMON_OPS_VADDR,
> > passing a user-space virtual address to PHYS_PFN() might cause invalid
> > memory accesses or out-of-bounds page struct reads. Should this code
> > explicitly verify the operations type first?
>
> Good finding.  We intend to support only paddr ops.  But there is no guar=
d for
> using this on vaddr ops configuration.  Ravi, could we add underlying ops
> check?  I think damon_commit_ctx() is a good place to add that.  The chec=
k
> could be something like below?
>

I plan to add the ops type check directly in the metric functions
(damos_get_node_eligible_mem_bp and its counterpart) rather than in
damon_commit_ctx(). The functions will return 0 early
if c->ops.id !=3D DAMON_OPS_PADDR.

That said, if you prefer the damon_commit_ctx() validation approach to
reject the configuration outright, I can implement it that way instead.
Please let me know your preference.

> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1515,10 +1515,23 @@ static int damon_commit_sample_control(
>  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  {
>         int err;
> +       struct damos *scheme;
> +       struct damos_quota_goal *goal;
>
>         dst->maybe_corrupted =3D true;
>         if (!is_power_of_2(src->min_region_sz))
>                 return -EINVAL;
> +       if (src->ops.id !=3D DAMON_OPS_PADDR) {
> +               damon_for_each_scheme(scheme, src) {
> +                       damos_for_each_quota_goal(goal, &scheme->quota) {
> +                               switch (goal->metric) {
> +                               case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +                               case DAMOS_QUOTA_NODE_INELIGIBLE_MEMPBP:
> +                                       return -EINVAL;
> +                               }
> +                       }
> +               }
> +       }
>
>         err =3D damon_commit_schemes(dst, src);
>         if (err)
> '''
>
> >
> > > +                           if (!folio) {
> > > +                                   addr +=3D PAGE_SIZE;
> > > +                                   continue;
> > > +                           }
> > > +
> > > +                           folio_sz =3D folio_size(folio);
> > > +                           /*
> > > +                            * Clip to region boundaries to avoid cou=
nting
> > > +                            * bytes outside the region when folio sp=
ans
> > > +                            * region boundaries.
> > > +                            */
> > > +                           counted =3D min(folio_sz, (unsigned long)=
(end_addr - addr));
> >
> > Does this accurately calculate the remaining bytes if the region starts=
 at an
> > unaligned offset within a large folio? folio_size() returns the full si=
ze
> > of the folio, so this calculation might overestimate the eligible bytes=
 by
> > not accounting for the initial offset within the folio.
> >
> > > +                           total_eligible +=3D counted;
> > > +                           if (folio_nid(folio) =3D=3D nid)
> > > +                                   node_eligible +=3D counted;
> > > +
> > > +                           addr +=3D folio_sz;
> >
> > Can this pointer advancement overshoot the end of the current folio? If
> > addr was unaligned, adding the full folio_sz will skip past the beginni=
ng
> > of the next contiguous physical memory folio.
>
> Above two points make sense to me.  Ravi, could we fix these?
>

 Will fix it. Will calculate the exact overlap between the
 region [addr, end_addr) and the folio's actual range.

> >
> > > +                           folio_put(folio);
> > > +                   }
> > > +           }
> > > +   }
> > > +
> > > +   *total =3D total_eligible;
> > > +   return node_eligible;
> > > +}
> >
> > [ ... ]
> >
> > > +static unsigned long damos_get_node_ineligible_mem_bp(struct damon_c=
tx *c,
> > > +           struct damos *s, int nid)
> > > +{
> > > +   unsigned long total_eligible =3D 0;
> > > +   unsigned long node_eligible;
> > > +
> > > +   if (nid < 0 || nid >=3D MAX_NUMNODES || !node_online(nid))
> > > +           return 0;
> > > +
> > > +   node_eligible =3D damos_calc_eligible_bytes(c, s, nid, &total_eli=
gible);
> > > +
> > > +   /* No eligible memory anywhere - ratio is undefined, return 0 */
> > > +   if (!total_eligible)
> > > +           return 0;
> > > +
> > > +   /* Compute ineligible ratio directly: 10000 - eligible_bp */
> > > +   return 10000 - mult_frac(node_eligible, 10000, total_eligible);
> > > +}
> >
> > Does this return value match the documented metric? The formula compute=
s the
> > percentage of the system's eligible memory located on other NUMA nodes,
> > rather than the amount of actual ineligible (filtered out) memory resid=
ing
> > on the target node. Could this semantic mismatch cause confusion when
> > configuring quota policies?
>
> Nice catch.  The name and the documentation are confusing.  We actually
> confused a few times in previous revisions, and I'm again confused now.  =
IIUC,
> the current implementation is the intended and right one for the given us=
e
> case, though.  If my understanding is correct, how about renaming
> DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP to
> DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_COMPLEMENT, and updating the documentati=
on
> together?  Ravi, what do you think?
>

Agreed, the current name is confusing. How about
DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_OFFNODE?

The rationale is that this metric measures "eligible memory that is off
this node" (i.e., on other nodes).

 I think "offnode" conveys the physical meaning more directly than "complem=
ent".
That said, I'm happy to go with "complement" if you prefer.
both are clearer than "ineligible".

> >
> >
> > # end of sashiko.dev inline review
> > # review url: https://sashiko.dev/#/patchset/20260405184247.2690-2-ravi=
s.opensrc@gmail.com
>
>
> Thanks,
> SJ
>

Best Regards,
Ravi.
> # hkml [1] generated a draft of this mail.  You can regenerate
> # this using below command:
> #
> #     hkml patch sashiko_dev --for_forwarding \
> #             20260405184247.2690-2-ravis.opensrc@gmail.com
> #

