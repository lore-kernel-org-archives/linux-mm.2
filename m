Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8120F327CB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366C46B0088; Wed, 22 Apr 2026 04:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DD16B008A; Wed, 22 Apr 2026 04:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A196B008C; Wed, 22 Apr 2026 04:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17B876B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:05:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9979EC9739
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:05:01 +0000 (UTC)
X-FDA: 84685456002.27.AC7FB32
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id E75A04000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:04:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UePOuQRi;
	spf=pass (imf04.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DItXGjCrmn7d94S2RI3cNWwTTtEvovQ6aSZWbg/Gdoc=;
	b=16xPSnZGpzGXX15sIXH7ul2YXFFrS5PDpakxKNtmFBHOrpl85EG254Mw1u8oaI8bS0jVBl
	+7Uq0765xKgfARlpX9sTx8q12+Q+ahd6OPr1nulVPf+sgafkUSorAG9l0GBdPeY4TOViCL
	QgxPlFy8up/t2mujzMeqvYgUlPLVse8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UePOuQRi;
	spf=pass (imf04.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845100; a=rsa-sha256;
	cv=none;
	b=nfwrDM3Rf7YY/8+oyMIJPQkuYWxxf/rUAtoWC+BWIUiYDUv0RiggTpm8CNQbhrgehdJfTe
	j8zLXcdAd90ELBCSJebegWVg4ds8KTJpKVRcuKaxfp6Wu9cLLYHkL8Ac0RyNiOy0JpLFn+
	2T+y4XoSOp5uV4rfWIEepFcSs/leANU=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35fb0bb27e7so3304579a91.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776845099; x=1777449899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DItXGjCrmn7d94S2RI3cNWwTTtEvovQ6aSZWbg/Gdoc=;
        b=UePOuQRixDgl375342kivPPr/IT3EdVhq/rtpDLzKR4kTRy8KKtJt4a7ZY+abN13Oo
         rVq+qg5TtHE/agm3+remYrG8l9D9V3qv48G+ljrNx/SU7nYSV7Mm3eO8bx4iyAXT+OvN
         p3SPZA8baIQtiaoj9ElZxr9BElwXs8aD1VpdMIdKa2uWgUUQm5aKvmsnPex3SiFWlewS
         RbkO+lzzyySCigzAM2+tN0RDJ+Z/SRSd4NZRhzy+X44eaWGtR1dNiuIoMY44CnXWkF82
         /2j//Ss9lHMPNLT3X2yqveU+x+fbSy/bES76rJxagHngUAY7f/UNhcm6Yb4UsOt5lWgu
         gqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845099; x=1777449899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DItXGjCrmn7d94S2RI3cNWwTTtEvovQ6aSZWbg/Gdoc=;
        b=ViRHDoqI3LvWNQYZAKjS0RlIfdnMw5g30gHOg2VT15RkVl21yxv2dTDM0i5ivZ8HsO
         g1NMZoLEpQruS9B6S2krGzH0SjZdrS7onu9MjcBpRBEapMVnw1SdpN42YvjI36/oFpjJ
         xbzpk9+I2HbrF1eaaafqE0m0olAnXXvuKBG7yq03/NPyWRLDIq/Iv8jBsAoJYeZ4InvD
         kYT+DaHz54jdBtaGEpaLJvOnQRyB+jboGIUCqtsPB6SB9PiDc5Gx7KeG0vax3X3pMkZl
         mbrcyiieaMenk0/JVfTPH/2vR2gn3et9a9C/fuHul63vBP8qX75796dQB8S6EHT4WEv9
         VHsg==
X-Gm-Message-State: AOJu0Yx/tMJJnGwkEaAqjLRjSsKYz/DZ6na+zUZICbJrtdPQn1Jr2iCz
	MMBjvQzFl5w+E2ORHO2BKMZzn5YWS5bertw2gQutdyuSdFFV1mlxfv4=
X-Gm-Gg: AeBDieutoj956Tc+89z8yVPePblOJS20pwVFQVZm0R6gi1sxXOWdrJ/6hMhz27i+uV1
	S1YGcm1aogP6R75aQoA8mlshe6+NcklIFnnD748phQS198DGHd57klsC5JpfeZczJzXCjCNh022
	Y+B0heTOT+E3JG54MuCc0ZCrYjRpaUnQEElgvZ+veN1m1cUSaYm07kCf/sqbS2traDsQ/43kLSy
	9YrMEH+bG8+DiV1ws3VNtFFpvzHDiojC3WLx5bZGMmjkt5aSyBSJsaog4JbXNaCQrabSpNByHFY
	M5ALKF7gvs8AHu6CCqei3qo8kCSO6uShb8JWufkxfJ6zb0DaStVuZbSZpknoJXqgeNsH63zdCoA
	xUUJhnGoSCVo07I3Uhr2WNFgNYY+Vups4shqNprG4cUFvF0nXNOqe10cK1A0HoacA4m6qFPAPp3
	P7SX092X45YIfy88mJSj9uTqT08ifOre7+
X-Received: by 2002:a17:90b:53c3:b0:35d:a38a:a117 with SMTP id 98e67ed59e1d1-361404745f7mr22559423a91.15.1776845098695;
        Wed, 22 Apr 2026 01:04:58 -0700 (PDT)
Received: from thoundrobot ([43.154.64.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fb9b121sm8508494a91.5.2026.04.22.01.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:04:58 -0700 (PDT)
From: Li Wang <wangli.ahau@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] selftests/mm: clean up build output and verbosity
Date: Wed, 22 Apr 2026 16:04:44 +0800
Message-ID: <20260422080446.26020-1-wangli.ahau@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E75A04000B
X-Stat-Signature: cy9it6hzf43ebzrsgawzfxuuq8q77gu9
X-Rspam-User: 
X-HE-Tag: 1776845099-627642
X-HE-Meta: U2FsdGVkX187BEjq+gYz5PNZ08X5yHA50lxN9qadyYPxzPuk+ls3zqUn2WbplVAr0t8S/rF/k3kdZ+L6F9V4hvxFo/sdBU0w42n5Y+z7wjAVxTe9aNDcS3Hs9KlSt5MSb1glKv3+V70NHWfF07du6QWIMRy4rkD/JJrxEFWPK9BhO934Hs2aq8n5/4mQsYO6ifvLEHhqLfHQlzU3z+dMvMDPwRFdX2LoHx/DD5B+Apy2tlm051gQGOb/6MmNHV3igfFRle0ZDThR9FgipJy066JCp0YtA64lfh9PU5KlKukTEoH8/gnEAGJ16E7+9SaCUlffTSTSzl+f0EGIQEZi9ZKw2BKAXF/W+5A/Q/PQXYGy+s1DkPHw6838Ue2pR9/nvYkvzIqmRUKotLSh3F0fMrrvZwA8Dl31CbD2MoHXtlLmFT1PQkyw6Fg+DP9VwYYxIzCCHiovXY+yX+4JklpJQSUZCqNpgSe5uzhtOuOuWYPbunUL3a1Xi6/Ax3956LKUXeE6zErMXTzfBymtd/vf4Ro+/cfpwVtNvyXZllitCAfQ6lWCcxVpaPAGrafDTov4jCg5raUQ/aVRWemoONH9HFuC0B/sNC1AiHez6BvoijDq0/ZTCxsGpckAhuZB2elTzhuiUJcuPOIe0AasDJxdETGYZowQrAD3D8ZlG/LUWhWQncwJC9LtEqpblho3mYfvtsClT0zzCS3pyviYemK6RBc+9BZIYmzWnD3dFJPtOEDhuml1Mq/6+61KaxYK7DDkb05Oblkyvz1rI1cSyii84nDZoPM8g3C4f0SCEQMjzIXjxS8F7VbZHiT3kpMct40UJOQg+1tLOEIVc9Nx8adJluoYpsycX4xmP/TXXiOMzW/3UxzqlcTAIXnjlX73NL+ZoIeCTIFopkDbPayZzrOna0pCzjaIO36AEcCIRzAGpKg8DFeBCmuoAgaFbnhOx9jOF7LmDoCIFFajjBFY1ts
 YHkblz0g
 Q7DIqaHzamvbS2zk8cmyVsC0nhdfOru4nAP/kOeo/sWp+59UlxD7vlykpyVds+bDwrhQnlqC4agQ2GzgGP0VRkZ+IxnnKQCHXkoujPNr4Kf5iiM3Cabg+DRlM7wt2rYTzZck4E1V911tkjaQHPtegIn/9zaEapbhkMapXVUBRK0amlyOeH0RIrz/U900AMfhhVBPgvpuGSbraavxDF1Q6C9VjUqlnbtg/4oubJWEBV5RKtyqp6a35PajGyWfAkbMu86hAF3KiDLWh3AefiIk8fOWMeZTXglBN4XwANRVBGeixvCzidXvOkENJljX9sEOtG3JB70bdU/G3PFzdYlzr8d2tmR++8AkdRblto4vDhpOGHZAV38mWfG49ol1Oi4TdlqeDKDBuZT9D2SSY2U0bqPdwkgVqaGz4w9BsRUhtb/cIbVEpdQhkvrXYBJXdA326ZVKp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the build process for the mm selftests is unnecessarily noisy.

First, it leaks raw compiler errors during the liburing feature probe if
the headers are missing, which is confusing since the build system already
handles this gracefully with a clear warning.

Second, the specific 32-bit and 64-bit compilation targets ignore the
standard kbuild verbosity settings, always printing their full compiler
commands even during a default quiet build.

Notes:
  My email address has changed due to employment change.
  Previous Signed-off-by was with <liwang@redhat.com>.
  Resent it after -rc1, as requested by Andrew.

V3:
 - Nothing special but email change.

V2:

 - Drop 2/4, 3/4 from v1 to v2, since Andrew wasn't able to confirm the
   patch works for the rarely happening issue now, so I decided to just
   hand on the process of the parallel issue.

 - Refine the 4/4 patch only to hide compiler errors when missing liburing.

Li Wang (2):
  selftests/mm: respect build verbosity settings for 32/64-bit targets
  selftests/mm: suppress compiler error in liburing check

 tools/testing/selftests/mm/Makefile        | 9 ++++++---
 tools/testing/selftests/mm/check_config.sh | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.53.0


