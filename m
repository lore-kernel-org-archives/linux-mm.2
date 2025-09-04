Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD0CCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDEE6B0007; Thu,  4 Sep 2025 12:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7954B8E0001; Thu,  4 Sep 2025 12:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2256B000E; Thu,  4 Sep 2025 12:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3CA6B0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 147C2119CB3
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:58:36 +0000 (UTC)
X-FDA: 83852176632.24.82332F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F85540007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:58:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q7M3muTA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757005114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZrjX7Lmr2cuL8US0MWB5ts0UhLbB4R42zRyeQvO8pU=;
	b=7wEWPJ7gfAoMuLNNBdrqwTG7SCcuQvqrlI6W92SaCCgEfwVKHnYYsljleYoZe8yFSK7NmC
	6H63Mx6+ANstIlxRPNbevEPLOR4aoo3+k6O3rOQlEJyhEeuP1lpPpqLD0ureKhU+LyFOml
	wypEa1txl6/AWuVzJuCfOpfEnTohNck=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q7M3muTA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757005114; a=rsa-sha256;
	cv=none;
	b=MnuZXrqalzK8qYJmL22e9ku9TLYCArc0omcpzcnaAB2snFWN6ZNi2iyaivMQMlPfQ9MOe3
	Aob+tJfFPWr54FADn+kvv2yNdAdSP9YuJCj+UrSOyyHM5L/uYsI/E6XRsBB037OdcE6ScP
	a4yjSECcoFWZfZODRBB2pZW9BP0+Xjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F20A343612;
	Thu,  4 Sep 2025 16:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA516C4CEF0;
	Thu,  4 Sep 2025 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757005112;
	bh=UEa9OQ4jfJH4rBrlyyXkXe7/eodn6/EO6fsvw2kn4z8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q7M3muTAHD8kpFjXtUyq3zi080/5t6d9tcPFDyt+0GAnhnpvzR/rbfxPHP7UTk/66
	 4ANXrAxnDo+uy+SrKkekWheeh42CvDD5kydArSKGJPRjDhEGumGaz7J8XY3bUTlRZG
	 iDYfV8fgOqejlgb7L3KGjBGrPuX/tQIcK02DLmrAaV0KFl+nqRs1LoopsbmWE3lDEx
	 Il3VJbfTZ2jJAhIFBQTVurI7tVRifvulia3/xJTdPY1JerP2CjTygZCrlGLGuD2pb7
	 zEnXJP8qbxVeY7oVSLiaEs/CyKbUfDGEBEjgkT7vPUcrYyJuVT+cW8Jo63csmm8K96
	 +xTlky2qxWflA==
Date: Thu, 4 Sep 2025 06:58:31 -1000
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
Message-ID: <aLnFN-jJkVzL403b@slm.duckdns.org>
References: <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev>
 <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev>
 <aLeLzWygjrTsgBo8@slm.duckdns.org>
 <87qzwnxgfr.fsf@linux.dev>
 <aLk0FuezkcInlM_r@slm.duckdns.org>
 <87h5xi1e6p.fsf@linux.dev>
 <CAADnVQLBrOgeH5T2iXa7nNpHTtQvpzuzfOgEgPQv8T_AKEg6mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLBrOgeH5T2iXa7nNpHTtQvpzuzfOgEgPQv8T_AKEg6mQ@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F85540007
X-Stat-Signature: hxrb46pdi5f5odh19ocupa4nhnqr4tkp
X-Rspam-User: 
X-HE-Tag: 1757005114-893392
X-HE-Meta: U2FsdGVkX18T+UInGUP6hyvL0DnqLUHGnCk+nmF3XuF1LVy1v4EDreFpjhV4/pGcUlNfQawZ9u1HHvMFTQr0lZwkEhukl/wAvMomu7BU1oTaFfkD4orgXZ7c+s8AqC765b84k3PxDHup35xN4MkPpibECsMLbSLxn89QrneiLWW/m7Fao2h5kagvy088FGyK7sw7OAHHAv3yRjRFwzqHOKOiDpDVZGG4L2DREfZ/ilhqy90AmD1ektKJTQwcikqLsk3KUWt3AFswkz0XQ4xefElNrn374WhT3cnbg3Q+0Zxmr5Xg77WLbdMbtpjF4YEwu3KbeWLcUwTnknz8Th1rqXq5ExlbHxXJtBf1zDoeOSD9njK0yEA1WMPI5ba7g8SpAsgAo08Ph6J6rRWaA2an/Ot/HulM4vhtzI3RQ4+SWi5NNlXCJb/6eRqvUDEH+LQsJdgC20j06JJnHz1YXvSn5f+yj1x0FefTm5Nu6Q1qBno44sTw4KOwQU4wQL2YLVdSO3x+zzvlqyYcFpIhslNys4WdHB2xVVTmyqGB4Fmz2fwK9OTRNSkaTlCD+vR+WY/IjfCIhBMwCSDrJDsJJSDGgByZoc9sG1g+qHBpoeX4od5gkSVdQEGMuDYNtrl1Au+EVFdYpYgIQSnwRreEX2jOOcBDbgpaLIqpQv0E/sbLVzC3WI0j/H/2sPcZjHrVBaR34NiAuhppLM3I1GInO8wycYlo99xziRpiQU9bhfrdGsvecXJUdhcjwGZl0LzXwyAj2lhmuVMNUAalhlzj4v+E752m35gJHH4YOzKb30vioqNOSV5oplB0uAdYZcigjvFJOJl6tNnp73WU1aqjJ/MrjVCZlcu5wDl/IVECVMcbm2F6bA7a0azp9kYdFXIScfYemcORYQL5HbSVVjND2iEGnsFI5BMPkNtwaBwab5cuaqvCdySXuzLczSnRizaZMErZ9EZM4BzT8+fvDCDYQe0
 QBCaUQUr
 hXT6MwVhNt0fX/xplzWhn9f48Cn2L743Vs+YGQLnk8aYAxGyjATYRnuTTbptrsTv/00haiWDHB+kXjByxJ0qoNt344vIxTpTq9RPZahzl4NGQha9cb29MOwGHVDBW8YEfjqKtv15Py4Pe1XPb8s2h81IB4LN12eyXLJnOm22RkQ0ZcqvbDQbXztG3ZpPMMOtrcxiI/XZBKPH+v0dWw1rZpKOq5SJ/T/PmrQXwLKZXDnUJMvRmJ0jV1CGSFK4/gaRNezheNDQRv9yrke5toKxHrdMEsv9w6OoUMAMX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Sep 04, 2025 at 09:26:45AM -0700, Alexei Starovoitov wrote:
...
> > >>      err = test_oom__attach_cgroup(skel, cgroup_fd);
> > >>      if (CHECK_FAIL(err))
> > >>              goto cleanup;
> > >
> > > Yeah, that'd look better but are there practical differences? The only one I
> > > can think of is fs based permission check but that can be done separately
> > > too.
> >
> > The practical difference is that a single struct ops can be attached
> > to multiple cgroups.
> 
> +1
> Attaching the same scheduler to multiple cgroups also sounds useful.
> I feel sched-ext should use cgroup_fd too and do scx_sub_enable() at
> attach time instead of load time.
> Then scx_sub_disable() can happen at link detach.
> Looks more flexible from user pov.

Nothing wrong with that but I'm not sure that'd have practical
user-noticeable benefits for sched_ext. Also, would it affect how associated
programs can identify which instance they belong to? At least from sched_ext
POV, that's a lot more important than the ability to attach the same
programs in multiple places.

Thanks.

-- 
tejun

