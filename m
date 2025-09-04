Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291FACA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75FF18E0006; Thu,  4 Sep 2025 07:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710328E0002; Thu,  4 Sep 2025 07:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626F88E0006; Thu,  4 Sep 2025 07:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA8C8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:07:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11EEC113FDA
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:07:10 +0000 (UTC)
X-FDA: 83851291020.09.FE9652F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56B8720005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:07:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2LNIdr0IxFyRQU+JgR1Du2sRS2O22SqJsiSsupwl7U=;
	b=gGQvOtgyqDCHSRwKfjVgFzdshw8B6P/W72O+VCU6mRjS1oOZgJeGfst+mvGQj5zc/5bWx4
	HO3uTdKJHGFrpOGKGUkiu3Fn3gqFRpP995fPgB+nKiKSEqlfDi9WqRS1G1qIOXoIY2ogud
	Cb3AhOtIoIclunhqa9/1rbPsh0qyEf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984028; a=rsa-sha256;
	cv=none;
	b=RKo+pMEm673+31tQSz8luXwmw3iV2bsFXU4YMPBK4XbgLvufPUZlHE4IGneltvZ1R+RWwR
	8r7uuqLhAUFrNFOosbrJIREF6ZLMsmdV5LsXtUCmWs50KhWUMd2EXqb2RkPRpaPCKfN1kd
	bRNjXNksDX/VKv5C4WJUu0Ayq/Au3T0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6A4D1756;
	Thu,  4 Sep 2025 04:06:58 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 754B23F6A8;
	Thu,  4 Sep 2025 04:07:05 -0700 (PDT)
Message-ID: <a2ab7671-093d-4b7d-b0a2-2a6f73bb80e4@arm.com>
Date: Thu, 4 Sep 2025 12:07:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] arm64: cpufeature: add AmpereOne to BBML2 allow
 list
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-3-ryan.roberts@arm.com>
 <b3f4e006-6101-496f-a4a5-13474470109d@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <b3f4e006-6101-496f-a4a5-13474470109d@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56B8720005
X-Stat-Signature: 6zy3498h9ypuo57aozr7xuc81zfexif6
X-HE-Tag: 1756984028-730497
X-HE-Meta: U2FsdGVkX18OPIqvzjEOPHSU02ThxONrmxxfOMTEw7wdTJLkeoFP4C7Be31WP9y2sCEMysLexscC5S3Hvgi6FE8GCIgotWFuUNYKNZEC60hRYBU35oB2BFrynQ79I/x8zXGiJCKgZ3zatFkN5qrlQKs58aVY7uhmyPmXjLLlHEfmufk2zEQqG57ASK/FP42p7BBXdgdQjlNyE49xS9l1YXkOvgp501eHCIw58b2nOq1otDzh7tA+bhvEC2cMFvSek6xCo+A9Hkwl9DDQBbPfF7wNB6Rae91tVFesXGZy0Lrqa5jeReO3/UBSd6pY1vvrAJgUc9/wndazkN0A0HLvLYJLHQg0k3yImuet1LqS6JsvwuR8VUCXtuHVeo73huzQ02lmFSYUsRZbXn8VEs5y1qdVj01tZljP7qVGfffvq1c21HuSVjYxVVjFO6zUuKoYqnNqOgdDNVrbL8ySWySDGDNqEojGlUAKni1BoSmDaGdcVLW1noYcTwdieU0FLrZbZ6TZE1NIYNuEQVcZlDvrGk6VbHeAA5Alob/I8NTYdagzd1buBFQgdTmHC7b3xmYPo0okhpuIX/v3OkudR0R7ZhpMUyjdpjhjEf1Tg3XRzXCiVgPf9K2R9tj/4etc/ZUa3mki6zdDx1GbwRvNxYoVBD6zOd13s9mLn3x6ONV8Dol3oPx3wlQXa4dZXwbKWjFpsy95FJ08LZdnYxxoOwqSAvIt/5+Pv+k+f+/AMINbVQs/fsDuPsWQdtR+ETb1oD0V1+vikgn3DRkaCkiRsZsI2qKQ8ZHyhcx/a54Wqyvs+sktcxOX2cXk1NSH7X2OP1YDq74ySX3h11Ps1gniQuRHmKs5z/8EVPuxzPHfd9RxG7KzJsL1bYxpTi2tKAMXTc+rdKamf4ofBU9flZ20ymbR5vXTiavcIQ9ngB0GOuxypRcrf0OwnVRbC+6Fed3VXtwkdVjjh4ifkjbwjUNVUi5
 vTB1lCOC
 FPGBfdQSTXkFAlFtmC7D4AwhGbJf8IepMbJCB5qpYUuyIsaLj2PUh1VaqBFQkjTHHvldi91XZ2yWz8O/h6jaQ3rlcPsj3fjrfjD1UoEDkamopsgcRn9rLSpMAaAA7LHMkTPYbREuxghOc6rceDlOu4cdZEVXrBocbFUg5UN04dm2/rybxLItlyQGUB4ZKQBbXLemLivmWEGdytxc62vVlh0BxBbi35HuHUoM771dA4OH797EmVtvwnqHMMTXDf4G349ZbiDyAxSxbS2RYJmi/Uy0BRABcoS6jXo/7bqyfX80PK1P2zXM44J1sIhGhzvqu1B+i3Mr3PX91UEEo9upT9x7P+9w7Z3DJAdGR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/08/2025 23:08, Yang Shi wrote:
> 
> 
> On 8/29/25 4:52 AM, Ryan Roberts wrote:
>> From: Yang Shi <yang@os.amperecomputing.com>
>>
>> AmpereOne supports BBML2 without conflict abort, add to the allow list.
>>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> I saw Catalin gave Reviewed-by to v6 of this patch, I think we can keep it.

Sorry I missed that. I see Catalin and Rb'ed again.

> 
> Yang
> 
>> ---
>>   arch/arm64/kernel/cpufeature.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 9ad065f15f1d..b93f4ee57176 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2234,6 +2234,8 @@ static bool has_bbml2_noabort(const struct
>> arm64_cpu_capabilities *caps, int sco
>>       static const struct midr_range supports_bbml2_noabort_list[] = {
>>           MIDR_REV_RANGE(MIDR_CORTEX_X4, 0, 3, 0xf),
>>           MIDR_REV_RANGE(MIDR_NEOVERSE_V3, 0, 2, 0xf),
>> +        MIDR_ALL_VERSIONS(MIDR_AMPERE1),
>> +        MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>>           {}
>>       };
>>   
> 


