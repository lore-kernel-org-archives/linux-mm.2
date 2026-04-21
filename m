Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6E8F327CD
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D0C6B0088; Tue, 21 Apr 2026 05:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094866B0089; Tue, 21 Apr 2026 05:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5296B008A; Tue, 21 Apr 2026 05:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8A2B6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:26:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1689D13C220
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:26:03 +0000 (UTC)
X-FDA: 84682031406.30.A62A7D9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0EA9B10000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:26:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SD3D3SKU;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzaoaMrVPuNqytuMUronCSujODBOvvcOBPL0ZtXO8I8=;
	b=VfUigwTMlBfsT0Qw8+FjCqI1GWtUPQo+ku2zFdzhAvhzZGTsprbtgHNv7GJRRNXeQyZtsv
	tb9BRZH95ObtthlotUaHOC9LaP9owGZH+iNYugnYynPvZyAv2ezf9esdxjwFMbhP7OXgLQ
	MdFPBwRFhF5JegvFEOb8yAlA8ZbX8do=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763561; a=rsa-sha256;
	cv=none;
	b=OIwHnQRwWnxff8PjApUJSbJjq+n7/ofuPSmE2ey1DHhqvC19L6XyRsSBn8zeV2FAhmOeqH
	rnVpxeIF70Z8Htln1ao5UJ/DDzG+6Bmt4mGQBW/1NGZgDDQWFd4dptMPCKYTtVPrs35Lo4
	xbqAtsSAuJJqrGFBKScbvHorEct/eq4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SD3D3SKU;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <af74eb8c-b45f-475c-aa27-7bf067b9a438@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776763558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzaoaMrVPuNqytuMUronCSujODBOvvcOBPL0ZtXO8I8=;
	b=SD3D3SKUPgIj+qrhNP8UR11PcWh6kw6SdyuhxhuNn0ebQLCWAqlwY98c9XHwiFysnJ8hWq
	45aWzk4gKq8Ql94lOUphOrMTtyvXqtK2qVDockgcF0MR/1VbwRPFuk6BFp4vpbW6rtbCme
	YA/THdxoYQ0wBEvAdX2zDNi8oZWR6cA=
Date: Tue, 21 Apr 2026 17:25:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: handle potential NULL return from
 anon_vma_name_reuse()
To: Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Ye Liu <liuye@kylinos.cn>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260421085056.26033-1-ye.liu@linux.dev>
 <aec7p15jvsw7XRHz@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aec7p15jvsw7XRHz@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: k571trx5sx915wibtauic1cqbript6pb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0EA9B10000A
X-Rspam-User: 
X-HE-Tag: 1776763560-719801
X-HE-Meta: U2FsdGVkX1/7Xan9p7/v+D1RPDv04EWCQpSw7cAKvkcSyqtg9g5uLZklMrTLOrokMO7urDPs2ny8y5Vv3NbwW9/927+am+UXtTe5dCmurAUW2KR64qwGrLuR1q4AbrOdC5dnv1UrFq20PHwzsZKk6j+j7xPHuYHcd4X1J1sugpWrn0JX12YinPNETevqW1CY7BIZSeyA/lOk79AmwoRDeI71tfQIprt6+EcdfJGNsb7O1gwjyWHF5x2PCUnbv7afxQkR3E5/3kJWkEDSJX2qLnsJCrP66VAQFXyI2EY4IWIMrQ3pNVrHIHZukbER6P5KrP1jBRxs3VSEQ+jS2TgS3mKF7K2Gwaph7owqgdNGrGWCyOcZs7061mBi9tg4mg8wNwvWGY6FktQbD7AdPqtFMokLCk7nHe8mHWqN0uIsc4gq8IDvp72FYLtsYoZBMq+RemyS5lStAe4x/O4a/WdXk5gNJDkHUj48Tq5Nhdon2p8W3pQrCuQOyzO6K2Y3aO6YFdxJeGTPupQ8YX0NQjwHv34zE4oqBVjm41MLF2LqtMrh6DuKcdHlymZXZrU+P94BLiWVztS24SoqfHzhFmPv6YV+aZgqd1Mvn7O95rCfaXZaa/18Gzq+LITDEvp7ktYpDdVJlSEdMSnZEIcUD50z9JZUgYCM4lcwpnSwkbGlmX6x0i7lAuRaPDs3CcCRDpv1XU8YXL+oHQ14ZGbPQeDZdyCblN5MOs9EfzyB9VdCcFEHgEUhqG6DHTtDK7MragN7Fsu5LhWKGBt7gMiiKuzUaGD8kfRoZix1/1Fm7Bx9tBW/FXiDc6wiKT4rjQnm7v9Qxav0jKD+JImW57vX5pYbifYlSmO83HiFhMIMFSlx85pU+7Q+Hl4xxtlcDq5AgY4JVfx7nust4APbNzlzK4094CqkGOhL65/ygKG8qwoHr6GfDYrVvGio2Ck9fcpPITYzbT5cf8kBiGngLyJtdi5
 xmQ4RDBP
 1uz+rSMERwUch2VP1R6VdCJkznu8whDRrjKXwEMcQXT3NIpDvz6f8hKZig48e4dL1ZG4hEL705XjJUoMBfKo4/aV0jFcgxwW5LoxlFbaVLYVxj6DN8LJXH3cOe5Ch0LNaDEhEzXkYr2Clp5VAmockJNzA4m3XBROU4Ps/Z6EhnPiqEZleDZeUfzahsCzy/LBQSlKocopo3gso7p39XMKwClSxEkcY4ZrTalyRf7wACYXDoxF/SblCi+C5Oa6v2YMBmA4fDI5edGuFD3zfzN3DXyfsGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/21 17:08, Lorenzo Stoakes 写道:
> NAK, expected allocation failures (even if practically impossible) should not
> cause arbitrary kernel warnings.

Thank you both for the thorough review and explanation.                    
                                                                           
You are absolutely right. I mistakenly assumed that leaving vma->anon_name 
as NULL could lead to a NULL pointer dereference in some path, but as you  
pointed out, the code is designed to treat NULL as "no name", which is     
perfectly valid.                                                           
                                                                           
I also acknowledge that adding a WARN_ON_ONCE in an allocation failure path
is incorrect and harmful under memory pressure.                            
                                                                           
Please disregard this patch. I've learned a valuable lesson about error    
handling in cosmetic features.                                             
                                                                           
Thank you again for the guidance.                                          

-- 
Thanks,
Ye Liu


