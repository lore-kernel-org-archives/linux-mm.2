Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6691D38FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C615B6B0095; Wed, 14 Jan 2026 11:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA276B0096; Wed, 14 Jan 2026 11:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABC86B0098; Wed, 14 Jan 2026 11:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 948B16B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A94016058A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:38 +0000 (UTC)
X-FDA: 84331140516.13.793FDA6
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7977840005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="I1N/mVtb";
	spf=pass (imf07.hostedemail.com: domain of 3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lp9W32Kped56Je6lvPD7Xlxv6Ozf5Aka/rllxnPof5w=;
	b=zASTzAKxFLZczxf0ueyFBEvgci0rCEiDJYuWNOrARX1CltAl+VkUKJ9981nzJ28kRTh3Ma
	1fT75BKKgOM/wwAbg4uIvorPM+x0paECmKvtoWn8RYx2PWq9uNWHehDg2xnLkIceXrkV2y
	j9Px9HX0K+JGKMM67LgMIxDy3pjMxUs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="I1N/mVtb";
	spf=pass (imf07.hostedemail.com: domain of 3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409016; a=rsa-sha256;
	cv=none;
	b=4NmtY6GzzFQZcPchHFBZDH8U91imx6IAZoRCRMJQR9k0epOwpB18+HvoeWubuzj94xejDU
	RjOCll762V4bcRL/qYoXfp44Cr9AJQYhh4m/DXBlZoFxGMjXOmJA+UeP7V+NN5EfHwJXjk
	CgWm1UU69HC/uiK/lsCcKDfcmxyzdjY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso196705e9.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409015; x=1769013815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lp9W32Kped56Je6lvPD7Xlxv6Ozf5Aka/rllxnPof5w=;
        b=I1N/mVtbk2wTCPz2pjsaOGcLMonig/fkil1A2hut1vQ5qKZnCQ7PtTyfROlqIj6pIr
         acFT/dKpNjGcZcIjH5AlCBkup72mdesh26zlT4/Y0fy7RqtJpv3UlbQiJKefeuYxTGnB
         SQ38fgHTeyvR6BlRMpdI8mfXD30Fe7NYU/YkXa0LSyjHZ5P4bsBbdPcJ6A+CI+Zo4KQH
         N8mNa8wXJ4sLTYPPdQhGJnrwOapC6R7ppapcjmIt0hota1BjlBW2CQ6OUZ9wYnSkFx1O
         St6Ivq6NDYfJeqri+BDKjA2PclnAGDCoYWhpRa18jODfI1Pz7B9e5rRULQNa1dZPq45z
         wPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409015; x=1769013815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lp9W32Kped56Je6lvPD7Xlxv6Ozf5Aka/rllxnPof5w=;
        b=IH9mezYzqKRV+X28Y0qBpjcQshtSaSfhv8gKUjwOivQl5bhPL0zfKEIo/uIkcxomME
         UBiL1rKiOr8ePzXrFRxfWOlqWlMpsozPwv7zOu9clVJ2DwQUpta1uHgskNGtiogdkQM2
         8C9TMJbIoJTLaFZcMXvkIZbcAvmZIgU8sGstT5R3mKsBop7Ca9DL7yWEit8vKHO8lnkv
         CRbGgIh4JidC5kwl11GOiWFSiiRcYsB1MaFsfkn3SGWwKtPFz1wr73nLzd/fEg2prdab
         w6Fnp3KkzsW8z7nO+Dm6tweltuZEENemfag+qUCezLYTutnctWt20VOMyyBRrMDZvPgS
         aYVQ==
X-Gm-Message-State: AOJu0YxAs7ZAZQ+l9sJMPDQT3LUYP1UeCd9qOtvUDRlB1j3HHJxwK9nh
	XRWykuc/bWpR2P+gWYebmHWDrpADgHLtOnmFf3G6CzlzgFt0nTn5JPwjZC+TnXZrb716aU19FHG
	pJTsl+ObGW5karN/Zdzd16iENvfd2wbLcjqnVSHw5XIS1N9URArX4Vrq2bSWABeSb0fTlMLMvtt
	MBv4mMJZiziKfmUmdQsA7sIJXI2kXmxQgM60TqlqTU6Q==
X-Received: from wmbd23.prod.google.com ([2002:a05:600c:58d7:b0:477:9654:b44c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5285:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47ee32e0be0mr36180785e9.1.1768409014935;
 Wed, 14 Jan 2026 08:43:34 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:22 +0000
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-6-smostafa@google.com>
Subject: [PATCH v7 5/5] iommu: debug-pagealloc: Check mapped/unmapped kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jroth1hm5roscpmhwrn8dbnmx4qxmp43
X-Rspamd-Queue-Id: 7977840005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768409016-749292
X-HE-Meta: U2FsdGVkX19k0rnk+1TXF6+G4/OM4KBR+xNqeMq+tmY6QDTFw4qjF0MpGpaDEqtZLctBRsrWmlu8zzhfTLK7BNGxlQwpOGKnAorcCz816RHeBTEUpgBq5vqi1tQFKQpITJryATJqbu1IQUPW+nUuw4KEjCD7CEupGhcMy7L0/e+4mdtqvOaf3+9bticY6n/BWNFVgiubfd055kO0GQjGdkUJ2mQICg1x4zRK2vSIvUdJzgKSIwG3uqP1n6Lg0l2f7has0uN8MqNaAYtyf8b10E55Vxa501M1JmI3cBP/JlVWA/Za2vRMWtoMLLeO1BddvnMZHtfKa1e/8k+Y9Gw4kWMcvm2YqwLVX8R04IuQExjKIbJF7BEdhSMvZiFbhueWXEzEwvCZUJqBNssI+6/Dzxcw1en9uuaXwy10GI3jo3d2wlyAwvn4ojWtqhFev3MsTQWGbZd/IL+68S+oQzEIuMVk/7Hhfpq8uk+qCFNQJYXLmUNHfdmXZIZv/5g1im3cjWM8rbzOKGO509VhyDyveMVh+WV9Yst8l3KJuO7KlVhkQ69CW7ckwsDH+fwpSMtxYI2pddbv01xlUXrEiRD01qxz2DjerXhG12XDIngtzuv6MuWDxPRXkEtIl+juwy/aalkbS19rF4c1QsHhm6MWuywxCBl/EfSvOkYeGnAnEPwUM2Pp5C6AYBG0/HodsILclq3nlvhMiAWhSjfdJOgoVtf43eVI7sdB+MgkUNsvFbmaMqUYe7wjjgODb0AElFK2zQMcG3aL2d0hJKVFowGRGmGWm6i9Jc2oGNnbcgfKWdDSkPpCAVPv3jqJI/Ng8NtVEdZk1eZbDgCLD6JIGB3gpYMQcC79Ve1Po1SvHxHNebRlTQ00vlSYwUzG/iHCX+5BlShaP9y2HnGVBc84iy+8nJVWeRFQZ0k09oIC20Q4yr1OSP6K7Xv92L+0F0WoqlDA4gmTIlWVVfsQ9ydrAEG
 33mFw4GR
 IAZs/4thUxDpYdMwgPvi3e4ryppBfgWWMRCunQGm5Ph8c7Y5IK2UlXwx3ZMGMKmYinAYpvv/5gf3Tvgog8Shrr0fk/ho1gNNtKUw4VjRDuS3SkdRGsv3kZcxC80qBNA35xpYPCCnaEp1FVWnbHmYgg+a7XUeNHipAuM2YMShOURHf/Eu0iwmdLa9+1Z5q1BgQjWqXtVGZ0hFAsphcxL8gajgoAakJA8uj6/9k9Vq7Y5RpGWYdWNQx0hlEur8K7rZ4ty6FnEIhPtJNHmaCobbRN9u0OXZf9g4w/TuXZQA2PCpPFdt0PWjoA112vgU2JR0O6g7S1MziKbEXF+QRUVMvNw0zVAvyzjYu/I8hRm9qQap7IqUr2Z4ooHns/EGFM/vWHP27lQEMRLQAH6u5hUXmrfZaUoW9FfE+DG21LOaR24ZFD1R+l729/ckjzB2f2DzKyDNwE6y0DUmStA6OcnWmPBM1tbu+0+p49TwOXwvsF9sloYrXMUlJsnzlcEEMuSVWRt33ToESyy0hDtraU9UAWTqzqcDPEmyggkucwGIW5f7u2/5SW3wLOa458+XWXAtg7pKCiK+vMwA7m1qnml+v6U9jJYhxPvMVF8CXVPi+gBhSjRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, as the page_ext holds count of IOMMU mappings, we can use it to
assert that any page allocated/freed is indeed not in the IOMMU.

The sanitizer doesn=E2=80=99t protect against mapping/unmapping during this
period. However, that=E2=80=99s less harmful as the page is not used by the
kernel.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index 3ce3385588b2..a283b5dbe26f 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -9,6 +9,7 @@
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
+#include <linux/page_owner.h>
=20
 #include "iommu-priv.h"
=20
@@ -75,6 +76,28 @@ static size_t iommu_debug_page_size(struct iommu_domain =
*domain)
 	return 1UL << __ffs(domain->pgsize_bitmap);
 }
=20
+static bool iommu_debug_page_count(const struct page *page)
+{
+	unsigned int ref;
+	struct page_ext *page_ext =3D page_ext_get(page);
+	struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
+
+	ref =3D atomic_read(&d->ref);
+	page_ext_put(page_ext);
+	return ref !=3D 0;
+}
+
+void __iommu_debug_check_unmapped(const struct page *page, int numpages)
+{
+	while (numpages--) {
+		if (WARN_ON(iommu_debug_page_count(page))) {
+			pr_warn("iommu: Detected page leak!\n");
+			dump_page_owner(page);
+		}
+		page++;
+	}
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size=
_t size)
 {
 	size_t off, end;
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-de=
bug-pagealloc.h
index a439d6815ca1..46c3c1f70150 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
=20
 extern struct page_ext_operations page_iommu_debug_ops;
=20
+void __iommu_debug_check_unmapped(const struct page *page, int numpages);
+
+static inline void iommu_debug_check_unmapped(const struct page *page, int=
 numpages)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_check_unmapped(page, numpages);
+}
+
+#else
+static inline void iommu_debug_check_unmapped(const struct page *page,
+					      int numpages)
+{
+}
+
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
=20
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..32205d2a24b2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,6 +36,7 @@
 #include <linux/rcuwait.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/iommu-debug-pagealloc.h>
=20
 struct mempolicy;
 struct anon_vma;
@@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, i=
nt numpages, int enable);
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static inline void debug_pagealloc_map_pages(struct page *page, int numpag=
es)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 1);
 }
=20
 static inline void debug_pagealloc_unmap_pages(struct page *page, int nump=
ages)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 0);
 }
--=20
2.52.0.457.g6b5491de43-goog


