Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AB3EA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80B56B0098; Mon,  2 Mar 2026 10:26:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57A56B0099; Mon,  2 Mar 2026 10:26:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84646B009B; Mon,  2 Mar 2026 10:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C99FA6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:26:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92EA9B6BB9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:26:22 +0000 (UTC)
X-FDA: 84501499404.18.C32C6F6
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4783880010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:26:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=FOM90vyu;
	spf=pass (imf02.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.52 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772465180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+4YQs5Dkv714g1jA2Bzu0uAvZRqeLbRE5ifHWvj8Qg=;
	b=meLXkK9Z9t/upKvNla37AF1hvP2qbTsGJwhMku90RR9gwnTg99mshNxHjRbWOw0lEHWSE4
	EiAn2EGhFCRNr7hw6y6KP6+CoNRcwG9QY/upw5ShjzokYZGxNtHPhK9Zzb7B7yTDzMe9I8
	ULCC9EtWBls8eG8v8k0iWiMcCNxLDaw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=FOM90vyu;
	spf=pass (imf02.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.52 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772465180; a=rsa-sha256;
	cv=none;
	b=rNwVd5JoVLnd0EC/egYjfJVR2dmUHDWfaV/3NpBlUIfvhYucf/Gst0GlLq4rcDDcejdIgt
	WJPDOFhuQfGw6/iUBo7xYNIhU1eBe98yuB0DSdwUkeugyQ6YDR7anKwunj9WMpMSUD0UlK
	UZLr7hUrF8ZqVAyU/e+iHmIGpZhPOi0=
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3411EA80078;
	Mon,  2 Mar 2026 15:26:16 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.35.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 7D1C913C2B0;
	Mon,  2 Mar 2026 07:26:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 7D1C913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772465173;
	bh=5Cq0fVCetPqhcVASCeSHY0gogH2h4nFJPBTkk9lvNfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FOM90vyuh0qq/iMnZYLAAcRptykQDh2Evs1um/z69V2V2SxPiVd1+q4aNOZKbUSwJ
	 VWFbbG+3zsJmk2UJMtS6WXE7q49Q+MIJaILNAj5VBzdt8J83vc9qlJxR9hI0yTjdj/
	 AU6aKrtlQ9jWY04ry3GB2JCeHiPsKiJ0cRKhpZRU=
Message-ID: <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
Date: Mon, 2 Mar 2026 07:26:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
To: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1772465178-3OC3rV38qpc3
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1772465178;3OC3rV38qpc3;<greearb@candelatech.com>;61b5a6caf2130fd460623c1c7a4e3fbd
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Stat-Signature: r1q4hqjp6wg1qya8kwftx56chgbrmkuq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4783880010
X-HE-Tag: 1772465180-333247
X-HE-Meta: U2FsdGVkX18ccZpuYwnX1qHcSl9PsfhgHXaxOu8aTBHtOFF/uqnJR/9J4bRuyP9UMYsIZciIvdKvaR0KniSv/QmPnNU12jpZPyo67zxl21ss9UzL2anw7NwBlz+qhlTgwKEfuF2MRPHZ5DgxseiiViJPqzaHkIJ6l2SziMKi1Mnz9DKD9kqDfickZGRR0R8QPB0F0G1qlfQML7q3aj3ec5mZLKZ5F0eKfcwv99pLXefa/ZJyW6zTIKc1qSg5/0ZfG+1SgtHZfxSJLDstqUBSIeAw+1sgdqnoNqBHtmtRvG5cUkrS0IJToBxBWPj6oc20m6wysdim4aObKKMsYVWdSl10n8RItzbFK1jWol326e91dscbeh2noD5VgnOkGWps2outQly2hmDiVvpaTijjxXbg8BPyV5JMY+Oe7c7fqx4mtr+NpHGC2P8bjPPFW36+fKZpF4XFyseV55r1mnpZ+lc7eJyKvfuVFA+WqnPhs5OWdqDuOwSNHr2FPqW7hM7nyf575vs7rac1Y8uluSig8T5VZ7aB74YXLtPgYjyKmFX+XeNkF9HEoOiOUzrWvkKAYEfEo/pHvcy5rt5ur7ICZNB/U3AlHDWwHykP0bPTAVaF3paoUhfieUovthhpEvpjDw+ey/tVoDtjm2dJ1RHNUf7EZnu2I9vY5BFOI9XF+lbaiAbB8kjlhyCacsmBsTaFtVvYvIvlYXTiVPATdOWnTlAazLjhG4jDmrv6E2L9qhkCn30KywQqmOKrudhfvEOgJaDhQdoXRqiLhOpQmZCnXsfh71N4vKmLBVMeRcSReFWp5y25XmVP3jy3TeClSDNwoe9tqfQsfZDnHkrFAAFuEpLEGlCh3RONz4jxvXViOYNfR3H3YEYxYm7ybOLiOSI/znvhuWdlopUVUrdgQMU+FZIehJXbaglTq+lendQuN8zi1esDzvpxetRwE38gVUxf43lPB1g4rMY8ja1InRR
 MTEXT7Qy
 ATwWRqkEf63PIH9Eqx0OZ12eRZ6tqUmz8l0dP1Y7y50nKBeyy2HRar6b/xzvOyp9qzRubWa46ugiwf78xCJOJmH2XYnuLbgUhDs9CXMrQMcNSCuUWA2vPfKp56QH7CFM+Fx/VpoBwEf6OXZnpyegYAJjKL1Onocimg4B/H2MyfVI70rxXyeJ+iNoycQLZZZ8RVypRguRL5RoEYpIKK0OJZMReM2/+VPPqVMKeV5T44+B8jQl2Uj+Z8mU28g0I9BQJgxi+5JYLEjoZrg/XTso4JZpQPBo3RY829z4bUmEPzkkvPHqeu59FGrQU6bMOyipfmAgAAi0QwQw4lRfsa/khnIanGCU+/QZ8YuftyLJcrTdLWi0x8193AHJf8gfrICtQKv9nKlljWOuoJ/BpT+gLwL3ZQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 00:07, Johannes Berg wrote:
> On Sun, 2026-03-01 at 07:38 -0800, Ben Greear wrote:
>> On 2/27/26 08:31, Ben Greear wrote:
>>> On 2/23/26 14:36, Ben Greear wrote:
>>>> Hello,
>>>>
>>>> I hit a deadlock related to CMA mem allocation attempting to flush all work
>>>> while holding some wifi related mutex, and with a work-queue attempting to process a wifi regdomain
>>>> work item.  I really don't see any good way to fix this,
>>>> it would seem that any code that was holding a mutex that could block a work-queue
>>>> cannot safely allocate CMA memory?  Hopefully someone else has a better idea.
>>>
>>> I tried using a kthread to do the regulatory domain processing instead of worker item,
>>> and that seems to have solved the problem.  If that seems reasonable approach to
>>> wifi stack folks, I can post a patch.
>>
>> The other net/wireless work-item 'disconnect_work' also needs to be moved to the kthread
>> for the same reason....
> 
> I don't think we want to use a kthread for this, it doesn't really make
> sense.
> 
> Was this with lockdep? If so, it complain about anything?
> 
> I'm having a hard time seeing why it would deadlock at all when wifi
> uses  schedule_work() and therefore the system_percpu_wq, and
> __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
> lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything related
> to RTNL etc.?
> 
> I think we need a real explanation here rather than "if I randomly
> change this, it no longer appears".

The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks before
allocating CMA memory, as expected.

And the CMA allocation path attempts to flush the work queues in
at least some cases.

If there is a work item queued that is trying to grab rtnl and/or wiphy lock
when CMA attempts to flush, then the flush work cannot complete, so it deadlocks.

Lockdep doesn't warn about this.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


