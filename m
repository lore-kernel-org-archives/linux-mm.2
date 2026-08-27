Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7033C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98FB6B0092; Thu, 27 Aug 2026 05:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FED6B0096; Thu, 27 Aug 2026 05:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FD96B0098; Thu, 27 Aug 2026 05:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 860E06B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:53:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC3D9A3B84
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:53:22 +0000 (UTC)
X-FDA: 85146586644.18.AC5A340
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id C93F3C000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:53:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W9EL1APJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V69wi16LUNblUa9nJqEd/LsAMjztWA0WyDgNToplCPU=;
	b=AGLFTKuFUB47zmi4ptUzZJCipX46xNC3m1+Xog3FOF5wGxRYYd/KNHI2F5+11PhfU7dI/L
	yzRak1boNrPvlh7HQlMXQPZXsNvgHntX97cdXlEzv8eD+k1oWEZxAOtRXoyNqb88b7V4mK
	Bt/BR4NFmbcxzKHK/HICLQPcBFrMK3A=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W9EL1APJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787824400;
	b=JyHGY4lvz0i8PHFx0Bz/3D+YZA5ke9vHhLNAYmnP5UnbxjnlcndceDj/z2pmqTt6FGRlGH
	qU/vQQbe88XobRRE70/WIoc01K4rD81EEYGMVFpLpam+6cvfb4nMlt/UXQsL8DxWtWxqEu
	hW5YCAXSbRwfSnmMmZkdWDPOzrIz93M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2055573c8cso291381266b.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787824399; cv=none;
        d=google.com; s=arc-20260327;
        b=sccOXbJwzkDbiE3BoY93F2Q88P3RYI3D5B+mAwozu9v6nQd5AJFxuXiXifrtFE1mfY
         1LE0S8XQlZh5Df2PVElMSt9CriT7T/1p4maMqXFJS7PpZhUM1x4InuCU19z9cEFTd+vF
         gzdU/z2gocNjmjpQew14doMa9qFtKJaHckWnJCXQpOZK+CYo5YHGxc0pi2CYQdL+IMWf
         aD/t5HZ+nUWUOOhfScnXJcBQScjQBYT0rKbZUIo1K6Yg/yRuQYWFQR3BSg7+v5JrVR/Y
         G4tiHKp6v+iSRQRPk5I1C1w2qk2XqqEn1eEnjGEb8SoiLH9crMpyae2DJi/T/mjH+HEv
         bbDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V69wi16LUNblUa9nJqEd/LsAMjztWA0WyDgNToplCPU=;
        fh=CEC/sWPyPvHkRtLAnGZHVHKvJUBv5jcI1k8XKimQEeI=;
        b=ET2acpUrJoGwkFFFsBEL8fbvoVCG7/8MRJr1elRV0lj3ic6SslBfzhelbKxg+aYE5A
         b/+M50HrhP/A8z/fvspc85s31Tv2/8qrBkHaxG+bOkridPETHuj/eZhW1h+hBd18ryJu
         xNKq9ozl9jhuACcBTg20x7ogEf1FZ5LbjrPgJFpO2ppw3H4w7zbZR746YEyVDtq7tZSP
         YSickXPYjM6recud0//yx2QDI5B1MnRpddDFS0Z7+haj1Vvg7HV2T5YINg9J+sgo8e5y
         pYY/+lb+kZ+MFiQy6J633INbluLLGcf2LoYMcbd7ASKZzGdzpyMB94Y/lMJ1y2u7SZ9h
         qCaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787824399; x=1788429199; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V69wi16LUNblUa9nJqEd/LsAMjztWA0WyDgNToplCPU=;
        b=W9EL1APJYkZASCDP8ml25duMZC4IRmCeXzm5a4f4GO6QqldcOwuBEkBcrmUJQWtMcv
         tylqEcdyd2OYvpovAf5xSpELXUmLpl/y4/Vu0S8woA0yhlPX39ZU8IiFga03dLhRNlhc
         fyUKCCB2KohOaQ5hH9387S4WkUqzCtc6/6aDSPUOBLwi6qmIWTneFowuSWshc9j4ofSf
         wblAqmaF2KvRZ07jfUEHT4YYUC2+J/YVl3jPeDmKlNG2oZHDQaTqLuObKQerYvQdosMh
         Awp7NUi+ZriOk+GzAvbyBagAmpj7sRPynFEKSBbSZI0OH8UWiU2sJDIEy1tkPag2Poxv
         g7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787824399; x=1788429199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V69wi16LUNblUa9nJqEd/LsAMjztWA0WyDgNToplCPU=;
        b=LqeMGkeDB8sKKgVJ22oh2tN3T5H1QcdfsVJTdkmH0lhIaSKqEbu58HHNvCoE2ZGCHR
         q3W4blWuzNBqoQdqb3dE76tf/FTfamOlhw985f9J0I2xWxUYmo1WEuE+NqxoDUaNNqWe
         QD5X+7vV6opdH6hUxL0+IRv/QWvuqgmn4kaUWk7LcUClZ8ldH+7WQ31icatL00omXzKh
         mjrQoX53omOOWryD1iAqQeTtuqqAEo5QveSzlEkPm7Ksx4JEyewjOVmrg8dkrBLdOMvP
         e0rqwXDuAR4p/pOtCS9tsb5bdojMcB61k7/BO0HbCxXeR4g6SSLi1c39znQFFPGQcYW5
         ZGAQ==
X-Forwarded-Encrypted: i=1; AHgh+RopgRVcyRWssI/igcvOBb9dJFPo7JAxFbQbyNmKoG+rltsTG2nffdy3pPjes6eOWEfXK4etpG1eOQ==@kvack.org
X-Gm-Message-State: AFuF++kueel0Kk5B0JTnTh8w02DQE+5YK0DHp/kkGjxBLAKo6DoeCQGO
	gt/ywJkytxPUlj5MovIzIQj0zQ5BJ21WwjqyX8BuZDrE0J/j6BKKox91VWk4bM63e0y9sAex85t
	i9DtVHCMg6EvDL3aG8CyQ8bk6sWlLjJk=
X-Gm-Gg: AR+sD12OchlLYjluiiBJ0mr21lGP1Ht4PX7ptJKEHcsMVwMank4qT89QDjwPzgJqK2b
	wd8Sq1/WuURiYDxJkqm9APBV+mBha/6Mt7X+/uGkm3trkvFmZATKBwxbWgKy1Gatk6ysU70iITs
	Ff5xk9dXufAFuEBmgOEW6OdocUwllG3qSE0tgLnAbh4n4fM4NL35EeEvSwajvLmmIGZIzv9S3At
	7zIEX+ykCozYF6vxB+vT1fDi1iChB4V71dV1sdPABbuK9IpoCbPflmb879jmQ/OEOHSRcbzUoof
	XLh3AdJoaJDeemDQA9JUtAvxAIel4Eyti/wo9n5uTNIf7ssSbfgCOD/moclq5yYL6u446lS8ehq
	gmQ==
X-Received: by 2002:a17:907:c23:b0:c12:9b93:61fd with SMTP id
 a640c23a62f3a-c250bb76ecbmr1325039966b.6.1787824398993; Thu, 27 Aug 2026
 02:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260827082722.1809702-1-yuehaibing@huawei.com>
In-Reply-To: <20260827082722.1809702-1-yuehaibing@huawei.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 17:52:42 +0800
X-Gm-Features: AcwNN1WwUiTkWAVLyp4BxCSmQtm-xAoV5FfSeeHtQxSaSTeH_J76_KhX5livf4M
Message-ID: <CAMgjq7CvP64ULRViPpMN3EHCViy1_nyY8ZnudrvUVXY-XFOvNQ@mail.gmail.com>
Subject: Re: [PATCH -next] mm/swap: Remove unused declaration swapcache_clear()
To: Yue Haibing <yuehaibing@huawei.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: o1w4bd3d8jfbqyya7c5kqbnsy9bywczr
X-Rspamd-Queue-Id: C93F3C000D
X-HE-Tag: 1787824400-739725
X-HE-Meta: U2FsdGVkX18adrD/XOekLfihQp3O/fHk6XG65FsaiNQp6ocuxS2WplZAIsbHPTBuKJiIM0gj0Jmy9cCT75k0ruB/4QTxwPNd/GdJOg9tUaX9Y9ReXbe89OQV+/w9DLlUxzleLrBV8rc26UFRAqgavt4sh2UYfBzpQ0kfD+xXcpvoGmY6TzqEX96ZNDwFKBo11kKG/VTBU7lDimsrIgF+ixwma31TDXC1C2JXuzw79sbMPTL2lYbo4js9aIg/4A+jZcP+P32KIjGbRX9zLlJzR1QlbPRwJCiG4U/NaB4VL5WwiXcFri/fo9oCjB65gNbJEZCb2gtNM0qXFcyOFX1eqpa8YwSHIPUqrF9j5wWacwfY7fD44mzIvqByeSPLqx4yna1EtPCYTEM/tc8fxqR9JClXdh+/sIgLX9TJWfk0g/PsnYhpD9YDJHdLLbceCBCBCso8gaRYxB7x6hUE1oZ6yJ4WCetYR1a10AjbXLcEqcdR9JDQxlSCl5qFkM1IkP5QM27kv50CAxJ1PracfZN4Wiu9cJj8ltaEC3XGd7gC0aJhrh9LH9g3Su7Jrw27PGEHCyyjkvZxbV9TjjYdBPEFUQBRzhR5uqdaMuwtawTH+Uqun49IJESCk7akBfvILX0e9OMVf79cg7pWB+zjwlPR0ViKwOBiqlfjN0ElibuowJLVVcpBFUb96CV4BB34z52tFsqZzb8rHguEy6KH1HVSZ6FAPz0Gy8RSmeJnwZZEk2v6hKimVgM0U8ctvhjC9hcnumn37lEa9myCHRbfX6YwEHJSx/K6OQs2lR6325FOgI8R/b7MIcl2pWYRJCx89pdFfH3+MlsVsH2S9n3zCYnTF14EhgFsIM03oulE9jGKwFQaEEXNUvwWBlz23TMO54eEej679Fkl+OSFVG/Q0xcx3W4ibX2rEl7D9T9g9FxrwE7YpvWLtIW2GS6JXo7EsPl4e2GYg0LZEplW24lB/0b
 ae1kjZn4
 XtpMtM36n85AwY1+gFEQZYlk2Dr9FE40QjXwZu1VrIwUf8DSHjA0QLvdOfwwWfmIeQLXyi1YnE+BhK9kpsyrg2lvAicL7btZPQ0G3ZTILDOtEuJGfvujupOYocyEz4cOP8ZU5dSwVDF0ZG6Ay6mFY8k3STFapXIcVZ2ZRY0wfr0oPYDfHkz/2oq+hjHqg/ajAPPHEBSEAkpwQ/Ehya47ayuOOqWR0zEg0heQW63WTD9BLRxEX11PdaSIJS0yd54UQqgN4rui/lTArcyo1napeNnDyL/CN8+xLy3RHNK0Lxb06ctSbCpfIlauzFrDSmtA+1GupyREElDDepIfBlGUqy6yXJaFSGLBQ9dbuR5U0DYpRC6A3UDA7uTC7bDsjiAlAbco5jDs7Nrf4m+pxzJ3VF9V5lyipTadqzEgfDw50ALe/b+6IVu5EFTxEqp8K3BrOuOUyZUwWG+rBcVuanZ7O1Bk7INgtUhJ49kde1/52cPB+pM8+I9cD128aAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 4:08=E2=80=AFPM Yue Haibing <yuehaibing@huawei.com>=
 wrote:
>
> Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO") removed the implementations but leave this.
>
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  mm/swap.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index d077e5893a42..29060a305443 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -344,7 +344,6 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>                                 struct folio *old, struct folio *new);
>
>  void show_swap_cache_info(void);
> -void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);

Good catch.

Acked-by: Kairui Song <kasong@tencent.com>

