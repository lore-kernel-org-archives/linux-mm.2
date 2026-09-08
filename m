Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF00C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0E06B008A; Tue,  8 Sep 2026 13:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251236B008C; Tue,  8 Sep 2026 13:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140836B0092; Tue,  8 Sep 2026 13:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E134F6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83F45A5177
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:52:34 +0000 (UTC)
X-FDA: 85191339828.11.DCC0AFC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id CCD4E1C0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:52:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGq5eRL0;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788889952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yuf7kW9a8gMm8dZPCPYh7BVn/yZWMPnrvgi9MavGUdA=;
	b=7R6zDKotzcmw+OfbDUKWcngLMBzhIHt+GlGtXrB4J6bvtdOgMeQs/Kjc4JN3HaHNmH5eDX
	D5efyn47+a9vBcO+e3UC9aXXxMdnXarTbT7I9GokPTpFh/5c6GbFdKbssduULVYq5tyRr7
	jVXTngTkEoIhbZAbkZGP9UJnaYMtIL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788889952;
	b=qmNyTxXoIkBmP4XgmuE0+b9GyV2HT/KRAP9+6a5U1Xgbj8jbigdAB00hqsJCF2mGlJVTrZ
	dV/2uQlKFUewDFHtdg28rfLGOORmYvgwg4EmGoqkRppSwAg5MuZwXoPyfwB2Ple1Qt7lE8
	n1k/L2f5kl65IKER5N9PXq5yMfA7SEE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGq5eRL0;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8557c3f270eso3034135b3a.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 10:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788889951; x=1789494751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yuf7kW9a8gMm8dZPCPYh7BVn/yZWMPnrvgi9MavGUdA=;
        b=sGq5eRL0PxdR9w66Sgq2bNnKGmdevaBPGdS8SK4jgqajyOYj5XH+e3yPiV9xHY5Dp0
         28IKcw+pnLEnav9084OZ4PvTdPeIUwG3goE5Yg67js9CLMQd6FZKQsXZVvH3+N4eHEb9
         cxR2doOetCol1h1H/9ApIx6f1BkQU+4uoWoYxkUOIo39bjf47cYvrpNw0dx44ffCXijL
         lSYOIZJJyumBdq1R6YiynNBOcdFpsWJHntjhJYOrSvLIewxDNcP3nzkcEbxpJdf+ZT0/
         0CVMn/DMye6Qu+YRn59gxVrZmuvK/WMMX85Me1hSbjySFtaCMiRw2uxupc7oBWQUP7Ei
         /I5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788889951; x=1789494751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yuf7kW9a8gMm8dZPCPYh7BVn/yZWMPnrvgi9MavGUdA=;
        b=CNz63HwZJhOjZ+JEG5JiNy7Fu2gLOF1hxAp9irgdZIm+QKjoKmx7ddfxFQuP5R6KHv
         mB3NwpQRDy8PjlqpUXOyyDxHF9oLYz5TT/cHKaXE5HJM9edEYKxz8AU8KYL7yO/X7v/F
         hr7hNnw15r19kv3pkf1NSikRX2/2SyMPJC5wXRshagUMicx4m0TQmELt5/ucil0k1vgZ
         IRpecXVAgqtfKNAxroW1ZxGk2f4KEpsfpnVaCdiGMKIh+pYCkSnzYr/e8LkrG67mVC1F
         6Woi7oVVNnsKkqIXPys3tEKJmujM0UJ/GcIt1ZvgLHvopWGLo2p5PSIbg6vQNycEIWgi
         DIyQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDIZsUfoWAEhkAdiZbYDm6huGTfza2ZaqBjNK8924DIabrZCSpancvtb3XmzKiN7mjABBzkDunhA==@kvack.org
X-Gm-Message-State: AFuF++nzO/Gnwq+0cfDNJ9q6ZZ+hUn30e+ryZH+FoJAkMP/6XEY5Dtue
	5wLnbIV+vcHViq+5/MqJi8mYIYDHdWMqWvgDDrl0PMqXvvB5qyLMR0Xm
X-Gm-Gg: AYBFou3kZvOrTbmI8Z9B/S91wS48CxkoS6CH7H/L4cnzXYnZcdZoPiSN3J6zHXzv5WG
	5ChtCYlTHDJY/Lp2SsrwSwfS+Q4Q1zhhChp7gHB9fxA25K6OvWztaULLKSUgdza8fg68rhMmvwq
	dawQ6exm3lC3dAyMB2/5mvP1lf8cpkLhGYCqXp7Bi3JPNWzGVp+4lJezu/N4mu6dTzQtrCglq+z
	O2YkXCSiuqEIQwqcgI+teTyRYvv/WqS2ewJPuHrYHva4hyU1exBRnveOEaP6IkcANZ6xtS6CjfG
	QNpZdsOgcXXrJ/bqQfQ9D/ZMk5uGnPrhhJhbtXFET1n48xuUPIxYIKcNjtdmSoRrWGcqqBPjX16
	ztWFE5GcX6f8jBeaw921k/7bvj50qVckomRn/5ryq9lGH7LL2xO6l4YbQEer69aBa2cEr2u1TKN
	4N+Nxm75f/AwvfwSxNkZEa3GUwz9vOuo2ZToeP1ZZ5FU5wevBhr2qzw9R2p3B060LC7bdVnwwpF
	27BFktGSMaSIGwLyg==
X-Received: by 2002:a05:6a21:d82:b0:3d3:af86:fb94 with SMTP id adf61e73a8af0-3da3a246eb2mr48825562637.26.1788889951323;
        Tue, 08 Sep 2026 10:52:31 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:885b:4183:b098:c1b9:7033:be8a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45a6abaa2sm5384356a12.23.2026.09.08.10.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:52:30 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: 
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Wed,  9 Sep 2026 01:50:23 +0800
Message-ID: <20260908175105.42558-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCD4E1C0008
X-Stat-Signature: cax18to8gqjgupgrdzhwhenhq3iyk6yf
X-Rspam-User: 
X-HE-Tag: 1788889952-552955
X-HE-Meta: U2FsdGVkX18uIZPmG5iBBDCnKcmJeTIKtlV8M6yNAXNyV/3Yq99Ust8PvaXbBq7454FulINC+kiLJhWWJskwhOipwRSrLek1Pvs2mUrOTmpGI5czEHxRrkBqlEk9J1uUduPSoUlymMp647NlFs4g0jr7VnEiUAxNCGujgbzTgL2KTeZ7jruoKjdnw7Zw8IYQA6QSJue61Wl2rhwvWXT7tMrhDxEqjQn0pUtlMlASw20/q8bMlJVsD0+Bh9kMk5MeRYlEIqZ6K+kCICvUMcthxV92QCVtY/9bXRGd81g3ZvIX/fP2Sfvw6Fn+/2Vmy3PF2DgUa2JaDQqdhdc44EuDHlrsCtxJfUjeSHKjbUmLoNhw590FU4qUSjY5xny/YalRX9ehnVkTeq2Bx2GsO0otVZDMsrkGm5Mcb8O3JkpZo9nlEg/lUrGlVhZD5LHYt65UeFKMz2IcmfSdJiKnt9bJApbtMx0H4G3mVGELvaEHbxCC6e4Tzmq3MOQRA3HFboAOI1iKmohbgGSG7weexdqYkx0dqiFrxIhNBnQpb0YCN7nSd4LZv8fIaCEIy5KLu/o6x0y9AfhPU+hNW8XINdTzMPwygJH0GuSnvGCjf5eElWMFpX+OB9P4V2tCtBfikbrai9ApVrjjYWkjNW2kCCFy1RcyV8jL8ejt8vOOhMgQeaMEMRp7If+KOPT26KLwAng9NKwMxahiva4BWCSML7Tyn9hyIvNhrsWNBtC/DxrC8IKMoe9w878Mj+vg9uLFT7T2KuRdwmUWSHsYGSDFz0VP/JDMpa+/IyjznivsJULHlwjDd5FLzqGpwVuB0OXE8sjkEMrYtgjDEtnLuioz00AvaiQD2m2UmJWVr1nWpeJWE9MCC/vANHEdJoGx2eaIBt/zT07aFzFOanFm7HYE6EWxVyl21bcA5CF56g9lG9bNr2V0gNiKv+Xhrppp3EIRWDCAPSjiufwS850poLdnlNb
 Tj6qE0ZX
 cZB6xEHJgPQKD8DNpBqa4vp1wRCSq4w6XD6NJCMS1jM7sU0uaGs27UgTbyfHeCJmgqBy026gPoeObsUCgEV1JC/v9saYGmB4UIBhf3c07QyANXiwUsUIpCF63dJoRVzWYgc1AzScafDdzXGNAjO+tnMV/cQrCEYw+z4nSZqI2nOaIuE78OtYCEo7vZRXE6sp2G1g9PMhjzVO/Gd3M4erhOq5P4OI7FaOQaZJZ4J/VgABj7KXaBGG3apJElK90IWX3Cgwouu952nBYY2wniFeP9jLNrm6APj/uKibVXBo7bIvYc+fi5w72xsygUNhCoq87pVmkaQ+uwqHC9joG+lIRTy90vHD5ECj5IFHLfm5OCToaYltsypIvxYowbkTJj2FjbT1gnjIHWgHY53WEJkrlM2UNVA5t5nCWkAvOUVTxZoX0vj5cCEmXCYlooRVFV2eJvvzyiM5+FyvdCVUoCPm9zYzCs4QX3Rw9gbeXtaJ/tQXZlZ5qwS1D4V3unA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qt_exceeds counts how many times the quota of a scheme has exceeded.

The value can confuse users when the effective size quota is zero,
because a zero effective size quota does not always mean the quotas are
unset.

If the quotas are unset, that is, both ms and bytes are zero and no
quota goal is set, qt_exceeds never increases.  But if the user uses
the temporal auto-tuning algorithm, the effective size quota becomes
zero once the goal is [over-]achieved.  In that case the quotas are
still set, so qt_exceeds keeps increasing once per quota reset
interval while the goal stays achieved.

Clarify this on the design document.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

By the way, I found a thing in the design document that confused me.

    temporal: More straightforward algorithm. Tries to achieve the goal
    as fast as possible, using maximum allowed quota, but only for a
    temporal short time. ---> When the quota is under-achieved, this
    algorithm keeps tuning quota to a maximum allowed one. Once the
    quota is [over]-achieved <---, this sets the quota zero. Useful for
    deterministic control required environments.

I'm not sure if "goal" was accidentally written as "quota" here.  Would
this be better?

    When the goal is under-achieved, this algorithm keeps tuning quota
    to a maximum allowed one. Once the goal is [over-]achieved, [...]

---
 Documentation/mm/damon/design.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index d036340dae8a..e083b74d618b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -863,6 +863,16 @@ scheme's execution.
   completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
+``qt_exceeds`` is increased for schemes with set quotas when the quota is found
+full at a quota reset interval boundary.  While the quotas are unset,
+``qt_exceeds`` never increased.  However, a zero effective size quota does not
+always mean the quotas are unset, if the ``temporal`` :ref:`auto-tuning
+algorithm <damon_design_damos_quotas_auto_tuning>` is used, the effective size
+quota is set to zero once the goal is [over-]achieved.  Since a set quota of
+zero effective size is always considered full, ``qt_exceeds`` keeps being
+increased once per quota reset interval in that case, until the goal is
+under-achieved again.
+
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
 the region is eligible to apply the scheme's :ref:`action
 <damon_design_damos_action>`.  The :ref:`access pattern
-- 
2.55.0


