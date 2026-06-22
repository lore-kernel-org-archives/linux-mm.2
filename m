Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DB5CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C416B0092; Mon, 22 Jun 2026 09:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5976B0093; Mon, 22 Jun 2026 09:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FA56B0095; Mon, 22 Jun 2026 09:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A65B6B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:07:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BCFA120173
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:07:51 +0000 (UTC)
X-FDA: 84907575942.21.6702928
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 260BEC0010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:07:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YwrJHPhw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pne37grVKNkhqLJPvEWX88uVjsSxqnASZgflvMtzG3o=;
	b=khwuG4Cd5vyI3q93el4DjruqEYfJr+aDbiSYHeY7AirI6kBnd8XNWdaqyZO4IlS6yAhxLK
	OWK5fqOUrx3pnXWSD/Iif02+JHSsAjONsM+cxIbosMsph6dpgsFHdny2G0NbzOhSKfvNgW
	y4Lwcd6sLVdGt08ipbvhY+jEykWbY/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782133669;
	b=SLey9E5+TJB8a11zDIwaJvxr/IXs+aBS/3vZgiMS+1hYdvganZvVh/qPxUrfHLhEvj8ft2
	xK8Cs6JI1p8dc720XMpMS33SHTckfbdgjANa/ow5Ot6yJNiWRTpV1VIzFoGF0sfAwXnX93
	FDQylxf564r2tv5wPmGjVrHNCXTOAD0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YwrJHPhw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782133666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pne37grVKNkhqLJPvEWX88uVjsSxqnASZgflvMtzG3o=;
	b=YwrJHPhwm7j7/p2kfVr1Ct4NfleSK0geBevPHUEoZFwTfevnK6G7mFIlOa0vIrqYW7YpIU
	0nwzaDABIIp8paEZq693mcUdFiyEduT5I08YvEcB4YJZ0U29w5vBrk60Dx+dMVJ4PslyDI
	hv1m3iQT+G2IDM3qr8LYIEXyeY66s5s=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Jun 2026 13:07:42 +0000
Message-Id: <DJFLNQEBX3PK.1ONMJBA46AQNL@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
 <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
In-Reply-To: <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 260BEC0010
X-Rspam-User: 
X-Stat-Signature: 3xwruqeo38ykxjd7se9aed1gjsx4n9yc
X-HE-Tag: 1782133668-504140
X-HE-Meta: U2FsdGVkX19mrWM4rfND60kWnqs813RiMnu+ACwy2VXH1mhZe4yEVce7udGYwmSmm0XJ4Irk6WIpKw/FHJ1jnxjGKt5mOxWFLaCTsucJs47aA+JScJ3C96Xzwi3ZDtvra2JivgIH/pcqdRjnCsIXC8vJAZ/UnG271pICI8RYBwO8CC7eJz8V1jC1D8upYzHbs6L3WTvDz9OhYe7pg9E0h2Q2FvcEH6VYfEh4ehd/YfQEG1zrA+WUWnlApo/fweq5HJQLKZbsP/HYjkarnklO2/32nURlLt/dbQCXM4AodKw8JvmwyP4HSKVEdemtlq236Q1gK5Jjkd4HnAF9mzqh7ZAbguSD1es3XuKmeQ+7jpr6fata8ivz/wk9TK17sgdmzUoLQnqdPWdjZDNR10rOhvGkyU7LVdEPp55FsD5cM6r4qgsgq55xi3wigB8VW4eRoEjZRSnYPdsT8hIh3oZtLz5I24MxmliwOHU1nrtpNK1OjXl5Z9G96aLNEnGIQI23dAmHHE8+0losEV0p+ms7Fp0WZdrUVN7NWxontKyssWrrCXHDevDSDWgu0C6AFj30mGJXptr+gkFGYC+P6JhtKxIXXIv2Kuy4HNSgpshtCdEwV0OGt6Dld488zqUQg6jtTB9v2P6UGhiWiyPFOykefa7X2mtKeldwqNjUZ6PDqECIvUcCHqmXiDtyWo+cMVqu2B7Ng1T3foYH3fKSMM9w2NPPXeEc4/IjIT2e4aDZWHQ/A045TCv9cYNZIgunlwU5WNhR34BgSSTvqt1w87659blobxzegdczjajplSAk4yYDvSIB/wselk7LLekEe1ucvNcgp1SB3bZ2puuO5oQl5wfeiOqSINu2lNbgdsnDKgUwOmG4wG7DlNSCVQQb4WGW9YvRJQmghl6ATdqGOAdgGo5Fvd2dDgYQZv0YiPSvuJknup4HkuA1grLNJo1uscZpyvGzeB0mS/6sFRdvIXy
 9jUa9riW
 wmLcGt+Nhaiu77p66wlaIeqU6ubvA0EZmsbgWfcXvaebGI9xBI0u+MIyQd0HhRYjb6I5fvEPs42tUcbZ3ZuVMeR/ajJlCB2xgopd+Xkz8f2S4kJ7PZdJsm9LJV9T2p7ACNWvbPUzYVByQI/6riAt4mwmUZJcZealU3b6fpeaDSJQ/NGmd02Z2lvWnEAu9onRnooDsB2IZP2tXq+UGrmlt7m8gtEdyq+/3zQtFlxHvErHgqEgWaWulSKEse+2BdnM4es9LNA8a1LFLDppVBPkkJldUuB/diDuiQPrNOTLVCu+G7h+dVq7H30us0KekOZwRw3qKwx5d4dvp7oXIwl2AVT1tU73SK3Mw4Tp9q23FbTaIBsrXDURPyDDFtwAl/sXktV5Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 22, 2026 at 12:24 PM UTC, David Hildenbrand (Arm) wrote:
> On 6/22/26 12:01, Brendan Jackman wrote:
>> It's no longer used outside of mm/.
>>=20
>> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
>> this also means moving the definition of alloc_pages_node_noprof into
>> the .c file.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>>  include/linux/gfp.h                             | 16 +---------------
>>  mm/internal.h                                   |  4 ++++
>>  mm/page_alloc.c                                 | 11 +++++++++++
>>  5 files changed, 18 insertions(+), 17 deletions(-)
>
> Do we want some mm/page_alloc.h , to start splitting up mm/internal.h

Don't see why not, if people are on board I'm happy to do that for v3.

(I just realised I put __alloc_pages_noprof() at the bottom of the file,
while it should be next to __alloc_frozen_pages etc, should fix that in
case we don't end up going for the separated header).

So what would go in the new header...

- All the buddy alloc/free entry points
- ALLOC_ flags
- alloc_context
- buddy_order*(), page_is_buddy(), find_buddy_page_pfn() and
  __find_buddy_pfn()
- post_alloc_hook(), free_pages_prepare()
- zone_pcp_*()
- find_suitable_fallback()
- free_area_empty()

Anything else? Or anything on that list that should stay in
mm/internal.h?

