Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C68CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6126B0379; Mon,  1 Jun 2026 08:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777396B037B; Mon,  1 Jun 2026 08:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CF76B037C; Mon,  1 Jun 2026 08:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56CD26B0379
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:24:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15B821A062F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:24:49 +0000 (UTC)
X-FDA: 84831262698.12.4E1CC9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2BBEC12000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:24:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GC/gRRyp";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcuOYNxk791F5phRxcJhyOXalMxWmtZOwcs6ao7FDp4=;
	b=GAsU5JIBE9Um0hgdzlnESAIncYcmF4F9KphYI6i3KOxn3XNaXljwKfCK+9wWNOQdag9dwC
	LvuFDwQKeYcXHT7KsL2FZVhWtDT4pKVCOORpspB5TbZbak2vk54QOpR04EkAz0G7r8oK4D
	xC96gmWZgSHkW2hEeOQlsHLSGlHRApQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GC/gRRyp";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316687; a=rsa-sha256;
	cv=none;
	b=LC4YyZcM4+ber9hg+cw2OmcUGdiVixN26e/nKbTX1KOfMD3y4gj0Ul4O2+vlVf5rCnCJK/
	JpNWez4Nm04+uyEhSGhVyHksY0ITiNxj9ssO7+mtXI38OibWQ533tlEgqKTauKq7FR2v7l
	TX+gqZHjnkQ8rn99HLuDeHpQouEPBGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51B7440121;
	Mon,  1 Jun 2026 12:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C2A1F00893;
	Mon,  1 Jun 2026 12:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316686;
	bh=fcuOYNxk791F5phRxcJhyOXalMxWmtZOwcs6ao7FDp4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GC/gRRypNO4Nl2crsnc1yh8KH4CZ2CTYtOgVJCcD6HY9cbk4h26lAeZLnsAEhV8+Z
	 R2ux5FJc6G8c5I0dEWFnNtewHs7ybgmCPOZGJy2UBrYG6RiTbF9grpTAR1PhnQyGaj
	 rq75IwCuHOQRNq+ccOl0wXtosg/JiSh5UGhuJTENhPXHGkHVa2/YzONyKVVn+bgH9A
	 lh4SDGRhqxfdF+VNv/nZ7LXvbPnbC+2fhVV1AOqrexDH4DbWiVRGud2HIGluNaUX3l
	 0d7RPohnvinFGjRFpOW1HXyCoOzA1EKxfbAl0Fd9ZdLU+Ro6/8fbsuSkQu6YThem4i
	 yGhl0VbgAJgxg==
Message-ID: <8c60f9bb-7a4a-4340-b414-9f7fbef4150c@kernel.org>
Date: Mon, 1 Jun 2026 14:24:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] loongarch/mm: drop vmemmap_check_pmd helper and
 use generic code
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601084845.3792171-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: hoswnmn3fybwc6yychr7mamqnt5i3qkn
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BBEC12000F
X-HE-Tag: 1780316686-64860
X-HE-Meta: U2FsdGVkX18fajnUlze3OZBc/dwB8r7792Fd6vYTYqmgdYOjBVnaxGKWI/o+HA6RXRe2HRW643XCup1VCTGQg0A8P74I8H4SFWo4Hyq4G9GGjAPjp65s+ohNka37NtpIYtx7JoEgn2Hm5BhKgAA4Hwg41zk25tvRVdU/hXxftVSjwNGewh70CTf9MW7/6wR1Z2wyZOawKo91VVacKU9MRfNJ/kCkvKFg7adRW/Mot/iBtDDom4Zcmfb7AFg5YjZ3RrTe2OQQqVGEb/kOtmTYlnt22/rl2ye0YlT1tS5Gg9iUAUL4w6Y0NaSjF+KRnmR3hMIK6RrwN9hBP5K6jkUu4M1hXhXG6d2AEDjaY72EBk7k/QPSqDIb2AkZiASbvNs06ZempB6X9kR2WIkrbepUX0wU58DVdHGhN8UAzJFUTyoPVUexwMfZWTWjR62ABif9uOY9WhougzWm/UHgZdvPJW5HYbDIB6RegybwhcJlaGdLHWN650v2J4JYOfh/WovvP+VmPdCcQ3zFF04Ae8tSbJ0DmnYz+AFib1NcFN/9BeK1PiEZ5T7HfeTJrsn0jLLuKZRERZv6z/e0qd+wzxwg1d3NurLyg95JU+e53P1gP+KhjyyrY6bTwuiSQYyMLREScb8tm2yeWaU7TwDRXLHd7TvsCbXPdTRvbEgg2zWWnw/MR9ZY7eoxbIVXZeqd4URM+J/FD7oVO7l57NhO7lRu0BrHNi6C26iMDIJtx8ka6cdIUECFdQZnEtqet9etW7KsRqyZ/9Kii3BxueiBpCVTrlO0NDwkwos57g9TcT4eZwhP1wR1A6gP5FCWh4iHS3i3BZlSTqk16j//FbPf1k8AQz/K1R74ttHMKWtqnT6PRXRKJhNt0ACIizTvqJElG6KX6fwIi4qwLsMgLn8PxOarSWO3UyQ1y5l2JCnYNd29SamafP8etwK1ACLu/uUp4dIfhQxXqGwo9LRvRe2FS5+
 m6RR/Xll
 23Rfjthi/xxARSwsX3TXtwU+EcE8GiNZ9GN7cXlX7QwQ7NU+aX0s8fTh621sCW4jRedLwMPttgqVlAAZzi66/XAe/8g6JpUIIFSMui2WpwMP+txFl0qHrrN6gOvIIqlE0oBi8DCeZOidJ2Giou+VfjUtqe5J1INKZGQSTtDEpOWv/siqbJXwxZO1z2dBTtYrcRa1ojWjEt7+kahSMmdksesB1nB/shnInZRk/HYSCH375NpiWwSOaYD7ay6OSv2hl8K3tjB8vhbXLSkPUlixB3nb6FmlCn/7syAxysBw0C+8tA7fNf6wxnGvlgGw3tiHkWhwFlbZ+1rAhOTsp7a4jPTWF3jkI33b95d0lQKDpNEhRpQ3t0/FB7MHFV44rUn6xSNoZpQro4NoZJ2lURnnPIP56jFBhF9HygmUYrcXXsBTVudJjU4AaSdnIJl9y4ieA2yXYaiJP4rC5EdH8qMDIyLaaUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:48, Muchun Song wrote:
> The generic implementations now suffice; remove the loongarch copies.

You are only removing a single function? So "copy"


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

