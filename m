Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74B8C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02236B00B6; Thu,  3 Sep 2026 09:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2736B00B8; Thu,  3 Sep 2026 09:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1D66B00B9; Thu,  3 Sep 2026 09:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA58D6B00B6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:51:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F43AC038F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:51:35 +0000 (UTC)
X-FDA: 85172588550.06.4181D95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8738714000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:51:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI4ZfLtx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwn+e7XYFkZ2YAWRETWCdW/iWdxBQOPcNHMzT3rsYDo=;
	b=1urK9OJm+We+9aRiZsrI2HSYum7SVagTs3V9SnSm0cJbzgYDblwqrLSXFxkBSIHBvVDVxU
	6DOIEH5+BDLq32xDuEw5qZheew3V52ZgUnLu5fvq9Ea5drmEGk1uzhDv0d8reS2TJ30xpR
	/WGh1BgHMZOakaHqrTxbJ2kYTb9Fazw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI4ZfLtx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443493;
	b=uAYrGUNAepSf/LzzzkPofluDV0uhf2eEc319fYRkUnA5wgnnAf3ZWvkEugnVVg+aVyMtwF
	NQvOeJbA1kRkBzUOP4+MtSTkHY9bEv0SQSFJZ//+bxcQawNCl3F3XjHuE7C+M1ijJTpIvh
	E3hAt0ilU5ywLMhNpS1+xreO4k4eFdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 905BE415AD;
	Thu,  3 Sep 2026 13:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8481F00AC4;
	Thu,  3 Sep 2026 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443492;
	bh=wwn+e7XYFkZ2YAWRETWCdW/iWdxBQOPcNHMzT3rsYDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VI4ZfLtxMcJNWHtm0wcwWDXgJgZzfNxCwxI9IO9vDJNLh0Twh0damukA1JtIipw6E
	 ZKOIFVAisNr1e3MRfEXV1OfrbaecwgayHobdHwSl8FYxKX1Cz1nMWmUIOyTgevolZr
	 89+CshcRRQl1Ncp4IeqHF6iRBXBqYJAlCz5QNCO98saaPMNwDBgIwwEHKK2skaFih9
	 POnfEHQ09qtF1fLeiIbWiKHpQ2+7xNpf1d2r1BWgp+yoDkIKPFNblENtQ8Gvr1O72E
	 CywAHgqdv67tS9MPgQQYYfFAPQP26nu+rNUpepwrx3RU3RbN60xFwM/L4i4Xj2lrIn
	 /85OQHGPBfEag==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Thu,  3 Sep 2026 06:51:19 -0700
Message-ID: <20260903135120.98408-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903031345.82679-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8738714000E
X-Stat-Signature: c5rz7x4a8izthket8x33nf3y8yy8cu3o
X-Rspam-User: 
X-HE-Tag: 1788443493-20307
X-HE-Meta: U2FsdGVkX1/eA0XGLfNLc67tk+ZiXogNV6rpNZSpWikGSi7L48lt9FySA8M+LNxFvHECXz+2sfNYZBIt2kEPu+nT4+EJPQIuI+5Z5YDBwN58UsB60UQzv6g0nDQGYrzBs9i0Pu1juZlUJerVzYYZ7L8xrWqF+szHoXd9F2vtP7AjFZJNdzykYAqZrJNFeId+dEE9CUxDOFxO4qqpboTv1euWPw3oU5ShM22mD2oYsWrjFp6ey3FoncWmPW6v8fr+TlxqFLVbeTggAclsXnL2Z3TWgaPTJlV2CLYW4xXTQAqaSP4RGZfXuT4HyIRbG2UnS+YCkXtZdeZxvOMuiXhDKlZM0dLtBtbChiWRrTuzDiaU2bK3UhasnQDgoVlKaI9hiWli9FxrC8fGmaJ3vfBCBT0+r95N2LnHkEG33qOQdu7HHi6cpzCmX8PtPvZLYkn+cQBcYR0soW14R2JDuGQMnJGSU/Z90k69p/Qz62Yy/uPN22rDoX1Wjw3/H7O6vxCyPlMGV2xNSitOKjVI0wUju7NecQf5Wu5IPhMubV/VBS86c4BuOm5VKxGpIv5926h8glu7ZUUsSjnB+UAhIXaLX9dS9WTnhtIZhlhk6aYX6IObKJhJVodB8QTYFKGHaubButhELR+O2AB4sC+QrJJrGdghShWBw9vDVrX7j5YwPFSRrPJdhfESR0MJjp+AXdur12PSYzH5Ba+YvK5pD232G3N3NEcV+CU3quuYULOlD0+yZ0CgdaazMd6Q4ui2PR75swimFVrL9W6g80rXQb5RhviUS6kh2a6z8werz+OHfQXvaZ9MDTj+gZG+p2sFUh7fA1wFrrY11XF/xnvzvrqGxpuZRVKF8blpFJ9c4oxR1S2s82T0sryBhCA2ongt3sAptR2oPju0m6YH1eTQ36IGuMmg8xKPqv2iJfHTcyXzUv1tsCNJntvU/qyZsuh1ltYVxXJwHOtl0Tkcz9/3eJW
 E9pC92Cw
 XIbV84U5vUABde3R7qMeWU60qFqyTLgODVn+Ddl9Z3CPN0HPpTpWmorv1lrxbqaz+Vn1wi7V2MQlYZ4PnrfwBLdft4bXWkjkQ2GOfCXk03GCadWlbzBMrAhls1HUXlqdMKt/fx2RKyewS8cHDHY4akQuJIYlydk3HPYz/SCIZL0QMlutjAdVsTpE1WkYUDeVl5q1C4l3jdrSUQx62NIq+wbA3wTtKcQTlCMWqpD4sPhh25DnJEiXMdbSX2MCK54D54D0ZR/6HJETMPz3Ivm8wyMjNn1TTTkKHRKqhFTVSkas9BLQ5ZdABDSNrYrG7oMPr/onPkb8yZOtNe7XKgoYHmHl1kYkgT8+v8j7ImU/LwVrjIko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 11:13:28 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> > Patch 1 fixes the DAMOS quota goals commit unit test to cover a
> > mistakenly uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI
> > goal initialization and eligible_mem_bp online commit, respectively.
> > Patch 4 fixes the bug in DAMON sysfs refresh_ms file handling.
> 
> I reviewed and tested the integrated four-patch series in mm-new:
> 
>   a20e38846efb..72dc8fdaae62
> 
> The integrated commits had stable patch-ids matching the posted patches.
> DAMON KUnit passed 42/42 tests.  I also ran test-only eligible_mem_bp nid and
> two-kdamond refresh-isolation regression cases; they passed 42/42 and 43/43
> tests, respectively.  Both test-only changes were then removed and the
> worktree returned clean at the unchanged series tip.
> 
> These were functional UML KUnit tests.  The fixes look good to me.
> 
> For the series:
> 
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Tested-by: Lian Wang <lianux.mm@gmail.com>

Thank you for your review and test, Lian!


Thanks,
SJ

[...]

