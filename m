Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29915CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3A76B00AF; Thu, 21 Aug 2025 13:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485D86B00B2; Thu, 21 Aug 2025 13:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399DF6B00B4; Thu, 21 Aug 2025 13:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2909E6B00AF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:53:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C3E4B86AB
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:53:11 +0000 (UTC)
X-FDA: 83801510982.18.3C61FC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07A9EA0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:53:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vh6qw56/";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755798790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7pV/Ed1D/9vy7zoYMRil8TE2d1o5varxFodIBJr+l0=;
	b=gBiknFotWGSyiuyReQdtr1hR7zKe/gqRdtqbtq2GlugTvlzzbKV/fvFGapshG1mC6Gyque
	kWgNVA8Z2ptav7/C9ef7SfuJmtqTFYhxruLSczeElOysIjEjzzC7MrPcPiFKE2rChKmOCQ
	KCkQwWMTx/L9r+8oznj6T48RJeV41ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755798790; a=rsa-sha256;
	cv=none;
	b=pGOiRobzY7xLdD3FDcYZLcSFLWf3ZhMdTTAmzAr2IgxHfDe6XCFhRjAUCy1yq9TUbgDNb4
	u7Y+Yx7C84VJTqEuLDRLNgYso0dlCHZ362Kn5wlR8dQx/70yaH/pFNb44hx9iiAuKo6SxE
	sxyc+/XWnwMemhStgAr7VcXvxsT/+TY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vh6qw56/";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16EDD601F8;
	Thu, 21 Aug 2025 17:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB5C4CEEB;
	Thu, 21 Aug 2025 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755798788;
	bh=HkSJibYAsBk+7KP9bP1bTvrw2NGup1d12g9fEzw+9e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vh6qw56/5TCRJBeoEyYFxuGjnHdIl62D3lD+4oUm9BrnAlZOENKlkw2cNDA5pxA0N
	 zbmDSfe+l1ff6aXaymdNeyugqMpSAS8xZtUfB4782aF916hoIri8Zr4X2h5ImrxFwN
	 x29SAXXKL09OySO0DZWKsy59QOX5wk5OXAT0/lZvpvrjPE9agaIvYbIYyisNTxox1C
	 UvxzUSUowp6IN7N/Toerpz9O0ifNHCqmwCXuNGOvHAoAoEM1jikMUx6VBcuHm4RA5c
	 0rYadFlZwAWd1UOk1Wl1RALPu1rCx8Whkaj7V0q+5J8hr6PQsevFSdmw7BN4Sxsy6d
	 oDrJw0quz0+KA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Thu, 21 Aug 2025 10:53:06 -0700
Message-Id: <20250821175307.82928-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821163346.1690784-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07A9EA0013
X-Stat-Signature: 98g8mc7tbt9gnzoz81as4xgd7fzwngng
X-HE-Tag: 1755798789-913769
X-HE-Meta: U2FsdGVkX1/Gt2ZBhVa6oTnNyrIHGWQGy8MH6DOpP5FinLRmEkEOazCG4jzczIVMxUSwtcPePlwmvsHIFk84hUBtquzbI6mLwRSjsdTHSPq9q91pfq1OvHfZtUL6mWqPwq9Z5YJ8b4ke1V/6z/UJnHJIvd8BlFxJPGkx7XPiTz2Ra9wHbKiKOEbtMCf968+r3pl78FwfeQR6+ByoOO2cE+i2enGPxqTyhxGAD4OADhimAEkHcnLyrrQaYLyOveJj04qr2rTn74pU1BWsmrTp6evcb8imcvYgxMK2EvLzf2xnke2FEPmK6a6SBqusMT5BeQaI/y1DYRxaB1JlTLEhdoleRtYW2EwM+kWJDip7nlxULRwfb9bDe7JmYHv64rqk0OJ15NMsRqLkRCPiWwH9M5v1ojllg6E/XcLCTUIXK15GyPRI0F2JYaXZm0hB4NrQxY3pIfK26tL3IvmvP6N0u57iIG9lbTzzyOFoDXzUjK2VOQwGYWNXpXuD9l/1oaIbmGyuALRP5OQBHwI6csJwoVEQ1sWt5ppVf0WsJN3Axmw0wqfssu19bVVXEkW69NtOQjEPSTcsWpkkksFupTIDAsx/u9e4WxqtS0iNaMOcGQ2hX1CHemxZ7wBr6o5qY6o3dLVPZ0M6mVVogaLyt2/whecEv9moIr+v5Nmh4DP4V+uCLrwmdXHullnmXYCsv8UoUCBkOC35skcAsypK+CuusLlzsl2zjrE9bGCIXM5jATiQczMYebRCDBXS+2p+XwMiCunlZB5Pb4AvE8ib3PB98urMSOFiY+0NwAjL5o4aW7w/sbZj7xI7bcVH+eOZn6BItKwvT+aWLYLty7s7MHNNlimT7iYcfJ0R5pn4EP0buIs6a1CzCXvC6nBSMd59I/kJ+j8nLCiEQODWkEEOtz+qNaTPzAzX8Ho8Q8RfT3ky/87A36RS/U/pU3oLrRwFxsxboPliuIeRGCeZGweORaU
 LVYf5SJS
 Uk+hGIpW9jp/ICC0VoN48HxUeYY0qNRLFNBjngGyhH6QDTmTk5llFKLB95scS+HKYSygo/3XqhY39mhBM9xEa83GJnGxKzQS/eVxG9QD5nrCjvSMJjQPQDvbycOGviLMBH14EM/8SOGreyhBlQvAE8K7i2yoUJEzU/AqrBDOmvVtME7TrcEVHWfIlnc34/OCcNEwk1GD9RxJQ9yg9jb+gyVgn6lvjvqWkFdGY/bgUJmllob0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 01:33:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
> /*
> * Have the 32 bit jiffies value wrap 5 minutes after boot
> * so jiffies wrap bugs show up earlier.
> */
> #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> And jiffies comparison help functions cast unsigned value to signed to
> cover wraparound
> 
> #define time_after_eq(a,b) \
>  (typecheck(unsigned long, a) && \
>  typecheck(unsigned long, b) && \
>  ((long)((a) - (b)) >= 0))
> 
> When quota->charged_from is initialized to 0, time_after_eq() can incorrectly
> return FALSE even after reset_interval has elapsed. This occurs when 
> (jiffies - reset_interval) produces a value with MSB=1, which is interpreted
> as negative in signed arithmetic.
> 
> This issue primarily affects 32-bit systems because:
> On 64-bit systems: MSB=1 values occur after ~292 million years from boot
> (assuming HZ=1000), almost impossible.
> 
> On 32-bit systems: MSB=1 values occur during the first 5 minutes after boot,
> and the second half of every jiffies wraparound cycle, starting from day 25
> (assuming HZ=1000)
> 
> When above unexpected FALSE return from time_after_eq() occurs, the
> charging window will not reset. The user impact depends on esz value
> at that time.
> 
> If esz is 0, scheme ignores configured quotas and runs without any
> limits.
> 
> If esz is not 0, scheme stops working once the quota is exhausted. It
> remains until the charging window finally resets.
> 
> So, change quota->charged_from to jiffies at damos_adjust_quota() when
> it is considered as the first charge window. By this change, we can avoid
> unexpected FALSE return from time_after_eq()

Thank you for this patch, Sang-Heon!  But, checkpatch.pl raises below three
warnings.  Could you please fix those and send yet another version?

    WARNING: Commit log lines starting with '#' are dropped by git as comments
    #16:
    #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

    WARNING: Commit log lines starting with '#' are dropped by git as comments
    #21:
    #define time_after_eq(a,b) \

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
    #26:
    When quota->charged_from is initialized to 0, time_after_eq() can incorrectly


Thanks,
SJ

[...]

