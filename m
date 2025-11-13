Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA775CD8C85
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B138E0006; Thu, 13 Nov 2025 10:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB848E0002; Thu, 13 Nov 2025 10:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01728E0006; Thu, 13 Nov 2025 10:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA8BF8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:30:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FD431A09E8
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:30:37 +0000 (UTC)
X-FDA: 84105970914.21.5A7E7F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D3AE40017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:30:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpEFMGxf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763047835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iJOtTMVD3vDu1xrrqghzFercbuhhPz6QU4Ku2BIczw=;
	b=AkKku7al0hTrN3I1z1/t2PradygilWRnRfkzEQBZrQWebtnOv7Fm5zmJF0ezDCbGVsUPYo
	K5TOv92uy+MrmiNP8mRIpHe8/r3tGNolEUhez+lOiPnLqQY4689/g3F5pppQkaJQaezF8P
	/Av7oTxGy1lNHYsdpzOQa3THCOsbYCs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpEFMGxf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763047835; a=rsa-sha256;
	cv=none;
	b=fOIdWBUHxanG9PSHBAEXmp0NPjIQZQ3/n6Q9dGR0iznvPFJQGiuAyexRCY1FgxEYW/UK9X
	L5U8vCBwYlQHOjVRFkefHI9H8uoo5U3/pzOHau1rKcz1YOAbLYq0u/3USk6yDRnpeB1kqz
	rKCTaZaliKTrw5Gp6ojGKdxlO4XOz1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A729544122;
	Thu, 13 Nov 2025 15:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1AAC4CEF7;
	Thu, 13 Nov 2025 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763047834;
	bh=tGGALCCjS204ssR6DDHUnCXjhFK8nMBYVU+owIpKMMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kpEFMGxf0CQGJGG9BMrBulPuHLSsbaZmz2F10q+U5lQNVex6ThzpOGw7+DyIt2PnK
	 JV0/5CVAlX2KfTg0ks5PYMUa+Oi5pyphqsK2EErkq7wlNXdUGarSi4HWS75zN5v+Qk
	 G++EoGJzrq+W5oj0gLFTPGyJl7KOSGp9Es1OUOubdrYn6UDDO2ETHBHpwGs1MUe+Jz
	 U8C+XjZX88rViP4mw8W8o3CedxRXAd6OP4hzOp370+Z18EJ7ZxaQk9jfZhrU9mNPmK
	 OUuZT3OTj//qPL0mMpoarjHmHdDHd+blv1yaY7uZfsNvXE+QcomCJPrRBh6t1+NqdA
	 Gy4FgH8ONHsZw==
Message-ID: <0c9f5b83-10db-460f-bdee-897396b49838@kernel.org>
Date: Thu, 13 Nov 2025 16:30:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: "Garg, Shivank" <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
 <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
 <aRH2pdhMBQ-20IC9@casper.infradead.org>
 <e38e8059-a62b-4ad5-8316-5af02a0cc1b6@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e38e8059-a62b-4ad5-8316-5af02a0cc1b6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D3AE40017
X-Stat-Signature: hjh87ngq1ef6araik8sma7z9ddtrpeo8
X-Rspam-User: 
X-HE-Tag: 1763047835-141951
X-HE-Meta: U2FsdGVkX1/dNkVK3kUYTFkbFVI9qhz4htnA0boDCFEliErXUA6cyAjUGVosrLGf6y9SQZqpqaqaGAlAe+Y6o5nQsTfwsgAik/koOPcGrfSiZbMb6G3pCWC93w30Z5SHM1mmhHLK0LY9Kqy60jsDa1UdUDJVLxLi4anFhqL6r28vLHQR1CjAvnbmBjP6hzxKFf/YuaD2p8QLYkTeo7A2p69zofPLgrxegtrHhVJUo+rMHOZDD+Uy/pyiBWIQpfmF77P/pzCov9MqHWyKt3/XQQjGIpUqtccrybNI71vaGC21TdpCRjR2mj1qmVLyEqdobssaVzjXzOMZMxnOpSLCb0CgaUymEYJjgScx6Vk+32Wz7B1QSjL9ntWtFjO+wiBp+Kj8QJ5Sfo5VEDJeFTiY039U7lDwf42s/a6VUlWFGfD8XScEnWypMfPHmp9HxoicFt9n88TItfuw1FI1OuOcSdKQnXr3AgLblw2ax61A4T+JIoCtri9yGe4hrGSc4y2eIAOnqf1UGpEXE7aWvOfxJKFrQHAqij3OAH4qY40eXNW1f6ew65RZlqyxdkvW4wLpOYhIY3s7CEZg+UH4y25CicQKRPQgy2n4eEMXtIfP2DObgZlKCWtg+BdkgaCN6ZLbY1gk1HDu8B1ru3aTdCgzJmFk3+INpa06mYpZ1YaUX4Zc4jjUiNJH3ASo2oVSI5JSY23oMGrNS2lx1oN4cc00twQGftY5ZmTaRx/eFDHNjQ/oLALM0ptnPkCniaMByP14zAvTPuESzRt8hwxO4+eKqggYLPDtcgIan93ywUY2PstlZ7PtvVuJgpXME9ivDRgFKcBS5GwLeJbGe9D7/Dq4uek/xxJt4wUkoghgQhxqMOIGpKxe3rI+8Q/kEF2JVX/LIcN44tNt9UXBzCFN7k+BuqdCtBRA3BN2FNaKxdKdOhSmVbKrcpuYz64aoH1R3Wh6guU3wvg5maxikL8CgGQ
 CBfxnLvb
 cwMYciLUNbZkZhjwcrWukW6T3+4E2BqdQZ6pyT9SZosvpjuuPhQV0kyfjsqIoHUfKM8ayCMMl/3c57N8vQKM7BEov8m1k3Q3cvfX+Hgi91vGvm/4+vuiosTxX+Jug1qr5mVt6QiXp+Dyv16SYBGL1ApWFLVbfIksuXGz9RV7dSA2yaiz9KARVoAXgqhUUkxA/4hx8O9a0aDyTbiBMhu6UyQCTfbD7NVy7zkd45u8k8FMbsexwMliLmc1cp/K7kbWS7qMvssxy2c0GTH0b4QwdVoR8YSwR966QgxbsoH9Wy4pUDPyyTR49sSCZAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.11.25 06:58, Garg, Shivank wrote:
> 
> 
> On 11/10/2025 7:58 PM, Matthew Wilcox wrote:
>> On Mon, Nov 10, 2025 at 07:50:17PM +0530, Garg, Shivank wrote:
>>> The issue is copying those binary to a freshly mounted filesystem.
>>> The page cache folios remain dirty until background writeback completes.
>>>
>>> Reproduces 100% for me: fresh XFS/EXT4 mount -> copy binary -> execute -> MADV_COLLAPSE fails.
>>
>> Yes, but this is an uncommon thing to do.  Really, it's the kind of
>> thing you do when you're testing something (like, whether ext4 supports
>> large folios, and whether that yields a performance improvement).
>> It's more reasonable to change userspace than the kernel to solve this
>> problem you're having.
> 
> Fair point.
> 
> You're right that this is primarily a testing scenario, though it may also
> potentially affect JIT compilers writing executables (also uncommon) but more
> research is needed.
> 
> For userspace workarounds, calling fsync() before MADV_COLLAPSE works.

Right. But do we want document that any caller of MADV_COLLAPSE should 
issue an fsync() if MADV_COLLAPSE fails to try again?

IMHO this just reveals a problem that might also be triggered in a 
container that just got downloaded or after upgrading a package, no?

-- 
Cheers

David

