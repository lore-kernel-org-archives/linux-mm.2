Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942E4C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D62D6B009F; Tue, 22 Jul 2025 04:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287278E0002; Tue, 22 Jul 2025 04:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176F28E0001; Tue, 22 Jul 2025 04:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2F376B009F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:19:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B7AE1D9712
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:19:29 +0000 (UTC)
X-FDA: 83691201258.19.7790A40
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8AD5180004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:19:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KjCcUR/v";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753172367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5uEarl3m6/o+HHucS3g1DD8Uh1kLqoLVobls2sEucE=;
	b=hDe1lv0uW7V3SHs3ABf/jnJ7VZ51SpsJHyqMH1lwQ0hYTUDejocnLXrH2/Okypgg8nNab8
	7eUWLbzhcEmc2RgBGi4OiJ5pGDGsmXm+0+ZZsciOFi/ShFPX/jIvkJfclpJD4ip8wuAbwp
	lwMUw8X8FPesD2lr0nKnSPKScfeD+lw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753172367; a=rsa-sha256;
	cv=none;
	b=SAAIugSC9UYXxZfZmKTFbYHOalFcz35pwMQSZgzOlX0HxKZWilO8CEa4oEzUBbL7QpNkkC
	/oi2fgxxRCGeVvqr7xrS2jHV4w+DT5r9TSvnQbvr9OGCx5+UlSrZilthues1+85kpy5/7o
	z5Mgurkqll9oEMI5q32EpxidyPEylaY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KjCcUR/v";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-87f161d449dso7024350241.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753172366; x=1753777166; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5uEarl3m6/o+HHucS3g1DD8Uh1kLqoLVobls2sEucE=;
        b=KjCcUR/vkv5piC0SlmG9UBfs8TP15ZcEoBF83A72mmWhX8mUwyzNFF91jG2lE+d/fT
         6x7HZh83cmWSb5a4j1Z2PXMdWdCD41M7iMUqkzGlUCu/9CW/GnBXjV5vK8a2tBOuzTMy
         BTxoR8hRPUPl2y0EI/jMUMW4N5n+x4e6P30C6y1mRmOemUXtQ2GIcl26m1OGZEjD4mep
         Jd24/OYxeBTBZjiw03LArefMCZmxHZKI6MdvqrwOt35XECtjkvMHQA6US0w8zNLbvuYn
         eCSvaxCHsF6h0OGZ7Ax2FsTDT6vXFLakxRHxOJQ6Qig3mPME0Ipc6j+QeNci0r0kOeem
         WAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753172366; x=1753777166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5uEarl3m6/o+HHucS3g1DD8Uh1kLqoLVobls2sEucE=;
        b=ZpZ6eGnl8LnvjLlww4GmBbIB3eG0p74mKM/goTE6tHzCefFXl1+/nFtnNrF8vZvUnD
         mHhj4sjh+mG5FlsHL65M0V2KpQylj63b35KEqaHwM+PIQEygFbPQa5Nkjqkc2VY+B16T
         R/SjLBsJGpzo5CuEniHN2hRdeXy4JCmsRb8y9Pye22+aUH4JXNs30cUglZpjP6Wj4Brf
         hJRBjK1km4un8mODxqe8pPYnM4kZbFK1GJNhQdxx8XigGROlIYrqjWp+KkONCM9AXBWD
         I1VvD9AKPwhabbdFEOS3g34UqGU5ml0cuH6KnN7UNIQomoKpjbhLX/Q58VtOhGWiUfb0
         38JQ==
X-Forwarded-Encrypted: i=1; AJvYcCW11Y5jADMCnL90bT9yeFfVyjzzyI70zUA9cuS3mK8+FnLKu8UwM3ZQjTngYtJpGwHcSOmJoCgYkA==@kvack.org
X-Gm-Message-State: AOJu0YyVnAOaWVspRt8XHwTPZv2BFcqMsSnPLyrDXHiuXevQqvpAH+l3
	2P42XhToI6Ac+WuRAbnsWdf0hOo/nOWrfVuBOPxM31o090HEwGhqe5N/ev8tV5F9rxeYcZKQ49G
	z4WoggczhA1N6WUkhilmvw7Rtqapz9qw=
X-Gm-Gg: ASbGncv4IfoVeIaZEQbCn1s4gcwx3wUJ5KVCcbZMmLLRSJ6t5i/YoKmsqFGBtAtAcQ+
	vaAl7RLjq3eIXSEIyVJm+5rjh5W+J1n1/6oJNnzXSjE85HNfiyKrwKCo0aCHbes7rNp08lsZzkf
	YMLBsc9t473wwWKQuva2DpfJBgS9x5lJYPu/FZpvZjRQ8Bj5td89UVdS0ec7/n5s7fws6/vW9QQ
	nPkfag=
X-Google-Smtp-Source: AGHT+IEnf6eJQ74gAkSS8lZskiicRVKUaqFZPHtdp91Qi7KcUaT1i48pIDIZaagumwQ9M+juK5jzXPuLAJ1O7NmJyHs=
X-Received: by 2002:a05:6102:e14:b0:4e9:a2bd:b455 with SMTP id
 ada2fe7eead31-4f95f3c4676mr10913265137.14.1753172366543; Tue, 22 Jul 2025
 01:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com> <d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local>
In-Reply-To: <d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 22 Jul 2025 16:19:15 +0800
X-Gm-Features: Ac12FXxom8CXi55J31hHCqL2RSaeqJyDgE4F3wONdD9d_5GA7Yp3rbkesesv0eg
Message-ID: <CAGsJ_4y9rRC54E4sma8fhZSd3aWDY2ubR+o5Et=cAeK9+gmOgA@mail.gmail.com>
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never" setting
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A8AD5180004
X-Stat-Signature: edcqnhin5d8bew8rdmjzf8jigoe4kjcf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753172367-802391
X-HE-Meta: U2FsdGVkX18d4pQ1eHfhOHzdnBoflZuElDcRRgu47JDokDHuJjkspQlSg6YiQ2xlEHTDRQZIfihUuj1F7Tw6gLEyn1HbB/7Oji6z90qbGsi/7PV73I3n/1id8Ce56cVMyirRx5u1mE0j2TChvX9JrC5pGcAyFjT0WountMU+ZHUZH3XCtxsdpJJ/TkSrSUmQo6BW/71KaLjru4buzZ+qR+sE0kWEUptByQkmmr0a1Oke4/ElJJ2NMmDaislis9J9y+FkRR2+PXMeF5XTQTK9D8ZLcQXA1G6geRBHblPDTofc5uIxr4w6pK29BFhqbWVRCx1yMuA9ZJOIWu1AatCZWTrVoIhOnOJMPg7e0dWV2KardBCF3V058tUc1f2uUDPddG/cQp4rYZnXZdmjJUvHjeq4eTZPKURc6cK7uYiG4mXtQp9EKnkQ5kxPh0jBFilZadFe5OkJefVXCxt2LMssJXLTQQQEvgevh2wKLHSE4IZOoiRe2E9Ze1Nppsanp3s7jaoBaQIy+bmNRXbS5HywavJ2CZLJPYAo9RCwHGaYvebpDDJ1AIDgiVV7o48XpFdJFM9/0vqsaz23wX+WqeoWxvjeJ8aYcaN0EoN1Y86SdWovo1KXkjYw5aDeOUpslbMMcXWaaRBH1BAaaz2NSr1ekD3vJyDC6Z0dG3YzmU1xNZOQp7korsMWpLn4yfXjqGNK0EMho0oVaSbi/lPKDxywZmmUh/dJSumG1cLMIzW3aBHDoasmalpbBV33x1QcwZT/qewyHizWTgcBFiVmMdgp6c7SfGxOMUjGFRo+xKJfUz3gzOrVhGCyAlyWbGQta1u2G3IhPF7nZRxsC0Vk1NmW6HFgBRTf8L6VpzMXGGzQ35+RjEqJjWLtG5AoLab/eNIxnThVUN2mEczIe+ZQRK2U1KmisjInApxtXyFM925lvHumg4Iose1eLuiBHTXgAtSqSDZSWIiAsbwL3XchX0g
 bMpDE6sv
 vxH1P86L2KCPEOQsUU3hh95khhAQihEpLQjRQx4h7/OBB11W7Bw59eYPdRHqHXHzwElmozv7UZuzeplhWfIWaThR2VaxXgG+bfNzcNWFH/iKcrCv9+DLNRvsmd4xvLjb/HF0xApATXS7GE+NcmTTSRKOiI25+vmvZ05Zm5XDsYhpQ1T3KAHppYiO9jTkzCJiNg/nTjE5bFDuKPmbT28K62SrXXgEiEyip6O2vdOFJxc3wtZ052sKMAuh3viejHHsPo40bf58SFp5U0XaRXb0tEOmSIz/FalN4IedSBWaZyFvmFn5QDK46zfkj192JvwP36nfavhoR6t7fZosgXZM99fuiQZ+8IZQxGcmChUTeLeEfRas/sokkAM8mBjsO2enQl304TAiz8l19XcQzCdLRo1Id8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 1:34=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Hi Andrew,
>
> Could you apply this fix-patch? It adds the caveat regarding MADV_COLLAPS=
E in a
> couple other places whwere the sysfs 'never' mode is mentioned.
>
> Thanks, Lorenzo
>
> ----8<----
> From 7c0bdda6a633bc38e7d5a3b0acf2cef7bdc961af Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Tue, 22 Jul 2025 06:32:18 +0100
> Subject: [PATCH] docs: update admin guide transhuge page to mention
>  MADV_COLLAPSE everywhere
>
> We previously missed a couple places where the 'never' mode was described=
,
> put the caveat regarding MADV_COLLAPSE in these locations also.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  Documentation/admin-guide/mm/transhuge.rst | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/a=
dmin-guide/mm/transhuge.rst
> index 182519197ef7..370fba113460 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -385,7 +385,9 @@ always
>      Attempt to allocate huge pages every time we need a new page;
>
>  never
> -    Do not allocate huge pages;
> +    Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)`=
`
> +    can still cause transparent huge pages to be obtained even if this m=
ode
> +    is specified everywhere;
>
>  within_size
>      Only allocate huge page if it will be fully within i_size.
> @@ -441,7 +443,9 @@ inherit
>      have enabled=3D"inherit" and all other hugepage sizes have enabled=
=3D"never";
>
>  never
> -    Do not allocate <size> huge pages;
> +    Do not allocate <size> huge pages. Note that ``madvise(...,
> +    MADV_COLLAPSE)`` can still cause transparent huge pages to be obtain=
ed
> +    even if this mode is specified everywhere;
>
>  within_size
>      Only allocate <size> huge page if it will be fully within i_size.
> --
> 2.50.1

