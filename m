Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC22106F2FA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D636B008C; Thu, 26 Mar 2026 04:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F52F6B0092; Thu, 26 Mar 2026 04:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3326B0093; Thu, 26 Mar 2026 04:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034146B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC639160BF6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:46 +0000 (UTC)
X-FDA: 84587487852.27.172B48D
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DBA5C0004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Np+0x2AJ;
	spf=pass (imf10.hostedemail.com: domain of 3i-nEaQYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3i-nEaQYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
	b=7/gZMIgWxR1bNvrdUpPou9z8k6kTSsJ+xIfJXpiHmjTwfxeKWmuXojaBkktKuQctCnH13X
	HXocuM+NgmjhgBJvP3iOMhAuL7SNwopCc61ia0qq1XqhSgqUI0tFwkvCQzze4QmdaRfwQ2
	JDU3W/sse2ylQRQSWu/vo8f/t9zEq+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512525; a=rsa-sha256;
	cv=none;
	b=XDcNsQCDwkmLQmDKgk19MvkGsllcMIRGKjLww8OGBpEsfm99fubjZB33F3Jn94lk5MrYO0
	lMpJfgkehf9crYxPAsjYmaK4stXqCxeOrV5Z78QuQjLctzUFeGjZsi87nyxZsUvqAwhsyD
	seU2wJ41LRfw/fCCle2kUdjPUewzC+8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Np+0x2AJ;
	spf=pass (imf10.hostedemail.com: domain of 3i-nEaQYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3i-nEaQYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2bdf75bc88fso609691eec.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512524; x=1775117324; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
        b=Np+0x2AJjDi+eQBd7AXEs2amdanXm7DkUFJXiVrQtnwIQMeBxP6K//gyOCnuv3K2EC
         0217jjKTD1Z5tgbp/f1KrmxSuViKcvFpn60z8Z/34KQQHuI+om3RiW+M6A/LX883I9E2
         M4xHigzo2H22ocjp9TgXTELhfWBLtYltvXKOkXJVhzTQrACAS71P1bcfjnS7ua41k+Sj
         qPLtrhNPLjI/o97Mr9ZnNRGI76SCN27gd9J0tDiy8wjFvPy6MhLVH5kkiWdyNA4vwXVv
         WArvtkoTR+NBA4E3yNFEM9dcRdkJVGDA2V2ojykMMlCzbZyBsTCm6OCcmNh1dL/EmNW8
         vfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512524; x=1775117324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wGMSLi6pfWPDruUV3e3+0duVYRVGge54aYv+ZuYilb8=;
        b=C8BNDkuWxK4aM3XdXzI18zq/9/u2gLlHEfafJN6ByZpi5e3IbFX+uV7PXepue4J+Vm
         PTr35w4l+Q7WvffbDSk6Ms3HJUj7gqqaBSKKRu3b+BrfQEkJ+1bjIqYDKPjlrIirE9lS
         IAvB6+dOLqk4irFpdZEDO+Sf04FhlcOHN2dt4uL1fAtGyTy1FI8L8zVuprDmmUCMGedi
         nQMVE04aa2BZFpt4B45A+pKBMuoWyWmeKIc67GpnmF543Trr8kbAizN8OUDZQab98v3X
         g2xSAGavW9e+fyFRTbFzLlBDun885R0dMmRih5UKE4lhNHd4xCO+jclinxpwRUJBjiLb
         xz9w==
X-Forwarded-Encrypted: i=1; AJvYcCV7zYSHH95UQCJscFWHK3OJXDVskSbI40+QpVBFxjfRhT0ZpQ6sb4a8aduZjdjQBVkDJbYiwRYlLw==@kvack.org
X-Gm-Message-State: AOJu0YyGFesbAFSZGGaEIfMdW4jL7a7PIldmqA6BgVTJsHjtuJYUx7s/
	gCjl6QiB7b76oeYNjrI+qAXpcKDjeJhY3GEWfCzVqOXH0E+KREt3qRnRVxUMM1ig1Vsy/BJF9U0
	BhlChFQ==
X-Received: from dykg12.prod.google.com ([2002:a05:7300:578c:b0:2c0:da3c:9f74])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:dc05:b0:2c0:f424:b545
 with SMTP id 5a478bee46e88-2c15d350374mr3760721eec.15.1774512523474; Thu, 26
 Mar 2026 01:08:43 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:31 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-2-surenb@google.com>
Subject: [PATCH v5 1/6] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0DBA5C0004
X-Stat-Signature: gmemhnatmgyknpb45pa5b1j3rc6sffex
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774512524-882685
X-HE-Meta: U2FsdGVkX1/TyIvkdgMJBUYwxLV8v2DkISRJTNzAjrWWAEijPtC3V+cMvDIR0A1vGxQZUDGLaRycbSz2KUsqFbUFH7kefVayqf7JOGEh6/fIC4Vcuqt3gKI/IxwbRmO1wMMCU4ipU7ReX0rm80uZK6AAbubvxs+fvcwjYxtCSY87aca+3n0Uu+GpCbh8ESN9C/2kwZQPQcGkgBQpijCE65mN4y5+bGCoNUZGGZK2OXx5FJRLMbOIXRSgfM3foCYZ82uuWv9GOY30GvFasLQAuH2kg/aHqgy2A+9of8PmGMcasl3H5wXjQl2FZSSgA+qFBGdS1hpm2tZJRNX/ouFDDL6jftvdPbYrCBXB2eTI7ulKr2ujpBfetuNaXCuso3F7TnSWm/XyqbQOcJAgCu5X8p7WYthHdY+GnMdtm/H9wyq/xnxdCHRJV/qiNgtOBcI5s9d8a3eh275iK1B/siEHauNai9HveYzWiOtWM+84Giz9st5sf1yzI3GpeAfcsmY7LiZjGg6Y1H1RIvdzhuf28Ontl2juS7m+hLapCKpvny8R76t1nFo5EbWbQ7ENgN4Pkvc1nVnGSSlHeKQxJWWKnSE0tBzRN4KNtxOWjc54eplC4IuAHDCwVTE1w3raSwmsMZ2kw8WG3joM+RqEgDAKwTyCaGmi3eV5zTsZVDQQXmjeHrdQ1ze++lT6Q7Yuo38cHSmSTdssB5tviAv2FRA8DK+NtELWZWHj5cd5ExDsHowSpku+7O0wL0iUr0csFsxH/7g9yyhqCyjeYXFkjxu7yYW6zYmtDLPo0URZuVD7y02XtV6B4h7b/CknDKMbNRYyI8ZZSpIuPl9ol+eui+GA4C1Qb7bqycyFe0l/O0wr9tGlMiA1qHQX5nm9wkzNTwSuxLELGRBY/pP5ntU9UzBRBwVV6+99V50tYwYudiFqO0rjzfLs/P23O8yBwGNCdjDaGexEs1I/jeKTY8bPkML
 JbsvgAMh
 Z+XwAAhaA8U64iZ1XVm3nrxog2PMagRbUyQ7Smw/ac5jJb0/F8zcca/ZCctSsv4VoNPEUBnu7/KPw7yi7JFOI0UEYs59Y2WVxUfLoGyivRPvYTsXY/uF0Aec/EVYPcB8PL48htQpz1L5nhSQBKUiqjE5XLcwh8x3pwVhAfqDSbnZflg0ieONC2NkeRO1eF0OTB7TngZ52k+dNKUkJMCUIHqaSfSiCH408dZjBFWGZgNntTHWLxrzpd61AVJlSCUv99QZj5eSBeBfFRTEyPSZq5az7aorMTK/SpJpkpqLFosPUjyM376CxGLiMSGJqCoykcIkR7eJSahmlEDP27+Mdjxv7QFDkObPNx3mztqoSuV17CP2T/gKvkjq0l0+wsAS9ohaKz44+GVB0x88ReU6fiVvuuLzXcVNk0DC0cQzAZxOAVGr8x8wmCOeH1K1t/fsGN4a6W7QR71ccn10=
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


