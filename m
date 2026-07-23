Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D5BC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7406B0121; Thu, 23 Jul 2026 03:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F3B6B0124; Thu, 23 Jul 2026 03:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E606B0125; Thu, 23 Jul 2026 03:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E55C6B0121
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:51:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A4821A03EE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:06 +0000 (UTC)
X-FDA: 85019270532.15.6868DB8
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A9D440002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VSpQje/B";
	spf=pass (imf07.hostedemail.com: domain of 358dhagcKCFg9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=358dhagcKCFg9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793064;
	b=kMlytFPjMkj+8UgakW7umLIbc461HR8owPPH4gmrz1Zo7aoJ7ZzsFF9LBFZ+pDTObYZUHf
	b6ej1Bs8MecgoFPLFchQLxkQ9+ElWi/ihvjme4rbGa2n/U0qPB8/Q7mW6Nhkd+wwzcTKjY
	PPp0q+YKn4DYnGwshc3sd8jaXjT0Gvs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VSpQje/B";
	spf=pass (imf07.hostedemail.com: domain of 358dhagcKCFg9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=358dhagcKCFg9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF4CarUiD02S5s3G5AQzi1sn1tuKaUMCCFINvnzAblg=;
	b=YpG95hed2LAhfpSGB/2j9cy0K6mrfA7kn+lE6NjTd8G16k5+5sKd3l9Bucc/mIC77qj525
	oJRjjW7UewkmCYxIsTW5jGet8jKZboxhOwD7KIK1yN9tsbNYn+6E3nI8tM4+1fwWPVn99G
	O2QPHbXFOlpFvpK1DiS5r2HSBAgjxTo=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e667368f0so803772a91.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793063; x=1785397863; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wF4CarUiD02S5s3G5AQzi1sn1tuKaUMCCFINvnzAblg=;
        b=VSpQje/B3Zwoxt63AM8Fq+TnHG37TQ2ShVKXQfk5cmFquOUihl0DGKtIJ7nt1N5Hdu
         ZEk/TNIZyGHMSs4yRwrX7njsTEHVWh1zL3ENlZ1p7dC4sdjvy6kRm500jTfm7u4ucPSD
         qXjp6y72M73izkux80WNTR5hWxIA8EigizHjlysNutO5xCNParJ+5R+Ih7B3uy/i7Utw
         KLdzrV/hLyCyg4Lo77EILqKHUCS+kWvOvF8EcsKtYOSuCl57uQg0vfy0K8y/ljU3cTru
         Gv8v0rADpS8Q5qwIEw8E0T10L9d+m2MTPVswvm+UqmG+rPASLzqxIVpe1dLfKjNu9xOV
         cijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793063; x=1785397863;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wF4CarUiD02S5s3G5AQzi1sn1tuKaUMCCFINvnzAblg=;
        b=dvFrPoOD1/P9aBQjCiUH7GqNbVmUOGec5hmPTNOqgScvG6aN0tecCi0WByhQ0XGmlF
         awLb6BR4nHDro/hlt342PDTAXoH1LhW/MN9GCxsemVBRPJ/HmPFq7yVWnu/OY7J99s7e
         PHacgn1piCFhoC/xGDPCZu/dGmD1R7EVEv/HFRWDfcirCOlt/UlGUhGuuMXAkhjBHRMm
         ccpMY7N38+qmrx2wWNJES0C9qXsJxO+GSKDM8ZSoMlVHUFwB5frzr4t566+YZtkBoHjk
         sfNE5oZeHEuRXNz+kMdb8+0EQooAIe6/l8/KfWBUjQPykxKmq0wuccz4jpF60K3JCQUb
         zK1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqUsNPcd8rCOeOrcWbecVk2v6CR+s+R8mpmwRl3886TjRfTBS7XbnK4mlVGEuLq4MW5Lg9gozrNdA==@kvack.org
X-Gm-Message-State: AOJu0YykwLVp89Eq7n9octWaJenfQNQxDexOyaDjgncKTw3dhUOQpGTO
	lrGfPQaGVxhpqQiFNPrPA1isUN91+DWOITHZiYzEJOo7iBgr9WoGunjvBfD6C3r3yDnyw4+OoTO
	utlDHQxPiZg==
X-Received: from dlar19-n1.prod.google.com ([2002:a05:701b:21d3:10b0:13c:eacb:77ba])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5823:b0:38e:6bd7:fbbf
 with SMTP id 98e67ed59e1d1-38ec6a48029mr1828425a91.20.1784793063155; Thu, 23
 Jul 2026 00:51:03 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:18 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-15-jyescas@google.com>
Subject: [RFC PATCH 14/16] mm: Free pages, remove files and clean cache when
 one alloc fails
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A9D440002
X-Stat-Signature: re3k4cb7gwrgwtu9byrzjfdi3cx7fki3
X-Rspam-User: 
X-HE-Tag: 1784793064-371155
X-HE-Meta: U2FsdGVkX1+qtKT5X5Bt2AHhG5j916DE0asNG3M5uMH26vJQBGsr0XLgAQAq2YWqq4We5SMJ0me3EXuJYHiR/VY5DzPGipU77Hgy1oxXwp12WzMBdhn2/Y0ZuOz4tuBkdXSCs5ztArvRhEr2K3ATpItHWxPyrNYHXnVmr7N+QnaX8zeoytd/pa0pcZMqZuPSvC6eTp1f+tdBaIxK5W8qpvoaptXlx/y++f7ToVpgKyIASaY/L3CakFBlb/mmz4U5YgDZtS28JEXr/1vKP6RPuZ3Ah/iChMzXTxuAECTiZaT+5G7Yuvz+OPtLihli9gbeh5gxmWGUo9UUYh3JaOjcQNj+9xIakjPkhzxAG+1EdMOqV8Vaafbxm6ekDqQ3HhVgTy7fGBOad75cl7+jmIgyk85c4zwA8tBoRXkWGNHPJYAGARsvfpL97zI58FwFWQzg2hpt554/ufnedNj7Gf7Hpd0DEPC27nAKDUxLLuV/FwA3yd5Q7uCaC8Y/yrtgL7a5qAgeGOaEJZ4HtXkYoB3awyxY0vV1a7e6EIuaUs67akrJXGmgcH727Lq16EHn6i6uge8+8fGrqLrzf4qNGd65N4hu/jX7RM/PIO6133yTNmMAkkKQFE507wguEodHxWQwwd0qhJmfEg81cJYWipBiwKgVPJxOza/W94nnuumPsZgqL/DfHnOWh2abgsVfOwdoOX4AIQvWoeJ3hH6ZX9lzWzgaibtxZ82JdUwyz0y0UjO1Zdd1/iZBgul6oUqMzlqHauMDcWKaHlc/FbKs8AfD937QNLzgnTWX6xcrhRfr4kcQaJNuXJZvAl5Tawt8yOqwLwS5YOA/OXbS/qqUD4dLhqUEuMU1qTZWaoRR3xWNcWmuQLhW/6Ck1HrFNCkwnJKQ3kHHYsFKGm0yrSl82zA8yoF9hifeqqjX5dAvFveUd4IUOPBERA9rorHrjQM8uosBn0xZqWC+p3KR+VgliG6
 Cx2/5jgy
 N9PL2r+JBiZD/cHbfKJ0YOYZJIrB1oeNqU/M/zkU/c+2NywHH3sqabQbCuhvCkGTjV4TCkeP+SoUjZiEgip33naAubbo7FMX/g38011FVMXREx52i0GsKsfUV5j81PW8DeoHAlG6DV68Aueky2a71yLqvNmz59HK74Cq0khaLBfO2pTOlzxejhKTHpAMkC+mZC1MzqzzlR78ODLlR6PY1lROUQojGabm5sxd55IOBVmLFLzt7jHZrLHxvV4Y0ZxwZsuA+FJN5Z10oPEpK2gfXSdLQAI4OSjsZHp65Hzg2ushG/WLjcmZZCEhXCDJYjpholmLMMOJUF+Nbm57JDk3Ck5jj8AJ0qMZtDQbbhFEgr9Hz7YXPT0LGtGMnpLEY5Qi7I769uDhZP7PeVkq2u4j+5fPw2Cko7UN1ero6W+4hGQO5od8yYR2qET/21oQxL5xZ8PhrM/5pnu8+Ms+mms9qFqHIGkBg27OvVmvTSZVrqWF7Lo7nIRycxNyAg20kdNz06faaXKj3dWkaBtVgRo1oo++h2sKphuB/36s5idPvQ8rccYB69VO2xIZj+0qTZfs5h10/gIVLBl7NF/WP42b4DkGBJ/khLkWzZZOm9zd0yF5uwvNjw4lYdchslw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When one of the requested allocations failed, do

- free the pages that were previously allocated as part of the request.
- remove the files that were created as part of the request.
- clean the kmem cache.
- Erase the struct page_alloc objects from the xarray that were inserted
as part of the request.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 203b71a25e64..e65aac881ec7 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -253,6 +253,23 @@ static int make_alloc(struct req_alloc *req,
 	return ret;
 }
 
+static int free_alloc_helper(unsigned long alloc_id)
+{
+	struct page_alloc *pa;
+
+	pa = xa_erase(&allocs_xa, alloc_id);
+	if (!pa) {
+		pr_err("The alloc_id %lu was not found!", alloc_id);
+		return -EINVAL;
+	}
+
+	__free_pages(pa->page, pa->req_alloc->order);
+	debugfs_remove(pa->alloc_dentry);
+	kmem_cache_free(page_alloc_cache, pa);
+
+	return 0;
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -294,6 +311,14 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	return cnt;
 
 free_allocs:
+	/* Free all the pages previously allocated. */
+	for (int j = 0; j < i; j++) {
+		int ret2 = free_alloc_helper(allocs_ids[j]);
+
+		if (ret2)
+			pr_err("Unable to free pages associated with file %lu",
+			       allocs_ids[j]);
+	}
 
 	kfree(allocs_ids);
 
-- 
2.55.0.229.g6434b31f56-goog


