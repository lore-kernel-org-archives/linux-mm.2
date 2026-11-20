Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB44360A2609
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVUqqnve
Received: by kanga.kvack.org (Postfix)
	id F06B76B05B4; Fri, 20 Nov 2026 04:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7AE6B05B5; Fri, 20 Nov 2026 04:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA76A6B05B6; Fri, 20 Nov 2026 04:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B98436B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:55:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55ACEA8DC7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:55:49 +0000 (UTC)
X-FDA: 85455040818.01.BF23DCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A5F0180009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:55:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVUqqnve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168547;
	b=XQOOdipjuoGLGTvXcPxfNc4uc/jgWHojkoY2Q/4wS5a54/0ol4KuWJ+tbrwtWYCYGqPlxy
	8fWbJ/a5V+QP8+DEeJ+qMXBUM4r0Fg2tyXH+b+tsEEL7PzOj9A2gBF+VqneQaCfIpXMqHh
	P2hvmdr/NCC+KLfB3ic6jVh8lBmI5p8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhTZv3Blqe/87/3q93peQEDtzeG4d/geRkpjWttccUs=;
	b=XKJNwUYeDVhkfs+WDdYrxbiXVchytUVEc8oJXV18L6vX8wagMCnqXFgi35KERP2voRrAXf
	4k/mlFjLlCvjuiOJ0WoDfcpvs7cfKjCbdV41XiUVz5EUW69mUZARSsVuD6EyXGtpuGmcOf
	Hs0n79qSJacQ9CRShlxIB14axBx0ZxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVUqqnve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A555340620;
	Fri, 20 Nov 2026 09:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1EE1F000CF;
	Fri, 20 Nov 2026 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168546;
	bh=qhTZv3Blqe/87/3q93peQEDtzeG4d/geRkpjWttccUs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PVUqqnve4rP2EPlGl10D8A1SY8AOGkFef8R4VMLgDpZ7/MP2thSm0+/Abgtz00wLx
	 AKQflX09OetFfDZVr+IiGDf8wmrArW6Sx5cH6m4LXCcfiiSOLISfVSNg/MBRMPhHdv
	 1bP/M9S4Yc9bXfD+KL8Csnuvjilv9aJAqi2V88bPq8O3i73omsPqhqGzPUVm/ty23U
	 bPmku1vZyOxF9OxvLnqJZ+hv9DV6fGLuPGpc372m/gV/fwL6waNRZx99WV8ZcU4ldK
	 x3I4F4RVY6drlk70VjNrYr7lPcn7o9cvvM+ECog8Re2oSMDZzTx4f088mksz8R923v
	 CH+2NyTcKoMyA==
Message-ID: <3b00e53f-b4eb-41d4-b3e6-791660da3342@kernel.org>
Date: Fri, 20 Nov 2026 10:55:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd
 inputs
To: Arnd Bergmann <arnd@arndb.de>, sashiko-reviews@lists.linux.dev,
 Arnd Bergmann <arnd@kernel.org>, Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Jackie Liu <liuyun01@kylinos.cn>,
 linux-mm@kvack.org
References: <20261117211635.2472067-1-arnd@kernel.org>
 <sashiko-outbox-221983@kernel.org>
 <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A5F0180009
X-Stat-Signature: wqi7og5t9u5huymt7xanmnxkzhare5wr
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795168547-848979
X-HE-Meta: U2FsdGVkX1+FP9c5HqXRn8xdbf3E3JLaOSXA77T6NvPNzSro10IY9KgkPLWkUX4/b3S/qQdn0Xdn0ig+NNnIIt86lCU4Bczu7M5UB5BezFXraRBgdHKNygL16GMOLmb0jTzhDJ/pT69+F1F6731Ty1oE/0nt16DRP/MNpMWSFae/YZk2DCkCJZBnrDZXknScFdeV19EFrcAmv/k+BG2qxAuH+PluXIvtnHKfHlMunyk4sOYraooh61TRpZrv+KV9WmoDNm6jD/ENgtuHxmHwiLJjPapnwS6mSQ+3L2xMALu1bJ/O/u2sIOHPP7VYhlB35IAVSUzqGodc8UAQJVOGp8SvGbWvDR515L66gY9mLw8uXbXEWK9URtiaU+g25bC5/WeHDaY+CQK7uq4gZCVSlpUPK6eHo46MpXN/mXIUATYiwTymcKdmU/dWxod8p+SdA7UU4iIntliHgNrIJkCLx+j+voj0K/8GT4JBmO/PqJL7XgN+K/7yYwZXxwOwg7BhclmGvjTtltlWZS83Xu3ElB0IztB1DGT0iMRfpbXxPOHXBGqowZHbPgSchDaRJiFFvz+iHPSQZMGVMRau22DKXmbf1Nft/YjWENETHvCN/96IdamNMzI3QrtIO83EhMA1nngLEJP3vDnPqIi4gPHuGimGGukk+MJFgu6vPHJv92SAdepxWXr178hZA2SXl6MhAKfjKMgSjexnWnTLzlUDZHKjUrxjNVN/ZPPlrc6+TSajsldWJpTGxdbU9m7DBVTUbzFNGRYzRNBgsvo/yLuCnt7EYZid1qWRbcvo84JpdznEeKScn0Peu32gY8Ly175B5EmvnnwO6UblcAgFrLfatMs4xGat4xzCzSD7k8vUsVqRmJNgokU14wCq5AbT3c/GlOQO1dQ3Q30OAAbsXYNRH4KAH6chcOfkcfEBvikPPWcMfyiE/El6iciEXUE3o5qctKXUcmqucSfEMiigeGp
 6UgDY1e0
 P5yDoZeEx3rRnt6Re2AaRSpz8W1bq/V06dcuDXO297CK9aiTETkeqra7lBUw9B9T/xgwNBS+UbQx4oGFGMHXSnZ0IvtjVozxKfLzGrkuuVqlJ89p/O3tvAU7s00EDE3uqu9rQLtdf1NcWlGa7IxKzjD80GFfXiigJmQsmoHqacEfwNkJ5ruSsOT/1/+PHJmMrA/fi3nOpDlBsNRV8hG12z7Amub+otxdFcOqtfjlbdrLIswaJZLGplkePInBgkymLPNNCiYM1XdQAth9HCUkAmsUsLFqYdGX8n3QoUfryWs7i92MkEOpPay1rEssSQHptYec/9ehy4F2aFawjnmqpHRf651bwwDmY6IAKjPdEp2XiRCS6vQWW4HXjoKnnb0ZuoNnKAykr63wVKT1WoRhcAkn3Arp837ISG1MG+lg3agtHjh9MlwbRyzvDp/9k56e+KOzs4Xq9a2UpL4EaBeQhDENgKSjsSJtKWi/x7qGb43xKqk9+Y58A9Zi14S1KQDlb46Hgr0sPeKrbybsFNbEEpsQMF7bkqB/P7L0ohXSgbIlfEneNcqHecRigH2muZkz8YuNzKfOBAQja38u0BcaZNXBaxJ/BXSc/drym6CC77mxHKpVC0QK4Z88HOpdDtE6SWyFJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 16:52, Arnd Bergmann wrote:
> On Wed, Nov 18, 2026, at 22:16, sashiko-bot@kernel.org wrote:
> 
>>
>> [Severity: High]
>> Does replacing the compat nbytes assignment with the compat copy
>> assignment leave a 4-byte gap in the userspace nodemask when
>> BITS_TO_COMPAT_LONGS(nr_node_ids) is odd?
>>
>> Without the compat nbytes update, nbytes stays a multiple of sizeof(long)
>> (e.g., 8 bytes when nr_node_ids <= 32).  When a compat caller passes a
>> buffer with copy > nbytes, clear_user() zeroes starting at mask + nbytes
>> and maxnode is clamped to nr_node_ids + 1, but compat_put_bitmap() aligns
>> maxnode - 1 to BITS_PER_COMPAT_LONG and only writes
>> BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t) bytes (4 bytes),
>> leaving the word at nbytes - sizeof(compat_long_t) untouched.  When
>> copy == nbytes (e.g., 34 <= maxnode <= 65 with nr_node_ids <= 32),
>> copy > nbytes is false, so maxnode is not clamped and compat_put_bitmap()
>> copies the upper 32 bits of the kernel unsigned long instead of zeroing
>> that word.
> 
> Same as my reply for patch 2/2: no, this is fine as the size of the in-kernel
> buffer does not depend on the word size in userspace. Copying the extra
> zeroes from it is fine.

I'm not convinced, especially given Gregory's test case. It's all a
confusing mess.

I do wonder whether this whole function should be thinking in terms of bits to make
it easier to follow. A bit more churn, but at least I can understand what is happening there:

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c7d4d149c9b88..5b99f7b95dade 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1713,27 +1713,36 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
-	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
-	bool compat = in_compat_syscall();
+	const bool compat = in_compat_syscall();
+	const unsigned int word_bits = compat ? BITS_PER_COMPAT_LONG : BITS_PER_LONG;
+	unsigned long bits, node_bits;
 
-	if (compat)
-		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+	/* User space passes the number of bits plus 1. Fix that up. */
+	maxnode -= 1;
 
-	if (copy > nbytes) {
-		if (copy > PAGE_SIZE)
-			return -EINVAL;
-		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
+	/* Don't exceed what would fit into a single page. */
+	if (maxnode > PAGE_SIZE * BITS_PER_BYTE)
+		return -EINVAL;
+
+	/* Process full words, which depend on the user space ABI. */
+	bits = ALIGN(maxnode, word_bits);
+	node_bits = ALIGN(nr_node_ids, word_bits);
+
+	/* Clear anything we won't copy below. */
+	if (bits > node_bits) {
+		if (clear_user((char __user *)mask + node_bits / BITS_PER_BYTE,
+			       (bits - node_bits) / BITS_PER_BYTE))
 			return -EFAULT;
-		copy = nbytes;
-		maxnode = nr_node_ids;
+		bits = node_bits;
 	}
 
+	/* Finally, copy the bitmap. */
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
-
-	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
+					 nodes_addr(*nodes), bits);
+	if (copy_to_user(mask, nodes_addr(*nodes), bits / BITS_PER_BYTE))
+		return -EFAULT;
+	return 0;
 }
 
 /* Basic parameter sanity check used by both mbind() and set_mempolicy() */
-- 


-- 
Cheers,

David

