Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C4FC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF10A6B009B; Mon,  3 Aug 2026 09:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2146B00C0; Mon,  3 Aug 2026 09:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEF66B00C1; Mon,  3 Aug 2026 09:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 964756B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:02:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4592B406D6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:27:00 +0000 (UTC)
X-FDA: 85059882600.24.EAEA5AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A28A940009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:26:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWteguSB;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785760018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xN9P22vbVMJceR28tbLqScWHW/CS/fqh19s3c2LZmvE=;
	b=MKY9ckYY/hrhIxq/P4JnGzvhsUIVzZgMWEZun6DZte+J46ka/NTuQuFMwpeEU8Kvg1KPtu
	qZjPbJF8Ax1M+hKmC2jOuxBM3Kqu8dqfEIKazAtwwlkkrHzW4UU9919hE1wkSH3XUyfMgr
	YJ/UO6cW9i3WxuG82K+d9SIDB7Pr7EY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785760018;
	b=kNYwzsG+gPAfMH2kd1PQeJhf/o405ChXsBiUnW79lUnYt607BtSolhT7aurcaVi0+CxUvt
	5AzmBbWJP7tU44MQsUw5MHJVzKPALs71TfKlZktcrGOeflNEv/vyYTL43pR5MEcHkl81lA
	Q2Bj00sRxjwXKOkQRob1J2j34doJJbs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWteguSB;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF1C34072C;
	Mon,  3 Aug 2026 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276EC1F000E9;
	Mon,  3 Aug 2026 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785760017;
	bh=xN9P22vbVMJceR28tbLqScWHW/CS/fqh19s3c2LZmvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YWteguSBNDf2N2WtMJCVXbbeG6ArWQ1dKYNjCkbvP1YEFEELcNmOlYA1ZQTUShnSD
	 2E8WsyGkkJ51XhKasVhJStI9snDN7kIdexgnRJIbi7/tKqPfUftKK+7CHYAr+ciWOX
	 CU6I4xU3q6nolZ4poCda9bLihmDRNxJI7KKZoY/+UhNjguI/xou7vYnqlR5BxqMOhd
	 wxUi3MlBJt8NDHW24TXf/hc6mVUFnHT1m2+ej7Z5M1OIdGImE759XivwynmL3prw4z
	 WORP39Y6GVr06VX/V0GgmLDpFcj+5Aa6TDTCR4Y+9XReqrUwEsR77Bxa7llaMrLn/Z
	 r9FuqkbkgLVdg==
Date: Mon, 3 Aug 2026 12:26:55 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: paulmck@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
Message-ID: <anCCVU7Y6lMaPmAT@dev>
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
 <d2cd0e92-930f-44e4-96e5-67b751419a1c@paulmck-laptop>
 <c4057657-7246-48ce-80d0-123e351a921b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4057657-7246-48ce-80d0-123e351a921b@kernel.org>
X-Rspamd-Queue-Id: A28A940009
X-Stat-Signature: 1okafazb1esq1kdnezty8np4c8yjr4cp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785760018-791031
X-HE-Meta: U2FsdGVkX1+kz1JwzkiytVApURGhPFMXq0NHX+BG03yxBodSOOcGNQGNVCm/pb95laoQshMbZVLUcm0nyuOLDJ1JjC3qsCsSZzXznCLI76mFjck/xSpnkGaoFe0yhHcK6+tr84gbEYc+SmmWAOksIjUZK/rEPsOHlMgJV8ZPq0GFIhUOyPtPSoO/9dTxPGRo8xCDT7IV6cr1zjjvaJCH6IDMyPPDyx4T0KewZxwRq+q1fO8nzUZzi0xzpXOw6pP12J+xA0taTYpYtNANbCE1ae443l74JH8XLuPZ7QfPvnNlfSp5LmNJsJTwZwpPHtBOiJiVQgdzIWrq5PkUPDfbdY8x+/XF+r2iqUVCu4qrIeZu4XdvcxBfCLMPncr3zk1tFi7AyHXipkGeRIvX2gee4WCtTShBII6ngn8ptAGjIux5zwKUnSDtzcoFxbiaaOKM4ouieEOtzFJTUdoxt2NwxIc+TzpVVlIhkTFf3eSVPc19G+/VRNtYCkOtRuOPqmEodt5aUKQJw0DogBqxS34PAvesxoUmfYrtQF0iUo2QxP3iFONCWUUao/kBPgSsWsM44m0s9hJFQd4LQtvfOGZuepsHkGIeElvXh4zd5ekWZOV913hNfUryf9v3pRA2g+NTARZo7efm7/+gZaXjX3lqAQxq2s2TyKdMvSyUTkh0ktIxsUnvA+m2okXG27kj/Cp5gPKPW2n1iXyAk4AcatIvtHhlBTA7KeZs9+KRKLLc+p2AGgOU2jiEZdBzppZnv7Vh0nc4i1qpeTN6rYsbvdjEb6AXQx563Rpj68xfEsotzA00XG/wU7MoZg+M6Tt+LuxE7VnSLxzE9MQyV0L/o/SBW7eUMDyiFR2zX0fO4Z9p68MpyeN+ytdBOrIX8gVJatdZGZopZqELHHotcfpereBM2Nqyaq7yBM7IfTA0ukQmGcL7NCzT8YvdqlDWy1ik62yBGNnSXx5brVL8Pxk7aDX
 g2/fXX/h
 WKwp5zGGAXd+LQt+clxFlrEVtMCBjaBbAIBu1nnRxNXkrFIRpQSuYcyoGY/29ubgqy8mD/Ofp/z/+6DmPnASadRuRBA8XZGI6vXfCDxioJiAejEKQRLFjy4W8cxA62jX5X9iowz5Ca8nzek/zzku7xLA95/rN0WUIVxzOESuRUiX5OM5xG/QFD1W6ujIdPpJXPLb5EbsWh9Pi2jpibanE67aJB4WrknxmkPOib8IczLxyxv468Zxln6tWEyl4TSbH/y28m25Zso2Cw7YYW2owZK6Y0gIkiopcDtPNs+vrhJ7Cw94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:59:44AM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/30/26 22:59, Paul E. McKenney wrote:
> > On Thu, Jul 30, 2026 at 04:32:46PM +0200, Vlastimil Babka (SUSE) wrote:
> > Which reminds me...  Are you guys interested in taking the kfree_rcu()
> > test code from kernel/rcu/rcuscale.c?  See for example the kfree_rcu_test
> > module parameter.
> 
> Hmm, we have a slub kunit test, but I think no such torture/scaling test
> infra. Maybe once we have that? What do you think, Harry?

That'd be definitely useful. We have been reviving performance tests
every time we wondered if it'd affect performance in a surprising way.
But we've never put that in the mainline ;)

Probably test_kmalloc_nolock_and_friends*() don't even belong
slub_kunit.

Perhaps worth starting small with lib/test_slab.c, and slowly
move/add torture/scaling tests to there?

-- 
Cheers,
Harry / Hyeonggon

