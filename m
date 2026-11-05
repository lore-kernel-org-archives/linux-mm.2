Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E30E606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 00:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0PJXDfBV
Received: by kanga.kvack.org (Postfix)
	id 188F46B05B0; Wed,  4 Nov 2026 19:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139096B05B1; Wed,  4 Nov 2026 19:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027EE6B05B2; Wed,  4 Nov 2026 19:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C63DA6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7D27160825
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:38:55 +0000 (UTC)
X-FDA: 85399205430.05.5FC8EB3
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id D04A9140005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:38:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0PJXDfBV;
	spf=pass (imf23.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793839133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
	b=1240465CoCHiquCbrpSqZAmI3yJQr8CKPTSHe1l2Fm/AWqsR1c0eVP08CmYUXynTNiwGsH
	6KHUF/4Z+v9pAFXGm+BMGsnXEvL7Bol8VYK5SR9v/TG0v4V9YiVV2fj59FS6OIWsVa3Dbq
	XeFVNV6YZxUvCgrMONIwwdbby2Ka0DM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793839133;
	b=cnx6n36sb97m+TjKsUI51LvCX0apakFSBcJgaeRrjezegnqEQAqpM43HhuOKpqB34YOJ8h
	2O/NATjQsBLBEmu+LkQTKwCaBp+bSjhTJf9oi++wxCIyXnb6uoagONSq85BTrEfy6h2RQK
	N5/QyGMpQMaUMo+jK0/aNOl4hyC5Q78=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0PJXDfBV;
	spf=pass (imf23.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dee593f18so996710f8f.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 16:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793839132; x=1794443932; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
        b=0PJXDfBVqhvHbyy2I67R9H/RpAiYYx5tYNjDTNLlm49s5spR/9h2xhE6odhvMIDfBA
         K4dm4/WnC966/4i1A0KQP9dHAfS9k4gqpLYfUVd04cm0mEO5atooHCUouJ00ywga5/Zq
         ENAbEna0iX8d+OZx4GgzKAYmpgeKLKgmvmm0ht21xFA3OIr5xT4uCkgr1FU5YUq+3Om1
         U3GYKR09rLXsUuZw0eD97120CLDUmjMke8+B73fA5731VzchmDx/dD5rt8rOBwrwqGKB
         aD/FsVmysaLBj1EGuvD7/mPi7zGy4XcY71k2zcxIcxmxfcaFgeEeuWhul7pI1CRXUU0U
         pCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793839132; x=1794443932;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
        b=U+a/lUWJRjMwQL0YThS9ljPyV6uFvr5JBQDlnUSai3mums0/yhK65S/dt4c4OR1wJq
         ZLH9hUXxeBbQ+8VE6Ymvg/QDqIXow/a3qAHG9eU7ZYhVRvJlPkF6OVyhrdvuXKb+mlSJ
         az9HLyQvxNx9n/Y2FJpy24B32UhDp7aQUX8kjoYQvWVnC0LOPTOY5bVfNE9tfo8lu+xQ
         yRrMjmw/vxnjg7rllBSgsMBJnLouhtyp+6LH+iDANptW40wO87MXp03YVR+qB2d75Jgt
         Qv9Y/p+oBIi8wXNEdcjf16RoRbfiVxEUEizgp0+bRiTk79HSeUQd1DgjsKkjhQ9INWz1
         Whhw==
X-Forwarded-Encrypted: i=1; AKwUvBwUUcWV9Cno6+nhkhrQDsdGprCYjnWF/LsM4DpufeCbZW45bafyg4bFRSGs0YSW58FHr6GVVCfOvQ==@kvack.org
X-Gm-Message-State: APuU4Z8/3jBGYcP8VutgEgUJTXBLaU0qTduC2Stf3FaAMSQ36nwkgX2T
	59rELYNroUv0NELkXtj62Se7fYeuNBaC4tRmYu7pZfS5u27gKQ/8FK5J
X-Gm-Gg: AYBFou023dE2sLfiq++RmoaEOcZwmQdJ/RJrQ8oup9m0Usb9yYRjg1f7TGGPFVL7ukS
	u0rnN8kGFvk2352a26QOhwotQW4Artf84qEambA1HSjLvN0u5GhPYG5y4BM3+HswH4sW1/0V2D/
	L7UF8qZHIy0D6AvdFF2wD2Hy0FZSMN9bQnbPX9hE9zU3WaArhq0GIJho/sNsZuQbA2+Vf6ZmvGI
	4cvar66oZySlwYRDFOBMROocYn1NGqibCjzRC8VTzbQZZwx2rrAkMq10/00lIK+utyezShDkxkZ
	5P9bW9RLMotI/zaExhhn9jKQLp2lddYszRwLJpFr/vwPls9q0a85CMDQ3tTKnUHCTT3KnhfEj/2
	1Ggy0BR6pOfrfkSMWzcZKiy1tIAYDYCXDi4b+SKHY5bLKphlHJUL/PqLRkhfBXqItfM3Q/7x8zv
	cv2LCPPO+Zg9WXcrMNgnk3jij9MrwDhHs4Wdm5iE8nfDo+UQ7DD7vbqiabsIRhQv1cv6v124qtG
	d/kCXhWMxozwHY5RpVU+UepfF5lifrp2qEnpQk/SbMQM9omlQ3eOLCCB7fwjzye6oB4vwC7v6YF
	+pynACnWHhTYTrRDs8j2EMOkGIQd97hbXNJZ7Gxjiopj/5vbe4wk4PMAz5Y=
X-Received: by 2002:a5d:5e8d:0:b0:491:49c2:3b3 with SMTP id ffacd0b85a97d-49149c2043fmr821244f8f.51.1793839132301;
        Wed, 04 Nov 2026 16:38:52 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed553441sm5988761f8f.43.2026.11.04.16.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 16:38:51 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs become isolated
Date: Wed,  4 Nov 2026 21:38:50 -0300
Message-ID: <auvQGQs-2DXQ2Brf@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aunrTtH00__Xi7PW@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com> <20261103075940.110308-5-matthew.ruffell@canonical.com> <aunrTtH00__Xi7PW@localhost.localdomain>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3sqfyxzahr3epc9upq36si95bgpppem7
X-Rspamd-Queue-Id: D04A9140005
X-Rspam-User: 
X-HE-Tag: 1793839133-887061
X-HE-Meta: U2FsdGVkX1+bbyXan/mOjsg0hnuJQLK8NzJZDohjcSfAGlw0iNvT1Mq8S5mJXShBYDIpfvBEnC2OkPa5FvxiGKrOz0veIMVH3AzCCO7xTczFIEnfgSMdGlTXv2jHe722zECItHDsSGybw05KhTh5Uk6BTpSSgvxPHOAeNrhc4JhX9rNJY9hCFXzKG5qxxu28lUYxjahlOiBFRAO71USROP3gJFHHBDCZn52SpPO2cQfD80bEiGXWQseJjljWezkZiTLMO27GD6dd20hK5512cU3yBBveoSnob0HxAl4o2wFMp0ke4LCTHAq7P/lnW2qnYm4QDfHnxcEvKk+yAsHLvwvSFNNZSzfjBhLTQBJIVcIc59+ObvA42aDQczX/pvo3D8a5Vcb6HJ5xn/cTWwk36uSfMqT57k7jTbtgEHTwjnSFSXBTJJYXd0mWfAf83aLoMfpeFn5KXfHtX+koBwim/eGe996knYXH5hpKfbWFkMkkDYpSMl1ZoOBdqYzu33QVPGFF1W4ge1EdOX5wTPfjUnnAqRJa7O0q3uKnTR36q8AhibUzD+dWJ6BPGu8Z0BpSU4MHDhWohW9xnPBfzdMD7pWPt7TvRQvb46bOm7y6U3LAg07ilxrWrF7+89DENNoEX9xWqgS78l6pPSB8bkmlcsJqTd98fyu/CR0GKnFeI3yuuMKVnPzlTWSByqZi30pOWkQG5OZzW3SM+giOXZqgVSeQ9BmPxqUYcLiy0Wb1MNWBmo6foJ4XQ/IO3wdM6NVljPOT3uOHeln7DJ9cYu8aTX8BsIvmacxDl5Ju17CzKG5e6/pkMyWnYiqWddyPkaQkAbr09K156aUoIrCIKmNNRsYcF7Z7dw6CMbcwkqHZ9PzAezZMLpqYASq3Q88C4EnOQYJ8ZzIz95O+rWQW/pRUGW0R1RLXwKT/60F1qK609aON50QEm1bZ2JVdFm8KFHp7ZRnoagFhNVZXjBhBffC
 h0FBRtbi
 HX9aWpJOLvZnYYx5VmAWG81fBk0EOj0z0XTBizkJ8sppAxsbFGh17xKjYnd6Mb4+pRcnH8Muo53EvJDBUtBOUiAb2iOotSR/oh569arHFYlzzB4mcnyQ7DGt+hy6qFXIb4so0AZms0nfwz0lyrlouAmNvWFhnmvOc+pTlM/FMRBQXrBoI04xeZS82yAe5a/cmGge/y4qMBLMK83oFeBXyIhCTA431cMwHN69NMDQPVptJrSaicrxW4mRFGsrpRh+jxN7be5y1mM65+TNDPhTaGIhi3pUUXjb2fVW410QEMD8mBGUnDxt9eYzBi26xWPU1f9S4iuhcj8xNEjXlXv0KWyRI4gDkb9ctN8AKEDePDK5lHvRcAqHD8DUAqz8JS7kKPxb35RvLnz9rXzibM4Dec+4jOyu6/XKmIY30rnqyrVsheyutIS2dWj9cZOKOzBABFSjMk2nqchsaBmBMneEdqFLKIbC8hRSPGw2y/or1xceWPI+6vsNdOjX23LImoIIj/AfZdoxT5QqxqferXKHF3EFwActEfuSonFZkNNBd4SuqFIM+tSh00K41n09cnByXszwLYhYqTKXEuVmQsWvrts2DvjQiZDp0IP8vG5wt0gy/+1qm2xR0WhW2zjPmBYKtnoYrI2ghcagMKzklaZlO9dHLfIR0s9Vi2EIQ2zGjpZhIlX3NyiOoyMsbhGYgzNIsaXvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:10:22PM +0100, Frederic Weisbecker wrote:
> Le Tue, Nov 03, 2026 at 08:59:38PM +1300, Matthew Ruffell a écrit :
> > From: Caron Wills <caron.wills@pulsar.com>
> > 
> > Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
> > that __lru_add_drain_all() never has to queue work on them. Boot time
> > isolation (isolcpus=, nohz_full=) takes effect before any folio is
> > batched, but a cpuset isolated partition can be created at runtime and
> > the affected CPUs may still hold folios in their batches from before.
> > Those would linger until the CPU happens to drain locally, and the next
> > lru_add_drain_all() would fall back to queueing work on the now isolated
> > CPU, which is exactly what must be avoided.
> > 
> > Drain all batches once from housekeeping_update(), right after the
> > HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
> > workqueue flushes that exist for the same reason, so that newly isolated
> > CPUs start out with empty batches.
> > 
> > Link: https://bugs.launchpad.net/bugs/2165410
> > Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> > Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
> 
> There was this patchset:
> https://lore.kernel.org/lkml/20260519012754.240804-1-leobras.c@gmail.com/
> 
> Leonardo, do you plan a v5?

Yeah, working on that.
Hopefully should be tested by the end of this month.

Thanks!
Leo

