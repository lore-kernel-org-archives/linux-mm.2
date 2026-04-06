Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE80FF46C4E
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 15:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F636B010C; Mon,  6 Apr 2026 11:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE72C6B010D; Mon,  6 Apr 2026 11:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24786B010E; Mon,  6 Apr 2026 11:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF01C6B010C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 11:57:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CE82E13A6
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:57:52 +0000 (UTC)
X-FDA: 84628586784.24.A33035A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8C7F100002
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:57:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QP9Fuyij;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775491070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaYGeAf+yPeBi2AUf7QAKJz5aCviAEGeg2Z5KJNsUC8=;
	b=aKMM1uREhiV+EoODGoKz/5r4lyr1CDpruBZ5zq9ccPJfmbepk7HH5LvstaRdGBt9MX0j8G
	Ho+B2qI7gkd5pgyye2Aer/e3WKe4Md5ktTkNECkVp12kmaimLXxic0gFbHOrsPIrjf/v3q
	fL8iYt1J0cfISyrXiBZmXcfEvkujd90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775491070; a=rsa-sha256;
	cv=none;
	b=NCstt7Li789S85OwTUEiYmR43c7RD3tFd1/TiLtouMnFtzR+zIHBTf5/EkUU/Mlm+v17gy
	um7MMsnUrAns3t9uESwrVNDKs9TEVkiVpim/FREdAIJjzyHxIZHWK5abuBq63WAS96m/P/
	kEpGsHzA4QvVfvbX2vTv1sAX+2fe+uo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QP9Fuyij;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 452AF60135;
	Mon,  6 Apr 2026 15:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C33C19421;
	Mon,  6 Apr 2026 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775491070;
	bh=NCB1kgwid+pok6sSzkYM/5mK7H+v09Z6Ios74HEuHEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QP9FuyijbcXPqLMKmRvw16mvM5ODOoL5M9/xJSRoUpw3CWq7gw1jbKVXgBnswfxa6
	 5TXJBSLlRdwKir6iuahHu+/5H7XkWYDhQ7LvZATpRykI3uS3pxLNULdiIZ2l6U4ZpL
	 /qAX6xLL2U/dWf5OGT/N1NH8t4WpeeS1jbZczHYWEEROv126R7s0g+LAjP04560Vh7
	 hILkS2Gs/mN8QmUBXUhQXvVmoxi712JjtMDXvfZ5/hz+xCnDvjNy5H2FLjDmPgTO8D
	 fr+aXyULN/4XHMyedsoXyN0oWClo/yemqFPUGB23xaXcZ43Y4pgaQLio1CIafPEfX4
	 sKTi0VJ53iAXw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon/core: avoid time-quota permanently disabling scheme
Date: Mon,  6 Apr 2026 08:57:48 -0700
Message-ID: <20260406155748.47893-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405225440.76827-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8C7F100002
X-Stat-Signature: a7su3hjnp15xz7cymkmrhsyhjmgnyrmp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775491070-46862
X-HE-Meta: U2FsdGVkX19aKAsevJT+xtL+rpsHhnHG1ek435Vkmv19TPcNh9bUIsv5sYyk8s25cf7Z44vHceDwdBtFx6Uio39EH+h3rWzfo5ial3FunvRGUHJs84ut4nayBSrkUArr4QDztvjB8HOrAOpiNutNa5H1J55HOTLWQuoHpoIiJXmg7ilAHFKGYn/rS7/zPrMYV/plSUixZtag+81G4qWqMbzINbtelOFvmJWMO/waBfhFe+gahEon0op0he5WD0PT5aD9RSPzFmXmCpm4/6NDYJ93VmEbnp+Hxsnk99YST89qTd1gKjggJj5mqrMzBeGvpJqee9+TNW9/6x6UHOHQmWn+tqggd6XkP/CJ4WKm6LnNNRRdNqkjBVRQC/SbqblrDxXyrjV3Hs1P+jorqynZma8lg6sYbN5xNYWcqvYDNQzghyr5hapW4pf/jMWoiVQpaS7YfFMvPLSbK52oATo0h7f8ZtrjTfuh0YNoi9x7lm/pdjLndWxJ+Pmi1Eg3hR/zLcv/5Q4Eer+uXpdufnixziy+jjZ6eEd0Ab9CwVyyY+3ZfXnkB3iHfbys01JZtM2Hf6ghA5StR/mkWW6nBkKSmKJ0Kuv3K0KMUA/T3sJNbEbo4mabuxylC28PmIYhoJ/EIt7aXOYKmtr4DyXn5/dtvYswduf60xFIZdEtY3sKeAwyxudPkKt3KyIGucCX1y/ZrXMYMSBJvqFQDpYC6GF9ss3vLDIvsN5zwdu8RIyUVg6ATVCQFVMUeUc9kK69uzaQBwkV6SWxRcd/I2DaRqt6p27VeBO1cuD+JEOCv3dK2pvAP0T7vxLh4K7xON0vYgBKfILqFwrTTpJjcJO3N7cmbP33VyNMuP1tgeGtL32ZmBKrb6wDylrqLKSDmWv+RVXI2VBra7cm8L2543pLrqkjGq86YLvjDACqy+w9CWCRmOlAONrevZu8jer/kK1jjEPeipMBjw2+xSf7tJwGXVH
 gaPdCIWo
 LbZrexEfLJW+MfkAE+heyzxANxnGSVNxXgrSfZ4aTvOh1DqGMI1NlMYVy3LePcMLy8yvUZ0dLMjy6jrbykglMgawJHmZAiuaOtCLcIVoCiJf5kcjL8rCcm8CZs5/KCDP+P5o7WAQj7nbxnVajbBokyKgOOpXqoSKV9QofLDGPZ5oYlZEtm9+x5YrkGH1t/TrcdBQomwDgBBMJFCo7ISCKuLV2AhmwZmhQV0A6XrG7FHK54/tv3QmqfT6kj6DB+06oz63mDiOiB9wZJoR0oFreGkDerhGr6G13LUmu90sgB7cEl/oBtuKvYbpdrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found no issue in this patch.  I will repost this patch after
dropping RFC, soon.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260405225440.76827-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit 93dc55170095d9a174cb626df2cde4fe5e49b9a6
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: avoid time-quota permanently disabling scheme
> 
> When a DAMOS scheme throughput is very slow, the time quota can make the
> effective size quota smaller than the minimum region size. This causes
> the action to be skipped, freezing the effective size quota updates.
> This patch sets the time quota-modified effective size quota to be at
> least min_region_sz.
> 
> Link: https://lore.kernel.org/20260405192504.110014-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3bc7a2bbfe7de..12544c60531d3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2409,6 +2410,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
> >  		else
> >  			throughput = PAGE_SIZE * 1024;
> >  		esz = min(throughput * quota->ms, esz);
> > +		esz = max(ctx->min_region_sz, esz);
> 
> Does this minimum region size bound incorrectly override DAMOS quota goals?
> 
> In damos_set_effective_quota(), esz is first initialized based on
> quota->goals. The goal tuner can legitimately reduce esz below
> ctx->min_region_sz (for example, to 0) to completely pause the scheme if
> the system is over-achieving its target limits.
> 
> Because the max() operates on the combined esz instead of just the time
> quota component, it artificially inflates the quota back up to
> ctx->min_region_sz. This forces the scheme to process at least one region
> per charge window, overriding the goal tuner's request to pause the scheme.
> 
> If quota->ms is 0, this block is bypassed and the goal is properly
> respected, leading to inconsistent behavior depending on whether a time
> quota is configured.

That's correct, and it is an intended behavior.

It's true that it is bit inconsistent.  But I don't think that will cause any
real issue, since the difference is quite minimal (min_region_sz quota).

> 
> Could the lower bound be applied exclusively to the calculated time quota
> before it is combined with the goal-based quota?
> 
> For example:
> 
> unsigned long time_esz = max(throughput * quota->ms, ctx->min_region_sz);
> esz = min(time_esz, esz);

Maybe we can later improve the behavior by doing the time quota based esz setup
before goals based setup.  But that's not good for stable kernels hotfix in my
opinion, so it is out of the scope of this patch.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260405225440.76827-1-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260405225440.76827-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

