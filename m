Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDF3606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TPKBzKlv
Received: by kanga.kvack.org (Postfix)
	id 0EF696B05B2; Fri,  6 Nov 2026 08:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A8B6B05B3; Fri,  6 Nov 2026 08:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB436B05B4; Fri,  6 Nov 2026 08:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C76D76B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:35:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BA6A140D36
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:35:48 +0000 (UTC)
X-FDA: 85404791976.24.C7388E9
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5876C1C0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:35:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TPKBzKlv;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793972146;
	b=EnuZD+8wkWUiR7pzSIMOPD4UJz1P9K5jpnYFDqdGeW83XMfvl+T10NWZ29ZSUL+9sOugmG
	ptyl8fRqw+hNTRZv/xIAyThmJIJ04ipt4UCXlXC/BE6t/M86+JriPuv4MA/0i0Z7mCDrkY
	RLEkIm6O8CXzKKIb4hf6bnVmPtm3kHs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TPKBzKlv;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793972146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqiBZf8MCJNi5yln1icHnq1nqZ0cACTANM4u61mdQZk=;
	b=A9J1y+4MFdXEIFERSnGN6EPvqRoRm0sDsJjM/X4iyqKa0vE2mJyquPVllxbRiceZ+W4BzZ
	nAOnRp00qy9Nr/Z3kDTa9QIy/2hPZegFDr3Uc79VnXXcm0Nb5tkQcrpDyv7vRLBmHrGL+q
	82LiwJOVTk9u+tPLp1eBBpgg0CFT3GI=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-492690dd5daso474043f8f.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 05:35:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793972145; cv=none;
        d=google.com; s=arc-20260327;
        b=lCRbFdr3QeVioNdE8q7YwtciKKLrjyFwdpjasyS+pgkrpgVENS+zKM16LUTkU1A+Mn
         ln9q0bOkk2NT3KyRZ+xagD78WDILdnAdApq6aizwJqpDD+rcLET+oQv9aW0NdS0jCBRI
         2io2ts8nLgyvxPHYpvpswnC2vb8uUJlF7WUA3CYIf1j1MP99pd/nvMPaIjGz7s3HmjOj
         HyoYeqFI7pKIYVJT0W4rSGGBzLrihwCBXiUJogS770126dXhXl2xhD5Oqy0wuZjkOpF1
         smGMI+bDv8P7zdkKucw2mjsnlOOXxTPg1cLSxv8ygANVFsCRigBjEdQKfMz8o9kw92sJ
         GiMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vqiBZf8MCJNi5yln1icHnq1nqZ0cACTANM4u61mdQZk=;
        fh=fmx1dxtpctjShnlRbNZE22Rl+dYjO38Ooqzqjsookcg=;
        b=EN+iZhbO5Q0DVafcQJLN/Gf2X8rjlQlSphda5kqUO38mV2RvgBz1vsLbo30PTXqVhu
         xTWXPuzqyXy6/p5AHYbAOlVQ1KqpekYQsJjgR9g6vRvzfdi0zLwW9yLTa5UGU40Ivn6K
         O/ecvlYyxPgIyKpYdqn3RJ3UmOhcUGruUrBfY5Qb3htJu2/fBIXvkaxfCEA1/gcTEA0O
         KSZk817Va5ezi9bChi53xb4iB1muEfFQW9Wx5hudxZ8Sk9AE+zfkeEPeSBf0ErkMDZYr
         JVot7BBN1d7iaX1VvFPTJh6V5zVxS7ciPtJ2FzIiwRmC1PNDl/UOgtwi7CTnZR5s9/EW
         ipGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793972145; x=1794576945; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vqiBZf8MCJNi5yln1icHnq1nqZ0cACTANM4u61mdQZk=;
        b=TPKBzKlvzCab3kJvBPPVExE19UC01H70ZiNb4DpwistvYWECmdoN3zAXO3Ldsi1F4H
         Lvq4+1Jm9TEJxQGet7Mu8lRO5Ct8j9uYV+r3YPW575fEJnFeztkqJ8F41s9ey1oV03Xw
         omi4HzdeTdcIm9P20HZynSHU40KgYiEEPM8q5AAAvaZMLzRVk4VKNxYVbRIVrz1iqbMo
         dBJWU2q8CWBMSR8o9DgR5c1RRfUGUr8F3vIYcyt7Ss5nT4H/ZUGp9SOEZBQ/+pKcsSEJ
         cOFaPDjyoqo/Gzi4y1ViXHp0nvWXilQw42sW18xljCXEcij9r9xbcHtwtNxGU7lbsN+x
         OfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972145; x=1794576945;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vqiBZf8MCJNi5yln1icHnq1nqZ0cACTANM4u61mdQZk=;
        b=COZSntemrVrEVk3pIdzyt35TPFo6/grj0Dfl/naT6VEeMm49ZDSQwFFU26ezvWANfC
         mVW8Z6WX4+1FxBQ9cwtI+Ya6IPFe1JOuS7vf8gZYHVyyNBcNpMGHvGW/4VouKSTAfcXY
         PMS0tsEtWzQjDGsNRv+2Yj8VxsHnsQ6pIP095oD8ORAuKOwFrQZs67OfvQAnfU1cugLr
         gK3hi1m2oMN5La1/D9EKK6AznXYQ6SSRUsfXd/mp+52QS4z/dA49QGMtEwa6IIT8SLdI
         1Rr21HHWvXfCCYzMrZMc5nypeBF/0LogV+XyLsHXjIUUN/nzEt5CfrRO2VXh/Ifc1Ghw
         o9kQ==
X-Forwarded-Encrypted: i=1; AL+hErG0Ok8fkREu6fbQGMqb+6OAA1kA6phni38MlYYqLfwN2k8QQTWwM4ggbEGViI+Se0v6toavia4C/g==@kvack.org
X-Gm-Message-State: APuU4Z/tNZIhwxA6fLSmO8YbY3wKgzlbobgi0XAEodX0KLTxwC8z2V0T
	GnYzIU9vCFifE6anLULWEE5JyLxrC+RJwTlpmKXcH2X6UWrxTPDxZbZWZ22R0nNOw77Uoi+ueaq
	a7edbJgp6KjdcqdcUE7cfehUE7bLq5Ow=
X-Gm-Gg: AYBFou0SvD5jaL+wQ8GUh1aKrTbZVtYrUOfMGo0zOjov5NolMnuZr7VnFaUg3khl1c0
	1MCmOAuOcA8E4f+MkmT9kuoscfJIsZX2LtXUbesoal1WFhxrpEvRaHf+5hvGCecPlqD7vdoFaMB
	bGfVFMpORpTdFuFE5jj3vgnst/E8Mqlf25LiI88b4LeW8gLqFrO6ZldQuSLBbOSlSVr7eV7NEa7
	daSkV1CRW0ptsBZm03anZP7P9ifnfJUmQv7xKPh2vMrpEbOC2szc3tk6JGROTFxOO56CTLr1EXI
	StlYsBIh0pGa66c/+6l8HZoFWI0nBv2717mth7r5HjuCAwlEYhd0EymK/YT2wBMPKaccxCJmJwx
	sMB97WGkgiF8X7kO+pFldPvA+EBTEmOemVqX4+y1Q+tg//OzaNIhrfAWHFE2rBOAvVjZ6lXv12i
	qCqXcnRi3fDsk/YsaDijalJAnLoYkWRtqudJeHcS13yzMWExc/zCdp
X-Received: by 2002:a05:6000:4282:b0:48b:9ed:b81f with SMTP id
 ffacd0b85a97d-492760da82cmr5408804f8f.10.1793972144669; Fri, 06 Nov 2026
 05:35:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <CAMgjq7AEg6XEUJPaM3mMBQAeS_KiDv8_za4w-R2WaZ=ZGenvuw@mail.gmail.com>
 <CAKEwX=O=PL3DEaEDe=F-=zhQ=VW3_UtcqesdX9fH_cr6orb2wQ@mail.gmail.com> <CAMgjq7BSzYTbrzbA4vGqMbvegoHnDtJ0vA9PcwCet-m6Ow3ouA@mail.gmail.com>
In-Reply-To: <CAMgjq7BSzYTbrzbA4vGqMbvegoHnDtJ0vA9PcwCet-m6Ow3ouA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Nov 2026 06:35:33 -0700
X-Gm-Features: AclHuK_c4e-RdWwmOq4OypJaP6HdPutPsMXoulXmVlinw_aIwzodsE6iH8OD2N4
Message-ID: <CAKEwX=O0s9n2x5p-BL1Hru3e-9z88Eg+JVM6OM02QTeY9a=xdQ@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5876C1C0008
X-Stat-Signature: mtpwhd7c1gxg715d31tgdrwb4x3konsa
X-Rspam-User: 
X-HE-Tag: 1793972146-645090
X-HE-Meta: U2FsdGVkX1+3ARHSuroQEiIGQpTJGfPZU79aRQ/yTkDRhn5Op52L0ATHxhAm58dYfKOaqjrg+kJBSz6xnxKmUYOEg5NWBuU2fN5i2ezIJ7zXD2MBNpV4KMU8UOwHwXshwNmFY05sbkd2VfrWUygQw1qsEHDbOrWz/yyTvUMyjzcrTFXnaCD9I2Fd1oNpWaWYg4z/NJUZDjdX5mT5mmLCI09+L+vBnMGjUCBYWj4GnpUcDXGoaaI94CvEfAh/6F1b+N1BwLkzxVTdcAYy7cW61f/d88f6uuC4zEL7aaJVxAH12oxcRzCFwt5pBT+7Ydym9btBhXSsuRGrxc6lj7lKsXU/ahRJxQyCcWSqbbAujr+Dt6T0NXXecQt82HVdLf+vY+UzULoIlvzsZVCaKU/RBv71H+v72f4HHmokYP/4Ub0EzadwWNZXChTtdQzxAYw2tKSiMYL87EIUPRJnwboKIBqJy2oF5ftLodKon1tDp5/4AZr+j2Xjkgbc8g6VOkcgLIYURDxti+z1UjcfJsaoirU3C+LRma+7zoK44Kp4eqUlG72cF/Szobsvy/1AS4jkgiTcNBpwgQ4JpYOTSANOD1AR31Y2Aq9SIyjWDWmk3/UCH7GmtCQgkg/7aK4nvbyAmws3/jyqCFrj1JLQAz6pTWaD0CdSng1xtQCUSZvtBdlYD4C7S0WwQpeWSu6ZxtZ7SbrWgVSFUF8PfQ3SINAzj10iNonbR1X8h/c7yjFhVTMzmARQuo02A7dpGk0VLTpmz6NWOwEdfVMWGU2lfELcniV8xYZVtiuF6sicWurYAPKpFhfVtHqrf5HIBot9oo/FMOqaiPMPw6U8CyYEZ6eJmWBjuobRLlyhN38FdRmDS4EA5ooHHdMMYGZ6uXo3rKGrIiMtJP70uW4zf7NrUbj1w7SBzQPzhNiiTF24oamGFG0DoBU6PQJP1n1ERd54XXj6Ac0bDG1k6joOSS2kBb8
 Usm6lFw5
 hROTATQ9pDPwMP3O2tQV9XEE/iyYRaW3bUZGeL9bFGnYOoaoUo4zoHGGHr+q+KRUa2f0q8UBwu3OmZMyXFMeTzYN7zoOf8tip5lyKLngFLpkAu3cPT8L6E/rZKy98jVI0PMFcUkEmM/DbXUGFRNGDu+tZQL8ct2vAc3Qvci020CDyiKPMw1OxDpl2FMjHjIqJpDnR31NaNIl0KHvKxpB5O2xwkjEH11p+HVqk5axjPHm8XOaQ3KSYLLDbSSRGean0BZyDGBGDK7wNXz5yL5Mnp1PKKD5e5RxrCobsY1WD+uCoBuS43n5RLkzmdS+8Mdr7vsDqRsgXeFLH9DNlcoOU6dugJidYZzU/QC4+ZUPlNQCiyXLyk2MPt/yo0UECg4ODzrpdRoyebbNd5jrE5VZqiXsrS+6mRE+efZ7m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:53=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
>
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -449,9 +449,13 @@ static void swap_cluster_free_table(struct
> swap_cluster_info *ci)
>         swap_cluster_free_count_table(table);
>  }
>
> -static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t =
gfp)
> +static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t =
gfp,
> +               bool locked)
>  {
>         struct swap_table *table =3D NULL;
> +       struct swap_memcg_table *memcg_table =3D NULL;
> +       unsigned long *zeromap =3D NULL;
> +
>         struct folio *folio;
>
>         /* The cluster must be empty and not on any list during allocatio=
n. */
> @@ -472,8 +476,8 @@ static int swap_cluster_alloc_table(struct
> swap_cluster_info *ci, gfp_t gfp)
>  #ifdef CONFIG_MEMCG
>         if (!mem_cgroup_disabled()) {
>                 VM_WARN_ON_ONCE(ci->memcg_table);
> -               ci->memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> -               if (!ci->memcg_table) {
> +               memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> +               if (!memcg_table) {
>                         swap_cluster_free_count_table(table);
>                         return -ENOMEM;
>                 }
> @@ -484,8 +488,8 @@ static int swap_cluster_alloc_table(struct
> swap_cluster_info *ci, gfp_t gfp)
>         VM_WARN_ON_ONCE(ci->zero_bitmap);
>         ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
>         if (!ci->zero_bitmap) {
> -               swap_cluster_free_table(ci);
>                 swap_cluster_free_count_table(table);
> +               kfree(memcg_table);
>                 return -ENOMEM;
>         }
>  #endif
> @@ -494,6 +498,20 @@ static int swap_cluster_alloc_table(struct
> swap_cluster_info *ci, gfp_t gfp)
>          * Make tables visible to cluster_is_usable() after everything is
>          * ready.
>          */
> +       if (!locked) {
> +               / * Lock it here before assign, not after the asssign
> and return */
> ...
>
> This should fix all potential issues I think?

Lol this shows up twice under vswap's sashiko reports:

https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org
https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org

Now it's personal :P

Anyway, I'm sending a patch soon based on your idea (will keep your
attribution around, if you don't mind - but we'd need more eyes to
review it to ironclad it). I also have a couple more fixes along the
way. Nice thing about sashiko is that it's digging out existing issues
while reviewing new code, for free!

