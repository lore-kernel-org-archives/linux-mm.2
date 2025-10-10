Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE85CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 17:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1898E0049; Fri, 10 Oct 2025 13:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9544F8E0023; Fri, 10 Oct 2025 13:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842B28E0049; Fri, 10 Oct 2025 13:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2C18E0023
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:04:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 079CFB9155
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:04:24 +0000 (UTC)
X-FDA: 83982828048.03.66D42B5
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3811A2001A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:04:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=a5tk1Q2R;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf03.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760115861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMMsbHNHQlUNowhauDzTqGTgCrfFH9KMpRorSuBG4rw=;
	b=alKLWL/P/DIj6KzHan71kUFbV9HnptrCw5WMivKAw3hVAE0Z6Fj6njXL8nT5zS+yw151cc
	PlCWmda0tJkg3GwLqNI1wWU1IyxbNhZVokb663pO9FHQyuCI7ehb2eKsniCzGw/tS4DjH3
	Ln8BwZDNaW6Q2+XeYHInGlaFF0UEO+k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=a5tk1Q2R;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf03.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760115861; a=rsa-sha256;
	cv=none;
	b=B3uOfWlZxLpu3qQmsB6aAtpnLDqFXqTW+/zuFBuLBxo4dNS1y9gGxoKmSOaZjEikfe01jq
	1s0jMS+7jJZhIuks91PHNkl6SrmXK6P2MLdIWVETguSEt2kGNGrzZhdmFbzp0OK/vtaNn3
	92ApfSUmY5V3MQSxKv7+rjseYEUACUc=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 72AB93F8E1
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1760115856;
	bh=VMMsbHNHQlUNowhauDzTqGTgCrfFH9KMpRorSuBG4rw=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=a5tk1Q2RFaKBve0xxBdEkKrQx3U5MDUNvrGH502dzk8UGJhQQtCi9eyBtTm6/ltQZ
	 Ee6kr74mZQtlNI2T9RlMspwFt3k+0S/WWhcj9F+rrPw9VunASwIQgfCYdyC7GQfzm3
	 q3+Zp7w5A3R7lym7eFcP3fp5EBJk0X60/MbUC4+G6+c+WCQZTAmrBSZB+/yoXigstf
	 rIV5ymr1lAxAQezrkKMj59Ma16tGIVR+zlqDXa/IWF8MmhWLbLy3uBALYGiiFx/7so
	 pmvCv067n5T2SB2ZuajhOORM4EkgyXRvReHRfrXjwV1BQJ+PKjDNHUECcLRVG7Q6El
	 TV+prLnDLTFApbxNu6TnGLtiZQBzzk1E8+DzS6KpsZyFXNxw3iPrP3smWYJ8CB1gtO
	 hSf7OoI+Xw2p8nbgzMMl/WZkTvpUlcEtirr3OvgHvgK7dYnCA0onesc38kJ1SLlNOm
	 VYoRXhugTWGZvvl4H7148iRjvtF38le1M26QenW7of6XlFmerUAxvBjOjwuWNCX8r9
	 bNQMRiZQmNJE7ucwL33d6N4IBRjgQewqPzsuKdlAAZVatPRDQ50m4aUSs9F9+9N0ev
	 fW2CfFwegOvotML7ymBMVt954ep+A2QRm0nRjfDAoTWELN8JVNTnADMQvKMzt4zonf
	 J+U7y+w399nIyjf49EdIfiIY=
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5b5d229adb3so5821754137.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760115855; x=1760720655;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMMsbHNHQlUNowhauDzTqGTgCrfFH9KMpRorSuBG4rw=;
        b=SWbwoOUKeMWmwRARuuxupIDZGbsnNfxXTyJldOPgGL3Vp48t9EBCTTBxdKDpJU4Rtq
         tkN2HIrRfiRm9E/+vKBq3exDz6/03j6ynTkfBB9nzUkbS/J5hqNOLvQkBqzjcj5nyiG9
         Aw+LlYVl4Ev/mxqb+crRTh42O1NK0IVlucWhukWPSS+TMK2pe4PpiwOQSLIeebrnSlnL
         kwYSkmpvd+uuBFTPQ08iaYcb4WVSnPK0jyBxWO3hhw2btEVNJHGtvq8xtQZomGDASaDC
         xi6BJcJO7UjacBzVrgbyL1EGDSiXR0cFIadHiZWAy4R7QzPSq9KlTPT0eHO3c5yDk+b2
         53gg==
X-Forwarded-Encrypted: i=1; AJvYcCXoYn1/nyZejdnR2wDQwugm0REvaSlpyU3wLXtj/Chyakl3dJcvBFBl61ZK3yKoBeUwSTekWLsiTw==@kvack.org
X-Gm-Message-State: AOJu0YyNoSp408AaqN9T8az4PpbmMduKZzV+GEjPoDdCazD0oMbaele6
	6VpsjhPSNY2vxQ/7QdBHLMs6ynM+yHVvhqxvWhJfgYJKfPAWzVx2rBPWZL+eNaPuO7XHJSHAHCT
	6TpHPtUesXvfM8j8vJsKJGj8uZlRfPFUAnVLGCO2Flc72ivXTg1sHDv7OZrnQ4DrWBcEdJT71DF
	WqNn03ItswXFpwlGPnmIX8cqV9m7DmKMY9Jf7tjcIO37E=
X-Gm-Gg: ASbGncvywTm6vy+/eP1mvWj+FdhsU2ERZ93DPBLHwmi9Vrnq09Eam2ghOypPQTvaNLB
	oY7VK4BRP61ZRIsoTX8vSGme5gdaREUEJ0rjId2PiKgxXoTPH1pN7Kab26RiFNR/LHhVikaeZor
	RNMT1BiidYRFCjuok8WUY=
X-Received: by 2002:a05:6102:3310:b0:555:56e0:f357 with SMTP id ada2fe7eead31-5d5e2351acamr6103886137.23.1760115853741;
        Fri, 10 Oct 2025 10:04:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBv28DNHJQ5jnD7uIITRjtmxvXAZjjFTFMwrxw+yeFjdrVbwveu4Y97WaEPytCYr30o/zb78JpBxe+rPRUAWY=
X-Received: by 2002:a05:6102:3310:b0:555:56e0:f357 with SMTP id
 ada2fe7eead31-5d5e2351acamr6103795137.23.1760115853023; Fri, 10 Oct 2025
 10:04:13 -0700 (PDT)
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 10:04:12 -0700
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 10:04:11 -0700
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
In-Reply-To: <6fa3c728-5048-4d26-9b6f-21757320caad@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-17-samuel.holland@sifive.com> <CAJM55Z9kRpc53s3Kip=U-CcDxAX0UZD5AbTBy_owU8xPEYH5MA@mail.gmail.com>
 <6fa3c728-5048-4d26-9b6f-21757320caad@sifive.com>
Mime-Version: 1.0
Date: Fri, 10 Oct 2025 10:04:11 -0700
X-Gm-Features: AS18NWCTcud7R14NP1QO40mHS3XWKKbNmY-Wviavp42FX96J5d0QmbVlv50GxHg
Message-ID: <CAJM55Z8masgGn4vVe_2g1e9WXnLu0Vf5oGxbiniGpsbOhYPLRw@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] riscv: mm: Use physical memory aliases to apply PMAs
To: Samuel Holland <samuel.holland@sifive.com>, 
	Emil Renner Berthing <emil.renner.berthing@canonical.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Conor Dooley <conor@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Emil Renner Berthing <kernel@esmil.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3811A2001A
X-Rspamd-Server: rspam03
X-Stat-Signature: rqwbe3sr8aypfbmex43bsi4m83qtsdnn
X-HE-Tag: 1760115860-850370
X-HE-Meta: U2FsdGVkX1+JcwUTJSUh/X063N8Qy2EoXv0eXw6ECxq/QicwqMsNACpIfafb5X6neB0GcDKzyFphF/xDtWN5HjsSyrpWQO/tUxN7OAeKpHJj/DhL76c34YcYW0jpW9un6GdrHMaaGUn0zk0xPLSf2YOVIIAEDLyU9uTP1oi0HULDrL6pLfiMK6vspYeueAFi07NbJoQkDx4GD4wYG5oMZEMwkBmNpuo11kdQimeNxLQOdsZaojav8TZIyzjpDOviJ4fZevL58dUwRUU/3oDLhvp7OyRWyZFZ09J7xH8+nNsRS42LXMrvVDAz7Q7p9DZNFy/Lkk8h0rO3+bd1TU2oYQeMTnEs0ezTWvuY+9pL54cS9/VVonqbHVM+GB7bmX2EJAhiK4wSBEsu7eGJK/om207yxnaxBkEqJg2QO69AYOIWstDa6bBn5my3Wud+Sxr7O9iNLoWAajF1r93iXi2seSjMRukkuSpYr9C0XYVUTmzrYq6jqewYKsNVjKe6Y8Y4niL7ZDT96PYEWr/tjtyPWdWuBcztcrpNPIHcW+SL+7TbOE27ySyin6m6IB2FlPwO34SpTFRwbMjcJDSPjK0WPdjMUa73wh4OSPmFiWeA3tNzHxZd46sJag1QouRe0Vk1eDRvHroqyx2eY8gPPbpz5Gq0LA0oasxm7IOFC7FTQPZy0zW2Ynvbe+awizW0GvOqXdvZlvgheMrkrQdj/QcmPhOj0jeHP+KmQ8scW4WP8Jue2JE0xUPYirTmoLH4aSYUcyQbkCzdeZDQ3WzNRHZUViaKDG5tmkJRhaMGvcnXKRUKOilnLIXd3hXyHOdkOOTHrckOYfchHcMT/t9REi+Myg4eld6GrF2fQxPNgctP7DHfo3gIRDOh1F3miV3XviQibIBB+gSQYfN/IHRT+QmTW86W0DQyYMIOmEMbCBpoH1oDNmOQJlOpBJc6EHAs33q9KlQwZRd1ItKgjmSJiAJ
 bsPTfGYZ
 YbkcGKy65SjfnTaU2K+qLrACgjN/URyA2909iucMBiDQGILhZvAlBk6hio/FGCLGPJBrMF6SKSVjpGc3iOdhL2JeIIr8C+DegucRn8jpUL6rmpcGzhv08fxjFgfHnB+5F6yqzVS/+P3REf2y9TVxQz+S1zJ2eezp7Y8iLwsAHRSNoup8vZfo5iT7Gk31srRek4INOuK4DcqotNS2Tj707R7ZvtfwsDv1a1NIQ6uq9sdEPfDiIV1T5F7DjAXS++z/DK6Q+MikzXqGLfGJblTfelbsSn5ex/vNTSS2FH1pFDRaUVWDEhrpecLnPWiLDV2GDlbxTf/1w+Ik8OvTVQ0VKjqWjUumXT0bOIR4mxnOR2gjTn2DoM107jL4DmLT0g/XQkriUDF0RJbqQV5iolEPArqjr2071F3tfHjQEIGsxJNgKDhhVFSwzoSzZElOIwM5n/KdnXgS4m7h1aPArneeMDWeXGqqD67fsxtn4xAW0GgY6D6pX9JSsHxJ4Rep94dcksFikakesYx5hOq16jDdKQPlHuLcO9XgSwxRv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Samuel Holland wrote:
> Hi Emil,
>
> Thanks for testing!
>
> On 2025-10-10 10:06 AM, Emil Renner Berthing wrote:
> > Samuel Holland wrote:
[ .. ]
> >> +
> >> +void __init riscv_init_memory_alias(void)
> >> +{
> >> +	int na = of_n_addr_cells(of_root);
> >> +	int ns = of_n_size_cells(of_root);
> >> +	int nc = na + ns + 2;
> >> +	const __be32 *prop;
> >> +	int pairs = 0;
> >> +	int len;
> >> +
> >> +	prop = of_get_property(of_root, "riscv,physical-memory-regions", &len);
> >> +	if (!prop)
> >> +		return;
> >> +
> >> +	len /= sizeof(__be32);
> >> +	for (int i = 0; len >= nc; i++, prop += nc, len -= nc) {
> >> +		unsigned long base = of_read_ulong(prop, na);
> >> +		unsigned long size = of_read_ulong(prop + na, ns);
> >> +		unsigned long flags = be32_to_cpup(prop + na + ns);
> >> +		struct memory_alias_pair *pair;
> >> +		int alias;
> >> +
> >> +		/* We only care about non-coherent memory. */
> >> +		if ((flags & PMA_ORDER_MASK) != PMA_ORDER_MEMORY || (flags & PMA_COHERENT))
> >> +			continue;
> >> +
> >> +		/* The cacheable alias must be usable memory. */
> >> +		if ((flags & PMA_CACHEABLE) &&
> >> +		    !memblock_overlaps_region(&memblock.memory, base, size))
> >> +			continue;
> >> +
> >> +		alias = FIELD_GET(PMR_ALIAS_MASK, flags);
> >> +		if (alias) {
> >> +			pair = NULL;
> >> +			for (int j = 0; j < pairs; j++) {
> >> +				if (alias == memory_alias_pairs[j].index) {
> >> +					pair = &memory_alias_pairs[j];
> >> +					break;
> >> +				}
> >> +			}
> >> +			if (!pair)
> >> +				continue;
> >> +		} else {
> >> +			/* Leave room for the null sentinel. */
> >> +			if (pairs == ARRAY_SIZE(memory_alias_pairs) - 1)
> >> +				continue;
> >> +			pair = &memory_alias_pairs[pairs++];
> >> +			pair->index = i;
> >
> > I think this needs to be pair->index = i + 1, so PMA_ALIAS(1) can refer to the
> > first entry (i = 0).
>
> The code here is as intended. It's the PMA_ALIAS(1) in the DT that I should have
> changed to PMA_ALIAS(0) after I removed the special first entry from the
> riscv,physical-memory-regions property. Patch 18 also needs this fix.

Hmm.. that doesn't quite work for me though. Then the "if (alias)" above won't
trigger with PMR_ALIAS(0) right?

/Emil

