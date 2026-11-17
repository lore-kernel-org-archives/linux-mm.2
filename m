Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0386E606AF65
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEgEUYus
Received: by kanga.kvack.org (Postfix)
	id C78DC6B05CE; Tue, 17 Nov 2026 08:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50456B05CF; Tue, 17 Nov 2026 08:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66806B05D1; Tue, 17 Nov 2026 08:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90EE06B05CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19A6E4042F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:32 +0000 (UTC)
X-FDA: 85444637544.25.3701737
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65C2B40007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VEgEUYus;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oTcbpI93ALmImptUja7T0f81+Fa7+2y1/1yBg80QEU=;
	b=KUno8AwGMmSuVOtvhvKn8d5oB/hBOysyY6iAynOPGg3d8dBACVOyu6mlwFbpGDHBDk966u
	hP31OT/LzmQS5JWEzD6a9gAuJtYICOnLLkQ1/MpNuVIxzPKIbZ3FqgQ5tty6d+ktKfSyAn
	rfq/qAPJmPfT4n86vDuwzkGbRw7wGDA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VEgEUYus;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920850;
	b=BB2I4Jfh3u9Ox5VD/NsCIXLAjaUz8Mp5VdQDWFJNMFLL3YZyV87hLKkfTnBR/6yWHCh+XO
	6iGKZ8gCX8QmQAQdKxizN9otfQnkxhr6at1YKeZsFJYdovp3HHAWhznooLHYoxCCry3Sp+
	kgWKAwcDcOaqVWOzOGdjVbxbeCQRw2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B941944635;
	Tue, 17 Nov 2026 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCE01F000C5;
	Tue, 17 Nov 2026 13:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920849;
	bh=3oTcbpI93ALmImptUja7T0f81+Fa7+2y1/1yBg80QEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VEgEUYusMfaBiL9V0jDqhE0cP1U4Va32n3mTGLAUJlBGLRG0RK7PCQOh85U6VD9BD
	 tX9/D0ecLRYyYdXHN1K6kvoGits0UcNP7FCjj8AXUDTu2Ur28dzIifK7pehSgnriUs
	 CYRskeZhsg00pQ96u1PWgrM7U3eIjwW+xV2OkRPs8kvJfvTCGtHWLfx5BHJmIMGRJ7
	 FviYP7E+bQCI05ts6keR3CYw11s/vwxa5HNAwEj+Urmx1Oo4+bqtJaktd9tjvU24L8
	 wI72hSoe9bAXXcZDDRBHS+mAMK3thU4h9eYjOA1G/99CuHIhTP68UJFZEhB8T+CkUU
	 7vk+e7LzkDr8w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:02 +0200
Subject: [PATCH v2 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-10-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: 65C2B40007
X-Rspam-User: 
X-Stat-Signature: kzj6yzd1s5zh64wqbrnsdtqx9ddb4uz6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794920850-666665
X-HE-Meta: U2FsdGVkX19xUd69isb0uDSroub4crur3yEDQAYNzPeJzz8YOE69ni3t7/5n8VsqvGmStoY2QBCpuiOxUl2mbqYUholP/VV1qDvdEA+oBlmhe014Il83dNHZcE1ghKt4YDyMGL7x7NlzogsGv52EHaUr1ID8+L2Rzj+wsIte0UMt03VyW9m6uhSXF5EPBPQnkXOyKy2Ra+CSxjfWOGQTDbJuEtQaFJSrXWeNsfYCf53KFnruGsVb1QDqywHQtzmrY/ho0jQR4PS1ckkwuJmfKwn6SeJekLD91ptcf0PM0zQ8A2a4BESSBbZFUvPyNlELtgeygfE3c2SWpVqJIwRqFp7NV0L05yy9H7vU8Rlz4wVyNFkUjaypeEktB7EANhDLPjf8GS5xxE5hwz8LTsNAdV8/ZSvzSROK04AF5Ya1Vd6zcZiqWRybMg72ZR5tR7RhspYtT6RjSNMyUFFGiTW8WS4N/R/KP5vWxm9e21aaaLaT2Vioubhsldi7hw1b1DWiQIkhk4+7OuU2h0G6fuK7A2Is5IZW1QNV24719AWgoSA+hIGnJFzPX0uLk7fMLG3tUgv/vQ+2iWiWhlYuVh2UxsmW4/xpUxwVow6EwkCRkLT1V2rjGL4+qwQFxoLKIKjXEYvRwmdaREg+hp3VkOkxzyOuFdL60IHaxNXhAKohJoory9E5FfQIwT7PzJCJ4wzps4YUAGU2J9YP0SgtY81WnDE5a3imF/y2j+QnqGADpE7CsB44kRPQHpmzRxXDfZQ4o4G6TLyvMuL1n0F7Pa5p1Ga0E2cWnhNAGgwUSTWm4KZb1MN/cfo9t/JoU6c2xe2o1ITOQDv8B+DINjzdtiVT63P99H/wf3/jEOEGcHEMjM9IwIsbfmzWYTfavM33PLeS+KXORFaT09LOVgyum8F6phr3pk30me5s9dd9oVa7J18VbocLhw+Uq4UkOBbnNo/bsS2YWmkC2Paa5VXBvpA
 BpR9HOJA
 9vyad9iuiz7xHkgN+lnYA80jfa6oHHrO79o1cM3r6Aqe5dDHsscggAtqC90MJJxiUj/v6cPqeA1ZYdiAOtqAk2Id8Zkvfaajd2mlFbj8qoiX+4dOshdAfNCZguWijBHlrVQrpVqbxa99x9RhbmEwtwi2pa+e6PRbPj6B4oAwDxUBAU2+QqF5LPcEC0dVLuJG4WaH3DftHZ8J9SsePaUCNujPg7LLAW8s+jR0wghIteJsuWOjUVaCFGdyb5hspxUBJlVT8xyJADuClaHE9zou/e0ly0GAIxvdKUoTt4ks5SSvzgWGqO+cuaad6Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

_sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
allocate the SCCBs used to read the CPU information, to configure a
channel path and to read the channel path information.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Keep a power of two size for the SCCB in _sclp_get_core_info() so that
kmalloc() returns a page aligned buffer.

Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
and free_page[s]() with kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_cmd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 1dc93d945be6..9f70f67049e4 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -102,7 +102,8 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 		return -EOPNOTSUPP;
 
 	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
-	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
+	/* the SCCB must be page aligned, hence power of two size */
+	sccb = kzalloc(PAGE_SIZE << get_order(length), GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = length;
@@ -119,7 +120,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	free_pages((unsigned long)sccb, get_order(length));
+	kfree(sccb);
 	return rc;
 }
 
@@ -173,7 +174,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 
 	if (!SCLP_HAS_CHP_RECONFIG)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_cfg_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
@@ -193,7 +194,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -236,7 +237,7 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 
 	if (!SCLP_HAS_CHP_INFO)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_info_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
@@ -253,6 +254,6 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 	memcpy(info->standby, sccb->standby, SCLP_CHP_INFO_MASK_SIZE);
 	memcpy(info->configured, sccb->configured, SCLP_CHP_INFO_MASK_SIZE);
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }

-- 
2.53.0


