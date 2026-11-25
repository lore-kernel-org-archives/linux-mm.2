Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C00606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrqSbBaF
Received: by kanga.kvack.org (Postfix)
	id 6C33A6B0987; Wed, 25 Nov 2026 05:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675376B0989; Wed, 25 Nov 2026 05:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C006B098A; Wed, 25 Nov 2026 05:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3066F6B0987
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:09:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9708580DDA
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:09:58 +0000 (UTC)
X-FDA: 85473220476.19.21BC6B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D08441C0002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:09:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrqSbBaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601397;
	b=2GccBmSxmUQ0qm9eoOE8UpE27+1kqodtKMsn+UkoSvgCbD4QqjcbtPPxsS/y9nGcj+6SaW
	BfBXVwhm681zSWCHCbakeyO3ltim3qOwvdS6fKfSP8FkmHhPfdYE7+BZKy3P8LOSbOx5pc
	ia2qPZjZP+lbXEjUYO2yD0UaYGmqx+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRTq+AvY8ISbuT9KG/JFr78txoqaHjxW4VA3cGzv+3c=;
	b=Nq7Xy0AzCNCUtY7E50vGIMXp2UNfciBQwZfJXo5xVhk/sIXGI7ev32o/LzkGI+ovm8Vhdu
	uKSj+xRp0PybCTkkMYEZDJFyzi7xZBFG7MKS7i0LFsX2TAaaI8YL+r1WxoW0hxdj7VRH5/
	QTGdZejMUldxy5coCP33mRBLNsHM93U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrqSbBaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5511962557;
	Wed, 25 Nov 2026 10:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6DC1F000C6;
	Wed, 25 Nov 2026 10:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601395;
	bh=fRTq+AvY8ISbuT9KG/JFr78txoqaHjxW4VA3cGzv+3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hrqSbBaFPjP8G9n1TEpjd1nBDvi0kQZJPz2xrVHr15XyRl9owNVJwfef7a1Yj3Vtq
	 hMbwF70XbF4FHg0XftOd5SE0U8cri7N7kzR6ueyonVnqIPAYlJTqfsAr5SOmCtsi/b
	 LWsyq5YR+auu4GxdhholkFMxCQvDSCFOsafIs3vOQBdXmfO3jS7OzpT+eTicBotJvX
	 SLDtmESfq2cKhB2yHNwAEaUDqqsMgpw5es9IrjvQ2f8US4vF3f+DKAI6TgtUgOdgu/
	 wIirgCJP4tzsSKbnG4ctC58tWlsYPSCCv6ccjzIZ6JymdiuF9weLIVkzEI4AknvGBm
	 BVYqPJf4XXMMQ==
Message-ID: <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
Date: Wed, 25 Nov 2026 11:09:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eosdi5idnaut9g6itzyrpzocd8ptob1s
X-Rspamd-Queue-Id: D08441C0002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795601396-161159
X-HE-Meta: U2FsdGVkX1+mfdDPprhzinFTMANgwxt+iVgOui1xEBR0FMJ0iGRbUqYz/vFtQ0oWyX4mwLNoh1r1U/upMMASZmtoylSvOWUDCxW2GF8Rh0x2T54Md1/J/dMHFYyAYvOjfYcM/x92vG3hs5Y/evPRuKqGpErLohgPN4A8hehg38Kgemig1aQSlZr9GkYaOBAoGc/P3loo6meiJg6W/W+i/8d9k9/jnQs2k9cWcOQnwKVQxbOzsyGQ0P54MiB+vz2MueSACA4Fk66C7Rx2Oucm12eH+3nCydKrCYy/30CcELcvYNUjyx5b0+apSrRuDQccSjx/Hk06TD/TxoQu/jF5LqiMNez6rqK2HUDZR3QBO3WHD1OHBqbRFbyYx/5YrIhAlkTeqqMAjr4a1HPN1IEIv4zp8lw+EoGKO89UjD83zxl4ITXvpHcFFwT/Epzsfrv7ewGJp6VBVQFQzXdgbHXezyyP0/2wW4Z+IR6h3HQQnSolMrIBPM3jecpV7yPyfEhNtPF9JawTrQYhsg74/MOJ3YlUYS3PbIY4QkR/P9uQFPrLPoLMOrH+E1xFiyIjoi8gOkIzcM2BkrdY/9pTAcYT6yXtSZ8xD4NLCb6XQ9jXYZlg6rHr68PRiaEXcQgggxxKT24Rdn9UTwiSAMbbXlCz7hmRGihn1Ob39CnfNPrC9yumhUM/JQL01ExxTDo2irK0GtU1zUi7D74MjVYUlXVd96tAmE0yS52eNe6WJIix0LSIu6mKemyhcbMHhQUWGbyG/5X0DEY4TW/8W26R9TUM19LDHLuKJ3gmMfu3YBZ2PW4x1EGnBWYoVT8brPpqazWEkHoMIaXMi+nh7GD4SV2S6hxKzgAxGm+9FoiNrChaobz9w21B4KL0kpOUoEz+X+zAyOgGnD+eEabvnlEvZR4kVXxlS60vO+tQuxVO5lE8dWvmz1bx60IGfpd1gEfWOhnrtVRWdq2kBLl4X2ivBLw
 yjOwl5dh
 jfk2jzIEKlNNJLOYNitQZE5PughtbBccYhLybx8u5OgvmkrLpglRuPJV3bYxSq6vGLeYAROrQtmUyZyArXZ4Q4XyKIWWi2+1waD+TQll2YhdSq006Hc9c8RhLWYbRtB5+9kbGpR9YN46HIQYf4ccsZ+r/gnh2/QMerJ/HblY38RuKjmh3bONmLveGFzHv6N1P+oHr526Lkyxox4sG2mw7KaHJSBYQZ51ackYe7dedod1nipFyawn3jtOGPsONKcUpgdTI5v/5ksTnfVGO2Zg2qac0I11xY8/9uhTEkfT7kj3oCxx4n/n0+xpN//ud1IA3ozbdEjbCoBeXJAMTeQhSrUq49orL1+l4tGFHUNv9DL0tImFz0r6fJ7N1IMnyU8z0VDSzA9Bngh+9echBTpGDeD3soMcXhDH2hnZZUIzD9MOeKOV8+jm4QSSz+69oQmP0mU+wq9QZV0wiRKC39rDCmmjLg3+YRmxMi7vIOPWrYS2bflp/1gwJpOkmww8JKJTlZZWzBaZ815IZfJibm05nl8xQhFfzGEJELrYBviHsndVEe1GqubSQplIChmbzmWfMdrTkPGzH9qOAvG5TBRrr+FUPNIQQQT6x3XKzBupP/amnWlkXqiGrwGAXqmIXqLLtrqx5Qg+avHf28yebGLMlub999v0zFLh1HntPF2ek6vlOibj2yCCeRAxf5hicUdM92YRU02ygq1aG4bi52aHCNwiyFseBn97kJFDjR2yVloMs+TSjH4BQuTOqqoPx2ipqNyN2sR9mhrxKuAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
> 
> Right now it only checks and sets the folio's referenced flag, which isn't
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.
> 
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 75e8641bf9ff..fa9f6d21e786 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>  
>  	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>  		folio_mark_dirty(folio);
> -	if (!folio_test_referenced(folio) && pud_young(old_pud))
> -		folio_set_referenced(folio);
> +	if (pud_young(old_pud) && vma_has_recency(vma))
> +		folio_mark_accessed(folio);

Can we just have a helper that abstracts that? We pass in vma, folio and young
state and it takes care of things?

-- 
Cheers,

David

