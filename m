Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CC410A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39E36B0099; Thu, 26 Mar 2026 22:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E114B6B00A5; Thu, 26 Mar 2026 22:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E676B00AC; Thu, 26 Mar 2026 22:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6D956B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:20:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72FDAC3E17
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:20:18 +0000 (UTC)
X-FDA: 84590238516.30.C1998AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB40DA000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:20:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTukcn8d;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774578016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q68p1t/Wn57txcTZhZNfUNFHf2WVDJzbIUrgY1H1vew=;
	b=Ue7zIwueKm7kqm9S8kzaimaP+rPnuVrE+qdL65Vzc7l5MjA8Ca/bBuAECcfUvZyPB7CViM
	xEl19Fhw+dMB90R9zRenKC3myfNZAmjSoHyHnLM2jWzMKmuum0LzynyDw3i5kH5DltMeW/
	XMN7n7j8FNrun+wWTjOcjA2hrX8y70o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTukcn8d;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774578016; a=rsa-sha256;
	cv=none;
	b=NEQTAeKS2EsLJ5YC44fMvynwtTY/mLvYbVgjWQwgWFNBx98erVd7DZO6+mkAFBkSSvFZXr
	afEZ2t58aBwlTyXe8vpxPRgjPxEt6v2k4DwO0ZZhYgFtQ+sshijZqQe/dNv7d354Rywh+G
	xjKoFBwyqA6lkGXkRbTjapcfHWZFdRM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE62643EE3;
	Fri, 27 Mar 2026 02:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6FFC19423;
	Fri, 27 Mar 2026 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774578015;
	bh=t6YKrGmnU6MgoUyeGbPCbgppVxSefPrhITRIGb7IYOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTukcn8dQ36D/HHne38+LBRSK/7+gdDAwVZFKcv/OKNn8LqRyqd06O+ooPx6t1RNY
	 FpB20+Q2KTHs9H/Hmfnriw4hQfTuellJe6yJJY32tmhLorS5GW7hBTf4i37nHoEjyL
	 6CQQp9fsA8N5L4je/6umM8HvN2CfkrPi53a0iGK7dQm0qqImDBNxkJ9cwnKh13DHQI
	 PtD2mJBH78Cm926mlTEqJVyRRsqRw9AhVdXVBZm0srt2al6zotqnOatAlSL7StgDLt
	 iVAdvOLqY+MkGPcjd+VeqBiWyz8YBS9gVi31wOiituBRQEgdzIXQBCepMY2hWxBi8/
	 x6BAZuqYffsAQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 19:20:13 -0700
Message-ID: <20260327022014.66567-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327021546.66441-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB40DA000F
X-Stat-Signature: z7b1ddi7a6woqwsk9hjpp9huk4sqfpoy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774578016-350735
X-HE-Meta: U2FsdGVkX19FmClbYIcnFDjrgWGPzs3Eh+AQ95wPgSBPUukYo0k/N4uzZ+lB3Y4wro/1ifKIg43zNDqmqnk2eNRwE4rTGtDBhv7LbE8prLDbA+BcGs8BFzN1/QlnuoPLhwRXVbPrgCbnnCf34+lHrNnRJUeDzkTcr1CKdaHFEjZ7XWv6Da7TGVYLqqVLcKZNm9+6isiRDfDgSZK1QnLiDXYL619JwIDUcT2i3a0bq6TgPzjmQAbyQh7BYYdagcLQA7T9wLjB7F1PNHh5HGuE+pySFS14RxAouNuRAcqqXcHyiJXop3vShWCkp53hQ4oUyK8nTtX+BD04yYZZwnhrURZr/Ma7nLjflw/HKWAO8Wmg3QR9BWEf2dn5i5d9/jD3fownfbJlzmSQZcRw7iUE7mbJEGTo7EZOoYOjBGNBMTuK70l+y24zScbMCA5ChZLl/60pymiptVosQqc4SYCXVIdHyNV6qHPMIkcfWO5eOCA3rGRHm3oXZJDyRHbk1mCLQr3qfXaWGKtdrtGP0T7Txhm3r3fgv8wO4VSgNHmUgSvUUz5JkHB7IwgjGebWPl01D4CTEc6qYPZPymHe7L2IaZfUM7hmG7/fkerPfcicaxD5UvwRAXFZx55PT1QO33Oy0IuwCUlrD94LDEw9Ln14QpChyIxCnx7Ql6MQH74jZ15oZwehTXe7aF8MpDfiT1C42Of2ChilLf6t/99n5Wd9WdCIELar5B53mU1g9u/DirRmqx16JhOF2zmQ8r5NHlXN44u6ycTziOn2mRGV9Rox5zjqvFM4DFiyoMxFY5ZKXx5sF3enpmUdfHz5+8T2yYJqa3IuFialQzhFQZyjbWfWK3R/gRwjSw+4bQX5Y0OfvSe723RY8FJPhdKUzKf3kOHfII7H/XSrSRLHEmWMmt6yPsBfxkkjUofp3dzgajWjGVQLi2dkDJssRthhRi1RiHnPvZq41tLKKFcgiHfEMyd
 zWPwSgrs
 7CRaZeQQ4UvqwkKEGdwsCOiW3/S4li89ZrtOXHlGvhSHmdVxFTHd6HFGu2o/XfaMny/ol7FrAXBhI09VXW+uw3ywdz5tEtOZcu4IGeeCAue2Z28vB9/D2m6ot7My+zxywYLorocbORq7RQtQIY2IO4hTJvG7gUf3YMMMEVzAXjd0I2lRpnbBp0E2uttOdMLHg2LnGtn9H15h4gmhY6j9K1yj+sPTbDfIpyTJ114HUjKPWraQQdWuiLoYjtM/d7J3tV98LXNrYw591usF7BKaOsoK3jHFoGokGsQ5Aur+s9Qx32+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 19:15:45 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260327004952.58266-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit 36b78ee39968830aca3d375219a2cfce73d0d1d0
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
> 
> This commit fixes a race condition between damon_call and the
> kdamond_fn exit path that could result in a deadlock. It introduces a
> call_controls_obsolete flag to prevent damon_call from waiting
> indefinitely for a terminating thread.
> 
> Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -3062,6 +3042,9 @@ static int kdamond_fn(void *data)
> >  	damon_destroy_targets(ctx);
> >  
> >  	kfree(ctx->regions_score_histogram);
> > +	mutex_lock(&ctx->call_controls_lock);
> > +	ctx->call_controls_obsolete = true;
> > +	mutex_unlock(&ctx->call_controls_lock);
> >  	kdamond_call(ctx, true);
> >  	damos_walk_cancel(ctx);
> 
> Does damos_walk suffer from the same exit race regression that this patch
> fixes for damon_call?
> 
> In kdamond_fn, the thread termination sequence executes damos_walk_cancel
> and only later sets ctx->kdamond = NULL under the kdamond_lock.
> 
> damos_walk appears to use the same pattern as the old damon_call where it
> registers ctx->walk_control, checks damon_is_running (which verifies
> ctx->kdamond != NULL), and then unconditionally blocks on wait_for_completion.
> 
> If a user triggers a DAMOS walk in the exact window after damos_walk_cancel
> has finished but before ctx->kdamond = NULL is executed, wouldn't damos_walk
> successfully register its control and pass the damon_is_running check?
> 
> If so, it would then block indefinitely on wait_for_completion because the
> cancellation phase has already passed and the thread is exiting.
> 
> Because damos_walk is invoked via state_store with the global
> damon_sysfs_lock held, could this infinite wait block the entire DAMON sysfs
> interface for all users on the system?

Yes, and I'm working on it separately, as I also replied [1] to the previous
version.

[1] https://lore.kernel.org/20260326135146.90670-1-sj@kernel.org


Thanks,
SJ

[...]

