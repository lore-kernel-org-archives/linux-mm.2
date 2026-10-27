Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB585606A333
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iCJeniYz
Received: by kanga.kvack.org (Postfix)
	id 914BC6B06E1; Tue, 27 Oct 2026 08:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E646B06E3; Tue, 27 Oct 2026 08:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71BB66B06E4; Tue, 27 Oct 2026 08:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFED6B06E1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:13:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 745051A0962
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:21 +0000 (UTC)
X-FDA: 85368296202.16.93EFB2A
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0DFD11C000F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCJeniYz;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31R7IkymhbZDSeMb1sPHaT1Pw064ctHxU7ykW6z0bv8=;
	b=s6ieaaYbzeQAVGfMzej0wKaRA3sUnTl5oVLZIgdQW5cCPWR4gRfSl2a2YxdF24dwsUnOaO
	o38eZHi2LegSMPTUubFTYw0S3Sw1bOK1ySSLb0f0scPnHP/GkwTD37hGFN3Rj3GEhf9X9L
	QT1UdGHgIyaAWD5ciRLGUdFfz8+odpk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCJeniYz;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103199;
	b=UsYqwC7zwcFL+7wCrfI7e4dkvSDyE3+F6cMs1Vbl4lhhg4gFUU4A2L8Nd8Jq8FvbSuiOi/
	LiYQzlda365TEnGLWLRiVk39+QdCOmCw598T4T7VTWuQOBnNWnsklBsd7mxm88GrYhawum
	83KJgezacPmAGy/8SO0cvFSKeMgk4wo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HldebiX4v8c7RjwCxJgdnN1Xxuzre2SESHSjUs+s7LU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793103197; v=1; x=1793707997;
 b=iCJeniYzOeQbcAQXI5BCvajlY+VMzjI76dvLPSVfX2sneLffZcubV1o9wLRVYrcjxnZws7cN
 FEK1oO5Pmqg6ZAJRDivxs0RExlDmP+L+juUuH1Ht7QFL6BSk1ePWhJPiBiK/aV4HigQKrbvy3iw
 5t9ksfvI0x6DDXWi2CE/eTlY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 05d4f9fd0d387be9;
	Tue, 27 Oct 2026 12:13:17 +0000
X-Mizu-Trace-ID: 05d4f9fd0d387be9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	josef@toxicpanda.com
Subject: Re: [PATCH 32/46] mm/memory_hotplug: avoid races in pfn_to_online_page() with dying pgmap
Date: Tue, 27 Oct 2026 20:13:07 +0800
Message-ID: <20261027121307.40431-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DFD11C000F
X-Stat-Signature: 9z5d7cyqmc3363q88mb7outxjh86rdnz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793103198-464705
X-HE-Meta: U2FsdGVkX1+gLt1lyk96FnbOtctyvc23aDkPUcLiAiq4t9PTzZF+qHZrs8PSvNCNlk6lw3EkgipXTskEbF+spkO+aFJ54kOnXCuYJC42Oe4UbOX1neNAEgNurSQjglMcL3eqV9u4TQmI/k9Xf66RiRSsH2aatUAFbuUhVG4CmXeYLcjY8IAsMrAo6SVQ7EmT1hJoU3th+MkmDzZlGJyFief5bILm2ynS5FC/cROqkomIjO/ZJAlEf0Rxlfu4WUNFuIs59wicJ7KJk8Vk7zWawclPUdUD/lJYaAAZVgKVxUGu7RKYCPG7JNb7omJQK68ACtcZjAVuZUy7C/MJcs3J4pvGj5EKaAaHUWhMt+fQgOC4T/lDmGW8qxl8Vkylm7tgM3O5oiV3odZ2u/o+6puZ/pU0RY1qPUjGWOJc64nPty2icuOAwv/AcoUAiRwp2WbmUiqmkOnM30XhvQxE3LfpTEwh6kpVNP5m92VGEq3IzG3+QeoNjnQj9B0Nc0JXMvD5hnr5yYRYtdQwyQ9tiD4zyPh01uoK3hTAtrXWotzcZHm9Bby9Hv26lYoJr2UehMt8CyLZd88o7adHJys1cw3JnN5Zwz8JEv00AIduP699kiavOIvmscIHLrRFl9z/+2qIiznQw6LisH+5Dk7DJL0kMMObqHUQQjO2rQX14cpc/+KHw/dlvfpnkvwyzweBDFjF08hQXH+Cp1Hh+gi3PtryVeMB0Tnu/bmYFOrL66k9K7EeRLctDJwyYQ53LUz84xRcMTb/9RHkCErl+v01AKMaB4SOMXN7o6bxZVOatXCxMofmr9DyToK1rNaTHhlRt2rwUvLoDG0gDCHYscm699oqkSpjCEPBlmXvVksmcRyP/9sqIubQHKBp4fmBmVLg6pUVUug3+7Vwx8I94VYYfEWL/OEeT5TSDyDQHhc6q4PctR9zSlA8GyQ1gtCKeQpBMsjBJ9G1hK9Qe7nAch/aVYL
 3CjmQCf0
 fsQnaIdztyGWFo56Z+zOXaxRZPyDIOWEk5+4+7PTPjew8BWO2A0vzW7zQ3iteNFEMAxcoVgumlmK9H6QGtWlbzl8/N7v5xDnjS/4bYpJGq2slCS33Z/8SmoDD4bVQzgKl6PYqfXBXaNfifWG4bRl5w4FLh7vxj0ohPEDW33x9eL31kcLAktP0PVga64xDWA2PUPZR2pg6pxYMcS7+o3Ppc+a8J9T++KN4p2H6wUg1tdee4OfCwEKYDKJt/IJA+/ZoXVeN/SwzfnDiVoGLBoRL0w6YePbvU2Gp/+L8XMYVFdi8EIWAOM7MWd1ktc+ZQAzWbWSZ+qnj94WTJ9rubcKCElQRQTW9Jn/FEYZtI0XTG7/pN/Wo7V5w3UOp56gcA7U0oc2oS3haor07Say4frjTIj5CygO6zCj+jRvzJS6vuQz/H2Iw/LF45gxMOPROWJLOKQB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 27, 2026 at 12:17:52AM +0100, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>If ZONE_DEVICE memory shares a memory section with ordinary memory, the
>section is online and the pfns of the device are valid.
>pfn_to_online_page() tells them apart by asking get_dev_pagemap() whether
>the pfn belongs to a dev_pagemap.
>
>get_dev_pagemap() only returns a dev_pagemap whose reference is alive.
>memunmap_pages() kills the reference first, waits until all pages are
>idle, and then removes the memmap. During all that time the function
>finds nothing, and pfn_to_online_page() hands out the struct pages of the
>device as if they were online memory. A pfn walker reads them while they
>are poisoned and freed.
>
>The entry in pgmap_array is only deleted after the pages have been
>removed. Look at that instead of trying to get a reference.
>
>This is probably not worth CCing stable.
>
>Fix generated by an LLM and sent by Josef Bacik in private.
>
>Fixes: 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions")
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> include/linux/memremap.h |  6 ++++++
> mm/memory_hotplug.c      | 13 +++++--------
> mm/memremap.c            | 13 +++++++++++++
> 3 files changed, 24 insertions(+), 8 deletions(-)
>
>diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>index e3c2ccf872a8a..b5e5e626c7a59 100644
>--- a/include/linux/memremap.h
>+++ b/include/linux/memremap.h
>@@ -231,6 +231,7 @@ void memunmap_pages(struct dev_pagemap *pgmap);
> void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
> struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
>+bool pfn_has_dev_pagemap(unsigned long pfn);
> bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
> 
> unsigned long memremap_compat_align(void);
>@@ -284,6 +285,11 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> 	return NULL;
> }
> 
>+static inline bool pfn_has_dev_pagemap(unsigned long pfn)
>+{
>+	return false;
>+}
>+
> static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
> {
> 	return false;
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 796af1028ee23..5a972d7a9e478 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -342,7 +342,6 @@ static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
> struct page *pfn_to_online_page(unsigned long pfn)
> {
> 	unsigned long nr = pfn_to_section_nr(pfn);
>-	struct dev_pagemap *pgmap;
> 	struct mem_section *ms;
> 
> 	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
>@@ -363,14 +362,12 @@ struct page *pfn_to_online_page(unsigned long pfn)
> 	/*
> 	 * Slowpath: when ZONE_DEVICE collides with
> 	 * ZONE_{NORMAL,MOVABLE} within the same section some pfns in
>-	 * the section may be 'offline' but 'valid'. Only
>-	 * get_dev_pagemap() can determine sub-section online status.
>+	 * the section may be 'offline' but 'valid'. Only the presence of a
>+	 * pgmap can determine sub-section online status: it indicates a
>+	 * ZONE_DEVICE offline pfn. That includes a pgmap whose reference has
>+	 * been killed, its memmap is about to go away.
> 	 */
>-	pgmap = get_dev_pagemap(pfn);
>-	put_dev_pagemap(pgmap);
>-
>-	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
>-	if (pgmap)
>+	if (pfn_has_dev_pagemap(pfn))
> 		return NULL;
> 
> 	return pfn_to_page(pfn);


LLM stumbled upon a possible race in kpage_read() ... 

Say the reader passes pfn_section_valid() for a device PFN in a section
shared with online RAM, gets preempted, and resumes after
pgmap_array_delete(). We'd then find no pgmap and return pfn_to_page(pfn),
even though the subsection is no longer valid ...

Could we take the memory hotplug read lock in kpage_read(), covering both
the lookup and the metadata reads? We can drop it before put_user(), once
we're done with the page.

Maybe along these lines?

---8<---
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 6aa99e42ec22..12bed36d76dc 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -12,6 +12,7 @@
 #include <linux/hugetlb.h>
 #include <linux/memremap.h>
 #include <linux/memcontrol.h>
+#include <linux/memory_hotplug.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/kernel-page-flags.h>
@@ -77,6 +78,8 @@ static ssize_t kpage_read(struct file *file, char __user *buf,
 	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);

 	while (count > 0) {
+		/* Prevent memory removal while inspecting the memmap. */
+		get_online_mems();
 		/*
 		 * TODO: ZONE_DEVICE support requires to identify
 		 * memmaps that were actually initialized.
@@ -101,6 +104,8 @@ static ssize_t kpage_read(struct file *file, char __user *buf,
 		} else
 			info = 0;

+		put_online_mems();
+
 		if (put_user(info, out)) {
 			ret = -EFAULT;
 			break;
--

Cheers, Lance

