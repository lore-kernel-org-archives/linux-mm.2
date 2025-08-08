Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1B3C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 10:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4656B0088; Fri,  8 Aug 2025 06:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4FA6B0089; Fri,  8 Aug 2025 06:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993CC6B008A; Fri,  8 Aug 2025 06:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88CE56B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:08:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E095BF20A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:08:50 +0000 (UTC)
X-FDA: 83753166420.07.543AB17
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51935180010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:08:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KymHwhOn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754647728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbxY0Jg1r6x7C+hh+rgf9m7gK/9hiurboFkbpVtd5c0=;
	b=fCBkB8nI1nnanLtBRAx/i7+Z2iOiL0+XFG3IzXkSfM/XGFSttcU6OJRFN0Uim7NugID+RG
	EvzjX5S+HnV6gjDqDRUQRwlVf3Tcupapl/v5dcBgQxw3yuj7DCtme8YYH/2nko34doBBO8
	BR+Q3XmEOirgr1Bp1PDRrgr+bBtfZHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754647728; a=rsa-sha256;
	cv=none;
	b=DknmSwSYQQKWq1B6lUiSH/lDv+VRFO63QT2qiNeLO8tIlGGr4NDRbzkZWjlAUFklywQsy2
	k9cjv7HfIHx2gm6N/roqzOThDspJg8AXzuGfYhOU9hKGjl10hQcMnuYTRKZ5KEkopBidM3
	L2qjYKJPeQ4d6s/YRirqEaL0YRjFz2s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KymHwhOn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55b797ad392so2311956e87.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 03:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754647726; x=1755252526; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gbxY0Jg1r6x7C+hh+rgf9m7gK/9hiurboFkbpVtd5c0=;
        b=KymHwhOnp6JR0PxUpuqvriEMOdC0WGFGToolCEvmN1jjPrOVHNS08SHc7/4kvjFRNA
         oIPzpfU+xnOCDgSltIg2pEFP9wPterl0M5GXwo1lZdlvjOHPExOrUAmCMDbl4AhtzzFC
         LOJmtmC8ZGqQCC1CABbQXsx6VoBkNgQikpov1HSZ6OI6ZaC1KpXiwG6bdvS9KaXkuMqK
         u88A/xa9MorqBVuXVB4mu9gC1Bv3HfMPBExwGFGqcVZ/oxaEcV972KG9s7bPs5HGeFlD
         UydA+yaJ+TdNgAU25O7VV4qnCGLyXck0tKAWr/YrD2H6IS09zg2qyOpnWIWiuix1lHWS
         NZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754647726; x=1755252526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbxY0Jg1r6x7C+hh+rgf9m7gK/9hiurboFkbpVtd5c0=;
        b=dpXwBtgT90+QC4DUYGHTavB6qFVwXMvU2KqBeVJ/gP3/mNzSOg7XkGnL6TZXmReN5y
         Qqxdhau1aVDlSCQbMkPNOPjE0HQqDWIoOLhgcEy8esMPYAnXHZp3KP53HyR9oukHDrQY
         MYLUrM0VjOvicX35HoUxc+NBHHWBuJsd7nG2WJcPEGIQr+mZL4RKvDqdFUJgqf6ek5JW
         gQcdc8qFSAiisq2pXDNPYr/QV18Xm6KNjo3YnxGepvvImWADGSh4WBcNDwFLemp4Ndfh
         xM474yWCgHgexuti+fm8YoboHpxcVLToG9Zsc2IkbtPkOYqeuBkhAj3NbnNvKyNrnv0V
         OqFA==
X-Forwarded-Encrypted: i=1; AJvYcCVY1Ogq1tbDf4Jrt8vGsBPzEdUHWU0GNQFqgiDsdyNDpNn+slO2yy1sg8viXakNLaskMKGMtAFs3Q==@kvack.org
X-Gm-Message-State: AOJu0YzzLmQSu36SI8lyQ+EAfQUlakKcOwxOWK4CSRDcnpot1wbGzqWh
	SmL2+tVmioNVzjAQc6Oha5bqEJpCG4kSzJnft0sqlrqhNu4sd1y4OIiV
X-Gm-Gg: ASbGnctAutpq2LMjBoQl60TRAuSnfNn6rTbXDjjvisOREFUV2J0/hjP/gIS1zecXqIR
	VMHiYCURSHVwf5CutZZOTq4Csopuwm1JpnDk7RmzL9DanYWbzPaUK76vpIGZRNHZ/MnZ9LJoL4b
	fndLzbSm5Arz7LnUYaf3qkT0jhXo2yb6wsh1EW93jUAsJS4gdovKPTrSg8k07ZayMqe7SkcErm9
	hkoysjEXGIKgKDW4OifX182xeDXe8MlKUwIO1J0n2MM9RAuLGFXvh3NJUmUVGhefIngNzXXbV5S
	Q4NOnzS6ifnjrbtU9jdanqykZuh+4xKuyUebF/jus+ZqmDpv4JYA90T4hgkfhV0/DMsSbsszQFZ
	kMNkACsVTBW3HLJ6peVVrVE1bcH+dsTJPNmmZgORR25dX2/OoDg==
X-Google-Smtp-Source: AGHT+IER+HryXfx9J3vMYmF3WW1vWe9m9Xz7yhLgRj00Ua6ih0RT29yWBMSZcOV/UCV8juhmCPA/uw==
X-Received: by 2002:a05:6512:2210:b0:55b:861a:d2cb with SMTP id 2adb3069b0e04-55cc00da448mr500044e87.21.1754647726257;
        Fri, 08 Aug 2025 03:08:46 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c98ab8sm2960265e87.79.2025.08.08.03.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 03:08:44 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 12:08:42 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] mm/vmalloc: Remove cond_resched() in
 vm_area_alloc_pages()
Message-ID: <aJXMqrVCcdLBsMGp@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-5-urezki@gmail.com>
 <aJSMfJhBOltRiSUh@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSMfJhBOltRiSUh@tiehlicka>
X-Stat-Signature: jh34our3txqybyja8uj7di378eph1617
X-Rspamd-Queue-Id: 51935180010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754647728-389964
X-HE-Meta: U2FsdGVkX19/oumf611JfC2zW+eoH1BimYAu24CeXBPdi1Dhy+yTahSyyY5KQYpRwKpjNOipEZBnm6EbnU9+pO4dmX8WA8Y0MpKHu/u8rin5DWaGJQTM/px60PhRfWIvEf211SGMIqhFptrMUVs/cEzH/88DzSO5VrYkyHLni3rx5hXNLJrE54fTaG4E51nAMELS9fTQaqpj67aS7klNhgROzWFSRJP4AZR6309z89QGOA4U7sTSXo4LuBgfUF/MdsSfkcaqJwbA/Sz6cHvfnJc6hGVJBgMTqIEia5L9+4/kqBMjXSmTjpzPAE67eIQJH0+pNuQYxoBn4JEujZ+/wm/N0WYUVl5s7d65joQFxzsMG8PPKv+DUmakpzHZaXFtUv8PrU2t1YwUTh3sQywOVAcQErUOhur0SL+yKhdQoC9Zt6r1ASHgSn8njfXkBceru0tZd4RusbJCcEoZwNbgy2wtAxJ/3Emu0xgn/YIrrbQRHr55bxUAGiCukBlOZAAfO41h4N4icBby18QZKl30R+aFbQ9PsH0KYBS+rsT137nhN0MTRe1n7SFzSe5wYH+2M8UJwVmDYJv0VcI5IK7EgcTtwssysJPTA2Dc4DLyTSeUD+DpLHd55yx6QSonHj6pQWiRP1Fi0g43pX8UB8brOFCfOQs+jwOQ8itSXR2b8e1P8Q5QeCtinKkclJRYmCsrXKbUroNAuiQzzFuUgPIVWMaUU3muIkgxQYN3YvnqSwS2RxqwZu0mxZ/jVs8X/RGnSWukl7ieyRfUlURIyIg2n4D1fiHpvtu6QIjNe0Y4LMju6NXDcAqhWyABI9uFqSK8eT99V9pEtEtMHH5xm0YFn2YWOBbTiAxWNn6aHhgQ1kHueuUuT1sFHaEDZoENRRDDJvL+6hUe76LIgoJB/5FYjQAB+KArEs4XH2jlFO+0d3KyKQpiKg/j76kNtRiQCsQ7s7VlNhQ3RtgSrbzhSdV
 QHAApQfi
 sQXBdrFrFeNqKvXj6jV1sG/l5a0W6I0mTXW/RVO0yqVe2+XrJzyJIURQi30QEg+eMRgdoJ6z3j5iUgJ8aeDdsKNVHHjzu9BXNoabuVPgt+62HAmjDxM9ewA1tbUOpBquoRbWorG1IVw4s4ut3i78xG28T8tlDyDaCxlleDnASSVA46dLaSUIonCONuMQrSPUi8PtYVChoHRBdoIA8hYHBi8yPRxN+LLOOuMGWkq5kWOQXppOOia04GqyhcY5nRd2yK1yzVx3Lt0PoRFseQEnMcA5eSWzjlCMWkOBX4kc6k0zgpk6ds7qCqG6pZaZhGEM8CZAXcSQlnBdDCaUs4wTUs5TCB1If81J1ThfVnYgUSclwMJTzs5Cdzd12PEyN4aItaEpO09n2szrwAhmKo0worZlaHrbdv0UjPargTgFwhBEW6p2tFIwtu5+HKlfY29YVuYApDDlX0FhHxicGxlikQa+Fuamd0oI2X3TpPeVGsVC/jldz5EUsuYVAQ7wgZpckDtBxB151STIGp9kRAEK/9Rr54PJYg2i/5hfM9bBUFlxlmiktGPbiG8DnyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:22:36PM +0200, Michal Hocko wrote:
> On Thu 07-08-25 09:58:06, Uladzislau Rezki wrote:
> > The vm_area_alloc_pages() function uses cond_resched() to yield the
> > CPU during potentially long-running loops. However, these loops are
> > not considered long-running under normal conditions.
> 
> To be more precise they can take long if they dive into the page
> allocator but that already involves cond_rescheds where appropriate so
> these are not needed in fact.
> 
> > In non-blocking
> > contexts, calling cond_resched() is inappropriate also.
> > 
> > Remove these calls to ensure correctness for blocking/non-blocking
> > contexts. This also simplifies the code path. In fact, a slow path
> > of page allocator already includes reschedule points to mitigate
> > latency.
> > 
> > This patch was tested for !CONFIG_PREEMPT kernel and with large
> > allocation chunks(~1GB), without triggering any "BUG: soft lockup"
> > warnings.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Thanks!
>
Updated the commit message. Right, it can take long time.

Thank you!

--
Uladzislau Rezki

