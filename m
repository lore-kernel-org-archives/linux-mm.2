Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE34C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237936B00EF; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208066B00F1; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D136B00F2; Wed, 29 Jul 2026 10:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C71F66B00EF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FA7D160695
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:51:34 +0000 (UTC)
X-FDA: 85041649308.18.ADD0100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 552D2C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:51:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/rdTFQ5";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhKC2rWDc0nqivSNnMMapSrop+/S8ksf4kWUVmW36RU=;
	b=fesqc70eG7CyuWfBETgeLEwyTarxbjqif1iQIZlaoihB1p0Y81tzkkG+QuagIjgLx6ocjb
	/FBz6A0uAsHvCY9RMZmkx+aKbtPuPz5ifCNmBwGK2eiRMKtEaSc7ITXYVyQSRIEH6P4XqX
	Yqc2cVQp+iIgLq3L7d42/a4j08oeCxo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785325892;
	b=M3pXgl01+P/VCZPUZ4ZO8hwPvAyd5gqrQf1KnCbN3NgzYV35gB6oRMi+w5H1U19J1LbDoS
	DNww/pg4bDdZHbtKFqCabbeagDp5ejiKx95DpoWl1IuJjGjdzKdWgivTJhzsdAjQqjH0nB
	QwcujQMvU/4EhnmMDKxbIN4kWKWBhPg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/rdTFQ5";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 514454367E;
	Wed, 29 Jul 2026 11:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231861F000E9;
	Wed, 29 Jul 2026 11:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785325890;
	bh=UhKC2rWDc0nqivSNnMMapSrop+/S8ksf4kWUVmW36RU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j/rdTFQ5D+V9nF350bJFVbABN4LrkdsttdXl0LTG5diGS3qfpE1d+CHl9CbSex6ib
	 zqh8hsz9l3VaQPnS5omwpQ4W93RN11H6fIAUPogAreBHTqCDzslNEnArGZn7XQd2Nh
	 L60L5+Er4w8vr9eNKEbKvwf0I2mjYLbJRtU3mP4hA552hqDOeaUCdQ3coC6W+Yrxob
	 0GfjMAvTYGFs0eYP7gECmOhuDEd4qb4E6ZRFuvxkWAYMyVwJ44RcFC5R45zVPN0jpd
	 8duzo9AGfdWaObfcg4y6i3UpveG99T2I3kDQU7SMr0C91jCQDkN2f+1bryJUJIPF5z
	 SyB3dhLtFqa2g==
Message-ID: <26b1cb23-bb68-45c4-a28f-698b34fa3aed@kernel.org>
Date: Wed, 29 Jul 2026 13:51:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
 <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
 <6db0a8c0-b500-4364-be3d-d3a537c61258@kernel.org>
 <e3b6dd13-2cea-4dc5-9038-a3abde71ec10-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e3b6dd13-2cea-4dc5-9038-a3abde71ec10-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 552D2C000B
X-Stat-Signature: rkn587uenw1ciw4pmnpow9z7efxmidbj
X-Rspam-User: 
X-HE-Tag: 1785325892-305367
X-HE-Meta: U2FsdGVkX1+EUM4qSoZ/44mTgRl5qwtn7Qcr7ShF3+wOeIIDpQ8m1NhbKeuNYohYecJv5TZcTLXjOLgVOd1/DrnN/xAQjbNRVtSuEEi7siCeeq75FqV4Q54MupQMxygGdMZ/1F/aOvBXouDnYxa4DYd3RZ4JUY1hsGp7K2bX52hSw3rsc3FMf33ND0iRld/YuKwwO644RGyj4jwwBVuvwOE305K9az95ySZjXA20hzuDHkX0THuPGvU21oh2mzDHYLdDzaYhZdlFdPMx+cL6JxjD1rqszocTCZYjzjD5z/sQ2XnZ8mswZPUnFPo6BwPVUzxQXL/n3Zkh6QUSDg5xvr9uj7gkMGZ182EhyoWmgdhenSJ6mjeE6ETJTvqeQupAPaswI5XaZTfyzpoEFjz1mOBzTo556Xyl4DrlQUfyTN7/W398OtPDd8aTHa7cgSSLTLp14wWrrLWDThhrCvtbJYtKdZ92+fNjyq9JA1+lT/ixP3n8L9oGJqNlFpuRnvY6+9aQ5RsfZvv0TTXQ6Ex69K+2bVgNccJRYp0WKdMeLQAkifZeMD31u0ORYQnqvkBnbiAxhGd1siTfxzGAfof1xAiqT32vgYZAqGU70+bnmpnqn8sbp4FTR8S77Qd01BOJFXFrSVr90FxohYlssOSN1JEIuVPDA1k92j4S7kIy09ZJnaCtoVMDIbdyJI+GW76hwnRpCTt8MSk0JUVPPpwvOhF0Cwj39h1ZcwRRGB8Dcpxw03ugHpnHroBQ2T81838UXa3dsBgqy0iI5vLBjPGmRGEKObbwO38vZ8MzHfKZUo/iBjH9zZK7BFLy9yCI7J9JMUlF/bJY7ZTkzwVzlV30xxW4rkpF96InLVQor0fXh/7cr04hVzwzhSbLnjE2GBC/Q8uZzPCuXAg0l2RwjIP2oi0dkzioYJceOn8Dv+CSOHX8wKPYxvPBE3XVk4Wmtz3qxUD+OICQNsGs7dUdvil
 wBMcN16H
 4AlCJecsjx+eQVvUB/MX/gecygTFX5xwO4cKga/UOxtWsfMQAWcXjJkSEg3B1oqNGbqrLNylXuftMXEtMlLDus1CdwZH/Ogi43IjNj2wSMfikJUrtU4Kerl24oeYDorBFEosv/D5opB7019c8XPkw6Fr0N7I6ewxPWcHIJbezX6qEyl+SUOa9TmcQtukVCK0KBjaAKKbnjJQjU/dSj/rVI8uM9wI6FICfjjevM42g2ZjFLBd8YEGRanRe9Mxo7wyJlUjqGWE1gWxz1hCxuAwz8T5qko6oxU1U59uSaRRJTl6A74uKvSPien0Caq1tCDZpdHfo01wmjokuyQhELy2CfB5573KR5gRH+lVq6ox40aIlSt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 13:44, Alexander Gordeev wrote:
> On Wed, Jul 29, 2026 at 01:05:35PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/29/26 12:13, Alexander Gordeev wrote:
>>> ...
>>>
>>> May be we need the generic hw_pte_t implementation as { pte_t pte; }
>>> right away?
>>
>> Indeed, that makes sense. We just need a way for the architecture to opt-in that
>> it did the conversion.
>>
>>>
>>> Also, can you envision a case when sizeof(pte_t) != sizeof(hw_pte_t)?
>>> If not, the compile-time check is worth adding.
>>
>> That wouldn't work as is. We'd have to intercept ptep++ and instead have a
>> helper to advance the ptep pointer.
> 
> I think I am missing the point. That is my takeaway from your previous mail:
> https://lore.kernel.org/lkml/31d36023-d728-4eee-90f8-158c7066f565@kernel.org/
> 
> <quote>
>>    {
>>       page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>>       for (;;) {
>>               set_pte(ptep, pte);
>>               if (--nr == 0)
>>                       break;
>>   -           ptep++;
>>   +           ptep = hw_pte_next(ptep);
> 
> We should really just let ptep++ work as before.
> 
>>               pte = pte_next_pfn(pte);
>>       }
>>    }
> </quote>
> 
> So are we going after hw_pte_next(ptep) or ptep++?

As I said "That wouldn't work as is. We'd have ".

So in this series here we are clearly going for ptep++ and sizeof(pte_t) ==
sizeof(hw_pte_t).

Because otherwise it wouldn't work.

> 
>> One idea for that would be to let the compiler catch that by marking hw_pte_t an
>> undefined struct (unknown size), such that the compiler would indicate any usage
>> of ptep++ properly.
> 
> What is the purpose of that? I mean when pte_t vs hw_pte_t uses are sorted
> out what is the benefit of preventing hw_ptep++?

One thing I could pull out of my magic hat is that you might be able to decide
at runtime the size of your underlying page table entries.

E.g., have 128bit pteval, but allow running on HW with either 64bit ptes or
128bit ptes.

I'm sure there are more challenges to that, but that's an easy thing to imagine.

But again, the focus of this patch set here is ptep++ to just keep working.

-- 
Cheers,

David

