Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE419CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED3F6B00AA; Tue, 19 Aug 2025 11:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5FE6B00AC; Tue, 19 Aug 2025 11:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4029F6B00AE; Tue, 19 Aug 2025 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDA46B00AA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:56:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CC4DC0119
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:56:09 +0000 (UTC)
X-FDA: 83793958458.03.50FBFCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E9DFB1A0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:56:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+FnP8Ll;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755618968; a=rsa-sha256;
	cv=none;
	b=FRJ//SCfV44pajuJY6zqr7wBdkAcWUU9XgH8KCe9cnMntFFc78zqdxYcb2t24OJwHpfv/r
	OE8FzVasvOtfnBQERotGeusOAEHlBBpKxshihvglFvemJWuDvFCYGHs4E+NGjUay0kamBJ
	nH3Z9AlrA5T2KlFiZC0OzFaCN6L077E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+FnP8Ll;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755618968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmJ+rYKqd3++tSO0JClg9V8JRAtO9SCMOSH3OmpkCPw=;
	b=qummyhvuuWvQ1o8djmmJANnbW03OPag9et2vbJpR4KQGMyVQ15lzEsS+RcqLxOVtt4H8Tt
	ZRh6WLmKnypOxePWeU91k5IeDcpE+XOFU6i8wrfZ4Yk/xsoP2l6a3FbjN0bIOziaNNXI/5
	OYxqxQD+onzY5xQz0Bv7rp+F0629rUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA3460209;
	Tue, 19 Aug 2025 15:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F00C4CEF1;
	Tue, 19 Aug 2025 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755618967;
	bh=398xSgeKockn+VZiMVa3lgHKcNI7Vuh9qOLHZCyHk1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+FnP8LlLp7ASlisgI3sVzfWvuMXSm1BvTxfqwLdTIgy2ARBLytzAJvpb64jBtfuR
	 9Ge304LXAJSyB6Mr7oR3sRZ9rALxVUjvR666lFoIguqGUix6I3CM10NWFmnpGBlc2r
	 dZcmObCMzld1Q73JWSWk06PSlGsEPamlo6HfcMBVuw/mf7W/Fa3MsYlNjLMywDu4L3
	 wEm/199F/QMOyGf253LuAjQs7akb4UFnkpQGt9vuaDZ5case9fZ2qq5touwUrV7Vbt
	 d3TnrtEgzzeB7kWmgItQ2FL0tE7twzGlwCj2BwakafuLtFVouPERms35kFkltVA1ZM
	 8Ljs5MgQqUtwg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 07/16] mm/damon/sysfs: implement addr_unit file under context dir
Date: Tue, 19 Aug 2025 08:56:04 -0700
Message-Id: <20250819155604.43810-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <c3050ee1-a3f6-4f3f-8cd3-a5d67dcdcacc@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9DFB1A0009
X-Stat-Signature: bzbnftuyym4gh68q4s3hsoj91gc64stx
X-Rspam-User: 
X-HE-Tag: 1755618967-63381
X-HE-Meta: U2FsdGVkX19NHi6EFjRZbYBX5YSVBURrHqLeWJCqgrjNVwmrl9kJaVDAGmBAIkZAQZiHldbsp0MyHuH2ahW8C+DFyij1Cev74T1DGwlGC4KWIljAnncjj6O2+/TJ+pObDS8ogTEJGTozgKXlfBMrSGQH0nposh/U8UGsFxL1gstlTOrCnPXVLAISyw5QBCrcx1gfIbLwKSkrQW68t/MHxvmYc3iNmUTXO/OmhczmOQEsg+FFinuUCnZ2YjsNLaweAUKDoynU6H1Aq31A30gQxrkYMIKlFCQly8WPVb+Cey7AJ/jyHfWIqcLppr0YpQMIoSo4ZPzPl29TipKoSM0iNVfy0qDALnzPU+j6edxXrZc5QQ3TYTxo2Sg+6JT7yRIgHqzkXjga6bKnAIAEnCF6dSIRl0Q5WiZJ7kUIT2qTksngff84zICxznVPq8MTR5f3A/R1RsApdq9AG8xND7HCjGe7pJpxPjmsrYuxkG9OofxWUQ14yjXUbaBVZCgPl+gtMNpM3cVuKnmjVdgCq/B1OWO95BrpnGiGvinBGM0SLs44m59UPJA0F+BHbaSttqAvPrpFL1z3bDy5Rj7nGEyjHqmRPYS3HjAZ0W0MXnGgcdtpOB/ijOqoTUw5mlhS0sDsw9WDbXrOlL37cw/6QMrbfBurF7mLGL1UUB5vbHbhhHYQ8EpsRMt3FL1+ARfMr3ZlCA3nKxDQ1EvVsbpEAQq1E7jQuXwQr8Rc/yutQcPjc38XV9mcsTzHsFriW0GvluC1brkIAA+84rEWBdY4d5xbbt8He1CF7fMziPSMjlCmfwBjC8O75OjMusIGzaYE+RCabrBOu8is84+1Nh25OsdqshINfqlwSfPnYq2/iM7S78HSsItO15QdiAe6ihrkYq1m1psCzmnYg8TswqIDzQ9Jol5zXvIYrOz35bxKwXHTzoAGI/bwl/C3bKpxJOMpFiwSq2/Q9N/sxAg8bYmvALg
 BjMHPu2M
 9p702RzN2rgFbxFYoI/RabuukaDeScorxvaLjIT/MdoPZF5O/N1+zdknta7Es7b4stMwnoYSaTncpEZAT4zwHj/cxLz5e3YyU1iGowzG6nA5+RH8TTfeK9pzIx7r+OmdO/GVd4Ngk02uIQih5EN1r210xgXo4+XKxPRMJuRAg1+7zfY24rhIrm0DPMUgLPH0N5v3fudVJ7EKbI7o81TWdhkFmFHK+gU0VH1h156DJLOn/21mGY9FrjflNuLUuhOAZV8uvSI3Pz56zs9akSiOSU3kcwQ2Rh7hGQEMgzKQbqQ47nDn6MVVZe423iw9Xy5TTtYS/FaXjZ4esi6BDz12teahi7SqUoQXTVu0ox2NF9Wq3nVFQI/p6Ln7njg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 22:45:58 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/8/19 14:24, SeongJae Park 写道:
> > Hi Quanmin,
> >
> > As I suggested on another reply[1], please squash attaching patch to this one
> > when you post next version of this series.
> >
> > [1] https://lore.kernel.org/20250813170224.6128-1-sj@kernel.org
> >
> > [...]
> >
> >
> > Thanks,
> > SJ
> >
> > ==== Attachment 0 (0001-mm-damon-sysfs-return-EINVAL-for-zero-addr_unit.patch) ====
> >  From e0a5aa5e571ecd0f58b0914f8fc8562a60014ae8 Mon Sep 17 00:00:00 2001
> > From: SeongJae Park <sj@kernel.org>
> > Date: Wed, 13 Aug 2025 21:17:03 -0700
> > Subject: [PATCH] mm/damon/sysfs: return -EINVAL for zero addr_unit
> >
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >   mm/damon/sysfs.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index bea782b0a711..eb4269383bae 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1422,6 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
> >   	err = damon_select_ops(ctx, sys_ctx->ops_id);
> >   	if (err)
> >   		return err;
> > +	if (!sys_ctx->addr_unit)
> > +		return -EINVAL;
> >   	ctx->addr_unit = sys_ctx->addr_unit;
> >   	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
> >   	if (err)
> 
> Aha, returning -EINVAL when sys_ctx->addr_unit is 0 makes sense, but I wonder if it
> might be better to prevent users from inputting 0 at the source instead? I've attempted
> to modify patch 7 by adding a check in addr_unit_store.

I agree that is better.  Please don't forget adding your Signed-off-by: to the
patch.

> I'll send out the v2 version
> of patch 7 later (PS: I am performing a comprehensive validation of the v2 patch series),
> and we can discuss it then.

Looking forwrd to the patch! :)


Thanks,
SJ

[...]

