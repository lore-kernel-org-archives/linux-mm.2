Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235F4C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F206B0088; Wed, 16 Sep 2026 20:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF33B6B008C; Wed, 16 Sep 2026 20:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE3E6B0092; Wed, 16 Sep 2026 20:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8666B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:36:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F210FC01B7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:02 +0000 (UTC)
X-FDA: 85221386964.30.027F1F3
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48EBF40009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ousgl4ys;
	spf=pass (imf07.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789605361;
	b=l0gPYDNQpMjDDj0fMDJdcITWw1Vi2SX89v9dianY8AJJYhKzBde39T02zC+x7iOIsa1t56
	IGhZ8q7SAdkCFtDq+LWWi8C2FbydQQ0y34ZEWs0keeW1PkJCJA0h+jWXwGa1gjBSFAOQ3o
	dQutQC/icwUTzeMcw/gXdeV6htmQfHU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ousgl4ys;
	spf=pass (imf07.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789605361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VEj2fyxUopAvzTBRoq/IFzzaeRf7xOyxSUgSKR9PaFA=;
	b=SOtCRJas+VviEZfIDUga3oWaXvZMsmGKMPcqKnJrp43F0L4CYwgHUHfpcuW23Wu5nb6ER/
	rM88MNqBPNnntw8Y3vBUudv5iXHVczH5BVjxudRer3y1Zb6AR4Wf6E5Zbf9MgNKYAWAZTp
	JX1NxS5IOkvA40NI7nXYKZXLMUFHp1I=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39d654f02baso213106a91.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789605360; x=1790210160; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VEj2fyxUopAvzTBRoq/IFzzaeRf7xOyxSUgSKR9PaFA=;
        b=ousgl4ysPStrFEJUAakelWDdiLux51wwE2Ooac52Ld/HjibFcBXYvpBkrNUu0ud31M
         93YSawLq/xSP2iejqo9pnUu/QiAGnF2T9jV67nwp5poSdIf3Gx+NRYkXhYTkIUquQn6Z
         AeHsABkvltA8dkD4Jt4V9jJ9O4n0sKy41T2Yg+Gu3srX/MdW7JwLqYGdE+a5rBiH9nZQ
         aa0i/gvSJSw6vym6/DxFLnOx4qG22gDMf/a1a7MviArLZKe63TFFQL1jz2SQ6bbUZEhu
         W2vt+QR7yBXCCiMPWF5P5klCOAIwDDgC9SI9b7y3sZQM7r5Me0efn4QIyBLRjP65fgTa
         DV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789605360; x=1790210160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEj2fyxUopAvzTBRoq/IFzzaeRf7xOyxSUgSKR9PaFA=;
        b=iz0iryLHQ8UM02aRrshPUTuacsf0xr1siPv40o7ljJwVydpL/HR4N/CrsMh4UEVFXQ
         DKg7+GKw/zWIg7IjmufpYK2lvNMn4XLdvrYhC6II8YXtB4kR04DGdzjp8NeFF/uiYodC
         YKQ0ReJJszgLSyIYBRJTk8ZCJ1cQv1gnurfZM1TwPZZwSmV8Fb3R/xt2s30ZDH1VlYzh
         oEjrB3iu0wRe5BqRHiwAvFDRfAKPTgq4Gwbj7gCKS7DfaZqwPB1W6TnSvtsSW8sfuyVX
         zBRwAGANSrF5XoaesGkqCE+2vps700yl5cqXElOrpuaRpmqrnPwfkmgVCIL8TsMavL8K
         oJaA==
X-Forwarded-Encrypted: i=1; AKwUvBwwqybwj8n8bdqpvPOdSqgd8wvqFTR35G4MQqn7TQKZ3FZX62vIH3oT1s0w7qc/m6FTRSnk1BTSWg==@kvack.org
X-Gm-Message-State: AFuF++k9Gadv6qjwQjzStBtnR7BKKyhxua2DUeLGSbKcKRtx4RGZxNxk
	/PnKxNaOIfTu7Q9s2JFRrdUQ1OEjIXKuuevmTSp4C0gXm6QcCycHYWA=
X-Gm-Gg: AYBFou00XSGrFi8OhGv0qqS/TgLsz7ZQ9GIv3F54Z4sZ7LZG4GSkxEW3AdqFYvuAn2E
	KGUSWhSBEDt1QBiBMo9o7ekLyaavc75yooHunHCzrpRErCUGW0NIl1tAonrdWy0TMLIZwCgAJT9
	HJlQAQn12YjtZ1283r4VBDrqe0NHw8xt6Vs7DJVxMz2ar18rKRogNmowJ3OtKxsxrbpo3yXp/7F
	lh2t9yeLl+Vbbfr6xHmcZzOn8rh98eAXG6Tq0tKGUJPZUEt1hlO/Fm0ny6sfRWuBIA+nuKCdkim
	oLUOc3IfSai8VardJ052lyc6DaXpAslLui02mutL/THv/8JWvA8Bq5ucifj5I94+ZEr2JDGDP9O
	5906cv4JfqCN73oQKEuzlKUVJMghdEx/bUOjvQmDwj8UoNAtXthaahixhXeXG5P8x1o3zvpj9r/
	3z1BHkqwu/R/9eKYTWK0E8dlPRQz2EzcCysTzh3NTtN8MkpATaF2QIG8xxJbNZDzTR3ymeGbTIQ
	IbtIBXUwCyRPYnELDsfsamA3VQ=
X-Received: by 2002:a17:90b:4ad0:b0:39e:3559:12df with SMTP id 98e67ed59e1d1-39e35592079mr3560740a91.1.1789605359950;
        Wed, 16 Sep 2026 17:35:59 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:3990:d106:a51f:be7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e36115cc8sm1722374a91.3.2026.09.16.17.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 17:35:59 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 0/2] mm/damon/core: fix the size charged for a filter-trimmed region
Date: Thu, 17 Sep 2026 09:35:51 +0900
Message-ID: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48EBF40009
X-Rspam-User: 
X-Stat-Signature: 13e6ufhugx13jjdai1b64drngzw5ugx4
X-HE-Tag: 1789605361-887133
X-HE-Meta: U2FsdGVkX18Nf17E7o7KUsmg+tph7Yw4u7DAeGiOXnAZya69S+iOnmfb+EexWKr5LIdaoOgZZZCOcnqNqSDea2T64g9UFyWxc9r09rw03JvX/J4Az1O2aA+AT2ZtY24+oDaEw/0JZo14cRpu7XQ6MgeQeEbsL6I9fJ6lys4m4gB9bLbZy3LpucUoP3lsWfH8iCXSa4ZeCYxRpD+mD/ze7x62ZECocr37R7d8qiFB//FN7f2Sq4VHUVLKyc1j0R1UMmtfZBAvxUbN7A9Jq8XwEPA68iTicNkiyjlwMyw63VE4PhBy2oaBkUe4yR7gaOlDmGk2BI63jUHNIl+EwVfAZUwytzTyc1i88+n/KvdXRxhAyqAYOSIeFUpPew56ouxHDnSUXjNKgYNZ+RE1XaAhrPrO8xsq3mxFTELFwGI03QhdXho3oB4gFg/LHFj4414uVWBPwFE3cftdAsl2BJ1Bgw2MLAB7AMMjvtEDdIHm3/Fpayb72p57Igo2O1/cf/In45UPViEwuQ1xq6MOtEhGCrzhiK1MVZ76x3FI6g/sot/y8dAKwV+AwnKs1L/eHHOrqcCLAh/40nvQBbXgBd1YZD/mXW25b4VOrALzOLiFdorP4N3Ra/5jzrD6bAMTMoPgzbvRnQv7Uir3gmHj6N6QXJ41do1amx8GuQLw0NzDOVSgLC9VIulPcr5eZs+CBUjtAy/ZsNKXCoj5YBT3Z9N7P8aqtLYhD4iI4ZKlyv+RMaHUX2G7sg0PPEneL5+CVr3Yfz2qh81+rqR3o6A7PaiwLZlh//UPQ9hE188VvAG0Ri6s5Z9eFu8RA0tRaiRr16DomnMgOzOiiRfs3bITIRJdXB4MbA0dKVSeu9zYtP/gXD7NosZ1MengE8dB3fufw1GzbSUQMY5kX2aHCVGHBwLUfUeFhfQKIzWailMWpaYupKhv/RleR49ZNwFb8VDY5H4BV+SlCeGwvORDY883gLc
 w6GbY2a0
 nnqBg4PkQyqvvZLV6effwMOScfhwz/LObcmaEzOKLvIUNiFOBaYgX47RBiUr+N4fyz630FVhDmfBmVAbvavISJ7mJYOOdDPxEk63wF9+NDiltZnI3nhcN3KOra+4Q9mhjMFbt2mXRGXCxqOxeaG7NwzZeOWQpvtGTeo6Sv/Z7tlGG/S5Xcilo0SBPmSMmfmnVbWTsWn6F31oTgyqgx1xPVmE8Fw0BMemeo0YaQKMHd60werEJ1xzN35mwYlmhk09AcD74XgAQkZ7Gnrg4KjZCKSNoRy6ABnFpI7nKZnUF2z69upE3GhMamnJuL9L2sbSEsXbtRN3Nujm3iPCOaF0DDnWdl6BkBD5+uRVOCO8Clb7vzmBzebG0iqepCMBaTPrcLtNmOEgJKqJwdBwgoi6iqyCqy3+YH6bDw5DJTh4fCeD6CYgmPMbF7XuSl+jWn/9lUJvD58FVSUdM2EJ50/GUFe4WzEnrHGpqgWEywqZ8MR5+5r0+CrmjZn+L3At/XtHIQbQ+Ze88nrDptfgIrKTIj53UOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary.
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account for
the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.

Donggeun Yoo (2):
  mm/damon/core: charge only the part of a region the filter left
  mm/damon/tests/core-kunit: test the size charged for a filter-trimmed
    region

 mm/damon/core.c             |   1 +
 mm/damon/tests/core-kunit.h | 316 ++++++++++++++++++++++++++++++++++++
 2 files changed, 317 insertions(+)


base-commit: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
-- 
2.53.0


