Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C79E8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 06:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84AA6B0005; Tue,  3 Feb 2026 01:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D826B0088; Tue,  3 Feb 2026 01:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93C06B008C; Tue,  3 Feb 2026 01:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B547D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:51:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B9B61603A6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:51:51 +0000 (UTC)
X-FDA: 84402225222.17.99734CD
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62C9C180002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:51:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t6JR1DzZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770101509; a=rsa-sha256;
	cv=none;
	b=y2on/+1LTquiaLQ2j1Zy4Nf4GGGM4TXpzxyt9kANo1yjT4wM3anYpdxjUVDb+9/Sv7QPOk
	4ekMbM7bVx752u970ZLDUfNoB5t+/m9ehM+aXVgvlTM++0+iK7Zql9eMcHsOasdrpozVSL
	q/QAgk8F2X7UmWp6nF5B4NeKlN+7+Kk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t6JR1DzZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770101509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+9hMjNVUP4EwH48yxFOv4vGjAKG4v04AOdez7l8Ufw=;
	b=i037T3WmpB+cBQRmUpbCnFIWqqFzKzDatAOmjoqwyJzJQIRG/QrkGVWu79zH2c5T3HLe1/
	9HvGC+UYocEdwQT66mzUR6j5M3oDHJwLwj8ncOXBhcnbdhWtOghYAAQBdnosluxRciYsoV
	f7RiG5G+GXVCZZJOLPeBpF6/Z/MDWv4=
Message-ID: <22dc3595-5bd6-452c-9560-9b7a5b8b71d2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770101506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+9hMjNVUP4EwH48yxFOv4vGjAKG4v04AOdez7l8Ufw=;
	b=t6JR1DzZxQCFOtl4IvMZlf0xEoyNZkUVmKQvIVbApqzLNOx+sfoKjTwtOdQZmuNUa12/Nr
	NICLYM6EVvYBlL8pAC1BeOevInLH/Mu8KpqnEK0uHRxtoVQNOqBBiA0/J/7XzCFAVZAXpb
	qXGtaKKtDsay61mpykU+JoLQ87y2L+k=
Date: Tue, 3 Feb 2026 14:51:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass
 workaround
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62C9C180002
X-Stat-Signature: e993wr6u8jdspa7wbdwm84mcsyif3gxd
X-HE-Tag: 1770101509-773598
X-HE-Meta: U2FsdGVkX1/8T1O0ZzMnsGHV69Uzz9crN8Y9FuUZAks9VnTI4WJ9JI0FCOof8uIHoaxaTQ6nfA83UExFUM18GAmYF3iiOiukOo+UqTlhDVDksv/B35NrNDPM1MvndA7doIjq+jAGPJxK+IHxyO5yzXi+IRXalcfo5dZmKhIh1Nx1SRDqTpFEG2JQLrgNjQvhGHbuZ0QttODpwxNdz/mBNq4ln7Mib06I1s2WBUiq+V1CuFdO13T0s5GyioSqJr+FTTjcai4JhxG35ZNJ5u8tKGJQQTC+6eBNXoTWJPpcb8Xba7Kz3ypdVUSUAHRW6i+GFk3bFPQKN5GLJ9e/OstZ5ZPXab0pWU9p1sFnBG4cHaAdiLgVLRme3jefEpgp8BGiIuO7m5d/k7yQIRDzbqTHMEublCHB4L7mW5ju3ZN4kU3mzaQflapKMjKTSJvtkzXwhFjCMWOx97ZsbqMiANHxJGkwKfLEQB/dayq6s3rqkoc8yXDCVwfr5CR2myAs+67/MGyjh6pFfo+95RtmDxpqsOfdcwEvrgB74Nd06o1AhG6+u6r4TBcYfA6Tns+o8wJ03KePiCYVUnyF7402R02C78ndV/RfPywNLWd5M74Sd2INlSZqD6VR8U8zlQWKTJcUt6TfOeJy7VRX61B362r1JL8RdI0dd666gZTbbyo+4WOBAF2MpCfkrjd4PnDXUfUBG2V3HdFom1e2RNPIGhYGN5iI6/2xaslEeEhTuX6jztSj0Hpo3VL2P9WZxeeEH7z/pNsVL7Hf1GSdzLWJ7KeiKPl/NIPgnOliWaJcga/H9UBifBhlUO4l/Da9ZbcJbqXn+WSImux2SXdabiM+V53yD3t0p3313xt9JIwKDAkhQs1NN4b7VQXgDLaJSM8WczMz3MiHcJic3x3KpQHtdaorrBjIYzDRuXb9qmKHBA7uRHtMBnwV9bBH/Q4gwdNSL576FNBMWEtO1XjtwcQkNeY
 fbLF0Ka2
 bMcIXC7pewL+Q/h6z9xys2vjf9rGN+d6cKXmQP8V8mEcrGzqT3g8Y8zPgeEg4eO5F8dXAUwFr/TilBuY3qKCRX5nbU7EeAWg1K5U+m4UL82mjKTOlqx6kp2xtpYVpVWLFUDE+nWHGnH4e34zwyWLi21okCMA2vj/EHooa1+RXweDNj7Rk7y4Pw4HwIzMtGPMLeT/vrQhGc4TzpbM5w+Hg+nnR/Z5KDQ5/rTYXswvCiNY2m3cLGxzT1+pUlUsYJz66GktgiXwyp4jbcOLPdYNYjIiihxTi1jBnVfwzlnUjBc6Cvk0e9JXyYOf/k1L/euHxspq5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/2 01:47, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
> cache, including those from SWP_SYNCHRONOUS_IO devices like
> zram. Which means the workaround for swap cache bypassing
> introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
> SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
> keep the comments that are still helpful.
> 
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks!

> ---
>   mm/zswap.c | 19 ++++++-------------
>   1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3d2d59ac3f9c..8cd61603ff79 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1589,11 +1589,11 @@ int zswap_load(struct folio *folio)
>   {
>   	swp_entry_t swp = folio->swap;
>   	pgoff_t offset = swp_offset(swp);
> -	bool swapcache = folio_test_swapcache(folio);
>   	struct xarray *tree = swap_zswap_tree(swp);
>   	struct zswap_entry *entry;
>   
>   	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>   
>   	if (zswap_never_enabled())
>   		return -ENOENT;
> @@ -1624,22 +1624,15 @@ int zswap_load(struct folio *folio)
>   		count_objcg_events(entry->objcg, ZSWPIN, 1);
>   
>   	/*
> -	 * When reading into the swapcache, invalidate our entry. The
> -	 * swapcache can be the authoritative owner of the page and
> +	 * We are reading into the swapcache, invalidate zswap entry.
> +	 * The swapcache is the authoritative owner of the page and
>   	 * its mappings, and the pressure that results from having two
>   	 * in-memory copies outweighs any benefits of caching the
>   	 * compression work.
> -	 *
> -	 * (Most swapins go through the swapcache. The notable
> -	 * exception is the singleton fault on SWP_SYNCHRONOUS_IO
> -	 * files, which reads into a private page and may free it if
> -	 * the fault fails. We remain the primary owner of the entry.)
>   	 */
> -	if (swapcache) {
> -		folio_mark_dirty(folio);
> -		xa_erase(tree, offset);
> -		zswap_entry_free(entry);
> -	}
> +	folio_mark_dirty(folio);
> +	xa_erase(tree, offset);
> +	zswap_entry_free(entry);
>   
>   	folio_unlock(folio);
>   	return 0;
> 
> ---
> base-commit: 2c263046cbe6d9d5fce3dfeba063f199f7e6298f
> change-id: 20251226-zswap-syncio-cleanup-a05b7fc6180f
> 
> Best regards,

