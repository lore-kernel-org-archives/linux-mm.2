Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3894BCE9D48
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3F76B0005; Wed,  7 Jan 2026 06:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791916B0088; Wed,  7 Jan 2026 06:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693CD6B0092; Wed,  7 Jan 2026 06:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56B2F6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:57:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14A801402F9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:57:06 +0000 (UTC)
X-FDA: 84305016852.24.9DAEF10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5065414000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:57:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LeOVqk9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of horms@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=horms@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767787024; a=rsa-sha256;
	cv=none;
	b=qUrj7tttvGM8yRsrRV9DgBcp9tcrsyNaYyeVZRr0xGnC1wVQn4MsUIw8YwZWTttzJ0Xou8
	bWQv6pAWQj0nfI5k64l/Du5euh0jBKsZ68HmwfMBbENY7Iq4e+12SYNhKihG2s2iwXhlf2
	RuFvBQ/dwxbhLtGoov+ZTvNeJRZujAg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LeOVqk9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of horms@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=horms@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767787024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIosEDTrE19jWddqbqxbORSLTyIFfzCItUOnBwUdn0Y=;
	b=I16krAwN8mZu7ZG9x8hyvUc34V2Tm30xg2/2H9JnmO6ETjvFDs8SVpiK7MAsYXI0JS1QBy
	fj9WMYS7hHbJBTILAbwvKjVCYdNtjsWKU3V2gA5Ojfo51acb7r3eQKPWSvFCT6njTe+iBa
	LihYUM3RxJBnbiBrVREIxUFTeivmbt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D8D543883;
	Wed,  7 Jan 2026 11:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7530C2BC86;
	Wed,  7 Jan 2026 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767787023;
	bh=mNpHcF+MwpeYkX9EkT3dgyo2t+tch8FndQ1ofJbAPRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LeOVqk9+TU5kCP+FDRa6whXFCQVaVEbDllyqM6h//SAX5uiVAXQ8VG7Am0rvJsC1H
	 GqoHmEPSiac74Rt53FFrHdVYKM4/rFVqh30AdgVeV6vLWbAjvELEI1HTUOnJqZhRcl
	 WUKTPSBfeNtl/h9hRKM1nu0OKjKz29OOH9dTct1GoghBZrfukj/3dyGolifM9h+2bh
	 wbVLW2c8CGbXntqacDOCLSp8UU61M7HCX59PbmrBJjXYcCtF5Cx56s4+CUuypQTiMs
	 aUdEwgtI6C7dlhy4lPby3E841CBfyCwkeyWL2UmPv7fe8h0pBCK+OfBWitaUqoPHxs
	 uX/nyikfJSLNw==
Date: Wed, 7 Jan 2026 11:56:53 +0000
From: Simon Horman <horms@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
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
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 13/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
Message-ID: <20260107115653.GA196631@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-14-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-14-frederic@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5065414000D
X-Stat-Signature: ohjpgd5cy4g8sz57kyhq5bifjhd17spc
X-Rspam-User: 
X-HE-Tag: 1767787024-691976
X-HE-Meta: U2FsdGVkX18T0M6gspTmEGRnIJ56sB1wyKZ+FiYDP/Ii99xJBz7siAJKLvYIF6UGmGshC4YPbUiL3D3foT+AkO94Q9h816Xc5QR1tkyCEiEtXP780Zsos7lcT3skbmCtbOIwAv+y9Uc4s66Ye6n5ON6HLcjlervmb3xjMpbZFXfKQ3IYMld3GRsF2YdSpCtVzMtjFRbWaAtYRPgXWeD1tLWwNoABuwsRoqxabtVbiOkxInBlNtGpJHQI65aWmdampcEL9WJ1WHY5AQLs3s3r3q3zelEAk2nfLMJDqrw6K0BGuW7Ufc8PsoK4REG7+rfsQ1LCGdrEQ/dj0N5BEneKv0LzgaZdQODQWHgozPA5ss9UwITfck+0OPWVgYK9pMVrIhg9tJD80J0kcgdrCjUHAgC34iwtmEKVjkH1qv7FoU9VfGQ3IRc0w1vUULUGmurouAzEzGGOdvRbpvLi+SMwYYeS+td0mG+VYHtdh0mTueeOclIPA/8pncYTFAJa57nlf44e3FWYsdgNIjorv4FUUZ3gJ11grcHM5jZryeSTXhPSVtYVOg9MY3Yz8k4p0iwLCQpr7g9UnaMu9/mwrsXkLDVr/Z8nD/Rn35IYAkACGZgaBZpZS1wAHI0lRjBg6ADFeXbHSnbU1aODpSIrk5fe7gFZzLpgFRKW69NYc5kig1gsKZncavM8X3ZgL9aQrjPXn3iywVcUW1w+JO5Qhlvms8NhWpXWM/gaiAkx0dHX8pGmz6SHTGIp3hb0DEH7rmJhHKOgHN0c/IT/Y3C5uJ3zAgkyMa6x0kULLToidgjauqnFMwCFK06CRli5U177XIxKDFlDd7k6D1RTiNnjxwiz2RWOJRFamvS92zRa+ZJxne05zwyr4Rl9KYNTtAME7WjcTvydMLhJuyIl4+c+XAiC64uGTzSsNrZ/4vFFzEG3Cieyxzsm+PiC9eqWsFqIhtlOtBTQkFmXFLalM04mCEU
 /nwQhi07
 9BuXOQEo7CQcgMppKJNFfZ0fCM2+rFA5ROE0f+WOUhI4u5E3mZPGMgR6PYXW7nY2KO3y+6wij+R4JTwnMpGMUhBWeETpUVUFKbTuP6fo4C7kaDbh5EhCP9lLKfySeu34JN2vHdTlOeMdivhmOoGx7pJ1apBEXxY5yUKSpWxNRIY2g9xKgR/7ITu5imopQYLUanxigf+2bjfdzCH4rTumRL9e1Uuux9vjlWWKGxHrOUgFlzj7/aBQHs6Y15zS8MEX2BYGqeZvLG3oJ6D1ZK7htQI/gpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 11:13:38PM +0100, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN's cpumask will soon be made modifiable by cpuset.
> A synchronization mechanism is then needed to synchronize the updates
> with the housekeeping cpumask readers.
> 
> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
> cpumask will be modified, the update side will wait for an RCU grace
> period and propagate the change to interested subsystem when deemed
> necessary.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
>  kernel/sched/sched.h     |  1 +
>  2 files changed, 37 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 11a623fa6320..83be49ec2b06 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>  EXPORT_SYMBOL_GPL(housekeeping_overridden);
>  
>  struct housekeeping {
> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
>  	unsigned long flags;
>  };
>  
> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_enabled);
>  
> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
> +{
> +	if (static_branch_unlikely(&housekeeping_overridden)) {
> +		if (housekeeping.flags & BIT(type)) {
> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
> +		}
> +	}
> +	return cpu_possible_mask;
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> +

Hi Frederic,

I think this patch should also update the access to housekeeping.cpumasks
in housekeeping_setup(), on line 200, to use housekeeping_cpumask().

As is, sparse flags __rcu a annotation miss match there.

  kernel/sched/isolation.c:200:80: warning: incorrect type in argument 3 (different address spaces)
  kernel/sched/isolation.c:200:80:    expected struct cpumask const *srcp3
  kernel/sched/isolation.c:200:80:    got struct cpumask [noderef] __rcu *

...

