Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0442606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Nko+yFpm
Received: by kanga.kvack.org (Postfix)
	id BF4036B00B4; Fri, 23 Oct 2026 19:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB9F6B0906; Fri, 23 Oct 2026 19:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2266B0C01; Fri, 23 Oct 2026 19:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88D626B00B4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:01:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 823951602C0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:21 +0000 (UTC)
X-FDA: 85355413962.11.F444445
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB7D120014
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nko+yFpm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792796479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=osCBwipyBL5AJTzZRVoR6N2lqUuiq8v4lq1bLHQB204=;
	b=FgaLJBJSfNXHcHRnrkw/K7w/QedSULEJgefP5yJAhPGIJARlkZr/3/pzQFgwrx1iji4xS9
	fkNQRIDd64vTZqPPBw6YdL9hbtRxVA0vJzu2Fw2BajEIv8yukQSgve/tT06S37pZm4R8fG
	qAajADxTYuVJELLbZEMk9EF2SdsoNO0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nko+yFpm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792796479;
	b=pdxUWsnSu7z7q/WB55chxfHyEC7nAhvEf03UNQvbIGIUx1SyVTsq6lLlGBL26LKVDOZhec
	xff9ScoODL1w6nDDrEY53/5mMybqF/N7wzNHkM8jbBLWCb/+fpqkxWrvx/40B3Y0t2zZ9u
	pBc3NC5L40HaSWUJggiNc1MpkKv8Pc8=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8ac8a2ac52bso15431537b3.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796479; x=1793401279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=osCBwipyBL5AJTzZRVoR6N2lqUuiq8v4lq1bLHQB204=;
        b=Nko+yFpmxTM1EFgj/4t5OMPNzqHFCr2xjzueZRe4nNEKc1Bhiz4eIldTly/vnywUbt
         AKvtBhTAvHmo24sk2eqF6wwdXLaAA3y7YPd5vPVfPvjn24TKHryYUt6Kt9V/gtBVtdKJ
         oGv+xSd4HHLqV28lGMGEr1qcyxckhWExzXgHYez9kHjBrcYCpM3wcQj9QJyIYJTywb9k
         omvytuVk1Jr5iOgth/d/SjNgFwJlNrZgmaDJE7bvMoxYx0rgykC5V3//mDTafRVEnbct
         f7to3lUwCqHxoxiL/zOZfN4TgqtXfQyyMCjlZvSWlx2XqzAaTVgjb8S0R+R32Xc5BexK
         26HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796479; x=1793401279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=osCBwipyBL5AJTzZRVoR6N2lqUuiq8v4lq1bLHQB204=;
        b=kbgydk2C0m4DXa06PYZrlx+/96vVgJ/Zi3Dg9q1CadgqCZ1FMKJ1CIdxKeVoLekKEz
         cpN62ZmpF0Zvev93EmvQAhbc0TJOfKKPohHN4nHBCkhLsMiqErBPuwP8wmYDeqFVAgKE
         PWchB5dq6psX2+4Qpdwgbs1eMUFGpguZ+AX3A59oWwRvWoOSFaKJ3HFpw/+D7iQfI99u
         DfxDWIRFSB0KhGLYiKVr3oj6o3Yz2pUscs4njY55q4tJQ3LDlM/TVUhmbxBSOKNY/fjq
         Dsx8gpVRr8wnfyu8OnBGA0qqZdKfR5tGkY3/9omsznTXDpxsVWXna76j32nrIOvBpEWQ
         oScw==
X-Forwarded-Encrypted: i=1; AKwUvBzJWQOSMQ6aElMp7/gGw7P715XdSCWqzdAdDj/bSfP4HfCzC+J8xvlI6QQGrKDVq2cuphYnGhqnQA==@kvack.org
X-Gm-Message-State: AFq9FYLqEXOZwEOQtBbb9UYFebZ5cwH7KgDh9xZFSYvJhP6pYQtlsh4N
	0wvhFE26QMbUXsA9guAscmJm2CuFlYBrTVfExbx5OsfX803OSQRgKSIT
X-Gm-Gg: AYBFou1JCL7bTL4iQpPxDzZZ50fs/LSWNui4mHM6eSZluIPZwOAV+Nvip5BiPpPlPUy
	/25EJqRilcK49GMRQldp0NeoJn0Pp6nO/M/Z1bB3IO1JRF0GdZzx0vioMw4+qvkIZfPCYKTTNTJ
	6rQoxjVCfxvzF4Wmsm8yv+uLFA6gEUf/g8mgDh3D6/m3tUHI9fJyOaeTPn+leqakQjb+/E1mzCO
	NOYRR4nLUK0fFLW+48ljkIhger50i5lLsM/+ApE1mkt5VmL1z1HlcY2Z8PaJYK5KCtrGPuCag4n
	GMTvGJdfLkm5wvO0ifwGHvD61fcTiQ2SfBhRsyqmzowjqM4fhfcsw7vdPkc62MG5ijEFOG84m51
	llyINfkBDZUs+eANQm0c89j3yOzfAD/MFlHjIAVLjwu0/jUzQ2U7SmIGQ/rC40lyAYBZfzvWBjW
	plggKUrqQJsCucvcR6KNbXPAZkFt4JQ0EESBgsdJh6j3AfDjwScLy/dIXV6u+jKY4cj66702n48
	PlgKszBLlS9l2jcWkC7DAjOTh9DcaBtOtKSQMjx0ItbRfmmOw66r3lgROjx+g9joXe4AcxorpIu
	OUHaCoYlJXS9YcvncxQ0mFJbHRMpu0Yd/nfHHD2GKBSuxjVi9a68
X-Received: by 2002:a05:690c:6e85:b0:8b1:60a0:c311 with SMTP id 00721157ae682-8b16736669amr4017387b3.33.1792796478630;
        Fri, 23 Oct 2026 16:01:18 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166e46a93sm2960557b3.26.2026.10.23.16.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 16:01:18 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] mm: split underused anonymous mTHP folios
Date: Fri, 23 Oct 2026 16:00:03 -0700
Message-ID: <20261023230006.3759543-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB7D120014
X-Stat-Signature: bcpjmnfa8g78mzo7fstr8sty4uyf5yua
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792796479-83632
X-HE-Meta: U2FsdGVkX1831wmEM3oBT85QubK0lPMMbz/Pcq+ejHztduCF1LjVbHlHlpXt1djT4bHBk6YAw+yQg50Wq2+gtTVQ48AwoarTIO8jHLIBvLmTDvX/eUkRmkc/SixQtvuVY/d9grPYnn01CCNjewfwBPTSL/ek4fGtSIgvGPilZHHratU2PvfPYO2B1vcwMq49WEOBqm+afMi4x8IoWCKl0lVKs9RKiB/jBrr71xaReXYerv3s0NZEX2tCqmAd/DjzgTpCkI7NmigXsr/f6PSvr/nGdVvXwM0pO3yFMp93wUodwtPJeqfW/wDOGDm1MsEwubHphmQaEke26Ycke7QZWIr4gMOx2qostSPS9fJgd7KHvEkGIBUw4jIAVLkiiQPm7RIj/3eS7jGI632O5cvqYPFLS7vK/YintAwYFDRnTdZvWZI2rOpi2oEF8nGiyaM+Aup6raJnli6N/pqCEuDedv1/C32nmkYufcNlByudkk07hsMekiC5uHEWvGw+xogz41bHRabCYZY1GPGSSDDint5asrf2czW2VOIhVRys9rl7wu7f5PXdzbAnO5RiQ127GVbua7yjyqNXv0BtahQTkxPJUnWFJYobNgJgn6UIeQ0mLeVZO8mfnhflQe5U8AKMnLwYC92axntq7pEYHQZxgyRsH6sQUFosgAwD3AW931S0zpy0CBkYHct3PLoMu8zpZushP+nAKcCAEiJwes2ZAybddCxadV0E3pY4SwBXebZA/tbJKDmJpIbnzHL8+CAMXLLDjuuPMB8FfG4ac66kqIwoLd3Z8C8zYZdnlPy2mWkqVPfHL4w6f4AMIhyowXhN9VwxwlsLKrSnGX8YDVsHI3I7lfbacsAM6RbwvTI2vSo1YOBf3rd75FfMTdl8ERIBbbj+uGUmAI+vTUIZWcUGJ2Pl/u/QpK0X0qLb4fjK7zWM6QvAtI2n0nU1TagxJfCTW41ED3rTiWJd4Y8gBKY
 Eno8+ai9
 280Uv0GrNFufv5bb2F3AtkSrlWhVfzbqTrbZzHBMv7Kd3RJEILCoXNUVJjhcE6Rw2mmEVZ8+n9GRG40lx8y/Ycpbwdi/QqlsNPkBZYfeSP00YiC2n+mTAwHJrIsmDIpseVRfn4pmuJFtJfq79Op5Kgl4lHIsTeucc6iUQZXvNGw2ZXS0Jxhzf8H6sU92eAqJrlDcbrTgth0Tu5iQT0WQJ32z8RC0cdgx6uzVYN3egKMkvvzATmOzShK4O5SAcoXWAOH0xBvR/uD0HmI/B4JmUTh7CAoc3aoDocM1cskWCoDaeYHLsKUFuJatarUAfQKH94HmFq/saQXOh+J8Pu+j9qPtJj5Qr6Gx3TrmGT+03vbipTwswDXgWrEGVzfoluypYNkwYhQ/KwPs4OT0lzlnZ1hZCNBV3ofAyBkkGG3LowMjwu5JILXg6VouV8Y+IyIU9tzsTWqOtILzl6rk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PMD-sized THPs that are mostly zero-filled are reclaimed under memory
pressure by the deferred split shrinker, but this is not done for mTHP
folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
base pages, as 2M provides the contpte benefits while the PMD size there
(512M) is too big to use. However, 2M THP=always causes memory regressions
unless the unused portions of those folios can be broken down and
reclaimed.

This series lets the underused shrinker handle anonymous mTHP folios. It has
three patches:

Patch 1 makes thp_underused() folio-size-aware. It scales
khugepaged/max_ptes_none to the folio size, so every folio tolerates the same
fraction of zero-filled pages.

Patch 2 stops queueing folios for underused splitting when
khugepaged/max_ptes_none is at its default maximum, where the shrinker
would never split them anyway. This applies to PMD-sized folios too,
which are unconditionally queued today.

Patch 3 queues anonymous mTHP folios on the deferred split list, with a
hard-coded 2M minimum folio size as suggested by Barry. PMD-sized folios are
exempt from the minimum, since on s390 the PMD size is 1M.

At the default khugepaged/max_ptes_none, no folio is queued for underused
splitting. Once it's lowered, mTHP folios of at least 2M are queued along with
PMD-sized folios.

Changelog
---------
v2: https://lore.kernel.org/linux-mm/20260916224437.1164512-1-joannelkoong@gmail.com/
Changes since v2:
* Go back to scaling khugepaged/max_ptes_none per folio size (David)
* Keep the check for the sysctl maximum on the raw, unscaled value
  (Sashiko, from v1). Round the scaled value up so a folio is never
  split when fewer than the configured fraction of its pages are
  zero-filled.
* Only queue mTHP folios of at least 2M, a hard-coded minimum (Barry, David)

v1: https://lore.kernel.org/linux-mm/20260707201735.4113107-1-joannelkoong@gmail.com/
Changes since v1:
* Drop the per-order scaling of khugepaged_max_ptes_none. Keep it
  absolute, matching collapse (David, Johannes)
* New patch 2 (suggested by Johannes): don't queue folios that can never
  be underused, which both bounds what patch 3 adds and stops queuing PMD
  folios under default settings (Johannes, David, Barry)
* Fix the thp_underused() early exit to scale to the folio's own size

Joanne Koong (3):
  mm/huge_memory: scale thp_underused() to the folio size
  mm/huge_memory: don't queue folios when underused splitting is
    inactive
  mm: add anonymous mTHP folios to the deferred split list

 mm/huge_memory.c | 58 +++++++++++++++++++++++++++++++++++++++++-------
 mm/memory.c      |  2 ++
 2 files changed, 52 insertions(+), 8 deletions(-)


base-commit: 3fdcce698abd9193752ee89fb1a440cdceb1b74a
-- 
2.52.0


