Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5B0606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=nOH3v0Bg
Received: by kanga.kvack.org (Postfix)
	id DF8766B00EF; Wed, 11 Nov 2026 10:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8FB6B05B0; Wed, 11 Nov 2026 10:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF8F6B05B1; Wed, 11 Nov 2026 10:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD29C6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:43:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 477261A0360
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:43:46 +0000 (UTC)
X-FDA: 85423258452.28.EDC4877
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id A075D20002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:43:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nOH3v0 B";
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9VREGS4F/KCTU6r3pJe44nJmA9BMguSSiJq5/NaFng=;
	b=v3oPdB32a/g4lmve42uy+UNT2C6PrZfCHcJOz0t9s5tG2F6TzCiGUH2GMZHEZqxZO5g91d
	eMkondUNNu3pzV3wgr3RK6KOLG40klzqKWUqYenRrYmS3Kwvm1icKVETxO0mQLAIzCqe+J
	zxl5VeIe9B4D2CXab5QXiw6VtQWkFKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411824;
	b=7TriORpnOb/dzIhim7VIHMREihuN5n70uw2ShAHpn7RnNyxuKO50UfhxDLcZEvZvZ7soQd
	/swrg3bvnr0ul7ygofzk0SjUOP77dvQz/QSIJam+TKVeq4VS01MyfhqisMI6g0XYMemxAa
	GJysEENF+ycc/UGf+aDKipi41TD28kg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nOH3v0 B";
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=/9VREGS4F/KCTU6r3pJe44nJmA9BMguSSiJq5/NaFng=; b=nOH3v0
	BgviyORkrv/kYgza8bS7DBqp+z6vvdhaL6MxCQAWNfCtloYDKLKiTixQodcP0Sv5jlvMdnsha054W
	U/qYAGfbfN9SwVkEb5vulZ1Qz9Foi1t5GZSl4aVD4TFGijBzZu0Nd0QJIhP6aCyTl4e0cbfYMogcM
	7qGghq1U7cyU4tQUSXmWgDwgOfmPU4LJhFTZi5tSwNPCwygqVsBby4hSMH3zGwzfVGzqWL6Nxv9ly
	WIwJsxy+52HXAyLJo1bkBtLeiqhbQ8jn1ZWAue8+vxVWlpKu/iYnu6bBfMrefDAHpIRedWi/fwloW
	ULCpubfTY4uMAZjRaxN7az8CXoCA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xRATp-00000003v0H-3ThD;
	Wed, 11 Nov 2026 15:43:21 +0000
Message-ID: <5cf37868cde9f220b5b6b60871864d8679454ac0.camel@surriel.com>
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, Herbert Xu
 <herbert@gondor.apana.org.au>, 	davem@davemloft.net, terrelln@fb.com,
 dsterba@suse.com, hannes@cmpxchg.org, 	yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, Andrew Morton	 <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Date: Wed, 11 Nov 2026 10:43:21 -0500
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
	 <20261111153532.1036709-2-usama.arif@linux.dev>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A075D20002
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tiz8mq373breqiem6rcw4jqzgiqm4cta
X-Rspam-User: 
X-HE-Tag: 1794411824-974762
X-HE-Meta: U2FsdGVkX1+XBiDEdvuBPE5jNrXvGxZn8WliP0i3XQwbgGclKW6WR6MXra/N6xW9JTw7ew87F/gLAHFjaju5EpeZ93MBkkmu1LDvWJwY+e1ty4wPUFG+D85DmACSid56RjxYtct1zrdHbSevv6hyYg04NhQsvtXinsf5qeaSn4CwIJHobEEw+EjYeDileVGqJDkNIc2DGoUS7FjkUTZeRiIuvc21qqZuORGuEZfrGtbXTBoSIW00riy+R1btkvwIH5a60o2Od2OqX+QugK4fS912yqpTwFhJC28wJrTKm1eT4hponDS+t8fm3sBExPs4w4X4DW6sMpybh+ojoBea4TSbpBwZN2HQeej+AYUTv/8D3l1/4TBuBpq4Acxmc647vBOudbqLYRblQPplOccBmZsVWpmdchC4LrbZrk2yuSfnOvGz36mUHFd9Rf5AR0ad/i/nXkzYDnTH8TeT/JrJxQ1lDzDrs0fCZDe66a58qloaXV/qpah3tBXouamE98KTH9db+mYDdEX5F2No+y4ucIHlhS3GesiS5NlC8Hkx9FNUpYzc3EkMrVsf5QCM3diwjx+QQsiNcUTURKfvwG7wjlg35wLTPQvHTTECAtf5/Dbi4uACeLCwrXJX3vy30aAnNz2A4VobLo3vxWzYRyea7YiH4dPGBMQuuHfdRaIPlyU13GzukLMy+xpGLxOFsl9UiMFydUWVdR1JPc4AdVSdRNfR8WUOvPe91wjwfQugyDWoOjiSBYKrYvcyDHLXN1MEq3IUsJzA+KMEqw/Z4Jv0S7tndkGS9bVn4/a4/4+CEZ+soGRk1vV1u0UBUSaEAcrU2Vxf2oYUAEsonO6+U0UaVMEA7g2vPTt7b/u+bmL78p0dJgXtD7VCZO7ucuYzh+DRqmONNsrdeSxDQDKs0gKC0oTQ3svbsEGeKVEANeVdp+4ab158k/Bzt9RpyI4gVZcIqQnuYZStY5u+X7XNn9f
 fUi9mCiL
 yDvQsg13zSunU0ZlCvffnihJ2N60+gOJ0u1/EGm2ilb42Io5W/y8phM/ZR8SOKXBTefMEd7tq0yPKVjX1FPZl0osSjlRuo+fiiH6/PmC5HdF0qQ9THrc8iZDMRAW0C98oD8GFrlSo6l8O9D0F3ugf4iYtkN1LiIUhZnt43CHdWa08N6sJhuVC8kI5eZOD26WZJ5gq+HsTPD9Y+jhzQaiuKwxmhBxziB3Nr3ufkoJyXUgbT7DCCSY2hThTRoc1sleBnvJd44ixXrCI5dX96uYKsZu7cygbd4QNplNDqlggYs/C/9aUGe7bx+h+ixCDFoP+IzqayiASdFDjyLUjqu8QAyZuUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-11-11 at 07:07 -0800, Usama Arif wrote:
> The zstd acomp streams retain their workspaces after the last
> transform
> has been freed. The first is allocated during transform
> initialization;
> additional per-CPU streams are allocated on demand. They are released
> when the algorithm is unregistered.
>=20
> In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
> (2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
> per stream. Across 384 populated streams, that is 193.5 MiB less
>=20
Woah. Nice catch

> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

