Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BAF606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbLLVOyd
Received: by kanga.kvack.org (Postfix)
	id D41376B05B3; Thu, 26 Nov 2026 08:42:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF16C6B05B4; Thu, 26 Nov 2026 08:42:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30406B05B5; Thu, 26 Nov 2026 08:42:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0A256B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:42:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E38B140487
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:42:24 +0000 (UTC)
X-FDA: 85477384608.26.5F8D013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id ACF11A0026
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:42:06 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDB3340A28;
	Thu, 26 Nov 2026 13:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB001F000C4;
	Thu, 26 Nov 2026 13:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700525;
	bh=3y1+RAoTiRmBI3p6Z4+38EZ+FatJO0aCtVj/6uxTSBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gbLLVOydBvkMe8tP+W0IOjwHDecpZIWlug3TR42aXUutzDN5FedabExkixcGooxiX
	 8zOJkBDsjhkkFNGe3s59k3VqiLcNUx4YAHuo0eGXCjlAEj4JyyDS6u8UWwXZPCjM+v
	 lOjAxFlH1jmHAxy0NtutJZeDW+0/OlNT6TddGwioPdpvPduKfxudSJoN+913Lw1Zc2
	 r2DXDhFwYjZW6+fN+PCRl0BYd/S0cJrhBXeOmvquUJe4kq2UV0VOwporxRkOF0ml56
	 8neBbsf33WLU5kstRptCci6iez18Gi6+D41ULqmw28nVogx5wg2F7msAAim/o88bsK
	 UU2CkwwK5cyGg==
Message-ID: <4fc1e334-16c8-440f-aa83-ae27f8b8d3d8@kernel.org>
Date: Thu, 26 Nov 2026 14:41:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm/gup: break out gup_flush_pages() helper
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Yuan-Hao Hsu
 <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
References: <20261123195609.4115244-1-riel@surriel.com>
 <20261123195609.4115244-3-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123195609.4115244-3-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1795700526-505921
X-HE-Meta: U2FsdGVkX18K/ZGvyLlf/O5dd8mWnkApRYPw5y3+DKAhjMbB5tweIsgzbVxowROJoIp4qir5RCIFV5ISvV4RgJB+wdltuf6tBSiu5lQHoS1hjsQLw1d+jZm01kgtDE1xlIWHgTu9qaurLs/mXpwfXgaDpW4H0T1j6pAGoEYJf5xTHYz6+0sNCaPqu83vv/FtGXKQF7hnx9llVryqwBcqb7ds5qToU5K81sBOf/TlacRxe0ixScjUBDPKN+ptdA2cSMFH3WlSWXbCjdpedB4eEUsbVlZM1ASSVaqzj9WdLz3PiPzB7rfJppVlqBzA3Wxa8zuJoDZfO8teAeb8Uadjx6wpGA0YafLTHOM5e2IKIpg3S6SRNqqg3BfCobrKpOzDGH4kgLp4HKye7/KC8+3W0CxqV0AhPAfFyoE4zUKH+VHx03ByKjcp/v2pRr354gmrY+igMzWRmkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 20:56, Rik van Riel wrote:
> __get_user_pages() flushes each page's caches in an open-coded loop
> right after filling the array.
> 
> Move it into a gup_flush_pages() helper.
> 
> No functional changes intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index e0698d2075b4..d35fedbce7e1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -729,6 +729,24 @@ static void gup_fill_pages(struct page **pages, struct page *page,
>  		pages[i] = page + i;
>  }
>  
> +/*
> + * Flush the caches for @nr_pages pages stored in @pages. The caller
> + * already holds folio references on the pages.
> + */

Again, drop all of these function comments.

> +static void gup_flush_pages(struct vm_area_struct *vma, unsigned long address,
> +		struct page **pages, unsigned long nr_pages)
> +{
> +	unsigned long i;
> +
> +	if (!pages)
> +		return;


Will this ever be called in this series on !pages?

If not, remove it.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

