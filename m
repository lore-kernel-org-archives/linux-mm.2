Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53F0CF9C7A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F12B6B0028; Thu, 20 Nov 2025 13:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A756B0029; Thu, 20 Nov 2025 13:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC126B002A; Thu, 20 Nov 2025 13:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE566B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:42:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED45812F2F8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:46 +0000 (UTC)
X-FDA: 84131856732.08.CA02B55
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CCD1160013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJ1Uaf3x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763664165; a=rsa-sha256;
	cv=none;
	b=HQ6ZKRJhtRzLrmKYrwme79Yk8w2x1Iw8+mt4g4i1N0Ory6TtBWr+YCgXVqEwiLHOfL3Tv9
	cTPOiM1mdf28rDrDhacjd0ibTA2ZO52SUaCNvQp30hsO7aU/J+z6pmh9whnP4HYWf5LCDG
	1o/BfCp2Fvjj0PtkdfoJ6MWxFiOJ6H0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJ1Uaf3x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763664165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5IkkGmTBKtnq9MgWNqv3BWJfeeYyXZgIWDNQMVeTZQ=;
	b=Mfw022X25XX1n10hTXKy4h1vhcsVQ66c+TwktQWpUDzEp5lLncHqKp9fQjCjm4y5aGS4cD
	Us5lwljmxru4l/IfD7UCniABFeyWh1VKZ5cv1SsJ3V3XJdTM1CRG/w9YIxhI3/OIWalvEA
	wq4DVTujVVsypW+RdqxNheF1M0DJ6xI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so1573002b3a.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763664164; x=1764268964; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5IkkGmTBKtnq9MgWNqv3BWJfeeYyXZgIWDNQMVeTZQ=;
        b=JJ1Uaf3xFPigET5mI+jSEp16e7k6tWoJTP0dcYbxxjDrFBPHwscQtQGgIjMYrBb/Rf
         ajqS5qGO7xRjXje9Hbv/gROo1qbHrA8vbqE4x21EhO+DIsupuGc2JiciJc5cN3ALvGNE
         43lG8UJ6ITDdwBMK1pi2it3hjHFzjtKS/1PG0CLjllIOR8EHG6np2xq4qNdW7LsdZO6T
         dZ+QZZIoxvQeBmG3Ci0+cx4RBIMdGKN4qm7zrojfj8pzdSsZyFP2qYt4hVTKWnALIfzO
         B649IXluxCk9qlV0Ut0bnQhrwg6q7RAhpwWKkEcIfDz7yfYvgPaws3zzZMMU52CdwU5/
         sNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763664164; x=1764268964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z5IkkGmTBKtnq9MgWNqv3BWJfeeYyXZgIWDNQMVeTZQ=;
        b=GRt2SSPmJheHasisrrYUGK1GSrJ/lupwpYd4uO3Aby2yrVZdW8miwNkMv+64cCOrVs
         /T/Ll21Brz+kWrbMsPAHgb2qGm3Wci8h68/Pvwxhcx4wSsxD0bSDlzU5U6XoeF4h+Vyz
         QAviicqV/HCDSyitwZO4k8b0b5GxFTVpf2r3yIwgAFvPSNP77b7H2qK1nYIx9q+3GJvg
         QBsFZvXDdbsHPd1z7j+Hw20KpTWn4D+G0ndrpEERrx61fbBY8OLKzTShwhLIKpJ6Nk9q
         dd35xHuOHJsO0LWktE/3nwn21hXyT9eIfq6Q6442cw1P3aANW5yK0BrrSPca9l/DBLkH
         L4xg==
X-Forwarded-Encrypted: i=1; AJvYcCUCZNbU1j5iPZIJcZzUEXMECO+PUpDx1tv/XVANhBGPU0DvuZU2LGJjXNt0Utgv2XX3R4kTK9d5bQ==@kvack.org
X-Gm-Message-State: AOJu0YyJYpbT36r2kkXbv055GBR2WxQaO2kxyA84G/iwllepSSDW4SOt
	+yJAeHoSRElyfspY9gGBdDwMzmLQ6Aa6UisREVF+73eEtk7a/6bMSTUd
X-Gm-Gg: ASbGncuL8/3XQRyTTrql5rGlP5VEjRSYRgRP3912/wQSvJxZL45gK1vdNPStYJLuezb
	w6k8ajWFpKXnKrC1t+gkcvxfB7NmRdd5cma6avIaUMPEyxaPGNBwjc//h9lOeumTCDUnUBhaPIh
	TdBU1FC1VKxwHdk6RmXeyNYpAANo8/V5IMCobjei1sLoamOFQ/mb6UIR84h2k8gr/GJDVHLBJGA
	xiJBgJwI/iXxt+Yp15Fr3xINAlA9fZYf+KKxXdkT7ygX9vnFVRIxam2IplHJ55YBKhU8hOELXtU
	OQOGT3oA2wynlx4JHfsnKp9shl41Lpkaxi8dCOyQZLQMnJAkrCrwATPpga1buSMRDMy3dNNb88d
	mefDZDqfDzAJRM0R2A2UDfhTs4VSm/bq/KzNCNd5o4YroOzY6/iEXL5GUa3WRxKSNnNvndFGgsx
	FviO+inpNbHEomLqUf9tjG3HcPw3bu
X-Google-Smtp-Source: AGHT+IEn4fRMkobTZvL45tQ+snkxa4PzVhtyX4lkl507PdlHW0Dkqo+rP9vCwPWP+/AQsmyKFvZE4g==
X-Received: by 2002:a05:6a20:3d1a:b0:35b:b508:b99f with SMTP id adf61e73a8af0-36140a58348mr3931938637.1.1763664163860;
        Thu, 20 Nov 2025 10:42:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed892396sm3565435b3a.29.2025.11.20.10.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 10:42:42 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	linux-mm@kvack.org,
	shakeel.butt@linux.dev,
	athul.krishna.kr@protonmail.com,
	miklos@szeredi.hu,
	stable@vger.kernel.org
Subject: [PATCH v1 1/2] mm: rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to AS_WRITEBACK_MAY_HANG
Date: Thu, 20 Nov 2025 10:42:10 -0800
Message-ID: <20251120184211.2379439-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120184211.2379439-1-joannelkoong@gmail.com>
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CCD1160013
X-Stat-Signature: dy9wnbu5dj1cqo844yz394tiesnoew3s
X-HE-Tag: 1763664164-186068
X-HE-Meta: U2FsdGVkX192E+RCffNY733YiVTNKhNuaiLpDIHQWI4rJoj7dQ0zBlz238vAvsBHxheC0dKATPid1G3LR4TBCcu075uFH8Y8XKk5dcIg/UT7SXwJhOdmqbGddpfjjM+VJnOqGRzZ5V0mLZvCK+QkgNliL9C9hzA80Lmnk+2nOSlGjmXjOcrUb2Ch2oahTkqYLYsoOy67xhJ+REmtdrDLWq4ffTXdrhCVb/lzSuodGNn6ePPHubVeFQlgl4HyyfSjiNLI9wE9rB+GPRkbXWLUe8W4czkCi4tORTe2qBRh+GGlVg/36KjCbj6Ptp2tBscR8CTtGEKgyaoz8SdnevBWKrHvzW+ykhPRuPhzAK4awIUVNc6nEbpidIK/4qpkseGd6qvGzwvsaUsuIQCxhxpVlAXRK19apIpkcXd0rs7d3I3S/ZDlvbHamZeOmlVSYrEtGyjxobHUN7QKc1583dEh/MBGHIK37P5POeDkvsopDNKgT7pUoNP0aXvEbMCKO9Dh4enrGM9wJMXjbsdTFws3A+oX3drEyKcbymhOEF0TwIN0K1+T27Eo6/ApEmUqzyxUfwe5DA5PuReDiK7BCa3U7PNvB/9bK9ngn9G7Ox5SelAMRCg0I14lTmsVkDsW603rK+8lPJN1eB3KpKs9ovX88i0GZd3K4L8vpZWdytRfLQfwMJDIJYTaS1X4hQlYYcvUmXeUC/xAQdD5ZmTQ7d6Shxdy/IS5PpVhAAJObtMn7otkCVIcUy1g3sXcXpqd+Yht3cf3ZAe8B9gYxh0fqdG/64Hp7sh9q5Kvys5NSrH5z+kLM7zanTNdcSVt4v0QefNnW1BPgleGE9rrZ5C6cDQNaWMDYzmNEgbWfrot5iuHjQBWK6o/bkcVp4aEDrPohtA8hluZsksWnctiEZkjkmytFzoTWXI9YgdfF4LfQpwsJXGQhGPsvgmgRThSS00wJk3/zdmca9IdBJnd27E9Tea
 Cf//f+32
 ycfhZg3Yif6lN0KlJhdlNit+ZPf8wkM7KMwOJNKOt8r3TLBfrdiS5KRdYVhOzUkip5sZsC3lHGnLxRNFMGva5LGoH/bu2HVou5n322NsNsymuU35l8LhVpBMcFVNJKt+shzVYhVI6K9nLh7RzRzxP/LGPAI07cHIXHXR5XR7NdHg6RZNxzpqsHP8LG1jS948NglJ5dzegCF+PEC2IwKYJxLV5F6nudbokSCv48s+1nWvBF23onmLbdppnQgaXGIFbs2nem2HiQdXdezn697SlYwviUq8274xYTWEBFz7OOXkgpw1cdWIcCeu9xiyemejCIbuTwtldhkWFs4tWKFdVlUEl4aa8lmZZTeqO9ZjlmYph2Iwx8vzsiFiswk85aErE1kBNjrp8fzNX64eElL83/UDjlYEPw/CroXSf9mmVu/mXogb4qe7kssAITnhN4L0/hlATQgdFO4Z1QE9c5KF6uPjzp7skxYDAhIw0QZLNvT4nL62fsNPBlJMZtBoTT2i2MKUnkaEm+mdwbFoK4u7KLyw5CojhKKkaDLBY1aaiTYY738k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM was added to avoid waiting on
writeback during reclaim for inodes belonging to filesystems where
a) waiting on writeback in reclaim may lead to a deadlock or
b) a writeback request may never complete due to the nature of the
filesystem (unrelated to reclaim)

Rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to the more generic
AS_WRITEBACK_MAY_HANG to reflect mappings where writeback may hang where
the cause could be unrelated to reclaim.

This allows us to later use AS_WRITEBACK_MAY_HANG to mitigate other
scenarios such as possible hangs when sync waits on writeback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/file.c          |  2 +-
 include/linux/pagemap.h | 10 +++++-----
 mm/vmscan.c             |  3 +--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f1ef77a0be05..0804c832bcb7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3126,7 +3126,7 @@ void fuse_init_file_inode(struct inode *inode, unsigned int flags)
 	inode->i_fop = &fuse_file_operations;
 	inode->i_data.a_ops = &fuse_file_aops;
 	if (fc->writeback_cache)
-		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
+		mapping_set_writeback_may_hang(&inode->i_data);
 
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..a895d6b6aabb 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,7 +210,7 @@ enum mapping_flags {
 	AS_STABLE_WRITES = 7,	/* must wait for writeback before modifying
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
-	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_WRITEBACK_MAY_HANG = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
 	/* Bits 16-25 are used for FOLIO_ORDER */
@@ -338,14 +338,14 @@ static inline bool mapping_inaccessible(const struct address_space *mapping)
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
+static inline void mapping_set_writeback_may_hang(struct address_space *mapping)
 {
-	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
+	set_bit(AS_WRITEBACK_MAY_HANG, &mapping->flags);
 }
 
-static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct address_space *mapping)
+static inline bool mapping_writeback_may_hang(const struct address_space *mapping)
 {
-	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
+	return test_bit(AS_WRITEBACK_MAY_HANG, &mapping->flags);
 }
 
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92980b072121..636c18ee2b2c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1216,8 +1216,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			} else if (writeback_throttling_sane(sc) ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
-			    (mapping &&
-			     mapping_writeback_may_deadlock_on_reclaim(mapping))) {
+			    (mapping && mapping_writeback_may_hang(mapping))) {
 				/*
 				 * This is slightly racy -
 				 * folio_end_writeback() might have
-- 
2.47.3


