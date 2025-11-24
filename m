Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717AACFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A176B0010; Mon, 24 Nov 2025 11:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A156B0011; Mon, 24 Nov 2025 11:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41166B0022; Mon, 24 Nov 2025 11:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF8A6B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:58:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E77A91604C7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:58:20 +0000 (UTC)
X-FDA: 84146108760.24.23CF5CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F17BC0019
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:58:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UT5MuBnW;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764003499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9JxkC1loR1qT/xiZq14fmgAe9ga3doS50jMDxGn/4I=;
	b=5xP/gZzGcQjVW9A0iGSduTTo0gn7BAUKZ6Iul9WCKxTaYdPlImNoW2t4supdzFxpvX3eX7
	azGLRHNWi0s/G8OYwuJG1LZdZRkypMVwVCpMnnOvSns4netMuXevSr+RajNR5GFlKoyx3N
	ATMVBn4DaVuotS5WDak4GzKIQZqs6F0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UT5MuBnW;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764003499; a=rsa-sha256;
	cv=none;
	b=rl46iZDO6stz5BtjsudPsobEBSAjlaVzpJBDVFsvhIe+xsbQ3Avcx0+RH/k5zpQQlA/xj/
	RAKOmmU5ZkMGkFjJgmivr9AcnxG5l6U/9QQVIcajS09SXJwQ5D1zJq1vH/p6xUTpmoFvbV
	ErgJyGCi9hhPBzjJICPQe6zG3ubL1m8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F78B60161;
	Mon, 24 Nov 2025 16:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCCCC4CEF1;
	Mon, 24 Nov 2025 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764003498;
	bh=tMBhcqn9bceBvM5ZEFAmI77gEkyO2ji65s3mR9vK9Qw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UT5MuBnWn4wHxP/3GzpYbhHve1Mku91hqGOvYCM/bLeSkyKsSissdar2zDddiQYf5
	 Bw+BNJndd8KL8wqlWe7s5jcn6A55PnkufCc8q5MyTMAke4rKa3N1sWmijzveDl0MTk
	 Nal+wtbR45nPi+pGtzlXNYng+qtvddibSvjeDycU=
Date: Mon, 24 Nov 2025 08:58:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <david@kernel.org>, <nadav.amit@gmail.com>, <huang.ying.caritas@gmail.com>,
 <andriy.shevchenko@linux.intel.com>, <bhe@redhat.com>,
 <nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate
 "resource: avoid unnecessary lookups in find_next_iomem_res()"
Message-Id: <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
In-Reply-To: <20251124165349.3377826-1-ilstam@amazon.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F17BC0019
X-Stat-Signature: geuszn1hng6p4c6dcuxcgc9poozibh9r
X-Rspam-User: 
X-HE-Tag: 1764003499-63542
X-HE-Meta: U2FsdGVkX183UyVeW6kqIZyo+IOTJyAv+5KHNKW6wJ95fi4zpw5kFwXVm7CqwAq4e5eP0XYnoTbfpzvs1Qhn3keJFdealu5OGAx2ddxGh5xDrlGZXmc23dwHCZrF8+YuJAdqgr6OpwZk1aDkQu4jHVBpdy6UWA4fnb2MDlbZFR4kvO1fea88Jsm6AKdXsWCDDTZkIulcPM8wp52byar4UW6ESTHKToMHIpdHn+xFNswdXy61kaHllomeSofhijxAKx1g8tdfeIuTbV8+eYnYXsJvkNSlV7a1tesiaVF8Rj+NTdVnqFdP6YBfm9V/R01CH7Oxij+geTFK6WzAlBh7hBA/6rrmRVtFdp6hG5g0w94tSHCNv7RL5SRSReCrw5JvbrKceRd0TnE+mMy8f/7NEPYDijPWTK4KYu52Nceuq50ITtBUXWP79mqHoHi6cqMuee34xj3f5SSrTvTpxB+FR0NOVKChYGIwiFbPPo0665+VSo2iSSC4s5KBqFDnV55idu4TYoOG694a0CCAM+0hdZR/fiRxtLZruzsise58/zok10VW2hK0zlf8GWHOn0NCLEfVsbcpnwLpO1EAmwg1EvKeMUwPI1/B14cQba1jLgFUch5CEX5ofcVFsNk3T5ooxc2Ga+hkitg1XA339H8y9YfG/BAKKic+bCz9UzIp7dRUjDMvMFllA7O2RM9Woc6LsjLhunO7Z6hANfq2NkzzrjeCkJmoO4tFl7CXFE4kAvS0R8+dVBaBZJgzABumQ0OYPb+w7fCJNBB/uYVHZpQwe8XQNqyQJMG+jxGSxe/9r3+eKtRLa9r8rRbDx7rKF2J5nKHnJuFAXLouc2DGG5fILjll5dDuteMWZ7OLtyCvfcqFZ3O65bc1LYsZxe0gTLP8kPdg0etPhZu7S5STs9YtySh/6BV3HdVMRvlPBWt/sIkZsbDR6yWeBN2ipy/gHeID7wuBgw6rmuTHTyApsRW
 rUWOyYQU
 NA5wcqlm5xFXx/aOMlS+e/J5LqRwuImR+B1zvne2ho57tmt9GcgC2IoGhU4bwtySbUbT0RoYJZNgUBP5dxX6jDMYyPMcz4VlbVNpLiTnVidTlHqDnNWuc4UUbrHNIe7hTqZon1eOO42Fl3a26ttlqiz/jb3VFZL1pPFL4zOYnkH3T9HdVy3ZQxCPzC/m269d9kBnyA+j7yuZnchXc42IIbByqgnB3YDnY8W6dFir+GA3V7GPmyBrMwIBKXCMOwoD+KCQVfb8sgrezsoRAoI7CExmsGhNK2w5V3+LmbzfX1LK4L+KFIBdN57Q0lU+Jfw52ClIDYLinuj3n55kdzGHRayIkzGgCLFL9FAdLJUZSoj9gRJY5DA2bTFgxWRBPIgWBWA3Ju0fHG6sm3O6egjwW4d0M7Baz+6J3zi39
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:

> Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> logic") removed an optimization introduced by commit 756398750e11
> ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> was not called out in the message of the first commit explicitly so it's
> not entirely clear whether removing the optimization happened
> inadvertently or not.
> 
> As the original commit message of the optimization explains there is no
> point considering the children of a subtree in find_next_iomem_res() if
> the top level range does not match. Reinstating the optimization results
> in significant performance improvements in systems with very large iomem
> maps when mmaping /dev/mem.

It would be great if we could quantify "significant performance
improvements"?

