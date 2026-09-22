Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FCBC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853E56B00A2; Mon, 21 Sep 2026 23:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ABF6B00A4; Mon, 21 Sep 2026 23:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743D66B00A5; Mon, 21 Sep 2026 23:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEDD6B00A2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:34:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B71A9160391
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:34:28 +0000 (UTC)
X-FDA: 85239980616.07.A571503
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id A1BAA160007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:34:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfoHUeli;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790048067;
	b=vcHh6DtjYIWz4j7Db+OT6aAgmj0aBhkTmZkC9PrFScnFx4H8w6Tbru0tk1d5IohNiyG2l/
	ZppvfIuRrtEPAPe0XO//ClM/mf8yfbGNaaakBgNhQmU17FmTdhL/EZf081PVe84FrZuPDl
	HzrL3C8wn821NyrKeDGbGePIg71ZVws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfoHUeli;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790048067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79sGlaOtlw0358gyZvavwywbeWh6j86mj3ggjA+geW8=;
	b=4dp+JHdwqXNy6uAyDwyZ7h9ZCqDhH+gXKZpRAyn4FIaph2GvSR+0MOb0LMN4IsWdlw0M+l
	PdarNWZzpMyGKFjFt1MMrUyJmJDexj2GdBUqwxP6JDLSpmCNi/E+PjlhPxdOZChHbdkVII
	IzBMOXTkYRk9E7huy6EjfsOXFADvUPY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CjIp01xrNtfOBxRn61B9UTZFA1lm/a/pyrDp80PRKmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790048064; v=1; x=1790652864;
 b=MfoHUelik4u6D6Wo2HiRbVtk/8AH0OSVn5inWpfUPNnLkZZALD96JKRcNngp52DWgZco/1gH
 NLFS14P++YmNAnXz/2NbabIVzsxQLCUlZnDJGVJ7HGOQPj0SX32bURLTEAvbRRflWnvSvu8Grq7
 NK0Ee0xrfReA8nKLtT5XvQrg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id cd004a5251b8e779;
	Tue, 22 Sep 2026 03:34:24 +0000
X-Mizu-Trace-ID: cd004a5251b8e779
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
Date: Tue, 22 Sep 2026 11:34:06 +0800
Cc: Hongfu Li <hongfu.li@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5FE0FD2F-4F8D-4EF9-BD78-2AB97E10B687@linux.dev>
References: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1BAA160007
X-Rspam-User: 
X-Stat-Signature: skejzb5w4i8r8t547p9jx8ahz57j38h4
X-HE-Tag: 1790048066-947171
X-HE-Meta: U2FsdGVkX1917ajEXvqZ0bB6AIUBplWaq0opyE+XGWqLfsI61Dyr8S0wj6/oFKcl6I2X/7M3tg1H08mZ7Nzt7VbRFYH1Rga0knL8S9VWZ5HB76SgWePfGFzwvOzNvlQX9vbEN2pS/8Fe168SEeGHc5J+3NEJvNfzLzgGk6rjveLWSJKYn4LZasrhqdDzy5sWwLbVb2kdsTuz6xDiiis/2bGnyZdijbCKjVnQgqEpfIqGsN2Vu8s9a46XuLMLHYBWoDciBUTug4fjV+cD0uftpcavq2WLnFrVniOnwTNBnNB8YMBF0RhpcnThUyMKZBK1F/NTggG4UQNcLxFKq+U71YOc3QegDgaMn7WbPnk3qXpq3POc0JoG9ePfsNlUaz+qX2g2xZhdFuqf3yLUbwSLbfUnYNMVxP53nzCHkte/FHIvH6NyVrADa+taNcxXS+89SYo/TSV0ZlFfxHBtLuFSG4PL5oyWyO7+NtxzNufkUB+OrerWqYiYmVi0P0H6oeGvRBtDWcg5a1fWL35DNs55DAZgphnR89/vUFnujcQW7Cazwxc49NZnxemAwBfMw26Slidch3ip3N1nM6mM7LFbkSrO/zwp1P21EBPcH+fW77w7lp7YNpt/eHYCqNYj80ZzVQsZWRNpjwfrSOH/to5M8MMC9f9x8QnyXBdGDxVeKmD4aW6QaY2v8AZ3ewp0cKixEV0i5+M6XyOdGqxlK7RwdkhwFM2Ndfipdb5eN2xRAWSzP0oqwFLF03mTGku8Chtcqrwa7/0Azxg1Ghmpll462It1ZX7DR+G9WVVAPCzIdVjp4v11sp3WbUuGQnrM0hFNoGlpYVTG+GWXnCic2vmPRoPWeC0qaAcZDJqoy+OSmsCSliO4wCudiqTo6X4uK1FLNeCS7RE29GfIjN02oJfSO22sWpaOYM380MB2g4JfE3rmc56Vf1MDxxAhhGpLGIO5yZI1N+azXAzxQsfzywq
 tckqK5Z0
 fLoAXXMpXGo3jMlDv9n68Jw3wrCc1Ywd68iaGosAhcIZYX1Pyo6Ig0Y3jGZdDawSsPODPEVkE2EgoPfzweNa7GUDnJ4pbt51PwU+yoYKwbyX43b66F1YtrY3ARjSv7OgLjqihZ1JY6f6h6Dz0eMzp+lN7j9bp72H3IwNi6dBp7vOOJwn+hPche+zSChZHsdNoh2HJuKjve25MOhpqO7PGHwtP2wiozqw3VqQ9QbU0339iBaxb1L4ihvsAicTzfOYFb4QkgyLyzRvXEZjawRtkHO3QiRMnFBV3+w9GjDmTyCTcxKYXayLltN7GjdXGZAikx8DrlzbZNRlGXlKXJCdDlojbwxzNseUDWyKWUpq6UrsVGCwOzH+LOi6ygzAbbpvXKgdmZnpOnsal+uVU2YLgyZK3YN7pdjSQIJhYGqIDDnfkUi0XnEw0zS1PZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 22, 2026, at 06:35, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> On Mon, 21 Sep 2026 17:12:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> Hi Hongfu,
> 
> Thanks for this fix. From the cover letter I was frowning because I was
> thinking to myself "surely there's no way hugetlb accounting is this
> broken..." but it seems like indeed it is. 
> 
>> From: Hongfu Li <lihongfu@kylinos.cn>
>> 
>> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
>> when a huge page is handed to a user via hugetlb_alloc_folio() and
>> decremented when it is returned to the pool via free_huge_folio().
>> 
>> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
>> hugetlb_alloc_folio(), so it is never accounted, while its free always
>> is.
> 
> That's pretty scary! Glad that you caught it here.
> 
>> For a migration target this means the target node gets no matching
>> increment for the decrement on the old node, so the global nr_hugetlb in
>> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
>> affects the failed migration path, which frees the target again right
>> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
>> same helper.
>> 
>> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
>> folios, has the same asymmetry: the folio is handed to a user without
>> being accounted, while its free is accounted through free_huge_folio().
>> 
>> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
>> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
>> decrement in free_huge_folio(): a successful migration hands the folio
>> to a user, a failed one frees it again.
> 
> The changes look good to me, and I was able to reproduce the issue on
> my host and confirm that after this change, the missing charge is
> fully accounted for.
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Again, I'm super surprised that a problem this big has gone unnoticed
> for so long. Thanks again for working on this fix!

I think a migration for HugeTLB is very rare. That's probably why it
took us so long to find this issue.

Thanks.

> 
> I hope you have a great day : -)
> Joshua
> 
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---



