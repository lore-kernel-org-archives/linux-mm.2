Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4354ECC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 22:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4021C6B0092; Wed, 14 Oct 2026 18:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8E66B0095; Wed, 14 Oct 2026 18:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2799D6B0096; Wed, 14 Oct 2026 18:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F21AE6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 737CDC083A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:06 +0000 (UTC)
X-FDA: 85322663412.23.5E1011D
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id AFE2640009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vDSoCgDO;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792016704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te98JzwkVTzNC8wlHAwz+oxIJRYlTan8LuvBBWzhlSc=;
	b=YPmtuJe5Nu3rF89F8QwGhlyDURBTCPFcfLArbJ5c1Q95sQ0u0qPC8IujCb8H1Z4WxS2lZ7
	CJVzpeBtWtwZ622jEk0I/eJFX/GKuPGNGSTOkX9KXPhSei6zM+Kmof6XhiQ1aIY15BaVtj
	0ronRURkNaR6t8zokPcK4opJjIszUtU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vDSoCgDO;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792016704;
	b=tyBCyQEdNP3l+mzE8Qrt6pazB3mQOSW8P0Xsn96PCmopWTHvAhJ3NOluHawlWSDseEzCBo
	BVUP3OOn9ftePyonBzXQwvysFVmBZYvq8wReTUcdu19hk1pScmkLLiurDKggruz2Za6gRN
	zt7WPgZ1IrPLs53SFLfhVoZN9w14wjY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53391022dc0so52212701cf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016704; x=1792621504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=te98JzwkVTzNC8wlHAwz+oxIJRYlTan8LuvBBWzhlSc=;
        b=vDSoCgDOHZ3k3ElhrE59ZSaIucIMa6s/yq0DcY/mv3fqokARH0ctxm4+/cRVDQXWCR
         N6b5e8t3n/ekkxEMiFk9ha3uAJaweS+ScHfsSTdyyLQ7rMI+QFaqThBoKMlwQqD4RnDT
         tcsxLv7fz8s3RZkoPxEKSWN/uMKX6qn7pqWhVbhidq3AS/tiYAheGW/5Th4IOy/XiPsu
         e/8D7xV+G0fvu2MlcUK5WvOTucbFAw5LO3K2FLEVKyr5BgMUfGS2gdNeAG0vRt9nYcBo
         T7vU8iQNBvEtblBMS/mEsIWjzYWrmULXNH5V7JTFTUDT/WVNK3GCc8gFMDH+8k+OZKQy
         7VdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016704; x=1792621504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=te98JzwkVTzNC8wlHAwz+oxIJRYlTan8LuvBBWzhlSc=;
        b=o94MHCUZcJSOby8Gzt4PcqUPr+c0mVeVBBEZwFJO8T9q2mEqZvIIrQ3o8eJBIkF0Km
         secyjH3SHEzZ3WqbzIF3UgDdeaa7nOnVY7Xhldfe+nMfAp8l9mHwEIURUwnAxitWB4xZ
         Nqtvwl5xHmb74ENT7QB3B7dTbyrTHx66om6d4stJSjFe1Poeq+dP3otwxO7xbM2iF6rg
         FsgvzqbmZGniqF1IfcWB1QialCZJvkUTOKXd4PWb2sRz9LEm/9USvPOm7VuWrHOkttZ3
         stZQ6Q9p6QNDAq3+sDCQAoVetesNGjpI9IYztZy2WACD3YhFiL1ZrCuQS2G30VmXmKFk
         CTgw==
X-Gm-Message-State: AFq9FYI9fW1aj0L4grxqd450g9qQlkhszJNegVSjE6TLE0eFtearaWDS
	3C0ze86Eoqj/4Qu7GTejVfrneNg4Beh4R6eItxsrOkPk5WCIoaUEt6jk66pxQZPyj//75q6Zro5
	OVstOQsc=
X-Gm-Gg: AYBFou1lrsQDMsPsWZvdqIlWG4cpc48iTm/mCvBS//JCN+uQ7s/JFlEIB0SBx1QBCav
	2zcRSta3poRDFMhvNrGlSccZSggQ44vHyhz3VegQ08hZaqxeVlfhItP3Z4H09V8ymppiLkojR06
	xHMWvP82ZNiAaovXPLVtZSNiUylBMb4EiBdF5Yrb8HeDuu9rgbViy5knXJ0phW+3yxK33xTBZIT
	aXem+JqqIrDKYOXxmOkEzicBaiKDCDiOLKwEwpNOqYqNRfKg3t3iQDHsJq7Obd9BhjtIiX8u7Sq
	xAvp+ydBI58107fIXIuq0GOl6u59CkHFFYyzNgkH0BQcVfUxEjablQbaW5x79Wmms6N1up2ixUN
	wvbnfG4vsBPxcZMX7G65l+8hG+6PHGqLPSHc81flgcd604mD96kv7NVTzsYNQQ+O0euOCOj7+JZ
	8scX+mLbFLyAUVE2jXoHnM/BqPij4KzsOMIv41fRrEz5M/CNMz1XPbUosu/chQrXoPxjM7tSy4q
	zk3MQWX6PYTiB8+PX+385jIQNsasVZ4siRLh8G2NGLi9oj50f7JYPq4TITPuA==
X-Received: by 2002:a05:622a:1ba0:b0:535:36d:dd8a with SMTP id d75a77b69052e-5359fb5bfe9mr296527481cf.36.1792016703841;
        Wed, 14 Oct 2026 15:25:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:02 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 1/2] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 14 Oct 2026 18:24:55 -0400
Message-ID: <20261014222456.2318284-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>
References: <20261014222456.2318284-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AFE2640009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 8zkmhh5so171y6i4hfm55iwanw68r7xh
X-HE-Tag: 1792016704-977959
X-HE-Meta: U2FsdGVkX19HJ6m9k9MvZL2alfuJ8eiAAwFHwcmnbkJ52T9aQ9+uB1iRg9KVkKMETdbmu0pk8IiD0MhhVYz/cXJMfVjzxN3IW6OKnnIFZt3FyFKFMIW6p4XWG9K+yZcBn7t8L7rRDoC7SR7Ak77e5LeUdQEOVNqEkTxn20O/yIqDMKaHGEh6ik3BttQuBmXjYtQtStsAgn4FVcH8BqwEQQxyX74Azt7U+MLLUW982xiRUXAvCHgA+4YTe0vwRqhRwAIboaRmFDwGG6YgCcgWeNjn8pyaY1nHGwlRYghs1nY+BiUN2Ww0eXfHWvTMxOlsApJbA3HjteuEFKJoHik2Tuot4PatEyJL+Q6yjlqt5ji7UhSUqIHLW9nAUvP76mM8rjT36i7msIYQRbFmuCevtSO0Cbiuc2gzk99vZVCXfPGpF9c0t5cgL1wAK+l2lsMGt/3ffN4ixYe0mSq0RXAhetYjdyv/4vWuKU7cf6R2JEqX755ZKlwSQkpboljomPRyGKuuenLHQMEdn6/lkxgN5imQC+tSk00+VUOiwK9/NVciMJSdbiQL4ZwtGfMs6e67i5B/1SOHg5YgPis9GCYgWuZcsHOB7Ps6hlCWP2Gp3lYsZxPRnfoESeuCdNTXCV90FgiKIcwz2pVkJ7gbEXe2d2bJ3J1wNtiB+4FqR6q7N/avUnspT2uyHByd1R8sYXN+kdLjBIBnWlllJ7l63DxigeNiMh91E0jEgU0ZguSg625tpmspN9yjyVnK51nHdlCsP1sCS5skHP9jL4H+VtK/zL3lY/x55SA7C3BndyJNeQob0WKInSacD1sFptSrdP6C4hVN83JeKMEHlO26MmdNNVOHtBfm8JAbsojWAWLRjI8lgD+wn7q1xCsz0s9vioZPHmJJZiUiw+c0d0RP0t0dK6//5DDWEiN7+n9X2qqYgyozMYwBgtCJKvZEDdcPiPYyOnhN2AttLxag/vCF6Kg
 kfy6Pzq+
 6tnCUAvly0bX12YbOJrqXXC3PKniaSP2Obi2x577vIBwhn2KXMpXqaOlZRaOoujoOUkZ/DmMRdinal1M029huK009EVuwBUZ5FBux6JF4jSEB2mxa76HAAZPc+aMpCp0xQmIkmNw2XFcWIvA6Uy3wEn/KngfyboQq7Uc8/tPBdia2p667Da6suBrX+0S1YkZ4sw2y4LNQ9TEu6zDUTm88Ag0Hocam+79ax6gHYKUSevNFcC3u6Pre6aLCKwjnmdcBOYUMN6IBgMQSsGr9OHVlqwggFfJk0qy78sezpas35PsJus3AdQDoiaDCnqkCqu1i2UngyLu4isynmcz/9jWb2FHR/hGN5V4JlEBI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7682aecc2c075..81db19f2ab551 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4425,7 +4425,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4433,7 +4433,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.53.0-Meta


