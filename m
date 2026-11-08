Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA104606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oq7mXUay
Received: by kanga.kvack.org (Postfix)
	id ED0C96B05B0; Sun,  8 Nov 2026 03:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9D46B05B1; Sun,  8 Nov 2026 03:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE9A6B05B5; Sun,  8 Nov 2026 03:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4B7F6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:26:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A4B2A7E78
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:26:58 +0000 (UTC)
X-FDA: 85411271316.05.23B27B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5503040007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:26:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq7mXUay;
	spf=pass (imf27.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794126416;
	b=d1yE8q1Q44jR/mpQxSR1piYgUlU4yErEb87Wt5zqsiRd25+y0z01/wADtPGcGcnsQE32M3
	yPjZAy3Cn0EkC+KUoiVnYq1wP92aglEV3q5zEv061/zQ5aE4ZML5ZHAU5tDtxwyxKjoy9n
	iu6oaHnTnHpPMm26VbO6KunC7wBICso=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oq7mXUay;
	spf=pass (imf27.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794126416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4OcSAvcvQKsjkU4ru+MvGNBWR2vHDxkyHmPg+JgZAI=;
	b=hDNSsweP/4U0eyPZwjsWgiJZwsvIGqzVwCz/UsiZEtgESHlVn/eipGWF7vupOgKVH+rpmC
	q1pamuN4oXlnsiIur29DBC042fzBwDf8kps09pv7r24AATTKIslV4VqewOQR9SVLxhmTOU
	bf5uXrFNUuiWzCIgjJ5fI4+gvDdYGbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50E0744860
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A91F008BE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794126415;
	bh=p4OcSAvcvQKsjkU4ru+MvGNBWR2vHDxkyHmPg+JgZAI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Oq7mXUayhQTDePVUjrfThAEG1V7e8Y9jHk7AEkIGpjTfkJ74OuNKPp2JUR7gO6tjO
	 gK8sjs0oIZYhKDO6UAQr8qwL/YVbv56dLKzgtpDd7Ua8fA1u/US0Lt6Z7nqH5rpA4e
	 /IbdbI//jYesPChnrmZ3wF53SnhaOo9IpQJRu/gjg2BgoiNbccUOk2BlPXeSHLr2bJ
	 W+AKvkmtSnFlVXENHlF79lpkVV5/tb9l3kXutdiZPrBwEESDq5a9oN/zvlNORF7AkL
	 cVdyb9kv+rjJRYxLzhIkLE1kUTtu2vZibPxBIDsg25TnlJwIVxiE8uI0sMGN6rYzyO
	 hqnXX48hdsztA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b5669a5100so262510a12.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 00:26:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHm6Dr5pZwCph5eEqo1c4MJA4noJ9chTKEZX7aUC6zGXNvjS6981yEXVH3rwAZk7UBDLxPuTyku8w==@kvack.org
X-Gm-Message-State: APuU4Z++lCjlNPssPzxbjQXZzKtjbKczRbAhJae1uxfebm6r9CESFjhO
	DZW1lh3eCACfL/ueTVn3dsDQE0eY+2TAhNgtgyj22ifHkL3aiTSxsJ5bX+yxn4KNFy/rykt0qNW
	sdBZ+0FKxtjnf9diGmtg99fhM8nEa6tk=
X-Received: by 2002:a05:6402:1ecc:b0:6b7:1c:eaf2 with SMTP id
 4fb4d7f45d1cf-6b7224041dfmr591123a12.7.1794126413758; Sun, 08 Nov 2026
 00:26:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org> <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
 <auypq8_7T-vml5_B@kernel.org> <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
 <avAvdiYY7SJ_Gfwt@kernel.org>
In-Reply-To: <avAvdiYY7SJ_Gfwt@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 8 Nov 2026 16:26:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5q2SiDJC+ZSA4F7kw2vO=Y+c5J-aNg=PNMoh_CZ7qWdg@mail.gmail.com>
X-Gm-Features: AclHuK9UKAm9d_ZAky8YF1Z-Jn3w5G8u3fB621EiI1G-bSq5xcRQq5mtls0NIdA
Message-ID: <CAAhV-H5q2SiDJC+ZSA4F7kw2vO=Y+c5J-aNg=PNMoh_CZ7qWdg@mail.gmail.com>
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
X-Stat-Signature: sf4oic8k8kdt8m7ejag4resep5ihgrfu
X-Rspamd-Queue-Id: 5503040007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794126416-727280
X-HE-Meta: U2FsdGVkX18Y3auQEHfBOzRGcsUBwQRF3i3oihOGOrI+4ydJ00aHBjOvTp2N5zoFnybnC29jceG+xp2syGfg/77lKiyjvf+Q25YBzdYAL1XfG7mc2AAjrjtcGH3sBkqnEoHpH/wer8RdWJDdPa85KvQb1rfs85o66AcMI+Djt5sSRLIwuFUEjBEJPcUgmuFRJJLIxWr+Q38Oo3y6ltU9zIkgTCAKmssTuHbCXlnKqs3eyFYw0spWlhLE5pNvcg+rLTupO+H1BbPXQKPVfY9twjLFzEm61ONzStsAYao6j0ZvrRZQ6MNJhpIxXGLA7D1tZvNHXz8Z5NBtQd1K23YiBV+ycNpT/RGSaBx02Of5+pVW7CQ3idB4Qn+QTtYhgfwAIRcZtErJ8me/Bk1SH0E/MshsZS7wTOz9uLMUMqI+RrOYyB6ojuitk0RBAANqJATymw8uMwgYdloRVhlpAlbnKCu7xvwTqxYSnVNANDvJ/EhtAKqBWqE95NdOkQZiG1VM9hPWWmt2QD75RAmIVDxByOOxPXAZjPxjAQSnqPa3jUNa78jvn0hFrB1WxzKURq144urlbje33J0NOufTnZzK1pyapz1ORuvl1F/vhanmwzxsIDPOlbmzfLPhlOHu0hmaEm4iiiRRFJG6lrcYkulG53E8A4PfcUm7kth/2GtJdkAxKx/FTr7cG3zqopJ1VgeOMbMFDPU/1nP5lirdF4JxYO92KGvRDoNvuqdeqWHS2k5pv3Co8R21mbm21M1ayn3E9FgeWDnquiWSYXI5P5cJX4wbEv/jLCJ8IyPIAaWoGlB6XVNsrlhR2nwkUHJ/hEVBgwxbbervKgTM0OID5MMJWFz98qED4QEXkbHlgXtPbMhOXjuXhjclWXu5dvo4EDOOtztFNp8cCjHgLM9tsPLHkHb9kikkmu4xlqJCtD3rauOrl8PH/63loiXuxXjq56/BbxFY0qfLXDPFEUX65HK
 BEcMwRxf
 5TG80rZN4wzId+osk3xBae/ssmkSzOiVbxShA9vKlpQyM+L2k8Lc/hPfydXsA/jc8RGqsTiH+pURwZ5IkXlYLsiJ1niYdpNkCmA+bUee1SdKIBIQWGC8vtH1zVo40nbmN2XlIK0WcwxTILJUoCSHgtLPjVf3nFIajw3zmV2FWHhMRsk9NptKPh/F+Jr2Jx+AS6sD5uJN2/IaIi0fn6PR3EkXeKV2smqLWF2fnQuq3qilthXrx/rKwCphov9v0e+DDKVsjtsQ6HB703o8wp7ySjN8Ik4BdGkrbSYbicdVRYbufc5NyODggv5SDVCnV7RAeJHGfFtSF4HxGwA21to6AciG46Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 8, 2026 at 4:14=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Fri, Nov 06, 2026 at 10:35:01PM +0800, Huacai Chen wrote:
> > On Fri, Nov 6, 2026 at 12:07=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> > > > Hi, Mike,
> > > >
> > > > On Thu, Nov 5, 2026 at 8:57=E2=80=AFPM Mike Rapoport <rppt@kernel.o=
rg> wrote:
> > > > >
> > > > > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > > > > From: George Guo <guodongtai@kylinos.cn>
> > > > > >
> > > > > > LoongArch never calls memblock_allow_resize(), so the reserved =
region
> > > > > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > > > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> > > > >
> > > > > This might be something to fix independent of KHO.
> > > > >
> > > > > Huacai,
> > > > >
> > > > > What's the reason LoongArch never enables memblock resizing and w=
hy it
> > > > > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> > > > At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we g=
ot
> > > > boot failures on a 128-cores machine, so define it, and the value i=
s
> > > > similar to arm64.
> > >
> > > AFAIR, arm64 had to reserve some per cpu data before they could enabl=
e
> > > memblock resizing, so they had to make it static.
> > LoongArch is similar, so below 64-cores machine has no problem.
> >
> > >
> > > > The reason LoongArch never enables memblock resizing is because the=
 mm
> > > > code is derived from MIPS, and MIPS never enables it.
> > >
> > > If that's the only reason, you might want to revisit that :)
> > Yes, it seems we need memblock_allow_resize(), but maybe it is better
> > to bring back paging_init()? Most other archs call
> > memblock_allow_resize() in paging_init().
>
> paging_init() is a historical relict that hugely misnamed everywhere :)
>
> I think platform_init() should be fine.
If paging_init() is unnecessary, then arch_mem_init() is better than
platform_init(), at least the name is better.

Huacai

>
> As far as I can tell, by the time platform_init() calls init_numa_memory(=
),
> all memory reservations that must happen before any memblock allocations
> are done.
>
> > Huacai
>
> --
> Sincerely yours,
> Mike.

