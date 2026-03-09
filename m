Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F1BEFCD71
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D1E6B0088; Mon,  9 Mar 2026 05:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E9C6B0089; Mon,  9 Mar 2026 05:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71566B008A; Mon,  9 Mar 2026 05:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60176B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:53:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 588AB1CADE
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:53:04 +0000 (UTC)
X-FDA: 84526061088.21.0D86DCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9004B100002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:53:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmiafaaU;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773049982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO80iq5jqMuW2wif0h4OfC49zPVR1w10IapXfSCuuTo=;
	b=r8UVv2hhLkcJ433WzZ4xSY2UgpDR+S9Y+MwSxLKJINcj4eqDJsX2Hw4JKfS0OOxI9rVY8H
	aPpPwUukPwnyNQ6BtlDwDfpUbsYZK+ZGlLoWcs4U0RTVL65DciD6tP9AOckrsFt78LEMJf
	5vkitHoepJUg/6zVzB9k/okvCNlh+Z4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmiafaaU;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773049982; a=rsa-sha256;
	cv=none;
	b=I73wsxpyzf6S8Dz9m9lIkM52CI8kmR0N80wWd5J3td26K7b3cnlpXwdVr3nCtrZPhyoWbg
	f+eyfjLrG612RGxiZq16Lg4KUGc6+5Mz74POykYnN/WS4/wS9zepH8/9VlmCfDhxeMHBvm
	D1xLJ70eQOhNlyNRwjvVlOM7m75s/f4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7091042AE9;
	Mon,  9 Mar 2026 09:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B89C4CEF7;
	Mon,  9 Mar 2026 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773049981;
	bh=PMIuKPsEvPXOB7oPgsM4Nr0xqxaEsQcqjc5S8SS+m8Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WmiafaaUd3N0urhZWm8ej60bzApAWQpt38JX2BoGr8OV3tszUuCJojKJMQmYGdJ7W
	 V9ZbwFBsf3RvRRBvf64aM99RzGfnI6VWkyivf4ZCXOhHJrOyJT1wo6kpxeMJIK0Pmw
	 O7H3J/IumMBFvtMEh5bfxgrIpVQ0tPc7ggQzTNSnbh3/hzml5wwraMlQ7GFkUt6CMo
	 vPXRZ+fzEvf6PqDOraPeM+pWGxu0R/MO6kMV39rYN6HkXH3aaB5DTR8LjuqgabY7jh
	 cP8GCa9K2RzX+qioulCI1ELzbTJD/VWY0bFe5y0mj7qmsdOijRN+Sp8gAcUgJDz4IT
	 NWvu6F0HYsBaQ==
Message-ID: <cbd42744-31e1-439c-b0f0-0cad052d3d9b@kernel.org>
Date: Mon, 9 Mar 2026 10:52:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
To: Leonardo Bras <leobras.c@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
 Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
 <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka>
 <aaJDjmnfuo8AM6J9@WindFlash> <aaYpICV55B70U1I2@tpad>
 <aa20uDGqnmiqYJ1w@WindFlash>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <aa20uDGqnmiqYJ1w@WindFlash>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9004B100002
X-Rspamd-Server: rspam07
X-Stat-Signature: tofgms4oonwz7hwt9dndqeeegg5ts95d
X-Rspam-User: 
X-HE-Tag: 1773049982-292554
X-HE-Meta: U2FsdGVkX1/C8XHhkofBTZAERXZCss7CyzWKQqna3kvRaelja4jMPidEWNNBz9Vj3YPeckxuAhxkOREDag/tG93FJrE0DpH3GmD14q0cMM8MdiB7rZarss9BHssjvJQQ1rGyV2VOsuA0PZLRZ4leTI627uhGNKGNpNyRhvTuJsjG9edReojTe00amjaPhTrUaq5ty2qzupLB7IkPsn5pgzcbvgLzjFnoOD60L0VHgQdGYIFDqbrPTshqrRf0W/2RJIZ1PJQJM2S4Of6i7JrasMW/lTF15MNl/3uZk1uLN2qFni2DPc5Nkr4PaRjuhUCnbbg/SexjvLBi0OWixGQChda+L/u14nmDh/Jo2NcRk89nLaqp/Caku0+0qA6TObPXA4oN4OvcwIPUPnYTZoWOHqmnFYfzVslRS+nRlYVtKx3b4dYlAGKUyFTcRKeizuRUMUW487zxBKVN4yQz12lIcaq6Vj05Ip3vF/5iAwdXaWcwysrVi0ByOQ4R+hY3l+TuR/rYEIUSVkhXTkfZ5aT9XH4r85zXGSYQRvaD1hqzpdOlVeKw7ClRID6V2c/YJsh+sOrof0+e40XA1uGMOUOgn596CyM7A0SGQDhULfLBc5q7C0SMifnemXL07yPlVQnrGks1qXfnCEjjiKTPZSPyC9hVOsUhCHQmmeQXpoozWDaf1Zut59UhbMrcJi1K8kbS1/st8GbpQiKs/QSj06VGRzx6ClIv1UJ4qplAh+3OduRYsnV584hgSO9MuULhJIkaYToVZOPaFw2b8kETVEMzt7vzGQUc4LkfMljuZGG/guq6u4H6tTvT5o7lwCR0t769UnfXNEDYitXJZRzXaIpEuJl0XfnMA5+duXHSwKBk0imhT5QbFwpOlwJru/iLBiWyGs6jEBKuJpwpjOfpsBLcBTrC8+Q3YFf5slZhgeRzj2TOx3TYo/JOmTb5XLCRYwo1JMimevUXP+CMenpyDqB
 56pApvaa
 uInA9VM9mkOwECsAVHC5srwVDSCjonA0kd916d9KhXA3FHOjA0K0oK90IEjjYXd4klaRK7Iavv8O1GBElhHt3r0oSaEjj01BIxzPDid7Tu9+FiqxGumjLeb/Figb6FP8PxkcTilXfFblpUHVURkwUxW+HjmCt6K1Ah2dBj+v8yrtTBFwgBLgj/zjxel8/0qhy3s5VQDMJFj+uDOSm2hcpwiWIQysVL5Pp0bRxiLW68FfEcRP2OzGjUPUMC+gSwJ/CQfRNISc5fj5mwelKHMiB5IHdOKBraUvK+b7wY9jMDidSqdvI5clu3s0f2dMnyoDlY0EivfAuF1QB8bY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/8/26 18:41, Leonardo Bras wrote:
> Hi Marcelo,
> 
> Great, hiding migrate_disable under the static branch is the best scenario.
> 
> I wonder why we spend 2 cycles on the static branches, though, should be 
> close to nothing unless the branch predictor is too busy already. Well, we 

AFAIK static branches are runtime patched to non-conditional jumps or nops,
so there's nothing left for the branch predictor to do. Or maybe I
misunderstand your comment.
It does however increase code footprint and thus instruction cache usage, so
maybe that's an effect of that.

> can always try to optimize in a different way.
> 
> Thanks for the effort on this!
> Leo

