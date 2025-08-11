Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD18C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581D08E003E; Mon, 11 Aug 2025 07:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5324A6B0159; Mon, 11 Aug 2025 07:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420D58E003E; Mon, 11 Aug 2025 07:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2EF6B0158
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 004BB80140
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:47 +0000 (UTC)
X-FDA: 83764249254.13.9C207F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC08040008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHIgDDer;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911605; a=rsa-sha256;
	cv=none;
	b=e3FlDG/xS3dlaQ+vzp+7986t2616KC5TSgB2vxDQ69zcQ+ckdorUPlQs+2tI1Fi70CKOgG
	T0HpaXQ7Y5msIkQtzK8H12P/WsQahCcmNOFQLjnjGojJ0uUnTVodQoSn+dCFaZ1QEM80fp
	h2XZs36S8xclwGsCcuLq1FNlJxewFhE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHIgDDer;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPzS7A0H2JYY/4bVoDqq5vs7hjaSrgBmC9jJDJzHOMU=;
	b=DNP+3Jum+7CbL3R4n7cCmkcvDG9eBBB+/WPKNOC5qHkh4raLDFwXLoj3l3ii4kOQNRtP99
	L5YcT9FVWYcIjZpEI8lBz+6x9dvwclBGr7kBh9JCeca0wQ2t7TK+DZnkQZypVsWE4bNVDS
	b5wDN0szq4jynTRgTfi1+i1oOGeiK5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPzS7A0H2JYY/4bVoDqq5vs7hjaSrgBmC9jJDJzHOMU=;
	b=MHIgDDercPLuz7pteul5tWFHjneuoapL5+LHdKKsGx/LVYDv8WWTlu0eatfgXf8yOiFYi9
	fubb/gj2MmuibpOIlWSpHbJqsNH/zWt97BArdZXWX8psJpsCOWalF4ZtFzOyVvTZ6TNn+2
	QXLLtrj5s8q5WQ5dfYehsejmXfWo0iQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-B7Mi2Vl3Pv2HaAVfGJtafg-1; Mon, 11 Aug 2025 07:26:43 -0400
X-MC-Unique: B7Mi2Vl3Pv2HaAVfGJtafg-1
X-Mimecast-MFC-AGG-ID: B7Mi2Vl3Pv2HaAVfGJtafg_1754911603
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d7ae12b8so30613985e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911602; x=1755516402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPzS7A0H2JYY/4bVoDqq5vs7hjaSrgBmC9jJDJzHOMU=;
        b=Kxsw5gKls9JkKJkZYtuaWO8y6KVXMk8Dtbx1ZOAfyZ4zfuqQGqmST97obXcc16NaZQ
         zqgDDvYydfJ7p8X25yzInqWPIf9GwzmiaFPhH4HGIv8888+P24DRVA3jTxmt1K7IXo2q
         1II2gcA3fyd1yJpJ+di+QbefiNe5ftRHTaSVfxC/2Ik3sRpTAXPLJmknV+zcSrpW+ADK
         Hu4OYkCbmhLkSdmrsSKv5MDLVb3gIVmd6RJD2YreANShkmHFXSGEAilzFzcxK0NEFzJq
         z9AVf+tStWa58m+w0ZORtZsP5LyZHvaKkz8JBE5gy3U3+GeR+ixWIxp5z8ibqvOsj5Bp
         hTkA==
X-Gm-Message-State: AOJu0YyeawCM3Futb36m+mj/f3esh4E286D3r6JIk/KXh4weQfuPkqCz
	GRlsYOWHhbsNoKXiz+CM7X95+WGhJnVjRQLJMH9mbe39lKoJjbb/BHRyx0sZHt/vDLY91oTobEx
	NQbMEVdu9erZ27Zl1slogtFduZTw/VWrLOGNK/7tj4JB5FTEqGYVU
X-Gm-Gg: ASbGncsGNzyxxyXWlWIFIpT7Uvwry/3+Zxk5fN/iXtAKjwHBCf3Rmc9gaNtviCxmuwT
	PW0+bulB5mjO9UyG8dAxLaqqeie+HFkF3WX8/WkwetUjeHDt/XeFRZvEEq9JRboI73b9fV8f8Ku
	LbRHg9Y+9iQnUaaR0sQHwPVysQyWD8ODH1eKEEpISErgkL/hANYSAMalWZ+kLvZe1Y0XOXFvIx5
	sQagVCV54R17ZIIEW4yAu/o3UYSczXQ9wL/IHaPUr/xnkdZYMtKPoYjipcgBckSyhlTiL0ct0cv
	oYjwOz2OG3DE3/UZxXo8EFaW9Kv8ORdrOimv21BOukmr/WOhU9jSy2JrbCPmI95geDPfBDnNuV7
	86QDW5gH5yhMoM6qVvYw+uZy+
X-Received: by 2002:a05:600c:4ec7:b0:459:e398:ed89 with SMTP id 5b1f17b1804b1-459f4ea2167mr89525715e9.1.1754911602515;
        Mon, 11 Aug 2025 04:26:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2VXT8eja0G/6oYjAzMox3Wj/YsLa0WXg9I30LI+rqq9mj5h9Avu9edvonRgK7PI+OIDYPVA==
X-Received: by 2002:a05:600c:4ec7:b0:459:e398:ed89 with SMTP id 5b1f17b1804b1-459f4ea2167mr89525255e9.1.1754911602063;
        Mon, 11 Aug 2025 04:26:42 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e6dcdbbbsm122068765e9.7.2025.08.11.04.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:41 -0700 (PDT)
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
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 03/11] mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Mon, 11 Aug 2025 13:26:23 +0200
Message-ID: <20250811112631.759341-4-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fq9jPH_YRtKT5F9-0BHeZkaNkOZmuyEYUrRF34TfM7c_1754911603
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC08040008
X-Stat-Signature: hqffmwzxekfq87en4uwhmamk59n9mjyk
X-Rspam-User: 
X-HE-Tag: 1754911605-473938
X-HE-Meta: U2FsdGVkX19nDKyOZrCthRzQvddGFNyCGOhFRMCw0DPmA2PC83EHMgtV5bjByITUh9xBpEaWIOlUaQo6M9e1IHyhijnNuqBdnULrq2mgbxlqWEgysBJc2R7X/f3f6ssAhiIZWRP80te4oFsXr0J+jhgZRxGdjHQaZZsgB9JtJK18ArhlmTd/c+X6nRSuRPtFiwtpdftFZechOPYv5Amu/z06q4oNzWp0OxAH/LdJA8WWCiYsPgo74AvLFGOKIsYGHO6X7JcZjHG2uLS1Ra3nXPHN4eLMUANS5c/rPd4zITfzpB/M2Ahhkxd3Po/4rVXGPYXVUTS1jGhs0hUF6EZec064zfTAqn4CUyj7fyPDj12WI6dguHjeyc1Jne3gylRjyzSf3rKRcxCXgL560oEXNkAxMgm6v3KWIX96IT5MbIRQAKcsDYkH/o4k3wvvdWtRMmzAeafjbRxy3wSeCtChMkhSY9zkLZ9KTQCaeut5KitW0wWidRil5zy9Deg8VeDyRkSbBrCeqHPKun7SXeOaDfVzEK5XlUalm8GtqUnYkPWaawmLLaS0LohRkNSDfggdd6b2tth4zEma6cmJFGcjIZ6aQ/F+hl2rsXH50MzWrtIOREkBQ+Wv8NT98leU99Le/2fyUFSLZORGOis2oWokU9FU9KA7JJNAk4pvvE3Ln0mSNsn1pi1OIp8/4xL7oMCVLkGxP7wN6CmAyuNL8ylluVW9Knqfq3tIeuFJ9oA1SCSabOKPLYO+IecDDGy7eJhc0ans84oW3aCC/6i/xaODCYdKRJeD05QpPNGvcFvzTNKkmU6XVXirFi9SklIj51m01fnlbGeRf5ejaM4fgt0uwvODQPyvlAFMR5y3Cq5jGqVsXivbQrYupXamFjxGZBh1nRhmpDat3LVsH43Hwov8hGbp0z+JXYd9l3dYrrtx2o6/GwkJhbqvv0aOo5FofE54tc78iP3B8fN5kTkOcmZ
 EPhBmfux
 qYQPwZUseKY5WrigCiNSqa0wbtVv+QZO0sWJ0zCMN5M2v1nEgNBxMHErJCydTdf+y9hLeR9CY9Kx4fT2uBoaIfn29FuPwjwtdUuXuhn60TAyC07l73dTBAmtG0UiTJRVAQU2YovbTbRGYZKOSGeQQl40nw7BHuFIGrdf4AwF8QcSoELP+yLM0GRGuqfIEnQRC6Cu0UvXF0atV8HsvHVZKhoMF0Zvz58w2R4DHyJf/CVj3kqOPPDiMnd76qR0uVH3zNUw5PfeqvLpxzQP0TAvFNmzrpGbSvB65gHHxSkrAcrJ8uQCKBkR3adg8vTX+XLylkji/CD59hi+ohg5GR0So4/QNcvzfm8r3yVN2hwyjveXGcL9j7W89vSPiiE7BHP8/0qP6ScAx3Lw0Gu1gOwbcDKVPTraz8m7l9o/4XVplJpeijjxsINa/lHeQ4LPtgjIYlGZPFeaDj1KcW1idhaZz/grU+PTeULt4icpoP7U3dgIMGqn32hG8j5lrzc7eHq3POzfJ6kN6WdiNCAqBi2wksxPhi6fob9rkRQpZUDpZDz9HM0cld9+EseGUDlQr5RJOnz/MYa00v7O5/f6F0V3675ZHWLztQQyEl5EJcbDNPpAcyIEWBD9wB+Y03HISd0EVgnQd/6/+VTjRTIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just like we do for vmf_insert_page_mkwrite() -> ... ->
insert_page_into_pte_locked() with the shared zeropage, support the
huge zero folio in vmf_insert_folio_pmd().

When (un)mapping the huge zero folio in page tables, we neither
adjust the refcount nor the mapcount, just like for the shared zeropage.

For now, the huge zero folio is not marked as special yet, although
vm_normal_page_pmd() really wants to treat it as special. We'll change
that next.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7933791b75f4d..ec89e0607424e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1418,9 +1418,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		folio_get(fop.folio);
-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		if (!is_huge_zero_folio(fop.folio)) {
+			folio_get(fop.folio);
+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		}
 	} else {
 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
 		entry = pmd_mkspecial(entry);
-- 
2.50.1


