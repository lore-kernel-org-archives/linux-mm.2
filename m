Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C02FCAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 14:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8772C8E0018; Mon, 29 Sep 2025 10:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E328E0002; Mon, 29 Sep 2025 10:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B8A8E0018; Mon, 29 Sep 2025 10:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6903F8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:40:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 182981DF73F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:40:18 +0000 (UTC)
X-FDA: 83942548116.12.7B038F3
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B1278000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:40:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759156816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvFjznroqzFUOXsLEPiseH1v02F6mpBvJnWjh/fc570=;
	b=qF5cdQVK8/A22TEoViPR70Na2ZDaBMCKegiwXbt0feeI34378oF3TVwVAyrmYbNKe8tHb/
	ztBl17mgTaIb9I9egFhxL/E/uvVphQr8WRiTAo0Tk7qYgWgH0pBdoQ06d8M00jlm7A7xSM
	No41peicmXmd0Bn3gZv6lKoF8Jym0qE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759156816; a=rsa-sha256;
	cv=none;
	b=Wc1K1B6GjbY2ZU9yTGuWe6Gff2UIqmRJR6d+yKlvSv5aQMos5A8DOYvWCSNlvSUz/hl/z5
	IymbAHR3DN71fbcKqmHH36t+MlCH6mm9TIPaUD3ZBADtgf9xqhe8ZeUh9pZ/ArZPcVnR3o
	xi+OyYZY3OuUx52FmcJemlrpjMwdtVw=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62f24b7be4fso8509743a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759156815; x=1759761615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvFjznroqzFUOXsLEPiseH1v02F6mpBvJnWjh/fc570=;
        b=PVufNjFrpWKGmucc5a0f0H/inEj1EeWXp1iTakeH/PzpdZWmhErto11w9EetDvTPTf
         VwYRpRsYNAOQr4kblXFJzlQbRv6tdFyGiN0MpP9ce3Mnv2tJ6lBWK656hhu1bvbpaTJt
         wwlNHd0Nzgqmp56n7eSbritMQ1ZbR3puB/L9aLzotVWphE5JhzBt2CguRrPqf4Vj1duH
         Nv6Wtjpitb5IQDAtV3nvCrUeJk/ZqOAh1iKww8sq+TzkgLipxwUFCmuz7JEp3tXJuwwF
         7ju6xs7qkXmRigVCjeMgk/JhLgwtcakopxX0Cz9ZsIwZssnhnxGDsjEwKTxlNriLGcRb
         f3EA==
X-Forwarded-Encrypted: i=1; AJvYcCW3GOuZR6485to0ZYI4bFeYL5NrT+od79Jhnv7RtOxx0Ei5ZFf4xSmStHadz6nulz+y6MLg7p1hLg==@kvack.org
X-Gm-Message-State: AOJu0YyBeqDHwRFwIneyV5vqsClrxTOYEq4DuM0O/q2AaVT7UKxjIf11
	jvSe+flMBDLXlgRMgpl5FP9rhiq3B2NbjVmO/gzuyBgHLDU6CuL3wkGd
X-Gm-Gg: ASbGncsLGqzOfrJZl+E3P1/STTyTiX1mP2V72GeaSahFPkDKEWM2B2hNuGNSk5EkfQf
	wh685PNK1gU0eKL4vs9khvsd57vQsYImTt+/M4CGNPZN2a5kNhDg5NE76fudnNIcEKuWQAEDR34
	TLrJWmyEzAGnhFPP5tnJURfzcsbF3XwRyJtNqrUGP/wUfz62HAmXDs4zmlCo1zBL4m4AcAKhVGa
	WJNjxH9cl+DwyjuKt+S37UgDo23ILIrc8v/hnSI3noD83wiLb2thB0TN6rxwgyqr37/ThD5PMzF
	I+kQmZFxEqOA13mbDGj3rNtBaxktyGMmn0mK3j8BWv4bI3ClQq2vExzeNqPXNJyMFNRQKHvw0gz
	Zhi8xVRBui8wXVFq9ceekOgo=
X-Google-Smtp-Source: AGHT+IHbZP5Sc9LmRevMUeUkY+gYIieaF0HX4TI6xI5A/0J/URStj2rfgjvSCWUg/riLdMA2Brr80g==
X-Received: by 2002:a05:6402:4556:b0:633:d0b7:d6ce with SMTP id 4fb4d7f45d1cf-6349f9f0134mr12493050a12.15.1759156814415;
        Mon, 29 Sep 2025 07:40:14 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:8::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a362993esm7945828a12.4.2025.09.29.07.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 07:40:13 -0700 (PDT)
Date: Mon, 29 Sep 2025 07:40:11 -0700
From: Breno Leitao <leitao@debian.org>
To: John Ogness <john.ogness@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Gu Bowen <gubowen5@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Waiman Long <llong@redhat.com>, stable@vger.kernel.org, 
	linux-mm@kvack.org, Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
Message-ID: <afbwnxlj4rxncrqc2bi7maljsy4vi3xq3a4ads7plvpww4in6n@r6d4yyebofdv>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
 <5ohuscufoavyezhy6n5blotk4hovyd2e23pfqylrfwhpu45nby@jxwe6jmkwdzb>
 <aNVSsmY86yi-cV_e@arm.com>
 <kuq7guzalpqj5bxe2vt6s3kirrq4sg5ozwcim6ewnzpxhuxm4l@yfgb44nbcisz>
 <84ikh1l5dh.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ikh1l5dh.fsf@jogness.linutronix.de>
X-Rspamd-Queue-Id: 2B1278000D
X-Stat-Signature: u41dpm9crqnwfb1yfiep4b1anhjw9y44
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759156815-257377
X-HE-Meta: U2FsdGVkX1+66MFVrvfaTAgCwVO2XofvtZypdJ7THTPeJJ0DGt2EuYzsFvs+OWykWrDXfFXD4JvKaSsuRzCjuEKrpCW89h1sJBqtc+4a73MLmmRfzo6X3XpoNqEogQD+ZW7uPLmqHDLsCQgTYQflFNzzARHybZf9I6uXzKgNe9nOqUrzCLPndcIV1uCn6gGGyHTcTteC+NoelHWPbWVc6lNVhc6u2/6g0cUUrM69x+yBN/a/UoDRQeuvBTWBuLawrYA2rr4lC4nPhX89QgrAy1z6EMHHpGZkT8G9P3Q0PUt6vrGjjPMJj9qVTKNuGA16WVJrVNr6leHeUYqRqx5QxikFHwbcaiHQyHob8lsLhTvIZ5o9YHMxzCTJpbl6PeMkEBcRm/ramlIbNaIzkB18G22oF/b8N3CrhmJcZVM3nx3vOXvfpbQSrQjs9sVvnENODeO+u20v7R8PxNLQLncEdDtS76cq08rYHC8NZ52djKgII75h2NeR3HLubkOkDs+K0IXDzZIOP9iKhaVsH+4hF4/8Ip1A/tVp1Mmt41v6Fr4oj9pzVQvq7dvJtDboaln4pfJY/7fhX4dCCBIO3V78EWv9Qs3WlwmPuDkqaPD807NcRh8NuX7gwts+2GZTcXTqjbK0+BjNdFUjhE2jG1sMve9oEl/KnNSTts8gRA+fb//HOXRZQzVnl7s7YXrl+NmFRrlmDHfHNcSYVa1ekAFKLdxqVOv6d7KoOfW3EQg7SYf67Rz4HvP9aanltVmAmLhNtU3l+bQ8gKbfZf6AL84FkNgqXgHkl2Dd2jtgtWPS92hXVVhHBalmFtW/b3hltBDehQJpnBUSWDeU1S4KHti8cikXmqu4SIi+tZ1Fzw09m4Yc7AElvZFN7AMv4VU2QIGY/t+gUUrmsjBZ/6Hd+3QDCrcfNxUGdwQQc2DMni8JdtCvRidJJgVfh32fVRd8HUiABjE6ewKJZMozdwIJbR4
 W+sBAzEe
 cTjOXUBK4DcEo53pvR5UeQ470M54BIxmrkoKAA28oQN61m8Ihzg4vnvuOK1PKPXcotDqcDb+GrmUJAJg3edKBdRcZ3tHoXO2+zJY3RCe3y4DVsryWTo88E5o8O0ijM9oJB6c4LjAu383PnQYtwHHC7tP1lxRpvthjtQkXB9bVgkoYtGrDdyOW/TnRextUMWnAn7il+ztrWHqLSMemdIcMVWPT0/O4y5tTc378xku72yZ2K+lBNZDSig0qMvu7KtxUiPl0lhOmZd76TTeMRuoH0hYQa2EjJN6Tz0rgQQAg6OlVivWeoHdBT77UjLcUb2aBaiQpl6LeFkokQDXR0aBXdGAPnP1u7vOfPY4yFOooPnP/SsGWq823bnzmWBYYnDdJH/zCJDMhG3B+xlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 04:13:06PM +0206, John Ogness wrote:
> On 2025-09-26, Breno Leitao <leitao@debian.org> wrote:
> > My concern is when printk() is called with kmemleak_lock held(). Something as:
> >
> > raw_spin_lock_irqsave(&kmemleak_lock, flags);
> >    -> printk()
> >
> > This is instant deadlock when netconsole is enabled. Given that
> > netconsole tries to allocate memory when flushing. Similarly to commit
> > 47b0f6d8f0d2be ("mm/kmemleak: avoid deadlock by moving pr_warn()
> > outside kmemleak_lock").
> 
> Yes, it is a known problem that a caller must not hold any locks that
> are used during console printing. Locking the serial port lock
> (uart_port->lock) and calling printk() also leads to deadlock if that
> port is registered as a serial console.
> 
> This is properly fixed by converting to the new nbcon console API, which
> netconsole is currently working on. But until then something like Breno
> is suggesting will provide a functional workaround.
> 
> Note that printk_deferred_enter/exit() require migration to be
> disabled. If kmemleak_lock() is not always being called in such a
> context, it cannot enable deferring.
> 
> One option is to enable deferring after taking the lock:
> 
> 	void kmemleak_lock(unsigned long *flags) {
> 		raw_spin_lock_irqsave(&kmemleak_lock, flags);
> 		printk_deferred_enter();
> 	}
> 
> printk() always defers in NMI context, so there is no risk if an NMI
> jumped in between locking and deferring and then called printk().
> 
> > The hack above would guarantee that  all printks() inside kmemleak_lock
> > critical area to be deferred, and not executed inline.
> 
> Yes, although I think netconsole is the only console that tries to
> allocate memory. So if this hack is used, it should at least be wrapped
> by an ifdef CONFIG_NETCONSOLE.
> 
> Although it would be preferable if netconsole did not need to allocate
> memory for flushing.

Most (all?) of the allocation is in the skb, where alloc_skb() is done.

In fact, netconsole maintains a pool of 32 skbs that is used when
alloc_skb() fails. And I see cases when that is exhausted (when OOM
causes a lot of messages to be flushed).

If we want to make alloc_skb() out of the TX path, then we probably need
a bigger (configurable?) pool of SKBs.


