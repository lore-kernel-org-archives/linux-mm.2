Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13773C79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039246B0092; Wed,  9 Sep 2026 22:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B706B0093; Wed,  9 Sep 2026 22:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41C16B0095; Wed,  9 Sep 2026 22:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6B296B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:33:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 399B51603E4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:32 +0000 (UTC)
X-FDA: 85196281464.15.AC04513
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17150A0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dRn6NekY;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789007610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvBCsqM24ZHvzS1IiTaODTjyVXUo3s7E7NsLy/NcZk4=;
	b=AdIPjh8QHoY67C0rySgYFKHzMgIMkJvfdmc/oZ0ys+5/LUUGr0cnPrzoQ6vQKHEqf2oQap
	BA8BSrj8HpZ2zolWL2Vd9XQp7Rb8V0sllNwnVYFeEEEvRp194MTj+L92pcTFKRgvy0Lh4C
	wByWgbw0PZB6fWdNXowYoncP8SlUeHg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dRn6NekY;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789007610;
	b=4VWUz1b3ND9ZUWgNeMRkrvcd37PG6tyIX5gejy1mtbmshLZ8u2nBclksubPMEZ6kEOyCgp
	Y9uYfkGqPBKqiUFA91DinCnvtKeZgf7Xr+zSOt2ezlyOPvUWXZspI+E922Y3gvqjzxZQkK
	S0kr/8joGPuZmJAQm8HyFBPhzC8iagk=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C0F0740E00E8;
	Thu, 10 Sep 2026 02:33:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jYEDatXiYrTV; Thu, 10 Sep 2026 02:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789007596; bh=CvBCsqM24ZHvzS1IiTaODTjyVXUo3s7E7NsLy/NcZk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dRn6NekYce19LgPIiJKdKDlIra1LFGukMMnyhazzpGuX7O2os37VW6mg35w2zAFR1
	 uAn6R/KCRz+zijje1ImMSPYsXTXR4JeGwGbNOmIZw0nc1eWG7uwtS24eVpgtqhzjpM
	 UD/fVgyKFL4QGtzKXn+r17S9HHNbvm4WUayUOXAPsJA1KRrNvwITtrrRqLBNsTCuo/
	 FXfZaxsYAJaOF80OguKz+Yk+HhbXGj6R2CZnIUoQDKdiRVghx5EkL9maNka3KefPtq
	 UhAk2Os+w8vfGt1P6M52avDuHD141lwpb3jsz20e67v4bboTfSg/lIGkL0Usy2whba
	 lXMQZr5ZmprJrI1RgnYRm4K/ZMCGD87SwAuhJzFmzgGxnDDbZCsNugn0Ia1hQDyqYy
	 c1U2hNyM0kMp94YrNsoudZuirFRgmt5NDjvnbc175iHM+rk4Al/2CJ8DWSxTP1Uhno
	 V3RtcbSJAQJeRZ9yOgAaUqzxvN4y7TeFZ4Bgyy50/pU9LrLyYXl8F46aLbTGGhdyL9
	 xVzUCIYbzAujK/sbpjalZrMn5unbTUA4eK+KGmsJUd6HEE5YIpzXnwxqdgsrDoiftY
	 EQcfBxuIyMwpWQRQhxv+qDP1GjYvfbXfxSJKqDTWPT7cMYmczuMzwshoBF7ht8CkKh
	 WDYmmmZDMNfWSCpkGl62SoKI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F0F3240E00B9;
	Thu, 10 Sep 2026 02:32:59 +0000 (UTC)
Date: Wed, 9 Sep 2026 19:32:55 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/5] x86/cpu: Factor init_cpu_info() out of
 identify_cpu()
Message-ID: <20260910023255.GDaqIW1ynrVQBDcESZ@fat_crate.local>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
 <20260814235134.3461435-2-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260814235134.3461435-2-ihor.solodrai@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17150A0004
X-Stat-Signature: f8x4bgt74oibiw97g4oeanpphr6yy6ao
X-Rspam-User: 
X-HE-Tag: 1789007609-339934
X-HE-Meta: U2FsdGVkX19HEyb7KRxSpYS79KxPlSnKmSBpnpWYDuw8aedj2gWFjNV8swpCPSWZOdCJL6zb9gAIG9//jlssUFTGpgYyAN96GOgqeovCXyjW2mPWU5Taxg/LIoNuZGqYqSxHxvk/00RhhueArNwF6h2c8XaNKEH2ebHMuH9idMkhyhYBTm/K53iy8VTZD9YLr4ggdad+LI0B/ZSf6qs42pRMArHA1gmdRLBrFSxxL7SRDTZ08DCCzfoaArtyLJsrSos0GAqfAXRfCQRsP/qsZ1hzpebsVWqB3qqLD8h/JnYgorNJA0lRGTiULEOOMCVahaFrVL2wVkjKW82JUDrHjORQgHPAbplYr9VvKdpMXnWBbpO9aCGzOs1BVB379fiwVnQz5v/Upju1Kl9GrYm5EffTNNKHiskS4yvvrgUGWeZ53DXvnzzGiaeGNjWif2INuCkulENwbNDpvI7iX48Bf97n20xs1Tq7KNlC34roR400gI4PkwgVJ8dJayrfPEVeRfXAv8HU7uzrMmFVZfVMDbcjHD/8cTSk6jYrtikq6n8+IdPVymz2xHnUMDgq//yydflLQKe5/PuP2zHiAWvQRFBwBM9V/nPD/hm7oFtzRAqyPhSGqEsHXekAJxP7yoQVIiVBZIkbx6PKvCjhD6zdMriQoiXOXuD7Bd1DUdl5ZzroovWO7v/yrcs5gdtIvNkqVSxmFZMGKV5Whivbg2CLhrSU/r2vWWPC2DVj3QVVDbOknKA5ZUk5jRD+KS2euJDJ3OKPc/XdjWrdEBMUvFvgqO7X6Ce0CKhBjtAjX+Xkz6uS197rvzaVlLpHdwGC1MQOkTUCwnXgAqS55OmpeVGYpQEX1GblqnSth745gjlrm7edYe9Z/nCtqV/9yLvpFPetOunXvFTwDR/aLjTa9Ax3fBg4BJX8DMs8/K+K4audN7rPPVBw7rR8QpLzq9CAXcLbS2bX+9aXkEgQc9OhMsd
 Bq7dMkjP
 tGSDYV7FXWAZRbo0KZBy2ITtJP67G3fSJ9M+ZNHKlaY/+7i74Dzky2ch8/dahk6/xa09OmaKevmINxC03X6sLWVcLALr07wOegrlxgoh0xiOBv/EGVw0DqQmACjdG9u092lsndqO0W9MF2E0l5B9Y8mh7w/t8wj1y0WvXUNB6qXMmo5HVPBYJkqHjV/nL+MmTcmMZJ1o2XmKaBzbocvSqg8v6tCA6UmIYYtKtlwdJ8M1q7XlJFvqvaecBY/MCx2NqixndMhzYWZMf+5iqvk9S/US4QRFJfj4uOA8b0UxRftArn3Lqi6nwmy1wIT/9pBROlgt5EZmYciWjxTTFkuryNu/z/tDvqsXoj7hT6KEBUTR07WtdBNY0CYzD19BUf1+16vk4N2RZsHJjg+T1luoH9w4Yb6WnBr2dEVTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 04:51:30PM -0700, Ihor Solodrai wrote:
> identify_cpu() unconditionally resets the struct cpuinfo_x86 fields to
> their default values and clears the capability arrays with memset()
> before rescanning the CPU to fill it in again.
> 
> However the boot CPU capabilities have already been scanned by
> early_identify_cpu(), with interrupts disabled.
> 
> Introduce init_cpu_info() helper in preparation for letting the
> callers decide whether the reset is needed.
> 
> early_identify_cpu() starts using the helper in the next patch.

No need for that sentence. I'll zap it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

