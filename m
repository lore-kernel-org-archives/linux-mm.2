Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4F5D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB316B0088; Sat, 20 Dec 2025 00:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E296B0089; Sat, 20 Dec 2025 00:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5076B008A; Sat, 20 Dec 2025 00:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 961C26B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:21:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E98514045A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:21:00 +0000 (UTC)
X-FDA: 84238700280.13.1EE5AC0
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5AAD18000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:20:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mf1nMu5P;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766208058; a=rsa-sha256;
	cv=none;
	b=kwyffDNVjuXtXt8kvi9S+oBj/0kjqQpx/Kep7AP7FllEOAt7ymW5Ht7iZfvO0r/B2XQbgK
	Ua1MtDmiGhttop30JTsRrOYpL1p7314FKXyz72XbBfiAOKGItV40WRtbfcWnxYfI/89uyR
	yrViyVAEQ1vUUS71XKxSrL4fpD2NPVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mf1nMu5P;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766208058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqDEhQp8CVG8lDjtgTLrpQdaQ9VpTAXZ80x9h0TOpys=;
	b=j4mBG92Ts821tP5GjUf2vq5TYVt+lEdsgzqNIVYrwWHqYU/Z/N7qNAKfv9Hgn10X7iAA6P
	r4kQaVwRshtA7NTT9En1ghB9zIa0IMAV/lkKIYSFdkGrTrHZBgy64k7VVzMACEgqPPZ7Bh
	gKnsgXc0kxaAyinRJ5NGm9o2DkcSLCw=
Date: Fri, 19 Dec 2025 21:20:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766208056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FqDEhQp8CVG8lDjtgTLrpQdaQ9VpTAXZ80x9h0TOpys=;
	b=Mf1nMu5PoKfV5M8Nonvx8tWbqyFtiONbhEehUZVpHiXAzwhxFi/3Xo984jkG50veGmiMZk
	3XKJpCq3YxenCKjix+Xqe3nRvFokuNjBLfA6DWqTikI/YnBCIYt8VEuBboDmeBeyde7+PP
	DCw4h1BYUstCScl2vhAC2At8Woj0N7Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v2 2/7] mm: introduce BPF kfuncs to deal with
 memcg pointers
Message-ID: <z77od372jts3d73n77v3o7dk4ro7hizuj2zn235vmbltwjnwfy@zkamyu7gf5jj>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-3-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220041250.372179-3-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5AAD18000B
X-Stat-Signature: zrx3qoknj4whhfg5dc9p34uz4ta91gqu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766208058-621971
X-HE-Meta: U2FsdGVkX1/qtSAcHTbZxs2tjP/3UkmaG6IUiuuBvBU7Shfb/g2XvSXZLTjrqCWGNwt3GdE38ro0SmVjSxpJAxiBcQvS/+s4PGqHH55ZDROufHF188eKglhexH9DfpPtR0Zm4lNpXSIdiqeBsxJmI3CjttWq0NZKt3dm1EccElizok4egjBF80F891yUcZndZAxhBpCQKfn55o/LhHNsImyP0yt7m7gLNrYwJcX8kwbI4sN7K9agAVyBzKKGnMfGgqF/ZI1dxOZ7Fc6Q2Y1MJRGUk3pxrGysbFzE0nrOqAILFHEqS0M/GPlu2V5naex7lbdBu8qe4VYedGDZ1vant3e3Db4O+P2uBYKp8rdmt1swXADivF/Mqu95vg4uy7wygK+3FtdADmEURV5z+S/YJ/TP4hSOpZVK2WPGgjzTPvP9MNBLMAHfjJ4zh1bA5ULi3x2ViCtT/GuWGL94VDnn4CNx2n8Xg58vyQc6HwQhvdZJUWAqIgsdGQ2Zr3iSX90wmR6zXgGEGTBE1N/DfbZNP3pdFC8uXzr+9YeXWrD6CcOhynZuaj0phUP8WPu2vPaVeRAOQfbCdy89/j3I8xeVjYZLFNMHGx1jg34sPvmMQtCG/rq/lHed2en8NMCTy41V5eR2gcnksVv4Hpug+nA9jVdc6FToOhfCKq4dWrP3fyFJP/MgHi0j/pcuN492kbwn4dnfOzr4H0+wyCpyzdrQ6OP51M+smp5yGbt1ppaPKJX8zqx77YSTs/9SFrBUhcnpnAHrJ84e6iuXa8iqDUI5Kqw3cn7fksrExNb1LOw7mXN0sipCMk4PbBOjBfO8dkHLy2hblScSbPp6ItddWnQTnidUgAJVz6Wx0m2KUA9bXRtJFj1wXqc4njkW3jgzyZ2rvtAxWG6zwTZ1033h3UEyZ91CfMtN+qevyykzJAoGnjX/jvMPSgNuoIGeZMFafMblTvAjKGgs4ry7KwUpLYa
 x9cpcLGu
 Z67vahiHy6pBMzCW13i0/sPtutzcevlewJIeDj/Ft1NA7HAYMnu8VCkv/kbgUXJ4sg3VRjtQRAlggCzon42JGhvXNnggIJsCfOQGecCwiwQkrc4Z7G3Rr5xg9+3uRG9ixiA8SvwXfF4sadHdzIXTwApl8qpHp9t5zk/IqA0O+p2+Nt+WltU4fdNGi9KtGResModKXXg+N94I/s4UbpmHndUeLGe51D0FohN9S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:12:45PM -0800, Roman Gushchin wrote:
> To effectively operate with memory cgroups in BPF there is a need
> to convert css pointers to memcg pointers. A simple container_of
> cast which is used in the kernel code can't be used in BPF because
> from the verifier's point of view that's a out-of-bounds memory access.
> 
> Introduce helper get/put kfuncs which can be used to get
> a refcounted memcg pointer from the css pointer:
>   - bpf_get_mem_cgroup,
>   - bpf_put_mem_cgroup.
> 
> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
> cgroup's "self" css. It allows it to be used with the existing cgroup
> iterator which iterates over cgroup tree, not memcg tree.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

