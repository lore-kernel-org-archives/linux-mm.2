Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FB0606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbdlsP83
Received: by kanga.kvack.org (Postfix)
	id 6A9DB6B0685; Tue, 27 Oct 2026 06:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681B16B0687; Tue, 27 Oct 2026 06:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598386B0688; Tue, 27 Oct 2026 06:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1A56B0685
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:13:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1322409A9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:13:24 +0000 (UTC)
X-FDA: 85367993928.19.C522663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4F3C80007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:13:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbdlsP83;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793096003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cka5iH+f4CbA6h635wyMcWCPwiqQPm4mJkPl8r728Is=;
	b=Us8W8+bhe+qE+2AbgXC9BcH4ptw5HCA5UJ2Qt73yhjW1KGHEAdTeKbpBkiGvoetQprxQWv
	6q+ByLk0GAnXWKZAJv/zyGQui4dxrSLkQIyyiNBldWXwcOzNHV7Jw7CHdIqRoXtUTR/9aa
	9ZoOxIqk2aHUszkOflvVhqGg7OgOlYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793096003;
	b=spmugfwl7VTTEPJfhqnJS/+ijw376LZyouGWeGKE6f+VNJqYhE6X22t5EISZkZpDmJmcD1
	6yB4FbL6To4eG6H3qgwrkqoCoNmnnTQYkevqDNh/v6YI5cQmhpPZUQTUaEZvvECSlBpRTM
	0tlb5oU/qWMCorzbwZE2xCYZ6IVN+KM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbdlsP83;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3787C42E22;
	Tue, 27 Oct 2026 10:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EBF1F01825;
	Tue, 27 Oct 2026 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793096002;
	bh=Cka5iH+f4CbA6h635wyMcWCPwiqQPm4mJkPl8r728Is=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RbdlsP83pI0g/GUuM6VbZ/P7fr3ctS+PR6qMg7VJjK38uiDEInGcgR8axZzFGyzch
	 Xu8ztux3zdWT/cyx43bEg029AF65TcMp6iUv4cfkEpEGcwA5TdhzIlkR1JM5IBiYkS
	 scMq6PvraM+qnz0paWREPYrC4vjw9IkmsHcfuec+D98dS+YOkzzEjLYhkjY44jJiRf
	 0rHtxNgZg6QQ+IpqUuHkD5F1Po5gI9bi5/DwYKYslq1ccb1h+m0ry7Ptpvr5G4QivF
	 jNGNIs/fyfOoWObaQePwocAIqdd/Pi9bPa3VTfoe3KnH6uMFPOkKoCGDR9+NqE/nuK
	 AVGed6pJRYBjQ==
Message-ID: <3edbd664-a6f9-4344-8a6c-6e3feebf728a@kernel.org>
Date: Tue, 27 Oct 2026 10:53:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
 <at97dZY434e1maVl@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <at97dZY434e1maVl@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4F3C80007
X-Stat-Signature: jq9jkk3qqmi3yq41jtdugnri76dbg3p1
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793096002-62180
X-HE-Meta: U2FsdGVkX198rNbPJeXxilCVgax7F/ZpLQMMjHtkJbsRb0l0jBrfLqtwUltJz+HAJTIeWYRq4XdS9Vk4EBdRFxyU3jZwg8/4IvLGysh0/Ene/c6QKhAbbvfQW7pGxhixu87euBSnIQJkqxZVKqaW4XPDjNdH/LeWYbbNNL00504mHUZCLUoJNpE7hHWGqlXHUdskDTEaySu6p39SwqoC3u9y1u3lkSgsHvjbAoJZZHPS8o3ltDPN8cM/3YZcY8/R3u5O/oRsQ9fwz6xq8Og1YeW4xd4uS7UxSgZI7TscVOYBGRUBj1wxqHGbFjh2ea6YnkHD5D4gNaoR1Q2Vn9hSUKZ47Li0I7D+zuVgPwWGWExHyN7CQmHyKbcesOsFKqC1bVmXvy7ZpGMZW8C8SQARBLAm6bQStH7DniTHecovaXGEI0AOzwOIcE4I59QyXPNHsvFQubcw/UVc43zqYCz4Dyc2pFZijFPxboZqCoULV0UW6w2wTQDxtMTdnnwqfyTDUypUMpkDOHCxKdv35YnHpif5xu3TI+oG7Mlw5A8EYRXZTs2qwKXCBxfc0yvH1PGMFrGqDyZWXXMYGNKUgWQR997cu+CF93ZLDzv6Vowoa7rG8qdoVBOGFcC554egCS0NKByZMXJ/4iQmeRik+ERkoJW6sX3d5IWrXgKesRsvBr88FHp4m2dqmgpJqXbIDxRA7oc9yixdCkLBoN7pvBbWh4W4BF02hWrVoKXQyltfwh0kBSiST2lyq2Sg1xZpqKgs8x0jWHXbUSHF1JeOSckVQJxEMV8q7u0mcHvXgJlMPbaPXVknANDFpnLMy7LqReuYPGASdiQFbqtJulgvAtlo3FiUDiyyDdmqJ15brGdzzYY6nvuuDJ4KUdI4xwdKV7ni8B/QaRHM4EPVHJJXO//fS16rUM4LDu8nDhTwq66d8OrEE0miHqGTudQEQtmJNrh8kpDNNzb2EuKtAg/ZetT
 AGHVBV4v
 7fAH7zjXuHeTOzq3Z98RJYZHUrTsRdUK3PpeWCCJme3inU3TWSyi47762QP5/RJWuLkZqhfeZ2rWzXG7s1dmwTbkC1eLy64PyHmtPCQtMYdKGYMVHRiLXl3Kfm030XFgzLXVBpvHx+S0kjSd6+yijSpUItZKfKcNWQTFH85l0DxwPSPTtXJXR8XQQ1T0SfwqG0InzVFbyC+sq7zhrc12pkqspGV4GzUKGr6XgZe+8NubhcbWnGedqnM3APyBqk85eZ/tLhrHAcUg8L2CXigEiFj2a8b2k40WliKgEgBzBCfCenwLqvl0ecsrPF11DzhaQj9MdZdQN7xIdgyGEKLf3ZMv95Dp5YRqf0Bhlbjwud1kN6+CHwW2H7iRjiXhFnVbQGpcskGhI5h2y1bT0HLDs1ldEFwHXmxYBdclWbYic9LU88x4Hp6MA4FGhenjVlRlfDzef9R1Q+3XCpGvD8lPNLJ0Ppw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 17:13, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 10:40:39AM +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> Once shmem_writeout() has moved the folio from the page cache to the
>> swap cache, the folio lock no longer keeps the inode alive: truncation
>> and eviction find a swap entry, free it and do not wait for anybody.
>> That did not matter as long as swap_writeout() was the last thing the
>> function did.  But since it puts the folio back when swap_writeout()
>> returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
>> afterwards:
>>
>>   reclaim                               last close of an unlinked file
>>   shmem_writeout()
>>     shmem_delete_from_page_cache()
>>     swap_writeout()
>>       zswap_store() fails               shmem_evict_inode()
>>       writeback is disabled               shmem_truncate_range()
>>       return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
>>                                         destroy_inode()
>>                                         ... RCU grace period, freed
>>     shmem_add_to_page_cache(mapping)
>>       xas_lock_irq()            <- use after free
>>
>> swap_writeout() behaves that way if zswap is enabled, cannot take the
>> folio and the memcg or one of its ancestors has memory.zswap.writeback
>> set to 0.
>>
>> shmem_unuse() already added infrastructure to deal with that.
>> Reuse info->stop_eviction to protect the inode during writeout. Increment
>> it before removing the folio from the page cache, and decrement it after
>> swap_writeout() and any attempted reinsertion and inode accounting.
>> In shmem_evict_inode(), wait for the counter to reach zero even if
>> swapoff has already removed the inode from the swap list. Add some helpers
>> to make the code easier to digest.
>>
>> Fix generated by an LLM and sent by Josef Bacik in private.
>>
>> Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ david: code cleanups; improve description ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> ->stop_eviction is ugly, but, oh, well...

yeah, I was not particularly happy to learn that this exists ...

Thanks everybody for the review!

-- 
Cheers,

David

