Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1A8C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A106B008A; Wed,  9 Sep 2026 12:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C016B6B0095; Wed,  9 Sep 2026 12:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E1E6B0099; Wed,  9 Sep 2026 12:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2F76B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:16:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6774120173
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:16:02 +0000 (UTC)
X-FDA: 85194725364.20.1257322
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9436140004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:15:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4tUtBhbbVP3NMGTQA1Nq2ISeRBUo8woLUUDd/T0VTuQ=;
	b=NDRyByTC5xlC8drk/AGDA2oJMkcrWOH9EZdQNO3nHY9/r3Do4b+qdzI8oyOfrAnIfmslin
	c3H0BHt5lxDKxz7mcOvv+SBdxcHeYnhxA1Xflm8lrZ+n3XMLA+JX4ExZDLcH7sYGgkBRTQ
	Vgc6DEKOrDTVHNEQXMr9JsmekVByEUk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970561;
	b=Os9Zz+eoILVN3b6+LswkTSKiUJqFfRhNy6z7mKJqf7YQGxrZxEOxkFckBT7M493VvcUO3T
	NzC1aHxceU1Y5UwtWK1DZ9zEFPoKJECMwoly8N9+8an9ueXL67OvBVj+X/eAnFscaTUkY+
	PvDfFennyqbO2hj4LMR4ZAhWzETDfdw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 10 Sep 2026 01:15:55 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
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
Subject: [PATCH v4 0/2] mm/swap: skip empty clusters in the swapoff scan
Date: Thu, 10 Sep 2026 01:15:50 +0900
Message-Id: <20260909161552.2335971-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9kscswa1qbxsdyosrsea3cqk6o5pai95
X-Rspamd-Queue-Id: E9436140004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788970559-363906
X-HE-Meta: U2FsdGVkX190MmAwzq3TGDuaOiuYIzjN94fkKG5d2DgCcy3qmebG0d7/Dxro5x7JORh32+1GdNptt4DGLaZyvHt+tcx8fHDZZQzN4UnN7oGZH9wKHVsrzI1pZCOrUoZ5AGMPQOOQxAVuct1bAWry0P6EJL5qMmvWnwYJuVanVYjTCPU4dl+xzNVKTIT3oc1CLV7d2Ava/I2z7Qyz9By4oJ6VrnGT5AHoG9gi5UHT3NFJJG0SjtLTKgo7ua3RNHITqnwU47pB7txWfTCuu3OpZocV2IBU1q3/7lAypdD0ym79ZoEq6nWafVikvEWSmMz27zyDaAdGUzkiZLAPVnaCB4hUlA5NwJchgp0nKXpjhvGQUjOdVwEStbRJSHN5TigUrcSj8s0byK7HNkceevfS+xpw7oIyqUA44A6+Rd0uYXf8CKYqg33fBiZdPiQrX0H5i7LzNi6aI3PA18F2WyT8C0Uh4M3hKILwFCUSldr6Tn9jYaro1PbnKfR1kTyBlTz2bGVH0f/pzBHswA+/sQ7pm4GMwkTzXys1vlrGPwgDIopJG8QPnON9VahT9eVEfp98azynJV4FzuvusPtZChVjb7RUoce9M68HN6Vl1d9NKHETBeRlwfrwIPrBj0jIpg7oK4/rLwu92TGx7SR/eH/Q+EB124PPUmvQZSSfYV1DVfahyEkXuEM0uxZtH4Df+w8fnlEFbifqdfi0n118gDe7wwqBqOIjFygIEErgqEPYWwf26ImM4J4HSTwPK4/5SsPobPDNHNRGeRZc8Phrjp33gfNEupeypnBU5KS/r/Z5sByQFU6eZVphpG18u8ftEiLTsvt3zqAnyRS5cvmnHRW2jaeDP5wLK4osRY1OmPkDdWl4pIsianJfA3td2eatRgu1kGIKEIYX63Xkx4lJh4YuYEqeG6ZwC8Q1zhFI2ZjLwHysOkmf4Oe2tVphWmg+mHRNvWcBtjvroHMTk4zZebX
 LYZlMvmV
 3gtRULkrvkKjIWZ7h/+uRuxIw3PqVGdOLTtbYIvwXoisg5mHZIB+fvq0skVA+zxl8/blFBAxSmt6jbN47eRLaVb5poprHftCoguPKgdEg0HO9ZE1c+IOEXdvewmSmRMDxwzMh0M/RF+S4hG88/L58DE/XQxv0BB7CnD3/KoKv1x2RemJRmnvkgz5xSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_to_unuse() walks a swap device one offset at a time.  Slot
state now lives in a per cluster swap table, so patch 2 dismisses an
empty cluster with one counter read instead of SWAPFILE_CLUSTER table
reads.

Patch 1 is an unrelated one line comment fix noticed on the way.

A debug test confirmed the skip path runs, and swapoff completed
under load with no DEBUG_VM or lockdep splats.

Changes in v4:
- 2/2: put the measured swapoff times in the changelog (Andrew)
- 2/2: pick up Kairui's Acked-by and Baoquan's Reviewed-by
- Rebased on mm-new
- Link to v3: https://lore.kernel.org/r/20260806193228.458685-1-youngjun.park@lge.com

Changes in v3:
- 2/2: clamp the scan end with min_t() so it stops at si->max, rather
  than running into the masked tail of the last cluster, which drops the
  need to explain why walking that tail was safe (Barry)
- 2/2: compute ci_off only where it is used
- 1/2, 2/2: pick up Barry's Reviewed-by
- Rebased on mm-new
- Link to v2: https://lore.kernel.org/r/20260805141146.127776-1-youngjun.park@lge.com

Youngjun Park (2):
  mm/swap: fix stale comment on swap_info_struct::cluster_info
  mm/swap: scan by cluster in find_next_to_unuse()

 include/linux/swap.h |  2 +-
 mm/swapfile.c        | 43 ++++++++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 14 deletions(-)


base-commit: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
-- 
2.48.1


