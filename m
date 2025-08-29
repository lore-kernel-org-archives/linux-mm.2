Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B744CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFAA8E0009; Fri, 29 Aug 2025 19:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78B28E0001; Fri, 29 Aug 2025 19:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A838E0009; Fri, 29 Aug 2025 19:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8406C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:39:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E3F4859CD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:54 +0000 (UTC)
X-FDA: 83831415108.29.C8331FD
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 656E9C0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZvT7/kJo";
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSyM1Dze2EIm/h9CrLecmjxbT3LpGai1BWLIFT/iT5s=;
	b=fwFRbuauUxE/Tl0hiY5OPqrDomPx+dWaMYsYKtj1joLSfepjz0XLmxICY5vZMI8JFCEKF7
	VwSgJpecd0C55KQJ1ufmmlCxlwYG+AHzBjTldG+9aTWKPS8oB9AcypExuH4Oh0gA/Fuq7f
	QlxzoLfiUstwwKakodcVLyalJKf404s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510792; a=rsa-sha256;
	cv=none;
	b=U7trvQy89fD/fhhPCFWoIro/eVMGbRW/HEK2xRZSMvr0gWfiRfncQIJJzJ6hweo4ztGKEP
	lKlwp/w/9xoWrvNfFHE+UUN6A7YgR+NvX2+zvTF5tCpTwr0hj7AvvkSaVzOcasiKLPERAG
	ZtJ8dWee3YxbsX91wdOLVyZMTb19p+w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZvT7/kJo";
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7723bf02181so261082b3a.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510791; x=1757115591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSyM1Dze2EIm/h9CrLecmjxbT3LpGai1BWLIFT/iT5s=;
        b=ZvT7/kJoUwyu4PMncllypz8DjkeadR1lhvPE2yD6LQ4FcyJIMSmVx1nPAaMxGrXcRM
         M8Hk1T0Bxm4v8B+YKHdXQv9W6jzTxzF5ctog2iMmkCSBaUR4HQ69qLhI6ieB4/zefPmO
         JxUYD6ZzqhRmNXAe/6JP9QE2VrFzcJ2Ej/pWrMUoePWuve2BvSoc3+LhStOPNTDNVPlz
         C4xQ66tiQG5/DwaISguN/9JtKGi0e/i+wt8po3K8DyVs7PZnpInlqLRZxwBX3OMDJNIQ
         5NkR5YckVtUTWn7ztWgdRCGAImYCks4cVu2Hluaa3DmACqk6sJs8+/D3NBnqd9aFMJvV
         EOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510791; x=1757115591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSyM1Dze2EIm/h9CrLecmjxbT3LpGai1BWLIFT/iT5s=;
        b=lVLEIR3H6ZnNZ8bIoMY08ryLa4l1ln0hSTBgmd6nXEIkaueih6VWeqmjshPlfAiaDm
         BcnEUt1DEamyeXSB3g5xjB6gIvhiPFK4eP8PaHR6RVD6I/wTjYx887r8h+KixyxpLalF
         tEqqgz5UH77NiSP4PVDozY68l27H3cSzmPoj4xuDRtD56NeTLAoaDZXtV5bGoguC28W6
         y+UhMUNsPnbptO5cOStd2bpoaapy5MdVHAP4MMiz3DvPF6Y3f56+AlsUouTY9t+Mtti6
         l9RQOV0zoU2egUcLOZSw6dgSIChkRN2dggZlzPC4ge/3gH2g0W4FsHkSYGX1d8B7xmAQ
         c6qA==
X-Gm-Message-State: AOJu0YwmoQmrdOQX1XP1Y4Oi7YqaeTIUk9h2AFUosuaU9ZbFOOV02NiK
	KEgFBoMbTkewZBQsbJ4hLT7eHiutx79nzI7VjuwjH7h0Jm0kBWBF76VTa+mvew==
X-Gm-Gg: ASbGncvCwAxj/mjKbJp//kLrSlK6mClFj9ovTrB5MHZUYoPX8luqaEjdFfdoaBDcNEJ
	lPXVwTUo995SF8OHRprjGyJYxVF1UX6lOgw/l+cenJQFA8pO6U4TiMZdlQBBPv+e051wVStjCX0
	r7XjXCEWs/hnVUX4NWtqxz01qts+mSR0zWZpHeJtpON2o652fS1OKhm41IerWPnJUx8H0/+UUph
	NQenNPq7KdlDZtHsSFEYC6gkVrkCuTrb6ro4v06q7VUeSm7+/4DV/bZYVtRk7AMyBNCIh/+meCv
	QjyfP/jse1+FHKq+4CaGW+KuhueOISlex1x8cyhlMt1IYgLub1xMUagucG+df3xjG3fL33GSygv
	M6L4mIpZSHzMibZYAg+Joo24JlSm0
X-Google-Smtp-Source: AGHT+IH92kboLhqodMinTpDUK+736mlRKSOdcOh6Az8Rb87HymB90yQOgtuIY+YZl3qJhrrr1GD4fg==
X-Received: by 2002:a05:6a20:7f97:b0:243:a17b:6414 with SMTP id adf61e73a8af0-243d6e5b01dmr528924637.26.1756510791075;
        Fri, 29 Aug 2025 16:39:51 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1d5csm3429829b3a.74.2025.08.29.16.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:50 -0700 (PDT)
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
Subject: [PATCH v2 01/12] mm: pass number of pages to __folio_start_writeback()
Date: Fri, 29 Aug 2025 16:39:31 -0700
Message-ID: <20250829233942.3607248-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 656E9C0004
X-Stat-Signature: hqw945b4ehs3is1y5muh1sj7rdopmbq9
X-Rspam-User: 
X-HE-Tag: 1756510792-218555
X-HE-Meta: U2FsdGVkX1+dHqkq2C6JqO/kEMa/Xh/qsa26uEH3rSPDyRbDg4qYPe5MLCcCoAnPLql0jRtEnlm/EyGQUxTC1oS9JhH9HrpiNrnRuLk35eGZu1RRLJrPepuSB+nvNP70XdKiQyHFSePqJUZeidGkBleiY3cqP/8N8bbQRHDwzWKMMoldTMYxz8AwBW0c+uvGvv9N2Ih5FO/xS2p6qNGDXDa7lBc2Os7cXi9itOgFQ58Ffk71wQqm7vrnaoJ3xXoyE2iRMKLg/yhB7x9E0MASBO7V5v0Qg4EfbCntXUu3PV51Y1CIX9HnCc0uZZO0hWDkP2SxLIEJ7UQ2Pc3/VRYgVVNcZHgyA2BTIXiqxcQz4H9JQoEIEVybMxOu7HSThquLXj/AJTutr2T8WTNApZW2fytkCsXtrSDuCaBwLlDRniXQEh2V8CREmBZ5zSSaq40V/BvklgOuDiP9RCTaybJzyggTLMaH3znb4TCatqY1++Hu27fFVVUYlN6dFMXphanIm7J6TYPTqBLhFeqlRedKR1nLP0Iv6UxTwK+0wmLxlWXhjOfuuewUfenlhGGZC+7k8hTInP5IyTgcA2RvE9k3YMOdiYM23NR6hBGP5H9ckrMhC6oM7wDRxCIYJ7zbL06xQUZVKl6oF2+oPA9vU4EJ0+B+zRhEx6vbmUO9MJoJuib05yxrPm8LsEasRzSBGLEC4CS4e07GVA8hmUmZJyN4s3Tz8ZO788XDJdruKXa/+Pzuph/oGtoucW+A6SbCMZf4VOYXJbKoEghDj6VzPkfIYjfq/Y5D6R4+xF9EEk8bzTwa+4VNp0JEEhIyPcS2gHIjrTT0sQjsqbNac5ey+wSHpQgZX8Xq0LKSgbV8H26f8qzRvK8pfXJb7OjePLLNG41Qs84c+3bwrxY7VzVd8iI4NZ4b8inM0w9S0IyyZaCKGMtnOMSc5rQxzYi+FfZlYATz/AbITu6VD28d4iCDSi2
 LtWbeVI7
 id9mgbi7syPYq3mVkbK+tuK0w7csHTJIKTO5qvS91kYfBnl5/5nXaMwkOxJb14Fe7c4OP9R7QRQHzJywa+CL1LlPeRYus7ZJOj6ecNGOZDF6uN8XGTmfoOe3DFPfEHnTHPamIKCZ7UqyMNdrM9znIdHIYxUz117UgVhM1nI0cnl0UFXrjnAa4M76pjvKtNIQurux0Jzvcix+aUNU5cmoE0mNZ0+zAl7J6IyNihpdja1HBHcjRtFZVohu9l/vqO4P13B1fBbccRaJPRNerF5qv9WUmyZA4PdUPbFQhaRcBsuNZ7g8p408DqK4a/Oc2410JsJpGBI6VbZH9+OoqfefD4sQsh0vMJ7MAhxSTWKV3BZxfMTQENulxllT7a/Sm4VBFUX7gTjw7Hn2bbYn3mXniyH+juSH2zV7N0rHHV81lwBBtIkQNFD5jKdNKb3aze5y2r6bd7snlkMlSWyHg5X4cIHiYgX/VsIKaI9etdea7VpHaHoGpbpuqBsfjzz5yW1k/MVTHc/qdDW+u/9qxdYsZVo/WPBukSLIDIrHDCDSB/WZfGjQ=
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
 fs/btrfs/subpage.c         |  2 +-
 fs/ext4/page-io.c          |  2 +-
 include/linux/page-flags.h |  4 ++--
 mm/page-writeback.c        | 10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index cb4f97833dc3..895e0c96a8fc 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -456,7 +456,7 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
 	 * ordering guarantees.
 	 */
 	if (!folio_test_writeback(folio))
-		__folio_start_writeback(folio, true);
+		__folio_start_writeback(folio, true, folio_nr_pages(folio));
 	if (!folio_test_dirty(folio)) {
 		struct address_space *mapping = folio_mapping(folio);
 		XA_STATE(xas, &mapping->i_pages, folio->index);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 39abfeec5f36..6b12a6b869f8 100644
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
index 8d3fa3a91ce4..d1e0743217b7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -832,11 +832,11 @@ static __always_inline void SetPageUptodate(struct page *page)
 
 CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
-void __folio_start_writeback(struct folio *folio, bool keep_write);
+void __folio_start_writeback(struct folio *folio, bool keep_write, long nr_pages);
 void set_page_writeback(struct page *page);
 
 #define folio_start_writeback(folio)			\
-	__folio_start_writeback(folio, false)
+	__folio_start_writeback(folio, false, folio_nr_pages(folio))
 
 static __always_inline bool folio_test_head(const struct folio *folio)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index de669636120d..d1b2c91f0619 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3042,9 +3042,9 @@ bool __folio_end_writeback(struct folio *folio)
 	return ret;
 }
 
-void __folio_start_writeback(struct folio *folio, bool keep_write)
+void __folio_start_writeback(struct folio *folio, bool keep_write,
+		long nr_pages)
 {
-	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
 	int access_ret;
 
@@ -3065,7 +3065,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 
 		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
-		wb_stat_mod(wb, WB_WRITEBACK, nr);
+		wb_stat_mod(wb, WB_WRITEBACK, nr_pages);
 		if (!on_wblist) {
 			wb_inode_writeback_start(wb);
 			/*
@@ -3086,8 +3086,8 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
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


