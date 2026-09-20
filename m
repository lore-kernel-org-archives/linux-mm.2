Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A22C982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357286B008C; Sun, 20 Sep 2026 08:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1786B0092; Sun, 20 Sep 2026 08:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABDB6B0093; Sun, 20 Sep 2026 08:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7D886B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39427A0414
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:20 +0000 (UTC)
X-FDA: 85234058280.17.8E38CFF
Received: from mail-pj2-f21.google.com (mail-pj2-f21.google.com [74.125.227.149])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86D3FC0005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fe/z/gMB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.149 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fe/z/gMB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.149 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907058;
	b=Mjr/h2ryY6XmUG9zkYUaaTQwrvJENwyU4xcGpL73bDTJkAz/fPoilrGFUmEuyVWjaPhDKz
	PfHLZI6Gptgl7ytJWluxS6LB/aePZU/Iq8Mh1TkktdJSCEjqdk7mTvwrGE2zNbbeExIhN7
	Er96+CNxwad0zX1GTS4/8fteMkAcoF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xjgh5OlWwYGa3/r9MOFyxfKxsWIa/znQ2EXAbXuSxlg=;
	b=6Y12sf0I9j1D4/QEnZYYO6B/BIeH0FZSV7MNW+u27j6h98s/3V4xQBnVAWoFyQp5xl5Kcp
	QxK+J9kNq+5cfODIR5ZzvMDPeh0vwnu3x55RApnHrcyBNS1zo3lTYdjdke9B9/dS5m6GS6
	M2/zNDGEpru7z/BEZXHdOpXlsPkRCNk=
Received: by mail-pj2-f21.google.com with SMTP id d9443c01a7336-2d747f0b25dso23595615ad.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907057; x=1790511857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xjgh5OlWwYGa3/r9MOFyxfKxsWIa/znQ2EXAbXuSxlg=;
        b=fe/z/gMBtVfJuke4qzY9MjZEFbv2k2xJfhvfHJ6mKo1v5NnrdY6pORQl2SXht6rC4K
         gczBek9xZbToB6v3HsehLkk15cfZBCms2JTasG9hXIG9QV02QqXIUp53RHdKdf8Pg6x3
         mkrLHlODMB+NyM4V2nDwdTiLCNcXciSX+Hk2GmNhsH2EL46chuno3lYuWJMFm/B7P7Xr
         Qrna9aXzw2AJ+Ni/zDm2HOD+gGY4y03EsbvexA4/h64gNdKO/FyPZmX0lX5aQJicMEi1
         oTAahH0DI7R2D8D+32sB68tDETGXX7CVa74J+U6SWz2wz0RjifrzQuLTsTXenWDz1Wdg
         Bpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907057; x=1790511857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xjgh5OlWwYGa3/r9MOFyxfKxsWIa/znQ2EXAbXuSxlg=;
        b=Ny/XbgjwyTSmrBDiOAXns/QoaFaZVxyGQc2dMtZjnLe+8ntWNG4XsSw+Bz18TvXMJq
         fG295l9xHvZgSEhixzfV2uRPl9KI8D6Wy4nKyQz+g20on+dqUnBklFMMvlhCuSGloje+
         +656Ev5hZ9U00xG1PqngwxyTKDjYXr1YZJAR0XRjQhI8PIbcmtFePbYbW2/XSpqn0FmI
         jqAsTkma1Z/f96ti8jfjAA41KoNdGxqGxiNZ2FFgXRe4qi//VIHAwSXEBYtTr4D7ibAz
         rkMGM8mPWXXv61Tzs4oJIiIpLbwP1ATNN4AcgxtJuC+ZxZoCnpJ/nnbSeTyr2mxY406T
         Hobg==
X-Forwarded-Encrypted: i=1; AKwUvBzKdyF7QBemQyVpCEL/uqKQD7i57aAKe7XJ6wjyM3gYasXJ0y121kGu3tueU7dy5QikpUQfVVsbhw==@kvack.org
X-Gm-Message-State: AFuF++ny9jTHVHYUtgkvYqV8hZcpBp4JpcaWNWevYkJzrrhRpaRGpeLq
	6ZUKowOgbFlSqlOw++g5h6DmMjMBr2ioTMEEUBv3NDUFNPGaPfG95uo=
X-Gm-Gg: AYBFou1/k4HK6jrJwgwiEWBql3OHiGBryFXA2b982l+ahopnTQzWTtDwFrMTXZ9PvGO
	el1oElXZmTuV/0uAzMZKh2PUBMmF+qVQmHZpiz74evZBp2K02M28UV8/oMH9AEp603+g2Wei3KS
	Wl1tFyBogRi9pzSiJ0IpXxNz6EbK8ZWjkVinkzwoToZGPOVb/YVEpoihVXEfQAX96Js0zBulK8+
	HZx95CO1eyY2Ogm+uHJnNJYSTXehyP6kfxeqhQjzSSyrEGZDl7lHCCCFwLIllL5JKkygx83dl9Q
	Hq2esE+Cz3WlzV3G/yUNu4HjWc6cirNjn0maQIC7oo+3X6K8CNEP5BAViqIvbS6LEmItIxWsb5f
	d4QbByV0rovBfrZyxmzYDefXqHA3l6EwtYCyTdJEo1R6sn6PiW43uqHH8k4b9eQPp3+pBfGGhMD
	/Ce1l5/WP527tzzxzqBs6qXdjaOxkcLsHQo26ZoKHJoI/MO9PZVxG3Sbyh7tdb3eavFgd8Db+9P
	IN3D7qPyfpDe3+FfQuE9OOy7oM=
X-Received: by 2002:a17:90b:5784:b0:39d:f5b1:e365 with SMTP id 98e67ed59e1d1-39e54f35b9cmr12927548a91.25.1789907057067;
        Sun, 20 Sep 2026 05:24:17 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm8753943a91.11.2026.09.20.05.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:16 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v3 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Sun, 20 Sep 2026 21:24:09 +0900
Message-ID: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86D3FC0005
X-Stat-Signature: ha8rmw3arqt66ce1uwispd63sok94y8u
X-Rspamd-Server: rspam01
X-HE-Tag: 1789907058-5335
X-HE-Meta: U2FsdGVkX18NtGKbW+jpBM5xsiUXnLgLtxsFn9CCr0KE/Z/43k15CbM2TQJae1v9AcGIntKXKDj9ODGH8Ey/2lVIGwKlttaF0spzVEoGJ2D/sNBC25Cm1JP8aAOon2PhWoIWMiw1P0Bi9UwJy4C88zYK3mpsODBl9TpEJZK6/tThzOzWL9rpD24QWoy86Mw1z0f2sqfgIJY/7AOZq+NB02/WPETfU/UYLtU5GboX4aC6l73tlNl9811wI8mJpHzWDr+a8jSkO4vUbGCd254vHGfM9MUDNxDsSQ9fvncBogo7ed3dHxE4T+Qn7PuNqZuaxAYpNMJ3TPW1CQW7agxd43DnJMEeruIPzQrif/ac5X5B8XyLwxO4kCrEp+L1pzVA5kVcLEAUqDFPxlbNmJje97Zhygn0SbcSCS8kbXMe4Ia1pVVqlbTkMsrFs9zeU9oMUr/9HiSpeGhNuMhw+aru+LP4KreXOr+Xa7P+VALxzlcd9e/SxY/QyynmyEPbsYin+I3BF7mJvIChIsq22NZAXKTX7DXfk7plCcUVCfDfdhvMeixmE9pgMIjtc+lmWzs4Az0JCGGIImZOQlGOYYDVTXiGpUKvJHTTVOqCX3R+uo62tgtTQyGKRAgcWNeFgWFDDqRU8fD8d3gzI2pZCsKAXFb9f/8gBuqzG0c5XAS0fGhdpfEUATEMgK8rIdLBKI/7/qiJRSYTTbuDDxZwguQaXSzmv2A3kkOpYPS74/7L7bsRj01Dk6OKbh5PEQFOXguBnMpz3Z/9+4F1qXMnxRrmUxkgz7l5yCqz3mFNO8or37LcH3uUKgbN3XpvTOF8rAr4C3NcbckG+FgU9qed0cxwZvsJl+BLpYTDD88KL+i6yz2uj3yPPxkh6LNWAtUKnNVwB+SpakW7U1jtKeYAL1LsZ5XjnOoTD5SJnpdSuzGeBflXWnMFBLDhqUKjqxeEGUPluNGx7mP/gr/MaZ8wlC3
 H0RC7xIq
 bE6crDnVqGVC2sKc255TJyoDitpdFE2nwaNh0MGLpXpDqPF1cFkrZShbWSdKgsNQTfV0o+tWKVCvzh2BudYJ/kEho5mVpYpyeet7FSKFN9Zmv9D9LYfsBR5r4sGKIpl6WiRVbu0Gjw6KEftQc/Sh3RUSks6dSi6jc+wiqieo0avjFhRYUwGzLVyPt1S5qB96e5+X1ep6/iz+wSWEQv9XlddqgQAaPYzyuwIK451D0d1QgA9OlAA80g+MD+PGqNZCxCtHYRPGSmgOw0Z4FrW/HI0AeyuZ5WJIaAX2TAUl5ujusM9hrazLX7j7UeoKDIFPyPr6YP7JSaVDrW01FXYAbhak6Al56GjrS4pMvfUQeBJc+RFLa4DOh+fURUffOZZv5IyMZCa/+mSeVdCfEd0/lq/AUdGuw8MFXMD9S+74/IglDUDhVnUtn/wCoNlEIzrB+Kssoad/BxqDNDCDnijP1M9a7Jy5f4cTjrX3PfImicPNDfYsvIlpwoqw1dpa/bYIxYxvUvbr2PYTWyWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and
the multiply that gets it there is unchecked.  On 32-bit it wraps above
429496 bytes, and to exactly zero for every multiple of 256 MiB.  A zero
effective quota makes damos_quota_is_full() true on the first test of
every charge window, so the scheme applies nothing for as long as the
goal is unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
kunit suite, where it would fail without patch 1 on any word size.

v2: https://lore.kernel.org/damon/20260920023111.2466265-1-donggeunyoo.kernel@gmail.com/

Changes in v3, all from SJ Park's review; the code is unchanged:
- patch 1: wrap the changelog at 72 columns, say what the impact is and
  is not, fold the 64-bit boundary into the trigger conditions rather
  than arguing it separately, and drop the passage on why widening
  esz_bp is not the fix
- patch 2: wrap the changelog at 72 columns; pick up the Reviewed-by
- drop the documentation patch, which SJ asked to drop

Rebased onto mm-new 87acb5b914c2; v2's base is no longer in that branch.

DAMON kunit on x86_64, on the new base: 36 tests, all passing with both
patches; 35 passing and damos_test_esz_goal_temporal failing with patch
2 alone.

Donggeun Yoo (2):
  mm/damon/core: prevent size quota overflow in the temporal goal tuner
  mm/damon/tests/core-kunit: test the temporal tuner's size quota
    conversion

 mm/damon/core.c             |  2 +-
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

-- 
2.53.0


