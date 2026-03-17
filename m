Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BF4FB5EAF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AF06B0005; Tue, 17 Mar 2026 00:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B8A6B0088; Tue, 17 Mar 2026 00:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50EC6B0089; Tue, 17 Mar 2026 00:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9616B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:26:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43E301B7EB9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:26:47 +0000 (UTC)
X-FDA: 84554269254.24.BAF866A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B3D920002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:26:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTlKDKdU;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773721605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZmHiihHzWbUm9RNbUs+WGd3rDELzc63Bwp+PZIFyS8=;
	b=7/d6fcgCCpQ+0yMH2UpCBOTBtw4A3cN5o8OyIuwNql7LTB1EnBJZhyepLxHyiOQjR0Ozwg
	hvKR7feoVgOfpgya0AXPQvLCeVEfYv1jTW+BpMq/eSAYQTv8PARpjtwTJ/kO+cyFzvM7Xm
	qoAN8qamEOUXJLxbx8VyzRbI9xi+wGw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTlKDKdU;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773721605; a=rsa-sha256;
	cv=none;
	b=UmlOcpgoDlPFb+XSZSFqzQ1KoWIKjtrlmHwt4E6Taah9GJkp7idmyA2gxbsxHFjJrgcv8C
	JR1NQO2dcYW2rOYYqfKxZ1uZAl9hoejWPltJAeJon+wDGvm/Jv/7wT2Smu1K+YppygPjt5
	zMefqOoX+SVnudCoShLukYF3GEoE/Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3D3343E94;
	Tue, 17 Mar 2026 04:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE1DC4CEF7;
	Tue, 17 Mar 2026 04:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773721604;
	bh=9Awbsg9vh3gWdgsI7WEfqFc76xhAUT4VlXF2nd696zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTlKDKdUnmgfyYNkASSEovavhFg0JzcPEcID2tWKD+t9hZfDJIphX6Jwe4Ovvb0fw
	 NakPVIK08JsWL08u9dQpaD2h5EcPIXxFn0vg+3fn9u/KKKtVvfEN+pe/Rrq87fDPYX
	 izLXK/AkoxyMwP2PMH43/WVP3p1Cr6bqwLSYlxBu61OjSvcp8Rm1zRrhKkuAuZHOtO
	 z3ywTtyCOBYy1/NIHPxQPgmqND/5wuLB2r3+tjf1FCmvvFci7ijoxyA/Rl0C7TRxE4
	 WsBAoVoWZSkq/Xrb6PU+i54mTsoMi+J2aTPXrDdHRX3G1OXCtKA+xi2kHObVpz3hCl
	 ERRYYI8whqoBg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 02/10] mm/damon/sysfs: add pause file under context dir
Date: Mon, 16 Mar 2026 21:26:36 -0700
Message-ID: <20260317042637.917-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8cq1ac7n894cdigdmb4szpuxrmj96xpn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B3D920002
X-HE-Tag: 1773721605-581907
X-HE-Meta: U2FsdGVkX18PHq0RcChRm6QyP+k927r921FwEgHZobSjV7LZDpswKL6NkTgTxCYFgVkEh1BvLEWu+je7zihY0lxmclYdDkJ0PcGMHVR5uS+SwrOP2zCazGLuw/xqqDXuMDPc1BGrINn6lS4oK1x8RzlFG+tp9l2fn3q1/gV/X1nPt3e9KWqbJ04qLoxNjNdI/YxGSU051mP12iaxhZLQJnurAQONScAHRMdCRZQkyWe0K1S8RuqN75yfDscI+EB1sThXX7IASgelTy7Gx8QL0shdCLJKCbHSAJD/ZBwXN5z7TYIQIVYMqc25R8U19vWmM2gY86XQV/rTBjdqv/1ZlR5RXN/W9DewENidwFWAAm71QJmRthqP/6vG655xcrFTZ0hX58EOgN9RqPAR2jH8Kg52RtPNPpKHgi0ry/gCrOEhU1PKy4ZdfYPxkQ23l9si3NjV9JZaGcZq1Hkb5caSgCq83zg7o1k17Clt7Xg0phKLTcUv4Y5fn08/bXgMYxE2/w/1gkyBZrfaCymi+EIql+MkHT1t+gF4a01OR8AWC/TyvXjV7laFNo5wqMvgBVCALgO5k1v6Udf5uagl3IxYkFiJ4CHxM/s4vYIYE7paew6gpfIgSJbYdMs89CJ4Hs27V0rLoX+u7uFern4JphcvfZdlYQ05St53uRunNT/3yiMzaeqIopzEExDG+kRW3AUvWlsu1O1IxybeJFCIscATykY6hN53iI0YSgrAlkLSvmxPGJyTWbxZNfL7RXAP05qAEUsMPCokrLs0t4WVVyP6DjQNWmnaGesVzlubEvfqxC8N5+ednriQDkL5mq8cPpzGRvfX/MMpmD2lVy/ULVy80RiQaBpBX2HAq6DUZRTzhIC5q0U0p3fvDhd0gE6lvj/YdeuV0ceyKih0r2sroUEBZK4a5oDHSXKZT2mCR6NM0rKuJ/Ntf+An0Ji78s3C9fFHdujO3iyO/cBAMvSvpef
 DlhMG/9/
 tbsb2U8gmHYLchKr2IOkjbm72MzwtKlNVVbVhh8IVB3spn9JQhCLuzDm1wC5KTv6hhI3AMYu7E3nT1lMTrK4EVoWAM8Dj91d/rEHBoBWdQWhM76J+Vc7Tdp5nt5mEmkHWf9d3uptRmFxMCoUCD8zCBJd+4EzK+8udCeOZKMIDN2XRTmqfgJcX2gmDirOaizmgTme+ONk2PC62pNc29k5I8MUW9IFey5QxC1nrKg7jeeynxZ/fo06u21x9Mwu5KMMFw25vJMWmQplrvQGcEllRkLi3UTsSpkXFQY6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 14:00:01 -0700 SeongJae Park <sj@kernel.org> wrote:

> Add pause DAMON sysfs file under the context directory.  It exposes the
> damon_ctx->pause API parameter to the users so that they can use the
> pause/resume feature.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 576d1ddd736bf..4cbb8b9aaba3c 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -866,6 +866,7 @@ struct damon_sysfs_context {
>  	struct damon_sysfs_attrs *attrs;
>  	struct damon_sysfs_targets *targets;
>  	struct damon_sysfs_schemes *schemes;
> +	bool pause;
>  };

sashiko.dev comments [1] below.

: Is the new pause field left uninitialized when a context is allocated?
: 
: Looking at damon_sysfs_context_alloc(), memory is allocated via kmalloc_obj()
: which does not zero-fill by default, and the new field is not explicitly
: initialized:
: 
: static struct damon_sysfs_context *damon_sysfs_context_alloc(
:                 enum damon_ops_id ops_id)
: {
:         struct damon_sysfs_context *context = kmalloc_obj(*context);
: 
:         if (!context)
:                 return NULL;
:         context->kobj = (struct kobject){};
:         context->ops_id = ops_id;
:         context->addr_unit = 1;
:         return context;
: }
: 
: If a user reads the pause sysfs file before writing to it, could this return
: uninitialized kernel heap memory?

Good catch.  I will add below fixup to the next spin.

'''
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1432,6 +1432,7 @@ static struct damon_sysfs_context *damon_sysfs_context_alloc(
        context->kobj = (struct kobject){};
        context->ops_id = ops_id;
        context->addr_unit = 1;
+       context->pause = false;
        return context;
 }
'''

Btw, somehow sashiko.dev added the comment to not this patch but the sixth
patch of this series.

[1] https://sashiko.dev/#/patchset/20260315210012.94846-7-sj@kernel.org


Thanks,
SJ

[...]

