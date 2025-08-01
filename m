Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA741C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762616B007B; Fri,  1 Aug 2025 06:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC6F6B0088; Fri,  1 Aug 2025 06:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3A06B008A; Fri,  1 Aug 2025 06:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43B3F6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:30:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1D7BC08CD
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:30:30 +0000 (UTC)
X-FDA: 83727819420.10.14B916A
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 035AA18000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:30:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AncwFI8D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754044229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2R+MqrgO5Yl0URvHmsHiXNr06EO/8hBJAf8Kunyd3Fk=;
	b=E3Jxzq8Xwv+QNZrDNGS7uAYF5Ij7ZgXhZIkF1HCB2c6Teld8of2RG6wcJXKkxB6WzBLFrQ
	xcB3KqZ8+eBmiMXr8hUIcdIOEWAvrerjgi/WKM9VzPEwa8i++00RGHSX+dNe/LuZhZzfYh
	qXkJ4SKWrDr2Vw5iYTyEfIDbF8XLimc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754044229; a=rsa-sha256;
	cv=none;
	b=JlOEz0mWZ7X2dfSNDvMq0SA9zS5of95FbBEMjATC0MSRI9V95HE90G4Ogdzxp9wGFFMqTI
	HPO2BD5wpMHyh/SSKoDaOvyxrHIAmIN/J/QnNyKlY9VjNZ0IDzLn5wcjEZgL3Etrtgd7ti
	NnUbU/FTLBkwoM397pvI/FiHpZxUeLA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AncwFI8D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b7823559a5so1119365f8f.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 03:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754044227; x=1754649027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2R+MqrgO5Yl0URvHmsHiXNr06EO/8hBJAf8Kunyd3Fk=;
        b=AncwFI8DCy7WzQvf+kZVaZdADgKus5qCdQo2nbY2uUPMkKRvukhPqRV9aeFsKjgEyM
         0hvuWYLfWYHPFxctet9LfLxrKhQoqo909AZR5qqDxtBACYRfD6/RQXePcRp947LTOvnc
         j5bdgt5J6guS5LVhB572XMvXbBpHBkSB4HBqVKCAyCSJj3wfRYTyR/kHChHTfVYJ45Fb
         JOvDYeK4v88hhFqxS/Yrvq2GHVoA0S99DHecbDyBYWonWzWHzANK9U9EnH0WhQrljlTK
         4GTu3aqUShXj/HHOYiQxAHW3p04CuBLXF9zMzyjrHGjpZD16PGCGq7yIalK6I+spvT80
         ad3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754044227; x=1754649027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2R+MqrgO5Yl0URvHmsHiXNr06EO/8hBJAf8Kunyd3Fk=;
        b=FrRRGJs6uAyKlm7FwI1wA8W5N48GQudJ+YfIhKbJnby6logSGm2zXH5bk1/pX0KfSW
         q2t7nMNS3UQbgyDn0kyYqTPYjkKrfh/zywv/8BeDGpqA48OQEKDB8TqWc83b3L06wPPP
         hAENdqfBCFP6aTzahbbuwcpkZr/IhV03Ys3WPVafwUfCNN3V3hlxv2mYEZ+Ag308YtUU
         WOKW8Sqw+hiHigXb15tdEf4iooS4++sEPH+MVQ7jCUVu1sSQshe/zEGF1L0A1nU8kb9B
         LTDbSje3D77jHdKzPFCVU4ZFyHFTYQYcLdNFPqXJ3nyUsjhXMROOYXoApXLH070frm9m
         2KRA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ2z3DhLMXYFvz9/iO4kNuAc1OOe8lAECtICi0eGR3nsBFD4WE/p7USau/8Eg1KBAK7+JKKJR/aw==@kvack.org
X-Gm-Message-State: AOJu0YycThQS3za3dT9xPo6Q+4P1cdXIRAtDn1g4Pn7fg5gmuuaPlxxu
	yQ8DcxTYLafwMlAUMX8jpMzrUrKRWBzrG0NAn9DXMjr6q8mIEx4iyLcEyS/eK0z5XNUNm3el957
	ikYfvoZSCoqf8EXYYGOgk+1XdwaOdfb0=
X-Gm-Gg: ASbGncuoa0qPk64DUoFETxPDLFGtQevce/551eCePOaleN+py7xfoagJUajh55n0CiP
	9TnbuePJ2rcOi/vn5+uOs0ko9PlfKCnibpsbsDcAergeQCALceQPUCR9i7ZujB7+HLBoOraEwgJ
	2wt50p10Ly4p/KthRarU7YaZg6Bp2OlL+QRNlEI6yxaBMDDYiv2ILnKVNgBwBmv92VFMgYVUNoq
	M8SvpanKA==
X-Google-Smtp-Source: AGHT+IHFfb9aylKzbGLPPo+9yypVoY7XdtvFrGtQic47H8I6uTq5dX/m0Fu7qM2GKR6tBwaCmTk4UWiTFQZcGNbSd3c=
X-Received: by 2002:a05:6000:3101:b0:3a4:cfbf:51a0 with SMTP id
 ffacd0b85a97d-3b794fed8bfmr8236846f8f.21.1754044227142; Fri, 01 Aug 2025
 03:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250801092805.2602490-1-yeoreum.yun@arm.com>
In-Reply-To: <20250801092805.2602490-1-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 1 Aug 2025 12:30:15 +0200
X-Gm-Features: Ac12FXwpbti9uxZkALv_-SQcxyY8JUp4abK1P5ZF80uVJbXi5SM7UT7UOWr81Jc
Message-ID: <CA+fCnZdiwXXYmW9a0WVOm3dRGmNBT6J5Xjs8uvRtp7zdTBKPLA@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: disable kasan_strings() kunit test when
 CONFIG_FORTIFY_SOURCE enabled
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: thomas.weissschuh@linutronix.de, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 035AA18000C
X-Stat-Signature: zpnyi7qzp4t7mfrfqsmetxj8w7gdtsqi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754044228-543322
X-HE-Meta: U2FsdGVkX19GsfC86l6gVP2IDDk6i2nJhyAuFX21DXPB+RtiewmO+xr4WMH4cZsNIRfTndzpeFjxvQ4bqFZP+yOZVjr0SSEmrnCBjJtwQTt/nLLgH0DsFk0oCapZGfJUc+E7PV+L4hLtahixdZ4rJtgByLb0QyRSc1Bf00KDEXeh1wcYTFMdgqbPWhHSJeY7Y4+VCwgjbBXlRAOWTngpNnmOSNYKJrBLctpxvZSM+7b4bSxGKcvtzMuKwQSa/vJb3DCLeEryylGQZJmCbxbXP0Axjr4sbbLeB0Hv8YorPwQSlCMbUPqikWJjALMkFReHg360fIlg9apghhc4ZcCVL47KHGRJe90FIVFUu8yG+TVLK/mfTpAR9aorGa1Lv6yMz9cdKsxihcF5IaF73Xn1TJLwPKOJJqhMSAmjJ2sIV4PUvy8hD3NSnpwBb7Ly+aLGQGhisB38ic1EFhl/WIbCgrP7YGDclbg0LEggZvi9VtLD0yuizbsW9EuJ7eXYgJULbOlMg8RoeebBXe7GR8v9MygYZh/ADx0G5rsF4Oi9WHFGFxcBKs5gwwyXzGDpUfR91EDJ0z4KSSMYuoEmIOCY+wj5GNYZx0derHvGKTesOWR2OTK8wDmMCeNzjJtqcRbHpRk9SuxZCLuAP+4CPgdHuucXHGxzHsrQtmJZKFm1EkKlfd575NqkyQrzexTocezaKYUHCXXkVAWf69WXijOzd1iqpODtHLFBNpzUFdUexzzBRJ63vFDXrEuxzKp/ay+FeexpNCL6wJd5ziIHXx0F9KybbSG0f2djlbNV47ZcbRC1WDOSCXd5XI1OuqpfQ8mXqlI+cu0fP9/AEZpvcrIWszHY7aolRyoOMxTLamYwMd9MqIDcwr9BAx74GJKB+00LiZj7c47/f8svQuyJyQ3pL1EuSD/IkH5hrbKSetKm9eEvGpc8Dk8TCFZpdRum8XLs9UIrd/3HxZtY5Evbt/1
 FEGcHCMR
 fXZbBNTDk/U8vd18C8QPWQZ1FTS/ozg9T7YELRRxhY6l7yq4kRcy3N1sRi6A2QedVGQqATVd0On+in21O0DcU1Hl9KO045FQlA/tCDEfUHz/KrECIxzroRLPAk2wLZQ7f6olvhKPJzx9RDuRN+7fx5/2bs+e/of1OoOQDs624whPI95m51/hw1L5/V6EehQY755Pdw3qqIe1aJjm6Gn8nG3hIsxKuHZWiuPpe4iIYRn437PEhK4dApz6oOORrDHZ/cN88heFLXFdYmS0G5Dmrw9xwIY5qLWrbRntFyd1ZSgdh9t+EJ76paIn1YKNvh60Mllcq7mHxTtdAMFLlGx2mJgVtFGEp39zqXpGnhXzHa6HSxKvfPC3qYMViiiXQgxokYkZ6VESYPFqFQRiQ9GOHmNNxmyA/InDoXUki+A8N4wZfnFt18TRza6xG51ogoGU7Q0dynWx9igWZ1nRZocpAp6EuKjQchPMq2ilixg1kH9b6odpoJtH4JeRbFQmEI5LFfVS7xuQkM9Wpp07KqiYL+IZd4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 11:28=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
> triggers __fortify_panic() which kills running task.
>
> This makes failured of kasan_strings() kunit testcase since the
> kunit-try-cacth kthread running kasan_string() dies before checking the
> fault.
>
> To address this, add define for __NO_FORTIFY for kasan kunit test.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/kasan/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
> index dd93ae8a6beb..b70d76c167ca 100644
> --- a/mm/kasan/Makefile
> +++ b/mm/kasan/Makefile
> @@ -44,6 +44,10 @@ ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
>  CFLAGS_KASAN_TEST +=3D -fno-builtin
>  endif
>
> +ifdef CONFIG_FORTIFY_SOURCE
> +CFLAGS_KASAN_TEST +=3D -D__NO_FORTIFY
> +endif

We should be able to use OPTIMIZER_HIDE_VAR() to deal with this
instead; see commits b2325bf860fa and 09c6304e38e4.

> +
>  CFLAGS_REMOVE_kasan_test_c.o +=3D $(call cc-option, -Wvla-larger-than=3D=
1)
>  CFLAGS_kasan_test_c.o :=3D $(CFLAGS_KASAN_TEST)
>  RUSTFLAGS_kasan_test_rust.o :=3D $(RUSTFLAGS_KASAN)
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

