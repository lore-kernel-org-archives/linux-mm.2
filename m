Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E873CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 08:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781328E0003; Fri,  3 Oct 2025 04:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759578E0001; Fri,  3 Oct 2025 04:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EBE8E0003; Fri,  3 Oct 2025 04:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 539348E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:35:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B328B85D3C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:35:50 +0000 (UTC)
X-FDA: 83956144860.27.84762F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 612281C000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:35:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LDSFop/T";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W4Z6NyaZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LDSFop/T";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W4Z6NyaZ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759480548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKhGqKWYXB0Whi2FFFvg79+OnJq6OL+eV6niiEbIzNY=;
	b=lrZ9KOPzj5jomI1hHZGS4hMs+umcor94Ih3qKhip8b4CpxUCJ+MY/+uutloK4GlJLCKWGF
	o+ySu1uBqIsj+qnnM2UGA9dhK+E3vltzPLlKM4GwBAl6q+PqjeuQNoavp3xOiBkj5sqo8k
	t4dm7y/o4muAC9lCQ6ntDj4Ajkl6OrU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LDSFop/T";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W4Z6NyaZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LDSFop/T";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W4Z6NyaZ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759480548; a=rsa-sha256;
	cv=none;
	b=S91tQU3nNSVdExZRZaAxQHMRhsYto7ZnmjjgpqqdpILOkugrvH1OkU1L8ZdT+OzAcBUZjF
	jI8sAJ8nA8/0TXuPXrsL82kgI0R31JLlToISAOGhR1A90hwQspNvQpWccto0mG5fy1vAet
	KvnKKZ3YZKdZhLFW2dPp/Nu1lrBXzPo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98E0E1F388;
	Fri,  3 Oct 2025 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759480546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKhGqKWYXB0Whi2FFFvg79+OnJq6OL+eV6niiEbIzNY=;
	b=LDSFop/ThKXqPoH/QB/KoM7KcPKAWzHsfQw0YMqySe/G6hma5O759ouoSZEpd/ZdvzsPhQ
	ztvzFErbzg5jdtKegWt4F24xxg8TsECp5Iwb8WzL/CqLoamhZSb8Ceqxs//egXcEolujap
	XaJg47rPCv4cDmoeQs/kiGQ8joqbL5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759480546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKhGqKWYXB0Whi2FFFvg79+OnJq6OL+eV6niiEbIzNY=;
	b=W4Z6NyaZQX364XOSjJoKQDHMnvB0rhPlY2A1q9IbodVBxL8GuxRNWbQlcM2VgEBsG1GPXQ
	XxqtGiZfqNIxY4CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759480546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKhGqKWYXB0Whi2FFFvg79+OnJq6OL+eV6niiEbIzNY=;
	b=LDSFop/ThKXqPoH/QB/KoM7KcPKAWzHsfQw0YMqySe/G6hma5O759ouoSZEpd/ZdvzsPhQ
	ztvzFErbzg5jdtKegWt4F24xxg8TsECp5Iwb8WzL/CqLoamhZSb8Ceqxs//egXcEolujap
	XaJg47rPCv4cDmoeQs/kiGQ8joqbL5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759480546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKhGqKWYXB0Whi2FFFvg79+OnJq6OL+eV6niiEbIzNY=;
	b=W4Z6NyaZQX364XOSjJoKQDHMnvB0rhPlY2A1q9IbodVBxL8GuxRNWbQlcM2VgEBsG1GPXQ
	XxqtGiZfqNIxY4CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 764E513AAD;
	Fri,  3 Oct 2025 08:35:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xeiGHOKK32gNcgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 03 Oct 2025 08:35:46 +0000
Message-ID: <db51bcc5-aaf6-4cb4-ab62-fed9d40d6caa@suse.cz>
Date: Fri, 3 Oct 2025 10:35:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in
 drain_pages_zone
Content-Language: en-US
To: Hillf Danton <hdanton@sina.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, Chris Mason <clm@fb.com>,
 Kiryl Shutsemau <kirill@shutemov.name>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Hillf Danton <hdanton@sina.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
References: <20251001234814.7896-1-hdanton@sina.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20251001234814.7896-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 612281C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: jsf19dbu8qdognh4i4kadckz8zct8jwc
X-Rspam-User: 
X-HE-Tag: 1759480548-545662
X-HE-Meta: U2FsdGVkX1+iOaErAV3qbTiuOy2+KxK0zuyR/Rvw83ETnkctFTRIPhiX5OUr4zjr5tM1+SS8j0Wpn5JXecEtCVT50Nosq3Pk01379zq0DVHcGBZJ79hkMHVdLAmFnl9lFvq+rO4klCdQAIZU9YFBWrbtpJGU8NZasI97Ve3Ibuvt4uAk4g86A00MgCaE/mp6igXuPoK8cb2jnotpdRuPNmAdmk+AGurnr7kgwrWn7lIPerEQyu3Ss15SJ6jyp5/6WlTrXYGuYE129h1eJtxMVVTYj7dCesPHSvwm6hYcHTfRWpyEH/q/eJUzlK60w26RLffgVfdWMDWMDgY0PuCBfelhKMNc+gjEkpGkfzzBUhVpcoBC38B3tHjG55A1624U3a8+AgXZ/YetR6B4tQQSjOl2sPlsugPnr9fp1tGmLmZnUyd0GWT7wyhHkxIZ2rcd3+4kY4+6SYcDO+i6aI4BeQcKudrRTtg71L2z6kSZEjkQ0K7CCY/9GIYFoRdr2YJrCw37oxoMmedeHq3QC4jY3dQWp0XdQ3WLFFPJVBYGc6lmS7VKsOkLeB1ejC6OCJmnACSr6cC22LWsDMOhIVG6VVPicfpeFsK66OFhF7Nus0QLig5k3Nv2PngnRwQZQNgThiGO+wWTmaAAUKQ5vWmIdprW88+ZGJItt1I8TSUlhf8dUrQhST/UemsFFfyim12biiStuKOdg0fwSYKovzRsPbYhuuFQ8X2ZADbBirIFeDp7AfHp9SylgyEEarvXnMWfrEQOae4PZX8IzeuuewdR+YEPDB60keiRUuBq9ef3rCy6PV+SBpJVGx2DQi5bicMrM3/qbpmQp2NXqE5fF9tLU0z0u57rHpqjtacqie+kw8m6Jf590RT/vO+TiwAjyJS5tmzZOwf6H46DpGPnuGDQcNZiQCP4q3E+wxviXnwMM4HFx9o6Q3nIHh6+nHOF5QL8k9SGIWTETj5R4l6WvJ9
 fhPDweTj
 Npd7XakGInxu0XIlCYVvHUUPjxLETugR+Ze7TRa0f0eaYvKofsoywj/3kBXLERnBOKHR70Zo0BUj6LQIWDL4VAyRiE00kDnPG7qfBFb70YehJusuGZ/XGWfvy3quCWY2HP4Y7H3kukFBs8Vq6hYa3nfD/SwB8qc5X/Ywdh/ici4WAqVeMxPuEJ4VCzE+S6nCoJ4MZSs7tKz6E56Vw49D4E+rmYXsNgPHuD3qF9eTKcnnqM5lgx0XEuze0w1ccvOA0k9qHhNoKjKvkroxMb0eoW0Bu71w07nqTx/3HjFAff9q4lOVHwiEVWm+9VYYKq/BBvdmdeiKLEQwZpHU5PhE+uboFqwCe+vDbFGkGBZsVxF/5X7rKtMbhRvdFU/anwiA4huvpEJIbm2CDsDYuPouyj8Nbsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 01:48, Hillf Danton wrote:
> On Wed,  1 Oct 2025 08:37:16 -0700 Joshua Hahn wrote:
>> 
>> While I definitely agree that spreading out 1TB across multiple NUMA nodes
>> is an option that should be considered, I am unsure if it makes sense to
>> dismiss this issue as simply a misconfiguration problem.
>> 
>> The reality is that these machines do exist, and we see zone lock contention
>> on these machines. You can also see that I ran performance evaluation tests
>> on relatively smaller machines (250G) and saw some performance gains.
>> 
> If NUMA node could not be an option, there is still much room in the zone types
> for adding new zones on top of the current pcp and zone mechanism to mitigate
> zone lock contention, see diff below. Then the issue falls in the config category.
> 
>> The other point that I wanted to mention is that simply adding more NUMA
>> nodes is not always strictly beneficial; it changes how the scheduler
>> has to work, workloads would require more numa-aware tuning, etc.
> 
> Feel safe to sit back with Netflix on as PeterZ is taking care of NUMA nodes
> and eevdf, haha.

Feel free to stop making such weird "jokes"?

Also you should really stop dropping CC's on your replies, especially for
maintainers of given code. I've only learned in the v3 changelog from "as
suggested by Hillf Danton" that there was this subthread. This is not
acceptable. When the feedback is wrong and uncorrected by others, it can
mislead the patch author to do wrong changes in the next version.

If this Cc reduction is due to a problem with your e-mail provider, get a
different one?

> --- x/include/linux/mmzone.h
> +++ y/include/linux/mmzone.h
> @@ -779,6 +779,9 @@ enum zone_type {
>  #ifdef CONFIG_ZONE_DMA32
>  	ZONE_DMA32,
>  #endif
> +#ifdef CONFIG_ZONE_EXP
> +	ZONE_EXP0, ZONE_EXP1, ZONE_EXP2, /* experiment */
> +#endif
>  	/*
>  	 * Normal addressable memory is in ZONE_NORMAL. DMA operations can be
>  	 * performed on pages in ZONE_NORMAL if the DMA devices support
> 


