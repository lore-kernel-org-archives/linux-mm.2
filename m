Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99482E63C82
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 04:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EE86B00B5; Sat, 24 Jan 2026 23:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C466B00B6; Sat, 24 Jan 2026 23:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58516B00B7; Sat, 24 Jan 2026 23:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91D446B00B5
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:03:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31CD91A015E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:03:34 +0000 (UTC)
X-FDA: 84369141948.12.9D9CB7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44077C0007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:03:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJslFK39;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769313812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tCFI7iXfi62K2wdlW62C/79w8m8oGv0lT1eed2oJUM=;
	b=wyqGJ6kCyETibf0b8LcFmUVoucFBPYSDcl82+cm8MO/H+kEeoiuqSXo1MB17qvR0aCKE3C
	zGjSM65SgOgUlSoq6vl82plE9uUrZC4flKYz7ywu4pw55VnXWoCJPGbJmdR+8BJ/wKdQgf
	OhNOfcN1Lh+axzXEHazYPFqhOhsAlA8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJslFK39;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769313812; a=rsa-sha256;
	cv=none;
	b=Uio0Mm6jPgDF5oZFdMSkrFTQmqVv1aXNohQrSBr8CsHptPsAIcKAVIl7XD6bT8Nys7aoLx
	bNV52yD8PM3ZOme7IY5pw2SFKz+Pt007R8s397njk1TdvJQwMBVWagiQcRwGM6CM62C2/O
	6QKz2nDwt1d2RNEkJfPltlLL6KcSdms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC5E84445F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B043CC2BCB9
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769313810;
	bh=TQaDh7lsKY8tFsjMYD7BTGjXonEHzONpf6q4U3MFS74=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OJslFK39224RKhla6bB5iSfRIwZLSwK0zH/qXmWbtyo7Rwl2geQRVpyApYumbBS6h
	 sjhFr3mnhaoAmtdJHFax59GRvvrchLOL5zShuJryRKCL7ySkkObMDssmrKVgXJ0myG
	 9+KPTkbQ+zbVxLp6U1PgZ4cIlPbpwYskoj24pHd0BCmt+XFOCGK4zvewGliNDbYFks
	 sRbjZITxoIwueQUFws89pfQSLNAOzlD1hFTDp2qOUxBfy/3/15PDeqQUPdqVY6xM1G
	 rqZFUV4MyTyaDUC9aaqickqMdGQrSNN7a8oRGSKbNsHFXNjkhd1URPdcrbjIDYYNsL
	 ivsA9SUzUuKCw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so6229262a12.1
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 20:03:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWyf6jR5QdfA2IpTHVP6Ey+s5lWoJ56We+IWrs4YWGtLNCekQ44ZkpGbbrglkX28oO1qPJo5tQUMA==@kvack.org
X-Gm-Message-State: AOJu0Yzo3OvBFBQPojSy+FaAm3C/ShvezbMmNcA2bLSm826jfHn3ray5
	LbfzCvKyywI/Islz68FH1GTPbCa5ortP/kso1G/b9aKK3EwgZ9/fVNECysqOwMhTFiyzXm1QVMu
	VvMHbYyagdMEzB005prBZULg1EJfkdkA=
X-Received: by 2002:a17:907:2d09:b0:b73:6f8c:6127 with SMTP id
 a640c23a62f3a-b8d3fa14150mr40755666b.12.1769313809089; Sat, 24 Jan 2026
 20:03:29 -0800 (PST)
MIME-Version: 1.0
References: <20260109051054.188030-1-fearyncess@aosc.io> <aWC6bIEg6UqvX1DO@kernel.org>
In-Reply-To: <aWC6bIEg6UqvX1DO@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 25 Jan 2026 12:03:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5tHZRHmXSA6m+fyhaN9nNjLFbEiVK7OWjL8EoJn16doQ@mail.gmail.com>
X-Gm-Features: AZwV_QgZtJU-wwFoOJ5ofNX243-l4sQGf8pk1EIiYklzuhdRgtqAyAoGEoSGyHo
Message-ID: <CAAhV-H5tHZRHmXSA6m+fyhaN9nNjLFbEiVK7OWjL8EoJn16doQ@mail.gmail.com>
Subject: Re: [PATCH] loongarch: wire up memfd_secret system call
To: Mike Rapoport <rppt@kernel.org>
Cc: Lain Fearyncess Yang <fearyncess@aosc.io>, WANG Xuerui <kernel@xen0n.name>, 
	Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 44077C0007
X-Stat-Signature: tmia4qsufi44fyextao1m7w6o1gd5s6b
X-Rspam-User: 
X-HE-Tag: 1769313812-88562
X-HE-Meta: U2FsdGVkX19VTVKUIFWVTY0k9KXAX6iaYFyAmC6JkBbgbzXpHSIrLlGTQryJbkDP1OMBEuRruLyfxe9Uf9MWXwWJGWyaou7yRU8/IYyN0bTVGNuJoUO1DNMNFwsZr46FF4a0+O1LJQxuA9aaBWBBGYJVqX/9cwKqLJFK4Tz2VriKKmDoemu9bjjoss3Q28aqqhWTuNSisIefB1rYWiXrUEznC5mb79zjlD+BLWI5Bm4eHXtTPLM/4RJaK2FmlXKUuW5lHpK0rksjiPi2Fgv3HSixxazO1KdNSLOJAK4MZ4qftjJRxdiZ4Z7PXUb2ww10DO8c8S6XriVrTH2Kr76+KZjBlvO6wLpvuuxjaQPdHD+odhI2/a+UG9FE0SMt3iMjDQtbADuzAqs9gqjE44JIVZti7egkXGzdkAeC/Pie46omPNVlaZhY9Ex4i8zNlx4NBK+8ggDvD4b0gTQH/EeFIA34fL3SBeAS7nTYCYVYWjG41H9ZLpQeAgbKSLX4PIDeqGiJaLvmbzFSafrrImhKDhe3CBJYcK563RdXZ0QNZKlsbacdC9EiGlkviqCfDYCjkVhJWJFg40IupIfgyzg13DpXNw9HFzjPWgCV7Xc0Qd0KnJy1q2CrHZIvE4HNJU6y8AXeIJFDO7QRKH1xQJqfboc2xL24JUihvWgOYRmr1PKAWXpcO1d1lXAdLMGAs9uFRqkHF9IRZj7REch30b7ExsAKTvYzA6WgDUlzbMu2vkijTtTNTQwAqCIc4z8WwbwvXZRqEwvw/9X7EwT3EmU3iYSuZ0AyzerX/8cysaqJhgRPMDZd354gHHog5mX0NlAnYzCYfWCrc5X1WK01ep04tLk9HVkgC3j/Uy1qiCdq2qJMuMEzOn3HsIUwcX0wPGXkbEFtVuuCHaG8Pl4Dz6rEuGahnxK4AYHp99pcux+wx5zb+UoOcHf33XqcOs3QkKmRVaPPwQ2VSrzm45XdXhK
 1nUpI4TL
 D7NdfdCLorFJ2QncM+KMKWHslQoscMDeuJ3oxdV+2FTxd3NFeDwtrD7dkJ02xXdk4aGO7vGWxMXDezcb7Z+qw/MTTP//8y753bPMJzR972NJ2UN8/60V8shlg7h5NG+Dsz9fQ3c9tWOSzhZ67tszGRWh1zeHuAB1oHFzk+ZQTaxqGOuJR/iXxq2MphcAr2f/D9KH09T7tCXDFGXwH/VqIYce9pG4NxE48S9hioWwCOmQxJUVEIhoSrMwyg5gvhdbB4l354lqmONRurg2+NXkR7B4NF4wDlfCkH2h/VVFw0ZVy8rZ2k4MvV+B9oyQUYWebGHTkX4PkmY+E1xgCWTcMjHGqwjjRq9gKd+VPtiMynObGgcGC42Rgs7JCe08yM18unMsBNFHTf7G60YI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 4:21=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Fri, Jan 09, 2026 at 01:10:51PM +0800, Lain Fearyncess Yang wrote:
> > From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>
> >
> > LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
> > memfd_secret system call, which depends on it.
>
> LoongArch version of set_memory* does not support splitting of leaf PMD
> entries. Does LoongArch always use PTE-level mappings in the direct map?
No PMD level mappings now.

Huacai
>
> > Signed-off-by: Lain "Fearyncess" Yang <fearyncess@aosc.io>
> > ---
> >  arch/loongarch/include/asm/unistd.h     | 1 +
> >  arch/loongarch/kernel/Makefile.syscalls | 6 +++---
> >  tools/testing/selftests/mm/Makefile     | 2 +-
> >  3 files changed, 5 insertions(+), 4 deletions(-)
>
> --
> Sincerely yours,
> Mike.

