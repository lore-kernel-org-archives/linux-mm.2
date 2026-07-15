Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A39C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631BD6B0088; Wed, 15 Jul 2026 15:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609736B008A; Wed, 15 Jul 2026 15:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FAE6B008C; Wed, 15 Jul 2026 15:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3193E6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:33:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B51041C0226
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:33:13 +0000 (UTC)
X-FDA: 84992009466.07.4F5BDE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC7804000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:33:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vZzmcAqU;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784143991;
	b=VbZjGKBNyCyTbbIkhxFcpHnWYFY9Ofp521qI7eYNOoC/sS6e8Nojwb8UuJsP2bMR2hKsKI
	hM65tyoKv90jeZgtDh29o6ICtNhgpXfdOPfDRzycn/GQb8gpSjhXg2loZbhVajguShK5aD
	DmuHgyNRDwr90qJHe+dYTwDUBuhEQgE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vZzmcAqU;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784143991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNgTwmxam6nd7h0Quf1kWnjF2oRJDHmqN2SP0HCpJIE=;
	b=qp9AEalSsjtFr6a/vemQGJkpwygTX8kUCm4TWjwrtEcK1fWTUHri17cy3JhOs/jtAadZ/Q
	1tw37sORIVphTXoR39Qhv/HOImcZCjp0o4k5zhZHAeXR94v+C5dtWl/WYRvxdKpvvp1vMB
	1HiT5+Y0fOBgqgXckO8PAeCdW5oQb2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F060D61836;
	Wed, 15 Jul 2026 19:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F811F000E9;
	Wed, 15 Jul 2026 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784143990;
	bh=JNgTwmxam6nd7h0Quf1kWnjF2oRJDHmqN2SP0HCpJIE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vZzmcAqUuhtTtgFOjBIROzyqMPic/9fHZY9lG8sX3dgSEhWI514lr8ha1A4xwlnNG
	 gwVsibhPJdVEtCLMn80evGYjHGZ5pnPIB+ze1PfbqqSW+FUg2agz49fq0UAjqARp8d
	 stOqxqz85f+2UBHAhV7g1jtwOpuJQ1VtBmZan1cU=
Date: Wed, 15 Jul 2026 12:33:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, Harry
 Yoo <harry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
Subject: Re: [PATCH 0/2] mm/page_alloc: fixes for free_pages_nolock() on
 RT/UP
Message-Id: <20260715123309.621edcb4b5ed72499d31ec9a@linux-foundation.org>
In-Reply-To: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC7804000B
X-Rspam-User: 
X-Stat-Signature: 1x6qg9z5hndqmkjd9a3k4eiqskh8awur
X-Rspamd-Server: rspam03
X-HE-Tag: 1784143991-425897
X-HE-Meta: U2FsdGVkX18zQ9yItW/M0ep7qk381D5/D4MDQr+Qww8oFIFPAIYmBgU9eohA+rZYpd59EwFmImD8+Ccmll1kTyML9DFgkhlrVbxO4zb8ojg4jraa2GSmnYSUpHlhUtRdwaC+Vg/tQTPT3X8V4Y3bqhKWGmeL2FiqNR1kkcJWDjxjvplDQjlIc5XnfLQkTKSflQBWwukqG5hr1kiyZFs4okoVjIdfEuVeRlhZaYPPRcbacJeBFWEWza/nGHZwbvB7FiXK8CyZ8dRKRNdQd2V4k9sjJ5DGul2l+KO4W06bCJDUvNcWq3OVBRSIDqeskRDyrtTHUfdcRR4nnWa899iBDZzAEm151UQhi00VvTc+hZmiPWTHT9bzqKrjq6LqckuiL4CDcnTbWzTktL1zVRh6+26/ijm8BHJza3vj6CvU2AM3CDOHFF/qDKsZ0SedbGDHHIKmcxX2Dcn1Xp9dm2hzLwBDk/x8/U1Nad4erZzOtDaU6qlSb7AxQAT2RAUYCWKzRKywDDT5Tv25h7ufvx56vIjOI8fEQwLOiDWgj3cciZoOEzA8UiAk9UbzftSmpuVpZkTfYn2IUV5yK+uMqjU2zm13LtndRw4cK/yrg9+D55UdYlLmMW54pND+QbYALE6W2XXXD538IwzzdTaG7gD677CGfXToEiJGWJXJFC/xFaikuTMw9pk3iutkYLSQN3ZSqZq+r0Ly/aO0uxPWM1XagL3OB4srxARyY0vJu34KCiHMH1eCdefxRnce0jdwoUwTVuqADfPw0w2nOmdgdKqkF+Sx4A7/9/TOSu/5tyFN4p5XeILATjMCZAXBgwmQoU+1zUzBxHXvwxqlJvKzCRxNP9TImOBjEYyKerRntyW8D7bur0DJ6dOHB/h+6pqC/tckpDpxfrD/wzWHfT0Jw5vbVaQ585gw4txhXyWEJRIXdCEkn0/xECWkQrArwP0XZTeRKSSgjCvWas+oZa9zXTG
 jWKdy2Hn
 dPHQFcpuI+Vy45CDWdoBnZopKfuYRei/p6ayfpCS18Ydq32xCMqRuGMlXucSIAtL3WNCM+vYWKaZjzxKkUsDPUWV9jZMRSnU4GOrO2EypniV7zWYfmyjqz2GWFDRIe3lqmhe6fegyf0dXBsXmKg5Va8NVS4VMnmFUaotbTnigEclyW8sHZwFvEdn0mPUqXgXWa2t+mJBFVkcS2JHaHhKtR1c0IL4yrUWGAU0deTSEVDgawBXq/mVCF3I55DAxZSnNbmGoR7h0Mi0a88OydKQEn/SpO6U/WhS1jN9rYszXJqOGIYHKY2Y1l8TZMPGhietqpK1VU19VMmj9wul7wmTa5Hfws1cgAJawwc2/nSJZ9TCMPOqy52cqDBZv6AAxFVZK1DEzjzF3BOHBYdewiJTx4FEVeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 09:03:57 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> First patch was originally part of a different series but Andrew asked
> for it to be separate:
> https://lore.kernel.org/all/20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org/
> 
> Pre-existing bugs found by Sashiko during review of this other series:
> https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com/
> 
> I have not reproduced these bugs, and I suspect there is no real-world
> user that is affected by them.

Right, thanks.  I'll stage these for the next merge window - no need to
rush these fixes into mainline.

And I staged them ahead of your "mm/page_alloc: rename FPI_TRYLOCK ->
FPI_NOLOCK", to lessen backporting hassles.


