Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB9FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9F26B0008; Wed, 27 Aug 2025 11:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75ACC6B000D; Wed, 27 Aug 2025 11:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670CD6B000E; Wed, 27 Aug 2025 11:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 562596B0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:30:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5CA25A791
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:30:31 +0000 (UTC)
X-FDA: 83822924262.12.8A6C8AE
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12DADA0004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:30:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xbgvymuZ;
	spf=pass (imf25.hostedemail.com: domain of 3lCSvaAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lCSvaAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756308630; a=rsa-sha256;
	cv=none;
	b=BPNRORFcjDquTk/+imKMdtorSYVnKpzdhQ0AtJH1DKK5WEhiqIh1rE+c0EsNxeO3nne+7P
	sNjKkZYyFisEkXzgRea8BjdM5z+FS3wH06XA4bRqI/mMGn1Zg9nsg1np/9wigOWCQcvmYt
	SWvVZ3xJReo6ZfpJflhNNcgA88NugOE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xbgvymuZ;
	spf=pass (imf25.hostedemail.com: domain of 3lCSvaAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lCSvaAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756308630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2lcoD1SkCJi8dEvMItuNydCcCeq1NBdI+5d9T3pGQk=;
	b=IM4ouIXCkweEfgeF+j4UeiyXuoOaeuAysak2pXGQVb/wIBd0a0yOP76O6WaZrD1SyjbsYl
	hYwaSGDs+pLBSmMB1lAtpI2dzcsvY9BUN7aNo47Vc09EEDkPGPFf44ekObgbgJECnCV/Zd
	Dz0eXVuwZu4obpRHb+3HaVtlYOYcN9k=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3c79f0a5feaso2692719f8f.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756308628; x=1756913428; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2lcoD1SkCJi8dEvMItuNydCcCeq1NBdI+5d9T3pGQk=;
        b=xbgvymuZUZ9JOv53gXxoOK7fiYwvAWSl7yHRWvE84Z7912LfF5ON0NtW1wWitZgmEq
         0qskKWEmZPRjuD6K0QtB/1WMREIbBrbU8sqgduD+4bE8IYJqLj2VEJSgM7La8RmtxK8y
         EBoNy9WvVtME35RAB6BLAGXmGcAoIpdGaTMrITiuZo5/jBFFdNHWb9TN0jBTDCOj7+sO
         7YlrQOpfrGDCEraxY6GxNcXlPGfz0AUyRpPbhibtlnEj+pEEjFz7LdzhlQKgjseTzjXk
         TWoB4I//YiM+cveBO3wHmFP15ms3XUAmCZF/JnmyWR56v46ONyIFLEQHzVKdznkbB+xY
         PNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756308628; x=1756913428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2lcoD1SkCJi8dEvMItuNydCcCeq1NBdI+5d9T3pGQk=;
        b=TawRwprCA7wr2RRlFlIY8caALfd3dE2Py4B2iQkeSvJxl00Ilj0btX0WYVWfc1xG4s
         WC2gCyDWqdE2FIkkX0fjyh8LM563aUbau3KRLHmoUM1OZG0JIRMiS0NE/S+SkVDvkjPY
         67rtsIqvTNapFec+NLT4NRvlGaeg6izSTw/BVyhML6VdcllmVjEjDCXD18AC0SvlN4Nz
         +90wRteHnqdUWox+gxlAAxpdKhgev9WQhzr+ZroW6ztRss00rHRDypTfJsBZ9nGyRjo6
         ZQW17VhrfPSe9XI3n07fZFFq36g2SYo8jM+0tojy7bGyNWT5ttQ6Bl+vpcKcKWgSTgAo
         gmNA==
X-Forwarded-Encrypted: i=1; AJvYcCV7s/AO7Ez/2/Gk3uo5u/G7rpDkj0Vn+8Lo3MXgQpDnzjNDSHkvS1qFbRG5Yv93/4/OFWU3IDGXFw==@kvack.org
X-Gm-Message-State: AOJu0YzTv/549B28K8kVkObU33oTwJoXX4tH4DDvHhU8a6i33DPkD5hX
	/QJuAArKjI081ZphdRp7l84yuttucy9dVbEVXEnheMp7p9li7nMXjnGI1XnueOncD5XXi2yRV7E
	H3dUnXzkgJZ3Yeg==
X-Google-Smtp-Source: AGHT+IEvXocNCcysmhKTOTVqBVS/7zQEmjrI1mwpeLDOcAO5bM1y/TcdWjOA2UfYgroW31bB46gdDNVFr0ea3Q==
X-Received: from wmte19.prod.google.com ([2002:a05:600c:8b33:b0:45b:73cf:2862])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1994:b0:45b:7185:9e4 with SMTP id 5b1f17b1804b1-45b71850b8cmr27223015e9.11.1756308628229;
 Wed, 27 Aug 2025 08:30:28 -0700 (PDT)
Date: Wed, 27 Aug 2025 15:30:27 +0000
In-Reply-To: <20250826191320.d5aa551eb5abef316de41175@linux-foundation.org>
Mime-Version: 1.0
References: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
 <20250826191320.d5aa551eb5abef316de41175@linux-foundation.org>
X-Mailer: aerc 0.20.1
Message-ID: <DCDBG4WR1ZDF.23COVR1IO2OSJ@google.com>
Subject: Re: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12DADA0004
X-Stat-Signature: 87gye4u4idzzz8y88erb5ymyewaeok3c
X-Rspam-User: 
X-HE-Tag: 1756308629-60682
X-HE-Meta: U2FsdGVkX1+OgWYhRdN1CZ++XOTRLprZEX+KUNYC5QK9G7yleusGgHOxuHJz0eQeTI3AydupECogQ3T/aql1Mh+dCAkI+WHSOdcpHK7N6i9Zh8qPsv1tI8YHhcYhwyBG1KYsi1lzHr8eHZ4hZRamuvZ0N6XhbXMKMVkfntLNKHuLFngvj6w/Yvtg9SIvHFURLy/KiloOFn9BMIozdLuQ8FuOCyPeaV0gJ7deAfbEBWHJXITil/2t9Olks5bQarGURnmwyPmQuJA0bHMs2Iycsfg6Khe4xP8jmaBUoApJv9KlRykWL4HX19Bu9A1tFDb8uUq/Bi7TggNcaCiabskc/CsLu3ipOVt4FYuO4RP/Bmd9EUqmitlwFMdlVQVkHw1UHics3KlO8Mmb6UJ2/wRaUffQY2jZYXvvQX+GfhmF1HyVTbYWwpoWWTKPUXhKzi8ds8PfBnkcmHryPKm1z3RhNT1vD70yanpiSuaz2P9EVxfm1sH4HNtBpH0nRwempdeG/sZaZ3hAK6AThHOCTMC/+eEAVUOqLo+ngZD4NMwqmPMjQr9TVFsBQ1vn9WXNjeaJGZquuTHZe5EqS92/fl3chNhOx0MNucqbUVrYkRVYcAHqYc401kLRdGhRiV+x/hm/beNABA8uSLAipE37E3Lqb2/nmQsIOWQ65yTEYJSiQEjTc4McEFayp9ZxfGtkxwBk5vbDB2kyodtEAaaZFj3gUsqqugV1mkkoLBYBQCqCwE8kY5MaJlK4907dLsLNKWa/79yrpLYTAS1suA3zK3tp5SeYAylWknzM93N5Uki6d77Y2C6j+aiVyzMoKdUKm6+TOSMvyPlKfWirGvWKAOrGyDMT/FajN7HaLb4QrA27aHjJqwcWEKKY/LytgCJUwoqxg2yQ7IyxUQXkCOaAwGqb1h1v2yIHIK9RgsY7PFbdjpEyZt3NgDvm1Wd2p0xCxa+3rdepvwy/WTMx4WGIJ0a
 DHR9pepw
 cJr6ootE16yEpX0/4obPWrx37/zkHe2J4zSNMMdxkOa3P752kbyDmWdnn8YJCPV1LjRGTqQ31cDtSg536a/hCHqoZeyCT3f0V2Wigait96TgSKDaNR3RUEGZ7sX2lYPQEyVsyh+khfm0qOEmi3XhtEhgiSXwwta0rExY5E036wSl+t5Y62rhB9V1vA6dmddmr4kRY/E3joU298ZAJa1eoGGnMRNmEOZKWVC2O8CU9adGWJAiDI4kLE7HDSoEB8xXHwc8MKCj4b4iG9nEkKRaiZcc0AejAHnBoKXNAfOcjnZU4vW98oxxBe9+mcfS2lrArpncyUXWh23bksJvOLZZTPkKYjlMbrs6+OG/XcZMitVrlxlTcEPFhcRXQhvlPgvyyPns1NxXf8clMYRQApbieZoq+HlfW3Sdinh30DROfGjgu18orxaJCUqWaEAsWWaTSUKeKZqqBjd/LF8Y8bc8gXO7dRwWSNha9HenG5Px510MKdeXtjmJzzCK/mZIyjDGqMyzhPcJtV1Aa07g3CSD0riPPnD1v4mtFbTP7GOYySL8yhNl+YWvClxP9MQLbKs+B1ZwrwOL4TKoLMALUCISZB/8v6pK+R2e6diib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 27, 2025 at 2:13 AM UTC, Andrew Morton wrote:
> On Tue, 26 Aug 2025 14:06:54 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>
>> Currently order is signed in one version of the function and unsigned in
>> the other. Tidy that up.
>> 
>> In page_alloc.c, order is unsigned in the vast majority of cases. But,
>> there is a cluster of exceptions in compaction-related code (probably
>> stemming from the fact that compact_control.order is signed). So, prefer
>> local consistency and make this one signed too.
>> 
>
> grumble, pet peeve.  Negative orders make no sense.  Can we make
> cc->order unsigned in order (heh) to make everything nice?

I think we can't "just" do that:

/*
 * order == -1 is expected when compacting proactively via
 * 1. /proc/sys/vm/compact_memory
 * 2. /sys/devices/system/node/nodex/compact
 * 3. /proc/sys/vm/compaction_proactiveness
 */
static inline bool is_via_compact_memory(int order)
{
	return order == -1;
}

