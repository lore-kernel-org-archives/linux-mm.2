Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCF2C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F606B0100; Tue,  4 Aug 2026 12:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00056B0101; Tue,  4 Aug 2026 12:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF796B0103; Tue,  4 Aug 2026 12:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82B866B0100
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:47:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0F33C0244
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:47:37 +0000 (UTC)
X-FDA: 85064168154.12.84B23B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3030A80010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:47:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAAuqSzD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785862056;
	b=7Xhl3SGPYE3G0tSzyof7/Fb1R9P3HSmaqvDKT8XJQc/tN4JwkxtcoSYbahUNWqSMCnx8bb
	cE/Rm1OnSR1l2kk7xLOJYcBlUC4+sjybCE+zn7z6B2T0EGMWePt+scXllwFn1Bv+y+D0e8
	u4LGy0cMKSV0qBZOyiMsyWbO+eLNNWQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAAuqSzD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785862056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/m4yAZ5mIsOFZEiU4veHFKr2AoqsHnJrC8u0FSLN/U8=;
	b=xo50Gi0+3TDJ1RSeRWR74EIdxZ/4HnPGuUs0B0PMk7cMCV+il0MkXhcLZt2JGr/HwJOZb8
	V4cJykkQnfjxTEi1L1dDvRWtCbFEvOnhmncjoe+UGOBvnfsbPKudFoDx8sVA7KpAglXuMp
	OhdmciRwIhrv1SXqTfhtsH5ydWFMWYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E004643D11;
	Tue,  4 Aug 2026 16:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8661F000E9;
	Tue,  4 Aug 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785862054;
	bh=/m4yAZ5mIsOFZEiU4veHFKr2AoqsHnJrC8u0FSLN/U8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KAAuqSzDp0wplUBF9Fq0YxQTEF733hGX4xj4Y90DI8bZ9hL6VeW908wQGHnfPdsZu
	 rrCzEKEjeah6szU+pl4/gkNRp/qVwmNa+ywme1I4lHz2SuIjJP5BWpFfGVgNYA9Eo4
	 v9vjxuwD+2Hyaigth9wcOM+k8DBaj/CIgX7XW4LMIS9cw03FKnhczraAQ7g2I/cQrE
	 bbnOGQeUiAJAqPJElj7deWCtVPBmTP81tXGPOIZaY1hjfVOreivQ/k5PuK/I13vFzF
	 CRX3ouvSBJ635W/6cspzFiRlHWV0BzyJiBOZs8jir0u29LyxpLKQHNzprXKiaDAND6
	 Np0mwa4lS6oug==
Message-ID: <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
Date: Tue, 4 Aug 2026 18:47:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3030A80010
X-Stat-Signature: i5ar8seg7xrautuupmxhj8xew3u5edpb
X-Rspam-User: 
X-HE-Tag: 1785862056-416990
X-HE-Meta: U2FsdGVkX18dD/ixwo6ejiNSoPN24lkIKbLjQmf928Oc9a93n42+EjXOlPf0lZXvxjDpJGOYumOTHuK4ClupI3ylHZTri6U86xUY7NvCaj116WRPOyHJviq031D9xQOxvgBOUEobWxUWy/QCVmMruAtSuskHklZd8WrE8JPzFWTZ295vpIibxReuBS+B6vf5Y+XkE0O/nrPCnD6iKSUr5wS6avJo6Y/GtzuwJ+OpSJ7vR9BTm0Ju1TS0x6PviqemjRmN+2R0ZH8pkAowTF4OGzPCQ67JFu0tEvi22owEQG23WHut9NWvnPctZ4W+gw/oAAffUq32xTLC7WqmfXfkPyrSx6KVw6dje68+EjhRZinV/F2FAd/jzqRCzebz8HN/zySoq4d9BfqzDverBnXHa+eiJPzIyB454zaLhR5OjVQJoU5XOsT7MB13IGwgxsh7dy6csa8GARcBfyrF+szngav4Stx+lSPLsVBBdePsSKF+bf6bDRUQyNxzcUilWcgaEGFChJtfEQCXK/lQS8KHiY2QqAv/4PEfOPhe7zikW3mdJrZyql00i1Zi1JA53ztknHB0N7mYbg1h2+TZEDiyincv6WLRE0SvSL+BmAACloONgddlK9BWuejcBBFYE5SmGdQH004cZaRtSykO+ySiFLdz+yk3GeWQJwBZUdmpB2CwaxgSSZxAhC0FJWoWxzqEXsb5vbvjtwLUQqYYpw3D/UHOEffAJj0Rav+iyavYmLz9o7LfRYCgZaBILR5t+kybLnrM1GbSLoBnuZ9i1PiVX9+9I5d0wXgkOi3VJT5NiYSx/TpwhnubkTcPqfagLH5+7LgW4Tgu+dpuVszK000s+NlGhHK4SeMYkUVjydlkSMN4QBLrfuZC4DXyNv3S7aF1g28cs1DJR2iXF0gsds4ALCfWAApsBGDBZU9Gu1NgXOZfWz+h5IOWb7VyfhOcNwqbEnyjarwiEA6DDG6YQDH
 2wnzjDws
 bAL0VYYQx1Osf4QDrHfpZ0tFgSkxCjplXOZKlQXwnlDhzIWhMshgO5hL7TlH/Tgnk2pnpM5aFtEc2gIAiS3MBO8ruxQEbp3vg+rrBqHz9XjJffr6U93bOWhbYD6lawyzPVyBSo18HTAHdtm2HgSIm1cJ45AXv6OIPUhXW8B10atEvngDVDq+K+JpM39WJ7XPlvhRZpJE5ZTCPOgqmzK9qPbtw0X4qFR1U8bPAj2ZQ1N28h6OvzCNHJGMPALLGbkdBqIgZjMPAv6LpMiRJ6aGeg2sJGHtYgfka/0GfHuCukbIYxZf3M4DXM99nM+82S1d4dNubJCadT2oB+4txOyNUaxjFMnSxJfVYietC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 18:19, Christoph Lameter (Ampere) wrote:
> On Tue, 4 Aug 2026, Lorenzo Stoakes (ARM) wrote:
> 
>> Since this work seems to be very much arm64-focused, perhaps it's therefore
>> worth looking at an alterative solution that's specific to the arch, like the
>> one suggested by Mark ([1])?
>>
>> [0]:https://lore.kernel.org/all/CAHk-=wire3dzhHx=KiL_f5Rj0=1u9ustsa33QoR-F9-v-NU9Ng@mail.gmail.com/
>> [1]:https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/
> 
> Mark's solution does replace the preempt_enable/disable sections with a
> rather hacky restart logic. It relies on a long preemable and postscript
> to each per cpu operations.

Okay, so 3 simple instructions of preemable is "long preemable"? In which universe?

But I am sure you did you homework and have data to back up your claims. Please
share that data, because I am very curious.

> 
>  It does not remove the code entirely like the proposed patchset here and
> cannot produce the same compact code as x86.

Mark's solution is the obvious improvement to the problem, doing it just like
s390 already does.

If the proposed solution has a significant benefit over Mark's solution it could
be discussed as a next step; and it must be backed with sufficient data to
warrant all this complexity here.

-- 
Cheers,

David

