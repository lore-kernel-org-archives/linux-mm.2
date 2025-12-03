Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3886CD1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE726B0028; Wed,  3 Dec 2025 03:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795A36B002B; Wed,  3 Dec 2025 03:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB296B002D; Wed,  3 Dec 2025 03:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF026B0028
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:52:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0673CC059A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:52:01 +0000 (UTC)
X-FDA: 84177542442.18.46AFE67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A80018000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:51:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hF3Cy6le;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764751919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiuBWC0mEPc0OmuG8HIwlBCUgUXiOjQK/86XccfYpck=;
	b=N0eMjarFOIAWydPCMHIWL6rQ1GHsWubJ+umJ0+sHhlFDvwElmooyA/A6ZKMD3Tud5U1VgX
	F5Sk7kltul8CwmT404aIkbGdRT1mxZ6dTcWiifLIvErObTt213+uhcL2a1oHzE95sxa6Ts
	jrN5ZI2bD2ewciFuUK9SWZpvPloHJGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764751919; a=rsa-sha256;
	cv=none;
	b=1TYY9Aj74ohqIP8r39AO2Ao12yaGaX7PGhpyQULScUQvs5h2JhmJSFsboxiN+AxgQzQyMI
	lPUv+UMr0KJ5Ky3hpoll9Vr3MFiaLICW01Kl7Wi58HDsxYMvRkcQr/URzEAp1eC3HZ7E4m
	18hO5tlyMokvquOxyH6avZCVuS7OyAw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hF3Cy6le;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F10C6013C;
	Wed,  3 Dec 2025 08:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744B5C113D0;
	Wed,  3 Dec 2025 08:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764751918;
	bh=+ZBqsXW0idRjNcytHlxgeXbrst/E2IBgJlHKuXQWrC0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hF3Cy6leWJx9PRGbugpsiWwVDB8ZaWghKgw4dnWBAVQp8UEVz3djuUxrOyVc8kqzU
	 IymAdPyLJsJvwEMpjs6O3osmuJU+IstFRP63GhDemZTSW1LbRKuTClWFpUy5Tb3LDn
	 4c3plGohnB3lA6/hLVlBdfPyFUZPv1kyesd2FqYOpjxZs2mT7Ysgj9hlo++KYyBJr7
	 E0hLgkGB8JwMN/sDZblxXTv/Sqzp9i8fc0hNi5PT0AvKoTDEc0df9QZk1LvqvMjAMw
	 JE9rTLbnH687m4bsow1CWNLeSlSYslIx9cruIxsI/4AQ7wRRyrrqIGjb+DKA3g21G5
	 8myi/sfbG+l3g==
Message-ID: <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
Date: Wed, 3 Dec 2025 09:51:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Michal Hocko <mhocko@suse.com>, Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <OSalvador@suse.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka> <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aS_4E2H5aJmSvWF7@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5A80018000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: tott1iyc94yuxs9kjs88bu4m7ps4b6w7
X-HE-Tag: 1764751919-601806
X-HE-Meta: U2FsdGVkX19/JlrlgFZ+qWhHJEizfQujVhoW38jfOiJnTwgASPojGNI64+cyhA6VAg4EU0Nch8U5uWKbWdu5uunP9x77jy+eM3vpHnC3pmCWI5AJ7R6qdNjDyap6RYt03c8OLAkRo3T7Rd9AKrC6rw3v2N2Ee27dryjZmJHjJB6a5Qql2QMyHaM0VPQ89I9/luAHmzvyZxckWbflBX9UxVNgq4MI61oBcOi0wKwveV/oZ0MS5Lbc4LkUtDzP8/kiQhnJcT1dFhbpvtBf3WeFhCYwJo6KiD8o2fiFQliZG79y6c1Ha6PKzdWq4sjHLVXod7udioQek9vjJc+xez2FxFpiARBAebABDSALwJ7khQEnP3Z2WIHaF+p7E58u/P/MWkAWQQhWMzJ3IocppKDlpicG45mypM1QCeqfq37rk2T8lq17RfGpsAPIT9x/a+Ur9jUHfenFRCchJF8p9c8AyHN3vgffD04LsPTDiaA5TkXCQJ0g2hLYcA5yJhKjU/Ip7653xKC7Jj5bOywKZENl4yuwfzSCsA2YCRUgU/Pzh72hiQV1beg8YgBvwhdNyHTNSmHwWGGf+JlWWHo8jOzLmNUg/kFRcaCOHAc6RqRWgvgAdmhi/NFS2xg9/P5v/t3pzb+E0sbdFczEFekmVyPnc1zpPVWDwMgV8wycGnT5iZ+dVMGnVgIINHu7eq3BmCW0ZOqNbHw/ZL7iGIqHJq+1HqhQk53xyoUDSkYie68fLr95wjhOT9yrNJbZP/WcgEr5cyNNF3OTMwACABtZgUIvqSiMZVvJaqIuOIk/yVVdlOg20Ve0rfDdfct00eWKI3q2fmgrGFI0OpAjFdlD8b6zEXg1JCfqIMN7oDvWYkLoGERT9nj5CqjoKQevznicfpLGcKOJlTu3i/BqFq0F7iCc3qPB6KXPHfJ6gRh6fSJnZtJNxrgFZlv3ybBJhzZpvSL5DxIfriujC9evLaLstVj
 +/vekyOI
 sP6jWYSh5aOvOCtehjHzbGg6i5ZBkjDFmWTiU7BUr3mHf8Ni0iUAHdKZAQwzmIWXo+JkWtozveciHzewshUzZlN7CVb2nU82Wih2rrKbV1iZVaL9vTJuL3fZPNCvoSS2nFAd8Dq283RsCK0+WQ0M24wUBy0viVKJpiyM+WB1JkTplx1hT5kG/wEIbxtr5cRLX9vVHBtN5wvlbyXn2/sK/Vw33o9Ht5n9W/RPa2iD0aXuAN+rZpweguwXyZchMzR1vPHUagLXD0PND4PBb/GyMa9HUCvlx+iEbuLWriHkKGrVx0+efUt4pfJ9p9IIU+vcDj+d+Dm8H6gzEoO0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 09:42, Michal Hocko wrote:
> On Wed 03-12-25 03:35:51, Gregory Price wrote:
>> On Wed, Dec 03, 2025 at 09:27:26AM +0100, Michal Hocko wrote:
>>> Let me add Oscar and David.
>>>
>>> On Mon 01-12-25 09:41:12, Andrew Morton wrote:
>>>> On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
>>>>
>>>>> When page isolation loops indefinitely during memory offline, reading
>>>>> /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
>>>>> causing hung task warnings.
>>>>
>>>> That's pretty bad behavior.
>>>>
>>>> I wonder if there are other problems which can be caused by this
>>>> lengthy hold time.
>>>
>>> pcp_batch_high_lock is not taken in any performance critical path. It is
>>> true that memory offlining can take long when memory is not free but I
>>> am not sure we can do much better. I guess we could check contention on
>>> the lock and drop it to make cpu hotplug events and
>>> sysctl_min_unmapped_ratio_sysctl_handler smoother. The question is
>>> whether this is a practical problem hit in real life.
>>>
>>
>> I just today hit a scenario where offlining was blocked on migration
>> failures that took an exceedingly long time to offline (many minutes)
>> even on a relatively small block (256MB).
>>
>> Now that I'm looking at the double-do-while loop in memory_hotplug.c
>>
>> zone_pcp_disable(zone);  /* (pcp_batch_high_lock) */
>> ...
>> do {
>> 	do {
>> ...
>> 		cond_resched();
>> 		ret = scan_movable_pages(pfn, end_pfn, &pfn);
>> 		if (!ret) {
>> 			/*
>> 			 * TODO: fatal migration failures should bail
>> 			 * out
>> 			 */
>> 			do_migrate_range(pfn, end_pfn);
>> 		}
>> 	} while (!ret);
>> } while (ret);
>> ...
>> zone_pcp_enable(zone);  /* (pcp_batch_high_lock) */
>>
>>
>> Maybe it's time to implement the bail out?
> 
> That would be great but can we tell transient from permanent migration
> failures? Maybe long term pins could be treated as permanent failure.

Did we try offline a ZONE_MOVABLE block or a ZONE_NORMAL block? In case 
of ZONE_MOABLE, bailing out is not really the right thing to do.

-- 
Cheers

David

