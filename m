Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4869E606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1Cj7oxG
Received: by kanga.kvack.org (Postfix)
	id 587926B05C8; Sun,  8 Nov 2026 04:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513D06B05C9; Sun,  8 Nov 2026 04:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C616B05CA; Sun,  8 Nov 2026 04:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 110EA6B05C8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:05:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75005A8040
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:05 +0000 (UTC)
X-FDA: 85411367370.16.D416BBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B8C3740006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Cj7oxG;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgwy2sLBhkZKtiaNvP4HpJ9fzTrVK7TDxZafS5632ec=;
	b=B3MATBoUI1CxNJI2d08l9pdoGbhcCaFVVyvKySJ8tQz8VzigajdEwmqrxVQrD5Y2ehRzHm
	gpT1bcAQHEDy0VAsCrzBF4Tqg4ar2OdMlzvrWHZL/4ZUOtK2QUt/w7Q4nIo+ewZEPNp1S+
	NdR5vxjnrx/UEbD4jeUgTz26sOX1b+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128703;
	b=bYko0Q4xUHg1XP1f6OTaocpKdOaTP+9oi5NFfxX6V7fLuq2zWVC5dpUC0DJUavIVVIbQus
	UXqNvhV/vH9vAiITHd+GHQqgB3yb59xuibHrW/q0A5AapIeYwr8Nwvswr0JRzj4fLIFeYT
	PRJ/+Ux3melTbTDUXguxV+tif4WckT0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Cj7oxG;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 233704383A;
	Sun,  8 Nov 2026 09:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6985D1F0089F;
	Sun,  8 Nov 2026 09:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128703;
	bh=sgwy2sLBhkZKtiaNvP4HpJ9fzTrVK7TDxZafS5632ec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q1Cj7oxGzsAhAnRq/ZhdMKBRRx/rWlaEbygQnZQSmH26OlI14AkTEH8dwlgMwJ+q0
	 K7OzN0pyEdMwTbJ+4B7NHLxClYFCbms61qVOV7JlCNy02lDKnf2yoIRo6WSPhqZnAo
	 Obqljd3Wk/Qk5EMgfnRs1acIwKigDQg2HVfA07l4ycO20UWsqYPSYeOMDi1wFbFByu
	 wZf7CzCQ0i7ljYKkGF4YGOlt15keX29CRg6bnwPwVhvxjS03sSTqnPIN8PLHCX66nD
	 b720SgkqEZZQnW08Ph+QQnEgIh6Ck260FbNWFlHkQLyi/4S277WgaGf6bTU+YW7uvF
	 T+DR3tJdCeMpw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:44 +0200
Subject: [PATCH 13/14] s390/sclp_mem: Replace page allocator calls with
 k[mz]alloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-13-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8C3740006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tubakbb5k3am4fiummrya7h3c5nsjdyr
X-Rspam-User: 
X-HE-Tag: 1794128703-251865
X-HE-Meta: U2FsdGVkX1+VQkX6ZXSrqYe+f6vpjk/E9EOsLDo7EigDVhkm5WS/usaD9Ri4zgTCSM4KEfsdwE6y5XUqXXdUmzk0LEPUTYUAmvPNaFETzjB9vvC+Lj3xPIH9sGoULWdga08G+5zzoiIWyFP8saNl159vxp5SIjPEMk+Wz8PEOnFJLtRSQqjsWiUlkk2wVeOJadd9ouA0sw1rOxqRPUms/gWiilhKV+HG5rIoiD13ij5vMEcgm4tYvEPaP2gan+jplu8/K5x7JY6rZOHv2mFYiOhUGH5E3lUSGEIOo6uDMIzb50xD111Up6X5Fea66da9KOucjNYyaNuQoLDez8X8vzl+NQnWLLQUG79wuWRhFwo8N+eIuqkkD7yCcRt4+uJomnme1OxdSG3rYhdBg8/A79m8gTGnB7/oJ4KwVKHiiHO1pkJ9BxAMJmATliUhHUFYF4AlHtQwxg0icOfU2SansbVsHmEzM7bmGpLhQECioYmqknBb+15Mgek3PaieeqpQayuDopUGwV0FUH/sjnNBzGpIsmXgNJZ+52YWJEu/nzcFyZEGMjY32NNAPVvJH690XF91k/+w2SOtG6UsGoDTT4eW6h19zzvfPhZVdEMVFCprax0CrPqRAbiF5rRWcNS50ouZyJ9l0XM7tSLAKY9+EkkVnEArTC/YfxRXb8Ru2Z0pp539TWvyshxUJvWg+rorYWcXvNffpasswDJT4ERqlyj0/Kg6b+Z6NchpIVlrywNP1ZM+fOFVZfhwnP6DuCv4pPG4iR77XRxQYZY+neB5FKebP+AIxXsbdDWcFHBaGPbRgRDDyUy8sXDqOM8FECvTsHQDwDIKyWdJgLDWTK0EEqZrI72AVVltUscWjQmlZCGo2myCay1FzBTZroRCK2osE+ZfNE+TT1e4xu0fqav8O4DIy0MnVeylAJtMKW439XE9+S7mIjrZqaRgxI+oD9FsRXIKHS+NsBOTnqP5maV
 nwddwJbf
 /+T/Ct6my2kS88kTuU8m0J+8n4J0GLoK7dqzL91CRKu02UA/DhZRIJk20P9QVE9FuHMolcVDXgdb+IIIt9nL2N/1vnxYtHEZMKYFad3yiWwVWL0EPp5a9QA5ypu4iDuioE8tXt7EAjIk6xUBhrQ7TmJLkeSbmB1dvlr/Anp3G7NZ61EyOsKBK4AICNFoXYgpyS4Wyj6pr4RFOD1uZzwLlsAGU89vTe80zoy8hyJMzNNgEBPAg7OB3I++9+sT/cbqKm0krMw5zNezlgkVBbS4IxdVAwB5UrqCFFKq46WNrydv+1CngHNiVp2LCAx0Ho2X+PwNS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_assign_storage(), sclp_attach_storage() and sclp_setup_memory()
allocate the SCCBs used to assign, attach and query standby memory.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc(), __get_free_page() with
kmalloc() and free_page() with kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_mem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 6df1926d4c62a..c28460598d385 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -84,7 +84,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 	struct assign_storage_sccb *sccb;
 	int rc;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -103,7 +103,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -130,7 +130,7 @@ static int sclp_attach_storage(u8 id)
 	struct attach_storage_sccb *sccb;
 	int rc, i;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -152,7 +152,7 @@ static int sclp_attach_storage(u8 id)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -487,7 +487,7 @@ static int __init sclp_setup_memory(void)
 	if ((sclp.facilities & 0xe00000000000UL) != 0xe00000000000UL)
 		return 0;
 	rc = -ENOMEM;
-	sccb = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	sccb = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		goto out;
 	assigned = 0;
@@ -530,7 +530,7 @@ static int __init sclp_setup_memory(void)
 		insert_increment(0, 1, 0);
 	rc = sclp_init_mem();
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 __initcall(sclp_setup_memory);

-- 
2.53.0


