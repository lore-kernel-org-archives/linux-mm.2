Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6E3CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7708E0010; Tue, 21 Oct 2025 15:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F768E0002; Tue, 21 Oct 2025 15:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4BA8E0010; Tue, 21 Oct 2025 15:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289FE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E05E8160599
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:00:20 +0000 (UTC)
X-FDA: 84023037000.03.DA3B06F
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D3BC4000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:00:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f+F9csHT;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761073219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QX4R/NBKfqzPmM9np8ip/2J9fn8AlyDDHWJ/b66Led4=;
	b=3lkdtF+J0TYyocGJUrLv7WGhAsdMykQxcCUKOL2JRS/YXHC9EcJ/s4T31VU5syOm6DAHCW
	0u7HlZPnPVhrIsP6mxnCn29STIMe19XoSZYrxlnq5zDyhqGRVphLy7cggnY8FFcrJh+SJ4
	DQQpOd1oeOzwZHYtCLQRejLL++3itQQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f+F9csHT;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761073219; a=rsa-sha256;
	cv=none;
	b=Q+qbTYqNY0khfiPueuPMX15ZDWQ/tM/7HUIlv7PXVZeuyNxCj0OYWHfy0DdbF5uXMMVGBP
	OVgOKqSPGpfMh3zqQCHR+bnWWsruri8IAJKH/FXpFSDLG+lH4sveTZpsu+MofQTcx51oCx
	lpzNijCT1uglamBiDc/BmVFeHQ1Kf3s=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5d967b66fedso1938130137.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761073218; x=1761678018; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QX4R/NBKfqzPmM9np8ip/2J9fn8AlyDDHWJ/b66Led4=;
        b=f+F9csHTaNMsEet4XPrAJlpyaO7/ZNdaI4p5D6T2sKQ1IrkQ6l5o857NPQWuXaj8Lu
         m3cXkC+a5KokczUDM5b6iyz+LF7yMX5yk0xUW497B+pf/uPCoZzZ4mjHuZGD5KNQLkAL
         gPb+ronPdqlDiJKiSCvuZz8OyPtb9LtJAew7xKg5Ft0a0OsFPO14yAJCS1XSlOec8M5T
         EWqNM6R3JOIetgQKwyGHmLkeuZG3l8y2iMRL4iyr+m+Gbmk585DtCAgC71129ZEsJ65x
         jz4cV6jsQpqHc5OC2sdH7nFtHxLafT2znkv702S+uiHoNfKMe2sBmlVjLoi5Hxm3yFlS
         pzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761073218; x=1761678018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QX4R/NBKfqzPmM9np8ip/2J9fn8AlyDDHWJ/b66Led4=;
        b=qqQvcjGD1rVzHEnKj2dyz+9WfX/qsFuNuwAjom9jXlms3PxE/dyiBvoi5mvCBCYdMf
         QGuh1q8TwaXwtSyLRQhFF0DS6A84Y8FNOoV0wIGMb+F99fHJUYRfN0uilZRM0S4m4pIE
         v/O0ZWq3sb7lUTc1/yVdMox0DnXg5uA0UyAgPx+U4ARx6upt1YYx1NeHG5iRuHwGU4dw
         rTaAkxzpPK36XqsUR9zx8PwxJKaVaHrsa1cDCNTqrOYwBZDwnRm7oCQNApzKvBuNIKKK
         mBl2KXbIznnFWhL9Madc2kz9WSk1Lusu4p2dBNvmVPt4t462JLj0Vyr+nftg5j6VTBIx
         3h5A==
X-Forwarded-Encrypted: i=1; AJvYcCWh4L2z9xsWTQs2PLGOBIEUCurHjk3MUl9Fdrkm4cKIVheY7ERqIbZaShamuvpLndYUmD+m0S6Jjg==@kvack.org
X-Gm-Message-State: AOJu0YywGwIo4Bb/hocs73a2mfc0nYGLqaqvbKtxtY3RaS9q0MZ6wY7h
	SpTRTXUvh0EOp0vOk3DyK4QKOhEl34Zqcw82JC8P1FgFEPwZxcFKMbtvZDFLfeH4jaEeNh4IKd3
	iZhZN1hdVmzftLF7KByOgUP3A03GPAPE=
X-Gm-Gg: ASbGnctRulPbKoWc9l4CPx4pJHrP5OvljSn5PguhszauE3Mtn41evD7hIdlIu8DYS/a
	G4GMEoq0cMIECIqlbXdtp/WkrygCE7Qq5Y+IAUE7alvYmp+SWIbgSZzkexApnA23PaWyNoqW3+p
	m+yZmWFKPYI7D6n98p7IGmH7f5fsiKRREtCoblT2vTb+n0PfzgZ1N2Dhs689Ni6gZ7MSehanfQX
	zeC0y0/rWrDHFFcbdzoFCt9rGBG4qet3guB9Vd+o48s7YKJ4fgaa9rsu7s55l5KWMrW7qrrnA==
X-Google-Smtp-Source: AGHT+IHzPHA9WK5Ga04M2zxckJS1s5xJMnk2C43DqK1XOAGMJNbXAm04rGA+bsFUHBWP2svtA/gkjzvflLlfapXJqYA=
X-Received: by 2002:a05:6102:374d:b0:528:d2ad:1f4d with SMTP id
 ada2fe7eead31-5d7dd6d91f7mr6017190137.34.1761073217856; Tue, 21 Oct 2025
 12:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251021181353.3842660-1-catalin.marinas@arm.com>
In-Reply-To: <20251021181353.3842660-1-catalin.marinas@arm.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 21 Oct 2025 12:00:04 -0700
X-Gm-Features: AS18NWBvsDP5km-0XmYnLKQIdPCwf47TEESXursF19YBQqMpxVIwRFTadlqzvtA
Message-ID: <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dmeixo3yuft1hsxr41bsy4pri6ha68s9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0D3BC4000A
X-HE-Tag: 1761073218-154671
X-HE-Meta: U2FsdGVkX18DNXPa+/tKDTbikykw09l0Nm03duFp1vG/0YQsvnJTOramFbUfAZf+dStg9Vrj7nyiHMgPy3CTJdmEwFYQc+Wwg/WGHLJpu5CQVZ9yu0YFyHGeFVvb8j6C0KM5xjg1pp+xMr39baajOA30OpW4tJp7ZE/oTkL8R2KHhwJpJODoXnCAw0J6m6pf+Zfidgset6daqskb0EWFcS9XAj57Isx5fWwoY9TrN3eerI5+J4zB16ur4JpfB/ePrwR99AylybGEM98Vcpm7Wbe/T2/BW8+kPKqNuvFXWptOjWmbO3U3ODpHeGCy8uiVG+ZzUEzNbcvSoYuhl4MGkKqd48uXFJwnX8V0VGIoeJwOJMtB7Zn1+ogaJKwAQqDZUDWzObhZ8Sbb8hzf2W1uRdVoaDBvphitBWvGoTCe0rVxh//5IVj7V1zvnBWrG19ehhI8wHZcO5ZURbLlByYcXRrN0iIhwECcAHqQgIRS+WyJbRr1QOx9r2hG02dnNUR5K3UmC1wYef9WzJOIkPoEjBZDusaxWIZ29/C96Bi9BC+GFLCb1uQTeqGrEe0IZVVLojCDr1M//4QNVgpY5MdKfY/Btko7EHv2I+NbiiOzAh9ZslJ/y4GG5TfO4dJjnxhakPgcInOHvNx23Br66VoOrm7b8xWDg5TNYo6cjgc7HHMjQwX3E6W2tS2kKQAwj7XdMg9sSRs/3Xx8lkfLEyZpWsb64jpMEtBYAQpqicA6BjwMOXr0TrZXP18DswdycCoGn57cU1ppZUSYVktSqAXRxgyVMXUnJMjfSBFnWI7au+PU7Am/mj2Mg6lxrhoFBI1WWLAIavB5zUfSrYBAPb3OVDYuoSLN6iM/aeWI6nJl7DT0jso6j5xaA4XjONFX2oV9tHxzlUhKda8waq7NFlOz4iqAOldyZs/lCqmRRbP1YRSeixpUGCxP6wdzciWZvS0zgJ1Uqg4ni+WT37DupCf
 0SSrGLMW
 7tCaJbcCGBpEOsRhTlLzWIFNmuLSE7aVzPeRDO6HHrU8IRUHzTjDm6Tkv4Hb6lLJuWDKsWUN//dk4KEOiGcew28uy+svkl+etXv27f0RAmX4lsojqmeiXKEv8rxUSUml+BxKagZMCthxl6o45QM83gU7tfDJ70M8b/Ya1SvywVmfMkVR7ay8b4rO2nOo3KZIbce0w0TjcPCmS4Oau9TMdICz9j0o6sc56a2wWCASEyigjU/ogDlbdRCg6um/gjZk+LUPWxVhKmAwmFxRmV3IRqLkX2rnPaRqM2cTU4380RSF2Cx6TBkrEtv52mdENppMDTuHPRZs3HzCixh4+9z2Th658hgc2MvqC1uJXHxZbrUiHRvFiVvRDtwglKsKoSdigZZB8UWZlNpGVLqfF3f4lzIPS00f1p5zRa/c+YPVCCyiKSuuUz/Jg4KxNtsF68xxg8trX0fq64sPs3P6IU6fMw+2n4y7DqNlcJAJYvuhb1O/8YZyfHS5ojyV4w0ZGcfN4kHYZr0hy6KyzhHQPar48lyuTY6qgG2Px9i73Ayvfj6jAaE7oUAaQDeQZJzVU3JO+2qzcR0aqCOeNnXUzDWeUxSeB7azkbSDV1w0K2D7QfE2PA0YpBDnXbWtYegzohIgLIeAABQK72/v2jwaSpQ5ljNDaDMbfpeJ5h319zgj41g2mofj6sLwiKEPQXlX7eH5yGYEETQU2yyOiQz2oDHOfMtdOfN2LsK/TsuCuq9qB2LoEs9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:14=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> The arm64 copy_highpage() assumes that the destination page is newly
> allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> accordingly. However, following commit 060913999d7a ("mm: migrate:
> support poisoned recover from migrate folio"), __folio_mc_copy() is
> called before __folio_migrate_mapping(). If the latter fails (-EAGAIN),
> the copy will be done again to the same destination page. Since
> copy_highpage() already set the PG_mte_tagged flag, this second copy
> will warn.
>
> Replace the WARN_ON(page already tagged) in the arm64 copy_highpage()
> with a comment.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.c=
om
> Cc: <stable@vger.kernel.org> # 6.12.x
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  arch/arm64/mm/copypage.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index a86c897017df..40749d0a385c 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
>                 }
>                 folio_set_hugetlb_mte_tagged(dst);
>         } else if (page_mte_tagged(from)) {
> -               /* It's a new page, shouldn't have been tagged yet */
> -               WARN_ON_ONCE(!try_page_mte_tagging(to));

I think you should remove the WARN_ON_ONCE in the above hugetlb chunk
too IIUC. migrate_huge_page_move_mapping() does the similar thing.

Thanks,
Yang

> +               /*
> +                * Most of the time it's a new page that shouldn't have b=
een
> +                * tagged yet. However, folio migration can end up reusin=
g the
> +                * same page without untagging it. Ignore the warning if =
the
> +                * page is already tagged.
> +                */
> +               try_page_mte_tagging(to);
>
>                 mte_copy_page_tags(kto, kfrom);
>                 set_page_mte_tagged(to);
>

