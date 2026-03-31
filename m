Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4443C10F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9396B0092; Tue, 31 Mar 2026 15:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689AE6B0095; Tue, 31 Mar 2026 15:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FA26B0096; Tue, 31 Mar 2026 15:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45B0C6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:01:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC4B913AA6A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:01:13 +0000 (UTC)
X-FDA: 84607276026.14.D8DA1AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F06624000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:01:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BMjtfCL5;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774983672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4pRuEHmIp3BFGh8Ag9ieDykRJEEEGmn8NZ78SlCvfU=;
	b=XuVtM/1N1CQKUO+GqLGbCSwupw6IcezpqXraiy0YZqR7WH8QGuGiOJ6kdptUWbOfY1I905
	TxCDtS/fUA8nBKX4feyh8tsQHuv2Rx3LPrSdnvZaLXbEGILbhYDCfHPnJV1t9W5vol6ds4
	5RTQ1O3N6OMnQysEv9MKet++Z2YraBE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BMjtfCL5;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774983672; a=rsa-sha256;
	cv=none;
	b=YafH7/ZDQVp+XlQJz6I14c7ncXIkPhpR0KfpwDRSNqvbKpuAfPcZaLfsqt8eBRzNcya4vp
	u3Xqjo6T9+0a2XLBsOG0qHPXOqky+GHtZZg6MAp9Mi72A/hPW7ZUroi73kKZfuexb7sona
	aCc+OkGkR/49pD6TlfmaXf0MZLDW9vQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3A3243E17;
	Tue, 31 Mar 2026 19:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9833FC19423;
	Tue, 31 Mar 2026 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774983670;
	bh=vNrRfej2KSVlrseFMbIQK10DdTqdsQrzDliDIFJYeHQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BMjtfCL5gbNmzDL9mdsoFjodHoycny/BTaMkvC2ho1rPpJbcWHjoJr/Ln1SMyiqUC
	 3jjmg4QzUZ9jTwFqIpqtQY3365cH+UZJjp45+xrUV9kd9Ftb7dXwLQRpuCOZ1k8sBo
	 X5cHnJdsMqMZ1SNIma4WXPdtZLiNFUGmOhTl6tkc=
Date: Tue, 31 Mar 2026 12:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: Jackie Liu <liu.yun@linux.dev>, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in
 weighted_interleave_auto_store()
Message-Id: <20260331120110.9136f80efa9c41146f1b92a2@linux-foundation.org>
In-Reply-To: <acv8FJBVieQnpYT8@gourry-fedora-PF4VCD3F>
References: <20260331100740.84906-1-liu.yun@linux.dev>
	<acv8FJBVieQnpYT8@gourry-fedora-PF4VCD3F>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F06624000D
X-Stat-Signature: 3efd7nu7o7ben33djta5essp1ki3mzth
X-Rspamd-Server: rspam06
X-HE-Tag: 1774983671-377159
X-HE-Meta: U2FsdGVkX19fsJgBJrDwEORBfsA+KsDOOFrTjo+NJSo6momDPyyiZlV97T7kPEBRLSpMIuv8bWSQcsJbV0GjJF9+uIXZMIlJt5j/VHINRmvpOmqQ74R2DY6rH5WEBK8ND5+h6tZxQhE4Vw9Bm8ISQXHgd6qgIBIwwTdOcyugOqdng01UuHhc8cKQwjmeHpn7/5UIJWwd80ymmFhzhG9h8eGEZ1GJgI6624CNwEWRXHgSLGyln0Yf5JP92YvZsgvWq3ztuikSpNgGT9s+w51ZVWOVe4Rij8NZXHP3nMaUppfdbCSZYSYnGqbhOFphtOOtpcrk2u33zk4Vi2BNJDABK60NpxSTDFkTRIoyhdcqEVWEMdK8IDMyLPa9KSuKn9k6M5KErZSNXhisv2kMImzWVIzQ72IcH/B9YG7I+gjdytgmw1AwYxgmYoTzDmqcbUC7iNrdzeV7YLwOO6NJes6kpiprBhboHDKrqYSQey2BPLbWLk0GIRoPVF+hSnc2LAruxBH9bnstcbUyz75NKlFUAcB/KPFFfl4qoans31759aywEab4uVCN50ejpESBcwZCaZcQ8Eb0LezrteD+F/RfcaiZ2qXmpXIVcpO9ut8HZ9p8ofg8ldm9nTQbUALFwKTBj6VgEcQq73aOXjovaAidtAtVLmZ8T1HO1EpRUcC5xGhx4whDU42FZMrBoTpEuhAdckYeiVJ779OATDh8XsQRFnhJdi1vu7DzOwbfGUi9Ji6LfTf2S4PkrMzgVN1IG88VGaR/HTAUuLVZnTxrk7p/zeRg+thTi+GX8/7OvekCMwodlU3q7mluIQoQyC6vd8rzoHNrptmyGFMaL/JKR68AcPo5fSUZYq4+gmUVEh2/sj8dCp9/DimIBtJ9EoYDZhuXeKBRckrW+UoJ2lXd8Nrabe3AXfJq8ryc+2++bP7o94FbyDAtGafVVCNhJgMEw9cUIOd5mJAk/HmctFFlmry
 JKAcUoHd
 +mco8MFRyukLaYF/rBpz54hw8OhXwYTKp3KmKZVlwWbsv3qfNAMkHc7O+Ts/4ZeZxsS2gp5llEtF0pO1B+7mKMGqHmwfkkL2l/oN9yE+wUKsxTAfVYLwQgz0FDBssjtlC8VRT/2AkL/cDUgsvVWZhR1PsAueWezf27ykH9WauyjsCQGsXFRwibLh8YilRTUhm8sqthexk/Bre34ouJiPACorAGGGH61/VyE6emDJccVjvIJVajXgfcrb1TKdWIFNr9c8ohB1xg1R+Lr4TE3Cbi2kSgVtaychpFQIzAfFDmScW04+C1mnJDde2BdbtTBrwbE+Fg3/OIkm01vaLOymzXijgSPdtMp4LCQEGCYVRsnvIECs9TKdELPmUIZBG5QijSjqrxepFiEXxFP40twjOAFP4eGuUrbIiLddtuzD6o4cgcVIY1wbMyG4yAv2Fekjl6uT+as8Pm7XDctpbuo68OMIktm4yiK/LfWYbyZkXgFevdfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:53:40 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Tue, Mar 31, 2026 at 06:07:40PM +0800, Jackie Liu wrote:
> > From: Jackie Liu <liuyun01@kylinos.cn>
> > 
> > Add the missing kfree(new_wi_state) when the auto mode is already set
> > to the requested value. When a user writes "false" to the auto sysfs
> > interface and the current mode is already manual (mode_auto == false),
> > the function returns early without freeing new_wi_state allocated at
> > the beginning of the function. This can be triggered repeatedly from
> > userspace, leaking memory on each write.
> > 
> > Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> > Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> 
> ..
>
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
> >  			goto update_wi_state;
> >  		if (input == old_wi_state->mode_auto) {
> >  			mutex_unlock(&wi_state_lock);
> > +			kfree(new_wi_state);
> >  			return count;
> >  		}
> >  

Thanks all.

Am I correct in believing that triggering this leak requires elevated
privileges?

I'll add cc:stable to this and shall queue it for 7.1-rc1. 
This means (I assume) that its entry into the -stable trees might be a
little later than if we were to upstream it immediately.

AI review liked this patch but claims to have found another one:
https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev

