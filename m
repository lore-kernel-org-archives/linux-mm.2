Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6370606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=zSnSDJrh
Received: by kanga.kvack.org (Postfix)
	id 7E4176B05C4; Wed, 28 Oct 2026 04:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794446B05C5; Wed, 28 Oct 2026 04:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C966B05C6; Wed, 28 Oct 2026 04:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F72A6B05C4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B09780BDC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:41 +0000 (UTC)
X-FDA: 85371338682.11.816864A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0466DA0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zSnSDJrh;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175640;
	b=58rbaB79vjwBmHptYzkEVz/0KfvSpl34ofAJUwQ97abdb0c8uS3QtnXzQpPi6yx1xTqqf1
	m7stl8nfvyTrxZXvXBSs/04GalzdW9hZpNBX/BdVz24CLWcQaeEfubaf4D+PlUaQVKoqNP
	1tLGk69XOc3sELYYQvV8yM3HsG8q52c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zSnSDJrh;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVqyFTfbEx0Cy541rHtX1s3lHEBCWasBv5wrEWGFtiI=;
	b=O3bcM0nz2R/BG32FtlFdHCfznXg4JJZRbcwF2f9ksmC8qUPRJk72y6sMd4camIWsP2HXn5
	mR8H0CmyhPigY6TF8V7BVQtoJhtWuzRyBMgfoK+hWt2zXQ1LdSzCuMLVw0F2lTEQNP0AKt
	gH4sSYcEEu2/IcYAiEFMtY5leJKwu2g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175638;
	bh=gVqyFTfbEx0Cy541rHtX1s3lHEBCWasBv5wrEWGFtiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSnSDJrh8lBPc+WJwkieuUvYZceHyW7Vo/Rgps/0sKKYfp+K8gQiq+VtATPCk1zcM
	 2R2y4VPojBg1miUzjCPiX1c/WXoMhA0i7UdNieYWkQzNjxxQaVUfA0XDy7P6CuqIG8
	 6OdZZd54748+SoGV6+XeC+xLbbD4RuBe2dmrjidY=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 232FBFBD1C;
	Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-leds@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-hardening@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 10/10] checkpatch: suggest nonnull attribute conversion
Date: Wed, 28 Oct 2026 08:19:49 +0000
Message-ID: <bc2cd702455e58feb777cdb230e3ba4f7e1db60f.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0466DA0005
X-Stat-Signature: 3k9cfhpp9mmd91o9hof6e6obbztpnz6e
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793175639-363965
X-HE-Meta: U2FsdGVkX1+4H7qUZeo1m44MLJ6UlNVwnNtB93mWfqI4qVq0E3nB2H81wJQU8GAerjBx9c+eGbdmfKF0h/hsbaCf9yCVdvEFN45waUlcDvrN00EAbmVgc8uqmKPN40dOC6ziFLQC2Sby1+DTZcvQS9zwM3FRfrfZGpbXjw4EBt/l6hJbVka5sgxc+ShiKUoq7uAD5XKZorIy9WjtjLeoe9oF2crmbWv35K3Bcm7WYs5f0dQubzSfJr4RBn6k2vZKM0oSyBKv/RUsbRGiFwMMNyLVAlYn13S9ShxnXvU3OoFHT1k52fBKSe/OfDS/Gyz1Ai3UCpDhd4xLM8gi1P/VeDz6MWece6pJ66c4jyEU1/Ciad0r/HZ2+zbAo/F2j68E5xeWCBfT3ntmzn+fWGR/1r6jwwwVDdytFpiY9QSJfkyCBJ8gLAqIBrUs1S4srhaNunXbg9cx1ay/M9qtPWCfzOEWcSeMHlwHRhUnDufn7XYaTez+1cFtIRzUHuyW1C/RmjQ+XUj7mIZDCCbrvJDZjPTvoZlBVBEa8xz9iUzNL/hS086xvT5e0SQZl9ZoVbkxEStTODWmtTRPhFb+/PYyAsm0jGyShpP6yst7VuJ8mXZS46dTGSj4AtMgGhN1TUMXLaEyj02E/wJCjmKtxQRMbh4yHpEMyi9KfuOfcmtjxU5oHpyFrXFVDh9TlZtv7VmKnM+yT0Pkp9tf0KUASOvmkqrLeQKxZjjDZfyvHxb45BHzwnoUVgsKmggYO+bPFDkCdcE0UHlG0Wh2o/1ftspJXl1s6i0gaxE8EhzPe2odc8TWlcOtzQSfFJtfssGSm+oNagbdExz6d6HHAFNnlJZtgUqYQ9GfVjTcdC8gjR5DDbdbnKD+Zy/jXQ+yOIUcSez8GfBLIRLOEdjwl8beS1P5Ozfq2CkXzHpQb67IBP3q7brtuReiTv5BWwgnUqQC+RX5buVhxrxAKL/iBJLK7el
 NnSwhfVM
 ixOjqV8HBb1Z3IqQn6y4YzEDMGBg+eUk0iS52cg0JBsioW1DefwqEhxtF6TuR9oB+Atq0F5mdPCrMY3Z5INfat6JA3ln/irfv+L94vmlUBG4h1JTQ6VIiGsLl+yg/0L+izEADKsMxqTnwsol8MdHSDC9wd7nxOdD8IQ4SRtXYskGXwowc9U+5nGuRQvrZk8aSIhpKzLS7DnzhuFt3EWzHlNegTo40TggvwA/O+t2IVgik9pg+doIAwcTcGt9qA5BcBpcPlD47wCBAlXIjcnT337BuqIjazP9aBxzw+WplhXXRpG2vYnQm7Ef3voaFPLzOSYtU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kernel provides the __nonnull_args() macro as the preferred form for
marking pointer arguments as non-NULL. Add a check suggesting the macro
over the raw __attribute__((nonnull)) spelling, consistent with the
existing attribute conversion suggestions.

Examples:

  WARNING: Prefer __nonnull_args(1, 2) over __attribute__((nonnull(1, 2)))
  #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:230:
  +__attribute__((nonnull(1, 2)))

  WARNING: Prefer __nonnull_args() over __attribute__((nonnull))
  #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:283:
  +__attribute__((nonnull))

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c9840f5219c2..e696fcd02337 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6856,6 +6856,7 @@ sub process {
 				"no_caller_saved_registers"	=> "__no_caller_saved_registers",
 				"noclone"			=> "__noclone",
 				"noinline"			=> "noinline",
+				"nonnull"			=> "__nonnull_args",
 				"nonstring"			=> "__nonstring",
 				"noreturn"			=> "__noreturn",
 				"packed"			=> "__packed",
@@ -6876,6 +6877,8 @@ sub process {
 					if ($curr_attr eq "format" && $params) {
 						$params =~ /^\s*\(\s*(\w+)\s*,\s*(.*)/;
 						$new = "__$1\($2";
+					} elsif ($curr_attr eq "nonnull" && $params eq "") {
+						$new = "$new()";
 					} else {
 						$new = "$new$params";
 					}
-- 
2.53.0-Meta


