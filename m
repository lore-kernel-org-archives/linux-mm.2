Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5D1CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851456B00A0; Tue, 12 May 2026 12:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801816B00A2; Tue, 12 May 2026 12:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F206B00A3; Tue, 12 May 2026 12:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 642666B00A0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:04:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 294CF1C03F5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:04:12 +0000 (UTC)
X-FDA: 84759239544.28.726C753
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id F2B6CC0010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:04:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fZ91/MZ2";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0D8jQU5BfShO2sTsrTqG76Sh20jWehvtgI/ct3AKBs=;
	b=AknBDodDYpCD8STTo2zxH7Aq2UGdcFgOcH3t2cO5JyvmI8W6+VD9LV59EIsF9mIk5+fpSr
	WqLu6s+0lbq+kReX7zHRbMSK4l6XMtsVKhryS1bNagywHWI0al8XxbH7pCrmrQpQfAWxVJ
	AZWBVsupPz859nLzXQ6cOeqrxMlNR6k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fZ91/MZ2";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601850; a=rsa-sha256;
	cv=none;
	b=GqIecw0j7NSEiBY2pOubKUgMJwYZ/KWbG8ofqagr0Ac7G/3/9VGtv9EaxjFN0sMFKWAJxK
	gHl46YMyo3ZbmeYwUYAsquyCPkNZI5Q/iAtid1cmaLBGmOBK/r4gjRsuBZkAD16+zOwopd
	BFKQZQ+VhLw5+Z2krt4MGnd/KRK9Ysw=
Date: Tue, 12 May 2026 09:03:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778601847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t0D8jQU5BfShO2sTsrTqG76Sh20jWehvtgI/ct3AKBs=;
	b=fZ91/MZ20l3qiBh0DrWzOhAaGqjpaKBWbRNL7bHD0tGEVMn6IncVlSh1dh6GqjMEvFMe3s
	NFRBokLlo2zkzWxNwIxt/YWqOXiTornJyzqdnUCKzZbXmvgWnLRFREjueLLpkf+Lu80EAT
	0gvCKbi71Ot1RGVuTgHWC+fwv3V2d2c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <oliver.sang@intel.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Allen Pais <apais@linux.microsoft.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baoquan He <bhe@redhat.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chen Ridong <chenridong@huawei.com>, David Hildenbrand <david@kernel.org>, 
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Imran Khan <imran.f.khan@oracle.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kamalesh Babulal <kamalesh.babulal@oracle.com>, 
	Lance Yang <lance.yang@linux.dev>, Liam Howlett <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
Message-ID: <agNO8G8tPnPuVrGq@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605121641.b6a60cb0-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2B6CC0010
X-Stat-Signature: toup6563y414hqczaiq8zqg1xh9t31fb
X-HE-Tag: 1778601849-422048
X-HE-Meta: U2FsdGVkX1+iAd1bKZdRtaWk5Kz8trO5gRnZ11xpms6dj+p7J2GqGXjGOjOOATNuiEZKbLBH4WohBfFAuBpeKl73tJ1fCM3FQFOVrk2QX7FmnFyHsv9bOB0hSBYHhfW75e4Vgj/adB7gmvirWEA7JJgHD1dv87s/CgilorxOieFbv5fupD/js0W+Ax0EfnSfFMyT3pgGml0/iO/DuAsSq1fK//3RG2PxWHIxQtl7mBUtQn9bSXdiODdgDDsboLeDPEWtgTfInN0c0QkNFopml4WnGZwuxiq8uLAKpUYRpXYYd3urAeFjPnRt8x9A9lsFpjC65oyIaH67PURifUAqHzxRF23yOZL9zld9wXDCvoPSe1mPWSmTOJbbkdjn8ABx/20oSrftPtopK4xNInfQ59jiIzMa+mM3uPCY1LUocS2dzX3I6wD+3DrYV84iw8rNOyugsvbtnQyMJ9uJdAomiDoF7A+71/E1pF5dwDkP/DzmCWXGM/fSsu2BA1P6bFwg9d4JjwCgTAJ1NamVWg1X8ZWheiwn4B8pSCD70xJIwfXLEYcscEaPV272coSyexrSJyHsOKD5qmcUAYy3TR0pkrYbl0PGDKvySk38VNtFvfp2VlYDHWqCuqsi4/xAOwPZnz4So8q3IGdOlI6aMjgIRaoN83ZdVjzYGQiXKg6I27XJXqmIceI8x471kF7d3HbmSbLRyMuFYiHU3n7TIkbvQSeYq9WUU9FEk9JPjrfJl/zq04hBwKjIEWnPnSXMWyxRfrofqCaQe7miqEGQ4arReFi0sDDv2LoBYpMUqJpIkBShtEE+7sX9JTH/67/CZmqyEtz8yGwjHps+usVHY/QDy51kVR5JobbQPz/7wwcAQeEk2zYVK1xVhxwl1QqEMO+ORCC7hK2PR6C+7N4Wtr6rrlSMrj8yhZrk7PxjL9S/Dwv7YyuESOIJbCAALDXwcpK8VVYtGMJoOHK87/U3irZ
 Jf4PLsY0
 ZmqFnwryRNxuHLQ96hD0pb7A99DZyx0i1pz0sR81/5sdCpLoHcLGcgP9uwxZotSeXZ9FSKueGuBY+OMSd45q7xeLF0wfrtfw/MhjvThYLyHb9Y427ELCUiAwJmpZPsBWkhW3+Vlxp73DuJfZGBJojLyCX14BOqEjD+kPxj+JKv4Rsri2DdgCENlZccpWk0IkzPFYOYv60MjZp3HGhOQ9oCN2CLhvgj4lAHJ1qLlNLxZZpbLgBW38hufFjpElY4huh/FFWgjy/QNMK1GDrZlR/n523xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
> 
> 
> commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

This is most probably due to shuffling of struct mem_cgroup and struct
mem_cgroup_per_node members.

I will try to reproduce and will followup on this.

