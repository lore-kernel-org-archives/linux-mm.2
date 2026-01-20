Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E32D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540606B03D2; Tue, 20 Jan 2026 07:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DC86B03D4; Tue, 20 Jan 2026 07:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5766B03D5; Tue, 20 Jan 2026 07:11:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 222946B03D2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:11:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7571C1F24
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:11:28 +0000 (UTC)
X-FDA: 84352227456.08.2412992
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id E9D544000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:11:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4pTiUAf;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768911087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft4cfnsazH2fqh82dag3UKKoVEEmk8hPCPptOiIZ6Ls=;
	b=ofjKq4X2WUcMqHUrcBFEFDk8X8lV89RlQdK/3fwjo+6ZNAFyG4KloAuDrhUfFJQrFK/uXp
	KaHI+MZHtJDZYF9U7pl/u1U72Q4EmTdlQQIzwSZFBXo78LWM1GBbo/iLWrC4dlWfvanjTq
	gWIO+ydDSlOx5ct+qORAkFOpwAs7PTs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4pTiUAf;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768911087; a=rsa-sha256;
	cv=none;
	b=DQlfWCg38z/EVnfSY/++wY6lsgFQ8l0BBX3s4btfU4zrI1rur8j4ZXmqdI7F2/VjVz0wN8
	8jN894OLHtP+BRipVGFksK/n2n7b4xSBQOYJuIHu60sSCpkchbzzRf5IYHhyQ5Q3gmH5nR
	KrYOYbVVBZi3orcr3NjfSzwb/GmyTRA=
Date: Tue, 20 Jan 2026 20:10:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768911084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ft4cfnsazH2fqh82dag3UKKoVEEmk8hPCPptOiIZ6Ls=;
	b=q4pTiUAfOIKpOsCaPxK7ufMZNY66q32D+T6qXJJExTNSxwJ2okdO2ymUJknkUzAKiW8yBq
	Q/y0CluMbt79RShE0/KvxS79Bl40SYaVHrdvCs22+iNKnaLsmI+uSrZOev9JWGfCrKcY7O
	h+6Ys3n0CeZTFZDrSjJWfpDJDu7UQRE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
Message-ID: <3vjyq6wpkvaczzgl3r2qhwi7zdluh6zldejjxnki2hft7vxr52@g7gn4lqbdi3c>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: odqp3hmay7yz3ewpnq4gfn47o4z6zcij
X-Rspam-User: 
X-Rspamd-Queue-Id: E9D544000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768911086-118540
X-HE-Meta: U2FsdGVkX19Ahc0hjbabLn5zifCXfGj5pVWvtPtKbJlktkGK/wkMBKjj/gix+/izMzk6mDzYp0EZk7MF4AWpz6mazjkWoS5Kscgha+gGZz6V/mi2IOZtLhv0oL3aIbtTMkqktlMUWQhfMalxc8tV6IQ+/UiBScsriBbM4C7ZYYCGoVs1WnAu6D7NLDA94HD2/GN0M9BGnwKpGQpOaRDPELrVrwK0N1dybsddT0C54B87nGoI3FKiDMMNfVGigIHZJwsJnA3pJ2Dggw/LK7506iqcV3jiTu6ei5vDBW+sfDeSHKyrx9o0vA4d9QOa3NIZ5ylaVRn3GRVnhhOnOIRyt3Vvc0xyL0VxyFLUwnbGpuF6SgQKSJb1Vg/vYDGWbfRotjHISrqC/EYxWfz5hkmLA5qkKr8OC+a6KjA6Stu+96t81Ii2KlV3oDUgav5Z865L0gtu3l1iOYkamQp3fPE0otP2GEAisLBhE1tlGPW3iYAq+W1rtXJ2AB8cNAS+eWHUh60aqnx5kpD73dMPe3REe0da0o64xARc//tKVmhBOKUl0qgbjyKDNrbO/Ju9pjPicVHgA0VfVa3Ueiw/hnBebDi2KVkLmwXEFV5f3wnG5J6U2udzbuuKQTvn6TUH6eOgi/hjzz9knbXrLq9ec/86msFGD9+gBrg8JrIVssaWZ7M/Y/iHS2BsFfD0uWT7o81MLYacOF8faXijuxN3bQXs25uBqAV8AepsJG4Nbh3aL2Hh7QXAQtVRZh2iEzpqMqnsoknyoTBmQGUkS4lBD9WvC55c8WyaPM7tnmoHyWGBZ307WcmhxALl6TZnBmVNSEI/24OP77081wHJ5MOAvUEtCLLf0SC+gmmUZULOaAqWmRZxYqgTQIm2ZQKJH7j7mPKD/2PXmCcw9lfrInJfyRWfQ33hXI0nhMj8L9+LV6aS9co+w/LgBc4F7+LOqmO/hF/0il+McKS6ONTRMacgN1B
 85aeSy3m
 iOwhab2gJKY/Lo0R8AN+uwdEoUevqv6q9pBvjOpGJWzh4obJvUVhEGTaaR35eVFyHaxBm8Qyxd/20PBkZdkq4W7r1MeoZRQCE/JKwb+jmTcE2CLQuYRWS9TEfgUDPsu/Co4OzKg3RooeHpvPuBrCkwz55hg9c/k+/UeKoNO/8BxPLwWKjF3YAan8t+Swa+pxQUfR+UY9fWuZ2qG//6zEzzhNfD1rTGMjINp3txTpDkLT4N93P0SrvgZDnrqEtxAq1l8nSY/3shqxBte3hAu+OCcui2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:31PM +0100, Vlastimil Babka wrote:
> We have removed the partial slab usage from allocation paths. Now remove
> the whole config option and associated code.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/Kconfig |  11 ---
>  mm/slab.h  |  29 ------
>  mm/slub.c  | 321 ++++---------------------------------------------------------
>  3 files changed, 19 insertions(+), 342 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

