Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC2760A5BFD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVUf7u3H
Received: by kanga.kvack.org (Postfix)
	id 4613F6B05C1; Tue, 17 Nov 2026 08:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412166B05C2; Tue, 17 Nov 2026 08:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302456B05C3; Tue, 17 Nov 2026 08:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBD86B05C1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F629A03AA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:14 +0000 (UTC)
X-FDA: 85444636788.22.519E36F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED10120006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVUf7u3H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K32cYhhpMABUKSCg35m/+J5/IEFf1g45r5D+/Iqjo7s=;
	b=CW1K6UcfMyJ6kcwTW21qmN+RyQUdsuhoAfhAzsRjcJs4AsBp/KgAUu/u80WegSDFZgR1ov
	4CeoG1lr85DcSLNGAgxX4t3DfYnmt2FGeuu9QplIjQ0n3JITTlLmPyX1LjUeUgzk80xtji
	srDsI2B5AzdQx+XZYlQjpWptyFac3+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVUf7u3H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920833;
	b=RbcgrOvvpe/Qball7p/VMwR6b97Ao80v+7slTSemjcfoL3EtBJup8JF0ouJeA2XSew0sZ9
	Jlt/EmsmE7PI7gjIvoARD0fbbwNSWLrWa0fwI9Z2tL5clZODocFH0pprGUczgN5rfcjdUG
	lsxTp1JDS0Mjt64kHfQMIA18xqbBHC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B4B6634DD;
	Tue, 17 Nov 2026 13:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E11F000C7;
	Tue, 17 Nov 2026 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920832;
	bh=K32cYhhpMABUKSCg35m/+J5/IEFf1g45r5D+/Iqjo7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NVUf7u3H6FYrGftOdsKYlwCrzA5Eb1yPspRj9Y8FRhAsicUQ6qxf43ABuFoIHlkvH
	 yQqkYBIs6Pnr58jFbCn9u8xpsolUSLOJhGzTdVCFCk77MSTHIuPl5hsRgbW5R8SK3g
	 ls3fx342OQHxkNMpSLnNgcC3YnEm3vbjM9qhCHECf1jDZkaGf1HxODf80EEPgHNsFo
	 7abRNRs7o5uNZ4qPqd6bzrU4rF33FHT/wjyai9uwT/FOi1wCI9vqBK1AUQ/qWQesH6
	 2a8EQmqVLQLx9a3f9hfOFvOicYAxnliCXjk1i9Sehkv8fD64ud7wrA5yDoqA2RumOj
	 MrROSM7JnkJHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:56 +0200
Subject: [PATCH v2 04/14] s390/sclp_ctl: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-4-e518c99622c6@kernel.org>
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
X-Stat-Signature: xeaewre17p81zioy14nsudnzsia9m75s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED10120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920832-923885
X-HE-Meta: U2FsdGVkX1+yNYNaxp24xpY1nwYKtpsXbdzMYpZgEpygtAtTYBFHmwCWmKb+uo4mbQDrfDxM03NzIp3Q+HZcULoLi5qc6b6pst6A3s/W/wNUEy/0tZm9dRcT+7uTUvJnEy01QTtclDpoQrzJKkXqTvk4dGoI/hPAMMLqQVkfgyf+X86Bv6KVD6MmmWo6EDm4jrXIINbK3T/I7Rj9uBMlfL1lVSzQ/wYZr0gU31yyLq133C0zxGKdg1iHXMYZwyazZzcKRhrDZ27vBJfi9uOwDH4WEblSH1Al41XEgHPTMIglmQBCXHFZ4+ETTktDvYtcoYI2jNroh3lrOULJ/0BXnusMbA6aSp+pexpw2QrbsexQSad6Pz4Yvv9B0vOxdOIKmEpcbtp3XlBbcW5bS7pwUJ1W9CZixS8vKjxbFyAPYg8EoLJdPLvuYr/WGXRrpTaVQDDVjL5LHaPvi/Pj5atnhnmgcf++E9y8xFMUqhZ+ZDySjElU4oSaaJfhAFk+UUSiyZ20HEOtxGiPJNpBFWgb+knNj2fILS30kZSVWUJyKSQayVwv2u8fZ1HaXUhpbqyYlV8EWe0QhNv8pRSuBoE45aLRuZu92uYWOSjf27hZNmMqFzSHZIWJt1ej2M4CCL9F6WDawh/4+aWk3I1m1lN3L717plh3jMdZIUjUwWR74UwyqKM6KgGyerqDPDn8ZA35P8druIRNxaXBiU5bFWhKpCCMlqbpT66GVUzYnt+yMSPKuyW0ysSox49u7NhucbEttG8BpkR+XUxgY/TlRqtf7ktTd2CLPZfFgSjDwR5KG7jq72sGSKVHeX+zuKG68v2nAFrvnY7GEnyCnFKgT70T4FfKqLJlDk6LOnhi0tX7JcCM2wPEfXZHz0bpC8WfQWtgxSRjqasIUW2xoX9Blqk1OC2F7NkgCqxddFk2AKErCLdfKMkSSaGGnCTa45xEfnuv4WB/loYjPJNLz4sB5Wq
 1XnlLiUH
 iDofDii0jSujdAAVE7bgvE1Qh2TP9DYxFy78CMaOaapDLiDSGEKLD8bAH+zo7DHDhfGivVRkS/tiSSMmxn8mwlSWbwWIpvoz3lBtNje6wcjyQcTHMJGVVAu61FlHZI6PHjOb/bBG3hLoNnzjtYs3gTD3jEhx6wj6Kh3tTFgagJe31P7o5Asuu+hLLxfiwMW2//Mi3WNEfGwRxRqPFgcnZhScZ/magB4j0Yh8ppo1wAn8/tFbjrexBkAeTkz7JToIIX3tGVZVzDcIEe/D5MxYTFSPFszRWDhK3P/SkEoZ4Lk3i1AwNzBIkMt1cQJIlImPR2iwbxDjDRdXAwMF7AAkTaQ7KfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ctl_ioctl_sccb() allocates the SCCB that carries a user supplied
SCLP command.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_ctl.c b/drivers/s390/char/sclp_ctl.c
index e23a97359286..84aefff3be98 100644
--- a/drivers/s390/char/sclp_ctl.c
+++ b/drivers/s390/char/sclp_ctl.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <linux/miscdevice.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
@@ -59,7 +60,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 		return -EFAULT;
 	if (!sclp_ctl_cmdw_supported(ctl_sccb.cmdw))
 		return -EOPNOTSUPP;
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	copied = PAGE_SIZE -
@@ -79,7 +80,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 	if (copy_to_user(u64_to_uptr(ctl_sccb.sccb), sccb, sccb->length))
 		rc = -EFAULT;
 out_free:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	return rc;
 }
 

-- 
2.53.0


