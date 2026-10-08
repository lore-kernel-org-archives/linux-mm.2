Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6CFCA6012
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 19:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73C86B0095; Thu,  8 Oct 2026 15:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD5C6B0096; Thu,  8 Oct 2026 15:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBFD6B0098; Thu,  8 Oct 2026 15:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C33C6B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:12:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B68CA7D1D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:12:43 +0000 (UTC)
X-FDA: 85300405806.06.83A602C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC99B40008
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:12:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnKRpahR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791486762;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imD318uYbaR4I8GkThDrvvtTnqtl46+qes0QsXa8DAo=;
	b=I5L1R2FgmckdRYlUFc4H/2LUqTtYRuiaNcOW/Uqx3zpQ8bKKRdkDBFfsEnkh9ahHZOf+Yb
	m1yv0ePceEzS/w7b5wPXV3d0oLYLb1hxfudY9Y9cS0aVKSW/MOJftcUeg4WDEWrxQiH1Dt
	G9/KcaZj5OCaef9YFg+l3ovTORQ8/6Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnKRpahR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791486762;
	b=45oWRchBOAc+KUtJHP/q5V8/7Xxf4dhLmXAWsf11PWP9pFVSkZsE++56FhO/iK0hppOJ5B
	v9dfRcK8DA95UDTppGWpwubiLVQiNbG6y+6KkoEZ4jLpn1KO8heCm6lQri+4Se72VLAfMB
	L5m1VWRGn/nUlakfCfymsxgY8SUBlVU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52418413A5;
	Thu,  8 Oct 2026 19:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78B21F000FF;
	Thu,  8 Oct 2026 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791486760;
	bh=imD318uYbaR4I8GkThDrvvtTnqtl46+qes0QsXa8DAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PnKRpahRAs+fCtPQqncrSuQSpAwUK3VFsokdhvscClzl2W+rCLWdn+MQfKgjpJm5z
	 e5B29u7tHEzbtCCN5Gg9E937UIKqJtUjNs5lPBa8N3UIgn38tPpINJHT1wnGzunjRL
	 QF1DOUumYsRMStJDTuSK5uKzqspKyN/3Ory2AKsVoauj5uvAPwidSGEDxYTZ9UxtH9
	 bfp2OTL6sN2qZX2NrIRiHCyPT1lu2QlVosFVqcW43mkAAWvuhzsDrXX41RdVku2Ltx
	 sUQfuwqyHCsDFzxcTMTQDkLl9oi9UXyRdpYpIosHfUgBqhTjHZO5+D+AphwNLm48aM
	 569ZCvB0szQfA==
Message-ID: <sashiko-outbox-164503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open
 code its users
Reply-To: sashiko-reviews@lists.linux.dev
To: dmatlack@google.com, "Tarun Sahu" <tarunsahu@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261008190828.3221718-1-tarunsahu@google.com>
References: <20261008190828.3221718-1-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 19:12:39 +0000
X-Stat-Signature: dsdj7oce8k3u8q7nndydrezdxkwjtfyx
X-Rspam-User: 
X-Rspamd-Queue-Id: DC99B40008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791486761-562681
X-HE-Meta: U2FsdGVkX187iXC3PmJkvSUb6OqYUcKY5c93Kt8EhRMglKBreYMaoj9CbYY25oVyhcIRAv0FytfZznD5Cuhzq/qS886ZxcvDoBgkEKkvGABuI8vAeI6L3N3xGbPdfLBCkMiFFmq+WIqecA6XbPCxoU4gdoenGwvL7dA3NzLVjPZNRZeSA3xK6N9COJAXhII2hDISyZRkN2ep/BTitr37DbNFEjijX2JAo1tDIrXXqptK/NJknY9xct/rqf/7n6WjyHuxzeeqK5mg66wx5F+kSMHBTQLnwlrlviAvFLJ4+qnS6cTlYMTj4O2z0tAJb8TYEt1LLXPNmc1mUC+xyRaZGl0q9DldHjNQnNRCwuXDC6rrqM2jIGFZ8dXbbej4T6ClSpULUT/MQuTPNJf9w0a653uXOpVdfK/tWoRkDzilwF4+/JQok2oas58bHqQwwFPiLoM5DilAz+/H8R//thpT3Ai9vl93FaMBTVyrEkz1TixtPLRt5JEhBISivET1NkfFBiR9NG5016tW3WA6eyrICjDgs7h+W6aGebpS+oXfBdhj/Y6esBQICMQpUHO43ulfO/dc+fiw2ki9ExWuyYaQKeXX03+cIFmTBOVe2pLR5xV8TA4RFBY36XAPLOpMlWIm6fRsBhLP+ZlrQaGXFqi63PWw4rn0VWb844MgIAtjJT3gLoKKeWH4wp8VvOV79SHDrFU6IwYYBnTWfQrZcSQp5THBrx5O504Ey2h2FQaqln7m79zcOUX5SyPPI+ho18VoJtPk8JRSFWt0MypC4ehobZ5uv4vzr47ekvDtpUosRWsQ1KdbCY566rNOK1L7z73kVS27N7+o9FDP0XBTvPt2wd5Ih58LlaE1wsGr4utXB637JYrhsrto5rfjtUrk4xk4hAs4k5CM3Ed5ffgSm/skdryTKD6mX05zS3nToZbTR5FfAPCwhxxuz/o+X6fS7IlKi9TRM2yJQNMUssvFQb4
 ARWlh7gC
 32vqR1F/mcqvL1hl/BGf0HHuzVhNBf5/oyg60pb4YbX0b9PycnVydMCEmi+jj0nS88AC9d5Z+1JLV2Iyr3DFXq92FbJPLylMp/EGnnfBuOED5P9S0fLDQ7pTaMpjL8XI8kB34FP1uN7cUzbqmtJj0EM7xzPauI6mE2sbtHmFTpK9cNIVJrYR1j+mTq14veiRtKiFIv/0BfjfcjtWVjXXs1hwwPyYd/6p7aYQxUaUT3E85s67V4t21DHJTXvo27mneVuakaA7Ec48j+qjx3EQTWd/pnGrSVr4mwV8mMsuc7rzqW06H5VcTZr00wLTunhXqyKNu7R/lUkz7KB6PD4qbd6NQ5cgTHq8P5M9eEusUFNU7LlZeaM0wa2dyALGX5C1edo3SFmWi2OD90P/CCKIQar4Fj2zVQBrlyifl3TjCo5kO6sRbryufePaXj5Ji5l8aPcfs/oR4rtfiZIb9Eqzo4YKpsrmFcN9BLqrpRW5aOM/lSSXcrvPJBSVjuN8w8KudQybH8xVifgtSS0qn7qgs9n7vBTFO6kl5HNEjt3hNKaL6z/X+TQOMpBT+IusWKQnTj/FdVwQJ2LvNz4TgYb/5gCWw7syg3zEHPRuVf2SALyUCb8EtAwVXV3CJWhfbNqsJv65obUwRfYFEMxvdX66nDzkTGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> for_each_memblock_type() always starts the iteration at index 0 and its
> body is a trivial 'for' loop, so it hides very little. It also gets in
> the way of iterating from an arbitrary index, which the next patch
> needs.
>=20
> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.
>=20
> No functional change.
>=20
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008190828.3221=
718-1-tarunsahu@google.com?part=3D1


