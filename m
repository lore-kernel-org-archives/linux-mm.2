Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40ADEDF023
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E448B6B0089; Fri, 13 Feb 2026 04:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1BC6B008A; Fri, 13 Feb 2026 04:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4926B008C; Fri, 13 Feb 2026 04:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEF036B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:08:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EE0E8BA01
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:08:08 +0000 (UTC)
X-FDA: 84438856656.03.04225B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EBD240010
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:08:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAowi5Yz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770973686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=za1+0L2QF18SNEZLji57wmTbv9OGEdon4jMye9CqBt4=;
	b=nsB2L82AYmBdf22z+L5UxgS0niOp9nmbbKIC2m35T49mykv2U+3won/eVDRjKfRz1wFfGH
	sG3GC78zHyMN3+5qx2WMimYHd66aZwMREGiusKUfy6tgNDCmyAeJ+iWYlSenW0QiVs0Q2g
	Z21Ei2hRIQzzWIW9zi4ehrDWFg1N4Zw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAowi5Yz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770973686; a=rsa-sha256;
	cv=none;
	b=ho/fC4f4nAmDz7lLinW+Mu7tvndvAP8Uejr+73MfClLiGaZ0PI8lz2tqGH9XAw18whgX9m
	p88bZf2uUXlZT42w/rPT3Hy8DyNe8PIuT+HlSdQuyrUYQvYAx1wLPfJW2AuwZN9BKFqTL/
	6R6s1m7RIsDAziAVU4Xk+5C+G+AkLl4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0E9B6001A;
	Fri, 13 Feb 2026 09:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A976CC116C6;
	Fri, 13 Feb 2026 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770973685;
	bh=qYw/s+tVSm/qM7WwKuniHBby8k7wA9GpwnN8JhhmYFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JAowi5YzJfgKhkcuBheQjBFOfD8QRSLcbXC4M3SkmT5FgBHUB1HQTJ84rQN6kYdeW
	 OxeNZ8uU4e0UJTDmUOHFeMKCN9DWxX0JC3o5BSnhtDKSZUfctowiWhH7JYyO7Lj9Bm
	 2A3kz6Q0PrptvJEGiEKRBvudnKVRq4DoEvCGwJYKytOhlk8ZcUujx6Lx3QoYyhOKiS
	 DX9EbRqj+3FyxBpx1yk3yVlkQx4i0DjxwxTNVJWu3Lgs0qoxoccKrRVDiHz8Lrg0bv
	 wBVlhiTg+WZcGrRuZh2ZxisglIQSDCpcLBq+gssDMm6SEDzTIwUsN8HMbkdnmOhKlt
	 nK8ymODyG4fYA==
Message-ID: <f5f0f666-b9e5-48a1-8e4b-e7647e4103f6@kernel.org>
Date: Fri, 13 Feb 2026 10:07:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
 <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org>
 <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
 <c48511be-047c-4ab1-bd49-f2c4899e3cf5@kernel.org>
 <CAOptpSPx8-APDtkrobTWrf10L36dRLdDTeZOwob6t6twmdbQ0g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSPx8-APDtkrobTWrf10L36dRLdDTeZOwob6t6twmdbQ0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8EBD240010
X-Stat-Signature: i79sarhmdycpozisjmodnbg4qjnmbek9
X-Rspam-User: 
X-HE-Tag: 1770973686-740646
X-HE-Meta: U2FsdGVkX180aHXYUL9zM6nKuHFDEncnsylkSv250s0Vk6813xy93oSsYetaQiCdE41JnPfQ0nuOMvxHLkOJ+h38dbHyTSroIySnXNTEnl9M2fps3GvTlSJ8y8x1pl3k7cwmP+CHhltqWqSPp11kTb4MSEaFZ/QG5I1Vq5IVM5ZL4JbE5hCRYxL/zkcGv9eSVGOOoX316Cr3P/zODhUF15rMi9FMyiWSETgaEpEAunRZ9oQU/kX6bOzyMYdd7xI4OQhklQ2nWLIwfrqIJPHD19qpJjZyUnnKcZCslNEhZWJ7oOsXNO2RtDOSuZts20rZj1Ov9vobuPGtDJ40IHFVTw1dybEZD5y5XEpersHRaPnTIn2AAd9FPQAOnnkNDY/e0P3HyiF92FuYQzZ6LfBm34qfWMyONWO0ASopWwH4urP7h2j5GVdH+9MIxTkgXnyxB+R+lfKeOXfVp9sQmS/Ftx5pa02MsLRsnhnOToApK2xq2OI9E663n3N0HbHXM3/bAhRUXY7+IjBPbQF1Ae7o72YOOpSWS5I60RDgOgDoRzHmQu5kDsQzVgWke4RQ92WC+JtdlUUFcwXduLQoSzeDw5Pi76aEBu03Q4IW55Br1YXt0PWHWtw2bn0t5PXTWulKVMXkxLk8sMXmCztt5ofq/xMv1SGA3qBLr3Hkh3c6Fj3Oz4e7rTgEmZeKp9B8/8ezxqhbgDkh8C2KZeKP5cTJuo0i55R/4GK0/Hja1esFUE6Jvb38DhUTaXbklaSSnFiwcKxDQimBZrPc52L7r/MwONGsTOhZnGxayAjxhmYNorgIUMpWv5ez2Vt4yVzaw8++ugto4/kqmDevaBG1sdJfDsV0vbzH5BK2xq+VM7uXQVdhGIE86uo00A4dd6xhhuQ5JqXJmXx/mHQnw2QA8gZSvHbco3T7/MG20gGRXDo3MMg5vSiDbw1gWGekQflK6EL2JbiJhlXDVJs6kLw2B+u
 9uCSAK8B
 TzKisOqX0zwwq1NcZWRreSCkPeufo32AY0Q2f+3ucky9yAa6AosAnkaycn4UazM2tFGIPMbeqoCBHCg1t7+LFmarst5xnbp49ufZDV73/xXictjvtAUf/JjLDFhN+EXoQoDeg9YIryoC6FPOyYoPhm2pTCk0YBIGS2JrLOR3eA41R+HdFgS9w1CzogU3azFNKevn+zmSdZqMn1pX/gEtYO4ediEjp4qvqZBEQ7HYrK8ENYhX8lL9NwRFumlPW3/Efyh/BvOFokjcQgTmXTvyY2JkpBcda0H8t8PrGPAk0zJq8J/lZ0ISyJfVUQZIBkhGwCDOifCXK9g9AiV+fo7Sk0YSPxuVflw8QE5hf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 10:02, Wenchao Hao wrote:
> On Thu, Feb 12, 2026 at 4:54 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/12/26 02:57, Wenchao Hao wrote:
>>> On Wed, Feb 11, 2026 at 5:05 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Thanks for your explanation. I now understand the design logic.
>>>
>>> What I’m proposing is mainly for debugging. After enabling 64K large folio
>>> on Android, we observed increased application memory footprint, especially
>>> for anonymous pages.
>>>
>>> Since Android app memory usage depends on runtime scenarios, we cannot
>>> confirm if the growth is directly caused by large folio. We want to
>>> analyze memory
>>> usage via the `Referenced` field in `/proc/[pid]/smaps`.
>>
>> Scanning for zero-filled pages will be much easier and more reliable.
>> For a debug feature good enough.
>>
>> I'm wondering what the best interface for something like that could be:
>> we don't want to make "/proc/[pid]/smaps" slower for all users.
>>
>> Maybe we could for debug kernels.
>>
>> For example, adding with CONFIG_DEBUG_KERNEL a new entry
>>
>>          Anon_Zero:
>>
>> counter that just tests whether the page content of an anonymous page is
>> all zeroes could be doable.
>>
> 
> Apologies for the delayed reply – I was just writing a demo to verify the
> approach you mentioned.
> 
> Using the CONFIG_DEBUG_KERNEL compile-time macro to isolate this feature
> is indeed an excellent idea.
> 
> However, in engineering practice, it requires recompiling and
> replacing the kernel,
> which can be cumbersome. Could we instead use a dynamic switch to control
> whether scan for zero-filled pages when reading /proc/[pid]/smaps?

Maybe a kernel cmdline option could do? Selectively enabling it for some 
PIDs only is not really possible, but also, maybe it's not really needed.

-- 
Cheers,

David

