Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098D3D2ECE1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 20:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDF26B02C2; Mon, 19 Jan 2026 15:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4E46B02C4; Mon, 19 Jan 2026 15:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB436B02C5; Mon, 19 Jan 2026 15:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 494B56B02C2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:38:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED6A3C1076
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:38:48 +0000 (UTC)
X-FDA: 84349877136.18.0A8F919
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A5B540003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:38:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768855127; a=rsa-sha256;
	cv=none;
	b=E7wEMBEaQ7kg1P8V2xE3RU0hDc6J3VbUgGwsyMXjDocQZhShUk1cQihXykwR/WbexDffhI
	Xt5Uf2RZkSvoDLLMdScC9ro1PxOLUqBGOFrrn8aaSgHzIH8OU335fYADordPy2xxgWTlJg
	uS0o5mTqWhr/c4d5dPdgKr+lAj8e9Ak=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768855127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqAdMoCLDfxesWeXSjFPeXninStgY+7qdqGzoS26PCI=;
	b=fqDnf4KMD1MQ1vkh730ooRxiBky2mM+xyuD4eMGhLrwIoZHS0LEpF0r/i98Xfg0F595GCy
	+O+m6TMWJJBMgfVwwgjeo7qYhOEaK71fL8rm5oCilFOmzOIc4np13shAXESLEFuCOe9GLs
	Kvmhap4FkHp48MxzTHn9d53jP/V6mpg=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8887ac841e2so36445646d6.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 12:38:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768855126; x=1769459926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqAdMoCLDfxesWeXSjFPeXninStgY+7qdqGzoS26PCI=;
        b=kWFvI0ZhH2hH57BxgdEUHE0yYiZYk08KRyWNmCpYrXVB4FL+yveP7+Qh/b5Nc3YJR9
         lzBwitqE8R5Jevzg4w+MUrf2Za9wRam0A9MHBEeSJ9Tfct9Jnhb1Oz/iMhR75Rxsj5Fz
         0S6zp/Q/bf7xJrJQj6WObPvA931Mvh10TcZUULALAo6X+b7mMpfI9fuxOTvV9GAz56j6
         FVGeJWuob6tpmdX154eRmURoaqJPEoJJR+C+S2enYQ1WgRr4xWKCb4c7QVPUMT8lu5W0
         K8dQGs5VLUFmst8qvpFG8k3f4Tf7bDjZ0lTmVLEr7/Ttu99wbxy/OyjrbZDJD8Ud1ApP
         X5Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVvqoR77z/3S/hfbpoJeZYgqqF26pHVbFoVeU47vcjg2eJfNUNREV7LJs9eO6Qy4Yx17Bb3Avp6NA==@kvack.org
X-Gm-Message-State: AOJu0YwK/zYJJ/VLvuuOA48PW9aX7lXCWnD078tU2oVJSiPMvw8n3JB9
	N/AZ/byQMxOsocAjzzzBIQyEIKIlcVjtPgbQKWmObQbfdNo2LfNI/oxgpgFboQ==
X-Gm-Gg: AZuq6aJZUOqj/VuvZY6IfuB0VJaALBz0dFGDS2m2RYgKGBluYXJR2AeILQUOQfsn1eJ
	TZ2bYtUvLyqoEY7cMCQ61ty16qg9qGh3/XflpV0LYEq7RDnqQ5LBQnMYJR0sz35WLqsGXMsirq+
	yvU+Upjg6vjd5AMLUHLwfR24ICYY3Bwh8yAt73LUva2YtvQ4K2VLWYmpqj/0MyNdf1hIJU2OWaK
	DpE8n0jj1gUgAlB3XpNdy1MFW6hDb24sW2kG0cQ/y2ftvUMO1yUlGoBuL209GaEzD82fa/BgtTH
	YCYcMMLyuxmM4vqG6cAuIY+V+rXcdO2R4fmVqEpIGaj9KQtB0EU96bem4p1X9NkrQMQK23nDtFY
	Ciqdu0E3CcgvgwKqzDv2TWbtmZFIBKgYbbRL7jbA9r+tU468Yfv5hNubaFEWHgKsPEZlNdKJC7e
	THaA==
X-Received: by 2002:a05:6830:6d0d:b0:7c7:568d:cba with SMTP id 46e09a7af769-7cfdebc991cmr6635773a34.0.1768848852118;
        Mon, 19 Jan 2026 10:54:12 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf000b80sm7154662a34.0.2026.01.19.10.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 10:54:11 -0800 (PST)
Date: Mon, 19 Jan 2026 10:54:09 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org, 
	rppt@kernel.org, graf@amazon.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, ricardo.neri-calderon@linux.intel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
Message-ID: <z2lraqiivexvfvokff4gmqyvbpswmfwhbkhv4u7lo3nnnyz346@mibnt7dkrvey>
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
 <jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
 <2vxzo6mt7cl3.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6mt7cl3.fsf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: s1drxafhrf469bwmsxy393c3oyytcuot
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A5B540003
X-HE-Tag: 1768855126-902146
X-HE-Meta: U2FsdGVkX1+wg5unRuw6wo/n/JfFMgP2l/Rhl80jUL4OvUYv78GizzvN4oxWPbRW0P6eDwE6b+PYXWClkOSD1XXnEvWo88Pvs54Unf+4mJZ4vljyQ1MMPHeuI/aq/aky4ZUzQhxvPlzfC/Mijbk8Qx6RweFXhj86MnX2pOhsItcuvFqJOxLpH3zKdmaBKjOuYXm2zRQYt6j5NYYwy0RKLnk9KfhUebdwL5H7K0BZBunGQDQkAdTct0MYSj11CWK+dGBvtpFdWFhcuMjhohucfQDJb8E7XqXqkGcCS2oVpBozd7yv120feUXT/hfiU/zTq9yRG00lN52UUG4HKgShuFBsNvMdKPy+3bWG5cKoCL7m7K+itqSfSSjG2MahCP+/SwOduwYNhet2Nb1qloPLHibrYmhSj+VxtwE1uKCUSpidbC42kqr7HmEq7l9ujzTVD1S+Ec6G4N/HyQkmhbQF+7geMOrZpn5cBY3/t2VTa/c3S7R+Kf3f5m6ShIX+3RWi7/u/H1mER6yUyEY3cS8TzQgilE6QwxyZ4p+uhPA6WuRV6glBCUHAhBCLKG2ODy+WYnfXExukm2XrJ6KUtyOeEt54R4208+7/9MajBGdqpBMy2kp9RchuO3NmnYv45qT56bqMxlwnDKJI5pL4sdO2YlJihuizjb72HoaRCeKMXImElsnjagHiNIcEOiLQufn+jM+MEXA4eQcULDOzyH+cBujOLnzvkwxFEQoDtThEnr0ORfuMJ2yO7SDY0IVzOY6+KD8+gEfrg81scxe7nCZ5ZjnolZfKQSfizHkw4+SdqfeqH+LNqeX2lSoVt9D14INUVZ22wux0yIEaQiOjDa63/xDKlhodh4mNkKXmrwXeidDiiA4SaUq0hcI+fnEwKSmVz36tZjcOE7osuD8zAhaQv1mDizyAefFUTv41ROlxZnnbxw6KK8bM8D05pRyedbch+1Qp8oHRS74Ae1McwOP
 CYj4yKEL
 eqtg0Qx/avtck8e6ofzfXafLxgSvaBLIVDMNmpU1Q8WzZq+Iiao/X8pkZzoCV58EmZRKDv8dKHaOP031nh/NpzGKNtJxjYPOYQkM6SeO3M2NfyauQi97qWkNyeB9WuB2TmYpITHRoLTiE8rDv9UjF33L3vL+sfWxxb/tt7xB1NoUFOSEi8F/DsrR4GqpSNEGP+FR7pxRgpkt2edWu68s4BuI6i/MVg+MNN4cNYZo6+hbprP1oTlIAod1RKfp2shYFDPWylsOWKW1TrE49wqK32NKLIhCQ14qlSyldHsjEMG8VXimf9ehgC3EOwgL7mDisRG75u1ZHb8rSISoCUC2siHMXbygerZpduY6HzZnC8t1ikhmTjho9r7pv8MoTwHxusyRcBzhiDBQS5efF4o4DBS4lTm7hfHmsCVhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 04:21:28PM +0000, Pratyush Yadav wrote:
> > On Tue, Dec 23, 2025 at 09:01:40AM -0500, Pasha Tatashin wrote:
> >> If the previous kernel enabled KHO but did not call kho_finalize()
> >> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> >> the 'preserved-memory-map' property in the FDT remains empty/zero.
> >> 
> >> Previously, kho_populate() would succeed regardless of the memory map's
> >> state, reserving the incoming scratch regions in memblock. However,
> >> kho_memory_init() would later fail to deserialize the empty map. By that
> >> time, the scratch regions were already registered, leading to partial
> >> initialization and subsequent list corruption (freeing scratch area
> >> twice) during kho_init().
> >
> > While trying my new patchset [0] on top of this patch, I got the
> > following issue:
> >
> > 	[    0.000000] KHO: disabling KHO revival: -2
> >
> > Trying to solve it, I come up with a change in kho_get_mem_map_phys() to
> > distinguish no memory and error, see the patch attached later.
> >
> > This is what I used to test [0] on top of linux-next. Is this useful?
> >
> > Link: https://lore.kernel.org/all/20260108-kho-v3-1-b1d6b7a89342@debian.org/ [0]
> >
> > thanks
> > --breno
> >
> > commit 5d7855fede8110d74942e1b67056ba589a1cb54a
> > Author: Breno Leitao <leitao@debian.org>
> > Date:   Thu Jan 8 07:44:08 2026 -0800
> >
> >     kho: allow KHO to work when no memory is preserved
> >     
> >     Fix KHO initialization failing when no memory pages were preserved by
> >     the previous kernel.
> >     
> >     Commit eda79a683a0a ("kho: validate preserved memory map during
> >     population") introduced kho_get_mem_map_phys() which returns the physical
> >     address of the preserved memory map directly as its return value. The
> >     caller then validates it with:
> >     
> >         mem_map_phys = kho_get_mem_map_phys(fdt);
> >         if (!mem_map_phys) {
> >             err = -ENOENT;
> >             goto out;
> >         }
> >     
> >     This creates an ambiguity: physical address 0 is used both as an error
> >     indicator (property missing/malformed) and as a valid value (property
> >     exists with value 0, meaning no memory was preserved).
> >     
> >     "No memory preserved" is a legitimate state. KHO provides features beyond
> >     memory page preservation, such as previous kernel version tracking and
> >     kexec count tracking. When the previous kernel enables KHO but doesn't
> >     preserve any memory pages, it sets 'preserved-memory-map' to 0. This is
> >     semantically different from "KHO not initialized" - it means "KHO is
> >     active, there's just nothing in the memory map."
> 
> This isn't true. If you hand over _any_ state, you will at least need
> the KHO FDT. And the KHO FDT is preserved memory (see the
> kho_alloc_preserve() call in kho_init()). So I don't see how you can
> ever have valid KHO with no memory.
> 
> mem_map_phys _can_ be 0, but only when KHO was enabled but not used. And
> that is of course also a valid use case.

Oh, I was not finalizing KHO, and in commit e1c3bfd091f363c1
("kho: validate preserved memory map during population") started to fail this
on purpose.

So, I understand we want to fail if mem_map_phys = 0, but thn FDT was properly
passed (how is it possible)? I know I can read
KHO_PROP_PREVIOUS_RELEASE/KHO_PROP_PREVIOUS_RELEASE from the fdt, even when
mem_map_phys is 0.

