Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88681C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16166B008A; Thu, 24 Sep 2026 06:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE6D6B008C; Thu, 24 Sep 2026 06:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903FD6B0092; Thu, 24 Sep 2026 06:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF7A6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:55:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81A4D802D4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:55:30 +0000 (UTC)
X-FDA: 85248349620.07.9127CD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0172140010
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:55:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJ9XvXG2;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790247328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQCJYntSH0F5QVJYSosc1oqNqnyivE4G/pZp3dfTNnU=;
	b=KFSzSxUhzDhhLehCFbNsv09Da/By1c57/6r0OG9ZghaabNm2O2LM6bGCAQ3PJqFuawJcj4
	CPOdwFhfy8e88tNbQSgI/phU811A2V6Z4b11Tt5kvRYs0HakB2YQyk99W+Kfjl9vxuwVdY
	dKJUpZZZr5/D6uJH8zJ0taYsSh0IOxg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJ9XvXG2;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790247328;
	b=398Tj/MTZc9UsbRm1eB2RJfC3KF0hUHD6Vg3C5oVRGr5Ymahn3IfRlm+L5wtdKiQ8Ws/UD
	MeJIfKvySVBWTzyN9LZTWnJ3ELByHruuket59fTrxBCNNr710uvzf+4xpEe/Fcwhc3ACKJ
	T28GQ55hyPvGrza4uVAZyH6TNFo7kqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F0C6601DE;
	Thu, 24 Sep 2026 10:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0C61F00898;
	Thu, 24 Sep 2026 10:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790247328;
	bh=wQCJYntSH0F5QVJYSosc1oqNqnyivE4G/pZp3dfTNnU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dJ9XvXG2Pdv4ywmQhxsP/omtI+lvZR/CvFBcjc1vTCkyko34Ty0iYtALxUUy4P8bp
	 aTUdAahs0dqVnjk89VmVeZGiVXwdoelftWz2RzvQsxFdVzaJVlkOej83jH7foxGl6i
	 lYdZBgPp9ekR3adIUDbFMEs4Iu0loDmkg9Xd0mHAF18dwkr6VRN9ZywbLHkV228++W
	 XuzU/Sp2o2KPxAkQtUsi3iZBEi3tdwhqclOC78oYTsa7ahrZ0w9fce6UUp2+9Bf3uN
	 jq07OQzJjK6pIj7GoQ7lAfoMrrh6Sk1UQ8gk8zPXxLtt4xdGtO213WeO3UR3n2cTCo
	 Az0CCF3B77X+w==
Message-ID: <6c79bc6c-abb7-407d-84cb-c9ab29732646@kernel.org>
Date: Thu, 24 Sep 2026 12:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
To: Kiryl Shutsemau <k.shutemov@gmail.com>
Cc: Harry Yoo <harry@kernel.org>, David Rientjes <rientjes@google.com>,
 Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
 Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <christoph@gentwo.org>, Dave Hansen
 <dave.hansen@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>,
 Raghavendra K T <rkodsara@amd.com>, "Rao, Bharata Bhasker"
 <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org,
 shuah@kernel.org, boudewijn@delta-utec.com, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
 <arPdnxhX9VHnDx15@thinkstation>
 <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
 <arT9TVHmM3WDjWnk@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arT9TVHmM3WDjWnk@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0172140010
X-Rspam-User: 
X-Stat-Signature: sas79d31x873rtj49za3hgm9q39b3cwd
X-HE-Tag: 1790247328-297117
X-HE-Meta: U2FsdGVkX1+cFCNVlpEaGtb+KCI9Isj4kKqcA1OA8DcylA7QTw3a9apQ1e5Jsw7fIGuUKaoLOwzd5dviqjkFz0dj5oQFuIiIy2ew5g2H8517AcOZeouyXjraosGzCtc50+6C9RJ1TNFBbUxqfAuiNMJRN9HZWZCSXWybeOkYYqKO6+HSBdiXeQvwbxLycAhrV0i6YXvnEvWmAeH42b8D8UneJWFF2Et/nE9zqC5zGyisIVTk84C45fUH/8WOxm2lCAwgpOAN2vir+6DAyAI5+CFlHybXYdQWAT2an5XdJPVWNkEK11ZN8CrctCXAncwJ9VNAf/2A/0S2V6to8ZhqnCXjWVM0UuZibmcUxrzhGSebriOv72Mu2bi7teT6+gG/oBEjWj5FFjYXwWrYB7dKk4QpenDlj0cIP/G0xP0OTfEXm+QEJW7Z7L3D7I9fU3U2g42x9UTExEhIntlhSxwNI2VSVlwfAwQdv8ll/Xq305sa02nqhtUKG27ryd9MIcd7QUhMVTDF4SStxSuSHldIPUsyCbDhHw0aSvPRBwLjrn6js8jLssjpNTlUu7ofxfOxl5KvHPPMK0Js/iLvYqnoW5+jr1tFFscbk4o5E1OpqxFCEcFH14ISGsWE9hwofZzJ7jzbXllodSKRtReO293f6tZ9MSC/dXwOuk5VvGgFM94eado8HQkTVfwDU68yoR5xwuPLF6knlEJ++grvZ7ZJ/tJ2byHmbIbvPOfPGdvKhAWdD99VrAoVBKX4I73QLxnGjcb9rdsSOmyUZCOW9P/NWY1qWnNVD7a6jrJaysdMB8LMRJXsdcvdELO7O2SksqbBfth4Z4RIJH7RRzJEdvr0L/pxjYSs5g2+geXXDa2IhijO2Nexq+pnUAfLg7D4tN9qqGkP588cvqobTi6ptMpKfF1DCnjEAHtggyRTpuY6zliykZjXHvtDjj80Y4osLDfsYL76oxwiI7OigYESdIw
 6Kb0u5a/
 6mZzs3W5MR8awU3DQGQbJPsKSu5koMllX3LsoVG4ZQ4gcYVbLSa2hVzf/RWDXERfP6Vtfw37WJmaw5xR9tpFZ5GT0obaIoA6dqDJEeRwQugsU6b7WOqcvUyViYAAGmKEeyHHJ3+NYMRU/LKlQYyxKl1/yYin/WUiEBF+S7Oz41F5uhfqaZzU9QJ/Oa44YMVpxs9cNudtR/giq2j3qLekfBttY6c1oH2xuqboz5ktRCnJJwOuX6EZSxI8x7cr1yPlBRInmuvl3ghKOamFCvGy1RyIUz8/G5u902SLNvbCtJbR4UrkCLCDb0HeYwAvnsgak1otVBGQvA+AOVpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 12:46, Kiryl Shutsemau wrote:
> On Thu, Sep 24, 2026 at 10:32:29AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/23/26 16:36, Harry Yoo wrote:
>>>
>>> I believe this is what the patchset actually did in v2.
>>>
>>> That way we'll have to either
>>> 1) make any architecture that supports kexec select ARCH_KEEP_MEMBLOCK,
>>> or 2) make kexec scan the bitmap when allocating the memory.
>>
>> My naive design would be:
>>
>> 1) Teach memblock early about poisoned memory ranges. Don't let it hand them out.
> 
> I suggested using a bitmap because ranges are not scalable. Some memory
> failure modes generate errors repeated across the physical address space
> (think of a column failure, for instance). It would produce too many
> ranges to be viable.

These are in 2M granularity. Is that a real problem?

> 
> We already consult a bitmap in memblock for unaccepted memory. We *can*
> do the same for poisoned memory.
> 

We can do many things. I don't want it.

> But I am not convinced it is needed for the initial implementation.

As I expressed yesterday, I won't tolerate anything in hwpoison code that looks
like a hack.

-- 
Cheers,

David

