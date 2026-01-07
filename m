Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB27AD0D142
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA846B009D; Wed,  7 Jan 2026 11:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060496B009F; Wed,  7 Jan 2026 11:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62346B009D; Wed,  7 Jan 2026 11:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D39D76B009D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:49:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7986D58E55
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:04 +0000 (UTC)
X-FDA: 84305752608.27.521BC5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B7E6B40014
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804542; a=rsa-sha256;
	cv=none;
	b=Ql/HuOVlALki4QH2vwpCT30+zot/QlT1LC4Y5E//gyOpO2KiP8vCDxy8I3YYqz18IBi5Ir
	lUiavguWbP3KV/GPq8791/wqajRHnvRGzoz4vt2W8Ys3BAdGAE2rNgPw9sK/zf7GVSEDWi
	weTWZaqXj8OCrK7jBtc0lzb0o0XSj1g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QqY8sGeDR6FYO4lpbU3tFKY5ZbGSb6WNhYUPr1FUYs=;
	b=2CK43hH2goaZjL3DTWjZHcAEYbQ5diahPJJu/ouUQJnTF7M+7ZIAQbXGwuDm7BVue4BUX6
	WUDnWcYdWSvo83aVfSvxS3EKmD3zyqseBBW4RxoZhQ92YCTGWlvs21g2VF47A7piGvNLxO
	zRPjrAahDlNuhi07MDwOVmN7STjMCiQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30ED91688;
	Wed,  7 Jan 2026 08:48:55 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8FAC3F5A1;
	Wed,  7 Jan 2026 08:49:00 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: [PATCH v2 7/8] selftests/mm: fix exit code in pagemap_ioctl
Date: Wed,  7 Jan 2026 16:48:41 +0000
Message-ID: <20260107164842.3289559-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B7E6B40014
X-Stat-Signature: qigdtspm3guqu8emdy5n8smuzic3eu6f
X-Rspam-User: 
X-HE-Tag: 1767804542-756820
X-HE-Meta: U2FsdGVkX1+cBQTPRdQhnTChqOvdw3u9V8RySGgpc0IZ2S6A4bV8jkjqf2Dz842viQBLJWuiyHsTKr/SAB/BnDP4N+pMbUA6VxX0prZlV4COk+T28FEIJGneunNWK7wvWSuWmjCT2RUuyBKEjlEgGK4xfrmscV9NgUwGkoSChs1pbaNam4etO1vI/hMlIqQHuUauQo4IGOhTgJ/5koWHeDw9UhyikYpscMD9r2yJ3xO+IWpFq/U8r/XhBIpE4fnOui0yLc/vYwx0alXm1YYBOuhaN86ZOnC/lbtS76HHvb8kztkzR4DqPGOSnF3FEpQGO1Q45foKwfBGg+UVunv471b4gVMN6kq94tssiQZ7cYn0juTbJ6SU08ZEs5pBkBob3qvXjOXB4ZFsiV9KPpoOtb29BUzxkKO+sGOUs4zyT+RF4Ufbks4BrqADrrNmAAaIhHrYjjbIlGq/Blfv7by7TeejdpARzUlQbFo/C/fnyDrIQJXSvCH9BLN3zj9SIfkKEarHAZZUCGxHrNcREuzhexp1EbPK17kksW7M7vxDWCFsI830xljKg7+UNbNlcf8Y58qxxZ+FSYVLTZ9gqT+aAsnr+RSzdTv2DexvyZq6zO5Ul4j2TnIs4VtpuUDMpG1Pl87mxhFnQIG4+abGtPv0wNlLXXsFOUwRzHHLwDM7kMVDU3c0Ea+YN51H4RVGiiA5cS/d2qSqHzgQCdYjPSfG9KLzgWFgOGmsV2C1sYupBfba6IyPEMY73lYcu8suLaa5dARpvl8i/nvKMcVuYBkaHRHFr25X8qvd3Jzx3R7GUbTPtUD6pZuWS3fkjU7VtxSb9hrBGYqmhQhXkta0F6+U00/lGU1EMMLhniYoSxbUqF4rjLOg5E/24UxddkkYZeWoT5FOFgip/OjRRWjKwTrbNUPylYE2CZHb4K8E+yF5AN8UJU8cEczyPuZssWR9joCrxhI0781TqsWx6XPGSOh
 biRCBBAY
 ooteJYqdaQJZaTYxlcuGcn3EWDJw+62TVNnLsER3mbGNV0rLvuN0CGjLyHlzmcR3ro+r7reiTH1EcWEaJ/klhIXo5x5fNzptOmBkKJwF2+32Fc4j3Gyb4xvfjHDXhkrpf0gWPCpKfkm/+mQNllhm73B3y40roDSLn5WiAPi6Q0VgAZbptCyke/7Zvf8zs+HxtyIBc1nXo2mQgZOkDhNkTcs9CaBHE7kzSTV+e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure pagemap_ioctl exits with an appropriate value:

* If the tests are run, call ksft_finished() to report the right
  status instead of reporting PASS unconditionally.

* Report SKIP if userfaultfd isn't available (in line with other
  tests)

* Report FAIL if we failed to open /proc/self/pagemap, as this file
  has been added a long time ago and doesn't depend on any CONFIG
  option (returning -EINVAL from main() is meaningless)

Cc: Usama Anjum <Usama.Anjum@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 80d7c391f8f5..7b214e8755f7 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1551,7 +1551,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	ksft_print_header();
 
 	if (init_uffd())
-		ksft_exit_pass();
+		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
 	ksft_set_plan(117);
 
@@ -1560,7 +1560,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
-		return -EINVAL;
+		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
@@ -1732,5 +1732,5 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	zeropfn_tests();
 
 	close(pagemap_fd);
-	ksft_exit_pass();
+	ksft_finished();
 }
-- 
2.51.2


