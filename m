Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23511CC6B3E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1056B008A; Thu,  2 Apr 2026 11:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871F46B008C; Thu,  2 Apr 2026 11:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787D46B0092; Thu,  2 Apr 2026 11:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64E186B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:29:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A4EF1A0707
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:29:19 +0000 (UTC)
X-FDA: 84613999638.30.4B91C34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E43E1C0014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:29:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tC4owcZC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775143757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BslXm+DnhpwHGC+Wl8EMNat2qlP3yhrk1x1bVcDifmQ=;
	b=g2g6AKBmLI0JQUlQeeWllGo7qS5hCZ0ZTyR7Q6Lao04NN4XYruHEYRib0YoFBTCjBixNuV
	6PAh0C7og9IMXl2MIKN1jBwVrQiqdr2V3gPL2uxQpL7jpfikI+Wk9HRJ1UQRm1jQX24XGd
	hPJ8XHPhDEO3BZORPR1ZAYMyN/rkgYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775143757; a=rsa-sha256;
	cv=none;
	b=fGldMaYjoBE/FR/FX4zSUxO7nqtGm823tFA4QWNbc9wy0+tNICrT/BbRioY0ZFb601gGJ/
	sj6+cF+CbuNGdyggiweof+9pRPmcPpcIiyqcJJbSWzh8lH3ks4u5rbot/hMy7YL5iiqdc+
	a4h4zJGOLJke0NfYMmsKbnzdJal95NY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tC4owcZC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C8CC360125;
	Thu,  2 Apr 2026 15:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65227C116C6;
	Thu,  2 Apr 2026 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775143756;
	bh=WabYirgQ6jpKqOZUKjPabn8CatL1+vtHOMtJQ68RdrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC4owcZCt67SHzbolydwGUIVVOZF0KUxKc4A3aKQSKZGp8c25oKVepJ5l9CvMdN4s
	 ed0auHEvD2pNZ2WdvZs1HZHpVShHsipz9Bkmz3lQrW26cZTZVS/+4OUKupQwVXc2SO
	 ALWXZiqn4qjvjdiv82SVzUflZqHNAPOmv4Mit42IuA0cPaU36eyT9ClmrWE3zDgXfC
	 02Qq7H3CNqaUD96x5pBuyBViwwpsTcLhGRe93qg5qHr7yRN6mF8QLZEXqIXEi/Hnmr
	 P+6i50KadqEjpuf1po8pZoBYHeVo2MVWo8sA+3XRTWFePNej3Sa+iQz529h9lalSlQ
	 LH92XurPX0YWw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Thu,  2 Apr 2026 08:29:14 -0700
Message-ID: <20260402152915.75294-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402140314.74600-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E43E1C0014
X-Stat-Signature: xzj1e57eunba8kwk5agckdu1rfg87ssk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775143757-555531
X-HE-Meta: U2FsdGVkX1/UnbGUUxm3ITEgKrzUZO11CwFkvFUjWszQzFhRFzjmZh7LcYtF7C7DeNTx90r67Z0OI7MZTBrh5wZsTtVHJhVSxm73n3YclLTuGHIZHlDZiYc0wmzR8VcERJsZ2C/CoI/EzB4Dx68Hq/V74cKl61Owtv2cmxODE1up3noAufPD5Fj306Ag95NW4oQU9xtlvW2yvt3OdpVw3V8ZhqR/USi1w8U90Bs1x3PPZTvZPqJJ/HkvWCeVD7qLqVs/vPggl+a7ffH5zbvg/FBWp1F0bA7Ek2XyL8rVNBnYpBoYcvgoVi+BMPTbeOJQXLUXiGR747bBLJyBClbyM1ZpfSnX+fbt8KKmg/yXR0IhTbiZYcv14ZEF8FlWMqdfC7sogrL1E+D0C0nknZKZ0Ist8pXmSOViOZYA9khE5LwPAsnPv8sDvr/uSySS4BBz4V8oq6rkJAWtOkMthAtAkQUcCZXcncF+M2JOBKvc6ewL4E1XYQ1bPt0fl3Hctmz+AUUd9ogpj2bFZ/F8sqCPFFtYty2l29yiQgrIJGAthzHJ7OCANiwDibVbUXfIFG0xABSVcfXGx+7GV9dFrko3iREF4wLPzOJY9OZ3QW+uO+rpa/7rkWt9TQl7Z0NBRbhyuc5d8/evYCOZKtLcEPUV+BvguDD+e+PX6cJGt8YKBls6rAWDTAat5YQkqVEsk8Wd7uVxBCDidg93jk2ey1+O703WTooiEmSzVsNajKwTuTOm+Rbk8n14kDh1JT7M3AuqfT8bCB6jHNmeov4w3XKFIloxBWDDJxIdzCngbNKWV+0XZXFZitxmMH7oQUwc0eD+9wShyGkLrf4I7Wm3nds/ZMRb9Mj3eB+UitPmJqzEBL5BNoSJewb2JolLSSdxlKSxG6y7aA7HxjiKVbf46vho1jpt3QkyfFP4R5bBhseJKCdNzr/Ol3vgTSEiTYRw7dNaNfdL0TzMTk984L9NYRo
 w2Dz9jqw
 rhQkIj/BdxjkAyTGZGEzqfDFXYWkxIJtjWsl5zxEVILjsrMmoH3Amfy1tK8iN2JYExl/0lY3TN6g3WG3t0+lh0sRzvM2IA+WNGogWrzTGq3XJlZ52tNqzzZjI99JBJGuugRqWSgLmWwPHKETucTT/ihJdKpBZZc4pwWd3djGqIB8yiB59764OjIHOz7HIhoh6sgqTcMlugp7bg3ZUP5ivbVeVUvzn6n0B57BKGJ5qkkA4w1r8NoQfHKUxLeo6Iwjq9dVSR8iKAosialkq8RR9PA134t1XNOQpC4QYG6Q12O634Sc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 07:03:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu,  2 Apr 2026 13:37:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Problem
> > =======
> > damon_commit_ctx() checks if 'min_region_sz' is a power of 2. But if it
> > is not, kdamond will terminate unexpectedly due to the user's invalid
> > input.
> 
> Could you please further elaborate visible user impact of the problem and
> reproduction steps if available?
> 
> > 
> > Solution
> > ========
> > Add the same check to damon_{lru_sort, reclaim}_apply_parameters(), but
> > return -EINVAL immediately. This is to prevent user's invalid input
> > causing kdamond to terminate unexpectedly.
> > 
> > This patch is a follow-up to the discussion in [1], where we agreed that
> > the validation should be done on min_region_sz rather than addr_unit.
> > 
> > [1] https://lore.kernel.org/20260330233343.4083-1-sj@kernel.org
> > 
> 
> Should we add Fixes: and Cc: stable@ ?
> 
> If we should Cc: stable@, and if the changes for DAMON_RECLAIM and
> DAMON_LRU_SORT deserve different Fixes:, I think this patch is better to be
> split into two patches, one for DAMON_RECLAIM, and the other for
> DAMON_LRU_SORT.
> 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > ---
> > Changes from v1:
> > - Fix memory leak issue.
> > - Link to v1: https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com
> 
> Seems you forgot the patch [1] before renaming of the subject.

Also, if you have posted RFCs or another different subject patches before,
please add full change log.

We are dealing with multiple patches in parallel, so I'm not fully following
entire contexts.  Please understand.

> 
> [...]
> 
> The code changes look good to me.
> 
> [1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

