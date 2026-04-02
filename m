Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBD9D6AAF8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 19:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9336B0005; Thu,  2 Apr 2026 15:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A116B0089; Thu,  2 Apr 2026 15:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FA36B008A; Thu,  2 Apr 2026 15:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C62B6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:26:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D36941B8AD4
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:26:25 +0000 (UTC)
X-FDA: 84614597130.17.F857008
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED91D14000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:26:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJmlyU2f;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775157984; a=rsa-sha256;
	cv=none;
	b=u/JoBbdILRbkKvZyEiUdPjd3Vh0lgQjLgSqOU6bwyZy8SIbRlJVxq6+RXiz6FXuZ2Q9KtP
	HUHC7F/fjDNwgTIdJoBKZONtrGGWocs5wijbJjv8mtCJEnuhI6HM60q/2RDJZ5P32OsdGB
	Hhi3ELcYvG2Ffj5u51JJfdbncXHD6/8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJmlyU2f;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775157984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PqOUhzsRPx9D5vtzblp2P9mFGliWuzJGA+r6wok8jk=;
	b=RqWmJ2C833Yoiha7tWIT2E3YhUbc5nGLlDx7pbrxRQwD3yIU4XkKVdOyENmNrVr0QNP46Y
	uDDnJjtVIqbfWtp80Y3ch9wbDk4XbG0uzaFBiEBnIPgfL1n+xvyoH7ToMpevCfjIEph+Hw
	IugNcyipvPsiS9gCKV3PNCpzpvLjVJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5C2244478;
	Thu,  2 Apr 2026 19:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40095C116C6;
	Thu,  2 Apr 2026 19:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775157982;
	bh=XLkaYuwC8TJumKWLKI6Vqdpwwz2SiUWTGMJT6mO3V9k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VJmlyU2fMvJ0khCoy1tyTA7o/BVvGJ9czzpOxX4I4bqpdJtlryV5k/ynLUFFpZkha
	 gMc07NJW1hL7Bub2F4I1a4k1Qz3ZGwd6bBlsuD1SSsPJYsSDtyw7f7Z/oxcgdcppbR
	 aUabFPTvkOy2z4MQNc/SpSztOnFwEL6XHe61Nkrk=
Date: Thu, 2 Apr 2026 12:26:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, linuxppc-dev@lists.ozlabs.org, Harry Yoo
 <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>, Michal
 Clapinski <mclapinski@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org, Srikar
 Dronamraju <srikar@linux.ibm.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
Message-Id: <20260402122621.566be08b7d16ba082371b5a4@linux-foundation.org>
In-Reply-To: <6a5f2139-0ff8-40b3-88f9-98d2ea020d6f@efficios.com>
References: <20260319233745.GA769346@ax162>
	<abzKcGiRSR_E8lLN@hyeyoo>
	<7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
	<ab1J9ODkX5iChu-C@hyeyoo>
	<7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
	<7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
	<h5qax9x2.ritesh.list@gmail.com>
	<20260320192153.759d6fec57f04fb653a0dac7@linux-foundation.org>
	<6a5f2139-0ff8-40b3-88f9-98d2ea020d6f@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ED91D14000D
X-Stat-Signature: if4r5ff66upha16kkjny6gg4zaot1d69
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775157983-870258
X-HE-Meta: U2FsdGVkX18u4LISZRCmr4eh+0AmhHqOiyRG09DmRMWN4wgTqufh9QwigGdrQA8+cJgm3UND4yKlMjCnYaHM+SiJGSjm94bL/4HwR6Z5gW72HrFyU39hgBxuNXNY8M5HgfznQRX/U/pDJ8ALQdhLg7N3H7/8Bf+g0efpC+6iKeky+nmzZ8rHqYSov6IiSdJBSjMPb7y4Ij9BTU+bE/QR4IsX+kt6acGlYCeCxwr84PfNKbwa6NUopBgpS6HSrWX9fKH6vGBpzd1fRmkakPzj9+bfv0TUgndCuaG/tPOUHWp/wnxu3yeQp+dn0fE3V4ZF0sJBiiF9f639COs/fonr4UR1VUktdJE72iP7dzl7JaR3t/gU9Jcw188RAfrW/7VYNQRmSC4gCrh72vizAdsdyH3TOLt+PgYm2MsMFe2dlTUdJmX0+20808K62FrX943ylLWxY/K5GhRGbEL7Ail+UGgHRRL8URpBkiVzV5nWAK2U4CMZ8Ze8fDN3x9yH4UxPUlIxE0m62b3pfUGFR/cGhNfjzISxCeCHKSVmBChfkdy3Q75cVl8SDNEMJIpKPpAQtTyBvztAXxhoJoUeQ7jpm2XzvluQzaY7lm/+OaMQKwdM8lvEzymx9PQs4BrGyhWvbY83n2H5nO8nxvnVcyFBIl/LtJdzi2nEf8/RVOVr4v3wnZxKWzjIvvAIspLp6aJ4JXuGxTfu7z9sgLyRQWzdWA3Cjq40ErxLDByieRVFNnOPCv6mzgE8zMO0Hf+mH8hpLdvuEANJARuZ50MlJPlIAZ0LfPX97F/lzlo4ENWADfd2TY7YJ5dGWoA8imjkKQOc0/UQE4ebhVE3SPwSYDktA/SVGji5kGEYi+GsXRzPAl9dqR4v4ypm542UFzLdEzWTZPc/6P7sqCiJFWBRD+XT2wO/wvmlSjqQnIVYFKyoP0VkiB8ms/uObytQvJSN5xqkUcB0E4nXlkQ92idiYt8
 CBHE+qI7
 SEvTNETEvnRFQTYb+HemQJIVK46KzY+JVpJQBsYCmbxskO4d4fY2b31F6DT9AFCIcveZj6rfjtep8c+x7Dtq4aMs9xwtmJ2aUmvLHO/Xd4daOpf20hhyqdodFhXmxS6inxAdFzh8yAZGzpbinnk0Cf9WTEn2gD/2/OG2dVQRhUGxS/K65TFWH+rGgSZC68RQHk3T5bzvNEouyIvJXv45M3pqSfyC0K6oXKqtCoU8Ojp6ij428YEwDoZro9XTPj/v1FD0ELrWCvUsqS8AD38qkozksge54uoXxhGw1xXacIBMjBuXpLargaWTJtjpwWu2xeDbCNZINP+sXFsJDtf4ybdX+lSqavnDaA/+IdlOSdsMd9FahDT0mj1uugttECUxWVZmtqjRUq4H9pr5KONo4Ni9meCZPUk25YUVO73SxrdxIjqdUx5Z8CtSWs37LcpFEM3HtaBetEYMMH0MGqaOKDJiF68x94yVnDfqY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Apr 2026 11:30:53 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2026-03-20 22:21, Andrew Morton wrote:
> > On Sat, 21 Mar 2026 06:42:41 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
> > 
> >> Looks like this is causing regressions in linux-next with warnings
> >> similar to what Harry also pointed out. Do we have any solution for
> >> this, or are we planning to hold on to this patch[1] and maybe even
> >> remove it temporarily from linux-next, until this is fixed?
> > 
> > Yes, I'll disable this patchset.
> 
> Hi Andrew,
> 
> I have prepared fixes for this issue. On which branch should I rebase
> them ? Do you still have the HPCC series in your branch or should I
> send it anew ?

Cool thanks.

It's best to do a full resend after -rc1 please, presumably against
mainline.  Show reviewers the latest version, refresh memories, etc.


