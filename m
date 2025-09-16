Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D4BCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43538E0014; Tue, 16 Sep 2025 00:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B058E0003; Tue, 16 Sep 2025 00:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57AF8E0014; Tue, 16 Sep 2025 00:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C500A8E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:41:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67DC511A581
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:41:21 +0000 (UTC)
X-FDA: 83893864362.28.3D90C54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD3E880009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:41:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kfde2bCK;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757997679; a=rsa-sha256;
	cv=none;
	b=UZlq0Ptou3tkGwCLiaXGl/BLri+q6Y0KxKj/w6hOV5dwt2UWSx4/69F0012JpL19EYATdu
	XJ1BqmGsRwDHp5eDaUxyptl/1sNPatUiswjhCw4NUf6MuXdKQY/9f4zfkhimvP1ucUJTKI
	9JJSjotdkRAJtNMXwFwQ/0mRiyFSm80=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kfde2bCK;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757997679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vr7cwIp3QBIJVPaN1FtLApmx8KvjKOf/9Z3lhiC3NZA=;
	b=KzEf6yjurILeKelI2izlayMTgJ9VXcLwp+98KGMK5uj/CJxV/i2bjtqEW4ov1oXBxJksua
	LQ81520yjyjPKVhq7YlX88RkD4peiIpP1eT/ICSyD4K6fVOPGmLpbzYT8gD3kFLwdjqpxn
	c4R4WFCMyCBsJHqL8tRpW8Uvf8OypPA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED57560054;
	Tue, 16 Sep 2025 04:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F91C4CEEB;
	Tue, 16 Sep 2025 04:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997678;
	bh=sNER0piXqThOPvVZ2lFH5TPIw7AbRv56V9c6OrCJQ9A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kfde2bCK6bSYDIyOsrhYTuiq9ts/r+Q8UslL3g+/PNOzNfNI9QUaZ2gNWFz8JRet0
	 saavCH1g6XV2gUOYRLpDvPtr1OvySz2puf6DKyAIeu10hnBDjiHtAc6mOGUCtra3m7
	 zNoUgcL3ii6ytSLE8fbvUvOyjN8FxGCBcTMqjPq4=
Date: Mon, 15 Sep 2025 21:41:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>, David Hildenbrand
 <david@redhat.com>, Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Wei Yang
 <richard.weiyang@gmail.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Giorgi Tchankvetadze
 <giorgitchankvetadze1997@gmail.com>, stable@vger.kernel.org, Joe Perches
 <joe@perches.com>
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
Message-Id: <20250915214117.5117d339669e091b1d3fa96d@linux-foundation.org>
In-Reply-To: <aMjohar0r-nffx9V@laps>
References: <cover.1757946863.git.donettom@linux.ibm.com>
	<4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
	<20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
	<aMjohar0r-nffx9V@laps>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD3E880009
X-Stat-Signature: gir6nypjx5togawtb3taxqzaa4tohyxi
X-Rspam-User: 
X-HE-Tag: 1757997679-623702
X-HE-Meta: U2FsdGVkX19QyDEAc/lLIxjrVBV3LbnqrHiDcEa67TZfMlIZvlBG5MUAXqicfkLpr/cf+kUGnAPPkrqTPfz+oQBYSEqX+9gEFi9rMOIlQUaA5+jNJ1xWzk0NHXqp5ufCtOFms91nvfahz2Vh7MyQt1HzkqnY8OyHMHNhAhN36TJQUOS/s1PxQyxG++rfc+A6e/GBcrKvfCL27v9TTsO33woecq2ixwJLtHcRGSc+qlZ9wXH4LFhBbWvpJzG8j9xOCkTbuJwzc1gLG5r9CJ6twVX7BtwQWa1J8FeD00IaWZkpXU4I4ouUZc5aGwMx0Ml+fH3laSJaOuZiX3zxcj3oSudK6L4DOFvPGkzl5XObmpM6nklCHQWN61r903ctmINetdvtP5V36x7KRraKe8pGat3DVvr5egQQfKxiSqQgHtcZkdpswwitNr/pnLUqqmTR2KmuYwkMoFRHTqqkLbeAZkOiVcJHrEbGI+b8MsBI79Qb2MZwFDn+woURiJKYBcdIA1wEfdiYzH3pzTDrRtKz1o/CwzHIynnoytcfXA0ZyvE3oulgh2NpoYIH2FKNn1Nta9VZqFIHm9JUyvYnt1aDQ3PdDB+CrRN2hVu+T9ILk/NUYRg1OU5eIigUt7gLP0GeXwiC4cGcYLOLHoVYDD904dqPM8oIWBnjzDurQy7HxEk6H8g49GjgxtPPt7a+RjhXrT+aZHi6IQAxNnNyEY3RhiXL9WSJbZX0U+DZpZt4arPPd0nBFOR1kCT65ZltnzB4P9iKPOlFR3k1EP+w+Ad0FA0vyp1nlI2fApZ256D+eLQpnxWogWwGzQgUqIwaDOX1BBkoGLyPO88W+L45BVf+1PydbXs9J86MBOUwWUDM8hen5BL6y1skuurMX0Iqig8nHtMLTKfZxMYciaSnkgb1WWRw+HoQ3jZLxqNWeEAJyY866MmxPtuijGGOzsVWgzODdUtwliWe/ZkBUdWkCVP
 i76etnfv
 MFn3a01DXXHml961NRuUZ+v53KS6UpEMsHMwrvrympuGSkFJk/9NaJPMwa+XTpBLJMQAGYSVHaj6E3pmZafYAlPQsdxVyyV4YwajGmTNHqo5wGDSdwrQq7tLFE2KURXZ/GxKCH6QvwnvG6Ubo2QENBOgbbrcIdiw2nXr5pdYXXGl3OXz2BeaeljjVh4A2/zIkaub92TWE9CcmBfqUI7rvOqd/mslTJmB4ZfRbBT3IXN+2ECeyNk7IJDzRlUi9HWA+8t51PDg7TPfHPMvCs4XguE5i51pWffFkSN6El22yGs7jpDReP2InvJHIjBlckoJGzBGBkn60O6WtlmYoEIoj0dO38I5rpi5pIX0tAvKpP2QmddfWwp7Lab9TD/i6yyuvnx7S3HKfaWWcar2alA9zMwhSSZDsKmJcEHG3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 00:33:09 -0400 Sasha Levin <sashal@kernel.org> wrote:

> On Mon, Sep 15, 2025 at 04:42:48PM -0700, Andrew Morton wrote:
> >On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
> >
> >> Currently, the KSM-related counters in `mm_struct`, such as
> >> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
> >> inherited by the child process during fork. This results in inconsistent
> >> accounting.
> >>
> >> When a process uses KSM, identical pages are merged and an rmap item is
> >> created for each merged page. The `ksm_merging_pages` and
> >> `ksm_rmap_items` counters are updated accordingly. However, after a
> >> fork, these counters are copied to the child while the corresponding
> >> rmap items are not. As a result, when the child later triggers an
> >> unmerge, there are no rmap items present in the child, so the counters
> >> remain stale, leading to incorrect accounting.
> >>
> >> A similar issue exists with `ksm_zero_pages`, which maintains both a
> >> global counter and a per-process counter. During fork, the per-process
> >> counter is inherited by the child, but the global counter is not
> >> incremented. Since the child also references zero pages, the global
> >> counter should be updated as well. Otherwise, during zero-page unmerge,
> >> both the global and per-process counters are decremented, causing the
> >> global counter to become inconsistent.
> >>
> >> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
> >> during fork, and the global ksm_zero_pages counter is updated with the
> >> per-process ksm_zero_pages value inherited by the child. This ensures
> >> that KSM statistics remain accurate and reflect the activity of each
> >> process correctly.
> >>
> >> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
> >
> >Linux-v5.19
> >
> >> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
> >
> >Linux-v6.1
> >
> >> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
> >
> >Linux-v6.10
> >
> >> cc: stable@vger.kernel.org # v6.6
> >
> >So how was Linux-v6.6 arrived at?
> 
> e2942062e01d is in v6.6, not in v6.10 - I suspect that this is why the "# v6.6"
> part was added.

OK.

> 
> >I think the most important use for Fixes: is to tell the -stable
> >maintainers which kernel version(s) we believe should receive the
> >patch.  So listing multiple Fixes: targets just causes confusion.
> 
> Right - there's no way of communicating if all the commits listed in multiple
> Fixes tags should exist in the tree, or any one of them, for the new fix to be
> applicable.

So what should we do in this situation?

