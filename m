Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1B0606A680
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dL7fPahC
Received: by kanga.kvack.org (Postfix)
	id 7BB8D6B09D5; Wed, 25 Nov 2026 06:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793616B09D7; Wed, 25 Nov 2026 06:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA3A6B09D8; Wed, 25 Nov 2026 06:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 485386B09D5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:59:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C9A5140DB5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:59:23 +0000 (UTC)
X-FDA: 85473496206.16.CD4C08D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77B11140005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:59:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL7fPahC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607961;
	b=mZ3zOReOhmp48PzgfaBBJCPsfnAFZSVt08G0tSqaKWb0Olq2oWc7O9ty22FTl/4kNJFDY6
	heR+7Nrh2RLWAErhWgzyse3Jerj1cNpjmxhYgq1SGYiKuQ8+qf2zCBur0NHKaNVf1wOWlp
	Fgd0+HpRp/hHB8vtaUc3e6KmpbAnF3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsojXvZUV/8CWWLGDvdxZoety8wB2FPnWCvQ+ubHDsg=;
	b=m2niZ6eRHu7KpBtq/Q/AMW7KH2sQ7MueacOLG6ZvID80QSgFUJ26zGqX8FYrfZhgqx9TdZ
	w/aD3yQRWPKpKZQpRgCxIhGa1/aOfrMw5toSDg00wf5V4lx7TpnaC6fBkiZD3QanCy4J9s
	GFDuWu38rB/5ghZIurwgfMOYSxmFDBE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL7fPahC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D2B945EC3;
	Wed, 25 Nov 2026 11:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379B81F000F4;
	Wed, 25 Nov 2026 11:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795607960;
	bh=rsojXvZUV/8CWWLGDvdxZoety8wB2FPnWCvQ+ubHDsg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=dL7fPahCLzn8G1sTEduUAI6i//aBNNBx7AwuTOAasT7iM4V97HCsfh5uBWHRoyBYH
	 oSSDQYix7BDViCl49Har43idoVTO1J+nA+Isbf4nKf9g0TVhDPeHjUBxSabBVAwaoG
	 ifShjjz1RNUA/0cQ5nbsncVKAIJ9AcoOl6oBO9O+HRWNFGWl6lBh+74maJ4cIfPf9A
	 hCBt14ubzttO5tLDfXENrKHKI9UdS0NsLBikZbnEwNThG/FIAQlZnmeLyxOQeLpgZP
	 eGkZPD5/nsrtPR/dfbTtJhJkoDGbuihSdvlhfMTYC0wNd3v3amBT2aLXZ1vm1fs6LH
	 neQNvjnsdKW1A==
Message-ID: <57cbd30b-4c6d-4298-bdaa-481773279bae@kernel.org>
Date: Wed, 25 Nov 2026 12:59:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] fs/proc/task_mmu: read the PMD once in
 smaps_pmd_entry()
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
References: <20261125115014.4014507-1-usama.arif@linux.dev>
 <20261125115014.4014507-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125115014.4014507-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77B11140005
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s3tij8mqiaci5gxcksywbgemuhji7s75
X-HE-Tag: 1795607961-695091
X-HE-Meta: U2FsdGVkX18ehOnkdSFMqhArEt9VOXqfBd+UTs3j0PFDpNCTDwIQejoqqeMr/6h1Yqa1zazSiqgiWR9capofLTSjveP79N7gkUKl35jAo1yaXrJ647KLPSwEvihTFQcTrOe4OdQZc8WSKvDzahlbxmPoocT0o68vSUbNY690w9JQOOVTRsUJ+7Vlyso3xzgRnNVSVd1yExBqq+7yX2hAQLVKz58ojOdjnJbEYpoApL3rFJ0ssO0frcVZnYh5bkgE89RtxDHjryHEvQz3tW25jFwU98orH5Zhzncxi6n3cQ/vVWNy+IARIqIuskqj0A7tdOYRXpYXr85V66S9RNaIp2Bz840XJo5+bRVm7xwUk59mjj/WDAhqwgi4eWtGbW6+8bRSwdRQLIfa52QpTis74zhvD5xZSIZS5GoRnK++iahuOMjLvsm+KBkBOcFNmYA0SYUmmHJYoUgAKjmnm6R50TUhYrPeY2YmJvXUbGB+b3mfu8TpZ1JPpb4DaaEttLxlUfIvjBO1yR/J3cT0+CALFKzNdiSjnk9Ox+XYwGIS/6Sq197ooXdX2+FEolsMVRW3/SX1xMR/s4ployJw0RR8H0elimaORpQfRQzHOG42ArorQX8tXWlqK/wkIklIKDF7EaOy58mQ+pOQq8cpej0jM6BpP+dUfNZzkYp/AJxVTnJbvyT5Pcjj0uD3/RCf5DPa57jmbFgnZcOfr+fHysISbGMNjvS0zaY+RK0BF/1iSCoO238zCkWeEOz1eGRPz/OegcYLCZi2oNt9R6W6YUX5jno5uCOfTjZ/6u9D0hefthqORJpe1fYdDoBHRJLLpnsC7c5Lju+yVnZYiqlsqjdsA+19yvUFo40x7/5w0zdWLeqSMAaU8On3fMIB+tqIp+bcDvHIwle0nalF4CQH6hKHKXKlb9QF41aZAMaQpsEBrTbtKnMCG0p5Pjv9EHPUKkdOwzThQD3Py4OjufjRnWE
 wlun7xds
 mwQae4L5MWGTY8GrMfPG+7VKu+rZpQXC/66qjMh6q2AXa8PXeKxg9XfL5yrr0bQ4hOCYMqKJUb2MspwBDxGvyQNjH+YnA7d8KuzCr2ddiovRWFwq1Xq50m5sju3vw17tL9juNQEBAzFwqgewPsycS5CKOIVnrl7c65P9miHRztIEtrEVqycgovsaUsYwRH9uge9RZx4nLzw7qOH8ndaLNW9u8jWBrKEqiwVO3ebu6jXtCiJ/tpBQvZoDpmhS4BdJX73Cza/bSUmRaTtbCiKkEpbvYs25m3nWgH2SXi9LWXar2BM04YhkcgWcDMocH/bAJrFwQy99ACgI5erTQsJBkgPK0JBAlyDxewTKe9krCRcagKojlXXeRQdimJN8rEXvMZCtAFSo9TJDsg1LPawmwpsztrXGQ6ayLzAuPAf2WwjGTgPWOyZ2WUhTRoIuW/+Rm3I0afCbrJjpi8SRMeAK7WC5Z0he9vys6NhcltML10Y43c+Kc2zNhyXgNYUJaOeEF3xNR3Q4bvYBvCCnnTq0uzirXIRUV2paUKrsdSFdSmSjGwKI4yL6Yt+ZAzU7RnbsbjTFfCHY11iqEskhhYfqCv7f2HHyNJL6463xWgyyeTm6IiFKmimgs9FMZI0HKq+wnEV8pWZmmSd9nHVu5Ce1mL2O8GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 12:49, Usama Arif wrote:
> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
> into a local with pmdp_get(), the way smaps_pte_entry() already does
> with ptep_get(), so that every test sees the same value.
> 
> No functional change intended.
> 
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

