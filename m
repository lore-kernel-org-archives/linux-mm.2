Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17D2D29C31
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CAE6B01F3; Mon, 19 Jan 2026 09:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3586B01F5; Mon, 19 Jan 2026 09:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB106B01F6; Mon, 19 Jan 2026 09:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4036B01F3
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:26:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8C721AA02
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:26:38 +0000 (UTC)
X-FDA: 84348939276.24.EF5180C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id D74F2C000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:26:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3J8oFIN2Q8wI4OM3y1tmLqJy4M93DQLXTPsaFmpoQRY=;
	b=LIPv9vIW706IOjquZhwiT9axKX7kjKExRe+n55zq4hBq2I7z6T4iBz17B8Ku8Uaknw6SJ1
	N734XNVA7tHZGQK9SNxkhUStye2uW92M8eQuevMmrlIpJx508D2YithwvP9v7CYq5gjVOu
	JTUTHfD0M30PMg11hUFIDOC4pTtmHvE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832797; a=rsa-sha256;
	cv=none;
	b=ci31gde4ujk7ckJU1AF8CNKwWLV14+ia8l+q8o4OL3Nf/Umo25RkVYuM3Vu6wuninUtYT3
	Y8U++kxQa4dhe2jIt7BGZJTyxj4D+0ftAgIDvKaUwoOue1GlxJ1dJruZNTFc3fIs7iqYy3
	hhm4VOQ81cZfx16vLUupQchVh9Y88G0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55E6D497;
	Mon, 19 Jan 2026 06:26:29 -0800 (PST)
Received: from [10.57.93.204] (unknown [10.57.93.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E548A3F632;
	Mon, 19 Jan 2026 06:26:33 -0800 (PST)
Message-ID: <46e50e9d-0e4a-4f81-8b43-61b897ad9c34@arm.com>
Date: Mon, 19 Jan 2026 14:26:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
 <09c214df-c3aa-48e4-9587-c54c667c6ce9@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <09c214df-c3aa-48e4-9587-c54c667c6ce9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rwk36pryfmwtoqhrpqm8zc6345qh6ctm
X-Rspam-User: 
X-Rspamd-Queue-Id: D74F2C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768832796-676387
X-HE-Meta: U2FsdGVkX18wGdmjUL217zNkVTPancBhVpVlEEo2Q1Xz1AO9YLp5RLR9hxG7pug1zJESpOvD1R5U336eVNXXA8dI6tvnhZ1ALbyvs80vm/5U0OXCrbwsJ30BCFgxV4TVICko4CQDHMvCCItfp9TEJVdpuX1LvZXoBwCBnoFYLoP41fU+7LF6CdYEVNkxJw9MPI5jS6Ak3eCJkhCjCzUbAdAcHxVgFIeN51o5MJjaF28W691n2GxHYc+OlwNXlgzPrmEGB4oA75A0EU9swm4TGknLxvw440cHnfDe8ufuhmzSar6yqzpBD4iLfo6EAYDID9ylHHfD7HHPAGSoVYsO9t/ExLQbrrAEUJGtUtxcdRp4tTZPWKZpew2Nn0b2792aaWQtghTCWwEJ7nh9cP1Tluiy6m5+U9+odmAu3y0w+M0EEBm+iNVUDc1ukrZIY6I2r5UhF3bRA1ivRfONPwC0JoFSCgLkzqvC2bjgdEHxHd9JiRBSVSpHK8/XepDMGh4R9DvP2Na36cKnq8dYVouKh9CpcjgPQny4UpilEEKBjf/Um9yt+DKMbsx1tcYunqN609D+cBYpGb4pmrr6Sqcm/Mtd3v2uBJhY+fQlEHWh9kVQPlesBaXTPz0I6hnlgG/3l4r3XTRf33RTrG3n4cuDQarqpE2Zp3MRT9S+LqwkDahIb30X8mZBZ/b0an1g9HEIOEP0CQQfKXoTMJOYa91g2mOVx4PB4vl/q09+tspHhm+aLuU6lp3aPRCiz+05BFwqwPMcRK2XGBTizysnZlFPwvktI1UmaZUtRvXTGmXLghNX3C9whQ+ARiwwwphKexZ0uUcH3YxKLlQTYELgpHleAWabXtTTN/3MtXpC1bXwRohuzNrY9cwMo4Gs+VI/DtLSN/Kp2wIt0rK4Z6gn4eJiMEDIqzieRw4V4U0cJCcruV3DKNQ1/FKtrwxFAanR26ZQQY0vo7xcrw8u3lW2LAq
 j5LAB7bE
 Y/QQlsnwj672cTzpUQ44H+pkC63c+hlATcNA0MxTmnfQ5gsr4SLpGASklmq/KFe7raOK9FTxwau/9vkuUdu4kSV2ApQTGi2ScMTt3JkNC2mbSt5OT3kefMcLRs33H+aJHDLC7JRa6MD+kJphVVD5woSJr6NqhxmEovnEY47fELz/CW32zrC/E4W6iog7hCDnMoQ7vUNZvzveQtJyxrPZbNDAtmW7/XpcAGs7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/01/2026 11:16, David Hildenbrand (Red Hat) wrote:
> On 1/7/26 17:48, Kevin Brodsky wrote:
>> pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
>> meaning once for every test, and skips the test if any check fails.
>>
>> The target file is the same for every test so this is a little
>> overkill. More importantly, this approach means that the whole suite
>> will report PASS even if all the tests are skipped because kernel
>> configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
>> being mapped, for instance.
>>
>> Let's ensure that KSFT_SKIP is returned as exit code if any check
>> fails by performing the checks in pfnmap_init(), run once. That
>> function also takes care of finding the offset of the pages to be
>> mapped and saves it in a global. The file is still mapped/unmapped
>> for every test, as some of them modify the mapping.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   tools/testing/selftests/mm/pfnmap.c | 81 ++++++++++++++++++++---------
>>   1 file changed, 55 insertions(+), 26 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/
>> pfnmap.c
>> index 35b0e3ed54cd..e41d5464130b 100644
>> --- a/tools/testing/selftests/mm/pfnmap.c
>> +++ b/tools/testing/selftests/mm/pfnmap.c
>> @@ -25,8 +25,11 @@
>>   #include "kselftest_harness.h"
>>   #include "vm_util.h"
>>   +#define DEV_MEM_NPAGES    2
>> +
>>   static sigjmp_buf sigjmp_buf_env;
>>   static char *file = "/dev/mem";
>> +static off_t file_offset;
>>     static void signal_handler(int sig)
>>   {
>> @@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset,
>>               break;
>>             /* We need two pages. */
>> -        if (end > start + 2 * pagesize) {
>> +        if (end > start + DEV_MEM_NPAGES * pagesize) {
>>               fclose(file);
>>               *offset = start;
>>               return 0;
>> @@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset,
>>       return -ENOENT;
>>   }
>>   +static void pfnmap_init(void)
>> +{
>> +    size_t pagesize = getpagesize();
>> +    size_t size = DEV_MEM_NPAGES * pagesize;
>> +    int fd;
>> +    void *addr;
>> +
>> +    if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
>> +        int err = find_ram_target(&file_offset, pagesize);
>> +
>> +        if (err)
>> +            ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
>> +                       strerror(-err));
>> +    } else {
>> +        file_offset = 0;
>> +    }
>> +
>> +    /*
>> +     * Make sure we can open and map the file, and perform some basic
>> +     * checks; skip the whole suite if anything goes wrong.
>> +     * A fresh mapping is then created for every test case by
>> +     * FIXTURE_SETUP(pfnmap).
>> +     */
>> +    fd = open(file, O_RDONLY);
>> +    if (fd < 0)
>> +        ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
>> +
>> +    addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
>> +    if (addr == MAP_FAILED)
>> +        ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
>> +
>> +    if (!check_vmflag_pfnmap(addr))
>> +        ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
>> +
>> +    if (test_read_access(addr, size))
>> +        ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
>> +
>> +    munmap(addr, size);
> 
> Why not keep the fd open then and supply that to all tests without the need for
> them to open/close?
> 
> Then, also the file cannot change etc.

I had a private conversation with Kevin about this before he posted; my very
minor, theorectical concern about that was that it's possible to pass in a
custom file to be pfnmapped and I wondered if such a file could map a device
region that has read side effects? In that case I think you'd want to open it
fresh for each test to ensure consistent starting state?

But if you think that concern is unfounded, certainly just opening it once and
reusing will simplify.

Thanks,
Ryan




