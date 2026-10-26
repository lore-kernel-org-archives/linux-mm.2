Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A1D606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=fiQPD5+F
Received: by kanga.kvack.org (Postfix)
	id AF7646B05B2; Mon, 26 Oct 2026 08:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8326B05B3; Mon, 26 Oct 2026 08:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9969B6B05B5; Mon, 26 Oct 2026 08:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6776B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:41:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BFCAA80FB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:41:40 +0000 (UTC)
X-FDA: 85364738760.11.7BB892E
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11B0716000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:41:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=fiQPD5+F;
	spf=pass (imf08.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793018498;
	b=M/A1Q3zAfpbZJcUOXTarAi/LO09vG1hM3uEfo4aobKk1UyNgtTwZif4q5j8Vz5pETtJ9iD
	YcMWqsdOVZ3ZyMaVCaHIot5fdTwWv4A46HKA8IlkRxeOQquAtzCIpLQt1uOH5KjrZRMIJX
	DyOn9q7VGW5RYNHQCqkdbdLRxwerUp0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=fiQPD5+F;
	spf=pass (imf08.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSbZwM6ArFWnjmuYAFuqV0i8s7gBfvuVh2SoTZC+x8A=;
	b=rxHefXSLM/DXzuhLNTeYq5brfQ5/p0e9rHXgUfXx4XVsuNnfHeq04g2L5etl50y8k15fOr
	BO8lmE1UJp1dwqWkd9BNGTLGMFUEeDH+h+116y19KyPu6YSuPQpZPaSNf7rWTlljGxhNe8
	zV7Xe5Hv5Ve533JzKWXxkil2B2/bMyE=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4jCtXt5zckz8tdk;
	Mon, 26 Oct 2026 13:41:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793018494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rSbZwM6ArFWnjmuYAFuqV0i8s7gBfvuVh2SoTZC+x8A=;
	b=fiQPD5+FuSpQJSMpZyF6nTiKVYDjeyTmcs7Cu5S+MsGVtGAI/MMb1z7ywb8u720v78tsav
	zb04/v/nC25BBabOPHqTyjvDYtHWyp5U/xpbb3CJq6Zn6csh/9GNbyhnk6FC+For3REk/g
	GHu5Ses02GQywNtmwY/u+AFbZG1xM6uEQbLTRfXVuqmTF/Oi4MXBDlbkN1HbtIeoXfg8e7
	362pw7UP/rggRrs2Bfw1Xm97vOrqi/WUtsfcPEwBB3Ck6lZaRgmJkKP2QXS3EsjC+XAqKh
	KsQFGWn+mdZu/oSVUrXQI5tZzZdaCrvgwclzxpAEwgB0kXXhPBITAd/MtzeJGg==
Message-ID: <b0d8d0ceda82e303262c0f61324fe8a84fd9f745.camel@mailbox.org>
Subject: Re: [PATCH 1/8] Docs/admin-guide/mm/damon/start: fix grammar
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 13:41:32 +0100
In-Reply-To: <179301327249.2.1796164575094900927.damon-docs-grammar-1@gmail.com>
References: 
	<179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
	 <179301327249.2.1796164575094900927.damon-docs-grammar-1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: oduzt75dmocrdjqeru19648ieiwqcoim
X-MBO-RS-ID: bcd2318e5fcca3399dd
X-Rspam-User: 
X-Rspamd-Queue-Id: 11B0716000B
X-Stat-Signature: fx1hj6gmytsrsi7bhkzpqg5wakq15wes
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793018497-524314
X-HE-Meta: U2FsdGVkX18QP9jUG4gPaPJHbOzqylcyik3i7lDv0ETtCmasMlGnXUaLlGG3ZVjsH6oB36Dy+X+/VXb6Yo6TG0ubG6RSPKqeBLySPd+Sj5SuZt9UjtRpAYHsyGUviiLAqG2XMtSMkBiDbrnDo8kWuF1N55DMG7c0jtHub9LWJLpEbsG6IlaAv030X+V++tJffX6LNVWWgBKJQPouXAYsPxHf3nd9/81JvglHFXVb7DJIWvPFgP2P1ZfUbL3ndfh2ljB+6QgsEhhHwzeQkbmDFE0sNP9FS9hJ7s1iQTYn32EYYS51XH3w91/8Q958T12k84vY2A9CVN+7sbMm7RUiScpL2PFLwkc/LqFnwlYk3lerldOIG8oWVyMSXINq6o546r70I9fZAwXekmZfHRxK6QP/vP4Lhtq77dUc2PZ4SuMYllRrKIqjwpGqzGUL+X8n3dorIXqTx3vJ8XVvhpJCmQrcuXkknyRzo5MrmFaqzDL+uGLM4wPdBE7i2SF8uVZ5aa5vLR+Rr7ffmeY+rvO/hJyDCUXa8ON56MeWKQJpyrFUUVahFrvi/kaChb4JeXLEe0ITjcLJlVOIeubTNn3SayaiGpRoYn85/V0N2NGIfkK76p71Q3s+FRgGVCZEk5PiQnzqwE5Bx2KyBTAyeMvpmeu0iObRrCKklTMvwTd7MJeieWvlQWzbPoqM2Xjf/o1qqppF4iuogPa0P4gkBQzw4H6h9bc1uaotV8x+J80K032UzzIGqMDR525ZOuv/oFGhApzQyukU0Nz2c9R6KHPVa5on4U+FeBrosnWS684ZGpWSKjYfkoZyVJf1/8gw886xxe1fhOGnHG5mCRGX1JHzcFIbSma3mkTRU9pXhs2Y4YposaotHnxg7AKTD78kr9Fw0jBnLTAPe8lAQHjSz8Wyg+zkrU15ytKyQktneahYyKxGXtyeHocCOKi87nck3h8OVPAKKuBMT/69dedArrL
 FR3uotGI
 rIVlg+NoNYmOucqoVro0sX9DBSuEQnoPUSoEyd0xm+6QTqmcOX4YDg+e2C0aNBt9L2BrGq+GaAwdbAd4yqXzuyknqzhXAAWu1vKe49CtvMJyVkyl3liDbb0hBp0xbrtobrtHxXclMWc0c40oiv8MufPNpXO07CguIZcgVqVKrxAN1YxN1xdBCkugh1j17ZHL50cqh7VaBfZi2t/wVvvrN+A1l01mId1R2c34ikiw9oPMuzQKLgSepPS+ESCu3vigMRjPm6UVOQiWiB2xguwByNqCryQ5LSdwVOSneYh1Oj+DNsTa6R6Okjud0j6OHlP+KPOJyj2V3V825aUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> Fix a few grammar slips in the getting-started guide, like "make DAMON
> monitors" and a region "that has not accessed".
>=20
> "The line of the commands" used to be "The first two lines".=C2=A0 With o=
nly
> one masim line left, I make it "The first line".=20
>=20
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> =C2=A0Documentation/admin-guide/mm/damon/start.rst | 10 +++++-----
> =C2=A01 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation=
/admin-guide/mm/damon/start.rst
> index d98b0eb8e771..a83fcc2265bd 100644
> --- a/Documentation/admin-guide/mm/damon/start.rst
> +++ b/Documentation/admin-guide/mm/damon/start.rst
> @@ -63,7 +63,7 @@ the execution. ::
> =C2=A0
> =C2=A0The first command of the above example downloads and builds an arti=
ficial
> =C2=A0memory access generator program called ``masim``.=C2=A0 The second =
command asks DAMO
> -to start the program via the given command and make DAMON monitors the n=
ewly
> +to start the program via the given command and make DAMON monitor the ne=
wly

'The second command asks ... and makes ...' Thus:

+to start the program via the given command and makes DAMON monitor the new=
ly

> =C2=A0started process.=C2=A0 The third command retrieves the current snap=
shot of the
> =C2=A0monitored access pattern of the process from DAMON and shows the pa=
ttern in a
> =C2=A0human readable format.
> @@ -71,7 +71,7 @@ human readable format.
> =C2=A0The first line of the output shows the relative access temperature =
(hotness) of
> =C2=A0the regions in a single row heatmap format.=C2=A0 Each column on th=
e heatmap
> =C2=A0represents regions of same size on the monitored virtual address sp=
ace.=C2=A0 The
> -position of the column on the row and the number on the column represent=
s the
> +position of the column on the row and the number on the column represent=
 the
> =C2=A0relative location and access temperature of the region.=C2=A0 ``[..=
.]`` means
> =C2=A0unmapped huge regions on the virtual address spaces.=C2=A0 The seco=
nd line shows
> =C2=A0additional information for better understanding the heatmap.

I have read the damon directory aswell but I didn't find enought to send a =
patch yet.
But I found this, could you add it to your patch?

@@ -78,8 +78,8 @@ additional information for better understanding the heatm=
ap.
=20
 Each line of the output from the third line shows which virtual address ra=
nge
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the eleventh region=
 of
-~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Fin=
ally,
+accessed for how long (``age XX``).  For example, the eleventh region of
+~9.5 MiB size is being most frequently accessed for the last 3.7 seconds. =
 Finally,
 the fourth command stops DAMON.

Rest looks good to me:

Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

Thanks

> ...

