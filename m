Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16677C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AEF6B009E; Tue, 22 Sep 2026 06:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144776B009F; Tue, 22 Sep 2026 06:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058CD6B00A9; Tue, 22 Sep 2026 06:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE6CE6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:22:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7291BC0427
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:22:36 +0000 (UTC)
X-FDA: 85241009112.21.F06BABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF353180007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:22:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ihY+h/wb";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790072554;
	b=jbJ/8SO6AlgZB+yxXt2xZ7dPbNdxcQVsfQjJ1wLSiUIYtC8xXx62hglGUZWBQ66VmDKl++
	EPwTmfqfAHKVSyz2x55ft2qj3LuZRckP1C32IQQALgAhh3zBnSOivXxA5cAlq+iyqS6crV
	Qv8S/Ev+OBjwi4g3N0Ml1EInKgiIVk4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ihY+h/wb";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790072554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DN0EkF+UVww2zD+JWORW1dS7pehZEzk3ZOGPbCH+2mU=;
	b=VQ0qjvOlLbWBPjv76WYNRMB6H6P5SNrOK0vpLfj4WmeGWEN9YxkYM8JheSuK+peMf6QVUY
	QV+1O3Lq+sMws7QeWRdtvYXdls6kf92q6NlmY/pNG4PqnDiEXNbwLQh6YXDnmfzvKr1IX8
	3AXswfGSW1kz4xAHvU7hYTHEgWirZEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B7260200;
	Tue, 22 Sep 2026 10:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8A61F000FF;
	Tue, 22 Sep 2026 10:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790072553;
	bh=DN0EkF+UVww2zD+JWORW1dS7pehZEzk3ZOGPbCH+2mU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ihY+h/wbIr9rgYOMg9hmVVaut1LOYTuIrifpMlalFf74N6LgXDLXSnn910Zz74fR2
	 LvFYMvp/3j7aVJDQtj/SqNTrpyudQKmeZPHt1ubnVVg+8srIjVkJCENRqEN74MChDf
	 +Ec08GzZgLLY3pq+E3KpbetqEL5kRgkx8VZv+BkAvKLkazMolEzzw3ENwaGK0ZN/tz
	 AQi6pagd6hE+NAy+Eanob4UxWff+yVMYCEpMDHw/ynqWj3Nx7gK6fUJt4gsMZfAspn
	 pRGXUZD2aVt+239kbQMIxpM5SZujE0wc8bFmvhyuw8Cy9lfK9tsbvO5ky7faQZPaM2
	 wFGJ8zpD9PinA==
Message-ID: <53761d0c-e4c2-41c8-89e6-3c9916934c69@kernel.org>
Date: Tue, 22 Sep 2026 12:22:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] mm/sparse: move __highest_used_section_nr
 handling
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
 <20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org>
 <arIC7BheTHzBnLoq@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arIC7BheTHzBnLoq@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF353180007
X-Stat-Signature: ggxgu6rybudyxmk87d357nrdqfu95h3j
X-HE-Tag: 1790072554-762223
X-HE-Meta: U2FsdGVkX19a/epvR20oyC7RIhbfB0ea36g3OATaQoQfOypadIlvevClo9TDL42FIVJDhF8IwuVQVf/F/p7XbvcwHdVUDrGGagMahqrT83qxe7kK7uG8YEKpkaGKQMAc6EQMwsB/YfMrhAl3Jje5yz/Pz8rA4jdjolD2hJJf9A/sfoT+6y8CYT1MGD9XpESfS6QfhSQTJYJqq5tPeWpE6ofLH0BWvkDQWWxYeDFA3gENDZFibL3uOQ5xg16z21hkwC7HW7zO+EFJHEvjqD+DnRaNsXwG/y/AvCt/JUFwwEzPweMUo2IyWVYBATJL1JM89sI7rHXwKTMm6eKFMDAAzVaZVEQGiupwzXyLaRmJOemUHVMGrA8uovYa6tL7LOZGXI3dhAT11B0mpd+ZTV8wFq16moXFh+oxDbvIxg2sXRPtLQRNCPNTnd5wj31lvRdeJsX1eEqfBs9io2wo8Jvla6H0541zBAUarQkxkPkaoZSkN8DJXUiuWGBZebj/hp6cgbBdhKsT8/Mw1BSGgoB/mAjOqCZ8wMMewD87KdVy/yyGg3tN8gO94XG+JonJjF9wu9wtLSAgw2tnJl4MUFk8YqhFMjWEj61suycLGKyz7JsCmiYKfipchMikineOa+DPExxG2kgc7Fa/Qu1iZe9s7BqFEqoG7hvXdN1XCXevRezrOCtJGvzx0nlr7AMuMouqCR4etqkVSYKFcGcuhbK5bBSFq7BmCN6xN3lt/tO5XvPimmcMuNkCLHYKS8gC2jUH/6wP0TECd0OK9Yc0oyioG5uOj1GXVgJGEer/WzdmFI/FllydDU1C4KGmSx41Ce5wtgGBybUParZuW5AHXpaBHhmhjsu9ummhk+dI0yRGSnYsPkxs4QKkSyc5wSdN0emsJ54x05yH8Bcb41GnmOBQXhRrgKPBk3t23shwSUgQ7D644AgfcfwCAhq8gv4vlFbm2eOXWi5UfNfo5bc8cfx
 O7UyZIxo
 a1jM7uZ8Iyu2WtVlOi29gGODjQG9XB/0v5Y3afym5P4PPDKsazwzq64MYrASHq3n4jTkMpmyhwLsLO4AYmAvrElA5Rb+ZSCNEff0YZHPeW8eX/OoY7hNHTbWlofoSMf4Q9kqUami89IcYhgFB2HrZ8d+mM+OT8ko2EPvWo5VHxAy93TwEi09TSgyooCnWLO/y/2SCbLXSVuRmR90qe+YwTxm4wxGVW0WM24SEL8TlOdFLDKssJ8MnCs5lhSyB/WCVIK19xM7xdspOqddzvNa+l2mYOzAs7GLcE/qTaXfPPNvjEunaXT/VOwqNR2YBDGzRIYGhBLOUgrhN7yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 06:24, Oscar Salvador (SUSE) wrote:
> On Mon, Sep 21, 2026 at 09:59:00PM +0200, David Hildenbrand (Arm) wrote:
>> In preparation for removing __section_mark_present(), let's move
>> __highest_used_section_nr handling into its callers. Verify in
>> sparse_init_one_section() that it was properly updated.
>>
>> In sparse_sections_init() we can just set it to the last processed
>> section_nr.
>>
>> No functional change intended.
>>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Oscar Salvador <osalvador@suse.de>
> 
>> ---
> ...
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -26,6 +26,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>>  	unsigned long coded_mem_map;
>>  
>>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>> +	VM_WARN_ON_ONCE(section_nr > __highest_used_section_nr);
> 
> I wonder, have we seen this in the wild?

No, it would be highly unexpected (thus VM_WARN_ON_ONCE).

Thanks!

-- 
Cheers,

David

