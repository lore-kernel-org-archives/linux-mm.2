Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E65CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FB66B00B2; Mon, 18 Aug 2025 01:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435A46B00B3; Mon, 18 Aug 2025 01:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346116B00B5; Mon, 18 Aug 2025 01:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 272016B00B2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:54:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0630160771
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:54:09 +0000 (UTC)
X-FDA: 83788812618.25.04B5EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CE60140009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:54:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=JXyJL07a;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9FDsJohFj85qyWlVnEXFutpHHzRi/7qiH0fiYIv+VU=;
	b=5VD2Ax/5kPScHK8h8YlCFgKKBCWjrTeIkYeLqdYx8UmCGf1leKQO18pkH/yvpakmo9fUFn
	PUz9awHv7UQhyDo1TIDSPAkfSS8ttP6x/rU752MaGVRK4st9DuUVeG/SLJ2h/B0YMhCuVp
	5P+J0UiHZIFxKWkxh/H8+CwJ5z4htBU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=JXyJL07a;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496448; a=rsa-sha256;
	cv=none;
	b=qxLNaChV93bjfsSUs2wtb1MhiYdb43DxZ92xGu9rG8IXjTJPKhObAwfc5RRNV7njPAiH4M
	5bplEyhKU4qCNWUzyzIL4hf08T/GWfLRGdVBvVykvcdUxKSZFEyUVXLp9B3H9r3sGoTEoP
	JBt2thPJ1fr/I5TzG5vW93IJdM4lmLM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E549C601D1;
	Mon, 18 Aug 2025 05:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EDEC4CEEB;
	Mon, 18 Aug 2025 05:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755496445;
	bh=7VMm1yCipGar/5QC8/PT1FgWUYooGhE6OFcFlzC9534=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JXyJL07acHqlg5PvXgmSd099vExnnoKfJPfUfBFMDr07Ry4Jsnve36oYcnA8pUhgB
	 QAV/xzCd+VNCenzBRvkU+t49ohBOOrxWoXUngWPYCGbRR44HFJs3ZLe7FhrIauahZi
	 WqmyF3ViC8I+m/EEy82JLpYn4eVHPEmNeuoNXmsM=
Date: Mon, 18 Aug 2025 07:54:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <2025081846-spongy-cornstalk-ea09@gregkh>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
 <aJ3f05Dqzx0OouJa@arm.com>
 <2285c764-e6b3-4cb4-ae12-0bfaa1e67358@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2285c764-e6b3-4cb4-ae12-0bfaa1e67358@huawei.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CE60140009
X-Stat-Signature: cp1sd9z8odfrjxmd7tpj1q5f1cnpb5bf
X-Rspam-User: 
X-HE-Tag: 1755496447-678847
X-HE-Meta: U2FsdGVkX1+jQRL5K342r1B1XOJAbWskdOA9Q4/5ZRGdxYVcHPySQVpbh/1IjnDR0VNJL/vLtQtsPB2V3lJpvE9+zDiIclo9hVCUqMYG3vBUfAegSsft/eXKtCryccTMw+sVxy50nCaxNnTbNPpIsnMApOvbFSTx5bL8eofgQPn1j+yxPi8HyhipnSxgpKEg5rjBpYN0EUqOhg496wmPwMjELSlLSfOeYoZ4bWDG96rclT9h5eJFoiRJWOdLj03ugbiHVcgXa9fWQGqrF/h8RKyF67QIZAhzDH0Gha7JOm1nSt1P3SSCeyv8VI06aNQc0w66iaoUpouNz27yZj8j5XCFhkIpxK62LR5hj/d/TyXKXjJlKVKP5w4r+Mh4jeu/foqACVMaDTdP2/JxdqmMZ1RxLuFuXEic13Ru82TZhxRX2BsVWNYS/qW8zcCLp6rO2JKphFMM2WEg3hof2sLCGzgZzwT5XlY0q7YXWMYRJz7s67ePWebDzGuWflQUr4fB8BHfSOWX1+83Mz2jqXkpe2fOrK9gz8yaSVUXcKPGKJonbaWZBFffsGkr0OXjz+HF1d8Zz6Fi2w/1rMqsop81doEnay02TD/RcLu7ffPBi9ZA0f4MWdHb/9aPzqDwsv4mIpdLDO2W59WQFeGXYfOm02tfklSwDt86HYdpzKo0JP0CF3TzFeB2w9xpnmSKEPdT3qUNy/AUseS8nA/Zwij2Q66vMjp3xDVcy7ZQhnnjQIXVNPMCqPG7YQaD7/iswF86jysbN7etWFviqv4QwhrnjIaK5swcMp1LhBXNe2q9PzDykA4CeV3WkDEzlWw+3t/5w5o26rVrZ/XgtOYhyXLboPmi2OVwes2rlqx8XA74bDetyK1Ml97R9Bt7E+aRWQt0UUCIYvNt3MxeoIPDO60CkOsZhqhZ3RiM0gqFsnbqdnnL0ixZgKofZy98m7yKZjJkXSPfmcsDD2v01+X1+cN
 939JHrd1
 /1Kvujn4Z8q2wljGDaTldN86kG1WrNoUTfNfx3/8Xi8N4Ls/CmQVmDH/aZw5fAUvgyJcpcjBB2eOtQsyKa0eUHXfTukR/fE1BDnBIdLn4hzEYOmtU3sIHoM3n5aGCZM3rfnap4ppUL7yWz+KBsYwmLzjs9sIRJeNgGXHurJ7QvFeN0L4w2DSw0EqLY7Jp7hnJJkB8qSNK5bVqY7LkijTsnhy6bh0BL8gn6G50EQSfbIsvOeN3M+QH3rYuCzw9NC+5FqUOvUbH3Ye0KGBBkYKkAL9TNPUJXahf/Tev4zuBdd2Jt0h22y+GIrcGt4mLSFTPoCBmOOP8mhb+1vb59y9t8jTutVnwugy7c9xL3y9k7+Z8hbjJ3YHYa5vleOVL3dOvUR1sportdNeXM6HG+EXOX9QATShZ1wIyCoxGw2tg4eq6bmSN22K/MZQM0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:24:38AM +0800, Gu Bowen wrote:
> 
> 
> On 8/14/2025 9:08 PM, Catalin Marinas wrote:
> > On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> > > On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > > > I'm not sure which kernel version this was against, but kmemleak.c has
> > > > changed quite a lot.
> > > > 
> > > > Could we please see a patch against a latest kernel version?  Linus
> > > > mainline will suit.
> > > > 
> > > > Thanks.
> > > 
> > > I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> > > code of the mainline version and found that this deadlock path no longer
> > > exists due to the refactoring of console_lock in v6.2-rc1. For details on
> > > the refactoring, you can refer to this link :
> > > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> > > Therefore, theoretically, this issue existed before the refactoring of
> > > console_lock.
> > 
> > Oh, so you can no longer hit this issue with mainline. This wasn't
> > mentioned (or I missed it) in the commit log.
> > 
> > So this would be a stable-only fix that does not have a correspondent
> > upstream. Adding Greg for his opinion.
> > 
> 
> I have discovered that I made a mistake, this fix patch should be merged
> into the mainline. Since we have identified two types of deadlocks, the AA
> deadlock [1] and the ABBA deadlock[2], the latter's deadlock path no longer
> exists in the mainline due to the 40 patches that refactored console_lock.
> However, the AA deadlock issue persists, so I believe this fix should be
> applied to the mainline.
> 
> [1] https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [2] https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/

Pleasae submit it as a normal patch then.

thanks,

greg k-h

