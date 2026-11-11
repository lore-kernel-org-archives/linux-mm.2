Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F23606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=EoVBFv6o
Received: by kanga.kvack.org (Postfix)
	id A29566B05B1; Wed, 11 Nov 2026 10:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A008C6B05B2; Wed, 11 Nov 2026 10:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9417C6B05B3; Wed, 11 Nov 2026 10:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75D966B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:44:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA5CF120306
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:44:36 +0000 (UTC)
X-FDA: 85423260552.24.38C9435
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D7BF100004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:44:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="EoVBFv 6";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411874;
	b=dkD3bfKD7hhTdRQRrRyIM/8sYWFBpaavKo7cyXQzGGXm/F2/Nk7rOA7X00trxIBfnt12g+
	pq0Gds+7MnYbv1ubhFExuj67dVqnKh1/t3FzHTemgLk/yGhG199wFZh1E2MJKPhWSbDPPb
	Z2vc9YKmr/pR2z+ENJHFhu6T9jYZg2A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="EoVBFv 6";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fjVRx5vsZkDMKGmhuNd7Yjfbs2A2AKB7RRC040th0Y=;
	b=oUQK5MfXcM3/1PAzEej2G1qhSV5qVMC6Z8fRyA3Ffz5bvr/yZyBluqWLWzBv+/nxKsoU9b
	S67QdL/yPTR+EElgTcXyRVrXP0F9AyCkeHi445trvO68lUSlKb3WAxtcF3dqz4ZJLivOMF
	mdsV1tSos0CoLGuYlOJlorGqVVKkOAA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=0fjVRx5vsZkDMKGmhuNd7Yjfbs2A2AKB7RRC040th0Y=; b=EoVBFv
	6oY8+IOL8Tyrj2uliK/+jDzxNnmJgURLiHpTSqGjVydHO/Ny7XVuOvp3vas+3W6+iABLVZMX9aMXt
	DDyJix35YA0TeyTJqMQgcVABnpmPL5yBSdnAI8j7at/Ax0Se3nS1Ufe8Zae+echT/5bsrF/Uce0iY
	hY4QkORTL6PDyXjWxwMU4LDNROEp2C3OPaDHupepWY5jNMq1oTujdKu2CjXzruuhYUxBJairvppjc
	uUeWrjpyQaFlQUX0dFpfIeg0h8SUsk0Zdqad+arogguxMf/qalnOKOscTdwzs7aSw0n/lYJf17iMg
	nJ4HjW2Mpg6FX6rObqinZdrp06PQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xRAUh-00000003v17-3enR;
	Wed, 11 Nov 2026 15:44:15 +0000
Message-ID: <6e62d5b36362a5dd174de68b5090794877ce499c.camel@surriel.com>
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream
 workspaces
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, Herbert Xu
 <herbert@gondor.apana.org.au>, 	davem@davemloft.net, terrelln@fb.com,
 dsterba@suse.com, hannes@cmpxchg.org, 	yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, Andrew Morton	 <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Date: Wed, 11 Nov 2026 10:44:15 -0500
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
	 <20261111153532.1036709-3-usama.arif@linux.dev>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: ho46sb8oqo13yu54mb3rmtbmxb1doq88
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D7BF100004
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794411874-782067
X-HE-Meta: U2FsdGVkX19GHQ++1JUnCgikgAKAnhzTF1N+xIT11lbifSV2017pnDDkVLEfVKqNLX7LMJz9G/bBNouY4PLXWOTWRGOasnkeRBOiKljr6HZGMDvDynZTulp+aVpwiN8VVU4g3HK9A20PuKBs0PACstaGylILppC3h/yePf6pQlXz1+IKz7kGS2HsuEySqS+VfARQe5AbpksKNyCxRj2rlRUNYjL18cxVqbYI2fc1eZ+FKio9VFf0yb1qaI9cYSMB3VSWYxtZBPWUoDc6JPEm0BkKCab+5zniDcd61Or2wakpBr4DsIsDVgLxuEM9Uva8K4f2YVkrueefRMzeLjqT6tqsoI9a41irxaPbs+kIrwqU0flE3hdvPm+OJQm+uNOpkj5GMzuScd3y2o6qt6419Noq/cbL/tVzIXaGTm+8uJDsrlmR5phwWRd44mQXUKkbUmqSphEQ33/S9dJjNSiF5VxvIpQjVvPwy/Bxa5fBIi1OoRCliS8yifLvAWjv3IUEeQ0AsBX22bepw5/gEHSaDAUTNpP0fjyOcNYLtYOt1EnKVPpv74++RMDDxCNLhCWrykh4kNq2l1xYWYFsMxgmCluGi7IFE9EYKySH22K7GEyVUr4jhuAx6RsiyOhJKGwm9FV2GMLz147/fTBDa6gOdEM2n+R3Rlg2MMRJYzyOR5xIVnnvb18PvuvbfxIfQCgn8D4VZMV9cOSbjTsrsGYhgkQ3PS9axY4PE+gx2m+NgArccVivp8CSP+vt4azXi0yw5bkroKZkJJl2Vb4txSzRmJBWgpsdFSWPbrqfkVWKq6ueV1P3+GQHxNbmCddEBQntvWXfiR+1tvjo8VRzQa38De9I+m3vRY16S2bIy77iJ64CENHgysR0ySXu3KC4YiXSh0DhZ9N4yExgWoErZXD9XhBh+aL6j9ZY+oS4AqfuG5+GNurMp24uiQEBTr+eqsP/pNwA9JgGGtZzShY9pgb
 DWLjMOtB
 XBOMIIDOhGmd8vkz0b18fCq3Vqk9TxRd3xRG1dTzEWf1yNzUFH7SUYykMZJpml0V1DK9Mf2cte8oJO0MGJApKh5cUo+6k5mLzN+BWd4VPM6Oadm+JhWSDe4qlu7mrOH7vJuPQbyWE+afg04YPDEywOVZXo44Zsk3EFxmdmiOmkdL4TS0/iJUBzBF9BBi6srzJ3qYVRs0fuLvKbjpFxk3C5vhH613VX8G9F00pWqIkUFFJKzhVM8I8bSxO15NVlkiaxIfjr63ELq1giTiBPba7kOGSNA+fWdkoILp9EITacK6+3jo3gzxgmSpWnwaUZSfi4VruBBMsW/KwpYYET4SrjDaN4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-11-11 at 07:07 -0800, Usama Arif wrote:
> The deflate acomp streams outlive the transforms that use them. One
> stream is allocated during transform initialization; additional
> per-CPU streams are allocated on demand. They are freed only when
> the algorithm is unregistered.
>=20
> In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
> (256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
> per stream. Across 384 populated streams, that is 42 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
>=20
> Use vmalloc() and vfree() directly, as the crypto lz4 implementations
> already do. This uses vmalloc address space, page tables and
> bookkeeping; the figures above compare workspace backing only.
>=20
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

