Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EF0CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7298E0010; Tue, 11 Nov 2025 04:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7788E0002; Tue, 11 Nov 2025 04:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7963A8E0010; Tue, 11 Nov 2025 04:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637EE8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:39:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F03F8591A2
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:39:53 +0000 (UTC)
X-FDA: 84097829466.29.F3F7895
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 240D24000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:39:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hTlG2TZI;
	spf=pass (imf17.hostedemail.com: domain of glider@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762853992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x27CBOBuvs19lllL/4Ne+a54Yz+5/uzP3YpUzWY+JnY=;
	b=1ck2xosBN+MO/mN31+1qSZmIIYyGIVR7m64NLFd+MknFxiTn3WrDmfLUVd+t7KWaZ68ZTS
	jajKEy9IoAW1Ic6YrsVGH5UQc6NT6vFlCSDyBH5Pat941isCey4eTeiaRLUjtRPctHps9P
	LLzUQkV8SAER0sRU/yLJUzl1lMzbe70=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hTlG2TZI;
	spf=pass (imf17.hostedemail.com: domain of glider@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762853992; a=rsa-sha256;
	cv=none;
	b=nxsetxvoBfTG61gnf24WtjJsNpqU4RzPjMMq8HCZpxFismAon+P77rerHIhqW8l4gGh/gw
	iqWdgNxxA84jIwm7t87kR64SIBeALkBVV5a/cd9N2UQqikqTVCtzevk0/hE5zVXe2RX5zw
	XbhANfJMW3LMzkDbI9L0Sq5Z0xnPVNA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-343684a06b2so2885554a91.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762853991; x=1763458791; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x27CBOBuvs19lllL/4Ne+a54Yz+5/uzP3YpUzWY+JnY=;
        b=hTlG2TZIiJwh+IWgnUbQQBsMcECLYYGC1/iYSmtcZ6FpKziuBKAiDB7pYUNh6xVDJG
         8Cb9EiFzqhsosa0MOmkWGBPUYxm9hEW3DZlp7uvBrYUfkUxmGCfOQ1j1lINzuNbDOful
         yprVJp/+/u1JG9w8NDqAjTlDY43MGz8nU2UVQS8ZwzHNk07zE3D5gRq1Hl+1uEwmcmSs
         nTSjmZEi8NcmhntzkOSgPhYyeJEjmnDx7GTCICmJ/8ceSEBmlrkT2Rb2cgtWrnNwaqYw
         7QSPXCq9wyDyDMOPhLZnHqTzXJ2LbEP+rvl4etT65D1v0SOqDv+CZ97ARzy/Gp0amCoj
         fk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762853991; x=1763458791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x27CBOBuvs19lllL/4Ne+a54Yz+5/uzP3YpUzWY+JnY=;
        b=WxZCsZFrXZ9CjjO250JuWXWmxyvx5oL1vfnwUDpkWvq1NQYpuvkJUBfg61hmHX37pz
         Uc2s2UZHAZzZUeBpfHlq5F8QBcAPC9owEuL3K9IHZ1+a/YhvTBi7SWCDWeBaMl3B8bw8
         sORj13M3q9MODUSW20tH/sbZYbhMfPyokhrJm7mKxn8PmckcpzTQz+jCvomm4mdruO9/
         lveH3u8MbW4rKtHW4DHuxbdhrav3zdYi1Zbs/ntx6XA54CzU2CqUT6vrpqbTu5H/KEk+
         k956UMBYfsOOlRkUHtnRuzxC+QqMNvzP9+IYAEovXwBnueG6q1Clw14TvKkxcn5ps2Tk
         ACPA==
X-Forwarded-Encrypted: i=1; AJvYcCXOLok2N4gw+HOWm/ek+EBl8YZdoruR8GYftG6OHFQ+6k+m/E3POWaNpPQLkHTyqwHXRpGIldvnww==@kvack.org
X-Gm-Message-State: AOJu0YzZ7gRw4dCNnpnXKnIL6WQJrRvcg2yx7dxPXskJu0u8eVY8Hs+Y
	4Jc1X86TkZnoTEZmnKPJHH0SIY5kS12M1i6tWkmlI71FXsYNt3mys+KaYgivmRZV4LCelZuSjfg
	8v5Bfrb0mXVIMUBbkqEv6ItkEfm2+CFpbEyYjr6lK
X-Gm-Gg: ASbGncv2fpKm+OsNJ86NqQpiCT0B2BY72kOvneRsfx+xXQt5hJ9rGFzVJmLEzK/0W/j
	m0qIAzIYDXJ+Q3XwCdKvRJCwy4xllmLrkkax6JQ1U4aAZDIoCRY6Z+iTVCW0wUMA5/9ka6ak6+x
	8YLFZbdvCty0PhCBjiiLDDOUGs5VkszTC93uO45P1D92VcAHBo2eVnZL4LkJwRbrs57TzpWWDg3
	Auwcr3WOUPrTN1z5HOP5PkDbCqkyCRNT4R/awpL/VwUz73ZOWmy2yY00XWZSb1Ly6K1y4G+0Tws
	pSwe4vPAGAhERA4wCgjm0o6wpIX0EjKVnX6b
X-Google-Smtp-Source: AGHT+IHbYtcp4TEm3YWuggGsZDtmzQmO+Esj4ot5UyBq5O3ykfRy1t7VIIRByVPx+YeUvhQm6/mmmHJjCQ5y0jFctOY=
X-Received: by 2002:a17:90b:2f8b:b0:340:ad5e:c9 with SMTP id
 98e67ed59e1d1-3436cb9f0a4mr17438597a91.16.1762853990547; Tue, 11 Nov 2025
 01:39:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <ab71a0af700c8b83b51a7174fb6fd297e9b5f1ee.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <ab71a0af700c8b83b51a7174fb6fd297e9b5f1ee.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:39:12 +0100
X-Gm-Features: AWmQ_bn-DpseVZlfA_JkC1KeMe_i9gWzENoYdJOcpoJ15BxyTxVZhbSiKbweC94
Message-ID: <CAG_fn=XyQ5Mc_ZvsibN4K0r70xfDAkhPqUJgtojVRcgTt-q0WQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/18] kasan: sw_tags: Use arithmetic shift for shadow computation
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
X-Rspamd-Queue-Id: 240D24000A
X-Stat-Signature: 5h1ef4reeyxn1im315ay14mg8oaht373
X-Rspam-User: 
X-HE-Tag: 1762853991-603446
X-HE-Meta: U2FsdGVkX18fAip9tBEe3/viZg+TCgmNK1nK4P3pSbZoQr+iGEdVhAUStPt20MIB/hzipWEp3Q+GBCyH7/Jqd5N/G4ImZqeRdBsjpkHziHFnH4tMv4BrBRNmnW3Q5CwoxJ+CqNgXlpz0gdIcdlR/Xph4Js/yul3gHv4CK0xtENYXBerybeYwCD3h+qvphdU7Sf49TZ1wT7rd0EHOFgkzWuzUi5HLLam9CkTR/SQfa2D1FwEnCdO+pjcV3R86hui3v4lBPVhsE03R3KlgqFFYc33PcUbkECJUWF4D0BK61xSOyCci8tkSRUwVXqDoI0PtRy9AQdgsN0m8cjajKJi0xKoj4JYUVxnWWD15Kcl7Ymib45MfUE1VO+tzH9c4RYJBXqOhuxrT+isSyNE11IVWBnh7zK/6c22V5R6006ugE93940OB/GcAp4Dh+7Sq6lxiZfklQCatlbYSnnzknyjxOMUkB1oLfI9Xvneod7sVUwB/UoQLXCrS+kafwnLefJxmOLZJNio8Hf/JrsIZyPq/OZrxrFk2713z5i3S54Y7PxNPE8t+w4FU5sdBQaUi/lKLIeSbqEwRHirkSj7hsry+OG5SZx+wHpv+ayCJqQsmOLF4QUjyFF3kb38pkp29dyOX8xInqgit4Qzin6MEdmu8p72Bz0bQBKgjYNaLfFrhlpy6Jnh4QOGY38iloqJfNY0KCy+bKIVSLAe5Wa5tNJQLqozk5lC/pXuHlmlQnCujemGRr7oX7PlO7JwXPg7ZgvhmKrZxPPULpsSaZoR9EiXWQC8gqvuhkfT5DgyDhHfYL7d6rHc7jatLcvR00RHkQtXRVLNQhJmUjslEVZBclTrJNi6C0a/t4jjDquUlqNvKB9gy6EGxISyt/7T1XzAL9dkSIc93eXm2uPz2gNiIPKfpHVZKC07WnZof+Yj+/FkAVb3FbEUGHh5YlcLswkT+RaeyVtTtJnfIJLmRY9OTKEj
 p5P1oVnr
 W0EIpWO8xQqv4WMfWE+dpAlL6RIqB/mZx/HjJlOXlCWSyIOJh7kdsh7U9rtt5hqEKDjGsViDMz1yYohTaVSve+ZU3vAvv7tr45o3hnAW2nB5eet+/J6fsHnwrE8b+BHx4iCqyjhq31kFSjUWgh/8d1pyarKCxMUqtp2X8ssiQ4pA9ciHNiocrSolTeyCMh7Yxd6ypW+4ePZMb2xHivk0cAeAeFihbzyJpyOB5jRD+cu9ozBFfmwGNONffzvFHvC9rqGn64Q726MeH6kapSKsl6fSpAFiQVuP/e8cqsD62mPZw+i1uFL+F2d5D3u68sulu0GTmGfkQMIStiDbRthrtWHaZTPPHUwwQ8euF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index b00849ea8ffd..952ade776e51 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -61,8 +61,14 @@ int kasan_populate_early_shadow(const void *shadow_start,
>  #ifndef kasan_mem_to_shadow
>  static inline void *kasan_mem_to_shadow(const void *addr)
>  {
> -       return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
> -               + KASAN_SHADOW_OFFSET;
> +       void *scaled;
> +
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> +               scaled = (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT);
> +       else
> +               scaled = (void *)((long)addr >> KASAN_SHADOW_SCALE_SHIFT);
> +
> +       return KASAN_SHADOW_OFFSET + scaled;
>  }
>  #endif

As Marco pointed out, this part is reverted in Patch 17. Any reason to do that?

