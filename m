Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B92CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44AEC6B0092; Wed, 20 May 2026 10:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB806B0099; Wed, 20 May 2026 10:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EAAC6B00A4; Wed, 20 May 2026 10:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9856B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:53:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80DBE1C0ECA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:53:14 +0000 (UTC)
X-FDA: 84788091108.15.14CF9CC
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3C2520005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:53:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Tb5cWw37;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FT6L1KrL;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288793; a=rsa-sha256;
	cv=none;
	b=MZFi+5v1tjju9DIv4P7b/5MotKkAGxZq8jB5f3R4FU85IS4Cg5NnR7sb+gWwVIF2PE2xRz
	kS05G2W/glgd+CIS8RL8UHyo5WDRt4C+s0VBXkTHi0cAxMMTvLFQCaCmJ+qWNQUjJEFA8k
	aN9ia8UPgLMrm8l6Rn+Go4IPdwiH7OY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Tb5cWw37;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FT6L1KrL;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mk2uML0f+DmowIUT8McBPWXKD76M6vlEQFs4dU+CHo=;
	b=49K5C++9MxQjJ/a5rO9FeSAEgjB0zblQ5c2cMcgCPcscvjyW3rmYgRDnGbJeU0nHtwWIg6
	nZPbC4Pz7NDbSfPZsYdaEJ0D791CjpnhnSEsYKfJMVmUXTuJqlEwZQwN/sRNj7qs+mQgr6
	tWUVHKuZIQASPbFcsDizz5yHAQmm544=
Date: Wed, 20 May 2026 16:53:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779288790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mk2uML0f+DmowIUT8McBPWXKD76M6vlEQFs4dU+CHo=;
	b=Tb5cWw373iYJzxUi63XwdH/EOQFLGovvQiB8BL4RVGvYFTMDw9jkLcj6Eac65cEmYur9xN
	hedaMfb8R88PiK1jm0Y1Y44BHpKgX8OfDK5x/67/W5qagWOr3YFYkoyVWxfpPR2RZR1Vc/
	L8t4a3a9Dp/HdeYav19jAYj49gbLXIh/QTfTqzRO6SQJIurAuga61jTSgtSAWfcVz/7k6Q
	guBQ93DcgZsii0P5Ik89YGdgn3yYeDzkovSe5drUQ67UNmhBPAgqkFG3pmvDcleIgyopOT
	dpuFVTGVgwoiaOYXZNeewYt+WZ3tic40EQLw/7JJ0GuCQ1+B/f/i3QkfXKOreA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779288790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mk2uML0f+DmowIUT8McBPWXKD76M6vlEQFs4dU+CHo=;
	b=FT6L1KrLsjVwCf6fGAeFVCl5O4Mz5bZa+IM2nXsByZo7RL37YpDxOtHnx/5AkedPD+hmzd
	PufPFmlC3Sm1dODg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Message-ID: <20260520145308.nay9zt6r@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-5-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260519012754.240804-5-leobras.c@gmail.com>
X-Stat-Signature: z8sawstrudhynxqcwf9iy8gt5378ot69
X-Rspam-User: 
X-Rspamd-Queue-Id: D3C2520005
X-Rspamd-Server: rspam07
X-HE-Tag: 1779288792-154188
X-HE-Meta: U2FsdGVkX1/AWZDQcPxHvfORVfFN8Q5mwc/nfjFUDsYCoTLe40W9rC1EpUNnL7In3qytdiyp9lat+Hp+RkeNlf+Yc4ADtNJNk/g0rzZCgwuuawwAxAhG9h03M3UpTdYVwZoVVpEYKEDO4E507bGtiIrUXMtsCsn5rQIoIrZYokWsHiondSTBG+VaEyIUltMm5OahQYaPLGTT4wUOCmI8TrZpz0jL8nyoPBu/HDX2Qqayw2ouL9NxD3HdTIs8kCjWqW5/WNU476jCvZTJdQiicz5dQ1oUkAp4MqBBG6DX6MwnXarG13zqzEYFdflQMreJY+9zwrLsAuvWQjRdpQK9nb3U8MoSXkfi4PVRfy3hYmz9yd/qz0rs/oIh3E7AWoSeRWBNSSpNP8midXfgYuUfDH27a8rnaFROZrcodulq0wIdOjyRRYJk945d22IKwXK/Zg3nAz/NE9qBEfVOsy6kWZK934C1Z4RxSp8o55JInZ8oxUVpHnwh2f2exhQgUz19lE3d7GsRFzGre50yOhbOrPeAPOD7kSeodkmiNM66K7KB6NB8fPQ0ewiyiBqeWH36e/TSttZygd2H/ylvaxxVgRdtcZG5TlAfwKwzf/g8NGyRqWu72juKjQPEnnENOV4PEHS7zKifZqNNVzCQhUFyDM9KzUVxYpq50xpQhO9eKm5P7NsdVmZOyVaMIswiPdIeZpvdDP6fDVeThNIPYsrlVyaTnuuBXCMeEdsV1vhOS/fPH5iGUiMwaVqYvtPf7jKmn60WdlaucfY0sTW0AHh0RSIZQEHPOqR/TbschfA+U4jLbZPzcdJZpkDGyNJOhEIuQxk/hgjWgfcAqOcJYBmSsdS4jQmMBu0YGzC8XdXQZ+HI3toUbzClybikROAGi5giXsWKbRQiH2DijYNPe29NJ2+g4MGWSJAqIJ8PXhZzZi9Vi+FC6zrML5Jm1NiVnvZQdlaXR8t9eDQUU1fspv/
 d61G54V/
 ATQYZxF7Z76J/1t16BK406GQER5cSMiouf2ZPVgTfFoenIhn3UCaifdB6LX4SciQpQ1du3ET1j2bXNKl7PfIH6eFOEiTa5y6IVdqVpzMR1LKUc2CdCZCtCZOafIB8cLWKwghz3TTr3DM/QuIMF2totmwDnLJgPVarK7KCYmN37cK5SWEyE2+yQ3+BvJC8O7yPJ2ljUOTSsQg0ul1pi6vCa/+/WqE0q3d3LBumO2Djx7d1JePffVc33pLpFFdS9Zs7Sk4adqxb4+UkTetm7xtv6lRTI099bZrhN/vk9lpXCXI44NHdKJw09QOI2XFj+/ON2BeFooqJkDMkadE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  
>  	/*
>  	 * We assume the percpu sheaves contain only local objects although it's
>  	 * not completely guaranteed, so we verify later.
>  	 */
>  	if (unlikely(node_requested && node != numa_mem_id())) {
>  		stat(s, ALLOC_NODE_MISMATCH);
>  		return NULL;
>  	}
>  
> -	if (!local_trylock(&s->cpu_sheaves->lock))
> +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
>  		return NULL;

alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
I don't remember why exactly local_trylock_t was introduced here instead
of a per-CPU spinlock_t. But there should be nothing wrong with a
trylock on it from NMI as you do here.

One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
on UP. kmalloc_nolock() checks for it, not sure about other callers.

Sebastian

