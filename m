Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F574C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 21:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A006B0088; Sat, 19 Sep 2026 17:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242456B008A; Sat, 19 Sep 2026 17:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FC66B008C; Sat, 19 Sep 2026 17:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E27B16B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:06:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69E628032A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:06:18 +0000 (UTC)
X-FDA: 85231744836.06.65D8395
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id A4C921C000B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:06:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LSyH3HtL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of benquike@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=benquike@gmail.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LSyH3HtL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of benquike@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=benquike@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789851976;
	b=qSGvjMJL1BT6HqL0qbzpwDZENWtp6v7N5CdkFsOHWy4y9QWF4RLRDsXlb62dVCW4fbo3Zh
	8DWe1psC9NWk7CAiHr4Z0yrICJs3TGPxvAMfbznx6nVo4zby6JRvvtvqNwcmf8RV4LFhHt
	mkFpxy6EKbkpGkhlsoGx2qvmBHXXqXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789851976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=82hNcCASzwnnQ3mn30WFW2aXkTjNeDCsU0d5QUjn04Q=;
	b=Nf8GLQjQDXlmraSpho2WnuYXMMXzxuRGDAKWNNfAWZO0wdowT1mr33o9C7CmpeEd15DUg1
	RKL7pdW+neU/mvfHXVg0XoaoWt5/YISAIM2t7XS11igPAqxMEPhYaqU+BvNG83sO3ezkQ+
	cjr6/B6XwXtR1p3baQt4WHIoxnwWOZ0=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f066d8so6554925ad.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789851975; x=1790456775; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=82hNcCASzwnnQ3mn30WFW2aXkTjNeDCsU0d5QUjn04Q=;
        b=LSyH3HtLb6MR2ColRlix9ydcl46a4I0ymGkfDrN2NiUb6jJJn3VP5zMHjnqGakOIXv
         yh7NSak3f3IFhofOtQakKxDUJnQZmgVNBr+F3TMUoOr6030IID8lrtA7+4THPHYe7an0
         8d6FOhEtYCC5faPwWVNasTMD0xQgKMfCWiSV+cBHsDsTfPcygrG1RY8VwsSTE8TxbjKw
         Z/TCUyftADB8TfiBarY8Xj/ca56SunU3amwIEi6n1YLzsrsHwUIskxEAot9ZfTxOUvQn
         yseuo2kOB3hcLbuejqf45A7ZMwTXA2NekkaYEvfFngtVmqg8wsOdZW31v4Oe2YVtwtrk
         Z9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789851975; x=1790456775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=82hNcCASzwnnQ3mn30WFW2aXkTjNeDCsU0d5QUjn04Q=;
        b=AHmEUDyi59P5CuwrQFuKp4InOTrLYI7nNc+bS5+mOuJ7E8wiA/x8gied9lSXLsJwf4
         QkJhJDNu6CB4YKJVk1aS5ErG1tZAd1pb5JtUsGcnaSWlu8s/t6JhJiStB70CaCHr679j
         uEGnC0m/PDrq0wOnBsHGM5LvajbzGRq/tsInSWwVtFON1pX6ocdkdpHLAOQ4gSD3FQew
         0QLCT8JJZdi/RXCA5T9XQQSTwDSWVW5XhV89P5tgizenfMy+NE2t1J9CFEAauG6XFHwG
         oWMKNaN+qXUIBcrpdHKpV1puFNsrXwrvP4MSu7FqJjfMRLbuVljH2UWKJKMMrMXapDCS
         e/Ow==
X-Forwarded-Encrypted: i=1; AKwUvBxLxL2S/IfSU/kKoPUm4jBImkvcciZpob/IzWzWxMYVH4uGdZ4k8PsWcRasfx7qjjNneSYA5qtJlA==@kvack.org
X-Gm-Message-State: AFuF++kmCHyEc0xmqQMYiyWJIkyj05fHuSDJHdHUBsJUHu5VNB05ADjP
	/WSbDxLX3LnKR/9YSwyaNjidu1B2eL5egEunDF+0VCspIjQzEObFJAaQ
X-Gm-Gg: AYBFou1YqsuXPWaUz5ivX5MwfYF3pzCVz5EgOFm6O21WI1Ga6wABoeAbLgF3MzSzc/Y
	WcTPz8FJH2V3cU8xl7kly5Bd6eFC9juDN5GxBHbKE+yWLZNhK+t6b47jyzzt42xah/dVSkPIqGc
	NCD6eILyGn1WZ3zj0kwVmCRr889xgnHX3uiPIMsCRJzG0zk833iAKv6RNVi1E2BcCCN0BF8lR+w
	SQd6dnirBEUxgTWmMlJay1PkjndlrM8moBXzg3B0FEbu8VoCpef9xbULbp/2NgnS6Op0gcKNaqW
	9uewhUzep6LxvRa7A2MyHrx6Uj+b61ApeK9J2v0V8f5upBDTmV/Easoj5sFL0enYXy+C5zynK0u
	PuT0xyMZFYC71+Xqjv9gq8mpYb9mzoG87yeYp+CgSox6WBhqKGPkZNDuwZ3C3Hg5Qnz4E+60A3k
	0bHACUZsjFsE+vobNxGyrt049eeLLbpCjmbzdmLp9hv+aWV8rc7QXSc4+G9+9iSz5tnLeVqe1tt
	Gf+fTRaJxBzoNecxXWUlYit2tpfxHjMKtaU1Z3tlp4/SHaYYPgIPyu2eRoeKhIdGhUjfYv2y2Jr
	AvdTMY9N05NS+D37hpSz
X-Received: by 2002:a17:902:9a06:b0:2dd:c100:2520 with SMTP id d9443c01a7336-2ddc10025ebmr25871935ad.41.1789851974831;
        Sat, 19 Sep 2026 14:06:14 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc1788bcasm12804445ad.21.2026.09.19.14.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 14:06:14 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org
Cc: vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	bgeffon@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mremap: account unmoved locked pages in dontunmap_complete()
Date: Sat, 19 Sep 2026 21:06:12 +0000
Message-ID: <20260919210612.3028241-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4C921C000B
X-Stat-Signature: nffm4k8as86jy7czi8eyre3jypcjjuyx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789851976-942783
X-HE-Meta: U2FsdGVkX1+ZHqAv/1Lm5kKFyxOsWW//57KuE5Jel81wX+KcS+mPjrAbRZ3OEi33nQFJ4jTht7EAicxWVpZWGnJDthIHDyJaQTfBjdHv8oMJ4SCwJO2GRF6AQG3rpfDrDcbznjCb1263TQNHdq+KoWTOz54xQxLXnetFmfc2ysO5SQMqHhRF560fFKioEIFe9G6ZUTcnPuaxFUKg6Bu8Vw7BSGY1aJArJ3bIV4vAE6BbUzO7FpirJ4eqtNXaRC4rETxrCXcI6NuWRKdzLAu4OE7t83cHOdVPDUKmmzRL4pfjw8LlBm2E10ytxVzruNW+0yf40y7RwW3HonnkYWj4dMPa9WHS6fgERo6kXN8SSsQVDlkJpqIk9u5nEmUIkPv4XNrXTNvFk32HzMgo1Mz6thXa/LrauyBsjU2klJMdqV3/Kb55D82ml1Jhw5pub+OJsEFjdXLn95dYquiFvYNovKdvNWlzRQtVI2C+SKbp9wuXo7jrsTtHyRCFuuA2g8XsECqxYpL8mMbn/qY/FVtmuAZ855xF1G77hn/fqmhg5cMMrw9LacU5nNN/Smv0H0zyuywi5z/sTMf0kCdhxYKrbVcgEl9GWLbz0E/WVz+1RSrRx/eJ8coEHuFxP5UGC/tW79Xao8w7e5VCS0ZTZRxfX+rlK0ara2lDj6FHK3IdatIWc2BYkFrmSwRt0pLDTVRcwHe/Mmq2toYyqr9O1kATH7n50zmVMdT4EOx7o2Vyx+ty689YbK+gIIZqN4dWmvZK+qSQIHikNiEb6J33CffYbw1AhQ0zJH+G3tt4hmNoYUcUAj+pUwjPKzaSisFOJ61KYlk9lzFuOjv2cUPwBgjodGysQBjPJwSJmH/eVr2VmDVkx2EeT+zrkch/Jv9lZ6tORqbX/YIhmMLyUnc5sy350FJDUgGMGIa8wC2319Y4ui268O5FxH7nd/9oA9nG+VLTZrvtZtq6DKobo5WfGWn
 obJn7WQi
 24KkzyFX4WtL/F/loby6ZV1sd3xIWAbSoL4hMaNCKXv94AXcneujrhJ2fiZwvtixRE39PxrSGlWoGwWbtlqIl1Jl4VBsIPRr6qO3r/p/cFGPIacsDqWQ24QRLHAs3gQIxWQX4Sl4iPCJCxJ16ljCeY9ZL53YoNRHYQP+p2v4sxh2CApQqxFcG7IQZ2HSd4MAkZ8GiLu9xkh8sf1jkcJnLf/bETcYMqSxRSBviwF78A1zAzxZJFep//fWnKqmf5olP8jfPoV0hgCD0OyRgu7PvWlst+36wqBwuubf0KwkRMSB72t32/QdX7ZtkyJPk12zEgE0afaXVmX8aMa1L9mnGJ3mzh5Lr0U/wyCIDLPJECM7n52m7UYhK+hPhoZOoOS7Ntg2Ne8tn/Q6IyALFQw+dS0NTH6Zc63E3IDfvQ+Lnx9C4lLpRCbzOOBaFIOIryWYMoZkjOcV/0fhtNbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MREMAP_DONTUNMAP is performed on a VM_LOCKED VMA,
dontunmap_complete() clears VMA_LOCKED_MASK on the entire source VMA
(vrm->vma) before vrm_stat_account() runs. This assumes that the entire
source VMA was moved into a distinct destination VMA (new_vma != vma) of
equal size, transferring the VM_LOCKED accounting 1:1 from vma to
new_vma.

However, two cases violate this assumption:

1. Partial MREMAP_DONTUNMAP on a multi-page VM_LOCKED VMA (vrm->old_len
   < vma->vm_end - vma->vm_start): vma_clear_flags_mask(vma,
   VMA_LOCKED_MASK) clears VM_LOCKED on the entire source VMA of size
   vma_pages(vma), while new_vma only inherits VM_LOCKED for
   vrm->old_len >> PAGE_SHIFT pages. The remaining unmoved pages in vma
   lose VM_LOCKED without decrementing mm->locked_vm.
2. Self-merge in copy_vma() (new_vma == vma, when new_addr is
   immediately adjacent to vma): copy_vma() expands vma by vrm->new_len,
   and dontunmap_complete() then clears VMA_LOCKED_MASK on the combined
   VMA. All originally locked pages lose VM_LOCKED without decrementing
   mm->locked_vm.

In both cases, subsequent munmap() of the VMAs sees VM_LOCKED cleared
and does not decrement mm->locked_vm, permanently leaking mm->locked_vm
until process exit and allowing unprivileged processes to exhaust
RLIMIT_MEMLOCK.

Fix this in dontunmap_complete() by subtracting the number of pages that
lose VM_LOCKED from current->mm->locked_vm before clearing
VMA_LOCKED_MASK.

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>

---
 mm/mremap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ff794e24f78f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1335,6 +1335,16 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	unsigned long old_start = vma->vm_start;
 	unsigned long old_end = vma->vm_end;
 
+	if (vma_test(vma, VMA_LOCKED_BIT)) {
+		unsigned long unl_pages = vma_pages(vma);
+
+		if (new_vma != vma)
+			unl_pages -= vrm->old_len >> PAGE_SHIFT;
+		else
+			unl_pages -= vrm->new_len >> PAGE_SHIFT;
+		current->mm->locked_vm -= unl_pages;
+	}
+
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
 	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
-- 
2.55.0.1082.g2b9226bbc0-goog


