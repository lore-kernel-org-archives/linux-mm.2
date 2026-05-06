Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D56CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 16:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D9E6B0005; Wed,  6 May 2026 12:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817EF6B008C; Wed,  6 May 2026 12:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEEC6B0092; Wed,  6 May 2026 12:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 592766B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:41:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B469160282
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:41:11 +0000 (UTC)
X-FDA: 84737559942.23.1C45257
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B5481C0017
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:41:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrtaON3l;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778085669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oRHuVmKCiZSPXy2nDXmz4s/lC995odQgxWms3/5OAo=;
	b=oQJn10F34zCBIUXHB8fDxK6SE7qjUfsik2/UdeoUgVqIM9CK2eX2KGvE/KH5pcwBLm84O8
	OyBt/4l6ZIF0pJc05KY2taVwoy7lpIgW0Q2sFk+w+F5WSPztNG4sN5M1erWLz/Rldsb1qo
	66h1QGGrAmky6eayjwIkuim+c0YPui8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrtaON3l;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778085669; a=rsa-sha256;
	cv=none;
	b=5KJ5tFUVjelWo0J00ttLeOkNEiQovIIDj73oUP9jOnjirx1J1HbnRlAFqHCK1e2cz7QgiJ
	20mD0tXZ54SED+b9q7q1wVygYEcVlD7KXQFpPPk1zgfw22nCt0uHw7sDMSezHumtD4Xi9k
	Q6Y1FuuWi8nehk0xT3bB1oOzj8LndhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EADD4401B;
	Wed,  6 May 2026 16:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A988AC2BCB0;
	Wed,  6 May 2026 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085668;
	bh=sjh30b3c1z/W1cQGXVs6VKN8mBptz52vyltQa8qkOPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrtaON3lluhILxsDmGjMLJkWvBV5Pu5iVtIu4aBxZytPYMAh9RGWmzbVgNiWfy/Zt
	 iGK/dQndwuyOK/t+Q+02gAAz0xZ5YjKQAc1DfgXgmQ8ChJfTyU1hZtb3Ef3hdRevu3
	 VRYunv4LniTGy/fhxZQ3E0cYulJdSy3ZDl9pnyKbPI6AdOYt4tJ4LyWPcah7TR2o/v
	 dDlGj1pEv5koHErR8j4+kTxYkbcheIKRhjJyjAiXDhqJaJrVw9Wbc39ardBx+UM+eF
	 Zv84n87GLrdrenCQrns5nhNZe+f1MYuQlQoNENosx1gm002LxIJvCvkpVN6L91V7rC
	 fg0gjX7Y/ttXA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Wed,  6 May 2026 09:41:02 -0700
Message-ID: <20260506164103.6414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2446b1e8-2b9a-4621-bbb3-ccec0f1aa604@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdopckfztmkufc1a1dw4g9575i4hy6ky
X-Rspamd-Queue-Id: 5B5481C0017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778085669-150302
X-HE-Meta: U2FsdGVkX19AGdLUK1hwEF4+CQRTWBesOEc60H4weML0s2RKU5XCUN9XWHZDxboGyuLoGirIqYwtn4Vl8wcSDkyG8oYscH++YSfYK5fTF3DIFGnopCqQFy5vvc4DSuTvNe3pmrrpjt725MMTDbL6MX9kOduB4EKbfOVlLJ8bP+hm7d1X3IX3EZC13Z/oMzKcEhukvL8/vK87JtUl9h7Y7BJU149G5EXRmK+jEDvsf/qht/0vJGvHzw1S+9mMIZveok4d+zg30voNCxxIS+ERpRcGiGZXi61Js2CbPobzqLyzak/f9ABbM/cOfr3sypECSPS/33LOr52OVLcQIvpV4khf06SKGXkRw02RplasnJi5g503VPsHzSObvdK0C0kL/ZQmPJMDSWPhqd00RePg2E1lGJEIn9GsqSmUT0ekZf7itw/sL+iRY33UG+Qcdg+4u652VEpLMWpKh05NkLaDavTmwEVgNY0QnX2kEpjKNIpo4Lcd/qvmY2PDxwWDVIJCPupm+20n4sCttvlAeR1U7RhpwQbCM2uniew7RYmBXBmCP8G9TKFYIavVk74BWA7Tpkz4FoxgY8Qb+11pbhSGy1nQk72woxAY8zWXvtujPj8EclGc4dxZnGc0GT6l0TAqSNu+43PmF/Dk1Mb4XH3Zp9TD1xhim/xOHTLaoQuux4YBHGby+5ghk+/tnhwvCF/WYwDWdTGGIGe260h9usaGB8FCtT0yCRZNBd0WxaQ0BuiLOfup5KTcGes4DsTNhI9owEAKk+gdkCN8STI+PSo++b0ITQuIRo4SuRhrXeYM5Qffn40SNUSVyU2wSYaLgs4rxcarCY30FcP+/OF6BdMKNtQUF65Co9qhgJHuL75exVD2zQMRO/eXIBtvW7O2m4k3p4rAchhcljiVpHZIwlrO/LqHn38VJ0puYZZGaHdtIteqCs7+d+xuToE6bz8bAoBIgzAydzHex9UhWCipezd
 uLsUMM/4
 97b3a0yx5DK4/FQIr+4G/kxiBzul1p99sscklT4KdGlYSQ640YOSd9lwAnTBBhfqQNTjswJb3YyRmAb3eUsv39uSxntQRctP2eL8orAyCsFDlyU14AQ4slf2QkmObhtRgW/0g39wyqo1cRsnUH5xsE4Gh0XUz5V/n8whh4/r0Qhv/IEkTf41GNNNIjPawAJpuSVP1AaLF6NtcoAFeEJF4BBXziYXoR87g8TK045LOX3wkoFAsr63jRTH82BoUln6xBgL8TVKrOapu6PHDkKnSJWarPQSD6ivEPTvLTgze6DbdQV46F54nqKBt+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 May 2026 16:52:01 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> On 5/1/2026 3:41 AM, SeongJae Park wrote:
> > Hello Asier,
> Hi, sorry for the delayed answer.

No worry, no rush.  Take your time :)

> > 
> > On Thu, 30 Apr 2026 13:41:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:
[...]
> >> A new module is introduced to demonstrate the use of huge pages
> >> collapse autotuning. The module launches a kdamond thread for a 
> >> certain task provided by the user through monitored_pid module argument.
> > 
> > If it is only for demonstration, I think it is more fit to be a sample module
> > (placed under samples/damon/).
> We are testing this in a bare metal MySQL server. Maybe the description
> was not the most accurate.

Do you mean it is not only for demonstration but a real world use case and
therefore better not to be a sample module?

> >>
> >> This module also has a user autotuning knob which allows the user to
> >> adjust the aggressiveness of page collapsing.
> >>
> >> Benchmarks
> >> ================
> >> In progress, will add them in the next RFC series.
> > 
> > Looking forward to!
> > 
> > I may request not that much test results for the quota goal.  If the module is
> > not just a sample but for a real world use case, I may hope somewhat reasonable
> > test resulsts.
> OK, will do it.

Thank you for kindly and flexibly accepting my humble suggestions :)


Thanks,
SJ

[...]

