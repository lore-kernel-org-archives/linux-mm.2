Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D98CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6968E0009; Sun, 19 Oct 2025 23:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97868E0002; Sun, 19 Oct 2025 23:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F9D8E0009; Sun, 19 Oct 2025 23:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91F008E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:17:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37D7EC06D3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:13 +0000 (UTC)
X-FDA: 84017031546.14.3D4A747
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 68A4740008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EFobJB0E;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kGks2sOnnpNLPiQkQk5TdavZHCtfoEFSojg02a8VBgI=;
	b=XgEf3WqZTBSqGKYRQpFKfqRkyPbrCMse3d2sG7EtB31OqEC7jcvPxGlHq3jwzXebtOA+d2
	1ejHP7m80Vl9Mapi7w8bRbwKmJWh0coiXsDAGbAgUevc/atDSC1rFXjG1GD/ZTCxsgSXUK
	hFp6KguSs48F18e3NhHwLg2JcHsWu18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930231; a=rsa-sha256;
	cv=none;
	b=3U6MQyj1YaI91kZ6SU/5V6RXR5NxeVJ+0qksF4eHIcK70EtpzIsF9yBtd00q8+1w6Xotla
	hdXgJpeuHZgQoBFhYmojSI2mUmUjSl8h3MKMMsn//czx1X0bKblI8l/WaDg5RWyiu6SQCG
	ZU/041dlgxqyXpwbHfanzv4idMSFt60=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EFobJB0E;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b556284db11so3381960a12.0
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930230; x=1761535030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kGks2sOnnpNLPiQkQk5TdavZHCtfoEFSojg02a8VBgI=;
        b=EFobJB0EaPsILvX41vbKHGopdHshbnj+kczt2zl+HZgdlWTesnes4KItvj3g7lE0YE
         QSNNZGNMl0UllxyTc0/ddFaA3NROxbRQg5uPire/tjRRAmM+LB32qgnInCSbK6EKSOsC
         qdDdqWwsYSiXrn7QMAExQErFwao2sp8utKvsCjmjwk2fcimUK+RfM58Sv6Njk5BDtgM6
         MDXreViNL660x7gYn/jjoaiB6jVM7gt3dXTgCfhWBgjZ9bEYDpYSRRyvceQI5XNGFjeI
         K6eOA+znOKUvKx1zOOJ+uI+9ACNvvqCNI2ziSckT+01c3OLg82tdhanW4dzsxbRok0ey
         7Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930230; x=1761535030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kGks2sOnnpNLPiQkQk5TdavZHCtfoEFSojg02a8VBgI=;
        b=rBFUgK3xyPV7MWE4l39B7ZKzGQZC5wErtRIxxjhMF2abxNLuLiFfigtDsVHrWi5RbE
         Jon46m7iAeIY0AW7pESr5+xakchfW8pnudeXGXDRP6Mdxb/W+UoUmBHkvL5/7/zNtmi1
         ZES6oAzJm0WrgAYuQQjZrce5LcYMGOX4t53CVyH2rN11tnf6kxMuvxpeYTjKIRSpchNP
         4QZVFAYDn8ZbMOnsYfjbXkJuhsuf1pt15rbZUCjlMbYlKEluu7ygd22Ki5YVsuupaQGP
         MCyViDMUUyvV3oy+e4ZcGvoTTUR5rBUvDvYoVirlNCNSHX5ULKtTkpWSnartXHZQ1za1
         aJaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu9SHMmqA9FWApnyuW6ZRuheqKIMfj6tadFtiYQEMU2rNHohGcHoGWuMS7uhtjp71QHGV3yYZD7g==@kvack.org
X-Gm-Message-State: AOJu0YwUnoG4f5boKJeAHgqar6Psae6d78gnmNi9VOpscAYYjoY0U6Fi
	yyLyYfZJe1IFkulk+mTIu8NDn63Nb0KAjz0WFzPV+YnxZpkdmQ7+WvL8
X-Gm-Gg: ASbGncvVv+qpRYlH7L/1iev52k5n/OMdq4iR+cMS6bJ4SBOq+/OXNtybexOA6qiFbNI
	YvF8+ZoC2Y90fhkk09c8ymn9Fkrw6qq1p04H3uZ48pn0DgvU0+VXefC1dQPSFXr66dCFOANN+9p
	r8I7iJvn0O2fwGfi5YzxR0uh0B4J0PIECSIsHxzFoQ3YfBb0gJoVQPNGTpSASFAKpdrFJDTU3qz
	+edtOLK8oMf3BQAc1IJ9fVAO5smhzXxvmqC9M0X5EXgKMNwznYbS+EEhBTKM5jmD7G67fdkqNkv
	dHJJQeeO1eAbFohGYbV5qRBTzYqiWwDUe9iblMK6zPymQXmkCCXhIF8O4R/whDVmPBN/srVXR3l
	n+rQEzqff3u6GwQCdvT4787H4/l2wluvqxvYWfqWC0+6ywg/SU6s7MGysL5wmKjClxPPZTovqVh
	gQjFCbK6qsQ5udwm7/tqX16lnHpvYlRcLamdNPCp+HLagKug==
X-Google-Smtp-Source: AGHT+IHgkWxUzoUUp0gWSk3OAPdv3h9UX6IroOzlUnb1eY2K5j3hSN09VNabSt60qr2F5Tmrcms9KQ==
X-Received: by 2002:a17:903:41c6:b0:25d:37fc:32df with SMTP id d9443c01a7336-290cb65c914mr164540365ad.47.1760930230150;
        Sun, 19 Oct 2025 20:17:10 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fddfesm66373435ad.88.2025.10.19.20.17.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:17:09 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 05/10] mm: thp: enable THP allocation exclusively through khugepaged
Date: Mon, 20 Oct 2025 11:16:50 +0800
Message-Id: <20251020031655.1093-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: i17fdxy1eujk5g6km6mtq5m596mc6jxt
X-Rspam-User: 
X-Rspamd-Queue-Id: 68A4740008
X-HE-Tag: 1760930231-351222
X-HE-Meta: U2FsdGVkX1+rkS1SlRZBzGmR5EiPeITG1loH7V3Nlx0P2HSOmKLgv33VnhaEkoAwj1dsUxm3+KEnwCi31kEn+3X2TspK6YF2F37pogXJhndrApAYKXzGYjlfdnb3EVQkvOOwgNN7upFh/OCakkHPjuHoEDDuwKw3KFaszCxR/bzJ2ykt5ndZFyhWjExAUbLSiW+2H8SUMN43TgqI4J9rINreerH1etulzD0RG6oAy7k460CmLhAbK/WyzvHDO4THkysZ8/drTekfb7grzENkGYWtcSTgxBJ/263e9DO0Y134q/jJ6c955cMWDFqeTwAIV2OAWddP0KayXXXgd3kjf+TqqgsjWEsdhfjaAns4Xrhht49XbASLpFqkBZwSVfw33qPhlsLDC2GEepPl1c5vV4Ku7JPDvbNevP2XiMbWYTwn/C8xwjG3D6TqEVVWwJ8HDUx6ovsz5m7ohKdv3VWzkrv0nzXTGuHkKGSGPSPR1B+y2tl9OEewcsKpFODlLzM9rHlsqqG3N+XK5evD6rWEvcWNieipvsdKtCQmY6zT3Jt16nGtR9Cdv0M5jQuNBDx74ZNPZEPTJ8fj/ilNw1hPE7w02MA37Nuq+0EXz6U31hyOg6f0gb46o80kghE6QrUkOCbuQq37gg3rTBYU3HupC73+OTCglmJOA6R4sB0sUwqQgBXnfciwrySHFI5G5j8xwt8WfMUDxU1U0sanzrkwOzxT4LOkKiKmr3Mfa2aq5WGAH9QkvCf39uKuPRSkSPOiEBebNRU0IcT7j5OmW8vz1xIRHSdVNsRNHLQMvTjbpPejBlj/B4Ww1tnXcyPwALciQDVb2h7u4StfMMA+I2+Cf6Kc96Zi4uct4MALyHhJmie2frdNGg5UAIsM1RbAg55GpP9ZXL/RHcSTdRUehAWQh7Hy7DoElQyBKzbB6PfDN8Xf6OIZxIH3bL4wC1GArberl3RUsA6joC6Rn8VmStK
 qKGi4TnY
 v4//P3EbA3Ieian5YHAs4wJj9Wwv3XnWxgyMPDR3+tdoK6cHmpRJtvdzUm09f/hTasA+jD555PjO4L7yqSbuzvM2uvoja4yx6V/jooH4DeAO2fbhrRFWxZkgz+X27qBWnc4tbM0KyPPsE3H9mKAC977VUk+y28JYgi9zlXsigRcqzg88oJm9HMHOCWMA5/z7BbeW3gc0qv3JEcugxVZo6tG5it2RY6bz4tsXIumTF4WhmW9hSqeApTYonPpOQFsbiu2JKkSJWM7Sm8qCpvi/FctTqVBZwhJF80g1WRVjhyMBCXJE8SAm8/Pydp3aze+e96CxzvTSI4399TZzyepEuuFcV1mrueiBnCKYKR3blF0kyS8KskuTbX0zlhpQKR+UuopQpFkB1jFz5IBqJ25MlEbJtB7+eExgwbcczJIz2eJgK2ursM9ndLPSth/fDG5XjK/Lm+F7rTSz2zjL7Fhrv/7CatMSbzFyKVQJ1AO5G9XKwFzE=
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
- khugepaged operates at the MM level rather than per-VMA. The THP
  allocation might fail during page faults due to transient conditions
  (e.g., memory pressure), it is safe to add this MM to khugepaged for
  subsequent defragmentation.
- If __thp_vma_allowable_orders(TVA_PAGEFAULT) returns 0, then
  __thp_vma_allowable_orders(TVA_KHUGEPAGED) will also return 0.

While we could also extend prctl() to utilize this new policy, such a
change would require a uAPI modification to PR_SET_THP_DISABLE.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e105604868a5..45d13c798525 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1390,7 +1390,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index 7a242cb07d56..5007f7526694 100644
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


