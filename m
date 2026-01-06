Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD10CEFCF5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F506B008A; Tue,  6 Jan 2026 14:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDB76B0092; Tue,  6 Jan 2026 14:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEAE6B0093; Tue,  6 Jan 2026 14:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E326B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:20:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E491113BF0D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:20:58 +0000 (UTC)
X-FDA: 84302506596.19.AD860B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E3961C0007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:20:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IADNriuX;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767727257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Uc0F3DUwIqqUR/64oFUqD1CdYQ/LZ++reJ8LrVQ7NU=;
	b=05QFvIgYCYXrTUj15aiFJ2jSgreE7QoBK4Yqe5T/aEMzEqQD6NB6Os/a1n9P2TfCSB4rKw
	zvqeoi2N/xUi44yYSccebJmpGGQh4S+qArjkfHN9wHbI5DJs5prkgM9n5AinpVLmx/byo6
	nYsR9aoGcLLySm8qR+kwhn6OFe5ARBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767727257; a=rsa-sha256;
	cv=none;
	b=jPlMzu9251fZ3B1LipUNdvRqgQq8e97unCRXdBl5sv7fkVZAFAipLyDdKIz9I/jy5w3wjd
	eJpmfH01J+YqW0ysHc/kONyUvjl4pThay0ERLeFke+DdXVRKMfWb/fVfWSxNG98CVTA2c6
	8N+tu2qPYKoj4niVs7mDHF5oEUZJKXg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IADNriuX;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB1B560007;
	Tue,  6 Jan 2026 19:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD41C116C6;
	Tue,  6 Jan 2026 19:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767727256;
	bh=eo/x9ROfg5WKQWxp7LBJD1JrVmKZnu+ytyd9m+qhnzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IADNriuXuMloqcnP3VojVv6eQPZ5CHvGqQzSUV+rWO64RTnJGVw2B7FdiFpkgwwRn
	 vGIFwEFMXWPfG4EwUm3YSQ1F9EwCGpvmzfqvLcCBlc8IUflqm4/Asqy8AKrOT9njPg
	 kDSBOec2TPZ6CH4av7XEgso2iYXcPZekt9xWsYvAN3smKhB7qlvNCsSO8bcZ4PzJ5i
	 P4eJ9qxqwLVCpiEd65ASVxjg36sb84JgGb2qVsdc4ItNRPf5wlugCPO1Pokkw5Lg1u
	 l36EP5PCLRiC83Jn7PMmBhpahXspun1ZrPqjN7WAQYq4aF7wFLZiKFTGRW5wfJgvko
	 xsnZqjxD0YoGg==
Message-ID: <9e8b01f9-d1b0-44a7-86c9-97622b2baec1@kernel.org>
Date: Tue, 6 Jan 2026 20:20:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 richard.weiyang@gmail.com
References: <20251221124656.2362540-1-gourry@gourry.net>
 <9c807ff8-b4ad-43d5-8034-ec7fcd0fe5d6@kernel.org>
 <36001B4C-A781-4571-AE65-4C00C9D215FC@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <36001B4C-A781-4571-AE65-4C00C9D215FC@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gjatwx4jmwn9irabb7kjpa8igrwk9n3q
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E3961C0007
X-Rspam-User: 
X-HE-Tag: 1767727257-560288
X-HE-Meta: U2FsdGVkX19/rhSwfLww377m2ytYTy9Oo3b9JzLTO1KMG6+7yqAfPcBWdJ7unSbZnt4vV62BcVBehGELsJaFmXITVW0PuhUnCRgOeo5g18oTlR+OUBUEE64b4ft5hJ1zWg80q9M8i8jLw6g5hEy7ZZWXpY9D8biHekw3Y0gSNHldovbSPcTUAzfV36BCEm4eXx9On3jdySk/5LZSFg6ZVWpc+bLgJC/A+or9Ako2YuAy7L9RrnoNecFqdbOmljv+4RLhHvIVciGRtzM5BHZCaH9t7AzDuWskrmlrDcMwcUHW0oQ9MB9K6GZOtEBYzJcuMY8p5Kml5cONmALRmlhqA3uzwjYhNwbp+QowRuY25C7xIF95blE4cvEaJ772MuUYJuOSM23IUaULo8+TEwrp9bq03KT3vryjCzMbO2ZF7avysf0PLoAHq2XSWiAybH/U7PcNNytGGwdZPz4/ALzQ7qYLIHg4bxo6V/PKIqHh23kNEbA2r1Y4UMQfAmTfwkEK7iKHuOP4rYZNynVpR1WTc0sKsNhdDN8D9+iXAjei6xlt+nI5FCrw46omOVkyiaIC9pf5uN9RFTEn5DOGgpsBFu40Tb45JM/RyrotsgsT5kiWNO4m+BJeAGsdFZSg4Sn1GMLNyD6k1ipdKM4/eRJa9BQoZpjJ8QaeOAv80Yep+zH2lBssefnYrJ50uOvxWUZBbV67S8P/iLtiaIU+qjE7bG2TJwYxIU1Xi0vtNlxcVexkb6fI6qgB29T++cyBpHzG1FAmYl+GTFWm8MxcEMzlUBiVlMfKb/ZweTho6aY0CAraD2bzQ2L7MCP/kP+rx3qU+eFPjTZPhIR4AaVNyOWUp3vGuen37UtIQxA3F2s+VxjsMG5MBw2xvbq2XwX9x3+6zQEk2OqdUoCevX1BOWPw50OGirPRDFGpzFGMIqzCJB+/6ktKH9D8CcMvoODHmeaDq+mQLK7rbguy7bjB5FE
 3Q3+AGyU
 wwJCalnHRW+tjgTLS0NxT5VYFw+M4IdNH+Xu6SVuREJVINwbKhZAw5fV+KjriC4oxPzk86S6WJacN32M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 19:56, Zi Yan wrote:
> On 6 Jan 2026, at 13:46, David Hildenbrand (Red Hat) wrote:
> 
>>> -			return false;
>>> +		/*
>>> +		 * Only consider ranges containing hugepages if those pages are
>>> +		 * smaller than the requested contiguous region.  e.g.:
>>> +		 *     Move 2MB pages to free up a 1GB range.
>>> +		 *     Don't move 1GB pages to free up a 2MB range.
>>> +		 *
>>> +		 * This makes contiguous allocation more reliable if multiple
>>> +		 * hugepage sizes are used without causing needless movement.
>>> +		 */
>>> +		if (PageHuge(page)) {
>>> +			unsigned int order;
>>> +
>>> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>>> +				return false;
>>> +
>>> +			if (skip_hugetlb) {
>>> +				*skipped_hugetlb = true;
>>> +				return false;
>>> +			}
>>> +
>>> +			page = compound_head(page);
>>> +			order = compound_order(page);
>>> +			if ((order >= MAX_FOLIO_ORDER) ||
>>> +			    (nr_pages <= (1 << order)))
>>> +				return false;
>>> +
>>> +			/*
>>> +			 * Reaching this point means we've encounted a huge page
>>> +			 * smaller than nr_pages, skip all pfn's for that page.
>>> +			 *
>>> +			 * We can't get here from a tail-PageHuge, as it implies
>>> +			 * we started a scan in the middle of a hugepage larger
>>> +			 * than nr_pages - which the prior check filters for.
>>> +			 */
>>> +			i += (1 << order) - 1;
>>
>> Assuming page != compound_head(page), you'd be skipping too much.
> 
> It might not happen based on my reasoning[1], but feel free to punch poles. :)

:) hehe, I should just have read that comment more carefully.

Anyhow, I wonder whether removing 6 lines of comments by just doing it 
properly might be better?

head = compound_head(page);
order = compound_order(head);

...

i += (1 << order) - 1 - (page - head);


In any case

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

