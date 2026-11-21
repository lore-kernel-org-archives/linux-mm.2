Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71047606A333
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D5NYVQNy
Received: by kanga.kvack.org (Postfix)
	id 808096B00EF; Sat, 21 Nov 2026 05:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9CB6B05B0; Sat, 21 Nov 2026 05:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D01B6B05B1; Sat, 21 Nov 2026 05:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 520A76B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 05:50:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7194A03E8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 10:50:18 +0000 (UTC)
X-FDA: 85458806916.30.873AC11
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id A922B180005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 10:50:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5NYVQNy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795258217;
	b=Alt85Iw33ECAaKs9DsEJpbzKrK/lp6kPUs0i5cnSL+gd91kZ6XXf0/+o2foUQphR8TpOag
	bmLfaouJmcnsUBeH/+VLRle4VOJLTXOdJcUnj1TYNc4tYkq4+t8nop1FYOET+VG5nHfVAe
	QdXvyQlIz7GUNPXeEIPXAFjyp0aCfcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795258217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMgIUwgaRDtqFb+dCr3Uz5uFgrgh0VgOFSH1MBelITs=;
	b=JMV2YW2Pd7KohRtJWqcMKiEWHUAgG2O5LoKMWX7NQT2QIm4vmjNAmP5Rv2oZ9KqP9Wz+ZM
	c3PHfOX8wgvxtfCQxJnixK+bkC6EF6Z84ab11X68X2EfUgpPHlt9A5aY8Mttheqev479OM
	vJLT+Pb0KqdLpKAdVlsOXgops6BZGFk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5NYVQNy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sfx+nUxKF49z2Q7WoOfZ/Q2qOCkr5Uy2iYFOKJnNr3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795258214; v=1; x=1795863014;
 b=D5NYVQNyU80tjtVZaMf4S5vxCCyCJWB/3sk+o83+MSTlvyEUikHp1hopIYZLm6xeJeZPC3Xb
 rRYddzHLglIXUTSKfN97oiZpXx6SIelCjDudrg/gziYMelv5JP15Gzus0yuDF0p4Z7m+hoJsKri
 LP9sIVAi9Cpx+sd0f3dZ9Rh8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fce2ada30c03c903;
	Sat, 21 Nov 2026 10:50:13 +0000
X-Mizu-Trace-ID: fce2ada30c03c903
X-Migadu-Flow: FLOW_OUT
Message-ID: <dcf13dbe-f843-4e21-80a9-82214b501f4e@linux.dev>
Date: Sat, 21 Nov 2026 18:50:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
To: Chris Mason <mason@kernel.org>, hughd@google.com, david@kernel.org,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 qinyuntan@linux.alibaba.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120195057.50031-2-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A922B180005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: csqpc6kewhz3zspxn7umrah47rcndhwk
X-HE-Tag: 1795258216-328986
X-HE-Meta: U2FsdGVkX18Gjtjw0omNegZkXsxiJu+ae3u6P4EQwXkJ00Yp6MX89Nspn/3e6QRur2R7kjGRCRsUiRg99vmbQmmsCWLPb8FvqszOHqxVSt9Tc8KvoD5o0owqqRRDgXtF5jEOcRTSAF+H6reKERl8KowYbQihnZCOd1aec872kaA76q+Dxqr52NAewBVLLnTIPDQ2uDLUwnY4gmb32U6b8AwLUXQg5UgDTWnCBWbhUrj0pTTgB1npxUwxw8S1REkMicbOXmDkzLEDaCfII4wIrug/MvuKFvvXHbWC4S5QaI699wexKkh9s9zmY2gkTLKVGqzX9C5jTD9KLaZhI2QwHY+86la3kKSmfyNyevX0/pTFeFMpeSI7KQzpSTxJiQde5QdClG5hOuBwStqorufTTOjMSNnjTIRmfO5aEc+GXqhu9AR62mXv/vYpx1TbWfytaa2AVO+tKtHGst4YDgksNb/IhU69PisMZ5hz/zbL/XDcCVLw2x/4MRPZxYQTVuCeseEvIjMNOXwUw1ZNfjZ5UWtwkYom5AjyfbwfI7ovRs6VRf3a1P9xMYFbmBpZ4EUulRZisdWOjEZQbCyvv3lRyWiK//McH9nbFujulPGe7dS+SW15hK/UhYK+mJ6b+atWw+Uh7S02QJolViNqWSlzB9+6/7ahuHek2AEthm8gROq+EZnE9z19PEsQcyFtWzSxGNjIHcJ3UCILPsbhDa0gYgUWwo8u98zgEGa/j2tIHDpTVgrOF/GpQlLt5KGVoTXZGd10brF8mM4WJhJb35b3Ml6P9W6PZeQmlhs4AXBRvUWre2yQaONoXq4GypKPLoZ5aixoRamxweSicssuzsskFFh340WLPcKFWcrw27B/QsAfZed5eUUUgI8zoVij3BdUDm4wXwiUg5gyEhb4F6XlhW4vjbbAbNK/Z+9KiFkvBRzq1Jtdt7vgbr6Ic8WigVmu46+w5fhHVJhdmTU2BwP
 tbAYEcii
 wYFR2+0HbKUOq0cGE4GDfqHiH32f4jwTvnC3kipEeyZFG+24GR/6bScLYxl3AVesteaoeWBW4hMcL19vr6uLPsCJacRRz7196j1lhCdCkXLy4lKxPnErJHVZENpKFReS1kmn4XrXe3JghoX4mrRpCrrj1uDzcGOgkLRQoh8VbQ1Iu9lYXNe/708Rs+o6cgy4rgSSR0+2tsqgppd++bnkrkIMSFTLW1dBtURHrF6PmT8LMDt6Y7OiMLRLvPQCgqiDvfnQCb7pl4y8XjpfWthh+a34LCOpLXanOpN37GhypesBJJO+d6Xo+8deVyqlXudpIH25gc/dW10HY1yQCINo51t76yhbCHA11l3AbvxTCZbxc99iP1tXmL++LulYeBZYPANuxjwe05CI5v7isAunBaS/J8YmsPAMG3l90PogeNtf7YWH1OaW9R06P02Av/kNSt1OplvCe7PBPvUMztLmHJx7iZhnbFuYvvl5Ewns7M15y0CRQ6TWPERkSU7/6gLM8Nkl2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/21/26 3:50 AM, Chris Mason wrote:
> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
> if it races with the migration of the folio at the end of a file.
> 
> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
> But it is NULL until the folio is charged, and a migration target can be
> in the page cache before charging.
> 
> shmem_unused_huge_shrink() looks the folio up without the folio lock,
> so we can race with migration:
> 
>      __migrate_folio()               shmem_unused_huge_shrink()
>      =================               ==========================
>      __folio_migrate_mapping()
>        xas_store(newfolio)
>                                      filemap_get_entry()
>                                        returns newfolio
>                                      folio_trylock() fails
>                                      shmem_unused_huge_requeue()
>                                        folio_memcg_list_lru_alloc()
>                                          folio_memcg() is NULL
>                                          memcg->kmemcg_id
>      folio_migrate_flags()
>        mem_cgroup_migrate()
>          commit_charge(newfolio)
> 
> Fix it by keeping the original objcg around while the inode is isolated.
> 
> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Chris Mason <mason@kernel.org>
> ---
> 
> Notes:
>      v1->v2: adopt Qi Zheng's suggestion to return early in the
>      failure path
> 
>   mm/shmem.c | 39 +++++++++++++++++++++++++++++++--------
>   1 file changed, 31 insertions(+), 8 deletions(-)
> 

LGTM.

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!


