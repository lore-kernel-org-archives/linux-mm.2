Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A204FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D196B008A; Tue, 28 Apr 2026 06:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD2B6B008C; Tue, 28 Apr 2026 06:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A306B0092; Tue, 28 Apr 2026 06:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86E506B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:06:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4374CC19F6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:08 +0000 (UTC)
X-FDA: 84707534016.08.80A890F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D9F61C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJzDj8L5;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cm2CCUK9Vy1tdhvoAXUcIuQ7lza4eisQbA2cYHF9+hM=;
	b=JMqAzs/Gd/EIey0+S/WTiVKg3Ct+D5tauxORjFka4hj7eEX42mFqHMq7UGpvK8+awhDI5P
	M8upJg4/BE4DmJaElznnp1GffSp3/RGrwdzoPi33JwFBb7pyFInRegQwJzmbDxm/Vgv1pX
	+WbaxqZpFjaxBbmKsD/xTUP4vjUJfvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJzDj8L5;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370766; a=rsa-sha256;
	cv=none;
	b=mLqQSZ6HHmUSGTka+s0bAlbdeGS5+04DmYKSkmsYcyUI8O+9QIHSbgm1gbLQ/lWqa4zLFg
	kmhDh5nxgQXe0ygYEGb520qEGOLrMoemavRFx1NrQt6b3Lg8mjF5fd5DV/rhgHF9JIIS2e
	GxSseoS12Ff2/UXsU023AC8EguaKnh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00D8744965
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA248C2BCFB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777370764;
	bh=cm2CCUK9Vy1tdhvoAXUcIuQ7lza4eisQbA2cYHF9+hM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mJzDj8L5BSAAysJ71f0nJHzksqR0AW+KYoQLRM5iwA96n+RBCHZxCCOQsbWt6lD95
	 Ys5WxLME4zyiMQEcEIH4RkkWQKHm0bMjknkoytSYHKzhR/Mz/6dTjF2blQE1GFQ/Z3
	 uSxSFPu7r3ciCOwao5tiEizf239lqXFpAjfQzyNzIBWQlrWUfVJyhuvTFkiM4WqqsE
	 LC/4PxzUyaDrArS3DAzvSAFPC08w5Pn7Q3aGGsLlTRC14b9fB0ooBwHNrkJr3KCwQz
	 WSz2EgjgNX/2LsACp7Ks80nehKVI1eMcRUNz0ctasDDvBgV0+vt/cBZC1ZdMQZMvG2
	 2J6mCZt0WA4HQ==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8eae9229110so1511394885a.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:06:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Tsz1T39oNAIQr1H+QhoPuvlr9rcvRYD2Qg4Ehj5Rf7QWWuHgz31ZLRc2c3POZcUkS8n7Zz5zGYw==@kvack.org
X-Gm-Message-State: AOJu0YxiN1q6DVkrTFQgQ9QqVXcoPXpUjpJ9blTWb2KuJBn6rTWOT6VY
	z8U7PlpT2f6TiUBbH4Jl8YZtQVbIug79s8MIBzDgo6kGHFwFNxRjVD89t1o1Px8Hv/QOyUWBN1W
	ce63GmufL1UfWlY7POCvJtmEtVcU5VcE=
X-Received: by 2002:a05:620a:2808:b0:8ed:e1d4:1644 with SMTP id
 af79cd13be357-8f7d6c49f3bmr289925985a.3.1777370764070; Tue, 28 Apr 2026
 03:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260423034917.8234-1-baohua@kernel.org> <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
 <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com> <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org>
In-Reply-To: <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Apr 2026 18:05:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
X-Gm-Features: AVHnY4IwxVYPFGGD97fFpKRbwZhRzR1g23i1gWoOd9B3I-Zb9WvjfNOjUuwrW1U
Message-ID: <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D9F61C0010
X-Rspam-User: 
X-Stat-Signature: raxdtgzrptw5r9n6pdgjqoiegwarnikw
X-HE-Tag: 1777370765-377125
X-HE-Meta: U2FsdGVkX18ovnSPllEvPDqiMdZeOJm5jCeZvtKTMlPbZy9PrmePlmMPgmzwXStqcRUE9Qsb+oTVaI5gtmO3YeweL9h6Tx34+cWMLrh1i3rKlZQfwkvpsn3WC4pxoHXHt9xMw5+nDCk3nLx/NV/1nKOQdwdZWpPQGSv4+iBP6l4iijybPkhtXKVLurOBSxW/t740ree5Yg5tD6vGqJ/cAOi3o96C9CncGxvKld3/KwHLbZT15CGb7DmEsqs3i+0QJyN3fySHIosxrYyIJhJe0R8XiNGJV/RBuutSlcnFIyoatV5Vs3iUIPB3FVlHoRjpEx8eXIGaGPlmvMPfOEsy/1od2JUXxCTWaGnxOU576mLV2WXmpch+w/gFKft+ZMqLmqWOqUZqdDnbgW8xdbMco7wX0dDrtgBI2391PVqcvbaWlOYeLNbbxkcaR0FwJwTYVpvzuKaQiyIWJUdkQIxlZsFN/uvE4rxa5ZC8/LX3bGkQJOEoHO1fjyV4GZbxXtGjvZMQgKjUQUBEjy4um43JKai0W42znGAljbZ35TE8dJJgmYkW1VSjGsvjTjcxFpRR/jO20Cdg9LqvX91BszqzEw23qDYYVKiwoIidAhwZY15XoXAGklgILQyuGnJOg3coJJt+L9yP9gFs+ZHFmMdMYF84VNznC1BD5dusmoDxUJ7Qs+2zqowkcv5tjdGG4xS5DhldQtQGYQjgphrGAbEku2ysindzRKz2wivrGdfOLci2l//kP1UEmbkVpksvBNJCoSrbW7qGxg8srrAhRJdRhot3s+KwkFF3HV9Dc5gDVGsvdmnzw2tmoPEI9nXEs9bf0l8qWCl4GCA2+angjV4B4ojL2qYQ067sBBhrODnUz8Umhm4z6pxzWImD+/kXuGHvcNWDCMArgNOEZEflp8hc/Mf2O0XwoG9oD+fAOev8euI2EbOXeCWfY2calAoCNteaFJJLzmI1qGDIIlJafsk
 Akbqx0Yr
 h5q88Fiej30luvSMMrQR4nVh9okT63sD4yp951c1CNAwJ2LcxAIw3rQTm6LsaYw8hV+aNsADGF+cjMqNMweB/OVhSjSe8ZWvIn8hX4WL0ZFV5xQYruaudNqOjL1gw1LvW9+iWX7DhUWH3RE0CQCS4DF90OY9HAyqxFC16Jdk/M1xC/9aV2j+Iu+gzx/eZS95w/ZvKtTVx0FG0Im3gRAyNXulwySoou8dmdv066310q1Xmerl1sCukEXKoWblSdyGyJYc6iHW0P/2q6k2PemFif0qiVBMsdp7wka9+qR2yTOd6I/ED7woRZ9FMfye0kH+U6AuGJBzwjJT7lNAc7m063qss1mKoZNipx07A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 3:42=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/26/26 22:42, Barry Song wrote:
> > On Thu, Apr 23, 2026 at 8:36=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 4/23/26 05:49, Barry Song (Xiaomi) wrote:
> >>> The comment appears to be outdated. First, add_to_swap() no longer
> >>> exists after Kairui=E2=80=99s commit b487a2da3575 ("mm, swap: simplif=
y folio
> >>> swap allocation"). Second, partially zapped folios are now always
> >>> split before folio_alloc_swap() to avoid extra I/O, following Ryan=E2=
=80=99s
> >>> commit 5ed890ce5147 ("mm: vmscan: avoid split during
> >>> shrink_folio_list()").
> >>
> >> Not necessarily. We have some scenarios where we have partially-mapped=
 folios
> >> not detected as such as of today (with CONFIG_NO_PAGE_MAPCOUNT).
> >
> > Thanks, david! would it make more sense to add =E2=80=9Cwhen
> > CONFIG_PAGE_MAPCOUNT is enabled=E2=80=9D at the end of the
> > sentence?
>
> Better to phrase it in a way that doesn't even require these details :)
>
> Do we even need this detail in the patch description?

What about:

The comment appears to be outdated. add_to_swap() no longer exists,
and the explanation of why we need to call put_page() after
splitting could be made more general.

Best Regards
Barry

