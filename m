Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CB0CAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 22:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDA58E0088; Wed, 17 Sep 2025 18:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EBC8E006B; Wed, 17 Sep 2025 18:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84998E0088; Wed, 17 Sep 2025 18:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9713D8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:30:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04799BAD85
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:30:50 +0000 (UTC)
X-FDA: 83900188302.21.1FE41C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C2B7180008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:30:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eXNgK4cm;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758148249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUFtZXM/OgJf4aAO4WVIl6fE6/75GK5R4uLIt6+l5hE=;
	b=yrp0dMx7y/ssR1noVkVeLIF90Smj6I6cH8c/Q60HH4BfoZuk+H768BtJ9j9FBBujw/rJs2
	vkVqNuLTfQo8A/J673TKfM6TWGibK75X6B5eHL6Etuz3xHPjkOE7UKfavR8aZI/hQwdZLA
	hDcJqqx2WM6ie8YLiCDyh3nCfdTTGQg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eXNgK4cm;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758148249; a=rsa-sha256;
	cv=none;
	b=AtiaN+XmPYvhmV4WiRX7ixF8jSPdxaNzLCnt8LPfFtmxezvZhI4j/pxiPRJtV/pFBhFVBk
	QYfydiTLkXJjVqxvjWIoWTbmRhWLHKG3vP2yoRZH/eAIIMPkTRMrg8lXD4FYWcIrS43fs6
	CbfGG17TjUuscafBHGwtlLIFBXjQBHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1550B401FA;
	Wed, 17 Sep 2025 22:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776C6C4CEE7;
	Wed, 17 Sep 2025 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758148247;
	bh=dUgGbvrbudlHAHGgS6P3LAmsFzYQs7U4CkzBsdK7Mpc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eXNgK4cmDv7XJTS1oWEzWXMxh8n7EBjOMAGzglifT0bN8XMW9nLS2uilzRxJp+bsu
	 g4/YPHBElGlqtcd/bTJA/uDk/y0E9jkysWKYImMOIRQBc5z+qABFxHAuFx5d4e7OSF
	 kllisVZyIoZlbs9F/NzIhvx5Hw68vA6hZhXSIiw8=
Date: Wed, 17 Sep 2025 15:30:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
Message-Id: <20250917153046.b781f65ea9a54875f4ddd02e@linux-foundation.org>
In-Reply-To: <20250917133137.62802-1-lance.yang@linux.dev>
References: <20250917133137.62802-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C2B7180008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qnry7mgphn9jwpznyzthjucc9qw69u5t
X-HE-Tag: 1758148249-998754
X-HE-Meta: U2FsdGVkX1+GA4HrK5Hk7mW5K1d4Ehagf66jXmWdmZ8HR8o2rI+Pk361ANJLMRXEoZ1xG5AfknBhoXvtFplY/xDxloKF6nBQjKNLH8EGZnnSk0aIEGOKEcHU1U7pxwNjZDvw2kb43WjGIi4U3hcc1E4sECHRXlfE6XEOdC6OTqvPSHGyiU4/W0boZ488ORf3AkLwVP6BcoETPGSDrSyMnZpC9e9Iwoa/cV9A9/aoka2XbT3hQTl7YORHgHgA+jxgxOHSWyQA1E3pktbfiS9cbKjHYAFXWzB3MdZrUur5eWu/YpEy7wb78tduewUGWf8IbxVRziS653sKMY6DftdskbwRw08ZzxPWp3ASaGbzJoNibx7BbDsJDPIXfYdj3s3EC+clMxLCMW5CGsVlN9kofYpIYAGxUL3GbghDcZY0I5LFfwmWsyt/F5P5UQftWo9D+/3v/9pflcXzadZpy0TGdr96+mTU7LvB1MOA/Pu3vGc2FE2hqjvjPO2bpM4qWXC32CV8Fo6PnnkgNMdvnIztYQv6oQPFMlaCvNJhA5zu6VHd9W25ydobZKT5ENwIpQq1DhjnePwGm7k7SAN5D/SimJw1+iS6mueCIA10ieoJ9qILrVG70AaZWP9NkZMVDQ0OmJOBwNdq+CR5NOzzkv46I5ZyUgnuBLr4+2Eql1K9+kcSTSWkHcWgPyqGutGTQBWXt9d4/CwHLDOYWkWV3HmgWzaP5JZvUqr94gPflyDnnESMusSygP1SDrbeex9u3Iq3wRaH2mXJ9S4P2V7XEXBV5+w6pv6erF+mXs2jUgcQ6a3fkrGpq4tugUkZ63++bNHDB3/2PnzS9zGr6OzMo9MfDPgXdjPY4sPbObcub7qi+d5OFKRrfTVLH7UJqOySIwzhxvxtxw9ZCws3oSoHJrbILWNhLds2qcefthQ8TsPDvqD2ht9UD2FrPGtapLXrHYPLTIF5CLm+YUSCXZmnRgX
 lsd1e5Cp
 AYNolg201wItp04bUu/iAQBeELvlb0qlojEI5TEZQQ0hpQbbq8hFTwV/dqodTVGSnoo+7AWw9nWVB9ue28LjoA+r37e1qcWhlvAP/mCUcGr9DW4cQ6GqA9vtseRlUW8Gtt7bWYJ6r11pqNxR7377MVmDzjFtpOdZdusvoul14UbiQzsfgN3xKtIVtgoBU+ulcFnXtia7JB0tPfOg7n/UvDyKQWiCbgpOvlP6USBFno4SdvVgLvPscUr6jxgo07TjN5w9SP9tFenWGhT1LXOrE7H/df2IBytxVzD+Qm7ctA6coun4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 21:31:37 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> The madv_populate and soft-dirty kselftests currently fail on systems where
> CONFIG_MEM_SOFT_DIRTY is disabled.
> 
> Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
> tests are properly skipped when the feature is not enabled.

It's pretty sad for us to ship kernels which have known selftest flaws
like this.

would

	Fixes: 9f3265db6ae8 ("selftests: vm: add test for Soft-Dirty PTE bit")

be appropriate?


