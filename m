Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDE0C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806016B009D; Tue, 21 Jul 2026 10:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768936B009E; Tue, 21 Jul 2026 10:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C2A6B00A3; Tue, 21 Jul 2026 10:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3533B6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:04:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1D221A0165
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:04:07 +0000 (UTC)
X-FDA: 85012952934.01.77F4931
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBEB71C0002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:04:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bqj6B4f1;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qjAipW3arar2oQ1bixfWVKbsgwvHLobvM3s6CkTaig=;
	b=g5CyJS+bM5HxWlkKe0z0Gxtd/orKZXQzblOlf5/Hldl/gmA7sKR8sNI6gw43notD+nCTb3
	AXmGUlWomL6HNCWCSPP20GQ4GkZ9ZNq13AwLuY5l0EpynQ6r/bX1/ItWu4aRYLkfKJ/N7G
	CgHUEfoVLgafPRO6ix5GLHapNhgUgg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642645;
	b=3Fdg2KG/ZX8LblIAOgGQdkdMZ/Lh6f8T2UayyOoDXR3r6DGRqPr/HXV7txNXzYzLOklDNH
	Lmseo0yix1vCvqHq9POBaqbpk7ZI96FbpAEyLNCN6kY4eaqPcxZj+hAlDAHNOj5xsNVexr
	NONNmvo8aNgv0vheC8SScMW9PiqxmCM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bqj6B4f1;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11FAC40576;
	Tue, 21 Jul 2026 14:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933531F00A3E;
	Tue, 21 Jul 2026 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642645;
	bh=7qjAipW3arar2oQ1bixfWVKbsgwvHLobvM3s6CkTaig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bqj6B4f1oF4DqBBhsnzjrmT7J91T1r2gWW2gW8hJkAeQNwEJUZZ9A3hwxjCgTIlPq
	 +x4Qq55bZ/fK/Ivsj33dE2ScI7Jxj68SByysk4XQqy2EzHJtEATc18Dcs/9bF8e+R6
	 BY8H5ojUlW1XuZtTXDTsHe1gcr36+JMG1boop4cMBrjdRe9VD1Q6/EvKva1gTo7H2x
	 QqsD/NBxbz6HjVUCHA6WuaLN/BnFwXyfJ1jqMyLAflNosdbbFqq6vsLjJTw1J95+NC
	 3HZc/KjhpOLx5KjZbmweHPP4O5pAZN60bsiEMxz5A7dKf/9ujJTPj4KVeDCKdqlzID
	 QaaJ5CIGn9NKw==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Tue, 21 Jul 2026 07:03:56 -0700
Message-ID: <20260721140357.285826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <524b7d2c-4136-4476-9a84-a3dedcd00c5e@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DBEB71C0002
X-Stat-Signature: mjmea6xhm6piwfeby7t4ot73xjmek8rq
X-Rspam-User: 
X-HE-Tag: 1784642645-634828
X-HE-Meta: U2FsdGVkX1+dnQEdEL7nxJII3+8qv+wgNNrhn52JhsgYQxhPn883A4nmUNw6Yw6zoNliZBRy5f0OHsKzLQxShYme7UhihEZpuNposl4zpzjD+YJKAZW/7whuKpozr0UlAn9GcW+UXpN2+DANGVRSoZ2L7/g1c2kTNoFBoRKRwQ6k9ez2PQoC6TPf1+4KFKFkIsQBnFw9rw2fgHxYBVTM+YetfVZFotASeoF8pw0mCnGDe3wbNBCwmbRwOssBnxDoP3FA1bEWr/7N2xaQ2XF132xsqeXLy8YSCk2u3KPmR4t4ysCMvWON3lzacrGCIuSzK8qJskq2dfI69OMt3kt22NvAs4Wj5k8hxjypVfaWYNQH080XiyuGVfFmvCKjCsg4PVEN5ybqGgWffB4ffv9AP/wsHEf/oelFRcw12kFdxb6iIXR5JmKeRhlU2fPZueSDRewXJQU3tEUBmsPDZqhwbuWlGx/ERsYviUDQOcIz5tNdHRFk5S/1OnAq5aukyL7oJT/viel8+jv1RTZfrJBlV5zP3HLUBLRug6H8UWkDcLtwNary8+fY8bnkuDLhdAysEV+djLKI9U7+rHgV6eAdCRDBUrfqRpwNogq+d3lLithUpP3jz6qm1fsTJnJip7pUhodAQZV98HP/ggOEM6scd4uQF78LdyNhpXiOEExIbSZL8iCb8XFaHTFt3Cpip3GtZSvaeKxAgG6lx97IFnLgzeU8saXaYx53pmamL/dtzKec29/T4c48DBBPMjM0w3mqgnMxtKDcjJ7uoe1B6an5cLx9YIxy+3XGibnPSatXd6A7iJzo6tFOBm9E44I2gpgNzeuY7HlsJNToFmPi5lydTRzdTB4WwN8ss0viaAhyTnhbZiTXWphfrZwkvJWfymEl7Ly7hekYsQxWwDReWIQP/342D2gJTzJzfyGqyLQ+8QGD9mdbu9fEckBkTpAe32k540BFaKfKqGHaXkHeN6V
 94v1+jAb
 xkqmsnP8GW1VxdOYXSl0+38PQ+iNQvOsw0Sbo/qCZg5v+MHjxmCfghKNHS0vySTs2grsd/3iHIA9gu+Sn/zIUEH3DIkVlDFxskfLHVrhHmkYhcKg4BmiE3eKxxtKgRM6Y6/L8CQq4DjP+lymbbgCO8nEFKPNLcE5/+kY1BEB9DgmmJNRx5+S3lWHUobsDmafjdWJ33fCgQflbMjKhIFr0KdnNCsSFZZvjfDCm/4rtlZf7PMX6ppptk1vyoCVzRlpwLmmurUrztUHKQtlomOm7VI9GoNuENKWmm1//M8WI84TyFYFvvT5PL44tB1YgjXKr9mJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 15:58:13 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 7/21/2026 6:58 AM, SJ Park wrote:
> > Hello Asier,
> > 
> > On Mon, 20 Jul 2026 12:01:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Overview
> >> ========
> >> This patch set introduces a new autotuning which allows to collapse
> >> hot regions into hugepages.
> > 
> > Thank you for making this series well done like this!
> > 
> > [...]
> >> Patches Sequence
> >> ================
> >> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> >> Patch 2 -> sysfs support for the new quota goal
> >> Patch 3 -> Document hugepage_mem_bp parameter
> > 
> > I'd prefer handling 'total' underflow and returning 10,000 instead of INT_MAX
> > from damos_hugepage_mem_bp() corner cases.  But definitely that is no blocker.
> > For the series,
> > 
> > Reviewed-by: SJ Park <sj@kernel.org>
> > 
> > This series is applied to damon/next [1] tree.  If this series is not added to
> > mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
> > to pick this.  In the case, I will update patch 1 to do what I mentioned as
> > preferred change if you don't mind.  So, no action from your side is needed for
> > now.  If it seems I also forgot doing that or you cannot wait for my action,
> > please feel free to directly ask that to Andrew.
> > 
> > [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> 
> Thanks a lot for your patience and help with the patch series.
> 
> I will work on the suggested minor changes once the this patch set
> lands into mm-next, if you don't mind.

As the change is so minor, let's do so as a followup if Andrew picks this
as-is.  If not and if you or I do resend this series, let's do that as a part
of the resend.


Thanks,
SJ

[...]

