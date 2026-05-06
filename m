Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D46CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8656B0005; Wed,  6 May 2026 04:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588D46B0088; Wed,  6 May 2026 04:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EBF6B008A; Wed,  6 May 2026 04:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6C16B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:58:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5B28120760
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:58:31 +0000 (UTC)
X-FDA: 84736394022.04.B603A08
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23FF24000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:58:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KGV7L4nj;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778057910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AiSvNvcTpa2TKyw35vaQTKtLcmTvDROixEkAC62Qps=;
	b=Dos+yRXA+4oeZnDvt4UqczlI+/yVmMVjw7a/kjFGebZQ4TQx19kaGtsbDE0zvRMlZYgxFO
	3BdvQDoxcMzkKMpso3+hbeXrVf6DnyAFuCBbEd0GSqT15Sra2UVE6SQwfrdChSenieJPOb
	HMArUfmIrLSRwjpeomB6cwY+zqyU5t0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KGV7L4nj;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778057910; a=rsa-sha256;
	cv=none;
	b=A6/qJcURGIho/5EtYnm1pr9F2bIoKAIPtU7rBVCMSLUGXy0E2zVp0cXpltYKSctdGVmhgg
	eEyWJJRPQJaKzSjTjdQa7xDB6ON/WuDJK1ylLRHo/j0mYWXMzBP1TxU0jv5JsOUZNdKImc
	jCXJMxJGsl/EBwtBiVVX7pTUUdbVgJA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778057903; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4AiSvNvcTpa2TKyw35vaQTKtLcmTvDROixEkAC62Qps=;
	b=KGV7L4nj1uEAGxgRlYZZCMkXl+iAuiWbnsnTLOGV3UpWQHWJpZi4GAcbqalUvI5CvwpOXpbQe5Zh4pg2RhTFQ/0NxEjAs7yfENHsuBJMssln9TcVoAOQ7KbtWWqFrmtjgAwR2dKI78OKXKoLR4lsRgByqesLF+oMAa61RyQuqnI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X2NxPMH_1778057900;
Received: from 30.221.149.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2NxPMH_1778057900 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 16:58:21 +0800
Message-ID: <b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
Date: Wed, 6 May 2026 16:58:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org,
 ziy@nvidia.com, david@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
 <afnKLEIaUd5A22ls@lucifer> <afnKpTo4cwh9LtPU@lucifer>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <afnKpTo4cwh9LtPU@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23FF24000D
X-Stat-Signature: iqn86kxsq8foqz4xz6ufjtkieugpxqew
X-HE-Tag: 1778057907-373492
X-HE-Meta: U2FsdGVkX183NBaELhL/YlvMU5pmTu/YVTbkxfr8uzXi3zzJIk4pUVgmN3vtdKgryW7Map2RutI13RLk+6YUAE94Tq8DjEjEA+75HeDO8NeQHadkffFrn2JjeQBasaSB7dzMNGoVW/hLVtSjD4HJ2Y64q1d6GxmepNkL5aCnoHOWhRRipF5Quv4gEkavvc/BlwL0D2vjKR4SQkKjeaf0WXvMK/reRAcUgg2r1oSOq0fhWZ9vJygwYKTdIru+Z56dkIg1TsUPTiRsvzT5CGTOzBbWegy264LsbXHH7wZoFVptdx5668L+xERcvDKwTRbVY6hLat/mUSj/o/uwUx2HriTyVbEyS8kKk2QabTOVK16FMPGO/ccQ9jHnKqJ4Amxop0bvBf67ybk3HjnYuHe1xaH0yhhSR5kO5GTCNoVtf6sUL2au/9tMUF5/q5BgFE9a7RTLxOwRYzhRUjAb51JC+LP941PrsBgrY4Ri84zXXa4me0RA0JlaV1hOvl843l+C3UjYHH+5gd9hkHwrjH07MziPlfIWyzgA8akXZOkYWby+aaUxg/gP+oOwYyzwGiU+iNhtMl8A3+vv+uF4yyQdxCUZOI7JHKAJGF86neXWBCF2Ag3Cc7LWSTeUa/UhcfAYHOPrTweu5zM/8aFJxgZpMhmFKcFISrmHWt7lGRwTZnM9i2gye7S1QsGPhXkOtjw/FOzkR2X7G9SGbrAh+4ddOkufexqHVpdzpzad2YLUbOy/ACBsLTVz3UmuUCEjQoQ3CX0OorJc7BFLskb5TxE6cMpKF5yikhHNypLZcHI7pK6Sy0VaEFYtJSgLNV0vaJANsUZu/Yv8iKYAYT6sMTD1pVDdjPNkkHGSk7Q5WeTot9Ra5FY7NtVRETbH5oTTSPlm7n3raJUIOFTSV/mBBjIPDsfMVZDmVlQABwZ1DjWwExjTUfpitoAXJBxgmpkeIitRR/pQZ0Isvm/lWDNWxhv
 EfCGdbEQ
 hmAnLEKW7b/w4Cl5ktSc5PzCPZdnExxiiZyX2ZO+rKfjph4LjGS+QpgGJlcBxogcR4wp/Yma+L2qNM7tu/Ojw7q0bnasCCB6EXi6NJ0h8PStxG1pbCAOLbsKj89E/lBi0MRCOci1p8QV6p3NClNCb+hmnvTqFCC5phfoZRktAKGCIRO0p023DO1gYI3KeN/2gHKic0AWjHkvQbyV+FKLsrUpJ9sHdO4VkUd9N3EVywd81d2wvCCzBXDieR1dR9avjfOtqYaHjgbOdIfPJ4JThYMaxsMW/QGWkeJtcrZnitExn2t5WEqGonNvQeKsK38HSR9rdzI7s3d2tWvb7BxyGOoy6sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/5/26 6:47 PM, Lorenzo Stoakes wrote:
> On Tue, May 05, 2026 at 11:46:11AM +0100, Lorenzo Stoakes wrote:
>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>>
>> As David asked, should we have a Fixes tag? What about cc: stable?

Sure. But this fix tag depends on the commit 665575cff098b, so the fixes 
tag should be:

Fixes: 5a90c155defa ("tmpfs: don't enable large folios if not supported")
Depends-on: 665575cff098b ("filemap: move prefaulting out of hot write 
path").

I don't think we need to cc stable, as it doesn't appear to cause any 
serious issues currently.

