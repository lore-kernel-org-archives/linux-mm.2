Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF60EFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D8A6B0005; Sat, 25 Apr 2026 01:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E356B008A; Sat, 25 Apr 2026 01:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCE26B008C; Sat, 25 Apr 2026 01:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F067F6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:17:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D87C51C0232
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:17:35 +0000 (UTC)
X-FDA: 84695920470.01.B6CD317
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D74840013
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:17:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cdbnbOvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777094254; a=rsa-sha256;
	cv=none;
	b=EGwwKEC1P1RIHVfpSSxiWfy4g7HW9jAPV/A9xQcSvcxAoZjxQ/xJokRbwaicL8SvU+Hshk
	Rkuj9JZsYpJcMufOhNdKziWJ0MhaJTKZbeeO54af2fVrUKg5n6K9ZGUlnYOHPNN2oSYZpn
	g/XB1mvjPWqHd9xGsS4wkEhtai84ef8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cdbnbOvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777094254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0ufuje2Pkx+7JY9Y+wgw5Qzs0yQFPJFayPDXyeKHrE=;
	b=VPYC0lgPghkYB2KHpLxcVSS8idyBKEKPIy8hFm16OdRjer/Z9VQX0igOso6T6tOhtLLgwI
	HSEV2IepOSUcFhEZBxujBlxhEz0+vSRMP/h5N1wf7Pfkoebc0atAbGzQqbCBhkG5DhDJtP
	5+QR+x5UrHj2nCAp89zjjVxexBhsFXc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA1F060052;
	Sat, 25 Apr 2026 05:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B17C2BCB2;
	Sat, 25 Apr 2026 05:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777094252;
	bh=5j0hI25fcLwvYs9O7EkFhaSQIshTYicy/Hs4ivFoX7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cdbnbOvV4TD3FZeIGsUUcdf9MMkutHF5KfqVKtYmFCSCXqO5GuwwpFG6lm6IVVtzd
	 LpgUZ7+Q934UMJJnJnvl4Ax2ep+64+pjmAyavKljk4KBbiz9J067TXLEJ54uclHQEY
	 UTtzfKNbX7rOtJs35REfe+0KnxAVy1MMN8DTary7pT+fNnaPpHKYQTBjJ6DUXHvyFS
	 V6H2s9nyK6jpFsSIfvLyuU+9PaPLQvBWPVn4f/97W4BV0IB9mNDO3mglYi3XmOr9cP
	 f74Er1HQYlZ1TFJxEqicTb0wRfEGihBbaqjxidkw4bKL1pMjDHcH1gBAvoVpmVjZZs
	 hfsO7Kv5mVPng==
Message-ID: <872e752d-c7fa-4a75-a963-4e2f42ce468b@kernel.org>
Date: Sat, 25 Apr 2026 07:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Lance Yang
 <lance.yang@linux.dev>, peterz@infradead.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
 <CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sqj6ubkdc5d34pc8zycasefxpm9kox6n
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D74840013
X-Rspamd-Server: rspam07
X-HE-Tag: 1777094253-90080
X-HE-Meta: U2FsdGVkX1+q7tv1+LdKhVxJjIk11PKpzF+niAvaLTeHe1TdxvqM5CsONHYJpbcETGCc+n/wkvKQ30GoAWyqvaA3YdzOi0b2KRePXmWpFcyDN6O67yXdxyZL9zwOEEtw6jUw3TQQSAkuY+oDUACgbWq7TLOGY2DJH7e+ihxSd4vJxo78y7oFSb/do8W2ECN+NHn3qXlyDuKYImlHq5WCP/P8ciSkx/qnh76Yqlfnlcu8vLSh4MHsFWgA2J4VbRzgB5Yt1zGzNtEQY3ukpZzXY6oV1UzqOGRadITJLKcfjtC5n2OhYnrKuTdsnBz5rM5d6CNtmPYIi1i3EOdXqG44TWEy6ozegk7ZDNvd8UujRXHZ8b4uZdLoOiKHdus9Bf7oQo8P5tBU0SdXXSbwSqGAeu+5jzbg9S3pJvAV9WgNHFvZBIlT7YRVy2Nv568ARuL+MixWgkC0T8hXvPTLCMlnsM3ll2odxEuhvSzvaedDX1ZXaD8QEYi33GfXNJTVBL5SRlUKJGOyuBrPn0t/WgGcKb2v4NBCbYXK/e8TmJW0H5jrvCUzUZa8dNdqK60u02dTmCH32rqH0+HtqJzs2CksTycWQWIq8oO/rQbxW+ZZgO/rWMeEuwGtzHFPxMGaSr2EXTX14pCNNJpfTq1Tg+2tjbeE8Qj0W4q7KiJMJM3AxzNobWiFCHNRmwLfQJ1CP3wx1X+ghLra5cBsC+MTjH85tC1IXWm56ss7ilFTYjlpN4WrAqdvm8IO983Z4ypmyI67poAnZU198tqUmEgEzk/yzy75CNMio83Iei7gsuaD1avnMDRW2no3aP0UDc+WuSx8gHGmZwVya++mxKOt6Qi0tsW/PtPV9hapU3rbfm0T074+47vg2LP5maxcAQETiO2vI1vDYhiB5OMq+0dUmvIq43d8z/UvEPgVdtlZHeQJqgNdD/M55jA7JKbovHT7vjwWrpCTsfG42v7A4Z5ecyG
 yZ27ZKQc
 UOFe00sUiGE05/zx21SaPfHFudNLJnYC0q2xO3eXDPTH1mOYS9U45048zTxoWh8IASuEBOrhpkoKegXy6L1WujlIjnoAzda7kS4QP0eBBoVPddVya92VeK0DvNUKmSnqBHcYXLjSxrAGewWNdON/k4PBBu5QKE2feGgcJ2+QWwCXVIbQmQLHBI1ixDnj+AnZzcdCBcZykUnI36ZIb9j8x0v2ogocQV0S4vm9FiwVLGdJhrZ44GJfb8ylXEAvuBh+5UrWGYU3oBlqrWG9gA6GB9FDr36OgAqgANpSqb9KX+SqL78i6N58RNKXP00Je4c8AXfLsGkE+uRpRL+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 21:18, Yosry Ahmed wrote:
> On Fri, Apr 24, 2026 at 12:09 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/24/26 20:50, Yosry Ahmed wrote:
>>> On Fri, Apr 24, 2026 at 11:36 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> But I imagine it's useful for reviewers to see Sashiko's feedback as
>>> well (without having to go look on the website).
>>
>> I read a lot of them, yes. Maintainers know how to find it.
>>
>> I even think maintainers should  briefly go over it before applying to spot if
>> anything in there is still left unanswered. But that doesn't need a mailing list
>> posting.
>>
>> I enjoy if contributors are aware of the reports and use that input in a
>> reasonable, like Zi just did [1]. And if they are unsure, they usually ask to
>> double-check.
>>
>> [1] https://lore.kernel.org/r/15191F7F-0D10-4907-B963-DA4EA0E36EB6@nvidia.com
>>
>>> It's possible that
>>> Sashiko is right but the author isn't convinced, so getting more eyes
>>> on the feedback would help.
>>
>> Forcing contributors to reply to everything. I don't like that, in particular
>> not as long as there is no way for contributors to run it early in private.
>>
>> In most cases, contributors just do the reasonable thing: incorporate the
>> feedback in a new version.
> 
> The usefulness of the mailing list posting is that it makes it easier
> to respond and discuss the review. Yes, what Zi did is great, but it
> would be nice if contributors/reviewers didn't need to manually quote
> Sashiko.

I think the most important part is the contributor side. A private posting is
sufficient for that.

So if possible, I'd start with that and see how it goes.

> 
> That being said, I understand the concerns and the pressure to respond
> to everything as you mention below. Maybe at some point this will
> become an easier decision to make as reviews become more refined.

There is another thing to consider here: impact on other reviewers, in
particular, new contributors, when they spot excessive review already posted to
the mailing list. And the first thing being them reading that.

-- 
Cheers,

David

