Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98AD7C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378676B008C; Tue, 21 Jul 2026 09:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3296C6B0092; Tue, 21 Jul 2026 09:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4226B0093; Tue, 21 Jul 2026 09:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0CB6B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:25:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E2131A014E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:25:25 +0000 (UTC)
X-FDA: 85012855410.05.081D84C
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FED216000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:25:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DQejDO91;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784640323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUGRrLpcbADBJyrtxfRhKxWvRc1OgkKW+dNy23AsVnk=;
	b=t0eO0PXrsZ6RJ1yG/ZRRzc/Y5eLteVn8mrm2fyQfw4frn6AEVi7U3sePr2ghoSLag0usUq
	WV98SpmomuF6vosnu6h9QcjmAR+Er7f3rHZeoR6EryPNV4LCb+hy1QHAFiDnSgNpIfp4EM
	kGuJnGjMjZ1Y2o+o22FrIqh6vEpXTaY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DQejDO91;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784640323;
	b=nAN5thoemUQNeGQVKB3LeDNoHc3WoLIBqwaqR5xnYlSgwpfG/2B819d4JbwoZbKib/iPPz
	zrc6Hq2NEJxGNS5JFNlbE6BUckrNcpbVt49K3wZBMA8i3BHiMcjZsNDogoR/LWp54rrACK
	TMrPNRF4J1QzM8rxp75HVEW0ifH0Qyc=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso3975477a34.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784640322; x=1785245122; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NUGRrLpcbADBJyrtxfRhKxWvRc1OgkKW+dNy23AsVnk=;
        b=DQejDO91CpYvA6Bl5qskUod1CMdvukHNXE7zG4wIiW4G5ELE6/0LNrLeBRaq4IY5gW
         RMFSTtlB8fwgX3c61EuFHohmgWXPMZoP3UZAlBK1Qt/dXNI2uJGEuMLufZ5wJPvxmMr3
         uyv/p3Jfq2wb2a4TxkrRZQhuwMbBau0pA6Rotb319hdOBqLLdObN2UHpKyr59rZqbCcy
         /8ISaU/oBo3JccuRMu7tTA0SHo5AtFNm/MImnqi1z4hukvagj0BmB2ZGtBX1J0oJbXpU
         /AdaQifbrbH2cnjJizGjAx5AoKaTOiSh6PxLLgZEdzJB8S+Uvfjh/HdBxg1OGeiiQai2
         Vv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640322; x=1785245122;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NUGRrLpcbADBJyrtxfRhKxWvRc1OgkKW+dNy23AsVnk=;
        b=jwqcyw0pdyLDNYcqVyzr3c0eWxtpx9t3TcXKZlK56BbabBOnOrB18zn2eCUAdwPkSR
         Jt7ZQ0GdzUaptwR1pBvkvAPtFUlyBoXNXUva0W4op11U5P43Ke8MtA+oyeadZy/wL7NQ
         ZqCEV180mvEzUQfKIdh7gG3XBUn9rjBt6JhJmesJ6J5Ar4IViUI5yLF1xcWma7JMFAiJ
         MRqkjYzr8nVNQK7V1pqqpXCDpr+xU6P9T4aZbHRnsOrOwNmUPptHtSRkJM5QqklSiHR6
         pYF3n37UobYpnjGEGBtim+nPLr2OCdmsXGC9zxvLvpndunJyaoRwbasnxmzUWBbBioA6
         YyHg==
X-Forwarded-Encrypted: i=1; AHgh+Rrbs2YcX+275nwnAWGWCbuT5Lr3l/HQCy5Bvk+V7mfy9GJBkYTNXIE4nwm8zcfXD9PRi+F9Ca+9qQ==@kvack.org
X-Gm-Message-State: AOJu0YzwowKWAuBty/ds75TS0zri9TftFQY4hzjPbg9JZsggWTPfwjfi
	cFEnXsmvscM7MBaT1/Ig+8m2BPI+ZiRSS+HtVYP6xlNhaptKJp3XePUB
X-Gm-Gg: AfdE7cleamjgfa1LaytK9Milw67tV2KeB4dicqUhOidRPjiAW4VeY8mNsUYddLtVtb4
	RjxzRcwqZ2sAXcDq98jLFAk5vLR82VF5nLt2FUvcYPUVieM6lQbLQ5CYGpRKf6eG1HH9gUyyy81
	3nD4nJEoM4ZxsIg8N++bJ08eLTCRiLml6gL+3Uw2inRm6/IKEih/oT0PmfPVAu++Tka6ZFVcWIv
	woPF0zVjlDWZ6CLLTgBLyZwv8l+nTwbp0ISv250c9HQsnmDrWzj2o5NEbBWUbJqg3tM+JDE76rk
	PraAIWqeFjpgWVGBnEpKyjOk6oijY4v5l0cRUCI4oaHHBaf91kjD0zqwZ++6IHEBPbRxNLAqNQx
	+44BgaIn6DQW0seX0TmF7OdMR3vl5N/WAkXr2r45ob0ssdJfQztt72UZNriWxeK11TwiKBqMAhn
	CXgfDnVg==
X-Received: by 2002:a05:6830:6a97:b0:7e9:b4cf:d8cc with SMTP id 46e09a7af769-7eda4d90dd0mr12044065a34.32.1784640322334;
        Tue, 21 Jul 2026 06:25:22 -0700 (PDT)
Received: from [198.18.0.1] ([144.24.58.22])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edad94e86csm11116231a34.7.2026.07.21.06.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 06:25:21 -0700 (PDT)
Message-ID: <c3fc1db1-5199-42b1-9e29-e7766b23a599@gmail.com>
Date: Tue, 21 Jul 2026 09:25:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
Content-Language: en-US
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Alan Stern
 <stern@rowland.harvard.edu>, Randy Dunlap <rdunlap@infradead.org>,
 Alexander Potapenko <glider@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
 <CANpmjNMpKXxk2KsZORakwwdOpDG=pRbtJKi7doBt7QmQwUKdgw@mail.gmail.com>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <CANpmjNMpKXxk2KsZORakwwdOpDG=pRbtJKi7doBt7QmQwUKdgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5FED216000E
X-Stat-Signature: yztrpfa8jqtpsnwd637kfh8p3yrqc89b
X-HE-Tag: 1784640323-10750
X-HE-Meta: U2FsdGVkX18J1ybY2W1+vVdmjzdVtsRdFHGWeP61eDinhKSy3tthHQvF1ILLrSgyZofpGfNLTxjesN6ku3htMd3MAq2q9J8kCTsg3tKxxsKTK7lWNx6NfuEirKHPSEkrQ5wFjVSWECB/1mIbsSyq3FhoZPboP0B4TurMR1OzdNWL56PR4oCX9TyjcrUYBJoa2QrEeIQuy3Gkh09K09ZVX9IGXZoqx/JPPZ4tY7BEmhkRaG+WKoqmyR/mHBlDGi36giHixdR0Di8JhETqkYyz+XU9urW4yRNQS7sXuqLohB9K5USUJq/bnadQ/tiH/BQonOvxHrWUoBiIVKhrocVE+PZMMUqjWjcKPLh06nZGPAJGLyDVE4Eqy4E0/YqqvJmEhFyGuvqyT20EsiRzPV6ghYLGbgBikxn5dV56cLjYs0hmFsri6lV8S0SOi39Ld4TAMFqAfqMZSk7dVo1R5gTFazQt4zQBKjDCkZeKdcWMz/SRg7FeSujUHgGdiukuVDbknE+GJmOrdLdLiZVQJS2BwFZU96HpWHUu0Q/4AkA1M0XVUl/3W/jRw/nukJG+Hgg7vB2A5XdKsCTlwpQf6Big889Tp3dCbYs6aV+HG//DIGablDMQPmrBZQA9TFueguSeRtzPr/uTgvgCsHQ+ZwsbU8CFgwti6tUebKFc2zh5xJZXyI8nU0hmMJcT+e3GKDUrcb0UFAWWyAtIxgXu2yvDjpZK49656AQd0+TGaePVlstlvQDtjhzxxjPrrLPbaTh2DbbmWGosFTN8U0SiLW6f0Di7jhFWZbobPRtP93xGpNs1+9DgT4las3hniizheyn/6G2pzHSbjQ5iRCrEMLEjOyFFfd/hGLr79RSlYhkBBVRgYFWgg2Dn539SCFs2y+PwKSNoK1G28ESYMaScnF2ZSn4GVpWP9xX3ADu3/R2AcafNxE+i26NctYvw2X09EGRx/j/xbEROyI87dMbEdqG
 doEF/n+J
 gi30vKZS4ds7Cm9yS2+Zv1xNSYiahbRFVAakQn4kIk3lZW483zzIa/tbK45r7hrLo2Se7xNbgXF9K7e2Y0lSXzPP+AQljK7Pf5ymtmgjwK5Cjc1W5TCjHHvCQQp/2cgMj1+8TXYwQISO43KjqiFsHiwVBc0NenyQmUkC6X6Nd3A9zaLfmuzoqqJbLT/b0GFT8L2OmzpokXSGblYtyb+CHKfGpFICGOFbIV16zKrTGr6895BriD3gVu8OlQEWzWvKwz1jVe101OmwlpQq/HXvX+oMkMqNaj32YkZW3bHMbuXcrP977oGsNLSzrgJQwLhe24zWDJrDPMyxd+2oSU0SIIkk9Pk5AQadSmqjdPLTHFgs/kIuZgMU65mFuBdys0xtrFG63H7IZu2hr/hktthDubie9FGxgoxaW1WkORf731FOPPKG8qAL1WtKV9XplrzzrvubdR8kGPqNpuCHMJkUwfC7BXQSM/P228LmTOdJneWQVjt/P3F5ldrmntuBAYgOr0y48K4L4IFCUO5R2s77l4ivxk2xedgPR0Byxbf3WQx8LwNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/2026 11:26 AM, Marco Elver wrote:
> On Fri, 17 Jul 2026 at 14:50, Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>
>> Motivation
>> ==========
>>
>> The hardest memory corruption bugs are the silent ones: a rogue writer
>> scribbles over a live object through a stale pointer or a race, and
> 
Thanks, Marco. These are good points. My cover letter did not clearly
separate two different classes of bugs.

> The stale/dangling pointer (use-after-free) case is the main one you're after?

Not exclusively. KASAN already does a good job as a general
use-after-free detector. However, a stale-pointer write after the
storage has been recycled, which may no longer be reported by Generic
KASAN, is one of the cases that the scoped watchpoint can help
localize.

The broader target is silent corruption of a known live victim object,
including non-UAF cases such as an in-bounds racing write to an object
whose allocation is still live.

>> the victim crashes in a code path far away from the culprit. Any
>> single developer hits such a bug rarely, but across the kernel's code
>> base and install base they keep arriving, and each one is
>> disproportionately expensive to localize. The question to answer is
>> "who wrote to this object, and from where?", and it is hard to get at
>> with the existing tools:
>>
>>  - The kernel's own reports - an oops on a clobbered pointer, a
>>    BUG_ON, a list-corruption warning - fire at the victim's access,
>>    not at the corrupting write.
>>  - KASAN/KFENCE catch memory-safety violations: out-of-bounds
>>    accesses and use-after-free. But they have a blind spot: a
>>    corrupting write can be fully memory-safe - a *valid* pointer, in
> 
> Language-semantically speaking, a use-after-free write to recycled
> memory (be it in heap or stack) is NOT memory-safe. The detectors may
> not always catch these (KASAN relies on quarantine for that to
> increase the chances, but yeah, not guaranteed..).
> 

You are right that a stale-pointer write to recycled storage remains a
use-after-free, so "memory-safe" was the wrong term. What I meant was
that such a corrupting write may not be detected by Generic KASAN at
the point where it occurs. KWatch was intended to use a hardware
watchpoint to catch the write and report the actual writer and its call
stack.

>>    bounds, to a live object, written just at the wrong time or to the
>>    wrong place - and then they stay silent by design. And even for
>>    the bugs they can catch, KASAN's rebuild, overhead and redzones
>>    change timing and layout enough that racy corruption often no
>>    longer reproduces.
> 
> There's also tag-based KASAN (KASAN_SW_TAGS or KASAN_HW_TAGS), of
> which KASAN_SW_TAGS has an x86 version based on LAM (not yet merged
> though? see https://lwn.net/ml/all/cover.1773164688.git.m.wieczorretman@pm.me/).
> 
> One property of tag-based schemes (and any other lock+key detection
> scheme) is that upon recycling some memory, the tag (or key) to that
> location changes, and any previous pointer that still has the old tag
> will fault. The caveat with current pointer-tagging schemes is that
> entropy is relatively low (4 bit tags).
Thanks for pointing this out. I agree that tag-based KASAN can detect a
recycled-storage UAF when the new allocation receives a different tag,
so it covers part of the intended use case.

There are still cases it cannot detect, such as an in-bounds corrupting
write to the same still-live allocation, or a recycled allocation which
reuses the same tag. Software tag-based KASAN also still instruments
memory accesses and can perturb a timing-sensitive bug enough that it
no longer reproduces; hardware tag checking reduces this overhead but
is not available everywhere.

The original goal of KWatch, which I now plan to pursue through wprobe,
was to provide a simple and targeted interface to hardware watchpoints.
It does not instrument every memory access system-wide, so it can have
lower overall overhead and less timing perturbation while identifying
the actual writer. I see this as complementary to KASAN rather than a
replacement for it.

Thanks,
Jinchao


