Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F1BCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1A68E0005; Thu, 23 Oct 2025 03:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872DB8E0002; Thu, 23 Oct 2025 03:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761728E0005; Thu, 23 Oct 2025 03:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 619A88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:34:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 305A51299B1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:34:23 +0000 (UTC)
X-FDA: 84028566006.07.DA76848
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9639CA0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:34:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ydTan2Yqqf0jF7M32u7pmGcI//Wt1lU1AlQ2SuuqbAQ=;
	b=Faxl+2B/mAGWJWl9lOEVbVFNEcmx7qHlaYbf17O9d25Lf9nEEWCN/OOKHrpKXMBJCoJB2F
	qMEpKQl13cyX7fHwsCpzHanzknfuekLSdeGV9Lv0CDdwUARGdp71cT851VGU/Y8bDfWi9b
	1X1p41VAljG1OAToiDD46lRp1K+LXNs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761204861; a=rsa-sha256;
	cv=none;
	b=csGkacMIpjG+GH+NdNyiJZ9S0Rz+M/3Zm88+4sCdMuTjuBWDRCQQUnLnIGGkEKCHBMIrYv
	KuuVbvhS7YT3lAjZyBvCZ9HvwHNBaMFjUQlEBrpxI5QTkDcLUQR0w+VJHYY6r6wD3SofoP
	XA1JHq3VgtOFIEJaGmIFmq21g73q8Eo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4csd706lG2zYQtjn
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:33:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8C15D1A01A1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:34:12 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBHnERy2vlo6FxJBQ--.49363S3;
	Thu, 23 Oct 2025 15:34:12 +0800 (CST)
Message-ID: <f718868a-563f-41b0-bdef-b0a2a98877ce@huaweicloud.com>
Date: Thu, 23 Oct 2025 15:34:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible regression in pin_user_pages_fast() behavior after
 commit 7ac67301e82f ("ext4: enable large folio for regular file")
To: David Hildenbrand <david@redhat.com>,
 Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
References: <ebe38d8f-0b09-47b8-9503-2d8e0585672a@huaweicloud.com>
 <20251020084736.591739-1-karol.wachowski@linux.intel.com>
 <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
 <43cc7217-93bc-4ee6-99d2-83d9b26eb31a@redhat.com>
 <610d89e2-6970-4924-824b-f27a2424979b@huaweicloud.com>
 <41f30998-e498-4c33-a4b4-99b9f7339fd7@redhat.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <41f30998-e498-4c33-a4b4-99b9f7339fd7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBHnERy2vlo6FxJBQ--.49363S3
X-Coremail-Antispam: 1UD129KBjvdXoWrur4xZF17ZF17Jr43CF4UArb_yoW3ZrXE9r
	4rZr92kw1DCF4DtrZ8KFWkGrWqgFWYqF4agry7ur1rJw1DJFyfCFnrGwn7uF1Fga9rtrn0
	vrnIqF17WF9IkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbz8YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam01
X-Stat-Signature: 4y6nhqqsctjc8js7zo7nrekgrt93mu84
X-Rspam-User: 
X-Rspamd-Queue-Id: 9639CA0007
X-HE-Tag: 1761204857-349421
X-HE-Meta: U2FsdGVkX19DR/84QTCGbJ7lnmLnCOYj0agLa/dg/ZMQHALF+QSHEFpBs2s2YO9OuUp9hHzZMhq952LXI8y67gqMeGLziYm1bHPhBpHV4Obkhtr55RG7y6OM8HBqP3UxBK6R1iJpg49wQAMmAAh6XBG+cgQ1AUQEtA4Be4VJo7e9leLs7W306IrMFJ8XmZZ0B+SjbcDMi5GEAlhH5ECfrsd1pEDaZLQxI4mRCODSefFmqwRfx/KmS3OtjCJ6SB2Q9sOhs2chAJ6ZEoOtXzBHGsmMW6ZKtFfBzmJwk8gK1+qSNEN9mw1jP6/ddWTYIvlew/sYRSPI7oEtTkjMVvnd7TBuixC9lOgdeubCDe4VleImCHtxiTObo4cvpyQG01+2snExjbWHDA4QIWR02BPIm4372tFYJx6Pw7a/tM/OOvhslJ7csgeCphWMquL2Y1BaccDmxIct4aS/flkOU+H+PRzffbSyRONpFNcSYvhYlB2GsiOFKvktgMoPadWK6rNg7C/Y11uyAi67MU/0jfwG8syXBRn+1d4ro0qwKL1RMb1zGXsM2KkPo2TRHNIzbiCI2ypPku3Ykj7pHAB3Fe6KQ3ja+SLkzpqXp5vtN3MISA+tHMprRnHAA4gFmDkPQsQDiIRL7qy244z9suvvthuzzJdWqsGBIiNNyvqQNnp5KaCNTAw8eEmswqBMA+47BSnB4/+d2BudJoNSC1PUpdhlNGHGNOAoEX9H5fyEfzwkmne9xvPHZLsyfRhnMUKRzpupEIVdwsXfYrbpQgAtxvuki8k31+xHWl6nUJvbVPpZCR6jQwNyaPicJPmXrS3iY0Vy8otLkJxzp812jb9J7QZoLmOdcaSFljQCdECiv1vcPMqmRGCxgrFFslKMnirx993YT8CX45H34nyCY70Z+GUokMJlZHzRDNcx7d8lyU20bbq+exCF9TWEV82a6rRGN6WauwjFY5T5VFipTd1JIro
 oSU5A7L9
 U+gqS47A+kcZGxHTIchvnWWr/2w/T0ZyvpITcAd3a3+Jm1bmLI6M/cC0t6acJi2PnCuIGM8QGQNS3itrakhTRi1nSwm8YW3/SuzOjvVIx1vN/0e1xQ2/j5aLSwTMgBDNGAHYjPrarVt2nEzeFXWNNvYpKqzLduCbz613CEoz9kGXw/jrbfa91sbDMQEcN7CrsSg8d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/23/2025 3:24 PM, David Hildenbrand wrote:
>>> __split_huge_pmd_locked() contains that handling.
>>>
>>> We have to do that because we did not preallocate a page table we can just throw in.
>>>
>>> We could do that on this path instead: remap the PMD to be mapped by a PTE table. We'd have to preallocate a page table.
>>>
>>> That would avoid the do_pte_missing() below for such faults.
>>>
>>> that could be done later on top of this fix.
>>
>> Yeah, thank you for the explanation! I have another question, just curious.
>> Why do we have to fall back to installing the PTE table instead of creating
>> a new anonymous large folio (2M) and setting a new leaf huge PMD?
> 
> Primarily because it would waste more memory for various use cases, on a factor of 512.
> 

Ha, I got it, that makes sense! :-)

Thanks,
Yi.


