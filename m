Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BCFCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC46B8E0019; Wed, 20 Aug 2025 18:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C758E0011; Wed, 20 Aug 2025 18:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9A78E0019; Wed, 20 Aug 2025 18:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEC338E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:16:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 507B21D8BE6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:16:40 +0000 (UTC)
X-FDA: 83798546160.08.F89CA5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B12AD18000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:16:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbA1UGh1;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755728198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPDurou6bSdrKeGurqaqhGBttU7jigBrsnUWkI5zSd0=;
	b=dGQXNMFltedhHfjU5A678AIDkbpfbfzMC+sdNm29DcnGqVbWgmTw1+MvNGuCj/liYbrPbn
	HHcFLujVPZGd9IAfXGEh5SyI7IC6HmTA9qDREykbF+bEV/GcU8yGF4xyBMbP4jeLmTlHOP
	s70jJCrKto0m8ND6WElAUS/a+qAGKpE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbA1UGh1;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755728198; a=rsa-sha256;
	cv=none;
	b=JUmF9iUlbZ3BVJP58Vh9CWxGU1OKHaalg7DEFJl1gsyEfY+luHHeV6gb2HfWQAE+e2GwjE
	aypv71LGfUuM/8u45w22Bkl8A5YaMQgwHh2uqmtNroYAzj8AV+RAOT/rlR1VPPcfqKEzLO
	igJEzX43EGMPtcUc8/LztBM2tJhbPfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EADB261444;
	Wed, 20 Aug 2025 22:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F6BC4CEE7;
	Wed, 20 Aug 2025 22:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755728197;
	bh=t+tWnrOdC52ng2PKCMOPQ3dU0wAXmGRrWg903Lm9s5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbA1UGh1nC3YLNxH36lmr0c4YOCpU6zi5divlNm5Vp7tVUEfHKWIjwqb3342Ktgu+
	 dLDHwCayCyjiEeOWEf+EhacAOsU2xhK4a55nMVPYy30hDWPGs3zwiT/rI+Majx8b05
	 XJp0xB1FwXZKAdOgSNjrg50hRj7tg2ppob0usfMC7Tz1EZecNieJgmhZQ+dMRbGLv6
	 WAivW2gaszIZrtJTOv5XhfsX8KCmEVEXErinhfqGp4fZQjXCbd8vB8UDOTXk+jkd5Y
	 JmeA4Av2AJiPd9enh172qDGMN7I343+BAUoJrCM0U2ifoLh3z+eZxAg4sqt7OFV7zX
	 bxfNH3+Cosa7g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: Re: [RFC PATCH mm-next v2 12/12] mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Wed, 20 Aug 2025 15:16:33 -0700
Message-Id: <20250820221633.87243-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250820080623.3799131-13-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rpf5e7tkqp7a8kks8zh5h6fadoem4bob
X-Rspam-User: 
X-Rspamd-Queue-Id: B12AD18000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755728198-206104
X-HE-Meta: U2FsdGVkX1+2k9IjjDUrnGIapdIyd8Iw5NFWI9NeBz1QDkfcUZjbdJju88+Vc4yBlWYPVRaTzq0IJeb25NK39PQSNVyChgocA+8phWzVOwhOnIn7cv8Bee3f54GN8G+0MYTIyO0hFXgMqWyHNMXYvOoV0HKDYN/O10VB61qFopuodnxVFcYwK4ztuvBb7H9WMvLvN508TjYN5xKa2bh4HWAjUTjSwhIIBAR6pkUZHC+1kT5cYEVOgmmvz4/QPL2FT5M0vPgtFkYCSoZsSjPv+HRchOGXC8giz3AQzkKpovfpDnYIVZhdcgfP74WzzJFTqEx1Dq+bx11J58yV+G6+MnUg95Hl1uCQEbOA8iqwbc2Lc8g36l00HZ02NK4KbdVcbjhxsFdNVmqZQrFJJae4/aAjxgS88X3ivtf/egYRL2ue/nYjk/Id9k7oKKFaqE8hZsuKym+rd0FWw29ljCtEUWqoBIeL3vAcy9KosUX/9cPk3L/U+00fGn65T/lDKVrT5hX2wwYrl/ZsUPERMOhuJJaovE26TEY/Q9LvB9YJ0AYhm1CkIQ0jRCVk5L6ozNUMsCtlBdfG5vEa7XT85daufrVuNH0taZZXRjFbDYAV2p9HY9LMB5r3OyIPwk/noJlwhjODmzUmLVPLpOb5vXV6uAxiI+zd5QTykzGfdyp4PNHaDTrYKQo+fpbmQjdAWhAJcRnc7IZh9eF+Ihn4+Cw1vOluwTBLnbV+y1wzgUmi8V0u4lKO8KPMvC/HizQk9MRyMWQUQiZGkipTB/jej10KbNzGGt5/ISXrAjVA22RTdmslSTBRNCtWq7u2Yf9zYqOhYIy+vFoenAJ18MCupiVtBcR1HjJ1WkQ6MrChCmPi5NAX2DKbSQTImC0XJRqiqtvKJSapWRq+T5sVQtghr6gTuisRY7wpwW/pojp+5YLWZQ6pwLXbOiZaa+6bEcYeB5HzMTHho/HAuXqyslfC3tC
 Qus9tqFB
 xcfF3uMaSfb4q2cyt3OeO28Iyhv5yym8b9j4EebWTs3OuH9NHpLBSOMqwb1AR26+8j+EWRKhg8z+22XF3jZblr2ddKUDInbbojcPLpeUov9aewUewTNcbGZSlEE57aoiIucnQd5/LwXfk2fSt2GumBKDzD05uFnLixI565cXgsep018yvO+6xicE/wFPO4p+t0tIC3geSkRLN8/GQhKfpEzadrpMwmj9UR6TNWGyZrU/olZTrWgIohrRp2vBdfWc5GR7PoWQqBSSL4GgiydLRKTwDLfSwjoQGtkI3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Wed, 20 Aug 2025 16:06:22 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> On 32-bit systems, the throughput calculation in function
> damos_set_effective_quota() is prone to unnecessary
> multiplication overflow. Using mult_frac() to fix it.

Andrew Paniakin also recently found and privately reported this issue, on 64
bit systems.  This can also happen on 64-bit systems, once the charged size
exceeds ~17 TiB.  On systems running for long time in production, this issue
can actually happen.

More specifically, when a DAMOS scheme having the time quota runs for long
time, throughput calculation can overflow and set esz too small.  As a result,
speed of the scheme get unexpectedly slow.

Quanmin, could you please add the above paragraph on the commit message?  Also,
I think this fix deserves Cc: stable@ and has no reason to be a part of this
patch series.  Could you please add appripriate tags like below and post again
separately?

    Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
    Reported-by: Andrew Paniakin <apanyaki@amazon.com>
    Closes: N/A # privately reported
    Cc: <stable@vger.kernel.org> # 5.16.x

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  mm/damon/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 980e271e42e9..38b5f842ef30 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2102,8 +2102,8 @@ static void damos_set_effective_quota(struct damos_quota *quota)
>  
>  	if (quota->ms) {
>  		if (quota->total_charged_ns)
> -			throughput = quota->total_charged_sz * 1000000 /
> -				quota->total_charged_ns;
> +			throughput = mult_frac(quota->total_charged_sz, 1000000,
> +							quota->total_charged_ns);
>  		else
>  			throughput = PAGE_SIZE * 1024;
>  		esz = min(throughput * quota->ms, esz);
> -- 
> 2.43.0


Thanks,
SJ

