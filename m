Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99DF10F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E8B6B009D; Fri, 27 Mar 2026 16:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2356B009E; Fri, 27 Mar 2026 16:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074376B009F; Fri, 27 Mar 2026 16:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75016B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AADC5160E36
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:17 +0000 (UTC)
X-FDA: 84593048274.30.9549C17
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1084B1A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vf2Ylclt;
	spf=pass (imf19.hostedemail.com: domain of 3su7GaQYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3su7GaQYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
	b=Dxk3tSn5cynW3S+vHioqSpGyhFcdxBwoUIARwlYBkiNaAKldInzF1i3jyx5WZ6mnJUgeph
	l2NRyjolR2Hq/W0TVSjZ+Y01OGFmDWZkIjAECYhK804weC+wFWif0FDLn56hqY51+iypfG
	IRmnhIuNAUpjM/Ettj2Monie36cgeqw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vf2Ylclt;
	spf=pass (imf19.hostedemail.com: domain of 3su7GaQYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3su7GaQYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644916; a=rsa-sha256;
	cv=none;
	b=5Bhd4dsJpYUo/EvaZvGd/tV5eulocG2J1kv43DDCuYEaDZqnCL/naOsxC88efF0vjuS+To
	a9zSz7IZCQPYi+1D/cpVUAe/cL4EGM6U5PnspsbiMIsMI2AziW429k3BfVPFRrrE/DL3OD
	t4CeTln/Lo0ua9rCTlu1ksVSlrGVo6U=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12711ec96fbso1768948c88.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644915; x=1775249715; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
        b=Vf2Ylcltmp0A2OvVpPHzdNmPrbTi0lBEOV8q6QR/h//RxuvKc289NWott6tyFj0kqZ
         qqsU4PjHvSJQ8PBF+YgJ1bzsejzPGZpCf5/GLTIdIxpfKeLq97J2mXiVNt3qp1A8XmPz
         uLNKEs8m7cu1Lw4wbr61sZPwrpkE+NlaR996IzqoNXtaKdGbPwiRyWHmsv3WN+vk0eep
         /XItOAdRkeeDzEBKg4xvGOSA8df1ph8VpOdqvRjZgyLWHX6H9Kg+ilO31sPIupi9pFuQ
         LgCTKR5diafKiuoIvYSTaR2DiGbA7R/IR293w0b1g+E9GGgv0qlkxes65JcSxfRaWCFF
         1Xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644915; x=1775249715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
        b=q2ziaddMAACvPRvAsnP26d8gFr5y1yMaHnAkKUS1BetGf/hHKcUNp/he6lXtIrvuhj
         /gAXUsmz/pG4xrQzamHymaeD380dI6RxJMOJcgHqoVTqs+l8prb0YUcoNV5V52ratSPE
         79e4n+qZ1WkpyJkRLtpIctXYu2PLQYwKcn0lbkWzlSfyIRWOs5gG/3lMxSI3x+ojhl9Q
         WSSDog8BaGuQsbVcZOMXzlrNN6ahFH0T6u/ED6fEDLfibwe8oPhT4f0Lu6KcECRdnaEH
         8uyV0Rle24ONayn2FDzXyLqJC1h3Vfi9QJtd2q1zXmiqIdAF3Eoc1RCP6k+KWz6et887
         ff6g==
X-Forwarded-Encrypted: i=1; AJvYcCXtU02DywvZRlD/dUglT0Lz8lf1RKjdYY/ghTWvOEVCNMOdcTihzNKapoJZLPJ0T4NxC9neYXJZJg==@kvack.org
X-Gm-Message-State: AOJu0Yw5vFJ9hOJTY2ko+pKNqsNDNw4csWUJy9hjzO1bspJyKo7QWHj7
	e1P+E1gv7hhS+ZoC6cSIYScFfpGK61/IDKDcFhuLyw5NBE8Uz4+47GTqD5zWv9yCIz2HY6IaN9i
	/BT+yfw==
X-Received: from dybml5.prod.google.com ([2002:a05:7301:1505:b0:2c1:5ad0:b659])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:ea30:b0:128:d7a7:5261
 with SMTP id a92af1059eb24-12ab28eba7bmr2796910c88.30.1774644914544; Fri, 27
 Mar 2026 13:55:14 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:57 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-7-surenb@google.com>
Subject: [PATCH v6 6/6] KVM: PPC: use vma_start_write_killable() in kvmppc_memslot_page_merge()
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
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1084B1A0002
X-Stat-Signature: tdydw91e8bnr934n8x4weffbuzk3mu89
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774644915-296126
X-HE-Meta: U2FsdGVkX1+hup9hN79BgK8BPmRw724laQNldEGWJ/C7v9H/PpQW9KA+A/Hk3U7y/bw5HpoDAExgPjHtuWSLGxOOLZI0aLYN2odac0/q/ZsWK1DXoaQn/WdiM94f7bEBGCp/GdldB13sV5uNiKpSU2d9Zik1QJ6JroSzXmQc6nDHr4rBCOrU8ASaE9CVjwMZKWE6CrNMJl6PK5ki6ywKCABSQ9/G5czmoqRAB4/2xb5mk6m4mURqIPYmD5ZpgpYqbP00GRXSp2rGseQ65RHSEEoM82/3Gpv1i30DRu4+ZwonH0FX+zecF/nHB0qEXuNM75AQvC22BurZHo+h8/LZLUOOo/KcSIIZOaobERYhrZmBSQ++3YgNTXh2eJoPJ04IlQdNmljTLRctrkff/JEK2UAVNaCfE0RmW6wf2oM9DVN+1ddgcra4E4N7fnocQ1Zqx4XykeY/0xS/3gi2RLvK6tYHYP7gvlvhUEdcMo0ebmkm5vRzA88vrtMfS/Xgj9fra4L0ZJjQv/g4wPle4xSqOr3f6xhuh2IWt/w5P0hqD0EE3N4Y608StaqtG3YBQL81OfjxeMDD1J0tOGDj7U4feI5+BW91vYClSzgBOdRmAZC/dL7hxcwG+u5NJLekRMP1J7RKUeNXnAQZvr54b/lJJ2/rAdGg9hMM3/2/JWbA298B7POYeriaHFPcee5k0W1NINITYx3sK+JjiIZnsuCaSVwCryKxNf6itDuANJ+lNUFOG1/T4bXXZggdcGjhBAYoFWk1whq8h8p6hIHEQHSracONd67Pzk7hXUtbLvAFjGwBKTITdgWNuMHhrRwjo8fnnNr12yEF0zBmyc7M+/2pl/oFFE4tZrM3HKhaaPaZyQrkse0FY9azB1RIUBEaGkkbnanlzm667jgn2QZOafuHfazwwTQHMLxaSM9wGBn/nSnrkeImCEKLJjO7SrrAdzVS/rnMJEfF3jEK59TkbtO
 hQ9yUgGF
 OOX5WUiwPyr/E61wx0GjnzRlKkl/SfIixKZoyrgMuIxCoGfnIH5aHWyR0SDRThEQveV5pt6TIsmmoPqphl2azqPdEeh5TrQasztC7AH1NUAl8A4AwvP8SkmiFm+NIfpnv0T52vBdBvXhMOpchaY1FYeNOBh/219woZk4CaPkVubs6mLNVLq/Q65/33F9HqspuV7EJYXhPFDrYx3YlW4SCVaLf5TNs86btD+fNOK2Ts2UV3qKh+c376DIOqhLQXwTNURxWgg0L3QKbUHvKWj+yfbaOjwc2vrSLC28G4OYBzY+2Am0NlpZgk2QtFKa3nFl/TD7Q9TS4ePD5cXDv6zpWedbCN238IVSxQcJLjfPvYfo49dS7LbHEp4NyKz61YeGV3Bl5PtKIIx1gZwOW5vvDllQ7ill0snph3xzTPigL0Io0FDgMa/UEvC0Bv51Zv06J7SIq9U8yfgVXhm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() in kvmppc_memslot_page_merge().

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 5fbb95d90e99..0a28b48a46b8 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-- 
2.53.0.1018.g2bb0e51243-goog


