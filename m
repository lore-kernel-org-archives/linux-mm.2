Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E68E7AD42
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 10:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D406B0088; Thu, 25 Dec 2025 05:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3533D6B0089; Thu, 25 Dec 2025 05:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289CA6B008A; Thu, 25 Dec 2025 05:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 158E96B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 05:22:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9950E138AEA
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 10:22:19 +0000 (UTC)
X-FDA: 84257603598.21.E858155
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id C006640004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 10:22:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aNhUZvgi;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766658137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsYBY76+84DgvKPe65RfD6bpGWfxyRwsx4CSiVVhZN0=;
	b=E6QvxN3/UETv/V0WYaGxfOTHH+KOlJEgdOAqtnIHzuxWzLN+FOL/RUquLZayk8OSvg2wZ8
	VX+7JZN3HjE3nf6HZDQ270TfAKzJRvoewTlC9MDXvTbeQ6whsS0rYZFlClGYnXMcUq41Y7
	teZPFBZ+90+1Q0PeY/H8nzHmMwbfnHo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aNhUZvgi;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766658137; a=rsa-sha256;
	cv=none;
	b=O99hMFNcSWgdrYfwtYc1oW2RfNl9wEnL6WrJGVHHWPzcNLdDo6D+jxDv4f8gQjp6vLC3ti
	dMRu9lBTA2xcFtksQI1tWqlztHMOKz8MTZDy71rKN+wLckabIV+eDx5Gftr3nUGxODxvgT
	XqJMuSE/KZUyMo0ktIevxiRG6JjWJeg=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so36470666d6.1
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766658137; x=1767262937; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsYBY76+84DgvKPe65RfD6bpGWfxyRwsx4CSiVVhZN0=;
        b=aNhUZvgigCy1ktfk+515lvH8eXDDwfV+7cPZ6nBUywZkbvWUsbA19rWEpE6XmV7MAM
         SeFnG56uzcvs1+VL6GcamCxlLQFVs/eYm+dc+EOkOGzE2/fm5FP+h8vhrR+ZToWv5OAr
         Vdg2Vcx5dmp3GFuqIBfvNUpOTsv55tUqBOIlI0dflQFB2/JJG5q70SuGrJdGdPxsf55A
         2YkxdN56stVV/ba4+SncMUY4MWgAPpKnT2zVEaXOmVvy1LBtwm+l+1cqdLlbN1yI+5uF
         PPD8k3NypBEDMYGBiLwa+LPcZbWdq4N7K861XJGxOHClZ4Y/22lnNiUSFHa7HeW5l8/8
         TKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766658137; x=1767262937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jsYBY76+84DgvKPe65RfD6bpGWfxyRwsx4CSiVVhZN0=;
        b=SH4hVzWbLJ7dj/SKe+2x3iC5mr9Ieh8DxdSmAWVA3Goechi60Ae9MF4tYmTnEIXpC3
         nOlH9wJTUXIs+za6iKHF0HYjE9UidDv44y3osahwoH91TevVMIlWlxTqEDyb3WcAl0J3
         U5BX0C/AbMMgV6tsu9xbSl2GAPeb5qeQGhaFMngb1FUE8Si7Ba6TFzUetELBgH34+QlL
         +0btGvF4RTNOPJI3aGh0q4Um0fIdp5GivHUHP5Dd6TTb9gB+W490SqnmlxDNd15UfliX
         faMlS3cZu4C6Vw3eBcRL+1t8gtLyfsMZheJm4zsAtuNZcxctf8SkvLFttnFY9d0P79v9
         JsZg==
X-Forwarded-Encrypted: i=1; AJvYcCUs8eRdjaepvf8m4/SQ/xAdYBWLIYImsMOcnG7iQSVNXeBQ6aLBEuIeyto3GaM2GF2Bq7GluFm+Og==@kvack.org
X-Gm-Message-State: AOJu0YxG+Bki1qG6BoagS75qsJlXIIRW0XYCfZdFbxs1bNjOIn0usOjd
	98NAgoStfls6HMzXvBrmFbDsxIoShhyadRAw4CPLgZoGXkPv3D3yjDrXnrC3tKzPAf9RXwVpWs+
	Ca83zKCKGiq+Nb4EAZGkC80rNvRcEVEo=
X-Gm-Gg: AY/fxX6KhdoD6aH1AUCIKq0tC7nuMLjzaWQapuUzw9zD5yxStxwT2/17NZR/RKE7D2m
	tunn6gL0LoVU2qFegjW1LClrK9Ji9osUVETAR8kNiyBwHY6V9SRIwqlhBfQci6oaosCioiwkEC9
	A2tjkjbCD8EYyGjwokczWG2dmzukKWexPASfa9jwYwcy3w+u3KPRhoNUnObejZNlSfZSJG1YOQr
	OnbzRT9Op/Zzm8vrQoibcMVGhpl3eW/bPw/2B6l/mX9CprMLVPtitTe65WuY6cgnfVPhJQ57akO
	D+5U
X-Google-Smtp-Source: AGHT+IGmFlztrWhZfsjY/2MD3G/Mg8UHh2dYWY7DEEw0dKzxvOIel39WFb+alsQxDjJUNwgXgYFN/Nefbl5c7q866gE=
X-Received: by 2002:a05:6214:1943:b0:88a:2841:bb11 with SMTP id
 6a1803df08f44-88d8213e38cmr370646606d6.27.1766658136710; Thu, 25 Dec 2025
 02:22:16 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
In-Reply-To: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 25 Dec 2025 23:22:05 +1300
X-Gm-Features: AQt7F2r6wYgtPv_r8pAe-hrAL52jLV60jj2LyA5S3Ld8aU6hOGX6LiFQmicuMJg
Message-ID: <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Wale Zhang <wale.zhang.ftd@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9wq76ufmpym64hruoaokrh8cxdqrbnja
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C006640004
X-HE-Tag: 1766658137-30471
X-HE-Meta: U2FsdGVkX18RqiXz9HdiIRlnXnBUQ8cGP0iMbrnZGX0f6ygeJpxEgXftd6caEXiqeLZYDes2vYFe3E8qCczEn/+GTQ9lQ0QTD3dDqBPSZs4GpWYQRzU+AOYgx/7N/lDHGC9MlDGXjg6p19jmZ2HJ9Qn4BxaDcBuJHwZ8KiP3VKq55hskh2KIwhlFF287RXWbqcm42JkLHMzf6US+Br/M3/5Vc0sD+Pw00fqXQrtH0n351sLJIePgldVwt+6qMvVGCQt3zJ3p++TazVVfSxjKn+DIeBP6tYXKEGY5xIYY9kp0HhIUc32ZIsm3CVc7eSOhg6bTo3fYyWo2p1vLhr+zTJZw4NnpEm6PbqoEr6YdFM5NfrhJHlMyBW31qsOoPKqUgQTFFX5QsuqyUpXvkB/wk0KJb5mF66XEFI2JpmCTSuG+Yowmpj4KXeazAX4h9HjlvxoI9cN8YxC7ynkxWAc+BYa5B/RosTR95EfPvJi9838hRLvwq1T+UeKwpHpEA5/KHUbXqpe048XLOaBrjmvQU/OrOWJvY/YMATzgCFicKERAg4dbxKkIaIgnyvyNj7qEXAK6KWf76lvbliUdFyvCfZ+G/0fJweHgp74/q50MwJLAL5VxX/vKSZeSHLqxLj9Xh5n5i6Xz3XB7LwgRh2pDg3SLDSz2F57ODxxOmCWbKv2s7IXT2OOowOT10Ms8D/r0Hjwhjokq2qfD7WyavRCVmjTl6g2sq+QDEVxYSMlhYufPNeSIUM9si9J2+Ew2eq9pYcX0cIDJ476XNz7AFIUrEVSConc2NwoB7CbmdSh6kUNLvSfX7R7xvBWG34QHbmJjqGob9pFRRkn5KspbBWR5V/S9slIIu8BuHeNrrIFXNS7vjw8UKNnwYZzSxzTOFiAdIy3EOpgDXdvpg0pUvqjgvi+TAo/4bf1ANdgDoEMJ8i/gbNtFCptoToZNB+5w57J130+HIKjc/UdUFVXZuma
 xr7KQKJi
 yrevmPcq8FxQFUT6ppVnmxMkUVAnutr2+4psidLXvxM70HCTBbJ88elFVxXrU1k2W2ByM1H3qPP//2sBEJgpPieHi7YrimqqU4jfWPiWid0mE47C3l0z80AyqKwuO/la4RJKMyf6RflI5x/y7Daa/0OfI7FNLrP6TfbXSceaftM3zONqLCpq3/UchJIkJwY2gTxAdtlfCj6s0N8Rt1yUmKqw52qbgwZSz8GDSC/nF5c8pr8DhAbnraYlxmxvB8BMIFkA3yhrk6xybR8cjElTifbMBThILdLYsED12tkNn2+G3LzAoFexRxXiru21/pLcqwocEtxMEqSKXIikesA57rFXaHOLFJXrVE0Ta3N4NHRaKLWMXJemqqnV8VQhsBTEd0PY0i4nsjEl0bqe3PaH9IYdS8LHRJXVdrOojqrnvYBIFqyx2IiZpbERkAWGOhF9tki0quv5C+hxuE+zPvrIcakOSXdrAWuChzVeMmqVvgxMsNCcSRYedvWBjb06bb3GN/af78F0rsuKAv6dZiK/WLw9bcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.ftd@gmail.c=
om> wrote:
>
> ../include/linux/swapops.h: In function =E2=80=98set_pmd_migration_entry=
=E2=80=99:
> ../include/linux/swapops.h:346:1: error: no return statement in function =
returning non-void [-Werror=3Dreturn-type]
>   346 | }
>       | ^
> cc1: some warnings being treated as errors
>
> Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>

Sorry. NAK.

This looks odd. We already have a BUILD_BUG(), so no fix is needed.

we should already have:
././include/linux/compiler_types.h:631:45: error: call to
=E2=80=98__compiletime_assert_907=E2=80=99 declared with attribute error: B=
UILD_BUG
failed
  631 |         _compiletime_assert(condition, msg,
__compiletime_assert_, __COUNTER__)
      |                                             ^
././include/linux/compiler_types.h:612:25: note: in definition of
macro =E2=80=98__compiletime_assert=E2=80=99
  612 |                         prefix ## suffix();
         \
      |                         ^~~~~~

Do you actually see this being built? If so, please help identify why it
gets built.

> ---
>  include/linux/swapops.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 8cfc966eae48..84eb36d97212 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -343,6 +343,7 @@ static inline int set_pmd_migration_entry(struct page=
_vma_mapped_walk *pvmw,
>                 struct page *page)
>  {
>         BUILD_BUG();
> +       return 0;
>  }
>
>  static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvm=
w,
> --
> 2.43.0
>

Thanks
Barry

