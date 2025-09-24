Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD1BCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 08:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A878E0007; Wed, 24 Sep 2025 04:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB2F8E0001; Wed, 24 Sep 2025 04:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7FD8E0007; Wed, 24 Sep 2025 04:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49A958E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:32:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDB0616079F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:32:35 +0000 (UTC)
X-FDA: 83923477470.01.F9A55FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5883C40003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:32:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKCiEqK8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758702754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yelwEdVyFlvDCiRDVOLVouJn/0aKPQv0jeYtJq158vU=;
	b=yFi6qMKHMDDzXI0Lh+T3D1X2OIHJh+bGckt5PPoYxBjwDbYKNEnnntvrm55LxxaUq9DtAl
	vxDI0FFoqE5eY0pGRAUKHbNKiZBmLEWfsmlioJf0B1EpXiSod62OUmIo03doj/GYUEdgug
	AiQz4rgGFREa1ZYw2jamAl3jppXU71I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758702754; a=rsa-sha256;
	cv=none;
	b=lpIgxWLpCRW771LLzkG/FQuerGOIzZGdsjOZX6HIfS8tv2g2SExWH0F5HJCeVFJFiJshZz
	1cEHRAhiA6zE+O84BBV+gB4K3b51f1dFkH1jgw88pDt7ERbFdiTRSyTv5iKOIw5dAlt5Do
	AnyxzMYk6hL48kL4oYobefSoVzOFCfc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKCiEqK8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D4FA60202;
	Wed, 24 Sep 2025 08:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276C7C4CEE7;
	Wed, 24 Sep 2025 08:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758702753;
	bh=IeX8yOCoDvdcx0fmIasWNFpPwpjlgV+9WMTNQdEmwx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKCiEqK8BrrchqRM3mvUVeZyIHSQcphRs0Pn/zKiofSIxKdDycgQec11VJpho3HhB
	 f3TPMh7Cd3FPuL3MZ+1WcHdYv/7/KIOFfg+pL7NGMMm797Tbf3pyf0x92qJXtpg5nG
	 vdBNszgGIRz71lHagi+gJSmcBvjON8rqgkSTV9aB904ZpKhrfbgwrAkA0zUBmiur4+
	 ilfckVKEogkxF+f2ZXXrdjpSP7oO8gpnvxJIvyCFg08POk/ZGAcVgQo5acdxhlexnl
	 CX5tW8G55aYDv9N/OUk3n6UIruY10vjTYRClD+ySOq17u2I4bIpF4vPHZdTjRWp0wp
	 gkuMHk9elmRSg==
From: SeongJae Park <sj@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ethangraham@google.com,
	glider@google.com,
	andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Wed, 24 Sep 2025 01:32:28 -0700
Message-Id: <20250924083228.63898-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250919145750.3448393-11-ethan.w.s.graham@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: afaq9zurrasyu4grhf7wo6yycpkudxth
X-Rspamd-Queue-Id: 5883C40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758702754-814307
X-HE-Meta: U2FsdGVkX1+JCPlNpK2qgXclHX3FL8imAHj26hLTywBkjuytEnhNSK0ENTk1WTXrUTsE1Y36JBRZ0rGE0H+iqj/q+PL8X1zayPZn2Jkcf0xeFjQOjmvnaRLNSnamenBPZMewnxdKb72a7qEdxhiLNXSqECE4az97l/woJMGBsE6V8i/LcNMKTFJKQjrP4Hw1rKaL862xJcx+pwO5gwVV4rhr9AnIUtiXIoaIOKIw/ZTPFGLrl7Jiu/Bv1bcT4u+gouch8Md2HlajIIvm1ECaG+elHp7uTe5U5gvcI/FCIFMJhQy8/JWuX2GC5sSa3D891E87BmwUz5zTZWLbPYX2EUQk+7Lql/qzwdR9LIhFxo+eH/e8nFvVIdQVh13/0lxgIwzTY9/iZOZAPYAk/tSay2j3THh8vthXEMopSkP0f0Z3DeL0t+CwS5NmsJHZ/aVxQ3Ugqz827k8uYFKVmDczHPjgoLFziH1SB69sXpJ0Dirs2UBklf4Eo+xRgb+3IkrM63NCqp+iNW4UD0s89EWle7iqfMd/k45LA8AUk0GJ9R8VIe4RG7J9uUVMMZBzbiIZ9PS8p3oX3BsH3ui4qQ5wgGkU08XJo/dXauMNohVW8tZtGNdotH1jqThxmN7Qip5nTSPxI07w4aE+Nc9nQMOoXgGczlQaInoB3Y1vFgEdImlhvGc+A0lKC+7zAU7UeyBMOB2XhtrATzTh5u7EdorYeKM8UhkdUKU+U2lRC/8GXyknCMyht+4ATH5a4G02U2bz6uKs/+LxiGt5UFbgUY7J0lA31M4/ZxaN0KfAVLTZbd7WSxrh/MDq/CtpEPzJ1BlxKlNH2jtO45m4RjHyA+jfWwGVsrmCN7zIQyZQdbaZJJF7Jk+56dsSaPOVOEBM3YlY6iRbGAOSRY98CU+T0JXKimRY2bXGvU7oSDAYd1bsyGNHle9+GG+CZVWfmdlkYfU2pOnDHf/dxS8lcU8XAos
 K8nbTEif
 zocK6enbvgb6PiyHeQFm8JE1lpGz22V2NZOdDHmhnQ7eArtzOWSIrACyHiOqot7j4tysk61CiURdT1lvVj7yuNpB0PsbYkfuNfG9UdY+cXtshA5v7D34IffuJ/PUrMv2iU/2SUJaNKhBY9ttcygvBaep1ER0eseOSULWl7xpz+TmtoW/xQiZoh8PKsXxWcCfNvpYDUM1K//icQW7DJiN6ZKdc0bPCydEQ8DgTSDKG2Y72RqCBuBMuKBb8CAa6TqnEqG3FGHhtAt5u4iismEStJfunPpuUgmxmweeC0a+zoRUwqSSNwHDDcAKCLiiMH95RoLCC2v08153AiLhHLl/tEof/hYx2Gn9EPw+pP1uMRSXIommfJDwit6TyfbQu4iWXN83WkZPU7/lolUT+sexfoZf1duo8J5w7AsmC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ethan,

On Fri, 19 Sep 2025 14:57:50 +0000 Ethan Graham <ethan.w.s.graham@gmail.com> wrote:

> From: Ethan Graham <ethangraham@google.com>
> 
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.
> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..14972e3e9d6a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
>  F:	lib/kfifo.c
>  F:	samples/kfifo/
>  
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst
> +F:  tools/kfuzztest-bridge/

I found you moved kfuzztest-bridge to tools/testing/ on this version, accepting
my suggestion.  Thank you for that.

Nevertheless, so I think the above line should also be updated like below.

F:  tools/testing/kfuzztest-bridge


Thanks,
SJ

> +
>  KGDB / KDB /debug_core
>  M:	Jason Wessel <jason.wessel@windriver.com>
>  M:	Daniel Thompson <danielt@kernel.org>
> -- 
> 2.51.0.470.ga7dc726c21-goog

