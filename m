Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82099D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5BA6B0095; Tue, 27 Jan 2026 14:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B29A6B0096; Tue, 27 Jan 2026 14:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC946B0098; Tue, 27 Jan 2026 14:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11CF66B0095
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D01E113A5FE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:27 +0000 (UTC)
X-FDA: 84378735294.04.B4994C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 28F734000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrHUkz6C;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPiiTGnTeOtHCWiJ+JFT+RK6v2SBl/muTu4PAPMBbI4=;
	b=ufatjON3o4vZ4H3vYUVpnVJzVSsFRiYCBXmSh/XR3znioHI/Hrwfb4h6zjcMcxflGM81En
	Cf1JDLkrKoYkKEhfna2N/N9tG9f27WAqw9W4ODlgy+Ydz8ClYf8AcXMeMm3hADmRz7oKiz
	PdgOeqJUR1K4yCRRYar+iDu6FZvPHMY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrHUkz6C;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542226; a=rsa-sha256;
	cv=none;
	b=I2kHXQz74VcaxrAEfjEc2Tt+W3Mg8CogiXo4wj2hfeEKOhbZbbiJtVamBW5ZdXkLUPJ566
	Sg1COXF+RpLaNCbv2iVca83lPDylV5rztCLC2NwX99GBbGoIHnXABL7zmU+qhuo8tTjWlP
	wDcg3xZB9vpn++5Mhy+WXfCcdzHGkL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49B23434A1;
	Tue, 27 Jan 2026 19:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C5DC19422;
	Tue, 27 Jan 2026 19:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542225;
	bh=nTxpSE/9FhIsTCsQqn23J/LwTg91bg9I5z/zHIxMJv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrHUkz6C+MTinzzGGVgkyaol0zc47wA0yvVmurTkfu0cKRYazU169tJNe5tHoevx6
	 7/wZJgSSUqc5jWeKq7JYrng3nrM7JEuZHMfX2JwK/M/NMa89Q9/dm9nQapAqcec1Lp
	 hK0/ivMIVrASZXYbIjVZBnt2bP9Xcel73hekQ+KPat13JeYFhjjONJA5tSZtsuAJvp
	 9zdgPk/Vu+Nycb2jm5R/WScVzGZ2F+4bgKBBNxuKbfzPub6nJJo/4XnV3DqNSmI/FG
	 EoXI+WhiNrrslRwS/DZxR8cZYDQe9w6bmIcDDG2XVJXLkOkKjci29ietb8D4VCEdQt
	 3K7FK4bRUM9KA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH RFC 06/17] userfaultfd: move vma_can_userfault out of line
Date: Tue, 27 Jan 2026 21:29:25 +0200
Message-ID: <20260127192936.1250096-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28F734000C
X-Rspamd-Server: rspam07
X-Stat-Signature: bjkhbpmdps91tt59c45p6dqdeht9us9m
X-HE-Tag: 1769542225-436561
X-HE-Meta: U2FsdGVkX1/Ie7SxjYL6KBaT6CgsBsd6UV4/AFylrd2r7UPVvSY/e/fJMK22GVF7+gmWzo14fXdcA7DIkaV2FTXFajWVVoxMqcEGSJGGzVN+QeOID8uDsix1QLbJN0rfpkGBvjeS/ljwF6TVF0UJEAJ1eyjGWqLDkGswAn3Nq/CUBP0N4ctvGeZsiG+9ojMkdWN8WmWAW+KPl+Zy2BMYY4RMBAXVekzNaK50cEEyUtank/tz+PYfCyYD1QZZgYTWSbw1g1Kn+IZoZeqcXGGqvmrXpaQltBRs3T7MwWJFJW1LcQwCqDnxXmXWNKvjIPb7V/9zM/DEv5EG8COPGDdscrpaZtlDwHLx49nSKx2FgTBECjdhv1HqT0eELoiqchHVc+R6t/mHkVaZ5ut+1hodScR0sAymXMeC3RSmFfatP7Rub+3vv2+ePMgEu4q7LRbRJ7BFDuCrJhAUlO76FcH3vDfMx3JW/8nl/kK7qWqarmA+LoFzr/hKobzhJ4f6tt3kSg9zRYzhDV9t9ErwRtwPy0OazFBW5OrpHrhFe2mF8ObNrJaCalrrQTGEFHakmiPo8bjRqNr9FfgBzcKnJa/mhOdfB8lICKnT92OEYuFFtw8lNVTVZL++m/1TQWTzK3FQi14M8OpXll+q4omPGHK4/ihQcy2XLsY4D1aRz3YMniPttf9LZ7jK9FmykS9jWgcxNEa8UjM+YkWThzlq2xoKP8uFbrvhplTui96ZOQ8kuIXx4j20GG5h9rmphJtq1V7VIl/22vxojrYL6kuwTEAgwi2OAGqLnHLZ8/X7wnVb8rE+XT+70Vij+rWKw5YQ/hzWFGwFtYcvMS/6KQntOzKw6cwsgii2qsp8e9DLxcxFjeukJPcbyg3x3FCjT7BtspmSGRpUX9tuw6J4ISuhy7VFeGVlcEzjE2ytszNltQJDK0WMB5sV9P8YKxVl/rJ7sqQ+/gwUGETT5JAFNwyzuZK
 /5A4udNy
 6QhNXTX0sGyKkuWg+ST00mnwd0sTZxoUYme+6cTSumwHzEcVUZsWKdY0/CqMlTALUKuKkxJ1G5DLgbY39EFy5VNkerZ8T+GZju8LSvmRC+KzirJ1qbvdTTSzxOEt+9iNTswRP3Q0UI2wPpHVC4nBHdut5ZL0yEtmApruSBRWeXgTwK13ZhI3wQsWcupJG02on03WYPQ0zaYmSTCz0oYL/PhYv2/HBs6SRTg7Ipkigp46jcRDBBdObOcWPbXCy81oIBQzjj+sQEPlEz1dlVETy4qErcmSvCV+Jn31g01xFaVhCUYdRWBJXMBZ29A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

vma_can_userfault() has grown pretty big and it's not called on
performance critical path.

Move it out of line.

No functional changes.

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 35 ++---------------------------------
 mm/userfaultfd.c              | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index fd5f42765497..a49cf750e803 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -208,39 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
-{
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
-}
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async);
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 01a2b898fa40..786f0a245675 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2016,6 +2016,39 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
+
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
+		return false;
+
+	/* By default, allow any of anon|shmem|hugetlb */
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	    vma_is_shmem(vma);
+}
+
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 				     vm_flags_t vm_flags)
 {
-- 
2.51.0


