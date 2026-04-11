Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771EAF45A1F
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 06:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912BA6B0089; Sat, 11 Apr 2026 02:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C35E6B008A; Sat, 11 Apr 2026 02:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8007E6B0092; Sat, 11 Apr 2026 02:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 718AC6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 02:57:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFFF2BAB6D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 06:57:03 +0000 (UTC)
X-FDA: 84645367926.25.C7EC8C2
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf26.hostedemail.com (Postfix) with ESMTP id 779BA140002
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 06:56:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hLFbcGp9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775890621; a=rsa-sha256;
	cv=none;
	b=4Xy1Xs+qyMAXAZxHAIPt3fvykZTi9laZ9G4BsKtg9YH54RtIg2BRAsS0ifUlKgsQMMP39L
	C2h63cX518vsIka7wP60a1XCYvylkAuewTuHVKR7PKSlOETeplCHKGhHOmYI3IS0rq1nRX
	x0JKuQMj/0YKKryscZ+e5qG9AEpzWLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hLFbcGp9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775890621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlIQer+sPlTVvAxw47yIEUkCSisIa3zev/LHqCpwb7c=;
	b=r6eCP7gwgjP5Kj3iofBBQZaey3PxVDJyo4Kl7dIlwmmxSamFiN62PPp1fF3zUtJV58VCtM
	eoiW7I3IfvFDhcXe9TXPiL8z7dqj8dhGMdYmM/xRjJ8QCSpfZNAQyNM8oTlPOWIu20t7H8
	hvXXkRgv1Qe6C1cVFl+62fTskdkU1UI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775890614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HlIQer+sPlTVvAxw47yIEUkCSisIa3zev/LHqCpwb7c=;
	b=hLFbcGp9yUoDfGEqVWMU4NibsrVXKNWnSlCadICp6YRZ7G4uzFk9Fus2kZcNojvetm89iAwbiQjHDLMe5V3TCqU9y6hA/by/PdYK/KBmbsGO2vKnk1wJvx9E8gfFrS8kOabWahKdcGR3MOUyuwJH3KbscMZ51lE902lZhKUe7Qw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X0nCcyI_1775890613;
Received: from 30.74.144.103(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0nCcyI_1775890613 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 14:56:53 +0800
Message-ID: <cdfcff0f-2849-4e16-98df-0bf18d894680@linux.alibaba.com>
Date: Sat, 11 Apr 2026 14:56:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/10] mm: shmem: drop has_transparent_hugepage() usage
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 779BA140002
X-Stat-Signature: 3t3ukasqx47ged5mh9faej7dexh6z8ot
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775890619-616733
X-HE-Meta: U2FsdGVkX18xOSUPNXcCaKTk5VbSgucs1o8zc1ZPWKqVuhYYQ4YWPuGp26/UumxEeyUYb9kKW9W5ndBm8Wk6Q+2iDW6L4FpT8ovYukkTv1AsBvNFpRL03XaR14YCqKwVfVxcS6wQKHiUAX/krWGQrqJUcaQz+FvGUQ6t5/Wo7bsh8eoEFSC1jX8rG7NbF15bXhEfN0PTlGHbvtcWOeVU3wGGB90XAOo+qAO9kcv4A4US5yQSha0mtR/u9+uhGwbVcZxQZAUBzAuYmoAJYGmyOaIiF2eflryweJjk7731YPe53LkdA9fEyJxOsmJ1nie6GDbduHKrUOsI7dx/BIKSPr4qNQqMJO6sZqjDCpvnT+aG2XRh3zwITK4uG+2DymhLDKbIqisHEVZGEqS+aVA8+1xJnVSBlj349nsYLUgrVOb71p67BGPjWmafWM80ruDyj/rJafB6xJwqEMAAlF4h1sHnkgvqhIUN99hPI/kFto2dVsxPUbvVaPjLf/j7INbTYH0B3Lom92JOMaf/DVhMQfKWwomLUQJQ4ho+zLZz+kkOWn3wRaZUz4y5e4OiqwKRCV/O3RHAPpPeAVSSgFz+zlJGnOjUyDnO+UsUkBK+aauHBvzY0qXG9HTVc9M1/yBKkAsQwB74GDi0eOsjv/NSvVjqgIkrM1UbyhPW+xlPxffhdI3YAZ1r7yyGeMbUZjlZ/D4WKJwerb8rrW6PkOSZYTsPIrO6Sqtr4lla3NssEmLFQjmTLQyxQhHJQ13lRgU+vrG7CXKCvJajnrR0a6h2crl+fkixbzNVo+ndIDZ4D7lgBF4JAuLeRGrObiDBrXnVMaGsIMCUHI4iciBzSmrPrIyo6yZ3KQNIVjxptjvubLxKklzeuxhVQitEaaxmSXmvWur07ZVRxsgxCoOR9rQUdKUq5MaoiL9mHTDGZlRo/ndACvgGyg2BeQP2IqHgfNGin1wlH+gXPo22wCrbZq9
 71W7qrUt
 7HDOl2MvkpLZdPDxnG1WYZ5FYAo7IzLut5FrXxfOxb+fX6nx8prmZYVXW414RrUv97KQFjpg0M5JqQ3ltcjql76VFpn/R5hz0vSKOqc1LXVsgJQV1wXTzpYTZzjVY2fKJqX/rhIgzrqfz6Kr1AntQjOXo3iYY2mY4eFLnGkfrfYb4Ni4OQFZiLbXEvfje2gV9kDihEaC2r/KHflZoJ0jXJBGaZT4PvQqSLTpV0lBeXVk96GVoJZxAcyVefOtFMGDNtOkowykndgUMsFXtbjI1APhmjCispK2Yf7yC4RY2nkNv1MY7IliG/Ae3tdK3ahIb6G7vmFeGhFpASeo1/58JbH1Qha4SWFgc5eXgBbiWjgkRyz1NXxqMxKkGP0de54KvWYJC+8XB3cyS7tM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 4:23 AM, Luiz Capitulino wrote:
> Shmem uses has_transparent_hugepage() in the following ways:
> 
> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>    if the CPU supports PMD-sized pages
> 
> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>    the code block calling has_transparent_hugepage(), the
>    has_transparent_hugepage() call is exclusively checking if the CPU
>    supports PMD-sized pages
> 
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
> in all cases, shmem can determine mTHP size support at folio allocation
> time. Therefore, drop has_transparent_hugepage() usage while keeping the
> CONFIG_TRANSPARENT_HUGEPAGE checks.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

