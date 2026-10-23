Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE01606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hC/L1MQ7
Received: by kanga.kvack.org (Postfix)
	id 30A1E6B0B1E; Fri, 23 Oct 2026 04:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB016B0B20; Fri, 23 Oct 2026 04:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D12A6B0B21; Fri, 23 Oct 2026 04:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBE466B0B1E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:20:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7256380295
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:20:03 +0000 (UTC)
X-FDA: 85353193086.12.5ABC0F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D038D100004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:20:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hC/L1MQ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792743601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+uZcRKsV5h7EXsxKjGUwOGNuNwl+VfHuYMNxjipb3o=;
	b=G1J7C8v81mn+WrWxuScfAP1MWbsa6PV1qyXD3ZFZFvv/x6ZMUmL3y++bqqmNBtCr1XUzTb
	9KCsqpCVsu+cwraYkALpdyFFwNqb9bekVe9walxjaKfEU/cd6dD7KxJOIXkcJ6EEPMY2Lc
	qkgoUQhWr5mJYoNg+x2m8+jJbxijT08=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hC/L1MQ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792743601;
	b=ujCPIVF2jQynGOyBSsSd833O018F0N5nV1HHJeLvezgOseFt2dfs56IRYOyBC4ECik47gV
	jzfkxQ3RajI2gIY56LLk+tA6SpmGaKgLXMDB/7K7gK3LK2uNlEgHYVgtJZILwHDaXn8rWQ
	Km65b2n4ln69O1w8LD+htLuVtIl65G4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AFB56024D;
	Fri, 23 Oct 2026 08:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739661F01825;
	Fri, 23 Oct 2026 08:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792743601;
	bh=w+uZcRKsV5h7EXsxKjGUwOGNuNwl+VfHuYMNxjipb3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hC/L1MQ7M1aO8VZ1NXHGDX9iszEeVlPNaBbhvunGdg6YNBPw8L9Mzspsy+ar1087V
	 HmI/6gwOaEEx2Kl+YPdzPJZt36tE6xVjAKtEEucZ7Tmsn7YBZNJaj04xcEv4cCsdqT
	 vU7oHMiREtChPgWu+glIZCkuwamoY67wWqaJ4q9USt5OWNPUp4zvOLwDRVfw9EwNbv
	 Yps23mfbB9M/jv+2MAx6cHKMEPuPmw0tRfdrDDKlr6q+B852EUofQvXDP6WhhStfy7
	 4OfSVa4tbqcjD2OakjYBIpsekvIf0gLa5MNL9qrnUPH3S5/pgVH3oTl4hj32sCWyr3
	 teIHgcWiNO/Lg==
Date: Fri, 23 Oct 2026 09:19:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
Message-ID: <atsYe34Qvw5oUDMZ@gremlin>
References: <20261023023106.515365-1-luizcap@redhat.com>
 <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
X-Rspamd-Queue-Id: D038D100004
X-Stat-Signature: xkbdhs31wcktw4xg7inu57ceje4s7yuo
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792743601-845191
X-HE-Meta: U2FsdGVkX1/WRTqCp8XMY8WySx7Wr76zt6zMmk3I97kfcmgdlG9OqQJDlSlDkFP2YVk0Rc9MHJ/fxBHagnma9HabWD+RilNwCEfJionqvkK+/C3TkV56S42VfqAPAqpUbR3VyJfcbZZ8X5H27kY+eUUI1Lnw2uVVyJ1uljfUmR9ASDZh9BqJdoeHCy2LsoY6er59bkSd77eD2bYQ5v/+KrABA0SYF//enqGzIIkzD0rMQKbuCoAu4J/r7Ys8lTfXhbmdW2KjRBhKOH7FJTL+2CnDjYkuA15eIkBQibgcAX7X+QlwPnttTWuK4I1OTQhLT6unS427v6PMmkPzyA2c7+C89kzgzTarRTNacY+qCG8O2GFjBNzMZsuFGKoDNQONp1/24UJzzkQAmylo5B6QADKbY2Vvthc1cj0ilQSS9y57NIn/bt7FAsbDQS/fhXAhuxND1gIQ+QOfu08r3JRWbaIlWmxhJS5O4P86eS+JkuEhvlmqeP7XSxgo8WcYYHLIhtiOmVUQ3nuLNYiqN0zT712T3Zq89g+NOTWQqDNX/AR/F4NutKjhQYzkbKS2paEiN6SWDGpqXCua3c1t3GSnhBZlpLmQsZr930ejkJMK6JX7AxYxwbgq73eTbRw4oTaluYmAToRzbMfurcAQdJyMdmNinxV5kLWpVX1Sk9FwqykfRi4jTGVov5oErQbBffCDaIH855ln8p+Rc0Q8vdDZo4FvIvgC/5J5NcXLstuElzYplAU5MyMABNqU85WuXTawDKFk4/2lK66t4v2kihaSuXRch9Q3a/mbA6bcYOufqhe2XnuZmRXHtNu15ahZz2odZCAtgXWI3UKltETElEZ2rX/SLo11C5W6podHLkIDJcboerwSen6I+d3TjHDkjo1RIvi71yjl6MwCpHPicOhn5FpfDCmml0jGDfh2r6D9uk4hcfS8turmAT06IudhLDCxcjwTQFnKvP9st6h6egg
 kMyjLxAt
 LCaFgsfZIF2Q3wCW3xN+ciPxtlr+dE5Zeb7SvR2qbUz+N/dLsH3AvhNoG5p1IeZBjji7RgkGQM6pPNLFs0xH2oplVfUTLtPrl6vQjARU75PwYxlqjyQWph6CGfLKRQgmJPRrnvJsE6ZxESaQNnKU/gXLdiLt7F1ViFbQMqc7l52NLtqbaf+y+L/kTWC/jjVJFWIpNDLi3tEiP3MeB+gU/eDQqALf+FP7r7rDHcTlHWw6v/5nwVJWj4IP9J+i+3X2b7MYnhvjo0/PInDE0unTKg3CCzNwsik2Plcv42Y6Hz6xa14U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 09:16:12AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/23/26 04:31, Luiz Capitulino wrote:

> > This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
> > after mremap resize"). This commit changed mremap() to use vma_merge() instead
> > of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
> > a VMA that has any of the VM_SPECIAL flags set.
>
> Hi,
>
> 6.1 was a rather long time ago. How was it discovered just now? I.e. what
> use case broke by the change and prompted creating the reproducer?
>
> Vlastimil
> Thanks,

Thanks, I have the same questions :)

Do always include that kind of information and whether it was an LLM-discovered
thing or whether you had an actual workload that was impacted, etc.

--
Cheers, Lorenzo

