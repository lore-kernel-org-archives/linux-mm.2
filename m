Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A9ECD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD3B6B0005; Fri,  1 May 2026 14:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155FC6B008A; Fri,  1 May 2026 14:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39806B008C; Fri,  1 May 2026 14:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3E406B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:31:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940B21A0237
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:31:24 +0000 (UTC)
X-FDA: 84719693688.05.889F23C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC67218000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:31:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOXBGZe6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777660282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vcit5VCNr9VXoMcOQyhMxOCECO1DhozwDepgc0vBmFo=;
	b=svMWNO2o9Xzcnxb7LmWOemkzYzbiCK2+pe/il7TvX2MOKUF92in0CWzhUoVPwDGyR4+fdH
	0g1EEMq0adl41t35KLr9lX0bq7rdfCYSkef+eTOdjIdgGvfEITfQfBnRZdzQVF5qxhAfeG
	7BNNOQy6k96FER83hx97SVN3ROziKNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777660282; a=rsa-sha256;
	cv=none;
	b=wbf8nXvaMc8CSPXQFq6WRmtikKlzErdOqXGJUL7f2zTrMy0qZr17jd1WJQYAOs9NRFxXyJ
	y037WNKb6CEO/Lc4pc7dPsfDbECr7C65cfco+UeR2EqwvznoQ2Js7CvzSNEKMB/Wp7mLbI
	xGxUSfqbpKqtPFzJX/aUTbNP+fis8/E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOXBGZe6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E931600CB;
	Fri,  1 May 2026 18:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784FAC2BCB4;
	Fri,  1 May 2026 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777660281;
	bh=pdBhaxoq9o0qOnN+Yknh2CCMcfvnW5ZHZ6zv+m7ScGo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UOXBGZe6HXDI+9k+t+hX5vdUraYSAXO+NVzKvsffxxj7bXprDVSL25/ZCs4DdzUvz
	 X123NOs0cSox1YxiMi4GCXX0Hc17eXiZuocwo5xJY/4BVLGWSUmjWUyVP3U41g/l6O
	 YQ7BmuBRFuTBayQXI/dV1x0fEqxDPHtIobSL7lrzK+I4/7yHiFiow1vLbhMlJlkzKP
	 VpO2TdqwBFsNmU22PgI22Q1LbxR842MEDI8Vbygr5/O8U0d9WgCuvFpxSo+tfQHprs
	 QgT4Squv+NgLZhFY1zEFkTMzn4m28zoCZj7yUCNokI6l3SB5s6MQxyMuiCrBfTnDON
	 kvBriNzWnbsuw==
Message-ID: <36e39a90-fd07-4458-b17a-4e7c176dd4dc@kernel.org>
Date: Fri, 1 May 2026 20:31:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation> <afTjKnO66Hl-XmfW@thinkstation>
 <01ea8acf-69ee-404e-8785-59fb0a527253@kernel.org>
 <afTstzZz-36KxthJ@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afTstzZz-36KxthJ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC67218000C
X-Stat-Signature: aatbaf6335fsaefcc1jj5r8dy9xretxe
X-Rspam-User: 
X-HE-Tag: 1777660282-870544
X-HE-Meta: U2FsdGVkX18gdKITeeSRSZmpcIp5jnH4tc/eSp96RDFvzzA7KGr0WMfT3rPjUZECXU+3vedLaVF/RL3k/8rNNQTtVPUnAQ8PctJaVrq9ho6g8oaLLS4vyffF//6UO/rgSMv/ams7DzIcBGN1OIMnHoinJy1eWOoFoxld9wE6Z2cUtROyXogUUC37VY120xnuJdKMnj4Yf/VDx83IrveMTF6I3H9a396HdRSaay7A1+GEhohtWI4k4hhNYaeVt0f4pyuaH0D9STiXWwaY4LfeGsLZfTUyZI8btxTYlom7yf0xBjdM+s82sDC2lv3zfXUuWeq2w279coA2EtrBkb+fDP//WRZeQ3DiZKKVOCtrHxGyFNfVexkI6orgaFfguNZLITzCE5PsHIYk5tuRUwXtnNvTyVv+zPo+FleDCdP9TlbUOGRWWFFLfcSozzn4TZJASUF1KT2dGIcEBKJnKH5FBm0qjQgqHjTWl5sPrhLqpgFPbFGAbsnMshVkbudKJolmo4LVTRLCKtbUp1E0hbA/tJHOK5FeZtlwwx4XiXzDOSv430HUTuRLsG0MwRI5G6pA/gYYvSzeMtY7/aDCjvTuGPpIjngI6O/alkxhPyb50BfEMWzqSv7xjG6A4pXRPMbA2ReTuOPsF577CPDOsg/GNORGw7C0W95UBicoBoSQ8a7UTgTyf7YZ8artOAndus5shmCg7TozVyYwhgSjYxvRVAWQSiZt0+cFiGS90JIyHlsKih2pD/sz4mP9aOVQiQb0as0jyOb3LEcRTTf93gIppYJHQ29Ae+DXTrXxz6gcaJsAjpLkzvNGKjD3+cF0v2rNb4IemphskuII5hEMGY04MpRfouV/5ameZkm+k7bfV16WgEnT0BaPVaUjcLqpS4Xhz7UO6dVG3mjP7iR71m/EsPBefNIvJ6kcpI+9Qv6EmZYCmsWBHx/I4mwpLk7qUxFQvFftXVKBhWKQN4WudP0
 bLXGvAEr
 tVcrT86vx4F5tudwwWhU3pu23b6FnGBVDHe7U3D1QhH+wgVwgyy5OsIuqQDDqBufeAXy+geaWHg6tvADXD+zD4BO9ctkTDBaYQT/Z2S2v8SkEuXaHdbvof//wzHoOS4ZOyonEDsWgTdCT7YGaQXt+mJKvsNZohSm2XOumOR531HXa6ZO5T3WHSIahqqFpIRyy0K7WlemHOISWlrZNU2JG6f1qjGKAQfe5vkNl9VF8mKs+slz0VT/wJHwU2BeLLUiLT7ku6kPU9IwGdiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 20:12, Kiryl Shutsemau wrote:
> On Fri, May 01, 2026 at 08:02:28PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/1/26 20:00, Kiryl Shutsemau wrote:
>>>
>>> Just a heads up.
>>>
>>> I've updated the tree. It is on top of v7.0 now.
>>>
>>> I can boot my VM fully (not only to shell as before) on all three page
>>> size 4k, 16k and 64k. And it doesn't crash immediately.
>>>
>>> Page fault handler is the most challenging part of the design. I wanted
>>> to flash it out to RFC quality before the summit, but it is not there
>>> yet. But it started getting a shape.
>>>
>>> Volume of the code changes makes it hard to deal with the patchset:
>>>
>>>  1530 files changed, 12675 insertions(+), 8669 deletions(-)
>>
>> I think you know the answer already :P
> 
> :/
> 
> Let me present the case at least. 

Oh, absolutely, looking forward to it!

-- 
Cheers,

David

