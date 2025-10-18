Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF39CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 20:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4338B8E0005; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8C98E0013; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFF38E0002; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCC1E8E0005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2F4F47D10
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84012414150.28.9C2EAE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 035B0140005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L5YXq7PB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760820294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9soWyrpuTg5B1bcY9SrelxAau2zMO6r1lFp7g+qBjs=;
	b=5JC4yfDryMzS2pS2+H/nFOuLWpxIuCscDEEC97n0WPUno5jWI/5j4OMZ8BlNLCIUPEBPtE
	qlO2bLOjWjBWlt9Wy49kFLP2FU6IsqYYTjntQoJGsHdKi91iI1CRwE4ssiLpbVXyCMX1M1
	O2g28cPfmPSknkw94C9EkdE4crzYbGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760820294; a=rsa-sha256;
	cv=none;
	b=PBKb8Yw51bP+djxIKbdP3YmKHQVNHfHNz61HXMA4PQnAkLdtqy5CDuQJ4QDSzQbW4q8Eyi
	TGMGxGMeJd0EusDE7Wc2KLlFrixlO4W9uvpznSEzKo2ipt2lUmxLp9r/ItqsyuWeMO8dG7
	VnXtK7/Y8yL+ZBgB57D0yVLbf+iCOSI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L5YXq7PB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7F5346459;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC6BC4AF0C;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760820292;
	bh=bP4f3Y9B2E5+Lr10DKBGnctYdQ3B9BDoxl8h6OwnfKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5YXq7PB1giOnU7iYNgo/idI8CvROxrbR7jU7M0CFA1qnN+VQdIQSz/24Mf0uTOOy
	 /i4Qx+PgMTJFYi1wVBQBwxN30Yp48QF3P2uqbNrAjnLdccxUTnNdZGZfnF9PMy+cJe
	 fYQTRCk29XxiP2D+OXmw7RbFtJB4X1ZxeTC6ozIDGibAoYdRrefq+luzycLCEXouBi
	 ADrjE4f7aQVKLX7bgek+c33B6izgCfPCDB7BMEt+PqjYnkeIi0mJTU+md3EfRJ0/Lh
	 vEOR//vczr2Em5IAGkvoF7F/3SJEcamRTXlW8Jecj+XzMqmAMYrXR3QFSkidd5jl4W
	 Ox8byEWMuqG8A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] drgn_dump_damon_status: dump damon_target->obsolete
Date: Sat, 18 Oct 2025 13:44:43 -0700
Message-ID: <20251018204448.8906-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251018204448.8906-1-sj@kernel.org>
References: <20251018204448.8906-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: c9pp6yw1cscw1m313xkerc61t4u8g45e
X-Rspam-User: 
X-Rspamd-Queue-Id: 035B0140005
X-HE-Tag: 1760820293-578177
X-HE-Meta: U2FsdGVkX1+wQmdMl21udf8dfb99E3Bzz8aZ/NwezISAUeynVDcKj6dQS4Wf48x/gbLbc00Xxq4U0mD5RI2NSADMbClXxkWhLYy+bLrYb1I7lmrRojebv+EmHp+kYR6oWFHgJsB0s4aG8Do2+xlshVDANGRqoL52Jh7IUkcKxUjrIbbF/sHydOJ4L7IY2QH2WaDfti8cU+ZWlZRuHWhv1+xHCOgalu4BMA4Dvv8rX6H3Jn/NfSQ5QH/jCeC4MRvojFb5wxDqWcUMVS90i7h0tlQtH3IA6L3gyzitX2OcQxnNeavLPjUYNheRRzqjZcyynDC/fTREoOQbZ0aDhze+8dLqpGNftGf7Ux8Oz+yaniZg2rUQf6giNXX36pYOUzx3BxanwQBnk78N8UUmQC9lrjrns1zK3sb1Qk+SlYtgCFi0xxN5hr8yXxZkze6MKEFOuK/BV5kucSzCY0kpyqoc+YrskLrT0kZh7eDI02WWPZ3MbA/CLX2NYOBKi5gBIvGHmInK4ETiS9eYFlSTMTpOHYJrMXc+dGUz+UguuY1804P/iZBQZmchuQk5wdEHi8AwyjMupz9g/bhRaSTHF3Z4B/tv4vRrsDnCqdzAfEGS16Th3YYvfuRmi6SPu7/i3lfHwp0CYDUJpiZf4OtE0pS4sxOWMNcjnrDXH53Dbkc46712o08XbI8lxRmm6L+Bqu4axq0yLfqVaU199xcdoT+4ngOA9cn/XimChi/AaCdzO2xoSTff9OnOCyHEDoG7tQghkK/O10A3CXddRcrrjxUTmAXRo0u6yv/gvMi2PoK3y2pEBxnSO6wcTHMd+uIAVo+Ugi6ZiAttQXkEjLmkPK3s3tKSDdGIP4NUiE9M6SeAt5ukdBgcBti1VKhcx5qKjM7BahZNDQzj0IYzGKPdhrl8jqgT85SGhqQSkkHbX60vmBURuYPv5z9nd48JpG/tOGNfyUZkD2xzcwqYkazswMy
 on5lYAY+
 m1smPUVbN0AGn1yBH7VS2QMqhLntIKNzlAFzDulKdGF3BMeu+HXWg628ztkZLtb6SWJ3YAyzm4Lux4/pTMccnn/vKQfP7PDv/Qu/orMQvcHPMHLmykuLnLHyL2EUikn1cy4uepgpU24EltHLp+uDL2gmGchFR5GMSQx+NEWJuan2tvFkMQHty7rklyM2lN+HlWmdmaQXyyYEh1RO+igSHhTb63gaEhTVfcAr2lUWs5MYTSg0Vp1oA5idJ4Uzr5yyDRDSHSCq/YkbnuLV1X/3EdBkEqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new field of damon_target for pin-point target removal, namely
obsolete has newly been added.  Extend drgn_dump_damon_status.py to dump
it, for easily writing a future DAMON selftests of it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 7233369a3a44..cb4fdbe68acb 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -73,6 +73,7 @@ def target_to_dict(target):
         ['pid', int],
         ['nr_regions', int],
         ['regions_list', regions_to_list],
+        ['obsolete', bool],
         ])
 
 def targets_to_list(targets):
-- 
2.47.3

