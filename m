Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B2BD29C30
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE55F6B01FA; Mon, 19 Jan 2026 09:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7B76B01FB; Mon, 19 Jan 2026 09:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9626B01FC; Mon, 19 Jan 2026 09:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAC606B01FA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:32:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F6A9D1927
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:32:10 +0000 (UTC)
X-FDA: 84348953220.28.5932B0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 85547A0012
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:32:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGy0RovL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768833128; a=rsa-sha256;
	cv=none;
	b=7A6lBfNezP7Rpdkwo11Jy25/9oj6AKIGW785uKQyo2BJ7vFedwu6RgzfhjFi/Qqvn4M9BI
	UJ08+QN3fkj996cRNUYL1ajVlpuatcZG8K9g4Zc+ab0J3K2bE8KsE5N0dKjN2kgtdNTfrJ
	XNI2RgoKUbMJVwoBbtZUU7ERCqf7Zx8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGy0RovL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768833128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gs97hczV+1/81h2p6MpE9wyGF7JNdxdjs8rjAc+LNmU=;
	b=tgKyjLso8EztBXd+4NjmQGNyz+zSnWZ9wlPGn2cuHT0Gtz2MIQ0OEkd6juue7qXfQcBWtd
	lQkHGA71Z2Y4aNJrQMwnDcTlOX30DNRLknrvFPw0yJAgfG/2AFPy1kYGWe7TfBwwU1ToyJ
	K8vjRBx20ZEso55tG+PPMuE55A+0Wr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C352D60054;
	Mon, 19 Jan 2026 14:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7B6C116C6;
	Mon, 19 Jan 2026 14:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768833127;
	bh=Hs96R0v+LlI8+ufCHnrjOfcRFqlmPYepVc9ZlwijYkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SGy0RovLRZvaYLdD3aLt2XozWXFHZ2SPjh0XzkFNl2IpZCqNfKbpohPSjP+CkYA5W
	 aEDIBTUxdcWBbYnU3KtrfMHe5TsAKXEGECs6N51jAJPUhu88PNtp8Azp6+MW43kK/Z
	 uEfkEN8/a0zOKDDuwCPPNeVm92Y4gfyRy18AgTsT52vNzujpnxil8MQSQmybO+WYgF
	 PNkszLtFenchgwT4grC2xyOkZ4N1nQy7ehh5ey+mweQFxs7zP8eysRJJFfAyuXB5LE
	 vMcRUJBOcDeCos62taDKTW6Ysim+u5nzgxm9Fe1bWw9i7xCtcmiHjSiIuE8oYx9jUC
	 2DlB0POinPT5g==
Message-ID: <42b9825a-adef-4e80-bbf3-bf01b9fb0054@kernel.org>
Date: Mon, 19 Jan 2026 15:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
To: Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
 <09c214df-c3aa-48e4-9587-c54c667c6ce9@kernel.org>
 <46e50e9d-0e4a-4f81-8b43-61b897ad9c34@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <46e50e9d-0e4a-4f81-8b43-61b897ad9c34@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85547A0012
X-Rspamd-Server: rspam06
X-Stat-Signature: wsnd8r47jzps4wys98e8rtmggg1kg4ip
X-Rspam-User: 
X-HE-Tag: 1768833128-750201
X-HE-Meta: U2FsdGVkX19YdpbPtXKtlFHs/WuzSnYw3kz0CuM/E8PQjXxIcgUUxbmI/XCBDXq3uFjZOGNBGRJmAYAGqeH35nzF0eE4StASmWpKYn/WUFGyIcWb14SVu6fy3Tof22yepLAFL/LDAk4fudcsNGGWx4QiCXHyvwVWgdPddrNBO1DID6MK3dDMavUS9r4VrwJhYPoQe0guChvLAMr/+YXyBI9HbxTD2traRWjf/PIQ7z332IghRpobXww08qQAIrMDjcwY7AuhZtYYJ+XLWQA/o0NYjoVSqk1gx289ToYAvQsjrG8EbrUYFEe1Jp8r7vjX2/wGOESA3fll7e+1+wTDULx6yUXzURbfONG8GTcAk/Mqm0aLelTkauKPP5IvairWztKQuR2naT2RdxpyClwyZUaW4LMRBTbs9sGF20tB/s0odYSZo2uzpIlz6TCJMB0Mm8Q0wsaLiGZ0H1gCHSNMPcB3TY3iJnc+v/ZBxjRxr9R3CyHB1WsDSx1mvDImDeEBW4IT7h1AaKmVuOpASsw/kvsa7+z+lgPvtr2zp8xjQowldE9EFdMiB5wl7W7Uf9Eaxk6bgYtgV3iEZRDGBjf8vvpoEUqr4mAEMGwE8DVD2QSFcvcoYK3MWq6a6DBx9ARfkjyCpuhX2EYKgMHT4zQGEpQ0g7Vb7s0mNGHoXeECnERcallWI4T8IyjM7AgJZTMQzx8PEgMLcSH1KnSUhlXCCR01c+BwWJVSiOnW7p7irObCtjlLk4N+7LEgbov76wb1WcpUZ2BVQM3pnUFov4kD5yAv7/7ALsv3Ei3iP0TfLIZPSYTrEVf7hxqSWQC8KDkghHzA1EAQIqChsG4FeE74TSFqj00/IHHohA+SquSH8WZCqaHWSETc1ImHIiA4siBXKVl0rsDm8nfwgxuJKyKjpG7c4O+sMvVPEnvfUq+2wBjYUUuWonKZric+NiEbSCHE3Gmteu0pGtxlyoTSYKl
 FAnBSugV
 za/zziu8eK5QoWw+ZsMMQGDeqOHoQ37iagMrQjgBvNl2D8iEdEwb373Wlqo645nKJvjbbH9OQQTvp+Bsi3ftohwioNvC+vQhR10As+pZXh7rXE+A9vkrjRzPSJZI2uDlYBPzxCdsrkzqLzskT6V61iEtdps7yRqIFENUPP30qCOdx9PfSb1Kt0/FaRAxsIO7PXBtOnj5K7BIV7pBzvn8Pp6LCDxqveLsavK21WHfZZhnS/RqWH5dh2OpZQMbJtGA9gRFuKRBRV0ycrZo2N5hpGLtXRCcNZwzIG/+/nSSyT3xAPTjbF8jdfw2r8p4xGFCT8hTvCgBRMopXCK3YwbyaQccReA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 15:26, Ryan Roberts wrote:
> On 19/01/2026 11:16, David Hildenbrand (Red Hat) wrote:
>> On 1/7/26 17:48, Kevin Brodsky wrote:
>>> pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
>>> meaning once for every test, and skips the test if any check fails.
>>>
>>> The target file is the same for every test so this is a little
>>> overkill. More importantly, this approach means that the whole suite
>>> will report PASS even if all the tests are skipped because kernel
>>> configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
>>> being mapped, for instance.
>>>
>>> Let's ensure that KSFT_SKIP is returned as exit code if any check
>>> fails by performing the checks in pfnmap_init(), run once. That
>>> function also takes care of finding the offset of the pages to be
>>> mapped and saves it in a global. The file is still mapped/unmapped
>>> for every test, as some of them modify the mapping.
>>>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>>    tools/testing/selftests/mm/pfnmap.c | 81 ++++++++++++++++++++---------
>>>    1 file changed, 55 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/
>>> pfnmap.c
>>> index 35b0e3ed54cd..e41d5464130b 100644
>>> --- a/tools/testing/selftests/mm/pfnmap.c
>>> +++ b/tools/testing/selftests/mm/pfnmap.c
>>> @@ -25,8 +25,11 @@
>>>    #include "kselftest_harness.h"
>>>    #include "vm_util.h"
>>>    +#define DEV_MEM_NPAGES    2
>>> +
>>>    static sigjmp_buf sigjmp_buf_env;
>>>    static char *file = "/dev/mem";
>>> +static off_t file_offset;
>>>      static void signal_handler(int sig)
>>>    {
>>> @@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset,
>>>                break;
>>>              /* We need two pages. */
>>> -        if (end > start + 2 * pagesize) {
>>> +        if (end > start + DEV_MEM_NPAGES * pagesize) {
>>>                fclose(file);
>>>                *offset = start;
>>>                return 0;
>>> @@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset,
>>>        return -ENOENT;
>>>    }
>>>    +static void pfnmap_init(void)
>>> +{
>>> +    size_t pagesize = getpagesize();
>>> +    size_t size = DEV_MEM_NPAGES * pagesize;
>>> +    int fd;
>>> +    void *addr;
>>> +
>>> +    if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
>>> +        int err = find_ram_target(&file_offset, pagesize);
>>> +
>>> +        if (err)
>>> +            ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
>>> +                       strerror(-err));
>>> +    } else {
>>> +        file_offset = 0;
>>> +    }
>>> +
>>> +    /*
>>> +     * Make sure we can open and map the file, and perform some basic
>>> +     * checks; skip the whole suite if anything goes wrong.
>>> +     * A fresh mapping is then created for every test case by
>>> +     * FIXTURE_SETUP(pfnmap).
>>> +     */
>>> +    fd = open(file, O_RDONLY);
>>> +    if (fd < 0)
>>> +        ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
>>> +
>>> +    addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
>>> +    if (addr == MAP_FAILED)
>>> +        ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
>>> +
>>> +    if (!check_vmflag_pfnmap(addr))
>>> +        ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
>>> +
>>> +    if (test_read_access(addr, size))
>>> +        ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
>>> +
>>> +    munmap(addr, size);
>>
>> Why not keep the fd open then and supply that to all tests without the need for
>> them to open/close?
>>
>> Then, also the file cannot change etc.
> 
> I had a private conversation with Kevin about this before he posted; my very
> minor, theorectical concern about that was that it's possible to pass in a
> custom file to be pfnmapped and I wondered if such a file could map a device
> region that has read side effects? In that case I think you'd want to open it
> fresh for each test to ensure consistent starting state?

Are we aware of devices where we would actually require a new open, and 
not just a new mmap()?

The reason we added support for other files was "other pfnmap'ed memory 
like NVIDIA's EGM". I'd assume that people rather should not pass in 
something that has any side-effects.

> 
> But if you think that concern is unfounded, certainly just opening it once and
> reusing will simplify.

I would just keep it simple here, yes. If this ever becomes a real 
problem, my intuition would tell me that probably the caller is doing 
something unsupported that we just cannot easily identify+reject.

-- 
Cheers

David

