Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A16606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7sKL3ij
Received: by kanga.kvack.org (Postfix)
	id 547916B05B1; Sun,  8 Nov 2026 03:49:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F95F6B05B5; Sun,  8 Nov 2026 03:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4389A6B05BA; Sun,  8 Nov 2026 03:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E82C6B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CBEC804E9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:10 +0000 (UTC)
X-FDA: 85411327260.18.B9727B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E142E1C0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7sKL3ij;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vCF5k78rkiAQGJjEpE8px/2xJwLOSb14zi+Ub19SbU=;
	b=KiX0eKM23JNUvMao5D2n7V60xxA56mdyf7WgzcMqxJICEBmmMMIR8UAbqdRjeL4Ha+Aqnj
	Bxk34ezV72wUR+mpqdNuYwQApmoqNdMRQR6Zq34X+wdxs64yBG90k+2ORBjwCI/6OQ8/s9
	F5zc61NUgdzqvwjVXtfD8TyR5mTHOqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127749;
	b=VFyyIlvI29SWp47IUIu904U1SkYcFlhfvFE0s5JPpUZWLmvM4w70ezfpMeB76i9CcxaAxK
	oIqE6uAhWexJlWVHXKvire1fWadB+Bbfs8t3HyHQ38v8C9EqLxrfIuFzGHawTmFkiMVrfL
	hdnNZilXQW6Ef9HNSWSxKcpx1pdYnkQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7sKL3ij;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4049540B35;
	Sun,  8 Nov 2026 08:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E151F008A1;
	Sun,  8 Nov 2026 08:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127748;
	bh=9vCF5k78rkiAQGJjEpE8px/2xJwLOSb14zi+Ub19SbU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m7sKL3ijuMxiCN4KBljYFZ4jfDx+8OwrmAzhjpzdOxERJ5fhUwGeGoaN28nsVVx5d
	 M0Gh1a7ABrwYOrUh4ZIFHfUnB6vPmYrVaRa5nghTSf8i3sHnwHIJ4LjFFQVYGlDPXk
	 A1AiuYKdUw/GULPXZfb69YhWrQxyrgQnPCthHkx53FdjGQjvHHjdu5MmR540QVQDuU
	 i93q1Pl3aWsLWnRCWcsXaQiyaH/uFIBGb8QoNm7qyL93gBF+4kVRkE7fygLRGnjDsL
	 gWN4tne3+Fx9t0iQ7SONlmf7NJHPquOjLTfOpWexeJOkxxvyf9WBCwtCsLW8ZUfWV6
	 zKDeEbDYvKruQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:48:58 +0200
Subject: [PATCH 1/5] s390/zcore: Replace __get_free_page() with kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-char-ready-v1-1-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: k1i7qcjntuuahor1z5b84esrcm3yteps
X-Rspamd-Queue-Id: E142E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127748-625433
X-HE-Meta: U2FsdGVkX1+XpHJwoq41px5TL5hJzdwXpHZD9StLyZ9OgC7ln19TqYJ2uCj75TcEwNlgMY4miqsov86XRgZkTlcuMce+d8HQY+SfNzX8Rj5OlW0CAh1x5rAu7YLF/8aa8SCW7T6Mt2k8ubk6l8JRBrQkAhq1WtgJYPz2ywVKr6It/sa3lluaiZiIjjIi4NdAWn1lwnRhjzLdQhqfWF8wb41k8+jmxRifwX8267KQQX6DvmzrJ4W02iR+0LEgVcFHp3ddfLi0IIY0zxBDfBFbhFPEWfrbmT0WOLpxK1UZP/TSyCmaPPoyE+xTdglFdUzsldqU3GtKWfTqiZYb3TERLCFhva1chkAoLop4o0JYylBTjiSklH6G8SlWUdGDMOhPmaxwV3cnX1yDLJ+ChyxasY5ZecJBSQLjrZr/9sDh3D/051AdiFWBH5JDwR9WeX7w8JHDmghpWKNZbPjnmTdCn/nFIkB6rHgUsh0IzFITe01Ozv0Aavvr/CjRinVRSVgGwmU/SmvnUaGpTO1etnIRv4V5nDhY3EJQiuMaOSyAXhZKz0KCsOHEC6DgQ9M4i3aSchXS0tyCdkfordFJYCApSyUOqtkJzoico+Wlirv/AJs+pIBtTDqL2o6jSZ/ZVij0OJ2AE+fSexXPnouPga4TetObsqs8N+GvwUTNjtUt44Gk19Oewy/uHeqPb0kOIzFJGY4O+NwKleaKjfWRHtA+ayx6SJEtJMAuVyUSvXwoqNa6H5+I3DRKVlda7h4iJRrVfsx9NpotDzGg4aTSBD1XmYmpKitw2xqidiMiQaH8lcNV9Q6Pe6CYpBLsdaKccngIkRe0DDIZKmCS7Vn7igHorGjht6rplyDalroyqFUMPBVrzjyZLdtIxVMoeXWCTfHVLF57HhQCcouMuPGefekOaS9N7J2PT52h8WoF5zRsOeMx4rL1u6kFMORX5zebmPXfChRGM6ekj4yHvIwe43/
 Xb2lxsKt
 nxOttPwxOetFBB4q5ywNhCn4fXHvrtYOS5Yj6IRaCHsyer9/gNGnCoPxFfR0f/az/fKw3qhfAymLTU63rtB06WuCYw7z7uYRUJ1SxipcIpd89/jpgR9DHBxIBIGxWZn7pllyYqohVSO6n9pmHEmliLZdEtfXfi1wly8B2AJcGddxn4joqUfYzUeWIXxKRFfPcnHC9O4uH67cV5NXZ5csnfjhqkewXlFl1Ov8B2WMHHKPZAkxvlqC91aL3Ty1xephyHvQna11+UCrbQJvadrynPxdRVDeOJaCk64VCINmpXi7pKIyRINUzwqkU5GmVpMZ7c4tw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zcore_reipl_init() allocates buffers that keep a copy of the IPL block
and of the OS info structure of the crashed system.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/zcore.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 1ab7400a3c10f..92e31a8a7f242 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -224,7 +224,7 @@ static int __init zcore_reipl_init(void)
 		return rc;
 	if (ipib_info.ipib == 0)
 		return 0;
-	zcore_ipl_block = (void *) __get_free_page(GFP_KERNEL);
+	zcore_ipl_block = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!zcore_ipl_block)
 		return -ENOMEM;
 	if (ipib_info.ipib < sclp.hsa_size)
@@ -235,7 +235,7 @@ static int __init zcore_reipl_init(void)
 	if (rc || (__force u32)csum_partial(zcore_ipl_block, zcore_ipl_block->hdr.len, 0) !=
 	    ipib_info.checksum) {
 		TRACE("Checksum does not match\n");
-		free_page((unsigned long) zcore_ipl_block);
+		kfree(zcore_ipl_block);
 		zcore_ipl_block = NULL;
 	}
 	/*
@@ -244,7 +244,7 @@ static int __init zcore_reipl_init(void)
 	 * to continue dump processing, considering that os_info could be
 	 * corrupted on the panicked system.
 	 */
-	os_info = (void *)__get_free_page(GFP_KERNEL);
+	os_info = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!os_info)
 		return -ENOMEM;
 	rc = memcpy_hsa_kernel(&os_info_addr, __LC_OS_INFO, sizeof(os_info_addr));
@@ -266,7 +266,7 @@ static int __init zcore_reipl_init(void)
 			os_info_flags = 0;
 	}
 out:
-	free_page((unsigned long)os_info);
+	kfree(os_info);
 	return 0;
 }
 

-- 
2.53.0


