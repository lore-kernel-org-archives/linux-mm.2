Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AE8C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E837C8E003F; Mon, 11 Aug 2025 07:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A596B0163; Mon, 11 Aug 2025 07:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD38C8E003F; Mon, 11 Aug 2025 07:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B56466B0162
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DD111D8E25
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:50 +0000 (UTC)
X-FDA: 83764249380.12.D4CE330
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34D3110000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HF8efkpC;
	spf=pass (imf05.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CQ37fr3U8Nz67n3Rs/zLbnQBIPHeKcdveRJNY/DHTc=;
	b=UKDTomce1fwy4i9U6DbRxTJdclzP6YGPRBm/4Tg7TtNfsSwS6rTLhEIrVbtGMjbwnNroAw
	8HGTKha2n1OHXwtDjKolJYeRj9BIAc6UKqwgBldfGw8a4KjNaXPAoHY+FRkZfsLYApe+jG
	ZBmg02ohske28ljPcRdJriKepr1Fc/I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HF8efkpC;
	spf=pass (imf05.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911608; a=rsa-sha256;
	cv=none;
	b=fnKtcKcVQn3fuT2ZZk3ZAOsfEkYDlbhE+9a8314RSrSBz8iGG6ukHu7gTcBybP674cadMm
	9DpOnRNuMwSJRhYWmyFAW4/HcruxkoP85JSzc+BoJkaMKduTMjMiRZv7rJbcNCDwT+YFTI
	OUZhKa61ldr74sUsQcl0G4zj4QpA3v4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CQ37fr3U8Nz67n3Rs/zLbnQBIPHeKcdveRJNY/DHTc=;
	b=HF8efkpCovdeGRPT70MfYPsAaEiWTZ0y0ohE1OCjP9NFvhh3mBJAR0NzOoyN7yRZsnnMbv
	yKxXZRR0BGgjmmJxZDPiXaWdv0OP1kCchRY6xd42FcdTIX36zkbmkucopok+npSTISmJWr
	YmszCzw+ACqKcu3akQc4KqyhROT33jU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-3ixVWF7XPLqDBsa3xAH4Vw-1; Mon, 11 Aug 2025 07:26:46 -0400
X-MC-Unique: 3ixVWF7XPLqDBsa3xAH4Vw-1
X-Mimecast-MFC-AGG-ID: 3ixVWF7XPLqDBsa3xAH4Vw_1754911605
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7961b3c82so2140259f8f.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911605; x=1755516405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2CQ37fr3U8Nz67n3Rs/zLbnQBIPHeKcdveRJNY/DHTc=;
        b=YDPr1CvjgE/kvAtdiwdJ9Bp7kuVtIydpWWhb4C6+e9kj/+rMMNki/wRsWmytNLlxl2
         M/zjiP6XwNGdmYLVhJcYnHvH7IbhnG9ykUZpO/Pr0AvoWfb/cWOuScgIwJTRsLjKFbiw
         3lGZrSc2rSUdBsTZaMdBH9D3j3ggqXSJW56MsPJprDvgJEcUVEtL78DLEd3XnFFozGyn
         TjOhqqNdg44TOT/dBHOxf5HShgL7EDoSfraQIR4msaeA1LiKDg14G/xogq+XhaoZY9P7
         dWucXXd6mZQQivTUp78+YJ+gKCgSazReds1owGRTKaf1L8gsBXBI/GtcTHbmmgNe41oT
         fOWA==
X-Gm-Message-State: AOJu0YzCohD6oYRlU2Ih17QFX8r+hd6D4xo60C/FN52CGljZD/d+XXPh
	xsTz3sXzCiuP6E7G4R1tF6DtQIx7ILEByjdad0Iq6UBe2yrnj8uV45S37OIikOK6zQYlexqQIds
	J8IDD6CxzCUu3lZi9oyCJF7UCqNkWSbkb/qijRksqXDjdyF5gFO7pBv3SbNXS
X-Gm-Gg: ASbGncuuAzPRqSaA9WueTwCa+2yFMOcBgSzrnORLfLrDHOwQKVMaRFjkE9ogbJuWHGa
	E5Fy7BfYKMCiTBgL0SbBFn2h4/JGuV/g02fGmSINbzqjU7BtTG7OKTA8hcE1Yb7nYIGwAGXOZIE
	eZQoz3zzeJZKQ2k84hy7fda/K0VtGtEaGpISNiBFAOwR2/WiGwWKho6SOMbdY8RekC5VM4R5QCo
	+IyscGgd8J7Qb/wROIt7iXUVNlUpKR09cwgaGsVnQORjbq9wa57EWOcudi7gQhH0L2zfyCuOZpx
	+uBNfump4+VeEMdDXgO6/qZS9rlNUD2urjHZhfHGSQVbEGRcb6QXRK3s/GtzVkPZwZF2c+d3ClW
	GLPxfMW54AkKetMfoIoafGRwy
X-Received: by 2002:a05:6000:220c:b0:3b3:9c75:acc6 with SMTP id ffacd0b85a97d-3b900b579abmr8417845f8f.59.1754911604951;
        Mon, 11 Aug 2025 04:26:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhtoj1JC1TeyGzrT2XifHRNOizQnW6DZ2myFR7vrwjVvSFSoQpoWzRIG0dK3lnMunpNHs17g==
X-Received: by 2002:a05:6000:220c:b0:3b3:9c75:acc6 with SMTP id ffacd0b85a97d-3b900b579abmr8417828f8f.59.1754911604480;
        Mon, 11 Aug 2025 04:26:44 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4696c8sm39325003f8f.55.2025.08.11.04.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:43 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v3 04/11] fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
Date: Mon, 11 Aug 2025 13:26:24 +0200
Message-ID: <20250811112631.759341-5-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4QDYDpa-zLxusQs8HxRe6MWUz8Wli1KeGLyqLLjDCwI_1754911605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: upmbm5xuhbss6os7ez19nniob8zqzxgg
X-Rspam-User: 
X-Rspamd-Queue-Id: 34D3110000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1754911608-303066
X-HE-Meta: U2FsdGVkX1+1mvXjshgzT2yty8vRtFDYxw8r6xKc9sM3BrQkL2tlfQ7XUyeLjQ2Bm4F/64Q1uAvsuUpWlpiSCYJudsoUBNYeqsHYSenr1yuZ9BUY/kJp0c6rtPXmCpzBB/7MOE2aan7mWaR8lh0cXSJzwNDxtzdx3rNN7K5d3eYCymXKTWKAdwtgZFgDJArMeXSFIShmzO7kpIPCjf4KkbDzlt5sETEwL09pgxEIXkSQp2e95yR3P+Ltyda1WK/jzIx7q+EIhfVG9+kLNMxL9P/axmDQ8uMMlU14OQC1wcEn0LPZ/WBgq4iquBd89W8h4VD6znKXHCbTjjecpuEoxwLzpFEcd1QLCREtAJdsREaeOTpL3iKfgi9BfJJcaVH4xgFcAhwBe0fXrOyZKzsiYKGAcaMnZ8EhETFbPp/ZASf/oifg7aMc1tbCICyKxeLARRjOUFCGAL7jTz1OP8kJtevrG9VbKDh1As21VzrVbciYK0vveliyVXoQzEg27+JCUOjBuqSDHA+6KX3jsmoBNTnipzYbU6hP4hj+dnSkPB0RbYyATYOvDt7eHjTFUXPXW6dKRGHFKjD4UGIrA/N2Y/MdekAQB8zV/CImkb81+Dwf6S3HfxHjoNzGhS6C3KoWOQSDpjrfDNJSqFRDXqiQlxKtjatNiBYa3P+4qbEUt4L76z/38/AQFBx5m5YgU34paBM4Ao9WnAG+jj/4C5xge+XlknqDEbfuyIjzsVIlusfovJ44tjKCa3Sm46XkbNUbwip9RDvYmKZ7FFMJFHtiMVRV5O0jw+ES2XfNAPGKMbeI7xOIWPVfaknJ3bvE8zdesWJkwNkFLYMIJh+lc5pj8CCCniSQsdB3GnmndvGhEMGNTPDcSE1QtAe1EJu+rczNK8S1x3lMTPmX28cRT1GVifCKNoJ7yCUfS88LdeD7bHoHzkOvFtJhTDZVySCokWn5FCLwY35DNRCAs8tTs41
 zDktwbWg
 CYggMsB8cAPTI6Rw/STJHcObqV7K++H4Uy6553fIao1zF5ulPsyuoJODfZsbhCEFpGq9gCpGyPK4zjL0eWE8FOQReqFHUxf8uvlQg859SCNEmf2Xg2uIuVk2BBilPahhmuT4KpgUosPY7HoSSDiDNPAzlLbBCls/bUmGCAOfHQptBpmEC2dcy3w+lEjmJfNNaPcLiwE2g3xKL3AHM200QK9EKlngq/lrWGDKEfsM/K5DTfzEeKRcr9Npc4RxVukWZ103SQguFoNUpQVcNZMpPFyzKGWfSy8VHXrE/zU5QNrK6i0QVfFfMg/lLKYIgVAwjE3HqFHS9XZQ+GrZAUuNDrrYJz3ABvfX3Z2bS9Yo1NPBZrrnCrHn3JywWmq1NcLT/L/w/GQeP9svTxmzXjte1BV/Ch2ZbBWzRcbE1jUJN0xXgr7NreU0ezR7iPRXvBh6SFbGVH9iWIh2CXH/1+DZSd4Kpthxe4n1kLNOvbUqnG6YRHU70h3fLJBnlY6oc8gT3NF2wEm4FzTaV4GsEJxDAb62B77eyfRuWL8shqUdEJGaugEOrLaVVkqttHtTvnBe7VFQNBOurKrBdM2C2fcKEZyTwaoByHM+kEXth
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's convert to vmf_insert_folio_pmd().

There is a theoretical change in behavior: in the unlikely case there is
already something mapped, we'll now still call trace_dax_pmd_load_hole()
and return VM_FAULT_NOPAGE.

Previously, we would have returned VM_FAULT_FALLBACK, and the caller
would have zapped the PMD to try a PTE fault.

However, that behavior was different to other PTE+PMD faults, when there
would already be something mapped, and it's not even clear if it could
be triggered.

Assuming the huge zero folio is already mapped, all good, no need to
fallback to PTEs.

Assuming there is already a leaf page table ... the behavior would be
just like when trying to insert a PMD mapping a folio through
dax_fault_iter()->vmf_insert_folio_pmd().

Assuming there is already something else mapped as PMD? It sounds like
a BUG, and the behavior would be just like when trying to insert a PMD
mapping a folio through dax_fault_iter()->vmf_insert_folio_pmd().

So, it sounds reasonable to not handle huge zero folios differently
to inserting PMDs mapping folios when there already is something mapped.

Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/dax.c | 47 ++++++++++-------------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4229513806bea..ae90706674a3f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1375,51 +1375,24 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		const struct iomap_iter *iter, void **entry)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	unsigned long pmd_addr = vmf->address & PMD_MASK;
-	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = mapping->host;
-	pgtable_t pgtable = NULL;
 	struct folio *zero_folio;
-	spinlock_t *ptl;
-	pmd_t pmd_entry;
-	unsigned long pfn;
+	vm_fault_t ret;
 
 	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);
 
-	if (unlikely(!zero_folio))
-		goto fallback;
-
-	pfn = page_to_pfn(&zero_folio->page);
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
-				  DAX_PMD | DAX_ZERO_PAGE);
-
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
-	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
-	if (!pmd_none(*(vmf->pmd))) {
-		spin_unlock(ptl);
-		goto fallback;
+	if (unlikely(!zero_folio)) {
+		trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
+		return VM_FAULT_FALLBACK;
 	}
 
-	if (pgtable) {
-		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		mm_inc_nr_ptes(vma->vm_mm);
-	}
-	pmd_entry = folio_mk_pmd(zero_folio, vmf->vma->vm_page_prot);
-	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
-	spin_unlock(ptl);
-	trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
-	return VM_FAULT_NOPAGE;
+	*entry = dax_insert_entry(xas, vmf, iter, *entry, folio_pfn(zero_folio),
+				  DAX_PMD | DAX_ZERO_PAGE);
 
-fallback:
-	if (pgtable)
-		pte_free(vma->vm_mm, pgtable);
-	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
-	return VM_FAULT_FALLBACK;
+	ret = vmf_insert_folio_pmd(vmf, zero_folio, false);
+	if (ret == VM_FAULT_NOPAGE)
+		trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
+	return ret;
 }
 #else
 static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
-- 
2.50.1


