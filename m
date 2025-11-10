Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82D4CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4277A8E0050; Mon, 10 Nov 2025 12:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEDC8E0003; Mon, 10 Nov 2025 12:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BDB8E0050; Mon, 10 Nov 2025 12:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269BE8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:38:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D00C71390B3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:38:39 +0000 (UTC)
X-FDA: 84095407158.02.C2AD905
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5A9214000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:38:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ncr8+DkI;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSOpGWJwXMs0s/g4qCwlIsfD5sl3RCmHWkcwp+GKrsA=;
	b=Bhc5gvsxyonsM9p6MwSOEtBzphYahhrPZVRbA2+c3K5iD+TB4/q4L7c0JLFB/HMiCPRM5t
	IKeQp/Dgb4XMiAcy27a9cXweqXla8jjUolb9jxWycyzeYIMDd2cY77m999MJOaptgE/p1h
	ZE9v3pokabhw8G+SjH0INLwMkk6UFWU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ncr8+DkI;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762796317; a=rsa-sha256;
	cv=none;
	b=jAVMopiKq7hYEzoinwzQESfyLqjc21FYctmG94NeIMUvASGNE1q9/cZc59fNK7zLad8N8p
	GIKMvVkHVhErkAxNR1cHgbq/geIX+hEXlmpJS9vQt2/NdUoEmLD/bKRePE9A3xUEMUsDmN
	We4C9HXdMW7cvuRx2rIINfvDgdXs8/A=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eda6c385c0so20086821cf.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762796317; x=1763401117; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YSOpGWJwXMs0s/g4qCwlIsfD5sl3RCmHWkcwp+GKrsA=;
        b=Ncr8+DkI/uEhYyysYg4x46vgPQrkVxctj9TkEsqTNkPwo4QcHO+VC62uNhWcrTs2aR
         OLQpVSQDd2HHuMJSovGjLRGHwC1qMuMHi9uS6YEI84SCT3o1d0MkJ7pHWOpPUV1I7lS3
         3BNcfLTWkF7d4D8Wijg/VlTOgoP8boAvapXkyd/ZXdGzl7PWF/krHBJ9XWgUnc0gr3PM
         3yW0JcNaOlGJb/pjJSSLUnWcIunIF1BZEv1jRrlAkY7Lg0SiQlHPFOoFwtGHiLnJoyXP
         KZIofbdV1p0Y6efJ+RJLn0PsbR8Lr8dFISTpFbYdi0jx8nx55wZJ4plq/xt9KhqQs7DE
         HRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762796317; x=1763401117;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YSOpGWJwXMs0s/g4qCwlIsfD5sl3RCmHWkcwp+GKrsA=;
        b=JF+rVeHI977BlL0JbO9VGaGuif5WIzRaVO4vvjaGQ05IUQMblR4h07KwXo7CKTEX4E
         P6hQI+GyneW/fyOe+T8YSZpRxTjucHy+Juw/H7wH+OKGFOG60Gw6MoWfj3w1I48lsJ/Y
         Rx6Cn5W3EoSZ5KOLqwP9eKjj+Z9zTmY/wyukwqczLO/OdrFKmfaRbFu7nvuQLnwUCrGz
         HdtoRXrblsbHt+W8M9V02zgIFp2U0y3tzsilR6CX/jjb0Z4aAoYu/eqkf2wADGr4Sy4Z
         IiLc60wH+RdW+ePjxTujm56UXeT8KY1rKJXKn8qUilGvdiaNJ/I4yIka2wpjE/WynTtx
         4cVA==
X-Forwarded-Encrypted: i=1; AJvYcCUVCaRa8rjFFpCPgSAHABmuOaqpR//eZDcJRryOFMdgBJdtFFPPXsTrPB4Kx6ccg3Dlq0tdE43bzA==@kvack.org
X-Gm-Message-State: AOJu0Yyk+QQst48SlnFbJckF4kvP68cQiyrqQ37Cp4njbvjrYucH1bUJ
	cyWJkBASLaVzGmvPhNuPFRN0ISCcl3QIlbpmsIfDJR+ERNtjpGqyhpka0TZ6McuW8PzteeyomsM
	8+YrGjnCd6OOlL0t8g9JicKmvV4uX8yOAD5xe1adB
X-Gm-Gg: ASbGnctRMJ8pPgIaA+HwB9LjJjZT/Hj/nrD7BvG44rpQQczIixFlzM8ql69O6byZbVC
	NEv6kEznrD2l6w0IWovoU7RRy2P/HoKFRJ6LBMaJ6PwoBLROwoYMpY+GXeBJqbiSngzEdWZRaHb
	9jJpDwlY1n74FTZlM/vxb05cvnjIFeDkrpKePSa+ChgF7hrN+vrn42zo4OqPQA8iFVtcJfB6+g8
	xVpUtu7oFR33h70IeY+UBmbtUASehH7aTrtemVkbRFc3T3LACDRplCy5/Wwq8+GUQi0x5YItZjM
	qc5b4LjYlauZ+dstmmDMeKHmJw==
X-Google-Smtp-Source: AGHT+IFr1gTkxV/2KbejHCAfn9cmRrtPm5R67TTLAIre2TRAH5dAXb9YnE16dsLdFYHK6GdY4jiLnljrS99RBkOdtpA=
X-Received: by 2002:ac8:5856:0:b0:4e8:baad:9875 with SMTP id
 d75a77b69052e-4eda4e70d87mr109099991cf.4.1762796316364; Mon, 10 Nov 2025
 09:38:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <8319582016f3e433bf7cd1c88ce7858c4a3c60fa.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <8319582016f3e433bf7cd1c88ce7858c4a3c60fa.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 10 Nov 2025 18:37:59 +0100
X-Gm-Features: AWmQ_bnlgBiH0JekOxzwX-3tPMF5D_wHyW4PzCjMfs9TphH4P9izG_-i06SXddA
Message-ID: <CAG_fn=VUx7GkcjuYO3oRH7ptgKVtzQNChW1xKL+1SPfJ=XvWwQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/18] kasan: sw_tags: Support tag widths less than 8 bits
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5A9214000B
X-Stat-Signature: kro8s4k4rcxzaknrownypiah3419pshx
X-Rspam-User: 
X-HE-Tag: 1762796317-565257
X-HE-Meta: U2FsdGVkX19VYnysNoS7ok7XCixQ3R1fEIcper4t6BtEmlKo/6r/jsR45g+wmQ/EcdjRR885GxNi3p5qRVxplHxPUAtZPgt3EtCfXwrQscN1/TBhmgz7Metr/a4PCvwocIqWrLOh0XibbZ5hGzUsYzHhS4/4eH+jjgewEXXY7EvyzWMLjWS6pmSRpRbZ6i6PHRtf/5aNKx6RptKbsMRCSx+qJ0MVLArcLakQK0hVcWNwmK4KbI1MKwsj25qYmUEUE2Fr7l4TWbHPbQ6GyXpcGUX5+jGOKUYWZuWtAdYCuhB+lV6XNUmPavbmUcxTjbQrOKVIqVNLzLQ58PPybN5yTMvNwCfTC2GYGuOV2Lbkad9U16PlTIDRrnoRnZWq/wnv928vIejJKwHDYVCQun2DKFtFT4Y1bOriWrFAscGnC+cUWRm2oHzOr0lgsOixpxK5CwM3xEgPJPMJIYGEypcy09TaLQrl6Cx0rCpLfLrIWSYEKvaU5459uWUMGR5bxpIevNNE8AsP0L3BEo/aUfn5InwLtBf/3qRcBeix2R80oEg6ZvX0pLH9C/TYOjAcXReZxRHjyW5JQh9qqCH4m3sXMoofqkQm7udJxJr4o6nk7i+miexBxiQKFNOMqnoY1fFzsoGJWn1Q8bkJZoJYoe4HW34HS453z9GNdWGW1Zdd4KhfqE4N2VtSpBO0q80fcvnCh6IlZ2iyMbnLaV1lH7L0tg8TN1AFOimZ5pd8PDVuhUVN1xIo8FoDr8qXekNPbHawgLn4dR9oqqR1apTqKcitHhHC5SV/uN6nGssYlIjPqbFGLUm6K4lIm9UrV+ZWae9pptvTbtY//phlHRqimq/xslLyG9QpGOA9vaBsKj1gAmUpRZGyEYb3nXtx+J3eukl1Cfun8Z9/M4HUEGxh4my/qEyWSIyb8heRfuuumxzMYEE7qOWim5/M2W9InEODBvFSEwcmm/+/UST6Erbdug3
 hNeq4Uag
 1UVIa/xoogIsfdcLkfKLQwcsAGCoJXd8qMOkworL1lNUJREdeKFjXID783klqoEM7KqGgbnr1cM85K7I+8d8Z19mIxsNvQlTOd4//Us2rTkhXnB9y7mNXQ7WahPT68NiuaLZClwBlhB7Y8dfOednLVZl73k5dJZsPRkVMaLOVcr7FnjVYYSytW+H7O12ZN2fxAetA3qQUQehUbHL9In290USjmrYQgKDRhiqwgfmuHwyXxJMBL/DvTtrcKtK9Y+gE5ONLIhZpstWyL2Ebcjjkw2zSZbPzG2810KpleFcXrL7EmAuSxmnxH1TRejg+TdFErpYQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +++ b/include/linux/kasan-tags.h
> @@ -2,13 +2,16 @@
>  #ifndef _LINUX_KASAN_TAGS_H
>  #define _LINUX_KASAN_TAGS_H
>
> +#include <asm/kasan.h>

In Patch 07, this is changed to `#include <asm/kasan-tags.h>` what is
the point of doing that?
Wouldn't it be better to move the addition of kasan-tags.h for
different arches to this patch from Patch 07?

