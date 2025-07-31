Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CD9C87FC9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 01:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9646B0092; Wed, 30 Jul 2025 21:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A816B0093; Wed, 30 Jul 2025 21:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FA86B0095; Wed, 30 Jul 2025 21:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 052D36B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 21:54:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E4591A05C0
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:54:01 +0000 (UTC)
X-FDA: 83722889082.16.856692D
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C2714000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:53:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TJovK3Wk;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753926840; a=rsa-sha256;
	cv=none;
	b=AWNFPxFTLZP7hrELbsLDd0ZIdtzPvVnW/8ppY6pHNwnlAXhtHKnn8JGmZX0xe1bMutFQ7y
	8P1mltP35tthh7xg6SMjXZjZ3DMZ0s4a/6fiO4NK/g/C9ctotfsmD2TTppuQmAm+u4Kx2P
	rNRzrtCYRxi3al+IJACnjQ7nZ6kmHJo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TJovK3Wk;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753926840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9gSsqsMNfh6LJcBnky2k2FWl7tW2t0BIGDVockm4ir8=;
	b=8d7xtqYSD12ZatCAJZPxtRpH8nWRAJCS3kd2L/MHUyAPNooOxjeTRXNL8yi3jIMUtwrJKG
	+Watkphf+acVlN/FKRgIaRXhrPoyje0BWSPeeaUdodPdXZhnfQd1MetjNy1TIExhuULGaJ
	X60GHTOlxL36JXcHZXzt4vs6O8vtG3Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753926836; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=9gSsqsMNfh6LJcBnky2k2FWl7tW2t0BIGDVockm4ir8=;
	b=TJovK3WkuO5dOfCiDLur8dXzs6cSz98yhhZXm+TM3Bv0dN5IIHJdRRzCf1H8qFK54Rr0xy6WX3kP1aoGIdHgxCnqoziX48qF+6+ue+SabZxpIR+oI8lCnJxgdArslN6vfoOAB+wktXmYPoLtz22C2dAWpV+jrKxu/CjiAGqtA68=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkWNcvl_1753926835 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 31 Jul 2025 09:53:55 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: patryk@kowalczyk.ws,
	ville.syrjala@linux.intel.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: shmem: fix the shmem large folio allocation for the i915 driver
Date: Thu, 31 Jul 2025 09:53:43 +0800
Message-ID: <f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C2714000D
X-Stat-Signature: kqxcxczqsk4jyfok75me7rdz7pfsd7sd
X-HE-Tag: 1753926839-787484
X-HE-Meta: U2FsdGVkX18e79U187GTjH52b4/3ewQb+giiJsRVCDRLUdnzmJ9ylWDX0arozmCwjnX+DsA05EgJ3qG/Mzj1ys3yqphm4I/VgPc59F7yY+bhXu2jm/mQSWKXlxV9LHPeIOjZAKP5EzWoiSlmorp/VXxcmxzPrSJAp6BTLqMHp+mTy/K/wyRYnQsf8AKuebhEyrqBv8mivU6d5kfywOIfuOmtyWMT8Aa0t++yOzCeQVtUUsqUArTRVtKDWo2pX7fXoAJ2dmVUhvDBUz4XCBPD7CSNiMGzFgdvNHsTHytsubt4PoBpcD4/xvmxMo5+FiHDGXthy6vgWzzAcLPH8D2uAM1niIaOj/Aa8jmkMcxYMS85XJhGRFAdldrHIUT0/045FjjlsJkS6ZHff4QGd9L/DKvGYHMgdVLJRKu828RyaX5FyJG9uInyskRLcq1zQC/GliTO0mxZPA59yXgSuTrtwVckWcE1/RvYRSG+8ysiYj/WkxMFXwjWSAlJfnJk28Kwm5IAS0fHxBhC6c+IZyPipjAb+VwmIdm3Rm6/p5G499tOeuww2wllb9V3O38zN0g3SxM8asP4xUjfokvF4tDG+K08kZcPjcAl8gfc8EmkjSLpkKQhJgzbRmyJzEFWdnsJW31gQC3lEslXEtJxpuN+sydAzKWsKhKKZF7A0An0m8utlsT+PgObC0lVlqGpxeNJZwmd9fWv7mC5QnkDVp62m7kwKhs+ghyhHaScPIZGoGyzaeCfH0ArdoUtyyCVFWyPeufgyov5BDmHgAa7xnbsV08CSagBiuKpEDf9oXYYvSTSvH+f5jIszlti2XeuCFFW/2a4WvFYS2asU1wYXdrlbbrbDOldYoSge24L4cmvrzu4Q2Q0hLCUBho/NprrdHRbXkBlGQeYM7xxw7s4rDg5c77fFOE58v88KwipbYocSyuI0ioPSSeWtz8wceAzFumAGQeyY5oqaWrp3Whe/Xi
 cT0JNu1q
 ZHEVt6zQZaiWN9FokPagoBQ9TykOehBhKwZa3nKmz7/WYor2qPO0uM5uljL68FgwYdaBBAJ+iwIcoB9/Fv7zXlgGmrP5WzzUd9BGufaSAA3HGMH4HEaB9scdatZDUybTFxSpVY3nY8vV/7Ap32qG/vYUPEU1sxX9za+WgP2CNqrASCWanBcKNeWqiTw7z8eFDVpuX7zIfvA8b6kGBrRLf1JNQBwGwtcMG0Br+Z3wWiHskkGoaMy8G1po6SqCfbcx/Ms7LzPHs5n9eoQTIxh/NzMImIBcZTgJqgfnnSCqE8QXqW9khgP4sDNEIBM1GFoB44/VZHDfzj7ghCA0ihkQxVbUzbrEtmMfth4TDc1tA+ixjchKipRAcz/S7nBgO6jP/pTnzDdcQeimPqitVv3yypUVqoeoRRFFfStTj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
we extend the 'huge=' option to allow any sized large folios for tmpfs,
which means tmpfs will allow getting a highest order hint based on the size
of write() and fallocate() paths, and then will try each allowable large order.

However, when the i915 driver allocates shmem memory, it doesn't provide hint
information about the size of the large folio to be allocated, resulting in
the inability to allocate PMD-sized shmem, which in turn affects GPU performance.

Patryk added:

: In my tests, the performance drop ranges from a few percent up to 13%
: in Unigine Superposition under heavy memory usage on the CPU Core Ultra
: 155H with the Xe 128 EU GPU.  Other users have reported performance
: impact up to 30% on certain workloads.  Please find more in the
: regressions reports:
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
:
: I believe the change should be backported to all active kernel branches
: after version 6.12.

To fix this issue, we can use the inode's size as a write size hint in
shmem_read_folio_gfp() to help allocate PMD-sized large folios.

Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Use inode size as the write size hint, per Hugh.
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 41eb4aa60be5..e1e5d5f7f58d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5989,8 +5989,8 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 	struct folio *folio;
 	int error;
 
-	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
-				    gfp, NULL, NULL);
+	error = shmem_get_folio_gfp(inode, index, i_size_read(inode),
+				    &folio, SGP_CACHE, gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 
-- 
2.43.5


