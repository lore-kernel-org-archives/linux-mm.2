Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E333ACDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 17:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528516B0005; Mon, 22 Jun 2026 13:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9716B008A; Mon, 22 Jun 2026 13:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4157B6B008C; Mon, 22 Jun 2026 13:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 161BD6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:13:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5831C1A021C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:13:27 +0000 (UTC)
X-FDA: 84908194854.14.38164FC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3EE4020005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:13:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cB1cmzMz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782148405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhF+Z7QvSyF8SFiHgEa+zx62DspglqwUqFsjrg9vB+A=;
	b=yLB0oywL9an8bqgEbCkvsTm1d8nMug9bn5oRbW17pvmEqDYpwR8dxs5IWvZgigfQC8OvIr
	lb3hxqTfBHj3JbOTEAadn9YiQgQL4jAjZQ4vf1CV+dItchi/2n7J5g/Zd7ikAMWoSscqNk
	opmKZcaw68CMb4noSSTNp5U3ToBAWGs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782148405;
	b=HiE3tqm4Rl+mpPiMA1NqqDZdJb6DkIohaL6wXLnh5JcjksC4ImNDd61aX63rMDChD46TzJ
	64ZZOtigA9vAYyAzxDVBxjnfffHGZzZYoTiANubq8iO76xFc0nDQtDHxRx2R9lvH12q70D
	1hS2rtqDcOC+LVyCYtUFE1Q0wCmmAwQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cB1cmzMz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F0191A00;
	Mon, 22 Jun 2026 10:13:19 -0700 (PDT)
Received: from arm.com (RQ4T19M611-7.cambridge.arm.com [10.1.32.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EAF23F62B;
	Mon, 22 Jun 2026 10:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782148403; bh=RnwiQypkRLn7P8qYZseBV6Ihj32aR3RId+p6z4H6xw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cB1cmzMzT+YCCg7NorZIa+KSxvTRYpIbv/SMaoP0VaMTLqKhCnwscEnPUCC+jZb+/
	 gaRLYTCzh177urdLiaRvwUNvASV/HdLMAMWqfK5gWm4lR38lQmrPWtcwc4xEt/s8Y+
	 xzl5xklVxQ8HOQlcmaoggGEB00Xm26zmkx0NmFW4=
Date: Mon, 22 Jun 2026 18:13:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Harry Yoo <harry@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kaleshsingh@google.com,
	21cnbao@gmail.com, david@kernel.org, will@kernel.org
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <ajltLd6FQg1aMge_@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <ajVByfkLbetzA8bB@arm.com>
 <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: q8eimhibx6ss4rnx8wywjt1yey9mnn1f
X-Rspamd-Queue-Id: 3EE4020005
X-Rspam-User: 
X-HE-Tag: 1782148405-588011
X-HE-Meta: U2FsdGVkX1/7/83p7gQwCLy1gObkXOYCf3BZhfbjyUZ39PdfhaW91YHalpAMKYizLUEFgM8/dSMo6w/77R5U6YQLUp/LHVYi9eQlU36y8FoC1lqKKOmFkbp7x1oBZW4X5HJzzdjda/9j6LEvRCWPKu0agaYukGBV1mIqUWoGJKzkWQCx9MdmuEs3gFpmBUVLij/lNShTzPTb0QqcOpQ1BYbZBXtrnQzzE4VIs3AwcSL+RrRtKgDgoyfPDGny/0j3UYZcSn41c+Nxt4O2gzqgx7qPYSYGELqlj1NSR2mMUoB/VEzjBhRTu3TiBUogFxGxUsKPVbqGwbZ/ev4Yem+HuuZ61YISKqhT2Phc7R2R8eNX1gn13jg4cI4qP+JeNEN/s4+OHLNaWL7d+oVOuiN+PwdfKkhguNwL24FUjqZGLsaXDXAwQ0wuEwMd4lORxBDEpbgFEZ8LJ+kohRZRyDPklCzn2d/Pn7bgBUtTn5oD03seiJv3RZ+CmK7tCXNNYJmMQhEWT9z4tkywfqsitGApVOnpbeaa8B+yTYS+WsY1wITYdO70giEPsy1rQwKA81hi5w0VgFhpqkk/QKKZgZCFoa24AvMut1uiAyy6b7nuN6C7Httk6hKcFEFV3rXA1QdW6ymJ93UWQJmxPPC5zf9M+sk8mDlAyZ94+XAU1F7H31gJTlJM5iab5lzasRfVUhmC7wktqLa/SjTnYY/g6rlxymYUA5WVG16FekBYrjiJ91ftF464bqOzlRrLCNAGWfC8P9StIEtBkw6VxG1oDCxb6wQQr2Ahx5/hAuZcrU3A33LN0BSr9rtQ2MUqUAk7ZCYZcakk4XY91x/CiaPlvMx5miVetTKlLu232cP3CMbdReMKu28jNPoZ1uo/RZkwFZoMgyvbD9+sdZxWlveuES3RDqZ3Isk+7wVzeFelOTzAVWeGcHYklUcRVoRlgMBcRwW1eovwUL/UR7p5YOCx2P5
 aCyfkR8X
 3oHxa6J/b8OXwkLYpRYDkhS5ppggLwu77VgcwJZhjlWSwGOt1qBejdDJX/+KswNyTiDlSrkhDHAm5cRLcbo+w7G2yH/bLp0Ya5hhDZv0KIIx1BtRfX9JqeHRy0nuUZmqiiTd6QFi8FeonO5VExnUNbrxZf6tqa1AYLeR0eO3E7VfjPh8A68LIYakcix2DhdMLc3tD/bvttTZpp+OEL1V+oxZKiLvpgDFamA1tlmlDZOvKYe4dw6X5Sqh3ODhnkjWko8+861s+HbWsyYaG4xPovLaYN3KN6sVoEVz+n1kmMPK1DmAkpio7AqNAI5VJ8Olh0t4TBH3obGAtFd2I2PW8aev0sp+T4rW3lKh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Mon, Jun 22, 2026 at 09:42:10PM +0900, Harry Yoo wrote:
> On 6/19/26 10:19 PM, Catalin Marinas wrote:
> > On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
> >> On 6/12/26 1:44 PM, Dev Jain wrote:
> >>> Now, when a memory object will be freed, it will retain the random tag it
> >>> had at allocation time. This compromises on catching UAF bugs, till the
> >>> time the object is not reallocated, at which point it will have a new
> >>> random tag.
> >>>
> >>> Hence, not catching "use-after-free-before-reallocation" and not catching
> >>> "double-free" will be the compromise for reduced KASAN overhead.
> >>
> >> I doubt users who care about security enough to enable HW_TAGS KASAN
> >> are willing to compromise on security just to save a few instructions
> >> to store tags in the free path.
> >>
> >> To me, it looks like too much of a compromise on security for little
> >> performance gain.
> > 
> > I don't think there's much compromise on security for use-after-free.
> 
> I think it depends... OH, WAIT! I see what you mean.
> 
> You mean use-after-free before reallocation does not lead to much
> compromise on security because objects are initialized after allocation?
> 
> You're probably right.
> 
> Hmm, but stores to e.g.) free pointer, fields initialized by
> constructor or accessed by SLAB_TYPESAFE_BY_RCU semantics after free
> will be undiscovered if they happen before reallocation.

Even with SLAB_TYPESAFE_BY_RCU, the object isn't tagged on free either
(or realloc, only if the actual slab page ends up freed). But we don't
get type confusion for such slab.

However, without tagging on free, one could argue that it reduces
security for cases where the page is re-allocated as untagged - e.g. all
user pages mapped without PROT_MTE. Currently we have a deterministic
tag check fault if the page is coloured as KASAN_TAG_INVALID. I think
for this patch, it might be better to only do such skip on free in
kasan_poison_slab() rather than kasan_poison(). Freed pages would then
be tagged.

An alternative would be tagging on free only with a new tag and skipping
it on re-alloc. But we'd need to track when it's a completely new
allocation or a reused object (I haven't looked I'm pretty sure it's
doable).

-- 
Catalin

