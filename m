Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3494BCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC6A6B0005; Fri,  5 Jun 2026 05:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D446B0088; Fri,  5 Jun 2026 05:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25BEA6B008A; Fri,  5 Jun 2026 05:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14C6B6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:07:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 937061403D5
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:07:06 +0000 (UTC)
X-FDA: 84845279652.03.2A79EE4
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id A54B0C0009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:07:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cOHMJlHQ;
	spf=pass (imf28.hostedemail.com: domain of dvyukov@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780650424;
	b=srdYeykbtCkQ0WIr8qKigyE6UtwHFOcYD7KAuqjSkF3sD8tvGH5MXgjmwBt/fTjxHzUjYw
	zHXjL/ubHntQLyG+iZviW/gs/hrhGkHQsWvazrUqq2CUL0Dnshpjbnnm4uzsTv4Q/MIspd
	q0wVq2BtNB4j0rSpF0yYNvneEva+95s=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cOHMJlHQ;
	spf=pass (imf28.hostedemail.com: domain of dvyukov@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780650424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93fbw1bv3SHPIBFbW1fWK/rBbsnGyvJpoDZh05ChLkM=;
	b=e0mqgp2rCNI0NtDLIdmK0YAGbspP5pGporQVUfSnQtxd6CclDVLHptJsTwsEiX/wm/r7+M
	A/yzypaA5o0rw7Waa0BOL/8VR/0H5aMIuvpbJA6r77uwXT1IeQrGMnhZsxO/l57NTKxVyK
	FJY9MfW1qyW6KQAX3YzXehbsZUc6SEc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bef1e6423e7so176463066b.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 02:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780650423; cv=none;
        d=google.com; s=arc-20240605;
        b=Qkz6iPSWM2ftEOT7DI50QA37N9siWSVwMAyqhQqHn59WIKsTj0wrpGTywioyIERVWZ
         K3r6VbEyfcQt1ZtwsApov2NDvmUtctzC0LH5wHoYkS/6ex9NmXqXSkyS7HYZ2Eo5jF6Z
         Gnufm0cuFsOdnWhkkssUttryE5VK2/Mw3Dav6qgM09FJ6o8ScwdZHImd+purqSWSj29S
         I8KEVmCCkwbu/iZ9RQ4ciN5xn+HxJw7agR0u2okKdm+RucBG60p9OqhApEpws7IrqkHj
         TK/vNc+kroESZUACV7liGxdyJPAVh/1Deq98WaLVXMsCiGfbp2QjdQsgzgu7FX6qVsd/
         yC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=93fbw1bv3SHPIBFbW1fWK/rBbsnGyvJpoDZh05ChLkM=;
        fh=11nkrvwFR5/iP2VffOLBwk2YZ4pROa9QAZgmuvstnuc=;
        b=FOa4sIMzkeIIUR+Ue0FGj3GjNh8JQ7FsfTbNyP8fO+7Z7tzwgoM8rwIUgvPNlC7OU2
         Sh/BXMAcsmmO11VMcnD5JKBcrxgszn311qAUOD/QB5LKr/ClovXg3l+t1KAPlmxJW1wL
         gesJTa93OVqV5fQu1VYxEDQuu271l1gHTXRFlUKk0g4Bdjll4wK6rhGvj5LoRoKdO0uy
         5eqdrmwo6YJipUR3jNbANxKQdrW6f70QVTFSNvQjxUAkjdD7xk9QFtCEq4oogo42UIbR
         8LeDZqZGAygX/wa14suAPgTfnIsghvQ0IqD9Zzx0IYJaQK4qjgkOU05KWKKzOFcdaasO
         kn4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780650423; x=1781255223; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=93fbw1bv3SHPIBFbW1fWK/rBbsnGyvJpoDZh05ChLkM=;
        b=cOHMJlHQT44T/WEDSDYoqYmKsvIMYmto+uijfmehsLb+Quy3om++E/rirlMejHFPLj
         OEGBHTZIa+xRS1LYIs50H9VXapT8HSrxePzjhopJijqyuVGnDJ4PpfgWyWtzZ0PNciAa
         xiIpP/p3JlM2CAyLcfXmj0xsU5Cy5m4JkqL74lpHhlWc/hCqx0ZZS9ToXI8ZPeGHCxyp
         GiAvgmAhT7vt1dZRVrUNOPYZLtmlSv4fmWPwaRgnwIttvfeyx39Udin6FnatJ0LG0ByU
         HKc9Urv7ioFslKHAFAgn/O2FuuiWk+HcIdySSChZX3tb8cVBJTXsZ2ICeenGoSMLmCpq
         4NnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780650423; x=1781255223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93fbw1bv3SHPIBFbW1fWK/rBbsnGyvJpoDZh05ChLkM=;
        b=JTD1cABNj+191ezExLUlEKoU+6alldCYj05sQWLIICfZqKfToAVnPm9IA2GBZnHvW4
         p+JsY+203KYajxFHQuhTxKeVkRsPqjoNrVpq5NOR1DyMk2HItNwTg/7+UwBWmiWwm8y9
         ubLzjhYoU+lonE9DIT12rcLBTuJ44BU6s3pnqBx2paR4ybpUGAfILeFFL+4exw0SQ1AX
         c+rDEkcHq4R3VQW/GtojocIqJaxa6bAZ7gEEFvOOpmUULQZV1lbKwmPNGiUdkYqA80Az
         /jGHyzTzSrGavsfTx90q19gdqD/16DsvbrSLVNkmHJGTqoC6nEpQ9Wo6ttMQvSP1n8kP
         Ax0A==
X-Forwarded-Encrypted: i=1; AFNElJ/AUYpVm6J/NyitI5h9L9l/dXsHqrxMasmwqCWPvg/2Z0hOScKP0Voaw5QBoG4+z97Rit8GdJ7v8w==@kvack.org
X-Gm-Message-State: AOJu0YyNW2yJ8Sc6RM0SYR0XDkvJKSPX9Q0bx98BdqCd4yvxaYrvjjVj
	ZF98P1ok3Zf3FByUW0vEyiaK3tMEpC3t5aQ64jO99j1bRfqDCnSqmlGMgd1L9szo0g0V2JN4WZl
	ssCWI0UB/DMHCh5krWFMviuXp56rx0bOUGPQdQnhG
X-Gm-Gg: Acq92OHF9k4SkfLg15hRvzuPWQHiuVqxpSSxb5/caFINBZGfphKRDC6HeZEgZksnQZ7
	UCtArKCBkvT+qLUP1hfVeKOtovjZBZMt0VXFug1SbuHYHV78xG6a525kXlgsKWVsauv5qcI9xAG
	B04APXNnWS0JAJFO+hutBEABDb5xZZXjL4j5+zJj6dsJ+BKbDbeB9a6TuS+kmBWAFd4MYTpAAwX
	mxwgEHUdLGd2IhhiqUDtYVf++5WG5HqzfU5NOvH651SC6+MwsEFM2JMG6wAsAdfF0jo73Xn2v6l
	uX9hz7U+aY3JTnHn4puLXPA+2etdSO/D5cg+1IjbZEKRK/L7DN6ssYVUCIWYUt/ZYgdhbeLc89i
	8LhUVfw==
X-Received: by 2002:a17:906:6a01:b0:bea:4c91:fe88 with SMTP id
 a640c23a62f3a-bf371b5030fmr114555966b.18.1780650422334; Fri, 05 Jun 2026
 02:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260605085423.1962700-1-glider@google.com>
In-Reply-To: <20260605085423.1962700-1-glider@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 5 Jun 2026 11:06:50 +0200
X-Gm-Features: AVHnY4Iyj_m2RkQBFj5XA0EUzxPdPq-a_LH9u8rfp3fEOU8jhhARGzXiJeAZk0U
Message-ID: <CACT4Y+bZ_Ev0SAdTt9MWnc4o_itqeXcKFqJV0gPerrzy+48ekw@mail.gmail.com>
Subject: Re: [PATCH v1] MAINTAINERS: add self as a kcov reviewer
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A54B0C0009
X-Stat-Signature: qtez349f8q81egocttaf1b89xecszek8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780650424-324601
X-HE-Meta: U2FsdGVkX1/4jQPxlUEo0Y5Vtp5IKgeMDdZslyGPiMPzg4lxzkGWRyCng2m+fcEHJjkwjjNfBJ+eEtcc1QkldrA5PX8leBEraflmZ9nOkiDppDRMA6Y8GJAVJ6cLJ9vLzRTI9tCJDHP6WGbWgssgoqMrI8zN2vtOvDwOulBshG1qB9qo0oSgzSKP4XGQycQSsLpNhlubPtf/hEzxcCjdiu1YkOcA15dtqX0H59nwq5JvPkhSgCu46LG6730zRDpFGRmJJ51kZl78Of5N2kCXxkJoauxI6M6JeE0rR8jMiGWcSZ2QvHG6u4o6YcR+oBB4Bt0lBkPLAPLZgdxJWzrBnds1/gPGpq9ew826SqUDCdX4yLazhLZIiRLU4mvXTwDeljAdbVCohdqhidgAWbhJh+qvMtrbd84Nd32pWrbbV1JdkcExl5E0pkjpp55EUTw8LqCf3yYeGzbbHRSvN/cc22vdE46s68CO9fM7fkTTyAV1+Cc4C8LhUkqfmnZAJaHJO1DiNhgzdg0AQ03SI/tJrkfk8IScjB04NNKJgFIU0zG46Q+HUO457BXaaI470S6beGloV7YJvbBXUR5OkKJgUSa+8wDrN/5NnsxJZTQhs99LzUJ2K385D38j4qAGJDj6wKukFHwV+qjxKT34bfu3BWbcYcnQhsUPnILuBZlMhixNSZ1GF09OCSYLB/X+2nXBLM0v7QzKY4cbIWUj9XA7T1nx/0kOgm2hsqXwYC6RhT2XkDTI2DUVy7sHpvcWail5QpI4GMXayRqEGqqz+ll7eFZrr8v6yCvUE3IGuO00lHIy51TWIGlLonvluBY4HvfAj+U//22dNj97lGjzPm+YuMd8CuiVm6SIWApdKclE/eGF9s25zcD5MGR1Po3KKp17R3OIU2yBwHNewris6IFk0vMzOCXt1IF10Y1JbuS7tpoG0mjcJ+EQDHDbPRnXjobF65R6LIHC6erfyrWLlVB
 IhFFGNbv
 ihRFQxwA8SdlNZ0N0RT5hLu5n0+KN2OPoktrExPwgcB0ZJViV+yztZKNvEt/NYL6C4smROU10Gg98dR0D4QO3meZffZdGZNPQnxhWke6ITYCbz36PvEmW60d78rLqb82BQ1IieYpTfx58pbOmSjo2azSJpM8pS4WB73JpQItK0L+2imB3txYB23xynnfxQ/FSIGoVqPVH4ZeloupwbuORWQ8M5hqsII7ov2evotJpqET3R4uYk8SqnMQxYenGPQV17T8OPCHzgbPtstPB4K9Nmct/JKsnU+osyAn2a6exGdrv+fyzqielVZTgi08ehevKkxgpBxsShk/jpjezTyCVgBISnUmOPXfx7WSjfVG1C+RxLMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 10:54, Alexander Potapenko <glider@google.com> wrote:
>
> Also move Dmitry Vyukov to the bottom of the list.
>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Alexander Potapenko <glider@google.com>

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2040011a386..2c293ba3d391 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13832,8 +13832,9 @@ F:      fs/proc/kcore.c
>  F:     include/linux/kcore.h
>
>  KCOV
> -R:     Dmitry Vyukov <dvyukov@google.com>
>  R:     Andrey Konovalov <andreyknvl@gmail.com>
> +R:     Alexander Potapenko <glider@google.com>
> +R:     Dmitry Vyukov <dvyukov@google.com>
>  L:     kasan-dev@googlegroups.com
>  S:     Maintained
>  B:     https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
> --
> 2.54.0.1032.g2f8565e1d1-goog
>

