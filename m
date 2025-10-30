Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C03CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36928E011A; Wed, 29 Oct 2025 20:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E5D8E0106; Wed, 29 Oct 2025 20:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD088E011A; Wed, 29 Oct 2025 20:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA6038E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:03:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BB95140957
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:03:55 +0000 (UTC)
X-FDA: 84052832430.03.FD674BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EEF6040009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:03:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2xwHM38;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761782634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFkr4yTCtBwDk1KiKNjyrbRzRwHM341oF4yWEPt/O6Q=;
	b=Kp3/R/THZTRTSiv0uw3XNWpA/NC0XgiYtcu8zmVfZ1kbK5fX4z/35wKHOeunk0f1reN4tu
	wZjTF2hofaIyEl42Y2X32FicYnl9Wz5A4IXqJsJCUwKuKIS25Y8PkfRehNLU/3A2EERdAR
	cSa33ttF1LqxIXabpP7FukxYKkd53sU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2xwHM38;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761782634; a=rsa-sha256;
	cv=none;
	b=7/0OuSoiL0Zc4j6TPjh1c99RAjPiSkQzZDQi5vr5hC+H0sMugGCV5qXBgs6nTd4Kv2+Om1
	zJsgLzWV55JZTOQEbtE4EHmFNV67Y5elOkeREYZFEnEz/+cYhtMWPoyu13H+6FjHxeP3z7
	zQqUl4IHfxqJ1w5O3+S9fIEg/OL/WJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DCFA601A9;
	Thu, 30 Oct 2025 00:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842BCC4CEF7;
	Thu, 30 Oct 2025 00:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761782632;
	bh=1XnGr1V9M31iKuMKW3cadiXKYVM5ogphmXcmc2DRafs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2xwHM38YkX0bt2FauUNoc+p8aNebX3OddEiZzpbnty76brkQojdA10bHHlhYJyoz
	 8Q0JOl4clPV7GExdOLx+2nQrAJ51ZiSOG+KsKDerEiWItE4827kdsS1ONn2VO4m4A6
	 OUH95kE6wD2yz1njEkr80MmZJ+zFV0u/jFHts1JjypsHf5fKSn3DG65xxeQBqQkQbf
	 NmIp/MWjz4cRe0I2mJ88CHgOdxMNZEPp0te5nIOHcD53vxTeYM9yurfxQIRCTFfvu3
	 38w+VTOCZP3ZPCgg/03pa3LcFGE7sRMdrnQQDyEuwhUeVdEykX3S4+H0HfwGrCjNNC
	 7OwjtmPn74xTA==
Date: Wed, 29 Oct 2025 14:03:51 -1000
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Song Liu <song@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm <linux-mm@kvack.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	bpf <bpf@vger.kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
Message-ID: <aQKrZ2bQan8PnAQA@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
 <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <871pmle5ng.fsf@linux.dev>
 <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
 <aQKa5L345s-vBJR1@slm.duckdns.org>
 <CAADnVQJp9FkPDA7oo-+yZ0SKFbE6w7FzARosLgzLmH74Vv+dow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJp9FkPDA7oo-+yZ0SKFbE6w7FzARosLgzLmH74Vv+dow@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EEF6040009
X-Stat-Signature: nkyfrmtksy3bkx39azhhxwb1ang637ny
X-Rspam-User: 
X-HE-Tag: 1761782633-293324
X-HE-Meta: U2FsdGVkX1/oDtzY9KnnCGVpPb1f10Lv+AjjoKyPeFDWsHowYuzbmheRxAhKNAHBirl55nnZTmwhwMI2fTvRZmZ0QN+C9zKhoY6rxUUiz1PNbcBsD/nR4nTDXD4vFMcnK0CL4ibPUe+womIVNNeZ14sTIwTTHvOIEPak22OUjiplFwpPbIBZHNMsXg3XQRD8h3LCQvEU43mIOMHJ1LMSz6CVwnLN6CAS0+A7aF/Bwpa8urhgJQmtKgUjFam91Dz6J+JegLLjPWZs2/ONnUFs1emR+coT3GRI3YjvJiCiXd8VM6kBQL2CAskG0ghD2qXAFsCIlL12upC5MVVCErWTVCWlQptl9blERCaxFDUacuqE9rQL4lQmWog/p3FikbvvQAbMRzTwgpRS9aitML9aCwl8TH6tW1H+DTk98sdpzM74Yi51pNJI2p/9TTEf8IdXESYTf3erAuvVd11DJvcDlq9+1HoXxXoevgqHX1PGcQt+Ax7OnSUER7HRApYp8cfIT+Kwue+HPjIXqR52YFEu+71Z8noUPSv8xqHuL5zE6LkEwJH1dbxoRriMflT2mNuVhMZ6Uw1pJs0ApDco5QfIOesmqjImjaoXvzee4pfo1Wta3yCmqgBBZ3T6s9xuKqFFBVc46heZ4ba8kce6aIug2Yp1d6w4R0lRohhm2dGH/FPnMtomgOd1FEjp4Uavr7aHUIG5Wzb7LyRECubopXrnidF7nRfM7uXbFXOfwTRFzkVyjJJhrBOiOKp4vH/yz2ciNrFgeBIgRA03JDGXWawV5gMpbtAGNLUBk0pNxOVkhhDoqCa31cKk20GQoK2FNzGF3Wrv8+bRJajwT8uYsFaV1tf8vdh90usPIpvztY0hIf2X9pCV8aSU8F2EJqMTXWMnedJAczNGPm3Uy45Vtso56Pu/TCGpz11pXMP/oSlXLzkxKJ/0V9s86uVkEQcJSsWvn82GLkd6KgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Oct 29, 2025 at 04:53:07PM -0700, Alexei Starovoitov wrote:
...
> > - How would recursion work with private stacks? Aren't those attached to
> >   each BPF program?
> 
> yes. private stack is per prog, but why does it matter?
> I'm not suggesting that the same prog to be attached at different
> levels of the cgroup hierarchy, because such configuration
> will indeed trigger recursion prevention logic (with or without private
> stack).
> But having one logical sched-ext prog set to manage tasks
> in container A and in container B makes sense as a use case to me
> where A and B are different cgroups.
> DSQs can be cgroup scoped too.

I don't know. Maybe, but this is kinda specific and I don't see how this
would be useful in practical sense. Have nothing against using the
mechanism. I can still enforce the same rules from scx side. It just looks
unnecessarily over-designed. Maybe consistency with other BPF progs
justifies it.

> > If there is one struct_ops per cgroup, the oom kill kfunc can
> >   look that up and then verify that the struct_ops has authority over the
> >   target process. Multiple attachments can work too but that'd require
> >   iterating all attachments, right?
> 
> Are you talking about bpf_oom_kill_process() kfunc from these patch set?
> I don't think it needs any changes. oom context is passed into prog
> and passed along to kfunc. Doesn't matter the cgroup origin.

Oh, if there are other mechanisms to enforce boundaries, it's not a problem,
but I can almost guarantee as the framework grows, there will be needs for
kfuncs to identify and verify the callers and handlers communicating with
each other along the hierarchy requiring recursive calls.

Thanks.

-- 
tejun

