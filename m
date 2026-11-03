Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C04606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UnUrCndu
Received: by kanga.kvack.org (Postfix)
	id 195146B05C8; Tue,  3 Nov 2026 16:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1470D6B05C9; Tue,  3 Nov 2026 16:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E546B05CA; Tue,  3 Nov 2026 16:20:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDF176B05C8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:20:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50D2312053D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:39 +0000 (UTC)
X-FDA: 85395076998.15.062A8F4
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 94FBA1C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UnUrCndu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JZWxs28Swi6KvLrdfpw/Rl2A6s+q4ydhcLGZmoeDLAI=;
	b=Qwn2FoUCzllBugHNp7Xr0q37vi12ma78kJglqQeIRG/gC8saE2H0WcLPDlSKaubCj+y2E5
	hTrA+MiULQhLcY8MP0MwAQsgAJziqeenE8zdkAcKYhUG9/Lo0iJyHry/J6iitkOVrbfDgX
	lNzJoJjR/o67u5N2lOeFJLKAzBZsdmg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UnUrCndu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740837;
	b=Sz/pnnXRaVecnyhDcc0ReoxSjtYWkZf5Sj4l1DcEAp+K/5btagpRcQlLdU0aAOM7oOO7pb
	/lGV8jczerYgJo/RgckAuNnDtuy74aeDKRrxq5C99VuVa0Caqf11d3iVlBIh+yPumci+PB
	6Vs9AzMkNb2dPOy1kCty72fbBsgGtes=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso27972a12.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740836; x=1794345636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZWxs28Swi6KvLrdfpw/Rl2A6s+q4ydhcLGZmoeDLAI=;
        b=UnUrCnduJKbSIjfKkxVXlXIVrHkZUSjj9fXUL3KKiF6zkGz7/VPx/O4ptbu4qcGjwr
         wzu+e6xEiJKCCmKC9lH8WEGHClop36ge2+0zOx55K6scdrZQRcmhNwI1ee6DRhs2ZGFa
         Hace4FTL4Qvfj8XqrNg9zoHQcnNlVrfuHNW2sUkqairneOFc6iKzjPYR5lvehx9PCyRk
         6LUktzgSEUs8COod6C/RT+B0le4GPnO3rFhM+s4U5lueDD6ZVMhj7Ni4/ug+MjBJimy+
         Ae1YfVhOBaP7aVTbwUlL4/7RZCJ7gjjLOkCzbr/goRvYxtfIhdspGneLBQZgsAhvx7fu
         81eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740836; x=1794345636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JZWxs28Swi6KvLrdfpw/Rl2A6s+q4ydhcLGZmoeDLAI=;
        b=ec+S7+BeYnHz33taBhp91EOLOpsNu0LeE31MB2lhEqnzNBlWe9yQpkrh//cJDJRxl2
         4xD8M8MMuMJ6NzOErPWdCSJ6gy8Bc+mlWbS6yazJ3gc9j8uUga+JmRS6teEMP/4J2LFY
         rSEEYrBLnf9IKWMyYQ6xUhzndzGd0gTCEiBR5AqPIw2BloeR6jPzgCBa4Wm8RkEH85GO
         Pn3lcue50jVmTpyid5iCl3JKHoKjPVpE28a0Nl2/+qwX4xUCWqZDI6sYVIJ1+DIM+ofT
         2y4U1Nq3IUhufL+PxxyjtPKWJ2+0c5r1gaRAh29QSPvd9bdAbvyqN2eIEptUonqmkLyB
         1mLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFr4iEGKRhknLK66HqXIEtvg7UlplARsCux8YhPsYBNeXtE9u2JQglMCxZQKiMr+hcYHUCoE6uyw==@kvack.org
X-Gm-Message-State: APuU4Z845PXg3BFHyILOGfz/U2pCcbi9S2ks/nx6A/ZjADHddK23sqQx
	Z3nGHyEx5AVHVIQ5cIoBBzj4rdhx1rfAh/GfQRn2XAQYkbLbnzkGDKI3e+kONg==
X-Gm-Gg: AYBFou3RTtEJtrdiDwhIYJGOiFNSg+5Dx+4N+FvFv1evI0Cp0hNNinB58OoO1joM3O+
	UuHFlls+fj72CIgwuQTClDgsb9Lvw+4qfsas7We7zeUJJaPglf+BBh48hVfaUDORkO+7+xXyEZz
	M8U013hpND8JBcgUnZg1abIqIBUhUjN94urQVYs34m8tyHLdDXmWR/BlqajKu9+dMs7SXkAAD/A
	HQ5Tv6LzRa0llfQEDXfr+EnLTbv6EePYuN1qmKNAqNBKTdhw0aAHl7aqts52P9WEqbAnD3pB09Y
	S2kvCJulL7NtLZWY+uQp8KoRJTj5UPdmiiou0y/imQvpT5hrhPlyAnJaduZ/oQB+VPgrgDPMV5a
	xRmxzNMAtv2SJCvegZfPPt1d+F08uBiiIigJ8Cy7aIuEBhZQGl3kfBKFVLQHcJYOiW75Ytea/+L
	VgcSpHtguyl6VvyLNw5CBGACJJnyFIDtuNpGEiRSCRbMaPNrARB4WiN2MEICHi9lt/L3s46Hmy4
	H8vYWg6sWh71JxMz8oHXc6I0H/WRAUvnNtdD4rm2/2GUS4ZxamLnonn3vPs0/gvhzQk+mQ7YQEx
	Oc5VU2fvaQrzkSPMXkz/AIj4w+I2oGpr9kpm0pvyd8/btr1CKO0AC9IBzx1FYmmP6bTu8zQSTFC
	mCqqr
X-Received: by 2002:a17:902:fd8d:b0:2e9:5714:6075 with SMTP id d9443c01a7336-2eb364962f4mr127434195ad.17.1793740836317;
        Tue, 03 Nov 2026 13:20:36 -0800 (PST)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed09127cbfsm68605ad.50.2026.11.03.13.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:20:35 -0800 (PST)
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
Subject: [PATCH v4 0/4] mm: split underused anonymous mTHP folios
Date: Tue,  3 Nov 2026 13:20:00 -0800
Message-ID: <20261103212004.1356327-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 94FBA1C0002
X-Stat-Signature: 65hz8hnruygibogtgztruu1gh5a6dkkd
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793740837-475194
X-HE-Meta: U2FsdGVkX19km2B8HUZlGCFotWucewaXHAm/Jza3INCe7Bb7Y1LF4uMHDKhYHsOu7e3qY0g1rAlUqMTGN3f2bxhx4OcOrdyEKuc+jWLHvRFCjHKkivM/MKrHg8Hxw1/Ne3Y9ByJzNUB+7MIt63LPheYQTD5zSDkvne/KkQVi30egybhhNqMkCvUBiYLvIDwmJLJeZq5+xmmTQZ2kR8AFaXMOYPjqieFdwsvwnqUr/BBS+qHJevXNUAz2esQ+H+CnrwvifUBmGEXN5an72s5FTDjnvQ8qswJ0QUeNWAUXCCJeaWkADztE2fUKWhIJ44Aug2o+WCOszhk+FhcgLsxN1SHfyAhP5j4cCFC09xykI8NNhOxJSqvVKhQGyhOAqhqpKtYf31dhpBNUI3XMbCBYfcP7SmAFsafBoljLkE8k/LEbgpiAYfdF0d3qG24jLEaxD8qGa3DjDR1ccSjek/ew750gSr6sNegGcVCtrhb0FPMsCjPqQR7AHjHYb3ruOGZX21Lky/jCyqN4V0s6RV2qb5fFrtzefwWs/0qYFBjkJZFaBtMETLetvn1J9MS3GrHkT3cYasFayoj4m0wbVTmFrgO9wUTqx0ruRkuXWCyRBATLTjt9PKQbR583BV8rUQML3XH2YZeErwC9vBs4MQ+zZCWtQosyT4gFhmFmofkyynZLQKZ5P1FpPxqQGEeldIjFgAkl2OuCU0MbIMGVsA5L9HMo2+rPc5LZ/V9hZ8EWAdKdta7dXjOwcioMeh5WtT1w5CgCWd/hDjkdRKI16olkUgugVh/L5sjlZwexoOoqIjzY7nmWMmdWt/Qr/yzeum2uZOBVJZYn//dhoMa5Tk2eym7C7GGYvPuXs9UoEIxwWkG15YThFAt/qxVmAz/bEortayLNMVlvtYQdijzlIRRcjSZoPJUsMrb3eGKkyux9aJsxj272WXadlH0t+R7kiAJ/6orbDOmqxGtg1gj18n7
 sXM3+/sT
 qcjIikUTqTJb7jEa22+HIXnDJ8U5tvLBjhV9/Mr8Osov9NPv/4t+GM0Ktq1auFfMnGppP7XlAHN/lP37Ch4+AfWvowyNdatn93RiQLQTofkr0tDAw0entPeIjCkfUIEFxsL4ED0Aaoze9h1Vl15BBx6ZGCUivmXSwBivBU8i5swi0vDXkiSJPThuMjWTFl28z07Y2jpbjoZTv4HDsyZSFm7dP9mrOj+uGc57uk6/6szXlL+xAWn9jEX4Ndy3PzEWMv+VyFfAbzterQYIqFoesHXvEkgydni/QHb5oa5wUNxM5I48qh1/j7/iQclrJrt4H9t8+A+H8xeCiFCz+6niovzalk4ktPg8YazYmpNFrSZ5BwzGEVeO99wG/9y2wudZoDprvynm1O2KhZzVOJKRWQWzd5s7sIz6yj4lpeq+iMWB83nMY4owZ8H8NCqpQAaHMsJH0Z4SOh/6u4G4=
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
four patches:

Patch 1 makes thp_underused() folio-size-aware. It scales
khugepaged/max_ptes_none to the folio size, so every folio tolerates the same
fraction of zero-filled pages.

Patch 2 stops queueing folios for underused splitting when
khugepaged/max_ptes_none is at its default maximum, where the shrinker
would never split them anyway. This applies to PMD-sized folios too,
which are unconditionally queued today.

Patch 3 keeps thp_underused_split_page counting only PMD-sized folios and
adds a per-order split_underused counter, matching how thp_split_page and
thp_deferred_split_page are handled.

Patch 4 queues anonymous mTHP folios on the deferred split list, with a
hard-coded 2M minimum folio size as suggested by Barry. PMD-sized folios are
exempt from the minimum, since on s390 the PMD size is 1M.

At the default khugepaged/max_ptes_none, no folio is queued for underused
splitting. Once it's lowered, mTHP folios of at least 2M are queued along with
PMD-sized folios.

Changelog
---------
v3: https://lore.kernel.org/linux-mm/20261023230006.3759543-1-joannelkoong@gmail.com/
Changes since v3:
* Scale khugepaged/max_ptes_none with truncating division instead of
  rounding up, which is exact given the strict > comparison (Sashiko,
  Lance)
* New patch 3: keep thp_underused_split_page PMD-only and add a
  per-order split_underused counter (Kiryl)
* Fix typo in patch 4's commit message (Kiryl)

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

Joanne Koong (4):
  mm/huge_memory: scale thp_underused() to the folio size
  mm/huge_memory: don't queue folios when underused splitting is
    inactive
  mm/huge_memory: add a per-order counter for underused splits
  mm: add anonymous mTHP folios to the deferred split list

 Documentation/admin-guide/mm/transhuge.rst |  6 ++
 include/linux/huge_mm.h                    |  1 +
 mm/huge_memory.c                           | 66 ++++++++++++++++++----
 mm/memory.c                                |  2 +
 4 files changed, 65 insertions(+), 10 deletions(-)


base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.52.0


