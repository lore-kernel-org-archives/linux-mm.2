Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95AF4CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB0D6B016D; Sun, 31 May 2026 15:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C350D6B016F; Sun, 31 May 2026 15:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD286B0170; Sun, 31 May 2026 15:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4106B016D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:01:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E17D1A03C0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:01:18 +0000 (UTC)
X-FDA: 84828633036.12.6F3723F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75E1C180006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:01:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IR3X1VQ3;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780254076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcdMJCvYcrxynpav12XOXRlTlPDIl3/7C5MgYt6/rxM=;
	b=EE/flfEh/qQ/XS+XMnm9RZl1ZY3wpqVQcoKoMrHVo3daYjYg7BfGaOmXXAqdvOnJkg9Wd6
	p8U2A5rzzAi5+hhN4cu9mFWQ5Qjy48y1TgFU64OEyZEfCONsI48BJtqUxbS1Kg1lqThabU
	a1rHhET4fwtWo5Yc9Q/tKJyTbwc27Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780254076; a=rsa-sha256;
	cv=none;
	b=Pfhjygu4MbbrGPGUPDm/bFbNp8wN29jjlLfab0SNtjNeK/fWq7eZlH84YkTLUAUX7z2Mql
	7AQc4zTFAVxjSAL+sWSlJQ2tpPPJYo1X8MgCYrWxcKi5VH73FIhWoZbYTlGmDPE07ketYd
	P18f5QoCtoIbb1T/1qokP3P1w/uTGdw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IR3X1VQ3;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD7CD6008A;
	Sun, 31 May 2026 19:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568961F00893;
	Sun, 31 May 2026 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780254075;
	bh=fcdMJCvYcrxynpav12XOXRlTlPDIl3/7C5MgYt6/rxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IR3X1VQ3sfK8nwizv/o40dv7x4UY52RwB32eTAzN6vkUjJen1CO+9kUOt76HB0+xD
	 iykOW4+TrFC5n9TXfXZXtvSDoJ4ycLBnff42d5ofdKUqncVr1sayrtVj0RNfWKbJU2
	 Tcbhu2r/7h/Y6zlcnS56zEIybxwmlYZXlD2hhVKlYta+WHVbTe0y4D/eZeHvVWKp00
	 NFuTbY3VnbUD74bfNyrUJtoXbuONXsBl+I1+jvo3g0GUZcmsHQYkUePajF8NZrvxr3
	 2nW6ksVuhtD3SjQi/lFyT0qTOGpPU82KdOPIe3G2NUq68rkk9r8Elc8gOHPPplMtq/
	 vXK2p3JnBERXQ==
Message-ID: <6dfa5f7c-ffbd-4605-96f2-09e365ce57dd@kernel.org>
Date: Sun, 31 May 2026 21:01:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Pedro Falcato <pfalcato@suse.de>, Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miklos Szeredi
 <miklos@szeredi.hu>, patches@lists.linux.dev
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <ahv16ogY8Zx3Rtox@pedro-suse.lan>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ot4wpyutejd1o7ptfk6ay1iqnzye5dci
X-Rspamd-Queue-Id: 75E1C180006
X-Rspam-User: 
X-HE-Tag: 1780254076-739024
X-HE-Meta: U2FsdGVkX1/NJrQ0HZovlw0FKSffVOBgKR7w8iEq59k2sMdqrdFxVe7E3bxofLyPxDg8BJN8sH0EYyjbNJxaykOw5aGKqZwcqYqMapX561hoHrAVhaSkH+KOW1P08iGpW2ghTkChpS9TCDRQ7kclvcpMSdwOhwvQBWrWZmdFw9Q3qlah7MQVan9j3QwzshFNklBfQldZePh3Kd7oX2lHKptfi4l6mhf/VtwDi4Ihmxy6YNnYZbdbvVAFled++TjH03lsWwLY/ZN8OINJZB0ynytGlLAU9NbULEN87ZFku0JLb5gchJqLzPD7KjzbQc3au4j8xn5XftBvvSyWuDpQbCRxZsadf0vh8hfo5DvzZ4Z3JLRCyRv8euPQ9ZdV7ikbvSSeacdoMzu1yeZLFOqS/jbPYBD5Uqh1h0skzRZ4UX1r4SPYj5X0kEuI7XGOYDq9BrSI3scn42IecP/U2QiR223iI/B1iEQtXYk9tMUgfqShuUe0RIpWSmYWWkPw8Pzm0cp+iu8FhJi3ye5JEBlXGeobhWA6FKvb7eCxM86Qoi+am89rvDZl116c93j5be85pHzoIW8NAnLDmuFquZt3MndfAZvUHYryal4QD7byXUsmdffIPebIrImrWYJE5yruAo5B0Gqf4WPhGduo63g1X/AfPF88Z2HdEkq6jLAJFf/XVziajzz0+i6ZEBlvp8v5zByzeMJ2t6zs/y9z1xSpPNLPYsHf/GrsjCPUzgEvNrfi03KQfR0d5+41MlDMt8TJ49PdI6pSgM2No/SnfJHFq9XN8LoeWCePIAHIxc3sJgj25IGPEfYPMxQ5SxTzZOIVZ88EtJ+7hJ+ctxnqmOgXWn9sCUtTYBwxnA5tLyvPxZs9vlwCPMKBu4NtvNORQ2lTB0o9lgyzHUn3x7592eWJyoGGw+O1aW2QO7cUA0QJTv1Th6F1dBnPGZCoQptpG1rd8f3xwmIT3HF5kppeYsJ
 n4dmiVFX
 UmV05Dr8rTxLh0EkpUvuEgWsDFkzlB5fdI+qRNTQ4AHMW45sv7ixg23EG6ppQI0/0DlI/TEiKR8UPPek+zHnXI6X8k5PL/4vpiJ+ujLyhI6OTz8qS8lM9H7JJyUH2+gM4HT9Cl90tLFust4q0gnxj430d7R7pULQzo6g9Tgp1dDbhTXy4yH8n+gbFVwBcpnMHdAf6NlCLtnXgHqahGtMYZiaYjLcPQ7xPZkNtjhzRf+TWOevATHIxZO+s6iKvU/SByOU8RorvaGRatUxjI6CGNLgaEkj9KZQzpF8+0bwb221AmRr7LYvNKKbv6NLrMo0efH3qKyrnFbVk18CP5bMccVnnUZRfG2f9K3f/2Lhs3/aeWLsCEcrm7QV8+kenWWNEhOfvPWTiQcb23Gw/TmqpzsH0rfzu+oQva041XYUlP5CwaT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 10:54, Pedro Falcato wrote:
> On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
>> This patchset is for VFS.
>>
>> Recently we got a lot of vulnerabilities in splice/vmsplice.
>>
>> Also vmsplice already was source of vulnerabilities in the past:
>> CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).
>>
>> Also vmsplice is problematic for other reasons. Here is what other
>> developers say:
>>
>> Linus Torvalds in 2023:
>>> So I'd personally be perfectly ok with just making vmsplice() be
>>> exactly the same as write, and turn all of vmsplice() into just "it's
>>> a read() if the pipe is open for read, and a write if it's open for
>>> writing".
>> https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/
>>
>> Christoph Hellwig in May 2026:
>>> vmsplice is the worst, as it is one of the few remaining places that
>>> can incorrectly dirty file backed pages without telling the file system
>>> and cause the other problems fixed by a FOLL_PIN conversion, but it is
>>> the only one where we do not have any idea yet how we could convert it
>>> to FOLL_PIN due to the unbounded pin time.
>> https://lore.kernel.org/all/agwFlBKvKytjURDO@infradead.org/
>>
>> See recent discussion here:
>> https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> 
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Riiiiiight.... I don't think I have to NAK this, do I?

Jup. I'll just ignore this patch set here.

-- 
Cheers,

David

