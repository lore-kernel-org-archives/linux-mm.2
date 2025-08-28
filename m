Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4FBC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EA18E001E; Thu, 28 Aug 2025 12:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F5B8E000C; Thu, 28 Aug 2025 12:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724EA8E001E; Thu, 28 Aug 2025 12:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF9B8E000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:35:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15EBD58407
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:35:48 +0000 (UTC)
X-FDA: 83826717576.04.99D94FD
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D2A640009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:35:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tZaXxXp3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756398946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXD1aqPsvjZ+PHO/PDPe12byUVxVGd8Wfqus3NDP+MY=;
	b=VITksQSeFS9g1LtTL/6r9TlE0ifcuEzwnBvYm3JvyMI2oJdKFSbOT2lGoAjLqtfEyOvhHh
	PbFkJYnz2a7Sh5nJTn1dQqtTy6de7GwVlROxweGQwE+iwXVuCs3sUR6tBUNpfA/S2yC80x
	QfdDpQZuWL1uFRY1Qyc1SGEFdkctPGg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tZaXxXp3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756398946; a=rsa-sha256;
	cv=none;
	b=yiHOJDkF0eaaX4QxALTXBJj6GAwmWVoDwfM5l88K53w4TYKXb7dUnj5ZtDcKANXRIgxmH/
	o4FTlcoNyBEyBKOruNail+MZIjqQG/RiGRk3eE0BdtEWlBzfB/tKHCmHcpXub068h65nQ8
	+25BwZWbrx6nHvTqwISfNURp0bt6+AQ=
Date: Thu, 28 Aug 2025 09:35:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756398944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nXD1aqPsvjZ+PHO/PDPe12byUVxVGd8Wfqus3NDP+MY=;
	b=tZaXxXp3ewliIwnr1Cp7mjd2qr/VuHiqSZ3fsUVyIIOFfNTTbqbrrOtdu2fqFEMPM8xSHM
	b3eho+0W1JIA8Q4G6pil6v2kaegZhDWatrx/LDEyar9I0GX07lgvRZ5x2U67GxM9f9UHI9
	Fh25B0/HcDnT1E0suij4FQLjHzd5lP8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Yueyang Pan <pyyjason@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, 
	linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <5ce6yn4iml5tk5zpf73gbxk6z244bkchwuxfpvuervyh2zlqlc@7sanekvjpglm>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D2A640009
X-Stat-Signature: n4wpdufp7z8sjq898dd1qjrecd9b7zyq
X-Rspam-User: 
X-HE-Tag: 1756398945-684711
X-HE-Meta: U2FsdGVkX19pr4p6qqySKUsGTMbsOcbMGF3ARQlIuL9pFSulckzbFXpsZbo0QIRKDw/sYpFQioz4sgLQ0YwsVt4/f+Np9QJV+Pvp7/BoECmyg0s7+oM5jAV2/hjfJrW9qQYcEukccN6CVu1Q5TwLyp+2ijFAq8I+DhwRzHCQeEqaoJR/QU952lHiZdevC1AcFGIVR3laFMPEhh1MWfhHpIgbaOOF4UgPyBEgSokDsjE7GYpWGwjNtZX1FKhbXrw5KAXLfFybv0uKSogbCzYiHBbKuyEdlBsx+2OGbgHTmOgN8vFtQQsme+6a89VE0xmburMmQd/SrGp/IfL/p3qn94XkkjHDvEkkR/0l7HcFWaWcZSKTtZTTY7eK3I6k9Gafbix6IVcI81wjlTZIQnPihWKcsVyWZ7d9XOVncHQ3hTIak4mVb3uxTbVG87BdgB3pt8a1giPWw5W/Pd0kuCF6DgsJAL8yLQ3Bjqg4E+0j/mvl+C4XpaA7XHhItklootL5MQYX4OLCtsEyad1IYc3uCz95Erb3T0baOMim2k3eOUKYXSqGIuKcjzfE/rQV1Itpo7qIs/NdwaE0gmjbBHP1dMmPWUClWU0QfxtmzZBAd2rzDgBtVWJpfJ/RLjB3d45Z2C9adapb5McShN3tDHXbr3EbsE0Wi+e9WEN9s5JO8TNwiJNkncfiXPc0st24r/OlNt9uNlB3oEPh8R8bWzB+zYGurCXDQ2B79eABYUomQD4a2S3vok+BKcG8cJAttm0qrzfDcbzpu97nqHM8NCx35pnPgatXvfrgdkSFj1w5rvH+u7Lm3tavwPFdRYweafyJicVr6Slyk5fv1DksQNl050gW7yi6CiTW4EmgZWHQtFJECYi8sGNWU+Z53hhTYOi20dZ54fsFplZQq1TwNRmulZKXb/cSlBjEHB2w0vTzCPzmW/WKscDShsEEQRdC6gvbXiqVMdjL7qPFkNsAKdb
 GmGYdEIj
 siJAi02LUDQfCKw+MpUxCAda4JXdTJHeBpZHkiE/wbhEHj/HXvwefz6hz4WmKSpklpJ6hnQXV2iNBR6qxBIRQcChUT+2PMeMUrld0tUVIIjinPoZ4jS2HM+yk4HZqmXG51imQCsDonZobLBi1IU9UdUecWD7BbpoTB0VjRWd1FqHsbY5K7GC5/hYdERtG8alLL3FUq81Pzyrcew030FMEmhg7ghHnCn7aeaLoiVLdhiu331gN6Ebf6Kv7ECo+63f8ZaQx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
> > 
> > I was not aware of interrupt context before. I will change to test-and-set 
> > lock in the next version.
> 
> Perhaps simply spinlock_t with spin_trylock()?
> 

Will lockdep complain that this spinlock is taken in non-irq and irq
context without disabling irqs?

