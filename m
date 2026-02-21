Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6C2C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 08:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEDF6B0005; Sat, 21 Feb 2026 03:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6596B0089; Sat, 21 Feb 2026 03:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CD66B008A; Sat, 21 Feb 2026 03:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD94B6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:29:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59CF5160482
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:29:48 +0000 (UTC)
X-FDA: 84467790456.30.350DFE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC8D2180002
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:29:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rLj5z5cP;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771662586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPHy0KiBG8d5iI9SFB4RntC8PVs6KYiMDvK0HTsyi1I=;
	b=2KdbrPMBM4qKF8VqFV66p/BkGJ/7+ZvKnd97INTtN8ZxvN89fnWxm+uewmaX9jbnHLb7Ri
	UNFnfQppc63tOYOBK+yLiSX522S0hyJUvR1yWlmO/UuiecA4mFVeRndeLFdeO7mUSgRYCK
	QoM9CVejmeYmy3vVUumj02f2SiFMXmA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rLj5z5cP;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771662586; a=rsa-sha256;
	cv=none;
	b=oz3tlnLxzT3Qz6U+QVCpAV3VUF64+XYxFWLKSaLxd84kMeRM6wkxjB3b2IGPyy4/BOXGjP
	m/lMPg841mExhwOHd3fnmZG4VjJCLlKCFXJvPW+psiPoJbeK0mWcPnUF2l1gDjRo39Wq3B
	X6KqVlPqbp0t5LbHDoicOTLsZlOjclk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EAEA40749;
	Sat, 21 Feb 2026 08:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE1C4CEF7;
	Sat, 21 Feb 2026 08:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771662585;
	bh=/KF7N9P8kwaG42Pz8uYG3PDsHTexNl7EceRjmbNSDCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rLj5z5cPPxcGa2FkpzYEDztmPckQy/FikbVToMmEYiwy8ViOVnQFMadQj7EmUZ0Kx
	 N2ry1dyjJbCcBR9eWQH1hoQ7VJPItPSrO4rXASmFcV6A81JRN4MgEFHlKF93tt4ZgZ
	 /zAv+FIXCh3yg+eDGmCykFiNskLmbQLkccoRUHDTb5PWFrF73C/LHH1XyD0AUzrHPA
	 wOjgkApFBm5XAS6lAv5vFZ/Y1YToGBox3IF69VbIe/Ztm9rtz/dGnBRZvJ+eGL76n0
	 aBJOizlaJQ4WN4Ee8xpHIfcSIgBGOgVXsw1gRA7Df8r8ltMVu+/clmMhPLsC2+i+yc
	 i+4bLZx7hA0OQ==
Date: Sat, 21 Feb 2026 10:29:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] Some small improvements to reserve_mem
Message-ID: <aZls879r9Yxd7Jcz@kernel.org>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217195816.861684-1-gpiccoli@igalia.com>
X-Stat-Signature: 7jgd7m13utwq8zzygjxfotphknruak9w
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AC8D2180002
X-HE-Tag: 1771662586-142146
X-HE-Meta: U2FsdGVkX1/74wL9t0QfJa2+ukt4+bc2R7UW9JYaF/c5XIjmOA1asGu1uWVsVkMXelp+ZjbRAayYArhtjGAPtyRPP47MxP6EX2xZ6Dk4LSZ215ethWG9FB8OK24qfgaLoJMdq0dHNo7IZ0Ut1wMTBE1wBYEPdqfkiXAi3aUoFK2cyvGxe1CTlB2fNv41s4dnn63IAJm37ZJ3gUWTj6dqskcolM4yIiN52MiQBrGmwt7/yfqxGo76iudZc0wyvUfBikMHTq4VHX0HM4hC2pTYA7aGiDTYzop8gVewwPV/1NkIyD1cwHWTYzFgRGlRKK9xpFDPauw3zItjexhm9Q9dVzemDhl1EDxktTmJBphQ9gAldwT+zjww4GB4mOd8uCw2JWT2swE2IXaSCbxEKAiVAaXIaT8mU6kV9r9bvb6FRvi28mj3Fiw0fEtdmCiDj8CXg/1TSn34OoknzXn0DyOAW1t41b5a0Zqd2ERtFaM0JYT3IdS1OfjeYltLTKtE6TQ71EZuv/D4p3W3xgy/M/xPsA3v4fdliziYLFgHJygMvBhqfshslZ5q9G3ZWwPbfJ/D+XbuPnGmV8ytpuUkD03q5o1U/lOg+QGZuj8qpfKEyHo8G5QZ6j+SINCPWRwkysKzl4ufR+jc1DEdVBn+EMn8t6QVgUHGi3nmn1JyZgyp8GwRZykd//ZGdwUNEMkilksKbdZKUyfxRCCjpWJyqtR3s8hapbI7q5A0YTicYU1hSPlPu2jRFlYYsS5jXQzxnKlZX2f/6EHveevIXMwieweUU7KIXgO78Gy1u60NWsZQ1V0FDWcyuoMdd31EugbcSjwQ1fwWZ3984lG80BaQK57Nn7IvMX4dZK5O46r3ntc3UsxRPrNxQEctTkRU0cgm8qoZZZ0fvSBzE38OzefNK1O9YmtqCKgjv5iF4ByAlaamNuaK7iYt4FfDiMSDmkB7iGlU9VgJUU+N1pkvpfze0Mn
 NeRbxlM1
 RytoBCoVJEA7jkUiHtNATEx+pAhjIcbHyYdRbBsV2gTRlcRSOpllkGy/jqz1ptxCHZqxDNVjy/DBecmQorACEwMdkcZnoePmpcgoXf7UquovFl0GkmgynmRLhan97+j0y96PUTpuf5p6aC//kI+HRzjswORW8/WFetZpQndZ9QgnIWU0auVPMIKdSUN70FhXgTWKBOQJZ+Lp4f2KVl8A29IjXdLcF1LaCd4UEzYKZnPdnC1G/y9UIBq2OvAFvMQ5G8mY2Rr2nqaS1aPvEAv/rPIgMAgBHeqqT9pNvlo5YsGIw2vA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guilherme,

On Tue, Feb 17, 2026 at 04:45:05PM -0300, Guilherme G. Piccoli wrote:
> Currently the "reserve_mem" parsing is lacking information both
> if it works or not. It can fail in many ways, so I'm adding some
> messages to help users determine failure.

Yep, these are useful. 

> At the same time, if it succeeds, the only place I can "see" it
> is in the accounting of reserved memory, as the following kernel message:
> 
> [0.086881] Memory: 3958852K/4189472K available (19671K kernel code, 2893K rwdata, 9724K rodata, 4340K init, 5040K bss, 220244K reserved, 0K cma-reserved)
> 
> Since "crashkernel=" reservations are shown in both kernel log and /proc/iomem
> and other unused memory buffers appear in /proc/iomem as "RAM buffer" entries,
> I've added hereby a debugfs entry for "reserve_mem". Though I didn't love the
> implementation, I think it's not so hideous so decided to send, please lemme
> know what you think and if we should improve code or even discard the idea heheh

crashkernel reservations are part of the ABI and kexec tools parse them in
userspace, so they should be exposed. reserve_mem consumers are in the
kernel, so if the reservation succeeds there's no real need for userspace
to see where are the reserve_mem regions.

I don't generally object showing them in debugfs, but the changelog for
debugfs addition should give more details why they would be useful rather
than just say that unlike crashkernel they don't show up anywhere.
 
> Notice that, with this change, the memblock debugfs folder ends-up showing
> always, no matter if we have ARCH_KEEP_MEMBLOCK set or if reserve_mem is set.
> Thanks in advance for reviews/comments!
> 
> 
> Guilherme G. Piccoli (2):
>   mm/memblock: Print out errors on reserve_mem parser
>   mm/memblock: Add reserve_mem debugfs info
> 
>  mm/memblock.c | 65 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 54 insertions(+), 11 deletions(-)
> 
> -- 
> 2.50.1
> 
> 

-- 
Sincerely yours,
Mike.

