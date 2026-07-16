Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEBFC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D8B6B0115; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5826B0113; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB706B0114; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF3A6B0110
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EB5E14018A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:40:41 +0000 (UTC)
X-FDA: 84994749882.24.63AF058
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC40D1A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:40:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=E6B3VSnt;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiOLFpPJEdQPABwKQzXpqhuXuZFKPhpE3SVrXAZwnww=;
	b=U0YvT8C9cUik9yS7LuXCcCu76iU9He8fG252S26pwNDC8PtUuyYB5hpecwoKaVl47rIdEm
	Cm254WAex+oQSRM8vAxjnr+TT/LR1zsthdUe2e6x9oQrxM63A6+UvxldtoKY5mjncI67/Q
	YTjslNsXFacLtDgZ8DFv3qKEEAzTgkI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=E6B3VSnt;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209239;
	b=Y4tbjTiOhuDQ1F5jwhfVA/7Dpnm+IU3iX/RacZZ15Z/xgnpg57rJlONhpr7/1F8tpwWQP6
	W77YqhqKlSQ3np1iG1yDL3bkbtjqtyQwsGuO4gHJmyLMCnM2Lu9AOMUqD9EA9gMDbS/zYl
	BxHOO117Fg+g505B7rBuqG0CL+kuFsU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IiOLFpPJEdQPABwKQzXpqhuXuZFKPhpE3SVrXAZwnww=; b=E6B3VSntferwOj4Y/u0/R1ul4o
	s2+zT+XIM/AN42GVotThn8bT3SAqwB9SmyUPiELBf6B3fk2hbWTyJ7E+FrSieAG9Lt1fue+pP1AnT
	6ajgcIuiQGEC4lapgOlCAGqXBe/7fUW5QbnBf6G78c4adF4+w2aY/1oeRQ4Ynk69R2IjPkEQPN0eh
	Ob65/3dSeyeRxgR0cq+swhl3Wa1KAPJnXGtxBfkwdv5CCD9rJql3isgh3UqpawCBzVEUfaZVV5Ysg
	hZko1teGmVlDAX7gjuBfo4slKYxygBOZjsPw+UYF0ZWanEEYLtrvP6n4DH/KpPQSl+pk9Km3kT8qW
	r4Q1CMGg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkMKC-003rU3-0F;
	Thu, 16 Jul 2026 13:40:28 +0000
Date: Thu, 16 Jul 2026 06:40:23 -0700
From: Breno Leitao <leitao@debian.org>
To: SeongJae Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <alje3jH32jS6D4H-@gmail.com>
References: <aj7KoDXJv3NByGUm@cmpxchg.org>
 <20260627000445.85650-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627000445.85650-1-sj@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC40D1A0008
X-Stat-Signature: rmxz9izs4mg4sutro1ni6zmcurkge5x1
X-HE-Tag: 1784209239-34829
X-HE-Meta: U2FsdGVkX185MEun6m0hBrS1GhCPFvTXP15N9/unauq44Hfhb0zMZ9MQz6XRGb6lvym7i9wO6OGsH/GcDlIo9JG6SETS1AGEX3wkRMMGTvq4Kam/MDrSNsWRnFjhGcFsXAWvT+O1L/bySdQj3R2LsgtGx5sa4e7jD8Xpf546ezmB9KBh3TW9t4PYT97QhhtwZ70CY1QFMOz4yAcSVSPHFElHYxG5MkUTmcA/rajOR3yF93gUhsi9woTOSFpOOzhZZD72GUFBPeJ8oEu2h57Kj9/NX0gZ91phW53UpdmoT2yGG5JTgpVgc1BbXAhFRB/2kvL2fDpQIRE9TBB/y8Skq/6mnfpPTrnXC7/l9EefCvQWPIEIO9MqxLdO68YoCGchHISjVg802QS3rwc4xuZ4uSL0r5d7Zb6p1bhpY+5e779NVNlG9htQ95PA/5VtEAM8xBMiKVyFT33ZPkIv3ghmxoCO89xecYgHK6gPhG2B++WIne4k9vgBgYYm+WsUYlzRyVPlkop57KgW6CU71AXEgHibtm+RpmKGakXCk2yFLYJel+ACedAWI7BbOHAVaveQmPm536fUrxAmsnkpA5/4+78Q4F6brD8SWssgg8wjAEQymke4CtPIU9RzpsU8GnnfD+TPp2+ExsMEZEQWn2goJsKVzjMPQTFRRYK0ddaqDNm0GCYyB7Byb70MSl91bUe5eyut3Ml/syrRqSnWKeBNt+GBHdcCHDGI44pqNGvpKAgaYewg5HKq+FcslMB0q5U92bYuogEJMyoqLcB74n60ixadzsjFsbiwrWgdbTGseD/OL0eOEsUWIOM8fwykfpBywjhBXKCrTFOfOczqYVe5OA5xx1hiVpxDfO+fJQYtz/lhQ6fEGsSNLbovEQ+FnAM/OF/yTP/qweaS6GQsrgkcvH/5vY4r4J409zAkBtQiIo2c1PQnF8M6TSclCz4EJuI2qvNJTv+Z1ziBFnU5sIG
 zkstqGHZ
 GgtjQhNBgO+zCoLLxj0905+ESj+R5rjMLtZh4C2yFDmjjv/TZKGnVcAEyRh+yqjTIYBuqRcj0on5PX7Wbr0kEEBIFDRiCku/F8OTq5tFL9yGKS2WHT+CrnzqEaUS3EwgQcA+JL1cwO3X+yUK2Q22GdnGurbUYKP0ejeIonzX13lzZhPlFQtCl46lOu4DfaCKgAetJKcRfAqk6mRIUEheOjcSfKf4DTfZd8C9o24gJtoZGDeTu5t5VPOMct7MLwZYYqarZBuAyyjz/SQxP6Dq7hMMtuzLazA4xWF8+gGzDTyY9FYqyOcSKaD93whiNTTD8wP8PeCX3rYsXix48gzeZnhq9VQQv6KW+S7enX/logrDZlmiebmOVreUk8FXH97h3X2BX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 05:04:45PM -0700, SeongJae Park wrote:
> On Fri, 26 Jun 2026 14:53:20 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > I prefer this way over the idea to initialize in the caller. For the
> > actual implementation, the protocol is that the thing is initialized
> > when the function returns true. This version of the fix maintains that
> > for the dummy as well:
> 
> I agree.  I also feel the caller code is _slightly_ easier to read as is, than
> adding the initialization there.  If it is initialized there, I would assume it
> will be used somewhere.  But after finding out it is not used for early return
> cases including memcg1_oom_prepare() reuturning false case, I would be confused
> about the inefficiency.  Using a variable after passing its pointer to a
> function depending on the function's return value makes me assume the variable
> will be set inside the function.
> 
> The code is simple enough to read in any way, and my taste is sometimes just
> weird, though.
> 
> Anyway nice fix, thank you!
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks! I'll respin with the Reviewed-by tags to reflect that these
points have been addressed.

