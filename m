Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C705C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75216B00B1; Mon, 17 Aug 2026 07:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26376B00B2; Mon, 17 Aug 2026 07:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B9D6B00B3; Mon, 17 Aug 2026 07:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B400A6B00B1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:16:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 415D6A31D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:16:27 +0000 (UTC)
X-FDA: 85110508014.12.5ECA0A1
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5046520003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:16:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qAyi6hYL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786965385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH9LwCWFH3rgs9p+wYne+nvJCLzluSxRDfVkYZbRm1Y=;
	b=Luk7qUBf7TAjqqS0j3bwiqzyLvyA0B5qIYMyp75VCITtvjFyWbe14OazKNpLRA726QsAXq
	rsNkDKPqdWSM8mgWUXtyhvQ+rsAxAGonOsWsTLcWb2uwIqC7iP4Db22mGnMJSdAemb5Y9y
	Wf18G5SNZrxumOGO3fHR4biVyZRLHl4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qAyi6hYL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786965385;
	b=6c8yZM5ZNacH5lwdBjLR81VhM4wlo0GmsCDfLJMuvmzuH5F/axUyCeMizV5z2IB05ndFPb
	aPcw2DJlAa03IvSmcOoTuWh2KbXhNsZTseTlkZlpHQ/TmKK9/z1OMx05pPAdPv8m8Xz+Gf
	QBvys268WVoDlxRCL2j9rO5ROp4rnlY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=loF7uxICqmGQt3wW0ry5WgjSFhP6qd7mp4uDC29Scf4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786965384; v=1; x=1787570184;
 b=qAyi6hYL94Fub4gVBo8Rd1scupupswpmcpZ5pE5OaVa06KDDFft8qngsdUmYUuMjVMwmQlcu
 3P1vrfQTi+yIs9yT5pCGQeCQ3Zg1BpJG9Ks64wKYLCDu8J89jQ1zRQ7fWggDSI0p7xiaSxoSXn9
 bU/SVGChdDkL8cVtwY25evMY=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (2408:8606:1800:501::1:7)
	by mta12.migadu.com with ESMTPS id fd8ad7876ef347e7;
	Mon, 17 Aug 2026 11:16:13 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside
 VM_BUG_ON()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260817103433.191266-1-njilav@gmail.com>
Date: Mon, 17 Aug 2026 19:15:57 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DA59320F-B64D-4B3E-AF6C-56266362DCA8@linux.dev>
References: <20260817103433.191266-1-njilav@gmail.com>
To: Narek Jilavyan <njilav@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspam-User: 
X-Stat-Signature: ajfnkuepuhecfq64a6jqwt3tmp9zh5t3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5046520003
X-HE-Tag: 1786965385-346490
X-HE-Meta: U2FsdGVkX1/91O0uMGM1aRMe/JOiO/YlvDdAdhxXiOOTu4f/LLgU5JVl9Y5aK5+5u0IakIjTT+hclVmp00aiSQb8KJUNYJQoUhnC28rM1ZC3Ja4jyO9vrNM3Er3dOMaXgYijbP7SPAH8F9J2NNGldiHf+Y4AcgsyjJPMoN0o7CAK/uHoQu7zypiFH1Hs4qqnJRSGJiDhtITTkHXgzIOMNchHIzBl4W2PTRhnkwBNdDv/Y9hV15RIrRM2xtZHMi+IAOpZxJOZdB2d3shMokOQSLOpTPUoXbQob8YeYgrAk7+5UJ4iiYL5J1WCvXeeW0zYqJUngS+Kt231dkpBsTfULYQ2Pm+mlBzvSJPeex9iDJuuSA0RvVP0PeC/R6LvC3p6MM5/tAmd6mEbmJf9H39LgnYi6jdalTx0Z0I7KxLU7QHSEdbmszfkVcgYjKyQNRcOjm6u6qNcu4p/Ee2YKYZEaMZ/gQKzl6gL7t1M954yIWgcUMrjU2WiayQ8w2x46gV9iMl9q7yNHIGaFYcTynIXVfKbA9baPQwDxqvufMVmWwxm/KsGgueitsRvE4vddd0E34ws7Awg6VdE5opiXVwoo9lPuKJKM5JaS66sBMHRAZbwXM056RU3BBteGGftBOzgvk2KebS3dnV2eaz9Q5OPotp6hvgTlbC0pEnGx24/Pe7wt3W+MiU1jcXzNPaETbgt1H/rhvWiYzdOus52L1gnngnc8GsWNuXvDiYhIQ/gVIROMF/e0/fv/Fqjp0wnwJ4cHXBjWothgM+rvUfY+zmmSi+/wp8pY2p3NsAAwZtpGTXgO+dW8dvcVllre18sLY/L0e+V7/dlw7+bknJUlEFx8awsB7IJB0xEM8LvocoJWLtGK7+MSRQK8VMHZWWkaMkJ0kH0zI/4xIWIuNh1uRjjtmRrPaz1KNybUdmg/pIyV46cIrTTnG3hhL0O2AkgYUxPaqk3hI8aoZ6wrwuVREn
 ke0z1SiO
 okzct9WQ9l4zJUE+mCP1Q7i+vSMZBvDfJnMqJdtxHETks4xMCabEyuHHkzvV06CAhu9Cuyy+3CDx8/uphgWKPa7QpRo/KVHSALC0K1/WHg0GISQmclXcyrcoIe4j1Y18V9GFU+WUtWrmCemKDIzNi7o7kR8/UvMTJGtULTMPA73JcbSaTdJB3h229g7wwkPgFs0PgC2D2dVgI5vXTkcY2UO/0YPIbul9XT+AWU8UhGjcEcnzifNhttJJkUFV8jB/Sy2AywzRvZtdsQBN1XyfXm7Vs4YTe+bqN9urCU+juhJ0vhJKolVMi+9BweCp8MFN2/ulUUBg4G9iPK2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 17, 2026, at 18:34, Narek Jilavyan <njilav@gmail.com> wrote:
> 
> hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
> the huge page size and then applies it inside an assertion:
> 
> VM_BUG_ON(page_counter_set_max(fault, limit));
> VM_BUG_ON(page_counter_set_max(rsvd, limit));
> 
> With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
> i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
> evaluated.  page_counter_set_max() is not a predicate - it performs
> xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
> never applied and the counters keep page_counter_init()'s
> PAGE_COUNTER_MAX.
> 
> That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
> the same rounded value and uses equality as its "unlimited" sentinel.
> PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
> odd, so round_down() really does change it and the two sides disagree.
> With CONFIG_DEBUG_VM=n:
> 
> $ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 9223372036854771712
> 
> and with this patch:
> 
> $ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> max
> 
> A debug option should not change cgroup output.
> 
> Call the function, then assert the result, as v6.12 did.  Use
> VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
> identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
> use BUG() variants.
> 
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Signed-off-by: Narek Jilavyan <njilav@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


