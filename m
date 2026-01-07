Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65ED9D0D176
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7936B0005; Wed,  7 Jan 2026 17:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93E36B0093; Wed,  7 Jan 2026 17:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7956B0095; Wed,  7 Jan 2026 17:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC2236B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:19:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6359A1A04D0
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:19:52 +0000 (UTC)
X-FDA: 84306586224.11.3BECB10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 887B54000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:19:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kksnc29x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767824390; a=rsa-sha256;
	cv=none;
	b=zL8wE3kL66dMlUpvlDTWcNOWf/yHEfBrZXsofliNcgjxkm/+Xn/mP8vhAfEWyM8wm2u6Kh
	r2cIt1c/JEh/tbv5p0S5Mxrj/prmXRJujG0GUErsT6H4hYfx9T9i269FphCcw2VGISNkGW
	OprZ9O4dFY+ttzLSRZNClujlP1e2D94=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kksnc29x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767824390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlfzTLYwYr/0aX4yVGoUr7AP88iACg9G/e7VhTU8WoE=;
	b=YJQNWDrUArypYnDnhMdeH4UNZTJ1uc+oUGHkfHSw6UPwCEPQm9SN5kTIWEEzdnQqWTkqrT
	Qn1dJnjELhfU/hnDM2yYWyeD+62rpV62YK4cOuZGTWzSApVsQYgDzIG+qJrf2uxDuFcT7z
	xGFNQob4+jDJR7Y1rG7Rh5XvAIbifFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 979BB41765;
	Wed,  7 Jan 2026 22:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27543C4CEF1;
	Wed,  7 Jan 2026 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767824389;
	bh=zhOqkkbLugaasC0FIugMFKDX8x1sH2DgFAam8cl8VLg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kksnc29x8KXtIay4NWkf+jDwhwF3VVeD1VDejDabJZFig/FSrVfdi+U/J9moIbIDG
	 Y8b8jIgwuS0RJW175tfgD9BY3U+3nCdqibLiEK7bo3CrObT43L5XZ9dl8bxvabxmij
	 IW0iJbShaOCz4ebFxudCBi6X0eFJxtj+6IhN2hqca1obKqHFVmvEMnKEtBlfbgXAUp
	 HDezVJTNSOoDJhE5MRPpRTrebOs4DaFqCqQ0NwayJkys/dvnDHEMsIQTrwg0mejO37
	 /xvsVART+BTCk7TVC9NFHSdPRsQuWku3fy4IfG8+p06b4vxHTdEVy07p7BE8zwjfca
	 mw4SOmxC7aFxQ==
Message-ID: <1ed7a709-27a7-4309-bb41-3f6eb933f6ad@kernel.org>
Date: Wed, 7 Jan 2026 23:19:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
To: Vlastimil Babka <vbabka@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
 =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
 <5dfbf2f9-0948-cd59-5c59-a6ee946ff9f2@redhat.com>
 <16dd4c62-c763-42fd-9ff1-a6dfcdbab109@kernel.org>
 <26ec5b50-1bea-4a62-97bf-56162bdac4b9@suse.cz>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <26ec5b50-1bea-4a62-97bf-56162bdac4b9@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 887B54000D
X-Rspamd-Server: rspam10
X-Stat-Signature: pd8kmys7umn4uudkd7nktekep6o17n1n
X-HE-Tag: 1767824390-307574
X-HE-Meta: U2FsdGVkX1+BVtcX6LU5yulJwL6kv4GohVAZLt8Lyy75/bZTauBf+F+6UZEONjQ0q+zCQ+k+HaRhKIlt3Frr5z5eODreU8g+NinnxKrA1pz1m1REZQIyGEbnOSiQSW1652DvFNztxvqYPCmXjasgLKOB7E7k0A3MNPSeQ7vLQXchPulIabJFDs0FmT9c7rxr1xXBczw5VNqXrnoySlBJ+BtPKCQEWm7vgBPd/jpihrTGv2roO8Y/zs9I5DOyy975p03E8rFb/AwX6lC+U74NWJ615vwE63LYVt3jdzeKFUOcdKWT5bTlatgPitylRHUykjebJWI52Kkxat3Ig93fhI/bbSl4NhjpSxDG/yuet9iyOWsIU7sspWJMpumb1/afZu+5tp/eVODFQdtAh6Haow0MguWooRLTUfBNiS0mXCoi0TCvW6pF7Tq8oZxM/XEdw+hS+jVYTjm5LMCo5oMCjyAyWIdlJkNes0TSrahFT/Jsiq4Gvo4Mu+0S78pMmhzS+nqCWy75l2YjfUmyLO5SBbvA+eSrJSJ88lUanTj1suzrgJglZeV1CxcCFr9f8XXPCRvk5H+2LasOe9gRNHRQWoFrVyxGNw2cQTDuiFrH8icnGOT7xYzr9TDUExd8bbJ7/TajC48Qwy7N58o792/DW6CC7dN2pszUZh6y5cUu0ul+VoXmRQxWbEmKFqwqQFF1Vqy+N8r5l6387A68xOJuGMJkOeajbCvLOhXOlAULDcmJ+U0guAPozY5d0L2GMIWvGRLiUyby7R0cHDp5JVnhQ0lc9U/o2dEDpFRoFoXAEyBSYbujtm63merG+ijWervqTBOqN6nO0JyiKwgN/Vpja8bKRSNMp8eewAwwxFTHcJKX6KKjiqJg281OlLtVvK+8AyG6LZPGteZ2MDGCcNz4/ZCdiV5zMXYhMX5AnTeklUi5c4pht8q/norvsFEjt90jdsj1ke/OmdV9NNyId/u
 +jeAgVeS
 56+Q4dhHx6MBsXD+JlL1WZ3As+GVkgxoG+jg5hqD04qijL4udkWv2Vv376p/09vT1s4c2USNpLoQOAbnisToQTigxB7m6zBp7yYGNxswg9HLlw0DOqFT68j4Uw6z+ILT9116LkyWd4AONblpA3hsTV4+pOvRlhNFE4vQbvKeYR/VhGb3/E3Ll8s70JkwDMdKky2O6l/HLwpfNXW4EZlvwq+wpKu1ww8gToOL00PpL5czB2b1ChFaLIbPppbgi96jxXRLh4VyTHtr11L1Qxc+nH7RP4zh6vVrAarWD50mymCDFbq+O+tHQ4EYF0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 10:55, Vlastimil Babka wrote:
> On 1/6/26 16:03, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 13:52, Mikulas Patocka wrote:
>>>
>>>
>>> On Tue, 6 Jan 2026, Michel Dänzer wrote:
>>>
>>>> On 1/5/26 19:15, Liam R. Howlett wrote:
>>>>> * Mikulas Patocka <mpatocka@redhat.com> [260104 16:17]:
>>>>>
>>>>> I'm not saying it's wrong to change the signal handling, but this is
>>>>> very much working around a bug in userspace constantly hammering a task
>>>>> with signals and then is surprised there is a response that the kernel
>>>>> was interrupted.
>>>>
>>>> I'd go further than that. If user space fails to retry the system call
>>>> in response to -EINTR, that's a user-space bug, period. It can happen
>>>> anytime for any number of other reasons. (That most system calls happen
>>>> to get away without it most of the time doesn't make it not a bug)
>>>
>>> So, I tried this - just for fun - and the machine doesn't even boot. I get
>>> a lot of errors about inability to open particular files on the console.
>>>
>>> Userspace is buggy, according to your definition, regardless of whether
>>> you like it or not.
>>>
>>> Mikulas
>>>
>>> ---
>>>    fs/open.c |    3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> Index: linux-2.6/fs/open.c
>>> ===================================================================
>>> --- linux-2.6.orig/fs/open.c	2025-12-31 20:10:31.000000000 +0100
>>> +++ linux-2.6/fs/open.c	2026-01-06 13:28:01.000000000 +0100
>>> @@ -1419,6 +1419,9 @@ static int do_sys_openat2(int dfd, const
>>>    	struct filename *tmp __free(putname) = NULL;
>>>    	int err;
>>>    
>>> +	if (current->pid != 1 && !(get_random_u8() & 0x1))
>>> +		return -EINTR;
>>
>> Reading the man [1] page user space is only to expect EINTR in case it is
>> prepared to deal with signals (install signal handlers), no?
>>
>> There are some exception documented:
>>
>>          On Linux, even in the absence of signal handlers, certain blocking
>>          interfaces can fail with the error EINTR after the process is
>>          stopped by one of the stop signals and then resumed via SIGCONT.
>>          This behavior is not sanctioned by POSIX.1, and doesn't occur on
>>          other systems.
>>
>>          The Linux interfaces that display this behavior are:
>>
>>          •  "Input" socket interfaces, when a timeout (SO_RCVTIMEO) has
>>             been set on the socket using setsockopt(2): accept(2), recv(2),
>>             recvfrom(2), recvmmsg(2) (also with a non-NULL timeout
>>             argument), and recvmsg(2).
>>
>>          •  "Output" socket interfaces, when a timeout (SO_RCVTIMEO) has
>>             been set on the socket using setsockopt(2): connect(2),
>>             send(2), sendto(2), and sendmsg(2), if a send timeout
>>             (SO_SNDTIMEO) has been set.
>>
>>          •  epoll_wait(2), epoll_pwait(2).
>>
>>          •  semop(2), semtimedop(2).
>>
>>          •  sigtimedwait(2), sigwaitinfo(2).
>>
>>          •  Linux 3.7 and earlier: read(2) from an inotify(7) file
>>             descriptor
>>
>>          •  Linux 2.6.21 and earlier: futex(2) FUTEX_WAIT,
>>             sem_timedwait(3), sem_wait(3).
>>
>>          •  Linux 2.6.8 and earlier: msgrcv(2), msgsnd(2).
>>
>>          •  Linux 2.4 and earlier: nanosleep(2).
>>
>>
>> So I would expect that your test code hear breaks user space.
> 
> Since the patch is dead now, are we going to update this section in the manpage?

Yeah, I think we should better clarify the man page to whatever the 
result of this patch set (and v4 that was posted :) ) will be.

I'm afraid I won't have any capacity for that. @Mikulas?

-- 
Cheers

David

