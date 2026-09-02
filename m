Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CAF8C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2E26B00CE; Wed,  2 Sep 2026 11:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562ED6B00F0; Wed,  2 Sep 2026 11:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452256B00F1; Wed,  2 Sep 2026 11:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23EF66B00CE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:03:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B32D8120253
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:03:10 +0000 (UTC)
X-FDA: 85169140140.04.12C4F4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1348A140017
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:03:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hB/7Tayw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788361389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMDoHVoHQODfGlDRyrZ38N3/qQqV14jIqO44yngpLFc=;
	b=bpgeqzyC8VV+ivuGeFzCjIHSCKsQcQ4Ib9YkgWa8oQ3o+MT1XgpVTwIt4p7RSxupzt8T8F
	hlR58yjy5FdJDV5viWNW4DCLRFX+5vSX1X3s1qvbq6LkMlElsqNW3b9Cpzsr7MlBcs3tkX
	BXND9dOLu9MYSeM59G1tdjZcmZPS9Ho=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hB/7Tayw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788361389;
	b=HMwVScDdu02zbc9nbrc82530pw2QE/XomjakrTiRcFdx2uJ09zQWSQTmwIeC4hGarFgmRA
	xSP29Iw8DXaquvpFM50Y4NyHpPw6ifvxkfqbt86z09UqayZufg3OJ9wgvPr9ZIfDBF7iBH
	zFp0nt+/E6Dbx2nd66MCHmeCASK1VGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70656600C8;
	Wed,  2 Sep 2026 15:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E301F000E9;
	Wed,  2 Sep 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788361388;
	bh=gMDoHVoHQODfGlDRyrZ38N3/qQqV14jIqO44yngpLFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hB/7TaywyBLNvyyfXZpLnv2VPC+1OBREDQbQzJFMNZIWJLrhHcUVAIs+Br1Y9xBRW
	 ayvecCVhX6ljF2/m6xEdRJFROMVd91LMdocz6umvDzN4CYyIUzQM7VrEvT4qKAPPKO
	 rqcTxRvSa9tuH5VtzsqvqAXCzOywljr+GRaJwnobjhwBEJS4qzhtHlMJfr5/xgpTja
	 I8k7jpkumLZPtm0O9hWJJe+mW6nIivu4dFlLf/0Oyb+ZiZnXKTOfSKu8vnmwQ0vdAJ
	 csm616junuXT/URSmjNg7w3Nv6uJitkeQrPJlheK3zbF2IUU9AqF24dA7L3db+Pgqq
	 vAvXpoKY0q39w==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: allow esz to be set to zero
Date: Wed,  2 Sep 2026 08:03:00 -0700
Message-ID: <20260902150301.88535-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902143605.6785-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ucipz9mmmt8rzkk1uzqy3uwcxrykw8k9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1348A140017
X-Rspam-User: 
X-HE-Tag: 1788361388-587463
X-HE-Meta: U2FsdGVkX1+c2COqKqu+eDKXnDvpUsZdwAVTdjLAMQBI7VKhTAblXFlJnwG466YXLAFrb2E+8J6/ImcEPmgnsIQ56pn//mrrmpeTbeXqxT5FU6LtfGcbsYsfVx5rh09RaA/QeeJUsXbI2if2qQIv+WlbnSQruPbeQfRmnD1Fz4lyNP+L40KBcsqXbW2Ur7bL0mjOPn4Tvc2MPDxpf9j+Y1/1OXgUtJMyQx7scN1A+OsEZMHSDHVou30qaiGtXY5uH2HSl/0BlZOMOk7WqM3yElFvICkvAXdaqVbTdTTk5h3tMf0vUIZGHNO/uCvhb6Ksqd8jJMwD45Iho2NM+lOrDFoFU5mr9j/+WH0kyQTO6bBKRhWF2GwMHI2ATNL8s/pn4j6MLIeovUH+MLixPSF2JsWtRLtFW/3+PXFYxoYez0/nZzWE61hMCYN0JCaYzi2uWuF+yXHeCd5LtEzG9djcMW++SxZMAer7beVlJ2SaoIt/4iBiKvFWNaocJ1QOEndUnFnYdU/gyndShuqtsUMHNi+dKikOoRBYcyDUPBtn+xFXjqx0leIW1HLHFpqNG51fPqMGM36D2uwG0tRUC14wyxJFcI6O4LMddAlALW0VIhQGstI30g5/womF40Goj0P6tHPLbproaxrukKYNGr6Fy5OL+Z5gqh8bzcW4IB8+KFkirq24tv8Q3snJTiwGPu2KtOi/OsjmybsxeqRvGKn4mFbvz15SVCLiTcV03kZNIxV15zXddtMIt40bqHHvYs+1hW7XKAfVm/JLw47msU5v+x7iCHZxER6vLpQQiCwOdNXkRGKib9R1Tx7hkUsDuSKtRfwF8UUdsqdkhaFFpRb5PnpOX4eEMQfFDbSx0IEumk/n+VrwOT2ki/F6eQMmXBdDrljgCK3eBtJEHuHeSo9GlxC88fA+CbBzab9xURH79Fmud5e8c3QGgiGkVOdKe/6zX2TgA5DxQ3ANiWKX6dA
 x5JCokQz
 iulyJ22do2+qJoUVOsi3MQYeNd4WlOxR0ypgi8mlZD2Un3+WrN6YnbYk2RSuuE6XPSPbEjikxHBFSuDSVju8KTYhFUGT3G1iUYW2Mb+94LzSdjRPbM4WM+4u8wCDRvY6NGgW2IbbHASPG4t+aIYn5sH1VUOiG2fFVg6h+gh2e1Eenit14IBBn8cRYQI/klXgTZiB+lErBW/MltW/VagB+NtvvNtT7OPloOKRuY0Ubp3EsQeAdKKx4KMHi41GuZ2wztdeJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 22:35:20 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Wed, 02 Sep 2026 07:13:48 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed,  2 Sep 2026 16:20:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > When the temporal quota goal tuner determines that the goal has been
> > > achieved (score >= 10000), it sets esz_bp to zero so that the effective
> > > quota (esz) becomes zero.  However, damos_set_effective_quota() clamps
> > > the quota to min_region_sz, preventing the quota from ever reaching
> > > zero.
> > 
> > Where in the code it is clamped to min_region_sz, when?  And what user issue
> > this can cause?
> 
> In damos_set_effective_quota(), when quota->ms is set.

Please clarify this kind of thing (when quota->ms is set) from the next time.

> 
> '''
> 	if (quota->ms) {
> 		if (quota->total_charged_ns)
> 			throughput = mult_frac(quota->total_charged_sz,
> 					1000000, quota->total_charged_ns);
> 		else
> 			throughput = PAGE_SIZE * 1024;
> 		esz = min(throughput * quota->ms, esz);
> 		esz = max(ctx->min_region_sz, esz); /* <- HERE */
> 	}
> '''
> 
> This is a minor issue, the main problem is that it doesn't match the
> description in the documentation, which states that if the goal has
> already been [over-]achieved, the quota will be set to 0.
> 
> Original documentation:
> 
>     - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
>     fast as possible, using maximum allowed quota, but only for a temporal short
>     time.  When the quota is under-achieved, this algorithm keeps tuning quota to
>     a maximum allowed one.  Once the quota is [over]-achieved, this sets the
>     quota zero.  Useful for deterministic control required environments.

Thank you for clarifying.  Please clarify what is the problem like this from
the next time.  Without it, reviewing spend unnecessary time.

I feel like your recent patches tend to lack such clarifications and spend
unnecessary time for reviewing.  If you unsure, please ask questions first or
use RFC tag at least.

I agree this behavior is not matching with the documented one.  The point of
quota is making DAMOS not unnecessarily aggressive.  Hence it is designed to be
set as minimum as possible.  How about below?

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3485,6 +3485,7 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
        struct damos_quota *quota = &s->quota;
        unsigned long throughput;
        unsigned long esz = ULONG_MAX;
+       unsigned long esz_time;

        if (!quota->ms && list_empty(&quota->goals)) {
                quota->esz = quota->sz;
@@ -3505,8 +3506,8 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
                                        1000000, quota->total_charged_ns);
                else
                        throughput = PAGE_SIZE * 1024;
-               esz = min(throughput * quota->ms, esz);
-               esz = max(ctx->min_region_sz, esz);
+               esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+               esz = min(esz_time, esz);
        }

        if (quota->sz && quota->sz < esz)
'''


Thanks,
SJ

[...]

