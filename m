Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A41CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B926B00AC; Tue,  2 Jun 2026 08:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423656B00B7; Tue,  2 Jun 2026 08:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3606A6B00B9; Tue,  2 Jun 2026 08:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE196B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:47:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC9C41408C5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:47:38 +0000 (UTC)
X-FDA: 84834948996.08.B725D56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 237C040017
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:47:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgqQihj6;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404457;
	b=iPstkaTot3r22rOHLZQb+6Vl04PUUinP2kWTGnpS1ivTHeanJotdsCge7KQ4AriYhTQgHV
	wsE+Lqfh3ZDKU1AAXdxsCAZCmHR5TH8T+vo8ulwniJhXuSc3QKZ+kMsDIZnR3P+3AN0Ye6
	ZtkIAjvp891ihD2fko958WF10kJ9Bmw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgqQihj6;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eo5FXpDkFvf14uRPPl1kyUutcnRuZUpz7x68R5KJSPw=;
	b=26iXIWUVSI1K/0RdYbpAIn4OctXFP32TRLuvkTMjOb6AaP0TRCF0iV6/M4L3PaLyq0uAJD
	2ZYkfLreer/8me1XAehGsCCDT1kRzcoXB1aQHeRLPK5EJ+F9KHAhEMFwQTsKinEHCnxYE7
	fkuHUfTiva1b1VmJ7WCzP8If/U6WIP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0BAF60154;
	Tue,  2 Jun 2026 12:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812A81F0089E;
	Tue,  2 Jun 2026 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404456;
	bh=eo5FXpDkFvf14uRPPl1kyUutcnRuZUpz7x68R5KJSPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MgqQihj6pj7h+FldOL4xE3K+YX7gfMJMC94m7JmsVDKATOtUgOhMsUIF9XCO4gWpX
	 lPtI5hv/Tjhnq7enqjIdrLvrNZShTow72KXqnohxh1A3oUCWTrOSrwJcHdRyzuRoFm
	 /Gx3qwF5nTnrAKSLTYyZ6PMmuJS2drAO15CM3Wu13VHvTSCDxcQm2iiQxfnI8vMcP4
	 /gzYEcTuplhxMjrdHVGX7VZSi5p8snBsI47hOT4M60Z8Yh8rAL8Xb6PVB5mdokBmCo
	 hiojmidCazEdBq7xTsD9JKk/44Rh6uqRzYRsKAgVyAMD7fSLYtxfqVUsVC4y4YL1Jh
	 9AzmZrYS+zoCQ==
Date: Tue, 2 Jun 2026 13:47:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah7QuyqNwaZWjDpk@lucifer>
References: <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
X-Rspamd-Queue-Id: 237C040017
X-Stat-Signature: fznoabms5qnkfukdgmg77eboo85sb6oi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780404457-148466
X-HE-Meta: U2FsdGVkX19Lc8sTG9ywwX1qvFubIQm+0ztSr7qB5G3Rpq19SNZzyW5YuV8pEP32+TWAYdIG2kmPOQarxwQY/ZNaZz0yMZrMHfwrqyz7oSYi3LuE6RG5R9hRrXwapIsYLQcdG3c9IwaA2NDuK5l713ZV63M9Vc1wul52Y5z37vQKuEIrdg62GJLkcFEgMPfA/UfCNrmC1ez3UdHHUCgXVs40/Paf84OrUGttDQFXGOy1BRLF/f/xCvOm9xQ39HCfafhVz6mlgsKxuYBgdMrz+0KWGEVVxT/HcCbQ0hII6z6o5bzPcFIjxF8rGtdIf5R6q9jklRlXzr67AOXtQTSVP304SsDo5SSwNbPaUFyrp8n0Iu76Y8OZqf9sZUzb18MGptu06+zvpJWP4mvt5458WENl+JevL6socuyHIWjMBISATQ1wCQlEG5XB/w+VFLkaRDHOzM1PhwISmReLF0mOaIRCyiBak+IzcDXqM6ls/5nW8Whhy9/DlCYapTzKy3QBY1vuol85lyn3p7BJVEiD7zXymMkzodfCoPyFIK3GDI1pBH0CVF/cFW1s0RFahiIPGOkRsQeKmnulp7Fqyx8JRqkg2f+RQLAweUfc0fRBHNlDphpCP+nzB+YwzAqCbpR80Kxs00M/dVKzV3hwLWX19sfZg/mk7oN5t38sTnRqECtVAROo4cZZ8y1vVLR6yHBbh0x2eENptbC2gx2CYhApnupYxrtAaz+Tw5fppNDzjW6w0yTdpxgDmuRIOzuJNpmL55qvJfeL49w7Qb7KHlCUnkAtn6rqP0RXuyLBtnu3d5MboXvzoPcFbtw/qf1OqwLmLazocvcHrgckYqRKAL8Sd0G3FV0MivYL45N/ZgZIcegTg0zJ5Muef4+sfg+ydtdElKDLzeuLxVm/AaPzplF9srCnz88EzvqUlvZ5aoWs0y54DnokVSL3aoh7gnQU/K5Cl6zKMxDhyXVfXoST2tM
 8gJNdZRA
 JHs+NLKUUomQfpdO/UnBQ2POce077X/k8EvfYC1HLkLqKN50iCV9BXAVxiPWT3AEfuaIdW+AUKnaHplUFBgTL4Py80Y5wDIFw5subpi70PFkUGhVNq7Ho3qp8RkyVNgwBQo18GzhITB1T2qnZEIrVxBfYk8G0ZS1SMXjTUj3U37U8Oj296QBgqG4QtJJM72RpkrGNQTtwlEFVsIFtJfJlvxaYHW8EAV7bRJGh1mFOhyKc9rKVDxJVUmGMjd8K0r/TuafC4jQjrvBt5ZRUK1AacV6UnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 01:31:35PM +0200, David Hildenbrand (Arm) wrote:
> >> learn from obviously) against how mm works in practice.
> >>
> >> High review load with many overlapping changes might favour a different approach
> >> to a subsystem that looks different from that.
> > Yeah, but as we said, we discussed, it's all rather complicated and we should
> > move incrementally.
> >
>
> Starting to read Documentation/process/maintainer-tip.rst, it's very interesting:
>
> “The tip tree is both a direct development tree and and an aggregation tree for
> several sub-maintainer trees.”
>
> “In general, development against the head of the tip tree master branch is fine,
> but for the subsystems which are maintained separately, have their own git tree
> and are only aggregated into the tip tree, development should take place against
> the relevant subsystem tree or branch.”

Yeah so they have a separate tree model also, so that's an option to learn from
as well!

>
> “Bug fixes which target mainline should always be applicable against the
> mainline kernel tree. Potential conflicts against changes which are already
> queued in the tip tree are handled by the maintainers.”
>
>
> So, yeah, let me reach out to understand what works, what doesn't work, and how
> it works :)

Yes 100% :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

