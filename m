Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78520FD5F89
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E876B0088; Wed,  8 Apr 2026 03:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F4F6B0089; Wed,  8 Apr 2026 03:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7816B008A; Wed,  8 Apr 2026 03:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B386B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:05:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EB421B8FC0
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:05:39 +0000 (UTC)
X-FDA: 84634503198.13.75985C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51737C0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:05:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LH0ocdHc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775631937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pb08oaDATCWLltN5QPqCojfNCmng3uCOaH6brIS54k=;
	b=DfKa3HTmlgLl0BXB/EZycPCFDsRqvUBraaHkPQ0RxlasT46fwtDuNQYJ0LTQ4Gbe+cEfuV
	rmQgu9iHwQ0WS9aiZ6oQUNUMHxc/s+oxsyfiRDF9UM8Q65SNkJ3LY+2q3j0W0f0Z02noGb
	3xPta5U4RWRLXGOTIROehbzdI7nbzhU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LH0ocdHc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775631937; a=rsa-sha256;
	cv=none;
	b=Dr5sOD72lmvy5jgHbLudebnqRxjwdwLDsrUKHaqMjbD5TmHEAFHECIFy9eR8hFR0bwwmKj
	q69j8LxhoNMQntAYk2eovDaIe/z3wqpRbcPG1AhtK0d8TUEd7lhhazsxC8212RZK3bLw1e
	5PFP3YFlDmtcDCH1Kk+eHrXlCWXneOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B882D6013C;
	Wed,  8 Apr 2026 07:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC029C19424;
	Wed,  8 Apr 2026 07:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775631936;
	bh=M8XYGEoCkMLxD3pn8ODjvHiw55anXKWJ1M6byHgjkgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LH0ocdHcmH4RV1KL1PiXHkOvlvoCRIJqQVMTRzQlvuhEbtW0bgfkjAxMxB7Zrkyxu
	 f5CMhbvDJERT6DOxCYAX+F5/J/4d29Jm0IPcfXoZhKjdXxNYcv/GR8CnfLtEM0zhBz
	 i5qLy2oj39iFwqGjIDohH6FI/F+0t75CLX4LyR3KnLEdFgXATv3Trm5GuELGoILTrZ
	 jc/eAxqVi/lOkrzhFQxbcsB8N6L9SloJtgMbupgUv82uIYu41BpT9Jx78ChAMN8cM+
	 Gdk4gGTbYxd2vsqwuZNvfjUzmaTKwGXEfDZhpCzCgesoeN0PFvfV7voxwslSv3yN/P
	 rkZW+WZ9BYFyQ==
Message-ID: <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
Date: Wed, 8 Apr 2026 09:05:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Randy Dunlap <rdunlap@infradead.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Dave Hansen <dave.hansen@intel.com>,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51737C0008
X-Stat-Signature: spzjs5wwjra19nfaajjc4zotz1pyj5x1
X-Rspamd-Server: rspam06
X-HE-Tag: 1775631937-553442
X-HE-Meta: U2FsdGVkX1+GFNv0OZ2oftcdHXmBwCW1pArej/Eq+6qmYFuO7vwxJH0nTquNMUX4vhzxTrmH15ihUNJ4jsC7IbsMRtPho64IQXTZs/l09twrI0EGH3iEIT1KtfeJSXYvrl+EQ7SmGjsJ9keJqZ0fCGhpzh6dlLr6JjB9jICe9C3LVgLvmcFH+upr/P6JCOif7Fs8j+PFsann9TqNQH1qP8CzT8mroN8BgT9VpwSaRf70cb607lB3CwUsIqsTW+Lnh2Dp2b+uc0HeopCXI7YXUGT76ius1VdItkBaSrRC7PAIXctnlM3DOQ34CvwtoQwCwQ8eqCNmH7m7emUverKxnw553Omqw2ecwunOrrnPNJLSrsXYCbS2mxhW/GdjZpNalGYF5G4s/SYh8SJVVQYAFgzuq1Fxe+jSeTFWjU0J2iJznZtcmMSZkt4u8NyAjyb0PebgqxkmhxTXEXinm6XaYNIx6v87Gl/SIF56U//YYc2qalr9m5RuWWYymfq/74SWZg5WdcYnCTKjQCJl54QYT6Ec9LTq7/VFDx9Yn4E41DDcU8GyMgwkih/jDdJ03+UzuooPCl3Ku5YmyjyNJ4MxbOTWoN08N7JpouDZOgNtXtcMfxRcw4QaDc8kXhZz9Hgpc9C9u9EfnfP00H6pJIpOMUbgqOTkqDRbSAcptaPFS9uVYuTIou2hd1DYGFjJTUhWALEvqNJVyTX0RefRttON0PAKUiInFv1CWYy/tuH2VNUEP/2x77OcL9qjPiauAX8wlmik3jAJmzjVHWLb3kYCSfkfHUQNrHMOCOZLSHXED3Rfo0RHLb9DwF4P+mHd2eQPgGwY4yz1qpx0lOc8QWWD5lA2atcitR8q1qwsDg7N4O35qC55HbudvN3N8fGTEd1gqPz9ym9cOUrccb/7XiijfKOmZuY38SI/ZfyvpUssZ02Lbo1OMC5a1Ql+ZGGehzyrEOPqN6JJAAmI+kA7FMq
 08cp2FZj
 R08ErsTRkYmMp9r1hjUDOSeAHLXxMaHXEukHp4oBPDIWx6RoNs6S706bCWJKJ73hjvmgN2zJ6TFtEDC7UBsMCrCzBfaCi1PfmqruyKK/eTS6ws9Y4m5E0hvNAhkrF6xEFYMiHUygbzAtFzahcVvemIro1x1uskbrKw+pO1dpuL4ioaD8d+yj1VmEKKq1OIkFnhzpMmHMGMyCyn6AIVPu6tR1Z9m3Q1HJX1/mvXg7g5vU0T9deq5JhavvTZnlBtvdvHVHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 20:58, Randy Dunlap wrote:
> 
> 
> On 4/7/26 8:12 AM, Kevin Brodsky wrote:
>> On 07/04/2026 16:42, Dave Hansen wrote:
>>> I think you're trying to get across the point here that the kernel needs
>>> to know about protection keys, have it enabled, and be running on a CPU
>>> with pkey support.
>>
>> Indeed.
>>
>>> To me "system" is a bit ambiguous here but _can_ refer to the whole
>>> hardware/software system as a whole. To avoid redundancy, I'd say either:
>>>
>>> 	If both the kernel and the processor support protection keys...
>>>
>>> or
>>>
>>> 	If the system supports protection keys...
>>
>> I see your point. By "system" I essentially mean the hardware (the SoC).
>> In general I would tend to avoid "processor" because not all CPUs in a
>> system necessarily have the same features, and some features require
>> hardware support beyond the CPU itself. Terminology is hard...
>>
>> Happy to replace "system" with "hardware" if that's clearer :)
> 
> I think that "system" is too nebulous there, so I would prefer to see
> "hardware" instead.

What if you're running in a VM where the feature is hidden ... ?
-- 
Cheers,

David

