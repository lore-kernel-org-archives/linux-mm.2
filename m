Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EDACA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6738A8E000A; Fri, 29 Aug 2025 19:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBA28E0001; Fri, 29 Aug 2025 19:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C6C8E000A; Fri, 29 Aug 2025 19:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33A938E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:39:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B05721A09BF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:55 +0000 (UTC)
X-FDA: 83831415150.21.3548A6B
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id E1B5E4000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b1zLFHvC;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9yE6iUWv1HmTcycn2Kgovi0OD86opQK3HCN8NH31Dw=;
	b=cxzVbW9EPyO1ZRgEyxyjcq0snZI/HNakbD5B05z/XE3UxZC+3kv1dgslgAe7omGlIprvMA
	k+yCKwdnf2MEin24VO403Ox3DLY7ypUjOH/hBDV7DTu1QBxJYE5HCvHCHC6YNZD/1IVsPH
	fKKLm/KrCAfRD9LCnUz0vRwinMRzBps=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b1zLFHvC;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510794; a=rsa-sha256;
	cv=none;
	b=SIBZLSRwrmhxYpe5Jzx931EVZTOUIe1Cckw9UOa9FPeOM0B0O5/WpuaFBZqS1YbIEC+ztP
	7M6Sm5HKo1lortKR343Y9pXOKxAKDEd53xMFvewD3i9f6G8vic3o8wPpVVWkQxaKm1bS88
	NaIwVZ7enEHsYHypmCRvEryxarEgUFk=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-327771edfbbso2712666a91.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510793; x=1757115593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9yE6iUWv1HmTcycn2Kgovi0OD86opQK3HCN8NH31Dw=;
        b=b1zLFHvCsLTw25nSbq1QChM1aWEo5Na7UXEZYaaSV0VWV/Z1O6Th4zN/V90I5I9XR1
         ZruNYd8TasA2rIO1BGoLMmpPvV0GtFFOhp58+KSoNGWSTn/vjOlvHL3LHfrI/rBIRona
         BGI4xBDx7/jFShT+Xm6tA5b8ixvVuewsE6kA3cg9t/mIGV6IVEIUM8t9//PwHpiqWekL
         C0k9NVTYH/fHspvaWOjWrNjafvKGNyYEN9Hh+YLWUTVO24wMqotml6sodnPpEThcf65j
         FEi7XTfF338USclJZy/itsRpEXzjKLyTdiryMyLJkBHb/e8EE95lVhnPlHYTgMJE8hcP
         cL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510793; x=1757115593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9yE6iUWv1HmTcycn2Kgovi0OD86opQK3HCN8NH31Dw=;
        b=bOibSzrWzdtjb50IywIPjxxgs9SUpOXUWTrWHPv+xCF65HexTSAapvVGqK3wT1MfD9
         bKu3USuusFizOi8w98m9xTG8CrXi3KOboWTSN2TBspTtwjofaayMPcumulavbHHMFzEr
         NzIdEJqdqLeOinIQ9ZBv0SjX5aqQHthKvO9EaZIb0bcpFFAhvHswyCnNNhz9muBum2Ac
         /Wu0NeVz9XlA+bIVONHlcOthNZIEObQ+9zu3ws2Eby2MMTSSV/x9Q11StaRPuBciefEI
         7u0nYjavdguPv6aGBips0MieQsrrYeech72VL4AYkLGOoGw/faspwwIoH1tb3WsKz0nq
         jqZQ==
X-Gm-Message-State: AOJu0YwGXijcT9S1NUaprtm70LOoCRHfhhs7b+rgZqHyaCkq7DpPmY4D
	0IzdyvvyglwWI2gyY+pwQI5S3qMTvEQiqp3CW3aAd6jZpq+DWaWLBVoyn/cwYA==
X-Gm-Gg: ASbGncsWZup01PKJB4RMvXjvR5i4JJgqpGzqshC34HqHbQSgFDkOaOid/1iHVIRHgRV
	9t95r7czPl2T1TCYn4OJ6ClO2FHf8G4xT6pJju0PGw1b7zYOSU8UwDV/jmWjnS6JcfHFkovOkrn
	Ut2vwHvgNR2h86PNK4Wk8RfAgBSkd9oykFVmMA8YEG7F3ey19gzHQO+YbLWfPi0BL9b8kNsHmLB
	gS2q8RAn7QTTu5VVhl+buhyZUojpA4zI4B6xCkZrrIIP5LZ7yZvI26jUTJjcKV3m1alV8ox//MT
	U8c+wqmmJappurFGpNoIAX12eo6wX5KVPwcwp8/qkGx9+kFQtoZzcpxNHE/TVZG+bY4WI44CUY5
	oZupEKllCXVYLL5kM3x/Ac/IPqHvn
X-Google-Smtp-Source: AGHT+IEakBzSU3WTPQcPaNKIo9o/oNQ5zQ/nTiRT9vUZAKzQVW1JTdcqtGnmIj7pMlDYZQjvOwwypw==
X-Received: by 2002:a17:90b:57cc:b0:31e:c8fc:e630 with SMTP id 98e67ed59e1d1-328156cc985mr554327a91.26.1756510792618;
        Fri, 29 Aug 2025 16:39:52 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327d8f66f16sm3893578a91.0.2025.08.29.16.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:52 -0700 (PDT)
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
Subject: [PATCH v2 02/12] mm: pass number of pages to __folio_end_writeback()
Date: Fri, 29 Aug 2025 16:39:32 -0700
Message-ID: <20250829233942.3607248-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: smeawqa34gsgotmftndf14faxhp94o5q
X-Rspam-User: 
X-Rspamd-Queue-Id: E1B5E4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756510793-953690
X-HE-Meta: U2FsdGVkX19K7jisMxxW+ZuHwq26JO8sALhprs5UKNQn9CICEyvCDlmX0lIsGWZMUVbe9S5Y6fV4mO5WNL3NK/wh6sbsLFhndR5rD88eRwFjj36PiA0lGYQN+8kHu/2r+AQjep8AQsy0gm2tQPwA86yhb62gT+tp+bVnzdUFhWRUeozjMYSpGu7fN+Om+i3r43PCqiav9hbKZlmWnqH2yNiQGRfNbcVw66ZDpusSXzgn99c47O+0W5krQF2xHyOLTl/h5aCxXWa5ZsFqoc8mfEByebxJbMvlLnEl60Vrv28SrGKk2gTJcQH01eb55lV2BDkQ8Tc4mQvPdLNPdKuEXiA/JpbXXI5T3oZYIH2xrMMqu0ks/u6lqe7T2iXOIEU1NQV/wOWgNG0EOS1D6+FpJ7PvxsotcpmiyYgQY0P6aN4KMB/J5C1i0vCyJ3crQikMZUqDXr40ie0Q0TKuXXzSRTUBghXdhGLOhTFW3DnEHNz8O5cwXxWjIOHEkSP5ZPW7mkG18mgFG6UbmIk1UlqvNGhQHQYx72UVEKtRcZ14q6+Xc6na4zO5xOmEOCHM8B2H14xlWc8W2TCMzhht4H7XGiZpgGzjo+BeFmVp4g+AUrZ11kXxraAAVhSQx2vmFrphpUWQc8TdXVebhuS98Fx7tX9BL+byxJi808zn2F9uNafYG0yKKQ5+we91Rbcs7CP2T7VCIKwDVgWvOq3VymF7Hx5EokEU/1mwWOIjJSzcSL2eKSIfZh8pQGjtnvK5L9AtekUhHyzMgULshV3E6VFJ6gvuMBC0LdZNUWsHmDgodv0/rEARgN/Qp2s8sjbmv8+qnw8P4jL8v1Spe+8wtSSfC+T8y0ZKQgbRsAjz/ZUsdkEGvuNwPxUN30bt5DKZiNqCpfjw/sqBkVCzzwGX4AX+pjfyWrh7IQfWP4mrZn7s+CNcgLK6rwEMkofS9W0NidEdwOIPelRLVp9S/jpVim+
 jeGM6A5P
 7SQ02o2WWQAPiK/Yqxxw9HzIomNYuJ1cB4m+DRsD54KhHFvZy8AKL6Q4UVpUMzBTHiRAF8qeDYuiZcT8UHFH7hgABDkkeVBPtO+6AMG8YWE1uMiI1W/z1sQqByhyfWRIyrGYrT3FcDxbZZaQwXGWkt1B9fJ8iStcDOWnVQloaAaxQ4RlhrOTojLgDm7AU1r0HajLNcnk8/84j0JpfDsfg9eWK53Sn1MVVJYMtQtezgv1j162aySEa7IudxTIIWmHAsdy9HQwPE8omhIuFzhoBHjoOzKqk9dCKUSgNHHYbk6KuL35WsLAf1qVsfkuaEoBie8gGW8PcaHHmAEXzR9SkV+a1OsGzoIvPBa3JGwRXSYNnm5AAUEAtJurXreCYezkANHaRvh4jVUCdm9nbq6eoPAmp44IX8pIreTvgMhimrREN4m33lb8D/0NUOoY3MKH0QTULXaKP8Inn+NkO3hwef14f0g9QRGo6XmerPZQv4uK7XKXksE5EBtVfixnl3QOIXs3nD0X5jFd6WQSMq+N9nHMMxT3+sgL14qITnnaGbFx2hwA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an additional arg to __folio_end_writeback() that takes in the
number of pages that were written back.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/filemap.c        |  2 +-
 mm/internal.h       |  2 +-
 mm/page-writeback.c | 13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..cbfb0f085eb6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1657,7 +1657,7 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	if (__folio_end_writeback(folio))
+	if (__folio_end_writeback(folio, folio_nr_pages(folio)))
 		folio_wake_bit(folio, PG_writeback);
 
 	filemap_end_dropbehind_write(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..2eb156823d45 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -438,7 +438,7 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
-bool __folio_end_writeback(struct folio *folio);
+bool __folio_end_writeback(struct folio *folio, long nr_pages);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d1b2c91f0619..65002552458a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3006,9 +3006,8 @@ static void wb_inode_writeback_end(struct bdi_writeback *wb)
 	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
-bool __folio_end_writeback(struct folio *folio)
+bool __folio_end_writeback(struct folio *folio, long nr_pages)
 {
-	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret;
 
@@ -3022,8 +3021,8 @@ bool __folio_end_writeback(struct folio *folio)
 		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 					PAGECACHE_TAG_WRITEBACK);
 
-		wb_stat_mod(wb, WB_WRITEBACK, -nr);
-		__wb_writeout_add(wb, nr);
+		wb_stat_mod(wb, WB_WRITEBACK, -nr_pages);
+		__wb_writeout_add(wb, nr_pages);
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
 			wb_inode_writeback_end(wb);
 			if (mapping->host)
@@ -3035,9 +3034,9 @@ bool __folio_end_writeback(struct folio *folio)
 		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
 	}
 
-	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-	node_stat_mod_folio(folio, NR_WRITTEN, nr);
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr_pages);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr_pages);
+	node_stat_mod_folio(folio, NR_WRITTEN, nr_pages);
 
 	return ret;
 }
-- 
2.47.3


