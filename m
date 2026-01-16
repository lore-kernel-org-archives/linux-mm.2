Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35C2C982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574CA6B008A; Fri, 16 Jan 2026 12:22:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F516B008C; Fri, 16 Jan 2026 12:22:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BF06B0092; Fri, 16 Jan 2026 12:22:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3351F6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:22:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5EF68967F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:22:49 +0000 (UTC)
X-FDA: 84338496858.24.3B7C9D4
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id CEBFC160005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:22:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b6vmQRTC;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8bloAHXlRqX7bbyuExKq5up0OoLL7i4hXe/j4ALHlo=;
	b=FrzQPjALnlC35+NGiiZTZcdI3yixs36bfbwS0cfgAT1qFoK7NEUedgxy1vZ3QNXjwP5FuA
	hT+hDUlG7FfHl9gMzQIrsa7RFqXqS6Te4cIPZhXfXdLW7xLnyqfWjSY9eY2j7H8VrIgy0c
	I+MmzabnbYOTgnWNrCh2JR72RQmdWHA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b6vmQRTC;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768584167; a=rsa-sha256;
	cv=pass;
	b=Assu7SvCThAvuvsNOBxhsYdMvmOf1rDvuCscRSe6RFbVzNGnOaJSdEgI0BSu8iAkWcbiaI
	FqIm67bMgXmMzztfHe4ITGpuXuTNwucMNjIYt/rhhkJbTfltgq2cWd8mO42EOBx8mtR7nS
	voz3jmSIHQ3HvCOTkc+wcI/lxF8fkIQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014b5d8551so546831cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:22:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768584167; cv=none;
        d=google.com; s=arc-20240605;
        b=YjpgVvDNxx9O7WwQ7tgAyhYeqbZpYV5id8nRSVlPk9mARs+rM41KtVrCJrOAcprJ45
         HJysgC1w3ZG7m4iYN3ntKL/NG1abNyAcXG1k7CtEcHEw2FaAFq5xPgZy+xnbtZ1OsK4s
         oR3k8DGDQJ+XGugCpboMlXMAvtHirQGGVWOUqjreZozOMY3FOJijQeAx/ExmLH6ycsvc
         PWQOCQRIVP1yVj4QvLvyECwHUrRGdzD+18NhM3MounPhFHCps8BSipR3Q+e7Rjmwm/Jq
         qKFqOvyPu65228M1BmSr+o150cmnCvSDD+p+g/1pbr9jn7rZ+wxnwJig0Tw78gaUH4sl
         4i2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o8bloAHXlRqX7bbyuExKq5up0OoLL7i4hXe/j4ALHlo=;
        fh=g/OlPt8g6Yrz20HocdLw40B3Zd+TotCKFwytj0k38Tc=;
        b=H8my85RrYkPLYPjrYpF6b1ivOyaWSbR0u9QTO1thfsxazsvqP6pWWcAsL8PXLpKE/Z
         vPFD52jZVD24fpn1kj4m+9WF6VfZB1wqbgQBH/K2mzkQPa3ajRmZo4cbbYOxtjeV7pQC
         V0uWtrOCJFdt73C4kUNaSqR+8esHn7onyl3gSGbV5hg/6Lsbr4E6w1NvYlcdMiaPRMUj
         Psnx98d13uS+5W6AzIuoC44y9SpSpxXZllG+f2QvTx8xwwi7TTGEuepX5OO3sncwrCOh
         T+okPxSs1+16sc6RIX7oQ55COREX9W2JWbphoPfoUy6exLLHLvhl3l1levgP6sNVXo5p
         pkDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768584167; x=1769188967; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8bloAHXlRqX7bbyuExKq5up0OoLL7i4hXe/j4ALHlo=;
        b=b6vmQRTCXgeWF5j3Vd2k/8mmWzhFGbp22XHprl4oHVAt8lwggKHcc0DyIrHibmGh8t
         b5avNacam2mIM92qyd3d72xcll6q68MlCbz9+MZ4ZPn1UDR13tlQm3lZclHPUckTnT+c
         c/3UeQiJzM0w45CdvQQKQrSH4C23mNES53FMsSqoG5Nwpb4/P2vRggG63fXxqR53AHQf
         wMu+wtkt3URXB+vUx5tuHpE5zCIbxGde2jNIs+28H+pc4kvbi8gS2FoSrIUkFAOVfGOG
         fFgDg9fcloEtH0+hNfJP3S+ptjMlETN7KDOx3KlRerpv2i91xToxDo3FPtYvubi/8X39
         x81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584167; x=1769188967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o8bloAHXlRqX7bbyuExKq5up0OoLL7i4hXe/j4ALHlo=;
        b=ihbDONN08nmi4j5nIdRjXySRjso3FsI95DfbuKHTU9rs+qcsDwoOk/y9m17U2A4XDG
         nmmViyVs3zxQOFkta23YLoEd+qP1NbeDBSh7B4ii5XTEN6wvaoRjmvHk4ggM6AdEXrjf
         I+QRpfrP/nqvyKahlpmFR8BCOIJvIvvqMUcqFydI21VuSaZhzKNbimG5NKDKDypv7pB/
         YGuFKppvXOn4DEUs0IcUIasgCrXxKUXA24p+V62PoOD8JFEPoyKd/mwqbP6iPzx21Jv9
         XZ6bdbT2RKy4JRTILxaAgGyxNTPKxcrYzayJJoxPK93nW+dLcL2AqiYwHZz6TSThVVX4
         JxWg==
X-Forwarded-Encrypted: i=1; AJvYcCXt3UsOfXATLWXHlrVaVnmNJfg2Jxk3irFBM5c4HmqP+HfJ9uvRKSx5p04W56GkoX1QcPx855tnwQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6TkIcoXVvcnJeldVj0H99HwEoDmfqeaCV47TWsm3ONcH6JP8G
	j+kzF9Y4eH1KnhqQADV7nFSQeOnv/O23CYlMvMNHxZYUOCymwzjhJYUD3YJTydqr/9Cnexv/IYG
	f7GjX49a2lVbu4hNGSlJYLZFqBv4qmx9wOJx8TFN9
X-Gm-Gg: AY/fxX4AxBG2BkL+8kieOkDxtosqCf497y0SettPDTX2BtkikOf4bmsdkb+NCFxjM5a
	n+N/9+35I6ry0Cgpk7i68ODuY5YCegKWit1KDCut0XSlla3XzOOQjZvj94M5LvNmHpXyL3Yr2mQ
	fh0ZI7aqTWCMD1jP7/VUGDKkk/9HUGd7UrU7wlHg3j5+NXOIFvif8DjnLgTpE56LdarhiHmKygd
	QQIsgimKGPqGrHuYuNFiJm8fx7mxeSqcBw9zHdIbVlImJ4YHv4QZnPxP5XOOofxv58Xfw==
X-Received: by 2002:a05:622a:1446:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-502a22d2091mr4481531cf.6.1768584166336; Fri, 16 Jan 2026
 09:22:46 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-2-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-2-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 09:22:34 -0800
X-Gm-Features: AZwV_Qi0GmjrM2TkwQbQz0K1_wtQP23K0QN4VNJnjVMrHBscdtK49aOG8chDQLg
Message-ID: <CAJuCfpG0SCGf-TOTRi0d8e0Zoh4r5-xXByhnmJRSiyUt9=LO4w@mail.gmail.com>
Subject: Re: [PATCH v3 02/21] slab: add SLAB_CONSISTENCY_CHECKS to SLAB_NEVER_MERGE
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d6duqy5tpseyqzwkn3fxejiz3zeeju3y
X-Rspamd-Queue-Id: CEBFC160005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768584167-42686
X-HE-Meta: U2FsdGVkX1+XeoHeCL7rleqOMCcdbgaxSh5ewEH1u7BhRjZDXMniQcISUpPr0KFIlAV9mMPn0BvHdOxGqwJyGqFdcn3EmzY8W1T+V3hjJGoQJ+9IblT6HV/JvOF71Hxh3r9MIWgmz6D11O8amXZVpdJxv34+75jdlzm+YsxtVEFBM2xrr0XrgQA9gTYZkGTnOgJ6aSOLHOSMrEhSG7mpkVia+GPPc9vLQAFQdvAYoEKV09v/iHBfdndAFUuoMEPGYs8h+KKUSOUjlmnVPv4qhhM7I5lFulsdHoQLpbbhKK95WrHUYp1eaGo1XIghbUN3XBpRpuy8MRtURZp7e6+qjzNzsUcUP4oHaDxvAQj1IWopvJwS3nMf5lPJ6LIDXWvhRf4ppGgCJYEjzTWgFluH10zJygV2RUc1iaw/4SyDsOPR9JJ2JO36cDztXmGydJarPR0EMFeAUf66+diIBf6Q1v7BCdWBzvSOJ1b1ANzdH1heN/Ta36SSNBp1M8AOd03XyiLDyjHlxLNiROeJLrlbGVOIUxBw0mYGhc01SO2AQboCrgBJn1NIZhzvcqoTQUsFYmGVnHWB16R5V3+Na4IHvusT+kU4VUmu6b2SB1aQ4+INHbZH4XYG/hosNilqiEd/LBoeqDW6gjkkL+x9NI5g6o+XclR5ruf56/yGHJG+Qj7q5Lk4XJHyF/dIs0JRcDDg+lb0QSoLKm3ApKBoHbvucSQ9c5f8wPnkNgXhEmPUDy6utQsMEoHkKcHG7jsemWwyNlNEJzqnp9YPq9ZoyrR1PubrtNKWBg3PCNY1gbpnmNXZLifuXUmzgXROrPKOjf2IrL0+oY5B41Ksa2vJWKJTXOey9DF7HYVNBGE5yaFk7lYSgu9H5KiC05Eo/X3DMVm5hHI21pNzMQXGUgj0ZNNxmRDIoyBBi/yQhwdSMSO7vzMm9K8KL9v7ZbQYzfMBQ0uY9Y29RkDeiuwx8lKmsXG
 REorjghL
 j+dBBQvWsNbklv0zbwc8X7C9aSkw2nIPYopHe3hdlTA5HbPZYEcWeOQD27wCHZlt7/bhLH3RWKnGMPkOegciX6V8lG/SEjiCNdJQM+E6yjgJLaxdayTbYikOKeIW9RPWaRDZal4eHaG0hHb11+uL8jZKfyM+SCLmbhdfk7XF8B84fSvE/IdwfLaOMT+zREo/mtpKEp97LMjkHDQWkJSLKaytaOEXKEvlv6mFm7vihHoH46Y+gvhxW6a8wIs4kHQJ45ALdlrcD8DVqMXxLqHA7KGL/cH2zgukCIa/r0Nj0eDw6J3vcViylhALsCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 6:40=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> All the debug flags prevent merging, except SLAB_CONSISTENCY_CHECKS. This
> is suboptimal because this flag (like any debug flags) prevents the
> usage of any fastpaths, and thus affect performance of any aliased
> cache. Also the objects from an aliased cache than the one specified for
> debugging could also interfere with the debugging efforts.
>
> Fix this by adding the whole SLAB_DEBUG_FLAGS collection to
> SLAB_NEVER_MERGE instead of individual debug flags, so it now also
> includes SLAB_CONSISTENCY_CHECKS.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab_common.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index ee994ec7f251..e691ede0e6a8 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -45,9 +45,8 @@ struct kmem_cache *kmem_cache;
>  /*
>   * Set of flags that will prevent slab merging
>   */
> -#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER =
| \
> -               SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
> -               SLAB_FAILSLAB | SLAB_NO_MERGE)
> +#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
> +               SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE)
>
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>                          SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
>
> --
> 2.52.0
>

