Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519AAEA3C55
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3E56B0005; Thu,  9 Apr 2026 08:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9851B6B0088; Thu,  9 Apr 2026 08:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873BA6B008A; Thu,  9 Apr 2026 08:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 760DA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:26:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B2688B74B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:26:39 +0000 (UTC)
X-FDA: 84638940918.20.D159BC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5C3BE40005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:26:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWOgEUft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+n/ZcDPTCc/hEZ/RKuJDUBK5CUHgAjmRI5hnWdI/nWg=;
	b=JRr80G6+T7z5nQ2zkQR4bw8mraWHfn8jpfKqN/2BQ3AKtjhvW2uJ7GKLX0eUWvqDheUtNJ
	ExHiRhcr5CHpYfVPOjp4uBkcUkTIQ6HJvbMCyaOMRR5AJR5rhniXtEzVqH9fzdOQKh1A0J
	dJtpep6dx2MWrgZSdiEc1VffiHiEnZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737597; a=rsa-sha256;
	cv=none;
	b=hRXKvpXMl0A18v6Kb7eNtTvH+75Pcj7hQHiz0sVeOvf2e/mfFLt4Cf1RVAfPTu6yGV4Y29
	P3cBd0ltZ7QRrjmFyuOVPSyeEfjrFJm+zRtYALMWJdzw0OdFMwGx3NjYin7jTIybeD2L5r
	xeNhKHJbAE2a5YzxmOixDR8rs4S7cYg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWOgEUft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F010600CB;
	Thu,  9 Apr 2026 12:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA238C4CEF7;
	Thu,  9 Apr 2026 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775737596;
	bh=6xn94hi7QOXJXatDloVH0qi85BECEdtao1w/GV40ioM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=EWOgEUft+aw3zsyNgDtc5duH/DEazLb4DieB37uLtHP1Gs4fAWRfpL3LP6Zv0buDB
	 me6oi+y3tCxnJusH1neeV5+j2XO7Mz8lqki6Oz1b688sX1t8vWhM+XSQdzzqZq9b4l
	 L2KrIWjoPcVhrgkwsdba+k94EUnhhps1huoi7gdqrCXsC4IAhQaLwAMzPqMdv0QOEA
	 GLQyHh+dc+35P6lCJQ76TWiSa2SN5hllsMNZ4evmlScoQPt5drh69YGGVfTX+Dc0er
	 7J6UePi3RlcKpbLmoBSQs+pkYp+1ZkXuVEa1pdYNfT7m+z3xzRbJFh8+N/MeKmrDnp
	 Alq28rmhZ79gw==
Message-ID: <a2d43c08-984e-4ccf-9faf-abefe0f931b0@kernel.org>
Date: Thu, 9 Apr 2026 14:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHYzIDIvMl0ga3NtOiBPcHRpbWl6ZSBy?=
 =?UTF-8?Q?map=5Fwalk=5Fksm_by_passing_a_suitable_address_range?=
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: xu.xin16@zte.com.cn, shr@devkernel.io, ljs@kernel.org
Cc: hughd@google.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, michel@lespinasse.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260409185610930gKQqJsFs5KoTU4S8MrflI@zte.com.cn>
 <d473917c-468b-46d0-adfd-b8a1d075f8b2@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d473917c-468b-46d0-adfd-b8a1d075f8b2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C3BE40005
X-Stat-Signature: 1peowchdqgn6z7esha3tecup614sn8hz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775737597-430051
X-HE-Meta: U2FsdGVkX18RlH2htlG3YBRcQ/lPFT/bjEw1qeCBMgk5nhYBzf1O1dqI6FoVdnA+78glq5ceHuGbhfbfse/oM1qiPLx3/OFoU2L4iG0BurJfvCf+rqbRAA5+Z3B60cRtX3jX/43x5Xvw6yoQ1wMe1zJrXxZM6BugcC5qfsx3/DHrQzrZflvWuml43JoJZmjxZ+V5arrNaZle8szszF5feVZLf8ByBJoThVmzTknCa6smTXvVJ07qR6mxwGZF3v3m3uSwEfVkMP73zW9IYvQsLl8IeosZuLgQMWMeVUSGtCfuLShGayWIAH1aY6dxEyzrIRHnZ0vHuN+gBsxnfB6JE2eBseI9/+WesCMW9DuhB/a0QQJjFnG0Ib1EmpL/xwy6QC6nHLTRKE3QERxai5Zlg3LJKJsFeo8mtrqXU54NA/NA6dSMs2AN8Ijz0qhiOn7l7UakpbcOWgCB30S/nM+ctlm9pBZ0oCbovDsUD9lIdOoywEu9HGjBZJ2GCaNzKfMzDJ6OWdbtiomPH/kY+7PM/rfjbJ9iY3WzVL6chdclrezC7mTJVoPQopRS1DQyUNcUbqwgmfAgRmySIsRk0n3t3fhPxhzQcivjnPOaGuFClnevDy2f/Yc8hAK0CGNGRU+OprzN6467TdV/nH1ETK/qA0Rjl28TW7Un6odZ3W7KWhEowBfmtbDGlG0x1UyCKCOJkN21yBiNfpztAsyHH+FWJ8AZb2fZvvqE28zMd1flWDKy10fguDzSeuQPrk/R6auUwp5SzSLNi+xRYNhS/lzroRPVmqwvXjvADYpQu42WuNfdx99fwS5UXJ/16uUcigEQoBNhph+grvfO6RcwQWlHPbxEWotBzRdgjU+IIqxnCVoC1xv1lEgRn51B0J7CaDjBcTzhvfCNk39hgsV7f/8wwKJzslxeoOruqtjIhjLSzJk6Jy68sPOx8AYLL1FaVDsSMtgt0P1Ty+yUyr1w3az
 nbhWnes7
 LhZ3kw4xji9NtzAvofUCw92C/qZQeuDIKXYR/Jq26Wr1+Aozl/y7RNcrU2YbqElUz05AJ9fK8yhERhOAJFKDK0xtucEDkHcejxgOkfMW4IH7ZvE/Uuo3lt0F4kLVRlBd2BarwIsF71Ke0vHGa7JcKPomlYZ29CmoMPPDmURmQXm8QOxfAwYMdrl0U1Vln1fIE0/yh7kcnZ9VV2Nir2RB3sMdsHIlsvSoqchE14TzAxKWOSyBvh+izZHofmQZGKP3UOepIXSd4qp9cSqvZOhVDYSpO+rfeF8+HkOdw6r6kCUWBVJTRIgTDYB0wJtuJnjVGwGtQ68dd0fMtmq8Nd8pBVfeppjzYDOr0eHga
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 13:59, David Hildenbrand (Arm) wrote:
> On 4/9/26 12:56, xu.xin16@zte.com.cn wrote:
>>>
>>> Hmm, maybe we could do the following. I think the other members are only
>>> relevant for the unstable tree.
>>
>> Well, I suspect that "SmartScan-Related" members might be also needed and used even when
>>
>> it's a stable rmap_item. In should_skip_rmap_item(), if its page is KSM, it can't be skip.
> 
> Yes, needs some more thought on details. We might have to ignore/skip
> the fields for stable tree entries that have not a KSM page.
> 
>>
>> What if the rmap_item is stable, but its page is not KSM?
> 
> I guess that would happen if we had a rmap_item at that address, and
> then changed the page (e.g., COW).
> 
> ksm_do_scan() would call cmp_and_merge_page() after obtaining such an
> rmap item from scan_get_next_rmap_item().
> 
> In cmp_and_merge_page() we'd call remove_rmap_item_from_tree() and
> recalculate the checksum.
> 
> In remove_rmap_item_from_tree() we remove the item from the stable tree.
> 
> So we'd want to ignore the entries in STABLE_FLAG in
> scan_get_next_rmap_item() to then reinitialize the fields in
> cmp_and_merge_page() after remove_rmap_item_from_tree() I guess.
> 

Something like this on top:

diff --git a/mm/ksm.c b/mm/ksm.c
index 0c6bfed280f7..51fd37ee24d6 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -905,6 +905,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
                VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
                stable_node->rmap_hlist_len--;
                put_anon_vma(rmap_item->anon_vma);
+               /* Reset pgoff that overlays age-related information. */
+               rmap_item->pgoff = 0;
                rmap_item->address &= PAGE_MASK;
                cond_resched();
        }
@@ -1058,9 +1060,10 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
                stable_node->rmap_hlist_len--;
 
                put_anon_vma(rmap_item->anon_vma);
+               /* Reset pgoff that overlays age-related information. */
+               rmap_item->pgoff = 0;
                rmap_item->head = NULL;
                rmap_item->address &= PAGE_MASK;
-
        } else if (rmap_item->address & UNSTABLE_FLAG) {
                unsigned char age;
                /*
@@ -2465,6 +2468,10 @@ static bool should_skip_rmap_item(struct folio *folio,
        if (folio_test_ksm(folio))
                return false;
 
+       /* There is no age information in stable-tree nodes. */
+       if (rmap_item->address & STABLE_FLAG)
+               return false;
+
        age = rmap_item->age;
        if (age != U8_MAX)
                rmap_item->age++;


But it's all confusing. Because we might temporarily have rmap_item->anon_vma
set on an rmap_entry that does not yet have the STABLE_FLAG flag set through
stable_tree_append().

And then we magically call break_cow() which does a magical

	put_anon_vma(rmap_item->anon_vma);

(this doesn't look correct in once case) ... anyhow.

So we might want to reset the pgoff there as well, OR only store
the pgoff in stable_tree_append() where we actually set STABLE_FLAG.


-- 
Cheers,

David

