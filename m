Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED38FCD0C5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90EB6B010E; Wed, 18 Mar 2026 03:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41BE6B010F; Wed, 18 Mar 2026 03:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B307B6B0110; Wed, 18 Mar 2026 03:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6FD6B010E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:52:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E10E1D416
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:52:03 +0000 (UTC)
X-FDA: 84558415326.13.3169A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD8B9160002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:52:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7siPfEp;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+wwh92G+R0TqtainBcq4s1QKvHlOG0hq2oonV1PwSg=;
	b=sU6/uFFBstCCwN19f2bo1XtQYka71MPDksGRrdzCwoXg4rRBHhfWu0TI4lAR1GznnBYn5Q
	LD3JkoXx9UMCfdsq5hLrqGd8SMgG6MGhJeTqywrgi9f4fgKrN3p/+feR0B/5bztFUtrjt7
	xN2Vma/uD/3DV2emg/G49xT9EpyfxgQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7siPfEp;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820321; a=rsa-sha256;
	cv=none;
	b=5kChUmVnXca6ZZh88YVjQJOD5IDW2bD6h/zJh1G0QIx7UVBIJ5fGwCbM00FIef38TfXaVJ
	s8Tp4ofa5FwIlxhjyvBCt9VstpD2E0skICh3JDSgvWOVv7vPERF4ffkqfnNPVWZkkSt845
	wh94DRrm37ua4hJ8rL0vyjPw60lv3kk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F2FE600AE;
	Wed, 18 Mar 2026 07:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EE6C19421;
	Wed, 18 Mar 2026 07:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773820320;
	bh=6YXJGpN/05ciWRewmyb6r+eM6RpAt346T43GsTHL1l0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R7siPfEp1dmzCHK1SuAPFV/Ernz2/GEx2Z6EQTxtVJlCUd3kvGvtPQTagNt/hvXIM
	 dGFhvKAAEIPYEuBrZrrzCXPO/NGZlvcROJGXxUuLppJKQ870T9qsQWl+NlOM5oRomX
	 +X1BnwHYBBeZVTydEK0L+diJ4VlSMfVGQ8s1B18BOKhgWlBhiFTZktJKvDaUc2Ps4a
	 XSGigvBdp47Q/KVexhBsCZ7RO4btnFGwsGTerU5lXep5NbqyrloXrxVt3TsWXK6K+f
	 rHH2DhB2c7v7usKbwdOTuoviy7UCHhX4KoMyguwv4mDByNs4ObUpEux2xleleQkUHx
	 /wE7v1D76ggkQ==
Date: Wed, 18 Mar 2026 09:51:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 01/14] mm/memory_hotplug: remove for_each_valid_pfn()
 usage
Message-ID: <abpZmD9zVtctGaGH@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-2-david@kernel.org>
X-Rspamd-Queue-Id: BD8B9160002
X-Stat-Signature: 5yd1h6c3hkpefgn9qnr41crgop3qxq5e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773820321-521422
X-HE-Meta: U2FsdGVkX19RJN94SOaivHeqPJP4IUfvxw6AScnaTGPB4XywfThDeXTCdb4FnmWaB0dw4uzTUUqoFGn7OA9ly2ueX0DKx2DIUVnSmP8rsqjEA85SIa06A3zuoVSOawm8EJHUKMAzX+NLPFKNeQtBIyFAirk9KQHR70mwv9DsSdEr2lLz4bTAhvCVZTUMyLkgvHwayiRGGO7yVWj1fcwvEp0QjQzXRwEtVvuwcldeei0zBRzrOubBEL44ypQqmQrSDGnenifd+AbVJtyZfAz0beSIMHOMNy44Gy7iWf4Jtpm+o89bGZ44HvKfYK94I1nGsGJPiAOQ4Y8dAwcaYD1fuc/ZvsfGG0wwZ2jaY4F579AO4gfR9KsXJqh0OHJfzV49HQYPTJHNY4EjZQdbju/5IuhsGNe+eWWOBCfs+nIsX4PApjAUlJ4iBABQStO5+auKvxQDsCFvJbn0BAjcw8DbSXjqvX8cU7Z8qGsHlLWLTNYvB/9wWQ0wPsStmkvWXLlvKPPlAWgpiJ3a+GijQp5yw1ThZ1uKVWocsK0OSidTW9hWUMA4d+ZwcyFH16sYisUFVwRiH2qZBOzP33nRIFA6UcmTH6lwOpDvDN+uLq14W0gFQ3XcDb4hla7OgF6+q1IZy8FI/Mnb9r5ESMPSWAh0RquS5YM54F8iIFdIwGHJji/CuXCAqRiRh9tzNwbutzT9EqbD426KFBOYAZx2bvzyQVNzlIc+PWAYgTVIyDX7gUWWmLaNHPUmPGfird588ehr0mvGazacqz+65OOusJEmxHURX6KXzpFdWeiB9bw060zfx2tPx2u4WoPzFqtbgXmXpxwwE5+/i8EJhg/s4oSu7/KpsApackJ3r3aU+C7KTxp3ULQ7rWZL4AfNOg2vcXWLA5pUDgwwIXl0ZAiy1WDcrcqgmJ2HXCYWq92YACOKsLLgiD651wN2FZzP70Nte3SR9dQdzcIvZa2MoQVzGHi
 3u3d6Pbd
 NvRYETcIhz1DWIJamzgs4VAba2V53cvHPN81pP4CTOOl6USL+9Gl3QqFGbkpfuuzPCb66OrcdR878mt2magSSwPYNyRC4mlKZq6cNnetBgUSEnc0HBi55XOGGKmL7QwvShmYicfC6ceytp+y/qDMWUX59Q3kevBBX8K5MCd8wBFim33w5HsPb0aRKpIOBfzwPhK+hoJDY2aNVtNk/NwATuvoY8uygRNArE+oQpwUzaaL1cD5QvWGtChJdf881q5fgI1jHzGihivGYS9NrHzh8UsYxj1ZcIaiT7DVZa5HL807O5T4n9HurUD7BAdgG8rHls8Ut5N1YOwcQR3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:39PM +0100, David Hildenbrand (Arm) wrote:
> When offlining memory, we know that the memory range has no holes.
> Checking for valid pfns is not required.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

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
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

