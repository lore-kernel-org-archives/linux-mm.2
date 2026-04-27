Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8CEFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53226B0095; Mon, 27 Apr 2026 11:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A8D6B0096; Mon, 27 Apr 2026 11:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67A56B0099; Mon, 27 Apr 2026 11:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97C276B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:13:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7918C1B96BC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:46 +0000 (UTC)
X-FDA: 84704677932.10.FFADEFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C906F180004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHvaeA9B;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=30lmDIEjhOlthvkHslnqLl3d1TqlU0PyU+CGFx+2ely0IGOGJeESkYMSm+VGwdfmEbGZ9b
	l3ntD2hl3QktmB/ofBAMjmd3X8VjqUo71PHJZSfRKkSqZbODvythIcIOCOeNHC/YvjYxvF
	wMopZZIRzLoMbdlMVsAJ1t4GeSSeMWo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHvaeA9B;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302764; a=rsa-sha256;
	cv=none;
	b=X5a1UfJsSbVJ27NBLOOAVGU0MHMMb1LbSA4rzSj4Hh7/U796t+wlHgaikxSaEYG+WGJDGE
	rM3jdTZRHXl1TIcCnK4n6L8Y2M7LR0dKbfQrona4AFtbP8ncTt3K1ZczWfyGXztX2qA/VW
	3xB0dYLc7jdwsLLepRbGTQ0/ztEpjQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E111F61141;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB30C2BCB7;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302763;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHvaeA9B29EOfNwhZ2BklSXm4t/Hcqa3SiTUb2DUOZDFGSxRDTO6B7qmoBVRub2Ve
	 O0HzutMREEg6GOFwc0InVJ4mlzGmbxWNwybN/i5sFNh9wWa5PSqIuBiUiUApIeQQdz
	 NZF5YN36/bPjjd5NttoNMCbxS88s2WUmdm3P91MzNlr/mMOFth39DNGPpnFjC1dR7f
	 7CuKeGpOaylKpV11mk2LwNVJRALqRuhdlAUpVKkMyEb6PaqbTLaOHei8Dg8PvLTYhw
	 hRIoESfZzSpHRUwj3Nl2DMgbzC2rdZjwm7ncKz3Y1MNPYp2MRfQ9GOc1gsyvSvjIWc
	 Aj4ogr0+dgIIw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Mon, 27 Apr 2026 08:12:27 -0700
Message-ID: <20260427151231.113429-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hfnyipnc3beo8h36s8w5he5e71fwjc8z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C906F180004
X-Rspam-User: 
X-HE-Tag: 1777302764-389547
X-HE-Meta: U2FsdGVkX18J8Qjx55wQOOAokoqrCX43OWCOKFc0+Xno9nGNY1bURsrSkOp+Gee/Os/9vXBNG1taYpG4/luvKK+zkrvN7beCLdaVF8/7pMjruBqfu9xAGd4OI9nvltwczOsaoRIuJ5eLYRNzMVGGAtrzWxXHLtAoNqRG+KBxCUj2aYNcIBbe49310BZZXp0KPAIEf4CPbnbTafM56rCi+OnYzhKiIkkBQemgGGyJbgRTrEhKEP5Nf0OnRb1MxQY1lVU4xdJTCpWdkyVJvHMXC4HdUEPBHYAPUHMMYpmuV1pEH9qZFS4GOD1HiCokDPMzRwNkbhQqxqyy4SZiGBfGmdgVUE+Rj0i7xr1fvs0r8l4l5n5jgoQmqMV1H23Gh322pjnAuZGl5HCiUTgYcESp7sys7GqMaHmsgrgXLgCoY9v0DrrLm/Wg7ytvAaAaMai2GYaoYxpiAEHMqq8tqH+FfK+X3coiFzyi5i4GG12sGOyvoAt/XAxW9btN2Pl4RfFP9s+JZiohLgqP0iJMh1X2aZqyHZNtE4YYNuQDFKyW/9qfi5pAB7ZGhZC02gldN6RFCc+YyyqUNbBi7do40TmtuUjye5LEACOdqSwzaRm++GIK8jRKPKnB6flsljKtHaw26EG9WUjgYSI+8DZR8mhS1WkJSF3DmWMqOmzjbk+VE0ODvYgTSVNK+QkxVYJX0HCf5VmEfH3cbq1RHrUBD+Bw4ZiLj8uLbnY8sH2TBYg9+S046YvIxtXAs2fq1EGUmHUf+EvScR2vz/lnMyATiWL8q13zuyg/ha2OxD/S3/GcBhftF0yajnnsvgLAXWzgbtib2jwdRjP8VwA+f7/Azo88Xh1eCrpDOPF9iGdV/ZXkSRGPSXEItnbZvVZRHzIpcCyEweahg1xSMv/QVXLPsDIL9qEOytPftTfVwuv3YXbWcPENAbtiJneKQyPLxeNdQBOM8DHlcfxRJWFhKp0UP2O
 Z+9PFvxc
 /oZ2yAiSytDjBmSmEDDXBXfo/GMD/c/B541yJYR/AmDQipu1M4JwxvsYSIBtsoai5FhAz6X5rkwCYzhdtvsV7iCFEg3pqK+i1Ty/si7rcsZv0z8NQKnts3Tyx8Ug7ZN6Hhb0mMumXkE/5p8yQuIRakDs/tnXonxcQcrZIdFBl2Y1+criPnlk/YZP7KqZcxuMsc3Nqn5cBB1nFyAAEEbFvbQPn95hWeFys2tDAOsz7EKESiWFluh7A/32pfIs2g9ODGKzpNTAfTbq+zq2W1yze9pLuSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index af99b07a4f565..5b90eb8e7ef88 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -200,6 +200,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
-- 
2.47.3

