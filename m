Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43871CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709CF6B0088; Wed, 13 May 2026 20:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA986B008A; Wed, 13 May 2026 20:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2206B008C; Wed, 13 May 2026 20:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF8B6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:53:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E87231404ED
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:53:50 +0000 (UTC)
X-FDA: 84764203020.10.539C124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55DD2C0006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:53:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=btvdIwZi;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7ZVUl7+8SFyCFnl46rVtEdaVCjcwazKdlJDKlEuvZg=;
	b=EeYBTxslz2RNY33r1q0P0dOGauP7pc2rJbMKJaERy6BW9y7eX/l2UWkt2jHwdGyk0HRcOC
	WReX6CU5ALwiVH4IVuw+SpBaNe+uOLRaKBQZ4hrpPQP1fizBJjVUMlqpwt0w2OZzE7LseW
	EHvY4HqdT62GpR+8U8JLuIkwEdEU8ec=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=btvdIwZi;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778720029; a=rsa-sha256;
	cv=none;
	b=Guz3xR8Xkz1nka0fS9TVaTMTWiL710XM8TVgqfCCzBe/RRkTbUIStGVGN6JBA6lQIjiLwa
	sVYYp6+qf9TRJtFwSsDX29hvPucZifNvUh50MVUSzMNiEwe8RCQHBDVttqz4C4hFUPkLjv
	HoNM9SivwLCsR31yYDAy2iHUFJ45h8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A967D60052;
	Thu, 14 May 2026 00:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F3DC19425;
	Thu, 14 May 2026 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778720028;
	bh=hyUigFXPu7+lHZADwOe0zFHa/0gaPvaEjifMk3qklnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btvdIwZiCdzIe6xjpNjJdzX4keWA+Lks75nNT1GqLzF+8K5R/vQanOVK+tZQiEiV+
	 f1xAMfZCBEN4jXgatP9+AGPUe7Otlcxk8qSap9MVFUUsR+vS1D+v5zfNDJuUnjgte5
	 l0U4Mr9mjhCj8VX13fPtoitz69U3ViqQchxBnk4adK+FutkSLQTyaOJOYvinWwPxLN
	 pp9b27OqkOGWA7kmxDPWPfQoFcgUGG+jZRcjlgbLViMBCwhTx6N2Y/fBI02kLa0d5B
	 kE40P9ltV9bHxySEIM3iNbi6vzYIveG4VbgYMwScQNGPX1hRaUywPPhJ34zDhrLLZZ
	 oTj4k6evAJeYA==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] tools/mm/page-types: Fix ternary operator precedence in sigbus handler
Date: Wed, 13 May 2026 17:53:14 -0700
Message-ID: <20260514005314.148447-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513022120.58033-3-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55DD2C0006
X-Stat-Signature: jcgqtbfa47urfhjq5dt7qq57cj4yxhs9
X-HE-Tag: 1778720029-496777
X-HE-Meta: U2FsdGVkX1/BczJxsegk+EjNFIam2BMCQ4uTNSZqsihEqW/w4CbiG+YAGVvtYv+OmtjanPC8gPpe12+JrYdvJ78KfxY6UkWHNIm+vHx7sFinz3fa/SJ9wyakv0dOkCoZvlzwU23attOeD3RDVDXTEZBzCxGD4xtTCghLFMEVl2kAIXa3DOazupBDOr/szbsQf18nJCvM+O7UWLxkcTcffkjkF62T08HE7jrkto0VK2IprtOsIPd3C9fdH0eDI2v9oUX8bpVtUKTHa2VNbH/QQJXl8E6VTDPdWC+8d6z+0MlRagvDvC8ZBeOzhjSi5mksz0v7hS32OS7ln7hd6aptfvHllaxy97o1+gF501JPpGhJn/PD3eyXJ0OsnirmVWvh7RGy7iB3dZQL+cGuPzbtsgMsHXAKNg7EluAWRtyG+KRKd/GabqRTBC+unsum3zivszJ6DNF437RoCysJLiJr36kPQoI7udRcVito/UiWIyA7btRW8lkurcz1DJ+c91RpzHdYz7YK8oLyxUTwsfnBU+TNZRryoSaVA7gG8a3gFW48zodpGxYpWv/kJEo9EAjuU3NjDwsrNv1sRT5alfpw1Pijb2rkN5npC1uWjX5zhkP+llq7Ipr3rjgh+zSl671G2SKhqZ2lRCfVM4bqGX0plQFphBGDXc/yAHZvzm3Tic51HAiGwOL03RmMF+NZ3SnMF9nmtQYv1sMN8VmuMPkVbIMfRzbylIInsLe6mOJzKeOF19focoDlKfxbFVzhwHGzfA8++8zJnmzQFg5LIMdQWTpHSF0Jb1fmjKv8osHGltxc6d2Ip0EV9PfQhQA2ucDvbk/nkR8RnoDPDFmN3vH0S+2Ay10DnE6tEoEoDvEBMulmplYH24hM4j4GfNAoOh098bXKiE4mfbF9dpTXi30QGIAaf5ImkUG603gZCwv4/w9K17ns+iutlduUyMET8JTe25ZOnJYtcz2SPgZIaUb
 USCRjwLZ
 uhHLPH/WZ7MMlgnTeLF1mclI3BcpwL8CRjAZFj4r/XRAKsdtJTNQxzoq9qd4w8+1UfGEKsqIdqooBkShIpbagfmLqrECl9w9NSuJKLJKSfVdRAJayXmrenLF2hvgx1XICgX6ysdXNl8e3F5FQc44H0H7YHo4K3akW8FajdUefVzxeO9S03/vT7/+ZIyx8Y5VDsf7JJZwL47MxWbZqdcDGpTzb5WI25S8lYhro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 10:21:17 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> The ternary operator (?:) has lower precedence than addition (+), so
> the expression `off + sigbus_addr ? sigbus_addr - ptr : 0` was parsed
> as `(off + sigbus_addr) ? (sigbus_addr - ptr) : 0` rather than the
> intended `off + (sigbus_addr ? sigbus_addr - ptr : 0)`. Add explicit
> parentheses to ensure the correct evaluation order.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

