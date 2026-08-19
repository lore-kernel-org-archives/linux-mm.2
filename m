Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B344FC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 13:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D516B0092; Wed, 19 Aug 2026 09:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E306B0093; Wed, 19 Aug 2026 09:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6256B0095; Wed, 19 Aug 2026 09:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8D26B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:17:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A58540560
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:17:13 +0000 (UTC)
X-FDA: 85118069946.28.3533568
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id A71AA80013
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:17:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="R1kV/7hU";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of "prvs=6691494d99=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6691494d99=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787145430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAhMls7II/EYIhhbxkSqLjlLaMUSTDEHyYBTxI3i+Uk=;
	b=wETeCg27v0RaSkkD1uZfMrETREiCofb6VXSnbojcY6H8uB63sG4+T5+TDxTx06YM9iyoXG
	ph8PoJm3yxAY6DpaTPvKYoHJNSX/bEjx+veRHSY+yo8EqKRFnLCMwdqp+WphVSTvc1XKkb
	FT4RpWaZioRKAqtLd6ITzxvyDiQiT28=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="R1kV/7hU";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of "prvs=6691494d99=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6691494d99=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787145430;
	b=HK7Rwd8PsZbhKWaeREdGDJ/FOG0T5hO8gqEHD65tTya3sU39fdsWtISFJ7WenAYwekF08J
	spi3UtTzYcXmaLzYPccGtICscGobY95P1R2heZi2zMIg9c9wY/9Cj5jui4tkgJs5fcx+AI
	y5Ipd9MgMGMQb25D4AzAZHJ0QTboGRU=
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JCpXss2264171
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=RAhMls7II/EYIhhbxkSqLjlLaMUSTDEHyYBTx
	I3i+Uk=; b=R1kV/7hUUw1VvGvR3wZu4mbfQNZMBG8jYt73wBDW/b7fvoZA/sKtS
	33OlUc8gk6mEeTU/NyeUYB/KFNLCqReA4KRy2IUaAKG+X8e0fZZyqxhnQOL7bShc
	Yj1mHOysbRaOn3GzHfyb1vE7E6kgM6lgHk8ZB1j4N1AfkjyX3KIrk4zCnGxRtdE0
	e00q6pHzd/W1jckaBWc42xar9eLKois/5umijdZNmiEQB4rcKQ83kti7zHWSBzwE
	XDk5q6Ir2G12El1VP+YaQ6Qr91KUbMsU8+ia43BfcqWq9DvqWtHzTiBNYsBFcnCb
	RT/DPHn+sGfDF9rBWInWuna89L2HJD58w==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g4yfhmpt0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:17:09 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a3ef31687dso958890a12.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787145428; cv=none;
        d=google.com; s=arc-20260327;
        b=AQ0ogU+3igZy1V43UOk2ORy9EkyZPBqg7wUzVXZh2TlJobY+AsCymGf89W8rCHO5+k
         F2bj/YqiHe6mfZelOXU9xDr4YsytXJg4oledsbHfDFwL+GXQwu4LCHDyf+N2Rq3TEexp
         MkVcqMXnWbrazs048Vi4WYrcpvFH2hPk58xW06JB3XmojbNqY08ViJWCzNQziQcjesNM
         Ey08stQBoJEYsnYC1fxfAsj9Dox5vyBE38P6VLcCyWICXaFLGbHMYiDXE/1XeKBs6IAb
         AiUldaFfCBwH7GjzxfFKZv0ytdIUVDW8UnJUMX/SW8UDe0TasSehFfmKrC9nwlN4QxOP
         LAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=amPDCjdDA7j5ak9IrHAc1f20HnHLVUkSfYRDZ1nWjas=;
        fh=8OwxSfoSkLShWPQJg/7OPUttmnBYZKHzdK2VIuJLoHg=;
        b=mNFWICwFFjcoJGPHRpOCCoiPiOnvCHtKeKxYcAC0ZFghPQ9aWcUkolIsh7oXE22tsx
         s2Mvk3E40q6rNroRQnahD1YQuC47gP+DHXUHkEcGy40p6vqWFqiAwbQ/CRW2l3EhOT1B
         DkjFivgeHB/vMnfcVlyIHRN/TF30L4b8anj7/sx3PwgVxyx4I/PTutOhd2WprAx/7L1J
         WhPdyT3x5x0g6gIy86dDdw5hUs+y8Q/BMSeHV6WGEAK7WN5SoehzbESBJilHGKqTpOUs
         Kf43iXW365TwJK5YGJAdhggHnALOXRWsNJN56wgtnv6NyddNdZosTZZIDJN2Ss+odBcd
         JcSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145428; x=1787750228;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=amPDCjdDA7j5ak9IrHAc1f20HnHLVUkSfYRDZ1nWjas=;
        b=J3PSKvbZGIwpQpdbyCc1nDOmrW0eM/hH5Bo/ROHWTlbgRpJkgVxdzDl/XmfuRbeK8/
         YHhEkoEzEFoe6DezdSUOcLAAE8xmsB361o7JRFwViQov8FWv3brpDXQQ9Y2SUYEtzOpW
         d/nIFAZ56aDV1W7Tgi9lNt96QO+6EP0pqsmbKSvKMRcExAfNNmitPNg+dzFvGOFUs2Ab
         j37qmRIWcZNkPm4Ryl9Y+TLD2lmUboV/bF0RV3sQTIENs0emDmiLQayuL2ILM7xQecKY
         HhRNEvdu9WZzDYGvKiGNsxqBsc8jS2fotLlsrZyvednFj3tJP3A5n/IAgiqag8ZCLQO9
         lKHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpSXOaP3hTZrNBrsQOEdQSKIF7bIP61EvfMCzTvLj17FoyzJACvRHCcwjhcVrD6LrGzQUxmNjt2BQ==@kvack.org
X-Gm-Message-State: AOJu0YwcPHeCSTif5hiKlFL5YhIqF5x2lopmqrYgKTN258Ld1g7ddHZv
	v8a3AEC8fKVM8spGtrZWfi5aDpePF7nkwehGnLcdjLpJzJQkxMxnGyvqn3qDDZ+2hmshQwmBwoe
	r6NuHCFPIsdpMTfOg7+ZpQRfFdErXQPQGJAk9Tyw/Gm+/HfiSvuGzdpCJXiJrDXU0iqz2Oje/CO
	c8IDFqX8SB88aGvEq3QEtF2B0PQw==
X-Gm-Gg: AR+sD133xknFbmAgZMDXDyyjxFc2fJsSEOk7hrBtBnHC60cx4prOK8BSKaYtDLMKNKr
	DFuWzmxm25l7B5fYZWysGlBhh0uzAkIl8Z2Sm4xClgFjNPnbu/aKiv+TwWMV6EJ/xYZZjpguNZi
	jetHvdKY31yihcGBIUoh38J8fcz0oWW+IOYy6ixBWUzjWDtHHhmr3gJElPSJhhHgmiZFieH4HG6
	KxziZFYmB+g+sgPHg==
X-Received: by 2002:a05:6402:518c:b0:6a1:f092:3c1e with SMTP id 4fb4d7f45d1cf-6a4032fd452mr2041124a12.13.1787145427632;
        Wed, 19 Aug 2026 06:17:07 -0700 (PDT)
X-Received: by 2002:a05:6402:518c:b0:6a1:f092:3c1e with SMTP id
 4fb4d7f45d1cf-6a4032fd452mr2041066a12.13.1787145427040; Wed, 19 Aug 2026
 06:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-1-alex@ghiti.fr> <20260818163221.589352-4-alex@ghiti.fr>
In-Reply-To: <20260818163221.589352-4-alex@ghiti.fr>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 19 Aug 2026 15:16:55 +0200
X-Gm-Features: AcwNN1Xk5iqn17t42iniquZ7VKy0qOfjGpedBjI9eFDNjdHV7zpBK7rsdMnTXqk
Message-ID: <CAEmasaVJ_LHaa=yh+38OjeaaNn_OppsRdUXf+UzVDzu0=_bn7w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwMyBTYWx0ZWRfX4oBYadILgbHC
 BvXRUcxNBQ/ZNGHRjLvxSd1XD2jfTwAGAmNTh06a7nj2tbQgswEK2MTPkB61re1yVVmOd25/bVx
 FzR6gYv2JOjN3uyz9LUMOCmijySBzOO5YeqIEQOpeZYwyzdIllERQfvASAlV/lYx2ry8vDqkWLv
 CRW8hvMLMAkwFLmvSbkOz0I2wtLTQlx9znss9ZdWTVR13CkBcEhfSasQB/hK/UqhkApB+k+DZNs
 quqzXFEPtNOMr3tX/Ln2Ztg4f/XA7TC8os90AAWS1RATMP5m87XKqM97qE5WuPev2+nV0K9EHT6
 4hnCMrZb0YmAeMBPWuE1DHmGgpB0OqchV07ZYGURluG9EBKiOAg+axHDKLeNZAi+DYC1zmMF9A+
 V0EY8Gkviorf+gX/4/WmTUbV6hNB7XYURgrSfxfjBPAtXfAljS35gFfrWL/EFlNSUWunenDB3+T
 L8zDFAZGsyKvy1+7LUg==
X-Authority-Analysis: v=2.4 cv=O7YJeh9W c=1 sm=1 tr=0 ts=6a85acd5 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=ufHFDILaAAAA:8 a=pGLkceISAAAA:8 a=LLsFW6RCn8ZTAUol39cA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-ORIG-GUID: YklUs5qKN3xKLQHW9N7wXfNboiqQ6uji
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwMyBTYWx0ZWRfX7/v84xvIMvOc
 UeXOnlFIbDDGhkJ0y05mIBUjumvqmYtYn4at3bHig/s1EbZiqZGD3HurHLBYnj+6yljJpAGpqWg
 MEFeoM8B2iGq7CwwHTUfMZqkwFLo0CU=
X-Proofpoint-GUID: YklUs5qKN3xKLQHW9N7wXfNboiqQ6uji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Rspamd-Queue-Id: A71AA80013
X-Stat-Signature: 8yfcksaubw55ktj3q8b5aremi7qimpfu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787145430-81442
X-HE-Meta: U2FsdGVkX1+dGPm5qAREk6SnqaJjt6C0lirLdLrpky2lPYa4UPVmcg0rZOpXc2KLOMzr9f2/ehxYr1JpPXisGKvqTw6iiFdjw7b/CsPrUWkHuMbQ5tfYUNDOTwQTCoC17p6JHTkkWd8G3kFzHEdZP3m6mF3ZO3oey/rvLn6KlezEh+dB3vgcFnMWUA7zeWZz5tUpSJ2TfsY1hvFTYokxbyrcg6peZKNDF8aF0LfPTETu4P1827TkyVG7Wd9ITU0QYST6YX4qlptMSI2kSfcYrO5aJfq5iOw8d8qAqluyDuYqEKIEG3xQX7LU56VCHOMvrGZnipT2lSyD1PRfsq7e1sY354Nn5AlWDERlcWYXoF5yevIJPBtiTe0WH1R5aICkuJ6BN4h6/TOd1QF1RYbVBNa5gKgJcZjjl0nUeGewi62eG59RbUYlGaxAhPBQQB1Y67XFKHb/4A83/IYj6s01c6yF9ckzJcssHPxConHZxHEQ7ViJKNRN80JhcsQdkE55NNegx9m2TnGapcPS3PoGtauS1Z1RolXOwAVBFjr1b1GM0qEPYbpF5eZGOe2n0zEXszZScux9u6lBO7/EozTsqfttxTL9Uh5jOdQ9zLtD/JoFE3cStnUWbmDdfOC54F5T2Od27mDNePPjxmb+wBIvgrvHR1aLciDtxuSF+MACA8jzpbnPKzpgn5igQsUyiIK/ts7NyL5wSzW4meFr3hCUyRgQHqTFhIYjmxy1z6O6TDXMx830UD2nsf48CkDqdJ6VdJ4Ue4FJhmHP+dwHKOLNjGAC2UeJoru2fKdBH296+YyGRbf6DB3L8T1WZK83ASv1S6F9ezgrzyIbAYCxlB/d2wsmrFSBx4/+NSAm0fxM4Lg/3AZBGsFHTqo8WDTOKvceEUgEZrJafrshp72wl7l2kzBkkDXNpp2rZifjl5ZnBx5nz0D585Ym7brNxLYEXmnADk+VlHoFQ0S19w1rj64
 vyYvlP0M
 BGqatUaVQ4C7h/h80ZyxPZr42Rsxt9nWeFyui532xrR2YbQecz21LOigN37+Ajc85Lniy2h0Ec0qx45f9W6zCqGiIlC3zF4E1WQ8PzeQQ2uCwfBKn2nKnUeKxsGOnWbPESpeDCKjH6MntsWmGNQNmWfTbstDV0bJD2ruTMm0/svkMoGMtT/S64XdyNAOzY5IZEi80/Lmle+cAUKMofDd3CvYZnhSeCwyIJR9eTrVon07Wv98+kKzsZLvyi7jL+nvSf+01nGZQztDzWcFKXGZDDtibjzHLaKqJzLUXre2NOSKKcxqdsOPzto6EdV2plnAkvqOovyWJr/jjVaR1p9XC0ibdrOP+K1zGLfslk7AakyjTsOQUxlCaVJ9eVZEob1Emc927+auD0HWQH/d50Mf5S01DCUdHfz2OM07qXKSWKTEvrS59yzxkNYnYwn6IpcuH9VQg6p2KA114AaRW6nPNIsANwYRqyZyu6nDALOm9whEh+wSqw+5mIG6cEQgASmg+1Yzkrm+DAiltwPILDswL7FtmIFkyq3Hv1XFZRKXxybJVh+exlQ4NOrmLaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am pasting and answering Sashiko's review inline below.

On Tue, Aug 18, 2026 at 6:35=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> >
> zswap writeback decompresses an entry into a fresh swap cache folio and
> writes it back. The folio is cold by construction, yet it is left on the
> LRU for reclaim to find and free later, wasting a reclaim scan and keeping
> cold memory resident longer than necessary.
>
> Allocate the folio off the LRU and mark it PG_dropbehind so the swap
> dropbehind path frees it from the swap cache once writeback completes.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/zswap.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8163e6c5f76c..a35671e837f8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>          */
>         if (IS_ERR(folio))
>                 return PTR_ERR(folio);
> -       folio_add_lru(folio);
>
>         /*
>          * folio is locked, and the swapcache is now secured against
> @@ -1046,8 +1045,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         /* folio is up to date */
>         folio_mark_uptodate(folio);
>
> -       /* move it to the tail of the inactive list after end_writeback */
> -       folio_set_reclaim(folio);
> +       folio_set_dropbehind(folio);

Sashiko: "When setting dropbehind here, what happens if a concurrent swapoff
(try_to_unuse) removes the folio from the swap cache before the dropbehind
worker runs?
Looking at swap_dropbehind_drop_folio() in mm/swap_state.c:
if (folio_test_swapcache(folio) && !folio_test_writeback(folio) &&
remove_mapping(swap_address_space(folio->swap), folio, true, memcg)) {
dropped =3D true;
} else {
/* Raced: the folio is now owned by the swapin; put it back. */
folio_clear_dropbehind(folio);
folio_add_lru(folio);
}
If try_to_unuse() removes the folio from the swap cache, folio_test_swapcac=
he()
will be false. The dropbehind worker will then blindly add the unmapped
anonymous folio to the LRU.
When reclaimed later, shrink_folio_list() will see it has PG_swapbacked but
no swap cache, causing it to allocate a new swap entry, mark it dirty, and
needlessly write the data back out to disk.
Could this race cause ghost anonymous folios to be added to the LRU?"

If swapoff frees the swap slot while the folio is queued for the dropbehind
drop, then yes, the worker takes the fallback and puts the folio back on the
LRU and that is exactly what has to happen: swapoff has just invalidated the
on-disk copy, so the folio now holds the only copy of the data. Leaving it =
off
the LRU would make it unreclaimable. Note the folio is marked dirty by
folio_free_swap() itself, for the same reason.

This is also not new: in the current code zswap's writeback folio is alread=
y on
the LRU when try_to_unuse() calls folio_free_swap() on it, so the resulting
state (unmapped, dirty, anon, on the LRU, no swap entry) is the same with a=
nd
without this series. Only the caller of folio_add_lru() differs.

>
>         /* start writeback */
>         __swap_writepage(folio, NULL);

Sashiko: "Does holding a reference to the folio until after
__swap_writepage() returns
prevent the dropbehind optimization from working on fast or synchronous swap
devices?
Because zswap_writeback_entry() holds a reference to the folio that isn't
released until it calls folio_put() at the end of the function, a race
can occur with synchronous I/O.
For synchronous devices (like zram), folio_end_writeback() is called and the
dropbehind worker is queued before __swap_writepage() even returns.
If the dropbehind worker calls remove_mapping() before zswap_writeback_entr=
y()
calls folio_put(), remove_mapping() will see an unexpectedly high refcount
and fail.
The worker will then falsely assume a racing swapin and add the cold folio =
to
the LRU, defeating the purpose of the patch."

Yes, that race is real but I estimated it would be rare enough since
the folio_put() call is right after __swap_writepage(), and the time
the worker wakes up, the window is very small to me. I haven't
measured the actual rate, but I can measure it if needed. And if the
race is rare with sync devices, it is even more unlikely with async
devices.

In the end, I don't think any modifications are needed based on
Sashiko's review, let me know what you think.

Thanks,

Alex

> --
> 2.53.0-Meta
>
>

