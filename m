Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74DA2D6D237
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36C06B009F; Thu, 18 Dec 2025 10:39:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF70F6B00A1; Thu, 18 Dec 2025 10:39:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9B76B00A2; Thu, 18 Dec 2025 10:39:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A26D6B009F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:39:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68141A5427
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:39:55 +0000 (UTC)
X-FDA: 84233002350.28.DC04E83
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88F7920019
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:39:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Kk/MuTjU";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766072393; a=rsa-sha256;
	cv=none;
	b=CfpgNL2hxRC7JW+kD1RoofGefoUm2xQNmp0mPnEDudojus3z5Lyd4m3XHuc+BmmQvlqbHX
	Xy+IMNTESKvu5FbROUK9OHStKCPE8/DA30Hfi8Q0UYYFw2QdkUi7W/R+QBujkPCjYlyhwu
	tW3TppvHaYLMdBGx+Bxd7Q1heroa0Po=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Kk/MuTjU";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766072393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuHMqXMcmxpirEyzXNbEyoC8EMjnJDl0xZyPIapUu5w=;
	b=xCr/RynxO7AMOef3e3V/VmCUFcprGYmD9Y9Cb942QgJviCbU05sscwBm8+N96G1RO+xcue
	Lw3PqYTysx9mXo8oL6LToErDcsVuewqb7lnLmQJNBljbSSY033Fyq8CiSbnnDCwhTVROxF
	dIBY0VuYG63oZngHbv+5f5Ya/EH9baA=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso661749b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766072392; x=1766677192; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AuHMqXMcmxpirEyzXNbEyoC8EMjnJDl0xZyPIapUu5w=;
        b=Kk/MuTjUgVbaWk9P3raDpSX1ZM6DVO9e/LJLHojynBDcPDolVm6t/oP3s982VImBc6
         ohVGZOE7Ro1koRTfJcGwwg3oce2KumYd8L0FneYl+Dj6jxN+Oig0+JfZOfm7IEDbrgmw
         Pg9ICFZ/UgWuxVDCFhye+uM7MbtdblspOIR2bo/Uy/7lzDBxSjbZQwz/WDTEyitucZIC
         vubN/0Wz+7ue3dU8XOwER47nPYEMYNP9OlwvutLVz3KNzuLXEUPUxWAh1vNFlRKIrzTC
         LEmAzN82k1iIkIJDbBXbkSLDBn5dmNKsXQeeZ0njPS1LqAIU6H1SMFJnXyTqWktQySlY
         hV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766072392; x=1766677192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AuHMqXMcmxpirEyzXNbEyoC8EMjnJDl0xZyPIapUu5w=;
        b=Uk6MGvMxBbAF1TJz5YSeOq5mOp2Ptryjdv6eDINnWGTKytfiEYuUIQJi+x/6i2Sm5a
         nX4MXhhU/JDAffpIIwotDWabyIiufdRIxXx8ChNJE3eT0Cd0uI1e5wrxP02NVwNaZbyD
         kLVm2SXv+F9q+9k+5RuxtYdVrX2anO8SyVViMHjjAer3zu7pjBxEleCaIVJO6cWymchN
         5e7wQ48IHuHVCAOY1f0cFo2JaRn8ZPjiC38EPW0nzqoPgjADicBhqx1XifYqwETEwaUq
         YO++bokLpAyi0vjhVc1wQ/tuCzulsJ4g3q8Es6aiAdF1OvLL6IIOhb/mK3g/vgWj4VxM
         DLfw==
X-Forwarded-Encrypted: i=1; AJvYcCW+KDHRA115uAvqTLD072s5UtymqByW46YMtLr/X0KLp6MZ520kjimY75a4kHCEOM4Q6pSD2e/qXw==@kvack.org
X-Gm-Message-State: AOJu0YzdXIB8vk+L0eAam5/xPa/WY3QcRcemdwNJrCY4UE0zwuJvkwja
	/UKJIUUFvVXMbqUiU/vZ0Ej33DqxBYIFU/lohkseb6MQlMmmDDDPG3xq
X-Gm-Gg: AY/fxX4X6z5ST6QUzTzPEiq6K9hDptW4HeauvBUPZvB6i+uI1a8xBP0sVr0M4VqIdHp
	9Moi3GkmEmH+BFzUxZleVVxwDnw/4SrptWRg7FH8PGAmDJ7QvcVWfC0NaMGI67yTpuxJOzU/3jt
	1aM5ehqZEEybxziHHXtxcdlvgj0zDdgL6HibXykM4jW6E5EIj6kaYfkpJOnLxVsh+5x1CO5u2g1
	V9OE28EvhVUVKM41hSrpjSbEAnIxSr4eubFoUyIwzUuQ78CUPGZjmcaNt74kSsWuthtfoLrksBu
	qxdnVXD0Hi812kabLpDC7bH70moJIwk6Uz6h1U9w5zhxn2mKlWrl0UHzV7DF1vFZURq0gvUEI4a
	rj9tg8znMqL5vuLv4rxpViJti6szw0nCPSVFOtYqCrxEV6s3fmMMIqCR1EnoYF+pb5OP2ZLaLUQ
	tt6uuU8TUFGh5/2jFisOIj/asq
X-Google-Smtp-Source: AGHT+IG/4pP1QZTQHQjUdG+s1c4fojraiGAhrgiuA/oLwx7PD0NTKdmdi1QirAFQNK5TCQv1Buwg6g==
X-Received: by 2002:a05:7023:a8b:b0:11b:a73b:2327 with SMTP id a92af1059eb24-11f34c4e8a6mr14008337c88.30.1766072392298;
        Thu, 18 Dec 2025 07:39:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12061f47269sm6851144c88.4.2025.12.18.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:39:51 -0800 (PST)
Date: Thu, 18 Dec 2025 07:39:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for
 !CONFIG_MMU
Message-ID: <c73056fc-94f1-435a-8418-26506cba9de7@roeck-us.net>
References: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88F7920019
X-Stat-Signature: d6txgr76tekwpupc1bbo7ksjtxd5c3dp
X-HE-Tag: 1766072393-326334
X-HE-Meta: U2FsdGVkX1+ssFu1KERykLviAFojTQPk5YxU8AfpRXMZ/XfZyzJpFVlmooteCzOIxC1I8U11ddy1S6NkvLbLhxLY8vDmSoGYMlPdaMUIpgdlX5bxir4REAzFD3PZBX27u4DtE0ryBB4RfeMSKqI1ADsX/XK9sPNPmEusqq+QRHVQMjima4n9hxVzUn5bdrPaTBVZdjIMh2wRUr1IxC8t3Xy5AZqch4qgrNKw8OX8QpSL0O6uRsmPvFQqIkKvbFUpLOzsrHJu4tYmsaX7bPSjMkdjHvLSeJk0QTvdhUwaoGD7lZ4bDU6tJMYESK/O/s8MCJqjN2YJD3aVPuP8uc13u66dXDSPYsEJMN45YcmMkHoDHDGX4yLsX42j26HMPCKpl9YaZ7Psb7GiCUeFbCkeQqjkNzT3DjCBvD66ELwe/BbjXliWg82qm4dG7m6Qnlab+12nNGTiu5pFawptAYX10+9EK+F2wH74wFof38FuVNPfLDgtFQUIP1TNkoACILMtItJnhY89cy09staKpvy0iODwQ/xpkvfR+5dstfoGs7a1L598daTz7XCXbpkxYqqYXn5EqyNVGX2fhzPm1qfi4xtNIb1RuglfeH99elTCrE6gXmn/91nAXf+UTsdLgCU1iIPxn8aiNrbKk9yqUyYOltCuoSLoQLz1L6vh3qrxYWDYI80r22Tvjubp3co12gSgd2pGrUzXb6FyuhQtdOhU94J9zdw7U8q4qhav6i6HoaF6ewwgXRz22aLwvxAQ0nzX+N4hjEjg9xaRPbiNEvau6HCeRGt1svtMMNeXEl4qAyyXicnu+g6tu/nXtx66Cb8rHEx7jWsoClU0ANOIxbuUwwaUpMiXVM5nDN1inr7d6Z0RFkN3P4EznlegbEsjfYN4wGaMS64QdgUVC93Y8Bw0nSOOI938Y7cyFXr0Od+PDNk+GrLuVwEvV4MlLyaQPRWEo1/mV5EEZuiYW0T7ymK
 UuiY89um
 i4dEZQlzNmSQ8ExhAEaK6EUqjxWbThdvUjIqXJ5xS4UzYnO+i1Ik9KBUZ2lf2TpHnKxjuSBdJxhjr/CyCS2NwAW/lprIpz89l/xqdnMy+ry+b00yWINgnqvleYWH7ynRtfEjP9zGxEVgHcJLoImMjBhxOZvXxXSgPYDXjOwjuzfH4k67h6zacJu8PHcsRUzt0EL42W+0ZWPGSDwP+S7Feo8N+f/afZU7jIfV5mrumMJe+nn8szPJJHWRgAv3R36ycjvv+rNTpW5JVnETMCbgIrMsZqKmYzNtODaJVbTgCPU5uW06lqmDoRIU3Pk7rBCpzLQxjueyhbSrbNy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:31:59AM -0800, Joshua Hahn wrote:
> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> 
> For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
> the previous deadlock-free behavior.
> 
> There is no functional difference expected with this patch before commit
> 2783088ef24e, other than the pr_debug in zone_pcp_init now printing out
> 1 instead of 0 for zones in NOMMU systems. Not only is this a pr_debug,
> the difference is purely semantic anyways.
> 
> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> Reported-by: Daniel Palmer <daniel@thingy.jp>
> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

