Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA525D2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A10D6B043B; Tue, 20 Jan 2026 10:15:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FCD6B043C; Tue, 20 Jan 2026 10:15:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CE56B043D; Tue, 20 Jan 2026 10:15:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE1756B043A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:15:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CBB38C0C3
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:15:26 +0000 (UTC)
X-FDA: 84352691052.01.A962C37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16D37C001B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:15:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dTm6pm0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768922125; a=rsa-sha256;
	cv=none;
	b=12mxsICdM/K3ny0ipJ7ABe1xFvRST59DiHbS4ET7ymG2DIyiQ2/OiKGxL77OGM2CIKosJF
	/b3IjSZ2tV0gQUYw9KZmtZ77A9kDCXyUvq1IeSP1KTwxIqUE4mVUSR99XzsEBzFh5jlQfF
	BswUQyj1X+N/mu5UKeLdu+svq8z79iM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dTm6pm0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768922125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsDLZWihLyJlFXu9AIgF+ATIVvGorDbyby2j6akt7Cw=;
	b=PiqirnmL77Pj4F01A4+KknyxNLxnI4baNdE+mQyS9N0Xxy2T7Qd8szI1NpB4UHWRRIfwwI
	lwIAJNyFMIoCLTAOEw333vupahLzcSzbHd5VKECULioIKq9OoD0vo3EeWUNwBZYLsJ0LjU
	+Zud3kGwbYMkUpaymsDdHZEiCDt9s+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72940600CB;
	Tue, 20 Jan 2026 15:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B042EC16AAE;
	Tue, 20 Jan 2026 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768922124;
	bh=cB6+u0cGFM+BuA6s4Sw76CjAr/+izfs5ypcZfWumP+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dTm6pm0UbqrACPX84K25WsKI0mLcsga30LnGZ0xAs1QeHOq8GuYQb0tsVAj/1PyOk
	 AN1JtPlGK2Lo1SN6drBYr1dVy9fdgzrRQCr2v1Zr5WaI0DgPDkYpbpHSPBc0lzPVxT
	 mDodJS2/jqZjTXVaKaFD5qjNt2270SzYmLSpr9NA2qekfz0PdVSlZLmHpnEvNYJ+eY
	 A07k9S1Ry7xxwMicubb01dCJM4tNlasnq386AOzVL87vqKI0T34pSKz9QNypV2LDxE
	 2HWPcTW6E/V+Ce+TphpVMpakDh1WcI3tzKUwZtHRXG5Gb8k9H87NfGW6D+dQQz/FfZ
	 kpuAsAsDnxf/g==
Date: Tue, 20 Jan 2026 15:15:14 +0000
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
Message-ID: <aW-cAlJCtI5Qtify@willie-the-truck>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-30-frederic@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 387f6m7areouoaamfq53hatah6gk5jbm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16D37C001B
X-HE-Tag: 1768922124-683091
X-HE-Meta: U2FsdGVkX1+vzZrjufHCuzcVYK6jdurKwQ+CXGOGWL/4wMvtYTClHdThZAelIbEwmVKj7sdz2eyOewA37dAlCiQzUuuqR6+f2agEnb6o4gZz722HzV41JyifYHRncYiGPtDnXV61xt8iftQ1DzUMUIE+pYQYXXDqxXMrGtJ1K7nUH6qYXrnCT5LZPmRwI/CJeOnd/lq+Id42amzf+s/+G0mN2jg3tTsAuH4g7FPOX5BQ++Nb1JsLE/Jd1tr22+4CXOdJ30QU1m8wtJMQF5IXOo5JrkOisWTyUUAIv513MPr0U9MflV9sZsz5V1nN1TjUHWon5WjKMh9qzibAVAAaW53GdFGj5Y1Ua+P/+Df0e4OyznSM5AykYVqlbTKYIiKZ+dRF/k9XPaX8BQP8/Sgwahk3YEHNKN4ihLmlZekH7Z47ALB2A/kZFlBOt4DbEItT6woml5aDu6Zqe6R/Quslp3Fta1jWRRFRnE9v2nTU8pQIVeMgVelUVj+CqYBuV66bD91AL/0WFOAaFtQY97T8tLba7VuPpxMW3VFixhktYp8kkSSygAQvb4dtRrmdNQXet/V7ElTUslKkhjUJmGykoOo5DvPsTGhlyB34zvEWS0qBpMStSOLUFSPYkFYutwaR6Y+bJvFTCPEE3JFWTYjP+cAc6E4S2+tR133DNMDvMWwxJgD56oyztao4NH10t/6vn33Q0Wq00F91QKyEAUGUtP4ieuaio3HmdGL2FogIeOKqhvuYAyP5UccYU/MX/iVxT47XeIV2srLaT7vomT0Eyp3ZiME4Dqhw3nuflyUUxI+ptK0G54Y/AKRPEoB5AGlQK0MF3KbNuWEio+UAp19+4sZGeCaNG2qR0MlpJgzRbNDEfVSIxIUV+dH/5ROpCGr7Aj8nC9YrcJ9lYPWKhxrN5moFokir6LDrfl6lhizwRETRQkzh6CA6JmpijQzCb7S/ttNboGGE6FDjZJ1fvH2
 E3NOmYca
 9w/DzDD71EAvZLGXxB7fGVBi74LRfnJYtbGHAXwGsGK6SQGJBn6gTt44xoWgSHCksn6lOAV5PTY44DbysXPaMmxJAgOptr27OcDctJ/Zr/uOGAzGkAww9ubrhKFCowLkk5ttCBVxUSQPgadlDNROvvacc6mPKPfffs+vRW/jZE9jW4lCh3CxwZA4qRObmhuERwC2MKSLbZqoBWhEWJIdZEtHpbvFMjKkdLxd2/gsW3vM1BxmcHk6XzneUdXYUgzi6UYOdvXyhJVKYQzL284o/WxfvoGEb4pM77mCn7a2vmeb2+NnsmbYfsdX+vYlrV9IkyGoUQx1+KjdaE4MIsE0EVRygZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Frederic,

On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> When none of the allowed CPUs of a task are online, it gets migrated
> to the fallback cpumask which is all the non nohz_full CPUs.
> 
> However just like nohz_full CPUs, domain isolated CPUs don't want to be
> disturbed by tasks that have lost their CPU affinities.
> 
> And since nohz_full rely on domain isolation to work correctly, the
> housekeeping mask of domain isolated CPUs should always be a superset of
> the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> CPUs that are not domain isolated):
> 
> 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> 
> Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> tasks and since this cpumask can be modified at runtime, make sure
> that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> by cpusets.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Waiman Long <longman@redhat.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
>  include/linux/cpu.h            |  4 ++++
>  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
>  3 files changed, 33 insertions(+), 6 deletions(-)

tbh, I'd also be fine just saying that isolation isn't reliable on these
systems and then you don't need to add the extra arch hook.

Whatever you prefer, but please can you update the text in
Documentation/arch/arm64/asymmetric-32bit.rst to cover the interaction
between the asymmetric stuff and cpu isolation?

Cheers,

Will

