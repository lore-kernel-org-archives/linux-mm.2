Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88851CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722776B008A; Fri,  2 Oct 2026 12:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9E46B008C; Fri,  2 Oct 2026 12:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E90B6B0092; Fri,  2 Oct 2026 12:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 389BF6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:05:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C421C1207FB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:58 +0000 (UTC)
X-FDA: 85278162396.21.E3048A4
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf07.hostedemail.com (Postfix) with ESMTP id E69F84000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzc3Ubr8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjygjUBz0XR9SPSaKsPy+thYHjK1vehyXXIXm5XjrW0=;
	b=3ifHRW6ZmP3a35R9wX+NdueUF550sekuiQhezETet2MdFkaUXzcDvHbn+LE15oUj2ZmnYD
	KXz1yJVRP8x8aBR8ETwOzX2/x4zZ2OS0hH6xN83wbs0cRaVCxLiqSqgjr1gnL4bOjJ2u/h
	r4sTtzoyFLfMrn4XVh1lsr8p9W+Y4ec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzc3Ubr8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957156;
	b=utT+fh/Nre04GsAdj8U7xEoB5+r8lb+LBhqB7QxkFQPbXm9wtoPrTPLK2qle8TjbFCuxEj
	3aCptZP2ZL2Tici4grjOnCRc3E37BAB66GVBZ22Gz4IHPNq167zO0zhoupI0REWI3Yz/Gn
	XeftyeGoEU/C7+wmHhH29gQlN+wemRc=
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc74520b20bso2120059a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957156; x=1791561956; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZjygjUBz0XR9SPSaKsPy+thYHjK1vehyXXIXm5XjrW0=;
        b=fzc3Ubr8TFGn+3EofjSbYABjHms26Pti46scVX5phHH6GN8+3oDqUUhcx9xxZo1aRl
         SOGa1kC6WvJbbU0Hjw4jXTg1KRFi+gR8fUWw4T8CP3HjK5wOwKQsyFN8ue1HL7cQ4dFI
         ngErp+5lSKtMgiGNdHJC7GQiY1P7rA1nxDlbdMiY8qQhRX+gWTI3cAtUOYYF6vJghGxq
         m2a/Exz1IdkyPBvv1Go4jYlNjEhz2DnXJ5/q3bwhYf0ZoZU3YThxmfkO6Ab5pIAvIx9l
         HG8HLzPSWnn4bjq1LUTZnet65KziM4umebzdSJucEns00L5mbZ950EM/ldzlKN+mRhg2
         YXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957156; x=1791561956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZjygjUBz0XR9SPSaKsPy+thYHjK1vehyXXIXm5XjrW0=;
        b=oTmyVz8RUZDqtSHpukaZfXY6USSPqfpF3ufrh1VCJDsAIeQfea1RSg1XJHjj+9oR1c
         sHmrdYz7A0gVQceOfHqzAT/ubR3oTRxI5NOS/7zanMk+SSrgVzqe7lqQttQLiuTOunIs
         /vO9a/5RIF2dJXkYc9jMIC/Ovsp9WoGJk2srGzkusGYoSlQiV6nXThM/APEHhJkzBH05
         pz+bA+omDgGa1UDBzWsD3V4kFGV64hoS/zJF/cxULSANdD3R9/g/KrAFT3m6v13uDS53
         lU+E0Wwh0jjSUnNGGSLCroVeBTsm1adsl55fghkZFehxFE51RsvXHAOOOzTO9oQPC4PD
         HLRQ==
X-Forwarded-Encrypted: i=1; AKwUvByTQjWl42JRF5yZlNHl88GD2rvD3FhCtq+eB+akcIE72qiPayvBarMclUKQ3xNFzZt6BbRdV1rALQ==@kvack.org
X-Gm-Message-State: AFq9FYK3FdmhRaaoTIEYU8zYnjfXuvtdgR60Wm61rnXvxCbsVpX2T7Zu
	Qjp57ewKieMK+QFxTyDwspoOpr5vFo/5Zow7npQxi9KqJpLPHsVUNrBK
X-Gm-Gg: AYBFou2D42UWPUhkvm33BY/kjy2/xGwRcWQZQj2N8GdBv5yGrxqd1U8sAuH7qQRcmwX
	dsAmWA7foG1OjIufWEBCiUKZ1fPgBfu9rkQ0AhB5w98kw7RmQBErwRFlf0kCLbUld2No2ppEby/
	zqH9orXzFY+CgWGOX/WKdGCJNjOHS5EhI6F3Wz7nHheBCOC2z3blCQLs7WzYxpOILgBp9t5ScVp
	YJinSBWYItFaZOxaXktgIqt0pCD47tvTIXqQhUAcCIyjt6kXfuLr+YGgVL/7zaAOBN39bPxQl8t
	H3JYf4K91Zm7gPWeBZhmjUgvgCKFgZp2wsFQJnbTFjjv+Z7xZaqtEjyZtSVNV3y9anAKwDU9YP4
	6VydCgD/keR9RUaYXNNdrhRikWm3YbYmm4mv3YbofzcvyhfW1VHr4pS7FECM/8YZrR0ifw+yL73
	hrfFNg9MnDCgwYcEOQfpgkQuK2nBHWCcrXN8VVTbmd6wxAOV6UkcvkJgj3dDPQ2X5fdR9VaJEDR
	SElcM2MFAOyvOk023DjcUQG
X-Received: by 2002:a17:90a:c2d0:b0:3a4:7195:ecba with SMTP id 98e67ed59e1d1-3a6ceae19b7mr1744874a91.20.1790957154464;
        Fri, 02 Oct 2026 09:05:54 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f47cb357sm9375672a91.17.2026.10.02.09.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:05:54 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH v2 1/3] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Sat,  3 Oct 2026 01:05:32 +0900
Message-ID: <20261002160535.661399-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261002160535.661399-1-ekffu200098@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yus49riu3qyciap9kppznoqbpesijb9t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E69F84000A
X-HE-Tag: 1790957156-528533
X-HE-Meta: U2FsdGVkX18bUF6PuluMTppF9HP+VPY1KqzH4nEIbBKncAbOo8fSNedyXMouCHd7ERT5G2WzHTYJoe4vZqnm8kjUVzyXdHloO6kBFcIdn9J7UM3j0Py4jHgTYzXTlMEGKaC6/xOCQKOMzJXRTfheowY4LGinm050ItyKeI5vtHUTbMQ15LcIWdy6h8geg1weX7e87U+kGUE0C/lXZdT45ynsD4DY4QF8sKRTijRWjMcjnHfRpWgpjnVAPfdn3EOCP6ydprAg8df7smQxE1vtyI4+orVTWdf6JgrnKIzz21pKx9rxjKLqPCmU0GEmUM8JjZ9hx7yxyS3iPFriMx79mVyNT/2mF+o2N7f5GcWE23JmgYFtxDEWAtD8xi053ydROD7oEB/+fREFXxrxRsBRFuGU/4gxih1ruMpZS+IWU5h4sZvBYRr77aQ7GfP+kDELwETsdjPPX+oZAkHs5/4qnvCQIeSwYHE6UFIYD+Ukr870xtD3CMOnTPbSmAtCaKYqfZslTaXDQp9qaoHhFivAla8P57oaKaAygzoaJFjyzx1p3bw/hIBxq3hGyQ00u+uDRFh8eCuh6TMbsXH/dbTkCCKoC3U4qZOWsM4lHUa4sCxS2y3mo7K7fIhOZkXaI/Guci8btX+QbmusV3L7VtXDGto8RVXxwigbhqCATW5Gw5jfGasnCiY5IsfEediX71v05U24yMHeHMQBeXDyUU1ACmagr8YJ2WE+9/6SLxjaukXMOXrVz+6mCWSTeSBrUvgGXA5BvsHnhS30/AdOEIO9ACtvfS3uOSEE8jSGkuf2eBfztLUpFeplEDxcSdjTK+xP0zS/os6na/Wb9jGMCjXlyZoe3iHTaOEl1XzuiERU06a8A9cmQ6yIcrYQxxIrTzz/6+6/eRkgQmXDNaVi29/SHxvHsw6SxAHzMCF6rBkMTpgQjovSVkbeTsHoAM2Cy+qglN3C2uw/rc+Q4mAHbh1
 YI3IOrnS
 jpBsyRA7aSdvrTg6T0KY1HqikqVZdySc+0owAJcGhCaT2+v4TtfH2BnMjObNEaI4g1MTr6y4rSimJbBVnrY9plbfBdajm8CBvbIRTkjvviWNgLIdSxW5pl2WgkTLrYB5gqTSXZBO/iFggdzQlQ5sCZGQx6p+Lpa6LeERd29MU4X7zgQVEA5rLtet1ecKR2LGSHvhkCJHDq7DqvVe7Sz9wnJHbNm4pjv3icpEjGkQX4ZK3XjBZRImhFf45hgVQgwQ2KToiyTcI3FGuHEYVd8mFEYORFmGoi769AfRuukLOG6BU8fUVyVCW1uAcYIMpHlAFE7oqZDgTRKqjUqoWGQAl77tvS8P85mdd8a2M1OUzgumwsN/Db+y6dEIS2FsDDhk3kiHUK3xmgnEBzkBCJSceg7vSpm0BpLHA/BHR3BgA1J5va3Thhq9fUeeEKKTYegVg8mWaXQvOtXfwjUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers.

So remove the function and its declaration.

The comment above the function describes the -EBUSY handling in
__vm_insert_mixed(). Move it above that check.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/mm.h |  2 --
 mm/memory.c        | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c038d06825c3..2ac734efd4ec 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 330cde31bf8b..4b2e4be28031 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3052,6 +3052,11 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
 
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	/*
+	 *  If the insertion of PTE failed because someone else already added a
+	 *  different entry in the mean time, we treat that as success as we assume
+	 *  the same entry was actually inserted.
+	 */
 	if (err < 0 && err != -EBUSY)
 		return VM_FAULT_SIGBUS;
 
@@ -3085,17 +3090,6 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_mixed);
 
-/*
- *  If the insertion of PTE failed because someone else already added a
- *  different entry in the mean time, we treat that as success as we assume
- *  the same entry was actually inserted.
- */
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, true);
-}
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
-- 
2.43.0


