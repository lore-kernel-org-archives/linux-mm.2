Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23198606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w7A+LEhU
Received: by kanga.kvack.org (Postfix)
	id 3CB3C6B00EF; Tue, 17 Nov 2026 22:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2C66B05B0; Tue, 17 Nov 2026 22:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B96D6B05B1; Tue, 17 Nov 2026 22:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0921B6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:50:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62E21A0427
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:50:27 +0000 (UTC)
X-FDA: 85446862494.17.1E1CC8A
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C925160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:50:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7A+LEhU;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794973825;
	b=ebAZlgoXBhMjTNnWBHiot6G8D6A3PmVcH9+fZLSRJoDZMJAo3LAFUoQdHNKTkBo7J/vxlg
	QVPoS6XIpnsVY24Dxf2iAksC+6vBwcak/2CfE2auh/Wg3fnOt+WOECIg229vuvrno4p+e5
	eVOSWgT6EtxOYhvLbbbzTV214WlgtyI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7A+LEhU;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794973825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPp6yMO3qB7Qdjiew2LVyPuo9JgIAUgd1wm/VlErX4Y=;
	b=diMKxgzemTNPrhnjjeUGTbDMc1A7ND1yP4qTsTwjPhJwIz+N8tMZEL668Xd2uQ1D3yOr63
	FI7RdeJFb7WGGtMzHA6+oJeXP3RV1NLtxZfAc2DtsUEaSTWgvZ+dr4PkXw6UWjeuFVxJSw
	0TpAs3+2u3uFCcPj4UCKNUaO7jSK0hQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=emwGL8FoGqLBe0pmI54NoXvhFi3KQgtC2jbN57YvmiM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794973823; v=1; x=1795578623;
 b=w7A+LEhU+TfH/1fwDx16tvnZNwd1b0iWXfZ1Hhirj5kzrLGJvwWOT+Pipqt8oQm0QEfbovFi
 5zVHr5rungYc+zk1Zo94hEH6h+cgaS9CXGQYc+QTBm0a8JptbBqscUKK4hNIO3vQsxm9jFnFoFC
 8t6fSr1IZIGsRe5CAf540I7c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 614c7474aa1088e3;
	Wed, 18 Nov 2026 03:50:19 +0000
X-Mizu-Trace-ID: 614c7474aa1088e3
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
Date: Wed, 18 Nov 2026 11:49:58 +0800
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
Message-Id: <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
 <sashiko-outbox-219498@kernel.org>
 <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C925160004
X-Stat-Signature: crih6xgj4j6jdns37isr79bkktnt38nt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794973824-442535
X-HE-Meta: U2FsdGVkX1/Cr9ufq/lx8fb3FpfI7hzZze4bhD2DeUubEu7x9hq/PZ+5wQtsqraR/xYjodnKd/REfmogwrmM6wYk19fA7ppJZM5mcOy1B3gBGx/R4ICpgWe3debwb0myyYhF4ktZCLdqq5lA2riUwbeolNenXKCr8EDsCFQZm8oY9VmiIWCQqMUt56e8mPTvgqTdRQbX9J9QZRHcQ92xvCEYkgShO+FZ4Cd+sKzTVIQTCXJvP3WYFqmbhxJcmXNBcFI86hqcXaI4AWz74yno64RSxLMI2EQYUEJRA+cTRWpEcxSW0nsq1isi3E5IzMj4jTL4OxXjkjlx3f+wCavNojO6IIJa/lin/gy5dICsCR4C1v7bZmDXEjeD/m1rAN+ziHCDcXDlg2IFYp3JHtGhgv0iMms0RUw3rsTJrd4ICf5Sg2tfLtvvGvhFrBqJVYC8IMTv7RyyV3FAV+UJ4ZX0VBp7LDd2Koma3U+PSI3kH/VF92O2/eNYX5+wjfh/2Vc6jVYMovzNGxPNCLJ7XlgCDtjALeOvSRv12cOAV+JUz2HVXS1caN5172b2niiflEUv2AbqWxz/2C+/ihT+xR+ERajEfmuR3+UKVDi0LG24zYDlB8i/lHrXkltp+gmqbiTVZYXdQEXvVxFjv/C12IhlyeJtRh7ffZIVbkK6IubHNMVNWk4YeS5UKr7kSLr0KhGHSExqvYw+wLQAOfJwVNeTYVQrNFBIO3LCv1n7tYrokykimu66AFyXcwijAUrUzagJuSC/9UL67ZFU+risFECHhWE4pKJQvu8g+kdnPle2vbh2yqqHtOORgyiDwLtKfbKOBGczPKYO4AVtW45h6j1fMEtsZubrIPSf1/L9IvxLGqDqJ15UZfSDvafqqTxeihfagqc87jW9869Xylqxd3h7R1m+nvYuMF16LZ0FSiEAO59mK7dQv7g5aTwpd+niC1YVHGSgJU4fyctH9zEMSVF
 kchN36b+
 I3xbNp2AAJ5haTKnf6gmijKwZ/8W4MON0xvzzO2qOjrh2RujixjjoWGfC+SoKoRBTyX5TbchdFaPwUTg554BeiY8lzVGYaHXhOUhfbkjOXEf+m/bd/+FbYGgEo2sbqUhxNfY7HPcTWo0rofGY0kjA/5lg+uqOdlS//0kF0ZwBT2JGFm/0B5rgcjgzj6QYV0wKBBac1O9CDZPG9EUx5ym1yrJ67aBYENHfLhe/431YedZ8E32mqyH0uFAligCpf2GEMEO/Q7bAQnx/j30IT1OBnx2Tz2FsVyi9R67/VXmDiIXcQzoz+OBRRv5u8T0LgIi+bTY9HrkEtIAdY2H9ADASpEDojN97XDUPr2r/TIqbRWmOno1cVuJS8OWjLBxIE/78CGPzGTVcbd1jkVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 18, 2026, at 03:46, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 17 Nov 2026 19:36:23 +0000 sashiko-bot@kernel.org wrote:
>=20
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [Medium] mm/page_ext: 4-byte alignment cap in
>>  page_ext_data_alignment() on 32-bit
>> --
>>=20
>> commit 4ecca9da35d7e4448f4270965043775293174eda
>> Author: Muchun Song <muchun.song@linux.dev>
>>=20
>> mm/page_ext: fix client data alignment
>>=20
>> This commit aligns page_ext client offsets and rounds the final entry =
size to
>> the largest active client alignment.
>>=20
>>> diff --git a/mm/page_ext.c b/mm/page_ext.c
>>> index b679a8c1f7d7e..dbc1bfa258f15 100644
>>> --- a/mm/page_ext.c
>>> +++ b/mm/page_ext.c
>>> @@ -116,8 +116,22 @@ static int __init setup_early_page_ext(char =
*str)
>>> }
>>> early_param("early_page_ext", setup_early_page_ext);
>>>=20
>>> +static inline size_t page_ext_data_alignment(size_t size)
>>> +{
>>> + 	if (!size)
>>> + 		return 1;
>>> +
>>> + 	/*
>>> + 	 * A type's size is a multiple of its natural alignment. The =
lowest
>>> + 	 * set bit of the size is therefore at least that alignment. Cap =
it
>>> + 	 * at unsigned long alignment to avoid excessive per-page =
padding.
>>> + 	 */
>>> + 	return min_t(size_t, 1UL << __ffs(size), __alignof__(unsigned =
long));
>>> +}
>>=20
>> [blah blah]
>>=20
>=20
> Yeah, but the whole expression is quite reader-hostile, as min/max
> things often are.
>=20
> How about doing
>=20
> 	/* comment */
> 	if (this1)
> 		return that1;
> 	/* comment */
> 	if (this2)
> 		return that2;
> 	/* comment */
> 	if (this3)
> 		return that3;
>=20
> ?
>=20
> The code generation will probably be just as good and it's __init-time
> stuff anyway.

Something like?

static inline size_t page_ext_data_alignment(size_t size)
{
        /* No client data means no alignment requirement. */
        if (!size)
                return 1;

        /* u64 has the strictest alignment required by page_ext clients. =
*/
        if (IS_ALIGNED(size, __alignof__(u64)))
                return __alignof__(u64);

        /*
         * A type's size is a multiple of its natural alignment, so its
         * lowest set bit is at least that alignment.
         */
        return 1UL << __ffs(size);
}

Thanks,
Muchun



