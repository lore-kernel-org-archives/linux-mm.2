Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627FA606BAA6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZdndL+Ep
Received: by kanga.kvack.org (Postfix)
	id 03B246B05B1; Fri, 13 Nov 2026 10:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06FC6B05B2; Fri, 13 Nov 2026 10:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE6B6B05B3; Fri, 13 Nov 2026 10:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A580A6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:59:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D2B6A792C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:18 +0000 (UTC)
X-FDA: 85430555196.18.AD57A2D
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 306E01C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=ZdndL+Ep;
	spf=pass (imf20.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.52 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aIRQL3xPbHGiEB8Nq3QfhoUZhbnBVyn8ckiUXc1wE3o=;
	b=lqUh7qr2xqcxjoLCBK6oZDsCgJ0TYkZTsuMVi1cdr5Bing4LHl0G5aAf2zI5Kf2tIXagwl
	t7HqT/P/Ml8lHPh18pxhaBnLoKUdiYgoHhz957LGz1JF1aYiWid9bNd1FfwQDXCo7pdmyk
	KHtwxmTXEc1SxXAaHWpMEGa23nW5/IA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585556;
	b=VAgOVwdKiLKzwHA42axx6ICeKRsOJOz+YRvSHjwtRdZFQF9611Us3kaat68OFTRJu0jLr+
	Ui36dgRT/TOpn3s+lYv5vVFHElkgRfDj5kdmCg8NzQFrmewEMWK9fE0sPCnxjegJzA6xzk
	DdhTod7mB0ef5h8VLJbGnXWsGvIEQSA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=ZdndL+Ep;
	spf=pass (imf20.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.52 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15ea896ddc8so1470571c88.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794585555; x=1795190355; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aIRQL3xPbHGiEB8Nq3QfhoUZhbnBVyn8ckiUXc1wE3o=;
        b=ZdndL+EpFpgwNBBhGD2pbcTWhA0J2XqR7BXRPsVTuV1rVw/+xamO1R1Pg7IucsFDIu
         ma739UuxZQvVk2OEM4gDYyZd1cW1XUNShGijXoOuyQo2UD0tAU88+vOFvPZqvtOGJzKg
         ufW018HbZk3XQuW/GgnA7q+uEbRwqjAL1EQ3LS/hlPhx/b1KfAsflizVQ5rtIXWkL3dA
         ntVTdg18PtqzkY1DjuINyLf3Ix9+qEfNbt4YCrNTOS3XD+ZC4qD/hX6gmvbzMNItNt2/
         Gd8ZS1k6Ya++tcdEcy/08hnLadXMAaNE6ms1059XVDmCPyHIvQ82/rZvRE+RHSF0XLVL
         /djw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585555; x=1795190355;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aIRQL3xPbHGiEB8Nq3QfhoUZhbnBVyn8ckiUXc1wE3o=;
        b=RMkP5xr/k2+WZKUx8pMD+WFbKjQATfjNFPXzVbX1WnjDwD5ZYMn7ndx+roITtk16DZ
         oKWNVxNcyfEE2JaT1Oy8NVu4Mik0CmiBsFXLQEIifXr/4p9Ges36Nkx6XByQdDXtPQ6Y
         z9IkTbpZErqwgPougLU0la5fqcVsI41MkAUpGeVUJVH38/1gbOzD5S+YOtvlxNXGbtIb
         1Sj94ZTVP9NYDNEynSf8549KmyoxYdyGJk+ijpIlUMyiCPmMOGt+AsFZjedqjC6nrAH/
         pL7Ye3GcdBN1UTc47F3fnQYcm8+NMYgtaiDzeIA8sUEEIhDwW1J4GWOtUKKb05fAQJ4p
         Tpkw==
X-Forwarded-Encrypted: i=1; AL+hErGnGQb6A/6i84QRqCdpEe0vR/Li3at6NFqTgQD8uqtEfw5SNLASEXVhOH3t9vt8i2uji0c/Z6GH+Q==@kvack.org
X-Gm-Message-State: APuU4Z9dfSTxw8AwHy652WbyCE3G01nsMLqvTp3j3p46H1z0lKysK4MV
	WeVJQvTjbBK/9amcPYgF/W0nNFXrgP05ngRFcu4awgG/E6ysq0WNFhe89pMLMKJJuS4=
X-Gm-Gg: AYBFou3MlrgpfOQL/6RwPWo+NWGQqh/G2Yun1IXzM2GRrNoDyUM3/gPMosi8rp2qUTI
	tM+JyLRCIytsjtYMd2ikZlFR1RllKzy1V29rg0p8KbfZAxFU173AP/RzGNXlK7HhoEw+5jysNVc
	RhSPgsNrurncML89O1ETTeobtdBv18RB/HmWQKq/qmYUjQxFipNzZDAfmr4o9xeS/y+H8PFYkvn
	pkM86Ewvn6qDkfp0pQfjgLSq+Z2MubDshcU88Gqa3a1Wm5Sm8dGhGmOv1ToB87fzWnO4qmhPmjD
	VxA4rWd5hWEIo2bQyBr+hTY+eYdHcerRw/taUPx11qrHSJcGz/tySfmfw4PDr2D/5PWZd/XYmTE
	UDY7RMSSzOWkLTwXv5HMRJVhPL8UG70umaO6IvcC9GEBlwj42+7wmj32NYQNRq3Qf48gImKHygC
	Dlv5A5rYipavRoArEFCfpYBDMnhHKfHLgGf/kOtwTl3fyd7GPTO2b6i/57S84V/JbSGk1XcBRmk
	lv9ZbrBQJv50QOfvdcj4Veuecob2CKxb4HtABW/xq2tUtUjCWRTZNOpVDqQBP3tnpiAUiB8SfTj
	bXL9D1fmGVfUgA3E6esLYmlaFmDC8w==
X-Received: by 2002:a05:7022:3c03:b0:1b2:42db:8a1d with SMTP id a92af1059eb24-1b5030cd460mr2271552c88.29.1794585554755;
        Fri, 13 Nov 2026 07:59:14 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031bc518sm7868383c88.15.2026.11.13.07.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:59:14 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: [PATCH 0/3] mm/damon/tests: add KUnit coverage for age_ms filters
Date: Fri, 13 Nov 2026 07:58:54 -0800
Message-Id: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSQqAMAwAvyI5G2jrWr8iHkSjBrRKU0SQ/t3ic
 QZmXhDyTAJd9oKnm4VPl0DnGUzb6FZCnhODUabWWhsMJAHH5A/BhfdAHq2tirYsqDGqhBRenhZ
 +/mk/xPgBjyfsPGQAAAA=
X-Change-ID: 20261112-test-age-ms-filter-9953843e7204
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Stat-Signature: godat78xwhujoown795ni99mbh3bnh6x
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 306E01C0004
X-Rspam-User: 
X-HE-Tag: 1794585556-398954
X-HE-Meta: U2FsdGVkX19nTnltj1U/btr2EsL7h6r2lECLBh/06l5uMz4oILIWJ2SRV9J1/HCF1jZCL1ZGbv/EkEHoGOS36Vx3Mrkk/mCy11PhAlvyFRRbEfXtDgxIdbm0OJt0q36RkAncijR1ZmDDHk6D6tVWymTnYmWmjgvG+zHwqYHyDeAxEoViTA/5F1+JgN+d6hW1GB+IOjBgj33FiKwoesH5nvZy1tdItJ4Jlk+QPstIOBwyUIaYka2bJ6smrTPhUDYCJi/YKJyVrv1Owbh8itM0DeKixoILnTDP4yN5wEXI+6lEr2Ohf5yBwSA3AphQXrXyTS0YTUviHaasUsO/Ca6vKZThMEZkR2Psg+4XVVNK7WuNHhknuugp00VpStH3kzZEMcQncK2U8NHyjaJkGqUtKjgnF37MaswBSr7MnRW1lkofYiJSZn20hhlgvmih8d4SqmBREFmcbT+tQB58+frd0rOnuHj8a8B7XdO39P/5Z6KoMrvir0Lty6qtnIs8UoXZTJLsxrK649wOPzWuXj8aIhrdyPyz/4LzFaw2csAe6TB5mIGGb1BKn3fH7Ugpki/k6Eja1WtmPSKHIMo4tLlIMwtQcRCYzo0txVObwQm2IiIPID9G5qzgBgt0J1nBZXc3gw/qnd1l+lZN1qdkNf6vEVWbxJCroPZ+GwBTMvxxfhP6q8zUzp+dEHYnMCT1pL3nZ8tgm61gDTfry80+SAleKXPrdpu09LZ1I7p+A9y/UPz0AJhIfH5P2f1thTObA4BhB14Zarf1dsOz9WPsiP5W8g0l+F/249vJjBk1VTxLDxzMOhm3gt4EgFTWleC2OQ5NtRQULRQ5o/VP3FdMPRwAwbShleEYG+7jDn+PCrR2r/5IXX24uHAFtnRDWZbr9bzHFQP5eTsUBC1lv2LOVCTg/t7wy6Bx1ZaORMs5EvLWIBC/JTLKGF2kFVtIVMnCvJvCPzVPaGhzxKtj3bShi8L
 3tm8cKJM
 CSzYxmHqiyVKLJq/KEIeVLg8MftqusIZgQc8JuUKwHubiMSouTRMtBQaWBl7nTMIjia4ZqGpmSQjm27+1KMeQ8KTn9ILSJr49tO8VMlRU/lZiUOcprsrrMHepQ0rq6hoB3FjPjGnTX0MQwZPg+llDT5idjVopde9W7VX3URu+1QQVnnFf+VA0l4dxYSZ43XRsUlR6NmZ8I/vyntbaMbOSo5pvwnVEk1Qd9egaVRtfOkdSaMS66+PrnB1V79IZRtHmpfGWcz93iKK4e+6yhV53XlvkiHkxgNkgsUAzKMYboBznhVfzSVNax6ayUJXjWjnnPxDJ3rCrtUyC4fs/YfKfYV6pyKvZsj4RQ6sf9EY5T8TBaN8b2FJmC2SrYqLdbjZEw3KnFJCJGmFDgIfqNyB6QgGfwbed/ZVzZV7fbJUwOe6+YOmV4mAJHyerANQ8APa8K/NGh9BsHJZ2oGx5sR1BUS82nkqJCAVfb+L+X3ICfEvaO3DZGgn99AClWvvVauAt61Tdn78eZnDjifRPybNEcAgmOIcwfmmk+jKCGHYgqfgK8u3qV2HOw1Llcikixb32ufNWT5f5EF/rTkkPegeoRgXrJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
committing valid and invalid age ranges, identifying the filter as
core-handled, and matching ages at and outside the range boundaries.

Region age is counted in aggregation intervals, but age_ms filter bounds
are in milliseconds. The interval-change test checks age rescaling and
filter matching after both increasing and decreasing the aggregation
interval.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
Jason Angelov (3):
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes

 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)
---
base-commit: daed51c9105158768a3949395135aa6e0a04bb7e
change-id: 20261112-test-age-ms-filter-9953843e7204

Best regards,
-- 
Jason Angelov <jasonangelov@ucla.edu>


