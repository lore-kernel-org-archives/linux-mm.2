Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D82CCA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 18:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9C66B0088; Mon,  5 Oct 2026 14:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46AE46B008C; Mon,  5 Oct 2026 14:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A7D6B0092; Mon,  5 Oct 2026 14:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 134A36B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:50:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F58014047E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:50:29 +0000 (UTC)
X-FDA: 85289463378.22.1D70A28
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D970140002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:50:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="UFaEm4 i";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791226226;
	b=ZS8Kb1d6C5ZjKkrgFZ0KB1BjT/IdQDMIi5uRibrCaxrHEhbzSGNyJDYdcyVewWXNjN9HqF
	iSN8qjQMD3dWwkc0SD6tuxY2QpAXmFZ1vrLmT2lmgOQu1u77hHzXdm/HYy6xowKKNHECBC
	5dNYUw7LLl5Y15Xbss9WPQF/ZgJmDxo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="UFaEm4 i";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791226226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Esv7UIvddDrGvDBQ12d3e2SEI05Tow3/227mVjVrkI=;
	b=zUz3h/rMIWuAzmMIe1SZAiP/blvebMeTj/pV0LnoejqfAIUMWJEjL2n/nwgZ3ECaQIJc7b
	rSKtKLeAN/4sLSKZntb2vsxjaCt2XHoiveytbb8qWXyCuKugpRjQtGY7C1zJSG0YaZhUZc
	Wjca0vCJrqXqyhAwFL1t40+O3Ve3JPM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=7Esv7UIvddDrGvDBQ12d3e2SEI05Tow3/227mVjVrkI=; b=UFaEm4
	i7kbzszQvBnUlHBsuMJfNnQEsHikyiuJjCuatz3gHX7wE874iIvFEczHql0jwbJ8p8GFughTIvemv
	w1N5F3XHAUlQYVT3HTsyypUuXyM/hBopS31NorW8EWRVM/fDTrXUsdF5LMB6aFIvuRyqhIdM0VzdZ
	GO/OZoGExMmrKlqmVxnXciadGcb6cu7tIiGwGdt+DcomOX/ph8QsDq+5JbHNYx5wODiRZs/ttjvOU
	v88Jpo4cyp6CVmpVPmFbuu5omVG4lv8T1F77DXWFnCIaHwyCkYka8FB8ZRe2VxsHmuhMoo4xUCVJH
	HCICj4WpnktyxBUQRfOkAvnCWRXA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDnky-0000000702h-1a3P;
	Mon, 05 Oct 2026 18:49:48 +0000
Message-ID: <822e26563419d8e3ffc13c43603ef79d4820503a.camel@surriel.com>
Subject: Re: [PATCH v1 1/3] mm: memcontrol: factor reclaim logic out of
 try_charge_memcg()
From: Rik van Riel <riel@surriel.com>
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	willy@infradead.org, jack@suse.cz
Cc: mhocko@suse.com, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, 	vbabka@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, 	linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Mon, 05 Oct 2026 14:49:48 -0400
In-Reply-To: <20261003001555.3498357-2-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
	 <20261003001555.3498357-2-joannelkoong@gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D970140002
X-Rspam-User: 
X-Stat-Signature: qhr5n7d8yffaubcfwejpgbqccr7bfgn6
X-HE-Tag: 1791226226-975084
X-HE-Meta: U2FsdGVkX1+v/5sGChfmdTjSFWqC7RWZ2AUFKfbZX9dzzfbymtnFtWCeNF5iTqxEMUXzZAuV0m/56G0Bi+LzTyWhb2x9QkY43AHtQbB3MxovYMNrS37YZ4AmxFH3tGKGG9wngfFuxOdkef1a/p1YSVHKGCdBGcki3zLvuv1hNlfIBaPTaLCO6jjQYxtjyzE11UVWZmpJTJltSoEZw+TZLbWVW3/oXoZ2gjOD9FPQejbxAdnaNcq4heAEndWdMY9Fo9tLm9GxPWylkbMoH6vocxqmxkIcNzO7Auad46KEb14jjB2zMW2CZvb2rdnJkxMGzMlQEMnqtiYSj8hL5no3Et28bWi4gqwBh2L05pYqQxur90lyHTztHDQxlfaQv8bTRRuJNKDf+dqJ5C0D6WebYu2/nbj8IrFRxhrGyzAVj7ApQ64RFzpQRAgvGjLaYyB1dHlHS96HZpLXutjFGB9n8Et1Hk4jQePnhXcrG3Cot82Y8DsuqY2Tj3CXkfB4nRPcDXp4XIxq1EYFr1KTo/qcyebFyyBXAXq4DiW3tfyhA+j/8xBlLYVvIJ5Vsr2P9AyMQtQocl+neWZbdli6g5/6gSNFF5f/A/1BsQM1i/jECfn0PzMYVFhU+YYFzVm9qiYeEdA/VVZxfwk9Vn/kQoIOVD3spdAyXB3A4OA8yXeOp0muk7lz18SL5B6waJxCL+LsSjX3aKTWsLlktzFAllh4+bNQCGtTgwYByNJi5L4Ei+9Jm5k1p/AnrBLn5UDOXAF0TiysJgrNt0p/vPct7rWn7v5d5j/mDq1cXhehmBG7KUhgVkfOoYO8MmeHUBXpJOuUXIPJ7XRkb3Rl7XXydav8DESzM3gplRm9uJMbVTNLoKGoYB5wQELwiz3apckGm0gLyGj4sid3rmnwImcsOCOu1bWzvpBjbepa8AIwPO+/m/ARsRBjEiAFY6SLYOZo7yFtNSIKScVE5E/aA4VThyB
 YYSV+9au
 lOMfGg0w8mxtWPFpzREdgQUWAoWm7T54ZJc+MOkpEwOJfhbZ3yL1jFLnAqkqwVuSfbicuR5sRIlE32f7wKBYkGz9AGP5Vahxy8N6LwG2C5SB4OPif1Wrh191WNmRx0bUmzw99QYtkCw7rgxbnM3sebBkn9aigwLxrDMnNBxx7e2GqLcBPsJGnOK1KE6RE8SYyqLPIZEDm8htO7T0zrZrO0CtIklC68kO0p1Q1/rvVHGbBLO+jZRev7Ds45WfBYgZkngijlb/7dZbm0l2T+rnTa1KWoWHxXF1FgOOpZAGhxRKXG0vxeNdy7JgDZftLCvlw3iRHCHEt9fjYfChf/3zAmeS1+HO2Lj0d6F6Ds/C68hpx3AN3N7PQI4eCEXJLTQMuF4iS7+wQXR/Rb1RyOpcCCI2LN03mEylHbojN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-10-02 at 17:15 -0700, Joanne Koong wrote:
> Move reclaim logic in try_charge_memcg() into helper functions so
> that
> the next patch can reuse them.
>=20
> In memcg_charge_reclaim(), we can call memcg_memory_event() directly
> instead of passing in allow_spinning. allow_spinning must always be
> true
> here since memcg_charge_may_reclaim() has already checked that the
> gfp
> mask allows blocking, which implies spinning is also allowed.
>=20
> No functional changes.
>=20
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>=20
Nice cleanup.

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

