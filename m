Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90982C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6F46B00BE; Tue,  7 Jul 2026 09:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757F06B00C0; Tue,  7 Jul 2026 09:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620916B00C1; Tue,  7 Jul 2026 09:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38EFD6B00BE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:52:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B72B68DF91
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:52:32 +0000 (UTC)
X-FDA: 84962120544.11.AD1A30C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id E13B24000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:52:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=l7tqum5C;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/6KWb4PfYctYp+8gY6gHKjmETilMdBvjVRCsYZspew=;
	b=f9o8LXorx1HnzsTWYSqKzCfWmPoBTVRqlF+onSLWd1vH1rPr90AlzWjC5/IVrjjURtRXz2
	hspqV+vBDjURCtmHfyPtEDXv0eWSD3ULN5Vr+FR56eXrB+6GgZqDzJzh0HsRDPRsUU8S3/
	alT7tNLbTGgyhrl3FKZzLcryDEXZAbA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=l7tqum5C;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432351;
	b=VUFY+ou84K12kVwwJqs6KWJj8PMY233jjNQPPDgO2olxpexFvSzcT/sbYw8W+xtlLouTc7
	8QoTtgdiAfCsJLeaHDx2yYPBJ3azxdyV29qCFWX7gGuQ+h8jaNKnp0w9UBM2F9pSf65SS7
	qRKIjCdxOoZjCcotGcyMy1sckY/6Vzw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8/6KWb4PfYctYp+8gY6gHKjmETilMdBvjVRCsYZspew=; b=l7tqum5CgVXYfcPwtJgTxfXiNY
	W+Xf+yjP5ugU2fn6LRQhGIG/KXGwZERlBynLMOA5aHPAjPSm5S6XBF3IDbi0TJyAThoasln5kjxAo
	beip/tuPnL3fLnGzJwLunkBGhyRftaYswtsTi2VOxFgEx5xtCC1s0eg4v8B8L3/mu6ZGXGnn8Qs0o
	7nA3r1DP6GorvKH3z0hsuJe5qn6HyVDyQ4ujI5wkoVj7IXEhvFsNvBZ1gvc0rVeL3xWODUBHM+A3z
	43wWN0u9A6AYoIpZ0/zbIr6ngSv8NaivanmsvSjuWuYwacUBuYRn+hlNll3yL8lQ0Ndj5T8P3iNwh
	jBQJOKdg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wh6DV-000000002t1-1k1i;
	Tue, 07 Jul 2026 09:52:05 -0400
Message-ID: <5c06c0ad2f2a7a039181a1775623ec06ca063dff.camel@surriel.com>
Subject: Re: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the
 per-VMA lock
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin
 <d@ilvokhin.com>,  Borislav Petkov	 <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan	 <surenb@google.com>, kernel-team@meta.com
Date: Tue, 07 Jul 2026 09:52:05 -0400
In-Reply-To: <akzv9FWH1peGukyp@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
	 <20260625015053.2445008-3-riel@surriel.com> <ajzUCZSRU3h_UdjR@lucifer>
	 <610d1c95a2f9131d5c018304f9a90afb33e8a032.camel@surriel.com>
	 <akzv9FWH1peGukyp@lucifer>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E13B24000B
X-Stat-Signature: sbaj3gzr9pcxjuctc6qf95tubjzkbmd8
X-HE-Tag: 1783432349-302714
X-HE-Meta: U2FsdGVkX1/LckPWH4N0BuPefbYi0+7pFRu8ziXE4kAw/KA9Rcz4+qjKbulBfqPRFZKKv7qoUXCaoBX2I19gd6IU7jCcthysEAss1OjG0bCs2UR1CnvDJ6sJ1FsXgaBtKH8jcD6shAdPf3BUmcdPcst4lU6/1LMfgQFNPIJhL0TtNmouic5xZ4DNSvh0RPa11TpghA8RdQtTNJ4dCCUGBpLjDPK7t35tDA/ZRsZXhwFWH9kXzlaOQOj9BLHZ6/i/bipIYexQREG1dDdLF6YyCLHxnsBOYLST1BN3fUhdjjD6dWQhwVuysI6goguJV0PFmC8cpABqnFuN18QIfgXxiPM/C9zT6U67Hgu2mK6+HueLyt6J33Xk8FxCXNUdFCbjpY41XdvEHiMuJn+Mtc/fA/7vBaexHtY0wPMm1UzT9/5I1O3P4p0GtK0hx5nccOCNVq4WdPxlbXLMnVHOQ/lZ3r4clavQUhjdSThd9AcTEUfDuTWzkvnGnKJpOt1+oFhs8ibOscpE4zw1oaQP4Ak+n9vdxer+YEvK2g5Y6ZsRaqIlJV/fkiF1TnHEXetIDpDZiM3uiHzT3F+ArWEIE83gPxTD/1oJBdm0DVk5cUk0KqBk4BrRM0oktkZ18m/H5lUo0q+9oj+MNFv6ne3k2WsMzD1fTqO3o84rpgwzuItYoxyxxtXre3IE6piaXy538UQv9+p2nTbB+TrA4lgn23CsZ3cLfhouA94moeLBwwzFR1OI3HE0M7I5zba20STZyy6IxJOFVewV4112dM+mVmQJiN87xiquVpszC1qiJP4cu2OFTdrL1dP62YbNy7UpQf2fyGMWn30NUcGEFLwwnIVIstop2cIhpNBF/UxE3mIHI4LkR81BrOjp3UPH//J+yygCEhG9FCJ0ZAzw00u3rdj5cZW+mFz5gl9qheW2ozhZRLe6ex3TLH+EK+eAPN6T8nvhyVcPXjbLiN0LxzRk2qW
 6RXKgBdX
 +qmGEwneaELcREBlk9RkSCkcd3uvGcGNgYCXVwBuXYpF7urZVdrxBX3LD+wEYGStmH70AuAgaekuI/CVXOtSb8DOvV9qF3JJWI1Y+kfZqDXVldDlNWP7RWDN03S0QdmHrBQDia2EuG4NlEaPgisTJTyY1ExTma3ICBLa9QtHepq8CyrFtzYqIfiH9MB93UzKDugoEh1jq3PBFvUcvvWyO2n3rX1gsCb254jZVKtxbF+GmWdc+5APoexHLCfbO1T6KLcZV5deN+8QaiEE+kur/1OsEEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-07 at 13:24 +0100, Lorenzo Stoakes wrote:
>=20
> And on page table retraction, importantly, the PMD entry is cleared
> _with
> the PTE PTL held_, e.g. in retract_page_tables():
>=20

Ahhh! That's the part I was missing. Thank you.

That simplifies things nicely.

--=20
All Rights Reversed.

