Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF146C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 05:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1C76B007B; Wed,  5 Aug 2026 01:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A15B6B0088; Wed,  5 Aug 2026 01:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591906B008A; Wed,  5 Aug 2026 01:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7586B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:08:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7299F120397
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:08:33 +0000 (UTC)
X-FDA: 85066035306.20.1D31583
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC8BAC0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:08:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hVaPeepD;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785906510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfmGVJYDjHG8Bx3n3lJMYrb3YO2SUPHgSw85tuZPRNY=;
	b=Pm58yfHCqZPSJ9xxU81dfOu4L5HSKG0Q6LHQhPvrfklxWlueBIySKzHQ86OXdfL7CG5FTB
	FXUyTZ8LKmnmfc1NBEpUPYelbEihzMzLLfX5+swV+OG+xzr7kCnhBItpEi+W2Kxjtwyg9S
	gc/wHP2CbDr4CCqD8NWAD0i0LDp0mFg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hVaPeepD;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785906510;
	b=8fDmPhC23R4zaH60qwJj2isA4PZxDZotCC7FlsVjlS022eJDTuBFGuV1PiNseupZ9Epkut
	nhJR1kxC77KNVGmZwAugxpvx6mH/JcDdmKfRgxd5TWwQmhVAZixlJOyvAA1OS/C0Tzi67a
	ZeAPepClfN2dFc34zKStQm8dtaQKBEM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785906502; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZfmGVJYDjHG8Bx3n3lJMYrb3YO2SUPHgSw85tuZPRNY=;
	b=hVaPeepDT+DYEEtOT603Wcr8ZyUD2GhSvqu3gd+uOAlaU2W+gQfB+IYdLfUIkGr4p5VE8FDfP51FUsArrm0j0JH8lGz3Nl8C//qKbL5X7jwuGhvovT1olbWV05xNyRdhTWcjWrfjt6Ga3Rl3kqw1gH95lxATCjKAvSxCXKqs4wk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8Q7OyQ_1785906498;
Received: from 30.74.144.139(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8Q7OyQ_1785906498 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 13:08:19 +0800
Message-ID: <dea2b5f8-7dd5-4b16-80c7-eee646a1c16a@linux.alibaba.com>
Date: Wed, 5 Aug 2026 13:08:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] add anon mTHP collapse test cases
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, liam@infradead.org, dev.jain@arm.com, ryan.roberts@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <178587592371.79283.16750931617435580186.b4-review@b4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <178587592371.79283.16750931617435580186.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bz4ttijs1c7hj13gshdwet1n79hmptq9
X-Rspamd-Queue-Id: DC8BAC0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785906507-734681
X-HE-Meta: U2FsdGVkX18V2pIEkbYlS61pCnNhFauMB3s9kRxKmggD3i+PhgevV8g3b9JziEvSGaDBx9rXoTPdFUqaA+NeNHyQfT/hXTbubKDzxKULfLO4HXE0SY21GZEE4HSYwQIJvsYQiNnE5NvckJPJNuKrlhcGhYUFrsV50Wot86zf7iqFfRAg9zEdbnaHJZBpi+ByPJvxY2K2tlM/XJFHVIuceXEwNE7GDEqQ1sP/dVKgPh6vZC38YImImPk7S0nQ4sMxzVvzWin93aQuM2FR75xpd9106ZeS1ILoMgEPLe3bExKVPVQBxyn47odrf3jkCskRYCx6Ur18rKniwzP0Ds2ErBz3I55mcv80IOUFJXabrQ+pOhQ10NDAgdHuzie0yB5Ho1DEsW3AzpLhC6bEzbtzyOGGIIWTY8kfL2uzYbUlDZ7jYmHgyv+qCh4xjKZxCG2WxDE+qNaMbJvhBxVZ1jwPuSKgpy6gqY//53qYVo7wyl3mKyrn86+RCH2aIqhpKxeJvnqXon8kUd88fytcSDTtjxoBJ2QO9sCo+ZCzgOh94tiPl2CD24rdlU23Kt9FVKrYuZJUGMz5XPOCLUjy7hnNwaB0YvMrFVlkTreMjjuwKo3eJhOengDlrzF9LtW7XxhkZkHKzC8Eh2Pd7YhKnUHSxpcCu1SqYPTH84GUGkT9DKOC6M45pm5quRtRfD/KBFF3hi0ZXWCGHZLkFanBqHOyl9J08AX9TrQ1syccAnivaPhyusa6blWnHlG3+oPa3GHgy0Ct/T81noU3xPh9KQrPtKEW1K9UEIX/LKUh1tNj3/ah0sWDux4+ohskAPDiWCxbSUmahRqua0FoDLdOlWO6SuUkSnxosHF/lxMVvNP3FZ9KFGNg3hejiSxUQSiltn8cXQxs+NVA/+PmQ0DkzFHggRFePx1t3chhvD2Pst0pKJbaLGFvtXRbRITe8xRx7ydqz2neY69HYXmoMl7ZFWp
 w7uK2D+Y
 PqRwLcJHeKveCcFiFMeu3pDoZCvHj6z8it562YSCAmNgqSf/eTZc/7Otfv4b8He3rT/O4KFt7X2bDRhIMcjPxetsDwIKjd9YZVoagzhSATKmr8fa7JiDAOqBrbVoA64BJjFyxNZN/X8AFumm+2QIM6ncNpYt3P15HpMoxXU8drLJsLcSqJOi+piQSCvIkhO+tQy+vZ9qf0j3rSnsQVzdgksOz3Q6mXiFBHY8AasqtBI2PJVYynq4jN7KdTi/DsIiBpd3w+wpcp1O+IIbqE6L/2GtNduys2HrCg4sHGiKRep5tk/M3rpbuyZA6AuggSHarW5hn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/26 4:38 AM, Nico Pache (Red Hat) wrote:
>> This patchset is split from the previous shmem mTHP collapse patchset[1],
>> which only adds anon mTHP collapse selftests. All khugepaged test cases
>> can pass.
> 
> Thank you for sending this out :) I played around with it and it seems
> to be working. This lays good groundwork to expand khugepaged mTHP testing
> in the future too.
> 
> Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Thanks Nico :)


