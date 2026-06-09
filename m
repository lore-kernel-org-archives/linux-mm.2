Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0FCCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC7E6B0005; Tue,  9 Jun 2026 10:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D2B6B008C; Tue,  9 Jun 2026 10:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3846B0096; Tue,  9 Jun 2026 10:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA94F6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:27:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 507FF1A05CE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:27:59 +0000 (UTC)
X-FDA: 84860603478.08.D746676
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8FCA1C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:27:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvEx0LGu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKSUe2ZShhtV7rCIocQmxdI/1q9ALaMdNbgo63AIhb0=;
	b=0tz5q3Wa0EIrvv8At7bckQTOko5eI00nGn+bOr2fFJr/BwnLEi7VGnGvuhXxWsEGU33anG
	zKO0+XlaZrY/KbFpE8Ds0qSsCY+uSgB1iDzgUyRQwuSVpw4H9n6c4U5EBJWR9NPq95gSND
	tqB5Zgw5QwgtkiepWvluNeYudjj7W04=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvEx0LGu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015277;
	b=LNsSGfkyt8qvohaXEzZN2Rg+I5ATxIY289G8GSYtrIygeH6m1igNoIcc0mwzSkpr30T/vR
	RWOFKxPCb3hgpfM9dknD4b7h0cx+JpBwT18yDO85b4k5fdBzD2ZJxXZyIdyatPP1ScO2nH
	URQGm+sKia5Xr+2rYLPYk1ZF2nDhliE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0685E601D6;
	Tue,  9 Jun 2026 14:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E361F00893;
	Tue,  9 Jun 2026 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015276;
	bh=PKSUe2ZShhtV7rCIocQmxdI/1q9ALaMdNbgo63AIhb0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YvEx0LGu2EMoKvtx/1rRr93im3SvYiAuVmh+qxGpdz1QA1k8bd+GpCxWdLW2rnWTU
	 Fa3vme8+XkgtU68ZaEPCe+JTXC8BgkUZd7QKa0mXAmuovdCq0dCsvOZxk+KAsvrMEu
	 d9UNlPZRJ0zOrU44kTxPwnXHqXikJleUDJzJgZq/yaokVvEgsKdRY+i0HeNsuoE6Kr
	 JukL3a0yFqdp2ZsYdgg9U+Ii6b3RjW0TYmrrIwBTZEQCgTGSMzlI0H32RrkMYX7IXW
	 hMLdfVU6A93WnStc/UM/X6eWhFT4bhfkbSWDFX6/bH8O1kYCwxTkrar44lyTD0eS/L
	 NWsybGqB70e+A==
Message-ID: <106e71e4-975c-4337-aaff-a00628827477@kernel.org>
Date: Tue, 9 Jun 2026 16:27:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/mincore: present-PTE scan cost after pte_batch_hint()
 batching
To: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
References: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn>
 <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
 <2780f0f6.176fd.19eacba49bb.Coremail.chengfenglin@stu.xmu.edu.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2780f0f6.176fd.19eacba49bb.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FCA1C0002
X-Stat-Signature: zhs9d6yfbpznngtembro8zh5owphe1gu
X-HE-Tag: 1781015277-630247
X-HE-Meta: U2FsdGVkX180dQoRPj2eqsNOZMW/y5KgzpGJk19NUHZyoU8TkjvrVfNVir+dOzyY5W5x1iKSdfyxtJCwM+gAer/Afc3rm7Vm0t9Ny0Y6c4u6ty4pbXcyq4ODkUvcom3EDaiPxVgI2Vbs94NZ6r/vuaoAwEvlYRM6e7FGW1o9r9IhiT6MPrypmY5QnWp2+XN/OvNLqDLoWORRIegoPWJigM6BLXzIvdZQwkGh77tLg4+hW04ZulVkV5JMsC87PRdH6D1jXvbsCP0Dl9I4cg0aoyt9osB6OZ9MlwicJlk7M7d47OZuVU7Gdagi74rTgq8dRtQxb+TccEXSpBx3M5GfhDleZIz44KJyYkTrD/HpAhQD3MxDkS6+owmUT/PqBssCq3/15RxlmQjuKbn0KyzH9xhDV09qnmDppgHmHUq/8H6wTTJ4/n6pboo7ruZDP0Md2koc6hHA1NximXvC0U2hTjIzCCrpWFZoFjAIhEiBi4h9xe4h7S4HBDa+bkaDmzlmadP7TC9H4hfz5oEiBKVWPs9WZMIjJA2VOKRzacrtoEoabKQa7VT5ji0U1GDUah/t/S3H3wAp7u0j3pK98sxXYavTNwa03VEjt1HYVRxLm0sAXoQPaCx25Wi76zO3Di3vCE0osRAUKnVBzm/SDEjOBNS/Jl4jSkoumTWs1TVdc8eliRlSbF/l9j4J5KsBhF4cuiMThuost5KXFsjP3YExEBfv5vUnRPDbZ0GOXp+p9Iu5qJDWPCOdfg1Kq785i5F4KZBOAJg52IF7PWlPIi2X0SDRubu60+UaIYeCkI4A7yRKoPzprv6zu0DCtMbkKgMDo7IXun+qnAnOwL31RRNl7YpPeVmM7dPbS/ZfhqV5qcEwOLHGf+cfWTM3rgc9st9bMieKgN75vNWit/s0aK9DVzwS6DcZOQnrakczm0ziRaLO3xaaTV30dLWQhpBbPw8HcO2sehURNscgErC9iQh
 7ynZ5hnM
 8ym0loz8YGeqNNOK6L8su5Scx5bCSQK45TEZsT8gmzh+QOb6OIzxeaKbMB8r3pWQnxMnjAdL8G6ZkkIDKgt3kqksEQabgWbgVtAd0N33p64WVgTMCOA+IGbKyxyB17sH2ici9fOjkYRmQQanE8QMB2eI+j1WfoHxprebfQwsEg4vAMUoPTYWCATeE3lFxteMYvWpDV+VmZrUq9MLxaM1M1EVYFI4ea2OJRGEB4VHOWRk0NVLTMrF16o0I2pz0qwliWz4ySqLWVPibSVZUbg1K2sxuZIzlkWZVkcH5phUkpfVLuyRj3QoO+1MU+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 16:12, Chengfeng Lin wrote:
> Hi David,

Hi,

> Thanks, and sorry for the confusing wording.  The plain statement is: I
> observed a performance difference in a narrow x86/QEMU synthetic mincore()
> case, and after your comment I checked whether this is really a codegen issue.
> 
> The wording in my first mail was too abstract.  What I was trying to say is
> only that the benchmark focuses on one specific case:
> 
>   private anonymous memory
>   MADV_NOHUGEPAGE
>   faulted/resident base pages
>   repeated mincore() over the range
> 
> so the measured path should mostly be the present-PTE scan in
> mincore_pte_range().  I agree that the 8/16 CPU rows are not very useful for
> this path; please treat them as extra context only.  The useful data is the
> single-threaded / low-CPU v6.15 -> v6.16 A/B and the patched variants.
> 
> The compiler used for the lab kernels was:
> 
>   gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0

Okay, GCC 13 was released 3 years ago.

>   GNU ld (GNU Binutils for Ubuntu) 2.42
> 
> Your point about x86 pte_batch_hint() is exactly the right thing to check.
> Since pte_batch_hint() returns 1 on x86, I agree that the expectation would be
> for the compiler to optimize the batching logic back down to something very
> close to the old base-page path.
> 
> I checked the generated mincore_pte_range() code with the same GCC/config setup.
> The function sizes from nm are:
> 
>   v6.15 original:              0x1fb
>   v6.16 original:              0x245
>   v6.16 batch<=1 fastpath:     0x1ec
>   v6.16 with batching removed: 0x1ec
> 
> So, with GCC 13.3, the v6.16 original build does not look optimized back to the
> old x86 base-page shape.  The v6.16 batch<=1 fastpath and the v6.16 nobatch
> variant produce the same mincore_pte_range() objdump output in my build.
> 
> I also checked Clang 18.1.3 as a cross-check.  With Clang, v6.15 original,
> v6.16 original, v6.16 batch<=1 fastpath and v6.16 nobatch all produce the same
> mincore_pte_range() size, 0x1f9, and the objdump output is byte-identical.
> 
> So your expectation does hold with Clang, but not with the GCC 13.3 build I used
> for the original lab runs.  This does not prove a compiler bug, and it means my
> original report should be narrowed: it is not a generic x86 mincore()
> regression claim.  In this check, GCC 13.3 generates a different
> mincore_pte_range() shape for v6.16 original, while Clang 18.1.3 generates
> byte-identical output for all checked variants.  The timing signal I reported
> came from the GCC-built QEMU lab kernels.

It's probably a good idea to

1) Try with newer GCC

2) Take a look at the actual difference in the generated code

Is it some inlining decisions? E.g., if the function is larger, other code is
likely to get inlined?

The function is not particularly large, so it's a bit unexpected.

-- 
Cheers,

David

