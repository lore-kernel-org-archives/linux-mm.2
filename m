Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC1A1C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC51B6B00A4; Mon, 20 Jul 2026 15:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47476B00A5; Mon, 20 Jul 2026 15:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DE06B00A6; Mon, 20 Jul 2026 15:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 658F16B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2B9B1C02E9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:17 +0000 (UTC)
X-FDA: 85010158674.27.D357E62
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E53640002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oNy6uOjt;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bn1va8d6JpVtah/28aJ2nDxAxk/IiYTaqElYsPWqJNc=;
	b=ZDFireqgw4/D8Z8dVpvdCL/+hzVDgWMOen7KwMq6KH+psTGjuopll3plP+mz/aBe7QJW9Y
	1ZzfqzIZ14eLlspy9EAt64+QLp/S2q1c3VQ2VXn5ms/09v/h7jbhhC7PbWExCOEPtvnmNQ
	f86G70+4SzkQtBCf+abOmBUCZYFJnWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576116;
	b=Z1EkVewoZgaOB7qqTFeKlmTdSyrkHc94L2sOlkCcZtDL/UNOHS6TqDK/e4Vp9z2zmUtfNX
	EDvGt4ktP9v9MmQDU9PyNnzcqYQ5YTYFjAVSemhj7fU39jTy/55GdOYzVqtoBqwBlHcxzn
	RJXLQkjf2n9qQuuUXGacRZdBBhu9rmI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oNy6uOjt;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92ea24a2dbfso893495585a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576115; x=1785180915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bn1va8d6JpVtah/28aJ2nDxAxk/IiYTaqElYsPWqJNc=;
        b=oNy6uOjtG8NEpC4gvvx+6ErPZXQREhaiS6iiMczPT40EHTpfK4elu6HyYIX4gVwJNv
         TzRmxRjekOae/9HrkmS6rpjI1ubOX9Xo9PTTIc2y0caLZHrfdyYSCVzkFpdiJtak+pr8
         zoafnhzDSihTcbTLatlG7ZycZ35lufzkFj0O4lvUhBaNK431LZtbr/qzd4ZxvOQnH0BQ
         vpiFEpNgzylzYvJG9eJfH/0zDG9/jzFJibCmir4hemB7xlFxmVek30Q81S59MZ84dBaX
         6CEfBrdH5gHZEGy+wRRUdEzOGf8vEbIfh7jH8giZvWn0WgdjCfEZn5Ll6YzDoowlJZQX
         Vnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576115; x=1785180915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bn1va8d6JpVtah/28aJ2nDxAxk/IiYTaqElYsPWqJNc=;
        b=hfP65km45LpsBZB0gKHhyTu3JqPqwM4ENMBhVm2w/6glGg653ZejsCFE7FxC/t9DfG
         9s2t5qduvr8+qcC31uKKkEkVNDG36KeaYs7perJEwHd5RF49X2L/oYv8Iyqdeg7ea8X+
         +8K2YEHUysdB3usI9Y/tV3pp3qlDDQFnQNcULOUmaZaH91VCU+EJioSstAL0s9Z/h0Fo
         XLGGaHcbt4DVkEcYRLIwb/S2RZH8AZh+QZcdze3We0+wB/UMI58/QLy+dhYN6YR8MyvD
         dGjDFmNhLW8ZPUYx+KcvXClS3y+nliCXAJ+ZaxIbPt+tzTDftqOuEc6V78J7omHF5aT6
         auNw==
X-Gm-Message-State: AOJu0Yz04QnwTz6hMjxbm1Am/tuwif7xdrRCW8NxrKw6oHoK2dUr57u5
	lpYzp2+7Zd32T8IwNW+WYlwOOexxdoG2kR6J5JAicnGnw3lV03u8GbtUS9r7s3Ol93yoLL22XUG
	aWJAF
X-Gm-Gg: AfdE7clndPy4UvjAKWsPxP21raw0fBDvCbd9x3yHrGkv4IXbN2bx6V5D6jTv+QIpJEi
	kiVIi5F95P71IyxkWvCZ+8jH1YpnZSIWgnvBN7Xan4hopDNllfoPb+SnM3dnlJ4a6gRcHqjgc9D
	NTwHjdbiY7+N92ZuoKye94djppBKyxSWY5QBNkSUyPB6ph0qjjfJjArw9xamM0AtGD9Dd0X6YdZ
	/4gft/jG2jsXEkEeCPXH09g8ZsnQS3/9jlvCKulUx/mdvvzMqyIl/yZRf9SW7jJfi//nzHOiACc
	WEcU4lZV9etHmsCH/RPr/XFXETxEObMUPPOMI9PNiJf8cE0K92ToidKZrtqrBzAAvIaJOfieaQV
	1QnEGXWrNeNUhMoZWtOYrnH43l0u6pCc2t2IwJ18+9bN1X/wC+a+fkHLeFnQM93HDDGiSLxhJ2l
	t7+nV4fiIJBPv6I5fDdhzUn+IXxdo7VK7fy0QlAJRGtgM4gqvXTtp1qnADzE6b6MU=
X-Received: by 2002:a05:620a:f0b:b0:92e:5ffe:7833 with SMTP id af79cd13be357-930b41d083dmr1531787885a.61.1784576115361;
        Mon, 20 Jul 2026 12:35:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Mon, 20 Jul 2026 15:34:08 -0400
Message-ID: <20260720193431.3841992-15-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E53640002
X-Stat-Signature: z9h4ifuygykeua1rosfiaigmufq7r4us
X-HE-Tag: 1784576116-419394
X-HE-Meta: U2FsdGVkX1973zhxqPzt5v5LCvUL44HU8ADxtP8seP5lnBNWklqsm+GPSshbSh149B2NvaBs7Xv4rUIHCbQ2cu8LYsg3yMYQ6xRP469+HlpNYqC44QpPC/NHsYkqmsw8Eu8pQPisYuFkR4NaxpMQhxxtzatjZcWKbMUSk9MYFz9YE2JZcZxl+LoBBoL49OL4pKmaSCtLQYf6Gihv9DPgzKCS5AjYxQD1f8VgU2FOf7cWZuZo+2jagtr6fUcpGqzNpmm5INoYqLC00WmMQWFJPdGSsufF9Q5fYndbyUGtU+I7T497DtIFwXkvbSxjbdXHeV/owEVitnWw2SYq4xTAmKYByrhS5alHthNIDhlfSYzsYinS43duRvW8d6uoiWb8DhBHskQR2oYfLs6OUNj6iQWol/PA164xDKmrX6gpQn8UsCjJ3Imb6mGVK34/hoBmbGs3vF6V0k7gBPA2BI/ZxmT4a5JyOiR86WiDrIRo+Q8NF9vCB1SXB/QmKNXUCFSTgP9KsSi6CFTMQVy8HjaYa/WquwinE0meZe8c8Qhlaza60T+2yqFhOd60rNQT3c3Ad1zbTYTXXODob//HjBNCVCN4rm2SNmH2ghFw1fFeWlqlZWV+/Rt489vNf/nO+iigTi+blvKSO6NAts8DVUSfQmMPxZc9s7fKRIDRkEzvVFk7r6MpECZu5J3yGgPDOSkir48ARYO17hsDynqCKxGF0I/zDAIk5X7CW8TU1yZPKGVwRC0uSuDI9FXOLavWQCRdfX+8DdwSFfHUu5ldFKeKNjHNbFtibiB7KNP2mGBXGV/m7ZVXOdJaSFFViNZqZpmsxIe32jw/uD1z4+nvv8/wmRyk3/yYKlTBEh3JEEJk1e3n0pGGbAPrkP6ngbvCQMWkCoUn89if4n/ltF9+FEdSaa87qco/Xch3jlzjFuMf1yAg6qYt1VBSNyUX/iS/CDXkPa196mHPe8FFyvCsnWO
 5Xct2g6P
 Ob/55+WLze+1fohJRt4WSA2uefW/GSJFOaOtU5GHtqO58UoRtT8URj90xWcVpFqUJ0j56CzLMPmj74NR8J2mzytCJoX+saBs8hmWBpuwW1n2yZ3FdM4GPF3kQLMDbwzm79oPr6ErWVcc5NCEgRmm8DGlKGWSsNfiqC2H/mv5ur8l6H7Ql16FYeFbcWVG7TYQdw3dl2Tu95B/di+w091g+ON8Yly2XagzLZySDgdi3hn7cBLeRi93NlWDkfHvxd5x6WSfQoEWXrrxLiVbI2gk1ppMu+h74LDr5/8cFk0Iak6Y1ZSm4qUmhGVuWbIMbZqrP2iqdaAO79BXMuWnZqQYfJ6jZ9LE1HEcCRRf3vvXMGKum6/N9/3xegoGCo1x8T0Grda2Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON operates on physical address ranges, which can cover private
node memory. Skip private-node folios in both DAMON's migration
and reclaim paths.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/damon/paddr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e4f98d67461f5..c741a94319750 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <linux/node_private.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 			continue;
 		}
 
+		/* private node memory is not reclaimable by default */
+		if (folio_is_private_node(folio))
+			goto put_folio;
+
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
@@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
+		/* private nodes do not support migration by default */
+		if (folio_is_private_node(folio))
+			goto put_folio;
+
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
-- 
2.53.0-Meta


