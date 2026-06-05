Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40A7CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51E26B0005; Fri,  5 Jun 2026 12:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBFE6B008C; Fri,  5 Jun 2026 12:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3136B0093; Fri,  5 Jun 2026 12:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5C1C6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:35:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DFAD1401C4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:35:12 +0000 (UTC)
X-FDA: 84846408864.19.B271207
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B49912000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:35:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jf4e3R/o";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780677310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fq86Giqz4sRTswuw2Pr3zOZSxkSZOaMq8XWUrepitc0=;
	b=v4TqOQLlc0N1wq3jJXCaAX0LYEUugyoNQUqMkiFD+uRo7R3pLbg3BWqhjrUAaJEr6mxixP
	jyOkBlCNu+9oj9uneYNEjDi6ARqnBQUkRTQ/3Uz/eHNfNC9EGoVtced4zn0sobdYEq1niu
	nlLM00GHE292QXaeXcZZUJ7ujmojPM0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jf4e3R/o";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780677310;
	b=dd8Z8ZLOBgxVIxDM/ruwB4wbFfZDnaeK08UtNbAXOW7WKUhYTbcUh2uuDZl0SBeCre+kzW
	KnSdmg0fm9Ej+D7iROGUBBw6wWYVIpEsiuCe7Gc6SOFqu+36NOHgbCgtfLwvnDN995QaBD
	yp8K1BNw1M35UqzbgBaAdzj6w8sBnbo=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b7866869so25435715e9.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780677309; cv=none;
        d=google.com; s=arc-20240605;
        b=NEMDqkUz5UQhr3LZ2DLcngVgiA5XTajsco1xv3bQguuoCXv58SyR4o6pCjoT/qYqok
         px+cAAvxutK7bMVxJMnjIgV7tOGiNlzZMxL4G14osBs2A7aYLEc577pOT7U2HdFNs++g
         L3Zerl+HV/Q7+dzjwmuBtl3NH7/v3UBMYRmmXblF9Xk6WxW8hJa9QmdIvGCBe/L7Nqx9
         mu4l1RknF3z2QYQRDh96nbCvHj1YV6SqNDk0xcy5lenR4c9d411/JxetEAY0WN0fEJwR
         Yek/lps9OqTZlVB+ovyvTsQazoYfWlQxA50FLtFI1Bw2CQ5MvWoq4KsxwzHlgFFuS9FB
         xRLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fq86Giqz4sRTswuw2Pr3zOZSxkSZOaMq8XWUrepitc0=;
        fh=RdvALwV6jbSmNmIM/6XXi0y+ESAFuAquhwVyTU6J7xk=;
        b=W8O2vCqIUzimlfii13CETdpIGAX1Xb/JIU/2YpoUdwq91kfAgnG5UDejhMYztzdJ0x
         ZuNV+0I3IbNyk1Z5gkfbVZmL9FETdkIsBfAziLkFqmYlXvTYw9qd+/4P6WB30HJx8yPt
         J0Cp54eDykbi0bRCX930/3VMQDu3FaufujAIA2qgzmjEmO0c+rTsIcjYLXESKEkibVFb
         pj8RmRzY0WJPUd20GI/7GsQuC2Xy86m4QoGQ3UmZ4FvaqUY+UVDAvySZZ/hoEGEgrSRD
         1RqF7Y6XsM49bM349YS4M6hLwRoTDHu4oxWi2Kucf9oGvBN/DYVfWO6xcY5Z6HHTb27L
         cMxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780677309; x=1781282109; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fq86Giqz4sRTswuw2Pr3zOZSxkSZOaMq8XWUrepitc0=;
        b=jf4e3R/ojL8Y4ue40X0x/XWh1cVEhl5cmsQs5ZHt8bAD1+y2IP0wCgnRJaAGVqQdqY
         boh44HVPeZxqFK4ejd0v427NnR5TewJUa6d1599I2KVGb2gE/7+n5DNtcFX6Tc3dvSSl
         XGBU6oX8T5za4toMLeLyaTq5Qywh2anOf6aWu9rLRxah5PM98VGULcnATIReCAp0Ked5
         5Ss8sDsoBXCb8w/7QODjUgywZrMh5nOY16zyAm8THtvcnJ+DfIGvpjAG7ALtjKvAbqVG
         LrLQel14lWlFJEKejg0iNgtdA0GDkD5ulKoPwN+9q+dzY/H7dIG4KE162zeFDBhTUH1u
         p4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780677309; x=1781282109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fq86Giqz4sRTswuw2Pr3zOZSxkSZOaMq8XWUrepitc0=;
        b=HoeA1pCY9BsWD/lwPal1VlfOV4JwiYGSF43/9/6UBMl9J1swxZ4Z312DR5vDk2vwfi
         uz0y3t9v7fMfP/n4ddVWqU5HWHWjC1r36g8h5k4ftsEmjvLHpgOm2yyJ/3msFHsdu/1M
         FpqueQVjHniSjgtdgZJpPEMnX4Gh3G+d4tL3pgFv6MF3jfMo6imEwE88s4uDbfvFGUz1
         tDaBfP0B0fwI3sibYXrWqIoVvp9PbDtTGdkcEXvsnoCfIxS+oU0NexJ8ltSU+KJi4B/D
         uHu7Dc8txj306hF+T1fYell3+sNFmrRkdfVzsE3uJtrn1t+o8gL/BjBUxJbt/8bJc4wb
         6J6w==
X-Forwarded-Encrypted: i=1; AFNElJ+aJTRPmvaNVnDH+MJ2SL+8eZzJ9vfyxHE74+9UET6N3n6JRfKKlMzmmLSZf4QhLu92KUdN3GAutw==@kvack.org
X-Gm-Message-State: AOJu0YzU3B9zg5ItsIDz3I+9o6IbuVTZPkuJhhBQZbmJjo/DDT6RKIIb
	r66cyi50LV25bzVzytVa3NzvjFFEh09poaKTquKqsN2ZV02S26F1dessPraKXyRMRtvLB8eXyxb
	aswZ3V1RukNZWXhhbyBfbmQlTYc8pURs=
X-Gm-Gg: Acq92OFOjskGtrQ9jd3y2U+efP8UkoxegWDKxmtqMBbhejSovijayRkAmZW8lehwLDv
	Cjd5K1DhoYOB0FF4R7bSeUCsKmhV2mBXDl5SEeeh314hyyvAFxWxs3NLZgQYNmz2AKXJlgwE1d7
	R7U/zm+mZqWfagwQLks0X5SDeVVgnkXkq4j3axWeh1roFDFztyWIUIEllkJY+4Uea40LX6Tkz4E
	x/FDNtRi8pdnZE9C74UkfrfR5W/k48V76ZcQfgSwXkZObpDrk3zBGDN3vo0TSwivwfn0myDe7uZ
	m7uqfzQs9IEfnJBYnw9gOndM5FANgFVg7iB/3X2rkEfUd+99wg==
X-Received: by 2002:a05:600c:8b83:b0:490:b58b:a8ca with SMTP id
 5b1f17b1804b1-490c263fd08mr74110175e9.27.1780677308558; Fri, 05 Jun 2026
 09:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260605084242.1549811-1-haowenchao22@gmail.com> <20260605084242.1549811-5-haowenchao22@gmail.com>
In-Reply-To: <20260605084242.1549811-5-haowenchao22@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 09:34:56 -0700
X-Gm-Features: AVVi8Cd_BzbKI-kFicZgkjWkgdcITVLzgbqtSi8KNSPAWE77qQD1N7NqENEVLf0
Message-ID: <CAKEwX=NiAwQdJFUErh41+wMvDDtFK2seTXx+bUu5SAAN46gCdw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] mm/zsmalloc: document free_zspage helper variants
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B49912000D
X-Stat-Signature: q4p5qt84nyzkdmh3i9i47rx61zg4sdxr
X-HE-Tag: 1780677310-94650
X-HE-Meta: U2FsdGVkX19cvV3DoWZWl/nmNv2i0pCUeUIfNhQTsiUHdroFUI8w4h8EINTAuWi+kIsN2Jch8KSah7Adqr1aeawOV+X+e8P9IR2ow3odejQmLtdsPgCLGcxLbzpl+kW/YBFYF0lC6imDS9xfWn8APRtRa+R9tRef3SveEnBrPxWzjl6ZCVuDAXGiZr7oEw0J6YTetdxyES3QkqEO8LjsAMmFgT6ptbFLO4eazptnE/Z0IzXKsXbkK8Dr0d3VcDnUx/acJ22Qsr2JTFUsF+ZqkmjKu8+qU7cgcf56vok76ygtztcscwSvtzdUYiAPRjD+iArZjuUA5vvaeBCGqq3UocBzF7dxbUZ2/y6o4GCBf9BDmUTv0NzpqISUANRdCndke/rmpv67z43nRRfi/3+hYEeUIi/nPuTYAYrmvxgIf0W3gFqkJl4d2zVxCykKVH5YoHmpUlCruSLmUca5IHWXyW8v8CWNW3tOrp/ekHh1uN1RMmUPxtsN2HebnpTV3+gS9b9j2GLHGAsw7jZ5G2L1AVGIph8DX1r6lNpQUFxDc8b3+gIBbRUUSktpWSjeZXfsMAODZCCiL1HkPaaK4oM6/djlVdTJ8+jruFS95NY9IdnoNHI/x0HCu61ADLq4RyxorBGypxcpzg0W/6pY1wVVU80haOGWJj5MJD0bfY2kZHWgo+DRsP7o9Qez6IRjlXGiH4hckyn0BKIVZDwm9nd9JVdMt5To71MqR0SfJuEhVKTBtLWNHbDZYWoGilC+dUkaOZfNNXSryRra5RWv5BR7DSZafJxdcRloQSvHTDqyU/oF1HPj20wDieujo7exn+RRFIOx7UkNf4BH54nf2TCaJLg7tzZGQ7ORWNV+aSwSjD42nm1l0nHsWL/hJeR7e6SNzSEB7lobco9wujrelCtWfveoVOMe8uoIRrqocEXLswM63VenKaR21bprwTSMA3zcd1o7n7r97YSYJAtBURe
 af8Qw0zA
 bPKgYaxR0ndXzpNY4ktyqyEv5Z8ZHBriTjEHXei/al/2DrstBmwBzzmqM3cIwrrFSGdWFvdM2G0CXAkNRJCpYHYHwnDQFbSpxnH7oPbmcU2WOciTOJ2D7EhLBs9Fyl9g9ZhemvVlfuKA4x/wXoUB/ig9z4TiGqiDwWjzBXY3k6i4IuYTsKG9pfbcr5TCHEflm+vgJmPYvbY/RqY47v6pJ2sPbkNK/CP5qTJJBHO5PTcsXfPl1CGK73n4nB9wTcJAdt5Y7t5XAm0KjXfqEP0nU321TM3IkzLD1Z+PtE8sKFtaNd8v569tqzEWuPJl6RiiCBbWfsESKEQzrKp4uiCOhxWXCXL3njRyjRkgL4dcJ/e+ljDEJjnt2qqFjpW9VQJh/j9f2JdiOrtxPVbVG7oMYA5mPulKLYkU2svviws8suK1HcFc29aULS6FL2ASFNxGLlNZIcnK4g/cikw592eOdzfsUfvACA9TCNlG+H1pV+CP4TEubaLfJJGfU3ohNotKRedKYMJ8B6DMGR7HQW4nn2SrQftrnacKxMxusavK/A68y8jyXUeoBSeQikn4Eex6PxEr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 1:43=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> From: Wenchao Hao <haowenchao@xiaomi.com>
>
> After splitting __free_zspage() into a lockless core and a wrapper that
> does the class-stat bookkeeping, three similarly-named helpers coexist:
> free_zspage / __free_zspage / __free_zspage_lockless.
>
> Add a comment block above them describing what each does and where it
> is used, so the names are not easy to confuse.
>
> No functional change.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

I think it LGTM, but I'll let the zsmalloc maintainers have their say :)

Feel free to add:
Reviewed-by: Nhat Pham <nphamcs@gmail.com>



> ---
>  mm/zsmalloc.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2ecdf79cea03..9f588b63ec0d 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -856,6 +856,21 @@ static int trylock_zspage(struct zspage *zspage)
>         return 0;
>  }
>
> +/*
> + * Three free helpers, kept apart here:
> + *
> + * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
> + *   to the buddy allocator.  Caller owns all zpdesc locks and has
> + *   removed the zspage from its class list.  Used by zs_free() outside
> + *   class->lock so the buddy-side work does not stall the class.
> + *
> + * __free_zspage(): __free_zspage_lockless() + per-class accounting,
> + *   under class->lock.  Used by async_free_zspage().

nit: maybe a short note on when async_free_zspage is needed?

(IIUC, only when trylock_zspage() fails in zs_free(), correct?)

> + *
> + * free_zspage(): full wrapper - trylock zpdescs, remove from class
> + *   list, call __free_zspage(); kicks deferred free on contention.
> + *   Used by compaction.
> + */
>  static inline void __free_zspage_lockless(struct zs_pool *pool, struct z=
spage *zspage)
>  {
>         struct zpdesc *zpdesc, *next;
> --
> 2.34.1
>

