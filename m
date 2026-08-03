Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D55C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61776B0088; Mon,  3 Aug 2026 08:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37CA6B00B6; Mon,  3 Aug 2026 08:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9DA6B00B7; Mon,  3 Aug 2026 08:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6F796B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:57:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 510631A0671
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:18:00 +0000 (UTC)
X-FDA: 85059406320.27.0A5971D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78D9AC0009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzXopaUF;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785748678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxyuD0oss58ubgzj1FvTC+7tUw49ZGQl25e5UWdLsh8=;
	b=S6z7OXTKoPMXOTa9dHHdgrvAkI08f9VxaJ1VQj96wWh/sdQl/OJu+LUlaJhyzatYHG4DWb
	QyidtzEolI8EnoU+MFboWbvjJVttx9aJTTuxXa5ykxVx8b5Rg+pUBtqi3S9CbizluWmAJ4
	iXOfATZmVpcAlTSgxkh4ThZwH0l1Dcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785748678;
	b=xe1ZN3QJG/CoQ9fPvSMtXHfeGn3prJQgzVPU79f/MbM/KLnatrJ3n7rP4gff76eCwKmGnM
	u0fc39TW/J/oCvWaz3XLzrtf0pKEHFsBCkv2nk0n70M0eY/5HD9Z/tYpEJugLEU33HwU9E
	JQ0SU+r4JuwBYn+R451B3MeDlGMgEWc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzXopaUF;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A35F60A7D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409491F00ADE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748677;
	bh=fxyuD0oss58ubgzj1FvTC+7tUw49ZGQl25e5UWdLsh8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bzXopaUFvz6eF3NhFb4UpuJ6Pyqp4WVoWUBykPWH2CJ5V/G/Nbls6Dm/a1p8D6rwR
	 GwvbaXXvzISYvTgv0x35Ts0FQmZLr8GeeWmhaWGQo0O+KPKtr3iNI3u3Urq9+to0mK
	 w5OwAt+Dvx7oMOtZvNFJ2KuVomsSmpy5iHdvKfF/TT9kSYF1O01cDZ1c0DeEDqmZM2
	 Oam53YGx3zR1UvSiSLjA+9NzSLgMqO9e/yjX5Jt222t56ZuPbyUXbWRUpJvdfkMqAy
	 MqOuay4TnrRHyjzzl8usI27OV/sVHWozrUP59rbn/Jr085pdvF+2sqhl8Ote2epWv9
	 VR3fZb6e8BbzA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-930f72317a6so164328885a.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 02:17:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoYtumA0AjnmrctC+7xxlsF0FDLjqdNRENc06Qt8C2iFwNLoLflAlx0gZF9ZoLIyXq9z4nWHFoqLw==@kvack.org
X-Gm-Message-State: AOJu0Yxqy3TaKyvZzSlFUJBr4xn4c3gI8llonZjxR+mMoA8qEljChHgP
	5sLfRtIjbTQ4k1YpbCvijlf+f+YZ78AaFdVHwOaQBMlIpg/tvkao7lZZyudUSp9Vk2CVLGY4JAk
	w2qY3K8POl1WPA1QWR0266jMruzI/3DY=
X-Received: by 2002:a05:620a:390b:b0:934:9524:2e89 with SMTP id
 af79cd13be357-934a0789904mr1748731885a.13.1785748676518; Mon, 03 Aug 2026
 02:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
In-Reply-To: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Aug 2026 17:17:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3MQVU7_Npxf3JQ8Q27TsAW1Tx5-ifH8c6+gKtg5QkuQ@mail.gmail.com>
X-Gm-Features: AUfX_mz8oKCS0mJlMGsIPpYo49S4g_rtl56yBju74CQn1opkjI8-NpakPIKDA3A
Message-ID: <CAGsJ_4x3MQVU7_Npxf3JQ8Q27TsAW1Tx5-ifH8c6+gKtg5QkuQ@mail.gmail.com>
Subject: Re: [PATCH] mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Hugh Dickins <hughd@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ng1oqrjk3jua8ayjiu7srxecbj5cm3ug
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78D9AC0009
X-HE-Tag: 1785748678-823044
X-HE-Meta: U2FsdGVkX1+uGilRIXMPxOfSfahxNV8vO9f+v2hcF6Nep8S2hi7gB94UAARD+mCxrRXm/lbgNLYjmy9M+88TGzNljj4xg5FvUWZ157pliQhP6XS2xeB8DgKsS1zTLk+HUdXXf8MljJ+HM1w4ABPCDQCSNwBfV3/lpd48acAN0LRETM8i0Ugg9+DHMqRiNOO3uBK3odlyEYR79RYSwQdePX0rGivF7ccGU1Hpoa0/oihsIyotrBGrjbtxHHI+tTpsC4hircNGDN9k6D6dnLA9oteQ9rU01NxiSY2fyjANSGzD9TohnnKp8MhgoTPKpKs75NmKxvP7oeAXfw9AUjBB1aCod3a90+fvipfMdFZqUeOvkb4ymjoFiUcRurGGk6vmzplvOZQFM67/ONjK7ghzIUEKu7IjVfySgn0vP7+zyleCjvLR62knlREUrbzkVJY3oMkdSmvRiVOaIKZ7I9XRjBGT0U3ZF/SmfAk7QQ0SayCtdbQca4qPaQrXaQvwxtrzsPN2ke6m2YlQ4Zj2AmTy/7R31rpvH98bJj0kiZn8c3DmctYpPS8ggpBRMO18baDqDICnI6ViXCeJoQWbtuCdpzlb9lKTqTwxyWDD/ZgC56HhEH+u+nLwh3Dp7HEpK01+GC8NzAxGvuHZZIQicariYF3PSlLH0WvvXrlr16E8pCY3lSkA/+1maOA5b44b/EDkK2+S0ObXffuXlWxc4pqqcCFiE5tKqM7TfNM3BAk/t4aPSpwiAy0kV1GUPJwZ57gzUaj3/TN3WhW0evrFR9WLAz2tVzusIfWm42QsfTuIgxWFvHoRBtSOdRG/T1uXQ+vi13g6HzOTd5wX6xP4sk6iGl+zkgQcGLE4AUnxP05TwPiyJUtz7gAvSiUeampvfnGSQoa8rnfeR9nfnfasqwJUOKl37svc9gJ18ltBavtYIkfxy8VeR3IgYedBv5oT5NOR/WIS1231tcoJy2xZPxH
 BiA2+DlG
 zwpYzaM54ja3izmxaR7bCFW0eBtAmGmZ/NOk410qFG2QbTJovSs53cDSyxmStmcL+iIKmWUDq6QQigf2O3Z36ONMwSphTLekI8MAjs6hMIeFPafO7xZS3ZkY1B2sVW7/pz7T5j/E77XoTVvYFUawgBNeSyRJvvdK9nUBMG5Tj0TlvdDYFY87XPs5Lg5Xz/qJBSzRn9hPU/78btzO8HraTBcWIxYfKvlu+b3gfctKbR/vu2iFlYZZZ7lprZxKhTnXVu8N4TqhG1xZt2fgjIyICL8TyuwTcXFj3BizjBQSyikUwHYCXWged/dDavI+d0ugZVCclOA9AQqUodRBYmL1GBTwV3LfeDHhDhKS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 1, 2026 at 4:28=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> folio_may_be_lru_cached() is currently only true for small folios, and
> for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
> of 1 in try_grab_folio()/try_grab_folio_fast().
>
> Consequently, our
>
>         folio_ref_count(folio) !=3D folio_expected_ref_count(folio) + 1
>
> check in collect_longterm_unpinnable_folios() will currently always
> identify "reference mismatch" and first drain the local LRU cache to then
> drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
> is really called after pinning the folios with FOLL_PIN.
>
> Add a comment because the current code is not quite intuitive: we used to
> drain only to make sure the folio_isolate_lru() would succeed. But then w=
e
> also started draining to make later migration more reliable.
>
> We'll refactor that code soon a bit, to also make it usable in other
> context where we really want to remove any references from LRU caches.
>
> Let's add CC stable, because having an easy way for excessive LRU cache
> draining on all CPUs does not sound right. In common scenarios we
> don't expect to every have to drain.
>
> Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migra=
tion")
> Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drai=
n_all()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Found by code inspection. If someone has a testcase that can easily
> trigger this and result in migration problems, please test! But this
> change seems to be "obvious the right thing to do".
> ---
>  mm/gup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b0..41c3317e0f0f4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_unpinnable_fo=
lios(
>
>         for (folio =3D pofs_get_folio(pofs, i); folio;
>              folio =3D pofs_next_folio(folio, pofs, &i)) {
> +               const int pin_refs =3D folio_has_pincount(folio) ? 1 : GU=
P_PIN_COUNTING_BIAS;
>
>                 if (folio_is_longterm_pinnable(folio))
>                         continue;
> @@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_unpinnable_=
folios(
>                         continue;
>                 }
>
> +               /*
> +                * We drain not only to make the folio_isolate_lru() succ=
eed,
> +                * but also to remove any other folio references from LRU
> +                * caches.
> +                */
>                 if (drained =3D=3D 0 && folio_may_be_lru_cached(folio) &&
>                                 folio_ref_count(folio) !=3D
> -                               folio_expected_ref_count(folio) + 1) {
> +                               folio_expected_ref_count(folio) + pin_ref=
s) {
>                         lru_add_drain();
>                         drained =3D 1;
>                 }
>                 if (drained =3D=3D 1 && folio_may_be_lru_cached(folio) &&
>                                 folio_ref_count(folio) !=3D
> -                               folio_expected_ref_count(folio) + 1) {
> +                               folio_expected_ref_count(folio) + pin_ref=
s) {
>                         lru_add_drain_all();
>                         drained =3D 2;
>                 }

Not regarding the fix itself, I agree that the fix is correct. I am
just a bit curious why we cannot simply do:

                if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio=
)) {
                        lru_add_drain();
                        if (!folio_test_lru(folio))
                                lru_add_drain_all();
                }

Or at least the following diff?

diff --git a/mm/gup.c b/mm/gup.c
index d110f30d9bf4..3aa1d498e9ea 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2300,13 +2300,13 @@ static unsigned long collect_longterm_unpinnable_fo=
lios(
                 * but also to remove any other folio references from LRU
                 * caches.
                 */
-               if (drained =3D=3D 0 && folio_may_be_lru_cached(folio) &&
+               if (drained =3D=3D 0 && folio_may_be_lru_cached(folio) &&
!folio_test_lru(folio) &&
                                folio_ref_count(folio) !=3D
                                folio_expected_ref_count(folio) + pin_refs)=
 {
                        lru_add_drain();
                        drained =3D 1;
                }
-               if (drained =3D=3D 1 && folio_may_be_lru_cached(folio) &&
+               if (drained =3D=3D 1 && folio_may_be_lru_cached(folio) &&
!folio_test_lru(folio) &&
                                folio_ref_count(folio) !=3D
                                folio_expected_ref_count(folio) + pin_refs)=
 {
                        lru_add_drain_all();

If the folio is on the LRU, why do we need to drain? Is it
because we already know that the folio is not on the LRU before
calling collect_longterm_unpinnable_folios()?

Thanks
Barry

