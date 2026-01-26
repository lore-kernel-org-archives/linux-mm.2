Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22097D13C0F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824E46B0089; Mon, 26 Jan 2026 08:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2166B008A; Mon, 26 Jan 2026 08:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3C56B008C; Mon, 26 Jan 2026 08:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD746B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:52:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAA7BBB163
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:52:17 +0000 (UTC)
X-FDA: 84374254314.12.E953397
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 596781C000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:52:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVVmZvFr;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769435536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ky62GUwPERN/e0pyAb7yB0pYqm86UmimVZKdDJ3jtbo=;
	b=FZbbTxqlukQPSHiiSjV+RXWmDbJ/Fe+JP2YgzZHRm+1a7ZUneApdrjmnrr3ilPP2e9lTKm
	IgS40xKxkPnAD78gshRjU32jJi86RdRI2rgrneUQ+eI0CsK/y1J2+gR/Xa0fdgLUBiDVW7
	xLkj5Aoh4j6jzd/qnkdGnmC/cVg3tf0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVVmZvFr;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769435536; a=rsa-sha256;
	cv=none;
	b=peDqUuRx+ys5ILbykslfaArimJR+EMQnOwyo3YJcxyTqTRNFCAsh9Fo0HakrHkMy0EqNVe
	IVferuNlcXkkP8OFoYFhO0oTEZ3J9QKKFkWhjirGUo3tjJlCbME75rCBmnI1p01+oxJQmN
	gKijB/SSgolxKwEd+MFbE3R2B6nsS24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA94600C3;
	Mon, 26 Jan 2026 13:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D689CC116C6;
	Mon, 26 Jan 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769435535;
	bh=kcA2cPiJEC19HBEstbYBifZWvAw98I0XK00+8H10mco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVVmZvFr+CRLz0dBd5XLWyUavbW8nCgjkNtfsZ68viSoUlQzfs77mgqO6yT/jpeN8
	 pg7kQkZ+GT9I3gBbH5KSW1N19v6LZBDwYGLOWXiqcQylBZ5g4+KO6kKGQcqEiAcp10
	 ausowbCOUHsZ9bfKrKj7R3xBLNET1yxkp9J+5MLTEWX7f4No1SfT5XTL6aSPrTfT+N
	 bCZy9asASdQMt42TI+gLu+rK/RLraHfA4D5BqFAPeAolk0a/hyw0wdylU0k19HWyrL
	 x4wXKWwVwt8GOfxwvDBurrXf2OyecnDAn/Q+0+zLdQYHvjvwQgg6PufPEP9PU1/i/q
	 WOFYplVNvnCcg==
Date: Mon, 26 Jan 2026 13:52:05 +0000
From: Will Deacon <will@kernel.org>
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
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/33] sched/arm64: Move fallback task cpumask to
 HK_TYPE_DOMAIN
Message-ID: <aXdxhfVLqyv-2SDX@willie-the-truck>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-30-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125224541.50226-30-frederic@kernel.org>
X-Stat-Signature: xhcwwrf18myeg5546otojrd65s7fc11x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 596781C000D
X-HE-Tag: 1769435536-467048
X-HE-Meta: U2FsdGVkX1878V5AXIC+JQe2VLsVv2PYIm88UMY+KDnMCTXEybI36/a6xUL6yxVUE1E62ojZo6jaQvFm10/v9FsbnzjoxXmU4wao65HuMtBHc1JPWEv5+2Dos/hOMH9IB2VXMNFPI5o4bf4OijjI2R+5y6nIDYzbcLrDvlWDwwEQ3XyCLWqHeLi0mWiuh6C2N7NUHVhMs2vovEoprWkhrAAn5UDNQJ8pDMolqz4GK81Tt6cflMwKigCuD+WRCJXk/GeBCDerH2ZP6bXHTHsOYeEeFHeKW9JM4p6SWMjn/IkmzzAxpBUfLLThPFchReYBV2ylDOCwB2nmUNeLowlKFicCmpgnZajs90mPCs3MOMX+9Rie5w655Y0j8pYzF1+5Bpwm4XN/FS4lfmjIUhweJK2IktBEf3cZbpJVk9paeoZaTefnRIU6ts2KgQWWAdj+11V5GzW+RkSCyVaHeX4SbjNtTiMyqEtko1Rv3uDeEAzKY9npk92Cvf6PYS5qaa86zbVJ5WJLZQ0U3Z5n7GPv3tb08RuYP1Vb2Utt46eMxdupjgMkGN9FjWZx6PQbl9am2JQJDo8IKk2j1YykncIVd3r67SLJ1SXJijy59zi4hQ1p95006n/GCJF9FDHUKaBOzYQSY77kM2/07ZmzJ97j0rLFabBYxUSF2PAezv9OkQsx3SzDbqtMnIZHRTi02/hwBnO3FxKtauLTnK0hI5P1d9QM19fs0En5w8q7X6swunMZZ/NfPLLyGY+xpeorQ0Wcv3Yzroqpn8lrFtdpyacvMduOUY3YA3zpYl7iCA6VdDfoffh0J02G3tr1pXvbHyyR0rLfUoyRLxxlHXiPPkYjGNMODhfSdZZriaYrFpoOG3/fvk1LONQYZJO/N+hfxLQYuDqybhi7DyJrQqiyyv2xizdO+Oj6AQw9KhQKgPe8TESkyCcB6z2Eekbmtli5b2cXDJWLczPp8Hf5tMwPkMt
 FWLm5B15
 KJIZAXpPaCpe3jvdN+8U5fIcSektB3HD9fhn4mEIH6IW5YjwwxAfHoQ9u5eVOEoWk6KeOiGT7UZtRJmZJVptwvPxVJucEtAKGdVU40XTuCjPkJMPGaIY4pIZMYWLovuRfS1zUdEI2w8IfwRB7yfehmPRoqb+dUPYl2D0g0RNsOwBlJthK176c6ZBVHKIH14yqJhJk/wXE1Vnp8hhj8PCoYkSezEAvHJbaPQ7Wl3m51YIGUZXc85QaSDmwY7QOC7dl46m5oM/5CCCTzqlrCeD8DYsAyI6gRSer09sE1fPBDKdCtmUCxNNLUVIGD2H6/iZynvW2OJc3zpf6yowLib+soDTWVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 11:45:36PM +0100, Frederic Weisbecker wrote:
> When none of the allowed CPUs of a task are online, it gets migrated
> to the fallback cpumask which is all the non nohz_full CPUs.
> 
> However just like nohz_full CPUs, domain isolated CPUs don't want to be
> disturbed by tasks that have lost their CPU affinities.
> 
> And since nohz_full rely on domain isolation to work correctly, the
> housekeeping mask of domain isolated CPUs should always be a subset of
> the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> CPUs that are not domain isolated):
> 
> 	HK_TYPE_DOMAIN & HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> 
> Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> tasks. Note that cpuset isolated partitions are not supported on those
> systems and may result in undefined behaviour.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/arch/arm64/asymmetric-32bit.rst | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c                |  6 +++---
>  2 files changed, 11 insertions(+), 7 deletions(-)

Thanks, Frederic, this looks much better to me. I also chucked my old
tests at it and it looked good, so:

Acked-by: Will Deacon <will@kernel.org>
Tested-by: Will Deacon <will@kernel.org>

Will

