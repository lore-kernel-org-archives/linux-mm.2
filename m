Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14297F01826
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67AB96B0089; Fri,  6 Mar 2026 05:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628186B008C; Fri,  6 Mar 2026 05:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EA96B0092; Fri,  6 Mar 2026 05:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4758D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:52:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E46A013B0BF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:52:20 +0000 (UTC)
X-FDA: 84515324040.18.04CA944
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0530140005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:52:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hruPX1va;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772794339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n28OOmT0dysIuHKBAgUVdyHn1XpIpPb4AQfanb1Mupw=;
	b=gKmIIgh3KjX1O59+q5rrSDbC63qIXwclNs7R8LxGUWKrt296Tps3fvA5FQlSUOXaJ5znRm
	p0eOy9QCEl/Zdbu6tUN9/3RTb0Ow2pOcYTd2BF+xYh3l7z+VguiJqAC27YdZ6nnV8uG2+3
	lJuSd9y3/bqEJS5tQCrSvgeQki/I7uM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hruPX1va;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772794339; a=rsa-sha256;
	cv=none;
	b=t2ARpk1O8xerNeF8an9OPd15arD74YisuCA/PA19jGvNQ4m/lOcX6gs0hVwm7LVxex4Q3U
	Ohqfsf/kKnFmLq3k1p1VM/Hf3SxQ/fNR61LoE63PaT3ps0PZwQJTnbDpPPS/ZOnls97/o+
	oyFCqQ1EbXKL5ByFnnTFUX/zFURb03Y=
Message-ID: <9008c7bb-f312-4a9f-a471-568575519d08@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772794337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n28OOmT0dysIuHKBAgUVdyHn1XpIpPb4AQfanb1Mupw=;
	b=hruPX1vaV5b3TUivNO8aCAVwQs2eLWNc8SoppNpNlo6spHYFvXo3orEGenyPMlPMW7wxYd
	pibIn4LMZoosNzSZPSRsBbg5pnjjxNafSqvpvFww1xowrKiJ6wdDotIu1jXOQ7q4CmjPOa
	nM/BU/yWBdhJ95j9O5U0+D5sDWYmlh4=
Date: Fri, 6 Mar 2026 13:51:52 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Content-Language: en-GB
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, matthew.brost@intel.com,
 npache@redhat.com, david@kernel.org, Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
 <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
 <CDBCA254-3E40-4BFE-81DE-70DAC9D4222D@nvidia.com>
 <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
 <ee77cb18-3ca2-4f2b-a1f8-1083b1a9e879@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ee77cb18-3ca2-4f2b-a1f8-1083b1a9e879@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0530140005
X-Rspamd-Server: rspam07
X-Stat-Signature: d8xuzd3ohg3bbuzj3smehbb4cmdqd6om
X-Rspam-User: 
X-HE-Tag: 1772794338-642550
X-HE-Meta: U2FsdGVkX1+UBeDILo7wFhYlLHS/ZCItsgO0BsEEEDRddOj+hPgXpQXGAUhKDIm9wNPr1c1WlnD+B2WqaRoXQYnLf0x34H3gcjVnsFHsdJAKtTqPCUwOJ3Oo6UhSypz4HZcK5jtw0vHQMR/uShnNgfyYlMLsIvrA5MmZDuO6rNjyox+Ery1LDMHvoNlx2WB0Yd3VMKySWrD6o0ppoxV7YmE1+qrX8vlg3iOv37RjiO2JsHeZdnXB71M3csUgwO9mMeYXUhAr9zfhNSo8WtBz+BzKnPFpCTU4kwPgI0VuVqfpl5yvQYre3z84wkPYhgortyX/UYh4qrj5somUvgCNfRX5kJ3BSzZTxKJqOEfdhvFe5b7xNEbJLNOi7fc6qSAPrbyz9H4l+XUMzCXTUdmYFdmDyXhBx0BCk8FzOc4BC89rteH1rxbODBmh1SKOanO7nNumqnDHZ30RIsbhO9pp8d6shKqJ8OqafXJm2Nr4iH1LdELGWPgtHHNLnrti+OVWfzKs43iCGQfIFiqZkYxyAKgoE1lAgfqO+OLDZdfcXL8pMHZAwPaVZG8F2U44mfldaACt5OCma055KR143GxTRhp9KtDKQMpkp871fZgbrI2feUeMACzQZep8auSzQgD9DCHw8N4/XsJRhWh+GC9tmxDXMNHi7HygWkVaKC0EPKuZ/mVPRhMpI05lmp0DNvyuFE6VNPoMEbii4jGzkh+LSKcibK71a7YS6s7J/DMQ0uKj34RXazNPWqIR3fzORSMjqmegcGCKqefCPsygj40/WBxEDUq3wVDmrhaxUHhuLUHj6xigmxkDHU2emi8G/CMeL3kpEBpd637YHkbFJgTkRHq8GfnqD5eUM2v4gNVwv1NTx1WMJr6Iqi5DexyeXPGETQvmIGtRBmDoBnGLf9sbRJRSdAndxZ1v9SusjKjLQW6Y9LL8btoU/YYXoSqPsnG4GBFRWOmjzunOYjWk0zc
 /6joclKJ
 BjrQiHSjZdE8NwxY5YISOanntZS5KPvK46dMv3jGXMvCr+HAE69CNZBoEptZO21tUwPKmWFPadXyeDyW6zjrSbuHb6TQHXTfXHQB1om1TSQVn9L6o9Bvuv+mZLXIgZ+TORHLBcoTcrN/7aIMqV56Q0HE1F8uJinaXUqPneG36j5BffZS3ecUUd0N+hnVPZXWb/IyqxvbPTILYDPHy62XQo8d22dXh3ovyyC6bk/VESJ1z7tWeFiXCJgq+WzxZcGZGiWf82pX1q8bMvVrk01WueHAqY8G12Yuc0b9pgqfkhkVR1SIZqZuJo5RQ2cC1+24/OsgJMsqQ2oxKUw45yoBFIFfpc1WJMZdsiM8K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




> 
> @Usama have you figured out where the original issue you are seeing stems from?
> 

There was no issue or bug report. split_huge_pmd_address currently cannot fail.
I am making lazy page table allocation work [1], which would allow it to fail.
One of the review comments was if I need a folio_put if split_huge_pmd_address
fails. Its not needed if folio_split_unmapped fails, but is needed if
split_huge_pmd_address fails [2]. Actually it would be very nice if you could
review the patch in [1], as its modifying the code you wrote!

Thanks!

[1] https://lore.kernel.org/all/20260226113233.3987674-13-usama.arif@linux.dev/
[2] https://lore.kernel.org/all/6982e9fc-cc17-4d4f-b26e-83997c4bf070@linux.dev/

> Balbir
> 
> 


