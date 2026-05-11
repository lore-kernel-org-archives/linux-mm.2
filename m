Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CBBCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017FC6B00B3; Mon, 11 May 2026 12:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AC16B00C5; Mon, 11 May 2026 12:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21416B00D7; Mon, 11 May 2026 12:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB3DE6B00B3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:44:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7868840211
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:34 +0000 (UTC)
X-FDA: 84755712468.03.EC89BC1
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id B376640009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d4sOght+;
	spf=pass (imf27.hostedemail.com: domain of 3bgcCaggKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3bgcCaggKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYYpDcSirXgCNmEkzMsYIoKA89hgjHIiu2Up3FGEf00=;
	b=YxnK6cFxDGle/6wmI7E3QCbGEnULXJF+S4N8w2vGnGNIFrmCvnsgbDimXhddQflfOsZZFb
	qBc8pGFpNB/ayTt6tjPGV7E0iy9HCdoh5xy/yS76gFieLNLFoyvb/ptO5t0Dd9ZNG4AEID
	kvjZiz+1/hrmnu5VrEgDdOVsI4yCVOY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d4sOght+;
	spf=pass (imf27.hostedemail.com: domain of 3bgcCaggKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3bgcCaggKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517872; a=rsa-sha256;
	cv=none;
	b=VFoIv7PEr3/9Fe3n4xdXDvrvBrRAtp/gNUTE2QdVTNktDil5IhNsxK6e6FG+KT9+EJrn1h
	JKM6jnvF498HyEhCujAfHS535iv65+EE1LrUKHylAX37m7YyiSqRQRheSdqEp4bHVtFu5o
	dx27tod4umU6qgye/XorwjiZMkpu34A=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso4305448f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778517871; x=1779122671; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYYpDcSirXgCNmEkzMsYIoKA89hgjHIiu2Up3FGEf00=;
        b=d4sOght+3EkopKZFmVgmxaS6sPQ1oWLvmZ35I0omlgzNR/cugCJm86Y8RTdR9hvEfL
         zHacFzkT+dSzVoCUVndVRXJQFfpyZfDQ5sZuUyhvSS9/UpXnO9iPoHLPj0JFuWlAzfrr
         nZEekvZgvWD2QxgGOucWi3urMOxyh3HE8NaMwP0QjQl3gjOpvmW6kLh+UBaC/e6NaK31
         lkrCNl7mA79J6KJgjkWfDCVUomFZe2hqHOMNkilCnFT4T2yFYf9KhUhNYsCSDh2NT4us
         yj5KMWvENQChTYTW5Ndla4f15CH+10rlNvic7GxUy7HB5Ccw/Il4gDB0T3KEQ9c7h8qv
         Sl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778517871; x=1779122671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYYpDcSirXgCNmEkzMsYIoKA89hgjHIiu2Up3FGEf00=;
        b=HsC12eBdkBHtNpKZEB2rbc2fRHzY/Q9o0M6L310zmaVCt1pl/eWEZONMwSKv+uNJXG
         H+Gp9rX5eGOvFMrAHv8ors0ucfVyYoLfaWhmfidLvgitJT2mzv3GC/204u5oeSJqp4DK
         KECt3fSnxNwuo8fxHB3VXPUf5cBKO0MtJSvzO/UeA5THxFCqfzcc/E8vbszXdWfRg3n+
         AxTcbuKHFQB4OMvu/rOmMfaiDQ5uBd/twsZS9dOHTT/E520ojv2YNPr0exaSzZYY+pKT
         t76NOY7P8rF6UXORvsQt2AlnZghLwL3sjUSRXhA7dIC4YUSR2Wl+Xk+9NOkUlmMpQ+R0
         n6Vg==
X-Gm-Message-State: AOJu0YyPZrzZLeHI/aIJpqrHhlM4D9tvRxggc3/ewiSMS+4uxm2MlLr8
	HTJFXIlxYST+tkd/bZXHZr/i8CeIxpPho3NRZvdgny9GEnyohBKYQ2O6SDNFgVYLBVtFWu9wQV8
	xI69dMMh20CXy1Q==
X-Received: from wmoj17.prod.google.com ([2002:a05:600c:4851:b0:488:af7f:772a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c6:b0:486:ff92:63e5 with SMTP id 5b1f17b1804b1-48e706acf88mr170579405e9.6.1778517870440;
 Mon, 11 May 2026 09:44:30 -0700 (PDT)
Date: Mon, 11 May 2026 16:44:29 +0000
In-Reply-To: <f7ead2e2-69b5-48ae-8f85-f875765c84c9@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com> <f7ead2e2-69b5-48ae-8f85-f875765c84c9@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIFZYTWTSO6F.3IOKEDZ30FINL@google.com>
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in find_suitable_fallback()
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tx1csdf1z4gnxmdgnmzh3wfaqa3ttzfj
X-Rspamd-Queue-Id: B376640009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517872-151627
X-HE-Meta: U2FsdGVkX1+2j2IP9ITlgdnm4CIjWSqJBmGb6ebKxZtQDjTaNojAYunBWguEcTe26G2CddcHK0+HUez3bSIPKfqherwc1g2qh8eKx9KnYlje9ihu7nTluEbxrwrOgEgvWozIE2KM3ok8QE7YvNRyfY8xI5uLKvi2/PEFcV5btek+fYzSdMWDaufwypr71vasBEwVoGCi+h0qOvuxkIkmZ1U7KFfMTqZGjE8JbUqFBlajnujJbpymsCAGE6Y2DsKPSQJovpE6kpdq+tn+K/VuTcnFfiDWiWsOdfeCISZupl8lyfxbaVRsRlJFUBQ81Vtf1POzY3eTc5sE8kJosfb/lirBOo5UzNJujCUvhXYCUbP+4ER39UV/q/4BHwiybWvcd/6jW5rPynFn1I+R8H7TprErYL8p+BbkrMlTpVAWixbJkcM6pjleoLxOTq/2wkvW3Y5OkV7ZJU/vWSpfBTJROXHJkEiEFzQzr+et49I4P+qFpkOrh82sKZRqHgN2HusMf9rVmbwjTXb4M6LHO6QVjFS4gfQk2sJAtJYNfX01C4fBv8XbalkbaCHi9jywAO/dktZ/XlXwkdx6JbN2S7xa59LkRis3NS75fIyaLdvvxUrHSOO+UQAm1jZ6vLWdYhxUxNMdXAvm7FE6YMSiTlWsB0yX5u6DII6wuF4c0IW5eQLgGHo8NVSaauj9rfd/Umtq5ml4OK10DUeLFn8gp+/nPXwax7wqqSTDT5aR3q2S0I7tEHZG7OipoN4HWCJINQDs4ebht7bosM/PIl08r8WzhBkhxJvIL0AsLwWDfqF3R3zEA48oQrqFQAdDLXc6c2pClaFZatdeDSNqHpa5X0MKYhyF6GpxYcrT3J9MBDRd8W81I13JWKnw4i4pNpr0jrX9m94SzYLjlOibbkOPOiYZh2WZsA5c+mAHw0LX+Fz1AzilnhF0lnMH7YcQ2JkssQCSuNyJ8FMFArr8ItZMcxt
 XKquDuFU
 YTyyxCchWCijMKZolmdbkTOsL/ZNf4o4Of/nZgdv6MDrvV/MUIpeqG+V0Cf7Pzr6gbTprWJY5q1Ri9nwZ0noRYXX4VgAi9XumK2nCpslzX5pdwlfP3PdrQWeY6WD9tqEZ8/Tzb99YtGDKdKsHTE8XZD0qCmz44T7gkowKnB2nqLtrRtE5vGkmfymwV8Y7b9xdhO3qvIDm3Lga7u+IVLPgdTEeOpGnrewQ17AsjOvEuBSjHmeL9+cdWksTRilUo2tIrKkp+fmftMXS4qCTUuPB0xCFOftMjrKurDIl37HNF5cubs6/K7kir6HJrQhn0fypRXdEy93UgGTAydYkPfOiUyPZgPKMLn1u2/N7wxjH2Ia6JpbiXfwRh4THzGyZggGAOSy+qOkICrGKNn4FYp4MIabSFlkaxac0TUz9sUjcy3Lq6nRbm9HHxKzNUeOHWD1VOKMa+G4TaMfN6VQ+OUYvXzpwHrcCd43tmn+TsCPsi1GeAFW3xm6jY/kg/kIYnWgV3VbaKwuk+8ihtg+jfeBRLrdsrYUHZqjb4kNcWBCipaMUHKd+FV55S9nJwVnuKqlKi2xOzcDp3djdaJWKOG/EIiBKmKyHlk6DRIR7NQjw0mcdWCtOCDfiWftEdOwj5kMmVTlp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 11, 2026 at 1:51 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 19:23, Brendan Jackman wrote:
>> This function currently returns a signed integer that encodes status
>> in-band, as negative numbers, along with a migratetype.
>> 
>> This function is about to be updated to a mode where this in-band
>> signaling no longer makes sense. Therefore, switch to a more
>> explicit/verbose style that encodes the status and migratetype
>> separately.
>> 
>> In the spirit of making things more explicit, also create an enum to
>> avoid using magic integer literals with special meanings. This enables
>> documenting the values at their definition instead of in one of the
>> callers.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks,

This and the prior patch could arguably just be considered independent
cleanups, shall I send them on their own?

Equally if they feel like "churn" I'm happy to keep them in this
patchset.

