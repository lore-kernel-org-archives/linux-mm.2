Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22493C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A126B0088; Wed,  8 Jul 2026 20:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B022C6B008A; Wed,  8 Jul 2026 20:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A956B008C; Wed,  8 Jul 2026 20:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B49B6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:56:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F37621402FF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:56:35 +0000 (UTC)
X-FDA: 84967422750.28.C550938
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id DAA8320003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:56:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ReY8dtSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783558594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW4SY9Z/tGn1IPNVvL7G7PC98wn1mtgzpnrzSAfXEx4=;
	b=mO377cpzHfMm7AHmujOqWXNZDwUhXazSc1j5EqFDgzfxjSSMUSH6dvFzA/pAZ4pGQzk/Ep
	xLTShjceWkbIvktVdTn8P7QCM/t4mjZBLCiYKQlKxV1eCIrLhfzi7SA4dFVG521jnPxmTX
	ktnPWptXV1PXxU0xKijdU35cKh/y3eg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ReY8dtSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783558594;
	b=QYeqW5wl6hfd8RzD+LraMuwIklCCpdsC6J3PoWhe4F08k2vdtnP/O6ABKKrgbhPIPeJPNu
	/R14NYGTptkeckgFu5IiVny87oPsMJPD2AvjbqbEDwip+KCw5nxlD9iTLANbzMxwcNYhWQ
	ptuNNgDYrYZ/om0CdPbvqZCr3mX0Zak=
Message-ID: <8f74de0a-4c86-4da9-ad1b-3f496d3ab733@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783558592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QW4SY9Z/tGn1IPNVvL7G7PC98wn1mtgzpnrzSAfXEx4=;
	b=ReY8dtSCkspGxZ1EJpSTPWaK+F/2B5C0ODBysqxbKXH+vvH+AXFB3TW5zeIYMmj/NyL39w
	CBqzyLzl3gk3EQwZ0T+11DIsHmqRSwXb39b6NBJDiylvSESTKetbLGFFawc4ezjrrNlK/m
	nvdf44pCn4oHTkdIL2vpmZjbpDcZJTI=
Date: Thu, 9 Jul 2026 08:56:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5.15.y 6.1.y 6.6.y 1/1] mm/vmscan: flush deferred TLB
 before freeing large folios
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
 linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com, yingfu.zhou@shopee.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, Huang Ying
 <ying.huang@intel.com>, linux-kernel@vger.kernel.org
References: <20260708041237.289026-2-jiayuan.chen@linux.dev>
 <20260708120502.agent5-0002@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260708120502.agent5-0002@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jbpp7mx6mr1gtc3qj96ybzp6sxk39k73
X-Rspamd-Queue-Id: DAA8320003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783558593-8374
X-HE-Meta: U2FsdGVkX18WRFHkR3yw8T0iuSukPpvCShvAzheKrTsJVrw5xBWjaVh2xZjDhZQHqO7jnuLHsvdmFokmkdABXfsXU8pcjZrOV7CCqUwLmvR4fZwT7KQ9RWrIVsun7Bq0fbzSaIZbjTUPoNe8XqcjDC9sYven+eHPVtmUp9pksQsE/dS3E1utBbNMOx2j8Ia0IJmos9tVQeMoI17WbSexlJhe8Jhi3MxKIyUGJAJDL0l4ES/ffcdyHKcnUou95pZJoiaD+FpqXNyzbAiHWnuli1tbD0sK4SXw/3qvG8jfzGM3V5Cn2CPlh7BLIo5XfQODho4aRplrNsC1m2J+S6YQM4j1xFwXc2I8CsiVVeeeCXfSCSG5XEtjD80swtV2czpNIoIeMtEH7CZfYLbQGojAedUVt6eOVdhx7uKfpop83/Ywj/YmUrEgFnJlI0F0VmGgZkN2vrF1YiWfv1lOdNRcUbXmN8H0s9LaIe3TtHpE9R3aInIRRnPpcEXSQXYfCUXKA64jq1T3TcSHD9ZVBxVTG91I6URa4DJI0jsKBTySc78sLpyMFWjyIkcqtscYfO2bNznHeFA1cCpiymN0OLLk4X9lJ4J55sJf8LSC6sf34iPuxSB9szRy2vOVll/ClZF5yBNJ0Rvuq0uMom5wOm13zOS3/D8L0kLRSCI6xvZgHHvymfHrwph59Rq50jxH4RM0e10Jt7md5phh6KpoqyAV5upTxq8aMLFAkLY05nMQE0PX7Sy2BKDUIBWzeMXTB7dDvrFKd+xoVz9jHoFKRMIIz4/3BbBlkrGlksKFkHC/uOLxGAl3h6PC+I6pVc1Q2bZ28HZ8yNOp2xH1sKKV3Gl13TI9a9Rw/7hVBZR+dqEDqCmiYKH20QagPxqDz7Y4bWF2UMyJC4fJKoSY/9MvP6MsHgzE3UKYTMzLvZRWuiL3Q/FW4AdkIaM8PovuRiz2wCEUq+X53utLdfD+6N2JJI/
 soTQyKnX
 5ru6O2GFdGbsc6eh26Qk6Cd62AbWD44sIIDjQVs43XVuMlnv3LQkNp6DW92tp5LH9dkTu7qYWkinznOj6b34b+yQhTiL/fSDhmBlrYO8Jeitlgc/UsLgHl1Z03p8i6Dr+4TVdDFLLFaQ72cgSEnE0rMISEU/mSKzlIVH3QBZa0fW1Vs+BYK5hMn9nLlsIj/771m5vt4DvaGCgWsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/9/26 12:18 AM, Sasha Levin wrote:
> On Wed, Jul 08, 2026 at 12:12:36PM +0800, Jiayuan Chen wrote:
>> Flush the deferred batch before freeing a large folio inline, the same way
>> the order-0 path already waits for the flush.
> Queued for 6.6 and 6.1 with Matthew's Reviewed-by added, thanks.


Thanks Sasha.


>> destroy_compound_page was recently renamed to destroy_large_folio.
>> So it would be conflict when this patch was applied to 5.15/6.1
> It actually applied cleanly to the current 6.1.y (that tree already
> uses folio_test_large()/destroy_large_folio() there), but it does not
> apply to 5.15.y, which is still page-based
> (PageTransHuge()/destroy_compound_page()). Could you send a tested
> per-branch version for 5.15.y? 5.10.y has the identical vulnerable code
> shape, so a 5.10.y version would be welcome as well.


I will try to reproduce and fix in 5.15 and 5.10.


