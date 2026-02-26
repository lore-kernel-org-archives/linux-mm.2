Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944D4FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE6B6B0088; Wed, 25 Feb 2026 20:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C476B0089; Wed, 25 Feb 2026 20:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DD36B008A; Wed, 25 Feb 2026 20:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A37F16B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:16:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BC81577EF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:16:48 +0000 (UTC)
X-FDA: 84484843296.23.F0F7487
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4EE8AC0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:16:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zNmaPvwZ;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772068606; a=rsa-sha256;
	cv=pass;
	b=KIm8l7ZT191VAaTLIUrVjosUMMkO5ReSJa/hWUziFD9VCXsvUYP5cFyYlzZSgX4hNmOgyV
	Qf9pvP/er9XK/LhTBlowzvbY1MnOcPeI//E9AHGV0IPL4I9D0M5A4qCz3tct+ELRQKP1Eh
	66deRFWgJG7Y/j9hFlZ3e+7o0xcAxXc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zNmaPvwZ;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772068606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRCpYCv9LhOitz1IfzI25VOPlvd9PoDqej+x+FrWu+Q=;
	b=3YYjOuylPVM2UWkd8Fyd8Uaq2fmZc4mt+2dSo63RXKbwyRP606KpOCsQ/BFhrPkl08A5L2
	7t7EpyoNC+CUU9J70mLtW27guqmFGqcQrTH2pn2A7weJwcy+k0OpP9EH9oXuQGU2psGwVC
	lPjhQLakEAN3NMuInVr/OJbJ1JWaUaE=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-126ea4b77adso408071c88.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:16:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772068605; cv=none;
        d=google.com; s=arc-20240605;
        b=WWuB/72RqyMqaDepfMBEVD2Jeu+GeB5uZug9AdUarG+AD0eKBst6QLmOfQhuAGpa5T
         Qc3kD8uaMLJplD4W4pkeM+XMzSGe1AI6SMknGOoJd69eammj/qmelnFQ++PpyYDwGv4r
         1CX5YRj1JihcXhVHLO2aZbc9fhF/2zN1LT/qxDW1ASevofIUGAs5SJ80RMTvioI6WIG4
         kXy/1kgQYB+I+7MmL+bprV07rb+ioRYlmiEdPCNAz7kXeBOT+4xreTMQhKJJXn6Ne6cw
         6EOG0jyNQQ/R0TkDOOIrw9HMXUQe6WqJiyIA8nlixMnu1+ldPLLK+kfXARKOZOxIwtEc
         x7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vRCpYCv9LhOitz1IfzI25VOPlvd9PoDqej+x+FrWu+Q=;
        fh=s4vL14sJFGlfN8GrP0aTj8Ovb8It8jXYSaELPJQ6fJI=;
        b=bpgTcM8RxyCUyBLMscd7T/Zs59kee4oUdw5ltHVF7/mEHzw52FGbIzPQhi4IpKYhsi
         6yhhN95sL1S7Ejz/LOoA1uWbq2mOuSp3Mrcj/KoZWJ4eIKVeDE1haiL57WhUShS+Aj6o
         ligzTHwjyoKIuchKjZ+OMKa4WVi66xew8N9MNUCf/P1IhC74KuAQKQSEBc89T2YootS6
         mMTQ1joJtLsVJbv9Ulqqj/1dcJT7MiODyZiSVQvMvr4jSuEui/9nvOnbe7+5PEDpN12D
         9BKwiePfyfd941eZbyKcJ5lOshfE4pJMuh76/wLSrtko0jh6wtExkKUI1gzfMnt3T62V
         cO3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772068605; x=1772673405; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vRCpYCv9LhOitz1IfzI25VOPlvd9PoDqej+x+FrWu+Q=;
        b=zNmaPvwZACoA0jwT32BNhtsOtROw7wZke+91vccBCI0X1MOrsJcmdFuN9VFMHR1U5Z
         up5GwOg2woGO2NGV8nQ+Q/iFGFCT8zPkWhTjoycYK240IRgtJa0C8+7ybXd5osMU87Ts
         FpV5jdgPkE+P5qOm8IgxGVgeUKd+4NpGuCcdechmJZNGIL6e3dzGzFwgBpMVcEUkuH/W
         pPEfy9eRxpT2Q4KSQB+i3rv+W/c8ok1+qrneJrZO2txcpSYd3t4A0CQm2fxkYdR6DtvW
         OmidJVOJNAkJlX5E9kGuoIt0aB2c/NEBFThB7cdFLOetrARjz1RFQ///nus6HU3APDol
         t4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772068605; x=1772673405;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRCpYCv9LhOitz1IfzI25VOPlvd9PoDqej+x+FrWu+Q=;
        b=k5s15j60l9tPd+ZOi6m0VfzynyhdwnGehkAZ+zpNeRTQeB0OXDG7nE+v87zWyUE8qc
         UqjAZ6hM5073JBAX+4clRRHNYnL2fP1UuAAmcYfmokny3oX8N9KwcDMcoTg2WTgeR6/7
         SKGYmwqvQvem824AEYAhIBrM51UUCTttMA0HEtBSQgyw/v5pAzrKHdRrTwuuN2Fzmxzk
         JUkgoCnQg+FYhqD+ZSu7Y/TUrc10iIwGuczCrGxCOLqip7bKmKTAR+q+dpDVt7r4ck7l
         +XAK8mF4Vogg3IbZE1pO2zJ7YVfOjO/OaZGiOWjRDfzrUHJxsXtjY2dGOe3FyX28ViJc
         sqkw==
X-Forwarded-Encrypted: i=1; AJvYcCWnZ7pj/8Eo88+KiRB6gpr5Jd1Ou2rv/CN9ptkj8drs3c6P6PXHhLHcITaGJZPHVAOQCYtAb6zhZA==@kvack.org
X-Gm-Message-State: AOJu0YxMklL37MlACbFzs6BWVqynJOdY8V1nqrPcb5UAWeezDzLdk76Z
	k7Hum7uG7JZzpLpdoIaasI0DQAiUzjbS0GiMXd/HvANv6TU3hf1s1jRHlx8lwWc6/ZTpbQYJH51
	XOWYRKZjLrDidbYAsQ61HsaxzGKtO7Pa2gP+lpUEv
X-Gm-Gg: ATEYQzzljBlXATfaoF6HzFivbys1qVUrWOq9lNxvcJlMjRbvE0yoRuHxDaxKlDvaUYe
	zrckNM4fbv/7ZJSFJVBkpeOayiIBTL2a5HXfLhBJuSx7ETcE2gV9UOM5WvPKeLrfgwZCXRNxZ1c
	teG9kaZ6e+3oHmn3fMfss3Ug8sW/CBY+C4Hmlmm2DMoEFiUZ5+0TAn3nvEpzHCShTeZOH/jHEZH
	4fjy3B9xQ5u0+4wInQPBHlyeq9dVMqKsKZWXnXAcb0KoX0esJ1NWHjVyib44lWOyEl7TIJM/xZK
	U9nD1ScY+jwr6D5sB7JRFK/1kY7yOaYupaVNpyw=
X-Received: by 2002:a05:7022:48c:b0:124:9fd8:4b99 with SMTP id
 a92af1059eb24-1276acbdfbfmr8853747c88.14.1772068604514; Wed, 25 Feb 2026
 17:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20260225203639.3159463-1-elver@google.com> <9476ab2ff783c77ff4f1d323fad3e356bb172fcd.camel@surriel.com>
In-Reply-To: <9476ab2ff783c77ff4f1d323fad3e356bb172fcd.camel@surriel.com>
From: Marco Elver <elver@google.com>
Date: Thu, 26 Feb 2026 02:16:08 +0100
X-Gm-Features: AaiRm52Q6kRNA7CHrMLsOWSgdbnXUE5vCnkOPGyFzwQOTRVlJEfjChemViCldxw
Message-ID: <CANpmjNM4kwRGU7mxZPtPnD2-Q2u2E5K9bLuHiZYkPkB4JETeJg@mail.gmail.com>
Subject: Re: [PATCH] kfence: add kfence.fault parameter
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-mm@kvack.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4EE8AC0009
X-Stat-Signature: jkqjxa9mhkhqpc54i8i61y6uz3e3yqfz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772068606-608456
X-HE-Meta: U2FsdGVkX192aY5XdeLieLNw6R26tcAo4F2/cBjk81+IF/jaJRbG+GD8Exn5SvHE2zsrgB4VhfsoQ8D0nHRH/t9sQQmNKRj2futMzgwgUV4RUcXwhyRdwfDkm9degbCiIFEANINXQB0GTrJ0srwBkkuDqrzU/fA+UWPOYQgg2U+NI7NjpDpVxFISZ6FSRmujjA6UHv+giH/CdWYudY4lhBO9LEu9OMX0OPRz4xey7+9KDKXi5L8iDVj1hm/DiosZYAWOztT3QISmNzBydHQU7BkkVIuo4Od18wETXgnHxBxv0Kham3n0EtSkdSb3esJrI/CqUAYTS+4GmJn9NbaKenivkSjDM+6v5gn950s/l4FI5xIWNCq7dgf9LPR5Kj1y4kZj7l55hjdi2BprDMoeDt/Rnag8ZwPGw3AnCtNCFpFkdnE1GMiQfUBeIlFPxrf7+9nQgPFClmY3BQIEUgp1xE/ejH2r49RqBm/13v7mE8lVIn6a8OZTbjycCimSydvqJKsSgTLTBwAjCzsJfPkbm4D8n1knPAyxrP4c0tbdt11VawHFT9wzd/bj0IYgyqvg048HqTTOTJLVGfU6H7BYVZ47BIGCD685k2Lu6bYtBus+/IWQLNpX2hikuPc0sF39IPwJ6EoA5asURgHkw3Kzwm7gUX5qUUYzKTx7hgq5V/LbC6spV1fUFOOHWuLSyLZXgwZq7jZKoR571xUoPeRQZt7L7Ay8UszsbT64zxdAsSj/Voo/5rpxGcFX4B/YcDtRpqFRu/eCUdcLoMKVb4vVUQeS5Gwd4rfP/JQ2E1uEVDFvg/r9a4gre+zwxkdAwZc7+9zJaTA/DyGU2lzp17qX+XrNCurL/yr+50SJvGPgbqTYIGRihzU8YgEm9FHuSBIE79Kgo0XqCbBeCSkb20nQopd2/p3bNLDQ8QvQ59VsWtffLe9EGIIbFa8nQVAgJfz2fUVhOiZw0qp0llVv5Id
 2rjNvM6n
 XIR69uN8bpHDzAtcQFYseKww/kyOGUv/iEyhNoOAhXMBsXh22t0oWZfO+w1LoNQq/UATLurBeRFbnwW5fkq9XYydmL7DTet4TYdN3a7uHRbh0ceSJZ2oCNN8i34dXiDNZ2OnsMQa3cbSiOEOYtex8xQh6/oiUvwVHMoP7NASKdJgfucbJ5X/ezWucZpp9446RMNGYASwVqivjApt4oxX4XdE4NdyGnqEsV1m4FEEgMrpPa34aBZEcU1JXyw9QapPjk5Hd9SlemwFpfV+N2pKgPwh15UkGknJZqjjrbm8Qxf5ftjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 at 23:26, Rik van Riel <riel@surriel.com> wrote:
>
> On Wed, 2026-02-25 at 21:36 +0100, Marco Elver wrote:
> >
> > +static int __init early_kfence_fault(char *arg)
> > +{
> > +     if (!arg)
> > +             return -EINVAL;
> > +
> > +     if (!strcmp(arg, "report"))
> > +             kfence_fault = KFENCE_FAULT_REPORT;
> > +     else if (!strcmp(arg, "oops"))
> > +             kfence_fault = KFENCE_FAULT_OOPS;
> > +     else if (!strcmp(arg, "panic"))
> > +             kfence_fault = KFENCE_FAULT_PANIC;
> > +     else
> > +             return -EINVAL;
> > +
> > +     return 0;
> > +}
> > +early_param("kfence.fault", early_kfence_fault);
>
> The other parameters in mm/kfence/ seem to be module_param,
> which make them tunable at run time through
> /sys/module/kfence/parameters/*
>
> Why is this one different?

That was my first thought too, but after much thought we should not
make this changeable after init, see below ...

> And, does this one show up as /sys/module/kfence/parameters/fault?
>
> Having the ability to tweak this behavior at run time, without
> requiring a system reboot, could be really useful for people
> unexpectedly triggering kernel panics across a fleet of servers,
> and deciding they would rather not.

It's intentional - having the ability to switch it after init means
we'd have to remove __ro_after_init from the kfence_fault setting. We
risk having the system administrator's choice being overridden by
accident in the exact situation where we do not want it to happen:
either through memory corruption overwriting that global flag, or it
might give an attacker the ability to circumvent the oops/panic
setting, if they manage to reset it. KFENCE is not a mitigation, but
this setting is meant to give a knob to reduce the risk that someone
takes advantage of KFENCE's heap layout - until now, KFENCE only
reports and continues - the actual buggy access happily proceeds.

