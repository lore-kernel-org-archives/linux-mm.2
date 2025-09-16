Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2ECCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ABAC8E000F; Tue, 16 Sep 2025 01:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034908E0001; Tue, 16 Sep 2025 01:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E698E000F; Tue, 16 Sep 2025 01:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBDA38E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:49:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 785E211AF8B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:49:04 +0000 (UTC)
X-FDA: 83894035008.10.4ED8453
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BBD6140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:49:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=sObSnyrX;
	spf=pass (imf26.hostedemail.com: domain of alexey.klimov@linaro.org designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexey.klimov@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758001742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+Ij4gEe2LcS6vPzM/CR57NuWgzn7Jx8huZwedt8Tqc=;
	b=m20WnwYkzmXyW5/1gTWc63PXmE3jZobwheAkG6DTGiBSf8TSx5zT3zvpOJ2fyDVPdiLUSg
	c5djCI5dhWNkHst36kMeitXlrcmBKgTP/47Un4+LmBAPOPAKvsFIX9yf+FJCMrGe880W2a
	VvvxX1U7j76k0ymXQ0g7O4YomDPMLTU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=sObSnyrX;
	spf=pass (imf26.hostedemail.com: domain of alexey.klimov@linaro.org designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexey.klimov@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758001742; a=rsa-sha256;
	cv=none;
	b=aaGGHMrYjJEhcPm28aizYNZ9CnIp4vckrX3o4+o1C9HczblKwWih1gb7tML+sv1GuD+xbr
	cSqLdiepFFNh1IuB4fdwt1hCtzSnu2ftwqnjFkig2dyy/wlzxbZuvZLRKRlh/8jiOIqW3c
	fzTTO+3h5EafCge6TsTOeLmeCQsbA/Q=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3dae49b1293so2762202f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758001740; x=1758606540; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+Ij4gEe2LcS6vPzM/CR57NuWgzn7Jx8huZwedt8Tqc=;
        b=sObSnyrXJ/HGNcKBQLGHDEByLUlH63EodZzAYB+nEZKwO/GC49bnWUQsHaOMPaZ4Xj
         IRGN5oThH9lGdfyZ8LPHkXlbaUoWZuCeCKftI81mPtttXv/EejHWgaQqEfsVMAR27ZzJ
         MsGrSTA4vd/OOqSuVOTws9vX2NVgIIFjIAHmYdgPySwwfqcKeKcSItNCAz5oxa4vsfIe
         UaCiQLXMpA6dkmPnXTKNWZVJBMQI/mU4aU5NgcB9/gvbfh4V56EyRlf5PtMz70cWIxAU
         EveGYtG5NRNdMK7XnDjf84T4LAxFxnYYAqMhUujItD3tNCvSghJt55fmqh3DwGsj8EQe
         iPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758001740; x=1758606540;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2+Ij4gEe2LcS6vPzM/CR57NuWgzn7Jx8huZwedt8Tqc=;
        b=OHSPhfX62/9xTO3ZzQBwc1/9XzxFrDZA6livU9giR0xzo4ocdRjCgwZ+qv4Za9M7xY
         84E7FDozSgn3g93F4+DpJNG9yYI7sqz3pt6jEVv1W4nOB5T7iskWvwv63uU52O8l4af1
         cr2iPDhY8ZJlLqwEO1YJAM679aYYEw63HtX/KCZMGcFqmR0gIyX6MXDszndH0x5AkTxp
         o4LWO3yiBvSu0znv9TVhCZGKxOq1NevHg70gHnqbz3wBi5CKyM+wDVvsfWV3IKPYwhA9
         lFKmZD0xvhODQcQWvwf7aFht5jK5wng5do8ExoQQpp5nX9vY5KJiU3YvCONZzaKbU/1I
         wXLg==
X-Forwarded-Encrypted: i=1; AJvYcCWz6SIOuXySuSpK11IbSHEIqKIfCC5t+Tl05hpdx4+5HU8vq/EyKLpIN7y2YqBvSLXThfeqAA2u5g==@kvack.org
X-Gm-Message-State: AOJu0YwEITkBPUCONTzP1NZMCoqd1u9DE377FgoZ8pAhaXYSYCXSV0sb
	YIYLJdbZ4Ww1Vt7oCPrMTr9OzZN8bDZC4DxfePtnaU+LoUv024mIBMyFV5JEU3aovYQ=
X-Gm-Gg: ASbGncu8fDEvAZQT3k4KBR3+c5bNRYHIhyP5elx/hg/pq/K9KvlmUxF7dk9z5Z2PTdf
	aCFsNDPGvCLBe5jHHSa2L0bD4M0XR7yDPyGOhi+4pqATIiqOQe4QKrWToCUsiZlAyRstYCWgIGs
	Kogo1b7NlNYfrhachlKMEEIh+4ydvsUkpsdFclEd6VsRxHtKaTFZqcYGCF2kEdaSM9BeisDT7c2
	zlCy2VpwI48yxvK2hA1MsadiL660gkO32Lgm56Xy1krS4/HYA387DX5pxXvvIcdVUuVINSfFgkU
	4xpm7KVLpu8KQWYzzvP62eWsfJZT439Z1zTSSweho5Iis4+7HqUxIFum+3OdbJ6JgIrJS5rt3Xd
	Ae1Y/jElK/DMKWiUPvxv7XVcLU/NMaYvr7UyYgiWfroeD37IqUerE3GAfrLoM4OM7be0w
X-Google-Smtp-Source: AGHT+IF7x+pGpXf85Vy38ChqF7Pkim2OKEyjFcqs8YYGtgVmrGA1ZIZ90uccF0N4NZf54XR53W2Dfw==
X-Received: by 2002:a05:6000:3113:b0:3e2:ac0:8c55 with SMTP id ffacd0b85a97d-3e765a3e423mr13059397f8f.55.1758001740531;
        Mon, 15 Sep 2025 22:49:00 -0700 (PDT)
Received: from localhost (054722ac.skybroadband.com. [5.71.34.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760786ceasm20896593f8f.16.2025.09.15.22.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 22:48:59 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Sep 2025 06:48:59 +0100
Message-Id: <DCTZLTRX455M.95MSJULLX6VC@linaro.org>
Cc: <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <tglx@linutronix.de>, <andersson@kernel.org>,
 <pmladek@suse.com>, <rdunlap@infradead.org>, <corbet@lwn.net>,
 <david@redhat.com>, <mhocko@suse.com>, <tudor.ambarus@linaro.org>,
 <mukesh.ojha@oss.qualcomm.com>, <linux-arm-kernel@lists.infradead.org>,
 <linux-hardening@vger.kernel.org>, <jonechou@google.com>,
 <rostedt@goodmis.org>, <linux-doc@vger.kernel.org>,
 <devicetree@vger.kernel.org>
Subject: Re: [RFC][PATCH v3 15/16] kmemdump: Add Kinfo backend driver
From: "Alexey Klimov" <alexey.klimov@linaro.org>
To: "Eugen Hristev" <eugen.hristev@linaro.org>
X-Mailer: aerc 0.20.0
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-16-eugen.hristev@linaro.org>
In-Reply-To: <20250912150855.2901211-16-eugen.hristev@linaro.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BBD6140007
X-Stat-Signature: h8apie4bu83ebx1sxngx65qw6ifb9wug
X-HE-Tag: 1758001742-939575
X-HE-Meta: U2FsdGVkX1+R9bK9S3DL4wRpTM8q+36tbmH1rtsTFW4UdqZXdwjnKPAvRM5egrfUi23mLyWcmyECRJORdX301Ar6V/SyyPAp2P+Yu9guoFpjlfqgR0hhwvCMMS0D2iQvP/vbRN9miopHgccJHzMSyR6Iw+ydSzbFKyGjmIGLJ9fVxB2y9pkYOAP2UkugAk5phJkoiRhtYedNqkanUgB1MvWncnPKC2BuvydoddEmt10v7crVSanE7JyBII2oNJqtgXG2r4YpUrRAdX8axe55y09/EiZrpWaWnpzGlTyKtPO2qS/w+30vi2nByrnaUWo9mI8nSqHkdWpYJG9ns7biOpweabNoeXXNa3bkKJEgm4WG2GZZSUVExOHz4JFyfe8PHlixg+54IndxcQ6fmkpTFAgwSYI197uRLxNtoZ8J8FjU2a+rI8DlxFNxEMkq/ps0cZ7LzrdvEixkPR5RAuB5ICrYpIs+VdMTFDbqZxz/qqbXoExD+zDBEVjaD2qwNaYJ8UdFjtvfxPPkuil59wabnqgBG0dDXdu8R4jxoyLZ59m6Vi53+krZapzSYIDuMEi9i1omCtQlnWEMNbfQG8epIa+FLZVXS/R/+Lkt6nDnfdApkmgMORlaFo+RC9RGYpx97Yg1u0kKuYjkTsx87apkuKYKW0CeXbrlXZ1xZ5GVhoFO2AAreWYq+UWiUe+ldV/+DVlX8v/BkbmY2En6SJCsxMmsF4oHZqm5KqT7Tmf+GWEnnM5a2Y0iY/aD9g3+EExdT9qIaI2NMqg/5vNqLPhKAYYoBGhxX5SdZGkIAlTp8kb+W0JzR1e8qI56jHnNfWRovhFlKF+8FQS6zIw0bpLLFFrz8h7mnprHcQA8jVd6rPCDNA72xuvWv7HgUhvLy0o+R15trnKh3aKXRM9ufaWQKo2mF+P5r8Hrxpljoml+Z+QmxvYjXvnrI7VX7ni/wwy2qEg38XDklR0TkL9Ka7+
 t/XCxxGi
 YXCMKz7jOogHfXsYznShJ9dj+NEbjoWcqUzM9Xi7DRp6lxDWvfftNgYcUEssjA/WiHE9cu7las8dWaGFeTjLyswP/8mHxq+hLQEnEcdnDvVam787dTujPfGqlipM6IxfKGu9RZurvMUx3VmEv5CfZPb75p1pxbm9Z6vtfhUD0rGB9udm9wKPtR3hFoZRpR0TbYRfREU1fTHnDSt8z/ga/UyzK4lGA1nLDiXt2WJ1KPEeo209/Tz1/r4mOzEtVhD1yBoNpqWy38ePHD0TXoAOPGtyyLyYsR6Dd/y40DGkzBJkFwLYV1Bw2YChj32Ut11q3Em5qrT8BYNqEEilkcg1CKYN2VqxY+2mV31w6R0l8DLcqI1CnqKXXd7ToR5nrWx69XDxSWN9f549/DLQefkMRJHV1NdEMh1YyBVEiVBK+33t9MvU497lXV/E15pzLlUhT6SCT+fmJLVhb8/dAdhfTNiSCzw6xbhUweJErQPqtaaF2sCnZ2ukALS5xDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 12, 2025 at 4:08 PM BST, Eugen Hristev wrote:

[..]

> --- /dev/null
> +++ b/mm/kmemdump/kinfo.c
> @@ -0,0 +1,293 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *
> + * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
> + * Copyright 2021 Google LLC
> + * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
> + */
> +#include <linux/platform_device.h>
> +#include <linux/kallsyms.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/kmemdump.h>
> +#include <linux/module.h>
> +#include <linux/utsname.h>

Could you please check if the headers are sorted here
and in all other patches in this series?

Also module.h is duplicated.

[..]

> +static int build_info_set(const char *str, const struct kernel_param *kp=
)
> +{
> +	struct kernel_all_info *all_info =3D kinfo->all_info_addr;

here ^^

> +	size_t build_info_size;
> +
> +	if (kinfo->all_info_addr =3D=3D 0 || kinfo->all_info_size =3D=3D 0)
> +		return -ENAVAIL;
> +
> +	all_info =3D (struct kernel_all_info *)kinfo->all_info_addr;

Maybe assignment of all_info on declaration in the beginning of this functi=
on
is not needed then?

> +	build_info_size =3D sizeof(all_info->info.build_info);
> +
> +	memcpy(&all_info->info.build_info, str, min(build_info_size - 1,
> +						    strlen(str)));
> +	update_kernel_all_info(all_info);
> +
> +	if (strlen(str) > build_info_size) {
> +		pr_warn("%s: Build info buffer (len: %zd) can't hold entire string '%s=
'\n",
> +			__func__, build_info_size, str);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}

[...]

Best regards,
Alexey

