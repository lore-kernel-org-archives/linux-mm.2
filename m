Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C103E67A8C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B956B0088; Tue,  3 Mar 2026 02:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E99B6B008A; Tue,  3 Mar 2026 02:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB996B008C; Tue,  3 Mar 2026 02:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF286B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:20:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17AB2C2506
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:20:27 +0000 (UTC)
X-FDA: 84503903694.20.92D3340
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10909100013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:20:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uL8bXKJK;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772522425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVdYil7W0i9u77JXtm0StCzUZz4J3OdCK1AwKZIzaa4=;
	b=oLQmxuosGvkibrXLhID+bJGhsT88a+1knmHVgqR4wcQT9vAuztFTiCTmCzTdBXPvwF/QeL
	hNErKTUQsIJ5mB2P6fkXtNtU9Vkk1RtY++BVYLXT4qEbbo9vhXdC65YCMVJi2aIsuyFtNT
	Vv1Y/USO+YXsTOg81op5X1tgstu2tuw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uL8bXKJK;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772522425; a=rsa-sha256;
	cv=pass;
	b=vOjYOSiODiihTvjXIr9h+nJnI/AR9jHLU/KK2FqlVEAzyztXkG9ouI11l4jAD7DXnFC+Ec
	a7DMTmpzJviVeHuGHqoMA91DCNRx5DRqokGgxSj16NpAytoP/gANtCcVVFPBnC5AgmEOwN
	fD+fWLStYdlFJScwQlG2qbL4t0W3d90=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8f992167dcso541126166b.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 23:20:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772522423; cv=none;
        d=google.com; s=arc-20240605;
        b=XYzANupqM/km24zuTXaynrrGbmLMDFOVlSRi9f2XZDgk6rKTN8wjaWXSITVNUcHXWZ
         +ClH62gc0ZAKQtpxlijkHXVQamexJpnFfOftmcnIiS6jyG/RNLOBOXkehTwDwsgumiyn
         vni6BJxkR40DjnD6jZra1nP1IXzRipS0F1ttImJqj5ONuiwYl2a1yoOAJ2XyATSETU4l
         n8ziZxJJMOTrCzWhQo5PKDdUj4XMmlT9nLCXzGQg9TaBLYIqdfMmbDjUAeSz6W+CvWlF
         tVuO/bM3vZlC2XYImp9r2qqGXQRe9Blm/I7poE1tNhuXMBB+yJ+KM/vh7lVxAd0zqoZb
         h0Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VVdYil7W0i9u77JXtm0StCzUZz4J3OdCK1AwKZIzaa4=;
        fh=wTZlei9+ZJyatiQHaMHK6sSn/lJFRSgAEfbc8HrkKdo=;
        b=SSllWHAWW5a2vwCEneewuQPKw9NXtHVSQHScKmoSNNmVPvh4yE2hMPRcqzckwQvMbQ
         Mgma4tc7LRWlX1dO+D42Ck/MYVKQgE6AUM/58I5qlvLgm83a/lJsXJAQtEw8EkOWKOue
         j5ISjeqQi/QJlsA7EcGcGZnhMmjLyOYQgtHQR9bc3DnpT/duxqyosngpxvY6TQ1LrJ40
         /0K91LSLGZsvtDpoWEWibE1QRsFVpKjj0XUCW6PC5aNT9voLkNH9xiw7da/bU1kWaPkF
         aYiNtyemDKPtELSNf/X3C1rx0l7jIkk7hZ8HrfjhBiXRIiSeJPH88NVNF04vX7yVDjY1
         sRGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772522423; x=1773127223; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVdYil7W0i9u77JXtm0StCzUZz4J3OdCK1AwKZIzaa4=;
        b=uL8bXKJK8ad37loKNf9N8IOQ3ul6AoxH6Nh/6vconYfGkgPFwxRw3XaOZDN649eoEo
         NpgLGjkAU304OvGwBsn0z6W22f9jPJRyz9c1rCFy0nmvvL42r31P4+jFje/phevS2Ddx
         JsdP7Q94cHzliqT6cFJrjCy96xiHQ8iQFWNrr0/PaxfcTHaT9phlhvVere9g9vopWA1l
         /1t52VlGVtWV1yzu3GAjTCkwbh/tajfNrKIyukypVoqxfFdcId3821jFhQUjgXZNAv28
         knCduv+8NnVQaZjOCsxRq3hHWnrsb20hZsi+WDtnY5iiSleDVYipA5w0gS/ERKYpAxgy
         l85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522423; x=1773127223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VVdYil7W0i9u77JXtm0StCzUZz4J3OdCK1AwKZIzaa4=;
        b=C1yQgtkztiCgyC4mEmmXLplS9jUCfqr0qWFEuTBzzscuKLfcUq4TVqGXzm4ow/iysm
         U+uDzNpeI51oDbQhLS2nQDRHl2lHTkzkihnUMfg8KYM6crIG2LASGcGTbJ/Mw+jCJhJg
         PcV0mFBc9G87CGNteBmVp6D+/8a7DA/ievHt7bAngIhthi/ecS/B1AO/kf5Jc3srs+N0
         WLMoBOotVRxG6Ym02l/1XoDuGHHklE3oPOOk9w7ar0ye6hic49FLNJffW1xZOFLaT6gA
         aHKsCKEBGDyV78YSQCeXTWsZy474Qk1oJa/dOS6qibDfzR+uWEIcDJGWIY+lWOnu3LVb
         p+7w==
X-Forwarded-Encrypted: i=1; AJvYcCWTOeHBVAqld3thmSkQuFSIsDzJ492RwPJASWHcBe8gYUQAyuOsa7LN9bvSbbQHIQMP4xXy+5b0ig==@kvack.org
X-Gm-Message-State: AOJu0YwKUPtCAKso9vtkNm80TyZMJk5wK8jT2K7x8ZhAeC9LT0DenGvv
	hUjL8BScZhC8IXEg7DcUkQtrFJ3amulhjAW9MbjllePlnijAmDR24Ur/y37ZADXbA3H5owwPSRB
	vXMr+i+LmG09UaEGPsk2gbMLVFn50LeY1+J1ZcE/W
X-Gm-Gg: ATEYQzzPAsVv+JL28tX8f7jm31thYdyDrvbUg8aSorhyFenp1BTS3RMT1rXVm2XRy/q
	eRjw6qRVVxlnYwYbpx7tKLRPzWd86uiuslbLpn1UbiV4JoNjs0G2fbb1UibuofhdSG2e/xpbSFA
	dB5uq8RUETfeWfdAHDY7TrwpHcYz1zr2AqCOqq0RkwEB23faIPgNzDyQe2OVlBTc1Y1D5A5aNT1
	H7cey55I5NhpoKopwDz46m+gMPFswIXz1YmibS3Ixag4JgZ2YC9YwQuM2WXlC60CajILdauEJmS
	vgLyKKnzUFBSXSqInTzQ5NgXTc3Nrjo0IIMYZQXh
X-Received: by 2002:a17:907:3d90:b0:b93:a3db:a6b9 with SMTP id
 a640c23a62f3a-b93a3dbae19mr488908066b.53.1772522422966; Mon, 02 Mar 2026
 23:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
In-Reply-To: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 2 Mar 2026 23:19:46 -0800
X-Gm-Features: AaiRm51Ep2_L29b_JroBYwNE4zf0aj9rqC2fV9F6QzDJPa3ta2uUEeGpii49xJM
Message-ID: <CADrL8HXaTz-TS9rYiQkZ6NoRWhHm0t4Tv0t=TtDXS4purLnDJg@mail.gmail.com>
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
To: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>, Breno Leitao <leitao@debian.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 10909100013
X-Stat-Signature: r1j1ejeizj78gwyb96kmt7sctbb4mmc7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772522424-638204
X-HE-Meta: U2FsdGVkX19r2/I5zjEGlIVsPn2HUicJHDKRZqfNyUATI/qLJ3ZLrhDSyMb6QJL8auyYyKFIXoC5xjpsR2tbBx9HjImYpcOy8CVoyzlmMxesP06POkYOL6QMAmZC/ZGG5eBQ6Hrn5Zk0rbbwZWWEXu5SSbzfqK4K/sjbIY+7c6IjAaBlYzwQyTcTan2mvDSIc9H+/FKt9qu5deApYzAgfcwlo2AGAcNyXVlsfzMoLPs0LT1AqPecXf1twtCDE/QsadtzgzvGOiRDPOccqRNGD1KbN7lHOrFalzqTHpbf+8X3IkzZrTAN0ag/VvUoD5p1ZPhUbhFIWwy/ex96rlYK5UpGFmJKvgiUNRXkeg6TU/1S7zkNuDAZgbcQY8ueEuLGQ9tqw3G/s5IMNZ8zEBPic0HpBhsymB4xQcsERCXnfauPpjxsAhpJo9FSjL7apQKnit2Ww7b30OiTcpx05irPuGQsDhD2JG7rmphiQ+4e5r+b8TheawMGIaOEPf/yM1ALOxO7WBZj/Y2O+2iMOREVaPqlICvJZEwBuzlvmUEEMW+G1sml53L88RIDd29ARCQ3jFra2F/o6gP5MHhAklsDAGwXBsjvllJxvMwWTmUtIT8W2R7eREKg7G3lyEy5pA3Yez9H3tU7ajBCEhDTPleZlVrt3qf6rNuR3ydtj9xbTwCDZhG78vi6x7pIJ9+IqdnXsDQinghn90XImYbG7BXBcgIIYXySwK0HXzpITQ8IZGmqxTky3mNoWSvyvKnh2WO84qLF9a8NwAslgtO6jE+V0WReEQB0a5LkHW9wzHzTL4CNBfmYRRhfPubXFBKQuRFjkP0jgI+LffeSRQVtR0kZvPFR0zrhEqGEguDJ3ADJfzZEXO1k62n29E64wvh/TaLNHg/eYJ6ewFcDOfDEAjzoViyEYCMIp28M3YiUyO/8V0MlywxHdxMCuDqsSBJGcjM856zOzneTPYD2EcmXvky
 GyS0QyOl
 ZWFmX4pX8qHfFHUxBzc/VAZQpDISOxtk60brlRnA8F3HwWRXIrvjhV2ZaMfeJa5YpNokBw0RDa90vfLjniKZ7dYNmlaQ3+bn9ZC+dA1S0vHbKahD83gX4d0G4A7gc7/Z1wVcHuoo48GucHOfEgBpGJbRU+yk3jckChYHLKfbA+HpIbX3CTlov5DMlAXNG+QOiGzaPLCIr7mY6O4/MvkE2bgJhkBi5Uulp7JD3Y1tM1ewl0DtAgNXu7xKm+XXaHDZbEdSh+TfuBn7iiP4tiWfbyeGmlUI2qI/d/h9GxqfZmG5jnPvTrEXdw7k5sKM89QhhtJo++8G7E+CYPMd3KzCvS/tW7wGVXZk+6GnK0ya436cG9rdx2FSZxnbUGQc83beic9Jb3GLIeDaOA9ok3OCki8BUvD830wXPw4hhskJVG2seYGxd21H/+YUCng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 10:38=E2=80=AFPM Piotr Jaroszynski
<pjaroszynski@nvidia.com> wrote:
>
> contpte_ptep_set_access_flags() compared the gathered ptep_get() value
> against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
> from all sub-PTEs in the CONT block, so a dirty sibling can make the
> target appear already-dirty. When the gathered value matches entry, the
> function returns 0 even though the target sub-PTE still has PTE_RDONLY
> set in hardware.
>
> For CPU page-table walks this is benign: with FEAT_HAFDBS the hardware
> may set AF/dirty on any sub-PTE and the CPU TLB treats the gathered
> result as authoritative for the entire range. But an SMMU without HTTU
> (or with HA/HD disabled in CD.TCR) evaluates each descriptor
> individually and will keep raising F_PERMISSION on the unchanged target
> sub-PTE, causing an infinite fault loop.
>
> Gathering can therefore cause false no-ops when only a sibling has been
> updated:
>  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
>  - read faults:  target still lacks PTE_AF
>
> Fix by checking all sub-PTEs' access flags individually (not via the
> gathered view) before returning no-op, and use the raw target PTE for
> the write-bit unfold decision. The access-flag mask matches the one
> used by __ptep_set_access_flags().
>
> Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CO=
NT
> range may become the effective cached translation and software must
> maintain consistent attributes across the range.
>
> Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>

Thanks for the fix!

This is similar (sort of) to a HugeTLB page fault loop I stumbled upon
a while ago[1]. (I wonder if there have been more cases like this.)

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

[1] https://lore.kernel.org/all/20231204172646.2541916-1-jthoughton@google.=
com

