Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89015606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=J2tR4AcC
Received: by kanga.kvack.org (Postfix)
	id 99AD66B00EF; Thu, 29 Oct 2026 07:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971716B05B5; Thu, 29 Oct 2026 07:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887B66B05B6; Thu, 29 Oct 2026 07:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66A916B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:12:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 004B0A7BA8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:12:28 +0000 (UTC)
X-FDA: 85375400418.21.B9D702F
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77707C000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:12:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J2tR4AcC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793272347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wHFqFmUHOMyAXGgatt6RtiWY+xh2oo6ZgNjkZL1EJw=;
	b=P/7PBl7BymD6LB9WbGEv93s0aPoWTa6YKJRIhl+hWalrn0f/WMX6Cgxt9samzC7fz8zHyM
	J0/eHUA3jGnyBffreopHjScYg8K9/XWHfnrbkJIBKlE1dZILbEhiW67bcK/4uW7/dk/bpI
	iCJvM3u4MTDO9OzbfgLNgm8KXZkZOds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J2tR4AcC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793272347;
	b=TrG//gfpv0trsnRr+Ixxwo/CcppaSnv8QXH9Y2LIqX7vsWHgCxr+5JppaFdEdhF9vJVbaP
	GnWLQ3l4esQ7lNsd10DGofZU6g94eZeCZy9gKE/WGPU+kFaW+lbiAa3ttZsuulzeqfpaV8
	2JyC2PpXMsA/p1kdz1JiD4Yh7Aqq4yM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793272341; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=0wHFqFmUHOMyAXGgatt6RtiWY+xh2oo6ZgNjkZL1EJw=;
	b=J2tR4AcCmlEYiZmwACVESFSvfwao+B3FKy+0OJYUdeWoFfy7tAf2HJkCF6VoEfTDje42vwE4KNa0BNujZlyVQnoI4mcdLmmQuVEu/AKzhWg9EWzMC+rwoQiH6b2C9gVLVRg0DRr0QMspHq7AyrYSRGNW+OWV22NYzxlSJIVDkwk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDjF4uj_1793272333;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XDjF4uj_1793272333 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 19:12:19 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  "Kaitao Cheng"
 <kaitao.cheng@linux.dev>,  vbabka@kernel.org,  ljs@kernel.org,
  liam@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  linmiaohe@huawei.com,  nao.horiguchi@gmail.com,
  ziy@nvidia.com,  wangkefeng.wang@huawei.com,  tujinjiang@huawei.com,
  mgorman@techsingularity.net,  chengkaitao@kylinos.cn,
  muchun.song@linux.dev,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
In-Reply-To: <20261029034254.2487998-1-xiangzao@linux.alibaba.com> (Yuanhe
	Shu's message of "Thu, 29 Oct 2026 11:42:54 +0800")
References: <20261029034254.2487998-1-xiangzao@linux.alibaba.com>
Date: Thu, 29 Oct 2026 19:12:13 +0800
Message-ID: <87zevwiwvm.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 77707C000A
X-Stat-Signature: pnf8iaa1a963re76mq65c66rr5uwus9z
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793272344-463156
X-HE-Meta: U2FsdGVkX19SvoxJG1Ok//5QpmoDR245tHnohtsIAzM6ayxiGtpwsaCoXkB079PGi95zlhenMnY7f/IvTsfCIyUI6gIQWW0N1Z1qWwi16KTMy1P6MpPSgP0ViBkyZG4rI+aTssJC2gi81Cd1t/q94DVoPm1UDD7apnEvunjD9n1BVCjG4gJtpQJuGryQqqCfFSRav8PBP0WJbOemSEVRd32ev42gAe+n7vCyulJHHKFHBot+l9y9oMmqo87V5Ci7DnedYU2RPzziXxe83Dl2FSNqJYXivtAZ8URXcqOeaQT1Fwi4HFHi34eEuCgfQTLmzme2d/r8vgvOjGySV77xNKUApBzjVK0wP0elD6PlaSatnW5ep88O9s31WJuh5XjQ2wYqy6p/BA2EtIoGoW7pHs6wNvAHNqx7DwAwi1u41wzs6b8LtFNeYWMTBx3OhqQVpomz5p9PE6+1y2G4NQOxdnSthy/8+/wAyEYwwdj4mJk/xLTOurGqnlm7lZhurYRplRgCegr/xII55lhdGTalkUtKMaTh0gDXVAsqx6E8VFkhPloHzT8mppQwP4JLAeE/gGvGR/T7pzrxrMOyZW/0UqSRXmfMq3BDDzWhceVacI1e9PjFqj6gKnR3OjfXc4x+m235AdeDHPMn31TlXyZGKQWrzez8abWWvbo7crxgb3KkSaMj1CJph5UVAzsvwqJ1DsGAY3IwtStvF9qbPZocszUv01kA364hExx9HROjV3/quQzpOo+UlE+fI/LzYp+YrPNcgdsefpwb/mHEoqFW37TwzGYUQ9lTEheaKm+48ndiFg41eYKWC1OOTpa9byshM022wfOEM2KLLDhUd+35gFgQj3H+8e7e1m5Q/9tEamr7Tz4WOCY7koi0vyQRRGXhq9fLxgFWiH0WOVxfYMGdOjtdKDOLj0guQkRLsTCro84My4scT5MpNdhWhgzYYqCLybyi/0kLBTvWdNryLJC
 oIvBBj7F
 ObXhhiMFro+Wdql1po07O9NmkgPA2fRheaNQHMtAISeUmJ4EMOBPKmuOdgmIBlj31ZqwLWV0n6Jkg14gP+cGRchv5ULqbMkXLgBFl68PLtqjSdvlkH9Hb6v/bLD8ku4BYu5D8UjreSVYOatTuIs+0KJKRuDnXQrp7GVJRcz7lYdzYJ4fDdjMpgDuCdiO/x/Ie5797UjlbzfoWk3HJzEzI+pO2C9wfF22aSE5EJdmMuc7aW0Whm5n75Vz3nUsDKnuzYpEucb3+Y3fjadK9DmSUcv+CxOVqfjohbCdmnoYAL8ribfXfDZIguXMJ0Z5YXq5VogGUYifV/Uxt1RE6VL4LaZ4B8SHTKlAnYVZk6IbIgW7MhOsi+Tt858Fr9sKxchK/i0+0O9hgt8gnu0LadFVye3d3ydLp/vJ4wX0d1wCpmxOgtBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Yuanhe Shu <xiangzao@linux.alibaba.com> writes:

> The !copy_mc fallbacks of copy_mc_user_highpage() and
> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> set while the data stays readable, there is no fault to recover
> from: the copy completes, the destination folio carries no poison
> marker, and the poison is consumed silently.

IIUC, in all cases except debugging, reading poisoned memory will cause
an MCE (x86), an SEA (arm), or similar.  Otherwise, copy_mc on x86
would not work either.

If so, we should only check is_page_hwpoison() before copying.

> Check the source page with is_page_hwpoison() in both fallbacks,
> before and after the copy, and return PAGE_SIZE, the
> not-copied-bytes convention of the real copy_mc paths, so the
> callers take their existing error paths.  On archs with copy_mc
> this code does not compile.
>
> Measured on arm64, where the fallback code compiles (10 rounds
> each): COW copy throughput 1043.67 MB/s before and 1043.26 MB/s
> after the patch, fork latency 348 vs 359 us, forced migration 57396
> vs 57654 MB/s - all within run-to-run noise.

Could you implement a micro-benchmark in kernel to test your copy_mc
functions?

[snip]

---
Best Regards,
Huang, Ying

