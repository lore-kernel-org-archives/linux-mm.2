Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1F2CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 05:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4703D6B0011; Tue,  2 Dec 2025 00:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424716B0012; Tue,  2 Dec 2025 00:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336BD6B0022; Tue,  2 Dec 2025 00:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21DC36B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 00:30:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EC4B1404E1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:30:02 +0000 (UTC)
X-FDA: 84173404644.20.047220B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0280B180002
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:30:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GN6UidVP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764653401; a=rsa-sha256;
	cv=none;
	b=p30/J2+r9IXXwqlICJbfILeMkRcNlsiyPqUHiACOniHQhr3RFY55y0BrNtTUqrLzsZRdNZ
	oDd0vHc4+9hB92dLgeHM4y/Xm4Zk3cYy3Uakqe/OO2GlqqCrtmXqVlFCXHtw6nqD0RTfGa
	8bYvi0p85wiC/May1/PNPz3+cLQNaUA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GN6UidVP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764653401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqSmUsAO7/5zqCxGO5FBe/rLS4lVLwE8mtyUPKVFUpk=;
	b=P9/Cb592Au1xnBM+xq6+nTiPiBJJJx6XyGMZccQQTTA+9s0zBFUDAcncKHPFGM5JfohVVx
	kChnVfsIHBRStOs3q9qwcanfFXKpN3Q4mb131s1wLNBllfTixNyMHKJHP+Ft6hRZq7bEUG
	RV671SoheqDm4nLwlCibyC1kTE8WB+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F18E16012B;
	Tue,  2 Dec 2025 05:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEACC113D0;
	Tue,  2 Dec 2025 05:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764653399;
	bh=AC/H7QIlr3QmhnqMSKJgZKvuq7W5yfN3H69eEAKcLp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN6UidVPjxM1COAEdYJo9i/+KxsQO3/OcfrIvQwWOziKPhPcLvPzo7PHFeE//knWh
	 M5MrUkOSd9a/SN5U+L+ljxEv3+TyUB+WOckKRL5L1G4XD3MrKJ8Po8IaXGbAMUreM0
	 Q2IZoUCxMQPKkp5fdWH7KJkMw6ucDj7jIMf0enFQNSmzH3jUBnBpBgA1kHJ5gzf1O0
	 S55hQLJnl53VwsiYLq77m6R4kitEuIhyEu2i8gW6rbffRs73JOrizKkOeDHcyH6gVI
	 /q3ZiwOGEQPcexopBdXJXBPAQy5XR0CiyVjbIGe5TzQtF689Mu32YD0XSyGtSdM23V
	 zu3khrlgl7jXA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: support multiple damon_call_control requests
Date: Mon,  1 Dec 2025 21:29:55 -0800
Message-ID: <20251202052956.987-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202021407.11818-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0280B180002
X-Stat-Signature: wjcdad6ze9ss771b3k46eibicj5hadxm
X-Rspam-User: 
X-HE-Tag: 1764653400-652279
X-HE-Meta: U2FsdGVkX1+783hINFgUklQV9QJ266PobeZV8+057/9n6KBk4K+9uLfrFiCrL02Cj8GlyoWLxX0kZr76cXG5kxjNFlEoc57aR75Khgyr0zjRz8igOfsV1XXorP9crmxzwKsktcpOVLBZ8eOAiEYZn8k9drwkYZEV8a4iDrACBDmJQSfS9SYeTOpq2akw1+MeN9wBq5he8BnTcUZecxSEgFD1jUv3NCGPmiW8g8w7eIA4GbpYS18riCPxr4Sc85rXDGAk26Vyl5SLD9PczJiEHTw+45Sn/wKk4BpoTUFpHQbQ+4pwEl756n8oQHcyIomAHDAl6Blr7uOS5PMuuNropl4W5wapLzMwOyceqY0oyp08Mcz6BfdzR8fNz8+s5KYyn6kgU6TmQwMtFFDSl1ckikN1GU+H87TATkh/XaNh6cV/M7Nh00kLkWFReTcsQgl2Oe7xt7Aa8x0bJGAnnimHdp7f7x4qCrOnpebWrTQnGAXjTl30oXKiRpphkeO2ot30WRAVKGidII7jRwOx+DCOvk0nRO0doUOpLCzjQ3ipliq2eqXfQbp7fD5KH0Jn3ahkgjx2Dsy4QU+q7ubl6Oc3hMaxLoJKAItKY3xDXAkTn26GWE3nQykpUkRI57ho7fm5NfyhNQhI/7/5AcSR+3lDCSDnqTEIP6AKgMTqsp7sJEtT6Ln92zz5Dv44KB1TMwN+pE8iI3zkAS/STex6dndvKnHk+vfAVzk33EM/h1pK7doP0r9n4CD3luCXa+XoJ30GHecsfwc705PzUuWR6PWV7wL8RFKOf5SU/Ky0kZ72+vCc4d2ssOPdnzecLB3bPzzPnlpqPBpG7JJeI0YW0u78IvSJaTYgSSUARXO/Rp3m0mrU/6HdSz90Ca2XNU5nwpgSG2v6M/o+BdaF8sLmniGA8mve820W7002HCx5ug7IB5IcCa8oyq9VxqIg+w+k8srFlqtP8EnUaTWZI8e5Elz
 FmrG2TDM
 RObTbDh6eLtFqXIZNU/ZhKz/BNbiPszOpnlPO5bB9E/SxYwshJWWEqStsLU9ZhhmB4DcjjAhCWut4ISK5vbD/KHPFNEsUie5T+PXpoULhRK7fSv/+Fu3seynxaMUxBqdAv1GvVvuu1eYKMGQIwN6hjGb9Ior2Nc18ZXJL9JIbXT3qBLTI5HvE6z9Gf4Yeqq5m+HFaJi9piyu0n+XkitK46/23UrMs19Q2pRbuNV5wpgu/jpfD1U2XcyBgXn+GZefTZVb0niqegZ0XD6H0ZdbovALQDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,


First of all, thank you for sharing this patch!

On Tue,  2 Dec 2025 10:14:07 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The current implementation only supports repeated calls to a single
> damon_call_control request per context.

I understand "repeated calls to a single damon_call_control" means "single
damon_call_control object having ->repeat set as true".  Let me call it "repeat
mode damon_call_control object".

This is not an intentionally designed limitation but a bug.  damon_call()
allows callers adding multiple repeat mode damon_call_control objects per
context.  Technically, it adds any requested damon_call_control object to the
per-context linked list, regardless of the number of repeat mode objects on the
list.  But, the consumer of the damon_call_control objects list,
kdamond_call(), moves the repeat mode objects from the per-context list to a
temporal list (repeat_controls), and then move only the first repeat mode entry
from the temporal list to the per-context list.

If there were multiple repeat mode objects in the per-context list, what
happens to the remaining repeat mode damon_call_control objects on the temporal
list?  Nothing.  As a result, the memory for the objects are leaked.
Definitely this is a bug.

Luckily there is no such multiple repeat mode damon_call() requests, so no
upstream kernel user is exposed to the memory leak bug in real.  But the bug is
a bug.  We should fix this.

> This limitation introduces
> inefficiencies for scenarios that require registering multiple deferred
> operations.

I'm not very convinced with the above reasoning because 1. it is not a matter
of inefficiency but a clear memory leak bug.  2. there is no damon_call()
callers that want to have multiple deferred operations with high efficiency, at
the moment.  In my opinion, the above sentence is better to be just dropped.

> 
> This patch modifies the implementation of kdamond_call() to support
> repeated calls to multiple damon_call_control requests.

This change is rquired for fixing the bug, though.

> To demonstrate
> the effect of this change, I made minor modifications to
> samples/damon/prcl.c by adding a new request alongside the original
> damon_call_control request and performed comparative tests.
> 
> Before applying the patch, I observed,
> 
> [  381.661821] damon_sample_prcl: start
> [  381.668199] damon_sample_prcl: repeat_call_v2
> [  381.668208] damon_sample_prcl: repeat_call
> [  381.668211] damon_sample_prcl: wss: 0
> [  381.675194] damon_sample_prcl: repeat_call
> [  381.675202] damon_sample_prcl: wss: 0
> 
> after applying the patch, I saw,
> 
> [   61.750723] damon_sample_prcl: start
> [   61.757104] damon_sample_prcl: repeat_call_v2
> [   61.757106] damon_sample_prcl: repeat_call
> [   61.757107] damon_sample_prcl: wss: 0
> [   61.763067] damon_sample_prcl: repeat_call_v2
> [   61.763069] damon_sample_prcl: repeat_call
> [   61.763070] damon_sample_prcl: wss: 0
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Assuming we agree on the fact this is a fix of the bug, I think we should add
below tags.

Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
Cc: <stable@vger.kernel.org> # 6.17.x

> ---
>  mm/damon/core.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 109b050c795a..66b5bae44f22 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2526,13 +2526,19 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
>  			list_add(&control->list, &repeat_controls);
>  		}
>  	}
> -	control = list_first_entry_or_null(&repeat_controls,
> -			struct damon_call_control, list);
> -	if (!control || cancel)
> -		return;
> -	mutex_lock(&ctx->call_controls_lock);
> -	list_add_tail(&control->list, &ctx->call_controls);
> -	mutex_unlock(&ctx->call_controls_lock);
> +	while (true) {
> +		control = list_first_entry_or_null(&repeat_controls,
> +				struct damon_call_control, list);
> +		if (!control)
> +			break;
> +		/* Unlink from the repeate_controls list. */
> +		list_del(&control->list);
> +		if (cancel)
> +			continue;
> +		mutex_lock(&ctx->call_controls_lock);
> +		list_add(&control->list, &ctx->call_controls);
> +		mutex_unlock(&ctx->call_controls_lock);
> +	}

This looks good enough to fix the bug.

Could you please resend this patch after rewording the commit message as
appripriate for the bug fix, adding points I listed above?

Again, thank you for letting us find this bug.


Thanks,
SJ

[...]

