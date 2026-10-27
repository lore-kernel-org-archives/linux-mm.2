Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DA9606A328
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLh2i4Pn
Received: by kanga.kvack.org (Postfix)
	id 533AC6B069D; Tue, 27 Oct 2026 06:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4F76B069F; Tue, 27 Oct 2026 06:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3C16B06A0; Tue, 27 Oct 2026 06:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E53B6B069D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:43:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98833140994
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:53 +0000 (UTC)
X-FDA: 85368070746.10.3A86493
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0DD7C000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLh2i4Pn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmR+vZLuWo/MOqGjjBOdrO5nYefFznZmjJsKNuauJZY=;
	b=67cu8AswHxLw9UODcSl7aURDklwsHz8lerK0YnVeqGt2PVa83KLXuhbf3g2jJsZ7jH/t8V
	RQwFcGZSIgLDhebj00pfixLC4UXw697i/7Re8LPr+ZMxLJ5nwqPCJf2VGcgjvwQlYnWdBO
	eEWInypieNzQ/k5EbvR8/aDh5C/DIL4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLh2i4Pn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097831;
	b=mCucxnk9IPzNNoqz6j58K9w4dJkcGo5g56n/r3FXhQp0LtlOlmYAZN3YXmNrHSco1JzdXD
	mgIKhReVJOimCn6kUpEaZEAfGfngKU89ouVoC2U4fSyFXu2pG/L3YGSCrGYdn8NWxU20BE
	uITqbNKDmr01vj2lyws1/qhSP1kUwR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CB8F6022B;
	Tue, 27 Oct 2026 10:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C01F01829;
	Tue, 27 Oct 2026 10:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097831;
	bh=PmR+vZLuWo/MOqGjjBOdrO5nYefFznZmjJsKNuauJZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mLh2i4Pn549MOAtBAwtTl7y/1OVtrnhp4rO0PbVy/V6UmYdAI3NtxKLMphuOG7fLo
	 wblUgc4S0AB7lxV1rH43/mDzSHF3W6Fynm7taDJXc1bX2QL4Nti6g4BSRnPmyk/DiO
	 lNS7FaWQur6QkV/w+mv7H8Wm50v3XNiFOVIguHWqQ6oSLNB4R5+4WSZOHQkxrSuugc
	 CMuIVKXwgrjt2zoc+cfKUOK3c473SQp01RiT5Df8tKOgu8lhdEcdUXMMrkXXCKHppD
	 D83cximXZrxDk6WmbRv4v12unJ6ypdppHtcvqEWZQjSiy2ajbp1AztlNYQOhLWSW7u
	 fD317OsWCcakQ==
Message-ID: <b30a1c50-2db6-4376-bcfa-3088ce5d68d5@kernel.org>
Date: Tue, 27 Oct 2026 11:12:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] mm/shmem: rescan after nonuniform folio splitting
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
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
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
 <DMF9OO106FGX.3P7TZUBGHUFII@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMF9OO106FGX.3P7TZUBGHUFII@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0DD7C000D
X-Stat-Signature: w11aso99z8qqzejjzhdgd1733eob6fwf
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793097831-872307
X-HE-Meta: U2FsdGVkX1/WcM9gAqxqmmw9DF4VwWQJl8np2ZZtEOyLlEDonXMdQWt3IJ8NKfBTqhhGJRwyNNloJjYUiQVBtnJBpUPdtshZg+EsNnTPzoZeIY3z4DftPKdEFp6xxay+OnuQYf05KkiT9anp7SqJ4Y2PgJJ94kDIeq5Kzgct7SiC7t+4Nv1viX+HZ8ae3/Ml7Sd8/hlx+wrqAiCi83z3a8rtQO+jDiQBo6Fukq+wmreDCciD4fbH0yFV//PCDlOxBfccLMgDghzK8ch/ik2/7WEAVzTgTgxt8F51hMUCEl1pkZV0h36/EW6TK0IPGTQooA4ACEgwQR7s6t7jPnK5TPlDELCV6rrPRqQQ6o9m8d+PrDuqTvfNryJDmCafFnWGro/C5KaQYiHzpFH0NO600hODAU7lA3/qjdM/hJTSGWeaASUmmXmeJypinCcn2hu8YpvNHvXTyTPzwv2DrXRivGI/WIBQQtqJSVrW2/vFjfOythtmOO1BuNSGcHilvXTRhZ31Tt5a6OPIErsDGiL9vidqTenVgywpdl5xn1w4DSRZ9J1v1ejKuAlMX8GLtnYG90/PBXFE8hPry7UmIlh2e7J/uPOxEuiQdQWeo0TosOUkog+zF9N2wP08REBLttKe4zgP1dvwH5OXQrkcQZaqGZL/UqZ5UMMRp8RNYeWUoUTFtthm3uc5p7BjQ0Ho+nCmwuk+XzKDVTxCsE4SGIXpxNgFoi20Ir2KQaEbWCKQq/SOvjODS/38O9Mpzqr7v+Peo22oeXJh8dd30HzG6fVc8AycFAPOr1XJWJ4lQ6CieKg+SiIKqj/FuRrhAPItgh5n3ezT0FZ/Ron2dc/VfdIBHT4liwUYXaRmRyeq9uqkJog3FVbmP1gXwXYnzg+LM2fteXz9HMcqTNtwMP72pkJXZ5UGLzFynab4JAbQcGSi96xr09ZjbZviDLXepcNieSmuJoI1s7OzDtgSK+OoJDY
 zrcFEHBo
 gMKWOnvFCQIQoqR/Ec2msDkgz0ORCV4Wx1J1yipPNk7G8vnR3iv2S+EsWbe3sVoF0j6b4PeDSk9RyxO2V3hBiz3tZmhzSAU8wL27I4vx+LSDoLgqJC0BLTWYWfHZYcIQsjkzJ6GoCbp3jXnW4MCj3Sf2/gzZSOPmzLG8WwMBRyIZCcFpSWftnlY00ckWZb9/QzheFEaPtFrzWfWc8XZYAa3JdZQHdiZUrdYDiupdWzR0Eopu73ayTBlhDc8QtaRlxoFpDuigmADWcI9CqlVDASkR/GjbNPZVRjIthuPd/0ZlJ1uBXW7l4X/TWJ+uK0t0uckpqI9DK4a6t8bWkZa4vNqdB8RCqB6ExSTY643omdkEcBzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:32, Zi Yan wrote:
> On Mon Oct 26, 2026 at 5:40 AM EDT, David Hildenbrand (Arm) wrote:
>> The final scan in shmem_undo_range() restarts after a successful split
>> only if the original folio is no longer large. A nonuniform split can
>> leave that folio large, so the scan skips the newly created folios.
>> Hole punching then leaves pages within the hole allocated even though
>> they could be discarded.
>>
>> For example, a fault below the hole can allocate a 2 MiB folio after
>> boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
>> folio successfully but leaves the original folio at order 4. The scan
>> continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
>> The hole reads as zero, but the pages and their block charges remain.
>>
> 
> 
>> Restart when the original folio is still in the mapping after partial
>> truncation, identified by checking folio->mapping. If the helper
>> removed the whole folio, no rescan is needed.
> 
> This paragraph is no longer needed after Zhang Yi's truncate fix, since
> truncate_inode_partial_folio() returns true only if the folio is split.
> The function returns false when the whole folio is truncated[1].
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/truncate.c?h=mm-stable#n282
> 
>>
>> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/shmem.c | 11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
> 
> folio->mapping check is dropped and the comment is adjusted after the
> patch is rebased on top of mm-stable because of the aforementioned
> reason:
> 
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 7cf5a4d9d1ace..ddea31f44fb32 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1477,18 +1477,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  				} else if (truncate_inode_partial_folio(folio,
>  						lstart, lend, NULL, NULL)) {
>  					/*
> -					 * If we split a page, reset the loop so
> -					 * that we pick up the new sub pages.
> -					 * Otherwise the THP was entirely
> -					 * dropped or the target range was
> -					 * zeroed, so just continue the loop as
> -					 * is.
> +					 * The folio was split. Retry the scan
> +					 * to find the split folios.
>  					 */
> -					if (!folio_test_large(folio)) {
> -						folio_unlock(folio);
> -						index = start;
> -						break;
> -					}
> +					folio_unlock(folio);
> +					index = start;
> +					break;
>  				} else {
>  					/*
>  					 * Splitting failed, but the part in the
> 

Yeah, that's straight forward. For this one I will keep Kiryl's ACK.

Thanks all.

-- 
Cheers,

David

