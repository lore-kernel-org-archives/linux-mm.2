Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BE1CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 07:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09FC6B008A; Thu,  7 May 2026 03:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE22C6B008C; Thu,  7 May 2026 03:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1AF6B0092; Thu,  7 May 2026 03:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E97B6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:06:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EA601C0267
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:13 +0000 (UTC)
X-FDA: 84739739826.20.7B64667
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E760140003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QQS6GcSS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778137571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BO67I+tc6fpB9njFQMIo7PJhrH5oEFtHvkZxfrMXbW4=;
	b=6PKt+GY9sE/2RMKHzXRz+b09Yh6pE+te7VeW0F5GzBvc7fKWghgUbGjTQ63VrsFqv6p0Eb
	U3J+NcPTsBjh9xlWQIOdrkTG9kNPhIh27zK3AIOYjKW6yS20k1XpNQUKPm2oyfjjcvEnay
	NgGr3vyzI3huaIeuAGMZnM7pPCOCKAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778137571; a=rsa-sha256;
	cv=none;
	b=48S7FciR4LOBq5ZZEopApaEZimOYB9wPTQoduC20sOofZS5v2O8v2QCtsotTvlHxf3G+no
	+Eyyz9WaTyQZR/CIwZGoIRRowkuTlI+OOXnqqxv0p3LKoeyoDU0tyik6eBgpRdZ0aKCYeT
	p1ZmUJAuJKHhUxvRjkNDKtYwvnvItjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QQS6GcSS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c6e2355739dso175854a12.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 00:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778137570; x=1778742370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BO67I+tc6fpB9njFQMIo7PJhrH5oEFtHvkZxfrMXbW4=;
        b=QQS6GcSSZjr37F4ATajHcy0pliSyteH0HeIfRBF4eu0bJfnk+MWbJDtS7wtWLX5lWn
         mWYCUBx+Co8YxwV7ByaonS/QggqkmXTuJNf3gPwvTnUEGLsvwZxE9SOx8szJj5l6FY5A
         /2LTGC18wn/GzlPgaN1VNn8uaBc4NhNa7Ue/EJaIHMM+2E+CgF+BgZ4bqlD5Fb8gqh0V
         eU9cWYu3TbvwAVKgSGsp9KKzbiAJx7hB5ucZG/WUnUDrl9Rs+SSbNSepDHkEUob5HRvl
         ySsKcgq1ASQM4OJFC6Fjab/MDRIYw3kwo8jhZIEo9yzYkeAyczYo+efN0I3V3V+Zkuwc
         daNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778137570; x=1778742370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BO67I+tc6fpB9njFQMIo7PJhrH5oEFtHvkZxfrMXbW4=;
        b=YYsr3UuA9i5bQtCiWJrkjLnoqCOJfe1WIcLXAYsvkq3cORFx8aLoobif475lXyBoaq
         5fZWYTEDPLxAv0kgBDX94XHONm+1t+ETtSvb/ZJ/2Kn1bji+RI+xelCCtBJb1xuUFntN
         pGcZlIprfODpZvrYRfahyVSCvysdbV3OmpUT6A9xBgTESrgG5270p6/HJ1m9yy2cLZjw
         iVa9/gLic5k4XoYXVr2ov6j0czO/HnAY/6RmOKbiY8dRYEk62yYhKVN0faHaFIt9NbQK
         ykz57wlT3iPCEn72qE7+l+hDJoJ2VUuFfXQYEu1xEQHtCv30gMf8qOG7Jgp/2f+c7NSZ
         /YXg==
X-Forwarded-Encrypted: i=1; AFNElJ/jysjD64R3p9qDqfPziCSFeOTEKd9PnK1fAuPvEsgf57OR4fgTan7mSjnCQJzaGu0mVACN189w6A==@kvack.org
X-Gm-Message-State: AOJu0YyMr/A3Hd5kM+guWTCUTeidIjR85UntREEhk+L1dLRh+IdqGB2W
	FnYszmbadZNVay21IHaJuAdVWgDaqFUgyJKYZY+N031XJuN/MCoAT4Md
X-Gm-Gg: AeBDievZ0MA/iZe0q9/MndST8ktrqXaEtk7+r1+EkITchy7saLacVSnX9D2r+GwRQdR
	5rIh1DOqF5e8dHgBbQSkrzfqF9GYqbGjGs5STzOhbOFbQaJG0k63iBtgJo07s+CeTnjYxuHsTCw
	WR586cn0nkb0jMNzvyqhdkQUAisrC1ytLnKS09PPnQA3gskooyL4oiwqLNJpeA+VKiUa2H5VnQM
	VmUyaKa/2vMeA7OJBw5ky0JuA0j5MDnKP7iW44KjpGCXERgdoxYWkI3L62B6KfsGji7po2JH41D
	klHQILQM3HMeflrwu/+8ZYWGC4GL9lSBaVUdVeuKNKxzH6WFWArABXtL5vQY33LLE2+34NDB3gr
	osSyW+7z+KSibvmngz/dWiS+p2HgC5267epd7LO7DWvkwYbu6HoeRhtLVE4YC8KZnpvp0NmV1+i
	TI+EVUJ+iyVaCFjW0CdZi11I1F9EmvNtUClc9O+9O849ZEEPnJyYcBNJIIjzcMKL4cgYr/hw==
X-Received: by 2002:a05:6a21:33a7:b0:39b:edcd:d92f with SMTP id adf61e73a8af0-3aa5a9056dfmr7399916637.11.1778137570265;
        Thu, 07 May 2026 00:06:10 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c825379099bsm1200164a12.14.2026.05.07.00.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 00:06:09 -0700 (PDT)
From: Chen Wandun <chenwandun1@gmail.com>
X-Google-Original-From: Chen Wandun <chenwandun@lixiang.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org,
	zokeefe@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD MADV_COLLAPSE range
Date: Thu,  7 May 2026 15:05:57 +0800
Message-ID: <20260507070558.3064142-2-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507070558.3064142-1-chenwandun@lixiang.com>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E760140003
X-Rspamd-Server: rspam04
X-Stat-Signature: jnspthy8fqn994co5j7p9ojpankwh44p
X-HE-Tag: 1778137571-990085
X-HE-Meta: U2FsdGVkX1/beRbLoxf82CKXRI353FUJixJxfJ9AivVIQDaN5DLBO4OBjXY44wxwkuGM31NjUbWFuW/N6rMWPqXCha7nnPn2PJ+2UNRB7fYRNHtmg8bPE7GQ0ykuh5bIYQp1AEbR4g4VrMIvKk1BustXqbmP3jSZyM512aXEZ76bsmoLaGsFhf8iguDH80lqMUqJUrf7yh2Fn14FhoIEUjHmVMVpf5VyqmRdyPqyrTDa8pG5lv4c+cVuVhb/R3/YyEPy2xOLzagItawDZ8+hnfNjlOWobMbbDD/H11wiR3Z2adHwCulBYpj+m09opFAM5smc7ppKuKWTIUOmJM927M9XRrzIWko01WJw9/j0GvXcVPhZEtodXXNQGUnjC//fxB9H6Bp9Hc1ycxndYfzjIgHP38igiNlIjBfE4oOSJ6CGOl9FGse2yEcfqc7h89/C8wEo35tJ7pB6TuhjO+SVyxC8xweIa/aRvXapO2+Xx90SEmBlkL1pA7DzKz9benZZHYvAQnvuwWqLkU3EWQvhbC0CBYkSy0mbglmeFMEXBY0rMpT1J3xvf1HpCOXn3lZAtGtifCYcjFoPZBYm2+LqqDtYTzRqPMz+dNxHAk5WxO1Xzvn9U3Ao0MyibsyUM/DSRrWZkl1AbVeEd39hvq0p3AwifXZT9kNh8iqfAmUW5yAgz2tGogTKxxcMvTv0SFqxLgtrzJuiTQHZQjc9xa4fn7b4NOLZ+5zXrRIUhjPQg9IvBGLDqJaHlpTGWwEPbuKtMGfWNtaG4BhpeYFzbh/hH95ppM3wvkKEelBHtHvwh8wltNAamEy/aBc8WXOIhAUl44oQpy3atf6D9LRyqvY4dy4NBzirnR8RI8ivJtoYImZrxPB9Yzdg9K0yPAss48tnH0MnO0qA9JbwEsbSzt2LH/KUINkWhFDXz9Q/gagvyODxOW/ju2XGxsVwJI1Q8Qu84UD7eVESdoi+Pv8m5Mv
 4IQ3Lm+3
 S3fhZPqgrhnwto7I8+Xn9xsCQz54xOvUnXZ0nqXrSDdjigossUezyJj/VeQyPViZHCvUePeeufY3Fl42hcP+kB9SyhMVSGR5mFRxf+OU6dJ6rTu2VoakoUJKvtWfNddNyIPwjg6Av6prHfHqWRfbjv5EKItimC/ly58ulXvkHXmFa4LLbFlzJw8HShUXfdHV4BFISI4qKCGhvs+yA5idMqIs+6qcJl0bXC9MH1Gr5eMZ82nf25VxWJ0u/xLpLqZvFVFPLBcqX5d6V2VHujM1eMT2jepumBzXAEv/rvc2BSdxmGGdxRqAYsMe6nLyGuwk84Ec27IbEongCyTxEBMjXSDCkbmyiCHZEwmwMjyW00jmjCG3NVaHtNTDWOAa2DiARSvVnUYcOSRA4hoE4wF1buNUzcsD0C/odxM3gPwaMPPHVVtzmas/oQAVuT6phVS32/0D1lovyl4znqBiPQ7ngrCE66v15Z+WYU/Yr6v6/gfpIb6Mm8SyokAjWbFd+692bfiEozssgtHxpRPPw6rwpbtUWbs3ihSucdzSx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_collapse() computes the THP-aligned window:

  hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
  hend   =  end   &  HPAGE_PMD_MASK                    /* round down */

Previously this was done after kmalloc_obj(), so problem arose when
the range contained no complete PMD-aligned window (hstart >= hend).

When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
final comparison fails and -EINVAL is returned instead of 0.  Consider
two single-page calls on a 2 MiB-aligned address:

    /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
    madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);

    /* hstart = aligned + 2MiB, hend = aligned
     * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
    madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

Both calls cover less than one THP and collapse nothing; both should
return 0.

In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
called before discovering there was nothing to do, only for the code
to kfree() and return immediately after.

Fix both by computing hstart/hend after thp_vma_allowable_order() but
before kmalloc_obj(), and returning 0 early when hstart >= hend.

Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
---
 mm/khugepaged.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..92473d93e837 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
+	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
+	hend = end & HPAGE_PMD_MASK;
+
+	if (hstart >= hend)
+		return 0;
+
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
@@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = end & HPAGE_PMD_MASK;
-
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-- 
2.43.0


