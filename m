Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73F5CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284216B00B6; Thu,  7 May 2026 18:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B2B6B00B8; Thu,  7 May 2026 18:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1727D6B00B9; Thu,  7 May 2026 18:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7FC6B00B6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 671B2160654
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:44 +0000 (UTC)
X-FDA: 84742049448.02.57F1BF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B9C540007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XUAbDxdH;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJWhlvrr2Y6sYROe+xcrAWinMhD4jCh5Mi8G3Y5SCz4=;
	b=UVRVdy2C1ebswmCXPS+h96WBZG7tO4HZ/I1TT4+tK81QjnORi8Fp+EWfK+y80nTK5fu5Ie
	42d8VcBboJ5m9Lhl2ex2m8rzo3aFalon9Gu8kE2hzP6FovXJIUrKBQXyy06Gmeo+gd13Sg
	M7h85EYtmyb0p/M3MP2cxQAvc2LOJvs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XUAbDxdH;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192562; a=rsa-sha256;
	cv=none;
	b=W/R2nWZJZS5sQjDaBivWrui5AUra88CZao7hEJj3Sc94+etQXBCx3P+VJ9PRhvM/HCxjWY
	kOHy8m0uwFpNXiMX4o0H70it+S4G83R0K74U00T6TZgXahlLFh3yyPcFnCL2cqHO2ESg94
	Wjl5HZqliyL2ESK/de0K8XCxbK9XSdg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJWhlvrr2Y6sYROe+xcrAWinMhD4jCh5Mi8G3Y5SCz4=;
	b=XUAbDxdHdUG+DvTSr1aCsgOA2HKpBZVQcjQotPz82ZZTRNanHkCfgUumV7i9Y+yW9IrR6h
	nATlEQ6WaX8Mu1M1+wG0F6EAczOWEKLj75UuLqupUg3qLweP6M1boqBPodpaJdER6MudaZ
	yxcNw2FjMJ3zAWiFkim+U6M+gfNbBxg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-I4k9IdFIP12f1ZWtbaDnWQ-1; Thu, 07 May 2026 18:22:39 -0400
X-MC-Unique: I4k9IdFIP12f1ZWtbaDnWQ-1
X-Mimecast-MFC-AGG-ID: I4k9IdFIP12f1ZWtbaDnWQ_1778192558
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488d8deb75fso9980825e9.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192558; x=1778797358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJWhlvrr2Y6sYROe+xcrAWinMhD4jCh5Mi8G3Y5SCz4=;
        b=n94c52toqz8QwbuFT2XIg3mqEts3JuhQSB1ZdsERjb1vac8nQ6pZUiMooOkYiGg3a2
         hhp1IiF8zWbfboJMoEXfpFUGFuE0BH/wkE/0B+pW/9zVh+UKCLILBn3RRUy5bh2GNmy/
         Irg+N/EXnlP03K+S33quoFsgnqsSGuZgdfFIPhjP010XQDOgCd+elD+tiBXRmufauHiS
         8hAHvcZ+M4c6M8gttu5WRbLRjFgtrBZxSbo3jXpkrBlRRsYwnExC1yf4Bpnsz/LkpTLN
         l8w4RSVGJwQyDVqVZ9TNC0lKXQ4eJtNMKWPAg2ydBWkk6SPPb1kBoMLI2F995lfAApne
         tVRQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JcJzD0I+OubTDjiy3ro37g6tfJh2jVJ7hc34nFM1klGaV1ne/YmgSKaQPDeufvo4XMFOxvk+ARg==@kvack.org
X-Gm-Message-State: AOJu0YzrHUML7nVQxtP1fUF/LMzw5BxUOA4R3bTb0KO7vc1iB9z3acER
	rSoWOMNLLrIKgVg3sRf8rAPviaplvFhvDyEwbm1WQLUgve94VXV0G6C5ENjsIjNjFcYh99W5MPh
	mFeqbjpYMEegEYmk1vn3dIa27YZvCVbOYmceAVJVynDj4nwhGOO3y
X-Gm-Gg: AeBDies738Ez4YElL+trGtIcioxncILksIpiL5V4VFKZOwz34kBWW4jhE5HXcIKuGgL
	XSTHNqwA4tlgdJu32J4EKUac85sl6iiiN4R9QBOGiZsG3XVZAveY715I56k3nKh2cCixNQGxUO+
	z/GHOO6hPCwl4GL9x1pP0cRebHL1UYr/JRlU6nk0BLaaR324hBuagWNC+GyXUibzC7na+dRTHMx
	j012PIXQzHbhO2A+29hsrWU+hN7d40jKLYV06sh6rCX+0mGGFOXEkWDw0B0nmA3OTNtDpDCulE6
	23O/T15CID9a+suU8rtekWQRA3ZD4fCBdQz8E1cOJHJvObJVdY5kHdoTYRvt+E61F5U2zn+wAdK
	6J7D30J2PpCAEgFiIBiLV1e6BA4P4kLqnP7plXApQ
X-Received: by 2002:a05:600c:a111:b0:471:700:f281 with SMTP id 5b1f17b1804b1-48e51f46e24mr127891605e9.25.1778192557770;
        Thu, 07 May 2026 15:22:37 -0700 (PDT)
X-Received: by 2002:a05:600c:a111:b0:471:700:f281 with SMTP id 5b1f17b1804b1-48e51f46e24mr127891365e9.25.1778192557283;
        Thu, 07 May 2026 15:22:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45416b5e3fesm1973208f8f.19.2026.05.07.15.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:36 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: [PATCH v5 03/28] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <ee3ce9c4ded3f90a924b9688d49daf2e24a3de83.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7EOo6xcMd-JzRy4eVEN-eSw0CzLFyz1gIvD3fQHD844_1778192558
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B9C540007
X-Stat-Signature: 3mfdi5ds9k3cyuby17cg5qufzicdjonr
X-HE-Tag: 1778192561-641776
X-HE-Meta: U2FsdGVkX1+MGGh8zMEyuRwOcuQ8YniuiZCMh1mTFLZI5p7KmAzYF4wY1E3mxaC9Zoyt6NLIEjRC2SZ2nzToOl5ds67jGvYKylmqgI8WqZFvpPvXJUvQqUWc+91typ4uqE+07/K66GQZiMS+fRTfeTxEiNzF7YRNYTTUGH2vqvycgD+k30I33IkdKXfXs7exbX2uYiDtXs+K80yGEtrgFRxZDJ4dpUVIOJXBL0dcoXbGs+Xqre49yQNr61VtNbi4B66n5qqHiGddq0xaynzcMPOjEAEHPNm/evrszKRTPMHKZTBfQlpYr6qzM8x0gZe10izoz/H/2Yz/NzjwEaAUHO5dRdVC/rtgxvCu7HnbQgfXHzoqE7eJRM/fQawNU2DoFGr7+h2TmN3grPgIplj4raVoj7nU6zE9HrIksrRF79IqYu55yYiwwmMLEkzEsvAOVYAxbQQzeJSMd0KY54INwQyFF/rUsPW5maNt9qsFZFt7Z6bM/sKKPbB9VaotL/CQYKN3p/DJb3vqDfEbJEQTST2cYvpY3LcBrG/Q/Y8nVYAYGW1nZy1WC4uCyjxLJoKBTkJNsgIrJ+0KY8mdClIwAqAYh7B9d8/nUWflWouDPEYhMsRVNNJfMpne4VCLPh55cy4lvoivBGKWUp62fhI/Yb4D5otmYYsdtiYHmkEd/PiKBlWQpxlKfWa8+AK6QBFWOosauWLESqQIM4DU/HpWuppdxe4C3tghigi+8XBtPQeSJBd2ZDUanOLarONC919A/Pwzw3guVonN8bb8C8ZK4iAKEpk7kq+CxbkRCapMb3k/588lepXbAQ7hWrKqQ5pvBqANPsYn295fFUPlYcUcq3nMZlXpumWOcvciL9b2wrGe7rTO9Z3XDQzuPkfedIlnSsdVbg5zUpbvnT8CDoGkNgPmXNNoYoY59scvcF4xLm4I7tdgT2tzsYKcNsKp3brWsHMFqpjV42AvFm7VOJ4
 AG2HPblW
 M3nrGaJN2uLKQxyXc9Ewv+9iPJmnxny3JS7ED93mxowzvMwZljGViRCdFNHzBU4BTny8fMrw1TCim/3O16fYnWk1kCZ7TPzMHxDvny7gaGlARNDhiU55riukd3XLTvW1jZRS+LKBcDVm3ZG58tRzSR+bHOVhf3Kg71dA5PtstLcsjSnHa9QPw30cF1MFcN+k4+xK9jNymQnj+D4qEcg2UU/QaRiDUcVu2KmiBH+KTg2sMJ/DkrlDs5UtqNRtQt2SItwsaBe4AWNCk4N0mt1IapLe2D57fVkHuiNONyzlEZXTWTmS/As3oiEgwZy4fqBQ09NeVXUkHCe3rvMU3zUpTtSYYAAJqTyq9a83CbeVFbflQeaJlW0Gv9XQA8wR6VaAZUraODC0z/pxlRcG0Z+4EJ7BbQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() is defined in mm/memory.c under
CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
will call it from post_alloc_hook() for all user page zeroing, so
configs without THP or HUGETLBFS will need a stub.

Add a macro in the #else branch that falls back to
clear_user_highpages(), which handles cache aliasing correctly on
VIPT architectures and is always available via highmem.h.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.
This also matches what vma_alloc_zeroed_movable_folio currently does.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..541d36e5e420 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4718,6 +4718,9 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
 				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
 }
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+#define folio_zero_user(folio, addr_hint) \
+	clear_user_highpages(&(folio)->page, (addr_hint), folio_nr_pages(folio))
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
-- 
MST


