Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458AFC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D826B0088; Thu, 27 Aug 2026 11:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514946B0096; Thu, 27 Aug 2026 11:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4524C6B0098; Thu, 27 Aug 2026 11:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230B56B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:17:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1D33A0478
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:17:30 +0000 (UTC)
X-FDA: 85147403460.19.2E0498B
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id EAAAD2000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:17:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gZKJXRsS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpbQbRlY4KIQWST/GVf7Cyah+XPdQHCuI+KU9n81JxA=;
	b=0NhJ5mrhOHit2YAW9hW3E4byYkUpf+HuE88nlUjcuZnIcTVrONk0ZISnCF2Pl0NvhlScr9
	k6xLnj+AaKnp27/qmsOd/4MR4FVZa53nwRo3Xeq6uiyxUgAhImXGWkLT42hh1xgAWYtixq
	HDi2pmHHB+pdYAryyfXF/h8uia1GsZU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gZKJXRsS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843848;
	b=Vyfp9mMeWNGGNHZ/BIIygYZCaDNKzBvyClvlJxKBoBv+1CHKxUUa+IGz5azFO2p6RqaHlx
	KkxPdiP1OpSMeg23msCleO/tldIXHNLt34tmfAHGeMmZiemHJP+UGQsKJfAFmzsds1L1D/
	EBIcYTzGdrOhgWOpD0oTLuDby1BECOE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g99OLAAAnjbXW5zwa+srzNjASgOnpSbteUzkGHrKJBI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787843843; v=1; x=1788448643;
 b=gZKJXRsS8rFdNHW+7kqCS5eyT9kFSoaeRg9PGcCQt4ygNXhb0V3TDmr7+AsspphK6ftfRBks
 63yYN3YfWXDH0VmsgXe/uWEGhGqPCZ/bGp2fI36aB2xprjJm2pFVwYqIIgiD/vixdrtybpOdHt2
 z2H45bx3o0svINibNNBNUtrU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 95c7913dc38281fa;
	Thu, 27 Aug 2026 15:17:23 +0000
X-Mizu-Trace-ID: 95c7913dc38281fa
X-Migadu-Flow: FLOW_OUT
Message-ID: <05f7cf39-b133-4cc9-8082-40b081b7f908@linux.dev>
Date: Thu, 27 Aug 2026 16:17:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin> <054cf257-f5d6-4041-8c83-902af87c736d@linux.dev>
 <apBG3YnZcHhlvU3m@gremlin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <apBG3YnZcHhlvU3m@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qn8xg1amwt7cnxi9cb37si8d3e7rnja6
X-Rspamd-Queue-Id: EAAAD2000E
X-HE-Tag: 1787843846-102759
X-HE-Meta: U2FsdGVkX1/KDm3gJafFjX4VltSo12ZhGf1K54VZLoBaXMME658L696KIckkfiCq3iXM876wKgLyDUFQfLf/rLlgMHhwPyZR8hnBctOObaBAD1rVZYzmsxjBZce2K25ac40DTgoRN2MNdYXjkWnI6hTHVrPrRWz1T5WjhP4CtHN/1sJ2g/3fz1+jfV8uM1kZm4McxoEA7R7khtpSf8CJk2vSDz4/1oKzILHvtwAUvV26fNsESg9APrgHb7lQPKPwTQ5Xq+iWpZHqL0rQceW+3AO3X074HGp4QRugEw0b2o81lvat8R2Ik1qFOW2ZQeWr3RnNaAffebUQ/0WeE6LfaUOjR8EFKmOQCnrfCReb0PXnqcSnWCfyVKnhFQYqKVcY7MSB+eyg6iOMCHRtmSuFaYdd7upsu8K9G5dCXPhbXy3SowkpzMpT7aK0ettaIRxCMuWX/veK0rVGIa4q2Z/oH1uERSB55tEnsmV9xXWsOQ3WwD0EuwFwiEk4Oa9EtMFRT7sAzox6fEpkQHhhPWlc6hHIcyG9/jrhxP1b2W1kA4HsX53wv/S7XInfkuBvPhVJiz/Ijsp1iDbjpM+wRqhQDo1WWIfpzb5vEwCb43/A2mSaz9tCPkI0pQ5QiMSvfHHsBfu8+DojioWfqu/eJZv1Z+IHF4TfJCyMq291Sszo7r3r1+R1OIP4e0PHYfQEAW2DhCDg3Qq+GUiRJ0W3FLisb2I/W2klLJv81WnwqzhuQVgK/xi3g+7xQy+uOLi3UHvjbEp9iXMqC0Y1jsuszA+scZKHqY+9PWgyiktLCTz1yomhbFyzbluwBbe2Jjknc4ZND9vnitv152yGGn0sTBHjQQsr4BMY+UA2Fqw+/0cWP+9OubQ2V9YgBhErxbjvSaXEYgEReF15vQWUPyg9I6d1NQCqgvYjiMKOC03aybPbvyxdv4wpY6KXldlg0WmzNsGQ6VF7StH5JFj3eRr4lBE
 yYuZVF/Z
 MaW1MvxEoWH7E4f3nQqYkJgOnIqdoxka0+k0H0n2MZVcye4uPZe4ht3FhACTYp18TSa4NfY232qDCC71k1CRGKZ7HgMPcYUXB+gPpYBQamk1cpgtpb0iJLFuZFRRaNXYIdupLMHJh3iXO6XX/IvTrzPeC0rHEEb4vu+z4eO5axhb8I6Lqnun9K61CbSYMR8eSJgIHjioCLhnwSTG60gIc3yh0O9SO91I8D83YHUc7kHSEHbxHHlaqeS5AlFgRs4/x1lwCtKHNOgXJNFMwZq3I9UFzu0YZ0/0CH0P/8/mX3oB2rugT5NCZ02F+rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/08/2026 15:25, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 27, 2026 at 03:15:47PM +0100, Usama Arif wrote:
>>
>>
>> On 26/08/2026 12:31, Lorenzo Stoakes (ARM) wrote:
>>> Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
>>>
>>> 	~107,000 words of review across 948 emails (in 279 distinct
>>> 	threads), counting only prose you actually wrote — quoted text,
>>> 	signatures and attribution lines stripped. That's a full novel's
>>> 	worth of review commentary.
>>>
>>> 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
>>> 	and your longest single review was 2,404 words (mTHP collapse
>>> 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
>>> 	of your top-10 longest reviews).
>>>
>>> 	Estimated review time: roughly 300–500 hours, centred around ~400
>>> 	(i.e. ~7 hours/week for 14 months).
>>>
>>> 	1,615 THP-related emails in the window: 948 reviews of others'
>>> 	work, 278 replies on your own THP-touching series threads (~31k
>>> 	more words responding to review), 382 patch emails, and a handful
>>> 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
>>> 	emails), June 2026 (113), August 2026 (111); quietest was December
>>> 	2025 (5).
>>>
>>> Think I can be happy with that!
>>>
>> Ah so sorry to see you step down, you made THP genuinely better!
>>
>> The numbers show the amount of effort you have put in, but they don't capture
>> how consistently useful and detailed your reviews are, with the aim of
>> always trying to make the patches and THP better!
>>
>> Thanks for being an awesome maintainer and hopefully you will consider
>> coming back soon!
> 
> Thanks Usama! :) I know we started off with some fireworks on review 😅 but
> you've always been fantastic to work with and it's been great to see you
> develop as a contributor.
> 
> BTW, I did want to say but never got around to it - I love how you've
> approached the PUD THP stuff - i.e. getting the huge swap stuff sorted
> first, gradually building things up, etc.!
> 
> You've always given interesting sessions + input at LSF and have had great
> insights on how stuff interacts with the Meta fleet also! :)
> 
> It was especially interesting to hear that 512 MiB huge pages have actually
> resulted in far less memory usage than you might expect :)
> 
> I will still be busy upstream with the 4 other maintainerships to keep me
> busy, along with series both in kvmarm and core mm so don't worry I'm not
> going anywhere :)
> 
> And as I said to David and others, always feel free to cc- me or ping me
> off-list etc. if I can be of use for THP stuff, even though I'm taking a
> break from the maintainership side!
> 

Thanks for the kind words! It has been awesome working with you and discussing
different topics at conferences and the mailing list! I am sure we will continue to
in the future!

>>
>> Thanks,
>> Usama
> 
> --
> Cheers, Lorenzo


