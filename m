Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A85ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6158E8E011C; Tue, 26 Aug 2025 22:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6578E0105; Tue, 26 Aug 2025 22:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC498E011C; Tue, 26 Aug 2025 22:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9F18E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:42:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A935484765
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:42:49 +0000 (UTC)
X-FDA: 83820989658.05.E586C0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFD5740008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:42:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hp6Jz1NV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756262568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hK+bMQhST+YvWzupuQ7NFN1TlKhBydxKgdFRDaFgN4Y=;
	b=TRdws3Myf2H8QgrPVFUiiaWbAdONRh3fhNRXp03vGFdpl59RkZBhIi+m9CSfi7bJha5iBz
	HCoy4hes1tpjf+EV4J5ePuw40cpqyq8hN/sRUiBg1LST/A1MOWJKLo5I1mF0Wwm1OOxO73
	iwH+cb1SV5ABalkHSQJ5KzvTUGayRj4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hp6Jz1NV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756262568; a=rsa-sha256;
	cv=none;
	b=N2nrW3a0CbGsgVx9+dxBz1tNh9izavDt9+Y4MWh5HSmIvVNqUUUZszJapZM+j3LMeqUq6s
	XjjjhJaaJkRC5FJgpWKZCjIHGX5ltk/jy8b2A3mcPspqSBMEDakslqa+hhHGjg7H2KD1dr
	YXT82DXAy102h7rpD73kg4/qd0R8Nvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA63943906;
	Wed, 27 Aug 2025 02:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8077DC4CEF1;
	Wed, 27 Aug 2025 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756262566;
	bh=5F9aykt8eK0WG+hcHahSzeOf9LKNCcllQsRTkdWNiSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp6Jz1NVTn+W6ZZo3gfoxOP0Lrh23qMpSGMhrs95ozCXNlHVoiwJngSB4hiLQp+v7
	 ioKOKNuxYFYucbsa7dy9ZylMsrFeUGgssTibfWCBLn4aRRP98S2et+T01XDSmFdKYW
	 oJ7e+2Yy9T6gsbBaz8qc0vYiEe+a4LicRC3MvYwGWa9JzvLgNtEX1/p//UjmwmIWmY
	 tQrWptpPE3JYIUPXl36urLIEfQPnEcRv3L8YmzR05TjCLNp7sp2FVvb4vG/aOo2m8k
	 wodJUPWoCq8Og3Mdtn72FU5mLG/iIc6tcB6XaFvMLYFRkae/cxJ7yF4CfXxU+/ALIR
	 DQWvmezYb6Bcw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Tue, 26 Aug 2025 19:42:44 -0700
Message-Id: <20250827024244.58979-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <c8c3d0d5-e9e1-44de-8722-1e7d09786b51@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFD5740008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: waow5b46xnrpr1ptr9yb3fhsowkcgu88
X-HE-Tag: 1756262567-75090
X-HE-Meta: U2FsdGVkX1+etjzt6vsVbRvi1n+BnXujfRkU4ITVB3ltyzeGnzg3rCFzhI+V52b9FOdMAMC8FFPm7KJxLNvsM1qyPDdBESDMa+nW9PQTDiHWz/sNm0a4yuzRiDZ7ll/EI9iI2mXjAI3lSU/ocWBsEiWMIEUPsDavTB9pig/ydT95eYMHRFabLnnwqqaWzfM+a6dZno1ouo3A1LZbhO9KMjBZZQROsd/YWfHFSzvyZfK2JyhglyxTqxlaxy867vQCnBKTOuz6Sf2yI9J6ocQ7+gTBX03epUsqb8q+AQBGiHW4qhS//2LUitFLIDFDHcKVRajLZjV6hIFkHph7ItKoRWI+cyatkU9eNxM/i6bjZF1Ql0YdhHvsKpb4iqDRR1zQ+lvvhqvrhgkfcM+Mz88tz+V/BqeQaSnIGhydjY/Ew/yviB+UkjqEY625xeT/NtpEF2iHRZeNALeMQ0GHn3tv6xmesD4SNr1raSNGsveVVCoKorfeJxjr4JKrk3DKSmVf7aQSkbbLAdq61+Ol8C43USDV9lIaQwQv/LNwqCMy8paBpe/Ql92EwbLYG2S0ygjnZOkbxrqhJH+k3FF1iZErSaXwbNIXUbYLeAFgda4EOgO4K89KTy5dQmyYotZ5q7M2YX/NvDqgbIQ3Se6TelcscRKO7W+9PE8z5oWMic3Cxi4d4Cw0Bk86obbrvdfw/4uAftBdjJGVxHxVTd7oVFs6wuKnZb1YhDPPSSRwerv4sEO9JWR1NjNbAu+0NjS7hnSh2JyBBN6VD419l+kho+5ZB/xmeZvlxE7P+J1IqCI1DrmgUgRxY9ATWgLrdcFsXOh2ry3baO71AwkoW6WqJpFkd+6VKnUaTC/jyWmMAe7EbJhZjoWNVLnhWwVKIFiYhVUwvkHjMfX7rg8QAyOj1jCRWhrUyNkEQkm2kppH/x27S4IBYh/utzROfyQk6RUWTCQ377XYXuza9VkQSEGsJbb
 UKlmK35A
 WGxC2H7o6kSIWVQgRG9F6XCD6IM/8IsQWe8x0NYOhh68hfVFWNHiSiDyKB6vbG13vrilMfLf5GxiLKlb/kPEHuHMzKcrYyCbCRD4iiN0DjmECdgFM8/xvl/ZC6MBYlsTs5a/H9jtsByomkovkoflHdWG/M5DLRm8GOfPoTIuJg6AgCcruK0ZM90SoaWwDaAblGLZesjxKFPU46qkrrGh6VixhCDI5Q5TARs0S926sDMhO97jVx0+jdxw213Y2L3zTZkLjmH2Y6vM8ek4wv1vqctzk6tXp8166EYLlxPSjDYGF05OsPyuRK9iLzpW3ygw/h9JJpSVVFAIoTecOj4/RZgjYISEauGSAxKfGVtb5envf5Y84OZDDtENRjhVNY+GOIsH/f4yF53jXIrqhs0C2fev3kEjZ98DDHAdAe6aMPKXvCxd8EhrW+I3UYKZMg/IYvOjWoW7XrSoBn0F7pg62q1nSSWqAvWcMAPVkQ0S5fPqkjsdNArBzBjlzFkSz/Kf1qKTWbusEYQeHmFh1d8Ynrj3Ljs80OVgHPKCf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 10:21:41 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/8/26 22:21, SeongJae Park 写道:
> > On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> Hi SJ,
> >>
> >> 在 2025/8/26 11:21, SeongJae Park 写道:
> >>> [...]
> >>>
> >>>>> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
> >>>>>    From hackermail Thu Jan  1 00:00:00 1970
> >>>>> From: SeongJae Park <sj@kernel.org>
> >>>>> To: Andrew Morton <akpm@linux-foundation.org>
> >>>>> Cc: SeongJae Park <sj@kernel.org>
> >>>>> Cc: damon@lists.linux.dev
> >>>>> Cc: kernel-team@meta.com
> >>>>> Cc: linux-kernel@vger.kernel.org
> >>>>> Cc: linux-mm@kvack.org
> >>>>> Date: Mon, 25 Aug 2025 07:41:33 -0700
> >>>>> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
> >>>>>             return value
> >>>>>
> >>>>> Otherwise, __udidi3 linking problem happens on certain configs.
> >>>>>
> >>>>> Reported-by: kernel test robot <lkp@intel.com>
> >>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
> >>>>> Signed-off-by: SeongJae Park <sj@kernel.org>
> >>>>> ---
> >>>>>     mm/damon/paddr.c | 14 +++++++++++++-
> >>>>>     1 file changed, 13 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> >>>>> index 5fad2f9a99a0..09c87583af6c 100644
> >>>>> --- a/mm/damon/paddr.c
> >>>>> +++ b/mm/damon/paddr.c
> >>>>> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
> >>>>>     	return false;
> >>>>>     }
> >>>>>     
> >>>>> +/* convert physical address to core-layer address */
> >>>>> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
> >>>>> +		unsigned long addr_unit)
> >>>>> +{
> >>>>> +#ifdef __i386__
> >>>> Can we use the following condition instead?
> >>>>
> >>>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
> >>> To my understanding, this issue happens only on i386, not every 32bit
> >>> architectures.  So I think i386 specific condition is better.
> >> I understand. However, the aforementioned general condition is essential,
> >> and we should propose a new patch to address this. After introducing addr_unit,
> >> any 32-bit architecture should support monitoring of 64-bit phys_addr_t.
> > The issue is that we cannot divide 64bit values with plain '/' operator on
> > "i386", and hence this patch makes it to use do_div() instead of '/' on "i386".
> > No such or other problems at supporting 64-bit phys_addr_t is found on other
> > 32bit architectures, to my understanding.  My understanding is that at least
> > you confirmed that on your arm-based test environment.  So we don't need a new
> > patch to my understanding.
> >
> > Am I missing somthing?
> 
> This is because I seem to have made a mistake earlier: I adjusted the local
> compilation toolchain. When the __udivdi3 issue mentioned above occurred, it
> reminded me of a potential problem. After switching to a completely new environment
> for testing, I discovered the __aeabi_uldivmod linking error in arm, which is similar
> to the __udivdi3 issue.🙁

Thank you for sharing this.  Then I agree the current fixup is insufficient.

Andrew, could you please drop this patch series from mm tree for now?  I will
further discuss with Quanmin about the proper fix and post next version of this
series with the proper fixup.

> To prevent similar environment-related problems in the
> future, I suggest adjusting the condition to the following:
> 
> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
> 
> Please consider approving this fix.

I'm yet in travel, and I'd like to take more time on thinking about the proper
fix.  Quanmin, could you share more details about your test setups, both for
the compiling success case and failing case?


Thanks,
SJ

[...]

