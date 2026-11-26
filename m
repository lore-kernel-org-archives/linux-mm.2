Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25248606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CuDahSXS
Received: by kanga.kvack.org (Postfix)
	id EFA916B05B1; Thu, 26 Nov 2026 00:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E834A6B05B2; Thu, 26 Nov 2026 00:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24376B05B3; Thu, 26 Nov 2026 00:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7856B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:52:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3066B1602BE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:52:06 +0000 (UTC)
X-FDA: 85476199452.14.4A0F3FF
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A46C140003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:52:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CuDahSXS;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795672324;
	b=8dGTLMxFs4fPp65yGDTmIXZg3/c1nmwrc7wHMEnjqxZrkf/fJOkHMcz5D0aWjVNJQnTBEC
	39g+RdyqaopEC//aB5j3QIQ/SYJZQbOB/NHBv1JfwJsT7EjCpTRuXj9/wWvH0IN+eDD6td
	AmXkXUehxn52NY1yKcf/p7mpCzFeEX4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795672324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2k6JRJKRP7LLLbAdrdUeXnNjQUGXGLvFy8MnHqGutzQ=;
	b=5OZWUUsP9yYtW75g15oh7aPZZWG5Nq5Hw9qyO33XQPqGrVNFrHlPoJOAt9+7IjrnbpsGyx
	8kY/0f9H3ftUV+2r8miG/uDpe2hUqf17Ye//0pnn/fyK8GG6YmMhghRpC+Ra+YZ6N4lgVo
	v1EN63eMbTNSLBll+Lu7aBOetwZCuYM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CuDahSXS;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-920fed989b2so62554696d6.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795672323; cv=none;
        d=google.com; s=arc-20260327;
        b=Uo2wNpiUcKctwAjcgkJBVUlKDDRJbhENZ52wxrlCuyqtibGeRvYXpj6hkHI3JwAU8F
         32fMX5fRrh3rSDVV/aMbCYDi33gjyFdBItKkotWE9+025J7ZN5K09a+pKmZ8ySzU0ca7
         1kkL3lY/5Y0SJxDd/PvV1Qt+sMwHQhJds9CrzWeAsu/3WQUPaRNiwEJJnCUSd1cyOT2v
         LnnBT9NO/SO42rxaks4ToJbJYeYenxzOE67VdtydnvKozW0wHvlFzcNkJIGHs7B0hMvK
         7ykcHCxmtrpU0q6ZaUYGeNvHuFyO2PwAkFX9Xx821KtMhLdd85sNIqyMeS1LLUN64Oxe
         sYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=2k6JRJKRP7LLLbAdrdUeXnNjQUGXGLvFy8MnHqGutzQ=;
        fh=iNYLj3sma4TNZGmVaTAYufyNMoEz5RhcADFhCNTqOy8=;
        b=jnVUQH9MlQiJkToMs+T6nUP2BL7DwRDTc0s5132klszhMCibuZQ5WcWxwkHjjuxkFJ
         Hh3U3cebrySt+rsXaetyHiDS7zW81MAEcqUI+GV5kugsm4IkhZPnHAEUg9ZYd9xsLxo1
         +SfGyjhA85mAzSBvlpdoG3W/i5tVXzsxhGanCfClXRLjPMpE5EBWDW+bk8mJLjer5fWx
         ahUniP0hM/SveL30tLFkhydT1TV+mDwu7yYBa4aD/ONMAOssrG+gg1GYkvN3AQNIeIwg
         rcTkod5/ZfFhynlufDOTtVlvslHxYhdz/bvuNPEaO0i2o0QSZq7WvoKu2LU/Q4x+MLZA
         pRUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795672323; x=1796277123; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2k6JRJKRP7LLLbAdrdUeXnNjQUGXGLvFy8MnHqGutzQ=;
        b=CuDahSXSbdek/AU8kCp7JpAV0r5JswcFAi0K58Xg2AvauomHzIgPhndjMwf5S/247w
         vVMRrVczNtIaUfL7JnDXwF1Ap1c2rKCtYACgcoEYWSebQAsS/YIGCU8lEyeuO9zA9u+4
         UhFz3e3qZBXDdLOJ96nfLjz/+oW2xs9baYQmIrS0rzFXfThzvrvUvdGhuCFdf2kMsRk5
         OYjpxnu1hzqSRCM03q7xHLu850fMzJ9HQ0E75GIlEOO6uPWC7jLEwkZ7wTzQlGkdoD/z
         7ygaKHUIsCrJNdyRQeiqk3XHSuJgAQu6YdTKJSZ7GqYNOjKseG5AWdMm7d+Liank4NHv
         1vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795672323; x=1796277123;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2k6JRJKRP7LLLbAdrdUeXnNjQUGXGLvFy8MnHqGutzQ=;
        b=EEnkXtwzp/9CdOlMJzk9x+YoqvudkUxBV1B3fuuysElhL2irWd+8+Dd0gBxA/565Ii
         gQdwF574ht9DZIHK8y2gw+dJTUJZDAAta/akfmpRMxzxpePpOCCrrVoYMPWBm6PRh/1s
         3mW1piwKjjRubMCjC26AMdQJCIIN66V/Lf9HL5iGOsun6odUTCyC1YfiWNT3mn47T2fW
         C4NeU5k+GsBGNIgMrSGL+85IS8lKTmoH96t5F+jO0mqCif0VuP1skg+HbTOVTQq+PphN
         e42g/VjjCAdI+HhgVoLYmWnz/zj+UZoYgmGwbJ99brhY0eoetZBsGn7qGDYiYcKQkqYY
         m8Lw==
X-Gm-Message-State: APuU4Z+WDGvPnL2YC2eZI9ThbcwAgT9koCmmqrxh9EKbqgGcYuzqL+XD
	Xl1n7mYjiUGU4mCHDH2c2tabUVqZzamY9pQTv7Ya85jD46rQsE6M7sv3ma+dNEphA53CHDp42Ef
	d0/Ltehh9qrUPwdvryj0aoHIm872JHOmdZvzIEf92
X-Gm-Gg: AZFdTZdNI8TQbK1RS3phYG5QQIPm+rzaOhKGBH9QJiT5HStuKPIsgvcZelPso3eUlza
	7SJHzKkC99aCUKrpbS5tk1w9F+3I0FmAc4Mj7athjyV74P0uS/ZI6hQH2drynBXLDCQly7G4ptj
	HIYxuyIvMBGz0Lrj89unppK7e8HVFEQCRmJ5gcjU7C9LCfuU3NNQC+qoR/YMcVCBv6huJcEVjD9
	k9IwU1kjZGHZwnvXlBtDPjfsI9VNkysjFXb9O79k/9dlhfgRE+3jTOUVGZqit8k9XJ6WprkMIvu
	N0J8GJvNtwl1+9mfa5jLgrO0fsLY3S90323zF+xGjS90TeAdEXhj5FBAFe2r9o1kIBRfUcLQBCZ
	cpnpmGzT7WbYUKHMEwLmPG6PoR2DulwF9BSjnr6pQqUTFVF/1bmtzcMsRc9HDXDmODQ==
X-Received: by 2002:a05:6214:458b:b0:921:15d6:2acf with SMTP id
 6a1803df08f44-92134aae3a6mr363727356d6.12.1795672322542; Wed, 25 Nov 2026
 21:52:02 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Nov 2026 21:52:01 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <3b7d2d65-be96-4b63-9de6-7303d2de641b@kernel.org>
References: <4c7f9772.192e1.1a17d5c2ed5.Coremail.xuhx@hust.edu.cn>
 <2026102727-data-sequel-ce41@gregkh> <566ddeb4.2ad04.1a202302fe1.Coremail.xuhx@hust.edu.cn>
 <3b7d2d65-be96-4b63-9de6-7303d2de641b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Nov 2026 21:52:01 -0800
X-Gm-Features: Aa3M54repb8SXZGoGoOnOV4yw28LCY3gHdW88ztUp64xOBuWhqUl6TXDC7tITrI
Message-ID: <CAEvNRgFsS3ntQBANqaqdm5XS8c4n6KDh3aODiduf6pCczmBSGg@mail.gmail.com>
Subject: Re: mm/hugetlb: a min_size-only hugetlbfs subpool is kfree()d before
 its last pinned page is released, so free_huge_folio() takes a spinlock on
 freed memory (UAF)
To: "David Hildenbrand (Arm)" <david@kernel.org>, =?UTF-8?B?5b6Q5pmX57+U?= <xuhx@hust.edu.cn>, 
	muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A46C140003
X-Rspam-User:
X-Stat-Signature: rgn7xbjwk61pyg13aig3gx5yqf69hzxb
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795672324-86151
X-HE-Meta: U2FsdGVkX1/FF/1qiHdB2fBGhk+4ELUs+7xrwVokSw3UUnAgiRR4KSZ3xJN45u/DwvDCqv2EKN2A0JkGh5ZyBKvhiFf6hMdMBGdQZe7RN8KXYqY+cArRdcPMbHD4ARU38+5EdkrXyhDJXy51F0r73S4suW2HAlzKLTqnv8VNLaR9VADUke4757KrE/W+wPlc6cRMauuxpXDz67S57mo02q5opUG8UAsJriMA45/wO/iRyQuVO1HuD079dU0m4zmrbub4CWIQX7/f1gNRR2qAc2rBbyAZRGjT7gEEqLpTXIRdg6SeAIpXwFenWxkXQj1cNrMaI6ULJQzkWVNLPsZxb1c0FZZgEP3gE8YHKkF7WrYobkOT9ZRI7tpfQnPAM/B0me1lubp6kv6r/lRdIXSaJqBkt6QTJL2Wz2Q01Mwccm/VnnxMnsdz8m0lb6UGlJjk/4LhMg/jFb7z5DeAqMWcnG7xqP+5zyp7Ssa9HDlkwpJMhWV/31+F6wWB2HqRlTOE6WgzUTHNCgqaEHqNFk2g2HKPAQDDnFBt27EN8cIEAYmDO1+2TWuyPil1kl1ynXxzI/VJQC0qrROkUeL5QqCYE4vqIu6+xlaMVceecjT9z4mnCe8RGHOAqOi6RhaadpsOoPY4/fjvwwG40dNRs62OHsI9+mco36y89YX3CK2vSxV/7EA0U2cWwFQlw/iqil2+6zAVU079u2FVpUemlwkOgbOsScXrorHSEsbDo89de59ZeCP3EgOD47WIpFGoOi2J27s7ahlFBG/2+T3F2c7pFvzvgAlInk7HAxdkfQWuVROp0uptJC4mURjOWPtPupUZuJ0hSwUpJzft6WqKv7Z4uz+remPqjbOjmFPJdeYEWvOQNreX6MfEJfS/i3rkRpV4JPSJsRcBT+KOTldN1bm57vy4u8cRIVG0THpvfzHPDFgAcpTGWDXLpNg4nA5JkNHxHpMkiHggELpp9xR74wy
 UYEFTcVg
 47TZLfBntqc0N+WgphAhaYvsC5QAkE8jfD9t9+zil3qnxzx5P797qI0RjjR25IrI/CXMgPI5KH3ZQDc+iqxupH+/L3y3y5oqhAKAqGayTpdkvgGYJWHrElH++tfh4PeXifsCe92gIZM14hjPpFKzFuDPQHikAa51LBnbFGJiiAhPSWXjfYhqjPsqIWRRy0IrATH1d19oZKC5/1bIe2QxbHWr1PCOddSdqpJyBwMV4q5/Offa8nnQ3U72FXDY49lupcswwgeigGl7INHbVxXIzKNQ/0jRiPmehgipBhZoXlAVYgTKMC7dkIWHDtuzVxcH+pPmyNcQ+qb1w8ZU8nymj0hQoj65mSPZJQL1hWeKvZ7A/UnxW16DI6PpoUeuPZxTawdZ6o0WhEKIggy3gYnYbdKqjkk52/L/9jxL+GOnMF9X6lQqDdh4gs3xgCFrObTi1iVklhXXAbV3cCExCLU1m7D78bYtVbvsY9qX1ljiJWdvdvqYJ7b03JuLj0YH8pYVnR6FN1a2V0gPJZMO0Tl2L6xzsRtUpouSXfpnuxiD2wX1Bp2PheOFpw6efhZPnt2qVwCmCCphh72sxNrSk8loic2CbkycZe0FRA77/4VvrJQcAnf6P4yjsMo/RrkiYLxeYyRh+D+gpA+YucqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> Hi Ackerley,
>
> does your series [1] actually fix this? What's the status of that?
>
> [1]
> https://lore.kernel.org/linux-mm/20260916-hugetlb-subpool-always-track-us=
ed-v3-0-38aae9b5ccdd@google.com/
>

Hi!

Yes, "mm/hugetlb: Track used_hpages when getting/putting pages from
subpool" fixes this bug.

I've been tied up with other work since [1] was posted.

I have a set of reproducers locally for the various combinations of
min_size, max_size, and both defined, while taking various paths
(reservations vs actual allocations).

The plan was to always track used_hpages, which simplifies the
accounting and it does fix all the reproducers I have.

I thought in addition to simplifying and fixing all those paths, it
would always fix races, but AI showed me a repro with races that broke
the model.

Because of the repro, I planned to re-evaluate to see if there's a
better model/clean fix but haven't got around to that.

I'll try to get to it in the next few weeks?

Ackerley

> On 11/22/26 08:37, =E5=BE=90=E6=99=97=E7=BF=94 wrote:
>>
>> [...snip...]
>>
>
>
> --
> Cheers,
>
> David

