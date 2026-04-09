Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E184BE98FDD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CBD6B0005; Thu,  9 Apr 2026 05:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324406B0088; Thu,  9 Apr 2026 05:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B266B008A; Thu,  9 Apr 2026 05:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 176376B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:55:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2EF41406DC
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:55:17 +0000 (UTC)
X-FDA: 84638559474.06.D133E00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF492160003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:55:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mXfStgu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775728515; a=rsa-sha256;
	cv=none;
	b=qbruo4ACLFO1VsXUCQsPu8IN+t4BDzMIlArcZKahiBU6iFs3dzqDLkKZ/tHOt6vVl9kiNs
	WeDbjhnYhJ0swUyhhNy07YxYXFF6Hm5gRXjEIPEXcGsc7VGlznYIYvdv733wRERae0WqqM
	u35Vq22tV1ukNQLeAC4UHETsqwq02os=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mXfStgu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775728515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSIHEAgVPt/ndB71PNd9KqLJeVHWDoe3ICi5iT/PeaM=;
	b=Vu2Runm1dQbKPHb4pucEzHkhTmbTUGU4+s0AFSCAEnjVNo6ZvmZm5IYNJcCvphcl2KOncE
	F7okK++lAOaTmYLyiLPjIs8h1F1MTPmlM6Q5e4oi7Hm3QwwX/2nAbXDwYd9EwkkDEjf1jw
	DZ1nSZykHbz4cTMHUjC8vJaBGI7HDcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB4BE44095;
	Thu,  9 Apr 2026 09:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605E7C4CEF7;
	Thu,  9 Apr 2026 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775728514;
	bh=7Jqv0DZIrzFjI5F0XxPVosyqI7IXF3zzlfSfOKKQ134=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=mXfStgu/3TLzTJSJjLl8FnH2jzRgL7wFbNyTxVRAwxXcBCOJJ80al87IknCfF0YG3
	 bpgBRvPZ7GuNHwdIltxZhZ9X/8zy5b8VG6o+ludtnWSQQgv6U0ws5i7M/Kaa8nyjol
	 orwEkErAbxpVLwYkk8bKGvKwe/M+cJLWtFrgFjuDWroZINYZ8SKNKYEJkaodZSeTW6
	 ZUFLypObeT0ujyGXbFc+Z/MXRHp5LNNxRXzz5rlQ6ho4Y2+xiHOz517EOQoV1CIwA+
	 hPicY2nRCoqew0KAKDO8IWaiCEG0yHyjCuqIy+GjffWdqiETSCciyRvmoIvn8ZNO1R
	 Jx5KErSlJXTRQ==
Message-ID: <5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org>
Date: Thu, 9 Apr 2026 11:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer> <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer> <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
 <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF492160003
X-Stat-Signature: km9rca1z9woe73iefn9z6d1nqhpzs46m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775728515-166345
X-HE-Meta: U2FsdGVkX19VWQduiIQlPSdafHYpgcxaIUbVj6Af2egX187PKeuV3fqYYc9rVBE2XcEeFM9ZJ9UQcCFWaLjBlNl9IhXNBEXJT+bQ7sqaLfUgYcTkgiatbLm2YUDyGgU87X3EZbLdTKr6DmaW0SMbeSM7uGy9VbD+abq0uusWZeYwtoHCcOk8NwZ/0TsXC1fdbZPhMFVhYjm2VbpVZ4sJIYRY4GAFPGD/d+yJxm4+dwd/Injw4cwQrwvieZajjqdazb25QQCwgYQKkbV0RRp6eyaBghZYovSB3ffTTnlsw4n3LNZc3RQGJVphisGXVZztLJpT3TWta5GqZozDlpm8ugUHVlAgIHy4DvkwKpIZ2N27pwCBII+IX2NI5m4EIyj295qWq+bznrIOsLzpgzCq9SGQfso0MMIkEhGAa3suU8RdbSzbAgvU6QiYrupXZ8sDh0uPeojNODe9sAyMt1VQZL3qDjrDSeo0nezhLyEqJZb0AlzyAeuCDzfXpekC50OSQDCmTadKGA4UmCpp98zzsESDl/dgWTu91grKaR0cW3zX8ggXFb8YbJQ/Q2El1k7VsKJ2q9y0VaolS2WIO9VmbQUhFJ0PLbrr8yjBlDyAe5S6IXzyrvfWbapk3cmhEYOagIPVa/tPamTx5uzjNagxQ/XbE47bFfT4oA0OUZ2svpFAufxnL4c1njRt+NZjUnG4mMBMDpjLA798T+eOO1r0GNOujOiz4/EKXBRfJUZnbBOqL8vDTDDdUl8zBMfExUsfJ9NsXoNqrVf6DrO6UihmIwDXDPaMqL5Wyudqv1oCSJiscDrwUYkR/wRbCxKVxDfJjdN909Mb3/JOnmZOXqEFESYkg+bDB+saxlLKJvnMiZqcYSB5PMLp1dzaSPqORozPIXUTQ12BGsPXfZzm4npzdalT8WqSfIFKRAFPWf0oITVeeidZd3fXHGvRYwkLC4yf5RTrYir7+4Y17N5j9v9
 71aM5LjK
 TYxnAWG+azuwepsHT6ILJ02SjB+lvfrO3xvP7CZ2EJanMdoLDXoTtGbpIeDSrZ1S0mKTxE+U5dSkel2/cVpxx5M8+QsCNuSKhlRsdvE4Vw6p5R+HINMoL7rqX2xuMGuVjWwUUbKU+90alS+K3RAClPVydOa594bVb9KNRFNn6M1SoeQD7I4xEgIm13libutVewC7en/b8cVmZy8Tk44mczg97K0ULViBxa6Kol7YdfGpjQ/GxtfD7ZdJKtDi6i1H9eP/EVoHd/vTcJ96YqtASikxWJehGLYMCpoj778svOBTQWxoV5+uy4ejbuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 11:41, David Hildenbrand (Arm) wrote:
> On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
>> On 4/9/26 11:18, Lorenzo Stoakes wrote:
>>>
>>> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
>>> 'related' VMAs.
>>
>> Right, anon_vma_chain has. Dammit.
>>
>>>
>>> And we're already looking at what might be covered by the anon_vma by
>>> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
>>> ULONG_MAX).
>>>
>>>
>>> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
>>> we check:
>>>
>>> if (addr < vma->vm_start || addr >= vma->vm_end)
>>> 	continue;
>>>
>>> Which is the same as saying 'hey we are ignoring remaps'.
>>>
>>> But... if _we_ got remapped previously (the unsharing is only temporary),
>>> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
>>> and would still not be able to figure out the correct pgoff after sharing.
>>>
>>> I wonder if we could just store the pgoff in the rmap_item though?
>>
>> That's what I said elsewhere and what I was trying to avoid here.
>>
>> It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.
> 
> As we're using a dedicate kmem cache it might "only" add 8 bytes, not
> sure. Still an undesired increase given that we need that for each entry
> in the stable/unstable tree.
> 

Hmm, maybe we could do the following. I think the other members are only
relevant for the unstable tree.

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..0c6bfed280f7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -191,12 +191,13 @@ struct ksm_stable_node {
  * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
- * @oldchecksum: previous checksum of the page at that virtual address
+ * @oldchecksum: previous checksum of the page at that virtual address (unstable tree)
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
- * @age: number of scan iterations since creation
- * @remaining_skips: how many scans to skip
+ * @age: number of scan iterations since creation (unstable tree)
+ * @remaining_skips: how many scans to skip (unstable tree)
+ * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
@@ -208,9 +209,14 @@ struct ksm_rmap_item {
 	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
-	unsigned int oldchecksum;	/* when unstable */
-	rmap_age_t age;
-	rmap_age_t remaining_skips;
+	union {
+		struct {
+			unsigned int oldchecksum;
+			rmap_age_t age;
+			rmap_age_t remaining_skips;
+		};
+		pgoff_t pgoff;
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -1600,6 +1606,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 
 	/* Must get reference to anon_vma while still holding mmap_lock */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
-- 
2.43.0

-- 
Cheers,

David

