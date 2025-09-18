Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C196DCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C4A8E00E1; Thu, 18 Sep 2025 05:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D678E0093; Thu, 18 Sep 2025 05:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A668E00E1; Thu, 18 Sep 2025 05:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84848E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:01:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF626BB913
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:01:10 +0000 (UTC)
X-FDA: 83901776700.23.C5522C4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0A894000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:01:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PqfpST/b";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758186069; a=rsa-sha256;
	cv=none;
	b=Miz4bb4Vnv8/fLq/vfIrzpu7+c827PTcv6mKuuzp0uGRk59m+UNWKOWIjuAfN/gU0MLlJx
	+xIsI+mEF4cSBtRq/JV5fS3YBrKoSdXkQH0m+Hp9wrzm/Qu3PRShzYPIjqH1q87sOR0h7U
	YZNLBi/UX3uYMzl/ze2wT843eIv0WPQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PqfpST/b";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758186068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/wSaqH34v0KZoe6ggKel2oXiRC6toJfQY2vW/+tF20=;
	b=71pxiiAb/8giG1ZLdJatShgA9Ncfu26Y1XkWZnqu1bvLtfyrnRoiL+pkHdlkZOYZMwE5Mw
	fpKCt7eiTjR+HBOPR4xv3qKEqk8NedTV1j4KbBaYRUFfCPDjQCQ+YVPRWViLXQKd7U7TBq
	o8Mx3JTW1dfzFFCdabupEkLc7LnSYmc=
Message-ID: <b3e03ae3-36fb-455d-9f62-7e915e7bcd46@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758186066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/wSaqH34v0KZoe6ggKel2oXiRC6toJfQY2vW/+tF20=;
	b=PqfpST/bvj8Jq1kdP13n/p+IjwVELtyooR80qm0u87t239/kMFNHZafJIH8I1yOSbZOxOa
	+RwNlf9y9pCVPxVrrBlTvGxQLFH90J6YckJ0hVeXCjzyrfwKqIUFiEZkIz4jy1wGpByyCU
	+8iuXunakmoihq9Hpnss7zGvGkd23Oc=
Date: Thu, 18 Sep 2025 17:00:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
To: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka> <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
 <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
 <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev> <aMvHt7Z2PMuZaned@tiehlicka>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aMvHt7Z2PMuZaned@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0A894000D
X-Stat-Signature: h5u5wk96ktf6cxkh34iq8zudc4smdsz9
X-Rspam-User: 
X-HE-Tag: 1758186068-322404
X-HE-Meta: U2FsdGVkX18kzOH5lqZvu2CLTTBfffbzhq0tYkBVnD3WQoXXpsqzy5gZwIQD+tpjZnP0GCsO6WRFm7m/j/pyZZzIgCWucI2x1HBtrMLRYYK9DoUbaek1jlsVnc4qnn43ldQbjZH1VPlp59geFExCF/0qZd4MDJe6MLuPN05o7pQbHr4Gs+b0MtazVD8R7G9lF2osuWw4KUFKILuElC7aAXYSAbbzC6/sErFlRa8nMYiuH/+LRCjxCh+6QteTekpquqR5wjC/3CI6Sbn5Q9vONf5Zq6/j3qxNO5JAE0FXGvSxYzyWFCZ51P1LtLANa0MjkhrtBudJVHXocGYb7NiHXCO/dqeiiSC62Gx3OwbXWc/UnIMxZHQ6NhAMo2MnjSX1rrjLj5DZhJ7czSpyXsiu0okq8FvP+wjoKpiNmPki38KZVOFg9NlSuF6rwcSZvKHGa4eKKkAMLX4z8AIkpBNb800s+842dKobN50XXQ3169Z2NBnZXYgsTFWCpyCxAJUqQtmGDROnEqruiGXB8XHxkSxVEELVEcS0qTQiSFhUIbWc1bYvYw1hVA+hjUFLugq3KETqzDaFbmqDKMipmRUPlKikuJbGpopQ/UjRyCvS+Cpw65PFclvO/Pt8UJSStVWrUxld7Zaochhn946qve3GQXau7Ux5+VsKkM/L1lO4oJc/RXC1+Pli4Tq3ro9SmRBmVBV1ZZrVcE3z9hvJiaGY6pyyvHs9nE/g6b8RjoqnVEfdFX84CoUPBn0T/T0q+xdaLwWDJkZTYZgJaUKMi5bHTigzpdR12LBu/vpfhRYINe2a5CwWfyZ0g9C5S0kreIewK5fkoxMFc30fQOMYjWKn/9mlDhZ0z8lMCz6mhjPLXCyWFq/oGyOmzdgz8RsEsr4/wGZfV9GPX8PLtJ+YiFEv+VV5QFTLvqDCnNf2va+F6d5lo/6k7JLlmxBixg+gxVWrcm16zcGpG/A5u/FfJtY
 UyWU+2JM
 ZPP699UIfel+95HNeP3N5OmIy0UlQcp/2h0whDwAnOmiItMm2FSp6Nn0YPbODkpnrMr6gxMTx4qjh7SAr/H294GPGC9+TrQ+jwlKih5e4f7WKbRMcFpXzVqUKUF3h5g9VUW3QaMVm8Qrb5aTR3ThUSHcTQLP/oQGzuEEZoZv81i7tXtYEwxmPwHq9blKfPS/YoRvPQyWMrCxT4TEZQO4RfVSygnadwHPZfsQ1M0YeVj1pHmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/18 16:49, Michal Hocko 写道:
> On Thu 18-09-25 16:31:22, Ye Liu wrote:
>>
>>
>> 在 2025/9/18 16:16, David Hildenbrand 写道:
>>> On 18.09.25 10:11, Ye Liu wrote:
>>>>
>>>>
>>>> 在 2025/9/18 15:29, Michal Hocko 写道:
>>>>> On Thu 18-09-25 15:17:40, Ye Liu wrote:
>>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>>
>>>>>> Add a header line to /proc/buddyinfo that shows the order numbers
>>>>>> for better readability and clarity.
>>>>>>
>>>>>> Before:
>>>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>>>>
>>>>>> After:
>>>>>> Free pages per order       0      1      2      3      4      5      6 ...
>>>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>>>
>>>>> Why is this needed? And have you considered tha this might break
>>>>> existing parsers of the file?
>>>>>
>>>>
>>>> Thanks for the review.
>>>>
>>>> The reason for this change is simply to make /proc/buddyinfo self-describing.
>>>> Right now you have to know which column is which order; with a header it’s
>>>> obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:
>>>>
>>>>    Page block order: 9
>>>>    Pages per block: 512
>>>>
>>>>    Free pages count per migrate type at order   0 1 2 3 ...
>>>>    Node 0, zone DMA, type Unmovable             0 0 0 ...
>>>>
>>>> Regarding existing parsers: the patch does not change any of the existing
>>>> “Node … zone …” lines, it only adds a single header line before them. Most
>>>> parsers match “Node” lines and ignore everything else, so the risk should be
>>>> low. If you know of any existing parser that this would break, please let
>>>> me know so I can address it.
>>>
>>> What if there is a single one out there that has hardcoded to skip the first line only?
>>
>> I understand there may be no way to be fully compatible with all existing
>> parsers. However, /proc/buddyinfo is essentially raw data intended for
>> human and tool consumption, and parsers are expected to be robust against
>> format changes.
> 
> I am pretty sure you can create a trivial wrapper to print that header,
> right?
> 
>> Adding a '#' prefix to the header would allow most parsers to skip it,
>> but it still changes the file output and cannot fully guarantee that no
>> external tool will be affected.                                          
> 
> That still assumes that they expect something like that.
> We are trying really hard to not break existing userspace even if it is
> not written in a robust way. That is simply how Linux kernel handles all
> the existing interfaces. There must be a very serious reason to add a
> change that might _theoretically_ breaker existing userspace. What you
> are proposing here is not such a reason as it is trivial to achieve what
> you want from the userspace.
> 
> NAK to the change.

I’ll drop this change.

-- 
Thanks,
Ye Liu


