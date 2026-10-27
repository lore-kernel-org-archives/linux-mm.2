Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6874606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EDOo9TkX
Received: by kanga.kvack.org (Postfix)
	id B62226B06EA; Tue, 27 Oct 2026 08:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEBD56B06EC; Tue, 27 Oct 2026 08:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2A16B06ED; Tue, 27 Oct 2026 08:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 777F76B06EA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:14:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 133971C43C1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:14:39 +0000 (UTC)
X-FDA: 85368299478.29.699A51B
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 893B1140006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:14:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EDOo9TkX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2elqJi5kzHeKCGHmCgG7gHaV/IXQ0JiU4P+KhvVimy4=;
	b=qBvdjxF2wU1E3NbOX0lBQySxFZPryC3LnDRXfMh0b7OkRtZVSwMd9pKnakyEeLVrfJ/RnI
	+jKa2rWDvH4eQmdviTFf2AYwmQSV9DyEm82UNu6yiWoTUcrriqiTTMcHJIQG9EJeMrHG6P
	hSff1Pj8dB0SpfN/+9EvRQnY9oJoScE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EDOo9TkX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103276;
	b=gcfW+Yq47OlYUQ9rbttoQBKnH+ON3w+KweXHr2Xk02XT0Kr1PR+K5R2Gpk2WeQvMMNsJiw
	ojCniwmnquGFMvsZ75fh3HAkzNV9SuXFh3y40hSlM/LQN3kDVoB+6a7VAqnARKthedeNiv
	HVeicGS/0kq8hTimFQNslFVwdD1v3g0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793103271; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=2elqJi5kzHeKCGHmCgG7gHaV/IXQ0JiU4P+KhvVimy4=;
	b=EDOo9TkXslIvUQOe1kEfFGx8CFWpp/UYwjWEkfI+gMwRAV9I7YG4Z9BuxnPuHXQHkkFagyHyXq1M+bDBO9jd8LYE3Sr6nj+TSqweSasGcY43y+BMnbibmD/BWTcAsbRBvNZOoi4w+7uZcw379TF6ObqwXAS7birGlalCgXs17k0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDdogD._1793103258;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDdogD._1793103258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 20:14:28 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Tue, 27 Oct 2026 20:14:18 +0800
Message-ID: <20261027121418.1222887-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <87pkww7lnl.fsf@DESKTOP-5N7EMDA>
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com> <f28b2414-ff07-427c-8e18-e950b492b351@kernel.org> <87pkww7lnl.fsf@DESKTOP-5N7EMDA>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 893B1140006
X-Stat-Signature: oa4zt77brfqsh94h3hikfy9hid16tc5j
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103275-585265
X-HE-Meta: U2FsdGVkX1/ZeZ019EgeMaTNDl15Eq0jyCwrD6aRjjWf5hVjqjTKQzuwfkalxvFqe7YO8OSmGuIANWdDrLzdVJhbdKlq9e8Eiu1V1yHr1IWf4GWNj0zxxM83KmGGWQG7tVQnCAY3I642+Q7xJUd3kYf8CvwiiR6kn30HHO9kOMjxS2VxOEKuWDvPyI9ySJL0QUMvdai3OJNOtx70ScQq/Vt2Oigtw9GV7GqgreydbxFQzFLYExWxgVq1/kCW3wZ513Wj8qPtsJh94nVf3NbqMJusGnoZvMtsfnUy/P4sH4u0E7yPbcTrERxTxA28JN06WEumMHpr+Q1kxxqxuSuO4QG0BSTllIVyeo3wfz1pWCUfEgPS3GWuEggDTvhXqFt9X1YKQ5AxG9cwgWGHBAW+hZxHmp8Lh6667N5ITdKaZvfjo346+eo1dp2HUCJHd76MERnCmyxhVTgNjRGRSpAWWyY7UMmg9Ysm65PHzSbD/VPBUtdbrae9Tt+wyIFMBuk38zZk4LrN6yZa1XnnEJTIkzfxlnGnI3tAN58mOxh4g5dCA2GGDEYpPb4USF2jNQFM8rSo33uujbhqUQUqid5nttihlgrY6TUUsrr6GsdHeK6R1yVQbPlGmZ9I5QFP+3QCLe5xGopmMYB0Y9HW3Pvn875g6d73+4D8Hd2yneZLlacDDDU4TqAaL2efsGPlgrrFYrON0hgsOCbahDskOw/HEu5IMsnngRXxpyiC5SVcQKiOZcErct5X60Al+Q2KuXaCW8xdZZa/amoizY1+yhVS+fM7oGSD6NceODXLPmVqX1hZJLpPE0ANsec27h3gULUwmoOwNvqc+GdbsG+PzVFYwzAoYR1vhHAawuAicg8kHsgSnil0CL5tScVksXf7O7uLlcsHsLn/RDAr3H004gBV1DdOAHCVvtLtXXgttIoL0FOgWdsWJXV+wPJ9Ddo4iCzZ9RBTNN+HY1m0eSEHA3u
 f8PltK/U
 iJLeHxH6WeSYdM6DAWFfVK2JXE1aQU8qZL32uKXVzQwuNGeCGvq3RX/gO+gfoTBuHLwnL3ut/Pf/A+sea63WqrLtCFJUpxQlSkP8AbB+agzwZS+adlIjxyWSH1TAiBE2pxR5ZvBwzq0KM2RRbfvjqZUUQR2ZQQFxELSR8lQqEXRocfnoTEGw4r0LnLFb2ZAr2UsyRkCxzAZSxGr3C6rFDRt03GjpXbX43FXrcosS6ueni3bYofCZaax8hTChEGIuFQaU0/AbIfWLpkMVfwP/MqXa8QX10SV909bZf8RAD/MYzzreg5MfOk4yyYbHPg687HAtWZe8vVnpjXPedCRa5eZTSJVu6oWf4xFWa8PpjUA3JMJNeTOV1WVYuLXwP7ZUBM/dfj5+dtwW2IwV27l1gPpTr8TaJzk4DiM68eL0WK44qp6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 11:21, Huang, Ying wrote:
> Therefore, the primary value of this patch should be to reduce
> machine checks (and panics) during memory copies.  If so, we
> should place the check code before copying.

On the placement: agreed - the next version checks before the copy as
well, so data the flag already condemns is not read at all.  The
check after the copy stays: a flag landing between the check and the
copy would otherwise be missed, and since the DDR poison state is
sticky, a late flag reliably marks bad data while the destination
folio carries no marker.

On software-injected poison: it was our reproducer, but the state is
not debugfs-only.  Errors reported asynchronously (GHES et al.) set
PG_hwpoison with the data still readable, and a THP whose split fails
is left on the LRU flagged by design.

On the predicate: agreed, the next version checks
is_page_hwpoison(from) before and after the copy.

Performance numbers will follow with the next version.

-- 
Yuanhe

