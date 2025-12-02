Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7F1CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 07:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C506B0008; Tue,  2 Dec 2025 02:34:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A737E6B000A; Tue,  2 Dec 2025 02:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFD16B000E; Tue,  2 Dec 2025 02:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8901C6B0008
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:34:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CA891326F3
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:34:13 +0000 (UTC)
X-FDA: 84173717586.01.A968D11
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf24.hostedemail.com (Postfix) with ESMTP id 297A718000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:34:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pauT2DHV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764660851; a=rsa-sha256;
	cv=none;
	b=m2vzmAINqrHGWG0LpeO1H35PY3QraGEGq6n+ceVwl58TDB+/N2pGZTrqL7bKy4AqtOP9aF
	nZbISp4UlJVkavXYj5djkw6mNZWy+L4tyGyLSKHfUY2Qct6HZzmljIEtU4kAjlWTOBllZy
	opxX63/r5WTNOMTZuVeJZur+6YvetOM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pauT2DHV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764660851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCXyg/6ZMlU25GnQZwOaK4qzfWyNJCeNzBA0R6k4M/w=;
	b=dcLojvJV5yXztMRHLkFXqg+zQtx9kmjziSHQDML+MwZ/w/XBEpT+OB1VYjFpB7n/v3poFn
	aolu2fCZDKBr9oqhOM2/qCE1VLADX6EZceNm9r1djAoHsg15aif0Isda3xigdnqhWSfePY
	48USubW5NVPLSzSh4vHG+SvVNUw6TKM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764660844; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tCXyg/6ZMlU25GnQZwOaK4qzfWyNJCeNzBA0R6k4M/w=;
	b=pauT2DHVLOBXVMzLQgZvJxkVzJMYsBeRKO0KTDIDD+40lplfCWfmLqypT+quBacjAC33FZpIuN7ObxCPWmHacERhytilebVQEcLq2WzH7zWM9cePXVlsjMuog0+05TG8JFc33YzGooyvqpEHXJnMJzEybh/GFWADO5gDasVP2Es=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtvV4rn_1764660841 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:34:02 +0800
Message-ID: <64ae5450-b74d-452e-a9ae-486c57efa092@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:34:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
 <20251125-swap-table-p2-v3-7-33f54f707a5c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251125-swap-table-p2-v3-7-33f54f707a5c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 297A718000D
X-Stat-Signature: fuf9s9bmh5idizg7gyxism96rtdouuxj
X-Rspam-User: 
X-HE-Tag: 1764660849-40830
X-HE-Meta: U2FsdGVkX181YXMFnbsU2+d2Mx15to10VKr1hpM7Cclma4NV8j0piQOjv92NrGuFROw4JrymJdHRGapFeYb4HmGmTuOhH1be/r+3QVmi8je6AkFuJwgR6Eg/tqZUxn/xpQDM387u/3K8nppM3DQn5vjqmQwyKGE7BcQE2k2aoGTiOxkHUulWUkDFVNHUYk2+M4bet6am9hJpiArF0Xt3YVFQE/oOTs7Nbqtjrl9vMBfQZGHcEApBUK2Kh5uxd8ROgVuBLfvf7RtTOh2f4Pk6hgpN8HkasWegSunh497BmTjukxjUmnFnNobTUYJUOwyF82Ze124BG0WfoTX3/PfN+ZC3yqPhI4aMw2a7oENTUPeQi4HcdeiqQcuNfq86AqxWrVcyCbTpQSrUi49wUBJBqu1OdR+XUBtHzflfaKECNwk9zzFZhfcJHTdf2qlMyymF0xO4jMrRDZC5r0k2AUNrOU+6CWEQa8ZrltJDoWUe+5DWfeMCcka2g85DmAB0Z6/cuisWdhA3Rwi2TXXheKFaA6I+SA/qWFEWrz1SNJwcBKUDU1JrIZHmvIBnJoO5N9wUQjSWITorBO6HBvnshxHs9peqf/DoSd6dSzCNjDYfB4H5DITIKZ+/C7yNL/zI/yPKvuY40H7CwebDUhhIO7Hwzvunn5Ut4hIBg/DgLv7unPJ5/gsQtJ6UeJTuA1ZelQyb//cGQWNpF3LlrHM/JvwnEXoVHOIYwez4bpcoUEt0JQt6Z74lfF9SfbkyjfcICeUzxcf8MdZ0oxZC9GfTkkpS/Jv8cmEzmJJhvsmkBHt2RVF0kjI2PJyrJPGVlQsXzwCsS6+HSozTSNSX9M5LvCqtI8iVUCGuntwK6H7aI4pYs4Gm+n8gUHNszYw/yFdjqry3ydxmYaAinn0xHTdRoOVfCtUPpPs30hZ/CcH8GFi0cQ+WQCm0shDZuJvYWM306T06PDQt4Iumcisq/FZ686W
 sba3RGgg
 OVaojvsavydoRscGUXSqI5GpcjtLTOjKTFVtoSVycu1E9KCBWs02i2mhq/ez9T1tUVYM8nfMtqY/BEBbFZLfa+wJE2KlFRE34sMlJPtGZRHFyB3Nrm7MseoiYpNgkVW+1bHcdHwOhEkwbM9F6aA+2grG/vr0/vMnHbioPvYx2Aaz86KhaOAhiQx+ZFHfnLhXgipvyk+TLqKagYsD3dH/exyFH4xro3sEyg2XkxMndpR+9MyNSLRWW0SCz0nYebrQKVJ70MRpcmfGTcxW6xZvVNfSyi5HZjYgQKwH2O9pAHV2Llm1Vsq0qUppqx42GQ8IpcHe3TfvyhGucWM4m6g2W5TwFcF4uosAUI1JJ+UlX5krAO5YwPDJPRg/LYgZSFvd3zqVp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On 2025/11/25 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Now the overhead of the swap cache is trivial to none, bypassing the
> swap cache is no longer a valid optimization.
> 
> We have removed the cache bypass swapin for anon memory, now do the same
> for shmem. Many helpers and functions can be dropped now.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

I'm glad to see we can remove the skip swapcache logic. I did a quick 
test, testing 1G shmem sequential swap-in with 64K mTHP and 2M mTHP, and 
I observed a slight drop, which could also be fluctuation. Can you also 
perform some measurements?

64K shmem mTHP:
W/ patchset	W/o patchset
154 ms		148 ms

2M shmem mTHP
W/ patchset	W/o patchset
117 ms		115 ms

Anyway I still hope we can remove the skip swapcache logic. The changes 
look good to me with one nit as below. Thanks for your work.

>   mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
>   mm/swap.h     |  4 ----
>   mm/swapfile.c | 35 +++++++++-----------------------
>   3 files changed, 27 insertions(+), 77 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ad18172ff831..d08248fd67ff 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2001,10 +2001,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   		swp_entry_t entry, int order, gfp_t gfp)
>   {
>   	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct folio *new, *swapcache;
>   	int nr_pages = 1 << order;
> -	struct folio *new;
>   	gfp_t alloc_gfp;
> -	void *shadow;
>   
>   	/*
>   	 * We have arrived here because our zones are constrained, so don't
> @@ -2044,34 +2043,19 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   		goto fallback;
>   	}
>   
> -	/*
> -	 * Prevent parallel swapin from proceeding with the swap cache flag.
> -	 *
> -	 * Of course there is another possible concurrent scenario as well,
> -	 * that is to say, the swap cache flag of a large folio has already
> -	 * been set by swapcache_prepare(), while another thread may have
> -	 * already split the large swap entry stored in the shmem mapping.
> -	 * In this case, shmem_add_to_page_cache() will help identify the
> -	 * concurrent swapin and return -EEXIST.
> -	 */
> -	if (swapcache_prepare(entry, nr_pages)) {
> +	swapcache = swapin_folio(entry, new);
> +	if (swapcache != new) {
>   		folio_put(new);
> -		new = ERR_PTR(-EEXIST);
> -		/* Try smaller folio to avoid cache conflict */
> -		goto fallback;
> +		if (!swapcache) {
> +			/*
> +			 * The new folio is charged already, swapin can
> +			 * only fail due to another raced swapin.
> +			 */
> +			new = ERR_PTR(-EEXIST);
> +			goto fallback;
> +		}
>   	}
> -
> -	__folio_set_locked(new);
> -	__folio_set_swapbacked(new);
> -	new->swap = entry;
> -
> -	memcg1_swapin(entry, nr_pages);
> -	shadow = swap_cache_get_shadow(entry);
> -	if (shadow)
> -		workingset_refault(new, shadow);
> -	folio_add_lru(new);
> -	swap_read_folio(new, NULL);
> -	return new;
> +	return swapcache;
>   fallback:
>   	/* Order 0 swapin failed, nothing to fallback to, abort */
>   	if (!order)
> @@ -2161,8 +2145,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
>   }
>   
>   static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
> -					 struct folio *folio, swp_entry_t swap,
> -					 bool skip_swapcache)
> +					 struct folio *folio, swp_entry_t swap)
>   {
>   	struct address_space *mapping = inode->i_mapping;
>   	swp_entry_t swapin_error;
> @@ -2178,8 +2161,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>   
>   	nr_pages = folio_nr_pages(folio);
>   	folio_wait_writeback(folio);
> -	if (!skip_swapcache)
> -		swap_cache_del_folio(folio);
> +	swap_cache_del_folio(folio);
>   	/*
>   	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
>   	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
> @@ -2279,7 +2261,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   	softleaf_t index_entry;
>   	struct swap_info_struct *si;
>   	struct folio *folio = NULL;
> -	bool skip_swapcache = false;
>   	int error, nr_pages, order;
>   	pgoff_t offset;
>   
> @@ -2322,7 +2303,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   				folio = NULL;
>   				goto failed;
>   			}
> -			skip_swapcache = true;
>   		} else {
>   			/* Cached swapin only supports order 0 folio */
>   			folio = shmem_swapin_cluster(swap, gfp, info, index);
> @@ -2378,9 +2358,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   	 * and swap cache folios are never partially freed.
>   	 */
>   	folio_lock(folio);
> -	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> -	    shmem_confirm_swap(mapping, index, swap) < 0 ||
> -	    folio->swap.val != swap.val) {
> +	if (!folio_matches_swap_entry(folio, swap) ||
> +	    shmem_confirm_swap(mapping, index, swap) < 0) {

We should still keep the '!folio_test_swapcache(folio)' check here?

