Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E75ECD6F7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE846B0005; Wed, 11 Feb 2026 18:59:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86166B0089; Wed, 11 Feb 2026 18:59:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C845D6B008A; Wed, 11 Feb 2026 18:59:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5D7A6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:59:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D1EF140515
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:59:05 +0000 (UTC)
X-FDA: 84433844250.16.DE18280
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 375BB40006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:59:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TZ0Vsayh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770854343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qag8o86LYIsDegtsmUh/0CZoMISuFrYHuBcc7Uj0mbY=;
	b=bpHw/kKPBqSXQ2LLj/J0/AbgLIx8mWtEa+cSl4mT681zo4716FlQi+J7YueKshFVSnx5UI
	Fxwu6+udr8wQB3qvvnOfhzOtxmJw02kJg4FmyiOh+GwhLuj947jlre5DJyPuHxmvvccqEw
	ylXquwCrhjttnO0djGyALlWxo2tJb1o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770854343; a=rsa-sha256;
	cv=pass;
	b=JkwXF/NLtxLN4/w1uehS4pDix3lzYo+tHWwYmhSMgLmzytAdWWCUSQsfGNJQ4P63gH0Dbs
	+fQd+SqRv/hCl5p4T22MpGzPBO2QSabmrd14hUWa5BpuPUF2gMMLPQBcp8iI2hHLVWwYHF
	oGFZ20nFYqby9DzRaPwSTmDax/99zCc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TZ0Vsayh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-659428faa2bso9073093a12.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:59:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770854342; cv=none;
        d=google.com; s=arc-20240605;
        b=P03tkQkQUxlZGnyRTb3jdaTGnVs0ZQDx3je0ZFQe4cDs0V3wxBmQb2KbqtCRfdMlOF
         4BdXAePIO3n66nAkWTzj2nMfK7FuzfBdNRKFtEEwzaGUcvYuhOURr8rWNqM1pbhZOrVd
         af3do0QYkxamLAAvjtR90GegD7V+eb3sdZaoRhl98KUO1C/AKJxv4crgBclJyDdij2Hl
         b+OUVIt16oikGjQ9+tLyIu5sRJiBifNoJZOZR5hh49IRETYlDeKU9ixNRcaZN93+tTJq
         RDFlTJh4aMoa20ohHuZZ6S/UFhYCJxwHj7Vki7pgAV9R0acA2CGoaq8kefxj40WX+Ugt
         sONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qag8o86LYIsDegtsmUh/0CZoMISuFrYHuBcc7Uj0mbY=;
        fh=iXRcz7Js+R6jXV729tnUFX6cx3fY/4120zG7NbgYkyo=;
        b=VIqB30k5ESZXcMsKYJM6iDbc5ZgwA+Yrl2/G9KxUI9BlHRMxbmX/z3eq1NzD7uwsmW
         ixj0ZY6PzrcLTDAsuKNrs3g/aIKZgQU8raRGohlPGVZeZcfu8GcwxbkWtnwz+tMGnMqp
         eWnYNOG68ldYQu7ssCpIls67zfvlJqkVi5Vr7YMGgva8dpauVcTA9xQnKBoORR56pflU
         qiHhPBI0MCINFMcJxk+ZJyxcBDCRe12FpLn/vUoT0wJ+nDP+ubDnuNvPd4r4aqPU6ygl
         3yPuh6iGqXZA1yboHubkz4Hp9Yp1rcJgUNRAaIHdm55PnP3OAZPPuGTkmAdIHFNpmkjd
         tOpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770854342; x=1771459142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qag8o86LYIsDegtsmUh/0CZoMISuFrYHuBcc7Uj0mbY=;
        b=TZ0VsayhU72SroQ68WRcvdVkIHojLZFPUsK9o/CazwU5OBs+BVnbR9yifd+ATChIJU
         +ilHTeacVEEnas0x79YT64P5iQ8prOmQZSILLmb/c2P8MhlXrLwzgJqovzJDZPjsAUKq
         QH1RRooAaILQqIVPzXCbcVhJQPK1mRY+UCkR4X2wVsf9rJa+KdPgxGkhEDVG17Ezs1EZ
         cSYynCuM6JyxNlIzYzq7Gbd2Vj0jzZdvTvEd5YE9mMQ8MHiL3eMqQd2AzWtb1YWQKE6h
         Ab5zOU2xXMzV8UuOhW+l+UaMEu4dbUmqAMVeXBuZAg1cHz9RIf0Z0ezWk3v55r/BvLbW
         R51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770854342; x=1771459142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qag8o86LYIsDegtsmUh/0CZoMISuFrYHuBcc7Uj0mbY=;
        b=ClB7QIWtdE7ErDIWpvUtOdDELEujOZkET4gUgwtMvWqwNyIbMfoeDa3FDO9mal55uh
         TGVFI8rtmg/cQT5IOo77UPkP9C6r7w4mi8xUKSc5sZzdr9GjNq3RBZJk0v9CbSgA1SKi
         f9wiWS7boyCiawy5cT4NK+0Tz6PevrCq7Kz5jzpDcu/OfosRbwGyrnMaQpuvcYKgwpyw
         KxD209/ePw3hvOYNqPgDfVIKLJDZ5AFc0c2Hu0B/2x2VU9z4M/9rgceeF3shNwlZrw+G
         hD77mK4YjehTdRSqVBxxSKwCOXVktoq/z41tbf6V1Fd7UgYqtFM5hwC8g9jUFozMS4Ft
         Iixg==
X-Forwarded-Encrypted: i=1; AJvYcCUx3eDVNJ1ewf7iDMIyQ6Ru8/0uK/OG5i1THVRSMY/tuBlsWLoRjFM6ABPWBklIa710YyiODogjWw==@kvack.org
X-Gm-Message-State: AOJu0YyI4J0hyhzvcDjCEO3UA2EA7m17dypzI9d3lMlq0SRR93b1hLjN
	Ve3Pp5bi/Hkb1HHLU9PNQusmVPIWQKiukCKllfLkzwDanFrb7J0+bKvuFxAqDb44n6cmonxfuGg
	HMJVTYy9eagn4sxaI1eH1Tnu2S/xLmFw=
X-Gm-Gg: AZuq6aI6JhbvIkwJ1kJbXadmav9D0jJ+vl5AoHy/YW/cIFlzqKoUj9feabkk+RqKPu7
	lKlxlRAmfmlZS02DN/1KX+EutEMfifcAKLJaewxWoFpofmlodH5Iw6r1xsbo9YM4L8shl+3EaOk
	EcMe9IG3hQymjA3MVRw8zhoCshmIy0z0y6zl+cvAQoSR8huYOHkGuUHcHKwMC+x5vmEYnUnLfIm
	9pV8TqVwF+8wdnEscl3J24H778AfBz/TuM4rU9p3VsNzlrJaums0vQqXZD4e+vkAUYjs4eTp3dK
	tilvrGXbDg==
X-Received: by 2002:a05:6402:364a:b0:655:c395:4553 with SMTP id
 4fb4d7f45d1cf-65b96e3571cmr389316a12.23.1770854341472; Wed, 11 Feb 2026
 15:59:01 -0800 (PST)
MIME-Version: 1.0
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
In-Reply-To: <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 11 Feb 2026 15:58:50 -0800
X-Gm-Features: AZwV_Qii28ttumfDYt52j0KrUln6CGAyB_U0qQloan7p-xdHLNPAhrKjtsuzWK0
Message-ID: <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Tejun Heo <tj@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org, urezki@gmail.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 375BB40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xbera3q74ca44cdyf1x3ukqky3dmkip7
X-HE-Tag: 1770854342-185503
X-HE-Meta: U2FsdGVkX19LFinXaN60oTIV3h0/5QPg0fswssIXxpo+1syaCGLehJJv4YchUjActK2QptO1HgqvROoUrlwvC/4RjlOcJW3a7KSOw/ana2EJQim1y/J7mmRH8ev0Pnz7ZezcM/D6iW4JjDJlbAPFyNaL+B+6wwC4Z6vTjnYJ5m0WhKwbuzj9zSRxeH1UUSnaqe5IGnweuM4KxK8hk670vgG7AFVr1kC5LDay6nVALBtnaxJQkN+gohGkKqBBwMMjBmG2zH5SOI9o65sgAdSM9VbOMIP2GlNk65x5nP2viRpk4Dl9hiwe25x9SzEMGiF5fMCyl84RgZBjfVMdjqV5Sa74hhmgUpgvNzTzYJr6qpSXGbjyXZ6wGirtFcuWNKm3Pi1WM2LgMtZdtjkXHo594aHXaqOzKqAT39SJrjzuUV7yXJxtAIDaJwdEoRGRhFM4vTw/PAoNBAhoQ4J33KTZtsjWbLI8y03iLSGNWN288V7Cz3T6njCl0o6wPQ+ks00qZIXqvTloOXFYKiV7oGfm57XYmQdp8TfC8MsOeEwJ8ojqml/CZuTLK/YdzkP4m1tfphv+Swb49QluDez1jAKtOVx5QfG1zwu/7U8+xFNxjv0jsoRsRs97cMBQOi7UavPqoyVNo5VXhhRxh3dchlXfRuHjYSbFSFKEiUZN1U7sjdQPjXWEm4Lvh/xrrr40ncTgdGAAZKkC3lLTecEyEAQ4PMLKNbX7pzsHVAQ3ZL4jynIwolfQ1p58dvOz20/QHiD8o2xcWKIPQDK9G9BJ+nW10UpYzTnAcdKf4zBpWwuuZM+98M7mnuJsSWF05+/FtUSm2abi9gDP+n9SUik4/4CwvpHH6U29SpLDFhsLWaIdhrSZKnXqlXPQhk3KYSUW/DULjoXFb/Foc3mOl8AVnjIGmHcEl6LaXDLWUeMSeIqz+i8JK0oUXr7zXy8SMb4qc2KYLSUpCxg9vXQSAjVuYer
 VTC9C0Ns
 COuWZXodw9UJrQpYLULduwzHibpAoz2fNcwP+RKFZLiictC+WXzv4adV+2zmRu6BZ/LAe6t12Y9+VUxvdsnaoMl7sbAyvVR+6AFuxRk8UQBz7ttY+u9f9j7xF/oQwmiiBVmYEoy9QGASIyVTjuYyEbLH8vPQygaA9rZAYaLTVnyTIqWB0zaqbQNGeA33qlCOK92qAaOePjICl9NQUSbxQICmWJJAwMqkAN4MjmN0Eb3vmvFRgrz2QoI+lt/HUjgDm3bgXmkTfEEF4CH1t3glqiTebdQxKqR7k3tIKimS9y8NDSUp+4fQGj2ZhKX826OAN9bhh/x3E0lRsZeQ39HRN4galLPtot3yiqI+zH9ZXymwybXKw0CEew6Dv7ZaYYUxAxyBL1wrwRMYBmmuplrmn+imFqsBwQ/0ebxo3TnKq6WZTtV3SZ9HKeBp8hoQV4qauVNmrRl05CxLro29j+4ncW3ldxm81Tl/CzsFuZnEghnJVJ050uupwhuEfkVDvXHGUJN8x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 3:29=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
> ...
> > Overhead
> > =3D=3D=3D=3D=3D=3D=3D=3D
> > 1. Some extra virtual memory space. But it shouldn=E2=80=99t be too muc=
h. I
> > saw 960K with Fedora default kernel config. Given terabytes virtual
> > memory space on 64 bit machine, 960K is negligible.
> > 2. Some extra physical memory for percpu kernel page table. 4K *
> > (nr_cpus =E2=80=93 1) for PGD pages, plus the page tables used by percp=
u local
> > mapping area. A couple of megabytes with Fedora default kernel config
> > on AmpereOne with 160 cores.
> > 3. Percpu allocation and free will be slower due to extra virtual
> > memory allocation and page table manipulation. However, percpu is
> > allocated by chunk. One chunk typically holds a lot percpu variables.
> > So the slowdown should be negligible. The test result below also
> > proved it.
>
> It will also add a bit of TLB pressure as a lot of percpu allocations are
> currently embedded in the linear address space backed by large page
> mappings. Likely immaterial compared to the reduced overhead of
> this_cpu_*().

Yes, this should be not noticeable. This can be optimized further by
using cont PTEs on ARM64 if it turns out to be a problem. The percpu
area is typically larger than 64K (cont PTE size with 4K page size on
arm64).

And linear address space may be not backed by large page mappins on
ARM64. If rodata=3Don (the default, it was called "full" before) and the
machines don't support BBML2_NOABORT, linear address space is backed
by PTEs.

>
> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
> uses that outside preempt disable block (which is a bit odd but allowed),
> the end result would be surprising. Hmm... I wonder whether it'd be
> worthwhile to keep this_cpu_ptr() returning the global address - ie. make=
 it
> access global offset from local mapping and then return the computed glob=
al
> address. This should still be pretty cheap and gets rid of surprising and
> potentially extremely subtle corner cases.

Yes, this is going to be a problem. So we don't change how
this_cpu_ptr() works and keep it returning the global address. Because
I noticed this may cause confusion for list APIs too. For example,
when initializing a list embedded into a percpu variable, the ->next
and ->prev will be initialized to global addresses by using
per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
head will be dereferenced by using local address, then list_empty()
will complain, which compare the list head pointer and ->next pointer.
This will cause some problems.

So we just use the local address for this_cpu_add/sub/inc/dec and so
on, which just manipulate a scalar counter.

>
> Generally sounds like a great solution for !x86.

Thank you.

Yang

>
> Thanks.
>
> --
> tejun

