Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0268ED35666
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 02:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06616B008A; Tue, 27 Jan 2026 21:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3CC6B008C; Tue, 27 Jan 2026 21:44:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFA86B0092; Tue, 27 Jan 2026 21:44:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797306B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:44:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 699F313AE10
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:43:59 +0000 (UTC)
X-FDA: 84379827798.25.2199BD1
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79A1D40002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:43:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AwSz2b3e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769568237; a=rsa-sha256;
	cv=none;
	b=nVpUEwoHwVz5jA2haphO3Mw3OWRUG1/HVBcQZB6UACuMxKMLM6IY/gXIogvTS/ad/iaS4n
	1QUe07SLYAWSuqVLl1oy1DxoUGXrE2XHbYmTNOwrwVB4vOXqSvhxtNAWBQEGYPOPJypN7d
	Nkj3PZKMc/d85eQWgbFAaQINfLcezx8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AwSz2b3e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769568237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3hcu+djTXiL86WSU47ccNO5VGh/Ab4OkQ+kc4ZUgqM=;
	b=SMpikh6NN10F14OOd5fMBzl2zjTGWs8063MvrCUMFwRVnRYqau8ItUvwNJ2B8lwnqg7zuO
	wCw7QdXK78eyEHsSQ92nWuY4kvdtY2RoDkCrKjhnJY900ANvUjxkbnAmZcTH6P8CeZR17P
	GE3oWiiv9qG6+lv/llMxtXNV2gAZ11c=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769568235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I3hcu+djTXiL86WSU47ccNO5VGh/Ab4OkQ+kc4ZUgqM=;
	b=AwSz2b3eZt+OrN40xQ2hPCXZjqKMFP4j6YuyJdyfettfaftqWvuFEN/iY9ks5CzOKdOoA9
	Iclm9/h8yjrGsQNL6rs8nKgDY7NuyBQySNnuzqpgQScwCeNVFwihRh4cgpR0ijobcxTogB
	AJBZ+EY+WnFDqY9Pih0rAefDsVBcOVo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aXjPf_fIWX74YVWD@thinkstation>
Date: Wed, 28 Jan 2026 10:43:13 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <25C01EB2-FC77-43A5-A737-7BD3D2D98EDE@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-10-kas@kernel.org>
 <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
 <aXjPf_fIWX74YVWD@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79A1D40002
X-Stat-Signature: 45qss6yyymxtf8p46ckxnhmmchaj94wk
X-HE-Tag: 1769568237-863459
X-HE-Meta: U2FsdGVkX19kUXnql7X8vtr3oGebCfMtZ+2Y9sd1oR7WkIFWYe0Sx8oB3+3OttQiAuXfKoryU4Y9Zk7Yo/eir123ok0EtGmMfupRQyd6JX7wc3Lgb891nxScHy8lMZkl9C5iyl8dOzzgVh0dgYIbw33egdEgOUJSoNnjFfJF9Wb7JoUC18hv5SGCypMaaQ8TJognUgCtIM5L7IhWPYl57U2cqtc8mdptTAu9dx8466C1lUB2oGSiTzg22kZrHvp8ytHTCM2qDoRdBRi7+iyFX18GIYGprbavchxliGciVZrqTf48zkY9BFYLhR5RyZQ+12Y/2vwv4ei4zv++Zpl2P+ogVEy4AuC1dti9YjFFsImxeqKAATQXehzb6XL0QBMpBl1k5TCdzJjoMhMsUihAdG82WsA1m5aDtlbCLo4cT/aIlHM7ipN6CkYmSBtI7mC0SQ8pCKrJARHGmAOqpbcv/wjvHGsF6l4/iBbiqyc6/epsGnI3rKn3rOFvVKYjgZwqN2KKPLJKRCTG/AqnsL9JVVEs6tPGDWm8LQn/PCbhBvUSWnVXfmJPwRy0QZO6xNUH9E0GSOmoLAvTC5c2AIbQfP7bnn00N85YTx/N0RCBW71ZDmFbn++y9rRIufx5KtDmTRzjs8LVB/habsRke4VGPR0VPJYEJy1vKkg68MFUHkEr9ATFxeukFAkgqnumuYATw0wIo/pw1NJe3+nlC9Ycr4n6YoTN0fGvRQNRQoYhVX5yfXDfNsB7FJ6p4LLgGPZzFflXBF0S5MIB/oDCVx7sXP7q/NIMOmw26ps6aJgggqeceg3v999O51d+vHtYFouQV6LKjs/xGipuT9tg1yBLQGQ4P5QQ5YXxxUShIoyQN1Lku2R7YmU1zUDmmGb7BFXzxzTI8co4L1ZFySyMbRHuo6XDzSkpeMEL+CpwBwZY8SQQxWuSD6C4+lC8yadL8RBrNeOm1hUTULqc/t92Hcy
 xKQ9MkNS
 wAMSFslmjE8l3T9+dbJvoPU231WqoD3JN7KV5ZqEY46X0B7p7CiIpLi84DwBloiJmOTU7g0bLRZj3kGOTYh128laiZ1MFdzmfYZ+Ci3s1FWiTY0M252dpw2MQAC3cQ8GCHky13A7BQ36gdO4q/TswL+LgIOW4Ozy6YSkLhT7EO5PMgvpZinvF31hr6IY4do7fenC8xPR/x5vck5CqaRKfILseSYFMgMaIVmwUp08xIb/8A1wtALzOzhMZkszaMEUTR6lu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 27, 2026, at 22:51, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Thu, Jan 22, 2026 at 03:00:03PM +0800, Muchun Song wrote:
>>> + if (pfn)
>>> + 	return pfn_to_page(pfn);
>>> +
>>> + tail =3D alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
>>> + if (!tail)
>>> + 	return NULL;
>>> +
>>> + p =3D page_to_virt(tail);
>>> + for (int i =3D 0; i < PAGE_SIZE / sizeof(struct page); i++)
>>> + 	prep_compound_tail(p + i, NULL, order);
>>> +
>>> + spin_lock(&hugetlb_lock);
>>=20
>> hugetlb_lock is considered a contended lock, better not to abuse it.
>> cmpxchg() is enought in this case.
>=20
> We hit the lock once per node (excluding races). Its contribution to =
the
> lock contention is negligible. spin_lock() is easier to follow. I will
> keep it.

I don't think cmpxchg() is hard to follow. It=E2=80=99s precisely =
because of
your abuse that interrupts still have to be disabled here=E2=80=94hugetlb_=
lock
must be an irq-off lock. Are you really going to use spin_lock_irq just
because =E2=80=9Cit feels simpler=E2=80=9D to you?

>=20
> Ack for the rest of your comments.
>=20
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov


