Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2775C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EF06B0093; Tue, 15 Sep 2026 19:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B194F6B0095; Tue, 15 Sep 2026 19:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2346B0096; Tue, 15 Sep 2026 19:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBBA6B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:45:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6C3B1A0590
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:45:06 +0000 (UTC)
X-FDA: 85217629812.12.4D7EAC2
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id D25984000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:45:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=RAknP2JI;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789515905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sua8TdP0bzU7O4yeelRGte5eUw3jSiWCDLoLEwBKAG8=;
	b=Ua09ZSFE2qIoJP6IASj62SP/xwiHpFddOApU4Uuwl/cYuBAjs/nsM/FfPJeB80rw50TKqd
	Il3psA6hQrGHGGU7aTGxrrww6vrqKPgZIW4yqmuntfe4T16sKB0odRBxvG0Llj6l9LAEWP
	yBODpzZAA1+uEURqt2xBJxvV7f3x4Ck=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=RAknP2JI;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789515905;
	b=JDoF2rCWqirIhcnM69OLwhQMnb75Oo/RrAeOOdt0l3jAW5bRYl3ldK9b/cqIDRvzRXlip/
	zrnJx8T+9icAcbFtqWyjqUaFKWtLjQHVzy017gKDAnALETB0XMB5jwTOJb7OJ5FZovhHiA
	oREF05QJoJu3+iBvmqCQKfLoD+pph3s=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B784F40E022C;
	Tue, 15 Sep 2026 23:45:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ae8IO3rTvQBP; Tue, 15 Sep 2026 23:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789515891; bh=sua8TdP0bzU7O4yeelRGte5eUw3jSiWCDLoLEwBKAG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RAknP2JIIeZeK9h2G6f7LQKJi2k5OGaS69ajtnCTxRXTaC8rDSKcw3rfCyh36WSYM
	 XTodwHxgxmHJkAUBCscwjdaI7IurnTLuy56Mf+IlHgKYJe0zsBbSJWdnda62a0Bely
	 QiPpan9JKstIIIn3knRU+gquXvL947K+2sx7h7V4mxMYdEPDkvkpOz+9sDJDtf8nfg
	 4aUk4YEw7L3pqS4njz8vnELlHnX7ZrmZo25YiVDULWMWqJsD00IhQhvYS+Z/XkRq/T
	 cXDZw91A/v4f74mWiPGU+LCoK9XRP0i5oL2NyDw/Sm+g2uY3Kwak4u5TQa3QsQceBj
	 TpJtWBdO0Qi1kw2Y0ganBEJfh25EyykpdJns4bmKncnFJ8kK7L8lQT/dbScNzWPKcF
	 zI/9/XxXmw8Sruq9lZJVfoFgNB0OWYQ0sz/asKojYX8UVeaX2Kemzk13JB54jKvzti
	 8wQ1NpGIkwAh0GP9Aa0M5ywUt211LyT/dIe4S2gyNWT+2QBq26BJFfXFzEUQl5aLBU
	 1FntjsvFhRI//EvqSOWRDGzGVpaRLykBy7tmhmeW0sZIlheiZVygSZpBLvyqgmt2+y
	 ilj8H8UpfmZcrk0apH1Suj2S73UNcQ0K/iXZSp98PKr2POmhr3wA8+8gusd1bZ7u0m
	 bDABwjYU8hko+E60UbYYfDuc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3288940E01F9;
	Tue, 15 Sep 2026 23:44:35 +0000 (UTC)
Date: Tue, 15 Sep 2026 16:44:32 -0700
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
Subject: Re: [PATCH v2 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults
 early
Message-ID: <20260915234432.GBaqnYYPlPud4KssDD@fat_crate.local>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
 <20260814235134.3461435-3-ihor.solodrai@linux.dev>
 <20260915023115.GFaqit8zcWHGkAdHD5@fat_crate.local>
 <a6f41d17-62f0-4ba6-a8f0-bc18866d2784@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a6f41d17-62f0-4ba6-a8f0-bc18866d2784@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D25984000A
X-Stat-Signature: d4axrkeaab6d9fthxb7c9doj4w46x1th
X-Rspam-User: 
X-HE-Tag: 1789515904-978395
X-HE-Meta: U2FsdGVkX1/PDcNXVVFW1Ur5QLtXCUnzPzmizASPpvZdcrB960g/9qS4LS91UdxCpYgEryPs9aGWRWgrYIKFB9HPOPBvZRzKfkiWGDlZqXS6jaeriDNzG07ShCKvCzYTiiKaHvyYiBW0Dzh/g1R3MgNFPh9cZoUw4WgwI9t/jNeXECBJS6IbASJ2kUJJYoYFFXZd7C4B9c1TdModzBvpYEnyopH09WCb6f+nh8S2dFiIvHzEVzFGvd7Duv1CG8Cex/HNKMrkqGkm+TU4fWRN5+5ZOhiIcwnCtaXWAHXiTCzYbfoGDHlw8LnkVpkn4UcAOe2BnVqS62Bwg81i/EhG9wZXamZ+MajuPCZz25ysdjOcntOR0V6guEML+pCWfm8vQV32yLzHPaRvE5VLNdXgltHdXkh8/P4cm/KZELjmkiQEYh8jlOPgpFXh8hfss6ihnelVpm8cPCPzC02bGbZopN6hi1LAbzyFRQ0MukJzCoHSjQ+k0zF8WpSqZcSXka6Q3MTxt1hFpCGB+eiRzK6sIXA1d73EhgLeucvT892bSwATFv9TSFvar8qrMiW/1538aF0WAps6862xAg9UiYanCPdqio4tQegcLY+JefBJU9eDbmipTmKc1yWWVcfHAH58WUhaKYdtXQO5lOU53f5Zdk7PURzWnr0zMY/CCrnm8VLjU46zPYHhkjY/YAz8GtOv2UYYcf06K0NdTaV7/oaJJdKIKZRp03VPTxO/tXH0GlFT+kf8NoUHorYiIhOAjWPDoGM98nKFiASrYKN+LSkLXKqatrGXb0R4pHXOhI8NVHM8KQA5PgNfX7FIUTDuax0tpOYrG1hQ/n+ia1Lak8V60OV1eMOF1X71QtDixowkRrRE11Ny9T6FWm/T3wRu6Sl0K2mF07IRdvl724YchKbwYtM9IU2akWWy4vUjINBz3AgDzwMEAWuKamKI44hmC/uWXtSvxLbZbzXwo5m+2t0
 0l1xlj3+
 h70UyOA/20AUNy3baI/9z90mt4HJTkaS/aEvnsuqrw+BTMRy4dr+ZV6xIGpsvLThtrczCB/jEm5CaN7oOn6nKwbgOtWBohwe6kg1fvRnILPV338Gat0BCNF/WcwGDU4jjpJeXC39zkgG5MnoyyBUtXNJQqicyxZ/01tJKGLs7VUhcXp75qvzOOJoyo+EZyaZGpoxj2n4yukRfGg+/KoryjjpZecYxzO5Ljdjg6KYZg7IJPjviaXcRKKUmhla7V/lCvW6GLRvsw1jy5+yWKsQiOs5atM9ykAgtlUAIQH/t9C01HhvQEqrbqarLLUZpk02KIsnKGAdoP64kh5SJgwauU+0wxx909IycWSMRzhL1cpRj207MPwLQCWeixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:34:42AM -0700, Ihor Solodrai wrote:
> Should I respin with fixed up messages?

Yes please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

