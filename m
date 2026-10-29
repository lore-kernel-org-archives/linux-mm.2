Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E31C606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rqECxI/h
Received: by kanga.kvack.org (Postfix)
	id 4238E6B00EF; Thu, 29 Oct 2026 02:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC586B05B3; Thu, 29 Oct 2026 02:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274D46B05B4; Thu, 29 Oct 2026 02:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16B26B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:04:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FFFA802DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:04:11 +0000 (UTC)
X-FDA: 85374623502.12.746506C
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 875B9100008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:04:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rqECxI/h";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793253849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
	b=IirlOIff3INF7b0HxzcIMauWCupmQAMcd8pvCQQRggz506Y1cYpUBIbmA/duT07aIXa2Ep
	QgAR3grE/GwT7jAG6EbpHDQPUML5dvd9QhLp0cz1F3J/fOdNsu8MClKvgDmvhml4Ezinr6
	AXycCGEldwQUNQ8RTGGb3OnNr221JKw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rqECxI/h";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793253849;
	b=Lwh6oxCcmvWRmh7ogmazYkwQqX4ieBYiwcYOLHP4oMtoegvWKeIQMdLiOdSg1AJL+x8UpR
	Q4tALDw3ldepf6eZ3X8iHEcIxyLDavVxzvwSXCAqXgjIHQNfCLayuR/fJ+CTlyOBogkS4f
	lCiv1PO7WujUu90ZkKHF0/S1uZuouak=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcb0f245e0so1689269e87.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793253848; cv=none;
        d=google.com; s=arc-20260327;
        b=UcP156q5XH4vjjIIEe+T5a9ZX6Nh6fz8HIQQFoOa4sWC3o5zTyje2U9wBhkOyYorEw
         UBzpbtMsEjy3Jxja+4JctkIWGcUtSXlwVCKSFi3S7HL8cZL3jGuxsVcPfeagty5hvZdn
         e/JiN2snTBhkOdX54qOBJIuq8/mbztOFN6C4WqM6nRonCKxs5omS4+RWHZofX1U3uTc0
         AsgFeuSZ1u7JN7IYn/mKDyGehVtal1FVjGmI8PNSdA4xnSczLrjpBbExNdJMkkYMqy6V
         4K+xT0auj5qxmEUaMWZxsLRzgXdUkYqxGHexS5g6eIzdezVBM8/IhebkIjbYQVhbjWE8
         04mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        fh=v1jZnaWnWhQjr4BvuS81rLKrXTnxZDDbmQPju+n3B/Y=;
        b=OtmFmJcmKGJNiQ3DI3jLsOlWKT/nEoBuVH5kGq4PJA0m6QWQ8Fk0zqQ5yF6MEg+Ure
         Jpqy2C3Tdb8QVJFJRm0wCqurArxUG3fJikxEZ20j1qtCy2Iv3qJ8pXcMFihVAy7cXK8d
         rjvbcQjvfXiPtXMdQY5gKlMJZLO0ZmE4lyKJfFqOddtYYTijgRd6d4a/g0J+C2T0neIz
         zDPy14wLS3FjP2vjQqRbCEclMBBzeZ9yQIuBbdSdce4nDDi19ZuA00JK1CQJ4oalGgGP
         ibf9MKhHd84IVTjA2aZeWix+a2/WgvBTa6BQP90Um+aAL1x7Kw9qvgHYgMN1Ge2JHJeh
         2COg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253848; x=1793858648; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        b=rqECxI/h6zFnL2ncA8jQbivo303PxAI6aaevfp+5POvkFGVoK+uKdSMcrdccen+yNZ
         SXYUd9lXD5RuGTKy8/sImjtrjlkKJe8Q3BSnJjnZGPgsQo3ff+CKZtmUu77P0IbDzu9z
         Oal8pAqgbeWCbW7xhr78oMMtM3zeKbbN9qSoQZgTphQrvC5bsGJReGVaQClINazlZMa4
         MXuf6KEXwuWpRsRZlOg6XSrc+1ZiPIzd6VUPl6FugWeadbEzwJyeI0SdFybuzs0dddYo
         7sLROiyW52FbfquWNF0iYrwEBaDqvXkYTFH1Yx5DaWXKa8q4XlYOKce7bQabu5ohQ6oa
         hAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253848; x=1793858648;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        b=Q0v6HBaKa9VWHFk/KuM3S4/ApGDdP3BY2zs42JR0MFW790ONTfH+uKyixYKOELXQGE
         r0oPmOv/KQln3v/NGVBPKfBxVu5UltcUQBaX9+34lQ8+84hFUaR1vIjP4bXwOC7dWI5R
         PcR1GC6L3xB6dTgFRMToQbcWXbb7UoGzci8hjZyd3DNftzQ/Ute9sDZ/sPVZoWrHjgDQ
         1CuUvP0I7wAvg0Lwr5GB0EybqWz7wBywmC1qENHHIFveUPV5sLD138+icyRQfzc7bH8s
         Od5imtoRadumaZOyXDVLBAhwoS1zLTyxH6Vg0A+Vqft27oUjL+SDQiDcxeSwcI09oieE
         u7vw==
X-Forwarded-Encrypted: i=1; AKwUvBwkwJQaJGnnESqTH18as1RWF+/lQJwo71PW+3Lu2IL0T2YSNgFxqYPG1F8zOQYnhqYbxUVQo8NBwg==@kvack.org
X-Gm-Message-State: AFq9FYLl9YO+7lh0pKj39Nn610v+wJaw8cKdM5Myg3Dy0vhBmkmmJx6b
	WI+BmI7Xd5f9K2JKIUSRu7gg7eT1wz0LwVcHBM3r+BEtjtErSfvSEZSI0bPDWnZD/pznd/nw5dE
	2ve4VkabZpJmckQp9tYK83VzgNGEXmQs=
X-Gm-Gg: AYBFou3LN1Bfg3Yibh/D0a8FLRK49QR99gXcdhvgAVxbAyrjbW45nwenusPqFgPQhWy
	Qq+7nAvdU/sQhvxikTfSCYmBvaC7XgHuNeimAXzDw6cbjG7qp3N+brySSbnBXvDUD0pAj5BBS8U
	W+LNrLzy55xGCCtkIgvNbVNv2OSb68BDtQcKeZUYfAkTrbP1TRSfH3Gn6+IvxaqnhTGbxvBp7PM
	2cYk3Chu6UAMEwDECxMm+3e9WghfapPESVCFtwh2W0d51ZuZDdKdRCSsqE/uFtgAKcu+aRO7OOk
	XNZvGICaDxuh5GmJZQ5oJVu8K1RiYGMdZ0+/f/+OLcKXEV3Fso5n8U1vMQmURSEwW/ABvDiqzdd
	KCZm5k162Dl9S7J0Y0RCYBr+YzTO8iRp3wQYL
X-Received: by 2002:a05:6512:3f08:b0:5bf:a42d:9115 with SMTP id
 2adb3069b0e04-5bfcad31a26mr1709830e87.4.1793253847632; Wed, 28 Oct 2026
 23:04:07 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com> <auLbyon-KaV5Sw5_@gondor.apana.org.au>
In-Reply-To: <auLbyon-KaV5Sw5_@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 23:03:55 -0700
X-Gm-Features: AclHuK-DCy2JhmM1ocR9rPIODBB_vde0-q1YKusn4WlZiYizVxfQyHZpW4RBSmw
Message-ID: <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 875B9100008
X-Stat-Signature: 87tsnz1b1duai3tr55ttkenfrkxrupzd
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793253849-719550
X-HE-Meta: U2FsdGVkX19FBfo84DI7Ub+sC6KvG3Yr6eEbhfhAzdlboxzNgTmB77xHi9KYAb6zHzANcqK4j+cMc21UJnW1zB/MC78JwwRVBL3bibIviC4JRtYLdtnCVCj2bi+jwQQdY+KJTgwB+pVec+qmO1CGPdQDMR8kfjXTQGZ5WH96Qd20z3gzXnWnXhb2Q82b6Vtc29viwD6GoesEaV3IRyXePG363DO30cNBu7FjCTNWo8UIC0adkmjKYn791g+LTwvU+Q44PdeSYf/w9DbXruKgZTeJ8sB3G63pfSCdHspBYjOW+/9bHSMYaCpXppFmpoKJv0b/c3b5qAkmY7ZPsu2+dwe/FtDEWhb3+uLOhyF2HThUJqG87MB9+oo5vV19f5MEp1wjo016wbi8XdZnYVJvEVs7tctZJ1xddCUk60YuNK7f5hCA17x7CMDlboGIM0dyyKO75ZAQ8kES4bFs01sTJyBrff1xSP8tb/B3uLPt02pIaFckKzwM4qMXq/Q7FgqS7TriaTU61UgkR6lKOI4hlC7HNUlk/ntEPSTpOpcJNxzltEZ1td+aFZAH8KCMr7mlQg6EaOqiYzvnQmH1S3KpCbPCoHrAzjmWvBDzN0L1o+8OmJD8g4ShrncYkNV1rnHCRO++Jc3E1iYzxtbJq1Nh6Z/RxfuMUcliy4PCIEuXMHVxrm1MTLOCuVVYPK3Kf82G5acNjh72bQsmtPBV24ffDza2jMpGXzgSkY6N6imMCrh2upmZt7N3GxL9g4+i/EvsXdHeENBDl3IkwctzCsUblCg2xibkJEdqF1i/3jD4RhG3AVHelu8sJsMs3GExcH+pRB9r+sBvZUoTz+7R74Dr16L/8EalFmCuRrQnRBdf65m88iZ6EcjA4cs/+1VpBqlThK9CIbk7KR62aaRcngyDuXF+0xCdunrkiFDgk2Vmkx5Gk5Qzd7soCEgM7i57G5YTuCkKfLcA/A98KvjPQcm
 N2V9WjSO
 xiNHmGOt7C0Mz8e+TYdWJKt/i/d6+GVd9ZI/dmEWtkr4xQtWXxGHrOwxlxXUg60e77h0tNFMeRpNPf5h6jjsqKAQwOrabdLFLv5eoABUDEW0+CeT8cYFRrQfJp9Hge9XCwYxxZWwdi60LIV2Am/rjqkkmjw5CvPPYQPWw+V5L25O8QkGKQE22nn2KVKzNCSfygIw9l8aKmZwDWSznviNsgs5HyxXj2UCCElBYKxT8LsODx7ZBDTYs4c80Oc7/zQBUaEWzqpy5DIc89AdI/HB6zC6h0DQDniqtTPsOuNvue1qj1coAyPBb04lKwg5w8q00hArPcKpAG60+jPdhcOTPj9lTYbjdFoUqlIJK4KR0/IVJY3UG6091pGpuC92ddwO8mNrRuiiwmAaME7baZYhxXTVUSvpkvp+kpjOmNZ8DRAvWAno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Wed, Oct 28, 2026 at 10:09:35PM -0700, Kanchana P. Sridhar wrote:
> >
> > Herbert, can you please take a look at this and suggest what changes
> > need to be made here, since you are the original developer of this
> > portion of the patch. Thanks.
>
> I think we should get rid of the changes to state->flags in
> acomp_save_req and keep it in acomp_virt_to_sg.

Ok, I will make this change, thanks!

>
> > Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
> > !acomp_req_on_stack(req)) here.
>
> Why do you need !acomp_req_on_stack if you know that the tfm is
> synchronous? IOW, how about just testing !acomp_is_async(tfm)?

I was under the impression that if acomp_req_on_stack and synchronous
tfm, it would go through acomp_do_req_chain(). Please correct me if I
am wrong, and I can modify the conditional accordingly.

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

