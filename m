Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57705FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95DD6B0005; Mon,  4 May 2026 06:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46BE6B008A; Mon,  4 May 2026 06:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9839F6B008C; Mon,  4 May 2026 06:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5E46B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:32:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 358E9C01A5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:32:52 +0000 (UTC)
X-FDA: 84729374184.17.813CCD7
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5649140005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:32:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DZeblbV8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777890770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1pBQ3dmpauwMVc7roa8Vteafz4/mkMyRaEsDsPXXbk=;
	b=PJYv43TB1+oEr81cHw8ULdWzkugmorqMLiFnJN+iAWaQkpH0P+injdOOKZ0j9Z8quJfCS4
	oyC5r2C/gS7Fxr9kjT2oPt/VatGTP//QLfjW3Twz5SZYKLKGoPfrdCxHhCtNseV4dQYlbV
	jrxC8H7d1Q14tckHaht5+y/CBSlvVao=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777890770; a=rsa-sha256;
	cv=pass;
	b=5q9Gpm6f808LrtMeHuMQDt963NcL6aArPAzCdaOM8CGBXzB/M78Y7dYu5o5JJLzx5q42f7
	+2RyEEDRsyRZ0iFUGgh2ng7ByFFLclq+GhY5nlK7bzc9NdcyoDU0HO3/9DK3R9w1grCx39
	gGvWDutF2EmP5/7X88mvB5F8H4+nEP4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DZeblbV8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67c566cb519so2174298a12.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 03:32:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777890768; cv=none;
        d=google.com; s=arc-20240605;
        b=OweGWD9VQPMX9+ia4os6K6hU/ZFDP8wByn2png5ii7V7GrLPlHOYP9KGV23NeJVPxt
         cyE79/+oNIU23T7oj/fXaGy4gHQV7CllisuJZVWBMJtpVcdkx9rEFTEQmzuZwJzfXtkY
         32ab0TufRu1eYFm3wR/xvEITucCU++p1rOWY6yA2zvafDOe3mIARMcu7ai98cgBE9Crx
         xD62s/MXtrzHHcle/EyoSc/QE/M50/FvE8XX1TdxfzO7uVkgrMdo4tOkgvirokvS8m/P
         NliillZHnPwStrQVWem8NOMLOUe4hOXDdKGocWcnSUZBxQgcWKm3bfD4xKAGhqV6EI+D
         6fVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k1pBQ3dmpauwMVc7roa8Vteafz4/mkMyRaEsDsPXXbk=;
        fh=G4MEgjyN9AE0GXqgew5KXoRZA92wHZ+PdlA0CARnzhk=;
        b=jWbKN/n56YPdkm0zhC/8Qqmc+lVHPU+kdWQjnxoOGzFCk3oljDh3G+5J1O3jToDDrP
         0JL6ZZhfqFWCBNoDQVu9P9cnE6Ytn995KJr/ZSYhh6OHIhMT3G3McaGNKSUjZsN7Ky8o
         VBmTCDUH8j3WDMkBe6sngdkmx+lP7eqYFllT4xH+26so3UsRkL20CAXph+YGQdjc/PJh
         kZtlcoN3S8oUfjaQ3OPiR8uqISAx30y/RnGit0yAbJTk5MrERmohErTgjZ76AkXb6+HJ
         yyWmpQiMVAsvEgBWfSAYDBnUHAqC2vNexup3Hut4aeMsFoWOXuDWF6x1WCGZdzH1MK++
         ZQkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777890768; x=1778495568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1pBQ3dmpauwMVc7roa8Vteafz4/mkMyRaEsDsPXXbk=;
        b=DZeblbV84W3Nf1DVkQ+QFJyG8N0hBK5xpFO1Bdc2kbV5nRvefoUQGIAwmcrYowQtWy
         W1RVBD4GVAwqeHSWOYGaQxvP/fdecLLSUDt0mUhcCwLuQIOSP2ZPVxV0U43uhBqbdOv5
         eRfqtq+v9JDiSySjXdvxOKx9TIjr46lrv7y6fCQsUYa3cx/qSaH1Ujo5Y/vrq64piRw9
         9LAn+5pN8n2aP/32GeMl1EgbYAJysPouVXgNwepeDaVGQS6WNDbSdPt9cTlAsmy4n48n
         eCz18+IVKzArxcJH1cHdnh2KLh0HhCIQP+jrpYz/BOsds3AaYkX6kARozHaMTHO7e7YQ
         BSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777890768; x=1778495568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k1pBQ3dmpauwMVc7roa8Vteafz4/mkMyRaEsDsPXXbk=;
        b=o7YcsD73x2mppI1F3phKc6aTWesVANN/F+G5R4kiCG+UHV9Ck5Y14pTokrIiGo1egB
         tRYYd8bLB3S3shzHqsXz3nC6IKpOX0bYw3vuK8ltN/ZD+yS5z+2BbnlL78gvVTyJbsuQ
         2DgVETkp/s1KLGyMfZdA26G5+1+i8PeXuFGPPeHG2kIGjPPZ9PbP7bAKSC2usfySrwWF
         Ty3b0GYFZhNSkiy6KAS9zbQ87dq12KSiq6fs/mP4hi9vgLXXJf4mxLFy4ylRVq9OA5CW
         sl5xhdH9leap6UUl2iVqOLgPPC3/+LR1npvpbQT0wgxrFUiA7JEtF07cpGyhVFdRCK2q
         hQ4g==
X-Forwarded-Encrypted: i=1; AFNElJ9+Aq2j0ICz6i3PvRwOkXT4DFp62QwOdwZYi84lenZ/AR7PuJqADOHXMUe8acXcYHUSA4/ena8gXw==@kvack.org
X-Gm-Message-State: AOJu0YxE3B1kDtTG3H0/JmaMd4MqmI2DyKCItBR23km1/sB3lZbpjJV/
	IHGPUk7kZA3r4ffDK+jrNhzrsHtkJ/hG2krR/tKNoz4IBrizWvZa8MbLuY3eIWMtw6ovJIWvmI9
	vw6vaZc2pQvbDiVbEfBbc9wUXATVO5XVtaTg6GwGTgA==
X-Gm-Gg: AeBDietrjEPPV8IsnQAHfDbCtHKdFP/vk4t7dq1NbpdleWvicQ+ckTxvXuoCNVpQfOh
	SpADdvVuEKwNqj78KVMKK1C+Oxx7MJTsr2tZfQLd77mBSIuqU/wlURT3nozldPkKs750pZuNQeR
	oAm9ecwZkfL0R+OUQLIUrfDh3xr0RaWFBJvP7IT9CJB4VycccnzdiCw08EBZUMwrce4Jr927tB3
	0g/Zcu0Gjw8tGTiFY7MZuaBRk9QRNDFKqpFreQecgga582gdaJfjUmuyiL9A1A0YsDaCIAfPylS
	HxN2OiwIOMHktcNSUTUXp3MWixDbpVrdXWigzblc7EE1dyK0SA==
X-Received: by 2002:a05:6402:a0c6:b0:67c:1fd5:32c8 with SMTP id
 4fb4d7f45d1cf-67c1fd535c6mr2725210a12.19.1777890768158; Mon, 04 May 2026
 03:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260504102742.3833159-1-pratyush@kernel.org>
In-Reply-To: <20260504102742.3833159-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 4 May 2026 06:32:11 -0400
X-Gm-Features: AVHnY4L7O8G_KVLgdHkNSHNSESCfg5WNMWa7oZ57dDlBl8aWaYRhiLVDiqRj_wk
Message-ID: <CA+CK2bChn3bAFBnmD-fNw2zh-JrAaA73DNmm416EbjXr=mTakA@mail.gmail.com>
Subject: Re: [PATCH] memblock tests: define MIGRATE_CMA
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Michal Clapinski <mclapinski@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5649140005
X-Stat-Signature: x6ybmtuctrk6p7zpskkgytb8ky5srmqo
X-Rspam-User: 
X-HE-Tag: 1777890769-487928
X-HE-Meta: U2FsdGVkX19WtsnG69VcoeZi7Jzp+k3LVUxEt+DtzUfloEe6zQJpj/9LUvhvn5sqgzHUXOr+wXTrXLkU4Zx/Vxv4Jf11F3oRua0t1ClmtYaBFIXQ5EZEbB7A6RWf+cBbS6SHmavjMKJx3nmN8NK7ng0pZ7DOrvOF4MyC2He+La5OIvL0CHjpF9ClunbCVNiyJV+M2F5nmuqX9xAuehM8vi4XZdczlm/gAGMZlmLcwTRJpubmIxyV3IDR6yNfFSjfJWmZc7cMLQ2mOzT80sW5lZPRDPTzP7xXDJqptAYFKG0/+vOJ823p+48yMxLD9AwQ7PsNcrKlH/MQbzMSwZtugq3MXdX6ERYFWqFQppZH6jrYfdaCUydGX1xt94ljro+43HOyEbTujdtkDCFVjsevMUl3xn5RG5la1Opbmanyl8gg19Jmm5MtGLSV/EXNSTdz1Kpp1HUY2x14Up7XM5fLlfOEO4P1a0s14jroCPfgD73WGIJ1kI6DyOPVcH3J2Nnq9H8HflDFsSuDJzo4z/GHEr6K3yf5Btw2QHG5bPCudPw4Q5vSi9/S5qBmYUufX718DT9e/UKeSyJXSuIWhAEs22heHPR38tCUX4MZF1QwdBp+qlBGv61CUZfW6WBY5A6sR8L78LMChEnHZi/ZXo+NhEijPL7/xnE0in2UJW+3+OoQ2cEv6nlHWjQsvmUI69Ps6OLlxaNAd6qCmfr7B4WHltu4rpTEUgq2CqGP46O6Lt3vxQ6yqyanK4WaPLLBj6N4cWZssXj5aWwaXy9NjOnmdQRTbvtw/Y8tqsokzT80mJ6VHIp6ge3TPzEB2FGmR1dDdCbO9WPADkQWeefrMjbD3di8Daey2AVvfWsHf1N5CK/+74VN3LrWlB9kIIn+R3Go/eVbwiDTlnn+VVKQJy3mJqL+4NxOQwEcTDC9W6LDstCxQkka2jSrgFaaL/E00C6d+b6bmE9OMbhctxjjY3/
 6uRJGE96
 Cd/MEvt5/NDatYpMShdAYpaX7gYMWZDr2eRWRUfZTSzNAIICjaHjaImesWLC+E1qSnZAgepl7K8Putt04ipsYudR876UlKMt3gkln2SGUt9dfmXmkQmSM5vhbuVBJbgGsq22I5ee8RLk6JLO4A54vBRv94gG1B3+WBrrg2MBlrH11laojfgjNGfw84McFOdNFPbz/fdm9xoyc3urg9wwd5EPHOvPWJ1Pku4VRE1h0qrVg6JiK7I5wPfeFuiKX4y26z3/Z+vUBDu0rFd3qk+QdNuB4hDP4UeTJtAT/TJoIk7BvWxkTIJ2rTcoOalO+b7aJIG+3SHNx5tWp3CCo5039cSLlZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 6:27=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> kho_scratch_migratetype(), defined in include/linux/memblock.h uses enum
> migratetype. This breaks build for memblock tests with:
>
> ./linux/memblock.h:634:73: error: parameter 2 (=E2=80=98mt=E2=80=99) has =
incomplete type
>   634 |                                                        enum migra=
tetype mt)
>
> Fix it by defining enum migratetype and MIGRATE_CMA. As is the case with
> the other headers in tools/testing/memblock, do not bring in the whole
> thing, only what is needed.
>
> Reported-by: Mike Rapoport <rppt@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/afcdDm4aAJvNaQqH@kernel.org/

Link does not open for me.

Pasha

> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>
> Notes:
>     I didn't add a Fixes here since the commit hash for the deferred seri=
es
>     isn't stable yet. Anyway, I think we should fold this into "kho: fix
>     deferred initialization of scratch areas". So random bisects don't la=
nd
>     on a broken test.
>
>  tools/testing/memblock/linux/mmzone.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblo=
ck/linux/mmzone.h
> index bb682659a12d..8d934ff5b080 100644
> --- a/tools/testing/memblock/linux/mmzone.h
> +++ b/tools/testing/memblock/linux/mmzone.h
> @@ -35,4 +35,8 @@ typedef struct pglist_data {
>
>  } pg_data_t;
>
> +enum migratetype {
> +       MIGRATE_CMA,
> +};
> +
>  #endif
>
> base-commit: 74d1099bb4edfca3ce6edc61dbacbed96720034c
> --
> 2.54.0.545.g6539524ca2-goog
>

