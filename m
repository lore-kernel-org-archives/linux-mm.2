Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A10FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE056B00A9; Mon, 27 Apr 2026 08:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F586B00AA; Mon, 27 Apr 2026 08:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5C26B00AB; Mon, 27 Apr 2026 08:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04486B00A9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:04:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 482E216019F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:08 +0000 (UTC)
X-FDA: 84704202576.04.19EDE68
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81DB5180005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E5HTbU93;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777291446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGW2njlj2ugDcXFumu6adxQFAzcj81+CZlVLaZj+Ric=;
	b=6LRvsl9/11Z1Bq3NlLZFMN9R6/Se61MOFM0yMMQJksA3xN1mvwNGiD381Zx2ZeBSEgv/c6
	y4gaidSrN01RcrPKB7OSvEcfyGBT0/qXRxofJWUhNAvMOPkxOVZzCV9qH/bsVRxD1YXxO9
	vo0TOfCLdrr2nilVAcQHbMcb5f+n6lQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E5HTbU93;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777291446; a=rsa-sha256;
	cv=none;
	b=wjYrGXdl30VBtbblIGddHejnBMpeFXm1lBXF5PqsguIFdSBQ1ICN4kUZ7ehxJeIuDaTkgz
	tTPuxlo5G7LFeDCZohskjn1rUtJTU4EGl4lDI+n8wVfEM/74KeT8SKmDJq7KXTJqTndvbR
	BEWg9jU39RO3YUubsUmMn9bW725WaPA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 143C72403;
	Mon, 27 Apr 2026 05:04:00 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB5743F62B;
	Mon, 27 Apr 2026 05:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777291445; bh=9abFZKGlP5VpbpK/xo3o3sS4A3nxNboOdLQrnuFuT/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E5HTbU93SQIM8aVlcAPTi1uVCP1N/6UdLlfw1iB5ICYPNgHuTUaYxBrlXZgdkCuLz
	 doZig4NlvoPQiazZPffunLwI4WTyOjdLVOfj9yPtNMeOvm4Vk+J/9q1RbO1OEzZETK
	 uAgOe2oVcTpbcNK3SbT3QQTP8ajcOnuOP6toOKG4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 27 Apr 2026 13:03:35 +0100
Subject: [PATCH v2 3/5] kselftest/arm64: Add POE as a feature in the signal
 tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-poe_signal-v2-3-2bd9d6f16ab4@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777291437; l=1828;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=9abFZKGlP5VpbpK/xo3o3sS4A3nxNboOdLQrnuFuT/8=;
 b=GTnr1c7p2Hin4jCm+yjPTqqelCqtlEX6rcqi1gm5BLqDAdM07xRTBou5V5Li0RVM+66g0W9+y
 P/t1n7po+HfAW3auqpcikvxL2xVW1CvymzvFNUOTdPkAlcmJ39/fx4f
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81DB5180005
X-Rspam-User: 
X-Stat-Signature: xj7hffjubii4csmefhf6k911hcdt4wmy
X-HE-Tag: 1777291446-841955
X-HE-Meta: U2FsdGVkX19m8JrXZ4i9OM1XYLMQoZS1w129b7aS6bNpcTiyfphsKc7ju79Y9cwjW208+wx/k/02IE91a+JwPBqJMX6UYhvL0LHTAefpBEWGDbdePEr8R632/FVjzxyLPFE7mxHPMnhkjfCHLNU29DTOFd/h4QFCAUxsBvm2fAtZcipZkgVzUVqM7Bh5LjoE6SkKTpRSIaQnhTHkU7IZq8jQOlhYdMUc6I4IwzBTI7O//GCNyC7P3Y8kBRiH/zLk5ouQm3oC5Y02V4lOfeB/6EuddYln95z3hsqiGxoIIEMCjE2LYY1532+2KnJ9ZvxUEJfDGPy6w7zUJkO6p5A4qp2dWINyLaLgl+0I/UfGcZllqiK0k9PEm6ruKAoMtMcd6SFnOnVk3lk6LCiPkgTrepXE3WwHSFX/80HRxNnU0QVJlZmgPtUG1kkooNCKawl1Z0QcGPp5FlkSqKkLe7JQcgDq7IWSn21L+po65hOPn6+owDg2JP/MJU7CgpDL+jK0g/UzXqB1gHjaunNOziTM2fPInYwgZcmrq0+eSPlG+gL92pVf6ytSoP3mEejMauS4QpdpAGOdSoxeCIkRXtiy9hbSoAVKfO2cKZqa51bNvJec9FpraXZUeXgyodokY/J2CyvSKNB1msUYz8rrwOdzAGGleZR//O88nvUOGHDF1i2M4mnGWLHseyGOSUc3y07YHqnof2Ymd5XaIdHTkU0VK0lbwFSrwa0ZphzYT52YQqz82aeGbi29k6HClWL/Tkg2aw0tskXbOt+odWAU3LLAO29urqy3e0kMTi9joWhDm0Xv9ERhvV5+Y33PaFH09tTXAjKFbYqHAWtYHXE+qnioM9nbsArmXVg3JZx/GedRuzxMquhuYd8TN/VnYtq4UruNOGIOCfH5eQU4Fu5YKQb4xrswKVvNrigQ0BZeZ6KsktqfhVDl/gCPqvTLpPaZ7XIDhNTBlVIua2HCK2e0l2A
 6mJiY3Vz
 4fmK/oee/6EMBmMK79goh9W5+TdVjoWxuM44cwftqVLQjbVYA5UI4VnCemE7Li1oWrjyOU7sebhF1kR0ZjwdAaZV+v9ozzXcsitM3NkUj1oGaVOmBTYjsRfpyHw4yQ2Fbqn4yfK2zIYpbvCOD+i02Zy2SOujpBYDWZJ3K8YRgeMJzHZR9J4UeIqrsQtJj+1l2wupY1OUXOeRgWzQ81SEFwVhUw4pzynPPSXNsuNhUH0xChQJ2ZEq6zYsQEAuU18EvyzVHGvYlaYLDvHkF9daiXSaqYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the POE feature to the signal tests framework, to allow tests to
require it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/arm64/signal/test_signals.h       | 2 ++
 tools/testing/selftests/arm64/signal/test_signals_utils.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
index ee75a2c25ce7..c7c343494cb8 100644
--- a/tools/testing/selftests/arm64/signal/test_signals.h
+++ b/tools/testing/selftests/arm64/signal/test_signals.h
@@ -36,6 +36,7 @@ enum {
 	FSME_FA64_BIT,
 	FSME2_BIT,
 	FGCS_BIT,
+	FPOE_BIT,
 	FMAX_END
 };
 
@@ -45,6 +46,7 @@ enum {
 #define FEAT_SME_FA64		(1UL << FSME_FA64_BIT)
 #define FEAT_SME2		(1UL << FSME2_BIT)
 #define FEAT_GCS		(1UL << FGCS_BIT)
+#define FEAT_POE		(1UL << FPOE_BIT)
 
 /*
  * A descriptor used to describe and configure a test case.
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 5d3621921cfe..4b12dbd7669d 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -31,6 +31,7 @@ static char const *const feats_names[FMAX_END] = {
 	" FA64 ",
 	" SME2 ",
 	" GCS ",
+	" POE ",
 };
 
 #define MAX_FEATS_SZ	128
@@ -341,6 +342,8 @@ int test_init(struct tdescr *td)
 			td->feats_supported |= FEAT_SME2;
 		if (getauxval(AT_HWCAP) & HWCAP_GCS)
 			td->feats_supported |= FEAT_GCS;
+		if (getauxval(AT_HWCAP2) & HWCAP2_POE)
+			td->feats_supported |= FEAT_POE;
 		if (feats_ok(td)) {
 			if (td->feats_required & td->feats_supported)
 				fprintf(stderr,

-- 
2.51.2


