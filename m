Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C73CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B21B6B008C; Fri,  2 Oct 2026 12:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B416B0092; Fri,  2 Oct 2026 12:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A186B0093; Fri,  2 Oct 2026 12:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 159FD6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:06:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81DCEC07D6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:06:00 +0000 (UTC)
X-FDA: 85278162480.18.88F4621
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf27.hostedemail.com (Postfix) with ESMTP id B6A204000F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S1Wlp6qU;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lG3PpTqvVPLXojPqrH3nBXhf48twgkVhGAKUdsEB68=;
	b=Ymg6ycDAdZMBOSW+vAp1yqQjn85w1VWwn8RiJoxxCK9Gs2IXlMoD9Kcxd3EbzCymFuePXN
	8RapvFRKOjYnkeDlr92trCYuLD19EPdo6GolrF6k1JylcC09S+FY1je62z9W5ZswCLdNOE
	fO6iIbXyquwkaq9/ns5/v3Mq1s/xYyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957158;
	b=D4sCkDH3mFHVWetj9Dgp9RmDavgjN863NfmOkmUDEBDt1weGGmIoaRfsyvA5Qph+AtyEP2
	uGZqALg3NMgQFvXdxRuiQWOekskHOzWG0Zm2fTPMJJGtYjCYCFjQjrxZdC8guhzS4nfqhm
	c41GO6ZbuBjyT1avdVr4+sFhJ0TYrcI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S1Wlp6qU;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0eeda3e03so84873a91.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957157; x=1791561957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+lG3PpTqvVPLXojPqrH3nBXhf48twgkVhGAKUdsEB68=;
        b=S1Wlp6qUiKvTvVPVk2x+how+Lr6wTVqP09/bBsXrWOKmIfpxQlO45/ZwcBznwHkJeI
         0ntryOAM51G6/935HWS2MFGd1Y10ZCd8i6JCWhllC/f+5+slBHr56GV69SeFLe0Xxoz0
         6lEcOKVbD5fSRz7i+Eggh/tyRKguzbUHJb6MmLSXt1bmfO6Dp3syHxj+bBJZN7xi/UYP
         x3NknBE6UbtoggTkLGAGhzwuarU/MSQl6Rpa/TqBlX78N0BO5Q/UtnJS3Cdydb9+a+gf
         UlBo2G5U6sOD30JB9FOdxu4zruVUHzb/TUOvDGLTalDl8f+P/jgD76Cj/cHyPmgM9Kce
         bR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957157; x=1791561957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+lG3PpTqvVPLXojPqrH3nBXhf48twgkVhGAKUdsEB68=;
        b=OAxmncJ+9/xHgYRuufiy1QsArA1Qg7HieRb4uik9+9KnGExaZQO/HqJqOiX4GbhcYi
         GRqpsnzKbko9+SvHY9LYRnSZdGOZTTpCKdpyIDKqJuFoZGBC1fnAL07RZEOo3pnHyZqQ
         63rQCofwmSO11Q/siQbVa5igxJEzU3+fjiQJHF5Edp2HtvAc9ezvqzxhOydWt8P6aAfY
         hPsSyTTdEx8Z+R1MetPyoHUNT0PIXbQLUIgo85bwp/FUrY+6Y/MyBUPvm5SRY2+MCTav
         XL3AERoMedyHMX/4XVTj9L3ROT+zZdvOAbRizAxlT1G4/jOajulewDnV1wJp8pM69xrP
         IxGg==
X-Forwarded-Encrypted: i=1; AKwUvBzm7EcDdvrSgVQ8bJQJSTzVatqidkfAzZjS2gi0q1T2Atw8KpYjCcerUVwYzlGspdNX0t+EzFCHsA==@kvack.org
X-Gm-Message-State: AFq9FYKPWAhC4mHym7K8bFCmg6cvC1ascPns0YOxzfE/+vcF9t9npnOt
	TtBcZIoGYCrrnvJJJ+lLrcsarErByJyfoagfxpInRdk56pGRoFfZ8a0I
X-Gm-Gg: AYBFou0vAQogFGkzzMpSZlbyrRqmedSoZE/G5sSusr2LhPJBIh137E8Y9TJ0OTZA3kG
	mNC4FFB4rJqyLyouL5ftwKmBK2/JbWaDHNlHPpMmc9099JUmt868boyze2ZHIDZDGlqule385GS
	aRs/yGbVnILXMgZkANbapcGf1rERsAtkydlY4VF2rLLH5TFs6YvgOf1DJBNjpcefkmdbeO/WeNu
	+a8PWbOiTcpPDgiVTQgGFse5SSLKEJCQ3m8jCYyNl4Cj2eX8bG/UtGJLudGLQ6yqfssDcMLdlb8
	amxoW6ISvAikOYYDCr9Q9wElAv7sLC4HdWoHN+VIdPXSB1gFk4DUDAOOUdy/Ik6ZenigdHQn6Zt
	GROYoZeuxFLc6HbT1GO2+qydcjWS6xmSFArup9qeWAmqSMafjIyB8yFZqWJYJNND95dzn8L5VOM
	zN+5hZ7rDLXdHZ+mTsgSVJ7l5BgmR+hy221Ve3vhiMlo6sZvi2IqAZtleUMmC0UH+8IBAV0FkuC
	9aVsvbz74QoGjax+OODimqi
X-Received: by 2002:a17:90b:3e86:b0:3a1:66fd:94af with SMTP id 98e67ed59e1d1-3a6ce7f67b5mr1330919a91.37.1790957157521;
        Fri, 02 Oct 2026 09:05:57 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f47cb357sm9375672a91.17.2026.10.02.09.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:05:57 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from __vm_insert_mixed()
Date: Sat,  3 Oct 2026 01:05:33 +0900
Message-ID: <20261002160535.661399-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261002160535.661399-1-ekffu200098@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6A204000F
X-Stat-Signature: 3rg9nabe194crkpdrekjqfuqcifrapp8
X-HE-Tag: 1790957158-150363
X-HE-Meta: U2FsdGVkX187/k3RE4YpfSVMWMTDvdz1zuWdVBzSrEhG/HTQe+g7q+YbgiuNfm9HFH4pydOhA9xRl5Q6p9mn1bi/5hG1/xmb+j1EWvk4Sd06jwjOQymHGspABszxfY7aJRSwI8hvXnI8wIOHHvlDcoeOMVvd25+COjUhtdr1dIKC0D4VKhcQl5Ni+8DwuTs/J07PGwEJCZWukgmlJf1SDAN75NZXOUITLgcn/HT1kSggz3CLTNd1JmqEzkxpOT/Fnxr8bpoKQgFi2b4j8JPztvRclgkXze3H3SM14frpVq92i5Y23gw6sXJt5u5KMV+2I51uRTqfLAO9OZMm0Od6wEmYxmpOUE8dczLRbTL3ct1m5eXepQRD/WQySiDTzrNexrv/uGovNWJxIxIIozCI73oGPti2IGcPKCeMphX2N8RGWfJOKmjLJ9g5jDdt/15+yYI4YRlEWRw3bN4nt8C24omXeRxwNyg+tG7kZ1iXDnXgJKsPr1gKNm2v0pYEse+Nf0L7VKaZDkEx8Ls94DPifBrw04QCGtfebluvduvhl6rFcUWS9XayD+HzufbdBZ13nfD6F5dZZaWyyuVKjeZ78GkZsPlia6e21WeWd7m2CpOc+szlq8xyIEbO1hYzLLJ6tCniTiwfAc/ojdtv7rkmA5WrfHNcTFP5+UtZCuy0O0uV9fvg1GsP7HBJEpg8T/SMN8kWtpGjeMLZGeZyLS+r59HPQpnvf1fsSuLjY1m0WWjGM0/dxuoUg1gX5AyuOz3r3t8+wFot6rE3K/KYXF4gzH857QTUkyVMrsO96zzXwxQUlPpKQn4KDKs3rYZkp0jViS8uPWQyCuVh1qn7srmfxyZ8HJ/nlRQCLIUHeVFPLRTq3a4vbcsD0m3H9HY9r7kjoMj4MMUfQZ7Hg36hvFb4o3evA9qdWzU3jfiaaUVLQQRF/TPfFlAfheUm46IVOrP/Tv0UmN+/OkEEaG5cwy4
 CRU+b+0L
 jFrkn4lZB2jS+04g5NbitO04FehwybbP9Ks8Kv6pvf0YEoWVHwQpc1JP03Dha5g+oEjnduHDFgMcqqTpCVOFBls0lTg4XQui0MpDE2h/vuOx/gpBD4coCTPrrqhn6oM8H+1IKU3mVdinYPcpQfXX69nsEYk4kLyY4BzjD5RYC6rKWaKdMjgnWGLQeShteqhMvHzFDyhEmJBKF5GpqbKdozoQUVeR2vpAh2cvXlQ3eXw/9vxX0SKDaxy6AuC+4q8gviuLM+8fYBAGMapKb09DIzoG9KRJ9thNvNeFeyOjd/Aj12F3i9KbXednaEAg/q7yzfzRIum7+OE2e31e1OLlTbtiPWTiOoMkb5QVN8mt14xGW7wBv70GOyiU3qUmuSTUv/jHe+4QMZuB/8g9vVuf1dgqTJiqikDmNBi+NbP8ZHsVRr8IWz6pUtrCg2RgQ4B8zwE4uGhihuk7/P4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vm_insert_mixed() is only called from vmf_insert_mixed() with
mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
and insert_pfn().

So remove the argument and the unreachable code in insert_pfn().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/memory.c | 57 +++++++++++++++++------------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4b2e4be28031..6c1d38eba7b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 		if (!mkwrite)
 			return -EBUSY;
 
-		/* see insert_pfn(). */
+		/*
+		 * For read faults on private mappings the PFN passed in may
+		 * not match the PFN we have mapped if the mapped PFN is a
+		 * writeable COW page.  In the mkwrite case we are creating a
+		 * writable PTE for a shared mapping and we expect the PFNs to
+		 * match. If they don't match, we are likely racing with block
+		 * allocation and mapping invalidation.
+		 */
 		if (pte_pfn(pteval) != page_to_pfn(page)) {
 			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
 			return -EFAULT;
@@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
 EXPORT_SYMBOL(vm_map_pages_zero);
 
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot, bool mkwrite)
+			unsigned long pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
@@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	if (!pte)
 		return VM_FAULT_OOM;
 	entry = ptep_get(pte);
-	if (!pte_none(entry)) {
-		if (mkwrite) {
-			/*
-			 * For read faults on private mappings the PFN passed
-			 * in may not match the PFN we have mapped if the
-			 * mapped PFN is a writeable COW page.  In the mkwrite
-			 * case we are creating a writable PTE for a shared
-			 * mapping and we expect the PFNs to match. If they
-			 * don't match, we are likely racing with block
-			 * allocation and mapping invalidation so just skip the
-			 * update.
-			 */
-			if (pte_pfn(entry) != pfn) {
-				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
-				goto out_unlock;
-			}
-			entry = pte_mkyoung(entry);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
-				update_mmu_cache(vma, addr, pte);
-		}
+	if (!pte_none(entry))
 		goto out_unlock;
-	}
 
 	/* Ok, finally just insert the thing.. */
 	entry = pte_mkspecial(pfn_pte(pfn, prot));
 
-	if (mkwrite) {
-		entry = pte_mkyoung(entry);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	}
-
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
-			bool mkwrite)
+static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
 {
-	if (unlikely(is_zero_pfn(pfn)) &&
-	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
+	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
 		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
@@ -3013,12 +2992,12 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 }
 
 static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, bool mkwrite)
+		unsigned long addr, unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
-	if (!vm_mixed_ok(vma, pfn, mkwrite))
+	if (!vm_mixed_ok(vma, pfn))
 		return VM_FAULT_SIGBUS;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn);
-		err = insert_page(vma, addr, page, pgprot, mkwrite);
+		err = insert_page(vma, addr, page, pgprot, false);
 	} else {
-		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+		return insert_pfn(vma, addr, pfn, pgprot);
 	}
 
 	if (err == -ENOMEM)
@@ -3086,7 +3065,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn)
 {
-	return __vm_insert_mixed(vma, addr, pfn, false);
+	return __vm_insert_mixed(vma, addr, pfn);
 }
 EXPORT_SYMBOL(vmf_insert_mixed);
 
-- 
2.43.0


