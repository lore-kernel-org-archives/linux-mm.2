Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB83FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 10:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5994B6B008A; Sun, 26 Apr 2026 06:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522D96B008C; Sun, 26 Apr 2026 06:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4113A6B0092; Sun, 26 Apr 2026 06:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3283A6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:49:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DABBD1B89BC
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:49:43 +0000 (UTC)
X-FDA: 84700386246.14.9869E84
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5D63160008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:49:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R4XXpPgC;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777200582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep7scWKVDqquDfjlRMHGlmqZl4NIrLMdEyZJu2mgSNY=;
	b=6zAeKUZm0uXOtrz+XGwbdtuGaBal9VdwHIqYj8xSmtDehfkP+5tWI9yCqr/1aLaTrooTNa
	ebcrAeZc9NnhvSxYPoy5I36BnIMd7uuKvhxBZ42bm01UyCEWjN5jC1TXBT+P6PXE4grfJj
	MThU8sBn8lbvxYYJs6z3m2zembPRtEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777200582; a=rsa-sha256;
	cv=none;
	b=TsNEm98hZOtULAPpJG7am4FOsS8u6Ae9g6acfy2x+IdYEU2cqCTBeUZ4OhjUnbHED30eFn
	RPLhgF73mghs/n16eKIYs71FBgP/4NRdQlABgad0AzY8Moj+rgV/5w9desW1K3tiwcXNI7
	Jo0bE167192zKLswFxuJd9A5tNYx1Jg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R4XXpPgC;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891cd41959so74775315e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 03:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777200580; x=1777805380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep7scWKVDqquDfjlRMHGlmqZl4NIrLMdEyZJu2mgSNY=;
        b=R4XXpPgC0CxIgdIo+mxidleHLFcENjFGBP38Q1mmOq1dMSSvO0n0pnT8y2XL25cP/m
         2NIesRPKT/vg+JX45IrYam1MaUEoT1uuiY51X+e7uf9MTg7FAb0nHX5hIpBmuNf72eVC
         9MMIY6SdJDR9zXTsQeAT0tAcqP7L2LNcKZc5DMeoYgiK9wrypI9u8Sz0E0sBmyMhvTDA
         Z+WC8CcUMZHtGiXwRCLZgVLzqTJYEeL7Ksiu0nW5UMlK8xpVkcKy40I9xeQbbJpS1iAV
         f0BxRqlVCSjpSeePOn8Sz3F8lnyp5DN5CBzcT+WtSreZul3DQAIImPqqFKEN3Znza+cB
         dTsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777200580; x=1777805380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ep7scWKVDqquDfjlRMHGlmqZl4NIrLMdEyZJu2mgSNY=;
        b=JXwx0BUlAZXYY1OuaV8mR12vsz9SVArTpJZRBqt+ldMXi/tF0V2vu4ujE1cfRhz7FX
         2IIP8+XL44D++/HZJnhw2/Ra8HG3Wj+D5JhUOp7eydliE8930Qk5SESvJOs0fg3fC4cf
         1dQgr292hHiV5/L08jrulU+KLl4/yCwIjpllYAD5poS5Hjxjf4AiqsMkmynhL4oyCodJ
         OamdUBmDobYG5qeHCXwb1GxpDD3cMwlc8wRJCZEA/OXDMCTEyIU4MgUE6gq+rp916G6e
         26v0WTNtTrYQwdQUcppmoMv8v/1a5sV1FI5p9Sde4aesN7XlQivwWMJuAoKcpfix4E/3
         s+1g==
X-Forwarded-Encrypted: i=1; AFNElJ8ifT+pB7/yP9bRxO9fU9Z92wrDG8uQ57EkxlkLgJj7FtP3R91M/g0s8Bykh88bCf/nROtVJTeYdQ==@kvack.org
X-Gm-Message-State: AOJu0YzpJuTQcxFZ9hJrvAYRWMVkOaN/5bBuWBgH8AFzaJW7Jmjk5WDX
	B3zseEmpCPHLGwX7EQVKbzVIUPLvs79pISeGRM0KUfQyO5oZQUtSxzD9
X-Gm-Gg: AeBDievjEMXyi4zu52hayHTEdcX3jloSt1eEFHaEoekuOe7YzG70BhHa/920aYglAM3
	ZDCSThSFDiJGG3NMojb1nnY7JfM4cOklxOcmLCEqU1OtJVyg0knT6tLwlpplCv4090rBWQiYAXS
	IYOfq+s+EiEa6W+ognqtphweruEAeRjE27EmnFkHBpbXRTP3UnjqluA2McUDJzgTWZi7aw//HRC
	5RZeNG0iy6wnMK79vzFk3XA8fkY0eyb2WeUodL7SoiI51UwA8AXqOlNmOZACEOGnoll4SLvqsiJ
	8X60hi+2E6FUyduE/EgIZPVdKwlmL5DXrZFR68tMy0UT5SNo2dyfKOR3vAyPejh1ZL1yBhqzUb9
	UiMJzC1H54dgcT2chSvzMzvDZhCg+gl8KlLyZSMfLoqoS86Nl+fibtN1KfvWlLlb19DYxzvbtY6
	C3VUm1ory9lNcUaltvlTrlmb89SImI1G0w3u/E5T4a/cH0JpLzOe21Ao7QPXFnlJ+fT679l5aeQ
	E0=
X-Received: by 2002:a05:600c:154e:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-488fb74fc02mr518917135e9.10.1777200579989;
        Sun, 26 Apr 2026 03:49:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1393f5sm666871765e9.9.2026.04.26.03.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 03:49:39 -0700 (PDT)
Date: Sun, 26 Apr 2026 11:49:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-ID: <20260426114938.4dff28c8@pumpkin>
In-Reply-To: <20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
	<20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5D63160008
X-Stat-Signature: sz6iy75uyx397xrn5d4y9q4h6f7krkc8
X-Rspam-User: 
X-HE-Tag: 1777200581-548396
X-HE-Meta: U2FsdGVkX184LgVR6mZRoczfTx09GGU5lqmovmToAAZffi0JuV5/T+D8QcM9aPMb1IVVUKfRvmMkoY/J/ObZYE5XA+zSyvC1oRFbUAS2asVqOezsbFPeCCI1aAGKYNwf8fTYgQFtZMagCXxzG30unBe/0Pt7oJZfTHR3riiJ0FAZD0N4JcQ3gKFPh+5GUq5YPdd92lDNEjkuwgr4AoPrIqyn/mg8fcV0koosYx7cU8g8oc6R4FR5M06qyL9gu109LLViimHf5b/HMnSLZad83B35X63TXR32ajBaWQnh3emeSyrDU7R+sItjW14fterWf+RR3qDvUtDzoMlTcgEySTdY02eptEhS0oAku7tuuiGzD9RKP6Z34quF7ZMIugUgUcNBf++lOCeDwWokSVTPI2D7PbayLhUVrD2CKbDb1XCzVIVZGwGXOJlE9ew7QL/MIL2OreeWV+W5B2g3VC0N9BlRXlD3Qelc4WJHy9+Ikh1pX1JsfoxVqJjENEZGJq3RlSorSvWNn2vJwxaLlghPheTpRNSzWZdWtGSpElZcrHhNMK36FTgZey17s9hlCm4eY0hWG/SBQb+mXmAYf7Y9RfHyV5Wii+SuYWBQuh+DTTot85oBFfESXufjNuAONvu7106fQMx42NBDb8rxIFAru9sTUiXUbZKgdowoQNW1PnnrZ26JdnML8flM0AugqQoF7PCNSe0eTyENZoDCSeIu45yVli1ZEi7l89d3ajm9qOjRgJgCL2LlNvDAfxiNs/C5S+ji+IU1i5JbGrsDfeml/UM1DgOY7Xe+hDnjKWT8YSXPxJOD+OL1+wc1TeF5zD7Kj8x33RpbEVcU2HFljGeJPqGkwiRIR0WWqSFRDBMxuL8Z6fGrzCRJVAO9JjnBY36EcXiYwrpIh8Rh/66HNaqFQzuApRV2ZO+NIFXuEaomS7gvN+TEg0CQFfK5y+qYIl+x5eoqem4kmr2IZzAQBZW
 uwV7E/mB
 fby/JM3ubsa2/Qo6YQMxJdz61QRdQkQ4i8YBxgHj5+N9mRdcGTFGH4EN7KUGLZDx3ELAzDt2H4tkJsmE97dxGseifhWECadXK6QtXfuACzh2qE+yxqwItHGn97rwrHbOHcIDWRJYQhUkujvXCsWh5Gl+gtpCkmjDrJt/z6aNb8G865ywOzswao5RGcgEcBBMerYr6UTJ72QwCB4s8oz/EO9QuSpbgxWrrmaeXMkugFrQJ7FWsnpUNy1gT3cBu/5dDJ7VUffFcDyElYDKsd5qlRzCmiOeOC4ruJY+gDo5aNDr7++q2FIKhV2snQvsdMLIxFR9GZ5FdBuQCOMV/fwz4dIyXMEV+v1/3TBd+m6FEyX8E1syvZgCwCV4NzytNIxnCAYwtimWwtj88OMSvhc3qaBJTwtQCtgVZjU4DUPIuMWKDDS3YGoENXOxj+CVjzrNb8GB5bL0t9wCaM9V9nBWeWHuBTuGcEAZsuF3aHjtdr3gg2awD3COAAM9VhlyKX6o7fmzJc5NRFvIljuNfFMAw9CSp3271186uQDS2hl5TfR1yR/tXy32JVD4zOzXUIa/zIL6D0VfYvEYMl86GHpZOTbbylB/ZGp9rGDuXGn0EPBxATpfZzMkXoMlGe0GxI/0W5uVJkG/er6WOa/BsPPwG0EZLMo+lANJtKpZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 15:12:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 25 Apr 2026 23:01:34 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> 
> > > > The real problem with this define is that both idx and phys are
> > > > expanded twice.    
> > > 
> > > The real problem with this define is that it's a define.  Why oh why do
> > > we keep doing this to ourselves?  
> > 
> > Sometimes #defines generate better code because they are expanded earlier,
> > and sometimes you want type-agnostic 'functions'.
> > But neither is true here.
> > 
> > But I think I'd go for 'always_inline'.
> > Sometimes the compilers make silly decisions.  
> 
> Gee, if `static inline' misbehaves then we have big problems!
> 
> What's special about the fixmap code anyway?  It's not exactly
> fastpath.  Perhaps this stuff can simply be uninlined.

Some of the inlines are trivial - just adding an extra parameter.
But this set would be simpler if the last function
(__native_set_fixmap() for x86) returned (address & ~PAGE_MASK)

> 
> Pet peeves:
> 
> We use too many macros.

Indeed, I get fed up of looking things up to find they are trivial.
Some of the 'helpers' do nothing for core readability.
Even things like BIT() can have unexpected consequences.

Not to say I haven't got the pre-processor to do odd things in the past.
But it is usually trying to avoid having to keep multiple definitions
aligned with each other.

> We inline too much stuff.

True - don't look at what strlcpy() can generate.
The inline code should just get the constants from the compiler and
then call the appropriate function.

As does the compiler.
pixpaper_panel_hw_init() repeatedly calls two static functions that
contain sleeps. They all get inlined bloating the code size and
exploding the stack when clang separately allocates all the buffers
in the called functions.

	David



