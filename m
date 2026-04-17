Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A605F8E4A1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8336B0005; Thu, 16 Apr 2026 23:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688E96B0089; Thu, 16 Apr 2026 23:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59ED26B008A; Thu, 16 Apr 2026 23:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482006B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:25:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6D86160A6C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:25:53 +0000 (UTC)
X-FDA: 84666608586.28.E1D65CA
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4CA9F140011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:25:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bVJTtvE2;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776396352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jIGmtfqQNV3WWdh9M42ndpoJ6WyORofupaAjImOgxKE=;
	b=mdgf48NsLICpTFPUwTwP00x9u18S9emrafZZlNzx43e9ePWQXKxM/YbiHccPmxWmByyqRf
	wdT8lh9qyvC1ziL5StDYWzIaWNc9t+12y2n56z9BTQmjKNTvXr2Ji4W889kZ3iKNr9TAwu
	JgbImpiMLY0wHCqdNs+ORFUqnbhOMMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776396352; a=rsa-sha256;
	cv=none;
	b=uwcY5E5fSvPHWMV8iCA0jHTItIjKvS2txFAhGO3ldmQ80Mg3r6Y+gi5sWaEFanWLSU6JS/
	xKaFvEr4qsnCWLvtUYdSipwwqDDIUTMjeyK1cYhTyLHkioM7h6F5ZyTqv7sPUVy6OJNyrG
	3wjiRwbB8+UxWlWeOYgBHN4hCvCrBd4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bVJTtvE2;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776396346; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jIGmtfqQNV3WWdh9M42ndpoJ6WyORofupaAjImOgxKE=;
	b=bVJTtvE2lTsUV4O+kHdHyo+GG/wQuoumBkuN5GHuPauRZbKKUsLSOvHA/jNPPAnpRouQ2fxOG/JQwJWBjfuv8qlD7+7MoLfQO1SVSQ9KpeczePn9cOV3Gw0COcW3LrRqxWGEQgARAc+eZUIhUvPRHF27oEChbPTxTx0UE/eJ1qo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X19y9nz_1776396345;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X19y9nz_1776396345 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 11:25:46 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm: shmem: always support large folios for internal shmem mount
Date: Fri, 17 Apr 2026 11:25:31 +0800
Message-ID: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jz9qe5uf3q4we4zutt1ahte4gbmq3g1t
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CA9F140011
X-Rspamd-Server: rspam05
X-HE-Tag: 1776396350-264270
X-HE-Meta: U2FsdGVkX18TMUTSLBJ5dSXpXegZfzhoSyM9LnAYNjFFhZUNUyHLU3dk1mNccHN5UNyuM49PsxsjSdXBX8+DszX740/hDICj0lNoWS0nHleWpL6A/Sk6iaZIDKuc861fT4LVR6a0L8v+eoVgD7Rey9p+lu1pA6ABMs1EXgfMsReBoBxmH1zYwB9WZOaysFGUxYQFXJxVCNQ3keS3EEezw38JPLKOgCAp6WjxDyCP4QT02SsVPH5gNYmswY0Xy6nYkWuEFuGRXi8Pf/kwI2fxcCGRmS4sCQx/V+EnucjzTd1L5GRLIRtJPjcrlibq52ODWvcjRcb2ITqSWCH6ocQCQFDHdpX0qTCqPLCxAc0Vi7p0hLC2H3MEG3jphDBCf6HNkwcJrpkvyZSFcnsJ2FuKZ+/Gy2ff/hlGsZUmLbWkHbtE/FNrcXAPWdZO2YabwwkCUa5mlO72wQiB8wZDVuJECn+JmlptCnJj4rppm1QcHnGIizjdBPq/wGEnzuTLFRo60FKQYB1U6dJRNXEL9DKHR3Jwleuiq2c0GmhZkPhbFCLQQ36OGN5R8Rrmrzv9GYw5bTjJt78/Un84CEYCKN0NWyCKtZlag+QDh+7UWsvFQNOE22hESsKniNm3RfeZAxfiLwwFq8vzBtkhoWrBW1dAvEORCQpcVoSUd1Wdacn0rPm7QQGqTEgya+07DE9kwj8K5+nl4rQrcDEQ1HouEHztUCBHIkJZtQKOptXFfaYhSJPeJRjWErZFIrwlS//NIM+1UCfpnw5rjEQkKHFWY9ohQ0lohT7nTW2XTImVyE/qjB+VsdZDJXD22u+p9H7P1sszEQ8bnD9gCiEvBjP/e59JlGe0T47kb31TttwpD+uDq0B+AbvTAPQK+pFJgtU6KTxG1RuN0XnDuZrdvB73QDOqrvu8xxMrrl2MU8LdMyE1iScraunaYZBtYUEPOH8OAmY1jd412/jtXWEkPjQGX/p
 6Mi9PYc1
 hMhs16M7n5tkCKi7ykEnMi68uhHMpRohmvmGHvsvML/mCoBsXowbcMGJng6wegG8fkNrcTqTs8GdV/hGkD3c+HUOjpswp5y5x9MOBNbbGq/4I2G8poV53Ys+4wY9OIt6C3olfAJFa+DmLHVgh/v0RY7C40uHwm0DpweQeA6E1i69T4DEHtuvIb7QRfOURy1niX2ry7MD+2edCT+ti2hsfqRUNXehGI/SNVvJvZjwn0uWz/ni2QgL5p1beN6mM6I7yAlHadFxOF0dRA08YVTomR8QNag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
determine whether the shmem mount supports large folios. However, for anonymous
shmem, whether it supports large folios can be dynamically configured via sysfs
interfaces, so setting or not setting mapping_set_large_folios() during initialization
cannot accurately reflect whether anonymous shmem actually supports large folios,
which has already caused some confusion[1].

As discussed with David[2], for anonymous shmem we can treat it as always potentially
having large folios. Therefore, always support large folios for the internal shmem
mount (e.g., anonymous shmem), and which large order allocations are allowed can be
configured dynamically via the 'shmem_enabled' interfaces.

[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
[2] https://lore.kernel.org/all/875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v2:
 - Always support large folios for internal shmem mount, per David.
Changes from v1:
 - Update the comments and commit message, per Lance.
---
 mm/shmem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..769ef37b1ea9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
 
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
+	/*
+	 * Always support large folios for the internal shmem mount (e.g.,
+	 * anonymous shmem), and which large order allocations are allowed
+	 * can be configured dynamically via the 'shmem_enabled' interfaces.
+	 *
+	 * For tmpfs, honour the 'huge=' mount option to determine whether
+	 * large folios are supported.
+	 *
+	 * Note: don't consider 'deny' for emergencies and 'force' for testing.
+	 */
+	if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
 		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
-- 
2.47.3


