Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA2CC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AC46B009D; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A8F6B009E; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CED6B009F; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 802026B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EBC040393
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:24 +0000 (UTC)
X-FDA: 85223469408.30.1E4DBCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70A01A0010
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJQfah9s;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2I5kTm00UAvsmFfDHBSWc1OoiPGJbIihaNhsLMlExs=;
	b=4RSGOMQct+b/zM9DntJQ4MhiZQX0zsfRMoQRbf52bXXDybbYNbTXS9cxmRlqb/YmfAly8t
	lj2DyItYGHV34GeMmpJPZcZYqHsE4yJRlRSjL0x/lfPnfphvr0zIogVsYq3bnxOdeaTMRd
	lk4Kuzyg60Ofo4v2hKwHMOCWiuCX/ZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654942;
	b=JQSh0zC/WpnFoOalg3Hrl8KttPGYV0z4Vu9VGqAlGBWU8KNPWSJ0djt5G/p+jppV1eq1ef
	jJ4R7AKC0X46C3axoS/8m9PGmXCGj1TYvVfKicpRMFDLgnkKCe4YL7gj/4w4m6YexJC2r7
	l0ZgPh8m5RRFw4uWy+fBzn1ayzvif54=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJQfah9s;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 146CE60230;
	Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8A41F0089E;
	Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654941;
	bh=x2I5kTm00UAvsmFfDHBSWc1OoiPGJbIihaNhsLMlExs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJQfah9sHqknVxHuAUuZPJP5U5a3RQPigf5dPsYTA/zWGy6sbDlqo+vtvXdSp/YjI
	 +/cwlnRNgA3sQDtPVS3bXfdNZ0Y6q5kG/aPwQdPxgikQ+rFKIxjNL7vk5Xq+bKmhYR
	 SO8ykCi5lNwav9Qj5zhnhAslmfSDRtznaH/Td75mybLfwpBelKAPPfE08hRd+8jJW9
	 dV9IFbjoGaEnxCsTYjOmAr2TkwfnI9wOiX3/dXPJnBWkyNoXm8UnxauagZHCHv6NWd
	 gmCOtomULGAZRjCqGbE5o6/dCtkzYW7W9916yrMN/eNLZVlLTOGyK7aYJDrIRZ8Tkf
	 xGxD0aahc9IGw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
Date: Thu, 17 Sep 2026 07:22:07 -0700
Message-ID: <20260917142210.90829-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70A01A0010
X-Stat-Signature: hw3etnago88pg6n9bkd9xg5h4g89wsrq
X-Rspam-User: 
X-HE-Tag: 1789654942-374483
X-HE-Meta: U2FsdGVkX1+XfMAz31n//8Di4klS1xwww1Wy7E8XuUOiSjAL0KUW3dPcjULdb8Kc/12TxYiFoMNlbLgIiQTwmdxIVgFnDZjG2EaPrgUM9EEHx1aPJ8DwCK8elWx9yO7SOGpBrbzBNjvELIrJLPOEc+91/mNHXSgMh0BDcZMvcpp/AyuBxhQqBdUiDB9r1/U68NlQlB/ZludStwdt6V6fmjubMOSqWkz5jHpB3WgjS71izDGchKivnfxnlbe7sNt1/x15Koi20KMSVOWlRhPkcS1jpR0Xw3Qzc3JpBpEx/RG5vpWljrhF7bYR0CLckxClOwC4WcV4CyG2DaSXBILF1RdT6bArezJQJn+rr5usXzc7sDABtY60I0SsIGwLjMGJEKJJERSKLNHHxnCt7ESEqvio7q4ZnmXdw1aUsuMCqdrKqJPR5EdrUf6y4EgYjquiGKdPmSiStFNSdStS82MaFVZrwdnBXQLxOulKgPUkMgYATyChRVyl99rXMPZ70GvAU6f365SXTgLCp0a8ZYYqBNkjWfTuHqOQ9axBLBdUo/Lj8IAeGTzTybNttrHZgt8GWylbnBAnCm7jsGg3bI/Zi1zFkg16NIlbqOGOy1o9R15UnV1HmazmXMNPTEB4ZP2GkQL6OjW2myvRn2PfHSv9olflBSjKcTJmsO4k8T8vE6FSwGw92xdI8uqe8QDxYHNxWJTrcJZUh2N6Xd+peiR3WejS8nggIoh7bX7M9/FgKEqQ04biWNCtzGFz5DBmU+8w2E987donttaSrUXktSIQYCqcbZk0l2mJW6wSjxDPL/7R/JIGRwSgGUpEMGE8z8pednDcA/AeyQGgdhexeEGF2ST2kDurpdBTiR8LuCOuXVcbJIKjStYRXPlOOKKn2MtyJ2WFiWX0/TJyVe7CPzfqcziRx7qpKrcCWuF13nHwtChXnS4aNQQqSCHtC5y1kHdc+iOSJdKXe15HBTekVmi
 pY4RXZpq
 7/PxmmDiCKsn7RT4IUsxiAp10Fcp//yvrw3uE9eOwHJ5vN4ZRyq/1K/NQOuCVcaSznD0RLYelxKhRTY40SU6AUFkdY1+J2B1G8qPouH46TaddCfSf8gpgiADNii7BpNSp14XbV2eYHLtKyPFicoYj8Fdsk1WstbEh2vMorhPk79Gtk+mWAcp/xTmp3j/Ub4ij8BGd/rMjlljjvBti9wGsGGOdBN8i1YFEXMiZgqL5cZK8aF/2dRS14UYODlK2zuwomvESCmHJtgU8S4vYI5oRTHFOx+3j6Rd/c1uxifQNzVPPmzs=
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

