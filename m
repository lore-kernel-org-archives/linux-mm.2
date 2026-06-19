Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6314CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A066B0088; Fri, 19 Jun 2026 11:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBF76B008A; Fri, 19 Jun 2026 11:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3256B008C; Fri, 19 Jun 2026 11:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53CC66B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:59:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D01638EEA4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:59:32 +0000 (UTC)
X-FDA: 84897122184.25.07075A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D7542000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:59:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzpLdfoj;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781884771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5RvRcw2meqklJnqkmu+HVWNIM7O8C9FRlJA2J68Y1g=;
	b=mi+Z05XGusuMm9sd7ThflFnV1GyQbnGaotnJZip1NTXWzx56mw+FhLBk7FkHhuKF/VY/md
	BF6AZpJc5rOmhxNJxHLijTGTg8DZfZ3ICXqTr/GIicJfzkDbKmd/ePRF34soTpuZ5MnlED
	u/QlerDHLAr5/ocrwoIOTIjD1pt1E+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781884771;
	b=JWc0JJBSq0fakieFkX1NYh+nRyk8lx34UuyTMVdvU+dnYLEss9IjaXH0f9m7OwK4Dp0pZ5
	G/hzqV0YgDgAoU5LAwXXsxwr9B2jOJ9pp7GeTTTcRtu4twBxtJq+Kwi0L1DBTMK5/YuKLh
	AIr/0Ad39Qnyva/zAEzDlL5criBxEUY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzpLdfoj;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 206F640D6B;
	Fri, 19 Jun 2026 15:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570F81F000E9;
	Fri, 19 Jun 2026 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781884770;
	bh=w5RvRcw2meqklJnqkmu+HVWNIM7O8C9FRlJA2J68Y1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzpLdfojBQvivOuVJaw39xtnvXRBtgCnT94eTds/Pj+vRFfIMZHexNsuZzIxJrtb6
	 fuvMaSTbUczNESBm50c+1q2ZLNXmt1IojMeOXrkmF2RZIhRWoPzQ/Vq1nSjL19Uk9i
	 HikQOTWs1M/cd/xcAiHTYBqkmKlxwPn3M91hDa8Ns9hFAS6QCdE7763q/YLSzlGoe4
	 Zi3HgCXudWZvesA3Df53ZmWzxc3vEm9BAqDaAcwM8EUad3U2/V9jDeByssUgiJJ8XP
	 +LIo/RrVnE4I8oFYPQfOn18J09HIGQT2EctHykU2piPf8CSc70xwZG3U50dm1I3FRV
	 e4mrfFSGWqjxA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
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
Subject: Re: [PATCH v2 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Fri, 19 Jun 2026 08:59:23 -0700
Message-ID: <20260619155924.11962-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D7542000D
X-Stat-Signature: d1sg5na553u7os6bgcpzwf7fh65a75ua
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781884771-449010
X-HE-Meta: U2FsdGVkX182mgK4QRymsa5VJQhX86aVH0ZAGW8Y9GeQfZRSBA5vIObqhkUrkDkImYx8AAI6cZRAYtJ2CZC4ujZky0IydT954c7ZKaORrkqTdjtwOxMIALLZXKk+hPVJjYFARsUgBUoPCm1uaK6lqZJGyr4A3T/1pjFC7Fk99+9rwH7wC0E4Fpytlpn574GRmU1q3XlpiqFfKnr2ncj6lQwPEwxIDb8xDrfj3zRH2Hte/9k3RfEm3YbZ4MOgnTBMnLgI7RXCf8DPX0f9PnYgwm4nSGJNFVXPqCVTzayZud/NRdey9Cj4ADB0VrYrlQNCnpz+N+RWmEXS8l6HJb2jk9UKXkDgWQqmt8ET9Ay1IrJL9ik2V+kpgDltZPtAwfW+zvY7tQkK14TMUMs2TGUHCt1KuQ0rlXYIiv5SaQLWeQwDxMR0z4A/ZRdcwNlCG2kx/Agt+LQDNZwBiQ8cU4mncF9cX7jXWi1J6zKHjoLpSy2W/3RRC9NDMXrFCC2o7rmyyQ6cy0QD5rhEE9E2dP30nAUO8QozRS6oXVEUz44bokK6wAFhOoj3epTQTimxoR/u+AtOjF9y00aUL64UArT6iC19Tbv/FynTfFWgF9VDigGHuhoAvh+OpDStcWmZEO4fuj3FBz7pVxNcUwBZrPmdOxClQQ2/ew81griuiV54CAVgPOhvG4DwRZYfwYX7GiKVGAvpzU3NmGDoeZXdw3XhOUg92u5lem18Mtheyc/U4+bgDYwrnUmylhYgOdqQ68XXAmd9MJQq4bD7WDqBZqJYfYErAFrGjuXpdQRT4VH6NCX/yRNQ29GsUxwWYcgZ3OBuxWJSwzxuoiXyIouJCTCKH0gLbkCjrNpQ59OUgOJJh/uuEBQ+RrzSn1Tle3GnZfAlaSyMX/LnqVJiTYcAgFmfcdpVbdWBSu266IjPhGGQO1ee7UmKuIXM2ZA1BkQqwwHVRMs8DnK1ZsG+8PY9Bxr
 wQa9URVC
 1+fCNUnv+x6Ny2iG5Sm87AUBjWEwGQA03n76dQ4NDHdxGnleJmitWCYmHyqDys/eSrEujCYWigS1PVcXFBrYDKN+CvsX3xIbgT98fNAnPdC0mBT7NsyVdGzl1LU0wHhs6jom9XRY9QQjIMqyf3MfSWGvLtK6cCN6I4Z7ZIOv/1gQdzOaijDHV1jkDPtUaKRll0HENdRmT5PVETqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Asier,


Thank you for keep working on this.

But, I don't think you answered all my questions to the previous revision.
Correct me if I'm wrong.  If I'm not incorrect, could you please make sure all
comments are addressed before sending a new revision, from next time?  I'm
holding reviewing this revision until all my comments on the previous reevision
are addressed.


Thanks,
SJ

[...]

