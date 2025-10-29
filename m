Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B766CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B6C8E0114; Wed, 29 Oct 2025 18:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13678E0106; Wed, 29 Oct 2025 18:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FF38E0114; Wed, 29 Oct 2025 18:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3BEC8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:53:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6771213A498
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:53:28 +0000 (UTC)
X-FDA: 84052654896.22.DBD84E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92677180015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:53:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNSYdcVI;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761778406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywJC3icbH1rJTbtfxjNg7bAjByQB/Wtaz4snpYmxsdU=;
	b=pxR/AzDXh+5mqGuY4pizTOiGZc0HhZJileNUq3Xj91t1T8ciKElRmT8HktY/HeZfS9FK3b
	wzczjE+MJQi1lUH/h9r2ybz6FOwf6hr38f9W8188rFh3vMCTgAHweWRcI/NkBKdTNJal64
	wEx0VGn0vSrsRFLit/83sEnVH7mncGA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNSYdcVI;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761778406; a=rsa-sha256;
	cv=none;
	b=QQCFox1y3Gz0r3Af+PnlDJpJH9iWgZsU2PD+duVr2Y3xMqStJeo37AFKM9tFoxzUIzC5uP
	ppYNomim+QA1seNL0xF4kdf3nf4tDL0rdU2PTPLUNc6+qn8PbOHvPytcxo5RY4aUGPmIwX
	GiXziOPR/B5o1rSDq56V0eODjKRVJPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9D9760273;
	Wed, 29 Oct 2025 22:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631A7C4CEF7;
	Wed, 29 Oct 2025 22:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761778405;
	bh=yggvcjk/2WC81qOKt/PWdb/tjbxgvfTjTX2rpHVXUJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vNSYdcVIlQppVl9XK6Hmux4x204Rz0Mjmv+zw+0fcgfwr2x5GT4uX2JIaJmKiL//X
	 +aVu/bx794bAn1J5gyNKRxxVz0q+8aZp9uL5cv8EqLQOy8Lyt/hP6VcqQBR/FvyaY/
	 /QeBzY8X2r50hITutJxTZGLKOmj5UHqgcGJXQu1/XGEaqCUzqPwlFf7hYBuQgTOnvI
	 36PMZHtc6/ylag+OHYh+k+JFW56ct0PXqZZzkrq9q1+pn8B5JxaHI58umNFDsW2n2V
	 wOBsUqUMv5PrXWZdrlXBAU1YQZC0UIRB+gnQWHO5sJEmr/2Sxzfw9OChifWcsUkMGI
	 9D4KgdYDIKG4Q==
Date: Wed, 29 Oct 2025 12:53:24 -1000
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
Message-ID: <aQKa5L345s-vBJR1@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
 <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <871pmle5ng.fsf@linux.dev>
 <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
X-Stat-Signature: 7kdwi9en18nimziojjmmzhhr8abuyr6h
X-Rspamd-Queue-Id: 92677180015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761778406-47938
X-HE-Meta: U2FsdGVkX1+oDuVJshMUUPMNCBzkDNWRh87mB0Gq1Mabi65Y2ISXaCN8Z+2urFKjEnUFZB+DjSCG+DfHRcinDL1MtloscnVo4+ECw020nOAhxw4SNKnrE06jHjc55WU1jqBBrFkru4nIzmdQmg4Damhji+07UdOw/xbo2/1lgTLsA5dmUrPVVm413TakdaHeOu6LxStwoWsygKN59SYvHtwdL7C8vFFCJU76Q/umzFlAlZYDOg0R5m+qOkpkB//7R2SyDmF16I9GMfqZhjqbnMDGwp8xsk/FMYlJtAwm9prkZrq0/M9NCAH1N5ch2EX5oM/mfSAoTmivqsw30PocIjdaOtbbx8M9fKdVg5k4AknKtzjHIf3Aft+Z0ORgqBG1Mf7GMb4vizOqo2QDqkKvfPSq+MDA9pufZUwIqfZTQQh+2JoErdFPB+ccpvkygC09ZrHqVxwYhh+Ig7U58be7u1XqOyp5dTwFLneLq6uIpNw8tgg/uzuDJEUfvoLujpb79z3jAYhB0Z5YelEsTyb9VJDVww/E2huDLZOMptVwxCd8wOL6sbqR2RJmW9VfLfM+sx3y/G0I49GTUNj6h1B28wddwUL4F2cGt7P3VkPCCX6HAaFniUWuq8ZwtPGfj01x5jwqFGv+Q7WrL5QNR8c32oeVy5+RXsbaVGVz2SGMZr9AUHECarQE9FxIn/lVJsoC5reHxVzd81UPNp1rE3SsK4tWwGkmANhuuuFB0NdyIRLIbqXUpBCyEaWi8DnRyb1tje1jN0ccjO1Qtxpr3IJ0pPbQZ6CEDgPXJLI1WOfpGzeLbK1XId5AQ4bFX2oDi07GaL9ZmWpOQwwPzL3H1zcqsECJSixdAAINElwpwxLn3BkYzdebZB1opaR0Hb23roefJHi84ju7KspsCu4g5bOWpu5nNjdS/yUdE2nRMC21Wlhh8nDhTcqqYxP+Vi+Ipdblq8A32S792qMTUrIGj3U
 7+MoeMot
 9ttQENiufAWpSB1bERb2mNTtTnbhe1NzhHTbEiaOSY0b+KuuEiiQ379jppHe2c2aHE8aLy/wTR0/4q4a9MztNFYTkNdkUUomXj0UktkW1mkOS8preuQOw7Ph47DwsQ8me9QHAy+eOQNVgG/ETN8xlurfMfO6UFWnSD6gh5U6ed0BS5H+HzOKnCtOUHXIMYlFHvvyBd84JkGMqg9l8wW3ihaLZHhfTHbpUQwMiK9CC+Xl2GHz5KHhrhLnGZ39Jb73/7Yd6/rPWjJnfVtKmuwGXMILxt8y4heTmvwSK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Oct 29, 2025 at 03:43:39PM -0700, Alexei Starovoitov wrote:
...
> I think the general bpf philosophy that load and attach are two
> separate steps. For struct-ops it's almost there, but not quite.
> struct-ops shouldn't be an exception.
> The bpf infra should be able to load a set of progs (aka struct-ops)
> and attach it with a link to different entities. Like cgroups.
> I think sched-ext should do that too. Even if there is no use case
> today for the same sched-ext in two different cgroups.

I'm not sure it's just that there's no use case.

- How would recursion work with private stacks? Aren't those attached to
  each BPF program?

- Wouldn't that also complicate attributing kfunc calls to the handle
  instance? If there is one struct_ops per cgroup, the oom kill kfunc can
  look that up and then verify that the struct_ops has authority over the
  target process. Multiple attachments can work too but that'd require
  iterating all attachments, right?

Thanks.

-- 
tejun

