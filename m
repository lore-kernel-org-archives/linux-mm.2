Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75104C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855396B009D; Mon, 27 Jul 2026 08:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CFE6B00A3; Mon, 27 Jul 2026 08:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A406B00A5; Mon, 27 Jul 2026 08:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56EC16B009D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:04:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9F3F1A06E5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:04:02 +0000 (UTC)
X-FDA: 85034423124.06.43B1E2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 310DAA0016
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:04:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXWaNyRr;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785153841;
	b=JgJFYeDCQCM2OEy9SsUopRKvlJVvdDPBbKAU+doGWYgAQ2ZYl0PMMa6bwZU9oeUQw2mtka
	JrIrHuwVHTI5J8wxsliFjxQPJMxNQA3xqoZtprvNP2hll70S+B7hi/VGJ88kt66Ahe09WY
	nRv7EQIk0SOLL4urPRiE10wDl2VDJaM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXWaNyRr;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785153841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2aJdor0Hpg/4jj2tv4oBgjyWI0Kytt4Ww5CPykH9Pw=;
	b=ZGfO8D6OqIMQnCZh19Tu5i4xYnYF629CiLOF9PdjfSwpw968kZGJ7mD7YODlGcDg51MBTy
	rFDeDIbEhs8BZA+Z6kzCjkSkvvk20+A3zATcTqVjqk+Ng7HTvDRvNWFi0+SVtH4BCHMv4l
	yE2sDtIEWN7VMpQT1TFcMM0MzBD12tM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 502A740364;
	Mon, 27 Jul 2026 12:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316601F000E9;
	Mon, 27 Jul 2026 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785153840;
	bh=D2aJdor0Hpg/4jj2tv4oBgjyWI0Kytt4Ww5CPykH9Pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXWaNyRrrKMWJ1IJNk5RXToC/2L4hiE1iNCbYl8psZB8Glfv0hWK7Oez2SFNvZ3FY
	 1/QbnH/o5rOsHxOr3kZErOTxDUYZ6lqoJMSUdQ0EmsPjNIStps7ipAAwAXKH/m3NFs
	 MITHDis7uQbUkp3Z9jabBs2A4H1gTqHCPmCV468Hxr7i/ZMNrfEuK+9GXs86LuT0gZ
	 BNRA9lMNA6Cvvl4V8D0gYUrNdAveWnRNjUeD+aBxIqjN0Ll18daIR7Cnw1SX29XuTG
	 dErEnkU7cyxLLddSK6WletbqXXvmomBknPSxugnmXwR4XZ5NdhKsWik6ZNFEnrMWih
	 m05vdEyriPRdA==
Date: Mon, 27 Jul 2026 13:03:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
Message-ID: <amdJEz-Sl8LRB_5l@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
 <al5CPpc7XpRX7Vbt@gourry-fedora-PF4VCD3F>
 <al5Surm6fPIl4LNA@lucifer>
 <al5ZPYH-0T6IPXox@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5ZPYH-0T6IPXox@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 310DAA0016
X-Stat-Signature: f1spazgww5ngouna3ku3di4xhok5pob1
X-Rspam-User: 
X-HE-Tag: 1785153841-616713
X-HE-Meta: U2FsdGVkX1/OrK0ARWkYAKd8vQjUKZoHF2zi/U2nykvotK4M+52r0KAaXvYw5LHMkN+lyMt6Co0giyID2+XOEOwKFerY9xcgZX3Oc5PM9Sf9bMHjDIdi9cuRCMYNVY5xLwy7orjWXlZFcKlJqS3y5Qnp7utK1m1MFdUxhMs4qH7N3KCMaStn2CA2p2g6TIGGRbbHJxpwu9yuO9rUOo4SP64SaS5EjqIjRzojU+D+BxwR929++fndT8f71HcHaqW0x0XWqsGJzVGRMkMQwU7I3RsKni0B5r9qcDmp5wpidFv1chKegFJabW6OzoAQONFtIRlEpreZs/vbjv5b/xo23S45nLqGSHpd0nouf2aAUlvZUYdhBLCj650jD85Zq8KTrTs2ApRuD0jJZA6vD4BbN6KnGlgu028ZnDEEA5rWCKZBYbnOWbmJll1DFCrEch4QtAQS9k9msaqhGt0ybkl8RtFxw4q98IGhWOR3ROXOXzMiT9O/vYrNW219p0iMLnnb24M4UUghfNeCTPx8KH+0VRgRM2c4HpAaA417sCl31ftr44o/le+9+obGi1PQPBPpPtYNWPmmWFJgAjIKmSWSb7To44wKPNLD6SWjWiMaI+iwd7vndPoPUfMUqkFl/voRUTPp2+Q+R5siOdJjEMe9r/WUkQfizD+vvhJj9Xu6hbXhKbD2HTc7cxROy5oYO4DMc1eXcljd1LVzpAqPkqGW861EcQgPW6XFHJgr2Aw5bsg3qYjGBN9NgMYBJY7VQLNqKciEoqUPuK42v3GB6t+RZyHoToc4N0pUruxvMzlnZNKqHV9RJVMymWThsS6nFSxF2DwB9Uz+skHA3dy/1fmbeFOaeilC4Ap2kqmb3f4LIC49/MiTWsKVaJ8cAj3GtmiMhsdT+jfE/4IVgRDy9qcUN8Nb/ucgCzIsp4O1uQCLuESeuD0dO+KHCYArmWX3hmNpawQfMAqQnqUrx1eqsh9
 whEwnk7W
 2UQ59jgSJfmI+JkOIBhb+ySw1mYSU02yNnkhO2ynJbssBl9FszwNx7tGtzvD1UsCwtRQiezUT6JiQzgzEknzg99pHeKjs9x/WIIgMCLbvgvc/Qm/Vi43tPeRjuZjvyE7lV4JNk6pXTyTB+0yvTdssZVNlxLvDMxjb9hAkQZKnoBl0DTGQJLiZT8qvbFmgwkrFNoZUxPK2dGZY4/lJAOlIHvMBDtsan7F0iS6TWbPT4J9Xc829ekmiG6LL+hb+Dgiv8/3ZB5tRpABA1lWNpMi7UqEZAoht9wcgWyfDhconQSyTI1pfX8cc8INPCdr73ZzMn4rHylGYwer4QBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 01:26:09PM -0400, Gregory Price wrote:
> On Mon, Jul 20, 2026 at 05:56:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Jul 20, 2026 at 11:49:00AM -0400, Gregory Price wrote:
> > > On Mon, Jul 20, 2026 at 03:38:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > >
> > > > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > > > they are unfaulted or were not remapped, otherwise it is equal to this
> > > > value at the point of first fault.
> > > >
> > >
> > > The latter half of this description is a bit confusing.
> > >
> > > Why would the value differ from (vma->vm_start >> PAGE_SHIFT)?
> > > (because it's file backed?
> >
> > Because the VMA gets remapped.
> >
> > If it's remapped when it's unfaulted, then virtual page offset gets updated, if
> > it's faulted then not.
> >
>
> ahhhhh the wording is just wonky then
>
> when faulted or remapped, x is...
> when unfaulted or unremapped, x is...
>
> instead of
>
> x is ... if unfaulted or were not remapped, otherwise...
>
> Sort of a complex combination of 3 negatives there.
>
> ~Gregory
>

Ack, will improve wording!

Cheers, Lorenzo

