Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA90C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 11:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21BE6B0088; Fri, 31 Jul 2026 07:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2646B008A; Fri, 31 Jul 2026 07:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F316B008C; Fri, 31 Jul 2026 07:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 740016B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:57:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE0CC1203DC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:57:58 +0000 (UTC)
X-FDA: 85048923036.29.A4E9AB0
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68B741C0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:57:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xr4jU4cT;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785499077;
	b=32IL+YY6d3nzfu/vfGMLUMH8GE5ysU5ikmH1A6OP+p7GThKzp6Qi/QYcJFSUZK17nIsY7e
	FEatSKln0bW2HQGreGVI2kNqFRKRuCDjCT/ABOeCYCyeagfeSgJCBi76nanSO1/ncnFTFW
	/zrVfdf05lm+PgdntTimCFs8Aob6AYY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xr4jU4cT;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785499077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnM+fZMqOTfOvPya0w0t8FJWn6k/GbvAR7xBXXOi7v0=;
	b=p/AdCtU73cqCLTkbgodSjjmDbyh3Rj1ZVFXITrZ67GhGOdhe3klPz+1YwOxBg5lHgjoIJ1
	vUNqiTik9dg2JM2LGYxWsn21xxA5fNtpopf5mHOHPWz1LR+GeT+KLzVB6nXUgA0/orVYID
	xNwLauvE1sUnMhdEGLiMTtHGwrusNWk=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785499071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qnM+fZMqOTfOvPya0w0t8FJWn6k/GbvAR7xBXXOi7v0=;
	b=Xr4jU4cTlta8FK2nH1n38sVAnWN5KkXMYZq8JZ5Ke+g0wKDofFqEvav2sSCK4fbJHu4+8r
	9QFBwADJbIN0Y69wzG6Tyt2u3Di4b2Jv5qfS1A4kzvf+SP4pGyM+FA6Ej7g9glxZXn15Q6
	Od30JIHbA7eiinUkmVe99Fb9LLv/FZA=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jul 2026 11:57:33 +0000
Message-Id: <DKCQL9KO4PD1.27SYU4GD2NH8Y@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu" <weixugc@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sumit Garg"
 <sumit.garg@oss.qualcomm.com>, "Will Deacon" <will@kernel.org>,
 <rientjes@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 <patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy
 Lutomirski" <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Patrick Bellasi"
 <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Nikita Kalyazin"
 <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map
 helpers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
 <amu1KN8uJt4aaZAM@google.com> <amwwwe4eYeXtniFu@kernel.org>
In-Reply-To: <amwwwe4eYeXtniFu@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68B741C0002
X-Stat-Signature: cnfujmqfrdkapf59bazyoqxpqx8xfg7h
X-Rspam-User: 
X-HE-Tag: 1785499074-577293
X-HE-Meta: U2FsdGVkX1+s2oVRJwH7FpNZtgMGAsu3GGXfizG/SKu98Tm3z94k7KKpnuwd9GZXfR/cNJp44SxomkeUstlx5iigWvTwanf/USbZPGGqoP3z9ercK7f7iDCLIDlea3kuC4tnMhfb246CUpKayjnnvfdSGqh7rAX0uVpzwrQn0mTHwVXquqSIW2we5JJ4ykXrddyUvijjWjCAzQc/rS//wKt1REIdwgp5zqzP7Il4DR9VWYRbZuE/q29jBAExSJ8PcdShpsk+YfyKdOPhu4AYR+3VseSiHgNPGwVwjfqRiHo5bOe5gyqCITOC4kg+dr8RVJ733PkK8bBOI1QIMU0xIl4L1sy5rG1G+VDXITTehaAyAtfTnPeZ9W0aCmvs2XJcqG0RhHDZIFxqItyn75hoFXcvFVZ0QAZTxIdZ80UfYRha0AWFJoWy9dre2JocNi6NjrphIsKXc2HxgVzlG0gRONCYizOYV9WqQh9R/wB36xn6cqJaF1SK9I+2l8BQUNYO1wtolbsltxw9rMnSqUdFK1wZzVBH8kyiyEUN25UxhTb6gHnwD0gorysPy1Kt7O/6355+Xtmv66oSYaYecGYPqOGPJcJiPhkx7MgPzk/3ClGRykF84xqxM9fAU86rfKUlNvw1yK9y0pkQAlXofNJEabKjGn5kXVLpnu78Hgxb7O2BLo+DxuOmi7uyrZpgjNUwyapSRpFcepHrrABXHFcrwMzIFK41gbxgo1/66lAaJguKuqRNgHHkoxXXgFK44mjo2vTTM7+NARvFwf8qs4gcF3bMQ8kE+T348s5Kis6yDPZUGYhqVhINVijEXGiu76lHzfRAZ/4UPPJC3ZX8pEZGgXVeN7BGp9p5wTAVti9z9WC4BFNubFJ9BoJEg806MwuSTdnmTjQGtn54hqKeOZKGtgikucjd0HNIn/K9XW81egYDRUajJ2oFIxcises6Mtbh/RHpnneAV+0MK1x2G71
 EwQjn51V
 bLXZT0JA/nnkFekT22zQ+vj7KfrAw+VENgU9iZrvTlCowKSPHjRLAE9A/6jSNRx3qzgCkJuZqSHMPQwjxzkFkedNHg7oQB5KDcIvFhtScpaVMDVwqTB+vw4r8fwLkgmswlYqqXvRcwYwHazYDgTMLHEDkGL1fkfPZt3Lb31e6Lpi9YYFKgSEq6zzNKSjh214/+pbRPpOXKSGLHmB7Vk9mFLZ0NffP0tyjtRzjMemH38ffdmZLTfNOFDOMyHINeXUvg2dDq9D4OKrIO5SG278ovPOtz3WcSU06DZUMMg4lz6gURsKdsme4sGm3HUQFYVbmTa2ABh9XAlmdm7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 5:21 AM UTC, Mike Rapoport wrote:
> On Thu, Jul 30, 2026 at 08:34:57PM +0000, Yosry Ahmed wrote:
>> On Sun, Jul 26, 2026 at 10:22:34PM +0000, Brendan Jackman wrote:
>> > From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>> >=20
>> > Let's provide folio_{zap,restore}_direct_map helpers as preparation fo=
r
>> > supporting removal of the direct map for guest_memfd folios.
>> > In folio_zap_direct_map(), flush TLB to make sure the data is not
>> > accessible.  On some architectures, there may be a double TLB flush
>> > issued because set_direct_map_valid_noflush already performs a flush
>> > internally.
>> >=20
>> > The new helpers need to be accessible to KVM on architectures that
>> > support guest_memfd (x86 and arm64).
>> >=20
>> > Direct map removal gives guest_memfd the same protection that
>> > memfd_secret does, such as hardening against Spectre-like attacks
>> > through in-kernel gadgets.
>> >=20
>> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> > Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>> > [Added comment, dropped modified set_direct_map API, added highmem che=
ck]
>> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> > ---
>> >  include/linux/set_memory.h | 13 +++++++++++++
>> >  mm/memory.c                | 46 +++++++++++++++++++++++++++++++++++++=
+++++++++
>> >  2 files changed, 59 insertions(+)
>> >=20
>> > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> > index 3030d9245f5ac..1bf2a15bca118 100644
>> > --- a/include/linux/set_memory.h
>> > +++ b/include/linux/set_memory.h
>> > @@ -40,6 +40,15 @@ static inline int set_direct_map_valid_noflush(stru=
ct page *page,
>> >  	return 0;
>> >  }
>> > =20
>> > +static inline int folio_zap_direct_map(struct folio *folio)
>> > +{
>> > +	return 0;
>>=20
>> Should this return an error (e.g. -EOPNOTSUPP)? Seems like it would
>> silently succeed if the arch doesn't actually support removing from the
>> direct map.
>
> That's the pattern we have now for all set_memory APIs.

Yeah. And I think that's fine, the risk of silent failure is mitigated
by:

#define can_set_direct_map() false

So yes code could call folio_zap_direct_map() directly and get
confusing results on unsupported configs, but that code would be broken
on arm64 regardless (coz it didn't respect can_set_direct_map()), plus
later in this series is:

#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
#define ALLOC_UNMAPPED	       0x2000
#endif

So higher-level code will fail to compile it if uses ALLOC_UNMAPPED on a
completely unsupported config.

