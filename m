Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196ACCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570758E0019; Wed,  8 Oct 2025 23:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521748E0002; Wed,  8 Oct 2025 23:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436D38E0019; Wed,  8 Oct 2025 23:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29F878E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:02:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF98D140969
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:02:24 +0000 (UTC)
X-FDA: 83977077408.28.5D6554E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5C6F4000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:02:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MzJBZR1j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759978943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGHS6LE86054/Y/Y1qdGFobY6PczmcGdCwMWRLQoAl8=;
	b=fV4vtLl9FlHlaEDMzfgMTP2pJhJZveE5jwyiLoY0It32V+mVf0jP7dXGWw/AUlQ1SNj4BI
	clvAJs+WKDPIR3XbemacpAY3YXXFHgUZ2oUUMs6DXZMMV2DA5EXcrGLUuUqLK6A7ffy060
	4XOCO4ZzwtlaXdAbODSfX9Giq2gaUkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759978943; a=rsa-sha256;
	cv=none;
	b=0GSPofBGL1m2wmbflHRrRov+gJnE0sFh9ymlSIug7Sa1eHg+5Xg2QfVRBNmW55VhMo/Pcq
	Ippylug7LMpPNiCmypk8u99zEHLCKLlrCkdzFE2WnzPnEMSy/63n8OmkWfIXHsXV35x/QH
	jAx9c9bVsq2gGAJi71cG45XxYl3AhuA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MzJBZR1j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
Message-ID: <c6c9bb5e-b70e-4daa-9b8b-53b6a8ac87fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759978940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGHS6LE86054/Y/Y1qdGFobY6PczmcGdCwMWRLQoAl8=;
	b=MzJBZR1jiS0OT2kLL2Wju4EEgOrpVx3DaHe59BtCj7i5nbw6rjCxfp9FsZgC0n1d+zi3wU
	YWlGyKzjxNOUgHdoR7Pj/x4ETw31p2xWXH+i5J29Oz0djvsMsbaRKoLPqP/CHUARPhJIl3
	g48tu2/3fBlMgJvlKpEj+3F7+oUlB2s=
Date: Thu, 9 Oct 2025 11:02:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] mm/zswap: remove unnecessary dlen writes for
 incompressible pages
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-2-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251003203851.43128-2-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: t8munum7uceatjue4qdxj114h7rrjusp
X-Rspam-User: 
X-Rspamd-Queue-Id: B5C6F4000A
X-HE-Tag: 1759978942-278919
X-HE-Meta: U2FsdGVkX18DoIpp6icOHttrI/F7ymME8B9auAS8O1pRqUr8A9Ov7D0SyTp8UiFtrXnWOQfmzSA/A2cx2mf0N2AVGcz+uSb3wZcuxCnDT0eK4YwQnv2f0KAsPLsQzcHo7tnw75TbG01Unexw0LnbaUIGFgl8GctGi1YTaCgHPVRxv5TUSJHRkXYPXrrghiMF3rh0/rHMV13b5pYLxQp9OoX6+lWL8pAOMFFxWVLEfb4+vg+k5GLvVeWLbkr4uCkcJ5EX/QJ9Q1LMHg4g5L2isQI9oa6BV+++9FCeoDMdn3R2aMRpiPURm4BITVU1sUcw6KCspF8NjTvZU2kEB7l/96ihNtKeOQxE2HpPX9i2NYCLXtzKvXFLNdJ7H+iIbe2LEt7jk21Zcp72W1xBuqMfG+Dvl8Q4MtEHBu6oKwjkP87AyUSa4KnXKIl8i+RY/Av1nUuSlSs1Q+XvqH9kTsGhjE5OdxvKYRU7vOGz3mJdc9hUh3eTAR1ODNTTeRQd4I8FU7rrYGL8YSMvo6vI0Ba5pUA23vaWK/7YC0BRTjhR56dDI1raRiDrfC241Xph4dNYl7l/P3xEHQN7U5TAmqZ0A2s/guyCeYqFcGC1FuSdWEWQW8MVGpm0DemohE6/RCslfFzaGXrbzy5dtzWE3dmSeDnKAHQvlFzPK0OaVCbShO1hBD9TevMlUj0GKK9vc4kYjf0x9WKKMdqxsIDbF3ebDbZkX9qg/9hvx41rv1J3vNwv6GU5KZL0rCyh8/2+rTHGqUMSDk3JZBcLIHlDdCPkc+4bQ9nFOASKqPVEDBoT9tLxDhE9qSRXQpBwaaGIFuF6eb4BcRvEsVsRRWyh/QLA69dgRcvvP2T+6qkS6cfpnT24OlJItm79zWWjPVf3hZUL85wGEpJuZIFsGDC/BIpzEkyeo37J6u4M2euXawTCpgaqq2xHZ2zOZYQe/o7qoXTpv+fkjTwnQBXT5W1bj4z
 Q+YfmlRL
 fc43bl1iJVgc5ZwTm1iO6dkciJocd0KXbYf9ix2EdTveLdPRTx5OVBhlRDtEE4VqW1slit+ZFsgqj2bXl7Kib+FskK5CXZTa3i9XenyP3n2nm/UOPc8ZuZyJcPofbVQMXto7GqHBF5VymQgIywBTgoKeRA9heh8rLU422jPaWbX7PQ9L/lUuJBz679WFVFckupJgA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/4 04:38, SeongJae Park wrote:
> Incompressible pages handling logic in zswap_compress() is setting
> 'dlen' as PAGE_SIZE twice.  Once before deciding whether to save the
> content as is, and once again after it is decided to save it as is.
> But the value of 'dlen' is used only if it is decided to save the
> content as is, so the first write is unnecessary.  It is not causing
> real user issues, but making code confusing to read.  Remove the
> unnecessary write operation.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

> ---
>   mm/zswap.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c1af782e54ec..80619c8589a7 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -894,7 +894,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>   	 * to the active LRU list in the case.
>   	 */
>   	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> -		dlen = PAGE_SIZE;
>   		if (!mem_cgroup_zswap_writeback_enabled(
>   					folio_memcg(page_folio(page)))) {
>   			comp_ret = comp_ret ? comp_ret : -EINVAL;

