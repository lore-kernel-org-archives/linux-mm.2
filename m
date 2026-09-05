Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA55CC624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 08:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313966B0088; Sat,  5 Sep 2026 04:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB626B008A; Sat,  5 Sep 2026 04:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202BA6B008C; Sat,  5 Sep 2026 04:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 029786B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:35:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AC111C1BEC
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:35:46 +0000 (UTC)
X-FDA: 85179050292.03.24C96F0
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4237D1A0008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:35:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbThWGY7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788597344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKdcalzFfHCkzaUSjtWFIOytWPP0NothcG56Z+sOaGs=;
	b=kCvzZIDkNu4L78dkWEkOuemrwOUZeHOymWNzRJXVPAvtndBsK1blBvmdxkTq/yDeDCWKci
	gR47C1yEY62x55htBF2OHF9fsnVt3SpLhgsdsxvA8u0U6YEG6v5qI+rzfijbtpkL17jsKu
	oaQ8AvVb6pZC5vQyCJ4HpMGUYLQjX5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788597344;
	b=8V36p3uGPAjehDdM7BHhqDzMdWoqlwvv7SDfGhE9rNTcfGyyQSYQgOVoMeMTYgpjvRl4cA
	8lBWuHgLX48/VdMQ912lLU/75tb5Nfjcn6QJX8xcDbfRQYWtCV2AXWVXZgBauxFHjdBgbj
	1YxXYPlQsiKN1+HthyIWxCztPxMhDQM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbThWGY7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LhEf2lmvz3lHfnrYNvIqdGOINaYOzsSsBbuAUaDK0d4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788597342; v=1; x=1789202142;
 b=LbThWGY7vZ2/ZeASc5XjxB7t/n5IBIhy62t573WwDn998Cdl9Xz+GWCmabUqgmUtwfWd7I2P
 VDyU0oSfPoXYXDlwtS+Hb+EGYXA6QWkahXFcUIFinC5Kzfad9AsCWaWRVK8drmYK/VIIGxCDrb1
 xj14qV4pMPTrtPPbSEQTrM4M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 41100b57e1186b92;
	Sat, 05 Sep 2026 08:35:42 +0000
X-Mizu-Trace-ID: 41100b57e1186b92
X-Migadu-Flow: FLOW_OUT
Message-ID: <e3d0eaf8-a85f-48ff-96c2-dced4945b085@linux.dev>
Date: Sat, 5 Sep 2026 16:35:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mm/sparse-vmemmap: switch device DAX to shared tail
 vmemmap pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831075342.57563-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4237D1A0008
X-Stat-Signature: z3fr41g5wdmdu1rjha5ea58nc65z9ex1
X-HE-Tag: 1788597343-818200
X-HE-Meta: U2FsdGVkX18r2pyiR1sL68cyKlX7+XtI5zmjCfpgZUVqeE2jOWlZFzjMOOVFYI1ojKc0paxdutUA6jrx5JuKJZ4wvuNhdHaAt+SNXjt1fVUSwhdztnNhroaNw9oaIj0xCZ9stif/35E76tNGSKlDz55c0aeG/kbUR6k5Pko9bosytXWoD/oFKqnLRcU1FmHUU71Jh+mH0Cc2CWstAWU7Oca7N4QkWZXai1RXVIdLq2u+IL6zUP65Yp80eUrTWp0UzlO+OtL/nknc4LDst/0GgrOuB3ryD1Ytp9OLggCHK0dqN/Cnp3GQUSg6ldIgNi0VYKkd6bO4zUnVgRtKYBKSZGQXHWgBBLT8MVD9O7ZDXCn2GxD44LZ/zt6Qkz9XkFWTFh27DXSGbMJL1RmV/RhTeupTkPrfVBE8fcQiFfv6A9J74cme4eyk4+ojGJeHdAP0t6KDFNG9cQP2AO7UIrrOgd3jSvXMNB8k/Y2NXblyB8+OZRtJl8ufYDqyHgm/dCNTaDesZIvd8uA6y0QOrsRMhSf2TM4mTjEusNrlGQpXWTmPOdhb09nXlWOIMsZ+hn6Nqlfe73jt+5YZ33qm5SDGHCmStdF13dXujyyiROWhP8SkrAxz/Rwt4tH5x0NhlxD75M00W5gMk6U72eXNcssl290s83l6RKyqqzdNSKS6aX6D3nt2u7umTZX39MnqRol1f0We4rrJvV3ftLN+q7MojH3OiaHOTi22twbBu4FX0LwDCfKdDGsAwHkfmuZ63g3TYG4hUBJBo/1cI3WxxEvrb08lVp2u8GACqOt3KXygFzYo9137elMPWqb4LbxsdZ2nQ7ys73zUctpwwxlYAZ8lv+saURQN9gkR0irUIDK/uubdhWV9RQwSJzQSBX6uCJMrfbQdSQr9+9RmHT8QtG4ImUP9ScPuxAK51I04urkSnci6+SQrzmLpYuUIeyWyx8EYziaCrzRFizcdOieGt2X
 H7tJYz7K
 b1qY215Mfrur7H0EYz6YxDj8aDVGfWhyjSsjE6GlF9e6c63M02tZJ8WEoiSVQHpLmcmD3BiAX1Vbz5pYFw4cs3boy+qvzaJ1BWZ6XqnbPmhjlyCTQ/5KxFxWLiTvqk02oSmBarY07GtWauBh5PjWwdyZbo7deoHx4c8F3UcTKoYmFgSY0W36B0sF7Tam3GCDA49VuEQig+hcIxuFwbYVe9Snv6yfCPNZvrQnFy7lodlZIwqRf0aG1dEorvWldQL3hx21dMqEukfHB/i2XL2rWw8ZoRHdipn0JVMG3ccIdYspL2VgM8YvR1KTiJXhpH6HabDOCogGKDn2tGO7n+jr+eb9Knyy6KI6joG7jZkWnAjOkMx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 3:53 PM, Muchun Song wrote:
> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
> Device DAX has not been switched to that mechanism yet.
> 
> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
> with HugeTLB by using the common per-zone shared tail vmemmap page.
> 
> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,

Could you explain this in more detail?

As sashiko pointed out [1], it looks like this assumption is
problematic: dax_folio_reset_order() may end up modifying all shared
tail pages?

[1]. 
https://sashiko.dev/#/patchset/20260831075342.57563-1-songmuchun%40bytedance.com

> initialize its entries with PG_reserved for device zones. Also skip
> poisoning vmemmap-optimizable sections while their struct pages may be
> shared.
> 

