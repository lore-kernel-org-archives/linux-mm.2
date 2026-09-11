Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918E1C88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3F86B0092; Thu, 10 Sep 2026 22:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54486B0093; Thu, 10 Sep 2026 22:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AA76B0095; Thu, 10 Sep 2026 22:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64AC86B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:41:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F1EC1A06FE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:41:23 +0000 (UTC)
X-FDA: 85199930046.01.E61B23D
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id E2B7F40003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:41:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=adZNZmRQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789094481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJk0u1UcOnDOPy91sspUcF/wAve5eSeuHy+a5gHNvbk=;
	b=XRqKbwGjvUpYJHPbRFinw5zsnP0y13yg+2H4jxi8qAGc6lVF0FdOqJGAdlLprNFDaPxpNh
	O2tesGQqXLE1ojzZeS5rHRY7A5Sw8lqlwOTg0iIIn+e24ir8k7jJ0kY4Wj9zXwtkmY9C3o
	JibTlgBeXtruwk6TF4ABMFverdcCCMk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=adZNZmRQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789094481;
	b=zjxl2SexybNAN5F1IdNVMAjTFZOg4Tjca/M2iTzTKFnzjoNgXLUOtW1d9Cchj3JiYH22lI
	8ZKUD69gwbm+aDQpwWgfcr6VJ0WunjOHhpbqRSHSEhF/QbXCjv/AOX64d42/N7jyFUBVXH
	O5fHD2R+JnIsYaUyGJo8LqkpALhF2YI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UJk0u1UcOnDOPy91sspUcF/wAve5eSeuHy+a5gHNvbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789094476; v=1; x=1789699276;
 b=adZNZmRQ3cxUe8zHt2km+HnfktRjUs9S0+G8u47/ocIANugHL+DJ7u7Jdz1aaL5R50TRd9oC
 P17oQ9bq+ZcI/qjPGsWT6wvaOVxvYxrjEUQsb3FTYChvZOY/Q0uzmq4x0QsHfKoGveN2CXRn8Qq
 zCLR9V0k5IT9/ytqZf7jAKvk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d64be4f82663bc04;
	Fri, 11 Sep 2026 02:41:16 +0000
X-Mizu-Trace-ID: d64be4f82663bc04
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260910152026.5bcf5c5d7f1ecdcb0147ceaf@linux-foundation.org>
Date: Fri, 11 Sep 2026 10:41:01 +0800
Cc: osalvador@suse.de,
 linux-mm@kvack.org,
 david@kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <35D58CFB-BC97-4245-A387-DB3077E395C3@linux.dev>
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
 <8A0F6014-4E2C-4F07-9732-2DF32418B986@linux.dev>
 <20260910152026.5bcf5c5d7f1ecdcb0147ceaf@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
 Huaisheng Ye <yehuaisheng@open-hieco.net>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2B7F40003
X-Stat-Signature: jocha9f4b6gna866rnrmct84mtbrm6kf
X-Rspam-User: 
X-HE-Tag: 1789094479-346779
X-HE-Meta: U2FsdGVkX18RQHJxzRO5siIVI5xwPPELtm+pj4erVehKUX5ydkUhOOAcj6ryLhab1VfkG2dJG2J2XkTVd7QO4k16rLQ/W65mMcOz1swox1sMZJQ8/it1vjdleWHwE/AFU57rxDcSXn6+QZ4yetwyHxvc5nBkywsP+fkVOFPM/qaukOtIMgJ+LPDSXme8Li3R+fL2XGyFxb/JRncycEnySd5ywHSBxksNdNRug8n9GKvVY5J73I7ejnLPPxjYwpLDbmtwR43vFrRqCDmYI3IicNE0d/Q9xWQu4NzEQoqLa68mLnviiDeWHgicak+TLAzWRpqE1XUr9bpDUNdGjZzsnRurh/v5vb7rLEbAJ9EA7Pu2id5GBeATeKT83cBkKPKObLY+Jyoy+v3qUQ/Q5IgYRu9fjxecbVlnsJDpRsxQvvYq2ry/oh9CAYitexXYCIn8+gh9lhirhMbRBunRawmvr6XCkbD8Nq0xX2DN+kfULIl6d6tjJ1rgNP4Y7nOSjXGUE4fDfLtdyytPfGfiW6wqx7gx5clpzb5XQ50ZkS3wJFx+W/uuP1hGU5/6Z4zgptR0CRiVYjkvYToROzzVxaOFSf+HfvYm3Ns+c05wPpecFAQ9KC32W7Gl/cdLaVGAlUNC9eY+frsd2j5QxJ6qQrYvvRX4fC0z0vBvwnwo8SAO/Kxv4OQMYWaRsElNIJs5zlyD4lBC/05qwABJ3PjRPVgqdtvGEr/YgFyBOPC0OCg7zPSioW8gP+5Ig9dtew2ZRpJuXkK6RxBYV11fEXgbOCRy5ys92WI060qz2qQTPm9WQimsEcLt6jYwf/5wC064jRooohnbucgsUKAIc/qdScfbfQT5zggzRy91f2aJQWqv5il3ZrQHi9KrSexh+5e4JWfOUYnQGimXIZMBn2ohIIPQRauPQgQQN7al1uPb+ddbGuci2JQIyEQNFfpg0hi60MWlQL2WPyUTEKsfyCsXxGh
 7/ECMH8Q
 dZOzUqyak0yAg2WoY7eecVPvOq3ond0HMTKBO/AmjxCy+4A9I+8gHaQHfmbEnEZdMOrlvXUIsWwcgYxidPtgWGAmT/nr+nx/T0w4Mp1qoYfTjtx22A+VEZI6Xsd5wgfTIiU2MoG6d7IgZApZuYVbY7i98eXxkQqzGHZBpDMp16vtZD5A5iRcZQ/oUT/JTKqzQWxuII4TUa8xGSLg1vv4NQ56hXI5xPOYL9pLR5K52RwwdqHnqn1YzEoR1pNxLK6zWlBKMLS1YZMHKN5vO2KjnFjqrvvFgk5JR/AaD+rlC5CZFL4pWI3ZCC5ZmiS3pxk7KBYbWWorg4Zy+mTqbEYaLNk38hliDGeKPgKjKUVIPttLLCogudDbqbfp+H4P1R0+oZocq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 11, 2026, at 06:20, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Thu, 10 Sep 2026 16:48:56 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>> This fixes hugetlb mappings when, for example, a task runs with
>>> MPOL_BIND on Node 1 while the existing free huge pages are on Node =
0.
>>>=20
>>> Similar issue also could be found in ltp if the free pages of global =
pool
>>> reside outside the nodes allowed by the application.
>>> # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
>>> # numactl --cpunodebind=3D0 --membind=3D1 ./hugemmap10
>>>=20
>>> Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>
>>=20
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>=20
> Should we backport this?
>=20
> If so, a Fixes: target would be helpful.

I believe the fix should be e4e574b767ba ("hugetlb: Try to grow hugetlb
pool for MAP_SHARED mappings"). This commit was introduced back in 2007.
Regarding the impact of this issue, I consulted an AI:

Severity: Medium
Impact: valid HugeTLB mappings can be rejected with ENOMEM
Scope: NUMA + cpuset/MPOL_BIND + nr_overcommit_hugepages
Risk: availability/configuration failure, no data corruption


The fact that it has only been triggered after such a long time also
precisely shows how uncommon its configuration is. I expect that
backporting may encounter some conflicts. In the absence of clear user
feedback, I personally suggest not doing a backport.

Of course, as the author of this patch, you could also provide more
information, for example, whether it was discovered as a real issue
in a production environment, so as to decide whether to proceed with
a backport.

Thanks.=

