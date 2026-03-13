Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70474106FD9E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E6A6B0088; Fri, 13 Mar 2026 04:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4CF6B0089; Fri, 13 Mar 2026 04:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0EF26B008A; Fri, 13 Mar 2026 04:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9112C6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:33:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30659C29EF
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:33:59 +0000 (UTC)
X-FDA: 84540376998.04.CA39254
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9C7940007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:33:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ywrjq0Yt;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773390837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pz3DEQxmz7FEkfqJW1qx0kp2uvXH/vjQNuM+Q6I8Wow=;
	b=6h4Prm2tFPk4ERErPl3UQd8YD+R2N85JTTJrCmJeKHuIzzRIm44EaOlbRkZVUA8ihRoG2Y
	9rD+a5NueIlrDjKuBy5xOi4gt/IsyUuiW6/FtqehpKUdYe6RY3cvJn2MIvuIgjB/USQ6/m
	FjnNDma6u1xZI6WI6YBxw0Ew662SBI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773390837; a=rsa-sha256;
	cv=none;
	b=fmEj7Qy4W+hWE52HlBGn4hrhPQceHqNB2taPuVmJ32tqxBqRS8UWzzGcXVlljkSg3qy/ak
	nbPIW9nKhitkpPLIzQCzjzdoeicrQD0lh8rG+RIccxQNUEZILR6C8hF0lhex4ypb8lWV05
	iSh/Q81BVaJVy4FV6+mqh7gqGZG2Hk4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ywrjq0Yt;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773390831; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Pz3DEQxmz7FEkfqJW1qx0kp2uvXH/vjQNuM+Q6I8Wow=;
	b=Ywrjq0Yt7Crvla5aGF1H6LDhliTdv8hMQEItOiMoyetKUDsLitdZp76M05JRJtYjtYVE8Ws3pJ4jOS05wKdXYZ5y7WlZGMA4IHPwi8X3GARdoW8qXte98lXkvo2vuVKqp/Ma1OXkFW2KletI1QysF8d+uSJmeWJ9ceYsp1V1a8g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=56;SR=0;TI=SMTPD_---0X-rk77J_1773390827;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-rk77J_1773390827 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 16:33:48 +0800
Message-ID: <a2f0f1e3-dab8-4e96-b13f-df20b8c0907b@linux.alibaba.com>
Date: Fri, 13 Mar 2026 16:33:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260311211315.450947-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: roq6fc3rquzcenmhcb7jj77yhqw8z9id
X-Rspamd-Queue-Id: E9C7940007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773390834-272448
X-HE-Meta: U2FsdGVkX19IEJ2c/41+oGLX6fIedt8CQmLuyZKg9WOHXMiCahabpQtmul+vAdTBqlgpKb+bBzZakszlj79UN6SihAPhz/8lohlcz5P2UejEc4XnGiV7yf2S7tQqq3jq4w1DZZP0XOy4rrhhcQssDFLYUSrVULcYyz+fbBl0Ve2YFE6DUiod2nsEKffw9+ZM8mHHhEgj154ZT7fLzue75PvDvaOrITMeXYHH1cuqEXcaqsXLq16dIY5lHJaagb6XxVut6T5z/73BkNRONjD3U5c9oUrT2pPEt48UeN65b1stMLGNeelf90g6Mfs1JPgXSTFlALzJxibIyc64IRG6TobJ3Vjydi2m+YePrrrhYOtnhXotYgX6mA445s8q9Nyj/qgxMGxQqsFb0VOZzN9oZj3Katj1COsBYohs+GZlDni8+e/wBv7HQlcJEo5FwzqSx47d9LVJZq/kRHPFdml9zzfF6WhJrjGOkQAHATk9Lk5uVYRzySyFq0uAWiMbFWB0KokwQC7dx35W1uZnvJj6C4JkBoFGBwmwRhFdOWH4EeHK+sUc485VrBpcZ2Thl0j7ydRxMeFWerasyvT954ihW+zo8OO9McMPKfWlUSoO7LjarCTxWn0QJCB2I1xqNFLIthpqeoPHs2QE4UfX3w4Ej9HyrNtIKztoex8z9FXppqyqmnkpoW8/I34wh/Bchm9ol4Ju+27pNlRksOFxDdBbfo7EAwm+hMH3L3ttp4E0Czj16NdNLi6Wdj1s/CPXRfUzSZCpY+kUmBBEswoTllcaFVajiTzdPhFujdp8Ix3viIFRu2hY6UZ6AwE4RKes8AorfQsX6mUxe7lucs0t2u9/8GjsK+Nb/mRcTMEXhhAdndt3nCUbOqdQ9y1PqVtode/fR7gIYSwj429M8CPrPXTovm1RrsWafo/PCp+mIS+yxUSl0SP3ZGn0Yt2/phFxxra58/wUBM9+jeZPUtXyOvq
 /FqjGwkc
 zXm4Vq7cB4wSZUBUgBLcK1pw31qFaju7AmQicw2fKox0vURE494nantPrWVdCrVOGt/3fuzES0tS7/cdjqG+CSXd/6YReOFlrIx1fl0n0DhRLo1xBjIRGAhmqBrih2lal+FDP3unRLXvsuly6x1pw+i/icoLwmAz30AfOHcgP5g1IsEI0d0bGtKAjeLCJ5kqANIezy8soPoMy9JzSp7z5qHx9RTUT/s2FWoZvd7+AmUGm1V1lj0LTphxdFZ2etYRXWgGfvJGpkSqHdVM2anAtJeMSCxAAM0kDxbHuos/BUEJi/pBOJ/0UHyV6/KBaTIFLnIYPv6rcGCAYvuyGvqsADzXsQA1/i0K3CPh3vHQ4nYkCwIH+QOEUzKfzc5cbKAGyNjDZtKnlx1zVWwOMoesBPoGgJNRLA6mI3gYJh/vI/7QbwuGCdbm5iIWUgIPcf390xnIw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/12/26 5:13 AM, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing. Create collapse_single_pmd
> to increase code reuse and create an entry point to these two users.
> 
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
> 
> By moving the madvise_collapse writeback-retry logic into the helper
> function we can also avoid having to revalidate the VMA.
> 
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

