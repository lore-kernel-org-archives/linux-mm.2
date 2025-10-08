Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E96CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 18:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205748E001E; Wed,  8 Oct 2025 14:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5BB8E0002; Wed,  8 Oct 2025 14:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E088E001E; Wed,  8 Oct 2025 14:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E76108E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:17:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E33CBAA7F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:17:59 +0000 (UTC)
X-FDA: 83975755878.08.B42C1D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DCC201C0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:17:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GUt9NBVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759947478; a=rsa-sha256;
	cv=none;
	b=D+AHa7fhMmW+2E/z9W5VgbVIOyGfOkhNvCpD0cIclq55fGSL/3uc8ie9PGriD1jhvsnDbI
	olrx6Lpw6SjjR6EOlCPx/h++XHfEL9Sdh+0u53MD0ag3fEe3UBUcuAiIVwXWkl4cpSgFCC
	g/nzUJ8TOebUoqRIk0eC8/hndoSYeGk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GUt9NBVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759947478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OQ2bk+WQoiuRq5BK0S2k2XJn2ltF1vtua2aBfLesSo=;
	b=1PueLPEF9sNwzoDlrUcBZD6eLzu2EJBXRL2JRZOpTwqN3Gqr4k0nvYz6AB1iR2+v962qw+
	m+703Mi+AYEbxGE93vALO89QZN/rOKlPJ70f9Dj3WYE5/1VdlgHu1LQcWF53Pft4505j1h
	pyPYlBy9yh8TTvefXL8XGHop87SxTR8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DF6C40BB2;
	Wed,  8 Oct 2025 18:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88AC4CEE7;
	Wed,  8 Oct 2025 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759947476;
	bh=4aQzZE4dPKYLC7wE9e+3mYUgK3sZmtIL+KSSPfosfqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GUt9NBVmokoT4ZHWQS2ZfEzYW9YwNbuP1F8iFd9oXTaOge9DACR/POTm/b7hf7nTE
	 D8NeRBhkov7umkM+ojr4jlvj5K5NMZ2jC1tTJUGLS6APxkkFjdJrvD7R6eSz26xPUy
	 OSwziBUZXFcoLJIyC7ffGhxPeJm0XRHHnUjtVHB2pV6MDugaF3Z02jU9/fquKH+XES
	 kVm4CQhouvOLTs6je5l1/iKeXfqH8aPwKl0DVwfP31DtHo0R9u6V1KARZi1qBLlIF1
	 rFkJuO/nZENaLaTWVGNKuJoCf9QYxinbpR1Hu84vXb8otD+PMj4mbhMRdPZE1mFAUJ
	 vyv2kaNgm3NEg==
Date: Wed, 8 Oct 2025 08:17:55 -1000
From: Tejun Heo <tj@kernel.org>
To: Matyas Hurtik <matyas.hurtik@cdn77.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <aOaq07jS60mHYGBe@slm.duckdns.org>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <aOVxrwQ8MHbaRk6J@slm.duckdns.org>
 <6cbf24f6-bd05-45d0-9bc8-5369f3708d02@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cbf24f6-bd05-45d0-9bc8-5369f3708d02@cdn77.com>
X-Stat-Signature: wy655gg1975zh7mwzj933okqcw4s91hk
X-Rspamd-Queue-Id: DCC201C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759947477-881854
X-HE-Meta: U2FsdGVkX19vONesBXNkajUWvDGEhaQUGWbxVutmATdl1mE4B0iGvHgp8mEn928khYbNwuH6lPGmsEMKrt4x/j+k8TykCo2aqqCW9lt1JVZ2zNlGUE/E+8gpZC+pRsxhkY0u/GLoF0nrA3EgLllvzK/3V/pR3iEiLKuQ2PdDxVr+0ODOof0DNjhkxVwRW5h119ZxvdSFBids7Phh05fJFwgaVY6z5dJBD2bHDp8lL815i9sWlJX0w4gQmM+iCObXk2ax2J0LVfOsKIh8jH/NzbFPo8qjiz87K1GXjO8LwrZNtEVg3fHLJUw7zH+akNNvsGTUGX97fg136WUIrvQbvxGwrY2pEglyXin6U/jAeSrDTysvGafAz7J3s7DcZrUWIa0uPgNK0ne8AmR1Syq6IflUarOGtfMZN4NQ/+ZmiuU3w2mP3Y1z3Sjw7PUTNEGt1Vv/imCOp8/jVFgajp0zEC4OsTbVr58slntBpD3CbkSeB7ZRwwLoBDSJFkimvbpLCOXJ55uuRtNGJkUPVUGGinYEbaBFsNaIZp9J5A3UEPwIeayby6iJbjD31uHcG0tpfok2i2+Qnjh10oSEiLAy+P9mPRLaWwxC0rqFxZftwQ0ffsjPQ5tyODCiKBWJIGeeZ9n4hLsiYK4yHqYIrMrfK2yJr8dhnctG2T1HnC3cCkMjQpEYdhg/lx2LJojLDCRQd1sUjWSBC7isBp5G84R64ZJ/6kZll66wYTpikrTLfegIFiNU023k+uKPCklnWbtPy1h6L/GlACmbRDz9sIXKO/acjBNFuvm3wUrUuQ5Si6IqSMJM10/RcCD+AqyE9+VENdUeGMfBcgcV8/JK3ydqD9ClPf7+XOXg5a18U7CJjL9bPpkZRDhwj55RqMlJki5b1MOQZUZ/Kd8R3E40lIyuF0mas29b3xhKK5HADC+jdl5x4VSBCxfsvzpUvl8piZi709/Zkh/xEVTNDSfoTWu
 votOkX5m
 RY1bZX3CH/TrJD+UegRV/8fB2F38n5JcPXcAj4XTqz8AWIVdWzyvMH4s/PTxYuz6cPzIX2aRtJd+2Jdu7d+KDWPgqpeDvYBdEg/XuvmoAkE3GrsY+1P9kn21ccoLW9fGVZXT87JMP8Hs8PscJvnDEveZXA0RPt19Ad/E3zdsD1t/30NgO4lsiPTW4x+4MEXKV5az3ScJOXm6imSKmj20GJPWHUEl8odtQtkBPi+ultZgQlOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 02:46:23PM +0200, Matyas Hurtik wrote:
> Hello,
> > I'm not against going 1) but let's not do a separate file for this. Can't
> > you do memory.stat.local?
> 
> I can't find memory.stat.local, so should we create it and add the counter
> as an entry there?

Yes.

> Regarding the code, is there anything you would like us to improve? I had to
> rewrite it a bit
> 
> because of the recent changes.

I think memcg guys will have much better idea on the actual code. Let's wait
for them to chime in.

Thanks.

-- 
tejun

