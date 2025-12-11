Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0423D41D68
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7FE6B0006; Thu, 11 Dec 2025 12:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971656B0007; Thu, 11 Dec 2025 12:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8868D6B0008; Thu, 11 Dec 2025 12:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7B56B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:11:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C78B2888E1
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:11:10 +0000 (UTC)
X-FDA: 84207830700.03.9651FC9
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8832AA0022
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:11:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1aHQHIt;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZHA3VtiPED6nloMERbw0+D1oBu9/agbW7IKbHBxpXw=;
	b=xErz9BJITfWoHn1IMauF6Q2XVEz+hemFhOsWLFM1wdg2EV/L5dgv2kdMeAgaPaJiKKvG4V
	kDNcX6AR58Mx0lUxmJWiaKySh0kqDvyqWPWKRiNtB8fe2jtFro4N0wAXpsTDoUpRsOsOZf
	9s/cIajE4nfIVdD7/nypV2KgiDpjSzg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1aHQHIt;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473069; a=rsa-sha256;
	cv=none;
	b=B+nZaFxZLwTvlP1LaUvsT4FptR8Wx99Q9rcjRP6FSeuua8BH4FnZhOonHxKeDsd7lcdGLt
	A9esWhK9lXQ+lylJTLHGqvU30abdoAvDUlQjyPawxVhNW9cxw9rXM+TjF9Z3f5UhQHSXwL
	m8I1ryKNr/krITJbJvVgYGM1bFcY1w0=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765473066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yZHA3VtiPED6nloMERbw0+D1oBu9/agbW7IKbHBxpXw=;
	b=C1aHQHItuuYhxumTNhHHkI3y1qiyC9h45fSCjQ/6FTaOj7SM13vXQKbYNt2Hhju2w6S09K
	7Y0ncs2fwoxNqCeU/el7/wecKyZDTQ3b9Avhf97t1xyMpalmIx1qjV4gTnka4DhTUQwIVD
	jKeDkaCMFiG+oHiF3dJzpQMG0sLThfU=
Date: Thu, 11 Dec 2025 17:11:01 +0000
Content-Type: multipart/alternative;
 boundary="211ed89b-1b60-4f09-ad9c-1755bc267767-1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <ba92a68ed433326a7d722b7bef12d2e0a17d6ca7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm: zswap: delete unused acomp->is_sleepable
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Chengming Zhou"
 <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <20251211025645.820517-1-hannes@cmpxchg.org>
References: <20251211025645.820517-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8832AA0022
X-Stat-Signature: acan47jmbjd3a8w66hs6cyu99ck7zjc8
X-HE-Tag: 1765473068-473991
X-HE-Meta: U2FsdGVkX1/WksqwXkAOFQIrrjewEycKKSIpmk4cV0bZNoz/dUy+Rf+Vqn8FL1nANQNgjXl01AEK6IiT1sXC6jx646rAxZYmQkbDZeZcGvLuX6zdWJgG8YSznVnK/h8tWnwPOwQSBdttU2dU5hEN3Pui931h/oUWHxxeFZg2Xa35Vt4raQe4mLPIR/kvulkvRqH9pxNwXaF+e8Z3DaRdZVyG7XCH5tw5ZQ9CQeyvEkxM0rpUDelMQm6nuuHY7pdnQLn91Se1RBI+3sACuqTjiXMwEf/oTejACjqBdJ2RZ3Qz7fh7NISvNgfHTfaR3RJnQI7rLRdY4geHxGY4kqgm2CUHCjkWgdsO82ONMW8Eq0AGSwdVgbYHcliDYKEOO3QY8p+BknHOCRWKLCyZuixqmIiRk2GGFHJlyuctPdNaB/q72vfQhvZz4EbxCiUd5tMzDoiQ3TvsrGz5nzVfFKbC35diV2sl2n/B2nRxiojBFsw11CWeD2pfnRPE3aTCGkeny/vhPt4ss3Jn68LZk4CApAl/mIOcuAdQA42HmlK5xOZOjpkFSaJ24vQX/fV2u1HUhQm/0hczhvvm2WnkER/E9a2sHEszDD3gnkTv2jA07jbm+2K+6XYwi8UuaUeGD/jllbe4V2q4H4PwYD+IxpGg58HCWT/OPYxzyumenpwq9iW1l74zCfxuCkhqop/UdmebJqXW8QGX2ufwMTkW8lm9K1Bx/Ujm3J63BSVYp3I0VcOq98wuuoOdjpbz4+UnZiRjOgQ7uVAbqaB4bpdchWdyVPSg0I5U8QP3L09NtjOwyBTKPsDyo4P/GSXK+/qdwuEhgR1DNVKbMx+Ie4aC5iVOCKlp4hYnhrYCKskYWVIiPxaNFlHdnN+eKS8+jSa+gzAXrb/oS20z4IKVcZdyLN8H36AiGjmfnC4iNd25Bf9XQYRGH9mX5LfN8M+4RPU0uvNMcQn1A7gFylUmhK41wmA
 3QkfggdA
 zhAhIhxql66RWvSnN4KSvLh0LPR8e6+xNyDErYWKKQts3JIbm8nE15d7apz07dhVX9usHr7PvVrBfe9FCQwMGtGqwP+kODCNuhoUfLMLMEuy9NBn0gFXN3XmSi6aSj2ca7Mi6pW6T8Sr9zn/YgJ4pOfyQGLyjhXiQbaSICs8zh++FTP3A8sZV5jyy3c4IM+IEuG3DZAp/Oyu7aOh2ykxKuFCpeqs8zLmiMqolz28BV65FfSY42n7Ch/cIBXevUjCuEHS1h4/gbBmsOImIiPd3tsxEKglD5eKMPMJYSbnZTWSsKjCdnjhZIbwIsWe8HvhUkk3pUkMDqa8iYZnd/DEXBgiLSef7W4sWm0u0agaqAEaZmfOo1j927az91jbFXcbETYyqV42mOWm+nYPa4dUZREcQ6zH0VkkMtFfo0UzJIuUS+sUe4XnIt5MVX3z7l/TFnSbkkqQwcSBF435Cqy8ncCnBexiulfSVohQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--211ed89b-1b60-4f09-ad9c-1755bc267767-1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

December 10, 2025 at 6:56 PM, "Johannes Weiner" <hannes@cmpxchg.org mailt=
o:hannes@cmpxchg.org?to=3D%22Johannes%20Weiner%22%20%3Channes%40cmpxchg.o=
rg%3E > wrote:


>=20
>=20This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
> read/write APIs instead of object mapping APIs"). Drop it.
>=20
>=20Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>=20
Acked-by:=C2=A0Yosry Ahmed <yosry.ahmed@linux.dev mailto:yosry.ahmed@linu=
x.dev >
---
 mm/zswap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..84797ed4d3f5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
 struct crypto_wait wait;
 u8 *buffer;
 struct mutex mutex;
- bool is_sleepable;
 };
=20
=20/*
@@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
=20
=20acomp_ctx->buffer =3D buffer;
 acomp_ctx->acomp =3D acomp;
- acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
 acomp_ctx->req =3D req;
 mutex_unlock(&acomp_ctx->mutex);
 return 0;
--=20
2.52.0
--211ed89b-1b60-4f09-ad9c-1755bc267767-1
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><head><meta http-equiv=3D"Content-Type" content=3D"t=
ext/html; charset=3Dutf-8"></head><body><div><br><br></div><p>December 10=
, 2025 at 6:56 PM, "Johannes Weiner" &lt;<a href=3D"mailto:hannes@cmpxchg=
.org?to=3D%22Johannes%20Weiner%22%20%3Channes%40cmpxchg.org%3E" target=3D=
"_blank" tabindex=3D"-1">hannes@cmpxchg.org</a>&gt; wrote:</p><blockquote=
>This hasn't been used since 7d4c9629b74f ("mm: zswap: use object<br>read=
/write APIs instead of object mapping APIs"). Drop it.<br><br>Signed-off-=
by: Johannes Weiner &lt;hannes@cmpxchg.org&gt;</blockquote><div><br></div=
><div>Acked-by:=C2=A0Yosry Ahmed &lt;<a href=3D"mailto:yosry.ahmed@linux.=
dev">yosry.ahmed@linux.dev</a>&gt;<br></div><div><br>---<br> mm/zswap.c |=
 2 --<br> 1 file changed, 2 deletions(-)<br><br>diff --git a/mm/zswap.c b=
/mm/zswap.c<br>index 5d0f8b13a958..84797ed4d3f5 100644<br>--- a/mm/zswap.=
c<br>+++ b/mm/zswap.c<br>@@ -141,7 +141,6 @@ struct crypto_acomp_ctx {<br=
> 	struct crypto_wait wait;<br> 	u8 *buffer;<br> 	struct mutex mutex;<br>=
-	bool is_sleepable;<br> };<br> <br> /*<br>@@ -781,7 +780,6 @@ static int=
 zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)<br> <b=
r> 	acomp_ctx-&gt;buffer =3D buffer;<br> 	acomp_ctx-&gt;acomp =3D acomp;<=
br>-	acomp_ctx-&gt;is_sleepable =3D acomp_is_async(acomp);<br> 	acomp_ctx=
-&gt;req =3D req;<br> 	mutex_unlock(&amp;acomp_ctx-&gt;mutex);<br> 	retur=
n 0;<br>-- <br>2.52.0</div></body></html>
--211ed89b-1b60-4f09-ad9c-1755bc267767-1--

