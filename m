Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBD210ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8592D6B0092; Fri, 27 Mar 2026 10:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2AA6B0095; Fri, 27 Mar 2026 10:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1FC6B0096; Fri, 27 Mar 2026 10:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58C736B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:40:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA8DEE185D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:40:20 +0000 (UTC)
X-FDA: 84592103400.21.5305E82
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 227AA140012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:40:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FpoH38ed;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FpoH38ed;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774622419; a=rsa-sha256;
	cv=none;
	b=wC9zq1g7oZYb7eXwG0iuKGadRtDywXbdIIKrFsEtFRgIpkCAwdPrs0C1Ism2gQg3PBxLhi
	LuRa9PcpH73rPolpwsw9ZiYpJ11Pj67B85oZg2NK/63VtsmN8vhhTKXQmxl9bxOcatpoIr
	Ha14Tsn2LmBjTXP5j76Rnf0nK1ZuwU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPmy7VWivg5YsRBSBaIcdTmp91XPK0irR3iwfLEb4tM=;
	b=Nf6lgbetvnrfe7U9Iw0P/1w+3VbtD1U7Ur98zTEvEAqc+iUiFdPA7RR269VQsbbBZBHaQN
	XZfTJ1dX01wl1/KxJe69tBTEUxmZjfma2WsrXtUULtNhMKeXJxbEooq7CcSPMxhCGkpiqf
	SGfafFOxP7sQMFlJZEv42ilGcKQJHvI=
Message-ID: <a5efef0a-8d68-4c8c-b8ae-09a6a33e37cd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774622416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rPmy7VWivg5YsRBSBaIcdTmp91XPK0irR3iwfLEb4tM=;
	b=FpoH38edCQ9PPpFsGYVuORz7UGKbAz3vOE8SC863R9H33+lGVW2wozoOwesf39+5QTJLZ6
	YMLDpHYRZPlLmWXmfHEsd2JK00Icpo84ITAZklijT4H3nM+WPbh5CLzikqON6bRdbSd6yH
	4h/88ILAJinto+ZbCJD1S1MPuXXTASM=
Date: Fri, 27 Mar 2026 10:40:10 -0400
MIME-Version: 1.0
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
Content-Language: en-GB
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <48d7c810-d219-4346-9e8b-d70243445a91@kernel.org>
 <cf36f821-8285-4b9f-b1fd-e080292f4204@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <cf36f821-8285-4b9f-b1fd-e080292f4204@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 227AA140012
X-Stat-Signature: naqjqnhpsydq8acschsmgmt7j3161aa1
X-Rspam-User: 
X-HE-Tag: 1774622418-126307
X-HE-Meta: U2FsdGVkX1+QsUTy35Up5mAPTxdB69twmSmOoT4Gxiw5hPf7KpoQQ863E3ReU3q0o9UZ8AiNVlKL/j8cuUOyrL4/iROJjPOH+z5U5V8boFCI2cdb/LgzfHTrB9XCa0WJLMt5ctDlBhoBF95Dnm0lFka5sFvKshAAgG+Zfleai6CuG1hmOpcmAwjiVwQQ8xaocCpyPT/MB0XA/3UsZXHMdeUCI0T17FCAYZa4eV8o65iSTwzTMmDdeASdraf++3y/1M9lvn1rQG/UCnKuJ+Xfpivh1k6IuQM8S60s0fbvlCpisMG7rxy0Te9/c2WGGpRimcLS8ghBC5AIuQpZHDvRDvzhidnmmLPvqnscSROg7voc2VSkd1qGyPBa2t+GDd5mxFZhwJcgXgdQb8B8NH4FBZRMS+t4mKwjBEFPZHhUo5ll0x6J8SzqNt+pZNaeynQdONtkOFZ+JYqpRwRpJQv1+TR5ouWOqpE10azzDCZVkpUs4gpsyjQbsFO1Cn6qpz4AX3S7jC4OYrd5Rx2mKRh6ccLawSPER+wbpi0GWKLBikxmVMIImhY4rWVtBbgBPlhCw2Q01RV4VBrCYnBDusqckrj0O2L8fAGsyK64VBYFp7+Yb/7HcT8TZ80ErtZMsZj3Xt9lG8YBlgb+1Kjj8UXbo6lihqZq7HSuXP/9UxBleWOHM/q2U9IcBHTvglQrJ5/hEuvDBOJr3meXcM6tdMKdscgo95NDuziBps3VEvwJSEgexfO2HVry4x9OWEqOR5axCBZE/dWiXnEvYZ5crPE1ZBPWL/UQOLyc/EgTGx8BfjIgR+AQtC5XVqN91Tn6fTgGQwM9tCorMw+iqhAHDAJ5b7pSgBfGs/vzu3GJ9UbRJHPgpz10nQ5BRsmBdT8NH5h/7M3W35FKLPu21TmEFDY3kO04eJRAf3mW45mO6QKvmK7rNVkvVhnaZUV3ypHRbzKs3KJTpVYz8pwy5KPlsiR
 tk2p3zAI
 ZcCBdFqvIEk0ID3+sOa0X4fh5SfWUcptb3+CtRCdt0WLM7rTVnL3QGiIOu2r4wd8pjDDev0E92r+sjCLzigfqfCpmgUc9wpOSlPiHhi5s1Vmsa5s0utV34knEI8Hz5T8P+Z9A8NU/4YruC5GRcoFyGHNUUVOlsQ2YSrE3H+J8Cp91B5Ers5UQDia7zpx/5eassYmLlnogCDearJ3q/NNgrY9YMzq0HPVC/YQIaLeHZ+iKVaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/03/2026 12:25, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 27, 2026 at 09:51:31AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> RFC v2 -> v3: https://lore.kernel.org/all/de0dc7ec-7a8d-4b1a-a419-1d97d2e4d510@linux.dev/
>>
>> Note that we usually go from RFC to v1.
>>
>> I'll put this series on my review backlog, but it will take some time
>> until I get to it (it won't make the next release either way :) ).
> 
> Yeah, please update to v1 from RFC because I'm looking at this and wondering
> where v1, v2 was and why I didn't see them...

Ah yeah I included the previous version link in the coverletter [1].
> 
> Generally I'd also advise un-RFC'ing a biiiig series IDEALLY be done early in a
> merge window :)
> 
> We've pretty much shut the door to new series this cycle, but being so late in
> the window at -rc5 would mean no way for this one anyway.

ack

> 
> But in general it's going to be a rebase pain this, 

Yeah rebasing from previous version [1] wasnt fun. But yes happy to rebase when
needed!

> and I'd rather not see it
> land in mm-unstable at this point, because that's supposed to be 'what's in the
> next release' and it's stuff like this that leads to 'I am not sure what
> mm-unstable represents any more' being a thing.
> 
> I think in an ideal world we'd ONLY see this in mm-new.

ack, I will try and send the next revision on top of mm-new. I do believe
this will apply cleanly on mm-new at the moment as well but ofcourse that can change.

> 
> I wonder if we need some process for un-RFC'ing really, where somebody kinda
> asks rather than it being a vibes thing as it is now (or a 'people don't reply
> to my RFC' which yes I'm guilty of :)
> 
> Anyway this is more general points and not about you Usama, because - hey - all
> this stuff is pretty unclear generally.
> 

No worries and Thanks for reviewing!!

>>
>> --
>> Cheers,
>>
>> David
> 
> Cheers, Lorenzo


[1] https://lore.kernel.org/all/20260226113233.3987674-1-usama.arif@linux.dev/


