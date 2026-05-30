Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990F4CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 07:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC516B0005; Sat, 30 May 2026 03:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C4B6B0088; Sat, 30 May 2026 03:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6829B6B008A; Sat, 30 May 2026 03:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562B86B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 03:47:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89080161791
	for <linux-mm@kvack.org>; Sat, 30 May 2026 07:47:13 +0000 (UTC)
X-FDA: 84823305546.29.593EB32
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DCDE2000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 07:47:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XlU47XZ7;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780127231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxXQXGjA8Ez+LLNGezkt0TxaGdPDqNizkUCvoA6K7p0=;
	b=iP378f9cDP5wPbyYwlqqGe/OZWUWLCeTG0jxjXHJnnfe266HDwlveh0ucMIXLhwdLl79Ms
	TYBBGra83sqZtP9PJigba7fdNcD3q2bj5OAzsRya01djFFoUGCcTr7duObdzTc3PxALM/H
	8xArP/Y5w6lAKKL4HSJCCeK9qpdsLDk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XlU47XZ7;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780127231; a=rsa-sha256;
	cv=none;
	b=QNEGcjKN6fvs3y2MOfVXFMeF4tiEhjLMvedeVbz5HhPE3S+SBZi2+6leQDsIX1zDeVXdFQ
	AQZxx3yXM4yxe9nwfFhgpX0s56nJl5cNxWjr4mCag+HLnINZjfto9e2CZytuP86eIdsal5
	6DnlWyumZJXJXj1x3OgpfZaaELJmIQs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780127229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxXQXGjA8Ez+LLNGezkt0TxaGdPDqNizkUCvoA6K7p0=;
	b=XlU47XZ7t70fUvpZtLoR7bU5qgPv3nVY/flIm+FlY+aCJVaW/2OcOM37f9BjQ1OEGJvAaI
	OZwER44ej+Z8rnIZum1fy9fCFDR8gZ0vOuRCpNdMO4klHc3Ei1+TdY1vtL2fGXk3go69Md
	ozbTnRO59SwW8/C48shqyJgtE1VzN6g=
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@intel.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH 0/3] make persistent huge zero folio read-only
Date: Sat, 30 May 2026 15:46:48 +0800
Message-Id: <20260530074648.33513-1-lance.yang@linux.dev>
In-Reply-To: <54986350-dfd4-4065-b960-e1ba30fee4b8@intel.com>
References: <54986350-dfd4-4065-b960-e1ba30fee4b8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8DCDE2000A
X-Stat-Signature: yhk1fj4ypesrswpx1bmr8yffsadyr8ig
X-HE-Tag: 1780127231-174979
X-HE-Meta: U2FsdGVkX1+AppIxaxixx36daftuFQJBnnN+MlImqU0SaOGoI3Gxq5i7oLOEfHKQbMxUvRyTOqN3o1BJIJTMTndh7OWPfgeDF2Rt4Nximab5NLa/iRCz5zJ477ytGn11PDrqBsXRL9lTiKc4uOQCiBVG3iG05bEmfbO5amDLqTLIHPKL5qlm6aGWh/pHrI0ceGNz3SBKDFZuXfC8ov5DogTyTKuNUnjojibAGB0RdX4zfI+Vaz9knj3d+fU6nE1ew+zL2gXq7i7ybLs5mZ4s7p0ZwiXGC/WRSjpTOFQI1zeK8WstggdFsgIR3Xl5OVH0QWL8VwQyh73ObOxRJTEKX958e3PeNmh2S18iPaEaiVQZJmVGOBzic2A2FkO5SNyAcvrWtSFxdKiFczaSBjPgKqgzKvjFYIwxhy5t1n8PsoxE+Fc6fAzvYaWl9E1tD30JCIkZpnuWhNB8QYhF5dMp2GG4QTPxCs3x/aWmhnrEou8IeTrlrcYQ9BqNgb56JrFgjyPjHOlApkpM9i6S7Z2rY2tM3y68HhA5CopJHACIqeElypQ13xIEttam08Gj/O52mvAVYxT3m1lZ/UhlfShQZ/sq21arg/xwiuElGZn/1qeH7JsVgxYWqbEeSeRhv1kWMnGM0oOEuZ/44Joe/gVYho7y7xhbJhcvm4tnO51//UOkbvxhrQqiR79COm62dgePS0N1WMt1TOTIVfmOtDOacH4OrUUdySxvy/TLLIE5EoGShEWAIr40ViNnuM+tPHn3RGPcG8xf5YtbLa3W1P6tAF6o8sZP1wgCSEYYG0AgEJYXddStOedSnVQDXh3Rr5h4o81AeizKPM3ZtseYhsqZzkg/v22IiGJG/aKBPn9NKxGu/Yeg9IBxjjJvT8HUZIXKY96QAny8dUxu/6ktDTzQXeCYM6OdH2DlQ88asVNvKHiOdS4Lj6/u41x//HcmLxHLS05Wqb6b4JnsYDe/YTe
 CCT7tZnU
 u0DRxYuJ+Y9LmtVrC3GEIRagi2nUBfJH7VxXoVxOKJP2qVOARrxXC4abEsdjNuOs0yXB1ASrWJMORKsYJIiBfHZZL4DmPrxSnt9o8u6EU//CBgnQ1S0ERwC+NL6nVC8Fmjqu6ikRwloJ9M9ISgHzGeLcmpfvmHN2KZZspho17LkH93TFv+4+giPooz60OdJK3B6beLuXzZ0L0wLnTSIspSWY3tvq6JL5H3XY21R7eNsrxReEuAn0MCjPxbiGIvamxEkt6uH3PAUqN35r6PGRa9QlPRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

Sorry for the late reply.

On Wed, May 27, 2026 at 08:58:38AM -0700, Dave Hansen wrote:
>On 5/26/26 20:56, Xueyuan chen wrote:
>> The motivation comes from Jann Horn's read-only zero page work[1] and the
>> follow-up discussion[2] with Yang Shi. As Jann pointed out, the kernel has
>> had bugs, including security bugs, where pages taken with read-only
>> semantics were later written to.
>
>My overall concern with this is that it's just a code hack for the huge
>zero page and nothing else. It's a total one-off.

Fair point. I was trying to keep the first version simple, so I
special-cased the persistent huge zero folio. But agreed, the arch side
should not grow a huge-zero-folio-only hook :)

>I think you need to make the case here that the huge zero page truly is
>a special snowflake and deserves a one-off special snowflake solution.
>Because it doesn't seem *that* crazy that there are more things that the
>kernel dynamically allocates that it wants to keep read only.
>
>Maybe there aren't many things that get mapped to userspace like this.
>But the case needs to get made either way.

For RFC v2, I think we should make the arch hook generic, probably
arch_make_folio_readonly(), with a weak default implementation. The
persistent huge zero folio would just be the first user.

But even with a generic helper, we still need to be careful about the
model. I see two possible ones:

1) Treat "read-only in the direct map" as real folio state. Then core MM
has to know about it and carry or clear that state in paths like
migration and freeing. It also makes the possible direct-map split / TLB
cost a more general MM issue, not just a cost tied to one caller ...

2) Only use the helper for folios with a simple lifetime: allocated once,
not migrated, not freed, and not written after they are made read-only.

I'd start with 2. Keeps the arch API generic, but avoids teaching core
MM a new folio state before we have a user that really needs that. The
persistent huge zero folio still works fine with that model. It just
becomes the first user instead of the special case :)

Thoughts?

Cheers, Lance

