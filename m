Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70FF1094461
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 08:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2EE6B0089; Sat, 21 Mar 2026 04:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53D86B008A; Sat, 21 Mar 2026 04:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69D16B008C; Sat, 21 Mar 2026 04:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A188E6B0089
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:08:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 479121404D8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:08:53 +0000 (UTC)
X-FDA: 84569344146.10.2028A53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 72BA9120004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:08:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sjm3zqKZ;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774080531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoFAn7UbZciL7kg8onf98qtXoqQnJOW/hKz3YHLFT0Q=;
	b=744tIy1AfESQk6cYCTOxuiIqBVJ84x3xxuUVeX7Rl6zP2ue36E+5oUt/l/rwwL7su/m8/K
	c6+8S4lwUFiSZLV3RS7U8FmdUvDy0FVb3DsVbvmwXpG/1yGc/61glZQBXfjxsMoTLX3F0J
	T1JluPzAS6k7a0o8/yfGhPHJkPRw8pU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sjm3zqKZ;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774080531; a=rsa-sha256;
	cv=none;
	b=GRQFj6tCkilevm19Xhokb27C5YL0OyCnjD2ZQDWyBhv+KOwP32aftg4ZCP5y2SJLaZmexd
	gnSYMEb/ilVVPqmdZVwUGgzh4k6Q7FrNOg0bTFY+94SvBmbEuo6O2ZKYVTwt88A6tER3l1
	hwH+JB1uY4yReKChJOBzuIF6n/ndPk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF4A960054
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AEAC19421
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774080530;
	bh=iAWAw7i+H5iM0LuB+tfDvoWnL6tz4FGANoL67rsstpQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Sjm3zqKZPvUzzxxNdfYb/xamhfOCt+MEmO83/mml2ozsOuePE4wzxa567tgLuhdVP
	 EQhjh1InBGWkGhOJMHiFzv5opJ1BI619SOKe35fdYFrTnW3IQCPhgTX0SICj5BxHBZ
	 MZRFTVrMe1JujejP4zMKjYBauD6IkZ2F30is1D7ROc6/Soqy0w2imZMGnZCefOUqoO
	 Zg1sYJmUvkELbwgbPzldhbahE/yUPbyFgK8l4gIsV83ZW5D0jxyFMRUa4aOwFjIcUS
	 ROsXAvmBjCK4/RLG9c1lfm9jkzPSyT29MDIeXbBtGsvn0Xjmr8Nk7ENuUAFwA7qZjf
	 W3jc5sA7i2Ijg==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64c9a6d6b70so1017154d50.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:08:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXO6IHe5+HZcsLONltqCvsn+3V2QykuGUszVWWZlSxwP7lBDwQDtV2FkjCigOdR4LWAPxwDcKr72Q==@kvack.org
X-Gm-Message-State: AOJu0YylZJaUlVp2e72I1bsSqQT2yyaqSGL8VPeS+OdVxxTFJBno/i9d
	rdg36EEfxrsZg/iMv/5aZFHeh/irFltGCGYTJQB5ra1uc/IYyspPBQylCbQuhsNyg6MJof3L6uV
	Ushjwg8ZH4KhYZ1ENt/9LCIJ259SMCCmDODqtJZla+g==
X-Received: by 2002:a05:690e:44a2:b0:649:c7dd:d2e7 with SMTP id
 956f58d0204a3-64eaa707e01mr4948216d50.33.1774080529698; Sat, 21 Mar 2026
 01:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260320050601.1833108-1-alex@ghiti.fr>
In-Reply-To: <20260320050601.1833108-1-alex@ghiti.fr>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 21 Mar 2026 01:08:38 -0700
X-Gmail-Original-Message-ID: <CACePvbVcDJOGKG_C-_=s5c=hqrVGe1Qq8EuvX-MWfd36nmNizQ@mail.gmail.com>
X-Gm-Features: AaiRm52M3hEIAZbalOdPJMeeqpHJzPlQnlH9CQGbWigMKUSDKeDtDtiOwUI_0rU
Message-ID: <CACePvbVcDJOGKG_C-_=s5c=hqrVGe1Qq8EuvX-MWfd36nmNizQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix swap cache memcg accounting
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, hannes@cmpxchg.org, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72BA9120004
X-Stat-Signature: k9mxbn9efme9d3jujrtfwoq3zeirag8s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774080531-698567
X-HE-Meta: U2FsdGVkX18Dt0SIlQzVVjZe0ObIfIg1DGDJyyj8nQVGIMLWX8sMeBlln571kuHnRMDchGfU2lbo+M8F24Nu2YChaCBs1duE7xQfsBoKaryU8Fm7548MMu2DC7bm4910F47R1jROBNNf+02qXZ1ngvTUzb/NOjOl2kzvhAfIRplz5Vvqc+m+pkL5lQxxDxMPi7HymVuJ/udZB4JMhHpk/swMcKgkZprLg4rks/Blvc8amb1/F1msk0C77+IJgsM1M6DeL0oSiFE+xmG2rOwn+Mfa2uZl7zAzBlvfDGF+DW3VUtnsKxbYnJ5Sz4ewCIuYOThqDg1tKgHdaHWkEnorNOAdh+TFx/FQIgNyqYsmPqqpLC5UiKmVXSi4/DTnQ1MeDjIEBDTkILlzfdFG/U72xnx5rOTTdK92gL+1fJFvdnWVGHw3iv2RnCDpMpBd8MZfchFQdH+iX5rY2mDpO33o1aMoKqVddxuyZsJ/tlp3Y5kZUEhiTP5EdsJ61Gf4IH/18bsPqA4cVdL8+EHQmRl0dveI2ACYZ5RuKVTYIrr+v4EG8CYQmOcNgtP2Wd6bYg1gdRarsebT2FylxFSfDZkPXM/VN+66wcm25za+2FS0kyM30kZbmjbc4jFbiZ9LC+t8DBSxDCU0fUQQw+E6TmqCLf5vKkvBOxryMBK3ipS6NgzdL6CZUGizBmCwKbF7NzhO+o0MinOLF4IcAPXntz8sH+BzIb4M92ZuNLBeMOQjN62lLNitRebeB8n3pCzGYjwMySskjzKU3vPibtembzMKqOcTatrUg+nuhc4V3OmE1oXvhkB9gsDZg3oyMDFpcpizyvJcwatA5XNicj1GNQ8GwVfLYnwE9WdF4KbYEfVx7/dU67zJIwNQ2m9Do9u44pdTlNfvO1GXA3A7ZuwNqC/H2kD544b3mlRv91WSZU65lGPPozZQC6woWjpexzWD/nazGcocR14vry1+zFVrtxg
 Huz2xnJS
 W0G+1U3flHn7m+38kPKFH/ymZXnmrtACrLYc1vNFmhs+oDqaU1W8YymVfV56Ak1sAJh4F2pYbcpUKz8phFDo/Pqtzb/8vFJ8wesCnuJgvuoT6G8te70y0jsbNvHkjS0cfqqFmgRMwA6/eXIdkPwtBQL3OTOB1Jd8eY67SoyhTY6VDy96o0qsQehkEwDCVWLpt7DCt2DmY3TkU2/FNF/jHc2CQUpXlxvyj2z4ycO7uh/eqSL9p1o+a1rwDr/urCQeGmTeOyi5fowzF1ejyZD3DUc48iwa4S9T2RVDZe2H9RPl/GtRXVs+0ZhPPGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:06=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> The swap readahead path was recently refactored and while doing this,
> the order between the charging of the folio in the memcg and the addition
> of the folio in the swap cache was inverted.
>
> Since the accounting of the folio is done while adding the folio to the
> swap cache and the folio is not charged in the memcg yet, the accounting
> is then done at the node level, which is wrong.
>
> Fix this by charging the folio in the memcg before adding it to the swap =
cache.
>
> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize=
 layer")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swap_state.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..48aff2c917c0 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepare_and_add(sw=
p_entry_t entry,
>
>         __folio_set_locked(folio);
>         __folio_set_swapbacked(folio);
> +
> +       if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry))
> +               goto failed;
> +
>         for (;;) {
>                 ret =3D swap_cache_add_folio(folio, entry, &shadow);
>                 if (!ret)
> @@ -514,11 +518,6 @@ static struct folio *__swap_cache_prepare_and_add(sw=
p_entry_t entry,
>                         goto failed;
>         }
>
> -       if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry)) {
> -               swap_cache_del_folio(folio);
> -               goto failed;
> -       }
> -
>         memcg1_swapin(entry, folio_nr_pages(folio));
>         if (shadow)
>                 workingset_refault(folio, shadow);
> --
> 2.53.0
>
>

