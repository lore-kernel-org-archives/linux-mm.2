Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D00B109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BFB86B0092; Wed, 25 Mar 2026 11:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596B36B0093; Wed, 25 Mar 2026 11:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3F16B0095; Wed, 25 Mar 2026 11:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFD76B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:21:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB39613B8F2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:21:02 +0000 (UTC)
X-FDA: 84584948364.15.A167D1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49F9D140004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:21:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7Nmi5Ur;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J60nfALV8EvCaP60dpkenGqCSTlVRH7CiTn8A4+BOp8=;
	b=U7fNsI6190n70KSPg/1LtfXduxnpAs0DzBGV3AfxJi2KVciHKe7doHXzoMtpNBLveFro/v
	a/9ag50RlmlJ3tnQ3sSRrE3juXGYre80qAWSsZ7ff62Faxo6yvUQYK7rt4XZZIDw7iRSLR
	cm7bOB+9iKJtVhppSiuh37PVy+E5WXI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7Nmi5Ur;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452061; a=rsa-sha256;
	cv=none;
	b=ctH0HrHl0AC1KKuEJ0Rw6gLRAswVWddceqqqB4uLxuvJUkc+I/mMgG5cNXXlxCGUwWqYcy
	JBNudWacwhKzT0WIco2D5WCDNq6MmmbBuSzohBAfPSsE2PTtoRxY+Awf7fD2dOgwwMF1Sg
	VnAkVUshmb2QFEUts4cVrXx1HdhbFak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2E80600AC;
	Wed, 25 Mar 2026 15:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90231C4CEF7;
	Wed, 25 Mar 2026 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452060;
	bh=27h46b3j9DijQ/Ik+vVFMkoOTVwU8O9sVthj0b5oE18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c7Nmi5Urec3RhO+Ohugiu0N+6vBJK+jWCqGxt/tJoJ0blUCcXNu4tTQdAXfrkBvvT
	 Q0oPXSSMXvg6XBv0NARx2rD1ipNO9V6NmryU71RMOgTFXLh3rfRDDpflDw+71EVt7i
	 8vOH5Cf6yjqgx6XDHk0rY+G9r0HE6B4V4pSvpdS+LZwDXqyhMqHNSdOfWgcU6nF0xf
	 LvM1wlarL2BdtBVK1W7wfgw00PgG7RGwArkstORlDKSOi2It1UwZcLFNzpteU5+jiP
	 +wtHngzVUSEGDUwkwECknv4N6IqoTdEzQ8uvwdRGhtm46gJWHTW6GgBOQBuCKpBALV
	 wcKqbUq3hI7XA==
Date: Wed, 25 Mar 2026 15:20:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
References: <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49F9D140004
X-Stat-Signature: nxcwgyqa9drwyimsgsmsomwqmg8peiue
X-Rspam-User: 
X-HE-Tag: 1774452061-189151
X-HE-Meta: U2FsdGVkX19Lw0vE+xod9Q1wMJ+r36D/s9pcIgs1Dp9VpvP7wvYfGH9CRVfhvBwwBLitDZawvdSF4kKN28wsUVLkIRUf0Z/H1JkzDRVhJDtcajLEcMj/GucmsNxdQIzR0dZlaBVyUFMYXAzhI9utAJBj3UG912BSDSbbxJ56v2zIZLz/I//svl3vxy+Ltakl3xGCYukkDm9yT1P0Vmd+yPxvQAN7fkXnawl1oUa2s0W0UY0FJrwBvx34VJXOERHzNcWkatirbBkQmZvcNZjhF+u5aLu54/Txn9BbSOb2APsh50UyyDtExks7G8Ac4Tjwz4XSmNTstk6quia4hlL9apL+d0wrq9eZeN2ABhHpzB4CioxObyoXSPIpRzmjAlRMG33UnzW7x3MV7SvH7CWgUc/7/VNhpsl5Gv0eqeKGFeQn4P4OTR2gndfpdxlgRXQVPM8l1dyt14ybdEzcDbT6CDk8/k21MSapIn6kXv75LcgAhycx9y5gBT4oaXV3nG/HH5gB0mpgeOCsMkgkXaAHdv/YZnbujY25L37XYMJDULbiIiTGhM/OLfMnv0UVOg8fX5RK5KI7APj4U0FxAFtDKBvIod4De6PGMRRbgvwGyaWn93UWfdjY8cfA1VX8UIhCUqGZ/xTPquCAtixbb7SIybLoSOkARCdEhqrUzPkPLx9hDtiukndsB0/vYNJnTyJJ6zCZ69laJbPBUXa7iHDxDJ+UWyJ5T0TCwdNBeIo9hYCdplrhoyU1sfz/jx/kp6+64y+42ikXZLbj0rkTeBYYy3l3Y4WMefyrKGfck8L/k/j1J3/P37uYorvGM7xidDMujsLCKwsZPbE7bfDZUZBliufM7X4jTyhpyJfdgMJ+qw+OIqSKF1jI/qDep3T7foES4uKeLpwp6+1iLbI7OMGt3Xm3i5XZ9nwcb1ZmSQ1pmgY4rxcLxiIxkrnP5XPmWtkcqD7MSdCXafaw7PCS5g3
 x+fSggyp
 N7PYFYLDNPxEPbbswsdxaOzitdG01UQrgBlTwohu+0/gQf7xb8Q0ph0jr15/+/hXtfdCsF7+qdY7TLzjRFV/+3dyt0RZ0OtzX2VsHI2HJS8igNiZTyuFwq/CMbQHdDhMlmxwrneOPYXWbFmTZSBB2809GAWYZaZoIzJHdsPwTZncQv5mvs4/orOM8MyNU28YHfH79YlzBsMXhoC2hNV7CEUf78FbM/TnYzIBvgq0HJKHh9gJVrv1yXst1rn7fVu8gDoDtl3LGKsf9M16h26GKV0vDEQ2LDtBzJbH+ybBUSLParmypV75tx70c3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 04:17:21PM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 16:09, Andrew Morton wrote:
> > On Wed, 25 Mar 2026 14:10:23 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> >>> No need to update the patch description.
> >>
> >> I will take a look at this (sorry for delay) but general point - while
> >> fix-patches are convenient, they're incredibly anti-reviewer.
>
> +1, I could have sworn we brought that up before. :)
>
> >>
> >> I hope at some point in the future we can move away from that so you can look at
> >> a series on list and know that what's shown there is the actual patch.
> >
> > Oh.  I've never really received that message, at least not at all
> > clearly.
> >
> > I've been hoping that the -fix patches are actually pro-reviewer, for
> > those reviewers who have looked at the previous version.  A full resend
> > of something you've already looked at is quite annoying!
> >
> > I try to mitigate that by sending the
> > heres-what-you-changed-since-last-time replies.  It's a little more
> > work at this end, but that's not at all a problem.
> >
> > I see a couple of options here
> >
> > a) I can fold the -fix into the base patch then send out the
> >    resulting diff as a reply-to-all.
> >
> > b) We can just deprecate the -fix things and ask people for full
> >    resends.
> >
> > It depends on what people prefer.  How do we determine that?
>
> I like "fix" for smaller "obvious" stuff where a resend is really just
> noise.
>
> But for bigger stuff I prefer a full resend (we can still have these
> temporary fixups, but for reviewers a follow-up resend is better).

Yeah, it's really about being able to come to a series later and be able to
comment line-by-line.

Really larger stuff should be resent I think, esp. if there's multiple
fixes in the series.

A reply with the same-patch-but-with-fix-applied would definitely be
useful!

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

