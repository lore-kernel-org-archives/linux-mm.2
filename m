Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6027ACCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BB880149; Tue, 28 Oct 2025 09:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933528013F; Tue, 28 Oct 2025 09:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FDE80149; Tue, 28 Oct 2025 09:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A24A8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:57:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ECB1493E8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:57:16 +0000 (UTC)
X-FDA: 84047674872.30.2CC3885
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38478120010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:57:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=efrqwEo9;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761659834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bu9Jr2dam06sl63fQm0tPkTHNuZQtbs/dlOpqYwRSNE=;
	b=ceiuxvVTFfS9MW7ICYLl3LT+imeWiCkaNyI4LR/QFtHG0/NKvokuCnBOVLOA/AaNQ4RzT1
	O+Hww8TMGZXZi9aa7a5ZmxXfTujwE4eMh3e0lRUrkEzHFCTAt2uOsnNqmy9SMNQD8JoT/i
	NhU+ZPlYXAmEjuC+Ee3jwagoZ2sqsFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761659834; a=rsa-sha256;
	cv=none;
	b=DsIgeonFv6e15oYQrnRaQpUzoNf3dGo0QXyk7HVA0dGpbAOWKxUDFNavbxzdIk1xF4MVbJ
	5yZ8qe4ofT9hDgY6G2mV3EMYrVyc3YyyHWua8ojYB4R9WSZi3fchb7ef7b8jxzcJA9+AbK
	vhM8acg82iWFM+GxwXlZQJ5dZYpUv/s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=efrqwEo9;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EF1B840E0225;
	Tue, 28 Oct 2025 13:57:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1_nsMwL3qR96; Tue, 28 Oct 2025 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761659827; bh=Bu9Jr2dam06sl63fQm0tPkTHNuZQtbs/dlOpqYwRSNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efrqwEo9LcJeGn3Hp3jgS8IGZBBajA6sljLj7pC3IXfRxaIRC1IPE/zSM61vuj0lF
	 GHgpbzAdYeu8OJMqOok/GadSfjYgZf/aEMjpTwliPBEj7ctTmXpfWeF7cPLTF4Lc/c
	 plznYjbyLE9p0TNCRj8Srqri+MkwbTkp7iCPXsUx0xhZTFf89eJIMgucTTZaU8JRLs
	 kLHkhPL/fBE7940uAoc2g6JJfDVAgYOzttpih3lWkVsEIjMqDBYjTc8EsDiQiJ+DGk
	 lUoBcQ8MionCKQQeETUXNhK2znD3yZALyP0NJHWJNzXnDJwznbuOHRbwOSjD1TOhEu
	 Uay+B7NjUvlXgPM6QPPyXWojsGSuulnTEpno0Tw5nb/+joejPo3QnaWODsBim0wew7
	 g3Oo87lnimQYvf7IvbkW00qy0tApDI6UDgVtSuyNKghV0VH1cfFA/fjppDMai0z6rQ
	 gyLN9nygh8LPRE4ZiVEGnhqWvSpFVHyCo1oo60zHrqSbuFsdSJUvkKRaiRouHUOtCV
	 So119eeWpoaGbEBdaDqMTfvzFvSqo/xsPpfCpP2PXKaegEe9ItDsQCjxb0pL19YN2j
	 fPrDxHv9oBv4w4UeZ2iyfyo39t39g0hl+RRya6z2Pqhz/0UzGpWNqpr0t93djBWMfN
	 a2E0Plm2ZYfSbsJi21O9atLk=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3570940E00DA;
	Tue, 28 Oct 2025 13:56:48 +0000 (UTC)
Date: Tue, 28 Oct 2025 14:56:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
	willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 5/7] x86/clear_page: Introduce clear_pages()
Message-ID: <20251028135640.GBaQDLmHzCQDegBHd6@fat_crate.local>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-6-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251027202109.678022-6-ankur.a.arora@oracle.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 77zzfjkpnf5qtr6h93etbur5eqxdzhtz
X-Rspam-User: 
X-Rspamd-Queue-Id: 38478120010
X-HE-Tag: 1761659833-912869
X-HE-Meta: U2FsdGVkX19lq/JgYkzJCZtkn7MeBnXpCUeHPwxTAQfJjI0X9PmcL9jocEslPxBvIe0BowhpYJ9TZcZbu+PY6fKHXYr/cbKzxwyfKMxxic3MawuexrWBIDvFGnhPLfIk154+GCqCEzdJUvMakgEDz/NJnI3q+2lBsCb3D8SF4KoI0rT1Vg/197uGaUgQjh2X+X4h6UGyfL64dDDxV1T6eObyyHLLjuAGW8dCZlYg9t7tJU6/k54iQWXVTGFdNAGbJoPZn8r7aA3apQCJ+s0+LLlKr0IP4Iqiqw+ko9jnIIj5yYI0BTecD5ssxGVFC92FIEA1NQCv28TPJ6Jm/+WlBa+joc7vG3/ucueYeJCd3Rp7tAeP4SrCEqDCmObcHLrH3q/Wi2SuCuk+zyggiEdrfy01enOzZIUKJnrOnDECUXu2YCcfDSU2W7ysZt+uOnZyQnObZn/E4flmCAld2O6h5t35PQvyHuURP2SeWT65LTau9VLSStruen3qVMmBs/j2sCtfApcISF/NR6VnsHNA3IEQOLQCSckZ0XKKhTUAVU2aDtFZ7S+SWkXUEUcpTxwb9VPn0yj3CxfOt1OnU4DJz/APIkNviVDviV+ocd8RNl9Gml0KiBVwNUISy4Dy099ytF4PtbCqPalOzJSHLNBLOLJY4FK1dSFMaIEar4jUkvp0/9UGS0OUBwVFtZaB0CUoa6Dz0debWwiSjNRYsFCF2g/l+/BdqG6IogJeAqH4TIKVLe1TYinib4vvroVrL8BQYkCd1NL4UCccXubx6LSN9PNh9juW959dIsRRNuCh13D1Ao6YYUT+BUuIqQ3XivYaVVxqNrM2C/uWr6ZXD3+43kV7vi0Vl+vMXQAvCUG/Wp+iCAPvi5QtTa63k7EvsxiFyIyiMCBzD7r7K5DxthHdLFu5mUi78G25MWBrWUE6xu5xk1fdcuq1Hr0TkuVacQhrdqsDlC/RQYbwEsgEL5s
 kCFR3U7O
 xUp9H4noWKXHxHsIcBBamofzQzvUfb3GC77TK/+YvesDvhgsJ7kbJxtqUd4US5h8g/f2mev49QfxzKMn8AIP3NeF3Qwm3HVkc8qfBZ/leySxqW7bZV26MA9haEpg3ok5GIzZaDeea18mY9TH13HjPAB//uIEDzwxthBvlIw/W3e1QNP56vypFfl6o5wo9BA4ZG7rJDuOV5MQzEV+3vfL4sm0CzJHvf4S/42w+qUOWzd/ohPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 01:21:07PM -0700, Ankur Arora wrote:
> Also define ARCH_PAGE_CONTIG_NR to specify the maximum contiguous page
> range that can be zeroed when running under cooperative preemption
> models. This limits the worst case preemption latency.

Please do not explain what the patch does in the commit message - that should
be clear from the diff itself. Rather, concentrate on why this patch exists.

> +/*
> + * When running under cooperatively scheduled preemption models limit the
> + * maximum contiguous extent that can be cleared to pages worth 8MB.

Why?

> + *
> + * With a clearing BW of ~10GBps, this should result in worst case scheduling

This sounds like you have this bandwidth (please write it out - we have more
than enough silly abbreviations) on *everything* x86 the kernel runs on. Which
simply ain't true.

> + * latency of ~1ms.
> + */
> +#define ARCH_PAGE_CONTIG_NR (8 << (20 - PAGE_SHIFT))

And so this looks like some magic number which makes sense only on some
uarches but most likely it doesn't on others.

Why isn't this thing determined dynamically during boot or so, instead of
hardcoding it this way and then having to change it again later when bandwidth
increases?

Hmm, weird.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

