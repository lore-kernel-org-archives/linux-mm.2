Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684CDF433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D986B0005; Wed, 15 Apr 2026 21:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E3B6B0088; Wed, 15 Apr 2026 21:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923B16B008A; Wed, 15 Apr 2026 21:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFF16B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:22:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED4F71A0755
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:22:49 +0000 (UTC)
X-FDA: 84662669658.04.66BD246
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA93C160003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:22:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EWG5oybv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776302568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0bEAAbgBNmbxicu2CtQb8Q27gLpg83fQgDiS0p6Nz4=;
	b=qvvq2ptATK4yDc1Brp2DGCRZb4ZTZGsRZL7yA8SwPqZ6/LCK62W6MuuUBFFy7aTM59NdXf
	3jVIF/GeAkFA9MRPRJazARHGcWhx5kqNaj3HowLPFDDR+wuEDVzOVezAktBTvo71bqP/Q3
	95NJ40hxxNGjSMOSxJq9XrRLSrar1Xc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EWG5oybv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776302568; a=rsa-sha256;
	cv=none;
	b=zCkcdo7vEkegILv5p97oXTtPoYeTw0AhqJFQXP/lw0bL5ljSzIwEYd/MesW04cLwjnAyao
	b/1u5Zvk+wbLfRVmlMCLc3PG3fer6NHFmrCHKt/sVaMGazqj67HErdw6wiHDr/IzN1feAr
	/1G90JsveGF5NSGduVOB13MwGLejaEk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776302562; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=M0bEAAbgBNmbxicu2CtQb8Q27gLpg83fQgDiS0p6Nz4=;
	b=EWG5oybvxIkX9t8vcE78+GmHJsxURoAXQb3IXDWC1aITG6x5nAwZHUKVoFZtGJNtnt30/vsAlF3XEsSlIxAA8/0ck/oAzdMWW8+QF4el8teSQUQUoQgJoDys+e7AvSx3gbDuCEsJ4pInr9WQ5qN9d8cinEQCZ97kVwqV2QSht0E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X16GTzA_1776302561;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X16GTzA_1776302561 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 09:22:41 +0800
Message-ID: <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
Date: Thu, 16 Apr 2026 09:22:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com, willy@infradead.org, ljs@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA93C160003
X-Stat-Signature: gp86zgtuui4r7yuxo4x56uxadtnu19j9
X-Rspam-User: 
X-HE-Tag: 1776302566-328127
X-HE-Meta: U2FsdGVkX1/dgILsKveJrSZMy6nCmUT18fzRDGNberib6VLMNKCzijt5zqaytQBWWCMb2Cyx4TmCFJ3qfO/og6AkFIzDdN5isKGvgDQkeOQcHqrv2fLl3MQrHLszzehOZgmAKN2fEj3qB/WbTrNY8o0KLMTp+1y53MpLN9U4V+/pO+8cMyufi5ir/2OFCiftpEyHt9gOBFA4eOXfKDNOpPd7qE4tYZCXcFhS+s6gcCvHmPVUXa5/tk25OrILLYptBMcIHTujLC5lAC0Tz7Kt9n4scnDIvE1Ms414btRkrOxEREjXqNG/Fe1GFWLjs514XmGeP9KapzIdwiBTZWX1all36ljhYahEr/24XWCKrcNw3Ec+IJQfRWDoPXuHhu85hRJ7zTNW1pzSWXr+d3KwV6UI4eka26J+y0ZmkoSwQi37mcgOZRUEKBgGaxVzEoZBYJlGEPBcQnW9HRPCPsWNnlj+A74FHqWfSwA2TxLe6YMs4RzQ0SJ+eLjijpbfH3IqW49crspptfrMOiJTBd93QStsCNwd6QqVoS5//cuO7m99KY8rryqJkKkAc3ZokdSuzPW2SkknzwW69SbiuaXTOq+Ww4nZ7JMkLMEKarBzlz9Y1I8J1emdXwyCO82zfr1K7rrGUbxxu0gzG8kQdmAuzeTAdYs0nWXMOaIS49Sia7eidAF2QvOwQRucXkdL2WZp0ahtxTfZOqWI6GEca+NOu3y/KqGMoj2iwNNTWdybMBq5RplAQpQ+aGPf3mqanCwVUPLstCyoou75FqoOLqMSoERk3ONmBu1XJN583bwNpqKNkosEPzEAP6jVBScW0+GzAc8RtDHNdAr6MO1C4oF6pZekwe9M8XDEOENJrfGyz8fMdlRRuWhIToH1vxBhcYD2D8+RJsc3V/mu/CRWPS6cXt4iBDSIz8w4KsQZyGhfSP5CdcBY2p2JJJUZO2eUA8yBdpOz0mkeKvBv3Mz7GLf
 xcx1IFJe
 0ZPu9DaA5Hqa7hgX3jf056cd7VXcl9bMpqU9y+WkvMBDuzBazOoClgyI7Ln2msmLKKWQXDXFGqkw4VwAGguOVDGrLCQCUUtL6CDOz2HQCVVHeDMPCrXvML2QSQAzCQMXRSqwjEv7C8BinfZtg6uW+lJDV3EaB3hqh3aOkch3rSqY/kIK6PiYoxo8LsWWwPO91ebu6b7G24T0Re0nDzFOSfwIU79vCHrIz0bxeG4MNBLI7Te7euYvanXsWtXpAj/nguTYT1bce2t27Y10NqCEgFxEM1AHrxgW37B8S6tsc93md+GIKB6n4cPzoplCdEid+ZdZEvLWxe9cYMmwa+hyAAzs8SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/16/26 9:11 AM, Zi Yan wrote:
> On 15 Apr 2026, at 21:05, Baolin Wang wrote:
> 
>> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>>> On 4/15/26 12:05, Baolin Wang wrote:
>>>>
>>>>
>>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>>
>>>>>> Yes, that makes sense.
>>>>>>
>>>>>> However, it’s also possible that the mapping does not support large
>>>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>>
>>>>> That's what I am saying: if there could be large folios in there, then
>>>>> let's tell the world.
>>>>>
>>>>> Getting in a scenario where the mapping claims to not support large
>>>>> folios, but then we have large folios in there is inconsistent, not?
>>>>>
>>>>> [...]
>>>>>
>>>>>>
>>>>>> For the current anonymous shmem (tmpfs is already clear, no questions),
>>>>>> I don’t think there will be any "will never have/does never allow"
>>>>>> cases, because it can be changed dynamically via the sysfs interfaces.
>>>>>
>>>>> Right. It's about non-anon shmem with huge=off.
>>>>>
>>>>>>
>>>>>> If we still want that logic, then for anonymous shmem we can treat it as
>>>>>> always "might have large folios".
>>>>
>>>> OK. To resolve the confusion about 1, the logic should be changed as
>>>> follows. Does that make sense to you?
>>>>
>>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>       mapping_set_large_folios(inode->i_mapping);
>>>
>>> I think that's better.
>>
>> Thanks for your valuable input.
>>
>> But has Willy says, maybe we can just
>>> unconditionally set it and have it even simpler.
>>
>> However, for tmpfs mounts, we should still respect the 'huge=' mount option. See commit 5a90c155defa ("tmpfs: don't enable large folios if not supported").
> 
> Is it possible to get sbinfo->huge during tmpfs’s folio allocation time, so that
> even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can still
> decide whether huge page will be allocated for a tmpfs?

Yes, of course. However, the issue isn’t whether tmpfs allows allocating 
large folios.

The problem commit 5a90c155defa tries to fix is that when tmpfs is 
mounted with the 'huge=never' option, we will not allocate large folios 
for it. Then when writing tmpfs files, generic_perform_write() will call 
mapping_max_folio_size() to get the chunk size and ends up with an 
order-9 size for writing tmpfs files. However, this tmpfs file is 
populated only with small folios, resulting in a performance regression.

