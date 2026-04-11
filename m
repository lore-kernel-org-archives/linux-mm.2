Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C143AF3ED58
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D596B009E; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79C06B009F; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A416B00A0; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96C406B009E
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75ED013BC86
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:33 +0000 (UTC)
X-FDA: 84646861026.17.6EB3589
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D90421C0009
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mSRb7Nlj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926172; a=rsa-sha256;
	cv=none;
	b=0I+yvyaNtm61NgyXFS4ZxgE17WQupfTFDVaxzhClnkmZ3wXws3mJjSUZz2PY3KJpW/IbzM
	E2DznwqMk/zQRq6oXdl/VrqGTMTemMUly4bPWu8g8CG5668LwLjqd99meIGz5BVDNv1TIW
	novp36ICdjPaHSLYSs8idL5OFblXIw0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mSRb7Nlj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=sqfYRW3dySJIfNdbUuYDDOT7h/YDiENF9zACOJzavsCqpkkm0+U4FftHvs0nNvrm70il9U
	hF1IO+uSYW9RapcCHkGN5q48HhjgLjxVtOoBkfrjcbgLfp4vuBZuXapHSAjNoYdFL7AA5u
	2lvz/xbzqP5AvkqCKLx8gHOlRxZZ6VI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CBF04380F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC73DC2BCB2;
	Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926170;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSRb7Nlj0CEuMqdwPiUtYj22j+aidCrKfQCC8QHJuMvsYqksw1GmtpdoD/xP/t0QC
	 CF1SK210iYJtgmuzwF47hQco2usECeUMcf+yUG8Wk73AoFuHT13Wi49y5BeyqWEDDJ
	 1I69N0PCOvRgjvZSlZvIDPYBchqKxkw1UBXzZdsQRF/Tq9G6Xvfxo9duVtWnlwdjjB
	 UPZMEDsBdeV9f7CdPZyszS5Ahiuj7P6L97HMm1gvy70VqQ6tQ6SDrK+/Py7sUEdD9Z
	 jpTmaXLfZ7PHYkUZh1kB3sysKvnlhthcam0DTrK8AuVeapnowo7VFO72p+lGPtreCU
	 JoR821Rqic3XA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Sat, 11 Apr 2026 09:49:03 -0700
Message-ID: <20260411164908.77189-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D90421C0009
X-Stat-Signature: 75pt63e1byewzdebnjq8j3myisp5bxaf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775926171-595180
X-HE-Meta: U2FsdGVkX18d53eoNGdsQ0rUEIV9jEipt6ZbHqvVNht0yfhYGmAgrdB//biOv/vWnBUIkuVMOXcZoEOX1WDv/FgUJJXyFHr5uyz8mb5kvNVcXCKvgY8jXCVpB9B/FeNpj0IauKVbaL2QDpF80OeqThFJeF4nHlWb4FOiSp5P4lfUSfm+UGjofykwkC+bhsIQnIvVpb9MukzJvQva8sV3D4IgXzT3dvTaWhZCltKUL5Tv7ALZHmnA7HnHuoHcEW3e/7+CwFoWGhpSdl6z5DNRmpRIOYnprWkUX1kVMgwAeKcVKGcbCmI0QTOYLTFN8bKaiYgzo6mCUseIbExCa20myrvp3bBjNy/SEvaMyTcsiHUZv2mf67+hanWghzJsRkI9Du08LkdLS+gmculmVB1O+gBYbIqc4AdXeKwe32EvJHteCYa4DY55oBvfDvoHJ6q+nalTLwQddCPqbMf0ZMGGUJGJs+5zh5DScq+VeC+RKAtovPe47+w4l4h2KLVVQEBKhqeMwlIdr0j2N4fFqOdDQFqP/Xyp7vp4U2xVOYNHZIs132Dvex5z9s7+S/JTjMieVkZil6LoOI0HG0hMmOhCJvOnUxAw07tRdRNavyhiD8G8mrm8oet9qPp1/doh5+PIU/dfTT/Zu+l5b8LAQQP8J1Vd20ljaaNM+dDdo1rS9KmpgHbvcbzOVdyBS0Bf9BSsysG8bLzayuqi5hcZdzFFvnOJNtpqcbZZrBbbJQxTiXMhZB7kve5iHdOS4gljFGlrmOs/UUe5Ps507qxk7QOAkoqlAvMKUHkOjJvJXcwv40/SR+nXtXnx+5xfntzF7FX/vJpphe5nHdZ5jvMkS0Kt9Vbm7DYYpFhqLoRaMTUGGbsN6k1p24pty7tF3O0v1pp+1Pw1F+kIcEwuTv0k+E7A1xfd1+vdJIxWYzyV0Hz5tDqVK5okQSwoagiG6EfIxOtNSTWZxZTdruvJOnxlMWK
 /ni1oP3B
 tn1H28TjvpnvqhYLxrjQK1F5VlPhhGhP55G/EHshkoO+cRj7D9eQyt6H+f29OiLgdcbrf9QKhkoEdmY3diZSvEEuh7FMgRyKkxrbecRmR7+zDijCimkvh+nnqgeBXjHutkU83WElASP4rWT/ZvWw93m1GXanCJys2SJZyBBk6z+C1FrEui4KrtP4EbgQlQenyapYjOO4nniqsII6Orp4/tH3Tvi9XOwq5hWbExZeRkd4+oMkuB4DTFrUH1FSAC8KpANFYnwn99OuX0xCp2OzW2iz/PLt4w7bU6Ri9BwqVzUiZndJtroToGJxf0tvmMKioVt1pCxNxPipK46/Kqmxf5B8PuC03KHxFoMHd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump DAMON internal state for DAMOS
action failed regions quota charge ratio, to be able to show if the
internal state for the feature is working, with future DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5b90eb8e7ef88..972948e6215f1 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -112,6 +112,8 @@ def damos_quota_to_dict(quota):
         ['goals', damos_quota_goals_to_list],
         ['goal_tuner', int],
         ['esz', int],
+        ['fail_charge_num', int],
+        ['fail_charge_denom', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
         ['weight_age', int],
-- 
2.47.3

