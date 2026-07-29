Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F51C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 17:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62ECF6B009E; Wed, 29 Jul 2026 13:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8606B009F; Wed, 29 Jul 2026 13:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459886B00A1; Wed, 29 Jul 2026 13:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FA3A6B009E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:15:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BEF5120721
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:15:02 +0000 (UTC)
X-FDA: 85042464444.20.3FC7784
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7015C180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:15:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dYon6dIv;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785345300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as2evUZR5174x9zbmjMJ18+JiY7zmu358dRWIJklKRA=;
	b=TtYX+5SElFDPk0/AO98Kmi9VuEIDXO87H872hTmSsWE6H7ao+HXIuHZFgjzN9SxYxA/yib
	fw4JTdyChTB4G+RAkfkd5SqZviHOJtMbrq8ng0KMCH/ZTksM/0SF5lEI9NHJWlm0IKvDaf
	awUStnPGuKfrxR7YjoMehcPGLKL/2XM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785345300;
	b=NF6x4h88zfS+J1fSKe/3fcyVvSsHASaJ0V3g7zei+597uiDJ7AHKYzrx0VYw53Nn58973z
	9nMXxnJkSM+C0d31sz8+n26TcGZwwW20Z9BmUdCZeBMmPNG2u09jkfmKTBZpYvq2rOYm3r
	VsgaFT8e8uaG6Vqf+x8tmPpoWj6sTho=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dYon6dIv;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ce7d2adef4so18377325ad.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:15:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785345299; cv=none;
        d=google.com; s=arc-20260327;
        b=L9rV6T/cp8qCZ8ZfcJI8+XelNcVuHNzPx/RSCm1TnkM0Tup77X2Q6sfobpkrftpOrs
         +fX4miBN+tbhJmHH1CB8p8OmcqcR1hBwD9ko6AqCaZOi+GUckEvWXY6O33VvfMEY0qO0
         O7/S4MrSBljpk8f5BjiEehBWiKYw4rzQ9tPx6c6Ax5oV+7KeURLVU7MTK9xQr1LKzMyw
         kD7YcsIMGow0qdiV7gbmrYrW5foNYxiCCxlECEehgUzcdkSb1u8kgHF289N6x+ZmRoS/
         9PVrdbRd4o6fWnZ5rEhJ8QsW3JzY23TWy40eXKfxqhDg8r3OgL8yTwX3/3GWqgA8T8ME
         pHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=as2evUZR5174x9zbmjMJ18+JiY7zmu358dRWIJklKRA=;
        fh=sTlBtjtxUdhFFnFHsn+tW65ypHdNfVdKdvyuu4cEKqY=;
        b=XrFE5v+HaoB6m8GOEr9YAYZ/h1F5H39GC7m9kpxtriB5JtODzAAcj25+eBwDGieppa
         lCQkKUP+fQq0n6/A7FTyHJEaputr/3/hKsHEKqzAmeJDL95Yzv2Ykg8DbEsZwCmQESID
         TLf0ArL7XMGgxn8iltg8bBxEBvfSN8EA6f/Aiyt0rY26HXHag/hJI/OdGI6iztsxjt9g
         e7Dq3G1kGlTziPxqT1bt1IQy+l6p2bRtIZ5xhujDLAV42xQGvfbT2t6Cz/s/UivPwyR8
         eaRgeYBkeP3rmFUUSxDGYYXDhcUxUmLink0ffiC/ZnDUf6NOhk/ZOWZE55aWZU72MKdE
         2q3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785345299; x=1785950099; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=as2evUZR5174x9zbmjMJ18+JiY7zmu358dRWIJklKRA=;
        b=dYon6dIvjvWekVGjWoaUliMfcvF47qjEJqWSJvTUS3WmwchKX9l+1b+86nGybvGoMA
         454/lEJ66Xg1f0uF2y8yDCCJ3zmdAts/2hksssw4EKuR2nN/PVC+wmecFDRec1iHH+m3
         yzlEXFvsZOgcQwlgL+SBz6Gl9k9uXW1dzYGqrmw7C56t4BJzMkFqiMl2aHZ1hzoKitqF
         BH99qJPYJqTykm1AeGRzrrNZl7aXRhrSaesBDgzI7QCGKFa+KtUHONWrfigbjGILNaTM
         yY5QufB4TD5nzAlGeK2PPBxb1xVPE/j78e401yqlvA8CWAgdYkUykLmsgugARtqzhygN
         N7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785345299; x=1785950099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=as2evUZR5174x9zbmjMJ18+JiY7zmu358dRWIJklKRA=;
        b=B2sjnXKy2cp3L6My0thufwg6z39hf32RwlGMxj9cdnnoCYsWMv5YN7C53G4JoZE5Ga
         UzkoKnR7ciBQBLrF28uR2DE4RE1SBoDK/Vy+12VCQ42ChMdNxBACzr8PmWBb3da6K4pR
         jhEurcRVeqXCS9kAz5fO94zZgbG/TKYpyZc0KfkmGev2g3qVpc6EeawVDHLlhZ9IClAS
         SJQH7tY6j9DMN6fZuit+30RPG/LXhTPwehgdtzBlFHMIGX+hW2hCy4C7nNTNJw8SwJeK
         XGYuHdU5VihJ6VD8c0PAJwq8xe2A7H5T94RqWaotNCLOjzAAcSq3XPNH7+885ZVOMxHd
         OeYw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0dBzGvNFfbiWbrPaq72cKpCZ8EltDchMYem09wCMC/6ejnOMnAl15E6ASQCTFBh749JbnDKmeJg==@kvack.org
X-Gm-Message-State: AOJu0YwRHgENRn2t1ozN75z2kH8fR5rdyePKs/LVD8CzZovzforT9g1X
	8vZgZLhzgTnxoz8PRGrpVwy93lzNN1jAaPMZovVx1YJR3OIkIkJnob9kDTiaQpi6upkSGpSbl2j
	+m3dMAi3c4S5aN2NM3hPTMut6ZagLKOD2QgA+Zmi+
X-Gm-Gg: AR+sD10sewG7nkkJM6hn40/Eab1nsyoqbQImHeAI+OGikjJhIAzPyB/Tt/mYuElk033
	tPeBIeJ2bEpBJaVYtD7dDRvf5ULWSZjQ6uLsn9J3iZD4mxImNgTEk0t5zVkCCyXSWy5G3IfauRW
	RRbEWeVOKE+iFdcmO3jVlItkfhcT0uyVoYNiN1P+wguWPV88DdNSswKbq/y9DSnpRGuw4P4s6jW
	hIlcWPBUmGEWaxFbMiEGq37+GILCsm+UjqRjOwXVoSeuJxtkdJfGEyRMSDmkwXCNRuxYeKlzoiN
	LdRFWI3x+T/hnmcj05vl7ZBpCoNbrixLqOOZEOaH/mTu7iVGGuwGDm0I9EOTqnTGwLCixi/mlTo
	vAQtGzLTKr7jp+oMPOtre8hdcxTgRQQTjJ4k=
X-Received: by 2002:a05:6a21:648e:b0:3c4:302e:803c with SMTP id
 adf61e73a8af0-3c8ba61ad2emr9540205637.61.1785345298564; Wed, 29 Jul 2026
 10:14:58 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Jul 2026 10:14:57 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Jul 2026 10:14:57 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-1-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
 <20260722-hugetlb-alloc-failure-fixes-v4-1-88e8b81970dc@google.com>
MIME-Version: 1.0
Date: Wed, 29 Jul 2026 10:14:57 -0700
X-Gm-Features: AUfX_mx4FC7g70bp9YMT6qRgtu_ojTY-UB_ArAnlZOfAQDe4XFWSw92oMszySWI
Message-ID: <CAEvNRgGPS7irKKq-TMjuhEK-xjbEvbxJn+X4nM6Qw95GKHbU3A@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] mm: hugetlb: Track used_hpages when
 getting/putting pages from subpool
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
	jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
	Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7015C180002
X-Stat-Signature: cbjq3dfdimam1nzjynwspyqq3mhiw1g8
X-HE-Tag: 1785345300-245027
X-HE-Meta: U2FsdGVkX1/PQOYy1IQt0/6NGDmTn3F/hBRvE794CRWlViGF4lEJWWUy18MCHSTQ5BSDSrQ9CyNewa4pYkfioVEOKwp4BBmi7p8kAdfrGkzAFZjCLWJwsAI9VybPKgWO+IrymrJM4TQrLJZ46CfKPR9EXsJSiXIXtd8Da2g7HUiw/vrdbj13ZznkVhSBOhTsydTH1UpVbcKaEgWiUb0asyB239YFqghaSzxWRnOOPiCBjdzzodrir6Ar+rnObWTDCdOkCbNDUSkeeTzgpKlH9RLsTCtiUzFEiIcJQHFvy/OdZffs+gcKZru5MpsHCSDVJ8ZBgMGumIjtvFlOJCcSDJGOSPUL0+vakdxZY+ni8gdXVKXYfmvphAJ0Y7QFRxbhXEt0DdMgCGAseHBYpXbXHp39PQnSCChS2wnhIKuws6VywG6aliQy2JWFk2ax8tqwjwVJEI39fKlZbsCHtn7bOrbXGbQXf7/Ud3zkZxfuhCt8fAfrRILUYv57yscCXD6JUrZk+SFvUbzFP+SQULoxzjQTUUCJ6Pgva6IFoGBXiIRIJV5J8BS5UoO4LjcRqCr7KHzXtq3jk2uUGiAFywzfcNPwoMheD/01O0/Z4/K1Zpzl+prNLla3jXMaMbMgfMTw/vZkOeNyNWRQzLkhIfwn9e86krov1jXm2/HGbjQsS2xMdTK+SXfTgZ1FIAe5LGWI3lCyNAk2BtQ5U0G674JBY52yvM8Ax2dD77qFfp4pnPUy08DEnrs1pSOg/XVOIy60QGzMC09axGMBKGB+wArqEwe0fR+jKLVHKhvLSW7N+48IQ+9aAma0d3yBrz/nG5RHgTd9Op4D04nfDwAWYhRs/0pThTCwsXHRjx+DMER8wb6k1IMsAB7adJQP/0zod+2wjcdxQPQUwlah5ynKBBnpp3QHnU2n2XpZuxAi63IVL2oUqsC2F7MtsbkUFkObnCWU0G9lFQeIdQE3osLNrrH
 SsBgaxw3
 XJTHKakh7OdKs9k8/QKzmN2o7Q4aDuQ4kfH41KK9PrK+S0mIXQjlcsWwLthJtC9jNSI1hQVO99C4aYpWCyNTbMePlvLhTlkA/QeNYZhEAHBcReg40PeVf/VMYVFBMCJMV8qZxlMmwtkGV3+lAbh1OOF0H0ZFL1GnK3wP5MTDUn7gQ3Ja6gI35vx6nVwevrLgVRpFylTfG9XfhGZ3pad0EULiPSI5NZANVqRoXTp8Amj2Xe7aD+8xH5LOMn9+wsGfpqluSNA4ydsswc0VdRsFVRJRGnDgMf+Z4JUVBDxr5+0XSVHQeQ+9oR7gd6O2zQAdVRhaVo47/BAJK06Y3VJVb5GvQjEHF4KR5VF/9rRW6Bb5abEMepYM6rwdSz4513Sg2fPeEMDqROLKLL3C5MC59T23yPjZnht6CKA+PAG+bOTg6UeJKpSX/WPLNzWYxrGNBPi6uJs1zx3RvlNMhtps2g55ZFiJF6+k7JByFEgoD53YIi6Nzs4Qhe2WafKY82O9hOMyFZ+everTFghGf0DKx6aQHPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> hugepage_subpool_put_pages() currently has two distinct responsibilities
> that conflict:
>
> 1. When size is specified for the mount, max_hpages !=3D -1: Keep track o=
f
>    total active pages (allocated + reserved) and decrement this count
>    (used_hpages) when a page is freed or allocation fails.
> 2. When min_size is specified for the mount, min_hpages !=3D -1: Ensure w=
e
>    don't drop below the guaranteed minimum, and restore a reservation
>    (rsv_hpages) if we do.
>
> This causes trouble because when allocation fails (refer to
> alloc_hugetlb_folio()) if gbl_chg =3D 1 (i.e. no subpool reservation was
> taken):
>
> + To keep used_hpages consistent, HugeTLB needs to call
>   hugepage_subpool_put_pages() to restore undo used_hpages being
>   incremented
> + But can't call hugepage_subpool_put_pages() if no reservation was
>   consumed.
>
> One option would be to conditionally do subpool tracking updates outside =
of
> the hugepage_subpool_put_pages() function, but that would spread logic al=
l
> over.
>
> Instead, always track used_hpages, regardless of whether a max_size was
> requested for the mount, so that the subpool always knows how many pages
> were allocated through it. Every page allocated through the subpool
> increments used_hpages, regardless of whether a reservation was taken fro=
m
> it.
>
> Conceptually, now, every allocation involving a subpool uses a page from
> the subpool, which must be returned to the subpool. Every page taken from
> the subpool tries to use a subpool reservation. Restoring a page to the
> subpool reservations only if the page was taken from subpool
> reservations. (If used_hpages >=3D min_hpages, the page must have not hav=
e
> been taken from the reservations.)
>
> Always tracking used_hpages provides the subpool with information of both
> used and reserved counts to make the correct decision for both max_size a=
nd
> min_size correctly.
>
> With used_hpages always tracked,
>
> + subpool_is_free() can be simplified, such that the subpool can be
>   declared free if there are no more pages in use.
> + open-coding in hugetlb_reserve_pages() can be removed.
>
> Also update the
>
> + Documentation for used_hpages in the subpool struct, since it no longer
>   matters whether the used pages count against the maximum.
> + Docstring for hugepage_subpool_{get,put}_pages
> + Documentation to use active voice, and remove some details in favor of
>   having details documented in the docstring
>
> Also update statfs reporting. Previously, if max_hpages is negative,
> used_hpages is static at 0, so returning max_hpages - used_hpages returns
> -1 and is always correct. Now, if the subpool doesn't have a maximum
> requested size, indicate no limit for free pages (-1). If it does have a
> maximum size, report the difference between the requested size and the
> number of used pages. This difference is always positive, because if the
> mount does have a maximum size, hugepage_subpool_get_pages() ensures that
> the subpool usage never exceeds the maximum.
>
> This fixes a bug in hugetlb_unreserve_pages(), where pages are returned t=
o
> the subpool regardless of whether it consumed a reservation. The
> corresponding bug in the failure handling path of alloc_hugetlb_folio() w=
as
> fixed in a833a693a490e.
>
> Fixes: 1c5ecae3a93fa ("hugetlbfs: add minimum size accounting to subpools=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/mm/hugetlbfs_reserv.rst              |  17 +--
>  .../translations/zh_CN/mm/hugetlbfs_reserv.rst     |  11 +-
>  fs/hugetlbfs/inode.c                               |   8 +-
>  include/linux/hugetlb.h                            |   4 +-
>  mm/hugetlb.c                                       | 118 +++++++++++----=
------
>  5 files changed, 75 insertions(+), 83 deletions(-)
>
> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hug=
etlbfs_reserv.rst
> index a49115db18c76..d244583fdcbc3 100644
> --- a/Documentation/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/mm/hugetlbfs_reserv.rst
> @@ -314,21 +314,8 @@ huge pages.  If they can not be reserved, the mount =
fails.
>  The routines hugepage_subpool_get/put_pages() are called when pages are
>  obtained from or released back to a subpool.  They perform all subpool
>  accounting, and track any reservations associated with the subpool.
> -hugepage_subpool_get/put_pages are passed the number of huge pages by wh=
ich
> -to adjust the subpool 'used page' count (down for get, up for put).  Nor=
mally,
> -they return the same value that was passed or an error if not enough pag=
es
> -exist in the subpool.
> -
> -However, if reserves are associated with the subpool a return value less
> -than the passed value may be returned.  This return value indicates the
> -number of additional global pool adjustments which must be made.  For ex=
ample,
> -suppose a subpool contains 3 reserved huge pages and someone asks for 5.
> -The 3 reserved pages associated with the subpool can be used to satisfy =
part
> -of the request.  But, 2 pages must be obtained from the global pools.  T=
o
> -relay this information to the caller, the value 2 is returned.  The call=
er
> -is then responsible for attempting to obtain the additional two pages fr=
om
> -the global pools.
> -
> +hugepage_subpool_get/put_pages() use the number of huge pages passed to =
adjust
> +the subpool 'used page' count.
>
>  COW and Reservations
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst b/D=
ocumentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> index 20947f8bd0654..ae1f1f31477fc 100644
> --- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> @@ -246,15 +246,8 @@ hugepage_subpool=E7=9A=84min_hpages=E5=AD=97=E6=AE=
=B5=E4=B8=AD=E8=A2=AB=E8=B7=9F=E8=B8=AA=E3=80=82=E5=9C=A8=E6=8C=82=E8=BD=BD=
=E6=97=B6=EF=BC=8Chugetlb_acct_me
>  =E8=A2=AB=E8=B0=83=E7=94=A8=E4=BB=A5=E9=A2=84=E7=95=99=E6=8C=87=E5=AE=9A=
=E6=95=B0=E9=87=8F=E7=9A=84=E5=B7=A8=E9=A1=B5=E3=80=82=E5=A6=82=E6=9E=9C=E5=
=AE=83=E4=BB=AC=E4=B8=8D=E8=83=BD=E8=A2=AB=E9=A2=84=E7=95=99=EF=BC=8C=E6=8C=
=82=E8=BD=BD=E5=B0=B1=E4=BC=9A=E5=A4=B1=E8=B4=A5=E3=80=82
>
>  =E5=BD=93=E4=BB=8E=E5=AD=90=E6=B1=A0=E4=B8=AD=E8=8E=B7=E5=8F=96=E6=88=96=
=E9=87=8A=E6=94=BE=E9=A1=B5=E9=9D=A2=E6=97=B6=EF=BC=8C=E4=BC=9A=E8=B0=83=E7=
=94=A8hugepage_subpool_get/put_pages()=E5=87=BD=E6=95=B0=E3=80=82
> -hugepage_subpool_get/put_pages=E8=A2=AB=E4=BC=A0=E9=80=92=E7=BB=99=E5=B7=
=A8=E9=A1=B5=E6=95=B0=E9=87=8F=EF=BC=8C=E4=BB=A5=E6=AD=A4=E6=9D=A5=E8=B0=83=
=E6=95=B4=E5=AD=90=E6=B1=A0=E7=9A=84 =E2=80=9C=E5=B7=B2=E7=94=A8=E9=A1=B5=
=E9=9D=A2=E2=80=9D =E8=AE=A1=E6=95=B0
> -=EF=BC=88get=E4=B8=BA=E4=B8=8B=E9=99=8D=EF=BC=8Cput=E4=B8=BA=E4=B8=8A=E5=
=8D=87=EF=BC=89=E3=80=82=E9=80=9A=E5=B8=B8=E6=83=85=E5=86=B5=E4=B8=8B=EF=BC=
=8C=E5=A6=82=E6=9E=9C=E5=AD=90=E6=B1=A0=E4=B8=AD=E6=B2=A1=E6=9C=89=E8=B6=B3=
=E5=A4=9F=E7=9A=84=E9=A1=B5=E9=9D=A2=EF=BC=8C=E5=AE=83=E4=BB=AC=E4=BC=9A=E8=
=BF=94=E5=9B=9E=E4=B8=8E=E4=BC=A0=E9=80=92=E7=9A=84=E7=9B=B8=E5=90=8C=E7=9A=
=84=E5=80=BC=E6=88=96
> -=E4=B8=80=E4=B8=AA=E9=94=99=E8=AF=AF=E3=80=82
> -
> -=E7=84=B6=E8=80=8C=EF=BC=8C=E5=A6=82=E6=9E=9C=E9=A2=84=E7=95=99=E4=B8=8E=
=E5=AD=90=E6=B1=A0=E7=9B=B8=E5=85=B3=E8=81=94=EF=BC=8C=E5=8F=AF=E8=83=BD=E4=
=BC=9A=E8=BF=94=E5=9B=9E=E4=B8=80=E4=B8=AA=E5=B0=8F=E4=BA=8E=E4=BC=A0=E9=80=
=92=E5=80=BC=E7=9A=84=E8=BF=94=E5=9B=9E=E5=80=BC=E3=80=82=E8=BF=99=E4=B8=AA=
=E8=BF=94=E5=9B=9E=E5=80=BC=E8=A1=A8=E7=A4=BA=E5=BF=85=E9=A1=BB=E8=BF=9B=E8=
=A1=8C=E7=9A=84=E9=A2=9D=E5=A4=96=E5=85=A8=E5=B1=80
> -=E6=B1=A0=E8=B0=83=E6=95=B4=E7=9A=84=E6=95=B0=E9=87=8F=E3=80=82=E4=BE=8B=
=E5=A6=82=EF=BC=8C=E5=81=87=E8=AE=BE=E4=B8=80=E4=B8=AA=E5=AD=90=E6=B1=A0=E5=
=8C=85=E5=90=AB3=E4=B8=AA=E9=A2=84=E7=95=99=E7=9A=84=E5=B7=A8=E9=A1=B5=EF=
=BC=8C=E6=9C=89=E4=BA=BA=E8=A6=81=E6=B1=825=E4=B8=AA=E3=80=82=E4=B8=8E=E5=
=AD=90=E6=B1=A0=E7=9B=B8=E5=85=B3=E7=9A=843=E4=B8=AA=E9=A2=84=E7=95=99=E9=
=A1=B5=E5=8F=AF=E4=BB=A5=E7=94=A8=E6=9D=A5
> -=E6=BB=A1=E8=B6=B3=E9=83=A8=E5=88=86=E8=AF=B7=E6=B1=82=E3=80=82=E4=BD=86=
=E6=98=AF=EF=BC=8C=E5=BF=85=E9=A1=BB=E4=BB=8E=E5=85=A8=E5=B1=80=E6=B1=A0=E4=
=B8=AD=E8=8E=B7=E5=BE=972=E4=B8=AA=E9=A1=B5=E9=9D=A2=E3=80=82=E4=B8=BA=E4=
=BA=86=E5=90=91=E8=B0=83=E7=94=A8=E8=80=85=E8=BD=AC=E8=BE=BE=E8=BF=99=E4=B8=
=80=E4=BF=A1=E6=81=AF=EF=BC=8C=E5=B0=86=E8=BF=94=E5=9B=9E=E5=80=BC2=E3=80=
=82=E7=84=B6=E5=90=8E=EF=BC=8C=E8=B0=83=E7=94=A8
> -=E8=80=85=E8=A6=81=E8=B4=9F=E8=B4=A3=E4=BB=8E=E5=85=A8=E5=B1=80=E6=B1=A0=
=E4=B8=AD=E8=8E=B7=E5=8F=96=E5=8F=A6=E5=A4=96=E4=B8=A4=E4=B8=AA=E9=A1=B5=E9=
=9D=A2=E3=80=82
> -
> +=E5=AE=83=E4=BB=AC=E8=B4=9F=E8=B4=A3=E6=89=80=E6=9C=89=E5=AD=90=E6=B1=A0=
=E7=9A=84=E7=BB=9F=E8=AE=A1=E6=A0=B8=E7=AE=97=EF=BC=8C=E5=B9=B6=E8=B7=9F=E8=
=B8=AA=E4=B8=8E=E5=AD=90=E6=B1=A0=E7=9B=B8=E5=85=B3=E8=81=94=E7=9A=84=E9=A2=
=84=E7=95=99=E3=80=82
> +hugepage_subpool_get/put_pages()=E5=87=BD=E6=95=B0=E4=BD=BF=E7=94=A8=E4=
=BC=A0=E5=85=A5=E7=9A=84=E5=B7=A8=E9=A1=B5=E6=95=B0=E9=87=8F=E6=9D=A5=E8=B0=
=83=E6=95=B4=E5=AD=90=E6=B1=A0=E7=9A=84=E2=80=9C=E5=B7=B2=E7=94=A8=E9=A1=B5=
=E9=9D=A2=E2=80=9D=E8=AE=A1=E6=95=B0=E3=80=82
>
>  COW=E5=92=8C=E9=A2=84=E7=95=99
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 216e1a0dd0b23..26c0187340636 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -1109,8 +1109,12 @@ static int hugetlbfs_statfs(struct dentry *dentry,=
 struct kstatfs *buf)
>
>  			spin_lock_irq(&sbinfo->spool->lock);
>  			buf->f_blocks =3D sbinfo->spool->max_hpages;
> -			free_pages =3D sbinfo->spool->max_hpages
> -				- sbinfo->spool->used_hpages;
> +			if (sbinfo->spool->max_hpages =3D=3D -1) {
> +				free_pages =3D -1;
> +			} else {
> +				free_pages =3D sbinfo->spool->max_hpages -
> +					     sbinfo->spool->used_hpages;
> +			}
>  			buf->f_bavail =3D buf->f_bfree =3D free_pages;
>  			spin_unlock_irq(&sbinfo->spool->lock);
>  			buf->f_files =3D sbinfo->max_inodes;
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e90..34b9a3e1be0fa 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -38,8 +38,8 @@ struct hugepage_subpool {
>  	spinlock_t lock;
>  	long count;
>  	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
> -	long used_hpages;	/* Used count against maximum, includes */
> -				/* both allocated and reserved pages. */
> +	long used_hpages;	/* Used page count, includes both */
> +				/* allocated and reserved pages. */
>  	struct hstate *hstate;
>  	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
>  	long rsv_hpages;	/* Pages reserved against global pool to */
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835e..36fa3fb3945d8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -129,12 +129,8 @@ static inline bool subpool_is_free(struct hugepage_s=
ubpool *spool)
>  {
>  	if (spool->count)
>  		return false;
> -	if (spool->max_hpages !=3D -1)
> -		return spool->used_hpages =3D=3D 0;
> -	if (spool->min_hpages !=3D -1)
> -		return spool->rsv_hpages =3D=3D spool->min_hpages;
>
> -	return true;
> +	return spool->used_hpages =3D=3D 0;
>  }
>
>  static inline void unlock_or_release_subpool(struct hugepage_subpool *sp=
ool,
> @@ -187,13 +183,18 @@ void hugepage_put_subpool(struct hugepage_subpool *=
spool)
>  	unlock_or_release_subpool(spool, flags);
>  }
>
> -/*
> - * Subpool accounting for allocating and reserving pages.
> - * Return -ENOMEM if there are not enough resources to satisfy the
> - * request.  Otherwise, return the number of pages by which the
> - * global pools must be adjusted (upward).  The returned value may
> - * only be different than the passed value (delta) in the case where
> - * a subpool minimum size must be maintained.
> +/**
> + * hugepage_subpool_get_pages - Get pages from a subpool
> + * @spool: pointer to subpool structure (may be NULL)
> + * @delta: number of pages to allocate or reserve
> + *
> + * Check and update subpool page usage counts when allocating or
> + * reserving @delta hugepages.
> + *
> + * Context: Takes spool->lock using spin_lock_irq().
> + * Return: Non-negative number of reservations that cannot be
> + *         satisfied by the subpool, or -ENOMEM if the subpool maximum
> + *         limit would be exceeded.
>   */
>  static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
>  				      long delta)
> @@ -205,15 +206,14 @@ static long hugepage_subpool_get_pages(struct hugep=
age_subpool *spool,
>
>  	spin_lock_irq(&spool->lock);
>
> -	if (spool->max_hpages !=3D -1) {		/* maximum size accounting */
> -		if ((spool->used_hpages + delta) <=3D spool->max_hpages)
> -			spool->used_hpages +=3D delta;
> -		else {
> -			ret =3D -ENOMEM;
> -			goto unlock_ret;
> -		}
> +	if (spool->max_hpages !=3D -1 &&
> +	    spool->used_hpages + delta > spool->max_hpages) {
> +		ret =3D -ENOMEM;
> +		goto unlock_ret;
>  	}
>
> +	spool->used_hpages +=3D delta;
> +
>  	/* minimum size accounting */
>  	if (spool->min_hpages !=3D -1 && spool->rsv_hpages) {
>  		if (delta > spool->rsv_hpages) {
> @@ -234,11 +234,19 @@ static long hugepage_subpool_get_pages(struct hugep=
age_subpool *spool,
>  	return ret;
>  }
>
> -/*
> - * Subpool accounting for freeing and unreserving pages.
> - * Return the number of global page reservations that must be dropped.
> - * The return value may only be different than the passed value (delta)
> - * in the case where a subpool minimum size must be maintained.
> +/**
> + * hugepage_subpool_put_pages - Release pages back to a subpool
> + * @spool: pointer to subpool structure (may be NULL)
> + * @delta: number of pages to free or unreserve
> + *
> + * Check and update subpool page usage counts when freeing or
> + * unreserving @delta hugepages.
> + *
> + * Context: Takes spool->lock using spin_lock_irqsave(). May release
> + *          and free @spool if its usage count and references reach
> + *          zero.
> + * Return: Non-negative number of reservations that the subpool cannot
> + *         absorb.
>   */
>  static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
>  				       long delta)
> @@ -251,19 +259,24 @@ static long hugepage_subpool_put_pages(struct hugep=
age_subpool *spool,
>
>  	spin_lock_irqsave(&spool->lock, flags);
>
> -	if (spool->max_hpages !=3D -1)		/* maximum size accounting */
> -		spool->used_hpages -=3D delta;
> +	spool->used_hpages -=3D delta;
>
>  	 /* minimum size accounting */
>  	if (spool->min_hpages !=3D -1 && spool->used_hpages < spool->min_hpages=
) {
> -		if (spool->rsv_hpages + delta <=3D spool->min_hpages)
> +		/*
> +		 * limit is the maximum number of reservations that
> +		 * can be restored to this subpool.
> +		 */
> +		long limit =3D spool->min_hpages - spool->used_hpages;
> +
> +		if (spool->rsv_hpages + delta <=3D limit)
>  			ret =3D 0;
>  		else
> -			ret =3D spool->rsv_hpages + delta - spool->min_hpages;
> +			ret =3D spool->rsv_hpages + delta - limit;
>
>  		spool->rsv_hpages +=3D delta;
> -		if (spool->rsv_hpages > spool->min_hpages)
> -			spool->rsv_hpages =3D spool->min_hpages;
> +		if (spool->rsv_hpages > limit)
> +			spool->rsv_hpages =3D limit;
>  	}
>
>  	/*
> @@ -6542,7 +6555,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		struct vm_area_struct *vma,
>  		vma_flags_t vma_flags)
>  {
> -	long chg =3D -1, add =3D -1, spool_resv, gbl_resv;
> +	long chg =3D -1, add =3D -1, gbl_resv;
>  	struct hstate *h =3D hstate_inode(inode);
>  	struct hugepage_subpool *spool =3D subpool_inode(inode);
>  	struct resv_map *resv_map;
> @@ -6622,9 +6635,9 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * the subpool has a minimum size, there may be some global
>  	 * reservations already in place (gbl_reserve).
>  	 */
> -	gbl_reserve =3D hugepage_subpool_get_pages(spool, chg);
> -	if (gbl_reserve < 0) {
> -		err =3D gbl_reserve;
> +	gbl_resv =3D hugepage_subpool_get_pages(spool, chg);
> +	if (gbl_resv < 0) {
> +		err =3D gbl_resv;
>  		goto out_uncharge_cgroup;
>  	}
>
> @@ -6632,7 +6645,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * Check enough hugepages are available for the reservation.
>  	 * Hand the pages back to the subpool if there are not
>  	 */
> -	err =3D hugetlb_acct_memory(h, gbl_reserve);
> +	err =3D hugetlb_acct_memory(h, gbl_resv);
>  	if (err < 0)
>  		goto out_put_pages;
>
> @@ -6651,7 +6664,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		add =3D region_add(resv_map, from, to, regions_needed, h, h_cg);
>
>  		if (unlikely(add < 0)) {
> -			hugetlb_acct_memory(h, -gbl_reserve);
> +			hugetlb_acct_memory(h, -gbl_resv);
>  			err =3D add;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
> @@ -6687,26 +6700,21 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	}
>  	return chg;
>
> -out_put_pages:
> -	spool_resv =3D chg - gbl_reserve;
> -	if (spool_resv) {
> -		/* put sub pool's reservation back, chg - gbl_reserve */
> -		gbl_resv =3D hugepage_subpool_put_pages(spool, spool_resv);
> -		/*
> -		 * subpool's reserved pages can not be put back due to race,
> -		 * return to hstate.
> -		 */
> -		hugetlb_acct_memory(h, -gbl_resv);
> -	}
> -	/* Restore used_hpages for pages that failed global reservation */
> -	if (gbl_reserve && spool) {
> -		unsigned long flags;
> + out_put_pages:
> +	/*
> +	 * Return all that was requested from the subpool, let subpool
> +	 * tell us the new number of reservations that need to be
> +	 * returned to the global pool.
> +	 */
> +	gbl_reserve =3D hugepage_subpool_put_pages(spool, chg);
> +	/*
> +	 * There may be a difference between the number of
> +	 * reservations to consume and the number to restore now if
> +	 * there are multiple threads interacting with the subpool -
> +	 * restore the difference.
> +	 */
> +	hugetlb_acct_memory(h, gbl_resv - gbl_reserve);

Sashiko had a few comments on this patch, the following is the only one
that isn't addressed in a later patch in this same series:

  [Severity: Critical]
  Does this code leave the subpool with phantom global reservations if
  hugetlb_acct_memory() fails?

  If hugetlb_acct_memory() is called with a positive delta here (meaning th=
e
  subpool absorbed some reservations) and it returns -ENOMEM because the gl=
obal
  pool is exhausted, the return value is ignored.

  Could this artificially inflate the subpool's rsv_hpages without backing
  global pages, which would then inflate free_huge_pages out of thin air wh=
en
  the subpool is eventually destroyed?

This is true, but this is a failure path and I'm not really sure how
best to handle an error from hugetlb_acct_memory() in this case. Other
callers of hugetlb_acct_memory() don't handle failures either.


>
> -		spin_lock_irqsave(&spool->lock, flags);
> -		if (spool->max_hpages !=3D -1)
> -			spool->used_hpages -=3D gbl_reserve;
> -		unlock_or_release_subpool(spool, flags);
> -	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
>
> --
> 2.55.0.229.g6434b31f56-goog

