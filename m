Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C23C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3B16B00C4; Mon, 29 Jun 2026 08:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C516B00C3; Mon, 29 Jun 2026 08:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDE46B00C4; Mon, 29 Jun 2026 08:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE2D6B00C2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B25811C3555
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:42 +0000 (UTC)
X-FDA: 84932868804.08.4661AE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2036520004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2YtNTBC;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735881;
	b=mMQnbx79QeQSAWahwPMtoDC9nobnuGqpxKrMIPWsnkGiOQX0gRRQncX5aVeBjuFUFC+AP+
	Wf0Q3EDq5YNm4i57LxtOftN7fJJGzTEgO14xQNOmzE6PWYWaKnh4aQCe7ZaSLkG0CJ1FV+
	JPcsrdKjgVuvEkBoS5RWipZhDqenTts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+of2eJHuR5dNuNJiS3cZuvLehUoHg8ljbLqq9Ah0AQ4=;
	b=PVyY8qxaylMxYrk+760x33xDfQTFUKCyU+z8Ft9Wq1pxa7PQ3lHSS0u/KjrXkm/1V2nnou
	QkWr4Kz4UDPeNYIMdl5fkqSUB1vDhM6hUjH+SwI2dRhEWaj3NkDFbQeXLp3V+vYKlg/cmC
	iKz1no/RhlvF7bF86ymrSz7WVsehKwE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2YtNTBC;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD0A9600D8;
	Mon, 29 Jun 2026 12:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4A81F000E9;
	Mon, 29 Jun 2026 12:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735880;
	bh=+of2eJHuR5dNuNJiS3cZuvLehUoHg8ljbLqq9Ah0AQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2YtNTBCsJFLeuggkXoygsgvXPGBhgysE1dL0jJxSBgEibKwxrxBKBVkCF7H7B5B9
	 CMBhr61zOts8FtzvxLocHIiLkQyF7/jaK21luzc0jjR0RUO8+CMng45Jp6ysrpb9aM
	 uY84Roia6rA0mFTBZlwUW/I/+znMt4CVrXrjXH2ChKSWcrSjCWtYc2HfuwM1FyISP8
	 vbmjmSzlxQ8mXIczOsJ5mRC89LLsZAg8F2I6xVLDYMZyT40OqQHfzXKe2Yb0HZTEpY
	 wC9fvuVgpJy/8Haqy9b9YseUpf27o/EwJ556JfcxFLzbHK5HwMwqJpR9v6i99Gr9TJ
	 w7K5/x0UhwFYQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 15/30] mm: introduce and use linear_page_delta()
Date: Mon, 29 Jun 2026 13:23:26 +0100
Message-ID: <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2036520004
X-Rspam-User: 
X-Stat-Signature: 391oa5c63w3twpripynfum368xepe7ch
X-HE-Tag: 1782735880-407593
X-HE-Meta: U2FsdGVkX19wd23ih9ZmUTJyqjbYhlk0iwxce5TQNPAsTyEveaaIRtRVQIfhAmjCC7qjEP06WbQssfZ1Z31wPpFa/WvFiiwZYaGzHg7kQt72GCCdzwG3Hnce2ErAbe+XzGfZwwhJWbmieNdyx7lZ7JO9Fgp4svPLJZPJ01RgIBCwBkwHwrpBaz2CZ9Mj2yfRtrUOJdZwpaLuZvu6Nk7hmRXWRgeoAD6rQ9w5OEmK+gt7WNSSzvEgl0IFn94zjTBR9YpWlh9/HlTQd5f5ejLGL6Uhv/hihBrPv8BweGT/GOz2yaZyhHcWEQVS0n00v5bA/a6A2tMflcd4QB2tjxjrzbFErELel7wKQ4cINEc/Crd2zXJM5qVRTONGmmT/hpDMFMo92wJRj1VnT/eqBH+HmxkguV71cIDtYeNsOPK4Xog6wyExC/PQENv5e/4F8WGBhlA67PreHRoph7bQBnpS3rimXd3+NaxP9pSnv/vGsVOdRds/sqr/jyQzJpXnbIPR00x5hY2IrcieByuzbPFyu0kLhxU+AGqJ5yAvLrdHxYA+QTuqCpJft3c1kxbC4SLJfn6Z3Xs8gI69n43c5f1/skOhebRM4WQKJltLbmuGll9Cr6z4OSkgxYnZ2sUsBVDJo9T1y7koBgHgdIAEJ0FsD7DIY87IwOWuR53sJ4OXdKLVtGgFOon5h4EovXNMBMEzDIG5Nn9sFJkARO9+niefM2k6rn1a6w+yeCYyj28W47K/dFifKRk+9WQuopDubIngMzVPENjqtIPm0Qs8vQURbGM9oFnA0PNmRBYyjF8Ecll8YtmRpE3T/fz+q5+7XPureSZs3UVeXUJ6eMh8U5OdIy/qGc3HwTPv/gdFLYZDJd9gmQhE33jXPk5LFs6kNB/05OwumbBiILxUHfY8Kw/ej7FX/12xEcV/kFX3eOoGSDJwIIjctRgr5WkTktMZgVgdjltIZnyeT5NZeI74hY0
 AyH8hP8O
 +5Gm69CA+Q3UDykeQTXwLkvW6FbGGopk+YTkmnLxqSftxbjpKPfT3pjHChvSfcphgPo+25sxQgDOk71ZkWy6xnb5j/Sbz7HKZ4J3tsXQoioZQp1KK8jcMBKM0nydRZ4aKzPSdQUniCXG4vv/HFCVC2/DHonDpM26LI2wOf4HzvYllKzm6ayLjD7vWVGKidP1IXllj3w8mEAN9hlJ2OIVaS8STIY477QDl1o8GDrMIHuHm0dIXiz4XfV253DxUBhLa9SCnf03pxaJEWDhElGzUVrYs/ThaT9UfRdQqRSiX2PcX+Ri6EilRyySnhG2q4XroHTYy+TmLcjXJ7fvfXupZjwE88JBHJn+TvITZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's often useful to obtain the number of pages a given address lies at
within a VMA.

Add linear_page_delta() to determine this and update linear_page_index() to
make use of it.

Add comments to describe both linear_page_delta() and linear_page_index().

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/pagemap.h | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..644c0f25ae73 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1063,11 +1063,44 @@ static inline pgoff_t folio_pgoff(const struct folio *folio)
 	return folio->index;
 }
 
+/**
+ * linear_page_delta() - Determine the relative page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose relative page offset is required.
+ *
+ * The result is identical for both file-backed and anonymous mappings and
+ * simply determines how many pages @address lies from @vma->vm_start.
+ *
+ * Returns: The number of pages @address is offset by within @vma.
+ */
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+/**
+ * linear_page_index() - Determine the absolute page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * For file-backed mappings, this returns the page offset of @address within the
+ * file.
+ *
+ * For anonymous mappings, this returns the virtual page offset of @address,
+ * which is the page offset the address possessed at the time the VMA was first
+ * faulted.
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
 static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					const unsigned long address)
 {
 	pgoff_t pgoff;
-	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
+
+	pgoff = linear_page_delta(vma, address);
 	pgoff += vma->vm_pgoff;
 	return pgoff;
 }
@@ -1219,7 +1252,7 @@ static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
 void folio_wait_bit(struct folio *folio, int bit_nr);
 int folio_wait_bit_killable(struct folio *folio, int bit_nr);
 
-/* 
+/*
  * Wait for a folio to be unlocked.
  *
  * This must be called with the caller "holding" the folio,
-- 
2.54.0


