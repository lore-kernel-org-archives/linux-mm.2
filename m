Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845BCEA3C4A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B306B0005; Thu,  9 Apr 2026 06:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C0E6B0088; Thu,  9 Apr 2026 06:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1AF76B008A; Thu,  9 Apr 2026 06:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB9B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:52:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E48B1B8446
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:52:40 +0000 (UTC)
X-FDA: 84638704080.12.6C7F4B3
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6910340008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:52:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Epj5NLKY;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Epj5NLKY;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731958; a=rsa-sha256;
	cv=none;
	b=7esEXYroKg02s3wLLxOnNY7UFDzCHGiIdafJmeMPKnVN5NIxLm9x6HLEBxH6b40NmfRCrN
	OeoxNd2z9/7d9PVJndfUt6ahFuZ49WE9E+z2uYKTq/6sJ016RRqHYki/fgGDw+3x8vBzFw
	6jyLhqgaElQ0V4VJ5Aib21QzU6EefiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuouJ5hGuPj+8OpBucBQO1REDxTAFBbB4iqEVWsSckY=;
	b=2szymbZJjGaHq6PVf8tf5B5ooTlM4oIwdf/SvxPbzKAWaYuao9z0B0DRtL0JjJxBpYm2Rl
	RemJxUNjsR38qlemHGPewykkVjxyXpMOTmnEVEbB9x6NSDH68kPz/5E05/4aTM++dZE6D/
	/6J4iS09VLrEgxHWZdVLBusd0Fc4wto=
Message-ID: <408fc657-94a2-4832-b5cd-7013c002403d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775731956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NuouJ5hGuPj+8OpBucBQO1REDxTAFBbB4iqEVWsSckY=;
	b=Epj5NLKYJdYGHLWGVI8zpsduF26q6pYl4ej9eTFU/B3+gZxA1v4rwN7MLujQuwBE8esvkA
	HTM0IoMJKDHP0rXcpUdW0MlNFVMt2U53vEFGsbTASJddvtITIWvpZrZ0dzmI0WgekvpsJD
	S9g/7V92JP6VFOspZsB+htVa4GUFg4Y=
Date: Thu, 9 Apr 2026 11:52:12 +0100
MIME-Version: 1.0
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Content-Language: en-GB
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Denis M. Karpov" <komlomal@gmail.com>, rppt@kernel.org,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 jannh@google.com, peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org,
 viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260407081442.6256-1-komlomal@gmail.com>
 <20260408123700.1596800-1-usama.arif@linux.dev> <addcUpxfuR2llaiW@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <addcUpxfuR2llaiW@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6910340008
X-Stat-Signature: n995exnkwd9khwx6if1yg4tm51bonfxr
X-Rspam-User: 
X-HE-Tag: 1775731958-292741
X-HE-Meta: U2FsdGVkX1+Xqkqtckc9dsF9DY/bCn4bKK2hbcKFqh6dTXSZoMZH05g7D1bmrDMAhYFZ+hKxFpqLJ3+9aIMkX5U5bbupaSBH25kkpigQGJcwK+wsQetYJwF8iaZfJmB58KFXzot891gqVDlS/K2ZScntRoYn04sTDRy8MnQc3dLgxtZ9fxx6OLLIeuKVhhAKuOWpg4tbqJM+r3TAXzeudNsDdTN5LUW58sLfSdEt3bpewlj72zxS0KgrMv4fLhc5btYK+2n434ZBuETwuOvXvBzDNe/nqOuPMCOgc17zHGgV00EO/JZMIM28/EyMVJDjL/HubZhU34TEZ8GcP2C259eRHmATQgAeg10kMCAN4yspYqLHHpB6RcjeZwVuC1z9RlVNP1lHv5ci5A0IJ6rZIeO+cyU/sWDLLs7s+tqMMe3WUuDcO1nReZknWAXX1Ie/xpdqi06dSxs3alSXaVAOLhy4As42QxDlehDIGIFWApkLxxdKr7Jy6QbXHeb4NcIRjJ9DIAWQ3VuIUpDRCiTse2AlXMimSZTwKDXs2gb4jmii0mOfjVfxrnCPLDiDfHb8Ozx/DLTZQlpHU2EHoBlr9ksfk7hX901I7JDmKi8eA8qmgoP5iiqM6XbppsCIs+pw44gI7DcUiUk6Aepk591hD7mqB0FqYmd9lYFeIW7ikY9VTzsKLc0I8hAhzV6MACFicZtkJIC2691lG4HwumkhsHKoZP2QcVHUU5755XE0e74jH6A8nRAwxRQc9Jl03Ve24JAYyxZdgCKx+mnu3nNgAOeOw5rR8KZ0/PN88rTT2AXnmcMVbxNV2kL9vXWARN689Z8HmPafWiuh1DeQU4H6RLAG7YS0DfjGudZ/l2LTY7T0OjxZBlquMOh2nS58FKpfDT8M8Yda46LaW0XhgtEay1BqDx09TqzuE09+ruO4lHQBwG+1RNmxo8VuJthZrotIVZBdr79wCavLfWtVRcb
 L4r4X6tC
 ecFRkj+E/fULt0Qj/AhEH/en6hBHU0efKwqwKHnko+Eg2O9NcwRInBseUG3n1NILV8zyz1dLdEmZzlnU9zYS3mgQDtPNclwX+WOlwVKfYtEWJXlNEodjUjFgeQ9X76353En/y+jJqH4It3nFwD4XMgGVzT0im2vkQ3GGzz6x7sa4ApLBG6T0Kva4LTHnLpk/KCeSs0y0jZLF+/I01CBILMcV+jSUd2kbkilpYEx0ZCR+wccz/DjreBIrzFfepCyJ4JIJ6VPu6pGBwn+eE4kCY7n4cDOj3yq7q9MNqeAmJukZ6c+h9XpJGEHSy98x8Z9achxEek43jUQzEXwVufr/El1yt0qufmpYvCNVJ2tOLVYdX+4r2MiywvHlg67sXRggXFq7I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/04/2026 09:01, Lorenzo Stoakes wrote:
> On Wed, Apr 08, 2026 at 05:36:59AM -0700, Usama Arif wrote:
>> On Tue,  7 Apr 2026 11:14:42 +0300 "Denis M. Karpov" <komlomal@gmail.com> wrote:
>>
>>> The current implementation of validate_range() in fs/userfaultfd.c
>>> performs a hard check against mmap_min_addr without considering
>>> capabilities, but the mmap() syscall uses security_mmap_addr()
>>> which allows privileged processes (with CAP_SYS_RAWIO) to map below
>>> mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
>>> dac_mmap_min_addr variable which can be changed with
>>> /proc/sys/vm/mmap_min_addr.
>>>
>>> Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
>>> with -EINVAL for valid memory areas that were successfully mapped
>>> below mmap_min_addr even with appropriate capabilities.
>>>
>>> This prevents apps like binary compilers from using UFFD for valid memory
>>> regions mapped by application.
>>>
>>> Replace the rigid mmap_min_addr check with security_mmap_addr() to align
>>> userfaultfd with the standard kernel memory mapping security policy.
>>>
>>> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
>>>
>>> ---
>>> Initial RFC following the discussion on the [BUG] thread.
>>> Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com/
>>> ---
>>>  fs/userfaultfd.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
>>> index bdc84e521..dbfe5b2a0 100644
>>> --- a/fs/userfaultfd.c
>>> +++ b/fs/userfaultfd.c
>>> @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
>>>  		return -EINVAL;
>>>  	if (!len)
>>>  		return -EINVAL;
>>> -	if (start < mmap_min_addr)
>>> -		return -EINVAL;
>>>  	if (start >= task_size)
>>>  		return -EINVAL;
>>>  	if (len > task_size - start)
>>>  		return -EINVAL;
>>>  	if (start + len <= start)
>>>  		return -EINVAL;
>>> -	return 0;
>>> +	return security_mmap_addr(start);
>>
>> Is this introducing an ABI change?
>>
>> The old code returned -EINVAL when start was below mmap_min_addr.
>> The new code calls security_mmap_addr() which returns -EPERM when
>> the caller lacks CAP_SYS_RAWIO. Existing userspace callers checking
>> specifically for -EINVAL would see different behavior start is
>> below mmap_min_addr.
> 
> You mean API change? :) we don't guarantee ABI for kernel stuff anyway.
> 

Ah no, I meant ABI, I hope :)

The return value of validate_unaligned_range() flows directly back to the
ioctl() return value, which is visible to userspace. The error code a program
sees from ioctl(fd, UFFDIO_REGISTER, ...) changes from -EINVAL to -EPERM for
the same input, right? Its probably not an issue, but we would need to update
https://man7.org/linux/man-pages/man2/ioctl_userfaultfd.2.html
right?

