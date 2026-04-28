Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D218FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640266B009D; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9DC6B009E; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D4D6B009F; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFBF6B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE9F28B749
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:36 +0000 (UTC)
X-FDA: 84706244952.01.FBB8029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 43E1E40006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3wwXZDm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340075; a=rsa-sha256;
	cv=none;
	b=SZZTAFGgFergVK9mzCDmvxJX/4fBQp7FrEaLXOaUcNoKJEORgNw3HpVwsNU/E6crBPtTuE
	phmn1nS9GQqiYQ1bPWkvr6yFbuH/iySdsTrtW5qdKcDWJPXxVcxA+Nk5dus2fdIH+xp+xY
	BdMp10Wwq6QHxllG50/uQ0antKqqNoA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3wwXZDm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=hrlXRY1pkxbmpBtwVG8hq9T27TeyCdJzV1Zr8w5KvnEA+3qwhE2zh5yQj3Put+4MviEHTw
	Jj0r2Qqfr9N1DYMM+A+lf4EjuDwm8xuvWuYIC/WRHX7OD4coJ/O4fPwtItAYCvs7ytfWvm
	cjwgrySkJOwCQHhzYDITI/UpM1lb3vQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7686844130;
	Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E83AC19425;
	Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340074;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3wwXZDm+0cTWZv0apzvd0Puqt7zmIVRJDT3ZJEjl1LYFTmaoffXrM8NTgnQB9KFx
	 1k4UOvVYqfB917urjYIWY7Thvm2rJ1u6aS8cPrZZKrMyVVmASDDA9/w52hhaLjUxuB
	 098Sea66YYRctrAsSmK7BrMwdeXgendh47a0D3kDwzrImPAXnmrrVLZHnpQ77nJQ32
	 ZLbLa1bDcRvBHJvggPFHoI7B/9m2EUPz2uMib7PMqDF99AuU8VHtoG/Ff8w0lD9O6l
	 yePmUJpjWQW80xy7m67Qqb0Ex7I1Vvb8Pj1wCpq7fy8b0+YThX2x5TiGvsngklZ6SK
	 FX1E8bX8A3i4A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Mon, 27 Apr 2026 18:33:59 -0700
Message-ID: <20260428013402.115171-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9i51ndaduyamqcq3sqqfz7zz4fusygbs
X-Rspam-User: 
X-Rspamd-Queue-Id: 43E1E40006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777340075-907549
X-HE-Meta: U2FsdGVkX1/3xiaWpKGoIix+UnXQlGUdu65TGpHssZi1lv8HdvsSnvw4pxrl0mu06ftFcAFoNmRDIl5cta3gaUr0m2YD6z3iQfzqBZPhIkriP87AI75oQB9w9izavWhLOKBFr+EaYiu4M06YUCP1R16QyWdgHSdsGa56MrPHOiipdGwjQV7+0AhMBgXrJk2NvDbu0XKaTt1JDtZYpBUX2RTT1mJEEBnJXvo5mAJaD5+kNZpUKUfLnm7o0SkYoBhZ4UlWMK4q0jhPbMJ202OehVymizO/0fijXS2P7Vm7E3UthP7ePF5I8yy3446svTgbKXckdtiz/+8B4WfeP1t7xuBGtJdwkvam7IYm6yImU+pjSILnoad56gr8u7RPYDJhiOIkasEcB7gInud8q6966EYzzd9//KQHNHMq4nkd0kiQNmSEugqmmDle7JQ8gM/4ssbpgPNk2r4YJpGCRLBDDLQbOt99vgsX/DZY5CNOvOwjjA/vf8ypnzsEVSMLKX348qFHnifoCFjyWj8hmQGPkeF4JEcunQNoqOABJ0IMfLArtjaNRt1BNYU9BHrO8+dqkXBpu/vgtJ8w0heUdVyMAvUlH45OI9MRUappzY6ggS4K+K9GHtfacyDR4MmfbZW2X9YrK0Y6SXaOBJKfM4UcZ5/XjmCIe7caHOyVOyf8ma1TrjaqQnabJmRWPpNGZARXhIQGXTFSiOHNH6cIxNWqRaDPtiUvkjrzQ/wbgEh9RPFC+zPpkzwLgkP6i9ke/HUt7JZiE3RhoBd6BZejaVQr+K8+NQWuq0GVa9U+hejJI+RrFFUj2CMb82e8Pl1NMS20T5x8PKNsUiXDLmIBLLFjdEIiHe7cadjXmL7c1FvTERlPCbbBIBjfRRYtQKC9o/S7gIPC4kXc5J4FtCKFrAQseJBAuv+aTeD3mUujW7XgTzHjZYRPmT3TLA9oIdWO3xYeemFz9dxZ8eERoqViG9f
 6XAWN5GO
 /384xVazaXzAwIBPBBZ+FL/lWe0SWuMasJY4OpE9zzh/ostW34T1uf/vXo+rEN+eurv87VusonIZYUudy60gOllD4s2ak60YH0D6htasqvfdq+e/CGKGXcYpjWexw3v8oWMkqSrpehqatvH/Mw3NRd+0amvYMeTPaMiAgtY96oTvyKteL8J4vmcgoPSdJjuAqqelbXUvnx5Sf9SVS+lH+agylF29Lt2I3hmk1PjiuY3SiZ+IZMEbiF3lbCfegkup53E6dkxg5TS/8XgIg+b90Wup0mQ==
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

