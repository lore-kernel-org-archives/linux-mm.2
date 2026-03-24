Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C965DF532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1471B6B00AF; Mon, 23 Mar 2026 20:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EC76B00B0; Mon, 23 Mar 2026 20:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C146B00B2; Mon, 23 Mar 2026 20:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E902E6B00AF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:12:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89B75140DB1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:42 +0000 (UTC)
X-FDA: 84579030564.26.DC8A9AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9BFD4000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EbwpHILI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4wcunhOzAWE0Wa/68gb35zEtWQYL+OkArGF5V8/Zho=;
	b=OZbnCK6ovKVorLQyrLWeEna5Ugn0rIKNDEY0JgMo8qCk8Nz3j7Q96YEJZnEDKzJjAhpHKd
	A2tiBpP/Su9HPALZYoXkZDFLPkiVYkI3sRYrc8ucpNJpLoruZ1bgjz9t1gYpGME83jAV0i
	NTPUr+HXFnoPu4ZQgxn+X4FEy9jJjJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311160; a=rsa-sha256;
	cv=none;
	b=JBcIlJiJaj1tHzvfG7bvUhCwI0QlE/xb5texaMzdrw9aT1cJLozX19PJO1G7DyxeMPoXmC
	hjbx/gbUQcCy3FMRDi2tXVBtredPjDTBHs/hQw7sL3YVnzMmFqo+QO+Gz9i0oh+Lik5eaQ
	3ER1FfXLCEs2DcImR1CROnPFEbTIi78=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EbwpHILI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0696460128
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAADBC2BCC6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311159;
	bh=+H+s+aYHdcYd04gEc6EzQ/seiFgB/hzUY1F9yPfmoQA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EbwpHILIgrDz16B2s4kO53Xdxoz8B3HvC5aZbHN5d3HrTUxTCzn2Gshz/wT8+Iihj
	 YArY+6RnEkySw/spJV2mmre1jWbAszzRKIqcDJ08zI3HGB4b31IzOOVC8yaSWNXf2t
	 NTjhsypu8gSwHGgcJVS1xzmRHvfbegIfP3BAodFz8Fa/aNMJdCuod/exVPymq9JF55
	 0sdhwaBPKzJIu2oe30G3+27CCAEisedicZBtpa3nUA+JhVgO5NLguf6xA179OYj31N
	 hRd7hva+/9wE+6TE4Zly1QS274Yp9RVuKpkGCcVzY8KFMQK0YIJN2cGXezfwH4P2MZ
	 qoh+ih4iO/A5A==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b98069e41b0so864550366b.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:12:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW5kwjWhSirLI2xpyDKH03qnu4ke8Lgo/0FeXLVc2lpcziylQ0jTQTNzd6W6bQLXoKAfYcYfLoyCg==@kvack.org
X-Gm-Message-State: AOJu0YwfdTYG8yBDtv7gbJZy98ErGJNIsOiAbzQGZV0nn5RJSf2Ml/Sg
	+lj+ZOcZfl+hdRYuO/tjOGJ0sibKJxfuwcAuEJ/s9aqggpWu829RyILGACEJM4IOXCBjO+6VJzZ
	G5KTf5R5cxTTg0laERssMRarXh2EGp+Y=
X-Received: by 2002:a17:907:9454:b0:b98:f1d:6a63 with SMTP id
 a640c23a62f3a-b9886321306mr94675066b.9.1774311158414; Mon, 23 Mar 2026
 17:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
In-Reply-To: <acCyPNCBoTGAJjfs@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Mar 2026 17:12:27 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
X-Gm-Features: AaiRm52HZcCGreQcxDKdZ-TsdspC_G13k_3Z2yzugtPstoSi8EP305bZwbreA_8
Message-ID: <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
To: Li Wang <liwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com, yosryahmed@google.com, 
	nphamcs@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A9BFD4000F
X-Stat-Signature: xu9epkiutocehcuc3o6jk76rnkpa5iyu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774311160-558529
X-HE-Meta: U2FsdGVkX19lAU6E8mpnIiX9eqp41x3+Psjb3OR8xn7Rwtr5HOQd37svNGCFMYIHOjcaarc5IhpaI3eY5QSECAZZ13I0nWTQat34a7izNVtIVyenktd/5A0A2P8iy2gdO6gmkYLtUgi7C8jjFdmBq78YqHvvtFlJAiRDl2u/6FiWWX/dGSZIj1UlMDXtyiNvF6mN5/kwowDkBrJ3jC2zD4R+tK+2QEMzLNzn/MdHfeOAE4aDdFAfVcNm5t3XNWZyTWiVDvxZfAr1t7Tn8oOP/mIL5DxaowB68+Ieo4GzlcaI/DWbJYfJRTT3c+rb+aEPm8GmxT4n4qzgG95j5zCraaEgmclfmBFlIMyUd33ODMyjKDZB6jIiirMWloIQtkIEIfgMbtwi7VAMwTvHtsLwCoCZpZdn60bDTNTgi7zsd6t5zSm/MSv2GiTwKbQnQ5sjEQYDcV97RIE93DHs9QDvWNN5xVNCI5dfsuN4b1050MUjg8hbjJrwbO6xgNQDeABoQRiggYYpTFJoOWENm1GvNsQvWev3Flgllwx9xr4DCT7YjpmQpMA+AEssJDbKccqIa2MMhVAhUt3S37bVab46r/R1CFWD5K1EmCAkPlAXpFqeF73FB4Oy4IY72CK6h0wGHCGVJBXUnrViQftsssfcrSTS7shGVeVwJAjHqd67+SBA93h90MRNzi3Bd/1wwFXA40GQGXBdczy3mg8QgKzUtoyaoR0sthEL25PSgUs5sORr10w5j/jKH2MDBzdM3nlmVSbZywkG4W3xrXq5keIZpQtPjWRhQCGUKf/woqdFNCDmUaGuZAel71YbJg3Uv7W9m4Wu/Wprj4lk0UeRbDAf+/rn07elGTFOtav255HF+vHOlQMbnpqCIW6El4u/xihXYGHCrD+JLSEvkZkRvq4jsY36MlW4YfXXjg0Yxx/2DIYBqrQDTTzXT003MdMJaWUNKEMmjG0RPDzgPGtZOQO
 Z5kHVnKR
 Ch27X++6B/vAgF3wTDNjyts7fvkjiCdNBdAvMbV95iklYziJDtvfBN2VcfMxUTNjz1Z5Oq9QLycdIdprSB4jzW+dntXdUzYXG8nKWLe+qmytxAipPMH4XhzzgV4cDq4RKE+4AgQe+ONgjxTxSJqEspWq8NMPYDmNNTR6fO9nkOrP+jRN5lf3SknY4XoJ2alEdfcFsawN7nKQg91MQsfPXDvjxdCVwUu3NZ7vLltmbqbKx8O2wAPQx5qSy/bd0jt2YznniagbnrSaPdcLWBoVrxjk5u/he3Jx966RMdbY5pd4PVe7XBa46QzRGcP31i8asShZvNUospELrgsS2z1eQ0CqiZrynPG0aSSj8ikR9IhhQucBDk4hESkQ4/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 8:23=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> On Sun, Mar 22, 2026 at 09:18:51AM -0700, Andrew Morton wrote:
> > On Sun, 22 Mar 2026 14:10:31 +0800 Li Wang <liwang@redhat.com> wrote:
> >
> > > This patchset aims to fix various spurious failures and improve the o=
verall
> > > robustness of the cgroup zswap selftests.
> >
> > AI review has questions:
> >       https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@red=
hat.com
>
> > [Sashiko comments in patch 4/7]
> > ...
> > Could we update this loop, along with the identical loops in
> > alloc_anon_noexit() and alloc_anon_50M_check_swap() shown below, to use
> > sysconf(_SC_PAGESIZE) instead?
>
> I found that Waiman submit another patch that do same thing like this
> suggestion. I'd consider to merge that one into my patch 4/7.
>
> So, let me talk to Waiman first.

Probably fits better in your patch.

> > The test data is generated by writing a single 'a' character per page, =
leaving
> > the rest zero-filled:
>
> >       for (int i =3D 0; i < control_allocation_size; i +=3D pagesize)
> >               control_allocation[i] =3D 'a';
>
> > This makes the data highly compressible. Because memory.max is set to h=
alf of
> > control_allocation_size, 512 pages are pushed into zswap.
>
> > 512 pages of mostly zeros can compress down to roughly 11 to 15 kilobyt=
es
> > using compressors like zstd, which is well below the 65536 byte (64k)
> > zswap.max limit on a 64k page system.
>
> > Since the limit might not be reached, writeback might never trigger,
> > causing the test to falsely fail. Should the test use incompressible da=
ta
> > or a lower fixed limit?
>
> If Sashiko suggests reducing compressibility, we'd need to fill a signifi=
cant
> fraction of each page with varied data, but that would work against the t=
est:
>
> zswap would reject poorly compressing pages and send them straight to swa=
p,
> and memory.stat:zswapped might never reach the threshold the test checks
> with cg_read_key_long(..., "zswapped") < 1.
>
> So, at most I'd keep the data highly compressible and just ensure non-zer=
o,
> unique-per-page markers.

Sashiko claims that 512 pages will end up consuming 11K to 15K in
zswap with this setup, do you know what the actual number is?
Especially with different compressors? If it's close to 64K, this
might be a problem.

Maybe we can fill half of each page with increasing values? It should
still be compressible but not too compressible.

