Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5110B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Cua1W+Jv
Received: by kanga.kvack.org (Postfix)
	id 669746B05B2; Wed, 18 Nov 2026 00:39:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619516B05B3; Wed, 18 Nov 2026 00:39:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555F06B05B4; Wed, 18 Nov 2026 00:39:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343306B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:39:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4831BA82A6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:39:27 +0000 (UTC)
X-FDA: 85447137174.01.46C49D7
Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3130120005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:39:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cua1W+Jv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794980365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivtPd5ttNuyhfy98ioQJITuu8jfayeumroo16CmslDc=;
	b=udh/f6rZXpDyLWTgJqpce0g6EOdPhhxrELnkYqgLSz2mrhQyXRWSRzvwNHzYsAzRchvrzv
	iF42VkO4Sd0Z7aSzzU1CMTddMYvoEXaPjFr3/oMPNv/+T/8aFAz/Pan/EYSmUp8O6OP//V
	+PT/KIqj8Nu+hCGpH0b/aixLGckdw+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cua1W+Jv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794980365;
	b=htb5ppmDv/ZAIbmMA9r4rLtDRNqSu6CNerg6hSqj4mpg1tSLQpdppZTqPqYaKUk+at/HjL
	GT6hNJKBgTZNSGZ2WViUpNDnryeFey6q+4MaQr4n01E/Q5qeZHjQMZJVLX7sQB3YDNuHTx
	v3nPoWBQhOuOhsp/y+Ap8g1zT70xRDY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H/f7fxK9dSXTVO4fB0pNECpC88jXcYa6XPqhZn4b2dU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794980363; v=1; x=1795585163;
 b=Cua1W+JvpxUG61rrVgT7xcr6R31Xd9mkZ6xfki7rUjVUofsHwhdLJ93e37hWK7VYxF/tVxGi
 hMCMYtBT7khXZ/+9kWPZ1T7uDdwixYsm35xUyh2J/MKIG0FbdwaNuS7YF/b2dqRtIJmzHpuC/B+
 HxrX2Sbtelk4WwyaxE2ksCYU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6c1682f25ee54883;
	Wed, 18 Nov 2026 05:39:23 +0000
X-Mizu-Trace-ID: 6c1682f25ee54883
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
Date: Wed, 18 Nov 2026 13:39:04 +0800
Cc: sashiko-reviews@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Chris Down <chris@chrisdown.name>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 kasan-dev@googlegroups.com,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
 <sashiko-outbox-219498@kernel.org>
 <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
 <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
 <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 3130120005
X-Stat-Signature: pcbxumz4jzg1kb1jx9pwdduaofof31ue
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794980364-488998
X-HE-Meta: U2FsdGVkX1+m62zpsYSUzwLRXXIytlv76vkpbeu5DHRNyKjRB0CRmMspbQlFQZaChCSFLojXtKCeKtmz/7SYlBKrEQj3AyEM0RZpPrSvs5hYdw6st5gK8nt0F5Uzfki+sxXlfbLY6ei+lyL1segWuua07aVURuYSZ9I1GkFim2Y7DnrmZ3ko9qIemrfQxGTwzC2k3a2erkgbHa3LWpN7XWVsQFJvQsw9bDi2ujjFc+lad/u7Px5dC2SmdzlAEvqDL28cSCj7F+a9KCox1XHPPwNjF8NIHv29iYBfrv/vWprHVKlOpLEGZe2w5XkxhsOTMjEz2Gjq/WvcMP2YgPBcUoHoPbpqCPNGdudKFUL/7bbvkGNMtsqNbXubcRP7YZ/bHdSmEG1hq8i4fNfovyR7d8nOUYDeYng5krWi75Tgn3TfRvhZ1YvNgri05r8iGUMgU33+1bOJde+I8rpydqf4eZR7QiCsTEf2Hynm/VNzX3IP32hq+vVFbeezAn29JAwVKTgf2gXoBchfJX2XJ7MdTpJMhL/sYfaxyFJL6Glm67TTrv8lkKnN3ImY/dpk0q/Lc7S4fKwsrp1vAO0C528AzwC1TONb9bXcAmB5pMShv9deQ/PNPSZXUNybaa3IcbiPsmcfIUB52GL6irWbwr8CRhlBDphtRktXE/lntiF8jhCAX5N2Kl4PDuUKsvJvjDyTYfa3Bdx72OL0nT6GN34GAYzZEzWSdy6rbuam6EqHe9wFfjXUjUqV/u2asom3A+dBnHPSKuMHHVQFphJbnglMZlGKRbs8VU3tvAmXZflCTMzASOabrJPO5NBcl6P4H2YfpIDQWZUJVUjr//KnPPilyJLa7XXJQ99E0TI2Nwu9RZAWQhsaZfYtOIB+AJu6ptiZmP9qODcBYwAgpV0+L9Nkfc8V2OeAhtwjCz/e7BumjtqXWYNpT5wOVzDddMALIoN8xNxhNXffZali4UFnDPO
 F3pl0U4P
 ZLUBJAdpFKRaG1qhHTxbvGiz1XwO0wcyGmPgw+6y09APINA2cU+uwIEVGaca7lcDNkWt7ljBZZPIX2yg3+d6ELTi75OozxsxbGzltjnSC6hd+aqZCfc6myBJIxGRqkU1+FduouqR/DgjqUC6PW8+11tJcD9wWz+wx6QM5MT+HZGYwYyXp8RQcqoRUvq4HcTwrc7UIjHXPV1eOSh0kMUoxyr9yrSYyrrx5Sgi+XqhUoJZ4lEnmZ+apqvFVHbczdiEFd/pi9R8fh/dspqbaeiXwSKgdwdRFRajwsPSAA59w4wCwUWPguIo9uBmhekF/UvlmTnw8eUoPkBmhY5wUNfJVr3CVE5DrM++tT33nvFzC8+/3qN8Q+4IW4Xw1Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 18, 2026, at 12:21, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Wed, 18 Nov 2026 11:49:58 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>=20
>>=20
>>>>> +}
>>>>=20
>>>> [blah blah]
>>>>=20
>>>=20
>>> Yeah, but the whole expression is quite reader-hostile, as min/max
>>> things often are.
>>>=20
>>> How about doing
>>>=20
>>> /* comment */
>>> if (this1)
>>> return that1;
>>> /* comment */
>>> if (this2)
>>> return that2;
>>> /* comment */
>>> if (this3)
>>> return that3;
>>>=20
>>> ?
>>>=20
>>> The code generation will probably be just as good and it's =
__init-time
>>> stuff anyway.
>>=20
>> Something like?
>>=20
>> static inline size_t page_ext_data_alignment(size_t size)
>> {
>>        /* No client data means no alignment requirement. */
>>        if (!size)
>>                return 1;
>>=20
>>        /* u64 has the strictest alignment required by page_ext =
clients. */
>>        if (IS_ALIGNED(size, __alignof__(u64)))
>>                return __alignof__(u64);
>>=20
>>        /*
>>         * A type's size is a multiple of its natural alignment, so =
its
>>         * lowest set bit is at least that alignment.
>>         */
>>        return 1UL << __ffs(size);
>> }
>=20
> Well I prefer it!
>=20
> The final bit-twiddle could be (size & ~size) but I'm not sure that's
> any clearer.
>=20
> We should have a handy helper for this operation but I can't find one.=20=

> max_pow_of_two_factor() is close, but only works on uint.

How about changing the helper to

#define max_pow_of_two_factor(n) ({					=
\
	typeof(n) __n =3D (n);						=
\
	static_assert(__same_type(__n, 0U) || __same_type(__n, 0UL));	=
\
	__n & -__n;							=
\
})

?


