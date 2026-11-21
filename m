Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3F0606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DeYzaWYI
Received: by kanga.kvack.org (Postfix)
	id 01AF86B05BA; Sat, 21 Nov 2026 11:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35AA6B05BB; Sat, 21 Nov 2026 11:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCF96B05BC; Sat, 21 Nov 2026 11:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD0776B05BA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F030A0573
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:49 +0000 (UTC)
X-FDA: 85459596978.09.9865988
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B716D18000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DeYzaWYI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277027;
	b=4MgBIWbKMCOMCaWm0Il/Z0Vm7+aYKx8pouxJ6Ko8hjeMqOMjlW/vq+34JZ0vS2PQ64OFdF
	QvoOQGzVthbMOVvD/na/x+qeuSrCdUIDx3sK41NzceZ4BIWsuquafVEv6oH+hyK5NseMiH
	dEMbZuTbsts03g+7LV2X4Z8IMwPEMaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MrzQvysZI5mWxMgDdoD01EctLlvyCpIvJEeHhtviPU=;
	b=4r3jNxPQAWu2AyjFSRp4qnDRjWg/RozuWiwprSecemgvvvjgMyLsMs/8lDZr0PSPHkTCDY
	Fvc/9ChiXlgSTZyU/tTAX+gk0x3GcWvqD6ieDR4xaSNay5dtDe8yIRvGqL7IMYA98UFx8K
	3NlO+/OC/BZtA6fZ2dzQqiFx+1p4Mg4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DeYzaWYI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17A16413CF;
	Sat, 21 Nov 2026 16:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1D21F000C4;
	Sat, 21 Nov 2026 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277027;
	bh=6MrzQvysZI5mWxMgDdoD01EctLlvyCpIvJEeHhtviPU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DeYzaWYIzY7gSMJUEA1QDTUOPjlUzrb/zp6y/sduD6Z1+qUYmaEbhu7YvE0mRC1Il
	 pZL+gp23Xj2Y2zdxh1E8JKrfDpkCJVJecikqZW5GMXel4TJZ4cym7oEwVZ9b3sXh1B
	 YRJU3o0mDSa9I0AzA89NdFLV8Le2KzD0YRRXrKkKTLxpqqctJj/BYjDZZOPp88eS5G
	 PFbIgWag4hXBXG8RXytzP53G+uLOmXLH9p1ZpxPj0g6upS6BWcIJdeElUh7s793+af
	 l/TgKYVHt/M2udQWKe9aABvtTOhlh3yYaQQBeOdy+VB2mKWjXFgmehRi/mynu087i+
	 tTn+D+8+7Rywg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:32 +0000
Subject: [PATCH 6/7] mm/mremap: respect guard gaps on in-place expansion
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1638; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RG8tpEXV2aZPcKGCFZhrBvdtmbrnrhgE8KbCbZLtg0Q=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2zv2jilQHNajk1ayy2/ygmiM+YGtwg+n9SyLXkCR
 /nzR9zRHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhILwPDT8a3vHMqVJUbd6vM
 md98V0c6cNckw5C1Yi2n/51svHq1ZiUjw6Sbfd9aN9wS3SK9T2bfTWmO6NzoOv2QPS/Fqi7Ii1+
 U4QQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: iieoj9ieaum3fyuprf4e18z8uxqru3qj
X-Rspam-User:
X-Rspamd-Queue-Id: B716D18000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795277027-276347
X-HE-Meta: U2FsdGVkX186vSlAax2jZf/GHIZLjEdxnw0kXu1UcINSzBYGnSXdziNnjlC3kOde+jzuvwX7MRiCmaeb1yPWlAtMtuauayFsQ50dhugHDS0eWGRnQ89bEnqAcHRb5PhzBGCn72ejnnGXCD+wNHJbfVyfrtb0Tyva6owp+VqBbKT8j+G7hPDW59OTyir9a12jeZgi3klhPbGZ0GGN+pMJ/X2Rx3ZIdvsdhxe10c0H/uF4+RQBc8NqFdByNJQbXUNswAxVhVX2UTvPcCZ9JcxapBl9oXflVLCMZAfXwEhp2yoRa8tn94mZLNfMTfsr9fYJ2VH3SrpOPg86M/8XXDuOccIJFR7rqK32Tk09JREH38KluF9kWt2abKAMnfxSL4uPnNDUDLI73qW4lO7PwL9l+JdSGVveeGFIgyOY3a1z+Ei6DMYDKqIhCoaay/uaCSDceI2kUlKNJLjEKOoXbeUeCNvAjnQphWHzq+C1oOYh3vQW5EyJeTI+B1ojCUzKkXMiE4n+Sjy73COXrZLd/Kp27P76dtDbyhkHEicxRE8Mh49mzu1limwnl8TVM0eF5b7CeeFB1AfjwymOsYJP6B0svfwKNtmoqt/Ie+MWu7nx7QR2qfOrKHfEl05/6klCZsCI1C1g2h4+hCqd5qYYZ0gGUm6fe4Nggk1PmESuD7R74WY8eJpaUvmZHoenWdRaZncr1gXvu7gpgra35gZ7Xadgkfk/YPj7G4OlNpHl92ba0wRq2R3vot9qXn4s5uILoblG0Wfxquob9D7DzGmyqBknnK7kHRWdtXHNFXfXaOQ4sADfb/3FRQSbFnhrGh4gu0jAvcHIkMP83L33xYSzmAOuj379TAOWA8qcIZfYhSa76K6EQ1BWt+drd4C7fu9fp9ELfh35N3SW/KGayB63V6SI2uIwdudkSnjCw4+CFT8Tu1yP8a0EFrMY6acxOjLWI+KdNnpbpG09ZDPaWmOQ6Lj
 cfvq/zyx
 DXjT0i6dZXj/V+x4RS8zfmCeVIuxl6E4mqc935q4ELmi4cBfhoMPX39PLeEdDwgmFDGAJOAF8aijvCfrMHjsR/ryyO5iVNqD8tV9tcjcbf9nUZxAMXLSbOfQyLhqk2vRVgdMWF0fL5BQZSoK/5gEK52McX8RjXwi0HrxIxak0Rz0pokUUcZiAnIZzi+geeWSzHW9N8YJ0Dhdn4lH0KMl6G+c0jSgdtAHOXy1qV3erxfY+LFhic2df3KKapZ5gRdIbkLVqXTLZWkq6d6F+0/cYN3C5LrhP6zCi8rAxtuV56AoS9opOs0Wr1t1tWWbCQ1lusLbz61rwwtArkFDxVA5Ht6n8d0baRNZuD70IEvWT7Och7BPUgY0N4Xs6Wh+uY8BtkVv8RZ4KlLKe8iKJ1/xeeEgG1pyQrRVjLv3aqbiSiYZkSEr6Q4tMIIMsJTy78BOVUzCSV8nZXfwAZI0V7J9Wk3u+QIDyS2Do9xAZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Growing a mapping in place can let it use up the guard gap below a
stack, so that the stack can't grow any further, or overflows into the
mapping instead of faulting.

A mapping has to stay out of the gap of the next VMA unless the caller
fixed its address. But vma_expandable() only checks that the new range
doesn't intersect the next VMA, and it passes MAP_FIXED to
get_unmapped_area(), which skips the gap check there.

Fix the issue by stopping in-place growth at the start of the gap.

Growing a mapping into or within the gap of a stack or shadow stack now
fails with ENOMEM without MREMAP_MAYMOVE, or if the mapping can't be
moved.

Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 8043c425b5df..2460f9421a13 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1552,10 +1552,12 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 {
 	unsigned long end = vma->vm_end + delta;
+	struct vm_area_struct *next;
 
 	if (end < vma->vm_end) /* overflow */
 		return 0;
-	if (find_vma_intersection(vma->vm_mm, vma->vm_end, end))
+	next = find_vma(vma->vm_mm, vma->vm_end);
+	if (next && end > vm_start_gap(next)) /* intersection, or in its gap */
 		return 0;
 	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
 			      0, MAP_FIXED) & ~PAGE_MASK)

-- 
2.56.0


