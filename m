Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FA4CAC5BC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8A98E0011; Fri, 26 Sep 2025 17:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB01B8E0001; Fri, 26 Sep 2025 17:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78558E0011; Fri, 26 Sep 2025 17:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAA48E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:17:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C52B1A075A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:04 +0000 (UTC)
X-FDA: 83932661568.20.286282A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20D6B120009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THHpV7Mz;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758921422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9EcAJwkVO1k6z+Bq8iB9jwHou2j8ZHFnEQnT5CP3gA=;
	b=JpLLPB7uvEegy9mZCQT1SllnIVp5ZIljJKGbG4gcI0wIxUYxnpIrRO1jQ7NY+jFALE6l8R
	mEvxeZYAYAjEbWewZgoOLTxBa/Z7ghyIlisS0x6Z8VIA43TLb1CNMRNOxk9Q15aiwcx6Fd
	zXYiugtbjx8WRfbtWRrjNcUWZ0xwcSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758921422; a=rsa-sha256;
	cv=none;
	b=T0Bvodrt8d9mpTk6xsCJcobnmoFdHmJJd529qyWLZG6Ltggl4thNKIyl2Q1MIih0rQAZyN
	TOBX0ilP8fQFtyaddW3XGtGKrwiSgl3z5mOFXPwCvHoL6qdfy378BhY5uzxuiPC5ZNYH5P
	uiPDUaykR/eQK8VJIIXKwfOR14hcWNk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THHpV7Mz;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758921421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9EcAJwkVO1k6z+Bq8iB9jwHou2j8ZHFnEQnT5CP3gA=;
	b=THHpV7MzN6gS97F54cRouj3Dlc1MXI5WTjZmlXHnwj0amP0HSdbTI9edveGIVt9791Z7Zr
	7uXX6UWQKIixSpAX9N3RUjlIdA6q+Nn8nQVHL+hxMdg2pJegY5ykzhYvIY6nleWMDju+xx
	G+R3y0KLL8cqdyWzgw42qml6ZMN61A4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-A4q3G3ZJOpib8INsVAPIug-1; Fri, 26 Sep 2025 17:17:00 -0400
X-MC-Unique: A4q3G3ZJOpib8INsVAPIug-1
X-Mimecast-MFC-AGG-ID: A4q3G3ZJOpib8INsVAPIug_1758921420
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-84a63a0c496so739517685a.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921419; x=1759526219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w9EcAJwkVO1k6z+Bq8iB9jwHou2j8ZHFnEQnT5CP3gA=;
        b=aEYTbFlEswWleCCYZkCfLimdmCssa7KQzITD7rks86YMmm9HOey94Jzs4nFSdFZTCN
         ZTI1LnSy6UkHHjUDAo7XxFcNBaCaDe2ZYCX21tkUUgzxAQ9+9Qc4XBdqIT99MVSQJdo2
         CmeSA48JACJjE8fBr7LihJH/abar6yPG5mPh+2BRnox96EDu2070APSCkdwvJzkrObpp
         Y3w7UuKxrdhA07u9io9oUIjBaln9/AgNmQBwZ50yTT0R1JxniOG2/28ZvEPcvp1r+OJR
         uxCb516trZcLUmabgHRnZPX6bnh8hyV5C3u+9Mdoz6f4zDcgZ/pU3BCTM3dZEclSHQE9
         UH6A==
X-Gm-Message-State: AOJu0YzBQ1pV7g16vF+QQApQZcyERWQTyC1TQgnyHde+OQzsoE6K5+T8
	adtQ2+YiM3yXEwgrQEPSD/g0AbUr9r3yPDQJEF1/CBOHNdvLRjKxssyfw6sYMxjaDdSKHSUktCM
	fEgS59A02hJkGjekZvQH172Bo3fTth5YJQSXYflgin+a8sfv15FSSS13iGjLp8grVBfla0i1Ihv
	oiryKZ3PA+b6Fd9yl45TtaXkUkStWYdQvEdA==
X-Gm-Gg: ASbGncvH5kJMv9uWEDXEDipyFAvrRRztzlGSxieE407atx9FU0yNDpyxgAVhYhgS3By
	Tn9EOYwdzkLOZHeVC0ZQpLwREGCGjVKVaug0s+NQ1EElaMaVPQmyTdDhPg38fHfxjnXMlDkQLJb
	6QHLbM+JlfQ6HUdbVpMeav4c198Af3qU78LBt1Ln32VBB4u+LolWGRV2MgmFjYq1ROqYJQSFJ/z
	NPcDTVvRr9pw57zrIVcip6pTuRBjS5AdNOuS9CyjcSpBo0VZeiHyuBk8uxZ7yhGby3Jyhp5YpuE
	/POrZAVm+OOl2d6TiNRswKg+4WT5HA==
X-Received: by 2002:a05:620a:4722:b0:82f:5ffb:1704 with SMTP id af79cd13be357-85aea5ff651mr1128783385a.42.1758921419103;
        Fri, 26 Sep 2025 14:16:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUPCqwUFOJYLq99ntR5y4uXNMimgWCraucnJeJODIKMmZEqHjL7gOw98u8EnRi2EraMkV6DA==
X-Received: by 2002:a05:620a:4722:b0:82f:5ffb:1704 with SMTP id af79cd13be357-85aea5ff651mr1128776485a.42.1758921418443;
        Fri, 26 Sep 2025 14:16:58 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-86042e32249sm210604785a.44.2025.09.26.14.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:16:57 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	peterx@redhat.com,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v3 2/4] mm/shmem: Support vm_uffd_ops API
Date: Fri, 26 Sep 2025 17:16:48 -0400
Message-ID: <20250926211650.525109-3-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250926211650.525109-1-peterx@redhat.com>
References: <20250926211650.525109-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X5IX82wlzNl_6KyAUwBFl5YhMfl9BzJsceC7KDhgyGw_1758921420
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 87kceqmmo3fs94by5uxm7ybrfnxgpigf
X-Rspamd-Queue-Id: 20D6B120009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758921421-513830
X-HE-Meta: U2FsdGVkX1/6/jOB7nHEF1YI7/nmeZTrnI7dPXIs/hXvv7ioVqsEq3mggy6hQ510ITyVXv9eMDQ+YWdq0v3TwqTyZ6k4f8Pq22GfQMZHM30VHqpJkq+njWjwjLnR9PoLMsEin25iMe6wN8mKkU8lF5cycZA3RAgHMZYYBrGh56IUnqEK/l/AAu6jF8t4Vb730r+SYCkbkGre8AIUhqBdZbVOVwzlM1x1oCflJzq7eTFkDtQXFbleKmfGGJZhGfVPzimyRX8jghR/OIbgyXiCe0GpHa2VfLES4IZid+9gXZjWeUCFjt7SoB0UgULDhCubhij8LyUioz1wilkXivRPmEbAuF7AVvLmzRMHTQIYrn/AY3L5E3fGFjwZsKZz6I43ehE1Bi55lX6TYXS6qgCXwDo6+ipLdtp/DtQ8z7GPMrnFDpeicK/mdWMZE0APZaHsijPECuDHYXK4ObRO7H3xm/en4mOmoE1w6Z4GSA3LEju06HJj0qBr7GUaoqZ+nlmxke5OkB3pO1UDTORN5S+nnuZZ/gOg5RpR8/ZzXuXZ0Hb6UDk0W/ZHdZRgNtusyRFF+p9STU+TjDEvkNv51ZRRTGePYtpwL22k9O/uJLHjDMVzC6XTG9YODXcaJlXTtGOKi7np5PUjmq/lU3IcUMVBAmaflpuVqzYUfKtTMhAv8zPycuubA2VEVezwhSygT4bXEXm9XEnn7e3e3Eoi1IaGW5Vh3oHr+l6ZdkdgqruH5GFokh5QMLmaq2Y+s/ThIZFYhondpnqPyq2lqEdPjfv3Ug1bKnKRU29w6VrtV4Y6kBuOhQ3mNOVh04/zaY5G4Bau8AGBA1SGnTQDFT23o+7UVCaRYP+8Uh/jEjHQ3UiCq5aGRM52qpu9wPa49Cs6uAuKqB2XcF6oGDoD6frCC+4AbyE0BJ6Ubo1XJH85UaPFMf/VZBnlxkD7uogkWQwLsBM/nN5YjXJcTAOL+9cVsJB
 qKSTu+EF
 kgEWpW6EELcY7Uqe+gZIUExncVL/k/wu7mAWYUD8JDfepZMh9rN8W3djQydLATFPPcnI6nt3Z+eFshud70PP1GsWbFeK6SNvcOPeKHrL1gPad/DEU8vzanxjmQI7+qQKHGOXihCdSlBxs4pwoWBgRvO+JDWNWKN7wkx/uVeOMOzh7RQ8pWRMCe0lW93W401HZxhRVK58OQ0KyHW39HYNe3LnbKd+LitQ8VmAqZ3kbMh8+b9ilHQNafnNnB/rtbMCfg2KDx9myRXouGFS2TETXbRiVakXAcXxC2wg30kaBHOuzutwaRw1V/IZmsTG0xjyMrbxz50/djidZufTwjnjpP5dwtri0CC1d/GrlrovdB6bPugfgHfoJhvRFXzwLcpL6P7yaM6MHoaF4cvfDr4vheOEpdK2rJpgHIlxnqq5daiPJo8q7jGyxgBiLS9VZ5MsTVLefVVwCcijEEf7FdBdavXLhO+SrAYwlR0cQC7b+bHwomVtgmjQRWjlKGk4Q0ym3L0rhWt3clH2eCxFo077T8EioZnYT1GTtkMy7vXOle5XVleJ5J4GnmFkV8QOJZj+Qbrs8cksEFSlcR2jakKqPkVSH9NFbptd/R+w9kKhxWvsrKGp1nRfJB6gwpu/XuMKkIXYFICkpQiqdRcAoELhpDiiIaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the new vm_uffd_ops API for shmem.  Note that this only
introduces the support, the API is not yet used by core mm.

It only needs a separate uffd_get_folio() definition but that's oneliner.

Due to the limitation of the current vm_uffd_ops on MISSING mode support,
the shmem UFFDIO_COPY/ZEROPAGE process are still hard-coded in mm/.

Cc: Hugh Dickins <hughd@google.com>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/shmem.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4855eee227310..e7b44efbfddf2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3148,6 +3148,13 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 #endif /* CONFIG_TMPFS_QUOTA */
 
 #ifdef CONFIG_USERFAULTFD
+
+static int shmem_uffd_get_folio(struct inode *inode, pgoff_t pgoff,
+				struct folio **folio)
+{
+	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
+}
+
 int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
 			   unsigned long dst_addr,
@@ -5191,6 +5198,18 @@ static int shmem_error_remove_folio(struct address_space *mapping,
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.uffd_features	=	__VM_UFFD_FLAGS,
+	.uffd_ioctls	=	BIT(_UFFDIO_COPY) |
+				BIT(_UFFDIO_ZEROPAGE) |
+				BIT(_UFFDIO_WRITEPROTECT) |
+				BIT(_UFFDIO_CONTINUE) |
+				BIT(_UFFDIO_POISON),
+	.uffd_get_folio	=	shmem_uffd_get_folio,
+};
+#endif
+
 static const struct address_space_operations shmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_TMPFS
@@ -5293,6 +5312,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5302,6 +5324,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
-- 
2.50.1


