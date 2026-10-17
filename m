Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417FBCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82156B0098; Sat, 17 Oct 2026 14:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32FE6B0099; Sat, 17 Oct 2026 14:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22056B009B; Sat, 17 Oct 2026 14:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE2736B0098
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:54:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AF62C02DF
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:54:26 +0000 (UTC)
X-FDA: 85333018932.22.9081F77
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53D7FC0002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:54:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RuJnkUrd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792263264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1fNOsVKAAab4WI8wQjcXQIXucd9FPacs7g4minaeJs=;
	b=6ECHFJVYhx2hWRFVJVxPDL1dsl+JKruY3HpQVydzf20w1h0+WnKlCljQ+6q5ZX8nJY+JtO
	b9PiJK2Y+8XtC9gMTp5dePR5cjK/Tm1ipJW3sbuPFpaa7xo8qr9wAKDuw6ubb4H7RH/JO9
	mdLCh2s/lVd3aE40UiAFABex+jqGdyI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RuJnkUrd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792263264;
	b=GnnbexjKEJAFyWCAzLIIQwq5TZZziIsknT1e2qb78oup8GrAwrlqPOd6wpWLJsN0vhxYNp
	NYVtPqC8zsOfuHRYeyoB4kqYPzMNJiygKz9oyxaNp+5940pV3XOr9egtqk2X8LQrdUDr+f
	bs4MvShawozmJdMqzQb9d912UD1Y0Z8=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1dec056ddso2930795e9.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792263263; x=1792868063; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f1fNOsVKAAab4WI8wQjcXQIXucd9FPacs7g4minaeJs=;
        b=RuJnkUrdGdloop8jpNCzw5bL9jV9GyFocSsGnnuSYibGxlOxY7r+8NRsi7YthpU4oO
         v+UhcKBQU/kaD9xans29LJ5un/Y7cturWESbVFXv3knYIJiNGUEuG/qAKH8eEmePNUL1
         mRyfGjT+WWAFEJXch7UqCchC2HZbkPlnPAEXfKtcixzmOhxmzqqKvVqzmoqN0VI6/0Gq
         ihLz4f8P5gpuL3k3s53k7SIhAHBCTxuwih5wyR+FtCzOxpB/RDGGbfQxD8hpNUb7OG0J
         fTMNN2sZpZO6ezIArEW41eZ19kSU2XRTziFMz5VsbwiCiS3b/nNAJlj/kkYA/JcUNmrQ
         C2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792263263; x=1792868063;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f1fNOsVKAAab4WI8wQjcXQIXucd9FPacs7g4minaeJs=;
        b=odhHlor+ebrcOQsqrK9iK/sV8ws0S2YDKh7udaTXVj5JoPo61d2xR2y1Gp8xQWdXD+
         i2b76NpKLoo66qoWVYeiqIrnciBGE3xvnnMZ2UgMHdTW9dtsuFLmlntmzEn8n6c8sObT
         KFo7qMHS/0WRcS/2EYOXfUG5xxA9pll9EX0je69QFcOILDID+Zrnfz+em3WnXKeb5T6U
         NLkK+zxGxPsT9N7AYdusecPTxt20J2z6ofbzjDnaciXAk/djKUR8iP69kp+XUt1NStNx
         kKbIR+eqFIjcFJy7ab0ubdn66CyuVrNyOd1vgYYP2e734mlOtQYplsuff+mofVMbjICW
         i/2Q==
X-Gm-Message-State: AFq9FYJeM9PLBxLEloeYs9n/D6TDyCCnYXM10rzeoTYqvJeFmIezg0gX
	JHOaOD4pHvIB32ycofcmvsMTcC67mW1iRFfEjiIYAuRVeQrtWdjyNgN2
X-Gm-Gg: AYBFou1pZ20Percw5wzGjUEnsBy+U08K97VypSbJBNHgN7dVpGcjvCfTfb9LLeS3V0e
	8VvGJDIr4gT6twtEJf+kp9pyRrfz9XoZ6sojNF6/veUho7FrlMaPk/YE/oh9wSoSj03hjDxSnQk
	1n0u5hNw0RRsEsx4dPdWbX35507f+MbanGfxo9WPmsqRaXRoM/0/6gFT7U1j0Iy5srFJWzbxDfu
	6uEThkQpeSUkqmPF9dXyUospM0UcKazDviFEeHzdfKLFYWtS/G6PotfDJLmTJoUT3ODrCCnX5vM
	49N+lHEOvAruiqVgwxp/lmrPY1uN4XqDDMSCARWMrosac9qyitbhOV7d45gO0ttWJh0u0SmURgz
	6iVDtokg+QmX6491jQ5I/adNSWlowF1jVjt2IL+Osj2Ee690zzt3wLL7x5XmPPzJIGdE3thv0VO
	ya/1IQOYPtJLLBqLZt/wEVV8a3W2TjC4R8L1lBmx7dlMBuHCgFRczgaIplp0ToDPfINA==
X-Received: by 2002:a05:600c:3b17:b0:4a1:7c7d:8881 with SMTP id 5b1f17b1804b1-4a1d76139ffmr71111935e9.13.1792263262725;
        Sat, 17 Oct 2026 11:54:22 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4e28bcsm12739567f8f.23.2026.10.17.11.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 11:54:21 -0700 (PDT)
Message-ID: <fe58f891-7752-4691-9e67-b5a4a5c125a7@gmail.com>
Date: Sat, 17 Oct 2026 20:54:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: hugetlb: avoid recursive CMA allocation during
 migration
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <d145aeb815b318ddd4dd9058d20038acfe5dc1bb.1792136742.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <d145aeb815b318ddd4dd9058d20038acfe5dc1bb.1792136742.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53D7FC0002
X-Stat-Signature: tdw83p59cn81a4uukc9pdjor59txpbbi
X-Rspam-User: 
X-HE-Tag: 1792263264-16638
X-HE-Meta: U2FsdGVkX18KnVf2E1VdIK88ZcPbzBUv9R2SVbmNc+aU4iXhLXLOVjID70PU4TJaJgEKq2nqmn6TV85HWDl0aKxkXjq6AeyP6SN2u9tODpTibzhhploVLL5UZmkX+93/OEvth/iXWZwp+UszkQ58TYKEtM20XKgJybwuG4OdZIgAZhbdvtWGIIGDGDHotaJ0kvjH1bzsqvXZRJ4vRMvy231EWhyj1DUCweGJgPspNrXEs/2EeIJvxJma+ReOlTul3Fu12J+2s/ikGbwslQnouEAag9ExeTI4d6uqd3JJhm6yrT2bhsR2HXnIn31nzfM8g01jV7vHo0LUlEZzFX4uyrdcqZu03ZuYC3YXruIF8PdXyUC75ELlBo1F9Gygx/nokloc3+Q2fkCOmM6B44c50F3bcZ1Mx1KJO5goAPiJYVHg30qSynCphGkS0HljIrWiMOtp0uzPMSLKwUw31jiImeHU8WbdCoyAuYRuqUMfmJlcuCIXZFavqtq/8hus6FEewtlTeA/SBdBvRspSoCSUQJFir04FcivE4Zwey9H90Egch0VjdkDbm1TIKY8glxGCWbJqwkVlXoAVvW1iN3Vm8eIGM9GuN8c8ci8Fba8TcnYICeSiy9HWPqx15OGxTUNWAr57U/Ow7N7Enjl5pBYqgLAdWWhKy+ConarZboy8y51SJzvJWzrMzoA1/xbe+jmUVX+G8Ey6jiDmQrfXg6hefWtizAXFHSBIE08N1kjqdOCWqZh2HjhuFo+c+iEc/zdeqRyPDDlIthJqKA2zfn98O36DI16m19/QS2cUmOjIeVz99PoEvlvRI6LMvI2aywwk88uLpDKL4kFlhCbROevDebwK66abt0CZorwZjGYnbc7z6xIlYmKTCYLSATzQv4OTMSCyQfnOrS/DLdlP0WhG7+kyVSssfYyioeQrdVKbIWEDEbuwqlq2SFQgaafFYg1WoGi8aJ5652Yqke3/EAX
 fv9F/Oo3
 wt4GI8rNqN8XLgTQgj0/UIPXjMxFxFiRiFpapp5EcP/aFd5z7myfWLhepwM65gVnBofCB0U/ymPpqc8nhQjRBqyp7p+Ekemg8iN/AzqQYwbFQASylrL12AYNq9NXi1N/9YEuam5P7at8J9TaySYHDE4xVfUQfwhLERlKQKSeemtGPPNemNEGkuFLi1lWlzKXIWOgaCBfvvLewyC3azWIbKnVn9IojV72qXaXqWQjuFQFaFKnDTYc6fQkgUQqVJusxgf5Fj9tS07daQ9PjkLnyYuJ1O+6Hl8/PgI6ZFW2y1f6Qv0hUofMm93lZHbefkqFAFPnTokFMCA9zs79qT5Ffk7WuFWlsNZ9UhDJZmqVEuF0tbPUrntEIDzfMhjySVh5wV8oulE6HKs5MRmNEkQN5Bi3tADZcM36gi2EeFAQUpmIpnPdAVGVd2T4xqRbg+VuLpDBtL21AMpedvuvHmyi3NcnDVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 12:07 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Contiguous allocation can migrate allocated HugeTLB folios or replace free
> HugeTLB folios while holding a CMA allocation mutex. Allocating a
> replacement through CMA would recurse into that allocation path once
> non-gigantic HugeTLB pages can use CMA.
> 
> Add a fresh allocation helper that bypasses CMA, and use it for free folio
> replacement. Pass an explicit allow_cma argument through the migration
> allocation API and disable it for MR_CONTIG_RANGE. Honor hugetlb_cma_only
> by failing fresh allocation when the corresponding size requires CMA.
> 
> The existing gigantic migration restriction is unchanged.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

[snip]

>  /*
> - * Common helper to allocate a fresh hugetlb folio. All specific allocators
> - * should use this function to get new hugetlb folio
> + * Common helper to allocate a fresh hugetlb folio.

couldn't allow_cma be passed down to alloc_fresh_hugetlb_folio() instead
of adding a second copy of it, so this line can stay?

-- 
cheers,
jose a. p-a

