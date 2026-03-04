Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F740EDEBF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 00:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1876B0088; Tue,  3 Mar 2026 19:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F906B0089; Tue,  3 Mar 2026 19:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1796B008A; Tue,  3 Mar 2026 19:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 984BB6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:02:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 397321B470A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:02:23 +0000 (UTC)
X-FDA: 84506428566.20.F24F235
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 132BA1C0013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:02:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=cXLkuepr;
	spf=pass (imf21.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.49 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772582541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJkdj9bxnYe9umC6PVKWOYBRDAwhFFDq1KtRj4Qx5q4=;
	b=ftbOWSdZpvZNJ+Ukp9jqykwBexUhOeJWRW2MS0IjXmeVU1TgLur/CUMPTJTo3rC26KrDWh
	2tO2fsRtDqitbE8nyRzWe3xIQ72z6wIPozrIHaz7ICWKqyV5uvqupVyshY/pcmVlLIwREH
	Xr1N7X9W1m9W0ZsNDAJ0RXa4+he4PbY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=cXLkuepr;
	spf=pass (imf21.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.49 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772582541; a=rsa-sha256;
	cv=none;
	b=8av0Y08VOtzRoZboneVZ3fFENSCVT+5N8Xidh9l24kL5nrTbINzT4IAQeuZE4CgDti9uiJ
	2/swR6+B/IJRig98uLQksPwdpuYK9wJ31mV2h+aLu79U0eulBPoLSj1Q3OwCpVhzgqFbSe
	jcgl8hrhXN5whbEOTKjLwUHx+tUlXyk=
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6128B1C0075;
	Wed,  4 Mar 2026 00:02:17 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id BC95F13C2B1;
	Tue,  3 Mar 2026 16:02:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com BC95F13C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772582534;
	bh=PMlmlJTmJH+EFUFF85hcCnD7ggv7F1pWyKFzmcYHZ4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cXLkueprkVnUZX/SGnTCV9Wf7gb5GCyzvm/1X+aEgF1WLLXhPsfNwMH0MZYIfFQNj
	 4dRvx91uoa9krngQm1Rwz+DSuKMunp0M9c6AKYNU3fjMnC8j6sA8TVosoAWVzwnSGR
	 lIOk8EAHeibTXBlHl0oZQWmWtTUTwTQyPmUQ7t2o=
Message-ID: <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
Date: Tue, 3 Mar 2026 16:02:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Content-Language: en-US
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>,
 "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <aadYoaA_JYduCx_S@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1772582538-tWDR7B38HNWO
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1772582538;tWDR7B38HNWO;<greearb@candelatech.com>;e39a4ef213bcaa75c219f509376588df
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspamd-Queue-Id: 132BA1C0013
X-Rspamd-Server: rspam07
X-Stat-Signature: 8gcooye9yfa3szhd7hpjhfzt4ar6m7z4
X-Rspam-User: 
X-HE-Tag: 1772582540-764986
X-HE-Meta: U2FsdGVkX1++9ItznKvy7efo98qytQrHNKgCjw4u7ee/hN0uguiWDwbsAJHBrqFQycoZU23NvsMqtwX7ZMftATAEw/QHZWDN4fsHBnPyAaoKzVVsI1SRvDUPPJWaVQUGJe9dnzF+OjfSoRJ7dilq6stEBj3RgEdFn7t90rrY0uybeDCmKH/XS2Eg32jc79ncJdWzjAPAQadw9/nVn9NSR0fbb03btrcE5iu2Ebr1Zpk+vXbL6K7YO056GwXK80bvud7PKQIB4MtkntYbtwrsLH/zpydzGPMjutTGtbVukVl0wSEO8wRnnXcoFjhp942dP2MijCmRGzmpuVxhHlaRB9lDgwMCWZB2akkL8KCWEsxDGZSB+Y7kyAO9QcvVxbXROLD2YLktRmx894Oxoz/n2FZltyeOJ4bhUxvAvMr8MmiZTVPtCun29mzNfvpHDUoNLrIwi9ufEPcxwAsAQXlLrbswWEenRPGHmAhfbGZ+BuyA9UlpIWi/4twjhzpNfpiybKo/gD3oUyGNexoa8U+4FH7Kq8JwWsU6cpC2MktVvokbaG+XgcLxinaxQ3XnBQcERBjnOmjsB8EjGx9C3VoWSODTYuEw8Xc1MrybJLKzupXYJk4u/Up5fohAPQT8RMNBAIJYphgP+r6UKnibYYK3cf9HTAi+EyDxPu8yGioCwxp3Hy4xEDJPVLTiquG3Aa1bc8TPwyPg7jwT69blezHLUA5Hqj+saz+Y1IZyD/gv1dBIgm74jvm/QEncoz7sAMEhRkn+eXLmdXuvSz/WR44m1ix+Pydt3gsz0vrzA1NeWbDBFxxJELDjlWUKNWrR9HEl5hWeawVDUTxjNrReoLvYU0vOzCVDx77UCTo9s6Y/kOttazm/a+W/GB1qcbYiF/TfnBHRNvagQnwKiQAEgqI0rv6HvxJIhIa2xea8f7EaM5VZ2lEQeNje0GpTkEgrvvGdqkK9K2l8zEjz02v6B9t
 WpoWhyGC
 4KSM+AqcbtFLq8w9zNOKZ7Wv22SXim+05ygcPeSho0RkDfTCWOvnOFJp2xGzGHMIMqsSh87z7FmACkCRxUImDF373AB3t0EAXtP3l8mF0UuPeFmBqRNE9MIdE7wW2iE2dBHxoHiJJCsZ78kIjxY0G2DUxu04YogmYSgGdodddG8LCLCokeZGYuUkL+cZMIBjh2Fi/NbV+7YzK2N35Akb6ZuOnzqDOkbAEsW00CzZlZe3O73+iueDPJMXGG//du8+ehBsKJM3Qb2+KkbIdfmEA6+6DfdH2lnFlZiYBt1ZiKRT0tWUEuWWdQa7D8wqnHSbv9/8jpa/+oQrB6hE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 13:54, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 03, 2026 at 01:40:54PM -0800, Ben Greear wrote:
>> If I use a kthread to do the blocking reg_todo work, then the problem
>> goes away, so it somehow does appear that the work flush logic down in swap.c
>> is somehow being blocked by the reg_todo work item, not just the swap.c
>> logic somehow blocking against itself.
>>
>> My kthread hack left the reg_todo work item logic in place, but instead of
>> the work item doing any blocking work, it instead just wakes the kthread
>> I added and has that kthread do the work under mutex.
>>
>> The second regulatory related work item in net/wireless/ causes the same
>> lockup, though it was harder to reproduce.  Putting that work in the kthread
>> also seems to have fixed it.
>>
>> I could only ever reproduce this with KASAN (and lockdep and other debugging options
>> enabled), my guess is that this is because then the system runs slower and/or there
>> is more memory pressure.
>>
>> I should still be able to reproduce this if I switch to upstream kernel, so
>> if there is any debugging code you'd like me to execute, I will attempt to
>> do so.
> 
> I think the main thing is findin out what state the work item is in. Is it
> pending, running, or finished? You can enable wq tracepoints to figure that
> out or if you can take a crashdump when it's stalled, nowadays it's really
> easy to tell the state w/ something like claude code and drgn. Just tell
> claude to use drgn to look at the crashdump and ask it to locate the work
> item and what it's doing. It works surprisingly well.

Could the logic that detects blocked work-queues instead be instrumented
to print out more useful information so that just reproducing the problem
and providing dmesg output will be sufficient?  Or does dmesg already provide
enough that would give you a clue as to what is going on?

If I were to attempt to use AI on the coredump, would echoing 'c' to /proc/sysrq-trigger
with kdump enabled (when deadlock is happening) be the appropriate action to grab the core file?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



