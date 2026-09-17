Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E632CC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D294F6B009E; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2556B009F; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53706B00A0; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1EB6B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 247C31C19DA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:51 +0000 (UTC)
X-FDA: 85221915702.26.E583CB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93E84180009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbEGiilU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbEGiilU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617949;
	b=vhxIkrgEkT/toD7iY8fzWbAMxtBQlkKSU5Mc0c517ewX8GB5ikrXmAWzRkOJSkK+SRsJRq
	pLMi33WMUCq4BeDBlo51ivG1ym40pvbo1e4J8SHWF0TYwu3ZX/nlxOCXXq0bxBodm2CYA9
	mqgjvnajYbH93tOyN3Y1FEHqaccjHak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2I5kTm00UAvsmFfDHBSWc1OoiPGJbIihaNhsLMlExs=;
	b=SYoWPPhfDC5NOzzubgcFRGvHm9vC9234dHUJIZlbl0aRFgHINCIvRYECpg5T+BeFbzOnyv
	fFbopkxN7tiLFxF0DekFeZ3XEdnQlsZUlE4YCHr+Ugjdm26d/6rH34l0Pi5OydeLMT3nZp
	wR2HbOGCLcEgPVkP8ixT9bXfmrBNGUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5C1460A5F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD21F00893;
	Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617948;
	bh=x2I5kTm00UAvsmFfDHBSWc1OoiPGJbIihaNhsLMlExs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbEGiilUtHvbzcSVprrfwDriaLz1NcBFIFM7f+aKOBKL5mNKgovest/pgKTyy5YD4
	 q8G5E7jBqfdniulKmM4jZQ3ocxy1WRjfza8t48i0O9pG7meisCBpe6X+F2LFa1/Qef
	 DAIcZ/A8WAgBUOuEHnvM+oc7e3acTkiGT/g5992vV7hzAOy4IUF8Opf72l9/s4xu+o
	 uRzTsCjXOn943Tow283EKz63/wja1kzfJq04X58A78KYd+k5zDXLOFdcf2YCiSRQJE
	 CSIkjSovOmcpaB1sT7B69qa8jRDMee6hDfAEuWcSr8o0ke+3xJ8ffdab/PhuGj1aJQ
	 QKmaZrT1cOEQw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/10] selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
Date: Wed, 16 Sep 2026 21:05:35 -0700
Message-ID: <20260917040537.107341-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 93E84180009
X-Stat-Signature: zea89tombeyfjfk5i4cgptwcsb8ipc39
X-Rspamd-Server: rspam01
X-HE-Tag: 1789617949-787319
X-HE-Meta: U2FsdGVkX19uzA11skSBTWMjKmE76YBKngoC6pFmTo+IGbgjpkctNHYsZQGBZZWOIXZkIRxwZdv7me1chpO5USq+0FmY0/CZwF3tytAfQeAsxB+DwQLLiX9Fhf1tJfMQELjPkKqRXuBl5p8TrpIlo0y9Ser3IJ4jE2FGA5psfA6Zpj78OXwEsQou3tuzqCsTiu1lfN6FoOta2xsiGVd8oO6jMpK24EpGJnhkyDNJlakSq9Bubh8oC7uT99WMwzCYdiMd1LygATBroM9PucjpyCgYlGpNBXBCkIWCer1Yp84+DLxcZ43hhP+hDtkU5ZbPFHvR3uJ1SZdEYbJEUjQmwpCwMMmmwEn7xfGaHWAZ/HkF92hcrT+EvhLZsARNYq2b60HlaAabnd1wasJUsLdfXfwij5BH+718Vfd3z074d4iKNvGJoLc/Ah1nEGEWqU1qjAJQhnSwZQsOQpSRcNqNX0q2Aj6Whihl5jJfJSKBdxiGNxgf4lObacLRvgjn5ZTDPoT+kAo8nEwKE0D5fzMRsGzSidgMnzLtgVrnDwYFuY5oi+v32x/d5PG8qHEpW21CqKhI420FFOQvG3+smIysnOIVzhlclE+3X9BoFpB/Jge21OXHLq2Nv17OZMBf2gE0ft1nIhZVyL+FH1Oc3EPQ0S3bL6ke080Qi7mr/4nZTry5gZxbpiV5QZG70JHHGc8AQ5NX5C3SYr86c3+S6ZFMsmgRXNYR/qkA9EfeAvtaBPlLTEvpjyAFWuiZs8TJLX5Or7n+x38UOUYdsqVqP/zrCk43v0onpQFtwycwx3wCBnmUf4lm4j7zrzfGJWeoGodac7SkLjxpiKrrkixnjRKu9Y9HblhgywL7NWo391OL/CyZdVdsufiA21iIGKhVtMovrLeeKLcS3p1JAgWip3QG1sgZ/Bvem4/0ZdFcYePfwhX0gD8huUO/fCQTJE0H9ZZV7vMOZ7LTylT+RvNqAHN
 fmrhb9Yn
 BOr8pCPZ1UEbZdabQqUr+9MKMmVMVitO97Dfw4ykH74smHTXCkn3AM+gIH2sqcA0RuNVY0Lnf/0LRcWeKMf4CzozJdEEMDwQsJOlw8rt+CkmxtrpNLf6c2SxOzzOIe4nhvmtPIRF8LxH7sRd9BD4jZXpFyQoV2WqzKOM0F/QY80/jrHrIezM3ishiYQcu6APicUF0ROvRQdLxt1MHD2xfTnB9T0jg6SsL/5mIBvte7i/Jdgs0h3ov2KFrHXYS9CjRUIEkaOsrQj/Zl11rCERDlws+aJTIqzVz8Y1sK5D4ucEc2W02LECBvNdkWAtddfLJBEvyAuHPEGrxeJeyhFfmupFowACTTKLeRN3XcdfqMkBNrqvNjupA9M1GPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The selftest can fail for any leak if it happens while the test is
running.  Remove the false positive test failures by further checking if
the expected leaking function is called out on the report.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
index 33a7ff43ed6cc..34c37129c49fe 100755
--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
+++ b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -41,5 +41,12 @@ if [ "$kmemleak_report" = "" ]
 then
 	exit 0
 fi
+if ! echo "$kmemleak_report" | grep "memcg_path_store" --quiet
+then
+	echo "[WARN] memleak found; apparently not from DAMON, though"
+	echo "$kmemleak_report"
+	exit 0
+fi
+
 echo "$kmemleak_report"
 exit 1
-- 
2.47.3

