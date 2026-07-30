Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA49C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200956B0092; Thu, 30 Jul 2026 04:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8956B0093; Thu, 30 Jul 2026 04:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116276B0095; Thu, 30 Jul 2026 04:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1A596B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:37:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 659B4A0918
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:37:29 +0000 (UTC)
X-FDA: 85044789018.22.5EDA3B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6BE140004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:37:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D9fSv0/L";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785400647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRIfx4TLYAlH3SnTech17HhGQG575fDtx9lFhxWcvsI=;
	b=USbL0sdsEjXPB1O6X2/W7T50dEtA/ANnz4tP59e0O1/ZxX3/wiCPtSXCXfADgiO/iG/YXm
	hZOMwbVo8NqNmHPMLtEDmpefszG1AQ8aLq2bIYN0/BZjMHdtTKATb7e6lbG/OX8omAmEjD
	Hw7iiaNeJApNu8cKntSE4XT1fJ2zbHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785400647;
	b=1OcYrqiwPcWGhIlVn8W2UFDBBmqeGbgczWdGLhi2VyoEh/vPgj7GUmKKv+jh3qTnDe37dc
	49J5XqrNaxIgp5w3bqKV70nXOkIooHDliFAFGni8TIv7VA3YYvom33OKoymbTq3wwTEGj4
	Js7fYtWCG/qUIBkC2/FStNNbbZvb3pE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D9fSv0/L";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 467A7600AB;
	Thu, 30 Jul 2026 08:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E261F000E9;
	Thu, 30 Jul 2026 08:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400647;
	bh=sRIfx4TLYAlH3SnTech17HhGQG575fDtx9lFhxWcvsI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=D9fSv0/LZSgIAShREquHiHX7Tx0CMoIBR485y3u10lT5SwyeT94zW9pgp758qvX2a
	 ZyngkQgu8D4pH/ruXOpdNGIceARJBuWPDQsgnOCULA8qiMX+kdsuIAQbqM633A/4ur
	 pzcjS+tcc4RXal+FkUBAME+iGlC3XJn8f0kKNKMxxlLKpfedUBlxV4KCUJduzra6tP
	 3PuKxZBTYYVugIMDa0nWHEMCk0Kp+Nj+vNJ+Wz3cL0VrupySYGl7BMd0d6WCc2R9AW
	 Epmbvf7XWhIqkQTRdB4f56/0Q+88wFyPnhIs0CQdh4ZKhr7ip3Sq/QGWvFD+ux7s7w
	 DKd+wAwYTCB0g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 18/22] kho: extend scratch
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260729145610.2827231-19-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
 <20260729145610.2827231-19-pratyush@kernel.org>
Date: Thu, 30 Jul 2026 11:37:14 +0300
Message-Id: <178540063445.2151126.14089645580528118019.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6BE140004
X-Stat-Signature: gmhcfxd6ekc5nhpmd7quq8n4wb86ae48
X-HE-Tag: 1785400647-609990
X-HE-Meta: U2FsdGVkX1/N1Hkkr7K8iEad5ZCiokJTiIY2npUCTB6IpWjyv0rl4b6pJmIrhh813wuw7Kwb8TBaBoPA7MIIsBGaRmY8kBE3HnJs0u3pcLrmNieABnSlubiyC+gi1v+pHTXL1RUgT0W136lc5prJfgKiVNaMWqZ7YLeQWeo1Y88UAAqWH1PqBhzB6Itm9sBz4ZKO0EgjA6JUC1Ade1zCkczl9Q1fc3xn6jMxgfvTTtrwcSMTC2DmCW5QQBSQKRIqLA2XfEH4EGSew/L+1oZ3WcqUK99fXJG6yDEQszuF/c/GvyJTJvvi+VY3oK3Rb5R5j4g/fKTkUBezxpBP04PTtFHxXRtmxC4OXRYQPZ2+pgJdIPcjgfmcnHKu2Kol48wSQV3HO6oEpI/IwPz4cLLd3heuQkfnn7DK6jLwC4GfmHLLVPsC1SprBZJ9gBXUrVcii3gjBgv5drglGfzwaplYQ1lE9s+9/UNIdC/bVk+9P0ZA9GjOt2eHtmkLwWJ8nNFvrqr9cZ/9Wz3XH7b3sxjbgoi/+mp49a2E6ztAzZq0Cq9J8NzhXzHCthzViFV1K9RzxwAmuM3oZYIYIKSh9NV7OOUoKxnKrtoprCkuqfWalPwo2bcF9UalXR2DZrG+aRIf5+4/JEfRUBVPDqu1auL34fGAsMBM2AGolLVPXo581tNAR71OJeg37l15r2q7YZDH6LHpk2Imvd32MfLAbbmhkVfdeJwjDAG0lp83AuO9iTghe3Y6NFU7pPPlqiu/8gzjK9bfLAcfRKHbfoM91iHfa1kmd30c8GTBai0dMl6LLLBc/eDR2wMZnJgfg/Ungr2dmHU6/NtyRDpj1FCcnwgu8Z+SWNY8FpZEhvk3xcam4nHuXWBIepWD/44UZvzRj1nGBQVJW2XISRnW4HlE4xh/azERhDzVt9ot+E4Z1swqdSPVK6w2OJBBDeb4tzI+RT0X7MrGyXVXdyeKI66pzUj
 lKRPYE5a
 bsMJf+AwJDq3Ca5JQVLn5rcuEQ5XBM4CtBkHUwKlNdvVbeeKvpK21HeTEPBYQiDp0DrZuU71a3vHdt11whnI4pZ+ZHz7pPLj9HTMHfPkEDZVo3uH8zZQ35zZ/1po/zoSCchMXm5bqUgWgEzLfCiCAJbCZDrztC1NZQF2b0iiu0fnfx84pqQqYkvt7h1BBrqwDI9574gReaTtHkSJdCbP5D2PzXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +static void __init kho_extend_scratch(void)
> +{
> +	const struct kho_radix_walk_cb kho_cb = {
> +		.leaf = kho_ext_walk_leaf,
> +		.node = kho_ext_walk_node,
> +	};
> +	const struct kho_radix_walk_cb ext_cb = {
> +		.leaf = kho_ext_mark_scratch,
> +	};
> +	struct kho_radix_tree radix;
> +	phys_addr_t prev_end = 0;
> +	int err = 0;
> +
> +	err = kho_radix_init_tree(&radix, NULL);
> +	if (err)
> +		goto print;
> +
> +	/* Walk the KHO radix tree to find busy blocks. */
> +	err = kho_radix_walk_tree(&kho_in.radix_tree, &kho_cb, &radix);

sashiko: Will this trigger a lockdep recursive locking warning?

I think it will.

-- 
Sincerely yours,
Mike.


