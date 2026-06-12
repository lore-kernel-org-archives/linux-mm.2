Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D06CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504756B00A4; Fri, 12 Jun 2026 00:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E4C6B00A5; Fri, 12 Jun 2026 00:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CEF6B00A6; Fri, 12 Jun 2026 00:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 239826B00A4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4BAA1A0401
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:59 +0000 (UTC)
X-FDA: 84869907318.02.B8283A7
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1F7D720003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EJq35ycE;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BR0a3ryVRFpnQOFzhfXrKrFPrgwx6VYHHIteJPCS1zU=;
	b=moUNRM5Jc4RTmpck6bmdN2OWDsSQECHx1u+AslkFDj7zEe4pbtOhnWTQAl/EoxZttnIT7A
	KDA2rvAcniWC4l9ypl5Of710qAHAheahO9XwToz5eloMI1hXU4sMZKoGucC7kjc1DWEc/L
	lW07CVvwqHsqWR/aWm9CucStRQ+GtNw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EJq35ycE;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236798;
	b=XhbQ1TOdVOVYLw2oxo+v7DBNxhwIQBsysWj9cuHx64IZf4KJ78s+rVkU13zgpWno0DBJ9x
	mlqjKpkUHbZ8M/AGdHRneyn+9B84mFV2Pnn9EPsAGQIxWUw0JzR9IIye1wE16ZTG33dCpS
	7OBMqOHIBlcBs813VlfiV+TgxlfxdcU=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84275887a3fso1129334b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236797; x=1781841597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BR0a3ryVRFpnQOFzhfXrKrFPrgwx6VYHHIteJPCS1zU=;
        b=EJq35ycEz51NVxaQHdq/Mb9k++Dgbgft4wP8h5igM5I4lXPkuTMIZih0J/USk06pHA
         hylaVJUusoVumhEOxwKDZm1psjeGmjoZfDiuqmxn3sRTHMP8K5kC2x3DppbOgEq5jRHZ
         3GF7wOUBlfnBh2/8QwZPUC+UJF/8uVX4AZlHcRI5ITCFn9cAE9F+b7y7xoGIwwRxtV1k
         674IsV4FWMeR5vywI7JM8x6EcrA9rSTl72/jnwZ25fmaAx2Jxu5wgOiCJgh12UI6RkhF
         ao/rqIs0EeoKzBsOuoyF9i7H5B3hc5ml4ET79wq6bZ1RN2Hql4/klci/nRweRgwGsTaO
         xHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236797; x=1781841597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BR0a3ryVRFpnQOFzhfXrKrFPrgwx6VYHHIteJPCS1zU=;
        b=tJVLlLwTqcW0wlZusNJmWgGRZ6u1Obfk+ihXmjOatSe52z3GwVbyzqNGiDgAkgy4oL
         IOfQhiulZZ1+QgZz6/CJZKta7Fp00ZA1QJ7B5G/3QNmI2HgAQTCuCk26DOvYKeX5p1RJ
         7yHv0C2TJEaQew58Ix1mfR3qCRh3z7XIDdvLdpc3YDORhv8Dy6Kixnr3bRNeJWWz1rBD
         P6nZtX8fJhj2fj2HkaKpjCJ+UA1MWGKn7MyDu1meDxPfW58IY5Nv0TiFnNG5mXNVBupB
         MAGBn62t8JcEjaFcNKpHHOOpr6QP8LJvosMfcYCbQr/rdLQbAxEdvPooHz+x6Ybg0EuA
         gOdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/P1Xh2A6SO8rCO6eATdkrRM6FyEZKq+Wg9D34Y1xYaZQkXkoa6JbgHVZnEstVXzUes6ePeC+qn1w==@kvack.org
X-Gm-Message-State: AOJu0YwFN4gcMSd3i7/yFpt4vU15toSdGngO1890QJPXARb6QEFib99D
	/nNOcj6LkKbmeQv9Kud/WpaEeExXCrXJ/HxvYvjiE+5q/tIQF+toaAvkiGsa+q9xliE=
X-Gm-Gg: Acq92OGPdoF7xu6YLCOwSkXUdHSutcmQ3sn+1gRgeP/9fp7K5rjN8q3eefs1AfKQk/e
	VQV6v0fGLJ88J7C4e0vke3ffVQFSjDlqzEkhxiKEnDvb1YZ6Wo7fggoHbR4YNYX4nMyBPlrTAQE
	QEE7vbGp42bpQatEOS5SaipOX7pOOLAi+83M93NSE4ywyB/HRArvj4RhkttmpE0cpAn+loTLy3r
	O/MCWKKkCI2cGNg7fe3YN+iUnAbKqDEyO0zWsJjlNOgM0ZtUNTV3tN57Pt+J2TkuPF1TsG6aI/Z
	W8q3p7MWDlDyaAAy8ZlVOxTW15CMoBE/ISmY9woHttGzRzBOe5r3ED/VVfuP1OdAiktZGX1d0b8
	OhO0y2/ZcrQSZnhkbhQIF3/kZpzBNadOYfq7moVYteK4vUJaXUZgpXvpuUB2mEWCzXClYm8MSuc
	MbnUcPxtYEYJgkjyK5yivyfLBpZhGdfSUtSfYLmVWuGmU=
X-Received: by 2002:a05:6a00:3e20:b0:81f:5acb:55fc with SMTP id d2e1a72fcca58-8434ceb5bfbmr869958b3a.10.1781236796968;
        Thu, 11 Jun 2026 20:59:56 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:56 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v4 09/19] mm/mm_init: Defer hugetlb reservation until after zone initialization
Date: Fri, 12 Jun 2026 11:58:53 +0800
Message-ID: <20260612035903.2468601-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F7D720003
X-Stat-Signature: 3ymgthuxkqrcq5ky9sdjfkzr9xigqtn3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781236797-159505
X-HE-Meta: U2FsdGVkX1+NS0qZ2pnRrFH/lmxUsVS1Dpl3Ui9jd/K1J+Pg+f0xg2NOJIbHMAhv+Oi5Iz3UQE4fX5nl244VpjDQ2uIhqpCAOCB5AoJ/eBvAWcCD+QyrrvD8fTwTBQ7sRHqdBcoKfh+DsAa+panlJ22L/seRiI+74pp1xeTiulGzFtgM+CUxyrkTeTngGWOjrNpDODjUt2MAL6AtpY8pgSrVRocTqyX2ji06/w0LRWzpptXVNORnI383uXiM+9kGbijcJChN41fC4HNSKIaZlZelFCD3VwQyfCSd3LHfYJAXv9BvpHni923fqX9Z99xKHIyiz9s4JrMlNJHH5DIKRjmVzQufvOXpc68lBxGesq6NzU7i9TQ2ehR7kLylh70N/rbLOJcmz6caxDIedgUC3EcPfE+xMzmsGi8NiWx8NNTq3fe/mYh7AxmL9r8RUNbkMY0YpcmxCesucVzaNDLUPhniQ/Js79zPKPVGh7yDNVwyclJWJvxs+kmHUWyx4XP9DDcGZzSNhed5TRaqFeP0gkOpgRK916reALYWt9DllO1BwryDpAinB7YSGtdRuUqcDO9cJeNDcm1Q7nMENAKZicP4ngPK1XIGbxatEOi6E2i80WnwHvtszvOTufncv5aHt2UKufwFQWVo0shUk9pJgV0akJS50fxnKy3B5bYj4WRBZSovoVwBuyir9EOiu2bqZ+aKx61kZCwnYTrGSiQAOSMfbDVXdb5bULT7OxPKLVxTQMVwEgIwQGNQjMTpiClnY5JF9ZltI2U1x/V1IVjs8HRbnlZKt6A89ZF/+qxzoD/1tFQV0l84QZDxm2kbe/w5QpQg4hKDx6STjWQtXwfAFG56QXhgpqqwUnl3OqREDB3yN0PO2xvqPibjNsQtwyg17qQecx7JylT2MhbzVaZNB06JOO4b3tQtXbadW6vjZhQmNIPCN1SrUU8nAZYk5fU8KWbLQpa7xD63zCazYbw
 cRTFMRDC
 oRt/3PIZ0z+PbhEyOGp/dKCiZKMACf+mp9cvWjUYQkPiG17pnp/612DT0ms0XU6KkHTBR++Psw64Mgy7/ShkPdNIrHb9XiPAeD9DTEeLaEyHCZfcpc8yKGFIgtdWBTfh6phRqYv5F7f/VtdQQ+4Lu/9riUbAa0VteoUy8zk6YN1Qgrz1EYgEHwmhYs4Jpc7lkRorV6X0rBD4Tz70coR7J7/x5BWaHJa54GQNIQ7UsPn9N9TTPzKU/tObFPAsg+qSzoiDSx24SG6590umX7pQFOdmpDTotEZwhxH08rz2wDsmJs7ZXW0DavrsxH/lMhdGIn0xjqUsTI4uhISLHy+8V4cSw4h2HVSeFlOUcTHORANx7OHtjSkBlKGeU/BccUGj5k2r2yAZVTxSqIn1LPsWxFODGD46ClaADwc6hDdCEOPbgU8NsTGZv+WIbn2CPtHPsvqfI29jDjugh/D8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
free_area_init(), so HugeTLB reservation happens before zone state is
initialized.

Move the reservation step after free_area_init() so the relevant zone
information is available before HugeTLB reserves memory. This is needed
for later hugetlb changes that validate boot-time HugeTLB reservations
against zone boundaries.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
 mm/mm_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index bdeaceadb531..ccf494fa7586 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2676,11 +2676,11 @@ void __init mm_core_init_early(void)
 {
 	int nid;
 
+	free_area_init();
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-	free_area_init();
-
 	sparse_init();
 	for_each_node_state(nid, N_MEMORY)
 		sparse_vmemmap_init_nid_late(nid);
-- 
2.54.0


