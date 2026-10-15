Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F63CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344256B0088; Thu, 15 Oct 2026 10:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B286B0095; Thu, 15 Oct 2026 10:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2322B6B0098; Thu, 15 Oct 2026 10:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 009276B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:26:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BC7A1A0A9F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:26:01 +0000 (UTC)
X-FDA: 85325084922.04.2266D63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D565E140009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:25:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifOWUm4c;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792074359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK9QpizG4Ez/xmCFB+Kev+kIplhhTdrrGQvFvPcmbYM=;
	b=C5OKEAgZevkww5+U0Rset63JBCakwtD+NCVOvD6BuNlGrdyAK0fJLkztIQmcF3MGEiZdcg
	ubuWTq4ylJ8GZ8NjR0bb8u6p3tp3G8V5tP1Ys8A9vPGHVrBc5I68r8PFu2pF4pwHqfRI6X
	HLrDCZHEH5j7JxHoj9CzCgFwXbHjykE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifOWUm4c;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792074359;
	b=fZkGDQiqptpD4NyLxZsInOFukmc1h0EIYJbtzLZkWLyDaaUoOvROgSppmGRcSlfXBF7p+F
	mgpfykyOKS3QXE90U9BiqsSQySAsnuzc6nbeqas9MIjvPPtuTrtoJhZ1a+/8L58Aey370u
	ZcIcFyHOOAcqqkZO2dcc8pphvX7BjPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BF8443CF4;
	Thu, 15 Oct 2026 14:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58421F000C4;
	Thu, 15 Oct 2026 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792074359;
	bh=MK9QpizG4Ez/xmCFB+Kev+kIplhhTdrrGQvFvPcmbYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifOWUm4c/UtZ6cHt8h+s0NRcM/TO90Uv4HYt4iBWL8yiHHGfbev3In/FHJWhhIyu9
	 HFS8IzLjMm45YjEPU8xUgFseEBAG2L0VWaKnTzuUlzoav3LC4sMZiD7vVGtfiFuSKJ
	 U8r+YNN07yPz5jZKhKrVujrhGEudOIyL7SCCEw2lgl5oCL1MLqCVwR1mDbA2Il6oVX
	 G3KV21ojGD1QYI1f+34SGmQITmpfZNU8dhTZISmkmdkr0TippmeK13a80f/6EwFAYa
	 c2af4nUA2ctsH24L2uPZsus5bqfF2EHejdEnGNZMfCWo3NJ22CPeG+9cGfRaNekvWL
	 RSzMKEk/LBvAg==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Thu, 15 Oct 2026 07:25:51 -0700
Message-ID: <20261015142552.104856-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015135801.19326-2-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D565E140009
X-Stat-Signature: wone5a69s93s7d5pc8h4f1senh8gxabc
X-HE-Tag: 1792074359-172438
X-HE-Meta: U2FsdGVkX19hlYf03kDySMhyaW+1k6Qdnt1u6vTUxiCPbvCVOwZATAoQiiH7HdkA9ZyOaKUtpPEiB4moRlujK0DIiCvpYbeyqQzO8dK6yQW3GcVhsxMQhHeaqbpZpipNYlsAglpAaaS1JRfN6oHt22TU91ScHLTFzza4SokA11YKChu4Gf5mJgNSMLFwGKBvY7MM15rZ64SIZ803Ly+seufU+xW4e6fBL4Yf7pvAfdUFF6vKk364rCzCIUMzOChzCfd7jnCytrvEDjK1YGbgqrUCeQTkdMKrOKx5XOSS2SdqG167rvAv/SN4Y9qKJff6q41aqCsaGCWd7lTQ0mvZsunQC1AwCrXSVG344zhqUrpUTQlcsi+2RKzpxAmHzMdJtINN6h6dqVd8nH+lUwu/I+P81by2w2EudxFye/XOfmiYmzOfoRFfBvA6gyTNdcfHJKszxcsZ6ywmoeCv4La3NFHzlRfSE5rwIMcsng0dCmAigpFWE1noz1s5nGeWifTmlqtw7ZKSCh0XfNgzf9gAd+/vLBC51dXfJ2ymOiwoclZV0oBHFXeW2NoYaD5ZddJK41xeCzOv4pvMd1pbC/b3KbzvnSvr3t1LJWDa7JDl9gJKUFEgAqbJa/y4aW2YigODvVNJ/6tkpfoGt9I3J92GxBJibdiTHQ3CQ1GfPqXkvhIS43/Gta6AmT7729Mke+7I5T27qn3JAI/HaFnXUwPXtRX4SLs31/xk62h9KzX1b867Ty3QI2C5HKcd78sZkX8KKuYOZQgb64YXBMX1cF3lUn8wnFcf7YBvXyzIciK5HgQyTkTLO49rOrNizPXp+EwuFKTMwbl8Mbbj0UxIkuK365vgvAD3Nw7928Z/gElx0ibyEqRC5zLodiE6SkUILxecWgcHUZq9yYJUFsCKoPohIQ51DbYbvlzThbByeyDprGUtmwcWU8OfG7YiLbv3XjRy7i95rD0DXCOt2CYXKSZ
 sd3P6ep3
 B5STCLN+3s9ZFeOWD3lRegp2Xra5+Dg/2jqf3RW+9qiJjyK/nTzEN4wcrKs7fdQXkw8Y3HTuToNPYlJKKH5kW5/efIfwzlgwXDJimy21JoIeC+P1XyQ2J9AgR+i538PoMuy3BCbg26kQreAZtRfUc8OnmONPt06HjKup/0B1y91UNgU2hRmYh0DlorUOGXuBhuErbOzBZO6yQjp7xCVxSakasEsEkO1T83OhpLdixu0d/rACm++FBWjJQIFATUiaBw7EUFbOci3hbkK99nH55IHXROA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:27:54 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> In damon_split_region_at(), we copy the entire probe_hits[] and
> last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
> that the number of probes installed is less than DAMON_MAX_PROBES, in which
> case one or more iterations is/are redundant. To remedy this, iterate over
> only as many times as the number of installed probes. To do so, accept a
> struct damon_ctx pointer in damon_split_region_at(), and update all
> invocations of the function to pass the new argument.
> 
> Also update damon_test_split_at() and damos_test_filter_out() in
> core-kunit.h to supply a context to function paths that call
> damon_split_region_at().

Looks good to me.  Thank you for this patch.

> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

