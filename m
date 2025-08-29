Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0628CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204948E0012; Fri, 29 Aug 2025 19:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F0C8E0001; Fri, 29 Aug 2025 19:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009F38E0012; Fri, 29 Aug 2025 19:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D25948E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 920FBC0A01
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:06 +0000 (UTC)
X-FDA: 83831415612.02.9B49126
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA0874000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rq9dbPDC;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqkXwnI3JgfLupCk8pn/b3nuyLdeqqb8x+Tb7fP5PEI=;
	b=OAwITsxW/I/B/SBhF7fv2WSZl57TTIO444POtxAB+d64Ctwv49M5bk0LukPRsGQ+Ks6KNN
	obarfWKC4uzVjI8i/hf6KKvaDIChlDA4V3oxIefkdkonrER4/IrurTD5e9+mztLvYsR2HY
	W6m07MxLnP9VZJBlNLoZIX9ZHKNO4h8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rq9dbPDC;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510804; a=rsa-sha256;
	cv=none;
	b=o1sTfhhwqBXytWAkM2GAzS9b8ChzrZBs/qsBuRUdidGtRCl+XSPdsj4JsOh7H02zBBmz18
	trZbx8oOr6U3KEXeQtSIgGU6n8DaAyCOYYoBaKSLqeH8ihtrrHgTS+6DTj7Vwo4PJP6brV
	ZgW+kzuGcoAMZL/imAmVRzX/AcnVIvA=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-323267872f3so2353360a91.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510803; x=1757115603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqkXwnI3JgfLupCk8pn/b3nuyLdeqqb8x+Tb7fP5PEI=;
        b=Rq9dbPDCKTCJuckSOSeJlgEZkBF/EIeOh7o3ykowkFdAAZUE+K7Gr88T8VXIht/HL1
         Uj6zoecgGf0VLuWM8GPpIuFQoGo1b75z4iwfn+mARcd3ku8qBKqZapw773Da4DA/1PhB
         LEeQc5bfTjgvXlwuWeiwfxbCbO4pfx4hcSrl6VN4zDJ0IzUT5V9Y6i2kqy8pl3Nk3U4/
         cvbaHX9XxwtzpRMTARuxi7GpkaQM7uBVcHwH2spe4Rn+8WKqHMyC8c74YKax7erLm0SV
         /awHSVwBgj9YmiKMpKGbXRYmLdK24g/OvTcfSMGgjIAPX1bkb+9KGmzUKODwi0JjrEWw
         mQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510803; x=1757115603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqkXwnI3JgfLupCk8pn/b3nuyLdeqqb8x+Tb7fP5PEI=;
        b=YVRYUBeWWRXLD86BudzQk0KO5dyWMVrxFcSocqXzr5VK4kP7lRw4NmZdnQWE1Pf+xc
         E86D/NmQTh03W+dKnOa2z52d5pSnAtzrpld6hk3xP8oxBUkKm6f/tSne1LHaXz/P+L8O
         dkCyvTYJh2IhPFw3ztqL2856CNAv1XDZsamL1VIoDwXSv7/fG0RlhCbiox3mgJOxBcqr
         gx6oDGPhHz8yNYOdfdPKSLeaIoEX9dn75rCwAtC5xvmkPpZUEMmwFA5epxrHaO0MGefR
         csiO8QsbU0G6bD++k6h0dric4ycu9B94fjdF1fG+ypzqUxeVkSdc02ModAMCyzaNSah/
         c4Bw==
X-Gm-Message-State: AOJu0YzNT9o16us1kykKAMuvDL1Me3ANhMHEQVgBKGNF+KiggUBsrxkS
	w7Ls1gg2UtYvXs09MrxkoKnYnXA/ZoXr+q9y6uA/XSMktf9A50OjGuDPCbU3/w==
X-Gm-Gg: ASbGnctZNxLe8MFQAZuvgF6WZqpJlAVAw+1dG4jTxQcdRYX7F03NN7Y9hfoV9QgP3MS
	GD5WlQdSwLqHzEIQbZ3QP8mOHl6te5rR8yF1aBoWndjg2VxU3zwPCCx1UkI/qL9m48aBQmBpvnX
	bdgCNLpJsEDKGprhSP5zl1hO47rm1tlURw6tETTSiMdfzrKeJr4ygPYrGjHMUwxeArNAeHAOsUD
	ljRkEo4rHXwTzndB5nPFc8silGVM66iCRBmfV+3xg0xabICBrK7liBxU1P2ebRzTb/21OdXQrQX
	kKTcYgSyzXsQd/0h6me5ut3fIGlbUIV2nDR8f+eOVXYJ1DoVqDbnCWk+mTe/OqPN/RS4XNDnmQE
	k41UnHqLSnP7mNkM0nQ==
X-Google-Smtp-Source: AGHT+IEy5ad1gcp2NQjvD6GIoyd4Xk1IGsyA1OtBH8eJw+FIwHlx6V0pvax8TukX/YXSq6cGEXLrNA==
X-Received: by 2002:a17:90b:1a8f:b0:325:ce00:fcb4 with SMTP id 98e67ed59e1d1-328156e1719mr529443a91.31.1756510803321;
        Fri, 29 Aug 2025 16:40:03 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:57::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4ba1d8sm3509155b3a.51.2025.08.29.16.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:03 -0700 (PDT)
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
Subject: [PATCH v2 09/12] mm: add clear_dirty_for_io_stats() helper
Date: Fri, 29 Aug 2025 16:39:39 -0700
Message-ID: <20250829233942.3607248-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ki33qr7ysmgryt9m633kszmkimmfdqhf
X-Rspam-User: 
X-Rspamd-Queue-Id: BA0874000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756510804-527204
X-HE-Meta: U2FsdGVkX19r5yVFhQnrqwa+Fo2pGSVKeDPSc7wgKa5730aWzV38TekqRgTuy3FNMoXdw1+FxeUZKJ4PAX6I39F+mLVYa7CMevMx1gVWfNiUm9OH60guoirTBzsSHEJ5Rj3sNw6yz712ayhLcfeciKAcC/BvEf+7gDx/bPEr8H8T2SioAg4DR/UBmuwsdlhKB3+9RX7ezHwaxbBxEL4AqgFwW0KvMQQ/VP2qxOrHf2jy+oXgu3Ym0+DpkYuTO8++YtPM5xTDID7X+LTwfrUkqBbRxcTRW0STsgwu/gnQKDRF3KclTTaDKLKAr4K766XF9H1p3wjVDcY3h0vyuemOzWJvXgJ1CvPDYvjsUDvF0D/mIdfKe5UUTBy/6X50pGtQEjlg5DYRdl2G5miIerUTWNi22AGJqeuPBSV1+qj9odIdL2GwMmlJqvj28KCd8RXSQW7gQh1tDYR9ePw7bn6ZkhjyqR6VoHzuFWPxn/8+cJ8cYNu3CMeceLOJ60P1N9S2qNDX70JWE41t0jtpibhIcP1NDo7YQCxIgj1GI309iWhtPc7xpqZp0+pc7JVntpQWj0TcKawwi5bxDdvYOA4AfrWtv1FuffS05dAedHTYhppOLlLC0NIQC2qw7hDmsM4kznEjJUBMaKqHjeOnmKPd00oRgDATwZQfMqjBSyriSJYylc0m00va5nJg0AZiovVhtoPEDrbVig5wRwx4U2r2FTjQpnx3GlcpFJT2PFZ7tNnk3czsJl14Djv0u5DJoqTai08FFk86pQL9Z/+oRA1qvq9KoRke/OzFUNkghqV0m3GavRhE4ToWTX90q/bMQWYJQvF68HZBr78UlYsmdrXaFM8nR22ay0SE+ghUUbI9KvthTf1deQl7JMqnA0uLNPiVSiiMZvw37Xycx3ARvUph8X1LaRAsVqHN7jNbEQNDKzcwhSnlPN5Cfcpil/ZwcBjHPnBJoc0gwovuuJvF/rh
 9tBenoEM
 voAoj/xwKG8f7avjGRqxhWgAK02BRf9UWY6jklMDVk51yUqdHUkV7q+GcemK/SYWFtqfK3dWx0FCeoZQlubM+Lx01Dq59+hz6Xsp9JwHT4rP+sg0bF8cA9B4gpli0Jn2Txx+SrIaTDCf1X4X45KRCiUMW+H2D3nXz4S3AfPRVDD0ZhsuSjil/17CTbr5f3JtR9kvcp5IwhWDE87ylx/gPpKNvqFZ2vABFpABwS3hAsPIZYXDTz/o/Kp7awRNmqtAN90b5wqEepxfmJK8Ej99UC9d4BAOmp9emlIyleRue1IntEHev+RDcEtoPRrkzeBv7usdUNZtD0ybFrbty5Ikvxxu8X/riTk/78VD1NVvzvsm4bSWZP0FpdbiQgI/OlYlxKKniF+RsB2IUcMF2pHxQtQJ5LdI+fjbTDPCVeoW/gjisTtEkFTGugIz4QNBHbmM0CRvXVvaPdzkWkB3LcewfERnkUee42h2R6khIt7V4SP0U/hr3at/0xoR7DY8vdFBHYXCpJ8ea8nFSGV7yvxm1ydyizEEySCxvfU8MJ5z9X+HFpVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add clear_dirty_for_io_stats() which clears dirty stats corresponding to
a folio.

The main use case for this is for filesystems that implement granular
dirty writeback for large folios. This allows them (after setting the
wbc no_stats_accounting bitfield) to update dirty writeback stats only
for the pages in the folio that are written back instead of for the
entire folio, which helps enforce more accurate / less conservative
dirty page balancing.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f63a52b56dff..2ae0bea03d48 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -375,6 +375,7 @@ int write_cache_pages(struct address_space *mapping,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
+void clear_dirty_for_io_stats(struct folio *folio, long nr_pages);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e0410cfbe480..726da7611cce 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2709,6 +2709,22 @@ static void __clear_dirty_for_io_stats(struct folio *folio,
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr_pages);
 }
 
+void clear_dirty_for_io_stats(struct folio *folio, long nr_pages)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	struct bdi_writeback *wb;
+	struct wb_lock_cookie cookie = {};
+	struct inode *inode;
+
+	if (!mapping || !mapping_can_writeback(mapping))
+		return;
+
+	inode = mapping->host;
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	__clear_dirty_for_io_stats(folio, wb, nr_pages);
+	unlocked_inode_to_wb_end(inode, &cookie);
+}
+
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
-- 
2.47.3


