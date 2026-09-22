Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA62C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA0F6B00AC; Tue, 22 Sep 2026 01:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EDF6B00AD; Tue, 22 Sep 2026 01:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59736B00AE; Tue, 22 Sep 2026 01:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0966B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13102C03CA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:07 +0000 (UTC)
X-FDA: 85240284654.12.B1187FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D46D116000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bDJUdjfQ;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Dwb+61ZiIhZrjnlVPFK1XZrDSM5l5u6qowPzm9WLF0=;
	b=dBBlCSpJcegYr91z6VmzGBr+dFWdSqeC/vsvSnJJ4wmkJcitNnE4wfevTRHgeQ89RLeh+A
	SEIvm1CQ3eZOMCWwG/oNIkSQIrpqf6cvo0XhMvLsqqmgTlYfc+ni30JRyz1qNx9J4VXl7Y
	LPBdBvEUC9d7/ccyEB7sss1XB3SI8YY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055304;
	b=qWRgeFU8X8BFmwOxbgwcP8jIr7sVA/w7jNTmF1PHLWzwIHAoytcpwD4ncDpcYha1fwQ/CD
	yL4V/NipaDPCKDCHChsLMnfaK++zZpHgRfK9zW3W4S1ZVoIbHmWCwmMmEyNGnaFystzl+R
	rI0CTfxV5ptT7wfHnY5BfRs6iYPIUJU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bDJUdjfQ;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Dwb+61ZiIhZrjnlVPFK1XZrDSM5l5u6qowPzm9WLF0=;
	b=bDJUdjfQ4hWTV40K7AmPofykUlExT5NKUF8necMGFzE2shuegH215tdsBv6F6XrnROJxJr
	WZaMk2rJRt6hxstMM7H2VnEGGrPMVd4y0Qmrwp1hqJiuyFmltiTlkk0pmbaSGDoxjQKerR
	9gUHbEHZBTMkU6EN9zBaNlRhvJhtmGE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-uRtZPs1pPIuNqB6mvYnKHA-1; Tue, 22 Sep 2026 01:35:02 -0400
X-MC-Unique: uRtZPs1pPIuNqB6mvYnKHA-1
X-Mimecast-MFC-AGG-ID: uRtZPs1pPIuNqB6mvYnKHA_1790055300
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b8c58d7635so1656861e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055300; x=1790660100;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Dwb+61ZiIhZrjnlVPFK1XZrDSM5l5u6qowPzm9WLF0=;
        b=NMN7Ez1ZtJgVgpsWmJOAWiseN7MKuQzB0Mb8xBgR3Bh2F7lfwz5GTK4VwvOwtADxWi
         enYjjZAhJFKL3Ve0QkGeT54vJpfWr2os5S238Q5xgThC0NV3sGmk0AylOVjbuH1G7nww
         GnZg67P8xutibBWn8qQkRGr3X/nygd6ujAVNgKU8MPSpWR+qcKirNKh532W7ZWlotjCQ
         dVb6rc0og0Pa8hyUSiBGs2KUHMWFknlml5gqGAYFxTFAh/cNIo5ezt3dD2BLS1g7W6j+
         UL+dwi7wdCkaAZqqd2oXPmhSmTWSn+hy4yR7k4eVsNXDCUFLhjfuiH6lubqFoNj45c71
         dTag==
X-Gm-Message-State: AFuF++l0R3W//b0qXKdLkDyKE1zWo0PMOA+jLaCgGxye8T5h/uAHUdKm
	9X4ghR/uheoB4mhz+cdGUprBDLjSTXguL4ZxxUDidwrQAXBHrZr8/q10ek2lsNq12MC57q8wL7b
	TNDETe0t6YC7a2S77qNzUJXEOcPfaaEg6N5IGxnjCJlH7QTBzRK0BlwlTULPnhzThMvl6iBSPkf
	Ot8VAnzBblKxGccL5ccsW1ArXrnjUxUTG97Qf/6A==
X-Gm-Gg: AYBFou0uMoDvJP3c1DURRJisszzyxJAcBebn4+HD+rsxtrRVEGh4NocMZQsGL0Lzx/5
	TeH9IrkDMspphamubT3+dpsWMBhDgBdmyRbfnLhNC2h6HMB0KryhDdTQqvXiyqFgo6gm8WgMTkK
	3z4ESS8m7XtIJoofGz3kdvLzmWHwuci7UvyiVRHzpYFsSLfcyEwaVOhy2kaTYmh7aQJw8zwT/Uo
	HguITD3+Pr61l8BrgzemTt4sBFUB72OJ5Gw/+OBeYxtDfK5+Ya6PZ71Ja45bUaUTZZHT+wxoLKi
	rUUslqNZxFmSm7a5H7nZdRag3dsLmvvPhpTVgYDbiQyp8BHg+twh/y8nbvmGJtjtWbdnrpEnuYk
	6yJGwrJDgI7Nr3k4oEDlI
X-Received: by 2002:a05:6512:3a85:b0:5b6:186e:b79d with SMTP id 2adb3069b0e04-5b8c194df51mr4033237e87.57.1790055300413;
        Mon, 21 Sep 2026 22:35:00 -0700 (PDT)
X-Received: by 2002:a05:6512:3a85:b0:5b6:186e:b79d with SMTP id 2adb3069b0e04-5b8c194df51mr4033212e87.57.1790055299969;
        Mon, 21 Sep 2026 22:34:59 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:58 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 07/12] mm/hmm: migrate collection in HMM pagewalk - pmd level
Date: Tue, 22 Sep 2026 08:34:16 +0300
Message-ID: <20260922053421.4092027-8-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JDsXZZ7LmHafk5pqWGwbaBMQ0sBtoVNbHGM82uIXP2U_1790055300
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mx96ifqgnsgk9oawa83innowowt9dcy8
X-Rspamd-Queue-Id: D46D116000C
X-HE-Tag: 1790055304-527054
X-HE-Meta: U2FsdGVkX1/uZscOCc4V3qorlJMcklOFpo1ueLezFzBK8t7LnY6FXnAc31YmzzprfsU+h3UjCG7xzuRQ0HlU2cnLVxxb+KTNbO8bBQI55v3LGqavH2JfZWUcu8DK+DZDDu0JoYBqkHDLXQC5vQywFw9DMy0H7uC+BwcmQnFqcwsEKLDe7wV+M/KJAPmvdw5LYzl5ecDN4rf/QHpIDI+ytiaGOb0lV5r/yPCMVW5XtLxaw8EHlsr1aRt6TRHbBVaLHCKokhjpTx2QmEJOL/I5RXPjzpoUEefScJhSQHLicFxz6e71h30iMtO3Q/t28WQc61AEoiJqs2neUWfHVH1bOucMmSaz7TdMxZXc8rzSeRviYzFKfCtAKcGtm+OGVyuLgkFHY+wcGbiuR8cq/dQzlaGvjuMPScOTXMrWAVVPz0lc/sIWG2/8LSohdIpHZJ6azZ7Qlxq2WxjCt8E9RGSOSr7ZEED1aZ0v2zIeJ8DbZ3FhICgfzua6nuZnp397dVr4SNMah4XL//v20BYOaAqfya9mSlXVb360lNzFobQy7HOthggq9H3YTkpauu2mxlVkuU8YX/VdN3qtoSrLwK179B/40+GRO9CUVXmQUZCQ6owhEIo+yQtvWxvRhgYj0OQfoo8epPgtUqj+etGIjppaqwREu32AapA6F/V09w4oQZIwaSUQPpI9w6P4gHu+pZ1Xt/DbcnlKr5N3NW+g9Yt4Vs8M8g1ToBVsN0Bvwa9aC0Pj6K4sdj7xj1w2K7eljGu5VEY+5JhYrkxgyyhKaJXIV/ZGqtS0XeBm4UucRbgp0Hw1+QvLGezEvuY7RghS+vC1hla1XDGhW3dpGHG0kTRIY6WAP8wT/OJ3HmgAqMMjohQMad5mD6qZdzVihk5j204k3dUFzphMmXp46dIcTE66nIcThdxCnxWL3lzovP+LC0+s3H2ReLX+MLdBxsqvn10twV84QEnqlf0lvH73QQx
 MIYmjLQ7
 og9eZjagNIOo0nGBNhq3tSilG55gzDiSBw5rljYffPZopfNrS26nrwHkxqyb2UoD6ajpSacKVp0Ukr/d2UAL6J84ijSvoWDyYzMaqXNlQ4VCOF8x6kZpt2uD69XPdZaLhdRI5ZTPp27eUj8VBLkq57rjkNPykcbsH3dp6CFK+gsjf68Xs0D0txpvb856gBSH80XAVV8IFnuuLR8Qvsc3/A+TeoQaGn6a58xDAoEnPtNHPOnBFJcmMWErMQCx9cbpzmHUB8l57YGSk2oKVz7TTmrF/cIC6OipX4sRcWl0wpVqlwypH+TPBYE7Otf0PXdlI1tL9f48ZkqYLLwt5LSzJ9nDz3/ETj92A0RYnvBrv/yizw6YOKDa7jQ1PzLIl3jnmbFbFIPuskV52OerfWIZJKncs4eHigMxysP2jLMg/dPdi7lGiy35WictyY/aKczeCWFN0l9ARlpPpn6neVuermtJhF5JiIBnp5+zmf3zBTZPlFXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_huge_pmd() function.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting,
and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
do the migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

HMM pagewalk based migration is enabled in later commit, for now
now hmm_select_migrate() returns 0.

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
 mm/hmm.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 2 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index b3b79d13c797..a1459bd34c04 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -552,8 +552,100 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      unsigned long end,
 					      unsigned long *hmm_pfn)
 {
-	// TODO: implement migration entry insertion
-	return 0;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+	int r = 0;
+
+	// Do we want to migrate at all?
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
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
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
+out:
+	return r;
+
+unlock_out:
+	if (folio != fault_folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	goto out;
 }
 
 /*
-- 
2.55.0


