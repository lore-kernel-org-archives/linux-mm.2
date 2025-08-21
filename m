Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7C0CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24ADD6B00ED; Thu, 21 Aug 2025 13:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223E06B00EF; Thu, 21 Aug 2025 13:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FBD6B00F0; Thu, 21 Aug 2025 13:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04A506B00ED
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:24:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABEF31385DE
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:24:49 +0000 (UTC)
X-FDA: 83801439498.20.545E7C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3222C1A000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:24:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OaXP/rtT";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oB7rZpsJyfo1hDyIYz1f/9hjWuunWICQW05edei9cQM=;
	b=JXJkgeWgSyXZoE/7Bo5exA43XtyRqAJRfYDDOSTiKkXqGwhZ0K9vW4fLahiABYSf1yXBeR
	+AaWmLqPHFX6NFbDbWJwmDEGxeJmsMr+EshwhOJCk3iVBu97Gc++3gZMbqvzOd6WRZVl3Q
	XthQJ7WgwfyroWXjMBvFhKGXz2MzvtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755797088; a=rsa-sha256;
	cv=none;
	b=veQ7nwnqmNoUwQsMzOK1s+4wuDYDRyukbof3Wj5JmPrEtzIRIUBjFUTlS4pxdd2rkLlM4l
	ZLbPVyFvQSiP6pKi0D/gxQDv7wwkK0WxlccDHuGqdo2L90ysJcYvKkKGLJuVvLE5cXkpmA
	3CsgNM4AnidDck9dAyYLQigNsn/NyeY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OaXP/rtT";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2477E440B3;
	Thu, 21 Aug 2025 17:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50A4C4CEEB;
	Thu, 21 Aug 2025 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755797087;
	bh=zvag0ItsqVk++H/ShYx94vCt9ir2zllvDThN1dD+mBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaXP/rtTLlvEoaQqa1Dn+8YDGCh29zSrfDZeUKHufdVMfC3FOWf2+DJ7xGtOaTJt1
	 PqgBJZLfae67EW8bEpGXCVCPIYR/s5wowwRc7W0KFusJ6U0C27fAyV5J0dnqxplY/L
	 7d2Wu0yUfw+tN+YtxgVRKUJqxB8uRIKgQD3FWzsc5mIrli5QnFFY9LlO6Wnr9i0BLp
	 yvsRtkbP0aj0NHNkpvIM4XVRd9JwDqHkNs1aURCbwNzyiC5ABeTPvlwhjaTTLZvr6g
	 qPo2Yt7sP9dqSJ6bCs02Q0nel9gzQh42RX7i0vhHaMh02pCWsBJmxGXd2LrODeDj28
	 443+eEjWdScQQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 10/11] Docs/ABI/damon: document addr_unit file
Date: Thu, 21 Aug 2025 10:24:44 -0700
Message-Id: <20250821172444.82455-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-11-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3222C1A000D
X-Stat-Signature: d8uex5ujic6sm3ohynqdaewgh7try5nj
X-Rspam-User: 
X-HE-Tag: 1755797087-363450
X-HE-Meta: U2FsdGVkX18TPH5E4Uf9F/thxAeJNpqUTzaCarHlnc66IIazszpnYTuyHxqnufIMeZmtsK79ZEqfG4u0z395H1mXpJK5TloKL/yaJq664oTJWk40kpikhV3Fm3a7lrwN58ndzCFGSIxd1iHj1gEXxSVWuGbOvBUYgTL4sMDkJ71tDAu9tU6AXY/gbBmtvn2Qg86NaHO1XA/hopRKjtd1smOWk+MWgfCAw3gBjDdrHaHRPM5P3vTxgZT/9/1RYZ0AqmtjZjbXFWnr5W2yqZNNoBQAGZm610Cy3kmX+/Fei9xeM2VqzaljJD8qe0PpXJhv6swgqj83p7ZaebR64doon4YAE8Ei5BuwL8lWC1A1AqB1dwrCUkkOa7UOggRsNoWcx2D3ep+TeEjbpRUZRDehHFWZujf0HWf1tIXp2nJqCTqkZ0VIWqZCavcb97JiBnepNW5Kmnxl7Ao1FZQTM61BfFWDtzl66ChpWqG4SAc9sygCBRy/KuotGl/V30OQXh8d1sahdAzSu9OfxNp9rftdE54Kn8qtDKFL3oOdTDHxcLM04r+9iQo3dDuCWZ9yJg1HoVguK1rzEouJjNzpRKD+W6MYAGtlBlT04Pmf1H9l72eRbEbXW6C2zb9syffP0dIZNtVTzGFi9OChvMaC5uGy3bZDnCW73AUno9lnBkeizWEq1S0b++G2ZfL4argxL3hZovqfZZBBr3NRZRzY6sqe8PLrxlrYUokU3j/vS9nM4Jb8rtI5oLdqXFn84ovWbBFSzhBOHj4zF0aGHyRkrh2/NFr/O1i0vp1qSAZV5HJotaJjv9fKTutqbYH0YFs3XB9578Uvn7vLPW0B46iZcG34woBvPF0oHGfIiW1fmUCcxpmjSSy4/fEdp+qypjvXt93cCHARAFro/qUIAkdqQ1ojvbFkfzO2hnb1TBJVsKXnyeFpGhsQ/H3TX1xG/NwkJXfKAWk67WSHC8g0wpvm9yL
 jMGyZcRu
 mQXqwMKHg3Y4tp/QB7wQV2NqBlUg0hnxb7k88wFn82sBUQiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:58 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Document addr_unit DAMON sysfs file on DAMON ABI document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

