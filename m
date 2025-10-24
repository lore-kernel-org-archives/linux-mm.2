Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E470CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 02:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19178E0033; Thu, 23 Oct 2025 22:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC92E8E0002; Thu, 23 Oct 2025 22:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E068A8E0033; Thu, 23 Oct 2025 22:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBCCD8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 22:08:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CA6BC0D1B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:08:40 +0000 (UTC)
X-FDA: 84031374000.03.7C7B035
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6FCE9140005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:08:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vnECX4a6;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761271718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JVQ7GVWcIU2eIV2pPNnWqg43ppy0VbXuD3FPTad8F8=;
	b=gh6bG3/0rF8DQSJmL/YF9TKMTfWcY2CmophE2mXUN+eTurpdY7x6qqff2sK07uB/qIwCSd
	j2t+CQLvbhKHMBd9x54n69QEr8K9HjCvJ5yR6XmDzNbzTGsJYxFx7+6T25RJSV+xYZJ06e
	SubToB10cJsEMsfIbc5Tzm+8CvkmcJ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vnECX4a6;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761271718; a=rsa-sha256;
	cv=none;
	b=aYcsOpgVzjt/fN3FDNhd5X4sG1v5ynrTFKDsIBwuqnjIZ9CD8+Y7e/9YzHNxNR+V6yL2FW
	pqAivgT+KQEfxXSC70nxcqqZuyBMs0GzFODxhv5PpcFD0taVZEbK1hYrSOU4GKhW4vtIQD
	oLEavMehniY6Sz0zR+v8eO3dXjM4shU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761271714; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9JVQ7GVWcIU2eIV2pPNnWqg43ppy0VbXuD3FPTad8F8=;
	b=vnECX4a6XkGY0myW4ggcQfPzYwVGI8it2z4e9NTKYtc7WI8CUx+QA5xg5M5iqVtwNSO8CnmlZzvDzwV6wHvYIIwdlbjedysbvn0Ljz3xL1A2qwG3kYM3NtyahzBWVGPrHwvujPIAeEIs2qI/jJ0FGkgigUw3mrtx6GKOfvuK+i4=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqscYCq_1761271712 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 10:08:32 +0800
Message-ID: <b1d18017-548f-4219-8cba-351e7f8d29b9@linux.alibaba.com>
Date: Fri, 24 Oct 2025 10:08:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, david@redhat.com,
 jane.chu@oracle.com
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251023030521.473097-1-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j3hk48fcro5ea1ntp4nh1rqu98y3y9u6
X-Rspamd-Queue-Id: 6FCE9140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761271717-846451
X-HE-Meta: U2FsdGVkX19lhgXrGVH3od7iArpmWXE1bXRP1hxRqp0JLLvXKJzzrN9nlo1HkaNoKI3OgDBwItqXVA3A0aBQZNF9+0veYGmMSnOMVa0lyauVR/4o89AXi5wCZ7+VHvgjQllSS5aStHoX0JtdR7b7Tx1DmHaTL+9tmrwNxI7keusbTeuh6eKeERwKvlKmjovN7m3G6PYO5yZGIs/24dsOL4T+oW4REPq+Bg0sjo3H8nPiew8Ib0YHPnsJy/AffTiYjH82XSzv8hBV/Lf07QSt+2V1KxN47BJCNMnfNGYYCuCDOAxYPxjYv/7oVVMrQUgDFBsUomTzaKjC/8gox7IA3JrNo9ngIuR+qOcElmnmsWStGoCXhP7+y+6+waSulVSCvfsOSp/RW7kYSQ79wkQlHdkU1n41CrUkWYlEqdR9Vp2rDxBmjzk/uYkE6ZkhbhvM4cQKriRyUey/Eb3yPO8xNQqGD7gYk+TuF4bQ8j1D6po/fZmEEckfQHC2LXAOjAnhbKyi0oH4TwdDuuWQCDaUQM9UraRQZhosuoqM3CToyk5KcVDzgyvVPmoQMyVpHZ2uIrrmchnDZxjrfqJKFgpyTsUq+J7KMIWQdA3lVnZcQOvjEDYhCXNgrg1G0J3jxCJ7V4pCeSBQRKKbFJFCr84JvvKvN3VzhrX4+p/2bhNxI5feKTrmabP8VqheOElKeyQH5nNZlIqIgGk5PZ75rt9q1tT055bLGuEf2hfimpF368IMXZ2Kqk9vLEl+SgR3HdCtMrNaYC2KPswlSn2GeUI3Kwv9cumWUFM3A0DjveIrJX7fEm7DkW1pQxH/CcjYzefNADbDv0eiLH0YlENO0rhFXWR69rzkQqrTBZho6P4c5l3Dh7Gr8iUkdxrqV7HhQyQNSy9mAxa2QmEZN6r7+Dy7dngiDj+7Zx2Oq1QeWjdyemVUs0QZKq5OjP0p1OtQ5udNcWMUWlt3/F14EogjH1A
 y5k8v8PA
 LzP+Bak7kBp0WwnRgavXjdTrILWc111Z5PQKagJJ3SQd25oqUYJ8Ro9hgiVhTiLoL/Udpm93EBXTrB/WWnqMMGCeqEPXOnEx+Mw/I2fvbGYTeTqbf2eZGVxBSjepbjKDskJse9KNZ6aiXV3+V6VfvmMVne03Lbg9rZ2hQzI821jI2W9wBqEAspVbkqliaci3Rou5yY7BlUK+CifCBcZsM8mZdJIotbDdxtWUOXlvM7XmId9yzPmdXeDOvC6HdLGVnhAMnD/NT9hSwloI5pDUH6GjYKxg3y4eFKIUe3yPFa4us1D44NKuMTsCahIn2klqlm4TIYcat1YubmA6DHXzW2V3lnH0x7smvmWFM22u7Ikjk27p2cEG+4iJhG0WjOkc44TkRvH/f79UMyGR5yF0vVXn/U0PzJgYmKPr159Ky9Gq45vEfv7cfUjd9AIrABlHQvFMV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 11:05, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>     truncate_inode_partial_folio().
> 
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
> 
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

