Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C42FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB556B0005; Fri, 12 Jun 2026 10:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C226B0088; Fri, 12 Jun 2026 10:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972286B008C; Fri, 12 Jun 2026 10:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88E236B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:53:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26BCFC0152
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:53:41 +0000 (UTC)
X-FDA: 84871554642.10.FC2AA98
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 515F38000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:53:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VNLb1aNa;
	spf=pass (imf02.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNJC2lLL+Mfh/+Eic+aZuLdpYzJPqneDQv8WwZq+SCI=;
	b=LLAbz7nmUshaoXDBFvx95WM22x0l4qdESYqavZ4pSo9+9rwtcNRfqAufZlirJ1xjr/NVvx
	4nwIPA/EU+u9wNrhc3sPoWOTKr4BuhRJ32rYY/V6FrdiazrwidqR/vz1SzTJRcb6UGU3Lu
	A2r5gXTzjBgeOaZUZdKlW1fgSmtYUEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781276019;
	b=oxjmx4uBjFXWX55DDKW0DHCp1Xj2vZaCuAKHKg11MnQq2vmkkPnBSwqzbm7mdbq62+HEih
	XELm24OpWvYAOd5bU62sLN4SSMU/ppw5OGQ2mN9/Qakj+cjBH8wdO1xuyrnSDDs8D4n6+7
	FTcU3FC1BoMh/WlY6nbBvSgydDoYTjI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VNLb1aNa;
	spf=pass (imf02.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781276017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GNJC2lLL+Mfh/+Eic+aZuLdpYzJPqneDQv8WwZq+SCI=;
	b=VNLb1aNa9Hj3sTq0ZxGXe1rCXnudw19/YcDq9Go1CTfcnSmedKhKgU1WXzGWX2S/O3VBaV
	PaaE8+mjNgr1fgbssyHTDIzJk8bTmggtZJ8ZTz5KVmJ42JPGDquZxlFzXZ1FWS5/ntV2pd
	Ar5z07KkrZ8vxM6qkbwJd84Q3FRuRMs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 14:53:28 +0000
Message-Id: <DJ75N99GTI2T.3RLXWJLOISLH8@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 515F38000A
X-Stat-Signature: 1itf7xg9j3aadp9scx599bmq3fbw9m4k
X-HE-Tag: 1781276019-384932
X-HE-Meta: U2FsdGVkX1+HAVVsp+C03jJR+EeiqQx0ptDK/3icPQYUhG/crI6tr2O9BE3qc28bP9+2/VBtHz7kQxME/ctAhD7AwGnheoP/MTZka9gvK38Otr+3IBYoM4aGyTo9e15OHFt4wx5cRz0GVJDalIH56kMzpj7Ybs4i4azpVdr/pjKdTXSK1VwdF2wQwT5LrFEPVArW8a1A9fGnmnxRb6zpBeRZw3r5V++REmaXDtIOgYpznhu9HidKKeUaO6jf3M5hOFGAQKsda5QyMOW8WssO9Mf0s9tpWelGUBRdWHWKgOkfAM3pDrc5hvITya8o7mdtAxg50zTKwP3ZIaqA/SE9OMX6JUP1mkL8OWEn3884IBk36QJbN/qxlLfa05vSiAyrhJx5ZWLAIvtEIPVSH9sm4iU3d8HO5v0bZiE5cDL9DGmUI6WxXPU5q1xv3CiYm6aREyndvoyzHqSMWmTB/MGw8LfkKRIpt3TGcC4lEgZSIYA8nH8UaMWtU0ay9bsjRLhn+jHnnXf9kWBS/9Nx0JcdQsDL78zgv4LLTfqx4tON3m1p7SMRRLOk19uXhEWBLKyKzR2Had0ez5c9TCJ/SToyHGthZc7bpBYv7ueW2ZFRIsF2grA+tl8KEQagO0Y/6gVx0KkeAk7qhi3utbePORDeBoCCRgXBTbt7UxvsYgEOsRPunbRvgckTdT1bHWPXyaba99MeojGGMRyJdH47IMsegdCIDKbGf7tVtsPKe0n6oP1HNSjeHoCrwkpmxIylKkA6ojh71n4XZ/a9iqVTYV0yrlFK7C9qC6y2nK+dcahCAyggU8h8HN453P2JaPG1CaTELlzqf3HskbbezOJvJtsByyA8klXxsx4FwHskvF+HrJRZTCtj8aY9OaK8zYnKixPI/wjQPeYGLGhd22fZ+19t4Nun9A/lMMFEH9FvWW5uYwXksPhZqf0tnFmRqZFmM72Qof5OT520RMWXWsIqGFT
 ZzCdkDFB
 zSFLb+FL8slgknUMM4lsz6Qtuv4AyXWwmP5PVxrJEHjiwhZjwaHE4afwlmNvXkxZ6/UObOALlxZOyTbYTTxVaYGl10oL4k3GNyf4l4ebSe8NgMqTdoXGwKaS9G65/+u4oI996Gl/qH2ltnN1yEX81c9xtpnuMAgCR9oStI0cKN3lHqvmK2rvlJXtj4++cnyfsYHLzEKsxo+xtM0Pi/bgPyNhlz6Rkpm9YE7XrRP1IsKjlT1MNjhemXmLkwcuf1u7yAUrz3f1/ebJ03zZmtauiE5vlwsTfvu3l8fi7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 2:15 PM UTC, Brendan Jackman wrote:
> -	/*
> -	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
> -	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
> -	 * to save two branches.
> -	 */
> -	BUILD_BUG_ON(__GFP_HIGH !=3D (__force gfp_t) ALLOC_MIN_RESERVE);
> -	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM !=3D (__force gfp_t) ALLOC_KSWAPD);

Agh, alloc_flags_nofragment() needs to be updated too:

diff --git c/mm/page_alloc.c i/mm/page_alloc.c
index 9e1949ea13a6d..0111cdbdb5321 100644
--- c/mm/page_alloc.c
+++ i/mm/page_alloc.c
@@ -3739,13 +3739,10 @@ static bool zone_allows_reclaim(struct zone *local_=
zone, struct zone *zone)
 static inline unsigned int
 alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 {
-       unsigned int alloc_flags;
+       unsigned int alloc_flags =3D 0;

-       /*
-        * __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
-        * to save a branch.
-        */
-       alloc_flags =3D (__force int) (gfp_mask & __GFP_KSWAPD_RECLAIM);
+       if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+               alloc_flags |=3D ALLOC_KSWAPD;

        if (defrag_mode) {
                alloc_flags |=3D ALLOC_NOFRAGMENT;

I guess I will just send a v2 once I've tested since this is pretty easy
to review anyway, any objections?

