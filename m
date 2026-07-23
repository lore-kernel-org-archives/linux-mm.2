Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0288DC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04FA6B0092; Thu, 23 Jul 2026 10:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6D36B0093; Thu, 23 Jul 2026 10:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E706B0095; Thu, 23 Jul 2026 10:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4F06B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:23:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FD461604CC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:23:42 +0000 (UTC)
X-FDA: 85020259884.15.A3F7997
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6EA89180002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:23:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=nM2EReCD;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784816620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raiZlCjLYoxwWdZZtszlEGRShmj11jqdgovnWEaS/WQ=;
	b=3M+PNKkj0oYw9H4TGoqs0JlX2HaZ3C5Rqpt+v3tmTqTCyaCRYQcYVsOQzqfVnw858l5E17
	0RN7QYaXHfy5JPxrbjcC4fNLyaIHfL7D5ofimjiT8pWI0EJvDPObaD7UNAGD3ipWk0AU6K
	RrlFUt2WIZHhtdOZSlLR7usiNLcHavU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784816620;
	b=lvvOLXfj5FQ5uaD0eKD58ELB9u4lB2G72aN7slvZLE6Nj2LJyk5ndSPRsAeSCQ9vYjuylf
	SWM2HFT4XBSqv1hyAIY3ckQi7Nj5Ic44P8FrCitUFXAx6jm5tj7CXtIBwuqd6+jNioGi8C
	KD9kr+utGvC6PEotcA6f98J73fD17XE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=nM2EReCD;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=raiZlCjLYoxwWdZZtszlEGRShmj11jqdgovnWEaS/WQ=; b=nM2EReCDBV+IOIf8cpmGoorWGW
	13jC5JXQgpYpx1e7+EgQ+2PndqTSEXbmS+qmcFIP83nHpvBYfh0/1TPT0S5862I59Fp4cK0QRak3N
	keO8AYen2fcVKWozOu2iqECeDVgw8N5B4SMhRm4FvdJPnKk+gorI4W3XCnt3LcgSI+1l5LXIXRdYH
	Dwxp1UY/wjocKYhYfOCt7b/vGBsFBknNH51oucAyB1gARF0OTmyrHT7cF2UbgWvwkIed5Qsqn01OV
	98BWcuqmR5WoxZrWFe1W8qZoGxfa9xukx0Q7zYxNA6+Qp1Rj2RTtkHGcWZhrv1RcIGZpBKdrg8TUM
	ZaP36zVg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wmuKf-0000000079L-3g6A;
	Thu, 23 Jul 2026 10:23:29 -0400
Message-ID: <4439df28abd5150ac587b6a27ae51fb78bf8d340.camel@surriel.com>
Subject: Re: [PATCH v2] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
From: Rik van Riel <riel@surriel.com>
To: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org
Cc: Breno Leitao <leitao@debian.org>, muchun.song@linux.dev
Date: Thu, 23 Jul 2026 10:23:29 -0400
In-Reply-To: <amH3AeO-PeAQoc34@bender.morinfr.org>
References: <amH3AeO-PeAQoc34@bender.morinfr.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6EA89180002
X-Stat-Signature: tsa16gx6wy64nefor5665f9c9bn537g6
X-Rspam-User: 
X-HE-Tag: 1784816620-186861
X-HE-Meta: U2FsdGVkX19A9CqCe4rK3je51s5QK8P3z+HxmLsa5abh0IESnNmZhUzit0A91t6g5QjSY4Vy8GtnxLCkjxemy5fGX53+Oy7UFVPVuvhtznP8+D9GCN/L2OAOUA9h2auDny//zwW41p6D1n8yIyhYtT0hSN/CtejP9QewoLgYCh7PZdyz3PH1XFbdzVpDNAEJN718noK+QwcbJyZYfIskuqgTQF8bsdl6ILVrM5GzUcRx5EhCAEw/KUPUHtznOyCvpvAvtLmJsVX5XQh0813bXzdUVwhgFu0yczW45LjxpxabQG/t8r7Aww4Xo8wrjnVfJbiftr0TEKdzpOH6aMvhzs0rNlyDdR7YM68tYaQo9ITcw9UE68mBFWPYWptWNtbNZ/hXOXt2sDea8rzdd+P05lnqSyCnngzFx9CU4YXzMUUdHt/C2h6KNWLp5CXenmutcX3IT6U1gUwTF++SzQQrz7oh1i+yDkHkUe5CsCAuLBUpPV3DsVnVtzHd5ygoioIA07QJpsXmhAdbhYuOmIVSo9tGwxfuAsq0T/ta224qHjXnrmBzKjAvwpkbcYD8v95qUwlPtOjrb8khji1oaSxiPnXJOYbpFSZSIyUJbLAR2JG9nPoctBB49V7xZ1RucTAgo/TfE5E3COH+c26dpZBX3JUlhQtjT4HDNE6F0IPltgTATYQYIr2vEXxzRTcAXj2lNXlIWeAonhYWM7u6E5zjnKuqEmlwtKH57VHK00A92JxVzqjENuCTJ4eP6ZJoKi/UGY86tjaToiuZzHaGoXnP/2vyiRx6jHm5WY5RuRWo27C9efJr+qTSN8SJZB8GZ09Ig6XpHmEzUB+5wS4FQVrKr7ULJvgdm5DWNLgKnhXN5bX4GgoOpF4hXe/8vS/pOxKX/8OKon8PC8x4nIaba8uVdPg31PkEOTqbC4iM3SsYqlTPUpJ2IKocPgqt1ey39pyqS1m+PMO+QvD164oUGnI
 ggFqLAAe
 /I+1GcBYwpFRZv2beHNfBvZmbiixX9PQup1pRGg9ldjh2+n3WP2q9xMCvRN+58Qat5N+EFXJT0vD/q6m7mLzz9s3/11N+NGYyU+VQB5Ef+ZvfusU99SO7NcNsSnCxURhEQqpxZgAqtp+G1E7oBNeSlx3qrMalZsmtdVFQVbEpJkX7PrOUzLbdD5NxbNkCHNNX1hTz/Gq2gd4pnWitCM/tMI59oaBAt9B1KcBu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-07-23 at 13:12 +0200, Guillaume Morin wrote:
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..3feeac0f8eca 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
>=20
> @@ -5252,7 +5254,7 @@ void __unmap_hugepage_range(struct mmu_gather
> *tlb, struct vm_area_struct *vma,
> =C2=A0
> =C2=A0		spin_lock_irq(&hugetlb_lock);
> =C2=A0		if (!h->surplus_huge_pages &&
> __vma_private_lock(vma) &&
> -		=C2=A0=C2=A0=C2=A0 folio_test_anon(folio)) {
> +		=C2=A0=C2=A0=C2=A0 folio_mapcount(folio) =3D=3D 0 &&
> folio_test_anon(folio)) {
> =C2=A0			folio_set_hugetlb_restore_reserve(folio);
> =C2=A0			/* Reservation to be adjusted after the spin
> lock */
> =C2=A0			adjust_reservation =3D true;

The safety of this seems to depend on the caller of
__unmap_hugepage_range() holding i_mmap_lock_write(mapping)

Could you document that with a quick comment above this
block, and also add a lockdep_assert to the start of
__unmap_hugepage_range() to make sure that the mapping=C2=A0
is indeed locked for write?

This seems like a fairly fragile area, and the locking
requirements should not be left undocumented.

--=20
All Rights Reversed.

