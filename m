Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734711061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD2B6B00A6; Tue, 31 Mar 2026 06:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4956B00A7; Tue, 31 Mar 2026 06:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE12F6B00A8; Tue, 31 Mar 2026 06:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C09286B00A6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:08:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D1D413C160
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:10 +0000 (UTC)
X-FDA: 84605932740.08.FC90404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D55874000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXXu+cXu;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/ETYgng+YeuhIm+f4ExBrJAzglqAANeUPSmua+n/fQ=;
	b=jeH3F1wQowRjefjoEqIuWmDJcwISIvDBzY4R7OSGe5CenNL7e6psAjCPVYw55TqJs8E7Xp
	IamMnV8hhnK6htba7R9Q8LGb+CYTNpJNAUDtb3S3kv6nH/JcQxkZytKY4V74B6AZyt0Lp3
	nm6xMKb5e11lyFB6G8CmprEinh3imj0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXXu+cXu;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951688; a=rsa-sha256;
	cv=none;
	b=d7IBOj39UGuP/s2OvuOF6gexZ+eFrmL5C9fpez/Pvt/GWXlaFeRPN5ErOiUXyRhGCvIX98
	6aS7BIMnnXu7MObJBPJdHdYuXPm5tIcIb+7+KFcOa3weC90FmBF0A8f9NfzFOxWRMva5lW
	SUg4yO2IGh0fOaX8iPM1fslySY7+9HY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A8F96001A;
	Tue, 31 Mar 2026 10:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560D9C19423;
	Tue, 31 Mar 2026 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951687;
	bh=/Rxl3kL8SEbyFXYr+VYIVFkryxfMTmzHf22BJsC6y9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MXXu+cXuS62+LFUfW8BMuONZBCg7TtUHJ3uLk3V9lYiXJEoNCfqOQ1LzvoRPjlm6Y
	 GJBjMawttoaTIF0w9oEsrvTf2FLtSt+Bn/Ng+cKJO5H5S6w2UfaOm3BK83eAr1Uafx
	 54gTVGTRjDOGz0xBqhVDHlwmkcMZ3uUAomFVcjFhQ0beEkv7lrfe7J7/gYw2HSnvee
	 adimUQd+2jZL702sa8jncTusB8A44pEquNOUeLsUQ/6FQ7owGiHo7w8C44IR4J2d8D
	 3DSB1u1n9E6cWoK/zu0D+zYJR36X2kGIQx/6dW0kcCx9eGuN02JFz4R0oocyfpJtD1
	 /3HJd3aIeTLBA==
Date: Tue, 31 Mar 2026 11:08:03 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
References: <20260331073627.50010-1-ljs@kernel.org>
 <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
X-Rspam-User: 
X-Stat-Signature: n5yc5oe97yhpyywtczp6y8bo7qq74nqn
X-Rspamd-Queue-Id: D55874000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774951688-598504
X-HE-Meta: U2FsdGVkX19+hCjHq+E9qzLAoX8GfapzP3SAUH7AIM5jbq91B+Vyz3LK8LrXTSQJFERTYwt+D3DpKe5SjoXqMideo6360PVqb7OmUieaWE4gM/FI31XVX93yirPE92l1gymol7AUNpQpB+2fYVV7q1HnJUjN/MshtTDC3TUCyBsORgnKCZT0y8T6As1DU0LHCsIA1fRdVZHYX9LqRb7sFvm+KTdctANz6ZBbWPl7tXASfmIsmw2uLKyf9lX8QWicSu0Rwz4p52IXpMRTDH7Zp0XS/QHd2Isr0Xb5+Llh8YhIxKYe+oURaUHFz0u+Iv1BN9XiUASzt0XKAhWg64uGnFgeTs1JbDycRlr979AJ8Ctm0n0JyiRIxMVRVTmyABnNpS/FjeoARYSmZ7SjZMHVYikUnm+YzK/TYpWApcSCPBt6D2gx3DQ9Uu4auhw/9s4gfpd7VkKnmDz0saXK67hbtYGhXL0L6b+Gq57d+zGEAjv5oWODn4oQuLGv9+i24T4pWsqdZdtOWzG01OAouaKEy8NKnbGOQlp2hJ8JL/esi+mQcbGIky9uEH0bE25nElgjc21bbdv0sSVBWX52LqDBzH1X6b9NePth/QAdq4wCs8M9mHQcl9PLpLDqip4f1iym0aUR6TXt8Gc1UNjEfFZlI4UcQhA0VaynHp2BlKd2mny3+4SY/x5zx4/BFPwIppkNMjF+NwNsQgo0UbrSw50FV5TkXQfVlrMACU6J9a5YjCWmLz1r7kEZWr4SrY4VszdwUXQP6gjpWYedj/nD0okITMshmWoL553kt2IBdOlS21XAdrI/DRovxt/KDBeZ8hoZuBVLKI3cWWbgRID3VO8bjbBo5QAS4vBl2Vqx5uk+ffZc9vR/2jBfl4Iat6G0WlEgFd/VHrJjYhZoqOAP8GR7pbiXL1tixMIOO2sTkUdn4514deB8TTOmjEGw4lkgUhazd0ep6/7fYlVCVmsFr7v
 3Hx6Bfpt
 LH2Bu0FBvWTtGFgCouBCJinZFZNDPha68NpVltm62sx0DGdODF/dRX+BWc7MQlIxSSRwlqBtO/2PBj//GD3xjsI+IxbfEDzTA44N/k33J3k9LFa2SBMEajBcNdAisncPM4dLbWDfmdksSkUmid4VXly342ibRQRyT1hpaE/5dEQrnPCt1oyRfltimyBc9qPl9EodavddJelubNvfsWa6svI2n2XJdxTmu6My+W3LWHmADank=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Then again, and contradicting myself elsewhere on fix-patches blah blah blah,
since this is just test code, I checked the below and it works the same and
triggers the regression.

So maybe we can just apply that?

Cheers, Lorenzo

----8<----
From bcf5c7ea63961756913110694cfd34173e3f0fc4 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Tue, 31 Mar 2026 11:01:35 +0100
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index f73803b3679a..efcb100fd865 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1245,7 +1245,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 		SKIP(return, "mseal not supported, skipping.");

 	/* Map carveout. */
-	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
 			MAP_PRIVATE | MAP_ANON, -1, 0);
 	ASSERT_NE(carveout, MAP_FAILED);

@@ -1257,14 +1257,14 @@ TEST_F(merge, merge_vmas_with_mseal)
 	* |-----------|-----------|-----------|
 	*      ptr         ptr2        ptr3
 	*/
-	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
 		  MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
 		   PROT_READ | PROT_WRITE | PROT_EXEC,
 		  MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr2, MAP_FAILED);
-	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
 		  MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr3, MAP_FAILED);

@@ -1276,10 +1276,10 @@ TEST_F(merge, merge_vmas_with_mseal)
 	* |-----------|-----------|-----------|
 	*      ptr         ptr2        ptr3
 	*/
-	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);

 	/* Make first VMA mergeable upon mseal. */
-	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+	ASSERT_EQ(mprotect(ptr, page_size,
 			  PROT_READ | PROT_WRITE | PROT_EXEC), 0);
 	/*
 	* At this point we have:
@@ -1291,7 +1291,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	*
 	* Now mseal all of the VMAs.
 	*/
-	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);

 	/*
 	* We should end up with:
@@ -1303,7 +1303,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	*/
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }

 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
--
2.53.0

