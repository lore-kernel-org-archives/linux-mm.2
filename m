Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E9EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3596B0099; Thu,  9 Jul 2026 02:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CB96B009B; Thu,  9 Jul 2026 02:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5376E6B009D; Thu,  9 Jul 2026 02:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27F036B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:24:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3D671203F5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:24:45 +0000 (UTC)
X-FDA: 84968249730.29.75734E2
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 07814C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:24:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TZAKPicL;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578284;
	b=XVXodSym5nXXNs7AnzNSa+0d3jFIHF2akTcmsMWa5jmRSxSW3UVb0p7WtLU6oGAV9CzRQ6
	BEn+ry+ImtzzsMvOJkA3aKAfFZl6HvN4NLPIfOIuEf5Y7qoPo+/V+0shP+uQv4pstjFUFM
	FIDNu5gvgN5ijV9tLED+Gr6cSvK/JHk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TZAKPicL;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPR8Y4wzyQDgs1UrfuCsKSlR5/a7t/3ZTJ5swVJfias=;
	b=djVhBBLdApRSMeWu9wahaepFHJg4HwaxnB32QyrpL0mU01c1eQ0BeN9RjFGuOSiTQrJO84
	6P9BhF2+hYsky8u2Z+VbKE4AaZnVh5a/6jOno6PmzjTTOEk8AO+DYam+Aqums+TgHzijwu
	uohKlmyzOp7q6J4XKOsMWGWe0cMhNOU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPR8Y4wzyQDgs1UrfuCsKSlR5/a7t/3ZTJ5swVJfias=;
	b=TZAKPicLQvG4iCtdWX5qIm0Ta1ZyZMks4OYsriGOofIlXt5dzLZesv3etwdGUDh2U3Te7n
	PaIXroz/cy+D/dZ/oU3RvQMp99Xglul0WWReBqvxS+UkfSxSf7wenmWOA0uctrhA2Vbeq7
	KvGnvWgneSi5qsyMrMphlmCrBToemas=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 04/10] mm/bootmem_info: allow calling free_bootmem_page()
 on pages without a bootmem_type
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-4-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:23:58 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4E28941E-03DF-403E-BB01-0AA5ACB3B640@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-4-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07814C0002
X-Stat-Signature: 6p97mgr38twgq7oekc781kup91ftaihm
X-HE-Tag: 1783578283-573556
X-HE-Meta: U2FsdGVkX1+lcOE+4mfU1nTXEXmy/g6ST/aeiMLmvKNr2Jc/RMpBxqmrCbgmUnfegWZwUhjATKK4kFGiMBgsZIpHaeabv4zNhRrnr5nMyjiufjs8MW4uTQ+ChmTcSYLbp/8yiA9xSWGu1pp0BggNf7L8bNIle+1DK0rqN/ws2PFfk3CejUJUtY/a9hEJjT8gBAwGfXe9HUGIJl/GSrya0jjPtUF436I4fLfRQzDxDJt5zk7gYU6yyU6aQZ92s7tqxmqr7kJSJUmddAV/aV/W2J/yQw9ZKn6T6+zk0Rbxc+IOn1nyGiN+cFIHoz/E5088cGGo7yJBAKym9dyT+vR9XMDd513dIWw+osullLk0HsEeDZClDW1vNe7lvZ6DiiDN526rixMe2/E0aGrkuWAZbvkGEvf4L5TEVBZeeLPw3hjAQl1KpxGW8/pbAPrY99rP5nhc1j6pChAxkEtvzSZqNP2z9kL0xT4Koa2SMMQ2A05w01Wc+zKXCpGU3Hn68sBqYaWJGLbA89rqntFsdyG0tZcGK8ffBx/kKneG2gcEGvAv/BEX8EYgq6PH79DF6EGV3HmR+qh1jVmLAT4606ffycu+qraIocsSbJ/5Eu6a/aFZMVQsbGyzSoUUTLKn4WROD7iJimQTfYPqnaLjd8PznT6sHsko2ElpLNzd9a+MD4bNBQjFdxYox5Pmyezg2eI2FGra0RiaVA6tRFlpJCIokoZj3Q1kjhq3UuAxGQWPtxUpGTjZ3GWz94VsWhqxTHMKmYG5ih2MmZo7fQ2zpqL6Vio4fhUuD4VZDHVQNcg4fD6oV+2CLvHqdKjxX6a+C/0d45w42q74sDNa9zyrfi8HwwwxyfFCeBK/z7IwIPn+nzGgEIyb0TJ7fUUnY7E7ti5LSMhJqk14veZpngaqDZlxggrflefdn+YnPba5njQJ0DdXbq0KeRVmeoiDTdohu/88RcU7dqXhQIIC1Clpycb
 qtXQijTt
 rB7ROMNLXRKeX9J0OCWBV4J+6N4y426eghOyrowhvftDg14hpjrL1BrZYy/tug101sNpRdft/jQQI/AJJGxqCK3n7zD566cus7OCWVDi83yFXUHBfZfdb/CWoubrSEHb7mzuE+qXdFuw4CKUtOmCqrWxuegUiyDHC0KvpJ7DMYyT4fMjGd38OwUSz5lm7IcIojFpYQ0VIyIoQYs0Q0wX8gkM3RPr277eNfyCtHr3n0JGn4MmfFqmLOjHBXBCjOjw3nyHzGu9uKffB65hj6RDWV0BITXwoIWtLVGGjZBvCDQcXPSiXVA6TVPgQ0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:10, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> As preparation for further changes, let's temporarily allow freeing
> pages that were not previously registered.
> 
> This will allow freeing unregistered vmemmap pages allocated during boot
> through free_bootmem_page() from hugetlb code, until we fully rip all
> of that out.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


