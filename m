Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52262CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC6F6B0005; Wed, 17 Jun 2026 09:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACDE6B0088; Wed, 17 Jun 2026 09:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9976B0096; Wed, 17 Jun 2026 09:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE846B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:29:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E88512041F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:29:14 +0000 (UTC)
X-FDA: 84889485828.25.2370292
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB308A000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:29:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0gIQOFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l29ap0z+NgMk8b+loIJRvuRDcMjGDora34vzEfwkZDk=;
	b=e9zktvyWNCtg95J5lad4w6jQRXD3Kfzh9vHbiSKmiydVXUjrYKM+8fZv36yXC8qeT2zCqc
	UjdMeXgIpUWisGcDiM9vrwU3hpNhTyULb/A7V8X5/Z4h9duNCr2sB8X0w7NP9YmB/G3VnT
	mbro/0gJGJTKuwRaIX8GcOXa60rlZAI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0gIQOFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781702952;
	b=0zsG2zMzoT3sLkhUZkBKV6d/b70kQLLaFgdYL0S1mzB4LALCAEEe9ynN13dvvN+eNxXh66
	MT9I8gqxNfJa4adwLfd1yelP122iXB4e7VWKKiztYz0KjZFZx0x0mM8Xcq0J8zL9P/goE0
	0h1mgEF0QKOdUw9t0/e58EIWUNLxHWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70B62600AA;
	Wed, 17 Jun 2026 13:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBE71F000E9;
	Wed, 17 Jun 2026 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781702952;
	bh=l29ap0z+NgMk8b+loIJRvuRDcMjGDora34vzEfwkZDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0gIQOFMBUe+cOrnPkfiSwdUdEN6vKwZoQuduMKyl/xeoyPjsMwkmfxMRLUyGpSYs
	 Q/pUDgV45Caa+TYJ57HL4o8CYCrVp54Wzvf1tWt2ymQKURot97o8L/4zRm5DMlw3D2
	 7YmHfvMBirwVUvKGqOYjRsdTdM/gEQQESSD5RRzK3LN2lY83F36IEm7qCeEA81PF7g
	 5QhLfx/Kk2loy/Kj1ognJwlNNRArKrB6TeKgHOwqLuCxKJfyGqiew4ERywaWQQEmZV
	 I4WwZxfCkIZ+AbUn/i2way5rcQA/1oA5DJ/ZXkgD9NLKeyGVEI1APnA04n/v03br0I
	 oTrlt3g6hsjFQ==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] samples/damon: Fix typo in Kconfig help text
Date: Wed, 17 Jun 2026 06:28:59 -0700
Message-ID: <20260617132900.83880-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617065716.750179-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB308A000E
X-Stat-Signature: cgqn85h994nnbp7nfpui1osobh1htstc
X-HE-Tag: 1781702952-23018
X-HE-Meta: U2FsdGVkX1/s7KWA9TF6QMVIsnm4fA284WswnyzrSOOJCospqDK+jUuOsxMT0g4f7ym+c2AsrxakfKhQHLYTkNKj2QSLPwne9fqeOPbyPV/8oCOQzH7RIOM7GGacu6M+ZA0e8q7imYF+ve7WO7P/2AS4lLAIiNq1wCF6uYXKSzgA5taFuOOAE8I0qqPlKS0NJtrIDAylPmONoQxSIiswOugF15VWvJxU+jfOXH9qd6+8PFsaOsQocA7HPo0HSB4anoGcdMM3fDpYVfgANBvnIpGwIA3m3TccQ4xGfjApSbcz2ILPyeUG4r9HWjeOiw3VgJy4CJuPAVgBrWQaz4WnsXM7JbxyT01BbrKXZ4bXHkrsJ98ACHiQBw740uY52aSq5XFTmwxgdZH08KF5aSvHN6NGvnuWiJqxTD33D29oqq0lZjDweoKKoWJfpUZfRi1W5xG/9GSdy1nf1XxRNu0KjpjlcS+8tGMjKXxibAacDE+piZuEo4vnchbYOJW3wSlfebGL768+6uFVZ24zW1AtVjyIoS1plq44HmcZwhxr9WhphYnOkle0TIq14+z3K8kDwwIoFoemYIe+jBc0KKSmcvbPsdHSTuw304XRwU1TTsCLj8u4qAPfs0uqokp75j8O6xC92IvxyQTheJsTcEjqqct0l5hM+ZkNHxtFN8UfGp2jEbgvtzo3gqd+Bi4JBZ1KKzNC9I0he8dJjxCSI9rEQc+O/8hMXe1GtWy0/A4LBee/p/5xHanCo3tluskFdW4ZgDogUyEX+yer7mYAu51lOZCh4hFRY/aMs0TAftG0r+kMnjE8+TrrjYhCDDdRnV+gef1dS9MR5NQhE9tOyId4hg+wZ/0yYIZL7LUT6hXrq/KBlJzVNnKyDG2I+Cx83sTs+sVOK4s1EDlnH3uHAYNldzOWXnRxEXfNS+ppQ9HW7ncvsYgnP905caW7Rk0vrq1vJ3KDOYunglz1qr5fEf6
 EV6XSPRT
 MnU+1O4m0A2oIMq2jU38CwWoBXsSa6nak7XDqWpObgWETOjsFSAe+mt/Nz2Mz6DL6olOgI9hOmbpbHPF+LOaXcKRvfFR3eH8HF/uQIdX/7d8ZnW2p/bKzPCQrk9OhD13q50FZhB/v5S0Gs5e/qQYORfxpO13/4F2eHBE6ZOWbpVO11+Og9dLwa01d+z04cjabGy4snQk8tnLCqJTtn8BCvryclFc6A7rcQUzjuUfzUkYkK8cLU/VMPZCxxALPEVzTMOye3vXRepa6rg/02OGSSFfUAKJHpxD4J2wOVV+wV4iGAzsvuTfiw5WaoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 06:57:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Fix a typo in samples/damon/Kconfig help text. Change
> "Thps" to "This".

Nice catch and fix, thank you!

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are currently in the merge
window.  Andrew might be busy for PR work.  Unless this patch is urgent, Andrew
might not able to add this patch to mm.git until next -rc1 release.  In the
case, I will request adding this after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

> ---
>  samples/damon/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
> index cbf96fd8a8bf..182a59722879 100644
> --- a/samples/damon/Kconfig
> +++ b/samples/damon/Kconfig
> @@ -31,7 +31,7 @@ config SAMPLE_DAMON_MTIER
>  	bool "DAMON sample module for memory tiering"
>  	depends on DAMON && DAMON_PADDR
>  	help
> -	  Thps builds DAMON sample module for memory tierign.
> +	  This builds DAMON sample module for memory tierign.

'tierign' stood out.  I will fix it together on your patch, if you don't mind.
Let me know if you mind.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

