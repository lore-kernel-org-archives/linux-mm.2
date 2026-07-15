Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CFEC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FE86B0096; Wed, 15 Jul 2026 10:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA646B0098; Wed, 15 Jul 2026 10:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9106B0099; Wed, 15 Jul 2026 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89E6D6B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:47:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2220FA0177
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 84991290132.13.32A30CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 179384000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:47:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BTwhcdSj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126864;
	b=mueCEqSxCNETEVzTNCWN2+OYRifoftSrVY8wiCc45FpCepv1tOuqx3PhOhGi0ch3kGxSAu
	ulX7luFqx8IiP+WctI4X4JJxy4AlCltxKh9BLNYeSd97PmvAwphNZbYHZvgMXmBOZ1RfjY
	zze26DU9kHMNhYwA6eZuOjwKkrlYHbk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BTwhcdSj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NA6GIBaGhdMcwtx3W+fbXUVcM36TxD5RfuczbG+96o=;
	b=lyUi9dGSUZehCEujcG9o8VCqYHJw4z6IBTVWX1vaI7U8ofWh4JCCb14Lw/rhliE8HRKWih
	vcy7kQXqTKxEQWpDWMIxsdvC0uIgPEQdrx0p3UPrXyniS8qOCKyrlooowjV08IQT0MJ71p
	kAf+OmdOyEZLUaYT7N+rDPG64qDiqo8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE13B1477;
	Wed, 15 Jul 2026 07:47:38 -0700 (PDT)
Received: from [10.164.148.50] (unknown [10.164.148.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFBB73F7B4;
	Wed, 15 Jul 2026 07:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784126862; bh=sYF1YoI7FvLDGePfeZYsbqzSb7LSoADtIopg9Qb/5wI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BTwhcdSjB65pW5SHOUKXDIn6CwPmGiqw566ssT4vahKzI8xJwbNb6xig6HiSW1+dQ
	 o5wK8+bqg42aSRuk55pkj58qGiOn/7Vhi3VkPFYL3xSnNr5Pb2wetOnDmqAhE3ap6b
	 STeNfDfGo2zO7GEMTbb/9t1u07xqpfowK4XoW35k=
Message-ID: <6c474ce7-8f1d-4e85-8587-8a60983cec03@arm.com>
Date: Wed, 15 Jul 2026 20:17:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: skip swap tests when swap is
 unavailable
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260715133418.170386-1-jaeyeon.lee.dev@gmail.com>
 <4b6904b5-81f9-4e27-8ac5-5bd7e7174c5d@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4b6904b5-81f9-4e27-8ac5-5bd7e7174c5d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 179384000B
X-Rspam-User: 
X-Stat-Signature: 59iow174o6m9acorteithqwjczfz3858
X-Rspamd-Server: rspam03
X-HE-Tag: 1784126863-854284
X-HE-Meta: U2FsdGVkX1+SHYJjrHXYUheo5pcVzXtal6HLDfOjpP/9ine5ObZ2xuKryuzaRDNJqwM6KoK42HhbsTuk474weJtk0rmwj1DwOD+TBU3BsSKIvyWj0pqxRBZgfoSyiQhfhdSWkCeECH+v+WVQU08IOg4KkBdUPCAGAE3UVGiWFuWxOC9jQhufBrCJLzBsSqFZsDqoSfPSuCVr1A9NMV2e4u295E1adeEjADt/gsPS1B6P++bqU0TlaNs/cd8Eryj/Px/qot9Iq8fBKC0AEN7QI+KlC74SV/397bKovutW1JBnut996TR1GQzGDi1ZmDwtkes0AYs9Y1k3UC2Umo8jdTF7RztsYE/3FiAHA93ER9z753edNXvJ/OKPIdZkzNaQQtzFiYrAGwrJLNelIRkEZy8uXPFmfwk4TqZLzH4+6gtonj/ePYGZjYSGB9+XY7HNLjraQIVwjiqy6K0Mi+z27lqk8VF40XgtST7rqHQLsDM4s38lGOjjny+/OYue4xbDjDgxcVOWQ1mKDZH73PWdIC47HCah6kvs2AqYn90IPR+a1tzMZL8K+3yLbl5ovFQsVvjyTT1t3MI2ue6iigJfWsGuamy/x0jCrEWMJzaeBeCeWg6y19jlvUDMHOBXgrucO17hCooYnydOVfDi2dDmtbotJz+1dSom7pg+tU5S4dn6inmSu4i8BuaYjQYB+N8jj33AJZ+s/qTOrf8f2WMOWxiMghqB9bKYx454RgjtpMKmf2oy825azAsgs52nfxDr15wzxLaftR7RKeC8WqDayLbvvVqBWXTjU3sA4ihFMshdv+Ym8WI6fPq76zsvDpvv2bgGDKregae4FOFd2ynaqHseAMsU1xxrGBDBGmqM3JXtH0+iSf7MSEurmFARnS8eY8VSWZDMybLPTao5dJBxxxXyBig0B41qyECtw486/q3yCcAPv0Sfn0nr0nboAGPybCXK3avkR8yQYtPIOfR
 4uvUsea0
 pr8pUJQV1QAsjkbV45EzxikvV2JA7xw6jPYGQmUQYqDwgry3qUej8tuHdnS+6MFa0bE7KAjt0r8optGwfHUtgnwc81VHcZPZFq5mGdAxPx+n2FS4JxMPk4U6CiJjWp9Sr6XnR1qKXM6DTI/nsA1u04erqvdEZS5TQNDpdMXXJ7WIGR53vIilqqaLvcduYkZua7c+SuH3+cyBJj8DPvIQp4fJBZZtG7C0qtkxDLjvDzVRTxhOgmdKiWx3i5s6zAgCgJKTF2Q/7w7QSM8b+1pDx11WOU6sToY+ixmWEDUQ+08IU0glNSODolCOO8Bi+oMFOjP9sxTnMvEH417E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/07/26 7:39 pm, David Hildenbrand (Arm) wrote:
> On 7/15/26 15:34, Jaeyeon Lee wrote:
>> The collapse_swapin_single_pte and collapse_max_ptes_swap tests use
>> MADV_PAGEOUT to swap out pages before verifying khugepaged collapse
>> behavior. On systems without swap configured, MADV_PAGEOUT succeeds
>> but the pages are not actually swapped out, so check_swap() returns
>> false and the tests report a failure.
>>
>> These tests cannot run meaningfully without swap, so a missing swap
>> area is an environment limitation rather than a test failure. Detect
>> the absence of swap via /proc/swaps and skip the affected tests
>> instead of failing them.
>>
>> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
>> ---
>>  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>> index 10e8dedcb087..f9b4ebe733ce 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -100,6 +100,22 @@ static void skip(const char *msg)
>>  	exit_status = KSFT_SKIP;
>>  }
>>  
>> +static bool swap_available(void)
>> +{
>> +	char buf[256];
>> +	bool ret;
>> +	FILE *fp = fopen("/proc/swaps", "r");
>> +
>> +	if (!fp)
>> +		return false;
>> +
>> +	fgets(buf, sizeof(buf), fp);
>> +	ret = !!fgets(buf, sizeof(buf), fp);
>> +
>> +	fclose(fp);
>> +	return ret;
>> +}
>> +
> 
> That doesn't mean that swapout will succeed.
> 
> Take a look at cow.c where we use pagemap_is_swapped() after MADV_PAGEOUT.

That suffers from the reverse problem - in case of a real swap bug, cow.c
will skip the test and anyone running the test won't bother.

I think this patch idea is reasonable, we need a way to say "swap definitely
won't succeed because there is no swap device, so skip" vs "swap failed,
need to dig in!" .

> 


