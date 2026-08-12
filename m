Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFBBC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F79F6B00B3; Wed, 12 Aug 2026 05:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE066B00B8; Wed, 12 Aug 2026 05:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40AF46B00CE; Wed, 12 Aug 2026 05:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 271186B00B3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:22:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A43621C0AB7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:22:03 +0000 (UTC)
X-FDA: 85092075726.03.4C5F234
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf27.hostedemail.com (Postfix) with ESMTP id 516D640005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:21:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TF3BBzCA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKO1l7J5+Lj5b/1ZVINpks9xo9DBxJWqzkD6biluj+8=;
	b=YI8K9539yAzHOVSepvi0YIACtvnMvabhRGAzoZAojCsFNGEc/kbGG8JYxWbV2c2cAPNtvl
	KuwSsYDcwgQnqq0z74pskbbwjrhyVi5/XDtD5EXJNzw3HKonZXz254hO+hYUqnaDdGClX9
	z6DwRb1IUbwTJ+j7Agtax7z9jH7GJhU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TF3BBzCA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526521;
	b=K8U8bBZVZlzXBdc077OvCnH5LOFXI1c5K2BvpqGvEatoYGoO1tMtW97vOtDVBRd31+iN2I
	GZB2/FXJB/lYr6W9k2ZD3Q7abGTaOZTgwZlZXvB60mjtSRA0Gd78qXA4apwTA8qoAf3j0T
	pYpWkUG8mlDuTCv7lzZnoaIQm9LWEIM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786526517; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gKO1l7J5+Lj5b/1ZVINpks9xo9DBxJWqzkD6biluj+8=;
	b=TF3BBzCACjA4PynfAjVBhUGAAobOuMBe23f95DbRnw11PiEJJBrAPh5x5UgsoUOspMlKk6xE/wKPWYVoYctIjA5/IJjkiJ1CnGygeHtiaqT/h8a+Jkpp8kXa5HDO/iSyacDvHWPOjcVsgA2HI/UQeVww314ZXWZ3Eq+uE+fu9NQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X8rG9bO_1786526515;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8rG9bO_1786526515 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 17:21:56 +0800
Message-ID: <5e58ae4e-81a4-4282-bc11-6f1ffb3a2a16@linux.alibaba.com>
Date: Wed, 12 Aug 2026 17:21:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma
 write lock
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3g8afh31mr5dsqd88ineu4hqzyk1g8cb
X-Rspamd-Queue-Id: 516D640005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786526519-31580
X-HE-Meta: U2FsdGVkX18OKDlNOv8dpfNEGiG3k7oP7CW/cOUr0wZ1m2xiA8Z/yY0d7ef8eN8gL6MGbDpSDyrGISZR/9Aj9V9cLLzSZDr2LSX317rPhA33qCwpeZi+iHLWVWZNsZxghNmoKsTZ6FyN5SOJjtdTTLT5yfqYcGEFL0EFWAbsxNWmY2NNVihFW0DF9891nhkvzwF/kBqA6QpU6JQMB8ajVFQEv+PkIvwGF4OUQ5rJ/AAdEqYLZyGO+aH/Z4zYH2qqXK2GfxAC7rU6UtxXaCUGxbj0aec2mZOARlsNBIe8MD3sG2J6T1fCo3gF9ahD+Ymx/ziFyqv/NeXNRNP4H1XbILCFO6gBIpT18+qzZLhEJZldqrUK4K6BNuR/2Tf9yb/GWDBltWPOeNqUWZVE2/Dsi9c6OMH2J7UsK+02M6ZR/EoJJvLDX1vAd467U8X45eQjnRo1Do2NmmqJ1auW/HolXO9u8vKdFdph1MCjGMFFZsJY6osg9vvWjm0AfpJBsiqlwFbIdTMz+9ynrpySejMZkqWRAEleP4/qiNWWNWfOH9gB9Fm7OhoSfgxJ52YQLAsXkTOMz11pCKUkzJHokg47ohof1SAb/x9rOoUmo2JFJT3ajzVX9t4DJxox9cFuwA/H5rHSU/AwI/6fpD8dn8TRzbEOmD0xH8yodmzecs2nTEx/pad8T8oypshdoWzbNwNLJ0cbhT0sH0wOTvuGGHyBxKA4IXMPGovM3QPNZFojwvNgCX+XIctCJ03EOCfJdZBPJEhJX4+prmTN9zLccr8VJAZSUb857OMAbuqoyncFF+WuQukQNN6gGblK6zXvz0eLkBr6AFWNuWP2X965lxtIKcdyOlZKAGSn3QcD6pxBM+vXCjcvWwhzw1dnYAvHgL83dtKk1JDrJJRJ0iahUoJfHDmxmyKGDWrsaydRko93Y1/Tx9CDun92UWC/P2Ikjd4sbA3E0DCz2gao61uyj6W
 RHTBgmtv
 I2INmRoLb2au3c7vUujm5rpL4xCLHVchERnwogjWN8cx2NxowxhkaUkKGrO/GYaskNyiAHUqClo49W50lq4LX8tqxt+DoPs2RvXLHundmLHeTJDGRpQPV9jafNNxFhr8NHSIBdDCcV1gGzoAUEj1oUbzT7SleqrzA66i5OsuBGh0CjJl623BkTudIVXICJbBdt0IAxnPyX37gFZAPsDQEFCftHxhrvl/QZPVnyWrr0RmJ4z39BvfzcrwDpCOKKL3hTYrLuYlACvSvRzDE+nelGwRl50PbMmzJ2sL9oi7DYvroqrHN1XYTmxigcK29gDgEX75s6s17TcXue9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 8:48 PM, Nico Pache (Red Hat) wrote:
> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

