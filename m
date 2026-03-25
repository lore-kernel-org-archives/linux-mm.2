Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD39108B91E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919536B0088; Tue, 24 Mar 2026 21:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2176B0089; Tue, 24 Mar 2026 21:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE9B6B008A; Tue, 24 Mar 2026 21:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7200C6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:13:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 044C61B8282
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:13:31 +0000 (UTC)
X-FDA: 84582812664.15.23C7167
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F4A01A0011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:13:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Eeucbkre;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774401209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seGLijH81jhu5sv8tLnxhgHeJvSv+d16vP+nhY4LW5o=;
	b=TezT7ycLj1VBkpeer2PVuabZoKmCkLAIIm85VLqVrgYzpMlH4ScG/SAbxXa3rRFSZNejQP
	NIR9k5lmon7n9Hsqga6Su4PcadFTyf/pUXB/4MW2fZcig+kZuBXpJkDaWQ0+oF30hLRkoe
	Lq8ZA10amaV0GXM6YY2aK3zFUeTNhgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774401209; a=rsa-sha256;
	cv=none;
	b=Npi7UbcGa0GWL5Ey5W+FMJ2OCixB7VTJb19JGOhw2zbAUbJHSsZTQSnReGXOUtaWP45cPt
	Ia4SxIWSGyHHvstXDOtgEMibRTwDt8YeiqoMT9IkpM+TvIGhFdbVNd1Vtnj6CHYR0rbpF8
	UWlw00D4gWzN1DrPD6rtRmBVA82Txdo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Eeucbkre;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774401206; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=seGLijH81jhu5sv8tLnxhgHeJvSv+d16vP+nhY4LW5o=;
	b=Eeucbkrel+W1MnO3m0eLhKu14t9zz1WQBlCFekVMD7QOjuKlm2qhafzJlmZKhO9mhx/jhqAyI+Fl0rEIxouIZwaEbiSvc8Frvt+f6+GxVluoa8FtjdBTXjzv9gqBzqI1Bm1wJ1xeqU/JpZINgU14T2qemyqMmFv48hVgTGjZN8I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X.fqdGj_1774401205;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.fqdGj_1774401205 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 09:13:25 +0800
Message-ID: <3325315b-3f25-45a5-b06c-386c0260518a@linux.alibaba.com>
Date: Wed, 25 Mar 2026 09:13:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: willy@infradead.org, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324190706.964555-4-shivankg@amd.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260324190706.964555-4-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F4A01A0011
X-Stat-Signature: s6yiuweroi3c7wfc6dh9kdt76ej9rx6x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774401208-396658
X-HE-Meta: U2FsdGVkX1/P7uHFipf/bKgkL8BCk718i+v13DYsrEphWBuorh1Ua3gmCzpLf0MHKpUyfr5axIsG7vYKMTs4/OjwaP7RnruYvo8zDLYO6nVufCJ+Oy39i+ZVLZf+dylSpOKyEi2XCeFsVT3ucKrLEW64fMyhJ1o/N/w2e/Abt1r5Zy7yshyOF9F6JTqOTyihuPPKt8BDLl1k1F9jnREOz3XD4YF4BalKnVhPQXDkehUoJE8REiVxbR64pjAh4i/+04TGVugFZIUJWM6BKvpp3qvLVhukhdWgc+W8Ddnm5WbEEkhOonIEUS9pzntGrVgWYNUldMb7YiobVAIQI1h3un2NsHV9WASAQ3OBXfWm403lvuF+BjnHK690TjOth82Js2ydmbcAUSNM34YErDROdsi2tQjZ9EYPjk+xEDoG519fcqSEEaKMMTXzI2291vJuOsrcp/fKGXG5wwHm1tjgPtoEaQofPpnqWO1cX9VfudipVPoRMhyoCHErCDDrUs5scAuptwaSs7QCdu+y3llk+yhhLm2/CGZ/KmxQKyFm5jdmkTeVxwe9QcepJk+I/Vfi2vR1ityO0gg13CWDElmIl6wPMwNYX3i6TXpbayq9ldIIrqBm0SR6RBLScC+FiXzaT8rFYLt09Cr60N3TdViYnijoiVzgVvQ53bgtCJr1/l3aGGD8S9+vudAK5zIhYh44QZRKujAvQ4wkwVRz2wKNSAa/hlypEue+ZbvFVUKiT2rdlR6dHxwTyP8V80eMf/OaYMi5bPvNP04tfFaxfjXbCZe6CsUi6ppwJ6hVzsqHlX0UXfEL8/64ReOfqFpfrxUTK7EJ749eUSgmP6TBw44QuFf8ny2kTGMFf1gxTxAHpGXBfzBRjVgSw5hgaGV+9KCarntgfHvQ+KxTKyQIVyRNPSktNk1NyYPFqmr2cGtRFadS9Ci1QMoKOm74uvDgNY/AXIWTKGP0tgBcDO1y/e4
 XX1YMCCy
 c+xzVxeBTv4m6MN4DfzcI5758R/1TKBaZYSoL2buw0yia1UacdiAD8c/5wH4aclXq/DbcvzdcWa9y+Af+pUeGdLsU5WXAIpNNAnOxkoABp9+BMdOjoO5qQrumtY2FWGazH6V9Vy8NBF5iBQsw39C10G6wCRTGgoYFSOrL7irMjl0d6KIUEOnsD/cXJeEG6SRXD+lqM2OUy46o6IMwt3O5a7PdcvR1Rn7EeeTtFgh86APPMwcjC/h/luyQiMkdr3N3soXJcCAJZ81oBnn7z6PmRzdsWQiOv2F7Phakjw6Pbux90LTWzv9/aO5hETLYnHzTAkNqNP0lmLCRE9P/fGh5IhdPiQFUa60NyA4e4GQEhsGKl5ZD0hgcX6BaBBBgYvOF6M0GQFNptlNaDWE+FgIiKWPODPe870u1+lH3NuPOGW+cMk7mKB6aQFv02UKqnCA/qYZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 3:07 AM, Shivank Garg wrote:
> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.
> 
> No functional change.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

