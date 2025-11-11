Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5705FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965DA8E000F; Mon, 10 Nov 2025 22:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E158E0002; Mon, 10 Nov 2025 22:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CB38E000F; Mon, 10 Nov 2025 22:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 776898E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:17:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E7F088814
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:17:37 +0000 (UTC)
X-FDA: 84096866154.01.1121310
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 400E420002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:17:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1LuwfNA;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jE8ud/JwB5HfBpvMy2LpJpkpeLCuOyzlsaO0bOQsL30=;
	b=xLz+ZEQp5yxea6idmqQaatPIhHhE/NkaY0ocoUuDpaU3Ro+jYTrNige3ul45jS8baJBnJ2
	LU1zXtyi8rfwpYrw5ks7fQCi9Qem4+FDG2Ox8WdFMv0JbXlAbyhDYfhzpRb9jGDrCeAhdE
	wFUoR99HIQTuz1FTz7Iz62PvelaVQCo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1LuwfNA;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831055; a=rsa-sha256;
	cv=none;
	b=6ZoxQibPuVDrmFAkZ4eNtxwSfF9+BzT/HAVsmDH/qA1acu6oeQ5424cYP+b92nzMgmUII1
	3eIW7UFv0VtQhDcR9KruT2QgSCLVYa0zKQ4BHb+7yIs9w1Hg1e/4tLJeNre7jTgdciq8Zd
	EkT++pQV5auI+c2KXZp8/Ac0NftsuGs=
Date: Mon, 10 Nov 2025 19:17:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jE8ud/JwB5HfBpvMy2LpJpkpeLCuOyzlsaO0bOQsL30=;
	b=S1LuwfNAvzPYQrz3vhJx2o2Zsh3g2qbYAclxZd6Ov0jAos7X6TkU3Zyy8C0XRCj+CqkJmA
	zmmEPOyf8rKIUZXgI8jl2S0G+4AxsbJv+Am+W32BJC3UUaJwxBxbFJ3q+EfsAFn2T5Ad+V
	NaHIpRjMUGnxVsHDJIOMnsq8KwRoeYQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <646pwrc7sxan6wlwndjyu7upx32fkd7bv5vqlut3tjt65eeyby@23efyxvpg2nx>
References: <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
 <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 400E420002
X-Stat-Signature: qymywyy47g5md637jhii68boke8rgh5q
X-Rspam-User: 
X-HE-Tag: 1762831055-547553
X-HE-Meta: U2FsdGVkX18wHob/1GePllsqBztBqtGjEGPVNFtOsPnR68vUHGClgw3ZYQjLS03B6+UEbqvi7SzMM+Y4sqdMD1xnJJ3Yvs/C9GN9ovBPRPoCwTOejZwKNPv0/3wUrelzmUJuP0HAc7mB1TMKlM46Md1zOi+R7qt06g0hyvWDO96UHioRkSEzUKC5soGjsJCzhnTGiHQURQl7dXuSTXeZxLvWFwKr+QiJITYiodMIbVOW7p8KiT0I2SjqQK7pankvVNCZZxX3pYuzAQd42pD/fBNZVkTGf/LA5XR5//Mc+7xkvQcONNlghYtMLPzcQcupoKAIWKM25dvLkGNKb/zSTR/rKBvLsYPXKDfgn8xACqdHngBPV2v/iVZ34wRCxQ2fLhrzYm61TV4bvPRLAxBKGwJSDVc8rlLKkbJIjdcpNR+UU5RVcld0+SQHaREtvJkYR1v/tjWPCTRSYbu7Nkis/1cNKvgl/nREvxKB+up5BbIr4g6a/M0BbwDCngAJSyRxDquC9X3jz19f5IafI97uaRHVzOhGqIJvXrtUjp/wxwS3r7u5d7ZViVF2j2tlKFZp+lYduUORfSde1IeIxn58jpoTbjys9w+CE6cjrAYQK0jbfHtbA5F0WgmKavbb5F5K0DucN8zDVNT072zMT1KFzYEK/gh6vNpyqs/XKiRMIjCV4G3h0ocIWeASCGJoesiJth5LzGtbgKwOKwSOm8TBhEmVdCvpse6fz2bcW4QGhRnwR4bUqKqxroflrDMYwz83o5hnPd9x/pSGTaTHkQqts56JppwIFO0S9WqSsuY9lK91MwKnO/rNWx4/zbuqdyAttXAO6uRlG4lBiJBWuxAh+Y9VzllOgkwAG4S/zLG0YY9OI6xB6sKSv/2DauId5mK+rixtecX8pO7Q07u9musahH3Xtt1yuPrceha7OAYo+ztNHHAW2f9Lbay4eG8zpC7JdLq0nY6AItDuutht4eD
 2reQ7/al
 2oGpXd6N6ItfNXdb5704GCJFaAptrgimq6p+hPtKf47UG7GhzEWOzE/ksppCAn87L9jO2mumYYMldq6gV3Ep+FZALqbDNmNJZcBsDph3YEbebQyv2c6ef8POp58FuJeYgLkZ4XB+pZ+GMCm/LxgHtDheSejCh7wf2j8cq0c7FesgyG6yqZntTYgpmxuKFEK1ja0Y6sMh6i+3jfjvzdxNy3ppynkC2pncIfW8NkQgKaEcUMxdX7mOuVpYxqCePd39tEofT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:04:09AM +0800, Qi Zheng wrote:
> 
> On 11/11/25 12:47 AM, Shakeel Butt wrote:
> > On Mon, Nov 10, 2025 at 02:43:21PM +0900, Harry Yoo wrote:
> > > On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
> > > > > Maybe we could make it safe against re-entrant IRQ handlers by using
> > > > > read-modify-write operations?
> > > > 
> > > > Isn't it because of the RMW operation that we need to use IRQ to
> > > > guarantee atomicity? Or have I misunderstood something?
> > > 
> > > I meant using atomic operations instead of disabling IRQs, like, by
> > > using this_cpu_add() or cmpxchg() instead.
> > 
> > We already have mod_node_page_state() which is safe from IRQs and is
> > optimized to not disable IRQs for archs with HAVE_CMPXCHG_LOCAL which
> > includes x86 and arm64.
> 
> However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
> still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?
> 

Yes we can disable irqs on PREEMPT_RT but it is usually frown upon and
it is usually requested to do so only for short window. However if
someone running PREEMPT_RT on an arch without HAVE_CMPXCHG_LOCAL and has
issues with mod_node_page_state() then they can solve it then. I don't
think we need to fix that now.


