Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08172C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25706B007B; Tue, 21 Jul 2026 10:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF786B008A; Tue, 21 Jul 2026 10:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0746B0092; Tue, 21 Jul 2026 10:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 946276B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:06:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09036C01C0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:06:28 +0000 (UTC)
X-FDA: 85012958898.29.F6F8928
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AA9C180012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:06:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTokIeXI;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdhiAY3AR+DWlx+cfFlEkb6gx81e+qOTJQ6399p5XX4=;
	b=zGEYydqjwD9y8QxbupiP4Rg1+DRPUKZoRa3hzhY+MgaQLXWxr266WHNpv4mv+jr4pmSfLq
	qvDZnoDsNrT7Udm0epTL+vD9Liv43NeZxf4HLRVmISL8haiVXlnxMIZyZmTWv5uo4GQWD8
	93ocGsaMDEiY21K83cybLOBHax3ZpZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642787;
	b=nRpPlQgJuS/A5TQlYSzv7uTLt1uvzn6acKeSA2WqrDAj5ShMhnDioHiQaCDdYBcz0cR5Yd
	2d22xQrQolddvWx7/elxqc97zZF+TpEBCYeVHnbV3ORNcziWNAnTu1oPZUBXMyjKWYgFxb
	ibtlNiLQLtCnUR3d4Cmw79bUQgNz8Vw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTokIeXI;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B7A840DC1;
	Tue, 21 Jul 2026 14:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3641F000E9;
	Tue, 21 Jul 2026 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642786;
	bh=CdhiAY3AR+DWlx+cfFlEkb6gx81e+qOTJQ6399p5XX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTokIeXIv0qyStkdpnmS+y+AQHlDHS2hFIEnc6/i0lw6uIKD7qarbgCA5oz+mjWev
	 9mLc2McjUXzHaf475W79BvctBYhqr9jgx/uKcQvnTWLwjAm7tmc+lDBMdr7jov62iL
	 9PAMjgxK7yggvD+6u26v1MFd8wrnzR9WtdFbx11qYv77LipTtyWlFaH2Uvy5IPpJc7
	 x2dzalMX47/mEFfSHtFr2SMl8l6WM59Dlvi1wHAPj4o72Tec3DOirezrsSgIX8FtcK
	 q/lAhiuBkSyUfPGIKPuE3rzjY6IgVJCC6gcutsAP1NwDZn6KLPiCxP2nRr4QneY5Aq
	 K3kbZx4LSOXGw==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] samples/damon/mtier: add comment for struct region_range
Date: Tue, 21 Jul 2026 07:06:18 -0700
Message-ID: <20260721140619.297538-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721070756.54435-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AA9C180012
X-Stat-Signature: s7qt3nc6oirdfhxskyg9njojciigpfbi
X-Rspam-User: 
X-HE-Tag: 1784642787-610209
X-HE-Meta: U2FsdGVkX1+jyPd/maIywfD4peaMz2TmFFdnTAnGbNxYHCN5myKXYsRMAhmE9XwUVkGw0I4Y4WCCE1mGzDsQcpZwjabVYgkuMjB3/N6q8Q4BZs2CHGyOqBldgJ3YWDw868jgxepT4uc+CEOTJ0O1gsDrM7KUgU0AE4jpV/Z+ADpt6JznwXLVE2HJAPtyuWX4tYez5qzhdZF2LmbC7bMgGKNQ87YORo12QQxT2qtQn7hKpniY6l776Cq2Hzkub9W8ri3ATKUWD1X+KMqPRuAGAbQWvhbeCO8RAVwFboNacRNLermL8ntY6D+abKWPTTT5IvAU7XoHz6CWSVns7m5lNn5z4X03OZQk47x+T1rItv3MCW5S7sEQDPtO9E59e6b6DEP6phzLVeEnPgW5GnI3/0RA4qHQtHhZUpsrfdeJIz1vS9pBQ39Q76w3msbNUP/N69OYwCdZpU4RV/5TZb5UQJTe7NopVvkwQibIqxMqlAjx7ZhF5YmD6pNPZT5YcMVe2zy5aCrXuL00Kuf5vvRvy4YY3CY7IqVFApOLVdwoAD+HwTwt9Cyt2vFsiK+zC/KZtRTCEFuZPWlqgNm//i4MkWBnUuwk87uKKd5nGzlnzkiIXRmhW25Ne68ZcqqrJ9xMIZc4XttzVEY3X7F+B+Yi4UVUarBVvTOuh9ydMO9knXiC4GOfSENm2D30Wk3sG4KDGXQpQp79I9XlTA9hNUC9SIbAaidTXa9xHyjHSkqp4cMBOHtaNwKees1RNGf9bd0HM6FyyYAWKxJiQw2Ue48dWTLSn5UNkFXEJRqvYuxBvIb1WjGd2qvhma4guJkekxDujQVrzAu3AkniKxfeCTo00/AupkqnkOaV8ULqIX3VKjB6Hrhjo5N2CzyQbgjp57IcoleeEMQJxMnFG6eJNlFmxlVmOHAquCCN/WhT5yp5yrNkYtTHxTPYvqS0KF4FdavYnSKoTNSUAvwk9cXROjl
 wyzzf5Sk
 nfIEifMUxahKIgESt3KMB4GWfUmgRK8Uw0G5hkjRsF+cCDDbhNaa5GEt8hLEVO1jpnM53RRp2uj5fiyBz9bv7h0byMZZxxSh8OkewNHHYikQoacQjia4XXxgV8MHL0FGgX+7bkJ4mx/7UjQsgB5gTvmy3PRSCAvIEBeB/PxQKch77/gjYcoJN3YnbB8Vv9D56QAVj6wI8caOPLTYCwfcPpMb/jTRXXL9C1BKj8U0G5Q3JfUnNABvpISp3bjcuBlF7699QFk57JPf0uT4kDWIoJ8KdziaUNl0VHSv4aMw3TWtbdBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 15:07:56 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The mtier sample defines a local struct region_range using phys_addr_t
> instead of damon_addr_range which uses unsigned long.  Add a comment
> explaining the rationale: on 32-bit systems with more than 4GiB memory,
> phys_addr_t will be 64-bit while unsigned long is 32-bit.

Looks good to me.

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

