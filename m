Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5C5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D85E8E0006; Thu, 31 Jul 2025 20:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288058E0001; Thu, 31 Jul 2025 20:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E958E0006; Thu, 31 Jul 2025 20:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F29E08E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC575135591
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:55 +0000 (UTC)
X-FDA: 83726300910.15.99B70BE
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8F9DC000F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqPaihh4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008074; a=rsa-sha256;
	cv=none;
	b=OzQH5BJvq3ng5JPj+3fkm/omcvp0I8tL5J+wV17iQ+H0OBBNtgw8RNF3KmSKu4dd2vCKQk
	CkvuHir1kVQK6bjG4FpLYDvzbqPrK+qPlsjNtLW25FlGWRZU7BjclKqfCiGtE3+4Oirs7B
	GtdCzchN5ksie5hzUOu+FwzO4mRHYLg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqPaihh4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deo2OGow1Yj8aDDN9/GvEalIjvbT4uSvY5E9OiEOryI=;
	b=dOTJ7TysONtsxXlTllG8x5Zrp56bTzmIEciZ8ACgBbzp538tG4/EMDb6m7mtmVoVswdcwg
	Nd20D3qtVmAIrdBNGePYG9O4PJRQBgaHJorYIxsIYKEyApIx2PVTcjbsm7H6IIzG6FjEE7
	KuBPq/R4A1rcmeLCcQGxIhpIbrJzz2Y=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23dc5bcf49eso22127775ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008073; x=1754612873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=deo2OGow1Yj8aDDN9/GvEalIjvbT4uSvY5E9OiEOryI=;
        b=HqPaihh4tUziX+aeZYNI9MV+70UJN+gX4U8JSMAKFh64JFKfFchodbyaCEl6sACntV
         G5I620j+ESAa+dqyvEeCzYW5D45ud/RWmMAtewG/FG5I5W0rbYcPZbDp1lNN1sZUhKdX
         WdMHOHjUyWmDVuRlrEeqVqZTXvUmUGNmqIBh0aYdT3KVSnAma4qjV0YnOsWLPvt1BA5i
         TcDYBL3LrBIUYcUE2fC4Z85pxzWbEcZn3zSSPOsmbsswFgeCGOPatDuTe3ASHkYRC7x1
         /JLLJxptzHpvooI3eH3uM0y1Ct8ChbDoxbkG/+bD/0kdJPp/ppjPSEoueBuNaQavn8ET
         8mWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008073; x=1754612873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deo2OGow1Yj8aDDN9/GvEalIjvbT4uSvY5E9OiEOryI=;
        b=mO+k3MBwaK+Phk03+lgkJoO9Dh9u28HaOuXLtuyYyiP8yxOLntQYamXv5B4cbCbV9T
         seC317r1mYFK2GbyaLO3n5yNm99XeHENzSFwg8n/vEoZLEHiXuV1tqPGcjSk+t3Iwm6P
         ey7ubMmIJgDmNLUUMC/17xlrrqYF9yeKBKuy1TW7ArHYjv4lUP6uaklLDiogv0Hqg3Xi
         lq5xGroREcpIHWREwWpldmKcp5WXSQSJzjgNL4jtlgHm6Aw5/wMc+EeAe+w6holwjvsc
         AnkcIz90xIlJYaEIsYrfbTnS65FV6InT+5a8+pXpMENrwdNxvI+IuZXsxKSB/qc8ObwI
         1nug==
X-Gm-Message-State: AOJu0Yz+58lsF6Q8QghaCgziKjduGwGzYwHxgcNMiIe59fEX8Y9pt2vr
	pbZ749Ly1ixViG1TwfZbp71wNcsh0poavsjw5V032hFvs/+zgpcm0h/O41KY5Q==
X-Gm-Gg: ASbGncug+k65+g/Bg9TwHC0KDho9Kn4N0bkzDG8IVKOMqDCAnQuDsNxLGiFRnjCXs04
	fcEXh4FsnIS/xzRh6juVFeveMDXAgZGp3c0ci8IeWCGCTTbB5F9wJFL1kOsRRErLrllYASArw1x
	F45RRVg1UWRQWcVwNmKJJGNRxKaCWFIJh6AQSmJJ6toEpd+2EuUFLj5H3kiPyos01Sq8EzLbHrB
	79HiMfxyyVYjpL/ASryZ05OfSLADopRrlhw5ulO07t8WgH/sJwKP8BIgORHwFlWaIakRJ5M3tpE
	tHOjRWJutoIj5Xgy/1d8Zf/IgOZgbyOyNbjn3ewxIdiO/hiuP2E/7WvLe/hINZ9rJFWanN8T2mm
	rf1MSl1X6kop+Ay/syg==
X-Google-Smtp-Source: AGHT+IEFW+3MHl1Xhmh5G/8acxElaSDOU6mMRivRCf0Sdqqhiiwc1uT4itB/3yeBJid0a3++7wNkJg==
X-Received: by 2002:a17:903:1b6e:b0:240:79d5:8772 with SMTP id d9443c01a7336-24096b31ed0mr137542255ad.46.1754008072697;
        Thu, 31 Jul 2025 17:27:52 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef48fbsm28224925ad.36.2025.07.31.17.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:52 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 08/10] mm: refactor clearing dirty stats into helper function
Date: Thu, 31 Jul 2025 17:21:29 -0700
Message-ID: <20250801002131.255068-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8F9DC000F
X-Stat-Signature: 9wo36zs1mmu5e5ef1bekz4m9s7w4yu5p
X-HE-Tag: 1754008073-264575
X-HE-Meta: U2FsdGVkX19/abNFx9olKvTFebyMOPgnb2zMiz5FHI1UEvtx3jqXcvGMSWTsJapSV8ghwIKOliieP2oGxwbjlA4m06zx8xRpZWRqkh1k+wFP5DTAjiEg9KROyAwl19Xg5AVbjimrtoIYYjU2KGwpgVck3dmCkNFqul3dgNvGBv1x7FXcErmrbsC9IylAvRNql+ADSMdKGOVwHKtrbGnrVRekuXKUeFV2tnI05/qhm/IJ1a/AAiH98X6outuqScdg2g8JZY0QsM0R569NlNVXzuRL9QlMxVueKf4vKY3LL5YK4jjaCJ+si1BNCnNdnmgV4CZ1I7y0D9oslttebqsb5Z88kzgVw8PbpubgPpJbTMlSZmOdDVDcYXqJLETdf+doN2/PqtHJhU2C9Oi91tXJWLYq2NNZ74/sqJlmtZSuj3Ozn671t2pPu16BHSk+5P8Q6NecABK5KMyuXoKcqA0zFvLEwqgZPwE3hw7ozP+ygGjy7RRHA8GPNxedioeABGo62si5ODJ5p3tA8FglHWgSI77UnzMnahyX7Dk3LVhJk5MeNe9wG+Ys3oRDc5E1HJO35N/GvHT8fU3cY81NqBa2EKwwnmxm9Tc/AzOnHwCghLi8Tn//myyj2Vjmkvo6roaV3SNZwAHMyhH0B0SkbZ2eUExwBWlvewXtlox0Zs7KHOJ9E2AhCYQu9vMkxCSFzYX5bPwb/sFksAkfPARNNa8jrO6sr+36ELBzFbNRNMfFxU1vakN8X+la6ZLdfTXOqf2M49+t3/fOK1LqzpZ1viv5lB3s98g/yqBeWMfDeXJWHL3bgbaYpKgryg2nUkLn0hUZESr3jE3nWiFuiYyq9zshe25/mZJnegTofRPGdVNyfpUQHzkE4tmg3s/sYkAMyQSbU1np/7LA90cXE+sxlVmhvaEwXUAofFAHSe3aCHBj+26EJ90n0pykgXzpR89j/jXXqVGCcsW5rUISlmuag6y
 JaLtXzMA
 puybhax/eSKjk61QHe6Us8/8D3QDb0L0+UDtGFFjjGeGfLK6Vsy2FY3F+IA0z4UmMZNiL32M9VeKl6nIS7JN+VwaESxijbsdBreUniDhulkF7PfIr/uNOXx+91pZ22WGFzVXoKQQRIMl60jGNXQejQ9a2SEOjHytuVK7CW7oNmIOW0rFc2mebKm37s+DbR7i/harZJ3Ct5f39g/Ns93lsFUj/AYHcUOKyw5lCIJajEv7gOOjo6vgLJPBzBE87JwPsTSkk9sMlO4KtKcbb5wfI57sFr0Hq/hkIuKQ9h7/QEWRosaIubF9/T6LMb4bf7+Rt2Ioc3KTb5n/TnfDGaa4+nrETi68qvu5AApYVZRz8Two467p1CpFxANVJuDdjlSNTDo/QA+VSXZgfAqY+nSmUrnTaCKjnmvVFFRYKHndOx8ZMSTOo17Q/ivIlcV0hCFjSFBUqRhDzjrfeBBlLTDZLCCXDDWHdYpJAelFlHrmxmkCYMgfH205gvv1eMQ==
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
---
 mm/page-writeback.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c1fec76ee869..f5916711db2d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2703,6 +2703,14 @@ static void folio_account_dirtied(struct folio *folio,
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
@@ -2711,9 +2719,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
 	long nr = folio_nr_pages(folio);
 
-	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+	__clear_dirty_for_io_stats(folio, wb, nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
 }
 
@@ -2977,14 +2983,9 @@ static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats)
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


