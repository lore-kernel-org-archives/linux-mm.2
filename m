Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420EBC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270756B0088; Mon, 14 Sep 2026 06:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247E56B008C; Mon, 14 Sep 2026 06:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F1F6B0092; Mon, 14 Sep 2026 06:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBC056B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:56:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8E4A1C1D51
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:56:14 +0000 (UTC)
X-FDA: 85212063468.20.0205323
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22AEAA0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:56:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gtSwxlj1;
	spf=pass (imf15.hostedemail.com: domain of matthias.goergens@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789383373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Gj8h2lt98zX4NzJl96Knw548gSSkkGwsjExtVdozT0A=;
	b=IBToZ94Q8lPS3A4WugJfZDiNVBeBkuwvbKkkcjE9pY9eWXcE1+8w1HO2AbSYfYsggipLwy
	j/Xf2F7ZU5peeJHuDChAvgzQDSwPHRjinRDokdsokaZF93AhL/7Xf5FbFh+Y6hbft/zFug
	NiraIlR9/8rR38UZyUB0Q6/RW3W32dI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789383373;
	b=NNB4Vy5UGMr+IfhPp+RjCgG7E+cz/U8v90cxLbVSSmHR0Ak6yr4ij9saOzlDGjIuoxkmCE
	jzOyaK9KoZuzuBSB0TFXWXLz9iBAZwX8sceCxUAysTeJAW6oi79qw3UwWBCH2g3HVZEdUZ
	8xPA5krRMbfnjMCgPpCP1Vo+D+V6Xnw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gtSwxlj1;
	spf=pass (imf15.hostedemail.com: domain of matthias.goergens@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8692be1cda4so2496014b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789383372; x=1789988172; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gj8h2lt98zX4NzJl96Knw548gSSkkGwsjExtVdozT0A=;
        b=gtSwxlj1EMKnzkTvtMEv72CgZhAGtXkpI8AUtbX1ZC3jbv6uIAnbd9rm5WB11V1HeO
         dTmYEaP/uAgAwVfPCIezyiQ4gyycHqSXl1uVMc63Zx39rqFRQ7+TqhV/HhYjWB9brPn0
         +JdtumBqYmH3ESKrFlCGfrwhZPTlnOoBZc6nrK4ltVqiITmuQU0QcM5asncxoR+ZQrpJ
         hBsUQDmqtU12LMkC8tSDzNIBxmt5+MhdBiO6xMyenJlFsTnyXwnhCaSedlM7iuU7WjsU
         MtZB+6CYVBtERlru/q/oVBayNx2Mt7V7YnC7yjtAOKGoxuc2OMYrXhu8ws16HYU4NWo+
         mMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789383372; x=1789988172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gj8h2lt98zX4NzJl96Knw548gSSkkGwsjExtVdozT0A=;
        b=durtvZbdqnSE8Rdi0eCPwOEc+rEEY+a7n8Ylt/KTkc+L9AEd61kvWHQJ01GLOFsMw+
         qNLyvMAysKHsPIMdM6XhysW7AkphRG5U+JcO6apEkAnOT2TD7pYr1tMZo+vmtUQHemfT
         G3gxc5n7GQoMfcCbu0V+f7OfpN2KL+b5iNdKa94IRcgPU55wiNmpVos5osixnZgFUHrb
         Uc8mnm/LdhH7hE4SM8bqbMriCr0EktSVI5mPra4sWvItBVcDX5jydgpySeAk8PyluowY
         xBn9ZsqQ+cABnGEhN2PMR3F9z5rgFKP7kSeNKmEL/7RP8dHb6JLFImWq0AbKhdosoJNs
         eTiQ==
X-Forwarded-Encrypted: i=1; AKwUvBw4npx7cuh20uyMcV2FuAfCgFhTICqOKq8FobWnKEvEL6StmInK7Ekf//4HZwprY4IoY7vGFiKcgg==@kvack.org
X-Gm-Message-State: AFuF++njIYr/iHhRBhg84O+vffAM27eweaVNBsC5PogY/I6q84WxhYOi
	VFRaAmP1z2m9Dhcj6m2gx2zXyfa1VbLNHF5qjUntTvRaOv5tIrC5qJ0o
X-Gm-Gg: AYBFou0z7wkZ1Mc7/VwwODOkjgYhNuWgrLlWDQ6eyHxNH71K65ElRxKcN50b6FXoT5E
	tpbcgGg8SS29TzPJfAjmMzABDrY9dtJFns/AVAWWprsFaCKWR0NiuFqlsC5C7fyEqBEWDgGr6kw
	hFdM+t158plQ2gS+RuWGVCPwqNhWE9sABY+mJ3abmTCr6Oi/XoXbS2p43ZvG+FqrerJTM293Dnl
	d0rJwo5/N6mLTexZQE+x+aQsyGUVC+6d2QeMtMUoXswHiU+ODs47ZBXcwRietqTVo2uQy06ZLU1
	0gm0izOuC9dCTxo0busNKZZvkgpWWWNp13k7P2QfmqcnYnViBN6KL46XSZtQAxBW80Wx/IsoPGd
	phUbzwYjsXfwpCRJ5jcSUdNH3dSFKNwY0n52OnH3GkHuLwXVFB0x26/yrIexILG2vxM3lccsoh1
	PApxP2/7cem9x3989Na/t68Ax2Q/Oze3fF/EBNQN1YT+ZGJ5LAhprLvxcZZ8UaJW0JRvHfvDpEo
	K+WC7Upgyvtt2uDD8R9BqLZXG0Mcelaq7qFFXyC07A/uV3lBQKBGagduCrfsQoWrEnbMO2KFrsF
	8CgieRBQ/Yl25DUkMS2JOynLji/0XhFj1yr+YKfHxzGVCWq4QhpiRPGL/8jQEPU=
X-Received: by 2002:a05:6a00:438d:b0:86a:9be:6bf9 with SMTP id d2e1a72fcca58-86f85108442mr4695374b3a.12.1789383371846;
        Mon, 14 Sep 2026 03:56:11 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b287c481asm4589354b3a.11.2026.09.14.03.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:56:11 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] drm/i915: unlock shmem folios after skipped writeback
Date: Mon, 14 Sep 2026 18:56:06 +0800
Message-ID: <20260914105606.3997649-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xakoj7ne41nf81st6jmtikjjumy14rs7
X-Rspamd-Queue-Id: 22AEAA0005
X-HE-Tag: 1789383372-250424
X-HE-Meta: U2FsdGVkX1/R1z30iwee+c9GtuQHW8CTj0iLGZvCZxHRyOfUH/y7kryUtmmxPJZy/mfORkt6VdBewvmoH02LksjlJs4WiusRKUOsXKD9Axl5qrPqnzr2UpOglWz+t+53ib4eRbaBFBw6Va5VXrwXTiZA7UL1kMYHBRRO8Anh7XLuN+XWjr+CWM3mlWpHughckFlja0iOOemyKMyz3jK6ott0z3M6VykE2+npAHJbUkKGYITkUAkgxGwbDBEBqirgVIsraiF5incOPopJargOxd5JK+L2EJabNriFQ/Kkxcdsfr75gaRsd6sipnk9Kc1kvvR361kEgrayL77vhCwL7ANEYJyPqEg9gUIB9EyjOtbgAf5saaAR++bwX+wNGWWJp5x7acNsOQrCOlqB0bZBn8PdlQxuh0IicPZgZOJbDquEnDt+NxaLanyia1S/7S5vaqx4om1EnosS5e46LG3WNOw9pQpmkidlo7gpsqYcTX9byVvTXxgUoeRn4AabVZYSlCk5OFraD545a22aiUQXr9FKp+dfoLk88zeNYEE4GP/3PDgylx5kP/AYm2GGamA19iWbrhV1SfRYL+1tVWVDMbnXl7EG+bP26aOxes13bcK1vHddipdBK27nZPPciERYaktYPyZ7ENysekTuPOng+8xeIU5fMknuJglWxT2nOkk9MeIQWGum98p64PyO5A47wuft7dbmesZgT7VKIlDvZRRIWEmzkxME1vv0cjrP28rLx61/ZNZM7iY72uV9CXt1ejskh3TKE2kqwTt3btSfFToMUNld6oGMZCKCxFoGL4HBHaT6fDDLz3Q4e/rrf2TEKIObd7g2ZUCJvvVBsYeU9+U9Dl8fOdMuwMs/bqrCDY9aLdSc7IRtdQdjUdm95yBTB1wAcBM3DagWc0IG45MB2no5OjqEYnOjKYa2hB4+Op4PE27p3T8QTKGDWBC2sLD96M0OyZ+1dz4PD4PobQR
 5iIa78mv
 jJ3BS0np2fsSGDmfV2YTJjBLZ0WNwj/Erzst6H3rwBOLAW425TGtzCytWpCjSC4dpkl4SO/DAbsVHokq6jGhxGjSIu1S7SHxIsjxzMJvIAqT1s9QgUPn8qbtdQhQib2cqVNVZ6fCqZlY+M7YWiyNc2H7h4FVdU3AXDPipocOPkkUr0JS5rATaHwl6ehr9nioy/TN7wVpBgZVk+JGNOxS6FtLWoICiY5bwX1hNNpewxfZpHHLw/+Y2C1YB0e1tbmbWTR3IGnGLlMKONO/FI48phdtBAkrIBPQp/MDwPZ8ctcymzyxfh9/8LDLem6wES5BZBX8wcKswgAJ9YUomsmz/LIg7XZ64ODLhqLnkvCwk1IokLvejc6cziZI7hwDpATkw3aWO7tUVCjkVvu8Xe0bHTAApwaXY/yXlEzjw+9Y3dPjmUmVn4hDJuwFxIr9bDWVZR8+yJW6z1e3A2qR9NYrnfbiac3VPhDh8Mktu3lKT57rIFVdP3CRZbY7yA5AXvq8KInHLQpFnpqkPsuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

writeback_iter() returns a locked folio.  The mapped-folio path redirties
the folio without unlocking it, so shrinking can leave the folio locked
indefinitely.

shmem_write_folio() can also return AOP_WRITEPAGE_ACTIVATE with the folio
locked.  Passing that positive control value back to writeback_iter()
triggers its warning, stops asynchronous writeback, and leaves the folio
locked.  This can occur when zswap rejects a folio while memcg zswap
writeback is disabled.

Unlock folios on both paths and consume AOP_WRITEPAGE_ACTIVATE so the
best-effort writeback scan can continue.

Fixes: 776a853a43c9 ("i915: Use writeback_iter()")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index ef9440166295..e7b18f7f9644 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -322,10 +322,16 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 	 * as normal.
 	 */
 	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
-		if (folio_mapped(folio))
+		if (folio_mapped(folio)) {
 			folio_redirty_for_writepage(&wbc, folio);
-		else
+			folio_unlock(folio);
+		} else {
 			error = shmem_write_folio(folio);
+			if (error == AOP_WRITEPAGE_ACTIVATE) {
+				folio_unlock(folio);
+				error = 0;
+			}
+		}
 	}
 }
 

base-commit: cbd3dafc2003db679ccd2f6c6a2551db79657049
-- 
2.55.0


