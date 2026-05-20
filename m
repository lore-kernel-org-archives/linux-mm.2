Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B11CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197366B008C; Wed, 20 May 2026 07:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120FE6B0092; Wed, 20 May 2026 07:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FAE6B0095; Wed, 20 May 2026 07:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E13836B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:58:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F0CDC1385
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:58:00 +0000 (UTC)
X-FDA: 84787649520.21.49FFA9B
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf26.hostedemail.com (Postfix) with ESMTP id B90A414000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:57:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iG5yRu4b;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzN7l1ThkVlwzYft29/2nDhN3g1VkN9d+lGAiRZSN48=;
	b=SzBZs061Jpxy087/OpG+fyvHUZKG8EWaxkTrRlBXojjwvRDwiImTQMUa4mGMNN0StmFEpz
	4R7ylJEKH7b/nHJQ85VDJ5UJC5nKDMWz9HcPOsdMqo+iShDJhFyR5RyRVi2fP8s1IchIRI
	u5jYzdvj5mVlmFwMtTEWkb2XqjrG7/4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iG5yRu4b;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278278; a=rsa-sha256;
	cv=none;
	b=18kcAu8krm7A/PVmvvh46c3DDWhGm34D+jf9Ko/1C0ifnVu3e/bxQ23JBNREz3ayw0M6D1
	ni5f/AM1kjkOfYDaKThtXjctcFUhTzSZWq7vOu7k2ebEg8AO4eTSebe9+ILzPdHHsh7bXY
	penzelfb5KecJJKGOu5Y5sd6uCvC5PQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779278272; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=PzN7l1ThkVlwzYft29/2nDhN3g1VkN9d+lGAiRZSN48=;
 b=iG5yRu4b/wBG+/Qs9QxI8W+a6tlM6enK3/n8NlURP80woWzz8dpgie0b3WQagbpHlASh5I
 MQm+M+Q1cOssUGNHeC6TB4qRVnguy57tLxCjabxQuDKhZmqQhaoLISaLD1x751SaK2SX6O
 7e9npIp9f2VujT8+i076Or0PUgyBHO/LuO7Jg/1J/+WXbRhVc6KtfIt19Rfm0zcKjm+Qb1
 WCEYuJuzvwvzdQrsOW90Ij9vjIepgAGCascHLFRlelOWrd4y/ZxkFSe0tk5XFeWDoIj8H7
 jFycVntHGSD566lVM7AvtX4+3UpDMVlNEYvJZR+Opi5NZyEaYMFUzVR30xfwbg==
To: <rppt@kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
In-Reply-To: <ag1Sog3zDcJuOaaE@kernel.org>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Message-Id: <20260520115731.35059-1-lizhe.67@bytedance.com>
References: <ag1Sog3zDcJuOaaE@kernel.org>
X-Lms-Return-Path: <lba+26a0da1be+713187+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2026 19:57:31 +0800
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: 6i88zxk5ogxdefn7z16wsa4q1kaxyepn
X-Rspamd-Queue-Id: B90A414000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779278277-240328
X-HE-Meta: U2FsdGVkX18afXUfOXHSKCkgSRQnWzHGW9JZ1cO3vrFOxbUKLzkJaidMSXWxe3QSNrJBx7oTLxSu+QKSn5s4CEcngh3Qsf5KtGT1enSTUTXn1SLDFb5SpNqGTg/YS054D+HWNlN0+mUhl3hpxs8ajpTfpIM4GXA2sWoVcawOF+tahGvmPWwUxZ2vYgP3TuJWxLW6dYFT+OXmw10+/pI1DQBHcd6vuUrLYytc6jzLXxfGkbJdogzMzeooWvITdk3rqhlmJiM1X/wVYjUeewj00GPmxiDgAR5om/JAF7PkomqUS3+Vzv3WCa9nuWawBNPmsOt4vejRaluSUDnYmmlqBpi22sm5wbIuJ5SE5uEIarLgBN74fI3RbiJsn+9rAZmx+O07UeVB4KW/0ZXAQBqqNLpLJonXCtRVgJPgl4eRDqv6LGJpuLBpqZDsY7jNAUmFZ1Kl1hu6v/SMyxsnsc4Co8ckqsf/2UoCNF0J+kDjGM3h2WPMfHNjUgK8T3meU+DJo2146bhwiZ2Yxj0sqtrFGwNJ757WXLtf+YUxeBuEHtL5VA9D5waSbmOwNvCbtawJ/WahCbDA1ic3l08Nla6ti1MykGLHgnV3mRR9QhsLMprEA1s2ZvW18yQkOMJmJyxkm7wODmsVXj6LIrjF2Ls42EP7HUh3jWqqxuriLICqG/75ECTqCMl3TGpbMRbSGnz+ZP1sCTrbO4rY23ZZ8LsO90M9y3b2wcBgLv4mV0iv33Q2lYpuqAKLCGt4O+/yQGrXb5CusAi0D2UfksMy8p3Utu5NCMSTfDV7oFvPF475BNONOAZ7InOHQT8pIjNdKAyLiYLZwoZL4h3tP2JrBGu5aR88mbfRXPafMA+yO28xXkAVj4MvLX/5D8YJlIrM9t262ENDOH8go2jGJdxfGRIGPNUA2YpTq9MpWBsVp8bXCG2HSkTv7koRwGHQraBnhgZTEsypa8KqBNe+2yGp4t/
 G8ptAZqM
 WO9oP1oW4rnoSapIc22o7wvIFQFVgsh/ZVL60zb2UzRXnCnPALIDibcZ6Og0aYC2d4kjV6uqNkiYIqUzvVhF8BPASojJPJCEtUcdzXxJ73RM5f8l2j6GPl5JF/ls9ai5mqnqP+as2ixINTDWahhSLcaMWL8aBR01P5Nmx0b46J2Kl2QmNGYfi9LMTWacHoHam2Au/VqTW/casaPVZS55y2rSjnnJ38O2pIzGjHf9HNrFr/+Qi41bC4GajPxHK9W1q6fAgqxaFsLmrQEs8cG7Ulu5uPcGgg/HKAGVejMZY/CAa6l/1UGraKnJyyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 09:20:18 +0300, rppt@kernel.org wrote:

> On Mon, May 18, 2026 at 04:57:00PM +0800, Li Zhe wrote:
> > On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:
> > > On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> > > >
> > > > Performance
> > > > ===========
> > > > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> > > >   Base(v7.1-rc3):
> > > >     First binding: 1486 ms
> > > >     Average of subsequent rebinds: 273.52 ms
> > > >   Full series:
> > > >     First binding: 1272 ms
> > > >     Average of subsequent rebinds: 104.59 ms
> > > >
> > > > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> > > >   Base(v7.1-rc3):
> > > >     First binding: 1515 ms
> > > >     Average of subsequent rebinds: 313.45 ms
> > > >   Full series:
> > > >     First binding: 1286 ms
> > > >     Average of subsequent rebinds: 116.93 ms
> > >
> > > This is really good improvement!
> > >
> > > It would be also interesting to see how the template approach would improve
> > > "normal" memory map initialization.
> >
> > I also experimented with this approach earlier. Unfortunately, in the
> > normal memory map initialization path, functions such as
> > deferred_free_pages() are invoked shortly after struct page
> > initialization, and this function performs both read and write accesses
> > to members of the struct page.
> >
> > Non-temporal stores via MOVNTI are primarily beneficial for streaming
> > write operations, where the cache lines written are not expected to be
> > reused by the CPU in the near future. In this case, however, data
> > written using MOVNTI is immediately accessed again through regular load
> > and store instructions. This results in an access pattern that resembles
> > a write-then-reuse workload rather than a pure streaming store.
> >
> > Consequently, non-temporal stores do not deliver the expected reduction
> > in cache pollution, and using MOVNTI provides no measurable performance
> > benefit for this particular workload.
> 
> We can split initialization and freeing into separate loops if there is
> overall benefit, but this needs to be verified on other major architectures
> as well.

I agree with your point.

> > That said, a template-based approach can still accelerate initialization.
> > Based on measurements from this patchset, it should improve performance
> > on the generic path by roughly 10%. I would appreciate feedback on
> > whether such an optimization is still considered useful.
> 
> Improving the memory map initialization by 10% is valuable.

Thank you for your feedback. I will try the optimization after finishing
the current patchset.

Thanks,
Zhe

