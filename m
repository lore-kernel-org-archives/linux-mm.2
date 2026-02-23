Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE37EA4FBB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4D36B0088; Mon, 23 Feb 2026 08:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCA36B0089; Mon, 23 Feb 2026 08:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFD16B008A; Mon, 23 Feb 2026 08:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 096256B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:17:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B114136D9A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:16:59 +0000 (UTC)
X-FDA: 84475771758.21.7299943
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E41B91C0011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:16:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYgK2zjM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771852617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAY9pJsCzmYOt89xnCI0bApB7GvRW+97N7PKe7fZzuU=;
	b=MhWLlwvRdFiEmyP33XW6/JBu4q7pBLfU9o9fd3GnhSRAqr+5cQ6fa83LdMUom1rmsHXWsK
	GRvAKSp2Rb5oo8fKsIiN2M3M9D2SFLbwZAAl0LcxyHvonJb8nFaTkAC1JPddezJP3fs8mf
	SiicmCK2T7QcY9KOh3fPNeXMoF8m3hc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYgK2zjM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771852617; a=rsa-sha256;
	cv=none;
	b=rlzvVx+R43acbJFnSkHw8wiqFx5Aj70HsQH+ZlPemikQsjTaaO4K/Clo79l6TdtZ6oab0M
	RVQw0kB5NNacVC7ftch781nbuPsJA0rRgTSY9P86FRcZCUeJi+0x0c5HRrNsRRrZoUdUXl
	w4ewgxmc6m9MXIEVVM5NlQrVRB0qhwg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 585BF60018;
	Mon, 23 Feb 2026 13:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8F3C116C6;
	Mon, 23 Feb 2026 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771852617;
	bh=79ojPEny0OseqEFgUnOWpiypR/GdZczrGqB0wGH5jDE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LYgK2zjMS2/60iBvFKXAn0KYpMT6XMLbnhrdo+aV5QAjiDzMsMFz4pGREkqYWj96w
	 I6LvtG9NLWdEabLJIyQl3Aj1XneN4fVw0T7/jyiAJp6pipk/Gkb+gmOGitbn65eLQb
	 urOqtm8YjZlAJuqo38ozvQE/PshPN0agxtm9wGx1s/TLk4y80Usmajwvyutf3mObsI
	 K77oF/jSMYLEoSbJ725v5zeKIzBIATPFV7CnAK0vvG/vZICtDD/k9aS1c1gyqmOhem
	 iBXeY1n8f/KB0KWHZQI6+MvDpIp7RMzyuxis5fe5RUkHKfIoO9DwlQuOPcZ9Zk1HX8
	 SWbtRzF0eIQgg==
Message-ID: <658903fb-cf3a-43c3-b8c0-d47b63d10782@kernel.org>
Date: Mon, 23 Feb 2026 14:16:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>, Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
 <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E41B91C0011
X-Stat-Signature: 634snsz9fmaeqexbwbhoi3kk4aa3m7cr
X-HE-Tag: 1771852617-17563
X-HE-Meta: U2FsdGVkX19ovX4xtIAv3V+nPADG8wpvOlfXZnA3z6Y2c4/Iq8Y/qusz7KNn8Xb63c4te8SXL494UA2EnRy24QocVO1wvRqQRCQ3OpEseiS7pl57zKRa93d4WFiQW8Tv1kocJqvvyZJhGyIMGYaK+Y7qk3SY8Z1JghE5OTIIwDZbEwxwI1IjRONOxfoN9dpdOW3jdH4YVML9WF3J99/UvKSNBg+JI3VJUWGmNXxFJh+Cx9QwHwNdtUggamIQer1SmSmCJdi0ce1YeFRc4pClpWuRD+qtD2I4ZYu/sYvPZuMcYmUBaKc3Ui1AK+6BcrLjL1qeDRSqfswrCp0qg+0+RGHhqkqwCfZx0ArR2rsCNzB8cQM39BUirtMkDuogfM5beSllLlz2k1rau2wNyXiKrxIfW9qyb8STqm5u6z9gFJ04fz3hpVe6V7tVFVrOjLVFbo5R9ixzVR8c8eJfvTUL0X2M+FY32NwWkhTHbw+AA6+UVPsZ9bISY1G79QwydFyycLvLYkWaIA8YTe2rjP2LjPwA8WU8dpQ6WE3r/4RB8VDPQ3UqPEm2Am0hDCeEThL+y9mNWCyyQa+BB/1d9NielnvFp7mHxNVvLvjWWniTgttZyQE+FWsI2OF40XsJzOV529gmjpaUYlQ5FUHgWtGu5R0FfR198vU2t039wdSVUURuKKmYOUzfWvxykOCMQWgSSZpbhHN1xmI9vdNIY6C68vMtEEBHHyt/pyuf9FdOEwBTP6GPpIpzQ0eOQSk0EbD9lA/YFG+hCr53libNT85H3oerOlPfrJP42on71atksWrsTZGWMUwiPEY6B5CnHrSZx3F7HhyKRgI2BIFEZ4I4Zjmviev+eopl0DKlItBPByCDj+ecMIeZAUh4F7TvyA/0xyOFZcViA2TaP0x5vY4GtqwrreENqJoM4WUIoeVQmwj8mqarFwxhCITwAXLsCdwLmAY7MXlRTnMPbBsexmX
 bE/fbRCL
 zcSJ29WRFIC4Ic1qxHajiESuvRuomytZJ4J1enrPTOsXFSjPCtFPB7buHbmeI+SjBINQ3SQJPFVJbkoCJHC41XjZOqEDMGJThy5z2AVYncyyEDUnngr0XoSBw+FesBSH9J3TbWM2bNbVJD6824qD3xzDBsu0l/gG5I92L4xxs8/zUfASC6UAVgVOo6UHqyjkwm3+5PUUm7PmVm/y/pbL4RzkL/o5gUPdulkzdzvLRg7u40N3lIZlCLwt9zVxNKHQRyhKxZvgDjNcLxykeeG2zKP5FcCRHKFnel5jBiTOfHHRtaF7xF1Iog0r07g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/21/26 14:38, Vernon Yang wrote:
> On Sat, Feb 21, 2026 at 06:27:36PM +0800, Barry Song wrote:
>> On Sat, Feb 21, 2026 at 5:40 PM Vernon Yang <vernon2gm@gmail.com> wrote:
>>>
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>
>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>> continuously access 128 MB memory, while the cold task only accesses
>>> its memory briefly and then call madvise(MADV_FREE). However, khugepaged
>>> still prioritizes scanning the cold task and only scans the hot2 task
>>> after completing the scan of the cold task.
>>>
>>> And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
>>> that property, so we can just collapse and memory pressure in the future
>>
>> I don’t think this is accurate. A VMA without VM_DROPPABLE
>> can still have all folios marked as lazyfree. Therefore, having
>> all folios lazyfree is not the reason why collapsing preserves
>> the property.
> 
> In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
> attribute, which is the root reason why Collapsing maintains that property.
> The above commit log clearly states "all folios in VM_DROPPABLE are lazyfree"
>                                                  ^^^^^^^^^^^^^^^
> (the "if" is redundant and should be removed), not "all folios are lazyfree".


Exactly. folio_add_new_anon_rmap() makes sure that all folios (except 
the shared zero folios ;) ) in VM_DROPPABLE are lazyfree.

In fact, MADV_FREE should be a NOP on VM_DROPPABLE, as 
folio_mark_lazyfree() doesn't do anything.

> 
>> This raises a question: if a VMA without VM_DROPPABLE has
>> many contiguous lazyfree folios that can be collapsed, and
>> none of those folios are non-lazyfree, should we collapse
>> them and pass the lazyfree state to the new folio?

I'd assume we'd only want to add support for that when there are actual 
known use cases that can trigger that + benefit from it.

Adds complexity.

-- 
Cheers,

David

