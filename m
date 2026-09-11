Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68067C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92C86B0092; Fri, 11 Sep 2026 13:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E243D6B0093; Fri, 11 Sep 2026 13:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE72F6B0095; Fri, 11 Sep 2026 13:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB8286B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:28:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E04D0802F3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:28:04 +0000 (UTC)
X-FDA: 85202164488.03.30FFBED
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 476FF40002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:28:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BS+G/o r";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BS+G/o r";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789147683;
	b=OBWU6zqMWa7+2tKw2jRWjrmO7pC5uDyxcyEDPFVSm8pfEJ0xZz99+WoG8w8e7OAQHjRcGz
	UMO6gZdBjFpnhnnQhdtV33D7gicQVu/6NSnOsvciFLskp/m4el9QaxljoxnilgRYgvGIbN
	qoJESBAnjM5d7JKWgbJ6OU5PLW0WvoE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789147683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4aEx9TiL+yJCtdnf7L1fkdsEwBRjE1oa43sDYAmTPA=;
	b=3LiYHiFm2CN4LUq2CGYRPQn5NpuhQOU0psGqZkcjDUv9Rhg2gqYbR8TOzoqPkLmW9kB9lh
	jxIGcPYjh5vZnihQQGMVxSeqOpkJZpv/8B4VTz+9BHIUBotzb8tsUe7oyZIVWAoX+qPyW9
	jC7a90TvcjmKuJpmcKk+YHhJyYpj4m0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=B4aEx9TiL+yJCtdnf7L1fkdsEwBRjE1oa43sDYAmTPA=; b=BS+G/o
	rQOrwG7xj/97spFHkKba3uYLrwyroT3GsWfVqISVOObPzf01DlqXBGJuUUKNZQKbouNad8MfdYGty
	dTOFK4zjGsbUXjCcXlOtfP1eD6Tm7W/PADXr3v/JoPJJIkJdZMpfECPwfLv+ljjFidW0DN7yAL34d
	SVWteweLwuZEVlWZ8jjIQ7oEPichFhniJOl+LlaetaEPX7nARcyIZCbwHGrcnakpZBmOHGbwzeuww
	Bgg0/GYoAld/rmq1YIBMl1Na3Qv+9Yjo2pfPb9VLz6zcCocjHC4MF0sofiQqJjvZeUT/WXz2Ly6zm
	qJGYYP82Nb6USGoLpkGlIr3HQrtw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x552A-000000082Ib-0d0s;
	Fri, 11 Sep 2026 17:27:30 +0000
Message-ID: <d2f5889660e97f03fae2cd43ae32d8bf8edf3446.camel@surriel.com>
Subject: Re: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
From: Rik van Riel <riel@surriel.com>
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
 liam@infradead.org, 	maple-tree@lists.infradead.org, linux-mm@kvack.org,
 jgg@ziepe.ca, kyle@mcmartin.ca
Date: Fri, 11 Sep 2026 13:27:29 -0400
In-Reply-To: <aqQ2E68lmU3Fbjsk@hu-ashoraj-lv.qualcomm.com>
References: <20260818152505.1057922-1-riel@surriel.com>
	 <aqQ2E68lmU3Fbjsk@hu-ashoraj-lv.qualcomm.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 476FF40002
X-Stat-Signature: wj7o9ges8pghpfuomobyh5ifd8hami4f
X-Rspamd-Server: rspam01
X-HE-Tag: 1789147683-137515
X-HE-Meta: U2FsdGVkX1+0rOoaXdUlz8cwKS1i5lKDgdpNTe2zjSCwLVo/kxsMBBhjwyiKbK0yBmSfkp5ecouwwxJ/xVsO7NoCn4c50HQW/BXCqxeNvIVF29FvHqThEHe3r8JOKNqnA888clyt8+1o/Mdm1yucfQO3ZUNVgRV1a6sT2ZZ28BqUSVAGYt0PfJ96XdrCC4rjliS2gC4pWKcZ5RrDQBEDssRotrpxC+Ax5PGTQl1JnEbKr1l0EgAZARaHJUBtzXdcFfukdgWjAfmt88sGl1L3p6GYdYqwTaLM6CyOwb9kJs2r+4/UQuF5Zr4QQk4RCFWpwKYj52OzCHI+M09nSLLm3ejrRD9i+DhyrIMHYBiJUclwMPsaUnWnkn+V8DMyMBzQ826QGVPbiMMaGRZyp5znzHglcDUzhawUxcy1wXBW63YLKNZeCtUMjUbbqqhh5D926QTRbiEbCTzDP8UWT6lCxwPiXPqL5qmrnx5kCmOAtAU/qVbmGfrffdFdQJX1OJDU/RsNCH6Ci1WwdLVwPDbQCGGHNKI83gi1m8R/NA/0Tgr7KkrGe/wtdXqG/3yf2GYyF2JWqvFbuyBfMm8YOI3/hj+4h5NHAXTapTBcOn6QKbfBGIKXVhDg/4cZJFkx428ITC79uNjU0IYehJv08fgu8mgsUuihy8C4UUdcNLSqcyNXgXnChcoUvwQzYg4M+x8QOqVSyEjKIj8cgtCi8XwefcHAN4tGd20QlNozwYTBLxasJO0TBi9l/QbTd68EuZjiI19sIAmo5HPDGEJcdldvAMx1Oa/w/1XQtuovGSYoo0WcgLev5Wk7BaXvw9l35cQDKBMKFz4BAurOMhKlwjH3JroOtvBoMl/yGfW+ih6BtCmNPlrkfEZtLYSd5gvlxM5H3lJ+Yvaafbf7YS4i5B0tDp0b/RllMSQbF7gy0K1lUeHmctk4Ng1+yWuTNAyYp7AJugQ0IituJVieptkVQYX
 bRYMWGF7
 k0QOqgABVykxr9ru8tzjz+8Q3kpRnYLwvLcm/gr58wuizGdRJWxU2DpLcPJ6VmqacWMfC1zg1aw19URJGGS4cnoFPNmoz/tXQ+y0FWjan9d5RdT7HvcTLwM6NlLRTqsWKIvXQCSVEpDU+NKuQ0EuDGwpwkyp9mot/u4mtnib+PwWvveKI7MMhqDM9Y6c1pkmlGpRkOoR2TR5mKq3insKNcfbqD6YUz0FC56lJ7JD4mU8K+8v4WrJe3cWeZiPxHV/wJYtPUQpdBiZ+pNqAcikrKB2o1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-09-11 at 10:10 -0700, Ashok Raj wrote:
> On Tue, Aug 18, 2026 at 11:25:00AM -0400, Rik van Riel wrote:
> > Occasionally production workloads at Meta run into the linear
> > search in
> > alloc_iova() in ways that cause real issues. For example, when
> > enough
> > CPUs at a time fall into the linear search trap, systems have been
> > known
> > to get stuck for so long that it causes soft lockups.
> >=20
>=20
> Something odd, except your cover letter rest of the patches are
> missing
> v5 prefix in your patch?=20

Ugh, indeed.

The content of the patches matches what I wanted
to send, though.

Do you want an identical v6-marked series, or
should I wait for feedback on the code?

kind regards,

Rik
--=20
All Rights Reversed.

