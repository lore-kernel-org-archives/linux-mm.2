Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5D2FF6E69
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71886B0088; Tue, 17 Mar 2026 16:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22216B008A; Tue, 17 Mar 2026 16:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C119E6B008C; Tue, 17 Mar 2026 16:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB7826B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:30:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A2681A0390
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:30:14 +0000 (UTC)
X-FDA: 84556697148.19.F39F5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CA344000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:30:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iUXIXfcz;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773779412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JOI1WDhC9mKs7qkv3xAE8imXMxEKxzsHF50xjtBPMQ=;
	b=wfBXCQk0DTppmPIQ0F2OyM01SD1nZS/XcUuunxXx8E/6QDPFz14/caWPXrKe7ojl+LNLbm
	NyVGb2p7sx2QoxYEwfzGnlPbb9luXamAWqVMgaCeBvUagPzZHco3+2tVIwDm4XgzQc6oJV
	0js2B52wS1i+q42IxxvSA492LMD+bOo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iUXIXfcz;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773779412; a=rsa-sha256;
	cv=none;
	b=60upAHG3jZW1vdaUEXQmFVJU+ooASPa5tO9GWSIONGKE/yujQIKagbeX4rboMUpy9i7TMy
	uEHG2dYgvFQvkbkh30l8/mU5bVUJDWTAsyqgwi9pD2O7MoHe9PVGniy7vMRTBRBqcNs/7f
	Pnj1K+F9bG3Zb5eIibzubOu9t86m0TY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B1A140144;
	Tue, 17 Mar 2026 20:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB62FC4CEF7;
	Tue, 17 Mar 2026 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773779410;
	bh=y77ME/+Lq9M332/u6NFypWmy80x1XFXPfgniLBpaEn8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iUXIXfczMpfdc+0NBStenXRrxWq/YTgxmGLQZZgv//051dLVl+XyMQgtOv4zYdrXK
	 WcViQ6KqoMYMEfDPipU8NRYa9V8G3AIDLWxnvpA2rL8fVClzacS5IVgQC517/LzoUb
	 HsPdtW1Z/2vPNz+6+3Voaxg7r/cbQ7wC7Th4hDuZ7COGTgxMmtYdA1obYstEpP4vQp
	 D8I7sxYrzyRArampSFUG0BPWXXcwjgV9Io0kldfWkvhKnZUYfB4/ewTuJS6ISko9Ia
	 FdDKZOdILKnJhWMcgvk8LPXezknwE7o8f1qZlGCGW5+NaNLYylxwRgsRW5gOdghXN2
	 O8Wp9VCwPgvZw==
Message-ID: <6b96a2d2-7262-44f5-9d46-f2187cf4c9fe@kernel.org>
Date: Tue, 17 Mar 2026 21:30:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] mm/memory_hotplug: remove for_each_valid_pfn()
 usage
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-2-david@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317165652.99114-2-david@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5CA344000F
X-Stat-Signature: 3cumrr6s8zdpn48hz9wrauob399fw4tw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773779412-37563
X-HE-Meta: U2FsdGVkX18D25SL/71cmbtGyx9Y0CYWL28cikU0FUGQxrO/2k1qJWptTqbxLu9v79xX0En1Q/ghxMZ7I/TKpIYqYRTkyQXhntIRnpssUvfn5dtuLdWb5iwNMOHSeAR3HmIcWv2lckpTsv2Eyhccrj9rbZWDmVnzCVoDl6+h5kwro8mkGoOZCGceqN9a9l4XIOtKIrSaIqkQXxHiJp9cbGbRManrvb443tYkJy57fyudrszuJQaF50stt2rHI0CFphPrqhBMzasuehptho4ljIdBo9G919qm6dLAEDN1df0ABHxpGFg+J+WiKvQbCP8w0ZP+/WqKbtzwHhEihOqMTFEah94wiWibM/DDKjYvbZrjFGaAqS6fN7tK8H3HfCewRmQjwlawqV+JufZkaqrUl8xQn4qCPw93rH4XsvQB0wpY0uC+b80DosbIyE1IW75ciP2iydVWu/h2sSY3aPhh1S+QtamBjDLTyYN1u2/Xk3IPhhTG2QH3aYsoUOLHUEHOWUlLpw1Jlrw74iyaeNnJGrE/GCz/zdwUswdnO4ab9O7dKspj/FDA62vKIrCNbVsJRCvSqlSaUHqia8w8J92oadjddJA8pTF7e8SxhBWP8cWbZ6FZfZSLSwNoObU2F++nVGfhZgrs6iRaz/U/cUx5TfIPXJEkYjJxMQdGQnMkCaWYSGGe/jSqk56Q9ZtvKFebojBni/a+/Ru4i2/IelQRPevj1QKRgQQWacUtT2VIiTl56TA0SIrNLGu3KhfThteF/Li0FYa0Rx4zThldNiUVd03M9PUT7bKX6MpLBSquZXl33BvcOP6vYJDQy9BN/cg1co73f4f2SbHipL1iYKIaMQOcRPIv4qVtht91oGTib88Je5ZRVvbh5M6OM3rqzKX0icChj/LCsP2ROFnYtCAcCXbJXP4T9DQLGQWGBWTsj2wSaWkn+pl6gN/VXTM4eOjVKdDU+mzrzTjhVtaZ0CB
 7IMI5Azk
 3ieap10xnTIBoh2d3Dem0j3QAlzT3Kymii1U1TuIUsGoCWj8APMvAwOSmExoJY4fatKRTYDmaysfY5ljoIG1lOjaNWINn9USWRXBPriaoKLmS0Rhu5Wo88+yhB3me1iGBs7LH9NDIYP4RwgTlY+s6bYUIfC5peJc6ZWAq8V7sMepT9m1bl9OvZVu0Coi8ZwMzbSy1aVcsROvxfrodUfsjv6xwCHMOrXVUbcqNRGoQ2m8ViqYKz/nE344Uci4nP+P0c4/lckxxB38QG0ppc+EhZ/s6oSP1luxtXImxUt5tBRbgSzbXQwEZeq/f6feg85NjqZpG8+aBhAfwCrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 17:56, David Hildenbrand (Arm) wrote:
> When offlining memory, we know that the memory range has no holes.
> Checking for valid pfns is not required.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory_hotplug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 86d3faf50453..3495d94587e7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1746,7 +1746,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  {
>  	unsigned long pfn;
>  
> -	for_each_valid_pfn(pfn, start, end) {
> +	for (pfn = start; pfn < end; pfn++) {
>  		struct page *page;
>  		struct folio *folio;
>  
> @@ -1791,7 +1791,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>  	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
>  				      DEFAULT_RATELIMIT_BURST);
>  
> -	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
> +	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  		struct page *page;
>  
>  		page = pfn_to_page(pfn);

AI review reports something rather unrelated to this patch: if the stars
align, folio_nr_pages(folio) might return questionable values.

We certainly don't want to tryget all folios here, so we might just want
to make sure that the value we get from folio_nr_pages() is something
reasonable (e.g., >= 1, power of 2). Alternatively we might snapshot the
page.

Will look into it.

-- 
Cheers,

David

