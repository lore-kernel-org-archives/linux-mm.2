Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B02C9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B43C6B0005; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957DE6B0088; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835B46B008A; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 708C86B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1DEBB7EBD
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:41 +0000 (UTC)
X-FDA: 84339819522.21.CD68AC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6529580006
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJXm0FAm;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R52eT3bUq3aUJA92KBAa9l1pw3RQvN3SKU/PCyPJ3n4=;
	b=Oh957oSdlIpRe/OQiT5kYqdldGxsWzTttWC04MCd2VURMCsWT6Hh5xyDIn0qAkX6uF7zx1
	g/fdNm1STwBlLr/C8Anw/s0iiwtQt//RRCpdhLPecALjsGRizTrORWmOdIxE4mbYL82Q1s
	DIsQQAjYaVP2RZE3SYN9opYE6GAssfA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJXm0FAm;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615660; a=rsa-sha256;
	cv=none;
	b=jXQy9BPyNBDMaYIyXnYZdATARVVE/Fa0OdKEwqtv0XRkzuu9+Z/bNLnA4wgCvOFJ1LVPek
	uIAuVUpH06IZYfGInA7ZE5xrutsQC767ou3sq4QMqjVShixvbxC3LYcrXBaRTMp4A+AIT5
	ILY7atU+tMKvblG/m3v28hkn7o8WZEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B175A60153;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C06DC16AAE;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615659;
	bh=C2QHcQZHqTAQDaO9DNebGqZ3A/aRqpTbgJDZ81lxP1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJXm0FAmw5o7Zyyw0HQ5vmJJXUcfUtEfBgHFoq9+OjGCg59S0H6FkN0JT9lptr+7d
	 0ePzKy/5IaJIzOHvvogDrFClUZEYUmTu0YJXcHrG3lGwiKUC9K2i4af9MCsMlUQFc+
	 RX3vnKMtcB0XTPE0RsZaWxMtbBUa3VsAGhcWNGRBzdRhjpqKE006BZRJnb865ci5Ei
	 PHkOttph3EjUwUtsgx9XLQ6Bvg2TVUieHhuGd7mfm03fFQAGMo8WgEorSrxe06juXV
	 uDdIsESmoRp0InW3CqGrtyzM+R8XWAkVlC7FMgCLfO+fB3/Md8SVqfzO5ErfKX6+aW
	 DoimfPQSCYa9A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
Date: Fri, 16 Jan 2026 18:07:24 -0800
Message-ID: <20260117020731.226785-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117020731.226785-1-sj@kernel.org>
References: <20260117020731.226785-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84bubg6kfa7bdc7aisiw3jgkbaxrojkr
X-Rspam-User: 
X-Rspamd-Queue-Id: 6529580006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768615660-848416
X-HE-Meta: U2FsdGVkX1/EIfEG3jJtpT7veI3LnpdKCbwrDlZRswwwfyjuZaO3XoQfoYP+U6K5mU3c7D6tLEwitWFYsvAezaLnJfCc0ejFqCqKPXOtf1fypD0Snsg4SE9TVIHqpns08gP/sr68+LiVyv3fhGx0yQHp70JaBdh2lnkrnR8bOuWX8R2dweFV/MgGWO6poXHsQFmVCFKMFf0Bd7N/tSchxlJWcj8bw1r64BUFZnCoae7pjbSeQqs2bST5hHFCHD3Q33V072KqWOZjoG5R1axKvjTNvLygybJEF4JUHmMznTLfPiSZWzN5xSUUsiuloOluvS/O/a7o4Rx058RX9nTEVaT7VUleodLjMraloSP4QP7hFIlFcUU1HpPj7gcKmUfUUQzulkOhatyttEoY+7cwIHLyyUzDkmetIKarBl/b8hyfGAyMw4MuKGBLbE9HUediLdb8loQVLGhPwH/ky8Hraz8KApnXhyvuVbK9pJPJ5laWTj5ymG371olTTJDpcDeYnmMrkiT9nq8O5GtfRd5lSPOzgD4fLdF1zMoOB2rpOfTOs+6Uu0DGmTFlXLosYx3/+A5iMT+9t3Qmy+FzBmDlwFMf2n9bUS1m36uhDo+pLugLWQ/CnxsSQmELlSHDsKfMAD1TYKP/qPwYB7uydOrK5pHDvFOhNwu30aPvtG/L29dTEGW2t3jF9vvAzhdMMHEU1b4hEX1VdnfytUKTml6GHOt99MAWlGh+sZmIKQhPZNAJpvznPBhyvblZKJMENZH37PrVHVOqn5KQYwaKRKhYbQu0LQPjulUplydEqr1i5+YRU/J4Cif+gXjjFZ38/KzXbLnobaXhkO9/47bHNTop3icPEogSlNUAdfhQMpMY9H6ThxyyrqhIG55lyLkxMDZIWfXA3vibeJq1olpGkaXm5kVD73VavKzp2xwWF9J/Cmmofwz6qi/to5/aQ5vigEgXWRKt2QgUJyyanpsJW+E
 lpbWVFVQ
 snCqgN6ncog7ZCbav6DUsnYFQds+bZiCxyqB1YQp8tG+0yXSRSJrX2o25OEuCb9Zpcti7LjaO8q/90Z7fNOyx2KKk0a7NYYKn6rdjrgnUncA73ibX82QtLw/LkUCoPnXA4IFm1qLHQre183QNNsmOuhxHKaFG0GLaJKJ4Z7wLE9OEEfjEDIGboeIeGF3IF9jY6/8Ewts1QZw2sAaGqN7XZEttgdbJ6sjXrrHszbZ5EidXeaWYndFg+wtkMAp2o1qylb//fWHqo2ct36YFkF6G0fhk2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs_memcg_path_leak.sh determines if the memory leak has happened by
seeing if Slab size on /proc/meminfo increases more than expected after
an action.  Depending on the system and background workloads, the
reasonable expectation varies.  For the reason, the test frequently
shows intermittent failures.  Use kmemleak, which is much more reliable
and correct, instead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../selftests/damon/sysfs_memcg_path_leak.sh  | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
index 64c5d8c518a4..33a7ff43ed6c 100755
--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
+++ b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -14,6 +14,13 @@ then
 	exit $ksft_skip
 fi
 
+kmemleak="/sys/kernel/debug/kmemleak"
+if [ ! -f "$kmemleak" ]
+then
+	echo "$kmemleak not found"
+	exit $ksft_skip
+fi
+
 # ensure filter directory
 echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
 echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
@@ -22,22 +29,17 @@ echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/nr_filters"
 
 filter_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/0"
 
-before_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-
-# try to leak 3000 KiB
-for i in {1..102400};
+# try to leak 128 times
+for i in {1..128};
 do
 	echo "012345678901234567890123456789" > "$filter_dir/memcg_path"
 done
 
-after_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-# expect up to 1500 KiB free from other tasks memory
-expected_after_kb_max=$((before_kb + 1500))
-
-if [ "$after_kb" -gt "$expected_after_kb_max" ]
+echo scan > "$kmemleak"
+kmemleak_report=$(cat "$kmemleak")
+if [ "$kmemleak_report" = "" ]
 then
-	echo "maybe memcg_path are leaking: $before_kb -> $after_kb"
-	exit 1
-else
 	exit 0
 fi
+echo "$kmemleak_report"
+exit 1
-- 
2.47.3

