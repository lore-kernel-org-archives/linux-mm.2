Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E5460A6F75
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dt25Ba+/
Received: by kanga.kvack.org (Postfix)
	id E9BF86B05C8; Tue, 17 Nov 2026 08:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25F36B05C9; Tue, 17 Nov 2026 08:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13A16B05CA; Tue, 17 Nov 2026 08:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEE9E6B05C8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48D80160432
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:23 +0000 (UTC)
X-FDA: 85444637166.01.00FB92C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C59C140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dt25Ba+/";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920841;
	b=wzZg8phpFWaCMOG+u0b2JKDasdXIUX+jFZ+cSDnon6BlZDtnWWscR7XHu/E65sN5jt4Z1C
	OrCLmjImUbahg2vz+nwCu69sdXhhqK8Vc9HIeUrOjzSFvFEkynGr3chkIo17mTnmYow77H
	UQjRlhU6CHlqnMJE9Dp3AwlaV4UQUsg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dt25Ba+/";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqGa1GEvMVM4CUAHQZQ4hNfpxe8V705FHjpxYKPLcQE=;
	b=qTQ7LGUCCNc+59P5aU2VWIz6Z20TRFTV4rYapqRrclpsSHsGEgXW9jjLG7+vvqvvFK8p8v
	EVffy75upv93gvwhSU/vn+xrIU+8AQA/OOXU7n7kYZEyt5ntTJlDcSmySvGvlgydJyxH/8
	E9yg2e+32J6ltoMp++QAL81L2Qn5O/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F77A6347C;
	Tue, 17 Nov 2026 13:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0BE1F000C6;
	Tue, 17 Nov 2026 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920841;
	bh=DqGa1GEvMVM4CUAHQZQ4hNfpxe8V705FHjpxYKPLcQE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dt25Ba+/d3PdJXh1Je/uB2LSw98YGFMW+Q+U4uVkA9E5Z2DHBmURph3zRvJU/T9GI
	 ZzY1FqVTo1vZXhKm8RazcA8XSvCe7TqycChOfMER1kzKYA2ocX9AQ5+dUpBImmn8j3
	 V+ykP7ihIjjgmJ+zgdsKJ0y3B3k6AXs/l9FDMuup1H68HpOMW1zlL3a0ZU+5VLfAiS
	 ECat5yJQADnDFpDtXwy01MyNZNQA0hpylmEUd4eCqnVS3+s9MTgbjEX7eO9ZmmhqNO
	 9QerUrcxmqbzqaw096lpJO1lhqH/PRWd7JTkT1nNWcOaeiMustWRobLwM334s+ZqT9
	 l6yRLZjUPg2/g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:59 +0200
Subject: [PATCH v2 07/14] s390/sclp: Replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-7-e518c99622c6@kernel.org>
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
X-Stat-Signature: st68ephtp8tzzuy4i3ko6j6c3cagiifk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C59C140003
X-HE-Tag: 1794920841-84794
X-HE-Meta: U2FsdGVkX18avaFu8rYXPRtFsp+APadiVUNK9WcrHW7wFSMZ/95hKEqmtu2mxDIiDKBKZWVB2QDgRiGPe+CpPMiI+ZSboBM4o6fCHdAnQ2P5P0k1JjUBYIHia4jrFm6VXACNfcm/u/Z80idfw3ypMFVOLc4kttbz6NderfU0Hnrdk0jKEUAGGte6vpqeNvENbrebMR1N/RD0e+I4Mr3AZ5EtnQ2nXjiMavnJacILCHPm+C2bcf2HugbxvYczIho3DXj5hA57onuyivq6BCzHnV6+r6oHpkdK6x0X80fmrjEJ1GcQu43fjIpNtmJJFOXl2WShb7PNz6bg0sdMdC6pGCaZvIOknroWHiDkl/x8Oc22hOfxyzQpbjjFGay45yd3LWQLZtxqhOa8mrhJeH701oZwgHnVSR02HKNdnXfp7GcTl8etT1HmEpjr+4jyf85J6O0JyDY8lahEcGyi+UKhG8w59ezjGXLPwpekmtYFxRxgTn1+La72lkEDFcjCbHiNmICI6t89h6OjX7bcHD7pCCHxRr1aZ/cIHQSBfDVLljNZMRLFjIlHotZ4PMKHi9ztito59Z5K+P42lGd4LnEDlbl2wo/3PFr3oXq3wUWimQqzmwlKR+nPbsc4M+R6x2ZopkY6XigC5+vxutT1ZPKaXth+RTaO7sHlWerNZeweLIrGX2JymnM7p8+4pfBX2o6chmc8c5A7c/2rzRhGakOf9NBy+sLhq+ICL1Vcz2Q6xxlAcdEz/lFOv8xKbRKVU0YIw9L3GdMsH7TwrLPbcot4cQQdhwfrclD9v1DMBxIgOUXE2VQvgZ6AiCs9W+QqmghuKFVAmdq3xoKxOTN/Z0q6pbE9dem4PnDVTaPwstdfr/rIt+YJMV90Q3mSrAhqnUDGbNZRMJTP6ZBdulBdDhkKLyQN4BrFYGFkAGNuqvlE8orOMVSlnsRsq2v+TXzPaHvZ4tq3DyGuTngV3/LXMZv
 XGtU/px5
 cvBKwBSFfCAVJZqyhkpC3/gcWOTz2lBqg5UTPOfm7fiy8U+ythay0PXhA3/9ZK8o1aqOiGDjtiGWx8PII+WQ04ZdPYXxlO/8paKbVxYxR4Q8SjWs2qhLQuz4xraxrpJVFtvgdUlcnEIZ95r51/UrDUMxAGoJMns0BjTdhdeXfkkp2k6rpC90O8XAsRLfpJ7PycWKnT/vVsctmA80emU5XsYHypV8zHEFfKIFwvSnWdyu3/sNjMbDOpbTi2sqyKzMJcbCgmIabpbzveLv2skHNPFDMpyIEr9OwZ3tpvm1BXWxezaP1gFrjZW6EZ3L5g35asXVBPHetVz141rxl3kVIYfJxqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_init() allocates the SCCBs used for reading SCLP events and for
the SCLP init mask request.

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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 98e334724a62..bfbac6dfa053 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -20,6 +20,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include <asm/irq.h>
 #include <asm/debug.h>
@@ -1268,8 +1269,8 @@ int sclp_init(void)
 	if (sclp_init_state != sclp_init_state_uninitialized)
 		goto fail_unlock;
 	sclp_init_state = sclp_init_state_initializing;
-	sclp_read_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
-	sclp_init_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
+	sclp_read_sccb = kmalloc(PAGE_SIZE, GFP_ATOMIC | GFP_DMA);
+	sclp_init_sccb = kmalloc(PAGE_SIZE, GFP_ATOMIC | GFP_DMA);
 	BUG_ON(!sclp_read_sccb || !sclp_init_sccb);
 	/* Set up variables */
 	list_add(&sclp_state_change_event.list, &sclp_reg_list);
@@ -1302,8 +1303,8 @@ int sclp_init(void)
 fail_init_state_uninitialized:
 	list_del(&sclp_state_change_event.list);
 	sclp_init_state = sclp_init_state_uninitialized;
-	free_page((unsigned long) sclp_read_sccb);
-	free_page((unsigned long) sclp_init_sccb);
+	kfree(sclp_read_sccb);
+	kfree(sclp_init_sccb);
 fail_unlock:
 	spin_unlock_irqrestore(&sclp_lock, flags);
 	return rc;

-- 
2.53.0


