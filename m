Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 046E0CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C41A8E0011; Fri, 29 Aug 2025 19:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E818E0001; Fri, 29 Aug 2025 19:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF718E0011; Fri, 29 Aug 2025 19:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 076898E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D68041A09BE
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:04 +0000 (UTC)
X-FDA: 83831415528.18.16A2D02
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C9CF1C0009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y9+2wa/9";
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDOVsGW/zxQGKiK09vhXrIhDtQw5LWrjTXPZUwXjB7M=;
	b=hDss9imqv0o0AeTAj3o8CZ5KLWth9aB7WxfJZ36ey97p7Up0eRzDJ7PxXNGsuv2mKVQ5kg
	hSUTRQZgXZVwMTNLPhHQJMzUEXu9ZHT8UjLBBkdRoVZd2PQ7RjvRO8JEywiTh/NwPzQdFr
	cebPDCRhzR+IqTFZ0NMyzHIiEMSkPMQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y9+2wa/9";
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510803; a=rsa-sha256;
	cv=none;
	b=z8N4I1XnEkZXKH22XwLMlZQCy0QYJ5DkM2XikFB8Xf/5peRhEdFGn/DTy8tftVZNwR76Rp
	J/BlQdzswhIG6753nW4uWhmdXRtMF5CNetauU1K/GM873tuiRFJpv53VH+380JTgEi26W/
	NLWWGKRSgtZzrSXQPEIz1kCHRfHSUNI=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-248de53d12dso15377215ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510802; x=1757115602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDOVsGW/zxQGKiK09vhXrIhDtQw5LWrjTXPZUwXjB7M=;
        b=Y9+2wa/9CxV2CazdXcRAsaet6Jus6CpW9vKgRoAyvnrYf5t81NaPpjScmuKeO7xaOH
         woi7nMQ2vnyqM7tO/XDCsddBhhytN2pRz8eotTkwMSiEkUjDthudl5ezzsevTxtmLzS+
         R/Hp6jfCO4XUZmDLPr3P0yTaEH17FrcY1K5NuSkmVcUgO5JdXODpGBtmOJ99EA7wJdM/
         6XWTJDITZOYSkwFVSOD6CKuPbSTZHypQH/OgkvzMzRh/tuvcANe4MV9J35jARpBvex8Z
         5/9O7OnnpRD/0Hk86wR5fl6Y8lHGHorO9RdCbnD/xBU65mRgT06e2oPR09nNIFOZd5f2
         9Heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510802; x=1757115602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDOVsGW/zxQGKiK09vhXrIhDtQw5LWrjTXPZUwXjB7M=;
        b=RhE//ksPovENXMf8kmHun0LTBJcDlZzVpklVnCHLbzLu4YBmaZU4NQejQWywV1bMml
         XxUFaG1fnvcW++c5jdu1dGPLV6SONfIF6xBmltx276HtJjmC2VEWzN3+yhKJ8yZFVFgB
         nNSBphQCt8F+lgzivI8ZY5wQWRouIlGBaNULwowFk5KEVznKUeQLXGWZ3IDlYXMD6gpz
         BAr5cm0UD1wbssKRC1Xfd07gaeSQL1TDhU1qJsmm+352rHE4DHs5+Kq7GlSpgMjJPW3w
         uRtvfWrMkm+3m20VHoNxUp3uSQ/GCMzf1AT5DzibeVYQ3H/R0FyzcIU5KjRgv89XWQFn
         ZD0Q==
X-Gm-Message-State: AOJu0YxydsYNt2CQPVqLZLMeNywT9ZVanC5ph4efXu2w1W9i9za+dG4P
	NrgrxB6ecJazpo3L3rbJysYHxJqCWmbQ6Ho0eZp0x9f0fZ8su1VpWwVRIIi1cg==
X-Gm-Gg: ASbGncvylOA9MUg8dD41lRMs1R3rZM+/6L1SQPZTOcovddS5ygKjZB6n8DLapb240Vk
	Q4g/XsmIeG8Il3sF2E/D+4oUDMWOZfw/AxmY+imbBRA7ADxliC63RuOTsUoiik3i0y6E6gqb8og
	svUjWh3lJJfLk2UFnVTWmef/h4F+q/mdHEQlJk6aJSUoITbGI483m1KkgMrVVRDH8AyCzvXu7i3
	S0UdFbPJsiVxY8X4TcXvb2ltzVbhgZtm56KEllT9yCMpd9Lbab5VHaTo0j9S2h5bdnUkUXp9QfA
	6F6Nw/dfKBSYOX3tVUzCp0aEgHxA9pzfZQ4siZzJJpKETsSlISwf7mjIpbYKtVnahSmHaIv5Mva
	NYOsK4geaeGMaxL8scw==
X-Google-Smtp-Source: AGHT+IEbyQ6GiY2kX+wUqgiABadDR1yhCyF2V3uBRHeeHLqCYES9oeoO+QyBVv/mT87GxNG57KKBQA==
X-Received: by 2002:a17:902:d4cb:b0:249:3049:9748 with SMTP id d9443c01a7336-24944a98207mr4524235ad.35.1756510801830;
        Fri, 29 Aug 2025 16:40:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5c::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903704379sm36315105ad.29.2025.08.29.16.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:01 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 08/12] mm: refactor clearing dirty stats into helper function
Date: Fri, 29 Aug 2025 16:39:38 -0700
Message-ID: <20250829233942.3607248-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uf4zjwhgsae4kuqdgoywoaqxrci9u3yz
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C9CF1C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756510802-641667
X-HE-Meta: U2FsdGVkX1945SAu7IuNNeaku46m9uf/ruva+QiLr83RYm8PTQB8eGjfxc71IwnmobHi4qTPIGkcE4D3YRQ1bHFrlAbRhFbfh8r+EToP53VRZ8wGsWNydh35Ic1ccHt8tHzsYkkH3ROBgkvDHwwDtwnO0bT+8iW/jywkTgI5AJyWGF5QBjtSNvD3dL0D6NzEI+u9E94rtGJFXjxSVaaPFf4vtRB20d4ABuwlk6REOlkOGJ5rW3KwknVS2CajNfwbfGSuVzAUaUeeN7NvETqI33exYiZK4X93/TkVTJD2XRccV+aDGA2JyvoiBXSRN7TPaLUHUWGEbFBz2JZ6EhxERtlOS46r1PLaXg5udj/gWVwMA7fEfn2RZjZSwe0kPBAy9F8DCAS2DEF+rvbOv1VJF8Pu68LqZguCA+ErJri4VjH7GbYwWgJDZ8T6YO+n1atDrGnGZ1AysusxD+Ieg2z6AfMlKlv2MxBQdJ5zCB/xkOq5Dae5JjPmlsbZPNWq/3mRmxTHXvnYvsdn8jdfL1zbs4EIa6ul4wA38nlpd4JhKeCDLAJhhn1sOydf3q3G0daR/8ez05BhsnVtsZwbYAUuDwiyheCl/7GMU4k8IHoN0ldUHZ0ThYl5ct1LJ2pYUJSle7deIp1kQbTvs/UP1ndg1AKkbKKRnuQdIosrO8i/MvVaKJX5QZFnmSKM/7aK3GyJpbc8NlNpFqhX6duv1nl0UUYFp/L7ny5KxiOyYSUYZaSegQGBuUeYliddKWh7f7cSstmqlHdsRgU8uROHkv3AIQpFzRmHD+RRZlUjmGxGQTDK/lfqDj1BktAqu8kYanvvV4XfjedKWEwQpVmoByHsnq2pF54hzOTzquvdMoPoq1+Si2qWzHYufvZ3y5D+atXMi3zkyNCwXy5e5h/oGMNZjPAW7x5EvwHcv1ibySsQEuj0Z4tsaMVbbuPwWjawWQlKZrA/5ad5P3Fcb59MS9Q
 tPFCUgPd
 m6mHKWeMDhEed2WQiW4UPmEZ0AHeCFNSZAIk86BwI28IGIHaWcRo9xiUNpOUuHottCR29k8xrfjXdkyFAsvBPT9NnaGfafmKBmDkIHpcDmia61xQJqOoK8gXojWMP5DNmPXns4xc1eUUvpTvtJpvBsWvs0GqBSXWCSEv/zqqVEK96NaU5wFZrH1nih3B5ypMa2j82ZHTbxeOzLFg8NpfHp7QrXDan9CxuidhXIIvomwmkjNkipYJlgsTPVR3XrWV29eL1M8dE1lxw2E9fNiixoZ7i0uLAfR86BRCvyUn4Wty7nXMC62LOxOtRv2SD3Hs7yyiQhekJ4k4IgmvhsbWz+cTMW1vxfCdsIexI4fFULpBKzFbvxhjJcwDtHJkTxllTuhspjqaZbjFG0xkNYl3XrJVfEHJl6nFG12MIrKQ44Gniyujh+vBKy1dfBVfO++LcYn3JcrlaunEfGyz05tehU2QbQR5Knv1dPatB5sf8xTIFDEu2bp7cAfeata30OxTpljp7E/Qg7QPYJ4A14LbTZ845og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move logic for clearing dirty stats into a helper function
both folio_account_cleaned() and __folio_clear_dirty_for_io() invoke.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 mm/page-writeback.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 294339887e55..e0410cfbe480 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2701,6 +2701,14 @@ static void folio_account_dirtied(struct folio *folio,
 	}
 }
 
+static void __clear_dirty_for_io_stats(struct folio *folio,
+			struct bdi_writeback *wb, long nr_pages)
+{
+	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr_pages);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr_pages);
+	wb_stat_mod(wb, WB_RECLAIMABLE, -nr_pages);
+}
+
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
@@ -2709,9 +2717,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
 	long nr = folio_nr_pages(folio);
 
-	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+	__clear_dirty_for_io_stats(folio, wb, nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
 }
 
@@ -3005,14 +3011,9 @@ static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats)
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
-			if (update_stats) {
-				long nr = folio_nr_pages(folio);
-				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY,
-						      -nr);
-				zone_stat_mod_folio(folio,
-						    NR_ZONE_WRITE_PENDING, -nr);
-				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
-			}
+			if (update_stats)
+				__clear_dirty_for_io_stats(folio, wb,
+						folio_nr_pages(folio));
 			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
-- 
2.47.3


