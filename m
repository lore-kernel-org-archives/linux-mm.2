Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D93F4384E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865066B0005; Wed, 15 Apr 2026 11:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8163A6B0088; Wed, 15 Apr 2026 11:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7523A6B0089; Wed, 15 Apr 2026 11:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 609176B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:50:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13D598B71B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:50:42 +0000 (UTC)
X-FDA: 84661227924.09.9535607
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4962CA0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:50:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hR3+dovg;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776268240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOMJEclslTGko0CKo3zJ9nnmBRPTykeI0IPan0usj1E=;
	b=E2vwhS+qkTgflqyh0lvmM7SVxiPWPxVbRQB2OrJ/Qgrh2cGFFHEssxbvjJhBNatg3qtSMC
	8BNmMUweoQvCgN2jeIvBoyMXr5AXrGx++Ux+4qHMvCGDt1lVoFnfGXAkto23B5j3Yi+4QS
	8bWS5oP8Nzdd3ZCTCJOrRg27f9ewPm0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hR3+dovg;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776268240; a=rsa-sha256;
	cv=none;
	b=FoTv3I2t9Dl19wP08x+JP4z6iDLlGUTWGfWA/glleakWFYvPkdpaVXD3VuVYga/G+/jT4W
	IrslH73CNUjnxm4MzDEZc78NW9PjRK0dkrtHFGqSmQYJRCgsZ1iN9gtQzoGRNKoI6SlpDo
	Rutx5ukvoIZPicwVZjcNmb7auQurVTY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77E3F3543;
	Wed, 15 Apr 2026 08:50:33 -0700 (PDT)
Received: from [10.57.61.135] (unknown [10.57.61.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AC703F7B4;
	Wed, 15 Apr 2026 08:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776268239; bh=KOMJEclslTGko0CKo3zJ9nnmBRPTykeI0IPan0usj1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hR3+dovgqaAoCeD7Tj26ImE/aKDrkOG7n2ey9QHxI3X9difSYSy69sYtkr08iAEHk
	 fyQlQqCCEJG3ZsAktdUrlv/o6tLioBkfsevEDHaXxc5Hh//9nV+0z8WKgSU1JBm0v0
	 6SAa+zLxImrdvyYlNd1yAhbhoIUq82FWMkSjwMhM=
Message-ID: <fea9c939-f955-4020-bed6-427e592f0024@arm.com>
Date: Wed, 15 Apr 2026 17:50:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <eaca640b-5006-489b-8b2d-148a3c4073da@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <eaca640b-5006-489b-8b2d-148a3c4073da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4962CA0008
X-Stat-Signature: 53asdfoifhawrs6ejmxoyazhchwid3fy
X-Rspam-User: 
X-HE-Tag: 1776268240-36439
X-HE-Meta: U2FsdGVkX1/eBip7u57K/zF87CZv3qrJrl6otdh67JaidfDJp8BIXuPySV97903XXPt3YKM9zH53r1OgiGjbp4fM+86lk1fKDEK679pLOwum8OJ6vK52EZf/xBnhQ8E0cdIwbJ7dLgYpHjs56PQscYhL7KkT2tWuzePp7mOTYXzY6iu678s5id5UtEkHRzvHT4HexDtLxlevq+wpuRUCOO6CrXDwQbcHwj3vHcAR68jqYcaj6RyOcmvcPHYXTU3ugXmrCQoAENOr5OlKkIQCxZE8Upxz0iIWDYk1WvtBiSBJ4S0tW1DINpDi0WZxknkXlPzGDoeIh3cbC1E6GvMGYb76gM6lyuMQf6U+yU1zEpyyEV1e+vCcX/BB/V9OrkGcY9WQWcXec4bjdqqhy8QBNxLju5G/GFcIkUzECEWLnzWph48V3SKZfRxr6pL1DqSJXvJlMo/AAtAc7w9FLMgfVrztFEu9HPfw5us7aiL6pddgSyqJDGH2sth75rFJhTrEASrISPfAvokvSorLi8s2HvoTS6d63jUtaYJg+GfI8L9xp8ZS8m+V6urWKIwoShMeqU7sraLnR5bEP3+3eHU+kt0OX3NCynj2rsNjQP4WuGRDBTETQEwbzAYz7RKQdfbym7k/JAvkZkcxHCLoWNERp6GHWY8e0CaXggQtR7Bs+31qSQUV+wsnHYHXdq1Xx2PzQ2c6AnY3gz7aCyjAFKpxyv/oCN56EVDmccO5GHwo8KswJ53peiGKH+NjmoGw0lLXUp7j6P5a3rFNtf0kpeCnXxHnUenAYkURXlhXngtNxPgjWfPGO/Alncfiz/3RhmIBanYNnv188m8WTj6lIYBQ84nzYeJYuuWOUsJuPR0PppbpZ5KOf/eVhyeXaCj0Jfoa8FOFOxjN5+h8Cyaosgrb7xBYg0CzMJXLtHSEA/gvWu9r14MLC5DNTyTcIJwjfS6Sg4vj8USdbE2mX9TF3ZY
 LreeuFu1
 TjRO/E8+xjP4KO6uBeNiW3IZjkZC/ywDm/rAe6WEO+PXotm6KkVntWb5qygqNTjyZHNteOLsKoREheJBpjwVfJVmp5VLoKvfMQ+ywTyXFMerhPCT+F3J4Mx7aA/oC3TwZ4O7NsIukuTQaVSi984sk4dpBFIlEdB1gJcXHQI9/1gk8ajePAvhKT7DUe9DPaLsBSNT1X74rfvMUKtf5wtR2bhDu0CednEBiGNoHI3+4WB/FDmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/04/2026 15:00, David Hildenbrand (Arm) wrote:
> On 2/27/26 18:54, Kevin Brodsky wrote:
>> kpkeys is a simple framework to enable the use of protection keys
>> (pkeys) to harden the kernel itself. This patch introduces the basic
>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>> the pkey register and macros to define guard objects.
>>
>> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
>> Each level is associated to a set of permissions for the pkeys
>> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
>> permissions according to lvl, and returns the original pkey
>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
>> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
>> this is the only available pkey for now).
>>
>> Because each architecture implementing pkeys uses a different
>> representation for the pkey register, and may reserve certain pkeys
>> for specific uses, support for kpkeys must be explicitly indicated
>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>> <asm/kpkeys.h>, in addition to the macros provided in
>> <asm-generic/kpkeys.h>:
> I don't quite understand the reason for using levels. Levels sounds like
> it would all be in some ordered fashion, where higher levels have access
> to lower levels.

That was originally the idea indeed, but in practice I don't expect
levels to have a strict ordering, as it's not practical for composing
features.

> Think of that as a key that can unlock all "lower" locks, not just a
> single lock.
>
> Then, the question is about the ordering once we introduce new
> keys/locks. With two, it obviously doesn't matter :)
>
> So naturally I wonder whether levels is really the right abstraction
> here, and why we are not simply using "distinct" keys, like
>
> KPKEY_DEFAULT
> KPKEY_PGTABLE
> KPKEY_SUPER_SECRET1
> KPKEY_SUPER_SECRET2
>
> Is it because you want KPKEY_PGTABLE also be able to write to KPKEY_DEFAULT?

Right, and in general a given level may be able to write to any number
of pkeys. That's why I don't want to conflate pkeys and levels. Agreed
that "level" might not be the clearest term though, since there's no
strict ordering.

> But how would you handle KPKEY_SUPER_SECRET1 and KPKEY_SUPER_SECRET2 then?

Presumably those would also have access to KPKEY_DEFAULT. However, if
you consider the reverse situation where the level is less privileged
than the default (say an eBPF program), then write access to
KPKEY_DEFAULT would not be granted.

Also worth noting on the notion of level that POE2 will bring further
per-level restrictions, besides which pkeys can be accessed. For
instance, we could prevent an unprivileged level from executing certain
instructions. This isn't in scope for this series, but this is a
consideration in the design of the kpkeys abstractions.

- Kevin

