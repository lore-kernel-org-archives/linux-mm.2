Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09441C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71AF08E0003; Thu, 31 Jul 2025 20:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB498E0001; Thu, 31 Jul 2025 20:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC578E0003; Thu, 31 Jul 2025 20:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 395248E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 105AF1A0BEC
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:53 +0000 (UTC)
X-FDA: 83726300826.18.F05B30D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B241C000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hkbtdJ93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008071; a=rsa-sha256;
	cv=none;
	b=uupd2C0L/08GkzYENtCtIjatG6nb77D9sjPap8FfUnmz9ii7woc5+jpZV7n0Ve+2jaCLvg
	ZxDFad4ys/52BQra/u0tIqm89Te5dMv00Vs/OBEtjdYWUtI2BQ2M/1r823amv1UEz1DrsA
	bpq4DK9vWca6X9tj1JGbX+GwMrLrFGc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hkbtdJ93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYAnpVPSM3LLyQtjDYj5TRGoiDVKef8f89fRro6Pb9o=;
	b=1Nxt/EjdlwOWxoU7AKJEp9cjrTH69QxG8sqnlBX8lKVWhpvkV2EHyOYexBy6fvLvG8C8cV
	WmvgclIqWYRmtCkrM5LN4kpmHd6/uNuaG+yTjsIKCz3gnDpnovHJynySFfvvzqxQBAaWMR
	Ul17oZX2C5DpJ57vOIIY/ERy9+D18FY=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23fd3fe0d81so10441835ad.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008070; x=1754612870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYAnpVPSM3LLyQtjDYj5TRGoiDVKef8f89fRro6Pb9o=;
        b=hkbtdJ93PKPLVmM+EaX8UPUYQGid0TUsGmIZ/V4lwrJUQOZSqP1nN0CN+WhUMUchmi
         dJ4M6eDpsuwqYxDSgSCmiL5iOHeYu2M8RHoH04BxWs94MCfQKqcn2JVAW6DwoQ0jkG+z
         zoVVqs/1Rz/XFHXceYAyHQ1w1cqwLFtyaSbXiZSmb5+QYc4D2qRntm6c94oCTSllwaQe
         FMIflVer9Snqufzr1O6sDEtMzim1CEg1oYSmheMWF3r0VPTFsTdeEIbhtARyjgQomIEP
         icB21xTj3GospprW494j5VX6BZiLjAvVISkuQqseQ6JTbzPsKsH+V3idlV5HvV5jy/Xg
         K35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008070; x=1754612870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYAnpVPSM3LLyQtjDYj5TRGoiDVKef8f89fRro6Pb9o=;
        b=FEbqQf2kD0roBfuuC2eT+oJTBv99D9L1Dzg718omoRSWK7ILkJc/ZPMJdhSWAMGcLm
         h3d8KPWlD2LBrXCkZiBLN1W0piHqR1OmIMwNzRvorhnPG50LjypXuElpK27aJNM/Z/Pd
         OgMrFO86YgRffcrbFRaOGKzVeEcd2PS00MAw0YhayEdga7wBmvHQ90J6BNQpx3uJa7gx
         IWBIAGjsgTSImHqcz0pTkdOLZinnA2wGTz4N4uFYRxqTTXhsyPb9ImmOqATOgDrUBoap
         JqExLeHtY4kqnkDRsNQwlYN5EekgTXyVAz2oqDgqK2lw7s2seUi8lBDoV+Bs66NMhtVc
         yDFQ==
X-Gm-Message-State: AOJu0YyHmo2mD7/ucSyw0OX4+JNtxJxN7N5vunoXALZXmTJfUaFdcTQf
	M+3f9Um5Vr6JWVpBgGDEPIiovcYguHNmorImHrcu+j4IQkr1klktU22iuKsspw==
X-Gm-Gg: ASbGncvT/l4dSc2FriHhXnxutfArWWfuXeQlTDIkrdWUKReW6/3z6iIGEC0LMtUZxFR
	tJT/4WFcjjPXz/br3HtUPIlgpfWyh1gVXt0fHDJ9025tpAjgRolbC1KgdO5AC2T1MHpghlgv3iJ
	sO0Urg+jqmcBb2F96kNnmFF3kfeVSkiSEyp08AJ2iuK9pGSITk7eYunnH+7XjpAa2dlwjhW1Xre
	IHiHFt/WlqTadGbrgdsdRsPrIM64UrwGKS8335YPe+3RleOlnDATUM4/jqHfim06pT/PIvPAed4
	i3v12ir/cvHo6B1RK91YFKEHLFHroICA8nha+rVfJzgztbrP6mWeUxi+5649P/3GEOYjgEzJmgE
	BHB61wh8TzRLGhfeQ
X-Google-Smtp-Source: AGHT+IHkgrfXMOK7E9hIh8oKAzasFFpQtlF6FHk/9SufKadLPTcGomsVFWYRnOkmWX9ISV04zDo81g==
X-Received: by 2002:a17:902:d492:b0:240:99d8:84 with SMTP id d9443c01a7336-2422a6d83f8mr8597165ad.52.1754008069628;
        Thu, 31 Jul 2025 17:27:49 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0e81dsm28321855ad.46.2025.07.31.17.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:49 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 06/10] mm: add __folio_clear_dirty_for_io() helper
Date: Thu, 31 Jul 2025 17:21:27 -0700
Message-ID: <20250801002131.255068-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B241C000A
X-Stat-Signature: hmh1jz3xb87g1aykrb4snm7g44ac865g
X-Rspam-User: 
X-HE-Tag: 1754008070-738539
X-HE-Meta: U2FsdGVkX1+nmXzRKuNjS2ijqQ4NrMMo1u2UHQTSc6Inxf6WG0xO5OLI3aArAfB6ABx9ftEKzjFQuc3phnqigNmvEoZF+VJM6SudNcZa+1F1lqgcQgjzus/l+cB9n13+4n/Glc0RlJLTnnDCsOk61K+ACLY4hSGBx6zWnefTIyAwE28plg9/0PCIzyA0377oW1P6dHMLPDzUEBGftpYCmssiopoMKZDZydpReQbb9VWBCVf9z7+91OvWv5JCIZsgAsgFjmP8tK+ATsx8MoGjAQN+JdsNvKr+ByGY2u7oGQQ/QCkkEcH1EnmJpTE07+Y4Shxx65Rrv+IObsVdtbFtn+rcg36LtmpocQ9mfnRdUj5nIc2q9kCjKidRNKzprPr+Attx4IL+UGyPY++0IgLOcoe4ES8QD/AeIcoIydl6pO+phZyipah2r60VH/1Ao+HOr6+yW63Ks/RZKRElnyVC/PGTsvtgMsKY8q8l+AcCeMiydABTlvRXWfdi9U8ENGnqLQLYouH6ormpZqWR59NwlaogB9dkz2JEJIsM3D9Em+ucbS28hFn1JOzv7u/SfnidOcGn3HBH8HTyWSOpJMRm+tWhuXlRiHGuu50KoDmmrGELxTsKlGBRn4cXQisqqeHupt0WGP7tssoEfhKRqO0ALYlEHct1iCIbos/nLMCobhbBhRRSZCCYpXmzkw+DrAQ9ZEUWIoD93RCmW/1v899v5I/MrI3Mlrx3JyhlCXwwbetT8WRj1V6eWsXyHCzSUfjJh5+H/anPcz8IaNRf/G3qtLfNAL8ISg03VJQtV0FufL2LSHiWQx2TraEWA1BJ+KC3pVycMCOrjWdVud6ctdeO22fEjhpoIHXJHVUUxcBHLSSprIrDrELuX83OowyeF6sZU/KNzgivlFsduKWZdscunpneSUXWFtsV8/uWXpWyPKl9nzjF4N1xbDdhQm/+JSuZmZwe8no0OW1woHqbm14
 DP+AIgjq
 JSG8BqExioac5jObIp5UyM5oYWlLoTrzcU23tKVbuxd+pBGU4Omb34SbcnfB6uJtHDZhMgmB0kcZTziS3fNSdP45w1ajhC3OyrhcMcZS+7DhotzDPiXr3hQuM4sIT/Y58fI23bAEEQQjkSAX8k9pRThh/7tUQqAOWsCv0SzXnvyAgBQE8lBBFMJcKTw6HohvbGs0Ry+IlbGr2Un5NoEfqqJqnhA94rcNIP/yqvwAbR1V998bfCcmGC4NiGOZnqTUWD41pTbtU44SSRmZuOaJOi91Og50UpvxAEQSW6Lu9/Hi0tVrKGhLwxhww+LQQLQLvp5LKPJDo9PZ/A0KKrEmJGj+eF+i0WdCz4CvqvqnexiRbsC6pAal5FOd1yaiMEF/XQjDzry/U+H5FcmboURR5bX/PjTZOiOCoWKA9BHSQmP77RT2zMa8gf8FmZgwnlzciYbt2Q62ntaB2ElWiCNnfV+rOQXmdFyXVd5+D6nLMdLFcQdbBBTynuq60TdsFPepemsPf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add __folio_clear_dirty_for_io() which takes in an arg for whether the
folio and wb stats should be updated as part of the call or not.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/page-writeback.c | 47 +++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a3805988f3ad..77a46bf8052f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2927,21 +2927,7 @@ void __folio_cancel_dirty(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_cancel_dirty);
 
-/*
- * Clear a folio's dirty flag, while caring for dirty memory accounting.
- * Returns true if the folio was previously dirty.
- *
- * This is for preparing to put the folio under writeout.  We leave
- * the folio tagged as dirty in the xarray so that a concurrent
- * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
- * The ->writepage implementation will run either folio_start_writeback()
- * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
- * and xarray dirty tag back into sync.
- *
- * This incoherency between the folio's dirty flag and xarray tag is
- * unfortunate, but it only exists while the folio is locked.
- */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -2990,10 +2976,14 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
-			long nr = folio_nr_pages(folio);
-			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			if (update_stats) {
+				long nr = folio_nr_pages(folio);
+				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY,
+						      -nr);
+				zone_stat_mod_folio(folio,
+						    NR_ZONE_WRITE_PENDING, -nr);
+				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			}
 			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
@@ -3001,6 +2991,25 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+/*
+ * Clear a folio's dirty flag, while caring for dirty memory accounting.
+ * Returns true if the folio was previously dirty.
+ *
+ * This is for preparing to put the folio under writeout.  We leave
+ * the folio tagged as dirty in the xarray so that a concurrent
+ * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
+ * The ->writepage implementation will run either folio_start_writeback()
+ * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
+ * and xarray dirty tag back into sync.
+ *
+ * This incoherency between the folio's dirty flag and xarray tag is
+ * unfortunate, but it only exists while the folio is locked.
+ */
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.47.3


