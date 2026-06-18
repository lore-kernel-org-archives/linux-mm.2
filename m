Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C440FCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CB06B00B4; Thu, 18 Jun 2026 05:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BA56B00B7; Thu, 18 Jun 2026 05:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B616B00B9; Thu, 18 Jun 2026 05:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 630906B00B4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:14:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFF8CA0690
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:04:53 +0000 (UTC)
X-FDA: 84892448466.16.8D197FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04D09C0003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:04:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haKYBsbc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781773492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brT7Ln5skWkl+WmDDmlxUMKf7E5NAPsYv0yiDxFLo0I=;
	b=kW7FdHrV5xTwoiNmD3ekZQ6K6pfQGH9Uo5DzaAFRfBadHE0w0Wm5TTNWR3rds0sdZjkNR7
	wtuwcVpy1xqO3BbfrX/wjVhID5lJci0I1kwzc23poJdNa/MDhcUnHg6ghbmilAns2CnW3U
	m4jqUXXUrabRnjRKFauWIXHF+DJ+sB0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haKYBsbc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781773492;
	b=MCVBTXuj65YySxtRcqMyk0YRA3vYyrpi9d9iFTWDBPqGfAXFX7XodgGIVkfMp4kgk6aMJi
	k2uF+yobykGNHBK09/c8G96PNDgTY9YKIxwqFyXOTOavA0+jRnytPD3mklP4fDh2zZ5ceI
	O4oZ8fca7ouKFjglXevK0jfb54UxJNU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E08B601E0;
	Thu, 18 Jun 2026 09:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A2E1F000E9;
	Thu, 18 Jun 2026 09:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781773490;
	bh=brT7Ln5skWkl+WmDDmlxUMKf7E5NAPsYv0yiDxFLo0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=haKYBsbc9gCVaQo39LR+3EyQo8ZJfVFQDN0oWO8bdm33HUoFFfgmQ0Q/bku4jiMwd
	 NPZqNARZ1j/ki3MoKAq3l7Ta8UPdWIbOrvrtlpQUrUXW/HRNsyIYAuIhm9UWTaN57d
	 ftSVq/75FRg3nLmmtiEgTDavTJVDvAHlNgRxKsNWO7Tf+FUE4uT6Jp1TZpzi+RSmkx
	 dD9tGP+GaZe9SANOX54wGUJm9W8fw1FDm+nQK7zRhJbeC5Kyc/McYKoDijYZUSknSH
	 oRyjelG+ljKff+kiKs9jgVXutRj6H94fkp8/Ud5LQ1jf63rcUzWEF/XDbw0QX/XySh
	 ChdSu6axxE/Vg==
Message-ID: <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
Date: Thu, 18 Jun 2026 11:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Luiz Capitulino <luizcap@redhat.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04D09C0003
X-Stat-Signature: qdtr9hdng7qt1mbh865jimj9htruqbdy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781773491-192742
X-HE-Meta: U2FsdGVkX19ZkzIrAv292GPbhNbAv1qT7snjRVviInXG4afb1jPEvKR5CW2YICxFGAB/s2ZvanPT2oBiMwIklDDC/ksOXZnj1JKu1WWmIGFF85w7vuMNktc6u+lLW4hUO02MpEQS3wyduJgZs57KL2bxzhi/WioGHi5zMmyts7MXyHOmmLoUl9K1Yh586XTMnztkAwFPzyaOgiL+NIbe9QY3XsOZXeJ725U8YwT/HmQLOycc5TbShtitoUozJ/GtiZGwS8hfW9NYXS9Ob6wmBhpVVWtyN7vEfVC6fEfUO/QandE/oh3X9z691pv/7KBR9pghdoW5J7ixOXrS58bKdIu0NcLT1vWQVcRDBqXqUGcKuJPGvnFiFchLKhYupDw5zRGnEDhfRwAivkmw9DsRRxt/G5QAXdTCnUiejG9GBmkbXJ+EsMWegpMdMuHwQlzYv67oUeNUsaxSR7924MVVlDdV4NZyYlHb9Y4GqbCxbRiwpdQaxiD2i7kTUVLNVrbVVd5NM6oDSXNkRLGKq+pttJf634oU0SsmugMHhcnbIOoUZAWqK7IShWMo/bm3x/qyd7rb1/uxpvHPllttfTOSoQx8noe9BVoi2EHZ0SO6Q/vmzt/9PrBx5SwR/TRAXmz7rHCvxKJFrz3ldvxkyJMz7ETtYRfBe/lJz4qy5Ustq+hKAsBgv1JL3OqJEXrtHgk4v1o2I5Jjz1Km/6lbSwiMqDq6Bnb9rhVOMgq//v970oXBa/Qzdpeg6zJED+MXNhYmXimP0iqCbHtzlLfp6uEurPC6243Kg73ES4MCF7jCVeL7i8yPcvY0x2Tl/nDXPbqBwBFA6Z7JujAwWKq2eIIF4M5c8cYoltpAQzdt9veYDfWnnVXzXKbHD67RUKb44RYThKkQs5ypjZGbJwOyF7k9md2wG++tN5mxGoKxHj2p1QjG0Ef7DKf43xbHymAFfRDqUqWs4JGRkhfjEMHOmSs
 wJdSGLcq
 wvFMQzTTjmRU+jlQ8Bz0+fMfgFzqAvVwJFgLYXFcodjDFjCGB4wVwlXDbvW4+AJByyI9wcbmXKnBteL+kmMJjcfxKL/FSs1HR5TRBvopzdNNNvkXLF6Uf+/PAcmTxazOQyxFJG1L8XTF8FRMcy8q20BCefCPjvyOV1FkDIFhiEPIrXh4FZ0EoOxJXDcbb2TId+VXRcVhvjtQIQ8crPDx8RO6GRoJIIm2S/nLx5O9HgdC6ts22JFHKYG/Vw4y13DbWxxqdAQaBEAmyzNqBGsov27CTbufa6xHzkJkh+aITPmHyvRxE2MoguRTunHw2KU9IslO6IFyLNPJMcac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 17:09, Ketan wrote:
> The page_ext iteration API do not validate if the PFN still
> belongs to a valid section while advancing the iterator.
> 
> When dynamically adding memory in hotplug path, it can lead
> to a NULL pointer dereference during page_ext_lookup at the
> boundary of the last valid section.
> 
> [   14.555124][  T846] Call trace:
> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
> [   14.555129][  T846]   +0x11c/0x260
> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
> [   14.571206][  T846]  generic_online_page+0x14/0x24
> [   14.597782][  T846]  online_pages+0x178/0x30c
> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
> [   14.597789][  T846]  device_online+0x88/0xb0
> [   14.597791][  T846]  online_memory_block+0x30/0x40
> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
> [   14.597794][  T846]  add_memory_resource+0x280/0x298
> [   14.656161][  T846]  add_memory+0x60/0x98

So, we do allocate the page_ext in memory_notify(MEM_GOING_ONLINE) -> ...
page_ext_callback() -> online_page_ext().

Which makes sure that all page_ext is actually allocated (for the full section).

So when we later end up in generic_online_page(), the page_ext should be there
and the memory section should be valid.


How can online_pages(), which onlines memory part of present memory sections,
online (free) memory that suddenly does not belong to a present memory section?

Something doesn't make sense here.

> 
> Add a valid-section check before looking up the next page_ext
> so the iterator stops cleanly at section boundaries.
> 
> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")

If the problem is real, we'd want to CC stable.

> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
> ---
>  mm/page_ext.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index e2e92bd27ebd..74067ea740fe 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -253,6 +253,18 @@ static struct page_ext *lookup_page_ext(const struct page *page)
>  {
>  	unsigned long pfn = page_to_pfn(page);
>  	struct mem_section *section = __pfn_to_section(pfn);
> +
> +	/*
> +	 * section can be NULL when the page_ext iterator's for-loop increment
> +	 * computes a PFN one step beyond the last registered section. This
> +	 * occurs because pfn_to_page() uses __nr_to_section() which succeeds
> +	 * for unregistered sections that share a root array with registered
> +	 * sections,while __pfn_to_section() returns NULL for them.
> +	 *
> +	 */
> +	if (!section)
> +		return NULL;
> +
>  	struct page_ext *page_ext = READ_ONCE(section->page_ext);

In addition to what Zi says, which will end up as:

	if (!section)
		return NULL;
	page_ext = READ_ONCE(section->page_ext);


drop that comment, not required. And likely best to just add a unlikely(),
because this doesn't usually happen.

-- 
Cheers,

David

