Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCBEC5AD4E
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 21:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1AE6B00DE; Sat,  8 Aug 2026 17:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA29F6B00DF; Sat,  8 Aug 2026 17:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7ED6B00E0; Sat,  8 Aug 2026 17:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 598F26B00DE
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:10:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBBE012044E
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:10:46 +0000 (UTC)
X-FDA: 85079346492.01.98DCB0C
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id C691840005
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:10:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gw2Ge6vp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786223444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfxaSe6UyiefH7WEwWNg1aTxaKNwUbhG337bVRNgenA=;
	b=e4pQXOOZBeCCfpDtn01FgYJ5YNcn0fOZee1ureLVfs1jNLSzLdpJtNMnbZOazeDlvE9cNS
	H6IqnaIw1BVolusxl4tE9MmVhEoYSef79kz3EMJavrHbgkHWVXKG18JqlH4mJ+NFFzfqxs
	0MgsNGABRKFR9scrf2On4DJc2bnimsw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gw2Ge6vp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786223444;
	b=uSXFguQ2A1yUZ10vs25/6DeQS6mUwSnHdFpYFXmFhia+YV04LDz0Q8F+IcgoILF+HpN5sI
	gNzI1GTnXkaQOsAWVsETw8jcw2+NWHJnhhaqZ7qhdHU0jICQ9vFejYB2xq8YRNK0XESXNc
	AvWS+97Rsatq8WG6ddoHjsieb9ks7Pw=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso770839a12.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 14:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786223443; cv=none;
        d=google.com; s=arc-20260327;
        b=ZXBYh/HpYVWTTinoThbMamxGN1hcxkfYV47/LQvypgZgk1A05E80vx2TzliC9OyYaH
         mWPIGSV+DlF5ScwuUif2be2R6jBufWR2NYdNL4+wBre3HB43qdef6+DVToqCXfMK0mVw
         dXmZ8nk/+7GgDItsNt6zPjihu1LlPgP17eJh8rtqroKaeIFke2MkRTruINgRFdHRCEab
         Er1ShxPQywh6mz0w+UIOKKC6LJjePl5l5/i2MOHbhTjYMz7pJ7wM/XKroDbsCUGKbyIK
         Pn+u3sTo+VRUQgCFK7vn/B0VrPxLPONcJbvDGw9H170KdZNdB/J6bM7KN9p91O+3zrEJ
         ylcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RfxaSe6UyiefH7WEwWNg1aTxaKNwUbhG337bVRNgenA=;
        fh=LVxnxFvwd/FHaBYjS785fDU+/RpG9g3iyPbXsV0O7Fc=;
        b=bg9g69cXZa8r512XIGJoyVeAYxUHGfM86ZREY2xVJ8NWdnRvxukDpHQgns5TQMWvKE
         2O5XWEFMVGJLZAvilKrBNWIHC+qHMiiMuTII8FhX0K9T7aO1libZM5EFIhR3YtKhZH8+
         hgNzKYuCZj0bybSLZr4yCzO7ix6NCRH3/PRQa9Z/06R80DftCkObOSaVOeGV6qoG0F+a
         1nMbqA6+m/3TljCPTeI8WeUxQXn0dmHAgTERcLnaKNH6McHu+PpHGMF9YrSfmlgrT0w8
         vgic5wNmLvtfQ393ECcjkmLTsU2RCNWM/jOTLSWYRpoGuU6w2w6jPbopQ2LE3UaHFhtd
         gUrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786223443; x=1786828243; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RfxaSe6UyiefH7WEwWNg1aTxaKNwUbhG337bVRNgenA=;
        b=Gw2Ge6vp8CIpYosD8M3A2TyuMWgLjXhEQ5psQhOJ2L2kUQ4HtyP3f4NCcfHcSGsqEN
         lffL9P7ZMZTkwXVoRwoEghmm8phN+DxYWxv4HnJb66+VoICQJFmIa0xg7QaA/1vrt12y
         HE98sXMCaL3iDb8Zx1BB0pMQHdwomqSUsoYUOwpUndz3aPoIJekpOik/jvC+8tzzbk9I
         aR6IoDOqcOc/U37nf0l8HBAOWSDfCKfSZ0duXteL/DGm2u2AFfjpbd4R+L2iCRh026wu
         oSi9I4h7XfwAgjr1oqhIvUZXV2V5o2MIVjINPQH4IkG3J2wxbhKOWPKbtuLW5oBjMI5N
         /l8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786223443; x=1786828243;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RfxaSe6UyiefH7WEwWNg1aTxaKNwUbhG337bVRNgenA=;
        b=Vr0zUhmokt5BQQLELkXAkMXBnHAl43BwQmAmvOJV4S+jOYK78gkgrmP9bFQ4BNG97U
         R0odyDQEBDAKeoXc+v1GC3qARSlW+aeA4P0OFr0dDgj0IlNVMAQQbxk6UYDHRrAoy3pZ
         FTjpzL3eCT9k3xGJnZvHDvL+gnBJbzGaUkVGCt5GfEktgyzLEZwvveuxYFwuU0QYBay3
         l/HAdVO3WGqCwMPyBr7BS2xAcn6QsfdMkmuyM+ESDLpZW9JHLBXAOG30OyZ/Bc+PKpr6
         K5VS4arJsK4vWr4AaOekuPdxmrkoVyGzauXHspJKg3lcg5JTGI1Y4GvKbJi4A46MqUDf
         wKvQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBiHswCAdkjuOrC4HZyAqZNQqb4Me7AqAKoEPX2rqN7H2zeT1Vies7pnGnyjmzy57vMRawquJs2A==@kvack.org
X-Gm-Message-State: AOJu0YzJce1GKJ+P8ccbsJTfTU0wyKmI0/DjnhvvQAb5U6UYLVi6qYHt
	gC46zxOJ1irswoobJV71Qg33FTphVygyakvaNXxJZ06o6qyzJo6rvd9k3ZNnQw0NcejfYy/duYC
	ThQh2KsC3qNm4uyVbgNRX9XCyt0E4O34=
X-Gm-Gg: AR+sD13DCncYS3zOfe4sEmCbQ4oxoLEzLoa5ub7KYKthEwMsJYUEux9kGTLqBQ8eLwz
	ffwAzaGc4/XRya4TguaI8M/QCbHfl2M8prLViIapHmb7N0+btY4CdyGnsU2VTWIcZG13zBdat02
	f/L/frs7oKTJHM6u2wxyYjIvDB8WHVzFHTq+bbly90CnMQn4CBqG5hgzQZ+LE4XW7d6x62IgLPn
	i8wspAp4u/J7mi+BKD3MSQ0Y4r2dq/40fx/whiMg4JeVTZi2v3dE/4k+TBlvmWKwdEHVRoZeL+q
	QMr3rU6ktPvIrTAJ4yxY3NvEjZraD3Ia3w3/E9IT2VKxaRI=
X-Received: by 2002:a05:6402:234c:b0:6a1:fd16:f14d with SMTP id
 4fb4d7f45d1cf-6a1fd16f47cmr1630520a12.19.1786223442976; Sat, 08 Aug 2026
 14:10:42 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 8 Aug 2026 17:10:42 -0400
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 8 Aug 2026 17:10:42 -0400
From: Ayhan Aydin <nsd.project.dev@gmail.com>
In-Reply-To: <20260725182628.221603-1-nsd.project.dev@gmail.com>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
MIME-Version: 1.0
Date: Sat, 8 Aug 2026 17:10:42 -0400
X-Gm-Features: AUfX_mzUMGJIvB0lM3YHHPLtEAGLO4zfpfJf_ZZFktAF9JiEbd8yHxOv6v_8MsE
Message-ID: <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: nsd.project.dev@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C691840005
X-Stat-Signature: 5q3agn6397p1tpnqpipfqxn69pnaukyw
X-Rspam-User: 
X-HE-Tag: 1786223444-225706
X-HE-Meta: U2FsdGVkX1+Pk0RiBUbn64d13S81tWFwoBWSjNk37hYd74Ch0YSW/LsXvN4cVMJxC6H8+yv5Mcm1JbxijSXK50m2uOUPRiGNns1PdpCM3YPhppyoJ51OufzOQ2E+I7Goz5ifwqbeZWR5oeNRG9ru9aB4I6P5QBXbqVv/r///1jfvZ6QlKQlMFZ5CA/d93P+k8Uo+bX0LfYg5OnFtIWTkhyFtKETMSyKMraDiBoEhDx53zvJg8xWJHcbQYY4XCqV8cqwgtXIJvk6F9NeodvAAsJ3bgKrHpweU6Tup4uAkdYdhpDoF9gjphI9J8xsMQRnB3ShoCE4aLgSavgvPKorSKKewThJLSv5VL0lLKwn/hVNXxwGF/wdxBJJKhQ1vreOh+6w6UEYFCqscHycFvF/Pw8IYNyZIAC39CR9TTFgXoxbvIt6Z+fkt3UqDogtcNCNMxE6ZI/KnQ9xoM26zlaT1VgFE0cKTWTHU12tNTFO4LCKiS8KLzX4/FfyO9sLwL+iciie79UTSjlvMFZcAr31r++58xt98ZIGc8a2rLhiEIcM0AEl921O9BmwNuVrvNaYEwua6n0CMWFoSd2GHRn//+jHrDZSr20xC5NGBpdnN4Zqeqv7nqCZuL6BcUS9Ip4/yYNiI/Ed7mIJZCHUhGNY6NUkTVHDtwCXaKBfMyhgOco8vn+UXmIMjhE7g96EFoP45wv55Kds4KFlypl2qEVGojN+a7ewyi8sKSbrf8KH7MXxU19GPEkPc8YU+q2hyul0W/9wLsIpVZ64VESlm4QXAlf4xsybVoVLCdoCtOmREWaHIGjLv09g7bRdbVJ/c2l1aADnR/F+FPFk7wpFTll4olwiVsIHKd6Xg2mMPw5nZi2hm/YDlLBVJ5f/cK/a2ZkF2UZZquxQQtnmksPqrOPT+5VGGRaNbaBrW9L/byh9hYAMvrLki3EuZdF60Az9CBm/Md3PNphzJN9/ol5PtQ1q
 nPYJhhrU
 g0mPCBWJRQfhRPDCDUgezA78vpwBmee4UPtGnQpHNsW7vSCzqnmdKWK0yucv/EAKQ8CabUlyjRIFusPyyo0OaSQss4BoA6i8sRZOqWn9bzHMi2lr0idRDIlAwYTAkwzAivyqeergGg1mAl3rB1lm/S7siy1/W49I9sbWj+lhA1K4CJUTzCwhZOLigXf26R7lTRxB1KL79Uu8jsrQ2GRXTpt/dccQaN+tA3LIxOrcp+Dy/E4QHEPgktOSBbmIsR5TBkJvpvQN1VJ/vQLfuuOwSAgOSGzzu2d/Fzw1+JJqVZPh9D6c6g71bHhk2I6br9rKlH+y/qk5/aieGXs1CVOPuqWx19zEw2pMPYwyiaFGkV70eT8gR3Pvid3fBGWClJs7DZlFzGQsd9rLgxcd7Lk1uREeP5q+sraZK7WJG6Pn0kZrSAuIyP3hKbmVv8lF3hhwA9jLWiBLujwjYemIbK+cTAhv0Gcr9zcuKftNR5GrZJ6T7qhVuCsTUrGKMLbnkPaq0Mr47789/ySixUbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Following up on this RFC submitted on 20260725. I understand
maintainer bandwidth is limited, so no urgency implied - just
making sure this didn't fall through the cracks.

For reference, the series adds an optional observation hook
(CONFIG_NSD, default off, see PATCH 1/3) that does not bypass
the existing ra_state / file_ra_struct machinery. All actual
page insertion is still delegated to page_cache_sync_readahead().
Benchmarks (interleaved ON/OFF methodology, i.e. same-machine A/B
with repeated runs, SQLite full-table scans and buffered
sequential I/O) showed an 18-19% wall-time reduction and
+22.6% throughput improvement respectively.

Happy to rework the approach, shrink the footprint, or
re-parameterize the predictor if that would make review easier -
just let me know what would help.

Full series and docs:
https://github.com/nsdprojectdev/NSD/tree/upstream-prep-v1

Thanks,
Ayhan

