Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83646D5C0C1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31506B0005; Mon, 15 Dec 2025 21:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08EA6B0089; Mon, 15 Dec 2025 21:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD416B008A; Mon, 15 Dec 2025 21:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA1566B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:35:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2696F58D0E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:35:01 +0000 (UTC)
X-FDA: 84223766802.26.251D6B8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D3F880008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:34:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LBOqujcO;
	spf=pass (imf30.hostedemail.com: domain of haolee.swjtu@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haolee.swjtu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765852499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPJQqTh4HgluXjAY1TVY+SERzjJyxjpOHlsvQ49rc/E=;
	b=G0hEAsjqaodsJG6DOGspzJshTRk87ilt1/m2N846upwK9T3a4pwqpDU3Pvf3Uvl7ItQPaQ
	9pQlXYv1+qH2XloZ0EwDeM8bCo3Gc423M+7iKx+VUEGjH4JwqO9f6cfwUPr+iNe/nyrEuY
	Fk1FPfF/DDY2kFbVHnxR9jr9pAywIGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765852499; a=rsa-sha256;
	cv=none;
	b=Iu1cDOIfYTvQAIm63MpVBag7Ah/1Zt+7bcU/EgfLNYxxVspELgLbdXVlpG15Y0mnHS0J0X
	IQNKDyzhJplImh4XKmMYOxG0ARGgMz/1oFcXzvBUCc9VUuOe4GLzmrt3RWn2t6PxUeAeuJ
	pDXCyCKRcCJQajasSsA7ZgPEE8P2HB0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LBOqujcO;
	spf=pass (imf30.hostedemail.com: domain of haolee.swjtu@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haolee.swjtu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d52768ccso22567625ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765852498; x=1766457298; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPJQqTh4HgluXjAY1TVY+SERzjJyxjpOHlsvQ49rc/E=;
        b=LBOqujcOqLnvwo9ZQJMsNctI8gYPQHKSFalo7IJR2nywSrHlF5fjei7Bz1qkCDbyea
         ZkRJmJ4GfSAuC/Ya5zOL0jqD8wo1Df+TyQkkLfMiOeXtzkxM5KaeK/xNU2+x3BAyIo53
         P0LrLkL5r7nhlsNTp+w+XckZTnN9X7gxPgJovxPXhgGo+rJoEmk0LGt3k1t/iOWLqmFL
         VGC5UD/lz4FHCiRVvVKiVrOrzc5w/v3nN+3xM5gTHGj0xXxsyOiFUJ0/ume1sc5IYJME
         dcb0o1WFYlCxhjB1liJfkM+EkMNjr7KNnwZzq3t742wzNijsBVvJcniKmfQv6ncT8Il8
         f8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765852498; x=1766457298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gPJQqTh4HgluXjAY1TVY+SERzjJyxjpOHlsvQ49rc/E=;
        b=fHL0UCprlnHJbLbzXqlTYZaClzAOV5veFqctFvCjB9zl2hTD7Lub6Aoiopy9TYEsoA
         6je1eIxuFvjAIdanHvpcw0uWkcM9he23aFBRWF7FGtdEqOV5f436VcHi2RtiG/s+wu9W
         cmuZBp+Y2CniPtZvHlBoTP5gLdmoD1TDHg5xyq7DaUXHt1tB0z+4gereTGYBbArECynK
         dLvFe8/Hy5Ra0KnSiKAexRPaoSVWxocA7L7OCg+T5ZcPn9ssWrIfx7Ob56YxX0uhB1UR
         S6AVlgL4Dyim9Z4Oo8GxBQJTXNu4jg6qvsoXqeW21E/HuETNWvOPQy2Kr9OWz0XtXyI5
         PCAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkzq9pqO3H/vqPa+redjL3acn87NmJCknDeqA7Xs3C7NLhuuvSgqr6Z4FvLA6aAlDd3w1qhVmTnw==@kvack.org
X-Gm-Message-State: AOJu0Yx2FSHP1zoK7mKiBWbfOUeUmSmTbc7IsQ3kU7VmUiT12OkPi87a
	GKgLiJH7BQAnAv/iVCCpFdwUws9ccHXjvux9hiag1ogruqd8k7lJH6NVCJLOVlg511nzd25eaAd
	KoOINYEjOjswcWDuca6SyGZK/JHu0XxI=
X-Gm-Gg: AY/fxX6tbIV6B4WD1WbUFqL8NxEfunFUu/FTPWRt4VR+pCMGoolCTk0TCqLf+a+w0a7
	bSLHLYpwOS/4ANvAbrmk6pagy2SWugYA9rw7PF7m64FGXRO/pX3NYrOsI0x+2UMMVX/jv+z0L4L
	/R3Oj3xbZl7WECucZNQW6pD1atT0oQzFOI+21Z72OLWL4Dxfa00EZFKxlLI6X2pv0BhO9sx4Kzh
	mggTvVQgfsxDQbBsvrNgYS7NMFW/GKGYhlRF1vbiMp4s9Jx1mNJWozUM9P6s4P2z8ETOB1Giy4Y
	hLyUYBrs7PEyD1VbaA71FrILQQ64Y0QV2jT7tZfo
X-Google-Smtp-Source: AGHT+IGZMy6NZ6vkCZabILETdTUKGXUlD+bvZoC5iv3Zv1JpXDoU7UgSEiVhSycXKmxJ2RH7lL+989/Af4wnIUAap0E=
X-Received: by 2002:a17:903:19e4:b0:2a0:ccb9:2f0a with SMTP id
 d9443c01a7336-2a0ccb93179mr68459295ad.8.1765852497996; Mon, 15 Dec 2025
 18:34:57 -0800 (PST)
MIME-Version: 1.0
References: <20251210002629.34448-1-haoli.tcs@gmail.com> <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
In-Reply-To: <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
From: Hao Lee <haolee.swjtu@gmail.com>
Date: Tue, 16 Dec 2025 10:34:46 +0800
X-Gm-Features: AQt7F2rw8xl0gEfLsHkMzX593eb5nar9s41UOTfyrmiU4yH99b6BBuwBv9oBwiY
Message-ID: <CA+PpKPk9YdzmqwdsQ9CAAxtBNYU+RD9QOO3NOnqeRQGuDLLpxA@mail.gmail.com>
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in __pcs_replace_empty_main()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ka9rd47tapnmxc6sowtxyt3kwcrumibz
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D3F880008
X-Rspam-User: 
X-HE-Tag: 1765852499-597208
X-HE-Meta: U2FsdGVkX1+Zj7QbA6qXj86OcEG3hT03UAIdQH4yuwjp7pY8Y+uIXc4ZMDPqP3vRJ6Q6qLyt0PDrZtwTEkA3mGBy4X0Q27YGJecFbx/9ugSESCGwaVTXEDHZdzIkyD1MXi2kwjh/tKIuniPEbVL0R8mj6laRkNJz30Hpb8I01M3GWiP1lTLUd1LqcxEtNPApSm6YoF/L4FYbepmryME6GZA9EksEBgE56IRJL4ETm4mmyNM5hnHy0CiE1epfqc8iLUUg3fescnqwz5i31ePtwaVj+mhfEsSnhW/Jp8RplmteTfQIJX19HiMVY1R4ij3XMxplFxqWAj187O+MzFXfTHCPYNHRdO/OUE170eQEJGA5AwitinCe0ekITlOf2Od6A0dL+o0Xf1PDHy49r53TazOWK/VYt/b5S08G/QZGLDgbd6tTZdl3BWVIqxBqB+oOoVPc5bVSDJnUnK0YqHt8pA3TgNnzkdlvGPO2QYbKrEfeV/GCuzXFXCtBNK0PBYR+Kd81YvciPYPnFIy+ze+dO0s3rCmV0T+bZB+XW2/giKsDnPuB6fi6v6ig3Ro80S0GEqBxG4BcJgwSVKk1b30CN39cNwwG5GMvsify4PxsRvqz8ZmMItKJvkgVohYazMrU26FOuHyRPPqiiT+zESgSCA3xsSV6+46xZJ4F091XUclhPTrcZDejc+ahc+qT5g5LZNMh2JglorS64LfSV0rZpWU/Ggnxa0UmRgKtDYkneEp+0dRMSK9c27KCQ3XUknuWPsGZLhBpo61w+XVWUjc869Nmqx1ybkqowt/cSQEchrp743s2Ips3wLzX1jkjOuUXCXwtJ9actwNzOUPlf/mBDvTcUjyrLiN4L1cPBZ/RGcxc0f3mN8AyZDcy8mwbsSbkxDKGj5n1KasCgU0mgP7qgQnvnLmOQ9a3etL/UBZprSmKW55blnPyCw3BlaYjGFG26ETiakTcO3ViMhDkmGC
 /Y0CoHC4
 VYjG1Diwq7FUDbdfF7c/Fkf31ncvgTm3soDJBRyEaRCPjqRqewQeKAf+NpuCb7s5by2aCgT2MDKHbuKaADAeu3XfU/F40e658/22INfUKuasyNM6PluuED+C8LI9Fo6qP7hoGaQ11OMhzA2Ragwx96qLVcy7TAhg16gG0xZ+/rsmHnzI5Ku+aIAK+VvCMAa3j36XB17TDc+eph1vePs3qSfHMBCjmIvC94KS5w8tmnLnrRJDr8VIZtai7nuY+AoHWEHmmZzDonK+cOIqxQlBm6oZc+sBCQaqP3MSgbwsQ7j8ZOkiYeB+LuhRArhlaBx567CsHmk6D2Bj+4SrsEcAvI56IQWsYVsw8xX3Q0J5EzZNP6cvs2QOoy+3TSIA1g7xtlNyWQ0bHD5ZL+fNa/cAZuap5lCLKwjAkfn6wMR+91tJYfro3in+uUVZcIuF6WD/krsGV3qE7uzIobItcltKWx1ZoGvSxqaz0Nyq8PSyDZdjI/cMk3WYBdB/9gA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000039, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:30=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 12/10/25 01:26, Hao Li wrote:
> > From: Hao Li <haolee.swjtu@gmail.com>
> >
> > When __pcs_replace_empty_main() fails to obtain a full sheaf directly
> > from the barn, it may either:
> >
> >   - Refill an empty sheaf obtained via barn_get_empty_sheaf(), or
> >   - Allocate a brand new full sheaf via alloc_full_sheaf().
> >
> > After reacquiring the per-CPU lock, if pcs->main is still empty and
> > pcs->spare is NULL, the current code donates the empty main sheaf to
> > the barn via barn_put_empty_sheaf() and installs the full sheaf as
> > pcs->main, leaving pcs->spare unpopulated.
> >
> > Instead, keep the existing empty main sheaf locally as the spare:
> >
> >   pcs->spare =3D pcs->main;
> >   pcs->main =3D full;
> >
> > This populates pcs->spare earlier, which can reduce future barn traffic=
.
> >
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Hao Li <haolee.swjtu@gmail.com>
> > ---
> >
> > The Gmail account(haoli.tcs) I used to send v1 of the patch has been
> > restricted from sending emails for unknown reasons, so I'm sending v2
> > from this address instead. Thanks.
> >
> >  mm/slub.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index a0b905c2a557..a3e73ebb0cc8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5077,6 +5077,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, s=
truct slub_percpu_sheaves *pcs,
> >        */
> >
> >       if (pcs->main->size =3D=3D 0) {
> > +             if (!pcs->spare) {
> > +                     pcs->spare =3D pcs->main;
> > +                     pcs->main =3D full;
> > +                     return pcs;
> > +             }
> >               barn_put_empty_sheaf(barn, pcs->main);
> >               pcs->main =3D full;
> >               return pcs;
>
> Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
> adjusted like this:

Thanks!

>
> diff --git a/mm/slub.c b/mm/slub.c
> index f21b2f0c6f5a..ad71f01571f0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, str=
uct slub_percpu_sheaves *pcs,
>          */
>
>         if (pcs->main->size =3D=3D 0) {
> -               barn_put_empty_sheaf(barn, pcs->main);
> +               if (!pcs->spare) {
> +                       pcs->spare =3D pcs->main;
> +               } else {
> +                       barn_put_empty_sheaf(barn, pcs->main);
> +               }

Nice simplification. Thanks!

>                 pcs->main =3D full;
>                 return pcs;
>         }
>
>
>

