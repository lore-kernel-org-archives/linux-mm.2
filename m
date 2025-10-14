Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F975CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAC08E00BF; Tue, 14 Oct 2025 02:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BF88E0005; Tue, 14 Oct 2025 02:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A818C8E00BF; Tue, 14 Oct 2025 02:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99FB78E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:57:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 502B214074E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:57:43 +0000 (UTC)
X-FDA: 83995814406.30.F4479A5
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 623A4180005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:57:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ddi6xAY+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760425061; a=rsa-sha256;
	cv=none;
	b=N1mctnU9cwEemRPs1ZTevErhvOysnJ6F0jOYOSFswkChHZS/5Npi8tf6InL6dk+HcTrm0R
	+p5rIyJli0cKmH5ZAN6o4dUS5JmiCEKvXs8LLq7EFM521qNoH2drgqclp1VGyXnaLusDeT
	/KWp6eVNKaVWvhp9kN9Re35MJi+7ipw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ddi6xAY+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760425061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydO9QE9Pyr/n5ro6pKARsUihNEcUXgq8dHGMv1U89TQ=;
	b=dKU+HTt3/ww1AcKD6dq3fDHjzFnbZf80I5MBJ29AcCgldMwO/8c+RD/Wjq1HDK8fGzOwP/
	J4if/hWg0mo4+BKgRm3tmkC8WDBgTZMHf2dV2SvB3mwhbPhedTO+IRqXBpwaWa0qhVLfzG
	qZTVp/ntOHEPVGC1DTCiFUm+NmmCVH4=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b456d2dc440so815786866b.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760425060; x=1761029860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydO9QE9Pyr/n5ro6pKARsUihNEcUXgq8dHGMv1U89TQ=;
        b=ddi6xAY+XSBINptauJT6CItzxE1aVwrl1+RMRqP9wB3im8ysS3U4r6Q0UGeR2Yral9
         TyS5HGYt6VovYEqjAfcQBY4pmdPZ5sfiw32R/WX0Fq/w3nSiBCQnIsDMRYyAMQdsI0Jn
         62zobVrvAbupJRyWwzmbxc3sA6zsPULxTPkY+JpS91SA42mDfzjd4yMu4A9yvbRlKIXn
         LjRJl9OyKGT1uFEfjmQUgPBIn4WztMcofGgxHMtkaPTeBRIajiSSj1Fie7QblK6dW46L
         5sT9u6FlFcsV/GYCDn2gTJEZew7WA4QbvMjjofrBg4tRrjDXhOPh1Ckq0NbNDya39ZC0
         AYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760425060; x=1761029860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydO9QE9Pyr/n5ro6pKARsUihNEcUXgq8dHGMv1U89TQ=;
        b=q4G8Q8OqbL/VOloO0ntK7umqXG+QVlchO9lYZB/2tmjSUQvYeWIMBZxWYTgpFKyzfQ
         v9f7IkBU1XRTXfwL5y6S7iqW5xu1vZI050K6Tslnx1uDsVVthuM/9VY2gx+7ePEcmAYp
         Y2Qo+9oRw21Y4+NdSAK0SSjYBcJEAx/Uc+m0RSURNgYW9kMfPVgprAYu+NDhLB4U8QbN
         4Rqp6wJmKka99uloK801U8vsKQ2+u+TOoTw66v/wPVvuNQASXD41IG+O1fzP0qzUY8DX
         Tj5ByE21NIVkxIYMaihvfr4wG0bqsMcvepBS2NaXR5pM+CKEuK4Kb0kQOFDa5ojNP6GX
         2qcw==
X-Forwarded-Encrypted: i=1; AJvYcCVfW1VC9MszdzQK6pfZUvbxbp9tRrlF2oop+wJLdfjDaKWu8qjqBkc8rOuY0HtZCrgxucUys5Ukew==@kvack.org
X-Gm-Message-State: AOJu0Yz97Vd94/HSkyQ9z1aLH94y71YAz8g7+0ui1FnvapkQL4JGRfE+
	D0fllJnZNL5eC07FWy8BOXx5fwBH/jSRfw7YctuPNiOxDQOgMrliaxt1345h8OQJJdv1SuyU59T
	Q3LbLjLZBmlaAuvKEBTLJUPIFLiNrzrc=
X-Gm-Gg: ASbGncvCrS7gQxSOzKbwO+wDYY6QqUjETTes0nWvtwAf+1JPsEUty5JWUKY9vyw8Cx/
	ED2blFOA4WK3aSaDEWm2XCFhJCAWCNKBmk8b393hg8OxgI0j4x7eR0hitccPx6LIHXFJLT9gtI4
	SWRHqpoPvIuqlXUfVjuTZBjrgVF8Dy53bJqJ3Hb8qZWebrLV9vK6e1+ypIcQeZQI6DpBblK/Vjm
	W8owUlf+f4tHCGOmn7XiMoaeQ==
X-Google-Smtp-Source: AGHT+IEZmsv+LaZQBpo3Rmh0owXX1J93Gn9uf7s1llsw88Z+kkSSb4fiitV9qcOalkZuBUO5rR3E/mzfblF1lt/7w6o=
X-Received: by 2002:a17:907:3daa:b0:b40:5dac:ed3f with SMTP id
 a640c23a62f3a-b50a9d59a8cmr2483657766b.7.1760425059487; Mon, 13 Oct 2025
 23:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <bug-220605-27@https.bugzilla.kernel.org/> <20250929160727.a0119e93688378c570a3c550@linux-foundation.org>
 <d2729b26-1bde-41aa-8e2e-b6ca861185b3@orange.fr> <CAMgjq7Ce_WXHJeV8tmbRT1wAYY2_2f8G8Z-9tbSjkjOg3077ag@mail.gmail.com>
In-Reply-To: <CAMgjq7Ce_WXHJeV8tmbRT1wAYY2_2f8G8Z-9tbSjkjOg3077ag@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 14 Oct 2025 14:57:03 +0800
X-Gm-Features: AS18NWD_fqRCtmx_ueqWm0Wvs85_BG6cf3qSnxX6h85R_7WpViN7lUi7jxJJMrE
Message-ID: <CAMgjq7AvfqbCwLRHPOwS2hAuFc004rmoZiAD6mGzADEK6zwM0A@mail.gmail.com>
Subject: Re: [Bug 220605] New: Very slow access on HDD when a swap partition
 is used on this HDD on kernel 6.16
To: Pierre Juhen <pierre.juhen@orange.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 623A4180005
X-Stat-Signature: 11ef7agz4r13i7chykemesgemckghr3u
X-HE-Tag: 1760425061-261147
X-HE-Meta: U2FsdGVkX190Yli/3NgJ5v06dWTuGX+zKUVoOXWyChizmBgTgLo8ogSb7cmiPAuWD5181gx3w9U8u6WmCNHaflyPncFBPWmi6rKEkKo5bwNTuuuCBm7dPnnhVGtn709ba5WFNL7c93U9uXQrqdAzKnm+s7N6jOBplL4yDgNu8/9jhJ9FdAOP0AtUBxyFsZHK/trFVlaUNi4UT77JW4BV4Vs093UFS2Ihc42mSfnujUrRpPG4cRDOj7PDAJf4bZsyt8PmMoYGfa7Qacs9qh+vSi6tRACSZX5jV6vpgpqCsk24eeh/djlctvhVxWNUHHF+S5XZMrr5vdgUjvpHYd/2HUqsFz6n8zMLp0UL1LnSuRY6/1SD81FYrbGf9r1Qu1AZSuEz9JQv2wwaaAJ2bOXn3YjhXdagEMNd481w5kPjIAJjTtU4PppyRsWAMksT1yFWuVoE50ggzZVMbBpiyzKi+6IlDpCLTtSf7MFNWGGIHSGM7GXGZF7fg0WLbJqm4pU+p3LKWI8qh6DCC7t5AJxPxJwBVWMP8fGQWusw9uu2vRHDkCzQ9rO4s/lyhB3omoy894zCLyDfk8IAF83i/PaU05Ad3DgvizvvfY/UxT6LDkKd3pV/O8zNArZJwApDnoLjKVjNd6AVsX4VZazLj+jB3AeTN95KP7Wq/bKa1nf9e7Q3sR68Y0EsGZ9Tc3UEivXM9FbYmwZBH3CMT/MK9MbMB0jYdkuEPYzXsR0IQW9nE61PTxu2m91AhpbBZRf+g0ec+xDBvkeWwuKcePTQr41Xx/C0jL/NezLnOOLBzvZPTiHdK3R0NtaZyLeKXy8Mp7uurequkSo9tGPBFecoZbBKxDNFLnAPT2JzNk1gHa4gW5XdZKDIMLXTsjx986/cyjUEHWl5h7yapE5hDGu0enIv8vL5Qc/S1weRTWiiayoARqwv8v4t7OgRI1ty1FSST9S9puvorCQLj/AqRwBCAPU
 6gBH57ah
 dAtrkqmk/RuJ9HWEw1VTdVZWzJOHBPLin9QkAQyRe24tx4eahCVg2dzbqTFpQuEb9a9uvpF9LsnDhas3ZP333fXsD+ldX1bZJyX1yPJvr2f6sMszMJ2oL2b3QHzmQ1Bm36gOAGo86ZoJqlt94zvQsg6VvVc3s3CCMucw6za3CP/Qtk+Q2QgCSKupeeCN4EaossTw8TC3P+Iogc/+Ne5PhlSCSLzkcD66N1qpzaApdWaJ2UtOeFHOjU7i9cA7RdCveJEj6fCmsRlr/dcAGaKePVLadbTkd/dikMFJ+LOQUiDHEcGK+Gnldzu1FxwIR9xwAbjKBo3tR2ucu0l9QeVn+PrW5ba9He8HKXJTXkqQGMOG9jVM94e5wjruvbWnDkh5heZaT2gqoc1kHClQPRfyfhnoI9VjxE/LzpwPV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 2:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Oct 11, 2025 at 3:42=E2=80=AFAM Pierre Juhen <pierre.juhen@orange=
.fr> wrote:
> >
> > Hi Andrew and people reading those lists,
>
> Hi Pierre,
>
> > $ sudo hdparm -t /dev/sda
> > /dev/sda:
> >  Timing buffered disk reads: 612 MB in  3.01 seconds =3D 203.56 MB/sec
> > $ sudo hdparm -t /dev/sdb
> > /dev/sdb:
> >  Timing buffered disk reads: 570 MB in  3.00 seconds =3D 189.95 MB/sec
> > pierre@pierre:~$
> >
> > But swap is not used
> >
> > MiB Mem :  31952,0 total,  27091,7 free,   3057,6 used,   2343,0 buff/c=
ache
> > MiB Swap:  36000,0 total,  36000,0 free,      0,0 used.  28894,4 avail =
Mem
> >
>
> So the disk is already having a performance regression after swapon,
> while there is no memory pressure and SWAP is not used yet?
>
> Are you using swapon on the whole disk / partition or swapon on a file
> on top of the disk / partition?
>
> >
> > So I suspect that, when the swap is used, there is some sort of lock th=
at slows
> > the whole disk that contains the swap partition that is being used.
> >
> > Logically, the system becomes very slow.
>
> This is really strange if swap is not actually used. I just tested
> with HDD locally and didn't find anything wrong about it.

I just checked the bugzilla page more carefully, sorry I had some
misunderstanding of what is going on just now.

So usually when there is swap IO on an HDD, it will cause performance
regression because HDDs are slow and really bad at random IO. So if
you are seeing a lower performance with recent kernels, could you help
check if that's because the memory pressure is higher, or the kernel
prefers to do SWAP more aggressively now, or the performance is
just worse when swap is working? Maybe you can check and compare the
swap usage after the same workload before / after the regression?

I'll also try to test again locally with some slight pressure on swap.

