Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1238F3D616
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 17:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45B86B0092; Sun, 29 Mar 2026 13:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF156B0095; Sun, 29 Mar 2026 13:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970576B0096; Sun, 29 Mar 2026 13:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4FD6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 13:32:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8BD21A04C8
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 17:32:20 +0000 (UTC)
X-FDA: 84599794440.23.EA700FA
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id F10441C0002
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 17:32:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MzT/8YBX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of demiobenour@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=demiobenour@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774805539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf/N5/T851ta5P4Z0W48sBbwNdoI9CHZu3wQNdOpQeY=;
	b=ud3uyqxGpd8EgsWfmqFdu8J8mMtLd0syQni8FOPS35R5rvzanDsXdKRJryFJT7m0K3kiE7
	+IDlHqboKL6CwMB+rLn2bqtHuKuQmGqfPB0az98Xxd+UxkZnSGQCjy5q6C9rXZtKwxNhWu
	SHQijKfjKX72ulQgAUiH0CMU60Gv3ww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774805539; a=rsa-sha256;
	cv=none;
	b=c7+hm8o/aTPe03Tp0+8Kdy4FE07Ne/Y6LOo0kyzKip6kFi2zPkezBasSbACP6/3vqqmY0L
	WBMlIPn42g96h6JHui3JKC3gGBGQGbxVkzJ9Q2g0Vj0qwsBSXfQG5jSPUu+rUZo3J5nU7I
	fCqp5zo5cN/+dqlYyYFkvFWOjVRyULo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MzT/8YBX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of demiobenour@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=demiobenour@gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6501d242e2fso13914d50.3
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774805538; x=1775410338; darn=kvack.org;
        h=in-reply-to:autocrypt:content-language:references:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nf/N5/T851ta5P4Z0W48sBbwNdoI9CHZu3wQNdOpQeY=;
        b=MzT/8YBXCwrEIPEwnPlrQ0OVmuA+eyfgVifAkkyOU5YzzrGzHI/a0z4OL1IQtwaTS+
         7nZ4clr10/vA2RVnBTKepF2NJnXr3pNBFEe+0a5G6JX9274DE7twqDni1/xTzL0unfv/
         wnHwIsaORtqlcYPbjj9hleUByei1AdEb63832vmoHhyZMi0vDkIrZydVvy9/yFhV7e1p
         lgrwQR+qK5WRGFoE4aTj4H7Q3LJ7M0pxHH9mep6cxlQtjpN+Tn+GFz8UjKIWzVtQF13B
         TvMPtb/z8OMlvlFIp8Q9MFeoRX+vsMnw7ofZKiWHNpKOOqapv8OxB5obEdy5SnPs2hGX
         Ve4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774805538; x=1775410338;
        h=in-reply-to:autocrypt:content-language:references:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nf/N5/T851ta5P4Z0W48sBbwNdoI9CHZu3wQNdOpQeY=;
        b=FP084CE1HzxCsiDgMrkInh8W28t02yVnKOdL7BxHyGu72h1uHeaKuDoNKzA9HeI5Hh
         rdwOyUkreAEdjwASt5vDy2S2btdLP12+6idBaLVUuUEC5Jikhlw13ujqn3HJjSApisB5
         WbAyxK/5i0lJlsJV2WMNrk9YJW4oMRGluUY+1Bo/uD+Na9CJRZ1/J/hM+Vdk2tK0czm7
         uLJKorFuO7r0AOj3D6L9Eo7HXNBpBe5Fo63KgKxNJNUDbQov2EabfKyDMNrybx4cPEEQ
         mLksFAxVPGyNaohfZr3e0lK+qEHJO0J87Cdt4zANtQK9DPSziBRa9pKzvukInzQ4BC/8
         kQng==
X-Forwarded-Encrypted: i=1; AJvYcCX2gIuECoq3eK+2OI+cH4tdaq/tEEhyV2NupODkr7hdN+JT9Z9IA5439Ic4CLUrqDcsghp0I9Ehbw==@kvack.org
X-Gm-Message-State: AOJu0Yy2myV257aB8kEbHdy6tpv53D7/RoBu/yhIbacMvLtQcwW1tViP
	iVgXVc1Dpzz5Tj050WsdLp6pBKGtHlV/7RxH2/+/rDSQnhCXKWYWQi+F
X-Gm-Gg: ATEYQzxJ/C72bMzYjjSoC55Lwr5iCiVVWbd7bkbzt2b3GYllsDX4e9oXlx8/3qJI4f+
	udjhaBhfqX8omRQwMx21mmDXa8KiwlQXO5159jZbzAz2odKAYdqQJSO67OGgN9xw42zusftIL2n
	BWmjmiNipDGi2fVZtW+FNjwYwfsR64LYwirVjb9rFmBaRzPNUploteq1W60EoYsMghnt+JMlrDk
	j3AbC6YTI4+S3Cd7h0vSVNqiS9YEN8a3KtBheOf1rAIGhZD+e8uLYNW4fPrIW2coTTA1fAawV0j
	kOBYGEByGonNHORDuUupN0YWxveGiAYR0KlJqEaAczcSFDkR0SdjSZXGSRGebOkizYLxvC2b3Fr
	bCARl0seBMbOxXYmrVAKm/UwWCvSQZFhmKl+e37BVjo97uY6M1goq3hziTV0AHaPpUZiuqNBwBH
	k+EcUt5NN7Ug3crTQv69OVsSEMF4itZKxS/JheGfS2Ch0WL31KZDl/D711tw4yxkFBhPUD+9J4o
	2rTGie1U0adwOeen0EOPWRXYJWKiJ4xwkg95ZkA1nWi8yjvCA==
X-Received: by 2002:a05:690e:b87:b0:650:1bff:603e with SMTP id 956f58d0204a3-6501bff64eamr838738d50.54.1774805537585;
        Sun, 29 Mar 2026 10:32:17 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-148-49.cncrtn.broadband.dynamic.tds.net. [69.131.148.49])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65009326eddsm2731855d50.13.2026.03.29.10.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 10:32:16 -0700 (PDT)
Message-ID: <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
Date: Sun, 29 Mar 2026 13:32:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Why memory lending is needed for GPU acceleration
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Jan Beulich <jbeulich@suse.com>, Val Packett <val@invisiblethingslab.com>,
 Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>,
 Teddy Astie <teddy.astie@vates.tech>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49yB+l2nipd
 aq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYfbWpr/si88QKgyGSV
 Z7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/UorR+FaSuVwT7rqzGrTlscnT
 DlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7MMPCJwI8JpPlBedRpe9tfVyfu3euTPLPx
 wcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9Hzx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR
 6h3nBc3eyuZ+q62HS1pJ5EvUT1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl
 5FMWo8TCniHynNXsBtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2
 Bkg1b//r6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
 9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nSm9BBff0N
 m0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQABzTxEZW1pIE1hcmll
 IE9iZW5vdXIgKGxvdmVyIG9mIGNvZGluZykgPGRlbWlvYmVub3VyQGdtYWlsLmNvbT7CwXgE
 EwECACIFAlp+A0oCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELKItV//nCLBhr8Q
 AK/xrb4wyi71xII2hkFBpT59ObLN+32FQT7R3lbZRjVFjc6yMUjOb1H/hJVxx+yo5gsSj5LS
 9AwggioUSrcUKldfA/PKKai2mzTlUDxTcF3vKx6iMXKA6AqwAw4B57ZEJoMM6egm57TV19kz
 PMc879NV2nc6+elaKl+/kbVeD3qvBuEwsTe2Do3HAAdrfUG/j9erwIk6gha/Hp9yZlCnPTX+
 VK+xifQqt8RtMqS5R/S8z0msJMI/ajNU03kFjOpqrYziv6OZLJ5cuKb3bZU5aoaRQRDzkFIR
 6aqtFLTohTo20QywXwRa39uFaOT/0YMpNyel0kdOszFOykTEGI2u+kja35g9TkH90kkBTG+a
 EWttIht0Hy6YFmwjcAxisSakBuHnHuMSOiyRQLu43ej2+mDWgItLZ48Mu0C3IG1seeQDjEYP
 tqvyZ6bGkf2Vj+L6wLoLLIhRZxQOedqArIk/Sb2SzQYuxN44IDRt+3ZcDqsPppoKcxSyd1Ny
 2tpvjYJXlfKmOYLhTWs8nwlAlSHX/c/jz/ywwf7eSvGknToo1Y0VpRtoxMaKW1nvH0OeCSVJ
 itfRP7YbiRVc2aNqWPCSgtqHAuVraBRbAFLKh9d2rKFB3BmynTUpc1BQLJP8+D5oNyb8Ts4x
 Xd3iV/uD8JLGJfYZIR7oGWFLP4uZ3tkneDfYzsFNBFp+A0oBEAC9ynZI9LU+uJkMeEJeJyQ/
 8VFkCJQPQZEsIGzOTlPnwvVna0AS86n2Z+rK7R/usYs5iJCZ55/JISWd8xD57ue0eB47bcJv
 VqGlObI2DEG8TwaW0O0duRhDgzMEL4t1KdRAepIESBEA/iPpI4gfUbVEIEQuqdqQyO4GAe+M
 kD0Hy5JH/0qgFmbaSegNTdQg5iqYjRZ3ttiswalql1/iSyv1WYeC1OAs+2BLOAT2NEggSiVO
 txEfgewsQtCWi8H1SoirakIfo45Hz0tk/Ad9ZWh2PvOGt97Ka85o4TLJxgJJqGEnqcFUZnJJ
 riwoaRIS8N2C8/nEM53jb1sH0gYddMU3QxY7dYNLIUrRKQeNkF30dK7V6JRH7pleRlf+wQcN
 fRAIUrNlatj9TxwivQrKnC9aIFFHEy/0mAgtrQShcMRmMgVlRoOA5B8RTulRLCmkafvwuhs6
 dCxN0GNAORIVVFxjx9Vn7OqYPgwiofZ6SbEl0hgPyWBQvE85klFLZLoj7p+joDY1XNQztmfA
 rnJ9x+YV4igjWImINAZSlmEcYtd+xy3Li/8oeYDAqrsnrOjb+WvGhCykJk4urBog2LNtcyCj
 kTs7F+WeXGUo0NDhbd3Z6AyFfqeF7uJ3D5hlpX2nI9no/ugPrrTVoVZAgrrnNz0iZG2DVx46
 x913pVKHl5mlYQARAQABwsFfBBgBAgAJBQJafgNKAhsMAAoJELKItV//nCLBwNIP/AiIHE8b
 oIqReFQyaMzxq6lE4YZCZNj65B/nkDOvodSiwfwjjVVE2V3iEzxMHbgyTCGA67+Bo/d5aQGj
 gn0TPtsGzelyQHipaUzEyrsceUGWYoKXYyVWKEfyh0cDfnd9diAm3VeNqchtcMpoehETH8fr
 RHnJdBcjf112PzQSdKC6kqU0Q196c4Vp5HDOQfNiDnTf7gZSj0BraHOByy9LEDCLhQiCmr+2
 E0rW4tBtDAn2HkT9uf32ZGqJCn1O+2uVfFhGu6vPE5qkqrbSE8TG+03H8ecU2q50zgHWPdHM
 OBvy3EhzfAh2VmOSTcRK+tSUe/u3wdLRDPwv/DTzGI36Kgky9MsDC5gpIwNbOJP2G/q1wT1o
 Gkw4IXfWv2ufWiXqJ+k7HEi2N1sree7Dy9KBCqb+ca1vFhYPDJfhP75I/VnzHVssZ/rYZ9+5
 1yDoUABoNdJNSGUYl+Yh9Pw9pE3Kt4EFzUlFZWbE4xKL/NPno+z4J9aWemLLszcYz/u3XnbO
 vUSQHSrmfOzX3cV4yfmjM5lewgSstoxGyTx2M8enslgdXhPthZlDnTnOT+C+OTsh8+m5tos8
 HQjaPM01MKBiAqdPgksm1wu2DrrwUi6ChRVTUBcj6+/9IJ81H2P2gJk3Ls3AVIxIffLoY34E
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------M4itWcqxgptiTNkOr9J7EdkW"
X-Rspamd-Queue-Id: F10441C0002
X-Stat-Signature: q35ecmzmjk1pp3wrbhjrm8i7p7u8i79m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774805538-297258
X-HE-Meta: U2FsdGVkX1+Ja74fD9hRM8kka6p4ayq7byJkUCLgIO41u3w3MqR6DdOuy9gdIp8Uw80ciOkr3J/Xef7jWYiwQKrjKV2yicqhjKBhWzmY3sGdCS4OqttpQ0AC577Fhb2dYTOhMjSRFirSMs/cvT67zSc97nfA8yrCbBPSzu5MwABSgS/JF9UKYd8LSbDpax5NwahZUHBd74o+LTbazkxxc2b+Wb2D+Leug8UmgMqmcjdXFfmHunPN2fV/tG87hCuJxSsbh261nLThgwj24TnbhZBLD0vaSV5GaUDe8MM5Nn/2Bd7JKqJhZ7PT+AsL6vKWQ3yex2iVblArV/pQHvWqU50SSvtCgI2pepkDIjcOJvCpyxD+MCcXSSyeEyuDheIEXOic904pEbwZhGytjm8qChwiu11/6AoNXazxFErvp0w+8vBpnEuBn6Kt51eYyC56iSqXTlm2NwJDCLhPzyTJBcNSSkaDyiguzWvcIrQb6GyckIOBEMUZteBkAa94DnP8/+tacLTLph1a5yEQCCsxVpA/IeugJXvADMmPbuN7jeuQ2RgG5zcnTg4nsgDys/jHPLJTUAywqdXZvr5m9IALMXlmgdq81Jcj12/HbzA6Gl3x5plu5NqpmBNfSKVo4rPUVZ3T9aKq6oNu6Oizv6i4pnk8ZOTumHimsKZaqgEwcKP8Dh9DqA59R07ZA3vfsrTAgAetaNbIBjygR+EGo5C45TvOmDrN4Ghf396dspPjQPvLXbqndSIujQNWwfOYwC7z9mm7CXKdwzFwGA8qQck7ijzBhpbYozpEOO5BCi9+cyc+rv43cAi9IO8pP3fwg+V7ut6VRI1Eg/qqQOeomPsexLq8jWu559FzBJrKN/4oOg7mxw0BwH8CnFr3h5GFFPmtFN8fXEcubeoKXll7pVqpu7GtfYTjvaR7cWgH52Kri4iXh3H7h77ivbwFq1NT8wktbaEjydSyI5OgMQvmzop
 q69NPwOC
 i2Rk6vJpH07z/nBZn03ikh2pfhmXHOY5bMxQSCR567C3Y4aJyhi2cZuvTTmVKY6Tfcdo7zSzkWXUG3G4TXE354V3ha3h0GGAZfY72ZsKUHJS651FJHDTGJUsnhHl7uwSnHRn+3FnLuDoT7JCkm6kWpNGiJBc07o+2sXL9zt3hNEkrGv4a73w6BzFP95jWaRlyF8/7TYhDu6q1yab5POYOs1V+YnFmKdvcL8IX+KA8NiiYdSew66UP1uiI/Rbf69QksagndhCY5iwJrYY6AC1FUPiLSiQhGvi8ZPBMPHxoWku8LkCosc9Bq7sPre7CICUT3LraepoxLnj/Di8FzYOsVzKy2PuHwhp6gsjo7S+8Rua6LwNmB6a+sbKrHuoiQPji7oh/e5Pl+eubYVpv3pXenVr8ghBBEA6dIFiWPZXVhvuDeS6YHXcTKdAFmlz8a9fVJEXhxsdzAbm8PJznpL+t9Lqr/rlXwPdEoTL3UY22APdf7rXG+9/IL4RKqA2jT2TfnBMSB+LThorIf6USEMmCA15WiAzjB4i018A5uu1x5IbTAyXXEpcG2EJ+PS9m0P0Rbyc9LMZ+oIWF1L5oNJvgsQMBEUnyRpPN+FAGosFHrVZ45rhbUH6R2LYTUIsxoXdkmd+bHVaDo794JpB2dEloQZLyQpsIEEz+SZM6/Bdw3T6rXbV33qlr+7Csf/jNHD+NRw3IeWKqSYSWNeT2W+2LPk61/tv25CnUMR9T9OL8YSjwUyiTQE0xy59ZbkSy2VxbDncm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------M4itWcqxgptiTNkOr9J7EdkW
Content-Type: multipart/mixed; boundary="------------dTBvLoaEMmhBo1p8OlQAVFYd";
 protected-headers="v1"
Message-ID: <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
Date: Sun, 29 Mar 2026 13:32:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Why memory lending is needed for GPU acceleration
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Jan Beulich <jbeulich@suse.com>, Val Packett <val@invisiblethingslab.com>,
 Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>,
 Teddy Astie <teddy.astie@vates.tech>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Autocrypt-Gossip: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==

--------------dTBvLoaEMmhBo1p8OlQAVFYd
Content-Type: multipart/mixed; boundary="------------QekcogRZyLk0V7Vo2wvrqX10"

--------------QekcogRZyLk0V7Vo2wvrqX10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 3/24/26 10:17, Demi Marie Obenour wrote:
> Here is a proposed design document for supporting mapping GPU VRAM
> and/or file-backed memory into other domains.  It's not in the form of
> a patch because the leading + characters would just make it harder to
> read for no particular gain, and because this is still RFC right now.
> Once it is ready to merge, I'll send a proper patch.  Nevertheless,
> you can consider this to be
>=20
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>=20
> This approach is very different from the "frontend-allocates"
> approach used elsewhere in Xen.  It is very much Linux-centric,
> rather than Xen-centric.  In fact, MMU notifiers were invented for
> KVM, and this approach is exactly the same as the one KVM implements.
> However, to the best of my understanding, the design described here is
> the only viable one.  Linux MM and GPU drivers require it, and changes
> to either to relax this requirement will not be accepted upstream.

Teddy Astie (CCd) proposed a couple of alternatives on Matrix:

1. Create dma-bufs for guest pages and import them into the host.

   This is a win not only for Xen, but also for KVM.  Right now, shared
   (CPU) memory buffers must be copied from the guest to the host,
   which is pointless.  So fixing that is a good thing!  That said,
   I'm still concerned about triggering GPU driver code-paths that
   are not tested on bare metal.
  =20
2. Use PASID and 2-stage translation so that the GPU can operate in
   guest physical memory.
  =20
   This is also a win.  AMD XDNA absolutely requires PASID support,
   and apparently AMD GPUs can also use PASID.  So being able to use
   PASID is certainly helpful.

However, I don't think either approach is sufficient for two reasons.

First, discrete GPUs have dedicated VRAM, which Xen knows nothing about.
Only dom0's GPU drivers can manage VRAM, and they will insist on being
able to migrate it between the CPU and the GPU.  Furthermore, VRAM
can only be allocated using GPU driver ioctls, which will allocate
it from dom0-owned memory.

Second, Certain Wayland protocols, such as screencapture, require program=
s
to be able to import dmabufs.  Both of the above solutions would
require that the pages be pinned.  I don't think this is an option,
as IIUC pin_user_pages() fails on mappings of these dmabufs.  It's why
direct I/O to dmabufs doesn't work.

To the best of my knowledge, these problems mean that lending memory
is the only way to get robust GPU acceleration for both graphics and
compute workloads under Xen.  Simpler approaches might work for pure
compute workloads, for iGPUs, or for drivers that have Xen-specific
changes.  None of them, however, support graphics workloads on dGPUs
while using the GPU driver the same way bare metal workloads do.

Linux's graphics stack is massive, and trying to adapt it to work with
Xen isn't going to be sustainable in the long term.  Adapting Xen to
fit the graphics stack is probably more work up front, but it has the
advantage of working with all GPU drivers, including ones that have not
been written yet.  It also means that the testing done on bare metal is
still applicable, and that bugs found when using this driver can either
be reproduced on bare metal or can be fixed without driver changes.

Finally, I'm not actually attached to memory lending at all.  It's a
lot of complexity, and it's not at all similar to how the rest of
Xen works.  If someone else can come up with a better solution that
doesn't require GPU driver changes, I'd be all for it.  Unfortunately,
I suspect none exists.  One can make almost anything work if one is
willing to patch the drivers, but I am virtually certain that this
will not be long-term sustainable.

If Xen had its own GPU drivers, the situation would be totally
different.  However, Xen must rely on Linux's GPU drivers, and that
means it must play by their rules.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------QekcogRZyLk0V7Vo2wvrqX10
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
YXJpZSBPYmVub3VyIChJVEwgRW1haWwgS2V5KSA8ZGVtaUBpbnZpc2libGV0aGlu
Z3NsYWIuY29tPsLBjgQTAQgAOBYhBHaHTZ8TNroiWQcccbKItV//nCLBBQJgOEV+
AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJELKItV//nCLBKwoP/1WSnFdv
SAD0g7fD0WlF+oi7ISFT7oqJnchFLOwVHK4Jg0e4hGn1ekWsF3Ha5tFLh4V/7UUu
obYJpTfBAA2CckspYBqLtKGjFxcaqjjpO1I2W/jeNELVtSYuCOZICjdNGw2Hl9yH
KRZiBkqc9u8lQcHDZKq4LIpVJj6ZQV/nxttDX90ax2No1nLLQXFbr5wb465LAPpU
lXwunYDij7xJGye+VUASQh9datye6orZYuJvNo8Tr3mAQxxkfR46LzWgxFCPEAZJ
5P56Nc0IMHdJZj0Uc9+1jxERhOGppp5jlLgYGK7faGB/jTV6LaRQ4Ad+xiqokDWp
mUOZsmA+bMbtPfYjDZBz5mlyHcIRKIFpE1l3Y8F7PhJuzzMUKkJi90CYakCV4x/a
Zs4pzk5E96c2VQx01RIEJ7fzHF7lwFdtfTS4YsLtAbQFsKayqwkGcVv2B1AHeqdo
TMX+cgDvjd1ZganGlWA8Sv9RkNSMchn1hMuTwERTyFTr2dKPnQdA1F480+jUap41
ClXgn227WkCIMrNhQGNyJsnwyzi5wS8rBVRQ3BOTMyvGM07j3axUOYaejEpg7wKi
wTPZGLGH1sz5GljD/916v5+v2xLbOo5606j9dWf5/tAhbPuqrQgWv41wuKDi+dDD
EKkODF7DHes8No+QcHTDyETMn1RYm7t0RKR4zsFNBFp+A0oBEAC9ynZI9LU+uJkM
eEJeJyQ/8VFkCJQPQZEsIGzOTlPnwvVna0AS86n2Z+rK7R/usYs5iJCZ55/JISWd
8xD57ue0eB47bcJvVqGlObI2DEG8TwaW0O0duRhDgzMEL4t1KdRAepIESBEA/iPp
I4gfUbVEIEQuqdqQyO4GAe+MkD0Hy5JH/0qgFmbaSegNTdQg5iqYjRZ3ttiswalq
l1/iSyv1WYeC1OAs+2BLOAT2NEggSiVOtxEfgewsQtCWi8H1SoirakIfo45Hz0tk
/Ad9ZWh2PvOGt97Ka85o4TLJxgJJqGEnqcFUZnJJriwoaRIS8N2C8/nEM53jb1sH
0gYddMU3QxY7dYNLIUrRKQeNkF30dK7V6JRH7pleRlf+wQcNfRAIUrNlatj9Txwi
vQrKnC9aIFFHEy/0mAgtrQShcMRmMgVlRoOA5B8RTulRLCmkafvwuhs6dCxN0GNA
ORIVVFxjx9Vn7OqYPgwiofZ6SbEl0hgPyWBQvE85klFLZLoj7p+joDY1XNQztmfA
rnJ9x+YV4igjWImINAZSlmEcYtd+xy3Li/8oeYDAqrsnrOjb+WvGhCykJk4urBog
2LNtcyCjkTs7F+WeXGUo0NDhbd3Z6AyFfqeF7uJ3D5hlpX2nI9no/ugPrrTVoVZA
grrnNz0iZG2DVx46x913pVKHl5mlYQARAQABwsFfBBgBAgAJBQJafgNKAhsMAAoJ
ELKItV//nCLBwNIP/AiIHE8boIqReFQyaMzxq6lE4YZCZNj65B/nkDOvodSiwfwj
jVVE2V3iEzxMHbgyTCGA67+Bo/d5aQGjgn0TPtsGzelyQHipaUzEyrsceUGWYoKX
YyVWKEfyh0cDfnd9diAm3VeNqchtcMpoehETH8frRHnJdBcjf112PzQSdKC6kqU0
Q196c4Vp5HDOQfNiDnTf7gZSj0BraHOByy9LEDCLhQiCmr+2E0rW4tBtDAn2HkT9
uf32ZGqJCn1O+2uVfFhGu6vPE5qkqrbSE8TG+03H8ecU2q50zgHWPdHMOBvy3Ehz
fAh2VmOSTcRK+tSUe/u3wdLRDPwv/DTzGI36Kgky9MsDC5gpIwNbOJP2G/q1wT1o
Gkw4IXfWv2ufWiXqJ+k7HEi2N1sree7Dy9KBCqb+ca1vFhYPDJfhP75I/VnzHVss
Z/rYZ9+51yDoUABoNdJNSGUYl+Yh9Pw9pE3Kt4EFzUlFZWbE4xKL/NPno+z4J9aW
emLLszcYz/u3XnbOvUSQHSrmfOzX3cV4yfmjM5lewgSstoxGyTx2M8enslgdXhPt
hZlDnTnOT+C+OTsh8+m5tos8HQjaPM01MKBiAqdPgksm1wu2DrrwUi6ChRVTUBcj
6+/9IJ81H2P2gJk3Ls3AVIxIffLoY34E+MYSfkEjBz0E8CLOcAw7JIwAaeBTzsFN
BGbyLVgBEACqClxh50hmBepTSVlan6EBq3OAoxhrAhWZYEwN78k+ENhK68KhqC5R
IsHzlL7QHW1gmfVBQZ63GnWiraM6wOJqFTL4ZWvRslga9u28FJ5XyK860mZLgYhK
9BzoUk4s+dat9jVUbq6LpQ1Ot5I9vrdzo2p1jtQ8h9WCIiFxSYy8s8pZ3hHh5T64
GIj1m/kY7lG3VIdUgoNiREGf/iOMjUFjwwE9ZoJ26j9p7p1U+TkKeF6wgswEB1T3
J8KCAtvmRtqJDq558IU5jhg5fgN+xHB8cgvUWulgK9FIF9oFxcuxtaf/juhHWKMO
RtL0bHfNdXoBdpUDZE+mLBUAxF6KSsRrvx6AQyJs7VjgXJDtQVWvH0PUmTrEswgb
49nNU+dLLZQAZagxqnZ9Dp5l6GqaGZCHERJcLmdY/EmMzSf5YazJ6c0vO8rdW27M
kn73qcWAplQn5mOXaqbfzWkAUPyUXppuRHfrjxTDz3GyJJVOeMmMrTxH4uCaGpOX
Z8tN6829J1roGw4oKDRUQsaBAeEDqizXMPRc+6U9vI5FXzbAsb+8lKW65G7JWHym
YPOGUt2hK4DdTA1PmVo0DxH00eWWeKxqvmGyX+Dhcg+5e191rPsMRGsDlH6KihI6
+3JIuc0y6ngdjcp6aalbuvPIGFrCRx3tnRtNc7He6cBWQoH9RPwluwARAQABwsOs
BBgBCgAgFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmbyLVgCGwICQAkQsoi1X/+c
IsHBdCAEGQEKAB0WIQSilC2pUlbVp66j3+yzNoc6synyUwUCZvItWAAKCRCzNoc6
synyU85gD/0T1QDtPhovkGwoqv4jUbEMMvpeYQf+oWgm/TjWPeLwdjl7AtY0G9Ml
ZoyGniYkoHi37Gnn/ShLT3B5vtyI58ap2+SSa8SnGftdAKRLiWFWCiAEklm9FRk8
N3hwxhmSFF1KR/AIDS4g+HIsZn7YEMubBSgLlZZ9zHl4O4vwuXlREBEW97iL/FSt
VownU2V39t7PtFvGZNk+DJH7eLO3jmNRYB0PL4JOyyda3NH/J92iwrFmjFWWmmWb
/Xz8l9DIs+Z59pRCVTTwbBEZhcUc7rVMCcIYL+q1WxBG2e6lMn15OQJ5WfiE6E0I
sGirAEDnXWx92JNGx5l+mMpdpsWhBZ5iGTtttZesibNkQfd48/eCgFi4cxJUC4PT
UQwfD9AMgzwSTGJrkI5XGy+XqxwOjL8UA0iIrtTpMh49zw46uV6kwFQCgkf32jZM
OLwLTNSzclbnA7GRd8tKwezQ/XqeK3dal2n+cOr+o+Eka7yGmGWNUqFbIe8cjj9T
JeF3mgOCmZOwMI+wIcQYRSf+e5VTMO6TNWH5BI3vqeHSt7HkYuPlHT0pGum88d4a
pWqhulH4rUhEMtirX1hYx8Q4HlUOQqLtxzmwOYWkhl1C+yPObAvUDNiHCLf9w28n
uihgEkzHt9J4VKYulyJM9fe3ENcyU6rpXD7iANQqcr87ogKXFxknZ97uEACvSucc
RbnnAgRqZ7GDzgoBerJ2zrmhLkeREZ08iz1zze1JgyW3HEwdr2UbyAuqvSADCSUU
GN0vtQHsPzWl8onRc7lOPqPDF8OO+UfN9NAfA4wl3QyChD1GXl9rwKQOkbvdlYFV
UFx9u86LNi4ssTmU8p9NtHIGpz1SYMVYNoYy9NU7EVqypGMguDCL7gJt6GUmA0sw
p+YCroXiwL2BJ7RwRqTpgQuFL1gShkA17D5jK4mDPEetq1d8kz9rQYvAR/sTKBsR
ImC3xSfn8zpWoNTTB6lnwyP5Ng1bu6esS7+SpYprFTe7ZqGZF6xhvBPf1Ldi9UAm
U2xPN1/eeWxEa2kusidmFKPmN8lcT4miiAvwGxEnY7Oww9CgZlUB+LP4dl5VPjEt
sFeAhrgxLdpVTjPRRwTd9VQF3/XYl83j5wySIQKIPXgT3sG3ngAhDhC8I8GpM36r
8WJJ3x2yVzyJUbBPO0GBhWE2xPNIfhxVoU4cGGhpFqz7dPKSTRDGq++MrFgKKGpI
ZwT3CPTSSKc7ySndEXWkOYArDIdtyxdE1p5/c3aoz4utzUU7NDHQ+vVIwlnZSMiZ
jek2IJP3SZ+COOIHCVxpUaZ4lnzWT4eDqABhMLpIzw6NmGfg+kLBJhouqz81WITr
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------QekcogRZyLk0V7Vo2wvrqX10--

--------------dTBvLoaEMmhBo1p8OlQAVFYd--

--------------M4itWcqxgptiTNkOr9J7EdkW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmnJYhoACgkQszaHOrMp
8lODMBAAkIA6VjfpEz/zye56Qmmok4DOmG9X9mR0O17lGAYZ89kI5u+Rdhj27Jyv
7kTlCdX2FSNXzskgOgPvw9FI6qR5Nwm9fTKjeEVwevQljuHi3rtwkBlytDvObCyF
0ODa5X6OgKAkDDNDRU3weoFOvbTVSE9ag+/Y2LEQxFxP/TdnIGsK7EYIMjtfs0pF
1sBDqbu4h7nZn3S/Tj3VWsnFZ+C+Z53eDk2dz9ioa9qOpwtgIiBiI83zhtRnziTA
z0GlAyMfiiK6lWVvbkeGjDwycbiAaxsgo9AoDrZLHL4aa9Mdz1qEZa5eBSA1KT6a
6ZTbf8/qwSvj0k1wgCzoeAHdhpZJ8hskmnUnLnz06uQmzD6NfvSy1LCXXJyJqd6E
X5O1DvbXRLQEVkLkCX4o00Nr4TcQgSzwbbowQHbSYduBq+y3S/OlzUmQxq8tfrd6
LaHTCSejNPU5qtj3z5U2w5k9GBI5l9CLA4QF5CH7g4oKiYzdNwHyHzcv/CKiEdPC
4cJzjW1lmMSiNy4oqz2D0MQ6ZRjMxbR0ct9VKF4UBx5A5zh2bgH2Nz0jz/vndP1X
5OwnsicASjU4p+OoW0vdKjjo0V1OjOIk9V71IZKguU2jXdCPH2583oz618pYtlVG
Z7TGSDyTQ3nX1z6xSpOXccEpG3zH9zv33PxK10j58NI1GouJxUU=
=7Szj
-----END PGP SIGNATURE-----

--------------M4itWcqxgptiTNkOr9J7EdkW--

