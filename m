Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B164606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C54bK2r7
Received: by kanga.kvack.org (Postfix)
	id 98D476B05B5; Tue, 10 Nov 2026 20:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965126B05B6; Tue, 10 Nov 2026 20:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A35E6B05B7; Tue, 10 Nov 2026 20:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBBC6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:54:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEE051201A9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:54:56 +0000 (UTC)
X-FDA: 85421169792.26.5B4A9A7
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf14.hostedemail.com (Postfix) with ESMTP id 560DA100004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:54:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C54bK2r7;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88xXlYyhRaZNXXS3X5RWnFnkAdm1161ZT112AKHXrTc=;
	b=03Sz76N3SvfxVcP+47IjVlj8qTXLjCR4y75j721OhB41QGhwGDHV2+JlPtaGSWqpoQYk4v
	h5P91hSSfqxZx0iLHHqkT9SNohwdKUfjnvBOSvnl8IP/KSKKet0A5/l8srsl16If6/F9lZ
	7TsDh30cNpanYQRSqWmpmREFIg5q8EQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362095;
	b=U4jnLFGnBHp96c73wIb9E9pvNEdTK1tQvS6SEfGvnurbxTeev0eQsR4k+7vWcjBWOnb7Tw
	GqDgjZN/PAbD4haQvsa0GKJLbEXteJU7e9Yn/pumsMYcG8kAP56Ej2DQE0OpGNgJKxyppT
	ysM5PtQZVFyEwvcJq3RSR6dDwj6ywgA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C54bK2r7;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794362091; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=88xXlYyhRaZNXXS3X5RWnFnkAdm1161ZT112AKHXrTc=;
	b=C54bK2r7jNmzfBU9aZKJ1P+pFVOr6FkX3kNvl0sZCDnP3iR7U+/47s6HxQFXTUckeZnfiRml7cwcXcVU93eSv6/LX4y2eKbAK0smX79YNxM5cdMgZcVcTAJd4H328s7Kbj7jbExBaunLG23mQsACE3yUOxwOgU+Fen2N2prI4ms=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XEX4t7B_1794362088;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEX4t7B_1794362088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 09:54:49 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  "Kaitao Cheng"
 <kaitao.cheng@linux.dev>,  "Garg, Shivank" <shivankg@amd.com>,
  vbabka@kernel.org,  ljs@kernel.org,  liam@infradead.org,
  rppt@kernel.org,  surenb@google.com,  mhocko@suse.com,
  linmiaohe@huawei.com,  nao.horiguchi@gmail.com,  ziy@nvidia.com,
  wangkefeng.wang@huawei.com,  tujinjiang@huawei.com,
  mgorman@techsingularity.net,  chengkaitao@kylinos.cn,
  muchun.song@linux.dev,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com> (Yuanhe
	Shu's message of "Tue, 10 Nov 2026 19:26:41 +0800")
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Date: Wed, 11 Nov 2026 09:54:48 +0800
Message-ID: <87jymkt9nb.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: cbzu4i5jsfjt1c5c4gy5oid3hsz36okw
X-Rspamd-Queue-Id: 560DA100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794362093-94425
X-HE-Meta: U2FsdGVkX19VbBvLF1Z1hy30kg28ly7BbMRyY59KRTqsz2MTQ4BVQUax9dph0w1EDF9v8+xxoyvOVQIJqbNvQh8tg+l1C3ibOBHd7tJFQJZthpiSf3Ra5+Up0V76B2DWZEIWFD+tzvlAGQVuQVz9f8rfvawyPYGmCmGn/c/MZAd85OFMRhiyBJ8gSa2VXQh903QIqKHuo5oDgbt1kmXFTA59LSD0XP8QmKRsh/mq57WSB8Ahv0ZEqBgJ2tMYxjPA5fNpbh3IbnDJE4XkAcZvUrQruqlslUMAhAMqAQq7aTjvGXZcufiOWdlFcC5/yCMfn4FIFXxPQlkBJZmoan3Zzu2xiD01Uto3ZZFUmT3L4fusBCnWDxxSnsl9BJ68kz5DxugJrjOyt4bbrqDWTatuNKu9igpYeADq1ybOeodE9QR2Cg6lGe/94qqg8M5GYIGHCjXuN6VGCl51kzcsajZW3FrBF3OlV44QJb5xTcMF2AHtBxEZlWwhvaZQBZoIzOqNwwoEcAvsdrcPkUwl78zs+0tFtQysceg1H7Ls/hGeOMw73epF97pTkh90n+12HTJvDMPtwYnYsncGXYVj1HQppmDmsZeaNPGxiFAqk/xMg3mJjRJOEnLBsu1IK62FGpHx1a+QqCh4N4VO247TaM7pqFghqUNDmUvARPUsnx9HhuSBtLzZN6jjZ6F5QR++sUEoFrFz1JZ4RKkb4R5GuP1Pj3IzQIJ8T3qvGMXDp753QFiA23RIfo9jlbZZjLgan5ulv4Zp8m/ZbkVS2gB1IAq+XIU1Y3DunK8zKZDeo+38Z0CxBI2SKVp649b/K4X4ViBoGYPdiTU0SGKBkNJGUM4TEYPq86eAjNQF2ohh6yRVGhflG7lIVaEzyxFlp5ZVdCzM4qlYzk1+a3oNi7Qw/dxFFeTqKQs+y6HZVkmalfgpzePDBaXberCmfyCk36g6qBO/Zkwb38IIXcAEr5OpCW+
 SSb8Er2e
 PYEUADxHxNzzHan+t8dlswo4cnudJhw6iRjPHRJmZY8LS9CjB9qQGVVFUPV79PvtG+jD7gJb0PXE1RXjG+evQYxwfTVe1dEgW2xBmJBlloWVZuEFPmQFZypKVoSaHvdFk7O36saFM9pWVcqz0Vbrrr/15URjW1Fl2A/WCaRhrGDx8cy2MvJcdi0e01hDZ1jTZnhIHZ783ttxEU3BiMgsVvNG7CQAXsNMADE6nL400iNP/j+jFnJXhke3Yx9JsRRQ4mnEv2uZad4M8iuEHAcQ0igUaM7Jzhs//kcj0fwn4fsV5mQzHZYBILRbWg6AkTu1yzEWG8/0P0/tkZpW+sfaA87NyNzc7gfjofpwagcM82w3qAQR0GtzEJI31cxwQwRxAiLsE0A7ozvjfPeqdQUpCZtCbMAoJCciPI2uv3AVhUyDJ4UO+3/gSjVBeMwFSi9dKp6e4
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

IIUC, this is just RAS debug behavior, not real-world behavior.  When
poisoned memory is accessed, an MCE/SEA is triggered, and the kernel
will panic without a proper copy_mc_* implementation.  This patch
reduces the probability of a panic, which I think is its main value.

> Check the source page with is_page_hwpoison() in both fallbacks,
> before the copy, and return PAGE_SIZE, the not-copied-bytes
> convention of the real copy_mc paths, so the callers take their
> existing error paths.  On archs with copy_mc this code does not
> compile.
>
> Measured on arm64, where the fallback code compiles: a
> kernel-space microbenchmark measures 90.00 ns per copy before the
> patch and 90.71 ns after, 0.8% of the copy itself.
>
> Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
> ---

---
Best Regards,
Huang, Ying

