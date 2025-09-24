Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CABCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02EF8E001A; Wed, 24 Sep 2025 11:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA838E0012; Wed, 24 Sep 2025 11:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BA48E001A; Wed, 24 Sep 2025 11:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98DA88E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F2B711A7F7
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:25 +0000 (UTC)
X-FDA: 83924454810.14.6060A19
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 702561A0016
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KEFbVgxK;
	spf=pass (imf19.hostedemail.com: domain of 3hQfUaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hQfUaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dzh5+kDID1KhkCxx5TAU7iczEzF1E7tPp3j9MouQ4wI=;
	b=ygLCrma0seCwll3/o4kpEuPcfqXHg7U2ZTRa//r0BO1pGDlYsPbvPGS0uiC4SrgYnb6mJ2
	9SxWY9dqZzsO+sfoWF6IVVp5Gk+wBrDDtqWoopLN0Q0GQ0HZPSVHut/YDBi4GbrFyyklpb
	5KulqgdDkxgWeb0enAvpEGRjJJJtWB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726023; a=rsa-sha256;
	cv=none;
	b=iw8U9EeCPDLgWjhXbDpFKoKNQbO+p/b7JdGRnQ/1VdNvoxn/wvFxrc3xt+DXTHBoBkQoTD
	Y8d0fKVdIS5n1A0fN0F9ZF+SyL5LpnSxB0oaeFSWgjdIqH1EkRbs48TD3KZqbBP/VbrkBq
	9kcEGxSZWZFDjCgQtkGtIon2gXy9c1k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KEFbVgxK;
	spf=pass (imf19.hostedemail.com: domain of 3hQfUaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hQfUaAgKCDIXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so65918285e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726022; x=1759330822; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dzh5+kDID1KhkCxx5TAU7iczEzF1E7tPp3j9MouQ4wI=;
        b=KEFbVgxK+6vbprBHGzbt98QiAA7RzjsxHHjTLZRJFpjJ2tsyVguzdWvimUzkWU9zKX
         3ECPcg0x0EfeDq2NJ1yRXLCMCfp2FFRJTmYu18qYONDG6H/sW4HHKcLftLNJKZyjhnlo
         IZ2Vi+p+AMVwjqaJ43o4wkzSNgzTJhuZheotxmgBpqCDAfF7fKeIFf/zcBtZRtxFu5sp
         TfSgSiMBTA8qLFGDSunxqr9PzHpRS/H0c6VH/wNpUPJNxowcU5+Wa0gFb/JsX1Ncz0pz
         u0b0BfeUPT3EtZqI1I30XX/MkZNjF5S5+8BAT0PJj82nUUETUjf+9Q+e+pdoZHIr3PNK
         zsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726022; x=1759330822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dzh5+kDID1KhkCxx5TAU7iczEzF1E7tPp3j9MouQ4wI=;
        b=u/xyrZSD9PSi18PhVLHmZWh5siPb4oKViR2deEBgDURZVFXAoOPaKLdsxHFlSo0ksR
         /hU1eLsAcXRBkThVLtSYdSi0lbDGoi+sFWoThhETGxH0ne6Q3wKsz5yIXJK0DKms2i9U
         +FIfAV9sXCNvIdMetqJmknG8HB28WWSOydqYOnliB2I9ULan580Uc1YMzLFSvdBr/JKo
         Nk2EUq8hUeff4EtnjU9JOk1bEYyzho8PCd0e5pVoglm62GM3ouoA8EOuDJc6ldwhawq4
         tBcl407Q4xbxd4jNqBcbgEvy+6ARmC67TKosoLv84f6YCuUjt9fyG9UlGvKpS+6SI+KY
         7UBg==
X-Forwarded-Encrypted: i=1; AJvYcCVjzQAn/XtJYmOmmAnVPBkIa5r5o1kk/id+5svQRFqX2S52D3jKyUkebHQQ8RdQ9fvfrYh0/JeX4A==@kvack.org
X-Gm-Message-State: AOJu0YyNhV1s0F+sI+jTH4qGFuou1wGOQ3pPBquUGkD8lye3uq6LRDS5
	IsiiK/FiIIiSl+sVES/HnL+y66MdHW4WIPn8N0XU/Wmr9eREVUKzIRJqO0ZYmktUUM3WlwNlUqu
	UPqvpdWLXJjaS9w==
X-Google-Smtp-Source: AGHT+IEsHROXBlX8gPQ5wff3adn8/PrmanibVw/L6EsgdA0zSkoUR9p6G5MTbXSwhHIl6BOnzg1VAmDD3yV6Wg==
X-Received: from wmbeu9.prod.google.com ([2002:a05:600c:81c9:b0:45f:2859:5428])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:608c:b0:46e:2f74:2b9a with SMTP id 5b1f17b1804b1-46e32a1a097mr1793855e9.30.1758726021991;
 Wed, 24 Sep 2025 08:00:21 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:49 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-14-2d861768041f@google.com>
Subject: [PATCH 14/21] x86/mm/pat: introduce cpa_fault option
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 702561A0016
X-Stat-Signature: q4uqmpd4x96jzbdxbbgckwc98rkermsy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758726023-104172
X-HE-Meta: U2FsdGVkX1+hdbOJtY0YzR48pyaGKe4RTSrlp/Ej68YrVJG51HXefkYr49QL5eXzeRnsL9Qi+ojlGWobeE7UeCY7XQVrQPFJgtKYJiPibHMx5qmUD+ZuTtgdybdaDLJ02iaGUDSsQz6KPds5Lc/g3LdFby4eV1wh8KSbrf2k8DBDYw8hixtwD5uOoZiHj457Re5KFaBhanRrphKY+AQAUejjZHZ1xxtaGWDJVe1PqyaAG34EyqoqSr9e9TREQeQ7eImyLpeKOZ2Pk8zfTJAdIlluRbwoIotpB0m24M2A2kyNUAafwfjFLPoI4iV0t0TU1ei1BlN6Gb/ijOb9yRxMfF1kfRkQHSTu/xGxyRYBLDVo1hppWR2saUZlppaBQDxLw/Acq2tRZ27CMA3ilpM2DI4tPH3rKnP81iTc3lbsLxJfzTWTQ6QW8LPMXChwiWEgDx7H1/UT1Fv1nujFGDiIZvWUkdsfUlQ4Mmy30ml4S3nJbthnf/C3kxwaAFnSqYYlmikkY0qzQZiPOfsbjz+2Zi1KIp0S9wndZstXwSaIkx81lLDWi8WeoXNkseWnHfP76UaYw33py4IZJCrmxGoRHy8dATC4uWdMJ6Q63qlN6KaaApj3mhRh8+jZNq3NgaVXXkJ5FfeAYE/vDFTD7aI4NUwkUUtosLNP3xn73pijbXhyt4ozp4GaYTafxvZv/L//YN4/dGFfg/DHCVOfxrtCb/F0c9ZfddQEiNwP6nrkOi2NV1+5LwoWJTKHp3eglTmkgdHFIFVt3urXK0kzA1z+oDAsvKaLK2RA0/dvtFf+rTOnchJdlcnPD9dtDXGM96IU3MgvAYP0WcqEcR7Op4Y3syr5+hlJlL7GShv6FVgp0xMtENFgtZjLjq834PVQ6DME8qr7EyGK4b9ANMhx1FvPV98tCI4m4mOzhHESRsOFsQjRHHhT2q7dZ1pGb24wPir1/KVeSlu3UkBLuzfxc+I
 ScO5dW0S
 /ly6s4PT4/DkWTKChMdbpSnIsoLZgvi2yLF3ZpMBUq5+CNsvyanSyOgq1BzTQlncqawg7xBd6b5PqGsaXTaSJBH2MlrBsmM5Bm2eXrnqD/EHYOJYHjGFymwh1PEEb5kiGNgdcQ/IaO5CGUdJavzi+uUBwQ1q7L5SRFBGysWgAS3ivNHdrlCxXiBzDCDzt6hTjr1jvJSrN+CTnbRJtpule+KPm0MvbWmshKvKu5Z9ftTEd9H+AbjemMSUjXBsYDM5bFrJ7ct1bBKgopluIYf2vPEHelyYSjk5RZn9yR1A7wQpQvXTr4yBhmt+Xf4qOmEBbJZtT9jj8bocUPLqvQE4Q3o+AZM5KfhwRemxPAVcStCAJmxKDkAFuc21OZfEmlzoBl5Ttvq2EgZklv/HIOZ2cAU/6UAsnXmiXm9NLskdY1mdVxddeZCwUC5wV6erZsRj9Ugn6V/cm0KiLk4umVzqDrfnq59RZH7r063X0Ieor2lqRL05jzrvvyZYoUfafCAm5YUNdUmCsRfQmZfQ2+/sHVQyM3xAotqQI5Y9CINDJsNeX4CRveepEIo+AGPecq9F9J91YNjDs7diU+so05KoF5iGRKk2MHjsKb0hrCmRpda3z5rY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Different usecases for the CPA code have different needs for the
behaviour when encountering an unmapped address.

Currently this is encoded by using the presence of the .pgd as a
side-channel. Subsequent ASI changes won't get the correct behaviour
based on this side-channel, so add an explicit enum to request the
different behaviours that might be needed.

Note this is now making explicit a couple of causes that populate the
pagetables when encountering holes, until now this was implicit:

1. kernel_unmap_pages_in_pgd()

   Calling this function without a corresponding
   kernel_map_pages_in_pgd() seems like a bug, so the "correct"
   behaviour here might actually be CPA_FAULT_ERROR.

2. Ditto for __set_memory_enc_pgtable().

It seems the comment in __cpa_process_fault() (deleted in this patch)
may have been stale with regard to the coco usecases here (including
point 2).

Anyway, if these need to be updated that will be a separate patch, no
functional change is intended with this one.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/pat/set_memory.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 53c3ac0ba55d6b6992db6f6761ffdfbd52bf3688..2a50844515e81913fed32d5b6d1ec19e8e249533 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -36,6 +36,16 @@
 
 #include "../mm_internal.h"
 
+/* What should CPA do if encountering an unmapped address? */
+enum cpa_fault {
+	/* Default depending on address. */
+	CPA_FAULT_DEFAULT = 0,
+	/* Populate cpa_data.pgd using cpa_data.pfn. */
+	CPA_FAULT_POPULATE,
+	/* Warn and return an error. */
+	CPA_FAULT_ERROR,
+};
+
 /*
  * The current flushing context - we pass it instead of 5 arguments:
  */
@@ -51,6 +61,7 @@ struct cpa_data {
 	unsigned int	force_split		: 1,
 			force_static_prot	: 1,
 			force_flush_all		: 1;
+	enum cpa_fault	on_fault		: 2;
 	struct page	**pages;
 };
 
@@ -1790,14 +1801,13 @@ static inline bool is_direct_map(unsigned long vaddr)
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
-	if (cpa->pgd) {
-		/*
-		 * Right now, we only execute this code path when mapping
-		 * the EFI virtual memory map regions, no other users
-		 * provide a ->pgd value. This may change in the future.
-		 */
+	if (cpa->on_fault == CPA_FAULT_POPULATE)
 		return populate_pgd(cpa, vaddr);
-	}
+
+	if (WARN_ON(cpa->on_fault == CPA_FAULT_ERROR))
+		return -EFAULT;
+
+	/* CPA_FAULT_DEFAULT: */
 
 	/*
 	 * Ignore all non primary paths.
@@ -2417,6 +2427,7 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	cpa.mask_set = enc ? pgprot_encrypted(empty) : pgprot_decrypted(empty);
 	cpa.mask_clr = enc ? pgprot_decrypted(empty) : pgprot_encrypted(empty);
 	cpa.pgd = init_mm.pgd;
+	cpa.on_fault = CPA_FAULT_POPULATE;
 
 	/* Must avoid aliasing mappings in the highmem code */
 	kmap_flush_unused();
@@ -2743,6 +2754,7 @@ int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 		.mask_set = __pgprot(0),
 		.mask_clr = __pgprot(~page_flags & (_PAGE_NX|_PAGE_RW|_PAGE_DIRTY)),
 		.flags = CPA_NO_CHECK_ALIAS,
+		.on_fault = CPA_FAULT_POPULATE,
 	};
 
 	WARN_ONCE(num_online_cpus() > 1, "Don't call after initializing SMP");
@@ -2786,6 +2798,7 @@ int __init kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
 		.mask_set	= __pgprot(0),
 		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
 		.flags		= CPA_NO_CHECK_ALIAS,
+		.on_fault	= CPA_FAULT_POPULATE,
 	};
 
 	WARN_ONCE(num_online_cpus() > 1, "Don't call after initializing SMP");

-- 
2.50.1


