Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBE5CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C404E8E000F; Fri, 26 Sep 2025 05:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0708E0001; Fri, 26 Sep 2025 05:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF8C8E000F; Fri, 26 Sep 2025 05:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 974768E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7299759E4E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:36 +0000 (UTC)
X-FDA: 83930891352.17.20228C7
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91F131A0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hz91NR8+;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSK3xayS0nafPEeCs+qk2zDDE4HBGPMWnEY1k1aBfXw=;
	b=iua3fX/VvYCBATWuIPUBnVNQarzbf3yEeKcRVqDn1Dqojni+SAd+YQ3kwXalG2sdwkO7rl
	XhSrGhtSu9Srfw8nP+enmnkelBq1HRcnvGQpWSGatfNF9hSXs2XhPgTeFTbchBEl2IVnOA
	6yxuRQNyuzqhDy4p61R8oInO58vEKZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879274; a=rsa-sha256;
	cv=none;
	b=jHcEfUnRZ1+iNI25RmkFFl64rzAn1JmWYon0oEgz2307MBHPiihVct0TlA+QPIwQ+rmqrY
	CoQ6ufhdlIKDXxFyPIHGicDCskdv1Wc6rMe8G18LDVJnK2qjxTVJXxuz0o325I3L6U8y9p
	30aUqKhk+OXhJp8abozpBnfoia17vCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hz91NR8+;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b551350adfaso1849852a12.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879273; x=1759484073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSK3xayS0nafPEeCs+qk2zDDE4HBGPMWnEY1k1aBfXw=;
        b=Hz91NR8+/3668rvtgf+bfl2J7in8c5jmgkhs0o7FUbkUKyLUdlGGDJp0e3wRak84Ha
         uHKrPQd2h8/+KLh1N5dyyaD3BHmA3aNrfzN3OPmnbOcMXeqjAwO+Gj7sga/ruzyX+L0H
         cryDa0WyoHGgSGIdZKXkSxwD92EntsCygJBIbP+IOYu2xOn0HELyY8C2+z2WTfSHKxDq
         g6jkEW2wVdEavz05ZVLD+xIANG9adZ5Ih5S//aA8dnfWhsCBYGu5XRG545ZpuD94JJC8
         yrNnbnE7XzGXo1gm7V1BIOppuR5LIWPI91GAR1cPjqwYL5cIVPlARMFZuZmGL4Xla8Zu
         U3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879273; x=1759484073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CSK3xayS0nafPEeCs+qk2zDDE4HBGPMWnEY1k1aBfXw=;
        b=bPp3ZYdTXmuZ9BmP2kJeMVXrceihrqoS9xpsbkHs5sjhL3bsQE/WzOq5gV1v4jYv2e
         2aecoZS8TuFt7hbr238clglpCrQ3qRj5vrKeNT8jOveese52R2fYPQ/7Wo3+R7B1/QMX
         5ELQJH7bYick9IQeBZXEQMJEOiiiaWDlCaHVFlM682zvoI80iIdiiviSv++KojAkJ9Og
         yVAdnZa1kReRa7I3LYbyfae49jpmfzkFbL5Lhfo/remdAA0hoF0zPicGkCA7HsGT5iSK
         Ya2KaGcS+JGZP2W2o28wa1DHxvBFOp9CDqNcg33Y0DLZGOg2GPaGmS/s5KPLVYOcu2nS
         TT+w==
X-Forwarded-Encrypted: i=1; AJvYcCWhps6+AawJKgdJsoUvs43+SWAoYmvwcr95Wxa8W5GvwvKF7FWbVk9zHHM4+APnN0e1L8EIDgR9yA==@kvack.org
X-Gm-Message-State: AOJu0YygLuIGlebbaY6PAHjTgVBT9T16ZW8JdiPH67dYipyMKMomk8AE
	FxRSO9o36JvBBYzpkx9KMyD9GRERVSCA7eRCWIb2hJfFESzGGKzjO0BD
X-Gm-Gg: ASbGncul689Ctk2OGuZ0FxInF4KPpACBkVkbcZ4opPsTj9UlbVeCgYCBK2W69VAmyoI
	tc04LPdggP8B7V5/5wx9HTh0aFoPkIb8tfdVK+r2RtqWiohCsDlHLy/3Fgk8KtwfKvoZHDN5cIZ
	G7MfBF3k3/dkN3tHNdFSQ5XMsxbM/fYE5wIRIY3V8ScJGDMH7uPraveSRNj7keqyypFxQdPHnk1
	P160D+kRJlCb/b9b/ZXD1SK093H+KFEyEynvIEuIbi86+JUx8ysaxgqpSlcHppst7zx5ZpQC90b
	pZ8Sw6wp/HSqhbgYJDvpAa4SFscUd781/c1O1wbGVQ7sTRzNoAkB+DFGtBj1LucMltWNsLEcK1v
	syNamAFDmg9mps9NMZHNmp/O2xhsQnvoZ7yYZ7k5J+y3o+0gaoUNvB9lUG6T9TKw40NyQpC9bzF
	bja//lItFafUmrE9ZWYu2AdLs=
X-Google-Smtp-Source: AGHT+IHJHzJfJKSauriL7OPkevf//sVckJLTHFgqvaZTWYLp0JaZgp87Bhu+TeYvdzgl9+yv9HKXcQ==
X-Received: by 2002:a17:903:faf:b0:27e:f201:ec94 with SMTP id d9443c01a7336-27ef201f0bcmr18530145ad.18.1758879273495;
        Fri, 26 Sep 2025 02:34:33 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:32 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 05/12] mm: thp: decouple THP allocation between swap and page fault paths
Date: Fri, 26 Sep 2025 17:33:36 +0800
Message-Id: <20250926093343.1000-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91F131A0004
X-Stat-Signature: fzacah4ptmj61x97ah7mhj84iweoq1md
X-Rspam-User: 
X-HE-Tag: 1758879274-923876
X-HE-Meta: U2FsdGVkX1/s/nex86ryqaczHMIejhiAhPvIf2i5EJR4pFBIUmJNINft6NB4oIrLj0HoCgJdUDW3xtS0/+Qd4Orv/ktDh7ZUOjVGkJ8lSqM/zhAdCTHfcRLYeZt47Zw6hZuVcv9fZIFRqwwVcuRYJeQM+9vRxyQLpnUawhr0vp277C9czCWbfuoXk9dXoa3ztrQqV5uAxVy0/jKPWO1pDpAlDrMYuOEzlEND3wHvG9AZ03cmwZyMVydHG7SyITwNmCB17KpT5z2ucNSfTs7ZQUmH+dybmgTbwo+lJFPVM63Rw+RTzDU9PL/oQ9N2G5K1OgDVOsy6JsbLKkPUNh6SHB7T8z3og/TWL5TsjY52g2iz3PvfwaGLjiNvwbw1QYH6VEPA8HuidS5fZTjT4ilzqMNfOFnZAKaDFafW/ugkY0RYlUW0clXaGjqyTyjviMrWfJifK+hJa29jUYB3EBPDnWPIHIITH9QdKDZ7dbwbiL/bAgfB60Y44chhhJU4dJ+h3/CV6xvLHin5bgU7MjmGj+hwVYIJ+e33KEYjPl9SBV2yhVZf7QqUsuznXhEzMPcUIGcXDVR0Eg/LS//M2vn9o7wqbPNcXzqQzXvuaA3XaHlMuZPfdyBkJaEsVOvpcKXT8Si4sA6DlB6gQe3/O7+jpsF2KXwJSPZj1+uDDHUOSArwdzIjrScFaToyTY2wyF+vAHgK2Q6cXEvOW+u5VQ9rtQl7PQ33orAbZ3FCnJmDNoYDGBsFMO30TvPdTUgb3piU8fbnik5pf7o/U/VhvxGYGZt52o9QIrNvBn367iEN1nS5kkEejnmwRVQBC7Ihugw7vLc8VaBCjB+OyXxHeZSTqyExh/tuqeTWvfVhT1VCvjceUjcrQRoDbVfYQoVboQhalroX8LUJKOX6FtvIaB2GIN6oI9rA7og/dxDCaDaMS4wHx9ug5/PyhQIVegB4nOFVCD1B5mXBAgJY9uLuWB9
 p3Ep311Y
 ZTYPyXucUjeOUPqKKd1wW2A+xuLVEPzMs7dgkR/HgWWFhnKYamgiZzmACqZ4fSf4apFZwE/tPJzf3zTxCpNUD0cEzUfW7wX2B2L4gk/Tte+OVxUsGhFQ/HfXFoZkd76FKyhuaOl0EXmANecR6qDT+GX1iKnudtlGUaOdZ+qVzG5b5DuCl+Hw6rQrXysHNUidYOoMChNTi+YIf5RMJFmltwvDIIyNg+G29p+wWSSwMolascxB7M8nr/Fhs9O3Pbbe2YToIe2oeIbWh+om0Z5F1SC1fI7rau6EDT4u1VCdpXKu/mylHfBgF+53350HGJhdoP9CprMvWipbmNYMyuh0iTFj0TAw9Nrx0j8vqpNC+heUAYQDly2rJkSXxq5Owfvez5reNNSo+TOycb6qhnn+PiRBSJd+E4qSzCiT2pQsOazaCC5QogUXBMCw/CZW9p5FRK5d1iegUJXX16X2EgVKwyMtq0ZJ4AOlxyYX9SzgFNJOm2+vAJjyq1FiHWSW34PCVnFdlHvmiyZg5k305eAiocLX6yItjLltrMKRrmZP06RodGQ2TZy1asN4sIcwYfzAYqTqTXbQdVyR/G3dZY9NH4d5LUlfBRbGVjeOoLgr+q4NY/pQ5Dez8r6oAyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new BPF capability enables finer-grained THP policy decisions by
introducing separate handling for swap faults versus normal page faults.

As highlighted by Barry:

  We’ve observed that swapping in large folios can lead to more
  swap thrashing for some workloads- e.g. kernel build. Consequently,
  some workloads might prefer swapping in smaller folios than those
  allocated by alloc_anon_folio().

While prtcl() could potentially be extended to leverage this new policy,
doing so would require modifications to the uAPI.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <21cnbao@gmail.com>
---
 include/linux/huge_mm.h | 3 ++-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index fea94c059bed..bd30694f6a9c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -97,9 +97,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
-	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_PAGEFAULT,		/* Serving a non-swap page fault. */
 	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+	TVA_SWAP_PAGEFAULT,	/* serving a swap page fault. */
 };
 
 #define thp_vma_allowable_order(vma, type, order) \
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1ac476fe6dc5..08372dfcb41a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -102,7 +102,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long orders)
 {
 	const bool smaps = type == TVA_SMAPS;
-	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool in_pf = (type == TVA_PAGEFAULT || type == TVA_SWAP_PAGEFAULT);
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 	vm_flags_t vm_flags = vma->vm_flags;
diff --git a/mm/memory.c b/mm/memory.c
index cd04e4894725..58ea0f93f79e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_SWAP_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
-- 
2.47.3


