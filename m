Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53060F419B9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DB86B0005; Wed, 15 Apr 2026 09:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE086B0088; Wed, 15 Apr 2026 09:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3C86B0089; Wed, 15 Apr 2026 09:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9016B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:45:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 203F1140456
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:45:21 +0000 (UTC)
X-FDA: 84660912042.27.4CEB836
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3BD6C20013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:45:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Gzwacxbd;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776260719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnqbigBGJMzyNSdWaIgD61qj4pLhrUMBjXiM4G7xin4=;
	b=7z+eWitIGABX/nY6ElgfPAg6d77PCRTfg4l19GbCK7o7CNndaNsY0h4oE6h5CkCk+1KV/w
	B9JXYBcwuXv+WQ9PPkAP74MWPglpqAJ2pZVIx7gz1tRjOGdkX3P4FhgN0jKHETwNfstsxf
	okvkgXSrD1v3Ce0IvyMa+aNEI9CqFIg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Gzwacxbd;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776260719; a=rsa-sha256;
	cv=none;
	b=KV0/UzPd6BEV/lsdbb/u+C9AYZqG9M6yfn8XpH8IupKl+OhSub0RJFzr3LaqDH2OG7GSBd
	WadtrpSqIcwzZH7sw77s54YBXbfbMD/VHfFriOAmoiJp29lRZXzVWmTdrLkxvRkg6MfYM5
	ihNfeTx8J7YfQ2PXak6yvPUzrsjTz6o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BnqbigBGJMzyNSdWaIgD61qj4pLhrUMBjXiM4G7xin4=; b=GzwacxbdjU4k8LyifGbcckiLgj
	ijR9FdhwFHMZd+iBAjDhtFqjxb1RDxKY5/BWaCvBsoycEp3O/ertlOXS5PjBZ3eij88akegBpnnf2
	HWS2XwCkfprhGHaJ9Pi41O046zKLnHYcUgBhOmGsXY5AJ9ZwO29zs4dawAI5fUgFBXEHWGyhXxUoc
	FPhYWJvgGvp9jPwvKUwXKuGU1RnVmlxszRbCrD+l620daTH4rIMINeJZkQcCftj+KisOsk4H0dSH1
	/ejwL14Rl88je0dBGoDdXYd6UcA/4WRn/ZTALb4Ey2y42iV6m19yW2FB/6E1PQJPQC/iCgxLVp0KG
	2Q8z2pcw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD0YF-0000000HVrc-3XDh;
	Wed, 15 Apr 2026 13:45:07 +0000
Date: Wed, 15 Apr 2026 14:45:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, ziy@nvidia.com,
	david@kernel.org, ljs@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
Message-ID: <ad-WY2B_9OxyWlzX@casper.infradead.org>
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3BD6C20013
X-Stat-Signature: gz5yxuy6z6m6t5zgqh1h6d5f88zf7ep4
X-HE-Tag: 1776260718-118655
X-HE-Meta: U2FsdGVkX1/omhgHX41H7btLXlERMHSAvnynznL/VP7DPQlAelTe4yGz+zMmXJALhYOPWCO0QfFZjttxC9kWQVRtBqhDd9xjKJoRrrzh+IyIh/0mwTzNXRsDlH703AYXihC4qJERoQPkCkDF5cHvwOX8UmMrTgf+iAw6/cpRcEbrah212nyqnDyxciMVvs25SRd8FJYZf70UaTGF4tWf9X72k/sa7skB6O9Q6YBkK5fDExXAkqTZxAsYwZJifAoApC/fmaYybkZkmD4Y/fF3P/qD99dkxeehUDfwzPn+sZJpYZmojPLq3rAHVZKU4+skRdzU7KgC0Tqfy2mkAZR/vIBVh5Y6CAJlLKtfo/NKyPPzTYu8Hg3TplpkcmVDtzkFohV/a1K0Rl1zFw3vJGvINFwNegIRz4s2o82HgeNmUMaUGsF/uy7kDTJJK43dJpDf0u85mKd/Yd3rGJAlTRufrHhJwJ02XHYz0UgeR24WiZttbFuYpyITveafbj5Xbtqj4hOWhYpsKJTSTIJOjnK9Cnb7bZFglBpu3Lr4xj6V8ETm8p0es+u1b94WTpA6C5od6+IbgzZ4L2RX1t7PZtIkwnlplTT7ga6wZUqUA3ecjLcl2c8p6ij4rzcgGaQlTPPTSU9IyzajR4Gtza/dfhN1RYvrsb/v6jMGvl8lafQGu8GbR9A4vTtHr5Y7j/0cunIRtaogyhnUzhqHdnv9/mm1h3maQ8hwu58Q5241V86ORDsYXS/TMsyJ4rUe4zVQVBWBsebOYBLf9DBKcQauifTyI6xsHR2J536gm2Cd3YuDt/oYCldwXAf2KUO/hxpsXeF2LK/v07Puq4IWVBfEnT9FSi2N7UBDoc9jr1Xl+XHUKyL5FIH31gNXeZ1rJYVLIsnee9zarlIlVYG1mGdKFyyBdjF58Xt48reM+ode0YalDog870DeTJQvgcb3mBWTFJU2vFS6z9y6/vE3VmJfbZg
 HcvYgHE/
 IAL923mkX03N9VNauX/BgVajJAXy73crMC6VpiX9sGi51dEX67UfyQB5sM437V291PzbEBS1BcBSw7Y6HQ6uRFFLwWJ2eFEP0uznWkj6F++8SAZoDDVXpl+Xt7ZwBXu9AtpEXX6hnEdZUQZbCoDUMrxA0sBNt2zeKTfzYEkFuKNys4cWawJwZOr4ApoL2l49FcdTuaci7s9EQUgIcFaKR9ZcHV3z9einRebGZXTeNLCqhxcch13Z/JnpAvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 04:22:53PM +0800, Baolin Wang wrote:
> +	/*
> +	 * Only set the large order range for tmpfs mounts. The large order
> +	 * selection for the internal shmem mount is configured dynamically
> +	 * via the 'shmem_enabled' interfaces, so there is no need to set a
> +	 * large order range for the internal shmem mount's mapping.
> +	 *
> +	 * Note: Don't consider 'deny' for emergencies and 'force' for
> +	 * testing.
> +	 */
> +	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>  		mapping_set_large_folios(inode->i_mapping);

This isn't how mapping_set_large_folios() is supposed to be used.
It's supposed to indicate "does the filesystem support large folios".
shmem should be setting it unconditionally and if there needs to be some
other way to prevent large folios from being created, we should do that
instead.

The current code is wrong too.

