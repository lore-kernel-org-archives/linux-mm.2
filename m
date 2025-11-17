Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41597CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8DD8E002E; Mon, 17 Nov 2025 12:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688C48E0002; Mon, 17 Nov 2025 12:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F108E002E; Mon, 17 Nov 2025 12:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 433D58E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:37:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE28156E57
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:35 +0000 (UTC)
X-FDA: 84120806070.10.F71449E
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 155C814000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQmyXWe0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401054; a=rsa-sha256;
	cv=none;
	b=tSsi5KYy/RBR9/iNg4iLcZRzp9o4mOmAltUQKqGm3igTN1YpKx199qkSJN6Na61wMNdNHB
	cLjfDutJlts7VzRzumXEl9RhBHOiLx48FfHoiR6cpercCKTHbXkwZmexG/T36mNpfI+ROb
	SbeZNnQSMuEMcENOKqwu2gvmPLSefWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQmyXWe0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPcO45dHFDvBr1myur2O5RaxoSFdLaXlPhz3NmNfzjQ=;
	b=hHL2Ieqsmm09xZZ+E+vsV7Q8PYfOj/bHJLhtOl8q7DHPU6pPNP5ex0HLglsJruPJ4l+Alu
	t50SfEtElCc1EV0dszzW0MiHjXOX4XY/zCueLZJFiZOnZ4Slz54BZABBa3jtLBDnqHdVSB
	HoN76egBjXjGU6djNw8X/MR5AKiBDBY=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so4397742b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401053; x=1764005853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPcO45dHFDvBr1myur2O5RaxoSFdLaXlPhz3NmNfzjQ=;
        b=HQmyXWe027C6EabCzJbKvt8OCkjUbeC4y1jM4+YvHhreo+A/vyjhmSCbln/BWE/7KE
         cO/hqAMExLtbtnVWGJ2O/yOwuVpViX5s35ILr3ZHdVZiCausDORk31RPNPSRtotJNQ3p
         rwbySwMWQT8DVTH1lQ91e3Jz/is7QPzuETMTZ2JMY4HjsyxX+4fsRgIoNocCy4D35I37
         Y+R+pXQYbmnMMKCeDPZ/UVVsNVO1i/b5F9ko1KvBICOqn6WKLH2faiesNSAHAPkRPmoo
         w8wtqcvbgevmn1rjneRnvxIVo7KOBwQWYujR4REILM04A9qnMcmFeoNLsy9GdWjFICID
         L0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401053; x=1764005853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IPcO45dHFDvBr1myur2O5RaxoSFdLaXlPhz3NmNfzjQ=;
        b=ZdIjIY2x8EUTJDoMKeUPrHJYNCf5EhMlA9ZhEcGJIW06/sitVF2EFPq0AXYR8blbMy
         QVIKgQeVhvPmF0Qp0q1dKRIN7Nksy7IYVOtsoc3IuNJje+gYyqIKsfuWfzo8LrLTD+Om
         JBjL0pUh57O66iwbUTP0WfO0C31TkFfRaWPMTigONb4E0tt61sghHyWLnb6RvjPY/7BL
         VaxQNQi7bT8omKR2o9YdfrtFRr9XS+mzFrcEoEfgS7YnFs3pw6TaVWMApZx0tCP6p9bi
         /Mu3mMNEhT3pmxQ8x0M/i6c8Dwubj3/zpn5z6QmsD3qPFa6p3nh6DjZDqxcYogJbOXZ5
         0P5A==
X-Forwarded-Encrypted: i=1; AJvYcCWvGLpUv/b1E+sfO4vbOzLMzjEeZsOJa23nDYQwJBqT4Df7XhNSTGTJKx6XtU88IBCedFo2sLSOYA==@kvack.org
X-Gm-Message-State: AOJu0YwuuNblteaJuKNw8NNqB9T0PNqgRe4RgXY89Iat/fzMFNvIT0J+
	n3ILZMh/nPlNpbBAchEdDQUM6li2cylPZ6VXkqnsjiQGCqvf4rOhTfWg
X-Gm-Gg: ASbGncvXCURB1Xko0RY8jnNnMwN7XqjBVC2ejy6BJnbsLYwJ3MfrQ8/4Xn4Prnj4m0C
	0AV8W1UHkiTM6i3ciuF5DKg6TeoPmUnwD1XSxudYCYpg07pVDaFLO91yJEo15zwoAH+POvdHO/e
	Myr3GvUXNG7ZJce+CoSzscgJmewInmpaQUOfluCD7J+0zXWdyWtY67FgtGmR3FfsREzGtasNHbR
	EgzJSYxJg0+edLM7LFrmSrEMwIlvOsdc14jhkhViOlP2vlapogHDU/GiJDS03G8ClwOYKpJgNuG
	m+cElOc5AN7GUYfMOiESez/cf+uGnu0PppkLEs2I3mX6ytE622/BxzeTekmP0iBvC3VkbHlkKBV
	kbF6duR3If+mpF52Bgl6RDtAZzVgieSR/uKce6DK2PvI/X+06XYYppPDA2wzEv9KMJhLU4WCllg
	AVtxdSya7SlLnuQlCGeTVLN1QvoozT7yXerMP7NBKnKOo=
X-Google-Smtp-Source: AGHT+IH4K/uKp4wBmji5+078HBHMRacMom3qXOxhrv9ZqIKosCXUetWMfsZ4zZ1443wE5zlGVPEjIA==
X-Received: by 2002:a05:7022:69a5:b0:119:e56b:957c with SMTP id a92af1059eb24-11b40e7bfdemr5600667c88.1.1763401052835;
        Mon, 17 Nov 2025 09:37:32 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11bf23d6967sm17190077c88.3.2025.11.17.09.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:37:29 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Mon, 17 Nov 2025 09:35:28 -0800
Message-ID: <20251117173530.43293-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251117173530.43293-1-vishal.moola@gmail.com>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 155C814000D
X-Stat-Signature: cwapsc86fa1gmux5ihj4yoxh59baye3q
X-Rspam-User: 
X-HE-Tag: 1763401053-428864
X-HE-Meta: U2FsdGVkX1+Mu35BchQl0XfVLyMCnHSFQImAsG6a/LUUeKiQ07kapiflh/1lYQ7rQt9wtgtUW13K9IbmVmsdvr0+lzZxEzgIW/9e1fMlPNAxpw/2T/mbrYf8PBixaoi9i4n+D41uotml6Q38TrwbZwKHbl7E+/vCRScTs040FBIeIShfVAlYpbqZ4SkiebMoobTDtovCKfaslj+HcbGKbykOzGnmIYZuoQg0yOQCBOAf/VC99XVWaUg+CBYBMtd0XFCNLw87Q9Xy8qUxnMTFN33bqv/UL+8yc1VHjnkwF1E4w1gDS4PelIDyLtD2ngbq7NZQwNQeTOvx8vDAEAOiworbNjrRCY5yArfpXIklrWa0Z8BJIBp1QgMzElSB0dwfdir/26+SV7b9e439NOBNxEhKLqa02Rb9INrvaPY/2s+02Ozn1x9eu6+fPbk2AcwXm5evHd6RTQoZN+oUaHEZtGZ1YkRFoetSy98I2JHtpYR5TnZ2bijD2Zqzx9KZf+nFdPZ3U4E7gb5DWoam/vXBcm5JGA08mqBpY4LtV3B5sVFXVXrcOkO3lpWB3trFbYU2Gdls53PSCo1nYGI3rRdk8ZW1pNbPZsMlA1aSujyGhACOcUGnDlXMYWAki4IO7/njlx5H2/UDgsMAO4yNE6uTRJJM4uf2wsVEXdnhKpte9aQnQBKI+4tD2+lDEYhovZgemhI/cA7zebph3b6747umrQyD1lGJqqGZoA5HI80LFuOkvdlatyRtu6pFeBEzqFtdSGm+IFr+3ZXDDYqND4BE/J9F6Y0tO4gOp/MQMkdkhNeBxRtCCOLpo2eFltXV90PM3mNVCftnlVPCvIMLAaSOpZdlZgRinT/QizUGEkePP7jn5iIf39yi/cX7s+jqfOQfEYi45RTUkxU6j08QT/XqW9m/lvZRcrWXAeAkRYjD6hQJN83iRU9sTlVpSpT10/ISvQMzmMoE8qhUh2Ur+nQ
 6ISo9dSt
 3MY58CXIYjOxtRCvilrV3WZzcVatX2WFjCNsh1Jno4ly26xJciR2Va4dsWsxEH8ZeKPtt5PiOQpszyhVWtFme3DmQ4YNsh77iVlo25QQ08bJC0JdivPKlf0t9n/fiSvIwLNJQM9o3cZnlTQw40DBo+O5RB+ZNAsYMfb7hPbvDjRG8CYo8ZI3h1VVG1Ms8DkNV0GGDB0TTAukH5AUaHh+2h+t6vyT0vWFPfeb2aZ4qR9QPbfFD7G/MMK9WmnrwSzeYJIOuE/jgNNhLA6P2nKqpTVGu/worVobTOJgoTSzPE6puBCaRwABPbs86wxi4uj44uG8um3IxROHwhToKx2pcNJaFcc6zhuKuIz7TFu6kKn47g7ayBp37Qxu4dLkWlFtVwsJgKoPNVNFRHPCkIy1IgXR8Yze6Kx++ChPHPNStVrJdg/SRhwtMFntBigDZubtYqKLP2LS6G+bO8iCFdfzv2r0leGc+l9S3Ra13QHWpTCFbfze8l0qY23KIBwtrhtX8tPQ6dAFn1RPkQUYE7hM9/HsqeiJ+8hy37I60RUdclbkUvrA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5dc467c6cab4..0929f4f53ffe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


