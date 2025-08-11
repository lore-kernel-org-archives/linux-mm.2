Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5520FCA0EC1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0C76B016F; Mon, 11 Aug 2025 07:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81878E0043; Mon, 11 Aug 2025 07:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9DF8E0042; Mon, 11 Aug 2025 07:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A767E6B016F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:27:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C34D140126
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:02 +0000 (UTC)
X-FDA: 83764249884.07.0CB0FBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A42440007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OzY6BA0u;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAxz8wtEYwnzSbLFT0UZ22FzefKNNzcleMeX5Ma3lWM=;
	b=V/KgVKpwJGbQtwF8+nqY5hWO9IjU0jX2gLOm8PswIS07HNhSDy5/P0w9Y7k/AMO7wuCGml
	tHrrFZP/rYN/PdbrWX4Ki2YdQkt0ozhdYZavtjlWXDtH6J3A08o7lmUQl8SKCYZSnlooBv
	VjgtqJ2RZ1Z9x/kAEI+CNL+BA0l5J2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911620; a=rsa-sha256;
	cv=none;
	b=v2s3PHqR7idaxwrLGMtm/D6HZfI+MIMrlyKlGlYjiPCXQE9Gy6c49mZj5rXE3Dq5Efvj1l
	o4Z7X6Gq+lSyVpe8RMUwmfV1meEEiyLDfrSbDNwetD/a1/RditMpd+DnmiWAuRqm22eKIM
	vdQPZIKoulkQ0q6h6JzikWLsDlPS93Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OzY6BA0u;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cAxz8wtEYwnzSbLFT0UZ22FzefKNNzcleMeX5Ma3lWM=;
	b=OzY6BA0uDT6lXYsWYJDCSZfSFeuEvXLw6qqBEehs+Hll7x8eEM+3MohhumbQ7nl/P5Oljl
	7yXNYZ7EM5t1fe8E39lAs+Tumqr8wchhEbCLDPXhYVFTNTiYxodqOC/wMLAS7a/7DQy7jg
	ns+OWWIoxOiiVkFmmepT1tAmwaU9S1c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-Dfq29jtUOBO49-ZiwQmG8Q-1; Mon, 11 Aug 2025 07:26:56 -0400
X-MC-Unique: Dfq29jtUOBO49-ZiwQmG8Q-1
X-Mimecast-MFC-AGG-ID: Dfq29jtUOBO49-ZiwQmG8Q_1754911615
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459e30e4477so37621305e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911615; x=1755516415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cAxz8wtEYwnzSbLFT0UZ22FzefKNNzcleMeX5Ma3lWM=;
        b=Hsa+fZvz0W7Jr79pw7/IgEhlxL5MjpnU0TKCrMMQT6ET7zsIWYVjUsoQQoNMy4By4c
         VQdROw/62rvrOHOLoIc591QN0r/QJwlkM1pNFXSYa7lNK0Cvv8wOEDMXYE1a18MJHvvj
         biFk+LvTuhlXG5hAK08E813wclWVV7/vXe/JGyOESGvGI07RR8MLQ+RSl2GuNZwb1lsp
         jTrCrqp9rzCpPkiDCN6v6igN8Cech3dc7H2zj6QOssy9VE3VPgfpK23IHDXwiJH3DVnu
         nODRUuebjinwIHEVajuLSSckRIKiPvMYBgzgOjSVAxGQkkF4A/VOgJ/8pfic4luxXhLv
         2MAg==
X-Gm-Message-State: AOJu0Yz7ofM2g/CYkHOchveen5cMXbgRPjgrP4Sy0fxC85vI7FEuHqpU
	ZyEdLg25iArb0+VkLpsDL1KrKwCuG/vxYSmaJPdKGLpBOqnYDrZlY1MgTDthotT3aLTUkbwNLl/
	t05orv7S6cbcvR187001sOJKaLYLurlctk0GWa0GSliLUGwg7Xs7V
X-Gm-Gg: ASbGncvJgt3ZaoHSNiY3Q1/DWj2FkZqKaG9WOt/QXPfWqkEbcKlg53habzbeKivN9oM
	IOq2/ipTPkHs3FfPGEs12iFeBFy3rS3PsXj+4UPtD1lX3D8OZGonkO0nTM6iQaBUZwhNaLPfskp
	K2Y1l6+Pz50mrOkhHYr2nVEqyYnhMGowBsAv2UrjXwmi6orucDPuF0XNi9qvQqxc4yNctyY1Z/D
	ZKQ9tqnVth6PTyn7rkqBcXOIS8ljVisVdKIpFhwJIALRimpRXCyka2lUjONALqbTq8/MNPtJErC
	Kz8iyO8Doz6nHSrnRyMQgNYWnTlnsc5S0ofZONohCkJli3R6oGRluiypf3CzZPWfJ26berWbUPb
	CqLwf71EEB6XfWBec5d4Cbqng
X-Received: by 2002:a05:600c:350f:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-459f4f3dde5mr124070765e9.3.1754911615174;
        Mon, 11 Aug 2025 04:26:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKs8kYesKmGWPRfo05vS75I0Yn/yE7Pq2L/J4XRbC28zXbi7Rocgkv1+OCyQd3aXR+1J2h1Q==
X-Received: by 2002:a05:600c:350f:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-459f4f3dde5mr124070425e9.3.1754911614678;
        Mon, 11 Aug 2025 04:26:54 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4530b3sm41080102f8f.34.2025.08.11.04.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:54 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 08/11] mm/memory: convert print_bad_pte() to print_bad_page_map()
Date: Mon, 11 Aug 2025 13:26:28 +0200
Message-ID: <20250811112631.759341-9-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gBqiWbXdcVw8fWR6HzqaWA3BePgZSbq_YP5MfO5AcAA_1754911615
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 3A42440007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1yze41shpsmwnrkfwszmxmdcja5fsm9d
X-HE-Tag: 1754911620-982623
X-HE-Meta: U2FsdGVkX19mLq7I39N2vKgKXZfJmLW2hyBxq13+gNiAZQV2AesILzcAtTfoGJw61UfRfi+K3mHpziUCrDpoO/npYaMTzTo7EStiibYaReqSfrQ+8sFs/lqGwefaqT5tJsRpNZIqngx2hjnfyEw+pnVuowNfcEsyKGUGi/hNDMPsEjDW30/tpSG+98Z4EvpykxsMWXPLViO0EFCEkFwnlKCn2Yvw/XRH++0QreT2ZqncPQ5J1Tnmsjd+g2BNWeFWClMXGZ8mm9J1f47HvWbwzFDlat02t1F/mPJ9UqKzuDI3h+WIs0XQm1zVUrxLDN4OaO5Tudn/pWdzjG9ZfXjw3043XRQZIGfRLx7rHY3cUQ1zEgk/Cqyv73+lQqGA7DcvnxB6geV9BcoS5JqHDTRfrFmCGf8/RaJasUIDqXLzoqnLOIC9G85R8Oqg6QZWnk3+I02rGDU6Df1iEHD/H4icB9gXTh5Jmr8cICWgoVyUqNYydOnCemkOGZ/qqsjMgK3W25lhi8Ogs9O7OqE957KkrFBVHhyy4SZB318F8fnDzw4TyjbrVaI2LGMMl+eMB1nZ6Kj0RWdXvzMNXN8N3orA9ta5qsuNxRWA6+WRPl7mN7Owdgt1b5Xl2uVAE8Ih+6QY3a+brDll4B5Q6yeU++SQsotSDt7bdTdpexw2kS2P90p0VpaRqBsWIZtm2teDqA/8T2jENSSzdnpDu/vuoXNh019OQP5+QbyvoZIo3iAVbeJyzCVdE/mV/8Vez+gagF5VMHo6V+pEUvmtrY63hWeEdR5ebVjIQO2HCYlYuBO5l8pGjo1rokyRTT/tkFfqoO+SZYQHveJXv5JzYf5P69wdEeoCp077TAG4/DfJ/GBuMsyx+TvMt3drPE8w10hpWX+H1M44Kjc+JnNCtqFUNvtcDsm08lIlN7jaj29Asqf8zM9YgG/F6pDfBp684N2SXU+LUGobXMdVJybRS6p/ZDN
 zXEf6fOC
 YdkHxChnxCyBuuqkv6TqruGR4JvsoCSPz6AiNh3vSDX9YLrUfiuWvuAW0YrTqTsafzT/OoOypDxdatcPcvwygYtNsnyCJs1eJn+T9ATM/7cVOAelrOdUmwbijI6Oj0bJy43HuDuA23FJzVGH8DvrjoliVsjN9A+k1EJcAeNPYWtwfWI7tNgoJO7XxsztTYX/pYak+uwNKCdLSjp/ndWwp1hgAozu8i3ij+86+heDLeOpQF661M9yZtZGYIz37UK82IWz5KSN2i/6HHN/w7MS7wm9smxnL6BMajggLnAxSJVT6iv2ilLEOdHEzUfFhtvTaD7h3U3iUwuSPPnbHaThyLhX9OW9FwHX+g7O1rtzfTH2L/nYfz4OTTg8uRYWTfX9pphHD/UsWRs4d+F/pID0ugkmnhBNd9+7Si+ppTq3gnMp62wx7cGLYINWVLYntFOzOqntFKGeUk7IQoiphYQM3x7Siv9Fhtu2rqlDhJ1iu9BSD7Uac8ZqORtUV0mexO0SlOKzKsEFr9x+Do3Ud+HEOqm4B1EocGQyIUK6n14+rgHFyEGaCWm/5dt9Lwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

print_bad_pte() looks like something that should actually be a WARN
or similar, but historically it apparently has proven to be useful to
detect corruption of page tables even on production systems -- report
the issue and keep the system running to make it easier to actually detect
what is going wrong (e.g., multiple such messages might shed a light).

As we want to unify vm_normal_page_*() handling for PTE/PMD/PUD, we'll have
to take care of print_bad_pte() as well.

Let's prepare for using print_bad_pte() also for non-PTEs by adjusting the
implementation and renaming the function to print_bad_page_map().
Provide print_bad_pte() as a simple wrapper.

Document the implicit locking requirements for the page table re-walk.

To make the function a bit more readable, factor out the ratelimit check
into is_bad_page_map_ratelimited() and place the printing of page
table content into __print_bad_page_map_pgtable(). We'll now dump
information from each level in a single line, and just stop the table
walk once we hit something that is not a present page table.

The report will now look something like (dumping pgd to pmd values):

[   77.943408] BUG: Bad page map in process XXX  pte:80000001233f5867
[   77.944077] addr:00007fd84bb1c000 vm_flags:08100071 anon_vma: ...
[   77.945186] pgd:10a89f067 p4d:10a89f067 pud:10e5a2067 pmd:105327067

Not using pgdp_get(), because that does not work properly on some arm
configs where pgd_t is an array. Note that we are dumping all levels
even when levels are folded for simplicity.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/pgtable.h |  19 ++++++++
 mm/memory.c             | 104 ++++++++++++++++++++++++++++++++--------
 2 files changed, 103 insertions(+), 20 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index bff5c4241bf2e..33c84b38b7ec6 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1966,6 +1966,25 @@ enum pgtable_level {
 	PGTABLE_LEVEL_PGD,
 };
 
+static inline const char *pgtable_level_to_str(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return "pte";
+	case PGTABLE_LEVEL_PMD:
+		return "pmd";
+	case PGTABLE_LEVEL_PUD:
+		return "pud";
+	case PGTABLE_LEVEL_P4D:
+		return "p4d";
+	case PGTABLE_LEVEL_PGD:
+		return "pgd";
+	default:
+		VM_WARN_ON_ONCE(1);
+		return "unknown";
+	}
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/mm/memory.c b/mm/memory.c
index 626caedce35e0..dc0107354d37b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -491,22 +491,8 @@ static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
 			add_mm_counter(mm, i, rss[i]);
 }
 
-/*
- * This function is called to print an error when a bad pte
- * is found. For example, we might have a PFN-mapped pte in
- * a region that doesn't allow it.
- *
- * The calling function must still handle the error.
- */
-static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
-			  pte_t pte, struct page *page)
+static bool is_bad_page_map_ratelimited(void)
 {
-	pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
-	p4d_t *p4d = p4d_offset(pgd, addr);
-	pud_t *pud = pud_offset(p4d, addr);
-	pmd_t *pmd = pmd_offset(pud, addr);
-	struct address_space *mapping;
-	pgoff_t index;
 	static unsigned long resume;
 	static unsigned long nr_shown;
 	static unsigned long nr_unshown;
@@ -518,7 +504,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 	if (nr_shown == 60) {
 		if (time_before(jiffies, resume)) {
 			nr_unshown++;
-			return;
+			return true;
 		}
 		if (nr_unshown) {
 			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
@@ -529,15 +515,91 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 	}
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
+	return false;
+}
+
+static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
+{
+	unsigned long long pgdv, p4dv, pudv, pmdv;
+	p4d_t p4d, *p4dp;
+	pud_t pud, *pudp;
+	pmd_t pmd, *pmdp;
+	pgd_t *pgdp;
+
+	/*
+	 * Although this looks like a fully lockless pgtable walk, it is not:
+	 * see locking requirements for print_bad_page_map().
+	 */
+	pgdp = pgd_offset(mm, addr);
+	pgdv = pgd_val(*pgdp);
+
+	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
+		pr_alert("pgd:%08llx\n", pgdv);
+		return;
+	}
+
+	p4dp = p4d_offset(pgdp, addr);
+	p4d = p4dp_get(p4dp);
+	p4dv = p4d_val(p4d);
+
+	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
+		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		return;
+	}
+
+	pudp = pud_offset(p4dp, addr);
+	pud = pudp_get(pudp);
+	pudv = pud_val(pud);
+
+	if (!pud_present(pud) || pud_leaf(pud)) {
+		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		return;
+	}
+
+	pmdp = pmd_offset(pudp, addr);
+	pmd = pmdp_get(pmdp);
+	pmdv = pmd_val(pmd);
+
+	/*
+	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
+	 * because the table should already be mapped by the caller and
+	 * doing another map would be bad. print_bad_page_map() should
+	 * already take care of printing the PTE.
+	 */
+	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
+		 p4dv, pudv, pmdv);
+}
+
+/*
+ * This function is called to print an error when a bad page table entry (e.g.,
+ * corrupted page table entry) is found. For example, we might have a
+ * PFN-mapped pte in a region that doesn't allow it.
+ *
+ * The calling function must still handle the error.
+ *
+ * This function must be called during a proper page table walk, as it will
+ * re-walk the page table to dump information: the caller MUST prevent page
+ * table teardown (by holding mmap, vma or rmap lock) and MUST hold the leaf
+ * page table lock.
+ */
+static void print_bad_page_map(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long long entry, struct page *page,
+		enum pgtable_level level)
+{
+	struct address_space *mapping;
+	pgoff_t index;
+
+	if (is_bad_page_map_ratelimited())
+		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
-		 current->comm,
-		 (long long)pte_val(pte), (long long)pmd_val(*pmd));
+	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
+		 pgtable_level_to_str(level), entry);
+	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
-		dump_page(page, "bad pte");
+		dump_page(page, "bad page map");
 	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
 		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
@@ -549,6 +611,8 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+#define print_bad_pte(vma, addr, pte, page) \
+	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
-- 
2.50.1


