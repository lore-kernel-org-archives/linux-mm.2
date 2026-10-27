Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE29606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NkjEe7DI
Received: by kanga.kvack.org (Postfix)
	id D44876B0831; Tue, 27 Oct 2026 12:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33376B0833; Tue, 27 Oct 2026 12:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB376B0834; Tue, 27 Oct 2026 12:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2A16B0831
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:27:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AEE840A7F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:27:30 +0000 (UTC)
X-FDA: 85368936660.25.0DC6057
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf04.hostedemail.com (Postfix) with ESMTP id E4CF040012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:27:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NkjEe7DI;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=053CHdAKqwJZRsLxQRremhTNFtX9kjO+yPnByzmsEH8=;
	b=ifm4+9Ch4e+dzCZJo2CDgDxUZzwl1Yg6cs4nrExaSXpjTRNKbi7M8MH5GoFWHEFQ0vxfbe
	TlV9L+Gc7laPs14lTjcvsmU5YMLgg4lQw1uXhllVZdf1/NA1gl+xf8jL3IXPFhox5QyzDX
	baPa6wNwe8jOs0P/nK2Og2XkQ+z1kaU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NkjEe7DI;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118448;
	b=3GCifew8kt7+Ugq2Nni9th18VPHy/2B+NqASb6j2ujDg9VSGe6AJRuc5EE66Gt3fN/18TE
	C0TBvxmwOV3jQiWiDmAHG8VRBdvmP104Q8U2SHKUjk0CxqsB5jUL4qWM/Ixw/enQGWH2sn
	EDeaPCaRaJR9d5Li9gJgtEqXW0zfnvQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vbqDc9e1bh4rE/TeVdLNHpxTFUG8xmq2PmfYrb9R1Ew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793118445; v=1; x=1793723245;
 b=NkjEe7DIf3imgt7jdO1mWQWHmDHTh9JVE0fJUceCcmzVBZytAufx9uCGrI6G866A/S82GrP2
 yNNu+Yac68LwZImsVfHLia4+6dQIHS3WGu3MpzzE/sRIGAh4XAvcnJVbC143xv+6J1GrkGEQFMr
 5GlsygNU7/17O45eqdXvlMm0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 009e9fd5f7d68db1;
	Tue, 27 Oct 2026 16:27:25 +0000
X-Mizu-Trace-ID: 009e9fd5f7d68db1
X-Migadu-Flow: FLOW_OUT
Message-ID: <137d6cc0-413d-465e-8476-a6fa14b5c2fe@linux.dev>
Date: Wed, 28 Oct 2026 00:27:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hch@lst.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261026152013.10511-1-lance.yang@linux.dev>
 <321017a4-58cb-4178-8ff2-055a9bbb28b6@kernel.org>
 <auCg6dXegweUB5m0@pedro-suse.tail5790ac.ts.net>
 <b47ec526-78b7-440f-a034-0a4d5137b549@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <b47ec526-78b7-440f-a034-0a4d5137b549@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4CF040012
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: x9fjcu3mu8swtqk118m3cf1pfhnwm5c1
X-HE-Tag: 1793118446-677892
X-HE-Meta: U2FsdGVkX19sEOpLx6GhOOWLal822HLCtQGWW6t+lpskIvfu2GJ1Xe34GTAW1YiO6qF/0oYYm3H+gbKG8wt19KzS7JU0e8xXbkVSre+KJCrem1HQXN+6jaa4XCCEOgz1x7H/bRf9NkujB7aa2nF8x9IKSxihB4D9cU0HaeYpUarTNpSvylVEC3exADeHKBveLyb8k/ikSUFFzBjqouOSvPUvm38ZujHjF1RtJoUzgvqsJWGPoyD7uc6fLjpIywQ88IfEYFmjVFyEN+d65WtCYtKBvNPRtd83wf2Q0ItsewJeJEWGdTLwOPg+dubM24ybs9Mepg8A93TZWoJ6Apw0wmVqV2JQiscg+God8gTWmQ9qemxAKRETfZXRepeQzgS7KOkUx0wG4q0Q2Eu8+8FLiRISZRNf/A9b1kuZvuJT/VuHZdLfGyIhmOquQzGTxISS1sx9U0C3gx7MSyIY4kHqjNFUEVmWtLPHTqcZrO7YwOxlxMWukiCKoeG1qtdvBNUfy+RimRzQvm1KmkrtUn4pkyQGFhjbGRETBUfqq9FjoOWv9J3dGm3qIa3SZ9IBXQOIbfEcwbFMtNIDv2utKrJuKChLADBn03xtAWt9IQ/J3tpWwtdgvL4X+QuP9dgO99DDdYK9+GipPQ185ieicmdDhvACxsfzBsI/WJ2eK7USaZ+iEfyp+uYmTDQWzUqIyvDUFUjZmCVCg/seBqquZmdmiivgT3GjqAyRWN1FnZa+JwUrFnoQmRSNxn0UKCaLKoq3y/WdkcShL98OZUVm7JbIAycP+CjZGN+tsGmKoxermJCQkOFLYJDZ3lbgYFjs1/Ni6qJVR6ulfaz+wVQiU5FxiCJ4ylhj7ovFj0OQLhmKUj9EVcB3yrZ6fzleOpZx7dWLTA5Y+ozccqoa7P0Ml1TMpy7tCZDrET1tor9Cn/PVZFxk7tHZYE0G8bqD7ScPP+OOBvNo+k/xVbjJwcGVkpO
 2mL20v9E
 MdV4+ICPYtYM0wz9ewBJDhXx9T+SqJd2gp9E5zxT91LmHX1gRH1eVTvXu6va1XJla6m+Ft8WEqoOKZczJ3LHFaBK56w3c5fULdqbjM1+/NlMh6fYD9ioNLpvnz/EMLf3GxqtItkNYAnPoWAsuizSVHC3m1H2QDBZdzTZ76lKc2GpzagwfCpz4/2CwPL0e3Lpsd77jaeA622IqMmrtdarexg5sXPe9IbAt5MtHzATm1qniqBLtJx8OiD//OuIFuyTUPoME72DM5r1Dr57YyFU214oerJJOSg7zx9ibaeMVUqrHuUe8FEHESyatL/2rvry5Sq3stMHd7BQJSDJGzvvU1HFAiRq6DLHeYBzrLxvx6OfGM4EcFgkwUQGW+C4mmyj4G4zPtkpb+8bKZFmhF7SMM+0IwEx7PXYUaDD4ZG7F2l6S8Obeak3/M4xp9zbjIhHYK/7nlVoK9MwtI+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/27 21:58, David Hildenbrand (Arm) wrote:
> On 10/27/26 14:05, Pedro Falcato wrote:
>> On Tue, Oct 27, 2026 at 12:06:05PM +0100, David Hildenbrand (Arm) wrote:
>>> On 10/26/26 16:20, Lance Yang wrote:
>>>> collapse_file() can call page_cache_sync_readahead() while still holding
>>>> source folios locked. If truncate holds mapping->invalidate_lock
>>>> exclusively and waits for one of those folios, readahead waits for
>>>> invalidate_lock and neither side can make progress.
>>>>
>>>> We need to release those folio locks before starting readahead. On a page
>>>> cache miss, roll back first, populate the collapse range, and retry once.
>>>> Doing readahead after rollback avoids an extra pass when all folios are
>>>> already present. If another miss occurs on retry, give up rather than keep
>>>> retrying while truncate or reclaim removes folios.
>>>
>>> Makes sense. So we simply try readahead on all folios.
>>>
>>> Any reason we don't simply add a second loop after the first loop where we don't
>>> take the folio locks and do the swapin/readahead dance, then a second loop where
>>> we do all the other stuff?
>>
>> I'm not sure I understand. You want to nest two loops? Or do you want a loop
>> upfront? I don't think we want a loop upfont. That's slow and involves
>> starting/waiting for IO. Fallback logic makes more sense IMO.
> 
> I'd have an earlier loop where we focus on filling holes, and grabbing folios
> then in the second loop only from the pagecache + trylocking them.
> 
> That would make the second easier to the eye.
> 
> collapse_scan() file could just indicate if there are any holes and whether
> looping makes sense at all. It already does a scan.
> 
> So you could just skip the loop when there is no reason to readahead at all.
> 
> This function is pretty horrible and the retry logic doesn't quite improve the
> situation.
> 
> But no strong opinion for this fix as long as we clean it up properly later.
> 
> (looking forward to reworks)

IIUC, we're good with the fix, so let's keep v4 as is and leave the cleanup
for the rework :)

Cheers, Lance

