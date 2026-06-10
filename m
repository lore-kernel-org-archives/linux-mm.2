Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27FFCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 05:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134476B0005; Wed, 10 Jun 2026 01:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C5A6B0088; Wed, 10 Jun 2026 01:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021736B008A; Wed, 10 Jun 2026 01:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E82286B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:09:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E27F40882
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:09:39 +0000 (UTC)
X-FDA: 84862825278.21.8008EB3
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0E60C000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:09:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hzp5pVhD;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781068177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RHcfWFsJiVmAbunXLJMpnVW4BYFuN/HfVIVR+xGLhEI=;
	b=xGGqicUfS7BSsLC881TzqmTPF+MLgQWllw/LirTvwa+wS2DoUKRO2RJl2bL3g8jPZ5zsit
	kTzSGBpWDLE8Q19kb2H3K4Zapl+jU6d4uF6gbXYex8/MxqHH+x1MU2BTeq/p8rPlRJrWkn
	3qFHzNcoDBlr1AorKREuAwVKaJTyUb4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hzp5pVhD;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781068177;
	b=QXgbYedyAeh3TN/+4g1fKHcmNRZqpCOanb9gIECTzHEF9YeJg9o9sXax2GDJNVqGgXssV8
	AcLeC2H3JzKoxZvpD7kEK8Ej/IC5EoPGN7ptOjfZFvDXlaZd5dhq0wqzoFh1k2OOfOefh9
	+ICijsinakOYARI4VtNc3z9dXxi0QLo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=RHcfWFsJiVmAbunXLJMpnVW4BYFuN/HfVIVR+xGLhEI=; b=hzp5pVhDHzkGjEcskk8K5YTF4w
	THr3gJHBdtRQFFgqjsAsoO6fdixFyGmx122vU0xpz3axRJBjX349/KHDmcO0t8sH4xw+Nn0lt/jY2
	SCXUJZfn5c4x28vA9gBWC5UStdt2+Xc6Yb2TjcMFlrA/5I6FMTEWn8xqpZJhbkdDPRxN3o2uieafk
	4J+vNNegmU5IXK2JiB6U1o0OAAZk3SKxDW0MlWQqStNrM2RwBxeKqXqhzj2P+8ZrXakgBxE+jXi+6
	pKl3Mfd5HH7xMDICRjPQ+ZIGawzxVsCyCGtqfxXuC327udHGQrdV2ws+61CZGoJ8rbu5CP75oRNoR
	ypNc0+Gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXBBn-00000004AT4-37fd;
	Wed, 10 Jun 2026 13:09:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2026 13:09:19 +0800
Date: Wed, 10 Jun 2026 13:09:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: luto@amacapital.net, safinaskar@gmail.com, akpm@linux-foundation.org,
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org,
	dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
	viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aijxfxXrWLCVqV6-@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0E60C000C
X-Stat-Signature: d3qej74uetxofbzoio3oa3hmru579y9s
X-Rspam-User: 
X-HE-Tag: 1781068176-333328
X-HE-Meta: U2FsdGVkX19C0P/b3vD6TsJiPmb1EYHkc1TVs0gPb2YmShSu+c3mKYeq9rS1DWKQancnqrARbXFffn1tv39twikcu6QBSW96U8IZy1rlJGSf6FRB3Mf+OgA1fUbcIahF4QO3DvPSnGaRWRHJsmFWsvD/J6O3KR4moW1Bxng5BlFS8Isl80xBci5qxDGZf9jz4yHCdRqKZkzF/d6XHMdQU1rwc3qeval12w/0h5mILYJIkfIJeWasZSooDFlt3wpHHQauS6mUzLoA5thO9eAd54FeViXCHqv/mRiNe1S2EtLYXBXDEJg1IE8qwhREuDjP7Mg65uiT9sPWRupb9Q10NF1HNe+yBsU2WKA/71ElWTVCz2t6vku/6ZeCg8Icbi1EVP1K2VBdyPyosnJQrbj80PM9qngQI1jQ8J5afSuL018MJ+P7EDIdbCBI/TBAhx1uP5I+tKgK0LOxMFrYZqFN2PA8oJdQNb7hxePOiXUAWd1SFnpr+yu8m0833e5JcLJqOLatsvAceAsNPUC+V0XvgVCriodEpih0O1gIRsTXcYXMTvpNPX7+ZUrVFkqnjtZkuT01+f9VHg6n4K3HjkWJ90cDVg5Tjy9JaN5yGG1wjkl7onixm7T/m5OuPGh12FHmIqLb/CkU9l0sEuaYfRJ5CsEFEND3nFVmf7BN29boBzDsr9ZYAmYLqn3YKHAVukkUPnXpvpGez2waxzflxsnUrTmKmnAISkKMDeqIONjfvFE1yaIJZpFg1OQu+lw+sV9f1jn8yxXYCLVu3mqewYW/SQUWomqRCUcZhHQ6/seyEyd1AXC/9F/OsFZUXEykpEuvxZ0g9N4qyBGsI+uP3+B/hU/3xy/Id6dwSloXed5ImteyfnQbIiCEuEjUZg3nuRAOjXN9QHBF/vcnPj8y9iWRAB2jZPtM7jfZZB4s8dtihnBlqx3jsznx6yUoa5CEI5BhRIv91m98WTDY9pYqW1o
 c24WatVl
 mn0VQo7DybIFNO2BaPxWJOHDQbKtQpdkZJ1SDbILTYaMp0mB8ett7THKosenIhueZdXPewTXzrOFjD/0e3NKzzTBCwQmvHqKswLAGGTBFC/YOtvApSEoTxAXRFJzzPz/ay33B+bq1JTogpdyqnFNCGSZnScmMtVd6Xa+vPVZkkjIu8mz1C7iRuJXSnYu9uMPDGtmrf6xYJz0PZYP9MuucsGSWxzYE+zG2dlixg0eTYZ5h46/Bdj1FOKAweLW/3lYCmkgWWVItsRRjVww0VKJ1XHbIASRoV4x8mywZSDkphvY5CRkvP1wP0V80rCT9vyQf8ut9GfrKluoplUet8vvjpLBiTVUrDSqLMWBga1lKyeJC+cnzXFg9qc0xmePvgpbZ+ugFcwFX/vTx+1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Because I think splice() is a *cool* feature. It was always *clever*.
> I just don't think it's worth the pain it has cause.
> 
> And it's been around for a long long time, and after more than two
> decades it's still most definitely not _widely_ used.

A couple of years ago I used tee(2) in dash(1) so that we could
avoid reading the input line byte-by-byte which is what every other
shell does in order to pass the rest of stdin to the executed
command.

https://git.kernel.org/pub/scm/utils/dash/dash.git/commit/?id=44b15ea09a9ee5872cf477e4ffc6b42ef37d1e46

It's definitely niche but made a huge performance difference to
this rather common scenario:

echo 'command
...
rest of stdin' | sh

I didn't even know tee(2) prior to this, even though it was added
way back.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

