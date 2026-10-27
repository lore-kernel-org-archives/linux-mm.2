Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B879606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BotLVmlz
Received: by kanga.kvack.org (Postfix)
	id 18A626B069B; Tue, 27 Oct 2026 06:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162446B069D; Tue, 27 Oct 2026 06:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0783E6B069E; Tue, 27 Oct 2026 06:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEB8F6B069B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:43:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB31E8096D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:46 +0000 (UTC)
X-FDA: 85368070452.24.915F10D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3904940002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BotLVmlz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0bWJxnleuC7KHlyjPlcNd7hTqiMUB+V6Nbmxy2tkww=;
	b=f1L6r0m4YHZ03O0mi11TjYWdIxC+lUBH8TxHSZLSGTg/FdfkAwcZ+30dFU4rTG7gDnuFbT
	MiHLuZ/ZR7gfYq8Hwhx5tJMcQetpLoo758+y5fOMZVNaRRITxCoHg/WNFsOg+rzXb1oLGx
	Kpm1t+pjKIXzbFJQwTQjUAkr8ski/LQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BotLVmlz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097825;
	b=bCrkliohg2SlNTFRgtrgkmAzUS0Fdj2pLwTumu5b/uWuOac9JjOfq98cSUHC7eZwJwfqIz
	WiDUVoSQgSitZ+6+OlCP1q31gzyDNC5qwsk9Z5Hi3He2bB/CUiGcRInisCWfu38y8QmMJ8
	bgtE7B496FL5B9cUY01NLFpQAbXPJtw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9E4D60236;
	Tue, 27 Oct 2026 10:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082211F031E1;
	Tue, 27 Oct 2026 10:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097824;
	bh=y0bWJxnleuC7KHlyjPlcNd7hTqiMUB+V6Nbmxy2tkww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BotLVmlzy4TZljtLczP71diLAjatbqzAQEkLZp7bs9LTerIp5Qui3KjuhQeeT4l8y
	 g6gDADj0uuPyyBR3/gn45tABr4F+L9DEc7hoSpkBt8FAsqG65DNR+ExxaJwzfI+27O
	 6A6t9+eSkEklG4w4NGD9aGjIUv8fmEET9xQq5AACqjr30EQsKl8n6M6dSFYBD8/gME
	 SAFhyJNtMsoOl29zYLOYHf4fLZY3ulEkDQAUjD+pvQI17pWO/bTChoQvsRdHyRja5K
	 OWIzo84jQYEScEB5hF+VocHW1TccpKKgvO2N+vIpntsTF00g/UjzLbZPiJyVQkkesr
	 PQdk+5cMK7eSw==
Message-ID: <699d2ada-6407-4758-82ad-927426ee049e@kernel.org>
Date: Tue, 27 Oct 2026 11:07:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] mm/shmem: preserve data in clean folios when
 splitting fails
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
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-9-703206d5fa0c@kernel.org>
 <at-GrQNgF3V_tL3w@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <at-GrQNgF3V_tL3w@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3904940002
X-Stat-Signature: iwnnst4qqf3dx9cdgb5xaaaf6wmpxbxk
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793097825-427438
X-HE-Meta: U2FsdGVkX1/1x46BJksdINZLkSfEp90YBT+/1L+j4aRy0kxut0h6c/bl1Ut+kjhI3Vk8goxSz2teW1wpj0svNbs+SJGmfC+8mTq6Re95+R6jod4maEzngb9ssOP8JnFm1JISJsVP0+o66L0iHTlFTYewV4/wTARfnhYHhE293KXbhcfm004Ep3xNPr++WKgVsrJ808OiXD91xm1xf2d7T5w4e1uly/GKjH89sBBZBKQYQGE29qmVNo3uyydR6aAfY8VL9TlVXZzKudAbg29YPNwvAU/Nw/5qHj+hSQ1n7fKgrTLv6bmgap3pfEJVxy+vGBmJc7nZhOJlgutuDj471G3g5ngqjr+QV6+w0zt8L8UCvI42NyypGKetUbm+q0VJmGmBl7TxHCongtopj+/aI9wz/SdlV8Pzg4RT+949PUFi1oK7BEqArYB9bJQKRGZ4K1/Gvgk8/rf4W/y1r/+CeNvObyMwvoeRynzvperDMK7C2gGHaReCkDbe1BmqSugxKAn98yJ63JymOcOOFwOQJ5cLgPQWQwkKLSRovvRDQ+dcGq1hgR2MEL2VrjdqXf34k6AZLMr9Kd9K5mQr3X/p0VIxCBKNG5ijkTdAW/KTVmYdtoAbScRjvLVhDP7O0/GWPz7rKYo2GrbF1yYePqwJc2oJ5cvCLkkYnOrQubKkaZxQm8wgoQFVP8F83EpA0hhjFjFO3bee9eF+h9+OVqWt5XhqRKzTWhSPnWprrCEMyxvsGfCu22WmvquzPR2VZVvTNaWUPSWJQXR8QQiid9O2V5oID5Yu4bH9pYBaTWPCCN97AvltEkPLO1PSI9lGStH+6IoakorR6y8bJZq1/+lrgxyHx3WSGXw+xWb/faPqpxp7EfwehAqTEy6F+pGIQujRgUeffmc6gk4brP3jFq22+/kze1NAols85IZc4YDm2zITU3X0zUXddtOGqOIJDScgrOXCVyE2lvDMWzPdoyX
 pRMsrqYI
 ta3Nyv8fc6EK+TkPk4lkaWDm3s/kbyEHgPHZyDVuOiL+CKk5++pGc6sJn3+QJxR4RTXL2ZUILtFvOELmaWa/uJqmRK15FGdPTNsgvklGesYYehSBtLSavgGZA6VIQBVaPg3lauzsA8kbwkzyC62RNQ+i6jralZwjQ3DWqz/6Cp2LwDZ48XjJUfNi4ctI9UbfgUs0e3oRwIHLx+cN9dmpfNS9cOPINgBFOe7BLoMiKtDyspsgRGqdUdgr4tP2uk4HT6yWbjRBVjZBieD1nUoIKzPn5xXiqVZv8SoHcO8RfZILHt5juvI5PQgRh8N11qhygDkyVyc8RX+i9vsEnu6AXOJ485/d52j3WAGEynqTUGniD+yliR9RfeNFKYWhjobhGsL7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 18:12, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 10:40:42AM +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> A shared writable mapping can have dirty PTEs while its shmem folio is
>> still clean. A read fault can install a writable PTE, and a later store
>> sets the PTE's dirty bit without marking the folio dirty.
>>
>> After shmem_undo_range() has handled the boundary folios, a concurrent
>> read fault into a hole below the new EOF can allocate a large folio.
>> For example, on a tmpfs mount with huge=always, the fault's offset must
>> be within the file, but the allocated folio can extend beyond i_size.
>> The final scan then finds this folio and calls
>> truncate_inode_partial_folio() without marking it dirty.
> 
> This is hard to follow. I asked LLM for a diagram. I think it would be
> helpful for the commit message:
> 
> CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
> ─────────────────────────────────────  ──────────────────────────────────
> i_size = 3M
> shmem_undo_range(3M, -1)
>   first pass: hole, nothing to do
>   boundary folio at 3M: hole, none
>                                        read fault at 2M+x (below EOF)
>                                          PMD folio [2M,4M), crosses EOF
>                                          writable PTE, folio clean
>                                        store to 2M+x
>                                          PTE dirty, folio still clean
>                                        vmsplice(2M+x)
>                                          extra folio reference
>   whole_folios: finds [2M,4M) folio
>   truncate_inode_partial_folio()
>     zero [3M,4M)
>     folio_split()
>       unmap_folio(): extra ref
>         → -EAGAIN, PTE dirty bit
>           never reaches the folio
>     folio clean
>       → truncate_inode_folio(whole)
>         [2M,3M) dropped
>                                        read 2M+x → refault → zeroes
> 

I'll add it, thanks!

-- 
Cheers,

David

