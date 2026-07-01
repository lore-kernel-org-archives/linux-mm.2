Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F06C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F49D6B00A6; Wed,  1 Jul 2026 06:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCCE6B00A8; Wed,  1 Jul 2026 06:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4446B00A9; Wed,  1 Jul 2026 06:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 577D76B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:44:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C8091C6D9D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:44:42 +0000 (UTC)
X-FDA: 84939874404.20.065AD09
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F360180003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:44:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AMWpoDHi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782902680;
	b=PfoAU/8ZtDirsUAfTFyRj/gSX3cl6SSFkYQu7xHlHf5rhIyRe4ZamITgUbXhPHQU6X7AZq
	mJS/McdC5CrpHTB/NPXgpxs2Lhm4NCp9vGHNNnE5FNNqls0jawkz+iBiy9Sah0p7W0K4Us
	8yObDf6l5NSasvaamTU80iiqDoOp6v8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782902680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Atn4BT6IY+UyTIxFw+Mt5/4qpOrMMRCDyJSqbz7S8o=;
	b=ginX1pBl6+c+EQ0bWwcD4Q3TZnYgJOBmuC5xHsV2J8UvnfPYXsi1olV99eRaxZz7OWuXIi
	5ANbX1yKBoC1flKiwSwiZTqn8oCbcRVwnmcQRD/oi5oFRFcmv2GcIpp3WLmrkSlXE/tX/9
	79kLec3BVPR8joiuVYvbel2S/IQkAgs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AMWpoDHi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <8cb5ead5-bc70-4ee3-8c5a-0cf31fd9ff76@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782902677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Atn4BT6IY+UyTIxFw+Mt5/4qpOrMMRCDyJSqbz7S8o=;
	b=AMWpoDHiLIp13PkuTCiEbsqv5MWUbfc1Nct3Na3mpjq1aX86XO7zUQY14PGstixuTkYC4Z
	bPg38oIDGTcmhjNF7T3QHFyANQfOCMH7n1jDRF7pw/pNN+Ainbsx1/KeAm89DigdQTHVHx
	mJj+sb/Qc4YJsT18pDh6kXlm14F9UDM=
Date: Wed, 1 Jul 2026 11:44:33 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F360180003
X-Stat-Signature: ydgip9pkoy7oxpd7nyozw8kqqwrtc47p
X-HE-Tag: 1782902680-957967
X-HE-Meta: U2FsdGVkX1+vyZvjdEPvZxzgGmus1xdTtNiK6AK+Vm0nVkmcmZJJ1H1Sxf9lP5v9BJq3mYqGCTbTsjCwWouRV5xIm2vZjZe151Jf9Cytizlo9SWS099DRPiHLJT7pXTkccgSmJS66IDAfMmptfS397SjNO7xtdRc7xBvxlaMiHxxNYkrcA0fJlBuY1d9wGANpXsgV/09wBHY9l20PNGkRMYsdH+RQoIGbwGuH9h6XvK+pNPFEycG2QwGI0l/TRZxYfpHLed03i1sY47wrXY4S4wGhDXLLBr12TjP4m+KDDYEuqc2aAg8CJ/Sayd9pbObwUdldSqM7M83Ziofna/jX4BiwCqgBeQTNUqbae0rc8VO2gUO4fL9hI8DTN4rzaynL/+XY7B9VB88OnfZRHEDM6tUJHnJW/XSL7G6NY9J9qrYbnjb8Gb+PZlzX35QMlAdb5aCRm+BX4y3vgaFG32g1GYaxbDb1MEDbACs0s3Y42xjzJsV34psJMpktx0oYOgSSARn3hOGvfVorBdgu16Yb03r6XBp/1gGz3FL4JfAUP40YPQvl429MJf47QrTbD8NVim+9WImefuMqfmndmiVjmPPomle08byToxN92GETKAeQGrIEQXKV8nBc518pWnJgEaE+is6lq1SwgEozf4PXdCEaEU4O/VwgSKq4/w2PUQhucPqunWvoip6ehcRXMKSqjOHfSTs6sjA9wQpRXf3OmZXy9SiEDsc/1hBrtz+pUvOkr0+e6QsgYVP41S0kfUh8+WRSnM6ujHEdz9WSi4WN3NzsC3c0c/rsm3s/TEwQCZWUOe+zzHioeQZIt9MO6aooCPMdTW6aQdPsuoEsc9ilnsmsxqcz3AltIQ/7VV8DQZauqnApXu/f4ZaHu8WELc3aBIb0t9kxfKQFYYB0NucOLp20hLM3GRJ214134zjS1+QEUC7ZChkeqT+27tKfeeoRTvjrw8QsLgGVSoQk8l
 CI4hwsQ3
 vjhJkqNl3nbMIGz4kVHGKSNMmTF0A2LQFb1+5Z/PaJmcLvoEEvTHntbgmDDquFSND/6Abm/qEdAgRbGs2AJHtqRvRy8SnOITkHrROAUVHFDUETBe7zavOKXrPVmbfjuJN3ML1QHoHIF1d+JSYZFH1w+oRRSW0C8oFWNAX6NqvGqqi1mbW/LBjMozFTmF1RIW/AiR6cujlum9PI26knEIKpRbIHrJV1dDAeIpzdNVITcIwA6nGWpB/gNnwCUwQTyFlua7A6y/W3I01s0JowGCEvCE1Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/2026 20:50, Andrew Morton wrote:
> On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> This is the preparatory part of the PMD page table swapin work. 
> 
> Thanks.
> 
> This comes reasonably reviewed, so I'll queue it in mm-new.
> 
> Why?
> 
> - Human review coverage and AI review make me believe this isn't the
>   final version at all, but I do believe this is something we want in
>   7.2, and getting it under test early will help to push it along.
> 
> - Getting it in there early means that others will base their work on
>   material which will probably be upstreamed this cycle, so this gives
>   them a more accurate base against which to work.
> 
> Sashiko did find a lot to talk about, some of it pre-existing so can
> people who work on this code please take a look at
> 
> 	https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif@linux.dev
> 
> 

Thanks Andrew! I think most of the stuff sashiko pointed to is not
introduced by this series or can be ignored.

I will wait a few days and then send the PMD core series on latest
mm-new.

