Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2761AD74968
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA376B0088; Fri, 19 Dec 2025 04:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840F46B0089; Fri, 19 Dec 2025 04:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A976B008C; Fri, 19 Dec 2025 04:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68EA56B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:01:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27136140478
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:01:01 +0000 (UTC)
X-FDA: 84235625922.22.7A8631D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E093140018
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:00:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0TH5GsV;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jui0S+C8lKHXNPZpEhV6AMZoZoHUHrcelBksNJ6Pk98=;
	b=Fqc1N7LFoIf2Tw28C1ewCFahQxyayx5LL8OPaXX6l4ClT6T71lk9+n/5YaCLclnvXLpKCf
	cdHzLzKjRNhMehD6OSUJEkxNxjiTiZ60uLUP4K1Tdaa44hU65nEFhNVmROb/eDCVKlkgCy
	2FBhAyOKBGOFE+U7kaWPyxaQgPnwXDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0TH5GsV;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134859; a=rsa-sha256;
	cv=none;
	b=gpD97tgsfnptURpAmRnG7WLOU2gC1n2EN2YaEjf1McWiXBJhk+vNeIF1K/cNsdEWjVm9sa
	TGYUaT4vnR/bdaahrTFFZl9fHs8cguSF44lq9nlmtMcqmNiy5rRXZsIpLBVyrbxaCuCB83
	IW4zPWn3WXjhKHvRXyk4X8c45TamzBs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E83496001D;
	Fri, 19 Dec 2025 09:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9597C4CEF1;
	Fri, 19 Dec 2025 09:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766134858;
	bh=94/ju6t+/0jAwX5bMv+Fy0c4ul9j5y1hst+W53vgUis=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X0TH5GsVRRkHvMW8e8oMJvYSg1DV6BW3dUIUqWUR9hqW3FPkPM+e1U83V3DKmvrfW
	 sNHgNC52nVAqULjrYJuxWmbsOyHlzio3kPJ5KcGKdQ9yk9ac5tzdu6BTFPGujTT2Kw
	 STT/1GuoKq7lQdhAeziARjfzRQpsvKKjscmsGKu2XDHH1OrHt2wnpoyS0lnZaDYtO7
	 1hGsF9BnqpxPMgtYsQB9YbJD8/RE/7DjYtNVqVNbzh39rmK5QU5IztEpa1ypNrnhbx
	 wVlvvEfOWw9OW6bTLfd0TVkpt0BaAKXtayqpoqhuePorKtV2eNYf63nZGNb6PgBYBl
	 njwwMP8e4TYXA==
Message-ID: <b717aa22-780d-4698-965b-10580142163c@kernel.org>
Date: Fri, 19 Dec 2025 10:00:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
 <qjrahvphdjzbptb4k7lzxbp2encmejvxumuzqiu6au3n3zwr2z@a2gxh37ba3ix>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <qjrahvphdjzbptb4k7lzxbp2encmejvxumuzqiu6au3n3zwr2z@a2gxh37ba3ix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E093140018
X-Stat-Signature: my4b3gg7tw84d88451fet6fm49fswwii
X-Rspam-User: 
X-HE-Tag: 1766134859-821727
X-HE-Meta: U2FsdGVkX19XuIRjgvvw+NhdBfDM5WK9xqxcVhBhHZ5se0YG2Shz6v+tEnanX9vrE3RB6bkTTdcsC7Kss1XmkKHYyhu56lorHJNAtTkodLZuMT3n1IMzW/hVZrmxqTr3jmFUbHHTedH/l6TwWqfyQ2ITwlVnWPYx5L8DRt010Yomj+c55mXq/if111on5I/inh2YFV6Br0U8veayu8LbqQhImicpNBcx3kLnzeLR8/vYwFbcQb/Cn/kb5pxODSog2UXczMpiWcjBG6sN0iJAvS2pGal1QlAcumXz1Jtmqv3rUusLExn3sai1yPTZ6MjMuDL/Tok7OTHMn2uafgrA5v/jRKCETexDSRJKhVSxeCTQf0UwU9hah07MLF3qypLLE+wk5PGNZ+tdqcAM1exmRC45gOxp8xDlc1Cfplckh1/s8e7Wyl4rj5ekAjG4Vkn2MAg5n8dcK4RFw1Rd/Umpyy/yrq8ZzOK/f2ML1Sj0RxUfZvSul67jAJs5srI2K+0YBe6YvFDNgvAUOrD1SQNLlUYrOND5j2yimNrEKqtC6ev5xXjexZ3HrEwnthih3strYew2BKvLPCoqxYWoqXaDSBdFuGXA/ylAgibUW+/+Yr4rzQGld2JJvqcm5wKzAJ6I7ga8XuALf6aNgA7T6bpeu36vdF5wMbABostwMKlG/6wlFBBPujMz5jHbpntQsnwWEB91lY0BIeYNogRunRBBPWzenO9OUj2UXT8OwvUurf4+aNVXIjHFrv4puCZhB7/PofpnZjY0enSVHT3Zs5eDG7GdY7D3W7se0l9FBmBDBRZOQAFOhZ3BQRbQHqGkj3jljMjZ96K2BUNu1z857lp5ojIMgMaJ2gIVCU9IVhRxu3qKb/ntMfKafH6uIIdLk55zovYrC88jz2LChBkfUTB0WvVT2Rj4DLrOQPJfsFA9WKk53d6p/DFZaXvuB90JaoufN77kLrPlebB/XQlDWY5
 iPVZZ+id
 AZSnAn+FaquckxAcHJzGi5C4OJ0aLcahjjDNuhu3bz4w8PDZN1CO6gjEH7urrVBuxFVz78Sv2kzDMZIcsxzYxJaOI/YZKthyRax0t0k3hOD4DcIFb6S5NmTRiAnCpMgfHzqQIa0en6gNmmP6bPVyvW8AbS587UORO84S72kx6EC4L6Q2ZtWmeNvtu7m3Ve5eqaqo8LU8MjIDU18lyPGp9CZpgkX0UD1dHTfllKWMqef0fciOFO60w6z/orXg8G4YUCwdQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 06:24, Vernon Yang wrote:
> On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/15/25 10:04, Vernon Yang wrote:
>>> The following data is traced by bpftrace on a desktop system. After
>>> the system has been left idle for 10 minutes upon booting, a lot of
>>> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
>>> khugepaged.
>>>
>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
>>> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
>>> total progress size: 701 MB
>>> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
>>>
>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>> as long as the take is not destroyed, khugepaged will not remove it from
>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>> scan it, which wastes CPU time and invalid, and due to
>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>> scanning a large number of invalid task, so scanning really valid task
>>> is later.
>>>
>>> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
>>> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
>>> list. If the page fault or MADV_HUGEPAGE again, it is added back to
>>> khugepaged.
>>
>> I don't like that, as it assumes that memory within such a process would be
>> rather static, which is easily not the case (e.g., allocators just doing
>> MADV_DONTNEED to free memory).
>>
>> If most stuff is collapsed to PMDs already, can't we just skip over these
>> regions a bit faster?
> 
> /* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> static unsigned int khugepaged_pages_to_scan __read_mostly;
> 
> The observed phenomenon is that when scanning these regions, the loop is
> broken upon reaching the number of khugepaged_pages_to_scan, thereforce
> the khugepaged enters 10s sleep.
BTW, the 10s sleep is ridiculous :)

I wonder whether we were more careful in the past regarding canning 
overhead due to the mmap read lock. Nowadays page faults typicaly use 
per-vma locks, so I wonder whether the scanning overhead is still a 
problem. (I assume there is more to optimize long-term)

-- 
Cheers

David

