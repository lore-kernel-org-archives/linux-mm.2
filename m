Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C056C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09406B0088; Sat, 26 Sep 2026 05:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA356B008A; Sat, 26 Sep 2026 05:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFD86B008C; Sat, 26 Sep 2026 05:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7A8A6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:16:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29C39407A6
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:16:06 +0000 (UTC)
X-FDA: 85255356732.19.9FF55A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 75B2D4000A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:16:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/cy2uAq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4bWsh+Pc9s6sIGPF4Grv7BRltIPfKgjNpbCy4AEEXA=;
	b=7/iQ+R3oUpZ5kuMRMr1sSrDl0fQ2BZFQjREH/DAks26wsSWDh0W5hwVOvuW2Gc2oWaO7af
	pLlvTSQJY58iIjk/m8fgQV9HPkqgJYzUvvYFOPVfpSCE88D0sY3AQjD2i9yfAJuvBp0dmC
	I7iRqG7+Y7HMucJp3cKn/wyZo/Xy0BQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/cy2uAq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414164;
	b=VsVqeUdkZR9c96hDTCyj1TRmzGV5NHWfWh3k6Sywjd60qJbMR0iAeII+NMDC8cX9ribtYc
	jPrwby1ZHU913EiwMhSguRNjYyfJfwqS1+jHkC0UyiVuihiiX+YRLATJmzr3QoEvD0DbA7
	AsCWfVVlO3uB5LpiUrDT4i5kAyOn0MM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8459343D1D;
	Sat, 26 Sep 2026 09:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6591F000FF;
	Sat, 26 Sep 2026 09:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414163;
	bh=N4bWsh+Pc9s6sIGPF4Grv7BRltIPfKgjNpbCy4AEEXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/cy2uAqCW0oNOWoQHl6gMve0xGBebGA1qmqR1XrS9a5R9KjUOKFr6umhqPOwVAfq
	 JV6o+g9ZbwsyFiC1yXxh+8YSz9r3KSw26jRgxGioo81b3ckcBjRXINtVkE5FLLobZm
	 cEXp3py7fiL/jCemhyNfo4o04u6qGas4PLNjGw3xPqVwYER6r75qK1Kpvp2M23DpoY
	 0BBb6c0Da8U0FS8/BGW5K1g9Jfq3Q/44IR7oFF8xFbzjaFcMlW6oTmaVRUNooMJemG
	 74S09dqAtiFGHl507QSUC4HwsG7rqGMANSDx0f//8KLgYHgnF7DXbYK/029YJkc1x3
	 aMwcgwNgXEt7w==
Date: Sat, 26 Sep 2026 10:15:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Ingo Molnar <mingo@redhat.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] arch, mm: promote DEBUG_WX to CHECK_WX
Message-ID: <areNQfnAdkfR8fAf@gremlin>
References: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
 <91d800d6-03f3-4068-8c12-618529a81528@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91d800d6-03f3-4068-8c12-618529a81528@kernel.org>
X-Stat-Signature: 4fz9ofypcat9j43omxgwema9s7grpz8w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75B2D4000A
X-HE-Tag: 1790414164-640928
X-HE-Meta: U2FsdGVkX1+5tItiks72dyoiSj61D20QIHcZrh7laujDF58Ee5bQNj8Ll+RHBgIANs2UIVPCBHtwklqAxaSDCDMCtQu3NYLrS4X8CvPwpxWFP7cVdOp+A5L4zX1zi6R6JJhZlc08RgxJI6M0xPvbGemxFRHJEHkaFjqUAVP5/Ynl0AqABbFT1KOnq1O8LvbmFBQ984r9tByaQIG8k0zfhPRmGC9Fh7nyg3WBUPXQ2HCcciODpy8FNkUwHET3Opqh3amaftJJC0ckkLjQ2YBR0CCAYMfORdHtFcjp+YwyUFiUy7huZFzMO/SunQ/OhPwojpKLKD7oRH9oPj/oC9X09gBOrhsCezdlo+wwK9YngRJ3Yd4Ouqh5/D5/dUKMXakHI2INGlbulzPam+k3MSGFGYQgu3qcuiVTmumqA0uSs59OPyAzj8aoINnxeHQiR/xxn6d+m7pFKoSnQ0P/LL3mowF0ogq7ZyeIBUqhWSQETFf+HdCCyaErWDakeXDgPHF4RP04e/kgjgkxJoPX/dNtotSGuz2BGwz4W7pQDgIkkQzt4+8SLQ4QZWa57cZunoWSKjGnJnr6ZD/PVmPGVsYlWntoDI4TYDE3xPNwCvUcJZAOG53DTb7KcdDu1LdJAAoQYQ5wCeKD23ZbPqMZp5nMyS87Gd7VrbDq+0v+rjwhpqpIJH/2kGqjiiZ+LB4fkVFqHOPx5hJnuPVuQTjrDOM3dyYl+qOpko6Wxe5iYnV9091XaO+xsSScUFxX+MbIW4osZ/XJnwL7KsFGWpK6fIBOcHMa95TwTbJDQI5YTTlrdI2sJ7KPaT8toF6JubQydZDcaMf5z/KCdVboiGpWceoMMpM4rjYKGPXkwbDgnE3Ul2xopk6aAypLdZw2sncK1YambOBzhnhDMfByfEIVfiNuitKkvUX8Ixo22oUl2N2unzlgkgFIpymO8lM3OX1/9+0G6f8Vc01lN587UQpXcEg
 IGQEw8z3
 cUlFLSxBEHhQcf/tPFNXzwgnHjuudwh+CsZASjTOHzKHQqN2IDxm7BYT13KLComcuXSlNpB7yTcL3209X73WM42/Poz1QbUCF3Ul+8hhVWFXWqdYUqTTl7JQl3lPmjdzrd5B8IDOZRS8WZ196k4KiLy4LSYuILKySb317szr0ms+vJrWpv2XATR7L4I+6Q9J419V/S0N09NvoX3almYfwb2SSqy6NGrsSDjEeURULhgka2IWHLvhMg7IXcqAZ7la8VKvYMnTD+WrD326h9avLHq/oc0ksgD1vXTMw/Prq5tAZqpJKBzDRYgXJf1NXAbmhJcFMW88GhtxTzjScZrpQu4YqfiKZioWhbPo8uGowrP8ULBbHnErjQinmZUPVz7iwSpKqAV5cLF9vdkMZN1c4t8aK+5mpSXPIvFtrocl42Yb2PJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 01:01:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/25/26 11:53, Mike Rapoport (Microsoft) wrote:
> > Verification that the kernel does not have writable + executable
> > mappings is about detecting security risks rather than a pure debug
> > feature.
> >
> > Major distribution configurations enable it in their kernels as well as
> > defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> >
> > Rename relevant generic configuration options to use CHECK_WX and move
> > their definitions from mm/Kconfig.debug to mm/Kconfig.
> >
> > For arm that does not widely enable it, only rename its variants of the
> > config options.
> >
> > Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> > the added size can be slightly reduced with churny updates of
> > architecture implementations of ptdump, the core functionality takes
> > most of the added size. It cannot be moved to .init.text because the
> > verification has to happen after init sections are freed.
> >
> > With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> > still leaving users targeting small kernels the possibility to opt-out.
> >
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
>
> Makes sense to me
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Similarly LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

