Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B2BCF3D60E
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830A06B0092; Sun, 29 Mar 2026 11:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808B26B0096; Sun, 29 Mar 2026 11:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724EA6B0092; Sun, 29 Mar 2026 11:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FECA6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:15:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 014FFC1DE6
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:15:11 +0000 (UTC)
X-FDA: 84599448822.13.7437448
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F96F80014
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:15:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/Ff42A4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774797310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1qKN5FhYMsoc0anm4gqwNzPEDnqARjegIdRbJYsXHg=;
	b=Ax9XJb2FbTS5qWFpheI35oJXMDXktXEW8ALWYh+bM5fToTQc8tjDsVVPX6jOdbaNN1dWsn
	QyAXF4dbIsYAI76mVlf/g1PX4Mbh32OjSTOUqnqhvUzcAQmQlSEYx2lR62LoneRGEHE3Ot
	bSQEl7DzUUWd3NQsvfJROK1C1Hnujjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774797310; a=rsa-sha256;
	cv=none;
	b=30GhC/gg/l3wPvIkqirHGPsW4STFF1rW0kzvc8a5Fj6/Izd8xDb779/5eUAqYASDzkl/mW
	/bSBa/weouIht/060OkWA9jcgcAiLvhTTP57shSQKfopnKIPEz0WQLVwy1DincUACbBzuZ
	6trp1K0sjcrON9FB+VElVuHJFYWktK4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/Ff42A4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DDE6435E1;
	Sun, 29 Mar 2026 15:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083D5C116C6;
	Sun, 29 Mar 2026 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774797309;
	bh=CVh9eQJNAnqOlDZKN8KfEisM9pB/qcp/6vZJUm8Xpec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/Ff42A4ZIKPJcEGjqNUtDKRVpWjFBvFHSSM3PBCLgaaGPNwYTKDNhya8aZ6n80Pf
	 pSiACfyMDrzeVpADIU8G78RnbLIH+2iX6+QRR6oBzgB+Wwv/jPj5c6l6n/dLnm8yxw
	 zktRv3IErzR7BR/rzRzJc0lx0KMvrQNuWUo1IuVE96Evh1zCw8XnHFzWooV0SYDEKq
	 KLDWPu+HD1g8nI2JQVuq7yMZKNfQqGu3dgMUcwLp4KODArkKL2TuB4lvwx59iWF7X7
	 4VMuDXkOWFMkE192gWif5VBibx1j/7UoHSdgO24nGF3giPEy/y+qoBHppmloGioAFj
	 oEoGxFHSYLoSw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sun, 29 Mar 2026 08:15:07 -0700
Message-ID: <20260329151507.44171-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329075107.36402-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F96F80014
X-Stat-Signature: byaubzkyxrupw4medcz7x69n31kihqwu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774797310-699935
X-HE-Meta: U2FsdGVkX19nD9pL3NpKKqpGmd5fARoI+M7q8x9tklYYMcRN8LvExEEVGIw5HD9xDvzIAbCqn/sqENtwhWJL65s5WeWnBX1irRu5PyxnHLBEUP2tlfowFSeusB66Ucvdy/k5EhY5QTmhUTwHhaKrtDCm0PWB8j+jBiqoJAXgKwHxSBU5u6Go6C0O0AsgZBGkqE9hthARdGtPyFJLa4J1pq7gaSePE3DggNnYZZpzokn7JSBTfVx5Xz+1rTeLAuIg8ZHAr0efrj/7GOBI44Y1KPS/lUEoIgG1iui+NwIOVoJgzBNKH7IRPb5NnJv6nLMI0F2DfR+LTmyvR9TWZOW4bJ7U51/W2Oq+htawiR88BmVvbDtXFog//9AEC9iOccciGdCHEYMzZfemf6Lgox9hVm51nmF+96LbC+X8q0tQvyIV1FqcnINuhUeibNuHRA25CCGj9QvpwK7fYa2+XIFLb7tB48K7myz1XcblIhJnUcwz1xu9cKINQYcyaWexu7GZRIfGvQplMep0/vSs+DJBeFZ+x6/fRH3nvyzsBGw6EyGlDR35KPbB5nXE/4T/+j+UuzEJPGgumBW6qyowfLb/enH9ELJGiWyMNGQ92/QOKakdrz5XDBWhYcvmPHURv6Y7mNYxBdkk4Oit+jXjivQHdI+eoVGZP9yt0MfnGtPbjofWnF/LJF0gNPAMPCr4ckSb3kYYakyODlbDzi0BXkW7JARyiY7rdpa9afdahGDlHbLAQ4edJ+bF7d73RJxBgALRuJY+W0OYE/Jhvbq7q/+B7xZ3ArDionWYhvzMRWvwrZ6CbHdubtGhd0zl9gEg2ihYDKd14X++TGREQx3ytERxCK5H8CHqhW5X5UmoLw0pZ6mJguxFjyN+JJI3S+gdO+ZcdVNjUk9By9KruJ8RHKnAkzOLnMjitiDSEXDkVQg3R559k4HBoZJrwx0jdkNI5J6cA0xOuq+8w3bPaCp9x2V
 pkkCaroS
 hiNRLUrSLf47QiBnt778ERXE/a+hLPqi0BDcnaaCB5kJseFY5LO/7tKVwmTqF3tSb7GpYPJkPqOTuvA4zx2Gi1oyqUUpgbeGW/HXhA+fXShCP9BaydWrQ99rtc5XcwleLfMWLhNPzYxykyDP/ed4OM8guuVSpmJ4LwuO0vKE9eqo/ERWSXROOnnpav7xRK8vc/S5+9TJ0QvPUT99YdadMWzfdJ0Y2rVckrFbJO/Y6X9Rlka/r2ROFiS1n8ccPhHxvowWxSwrYu7aJ5lyyL89RgZwqhT+qBgMpZQDA7ueegS2HgYlaxgWoUDC7gb1QGT0eagVRb27mcjVZ5Xc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 15:51:07 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> Thank you for the clarification! I may understand your point now.
> 
> So, you prefer to keep the fix local to the modules that have the issue
> (addr_unit_store()), rather than changing the CORE damon_commit_ctx()?
> 
> To confirm, are you suggesting something like the first approach [1]?
> 
>     if (input_addr_unit < PAGE_SIZE && !is_power_of_2(input_addr_unit))
>         return -EINVAL;

Yes.  But the real constraint is min_region_sz, so testing it would be more
simple and effective.  E.g.,

	if (!is_power_of_2(param_ctx->min_region_sz))
		return -EINVAL;
> 
> [1] https://lore.kernel.org/20260325071709.9699-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

