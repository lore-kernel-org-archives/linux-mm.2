Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6205DC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7049C6B0088; Thu, 30 Jul 2026 03:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4D96B008A; Thu, 30 Jul 2026 03:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1D66B008C; Thu, 30 Jul 2026 03:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 351296B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:06:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B95F4A08DB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:12 +0000 (UTC)
X-FDA: 85044558984.06.7CF77BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7E69100012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NmokH/VO";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785395170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmO9W/NuYxTXqSSJF5r6pVdQn7TX5+h0PgTB0ubFdU8=;
	b=gtTtZBmAPS1YhnD2usnkdJCMbt6ynpw9Ey6ZFBA7KQmV3oNcqcIcKS/6eEPPdxsZl3NL1v
	IJ/s1cHFObis27eqjucf7BQL6PFg5aHXhG2YkqYkFp7+prJBPRVwglS2Q7tsb7pnpjPinC
	cnT0Bvg+UPQB6kVXsxh7YzYeID8BXVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785395170;
	b=meQM+Ndy2Vk3neUwUTaF8iTlM/PxDEQdfaOrq6wcIuaVGqtgdjAYxA2aXX9fg++D344eXE
	koc4v4OzIrKda9CUD4xrkq2IVt7VRiJTgQYt6OpNTGeFXnjSFgNtcoU80f+L79ELyflFev
	CChTYcoW6u/TkZBOnLUWIBsi4XvzBEI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NmokH/VO";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3D94600C8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689661F00A3F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395169;
	bh=pmO9W/NuYxTXqSSJF5r6pVdQn7TX5+h0PgTB0ubFdU8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NmokH/VOVLDI4rGuyP+cddem36BNRWgrtuP/kcyaOWUUPy+z/Ck0/b8n/oan2jx6q
	 ZV7sRkpApUJcRiMyUzVMUMohKTYh88rYLzh4+cIAF7DsCrKZexZjjyzqEOJ5zQi9Yv
	 99DCTk6u6LZkXBBjpRnhWPmSlPqtndShF0bBwg2GqBgynjg/WlNzSpaCvFGIs5cHb+
	 ELNtjsRhhTtgqnHbIvjWsXD9xlRoKgpLerJus4k5y/79gQqVGs33VEEU1Cuv3WgCsS
	 oJWtOoRoUUjIWQBfj9tz/YkjCchE/MX3uUoG7mRYYSLUhX5Sb2ok68+vU47dBxJI4c
	 rb28Qf4EN8zpw==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c0c45c580so11975211cf.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:06:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrccXLkYFsGXLkGvXa6p6Qf/lYU1tRlzLh5l59Fh5yDvRAmKDwczKwAJ6W+enNLza/WppkoeBshew==@kvack.org
X-Gm-Message-State: AOJu0YztCya+7f+1BB1bZ26QPzl+jaQ4ajzzqKL07qu76NDBaIqIOveO
	o8eKCRXMfeceKqtlQCOkyA6iwfxFC9D3ruixrNHCYjc/RO6sYEtCL2YMQyhtwbP3trevL9RR5NF
	0He8Ra3+ZzFug7WTjpaLtWl+EcLp7Ga8=
X-Received: by 2002:ac8:5d0e:0:b0:51c:8dd6:c3c1 with SMTP id
 d75a77b69052e-52b387551b1mr15766911cf.82.1785395168620; Thu, 30 Jul 2026
 00:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4w=gpjgwkndm3PAmZXxRm+E8ASG=6XFpprWwr3AxnpvSg@mail.gmail.com>
 <20260730064122.11785-1-lianux.mm@gmail.com>
In-Reply-To: <20260730064122.11785-1-lianux.mm@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 15:05:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x22FfT2HkPPFaaEXck_BNbW-xmJNeyhQvpWYwYVspgVQ@mail.gmail.com>
X-Gm-Features: AUfX_mxIMMSFe0eBmaJc1kgIGZrl-TPZYp-uwTiDVLfOjsnqRyy-m8CYjEZabj0
Message-ID: <CAGsJ_4x22FfT2HkPPFaaEXck_BNbW-xmJNeyhQvpWYwYVspgVQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/5] mm: mglru: avoid scanning empty generations in scan_folios()
To: Lian Wang <lianux.mm@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7E69100012
X-Stat-Signature: pa7e1doyo8fbjfrx8o77djo3my1krwfc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785395170-581773
X-HE-Meta: U2FsdGVkX1/UbnVPNzuCycD+hLbMV+lZ/rSv/OmOsFWxZ1ou65y+5201oXwBvEYcdEpoGBgy61ycqXD73qAhPJTSCzj5EgpyoFyz4hFcVi0etHrJU6wIBiu9WHGgsw3YIN+Sgg+13dpGKWGP1avkg85a44DKTjYYgRlV6MwiyuSygx41xh64pCDMDnaQT+OjAGQw4rZ8Gp6lniPmXBQfXoqMj8Kr76bVBAR/ZUwHToSaHiaYm7YVQPr0mVeB2GwhDe7N2x4CYnlstaugtd1u7TVDAHAC9nX5oK4Q6crXrewe3eaG6Tk1ubFIFBmUhRAJwPnsZSITBlh/A2upGdXaFJ9mUmTXpVrDDhdQYeehp7x4CQlEAkALlY9oWFtlW9VDxR5Ty4HbhZOUSsC1jTWO6W4px26qRbDfIlCmh2RqM0fMc2z4oQx9YO6N1GDyULkeVi4bqNBXg+wtF+vSFJYgoG5tO+JJHmOv6qnd4I0nB/kro0E+xnZhqW7x8KvpVpAKhyS/AwHUQpRjU7/hd4EnSeD5ED4REhFMubNQxu5Xr2AHejB6l2r403xzMKqqghULRaj1RJXYlol5oteXQ9/yZTfSwU8qwtR+bJ+aSHoqmT9BufYf+wXY8omPnzmaEklKg/N1qd+GInrizAmIV6NYnJv85g+shbFT1OSWoE3dCZ+Rczao3triLCC9o6g2hOBtv5neYTT/methzrzFNJD6x/vpnvDxhWRvp5uLVs4/GkgdMIoXHTQ+ySRlzQPOjPp67nozG0Lz6r8IfcU03hu4ELaKWPukDcq8b0c5/4Iq24mlsEPLJb6+zO8h/m7bXGZJvLx2oy89oEDdTQi4HS5T6hgJluZ10fL7/EfTqvlZAKf55mYxhGp8v4BynIQxNIvdOnRzm5s8hkGudjAST2Jf616P8OlyB0jqtFfiK4r0x8rV643j/79R7YUwoUTkHmOZtx4hU4BHzq2CBumRdyE
 baq+HuxG
 QFZKIqD6dwdAlpZYEkvq9aglGimr4wN/71liEsqyvhafZE8sv/vAf+GwJdinzVrkILH2CElKMhIqUdXBZSVEN/iAwOASSoixzaFOuOXrSMyRyV4r++RJfVfEBwthfkf4qBrreGmI9p7eM6TTDai7qu0f+gO7qfp9AS4pBUCiBOVLxf5Xhpx7i3tcWhxe1Wf95SBGzPcJU4J0oKWrDK/qtGm+V+WPNH5Q3aaLyTPse4sMfX5izZrbSuxfqMAgjSa5NQ/bY/FonmlkxwaoRXIqeLWpQM/n9UCIaWCipcEPwjhD1VQVmsqECIxxSwWYm8PfSSiN+TSq/OCUO7N9WSzq93Ar2dt9VrSXyQsahIyPEllA+rycNzEk4j2TipBpT5l/u2L3hjPy7zBe3NbV2pvhClWu454zdDLycXmz5uvZe7FEqBPqITQUeQWpQkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 2:41=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Hi Barry,
>
> I tested a list-based exhaustion check on top of the v2 series.
>
> Using remaining > 0 still misses the case where remaining reaches zero
> exactly when the last folio leaves the oldest generation. Since
> scan_folios() still holds the lruvec lock, checking the generation's zone
> lists directly avoids both this boundary and the scanned/nr_to_scan
> page-versus-folio mismatch.
>
> The change below only replaces the exhaustion check. It keeps the
> priority-gated fallback unchanged, and reports the MIN_NR_GENS early
> return as exhausted to preserve the current v2 behavior.
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a73be7590cd..59b8725a0650 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4635,7 +4635,8 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list, int *isolatedp)
> +                      struct list_head *list, int *isolatedp,
> +                      bool *scan_exhausted)
>  {
>         int i;
>         int gen;
> @@ -4650,8 +4651,10 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
> -       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> +       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS) {
> +               *scan_exhausted =3D true;
>                 return 0;
> +       }
>
>         gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
>
> @@ -4704,6 +4707,14 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>
> +       *scan_exhausted =3D true;
> +       for (i =3D 0; i < MAX_NR_ZONES; i++) {
> +               if (!list_empty(&lrugen->folios[gen][type][i])) {
> +                       *scan_exhausted =3D false;
> +                       break;
> +               }
> +       }

Thanks very much. Your understanding is correct. We do have the
case where the last folio leaves the list while all the other
scan targets have already been satisfied. My understanding is
that this should be a very low-probability case, so it may not
be worth the added code complexity?

> +
>         *isolatedp =3D isolated;
>         return scanned;
>  }
> @@ -4757,11 +4768,13 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
>         int type =3D get_type_to_scan(lruvec, swappiness);
>
>         for_each_evictable_type(i, swappiness) {
> +               bool scan_exhausted;
>                 int scanned;
>                 int tier =3D get_tier_idx(lruvec, type);
>
>                 scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                                     type, tier, list, isolated);
> +                                     type, tier, list, isolated,
> +                                     &scan_exhausted);
>
>                 total_scanned +=3D scanned;
>                 if (*isolated) {
> @@ -4770,15 +4783,12 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
>                         break;
>                 }
>                 /*
> -                * If scanned >=3D nr_to_scan or isolated >=3D MIN_LRU_BA=
TCH,
> -                * avoid falling back to the other type. The preferred
> -                * type is still reclaimable; otherwise, it would have
> -                * already run out of reclaimable generations. Falling
> -                * back too readily can disrupt the positive_ctrl_err()
> -                * bias. Also, only fall back when reclaim is running at
> -                * a high priority.
> +                * The preferred type is still reclaimable unless this sc=
an
> +                * target is exhausted. Preserve the existing priority-ga=
ted
> +                * fallback without inferring exhaustion from scanned, wh=
ich
> +                * counts base pages rather than iterations.
>                  */
> -               if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
> +               if (scan_exhausted) {
>                         if (sc->priority > 2)
>                                 break;
>                         type =3D !type;
>
> I built and booted this on an arm64 VM with MGLRU enabled. A fresh
> swappiness=3D200 pressure smoke with a 2 GiB file-cache setup and about
> 7 GiB of touched anonymous memory completed without a
> WARN/Oops/BUG/panic.

Thanks! I'm going to send out RFC v3. I'd really appreciate any
further testing you can do.

>
> Would this be worth considering for the next revision? If I misunderstood
> the intended semantics, please ignore this.

Thanks! Your understanding of the corner case is 100% correct.
It's just that, given how unlikely it is to occur, I don't
think it would have any noticeable impact, so it may not be
worth the added complexity.

Best Regards
Barry

