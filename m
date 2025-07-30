Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5A2C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBAA6B0088; Tue, 29 Jul 2025 21:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C9B6B0089; Tue, 29 Jul 2025 21:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1B06B008A; Tue, 29 Jul 2025 21:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB2E06B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:26:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E505C02BA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:26:41 +0000 (UTC)
X-FDA: 83719191402.11.029AA5F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7388640003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:26:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X655+ezo;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753838799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66qP145Pokuu8JsiLXxLWcuYNVd+EPib7TlXMXGAKk4=;
	b=BAw/3M98gYexNkxZxuoSlq6jXqc/UNorGsqmT+1QzM6Fd3Y5UGkH19G7CDaWhoxdozXbT5
	/0oY/SEaWyBkLKnzRUQy/PkOTG5Y/OuHqj4L1FfbI+lGK94iiDjz06IJReKavbTz2YjhS6
	EXidPtwNc1O41eTOyn1LS+EO5rjciGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753838799; a=rsa-sha256;
	cv=none;
	b=j+HndQh35LEsPkAhOtTP27c0jSlXz4WVCPy5+TnVHdower8k8XYHvbqnkRaE74rDcw4kCs
	4o8ibZdiI3rDmT22an42Ck3FHm2Bf5TS5fbyDCXgrmKkWAkUGFjOwnaTGaSt9XkbiK/uE/
	6fyRsoY2/ukBkJL7mXrKe295IdYF4PI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X655+ezo;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753838795; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=66qP145Pokuu8JsiLXxLWcuYNVd+EPib7TlXMXGAKk4=;
	b=X655+ezonDepPDo0G7rDeBYBlfTPWZxqk+BIkrvfDJPJDjpAL+jVy7UC32nXBCYyVZAi+BgE7P1bFNEINNSiGbHWiMw2uZ5Js6PE0eXWIB8HxuEgQFzX3iLEGEu6MmcN4AD1JyPvt86IU+evIDATyZkDHAXay/IWWzRao0RG0js=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkSOR14_1753838793 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 30 Jul 2025 09:26:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Shi, Jiacheng" <billsjc@sjtu.edu.cn>
Cc: linux-mm@kvack.org
Subject: Re: [Question] About the PCP free_high heuristic
In-Reply-To: <93574E04-0528-4282-B1C3-4A16D9768EA5@sjtu.edu.cn> (Jiacheng
	Shi's message of "Tue, 29 Jul 2025 19:29:32 +0800")
References: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn>
	<87ldo7z5a7.fsf@DESKTOP-5N7EMDA>
	<93574E04-0528-4282-B1C3-4A16D9768EA5@sjtu.edu.cn>
Date: Wed, 30 Jul 2025 09:26:32 +0800
Message-ID: <87cy9izcxj.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7388640003
X-Stat-Signature: k6zw6866odkn7j7a7xxp9wbya7eogbfm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753838798-467734
X-HE-Meta: U2FsdGVkX1+4TBNJ9X3YqgPbkNBZiJjG9Q13lMPf5Xot9MbabJ2C2d13J1541YxN/GEorccukZd3f+8rKH4Pi4uX7oDLnaQUn2pgPNFdMUsBEa2BaJVPp7t3/wfV8gYrbv80wO+lPPYLe7oyJ9hwzPZvIoxnUfiatdo20XojM6KGsGlYq+hcnvUM+RcdMitxMMG/K8AZ8veqZrAzdheUBAWg0yZ6A6ikw4Rf16ydRtQK7E7RiOZfFspCU6Wt5lD6OiZz5OrSvS03rIW2Kw1ywwIWKv8XDPYq4Mil1UKSHI18cERUuBhvUcO8SOF55YgddZFQu1jTNDEWZtmcLXtLYMu6u8DXwxpn+4zxPqspMwjMsrB6IWHrVqb86fLh1ZiHApvknruc3wUa7ovezJxztl3aR1v7VTCBMS2F8pJ0Je1FT9+AFAtXhL6CCVsr4qWrxXF0tMJhavdPDAYsR2HE+ITTFIIzXZL7AbQ/9MDAc8FOOZPZcoolpSLgor5XLLO0i7M6ahHiKC9PQ/aj97xY/UPn8UbykKcvpw5G49xfWpCaWH8t0kXT9x/E0UZFjN+8N75A1kh95wiq+r0mTNbLZhKz2phQ2SzxoYKVm4yMze8apUKpM1uwP82moRhsCJ/FYwGsGtMYzwrwp30DZSj6R21w5Re1IPo+epLohRtAemICqYy0ptDKYKdCa6aCvGTFB1mGuWMsZciW2xptqziuPr/LQgTDmRun/srkdt4mqAEQvJymV6XXqUoWBJr+Fv/M7w9HJ/M1xdBjJafMst8KPLX1cmdthzfdD3s4wASC6M3nVgWn/xQUPH48TsdHjZVUx9X/1HHqqYAbVOUrPKYu6WMvH+TtZZG4Cdp1ngWPX7eGj2YzY+tAUpyTtVJEClm2Z/ubFZwZymL3W0+RQ3jrwkMHLNVfUZJc1MB4hl8x8VVoYjirjY2gmN3gK+i+IdEjwMUYit7nQg0ZZVG3u14
 vKfzKsZU
 bOHzvQMzk2jWCLPqpMm7HfKcUw20svZhfwH9XMUaY6ITNdBwKwflljpAsxRXimqJhawFqGi+/4GnK2Z42D6BKTtV4Gl1CF+1hLCBG13mIlOcRmn8ZWJnvg4lEAoo2OD4Z1kHfu8Qz6l93Rjortkkwyfj4/3UCynNkHXU5MBobbcNEPPMWSyFNXFUlzHNj3LtLkt1b69HnDoxTeR+mvZRjJmiduFbMtcMwfJBazalCjzhvA1MXMHmgr2hGNwKvSR+LR3rkEcl6Kpv/kOKoupMQ76pUaB7Xd+gDMCFEsgoGPnWM8sqVfK9w9PuM4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Shi, Jiacheng" <billsjc@sjtu.edu.cn> writes:

> Hi, Huang, Ying,
>
> You are right. Using high_min is better when the workload is located on a=
 single CCX.
>
> By the way, I'm wondering why the free_high heuristic is only applied to
> high-order pages. Would there also be cache misses if cache-hot order-0 p=
ages
> are not reused?

The heuristic is mainly for network workload, which uses high-order
pages.  You can use `git blame` to try to find the commit which
introduce the heuristic.  But it's not a trivial work.

---
Best Regards,
Huang, Ying

>  Huang, Ying <ying.huang@linux.alibaba.com> writes=EF=BC=9A
>
>  Hi, Jiacheng,
>
>  =E5=8F=B2=E5=98=89=E6=88=90 <billsjc@sjtu.edu.cn> writes:
>
>  Hi,
>
>  I ran the bw_unix benchmark in lmbench on my test machine (EPYC-7T83, 32=
 vCPUs,
>  64 GB of memory):
>     bin/x86_64-linux-gnu/bw_unix -P 16
>  The bandwidth result was 30511.63 MB/s when percpu_pagelist_high_fractio=
n was
>  set to 8; however, the result drops to 21595.98 MB/s when
>  percpu_pagelist_high_fraction is set to 0 (enabling PCP high auto-tuning=
).
>
>  I first inspected the auto-tuning code, but the root cause of the perfor=
mance
>  degradation lies in the triggering threshold of the free_high heuristic:
>     pcp->free_count >=3D (batch + pcp->high_min / 2)
>
>  free_high heuristic is used to increase last level (shared) cache
>  hotness via letting one core allocate cache-hot pages just freed by
>  another core.  The target use case is network workload.
>
>  It appears that free_high heuristic hurts your performance.  One
>  possible reason may be that the last level cache isn't always shared on
>  AMD CPU.  Can you try to bind workload to one CCX and verify whether
>  this is the root cause?
>
>  I noticed that commit c544a95 increases this threshold, but pcp->high_mi=
n is
>  relatively small when auto-tuning is enabled, and the PCP draining leads=
 to
>  the performance degradation.
>
>  The problem was fixed when increasing the threshold to (batch + pcp->hig=
h / 2).
>  Is it intended to use high_min instead of high in the threshold? Would i=
t be
>  more adaptive to introduce some new tunables for the free_high threshold?
>
>  In general, new knob isn't welcomed in community, because it's hard for
>  users to tune so many knobs already.
>
>  ---
>  Best Regards,
>  Huang, Ying

