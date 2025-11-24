Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 563E2CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19D56B0008; Mon, 24 Nov 2025 08:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0966B000D; Mon, 24 Nov 2025 08:58:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06A16B0010; Mon, 24 Nov 2025 08:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 889BD6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:58:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A3ED4F04D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:58:10 +0000 (UTC)
X-FDA: 84145654740.20.144F5D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82B2610000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:58:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WDIpPF/j";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763992688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYQMhVSYO3d5lT1Rw6KzIqKorc4ImaPCKf89Hh0P4wo=;
	b=j/xkF4fnJw4nnuNGIRBvQK3jiE/xigghBtJBur/l8NoBaqY8AI+FylpMzyVUI8jx1RBy/r
	vHx9aEpp0GAGS8Z8q+fyoxRGRZcySU0RheW/HgAxj1sx5+GKcARiyblBpjXMQpZZNTYIiZ
	0CeXzeB3k3kG5EcOD2EEqYmz4ypqOd0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WDIpPF/j";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763992688; a=rsa-sha256;
	cv=none;
	b=kZSSGDJQPVlRCdpl31KcXHiARIyeChtXna3V4mdVCdC9GCOkxB/mIhuQP/2F+soVqLVL13
	hHrsiIfYs+Q2UZXwUOAnOlkl29MExLZfQ0qogXmpNTXWxpY0WK3AlAr5jFefKGli9CzJdL
	4dSBZTy+UURrXaJldjwe3/1Vu0pMQDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BDD242AC7;
	Mon, 24 Nov 2025 13:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DC4C4CEF1;
	Mon, 24 Nov 2025 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763992687;
	bh=jH2AxFvj9FK1wwbRSCm+4BWILbLVHHZ1oPWZAimqbi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WDIpPF/jSgYmeTCYWbDH96GOkZoH4aHDi9ZHJdRTIms9WCI4RAwHdEacNBVWkDfFu
	 ivVgSfYkPwfo08jrEXObIqWrerwrryN0F/Q4T4EWDx6DUgJ//ScZNH5o3S20HqCQnf
	 sNC18iXSU+i6ush87zA5Ai2FbGDBiRhNmBmO9oIhGMNc3ieYsTMgB4fl/KVhZtZokR
	 +xoVaj/XtY/K0hStlQxhMqKnnsNZCZrlDBc87Drp8cCf5VC2UniBLvlmHMVjieGY9U
	 MleuU0mNtfJxN2RFctHFTqEOrkBfFzUK9Y8hCbZtcZSpeu9ENTIa63JNs1yGGmB1td
	 FAkHnxIK9IEIQ==
Message-ID: <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org>
Date: Mon, 24 Nov 2025 14:58:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev,
 athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com>
 <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82B2610000F
X-Stat-Signature: ems5bap7epgyqix7t39fkhdh5gdqaptb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763992688-788024
X-HE-Meta: U2FsdGVkX1/bHlp2XXa7FQJpbf2CzXyQGrKAlFbqyTfTgnI6pCqPscz+89ZTKX7GlDANJWCbbdF1d27343g8vrarjRlcGCIGBrj3zJDknnwTohwevAYH1xhkJ6l2JuP63yJYhIoQTkq7yw4xV5PRMDb5HLG1+GtNmMf+Dziq07G2XJ5n1xBsWXp4gw10BN3Vr4/EBWYs2A6DUV/eAeBQGdUpiyUaUb2Q4I/w7A3DdZdxzDVXLkH5b9ex9LvEvRTgMhBdkTrj5PQwfg5QHECYcs21UftpTrEPNEIAoooqFtdGY7+g16DcU7QpeCsK0d8So+zTaVN6ZLOZLX2M0dK7XKcnroPP6wOjiGSnf7ij++8PZBqqgqmF+e52AL8Y7j2HMDTbvhqFKLPQKJys0RmPUsEvcOeNEs1MsJlMBKBAyVXHiP+E0Hyw9P9axfbVwY9OVSBryXTYwakkFA71ajw9nxRlgMfnX9iv/jW0BCKWY7WmZ07+QZN345duAchE7hytbXY6HJh4nrR5s/6t4rPeQYd8oBSm4nIEs4zeo5rkW+lVuJLsXnGpNeNRtPfakhZyS7SKaaepTkXxmWmzu9u3UkHc2wh0eNf2xZpnGgCvD19dvm80xBke5SHE6k0LRjJSNQxmJJi0nLMetSz5/EtEVmrR55A1Y9dydpG0M7Rc3Qoz6kNlOGPe2lloK5KNjmjSZIxv1qKfsFaCyeMg/DwlsOBMnms/JxiSETsKc+rpmy1OtgH137XyNWkDg69vF/CiAW4ATzqG0LCWqvG+Fn7U6Id1es1ONws2dX2LF8FPMRjhRZ4DSFYQJUpngdQgLIsHXhwiCF5QxmZG6G5sQR4sS97r9eTpeRU+IcD0IXiCLvrsYiYVwca2zxfJCJ4U9MnN+ud2JmrvjVJtO/1hPxY9ric3JFpkr6OnxHHHFF1WpQsuWFKDgvzJQUKsFYJ5gSS9HhdThmN0j3GrVJdClvP
 HE5mpqaI
 jmMj9rEwmrgtnRPuvlGVqZGiDSwS6rBzgvmQ0V8CpJ34M3IcHTCdVcER6mRmwYdugM0inccHnE+LqKRkywotGizPKQNwrvJuG3fEUPhKdFr4txkRXy/6iVlCYNfjJEeork2aamvrpeguF3ip3V5NPVrogdNdeiprjM8y71eYPI65Cb2c13pZqMzuqxT9/OpuazOcnMzu+U+ZlHSQI4z8D2Mh4vt4RR/C48OgknoXV02utZC5h0Y4EgrsisSarAHoL+xx1871q4ftoJyTGHaaaivcPPdzAzA8DGlnxk9eG7TPevM5AEobCXLK/8JXrgy3Tnyi8M09tiaxYPmgzcrcO4WsEbFJgJoSJNJDKRPTUpugk2JQuVasGIdRqFo47CordK0yRYXXnLKE1udY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 22:20, Joanne Koong wrote:
> On Thu, Nov 20, 2025 at 12:23 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
>>
>> On 11/20/25 19:42, Joanne Koong wrote:
>>> During superblock writeback waiting, skip inodes where writeback may
>>> take an indefinite amount of time or hang, as denoted by the
>>> AS_WRITEBACK_MAY_HANG mapping flag.
>>>
>>> Currently, fuse is the only filesystem with this flag set. For a
>>> properly functioning fuse server, writeback requests are completed and
>>> there is no issue. However, if there is a bug in the fuse server and it
>>> hangs on writeback, then without this change, wait_sb_inodes() will wait
>>> forever.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
>>> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
>>> ---
>>>    fs/fs-writeback.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>>> index 2b35e80037fe..eb246e9fbf3d 100644
>>> --- a/fs/fs-writeback.c
>>> +++ b/fs/fs-writeback.c
>>> @@ -2733,6 +2733,9 @@ static void wait_sb_inodes(struct super_block *sb)
>>>                if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
>>>                        continue;
>>>
>>> +             if (mapping_writeback_may_hang(mapping))
>>> +                     continue;
>>
>> I think I raised it in the past, but simply because it could happen, why
>> would we unconditionally want to do that for all fuse mounts? That just
>> seems wrong :(
> 
> I think it's considered a userspace regression if we don't revert the
> program behavior back to its previous version, even if it is from the
> program being incorrectly written, as per the conversation in [1].
> 
> [1] https://lore.kernel.org/regressions/CAJnrk1Yh4GtF-wxWo_2ffbr90R44u0WDmMAEn9vr9pFgU0Nc6w@mail.gmail.com/T/#m73cf4b4828d51553caad3209a5ac92bca78e15d2
> 
>>
>> To phrase it in a different way, if any writeback could theoretically
>> hang, why are we even waiting on writeback in the first place?
>>
> 
> I think it's because on other filesystems, something has to go
> seriously wrong for writeback to hang, but on fuse a server can easily
> make writeback hang and as it turns out, there are already existing
> userspace programs that do this accidentally.

Sorry, I only found the time to reply now. I wanted to reply in more 
detail why what you propose here does not make sense to me.

I understand that it might make one of the weird fuse scenarios (buggy 
fuse server) work again, but it sounds like we are adding more hacks on 
top of broken semantics. If we want to tackle the writeback problem, we 
should find a proper way to deal with that for good.


(1) AS_WRITEBACK_MAY_HANG semantics

As discussed in the past, writeeback of pretty much any filesystem might 
hang forever on I/O errors.

On network filesystems apparently as well fairly easily.

It's completely unclear when to set AS_WRITEBACK_MAY_HANG.

So as writeback on any filesystem may hang, AS_WRITEBACK_MAY_HANG would 
theoretically have to be set on any mapping out there.

The semantics don't make sense to me, unfortuantely.


(2) AS_WRITEBACK_MAY_HANG usage

It's unclear in which scenarios we would not want to wait for writeback, 
and what the effects of that are.

For example, wait_sb_inodes() documents "Data integrity sync. Must wait 
for all pages under writeback, because there may have been pages dirtied 
before our sync call ...".

It's completely unclear why it might be okay to skip that simply because 
a mapping indicated that waiting for writeback is maybe more sketchy 
than on other filesystems.

But what concerns me more is what we do about other 
folio_wait_writeback() callers. Throwing in AS_WRITEBACK_MAY_HANG 
wherever somebody reproduced a hang is not a good approach.

We need something more robust where we can just not break the kernel in 
weird ways because user space is buggy or malicious.


(3) Other operations

If my memory serves me right, there are similar issues on readahead. It 
wouldn't surprise me if there are yet other operations where fuse Et al 
can trick the kernel into hanging forever.

So I'm wondering if there is more to this than just "writeback may hang".



Obviously, getting the kernel to hang, controlled by user space that 
easily, is extremely unpleasant and probably the thing that I really 
dislike about fuse. Amir mentioned that maybe the iomap changes from 
Darrick might improve the situation in the long run, I would hope it 
would allow for de-nastifying fuse in that sense, at least in some 
scenarios.


I cannot really say what would be better here (maybe aborting writeback 
after a short timeout), but AS_WRITEBACK_MAY_HANG to then just skip 
selected waits for writeback is certainly something that does not make 
sense to me.


Regarding the patch here, is there a good reason why fuse does not have 
to wait for the "Data integrity sync. Must wait for all pages under 
writeback ..."?

IOW, is the documented "must" not a "must" for fuse? In that case, 
having a flag that states something like that that 
"AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we would want 
to add to avoid waiting for writeback with clear semantics why it is ok 
in that specific scenario.

Hope that helps, and happy to be convinced why AS_WRITEBACK_MAY_HANG is 
the right thing to do in this way proposed here.

-- 
Cheers

David

