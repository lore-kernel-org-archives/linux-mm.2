Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BD7C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2C16B00A7; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA726B00AA; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C5E6B00AC; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C21076B00A7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A2535D4D1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:41 +0000 (UTC)
X-FDA: 83726300322.24.D0A6113
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id B9D0220003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ag4exbWC;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5B57mseETpFTK2e/32JnZzIEdRNKgkoknISTtuUYAk=;
	b=GjGwQ+osJaXErLGKw/PD8Wyl7z3a9Wcln43E2ob2FSUlPuKsU/XjFZPIAy8A5lL6iTx4SR
	aI4yCmzfzPJsBJjQaw5mAwo5qq2A7Rz7s48/PHYj4MTEVQkjVmyTYrTx+bKd3/zWI4cQnc
	70BskejA5aMyK6hfA5xqwkvc8qDzKvs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ag4exbWC;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008059; a=rsa-sha256;
	cv=none;
	b=FSKSSpdLOpVO0G0Jm/vCTXX5ZI9h7cVB41GpVLJ8JiF+CiFRR5SbXSdT4R6Rn6TPFAqDca
	tr0Nm9FaPCI5yWCcEcFhIK4Rc9DwcFXx5yBAzT/FleB83Sm2S+C402X6MGTzUEaw3U4U9v
	xaBx7vwJ74jJYjF4OT9wGwe7Qcs6lU4=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76858e9e48aso906685b3a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008058; x=1754612858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5B57mseETpFTK2e/32JnZzIEdRNKgkoknISTtuUYAk=;
        b=ag4exbWCQ9qlSvnoOk8z5bS4cpVukEOCjxmUXiJJ+qvFhaVGEVuxLdZIIKJCTmsO00
         1Uukv4i2MndnEYgE97iGxHYVpk0S4UJhHvIFq6cG/rSq+6K3ifRoS4Ke9iRSPEINBpSq
         AYwuedy+TkOHAwZL+63Pxxm+XAuSWdYEMboRQ53jzaaF8HneW4o9qxFNKNBtqlwpQLMR
         ETMF95oL2PgVNIVtcf4/8oyl6IA0BBGySp02dbkjnnYARvghyydT2iLqC7QLOPCde5ed
         GBCdThUGL2qSLzREdPxfgxr4l9pOpJvyAqM0y74a+nNuSXIRnjKWdB9a/vVjI67DH5Q3
         JEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008058; x=1754612858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5B57mseETpFTK2e/32JnZzIEdRNKgkoknISTtuUYAk=;
        b=kLfrqFUeMftH3Db3FjKRl2ecvPdjfYTjW1hmi8VqurdF7NCwGqzrwCMwwX4QOMx3/5
         5zN+eMZmnPpVw/F9cKMvVYyD8/9xSgQ6q5QvWwpI1zjk40vVYbjBgrxhMPn9Gnsx4N/g
         bsrQM7SsCgbklHIHrOvDP51g73AMxLUOeBacBdiAXROjh36XuYWbHhcEfioVOSivzSFL
         7esOJ0a4mYL8rnLzza/RcLcx/M/XGn0JRIsqGOBzaZTCzpzcibF7lxHm8s7rMcnjjxUU
         ewMawm8a3cUITZv5xntP5NXf+AiUhxs2UA3mQnjdnpIelGz+Az6rW6Yng0PPiKArS4EU
         Bmmg==
X-Gm-Message-State: AOJu0YyEsWeQ1x1kRiJIYyJHh8hDrS9ClOBGzmE1SEW/UR/0qQLrLsXL
	zeMbsmKFHiCtGBZ8KxqPNhirhsSULszrc0dCU6VKffURRjvO/2gOK/Sw+wxjuQ==
X-Gm-Gg: ASbGncuy89jDRPO92lWr0hU/8Xcof7eT3sFG4qvQlm6n5jF+lrfUnTFpv6bdABn5yBD
	1GL83mCGcvmEsn8oCo55ayS45x6bL7tsPt1HHbwzoYNIiWGWHlK/s6R4MzkZ4i6DKsgPkMkNsGL
	Gf2D1Ye2cxBaTtNKFzC+tSknZSoqtmW8afYg9/TQg8QHSYVH6Sqtu1nz+9h2Bgk8Wu/lZ158gGh
	ZkLs99UTiDfefUkfqQv7iuAJdL8bjsG6h95i1ggPpDSx5WtvmopvsfiR8WyC+9DxDCfJZIwN0Ms
	IVdhz+cIH7NYYcHLHT3RaxhwwKXlQd51QweNOz7+e2k1Vcvtz1sN3A409X4tvzmAuHH0ulwXsfz
	WZPU6C4k2oYw3MxqlIYiRf0QBx2Q=
X-Google-Smtp-Source: AGHT+IGd85tF/kHZ2d9TzwwdX0gJh7BUCyCttC3q9sNC0ospI7oQdPkh9WCQsdD2QQfSQq9fi+kfQA==
X-Received: by 2002:a05:6a00:1790:b0:748:323f:ba21 with SMTP id d2e1a72fcca58-76ab101c40cmr10929375b3a.1.1754008058333;
        Thu, 31 Jul 2025 17:27:38 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfcfe18sm2664208b3a.93.2025.07.31.17.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:37 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 01/10] mm: pass number of pages to __folio_start_writeback()
Date: Thu, 31 Jul 2025 17:21:22 -0700
Message-ID: <20250801002131.255068-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B9D0220003
X-Rspamd-Server: rspam06
X-Stat-Signature: nefszfxfnwujhqoj81pxnio7y9bc75hz
X-HE-Tag: 1754008059-342828
X-HE-Meta: U2FsdGVkX19+HIBJ7RWp/jLhQGe+J0bxDOmqV3q8BGop9RJK+hdLUgWkWLjAD3+X7OPEq3m7zsp/MtLq1CjnuhvKl2+84hm3CCF9p7H90LdCoTFtl29UwhAyvPYTkTvl8gr9UgWdLS3u4rIo4gJrG2lvfw6Wr16hlob67jjjKDLUOkeQyyVe8MvLYyJNwrRgKGOErloy08w71UqsqPjK36iaEiCoPU/dZU9IHEYT8uIBnPZSKdcDjfp0wA7+sHDCwAbPvCM/9OJ9wRqiTkUdjfh0QJ7M1tXVXkfcCxRWbnh4sTg5ZcDBWaAXDzzF06KuNBuG13WWeoRVOQ2pBkevz2tPOfOJdPMufOkHcFPgvs9zM8Fj7o/1hzCRZfUCqlBuh0Zi+xfZv1ufex2suVcmb6ZgWlZaJv9oU/7a3lmLQvqzLt6FmPUyfJy/FayBPxqzSjVr86KKd8MQBEJtSnsFlbfrLAasrwLuJjBdsyt4MH0JIVfN7idv1W/ChlJZtm1YTxSSKZlKX5L+qyFP3A0J9iw7MNw8qAzD/kipzw5j8pzT10wyVBT5ZCiYilIHzLK3YRS2XkK1yJLlyhfkyl6zxb4lhU18Ynme4JJb/79h4bfflzD7R08Uoxaw2jnuK53HGhTMEv0xdJkhE+StAaTg2+XmNuMD95dxqCVzEyChjdxwvekjDbNPjm8f97szyhy6x44py7YkrYI0sbwnxftG1mO0tgbY5HhUGbdCby6ZGmsDqp3INZAXyQngCbyWmFuUi4gRKL+ev6nbNO+11UVZpwVrr98sFGSdC4Iw/DEISUSFUE8ndTr+VvuLgFw0jl265eJ5amlH2mBktxH5F2zF3c7RPm280OT2QM8PwznRwW64IHP1v+MVq2hY7kInLX3RHaldK5892T3qYnrKxJYDOhPpnjh7FXLReXm0LetJ1NNi1fHwRJ7pUPOPMm1KhZOrcq66/ILlm6QODr8RH1J
 ygUhvsQG
 hPX3CjV1k27nlzwKa7RBqzr8aRIQ6j6ONBjBiypej6aOlq3T0faGlFZevSOn/PitS2Nkm7FeP2CWNVRjF/jilVbid0ZGuzmkBhBqo9NbDJsvHlHJQ/TYOsO0Q+xoiDCJ+fLAC1fKWIdpd+dvPHYGSml0arD9ybbrNnzbDFgY0+9AntujHQDwviUIfZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an additional arg to __folio_start_writeback() that takes in the
number of pages to write back.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext4/page-io.c          |  2 +-
 include/linux/page-flags.h |  6 +++---
 mm/page-writeback.c        | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 179e54f3a3b6..b9ee40872040 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -580,7 +580,7 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		io_folio = page_folio(bounce_page);
 	}
 
-	__folio_start_writeback(folio, keep_towrite);
+	__folio_start_writeback(folio, keep_towrite, folio_nr_pages(folio));
 
 	/* Now submit buffers to write */
 	do {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4fe5ee67535b..7ec85ece9b67 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -854,13 +854,13 @@ static __always_inline void SetPageUptodate(struct page *page)
 
 CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
-void __folio_start_writeback(struct folio *folio, bool keep_write);
+void __folio_start_writeback(struct folio *folio, bool keep_write, long nr_pages);
 void set_page_writeback(struct page *page);
 
 #define folio_start_writeback(folio)			\
-	__folio_start_writeback(folio, false)
+	__folio_start_writeback(folio, false, folio_nr_pages(folio))
 #define folio_start_writeback_keepwrite(folio)	\
-	__folio_start_writeback(folio, true)
+	__folio_start_writeback(folio, true, folio_nr_pages(folio))
 
 static __always_inline bool folio_test_head(const struct folio *folio)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 11f9a909e8de..2e6b132f7ac2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3044,9 +3044,9 @@ bool __folio_end_writeback(struct folio *folio)
 	return ret;
 }
 
-void __folio_start_writeback(struct folio *folio, bool keep_write)
+void __folio_start_writeback(struct folio *folio, bool keep_write,
+		long nr_pages)
 {
-	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
 	int access_ret;
 
@@ -3067,7 +3067,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 
 		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
-		wb_stat_mod(wb, WB_WRITEBACK, nr);
+		wb_stat_mod(wb, WB_WRITEBACK, nr_pages);
 		if (!on_wblist) {
 			wb_inode_writeback_start(wb);
 			/*
@@ -3088,8 +3088,8 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		folio_test_set_writeback(folio);
 	}
 
-	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr_pages);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr_pages);
 
 	access_ret = arch_make_folio_accessible(folio);
 	/*
-- 
2.47.3


