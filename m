Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3F4C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9426E6B007B; Wed,  5 Aug 2026 21:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ABB6B008A; Wed,  5 Aug 2026 21:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859AD6B0092; Wed,  5 Aug 2026 21:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29B6C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:17:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17F7FC062B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:17:56 +0000 (UTC)
X-FDA: 85069082952.26.1210E65
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB8E910000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:17:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IGG/OvtN";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785979074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++OVII9rPRuLo9kRAA6sts8kg/2BfkQm7kIApCaZIdA=;
	b=pCWybp1+Ly9ZoLm3kpefUmsDs2gynvwGSPdSt2HxQOQQ1tZPwBvdRXgQ+smiu6zA9SbXNY
	fUoHh1cGxTP441t9A9ARQQbmNKbN1bFycvXXXunUWZks7KJzmCFxZceWy+goxeqXOCWrY+
	ux+sQHntM6SAY17x2hQC30D60s0ff0M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IGG/OvtN";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785979074;
	b=ylawo5lwcK8fNvPIRQNubqqacxA5J0UpOwQ0IPb2izkHcaOHR0k5zzf8q2xcMqtiARrSr2
	I9/P4WtMExJJZkI4s7XUl/b+em5+ffzfiHNbmc4NZnRLMaPojI3JNJ0S0+AuOhZYZc1uAj
	2hJIp/7eJ1beERBh1hy3V+9bKSyNpTg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785979069; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=++OVII9rPRuLo9kRAA6sts8kg/2BfkQm7kIApCaZIdA=;
	b=IGG/OvtN1cdwor0P82MzU7NQoe0Vx5x22kFBtzmzFwaWDaEQ0IGSf9X7DJe82SGFjs+/3zop+6a6ndpOrakCJHFwVcy3Ybqt+C9esdxlL3jf09t2/zDKZemNSyZyrj0X1YwtrHDwGQMtLW1R+2xso31bDb9R264M17lFtRjA/mw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8SHgJy_1785979066;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SHgJy_1785979066 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 09:17:46 +0800
Message-ID: <8551bb7d-945c-4be8-b7dc-01ff15fdbc76@linux.alibaba.com>
Date: Thu, 6 Aug 2026 09:17:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org
Cc: liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
 <DKH5VECNN2LF.M3RGFY0NORWI@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <DKH5VECNN2LF.M3RGFY0NORWI@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z7z1emz1ocyiiusftokty9d75e3wdtda
X-Rspamd-Queue-Id: CB8E910000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785979072-925373
X-HE-Meta: U2FsdGVkX18UKpRa70olarftEektD9+Pllp0nfrxxHI9/hmBL7Jk7cBUG9XFBPZehTC1SoGmK2coXboq4rGWRfDEsjZszBp6NO+hsUiSaI4yE4yew12ZEmpFctJZf0B19Q3wAGLpJ3o38oDretzATNTwbRM++V/mbyYYeOLMVnV4gID5DS1Ltz53TTOkQiLv6cbW6MQU5J0XdiyikPRL556e4hA2p9gC6btE3IQ0FwSlzsOq3l6ZzAgJBACFQAGiZbmIEV97vC1wVj9HKoHkqFvI8mGR/248jx5R4ml40I+DmFz76EOjI2yHZptIRs2M7XkqnHYgbMtYvgd+zXvQg0EZloUXQzgTpa+1RQRXF5E31z8DK8uJQZD667kqEyD5sqmtsVAGr+Rm8rlydE0kFrbVMK1QnrTJSuuCFt+MIrpAAUqily6abnbTBRA2W6Ll/QeVzZYxcHks9/3yi8PyTgmafcHGbqgmGuEYHLxGMLgAEYJM9wAFVACrRML5rp4jLDM1KvwJqWp7GLbHLVajikeXR+uNaXE+A92/jgWqVd6j/8WRj6shbSHicttVqhhm6edN+Apn6GNmon9kxZA7JZWLQlWCdAvGlIvK735tq8tv24EcMYXg57Srb/MoG4uhAws2iQYZ4gtVW0kvkyNtqkrc1M71QBtUDQsxK5T6cGrWczrLaVv//jBxhXghLYfFMRwk++5jucZcs29t73mZ06N7kbIr5FBys0iAeAjztqBxWcQ3E22GG2I2X+JROprZjUraEfC0ioLFwQGlfuCyz+NRTPQaN6INqWJuE+5Igoqs2DqmPoQqT8k4IZqRXmS59gAZO25WHYFFvdeiasCH0VefbU1QH8aj//iodfYHxM7FE5DEmdwitAKUCCc0oNPn4ZJCK9WnwcubyI0DSYFPERdqyHL6uw3jCa/pAXTv8jZ6UdX8PHZ7HenYcv4bsLr72glAI7yjNV52V8retCE
 JLJus8ju
 GVkmYYkfjXb7DIQnvkgd2DQRNZT40qXJjtopWGVbzuxsfhv8WfymwBQ/TxN7w31VZvO0rPSbhC1MkIrAO1hXoiVeaFAPvAUpmQrWoFe5HvwRR4MkEkLXaWblBI4gQJP7vVOtENhnuOdOst5kpOdlq1170ZiaKNCQwrTfP+R5eLJb9m9ZEUE5TjPdPFbXQmRa9eXOTdRxtLUjMD5IcCMVxkoN6dalD68Xnhif47Ml/jh0N7uWCREG6c0OVLnJtq2SyQIOZ7AZy9Sc6ZR+Y4qSLjRwnEK7LjMCfkdL+3XPeDyAaz9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/26 12:46 AM, Zi Yan wrote:
> On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
>> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
>> parameter to specify the collapse order. Additionally, added mTHP collapse
>> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
>> for anonymous folios. All khugepaged test cases passed.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
>>   tools/testing/selftests/mm/run_vmtests.sh |   2 +
>>   2 files changed, 113 insertions(+), 19 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>> index f69be6be0ecd..64d6da6aa90d 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -26,9 +26,11 @@
>>   
>>   #define BASE_ADDR ((void *)(1UL << 30))
>>   static unsigned long hpage_pmd_size;
>> +static int hpage_pmd_order;
>>   static unsigned long page_size;
>>   static int hpage_pmd_nr;
>>   static int anon_order;
>> +static int collapse_order;
> 
> <snip>
> 
>>   
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index 687d115e3bd8..d09f9f6a384e 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -410,6 +410,8 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>>   
>>   CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>>   
>> +CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
> 
> Why only testing collapse_order == 4? It is more useful to test all
> possible mTHP orders. -c can accept common separated order and a range.

This also follows the previous '-s' parameter configuration, which is 
used to specify the mTHP order allocation.

I think specifying a single order size already tests the overall mTHP 
collapse flow, so I'm not sure whether testing all orders is worthwhile. 
Maybe I can add a few more orders?
./khugepaged -c 2 mthp_khugepaged:anon
./khugepaged -c 4 mthp_khugepaged:anon
./khugepaged -c 8 mthp_khugepaged:anon

> Why only testing mthp_khugepaged:anon? IIRC, file and shmem are not
> supported, so khugepaged should reject them, right?

Currently, I have not added test cases for shmem mTHP collapse, so 
adding file or shmem would be no-ops and might mislead others. I will 
add the shmem/file mTHP collapse feature and test cases in a following 
patchset.

