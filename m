Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D484FCE086
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A276B00AA; Thu, 26 Feb 2026 09:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634B06B00AB; Thu, 26 Feb 2026 09:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537686B00AC; Thu, 26 Feb 2026 09:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7DE6B00AA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:15:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6946B6D8A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:15:51 +0000 (UTC)
X-FDA: 84486806502.21.67B068C
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1172F1A0016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:15:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=nrLO7Tez;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115350; a=rsa-sha256;
	cv=none;
	b=FTijZRTbryyAYbyrX3RaqiZ2m7giNoFkci1wsvJfAo5MdbfAwq4cDpF99ExiG8+YWxtvuH
	KSWYruDNUD9hQBPf2gtc6kuFvCG53IYd02kA93JAZPL28fpfMTE2nZq2ITW3gqm1+9mRSC
	jeR9Y16/F0HRBdXG+OIlk/4GCOLKE8A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=nrLO7Tez;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9s+UpFhge3zc0ML4d1eIWQzLbCji6+36HhEypvv/XJA=;
	b=oGLgd8kdCSLojTqLU1bZeMWyUpuDH6wuFvgKLx+q+mXD13FjyXR5J+LZXOtluQdFANKl1y
	tsGrYlrQJLeDOjhXpCL/ObXN/dm8M60aTlSQJZWPHC6syVZFNoXUSGkNsSlj3LvYpeoyza
	y3URVrkuS0/tbM2bCXBiFJDGwPlCb78=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8272c559597so897189b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772115349; x=1772720149; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9s+UpFhge3zc0ML4d1eIWQzLbCji6+36HhEypvv/XJA=;
        b=nrLO7TezYAZKgi1ix3gFXZ+gw63kJChuOLZeuVk0J6EoZTqFNzzSae2BwKcjvUV/rm
         9xodToA2VS/HeVHwUeklnNwKnzCsdLs9cAVmlpMt+fRTEbWT50sUdbmGyxMst3XtajVu
         8ZPFWohCseYrnBlWnK2YfX4Aq4AibOA8YKCds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772115349; x=1772720149;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9s+UpFhge3zc0ML4d1eIWQzLbCji6+36HhEypvv/XJA=;
        b=Ap2LKAoPdzrL6xfM4iRJgzLevciNNb7kbly3lhXyFKIbdznDzsoSCHyCsDjOw2755X
         raulGgWU2vah/7MCDU7JdRivOW0ChLc/YHyFPyGBMQ1ZVIpBJNfd79uiB3zXIb4Ia0KQ
         vCDSbW7TmSFgEIUBcK+eZ58WCJTvycxGX9QlRo6+jFwecOfeVFYlFa1vehc11Erci/nF
         Tr9zOwhOOUnbtXHNOCyrHrnDZxnCm1Tf5bJuK40hWABCDWP/HQUtQOwUwHlERdUYoZog
         Mt6hpH6JW0JDNbNtrZz1uvxbFPoCcq/d8NBeOFtl8mxGSkGfDv2Gy4q57A0KExzWjEpY
         +EZw==
X-Forwarded-Encrypted: i=1; AJvYcCXnhWsxBoDYiuG+xBVdOx63BH3PZyd7ntea2iUY1ych/J7jwmr0N5ZpwEvD0e3UKVAw2Gk6e49fGA==@kvack.org
X-Gm-Message-State: AOJu0Yz7or0F4Cz7kavQcjaQe/J8Q94xCTxrvd3jCQtcB7lDXDPkUhTZ
	IiGtGKRUCDzdcvfVZf1Jxqxzd9SbVxKFSQA3haccj9xWuqmznVv6nLwxPUhSww6IeSTydV/T4yW
	72n2+rnJh6MYJ
X-Gm-Gg: ATEYQzwUsKQSemYHzsHhoMTzJ1G5FXBuhZ3BGGOEnLuKD12wld+U1gFlj/is3BaZqJY
	+qmzBfJDZFtwUHEnkgiBsF05pLym4+Jt4xWkefkVldA3IwZww46ZCMF5qofrEVmXR6RWdRVg4LS
	KcppUKNq4HrpUlY+ABlQ6dzZGNnA/AP5iZy6BMZnLCLtCfouzhQuSzzuSU6tpk4mJ7RggzJKWoz
	9L6qok1Dr6xHB1fMNYqmznrQcscMjJw2jsAdqGYqDGSiKreKax5m0vpL4Jd5Lm216VabhKzoT+D
	bs7HICtFkrv8OUu9pSnHNwIoYaqfI77lD/74cdANkxgOt3lfhQwA1c+FoFx32fKUjSEYBnv0e3E
	1ix/T4rqQy5Y3rZijoUt6ykOB9/JdKJOttsjzqMO60D5yT/jYxhAzLfBUjhqCUJZ3EESRBhg+rr
	27EwyjkNtPj4bHYTV5lA==
X-Received: by 2002:a05:6a20:9395:b0:394:58eb:48fa with SMTP id adf61e73a8af0-395b47aa1b8mr2354656637.6.1772115348571;
        Thu, 26 Feb 2026 06:15:48 -0800 (PST)
Received: from localhost ([154.47.23.70])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa82cf64sm2301093a12.25.2026.02.26.06.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:15:48 -0800 (PST)
Date: Thu, 26 Feb 2026 22:15:31 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
Message-ID: <aaBVg6nPQz-WvyzT@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1172F1A0016
X-Stat-Signature: q597cwsfi738xjnuxq7qcih8kjo46myc
X-HE-Tag: 1772115349-311298
X-HE-Meta: U2FsdGVkX1/mrJSH/Y/hh4AJ4c0pSc3dpSfVAzVIVjN11ztVwHeatiNLkAQsEVrsDr/aAcpU3LyoOjvYiDInG0wNfCrx5ujyZINHYv8NX4KF/caIzLa4DqGuBDXwuUAxbUEEIr5kkGYXU4EXOqrNzCVxIc4iTMprXPOkRb0te/7Po1eLUa72CNj9SnCgbO5ACEzHWloESiboXoVZfikj0cIvkKV6A4jjwsrICh/1/igpDbBr0Q3TtbHPYNMfie2UJugsVkLQpmnW6xUzIijYcSImvfQHB/UE953utsRZ8YIi4rsKY752UICXrlWqr3oCvNI+Q6ePC7t2ZCvHg0mdM1u+JhLm0Y1aw7I5/g5rqsObCvNPyiXIojGqzIBcD7aD3ml8AjRJy97oo3hW2NBQG2hwvDDDL8EQkd6x4BAPkS0xwHtlT/IiwAoyVJFRBPphUAPECsdUvdvQQYEEd/SmkYGSW/2O/p1h0+XbqNVLuo2fgg/GTNs1xJH+Qzv7WzTPGmETTytRF/4gjXHh2eCDUL32WEqzI4p+iOe80TwLghjlocY/DoqUxyR0euUNxqYHZ9fPiAmjHIJoL+uqRFBV7rWXC7InuE5Zq+A9IbBD+maco4+3rWgdNKTEY3CiME7p8tQzvs0/PeWkbqGy5Y+qbjGEyM7Z4QMA7FJqjhoZ+lxO2DYeyH0c8MRxKQc7YZPAi6NJ7LPlahoiM8YupRmpbHOqtRy2yw8FxbGEJUabfvcoVqv7XoNy3NjMgky7KBNC2Y9JeGuMdHGntS7JyPC1OdKeSS/aHvaA4UAC8rxwl5HvxIKIkK5qnKxgAx5pXPjJDVtVc+8uYdzibXnMPXugS2uKfTWvKj543APiMWMJo6UNRAwTcnzpF4jlKX6hpuOIUp58+s8XW03OoTMCPimtxGSp7LAusHXaTvuZ7of3cZ13mKz+WxmQXyCZsq5KIV7tBLWYQNKWjrl+gpUnfc4
 OOy32gWB
 2K+vKeBoJdWyRmjQ23CDqap7hgNgJ01xCjWrAgAJqfQTeX9R2sD8PmrfPcYFPdAP1cUDur3IfP5KPVVW5nXEBdgMjBUId0HTXVoOQWcK0fv5Qz2ge38UoLGo7n3Fbry2FpocDPPehzmMBKZFDpqLGjkmOHeAip2KCIaTQRcxoV7125hG173nSwraCsO7JRuSZUSTP9MmzTNp8ejZNWrmesi6jhvjBh53kqsCrQFxrqX6lcYQOGFYJdLb+kvnlbO+eH8yRk18UsYl/7T42+YiZpmuL6/6GwmXANErR384Qr/lbNylBA1gwHMEHZlgLBC72P7BhXwhocJVgq/KXOfGblsC6ZNSskpRN4fCZVT8O+Hc/JmXajtgN1f1DFBbxa8ca+0SHoaRpo91WiwbsFuDLGLxMDo55qk1DHXxOTaCtT8JxbdIlWQz0l8C13S6HinLcsCKJjXCGySzgwxrNdBHOgDk2xrKmjr3CQQrYgGvDbE0F69m1Cg0NUnYT5qgeu/jatQ5yvg87nlp5+XqOtpRKVGfoXuzVQcg8MHHd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
zero pages. For the huge zero page path, src_folio is explicitly set to
NULL, and is used as a sentinel to skip folio operations like lock and
rmap.

In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
pointing to non-existent physical memory. On other memory models it is a
NULL dereference.

Use page_folio(src_page) to obtain the valid huge zero folio from the
page, which was obtained from pmd_page() and remains valid throughout.

Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd..fed57951a7cd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
-- 
2.51.2


