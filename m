Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE475FCD0C5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E14C6B010F; Wed, 18 Mar 2026 03:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391CA6B0111; Wed, 18 Mar 2026 03:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7AD6B0112; Wed, 18 Mar 2026 03:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F166B010F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:54:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A56518BFED
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:53:59 +0000 (UTC)
X-FDA: 84558420198.08.B064F45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06C7C1C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:53:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpzsE4Wy;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxt05z2JrjlDVPAU2XqalmGQqT+zahdNgwpwyn20miE=;
	b=pZT54IkAWwqYlY38OIJf5r6px+3uj5wiJoCpubTg7DpmQ02DzarNi19U5eZT3leppZVL1+
	FT5Ljs60pvvYLUhgaV6S8agIJ01o7TYpIbmd7ytdZDZ5t8lVb3ms9Iq01QJiKkW1Oc6Lmi
	u29SFv6P8syfpYy1TfZW7nYRXHYeFNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820438; a=rsa-sha256;
	cv=none;
	b=MdDDslnlU9s5CW22iXMb+IKSDUPLWV6Xp2tYddEnIfPNk+tr2q2eAd8P/IahJ1pGnIAX6b
	OeHT1PpBidGT/Ybg/j83T5FDQ07S46EygTSEYFIne8be1NRWyrMSaDy+1zOfRXMBTZb/ci
	HDUXRGOL0gWpa/Ce7BF8lzwdarTDqh8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpzsE4Wy;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66973600AE;
	Wed, 18 Mar 2026 07:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E9AC2BCB1;
	Wed, 18 Mar 2026 07:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773820437;
	bh=QOTn4h9c0XtF8yhxZi704PPjn7nl6uZFa/xNu70MWAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HpzsE4WyRNLn+Xvhih2ZXL2M+GOXeLOut/S5fo1SIWKaLYBhjbpw7jqc5ebwA35DN
	 g21uDWcZ57UKgXMUUXZEf30l4NjtC1dHQlHrJYcSk7QQFl/owbH+1IBU6JV2YuXEsk
	 CJuOYC2Gx6v5yPWqGulyZlSa1CulmoQvRtK7eH4c4GNo5mxsGAJsz+7EkqzYSqw3ow
	 K3oLBK2fhoIDz88IXQz2iZfbmU56gksb1VZMP7wZqhOlHUEl+z4RTlbVEKpjAX/EtV
	 fmsz1j/MaoDN3rzrHIVeVp5HvTFAr3aL1GyotmG7VzafM6YkKXHcs4hZrRkERWGmAf
	 RykQd2M5dNznA==
Date: Wed, 18 Mar 2026 09:53:48 +0200
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
Subject: Re: [PATCH 02/14] mm/sparse: remove WARN_ONs from
 (online|offline)_mem_sections()
Message-ID: <abpaDCXit9cadpJh@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-3-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-3-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06C7C1C000A
X-Stat-Signature: nya4ccnzbn3cq5cd4yi7cra3nrgkfqbu
X-HE-Tag: 1773820437-137442
X-HE-Meta: U2FsdGVkX18woPcPTVDUbzXvOKGxPkaeFgLb7eXK9AQBpYkDJA+TZcCVB6rcKA7fqVTi+LN4WKZ33AjwpX2Qqjr+EWglKvxm9D5SCpDBRsnO3tnkGlde6GjJzjo1sLYuH3hxzvbXzYwInn/Eg9E1QnmWrU+07+ZOkYltQdR6XbWyzkSPDbL0Qme7yBRd2Bcy5s5Ub09X9aAZT3rgsEG1zjJEj/7U4r1+VRaGo5cpHQmdZSj3iP0c8vOSX51Wzl3ahJWnMx8PSukCt0/WmI1sJN9q5Ot6TeWgRN8BAMra9iGgYV8nIOmsUfrt8rmr+FkYCAUtKKsHWvwzQ71u8ybpiCnj3/rob//5FK855yy8WOnok6dJ97lrzSEnPKvnGQrrGea/br549+7bW41NQFIP3HH+Du1XXTJUpUUC6qwxfkGxVXPzjs/7c7/5TzU5bwfxPpoHWLXt4lKfyqsuOdT6YCVz3xmSnimE6AZpzvustvWlSSoJMviyUe5tCiNjLUlWhjDuU7+FKF7F3uVqHMo0gm9jaMlIInfrwPCF3GMc5jRUHq4c/3xIRQVESOERZ3ZsQwu4Y46q3reLRg/rPZ4GOA7mDl+pUg5izX9Ue6foxRwofo59EH29LqHEw/HNp/lUcGfv0ykLUPkDMigEYjdqRH0A6UhcjrXCzErE2Z45cJM5Ong5xZcidkZ24hiuXMoEPfKsbM+jdGjp0DtQdC+IULJtFQHrEd4/MkXqiHA+ZsWq/vQdJ01i8SioBRdgNRPzB+yxrufDe+vOF7ymn20eYfEkWjyP1ZgIqoQ+GJD4N9Pfe7M3dCRVfjXnbAmNhlDLK4CutHjSUAAIy/gs38wDpZ14AMa+HDGD7Pd+e9CWTQbB1q4QHYhWVD0NlsMFRpxCjbKVN+iutlN1L1QRcmx4jlHBlOpgCuQ5DfMmnj9uu9ejBo/LFlkNTiixV9Jas3r/hiS/G9trO+C+x9n6E6z
 vDyHPUNa
 qR5LIh+N3EkzebtAIZD7eVYDTUdWc3EVnNEmuBn69QHv+TMIdutu2Lyf5TxDbeVsg9BEdg/h1MzEkGMZYwlLgPeBNZXjWvT0xphM33Sze52W1ykxLpTrJr1NbJ83NEmcl1+iBc5bq4WTXiaK2VX6d93x451gFv4FTBtykxAfx1oqHO0I1CkL9vnlrvGFHbogqldDKsOE01GkfY42dmkzs4jhtzukzHXdDGGIgcqhO7Eljsb+E+1pvtmeo5tWrEqCpJ1edoyks32gm9f5Ei1lhhTplbT5ADXg1QFYk35J1Jrh+vw5kdlI/QNbpYWtak/sKX6xp/gAXGtpFNwL/nHBhk29T2VTlmeKrWNeK3+GvJIVn6pU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:40PM +0100, David Hildenbrand (Arm) wrote:
> We do not allow offlining of memory with memory holes, and always
> hotplug memory without holes.
> 
> Consequently, we cannot end up onlining or offlining memory sections that
> have holes (including invalid sections). That's also why these
> WARN_ONs never fired.
> 
> Let's remove the WARN_ONs along with the TODO regarding double-checking.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index dfabe554adf8..93252112860e 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -638,13 +638,8 @@ void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>  		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms;
> -
> -		/* onlining code should never touch invalid ranges */
> -		if (WARN_ON(!valid_section_nr(section_nr)))
> -			continue;
> +		struct mem_section *ms = __nr_to_section(section_nr);
>  
> -		ms = __nr_to_section(section_nr);
>  		ms->section_mem_map |= SECTION_IS_ONLINE;
>  	}
>  }
> @@ -656,16 +651,8 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>  		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms;
> +		struct mem_section *ms = __nr_to_section(section_nr);
>  
> -		/*
> -		 * TODO this needs some double checking. Offlining code makes
> -		 * sure to check pfn_valid but those checks might be just bogus
> -		 */
> -		if (WARN_ON(!valid_section_nr(section_nr)))
> -			continue;
> -
> -		ms = __nr_to_section(section_nr);
>  		ms->section_mem_map &= ~SECTION_IS_ONLINE;
>  	}
>  }
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

