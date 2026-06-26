Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63113CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202BD6B0088; Fri, 26 Jun 2026 03:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5EE6B0092; Fri, 26 Jun 2026 03:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115276B0095; Fri, 26 Jun 2026 03:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA41A6B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:15:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37A1C403D8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:15:36 +0000 (UTC)
X-FDA: 84921203472.29.1F3D41D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6798C100007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:15:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxwOaYpa;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782458134;
	b=Ps9DAvQxX7RuXMYRq1I0FrD/dFGocLXigYh38J6Rwb+VcLf4CijVTshRu7L6x0a4m1JkVo
	FUE/Yf9Tp87pdMmwQHkJFTew6edqyRbzIV3yEWwV3O0XbVodwHVGfU++i+BlUQAvdjDxCc
	hSaLEzxYpDgzMmPMYiMUZ7KtN/RBkr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782458134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lVxdm0Ep0/M2ZYIKTC77sSAb+8Ja64CITv1+WKNFCo=;
	b=NZpO4DwIn1PVwNrVTsD5+P1DJVIZSyz3YHPPIYLfUl/qn8tbadyE+8lh8ChllhsZtjZfRv
	dw5LMfV58veByei2xvUN/yvG3W973vxMhL++kMePsN+EfIdv9FqnC855ZdLkWm3uaZaPdx
	BXB8eV6vC/qy6jKmOFVrharjtOO/Klg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxwOaYpa;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85FCF419F5;
	Fri, 26 Jun 2026 07:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B840A1F000E9;
	Fri, 26 Jun 2026 07:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782458133;
	bh=3lVxdm0Ep0/M2ZYIKTC77sSAb+8Ja64CITv1+WKNFCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OxwOaYpaqmr2aOcT0SoHP1REiLiNj80JROVsNPvrfmy/4xobxnTZ8DFNS8aLhzsG2
	 pc1JYInzhAEN2BaPLK5IIiAOHveUeNvdS1h9ZGykqqnp5ZGjRF3zukUH5/xWpDaG4a
	 RLnkTDu6Q+3/Z+sAuJ4XlXT4mNqSWDTTOVDsTtQi8inuy+EB/yIT2FcP2ihzw3bZqr
	 j+iVV5RthEeDUHnj51btEokTNkIRCnngT+INPOu+UcePKVCbVPX4EZKw+Tlt7lv3My
	 3mwPy1OWlmkE3FxK8W0FsHXg9gLrC5vSd88rLK6Wzytl3VcjKiIyKvITr5gkqr/kZ9
	 26sUDDbQD9wjA==
Message-ID: <dc5e47af-1434-4e43-8ca7-f90de3dc3f63@kernel.org>
Date: Fri, 26 Jun 2026 16:15:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260625151554.55105-1-qi.zheng@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------m7QUOiwKcAfVY02vm0zfaXUG"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6798C100007
X-Stat-Signature: dpibik7ihhf8gpiujcg91fkckq5jikfn
X-HE-Tag: 1782458134-99256
X-HE-Meta: U2FsdGVkX19e89Gwq5O+wWpPOeQ3FqCWywb5heP761jEducjO7z9pK3sIfJqjVoDBr0VBYsRRJkJ1A9fpgYXj0QTKymBNaeTEhFRTRA0x0pmmBWbmfffzlnUCV3MrqmOiLyfvyMHsnj+2xcCtuuQfSD2e9yt3b8/d+2qI3utMY9JUPKgbwNdpR6XWWzZHUQsh/IdAPCt9PnT7VX5DZTQ1n0mF8dWqDw/KUMeSFyO46h1XwhnJqiUyO8At+1tUt2+cJ2jzjZJkKu7G+3PpbSmSJ15Cn5FqbT8dEOnYM+y+J3NT+oDGqQ/ddkCY1osbM9+c9h8jDWJO5wggIBiQ/RmniRdBTDFKNJYeX18Wrcon8I6NINlCNdnICJIEkWuEdKf6DmjFwQIjgUHN43NK/2j4lW2/AP/Hqq7d4F0XrrZtiDfIOwTHzpuunkRXAV9xWTfB5/e6RsuaJvGEpnHWg4P8VjEOzEMG7VXwvuIKwi1WxT/o7My2jJQ4DfIkBWbdBElyyfACinCve9s/Fwxts6hQXasytESO9rC8KMvE8Hm/GLRPqyvHSbPw2sZouYBcLJuT5724ewjEOEGhCIka9IHro6rOwDVKG8jJwWwbwwErhhcw3acrmcAAdqmQuiNhAJFpF3K/qiEmTYO42s9VgiJbIfLh+H73ih2gFxbLXiPA/26fWC4mNokiTkmnLmRqtmsBPXtAMgdSY1en+HzeeHHuVEq5C51PpwZ0GF5JFIhfvEiuE2A8TtOC6ZpMLN6CBHAj9CGUJeIdALXbLIKhWRm49zJu1cppWmThMakRMDVSrgcazW1TAiwUsBEXpZnSGNtVTZosSkckM3IljWEKj5dbzawTuCfA5xL42IP6u2qIMbUrKHLv0vdE3zBEDeYYotwen7eU2nixjNU5CrBHsRfjlk2Sl9uF6Ov7y4lJcPRKBVpi2cT2fgRaXzea2/3gN27KKw/eIzyvNeYgc+roy0
 fW6OMSqZ
 sVbZVtXDCYW6TY3dNYWTexJVpTCZComY2j1LfOGBnX8hnvzbcENw4dIQJa8MrI81/d26qL+Jf0r1253vGFHi4EA4WxPFyqH6E4IWYu7XhVx6LoN7ch5gjBgGNFalXy6lb5PU70//Buo6F3vzrnilPhkZUU07PlqmuhYPG4yg8KxDk3eZ5RSulO02LZhOTiHGCZ9KUSDFyjV6cB7zTzwHai6w6qoM3STpm2eU0EeuPsDftLPJeYfs9b9F4MCBruSW2/wtSXj3c/sGOvnuLozsNhDsRh/BiKXHhXCpQi+k1g8pEg662EqRPxnVvGSgwLkv/FLHD2G3JKuBw21HGQjCfH2dgOO5uBDVe/JxWnCOdqit8ch8jU+og/99dnbFDW36KiS8HgT43Tbe8Q6gjBXaYALLoSxFpl2msB0V6GuUfttK9aU73vRs5yg7JSvxIWUgcK2wN0cnLVE8JJa1bIxWKLHGpLairUfPgfNBhTlbvVfWSddGKUrFdLyvMmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------m7QUOiwKcAfVY02vm0zfaXUG
Content-Type: multipart/mixed; boundary="------------5KW8ae2yJZ4W4qD8pteHlVMf";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Message-ID: <dc5e47af-1434-4e43-8ca7-f90de3dc3f63@kernel.org>
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260625151554.55105-1-qi.zheng@linux.dev>
In-Reply-To: <20260625151554.55105-1-qi.zheng@linux.dev>

--------------5KW8ae2yJZ4W4qD8pteHlVMf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/26/26 12:15 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec loc=
k.
> The reset_batch_size() later folds those deltas into walk->lruvec under=

> the lruvec lock.
>=20
> The page table walker can run concurrently with the memcg reparenting p=
ath
> as follows:
>=20
> CPU0                           CPU1
> =3D=3D=3D=3D                           =3D=3D=3D=3D
>=20
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages +=3D delta
>=20
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to pare=
nt
>                                       unlock lruvec
>=20
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages +=3D delta
>=20
> This will trigger the following warning in lru_gen_exit_memcg():
>=20
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
>=20
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pag=
es
> reaches zero, but there are still more pages.
>=20
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec=

> stable against RCU-delayed offlining; a dying memcg redirects the delta=
s
> to the first non-dying ancestor.
>=20
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a=
-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios"=
)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

besides some nits mentioned elsewhere in the thread,
the approach looks good to me, so:

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------5KW8ae2yJZ4W4qD8pteHlVMf--

--------------m7QUOiwKcAfVY02vm0zfaXUG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj4nDAAKCRCGXBN6rc5S
1vJdAP41DQ/Adn/NHl8DrlVUlhHpdYGNd+BlOc6FRwocVOTrGQEA/zSmKeZqWesI
TcJfcwrQQoZKB/v7BJGNTnJRLM7YEg0=
=xY2b
-----END PGP SIGNATURE-----

--------------m7QUOiwKcAfVY02vm0zfaXUG--

