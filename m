Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF50ACAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 12:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080098E0003; Sun, 28 Sep 2025 08:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0579D8E0001; Sun, 28 Sep 2025 08:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5DE8E0003; Sun, 28 Sep 2025 08:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D95E88E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 08:53:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47AD013BF73
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:53:24 +0000 (UTC)
X-FDA: 83938649928.28.D2532CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 292242000E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:53:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759064002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/34jcHK76hSOU5Qxl0fTUUIb+wh5jncdNnqgpmsHY8=;
	b=brBInuIrvojcM5vS0E/cFla9iDXLuAEGve+CyapZ4NbTBIDA53lfeosHtRo5BmBdN/KYnb
	MtXrmETO6nnFOiYBoTtlvVKynxexgR90WgGmqTjz7nnF5Rps3ItT6l1dRNydNw+G7k79y8
	pj8n4EzrbAJGg2RQPIgx8VKEkQ/csV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759064002; a=rsa-sha256;
	cv=none;
	b=WapdAeWg/cKqghvLgJ59XOu6B0kd2Spl8LrV+fqhG0+3xhHEqMQcMIXHfJjgfJtl7tAlq0
	TheiYXzlD8GgBdyjd7UimZqLFx11R9dIyp+YWJLxsmGXaSPkF6d/mzZILb5+nHuZtcY4gK
	sGQ3bp+WiUadGsCkaPq6oWiuiIfO8TY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7006150C;
	Sun, 28 Sep 2025 05:53:12 -0700 (PDT)
Received: from [10.163.64.48] (unknown [10.163.64.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120893F694;
	Sun, 28 Sep 2025 05:53:09 -0700 (PDT)
Message-ID: <3c3f9032-18ac-4229-b010-b8b95a11d2a4@arm.com>
Date: Sun, 28 Sep 2025 18:23:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix some typos in mm module
To: "jianyun.gao" <jianyungao89@gmail.com>, linux-mm@kvack.org
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 "open list:DATA ACCESS MONITOR" <damon@lists.linux.dev>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:KMSAN" <kasan-dev@googlegroups.com>
References: <20250927080635.1502997-1-jianyungao89@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250927080635.1502997-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 292242000E
X-Stat-Signature: 7okztusec518zzmiqj3mrffkk354azhf
X-Rspam-User: 
X-HE-Tag: 1759064001-307657
X-HE-Meta: U2FsdGVkX1/ZDHCiSvsaPjknyuQb8tVlFATpOY404+SQZAfRaLswxjqGLNS9iH53hzSZarRma/56keiCqsa4SnOvoM4D88+kqxRTFAqIWCV3zteKxM960BAY0Tk+7nVqDIXat42W5kGNHyOk9a+RLQTUMuNI+kkvTKjz4tqEVEAzipSIrkI72dfHjexdhVXBdfMDj23NF9uD10YTk9sYu8zv7e2IK7Tl11pn5sSE18nQGbarbX69uxDqiwxVnjY8iJXCqOv0lEXxASiGVmI4jnNf4CzDwtBOtwMLVKiDp7i4ySa0e+CFw/B5LeIHFbeD66kzdlrIOW3e9sKMKRlIdGjSkrD+5V5d9oGEPCIsRDA6ZMQ0yT2H2mBI2BXzdPLe1fqx+thm+BcdnydZ7fTY/vrsMeWcPHodkkwhaB0MmrNRu+58RzqQm+AqGkDSkfsrRz7do4Xu5NKwmWpejg7ZO3yslH7mg6RA4y0YpFBxAxzehfhF97YXK3x5nJw4UXHnBOn9KTNz1y/VHSIznmZsY+SV9IHrSRiA7qImqvrXpwQ7TC3bCd0724ZtWl3V2VHIULuQjBs+DlV13aLytXOHYN8OBjnxEyIWSM8OPN8sYawW77lAEdfAuMiLseUYM9J8J3JpS1nz75Dd0ziG5mloj6L01Vf+r8sIj25+n62ypaB127bEVzoEoQzcGCIMuGfECeCI3Lb1LPgKd6nd2WpYkQOFJ4gIgWhxmQIMuVKQzzZa6fd3SDhhCMVcGy3i/qcQgsV8MYLz20ku+Ko5gzxdQvsgCi/hdBbe8U95VsxQF2662KMIDfjTzdUyPj8dxTEX5XJI/W263eg6+4KLxKT54AKwuBIm69fKDyl27ig0NeqG60dIFxaAKMKqRGsdB0kXLDqafNaQaxP/7WnEQvGFpbL+otKS5OdIafT3W20z4KstUzjj9WbEf7mo0CChusxpdcEyUMqQAsRnmADucV3
 SLt04tj5
 Z02PCBrfHBTeEZPjWqPKuay7duSwsvk44YJEqwUfJ3FItalE3JrDXK3jOGKRf4WQJhv2CGED35eF7bxLltFvLV/eXcXf3oPT3qNRch3WpjySh1LN45pFv9TxIHBBuTKPOEnL7OnGqDb/Bld+8Iw7gpj6mDJCoycgDZokGQHrGo/hHMRIaNK3+zQvOrXvQsgIwesw4fgQuCuNqnPUfAKqg/79KoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/09/25 1:36 pm, jianyun.gao wrote:
> Below are some typos in the code comments:
>
>    intevals ==> intervals
>    addesses ==> addresses
>    unavaliable ==> unavailable
>    facor ==> factor
>    droping ==> dropping
>    exlusive ==> exclusive
>    decription ==> description
>    confict ==> conflict
>    desriptions ==> descriptions
>    otherwize ==> otherwise
>    vlaue ==> value
>    cheching ==> checking
>    exisitng ==> existing
>    modifed ==> modified
>
> Just fix it.
>
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


