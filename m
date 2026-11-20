Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A531060A260D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=modal.com header.i=@modal.com header.a=rsa-sha256 header.s=google header.b=UM6vQeuV
Received: by kanga.kvack.org (Postfix)
	id 98BF96B00EF; Fri, 20 Nov 2026 16:40:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9159E6B05B0; Fri, 20 Nov 2026 16:40:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD406B05B1; Fri, 20 Nov 2026 16:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC7E6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:40:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADF58A0187
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:40:56 +0000 (UTC)
X-FDA: 85456817712.01.19B91F1
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id C704AC0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:40:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=UM6vQeuV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf10.hostedemail.com: domain of samridh@modal.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=samridh@modal.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795210854;
	b=VWebDeFca/Nm3yLoICaxN1CxfM8Z6T+rQWwzeI+U0spdoiCxDW+ZcmRJGuNxy9atF4MVnH
	EO+5+nMCShKVXWVeuuo8J3wgk1n7xz86HLrYEd0KwfVanMg5Q4fsoA5uZ0PvjzAjz9Nx06
	I9P+lxzGXHiAzm2jDEkdciC730seVgg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795210854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QImpKtA/5km3yjf8jdokal2t9YOvsyssIpZK1Sv9UwI=;
	b=K1HaPUMWVEpK6WHyiKNcn505rYzporbokhIT2IfikbXnSgOO8KgbmiScmx32V2lOhX0JwZ
	oCFJzrs2kW6GWcZYYauftjeHzhNvjZqrWyA9E/bgqheM1j91HRTotxCpE8naqBegmrc2ML
	++twCyNMIUMxcCl4d3l/N4ho4Vx7Vt4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=UM6vQeuV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf10.hostedemail.com: domain of samridh@modal.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=samridh@modal.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0d126f631so11435967b3.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:40:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795210854; cv=none;
        d=google.com; s=arc-20260327;
        b=f3p5J8Jk+j3Ww/4QGVCSiN7Ho1VI+/RLxRRCyvBjqmDVhsGLNAH2/P808M1I8mvXt/
         k7/fhLdlAz4H9KC82Q124drl1eWnmDD7LKNoGflR02m0F2B80razMbH1Ua64bEaGvgru
         BTGeVVuvDytuJIXszGS7FE9r7pvfEdo7w+LfIYUO5OHFqIdSxoGoijClc/ewdjDyy99P
         Q5DMN87RO0yYYFRdQ7TXn2zmKCtHMSiSlqS0xYHY+IVyt4FZZ+woWWmf2dW4PvquR0x0
         W50t6yYHN7YKbMTWmb7rPKBH8N9QZY3tXPoEMFf97ZA77qgYHrcj8ffZIlBKfbfEa6hR
         joEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QImpKtA/5km3yjf8jdokal2t9YOvsyssIpZK1Sv9UwI=;
        fh=xXbUX3kYkRvpiqXpLqB/ByZmFdUJDe4yej/kBb7aMPs=;
        b=fz+P+06OPO3NiRbxScs/0kFdBf7kApdzYp/ex/ja3jWk+gx/DXJ2Js/1FujCZK1gWr
         yqaW8VrcmBpwSdVOPTldtfVDwiyt0cwC3GZ+o84xH+tpwLA//EtdrYxt/ZgculxGmj8w
         dJN7/Kc+K776GBurS0rAYwzRSuuq00ADOP0U6tudvArZ1eGxcEDJbKsUt/i6QTRrnXYt
         /jo1vxx/WcDIeRHb9RQ0oSKHTYj0hvqiyypmF0MoLGOVHwF+OXWlID8F/ItKu/5rx0Rs
         TRcgxTvkk1mwFjI2s/egkn6q5n7aftSuVEIDcVOrkTlhszObGdUHB+3VFx4uR1P7CprA
         z7gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1795210854; x=1795815654; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QImpKtA/5km3yjf8jdokal2t9YOvsyssIpZK1Sv9UwI=;
        b=UM6vQeuVMM4Lbq5p/QQXSxAgEEMrilh++6GHkKw6DQhnBOUb3pwvIU3qxkRt1QzofM
         ojocenw8vT9I0a5SB1WBp8BH1I05aBMXK1ZLXjIYZvDLbTBaxF0HGHlZvV1v9o40ARzA
         kr2Ytd9m9pHonWHaC9fF3B984CUbpdpkqH+8XsaJ1qwtEwpV7Dew0gPa426YFqWETA2i
         AB6lNpzBBrz0ab0aZ4GkBE5/MuTE1dUHu3ggsrqvndH3yrrIGGvs9p5JUjpVsWHCVc3V
         fnDrhTsDQ4a/tJE7CLoLyYjvqyyVuPqQodP2cM0kkZ1WHsNYk9tM+AerGlp9r7jj25Dj
         VDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795210854; x=1795815654;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QImpKtA/5km3yjf8jdokal2t9YOvsyssIpZK1Sv9UwI=;
        b=RIsKV27H4IkO2A9cJ4lz9+npQmHjg6UZZszGcTBHqqHTZLc2P5Omq3nAM49VswKYYs
         Vu5kD1xc9l3p6WPwLzEUH195VyOv8oyc90wToWNgDJNLmn+CnsDsqfLrVXuDzq0N/Ln3
         +jdegn4TjzF2Dd1DIv1LVKRvg8Y7vFaD8QK1GF8xQETmxRW9W5wHOnkGyh5aDyVbOi5P
         jH0U6zT4LR3lK5wnHZkE8OlWUcQlYteMHOeWr1PEUrU35/yNKcrInDNbklLqSbJvnNAU
         mj/ib2RCYMVp6Zo5ajmQFY8/LQFD0IjmxR9JRnOpEo6/p9BddUq874HRA8NRFJzRAF9Z
         roNg==
X-Forwarded-Encrypted: i=1; AL+hErH1PTcDhdzflKxLCR/MXalzvzqUowbZFHw+w/+f1TS0PrD4+umN9f9wiENet1/TaO+dvSnWXKjegA==@kvack.org
X-Gm-Message-State: APuU4Z86fm5KTkenPvu1AMqRKwlsJ9PnAoAxxnw3XpaM3vHIKfeRwGeS
	Q/yrrrWR2dfW18hqDbLpjSRcVfW5dtvlvT9/s7zKJJnr30FG6GKNKr5WUbL6NqL54MYDwn+yHz5
	MObTjuemByxwptbYQFIdSMhNUMMhvuWHPDZ4xU+8vM1Hg6P2MSIIBdI0dPw==
X-Gm-Gg: AZFdTZfJD8zyCiInZnfPwiyXLgYdYZt1MUj3jpw7fXPcg0Z3j/47NYVWRHbMXsQN3GM
	6GTnyQHnVIkzawUWQBwdn7eG04AMnoeS+Kk82jCtXN+1q8Idg6zhZ747xjwR+uPQIlhCp6QB9Ir
	x2VvM1E0/Vb54X+MpH51xBvrpzT5xHA4ds+D+sd/SgVaB5v2kTcIRcDkuRXzY1wKsv+kOrAskpk
	w0YRSQXOTLzPsewBCgZ7oTv5VKAIZuRE60dw3vOYYekpaKUlBrZd2C+PEitf+YvS5Gifbap6vdT
	/5LZAReUGrfKZWZoGPPL43QEPbOtY/lZznirjGs7e4TzCvzUV9kPDtkMl3Cil6yuqjSFTU9kOBn
	FmeuQg4OT3Me89rkjRI8kDl14dvy6pYOwLYbomjrGQoNEtYGkn9TjRb1YQVkP
X-Received: by 2002:a05:690c:9c02:b0:8b2:bb94:8cb2 with SMTP id
 00721157ae682-8b5204ac257mr21219207b3.35.1795210853469; Fri, 20 Nov 2026
 13:40:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com> <e4c0fcf1-b70e-4d22-9c4a-5829e1438ce5@kernel.org>
In-Reply-To: <e4c0fcf1-b70e-4d22-9c4a-5829e1438ce5@kernel.org>
From: Fnu Samridh <samridh@modal.com>
Date: Fri, 20 Nov 2026 16:40:42 -0500
X-Gm-Features: Aa3M54rPyk2mfbXoTl6Y5BgeHrItQVBO1R-NrW2iTa9bd2JmExDRcSiUYRlPG1w
Message-ID: <CAKyepcSuZ49Nv2D3UGC++-niYtfMcPEE7sjAf2SSRx4KAy1oGA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem: avoid zeroing new folios twice with init_on_alloc=1
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C704AC0005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: pmoc7scff4jtopn4hufppc8z8ctmjxbf
X-Rspam-User:
X-HE-Tag: 1795210854-364995
X-HE-Meta: U2FsdGVkX18Wc8dk5uHRzxwjon6BOZbh500TRvKFWhV68P684ybPOy8AZ3GQHzciA5QQw+J/q6/R4rlYfQkpBEMrFOuJ9g0zDQ3UQFacmBsw3IsFwvCxqqqzGK+FJ/50U8blsydfhmFSodHd9aJN+uR/1r/PIYFSogVGYvXW3eB6UvEagQ+8lU5a969vo4xvWDWjBp6prSAcPL19sigTwLXz3N9mLn89SVUNvuuzpxyfTVYV+G/lzjrfWnVHV5gZvyvSiwPS2Wp3o1HIbPuIAstRX/k5dvst+/da9UwMZTgP2j8WzGBvdY3PVOSGGrh//OLa7sO1gDt+nuulhi72DL98I1pe/x3CoZrifxN6CC4ZMqGyg4QS03OKbD8Mc/mx7aaBzGDBBv9h+b4HnB5gW5Pa4Lq/ETkTv9ChjlJNtxM4jpO7KfX1EzdV9QxkTYOUbYIwgHDa1ABiP5tRuhKZJZagWUPrTFg4ONfxJGfVAUNBkqJ3twoolFJzdvsN8umuQuxhJLq1r6G1dATdNBdDvANXPbKU1h+5K+qLqaWSjBP8cBgFTys4MN5ch5GXGv57+/lkSHW96zq9iz0vF4A6qllq38ZjohbZ1bXI79RA7WzioNdqJvcV8GtmY6ZXPCSJyU71OBTZ2sZzefQd/dQc/003QIEzs1R3PVjvEmDAw2P0lB7ZaLU6uhPH2mAfD9X84J1jzvGOiqliGuSOckLJFYWBVHEvILoIL5adq5WaMRxFZ9i3ieSfDfizCXER5EKzSoU0P1v0wgsERNFrS3YJjI2JJw5YdV9vD7HbP24ZxpY4T0xaCucOt9jq7NL9YA2veFEy1BXkRahQ0RUpq2WQwNkE24M/T/+STEczLfykvtyj7NJyUKM9hXde18dHUdragn7l2tAqH7VGMmnrRXfUCB7q67K7DIkSESKTqmN1+2YgXTcqyh6IpDiZ0/bz9UccytoztGVe44b6UuUa8da
 HYKUsGPl
 0DJ/4fCtWJegCrOCofaS6coeTWlEsyEEA5UJjJdUB8fAtiiO58uRtn2WQ3Lda7Wc4oeDQHV42Yh8uFMuwfkwRtGsVEdRqffNP5mFzOiKN8dEwxbrnDP5xffYqg9NMXcMGvUNiQ2Gg/2uDJ8JB+1zDtzmH4c8uhrZO6tNB35Pq2UKT5gPi9Eq3qdLffWfDnm7W6VqEwA5b2+qBbP18/cNHbXII0cZgC2dNX4aGMXqYC9rjzOxXNrMemBXvrXwKrcNH5QTawtY5nVGkSLve7b5YBrY/FUQ1lQlSipRmvxYJpJjjHGfSyRElsvZNB6br0OGId9WDZ340P2EbSS17/H+RJBt2M1gZmQH56zHPDjqAIIkyyZIvezgyB8Mbc8kwbcJQt4G+XnLLzkCN6Q9bPJbFUr5TF4A4YjBF/a2cRF8Lq/DYmNloLAFHM74xsX2FZ6Kg9YgjICqpWKMKwjVrIKMx1dErYHoYnbMcPCJePZ9Mkp6A8ovPqJnp8qjb0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 18:06, David Hildenbrand (Arm) wrote:
> I do wonder whether that could go into the loop, because I faintly remember that
> user_alloc_needs_zeroing() is disabled when CPUs have dcache aliasing.

Yep, it always returns true on CPUs with dcache or icache aliasing, so
the flush only matters when we clear. I'll move it into the if block in v3.
Thanks!

