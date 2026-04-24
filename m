Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14478FF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452136B0005; Fri, 24 Apr 2026 18:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB9C6B008A; Fri, 24 Apr 2026 18:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A31E6B008C; Fri, 24 Apr 2026 18:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 105596B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:11:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8A75A014E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:11:42 +0000 (UTC)
X-FDA: 84694847244.11.4725CE7
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDA06A000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:11:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dlGVxKWn;
	spf=pass (imf25.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777068701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4MGhHC+NydhWG8P1j8ird1HDHK/LUJ2nl+eW8auQlY=;
	b=VKQ7orhQyJcMlR3KGmxMPKhXIOBrtt6srNrUD+zT1JAP+QbTbklw1OvipdHy0P8gaJuka8
	z6BWSL0H6Xp93FxO2f58ZE4aWzVM/0EwSjmShf00Nuz8FHBgbLcvwCvSfDP/J16lf3Xeyu
	7cEg+RMN8DOI5lXjV/lrX3KV/9EGQ9I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dlGVxKWn;
	spf=pass (imf25.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777068701; a=rsa-sha256;
	cv=none;
	b=s1/bRqvJknRiZKdPCkjC0VTkTMnhm0EebDwE80kf4jlQdRBJh2pZrcVzZker/0yt1YhSVS
	fqeeymdLBLTDwW5iprmBPWR4fhBGizKI7BOLiY5bADNHps2g2D5rqshNWzxWy2PP70hXF9
	YTj8KG9radbIN5k+afH0Hex+hD5QPXU=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso40421175e9.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777068699; x=1777673499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4MGhHC+NydhWG8P1j8ird1HDHK/LUJ2nl+eW8auQlY=;
        b=dlGVxKWnGkRjMDoYC5LTu0U2HR28zIthZweo0D3yluPLLhuzRXILT+y4H3KVNbZO2w
         o0n0IZfJL3PB6KhlBlAtoeh/vNVh0vLQQ8bVL8BUrWUC4GgJFs9ALwEoP69Qjm+w2h4h
         /GTsZzeOWYbRODZFV0GtOjRCioW+r4KpcaOvMv7zYS35NXG/GQI05RdVVWu259Tdgc18
         Zgw+8vJrsR8NB9ikkhlqVKWDWnBmLJoHPXk+na3vPf8QwsNWd3XHrNX8eXYd3LKJT7ia
         6EwdhUZwCWHopssOlBigobs1qi+MU8wZQRxZz2/3uOfoa+lFEDcF2mgiu0DadsTEHBfi
         uExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777068699; x=1777673499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f4MGhHC+NydhWG8P1j8ird1HDHK/LUJ2nl+eW8auQlY=;
        b=bqtSc0wujVmE5YN4fzAZv961zPyzMpCsKYfIU3ED1S5vmxbTjoUOb6wHtJZ6Upap25
         30yByem75WAW8MO52QqrTx6b4dIxOflpDzGYNlGsjKaRznpAtKIiFXGn27+4qDLcANRR
         MJTHtBb+rzSW5de++cPPBXN2bLJexnsGy/66OvX0x0TFOj7hNIWn5OUMSTXbe/vleg5y
         KhCkuMLwEOJjcytpeq+ovtHp1t53H3D1+RTc7/bUPp1Nc/+73KAJ6CFQbJih+D3KOrvy
         UFDQbxpAaRWww9EU6Zk50eNo6uZfVQSNXL5413HiQM6fT5ahb2uSabIVdQhYW1lVQsfw
         Ywvw==
X-Forwarded-Encrypted: i=1; AFNElJ+39wUIlXwpk1HCiV6N7UMWba5HoR/jtLL68z/u5+eJiGKSAOqxlEThSz2HR5tsTtMjMu8UQ/hpLA==@kvack.org
X-Gm-Message-State: AOJu0YwORQThPiyxjHwn8Ne6DfznIGUaXkQgY0UPs1Ee5+2dshCBa9Ft
	24Y6wEN4LsEeiXkZXY3rBL6dppRIVMMAsfNwEvwlB4jDn2sYR2kiWYZH
X-Gm-Gg: AeBDieun0aklmv60tJbomNXW2iVpVc7P294B4WoF+tIFxAdXxiQFPMfUYvfmU2zpUcw
	fuWoNfrx4q5VhSjbdCyj0jWLXGo+yoBP8MlxgfxS/oUeCOkMS/BLaiXWrYE4DCxv+HUeN3hEeN1
	+G5BZcmlMnZ47sxlhmm3Q/gBJREAyDTnsl8rjZAj56rJlF3vPEHmlI7ekIzfJWDfM6UwyEr3tte
	/1942Hr03OI4pXWemuabcVsN+7/W+QE/DgS3teOIKlfLHw2qmeNrX3As/kAGDhkk4pkNSSUyxNt
	mbYPi/uvY3zpEie2OwK/TwVhCDi13HisL3aDS79N8z2i1KUb5GZryySagjG0MJbK7JEIsu821RS
	ER1tIac3mPierqQvI8FYyJtzMw/P7eaUSdemQzgVkS1M8ol2oL3n4x4UCVuX+Ib8nV5crv6eOp8
	Q7MfGHp/j0HqlgI3uDae0Ra6jrkV/OPUNWyc51xua3
X-Received: by 2002:a05:600c:a31a:b0:488:b239:77ec with SMTP id 5b1f17b1804b1-488fb778db4mr371652795e9.17.1777068699319;
        Fri, 24 Apr 2026 15:11:39 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb75a913sm188157105e9.12.2026.04.24.15.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 15:11:38 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: avagin@gmail.com,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v2] mm: fix VM_SOFTDIRTY propagation on VMA merge
Date: Sat, 25 Apr 2026 01:11:26 +0300
Message-ID: <20260424221126.1238744-1-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
References: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cqgrshphr8xm5ew8go3aetrggwhepg9d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DDA06A000A
X-Rspam-User: 
X-HE-Tag: 1777068700-377678
X-HE-Meta: U2FsdGVkX1+rRCS4r6UlA1c1IQg5GNAk3IYFL0PzFWwrk+gP2ZORuva2wCiAv/+dUvev5OcUR82TS0K8iBPo6rSKqJj5MI65Dz0ktpX+neAjwRVY9GNCGwYJQSI2ObHM5d9OmLVk7dI8QaG8PzjOiI9oRk1zMI5p1QF0Fz3LcJhpBGRohRgL4p/X2Sh6q4j0pAmLQoEv6IbU1nGihRC6/qAQpyL5CCQgW8bUbM7OyXUzYXdOBHpiunpMdgFlwHUA3lqiI2gdGj1AdBh+pEUEY7dPRzkLDC9awHqhtuoC6v65AXVPF1fvxrSmQLxBAMXkj4N+F0EMH2TCeRio6hg8+B0QP1jQI+OEFqEuDeZH59+sAy4pd7PDFSEqIk5bZZoABGDzCWAeHmPCm6FIgXFDgetnRQ80U6uGrYKGv4iTLW3zyCOC+N9eu0K6Z2HWcici23KgDacSDPgLTZU+Iiy+jnNyFLs/Rt9lRy5aNz+BEwiuYtGCXEWD99rXfl9xoGIkpyqhFkhGkasn4EsLETR8BABbkHwM3SIh16UsN6KZ/5wPNxnbinFE/xiKpdZ7Yn5p86EkIhVi3zOpq5VPiZaIDBqxAKEfaW8HCs+JzXXqLweqGKBl5Vje2clkSGfsR5v+CNUxjXz2VrNnNahw8Utj/vEqoIimiOrzYBM4RRWizDjNPX1Z4PBfAWw5g5CQ0LnoFLPZ9rJQoO9aRxykfNUHJSFADIi14pgR0HTPU7PnjccdRJhIT6OfNfyXfONfZZcPsHvAheTy2wSj7Vdn+xXpbEF2p/vxLi/k60jkZZ0xLfgD/4iYchf2qnGLWi8GNS9DYQVFRs7viDRB6cWvkuofQQS/q6R3StIuYfJzPztm3PCBUaTrXntaNDf1uMnv1YlVlx2l9gGzz6RwYyHoyVzWguiRPMptHg+fZ+VlqivUWx2VvKGrxagag6wcL3XKNFg0VED11LyhgheH1Ees+Pi
 GiAKe5QP
 NPRNaT8nvl4TBOPQK5ZpACxg0ZWjvbQbG/aMkuxi068r1t98JqmQCtWJUTad3qmZR0hRp9zK1zu17I5W0aRNH8RLXFi+qOAdVP0hzCk7vJjv2hKjjiS69cOJlt0WNopHu2Ftv3FF2o+wX0qcKQh9mVxcnE3Rvwa9bQoloy6pBb4VWFLKiKQWirupt89aqy0322Lulh2CcYTppPjEbtiOixjq78m1VZbJ+d9oxZAXiVb00HTu4l4GF4ZF+HBu5VH5Hi6osqZrl6+LMIt5yTovMkJWIIRR9Ek0fLO15AfLsIQlkQTIfiMyI0V+OwI64gJY31Bl+mve4q0wv0/uaIY5cfo6tCsqZSK/FoPVVKREBcUZkWDAUXihvLC6lOANuLNfm/kszKxu7Avs5/B3WE0+7bKXaU2p9r/VTB6oWI4sLFYrkY5UH5iXRddl2rQI5kAnre71/9Ciyk2szVtjMu+dWpt0RIfS5CfBZpSRBsxZkas4e6way1vN96Eb9TXIxBat2iBNmmvCo32yScjvXW8z8yLlC4gbEP/BqgcEy+2FBCymE0/7yDyrRpn7dZaBhO6n/aaSgP6CAcGPaY54c077bvReVLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could be
lost. This breaks tools relying on soft-dirty tracking, such as CRIU
incremental dump/restore.

Upstream resolved this using a broader VM_STICKY infrastructure (commit
bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn and
risk in the stable 6.18.y tree, this patch skips backporting the entire
VM_STICKY series (9 patches). Instead, it introduces a minimal standalone fix.

VM_SOFTDIRTY is intentionally excluded from normal flag comparison to allow
merging in mprotect. This patch ensures the resulting merged VMA retains
the VM_SOFTDIRTY flag if either of the original VMAs had it.

Suggested-by: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org
Cc: lorenzo.stoakes@oracle.com
Signed-off-by: Ahmed Khalid Elaidy <elaidya225@gmail.com>
---
 mm/vma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 5815ae9e5770..03728d855684 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -978,6 +978,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
+	/*
+	 * VM_SOFTDIRTY is excluded from normal flag comparison to allow
+	 * merging in mprotect, but we have to ensure the result is correctly
+	 * marked with it if either side had it.
+	 */
+	if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
+		vm_flags_set(vmg->target, VM_SOFTDIRTY);
+
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
-- 
2.53.0


