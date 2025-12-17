Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A415D6406C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584E26B0005; Tue, 16 Dec 2025 21:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5321C6B0089; Tue, 16 Dec 2025 21:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413B56B008A; Tue, 16 Dec 2025 21:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9676B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:46:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBAE51608AD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:46:10 +0000 (UTC)
X-FDA: 84227423700.14.94A0E94
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id A33821C0014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:46:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajSsSTbh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939568; a=rsa-sha256;
	cv=none;
	b=6zKWZJ0E4lWDx5SLNqEeT3a+NX7is/gX+hkbHs9KXkI+X+oCgI8qP2yiRJjZGDkoVspUiq
	LsSCUbfjvsGegRXb8Gv5dokWmzHGw9VqGQcNlkClIajBQnx5hTn6L1YFIrYXwjj24CXH0V
	slvObZTscPNpFYBFgJgy+oCLk2wKNEc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajSsSTbh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWJAKfJrIAis/gjVkofg4/MPwyYID/O/3zMZZvl7ZHo=;
	b=POGyvgrsy4VMwHQPLne6mBVU4x+ZG8DAANwm0NsZZhZSCtjDnyGgwW5NtTK2/Htg5TLKUh
	g3ZEclEoyGES1Qb6IZpa+viZEBgIyGXTr5kdvQrcm9PmZu/w/OZ/jujheFfLUQ3ERSP6AX
	o9OLgzbQFKXmgpnCVXkLFCMqVIZey6Q=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765939560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HWJAKfJrIAis/gjVkofg4/MPwyYID/O/3zMZZvl7ZHo=;
	b=ajSsSTbhCR2zDsAqsjt+GAUnrQNOvxPUwN7oMt8rJ97L3GwuqOedO0vByYgvGhAAsXRDgl
	dyPh/fI6oQ7wEIu8iRbQHxc6p5qsPIBk1SE34ngCBVCsUykh1WKe54RJKcfx6SLKpo7K5l
	Tc2bmerGPJ+jkmZk5RAdjNsARbXv9Go=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v4 2/6] mm: page_alloc: add __split_page()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
Date: Wed, 17 Dec 2025 10:45:23 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 sidhartha.kumar@oracle.com,
 jane.chu@oracle.com,
 Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <B4BF7B99-1A51-4A54-80E0-28692344FA87@linux.dev>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A33821C0014
X-Stat-Signature: 13qiyjf6q16kakw8r5mr8esae46k6p9i
X-Rspam-User: 
X-HE-Tag: 1765939568-347877
X-HE-Meta: U2FsdGVkX19ieHMJUBVYvp8WYj0N8vD7MsbxulWTURCmzhegwWELzuXmIrOdI9OzVUFsHSgcNBdVGuhYfKQq+Ot7vMarOOe1vO4XqcIG3e63Z084I9STVaf0kDdai9iLihhfglYjHoEDizkeAB3ZWI+elZHSVFcqZ4tCFmHXKXegAm+oIpn/9ZSRGbdS07pWULuORPVzfj76qdEe4kKgncwYoEejmcNKlvkQkh1cm/Q6M5jDwqOPE6IY4Nsvge0SAD1fifa9JONvWIypHE9WxAebSrXHQ5fE7jTsqlw1KSMeqwY8frpDeg3B7lbG92AT6MGoXFvcW6WxkMHJn99RnWNnD9LfW7AzA/iRL2VUzNf5l3gjLl6984jQcwNjxB3EF5OF8UpqJIC8QcCYMO/fgrDCwjkkZP7p62gJ1mtpbnSHsF/srjhpF0JYHZ/aotZlcUDy/F0IPDscZjYtXdJTu8QSeRc/DeBxkxPgCaukC+KDnWm8CUrJngEwGiC7WK9ZrHKKYFc98eg9vuda5emY0YQBRU1AM0+Jl8YXwoOg9r/RGRY1kWhxfA2fcW/ZuVk+lyr0zDsoQTSFojH9pPhmHdiaP+j2kDuPtXekAM4BbkAC6TwPdPI7CyKbRMH7cpM68+ZksMUK6GUi8bzptwZi6Wshzukit1Nb2dBy2UMV9kkToP8nh/K4l1YYUgGd4CM2z8pMaKGYVEFgMWoedw1vNl8zaeAEDaErQnb5i4Slm3co6WjEPBKHr8KogDlXL2e+Tr+GJUv4D7JqC6GHtEu4wmiRjBkRCCdnrfZPrU1+ULONk9pjSHtLcLf08wBF2AGQb74HWYq+s2rIF1BmiocYajQqOys8OxGaMyb4+jEQNnhoMecxGbomXHT3kE3ts1mi82P9Ln7QkR9PM4d3ImTKQvkz01hVXpusQEdxvCTeQFLf/XIOcoHS3nKSDNo4IermOebXQQk/YIHRcits395
 iU7umwAH
 9cbcBWWWS8oz5aaH3/FTvryAq0TolR2MCp55t5p30bn4O9IBqPq+ay5FT4sVIUyVV/P5AEXRyV0Kk8PZgXQAG6oI6vV52hGOncCIkEnfqZAmS3M9SRaddmMVoYILRnwwrwRP9FpQTEhLPqZ4K8ug4XmlDYv28D0KmYr3ggA5hXy8XPgsKQkvne9xWy2WDR/7WP819XpVVywoaIS1gAxtyOAnVCBgrtDiD5+iWsCiFttnz1qsU/0joCBkqqE7sx4a2IiwRseVjTo2dVqZu6lvWh+24tUQbT31Hxjq9oyu+Gn4hhs/2447w3HkNFUVsCGIcNaPTaPocpl2jSMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 16, 2025, at 19:48, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> Factor out the splitting of non-compound page from make_alloc_exact()
> and split_page() into a new helper function __split_page().
> 
> While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


