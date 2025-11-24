Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A62CFD340
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EEA6B0012; Mon, 24 Nov 2025 12:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF806B0022; Mon, 24 Nov 2025 12:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEA56B0023; Mon, 24 Nov 2025 12:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5D396B0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:43:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69659C04E9
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:43:40 +0000 (UTC)
X-FDA: 84146223000.19.ABA5DAA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id AED55C0015
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:43:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=PYZq+3N6;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764006218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/I9K/FvlzwwzFcfXNsTEhQVXUvQTpjTeN/OkRnIVAw=;
	b=PMWRZ/fRWJQs23JZLChBZkGx519Xcgxw8qlxBsyQkZHhZHIwktgqpVDfMSZEhpd0my/N2S
	08GzWh1SHZRulkN46JmqljJSgGQMW3PoZYDzPj1x5R+LShrrsw6uIqmGkhQZD71OEMoPGP
	MZUDxAEZ23tVf1FTfbV9/6bkyVOX+6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764006218; a=rsa-sha256;
	cv=none;
	b=Ob3e2RfLiPaYhLRa97sg15V+OKok49TwhFEkeThgU6SacVIK7HUY+rDQ/Ge/MJ6KvpdSCR
	nOsoo4RC7DqJ+6y0caAEZ3Es6LsdrI+yqG+6PcdntZVJ4xsmYUlR+vIy/Dlw319pMcisEc
	13Pxu1hEjcGzGHEf1/4YPPtENErUfvY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=PYZq+3N6;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z/I9K/FvlzwwzFcfXNsTEhQVXUvQTpjTeN/OkRnIVAw=; b=PYZq+3N6tjX6NJWqEaPcfN5Cla
	j/JkOMprSa5JJaRiwiz8QoEfuB0KROt1C7m8FS/MP+tTkk9Ku2QPVCnPhIcWCAA2fJk85EbV7wFtL
	t4uXLDQTLYRtKoZa4cx5DOidMqSWu7ad4ohBB3eIyqVH0pHFJ5qnPnAV4rIt79QaevKsuWYilL5nd
	W6XT5sVzpdM+NcJgvhKgw+1ZbHTubi8DBBmBQO6vleE/GoaY8d2OOT/4E6vLPE+CoIF/LB1CuGIxF
	zxwPxoEFA3E9eX66HEgP8Rvv4MADC+XXy3e0D0JDzcaj+7IICesW5SZrpS1P2ElBvbszcgw6Dm/jl
	ZWrMJXwQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vNaaH-000000003Bs-2utf;
	Mon, 24 Nov 2025 12:42:42 -0500
Message-ID: <86fa3bc129bbd0e0da9d118ca6441e34a389fd2b.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed
	 <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pratmal@google.com, 
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Date: Mon, 24 Nov 2025 12:42:42 -0500
In-Reply-To: <CACePvbUMAi-v0Xmw8-GCiYuP=smmtxeVQ3VS5S4mWcVirDGPSw@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
	 <340fd55d9d7d9436f18205bb458e9bd469b36c6c.camel@surriel.com>
	 <CACePvbUMAi-v0Xmw8-GCiYuP=smmtxeVQ3VS5S4mWcVirDGPSw@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AED55C0015
X-Stat-Signature: ury4oei9terr9zjzk9jtjtsaua3sbagy
X-Rspam-User: 
X-HE-Tag: 1764006218-199336
X-HE-Meta: U2FsdGVkX184ph5jDV/SnabH3BS2mAXDdDjN4YdGWd1Wl/MSzyrHPPSa0YrWE16kYlHB/aorUvXv/ccpGY4McUC/86daorgy+C8eFDJOrnIQc6impH+/AmzY6PAtq3Tds1zZm0Gf+Jt93U2xi+qTqOANUzJ6nc7IvSlb+ENlPJ0QbPjNGt8tuZa9amBDJFYOSsIx0Lg25p7kOtG+E+FHrveeTpOfXOg0jTjVvgH3inRWE24MDbyPiG1tiR3C7luJrgiZb425JrEobtToix1Ohl680AzLJVwUaHkW7dx0+XE2LCrF7bMmoWDsn8JGuohvRg8tdttpEjSqGlxnhdTZMe6kh3gworu2NwP7zwLMjW5f3mOpkE7hgISR0MEpm3A81x0qEzNItOKxni0SZljTiwgfjPLj51yiVTQa/T1GOR9eL1fZO9gHQS0YEXK8iUywNKB2oXdB2ZpuXeslNT+WauqVaaecVgxGiM76oLfYOlvo1+tYlKNVDIyyHivz/NA2clWVLA81CJU/R1cBskYEj6z7TA0oemZPmgJJdBctuh8TAi08cK/YCSCDpHs/E/O/bM4bDobiN512FdTnCVNp2vlLqLjARy34akdM50Sgp8IQ9NBXtpn5uytpLyTtbX+6FAfDX+hQx6SIgfBzqU3nFUgveL3A9FPF/3dM5OGBrjSvidrUgHNgGuDCXG5knvGMLUBeszriUkSwuIGC+957as4ZkjDz8pOxqQZnaSA6eJyNS1dUsd3V1x3+ssXqrlBUm28MPIAx/f+uhNBU7ncpSAVm++AcsNuR0ZwaGQTAHiaA8RQ2/CReCAubYANmdM2Y1ZmqwqYd/E2GUSKFmMz39FATyzDbdu3sw3dt/nn1vhv/CMCpRIDa0IgjtIj8VnbC5qHeGjsA2eCXEkdS+fDzIDmYf7Mv+SQjbmghiNyxhynm29sCfvp4jqgm6YDSWj3pzvMy61mER3JlToNJPwM
 zVFJcC27
 vw5zr3FrFp/x/gEjJWZBZxH8ZSaV04ibECcUuN659ctrB8fk9/M8ns8AAC/KQm3Eu5DXTx/BPr+AAmrhHiJRONuZlEFYNBTWy/xVCa2sv+b4hp1LdSgm005xyNmsGQLl6E1N0qpHz4IstM8WAGAOtdMJNWLHnzrl5TbCIIocfHZG3hJUFa+PquvHfMDsTH87DfZtyvIxOScsGf01As/04xil7mdmBnA8aLJfvsFGiVcVKpF03NcvnG0v4VyuQ+MvFVbInDIaQCnTxBDFNBMN9irEPaOs6BJXVSur5JvENQJ3sHWMLDv+APqAealSjIaI/30E0NNdJ7TXWIZaVW5iZAL8Lbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-11-24 at 20:26 +0300, Chris Li wrote:
> On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Fri, 2025-11-21 at 17:52 -0800, Chris Li wrote:
> > > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner
> > > <hannes@cmpxchg.org>
> > > wrote:
> > > >=20
> > > >=20
> > > > Zswap is primarily a compressed cache for real swap on
> > > > secondary
> > > > storage. It's indeed quite important that entries currently in
> > > > zswap
> > > > don't occupy disk slots; but for a solution to this to be
> > > > acceptable,
> > > > it has to work with the primary usecase and support disk
> > > > writeback.
> > >=20
> > > Well, my plan is to support the writeback via swap.tiers.
> > >=20
> > How would you do writeback from a zswap entry in
> > a ghost swapfile, to a real disk swap backend?
>=20
> Basically, each swap file has its own version swap
> ops->{read,write}_folio(). The mem swap tier is similar to the
> current
> zswap but it is memory only, there is no file backing and don't share
> swap entries with the real swapfile.
>=20
> When writing back from one swap entry to another swapfile, for the
> simple case of uncompressing the data, data will store to swap cache
> and write to another swapfile with allocated another swap entry. The
> front end of the swap cache will have the option map the front end
> swap entry offset to the back end block locations. At the memory
> price
> of 4 byte per swap entry.

Wait, so you use the swap cache radix tree to
indicate the physical location of data between
multiple swap devices?

Isn't that exactly what the vswap approach
does, too?

How is this different?

--=20
All Rights Reversed.

