Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AC3C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09A76B008C; Tue, 11 Aug 2026 06:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAE76B0092; Tue, 11 Aug 2026 06:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA206B0093; Tue, 11 Aug 2026 06:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 835266B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:18:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C02C140391
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:44 +0000 (UTC)
X-FDA: 85088589768.29.F904B9A
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id B509180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rPpJ0USD;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786443522;
	b=Pg0RFcVX7TWK0VZaKNCJ0MdTWNS6pff2qEZELV61eRtR7vHw8GRjFsQZDG45P8VrcoKBY9
	Kqxh9f1rp3UddDB7wxbh3fs2j5uLtYKJEtZTTMOrKbA4W7wBcbxMB1hIoThxcXuqyDRTEt
	qMgBKxWVzReykILOXWxcuiMa7NXxGyY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rPpJ0USD;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786443522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=upRWsKe+PxidVTSoqqQjxjY/dJdukcCCjBrH3y90UxI=;
	b=laxq+2Eakj2CdeIXFJpzW4NVSUjk+oVYGE7iE7eYHMpSnq7OHxnBxKGBxPY/d/cIV7DwXM
	a+FGnVzWr+4EohjHEYgM/Y1sdl/l9I61uNqe+Zloaw/jhTrSsWoyLsOQY24AOYII5O2OvR
	xDRCpF+RHvmo9+Hu7lnTFpDbZwDW5Ig=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c96c92c0980so1700526a12.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786443521; x=1787048321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=upRWsKe+PxidVTSoqqQjxjY/dJdukcCCjBrH3y90UxI=;
        b=rPpJ0USDxQ33P7tzrvkQa4P1AySVoArJINwL4Mkdf/gV+gIilNpraj7NLt2DZVxSLC
         PGLyFLJxfzBmnhH3kItFdod5scXAPs+euDptEzHDdZkkuwxzL4iei0xpvV4hzOm1Sjus
         iCl1vMrzVZZjD+Pc8I/2JjHscztAeQG0v4WHQB+gL6fd3QgX6BitccOzpALAyiuVPcl0
         Xm1w/IJ3UWpLVNkD3d2nObpLSEyPi4fIsRGpnOonnEBhQmHAtw5k8ZUZOI/ZMNAL2ae5
         /XtKpd8YePwvQnbdOOC96utuAlZMcrJInqTiV68tW8MrbSrKu3ZTO2Tl90VcDpsJTdWF
         4mTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786443521; x=1787048321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upRWsKe+PxidVTSoqqQjxjY/dJdukcCCjBrH3y90UxI=;
        b=YUlIBBWat+i8WVH6Rk36bZ+jvYSaTUs4DGEnJ0dgMawXI9/ztcQfAjjOO8PpS8X60K
         o66eCmaTrY1TrRtPxH8y+O9/RYutJsC+v0mi33N+77wRxj8eQwFHlGs84HfNDSwdfuPf
         Z23j3G++2aQqIMsbgC4yHgfIi8ubkQ94SHhOJj9NGrq7KkkFdOQC/rYVBu+T0aQYsCx2
         VsJT2s58M+gKv5dAz/b4IIoVez1NqPMZCuoqlcIg9hmAAP0T0SLujreiW/em/dA3HXQU
         9CWzv9YX1AhnpAzrYC5WEvKcV30DKFCHU9lw8v043MVMBrDoKLOPtOR8HghYEz03XsEC
         8sKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpS02exUSdbnccg323NNRlmF4FdHxDpVN38fwL3owuJNltx4P0YTXR7F2e60JmzS8AuhFVvEkVOGg==@kvack.org
X-Gm-Message-State: AOJu0Yy1tJFwhgwW7+IUBx1ImXcnEYQlHZGlS7RJCblcsI9GCM0PGl94
	qW7hT5lMbjknBUINyxtU6m5zagucEcdy2BeLy3jCAiPWGGkWcgQ5XGGA
X-Gm-Gg: AR+sD12j1qnZKbNBd+OOzlJVoLcxNgCgnLTR45ClBrXi7vaYABepmaORFt28CkjOKAa
	CpotfzDgcFJ707fJp3vH4CqyBNiSCXTw1tmhyBN3x35yRu4W87FOeh9LhmqZMGr/Z1OCcA/xZpJ
	PuAdows32Fxg3LVNp2QyPHkhiCO5P1onyhPcLLpPm3g6QCTSgYeP5i1AeJJft2jJJxHBxVXm54m
	aHObLol1dJZQ/ag4csZu8GNybV/Vs/SdT5Dc8dHxIpsLgXpG6Bgq+Ho8NKdTyze1h3LJen6DGDl
	S40YxlCYHZRGfSCGPkNeWIy8zvMEuHn4Gc8DQwUIzg1nf9MrwyRO+hhEOJQajeJcHNIhBxMDd5w
	yszgeW4vA9gJOMHzWMKTdAVkByNjUSqAbXFB7xBog83CdiEEgQr7L6BZ9YzYajrm9SEXKv/oWaN
	vndaewox0xDDHPlm+HT01S1ot0bKgvjN1C+qBLIz5iUVXhGZze6AfHS22tO7GIaao=
X-Received: by 2002:a05:6a20:938b:b0:3bf:7ab7:98a4 with SMTP id adf61e73a8af0-3cc2ba6e38fmr3152503637.27.1786443521318;
        Tue, 11 Aug 2026 03:18:41 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412042dd37sm3752328c88.11.2026.08.11.03.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 03:18:40 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Tue, 11 Aug 2026 18:18:38 +0800
Message-ID: <20260811101841.804596-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B509180008
X-Stat-Signature: dsz3bwyux9ktbtcmicxikah4fqhjkfr4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786443522-451790
X-HE-Meta: U2FsdGVkX180ZJw/EJhviCoJw6jiLwJBtfaV0jHZvJUX1wwquoR2ByKXzxiCWyDaWYlvL0lqjC2oBc3D5z5X4nWUrfiusvNR8EmS8ddqmS1NrecJ3G6+j7Iw6bphYnvMG8z64rw40NPf9yZIgq4LFD6OXWbz+h3slKuYspY6wBuTHAxQh2YXuUQU6mVduUq0ti6puW62rCSSvPVwz73wE/Rjzwg7zo3rYwPmUSfqMRUO9EWBHE+7p2v6z7AzMQqNLxfktqmwH5SY3vfQXXIIMkIaljXkrpV9HlTfxskoHrC5kyCek2+4bTG+Xi30Ce6cV2UUmZeWS4r7nvjW7uiT2hvMvOT3wpPaznqSWbRN4VCSYZLfg3NF/Sg6LBAanqovuE0jGlWvMbddvkhkKPoT981n8Gtqv1FCC8NvyZQp7y0bsjEbTaSEGOy0IXPF47L3ac6HXpVvw2UrLiVaf9ooW4DJ/Gox8ct6W4SpIfuSM6iAwr5iB78GMHwPk5K+Yf1VkCNEclPMN72M5vl8tyJRKxF3fjrx8N9UU9TLGZ9AmtXNAZzlW++mv62CQog/4VK4WNGu6PVQRdHouYELoeH0kq4sUIx8c/qJINo7X9SzSNhj9IqL4FV7uRbc0Fm0AQcGRpSUIEqgrk4ORTYJf8cv6yP0lkRVFPSuXUmNYBOH6pjzInV8Oj7P868D1f5zrOfnDinL9n4MUpefAb7lN+3lK3lS0ALhiG6vrsNFYTk87wF4tWpSGwWXSKeY8qxbPO8kPJn5k2ENmDx8YCH8lciLp+PuZmcD5iM9fRV/yXf4fgIa4IjW8gLkXifACOWwWcghNIRly7RjKH7x9bw1waghLu5EzDbqIOixS1Ph40vrVVqhfyAC0bzGu8HbnOkgT9+Tp1WjoIntfvbF6o7QtLuNhT4JoUJCrDGO9kN6H4d+Lmz92j7BtLK2012Xjsfd7q72OBOAQ1w2rCGaQK2Jwqb
 AKDLNxY/
 4sEXHldvMDsMO526RhdhZ15m9FI9DTk1AntamjPCU7QgjwEecQl4AXLBVl2l12zF3uKQIQCBQwbzOFpuuFlkQWyvIQo8RmHwb7Y8zE5iRV3eoFjpItIsgmp9s4mAyWFaNLs900KHBuXo5XSdMbVFOSnzkvgyxN81mFm1yzCzyVN9kY1WJj4+uMerbvO4l5Nl5q485VsT58RdfDfySc7p2qQXIqVT6KG0w8dIHrwQsdseYqxRPUBtxFnZhjIC/KD2Eu909Zh262UrBJcpkzCgHYXUL9AT+kY7pgDIZMl9WJQyM1sQGboAz7Vd8/Wh47xAFz/cnKy2EIcxUzK/1hGGraFstsSxxbps/kZol2h4QOu7moUg0tXNNrqTCR7u1XJMV0j2wVJpio3stA1RZKKINL9PHdY1R/VI1P+1uP1LPy/yUdK4qbaWEQn6qE3WzZ4IGe5a+nOJgp9NZ5SSuKS2PkMgHDgLKQSix5BFTCGpS/d27Rj0xvE4tuMBe+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an explanation of nr_snapshots to avoid misunderstandings.

Liew Rui Yan (3):
  docs/mm/damon/design: accurate semantics of nr_snapshots
  docs/mm/damon/design: difference between watermarks and nr_snapshots
  docs/mm/damon/design: fix typo of max_nr_snapshots

 Documentation/mm/damon/design.rst | 7 ++++---
 include/linux/damon.h             | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.55.0


