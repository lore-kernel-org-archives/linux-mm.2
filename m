Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94A0C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5440C6B007B; Wed,  5 Aug 2026 10:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F51C6B0092; Wed,  5 Aug 2026 10:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E40E6B008A; Wed,  5 Aug 2026 10:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03BEC6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:11:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E9831204B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:11:55 +0000 (UTC)
X-FDA: 85067404590.08.377B00E
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id B86AA18000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:11:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdFSzv1o;
	spf=pass (imf16.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eFjaJr+M2H0kL5N6nM0BTOJS3VJmwR+FQgMk7+rxLY4=;
	b=UNukrsE5x7XUkmfv/AceMOqE0pFijNIfeZdQbh/DfocIJSPYnHSsgIzKEZhUn9vwTaOWgc
	bQlka3OQvgPNsBaKn2nipFcBekobbMJ2wCgURokuUwFllGs8Rc+Bh9OxGaXNcX2luv5QHI
	rpp5AkmG1s6e6F1KHWKWagSYiED5uB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939113;
	b=YmiMNUrpZCQ7aIH79T8Zdkp4bs5zTNjEyppR7SNfeiWrauP9gSQLmovub3CszSCwtrSqSn
	baj9r9lUqlneVN2ZVAqcZfNAgxe4oKZhoAgo3s0oklw2Cmb3H8M8cFVb5GddIdN4i6VDAn
	rbSPjupMNzqHokZUeIox6CMU02ea8kA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdFSzv1o;
	spf=pass (imf16.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848761b5897so784590b3a.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785939112; x=1786543912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eFjaJr+M2H0kL5N6nM0BTOJS3VJmwR+FQgMk7+rxLY4=;
        b=kdFSzv1oaWUTpPnby1OCOPz0s/NnPBB8/6S6PjivXpc9jOaYPlie/l5NHoV034vTy8
         d9tfHIZas4xvHR9+7mQ/JkaE4yC9M26xo/vcBq/r+IEoXwqBJbsZOhqio3l8eeh0u95D
         4lc8uPXzoH84xPudFaKwInMhJbGvy4Lnw+fuMkWLH9HWDWaJaR9jZtvy6PyRHIJWavdj
         FaUa/ZRHdgbZmh6YdMTd4Tg/QEqASenk1YRHku2uRpNWOCjI6j2/tfpkPPvgleII+WyE
         OsfS8T5l6kGokG2owrUb2veO8NpQRtwWNnG1muNm4U1Z6+V7WA1/5q2PYQyRPQigtHFP
         wY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939112; x=1786543912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eFjaJr+M2H0kL5N6nM0BTOJS3VJmwR+FQgMk7+rxLY4=;
        b=HIpaGeh/tmgv9gItMqa6qPhz6Dx0xsVm2G2f+qJ7uVQlhxzQ7Y3pjPYpwgfh2AqNzt
         Gfgzl0EbOOUliR9fPzpMhrHabBt5mgc5ZndWJy2MBLpzZPuQGqd+eHRY+uvctrZnGk3Q
         oRnrvty31JELdX9g6lfemzE0zZn4iqI6x8nedkWROT/xlZ5sJSFLicZWBWwZGGuer9uz
         Yi1PyZork6mTZD2VZFIsnCzcidz2A2Wv6TNzmk24dQoNHaPYMI/Dw821TO5/5qLDN30K
         3LhZDH8+1ISGDeUwxaJ+6M8zSZVkSjXI3LoDjG/x6usrSbwNBZ0wclKngIKqnRbhhO6q
         j9Aw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3nqNxzdfByH55qmim747H9sz6ZxsZIxaqHtRUdGvQUDhntHEP7ccwN/rtBvmFASL44obI6kDwOg==@kvack.org
X-Gm-Message-State: AOJu0Yz5QMsps81UwKgRFx0bbr7Xua+1xBLWF3shBd4fSGKwWbXrlw+I
	8nlJXCLq6bhlzrZE80tUHtnQFWoDe8sUnnGlmbny/Q+RW//9gvEXalPD
X-Gm-Gg: AR+sD12Up3vF8FEbDibm80yHAcy9tO2+pHqM9w2dXle8P5FM/09UPZy04UF1XLketGh
	eD3NXALos2lppC7HcPF7NCro6dsoftPx6ZMomMp8o7eNCJpG+t+h0NoRaS8YhG0DT+QOJYef9ek
	IByY2B7BO/BzgVWj2Vw/kij6p6iyjCzpfXEGZmmhEV1Go56Xmeh1PsRysckDHUgj9DJOcO1PgG6
	UrZFkqKnghR46BlNNncudctu8uVSPdF7QmCAxW3vMJLtRhD5WwYo1F1/sumGItLyAeGval8CQp6
	iAjM33NS9B2PA42oAPd7wzTuOSKGphY3tf76zCdDWiltu33c8olHz0i6mAYifd0V/FR4GsVazNv
	ZdzK0gfbPSRjXyzaR7Rbg14RDr+58n0GJ8hD2AR571YQ5i719gq0BKL+1jQhId0IBjbARckdVKs
	a46MkcAUt61bUgNI7l0TKlTUwczI4nzVEx0OwgYxibGGYUy115g9V/qpZ5PKqYYXWsIfUUpKbTB
	OcHl+QDLt1W+Bnl1jb8wc4+RGZigzAd28SbAwmgAp+pfnoBHHDUpRvrOl1H
X-Received: by 2002:a05:6a00:194f:b0:847:8971:87bb with SMTP id d2e1a72fcca58-84f2e00ea47mr6381590b3a.21.1785939112218;
        Wed, 05 Aug 2026 07:11:52 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e50846esm913940b3a.46.2026.08.05.07.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:11:51 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/swap: skip empty clusters in the swapoff scan
Date: Wed,  5 Aug 2026 23:11:44 +0900
Message-ID: <20260805141146.127776-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B86AA18000F
X-Stat-Signature: o3ezejrhzjkxnpnps1y4i54cb4ghugoo
X-HE-Tag: 1785939113-479729
X-HE-Meta: U2FsdGVkX1/8SYxcVFXRmxGNa8voq6ADCsPTLbMmbmf5cNWlue2LBGdGmS6bIcsokrlM+Y9U53R/PV7ejK7B9cKSzeAsC5D1ThlupceJIATi8N0dLF1/Q5jUzfrZWez6lzMC5IN9lrMsQBZX00/z/bCSOh0sIlLgkjxdcSNidWXpcgkmirLxBGNNCBznzplkS9dO+t7uWm+hRCqNlgXw98WV0/+wwRI/Qi/fa0KjlNKFTaRo6+5gAOA2yJIM326TfOAbPwAhUUe3NTVs5lhN9kNG+7Vj8cGWGVu6UvgWdCqjTk9cMKWw0UBvXh7Lhb+5iLLHowj0PM3n5XcffFSUGv/7Lmtne3N5mDwdRSMgPHsdH94A6rYbaxijd+AVA2S2sZuOXCUoD/Kwmget417YorqednarV4hJLY4z/nTLNT+CDNGc+02qk/k0inq/mZcy3X+gnD3BqtzPumIIVH90sT0T4fFrvvZfV8dWwt5ECM/LXIKGTa3WvDiVn4uAeiwHb/hqJShMvzrZVhcwHR/LwqU+OV1tYx3Pt0dnragWx56PpKcaCDVJefzGM2DBNlaAqb6ZO3Pf4/+OqdKSTw+3GZq5T1T8RhgJZf55pB35vxkELkaUysW/qZVIX2mwrczBKgkwqG2db/0zz+c0CgbEtb9PeVPIP/T28aGOOFUJNM3x4RrVPmjNq4qYxiAiarAan7tHLBGHWL3pEfuF9CjIxkwR+JQPFY0qoSBlbHsSEp23RBQxdaL/IuppWFMyX7PMOudIjV1yvWCJQb2+CsbKwz4wyIxjEpdInm1T5bR3m/Q3JEf5kEkZUe9IotmAWekkWhKvLSc/QDNOfAhdn11Syg72UHPLyn8jAmDitPnfaBlhjlmtKaJmJIS9daBA7bKCRaMLIYImY1xSHxrSVGxJ/yXJgsT3ZCrZs4+hOXcVKyTA85pWfPEyUfgJXVFxQdQ5UYfB70PN1nMRAyj5Uth
 7nTcTcJp
 Zjs/2ZiLf7V2j1jI4LZ30kc6tXlXFjhcGynbyAJZmUXowOdaOFf4mHJS+GWK6BCJq816WkcHg0onWdUvtyySjnUq1NVSpCKHWE+cc2c8tiRdnXljoyGFkXtdbH2Xl5biZvFOaOXqS3b7ep+6FSkDLBQEtvPkML9C0mdsAkz9mpqeAtdSdwLCPT4/CutqE8uoSaOTvlFpt6dUD6/YXms/MvEEFbgBojb7/A38BNRmnIGRm2xSK+iY7RfHrbW+jMhGoW353ZQYi5m0JMPjZb2tzDfScQ5pYQWhMv3ZpzlxUsuxlzH/wgpRlxod7991t1bNK66b2is19IOyWvrd/rgsakDZLRkhDviW+mxp8UHoGtmOAaOfyHTdr1ogkigkg9KlUYyAYCeY9G5vpt6Dn9XEvNvGEA6VrssGBSxph3UvNNULDbnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Youngjun Park <her0gyugyu@gmail.com>

find_next_to_unuse() walks a swap device one offset at a time.  Slot
state now lives in a per cluster swap table, so patch 2 dismisses an
empty cluster with one counter read instead of SWAPFILE_CLUSTER table
reads.

Patch 1 is an unrelated one line comment fix noticed on the way.

A debug test confirmed the skip path runs, and swapoff completed
under load with no DEBUG_VM or lockdep splats.

Changes in v2:
- 1/2: reword the comment to "array, one entry per cluster", dropping
  the redundant "on every device" (Barry)
- 1/2: pick up Kairui's Acked-by
- 2/2: drop the min(), the swap table is always SWAPFILE_CLUSTER entries
  and swapon() masks the tail past si->max as bad (Kairui)
- 2/2: mark the unlocked ci->count read with READ_ONCE() for KCSAN
  instead of cluster_is_empty(), whose other callers hold ci->lock
  (Kairui)
- 2/2: expand the commit message to cover both of the above
- Rebased on mm-new
- Link to v1: https://lore.kernel.org/r/20260728155907.391820-1-youngjun.park@lge.com

Youngjun Park (2):
  mm/swap: fix stale comment on swap_info_struct::cluster_info
  mm/swap: scan by cluster in find_next_to_unuse()

 include/linux/swap.h |  2 +-
 mm/swapfile.c        | 41 ++++++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 14 deletions(-)


base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
--
2.48.1


