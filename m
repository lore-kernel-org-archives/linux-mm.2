Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86077E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 18:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8C06B0005; Sun,  5 Apr 2026 14:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9646B0088; Sun,  5 Apr 2026 14:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398616B0089; Sun,  5 Apr 2026 14:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29F156B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 14:42:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF6EB1B749A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:42:56 +0000 (UTC)
X-FDA: 84625373952.26.0C1CCDC
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0F3140003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:42:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l7LztxnT;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775414574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=la/BeibUlIJDCZTiPwSwWhDiM4TsgARxgnUgElwvrao=;
	b=XitOKyAdM5e9Bz/wp4nhSyCYV4U0XdInitDU7Rpsaj3+ugAdA2No7EFLQzoI1VAjhwvUo3
	xboES39LRJ40K849aFziV1gMB8hiy1hnup6XU2cCsIxr3f5aQJEeZVHQhNohFkPxfWXrsI
	4h4zLXrgLbBeMIx62+TiJrcO+Jplckg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l7LztxnT;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775414574; a=rsa-sha256;
	cv=none;
	b=G3FKQ0JEPdiGen9TUhuw9rDnADnwqYOpora9Klu4O5ThDAxNVhXxNxKtkumvkKJ1KjXchx
	9X2gFXhP5Of8nesWhFF/PPIdxbpcknI/KGgRxxVq75sORlLMClcr5QjEPCbIABWs7yDYkj
	7276mBkrxTS5mn/ocurSuWy0OUJyde0=
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-79c20063a32so32910117b3.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775414574; x=1776019374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=la/BeibUlIJDCZTiPwSwWhDiM4TsgARxgnUgElwvrao=;
        b=l7LztxnT3Mvh1M9sKt9ofeHj+udFTUgOOYXqyt5lx10EiQPgEly9BStZiTOFSnBmMy
         MrAEtgsg6rt1oe6iA8RQsqz3D1oD8kcSwNU7y0Iw1qqtp2L7SNw2vwgJ0bBSniRPRFSm
         cU16xA+2gBeYa8w+L/oISkiOvSvn51A8/GFrXK0vl/S70NYtDvscTS8uU74I1by4Le5z
         1X/TEzn1HIRrFt/rtHu0OQyCbXmvEAAVSN9d9lCkT+rg7/u2uTWYzTzgCrShs/H3zOc4
         crrLRsYGWBS3Svk5o0hz0bvOWy7dfXIy/zaDkpHjDgESVSbVRN9AihLFEwNboNnXyFJt
         ud2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775414574; x=1776019374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=la/BeibUlIJDCZTiPwSwWhDiM4TsgARxgnUgElwvrao=;
        b=WlxFdBbHWKyCaCfhtNl05Q3RCzLSIAzmG/NRbUDYZmiazuK6uCMNkJcubTTt6XfWSa
         06wftKCyJVdKGkbLRq2XDD7lBLXCB3p0ww4P/TrhgIlQYqPw+qapFxOTA0ktXVWMVvDF
         wIqzMXqi/EdvpXpOO3TEK0dyFI0Ac4TmEAiVXiU9vfuOCezfqGM/fEnmH/vBuNkL0hTE
         eeL+CIfVHamGY2+AJkwxn1KhrBUHsYSrawSbX5G18fJwSjcxX/BULeN8SrSeWZHcdig1
         3EqmS78ZQzGA/tTuT75UaPd+iBGqVSvFtEeRiigB2dQk6aViKhzxU0Fq4P3y2tErU0gJ
         GY+A==
X-Forwarded-Encrypted: i=1; AJvYcCXITfJfET5fg1u3g5NyLBouVfT9Dd5DtEmkqV81Q18QiHB9SSKtRJTf00/3r/dv/oLth7g073DKFQ==@kvack.org
X-Gm-Message-State: AOJu0YxPCstvJ9/wrwVYUGxe9nETIV4LlfB2s1iaSRXKCd5s4j+MaJEs
	8Mb9mp2ISpP5DMoaeoLYSrr7LB1zZ7KHuOHxCp4RSco6rPRnf5OxDlQ=
X-Gm-Gg: AeBDietib9P4ry3D+0C12BQ9SLROOAmw8pRNrj7+wUfPwYWX8BKc+MQqSYJ5r7sqX4Z
	jbTHuA5UBAVJre38qPjQ79UaugPtCiYCgArBg3DRsAGScd2+Wk3NTx0w0YwZhQBi0o3e+gwmSJd
	R/LePMcbGP8OXuptZhDcFex4Msvc9sO92dEiHb68Ubp4w4gq0mYM5d0kj82Y12PgTXwdkcYnZeK
	OgOpQkydkbJKZgIhvZg3Hw1MI62G2cos5CO2MKlP0UaC0NxSRMl79EFMfHr6dv7Uvs+k1Its4ok
	57ZjEXZoh5r5o1XtcG5rL08kr5su6bsE+PuaokYs8Q9PrDhhZ8qBtg+SOn1dSPOlH4++2l2tvmj
	h1WVBBPXs6xC74nzHjEy+x5o53mpcX+OUe0eFh6tKiWiZ4sYMxy0bo3JnDGxrJnT7PrGx/jV3xo
	3bX/fu0Kl2ENOxtx2m+2P9P48JNo3wzxOKt5vy5UHHoW7ledzCNdtQaxFM9igkKtI3Lzp3fxFea
	w==
X-Received: by 2002:a05:690c:1e:b0:798:c633:d13b with SMTP id 00721157ae682-7a4e17512c2mr81212917b3.24.1775414573586;
        Sun, 05 Apr 2026 11:42:53 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a36e42fd37sm44685627b3.1.2026.04.05.11.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 11:42:52 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [PATCH v6 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sun,  5 Apr 2026 11:42:46 -0700
Message-ID: <20260405184247.2690-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qqzanekwef35ydp3b5r8z4ns5beba38e
X-Rspamd-Queue-Id: B0F3140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775414574-245158
X-HE-Meta: U2FsdGVkX19MI+ZjizQYov3t6tmgekhLVC3wxaFAVrCNZgRFJCx/LD+jymQbdruYEWBanIG3FKgWzueUzNQIjnNClEmyk4mCj/kMcgFwptQbCVGIbuzTVNOO9k6BadOCTgmaTBeddr7js0dVdWS+/6mRZ+F4r85VchFwItuSNXjA+4r82q4Iz6YiCSNi2lzNgaUZR1AJ2gJKC4JTZcD2gazykS8vH91pjOSFPWjm50QUdpQWombzOMB6zauG5MKKa0O3XkxaNBxaUU3JEOLPVW4+8Nl8bt2so5lND3WnF2CDa+Su1s0lp77qnoNOWHJW5RTxa/pNMngRzPQZiLL5eezTZ74VVXNF9LzoTGCmYeEgdX0ZjyFP2GJZ1wLEaxkolZ6gionXBtJtqkQBOa7i7wUBLFl+CjlWv+oiw+I2p+Du1GdJMslAzsjP0Ace1aUegvAWAY/Sfn//lFZiJXL9WPCb+Q54EMzeEoDAKhhyzH3Dq4hO3UPNscQRJkD13GPOKwtzzsAJvkrPlHdjLGTHT/MGiQQ9nsU7dLBtVUnB5r6hYl/zR469Eqsim7xMHVkw1HI8wbKziClU38oSqxrh/mdvyq1tIJ0jK+JVzGVvgkrUH/J9osp82WVQI0KLQL01Je7ShtEGsdPid9eErWv0A2B5vVnFtcWTrVaS2aEnsx2AdicSn2LuyEYGKGUh4OX29kheU30pWrIm9cNr1U2Mdsq6pfx3l7r8lOlgGozGaVdrE+3RXXpHu9KHFA9BVGVGcMpfHXKwRjaTZE02h9+M+YRiuzL2Hp5/3FiU8e++1jIOxXn0zQ1yRje9rSCPpD7QzRn6BltOgEv7+K+Vvw6hijyMU4+9ph2oX08Cb008IYmjVKttWfUgKcBuKBGxYCx3KdnSXzMaOYwOQHcf/pGq1UAXHfps2vbVPd2rxPimbVeK+8yfmgdC8+eTmk1xuePwaw7Gq/PoDVbXQbGX9Vh
 XX3TBVAK
 yoS6b++DdW39Q8dU50cC4NxkgEz8LNU3ef4tri3izBOGLGUeuVoFAVvrzg2eQibrbg+qkwYqWhgV/PylxXkqoR37bshXFBTMDhSZbO0kSFlJsgPI7RAdBjFRFhe/s7UF4MXN3Xd1EL8H4SSPKEqUL9p2V+hndy7MXIHSB7cyPJFACxktDxtqVvItLHmZQMQ5DszEDQZ2sn4uEYT8xiyuUC1+YmyfZ/3IA2RHcjBLCjk/g8B5IE+LHGpkYCVu2R4Cb5V6dxnXrSKs+AwYEFoIEDPRd4/ssTfshXRT9UmO1FHws73Bia9XS2JUdWBCaDbBnZ2h5mgyHt3FLf/GTlxKp0SoqQCIazujKOuYiCmJLd2Zd9w2wWASBbTzB3F2qqRMuSQ6PWtFqmz14ORN92lu69s8S4QZPZqaSWi7bpbTIvxRie5oDdKvHrJUKh527wvNEmJyPwr3YSusDbdZiYGKz/eHKQyyUDK11bMttIpHzgLB38pT0Kd0wqoTcg9k3emukh5sTRLFpWKcUzBBiLXwwySvJprqm/GsFBlpDXW1aq/ByyauEat0ojcPswC9iu3aEDCzPj20U4/AAKr2L8Uiq2MYbKPd4O3JNZhdyhuOy1kRv2I5XWFNZ6rjtNi4f96GOGrh9IUEkk8MnhjDkOs8y8dR+r4S7z6JwOnLDNbBdsf/ZG5LxoN7Tqr2w5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v5:
=================
https://lore.kernel.org/linux-mm/20260404012215.1539-1-ravis.opensrc@gmail.com/

- Rebased onto mm-new instead of damon/next for sashiko review
- Removed Reported-by/Closes tags per maintainer feedback (not needed
  for bugs found before merge)

Changes since v4:
=================
https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/

- Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP
  per review feedback
- Added clarifying comment for ops-common.h include (for damon_get_folio())
- Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
  #ifdef CONFIG_DAMON_PADDR guards around functions using damon_get_folio()
- Dropped RFC tag per maintainer feedback

This patch is based on top of mm-new.

Background and Motivation
=========================

In heterogeneous memory systems, controlling memory distribution across
NUMA nodes is essential for performance optimization. This patch enables
system-wide page distribution with target-state goals such as "maintain
30% of scheme-eligible memory on CXL" using PA-mode DAMON schemes.

What These Metrics Measure
==========================

node_eligible_mem_bp:
    scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000

node_ineligible_mem_bp:
    (total - scheme_eligible_bytes_on_node) / total * 10000

These metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
ratio:

    PUSH scheme: migrate_hot from node 0 -> node 1
      goal: node_ineligible_mem_bp, nid=0, target=3000
      "Move hot pages from DRAM to CXL if more than 70% of hot data is
       in DRAM"

    PULL scheme: migrate_hot from node 1 -> node 0
      goal: node_eligible_mem_bp, nid=0, target=7000
      "Move hot pages from CXL to DRAM if less than 70% of hot data is
       in DRAM"

The complementary goals create a feedback loop that converges to the
target distribution.

Testing Results
===============

Functionally tested on a two-node heterogeneous memory system with DRAM
(node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
migrate_hot actions was used to reach a target hot memory ratio between
the two tiers. Testing used the TEMPORAL goal tuner available in
damon/next and mm-unstable.

With the TEMPORAL tuner, the system converges quickly to the target
distribution. The tuner drives esz to maximum when under goal and to
zero once the goal is met, forming a simple on/off feedback loop that
stabilizes at the desired ratio.

With the CONSIST tuner, the scheme still converges but more slowly, as
it migrates and then throttles itself based on quota feedback. The time
to reach the goal varies depending on workload intensity.

Note: These metrics work with both TEMPORAL and CONSIST goal tuners.

Ravi Jonnalagadda (1):
  mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
    metrics

 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 188 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 192 insertions(+), 14 deletions(-)


base-commit: b47b4fa4c232ee36aae58630e9d6520e35d33f3a
-- 
2.43.0


