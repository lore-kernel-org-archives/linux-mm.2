Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC449C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECD26B00C4; Tue,  4 Aug 2026 00:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5FF6B00C7; Tue,  4 Aug 2026 00:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0A26B00C4; Tue,  4 Aug 2026 00:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 569416B00C4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD2F7808C9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:19 +0000 (UTC)
X-FDA: 85062302598.30.94E0EF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87AB8140008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y0ONHbuT;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817637;
	b=oMGQrPYDIWFyU5K8g7H4pwX/h+UmZJkAQdJpQZJVlBJqhZyrAUC5QHb5CYBdoMaJKiCYLK
	cj7TJXVUP2CV4wMEOa1V5tvcHZk/wNgm5gVil6aDCjbyiYgvJiw8iHuT8KEzM0YLXvR+xE
	IWz9FdDm6nj9jaVAgCYqQFXmfn9U0Uc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y0ONHbuT;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWLoSmzvlWrra6TV4DFt42DXFKEy+9KqLNEl12wX4Kg=;
	b=F5Jfa9b9UYuYfy3+xmCWmW9oqcY+JJhj9h9hCObCUU3dksXhTZneJ5xHtcwJm8OM8NowB8
	XqA401iBtRXMaOpZGcRNPb8ayGSX38Ii9N2HirF/K2Xm4pnc3EyVgfIJ5jyga9wKUA7eKv
	5jUv6HAoxXbjLH4gDpFEPT2V+fPtpO0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWLoSmzvlWrra6TV4DFt42DXFKEy+9KqLNEl12wX4Kg=;
	b=Y0ONHbuTotaUU4rMZWfx1EomJsCc+pYkdxzeCJR9CAg3UknwkYGq+rCz3RF6GqHSAhds+e
	92qjTTXMHz0u0hAMVt4/JRfaW16mTSGt+VVXQVMA5ehUfGsk7osSOxYbB2Ic04Q44a/096
	WgIObD6fVeCBcLsR5BIzbvIO3JWb/tc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-6vCnbUFlP2mJjYK4BSKWLg-1; Tue, 04 Aug 2026 00:27:14 -0400
X-MC-Unique: 6vCnbUFlP2mJjYK4BSKWLg-1
X-Mimecast-MFC-AGG-ID: 6vCnbUFlP2mJjYK4BSKWLg_1785817633
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aebf128d45so282112e87.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817633; x=1786422433;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NWLoSmzvlWrra6TV4DFt42DXFKEy+9KqLNEl12wX4Kg=;
        b=qYa5bEy7wqqP43CZD7uHf6Qodq3iiKi55oOuMNFUNYSaeey4GaxrLJ5iZp9XWA4Epy
         uUD5SEvpfvSakjneYIiIaTIIFY/+x34eDXyd7WF8Kz4+vQw/CIh7gLxy2fAdN82GeHIA
         301AF8SK9XPQ1Q7HjU83wG8yiUg5BCDZvxtkwvk7kghH7reIw1u+akAnhGxMwhHeaTnt
         rt8PiwIUnAQ8TIxD3FFL0draljEKhZEwFVFMsybylyvKkhbCFNbbXyFwFz/o2b2UxFXS
         GWJlPqlA8s7Tzx7rVBGX+shM0bmrdVt+K7Pgy604V6CZVSwewpLuIgyqk26LcirnyX2a
         aXeA==
X-Gm-Message-State: AOJu0YxhHQd2k57y2oL/gWJ0s3Zl+zYKRNy5uAI0Wq2In6rCYEj9YDVx
	TBPFQC6eaq6lvdKCKazPPGO7lippshHu+QEfbDrdJHDWGuxIelBRRHyH3MX8BAqtgrCszfRdqjl
	VZrgd91ymqmci5SMhLg4qp58ZGmMpI+kLsXHjUAsUeCM20Fgu5Q2/AK3kIpNxDJghaOlLe6YQFU
	dLRKLAIybK4C3e2Ei2NYyazLcJWto7EiPIp7hosw==
X-Gm-Gg: AR+sD10+SNnfH1DqGNRTPtxKMiP9NR5C9wYBc3ruzkpHyBLEzV1FKtxEkEtzN3iNg9/
	An7tl72JH3xFNF6qqy7IeVwzQnXFBfEm0ktYhkQn3Ll1R8LPVsz0/XybkjYS0hOYP8XcBgQ3yNH
	56tF5o1Paud3xfzPo8pAXPsyTEJy88WY8M5TluX7Onceigl11G50SAR/dQagY+YbYQy+Aaa5d+b
	RriTcUBsAVdNCvMLR5w9zkdVaIBKzC9qSJDbxAdM41Zwgj+YD6V+YmOy9w23i08q4LgFTC8zYwh
	/MMROcMFNDp9h5uZHW0+id5kMcKKU1f8WwvpDc0He63Q8pAItiuv9fk5JeT6bQbw+LCOcahObMp
	xhBp7UZD1tyCM61qJ
X-Received: by 2002:a05:6512:6ca:b0:5ae:b7c7:5334 with SMTP id 2adb3069b0e04-5b2ee622c99mr384797e87.17.1785817633395;
        Mon, 03 Aug 2026 21:27:13 -0700 (PDT)
X-Received: by 2002:a05:6512:6ca:b0:5ae:b7c7:5334 with SMTP id 2adb3069b0e04-5b2ee622c99mr384770e87.17.1785817632836;
        Mon, 03 Aug 2026 21:27:12 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:10 -0700 (PDT)
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
Subject: [PATCH v13 05/11] mm/hmm: implement folio split for migrate needs in HMM pagewalk
Date: Tue,  4 Aug 2026 07:26:25 +0300
Message-ID: <20260804042631.2175585-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bDFykN2Zd9jGFeBHW8OTfyQSTDe4jcHN7phzcweor88_1785817633
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87AB8140008
X-Stat-Signature: 6jks7xq6xytps9oo9beemb6qygds94zq
X-Rspam-User: 
X-HE-Tag: 1785817637-819840
X-HE-Meta: U2FsdGVkX19v1LY1bGWi6z0G0AnPZMccDMn1xtkTqHmSN3/DCgyjc4jPqQMjEdwhYmPVFGJxMUD6O0aB5unwztDqX7xWE0q7onxeyprK1JpcNGzuFHHy9GrIxgEcHd4QwD1H63GAiWHvJRWj8nnu5C/iG4GgOJNDsWRle2l1y8KnteJ49NZ1SEomIfcjMG17DW4davKsGMOo6bX/NrBCA1BwQr59RDfPwMjV9Oc77szZzFH2qPAT323kW8wbTD95D1pgyFT4RfK3K/IYZd5ucRVfW7OPnpJSgkJiEKhXMWYAc1tIYA/GREYD2gx0YAPXbXOFzMLTcJ4jZvGTojxVs8Z7qJRqRE6Je6YNnnRuyk2NNfGKZ+hM4fDf7HRlo3BRmdtbqxUKAWbW8nmYrtNnjRFo9mudY0vDRy3URO8+PimhqULT7u29uP5IPG2xgE0yL9EYzMi57N8RiV/ka8OxzlsJyRLjI8WLmbGQLJ9lfeMIL7YeBN9RqO+ZJ+bAtSOY97kpwLZeqTWKaN3WkSqMTrWH0gqgyaV3LhK+YyjakADBpG2YRqaX/PHlSRXYe4w3SVv3wFdOPn21TvRbbAx3TGF6Sjmp3WRamHmko328Wf8INGPEWRCAG1Eg52VjSVIpqOjhVlXGHMR7FQIW/Ig8P2bjFpCFhfK28srnzhatDhqkViFCLczOSHBMKBzcIZGrU11DQCDzIUNNcPjLdCMpCOBOhINuT3/W2iivKVlWvAVQLcA8lTRQBabohYi9jMpcO7PrTrgBzD5W3QZLoDmcmOYyzVP0mR3mW584pr3NrxLJYrilTQOJnJXEf3MmRH+X1rUlwu+Ixeq9rxWcUSQTPEjggxCmMt8igaUKD8VkCJlzVwXEABcrfHo7EWBY8x2/ItN8TcbtibJsQRpd2xRM4whzKbSs55brgM2PSLAS/iOMiDT0vvKu005UJl3XB9tInbOwaR1W3pe2VoAKRgo
 JSNhEmb7
 SgHGWgRT9a3SwfXgr8XsHFcKCbEO9dgPNDiZJPw3FOtVNJ+pDbKSqjLeNYoUZBBoG2ekQZmd33l6Ti2HMDCK7033MBQfPsonx9BIK+VdWD7lq8JaNYM+VGL2HUVqOAqJM1hxDNLrBy7cnQvL1CZEoNMJeHib+noD6xqdJvDl5fL3SUHV+Zj+WKeoF3NEbPBfUSxC1DIXSx7b2XsUAQ4g+UYW1oxmCw8Fov/yFXKGeJovKvdUEZlzIVbc2w/QyvQuAKYDwoBqYKSi6M166d+NYEfSOsYlJ7HnVxscxJ0IIGo1xVgk7j4kT0huqE54lJ3CjLZIH/fXqnAGzvocmPf2K30xG74y3cQm4U/C8o9ERUf7ha+JYE+p7fwSxcsqvgMdfZXyplPJXLTK5p1DbXxhumhglw6afgzPmDrouvTDeACZxXDckOUASI87dwP9dzw8URN+lbdy2qzufhrRHm61/IdB8xVG7ElrbHdzzmq/UOQ98pb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the helper to split PMD size folios during pagewalk.
Splitting is needed if the start and end addresses are
not PMD aligned, or setting up pmd migration entry fails.

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
 mm/hmm.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 75e19be6ef76..3621d1df51d3 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -511,10 +511,51 @@ static int hmm_vma_walk_split(pmd_t *pmdp,
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
+
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptl = pmd_lock(walk->mm, pmdp);
+	if (unlikely(!pmd_trans_huge(*pmdp))) {
+		spin_unlock(ptl);
+		goto out;
+	}
 
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
+		}  else {
+			folio_put(folio);
+		}
+
+		ret = split_folio(folio);
+		if (fault_folio != folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+	}
+out:
+	return ret;
+}
 #else
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
-- 
2.55.0


