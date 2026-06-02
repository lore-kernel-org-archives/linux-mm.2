Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDD2CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 19:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016286B0088; Tue,  2 Jun 2026 15:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08E96B008A; Tue,  2 Jun 2026 15:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF79D6B008C; Tue,  2 Jun 2026 15:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC4596B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:57:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58A0F8466D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:57:15 +0000 (UTC)
X-FDA: 84836031630.23.EFD63B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E67D1C000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:57:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOVI2Ocr;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780430233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vQhc1dbc5LVHsBRrn3VszFfXAXWWO1kVMy2oolTIN8=;
	b=UhmGEpchcPNMTEzhnqp1opuU6oZZODvwaE6xHqBizWayQaoIov3JvEH1OctNcfTEC4ntDE
	tvgaH4ykBWdWQOPWJvIH2rh1VVZ+N9VtpLxyEKVM3D1OdFkzltaorfx1OrT/GCMQm0rhsN
	LCETOkQ5csFhfsq0vZxh6LFzsZuiSlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780430233;
	b=rh63fLfKZClmraW2I0QAEO0ifpctA4EdjpcM0er7cu9vNG0yQU8ZAM6JEPrs9BgfwUM3Z9
	knETyaGYlVxaLo4VzYZIxNORO5prFSssAq4tXRX9rq8nClHWwPcA7pMGuTFd5vWGwNrd4+
	rg2GkxorHgx6TbUGWO4UQQ4ra2PoAlA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOVI2Ocr;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5830D4171D;
	Tue,  2 Jun 2026 19:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4021F00893;
	Tue,  2 Jun 2026 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780430232;
	bh=0vQhc1dbc5LVHsBRrn3VszFfXAXWWO1kVMy2oolTIN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hOVI2OcruvfTllpcq0jsW7aDFTSL3NcP0W3HNxtTvh9lZ+6HJZe87VAiGFM5ZpVgF
	 vVs4fil66BhU4jNutDHSlKK/hFHWCZrsFTLyG5qoujYRTQSpet4Iob49+SWHx4tzvO
	 1BBPDWzv9nT1gmYEchMPRpHeKH4BqWbg7dDXSz5rydwjOciOQpeXdcXU9qsAsmt7wx
	 t7nN8hUMN5WzSC2Bc6L6g/Y1x/iQyePeVVe06eotXj3k58evUKF76WykeF9zbSoqxY
	 R/wPNnx1sNH0ObNSmUYvzw4T/3fa7V0UYM7puEYChaosOovG4sx7ZUBOlAYHltuxBm
	 st+Q1CEvD9xaQ==
Message-ID: <1fb6a226-2899-497c-abbb-eb49c3a2f306@kernel.org>
Date: Wed, 3 Jun 2026 04:56:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
To: Barry Song <baohua@kernel.org>, wangtao <tao.wangtao@honor.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org"
 <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
 "luizcap@redhat.com" <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "liam@infradead.org" <liam@infradead.org>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
 "riel@surriel.com" <riel@surriel.com>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bwW6faxu8TU10uSydRwBrOZz"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E67D1C000D
X-Stat-Signature: m7hkky7aaghok85619c4get75i1x8rxt
X-HE-Tag: 1780430233-379534
X-HE-Meta: U2FsdGVkX1+xOs3IgTGbdm/TBvgp/udgRbLQhM+xPwN50hVf6YDNclbRaD3J+sMKoZsDibiV43R1q8PzP2JSsUhd63zyf12xquluX53eO+aZZfesrgJHcXw/EPkSe6ECtPGnWOMe8K+UDUgJFSI/RXUMC2r9eyCmJTyLWmx+m+73RqErZtMTckaPESw9f+ueaxWjGedPu6SEx6EF9DODGNcXrCLURLD19S3qRsNJDrzQQwI98gpactkb5W5gb4SKgjHstE/gPW29DAtwVb3MHI2Mkq3pS5u8PFAa17+rnvAXWxdDMU8/zADyEazQBN/go1bUdETSm96CBv1ZZpSTqta0wi2Vug6M0ZHoRYu3pthYqLYX8WO+IW7QPPb9xFCTGXsqQsv66JHlmBOB86ji0r3jFAn/BNftAtaCmE9J1pc070pMJeAm3WyC1RcKo+mAtw6JjmHaIP3behETrlaxDMQAHtLJD3jg+YRWoI27zpnOM+QI8mCHwvrpW6w35gdfeUu+xNhNA9C0NDlv920BXoHBLEj8qjQ5tbtQ9Osi3PFG2++8OCu9yGGxcaUsiXkYoJg2DmcSm9xlc53/P1vzw1R6acHZR0yznfCgmX8JQUXtRHGc8J4y4fECvZmIhsbEkOSAB39seZ8+i/DrQmMP2tkrLRzwT7NDOCwuCdaj1nigCAso0IdwRgBYXFIhzH7JK7IgRdYLiFep3kGeO++S/cy7/gICOFcfF3KBC643o283bI9eQbkjYwixhv9DvVrti20mLctwp3u/Qqt5Cyd8Z8zTwwKgfizgTTcpSG4AxAyKiZuZ3BXGV9VJaizbVCPm0ih6EhXWXBhi80cJzor5Ny7k0iPlf2LtLWHGq7i+FWVbBJXuAELqTEUwTK7reKkXlDqYk4ERQJQWyho99mYR27c8T+k5ZGDhwIDPB9Z2vNWuzlPZfcFtvha7apq3OzDka9rEcMxOqr8h/LMriH2
 KUbzYNem
 hZ2xqY7LSs/5TpPZbp8t2sqM3SR0bcXc4lpCi+0CkCvPmOY55iDWOapUeabSz9nz8DLTBVxtots9IId1xIs0zG95oziGzJfNrSD+eK68rfHbrPQ84Qag31YfBEw4N0recJKhRtBnLbjhgXfcHtFyVoUWNaOj53n1ea4lH6z0LYm+riLyntYTfYOZ+L4JJRc52tgPO42SAUrC0xXTKe0gYbp0Jmwbg780w6DWJskA2wYrh+FIXEP7nyxHTXAUqvEuU4qLVRyMMYT+y6P6TzBIQ51uYEohl5mszz43t8ro58iVgBE39ztXbA857nKSMRnXvF3cVQsNO8ZzXgQSXw3xN2KlML/O1fAlfB5DZZjVwjcC2fz366t2JOH8pk8vZJcaCLOZoBLvRm8k0N4J8AcQbiZledQzc3namGfOzVvVM6UGfFCA/MSP+95NHfqIXUl4nFLBKw3T0Ox4z/oMGadv0h1f6OuhVSMy0Rqawk/Rgv0zJ1EbYMmq/2MwHbKd0R42Gg1JMBqnnmEHkK/eOhzUwhH5ILTaVVPxJLKQEZ62umdWWw+K7DYWuGHP6/CFVbUF5bm8o1mtLpa/NplhEXHw4GMPl9OJUccCpOcQGZsDe1oZ0Q17p11up1XO1HAzPfurnodJl/x0Hghm48N0FglpVIGDatbFCHZcOV3ck+4Ls48K5mPxkB8sqAHcz2TzbAZ+nbjGF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bwW6faxu8TU10uSydRwBrOZz
Content-Type: multipart/mixed; boundary="------------YuOxOu3OkEnuies33ChEyi0g";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Barry Song <baohua@kernel.org>, wangtao <tao.wangtao@honor.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org"
 <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
 "luizcap@redhat.com" <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "liam@infradead.org" <liam@infradead.org>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
 "riel@surriel.com" <riel@surriel.com>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
Message-ID: <1fb6a226-2899-497c-abbb-eb49c3a2f306@kernel.org>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>

--------------YuOxOu3OkEnuies33ChEyi0g
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/2/26 11:15 AM, Barry Song wrote:
> On Mon, Jun 1, 2026 at 9:46=E2=80=AFAM wangtao <tao.wangtao@honor.com> =
wrote:
> [...]
>>
>> You said discussion was welcome, yet when someone offered even a
>> small comment, you refused to continue the discussion.
>>
>> If I had known you would be this inconsistent, I would not have
>> replied to you in the first place.
>>
>> This will be my last reply to you. I will not respond again.
>=20
> Hi Tao,
>=20
> Please don't walk away from the linux-mm community. I read your
> patchset and found it quite valuable. It not only reduces memory
> overhead, but also eliminates rmap costs for exclusive folios.
>=20
> Since I'm not very confident discussing technical topics in English,
> I wrote a blog post in Chinese about your patchset:
>=20
> https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
The cover letter and commit messages should have been elaborated to a
much greater degree instead of making people guess the design and intent
from the code.

> I have to admit that I found the implementation quite complex and
> in need of significant improvement.

> However, I think the underlying> idea is very interesting and worth
exploring further.

No. What it is trying to achieve is ambitious, but the idea itself is
not worth exploring further as-is unless the correctness and complexity
concerns are addressed.

> I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> implementation while preserving the core concept.

I'm afraid this encouragement would mislead us in the wrong direction,
where all of us end up wasting time.

There isn't much point in posting v2 without addressing fundamental
questions about the design.

> Regardless of whether it ultimately gets merged, I hope the discussion
> can continue.

Regarding the "improving the reverse mapping subsystem" topic, a more
constructive direction would be to carefully revisit the design
decisions and discuss what we can do about them (that's exactly what
Lorenzo has been doing).

But that's not the first thing I would recommend to a relatively new
contributor given that it's really complicated and even the people who
have designed and reworked the reverse mapping subsystem over the past
20+ years haven't come up with a fundamentally better design.

Reverse mapping is a frustratingly complicated subsystem. Without
carefully revisiting the current design, there is not much hope of
improving things at the design level, even slightly.

What I would recommend to new people instead is:

1) starting by reviewing other people's work, so that you have enough
time to learn the historical context and subtleties of the subsystem
without making intrusive changes (which also keeps in touch with the
community), and

2) making progress on smaller tasks with less intrusive changes, to
gradually build trust and be able to do more valuable work.

Unfortunately, looking at how this thread went, I see that the author is
now in a worse position than an entirely new contributor.

--=20
Cheers,
Harry / Hyeonggon

--------------YuOxOu3OkEnuies33ChEyi0g--

--------------bwW6faxu8TU10uSydRwBrOZz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah81iAAKCRCGXBN6rc5S
1jxVAQDM4pzeofE4dxdOjh77PA9/N7OslJ1TE4+pZBNAdPvx0AEAwjZ+A6hUR46O
dTxVf76ruthYIxyJpw0aYD6Yrw472QM=
=9zed
-----END PGP SIGNATURE-----

--------------bwW6faxu8TU10uSydRwBrOZz--

