Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59ADB606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PybyqUG9
Received: by kanga.kvack.org (Postfix)
	id 707FD6B05B7; Sat, 21 Nov 2026 14:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B99D6B05B8; Sat, 21 Nov 2026 14:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A79B6B05B9; Sat, 21 Nov 2026 14:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E37B6B05B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:59:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 765CF1A058C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:59:11 +0000 (UTC)
X-FDA: 85460190102.18.27DC06A
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 78A7E40005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:59:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PybyqUG9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795291149;
	b=KKDsgOlf43i4u7OrSfhUPGtC1YDLkDNzGB1IKY9n/yQfxumQ70ghQs9mWMqtAboiBeKa4I
	T24rPOzRYvY2bzc5+qzbgXQLzFRmSRLGcBk+YD+MpG0h/0KZ5nNlSHBM6h0NhUlbEk7yEL
	+QMhHCktgUoZpccxsSBtL5/I3ovceRM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795291149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIhHcMOq1lxgCSbMijVJWW/hO8lntUHqWYQIN2hdors=;
	b=zGXq/8CsPRivu4MkcwXqj1CVuVxkEP4qRYmeHXK/HgpH5ys0Q22mNaUfBBsSw0gptVRCN/
	LfMZrGFCirInie7+mssoIjLb1M7ILkGeC8XmMpmbE+t5uaz8IcW+o+Zlu2AX3UXWpfuPK5
	Y9mWA5/84cm5L1EwQqOrp+9FLNH4OPU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PybyqUG9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-533202fe429so185961cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:59:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795291148; cv=none;
        d=google.com; s=arc-20260327;
        b=TisxHa7LzmeJF0Rh/4N42Sgely/HYfs0EvzbZiTH5DlMtsVLv0IqD3iPnc0V+ioxEf
         +2Fhps2g/TmIOX2BfGDanmJVVFXfPDgtpK/uoAA/hnxfoJ0GGI2H/zCVVTuWTRJDeopR
         TamTGiixeUyutXgSK9pWI/lpr/OW6SdnxaoIX1+UMh6WZKd4TK8zlJAmrwbEcEiM6LxB
         PmUyOu+YwBgRjnoNbWLziw5VQ0WiwkkXOJCl4Cm71J3h12PJ50Vn9uL0p8rcmM6Nsim2
         4RJ0nZCuBCCEWE2D2Wg72Fe60PpCh21eGazokc/PVWxGilCg1QG/ZU1P0xd7b+XuueRM
         v0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XIhHcMOq1lxgCSbMijVJWW/hO8lntUHqWYQIN2hdors=;
        fh=S6hFQX82l13sBZQdvHSn3YKeHzZre/H0giDycYgD/1E=;
        b=KtU0lxO3q3frJTE2H92BnievTN1Ofg70uJOKStkNR5gBT7GbHHe/dMCy52OggD/wtg
         K+tpUjawW5mYIxdj/rvca+Net1RtSCObnbAdPz3/bOdkigXs1JLPvWO5PNstki2j4vgW
         wcI7O7TOj1nbsmNcFoT9BMphX9+8lKEnt9ldSlgbOa+w1nfZh9G1JSadDH4SZfSq9MKx
         IBTtTrfEHNvkg6C2YiSLku9YOdQ3JdzaC7COU/G6pJmDkEjGu2Mzr+UzYVqkn7SL9c2h
         a9fr3WRUfCbSyqzEzpG4DE5w3vdKTgpOoAoh8qsvEzEdFCq12LKn5WDkw+Ck03dgcWXj
         7mNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795291148; x=1795895948; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XIhHcMOq1lxgCSbMijVJWW/hO8lntUHqWYQIN2hdors=;
        b=PybyqUG9FkhFCHKGS6I4+S+XL3oG1GjPQm7md6CSr750sdK4Km8A6tEGaGvvlAUqnL
         OGiD3C6OMRLQ08RykTwVUm8vCXt1TsR2h3g1PZ8ls0MFpH/D874kyRBieClWPtwZZ0LQ
         CnVU/y1IAB/fSvLq1Zc4tKL3wVAAnvumb4v8t8M/ePFhR58TRq0WLjyB2OwqeiInUHPt
         u2fJe738cKeDLFjhasBeTWHTaYmAj4jRoOnOTEm2uK+OnBjA241IlUvsjdesZRkESb9g
         DKd1+0EprDBxbVyR3SPUemZMWYl6rJbsL6/vfd7UXi7TRJ8x4jBSaQZvyqmgwNTeMv0p
         3d4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795291148; x=1795895948;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XIhHcMOq1lxgCSbMijVJWW/hO8lntUHqWYQIN2hdors=;
        b=ia2uVazsMdac+ZFiBLgokqaz+VvLpWO6ZBn5R89Z6cmNfyMYKjQZSJ5BSgglcj6e94
         wlk+ee9qp5NfNScBet9ZcnMQy+nN8NHEvWB3uXf/BTZi+V+j3r2x8WkQ9p+1y0xmbwWc
         nozBCagZ5V5fMF4Hf7+OS4vrILEpPyFcar6bU1SGwRsF4dZd9g+YBvg20iJqKNjq1tEM
         A9sLXGOsVgh2wweAmIx4LcrOC8SYIbBmSspla1T3+HCsUnf5nDi/bH+edjpi95JV98Ic
         mcrf51gOMpL75CXJe2cVRNuC7h0vTlZd8+YJmN+3ethWhZ5HUAnSA9Qh8GWmwezoF6/e
         5EOA==
X-Forwarded-Encrypted: i=1; AL+hErH3v+x2WX6Edm8faGTSgsWPzRScnOQwRltjxVZ+YQEID9F1oydHTdaxEFAQJdEmr4UyBLfBmdzJ9g==@kvack.org
X-Gm-Message-State: APuU4Z/dayXZqJe2F+XOhMiXkzeM94IxGkydJADaZkd1T22URbbb70BQ
	W1gEMriH8lkyQkEnaNqY0TTQVrtZxWGeV2SrQX+F0IOhOsw7/anQJqfY3vNHOO1PaNc1LIVwQuy
	crKqX9H4lDoMiISf/qw0+RxTVmPUdEqZ42Bg0d4Qp
X-Gm-Gg: AZFdTZdmVMhFyBNcDYnkoLaz8uyADNBWNuXjlQt5eV8AiuO2GFc2LXEHtncabSVJT1p
	36/W9wGkNKHTmBy3jUbg71Rhv2XGq3RdnBGZfUzGR8egHuCINww3dpG2zEOYeDQoYNLVKyZM+eM
	p1IDBCeYhPpfmds+n2xbg3p9eFwCbafqGpgaFlNBy88PnWjfuw2p3Va6g/Mvxf2ROxqCyhHH+sx
	sDDC0NRHDBb9vXLTrHarZh8fBFKutMZwHI9qhZer+Ru9Q0Dn09gomWuwbtUFmo4wR+bQ7SL6+Wu
	4pn18Xo9NU9taUOAd7tAHnGfa29rkHN5xX8TcLKAbz2Bu2kYosiCaWYzfgbjHnAosHf0uSdXyTF
	MZX4cYcIFiLrTzAXeNHxC0zByJV2cRPB0IDOrIThiQlsdBA0kf6SMbofrOErbmWhUEchM0F0=
X-Received: by 2002:a05:622a:5793:b0:546:92f2:7830 with SMTP id
 d75a77b69052e-55d881afcdamr15534531cf.6.1795291147800; Sat, 21 Nov 2026
 11:59:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-fix-rmap-lock-ordering-vma-locks-v1-1-952c0dd5bc3a@kernel.org>
In-Reply-To: <20261121-fix-rmap-lock-ordering-vma-locks-v1-1-952c0dd5bc3a@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 11:58:56 -0800
X-Gm-Features: Aa3M54r0lX1sZPDgZjkYlK-B98Xmj36YAOPoonN_ucpiXTdrt3h2CDHnz7kueAM
Message-ID: <CAJuCfpGk8xA6F=uBCMf4Adc-whPbSM=JdqtRTiRkeMB-ZyZRsw@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: correct VMA write lock position in lock ordering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eexqdwnbmme4dp68thr4xjf3gsgfmddf
X-Rspamd-Queue-Id: 78A7E40005
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795291149-614200
X-HE-Meta: U2FsdGVkX1+FAjeiux2j68djz5HLy3bqfFoohR8P8eljHH0xefsa4USfnt0XN3Za49MzZ6gHsn1dZVZlvoFUvHwI3hWKs61IqEsNb7Ssny6BJLeagQAPoXg3Ro/Ww4hSudDg77GY/NEaF4Jebemo/yhc3x3aYrrofa8p1VOJYDhZZZGSQO/bxlhoOUHonsIZfPxqqEyA2J3+QK/eZkv2lOuHe6KMt1v1T56L8il6YJnfBWKJYWTI7VNJR0wpBb9drLaFJF1d0py9A1pfVSAyBYnj3AMFAcTPbPj09GeS30rOgk6A954yveg1eV2lrjRYCxt1ioefQuBPQf3k0F4FGPXZuW9i73NlUk/jn1MJPNrJ1iJE7giHHkxLH3WpsJds16KwV6xJOXZXY6jhvaaKYzEJ7JctRMzdQ9xLUqCVH9Tz61ZUfdG7zATu6aqPHWFm5W5KVgFhrw40Ev/bsqldubXhXQHkODXQiWf3d/IFBTNHlojVv0fVJlEZIhhmflJ4fN/LmQUusCDHWBfegFPlPVTeADtMTJbEWR4JzXBA8NmoBicL8Woj/a699DdpJiUsq54UJEt0G/PfQ2qgz4b2sdK4QvFdG4nPNOp4ArF6FRjOGFIFZK244RrVYqJYzWmlCaraxj8dCykIZVdX7y4x2zFpisyPAsEK/03UjRKz271+KiaDMNvEdq4Y4zq+fz6IOAemF3ktv//KJMoiY3Em/lQ/xvg3p6Q++aHBZEeHAJWjd71P+MFPtZZ8aho6pnqxh7CFg0qILXeLTAvsYh/pKm5bGjtncJ2K4CxKFPJfcz/Oip1u2WTWcS6QKjnWB2EWzhgrmwmSQMdeesJIPIfgEKQdUNhLvAphqHqzb973RXT5N+g4oS5hQCcnxfq06MQpYY5knmg9SkxtEPHuhtvXg4GLm4UK4MbR7nSYT/FRzcoRavx8KCQh2PGoq+Z/GEi+Av2y7+mvJkFbqd2QCq3
 Kgky24G7
 HWAZlHSDWMHTbXiVJ8VEOj5g/ZudbhNBTP+SKUcKm9tYfUlUuyyVxhRHl1/zfbsiAnYUvHqaMGMqg7eYMukNmaY31hps6Rp6f6IE/lDWrkSzX5jfOt5kU+1LKqN/9YmTlZFthG+L/ezuqGfqiErPkZa6wdwXsJ4jfTXb5Xi9KM1gAuS7niWY683nDxUtta1kFx1/iaDJJ5WH6KfoDv+US7Dec3KV4cvSa+KhteEKJOh/9osSxWboTOno2YxBymReWRa2jV8FdbNJuBKHKyVXFK9Q4BnpNaP0RMOiizsgkN8LcLQPpRo8TFqQCJhSgOdVps8CCdLpLCJooFQBA9sPaw9dG9e11A+fyzNfaTcaV3ZN7Mk/qSPs2HJa5VD632FNoh1wrdMN48m9qFIbJ+bv/OKELQ6w77eFU3U9GqthdI/ZZLkcg7uGMU/+ZEa5+k0Pm5qgYSpsRxFodnT+GPa1+9O07x74o5NM9iCTFI3B0R1q9p/4B7i8Tc+vs9tkC5SaAha7Nc2UC6nGuH9rzyXlXfXRZFYqwD2Bnrs1oHIbJg9g4JhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:31=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The list at the top of mm/rmap.c is taken to be the canonical order in
> which locks must be taken in mm to avoid lock inversion.
>
> However, VMA write locks appear to be misplaced. These were added there b=
y
> commit 55fd6fccad31 ("mm/khugepaged: write-lock VMA while collapsing a hu=
ge
> page"), which was focused on expressing the dependency of locks after VMA
> locks in the ordering on them, disregarding those prior to it.
>
> Of course, a VMA write lock requires an mmap write lock to be held, so th=
is
> leaves three locks to consider:
>
> mapping->invalidate_lock (in filemap_fault)
> folio_lock
> hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
>
> Each of these locks is either downstream of a VMA, or is not able to
> acquire a VMA lock at all (e.g. in an rmap operation).
>
> This is because accessing a VMA's file (thus mapping), traversing page
> tables to a folio, or interacting with hugetlbfs requires the VMA to be
> stabilised in the first instance.
>
> Nothing in the kernel takes any of these 3 locks before a VMA lock, and
> indeed in each case that a VMA lock is taken it is taken before - so the
> kernel is already violating the ordering as-written.
>
> So fix it. Also add [_killable] to reflect the existence of
> vma_start_write_killable().

Thanks! Could you please fix the documentation here as well:

https://elixir.bootlin.com/linux/v7.4-rc1/source/Documentation/mm/process_a=
ddrs.rst#L424

>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/rmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 65646ed6fc45..55367e7d3eec 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -22,10 +22,10 @@
>   *
>   * inode->i_rwsem      (while writing or truncating, not reading or faul=
ting)
>   *   mm->mmap_lock
> - *     mapping->invalidate_lock (in filemap_fault)
> - *       folio_lock
> - *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs =
below)
> - *           vma_start_write
> + *     vma_start_write[_killable]
> + *       mapping->invalidate_lock (in filemap_fault)
> + *         folio_lock
> + *           hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbf=
s below)
>   *             mapping->i_mmap_rwsem
>   *               anon_vma->rwsem
>   *                 mm->page_table_lock or pte_lock
>
> ---
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> change-id: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

