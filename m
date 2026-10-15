Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF10CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F173D6B00A0; Thu, 15 Oct 2026 11:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDE76B00A1; Thu, 15 Oct 2026 11:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCDE6B00A2; Thu, 15 Oct 2026 11:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4D036B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:37:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38E8440A56
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:37:02 +0000 (UTC)
X-FDA: 85325263884.16.4F8EED1
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0AA1120004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:36:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PClBPDRE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNC0Fd3BGqN5rK2299oerWY4FCk3NDBRR5bAXp6FoIg=;
	b=vmbmDikOq24gPqB7rDyxAoxXD62VQMf0Z/CgALHCdQjgnbO0cKkt2otXr2Kb4kXmGZLgAS
	MVaRQYmukvOg6HKPFXXXGZLPqhrb9EhBWmF2wtxH0bg+1JYVl5zWEPrmw4tGAoB63IwYZt
	QGzaHF+k+BLQwQhHQ3e5vRBsn2qU/X0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PClBPDRE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792078618;
	b=Q+wzy2ZzIV9/ojqZ46V1iHoxL2D0BfdlgKfYqG6rYC1BVDoUWyBuRcuURhMK2tjgWyKsm4
	qgInFEFMeDAlX8jTDEqDlxSw/fAaDAp1AwWdougUYwI4qs7BPsi0eUH6IxTA01ZbWNKbZE
	P3LWnyjk18Apya1i5P1iB+aStFbQyDs=
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2df921c1d0eso7215675ad.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:36:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792078617; cv=none;
        d=google.com; s=arc-20260327;
        b=kaDB7T3smj2AkMuPr3J6WTeJ1tvwYIIz6LIcjpTJm3Bn3XQcOpQAa75Htahr1sclzF
         ysA8Ya2L7kloDZuFsVqhI2+7D3sxIkmknwA/3YbLT3tguWiXbihbb5lrxr3Fqe2LdJtH
         WCpm/2/g+nbvphtFWRV40GBM3VSuSFbJNFvUtLrV76V6+r7SH5TNuPle64RPE1hpMdjI
         l2X/qTViKG22p+U/tR7s5i8uz5SSwhRyjdV2UYxLm7DWds+8+y99TJRJ5HJJHn4i+eZj
         e0ZJU/ipPYDBzEzxbyqSsqKtUT4stWwN74YFaczCjde3pZQBnyMI+E7oELJXehDr641g
         wESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=eNC0Fd3BGqN5rK2299oerWY4FCk3NDBRR5bAXp6FoIg=;
        fh=Ej4zCzMw36k5omgao4WHKZmqdVeBTYAj0rcMTc5X74g=;
        b=gwvLxmuOtu7pMyHOGVjoKLtGeewc2wFO7FwujH25n9buyVNDpY29rOLRZ1lkcamlVE
         H+pARyDlFg3g3JHGo5om8oqOa0bohgaoFSbVurKpgkGU8+skA7zWtmKyI2Ff0K3SJA/F
         HmVFjw05cGkHGp/RxTr6SqBJgbFUVF09rTWMM7HbPjN2Zx4HhxZKVFVBCa2kLoiD3ENu
         JtRaOzsu0GapffdEWvQCsLD/73hkn/I8mul+C6SDVi5KxR3i6AIge+QrYNM0M4vr3jYz
         ct14c1WJlJhc/CGGfQfRPqV5BuS6QnHPiqYSQGBxI+J4yVooSKSU2VdKpXhukpUI2C6m
         tfaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792078617; x=1792683417; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eNC0Fd3BGqN5rK2299oerWY4FCk3NDBRR5bAXp6FoIg=;
        b=PClBPDREqAiRTDUDoHQN/6RlL8t9MFpjknFBGV22sSxJU3hLIGw05GIi+eOq7/9nTY
         5o3R/M0b7+mmo2YFfyBdZ3vUjVpS89XoTp/MbPkiXczS9tu6Ymn9uRmaA17j9TKMdmWK
         cKUWApaX8U9BzKVcEvqVwRGnaX94E+BRKS6tEKs7/jh5laqG1GnGqCdCoDcWZVNzfWwa
         zW1JTA9ZNZlzGDjcu62tBnqS6guMFrnlI4CjZ0j95Qb1n/xP2oV02wAPpFs6V4uTYiaC
         ZDerJhhxKMW2+uf2rJbTzXnh6tXnfnoJnPP4N8Liv7xi6fyMB1A0HZen14hMYS/GIJBP
         3UOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078617; x=1792683417;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eNC0Fd3BGqN5rK2299oerWY4FCk3NDBRR5bAXp6FoIg=;
        b=og70fc3lahAw/WoZz6QtnwF7AjJr2y4+UsEY0Osw++nOq/soJAMli894qrR0509TMS
         eaioPeTq4leaWaF3BHE7WfbVKm6je8YkzLYLPUNF5XB9EzUSCnYlfVYclst+VaztGgRe
         HDRn4pByCB8DOWoPTXlJDECQGAGoXEYshpv4aBPLZbGl4kIlAv8yOwb3ru7qtcg6f7ku
         Nlm/LaXpCIWhxWQF3PGoMcIVoK7+P+ddyageXyJtpu9SXB6/qf+T0HKzOURrivn/ycmc
         14TxMpwRWyq224L0gsjz91Mv9ZIRjTGCxkhSdAwfgliCPINF6mRjCOpU/bmnXeLNZRIW
         dUew==
X-Forwarded-Encrypted: i=1; AKwUvBx43IjlhCn7cf53KapD03J3eYu69O7vhz47rqvbXhTtTJ/0F08rp6sEvm6YEfrk3gjIALkjgbl8UQ==@kvack.org
X-Gm-Message-State: AFq9FYKDjGM5oRK13GiuuZF9H2uWg+ZO3bEkV4a77gkkk4h1FMDcDNbG
	dwDQ257uhjW6iliupJexIRUly69Xw4pTv0+7Z/rUPKyx5423U9kcieHHyatODgyxZPrbuAM1w6g
	5NbrH2MsNokkmyl7nWQGU+GjVzBt8vz6cmH1n//RFyQ==
X-Gm-Gg: AYBFou1hn8RC6/Ri/kf/8mQcPRfyIUKbW440h+Pd6dzvgiYKZ48RT+HWSAIihImkyqz
	8/7iuJIwmxgwR8uL8P5XIFVPMjyKtLHzwQZ0f1t0Dvnvah7YN3NZyPX0vXOuEZKfL+LANvFaG0A
	+0D9kBuLy5nr2gMqL3BVPXqHk8dFqPC85ZG73Wqr726ESWb3td5UwnBHMb1ErjhH2fxbuHeocOb
	eN8Q45O3usqY+l3XNHoTFhSWdaSp4hzkuFMPjXZPZeXgY+iHslacURyIpMiLJeMIKCAcyhr40A8
	LafqMYKWlAhoYZ5IPf2n3jZCku5vOZywl2nmUPIj+HN8D1B8hutxd3KZ/ESy/0CPbYXYNnot00N
	NBpK2p0Q=
X-Received: by 2002:a05:6a20:244e:b0:3e1:549c:deac with SMTP id
 adf61e73a8af0-3e16b787a51mr17302180637.0.1792078617372; Thu, 15 Oct 2026
 08:36:57 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 08:36:56 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 08:36:56 -0700
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
In-Reply-To: <20261015141027.88149-1-sj@kernel.org>
References: <20261015141027.88149-1-sj@kernel.org>
Date: Thu, 15 Oct 2026 08:36:56 -0700
X-Gm-Features: AclHuK85ky1hJxxDTCm3lZUrv5F8rUf3dKyeQBVHR1L5-9dl9c9590Lj6JmwJJI
Message-ID: <CANOyQmF+nwNyGHptBJhT2iVDV6cmBMYY8rqgXnqg7GCDfFy_ow@mail.gmail.com>
Subject: Re: [BUG] DAMON: 32-bit overflow selects wrong sampling interval
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A0AA1120004
X-Rspam-User: 
X-Stat-Signature: qnhoag11bnzndnhu585u4wm9xjowdahr
X-HE-Tag: 1792078618-411544
X-HE-Meta: U2FsdGVkX19ae+c83qfXwH0mUls4+S2Rl6h2mYYqAa9FWQY3177kkUHkVwUZ5xs+P6TfO4uQpbOwDlVU1YMyVYMr8A7tR5HQXfaYPoTL1JUnbQwec1JMQEDyfR9btn4C+qk821KVy8X3gXy4/2peibsHM0ZX9zHXLvs3wDCZZIRxUFSmRSwJRLTrrDn/ik2/+njNq6b07Aw12N8YFf9cCadD8I0IYm9me2ac1PrKSxDgL/dVUK+LDQzQU4gCi0BP4WCcQ7JrqMVBKsCevKKXjnNF94bpsTPVtKwVzjNeAW97L5r0hOtMiVo02QXKHBzf3n/J20YZRvwtHK8397fYikrq7TQivmB+87IpQNmE4Ir71BMGXCKLclayggi8oibfdKEBrwPaKp3nhiUfUU1vMMoMFeQNRZEtnh9SzeA8fdEtB6irFp4abVTujyy6W/nsAz9ERntiWe6PxBdASc/uuhY/uOKgRTzJIu86VxUeEYJbjX4of6X1RCVcIxCliylUuMj6gpaWd/ARfuhRXPmrrtPsSS8D5UIrYxyOGRnLqMBNR/S5ajNL2eHTSwuI4cylnZFtUdqtjWXhkHsiyPmWOGfB5VZ4V8cAcRV82XMHa33xF0sqXN55fthMIKH2klpe1QobEpoq2cviGBzhhN8IFVcWLf2EnBmut9UJWXGrkpFQUi8ILAw/oZAr3vXx49A5EjzaUb8gKXKfWjdTMiA32Z7YBSA9ICaV2EoqYuWsAQMT+wR+8IFpn+TKJEwJoZUsX+E5EaYj3LjQND6vONm2Vc5+gY1ELZubnoegNE+O0yijdm2nsrC4rYZcQM0EXGIrqkqo74cCUs9654q8h26evngZJB8DnRtJGW5cs79gH4xkrbHP6o+65y8tWI6ZQxmpP5LBNp0HBU7j8t4h+BKtYXewS6r1imwJ7i9ILGYgqsZhiF1m/7TyekKlARO/vt4o0dkjByBocICZprMJV0B
 WMiJGv27
 95vdI+XxuZtSI6TIukS/an6n4xyFLVBsSbEH1XuPlVJ37bH964ZQl5aLOZwsXokr0xUOnzSRLdn3SIS8gE0qrIq2AretlyB04uKwZ40n2sK9Roj4EbBd0o3UyLeAPLzXTlgYU3M4n/gbtrJI8mPiJPtxKLet4XXhn2KofihOHQ+va1mHG3Mwea4ygZt4MHIYi0FzWQdc20FNA5bJ9OsVqh9WGiCrvDTXW79lHK47kNg9ZWww8/hZDQlCHjU/itixbUIFAHsgcCQiDax5ayGCQPFIf8TmkqDutTmTM/7XTAvYgwVWEG3/lq8nMVZTgWCXB17ufhuOUYZKcbBp4plGRO2ivhfSn6ln/IMZjRZgh5H/UaZuxU8YYsUsa7I7ypgPeriIGe5EaLBrb1qMYp4LPXkhhqCuMoud5MLBt2pHZDWtTrc9BysZ3lfINLkzkV8lUwBFAEjT16HlmROhJa/pDAOxNBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I haven't seen this affect a real workload. I found it while testing
interval tuning on 32-bit.

I set min_sample_us=2500 to make the difference visible. The default
5000 us minimum hides it in this case. With the captured inputs, the
kernel picks 2500 us, while full-width arithmetic gives 2812 us.

The shorter interval could increase sampling overhead. I haven't
measured that overhead; the observed issue is the wrong tuning result.

Thanks,
Aveline Noir


On Thu, 15 Oct 2026 07:10:26 -0700, SJ Park <sj@kernel.org> wrote:
> Hi Avelin,
>
> On Thu, 15 Oct 2026 07:24:08 -0400 Aveline Noir <jm5905938@gmail.com> wrote:
>
> > Hi,
> >
> > In an unmodified i386 QEMU kernel built from mm-new commit
> > ad9f2d463666, an intervals goal selected a 2500 us sampling interval
> > after the first aggregation.  The same trace inputs give 2812 us with
> > full-width arithmetic.
> >
> > The kernel has CONFIG_DAMON_VADDR, CONFIG_DAMON_SYSFS, and tracing
> > enabled.  The guest monitored a 1 MiB VADDR range as four contiguous
> > 256 KiB regions, with sample_us=5000, aggr_us=100000, access_bp=400,
> > aggrs=1, and min_sample_us=2500.  The default minimum of 5000 us would
> > hide the difference.
> >
> > At the first aggregation boundary, the four damos_before_apply records
> > for kdamond.0 showed nr_accesses=1,1,1,3.  The next
> > damon_monitor_intervals_tune record showed sample_us=2500; sysfs then
> > reported sample_us=2500 and aggr_us=50000.  The records cover the same
> > four 262144-byte regions before the first tune.
> >
> > For that aggregation, the inputs to damon_get_intervals_score() are:
> >
> >   max_access_events = 4 * 262144 * 20 = 20971520
> >   access_events     = (1 + 1 + 1 + 3) * 262144 = 1572864
> >
> > On 32-bit unsigned long, max_access_events * access_bp wraps before
> > division by 10000.  This gives a target of 409364, a score of 38422 bp,
> > and the observed interval of 2500 us.  With full-width arithmetic, the
> > target is 838860, the score is 18750 bp, and the interval is 2812 us.
> > The later mult_frac() remainder multiplication does not overflow in the
> > observed 32-bit path, so the difference here comes from the target
> > multiplication.
> >
> > The affected expression is in mm/damon/core.c.  Widening only the
> > target product would make the later 32-bit mult_frac() remainder
> > multiplication overflow for these same inputs.  The 2812 us result
> > requires sufficient width throughout the score calculation.
> >
> > The 2500 us interval was measured on the unmodified kernel.  I
> > calculated 2812 us from the trace; I have not tested a patched kernel.
> > The i386 config, guest init, serial/trace log, and build/run steps:
>
> Could you share more details of your use case that this setup is needed and the
> overflow becomes a problem?
>
>
> Thanks,
> SJ
>
> [...]

