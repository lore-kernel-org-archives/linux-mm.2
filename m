Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D967ECA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623AB90004B; Wed, 13 Aug 2025 04:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB6A900044; Wed, 13 Aug 2025 04:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5389790004B; Wed, 13 Aug 2025 04:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41D70900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:21:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0194116E7D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:21:24 +0000 (UTC)
X-FDA: 83771039688.30.D324BC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5665340004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:21:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6WQDYQo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755073283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1A6dD6C4Km1LSjdto2vSsJpXRBkg6nyw8IW8miaDr0o=;
	b=HleV53gkxfbtLHagJEFT+RxERdaB4+3agjCxB4GdQgabSJ16jrQxd5eJ2RlcPDT3S7e7Oi
	tbcCsUhtfz3jxAmPmfOge0vSTaClfnKly+x9n29jnzxw1yWViELkokgj3c094qAVdwk1/z
	T00UqmIVmPJkQnjkLZ2eH/lMH83vOC4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6WQDYQo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755073283; a=rsa-sha256;
	cv=none;
	b=irYl06OVRTYlIuOxiTKjf1ybP9TKES4Yi2sH6VmGnwHtUhQVQc2RhmHFLLRp9sUgEAr8wZ
	6dWeofze4FHZXsNygGQ3xPJrihjvaOeSiMtzNzDdgYAzb3UbvbxHhFL94sIZYwe9qSY7F7
	6wAVL4GIm4UPfZ+x54+EQ/rRi4KwqsE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8664601E1;
	Wed, 13 Aug 2025 08:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEDC4CEEB;
	Wed, 13 Aug 2025 08:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755073282;
	bh=yhBdBDcSunhilhQ/pLGoZ62EZ7ieGf8uO+xCa6kR1EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6WQDYQoBPHnofiXPJ4qmdczWv69WGBwibh1MmP4Fjl2Qtdd/URJMktaPsRbIsYlW
	 15c8wd/lXfLWHpWiMVVLdLYbHQ2ne1hMDvSrmoL/pSjh3Asp+kyaWal/YCfQkcMAjQ
	 +h17hH0xHR5mu+5TG0TW7w1IyoV/W5ASKoWtLeshtCnyBZAc8mdnWg5hndqpGDKt9Q
	 IftQbXR3Uo1QCqgIKLE5EIfxo1Am6K4umMw0+dpB6td6WDyJcTrfb8yk5mnhoEFF0B
	 tK6LAtZsBpY5Agn5WhlxpHzn/dQeQPfWwu6jcqE+IQ6CphPR3nhGoZpllqP2J+q7QV
	 XBQqdO4LypEVA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	pratyush.brahma@oss.qualcomm.com
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v3] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
Date: Wed, 13 Aug 2025 11:21:06 +0300
Message-ID: <175507323699.801708.6071992016913841165.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250813-numa-dbg-v3-1-1dcd1234fcc5@oss.qualcomm.com>
References: <20250813-numa-dbg-v3-1-1dcd1234fcc5@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5665340004
X-Stat-Signature: qf9jhd5zxmqdkzrwwhyegik3aq7ehinj
X-Rspam-User: 
X-HE-Tag: 1755073283-181163
X-HE-Meta: U2FsdGVkX19Pb94ROcHvd0hBF/ILqjSbSnhvvBpk4rVGmMaPf7RdRYX36FNv/mBTW7Ltza9uFXNaL4QGJEVpQJxnaOVm8sPw40QOtTmN2hoPILHkzNJSz6AxpRuwW/9l4/u2bJBfC4CO93cSPbCps4EdiqUqo6OQLyg/8ZQ7nXy+2btZS4yYSskqekc1g4+SNRsnBeDn/Rsh2xSYjDMrfU3Y4u9iiUcAg6oVnvOJlUVAf8/JYw2Xk4mdbfRlf7cCO1mhMIJKsau5N4jbnJgCATChCsCB409/PXogBnueq5E7VZF5RX7l5szoZX2aQ+V9AMNn3psKSNsdmJR0hRZBfA0ZUulep322wpnLc2rBdtNFHt4COCib7ulOzszRUz1DV9Zmu9793igkyIbJfKlpxrKhwnqGg9bvmVVksmxPTeh0DzAieEH6ZDwlpMdG9ubJB0BnqutxQMCZRbVE+6Di98vKo59Vaj3mryoWoVwoiPLvkzU5TvhsXFasjA1J5kXGOFScOmbOBIrJdsYq3tB/Vt06VY1LRK+dIevBEMD+jgS11bpU1a4vpNp6Dg2CytLb8dypjQPfndEMC+idtS9pMX1b4jgDgsFDn75efDeb1gGBsQ06Sy6u+4MdGcsGjkEKqql1OU/2UykAWHuQUwv5RQqnaKtoblKqtG77zZXjRYUhyM8XAXhcCnOIARx+/F3RgIjEcRlF7V6vrBVfo+R6oZHioCVGdOd8LBApkPs4vW05cf8q/YIsM/KIwVRACylpI1c8JWTqJrJYeOX7d5CuOQT5uxfeGbmBU+3TCQjQtQmf29VXDzc0edUavi0gDwHTOKeWPi9DFtq5HmAJSWOtRa1bloS9m2lB1uMdnwVsz386w1QcS5HMj9B/2nX9vhW31iZk2ADMF5dJ2frTqEkGIjKX4bZ8eDB/cTn0rNe+1ft6EqijSrT+R7lyLZZdOIay0vjT9Y+jNz6oCDI2hyv
 mzJUboV4
 diJumaGAjoZSlgSzNseTJ9F1Z8p0QarqAEo8aJxnMc1/slMqiFlQvDPLWkPDt4/cHTVLFnqYSKm1SXINRdXufiROxBQLm7qkG7JaxxTyVCBUx1kAa9mMl64AYLDI4EATA1cdx1fXbVxPQ6mriFQhZBM8S6O6hIHvyGzGR7NZDa4bhO8heX9mAsT0orMHj3zKWVvcnJLESEjQH3kfL2f455VeLcVesd37HyleFx0IeohT2nyRdM9NMyhm6UMOz4tGDfif8s/i3HXGJ2OByNqgi8EUSa9BjX6KkHvj3PWxdUdySNpBd8ICvhBAlgKweEk8UXuFG261CmH75fCJWiX5hVql6LOqOxXXWkDzfoUKBziCcy5qEROJDg7PHxcNWJIpwlcd3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 13 Aug 2025 12:51:02 +0530, pratyush.brahma@oss.qualcomm.com wrote:
> Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
> align with the consistent `pr_*` API usage within the file.
> 
> 

Applied to fixes branch of memblock.git tree, thanks!

[1/1] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
      commit: d045c3154080a04beb07726fa311b89d21608981

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.


