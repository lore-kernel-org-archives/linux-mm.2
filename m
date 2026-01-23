Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74AC2D72354
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0EFB6B045E; Fri, 23 Jan 2026 03:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5E76B0460; Fri, 23 Jan 2026 03:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12B96B0461; Fri, 23 Jan 2026 03:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9328C6B045E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:53:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43E411AF99E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:53:52 +0000 (UTC)
X-FDA: 84362615904.10.DE58426
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 94F53180003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:53:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJyy6q4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158430; a=rsa-sha256;
	cv=none;
	b=4pO9MujuMHtuqzSYtYYbQ4mgR+K5W/ft/B/SSUXypmLFtIbD/JzFjxQmVyg0FO2hIw4ep8
	ZM/MX/gUIt9eogpMu+PgAXxUGw4GnJ0kUk8LyslN/yCSQQR9RI2GDum0MrfspE0Ghn47Kj
	yTVTydGJFgaGE3WqCUeWNrbbKzzCrZA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJyy6q4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSbY3XgNEeMt7RDjgwXfpbnZxu/CxSRhlv5jLZ5PvPA=;
	b=keN9alvvhPmFoYoBzDs/NyP97iKdPdr0iwSA/fcwQgMv+E0grP4fafL5e29KbMjicXnBVD
	Ny46sDGkIG2l/M/4TtFabxTR3iUjCh8yUq2ttyEQE8Oz8uEQeNezmaKtyMW7Sosr+Cdg98
	6n83+ZslrAT6HDVxkV7A3JWRTYpCuGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59399434FE;
	Fri, 23 Jan 2026 08:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1591C4CEF1;
	Fri, 23 Jan 2026 08:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158429;
	bh=8xDScLcsy5OFgIJg5rseIw23Z3H5/7lWSJmJgApIXko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EJyy6q4GWlNjzBtY8qzSezHb7bGJ0MPYYNHtLo9jOXlGE/DhGzq1hfsdoLsqjLcHB
	 KyHB/f8pdvDLTlYmTUYPNPK3Abt0FTBwhzIVXmzVsQmfZp8XB1Fdam7mJLMGII6GzU
	 vGYWSG3J6wWzp/HHPspEPHFPwJiVIyoFxLIrAQoi8SlYn+5CFFzJUw6NavLlmM8SZc
	 we7Wuh+48gW6nIFohR3yz54yhjHR4iYs2YXbW8XS6JyGqb/xIdxXwTjAIncCpcVpp4
	 JnJb3EpXp66eRrCBIGWkp71VvVprmAHUEBHJVAXxdycnZQtMG+rVlM2T1F+sYDB5UL
	 o13nTXz1H/wWw==
Date: Fri, 23 Jan 2026 10:53:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2] kho: skip memoryless NUMA nodes when reserving
 scratch areas
Message-ID: <aXM3FoK7g12P5h91@kernel.org>
References: <20260120175913.34368-1-epetron@amazon.de>
 <20260122152112.1a8be8e7bdab72631234cd69@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122152112.1a8be8e7bdab72631234cd69@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94F53180003
X-Stat-Signature: o4kn4toncmrtq8y3qgm4prxumyfszszn
X-HE-Tag: 1769158430-18561
X-HE-Meta: U2FsdGVkX19asbYQIra/pYQOIaZdO9/CR3axvMma4ydopaS+bT6oXKtye4FGkBa8nBKfRJU623hXq1TB+bDnsJxptAchnbKDlaS6zinMXj93+fFwoachu5gRW4Kf+JcAg6UZkTpTROYxwYqYbhtVtzo1OhJpe+L0kVg0ttok3wjiTS6JeQmNP2HMJIIS3qF/pSjuCh9JA6FWMqZf5Y+L5JVFbNaTcCJC9bUo9bvyGTuRrNahagHNFFkZZtah8F6PIeIPpBABPp41OBIO90q61xH6AuP171fUFqAPONnXLAM++S/hSZg4rPkMSNli2HZhTVJuzv3t+fcYY2xigltSHXPUUmvZVA6WuYCEHBGfxUh3HgntR+WvS7nrbIy6sk4NYIBRcsRfB6SPNi2RhH9wkC7XsC/jp+PvbNQmDcazRP52xUisWKcZ4li6lWulDzVQ7sPNMCHqDZoVkzGI3eGTZdewrfxc2L/NbWGxbMqkTLY1AWf35A6s4VHAF9qgXhDHc2EsF8iRDPIKtkXHMrrWzly9w1nX8wUNCgkAX5S+mmryjdZT9/spiKQBTHlZGJODW859Hmw1jazLFwUL3Z+vmCU0KR1K6+x3930yb6y7hpe4itn4R8zoSUg/x7KbaKqXX87C0oHjPe0e9rBYElj7EaoFT3LugLAjTPaj+GtDDdf1DStbSFkT7XxV4tXjJ+7dPm3BWdd7Ry9agXUt5Ps8wLQ+pTvA+gd/qBYtraP+tGP/7AkW3/suRKVDEQZ8EJBCkF4etQjTAbCFR+T/QoRQQ9ZAYPELhYuIx8EegLDcoSw9SbTGcFHYOMfPyokJ6oPfC4WJ7owTFuWfj8CRHcYFeHB6nCPPgwUL5Rq08hj4W1ZRERJQ/Nni+BrTO5X13UdcTgSBh6sBFmbKUCZUzFlJ5KlA9tJKKyND4NZ0DW5YobB8dF6zzzot2k+6i0WVBBDJFEVTK2gFkqatNSOE5NG
 8mZ9VWkH
 XzLT7Vi2P4cUkPGoJkkGS19bQMT1ntuLf0l396XtGR9kkbnPcJEGYfiMVZA/gz75ynAvt1OGHqhFNm8KCXcvsB+J6Pq2+Cd+AjgQ5ZT2umh3jNVLQTW6E0thos1sF2JvPJLes0cXK1t28Xsx49GZheejK++rJT0xvwN5wK5vAhFNTt4OYr0/58ebOgFFSXuC3ZML83o5INguHUge8ND1j4UhpvBjMcNgpNjk/eh9YwdHLrjl63vB25GLj8jtedz83MUO7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 03:21:12PM -0800, Andrew Morton wrote:
> On Tue, 20 Jan 2026 17:59:11 +0000 Evangelos Petrongonas <epetron@amazon.de> wrote:
> 
> > kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> > per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> > that have CPUs but no memory), memblock_alloc_range_nid() fails because
> > there is no memory available on that node. This causes KHO initialization
> > to fail and kho_enable to be set to false.
> > 
> > Some ARM64 systems have NUMA topologies where certain nodes contain only
> > CPUs without any associated memory. These configurations are valid and
> > should not prevent KHO from functioning.
> > 
> > Fix this by only counting nodes that have memory (N_MEMORY state) and
> > skip memoryless nodes in the per-node scratch allocation loop.
> > 
> 
> So kho is unusable on such machines.
> 
> Should we backport this?  I'm thinking
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers").

It's only for v6.18, but sure, why not. 

-- 
Sincerely yours,
Mike.

