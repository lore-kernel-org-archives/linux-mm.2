Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608DECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20B36B00A7; Mon, 28 Sep 2026 13:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD33C6B00A9; Mon, 28 Sep 2026 13:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A706B00AA; Mon, 28 Sep 2026 13:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A28616B00A7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:21:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F67FC0273
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:21:10 +0000 (UTC)
X-FDA: 85263836700.04.83EE709
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40F331C0011
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:21:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=qABfvtLV;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i pmZ6q7";
	spf=pass (imf20.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSkum+x883OTq00st7eT1eBmqnsmeRjmxXUWAqbPki4=;
	b=aH8VwDNrrnsPUBQ+H7ofMtQ8s76KO3tB5COjbOr6W/LH0vLvovk9NpVUKl0qhn2fuA4Vzx
	C/upTYFEnNfBQehQSDrHb+CTrZY3GYEVA2wcE2GEhCn5/kWdCMO3zEdtztIhTMGBVQQoNl
	Kz5GDASyTINUD6MTQE2aQYYBG89P3Wk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616068;
	b=z/mRWbsGwPseEBlYjkRiew2y52nI7owBBnXY26bfrJ8RnzZ93vm2mbnwRHskGtpeuy/RN5
	Bodu2OF/V+H+qa7OCeZpKl9UfsCf739Ai6C41ZFd+a9AHMYfBrd9XxyTpqBYV8CMa0uNVI
	k+xUQBbZSjmWrH3QqTcJfR/Se0l1cQk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=qABfvtLV;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i pmZ6q7";
	spf=pass (imf20.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id B734D1380505;
	Mon, 28 Sep 2026 13:21:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 13:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616067;
	 x=1790623267; bh=DSkum+x883OTq00st7eT1eBmqnsmeRjmxXUWAqbPki4=; b=
	qABfvtLVTAv8QwI+jBWU6wqRiPsnNYgQhwrHOTKtV+Vn/VkwlwKXnf0QxLiw+Gj7
	DVnlLgauwWV3qecXMWYFr147+JPN/Y0/qJ7D1vvHBlk7PtddYnwoKl0051UlSEhd
	m/EIsgrkR52yAjRROuaPP4GOVp0kA4vuSPfoEmAWJ4LD0TevsWCrgTSa08yVst4p
	5Ft0KJnrBAExwCm3lafE5fiLekTrtAHMEn1+N7XlnFv4U4s5Wmj5aao6nWewHQR8
	nXAdTvBFZr5nrTNhag0AoIYkzZZ14DW6NhJVrE0ZQ461iz5ZPHET7lhWRk7G0J+K
	feFQFFXApIRlmuzzxz5x3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616067; x=
	1790623267; bh=DSkum+x883OTq00st7eT1eBmqnsmeRjmxXUWAqbPki4=; b=i
	pmZ6q7XKgqJQ1C06s/7NzbYxQlXX3Fl0zHeReIYK4wWqQfMeYbGzrkTgwwtIGvKt
	TEKfHKMSZnD/pomXRk1KCIiUlOEjAmFpoartLDrwrseadgb38+xExzW5iNH7ENiw
	hS+QyIZUY1Nt6ibFu928VXML3e7u2IndEuBAGCnn94fmNFqr169LzH+8aiapioV4
	FWJtWEZQfbdHm39p8XuiDsaBYHc/bFljyFEIxTvUO7tOiZoQPCvocVEmLe4Y2uvj
	glelolt5XX2gdWxuN8wV1+bHhDc8uctp7hsLZqwdTqeIUMlAtjImE3UyGoSIs8zx
	0mGJk6e0D9TY7gnZf30bQ==
X-ME-Sender: <xms:AqK6aiJdyvWbA3q5ZdT0g_VOL9ARQ3_xZEtQiFkinFA7XrkuVtRrEg>
    <xme:AqK6atmRDwMh_jjx2wQzY4gknAii5LAXTeDVRNef1H8859q3c4_pN7I8lP7x_LZlD
    NJ7oKH8nKMqk0321ikXSIEM5JOJdbpY7l98QcALj6Lg_MaYvdymkg>
X-ME-Received: <xmr:AqK6au_riIrusCDiDYS7LlcLDAyMAzKRe9E4-p_ejZ3tPGQkzTjZLv2o381k19xa>
X-ME-Proxy-Cause: dmFkZTFVchM+bTT1PKuZ7CN10fxXJIikNoVdUVFHA1eqyKMgAAVr8P6ONf1Qg916JwGLA/
    UIAM5uyklkVrDRDmXBCinnisDlXug/Uvz0CnXEuy4xZlY+Q3iKI5V68dUZbqn8FCfsIN95
    6KfV8L2bBYYMAysjIpjjTtDvr59SlVXR0rT3rsZ8OOWBdCzi2fs/qRsgGZhcNemn8sEAcR
    7gOuIxy/+2FBe7o4KglohLGCDym2m4zsXZ2bZO1r7mHjauIXUwmWu2ruzm3DMO6W6IP24K
    Wr2E/Zfjs4QhZp1KylseoV5Uqh0JkwjuRMQihg5e/hXKn9gV8Cjo7+1dG47k97NaaXBvtc
    6TosNN9zLhtvcoQ3r7SWS1Frb2Qorac1G8xePLtKHSGJmGxR8MUFy+I94uu8hg8RIumbG8
    SY0uTRLUL7ZXAHGIFzGJTRUWIX2hNbfVOEldVBvHg8V9/AF2MJIwhJ0f+kFlJnVpV4ycHp
    mKM9/zNsIiMMIH7wuKU4HfRltaRNhlV0YkDylvsKrut+Wh+XvvoJFU4M5SCC/C2VqifXrO
    OYHBvAhipyvrLi8l7az1rLG97YIm4jdRN+vuK6gHN5DJGuaUqTQKM+EHzM0pq6gs1lcqla
    bqJpdS7RiPDgdLUNPkCZqwhc2Uvf2IlXv/5+KTDtuT1Wp+YQPP7SNpjrYBnA
X-ME-Proxy: <xmx:AqK6agbe5qel0Zvetr1je2exn-rTW0Xq6Q3HISCHxyeI98zoCcy_ZA>
    <xmx:AqK6ajeS2DkKjha4qtyiFz8pYaVBZoLsCK2WMI_lnTuJ8al5s87WFg>
    <xmx:AqK6agFhpvYnTNdvu-UzjllEirRVmBdKqpZtG7UTJpuighG5Qeag5A>
    <xmx:AqK6amPFEHR90eeZStkd-dIzsg-ZIVPXILeuDuO1FZccV0GOwpB2sQ>
    <xmx:A6K6aqZzes1EOOPDG3S3_LbCYWNwv6cGFWazqN91PQemXmsFOH7EyBO9>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:20:47 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:57 +0200
Subject: [PATCH v3 09/12] mm/rmap: Mark folios mapped into
 crash_memaction-marked VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-9-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40F331C0011
X-Stat-Signature: r51g1dopq85tpiery7soykg9tk5e7yaw
X-HE-Tag: 1790616068-484760
X-HE-Meta: U2FsdGVkX19UIhvG68WP2s/3ZarEc54njm2Lh4Ib8D1L+dWTg69ojjUVpirqYM9QvKqHWuYvSNY7Vv49n7QcF1pzEmIrAx1mDLGVu6bSZ2yh7+tP5gGxF/gC7QMv9OeMZUavCK8vMQxJKO78T9faGtlb56UYPIe7zQVyTGsD73Yc0OPD70WbTCbCvHcRPHGTkbmLdZkV3oXAWk4khi+9EbtAGQCat6KvRM/nHwy+w0jTVS1bOBPGlMWQg2q/mC6M/wqIWMxJUFkZy7USi/L/HcPrUbnOegg4DrpZYRVoYg/9BzTGcUy39XhCb2cS9RHhoV34pgIMD07kKQsalGY9dTsTBGoMUoT1cgNi3iHXNv7tfzlKglkVSFye8evodNYjiRDnTRmlcJzjqK1lResVoxIQEyuvw7bVUCnweP1UyBj0PVhR6lecJ1Y50fRKLXE8NMlt22XfQESFiGykhz25+bbGPOKFq4jdNoNyi4lQ3Pyr3Oxj533i7bwsJAorQtMqDjvo3xUiQ4obUOM5KD3dr4c5/1Rl6lCsqawc+IFupk0DkpjNdl4fyF3x70kRPvCV9apEWXpAPL1AaYfwcmbEOey0fQ2aDt04iuLrnWYqtKYqj067zC+F5wNWrnQc14dF3eVkpjnN1/bsJ+1ySBmjo0iQwVBSFlIL2Xk6vm0ke3vpX70gZmbv7+OfDIHvZp52L4gmazQ2Mkk6Q1jDV6eSTh8jLZ8hTLDjWvESarjM5NYqsx8xxb1sd9ZKEC8YnLFHzg0kaXpswMybjTPQCDyfCG1Ua7rT3JxNhmwvRIbOtLqUXYcDGE+6b/ce/+Z0i3Q1raRR3Ixp6PMECuLU09h1+/DNv2PDzg+0qx/yIwCeJTq/pd9CG6D0/BELR2QeMlqc/2BqX7CkNuKGYLZ7Gx3GVDMHlHvCAdHhujL6gtm6zBwMj8S9jLi3vABrRgm5Q9X1jykKycQMNkW/177R/Zr
 S1iX7383
 C+tG2s8UklCRClGfvInsvV5RjNxQbRJXn/NZ/W2X9vnDqyeS/PbNOcTVEsPkah1ei62C9PBHWqsan2fwl50DStsr+czgfbt2TMcid5JZEXyWCoU63b3QNDAK0X79K66KAxeMEI9Me+82HgFKqOWw2VXLCm9ppjndvJL7vDahfMBLuBcRj9l2nkV6N7GL7KJLNJOnrgugVtREyQlo9eoFWKk3SSUPRUW01/qH9ksRRz0v1fqDseWUBxwuLM/EZ7BDpTRfRJ1LNL/1Emd5i7bYij6ZLLEDSPnR3WU+GzbWjKq1SeRiEEtYw040JvEfKZ+9yhv3HwZmBt2G6UVnzVMGprGinGaTxkxa/qXVstS7PumTO8Nu8luaDvPCcGqeh09irU6W4xgUnAqdtywqAK4uSSTzbucRRW/+agoAHYzM0JqKwPM3iZMJRII1TRiIsGp14iYhWFso+puYAnjXAkl7pgNn5O5t6X7SLk5lcTO0tf0HINI4S8qbdizfJDXyxfuPLPMjKLHAPWW3PuydKQhXhVNEa4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Propagate crash_memaction marks set through madvise() to the
crash_memaction registry. Register the folios of a VMA carrying
VM_CRASH_MARK with the crash memaction registry as they are mapped, and
update the registry when a folio moves.

Marks are processed in rmap since the fault paths, CoW, swapin,
migration and khugepaged collapse all converge here. The marks don't
affect pinning, reclaim, compaction or hot-unplug. De-regsitering free'd
marked pages is done in post_alloc_hook() and the hugetlb pool to
account for stale data in free'd pages.

The marking code is gated behind a static key that is only enabled when
the crash_memaction registry is explicitly enabled by a cmdline
argument, so there should be no performance impact unless the feature is
actually used.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 include/linux/crash_memaction.h | 15 +++++++++++++++
 include/linux/rmap.h            |  5 ++++-
 mm/huge_memory.c                |  2 ++
 mm/hugetlb.c                    |  6 +++---
 mm/migrate.c                    |  2 +-
 mm/rmap.c                       |  8 ++++++++
 mm/userfaultfd.c                |  1 +
 7 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/crash_memaction.h b/include/linux/crash_memaction.h
index 5f3e114c60ad..2de60bc12dd9 100644
--- a/include/linux/crash_memaction.h
+++ b/include/linux/crash_memaction.h
@@ -4,6 +4,7 @@
 
 #include <linux/init.h>
 #include <linux/jump_label.h>
+#include <linux/mm.h>
 #include <linux/types.h>
 
 struct kimage;
@@ -50,6 +51,18 @@ static inline void crash_memaction_unmark_pfns(unsigned long pfn,
 		__crash_memaction_unmark_pfns(pfn, nr_pages);
 }
 
+static inline void crash_mark_pages(struct page *page, int nr_pages,
+		struct vm_area_struct *vma)
+{
+	if (!static_branch_unlikely(&crash_memaction_active))
+		return;
+
+	if (likely(!(vma->vm_flags & VM_CRASH_MARK)))
+		return;
+
+	__crash_memaction_mark_pfns(page_to_pfn(page), nr_pages);
+}
+
 void crash_memaction_mark(void *addr, size_t size, int types);
 void crash_memaction_unmark(void *addr, size_t size);
 
@@ -62,6 +75,8 @@ void crash_memaction_unload(struct kimage *image);
 static inline void crash_memaction_init(void) { }
 static inline void crash_memaction_unmark_pfns(unsigned long pfn,
 		unsigned long nr_pages) { }
+static inline void crash_mark_pages(struct page *page, int nr_pages,
+		struct vm_area_struct *vma) { }
 static inline void crash_memaction_mark(void *addr, size_t size, int types) { }
 static inline void crash_memaction_unmark(void *addr, size_t size) { }
 static inline int crash_memaction_types(void) { return 0; }
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c726..1eeb7762b4a3 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/rwsem.h>
+#include <linux/crash_memaction.h>
 #include <linux/memcontrol.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -472,13 +473,15 @@ static inline int hugetlb_try_share_anon_rmap(struct folio *folio)
 	return 0;
 }
 
-static inline void hugetlb_add_file_rmap(struct folio *folio)
+static inline void hugetlb_add_file_rmap(struct folio *folio,
+		struct vm_area_struct *vma)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
 	atomic_inc(&folio->_entire_mapcount);
 	atomic_inc(&folio->_large_mapcount);
+	crash_mark_pages(&folio->page, folio_nr_pages(folio), vma);
 }
 
 static inline void hugetlb_remove_rmap(struct folio *folio)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3fb9504dff7a..adbda968d58e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2966,6 +2966,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 
 		folio_move_anon_rmap(src_folio, dst_vma);
 		src_folio->index = linear_anon_page_index(dst_vma, dst_addr);
+		/* No rmap add, and the two VMAs need not agree on the flag. */
+		crash_mark_pages(&src_folio->page, HPAGE_PMD_NR, dst_vma);
 
 		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 36f0c0d8f5f1..309be0b301ca 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5063,7 +5063,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			 * sleep during the process.
 			 */
 			if (!folio_test_anon(pte_folio)) {
-				hugetlb_add_file_rmap(pte_folio);
+				hugetlb_add_file_rmap(pte_folio, dst_vma);
 			} else if (hugetlb_try_dup_anon_rmap(pte_folio, src_vma)) {
 				pte_t src_pte_old = entry;
 				struct folio *new_folio;
@@ -5982,7 +5982,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	if (new_anon_folio)
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
-		hugetlb_add_file_rmap(folio);
+		hugetlb_add_file_rmap(folio, vma);
 	new_pte = make_huge_pte(vma, folio, vma->vm_flags & VM_SHARED);
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
@@ -6502,7 +6502,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		goto out_release_unlock;
 
 	if (folio_in_pagecache)
-		hugetlb_add_file_rmap(folio);
+		hugetlb_add_file_rmap(folio, dst_vma);
 	else
 		hugetlb_add_new_anon_rmap(folio, dst_vma, dst_addr);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..467b695e6dd6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -434,7 +434,7 @@ static bool remove_migration_pte(struct folio *folio,
 				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
 						      rmap_flags);
 			else
-				hugetlb_add_file_rmap(folio);
+				hugetlb_add_file_rmap(folio, vma);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
 					psize);
 		} else
diff --git a/mm/rmap.c b/mm/rmap.c
index fbd66a2823b7..21183478f606 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1582,6 +1582,8 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 	 */
 	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
+
+	crash_mark_pages(page, nr_pages, vma);
 }
 
 /**
@@ -1703,6 +1705,8 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 	mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
+
+	crash_mark_pages(&folio->page, nr, vma);
 }
 
 static __always_inline void __folio_add_file_rmap(struct folio *folio,
@@ -1721,6 +1725,8 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 	 */
 	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
+
+	crash_mark_pages(page, nr_pages, vma);
 }
 
 /**
@@ -3190,6 +3196,7 @@ void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		SetPageAnonExclusive(&folio->page);
 	VM_WARN_ON_FOLIO(folio_entire_mapcount(folio) > 1 &&
 			 PageAnonExclusive(&folio->page), folio);
+	crash_mark_pages(&folio->page, folio_nr_pages(folio), vma);
 }
 
 void hugetlb_add_new_anon_rmap(struct folio *folio,
@@ -3204,5 +3211,6 @@ void hugetlb_add_new_anon_rmap(struct folio *folio,
 	folio_clear_hugetlb_restore_reserve(folio);
 	__folio_set_anon(folio, vma, address, true);
 	SetPageAnonExclusive(&folio->page);
+	crash_mark_pages(&folio->page, folio_nr_pages(folio), vma);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index b242fa8b22c8..bb0a35d59daa 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1326,6 +1326,7 @@ static long move_present_ptes(struct mm_struct *mm,
 
 		folio_move_anon_rmap(src_folio, dst_vma);
 		src_folio->index = linear_anon_page_index(dst_vma, dst_addr);
+		crash_mark_pages(&src_folio->page, 1, dst_vma);
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */

-- 
2.55.0


