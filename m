Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B077FED9F1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FC76B00A5; Tue, 17 Mar 2026 13:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6CD6B00A7; Tue, 17 Mar 2026 13:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33B56B00A8; Tue, 17 Mar 2026 13:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 914B66B00A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:21:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C2DA1A02DB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:21:28 +0000 (UTC)
X-FDA: 84556221456.10.1527C48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83D5AC0007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:21:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpXaC+4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773768086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT2wJ1aTmqW81Py6vQ7bIascniqxbhpLxrxeObfJjzk=;
	b=38PqFEDcKwuSDtv6uXBAi2AvNejERH39CK67wG6KTzFANRMf900VQOpCWwllZKFzHMI4FU
	jJhRQs/Qg9H/ErO/CudPIm6Sl+RpWBgk/qLZgwMfph0qLMjWr8f8V3HA1Zz0iKEyVz/17T
	dyoSLb3Q02VOlT9Ixr5mCcltiusgZj4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpXaC+4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773768086; a=rsa-sha256;
	cv=none;
	b=HZqG/c3x3sQKDg05aEI1KUZ3UBMRmGn95O5MY9TBpvL9ejkgJEnkqyNQoXwcsJKbdS85mk
	YhKdAfGLRrauROop4SupKD/XmCx911ojM2jG00SgcqDToPBDNNFMMVr5YlF/ElygDGYMN5
	47Vj6gsuo4miJNlfF/OQo5JA3y8Lr3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E935360133;
	Tue, 17 Mar 2026 17:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6E1C4CEF7;
	Tue, 17 Mar 2026 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773768085;
	bh=aCHrUD8+LmC43GsbN4nEVNsRfFAFX8etI0ZbsdYUK/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpXaC+4IB9mCgF/42BlBRhw6KVqOa7RR79BYddvDCTBgjA1gLWe+RD+aF3NGvHsIs
	 ebZVzsc1DAjrIciSrlH7qS2i4CrudMkxxc8IIgtbzG2gu1vfsrz4YEk5ZTNzwV/7jz
	 1TIZruvkoK5fMndOp0pMbv9pc7nyi3gfX2lgr9AgRGkGsTovEHui3yWHJkjTQB9IRY
	 /pq3TyUUeDI1GFbTMgqJJFTNVhz4d9utSWqf97jJ+VT21vmAlHQuwIh1GJJCXxwHNZ
	 9p+fcsYVNQutrx8dnSA2jC3vnGK90ju3XFrX6ww98WIen8Qlg8ghuPrAWI75EdQl4e
	 ATXExyJTigkjQ==
Date: Tue, 17 Mar 2026 17:21:20 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 02/14] mm/sparse: remove WARN_ONs from
 (online|offline)_mem_sections()
Message-ID: <7056316c-e811-403f-9edf-8ac3c4248dba@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-3-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-3-david@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83D5AC0007
X-Stat-Signature: omhgggqagx39jx73gtuk18eu6czfor8p
X-Rspam-User: 
X-HE-Tag: 1773768086-541956
X-HE-Meta: U2FsdGVkX1/jX4TjvPNi3X5tCW8epSnDzv8KBQYXxp2sWiLj88AljuvTBRSYWa2PAixrPHiG4Bw8RnsK3FM9Bgdg9Y8fWIbu1Q6DHTppKcy7Bp36HEZqy6AlGLbqNI3lfVsFqbMofNzzowC7CBeP4nzRnVXmbgkmwYJcXh6LeSiUxPkWm5vlCGgXIng3310JLWhhjbL13Sa7LGd5T/G+lPL6gM2u/wQ9wSywXp3lo5E63hlbLndcP9zFILcfXdckTyWULab6fN1chVIze9aD5futePSQE5yf8rkbahQaWRB9JasJKcW+9yzYB38G4jKIr0pKXfkxQrrHdh8tKak9SD+mngUaJAtM7wQ+I1zMfv7r6FTpnEuY2dH8KwkSnhVjsvn9d0VNi4WhC99clxQBDdVVulF4l5308WPngrSTGlhJLviyP/es0U8ZjKVDYTZpGN33WygPXG9EpZbR9NhN+jVgP+nIVGXQ7/ZAXVggOwVMZjM5fzoKyh525fNoz6FEY7oxAbkvtRwCl5cb0kQpvc5DQ5sWCvtBGSFrxWx1b1wWZXLH2e7kKGOLb0IqVC3IkrzPC8waS5aYh2P2ul1AGDhj5No8GISEzKak9hfxEHHflQ87wsrjlgYdDtXqAf7BrttAsqXNzl49HQAly7WTHH//P6ajIhPxLvW7qf/b+NWbvERvVbovzLpTYkHrOYNxCDmid4WHWgpNN3rWhXkNkdg1Qcs+0cozd3Kmd5KJPAAL44yABB9jsGSQyrKZfgJWjFjui1u72YDCTpHx/gGLRdkpy769mEqh4mOK+IZIIACckKtzwYjJPumxrIK00dh9I1ykL+FcVTKC2VkWIvix7QP0m8nYxuH1qnMV3SYDstgWviP/NbYpKY1jLMDAFAOY4gJL84xyFXqnJshexbu3R+Iu4ggmvWeYRc7k55DqcGcovjpVGv1odN0UmaUUGNV7G+wOzvU/tL8FQoY2fG3
 iBSrdtgZ
 7jlx+VHXhCyijrQAm1YfdJ+Ui0TkGfQpkVYIPGdlJJWrbzzGLwwKw9EcH54/Y+5ZhXKS5Gc7Q4ZYzrtSO5wZcbFz7PU+Am3K91jAo3dO+H2gBdYxSBeB09AZ0989lkI8QUyPV9iQ/4TIYkTMQ0jLSJHUEGHkGL6WhG+Cbipm6jtkVpoOlGQij2AXUxjH4G/tKLHMB/ooAcFgl+1HmWAdb0catzVukdMZCVv8FADQzjJFKiI4yXvNrxHQ0CHcbBiY2iU6tCGdwbT+D5fqnW2pzaM9uyGJC9olZSUDgX8GaTx5sOzJyTpveyzzfWuWuByF5J6yA
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

I'm warning up to your series! (The bad puns may/may not continue) so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

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

