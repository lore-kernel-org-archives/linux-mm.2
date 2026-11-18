Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555AE606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=natalenko.name header.i=@natalenko.name header.a=rsa-sha256 header.s=dkim-20170712 header.b=IbpaSFfD
Received: by kanga.kvack.org (Postfix)
	id 747216B05BA; Wed, 18 Nov 2026 08:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7E86B05BB; Wed, 18 Nov 2026 08:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D416B05BC; Wed, 18 Nov 2026 08:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 436BF6B05BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:43:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4A65A0764
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:43:07 +0000 (UTC)
X-FDA: 85448356014.16.F0DA488
Received: from prime.voidband.net (prime.voidband.net [199.247.17.104])
	by imf16.hostedemail.com (Postfix) with ESMTP id 17BF2180003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:43:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=IbpaSFfD;
	spf=pass (imf16.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name;
	dmarc=pass (policy=reject) header.from=natalenko.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009386;
	b=JgGH8X3cmhjo/CwWEzRAirBElYioMIs9f6rkmp82SBQfr9G5qlK5fXXeUWxtAE7TQ/815G
	hPWY2BVj8zZjM07/1d+58XXvEAtpXf9X0YvMiosNhh1n1fZPxJ7rI+H1FhnJp51ysqtH7H
	UYQXfpBtKriTJUGoQP7GZrMOAfAhZ9U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=IbpaSFfD;
	spf=pass (imf16.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name;
	dmarc=pass (policy=reject) header.from=natalenko.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3A8tncABMhvLcvnAryBI9OBaN2+cyeVWyr9f/ku8CQ=;
	b=u/J/Vac3IxHQ+xdPxRrzrCpNU+3SyT8vIJiN5D9/+f7jUQNZvzx50mICerJi1LPTY6QHt5
	Gwvpmj3SsVT+w16N+AXPE7LcuWUiaZrGt1YzOd9NqkaCTkAmYjWGWCslAGe5nqF4BTkKGM
	O1bN2lhPMXbl09FvP/iXpZkTClkJ4+g=
Received: from spock.localnet (unknown [IPv6:2a03:a900:1010:3280:c109:c893:2bc1:6f68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by prime.voidband.net (Postfix) with ESMTPSA id DEA04635B040;
	Wed, 18 Nov 2026 14:43:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
	s=dkim-20170712; t=1795009382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C3A8tncABMhvLcvnAryBI9OBaN2+cyeVWyr9f/ku8CQ=;
	b=IbpaSFfDNHdv3jLDm72WzvU5vZEnfhNA7D/kDYS8SnTLhIT898Mj5/OxzZfGc0Uwr6a+Bs
	NJH7tp2s6uQNQduj16QUPxPLm8qYbt9YYgX2oWIlIsM37IGNRdNKK+FYOy6m6C62tj2r9P
	AvRHxA0q+ZOXawkhuhvELXM8u/IL4lI=
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>
Subject:
 Re: [PATCH] mm/swapfile: really fix integer overflow in swap_show() and
 swapon()
Date: Wed, 18 Nov 2026 14:42:45 +0100
Message-ID: <1qrRCR_8TmKp1fLrVvqUFg@natalenko.name>
In-Reply-To: <av2qxMxZXDIlGsX4@yjaykim-PowerEdge-T330>
References:
 <20261118112610.122799-1-oleksandr@natalenko.name>
 <av2qxMxZXDIlGsX4@yjaykim-PowerEdge-T330>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPartsQSnCu3rT4OC460f9hr0lA";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
x-ms-reactions: disallow
X-Stat-Signature: zb76s87mjoe4mg94xuyemcbs9z4o6tq6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17BF2180003
X-HE-Tag: 1795009385-676488
X-HE-Meta: U2FsdGVkX18/dtXAiwzEZ9XIdPrSpnVHnEF29eXyzIQJzJR5JpNFbbewws4rZZ5K6RUjO1AtAzlisFqeVlaHe29S5l/29ym9SReh2VFQSBGBpiBuE1ljqo5D+Thi/6UO/9JGCgvkXnHtswnWNomhD1gbCab74lagOae+LfMVADgWoxFohIeK31ZSaY3YiuljocP9TVbTIU0hzqrAF7JAYQR3mJhTexTE0oKNe9jC1eZ4D62scwcqotjOqw8EFmtPlRvEF8dryccPX9H6wdnGWNYAyoxaka5gSh4CeMVkw0907TLms7MKKfErYLnd4DIBwKmXfC+F6WWcqyP0u4Zcz9fqJDK0M4pcGFPSitBb6ehb6uRmyeTuzpCbU96dCPSgfBHryTGP3Og7ywJjIMjjrkgisStRVa/vMboVFzCEtXwW+4dlHYIUrFx37JBSr9s+mvtBxAFg+JPdZkqJRrpmzrd5GOhzi5r84qmHRnKzHA/ILj0mk+6yL5x9DhPfIH97YcS4a9VuzNcrG6VcCm1RPiRNuniILHhS4QEcc6A5obbRI/n60m/BrbYggUB4+mGgCKosCg35YY+Ufxq5MMvkTl8Pr0k1S3JpPkPj3p4jrQgqb5IThKEHrENLqVCgd4SXI0M79kWVz5/bOKKCRwQRz6BdWp4vwnNWetRK1NFCkxZ8rdXcJPAn73y6NWUvUrVhxiUM3SVnv6tr0+5u9tCsnX57jjwy/iHS1PB+rsDCuzkplezCVLAipKNEJt2FBwXyvhhF38oci5eJiCm4tLVKOSLe49QjppkjWwGO921XNrCQfNJhQdmJOhzf+q6mUhFdcXQh0i65l1s96Bn5E9wEMSPzkM+s+dfSd/3I5cV0My77zh1NNLAweo3a/vy8WPt9wLWPUNlFvwb8n48kQwb0U9DMaB0UNhxXfQGjY2Jf2awkbVovD7K/87akPbq0dnZ0WwB+AJUZIp+/5TA9z85
 lhf5aUHH
 nygH0e+smehU4HSUj41A/nmn/dxUDXJCZfJTy1PQZcbmXJ74VJ1zpxGnh9Y26D7s0rrIZm7enwqyYX9mYHx/K+ZHKaCttiGMLQarluWQ8UgCtE292TFduQ1ba+1n+j/1Ghlq4anWa6VNj/WLZR6DgjkNSiA2ChCHs79b9HsaCu1oUramWZUcXMTcCJ4afKtERLDKlFj6B0mIH/zRf0v5eoZBysxEVXcLQOt7nko7STG8G21l7BkXp44NfA0lnvSqMuDQLI336A8UgmQiYWovNcglh3gND9u3k3rVT/b/RrBSO+APzBVPOBxfeXF6+KA3PFhWWQNfYsfYFibF57fl/fjHAuEKiTchdd7SJIVhyN/9KTGNpM7ZQzjAJcYSLP0V7NG3103mkzD7viEqt3ljFp8jk06MeTvpY+iRMrLPI1LYNWvQlh9qg3awG0MzbGPZU1h3nlt2sgVWN0qa/z+vcVln7Q4WJdbfcHAI/fafBUCuXhaXO++C983mGToQpJMQ+dz29Ixn2V2uu/ELTFfSU1alXar+x3eaSw0IZpdxgWYP3xp6LTXdA9t426HI7zwlkwD/Zo6sbABxtXxt2MFmNC7fprLc0QL8lwDNRLJY6n5sibP6baF1zLMoTjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--nextPartsQSnCu3rT4OC460f9hr0lA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Youngjun Park <youngjun.park@lge.com>
Date: Wed, 18 Nov 2026 14:42:45 +0100
Message-ID: <1qrRCR_8TmKp1fLrVvqUFg@natalenko.name>
In-Reply-To: <av2qxMxZXDIlGsX4@yjaykim-PowerEdge-T330>
MIME-Version: 1.0

Hello.

On st=C5=99eda 18. listopadu 2026 14:40:20, st=C5=99edoevropsk=C3=BD standa=
rdn=C3=AD =C4=8Das Youngjun Park wrote:
> Hi Oleksandr,
>=20
> > Cast si->pages to long explicitly so that the bitshift in K() doesn't
> > truncate the value to 32 bits.
>=20
> Nice catch. 642929a2ded0 widened bytes but left the shift in 32 bits.
>=20
> > Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show=
()")
>=20
> stable kernels show the same wrong size, should this also
> carry Cc: stable@vger.kernel.org?

Yes, picking this for stable@ is a good idea.

> Reviewed-by: Youngjun Park <youngjun.park@lge.com>

Thank you!

> Thanks,
> Youngjun
>=20

=2D-=20
Oleksandr Natalenko, MSE
--nextPartsQSnCu3rT4OC460f9hr0lA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmr9q1UACgkQil/iNcg8
M0u1Ow/9E3JLHpCmvyTaSde8JvsLvNSn0rdHLUpfFdft/AC2bOa7ARewGsBOTWZ2
+Zwr8FpjTf0kRE746zvJfScBJH6t7Hu7gyc5crcJqwUb/OrxIJ4IGgpO67N/vv+9
xuh2pMSJOGCCwSu7fY96k+P2FRFTdcFFUvLMoJJP/mlcvhN/wRpLwk1/xkLkOVda
p8tImT4BG9Z2jp3+11T5nAOMRc5bK6BWNkpZaxfcWP7QfFnHqLW/EyfcTAdvEaO6
Bq6T4onrk7jWqJr5jBaDr8aPuGVkpQJUQckY6cCOsDEmvYoZKtbw6IN5Up8by6fL
OAIuDaq5pCnhshvrawQXNvJbZVpmvg2UZIwMwjQesnEZuUXmNDpwM9r8egCyNoWu
YJ2mgk5xqNa98/tRqXvnYXFUugcSWXH54SEDEY3kSFS3E7PAP43G4SnOyAWtLvjt
zXLdxQLs23HeXzBzIKmlJLRtS3hQQXsI7n15H+ooHyIemDZzZ2xSTI8Rq9SPSvm1
jtGtX+8n1k9rI5MZAeIaX3vdHtdh+y9d2BHn7wJzx9LI20rXyW2D0llKjoAY+4oi
iTRKvUvNSHFAZiBKFDnVBbRjPAaGLPCLk3KaYBL0faJkGCw9DkrlFlmuwtUlNHWl
fPU99EZlK4mGrBlMHiAHYV8KB2I5taplA5qjFxz9zC1sF/5LUt4=
=TbdJ
-----END PGP SIGNATURE-----

--nextPartsQSnCu3rT4OC460f9hr0lA--




