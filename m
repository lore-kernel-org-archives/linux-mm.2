Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD53BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96066B00A5; Mon, 29 Jun 2026 08:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CC16B00A6; Mon, 29 Jun 2026 08:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B5E6B00A7; Mon, 29 Jun 2026 08:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 919D56B00A5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F8779037C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:10 +0000 (UTC)
X-FDA: 84932867460.30.2D8A0A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B8CB40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8Gqq6Ha;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735848;
	b=P2Py1gh+ff3bHU868w8nzaphj8lTZBDNJ2vrlSq4xEf2UB7xfjeBqqyLAsF5z6ZM6ygMb9
	/23QjBTJye8ZU//Sm9FMZRtRHpV+e9gfrRC6ACa/ANnSz3Y9+Z7GMWlvkoVasaPm1ptQyE
	C/iC+jHPqhZft/wvzF1WAW70vEewIOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRH3nWttrO+IvYqL5rFGzJUV29IkkM89vk8rnpYCL2g=;
	b=RcLLqPjy9WCp4JXpxN5l03tS10la8eRkGVcXhVPgT8QjCZi3dw7VvQwU1ctYjLEG6M4wDR
	dKpRR0JgOW/wJNf/xiRWVecyivY4wC/I7+5I3I7rgjVIiDoSUDOR550+8uwT0tMJHEg/hg
	uBTI9XJJbl5+kGryIMEGJeSwvF3/irk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8Gqq6Ha;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A334940441;
	Mon, 29 Jun 2026 12:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA58E1F00A3D;
	Mon, 29 Jun 2026 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735847;
	bh=FRH3nWttrO+IvYqL5rFGzJUV29IkkM89vk8rnpYCL2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8Gqq6HazVpY453qntgYQRg2KTWt8lZ/vexm6YznKPmhVEQVTTAOij1mmS4l/ZwSI
	 tDroo5WMFbOkWde8qHAsbsbaC7BUMYnCytmnbbeZFKhKgmi+P6btImLxdQzbC0kMnf
	 G0sUKWdf8EEgiXRDkPyQ02oipSfAG4yJ5h8dNwgHrKuvhCydec0pyvNNO72DESpGdQ
	 HYc4wXd9paiOXhmo5YiZsNonoT+FRF1LSyZ++LYVPX+wXOC/ssLLGmWweo9y+WI/6/
	 2MV1JSLmt74+aX80ll2fPEpThUkOYwJTEuePiaTIjqNp6YluviVf6MaXBwCziNhmTF
	 +Vp0OVSfIq+lw==
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
Subject: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Date: Mon, 29 Jun 2026 13:23:15 +0100
Message-ID: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7u7jkk6mch8cdiksw7a5yxaqaan7gk6i
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B8CB40007
X-HE-Tag: 1782735848-282616
X-HE-Meta: U2FsdGVkX18jo01oZdy6y1xPc3tag3GrquZJNaCzbmA4W7z7SXK660BbV29poyBB0yB54URQJbHToD9yONqacn76DvKEJGupYMFWKAdL/EPaZA92VWEtTSRQA63Dt5YHDMv73m9USuStXKSecZtdSIPwBsWlDVl0qLcEyUzEhU7FSlLwgeb8deI2VnfdEWrvHSzXtZ/RB1QqntLzx9OQJ56ZqDouDl5Hrt8ls2KT1P4KQuRdrmjChBrIZK8zVScPfLNLL5+hagoy9p+wvFFm9BA+dkGpwySVPQME/bB/Yl5k1856rdKO+W7OteKs3iRaeAsVYl24wOruTGlDuEjHovjFgHk5sAEcybK86L7xxiFn10QkeDK0pDMq8K522fMRCsUTxCQ7BIgcXoi+3EFm3hl3219keVX1NQ+rNzmE7WEIBbTUPlwF+eoABo6H3m49d3Eub9xXbhWwKzjVhaVklRNFJ1eXL0092ziSbiMCFmNKfxbFsPXuVaf7UAG6vFB8tHgu9pMvLVfMXUTwVV0Bhtc83u+H6xtTEmNp1QlePRGh0tF96aFYgJPfxFgy7xdyQ2JiOdE9jQcjfpcJHjhJny+jkzPJcCP2pLzKeOEhkVwE8KK6lfywwTa4CDrQUhH9yZSMIbovuiNEZ7l4IgUytQXwY0OXvz+Mqd5+qE64uZF+4lPonqb57TIqmftIj0YslMoX1KGPs2rhsJkooLXzSaA4VTG2KdLC2bHbJCwzoq9JOoyw/A9GIxQ+jrJ7+3MCexCfQcWum8S3Qmbair8RxwkvzER3DRs7qhZLWEPEwRvzXt98NKKhpMK6zLV3KSlbIUTRyJ/1fpIjGo8Ie+OeWr3xF8PFKCja6MhKHK/9g6zqHqbBFwjxZg/mfZip34N98alYrtdBbh0TOcx7pBtDBz/H9cNXdiGHojNIInABOBj3hQiWdJ7Mxfhwjv5jT8mPS89yLG3t5nQr0hcm95Y
 amxApmDW
 B5LacC/qi46Rfo6KQrQRNKTP2J2kV7qDlg3Rn/5IwNDnYAfdlhQGnzITxLFUQyhYFtGgnRwSsIDoBC5LpkZ327gh0aGGUHe98tUGPimOVofHgKTw1YTgFzeYFfenwVFiiRzBkFu64F3Z3ER9Aq9DUPkzAhlOwLwGvtUbsNk3AARpyuPYSCiNH8gBRNeTbRvE4K8U6K/NSZK183h1thf+318jfkApvxzHIRkVUtg+J6qPUbF558GDYpXeCiRrRVWsGE5NcY3r0hCm5+Y92N6EEVz8R/e/unGEwLj4EedvHDZja8kkVzpwgVy0vRKd2/CDX/ybPzshPPXZP6dqKl05PIrbwL0PDfYrDHMBPjCeHtwEcOPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2f00c75e66bd..e7ee315d5ba2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4298,6 +4298,23 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_end_pgoff() - Get the page offset of the exclusive end of @vma
+ * @vma: The VMA whose end page offset is required.
+ *
+ * This returns the exclusive end page offset of @vma, which is useful for
+ * expressing page offset ranges.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The exclusive end page offset of @vma.
+ */
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 /**
  * vma_last_pgoff() - Get the page offset of the last page in @vma
  * @vma: The VMA whose last page offset is required.
@@ -4311,7 +4328,7 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
-- 
2.54.0


