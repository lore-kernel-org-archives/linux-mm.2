Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F6DCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C63C6B0456; Tue, 20 Jan 2026 11:27:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E9E6B0458; Tue, 20 Jan 2026 11:27:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D296B0459; Tue, 20 Jan 2026 11:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC7606B0456
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:27:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96FB61A0322
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:27:08 +0000 (UTC)
X-FDA: 84352871736.19.18A2220
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 577CA18000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:27:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768926426; a=rsa-sha256;
	cv=none;
	b=WEJzBdsm735vEu+/GmiCvtR26mExa+bcunnDSCnhA6QRt90z26cc04RhkE9fsluCJ1GKbj
	A1aav0ugpfYm9a7M3Qw7LljZkYuddqL6KMX8+jOhCO5bKRx3/wfrRVpI3phTIdI25j1NH1
	wCm9E4IP/M5ncXivESSCjnWnjR9AwwI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768926426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gF2y7YWjjVabDGLcfjGxjrZYrLf/hq1DXKLtVD0Ogkw=;
	b=kFbJyhpFMQqpE0+tOFPMTadW5/X68JBGyjd8YO5lAXGSca8V+Doi/ilKJeuv4PrLhEISj/
	pjvvAtaFzZr85rSr4km8h9g8GO4ewzP3qHtQ9c+RDTNikbAD/VOeFsYQMlXsBKzHJBhrIq
	n3DV2c6lK2/YKp1rL9dY1s7uPKL5pTA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93E211476;
	Tue, 20 Jan 2026 08:26:58 -0800 (PST)
Received: from [10.1.39.200] (XHFQ2J9959.cambridge.arm.com [10.1.39.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3B5F3F694;
	Tue, 20 Jan 2026 08:27:03 -0800 (PST)
Message-ID: <ee3750f6-dd8b-459f-bc19-8c4a857d40a7@arm.com>
Date: Tue, 20 Jan 2026 16:27:02 +0000
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
 <46e50e9d-0e4a-4f81-8b43-61b897ad9c34@arm.com>
 <42b9825a-adef-4e80-bbf3-bf01b9fb0054@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <42b9825a-adef-4e80-bbf3-bf01b9fb0054@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tmu3tkraqx1scraiz1ozp8bdxzdyph8m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 577CA18000C
X-Rspam-User: 
X-HE-Tag: 1768926426-960862
X-HE-Meta: U2FsdGVkX1+g7rkY3Cs3I0ViZI7gI8CL2DXOAhEbRwfeqsHq3EctDLyQsoWcVEfyiHe1v1953x+B20uKwmNs6Jirb/d1ojmr4ieNHDAHIMh14GkCeDh6ZzPK6BVoueSP+1SKoMtA5tdkKQqfTxxlLBwRRbBPmdFu70x4XW4ZAq9hN6pRFnUkGHcfOPb5TuJijqJtRZlRuIc84h66jr/tjBK9ZMpYCJVSmQJpOzqhRkWo5Wvf/H45kphCa3SisT16TIhEeYxMBp9EhrLVDU6FukLEbyePRh93eRiefMHqkGysws/rgko8vr7DjKG9imDiAjG7M+tEDlDIhKWgqbIbzxM+uew0e9O6mGRbCZSlo/hQQH1XCa4/1ZpRFSxVbg65C8cPdi2hf1JdlC/V9Q52y+Z3aFpkhWr2E3BNHPVvQVPSSVt0V7Bo5OdeYSo73/UX4whkF3uGLstQ7G3hP8HHs8GoPZf+p1xfmqz5JM5t5PHRFuX1lvc98xJmJNYvufVDE/VN6ECax+WypJf/9Cz2mhztBJoaEAPr+OOWWZqkawSnCdvC58FWSM6lXZJArehkAG1iJgO9oyPQVq0Dd0WeXUlJgyw/HJHmpPofG3iH5KzMiBdunQTtGo3e+YTPJ7BtigeNrDAMApOJm5CnwO+HrqDedWZlbhepFeqt7xEwyL5nh8yWlavOHohLig8l8NRLrqmybb693/ROCNmm8aqK1WyIWVLe7j33iuZLIK5yzn5IbtO+OA2ncz0ZoWZv0zBFa8b1D9RLlJeZ+nf47HkBJDNcchCw8SABOpXCZX3p0ubM/zwJB7VRqmwfIwlz9DUepOiH6/4mHDMgkOIGfNhhcwOAQSkyt2thdi1Z13dMurSv55vnzCARkhoYJOIpQTuflzcaLOerrXJR2umtBYX190hj69flfr40kGcw0yTvqxyy5Bhlve6aPcoIzvzMUF5a3kG+n/00gNaBCkXWpWn
 nRY8rrTH
 u4YHZGduHQl5GEvtf1aWpJaII5hQTchAIBnQRaVrz9J/FXQXW2PLGlqBgdk7rqnxO+DEj9c01X1ICA74I6cRavlFWf7XJQw4f2NwJ3/JMJ6BwRrTn9No1Aiaui+KQ24jk7qF7e087IHRwou2FbGiB2/2EBsszLZYEYteW585aVBc4K6HAH+wcdTdul/Asn3ROSmN+oA5PvpL4FPNgYQ4VHxu2h4J1ze/Sz80x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/01/2026 14:32, David Hildenbrand (Red Hat) wrote:
> On 1/19/26 15:26, Ryan Roberts wrote:
>> On 19/01/2026 11:16, David Hildenbrand (Red Hat) wrote:
>>> On 1/7/26 17:48, Kevin Brodsky wrote:
>>>> pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
>>>> meaning once for every test, and skips the test if any check fails.
>>>>
>>>> The target file is the same for every test so this is a little
>>>> overkill. More importantly, this approach means that the whole suite
>>>> will report PASS even if all the tests are skipped because kernel
>>>> configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
>>>> being mapped, for instance.
>>>>
>>>> Let's ensure that KSFT_SKIP is returned as exit code if any check
>>>> fails by performing the checks in pfnmap_init(), run once. That
>>>> function also takes care of finding the offset of the pages to be
>>>> mapped and saves it in a global. The file is still mapped/unmapped
>>>> for every test, as some of them modify the mapping.
>>>>
>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>> ---
>>>>    tools/testing/selftests/mm/pfnmap.c | 81 ++++++++++++++++++++---------
>>>>    1 file changed, 55 insertions(+), 26 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/
>>>> pfnmap.c
>>>> index 35b0e3ed54cd..e41d5464130b 100644
>>>> --- a/tools/testing/selftests/mm/pfnmap.c
>>>> +++ b/tools/testing/selftests/mm/pfnmap.c
>>>> @@ -25,8 +25,11 @@
>>>>    #include "kselftest_harness.h"
>>>>    #include "vm_util.h"
>>>>    +#define DEV_MEM_NPAGES    2
>>>> +
>>>>    static sigjmp_buf sigjmp_buf_env;
>>>>    static char *file = "/dev/mem";
>>>> +static off_t file_offset;
>>>>      static void signal_handler(int sig)
>>>>    {
>>>> @@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset,
>>>>                break;
>>>>              /* We need two pages. */
>>>> -        if (end > start + 2 * pagesize) {
>>>> +        if (end > start + DEV_MEM_NPAGES * pagesize) {
>>>>                fclose(file);
>>>>                *offset = start;
>>>>                return 0;
>>>> @@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset,
>>>>        return -ENOENT;
>>>>    }
>>>>    +static void pfnmap_init(void)
>>>> +{
>>>> +    size_t pagesize = getpagesize();
>>>> +    size_t size = DEV_MEM_NPAGES * pagesize;
>>>> +    int fd;
>>>> +    void *addr;
>>>> +
>>>> +    if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
>>>> +        int err = find_ram_target(&file_offset, pagesize);
>>>> +
>>>> +        if (err)
>>>> +            ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
>>>> +                       strerror(-err));
>>>> +    } else {
>>>> +        file_offset = 0;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * Make sure we can open and map the file, and perform some basic
>>>> +     * checks; skip the whole suite if anything goes wrong.
>>>> +     * A fresh mapping is then created for every test case by
>>>> +     * FIXTURE_SETUP(pfnmap).
>>>> +     */
>>>> +    fd = open(file, O_RDONLY);
>>>> +    if (fd < 0)
>>>> +        ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
>>>> +
>>>> +    addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
>>>> +    if (addr == MAP_FAILED)
>>>> +        ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
>>>> +
>>>> +    if (!check_vmflag_pfnmap(addr))
>>>> +        ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
>>>> +
>>>> +    if (test_read_access(addr, size))
>>>> +        ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
>>>> +
>>>> +    munmap(addr, size);
>>>
>>> Why not keep the fd open then and supply that to all tests without the need for
>>> them to open/close?
>>>
>>> Then, also the file cannot change etc.
>>
>> I had a private conversation with Kevin about this before he posted; my very
>> minor, theorectical concern about that was that it's possible to pass in a
>> custom file to be pfnmapped and I wondered if such a file could map a device
>> region that has read side effects? In that case I think you'd want to open it
>> fresh for each test to ensure consistent starting state?
> 
> Are we aware of devices where we would actually require a new open, and not just
> a new mmap()?

Nope; as I said all hypothetical. I was just being cautious.

> 
> The reason we added support for other files was "other pfnmap'ed memory like
> NVIDIA's EGM". I'd assume that people rather should not pass in something that
> has any side-effects.
> 
>>
>> But if you think that concern is unfounded, certainly just opening it once and
>> reusing will simplify.
> 
> I would just keep it simple here, yes. If this ever becomes a real problem, my
> intuition would tell me that probably the caller is doing something unsupported
> that we just cannot easily identify+reject.

Yeah fair enough.


Thanks,
Ryan



