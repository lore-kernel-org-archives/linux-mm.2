Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D6FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33656B007B; Fri,  1 Aug 2025 05:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4966B0088; Fri,  1 Aug 2025 05:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC6D6B008A; Fri,  1 Aug 2025 05:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD5C16B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:58:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DB75BEEE3
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:58:25 +0000 (UTC)
X-FDA: 83727738570.11.272BF88
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id DAABF20011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:58:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGeTP7oW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CyV28xq8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGeTP7oW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CyV28xq8;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754042303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSeXoQGGBjQ3qsfMVMRj+BOL1M+cMszW9Zuw5XUauSg=;
	b=RU1HW181/Ps/gDll8+cvDZhT5mQeG8K7nZyNppLMCMIrdrn5wcYJHJT9EO6Jw4YxY6EmBb
	8JbZyjnJQNESBJsphUsRMA+HNE/9rrw41yztAb/HGsaN2DMeEYMo0oresrYpMG5k7Q7O6D
	gPfMj5GZXdF9gYvd/nHibLN95edxaPw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGeTP7oW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CyV28xq8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BGeTP7oW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CyV28xq8;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754042303; a=rsa-sha256;
	cv=none;
	b=PhAFtkNljrYBGHsZgqadMVp/XrTR5UjaS9WJVVaCy0vyfcUekl244M92cnvIhM/YFqc/dW
	IWI+ZPDYLuxH0FXlJnKeqqptZ529pB+0DWQe6oVydhA4I7qEIrfSrxzuH1eZ3w32p4Qa55
	q9S3/TsYVFlMcEnm807gqQ5YjdF2hsI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10A771F38C;
	Fri,  1 Aug 2025 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754042301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XSeXoQGGBjQ3qsfMVMRj+BOL1M+cMszW9Zuw5XUauSg=;
	b=BGeTP7oWISr0is28g1zqquLpkV90ngRr5nuDJxV64VVxDT8WmALza5MLDE0YYXAhJ7UEGn
	INpJrCxh3w2AHjuLS6RLxamcvhakkziHu8razT5vgcxpa5n9R3tVBbxyIX+SMssIoR0o79
	64/v+qqWdVSpP0hY7FIzcl9ZiBAXTA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754042301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XSeXoQGGBjQ3qsfMVMRj+BOL1M+cMszW9Zuw5XUauSg=;
	b=CyV28xq8IPyLqt+9kllEjgdVYkp1wjYiHUZ3MnYeJwSqKUmffkZHHlf0eUvUXR6lr/DMNB
	L8kqBs1r847cEUAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754042301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XSeXoQGGBjQ3qsfMVMRj+BOL1M+cMszW9Zuw5XUauSg=;
	b=BGeTP7oWISr0is28g1zqquLpkV90ngRr5nuDJxV64VVxDT8WmALza5MLDE0YYXAhJ7UEGn
	INpJrCxh3w2AHjuLS6RLxamcvhakkziHu8razT5vgcxpa5n9R3tVBbxyIX+SMssIoR0o79
	64/v+qqWdVSpP0hY7FIzcl9ZiBAXTA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754042301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XSeXoQGGBjQ3qsfMVMRj+BOL1M+cMszW9Zuw5XUauSg=;
	b=CyV28xq8IPyLqt+9kllEjgdVYkp1wjYiHUZ3MnYeJwSqKUmffkZHHlf0eUvUXR6lr/DMNB
	L8kqBs1r847cEUAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C04F9138A5;
	Fri,  1 Aug 2025 09:58:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZfC9LbyPjGicQwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 09:58:20 +0000
Message-ID: <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
Date: Fri, 1 Aug 2025 11:58:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Realtime threads delayed due to kcompactd0
Content-Language: en-US
To: Mike Galbraith <efault@gmx.de>, Frank van der Linden <fvdl@google.com>,
 Alexander Krabler <Alexander.Krabler@kuka.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Dennis Schimmel <Dennis.Schimmel@kuka.com>,
 Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: eb6jq3syj6ajhr6yrditbi9assf9bmtn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DAABF20011
X-Rspam-User: 
X-HE-Tag: 1754042302-559823
X-HE-Meta: U2FsdGVkX1/08JQSJkGszAZh1dR1dPzAafmNcylmypiWBRZKJGJbZWoY/1jge20pdO4vpXFucERN/vLbisKUMnThJv8c2QeqRtr1WHy9Ph4HAcg+Ymnfs65wbnoUVOukSE+7TOPCd7VtWPC+R+hb47K00WsS1tPPXSJVTjuo9lluyNrLCieNDkOAZUXN9lDAe5SGDB1sAN1zmW+5Nlcpd/+R4z4HEFaG1B3N/Mnvls7x0rWlPmz8y9IUvETb3744AFKOp15+z7pTXFhTwW26/ehjRYuCXLgXAyOyk14NILhrh6IZrdxwQbKIWUA8wOeMVv4+RyJJCbhBZ60R9Xx3IV1e91xv8rYOLiwt3N/zy/a8bKNSlRCPry7gmyOW2on03POJUpnJ9nzwA9ttu4B01OkZw56TdJ9VGH7h4qOouYlpNAAvXTW6dCZSXx3FeiG6rtwzgNvVMBJbtLqM/yKYRzlPOIkmt/BFIaw+7IhqTDJRmhcJKrgh5rkPr1isF4/Yqd0wEQ6QLAU4J2t1g5uEUo4crhPFlaGi2v78jubKumv93Gyb6DSSqMN83Uwbh8+jkZiIvrrVjgq9xNnvsDcQ0k+SjB3n7gQJ0adwdKrL5Ix3ssfel3j3TnbvPewJd996dVH0TDjyS3sCaM2dJMKKW1viJmrsW/xeeIQfcWSL3BxVoKFDvBYTjMJHgHA5n5E6aHxhdqsUiWzDF49Q6EW0fR2Ib4GmX6XwTi2iGuBPqzUh8/FNQ3Z22LTUAGXdSPKnpZ8BxfUresnn5B5zAL1xyNlsPtRVLHXrI7HDuC8wjlqseu5qAPiC0qdN6t8778Swn23xaA6zwbGDUcGEI0F+UEPdlmT4veRweWSJ+jWH9J3nS50LQse7LaxSVSWIKdpSKhAlNu53yGmQWfTUgJWhvsJWwoMA04qyRxkjbnOkMUfJNUvE+jrYPtYAjqXp0/brr8EQY6M0VhmGTO2+pDW
 R/6wnVD0
 wLVtN1FQESm7DaS8sfJ+HrGWiw078WU6sTWHCzcqoHXnWW/Sk1On/ZZVITBUqVan0SvRJ5PZXKdEIGwEsKqfUWJdSzgP55qUggHNAO3s+iYmx83tE6VgxyCdMEgl0XEnG7xOKnWhyS9h6FkiFn8eWJT/2mXtoeSMBhLaiKHg5YiwBm73RlmuFTUu6X8jCyaI5FEoEfRnKPJFOH0FU1B7SGrM07GBq9Iyec1GN78tlu/TcnrHJbXxQf9okPKudB7Eb4JeKlQN1wdmGD9gXwfXJW7Ppk2TLDUoz7+CQceaRcDRIUK57s7ts03XFCAOsBoPlGirQv0A8/ikf9eQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 04:46, Mike Galbraith wrote:
> On Thu, 2025-07-31 at 20:41 +0200, Vlastimil Babka wrote:
>> On 7/31/25 20:34, Frank van der Linden wrote:
>> > Not sure what the right thing to do would be. Either explicitly boost
>> > the priority of a thread temporarily during migrate_pages_batch, or
>> > mitigate the issue by dealing with 'busy' pages more quickly in
>> > migrate_pages_batch.
>> 
>> There's a workaround for realtime tasks. If you mlock[all]() their memory,
>> setting sysctl vm.compact_unevictable_allowed to 0 should exclude these
>> pages from migration by compaction.
> 
> Hm, per documentation that's done automatically for PREEMPT_RT...

Oh I see.

> On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fault, due
> to compaction, which would block the task from becoming active until the fault
> is resolved.

So it's probably the mlock() part missing since that should otherwise apply
to kcompactd.

> ...but rummaging, seems other stuff can step on it (contiguous alloc?).

Yeah, there was time CMA was just something for mobile phone hardware. As
usage increases beyond that maybe we'll have to tackle it. Ideally by not
having mlock'd pages in CMA areas at all. And if contiguous alloc is
attempted outside of CMA areas, respect the sysctl there too.

There are also things like mbind() migrating pages for NUMA locality but I
assume people just wouldn't try to do that with realtime workloads.


> 	-Mike


