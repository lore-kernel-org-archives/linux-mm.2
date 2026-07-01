Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5677EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBB46B00A8; Wed,  1 Jul 2026 13:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4786B00AB; Wed,  1 Jul 2026 13:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C766B00AD; Wed,  1 Jul 2026 13:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD24A6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:33:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32D4B1684D9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:33:50 +0000 (UTC)
X-FDA: 84940905420.14.C7030EC
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 46F6E4000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:33:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Wf/0am+m";
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782927228;
	b=Q+k9+CgM9JDyzKrRn1xcTK1SU3pWVG2h5zrrh+PLBhBR4tQI6DwYvHl/80wD4kpqe3t32t
	b+4LxL5BnRD+2io4H9qwRKyjOkzfBMhLTCz18UTyE8gPf7xo0uuBeFnGnL6ChJp+gJAe2Y
	Wh9idS4bHrzVtX7KMJw7+PmfDS84Thk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782927228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLYniQWTkrnaZMuzcboN6JdTfeobG7HIxzFb5zfv/DI=;
	b=kmV1K/Z+S2Q8f+IJ90T5yXL8Udth8GewYoqgSePSnr/6fvEghJ4oU7SNRssBvtB4biG7am
	KvpJB/PxLwWRGeoX6/OEXudyneGsRhWHBcsWRfcvvadn/sSSEOVP5FmaJkPu5H8x1E2R+3
	l6ALKLq+tHLlTi6fs68+TRJDQlU1gXU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Wf/0am+m";
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-473dc4cf238so583854f8f.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782927227; cv=none;
        d=google.com; s=arc-20260327;
        b=gFt0UJ3xFo8uME8zlWHPtpha41/z5+oGn2J/DipAn0fWi2LDn+uVUtWgJZve/9teXN
         2En5GEOQ6atuhbxLetVFQMnOwZqxmnyrxOCjJpxsJcq0qy9jBwj+7uHdo6h7DqvB7V9/
         AWCQTdRZKr0qUDKhC1ztDP8wNN+mGPK0MItPZg1bEuvNMrBQelJIMza4UFHghp0SvU2q
         cwonJu077pARfxlIuNcmD8NwFL6g9ox7KW0tZ2xT6lGdk4mqWHFWkXRUKFSjGbGmXlv0
         pNAd4ujkW1WdpnO+4/XEDp6GvGPb5qeg39NDLOa7OtAec2pzH/6fGbsXx0JEBERgt/NH
         x6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BLYniQWTkrnaZMuzcboN6JdTfeobG7HIxzFb5zfv/DI=;
        fh=AEyBudk/77esBZEM7/Ag7Znsr5mQGxcr2nP7xIvpF38=;
        b=TPp3J2AjsUYSZu3koq752eoZ1hNMEwu015qsHg2g2IqfIJz/Iz6q6Jai8JDGjUY1gZ
         uHPwi4Rqz5Q44rvxqwaXfF9PqRvrTpXxmKxJWp5JcYCqghBkN+HTw09GN0uSxF+ZottW
         nlRZBgL7QcDRANnpE3iyc4bHy1NyNKoM2F86E449Hbw2OyDJvAXGqko0xk3lMg2JwP/2
         YAR2IPsI8PPy9RnQKIl7wsdM4G1KVyg8e+SRed2TUxmaTSKDKwRn6ghNKVMxEAvlCQXC
         V2Zrq4uoon2ONaBPJkW24KUqYUUcHT1wf08kMoK6rZU0IPXBGrc2x06Hvyk1jube+YmS
         twaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782927227; x=1783532027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLYniQWTkrnaZMuzcboN6JdTfeobG7HIxzFb5zfv/DI=;
        b=Wf/0am+mowiC8x8pJ26EEjhoyDiPQtVCSl2jcHNh5q1YLo8RTaHwhQduTqGyWjs+Ja
         9PWNYl7HIMzQvPjCN0/I4LTQ1cEgRQw/zHnspk2lNhdiZaMjRO40slyC00vX4VbKQMHJ
         pb9Yu7pP1Z0QWjTw9d1gGsOGI74SB05jkgPMzYrOzgtOSTKMPQym5bncmnZPAqi8XQCh
         1NkZizTq16hces3pBkJbZbMdSMbjXA5TU8MOb21Yho+n1mA+CP9iu41O9lUuVvkA9oF6
         k0HckncDgaDKBWvKn1dT5SkqZP3sxJNnPi687z9+l134F9Zgba2+TQtS1ANITOXLxoWc
         REEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782927227; x=1783532027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BLYniQWTkrnaZMuzcboN6JdTfeobG7HIxzFb5zfv/DI=;
        b=P7diejE+L+68bSRxXfKjIQ+sS1SryyD4ju1Y8415yQbmiTmjImX1y/ZfPUVeqRRTOb
         yNoYIJKev4TOs4CS9uKgM1d3kzsqEnwPGSwd9IwLOVY49iwjbzM7geFmVVNZfitHrd3o
         kz+In07yhCh7velj3g606bXNaizZUkvddc+HxIwGm1Oz/8hmyFAp67sYPIybBl8e7vt5
         UUnvW9mjf0+bW7Q5qg6qo6fszFEnAo+1pmzDntIMuOAmvVRMnfT2rdeecZbMlpwMzm/R
         9iNGaE6c7zLtKErncIR0sie84pRpfI26+AZ2zfg2YEzJxzbpuJKWSzpvOXToo2e5ZNzv
         t6fQ==
X-Forwarded-Encrypted: i=1; AHgh+RpFbE2Sri5b61+6Pwfjv8m8h/LLSlvpeOx00jdLzad74LMmPDQQiaRLepUOGmlPEJ61ZdA39L3Fsg==@kvack.org
X-Gm-Message-State: AOJu0YzCOjvp94KzL8tyeyhZKMReblSPkg/lpQG3gKSTqN+Yw7uRDvD7
	l9mVNuaLntxby1WMZHqJcwNrQcS8NZHsWHsiZbssMZgWyH2kWgjVICi+u2l+KJ1KW9xRnzTliBs
	L+/gkIHEv0zot+hKJ0pXMdj6uZoKtRSs=
X-Gm-Gg: AfdE7ckksnab+LEEvTlJHI8OFOEfo0WZhSYv+eqzzk4WhPm4JlUttwDi2orGlHfw7KM
	rAwC1g5luh+5AV3hrphEXOgYx/fHTbe3bCXPFV+TITkX7h4NjBtdgp1uh0DS397q/P9z+GaN9B4
	YEO9IYOxUtUTLGVoCHYgZXkBAj7h6kFXck0iiKrI8CC2rFsZa3zDQvVzEeQu0qQrOVuwBEE/HOp
	kpVhPUkBDqEaEBrkyCHNzWHDffspZlGzqOn/VseBnjXUkmIBIIhSILz6dqCY6/DzAedrFuDJI5g
	HMvZbvNRJpzJZBKn8YT3tPShsAJt
X-Received: by 2002:a05:6000:4694:b0:477:80fa:f462 with SMTP id
 ffacd0b85a97d-47780faf939mr2424022f8f.35.1782927226685; Wed, 01 Jul 2026
 10:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-2-jiahao.kernel@gmail.com> <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
 <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
In-Reply-To: <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 1 Jul 2026 10:33:34 -0700
X-Gm-Features: AVVi8Cdct_XjHaPzkM59ofcoatqWxjHDMf7QaZzgYToPCg0_6braxznx6KIBQEo
Message-ID: <CAKEwX=MH+0yixjrbTR3aOE7V0MH=GAP9yKzHGqHizNZm0DBbZQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: yosry@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: of6abkzncd898tmjxtuwooanwbny4ddw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46F6E4000B
X-HE-Tag: 1782927228-954286
X-HE-Meta: U2FsdGVkX1+ocp7LBw+63tS0j01KwM6meip4vuqA4XyBz9A7CdIdKwTyyqhZaabCp9+5mArlF3xLYDWOK6IwwDaLLv3Sdwlh1I8UENuw9V2ny8KV0ELvBmxnRMEi1YzhFDfDfD30u+Yx7UMvC+o7uzXDvtNk7rZg9mnVnAVThOSkTff5uMKJGK2N2X8wQjZcWtA8aIco5+tDYSKJ6e5P4wH6I75kY+TOqGqQJCUyzJTU8FPHYGospL7zY6XBd0vLeF5cgNFWDrivUeBQrNQ44TMcxmrp3Y7uqb7YnhGGtV+rdidbLwmgh24FhX8/zeapOrphnlLKJIvQ1DNLX6ecvAR1stoCpnD3qO6Bya5WLF2E60q2ZTNkhR0E8IJFGsLwkMP4ynIQ/9JsmvbD3IfnLTqVpPsWIV1ph0+i3moHmoRrnxmK/X/9y40mwCXXs87VgG2Q2jcTL80/ItsPEhSAsdbWfgnYwBCWJKD75LvOzOvtPaJWOcIhHtkL5HVSYLrHKIL1FCULRqUW920Bc6K2m6TBzgX98xqMZWuxMrMqniDzL0Yv1tB5SBJVWV+C2+5FmOtjD8k549zqlhCdM1wP4FyHgiv76gfyGk3mhsOyPoj9N56T6AvGT/nNPBkCtcpl6k6BOLXJjdb1Cp3uyrasn50sJR5eIBwQLZeRzmKBjU4VPCANEqKfQhC2k3S/QrmtLwsvC4Ab3KUcWTA0XWOMF3p5yRyOUZiojjMFKJBlo9cXwEOwyfLEWGFrZNtkOXbO6iTB8Patg+D86GL3f3JHxtww9UjcfAHd2pGag0W/gvD6S8GM+W83Rs97tQ/ye4cDt3RTLgHMeBf2lhAXIJIQRQYjg0heQSurM3+UzgJnJCYtHABvIGyNN/PP7DCqOJZm5nXEra6t6QjZ1zHOt/lLlBgHrXpVynOlUlY5Ussb0cYOh5V1wkKdBraGkkQcJ4Bd503DH2M5ZQIV7Anxxkl
 9CYT7Xc8
 Xhm60bAfL/QgIkeKdcxHX7kxkonhuAIudFyyLFjgI/Rqy2B2a0EdhPYaCeFUbGWno/6PnkD2RdbhIwNskd/LPjnY5Xv8Dsjal9THX73o44esCNEgkTCI5/QVOqetIyg8TH7kWbFIH0z+yXnEZbSm8O+XH78up0ySnNEdCRIjunu0umVNW/FOpWGH+Pf3Y7SjFDYBV9Fbw+xPcclqQx2vXPQwnEwKavQZxP1n56RykZsw4PeLWdWI+yJEPf6omPGMx7a946SmbwvXS9nh+tcV6aMEhXMsd0ZoVieYqCugjXRJJJwJUgD85Y7vhBE3ObrOTlvSFQoDPzg3EqkyD7MxEP9duTOqFI4Uot9RLmHbrOfgb4k0sgzcAalmHIfyzXvqITZwqGa9ZFlT9uEiBlljPdwBMDRjTGzyyINWjKKV/jhZz5E4A4q3w96iLeZgaF0pvUz8OSNQPrslM+lriUAv1MBNjw7Auzt/OpJk1/0pUo/lZE77NE8dTBiGlLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 3:51=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4b5149173b0e..9d4f19fc440e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1361,11 +1361,12 @@ static void shrink_worker(struct work_struct *w)
>                  } while (memcg && !mem_cgroup_tryget_online(memcg));
>                  spin_unlock(&zswap_shrink_lock);
>
> -               if (!memcg) {
> -                       /*
> -                        * Continue shrinking without incrementing
> failures if
> -                        * we found candidate memcgs in the last tree wal=
k.
> -                        */
> +               /*
> +                * A NULL memcg ends a full hierarchy pass (except when
> memcg is
> +                * disabled, where it is always NULL: fall through to
> the root LRU).
> +                * Count a failure only if the pass found no candidates.
> +                */
> +               if (!memcg && !mem_cgroup_disabled()) {
>                          if (!attempts && ++failures =3D=3D MAX_RECLAIM_R=
ETRIES)
>                                  break;
>

With Yosry's suggestion:

Acked-by: Nhat Pham <nphamcs@gmail.com>

