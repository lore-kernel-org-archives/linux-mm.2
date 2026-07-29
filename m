Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F5BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 17:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344546B008A; Wed, 29 Jul 2026 13:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B4A6B008C; Wed, 29 Jul 2026 13:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230A06B0092; Wed, 29 Jul 2026 13:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04C396B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:12:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83B491A0710
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:12:21 +0000 (UTC)
X-FDA: 85042457682.19.164D795
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB89A100012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:12:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Arj5dKsi;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785345139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydzhtkpxp5BQwBhGox1Nkoqh6PfrK9kxbIuBs5y9N6A=;
	b=vFR/8JCqJRSMFFu9D2LO3U5cv0luNrVK3yBWAMnhC4eRSWY9Rzv8N4kT+6KSd451w800yR
	i6FuEzNOMhlgyb3BxrrrD/vOLNco7QqlACCLuCTxo4k5LRLGjzxx+I5tmuEm643E2neyIq
	Nw3j7LLCfYaRsWaZFViYuG5+yOfC3QQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785345139;
	b=fglPp2kYY6bQOGFsxv60aIRCbdJYshqEokH6QY5WUhOMKtxx7V3ES9XsX0uYA9VXsg5E+G
	hUVEaMOooiuI4JCWt0yTzDghFwN2h9QA/il5ioDbMX7ZXO7eIyYQ9owQrI4MYCmmPtLunK
	9Sa1CwgSo2FHumHiM2MdwGr/atQkfwg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Arj5dKsi;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9195642A46;
	Wed, 29 Jul 2026 17:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E102D1F000E9;
	Wed, 29 Jul 2026 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785345138;
	bh=ydzhtkpxp5BQwBhGox1Nkoqh6PfrK9kxbIuBs5y9N6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Arj5dKsiADp8nzEpUb2nTNNXinho7z4KB+KTxpgxU3M3yvn60+RFOmnNHG5ecfqAJ
	 UQ5o7ZZJ1dBuhIe5OQAvmNXX804KdLEqbcExYpeFPsKkoliynK1brjrpy8v8wuVNAj
	 9tsdNB9T1AJ3pPoagVRqpo6EY7IIkwOzio0o/hV19or7vSRjVCruI+SX9wHjpCpWnq
	 3EVAHecRj4333tJh3roqqmzcBe0I4jHe1JIFXeEFLRONNo0TQ602dozpVVFamqGigb
	 v9VRmlJMbiQHnQnkwOZdOjZN+AHhn5XH/rHEPDgAnTOiyDBTaFAU4M18N0KZlIcwPZ
	 qX4IkiEsH6+6w==
Date: Wed, 29 Jul 2026 18:11:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
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
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field
 and add helpers
Message-ID: <amo0FZFM238Xd7BT@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
X-Rspamd-Queue-Id: BB89A100012
X-Stat-Signature: n3m5ykbpk9ejkz7hmojh44ubd3yx93bj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785345139-920391
X-HE-Meta: U2FsdGVkX1+PwH7j/NK6fKTRRtsbEwQt/uDfCbTMH+Na1qH+chJcNcGbunWN18w9zofy7fpZHVkxmIb5mzGDLojQHpW6ELgy6VrqMdG/gNwYgnUlGxp5saJruUxhDX3QYmPXaL0aEw5Cd6JoNbbw/WV/RISK3w3HiBBW12KCaQHNMbEQdN7xga64X/GmN8h7d5/502zrBVkBY7Pc6Pu2lHa0iLHZbJhIiIWMbPQ5w74P9OpzUBF2lHti5vDSa3RlSYj6oNg+ebVAqhGs/CFKC3eq2ycN8F/dr8NujcAXgnuWk6t5+nT9gs1BwzWlB7qU9zFgT9ZqHtKMCOMyD96wd0apfXFf5zZxUPFTXQWmW5g1suA+tgBYfPmY9xeSpNsVSqloIE0jnFlXw4wEkqmEyPScncvbiKuTAjYS4Ai3PM+bNEzYhq67mpbsHT7S+SWBPqax8vnVl2qkeKgPuNYW4+GjgaRc/CPdgHlzkwLAUmys5cJwp91rAZN8VLSMPB0o4c4E1mDOVjUiGqCUsHdCXiNpe6QsYWNfF4teh/e9i0Z7WepgKWCy5f9E074f9LaOLN0lbOWqp7XCy5oIoD4nN1wvlrhx9s9zPhOLE8JfU034IvrNLU76b4hnrTkEhTOCqqSyF2kn2q10fbu+wMwtz49Pb+R3Fy0o5nWq0/SDGvVOigoa/6Xh3mwBNSfOGzEPs+y+v9DmBkAja3Q+gxk6ZOtU7RhzjOgsUG2zrUTcyPLtpeGAuV84nfDS0V0pbf3foyrJpm9siFN1E7XxcPhNvbZrhiBinHnn57b3R8ueO9vK9sA5utml1QOVsMvjGX+J+lI0nBBHgoUQWUN3ixYTmGZb5vcp6OGd98mJ7hKp/ZHYWz8KNcyyJ3Zt/w1VYX6JwAbwJneCJPNdYCJLeR1da5Boc6nn2/TD8Czg3S8/uGX5TgpnM9CE/Yt9le05qMqBI7BF8U2abBpz3m8doyp
 rJuhL77x
 An2PCUcF1VCiD7k7Fqut7nvOVc2xXjkAMuIxX+esn0Pukb3wkBBgjyZDjBsSEMVphU7sfsaamfcjw9UOpQIi5KmGtEwgKFfFElUBMbODTgWv9m1/waUaVBnS17IO3CHc7fni6B8BoUnbL8DO2nJfK+zrWsV9lX9lpw60ovY7kJk5VK+liShkn54R8MUgF+oCPZCWewuo28EwZCuQkzTRthdzMxoqkRZLodn5c1beXf9d6+Wwa+4v5fzoGJL9LpmbTKCULxhVbsrPVAfA9UwN2xl6euomDcRLaKYM05WkUHvoh5eQUwuPoupq31OZTGBgAg+t7QHFegGDm5JZx93sKRnUWwu/NJ4mBmdHgzd4Q6D6xjzPUAmouWjVgsEeviY2OmOHwdydof2axWo87wU87rrHIClJtM+R5hx+N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:48:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> This patch establishes fields within the vm_area_struct type to store the
> anonymous page offset of VMAs.
>
> The anonymous page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
> if they are unfaulted or were not remapped, otherwise it is equal to this
> value at the point of first fault.
>
> Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> file-backed VMAs are tracked by their file offset. By adding anonymous
> offset as a property of VMAs, we can now track them by their anonymous page
> offset instead.
>
> By tracking this, we provide the means by which to eliminate this
> inconsistency, and more importantly lay the foundations for future work for
> the scalable CoW anonymous rmap rework.
>
> This patch simply adds the fields and some simple helpers. Subsequent
> patches will update mm code to make use of these fields correctly.
>
> The fields chosen are packed in the VMA such that, for 64-bit kernel
> builds, no additional space is taken up.
>
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
>
> Given the relative time spent accessing reverse mapping fields as well as
> updating them, there shouldn't be any performance impact here from false
> sharing.
>
> Update the VMA userland tests to account for this change.
>
> No callsites are updated yet, so no functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sorry I forgot to run b4 trailers -u :)

Andrew please add Xu's tag (thanks Xu!):

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

Cheers, Lorenzo

