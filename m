Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21262606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CSgImXZD
Received: by kanga.kvack.org (Postfix)
	id EEFB76B05C5; Tue, 10 Nov 2026 03:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA01A6B05C6; Tue, 10 Nov 2026 03:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6E76B05C7; Tue, 10 Nov 2026 03:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3CF6B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:13:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A11C14088A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:13:48 +0000 (UTC)
X-FDA: 85418495736.15.D14A5BF
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51B0B40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:13:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CSgImXZD;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cULckHym5c4oXI6w2PpCZrU/ZPx5hooKxsgHRzG0yOs=;
	b=dB7fia3YVicDm5RL7E2tPu2yygy8HZerql1EInVBJMVc1KpcoO8BA2hnDi6N9DFn5f32dT
	lYwdSpKLTNBlDYhJ9sasRzJKq9iHehN5ipfU/FMYA4REJ8egLuLuKI6CK0C7s0H5cCYf0w
	xbG9hbItej8XkY9oeGWAziyiMlg9bC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794298426;
	b=5JIb2bS3rrVZnmFQenPRu+QbMtHMuzqXZKmvJ5TiETTxuLG8f7tX5fzmnW8RwH2srQQDjZ
	o5N49XE6oRSBDNwwBoy9XqR37kIODxayhlnYJCeCYshWl7fwZLlOm4ZSuCDlFImg81iY10
	zripLXjTZgDZKiLknixmj/HsT2laL6M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CSgImXZD;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794298421; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cULckHym5c4oXI6w2PpCZrU/ZPx5hooKxsgHRzG0yOs=;
	b=CSgImXZDdU57b0QvO2oj7LCP0F5NRE3LfS5hcZxUf3sit4Bpnr/LfJucnGTabkXi+grSSmQspPZ3LO/ACEMK+8g0ojb/iNA23cUle49MTwgmtFLqBLSM6sJ5viGg/P9KbTAqPpll2Bbq0oBkqZGYszb1QpcwGc/hHKBH/CZHMMg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XEUgVqB_1794298419;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUgVqB_1794298419 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 16:13:40 +0800
Message-ID: <9c6eaefd-6d88-4baa-aa9c-b856a1189730@linux.alibaba.com>
Date: Tue, 10 Nov 2026 16:13:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm/huge_memory: don't queue folios when underused
 splitting is inactive
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-3-joannelkoong@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261103212004.1356327-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51B0B40006
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rhhq1qiec9geggum8an8i9d77x4xxsfe
X-Rspam-User: 
X-HE-Tag: 1794298424-502105
X-HE-Meta: U2FsdGVkX189KZRd/WeEg50b5ItZouVVEaTgwACpXWadwia+Lt+ylQO8R5kKcCo+K02uQjORIHjEDS/svo2LtDz04MQIiI05kB7e6QEZIgoqALpDEN5NswJDTHJlYEmLH7VTQDK4hIDWulRbe/4p70x3ICyvCyKV+RZyNzbbrtxorE3uhCRbpL5J+dwtZ7MwYqXs15LgjQjkvQgc2jSARaqauRewayndXy7O2X0+NJUTLY59lVOxzV1ugaX6483y4OEAw35HseJHERGXHtW6JrWhx3t6L8nRwtgg4W58w7x+xhUbiQKO4lZyC5zKK5WyL4W0ygvLSlxYdvKZPEDMwX1CZaAq/MSutVp8DGXPGI+Q6sCm5aaSOGgcXcyFri/Cl6zPsuu/Ao6d+CKorKqq3E2yEEdslg9OqkaHt7nvqr5lNv2sQOH9EWqnLuHskhNrw5KsxfmByXiYrNrmIZiq4vZDVgB/0Ac70jBjN3yBGAGaWwuJ2UaOeoznaIAsfP3AoUXlbAHP25eotw9BVPAqfAfcrTrXwdj6xbHNJOF/b/Xjs7cLrVQL7Cut73gEpGftM98C5QhvZQra45KNX3BI1DMNYG4+GpvyKnkdTcLvlakQyGcFVDx9+R6267DuVKGfG2u65u6fX7muNq5rlHmS77prjDqLFHUsaSsLh2IoFSQrpBiUGvAwV9/5ukbFBYT0rKEBIGlWV6Zkl8TFyOXEj4MNIX8qnBsQMMifropHM6hhv2k0MNFPZxeJqp6iIhTZApiF6EnEJQUKa6i4a4F2ODh/sKTso0feYwIShzayqvvLN1UEVz6Dgl6E5ALt8zVZLT+r3hw4XBMx8rP3mczuTeeCceGqTzVsUj7livn7Ax+3vyWDnk5emdoH7uHwVzHoxgbkZHCg9dJ//gHE66Ay4Bmdd93knsbN5vDRZwfBvemP50dUhoLCVdoE92Ztp81rvkznjlMGy7qvqLxydJL
 JOsomTEZ
 dhH146IM4EesxbsFJR3Qid0CiIe5J+HKHPiziy/GZPMxe8KHafKvqrRinDXYiPKTFw3z2vD8BULYbx/w7k8VcaYyB/5jAxII5JPK6S4u7uu+xVpM3of2RrT4181AyvTY/Kg93hahG1WMrqKAbsmE/bO45G4vPnc0dm2FrRxI4zKd/OvGkzEsDCnK2m5pi1j7ySrPBGaFvXmR+QnENr/hj2ApdkGLgm0qQT3qX3rdK9WIvBKurfenlHFnWboy7shTH36InbAiMaamW5NFTa0dtz+8DvGNHdrYBgF3rtbBRXBKxMOWQfEyHddqEHgotOA3O9Mldmg48gcnVXy0Jn/ACuSxIysw0+55cGF/RbYSKLiisCZ7UxdrK2fHU4X2qzO2zB5kSWn7OrkXD0IPmP1ekAXsJHwiaPMfP6fds7CDRU6APh3m7On10Y9Podj47U3UIh6huMKciGCvLe1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/4/26 5:20 AM, Joanne Koong wrote:
> Every anonymous PMD-sized folio is put on the deferred split queue when
> it is first mapped, so that the shrinker can find it under memory
> pressure and split it if it turns out to be mostly zero-filled.
> 
> With the default khugepaged/max_ptes_none this is wasted work. The
> default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
> of zero-filled pages is tolerable, which means the shrinker will never
> split any of these folios for being underused. They take the list_lru
> lock at fault time, inflate the object count the shrinker reports, and
> are then walked and dropped when they're first scanned.
> 
> Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
> factor that check out into thp_underused_never() so that
> deferred_split_folio() and thp_underused() share it. Since the default
> is the maximum, out of the box no folio is queued for underused
> splitting at all, PMD-sized ones included. Partially mapped folios are
> still queued as before.
> 
> This also matters for a subsequent patch that adds anonymous mTHP folios
> to the deferred split list, as it keeps systems running the default from
> paying for that on every anonymous fault.
> 
> Please note that the queue has always been best-effort. A folio that was
> queued before khugepaged/max_ptes_none is lowered gets dropped from the
> queue by the first scan that finds it's not underused, so changing the
> sysctl has never retroactively applied to folios that were already
> scanned. Requeueing eligible folios when the sysctl changes will be
> addressed in a separate patch.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

