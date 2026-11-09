Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C28EE606EEA4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebr0IUwg
Received: by kanga.kvack.org (Postfix)
	id 99B0B6B05B2; Sun,  8 Nov 2026 19:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A85C6B05B3; Sun,  8 Nov 2026 19:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE976B05B4; Sun,  8 Nov 2026 19:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 460DB6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:34:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 993BDA0493
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:54 +0000 (UTC)
X-FDA: 85413710508.18.3402B50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17B7BA0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebr0IUwg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794184493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OCudfXEDg6cig4yHI+UL63p9GsP6rZU26NzHz6BN+I=;
	b=K/QwOBHXIKIZoyDh0dHS/VeaFISwjFHEegTUIFLjTs3uqV71crEvABqMZOJhwpglPUfJwR
	aYrcreybLHt01qBb+405iBCRT06J++8RFY+P3aYh6ezUYE/X79ju6OfWP+nnofL6N0F/N2
	TI6tJ/fdgANHjl+j/P+hp/d8WdiFQLk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794184493;
	b=RjUzU/WjwcI/ItRn5fpAS2/KTP87XZaI8e0dEWOjcqprhyvzQMDoGf0ZHVZecmIzsqpoEe
	YubZzxGI7tKHBM3INCPjBJFChHKLzvLu0/9AucrIgZ/pd+WcxsD7x5ip7LE/CjuB5990kD
	j2GanhTrYjGcr8Ws+4wdUQyQi0aM88I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebr0IUwg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59CE341A99;
	Mon,  9 Nov 2026 00:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B7F1F008A3;
	Mon,  9 Nov 2026 00:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794184492;
	bh=7OCudfXEDg6cig4yHI+UL63p9GsP6rZU26NzHz6BN+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebr0IUwgo91kruwpo9Hk3mbBwDRDTrBS6j7Ob50y75nFR8MmrRUyk6EB47MxXB772
	 08VUMfY1hsSWTKbXCpLVubJCmAi1kNLNoDSImKenxeWhQbOL2IJmETIz2ekO3JKBn/
	 A7HKMcdwLVKBaia4SYBC3dxPViIQOo+qwWeiz2d/Yc4LvLVb44UNbTCMWQsab7WExQ
	 gvzIXHHsMeDDu1RcC7x+qY4pOsN2YvlpXgd1OG5XbybiHIN+Mwb1Yp5hnvpm264UFd
	 eoAit+l/jZS5+pYH4ecbP11wbPkbZBzVrB06jqHENA4MCR0XXgZjw3y7qAKvzmMp3q
	 sOAdv2ROJWYCg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [RFC PATCH 6.12.y 3/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 19:34:37 -0500
Message-ID: <2026-11-08-1-daily-reply-0009-damon-6-12-psi@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107214525.304638-4-sj@kernel.org>
References: <20261107214525.304638-4-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xd8upj8rep3ekf9wupxhp39rcgxpisze
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17B7BA0002
X-HE-Tag: 1794184492-222226
X-HE-Meta: U2FsdGVkX182Csk7ZlnEk51NnaGzEi21K+5eKVJjTagQ66wFWwQHwSN3A4qtqae04Wyf8OrT/mborIvRZfgI8SdQjnn50l/7UUdzVs9JJQ+d2Ell2loHKt4iEylHaEtjhy+M2NS0K8U9bmLTrCUpdySb/4jYrYD4nXY+oxYrrThtoBr+1/fgfsOVG/RGCnhBs3IVIqdzcBG5c0bw3pDcYWwNo+ZxV1ZBIA2Sge1xqi2SkRRT3IHuwA/qJCQHeDIrO+3QZL0L9j7/bO3NrudK/mRw5cxFea+nzG7p4ejcS8w+PXIC4yTfbXM5LR2ogIKTDkgnCRGK9TGQjE6ASj/IS1T3Ox+84ykGijbPYRQN0305x122ymSX7+R4A1w+BXkVcAeNArTaG0RicD9z0viNOJmBX7oui2P2JLMcnBJtwod0ALligjZDzyPDfRV2M497l6m0T+Ez4z4BbKwdpMzYkI8UdN2Cgwb+OtmQCLaMYjWF6ib8rsBTTd77P7fZcYWLVn+Qv85KGf105AgovNeJO0ZNs1x53AFAMsn/OKmXKfwRA78nPrNsMUf5qCWGQSnp3U2oD2cFR7J6JHJBVw1GkTNpiv5BdkIT38e4CbaccfKHZ+6egDDR9guMQA6vvab7Fiu+LqWBNuVp8eagSlZemqaZc+thFw9FWtjffWykGWUFOM4RMqF5ofqMy5Uh+e5dhJkOaeTQ+n94UmPocB0PSP9QFxJjfc06Y68U2SVIQUDoOqkZ5gJdMw7g0/Ot4jXRsJ4a4GtlbwOZEdpjHP8yY2528btddyhTliBs4DBgffk42bVMvT8UPqCiY8QsQpWaNXHmAC8uiR7ursdG8dlzeci2rH8qjdgZuMe3x1+KId9Nm2hWGXN37O+zyYBoYtRfsINSOaYVeeEqU+ISzDKtXW4INVlB3zTI2yYk/nJeBOVfHOz1NZPwxEkN2vxQvRkE9ebZijHDq/v+H0atj2r
 I4JA8Uqx
 c1haC6tXKmA1NGCbN3jvqVQIELhmV6Zujz742um2Oc3dRXYqpq6VBYABlsfR4tvs7tQAPTQ/p86tLEvp3by3D86eRHn86sz/4IJLFpe4oIlNNPby6wGnWB4JLELMC7Wfj8Y2MLCb6IS1l34cNlDZhVmldt5WkOa9yzN1dr2nYu4IZinhxB6IcgJ++oJsid4QE2yHvCZv4WcslSGXjkqBjxWfPgq00MAHoI608uq70cOaCcCvwid26mwuEoc+BPWIrh8ApD7jTCV14q+spjDN1gUYHT1PZap80z+1foOu6B/JIYhN8TrJlUskyeCLmaCTYcigYZHaa43zBQdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
> delta for the feedback loop is calculated using
> damos_quota_goal->last_psi_total.

Patches 1, 2, 4 and 5 are queued for 6.12.

This one doesn't apply: 610c4438fb66 ("mm/damon/core: error
damos_commit_quota_goal() for zero target_value") is queued for 6.12 and made
damos_commit_quota_goal() return int, so the `return 0;` has to be kept. Please
rebase it on the queue and resend.

-- 
Thanks,
Sasha

