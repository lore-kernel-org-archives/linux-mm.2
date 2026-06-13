Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664C6CD98CE
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941336B0005; Fri, 12 Jun 2026 20:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1FB6B008A; Fri, 12 Jun 2026 20:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806B56B008C; Fri, 12 Jun 2026 20:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72B656B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:16:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D74E120288
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:16:58 +0000 (UTC)
X-FDA: 84872974116.15.BFC6847
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3B19B180002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:16:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0ceCiDH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781309816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWwT9TpVhYF/K0z+rdL3pthvZP+Xb5uL2Tmv/pNJ18E=;
	b=Mq4SjfsKOyWpXPdYf4S+thgH/PY6j7CIUzjoH7pvtEeNjV7tCJa+kCjljWnNhKN/A2cvk0
	V1A9gOsoAFlB9BKSoghpPUmSME83uYhcGEqt/LBfZms0cFF/nuB9sy+FHYNJe5baBFU+rT
	HkF3SlWnrF9jKWofc4nO/onhhYZH0NI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0ceCiDH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781309816;
	b=OpGWWWQ62IX54+0ZMCKKEn/Wv+ACQupgCq53DyRBQwdtuzdeehxeEUl98+YwgdeYekIrxO
	YlBIK4yZf6n/43DMYwDgBMU38HKXUjtWGNzl2CbI49RnhNht7en70ExcEgbyrORQuyTKJv
	lt+JDu0ADcxwZ7CzUptoPTiFjeXmzVo=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1336742714fso2006c88.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781309815; x=1781914615; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AWwT9TpVhYF/K0z+rdL3pthvZP+Xb5uL2Tmv/pNJ18E=;
        b=h0ceCiDH4m3z8+uv7M4W2z+FPvVEHuCOhIsxzzHgSRBdObPGXgfOs852oPFTCAeFJu
         oFRAHz+1KCRKbxYFcLPUwM7Qn5jgmE0J8YYyKP0KYramQJRksNpVIBaCWTchlHigqNAn
         s2XDGm79GI03IaECMvnn1ibFWJTBSH/1UFuzZTYRTJNwfygpe/SpASJnVgAY2Jp8MzJv
         QTlCaZAF2IrZ2EwWWACKr8LrYV9IMSyusKMNirSYS4FUmzEv/3E0Zbu6mulI8uXdbihD
         uF9bPmIFQ9oPP5eGqP9Lyj87Pn0aMHParokcm8+NTWCpVifcrYaWY3UzDeAplspN6wck
         ybvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781309815; x=1781914615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWwT9TpVhYF/K0z+rdL3pthvZP+Xb5uL2Tmv/pNJ18E=;
        b=bA1UHl9YUpJbX0W4zvE82fBhcE+Js85OJTOLLLaDuJmxifKVvkozbAJZA8m6sDNsNF
         oVzpxXRRE7PqmIqIVcZmz///487nkX9jfs5/jmNVl6mBQY25cOcuhXOmsrh2N9XByAZn
         bLEtR5TfPsE3DHBgbSV4It1Q3lNx+6hVpFpetUC2cFKKbA585mKLlMo7UOqrZCyioXaP
         WEo373n/RBMh7yBGX/Z9Cz8LWMrEIhxFmJPs7v+/eVRBvdEmqjFb7Tz30VXmdJjYro/7
         JL8jNVSVESQ59vwJ7dV8BsxJEYj8tTi0T35ozAkl5PcxNj++c9VLZcZRIIri3HL/Gedr
         WZHw==
X-Forwarded-Encrypted: i=1; AFNElJ+u7OA4L1BR+EKl7ToTz2/jf6T4d7g2A2H6XJBVjG5LYQKvJsrQ5pK+4YORlozZV/Sfy5w5zDZRMg==@kvack.org
X-Gm-Message-State: AOJu0Yyp+Knl3mcxDg2gVsRC1Dgm2UoSJ+nbfEV+2HssJ/cz1e3r9xuH
	fD2GEC0RlFudGNCd+NFcYjwMa8fDeNh2kLVvUKedkWNXEZp2HE5RAe4UjpOlYu903w==
X-Gm-Gg: Acq92OEYRxH+i+5g6G+BaFIk4XenuV26kKMWW+OT2/tIlu9cJK8vCenJo2u+N6fwVbi
	m1v2tUIwW3UXoNjbNT61R7SZb9/iyJ4JUIilmttF8+Ez7KtIy27/cL8D5cs3GXB+w5J4Ho4CY31
	FkXBmaA2T5V3QJtoYDkRsrhjkVoJTYc27YS4botI5aDMIGVy+1q66D+iHxunD8l7gcTOJN0ZrnD
	31KixR+UbsKXHtdRjNoVQ/gQFsQcvJFqc8SdkA3SyTuLm3O81EFBFOTkmWBzVI9Q5yxTz+rN9c9
	b1aHRhSzae9r08W7AeT+Qcqpr6d1b/hAsNLOO4gfazMzDD9fyn7gVxEyPhLh+YAs5EFgvXg3ufZ
	1TboJRGbi4GJYXIiFogn9FxZJu9uhbrWpuEpG9rTGff36cqro/KX6ui5dh2Yu5nlxb21PTlsfc0
	m/+HamPBSyWnIdx6TkmoGxs9/vlJmoadQx03AiFwTCikpIA1lpapWuOpCojDjMhRVt+p4NuiwP3
	EM=
X-Received: by 2002:a05:7022:f8c:b0:138:888:32db with SMTP id a92af1059eb24-138fe5a1d90mr28525c88.27.1781309813946;
        Fri, 12 Jun 2026 17:16:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:e362:1a25:b90f:e3ee])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081ea43b80sm5190375eec.21.2026.06.12.17.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 17:16:53 -0700 (PDT)
Date: Fri, 12 Jun 2026 17:16:47 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Dev Jain <dev.jain@arm.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
	glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com,
	kaleshsingh@google.com, 21cnbao@gmail.com, david@kernel.org,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <aiyhb2XwMMJE3st7@google.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8i5hi65a3oktt9p8zt7ke6pewyxggyg4
X-Rspamd-Queue-Id: 3B19B180002
X-HE-Tag: 1781309816-871898
X-HE-Meta: U2FsdGVkX1/68r2Xn9uvDGZBzl3xaGUG6up14tZlPas6Rnq5DFcnHsj6WXvucf3jsvl83OHDNop087FOPCp8vr0hbb1aaC/OFZSih7420JQizIUmyxupiZPXs3DP3SqU8Q+oDo4cqrEL3/9tJQhT5PBRr7zmhLjRTGsUUc72kP8CrkE/dq1R1Ymk/3G//j5fTeXhx7zGSZzlkZIRiD3ehJY/MvWho1V9/c9NBEVojnRv33Fn7++qXDG5kWkDt0Tj0PFB0L3LuPzSwEbcnEc5cndI8GgAUlbGgAkehBFPVhIFjKoMP+WwgHrOqau3ooPXCW0XHtX2dhPUkPzNaP/QVTV0m4q47BXDvwo03UzIL/1EY0sFEzMVQDxChZGi0Js4oNun7Syb3k8umiFjD7elvrijEK1HrQmRix0YUUrbWhj8ooTl1P0h9XZUKfWcMcjQioQB7FWqx4VyJPDgXBpO8FTrZRG/roX5Xw/Doy+uUvqjB7wxru4SB1iNf8vaQsgBrQMW1P6/20YwMMa7JAXEu3zJi+A1MEYLLA05zAHeSxmzCd5LQiEFBhnKXiJdewo58ZbUtVbUNaRA/pTTVBTfxsbRv9FUuqBQMa7LuRlRyepMi0Tf7WV0575wiUeCWHw3f/2SbzAI5jC7RTlV95rVcB7LHFeacywjlTaSKj1xrp+zGn6IbGhjHTnmOnXN5NE0qzyFed9nADjm66rggGDBxAGhET7DmmgyMgEhZCzC4AZTIM4LyMIk2/TCzVEzRq62UFCN5zOUA/vNFHe6wMmZIpGAoHO50xBZlLgSB1SQreckDQ1xzrtN+k7uzkAdRaOfyfxCv2xYAcyojqpJnB1lcxXcc9Pj8z8uzvDQSmG3alUphUkPCgTMwjC2TcjZ3i5a/KDWMgaU4mr3tPl1b98rbMw58HUQnLN7qmEPDbB5828Q4FhAhETTCrXn7CBg/LE0v7jvOnfu9IdKudXOlA9
 Rqq/p4I/
 q+SQVi1qzd0ElulnY8oFbJGrujFxVGMS8Gt3VH6PB7UcvWFG8JkoNxeseTNFaSHB57jLyQf0ljtgJ3Xyc+UYgI0Y9mcnsKDIP4ea6Yi9hMmrW0Zd/ZRijBg5Ih1A8q/AF769dTgU9EdpJl+4p8rcLpabRAEv/84nLXLOFYTwNAk/rYMZobJh9VG1y5dYeOqlrWkVzjPofWy6nxLK6HB1k/eQbnUXCRVty9uonSo+2zqnFVcyGzpp2U/SGFdwGHqfL76X2hOZW6rup5n8B7cV9meqnom7sB4S2q9Q7nBBGep+/s2/BJdvIV90VFh3tcN5iLe7q9fmOhFkBW2iAXGp02wzfm33nWiiSXZllTLCNv6hyjxdtfwalobHef85OXrh9yYLaSdLZ5hPHfrns2nKXaBudekKSamG4KIDBKCmDQMVO5s/N5EHhW9Xm8+laCwBDU7Dm26435KXHjw2HQX2SFSrxesElK6GrqWGF5ziM1YyXLWRKc/wXN9n+vuSbQMc/pKSWqxnBee3DwsWBSUKT60RL9lAKeMlMQB6Y/cf1auQhmYOgxFTKJXwGVwIhbj5qa3oc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 04:44:22AM +0000, Dev Jain wrote:
> Introduce a boot option to tag only at allocation time of the objects. This
> reduces KASAN MTE overhead, the tradeoff being reduced ability of
> catching bugs.
> 
> Now, when a memory object will be freed, it will retain the random tag it
> had at allocation time. This compromises on catching UAF bugs, till the
> time the object is not reallocated, at which point it will have a new
> random tag.
> 
> Hence, not catching "use-after-free-before-reallocation" and not catching
> "double-free" will be the compromise for reduced KASAN overhead.
> 
> This is an RFC because we are not clear about the performance benefit.
> 
> Android folks, please help with testing!
> 
> ---
> Applies on Linus master (9716c086c8e8).
> 
> Dev Jain (2):
>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>   kasan: hw_tags: Add boot option to elide free time poisoning
> 
>  Documentation/dev-tools/kasan.rst |  4 +++
>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--
>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>  3 files changed, 69 insertions(+), 3 deletions(-)
> 
> -- 
> 2.43.0

I tested out this series on one of our devices that has MTE support,
and didn't see any functional issues.

One thing I did notice though, and it's independent of this patch, is
that the vmalloc_oob is failing, but that happens even if these patches
aren't present.

Thanks,
Isaac

