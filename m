Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F14CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9B46B008C; Fri,  9 Oct 2026 01:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1912D6B0092; Fri,  9 Oct 2026 01:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE886B0093; Fri,  9 Oct 2026 01:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57416B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:12:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C3A9A77E9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:12:32 +0000 (UTC)
X-FDA: 85301917344.03.44602B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 53CDB40004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:12:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uoQWxJ97;
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791522750;
	b=HSFInQJCS8LbZrVqvQMaFGiH0qAQhoDk0+d4ym7Bl8kPthxHv2jJAoXh5HdZonO3bmtjRt
	3wwrk4a1Unl1QXvk16c5ZOvlwMb1tMKocaUFgZ2in72CQXTfrCrfjS2DtrVAX49+6eRxFL
	QBvjM+FhpSo8dZ2Slk+8kS+XfQUrQJM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uoQWxJ97;
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791522750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QY31TTx9HyyXDuHWiFsTDXnuZbzysF4Ga1YTwJVnuw=;
	b=j7kYayDPL2kySqVmdtwlEK78fvsZeV00FWMdlMsTSBa2ZxTkc1v1u1YvRGwJeHGJ/nDe9b
	LE9Jc47sTTAQjtNYTORIJlZq6RBXdn1wA+h7onqoVJuHpVZBcCYvUvLJhfvukGUYCQqXZC
	T/In0lPGeXghUEW0Zk/JAAb6BxDrM+k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0E891570;
	Thu,  8 Oct 2026 22:12:25 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4A4F3F8C6;
	Thu,  8 Oct 2026 22:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791522749; bh=zSYMl7a8RtqHv03GWxsPLbKj7ndW4IvlDFsjvw+3hf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uoQWxJ97Hz1eRPl099QJyUtwMLr+0dw19rS/t+kaT6bwNDS5lfIhFJP1gEVw2xRCt
	 E6jwbcmMM26ZXwu4Th+zTdRe9xh3jpu/XxuLXa5J9T6Z6ekN5+sDELupT68/FVuhtP
	 vmsKXQOaioMV3PAYMHFwrVEciO5Pv/QXqerh+mnE=
Message-ID: <482deff7-772a-4668-984f-8c4ff51da7c8@arm.com>
Date: Fri, 9 Oct 2026 10:42:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53CDB40004
X-Rspam-User: 
X-Stat-Signature: hgkhf1u7yhbgu7t11iwbx139qymhhmt1
X-HE-Tag: 1791522750-338035
X-HE-Meta: U2FsdGVkX1/WtKsEYsRF/afoDzoi26vkxh3W+L/l2vXKPArHwTrFo7fztfQxpZawMJIygREoAN6M1IcVm1phr0hm/NExYrn76tJBVMZAAuQOeIGXWAlHNsxEz8v1Q94w70Dvd+MSRjXycVniBiIdkd8W1XgJcV7jq78ij4sR6OXYpIJyQux/g3YCtsct/hWeByZp+jtaYb2+8hqhg0XvCJS9lsDZuuxszURM2sByH0YvDLWhRhcsRsXUSUH3kMUsYCnsyzFG42u91yVZK8j19VVql9r1zFsHfl3Yw9mzMBzwsGbuxqjpyZi/+Ui+ZkMVXioZ8pB8vQhyrSCsvqv0TIC5M3HJzo4g3n4flY4zNbfLk6I1QTMK000wzEi7LBvgZ+O+10rVNDnTYmwclS0Fzv4VHgNgn0UedxEBR1a2GF2QRJJLjTgGMCcDeRfkdBss8hhbVXD8W3UO6F1aUL0DdS+ZRAR8Qgu8TuN5Q8iogBqNxJi+eri3201x0OBQ9NyrpFPn6KC5aYhoc8t9UvYwi6FzDAaK5o+LhCSKPpbEVZu2tV9O2u6eKGNdhiJr7VPVOTjZ5l+Dgygu1FTksCw/seGtpWbyU+bVrjFvKI81eMii0i7wrS7EPFHab5/k92JnxbTes5Z+Xn3qGJnMV5LayTtx1AjRGpSwPdEpbpXrDkRtp6e2ac9bO5DBc3bTGJDl6VEam3TaN4hbIClMa/L82UD54iwZ2lur0GjpmIqBQOedHJrD2PTnojFu1VKNpJv26CYNGBvPLK0Mt1ruDMznxUbWGNwCKLVP+xFXhCSLgSZc0454Urqn2vsAsUxO2bSOJ4+c+B+VbKGpVjGbwAHLd+XP10eaI5erfxsnia56zxKj1LECgdfm2umcufOx2oyd7+lR5Dpasn5vcAxI5omictW0nH1Mc3pdjmlf8RArfPUoZUa/t6WlrRSSugdgUdufSDZANGvfJdmYJYdZtC5
 dRtF399B
 b4rwcyMKnEwAt0YC8hxozv01LNS0IFRCl/IAiC2jj1sbcFF82Nd1HmBlCf7dkIh4Rko82EqMOAcGySiqIGRkjREObgCcbGsQVP6cQLd/KEW2AKwos1R6ZwknAFn1TyyGnUom2RpRjJvSCrlAEThHhudlTAp6v0hT0VfQ+Uy3wJTYNZikO+FL6m0OWzQlxZXeQCJ2MFeMnrBZdK8hvQO9H8ut9Oo42A38jXBgliy+fb1qi2KeHLQD4CajDIrmEZkIbLvrXtM2mnHUQTdF8SOtSJv5bqmEXIvH+ntPpAkQ9u22njZAj1aPSb9GLMS9q7JCA8Rf5zbmQv5gtkVZVC0W7t8eLAxye/n+kq0Dclh2lFjoHxws6DzU/aoOeHM91bqTOkjSspMHWaK6OIls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 6:57 AM, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
> 
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> 
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, pmd_psize().
> 
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
> 
> After this patch, output of transhuge-stress:
> 
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
LGTM, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

