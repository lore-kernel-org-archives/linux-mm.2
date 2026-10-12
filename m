Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1B5CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BDA6B0088; Mon, 12 Oct 2026 16:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F336B008A; Mon, 12 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44C16B008C; Mon, 12 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6CE26B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:07:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D55140CDA
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:07:56 +0000 (UTC)
X-FDA: 85315060152.07.C38D39A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8679EC0008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:07:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="HlY1KL u";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791835674;
	b=6vGNNJxfMVyUr+ZhBFUU2b6wxff7oljYbn4kgxUDImIOjuKE39lXHRcoBIj2Ki7aCTcARK
	Ib81QUvGmMiMwsF9GySN7h3SnZaTDbZqrnTZQxY8EwuHvFHdgDyalnQfhF6M4eOaOiu5yf
	+YFhtIpCjlDsCCMKpREf8IjROPBcoB4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="HlY1KL u";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791835674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ReBJ2E+TJExN2d1iI7yALePqkF8bg/z0h6TsPrzkMs=;
	b=w2vdDmHw8sd7BUlU/nUuxpGWjf2S8EBtEI0xF0L6R20c2f82kM3n75i/SeCNVOJLtq3JtV
	eMnkvrewtWSSMruVoniJsyjJbHMo3sKPtHQGLNKSHFCAiX5aN1tDj4UzJSPbfQAOOJcOoS
	WYqDHodF1/w98tL0TpWCmg1SUB4bAU8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=4ReBJ2E+TJExN2d1iI7yALePqkF8bg/z0h6TsPrzkMs=; b=HlY1KL
	uXtzmJOuBli6lpNiRYHWIuTY3zDbshZ58S4WipPA31Dqd72oEaeVToCTvQoqihuMIakJQvlEXnxHY
	VvA5XHQ29URH+pkUptGCz6scIF+akFIYptVlz4zp73xj7kaX4O0SASaf/i630tZCfjetCxxABfpC7
	J5wTjZhSYuArvazb8m9gPbacPSBS6717bd+MiDwtQo/XpnJRp0So32GpoufsdJNguI4eRYuWzZzO6
	Hlr8MeqhXK70YOl6Xnc9433WV62j34roGyNNc9ADrW5P1Wiukd/rPlF3AxQT1yU5JbeHYgc+e4wBI
	3r6Kgef+EvrsheKn2EyhIUyyxVeA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xGMHO-00000003WRB-1D3K;
	Mon, 12 Oct 2026 20:05:50 +0000
Message-ID: <a27117bd826de3cb1e6c791e384d3291a040d8c6.camel@surriel.com>
Subject: Re: [RFC PATCH 1/3] iommu/iova: convert from rbtree to maple tree
From: Rik van Riel <riel@surriel.com>
To: Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux.dev, 	liam@infradead.org, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, 	ashok.raj@oss.qualcomm.com, jgg@ziepe.ca,
 kyle@mcmartin.ca
Date: Mon, 12 Oct 2026 16:05:50 -0400
In-Reply-To: <9547761f-7688-4351-b172-9e9d5fa28b15@arm.com>
References: <20260818152505.1057922-1-riel@surriel.com>
	 <20260818152505.1057922-2-riel@surriel.com>
	 <9547761f-7688-4351-b172-9e9d5fa28b15@arm.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8679EC0008
X-Stat-Signature: gczydceoco9rw5r3o6g73y6zzh5k5iwb
X-HE-Tag: 1791835674-815929
X-HE-Meta: U2FsdGVkX18klAGGQ6wcHmVh9EAOXikTm5G/H+X2nQHrSoh6c5exy/YPBqUBbkf/DFqNHZUBExE7t1dnuDO5davi16F9xQothDseOkTnL8AbfLvlLx95iHISpe8V1bU0kgWtf1GmsYxEo+ZMhCROlHDeVjxwmRBu+mXc+MI7vn45qBVGfQKK5W66JZ+D5MGWUzGli0bCW19+ikd2AHzhn7IDEqJOeHiw4djbFF3Y+TgnYBvXQAkhDQADfsQvgnRpjvgJY8UCJPFVeVQKCptZtM3I48RNO09bLtMyMi1GmjwUNUVzZLdX8tz1ZYTw5JMQyo5v8X/QyCPSrNKpWAMcoSaZw/e8ykbya6Thnsrb0Pi6N3FTAwo0nQAKhj4w1p3xubNVTRWRtpABPD0ed+smDDeNB3p8vvZFlbjdGHaOIf/yU6PEwwcBwsnEsurjS+h/b40PUUjN7rQu0vj9GtauWKugLio/Lr6FTTDdGIVWlLS9zBhOuFTl+ms/AjOpHjYqsiaVw+aXLg4rQTRZ/L0BCMMoDfGuJAzH71gVPB/EtD+qzVhcQgBhU9BhuSQvCDLn19EmSwIOpz2HSAipAccrkuvMiCwkS2ZldtiOvAN4H0kuAo84eAxUir/S3w6qw7/Ocx7XtLAJmOtxW9q0kwhb8QPfa35gllB2z9NbTZKhsE+64UmGVuWyff9bQS0AAl8+JiyIecpRDEVGdUfujLiOyqL8U12wtSpcXEbhpqt8/8lUveBrbGmFaL6m9d6tQBsmke8dVsTwtQaQwoqyqmFJzGC3iTOfndckM2DSJVnj6A/wmJEPZEt3vVz9T/4b7VydFQhamhc2oAwS2IQanXybiUGdvlbesVuQiJxpV5E4jL59o3pYkegeserHe/wjFL15wOk0Vv5fiDsItKFj1ohK2iEu5KRtGbvGQikyhNhFT0c4/1Tw2TIxhzS9HcrEl670J47O3olRsGEFzLnmk5/
 elToEQ6j
 lVXsi8nfHDQsg1IeShlLMkwfzb/kqnxiZD6KS91KC/v5uZtnVQaX6D6E+OsRZqxemXDN2Y9yTAP4dQ2FoCzkU36PaJCNP6yJTHHY1owQqMIPCwjeuEWMGGpWQc4u0Buy8kIGQyeOohHNiJhGQqPxQRVsQ8PSdAjNVJOCxi4hxHGL0LesM+jIQR1gw90V3hX1o+IkRlTSwuZqHwNgGNCgi8gh0hoJQbKYkfs1PWE61XL2wq1C0GUPujsrKnZle/jc56Y5nk6U7w/xyx8vNl2+HfIWj0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-24 at 16:26 +0100, Robin Murphy wrote:
>=20
> However, either way I do worry somewhat about the increase in=20
> fragmentation and premature failures once the space starts to fill
> up.=20

Now that we have AMD's test results, how do you
prefer we move forward with making the iova
allocation O(log n) ?

Do you want to pursue the maple tree approach,
and live with the fragmentation worry?

In that case, I'll apply your suggested cleanups.

Do you want me to code up an augmented rbtree
that propagates up (power of 2) aligned gap size,
so we can do an exact hole fit without having
to walk through the tree?

Do you have some other preference?

--=20
All Rights Reversed.

