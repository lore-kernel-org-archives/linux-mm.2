Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAE1EFB7E1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17806B008A; Mon, 23 Feb 2026 21:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEBF6B008C; Mon, 23 Feb 2026 21:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7A16B0092; Mon, 23 Feb 2026 21:39:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD6466B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:39:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CAA81603FD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:39:45 +0000 (UTC)
X-FDA: 84477794730.09.E734826
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id E39F240009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:39:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="gi542/F4";
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771900783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAYOHuNWQcJjW8QWbfDChldfD3kGn4KOZM9BL41wwa0=;
	b=mgZ7yQsiI1vC2og7W5dYwxW8GuK1l7xrRcJITB2oXhiVLjfY1KTRRsdvAMsE50ZahjfY6y
	I/WDejumLv8GX5hp7ejHfYF42Sb+kTYMitpMbOOwAYSasnzqzCFkUnxNAP3m3hdV+sEkAb
	Jo/Uqi6LeBvL1dTiI9xXvKB1X/OkBO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771900783; a=rsa-sha256;
	cv=none;
	b=e8dUTtKqGIEHI9jh02e1nF9551Wuix5/87/JkA64tiCFnH4zsSC4k/BAfi6mJEb2stK7Ss
	qb46Xypu8iR1dKrChVaQvyOSrNl9NZBQT9fBQwBxgngmAvGwQ1pmIMPm31BV7Mud+5WIbk
	MP7yWB8OU5IryRQBbbAEgbm9xMRTQ/Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="gi542/F4";
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pAYOHuNWQcJjW8QWbfDChldfD3kGn4KOZM9BL41wwa0=; b=gi542/F4jj60Bhoqxv/W7avl1o
	EFbf2EZddQ8rkSOux7kxVSLN5ExsG+mpIAOm+clzibP9tRE5knUYLMf9EnaYiOZPXz86gqdSKmPPy
	s+MLB/Inj90OlbquOFbpjEYQKgWyHtvGPkU4tlGryvUp/bRgideMqExjhgtglAwAiKHOeOlzPyTbr
	+Pqpq10pWU1CnX4uAwmE9a5Y6ACrVb6Uj0sEVN+c9GWbH6rrv4JDo5W37RwFck1IktMzO+keaST3w
	+8SxGe76KqhGee43F2B4CSQXQFN03fMV5Qfb2ZL4P8gS2fhbmrsWQpB1SU0N6lIcISWdt5JLuOZTv
	eZO1s8fA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vuiK8-000000000dq-0e8p;
	Mon, 23 Feb 2026 21:38:57 -0500
Message-ID: <b3c1c739c233ccb32945ccaffdaf25fd3f96dd59.camel@surriel.com>
Subject: Re: [PATCH 2/5] mm: rmap: add a ZONE_DEVICE folio warning in
 folio_referenced()
From: Rik van Riel <riel@surriel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, 	surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, 	willy@infradead.org, baohua@kernel.org,
 dev.jain@arm.com, axelrasmussen@google.com, 	yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, 	zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Feb 2026 21:38:57 -0500
In-Reply-To: <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
	 <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 96tirgu5cxr6px3upp8ecr3dn7cgs4np
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E39F240009
X-HE-Tag: 1771900783-333987
X-HE-Meta: U2FsdGVkX18xPmjSZ11N7+bnrrAm/AJrCgxqghnQ8rRYNF+mjDBZVrYQAfdzQh7bNVnMyZdS7DyU78NmS2LhnSVhWa4m7T9iOIrhCC9SZ0KFHaMo8mzN8FgAwFPBR7R6zGOReJLz30+EGHrVKfCN2/ldPcrf5UJTmSABpEsYmRFM7s9//CKvrPeUgSduC0qnCAKfN3PRrqlhKYQfw+0sdz5Oofo0g4/x+3RAWjhkVTN15ZqRXL9ha5vilcfyhqQkIy2DBc+sofoAbWgbr21ErnuVZtzI4xHu8HEAgO7MrtW8VuXBb5/Oj+UBRRgUEb+No7x2x2YEn50hweGxEuSJZcCsHE3tBEQBATMG9OOrAgxjeOe77KiZi61YVMiFQpd4T0ESwAGz9X0kMqEU3fmbPshEakXpMEysyIaCJ/BvNNrHtCmBPlQEOlq/O3HASFP7DEXMFwLsEpxbi3wWIovCGyI03JORCGfL1Wg2D+by7/sUz4K+yJY2IGhBI9ntmduURQOLlqI+F9yjqortnRqNx/qkTbzdF3XSh8pqWRaAgC8O/Z4shoS/HSnv5HxqO9H8wMQFGHfb1GOrrM7/twoOeqJtrSSXh5UDME8dk8AumD6U1s4b31bflWQQmyAumbSpaNXB785YOrZ8j+BRmQ8Q7dIIIvWwAmD0yvSgkZF6DIMB5bBWdVrEw8Dq240aA7wYe7+LcnvS9yr73Rfk1vqtdZx42D3Pz6NXUglLef5Tls4DCT82mLC02PuIXj2do/WyGa6EPPGfv3hWHwJ+FEDHLsYHOATz9sBQkm7BLV7LOBGAtP7C7XD4CUVcB+kMdmrA7wOmXhDc21WWKfCSclp3xIz9aA48Yu2nyKezxr4iDYInV7559qhdApcVBh3PFkRWMQbljCg28/7gJfXGPxpwasRzJ5NB6yvngXToKWRcsU/sqe5vyjTV64ms/mELU4HE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
>=20
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e..be785dfc9336 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int
> is_locked,
> =C2=A0		.invalid_vma =3D invalid_folio_referenced_vma,
> =C2=A0	};
> =C2=A0
> +	VM_WARN_ON_FOLIO(folio_is_zone_device(folio), folio);
> =C2=A0	*vm_flags =3D 0;
> =C2=A0	if (!pra.mapcount)
> =C2=A0		return 0;

Should be a VM_WARN_ON_ONCE_FOLIO so we do not cause
a softlockup if we try to print information about a
million ZONE_DEVICE pages?

--=20
All Rights Reversed.

