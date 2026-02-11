Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C2FEB597D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F556B0092; Wed, 11 Feb 2026 03:13:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098D96B0093; Wed, 11 Feb 2026 03:13:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE73A6B0095; Wed, 11 Feb 2026 03:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC71F6B0092
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A683B6A2C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:43 +0000 (UTC)
X-FDA: 84431461926.11.A3F39FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 73B0E80007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dvcx78ye;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMi38U+Kd2Tdhq5MSflniYKXEvK1Z3ZrKy0HbmnRycE=;
	b=lYWUVfQe3n0ij6F+mteq/AkWSok4838ICJ8UNGgRV03UngsWIuzu3EAlD4TjFK5KRIPFCV
	RACId69lgeiPQOP+I4dBRQSZsFkLYmza1ka07ZD4/rd/czOvmN0ANBEGAckGlh622Teq7P
	eLNYmyf1yy+8vnyKfDNDnOtzVZZJPKI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dvcx78ye;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797621; a=rsa-sha256;
	cv=none;
	b=nJJS97hcUnMGGfZMZi/329TDkaV9Yz+xiTKEjUYu+baR8QIdSIC+w9R4K4OdgGnasbVCOR
	G9YqoD3eS++wY4bu971FD54ptLJ7K+AgXjzgQBv+oRbyPLjf5LPAUC92jkkdvPhp+kPWYL
	IdZ/cFeVGFVFGT7dRHGXdqF+ywtNs7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMi38U+Kd2Tdhq5MSflniYKXEvK1Z3ZrKy0HbmnRycE=;
	b=Dvcx78yeielN+6PSIobwnBUxdp2iWvlF7Xw3oRe1RwLUQZ91z7JIgapg6OJrf3kIarTiZk
	gi7NAHjPkKkjZWIgG8lXS+HeXpjMzom4qX3WHiHFf1+P13JzyIik91FIr46VTHZJ1rzVyj
	lK60CNCcrQVa+FpxOZ9rUdmf1gfhO8Y=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-ar9eBNFSNiepjBAkPNq03w-1; Wed, 11 Feb 2026 03:13:39 -0500
X-MC-Unique: ar9eBNFSNiepjBAkPNq03w-1
X-Mimecast-MFC-AGG-ID: ar9eBNFSNiepjBAkPNq03w_1770797618
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59e5f9f1d91so197217e87.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797618; x=1771402418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMi38U+Kd2Tdhq5MSflniYKXEvK1Z3ZrKy0HbmnRycE=;
        b=uI0rBVHS02E/02vIj+KQxHX+KASfwimMMByWwF+I0Yd71PjoorpibpoTKH7ntq/qrl
         3mossV8QaGH2bjFgoyw0Tyo2+8RVTyuXJzi25/CKXZCbDIYw+CDCsU/fiaN6hJRymQs+
         peWXuVa2j3ZRy4aV166H36yrBRppse5fHz2QoLKIEYj31WwLdsU8SRfetCVyS4h59b6n
         7oqUGtNvvjviQmkPs5Gf2ElUjhMUVpFefXLgYAKsFlUQavAHHqrX23Jd37CKOItYOerW
         TMswivJ1p183Q0DrtkqnM2Kl7TUlnGxKpznZAFww8aME+hOPmyJZIoTRuS3ATzmprwim
         t5Iw==
X-Gm-Message-State: AOJu0Yxc0rJEDAE4K0Ocmg0BSmRiGj66waY4Se37z628UfvpmnPw+86j
	2O0t9D1OaHKK73r/83Q1F3cdFW0faYiECcMjTtefc4P7v6bLFaftuqSYARkF46qNyH4+ETdn9vz
	xdTnK12JOQFqUCGByqvZ+y6Y6xipFv2PI9TD3jWijrcPfyQTwCWReXcaiKO/2fTdaY1yELAS7i8
	8el++u+BxamdGjgmQ9DN5Z7oiLpFi99kX7O/4=
X-Gm-Gg: AZuq6aKJSpfqH8rlV7RENDYuRi6uSLwQ6wEaM8SDyNyKOvRjmaym+qjG6QlYVAunYAG
	bj/u8FZxQ/9jzPXqkDAARSbmoicNVuc2f6OC/H2APfO0a/kvp6yu180pQ6RaRDIQYujElJ2TybV
	o/yS1B4Ra9JI3Jd6y5YVzWj8eVzdfkPD9RkmurRKX8cddgp6M7jXsyqEIHDn8QpnI1vsHwXdcn3
	RuUZaYig6fh7g3Ufdy3BtaUcTV+P9k0fclwfVAnZVSxaw7vpxEw8rjHAvL16typOVw7KB4sguUZ
	s72DPwfIHKsP90o5Dg9FhgBhsJ0+K13dBNmyhxAVh4CIuu1vZr+dSdWA9LgCBUW4OIvtVFqVvuz
	1S4ANaH/AxhNp3xN5QLj/g0MBfyz9GjRMV2QB
X-Received: by 2002:ac2:4bd3:0:b0:59e:478:6423 with SMTP id 2adb3069b0e04-59e5e2077d8mr373407e87.21.1770797617862;
        Wed, 11 Feb 2026 00:13:37 -0800 (PST)
X-Received: by 2002:ac2:4bd3:0:b0:59e:478:6423 with SMTP id 2adb3069b0e04-59e5e2077d8mr373385e87.21.1770797617337;
        Wed, 11 Feb 2026 00:13:37 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:37 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 4/6] mm: setup device page migration in HMM pagewalk
Date: Wed, 11 Feb 2026 10:12:59 +0200
Message-ID: <20260211081301.2940672-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1_I05W0GABB6-Sflp27w85kT-uoeKvz1airpgaTHBl4_1770797618
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4b1p8rhi7jzqnsi4npt3umpxob9g4y8x
X-Rspamd-Queue-Id: 73B0E80007
X-Rspam-User: 
X-HE-Tag: 1770797621-405677
X-HE-Meta: U2FsdGVkX19HefbP9RznYQX+zSGW6XOLPpHFEnThJ4FcFfNiGiJ/alK2EO/vHaRzzOdP42MNM7+2vxHbyy3XJIXzxKnpK+wtiv3CGwljVX8KF0FGbFu4gq3nPJM6ccY6uiDKPg+Av015nrIdrbqNWhpyqr8S0LCSm35rVzPHJ3GmStiPLsPMrFR/MlCMWZtlGaOQbHX6R9v7DHMGARnTp7P5bwte8rN0blG9Jk944agwFbdSlt5kl9RWkxBNi3TaAKG45v6SArie/rCUDXLe+FufiAFnmB1qKwEySBFYzk4R5cIsV4qpKN9DDSOG0n0VKr7BHhlrKiiKlcQ+NF0mG/+zbex+BhZ0XaznDvPz+0pcNeWGDOPFqGHmUlPzplJE6lEkPxhS0gW8uukHWWY4WELun0x406chrzAmkkqbRnQoUrPL3XfcV/jzwaCBKmJr42DgNjN6ZuAGZOZlIl/BRZQoWqXaEAWdjKjpmkdjTfDDuhrwfg26rP3RLWvqguWcKbpkSHiDpzNXcK7Mz3ErTURM9A7vdwXDOOwdCGsQKX9CmUQ70U9/hoP9qaZXpxb3L6/nyGxI8VICCMhHcFwE5OdLQdDvkIojHjG9/SaI88I65joroEBqVbStCso9QqO5LJH9swUu8gZuWlT1gVKahkqzMyO04tGX9RJMcwcE1Lg1NWGXFkHwSDOAjl5DAn0swPfC+gNqZw8EAoOa73CyLa9CuNBQlF547IUt374Yl86uQqE0aIYwNEg7uLiVNaIJgCPVdiC5l3QN1sGEbMRWWuhHL3ZnOEDS9NPYvQTQYLwjHkEq1cYADTrkniL6MG3HR/aLkuElvU1DoQNdxUem+EUcmFfhiP37rUUwUjMDdYakSkeTHD3ensNUKTFhXdkVq/4Nq9tx2n0FzTrILcbxPm9E7U611YIp9f8vYiTTSlUGkl9q82H3D8273/Qr/ro7J9iVBWYdCYxsxgEU0dZ
 IwtwVl9B
 saqn44BA6P2VqgeRrxLUltXmGBLZ5+KKOQWNHtKWt1bzzit/yQXzgILEEUk/e6gQnWRVMRjn+L+cFgIs760d+bbr1o1R1sYUkWLtHyxNT8N9xbKzoDi0uX87S6i/2Bm/nhrVqZTVSe87gSV1kmIYnVkca0fo3mgsCcJI7gdB+z/VtNxR48OL9HFPqWvnDTbEMcIQxUyoNlZzDXlm/D+dB8s841HVI1lRwMCh1czYeNSAfYmSbpdS/Tk/dYHS5QaNhCwHAmSEph8X3HXgMmBrQlY2ZlbujgsbwIyEo8mVoIb3wRTc6Y4a1q4NZvQ0eKHpeFlO4WsSS5jcj0EYPYmeMV35igunB1IwwGq4UUaeEp3YgTUiXFC4N4S5t4/xQMGvjj0rcPuwrAVZ1TOGGf00q7KRB/HcJjp0DcAQr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() and
hmm_vma_handle_migrate_prepare() functions which are mostly
carried over from migrate_device.c, as well as the needed
split functions.

Make migrate_device take use of HMM pagewalk for collecting
part of migration.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/migrate.h |  10 +-
 mm/hmm.c                | 403 +++++++++++++++++++++++++++++++++++++++-
 mm/migrate_device.c     |  25 ++-
 3 files changed, 425 insertions(+), 13 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 818272b2a7b5..104eda2dd881 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -156,6 +156,7 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
 };
 
 struct migrate_vma {
@@ -193,10 +194,15 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
-// TODO: enable migration
 static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
 {
-	return 0;
+	enum migrate_vma_info minfo;
+
+	minfo = range->migrate ? range->migrate->flags : 0;
+	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
+		MIGRATE_VMA_SELECT_SYSTEM : 0;
+
+	return minfo;
 }
 
 int migrate_vma_setup(struct migrate_vma *args);
diff --git a/mm/hmm.c b/mm/hmm.c
index 22ca89b0a89e..414eed901b82 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -470,34 +470,423 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 #ifdef CONFIG_DEVICE_MIGRATION
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio) {
+		folio_get(folio);
+		folio_lock(folio);
+	}
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		if (new_fault_folio != fault_folio) {
+			folio_get(new_fault_folio);
+			folio_lock(new_fault_folio);
+		}
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
 					      unsigned long end,
 					      unsigned long *hmm_pfn)
 {
-	// TODO: implement migration entry insertion
-	return 0;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	struct folio *folio;
+	enum migrate_vma_info minfo;
+	unsigned long i;
+	int r = 0;
+
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return r;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	if (pmd_none(*pmdp))
+		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	if (!(hmm_pfn[0] & HMM_PFN_VALID))
+		goto out;
+
+	if (pmd_trans_huge(*pmdp)) {
+		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
+			goto out;
+
+		folio = pmd_folio(*pmdp);
+		if (is_huge_zero_folio(folio))
+			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	} else if (!pmd_present(*pmdp)) {
+		const softleaf_t entry = softleaf_from_pmd(*pmdp);
+
+		folio = softleaf_to_folio(entry);
+
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+
+	} else {
+		hmm_vma_walk->last = start;
+		return -EBUSY;
+	}
+
+	folio_get(folio);
+
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		folio_put(folio);
+		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+		return 0;
+	}
+
+	if (thp_migration_supported() &&
+	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+
+		struct page_vma_mapped_walk pvmw = {
+			.ptl = hmm_vma_walk->ptl,
+			.address = start,
+			.pmd = pmdp,
+			.vma = walk->vma,
+		};
+
+		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
+
+		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
+		if (r) {
+			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+			r = -ENOENT;  // fallback
+			goto unlock_out;
+		}
+		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
+			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	} else {
+		r = -ENOENT;  // fallback
+		goto unlock_out;
+	}
+
+
+out:
+	return r;
+
+unlock_out:
+	if (folio != fault_folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	goto out;
 }
 
+/*
+ * Install migration entries if migration requested, either from fault
+ * or migrate paths.
+ *
+ */
 static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
-					  pte_t *pte,
+					  pte_t *ptep,
 					  unsigned long addr,
 					  unsigned long *hmm_pfn)
 {
-	// TODO: implement migration entry insertion
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct dev_pagemap *pgmap;
+	bool anon_exclusive;
+	struct folio *folio;
+	unsigned long pfn;
+	struct page *page;
+	softleaf_t entry;
+	pte_t pte, swp_pte;
+	bool writable = false;
+
+	// Do we want to migrate at all?
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return 0;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	pte = ptep_get(ptep);
+
+	if (pte_none(pte)) {
+		// migrate without faulting case
+		if (vma_is_anonymous(walk->vma)) {
+			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
+			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
+			goto out;
+		}
+	}
+
+	if (!(hmm_pfn[0] & HMM_PFN_VALID))
+		goto out;
+
+	if (!pte_present(pte)) {
+		/*
+		 * Only care about unaddressable device page special
+		 * page table entry. Other special swap entries are not
+		 * migratable, and we ignore regular swapped page.
+		 */
+		entry = softleaf_from_pte(pte);
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		page = softleaf_to_page(entry);
+		folio = page_folio(page);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+
+		if (folio_test_large(folio)) {
+			int ret;
+
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		pfn = page_to_pfn(page);
+		if (softleaf_is_device_private_write(entry))
+			writable = true;
+	} else {
+		pfn = pte_pfn(pte);
+		if (is_zero_pfn(pfn) &&
+		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
+			goto out;
+		}
+		page = vm_normal_page(walk->vma, addr, pte);
+		if (page && !is_zone_device_page(page) &&
+		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			goto out;
+		} else if (page && is_device_coherent_page(page)) {
+			pgmap = page_pgmap(page);
+
+			if (!(minfo &
+			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			    pgmap->owner != migrate->pgmap_owner)
+				goto out;
+		}
+
+		folio = page ? page_folio(page) : NULL;
+		if (folio && folio_test_large(folio)) {
+			int ret;
+
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		writable = pte_write(pte);
+	}
+
+	if (!page || !page->mapping)
+		goto out;
+
+	/*
+	 * By getting a reference on the folio we pin it and that blocks
+	 * any kind of migration. Side effect is that it "freezes" the
+	 * pte.
+	 *
+	 * We drop this reference after isolating the folio from the lru
+	 * for non device folio (device folio are not on the lru and thus
+	 * can't be dropped from it).
+	 */
+	folio = page_folio(page);
+	folio_get(folio);
+
+	/*
+	 * We rely on folio_trylock() to avoid deadlock between
+	 * concurrent migrations where each is waiting on the others
+	 * folio lock. If we can't immediately lock the folio we fail this
+	 * migration as it is only best effort anyway.
+	 *
+	 * If we can lock the folio it's safe to set up a migration entry
+	 * now. In the common case where the folio is mapped once in a
+	 * single process setting up the migration entry now is an
+	 * optimisation to avoid walking the rmap later with
+	 * try_to_migrate().
+	 */
+
+	if (fault_folio == folio || folio_trylock(folio)) {
+		anon_exclusive = folio_test_anon(folio) &&
+			PageAnonExclusive(page);
+
+		flush_cache_page(walk->vma, addr, pfn);
+
+		if (anon_exclusive) {
+			pte = ptep_clear_flush(walk->vma, addr, ptep);
+
+			if (folio_try_share_anon_rmap_pte(folio, page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				folio_unlock(folio);
+				folio_put(folio);
+				goto out;
+			}
+		} else {
+			pte = ptep_get_and_clear(mm, addr, ptep);
+		}
+
+		if (pte_dirty(pte))
+			folio_mark_dirty(folio);
+
+		/* Setup special migration page table entry */
+		if (writable)
+			entry = make_writable_migration_entry(pfn);
+		else if (anon_exclusive)
+			entry = make_readable_exclusive_migration_entry(pfn);
+		else
+			entry = make_readable_migration_entry(pfn);
+
+		if (pte_present(pte)) {
+			if (pte_young(pte))
+				entry = make_migration_entry_young(entry);
+			if (pte_dirty(pte))
+				entry = make_migration_entry_dirty(entry);
+		}
+
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_present(pte)) {
+			if (pte_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		} else {
+			if (pte_swp_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_swp_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		}
+
+		set_pte_at(mm, addr, ptep, swp_pte);
+		folio_remove_rmap_pte(folio, page, walk->vma);
+		folio_put(folio);
+		*hmm_pfn |= HMM_PFN_MIGRATE;
+
+		if (pte_present(pte))
+			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
+	} else
+		folio_put(folio);
+out:
 	return 0;
+out_error:
+	return -EFAULT;
 }
 
 static int hmm_vma_walk_split(pmd_t *pmdp,
 			      unsigned long addr,
 			      struct mm_walk *walk)
 {
-	// TODO : implement split
-	return 0;
-}
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *folio, *fault_folio;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptl = pmd_lock(walk->mm, pmdp);
+	if (unlikely(!pmd_trans_huge(*pmdp))) {
+		spin_unlock(ptl);
+		goto out;
+	}
+
+	folio = pmd_folio(*pmdp);
+	if (is_huge_zero_folio(folio)) {
+		spin_unlock(ptl);
+		split_huge_pmd(walk->vma, pmdp, addr);
+	} else {
+		folio_get(folio);
+		spin_unlock(ptl);
+
+		if (folio != fault_folio) {
+			if (unlikely(!folio_trylock(folio))) {
+				folio_put(folio);
+				ret = -EBUSY;
+				goto out;
+			}
+		}  else
+			folio_put(folio);
+
+		ret = split_folio(folio);
+		if (fault_folio != folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+
+	}
+out:
+	return ret;
+}
 #else
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c773a82ea1ed..222cce2e934d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -734,7 +734,16 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	int ret;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
+	struct hmm_range range = {
+		.notifier = NULL,
+		.start = args->start,
+		.end = args->end,
+		.hmm_pfns = args->src,
+		.dev_private_owner = args->pgmap_owner,
+		.migrate = args
+	};
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
@@ -759,17 +768,25 @@ int migrate_vma_setup(struct migrate_vma *args)
 	args->cpages = 0;
 	args->npages = 0;
 
-	migrate_vma_collect(args);
+	if (args->flags & MIGRATE_VMA_FAULT)
+		range.default_flags |= HMM_PFN_REQ_FAULT;
+
+	ret = hmm_range_fault(&range);
 
-	if (args->cpages)
-		migrate_vma_unmap(args);
+	migrate_hmm_range_setup(&range);
+
+	/* Remove migration PTEs */
+	if (ret) {
+		migrate_vma_pages(args);
+		migrate_vma_finalize(args);
+	}
 
 	/*
 	 * At this point pages are locked and unmapped, and thus they have
 	 * stable content and can safely be copied to destination memory that
 	 * is allocated by the drivers.
 	 */
-	return 0;
+	return ret;
 
 }
 EXPORT_SYMBOL(migrate_vma_setup);
-- 
2.50.0


