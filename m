Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887DF60A2633
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFGtCt+G
Received: by kanga.kvack.org (Postfix)
	id ACDE56B0372; Fri, 23 Oct 2026 09:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5AF6B0378; Fri, 23 Oct 2026 09:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B84B6B0372; Fri, 23 Oct 2026 09:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 720AF6B0372
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:48:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73F5F140432
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:08 +0000 (UTC)
X-FDA: 85354019856.08.1B1CA75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A69EDC0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFGtCt+G;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ij0mwfZKNK/iHnKQbkQjE2lD9tsPVCKzLil0h8xoKc=;
	b=XVsAfTNKoRZObV8nYvdXrhM1bEX1P0+s4FHcVvb4z9g9eyTjlh9E63/Z9kjGhwAxofGsk1
	jtFs3lBE/DJv412/ZEy75k6gAVheZ/h60A5vkXz/oJTJ2Du7QWEfinCUBj1oWUHOmL19C2
	aih+y1R31hRgIqMeuERFnizSQIIB1gQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763286;
	b=WbweM5stzTkFEv5Oejiq26lCV6/+Laxd0sNXqMzNzhzeT4/BMR7yXNDQ9wHWGkkR7+8rby
	MAyhmeZjXVlsDBCTNddJdDPlUriRIcRSgdbndfe/SGfz4IdFyYY7EM64MpsL+Xg7elqNVn
	mQeQvtQbAXwD6HqwQGxk1mi2SjMRUoM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFGtCt+G;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4270260A62;
	Fri, 23 Oct 2026 13:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FA41F031E7;
	Fri, 23 Oct 2026 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763286;
	bh=7Ij0mwfZKNK/iHnKQbkQjE2lD9tsPVCKzLil0h8xoKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oFGtCt+GgQFOTdE3OqLHpv+WzwpO5SENfJKSSmxHTpxpGG5JcsA5xd3k8tqDqM6Uw
	 NMEOQVo5FMVjp92q6GCu5MZlOe6jB3mu6EbmeOd9LpLoFpyfEBGf8WLsmkk/dYRjMA
	 c5NjKIGX00hxSbXe79Mf/T/SW7frhQUnnXUl1V7V0rkBEBYtNd8A/aPLcuPJinwViU
	 /SIbwMBGpk9rx6TrnEAHmqm7vkOy9/c+2LthUqpseIf2GwJZLIuFBwGCqWhsWAXBby
	 2LvN/rEYWxcnEECFSUWBbY6Dw7bI8LM8CrEp3f329IUAcCc3XC/nSeqvW1dNbr0CrS
	 JsH2s8daLPerg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 14:47:29 +0100
Subject: [PATCH 3/4] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing
 anonymous names
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
In-Reply-To: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1763; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+8zMzgPcLWkBMrp2HQCx5OthBGMujXI4JiuFV5MjM6k=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJup7asPWgxuTRpFeeuyyEmfqXRK7qPdC+fXBrvdpvZi
 kOaZfWkjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwkh5OR4R7vItZTfy9nbBXN
 m7N+7kbrC9MfMfJJTSotaLjv2Dxd4yXD/9pLn/efZpO/nnLmX4vZnldH9Za6LT0qsTHLVbtX+tc
 1YW4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A69EDC0003
X-Stat-Signature: bd91nzaoyyy85q39gitwmapttiqwup1t
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792763286-585666
X-HE-Meta: U2FsdGVkX19cgUXg7WGrvbZT+6H4N+9eUZKPDR0tMhZRnnLGn/c4tKpeZMhLN7q4CLl7FR6wo0AoVocIuC4tPl6zCOWE4DMF5eMeU81BcUb4mQ/KOrZ5sbJfPE8oEfkcNPID0N28VD7/WM5XusitEQkYXhkoTbPYg0MjozhSmdH7ZG46G1BVqHXGbmM5KQfcJRqhjxMQk1Hzhr9wRzAqP5/mYKnmtC6da+F0rae5kh3MwS+Me8E9cV4PxjMAOWIfKPiMx6wQfY0sCirtd0rQCF+Ue6F0wXEI7i6OJLBM7E7a8jIGmZtcAPuD4lUPKkojOcOW/LJyQat8EpVQTQ6+1IQrW41ccViVq8bL/TTEIhdf/V21VuQcbKoVR57hOHBMgcCDhUXssfbH4zJHsfnsHtiMeu4xg3kz8s39vPWGEng/20nxw1FpaxJFRZ7sDATtgHZs5jjJ6yk3SMOdVnKUXKYvq5zk/9s9CZJmKDjElmwAOu/l+3Wh4D2tCe07gCG1lozleBIYv8YnUoqoXmepOiQswOxuvU8BHSnEoIeduDeK4zHeRHNabAfI/uoW+FQcp7A+AVQJBQEVVDjC9Jjw/j/447imDGYmzuKw/EJY6mitUFaQfIHRs23+sulBB4rSGOa105wFb7Fy38KbFFkrrDiISEoOJDmtMZXNBTE+EBcfxfW+kh+avQCgZfjGygW7gNRSvBhpOUcBNxQidFq7i0TxriQOpNWb21qMVzYV9fBOFiNc2fZkMGdgDEEzXYmvD3EqAv5iC8LjRyIZ9Uo8WpZObF/uubJSc2xLPQmNWsACugEpWN45XRUpQVfOYtnzwJlg6ZwONxU92GSwGcbn713rROFOqlxPFTdraK2eH0eni+hi8mytY8oh/RHTCVlccEbjgT6EuEz6d013kXhGr7TTuVjoMuUBn4R0bLGFgqJNYUbM0JwhEUVIksLzO/5nkay4KWx612RvLT5Pu1v
 nfQidOjS
 JLD+hq4R+feSzJyTJO3W6ngAlZprH5r8hn/vknVw3KDadIslmTUhWl2V7FMFk+OiNtAyiLhS5F9TzDCTDwrrv2jqsPNlXLAoj7a2ptEATXfBWKN4ubqbRkvSPi8g4qdfSi9nQS5vyPOkySfgg0zuX09cdUP3raNOUT1564/OhKMQxIhqoozASxhdJpK2VMyxQfccgmWx3vshbbnsARi17Y4MWZyx6m12m+od6sD5jLdSZczH40B5BD+A1kHBP6T1HxZQaGmpWzsgrfYpeB0IuHuW5/OeYUIUHBQxgLScZL+p4TbSMW50QBh9d8f/yxWzZmG+dgAYa30c2om4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

When changing the anonymous VMA name, madvise_update_vma() calls
vma_modify_name() to possibly merge with adjacent VMAs. We don't call
vma_modify_flags() and consequently don't obtain the new VMA flags.

Later in the function we update the VMA flags to the stale new_vma_flags
we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
flag set on a VMA we just merged with.

There is no need to update the VMA flags at all, so just exit early. This
skips calling khugepaged_enter_vma(), but since the flags didn't change
this is fine.

Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ ljs - Minor edit of commit message, rebased ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b2e00efcaa54..e9fa4f71efea 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -177,6 +177,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vma_overwrite_flags(vma, new_vma_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
@@ -186,9 +189,6 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
 		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
 
-	if (set_new_anon_name)
-		return replace_anon_vma_name(vma, anon_name);
-
 	return 0;
 }
 

-- 
2.56.0


