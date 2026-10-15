Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C19CCA463
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B226B00A2; Thu, 15 Oct 2026 12:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD3C6B00A3; Thu, 15 Oct 2026 12:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95456B00A4; Thu, 15 Oct 2026 12:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8261F6B00A2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:08:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07E22A031B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:29 +0000 (UTC)
X-FDA: 85325343138.27.5AFE344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 438B920014
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0BiqyM1;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080507;
	b=2KVZNRW22odIS7kdMp/bFCi0yh5rRHI3un5XIFC2ucvaoyfckp/pkHeIm0SRfTDioVWcUS
	rZk7c1w6kXQedDLXaxMr76iJLquEPznWBtggmHORKgzYcTbLS/Z9BI3tqcwnRXRkx3Z1S1
	PwdBqgUPGA2dzDoMY58wb55wcSIZZ20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0BiqyM1;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNBJ012Mx6kfcvUBOVNjCydGf++Y8d3EAS1qqSl0elI=;
	b=I9XIB3hWiMnOeZDDwcmEm/Vcc+d1wNY96hTz7NKZID9rf1VDrpnnSAywI0MEiLlzSRHFVL
	1jvToXUupudPeXtbVRk9l/fXkoNxiOJW/aggj+jD0tEMFMgfQIUT2AERW863pfqT+GT3xT
	H6iAFLgTZ1AZprpOC+PA7nw9w8PSKgM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89FE74147B;
	Thu, 15 Oct 2026 16:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18C91F000C6;
	Thu, 15 Oct 2026 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080506;
	bh=aNBJ012Mx6kfcvUBOVNjCydGf++Y8d3EAS1qqSl0elI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S0BiqyM1EikbU5FSP5gpgmgVDBpDGZBYWODwAV1Ic3pNA1VmXdIOuQKrAshlqR3Qh
	 wVP9C6RR2rBriogLU/+ZEYh5q71OPq3xSELDt/+3lXBBdtWTc62aIKPCFWPSZq0FTf
	 y6+9+NgDq6+rinyM3/++iSFdepuLfZS1iXvRjqoHz/LLqcH2SBHFMQrbsWVD9qMVGX
	 Npc6IX+bOez0lyR1YTFpqRQ4DunIPt8k24kjrcvhVpo20A5FzpUgPqMMA4R9ttx4ME
	 T2oHNK+l1Aj19WPcDh0pts0jgnqhIXtUncc3/s8gfI4+GuDEuAybw/NORTIoyH32aV
	 s37ewwY6xA1WQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:16 +0200
Subject: [PATCH 10/10] mm/mremap: fix calling fixup_hugetlb_reservations()
 on the wrong VMA
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-10-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1190; i=david@kernel.org;
 h=from:subject:message-id; bh=xzUoLGsOY/4424/eZSx1vu8LhLt89f41pteXNyOKue8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DIpVItrO/T+XsDxVxsfyqpM+Td5ovDErdGyr3ZqT
 jh2/utCvo5SFgYxDgZZMUWWoOD7Bi9frqutduNjhpnDygQyhIGLUwAmsuEDI8OUOOH5+WJBQm+u
 xXNcnr3e6QdPid4Hqb8/ltfaOHxx2GfP8D+9qqk/RG3zpy9q+ZLHG72S6nZxFrUa31m/csHRGGu
 dbewA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 438B920014
X-Stat-Signature: bgd3cn9oue6rqeza9cm1c39nfzq8whm1
X-HE-Tag: 1792080507-749693
X-HE-Meta: U2FsdGVkX19aiTJJrb9NgZh4itVGER59Srm8cd6vt1vGBQPzgtQokp2NSLUOae/AEkdISs/SLd5BMLGl+iPGpfp9jjJ8VVHv+1h9XORlNIPNMx9LqRkiXTsfOe+qdEvO5CkckTdezmtRUiZLpDkArCXiIuk3TfzL/bKD3T3h1h3qEPoBxRheh8ZbT4s+GpbhzGJJZN+ZBNA0HUHfDoGI53w1FFRxIFGvRu+RcwSEeijqBJ8/YJmQtd6WB4MXlj941xXrAEhOcvEV70Njf2DhMm4PJdr/HlmqbJVCYN1s2/tEaI3UOC4SkcAdisSq7w2cfRSCeBaC39JT5+cclpfzPuhsQBX4C53f3cD9bjZcGHHTVS8WAqAXucuYkM/mOmL6HFz9/JW1wVie5D/+fiM0cT+ilzC+edOnWPMHR3jLkZJ91E6KUUUamMqJIArRvdF9yrZKCdvQHebhKrlyGYDb2hjzQBhr92iK/GoSHvlI+uyXOBKhDy4WfcuqHzmVzQjuHx2kgsaE1YN9NNm5y0V89Jh38H04Yl9OmlPKnwK96fAC3R/ro+xPHhnVFgu5X/CoGFS3bBAIpSYbb+rtkyDUT5n7nYY5wQs316u1EVUddMxps15C9ZfIWdUZLDvocwBmXwn2aax5oZmFU/C4stOuT4scKu533ojT1zu9BfV/QlbycAGYmGA2mY0yaTj3TFh4+99ufN6S04VnrrQIp66ADxr1UL/uz7fOQ6jENqvojkd+bL9X3a1aU/Ldeq1UThxl0KsLUXArfTtcLRGar2ySkbsJUyNA+tt/niHIZ0az0hwO7eir+tHUIw3+rUACI4zlJzqP3MbwfnAwlJQg+4VDx1YwjHED7IfiSRSIDHo5bn9pUgIU+Gy854RC8MJck5kFd2X62KCAO/pI0/D2cVZH8bX65bM/7quX9empUdLtYrX9SaxJKfXBV+O72AUL2YYGLu4s/maDjUv5F75wuOV
 lmgUcwfm
 EqV+5zNnXYX1oyOmCihcAMQq6utAxoVydBJenWzftYKGGYOsgrmWh/k/0WRtawTUrYZAIPYJq+tChYAeeAS7YsFFW0giFjz9rr082nIM8jB5gC89h91GH/TRdJH8dxJCvHAnSv7DuLhEfyB0yB9TeQZ8owdQB4PJBk+T6JNgpAJGNY4XfyGGX6gwyDAhZlydMJ4GHNpHx1yq1s6huOv3HDQg767HccAYC95oUT7sXJWdd+fpTN5DTBWGPUMFpjp7kMxsGDRMKVUv5iBg0/K162srUy0PNun4A6IuiiMRt0agjdIcX/9bsuopgLt9cEXTO/Ny0EecD7xy46n0ThTwEjtHujg7RK3cuVionuclGF/3+hSa+vk4MWneCfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In case we fail to move the page tables, for example, because we fail
to allocate a page table, we actually keep the old VMA.

Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
by just calling it on the VMA that will be removed.

The user-visible impact is that the VMA loses its reservations, meaning
that the existing reservations get stranded (leaked) and new hugetlb folios
that are getting allocated in the VMA cannot make use of the
reservations, failing these allocations.

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 444f37d7cd28e..ace0c6a343b1b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1345,7 +1345,7 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	fixup_hugetlb_reservations(vma);
+	fixup_hugetlb_reservations(vrm->vma);
 
 	*new_vma_ptr = new_vma;
 	return err;

-- 
2.43.0


