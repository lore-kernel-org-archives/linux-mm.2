Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA80CC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6E46B00BB; Mon,  3 Aug 2026 09:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987006B00BF; Mon,  3 Aug 2026 09:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800EF6B00C0; Mon,  3 Aug 2026 09:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E886B00BB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:52:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F00D1A0690
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:15:32 +0000 (UTC)
X-FDA: 85059551304.25.5739E0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDEC51C0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:15:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2TVK2uX;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785752130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v71BYkAHIRI8Q8frz24K9WW9baJGdIZiJra6zVG9U4Q=;
	b=123nhwR5QJ9+DResMTibdYwD9gRLRIVgms2yvbATob07jctJnCfL0f2sHomoE7SiV6d/PZ
	ISXnLtwmvea948ONefH6aFGGQxJ+ko6JDLniS9Oax7eRRDVM833pVO7pGxSaHSw2/sgWRd
	gG09bEa2Pqu4LLsIgL6RU5Z/SAzj/RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785752130;
	b=bcQmDVSK6zcxr3ngXrHxPcB0pXEj8Z9UuvFqUfCNK5bcxbSuYMzmeepqyGlbeVlN25tseB
	E/Qy5+ayMIrl24zYP8lUwjqF72OAHM0CNvWwhS8QNl/+NJ6pRn4sXLhNs/NQXDgO69t3cP
	SrfPnfnloSJwPYye0jStwWcPrPeKwic=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2TVK2uX;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0926F40344;
	Mon,  3 Aug 2026 10:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747321F00A3D;
	Mon,  3 Aug 2026 10:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785752129;
	bh=v71BYkAHIRI8Q8frz24K9WW9baJGdIZiJra6zVG9U4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J2TVK2uXiY0cFJv633nAghYxOTtWj4WoRxazTyou1qgggoZymwvopm2LYCBg2kGds
	 ymnEUF629L7pEfyiNWowUOOSJQuuFRFGV0mUPgZhuLD0CLW+vIr6c7Geq2Pma137YW
	 7OE4bzALZg01VNZS4/a6HHR0z4/2doG6N70QflXd/8HfBF5LxlbDxZHougZiJEavRk
	 UPdaWF+jiInQXa4aETFFy0RaM5skKQ+gkvmOLWR3CfSgtF+rR82OhQEep61xeS09aB
	 dz9eVzhUmkqmOXcqJfvphbCw7TqLCjh3jYOIQtdjIp2vHvzAJ8qyVFEMto2DgiH17d
	 n2cE1J7UNfRQw==
Date: Mon, 3 Aug 2026 11:15:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 05/15] mm: introduce and use vma_filebacked_address()
Message-ID: <anBpy-uFv7Ghdr1q@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-5-e8ecfefea812@kernel.org>
 <73adddc9-4321-4f6d-ac67-470c8f515fff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73adddc9-4321-4f6d-ac67-470c8f515fff@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DDEC51C0007
X-Stat-Signature: eug34kzzb3u8tqgfao33nezezeiamddz
X-HE-Tag: 1785752130-530430
X-HE-Meta: U2FsdGVkX18QIsd9Q/Kki6d/39lTfokyEUd10gtRCSB27pppsy9OJOQi0XAJ9+Y+nm+Sz6Pb2BhCzTebReFzht6Ncqhk3duIMOCK/4jckQQzsdRVDd96GJdrs1GDNypo06u+L9DBoWVWXwGHu4G2zNiLwWRV+j6PcHK3LBZEWzKPNwjYiD5vaLMDbJNm8lTl5RAxqyrHFSEpkQidWALEzUDJLSh+gBusnwOJGQsNhl1LMUIxmYQm/5YRssWCCyaRkEDiq5PsykNc1Ggqgw6WnoMt4JIBuQHtP7KASLrSqmKePPx7qsD9tjLq+I5RykwPQ02kLaTCe5WFpwN/R2LyajHq5EZuAALRjLM8wxgQNITYGYzw7jGpRYp4JKq05HAVp76YK4RIf1IvAMqSjzkNEyUy/MeljmQqyw8ehfbCHoxOzP4KY+NEL0gikDSjTwFo5Hycl3g3Xw4+v3zVGGcE5vdrAueubnr411AfEkhBSWRIsgqsAgBcXGSyAriXpfMviJPVNjsd8aMVu4w2jvygOppCIYoDU9xUdxIsL97ZyyL/A5xliX2bSy/HuIiX3VECehYVNkVUSaBUbY6KHya1cPz73FCxIkYxCVf5IWv03mN1lTw+XYdueRC3KZB5uh0Fr7HapelrT8QWThjl+PKGWdt0wmYlcrDs4w62zucGnrtIxcwZK5oZ9WKkzEBUglfq1taowcpt+NFuZPLh/wnbprF43EjzHF8HJxiA0DPfseHUuC3Eb7em9Up0KZdOGCLJWCFZe7PIV7ZR3qelTF63Qb+Fs744XQ/9ceAEUyRX0oqJMFgDcVkkqP/69nxhWO7Nm0MWuHXC7v8GPzoPLuoiwAz7NouEyVWB94Xmm8iU+TEpvlgmA6C+Jtw1X4ZPm0ClUE2T3s5wyXtrjaioNPcT1qXjmQfbz6rrHTEKSYLjHEjDAc2M+frgbYG5+SnoSh6whURHGkJZqkZ8OEZC9Px
 zVE3hIRG
 +Pizsgd05yL2X650cMjulUqk9OiE3O+e2MgwCBOfoWUGXIE6xzW5bDiG4rbf+oyCKMiA+ZPfkBNv86xb4ZT7xLPfq86NMmXJ60wWyLaEi5Sfv22NvAykwdqkHckUZSShzShkX6s0wtr8wBTjnIr+8uQA4zohm/6OND5PNUSm4paqte4/7+jA3s+ubWV9MwytjWssQyB9p/atrMcQeJOKt0YEeD5mdWGr/m+3RDFlxRRbL2nWuUT7ewbkwasC7kMZOpod73B0FYpB/4h9I/awAXheibJM4UccGrpf7GWc4nPwGBnCLRyzjlm7LisBOqlxSgXVvVswNzQzYZi5+JY2kSQs5KjqtK/LHCxecqUzUghzX/YB1LcfH8WjKrAUAi6FaktXfd31ROElLPCrdXrDAiWGuuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:54:31AM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > In cases where we know that the VMA is file-backed, use
> > vma_filebacked_address() rather than vma_address().
> >
> > This lays the foundation for using the anonymous page offset via
> > vma_anon_address().
>
> I was briefly confused why we can't do that immediately.

Because everything has to be switched on at once or it breaks things. Obviously
you could use vma_anon_address() for pure anon but at that point you're only
confusing things.

This all stems from the existing situation where anon folios might be indexed by
EITHER a file offset or an anon offset.

In the end 'laying the foundations' makes the actual 'switch it on' patch (9/15)
nice and (relatively) small :)

>
> >
> > Also add an assert to ensure that the VMA whose address is required is not
> > anonymous.
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

