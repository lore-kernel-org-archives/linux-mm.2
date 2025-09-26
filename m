Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2D9CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255C48E0010; Fri, 26 Sep 2025 05:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205CC8E0001; Fri, 26 Sep 2025 05:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4CD8E0010; Fri, 26 Sep 2025 05:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFF3C8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBEAE11A208
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:43 +0000 (UTC)
X-FDA: 83930891646.15.DF659D5
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC4E72000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZbKk+vS;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcUAVjuBCwqD/o526Djm1QGIR4OCMDMMqLBu73ohlCo=;
	b=PmOGcosM2l6Bg8mg52sDfEquVTGKjkSQAQrBR0YNh6M1Dd17mI17S2L9iqYDVlxXDQGvTZ
	b24OHrwnbWTFP28PM2crBl9Ceg0ucLedtlp77E5HMhlBgRfPldf7j5Pww9kP3Y5+xz6I38
	7asA0UmoeT6XQsBpZndJJ03ZqkptU3s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZbKk+vS;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879281; a=rsa-sha256;
	cv=none;
	b=RXcUYXls98V1qyFQLEvbw0EETnkECQlvaiXTtYWrnRoBMOvHhcFD6QCyXinT/bx71J14xd
	38yqab4tlKxlceupZxBvqER5bCmpKzU2SaVSlWP+gFEHpdbNPOxMAUMb0SbnFR0S/OcNlw
	9mG5omAlCJJvGXgv2yQcdj+Jhz92aYE=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27eec33b737so9618035ad.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879281; x=1759484081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcUAVjuBCwqD/o526Djm1QGIR4OCMDMMqLBu73ohlCo=;
        b=XZbKk+vStWgWrYxOPKstG6FiSEL0ipuuBP7qUWqJ8fPz/sX/OSToK4yg0xeVqihG5K
         sdQdhI5DRGUoF5rHW+kjC3EiK8A+HfUwZEC+c7KSFhbuyALdSu3FleJn7mJ4TqT8788r
         B5kfuXLIPcoJ3qfooDS0eRzNOVhMh6SY5McuW+ZzWFTaVn5F5kxkG5fUDaQqgoGlIHRD
         NrZzdoAQ3MYWVyXwD+5j9A7JfighKS/xA76S3OjVsY5Ui8Xg7bELueZpbWVXd83Osstm
         386u1ZEEDb/G4JBn2zVT5hVCDMXrUuEpn0w6Ixs1CT+jqCqVirj89AWgWq9cNeIphxld
         tvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879281; x=1759484081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcUAVjuBCwqD/o526Djm1QGIR4OCMDMMqLBu73ohlCo=;
        b=JHNxcZDhBB7Lp4I4FChqhaFg0CPQ5IBql8dCwGDzSCILocgLJGYvTLSGqT94iNW1HJ
         H7PRVvn53y76Au5iPY095cnKXtrsZeyKsciPPcfIYI+8Mr+6CSQYOVjRbXnMeOdI8zvG
         QySlIUtXs5DIwV36PU36s1ew3TSmkCfhwU1Q9jQNULGqrhC7BOKR9+85o2HOB4sJlOJf
         TH0+5E8DzdDxzfCf0Xb3lafLK4P8R9wjkm9eZCWQyoGKcEMNNChOvHfuZwWcZEn9SSac
         FBgIzGjIyBY7LJVZXzXLg6x/5UbFlV5VArwIUVyoz60O10GYjPmENk75iW8W2K4d+Cj3
         wn9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXYah+mwvGC5xUbmtUEUTJLz94Wy4Vryw04HcOVpRfJs4eUP3Zc1ZcoW+z8iJ1/tZQWXOW9EFV+vw==@kvack.org
X-Gm-Message-State: AOJu0YzuyuwXKrQgv10XCVCDb4mIlCNJwek42hJ+egb0FPInpScYrN24
	6t4LtlyLponxDAYYnJZ6JHcHCv2I4VMBrTbbzQd9F3Laohr8RmpYlFK3
X-Gm-Gg: ASbGncvOB4+8Zy6iJnJ+zk35oEyTopGDhv/Jm7ga6hLAZVnM11wPtgH+4VE60hN9yDW
	RaXUhB/1ceQ0D0yu4ndEcSZXZAj5R11ZDZIFLcOFI3tS1R5psULS/GkNRH2mAtnTLoamFO6yv9R
	G5DVTAFYUrj9b6IMjphDPWgFdenbqNDYoZUVielgHUt4BUBJFUpVY9navPibuilKNgfaT3/KoF0
	nWsM/m/y/PUxGNa3l3K0gQv+zVxr1rd2II3V2ZdXT/Z4xLE+KmFixcpoydB19tecrd9nE5Hdn00
	A8kIx5YOYKHxvFKJE58PwRq0XZjjBYFv5VWtt+upc8wdg9/zzAgoBkivvIsX1wlypIrenUdjamh
	8kw49fCBtF4ICHYknRaMHVGgdQTB6RnbMksyLwvbIRPq1z5baMO0NU8CkqaD56hgAvQqr5Jn0zK
	Zv3ztsxitPhtfn
X-Google-Smtp-Source: AGHT+IHpTOJHleE7ACdFvjLA52er0X3g6rm9mXYHGB20zbDxAkuQgTkRYnpRqU5bnQ67XgLmD1Xa5Q==
X-Received: by 2002:a17:903:19e6:b0:266:f01a:98c4 with SMTP id d9443c01a7336-27ed49dece8mr69854105ad.13.1758879280625;
        Fri, 26 Sep 2025 02:34:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:40 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 06/12] mm: thp: enable THP allocation exclusively through khugepaged
Date: Fri, 26 Sep 2025 17:33:37 +0800
Message-Id: <20250926093343.1000-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pchaw6mofuqkoszu51s3uymy1i8iqg4m
X-Rspam-User: 
X-Rspamd-Queue-Id: DC4E72000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758879281-107349
X-HE-Meta: U2FsdGVkX19NI1LQ6gDYl1WC4FvpkrTIYkYiUjT3vA06Vs+8gw/XE54jFnW8rTfvt3Stg91Hmlsc/JTlTBG4x5MK7zQ6RxMvWneWefsbXttSwFXU41/zIkfKWzoiiDqg4S6GCzY2dRl0hf/kfeZF/8g+lyfCBRjcPMGzOaqvZHXKTrqengUU+YsqJE9t6EGZoGFsIrPqDhGWGlKziHrTRyozWfT95kZ0CosSLKAB2J1dGg4ZPUH45Qksoe/4OylkridQya9NwAJZ8KpMo1GX7Wgsr/sqoEN6tp2ltlWMiO26ltOYaTicO/rernihPp7U0whYjOawsdjsvrdwEK+OFo4w4kt2lyjiuU+U9tUQ6ekuiYo+6wmV0AGueWRf/RPwbtHCGJqUp36lHzkwWzTzmoZoEEgxHukHaaVvJeaaQWGi4X8guRRmO4IT3soOwnRCEfCsOm88KLEn6DEHFff2DFggI5RmolXCDZHaYTzVlvW2t5i617HbmOvYE9o5RV5fNvBuec//mbM8WwSGvtJubM+KqkTVla9/+ff5+b7I/1Qul2YDjJaCeCkG58I6z7hFVqakAicez7VrSGdkiiqVD7Bv2GZB0jhD94l763qxGb1EoHnLU9soQP7Md73gMiW2dTG6j3xw4+6XH+OtTW9MAoE6RhR/ZL34iSA/dwijfDc8X4ujzE9SqZNdPA7LeqsgOqO6JbyH1UhHnm+/fyRARqq2rDXSBxOh6JJeCpeRllS5A/JKaP1FAeClQduJwGgDWIf7NGHcchTho8o5vqwczUR2GKpqF/7nuM07xwQ4bkBNI3gIvnAZCuyQtQhK+aXQrLElaODa9Mt69ShO/XATdxhGts9UmM/c2rrJVzbe6hX6YoZ14pEpLRbvnEFkevQwfbjX5iPVNZnD2i49QDafaVC0OX1ICB+mWz0tq0/WvXKbQlK4FoNNY96nYzcxCxJzDA30ShzUQymMMudOEsT
 g5m+WM1d
 rATZcsO+UFSuTPVM+Nsq1XfP5VGLcNoY8fD6y73/INOojsQcvXASyIIjCVaI19/x1jBlEA8mVQOLoJtyV2Z/JkPi7at6NHzcQ8EM2P5QbF0w6163QMSfEXW1mysSmL386XPij9VgmSheQEv2aUIqdqwUzsw3+L2LtzzDxNuIeIB59QeSmkF8GHNryH9E1I71JmtI6VVM8MrhDpaB/DXy5BdwT/tKUf+ZQdakoKjcx06iFzSie3mXalHOoFFZ34h4qhAs20fEXXMFlZdnhMn11KnpAFzqC4w4a4i+YSNK3GNDTujk8lk62rGIxTnNCOhcRz8tJEh18mHtmae8Xov8gNlWaUhLFqIbc7NCEvuPNdwRX23R4q+oQAEuyCLi622o8hcgVEDJlV3P0lvzAbUJ2JN7Wkha2m7vamF8Y/CRMkJuOaP/T8o9qvPDVNoZod0XdUEMWKRkqr494/LWowyW1nhYI7Dr3onrduQSKTHj2U4WExro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged_enter_vma() ultimately invokes any attached BPF function with
the TVA_KHUGEPAGED flag set when determining whether or not to enable
khugepaged THP for a freshly faulted in VMA.

Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
invoked by create_huge_pmd() and only when we have already checked to
see if an allowable TVA_PAGEFAULT order is specified.

Since we might want to disallow THP on fault-in but allow it via
khugepaged, we move things around so we always attempt to enter
khugepaged upon fault.

This change is safe because:
- the checks for thp_vma_allowable_order(TVA_KHUGEPAGED) and
  thp_vma_allowable_order(TVA_PAGEFAULT) are functionally equivalent
- khugepaged operates at the MM level rather than per-VMA. The THP
  allocation might fail during page faults due to transient conditions
  (e.g., memory pressure), it is safe to add this MM to khugepaged for
  subsequent defragmentation.

While we could also extend prctl() to utilize this new policy, such a
change would require a uAPI modification to PR_SET_THP_DISABLE.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 08372dfcb41a..2b155a734c78 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index 58ea0f93f79e..64f91191ffff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6327,11 +6327,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
-		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (pmd_none(*vmf.pmd)) {
+		if (vma_is_anonymous(vma))
+			khugepaged_enter_vma(vma);
+		if (thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
+			ret = create_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	} else {
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-- 
2.47.3


