Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A94FA3758
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 20:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1846B0088; Fri,  2 Jan 2026 15:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642516B0089; Fri,  2 Jan 2026 15:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DFD6B008A; Fri,  2 Jan 2026 15:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 436A96B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:23:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA1385CC45
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:23:28 +0000 (UTC)
X-FDA: 84288148896.14.A6A79AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC12B180005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:23:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C850m0yz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767385406; a=rsa-sha256;
	cv=none;
	b=XCI+lwwXdD1A1BklBuqAISDktzQztE6L3DeK2j6trAN8nOlSAjG0RwnUz+thjm1NxLJk2C
	EXzPeikSHyOj09suhl01GYFbYbOfuS50DVI/fdBgfUcrWui6ALx2WD5mE8YD8zcvgR75wR
	2hBUIwijheEJt8nnXUtoy6HLhObJgOw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C850m0yz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767385406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1YcIStoqkIcSHhANLnGzWO4A4OHzOlFBp5QJ1ROnc4=;
	b=7dZF7VgrONYo6mc/uXx8N/ZsS6mhUzJjK+Gz2tVeOXBWQGQ1YsjUdFCxQjNNzTPWyTkYVh
	1KXQRZ6rkCnB/oJ34k5ZIgVm30Lt4GMEvYeDEQvartS+JxZipqTRNmdaZMQVfhXRHgVN/g
	MCk1017LJI96HBFPpMH7uGaRrclcEKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8E0040328;
	Fri,  2 Jan 2026 20:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5E1C116B1;
	Fri,  2 Jan 2026 20:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767385404;
	bh=36h+gzQOCGURAdbtJyCuaVTakIb422pTXIoravRz/yA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C850m0yzR3hfqz7dBIq6J71yU2NNbzw4mZaZTNyPS1TZV7qYNGtTDRPG8kpI1KJZU
	 ofuE0e2/hKuY+6qQQ+lwQ0cj+QRkeNR26LRPa8WC2Y0oXilcU6aovdOyDqulr10/0J
	 5w+ird2Y68JVQc1u6tcW/DP7po+/gYn1EcUYwlJp6jHPGn2Yy/S+qSk+7FuXSSkyt5
	 nCJuLXK565YOlUy2SvzN3oX2xAQGgxxkic4YaKhFFok0GamRAPMXKe6yrSoNzIPeAe
	 i1FlTFFmTkhtejMhNuCFQjPyckllVuKw4dtWQQ8M+NlfERKco0rQC6McmwA9iTE7T4
	 hcbWYVbQZ+9zw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
In-Reply-To: <20260102-kho-v2-2-1747b1a3a1d6@debian.org> (Breno Leitao's
	message of "Fri, 02 Jan 2026 06:53:24 -0800")
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
	<20260102-kho-v2-2-1747b1a3a1d6@debian.org>
Date: Fri, 02 Jan 2026 21:23:18 +0100
Message-ID: <86o6nb7oi1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC12B180005
X-Stat-Signature: uy4fac878xtp87fi5xpwjhwuyo7qt93f
X-HE-Tag: 1767385405-593426
X-HE-Meta: U2FsdGVkX1/ItXui2bBiWwM0R8FpT0Vv5meQEk+2JVo4J4lukNxwRi5faCms6vYTAYGMk+fTKT5OY/HZq9or9g1FBydwscbh/6cindPLvjkV32/+n1ClopneUUt0aJz7B1nJmOgG1cz6ebs+xskmEs3VcK5IQ3jkaeL/4l73NoUTbqNfCbG9Z/TiBvilR7S73TcmN1L6tY0YQcp0myqmJQMP2jattTg7+yBW3h2H6Esu/eHekFsZUAkQVKfS5yZc1AGv9X2eFcwEMiux5HoCFZZLWVIBXew8cpkNYdQJUoDuKy/8jSyo9V2r6QMxiKkyBC1bllTRAaKaimMrz/XAR1MebPa1WmgiueYees4OfckJwoi1YVEPNK7alZKG+7b6xVTpS/fUsUnIN479FSLd5ZAf8Ue+R8aqWNen6iV5aBycPJs1qXwbeW6+UO+XVeMLlSnO53R6svmhDoOXRuao1cYSq0LNkYimjBuA+r2IV1AELAag7x7vxI64wubE/rrEao2xYzc3NhYW5P7CaBIVpdeX9QiUeGVMgKSEqfwi8/arSGH4fqilg9L9ADcra2EUg5T9mjQ16swyKC8CLQwb4lxlASdBWgrUFmivurKYY55L73MwXfoXQeTlD0E+9Q6ceqFlX86iJNukjQyU+gp9vYddJ9DMw4sX8XDzuT4xrZBMnzcH1Rwo4Y3mQe2J9CpN88A/aMqSXrjPFYGkE+JxQBaPXprvklLJ0xstbk04an7wl+QD3JsE0O+a+L5bg9e8sx1Ax2PIYg1hQOAlRtXOVdxWQNyFir992qthqsaX6AlbTbrTS0dYNjf/4laOX/Kx0BMf+zwloYEH8u3CtfGzUSD5F6kORvSLXFiAks/9DOPka4nobH1Ez9GpZHD0ojRzFwxkymZ3e9tQQmZUMuxIvKe9P0dUQaltUHj23mZ6PpeLMFabNkozYXDHQh21HZbftjai2pyYxdUKgbSyOiA
 dxx3H6sG
 8W7SXR6CsA1MboUIPgWxPSA3PalZo4kHM4W4hfqbaJNY7ScRfVkwrTPhWmtq1ZYXYzEqDesfrlC8HTXTG/Amdx4XIZ/EApc/TdUqNa8FRD3Fp1pLBYufyAAKyiFWM3VqQq7OsVfbYqDr5KbLyfiQCd8+7l05WMO4pdvwx7eQhjJeTK6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 02 2026, Breno Leitao wrote:

> Track and display the number of kexec boots since the last cold reboot

Nit: this does not track kexec boots, it tracks KHO boots. None of this
can work on normal kexec boots. Can you please update the wording to
make that clear?

> when CONFIG_KEXEC_HISTORY is enabled.
>
> This extends the previous kernel release tracking feature by adding
> a counter that increments with each kexec boot. The counter provides
> visibility into the kexec chain depth, which is useful for understanding
> boot history in production environments.
>
> Add a new property, "kexec-count" in KHO FDT alongside the existing
> "previous-release" property. The counter is:
>
>  - Initialized to 0 when kho_in is instantiated.
>  - Incremented by 1 on each subsequent kexec.
>  - Printed alongside the previous kernel release version.
>
> The counter is stored as a 32-bit unsigned integer in FDT format and is
> only active when CONFIG_KEXEC_HISTORY is enabled.

We have such a counter for LUO as well from the properly
"liveupdate-number". If you're using LUO, why can't you use that counter
directly?

If you're not using LUO, I'm curious, what's your use case? Right now
KHO only supports reserve-mem outside of LUO. Is that what you plan to
use?

Also, do we want to keep both counters independently? Or do we have one
and drop the other? Pasha, what do you think?

[...]

-- 
Regards,
Pratyush Yadav

