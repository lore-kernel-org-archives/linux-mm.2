Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC3FE6B25D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C039C6B0005; Mon, 22 Dec 2025 17:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87596B0089; Mon, 22 Dec 2025 17:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86506B008A; Mon, 22 Dec 2025 17:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 977496B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:57:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 340198ACD0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:57:27 +0000 (UTC)
X-FDA: 84248620134.26.61C0ACC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A4FFE40006
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:57:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q4rIU9G7;
	spf=pass (imf01.hostedemail.com: domain of namhyung@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766444245; a=rsa-sha256;
	cv=none;
	b=HoPEGTek7R/t3kmGEndNmCcAEwfiJR3U28TYUz6+lOkyRnrWbDwqgQSzam8iyG+412/UNe
	HClKpdSx10gNcmad23wemgt7Z7GNo53vr+xV7i2sB79GFjhAkejf8B3KzJQUHlt7BYXE8r
	n9cibxrxdmR2hCigRhJ7hgRA1PC0+u8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q4rIU9G7;
	spf=pass (imf01.hostedemail.com: domain of namhyung@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766444245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NguvnFRuBJy3/mLBavaMslHp+ivpjY2fLVCtF5mOGQo=;
	b=3EUvLj4MucL9oxvpB4TMPZOp2E2uR26yeMTi5DlVTwY2G6LJ3f1jVLErfE4rRWIzpQEzpE
	KvErUSRkYqgsmCuXM3j6vFIMkbns4REHL+AhNwCpJ+nYrm4MPMDcXyUXrMhRsx9OjqKCTo
	OVybsaRc+h4GJz/UYZl5WmDIihUH1FE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E93BF60172;
	Mon, 22 Dec 2025 22:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662BAC19421;
	Mon, 22 Dec 2025 22:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766444244;
	bh=0a17z+b1KhA8Lz1K0fL/UR9O/H21Il19WH7GUt6FYfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4rIU9G7TCnzvjlDY+CL+7shqH9WYX0LAtIesk0t5K6XUeB27bU3gaLmOhGELTWDS
	 5DIy5uoy7AmVtrvDUZQ7/culeKy1ML3+tOQzKDxT0Qf8A22EmEYlgpzntlN2cr+8/V
	 PnUuD0Rb/2RMa6iphu8gsVpaFfsjt8ouWFA6KvczMaxQnUVAIC/3a4mlLs+D7kyLDh
	 ZA5QVlzfvK9lsi5lvDRm1tXziGmoJgoTuW4iG18ryBkFnp1PohFaDyV5S6qDCZtvQU
	 EwZLzfCVFIp6OFXsGgHNrZWgYa+vPFJdjWKrWcT93k+HXldZlL2Pask5lf7nUCi1Wo
	 BPbbYED/wr+LA==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] tools headers: Sync linux/gfp_types.h with kernel sources
Date: Mon, 22 Dec 2025 14:57:14 -0800
Message-ID: <20251222225716.3565649-9-namhyung@kernel.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20251222225716.3565649-1-namhyung@kernel.org>
References: <20251222225716.3565649-1-namhyung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4FFE40006
X-Rspamd-Server: rspam04
X-Stat-Signature: 6jgyfc6yk39idm8cnnwwstge1o99mnd7
X-HE-Tag: 1766444245-95744
X-HE-Meta: U2FsdGVkX19nxwTD9vs8Kb2lOMWxp9da8n07nq/o64qxeX9UZD52w2vN52PmSGMoGFOE7Srm/9WsP9U3dBtoOry40f5rM2WnJa8LNJQzIq+q1wK+hlcw50ees92MtQNLtAXCP75Zn+xb7n3eOLe1YwYiY1asYpZJW6Rw0WjoN3M2NprmCT6I6u/95kIld2OqOCAQZ8oE1dH93G//UX/zi3eQTRwLDQ8IZ5OfwH/mhDA5niWr4q9D66w5XuCC7/Ob39kVgMAQmG6NsBdxlaN8m17bp73b0O9R+CT/RtHuKxMckaNb2cUe7JofDxvggHbrgqPOrMEs8MrF3s6cLmhWEKVoe/NUygAHhswG/QAWUYNxknGnC5xLQs1xEzAHSQzIWH7/1bRjXO+hqZii1mnYDcNzV/NpkgGuxgXXo+gh5dQ3TmNSNyRX8gHxWft+dLCZPQJMPIK7oV0DI+YBulRRly1qytIAtPhsdhDEbuSju6ahOB6dVpqmZ4u+ovOyWvfbwfPaGXM8cUuWIb3ao9d8lHKhQM6MASIDfUwESMGvWrK4aPWj7mgLLrlmP6wVzkyoKyBtHh5rUZwhNbJ1h5C7r6gU7JmQE6FiqEfCSISUbWqtoN1bSkGDUXN4Txsocdv/u3TTJjInyUKw68bhGFWlGu52GEYoJUrst1gbad3/XtnLJEvu/De5gEf9Mz21IBOyioGHsX72DWhHtXF3Fpiac9TRr0RLUxQ7n0JQnQbcEF7UVPwQRr+AKvCrzNheIUOH3QNitE56M21lay+T8Mzq40FRG4IS3nXy3E68JJ2eq8EX3UR+ReZJWJGAKd1Tfj1+YNAtqRi0AUNFi3ECQUN0Yq4Oj5j+5Dfixo1ui7J1SSlabahMFgZcBGOrwkYyTg3wyRL4FPF9GQ7D7zhFs8xaLattXwmVQpsHjtXMil2T3wJ7dDtEbA5j+jSHOzrx5SAzOHnbc++XUuHI72zBhCn
 UppLS7Uq
 xj5+pOhvLrJJ9ruoB38GspPxtfNKZJOnp2SwKwcDFJa2EAPC0FW0xjATi+9acWHOaiMKSsqd7jjHf2HONENOKdF60e5gKRTz2pCBwaMw+k/YJ+OLaCJuqhswJ+csaXwtJoP41810+vfPo8+bdlGWu5G6lsfRd9dZMYnxvFij0Z2EryWC92+KEB+HHMKoPVGpkq3yn8SPCzlOYFtu4AO6poh5wWHBW0S6YNAC3nwovQH4D0cUgSVhyzzBjkrtm8912REvT4UeAzVs+dwnX1bMyL9u94i0m7RetlhvoCXmCENg/T+0TtA16xvbdRGe/8b04T830nXMrufywpefaL0iG87bS0fF2x6phgm8RM4Zd9fxiLSDQ5VkyepFPvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To pick up changes from:

  4c0a17e28340e458 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")

This would be used to handle GFP masks in the perf code and address these
tools/perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/include/linux/gfp_types.h include/linux/gfp_types.h

Please see tools/include/README.kernel-copies.

Cc: linux-mm@kvack.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/linux/gfp_types.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
index 65db9349f9053c70..3de43b12209ee79f 100644
--- a/tools/include/linux/gfp_types.h
+++ b/tools/include/linux/gfp_types.h
@@ -55,9 +55,7 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-#ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
-#endif
 	___GFP_LAST_BIT
 };
 
@@ -98,11 +96,7 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#ifdef CONFIG_SLAB_OBJ_EXT
 #define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
-#else
-#define ___GFP_NO_OBJ_EXT       0
-#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
-- 
2.52.0.351.gbe84eed79e-goog


