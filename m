Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734EFF9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4BD6B0092; Tue, 14 Apr 2026 20:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54C46B0093; Tue, 14 Apr 2026 20:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44936B0095; Tue, 14 Apr 2026 20:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B02676B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:48:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 590BF160210
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:48:48 +0000 (UTC)
X-FDA: 84658955136.21.65B4D02
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F1F01A000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:48:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wt9j8PlX;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776214126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dOLQgMFIc5WUqLkqCJZGmnuCCvn5m/W7yOiMCxXGac=;
	b=nOqoDf98oicnMzfZ7qJNwodPk8NvwHRay+zKGc1e2wH4L6oNmi63ZqMwnNzqS9JJFO3H+b
	HMv5c4OliePTWqpQvKJf/D9M90Nz4y1THsFjRKmhmf1JrKpKlBg8Z4NZlAO8MijXp8OhAf
	Ea8VZ1CT1HqUAOFKHw5T8ZSmtnU/DTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776214126; a=rsa-sha256;
	cv=none;
	b=5sTypY1rG+qDN6M7nmEalndtVRCVtVwtt65AkxfAaBOgpbmO8Lv70HBWLHisXP94iYFau4
	EJrSR/mbvuQqjbYJ08NMRsInw0+NZmlF/U2+mkdEmvl6xYBdG4hrVzwNS/mfwqBovm1daW
	7yNkEToMP5pdU3uUW8wNd8H5A3cU5lg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wt9j8PlX;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7388e265-ccb3-4938-90d0-4b503198ddd4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776214124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dOLQgMFIc5WUqLkqCJZGmnuCCvn5m/W7yOiMCxXGac=;
	b=Wt9j8PlXjKFscfm8IaE/7fE32DTbPJEridqhLxVM6uhZW+xqalaHoT9Tt8/Vfn23ji9k45
	CBYPlUoobc9vIvtFyDSUZ995PPzra2KnDqphha67t9ihj9dhj9KvKloVCF2praJbRY++id
	XxDS1vNDRy1nl3tFSewQ91fuGreoRaA=
Date: Wed, 15 Apr 2026 08:48:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] mm/vmstat: use node_stat_add_folio/sub_folio for
 folio_nr_pages operations
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20260414091527.2970844-1-ye.liu@linux.dev>
 <20260414091527.2970844-2-ye.liu@linux.dev>
 <fa26f2c4-a755-4ed7-b835-465c8c5fe0e2@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <fa26f2c4-a755-4ed7-b835-465c8c5fe0e2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6F1F01A000B
X-Stat-Signature: 4iud1rut3fdykdwqw7o7wm5o3m9rfasu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776214126-343179
X-HE-Meta: U2FsdGVkX1//zah003SuoIhNZhFBj0LhMKSNRgcoSZ2Ul44rnOXRHuYXUrCIvTjzf3IldwUxnk9U16qvkUYX6B/oioUimf63svKzstEXqBteEI6C19o3YL7O7rYsoePYx/b0cOnWpLQ8L7czZR1NpjLrgOfcOiwfhISCvvnjSqAPXiGXXIXnUS05sow0BFxwin3k2jRYzSMMedn0VFfhWMWKlVLQHoHJW7QtrtYRLEAnkYKXjp5mjzI0Eoe0uvHZyjAGDaqzulOFT7hkwEuaQb/1WYpsyFUCtZIJDBJH1qESIgxlf5Z09TkRb5WPNxecrQRDcvs6Nl1hgYXSI8pETZkby7PJANSBpKc6yGY/JmmomhZIh2Dx6FhUIrZTX9zwMfdeIqMU9Xc+9AIHnkkMe1LGYFlmLB5j+owZrdpPaGl8AijJiopYk747F9MlFDNDVrUFyhFf7xfPDalZqIU4ktrNP7GNzZn/Aj1QZVcDQQtVdQhEn6NtPPpROvdJhDNInykX9eiTkHIBQglXCthhhYXW5Fsutg2RanSZmmXYRwkQmsuB2zbjxq46UiIVmVuUdUl4MqteaPU0P+6s9Di1GTs4Liu9WEXgbq1qLeEuTvgCDuKNkgGWemT8QwPe7O86pz75YF4nwKGE3H9xvvxKe/oVIDf5abw9yKg7LT63PxLanj3LS9GlEBr7K1X5zBYxVuWpCjVhU+oIUIjA7hHgeyDCVz79Zz9yYuY4GdMXXShJldm4DPKXAh4KDprROrOIvONLlT3Bw0TgNMtwXejyMhQ0PakYk2ucybjk6sAROW7AwF+IPrvpe957JKJLy2h0Ibc2BB+4ig7/HvMQt5leLUAidwRXLiYREf9peA3EFGeTuxGTvAh95c07T4xHU+dOd6G8MKDkItHbffjE23CL2j5OLHpWyB5OocSnbdfphz8Jznp1GJIePQTs88qcIV0ERT9nsKWyYh7YcZT9IRe
 7oadiIx2
 ZM7SOWMjpbPdA6swjt5R6qCxEfYc9nzRvRAF6AbUQOg3V/WjwHk7AJKKpawmV62qhurdKl8TqrgpN+rgi8hjXhLv6KCPI+Tmx8uoxohe9eyNgAu7tgFTfvzz4sCu1pgp1Tb0yYeqr2hy/qjfD7D4dyzFxNma6PcPz6pGDBEKv73rzvWB+cm1wFBOHSzHNi+Ip+X/uJo5yUIWASYt9e7rpWzOuRlKaYf26NQeEdvFbkzmSnK4toXvyuEUVO7kJqbGcBcotjgCJh35WeJqBPyxCXnkBTIkHfPFecLnIUCqULN4D0Y7dGsvgM80FtsM/2HYKnPTP/j1nSRz/89r53MswmASbeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/15 01:52, David Hildenbrand (Arm) 写道:
> On 4/14/26 11:15, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Replace node_stat_mod_folio() calls that pass folio_nr_pages(folio) or
>> -folio_nr_pages(folio) as the third argument with the more concise
>> node_stat_add_folio() and node_stat_sub_folio() functions respectively.
>>
>> This makes the code more readable and reduces the number of arguments
>> passed to these functions.
> 
> Also, that makes it clearer that we always account the full folio, never
> parts of it.
> 

Thank you, David, for your support. I agree that the new functions make
the intent more explicit.

-- 
Thanks,
Ye Liu


