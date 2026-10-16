Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF00CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0046B0088; Fri, 16 Oct 2026 00:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081826B008A; Fri, 16 Oct 2026 00:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2C06B008C; Fri, 16 Oct 2026 00:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1C8C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:38:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD12B1C2FAE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:38:33 +0000 (UTC)
X-FDA: 85327233306.06.2FA1C47
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2348D1C0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:38:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=cBFadL0t;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akUKtCOOrlEpH/rN6LN5UUaba4wuzZss1jd/DErEyE0=;
	b=taGBpB0ecymgy66r1GuZUuCIKfDHEqJgmuwmjguey/PNw896OKoQ/mt7IKJfVU2Bgh20XT
	VlJpXLhPrHeBvgcEsyBlYuamBAJ0cy6UJ0R8mdU2vaX3f7plKNys5/xP4Ss9NLGzCOolAG
	M3OmZSjbS8dSQbemknlR9pmLrTh4v48=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=cBFadL0t;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125512;
	b=cuPpcPBMpUwNVmvVsJSo3JqejRV0scyJ2tjP2N2iwqvmLRGkVNEeQeb+IK9vjdNzbaghD/
	gKm7aBGv8OkLDqtdQCyHuvhJfIzmRqjUQyuu2lYValJd+seyDKv1Hws0TCEAvOLwmbfRz8
	OurycP8NjkZL1v/iukFjKpvNADZkNd4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=akUKtCOOrlEpH/rN6LN5UUaba4wuzZss1jd/DErEyE0=; 
	b=cBFadL0t4yG1/WfEDOQ8wKVQA5t1kSkWJ6i8c/fYSi6+wTEDmU9DwCigIsKPEGwiXfxQUzXBhf5
	t2q1l8jhTKeBxdnxvKNIqyLKiG4iG1V0U5c/OtXIMST64/XMoV0VfS21DblRAuqaWehexRdx2ZMiO
	OGav94vPTkoU8lYH4yw4AR0qKpKvCXf79ZiXX7cIVr1fPgW54RMyZddGEasZ3Q2g4JasxGq2wfPpf
	e3hVUyEYtRHsfqmhCDqe5qoVOKWTp2DpBjMfJIfO28SCOhWEDm6bRGdXYKWdXWmSu3pioMDG1jpaP
	WRqh8ngI9o49wRgKMNSC+EFBH53QMGcNar/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHZi0-00000004QCB-1BxB;
	Fri, 16 Oct 2026 12:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 15:38:20 +1100
Date: Fri, 16 Oct 2026 15:38:20 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atGqPIpUfX0LDokV@gondor.apana.org.au>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com>
 <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2348D1C0009
X-Rspam-User: 
X-Stat-Signature: bb37mizcf8rdmopp1gm8q3hrob68um49
X-HE-Tag: 1792125510-69754
X-HE-Meta: U2FsdGVkX19GStYswAjuP/AmsbcA7Z1Jgoe96xOCN7trGzrpjB+EhByr3QBR3xFuDBGSaYtNzTXmC1BJJarq1jfg+RfUjf79eMaP+BItU8wrGq+VJxzM6Yuu8iFRoUJHZM2LKj69Jwo56Jr+a69u9CmH229+Lh4nJdv3AunMIqMMz40MsC+zdMJbG0FW+ECS5H+zEfcl/fNdOXVo32jBVH2ZRWQiTYgoMq8OJzpZ2b9ibG5f8c1ZKvTJ/jMpqP3ERsqSu4PPa8Re6hwCsBiXEA3EQqD49QE+qmICCTryZwnQmCxO+RpXc88M5HAPI/XJg2ja6kSiIpGoXMU04pK4jJ6PYMK7zWLVkAxd7h4bP3c6Wc5SNsmBQXXDwLpReziiuXuDKC3Wk+gLGZ86669mMWYfUCQed/Tkb2p4HHw6o7YwiDhQWTAkiLyJ1Dl2DkQVoLgkBn4t5udDMcexYr8YUY5eH2BrJ/p5wxb/6JYajL2UcXRs1WlxEsxEyIhDi4o32cQVlDZY9263wbtrgDvY+Uw8JHf3pEUbzMDuKlE9nzaNR/3Yc/z8qO/U4Cb4sgstzXSAxxB4xKZNvzu+RUqItRU3YLcZD/ytUkP6hfe/hjcHI9lW4zEG7w222WNHkV63dDpz5jv82a0GH2bQlbmUAEDGuushxpAahjKZL56hVVmaJaZtdn5tbwnZ4Uwstd2Zfy0vjXIeyeYdKmXptR0EIqqJ1Ek2efvVyheHeLosd0tm++xmv+5CovJE2WMeCwUCjroWVtOK1/b52sMNqmY4vA0GD/o2Xo11mHa+dmTL6eNk8lQdyNBALAj6oMAR7OyvTtvrNiobkekNvl3fhqc+c4ns86hkl02ObbhL+IkXeHjV23ZnnQufKhP5gCSqh1cpUjlVWjmcLvkVVGRMqo90y+94ydciG6/uTIx96/KEoS8/2ik7yRN+F5INFCq5OSz+bxguzmhxBe91XzjZW5L
 ewEJn39y
 eDlZjYbk3I6FonVxaVp5pMIMzqUma9tAU3YtpBq8Td/B1yMyoNdFamjWbdlnTZ0McKhjOcDgilB9UXUh3HOI36YakfFHNYj8ZtLUluSPvIF4LsTa+z3QvQs27dfpeAxVWNuSt1NyyBB1g0kpDrGpZJpzxwmt3hQYcLu8seanZU/zm46hnAQTwHJtRdCSl8cXcHAd7ZKLuZWp/iVXagsCASsewFu2FK/V5YifqxvnHig8XmblZGEhm/TgG0/OZml3Th/TPwzWFJZ4tFV52JW+R9pzYz4ksDADkUz00Pt+u8aEYP+Yh7IGW/GmbSFEv3yA29+i6MiK2radJUHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
>
> If you are Ok with all this, we will need Herbert's Ok for this change
> in patch 3:
> 
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 192ea996e779..db8e4c82b900 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
>                 return -EAGAIN;
> 
>         if (likely(req->unit_size && acomp_request_issg(req))) {
> -               if (!crypto_acomp_req_seg(tfm))
> -                       return acomp_do_req_chain(req, true);
> +               if (likely(!crypto_acomp_req_seg(tfm))) {
> +                       int err = tfm->compress(req);
> +
> +                       req->dst->length = unlikely(err) ? err : req->dlen;
> +                       return err;
> +               }

What if you put this short-circuit into acomp_do_req_chain instead,
does it still give you the same performance boost?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

