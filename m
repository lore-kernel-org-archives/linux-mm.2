Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E049EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9ABE6B00C0; Fri,  3 Jul 2026 07:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BE26B00C1; Fri,  3 Jul 2026 07:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62436B00C2; Fri,  3 Jul 2026 07:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0E8F6B00C0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:43:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33F868E7A5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:52 +0000 (UTC)
X-FDA: 84947281104.17.BCE21F5
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id C04BA1A0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=axBe2JTE;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783079030;
	b=AHiwIC6teTpxFKfhAd8myOxcMwg5RJ3oG2UtnBuIKYd/P4SZCjnAR0tsVM2M3EnS3FdsAC
	yV6s+0EVaL8nhKRBo7j+tGl+GqLmAtbaeULPDN3n3hNCwdBVt2MsfArk9P/S7Qq9krUhzC
	sy6zfeh3l5hQIoVx34Q0HzMI0c59tao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783079030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSetS396SrH76litqhz6V0tLsyOUbEp17iVMUlqbZ0A=;
	b=ND1x1nWY4WvdjUwfvBPAiZdmd87xJEoOVynu9qqKE9Lasf45QHbMF6c7mIDIKRzYZAG7R/
	oz9FYNcd2MVX4rzZVdIT3z8FOzd7YuK1xFJXCkqOVVcphX+RLzfo6hpnNcbgCGDWgQXCrJ
	mMS1tgJP9HvVoBPyk78VLTPqEigR6v8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=axBe2JTE;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783079024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSetS396SrH76litqhz6V0tLsyOUbEp17iVMUlqbZ0A=;
	b=axBe2JTE4wy9jYDVh/aDcxlWFqplgDs/zl2EfbLtmG9mqQTYZV5rPg/mysAbrTIYroHQun
	imD73iN1OFVJuv2JTbrfrEOVOfWxT3+/GG9kaJQRW5kMdQ8aqP0fGcDHhwBu9Ypv9V+6iW
	7YqnlKUsRosMN4yi746SiqKn2nh99fI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 11:43:39 +0000
Message-Id: <DJOWRDASVUUV.376L8DP13F1XQ@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
Subject: Re: [PATCH v4 18/18] mm: factor out can_spin_trylock()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
 <1e162a97-1594-495d-b48e-7dafaa0a6d82@kernel.org>
In-Reply-To: <1e162a97-1594-495d-b48e-7dafaa0a6d82@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C04BA1A0005
X-Stat-Signature: c6xq9amt3cyyfbhcrt1pzmw876a95d9h
X-Rspam-User: 
X-HE-Tag: 1783079028-343645
X-HE-Meta: U2FsdGVkX195rtcpClgek1elPRjjhW1uKjcHOcnx8dlGGFtItCqrdkE50viByoH0uwUNxFvF3/D/RpjA9y6H5k/ywtefte6/1dsVRO01k/w/7DLp4l9GlgsM4qBYQVG9fCgtJFr2+YfddJtFQdvzCMkRWX3asvuSEoIjdmHguTi0au8AO1IjHh+Z9PqDv3ln5mQdfol7XrXNHTV6mfICEaGvCACbRIE5o2X8j9AdmX/oDmG/JpDHv8/Xh3uRUYOUrvu1IkX2Xzvfij+GupifD0kGROfa5ErWnzLom08uxruob/8e1bdUt9zbz5aJixidItladijuNA9PlcsTOllFKyXG33rPprEBCkFZfSPlkQG0tYMz61s/NwkBySSJ351GCwE1PCpvqnTWBu8tI+GAmCoLKxHXZhxnstVlEcUKsn4TQvrGxCHXNmImuUnJ1HGu8/4oNN5Ys5gUyRKV77af7oxNulsl3jaJ1GCLlVDwJV2ZMsMtlDfMQHcx+o0mY5RJZMcFUZZHDvaGZD3OsX+8q8ZJRc4C4VRmDSw6kB//wYGFfRiydOzBhBnjmYhIH/ylio7G0cYk/qXss5jS87t0+mec/pUmjo9xFu0EkLoRtgCfud2UFrcEN0hC+5Tki2izwTPgjm5tG1UreaqVRjoJ7pb16uYvzF/OOT80yY4qsAqfm6DHSq0V94ipIvnl/LcF1aHRz7eUH3Wubv+6tT0DGjk4NAfFuKiV1ugijA+C0ttiP4UAWij83h8WJrSfQbeTZhjeP39pI2rTOuv+L44gMAJXTicTbOWmSM57PJKAf4zM6JvlqSqt3rJJyT5dWb2qjV4PpTw4m9BY/IsqFyn0fpvF6DciS9OnItyvlKiG1q6Xg7k1XeJ5ZbeqtaYuwAULVxCeE4Q8DTmJF6B6AOJWmU65a6Kyd4uxc1HW+rHIJU7N6c/r6Zvs4XWF0L2wAplu/0R8Dtj94aSnZa5t0P9
 wQlZsrup
 Y6WvbJrpX/hbyOvmrueE1zJot9H/y07dc++sLK6gTNTD33VSpRW/9IDkw8nq7s3HlzQh5M+zUexSGijz0t8NT90+U9t3WyyK+ady0kwCXL+OkeRUpUnrWsyuec0r/05NnYXyUsWqAr0e+ErDvKmIa1dOLkdSjIlqGyiAMgee2rLFUTEurDpIy43WFJLse0wlklBP6PzVP1AVJbSKSZgstowzzwBm59eN5fVujn7aQmKMuEAbsrEJy2OWCsD76jrJbjxR/uTEJ0ZYz3n2EYi/MuyU9M11fpNZoQUlL31YH7ahZMsxkuMO77uhJ8FUX04tdBMlp8C6JDMcYaWAn8Ln7v5R7UFSapURM9jNMH61+3x6g9v0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 9:32 AM UTC, Vlastimil Babka (SUSE) wrote:
> On 7/2/26 11:49, Brendan Jackman wrote:
>> Deduplicate checks for whether the current context is safe for
>> spin_trylock().
>>=20
>> Does this function really belong in mm/internal.h or is it generic? Not
>> sure. If someone ends up duplicating this logic elsewhere in the kernel,
>> that would be a shame. But goes in some generic header, someone treats
>> it as documentation about where it's guaranteed safe to spin_trylock(),
>> and then it emerges that there are other subtle preconditions that
>> didn't affect the mm usecase, that would be worse. So, just be
>> conservative and keep it local.
>
> Agreed. We could even use page_alloc.h ?

Would be nice to shrink the scope but I think it would be "wrong" for
slub.c to get it from there. It's not to do with the page allocator.

