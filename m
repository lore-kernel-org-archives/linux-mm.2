Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50AAFCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E336B0005; Mon,  8 Jun 2026 14:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25466B0088; Mon,  8 Jun 2026 14:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BA76B008A; Mon,  8 Jun 2026 14:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845026B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:42:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31EBD8CC8E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:42:33 +0000 (UTC)
X-FDA: 84857616186.15.DD7C643
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6046080004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:42:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0HZKfaV;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780944151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTurqwAonbHqex2EQ+XolDLMRIFlrC/dSa0htwEu82g=;
	b=s1bk60zdDeWDKvMCo0qk2zg8zb+Xvppq+K46UG73+efqEaXqwRiCNF9yCp1ChuIPIcgJvN
	rERzgEmeOvh40R4TjgmnLQsDfSQLnuyEmac+e7pY0/RlG6CWiRsAsBBNFYO1rcCSkUS45b
	HppCtpHIMddkx/JRwXzeg0aDoN4vQws=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0HZKfaV;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780944151;
	b=f1y9otEqiUE51zgqQ0ETNwW6f4t3NxbSFUM0UGIq/MPB7Pdb/4XuG8qvt66ZN1RMGxHbwP
	Fuf2IibXQ/sJjh6nZACMzHrh5pQ4y+M6tZW8fs+s2gnAI0eBkyWRA0Qn5f7Gpc/vd4j/dt
	P1LKNuN0h9VwtFoSt6r/gWh/JkySznc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1D706001D;
	Mon,  8 Jun 2026 18:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01E01F00893;
	Mon,  8 Jun 2026 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780944150;
	bh=QTurqwAonbHqex2EQ+XolDLMRIFlrC/dSa0htwEu82g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z0HZKfaVAqzMbu2qFZkeUKh44K090vkZHhr2CreO4dU8mj5GgCXvKHTG7KXIGt93i
	 RBGKr5AwaZ656gtjGUMPa1zrG09sZj9D7+00WSGAuTa62mfSlSFn008n5LgoEynZUV
	 gO6DlohPsodQ7MCnG4Pu8vQrEbJZRt0J+VCPvcwiKk0Yl30jqnhE+LLQcXAqIp/9fV
	 pTs+I6Hi8Ft1phAEeMZW8xdMiamy4aru//jt7fMVDpwSn6Gtyyce9pTg0u/8xm40bb
	 g2ave37PYfMp9QvraQN7iN4kpvyx1Z5CCr0zwk2++i/A7FiIn86nyxOPs2AoLaDrQj
	 xwTvnsa49ol4Q==
Message-ID: <fa093778-d0fd-4c32-b229-74dd18796565@kernel.org>
Date: Mon, 8 Jun 2026 20:42:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-s390@vger.kernel.org, linux-next@vger.kernel.org
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
 <20260608171917.3195488Afc-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6046080004
X-Stat-Signature: comsrf161uch1fme6gry7qxdekrj8iys
X-Rspam-User: 
X-HE-Tag: 1780944151-303193
X-HE-Meta: U2FsdGVkX19SmSczvLSkPXjZNopMf+7MowwUIXP0AI8cf9ztDmnTZYW9C1AJwGczkvtha6C45eLqlJVQSUgVciCRXCjHkNGDAnFR07taEvFMxKXx4A+dyFHrArhiZxXWWadGqSrOMWUF7JlIH2UxX0X57eYnTPlmfDnmA75dSlQVrtkt8n1iCCURz6ko6feByY9B4mAPXbCBmoFPoBf0e3sdTf+9+nSY5Ok4UfL31tk7AFvHzOpQW49s1jFeA1Rb3i9liccoQa/eJ9lRgEUHNAxDB3XilVWVPZzEQgD0viVxj6JJHdJ32hgrlKFMWECFfep9xlyIJZeoxiLW1RkZdFk2SuK0sJicA+l9wI+26cFWFJIwess1YP66uoAWnxC+eYXmWOA/p71FH9DRpbKxFrmSE0VFhs0yP6zi1eA2YFfN6AjNgi9aBSiAnVSTNtukMnMooQNKCgCZozAUwi0bNhNk6Gp9pSjyn+9zPQc/NHOQvpPVdWHTyzuudPwmqZl6vjV83M7zpmyBx0KBrL7d+Jy3ro/wi45i8Ex4RTfbtW3wlYXnIDZzgu7HODv97oCZqQJW7DHuNwDPph7LhrDp1hpgQWbDhhj+YiqvSSBVeMmXpfx1LQeFnSKwsm+rd0/0sYN8G82+dxU7bI59GTFYm3uGfnH1j5Z2FlngfagPf/qCqGbtu5bRwDFYWtruvJIr+b6GhxkV4s6AjaiQ5s9c4eTXRyoAJYzsIsggFE8Xt3PwDo9C5N+fRJqgDAnjsXUb2BTeE84gnateBxWUc6nkxgCQUgGXmRXpVKCgClbxYFc1CTn3tLA4Yn5XjzMgHwp2oRGK2XpyJs7CsX5TlfmDT2IvSiBq9x3KLdKO0IykibSyQiGz3mIbnOcewPrCivuzWQSSkRfzkk9aJtxbQNZDDdb2ZYlhg/PIrlRiQXhMiHKsAUwRviad1hK76bVN5bLJ6hkZs48KmSA/cn20nm5
 7OOj4nC2
 F8AhsqsWveMEw7I+dkSnXWtuNKsdR8Gk54DqtplviDbAIb9TD8bVVxaHJ6zNKgv5iD7UJnptBqrq7mIzjUVuz+QbWUPWTbrHTouh5uNppnjB70atYwnpW0LRu8LIicumDCUQTw+A0Kkw5H82PEffapzfWenbpFL5NySsqMAealAxEhXZRyaSg33V9RSjlbXh4yhxz8HbqBWKouCMSG/k9pEuaSNPXtEkKrnBEDhg0ZNra+1t39CaYJGh55QFYBHKq+Ors11luAlAf4Ul+LbttquQHmYT/kPkEhnuvLjVKGf5FcQrJeWir7A0QBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 19:19, Alexander Gordeev wrote:
> On Sun, May 31, 2026 at 01:01:06AM +0000, Askar Safin wrote:
>> vmsplice behavior on writable pipe became equivalent to pwritev2.
>> vmsplice behavior on readable pipe already was nearly
>> equivalent to preadv2, but I made this explicit. I. e. I made it
>> obvious from code that vmsplice now is equivalent to preadv2/pwritev2.
>>
>> Also I moved vmsplice to fs/read_write.c, because now it arguably
>> belongs there.
>>
>> Note that SPLICE_F_NONBLOCK behavior slightly changed: previously
>> vmsplice ignored whether the pipe was opened with O_NONBLOCK, and mode
>> of operation depended on whether SPLICE_F_NONBLOCK was passed only.
>> Now the operation will be non-blocking if O_NONBLOCK was passed when
>> opening *or* SPLICE_F_NONBLOCK was passed to vmsplice. Previous
>> behavior was arguably buggy, and new behavior is arguably better.
>>
>> Now SPLICE_F_GIFT is always ignored by all 3 syscalls: splice, tee
>> and vmsplice.
>>
>> Signed-off-by: Askar Safin <safinaskar@gmail.com>
>> ---
>>  fs/read_write.c          |  23 +++++
>>  fs/splice.c              | 192 +--------------------------------------
>>  include/linux/skbuff.h   |   4 +-
>>  include/linux/splice.h   |   2 +-
>>  include/linux/syscalls.h |   4 +-
>>  5 files changed, 29 insertions(+), 196 deletions(-)
> 
> Hi All,
> 
> This patch as commit e2c0b2368081b ("vmsplice: make vmsplice a trivial
> wrapper for preadv2/pwritev2") in linux-next on s390 causes the selftest
> tools/testing/selftests/mm/cow.c to hang:
> 
> # [RUN] vmsplice() + unmap in child ... with PTE-mapped THP (128 kB)
> 
> Recently there has been changes in THP area, so the problem is not
> necessary linked to this patch per se.

If we reach 128 kB, then 64 kB likely worked. Which might hint at a similar problem
as found by the vmsplice01 ltp test case (blocking instead of returning once the
pipe is full).

https://lore.kernel.org/r/20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner


-- 
Cheers,

David

