Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B8CC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0CE8E0043; Mon, 11 Aug 2025 07:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B216B0172; Mon, 11 Aug 2025 07:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C857D8E0043; Mon, 11 Aug 2025 07:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAE726B0171
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:27:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AC4955F87
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:05 +0000 (UTC)
X-FDA: 83764250010.16.D8652BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53A1A180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M/Jia8yl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfX1fQMnvUejv+2+JWwebv5CirI4aCq8/b8BncrLfY4=;
	b=Uk6m55z9NmsbNrumzBPsuvlPaAkSj10mn48PQetVjfNExj0qSgEP66LHlukHPZsq8B5Amf
	dPL/o1C4NFkiggX3nHoWdztmCSlQZUte2MVuKrutNFAJLQSHiUvoydEHGXF2kuO10IUakf
	kJfq3F6UG8/UbvNsMqp9tg1fylrhVkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911623; a=rsa-sha256;
	cv=none;
	b=thVTxJpM5p7q7bozneRaPUHYAHMRlvDQpKzdqPM3cg1dqWyd/xk8XUQSRLPZH2ouhpjrG5
	PVaa+chGDnlWTnSWFAHHj87nWqqD9QCjcTzJXE2CxAsyZh0IVfkTZKV3O1Tv8S1XweOa+S
	OvIASpMSoUanOLkMqgZcdqvRpsEwYY4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M/Jia8yl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DfX1fQMnvUejv+2+JWwebv5CirI4aCq8/b8BncrLfY4=;
	b=M/Jia8ylEwFnEJIKIYmljTKYo6R6xqrWqn7X4qPa7gz2cUI61e6gR5b/lj8ZsoHg25RODd
	7L/Bk+QO9Vk4qZFIlTdOl5Su7iT7lyFRpqmDRGuSznrNiln0F0y1SakoWlmwOXtsRQLwKm
	Vi2RIdft5S16EXXPZ1No4hLtFCTYXQA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-ioS86qaCPaa-zUL91kZb2g-1; Mon, 11 Aug 2025 07:27:01 -0400
X-MC-Unique: ioS86qaCPaa-zUL91kZb2g-1
X-Mimecast-MFC-AGG-ID: ioS86qaCPaa-zUL91kZb2g_1754911620
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-458c0c8d169so25192425e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911620; x=1755516420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfX1fQMnvUejv+2+JWwebv5CirI4aCq8/b8BncrLfY4=;
        b=OxsrXJ15G6OqYxC//2/g9NMngNxHr7ooQxjo+lHKxm6JA44+5aiSKCQKaeGOWTCn4P
         ss7jfB80C1nRzEhFqSSNGB+hnozjYfmV7r/ETNAYx3GTRe3PV4oqTxI5XES/CtHcbQxH
         tXRlPyGemI0Ez3rRvuZobRGf6A6tHYOeFdU0rvTohUqBYYCIX6f6ZRm8R97kPirGVthV
         vyEdAGkTBqYJPWKg2Kb5FozdV+SZBGPOO+e4IR+oSAcFhhyOuiFxeCS3b8tofZL59RbY
         /dsRWIEUnM8h7d42nFHC9f2MNPUrJ7ejrx/KhYRJinK0QjKLhOWpvpuTosIBIN6Eb0rF
         2/5Q==
X-Gm-Message-State: AOJu0Yxy8AkoTa6gkmKR6gZ+MzBsOq8lPxeJAHWdni0yqBjcrVtfe95g
	Aaknq9GEr3FtSImZebs1Llm85tnG+hnIPQ0hsplVOBHdrvrNlOMpyKGRr+rafzYpY7477TectcH
	BS7fMPRmfQfSbyC4bKVueWmpzbTNNTK9erJyjC0UpZg6MLckRy6RE
X-Gm-Gg: ASbGncuDaaofAi0f4iR9/C/q6liTuhv+ADXyGAS0b5rlM70ecWPgjp0xF6eiobAHSAv
	cW+qLOS2VWWNi38QtZ6eBcgmcqlN9lTYtuqu08bp8LDSU6NYcRYFJ5Cx8m9l29uUX0QcOvgj0ic
	nhNOVvuBMgm8e6EjWQIVpvMQ/C/VvRq2FXCIZVQtsCTCywJSdIWAaYq8xDOqwB9Vx2/KHnsWN/S
	yZUb0p9qhwzl0gmwvSY+nARypWgMRTdIi4yjqsPoLjrVvTBdT4pH8tvBINC+dh61RiybVBtHxAO
	XaLVXhJx5weH3//WJQ1uhV6654jpHuu3Qqdo+RH6WyXPo7nbDbF0FqWmEfv6cHo0V8YLIZcm6l7
	ekdP99EpPpL9Un7Q+Ozq5vTDT
X-Received: by 2002:a05:600c:c493:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-459faf4758bmr80581335e9.11.1754911620246;
        Mon, 11 Aug 2025 04:27:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBm+6FX9Xdf6wc1nTSJlLqt7RXq7PC8peG73SnR2aY3/2U0Fhn5nWzADDyt5hVIbhoPtrtZw==
X-Received: by 2002:a05:600c:c493:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-459faf4758bmr80581015e9.11.1754911619781;
        Mon, 11 Aug 2025 04:26:59 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458be70c5f7sm376335155e9.26.2025.08.11.04.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:59 -0700 (PDT)
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
Subject: [PATCH v3 10/11] mm: introduce and use vm_normal_page_pud()
Date: Mon, 11 Aug 2025 13:26:30 +0200
Message-ID: <20250811112631.759341-11-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cjuhNXRCY2JjtOSLs3js1vzhynEMMSIisWYr0U6wFUo_1754911620
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 53A1A180006
X-Stat-Signature: uggehwkn5dsrrg6dshon4ubymodcr4z6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754911623-935860
X-HE-Meta: U2FsdGVkX1/SKKp/C+yEo6cXLSuAviuggJmq2ew0EINNSGC7gQIpDSZvr/n32Vr+wJ57NOE5N6fy9kDFVrTK+zRjEmooyH3wvvcW/9mahyzm4ZTcwLP495VScGqg70lSY1qf4hLsM0kRD/BxmJE8wJlVOlyRrIZdYEeLURRCZd3JXIQeOJPSBwne+KyZeZjOQr/wXSSHECh8ZwQSixuvwgAKv6saY6aFqK79FRP4PG3NV1diB3REDt3Ysg/f4LdwGVZzxSxn1DQ7EfiSmCGYfJ8v0U8B7c1yyH4o1H5eRTfKY4giWE9YEX9lAFgUWqYpfQjW/3nwh2lMfZxIjxlfSnDg5BQsbLSFjo7IJFLiq1f9sQHwOQrOAseFu1eQbffFgZzP/TKRbnmHiZlU36SAQ3CwtuIbYRsv5MK5hgdRlZV3n5WsOckaSRoqavBddu9QXMgauC6UHnB7rmGDeVvM2j01aT3ylvaB+RWf+5IUb/y06TS1233Q3JJV81M4JamoQBC21N8kRhWaGHVhvk1+pwS5VoRxCWO9An49XcaAfZb9b8G24ywv9RzOh2LGoMuFvs8mAQd8899SvHRjX5rGqLFb+0j8pGzF3An/jsTqV6IwHQpYkHgSyqeh2Pg/kEik7zcqp0oOFUEKPkLK6fe54qDYHwJEosP57GBpRmJOvvV5i/DaB+EFXQfVkBPxolDIh/EbTIOk6f9gzkA9dMEsbAqzEZm3FCFruKPJKVR1avB0kEu4fjBEeolyqbHYpHS52R8Z1+O3AYj1SPlR3hp7EMGmTE37EcW9n/MBA3zqwsa4WUSBkOikmzFUCa+wkGpxVcAU49ECNinE9KQXZAk8EVpq1hRtZILUsBVlACnVpdcXE57aQWvX4oSPe05NsOk0pzK8/7iwxd3pB8UtmS8FuRMtW+5JImSyVFK+8s4AlfIDzi4OyUwNeItUKMaa6Nb/k/DYUdXjJm4GAjR6rZz
 tsHkXmJx
 Y8C2FBHCERJWEeRAt4TyBFRs3z+sN1819k3rZWdfckqy5kOPtKMZctHBDU62hR0UidjPw5/flB04+ZF2Ivd2KNA+ybu8e0enraGYsVYtZO+ToRRKhRT9RpJ6vw8inFRAbJO+ozfMjawIZ6lisB8mZELh8ugoewFAka7ydHUA5FIcuH/b3L80SLAx1wTE9hlfKY7xAkejGKhNTwBODQj4Coq/rXLMkpIzOpvLQX7UUoIfOdTBAO6WRQa8Be8x5UPI8iLO+alUVmPNFTvaz//VT6gbSQLCd6Ff+ZGeVAJf/BbfhYXjCusgmsy5rqRSIqOKGyuxSd05nMthGBEsfz5HA+Ll8zF+eBk6SvfEJiaz55jHOwCTctsglOLR3yUul/UCi6h5wKj3TdImO/D+VgwHG9aPKldklQLT0xTHrpE7WRnmVBwF06lD6AtWQHXYIv60RXBAziz5N+uoafjxP0Nhy96J/+qS2bz7tkm89ADCV4543oGt2gFH4Woaije4JDvv8qzxRCK3VDHhiO7XtvOVIfyEVvAAUDNv7xgrqsf77854NIXYWBPT56smeTe1fkYqo+7Fwq6Vx//SNl8FYlSA43GEWpzUQB4W3diOfbA0BRySNNi05bjr3SjFK5icMOCi3G9YPmWC5cUGD8gEdrCJbXVsL2q5EzSTxmJlpyv3YoascyKwDjdKcG0E0bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's introduce vm_normal_page_pud(), which ends up being fairly simple
because of our new common helpers and there not being a PUD-sized zero
folio.

Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
structuring the code like the other (pmd/pte) cases. Defer
introducing vm_normal_folio_pud() until really used.

Note that we can so far get PUDs with hugetlb, daxfs and PFNMAP entries.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 19 +++++++++++++++++++
 mm/pagewalk.c      | 20 ++++++++++----------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b626d1bacef52..8ca7d2fa71343 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2360,6 +2360,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t pud);
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index 78af3f243cee7..6f806bf3cc994 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -809,6 +809,25 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 		return page_folio(page);
 	return NULL;
 }
+
+/**
+ * vm_normal_page_pud() - Get the "struct page" associated with a PUD
+ * @vma: The VMA mapping the @pud.
+ * @addr: The address where the @pud is mapped.
+ * @pud: The PUD.
+ *
+ * Get the "struct page" associated with a PUD. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct page *vm_normal_page_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t pud)
+{
+	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
+				pud_val(pud), PGTABLE_LEVEL_PUD);
+}
 #endif
 
 /**
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 648038247a8d2..c6753d370ff4e 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -902,23 +902,23 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pudp = pudp;
 		fw->pud = pud;
 
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
-		if (!pud_present(pud) || pud_special(pud)) {
+		if (pud_none(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
-		} else if (!pud_leaf(pud)) {
+		} else if (pud_present(pud) && !pud_leaf(pud)) {
 			spin_unlock(ptl);
 			goto pmd_table;
+		} else if (pud_present(pud)) {
+			page = vm_normal_page_pud(vma, addr, pud);
+			if (page)
+				goto found;
 		}
 		/*
-		 * TODO: vm_normal_page_pud() will be handy once we want to
-		 * support PUD mappings in VM_PFNMAP|VM_MIXEDMAP VMAs.
+		 * TODO: FW_MIGRATION support for PUD migration entries
+		 * once there are relevant users.
 		 */
-		page = pud_page(pud);
-		goto found;
+		spin_unlock(ptl);
+		goto not_found;
 	}
 
 pmd_table:
-- 
2.50.1


