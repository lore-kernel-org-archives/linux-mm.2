Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5995FC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9ED6B009B; Tue, 22 Sep 2026 08:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B6A6B009D; Tue, 22 Sep 2026 08:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459C06B00B2; Tue, 22 Sep 2026 08:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 257886B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:55:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DB61A04B5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:54:59 +0000 (UTC)
X-FDA: 85241393118.30.ED91C57
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15C2A2000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:54:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4Z4+Hko;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkgH+ro7+wbDdoQrg8BtY3ruF9+iovRZJlYnC4aEjPE=;
	b=rJhar7dxcx5YX4lhwmpi8nz3Fa40Azu2TwSgfp1CGp1uAHgeRXY52eN8BB1mU3Ss0Gtvrt
	z/mKbyh/TQ0gobnvqX4GafI+gXUGm9IfQRSEJ5v2h808cqsQolOQVXyi4yQuv75DIY0xbu
	nIC9h+z3r/Fn6savS4xLy3iNHWISIA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081697;
	b=kk887CVJ950sNen9Q1i7X4nMU2GHD0PltvrIh4+87o+gsHuPS3c+wO6vD9KpIoCMwPuzrA
	uehBHMlVYP992dVB7jEiqPQv7VjGLP20JoqPHdULnhldzVir/+whhqxCug11gEIVBSjAjW
	ytr+f8/+HSSKo8I8PzXQ7PeH05YiPyE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4Z4+Hko;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FFxHiQYcjgILl+Zqr38rhbNvEsrzzjIqXE46oCelFqg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790081695; v=1; x=1790686495;
 b=X4Z4+HkoL/GUjapbPGa6pyqQyIgNql7/xCdBdGDhzNdJ2YVOJ297ziJJCzb29YUrCo9C5q2k
 QJCCpTkZo92VxAEG/8vEwggGsn/yVMAIXJ8Bsnp5QJx5xCAuFyKEBqYcteBJBM2/axzq6kbjlix
 yqPK1R5natYWXCjhgwPDCV7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84d8d0402c82fe38;
	Tue, 22 Sep 2026 12:54:55 +0000
X-Mizu-Trace-ID: 84d8d0402c82fe38
X-Migadu-Flow: FLOW_OUT
Message-ID: <4659ea28-19fc-45ee-804e-1cc7091f4bbd@linux.dev>
Date: Tue, 22 Sep 2026 13:54:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 07/29] x86: mm: add PMD swap-exclusive helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-8-usama.arif@linux.dev>
 <0df7e349-9d11-461f-8b8b-68bbddbe1f3d@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <0df7e349-9d11-461f-8b8b-68bbddbe1f3d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15C2A2000D
X-Stat-Signature: 83bakta1g9z6sb8mpu6i4uk8djkzsqy9
X-HE-Tag: 1790081696-483683
X-HE-Meta: U2FsdGVkX199AclQiHLBmth22IEufinxyKR8sjFKGGo/dXH1shMOxWaz4TROn3ALuC+rPzt/eURWZy0RLe/RtTZIPTg59z8jy2ImxNSDEcc+D40xeB9oSt1JZHwkH4IpGDDZZHdzfnSc2e0BfsQLqL5x8UlypFtn4GG4N7GT2J5L4FhYsgvz0Lgc+weDhB5JJi6bpETVYn0+RG88WFyvBuwsZ20vk3VKWTOkzp/buR1ohS42i/JpWJKoQ4Hj8uF/JvRKHy9XSvcDLqSw+B99ewQjE86UUcMirtvfkBoMU4iUZE+Dg8REdnSIDQuPRsAbiahSeGLAcENjledtry9RV4o3p3XGnkWWiWXGccVZ0JmSu+BR31zn1jx9AJAzcJhhj89UxYSFaoZel9SW7lOunEog+M4fJ+rOm9Wbe96nMTqq9+JhviSCLkqdmJ9ymPu336inZAe7wP9gx6Ru2OKYvF54hDO5LCNUwskzp+5hUxVvCvRVGo4x+Zjwy0/i5oAETRv9NziS+srZSqOUpZmBkynP1jOHGRb1BnoX0FL6ttUFWwpk8B1evDUthzmaUkVAHzC/TVWugWL0Em2bLSze8CHaD4tPSf8152CQ4H503CyXHaMpUgDvnCwJfQt2Wp5VkFWCfsf3MUwp/5UvIb8qHrl5DaFu1XNz8a6ZbaAu2dzLGpdYQQHGffDT7n0Cpfo6hBvHevuMlVIHU1K/jea5DI+WKa7aE9+PShY5hZ9fyLf4mjmNAur3sGiPcFCNxF8vT3QHSimpX2lZKUNp+xadM4JMgYxG1KhB7W63L4Um61cRcW7AXNAfSmFGkPJwKNcwUAE+7kdRRcFJTw+6tUCAMJ7WftBSKDNoHcFo+z0qv/WkroBTFe5Ph5drm2FeftsbDHovxS0ZVwRJS7RD62hcE5joHti4rztwJQkHZHN06o/OvJ3EqYnU9c9thrrndPJMZ1ViV/JhtcmDIfaPLNj
 gpKTOXaH
 ygSvNAE7ZhOPtW4HKGWKitueJ+qSWr4+aZUWqESoPmclI1wf+x27NxXGBcu3UJOdRHWI6BCrvmOjbZLQW853sW6xdn/QHGDIZf64HKLNn58O4sjgMoCU9r4gkEO+LzJVhB9BSVuXEMy0UEKvXkAHtF8nG+X8MB8CxWy77ah8AVakqPihe/QpWxUzXR+X7FJ3bu88NrBBmuTkGRc+K+NTUYWVh6eqroO4K3P7f6bNrycuEdIf40/e8MfRGYF4ijyEPhR6CNVil9o14O1Xlq5dl/W9XMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 22:43, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:27, Usama Arif wrote:
>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> 
> As a general note, we try not to talk about "this patch" or "later patches".
> 
> Instead, just say "Prepare for X by doing Y.".
Ack, I have started all these patches with "Prepare for keeping a PMD-mapped
anonymous THP mapped by a PMD across the swap round-trip..."

