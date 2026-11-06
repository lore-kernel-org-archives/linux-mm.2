Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D75606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NW+CiO38
Received: by kanga.kvack.org (Postfix)
	id 8CE936B05B1; Fri,  6 Nov 2026 09:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A64A6B05B2; Fri,  6 Nov 2026 09:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D956B05B4; Fri,  6 Nov 2026 09:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 529986B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:35:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1F3E40DF0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:15 +0000 (UTC)
X-FDA: 85404941790.08.705361F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC73714000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NW+CiO38;
	spf=pass (imf26.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793975714;
	b=MCRhKRwm6itqud6QH/7cWornBEAjVoqXbbmiTnIHkD6cqupBiSv4feAw7eurGr+jlQZwUK
	muiURAH4acgyTLmCqk9FQELSljBtRx+iceJYWu5Y9KYHGijXrb6Q9eYObkbLEHtYc+Rqjq
	MJUo412sGlm6arK+X3tvnOTYTwy5s2s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NW+CiO38;
	spf=pass (imf26.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793975714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABFV9qqW5v9B/veTK1qFSxVFzw8UX9r8phfo5f88bHM=;
	b=x+J8vMKUjCBDcHYdI4RFGyn4hE7jXpBhRv3sx416fkYCXnXX+T+6MKMf595uW++EP7xUtD
	M7GBDripcFEw3kZAXfl92pgWjEh0LwCliC0BI+uffaoXplugWdWWKWh3hKBZBzgL0/q2aF
	ioUPXGxkhr+RkkdbbUp8yOQdERQ+KS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D716400C2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E617C1F008AB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975712;
	bh=ABFV9qqW5v9B/veTK1qFSxVFzw8UX9r8phfo5f88bHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NW+CiO38XAipmRfvZb5pGzPtdB2zoSkBFY3QqVyfdPAFpM6fBH+ps3C/WRq7ZfzE2
	 o7WUwzmqQQ3PkE3gvMRfgOCP9XzXNGtg12V8S2fi5UZdZmB4q3mp8G+xTIwOtPAtXN
	 3uNZAFMQ5hm//mnLWi8wTsZWz9GGPkHPOFoVPJnbpwCohuzkA8Xk3qgp15B/Qd4kC/
	 XXTNMv1YKeN4P6VHCjS/J2rMGpKFjXdtYP8tYgnawdShP5GHiBIrTMXGFyBBhzj8Df
	 6SsOM4/1dFVK9LCCm2l2qkHcdnKYWKMJ3f1ACFpTO2jqaReJZQlahdWNR0bptLYcEb
	 BhkFz9AHmxvVw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so818124a12.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 06:35:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEUpNVpvahDBdEM3wzzNCL3fclwBL0DUXvNn2L0kZyL13KfKd9BJ63kC595B3jEW3QJtBtznmipsA==@kvack.org
X-Gm-Message-State: APuU4Z+J1glRvHrNffv3u80zBohlXyIDsY6UO2r/0o9b0Becdaeq068j
	gxHFyn5qOApcOUe32vbt5OKB12RKeGY70oAN/VpysHlkzw1H6TEhvOmRd8+Xu+dRmWSDzyD8qYx
	AeQl3tYOJeHioc+aRIbjkcp2X4JFmfhc=
X-Received: by 2002:a05:6402:1e94:b0:6b6:edd7:7928 with SMTP id
 4fb4d7f45d1cf-6b6edd7899emr802991a12.26.1793975711577; Fri, 06 Nov 2026
 06:35:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org> <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
 <auypq8_7T-vml5_B@kernel.org>
In-Reply-To: <auypq8_7T-vml5_B@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 6 Nov 2026 22:35:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
X-Gm-Features: AclHuK9KCIrf61pzsewLNfcg32ftrSETM4BdWXL6OTYNNDPn4F3U0UamXyiZ-QM
Message-ID: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
To: Mike Rapoport <rppt@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hzyccy19w4ta1bickzux3ocbceq4hsco
X-Rspamd-Queue-Id: CC73714000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793975713-433990
X-HE-Meta: U2FsdGVkX1/6boWshkks4u8HMtIxf2uSPU90dXlytt8ghXyLB7uWga/WXjVIxZBsu5kLaXc6hHDAtjIeNcUzpXgKTQWt+JsONe7NUDgl9RdB3fPBwkZrIfwJ4q90GPbyM57rtorrK1LNv7kaF1iHx22NzEQDqde6XErdSlBGqJeysmFeor3S+zMYXmP1hxgnrt/ede3s/4FrVVfpDV66fdnxFkXG4Kw5E/7qc5AD77v0gLQMGWPffmgnENGUOCGHODButpTe4JIkvmiOIuUJh+6aPop7hEO0ZVxV4gWiAmRxupofeZgWd8L/rty7pOXAoA002ziBSMc+Cm2PA7kh8KQDfucksdzUHs6CLqtwfdH85/Vw1sC2+qZpI28KC/SKLpDpAV2WS3W3++xrsEATTx+o31eZo4Qa/owiaeu+F/YPTU7fUnrbw7c2mT3v5w9MhHx4EkcQLvlu5gijiC8ojmLtFmydqMsyK6kgc0ZjfEXkzOgys7OHL1KuI5HMjqCtCTXgdzJ8mRbL4jP7fv/HL3E4z365+anSJ96O7EqNoBzHeKWHVnP/WfJtnwLTB4Jd7RplyOJMHm26ch782W/NumiZ7j7EaimAs9teXUF+vZ8FbFAPT61YogAIRQC0amnF6E5LXjPG18/6kc0qq9h/iQVIvURk11FvEF7AJrur/2Mf41c8vmkHaW+max9MDMlxpHugpum4It8Zjkw3mpfzLpC1wrDRIUUzMIx4WLg6LmEQsFom0HlQEC4gY7zKyS5bkDk4edovBT5BHLyVt78PiQfPVjFMpA3+kht9CrpBkFdgiuqkCgzC0CH3gFLdfvRT34d3D3rjECk1Sd7uiKvZ7n/wOsUxPiDSTgiRfpacnK25qU0ONSWD6oAgfLQT3pznRhNWgP5Ute7IvkI/E1d18BE9BHTmhtdPf5srTiZulCufDM4wAFf/LeUuD9CFE+sHcy2u62z1FmhQBE72Nx0
 RtG32VWm
 sPR8s2/DXpUp8yPAgBTQKlyRm2QoVWj0wm5iDSiWmt979FBzUz7mh1zfO0r44gkLhfYsZW/wuUuS+Q+GA6AQlOpDnE2bArprNNWs1rlYDic1h753GInEV6XlZp/tG5Fdwa9BQj8cwPO8qOA69egKPaL/5It5ldomlXZdL/PTKVxRm/FPs18VSUKBdvHw5p9sUrFiOiocNGT3gg7VR/7dJEU/LCmDlYSLQ2EFczksfAcCF/xh3MwejrZtPZu+4z6k+u688q+TjiWeri2hNTmjou2zYIbKQab4BgyZpA9BCi+JmeL6hIUiw0fwTUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 12:07=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> > Hi, Mike,
> >
> > On Thu, Nov 5, 2026 at 8:57=E2=80=AFPM Mike Rapoport <rppt@kernel.org> =
wrote:
> > >
> > > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > > From: George Guo <guodongtai@kylinos.cn>
> > > >
> > > > LoongArch never calls memblock_allow_resize(), so the reserved regi=
on
> > > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> > >
> > > This might be something to fix independent of KHO.
> > >
> > > Huacai,
> > >
> > > What's the reason LoongArch never enables memblock resizing and why i=
t
> > > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> > At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> > boot failures on a 128-cores machine, so define it, and the value is
> > similar to arm64.
>
> AFAIR, arm64 had to reserve some per cpu data before they could enable
> memblock resizing, so they had to make it static.
LoongArch is similar, so below 64-cores machine has no problem.

>
> > The reason LoongArch never enables memblock resizing is because the mm
> > code is derived from MIPS, and MIPS never enables it.
>
> If that's the only reason, you might want to revisit that :)
Yes, it seems we need memblock_allow_resize(), but maybe it is better
to bring back paging_init()? Most other archs call
memblock_allow_resize() in paging_init().

Huacai

>
> > Huacai
> >
> > >
> > > --
> > > Sincerely yours,
> > > Mike.
>
> --
> Sincerely yours,
> Mike.

