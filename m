Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92417E88D74
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 07:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56226B0005; Sat,  4 Apr 2026 03:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DF16B0089; Sat,  4 Apr 2026 03:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B446B6B008A; Sat,  4 Apr 2026 03:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A39186B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:37:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 401D2E1EF5
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:37:12 +0000 (UTC)
X-FDA: 84620067504.09.7A6024D
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7B5E140006
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:37:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J33Tenz/";
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775288230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nWmxlFNX2J4GFdZGRIfE23zfRXOguYRhAS78blu2KA=;
	b=WcgARgjcUTFGto1Plg96EaMnpAztTlBZ5YvAptpm85mhTFd0GZfLKRZo3lE5FpFURrHwdK
	W+Ksof4hfCbRflpz0J73XkEoe4sRM/Qr4EiEVE//b7uXf0H+EpO5t4Cd0XgchCrIbixqV8
	4Xi0rBoS7EioJIVPNKtSN6a8fG/Ymb0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J33Tenz/";
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775288230; a=rsa-sha256;
	cv=none;
	b=Dietqs/6cUYHPs7/Kt+AeX8OGwR6jxdiOrKWzm4jmU3fMYNuByGBBfPSnp0LwTZsPkFLrr
	5qGc75w4vDfNHAVAXTIez1FgnbRFzEsKd5+48W3e3bbx6nYZVNm7OjtXkMdkflwR2M/jcA
	OO+j8hmikwAWzpJejljERyOYL9zOuKQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775288226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nWmxlFNX2J4GFdZGRIfE23zfRXOguYRhAS78blu2KA=;
	b=J33Tenz/ujh68w+9y9GSofFFuNbYRuCJy01kusKKlEkABY5ljUk6uvJbKYDHMmHBIJOXFT
	UXtt8AucZB5bfd/OfHI0wkfWil+HoheGoWkV+iMawWx8h6mRgQdLXNbMYzhRG4ENO3ICHP
	3j2bY5ABGkDxRJU5fjDVh4NEdUHMPd4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 0/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd()
 and vmemmap_check_pmd()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260404071720.3577290-1-songmuchun@bytedance.com>
Date: Sat, 4 Apr 2026 15:35:52 +0800
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 Yuquan Wang <wangyuquan1236@phytium.com.cn>,
 Petr Tesarik <ptesarik@suse.com>,
 Austin Kim <austin.kim@lge.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 Junhui Liu <junhui.liu@pigmoral.tech>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alex Shi <alexs@kernel.org>,
 Chengkaitao <chengkaitao@kylinos.cn>,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org,
 sparclinux@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2CFBEBBC-5273-48E9-9E5F-1F4599194050@linux.dev>
References: <20260404071720.3577290-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A7B5E140006
X-Stat-Signature: ysayqema8fkki4r3o6mcc3r3ipuaac8p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775288228-332377
X-HE-Meta: U2FsdGVkX1/9S6jp7geyPLgpeoaLGLx6Yb9FFiuUwCE/B2Yv1RWPWVXHWQnCkb/ZfssjSCeu+VmO/TMzO37xN9KUvtE1IfNqmTx6qT47EAAYwZww/cNyFl1ue1P2r/YeuSH82E7DLnOENe1nKQhas1QxexWSSmt6ADl41x/5Ledej+aSLI8x4ibQLjb490btYP9e4EqoAnsdCfou3V1wUN6r1g0V86/XILHTwrg7EuJ+zyDkDiw5YgFt4dKnuwToBKGWUj5u58dIWZk6YS4F/uwb85YRMjogzz+oRyFBuz/Rniq7ntLoIG5r/vFh1DJVekShGRd7KBHiLB9NAJShGEtMNHDC/DBLlf+tO5pP79gDQOxj7dOHkVxTZqWFzN7A+E46FZnFIsINPLxxYnUUUgnIMp5rx4Tq/j0UkKuvLANITzitYEDkkEOK52aBv5E9vJMLtfrdo2Hw8xAzciFV0+9DIv5R/zykeyZ9T21Dz2kYBA6RtWgNMy2gwNzOQQNF5m8J8H78eNdyUDqeu5nGxRPkY9jmbj+W6Pe/Pz86qTFQzhFcXibDi0Nfi0orgpfyh+qRuw7pofJQdpNLy14eqw+ZPavzz6TeFybOvOs82h1gRvjI60g+TtCmf/BcCum8h47FYrYYjO8qsnCVzkmgx0Jks+VP3UEpxfXrZZTbPTEdX/d3srwmLUzX+n7OMASfGLrl3LDHAesZ3H/e+9N9GvROsg65hkOGoyyhsBRbwyM9ITBBRCqoRg3u39XNvPqT6l4l2x1RnJhDH9c7rEiBV3t1iKsIgOOg2oS9pTV8t2rP1QCiaMRAu7eMDu8HjyUSsgH25hvalAvM0ui+Osew7AtMvwcsm3Abn/5v54/ad49nw2pBLU6d5W4EYUP99QnYqNOnG9tFefG9Kaj4WqovMUGqAXsMu1eMZQ8m5gvi/RrL8ZIdiBV2w8VFMnbUqYUjy+XWJy0buW2AFXsUzAx
 9dq3DlAo
 +EfDxPdl6xXCRO5pwwsZp5IHJ0sx2wluQ6zoyu6uOI/8cuKw5NdJTXQWI9sOZOgKNzM8QfTlgUg0FBXXEz/ZYjNn1e1RyHVYp0GOdGMiqXvJOLI/8xEA1rlyW7lK9nPB/l3n1rJDPA9mx/4uW1xyWOPFJk0yc9PqcJaAyJjnPhVdmeKwuz5VXSsTODq5K6YHKgUDQxp8iUdf6rZyHZ100YlRx36eGMXuXue9Y1p0mYxViJW3y90WOTViEp7TsRh4VPNmpT1tb/ztYNKqFNj+xg2SG1ZIY62pmX3IiVpxoganbxbBZj5gUgmG2c7TID4Vh4VsLUuSwnD6iqfvaFNstEm26YgZjLewO5Vfa7T7Y8rLvTVN8h8LGN+vUKN5D/fZAMxfh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  =20
> On Apr 4, 2026, at 15:17, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> The two weak functions vmemmap_set_pmd() and vmemmap_check_pmd() are
> currently no-ops on every architecture, forcing each platform that =
needs
> them to duplicate the same handful of lines. Provide a generic =
implementation:
>=20
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL =
protection.
>=20
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>  then calls the existing vmemmap_verify() helper.
>=20
> Architectures that need special handling can continue to override the
> weak symbols; everyone else gets the standard version for free.
>=20
> This series drops the custom implementations in arm64, riscv, =
loongarch,
> and sparc, replacing them with the generic implementation introduced
> in the first patch.
>=20
> Muchun Song (5):
>  mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and
>    vmemmap_check_pmd()
>  arm64/mm: drop vmemmap_pmd helpers and use generic code
>  riscv/mm: drop vmemmap_pmd helpers and use generic code
>  loongarch/mm: drop vmemmap_check_pmd helper and use generic code
>  sparc/mm: drop vmemmap_check_pmd helper and use generic code

Hi all,

Please accept my sincere apologies for the mailing list noise.

Due to an error in my local scripts (failing to clean up the patch
output directory before regenerating the series with an updated commit
range), multiple duplicate and conflicting patches were accidentally
sent to the list simultaneously (10 patches in total instead of the
intended 5).

Sorry again for the inconvenience.

Thanks,
Muchun=20

>=20
> arch/arm64/mm/mmu.c      | 14 --------------
> arch/loongarch/mm/init.c | 11 -----------
> arch/riscv/mm/init.c     | 13 -------------
> arch/sparc/mm/init_64.c  | 11 -----------
> mm/sparse-vmemmap.c      |  7 ++++++-
> 5 files changed, 6 insertions(+), 50 deletions(-)
>=20
> --=20
> 2.20.1
>=20


