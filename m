Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0311E606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfnvbJL2
Received: by kanga.kvack.org (Postfix)
	id 256A36B099B; Wed, 25 Nov 2026 05:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C776B099D; Wed, 25 Nov 2026 05:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169926B099E; Wed, 25 Nov 2026 05:26:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E55786B099B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:26:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D0311A0D7D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:26:28 +0000 (UTC)
X-FDA: 85473262056.22.96D2792
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A7B57140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:26:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfnvbJL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602386;
	b=EDuLVjwWiG1fPVFvSNUneWK+5gLCEcNU0k5pmoYEZfkFtBXmTTmrY4lomnIQfCA4BOUodt
	B0d38E0Bv4XqszfjUrA5rHLZTIn16Fpsh9WFBDG7o7vy3xQzjHHPaoPylDFHYbslnucti4
	r4phEmCMU60DRLNxl6Br3wmY41mOCq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJW+afDWIWxoDSAbl6TmjU23FJQuelNkJuMFpjidvk4=;
	b=NoSydpKcfT2WAN/R8ziyqVT+Z0EYI+6GbIlw4MnD8eicqWmGrwynIBozRiwGCV5K2UjmhJ
	93X1mV47jXIueLQDuzkb9N+R2XNPxe5fLGCQJRbTRtBn8hbblX+DE1O3iCJw13OSzjlLre
	8++w8t4pz0hm9f/YsHTs+L/7uuUa3Zk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfnvbJL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD13840665;
	Wed, 25 Nov 2026 10:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B348D1F000E6;
	Wed, 25 Nov 2026 10:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602385;
	bh=uJW+afDWIWxoDSAbl6TmjU23FJQuelNkJuMFpjidvk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lfnvbJL245K8lJcAFkVJOQxmtu7shESOrpPEWsC3LVdjwIZfLVxcE1yZgivknjoEF
	 VF3AeNjPG29BGh7APelu1Aolivj1Gp2ZxbCDGabJREAb27oEGZRUsYcTBFahyW867o
	 LpfNrzZcxYD0sG6cZM2lWngo7L2CO6v//7ujOxMkDMR9+0N5SzmAy95HbXiArUDAMf
	 wmycAh1w5nOdE0VDGXc4YnS1RfYx1ZFafdEQjg0e69o0A6yNR98CwtjIUx3jiDDIWp
	 gLN/5Imq0/+OmfC+cu9VCZjzbn433Z+9N4sY27fpUx/os4Nl0rxfD2muBgPDSyukdV
	 1UacFPyJPObNg==
Message-ID: <b80c30ab-d079-4d8f-9ca6-4c51582bc8c2@kernel.org>
Date: Wed, 25 Nov 2026 11:26:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: introduce mm_slot_next() helper
To: xu.xin@linux.dev
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261125084205.345860-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125084205.345860-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A7B57140003
X-Stat-Signature: j9rzfmy1gstkuqp5xhp7af71r9mnbpj8
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795602386-850949
X-HE-Meta: U2FsdGVkX1+kDkQZ8mo3a/NJsAmRzEVLpdwDjJwT1D7k3vK+iD88Yb4Dzh7QmWbep8es7tIeBuI/v0vDBVr0IqzGPE8wnRHVaIBLsqqq4MolwnmX0VjhE05DdBiSUO7Aci10b2kuZRV2dE2q4Qbe73twzx0OlEYthYu9ghtXR8tynZqhEmibVV/7VLDBffEBKVjaPIseLM3g04lqrgXjDxwIq9OzyMaJwaIo9x1zNgCtNbfp6a0aFinQtwg969ZfQmzrVG/PYtGbw4W1SvtEDblKXKZJ25SR5Uf6l/b38KtwsFnIj1GihSW87sfdOD7/nphtWRrUFUBXI2WOLKXhkjEbyC16iTCvdZYZbgHGff5TOXzG/6RG0ZyR7cZWdF0j0OMpbNlzgdXvFxMuzLg8zQ6UraSdf3vEDjTTLQLGbt5uz0pKNbuBNSXfqLX9Vlad0Rs2QUL/+j59xE1IeTyTQmB144nO+q+7xbMEFxO9Z+dhzf8Rm6wwivenJxAopIaLPlw4jUgQq9eZ39PJfsuqv+mS2G0rArBI+LppoMhTOIqJMduR4WZzZEa7jGqAssvioOkOn0BlW4Etv+x0aeZq8WHQ1ds0GLbqR5kPeObB/7dmKO+nFuNuaSsbtovvxK9//uBStJ74vSYQ/Ph4oiOyODph2b36+4gq9EKYwOdW6uWtQGCCuZjNxTmgU0EdxqQf5KrE7pcuzvP/DIrEx6UEDJnuLprQxUfObjwpDPIJbWZ+cXcU5mUCgU/fI1flwTKIO9IAX9qVJrxsmUeHPNKF9pPcw/Da33dQeC6DrEnnH8qwyyPMZFOg0wEgbtoQN4if0NeUAl45f8jeAb3jk4eFS87Q6NLeF2sTpp/cBdPjZeFIn7eYVvYpQuw8TiTkO32ZBVcDyZGLL57n8TLoYAkMEKeGzls/GA0cwwyXA6zLsUS5XR5hfTnS7WpKnz5gHRG6IhXRWbumZUPhQf80sIj
 Jwkshn2C
 2FLv3jKYSIrjrpHwbFC2WH5S8Ejg99/XXRDmBnmYV9q5WFpnAzqM8K6hc7UxjS4vZ+thxVrUFwwtBN9q17zsNDmYB+w0e4RDCNd7/Fc7Dht0B8HDc8Ej6A+WU0RdFGdaOUGsoGwsy9TXHYhYm3kQ9Y+3xTt13RJO4qJytI3/rjvrOauf8xmbPF5FzbOfYiK6TjJxwvA/x+K6s0pRFiKqOiIs3xLrW2wDXRTSuG2K2Z+kQF0n3SswiVUAg18mQDn0pSQykcfNi4pnriOJOoeA6ADNzlwKka0G2AqD4kyVh4GmvK5UOGDR0mMsgUo5YNDeVv8oW6bW7qCjOazQB6NUiUA3/ZRJXfZSA485XBq+/pnJi9RPjPk8Q/xaDtk6tpa0OIkzH+Ua5S0B+gLGgFgWNd5o6cNevr+yc3P/qxHY6WRgJYoWR/whD72o42GfturgxA5W2BrwkJiOFBGyqhMRE8Nayx34MSf07o9JUe7lxHtNrMtT20WPTKdTvNS1mAUc/dp9gTyuFxs0gOsb9+ShmF2LgVZxyB1gLncHANsX4nKbdJr11JpMf7ES1PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 09:42, xu.xin@linux.dev wrote:
> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> 
> Add a generic mm_slot_next() macro to simplify getting the next
> mm_slot container entry from the list, and use it in khugepaged.c
> and ksm.c, just for cleaning up.
> 
> No functional change intended.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
>  mm/khugepaged.c |  5 ++---
>  mm/ksm.c        | 18 ++++--------------
>  mm/mm_slot.h    |  3 +++
>  3 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ceb1b16c03c..0a5c78d01159 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -3074,9 +3074,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  		 * mm_slot not pointing to the exiting mm.
>  		 */
>  		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> -			slot = list_next_entry(slot, mm_node);
> -			khugepaged_scan.mm_slot =
> -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> +			khugepaged_scan.mm_slot = mm_slot_next(slot,
> +						struct khugepaged_mm_slot, slot);

Weird indentation. I'd simply exceed 80c in this case and have it on a single line.


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

