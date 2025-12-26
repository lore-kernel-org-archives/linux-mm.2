Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC2CE8FDBE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FA36B0005; Fri, 26 Dec 2025 18:56:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F159A6B0089; Fri, 26 Dec 2025 18:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E212F6B008A; Fri, 26 Dec 2025 18:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0FC76B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:56:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6870A5B60C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:56:54 +0000 (UTC)
X-FDA: 84263285148.30.5DA4633
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C920C20002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:56:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESTPbVJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766793412; a=rsa-sha256;
	cv=none;
	b=RqPYTB9p6dB3qAbB7wRppb056/8xGxfZiZwwWcKNEUhNRjXsx83ncFsO6U5ScfMA/LRmAI
	5E9gKxGxYDAt18Q7E3WfGsR3C2LbKynq5Ak1mlQKqM6eHujNEIQNFKxjxZTUuCrL3FWj+R
	dNvY58JyfYkOoMTw65/Lrve6QRGpuKg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESTPbVJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766793412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98AezxJ3jW3ULUSY6zvEN0A6ECnUczrNnBoMc5BW2t8=;
	b=1gQtKS+W+HFJmuhcfpUNZtRbspma5W+APdEyxPaiDKJWx2c4Tt/pM5x11JQ6eBJ41gCK8c
	GODgF4Vq7GLEUx0lVJIGYXCvHiKPr98hnZGTIPZAIBwHRHPpyDC7W8uZtgVwkh5nEqqJvg
	x5EsPHBvfHhKbAyiUTrJnFD0BWyhw8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F2160007;
	Fri, 26 Dec 2025 23:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053BEC4CEF7;
	Fri, 26 Dec 2025 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766793411;
	bh=TmkQ20OZkTQkt5CoWiGqlvcZyzl19wgFNsEBjFcJyxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESTPbVJJEMD9u9uHankO1Rd8hjsHnae8LYU/sqHgEPolKKBWTxvNiLpqtXw/Afw7I
	 kRI+cWQthmnS7MU0oGsE0IHLNMkKsI/EoJ1Ln4bL0WmRvXJQAjMpS6Hm+aFs0XWtNk
	 kouoAQmT585nRVEqyOuSzCqiEASOJPYciCVqlpyTUVW0BZuTZw7B66wIPPcN83E2QN
	 9+5R/Nfv7VVEeSGyicAkaNhQXEc07s2XAd0ApwBhwayDKn7ZvxLcpUabe/caIjhlFz
	 L8GjFTl8a8wrHjo5nhcXTSIWvhmVGzMxb70RcdWJGqcetaCEi73LRF9AFuGejws8Zf
	 flFJuqv38l56g==
Date: Fri, 26 Dec 2025 13:56:50 -1000
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aU8gwjlVmRkMtPZT@slm.duckdns.org>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-4-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224134520.33231-4-frederic@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C920C20002
X-Rspamd-Server: rspam10
X-Stat-Signature: bogddiki6ozutogwharzs5cfhyfrsnqe
X-HE-Tag: 1766793412-150448
X-HE-Meta: U2FsdGVkX19SBOi2Hc5xNdWxZiFZK9lPN6Ha6LiJlElTBo28dJcqdkafox+GpJ3hSHu01fFyEMFDoL1JIpS+ZuOTqLMKeZf5iaG2vx6PhYqlOpmbGBSWda+sR078731SBQcUhJDikWHTQd+Y6XlTrcvQPKIXLXMdXTRUYnMNpeAk3P737j1KrA6YHglUuM21zbSSHZtWJNtGJFUVe3XLVxfYJoO5LxHSzHsKXAvCOGJJ6uUs72ZMHjyWP8BBdeAyM118gyMeviUo2tlXuXyQ3YtDoE8WnPy1wAZZWJFF/qOLVpgViSeN3OKuKzbXs8LvoKOOY3huj/IP7KqhxBwkPh6mTYK3MVokoz0zl1XsYOIBVZuK+lP0gKa2vbBuxH7Ep2HFY6IsybM5QAZiiJ6TCEKe1uTdUX5pBs8bYjC1alpZ33Ph4visozf1sHfwrdd1NfWpaOEZtvU6fRxdKq3YXQ6LO20mDEFIGn5ssIimWclr26AYeJRTabtQ1uzRZw1BnLcOXnykRSnBMmHk1mLmqIqwvqF4tMRGPrKjpFbwNExGEXP7SxHyEvRwcvOh2kfqlMKo7C9fHZaTeSMbWtkHjROYth2RsVFdRyov1KX0dmgGCklSL7HGSQti5cahTKHf1fBSf5sH4CHB1CvHadcW3d1QVs/2T432qsp31l4KLQeIDC8ddfl2pe2o5rHdRups75L6LHgqMqmqKjVu0+hZ8D+36NHPsOdFuRp60oeAjo48Mme97ycGaeLLb72u/RXT16+ObdcfGajb9Le0dIkOuQnIAj9rxWA2Q0eqw0k1+4PglI0O5H9u+UGySS/iX5L5dvCOBG0yr3cul1R/fzMw4VQAYXTpKlpHHHHxixpXIPAc6qlJsZHEjvB9bPL7B9wvvQgWO7u8+b0WjWw2Wjpev5vUH4YUxOW5r9MOO75zMe66BnR+ys2gQkWrlxNfEAwrs5Robwh1vrGmE9zn26Z
 Gh9u9Vbv
 Y3JULKRgK8FYcK6fnUJ53QXyigU6BFldsJ+PjetpjwnYWtLU/O1BgVV5iJWr0LvNCz96BZIupW2c2yXvjikoxWLv29DRnLBPP539I9O2BnCiYfN8s9SHIfkL0Oz+777pSvkDsTOrXkOE6ZR6hc2B2OvchRmYYEbH1/sukLPp016rXkFdTRHECtmBBncROgtgoke0gEmconRxMGyGM7s00ZG+Wsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 02:44:50PM +0100, Frederic Weisbecker wrote:
> +static void schedule_drain_work(int cpu, struct work_struct *work)
> +{
> +	guard(rcu)();
> +	if (!cpu_is_isolated(cpu))
> +		schedule_work_on(cpu, work);
> +}

As the sync rules aren't trivial, it'd be nice to have some comment
explaining what's going on.

Thanks.

-- 
tejun

