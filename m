Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC85C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EAC6B0095; Thu, 10 Sep 2026 10:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E63F6B0098; Thu, 10 Sep 2026 10:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCF06B0099; Thu, 10 Sep 2026 10:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 219C06B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:31:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F9B1120548
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:30:57 +0000 (UTC)
X-FDA: 85198089354.16.E008B9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4904540016
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:30:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+NhKwxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+NhKwxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050655;
	b=SAGPMoGDSUdYee07/mlWHQ61ikRfmCw0G1Bh1Cw7JSG2fSOV8T12NPBTdoSYnlsiL/rpIS
	FvV6mpPv8RK9iQHXIfdwDr7JRyLekH1YXCogK3dYAdz5rl15j7z9sOf849bILEsADN2jD9
	NAzwd+TAMa5l94hSTc6sKbZ4VpQwlDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYIjJzkgNcf/L8IdAlVc5CxNGSBjCKsHUzlpJK8zVLA=;
	b=OQ89sCSed/9L/vwBsf1vL+iL5FyQ7VimVhEC2324GECJ30NN/G0Aoqrc4vmRjsueKrFCsK
	mA05fuy18nUjw8QonZ4/7jRr90O+bjHnPkRf7enZMgr69AZDG5jlnElP86pjT5gCBF3b5Q
	bs0lxAo1m9+ukW7XDDEmaN0HnmXWLNU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BEC1418F6;
	Thu, 10 Sep 2026 14:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14821F000FF;
	Thu, 10 Sep 2026 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050654;
	bh=QYIjJzkgNcf/L8IdAlVc5CxNGSBjCKsHUzlpJK8zVLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C+NhKwxftOndxbZynkT9flhdKmqwHy/1toG1XLj2OU1G58MCD12nAwLOIhGGZffUa
	 AkRl65KSKyX9avFrOtHTOShpKJiVFO9OWw540xAJW2ldjVX8bahRSaXcbakvPiVE6X
	 xQWEzmmDV5MP+RSKvhFEVX9A7FZ1YcY5WhB2lJtnnzuBMg2yd2/1mhk38AseGdM4h1
	 BEJEdyGAeJlI/33+zLCOswq8O/T611SDkNYOyWXz0THnaju4i0LucLbGX650EmuqTs
	 TGVNI7c+s3GZAxvObikqWisVQNc/Wtqeh8KoI54CTVf9iO1E55s1tLKKFsBF7Dfnhn
	 u2oqY5ERBi/0w==
Message-ID: <44f7ce5c-b75c-4c44-9202-1d2d3a1de965@kernel.org>
Date: Thu, 10 Sep 2026 16:30:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
 <aqKo5vHZbDhzrUZL@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKo5vHZbDhzrUZL@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4904540016
X-Stat-Signature: awcn9jtdfmfdackrpjcaazu9utkm4yd6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789050655-392126
X-HE-Meta: U2FsdGVkX19dD/r2t80Kby4wU3Dzp1dsE7RrkxuZhN16AitN6OyPYLELm239DGIAhSwdFd/rrkQ1nhNQ3W8EpecsR6zVeEDUNrH2E47WbK/gujE18W5gnXJM9LPp/lvUSoasVLpcdBdzZnglWulMnJrqJ/blu2iaT6xMAjoSn6rvWX2I7cEHceSQas7RO3dqMYXxLFCEl9yukyIlt48fjm70EV62g9ElyxMPX2FeRdh47CqNvf6Ku3E3jmKG/YZ7TWP9ukVqSYkktsjL+okK3hki1yT2rDi9FZFGFrJXCxMeW1EWfF2a3Qn0FUWUm+cGzjnXWhUfwiqq1twjUlWco0rKKChpdbJQxwDAmkBCNvRbaCdtvntmD7834wmGUJ4FnMXysn1JYU3ZkLLm3DM/NDtkCtfltPFuD9nUqUf0OXCdo2TSWgLkmmnD57hqOcCdbH2PKpcqOqPvrFMJgyOEOCsywFZipHAqe8DnZX/JkLdNKB5k+ek3w6A/PTulJLmN4lPhuiCg//To0FtXFvZbo7RB9ZLTCR8Xb+rKvAA1vNoyfjX3AkTCzCTps4+pd97KH2dK3P972uFWIxVSEX9qlG1dyOdkt5R8NHBbM/KtI2Hd58eCkCEF2/peOVoU94+NwnGtRgaxeuqet6iENEdxLv6Qd/+RVDErAMMK+Btdl6Bdx30Fm698ikrNJZBgDdKyBl2tSEuASnDJo7owE3i0LG4XiSmMt1HpAWf6WHVM9N2Li4ml1iCyOp0raPMRnkD+XAuMs3q+wK7tmlaMwy902Afq53gYydXX1xTlG1PaD1p0XI5FGev5zIiTt1U6vMlxzYNYE9hZVOHqQYJ2HPjgpGzFv3xnmWtpcL7VBj5pKm5w/UyQwW1MdmhEC6/epv9Zsi2KkwwYBYAjlUt4oqou9V2daC5ZlI3BCPndpwadCfHpa7wGVAbMH9QqFVmkD1LlIrP5ahn5a218UtzHi6P
 4lYwuuL9
 5qxurMi4UqbkTCtB8p3FnsZlNGvWPgPSh4NjgMogFKNSUh3xb9qknRvmcHPa9MLo6/w1eoEaPbY8pOilSwrlSX22aoMmwGDFyfieHSUXxEZLIs/5Y30ff0e//1EE20ZjMGplYRDm4IQP8toHyW5vUhotjAATNKuEVokdmltruaSYj1Hcv3fhY5bTbq8blzd+K3j2iy5SQC+lB3YD0k+HJnTtt1MeLOWEkxRslnihra9iAxiU3EeYpDT0uWLmeaTlJsTpTeaqVjc0npjyGl2notVGbWoex8Eis63NtHk4VqGS/A+2KfOFlvAblHYwdstiB4ibfK2uwOnWPFN7bkVyx7Ar3ck9CZYWswVtvMdO7dZooTF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:29, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:32:55PM +0200, David Hildenbrand (Arm) wrote:
>> memory_present() really identifies+prepares all early sections so the
>> initialization in sparse_init() can properly iterating them to
>> initialize metadata.
>>
>> Let's just inline memory_present() into sparse_sections_init() and
>> cleaning up the code a bit while at it: make it clear that we are operating
>> on pfns.
>>
>> Note that we call set_section_nid() now only if the section
>> was not already created earlier. Now, there is no more inconsistency
>> between what we (temporarily) store in ms->section_mem_map and what
>> we store in our section->nid array.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> In general please keep move/refactor steps separate. It makes it harder to
> review when two things are going on at one time.
> 
> But I guess in this case the diff wouldn't be that different.

Yeah, I actually want back and forth here and decided to keep it simple.

> 
> Anyway seems reasonable so:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

> 
>> ---
>>  mm/sparse.c | 41 +++++++++++++++++------------------------
>>  1 file changed, 17 insertions(+), 24 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 6a6d258862904..36e3d854febc5 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -179,22 +179,27 @@ static inline unsigned long first_present_section_nr(void)
>>  	return next_present_section_nr(-1);
>>  }
>>
>> -/* Record a memory area against a node. */
>> -static void __init memory_present(int nid, unsigned long start, unsigned long end)
>> +void __init sparse_sections_init(void)
>>  {
>> -	unsigned long pfn;
>> +	unsigned long pfn, start_pfn, end_pfn;
>> +	int i, nid;
>> +
>> +	sparse_extreme_init();
>>
>> -	start &= PAGE_SECTION_MASK;
>> -	mminit_validate_memmodel_limits(&start, &end);
>> -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
>> -		unsigned long section_nr = pfn_to_section_nr(pfn);
>> -		struct mem_section *ms;
>> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>> +		start_pfn &= PAGE_SECTION_MASK;
>> +		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>>
>> -		sparse_index_init(section_nr, nid);
>> -		set_section_nid(section_nr, nid);
>> +		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>> +			unsigned long section_nr = pfn_to_section_nr(pfn);
>> +			struct mem_section *ms;
>>
>> -		ms = __nr_to_section(section_nr);
>> -		if (!ms->section_mem_map) {
>> +			sparse_index_init(section_nr, nid);
>> +			ms = __nr_to_section(section_nr);
>> +			if (ms->section_mem_map)
>> +				continue;
>> +
>> +			set_section_nid(section_nr, nid);
> 
> So the main change seems to be calling set_section_nid() only if
> !ms->section_mem_map (and obv. calculating ms earlier), as described in the
> commit msg.

Yes! I also played with having that in a standalone patch but judged that it's
not really worth it. I can move it to a separate patch if you think it would be
better!

-- 
Cheers,

David

