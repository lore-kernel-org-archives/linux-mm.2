Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E52CEB363C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2586B012F; Mon,  2 Mar 2026 17:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825B66B0131; Mon,  2 Mar 2026 17:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7318B6B0132; Mon,  2 Mar 2026 17:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6487A6B012F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:31:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFD84B86BF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:31:03 +0000 (UTC)
X-FDA: 84502569606.09.3B11D39
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41A2F120005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:31:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=p0iUcSca;
	spf=pass (imf29.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772490662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jk0Kqijybusda9B544yW7IfQKkg2qqXZAJFFRTOJl8=;
	b=Ej7iXFWWVXrvvBNi3UODKXBnOtcRtwAYy3rjkjyN2CVVJCIHwLO/S73VFZMx2hwxTRj6bO
	b8sR//uZ/v8xjGWODKi18AYCcB3Ml2fLo8eUEqrT5/KvlSHl2cQRatrJ92ug7Q97cYOStk
	hZNlGxY6XLCRtIRFXCKoJZ1EKbloNEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772490662; a=rsa-sha256;
	cv=none;
	b=rJbYroRNJjjR5eDIgHBry1qcYTfwB9CFX8mBJ+zX3L8z9nzKH6F7tkjcCFG0IQ4jZrFgim
	KPtTu68VzfwMA6E4uxMmVheAvgqnMm/Poe3FiLsMnEnNFXT6fbvdBbuOKIgdRxGDC8msXt
	K8Z38h+uWUV6KAsKwSZsHpjF4eYK34Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=p0iUcSca;
	spf=pass (imf29.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1772490657;
	bh=tZvLePHDcA6nPS3DGdX3TVhrRB3omFsqKk8wwChJqvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0iUcScaLj+aHRl5SpbKIM9COu1svBq25PEsqKZFpE07xFsXZDs+LQ8jM2fjuYu1k
	 BYix94tXaFONt3XnduyscVQnXfFDgfEaTgmtkW6pBPLAb99hz8gtAmOjgQcojQX3Ik
	 f3B32p1a3xP4zlTahhgQ3weKmOtt/nXOE6SDwoaA=
Date: Mon, 2 Mar 2026 23:30:57 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Jordan Richards <jordanrichards@google.com>
Cc: dmatlack@google.com, jasonmiu@google.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, rppt@kernel.org, shuah@kernel.org, w@1wt.eu
Subject: Re: [PATCH v2 1/2] tools/nolibc: add ftruncate()
Message-ID: <596c05a0-caee-4696-8136-e89081b7c68a@t-8ch.de>
References: <ebf0c9fd-9c45-4aa2-8cd7-fe8d5956ce52@t-8ch.de>
 <20260302222043.2432413-1-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302222043.2432413-1-jordanrichards@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41A2F120005
X-Stat-Signature: zn5444xzx4mceg3e1ieu7t9gchobhuo9
X-Rspam-User: 
X-HE-Tag: 1772490661-269594
X-HE-Meta: U2FsdGVkX1/uyM1MXpoAf2qOAIjuPg+047lGgzLT8RMoZX/7BZdnT2b1+ETf5pVNihLYwMEe8Ojo+f+WCMugQqjYt0LRTcIA5IDBpwtwDIvwqAuf0wp9wVrfdG5rNJV19jTHNMY16Zr0nSVrPeK2LSJLZfLx/xmINGwfGgbpgDCukgeNzAiNPNH87yXrJys/9jJwjtSBrqNQ7pYozmg/TF6YweLUaY9TUe/Ro8jwguby2LiO8dq5wB2V6CEFDoMryZz8svrRmG/DUdSARLLiRfg3DygSvHjqOMBoBdiiTLN0gdHnzRXtQJ/UW7Gw7G2skIGl80wsk7KOoXSlhQPut8/c/Hwmyc+PxT4LxQSUoDP+4qD2abZc7S0c/KAIxFEq3WP2BlSsqVTL2B2Nb5vU5UwLTi2brpy3B6+KSiXzfgwQCAGl5TQ5InhKbKm7yyJ+cEHzqHdpThFfDRcZTZ1djzGEyixXpzR41yZEB2u8gMza7Uc2xSQBHJq62cfzBfxfQNLQhUColPU2Lec36+apcXUz/bsy5qlFLg29kB88jJx+Ik85RDUT2X/kxdWO34l/ZS5ECLGPMKaV7RzsQIcYCX/5s3od+0REwLWCBFJudV4OTXCKdKndUGnbyfEzy8sXOCmt//sDhMNB7HX3vVexfB+mLXDwWBSxWQ4UQyCg92gzE+chMsMIdtYo5iNgPzvnAOEWPpoCnkxvqGhP+0UvMZegukIy3PD1tRPTBF/iZDkw4iVcYNbFZVVL24GBdFseA4UY5KoHEKAFhf5jIATLag30Gk0tXIyoZdGcPIa274aM5iMDbSEkdO8Pk9Z53foaC1a2oKve7DXXqBLeGaQIHkdaWGsdp2YxodLXCOV99Bt5/7TLjqOMcFUYDftEYEwMJhtF92PaRhVeJko01QbwYB9d1kN7m4rNmuoL/rS8dXgqbCltrVSNXvq+TMZlJsguF7ZNuNW8bsWju6WHRvr
 GQvqAOHF
 BffHBcCkXpc+j3E46i819cwoNH1Qit+A5S7UPNVdK7z4eyk6J0UPUvTh3MtNAXnu+iQ8grPWfu7Eu9XJT7kJOwS0oFMGWkoJqAJtQ4zC0zUlcqah1mVTEYeGcX9sfOwMkZBg8GNFGoxcytMucje6bo5tgliTNhgXqXbM1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-02 22:20:43+0000, Jordan Richards wrote:

(...)

> > off_t is now always 64bit on nolibc. On 32-bit architectures however
> > __NR_ftruncate only takes a 32bit value, leading to the wrong kind of
> > truncation. Use __NR_ftruncate64 instead where available.
> 
> Good call. On some archs (arm, mips, ppc) register pairs need to start
> in an even register. I assume adding a flag like:
> 
>   #define ARCH_ALIGN_REGISTER_PAIR 1
> 
> in "nolibc/arch-xxx.h" is appropriate?

I would use a custom sys_ftruncate64() wrapper function for those.
Similar to sys_mmap() on some architectures or sys_fork() on s390.

(...)

Thomas

