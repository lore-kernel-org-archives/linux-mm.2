Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3549AE81A52
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671D46B0088; Mon, 16 Feb 2026 12:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F266B0089; Mon, 16 Feb 2026 12:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501096B008A; Mon, 16 Feb 2026 12:10:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3944B6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:10:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B44E51D061
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:10:20 +0000 (UTC)
X-FDA: 84450958200.02.3BC4303
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E54264000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:10:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UentRwXd;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771261818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaQ0OXZDiIGvRtMFwDiNcSnzr/tYNYYL/vIV6lLWmT0=;
	b=5aeAs/WIbmwwwgiSPWv3QeS+B83oRI2dFjDIN4jC/sErjckrKjNL3YfL1T+RieD1Q+y5sn
	3waYz6PBSrTE2nBpQmnbBvAHU+5lJiA/zP221paGPk+uODcKKsXN3yyDCi/7aM+/Y7OBD0
	WD8IrqW90lfLiSG+AWitCyMkvoNkC8g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UentRwXd;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771261818; a=rsa-sha256;
	cv=none;
	b=k+ijSKzMpf+cRbX1FPsxfVhQ6FbzU4Z8gFCdIruSjbi07TGXvsg5oQ12sNRsZ5jJ4oaQWb
	JMaHRtZ2Aiv5SI2EmiJ4GOb3WyWunOKKyxwG5+bAx51RS39A3BfaXZi6vMU2b8df44oQBB
	wT3kddyvH9M/voPysY7TC2MxA9j56eY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C0966014C;
	Mon, 16 Feb 2026 17:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1248C116C6;
	Mon, 16 Feb 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771261817;
	bh=v3qrqnJwZA6qFwCA4Mm3NnqaPiKrQfaTE3E7NoIivHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UentRwXdklwDX853Rt/zN+0KaUCEVYjvV9lg6ProwkxjclQIYw5SdN7hPO+by4E49
	 /qeK9dKOtmi+AK0m9lHRJoPJTUvg3pYN3B9C8xwUgmL0eVGHBSgmRIs1MuDrTxS7x0
	 6VHpUGKBDOg0Dk/3FG2A2Rju8DPAXUZLrae/07qsM/hWt6gZd/ojr07/dC5C1bnFrk
	 sSjw5kDtBn1aKBcXBshbnCMZNU+AHShTg/+41IddPKEPq+dt3Jmj47+ZMnBr0EByFB
	 7sYGDzUDlP0BOM7DizK/cEYUu14q8Gqt5F2vV6ZHaPdxMC6zqJ8I9o+byk71PaUV3H
	 qtyI6ITx2TTMw==
Message-ID: <18ea1313-1142-47b5-b5b4-5c1403662f86@kernel.org>
Date: Mon, 16 Feb 2026 18:10:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Matthew Wilcox <willy@infradead.org>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNJZTiRt_vm7oKq@thinkstation> <aZNNf_OkH-4DXDR0@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZNNf_OkH-4DXDR0@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1mfwfrpssyfp17bqejgzin1anxw9moh7
X-Rspamd-Queue-Id: E54264000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771261818-680277
X-HE-Meta: U2FsdGVkX18I479R0KY0gcPO/M7FgXZwbqdyEhPWoxAwSnAEWXtJZpeX8ulPU6cFBwDt2ag9+70AwNs8NM9ErtRT4ivybc0QWPZ/qUqhmE2Ma1B5uY+mvsLhfM+5qY/fGzglxOkiEb4qJgzla7Bd5uM/xjoyjFmQCwvpKsJwfCkluvhlMld2xcYDfP8t4NzpsTDRV2CcSz0hNDfe1KZkcDAuddq/ttUPQJ2DOVHEXZDeosmE9N0mVtpT9GDGUgWyplMx/U00vSEyMd79DfSwgpIjgFHuML9iiFqjK/+Goa6pjxkJfcbpNAP+5Eoa+3UtZqnpdBaqQy9/IgA6BoxWGXi1dz7nbB72FUr2kVI3r7HcT46mQ3nBmLSrIF1OGY2YpYhjnahJ1jQ9hOhe7Sb88JtHeJHfKSL4fsiRSwtCabWYFSWDjEpvtCe8or4SrLHaBBscpxLRfYYmXeQ0F66ft1XAZr/4W7v0ya9iNA620FTnrpa2Uye1I40JvdBRD0F6qhDO4/DRICEo7CZr1UeYPj1/+ChRt3yFmk3lpwptZVyq26Kg7raOVd282Fvq1yJA0HUC3X7s9tjIYxI0UGfQAO+W3IW60N8eb2xJoJ9JCs7HNXUDCC3+oMSHR/HA3x8QPGDLHqPbOkekrzRkPMLYQ+VeGiPFTUBScO+IluUBbeY1eUUfTm8GtE4AeLdTMgE+kUBg154vSKOju6Mc9eSnl4S02/EiQTM1qXK7XB4wo5VosGGSZ8jHeSHxmzFGg7QqtmkvjMLfrO0BVLUzEfN3cGg32pDaUYWw4KwFChi4ma323F5QaV1r0eQlq4ftQUSNSDuP8y0NoxzPjyJl9O5jxirraZBtANKj28ZYe9jeUU+pfjP8Sbh7LJ6p8dvHMNrg6z0fP4WLU5r1zg7uxQXrnC5Bi+sNNa38zmZu6Ydc9a60MKXJUxfzpxw/FUcH1mk1co3GlQ4+uTrhghlxwK0
 xS/Mlxc3
 +nbF3gCy4vyRNrbCOSAU5iTOE9VZI73DlAr5TvsKfBCKqHtLF1SpeiUpO05kx26E+pC3LVxSu5M6Q25anP9UglM+Bi83ZH7K2gf/KKjFwAohW2zzXjRxZZ6FMp4IihqF0EQHLMvrDKVX7pup1EHSg1tCPqlbSdRZpScYdb7K6GQC6S1WkGd9MFg2qQrRHHV4ETN1zKnoKPckndxSldFyAHZ4AIh3vHSPXYm77v2Vr+ogizrTsishrZazVginSIpwHzjoC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 18:01, Matthew Wilcox wrote:
> On Mon, Feb 16, 2026 at 04:54:05PM +0000, Kiryl Shutsemau wrote:
>> What I would like to see in the kernel is a syscall that return the
>> memory stats in binary form. Something like
>>
>> size_t memstat(int pidfd, struct memstat memstatbuf[], size_t n,
>> 		unsigned long flags, unsigned long start, unsigned long end);
>>
>> The syscall will fill up to n memstatbufs, one per-VMA. What exactly
>> filled there defined by flags. The return value is how many memstatbuf
>> is populated. The caller can call it multiple times to walk address
>> space it is interested in.
>>
>> We also can have a flag that mirrors smaps_rollup behaviour and collect
>> all the data into a single memstatbuf.
> 
> But is that what we want?  Let's say a process allocates a 2MB THP, uses
> 12kB of it and then forks.
That's just like all of these entries (Rss, Anonymous, KSM) except the 
Pss ones behave.

-- 
Cheers,

David

