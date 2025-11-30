Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05966D111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 19:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035C66B000D; Sun, 30 Nov 2025 14:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DAE6B0010; Sun, 30 Nov 2025 14:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65A76B0011; Sun, 30 Nov 2025 14:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D64C26B000D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 14:03:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6746B8AB34
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 19:03:48 +0000 (UTC)
X-FDA: 84168197736.26.03D6B05
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6A9FC0011
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 19:03:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b=oWx5KVdS;
	spf=pass (imf10.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764529426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcobmzCVZzKsalDG7iII3Z5e85MNaCA1h/c5e6HyJFE=;
	b=rFntelK8aIWk0QbM8gcl2B6uSuugAMFNZ00mOicJN0ZhEISsRAqXLvRs1PP87uKyvOPan3
	GwJFJtJd7m1IP8YXU54ZgOiI5sT5Bv4yuE0moU/QzOaollypvWmPiaXvYRKST0Rclo0k2n
	RJWpmhA25nOHk5yLVskSxBmXW12x1vc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764529426; a=rsa-sha256;
	cv=none;
	b=t/z+1ug1A+6u4+ejzmweAr2iYfpgOu3e683kGqSQpHxRwzvqWJdXDzS4wryOwPrnz7HP5r
	F6FzfcdHUpigMOT41i3KCh2M+qToIJVlY06fmbokWXIeJCXAGa+wrNSA39uK419pEAr6rc
	NlQPHkKgtALi+A9iAJ4W8VqR081wii8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b=oWx5KVdS;
	spf=pass (imf10.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vPmhz-005OE4-Uv; Sun, 30 Nov 2025 20:03:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=CcobmzCVZzKsalDG7iII3Z5e85MNaCA1h/c5e6HyJFE=; b=oWx5KVdShvtRvg50cH+3h0Z72F
	i8zUjkrXdY1GXaP37WvXdsFKPiSuH2ZejGVU3ridQvXDXUbjDoH6PWuFkPviLkPTjGbbzGw2lMr0P
	54NtxGg0C0dJNmNuLPtbOgIrVcQJIgMV20g8myfNSMCBLlu6VOASgeEfPC9KbD8csTP3OdUWYIZJ8
	BWKKjaABTm1bifHy0rM8R75vkEr6oQ0XV9k5dINLEO9GrEZbJG/QLPIr6jLN6gwdDAZA30EJWwMyE
	Vn57MU4NG4wbNWBsDp2PJ9EddQOioF1ExU9dUJjktx1dvZrsV3HZ7l24okhtHLZEuwP3s4pxAUx4N
	Gdz3RiVw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vPmhz-0003YS-8t; Sun, 30 Nov 2025 20:03:43 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vPmhs-005yEm-EM; Sun, 30 Nov 2025 20:03:36 +0100
Date: Sun, 30 Nov 2025 19:03:31 +0000
From: david laight <david.laight@runbox.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130190331.40385ddc@pumpkin>
In-Reply-To: <20251130164348.GV3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
	<20251126185545.GC3538@ZenIV>
	<c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
	<20251129033728.GH3538@ZenIV>
	<20251130030146.GN3538@ZenIV>
	<20251130113213.40c8e7a0@pumpkin>
	<20251130164348.GV3538@ZenIV>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E6A9FC0011
X-Stat-Signature: k16cm5crgqettj4q8ggfdkub967in38t
X-HE-Tag: 1764529425-818913
X-HE-Meta: U2FsdGVkX18ycWJiHhmh5yEeRGWocVvE46+JFGC+ANgETMHQy+pEfJYC49Dir7lieKOVF1OA30Tp9NEIVTnRj01rPV5lFitsf77z4p7vPFGCBf1HMxQ94gBumptir3bfmZ3hHGD33EdBSIs7tqHk8Lyv0XET8zu7zTqbtc1gv+Me+XbqCeK3bvdqxljNGHHM4fZJxWD4kpc72aSjTYDCDbqGNRS/Q/BmUb7I5IJS/Edl0hlU400JUs7Wo/mWIuVD5oR1Rc0z+YaSTv6SXjMv+agApKnWbJKG8+msPSTwJi3nzd5OHlbgf9XZTQZ9NY0MGrZRxaQO2dcHJ8WzZo78bHcfIZBT4RTPjjAF6BNvIbIidJnFiw4o2m5IwYjlYeuu81zt0c6FSeDq7mD8XwkneIWze1i2ysHcUTZ1Cn1kHaEabxwg5lKGAEW25vvJ9oCQeFWfAqS/75HtJunhhakY3WtM+bNa7U+YTBaxPMhjM0wD+cQMLOMQW/UHbG4iNzJG367CMVaYUf7hY/4SHBTJvVMnSGOSSYPk91buA5IrNSN+1Ef2W9/Fw7D6Og69KWzdBEnDE5N5fCLX5LK4qBSK7fEiLJtBo764jtoGxTRKYajoXcClbM0w6m8bJCkdyMrB4bAdxLINVU458C4+pQNJpPVfi2ZVw3KTRqe2hCFcGu4X4cy80vAo7BkIGP7G6n+/O6p9who7MyKjXVuamnWs8tNAGXCJF6hMv3Y0V4JsYC5LbiWNhrzJ9FrSMDRrQiS5PdDTCSSFPUbm+Hk/vDrpJHZMsY1aqx593kGtPrhXgwkAyvKZe8vkcIs3zIO+3xw4XGH/5RwatNpE9M+YfCT/qP5eju3M2Vu9i/7QSSqcLy/nBMz1lB70TZ/jKH6FNhYBRq9NbMVyGfZCv1Ki6Wr/2U+tUkb26+1X4QhjTYkH0avYk4iFf4qbXXSsCfu4BjQvy9gCENhnMAUmrG+d5+N
 5PyCkcbB
 3COeEfAK4Ilbvj0XpHx5pfXG/T33ZexIYgE1vQENZKMlvwidO4A9KeaPCvAf/2TeMJP5FtGaxtSy3WawoODK3chV8VyP1G8fl6LcQuA3SwFJdruwJgpBsgRFeILHAFNHKxrkkdkLuTc0lf5nu+4uBFanxfmzx/QatFhYbT5ml/ma1oqYz+mm9mgdsBEznekzbQvNZMojRIVteUvOpHLW3aZ3LADAUQfqDesvul7DD6d3m8cADvGxLvr5xhnmKYBQkAGF5kwBMQYUIPQb6P/Hf7e9+bTsKHVRSg+HV0W7Pkug9xjbvc16dSmXaDhrbhn79JhCX6nmGhYPBVpX0cskGjc2QBUuxuq+JODH53oAobAGv2TeOBUxS53C3ruBCjLVlMkthS1wtrlguyUu0tnz2PQQgJMlYvN6kolVu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Nov 2025 16:43:48 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Sun, Nov 30, 2025 at 11:32:13AM +0000, david laight wrote:
> 
> > How difficult would it be to allocate the pte for the next 8GB on demand
> > inside vmalloc(), and then propagate it to the per-task page tables.
> > That is a path than can sleep, so being slow if it needs to synchronise
> > with other cpu shouldn't matter - especially since it won't happen often.
> > 
> > That should be moderately generic code and would let the vmalloc limit
> > be 'soft'; perhaps based on physical memory size, and even be raisable
> > from a sysctl.  
> 
> Considerable headache and pretty pointless, at that.  Note that >8G vmalloc
> space on alpha had been racy all along (and known to be that); it was
> basically "could we squeeze more out of khttpd" kind of fun.
> 
> Do we have realistic vmalloc-crazy loads with high fragmentation of vmalloc
> space and total footprint worth bothering with that?
> 

I doubt it matters for alpha - I suspect you could just nuke ALPHA_LARGE_VMALLOC.
At a guess it was written way back when the biggest/fastest systems you could
get were alpha.

I was more thinking about about modern 64 bits systems where you might want
to run a distro kernel on systems with relatively small amounts of RAM and
others with 100s of cpu and multi TB of RAM.
I can well image workloads for the latter that might run out of vmalloc space.
In some situations even getting a command line parameter in can be hard,
so you might want it to be a systcl - even if changing that is what does the
update.
(Doing the updates in the page fault handler definitely sounds like a recipe
for disaster.)

Note that I've not looked at where amd64 gets the limit for mem_init().
Maybe it tries to 'guess' the correct value for the system.
But it is likely to be workload related - so allocating 8K for every 8G
of physical memory (one option) may be wasteful.

	David

