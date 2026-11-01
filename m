Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEEFA606A331
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=klz8DA2W
Received: by kanga.kvack.org (Postfix)
	id EA2A16B00EF; Sun,  1 Nov 2026 13:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E541E6B05B1; Sun,  1 Nov 2026 13:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42336B05B3; Sun,  1 Nov 2026 13:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC1AB6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:19:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FC8A40AAB
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:19:01 +0000 (UTC)
X-FDA: 85387361682.15.98B475B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E1968000A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:18:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klz8DA2W;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793557139;
	b=ylD9HXRaF+B3oUT9fg8yELYv+o8U+qLksh59esFmQiz9fHco3ZgsX+Lmk2/JsXg9Fnmb4J
	pxax6O4UuS5viWWcI6ecY13HhlrHq3nUHaFd4us9bvZfYG7I3RAEkXd8QIPduzEuRiHZgv
	05z01Ju8eFD3yv6qqWxe6LIjKt8CK5Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klz8DA2W;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793557139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ufkw0mhxgeNgH2/pQ2q7PPe3Br8wC4VML0hZBdX1Pi8=;
	b=ClARTxPNoqr4QVQJTZpfJyDm8jw/n+Mo5T2qF9lDQ0NNIppRGgj6bonXrNkWKreSWaOFDj
	OaffZGz5Fp5wm8BrqlAUVk6ijJ80U53YLWAUG/nWB1CMgNx0zkSi8vqB5q8ohzdYSkOxKo
	BOMrcEhu/6h7thyYSG+BWE7rrBLXxZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F09FD60054;
	Sun,  1 Nov 2026 18:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECA31F000C1;
	Sun,  1 Nov 2026 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793557138;
	bh=Ufkw0mhxgeNgH2/pQ2q7PPe3Br8wC4VML0hZBdX1Pi8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=klz8DA2Wy4v8itPMM2Sk9hjHDXFe4ZdxZ7Wm3kSIbNIjgq2j0zYuwD3dHhzLIsL0e
	 4zKr0h4je0AERM9ZjdXzQgALGxnA98fIsYFgDKnS+aeSps60tnSRzpaw2RJNLqRveY
	 5tSqwghmdVskVhQLiTUVhkKxF+1lg2G48aFjA+jvhYGJnlq4x/ruqGjVl8SSILlFJ7
	 t4XRAy1rUINCeozRiHO9sXtJmZuofyoT4naAPHaZaTGPifbJmkANfnGNglb+yUCEGZ
	 AeS0wXa8ZCWPh18XTbEWZyvoDH8pgu5Y2P7HBtGjqfkG+FTJhEtIpKe5JAFxSMAIkI
	 bF9wyBE8cQqEA==
Message-ID: <da1dc033-9131-4b77-9443-a8cc82fd7e58@kernel.org>
Date: Sun, 1 Nov 2026 19:18:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: check THP exclusivity for each subpage
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Kelvin Zhang <zhangxp1998@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Kalesh Singh <kaleshsingh@google.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
 <54617273-262f-4e17-b912-8b07113ca45c@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <54617273-262f-4e17-b912-8b07113ca45c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E1968000A
X-Stat-Signature: wsmpittykesq4i58k46uxzwf8chjyod8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793557139-831814
X-HE-Meta: U2FsdGVkX1/LXvw5i6ZrbW3KnFq/mkSIcUT4D6mKiKdwjoyGb4yYRJQ33ASwrkhfFGZttPb1qVwaqZTESg2QJV7mpeaZCHUxrVLqIYSMfsb3jWNJo9uspldnxJMqRlKg+y068wcexliSQtXyYcFkb4hUKjYKj1LbsCODRknfdkrXQio++SkCWaL0xTnTLAnV1N2H/vJ0MjCSY9q5l/vu6L9eUHS+Y4/14vjt+4IFDmWzKL4xkuEXqjJL0eE/brB8obVY7bTGh2Lqs5bQAfrhY1r9la+erdOOaExwyE0vkiaIOKFTUqiPuWiIxjPHHnDUDBw/SNwGqQDSrhVLHVisUjPN333X45o56gq/bhYaaBGT1khtamPFlT31omvK9tzWSaNxC76jjhQnipD5AQL725Ohkgp+the7rtcrjBqrfqpbvfgc/oirT42KQXjraXemSqKuXIl2AtGAPgDfmV8Btl6nKSNM6GorDCL595ga9Oglb7HTg6Tzx39dT+XBsV8hAtQP/sS6jzCJmGkiG4ijQYxzw4UgMN0Ft4G5tdnFK5xDMMUG8V+nLKAg8PM01i5DKJsFB5Z4/LWpyRpnIQoFfCJXNjh5IrLGNXcHiIsSF6eJuYtmXpq2/3pONffzvYb1N0ifIX8q9WWqozkmz0pIAfYz1hL3Vfyq6qLR6zT14LVx/FA636GdJrfJn8/1X6I2+dDriWuakmXMrhXMXgxCX3RP0GTMn4uQ7uL6j4ZE6+OEhroxllJ2BsA7JljSLg2MIRdXHTeN9T1/TWWIbQCz7CR0v0vJYLbGnxdVgSxVM9M9x8HwYJNgNt9mWtEqXW3W5Eq9gZv5quc/WZL45o7EvaIfXemcVdthNsZqHt9JYKFpKklYXu4oC57ur33uL7/tdUUms317tdoMPqZF9UBE0RfgdItm8PvznPhX5KNgarGMSAri7aTXtaujtuUYABtPYk9v1UCISNppybMsyqq
 4Y6sy9DX
 eRo0FuDsXJkFEQS6H+I1Wlfuhb9L4PoQ62b5MbarapE1q8yDrF9zyTQ1bQDsTlMPI7Pwx+nXuGtCxa1XA55bM47MiUK6lwMB0qwY+maVMegacvvp4NKPgrbwcgQFXCmxZZMxPsmza7PQEtW8yYuZldldwN3iR1QjMF2xIEkyckks7scRiRJbHrNWX1ldIgz5cFLlUiBUxeRhVc89v4D4UwVHs2Iv+j4sMUs+S4h/3CtncIbsjWCYKp/39sB8wrH+ZVduwCD+E0K20LJOkUnoJy9Y8dEtqqVe0Hiq6vWCPmuL6OHJpbeeQhCIHR0TivtBIgnzV6J+ym/+Rvpt1QhJCW+BxUCSSEIvgF83n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 19:07, David Hildenbrand (Arm) wrote:
> On 11/1/26 18:01, Kelvin Zhang wrote:
>> A PMD-mapped THP can contain subpages with different mapcounts. For
>> example, after fork(), the child can unmap only part of the THP. The
>> parent retains its PMD mapping, while the remaining child mappings
>> are PTE mappings.
>>
>> pagemap_pmd_range_thp() passes the same initial page to
>> __folio_page_mapped_exclusively() for every pagemap entry. With
>> CONFIG_PAGE_MAPCOUNT=y, this applies the first subpage's exclusivity
>> to all entries, falsely setting or clearing PM_MMAP_EXCLUSIVE for
>> subpages with different sharing.
>>
>> Pass page + idx to check the subpage corresponding to each entry, as
>> was done before converting to __folio_page_mapped_exclusively(). The
>> index already accounts for reads starting partway through the PMD.
>> The conservative whole-folio check without CONFIG_PAGE_MAPCOUNT is
>> unchanged.
>>
>> Fixes: eb16876971ea ("fs/proc/task_mmu: remove per-page mapcount dependency for PM_MMAP_EXCLUSIVE (CONFIG_NO_PAGE_MAPCOUNT)")
>> Cc: stable@vger.kernel.org # 6.15+
>> Signed-off-by: Kelvin Zhang <zhangxp1998@gmail.com>
>> ---
>> Tested on x86-64 under QEMU/KVM with CONFIG_TRANSPARENT_HUGEPAGE=y
>> and CONFIG_PAGE_MAPCOUNT=y, using the same test binary before and after
>> this change. After fork(), the child unmaps the first, second, middle,
>> or last 4 KiB subpage, while the parent retains a PMD mapping. Both
>> bulk pagemap reads and reads starting inside the PMD are checked.
>>
>> Across three repetitions (12 cases), the unmodified kernel fails 24 of
>> 84 assertions; with this change all 84 pass. Fully private and fully
>> shared PMD controls pass before and after the fix.
>>
> 
> How was this found. Through an LLM or because there was actually a problem in
> practice?
> 
> Why do you care about this information to be reliable.
> 
> If the answer is "I don't care, I don't care, an LLM reported so I blindly
> submit a fix" we might just perform the switch to the CONFIG_NO_PAGE_MAPCOUNT
> variant directly.
> 
> 
> https://lore.kernel.org/linux-mm/20260412-mapcount-v1-4-05e8dfab52e0@kernel.org/
Sent my mail a bit to soon: the reason is that this might be one of the
best-case scenarios: we broke something by accident, nobody cared for various
releases; so now we can just change it.

Thanks for the report!

-- 
Cheers,

David


