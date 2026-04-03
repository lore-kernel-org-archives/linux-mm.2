Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A65BD7309C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964A36B0005; Fri,  3 Apr 2026 01:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915DF6B0089; Fri,  3 Apr 2026 01:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8045E6B008A; Fri,  3 Apr 2026 01:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7816B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:29:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D47A9C1E3E
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:17 +0000 (UTC)
X-FDA: 84616116354.07.819BF75
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 191D9180005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HWm8vjTQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775194156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PwVEBTN2pqE65yckg0LJLlK41X4ju08angcIWHyFOv0=;
	b=rRSPaiLInZIlmAXOVAVcEDXtAYosS1yGviaR2W2z5V4sH85MSrPcF5s5fkNBvGEJLcT07q
	JwvBQaLS0JW9tAtKGNl0QOCd9Lkb1lskybv8V1a6quskKp9qWmlCXE5CTn40rE3SE5l6yq
	kkG9HaaPheIIHNNCyVep36veO42WCWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775194156; a=rsa-sha256;
	cv=none;
	b=UPHSNxVtEEdAXqSYiJz26PxySf5gYZiDNUz7IS/NSg+ucJtkI6oHEIaZyQNYSrJsiIC6i6
	wHnTTmjDMawRCWh13jjuLKZB3l36HlA98iiViutsigkgty/NT/HUkP36shNr9eEIjeJe3o
	vdl8cvISvma6iU2aP59mXBY9YbEirXA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HWm8vjTQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82a7ebc729dso668945b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 22:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775194155; x=1775798955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PwVEBTN2pqE65yckg0LJLlK41X4ju08angcIWHyFOv0=;
        b=HWm8vjTQXqw82bjNlIhiaUJUTxwRUbRCDPPtaLGH4lVHGYkf5uppuV2R59ezBW0CJZ
         ubPvwV/mKT1somxWjrWFrNxBC2WMgMODfeikc35ghEiFr9oM8KWHSiVfzcYZxMvmmHOY
         udgZBFcRvachBUv0KdMvvkhpP9A8Gua45crP4wHPSM5a4r2vKQOI8vkjncN1V89mP/HR
         CXN10XCLpzp8K1Df6a2dYsPCqK59LDDOpZPxKiIQIgxGbuBjnwPU4j5bBrGcRrCQ43Yc
         ZaTfI3/fVocpi+FAlbsMld5t8d2lVyiCLu7Br+1c7jhFPcsjkdSgF+eeL8VdrgogZnLI
         p7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775194155; x=1775798955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwVEBTN2pqE65yckg0LJLlK41X4ju08angcIWHyFOv0=;
        b=A5PM1vQZeeFT7ZnStdY62c7tYhWNq7tufBDnyUKsSXBnSGcDychKgKRJd3lzBRI1dd
         KjlqNWqqx5I3d64l7+OX/phuksoVd3x/BVFrMN0Q5fHBbtA8gBE0co4KMUnBx4eTv9Yq
         lXkWiVM88F3FpFxj1Lzfdg9r5ZCs732HcXXpSTWeWeGNoXdWInSyw3fUT9BXV4zd/UU1
         q1xXKUnM1yrUGWkDyaB9CIxyB0rIEpDeNfVELXeIQzKGaNywFAQHHsq0uqC8T/ejpMon
         SY3kIWom1FcI479guCbgMTHhWz178AjIVh+xxOFB62OCfaZ5OfvVhxH2mlBuRNnSv+0R
         tqoA==
X-Forwarded-Encrypted: i=1; AJvYcCU2Xv+XC2p4lCkjgA1kZLfNk0lkdOaF/m6ZuoPVvGiHY05qFhCPNAkr0mdDPBAKy4iYiqsfNecrWw==@kvack.org
X-Gm-Message-State: AOJu0YxsKIjiIlkZV9jHDtPZMWi5lFcJbq1OJpLMDhJPBNYefgHJvBQP
	uiOQtiB/dSa4iTCi7XsBzAantUerOA/saN6ijnYRVmZtbPLptUz/uNtx
X-Gm-Gg: AeBDievFr9QiBK+lUzNTQeRE/ewrlaIeBubi8HW51SXPLVjzJSuhZ7queEL50Qsb1YZ
	g7XhRTLyeisQu1gf6d0EuwodGGpq7x1oCR6sxJNY6MV/9ZO4DSxHUclwMtgrqBFw9CXavEwDbAx
	jGdOHAW/w2plX+wOTJnCptcFq+V9HFSefbIGe6dWcNPffEqmy9yo5ws0L07iJBmvayAjvLQfKRX
	ajLr8rW20OlEHCluh3jxG06aKzPSB6b7M5+sPDTK9XQDr8RTsg0k/t8Dqtd4b3rd+2K3dvdnx99
	owVNkstaWWGmKDLPNJqLOw69qioeZNJTNeUBg5sP6c3LbIqa5TtDrEEClSWZXiTUhS8LRGPnldF
	eUR/6itTy3sfUaIV90P8tzADG5D9ueWb14CyoGTvpaueDpe5xItNIUHPMXSm8HdoGOjH2NnZcl6
	Yc0bxUI36nd2aK0O0rYA/Mr4jWMHY=
X-Received: by 2002:a05:6a00:4c16:b0:82a:78c0:6b75 with SMTP id d2e1a72fcca58-82d0dbabb59mr1887722b3a.44.1775194154839;
        Thu, 02 Apr 2026 22:29:14 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82d11cd2ce2sm782120b3a.6.2026.04.02.22.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 22:29:14 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v3 0/2] mm/damon: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 13:23:48 +0800
Message-ID: <20260403052837.58063-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 191D9180005
X-Stat-Signature: qqhhd9tfzwd7rqmp6zuajnzmankt3e8q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775194155-266086
X-HE-Meta: U2FsdGVkX19lVrI8E/TEH4Kw6pyjPyxWJWzwcsg3VAJQjccH4rwgdE7mj47nEQHAHmn7syFKNcX/Mk4u+NOm53R4/9iAfqqdkMESeStPUbEizptVmZrJS0Jvp1ISBobmOIMBPqgW9r6iP/pj+V6BE27d1lBc4K6xEHwhCF9jzsU+V5puGWJnhJkyfWU69q/LsdfdV/vPBZshx0TajouAWL/G6+AxvqN+EJq8I1TqxO5Nhaes4WdGz7JymWK4l07i4EzfqWgvbiBsjq9BDzM7ZG/1ZYCmYz6MyNQMIwBA2AxAfb0Dq70RzDJ7Fpza2agBppDxzDvHGiUm/axf7gavQG6PNIKdbu8EekEjueFpLSUaapHy44pHtuBw0+PN3di9LNrvEmCj4UClW6xjDIiDJ5dZmm4oZYb/jAF5z79pUEOjaLh1T/cng9GVqjSROUDapEL55aaJ79e0R1IVvzA1KThQlJGbbuehcJSjlO8qpMvdAYPCcJLrQRmBWBTFqCwG0ph7ulmbam87RNbvP1KsBGx9GL1JrZUdUla9uB1K0CP+BP6Tm7YFgx5zzBVoL9eE5BJq4o6uFwRJxJWHnXzbZnVxB/Q00jwzKaCAXIpV3R5gEicGadGHyN176WF2RbxrTdnzKPwIcGxwvWZEDaIyD72qsEkRyhwp1j/9GiABYpxxqqp1A1tbYPWsJalwTUHpLie2v1uGc6e2XBZEUCUzx7vhGBKxXYPAmH5GTcPZb8qaUl/2mZT0qdczcg2LyAx/rfjPmURwT0tiuMg/g1d+bEZ7zNS9WudXnYK+t0/xmJTdUCtB47hrGHcGWVesKtccLbfO7+Mwx4RKo2rbBnuGLzQPpaSKWF/CczAv3X7eekYv490RkERcOQfXB0Z4U5MkmiGihDVUetrxsdTCkjHWxoRFdqjM50SUjXbCFu0FcP8xKoelA2TE4kc50THlQ+wOYW2VyJaKiwJpIoKoAzA
 ksh+ojI7
 QuJF2vWHPdQUPLOisWI8xf6MxZ+J245WNkXrf8+Gx0uZtAS5bxn2kf6MpjgRJBNEngjvPl1lrfWnLyrRVot33as3c22ueUwaosh2iQr15Cmf+DPOpbnLEbI/O8i9Ntf+v6Wj76k8wXi9fhfx1iMOJec8kwaUmRmFcV2WPc8RJDS0h9QTlW0or0CGU4CISFyu3aaUzZ/rirEe0l+vfEtAImoZO/qgH9gMJtHFl7VKzGP6VHZcBOj3S60I+iPxyb0mRCty8NiHFMue+9uebclgN6dE9r6yQ9kwcaRtYUEO/eEGQsGM6S1T7VSVsVVvSOYmKFeO4cT/fg/uyzu+GPeDfG+z0UGq65jcufIJn0G/Q+NYHZBNUXAg/48v5+cVPHaU4TKrI2NFtcDrVtept8UYfTbATgOUO29Tj6SYGUfrsHLxIaojZEv5MSfmocTOJWdu03x8lMubdE00XkZMApUZ/RLR5A4txAAiPCKpE5rr3+QliGiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user provides an invalid min_region_sz (not a power-of-2) via the
DAMON sysfs interface, damon_commit_ctx() fails the validation, which
causes the kdamond to terminate unexpectedly.

Reproduction steps:
1. Enable DAMON_LRU_SORT or DAMON_RECLAIM.
2. Set an invalid 'min_region_sz' by setting 'addr_unit' such that
   'DAMON_MIN_REGION_SZ / addr_unit' is not a power-of-2 (e.g.,
   addr_unit=3).
3. Commit the parameters via 'commit_inputs'.
4. kdamond terminates due to the validation failure.

Solution
========
Add power-of-2 validation in damon_lru_sort_apply_parameters() and
damon_reclaim_apply_parameters(), return -EINVAL immediately.

Patch 1 fixes the issue for DAMON_LRU_SORT.
Patch 2 fixes the issue for DAMON_RECLAIM.

Changes from v2
(https://lore.kernel.org/20260402053756.26606-1-aethernet65535@gmail.com)
- Split the patch into two per-module patches.
- Add Fixes: and Cc: stable tags.
- Elaborate user impact and reproduction steps.
Changes from v1
(https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com)
- Fix memory leak issue.
Changes from first attempt
(https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com)
- Renamed the subject.
- Validate min_region_sz rather than addr_unit.

Liew Rui Yan (2):
  mm/damon/lru_sort: validate min_region_size to be power of 2
  mm/damon/reclaim: validate min_region_size to be power of 2

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.53.0


