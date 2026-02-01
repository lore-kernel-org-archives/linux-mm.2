Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFBEE7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49F96B0092; Sun,  1 Feb 2026 07:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECB46B0093; Sun,  1 Feb 2026 07:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E4E6B0095; Sun,  1 Feb 2026 07:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B94AA6B0092
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:26:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55E501602C5
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:59 +0000 (UTC)
X-FDA: 84395812158.10.37E6D4B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 83BEB4000A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TGtUm/hH";
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1KIjvX7rp1rAqsSo7NpZu+Xr3OmRRK8GikF7hwaL00=;
	b=eMhnuz30WCNAjKqIVGyPKMrp3CFRNHT1Z6tcnM3ECvDWK4BopM40CSIKyV7LPIswq2UBRZ
	oGsQ5lLxKRm10VjrztzeS1xOkKCFkAHhdlrpZTAzvb1npKD7X5tWitA17LTdvTqiUu2kJL
	hXXUKkIih/x99tOig9/6gA++hgMlRLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TGtUm/hH";
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948817; a=rsa-sha256;
	cv=none;
	b=fF0BOhoW7RJxmIFN7ud9owpYAgbS0JIKOTJ9blx+SK2iT0Z5zOSGSeqoxGOOUKY4WlXKJP
	Be3+adVnWOUQBYumdf5wTg7cy47UyoIJywlCXXGV2qwAHU1iqNT4JrmuOQISmKqe2VXU/e
	KpwTRjp1b6EtQS5Kzot9IRhuVZxyZU8=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a7bced39cfso37238615ad.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948816; x=1770553616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1KIjvX7rp1rAqsSo7NpZu+Xr3OmRRK8GikF7hwaL00=;
        b=TGtUm/hH2AVQLCXQJ95vmlyXHpENMpm4sRrOmiuBXvAXioOhYRdwjHqWSnYD4wvCWQ
         581zliZXost2KSMFIcutKFCZbXku9bSUbji9UuIGtckFv/GOsrANuvRKrdQwWlybY3I3
         fjzNxWZP3ha+YfoqTWiO2EG+GunD3LGT2f3gSKHXMotg7FeJOKRDA1XeJGLipDZO9cxJ
         a19TwvLjrXM9pzylxofd2Rt6TI7Ju+4j6ZA8WuP0Upq55kZW+95zMgW/E8nH+p8wWVqk
         X2WR+ja4N/NLtxbbPCZ4gyu2mK8voZIIw62AOGH29jsHSywvKkRcGMcR/J4X65j7awi1
         8+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948816; x=1770553616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g1KIjvX7rp1rAqsSo7NpZu+Xr3OmRRK8GikF7hwaL00=;
        b=RbHUA9YqLawnUipxYpGiMAwLnx2Ulze6wlstUidePyKx9xPJ+hiLshajaJHKiJjgpx
         V3712sSnvOVi0Ndh24a0SO69HWGkWjJVRWwlgdmvpUe7a96kw2Bb2FuSlnzieZF/rXWM
         sO+GQPKRbHt09b9OVaKig7HSxMNURqTwzTcgCiLBaM96SlEWCKb/BXyW9y1KF+UdQj3l
         pKbg1A9FM227GrAAo7lzOp2qO/eJ8vBtKJt55n2/pp+6cAtLbXVJkC56dQ1/pSskpo7P
         PjFNUHzktyZL9OLfgfgglfjERZPznIzsndnGNLU/NhsTWQJmg+SftEjnCbPO9MA6nduI
         qIlg==
X-Forwarded-Encrypted: i=1; AJvYcCUOBPjpwesnJbYz8ZkJ3BOcxeyegHMGCp+IXU45OyRVfPs4BnrNlaEcfj6AT40vnGYL0Z9YrHopKw==@kvack.org
X-Gm-Message-State: AOJu0YwkfQDMJIaHRBsGjeE3q4nxQsaOIEV/WE7HAXDls4PDZinDT12J
	5705jwXkBhANN6YxEkbaJS7Q8q95bbUHOgCcjD1TyVmJ+5HBw+AI7n/F
X-Gm-Gg: AZuq6aK6mGek9f8rLocDxhg99JXj8e/+ElAP/MJxb5Xc26Mc3aJc3kM1LyGF2EmwSP8
	Y0JHgl+pJN6giXcGlAKR65Zjdm5Xz6P4f19uC0Qg+RHucU3k7ZR8RwAiVFR5YXiEBJxzeH+SBGs
	16MDA770wo3bjjdgjCIxQFK2AXnN/LQDlMXM31y7sPPfIPviaWbcrNs9aR8uuZ0ggYFxVgCDHJm
	BOjCX1xBpo/cCyHJSkqtJc4vIToXK6IIZWgUZlNay8uq8kZixgsaLtWanXOjxRgqPc0x7kGWadC
	tu9cSZg9k2WmdMZrMJDiOIkkgXNOgbUo+pvW7NC6mAQhMUP0QytCsctjUxU0uODnngTh/QhzJRw
	b47VyqPfnaVsdJqsyUTPVKMF+VvgAC8lhD9pEVgC+M3JuKSO7KZBWX5ngJSFxAtITwuyC7H94Ix
	C+Ftltl/0EDPPfeCGpgDVvKSRp
X-Received: by 2002:a17:903:1b10:b0:2a0:b02b:210c with SMTP id d9443c01a7336-2a8d96a6e47mr88899225ad.1.1769948816454;
        Sun, 01 Feb 2026 04:26:56 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:56 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v6 4/5] mm: khugepaged: skip lazy-free folios
Date: Sun,  1 Feb 2026 20:25:53 +0800
Message-ID: <20260201122554.1470071-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260201122554.1470071-1-vernon2gm@gmail.com>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jkzaebqzf6btdpw4akwehj7hg31jwmnb
X-Rspamd-Queue-Id: 83BEB4000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769948817-412465
X-HE-Meta: U2FsdGVkX18BjEQ/tRB468SVx/lLNUbfM9mb9TO8I8ZbanGRtYb1VzEC6k2eyWGWBsLz4DNNG9HdUXAnKYpJM1LRLw2nNCIUyIF92pr1EBlLoKcEP7skJIQ3z/ppUPPVLandNP38YN32HDiXTQWZTT0jTLivgoJNksvi+Cmn47RkujWk8BWcgSguppYPwnW2BV4sCgBLZnHwM5jks/lSbFpwvljjpjw48yUK+3sHvQNSnta2nwVG4RzEbkk78SV54wr1xoenG7c0yoZK2D1s/rX+W4JoGi4WeS3yJnrLVl9mKwPCBicq+SFHt079FTuB1kR3KdkPs/QdDnl7Y3do3TDMbOEK7ddkNGwVEITamJggJvUoJ8qXH4knDooicToPzcVxs4ADPHlUKjQZ1F9clHh6D3ONav1xcu0K/vOx4EjWu3ql1irD7/zZ8eMVgQjePGv8sAdxeI+/hlSxSG4kJ2nbbUitBVnIozcKUTqwJmNK3tWvDoLvA0nf32cXYVzIurPtkupMurW6HdH0dwniabiT0FvcWZnG/lB5XgKuiZ7olV/wtFGyGmsZa9FoOSO5CwvQbj4iIKHDlqUwNSfuuNVypg3MApD9skttiAkz2DlN3ztgoCqvFqMXXlwm64pwLJJn1b71pAxx3QJ5ozK3bxG8Ovrfj/hDdWKNuz5ize+P4xfEAeG6/QQD/DxM+fNFfLrRNKGCqS9NzVq2f4ABGekgfQS6DHAXaH8IFj0DK8EKWClLVo1sRVVisju/qMLxbeypnhnPLU9dsojWDBK3KY7i4onlKlp2fHoEyec//9fDLSHGcUZPO1R+vAl4cQktdTrQV7NvHDKzZ4JZdEmNn/D7kvZsAEzuI0axzsCG1RMoj9Xr/hjB9kHI7Vy/LzFNSaraXp+w0f28XlUz3mu0KlDvdjWPHJOSkNfM4r/AfLntTWGURdnax+KHaJXgWbJwLIHW+AenMgQYpU0xxVM
 gbXv9mXx
 FnKKFZSHZruhk4Fy6N2+W76aR1EfczjM/QXWm+SApjhPjXn0d/MQRVyrAC2auQw8LHSerL/UfGRR0JVtogQ1+0iTE9AYuLCmY3AVnmu8pTB37Qf1rx4FlQh8z12tAUvUjghpEv9ErCoXQ67yS2I+ZFHW8GS4XianTiPZaH6agpdHk2lw22FzHVAGNCo+P1USnRzhDBv1y6Xb9Ua8M+iEGfywmHpCjQGosCRdnP+QMpaGhVPRGM+bhd5IuNxwt0JXoXVZ3tZqHWLu4bBNeU+rewhT8YrEpONU6GibT9W2sPzRGYrZ27UiAyHppBFJ9IaANWUALpBVyYqfAgVXbQNuBeef0JFMPtT1ep6SSlKzU9rUaYHbfr3oZfp1rfbbyrM/mFfabky7btlLee7xCOlsqBA5DS1Md0nXH9UPNPfGGVrC7/+S0IFpXl0ydUptvrNt4DaOyO/7Kw19nbKuYIAuMximjHZ3nDGNd8tN0VFpVpwNaSzDWWO7ZVEWWCugVRVthdNlytJjZ1pOOUmHZ/KgI2Jbrr5TKcWrIH3E3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

And if we collapse with a lazyfree page, that content will never be none
and the deferred shrinker cannot reclaim them.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, it is appropriate for khugepaged to skip it only, thereby
avoiding unnecessary scan and collapse operations to reducing CPU
wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  1 +
 mm/khugepaged.c                    | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 384e29f6bef0..bcdc57eea270 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index df22b2274d92..b4def001ccd0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+				folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out;
+		}
+
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
@@ -1332,6 +1339,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+				folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


