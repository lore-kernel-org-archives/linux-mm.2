Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DCD10F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA3A6B0095; Fri, 27 Mar 2026 16:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AEF6B0096; Fri, 27 Mar 2026 16:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C486B0098; Fri, 27 Mar 2026 16:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72AC86B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C2FD1A12D8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:07 +0000 (UTC)
X-FDA: 84593047854.06.C37E638
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A8FCA000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2A2lpGA;
	spf=pass (imf25.hostedemail.com: domain of 3p-7GaQYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3p-7GaQYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2A2lpGA;
	spf=pass (imf25.hostedemail.com: domain of 3p-7GaQYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3p-7GaQYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644905; a=rsa-sha256;
	cv=none;
	b=V4+V+pm0mP5wutq4xvPmifVv6N+l/ZwVzrZHIeKERIgCyxI7HL3WIR7OCVfxupUPj26lw2
	JuDuPuzI+Ns4C0wfdZjL2kS0+ekKrIZ8MpaKUSV3y12UI9qJwHNxSDxrvjqIaAVf1D91vO
	+y19/IYR81jd8auDBNJVZSsJhMU7HeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
	b=yEE4SCWIwdTJJTuzR/AaA0S4ey4HiVwdQaxnVnO/qKHTVedYKr+/m8LdAnfFSpTF6nrPm5
	NiDdFi3f1UmEFdmiKuT7e2osgDtIVPltDoRHDoI+h1XI6MmeDxzQYF7Dy+pQd7v879/PsQ
	Fzu7Q5hpxdf29AujZF8nAN2u2IiQfbg=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12711ec96fbso1768255c88.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644904; x=1775249704; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
        b=J2A2lpGAwtPDOGQ/DNsJs//Z+2nIRlKouHBzRyjCNKwOEYsMuN8UI6GDGhw/Tm7YeX
         VR0WxPIyddjs6+1qGPci5bfA5t0vJju4RyNDlCai+VE+y7LpnrHvbA4VJwCXv4kxs5L6
         tXifTbEmNh6Awj8yEr6yX2WGtGe/VPCL6WUxsAO/+E66r6p8e0Vl6AxazdZuqp2oD0TY
         kqTaQaVsOsj35YKztfCtafhw8uhcCqh4CA/UVjdZOifFvRdvxX/JBy7kZuo0+Z3zpSV0
         Ckod9608VMY39fREfWtfasYYiCBxpQRVodT627Mcbmolj05DTkPDt0gzvEPEd7Pu0Zn+
         TYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644904; x=1775249704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
        b=obfT2YIvXUSFtyX28IE3nO8UQf9gsE+BYpKROinGx51XjNiARhu55KqZINi06AywIF
         KeQn0O60OUar4Ujihpbj/G8uowvpNLjNvgzqQYdV2owMSOLacaNI/ox08JSrpscIY/vJ
         YJTOd5J9AIw8g4YxVsfpm2Np9TeUoqfOIltaKpyhj+fpKtA6+yUvG1jBdkHUYMNhA7SJ
         X8m7FjEnmGNjy5AbkBNqr4JDCAX0MrR5H3GQKWibRGNkGifTxAVHncj+YtKQQAAhG4gX
         UbsqZI9tBWGA0J7UZYs8ehygGNVeiPExaeJ0IjfnAe2iTivS1yJuhjv18AtcWoOGKMni
         DEGw==
X-Forwarded-Encrypted: i=1; AJvYcCVByefwQp7dok86aar6BmJbyRIkwX6mHfRBuso4eFEN3t7RjYpi0xUFurSBHNUceIYCKKE905Ht6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy9mEkkRBqEiuY3TRCbE+pcR1GdXhJI4SyqUgmAwPmMrn6xgbzK
	lZdAcBb2KkyvMZy5yjXmwTZGZGP/I9lbxloKNLXqKfvK8TiyXWrUWiyupwiUG6EOW1DHXRqd5wN
	b/xl5yw==
X-Received: from dlbsj11.prod.google.com ([2002:a05:7022:f90b:b0:128:dfaf:10ac])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:e982:b0:119:e569:f277
 with SMTP id a92af1059eb24-12ab28f2848mr2382854c88.32.1774644903670; Fri, 27
 Mar 2026 13:55:03 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:52 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-2-surenb@google.com>
Subject: [PATCH v6 1/6] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, ljs@kernel.org, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A8FCA000E
X-Stat-Signature: 8uk7s7rosioy9ycobhtd5srxb8ydn8tg
X-Rspam-User: 
X-HE-Tag: 1774644905-352545
X-HE-Meta: U2FsdGVkX18wNf8pBkrYNR66GVOWQMNWG+sDUmv5PhTrP7nXlHyZmIb4PomIJ6y1MRgPWJYTivvbETywCNjsEEKEZtPOUay37zBKMBKSPhwwcfs0IZhsfuRTRQvuvYlRjwn2RjzQl3YKhilVUPC1ekpLnK9OapbC/TAyFkqXQLBW5FHXny6KPt9Jpua6z9okjBD3H9IhOAWpmVwfL4eltD6u5e1dlAW1LwWZJZKwRPZKH4pRinu76wuBlSu6gHTMZIZkpk1l/8zvkwzFw9ZOHzYiM4NuWeC/9UZsWM1hQFDrtsu8naAaFrVAMWP49eKw4OYHjVSq1qVBDkAH6mYLFTT/D+YkB6CZgiDgoEid4yfofW1XaPSPa9jtLMbDNlTPrM7i7K+FQrYY3x/7WihUzIe04fbHox3sx6T0wYynA/dJrLnPjYTE5v5uPrB76g/ZGKjHv9KuIQxGKgELDuzSDMLL8Ary2LnjMfbmCTFWLDW2Hks9UFmQboklSboMIcyl4i4mZh/nqQqE66CFmhu3uL8Av70dfu9OHpE2uHqH/23dXbWK6ef6jzNytWc700HzSt4u6VtktZPB0Tcj+pvqPOpUpxqbYPZ3kwhh7fimKXxiM1XrGUUFKn7zbSvcVqT1Rnw0S8n20fhKfc594s97GGxX6bNewD5NCdfaqaA9wGgx126MrulpV8cvu4mpzyitluSG0/0Wh9uBGSOhkh1St1SCjdTaMMeYuRb7/rFN77Y7c2zCDMgF68qAO7sOUic24aRNkFoXh9OjoIzjyDAa8YPMTeQfCPXfVKBAJBB6Y9TxO/sMKQS/+e8BlH+muOgLY5/gmji83vNSNxah7fGlhcjs15mGQKaxGWiZxKtNn+E8jEX/1psJA2Qzj9rCpN8y81s7oEOd0myFwUdR5OjF8BHV0PllbYlbmS3p0V7gsYd8ymPWwV0D4LHlUmgfp1VwTx2jMnMFxc9myh5Q2Wq
 Mb9wJAqA
 8xGhf7PSZjveiyLRcAVQz+MYpDuson8ATpjBdVVGF6//IBCnJUwN2+9919VZJgPNsXK47/IoSgclP+fZ2cgWd7ZvLndMohuxHb15wAPzt+5bXglYumQPix2DXkwOQkdRB8tjaZHSIh+dGouO9W80QMZ/sKpUw96xl5jYu4gM5XKkjVT5mneE20ffbIAiTmuPVDffaKQtrWGagOcrtxRIDhVjt/oCSM5y7FfzGZJ4CAhLMxqZ84JLr66PaVm4Mc9P0KLtwMQJlcoQMHmI4VTWuG6K+mwoPj0t706bJK2p5JU+Re4G/CA4sj8yND8J3Aqtdi5Uz5iiqHf2YT/5Bu1m/sBHBHFsPPwzqdXx3s3Hwpklr6hNxD4dhJoQp91dG5MdMIf8dDjBuUcoT8ayaf4k+JvfZQsej2rDAWOHpLx+EWq7TrIQAHnINhkY42dsBmEKk7GaIVVklovvsEXtgM5+teYqZbHsqUBi/bFpvV6rrsiseq9psGfQLC9ruuqMmNjd3q7G0DDA+pjEXIJQ9FQTDmyAnjuQ/HdPuTU4J5BR5PVPoTfhaC1TaYiWfKnbNe5G6hD2f8WmLzrazPHxFvoRmuS/oQQhKXl05XcZmPds34iFA2R2FI8mvNkkMZ2nofkGmkUCUXGFupDU9k1nkjQtKTMcYGbMuiOnkj532bjKcw+tNAiB7GKWBrksS+XM++uYpdxeUBXbMNA6aAbNHfmTlsZFd7mf3zSuVyOyE6htbkNMk76OfN93wqaAUwOviNkcBXwYgjLoo1gYm2r1a+vHkZaTfxtkIx00rwLV0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
for errors and return immediately after an operation that might fail.
This also makes later changes to this function more readable.
Change variable name for storing the error code from "ret" to "err".

No functional change intended.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vma.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index a43f3c5d4b3d..ba78ab1f397a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1170,7 +1170,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
 	vma_flags_t target_sticky;
-	int ret = 0;
+	int err = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
@@ -1200,12 +1200,16 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
-		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
-		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+	if (remove_next) {
+		err = dup_anon_vma(target, next, &anon_dup);
+		if (err)
+			return err;
+	}
+	if (vmg->copied_from) {
+		err = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+		if (err)
+			return err;
+	}
 
 	if (remove_next) {
 		vma_flags_t next_sticky;
-- 
2.53.0.1018.g2bb0e51243-goog


