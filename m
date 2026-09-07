Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AEE8C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914996B008A; Mon,  7 Sep 2026 15:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5E16B008C; Mon,  7 Sep 2026 15:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DED26B0092; Mon,  7 Sep 2026 15:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90A8C6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:21:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0325A16029A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:21:28 +0000 (UTC)
X-FDA: 85187935098.03.5835C0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 692D080002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:21:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clLvBAlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788808887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWijxrLdQDsGgRgXmpcSlRR5URwkb33or6eeb1Anop0=;
	b=IG1K3ZLOVoyEfR2MvprohqIDtRd6J0R34/FVdZjuimylSQqtW91FrVu30ReD4ZIw3wtO/5
	W5KQnV1c42AXtUWfr0/E1cWg7YKsoAj4SX+NJ+F/PIvbkCwTop4OOu6tiN+txOe9+0fB5E
	Q6l8HwtLrKkOzpKxk4g53eqqruagAPw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clLvBAlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788808887;
	b=Fd9HtbyFyyQBxjm8nFf/vcvtIFu3kUgHIh7JJHsPFlWmjQMLE9x8X0SztV3DLDN7gqYSiW
	4MrCN50fMU9X+SG70MPfJ++S7XTOz5Gdy6LObxDeCTots9dA4aDxb1x+20DSORx886EXGM
	klvgKFXaHEGDzqdeSRrT67d1xHZe7cE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AE40601DB;
	Mon,  7 Sep 2026 19:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AA11F00A3A;
	Mon,  7 Sep 2026 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788808886;
	bh=qWijxrLdQDsGgRgXmpcSlRR5URwkb33or6eeb1Anop0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clLvBAlf81C989FzdCRjFL934EgS/wHJBNl+CtcseYiWtQgpMf++IL/wOF4+ku39P
	 vyUSvZfPYATgAjvB53XIv+hkM+V92ZugAuOdDpsvRBHYVTy76SGwPEzc+zHA10kS0J
	 D+XsTik6h6/nYenZDyZKlC0/5k+DZYYeK89sp0bFrAHr5o3M7xbFSQ8z5Gd3lAO7GX
	 Hp2ARovbdCnreU8pCmPR2xg3+8X5UFjARnMzqldN75dQxx2AqgQmLiuXSyC+cbMGoX
	 SmcbflxKJk6vSFvOnfKDBm99+pdqJGb7OBiZXMVE5Wdp6Y0qGcJbyFZ8B44RBADs0I
	 ltr1R/8cjX0zg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Mon,  7 Sep 2026 12:21:18 -0700
Message-ID: <20260907192119.111740-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzke8hodqoss1saqjobbz5u8phd861gw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 692D080002
X-Rspam-User: 
X-HE-Tag: 1788808887-493010
X-HE-Meta: U2FsdGVkX18ztXzX22MWRb+cWQp3eGyyIiq6N+vvnMXeODBB5cGdGLVxEvPvo/Ve9/I9OjbEJSmKBV3iIiVidLlY6Kla965jOwpHIrpYWzM/S1jvEqbm3LnFHeDsdQrEhzIAgq0Fglejv9SAg25aLYLzQEo/ytqPJ0K8Xl+gnrKS2ER5dyS1T2m2jA1p0/rPeqR7/VbTsYx3z7PYk+Qfws5hvQy8pyG8yiMbbs0vqLNUD/Uyh6n6xa+SDvOl4/U+Gd+60qSJQqjvyl9MHTU60kIqRYMpY/1V5NabLzynuKMfFDzLD7OzKCf5YMHQeq1F1kz9FvnE9eYutcvi43akJ8F+yctOZtg1wlTrn/ZWShYXzOrbW6sYbX2w6ovhfhYDTEw6QKmKMUUgNeriSy9YMr4LkG5gZk1nMlHI1AygpWt03a8S9RMkfPcvB8Vw8gVpr32Wz0w+ltqW0jlZuId2UxZndcuV0Ud5gzs4ESVFeStIxdEgjIQtD17tb9+hAJm2qceVymi5Nv6ygfq18yxQuRB9NiyUS3/TPk540q0Vlm1DOXJ1O+88tVGrza2hQtHr3XO5iukAtlynaYDBt8UxRoaCmnfmqG2DM2Gk/5A/ax74sT/S+IuTxnJo1ocS8gwWDE0T4gX0fSwkFUofgN+BFAADpr6+Q5kLjbzV6y53sg4pV1ok0Qdia31Ws1HmuIGlFZHPODnLL2BdLS5Nl84JXL82SxfOf7tV/oOkX4RUYk3wK0Vaxrkuus2AMvXhHypa6LxmS8O0YASf+8DgcU41zX0Ggv3TpHQODbPbrbd1gGmqSJOVZEGI4cMMj5aI4jp6SXL5IPWeUMQFN18w/XO9KCeNZwMPsRedsYl5dZsSJeDTkQ1QUCFl3V6S8U3E7JFPma2TdgLREnCYp0slMMZIfD7jthp7zpDJ0WclxuxRUTlJ1zY3m/0Xm1vqw7gC5yTNUCxaBMw5Y13l0yg7Big
 K53gF070
 X4iL3eCahrrMA7p7Ed3LyTrLUUjc1GZSy/Kw+S3Fan+vjDhwRhU7jayA/yxLqyBZX9VFsVK1KspANs9Xf4kmUGkWOpm1Z94mxNtwUIeHLO1bJiHrZd58seYTPM5bijivLAbQQd3pwLJzclt25KsKnkPRzTi26RkI4fV1J2bgEdhBqcyziGyxDDdetf7iekuh+k0CkWbGFWPNPUV3eBc/1Ofhy/kKXhA2eoDeStqKA7oBpCF/o8qwdF5kyRpixW8xwkJzrPWBNr9zg1fSwzM5F6fYZTh+VxOa0gDUP2OjKsEOdHLVkl7fVLeBtNQDMKMCcDr8QJRf9BDphVvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 10:12:11 -0700 SJ Park <sj@kernel.org> wrote:

> damon_probe_hits_wsum() is being called only in aggregation time.  In
> future, it could also be used by DAMOS.  In this case, since DAMOS uses
> its own apply_interval, it could be called in sampling time.  Then using
> the not yet fully aggregated probe_hits could result in suboptimum
> outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based
> on moving sum to prepare the DAMOS usage.
[...]
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -704,7 +704,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
>  			__damon_va_apply_probes(ctx, mm, r);
>  			if (return_max_wsum)
>  				max_wsum = max(damon_probe_hits_wsum(r, false,
> -							ctx), max_wsum);
> +							false, ctx), max_wsum);
>  		}
>  		if (mm)
>  			mmput(mm);

This cannot be applied on latest mm-new, because this relies on a
not-yet-merged patch series [1].  Hence Sashiko also failed [2] at reviewing
this series.  I will post another RFC after rebasing to latest mm-new.

[1] https://lore.kernel.org/20260906184417.96621-1-sj@kernel.org
[2] https://sashiko.dev/#/patchset/20260907171218.101430-1-sj%40kernel.org


Thanks,
SJ

[...]

