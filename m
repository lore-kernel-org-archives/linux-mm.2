Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FAFEDF170
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4115C6B0088; Fri, 13 Feb 2026 10:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2A36B008A; Fri, 13 Feb 2026 10:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB7A6B008C; Fri, 13 Feb 2026 10:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC346B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:08:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE3591C5BE
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:08:44 +0000 (UTC)
X-FDA: 84439765368.28.F94F48B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D85AF4000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:08:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sK1IjiSC;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770995323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nu2gpGxkGLyhK46cAjEX87LSAqSH3W+w/doPxW+RIKY=;
	b=cgtUINFm5ifAsBLzax6R5teuPboM3wefZKTRrjlIbSg8/mSOb+6dUEUnZpxVUjeNFLX09c
	Svxl+z+9Pa1CN1LwuTAYGO7Ed6p6lteiTsfsaWN4dBcnxFSOmA3R57lYVZ5Uw/V+ySyNnj
	re4z/EZRqb1XMu2tugMQ/zDtpQnezwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770995323; a=rsa-sha256;
	cv=none;
	b=LX+ZkkCQqd4B3SwlySaMlC7l2bgQ0k2PSZLfJsGQHuyEz5Ha/KHfcnknvPrvY5byUHokYV
	oP7Izi2nadyvVKBmicQm12Go9/cdEIdbNxrsFXC0tiz6pg8lWj6bGgbv14IXldjuuMK+P/
	Az/lxYDtMmgQXKJMS1Eikd2Ld0G53Fg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sK1IjiSC;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2CA242E46;
	Fri, 13 Feb 2026 15:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF97C116C6;
	Fri, 13 Feb 2026 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770995321;
	bh=GXBtj1qNC6Jblz3dIZAJPiDoGI3O8kR+BUHee7Igrxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sK1IjiSCmE0y7Sh4IMcY8/2LLoIK7UQ4n8wkOCBdWaLEvd3rdW70ws1cCiyAlM7Jv
	 Bf6VvLoH4l6aMpSvSl6TJUVgHLQ4/w1vHBNwFj8hko+9w/YTq5RyAcMu0a2UrrHN1w
	 SaViNgvq9gIUqvJy3e2hbju3fiYTT59ttIJ7gcuCPIXvymCRIrQM4M24jfBK0S97xb
	 n10y+E1+4yXB1aUwPVma3ihjViDfZ6g6Pl2izTuq4eD9qtGranD2KH6rrfKFye5BTs
	 /lMJH39wQmgFZehRfcld42W49t/HDxsFR7jyOpR3vA0pgDS5hXAVkbwirDoMK8w5Ru
	 cy6/AeapB5wgw==
Message-ID: <edeaa5cc-e805-4cc0-8886-32e1fc341815@kernel.org>
Date: Fri, 13 Feb 2026 16:08:34 +0100
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
 <f5f0f666-b9e5-48a1-8e4b-e7647e4103f6@kernel.org>
 <CAOptpSPuWb7u+ONYAeqsAOCkheqg5oGW23ARc9D41mnHDAXajA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSPuWb7u+ONYAeqsAOCkheqg5oGW23ARc9D41mnHDAXajA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D85AF4000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pkafqt394bjqj69ypgq3nz1r9kphtj44
X-HE-Tag: 1770995322-922707
X-HE-Meta: U2FsdGVkX18fqG0uIw7fq/uBuH21vYG+moVT7jSjw3vrnYZqEjN/7SfEAJAZJHDxmxnw8FJuSq/UYoCn4Gx8tlyPIptNO4x1ocC7glPXgt5OLIen4RTdNCIU0RWy3/cwuIRHrl1u+rlpYIYG7LeSw+HA98rG/jY+z8Yjywc1cwmnGdJ77RKV2FyQ3eltxxT6lU20SFDCuALKyDGNJQrBV5rGBolqPvgmjC2Nku+a8aRpzlFJZ6zDEZQEi2GXir+iqCBCI8b244AgqEmUQT5s24sdv0oEEQvOjmenp7F15e1/bdcrW1/JSz9UTDH4tb6AXcVYjNX9Tr4wKpupqPPOuu+CC9jH3HxONjFWuEBodbqRUQdNEaQQ7tiPoLbHh7u7n7E6LnGooV8mv4uU5qPZ6tr0OCTP7gkk64QOopTaazN7SDSQX8Ef5KuwDYskIdShAe+5eqea3+qXlipfy/Spd96GL+OaWa8bSa0CfE/nPf3dvBWt+q+963PquwKGP2CVS0GJdErwactK4xsMUx5uCvGNhWSq1WW5NKVLJtaHZCyKz4RL4f9XI57EFD9dGjkGWIhhWPJNhzJwjy4brWCd/uGgca17FJMpBD/2aDSAqhQ2cr4F9Ich73gdxKcbvcK+UGtYtQM8H3/qzX75Qn5F/JKoDAZKpSAW24kM/5aSQ9GnqFMwHXEjy/sIAn/dTNAOkMDNzJWXInkYUUDH9cGuDdQ/dYbz6shsUWXEmTAbzYivi2GWfPQM3fE1xrm4sDMKE50rc6TmD6HTh9BzyEbX7ew4CtZPXokfZzzwzUKyyfdlTBgBzfMhdl8Q5N/Z3JOGA2uB5lTVsy2qU9cp/y82tAZVnWGcC1yItJ3qgGYYCmQ7/+bDrS02d5B1HEJ0cZPQRokYDYcZACNFu/ozShZr2t6tB0qEDpzw/Jt7kh1HPwU4JVoNUAOXj5Ku7hiqqnqg8LJtFyIug9Vd0dztP/0
 7kSYU7Lx
 ntpqChJpIAi5RzUv46SYPq6vWHqsh81AiVM6ytPXC1gv7hM4uW6JVzRhmaIvYBEyngi3UrfB5F5kn15QaW3pG1lCPHHBpqGi7xOHiqQ/uL2liQvORSs2ITi/+6n6L1GjA0XRGhUD5j5YoUjO7qsIUDPwNYpqhza1xnmDLdF7XWAX5DiXq6ODIcQmwBshgLGqeXxkdnXKtnJ/dZwdmYH0jqh6miiStQkSORIWiIS9EuOqfQ2qTcyHJu4ofWYB1BQ2I5zeS7AyqSJ5YDKIdzxoDw6zoR8TifGEldHIg2ZLk77lBn6zAbwqm0Zwqu4cIqjGB5bZXUxHyghny6MIqdp93z0x//bk6rM0nQTnP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 15:52, Wenchao Hao wrote:
> On Fri, Feb 13, 2026 at 5:08 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/13/26 10:02, Wenchao Hao wrote:
>>> On Thu, Feb 12, 2026 at 4:54 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Apologies for the delayed reply – I was just writing a demo to verify the
>>> approach you mentioned.
>>>
>>> Using the CONFIG_DEBUG_KERNEL compile-time macro to isolate this feature
>>> is indeed an excellent idea.
>>>
>>> However, in engineering practice, it requires recompiling and
>>> replacing the kernel,
>>> which can be cumbersome. Could we instead use a dynamic switch to control
>>> whether scan for zero-filled pages when reading /proc/[pid]/smaps?
>>
>> Maybe a kernel cmdline option could do?
> Kernel command line parameters can meet our requirements.
> 
>> Selectively enabling it for some PIDs only is not really possible, but also, maybe it's not really needed.
> Yes, it is unnecessary to do that.
> 
> By the way, will you send a new patch for this, or shall I take care of it?

You :)

-- 
Cheers,

David

