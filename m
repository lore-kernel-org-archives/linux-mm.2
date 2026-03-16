Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1674AEFCBB3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793D56B0143; Mon, 16 Mar 2026 02:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741B46B0145; Mon, 16 Mar 2026 02:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D246B0146; Mon, 16 Mar 2026 02:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5190A6B0143
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:39:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E72FE8D257
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:39:02 +0000 (UTC)
X-FDA: 84550973724.30.F958580
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 119D0100010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:39:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MrQjokWk;
	spf=pass (imf05.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773643141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i52TkJLF+/gqgwMa4dA8pwBRoRKDZSDVOXYB570DO/0=;
	b=j+wRbjsf4KYgtXYatM4DCX28dfVbFHk46ElMJSN76Pp9wilSfQxvYtYrf3DhRluBEAhoQ2
	GD4XolXaLet1T+6t8DOEmVFdj+yTBM2U4X1fTrUIYKT8AVjb5wd+5YKPlv8b9wxYg/EgSU
	ZhUioRsPacfzrlYXmTt6LDvurSQ0dp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773643141; a=rsa-sha256;
	cv=none;
	b=HbgFFFAv4E/C3O/iYoD+ckBCMaNE+PU8lD0k4TX3ONneQbwcGepUrWMOOdFhs8sTTLqE1i
	PYhitVOs9G/2+oMEvM1hLj+aJNvFaq/UVVJyqJSON2A6/0IxDqtKioNA+qJaEmLh3ZlMKe
	Rt49NV8l5T7UsNF23nFj4S9oZuxuxvo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MrQjokWk;
	spf=pass (imf05.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so4534230a91.3
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773643140; x=1774247940; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i52TkJLF+/gqgwMa4dA8pwBRoRKDZSDVOXYB570DO/0=;
        b=MrQjokWkL0gUbqQ38bgVrgcLMsdEwvJrz+hhwayO/g1KNcoM8j/hjpEjzmULB+WXDV
         GmA+Wy1MDWFjhY3guf77RgQ+Tlokdg7a9OOZTMGMpbC2fI9aiOsxifto5rdyY2jUJhUS
         PB1VQxLUtILPiHQk3JxIBbyH9TaJZQVhCmVuvHetuoddMpbKuiaMRBtQuuqG1ziVBmXq
         nn0tL4J4YMGgNiotBX3HgIskL3fvCj+fbHX9ttVQMmtlsBJXh1QF6Ly7Cy3wSY+5RvC1
         G6knccLdLJx+optInnk1SQgGR2HqEbAl/AAKJ3ViMdb/MJVnGKrmjpiiWtq7IBI3g7QK
         o2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773643140; x=1774247940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i52TkJLF+/gqgwMa4dA8pwBRoRKDZSDVOXYB570DO/0=;
        b=TZ92iVHZgU/0q+26Ttst0fehAMTGIrXwmtHXrvgggCNOoUv+SLWxU2iJpYuxGwe6i8
         YEYmeNZy6RjakkwnWsiIzVA+J4WATnGYco1WV+EKa/zgniDilaDMhrBe3VIy7+y8m1TT
         IH7oCbkrqEv0yELotPoKj26ffAL44DlAMjsz64xbf67LNQQ0cUEKGfo38xhPYvxvPcUd
         qFeWtUScT+HUDFlqya8Hlrf/2hGm8a6FwePk6Xd+ipyp8mLAJWyKhNzGsEgFL0/aeRED
         aMc0yKPEgexXVaRJbmTpp4Z0tMiJLm/MqGrToyFULiEEARSkUSYj2xsodeTxzo8Z98xR
         5r8g==
X-Forwarded-Encrypted: i=1; AJvYcCUJo/Z7PsxVxMsocmQwICRFcryyt9z1tAuXVy0kOQT1NA77GLM/RkiwEG7apvDz36ZduzakdnIzbA==@kvack.org
X-Gm-Message-State: AOJu0YwSWCcenHWXm/JjcmDcO+P7JbJWfPdKy/xeccRkC+LMuax1c18r
	LBJUIpzAjh/6wiUKOmKtMXVvZaFQCvezuyb3KdJoQR693hSpG49IZCr2
X-Gm-Gg: ATEYQzzHQ95MFW8CdO8sP0RoJs/P6VAv+xpjTnXO+U7d8VCF1RoEoJYaP1BlFl7oYUF
	/PxzhAu5vbTadUSCCo4FAmjGkiz/9obUXwa4qlmqbZeH904FKEmlCrJMisl+Zk11ipeTWht8NAp
	xyxycZmKRCahucm0508o65JfBggYxpSVuk61G+UgvV1nJqwVm00rKW86G1zGl9JUNPvOmiHTGuo
	PfeeLFEtvGO+gluGuAnWIp0GyxD4h0H7gMao8Tgak32jXL21RXNV/hig1EHaJucm/KP1ZQ57vbD
	sTHsh88jEqAGAZWrbhRSf4lkONp/91FKSXUlIpeUrQIeobG0YHJLh7oGiWaRdeybspS6HdshS23
	O8dzRc9AIdKTKZQwNnidrnc35v+ics2zcBgR/XzKk4aJeQZRjobLArh2EqywYZSyUxYC3DuADUJ
	XX/uDeVItqAY/1bebvorI=
X-Received: by 2002:a17:903:19d0:b0:2ae:c358:bb7c with SMTP id d9443c01a7336-2aecab1f8ccmr139465805ad.35.1773643139772;
        Sun, 15 Mar 2026 23:38:59 -0700 (PDT)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b05db37a8esm11809845ad.29.2026.03.15.23.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:38:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id BD70A420A800; Mon, 16 Mar 2026 13:38:54 +0700 (WIB)
Date: Mon, 16 Mar 2026 13:38:54 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs: mmap_prepare: don't italicize structs
Message-ID: <abelfnu4kfapNEoG@archie.me>
References: <20260315224506.1973566-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kw+YVwJ/rSL03oH2"
Content-Disposition: inline
In-Reply-To: <20260315224506.1973566-1-rdunlap@infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 119D0100010
X-Stat-Signature: fro9pq1rbfqogdkm48dskim8wt1fch5g
X-Rspam-User: 
X-HE-Tag: 1773643140-243152
X-HE-Meta: U2FsdGVkX199HBcEkxLLR4PxqYpE4CYIGoS9AHxvohxoj4MFhAfpiv/EoXm4BJWuBVE0bZ7lhX50MHqloFUfuwqLND4zpxJD2kBuxcPuyM9HbRoM9JflOUjhJ0QuY8ap9fH0HGODb/A75TEf2VHBtjPJhrevNvMEUjRtAvleZk7v07jtUKh49NlSDo3eBiTn6NWYeFLRNrz2Y35ut+1/qxYYnoq0YxTkybvST/paZyng8mAv14onjd2R9Vz0/blYHpdSCuEfPx41Dyeo+lVxzCIWBNCE1iN4SNb7G2g2p7p+yRKIuauLeq9qkwY0mqpikyz8DAJXFvtfObpt89725BPt7gV15SOrV9YG2hgVRRL0wLDLJSj5DTjISetwTOCeBdaj3nhdZ0GAqO6TrJQeUlOVnWVHxKX4YhVpkY4aJFtzRFlG2uOMWsBkHlvGb/Bxe+hqPMM61UbQ9s08gpeRcC2o2m6iHYM5vVwGVfuK7ot9fvessJLtTNkyJwAL1m8S9fqYOHYbMCG3UT4Gbe96VO1WYUF0PenmF8OUU8etVW0AlUmCzIdwhA4LOxdEcgi0EZ3gseCATs9ui0OmeuWQvz/WymvMayL28h3vQOYONRs+LubNHnhwZhS1nDDCmKS6ZA6KBUSkIb21iIjlX9DaTVV+Avm5nNKwVowiw9rH/qYQBmYTUXQ422bgQVdv9u26IwmhLJ7AmYQXst26Ag25Ysgy9JsIX1//4cj+St0ZPMpYaShuqFtYAjlIsiuq0SPr4FmG/t88ZPaiJerN17V4ekTE4KnE3xl/oBtqedi4A08lVWx7mqpaHOB5+hFDMzMJvBSdVrsJBaWqwpzF1qY1zgPF0fVg1pC9FBrVEofmZb2NMfEE/iChLu20KRao4TKCnl7YBQsWZb6Xt3pTDymRjktKF9A+tonE/L1oxBtCHt7IyLKnjkv7Im3Fqh7gYgrKP2dVlRY7L8v8TAUSzx/
 aSTR8F8b
 b9usQH+O5nV6Nub8QnJg15aiCfHDYWHN9ZhCu/LDZHzEmDVb8/eyWmxywWEUSGTTKL+TV0W+AI4r4Sq2NoPt3m+0PLZro74IdYeToOu+YAGU2KyD6nEWc5IcOiHEoQL7PrA677idI0lvBhGHFl169IZ9lFjeGMtFDAXKhBvL4CHHOP2lybssdWqkpd3SHQXzKHPuvjVDUQlTCwpg4KJnU7csJTUX26qzwAQ0paHQJfNVLs+R+rtUNBOkU63gQKXtULnBwqzYtY7l5otGAF0BGzyOXFZJ9u1SAFcMuwx7m1WgSsi23USScDOTVV3U9rlTWv55mobvUjPVug9BJvlxf+40Xs/7LGjAj7+eFD+5nQcEg9UhfFgUdleKPmqzxdP6OFEfJn0gzwiac9yPh2sS3MwKgmFKwud6qa5rcpxMEQYkikjGs33AmxyiqjVGqLnIhO9pB0xEi4Zz1nnu9vd2D3hrTUGg78Sr4PkhJIDdGj2ON6gCYgJWJtdszU2nNVUASZcCrktmh4EPXESMgpzX3nYD8XStEg+Tp0Bxvdg7ebJQQdjLAYMoODKEfUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--kw+YVwJ/rSL03oH2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 15, 2026 at 03:45:06PM -0700, Randy Dunlap wrote:
> Using a single quote mark `struct xyz` causes the html output to be
> produced as italic. Omit the quote marks so that kernel-doc's automarkup
> can make the "struct xyz" bold monospace ("code" style") in the
> generated html.

Acked-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kw+YVwJ/rSL03oH2
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCabeldwAKCRD2uYlJVVFO
o17JAQDjHSzFfwNatbI8KWsASlWo4rDgcmRiR8d3LDhZWa5bOwEAlJTuBxoFWI+m
4EYUBh3zA9OKXNp54eOkbQ4REzpK+gA=
=JW2B
-----END PGP SIGNATURE-----

--kw+YVwJ/rSL03oH2--

