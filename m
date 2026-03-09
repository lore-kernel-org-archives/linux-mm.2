Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1EBF3C269
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1196B0005; Mon,  9 Mar 2026 10:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F726B0088; Mon,  9 Mar 2026 10:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481016B0089; Mon,  9 Mar 2026 10:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 395E86B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:15:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBC7F56CF2
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:15:34 +0000 (UTC)
X-FDA: 84526722588.20.55EA1F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D136540018
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:15:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TIApE0b4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773065733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6uIg6iu1XH6lL3r2hyEQzj/+Cq96hCap12yOdaSVho=;
	b=V7yfjaBUYZCudBrchBJTrryg29nbOgBtjkUsBJAjevEbtY6xWqsZORnBB2+rEtb882dEG5
	obp49Cvc0Trs2JNskHhmKfanfvud+SymQafIjhWlovFQFqS20Be3CBYrTvi4pnRfIom4N+
	CKdic6XTWomqm7NEafeuYAk3bkZLO9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773065733; a=rsa-sha256;
	cv=none;
	b=1AhieHhYkmSBmAJJ6QhZloHoY3HSU0/A6FuugwvgunDZ0fF7VAVtkN1TKW5zGNfHCd12Wj
	og+nfBpKnRcOM6J4N1XhHh++ujgPzao3B7xtl08ncwldkNd+3Mz3OKthegXoYcgcK91tQi
	jJoBS2ymWBGKB05zrXbCg1+cxnDX62I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TIApE0b4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6F44440B1;
	Mon,  9 Mar 2026 14:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51F9C4CEF7;
	Mon,  9 Mar 2026 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773065731;
	bh=5rpS4G00m/kFW8PthAEdjjLjgfkWUJy4UO9/BkrZXCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TIApE0b49DQ54mrZl9FGRFT27M8H798lk0FaGL90qgjp9De/0PAWEdW1B8tHxUbte
	 ROAbQ/6qA/4BP+gYXZ1v/AV90+N4aZaxW3sidFjMf8l2efh5HYPZcYS6+RNaa0mKEN
	 Xvooe5oR7rQoX7S9DzNjxeJCy0823ASF3e6Q2s+GQ7O1n8tw8lgigdGYYoxWZLB/mi
	 AarmBhlA6sgN3TGY1i92003wII0qyhdCnMoka++OIgEIVAO9dyQEX051UNv5eCZ2Ej
	 kLhkrTjSW0oArRLVYpImzg9myioghgTj4F52RXhvMd35vjJbV2juSgT64n/BLfN4pB
	 t1usvPpxtiDtw==
Message-ID: <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
Date: Mon, 9 Mar 2026 15:15:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260306204550.8405-1-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D136540018
X-Stat-Signature: grjtpdjwztghxemzxmeqrghkejg3581h
X-Rspam-User: 
X-HE-Tag: 1773065732-188271
X-HE-Meta: U2FsdGVkX19R9IbJcU43cSrEy+ByS7TFnA3PWTPlhYM5CmjExv1je5kqSDL4HuZyijvPj1Gm6csIzLcVhgzZlmTbFv8+OVet265JFhp01h4pHZ+HRPQN+dh2P/7RPojoYWmkYshlzdmbArlRVmaGlCbNlGWo5zwp1cuiBfc3dFAW8ak0akumnw9VdiQFykuoovXPbnk/5DL14wt1cEusV8SFgrqv8iSNVRN5IvGU/3HTflid+zrUcPoP9PCDmsl1IDTK6rSxvmj8p/h1gXtyWfALAryZtHBvaNYOeI8E7D/ykvctfZ/3vPpMEbrsHP7pCyQbNpPSF7CH0xShBH7tVZtKRZT+YsHhyEth+ZLenhyhTlky4075migp7aKEtkctyCdq/sL4ckHxNTLGPujZrLZUNjvMvVhX7UAnCIcBUPFzQNa99ta8aFVN5UM++DKRwBHyI1yIErVvNp5HTOkYfbG7FABZomzkxfb6WSc8UppuTpc+/B37S1pb8MbugOoqMOOWaQ1g4b62GSH5b1rIlUycCHtE/6T+wIxZXxjPAEZasyRrB3ibgMX+doslyeTEHxktyFSpvTRlstJsId0Dov0pAHqX/bamLKWXQe/IWG2Gjtylwf80QKdV+5AZOWxzUzyIIdynfhOByqhNGdt9BYETUKSxQS6qetoUX6O9IAl5bfGdnddijZn5SdfKPdz43LbQY62c9V7A4WhNR73r2dFHrn+Q7TPIS30OVy0jmE93qs6duxndSa244yjFi1Bq3AaO5/MQSW7F2Vq+FDu5vinoyz9nCE073utFXDFDbMcF3lWnySZno4mxL2LNA5S+bL2zqEIUMMCKNqGTFdZRJrxIA35Vil24MO/tkJKZap9cfoNVWj/TehunFKr690FDmwlTd9moJ66ZDHcKFWbSMiIRNmmSRwPfVpV+I9qGhB438/1c4dh+zQoylZHTakFHh5zr18HBzBBRAE7c4g5
 psFeFpHO
 XXTZAD85rMqDUfyIywfPbRAG6bqgM4E+LeVZ6UVbDkvqtoe5V5Mo/nGOt5vy8/uAsLwcbM7ro55vpfuSkwIHlfJUHvheU2H9CY+lwfRVm5jF/y3/TnnVnzYj7DdNosBLPqwGskw+NvMJxygSYu/vj8Hsm0JP3zwN4n1vv978fEFGxc5LY/RaGVfiiyy/qRQ2+JmpCgy+Jz7of5vKfJfLfXkYsj1zXMTBaE1quh3/hOqgnd15LfIbAHULpCD6hhJHOwa3GRyZpbQCZX8fqIZJMHAI3I15Bi39K+n9M5PScqb0BvkZ4wlW2PPXwsZq5T2WOmDzQ+4LnpxZepXO7/ogtipv2cvabqnSw2auZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 21:45, Anthony Yznaga wrote:
> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
> to the check in mlock_fixup(). However, they will be locked indirectly
> if they are created after mlockall(MCL_FUTURE).
> 
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  include/linux/mm.h | 3 +++
>  mm/mlock.c         | 4 ++--
>  mm/vma.c           | 2 +-
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5be3d8a8f806..bb830574d112 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -574,6 +574,9 @@ enum {
>  /* This mask represents all the VMA flag bits used by mlock */
>  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>  
> +/* This mask prevents VMAs from being mlock'd */
> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)

Instead of adding that, could we cleanup further by doing something like the following?

The usage of "vma->vm_mm" must be double checked, and we'll have to take care of making
the tools/testing/vma test happy.

Not even compile tested, so will require some more work.


diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
index 593f5d4e108b..755281fab23d 100644
--- a/include/linux/hugetlb_inline.h
+++ b/include/linux/hugetlb_inline.h
@@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 
 #endif
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
 {
 	return is_vm_hugetlb_flags(vma->vm_flags);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 6e1162e13289..b70ebbdafe00 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1242,6 +1242,15 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 	}
 	return fpin;
 }
+
+static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+		return false;
+	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
+		return false;
+	return vma != get_gate_vma(vma->vm_mm);
+}
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void mlock_new_folio(struct folio *folio) { }
diff --git a/mm/mlock.c b/mm/mlock.c
index 1a92d16f3684..e16b2ea234f7 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -472,9 +472,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
-	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
+	if (newflags == oldflags || !vma_supports_mlock(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
diff --git a/mm/vma.c b/mm/vma.c
index e95fd5a5fe5c..b7055c264b5d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
-					is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(mm))
+		if (!vma_supports_mlock(vma))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
 			mm->locked_vm += map->pglen;
-- 
2.43.0

-- 
Cheers,

David

