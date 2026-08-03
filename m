Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB28C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F4B6B0096; Mon,  3 Aug 2026 10:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8D56B0098; Mon,  3 Aug 2026 10:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAB66B0099; Mon,  3 Aug 2026 10:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46C426B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:44:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C608C1A06C3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:44:25 +0000 (UTC)
X-FDA: 85060228890.02.29CFC6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11AD818000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:44:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obSbc5rm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785768264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SUYehOCR35MQolMkuC2vU/2PksZiE8FgZrQCvTUjUA=;
	b=QlLRUDc4mI2vq+nx6C/8mtggtLQnaJKL8vlQXeOOQyANJZ+4IX14un1nMk2dMg7CO7rWyH
	q+PIxOlDFuY//8UiJECfBt9I9CqOnUp6gLIQe5fn/FJ6zUXZC/GhStTlj2V3/VOze2UCd/
	1Qfrw7jkob9NpxW5UjIXyZQQecQnwRM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obSbc5rm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785768264;
	b=OhkJKNYFVe8AdcF5zKiHpHk0TLTaYN4sJUyj2Ck9oTcv4n6Sl9D5k8X7GF0xfwoybTF0lD
	KoMOTyx0gufGrEc/GcM8IKheGJ0PqaJmOpRBwXMUNa70pjEhHQCs7u4e1QT0RIb/Jr556K
	mbCOu6fNJt8y1w+vPKwM2bz7INvUp2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAF3F42E6A;
	Mon,  3 Aug 2026 14:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266BF1F00A3A;
	Mon,  3 Aug 2026 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785768262;
	bh=2SUYehOCR35MQolMkuC2vU/2PksZiE8FgZrQCvTUjUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=obSbc5rmSMshpAxPQHkZdfm/Uilr9a4TZbJqrNfsXs85jGXw8T6SoPDRSevaKT3bz
	 kR561dD5bwFhWH21PaxOsKHUEXx3lT+06NjTAcrOQP5pgEfHC/jnDHd0G5nO7vOKtl
	 yQxQLoWPeASNSUUB+gcQyAXa7GUO0PqtYqnQ8Stf2kdhz8tFIoH9WGxkiplXPf5oVs
	 kPxaL3RwmRPWHsa4MF7y1NTeULvApDZNqkAm8q3lp4cvmm8vMK3+TXl2RcvPwO/9oA
	 dhhM5SIcr1inX24cLkSI7UkZzo5xU0/zDocYyrf08EaoMfiTCIhJm2IiGMVHm/36OU
	 VjdYrPpVxALlg==
Date: Mon, 3 Aug 2026 15:44:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Aristeu Rozanski <aris@ruivo.org>
Subject: Re: [PATCH RFC] mm/gup: batch contiguous pages in follow_page_mask()
 and return them via a pages array
Message-ID: <anCn2Zol3HywR8Tk@lucifer>
References: <20260730035350.1fc95dd8@fangorn>
 <amyUQahYOgov0z8c@lucifer>
 <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
 <am2_dWJKZBzwd8EK@lucifer>
 <517bf6a8072a6e66f28f8ec08bec4b604f29491d.camel@surriel.com>
 <f31c2c50-2239-4fd2-be3d-dd70c3d6140a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f31c2c50-2239-4fd2-be3d-dd70c3d6140a@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11AD818000C
X-Rspam-User: 
X-Stat-Signature: ubsqwd4ooym6b8inncz5a41rbtr3zxjh
X-HE-Tag: 1785768263-560074
X-HE-Meta: U2FsdGVkX18WwD7UUfiiAplnA6Ewt3VNb26YttownuTxmwnZNtI4YUCl8k7ZETOM4UffBiL+SyMraOnweDMxHZLLrPOfSdtzvFZtm0baGsVlxQV2l4VwuUbo2448sGARoNndvEuNCGPhs4sKCuKsma33ImH0+fiwrlM8ntXE5ehHIUW5XHh/6khScIVRcMdyeWlf8mjrjj/uJhsrXb37XqWshu032F675plX54Exeu9lyiYZr+QD0LKWcFAyQ4THeQb5/HrA+/N9drTuJU9JYt7vp80SrrCai79cx36T1mCBQpuZnn4BI/c9GjKm02LXMYzzvt5gb4MNdoQgg+pRNAEGxG0bKWuHleMUGPekQJy+1HNLpXc+qdQ9dsgoBnuz/Le/d0O9HAZpCIGSis+0qMkpm3LB/l65mChuwvPacJ1ympalgUDcC8SAd932YfKMV8nQB9VICc3moeGoeyEWVj5GN6a/BLD3RYc5wgTlmUTswX6LQG4T9HVH0/x1aSSWj9UsJi0NZSAmpKEpREZOFDbgaXBv/8GM2M6dsaetncUXiYopbjeSQbDSwhgfdG4oEcqy0pOgbL7115vGvHBaWDCCyrOACqkd40ygXAZsC5VYgzd0ZA01eNgqjDFm3wbpFN//IZ8WwqgHMxBnJZBEM9DSMnbdVhGBJ0Usv0xs/uQuBw8k/iwjGCk6iC2cnnWs9fS/aUeosbIlkdDbtADCVZ4f48/kwKwdnZEFm8/ZEqdSls1MT+I05FSa3D4PKLslMNlOs3pnQu7Hr7tQyfZFgrlsWYmNg70qN03MhmnOEB3/RJ0xAD1/ZMwYJ+SL5KU52imaNi/r2aBxa1qameFKFiEHxM21JHjwE3DKrxsCbUeF2l2pMqBcM2frxFCdKgVMlFDqlm1Dqewmn2/99/FDbqxaEEkmUIy8OkMOUYutOp3+xLfZTU8UIph4rkwtr7EBu1o5JISD7I3CN3nPk4W
 IeVsZPkK
 5/OSkcvpMINUiOgVwraX4c9Chk7K7nVqJOC9O7aoiHZWbJwFtmcMN3hUWtbmHW0loyfKnNjVjo6v9XFKWeTYqyWhqr2DkjBt6z0S2Mld8+UjPZz9kyrBYrkQNEuwxHLKiMTMYXVnXUrRi5u2/jViSD4VRFn4OEABlYOQlGtArulITyQC3z1D9eoYZ1Vgpzhtl+lEE7OcDJt3LSidkf5dTaJIrR6PsQwC/yAfnYsyU82Ymb1eFXBuGTpY/UysFykMU/dpisJ5Dqtqec38T4gQucVdUYF6VVG/3pJWBrBkbj2tdGbsZpQPNB5RKEjUZOziZxRr0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 02:33:35PM +0200, David Hildenbrand (Arm) wrote:
> On 8/1/26 14:25, Rik van Riel wrote:
> > On Sat, 2026-08-01 at 10:54 +0100, Lorenzo Stoakes (ARM) wrote:
> >>
> >> Thanks for doing a human pass but it LLM's habits really carried
> >> through
> >> here. In general:
> >>
> >> - No walls of text please - fewer words are better, clarity is king.
> >>
> >> - Don't write the code in English as a comment/commit msg - redudant
> >> and
> >>   distracting.
> >>
> >> - Sensible patch separation obviously please.
> >>
> >> - Write as elegant/reasonable code as possible. If the code you touch
> >> was
> >>   some horrible mega-function, take the time to refactor it. Pay down
> >>   technical debt.
> >>
> >> These are all things LLMs are extremely bad at (even fable). So they
> >> need
> >> to be done by a human.
> >
> > LLMs can apply those rules, when expressed in a way
> > that they get interpreted unambiguously by the LLM.
> >
> > I'm slowly building up a collection of such rules
> > in the kernel-style repository.
> >
> > AI can write in any style you ask it to.
> >
> > /*
> >  * Long in the Halls of Rq the weary wait,
> >  * till __schedule, herald of the turning years,
> >  * calls forth the next to walk the road of fate
> >  * as prev fades west.
> >  */
> >
> > AI can also flag such issues, once it knows to
> > look for them.
>
> Just the important note that people can use LLMs to make themselves
> more efficient (if they think so), but not by delegating the hard work
> of sifting through slop (code and/or comments) to the poor souls that have
> to review it.
>
> LLM exercises should be done behind closed curtains without us noticing.
>
> >
> >>
> >>>
> >>> In order for them to produce code that is at least a
> >>> good starting point for editing, they need to follow
> >>> rules.
> >>>
> >>> Once you apply the rules, Opus and Sonnet do not
> >>> produce results that are all that different from
> >>> each other.
> >>>
> >>> I just added a few new rules, so the tooling won't
> >>> even let me create too-large patches any more.
> >>
> >> I mean, sure, but what's needed here is human Rik :)
> >
> > The 80/20 rule comes into play here.
> >
> > If AI produces junk, the person starting with
> > LLM-produced code can spend days cleaning it
> > up, without getting things in a reasonable state.
>
> Right. But what happens instead is that people think it's okay to not do
> that work and instead workslop us.
>
> That is simply not acceptable, and we'll have to start ignoring people
> where this is a recurring theme. We simply don't have the time to do other
> peoples work.

Yes exactly, this is the problem and this patch was a prime example of it.

The theme here is 'please don't add to the impossible review load' or you will
receive a >/dev/null resolution to the problem :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

