Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BD7C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC696B008A; Thu,  6 Aug 2026 16:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CD86B0092; Thu,  6 Aug 2026 16:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455996B0093; Thu,  6 Aug 2026 16:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12F3E6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:25:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2B2D1C063A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:25:40 +0000 (UTC)
X-FDA: 85071975240.13.9E95137
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E11B5140011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:25:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwpgts6a;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfET70ipzKCzRF0stqGxwRTRCOBi9eCntG9G5yTBiQI=;
	b=JL0POLGWPI7MCXwwhJKIwDwlivr2rkB/WOgzxU/jo6uw3bOxtWMdg6KaGdBkXHCfuRFj/v
	9VbjS9DiVRKcwpHJY/hVKPhIeqZ3DTN3ryvaRxew2uQ8LvcPRQ3WZqzqSeyMJXqD6ZMiVQ
	jWDoaKhU4raGFDcIlGsw8m64yAZCUm8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwpgts6a;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047938;
	b=kuQq0ZE5crX5e/7fZYsUWPrIW11XtFA2Q5YaOc+oNwtAkhUo0pExHnX2tFDwhekD/Q7hop
	/bIUAl1MnlSWxB183tAA2ATZsS9JXy6TUvZsykBbzAGpZIZ1UzFmWwzXCc5SldFWn0j+lz
	Z7OVsOHOM8R1tEWZec/LcNnBt06v+N0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A41960103;
	Thu,  6 Aug 2026 20:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51301F000E9;
	Thu,  6 Aug 2026 20:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047938;
	bh=rfET70ipzKCzRF0stqGxwRTRCOBi9eCntG9G5yTBiQI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rwpgts6aRwCIO2Kmj6JKXNMNjMTQ/36LbfymWahUV9Jp/Rc317EiIZxpcRjgbNRt8
	 onP3R0fJJJd/Fy+rQCpEA6DzvgM9nbiXbXo00W2j8kPrdNAHUmlFYjv0JJ/qEp3pqw
	 qZ9IgAQj54bNZum3sqmIZdj0WZGMAS1iQyW1mWChHLna9KIp5Ww52DkIXCvIhgo3ZH
	 oI6KknHximElYnwTT71n1K0TlQp/LftDplGxhqvxeJmKsYGSomwKQCM30ncNpsv1cn
	 KKtV1/2eMxlKC97bDY/XLdI6Yu1TJjxaRUTJDxeTk3Mde/KA7CGI1zub1O8S/Uf7x0
	 rwd7tzzDKmtpw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:35 +0100
Subject: [PATCH v4 10/20] mm/rmap: track whether the page VMA mapped pgoff
 is anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-10-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2286; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gUsQ8Jm4b1wdTqyWtNbp+uv3FdHISPYvdCAHWw1Td6A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lzYqhX/vp1DaYfVrK8yHf8mRQl15L+UXOP1faHKs
 tIp88y+dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi2jMYGXY+7NBwvuTCv77V
 Oc5PO9T8ivKlrYIXOWrLf8XVRBX1LGL4H7jIvHfq8//zGvLsjxw7yWO050nNpzOy0qKHWLNnvZi
 byQ0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E11B5140011
X-Stat-Signature: dxc67t3ktxhm3w3f1khg9tfmgasebzhb
X-HE-Tag: 1786047938-555124
X-HE-Meta: U2FsdGVkX1+aCr7ZLHvmB8/R3OlZ7vr2b7RWTVuuDclyvxrCPGio+tobxfFTODdBrLtcwY6LPxkW/aabRQ9QGGXO96wVQ5nEIIodrWTmra3hpby9Fxq7MwVHFAlJEvHst34Mgj2pIKEV/+SVoOJva9sGc/O9B00MKoXuPY7lNN0uOub1Tk9uoTSdj9bap0NZ5uj4+yA+g5/17jxFwjVt3WLD9mfSXIs07N8sGywotb9JaCcX8U6COOs4PMqs7l3NWNoMrQHv0qiNJqbLZjpfHOu69r7BaG+wzTECUH9bTC91yXWM9//TOybhU+ffAlDh3Rc13KR40r+iZU1AJqZmnkp1DcRGM2qSfc5NFHysu2221dSp84Fp72OfrWjkX8LkVyMTAo25e+PsocPydYQ5EjR+wonTpgEds/NVUx/7Xx5TyXi24pmBHJ/CWg8zpEWp6O+B1LSctTqZQ1oTlF1QXi8JpzcFZTvIRIXqMapttvnveflv5bifyA5wDD1ATQBMQBCcPk1B/+NGRUVinnChaRBOqxvaTbwrFPlm8S8dpV7M1qx0RbFigHXthMMqj5uVC/DR9v4MhnPbixDrReOyNg9BrvnE7AzRuTkD7AOT9VJ82u9f8n8pnuRGOSC3uvqiqZGOXlfNlyWJKq2J9mvvzniwW0kR/xLvSJ7DW90cA3hSCHdCAkUEffuwIv4j1aRJxhqYvuVLkWOYYzc2nBETd1hqq9dSL25QJ3JxEtUTa4RI3gvYZJBnYLHYpj4mfZUt8oGinY1q62jtZet/DiDNdL3/zupO2ZYXAlVFnyaJwYrFDdJhXijE7v+3qd1UrMNINSdiiBfZjdqbIs5i4oNA1W1oPqMRad0YhYwemWTgdQV2FAdz0vAfIVrkNsqD8I2fKstbzanpEbCdBMusYP/FyZWh/juCpncUvTRqzbqqvX0byK+sq9SXyQK+csske+gPeRZXTcr0Ueqs6Sjimjv
 rcbTtrCf
 uPl3ZzkaDuoY7PLqLSeH5f3m5/85AlHK5Kdb9Ycfve8PwzB7MFIG8lSkdUk9N6Xw69rsOcNFd/glzGGTh7K07AgPGHMBIqVNGaJNVjGwLHNGYKA2e14KFAm83al0Jmsdf+ZwiSCzu8VGWYCSuKETSrn+D7wpDpneXNt68FGgHWdREZpdXgIXauqV/M5pXlVZlXTAMr6UB9ESdJAuuhXDJVYnCK9GHBj0qZ6iUZW629UfCk9pqGGZ9kMWOWuifrtvbpsV1MPcZPobf+ceISLhB5jh44vUNZw89dJ4MiPiMcyhnqHSu9LS8DdyT8UBsTIiD04YN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the pgoff being
tracked is an anonymous pgoff or not and update the comments to reflect
this.

This is necessary in order to determine the correct VMA page
offset in vma_address_end() when pvmw->nr_pages > 1.

Also document that pvmw->pgoff is meaningless for pvmw->nr_pages == 1 and
for KSM.

Do not set this field where pgoff is not specified.

This is laying the groundwork for eventually using anonymous page offsets
as the index for all anonymous folios.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rmap.h | 4 +++-
 mm/rmap.c            | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..0574537a355c 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -864,13 +864,14 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
-	pgoff_t pgoff;
+	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
 	struct vm_area_struct *vma;
 	unsigned long address;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool pgoff_is_anon : 1;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.pgoff_is_anon = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/rmap.c b/mm/rmap.c
index 5798427d007f..ab3f879454de 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))

-- 
2.55.0


