Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2036FC44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC9E6B008C; Tue, 14 Jul 2026 20:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5DBC6B0092; Tue, 14 Jul 2026 20:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73C76B0093; Tue, 14 Jul 2026 20:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 907C36B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:18:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B6BFC0526
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:18:43 +0000 (UTC)
X-FDA: 84989100126.29.5D2EECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74F8FC0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:18:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFPo7Yva;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784074721;
	b=KrYj1e3AzIQ0l40xJPNWnoLzbJHnWnA/0s0GsocVmQKCvNDOz255pGJ2O8cMPESHEq/rKy
	0accH1Ifwl08O4z7BzX2lk8MiHK3E5E67zhGCX66ltZLYR1W0HowXwX+uAi3X2YTCHtBvS
	5DIwyRCRDaCAWd54MruNVztb+YlZA9Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFPo7Yva;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784074721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3HZR7bEntVs/K50pnsd0JT6YW8Jt0IbF3Prw+PD4Wc=;
	b=MHsHr2nbQ9oe71bIrf5AXOD8eEu4HWyzGoqO1iDZveuGBXUazn0z53n6poIxjxFQwRZCN1
	P1a22iYMrrvBE5w/xGDS/QyIyxrb8+6QV3k4fRE3cmYKILF/JI3AZ7bh57hvrGV2HzkzPH
	KG55rR+Ef6+guR3pGPDL+72hM6wxR5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF85D600BB;
	Wed, 15 Jul 2026 00:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D31F000E9;
	Wed, 15 Jul 2026 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784074720;
	bh=o3HZR7bEntVs/K50pnsd0JT6YW8Jt0IbF3Prw+PD4Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFPo7YvamTYKlHjwOtyNaUSjis67MXYZWdKFSkGSx6G4bObncfvdmjEsa5FWh/OPY
	 Trt2dtUHJuvE5gmZRgxhooyhUEB5Zat/ZY79a4BAZcYMQ1Uqw1cZNhmxr6PTeN4ovI
	 G30gsVPCdgBoLy3Kt1h45sUaQuSCc9eAy95MrjUG5CtTfZ+2TiIxwVISb0jkrwBz0r
	 wW1SvgaLHIQsBc/9CYB72kUls6ZRPDWnO3wuFxpI3+jXMnAoGVRVo2mvlZKhSlMUDY
	 EnCImW0pkEP0pz07eCRqFr5nbSapBGAVCNnV0U24UkvSMRJJXw1sHnY9hO8ilNYphP
	 NJQko7jkqNwHw==
From: SJ Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SJ Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Tue, 14 Jul 2026 17:18:32 -0700
Message-ID: <20260715001832.106007-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74F8FC0004
X-Stat-Signature: 4yzhdaob7m6pkf4jx4wfkdrr8fgpgndk
X-HE-Tag: 1784074721-711435
X-HE-Meta: U2FsdGVkX1/B0O8S3MQm3tU5eRKeDKFEZxsljU5e9H29uiZ+N9P3HKw7aeOqtednO0Ar7vTsnaOXONK9mWkNHqpwGIqFsGm/Rs0RxYVL11gR4Uh7h+/GYDFej0af3x4OgFHct02Ra+0lh9sDkxpoiuXHk/Mnf42Skib4tPDJ4iZMeuqn19OOzNKY7Suq8EktmaquiuRPr/haThEGiw1Vm19ibG9FWKEBzFfOZyrUhWSglBK8v9D8BU1szl/pj5LrlYvsp+RtSWgsMyFj5LpqTDv/qwTWxDkSucKC0rUuw+FHFuBhyJ82s6j9jnZfjFGZ07a0pS+e11ifzveRcbEfoTGvRoc8ykbGA2+iyv2KHnW8nlsmUQGP+610RuBG5VgYQ3xKn2oWG7hg5pzJ9rqAKWWqRVGcVnQ0KJurbXrorxOrFysbsj0ybim6+6reL1eNyYNHf5Fui7ihfYJCP0NxVUabqGQ6mmNldl72L9HfOd28IhuiUTpDlu0cDtQ95NEM+TN85QNeiJQGZgl4eMWOkAebnN6eRFdoXm3pYRWVXYk9CoUuSjQ5aeP0Rwpb62zeKwx7NJs1ZKlBNvBFQHCrr5PEdLFmCH3VKkbevyKJmxwvaK3LsLp8eMaRbeMPYXw9lVHijvkN1I+G4C0WUuCgPbvAcpm9cHTrOJJdzFB45cY6hasd/XVap96qrccMmIcmrUMEurIcY7cCAl2mablhpmHOR5iWEAizuVwLCWepZAc8Oy2IhNpMXyztVXv3pw+83VJpGIqHwVRD7JUBwLKDwnnjMmsSim79WFtP687cm9z1OUfFLtzw9GyrqUcs9z2EY3piXH7MfNVvLG+EzPj/Uw1vYkYhS9OLhyFB/hCwhWVyKBMm/NnsS3VVbMH67GV4k3sOEfbKIR7YrXqZe4saaV8EjkLCSbiYTyiILqVj7NWQo5QViLhiZbO2OyV8MguA/qqhFlt3XctHZyy4lGk
 s5MyHn5a
 pv3k6C7ENTD9CC+Mtqxai3VnVpJh/cJZNPbimwC1T3a+DJqtcwf/doryDPRxgzmuwyCZ8Ft6V5+s2wX+dXUBQ8xAJtNggNJ+QNtGUuNSmD6Vh2aXT0a46paUi1KluXuTB3q/+i8buZ2ggQGDzHdzif4wNDWmJDkCfnC1zNJRtIB/31KGv9jqoESedElF3oZhHeygFI5d2w7ivw5KbAaC2B6tws3Ws6JaK8QkZxsAZ6XnxNk6vgBiez/thLzuFANhjusuyi+oWBqIOGcKUrtFz/GRr9fVMSlProMzs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Tue, 14 Jul 2026 15:01:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ========
> 
> This patch set introduces a new autotuning which allows to collapse
> hot regions into hugepages.

I sincerely appreciate your continued work on this.  But, I have to say I'm
holding review of this series for below reason...

> 
> Motivation
> ==========
> 
> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
> misses (or hits) is to use huge pages. Unfortunately, using "always"
> in THP leads to memory fragmentation and memory waste. For this reason,
> most application guides and system administrators suggest to disable THP.
> 
> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
> However, there is no way to tune the settings. It will collapse all the
> hot regions that meet the access pattern. If the server is a bare metal
> database or big data server, this will also lead to eventual fragmentation.
> 
> Additionally, currently THP is set globally. Ideally, there should be a
> way to control which tasks can use huge pages.

You told me [1] you will rephrase the above.  But I show no change from the
previous version.

Asier, this is a repeated pattern that makes me reviewing this series very
difficult and tiresome.  I don't really want to waste our time on repeating
same words.  I know you did this great job so far and you can make it well
completed.  Could you please thoroughly and carefully review "all" previous
discussions, address all the comments and resend the new version?

Particularly, please note that I also asked [2] you a question about Sashiko
review, and I'm still waiting for your answer.  If you don't have a very good
and confident answer, I'd recommend simply adding the zero-case check.

To avoid wasting our time repeating same words, I skip reviewing the remainder
of this version of the series.  I will review the next version.

[1] https://lore.kernel.org/b786294f-0ba5-4b05-b956-d902c358dd88@huawei-partners.com
[2] https://lore.kernel.org/20260617041515.98906-1-sj@kernel.org


Thanks,
SJ

[...]

