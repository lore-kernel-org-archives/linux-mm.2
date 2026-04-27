Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA57FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F686B00A5; Mon, 27 Apr 2026 08:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06AE6B00A8; Mon, 27 Apr 2026 08:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5AD6B00A9; Mon, 27 Apr 2026 08:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 772496B00A5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:04:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D71F16010D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:06 +0000 (UTC)
X-FDA: 84704202492.06.90C4DC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5678CC0017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=etUonoN6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777291444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWBf5TMJ5SJ/i7mrUIHd6S2sJXG0sYPofpDKEaeLN0A=;
	b=RmV68z+8npl1gVASpbbW5b9IzgIcl0/9sMXWQbXnNurjn+EQMVUdWG3TXeIxgj0Tzuji6e
	AURLEu3mVWzw6UdPMhhpGUP8M/Ep1zk7lm8gyrfCP7+R/n5ko6uh5hDOUvIhDXOIduiVYA
	Qq5HD0gZxl0Zq8e44bizdU1G7Rwon4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777291444; a=rsa-sha256;
	cv=none;
	b=v/yCRmTfO3hdQvKBAAaCZDvNTEtL2EjdOv8gwyihQYwrrJ53EeeLUpPJWa2yOgAys0cZD5
	DSPJvwvoMSJw+cPmReYdi0BR09VD1NK97bYTmBg321YiqjViPlMTSuTeyauN2rfmJcQJ2T
	U+uwSHhndKXIdogYfrJrg8XIks92qXQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=etUonoN6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27EF4237B;
	Mon, 27 Apr 2026 05:03:58 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06D033F62B;
	Mon, 27 Apr 2026 05:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777291443; bh=awcZVPdgr4NoF6FXkdZLV9n173eUmmWJVTl+xzU9qi0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=etUonoN6yDhxKa6hqLVL5RxhyWOxzED9Q58uZo0iPeFyW4oCmYJkq8Lttdn11mcQJ
	 Yu0mQ+jiepIcjiXT0sced8SveI+geZ8cg46DEctgDeFySf5k863kuKk0/D2yyElW+Q
	 qBMdUlbRGgYjwOqzdfPCbApXucgS20R46HQoI8j0=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 27 Apr 2026 13:03:34 +0100
Subject: [PATCH v2 2/5] selftests/mm: Fix resv_sz when parsing arm64 signal
 frame
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-poe_signal-v2-2-2bd9d6f16ab4@arm.com>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
In-Reply-To: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777291437; l=1455;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=awcZVPdgr4NoF6FXkdZLV9n173eUmmWJVTl+xzU9qi0=;
 b=HUE7VaV5mymXwUwqCX1U0mb2g/qez2BgKu9EqDu+FVf3vPerOr9icMeIKp6NWvRlEynUXEsXu
 6AbWmvJwVciC+2FBPdj7AuDDoP3Y49f/5k9SEqqhbMvqVxsge4RRZ1b
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5678CC0017
X-Stat-Signature: eq7ct8ejawiwxgi99pyc8tg6s6cqoxi9
X-Rspam-User: 
X-HE-Tag: 1777291444-891774
X-HE-Meta: U2FsdGVkX19URDU0C1ddzngO0sjGxuHVbzwUlvTvB+fDfMoK/tt1DqgsgM3bNURIAQt0X6mxTek0l0uLcRSgq6Vi7WsqZ2iO5dnn2INtDFN64LvjsvMvNmsK6m7naWj7d8LuumfTd5OMpofqDNVPHTYlYRntXwwdmHx96dlIMNiAPaLYsDOWIq9ixUpsJrkDrGLU4wERmQdrfDdrF3DgCkKDygz8QhRy5eDkgLaJhxHVrC74Z6c0EIbTrm0OqEn+wktdtoF78gmwHebFXfkC3meqFT03D7lPH2vIiov4/+LcAH6vZ1p86+AwKwNpUKVu0XL8SihBDPqK21Ungtz47re/k/jiCRrnQMxyutTjQSAPgnEkg5H2gFv3NQoikzgSf8oKCeG1msUrWCZuNLTAPayTsNl5FKAQU+kNXDVPY4L0ykUlUTOe6B8m2G3oq5LWYULbLTcA0eJnXjfAjm+1Ks6ewOtVhPjTn1t5v4ZGuh/t9G0D3w5W+31kwjvtHD8CjPThcptp6hNF4gVg6FEbgkBCujB0mlnJ7Wrei3SQVaAMESVHOT+O1r9JcsX0ygdEtj9m3WrcsU/4q9n9HXVJMBPN2IEHRf3gWcMdqzwlJW4Dmerm1Z7Za6N3ZcYtaTpeqXHDjFxMJ/CnyV16bvV4VznebyUr+7I/I400l19JH7imhw4/HhfumH76Xc2ssbzUSRrEhCGS7sjzQI5hZ5jzVoWsYlE40zcoX2zbleb9crq0zcKTBkghowIWq8X0tLyVJr4fvNIkQmjI7y7PITyDkM3ukU5bCeeMRd1LMmjXTWteL4W4wZsOxWSXPYuVvkh/L5kurS0hCdaXzqyZJTVQEwtaDUgXZzVwnzqve0J1SuosehL6/N8ZtdYLkf133IiwvfKDmtztzHB+j6Nmi7hVES436lKGS1gUezwPfID9U1HQ6P+4RL5YK2OmDSYMs2YeUUV1Zpcx+EKoeqBg7tp
 BlhYtdJo
 hGfkoxDx5oIe9OvNs0yzOpJC+648b/bIthSwslCFNwX+Fuu7gQQOL47Xi6f0FryjYuv/tK5ZO5SAWCT0tFrVXxV7Ac9DZggZCBvhS4qhMtRaWNECgZf5mo5YwVsbNhDQuN/N4m2wxl64ROzNBAMUX2GduWP1+Puvg4de0GxI3KrBrrLjUmZoNN7jgOa+Ev8DpMH19H1a43Nb9+utRwNN/ElueRhzD1l/Xa66+iG95XKNBQejRruxssfjIrVUmv5bx9eIc+QDdm36HKcWFUz89RA6Z2Xpzc9ZgsPALkWf0prcDCfD0chK4KywyaJixrl/3dKmjrIKog0EYU55SL1NDMLFrPKp1Xqg+UR1ym6f1NLoR164=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_header() wants the size of the reserved area in struct
sigcontext, but instead we pass it the size of the entire struct.
This could in theory result in an out-of-bounds read (if the signal
frame is malformed).

Fix this using one of the existing macros from
tools/testing/selftests/arm64/signal/testcases/testcases.h.

This issue was reported by Sashiko on a patch that copied this
portion of the code.

Link: https://sashiko.dev/#/patchset/20260421144252.1440365-1-kevin.brodsky%40arm.com
Fixes: f5b5ea51f78f ("selftests: mm: make protection_keys test work on arm64")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pkey-arm64.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pkey-arm64.h b/tools/testing/selftests/mm/pkey-arm64.h
index 8e9685e03c44..c5a78a2f211d 100644
--- a/tools/testing/selftests/mm/pkey-arm64.h
+++ b/tools/testing/selftests/mm/pkey-arm64.h
@@ -130,9 +130,10 @@ static inline u64 get_pkey_bits(u64 reg, int pkey)
 static inline void aarch64_write_signal_pkey(ucontext_t *uctxt, u64 pkey)
 {
 	struct _aarch64_ctx *ctx = GET_UC_RESV_HEAD(uctxt);
+	size_t resv_size = GET_UCP_RESV_SIZE(uctxt);
 	struct poe_context *poe_ctx =
 		(struct poe_context *) get_header(ctx, POE_MAGIC,
-						sizeof(uctxt->uc_mcontext), NULL);
+						  resv_size, NULL);
 	if (poe_ctx)
 		poe_ctx->por_el0 = pkey;
 }

-- 
2.51.2


