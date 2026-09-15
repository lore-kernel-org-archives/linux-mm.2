Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159EDC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AAD6B0088; Tue, 15 Sep 2026 11:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC156B0093; Tue, 15 Sep 2026 11:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229DB6B0095; Tue, 15 Sep 2026 11:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014806B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:05:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D99A91C25D1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:05:10 +0000 (UTC)
X-FDA: 85216319580.19.831556C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4CF4F140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:05:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTYQz+4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTYQz+4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484709;
	b=4YUE8/FSvkyMivr3Pakraq9Jk98pML/vwlAcGHHoJN2pEur+i7szOXpr6uJ1lLfbm6xy4y
	XuiXNedDcrSO5vPk1+rHeljtfBzHIMNkrZtWxtmnj6xSNI3tulVq3ovG40MkxduVzBj8bS
	W70jVK9SXOYWIDt2pLrnwh5Brr2P+gI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvY16KjcBiMArLy1iqWzVK3IRsX2lFN4G+miq/VqWjc=;
	b=cGClHwcvKndZEXXiLAq5Nt9puboH5SCPC7Yaae5z7jbJFFhAEK849EaehVzFGgrLPvrakn
	ODM/7Lm7XCWU0yAGtXu1+FIPx7gEWBPDGSkBRXrHdj+3vASK3DZmB5q35X9JSLSRZGyrYv
	AdcGA/meGNY//T7L+WbY+qp5jSHL8ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72C504150E;
	Tue, 15 Sep 2026 15:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2627B1F000FF;
	Tue, 15 Sep 2026 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484708;
	bh=mvY16KjcBiMArLy1iqWzVK3IRsX2lFN4G+miq/VqWjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTYQz+4sfDZQOxuxOs73OxykKi+NVW9swaQzxugs3lGVhAv6XnZ2+6ysW90CQMjFV
	 ocqXxiGWBx2KOO7h/4ST3SG47IeSVDu4QrAjuw6ie1A6wY5a6ZHVUwDz/az5X92a4n
	 HC0aXiwVmtAzXyy5FjuEoh89eJAv1+x4Ytb1TNx8gcsJnPuhsl1Ih0TJkHGI2gQ3yU
	 PO7+UEx+mjzP6zXNDljq6dpxF+jx5g/zWXFFHJIM5etu2OYmJ1wqxpgfalltDXGQtt
	 Rjy307DEA8I5og88N9dwrokYU5tIdvQKJXDgiidKRM5E69Se1cGCd9ddE0YfnCNlCZ
	 3bGM5b5KCrmlQ==
From: SJ Park <sj@kernel.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/sysfs: propagate damon_call() error in turn_damon_on
Date: Tue, 15 Sep 2026 08:05:00 -0700
Message-ID: <20260915150501.95021-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915093928.3389096-1-wangxuewen@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CF4F140007
X-Stat-Signature: c78yq6sqx5jg4wt5txnfbdwpyndgdzyf
X-Rspamd-Server: rspam01
X-HE-Tag: 1789484709-365680
X-HE-Meta: U2FsdGVkX1+vA8Xt1qlhpaMJqNUqVWNDYQe+2eFlaer5wrZ5brBuSkgH644V7L3sU4A2rGTiI/1c/m9EmKz+WHgwUi4GDjpf2ox9+PJBPuSbZSvIYDbrbNYQNWyptkYWSyhq/oN17/GoHINhwlyR/h4QEpXTEWiPJLcvAjrF6+H9CFsY/cfa1b1mtSK7LDmHZUWa2mlNK8UhdcSBWKjj1P8VnH0aTsHgrdUv7S5wr+BpnZCH9eaDPFlFBlTRrH+ENDuJcU95EDLw3rpvH+rw4j2KkmxwrU1zEgPGV0A3/AmdXhqAAHLBphc8pDYy8Gxy+QmlOgR5fgasR4Ogv07qEd/YVJD0Z02T74npxdEisG/FpRtsmhji1O4eySK/hJdphQqSOAlI9oCfCTR1hteGqhfyUBrBu3NNxQIB74YMjypBsppWerjchcUFZpo+3UsrgLdlZGhTrsAYIYdtG5MOYu+3cWv8XnMcR0Wqe3PNK6M3BAyO9oLmiyuzOuum3i/H0l52nocMCXt7ie0IpjHy/+MM2qzkSWqq2RpUwpX8VWCh2Syl7SG9YgyBMWvjrpR/qNM14eIHFdcR9OK3BsMCf3Z4bmpYXwE5b1GvlmmdKO3A9UeBASzrget+qusfmXdEQZCv0gH8BxAT1L8lpZw2y2McD5637LfS4XabZ4kMmIwQmpWWuNEyMeggumZKNS4vxvhw+y9IYa7YTepeNkRS11dezW4GsXSFR19g55FZvPUeXTkbPoogoYjtJ2HCvW3N/sixdMHNxNsUTvl1sBCcD8FV20+tqtrrDClQ8DcytWcehlknfevfrRW+qYCxmI1Vd87M0Z6sLAws3uHvldR+uDJ1ulO/8qN5AwJV20QVwlg+jPZw58wkADLtPRQKuHj3NZvZCNm1ZAv5yUAGqnf5EED2YAYsS5MXKEJ4tC3H1m7KpmBG22wOy3dU/Oaayt3DyK2GRYA9fzsXBBRd5nb
 4klc2Ogk
 vQE1fEUbaBvMfTsiEE1igZhkZuWmmrpEhPRbL1MFflfNjbekT2MHNR1EF9l4yVJOy3ZTX1cIxL+AnpS4JeG3kKXODZ2GPGdulqEVMhU/I5/wZunhjNnMFJ5xoGen+RvtZrOhgeup/euSKdkY7UAxdxrHtER1Rf4pdqSOnnnlyIVgN1egfAlF384efZqFa0AnZyADu8V6SGAV+ekI/xYKOPnEmIPoEtYFaRbRUpzOApDl2lfO8dAUhH+FCxLFjDwFN595UjALbWjcwjdCXKi9DNzDYWCort0aS/QZDbdZjixw8HI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 17:39:28 +0800 Xuewen Wang <wangxuewen@kylinos.cn> wrote:

> damon_sysfs_turn_damon_on() ignored the return value of damon_call()
> for the repeat call control registration and always returned the stale
> result of damon_start() (0 at that point). When damon_call() fails,
> e.g., the kdamond is already exiting, the user still gets success from
> the state file write while monitoring is not actually on.
> 
> Save and return the damon_call() result instead. No rollback of
> damon_start() is needed since a failed damon_call() guarantees the
> context is stopped.

Nice catch, thank you for fixing this!
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

