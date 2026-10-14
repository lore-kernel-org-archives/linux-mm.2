Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC97CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DAC6B008A; Wed, 14 Oct 2026 11:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DE66B008C; Wed, 14 Oct 2026 11:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD0B6B0095; Wed, 14 Oct 2026 11:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA4176B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:41:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7406F401C3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:41:21 +0000 (UTC)
X-FDA: 85321645962.25.48308DB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id B229540005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:41:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="UBE23s T";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992479;
	b=55emb+aYYdGGsLjg20OGjbPXLVdT+Z4OzOAjKCOjXADgMR+2xxNSUE1ruFVeHR6jULq4uK
	ykMLWs4J4oOkZXl5qp77uDUtUhTN28wfVEJOk/I3tcIhvDE4gX1qxNq/528F3HXe2GA/wq
	oL8+Lhu8xK8KPOEbXhXkSm0d0E1mFaE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="UBE23s T";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4+LhtkK5pMcjVw72SPPYB+TQWtwmtKDStneHZm5jKs=;
	b=RPL9TAnOUZCsBGbeq9q8hVPSIxj9ZE4qqs92tHqVgEmhCevlGNszNhS4UZceYQF///KtRr
	E0jeKQLa+pUP5t902Pvyu2nAypBargfIV02tvDBB6pDX2R9cf62aqJ3GsJD65RpDp2r9Zo
	T0OSbzTZwvicmrbnAdhX+dfTb5JWgls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=r4+LhtkK5pMcjVw72SPPYB+TQWtwmtKDStneHZm5jKs=; b=UBE23s
	TOcvDH0p5OczyE9qf2ysuYZEiX2ggPWwga12rLon7Jq5B3vuRVHtF+RsIFLIEh9d2TGtvHQX0qhO3
	wu8QZuaGUXEGxSWmK0MlTBhHFgpCQ+U5VMOXIhPehZPO9aRlqhLm2DFDsJISuoNK5DEuA9KFJimGY
	GI4DWfQQlwbrGPmg9mqbnkN4nmlykAQaI8dr2glC3WMwtVp7BkaruMPNwO6Qvd6W5WkOE85kXL5II
	K979xKhZtbfPx7ikiE4EVwpkY6euKvLIueSj9A0j8XE37EQz0sTxjR2p8EUtvqwEu+XKqbZqQAu2L
	D8CmzrQCeFGzkywLDr9vYhufqtSA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xH15W-00000007UUV-42LY;
	Wed, 14 Oct 2026 15:40:18 +0000
Message-ID: <d96d827c897823cd9236ad0554a22e832b92350f.camel@surriel.com>
Subject: Re: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages
 under the merged type
From: Rik van Riel <riel@surriel.com>
To: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka	
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko	
 <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, Johannes
 Weiner	 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Kairui Song
 <kasong@tencent.com>,  Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,  Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand	 <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Date: Wed, 14 Oct 2026 11:40:17 -0400
In-Reply-To: <7b547b9b-3b30-4486-87ba-c9ff0e2dab56@arm.com>
References: <20261007021250.1665929-1-riel@surriel.com>
	 <20261007021250.1665929-3-riel@surriel.com>
	 <55f51fb8-9777-424a-b45f-a6a5bd9a4693@arm.com>
	 <038db2e68469e74077264a490e104391bdffe35e.camel@surriel.com>
	 <7b547b9b-3b30-4486-87ba-c9ff0e2dab56@arm.com>
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
X-Stat-Signature: 68ife1f5pw6hq4cacg6yg8r6z69oo65k
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B229540005
X-HE-Tag: 1791992479-661752
X-HE-Meta: U2FsdGVkX19XrRLodkXb0PY2gNvUEYgCzA0y7Y3sd0m81L6nUGZ1qlKRqIpzF1sVusJVAtDYRfBkYyTStwhtYW+PAjE74zz5Eo8AUfCVM0Czk71usBz2rA5uZrJmUTyKzNnT3vNwnZPUXXVZO2DeQ/v9+rAdMAtFGg1lw9qo8LcuU84qyhLmJqnzM01Z3kgor9iOgfQNj4REVrpk91Ns+z+zGZwT846CHB9smyNtnL2o31r2nTsJl3LpIGVpArshpWo3pmP16aICy3QFXb7AoNvn4oiOWgexmBs16PRwFtHgqwcfU4y3hCLFdbmYUT9tuvtJJRNR9OunJf8slxHl7kLDdUvT0T0r+nITho3cAf3DH9oh+hAvyYdH2eXBUdLNZHk4SCGUmS8qo4NQl+kMHB4+UcO6Q24ReQvWuzI41KTgI2z9PiotEDxVlcYcFjLtYUcByMQRLa3tsnecbbtMCmnnh6K8AtplC8udoB3pa4SnaghH4VfYF92cNgVeRBQqa4aHlrw9Qon8fGn5l6Ps4buzveDxgJCPU1AtC456TAZK5e2De5Ko+pfTA3iT8utf7nRNixH4qRejwSDGwX6WzNhQ4Rbywx0Fny4Kzfh4kNTpul1nc0DgjTOvCq9FOPOOyKAKPn34v0Fzp0ujx1VCnJoMHHD/u6xMhhBZXXRBhg+pFqJvWmsw74tQ8CaCpoddkGOkLZgsWeuSeB+OAnfIrDnUB8gFaxyRmqIin0qXy1AAbMjtEBhZQYMC1D1jgOTQF5kScPPwOohw++ILMJR1NlfHddY0o7GFXhPncY1/cgIWrwC1cX2HpBIcbrPGVhw/jv4XQPAJR+Xbt4IDlqJLmIVUPPmaxV9qj2PohwY1qf+tsqZwr/YDjEAIrZiceA5WhkLsRVANyRuwrBv9VdITqgKTezC4YUgJjlheVhcpuc9bP2wThhBw81FGfTCc+nSzdcUNzdZDJGaP0mpkLYz
 pp86GUDQ
 XI3uYs5lAD+p9PKcZbfpA2Gq9ssrvNHAqed4uJ8ecesLy372vqPr9TwOQnn4wIeAN2D+KX5vlTQt3oC/q1dRpEv296KEf4JDPpWuYDdXAhU5YP13anozzbLH3ybGFKGzkDp4nWzlfUr5bRZChO8RWXI+rd95pfYDepajr1errd5+EoXzOBdppOU3Rs9usAG0wdc1JWthJYjJ7t3SVPtXNwKjkP0/DEA5D93z4r0uqksaN+yyA1Lh0FIhVGZYcuUE3GvTgdq8WWDQOAPcByWncdEFUcYv207B1kphhB/JCX55FDXFw3t0VflhI6ui60AoCUX4YnbZORPoCGT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-10-14 at 20:49 +0530, Dev Jain wrote:
>=20
> As you said, in account_freepages(), there is currently
> no conditional based on MOVABLE and UNMOVABLE. So we
> are essentially doing -x and +x, netting to zero.

Lets defer this change until later.

During a later stage of the gigablock code, I
do need to track each zone's free pages by
migratetype, but it's not needed yet.

--=20
All Rights Reversed.

