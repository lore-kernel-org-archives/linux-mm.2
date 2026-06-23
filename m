Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4688CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 22:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC6F6B0088; Tue, 23 Jun 2026 18:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D346B008A; Tue, 23 Jun 2026 18:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DF56B008C; Tue, 23 Jun 2026 18:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406B06B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:24:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A578E401A0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:23:59 +0000 (UTC)
X-FDA: 84912606198.21.79CA572
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id E17411C000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:23:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UqN3+Cw8;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782253438;
	b=dLsqzLKveB2Lynn9RTtoBnW+QCskzc4xKT0q/qfOOZI7a6UZSAnb4PUTschtcW0hvhOSu4
	l+cBv79tpSeyQBXjUVP5IQh9BoCSMriShqmGw8F40j2jbzt3Dwn0+fHBzOBbroVOnFdQQ5
	GKMOAHBlGmo02RwR3l1Z305Q8LZuEPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782253438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGhneuItUz7KOzuK/epKfC9DwI9TTG3U2/mjyrDhuFU=;
	b=2h4DDlMA/kEphbWgqoQiAt0NT9zwo2JemBBORN3XaASwIF42emMwRFl1dGxnVwNS1e5/8P
	oK+zepQ0CuMRueg8V36U8cU52LSXa6k8qlWfdfAIrj/D7YHy5vxxSVz8Ef6TQPwj2uIFUy
	K9MbRivjdAV6eZRAzcOew8ZmgB77SvI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UqN3+Cw8;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BGhneuItUz7KOzuK/epKfC9DwI9TTG3U2/mjyrDhuFU=; b=UqN3+Cw8lnLkXQku8/2OqCKTwi
	htxm8ZztcdBM3HX7YGIOz9jjw/iuaOVE6gzUvnN5ByKL3jFwsjJnxalCnLfGAJgVMm8piWV+X4ytU
	9UIsoz8V/P1DPoWzO7SNh4HbWBSY720M05icATzMfZ3MYTodXeC2kGmTO8sbmRQfWIujBYGKDj5dC
	vun45bcMbQMBFzRkYM6rK39mBsbzxuHvpdedI1jzh+NDdnH15nv9GkmdGu1RTZRBPkf/yXXH1w7kM
	9XrUcS7eznhh3hPFjyvzAUul/pXqdZzmu/76RchhAs/R+WSlkht06MVwckfmarIHs2V7bXpG+hWWp
	If/mmZyQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wc9Wl-000000007sj-0IMB;
	Tue, 23 Jun 2026 18:23:31 -0400
Message-ID: <82a3c10f5a59bc6961b5faf2fbed5727c1c8ea84.camel@surriel.com>
Subject: Re: [PATCH] fs: Free any excess xarray nodes in clear_inode()
From: Rik van Riel <riel@surriel.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Zi Yan
 <ziy@nvidia.com>,  Jinjiang Tu <tujinjiang@huawei.com>, Dave Jones
 <davej@codemonkey.org.uk>
Date: Tue, 23 Jun 2026 18:23:30 -0400
In-Reply-To: <20260623192850.1595958-1-willy@infradead.org>
References: <20260623192850.1595958-1-willy@infradead.org>
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
X-Stat-Signature: j955gkwq13uiwoo784h1c1d13zkenq38
X-Rspamd-Queue-Id: E17411C000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782253437-541916
X-HE-Meta: U2FsdGVkX1+ycb0W+Ayzw7PfKihoJgqYbLCyMLy6wwW1UlXedm6760YYZHogH7CPyZQbKTMMeGZTuIyzzPgDbUKOfV5YMCBRb7oaTPMx4PTrqfwfYX8RPGP+7akpV/xQ0ctCE3aQ+9uuiXLnT7m0fOlWpQX1Wh1Tyf3Oa8GRK1fD/4zSeOnTkre4FTCmnODOBUWkqGKkj9raqyLS0SHmX4cI5TV/Lu4NU5L9i2y2kRqRB3VscS1YMw+GO9OaseUuXNVeO9saLUGSK66+2/ACeiqY6656rBUTWehDwNOKS5+mM/pNXpJRQGtz3LWDYEOB26OKruAcObKcAtMB/UDiv5JRneUukj1D+lI1frTs1DZy2yPD5Px/q0lexVOF0bbAaiyPQbQBTBvJ1d7dPR0wCwpKTzgeOxtoRgPDWdxgF977v6J6ucwbKW8/cq/lML92R/bpx3MFXRPYU01XEFVb7FROlVsg44s+27f8OOXQOD5MqjSP8amo6JPi8whllkjUqD46mrnjhH7iPGfLED7B7XhHIuyXtPq096J4rX56INP5r8eS74vESA6bmLlgSVFw/gnWApbkvM7GZUW137Sg9Y8DSQOeIuMKcp9Skszt2E7G/Rr7Ai/FzsP4jRrFb5qvXL7Tb7wZrZMF4xY+6Vnntm/WlRQJ8ZsMh2Kogt8amJTVsd4ju0Y0eAeQV3Qb6KFCVIZXc2i8kvMfhwxlMJwBmb4OP5+x9i9c+kH3SIvtJQIVDzD8jgUWBgGe9ZaXIzAhMlLcLXtnRgY5VeVHY9b5llLyuDchSeDz7wK0E1fnHUen8Ye+bQ0B78c8UCcAliBm2/nTxYOu6Yw77QVSA6TpxolPtUokVtQ9C2THT69JShnOQQjM0uvLa58hegFVtJckNnuoPLiIsx8kZ9dNu86THbNACDygdZIVYyFPKa+IQMsmDyzsWzTn3A7Qt6tYeHDukNw1bkbWoCljFS11Fws
 RbjbDIU/
 Hpf3gULUR6f3OZvyNquqHCe8WEayj8BxF28Ey4P+2ynrbXh5VMjIu9FB1l9VKn5U155G/vDbf2O7dSUxJLcYPmqguPkqhV/3LHiL9/S+4twUdFg5s6FAROUBlN8UNR+4mw6nOQWqPvqVBlDn+bPiBnD5nrCVRwpHZbkPuBeaiv4cDObqHJHTxlTmb1wz+FDQz2U8uq5vXod+paZwybXem/ZJZW3IKbJhXjvMWKFVG7xI/TeEFwwyTjiz4Mwya6fS632OgcLm6JIOjVQXwJEicIqo3yzsGj4atVtXf3F4bRfx9IEKYh/05Ypi8NvDrFLinF3r3gYrzpC7TjWDCuZCC4cWcx44ZEYp/j1XSH2qEQIFDq5LZb1fAITNkhGVhL2vaAN5moAqqgEs9Lal5HyrWyyQ7zdA2pz2aiiLXP5dyQJ9E1Mm/xu964XwYdCyCAKu64vvrEisQs+rra0YCElWBfcRFi7XR0dDGWSW0FPsSsrihWPpZNfWWNhbS0f/2Jnox/36FD6Jg1W5f/3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-06-23 at 20:28 +0100, Matthew Wilcox (Oracle) wrote:
> For many years we've had a hard to hit leak of xarray nodes.=C2=A0 Hugh
> documented it well in commit 786b31121a2c.=C2=A0 Recently people and
> syzbot have found ways to force it to happen with madvise.=C2=A0 Rather
> than fix the leaks where they happen, just call xa_destroy() which
> has the side-effect of cycling the i_pages lock.
>=20
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Jinjiang Tu <tujinjiang@huawei.com>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Link:
> https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.co=
m/
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

