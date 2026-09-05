Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDA9C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 08:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A396B0088; Sat,  5 Sep 2026 04:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B446B008A; Sat,  5 Sep 2026 04:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539A66B008C; Sat,  5 Sep 2026 04:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA566B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:17:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A019A14028B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:17:22 +0000 (UTC)
X-FDA: 85179003924.24.4D83495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CB9E820003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:17:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoxV3wXo;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788596241;
	b=nNKjIReUXLLrCkZzA5GukvRzzlIK/IxCfKfM7+6kkdUvda+QDrk5FNPD8C/p0M+a8fdFbQ
	21AGmxdNOmV3naK1/NM7WmE1NKYfUplxBsG7d2yrSiQlsLGJtYkDjPQEhjGStByi9TMuuh
	QDX0uwWrre8mD1GJxWxWQFmtfXh+j0k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoxV3wXo;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788596240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLJgCK/i7KKM8Qt6Jp5xXHsiNpOpodH+suANyKbQKNU=;
	b=4UsN9/ECUVrAIv8LiwEfpxYUEWh/9ofIHJVgdTmdcTc5wbzxyHQxRxTfPYM/UmRNCv7RUT
	UYr+GHXIO0ZDwjQuJVb2Cgwkj8cjcjfvTR6tYimT+xj1IBU7k4P5Lnsy/uXM90+nfzgS9D
	ofqamCTiGMepQ0QVJM35UL9iz05M9E4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DFB243F61;
	Sat,  5 Sep 2026 08:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2421F00A3D;
	Sat,  5 Sep 2026 08:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788596239;
	bh=nLJgCK/i7KKM8Qt6Jp5xXHsiNpOpodH+suANyKbQKNU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VoxV3wXoLAuRx9NK8llC5I0vnXUaegWJXpqBavZXGXulCjB7XsQs1OmEbBq8iALzd
	 4w3R7+NVl4MjhZjrS9tjrGSYm9b6XQ+JU7j9Xc5HQ1IJNL2U7kCz+5rK1yJ6pFVBwJ
	 IqbqnWqV+dJWBIbxCztuaDasFWNPgPs/aS/TpZgZkKPLpf0qnR5lDjftcmEgZ3GsgP
	 Pp3LL84KB4SNrSFq+hdNzmS3PEyLy0mncp61J7583utLqhR3dSLiO5KDEL+ORgPgLE
	 lN0Olqvgusu2X+fScH2LEghzP0FO+CAO1mEkdZrsBAtnazzxP04S7xytun4VkvUifj
	 FMTRJg19oWMnw==
Message-ID: <929d0143-91c5-4b47-8e38-30675b4ace5d@kernel.org>
Date: Sat, 5 Sep 2026 10:17:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation
 scenarios
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mina Almasry <almasrymina@google.com>
References: <20260714021630.1063823-1-husong@kylinos.cn>
 <20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
 <apqBn7tWDHQeMrzB@kernel.org>
 <20260904104812.7ee79803a10ab355ad2cdf81@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260904104812.7ee79803a10ab355ad2cdf81@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB9E820003
X-Stat-Signature: mjzqa6nkin77rw57dyrc5wc78ba66yjq
X-Rspam-User: 
X-HE-Tag: 1788596240-263390
X-HE-Meta: U2FsdGVkX1/Pj43aKFmGGwsYqYf7HKhHbmWsZr9RgeH/i1+HYmRhf9CfQyrWJM/Ujm6enWJb4388eAYp5N10XR9fMWDPX8r4PdX6Y9ArWYZIuU7Inpn9rAO2EVDKDWtu2DadCdsilpUmO0MVF9DfbWcrCyJ8JRwSTkdZ3BBug2c+imgeBOripvbLDCYcABRShHuKrzSm/MJiePWRwpdtzbC7f71pWowc89d1YV2iwiQRqKul1VXhQ0wb83CygBtTrjR+D7aYVfgfXOmfJXOnG7W722yS5NFJk3k/lh83WkUP7lW/a4S169tuMczF3Y7uIpMk/xyDCuPFeoZ8nV7VD3BfiUAu9Onyoap5tKV36IGIGyJk2y9u5rOjjx/0IrHWXg3semwtHGAuIbXQ6pHNpi/FLlYk9y3wpUFWjvRHgI5DM494JrqGqURg0Ydk+s9KXU+NeaPY8ShI6mK3xcTsE/ZGXREEyAyOMP6HzqBnmrof67C8fvpuwpSXA9U1bKSuCe1GxPQpVv3dLJiP2la70RE/afeRX9PCvaifzLJHvL/sZEYQHyGl73K1jEvmuIppVoOSYIEAI4T3dGCLf5fI8RFi+sJXqiMGhvODRHldAV3K7nrfZ9wLcw6+ELJ/oAAQssiGO7bcq4e5+WtaHq2p70ozowh3cLzMNx/T5scNvihcDZbTCWIHa5FsY9PT66eZ9lLLREziknN2PrLAV3jyFUxq/MX/Ehetv5AmS+rN/SWbozwlIgXwiOcsl68YJSfO6zrflVPtq0bLc8HmaHE87qXvTOPs73j3AG+tEIiaT7lwyOZe6c7VnjWBxh5sxtcNLeSvVhjjd4LC4slZ7yxT4Y+cvzRbpjCWdK5uf3C9F9Yo3q9HZaQR6nmOauHL1sLF2BZAkLP5pJEAsdo67ebT0+usHkn3N3AyIFwg0VXQy7B9MQJzAxTl3bAyJe69XVE/dSLjMOheABB9ySjOLxU
 3c7QWq9i
 vA5Z01LZosDWgWIzmnyVoLmiIyqgq86uxfvRosKh9ZxfBfsnW1zkUrosoTdZPij0ogRMUSTb9W9UyBHAB8qfbWgWBBIZ+lUZdF0ecSCzZ5h6GNnJlcfKng9ivf5GEPEzOVxMMKmc5sBZf+nAdt3XxWhsYjVF0ptLdawf+gUs0Ih/Z8ErhHh6qihX4nzfuPMwJHGnL3izISVwHWJzzIY8FCGmIKQGSD6eiAkq8X+Myw4tWi5qdbJp8MWKVnX82Em+5osHomeE8KgkkQ/7a9UZVTY+z8FIDIePyJQj5r6ru+PTUDL1/t4fjUR+1nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 19:48, Andrew Morton wrote:
> On Fri, 4 Sep 2026 11:30:23 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> 
>> On Tue, Sep 01, 2026 at 05:37:48PM -0700, Andrew Morton wrote:
>>>
>>>
>>> OK.
>>>
>>>
>>> That's reasonable.  This code was added by Mina six years ago.  But
>>> he's still around so let's bug him with a cc ;)
>>
>> And this code breaks our CI e.g:
>>
>> https://github.com/linux-mm/linux-mm/actions/runs/33040981840/job/98414290236
> 
> What do we need to do to view the error output there?

I recall that one has to be logged in in github in order to view the output:

@Mike once sending automated CI failure mails, would it be possible to include
the full output?

-- 
Cheers,

David

