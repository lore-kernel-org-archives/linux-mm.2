Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE74C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4226B00BE; Mon, 13 Jul 2026 12:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84E76B00BF; Mon, 13 Jul 2026 12:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99F86B0154; Mon, 13 Jul 2026 12:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8298F6B00BE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:56:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 225228C60E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:06 +0000 (UTC)
X-FDA: 84984355932.02.7C5EB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 263EF80004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CdNGRZw9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha1xvGqm0LoQeRNWsAJydgpJy4DP/Y57liNcmUTObfY=;
	b=yTAXTd1v+BCVJ7uCh6Qg9VNcqwvb52A8tpg4rux/DQdyAwpAt72T5372Vj10ocqd7THHYM
	jdeHEBaN3W8cJI5M+Kjv5izV48K0BYyJN1NiPIBUpCkFDqaSqlAP4XCa1ttyEx2vu/uClV
	5/WN8zHag004OaOoFCueipdFA+osteg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CdNGRZw9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783961764;
	b=kWlj6iaIK+/R+b5N6VtkPvgIotQy+Eh3K8aRhhsd4ljeXBtuD0TNKZyM3SUVgQVV2LF59J
	5kZ4f3ILi7yIRvCY6VSRPoP8BODry6dS1Hq0K83ca49lQ8PFh+h3L2x3Wd3PShBuGZnm47
	QZ6CMwDduB0rKvwYYDJ1lm6xEIVvlvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BB70433AF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD811F00AC4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783961763;
	bh=Ha1xvGqm0LoQeRNWsAJydgpJy4DP/Y57liNcmUTObfY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CdNGRZw931++MGEB/6HnKSow3e+sCJxhFPbuMPvDITJ4LeLTRRwXGlJqAuiaidrRu
	 cj6TRvOJj5YxN20DK+FEj1jNTXQUfaKKown1/q93pQIianU/7sdseU0FZMHZTHrW9T
	 Q7Ak5UKtrAa4nPS1av2EpS23F89ki1momN5vvx2kHXhWFAwmQ14Ke+4nhKbwo51ek7
	 axiFietmi9UNyxLhGO8JoIauwSokLaXFEai4ksFgoG+hJ8oSBLiMWD+yoeGKZDDlfP
	 +299pXslPyybl8Q/DWHN0B6k+OkcqB2p/mpq+5AjpzKySaOU8384wyzLzp1ki2KHUz
	 3IOQpwX54a8cQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15f6d667bcso412171166b.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:56:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roo1jvydqKExAZ/+MGc8nS3O8NzpbrDCP+BMt+DNC/NrP7QGgBbGLUy5a2sQem4Nzz4fZe2/4Bm0A==@kvack.org
X-Gm-Message-State: AOJu0YxO8be2WwP6EPzPxd+9/B3YdWa/oFXJIh6UzkxgaxA38t9WGWMR
	AIUEWZ4/qQhoXFdUceVK2fahKUdq57lKOCCeuLyWGv5PtdrqlhxuA5zzya18sQ6aLzMH6GJ9NQ2
	nuitE6xET39Dvp5KFIZWhW4cieMm/GzQ=
X-Received: by 2002:a17:907:c084:b0:c15:ce72:934a with SMTP id
 a640c23a62f3a-c161ea93d40mr425514966b.48.1783961761598; Mon, 13 Jul 2026
 09:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260713133613.2707815-1-usama.arif@linux.dev>
 <20260713133613.2707815-5-usama.arif@linux.dev> <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
 <da9458cd-f039-4c7b-9e00-a473b05aa3b2@linux.dev>
In-Reply-To: <da9458cd-f039-4c7b-9e00-a473b05aa3b2@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 09:55:50 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPhwmJA8MyJPiBJponaMETbgMNd=Pz=_bj_PBo1D-Bw0w@mail.gmail.com>
X-Gm-Features: AVVi8CdpNHAx-jlB0382O9N50zYED79cHxjsjhpjUhZw5K3cEsAPo_7wbOw_QKU
Message-ID: <CAO9r8zPhwmJA8MyJPiBJponaMETbgMNd=Pz=_bj_PBo1D-Bw0w@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] mm: zswap: add range lookup for large-folio swapin
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 263EF80004
X-Stat-Signature: nbrj4mhk9rdms37ya6addkuyudkshd7s
X-Rspam-User: 
X-HE-Tag: 1783961763-56881
X-HE-Meta: U2FsdGVkX18Ub569iIT3VkgVhG1NjUY49uBzrye/qBTQXIXOAUgktwutlPkkNks7YkklnlO3e/kOIegc9VwxZ7bDCMBzbOvqt4t3z1eel/xXnrXYvXW0jcbXeXuq+zc90vwUIhwvTN9naLESZL0dUOW09svLOxJq6WTi7FZljr2EjAyF6YLyQvh7fuyUfTWRVuDlyvrfk7ccuc3YkwCQqPIWKNvBG3VkGBJ2VdFye7WRUtCRpuj+r/0RFRUARWjlAm9o8y9Ih/andiw90CGFw0wo9SU873oGe49CtxPvA5Ylup8yVTzGLgmxnZRaECwVUy4GYKVEGj/CE09/eha+vgDM7+nJEg6t9dKLeL4bJ+QCmJQbCzrkeevvblJH1SyBiKwUF4AKVWB/rC6J34LywiKliq8u63mEZt5llGUl5PfzC4ZJNd813/Ee4hHaVOcLXGQWvRcHxpyypHOtvJ2HzQmQgMoo9CI+e+qNpW4vBrfOLYEr2OWNDaAoXvUqyKWO7G+7N32jpFky/QuU+cs1b3356hAXlK6AYotsVQn/JV768qoHorJbcVgcjFix7lsDkBjlgY3DsjCrtm9Em6zCQ6hbmSt9aK1FNHQCUgJYmw2eeDRB2eLtiRWqA7WQq9VBez5Ba/N/RLprb3hQq6Tr2DVzmwPg1IDD72FEeBbOZqT2rfMRrmBEbd2s1EdtBHGOqWohqq3Gd33QlZjdFuAI+/CZlkJvb0MeAzbFDKOk7I34Ggt1w+Ou33MOSG0oDE0+oDZFiLhTAAT06WzL3mqk8N/1SvdFkw3WpTlAHTYtSuqCusxPB19UKbT0hd3/O+54jQqz+dGiw5pRkoZuecLkxhzE6AdxIuZcJB5oFSXMfG7REqbZfzIhi6y1kRVujwC/CkIgONqSJFNayyygu4aVBNTmeysfsn/dPC2i3kHnBW6Z8ryXR2Mh9weZCyhZ+rrg/f1KKFOwq7Jbjriekc3
 1cLnvgJd
 RbZ6ACUuqbSkf7emcE8lBgPGXLVQjRqEmhx/hMCnwLpABUiRraEBcrAblIlvyGl6Nw3kkipmbZyDRxWk4Njw4ZQQ+Wt4MBgqbpnDFhTtwj8mOB9NDTe+e62pIjvDvYI6KMoYBk4q1TudKVI0mXz6wfCWlmM7Z6HuoR9l6ysOPwdXpDoKJ6IsITB2Jxd4PnwEIbpZaN3b2+VUcc21G8VRh1eblO+A98obbU3iEJhViqF6CcHN5vTZbhKdii8Ockw8RafVC3zE577V+N7F9xPR7Qvg4fL6Or4t98lN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 9:29=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 13/07/2026 17:02, Yosry Ahmed wrote:
> >>  /**
> >>   * zswap_load() - load a folio from zswap
> >>   * @folio: folio to load
> >> @@ -1571,10 +1588,9 @@ bool zswap_store(struct folio *folio)
> >>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_sw=
ap_page()
> >>   *  will SIGBUS).
> >>   *
> >> - *  -EINVAL: if the swapped out content was in zswap, but the page be=
longs
> >> - *  to a large folio, which is not supported by zswap. The folio is u=
nlocked,
> >> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> >> - *  do_swap_page() will SIGBUS).
> >> + *  -EIO: if a slot in a large-folio range is unexpectedly still in z=
swap.
> >> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
> >> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
> >
> > Just curious, why the change from -EINVAL to -EIO here? Does it matter
> > in practice or is it just a matter of personal taste? :)
>
> The caller only checks for !=3D -ENOENT so no functional difference here.=
 I viewed
> it as a change in semantic, -EINVAL meant that you passed a large folio, =
which
> wasn't supported to -EIO meaning the request is valid but zswap cannot sa=
fely
> complete a PMD-sized read from per-page compressed state.
>
> I dont want to speak for Alexandre, will let him comment on this properly=
 :)
> But above is what I thought of when I got the patch from Alex.

A mention of the reasoning in the changelog would be nice, even if
it's only semantic.

