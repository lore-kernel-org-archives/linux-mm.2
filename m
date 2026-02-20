Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60589C531F2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BB26B008C; Thu, 19 Feb 2026 23:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10D76B0092; Thu, 19 Feb 2026 23:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913106B0093; Thu, 19 Feb 2026 23:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9756B008C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:10:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 184EF8CB24
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:57 +0000 (UTC)
X-FDA: 84463509354.25.7D474BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7EDD3C0009
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N1VrZuK9;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/A0Yxvye63cj+hpAab8QOVcalyFGH3t35eHSGcH62hs=;
	b=MAPvsErVdCsXBnadPfUNEkD69ycm2pviD129u1GbNe0Fk1Rd1cOpL/27sews1bF48FXhYi
	Jf37xy4QPEmYo3a36xIeMSwyjenLthOmMH3MUCZRnqMK6ZCfB47T7Yryzqo5qKXsDRP77s
	Ghok/tv0bjktdg+2mnzNhK4pfwFXN/0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N1VrZuK9;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560655; a=rsa-sha256;
	cv=none;
	b=78Bk1+6QJ+yBzbB6RPVgBEdtpO6qeixxC2TyEnKdv3dtD3FOj8vexr+wQAd9iweP68UyYx
	TJBfxrTzD6DpM9VoKsjNVp3YzT1zX9CRwiVmr5Bba+D16uLHBxfULzzSWuaKJCdmwq2xlB
	g6o3/iHQeAVDyr3IywNYo8idhIUjNjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA55A6185D;
	Fri, 20 Feb 2026 04:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD7FC116D0;
	Fri, 20 Feb 2026 04:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560654;
	bh=Wl/q2I9MW4EAYAIqkkPs9cMuPySyeP7Ys0yLcRoxiik=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=N1VrZuK9lrvi+0jv5UrnpCwpMzW70T8EtjcsHnyvYb/C3ysXhXnwcXh0J1BUrz/fQ
	 FXvJgc0MX5grtuvCDCjFOveYmh43k7YKrhJKjA6KNPY5GbthY3tSAB5Rd8DWyI60O4
	 60LGpZhdpz2TPplFhz9GOt22IkO9j9SafKfb23NhzY6Pqtbyy2AyC4nRduEnajg21H
	 pPrMunHoqFuSELpIJz/FNzbQUBVTQ/4/r5X9keCr5k8mekJQPLFSEN/1VTk4FKKX96
	 mGvQFqOn+07PQ7stZW8usaIlrYxFaew9yX4CoBIDJ2elY6T+mswJuAAcc8jX+e9rPf
	 2Anz+jmhWYL+g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FEBA3809A88;
	Fri, 20 Feb 2026 04:11:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3.5] arm: make initialization of zero page independent of
 the
 memory map (was Re: [PATCH v2 22/28] arch, mm: consolidate initialization of
 nodes, zones and memory map)
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156066278.189817.13783312336351868850.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:11:02 +0000
References: <aVpWpLV4Dut5Muo2@kernel.org>
In-Reply-To: <aVpWpLV4Dut5Muo2@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, klarasmodin@gmail.com,
 akpm@linux-foundation.org, alexs@kernel.org, agordeev@linux.ibm.com,
 andreas@gaisler.com, bp@alien8.de, bcain@kernel.org, chleroy@kernel.org,
 catalin.marinas@arm.com, davem@davemloft.net, dave.hansen@linux.intel.com,
 david@kernel.org, dinguyen@kernel.org, geert@linux-m68k.org,
 guoren@kernel.org, hca@linux.ibm.com, deller@gmx.de, chenhuacai@kernel.org,
 mingo@redhat.com, johannes@sipsolutions.net, glaubitz@physik.fu-berlin.de,
 corbet@lwn.net, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 linmag7@gmail.com, mattst88@gmail.com, jcmvbkbc@gmail.com,
 mpe@ellerman.id.au, mhocko@suse.com, monstr@monstr.eu, muchun.song@linux.dev,
 osalvador@suse.de, palmer@dabbelt.com, pratyush@kernel.org, richard@nod.at,
 linux@armlinux.org.uk, shorne@gmail.com, surenb@google.com,
 tsbogend@alpha.franken.de, tglx@linutronix.de, gor@linux.ibm.com,
 vgupta@kernel.org, vbabka@suse.cz, will@kernel.org, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EDD3C0009
X-Stat-Signature: 5xuihbndp985phdkc93xmybeo9aq7xix
X-Rspam-User: 
X-HE-Tag: 1771560655-531128
X-HE-Meta: U2FsdGVkX18OXi74EzFfrnL0ixBwBEAe1iEMHm5VLBf9VCD7csdDCVct8VpdgiEiD1NL5ucevHNTDENHnkryE19V5Ucnufp2K9DfmJ4Q213ShsTLw30jWyc8yBgBxb4gS4cEPNPKwl0e+xA2eiRp9oVVHXjASdVFC1IY1xqqFGJriCuDYcZG/E0xVX+nPyeJ+TV7Svt8lfWjPhfe+v2lku89n4I1kuUlcfzXZ5q56ml/745Jl113Hudf0JO5FRFKJoMuTNXu6VxyXXoagwZhQBwbSX0zUPYMXHpgQ39xKoSbvcxqKgCsI5aKCu6QUtL2bNylZOba5XeSLufR572ziZAs2KfXjUQiEEcylY8zXA0lQXZuAGFJ27CVASIdCyvIft6NSYCOe6Pt9EWXFPoAnSgWw7wwMpE5EMB/+iGiKcdeiWTE8aUO3Yay3d9gqo3NVfjhkRspmIj4lLsyDqICd28pS3rUR0h/wV7RE00C3QhXJjst1L0FD8JPoxunfRX3vzfc8Z3Wk1WYm1xofu27gdLQ5DNjVHiyiJejI93RguN9NAZV3RUggm4M7z29iabCbd0IFP+fjOQXfaMbTsbxc47Qrls/cstcskGZKwD3ys99XAu0iV5z8jrYACCEttKbh8C1sX26HyYN5AR9rbKmWFwx7HGS6sYYbWVRJamcbPqxMUiO/wJCp5xfTu+M3YmHUD45z2b+aBzcqVPUHypaTSLhJBK4Zi6gP90NwkgnpqnTCxn0wTUZCRtNNcTb0tPAWRfOeyH6oyixeYR+bjwZHoqaruO+DIVxsKgXICgTICq/dOHBs+f1dVSjzYWaLAFsJw1/OlHpqeqeD2yYLUNrbLZ9ExcSAaAuds6kqDsrDeKwzdB1fej2JedzdBNI1WzrfTpG7c/0LIX9ge2QLErjiEt8DDRg9J5LhSDiqCsoduLvGU18vBHA4n1/lTq2xVJ6l8orejxKGMdtEZVM0tJ
 5uA7eH92
 s6vgskqXeEtZU3YturhDjcw/9ciNKafcyMNUbl5PT0VHlH0euOas7d+DUy4WhhA2169HS6ciW2eOo01PppB62anPne8HgtpsDxvS+ioeUPEVH0Cbb+Ewlfc8QsbZEaYub9ZrV9qYDzMJknYvLymnH4o45jMOM6LXnsNWD5gPPBPRodnuChxsM6mKTmTWTRhn99Jt0+6SuY0zMUTCmwwluAMiJG8d8V2W94H5/XrTSPxcBVrCplptKb//ro/CX7l78vjd5ASY8HtFaJ0fKYdFaPRrwguSM9lKWR1sWSQ3Z0koZe7ul4MdZIR5vNZxHvW9aOZufOFSTt3MNAvc0xTGgz3kQ/Rf9oU7t7fI65Qgee4kqRJzJSY21rdq28B/5RSwG0ul7tPwZ322QhUYCiPlUQZWpadvSEuH8kag18ggRfS3fGY4Lw4b7QkGMsIUUv/4sgOzhYTAD9iwm8WCyuV4nTpJu2adOWaV5sSwkzPpXJ+TRFHo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sun, 4 Jan 2026 14:01:40 +0200 you wrote:
> Andrew,
> 
> Can you please stick this between patch 3 (arm: introduce
> arch_zone_limits_init()) and patch 4 (arm64: introduce
> arch_zone_limits_init())?
> 
> From 35d016bbf5da7c08cc5c5547c85558fc50cb63aa Mon Sep 17 00:00:00 2001
> From: Klara Modin <klarasmodin@gmail.com>
> Date: Sat, 3 Jan 2026 20:40:09 +0200
> Subject: [PATCH] arm: make initialization of zero page independent of the
>  memory map
> 
> [...]

Here is the summary with links:
  - [3.5] arm: make initialization of zero page independent of the memory map (was Re: [PATCH v2 22/28] arch, mm: consolidate initialization of nodes, zones and memory map)
    https://git.kernel.org/riscv/c/18b7cc70dea8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



