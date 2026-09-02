Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C660C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595CC6B00E0; Wed,  2 Sep 2026 10:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546696B00E2; Wed,  2 Sep 2026 10:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DC66B00E3; Wed,  2 Sep 2026 10:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F30C6B00E0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:48:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B036C1A0217
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:48:13 +0000 (UTC)
X-FDA: 85169102466.18.CD56CD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F7B51C0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:48:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AyikNhCw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUXYVCmWjiQeTz/NFKBu4Y1w5fCojC14Ox7jlQ0n8OA=;
	b=UdpCZ3Pbdb/pnHkMWLY5p4YT9VJxNaZ3Qx53NR5TmUjEmJ37QfeAV2wrfhfTjitE1Q4H7e
	UYM6rGuGBHCDUS0A7mSkcY4lbjizGfmv5ytwvO58y2tVJs8ksj5dl6zJlfgGTWabyliCS7
	pafQzQcVwKQMJT7RArRNODqeSWLEO8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788360492;
	b=kVGfF3nUTtimSlhXBbxZCslKwaYi8JCxdCALnZlJklSew7qMAxtNXFLhQy/hCn0RsmF+4m
	Q+kXVVoWhk/qAFNYAdGQBZJ5mzMVkZ8pdLRf91VfjQjEwaweUPTkcmSV3dWodjeZvHwujj
	oRT8TeFjh4rTxvtZehmAa9yj//aQdU4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AyikNhCw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46897429F3;
	Wed,  2 Sep 2026 14:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A321F000E9;
	Wed,  2 Sep 2026 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788360491;
	bh=kUXYVCmWjiQeTz/NFKBu4Y1w5fCojC14Ox7jlQ0n8OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyikNhCwZna5smqbj0GVWcCnGjutXLJmM9MvlPkDkDB9JJo/kn3io4tTvDe5tXMxW
	 ZUJjlFamPUPfGq2Lmn76ybrIYQPDL4mzZUKVZjfcXGiJEJbIuTGjxD4BsugydnjM82
	 SYjbRfQXN+jByOKT3dN4kPhNrpx16KMLuEcCraBX3USkGOdvW9ZjV4wMzsktiY4DnE
	 AzKko6VpADJ/YxX9/Lt+miy8YUFTjr9S/9QiCfYgStVLF53EtKXZC5nqHQKwklqp4g
	 bDrDAPVc3LDJhQFcLdo/P3TnXopCbzVm1mlLKaifWc/rSGrOrBVgIjA9vyUz324zx3
	 XvksGDML0s4Wg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Wed,  2 Sep 2026 07:48:03 -0700
Message-ID: <20260902144804.88298-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902142254.5328-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c1r6cj8t91xx3qcd1a47kzgxsa8uqe86
X-Rspamd-Queue-Id: 1F7B51C0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788360491-806978
X-HE-Meta: U2FsdGVkX199i7M4omSp++nlhLJLRoEGrUFONnzjYdc5kICnCWF9I/TtSrjm+ZIi14KWkLD9pjDOXekxNCFscxcZutfYYWOkD5LHe4mUD9YYvuf1xnllfsOOBQtlwc33KVFIhlonhkaWxwnKbz4rUeHVCU4bJK9xAigBZLFZ0Ya86YLmXJTYkOPSymO77vG37BwKDimKCil+pYJJyabLITJ6RRXYAf8QV3IAKhOqJrFRcF+WSqoHPo5h0G+XqqQ03aUEJSFLUmkTZ0WA67dLjwxTF7PYBf7G6c0I6wNRwccP+X7YT8R/Gc/Z1qabDtWVBvNJAQhEShVB8dIFOz1yfvXgPyIRdcME/Af0no3vrY7IEp7mJ3HsgLJSmNEvKSlA2kI9+h78scwGxI4mLIwYkmArEX4WQ9Wu2ww1odGJl26qm0WAjO2UehuULG+5DxU5JBLG2xQpkCPi+uD2eD065edwXTNCXuHpbMh3/8iizWKJhv8XZh1XWiZoktqtZZ5CZUEgCMJNNxFaXfPWD3WEVNr+dMChYPs4pfTKPlVvbFtIS2MmsF8b6flcNx1Thg6NEnW9AurjuESHQIYPxbUkX5zBS777hZRy9E3mVb0vq56TpiMjNg1v3rjowpV9MPzn3xf8mih5RNFBCys/TzUwq/ZHUuGPBTE0Mqn74bWQhMSslcXWCi6blLj39M+VXl3IY1jCeB3tfGa+RVgDOKQyZV5EhhsvoBubhkKHtrpy38Aw/+lb64XUi1ZkZJrB0QuTkR4cRRJDZAxwZTuXv84Am2iJSt6DFtahgqvOqcGJEKXH7L7MFyP6JeXW6UZPpJiS0Ze7xiIj0JBzlP//Rt+LnjiU5c+1CzFwQB9a4WJ5pTXsHyc1oqFNab1goo+oVosHr8ox+GDNWZJQDOmhH0Gz0dwjSxKo+fK/hi0RICdv8YkgYdDvB/3EKg0O8pEpuz/9yTjCuWyYclqs2oeGUGg
 VUAyc0AC
 S5MTKdYdSDtBg/uaOLPG95tUns1XjcKeUNj89pjYuBjvL2zaXRlgaj/SqkQ58yg5oXCmsKY7WDgJhb9vA9EhgMODZh+/kqaN/tjMWO5enrpsDc1o0obLMiWX+0t8p9+vjv20aqXevk7oPynvM6CQUs8jWd/wNuJ717f3JUkE+iKYezMqOlj+GRRsY285v0zgye2Qbh/zJIKOSWYceJYt82wqYCJRUYxmfuDMirks3ykqOMMx0npD9J1kcgP9ekbxK2dJxc2XXgnIXMHICdQYSsm57hKefGpPJ4jsXMePMHgoUvEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 22:22:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Wed, 02 Sep 2026 07:10:00 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > When setting goal_tuner to 'temporal', if the goal is achieved,
> > > quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> > > will always return true, even if no regions have been tried to apply at
> > > all.  This causes qt_exceeds to increase unexpectedly.
> > 
> > To me, this looks logically correct.  Could this cause any user issue?
> 
> Yes, I think this might cause unnecessary confusion for users,

If it is _might_ kind thing, please ask questions first, or add RFC tag at
least.

> at least
> it did for me.

If it confused you, definitely we need to fix it.  But if it is just confusing,
let's try to clarify by adding documentation, rather than changing existing
behaviors.

I feel like we also found similar case that people send patches to change some
behaviors that confusing them, but not really problematic.  That sometimes
waste unnecessary time for understanding the intention of the patch.  Please
feel free to ask question first, if you found some confusing behaviors and
don't know why it behaves in the way or if it is a real problem.


Thanks,
SJ

[...]

