Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBB3CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12A36B0005; Tue, 26 May 2026 04:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA846B0088; Tue, 26 May 2026 04:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFF76B008A; Tue, 26 May 2026 04:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2D036B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:33:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6923A402BA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:33:16 +0000 (UTC)
X-FDA: 84808906392.01.CACFF1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C131C120011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:33:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvCNSSAj;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779784394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWy7Rcx3R6qFnZjyKosdkRehi5dLXhtgyFC+BQ3px5s=;
	b=t28HKJ5xMF3zYELZl0B++SnpjxauueZ0K9Ef4EfL/KKrTvYKKZ3wV0ay3v7WJYioFKQPMA
	jkri//gGWycQ8FL6Fv+TLX5nxH2rEoyNbNK9Cns1Ix/eQy5MIsDcpuSHRqzMebCP/6fAyp
	FXpCosT8wP/yobl4cPsxilL2nouus0o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvCNSSAj;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779784394; a=rsa-sha256;
	cv=none;
	b=kVwROD4KoT9j+8iqT19F0MLWmNQtAxQqC4e+4OjMsvkLH3XZ47WS9dz62xsh5DmKKoPkvD
	ncMkdUdHAAQbXyJixdjt+gKG2B9a37FLWG/PkEy/VF7kMJetLxvGMcjkouPw3yLQGfiizB
	yQRYbhGUig5F4GScFAM5U6D4BbF4vUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 506C260018;
	Tue, 26 May 2026 08:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA341F000E9;
	Tue, 26 May 2026 08:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779784394;
	bh=ZWy7Rcx3R6qFnZjyKosdkRehi5dLXhtgyFC+BQ3px5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MvCNSSAjNnejUmuowmyUxMavGD2jehxjtu8HsCUYPWbPYQQ0jGYC6w3Fe0q6QmtIn
	 hx82APj7LuOp8MQndXODZIoWX++RnqsZwSelVaiOJAUkeyw+yVMxPe2c5vwnWucCHS
	 S2+FjRy5fPOeAiw2mlr91ibRcQBcdFtZyyVtrW1xmbxYiT3VdRcIRoOw26PdNPlpD7
	 17PoI2AGkQs5tOFNBpTpTa4shuQNX/dv0dx9zYypquxBMV32lYEw+wTinRyDjDciXo
	 Ohj/LuACLqvF1M7Tu8pabf4u1KwmfTeFrsM6NaudxSyHbMSquNmCQ8dgzofT89I6xF
	 k7oSumqIy3LXg==
Date: Tue, 26 May 2026 09:33:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged:
 add mTHP) collapse support
Message-ID: <ahVX1iq_-95vd0PN@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
X-Stat-Signature: d6nqi3p1gpnk1r7s3dkmigihqszry1gh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C131C120011
X-HE-Tag: 1779784394-862687
X-HE-Meta: U2FsdGVkX19AFLRy/J9fCK7GnKB9r0PGKMxuAIskVHpRY4T3P8e4brLZMUBhNb3BzN03b/9z6zIMiF4YNvrH+c272HMBq6t00D8oakslUYjyQc9uZWwqz3a+OMr988WGPo4Uv7M53JB74QjevwJ6dE0uDemThO3N4ORRsQdjZjQLyiMF6cmumRzaYui2K2kw8WWUs3aNKAT8vGeU9E5ZpEaD4nnvDWumnjEmo5RRpTC3x86puJJ2DncjU9f63++5tRURQ/QTNrxXOg2ZaPTkOekWllMp2Dc9vpOEVqCmdyw1sw+OtP/8c7tgYJwZ9EwnhgjdRcL4M6cW6rmodTaIBhkSp22Yyl5Kd1btLx5AHkxfIrux0q+9GiziKsQv+cXCB5STfAHjtuRN0/zMgQh/NIcV+ULAM7oNQyh0fpezMZPfLWE7e2bbJTbW1FPe+FUpkmA/VHHNs1inJot8WHnJGJcGYQSSbC8t68Foyon1/VlJjh8AsS2meGKOdMbdZsNwbRyJTA6iA9HkEfGUGWW02mgrcrDhZm6X9wFiwh8kN9rhMZojukgh4n6uQJM8Vyyps0AfHmZ68U13NqQ7Nw3kzf0nj+0H0GP+CT/iMBQUARPT7YmfMVQmRada5qY6BpbcD8LaP/C3KCQONmiedTkLSu1Izp1UX0yKmYwVfjV+VxNrbzU8WbJ3o81bZqRbAMRS1Iv7HaT8cSrN9UjhFKYHRTFf9twOZHVPl+uELcLtWwacZ/FltjQAFHXz7Y2IM19crMYiXu79gq6d+y1i2eILexZrb1hCmw9SL4IMZ5ggr8/CW7bAQORKm1PKQLpS0uCLLqRJFl8t9q2fp+4VSVBj7Sn1GbEL0RmKHz08opQo4DM33GTwm+EKwmw4aocYixUtejtNjVsF2S6yOA22ZMMvc4G8q067yylXB8Qt5pWMmnNHmkjryd1BG7jh5Q6I7tRg6Jycx27x7Cbogd6ZBR0
 ZEv2JUuG
 CritLQY7iCCaJAt+qEmCec9+ZRUl8Eyr9REOgKVxwYrBTDEAIyaLnDr59Hngc2/J7LnMdo81T239U0b+rMaz4GwW/v/QZo/blnSvSABq+Gd8INt9e/AyLtch2o6P8GHu3QncYimpPhMX39iqOfLgLXF/Jm3NDpKcpH4jWprMbBof8Wd9TKf3Q9aWBzNbN7hvaR7h10t1LNfN1g3IFQB23QjGVC/a+ZwBzFSKxEPCq8aoHpdzgpCCRFApd5FMd4PODZv0FuUoTSHU044AMWrzsnFcFFTzuLiHT6tYjqkDWq6j4Wbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[trimmed cc list to avoid noise, apologies if I excluded anybody who is
interested in this!]

On Fri, May 22, 2026 at 11:13:42PM +0200, David Hildenbrand (Arm) wrote:
> On 5/22/26 18:11, Nico Pache wrote:
> > On Fri, May 22, 2026 at 9:13 AM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >>
> >> On 5/22/26 17:07, Nico Pache wrote:
> >>>
> >>> Whoops I manually changed the coverletter subject to reflect that this
> >>> in on mm-hotfixes-unstable but never updated the others...
> >>
> >> But why? That branch is for hotfixes that would go to the current 7.1-rcX
> >> series. mm-unstable would be the correct one for this, AFAICT.
> >
> > Sorry this was a misunderstanding. The goal here was to base this off
> > the closest base commit behind where my v17 already lies in the tree.
>
> Ah, I guess this is a problem of "v17 is already in mm-unstable, so against what
> to base v18".
>
> Yeah, we touched on that problem in the LSF/MM process discussion ...

I may be misremembering but... :) [correct me if wrong]:

Wasn't the general conclusion that we maintain a stable branch (Linus's tree +
stuff that's been reviewed and is locked in for next release), and have people
base work against that?

This would be 'source of truth' and what we eventually send to Linus.

In that world, the maintainers perform conflict resolution, but with git rerere
we need only do this once.

We'd have mm-new which would contain everything for testing.

SO my question is - would we even need an mm-unstable in that world?

What role would it perform? Surely we'd want the stable branch going to
linux-next, so it's not that, it's not quite initial testing either as
mm-new would perform that duty.

It would potentially make life a bit easier for somebody doing a new series
to avoid merge conflicts, but that could then make life harder because
there'd be an implicit dependency of their series on what's-in-mm-unstable?

If everything's based on the stable branch, things are surely clearer?

Curious what people think here.

(I also wonder if we could have branches for versions of series so we could
do some kind of an easy diff between versions but maybe that'd create too
much noise :)

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

