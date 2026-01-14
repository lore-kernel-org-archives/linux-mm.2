Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4A4D31A1E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD376B0005; Wed, 14 Jan 2026 02:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D8B6B0088; Wed, 14 Jan 2026 02:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA996B0089; Wed, 14 Jan 2026 02:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0A0F6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:37:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 943BF1403BF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:37:00 +0000 (UTC)
X-FDA: 84329763000.28.2D13B1F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id C2EBD40003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hq8LWTkq;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768376219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgpPItIshWGmcckmFrugYSe+KJgz1r0vWlTEq1rQasc=;
	b=Re3pOFQezcfsgCmqMoWD6h1aRPdn4qQOk/OT2StePB2YWN/sbiHsR/XWRU2vpm9tqXRXmQ
	zfXmvy9DCOT48D9ohsHoHeu7JXzKxFm3HB05lQpZsdogSkRepHa1h2tC/JQNm2QJ2jwA4F
	w48bYDytP3pa/rvsNQIKUbippC5v9WQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hq8LWTkq;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768376219; a=rsa-sha256;
	cv=none;
	b=cHaBVbul1ghZPyekdyLSAJgzi4gD3ZjeScuKE1++0T4T/2qkyHwXfdAHSMOZa0ISQlgaDc
	sm+eiB9Vi2H4Kn+8X6yWvxxMWgQAAAPeJoYYIYTZoBzlzaCZTnu/BN5N58VyvWS91nq0c/
	LzB0/Yq/DKvigg01Ik129SKtyETP1gs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768376216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgpPItIshWGmcckmFrugYSe+KJgz1r0vWlTEq1rQasc=;
	b=Hq8LWTkqCF67yXsJ31A7soDZlPcqcomQJiHgqNnF0m6g29M3M9kH6ioqqnqloayBQ+xVBy
	O/xpnEA8/MgK3pILd1appcJX8ppg+WahBMmIczXm6DqZkj28nE3vQUnc6gUjbE8GdgQVRC
	oG5OwGppan+Ofx3sWgCyhE0SAFHBDjo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH 5/5] mm: hugetlb_cma: mark hugetlb_cma{_only} as
 __ro_after_init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260112150954.1802953-6-wangkefeng.wang@huawei.com>
Date: Wed, 14 Jan 2026 15:36:18 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 sidhartha.kumar@oracle.com,
 jane.chu@oracle.com,
 Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <C06026DF-7E7A-4767-8A74-C1C775CAD3FF@linux.dev>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-6-wangkefeng.wang@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C2EBD40003
X-Stat-Signature: zpg3wqkwnh8r5bru7xg1swudwnzeqbqe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768376218-24913
X-HE-Meta: U2FsdGVkX1/DRASuwObOB2vLs3EEDy9lO3WM8nZYVa/N5gMYjNOepcgHht4r9Ku1N8efdq8vLp6lNhjJ+K44cmVSj84IOf0SofkMW7hSwWXXjM48AnKEocRZze7R2GNuaNGxKlYI9pJDfiMZyA/fEhsxQtqKbJCVFejSvnD5Rz7EK/969Bnqn2l506GHcnW3sKHnyFHwxJeCW46yzdmXAR0WKhbKvDUuT3LG/oa8XlP3MCOqPJcvQOjoXe/xBEGaIfK0wvExni3fQeAw+M8A2tXoQre4seP8qsxKOuLCnpNMXZm4MclX1M+j/BTt7Qu1rLRkDei5+m6OF1EQLd3Q4VTfZuJ7v2S8HVs6nmcuhLRN2F8aZcGVz+4adIeTGuay84lOXAj4cbd/w9dXvPVs42qarqwtAznwBAyBXUQD3NLGpI0o4VHF43u5lNz+co2ir5Q/vKyWn5PJnn/cLIc5LNVfPeHHYfemHcpqENXHFsf7BUqJB+OiEBqogK7w7GLF7vvKogpYXl8yKIRqX3SgqfOnH+VGQOcWsAf5qPUvoEAF3QVvAgsBL2Kd0D5loGT+bzZGRleL4l0k4wWXmRz/78ifumsPdq6LHfGw0Jk5GsTVVMUDv5GsBQA/7WFY0TqKUjLpaySiJpB2/fKWVzo5USz1f6tspW76fgbX+/M+lpBbKuuICvYQdKdBnekBWhSG9kqvpjxRc4ZLfRRJvBNfo8yxIGQGbzZSekkoJPbb7G5BqsO0Fh05ANF9m33wIRIJSDFqhxv9/xVdvZh+1troonRAHQpCQY4Fpd6OQkgj5wXTZ4rrbfKOqezdykFl76iv8yRPwUxz6Ik+m5PSQ3BUSbudfZ8PeGzMK5pEvF6NM7hGYZ3qhRvO9z6v1aCpgFkKF6W1XGfcM4lnty0N5cadwXiRUYaqfeNyFGqkHS8omABELkZ4Fhx2QVHOYrxbD64j4aoJr1FBTWKnILZrDb5
 rYjYA1ZK
 W2XbIeZwb/AdeS/I696AbXC9jxNTpikfjz5N3m8w2ySK9+i7t46Gw8DR+kyAa+P+YAT5VPQ4WehG722rIaUJg5cKZnkXjr0aXCMb0SzsHaQsD6djVU1SgXmSBg4gsQxgSg/DwnfmyJx/o5XoLXdpdPNSj9c5aZZ4q3WbiM+9VcqlMeHlsKmvYDpCGphSZKV/+wUHHR32UZovhtTl+vVRu9YWn6IYIs6XNEbYChEDhg3GLUc/LpKr+hZPnOZiqPTYPtj6awXoWyLVjPOMvRwTwZ8/HzcG5XB2BG6YDe5J9/lQFJWPWMljOR98WQxdlH6t/2jgibxKJfSWDZ1hjzqcsic7gXv9DxxohH+H955Mx/5vRDfraHzAsuBJKHgC2GhbbMC0tpd+ILU5bPzRq+u/WzFxuhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 12, 2026, at 23:09, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> The hugetlb_cma and hugetlb_cma_only are initialized once during
> init and never changed.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



