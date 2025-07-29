Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4243C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C28E6B0099; Tue, 29 Jul 2025 05:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673D86B009A; Tue, 29 Jul 2025 05:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5893E6B009B; Tue, 29 Jul 2025 05:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 494DC6B0099
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:59:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 003681DB484
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:59:36 +0000 (UTC)
X-FDA: 83716855194.10.BD2565F
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf11.hostedemail.com (Postfix) with ESMTP id D905B40006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:59:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dd/BeePA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753783175; a=rsa-sha256;
	cv=none;
	b=76tAcozfCkJzfaj86nNGG7GkZPQ1ZMjl8Kgo2A/HdfOaTZBIy7zMWusQ8P5Cyt4u7Zam/j
	ZAnTnvlBZr75GwWnikqmR2jyNbFbjEQykYLF2xjV+yfbNhlxVsjQ3Se5wyYVEVLQMEcURM
	ZhgIAHgbiasqQ5ZCFF81+uMMnGqI0sI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dd/BeePA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753783175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Rx6FSp83mZmyZ/jpMUszx56kknDj1q2uLEa+F6Q+tE=;
	b=eBceTP+B9ftpN+Tpp7iRw24kJ6NoUXJSIOYGh2aPAVRhyM8Yaq/1Kju3HHAMrwz2RsP83R
	RewR7jU6BYz7DHqNj90OdyztfooCnrWozuMHX+LJcATnSvPaBHHdtTruWjRFSJcNvyeMt/
	bieTWQH+qMWrbP2GlletMQHnY6DV08o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753783171; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=7Rx6FSp83mZmyZ/jpMUszx56kknDj1q2uLEa+F6Q+tE=;
	b=dd/BeePAXV1p4OsxwJMQHJoclHKfBCIrpvHpntkTHJlgT2vlPK+JKZg97T/VGDkh3hxe0X/P6kscgI9PcpxNyAOmBuMj/LnWr3Pa02VuXtuB3FwghBMjtO/701mBh1Ua1uixhce4blDcEbhYptJ2tzl8JoXT4OixTGfw749pEjQ=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkPqgWA_1753783169 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Jul 2025 17:59:29 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: =?utf-8?B?5Y+y5ZiJ5oiQ?= <billsjc@sjtu.edu.cn>
Cc: linux-mm@kvack.org
Subject: Re: [Question] About the PCP free_high heuristic
In-Reply-To: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn>
 (=?utf-8?B?IuWPsuWYieaIkCIncw==?=
	message of "Tue, 29 Jul 2025 16:08:20 +0800")
References: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn>
Date: Tue, 29 Jul 2025 17:59:28 +0800
Message-ID: <87ldo7z5a7.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D905B40006
X-Stat-Signature: n3ay9hxaui3f4b8jm4zqwr4nhpxju4fr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753783173-54488
X-HE-Meta: U2FsdGVkX19NAODhhZfOpk54ELQ+NxCcxeAaK8WvTpcXR0hBX18dGd3LQ+Etl6u6K6gqwOC/GqmidgKaL1zrSv4XxWuW1q4sFWF5+ymKm06FBa42g674DoE2XHZmZ/l+8R2Kou0iaX/YrSMF7JDLnawbEG/2A5ntlS396ZxMT4FvoAGFZuPDW52weDS9cXmUNM7OBE2+Epy9ilPfPtR6rUH7zEXvTpmXe27jjA1VcHzCGMtVYJHu1kMirrcNEHk27mleHSxyqJ6kvqa5s/5cg1ZpQKw/1WulJCLEPAXjhol4D8geUDsHb6zZFe3rUbvGkK55ZwzwO6E2/VJseS4Z4hDcHnhk3VkJswnWUdb1WLfS+qNd9Iv8Zdq7lAZpbJiG2jap8nDizZG6voZwCxmU95KkMMVzvp+u62JdCaTwHz3eqWMPUPFsnpyLUmU58via/VAr1OB7UMvWREN4qHT+ZbIa8A5L7I3kfn83LapEk/Bf6JGeZCg2kX+QAR2G0+n5qv9hF3m9Xd+2OA1C9swascUIhgyJkMrJDpljCZuW23w2cFxOnlTuq6uhCGQR2z69YjQMFdsLDaUi13+nE/vZrNQdR+2DYUr9PmJgG5Wn8Uo3fzCjUK6QjgdTi3Wc+YQKuhc38q/RT8WQEXEMQlmR64P6fg4lS5L5TX8S7REWs5tdTkIDCiXb5qx7IzFrl0AnoZimchc5Or+W7k/SdKGxF/vQBchw5jCfxNdZbC0Tw/iXBqgVs6IWJ/KNObsGZtTUiwD4iJCLtrr49mie6lbwhLPfqGRcR1wqjSqSL6AwCdRqZPSTgpwwF2YyZfn6CtJKM25wHGklmZz2poVm+VOeiywsCyaiIMHFzuUHf8YSYGQA5UTN8cjTO0Yr25HgRNvpSxWFl2+zXWpHiXpCacfQG/zXTqjrwG8T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jiacheng,

=E5=8F=B2=E5=98=89=E6=88=90 <billsjc@sjtu.edu.cn> writes:

> Hi,
>
> I ran the bw_unix benchmark in lmbench on my test machine (EPYC-7T83, 32 =
vCPUs,
> 64 GB of memory):
>     bin/x86_64-linux-gnu/bw_unix -P 16
> The bandwidth result was 30511.63 MB/s when percpu_pagelist_high_fraction=
 was
> set to 8; however, the result drops to 21595.98 MB/s when
> percpu_pagelist_high_fraction is set to 0 (enabling PCP high auto-tuning).
>
> I first inspected the auto-tuning code, but the root cause of the perform=
ance
> degradation lies in the triggering threshold of the free_high heuristic:
>     pcp->free_count >=3D (batch + pcp->high_min / 2)

free_high heuristic is used to increase last level (shared) cache
hotness via letting one core allocate cache-hot pages just freed by
another core.  The target use case is network workload.

It appears that free_high heuristic hurts your performance.  One
possible reason may be that the last level cache isn't always shared on
AMD CPU.  Can you try to bind workload to one CCX and verify whether
this is the root cause?

> I noticed that commit c544a95 increases this threshold, but pcp->high_min=
 is
> relatively small when auto-tuning is enabled, and the PCP draining leads =
to
> the performance degradation.
>
> The problem was fixed when increasing the threshold to (batch + pcp->high=
 / 2).
> Is it intended to use high_min instead of high in the threshold? Would it=
 be
> more adaptive to introduce some new tunables for the free_high threshold?

In general, new knob isn't welcomed in community, because it's hard for
users to tune so many knobs already.

---
Best Regards,
Huang, Ying

