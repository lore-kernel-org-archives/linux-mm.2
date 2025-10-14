Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D989DCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405D08E0152; Tue, 14 Oct 2025 19:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6A68E0041; Tue, 14 Oct 2025 19:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC9A8E0152; Tue, 14 Oct 2025 19:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B05E8E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:15:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5AE913BA27
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:17 +0000 (UTC)
X-FDA: 83998277874.08.632D7DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53B391C000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nxd3Win2;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760483715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8wwcsn2rHV82DpS6Ecdkf6voQq6mgSVsI+Zkz9YIrQ=;
	b=vqJWgWHJQ1gxasVUs1gdxjzf8gsZWMzKeE0c6VpyYioFbfbbG+eLPU66jyZ7oT10kRQHRf
	65nivvKOP5Yib3/NjM/gAJ39O1BlGD56vLcKz30hJE6wG4AqhiidBAzPM6mHNdkdKooEVX
	AoFgHMvUaJgdu5EqWZiCY4f6K6VHysg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nxd3Win2;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760483715; a=rsa-sha256;
	cv=none;
	b=EE/wqnC2vqfKFm2AYj36xRHZ6Sk9MqYKkYG2tmJgz57pVKaqsl6MyI30skKL7kkThHyi+B
	OI/1casc54QzP4v4hVT+2lLRa5uJr0VsvAD/0vBdJyn2JtdF/Ogo7U8TgEqxxiGRLn3RXQ
	PeEVadEhq+1CXcP6c3GPhqJ0ZbfJHYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760483714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8wwcsn2rHV82DpS6Ecdkf6voQq6mgSVsI+Zkz9YIrQ=;
	b=Nxd3Win2ILt6N0CO7AV37vplWHnz6PyXS72abd2P95P+OiuPKxjyFFHKLdeUEyLZvHvmFP
	d6qaD0nhf7zV1VexrnBqSDb7epg+sZXj/BDQqFaLcU1uAtHz3ci3ugfx2y3QUTJmR/5JOB
	kfEZA/ABqL/Q5vEbQWusqbGdsVr+/Yk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-14DnLqwjOrCGe0fM0p3q8A-1; Tue, 14 Oct 2025 19:15:12 -0400
X-MC-Unique: 14DnLqwjOrCGe0fM0p3q8A-1
X-Mimecast-MFC-AGG-ID: 14DnLqwjOrCGe0fM0p3q8A_1760483712
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8645d39787bso3778736485a.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483712; x=1761088512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8wwcsn2rHV82DpS6Ecdkf6voQq6mgSVsI+Zkz9YIrQ=;
        b=Ur9ylVnFp/jOGp4VbB5pUGu6ZKaErsehDKbfTRODtiNgthlRPkbGPRD6bmL0VbNkSR
         0YMSriCzo+LKF5vGhYmB+Ppe5BiVsKCbhGRL9cKDvw2dQmjk9twfZ/f90KcJsJlQEuXT
         lqIMziykeN9Ocx3/ZhtX5VUDdJsWL63K/bCfIDEyz4cciT0Mzu8GXQWNeJueruVnY0Fg
         jqlVJ/5tYR3d8jv/7b5JmuhdyNTvXEjnRNaQbve+2datDBcUsw0lus6SbYrvfB96O2vg
         zitxugcFmqONvQXIUmPP83X7ZpDESxi6E3cB+jp34AKddnuexvr7qn5JXFBqGSCCSl0B
         nYCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu+exQMSN2Qd+wReDqSUg68oFuuf8HjGajvwN9ePUcHBqRQTu55cpOU7W+mfjpClSOp3C6F9EkIw==@kvack.org
X-Gm-Message-State: AOJu0YyH6I7IdSDrPiswOOLKn5bqo2lIw7MmPI/TIOgJFFv89Obq5DrR
	KnzTtbpmSxC4deuvXYB6+/BltXW0tdUcTuqtpBEErDdZu0MZ0Qalwd7h1RMXo7vbr5Qbj0txJRt
	4QBjiZChixldAk4Q7bK7kD6VW3Jm6mwn2YtVMxCJxqhNX2y5Zul60dqz4kY8a
X-Gm-Gg: ASbGnctxrj6um/+3Zy7nCLVDZ8NUmW08eOmtNSlDkzoNfbFe+nl7I9T+B34Yw2+E1VU
	DfZzzHyhOcE5UMIat0iuRyLCH8rOHzfOTyG2CvJoo9ydQZ3Eu3jMw1v5ZiV6yKQXs9qTFiQYce4
	i/lRk96OEPHVAkjU62d+s/H1hN/V4EIoBrWkyK4MGykn9WBDlviG8vaCWJGTQkKUAYqD8O9Q6ic
	j5uphIcw36qgX3BGtIq9y8wX+trF8JP2ZWg3O/hwTyH6JupHNLrTTQKWC6K3GAagiwspoQ5iwka
	7iAgfqzZ+bgQLJSv1ixYpx2qSg7+BQ==
X-Received: by 2002:a05:620a:2953:b0:85e:96ce:e833 with SMTP id af79cd13be357-88354caeef5mr3364650385a.67.1760483711945;
        Tue, 14 Oct 2025 16:15:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtVJNooIhMfiRlFPnpx83oUPtb9evj6TnuhZ+j9U679/QGWdl8aBsJeO1wqsoFRICR8/NLsQ==
X-Received: by 2002:a05:620a:2953:b0:85e:96ce:e833 with SMTP id af79cd13be357-88354caeef5mr3364646885a.67.1760483711349;
        Tue, 14 Oct 2025 16:15:11 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1280258685a.53.2025.10.14.16.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 16:15:10 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v4 2/4] mm/shmem: Support vm_uffd_ops API
Date: Tue, 14 Oct 2025 19:14:59 -0400
Message-ID: <20251014231501.2301398-3-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251014231501.2301398-1-peterx@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: au5oM75XT8D6I0Z-57a9jAYN3qewrraeFjlzwkRKO3w_1760483712
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 93a4xst68ps7hay8dqymoqisx7ukbu1h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53B391C000C
X-HE-Tag: 1760483715-35034
X-HE-Meta: U2FsdGVkX18QM+DYiziiHMUr8ZAxYo70wqLJ2rmVdLnIe5vKKkVuy7NzTlbvIm4xYtZE8MA5u5619VBIbyMXbRB04xkzgjkt5uE3KcR7RKqR9rfy9mxBfg5l8m0OKCdHhOCaQ9Dd1+A+y+0DHI7GGDEIxQuIel7kVUQk8gtddy2gB1Vt8MrYwAeWCmZb8+G/oYXs5HX1NIJWc3vjATyuU3hS+OdKCDQGJsMz7kJER9M6eOUpR0re54EsqErhV1w5IA80+hj2NAU2H+hETfzafju+4HHy1JZfo6/bz7lZxztRr/d52r/tFWv+RSqw7YdqxIvmtxcNpHFeWnIPSlpg35HGIeHUyIB0GqmgTMyl10KrdRVKsCeanG8usJFf31FSqjGPZ4MfWp2xl0N30o9G9SBPWKsRFSwGKe30J8Ul6ea0JyrMZtvWTiqKuDu7jA6uzLVmd5uaHxGfQh5FeAH+JYHKz+WnWT219gepWji7pFn5KZq3wXT3sGzGcD8lrdNHXwFzHl5YSIGokXWXhDZEcEcGFi0VvQQ1XuHCuQQL+60t4pN214p2OKR5f/WMWt4T+oqM1X24WzKJJ5LcEzuqvhxYFsAywYtLbsw4C8WKUW5X93OplqVUWKAEgGapxo1xYCocUfjv+0vZnkR4B9wns52jNfrXb27mBzUAex9bdZn9ul5mqB7aY+/EdTzSTLafMLaJI0rfu1BJRfYxdQBvL6rjfEICDAs9NDliA0xfQn00TIquzAwexaiokQZSvIAs7uy6bZFLCJ5QF34cRe4x5ZBwEKTtL70LnLPkvaO+Z3+IDKg6sgNxjfdqQmd4Cpr3AZqjUJ9SBLrGilrqvmykoMRLpZtpsJ3uyvYavsXxKsuq4MxFusScQRgfo8kbUSzxSy1HyDLrn8q0mc1y1DuXkO2urLUyMma3EQ46aycEjJDevMfvUt+nX3abqF/hznA1XfCLv5Q9rrYLU5eqM+V
 VjKwwufC
 jSb/p+jFwu4IkmUWaAsTWNR+qjqpg9tpHqfcO+EmvcGyqRMTTv+8C9VdyifTRqvb3ZKpHFl2qxGCvl5A3TDp9ZXx5Ce1b1ZEjj0qVjdbwq8lJcLZXcSm2kOqupr0ZoH5LSzpdr2bEruIJcFT6xkSVXdem2bbtnDnC6Ht1xVCyzTZH1UzcSHIaux3vSAgAPjiNhj3pzG8PTiwT3XLa9t9hgxX3SDZAClwK550da8n56BHK20dnZeTlToGg3rFEso8CrIzGUk1UjkZvdXCJa99ISuI6dcnCYeOgNlSlr9rSFB6rCmHxlFe3fcETPxV/PtPeN+BtOmJNj76oLsW/62R4jh9WbGedHKBB+vT/jiszLrF/xu+QZFnxeN3CXVWxnJrmDkCplB/bHYFWd93nqPe7j4JxwHjW4qwvQVG96LF+jpmNHFerHLZxyzi7w/UWU6cMcKzITbuCWtU6EhOLR0U9W7dWkbsgxBve/zi2U8AT4Z+98K42ejzsWtokdaGlmaGv9GUvwrPNn6q10wqbSCQSjmmG+3bcKHPZhnx3idT1ELIck+pVijMYxre/BfMN1SgGFq9bYA0t8AdUZsbwoQqesjaUEtp4sYBFmV7/mf50eXsWUrvNgvQ++uacdaVfphCKJ8cxb0oIXA2xHDLoOV7KcQ6UzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the new vm_uffd_ops API for shmem.  Note that this only
introduces the support, the API is not yet used by core mm.

It only needs a separate minor_get_folio() definition but that's oneliner.

Due to the limitation of the current vm_uffd_ops on MISSING mode support,
the shmem UFFDIO_COPY/ZEROPAGE process are still hard-coded in mm/.

Cc: Hugh Dickins <hughd@google.com>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/shmem.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index b50ce7dbc84a0..0be112689f9e5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3146,6 +3146,13 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
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
@@ -5189,6 +5196,17 @@ static int shmem_error_remove_folio(struct address_space *mapping,
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
+					BIT(_UFFDIO_ZEROPAGE) |
+					BIT(_UFFDIO_WRITEPROTECT) |
+					BIT(_UFFDIO_CONTINUE) |
+					BIT(_UFFDIO_POISON),
+	.minor_get_folio	=	shmem_uffd_get_folio,
+};
+#endif
+
 static const struct address_space_operations shmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_TMPFS
@@ -5291,6 +5309,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5300,6 +5321,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
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


