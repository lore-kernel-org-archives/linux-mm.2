Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F304CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDCB6B00B5; Thu, 18 Jun 2026 04:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B661D6B00B6; Thu, 18 Jun 2026 04:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BD06B00B7; Thu, 18 Jun 2026 04:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3056B00B5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:48:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B051B406E2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:30:37 +0000 (UTC)
X-FDA: 84892362114.02.3D402C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D59C5180010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:30:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK7PnRy1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781771435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGhbQekJqWwn8AB1BZdGKXVYLktjfCTf6Z1qRB9iehw=;
	b=4sHoOwLvSxGlZTd2bPSOhY7MY5kasfO+CbQbcPCieGRNHBQUnvCmenftb4gObuo7Jm9nbS
	sqaCQeoE/OrckWc0tdSZgGpxRC/lOpG4/NY7Rgwj26WWBExWuu9RnCsrw6OdARaEmNJU5+
	Mv+W0LpGwb7zFGvG5C2XOc4pxWcsIjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781771436;
	b=s+z1vB75qOGxc6l9qxqj+1sRC3aLkV1unBLNaOjOWzMpQg6DzpjXHlrXX/dBInqTo4MIFE
	/nDIchSbqgMG2NqCWswHA1i7pZ9JdzucrpClo+5DaRWZFOvphBRo1d0kTNO4MCzsiJmX6c
	ut8h7ZNGiPoumc+2HBLmqSuEMPMaD2E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK7PnRy1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06DCD4054E;
	Thu, 18 Jun 2026 08:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6F61F000E9;
	Thu, 18 Jun 2026 08:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781771434;
	bh=nGhbQekJqWwn8AB1BZdGKXVYLktjfCTf6Z1qRB9iehw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fK7PnRy1mINc5gLPRbZ/6poyoyt3t0M5bTbyMiyuB+bCopIZKet3C9E0v4PFNnI62
	 5k+oajs2ANDCtmp8bMremIf/p6d8ZT8sdS9ERHa0Eve379SeQIuOT2M/1DidM9MU/X
	 fu5RQE4Lk+uEm1Z6yIBiCSXZHefqC16Kb53h0AvJ4CCDPCNolrnHtE63hLaVwARE3t
	 qn1kbie8UesGRg8N1K72yF7fpHszX+ZMuNWahliLPf6/CxseOWPKrbV7Cl0s1Qlg2b
	 RNsZWj9wqgLcRcdKgEPI6i5U6pMhz+0bX6xueOpDEWd1VA/0YRdMDVk0rsUJyGrfxg
	 7QgBmSYhw7E8w==
Message-ID: <bbcb6db5-6a01-46b7-979f-dadd52a5176f@kernel.org>
Date: Thu, 18 Jun 2026 10:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org, willy@infradead.org,
 usama.arif@linux.dev, akpm@linux-foundation.org, mhocko@suse.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
 <ajK1YsIJmD2ImbAk@linux.dev>
 <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
 <3149bc84-dd3a-43ba-826e-6364965fdafd@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <3149bc84-dd3a-43ba-826e-6364965fdafd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D59C5180010
X-Stat-Signature: n67jkiebsqcffq6z38bb589agn63csqu
X-HE-Tag: 1781771435-118557
X-HE-Meta: U2FsdGVkX1+rIRzuSrTCiU+kSRAEFz87VbM++ODtsQfhXD6xICXeT4pCPcCLoaB2erk5Km9Uw3NrI4iV950rdViyZ05IAUjn8vUBYoiuV1TTq7uso9DXVXN9GP9wDfsOecB41zUkTL7szW0MzHlvT838pZyIMSA5qHfVenIhfF0/GaFuXcoc9wMm6lSTH8mbzuUyF0DknRvobY4w0ZWSAq/9/nTCioaMQRH/EV16CThtz+iNgSG47sdppqZRwxoNirRUCGgb8HuJCqESMH9yhIM0G8s13atqABzyWPMGw7kbQdmSnZ4bHUzPXJpYLoMFed4KkL7X3O4bmBqbWP63KNEEwP/ZzFUXmP7q88ltCs2UzCL+vg0ir4oHXj5UaNnjbzFz6AaFEDlcNaTbl8beEzYSCzQChBAfwYIPRjQ7Q/kG83CzS9kJZ+bZSZt3zbzFx8h/81t47CcgZKdpZIWONVyhAWN/k5Tf4isTV7cci9levXgjoKrVegmd66ooDX1R5J+eklniqgO713ZkHNv9qfaE6cbcwnOf35sbwAKDjqc5cxacqwZe4oiAbzlSaTkTLLqxz8OPsNhCBNbKoHauqjHGf6gmMJKYW1TPNPmQUMBlS4Ix0ae/0SsMVfoxslR6U1Fc1uI9PgIKx0j2Q8DnQJMJVgXakQxQaxraPePu4389eYZ3QyYW9nq4ha0tgDAkQIWasc9MIlJnPMI1wLuipt9DnG5VgMyTg4D511S3lpFPo2HkBzGaYdRoPohWGZs+OrKpkoy7s7D1dD0IG76IlTkCsQD74xX3zRLZxDr7KmruwtoSKx3Jjo8gvRdYOR2G2rDC0bpUgDlvc7uZPWceDtPAt4wdlmMy/Hss+wbztsRZ9PcTXA/lvAk5u0xlMORBAkDVQQ7eGyEPM61E3ZT+hmARZrEFkkwk09tH6nR3ntUxEtImJsB+sWoWWKjd8j15AJTBW4Ylr6Q8kELmMfa
 DDXSTipz
 TQSnPd7BYA46w5NWsaVvQGnzc4JJxEEgqEvEkThGs53C4Enx4rB1E/wkBVG4pRoSS2JnNFULkoJvBnNBdNvKuK4kEO7tRrNAm1a/tlEIVE8ge4z/3nqQB0DMB9f0XvXG6m5WrRi9yrOFfJtIHBPHdpNq8ItJN/Kp7khlrbbY47zSponCssg1x4LhZRz551KhwV9ajRvLLLnImvF5A462ZTs0WzOmnH+xqUqM/SsM6I90rCyFL0jmTKvSAhQwAsAlW1w8K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:21, David Hildenbrand (Arm) wrote:
> On 6/17/26 20:18, Vlastimil Babka (SUSE) wrote:
>> On 6/17/26 17:03, Shakeel Butt wrote:
>>> On Wed, Jun 17, 2026 at 01:11:16PM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> Given that trace events can quickly become stable ABI [1], are we really sure we
>>>> want to add this?
>>>
>>> Yes, I think so as this is useful to get insights into lru cache draining.
>>> Trace events being stable or not is secondary IMHO. If in future we rearchitect
>>> the lru page handling where there is no cache draining anymore, we can make
>>> these a noops.
>> 
>> Yeah and I don't recall ever that a change to a mm tracepoint would ever
>> break someone who'd complain and we'd have to revert it.
> Really? :)
> 
> Read the context of the link I posted once more.

Ah, I see. I've only read the single mail from Steven that referred to the
old powertop breakage and didn't notice the context.

But I don't think these worries should stop us from adding easily usable
tracepoints.

