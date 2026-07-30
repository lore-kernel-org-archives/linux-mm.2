Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53951C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329C46B009B; Thu, 30 Jul 2026 10:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300DF6B00A2; Thu, 30 Jul 2026 10:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2169C6B00A3; Thu, 30 Jul 2026 10:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007476B009B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:07:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8797A1C0155
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:07:08 +0000 (UTC)
X-FDA: 85045619736.14.4E7AD5B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id E10E3140011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:07:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JruAloCF;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLkeg63OuLCVxSyZVT3FGznGIpDxUacdB3JC+M2Czpc=;
	b=CoRtzUxyzU/g2ZGB3VxPOdXrxDxRRgVr0sO5vK4VTVP9bqFjaf+UbuJMmwaHPnypQGiVke
	9LeM0nPC7gEMmoS2XdrHAsprkEw7x479sNc3HJzXwrkKXpPX/l9D9uD130ikXNQSFYF6bY
	wY5B2Jn/m21aYui+UMIezZN6k3KaLTo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JruAloCF;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420427;
	b=ITDTEP42tFYCmI/ijKJFDrHlahrAVXpdXu3sheKIkr5BATguq3BoVvYLyrDqkOFE5g4E3x
	gjhZNWGUyU+5pOIzvB5NUAS2ImAnmD4uviZ9qbiDfgZWKGhxwvz0rYcBCGylDJCcsx83wf
	V2IWRi1P6gMhzHB+Ic+ZktOwz35lwYs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PLkeg63OuLCVxSyZVT3FGznGIpDxUacdB3JC+M2Czpc=; b=JruAloCFq/byX902aD6eb4nSmJ
	bpfmu/SXtypm50k/hfRBOvP6it/z0APmDVQDTWrPjumMRGG0LWjP2/LGKwl8/ecdBsoTVGJ5Ptzh3
	gZ5fFaZ5HF2WTw6QpSrIrFKHJgnbk4to5b4wCE/CswWZ6ILaUoOL4+ukFOnZLxltSF7+A7CeWTUY9
	Z/D+IoHIcvlw85VXICazmvxGAudPMceZS4m1giLr+ZJwkwewLS6iRI0dFrJkWtfrmqPgj7TFHtOsx
	yVZHX5GnuKGAptpU6MoKnNMsWTsNspG20QtN19pdXc6wFrgC3OSBGUlKeRx1ovL3qwQyqPmmE++y6
	Frj56npw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpRPN-009IEB-2U;
	Thu, 30 Jul 2026 14:06:50 +0000
Date: Thu, 30 Jul 2026 07:06:44 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>, rostedt@goodmis.org, 
	pjaroszynski@nvidia.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com, dcostantino@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <amtZNwxZ3gpOsPER@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amdWVTs0WKOxguxP@gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E10E3140011
X-Rspam-User: 
X-Stat-Signature: 9sdijenkjqbwbrtsdcp87jeos3egmd69
X-HE-Tag: 1785420426-821966
X-HE-Meta: U2FsdGVkX1+bmZl/EUEi2MoKmg8Fm97egNvMmJmDhVwhk11V3pDJCvPF1I6sMIKRgf7HmmndsFg0yjy9Ur6N4XqpeRU0uwb0fs9zdXULE1M0HM3vWCXay+frRNwY2s9+43ZOiBypEd3pGCYwxIXuuCreVLJ0cFpsyELSP3V4bdIfQUw7LkxWadCB1VCh9x1BC9XUSSlFHXksKv9Ki6jqDvoIz1UPg7Bjjx6YwAP9h91zvZAm7STTGVQy/pygL1I7LGnXQJpcKH787JNhalP/ee1oiXMQ2x/zvt9gvR5MWec7NFOizFxX7Rtt40p9T73OsGEtpssdnQG1ePKh8CWLiWaHr6rkDXtfhvbl0y6s1r8ieTdELp6NwL7+Dzswv9A6tt60eVeJK/aqJ+tqQBXnsrsOiUEsKlwlnT2tqOX8WZDpibATBlyFlFwdzzX1AVsWopOIxEWFOkTwa4aT88krkh9tzpe7mbJ3gNk3T0yvB6c5n4dBDjDjcOTE5+XQGk52bcKLDKQ1Hu9/lgYDgiGYYq156eo4lcokbaeuWMHw9dI/P+l9etTDy5Xr6m1/Alyqe69kDVCoY055/fUeejwoLTVtC7AFIVR4gG9sNIoki/0UCrlfpy6T2L8FAT2gNVMHi1NBoWHwj9V8zgyVliGMJ0wi8wsM7g+EpVSlEkir/BaC07ZPzCa0on1gQxXgv1giv3m1He+mbYFX2LXbUuvmVaSunu8h308j6dL2IvYiGWRJj9nEm5CNtHyjuxaCTVlwEZilfDAKy4FLfn7p607zqU1Z+isJgX/e/ZECDQ8sbOtDMkIpgv72o+/QhlaD+ltcon3mQHxJMEvIEPr61ydfzHNVN3H8JqS3a1ybWA2GG7m9bqnw3pkHdSpqr76DQD8Okg6xtnuDgiApOL724UAdO3iWc0c1DUbsOiHfbW/DBpfk2TMmt4sWCD6ol4H2PWdH8W8esSZroOu68jHqIHj
 H8l+P6M4
 k1Q4nhACt9r5pVMjsz9SPQ8nO2zY2D0R8gAWHlzgj1LI7jHw2olhay3VpKNQ5f2E8UQrWsLuvirLV2lsqExPsWkauY8q149NBQu6JBv721lVjDMZepp8qI6S0kelKqA6/hwczgVYahfaMSvkH/gS6r4c+snioohQXLXF0ljjofxy8qpW+0YoMt19PRlGWMpHuo86dlgwFSGk2ZqIYWwIlOio5Ybz2OsAToTveM4g9Kw8CfugjjWdTamgpVLLCnBcB+objlbytw5qhcEGyQZTnqJEE3u2sX78iysrC5enCjafBMND8Fm7u4a8h7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:04:37AM -0700, Breno Leitao wrote:
> I found 3 different cases on Meta fleet, where rcu task stalls show up:
...
> 3) Nvidia driver
>   * stuck in nv_procfs_read_lock_params

I've investigated this issue. The nvidia driver contains the following
locking pattern:

        static inline int nv_down_read_interruptible(struct rw_semaphore *lock)
        {
                while (!down_read_trylock(lock))
                {
                        if (signal_pending(current))
                        return -EINTR;
                        cond_resched();
                }
                return 0;
        }

Code at: https://github.com/NVIDIA/open-gpu-kernel-modules/blob/452cec62d827034798072827d3866d1881662b77/kernel-open/common/inc/nv-lock.h#L54

The lock is never acquired, and cond_resched() provides insufficient
scheduling relief.

This triggers a more severe issue with ftrace, which holds ftrace_lock
across RCU synchronization:

        mutex_lock(&ftrace_lock);
                ftrace_shutdown(struct ftrace_ops *ops, int command) {
                        synchronize_rcu_tasks_rude();
                        synchronize_rcu_tasks();
                }
        mutex_unlock(&ftrace_lock);

Since nv_down_read_interruptible() spins indefinitely, ftrace_lock
now becomes completely wedged.

I suppose we want two things:

1) change cond_resched() with cond_resched_tasks_rcu_qs()
2) Avoiding holding the ftrace lock while calling
   synchronize_rcu_tasks()? It can take up to 10 minutes on a healthy
   system to be releasd, right?

--breno

