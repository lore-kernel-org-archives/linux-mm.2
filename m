Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211CBD72348
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7946B0432; Fri, 23 Jan 2026 03:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551366B0434; Fri, 23 Jan 2026 03:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453DA6B0435; Fri, 23 Jan 2026 03:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 330946B0432
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:17:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCFE51403FA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:17:16 +0000 (UTC)
X-FDA: 84362523672.25.49EF666
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 101A7180005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:17:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q76GxKf571aWV0I/Pa/JClhBRMLw2Sgfua5X1b+l1is=;
	b=eE5zFVa9Xq7W0jKRhsPn5iB9xEe6xBE4jYWZlLuNPhSfPRrBmoeXvvz8vs+vvVC/XbVnSo
	19UTITL5ROQa/sF7Am8WawOQsspH+cs/GqSGish+/MkkuiP4G+xf6PaKhNUTrE6kIGmthv
	z1d+/3phktQc11ZWbSkFd1J8vewfrjs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156235; a=rsa-sha256;
	cv=none;
	b=YehYgFCO2xyi6MRFn7sx70ZJhEjgVcAClxzb2sLFcmcuM8FALNYrAEGkxjRNxGx3RwtGDe
	6ip9utiB0X+rN50/P6U06xLRF86RDpOsB5/a6sJCDuGf7ac1beDUZ/Y47vHo1/VAQ4Styj
	NMGi/D9T9tqgftUKjnxd1u8fykyVY+g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B6391476;
	Fri, 23 Jan 2026 00:17:07 -0800 (PST)
Received: from [10.57.50.81] (unknown [10.57.50.81])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E607A3F740;
	Fri, 23 Jan 2026 00:17:11 -0800 (PST)
Message-ID: <ed372449-de6d-4588-868c-1b87d5655632@arm.com>
Date: Fri, 23 Jan 2026 09:17:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] selftests/mm: check that FORCE_READ() succeeded
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-6-kevin.brodsky@arm.com>
 <fe1ecb39-abbc-452c-b3a3-61d63ca32244@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <fe1ecb39-abbc-452c-b3a3-61d63ca32244@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 101A7180005
X-Stat-Signature: 6gcpp9gjanftx5yroccu11y6my7o8dk3
X-Rspam-User: 
X-HE-Tag: 1769156234-712310
X-HE-Meta: U2FsdGVkX18doZtlrnYnoTG5hPChCJTTGoLhvlS+PXNxTi8vH7RYH4MsWNYxHjvuTHLfb0qJKjK+khQBSlq/aj6vaBnQRX75eSETXNBJxnySSVmFkJz5pPumsJq922q+0Jv94eNh4lOZc+MSecjnyqS/Wy+0WtoO6Ef6L9oIgmLXsTNbF6lYu+Mz7o41bsteDAIPVJlRqCb3oAzhY/8GSkXtxc+J33CFhWsEKkAfTbLzRMDjhj6zKTcGM7VytfFTs/VKsFId0KitG3NO6bgF4J4zXxmYEYT1yF44ym7ZlQ1278RvQiK2ise6RccXJWbUOsVqGFStt+HolzZb8IKyuIXfupbvCvk8PRF0DRi909jZ7qIdiw4PoXwxuzofBkeAky5KHWUP56zU+FjPjtl4N0Hgq1bDR/Z6NRzKDP+odWUMxScoCuMw5569XEAR+PfYJrujaTeWeSEz6NBCG/sn8bmPeB2HDvGsy4njwmF8t4cdjN06JEfubp86heV7vbSAXkrgzaw3oarH47ahFCsL/dZKq7UAgWKQIOrqWJ13beMUaxqkKo5SgVwtrOljpimIBI4hQzQ11vzazS4p5Qu1DN6jaLUhLhTAgDaXtB5FKlSL1iNi+8Bd1GDB8T5XZ1pOzn98KQ0iSoiGnpagl3Lyh5M0v7FRFAeixm9KxgQ8T1BY9ze2PMpgnFXA+FdapzZVcS1XI7ztagoe0/Bd9jX6pRAY2BF/RAyfX3pLMijXJn2D88ZLg3OGafWT9zIsMotH11CMmNjDQpX85pj7XTLwSoV+lcalmVw6z2UtNh1iUxv4NZpTcaYqZRMAIkFc47QV+YPsjCY3o6nizQ5DToQS47V9agBqSj9Jv0WRx84CqDBatRrljLcMEEUU/cFccs8tsFA7wVONAfDAt17rPTtHP8lOOBh0JME4Km9Cjjw836q8/5JmhPgoIdNAqm+NxNyrmUEU5sY5Kn5wHcJPLgT
 koKPGTdb
 lj1diMyrYxLlD5NMcmK3gtr+eXrq5dtltJU8yhfyCrXFJ+sJ2p7niO7LoEAaXroXdNb334AzbU0Gw4HMMeWQzwJC5bPKHHqBHVVKs8YQam7NXPXCR/3OUqnU8ChTX4jdEvggDfogqojpwAC5YtiDAQA0Fa0yoZA/emyUAE4s/+PiK5y1VyOGEyPKhtJ9thN2xEMNompBwI6tL4UtBfoMryaLDmmJ8qldA4565NHfGQjoKsgLAaJhFA8xjhH3Pny0wWsNyQEChxMV5s3pLVK9gkAG5CcRRjpXqtzWZB3em3Ijo+4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 23:18, David Hildenbrand (Red Hat) wrote:
> On 1/22/26 18:02, Kevin Brodsky wrote:
>> Many cow tests rely on FORCE_READ() to populate pages. Introduce a
>> helper to make sure that the pages are actually populated, and fail
>> otherwise.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   tools/testing/selftests/mm/cow.c | 43 ++++++++++++++++++++++++--------
>>   1 file changed, 33 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/cow.c
>> b/tools/testing/selftests/mm/cow.c
>> index 83b3563be26b..d9c69c04b67d 100644
>> --- a/tools/testing/selftests/mm/cow.c
>> +++ b/tools/testing/selftests/mm/cow.c
>> @@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr, size_t size)
>>       return true;
>>   }
>>   +static bool populate_page_checked(char *addr)
>> +{
>> +    bool ret;
>> +
>> +    FORCE_READ(*addr);
>> +    ret = pagemap_is_populated(pagemap_fd, addr);
>> +    if (!ret)
>> +        ksft_print_msg("Failed to populate page\n");
>> +
>> +    return ret;
>> +}
>
> LGTM.
>
> On second thought, this primarily catches if someone breaks
> FORCE_READ() ... which hopefully doesn't happen that often? ;)
>
> Because if the read succeeded, surely there must be something in the
> page tables. 

Indeed, one would hope so! The check doesn't hurt either though
(especially since we already have the pagemap fd around).

- Kevin

