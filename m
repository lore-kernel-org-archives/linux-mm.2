Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEDCCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D256B0088; Mon, 12 Oct 2026 15:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD696B008A; Mon, 12 Oct 2026 15:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD4C6B008C; Mon, 12 Oct 2026 15:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459EE6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:21:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA815140B6D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:21:29 +0000 (UTC)
X-FDA: 85314943098.18.49F2CEE
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94340A0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:21:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lHiOLo54;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791832888;
	b=dA+uCdtjt0dqYNxz2CorbzMRDY8Sy+bsMWSaeCpdBsMVJ4Yfa14LEW3JNV6dK5Ry6UDXho
	3twDZTIzjKeQ2NNVszXdmTMXqkQWqt7mGK1ve2UeCEFpOHlQOnhUu5xRfkjbachwPCqNA2
	NAJ9w1KWGEpfRFwT4otIBMQ/Pka8Mu8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lHiOLo54;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791832888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqFeSQEBcvFM0X4Ltoz0Z2wIxF05UhXGwoaGo91n8pA=;
	b=c4zngdF5BzGxPmvUM6IwVWW/cR1C9G3o+9X3dyfhZZWipOANmEnG3zMVM7g6vszoUQcNiv
	OoJh6cA24s84+xc+ww8uw6gNGWVJFLxcFMf6MalVe9+ZsWhc/zQ+9+IDsB0KPTb3N0Ph3i
	XM+4VYI2BWMID/VK4q6xRU0OKj23ac0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 74FBA40E03BE;
	Mon, 12 Oct 2026 19:21:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1GdfJFy0tNit; Mon, 12 Oct 2026 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791832881; bh=WqFeSQEBcvFM0X4Ltoz0Z2wIxF05UhXGwoaGo91n8pA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lHiOLo54sbzzTO7dznYp+Y4m/v9HN7PwdJ8P2SsFAczM2V4hyWgsRW72kufPDQJpH
	 v4OxWMEybbdRryY8sPq/8YQhD2efK6TYtuENUchgKoyFb36dA/H2Sa0XNM9owo/rqb
	 E0KA0imoFWDBZ/eziVfTSuPEwtl1URFtErQIs7cHBlgMJUV8+XEgEHZJJuosI7KqDC
	 j5mq+0vh+CNHHvVkEnaa2awrwBZGM2GjyJd5UffTmIvr6GsdKVW6ryV4PkoG88ZS8p
	 +r9fjKR8n2cbjWJSTX09oXbKjAwMgDWuna1Y8SldVKLVM15XWqenJc9qIE4tAETl/G
	 BeqNJYgKUmaNrEp/Z11UG9S+qEz8dU/zwHhz4clR5Ip5cwoQyWTc0cH1sLawM0PCCu
	 pFIvMgyv3ty2VLXc9M2AUKheZp7PMLMfBVyDngubaM4fcW3QaQX3qFLYGQI2oA8ZM7
	 jLRWGmLut1vo5rZeO44GDBWUzSo1vFo6zf3TLZo9MqgnKOG5d6QpaQMuI4bN6a12j3
	 YNCaeBrLEwTKRrh8WxleByv60ioVG1Xrzy1t3xlu4OsF4GeMF/wj8+K3RtjjC+PrAb
	 4SHHxeS4V2xf0y1ddusq1MHJx51ANrg8Pp5Vl7bTEFQviXgFVngQheYQ+aYmGi1pzS
	 32wNopL05/harpXiNO71A4xU=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C5E4E40E02B3;
	Mon, 12 Oct 2026 19:21:09 +0000 (UTC)
Date: Mon, 12 Oct 2026 12:21:06 -0700
From: Borislav Petkov <bp@alien8.de>
To: 1sh1ro <yangguikun19@qq.com>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Thomas Gleixner <tglx@kernel.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <20261012192106.GAas0zIsS_fb6dgtGB@fat_crate.local>
References: <20260624234510.GHajxsBgG62PHgEZa4@fat_crate.local>
 <20261013015904.44144-kasan-early-boot@yangguikun19.qq.com>
 <tencent_8BA9ABDFF623474ECBA6E251A03E19512808@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_8BA9ABDFF623474ECBA6E251A03E19512808@qq.com>
X-Stat-Signature: z6mhz116gig93uw7uykjjkx4mdcmkcwj
X-Rspamd-Queue-Id: 94340A0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791832887-789064
X-HE-Meta: U2FsdGVkX1/mOodBPFIgYxK3r4Gg4oCEXxMmtXdQNQcFIS7rtaoM2qpOyKGT5r/Zg7LIuDvtVNA/zjX6167IZecCxD3OEklszUe1pDDgn2gT2dtJIPJw8S1I8zSEF4i/FO5BA6y8bqoa8PcvBjIBsy3syAdn8isuO0nYtPIooJcN4JRyT1xwAc3OFgOi/weF15et2bS8BTyV9UxaPBULOpqMy3KXRCd0dBX52xKdAPaicFx75pDnaHngYzixvXvub5nzRFIUtHRRICjWQnVPOleP5eJYXAdnzbqW3y8D2HAx2w7qcpLQHlGm99JWIaBfuNHjMuD8TG1EJJBSaQ6n2JdCdYlHRw/XSTErQcFpiwcV4YYoHT5l/a/nfuJiUD56wLhK1VjVvRN3MunY2iUXqUrvOAhvypJYcYjHDwkSEgI+aHsjNehdYVZ8kFpDnM3sftDTfEP87BMY5u9yjbSyQYzBCPn2JZ/4QxI9ZIO7clgGm0Tt+A3wDT1ahyAmBXIuOCXPsvuTwWzv2eKkwx4hIycHJwOFhQnvc7gjVlBNTswIHxQmrSk8nlZ0AFj/nocYd/Q9QayxL0S3ZNcZ8aNeW1BF7VetJU9S2uA61/rBs44xvSx3x2eto605KfWbH/g783T9CK3o3PkE5NO3+Dba2XQGKdGNTD0+KIHSoRFXrPW/VXhyy2mahDgl2jW+1S68+j8t+2DXd4dckfAgva6dQFrs2viyH+0OqAJp2g7RGRFX9AkqMuWhG69oGvELyInlumOMioBauvB3RrSUKNZttNCeoRenvgDjIXPVU65p49lHxtVzAzOhS3FUJHs9UBpoSFcQgRMns72FdEc421M/gm+o7TVCIFuXwBt1499mDdonVklZxyvSdVWYYitnS8AAR59ejiJriPbFKag3RA/cv31gqles95PmoaGtj/+SzIF7UhunZs9OR0lI3geW+i/4bqgRn8CsV28H8jYrXhz
 XQfTGslX
 DAhNL2z9rsbl680TLEc0I40TZbmIOZQ5Vdaq8eNZQlJH1VZVgtuKnIDOpGT1EhXXxs7PpRx1rbyHLkUhEcwZVZW7z7cqZWHLtYQWteHHbFwl6Utb+VJcROuSzGgUCtxkI8LtVq3jptovYMAm2Mob8Ei3i0NThsfvExoGlsbUZ9oPusrszk/5gWKQbl3w14YflmvrzHsqtnYy9zlq6j9gjdTgAIAZzrLJy/t4JBRpHjblsW5AdbrcwxhNdpyqEUKkbCJM4OUtKl9juJAmDMWyAj4G1CRnzGC0bUtY5Z6zYMDTuPhLVWn9AzcIR7pyGkNhquZR/bu0ZNv8/+N5d461eyK/0X0VCH+64rdXi3B3oovXo71pCO35eyh57xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 02:06:08AM +0800, 1sh1ro wrote:
> I hit the same false positive and can add a data point that seems relevant for
> the fix: it still reproduces on 7.3-rc5, i.e. after the CPUID rewrite that was
> expected to take care of it.  The rewrite is in 7.3 -- get_cpu_cap() became
> cpu_detect() -- and that is exactly the function my crashes interrupt.

I don't know which rewrite you mean. 

If you mean those patches by Ihor:

2711d67bc3a7 x86/cpu: Don't transiently clear the boot CPU's capabilities
db349783ca7a x86/cpu: Move 32-bit SEP setup into identify_cpu()
ad86fe2134cc x86/cpu: Inline generic_identify() into identify_cpu()
7a762b51a149 x86/cpu: Initialize boot CPU cpuinfo defaults early
54a2882ab9f7 x86/cpu: Factor init_cpu_info() out of identify_cpu()

they're in tip queued for 7.4. So not mainline yet.

You can test current tip/master if you mean them.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

