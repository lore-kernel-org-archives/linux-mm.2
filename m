Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543EDCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C8B6B0092; Fri,  9 Oct 2026 04:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E6C6B0093; Fri,  9 Oct 2026 04:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433886B0095; Fri,  9 Oct 2026 04:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24A006B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:22:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6DB6A0296
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:22:01 +0000 (UTC)
X-FDA: 85302394842.24.5E794C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1CB8E20007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:21:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeLhcx33;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791534120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XR909C3Pjd+KOHrf5jL2WUTMt/jvGOVLkbFPbLw6Xoc=;
	b=NYUO3Mq8Co1EsbhzNrr8SCWEgiKZTNLn029f62xwoJbzfNl6Y5epLd3W2xnY1P0OQGAWUW
	3yu5E7gAJxMYjQw/HOB+HGWO3w7FmElBfl9dzBzziBa5Mz068vXKam/LPzDh2HVFcT88ix
	JNOSXcSYfVTlzFkrT4XdmMa/RpaSanc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791534120;
	b=26iSZM7cFDejfCVpvzJsmO8PEMT5lw4Yt61XKBzQLCgntKci7FPWqoLznJYlqXubdHfFPX
	rAMA6E2BmERtXv1sc2Ua5qfZKG2+sKDlXKl2pV3xGAf1yQvFS3+EpnWEi8Rz8SNNX9AdqZ
	/eaykjewC+3Z6+LljgLTq4/xtr4TUQ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeLhcx33;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 823B8601F9;
	Fri,  9 Oct 2026 08:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C921F000FF;
	Fri,  9 Oct 2026 08:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791534119;
	bh=XR909C3Pjd+KOHrf5jL2WUTMt/jvGOVLkbFPbLw6Xoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeLhcx33IW8mAy3QVGFv1zIRvGO0PRTJw79Sho141cXlFv4eOc5XRS2BpsQ98vgch
	 Tuwvp//eA2nS+vyzXnKO713iSPJBxx9behcXXYwaBia4Z0XT5ucnDIqiYs3NP9J4DM
	 769mLUjlyk8vgVnquToil1r3INpFAimFlw1haA7TgVRW0ffIgxrBaNsDeGxeeC3heJ
	 2DOBo5/jgfRxZhf54Cm21T4uoDgj0zoZc9H9nOvcgz3uPux5BhYtKgHvYTj5bKzcyh
	 KN/JKYUr0V0RsIQcQsIdIFCgZtmyUN7PtvU4/MWeUwSD5RKN9+WTQ0Jzk1U+4zFlin
	 0uufXWcHcfSdA==
From: SJ Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SJ Park <sj@kernel.org>,
	Suhaas Joshi <suhaas@s-joshi.in>,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com,
	oe-kbuild-all@lists.linux.dev,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Fri,  9 Oct 2026 01:21:54 -0700
Message-ID: <20261009082154.42336-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202610091039.fhMXCn7d-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1CB8E20007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k676kdqwidrmyrdfxocwodq7kws6rdnf
X-HE-Tag: 1791534119-207970
X-HE-Meta: U2FsdGVkX19G+YL/UhePQetiTb5lwZiBR6iaFF3nk5HbEcLEv+C6UkMt4TIuSYWpccdRDljYOMZ6NgZEcoZXO98qjnRPAXWRFF2YLBeuW71L0L40pxzo5pdr/dWzecyDg3jxgTAfCqibLvB+U/Y/3IkpGciTTtxFByTQ7KVf2NaVqUCR85APH/B0Gki2MGpUDflaLui5aF3qGMXcq+C5bBhnXj/y5+BEl7uMTsADxktOECvLsXvI5sIPKdT388sKQZ3EKpgugP9cvxPgPnuSk6njT5PmHLsaT376T7qSdFQp2vJvruALH79IubvLP39Y+hymm3IouVsbIEXF3mquYidTkqnETKE2Q52i0iq4/D8RQPKtLsNTHz5Qrnp5dUANWgRS8/Wi6DN9bedsR5NkMEYAf8rvSNvptLUM686sLp7iccvz7lcz9ESzU++9uOSCQ5e1eF2NaVwW5ydfZAmO/PfOVKkpUFuubAsIOIkoYmnGoE8Pe3Cb+lE6Rly+JV9lnJZyRsAY1IM1InxKa7yI8zjSJqrp2CVMszlLV2xQCxhgSjVBLYf7PVX6bIfn3UV8GjDY2fPs7zWJvjvOzd6mQXlvXZ+T5tEodqAv+9JvOEb8QgDRK/hRTuYnl2Q7I5PTNvvofiXM48JAjFVc9GAtKxOJ6G2neFepT/OHbQpRjQg/PKn4ipeHhA5sR6zRDD75eLyUKECnLTrDJ2YzUphxTuK6N8kbiwHj1E/PyQNDt+OtHsofBdkrqmS7oDf6gwROrbEdRJfvGwtC2vCCJvHUi27/NzJmrsj/Z3U01VYLb/qR12Qdxbve32XXNw30zCTHDGc9UQL5jTHZwjOyIqXQv0BfV5Z275j2M5SjExdb77WrRuzLeaf4HCX7J1UU0tkGYvN6en4HsWiZ0rF7CleG9dNjYDQBQUPTscm3VwKnfck9c4JRiSeawzi8B4PWZ5WfFfcVi+KcLtefnd0DMUY
 taqsveDh
 h60JBuxCxbAVUd9VYDwyoLNoP21xu48WT16AZAlW9NygeoCng0XFLKwRI5aExTxDRIt/idlbPOQHde+aYEdRqYVSPZ8JMr9ZK58dO3Ttm8kUzydlEqOAlskNr6swesalIMXW7/zn31T7CagOnl1go2CExwY0UxuDyv4vu3mrLF8ueS1hIEhh6yEBcR6r/UO03voqqy4PxyAhRkq84woR9l1qKwWE4DnwtlZglr6Lca7GAjRvvVkc4wyxJdm0A6D0f2Z3oP5WQeHaTuWo8XH/8/C3LIpLqVBVMJY2ddQo/UAJQjzxpERFTbugEnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suhaas,

On Fri, 9 Oct 2026 10:40:07 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Suhaas,
> 
> kernel test robot noticed the following build errors:

Could you please check if this is a real problem of your patch?


Thanks,
SJ

[...]

