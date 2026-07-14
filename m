Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A054C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DA96B0096; Tue, 14 Jul 2026 09:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7246B0099; Tue, 14 Jul 2026 09:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EDC6B009D; Tue, 14 Jul 2026 09:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 391FE6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:22:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE7EBA00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:22:13 +0000 (UTC)
X-FDA: 84987445746.04.011A2ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE2E040011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:22:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hraK3PiX;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzusWZQvSdAC75BhLePWkECb62a3t8QA9yY4IsEwwDM=;
	b=TTUw+dugP1QAaWcsA491h1D79kdJRUOsSdbJkJqhDa5loHmY37hJaxx/CSS8RHsHPc7qs/
	HiII+g0fxUZo5AwqWmgTedx4ommdB4EVJBNYh/grHngtHhfD3sJWpBtpaXDLQSkWw4wiOD
	44GDiEPc3SNw6huqISR7yc41NLAXmTg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784035332;
	b=TFXRTN1SP3Pj1h1R6DGX6trgAlf8asjGvapNkPbQCL9QTRHaKEGKU6MmJQ4JrTPWObztPl
	UPOg6tADYVxREeyNHEGNw5tpjkfwAMZqRw3+1qde2JgSaR5UlMukhvxeDchDN98Lf3wLCz
	2+tiRyKuPZWc6Mdaf+EqWZJKcV1ELTg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hraK3PiX;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8E8A40E03;
	Tue, 14 Jul 2026 13:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C91F000E9;
	Tue, 14 Jul 2026 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784035330;
	bh=GzusWZQvSdAC75BhLePWkECb62a3t8QA9yY4IsEwwDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hraK3PiXKmtnhhb9PCsQZZMi0fnPEajxrk/hTrFivKeDnfGKVGMpZZ6CugQFEzU94
	 xqWjX8Vb5ll8Nfl0tUO/uqtwp43W6aVdY0JwSDoelJUSkdckhXmXJz2fOjCoRYIt8V
	 T6igIIICawbRUXs4M8kFRb5DRJmS1bBe2BHAKBor0Voz19RQBbn+Rzj9UPE9wD6bWw
	 Az4uP5At9Iau4mQvIX8Zx6i8qVHPikHKAAGyrkKbv7KrgcPQcIICv1RRFnkjKmh+4B
	 2UBgePb7962aGd5n+lHIssD10B4z90mlH87treQSZZIkFi1y+LOdv/2dP0udPrh1Hk
	 I66RIsT/6WsNg==
Message-ID: <9e9345c8-30a4-4f78-ba55-d7fa073b82d5@kernel.org>
Date: Tue, 14 Jul 2026 15:22:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
 <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
 <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE2E040011
X-Stat-Signature: tegkzsud3a1d8853bd3zz9qpjfaydk74
X-HE-Tag: 1784035331-349550
X-HE-Meta: U2FsdGVkX19pvkrTOPj92CkWIenHaXk66xnn5SfFErog55xtJ1zlMK+Qd8W4YAZ1K3f8Z6m3lbvJUtHM3H9wpFjl2d16zcNgWk35GoiJ9xfNAglWxdDUQxB4c24a43Wyj4ZJcMW5DQepwyNhqupVrT07it1Rw3sMt0UYe6PJSuyoneUdFA5lNIBzmkjt5IGN2Xy/3Na0fp58/JxN3K9agLKHYM3+FyETvcMDJasXOYoQFRzj7s2r64KM6BzDprCJlA6iBvXjpL5Ul0LWBb0v1KDbDuytIRzzU1r94bOr+wcbgUjbmqg75rofzApTcXsCCMSeLmsTC9ywaQsnKy8kQEtNFd1eJ1vbxeL7AohI1q5tl/xh6uuOzHRiG5EGBgBzVDVJ13L2KNZKW821yItcQpnyEQQuLaPkEDLdzrVlrJlM0U5aCUIcUclatjj/cWhWDgUqz96meBmBgB9ZEKfWbc4pAacc3CKXm8BdAkV8F1SEgLEGifUmVE4LuICSzVFAEyd61LcsDyw7qiKzktCCJmStHPvbnHhywUNqObG9KHSvY9WimVALn9fFqmgJwgSDJyUe27RgbXZDyDvpGLjfQTmv8OYbBxsT17Nzi/ZCIN/pxl9AnD4QXRbeZlDMnfQvejy/RPeyesPtwpOs0Q4m5nlw610brjG3j8L51QNctBczaBCP3O0s5kcpayLJ0p4irazNDpkh0gAU8EGqqwlYDRTyJ/y6cV89HJler2adZCcOeFrnXEyUUUU8StSvGNmygfU1LlCNKZRcwgcHdEiz1MhKVVSU1JxQtdw+W5x8TLVM024CsSfJUd6AK2ZO/lndxwCmmMBLjveF+8t+fqkKxGGgzTquoP56GCCo86U4Yhlq1Aw9DhelohymKfjOAKsLL/p4FFb6mKan67k07NebFAjt2Zq/j0ugGTVPL35iYMVitI2nRCn5QT8QDLajEss2DRsDMOKsFyUkuGYQKAm
 uctuZLtD
 SC+Zq7Og+iTSVcweFxwGjSS1r7EYIO1/ikLI3dus1X6kGfa7FvuB4LJNnro4z7yD45kBGGA2cN9g4v6udd562bTLPIsCPt/LM+KPOJAreG86lx1HXYSpun4BKlIEYExeV84Rwc+/aKSw+1ZVU6/434plmlc/NBJJlLCl8WH7DN4U2OghX/fqxk9IOpG4BSmKJA+ABobJHDj+Ir6lcC9BqQWwwsL5lu2XtIyknfN2d6QuTv36wMhU7FQAxBQBPopNHNfikg7BLw0JKoEnD7x2PBuS7LziRYpRhE7d4ulIFDWllgkn1OcbAblKDpOz1+eAhCvO4IlhDqNI4PTQJgFKfkWMMhafiwu9gpUyq8k/EI4SoggtfkPcjAbrtD245gMfb+SD0WKIrI3fUCKWPTs6Y/s62DhzAdA63YgJFej2/sE823ZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 15:09, Vlastimil Babka (SUSE) wrote:
> On 7/14/26 15:05, David Hildenbrand (Arm) wrote:
>> On 7/14/26 03:51, Ye Liu wrote:
>>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>>> migration has happened".  Replace the four bare -1 occurrences by
>>> adding a proper MR_NEVER member to enum migrate_reason, defining a
>>> corresponding "never_migrated" string in the MIGRATE_REASON trace
>>> macro, and updating the GDB page_owner script to use MR_NEVER instead
>>> of the hardcoded -1 so that lx-dump-page-owner does not incorrectly
>>> report unmigrated pages as migrated.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> ---
>>>  include/linux/migrate_mode.h    | 1 +
>>>  include/trace/events/migrate.h  | 3 ++-
>>>  mm/page_owner.c                 | 8 ++++----
>>>  scripts/gdb/linux/page_owner.py | 4 +++-
>>>  4 files changed, 10 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
>>> index 265c4328b36a..05102d4d2490 100644
>>> --- a/include/linux/migrate_mode.h
>>> +++ b/include/linux/migrate_mode.h
>>> @@ -25,6 +25,7 @@ enum migrate_reason {
>>>  	MR_LONGTERM_PIN,
>>>  	MR_DEMOTION,
>>>  	MR_DAMON,
>>> +	MR_NEVER,		/* page has never been migrated */
>>
>> Shouldn't this be more like
>>
>> "MR_NONE" ?
>>
>> As "never" is not really a "reason" ?
> 
> It's not used ever as a reason that would be actually passed to migration.

Right, it's a placeholder for "there is no migrate reason because it is unset"

> So I think the name is more descriptive this way.

Not sure I agree. The usual translation of -1 -> unset is NONE or UNSET.

At least I was confused by "NEVER".

-- 
Cheers,

David

