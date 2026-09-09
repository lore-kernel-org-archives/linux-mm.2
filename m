Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B035C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F31E6B008A; Wed,  9 Sep 2026 13:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4B76B00A0; Wed,  9 Sep 2026 13:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093BA6B00A1; Wed,  9 Sep 2026 13:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEAE86B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:19:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46F1DA02AA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:19:09 +0000 (UTC)
X-FDA: 85194884418.05.2DBCA62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 894121A0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:19:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MQXXW/Yb";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZltEzvklF0alHImzEAERiA+PVh7E3q1Jsm6Z/RtKTY=;
	b=8qahIf0TG7qna6sHTSm5sMUDlYkxiGRUcE54VHK4zg4XO2GLILgrmRCGHNc1aL3JDCXWeh
	7TrNlDYF7midrukE8tzKNjg0uifuvnBT+HHgS6XCf9OLjJgbDcCVFN1zqGsX0DyKk1u7op
	L6loKliAs88r9f5GwEUIi8xcLaWtFBY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MQXXW/Yb";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974347;
	b=A10a+NMkUR+i5N85uL6QAR6p3/jkLjajsRTm8rW4iZnhVixesrOKIkAKAsf444kY2RrsZ1
	uCAhn5CRMM2xPSW6al1NwxO1wvoeeTd4CHUwv6JQIdBTfSqn1FrNXqKUmrRMOl3+gL4ptR
	8JQd7wXboxWk/WoWLRdfHWqlSw2vtHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B5E8601EF;
	Wed,  9 Sep 2026 17:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913BB1F000FF;
	Wed,  9 Sep 2026 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974346;
	bh=uZltEzvklF0alHImzEAERiA+PVh7E3q1Jsm6Z/RtKTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MQXXW/YbQGdiAIOm/kF6qSQKC7Ng+EPy144HC7OYn6CjwTnO5XWjO7Fby43eLrzWL
	 C4v7HlqfPUMh7aLVhgNgLCPxrwfK9rFCTOzP/AbhNM+v9awOcMSWRrwtyed7ujlmrc
	 TBRixw4lcb2nR6NEu0ZEH8zY0RdDOdB+sdevCNXWSZ3DrnQqGNBuXEd4hT1E8WCqcL
	 QbPAQK3LFUzPVD0mmWQ5kIAXPikUPIw+BA6lLDkeFrGP/Ak2spaars2paiPewdCRMl
	 p6+rfJXjhu4UmR2WG5dbKPBzIOcRO14X4tVJiHvJtWVrT2jF6+ab/wKc7vcX1gcggT
	 e6LVYwM1m6f6A==
Message-ID: <84e667f0-f065-4679-b519-5151aff04e56@kernel.org>
Date: Wed, 9 Sep 2026 19:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
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
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
 <aqGSv_VPT1IKGgIs@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqGSv_VPT1IKGgIs@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 894121A0006
X-Stat-Signature: 4eiyuq5n57hz9ph8agrjpia5iwwzdytk
X-Rspam-User: 
X-HE-Tag: 1788974347-677149
X-HE-Meta: U2FsdGVkX1/FgkgLBhF+n74Li+DY97qkGtFwyIIv8IxYJIH0mbq2zDj1WcZ/e7r1DxgYi3j3oa6eRkI68LBIvc/niJeU4m/mJL1Vtg6N28X9e/Au2W7E5wg/mTwmKxoyW0r705dnFpWZKGYoNbM9pZAknr7yI9lHaSKWN0Ex38ifQfl9pSbm5CSsBfmoRHCN0qYht8D/OAfyx/DwAgcBd6mC92vCAISpTzHyjQusdZgYVmVJ1wyh31BZqpzyBReMvECihO2sfjwgzN1neFCqCCp3ObViJD/qwYWyHWTvpW3GHVo9hAw8s91hatX3JYDty3kdCtpdmmGcBsrJmvGDippqnzNnNLJN46urC0ZESZVjfvXdY4py2fNa/HCOzgdVPpmlIAQdllpjIInKj8vYf656CDkBUnyz03XOumDJDdbl2Gh/6xKwijMUIJN8Q1/f4vQL2c9DQzT01cTP2JYYFU7IM+FZ3wAaoap+RjKl1wAS/REfcq4CbEYbNxCUuPfuUwo+L0ffkGh1V/kJPoeyXe+Cn6d5p4Powf2SBDAiwanrXbqkVveyiZq3fXk/2unQP5CeCeJfXR7oN/Q5CEhiDbCaJo744ImIJzNFekOSrFfBe92925gfw1+u9i9mMtjITuRh+WPyxaYaRma9YQ5JX5L5YXbJrtOAWUNfPfLyJtjkXLSkZfAWUnzDG/fpG+mTAitQkrot9MEArIBz344iSQlyFbqR+wYQSpe2iBGWsfcxTFCiFYeCiIb5JQFlxr1C7mPF2bruEtKlYtw1ei40voPAYU3X9gR6j26FgY0Vo3a5LZhfB02GKOBagvmuHp69K5fnFavydvbtM/+loMmzL+vvJ1VSOXoYL6obhsqw7iRs442LUF1SBy66LfHPWx10SJ23LzeKZnDQlG0RQTZ1w8CCBF6aeQ3F6mg4u+437nWSaQn4U78ddM4c7E6yHToaKjrOfYxXym4ip4SF5xx
 uo3N82Sa
 6UouQOTsYMZa92lHLauRunTEtEzIv6ZPiZDRjm0suItAforPkSwknKzeRdoF5J06EfIEIlCcN9BsdIi1K2Gm/7SKL6+DQLhPGW2wPTL0MbNTZy8nxYolIKyQo0NnRCI4kFv3LoG9dPJnzE206b8lwU7o9VqLyCUii8OgHimSb0zZWdWZbV5XKjO+3IHmG96bIQeIe+rFCkVDrdMWmr4/GLf4fUSv2ny2riVuEiE3YqKpohc7kN4VExBYeOlWVq8lzFH3qSdjhdB5SN65wbxNr3vBy5FMaS/hCZzxI2QEG5O6pl5wwxGTW7jop4eVfd6uGqfpG3QZZkPKSzSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 19:09, Oscar Salvador (SUSE) wrote:
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
> Acked-by: Oscar Salvador <osalvador@suse.de>
> 
> Not sure if it was intentional, but it seems we lost the "Initialize memory section ..."
> comment.
> Do we want to put it back? Maybe for the folks that are not really
> familiar with all the memory section's inner stuff?

Munchus patch added it, and I asked him to remove that comment (as it's
imprecise). So I expect, once I rebase on top of his updated work, that that
comment will be gone right away :)

Thanks!

-- 
Cheers,

David

