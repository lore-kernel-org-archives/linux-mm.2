Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F74CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 20:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0366B0005; Tue, 26 May 2026 16:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891386B008A; Tue, 26 May 2026 16:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7B56B008C; Tue, 26 May 2026 16:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAD06B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:42:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0B8D1A0496
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:42:58 +0000 (UTC)
X-FDA: 84810745236.24.F58615A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 427EA80003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:42:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnXxdYbX;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779828177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZTfBW5rlTZhzaZxm2PfPqMuSXVFckoZNwKbaeAtQ+4=;
	b=yTPs21jgSJuHlqQN1OWAfKoUQ964njoCNPuMggSxIOamZ4fg1MHCyb0fqJoqjIRMFaWhCK
	rmHy09T9hLSu6MUouaixyR1RkEhBXdyxb5/D6F59w3fANtK2dJI5PlgTynDZCo080+DJhM
	Lv3XxR9FhX6NCt81Xwyl+AsWrJdZ8WQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnXxdYbX;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779828177; a=rsa-sha256;
	cv=none;
	b=mO5v+7UieYEnxSrUk83/lx7OavcyMw64WShABfb9wnBJ2ym5t19MExYvFphAy7k7qoa1KU
	g/OlQ4JQ1fUWiDu8yW6vBIkwfy4QJqCQe8Riou5s6MwReXv2syB92NF5MobpXOF4mxEG51
	XaMN7e9e5NmI8ijivxVjgSuBK9lIJp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A996600BB;
	Tue, 26 May 2026 20:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C822C1F000E9;
	Tue, 26 May 2026 20:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779828175;
	bh=3ZTfBW5rlTZhzaZxm2PfPqMuSXVFckoZNwKbaeAtQ+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fnXxdYbXA17KJFr9jPIl+w0Lv7scVnFoieez7XOGGJxN/N6u4vjo/+icH+YOznGLE
	 uRotfnHv3VLmFAjxBGgOuRJUAMMvke3WyGhYkonLb9Goj9I4ErOmi2APfi402ug3y6
	 Nws39GW0e1VO0vzVe0kGoi0FF+6/NsIiDHWmDmhh8RPcFAwucbjuFLN2Ecp1FfUxE6
	 dn//xaC9YbwhM+x6y0YauKjvmcxejsWkHR5WXaovLKCCnIoPwSiafIbUczC9FqgJDb
	 12T1ZeFKgRfiwlh6A8Dl65dF13Y5tKDOG143BR58tdyQ6lBBmAwABb0th3A/PsCOSN
	 G6fCnIrk1iu3A==
Message-ID: <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
Date: Tue, 26 May 2026 22:42:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ahVX1iq_-95vd0PN@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g7fwjz67nq7966i8xmd9914e6dusxrwe
X-Rspamd-Queue-Id: 427EA80003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779828177-261802
X-HE-Meta: U2FsdGVkX19ybY/5Vnvo3K3HugyhSXuRiTw8ehtMZZwoqh0WTBmosZzQGvlXA/2Adr203CJIKf/KohHZ+nlIeEknDcr6UvdUNN3T8B4kRoQ0ZEgML89GcR234i3LaJqQgpIhgVTKX7qbprl2mle7CEoqe3atj5DeqOSEUE66BEWnb3tk+mnPmqy3s3P7whDCRbonm37f4e4g+zcILjs3L0opaueCE/8cgk2hmHal5+6RoC8EUVJf+e8E+b5FRMjv9G/1V1UT23VXdWj/VLCiEjfmDQdXBeIjVbFyA65McZ15AqcGuhx6KiLFGGBpPQuFxKKXzN5TspzG7kqc/YJD3TppXpG2Myi3vXTFQNILHtonOA9wUODB9lHLeaVL0Sep/PyqgxzqV4ZRsCyLzMcREgdh2LO337IN6d9iaoLCSV0bwabJ8/u0SPy2D2YSX52FVeDZ44GLS0SnxARyLlCyNGWOAZ4rASTXkAnmA7zz4UmgGQXxfrI3BdxuZEatnyZYbiVnlaYpkBR0y4EfLVJX2Y9VKryShc8pf06VKequBKcBiowZF1NKbY51LFCE/cVX8D7KbWa9JTSjWnMUvnjftYsYbCJmdKCV9bO11eOvHOPUib5UprtaWO/I/SobjSdxYDVuOyS9LL0r3VMSuHdrPdO9iBndXpXaR9OYQJDXJGpdpqgD+5a01xjx8yILW3MM87yaLGX8TL8gTC+nzyQdJnASKKG8oUCbrGPY+QJh+gD+h+OX8cXfD5f1xDTlSEo6ClPAFjno1rq0tSvHGRlfTDKT2rvHEL5U5amQFkWn5BkPshhha5jElWc7VRMjCCY6rgRXCwJOq7a1Mrb694dycLoDGeI6gBtwb7aJ0iOsmL8MenQJtG6xjxElp8W4xZVKAhXfUry3kMr6kSCakvCGAZhEnoTZ1PQCgE/vKgWN7VUU+AdchwgWTuaR0KzozgofOuEGTUJEsTaSwS5UZlJ
 aMRPpBxl
 eGt7Aul74c2VkSr/jNkcx+dwm1ysAYTZTDuYJanLta/ixMVXseem+xY9p/YH1eAvWm1M28a4jr/E7fCjyDaw9qCRB019MTZlCPW6asBkbIK0tmkpLuMvT5KTMws6YOLows8uSY4gTSKKU34rMyXmpr2SZe/S+dbMey0FiTVf5FKXlI3USi5+OcaCjbVmP7secdAe+zNZGSbZKRBkBLcO6OKxfikcCgXoADAP+Se3v18m6RF9NV0gurd2o2pv3dYrPeX13G9Jksga5dlgnpEodeuAT2h2GGX5f0wlPup/h5VtJhLXbM/HD1cKLrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 10:33, Lorenzo Stoakes wrote:
> [trimmed cc list to avoid noise, apologies if I excluded anybody who is
> interested in this!]
> 
> On Fri, May 22, 2026 at 11:13:42PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/22/26 18:11, Nico Pache wrote:
>> > On Fri, May 22, 2026 at 9:13 AM Vlastimil Babka (SUSE)
>> > <vbabka@kernel.org> wrote:
>> >>
>> >> On 5/22/26 17:07, Nico Pache wrote:
>> >>>
>> >>> Whoops I manually changed the coverletter subject to reflect that this
>> >>> in on mm-hotfixes-unstable but never updated the others...
>> >>
>> >> But why? That branch is for hotfixes that would go to the current 7.1-rcX
>> >> series. mm-unstable would be the correct one for this, AFAICT.
>> >
>> > Sorry this was a misunderstanding. The goal here was to base this off
>> > the closest base commit behind where my v17 already lies in the tree.
>>
>> Ah, I guess this is a problem of "v17 is already in mm-unstable, so against what
>> to base v18".
>>
>> Yeah, we touched on that problem in the LSF/MM process discussion ...
> 
> I may be misremembering but... :) [correct me if wrong]:
> 
> Wasn't the general conclusion that we maintain a stable branch (Linus's tree +
> stuff that's been reviewed and is locked in for next release),

This I think basically yes.

> and have people
> base work against that?

This I'm not so sure how it would work. Assuming we have submaintainers with
their trees and branches, the final "stable branch" is merged from those.
But it's not a good base for work targeting the same merge window, as that
work would likely go to one of those submaintainer trees. But then it can't
be based on the result of merge of all submaintainer trees. That could only
work for patches targetting the next cycle (after the stable branch becomes
part of rc1).

So either patches can be based on rc1 and applied as topic branches in a
submaintainer tree and then merged, or if they really depend on something
already in a submaintainer tree, then based on the respective topic branch
that's part of it.

> This would be 'source of truth' and what we eventually send to Linus.

Yes.

> In that world, the maintainers perform conflict resolution, but with git rerere
> we need only do this once.

I think the conflicts would arise from merging the submaintainers' branches
to the mm-next tree, and if they get updated and the merges are recreated
(like linux-next works) git rerere avoids resolving the same conflicts again.

Hm like Andrew said, this needs a diagram indeed :)

> We'd have mm-new which would contain everything for testing.
> 
> SO my question is - would we even need an mm-unstable in that world?
> 
> What role would it perform? Surely we'd want the stable branch going to
> linux-next, so it's not that, it's not quite initial testing either as
> mm-new would perform that duty.
> 
> It would potentially make life a bit easier for somebody doing a new series
> to avoid merge conflicts, but that could then make life harder because
> there'd be an implicit dependency of their series on what's-in-mm-unstable?
> 
> If everything's based on the stable branch, things are surely clearer?
> 
> Curious what people think here.
> 
> (I also wonder if we could have branches for versions of series so we could
> do some kind of an easy diff between versions but maybe that'd create too
> much noise :)
> 
>>
>> --
>> Cheers,
>>
>> David
> 
> Thanks, Lorenzo


