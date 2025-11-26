Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1B0D1118B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 17:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D4B6B007B; Wed, 26 Nov 2025 12:50:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DCD6B0093; Wed, 26 Nov 2025 12:50:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BE26B0096; Wed, 26 Nov 2025 12:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFC76B007B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:50:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C54CE131821
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:50:26 +0000 (UTC)
X-FDA: 84153497652.09.2C99A44
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id E317A14000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:50:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iCKt0yBm;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764179425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59kXixxQWJbDiB8ZH4iPSjqxruE37/qXgYYUaXC6aUg=;
	b=nudjekrpUqgWafKCMe/qnczqz4OjJ6c43RSLwna/ZG69GIGhybchtPCobRR1cMuu4SPx4C
	fULyzxbcL21jDHIjE5o/JKAe+Uw3ls/RcMMrqroU2lRLlHQjtz2bpJaRCxruR590Cl+crc
	M1awXB/yt8VEDKG980e1rXDCXmNTxjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764179425; a=rsa-sha256;
	cv=none;
	b=AxqFwAm5uv1N8eqAC/FFLeP5+wGc2JexjJ58NQ7umR3UlM2v6xMGyaEZyXSoVpGvw0SSZk
	IHgzb0H/zRPsjCDAE70pXSDwUiI4PlKIb0xxVJLb6XpWG4JcTH/qSu11T9aYxLPNBi3/Ry
	wHEtaNC/wapp9cN743I+k6gIfipA1/s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iCKt0yBm;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso6125501b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764179423; x=1764784223; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=59kXixxQWJbDiB8ZH4iPSjqxruE37/qXgYYUaXC6aUg=;
        b=iCKt0yBmaHzZXfsvAdz1+/ZbqfawXV943URoIFeSHFPyOcxhDPZ11gB/F5jnqSl8Ff
         FE4+YZfMVxbaYtkMEfVwUGTNwCoQgfskjLjpdhL1N2SYLz7TQs0y6m//JP8rmAFq1pcr
         4jSa3FQa+GrDSRDUoa4L1VLxgiZctVi6WpZsMC7FxtrkklCztLEpl3JvMLVBaikykaI2
         3mRtL2N6Pw2NCzyxoPavDJnPW0ei8302zdtWAhAQg2zoian9QcVcyI8w1x5YdW6KoO6H
         nGErlNurRdXnrZi8CtXNnhq2OybSZVld7D/A7Noa/66AbfO9knmgylDsNmUeQH4+Hjxe
         z+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764179423; x=1764784223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59kXixxQWJbDiB8ZH4iPSjqxruE37/qXgYYUaXC6aUg=;
        b=FbhkaozAOkIf/5Hprdicl1muBrOeYbJM9DeVOe6ll7PgbImbuiXR15KdYggvOaOxKj
         L2+A/Op+kMIjtOyAWrZiNM8TOknBMSghhdr9jXO9hGuCOfZOyPSyIO9nCN7M44dZnf30
         80pHTi9Q/LkQ6rjKlL6e1i2dLLgsMFdDEIy14bZKwwBWcM1a53kZj8dqOGHoLhJRTkC/
         1RJOc5/VmHHcNac9bffyXrEcg6+EVP7Q4ti70QxleZ6sYZJ2wsoR89M/Q9NUJ+tmEddy
         PHfHaxJYvqOEwmwVuHyQ/pH3IHMihSLSidi0Ygon9XWob6g2+vkGBO1NbjVEY6jmAGl5
         CLWA==
X-Forwarded-Encrypted: i=1; AJvYcCWy/JpTKVowS1GXANjQO20Io0Ku9YJ6MbcBjOTSifNTkHwaYXMvXNqslLUQrpZEj2xlpT7C9fk+ew==@kvack.org
X-Gm-Message-State: AOJu0YzVZPKDXZ4dcVhI+qwS1CnK2YGsi/B2Uafwk276+g8gQ1BdtU4y
	qLR39zqbKcQJbgfeEf9sZfPsVYgWFZqOyi4iK4H/IoMB2Iu3n2dkct/8wPx/UoQuQ36Y7iDYd4B
	NWqohWXNGIEjTA1EzXh2X6XPwSQsuCcd92sXaGnln
X-Gm-Gg: ASbGncsu+/Nh0TgO3mMMoargWQl3On9u+zjmrDMhgSMDjdMoSxodALgql4bI5qY4n+8
	/KncztXpYblAhG47sAa/unkRi8OZZXo/Zx0Vwihg+D9m3kSQV8bom5Iu/5Lue/3jwOgDg3eVXYC
	IpMya397dnMxwWQplQV+KqtukdDFqHIrj01lFdQ7mvvcLtVWo3fGXUY67qZPjCw793/J7KQlOAv
	6EZzYPhIJusnBWCiUa9ESvd6nogID2x4ryr9QvEHjrporbWu6daKjOPWGykEsN5OuvVxf2b372B
	d0PDpjueEh1WnwesyUm7JLUwFw==
X-Google-Smtp-Source: AGHT+IEH8iiHLAo2+FH9wzaC91akn9smNWohRnkH2hmv67jP8o7Ko2RSe+5+r5RWbdrDdN3fn7Kiu/5SZfus9rnrq3s=
X-Received: by 2002:a05:7022:1607:b0:11b:c86b:386a with SMTP id
 a92af1059eb24-11cb3ecc9aamr3576458c88.5.1764179423189; Wed, 26 Nov 2025
 09:50:23 -0800 (PST)
MIME-Version: 1.0
References: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
In-Reply-To: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
From: Marco Elver <elver@google.com>
Date: Wed, 26 Nov 2025 18:49:47 +0100
X-Gm-Features: AWmQ_bnJoMrdDOqPDJnxQjbPC977DXkSYeKKnQxtfcjlsJnLvzh-SYYPHrqcVHY
Message-ID: <CANpmjNMmw366KEUnu_OQKDKvZJQErj2mXe7TxyQHObvpHjt5hA@mail.gmail.com>
Subject: Re: [PATCH] mm/kfence: add reboot notifier to disable KFENCE on shutdown
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E317A14000F
X-Stat-Signature: yacefu6rz1ocebfe6jkxt5ri3fj5xsoj
X-HE-Tag: 1764179424-831903
X-HE-Meta: U2FsdGVkX1/K1UN9vYaTMoDZgIpa6ghuQ9V498jQX1wtpccGCiIQ6U00i7Uqtn0EON6sAfC2uibLitFj8wwYPPTUjuhZcoF1MtrrMCE9r5qDBX9Uc+/e+4zTS5JcNQZmKdTIC6mSLSulrP45XA0wbZTR3bfMKuPJeFZC6QKdMXcQS9GZWrMFk3m80sZP8FaXH2+WigIR+spGP1/cgffwYrsAOLQqkrRTQtLOB2/NPbDhYeoVKmNFY6QDm0jR7HFkg8zvBaBWmBF4ILaHUWvw8Obv78z9Rju8AjrsMhIjrSxg4PfxYlAxBelVa8BlWp5TIdyiu+yXwDRpACOLn0P5u6G3ctCkz2AYUy2qjQRXZPRc7vLH57h6ExKfrnlAv/aPyu7A+OPuLnP6hJBmsu9ORkaeomZd+9u7SWJOyuuF6ZOY3flX2Jr3/liQBVASzxj1+RFd4I2Rt9azn/AW8I5HhsKIw5ZkU/n/esCWRNIeIv6grgGrEv22zLFn/SRIkZo+cOo2fHsZTM3RmaVZJ+6tk0DAV6qQpRstj0AA5vWG8ranADVE4czRBtT0QjsrZPHdM63cHOI696SfaiMCsAt/nIyRHkBYemp9BalkFZKWiO84v0K+PuhnaJOV6W15Zy27MfxcLlYUp2xQrWMO/lyMwmDYFvMBIzNGCJTAmcwjAUigv8ubwDlH8mb/tvzGhoOt8tPWnDaADxxRFflDH0PRutnCYsp6fxtimEkavS4Orf8WpLvFqKqUypzx8uWL338safmRvx8GbDfX1ctG2ggZgPzmTKqv6inOrNnBUyvJn5rBYIhpQY71xB2i2o/j/0PdJ09soGE/94Gbqi+sDiuKHeXulZ659BfUTUf9DZctwt+FVC0+bnlzbpyZ7Z0Hktr+2N+t/zbmFF4oGsMcK6OWpDUYX2VOKs2pj5FG2lA1Bd3ZeJ81ISwVVLKmegI7M/iGkJ5N1q+Y0NZEdoT46ns
 q/gfJSMM
 sUTbRtF3SsOGbMGHPVXjtSExCwHlmTLeYelNVdPjzkRhaHEAewMFicWJX4fZjEw2pDiiH1Y3Y9/YpU/xKbT4rZTeeOay/gzTrXPbL/S+rAbFH55W4Bxh/NPiQSw3hyoFqKdtekUFJ8BTyUQjq7mY9ykJnbRbbd5i5RzkcVXgObS/EK7GvmIDwtVuFgjMSeVsF16e1S3LxjJDaoKbbSUGdIk1AYTqMwYX/t1K4gg1xLBtYln4qbfC6GW1fLwXMcSO0RXI+JZqluuKsDnA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 at 18:46, Breno Leitao <leitao@debian.org> wrote:
>
> During system shutdown, KFENCE can cause IPI synchronization issues if
> it remains active through the reboot process. To prevent this, register
> a reboot notifier that disables KFENCE and cancels any pending timer
> work early in the shutdown sequence.
>
> This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as
> this configuration sends IPIs that can interfere with shutdown. Without
> static keys, no IPIs are generated and KFENCE can safely remain active.
>
> The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts
> down before other subsystems that might still depend on stable memory
> allocation behavior.
>
> This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
> that is busy in a IRQ-disabled context printing characters to the
> console.
>
> Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good as discussed in [1]:

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 727c20c94ac5..162a026871ab 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -26,6 +26,7 @@
>  #include <linux/panic_notifier.h>
>  #include <linux/random.h>
>  #include <linux/rcupdate.h>
> +#include <linux/reboot.h>
>  #include <linux/sched/clock.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> @@ -820,6 +821,25 @@ static struct notifier_block kfence_check_canary_notifier = {
>  static struct delayed_work kfence_timer;
>
>  #ifdef CONFIG_KFENCE_STATIC_KEYS
> +static int kfence_reboot_callback(struct notifier_block *nb,
> +                                 unsigned long action, void *data)
> +{
> +       /*
> +        * Disable kfence to avoid static keys IPI synchronization during
> +        * late shutdown/kexec
> +        */
> +       WRITE_ONCE(kfence_enabled, false);
> +       /* Cancel any pending timer work */
> +       cancel_delayed_work_sync(&kfence_timer);
> +
> +       return NOTIFY_OK;
> +}
> +
> +static struct notifier_block kfence_reboot_notifier = {
> +       .notifier_call = kfence_reboot_callback,
> +       .priority = INT_MAX, /* Run early to stop timers ASAP */
> +};
> +
>  /* Wait queue to wake up allocation-gate timer task. */
>  static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
>
> @@ -901,6 +921,10 @@ static void kfence_init_enable(void)
>         if (kfence_check_on_panic)
>                 atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
>
> +#ifdef CONFIG_KFENCE_STATIC_KEYS
> +       register_reboot_notifier(&kfence_reboot_notifier);
> +#endif
> +
>         WRITE_ONCE(kfence_enabled, true);
>         queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
>
>
> ---
> base-commit: ab084f0b8d6d2ee4b1c6a28f39a2a7430bdfa7f0
> change-id: 20251126-kfence-42c93f9b3979
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

