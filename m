Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF73DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C047B6B00B6; Wed, 22 Jul 2026 20:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5606B00B8; Wed, 22 Jul 2026 20:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8776B00B9; Wed, 22 Jul 2026 20:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2896B00B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:29:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1871680300
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:29:07 +0000 (UTC)
X-FDA: 85018156734.25.7B3488F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 78CFA20003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:29:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC8q84n8;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784766545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1klxc6MvqPDoBZg4y3VrtQPMZwyGIj+K0awBUjVudaE=;
	b=Qum8U/HSTmiqHMEslxaLHN/rgEylLzVTxDB780JjwuiZ/O/XTmQuLjQW/iHGLeM0uWZHXz
	vPV/n2QRCzVFSNkprX8D8lASGwOTotTxq57u1O7ZcJkXaKJOS06FvP0F0ZNfTYNSSwqVWd
	+dxkP2BJDE7nzPuZyuSS53BdS9iUd40=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC8q84n8;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784766545;
	b=57+oy2giIu2WEmOjrd/2jy5RQfeiHM7sy+BTV30FxCF6D/H/wFYPDznGQKdi2Fa4OnZJ7/
	Ihg+irXr9WUVDqCvZ/uBaQKCnxu+PTyA7i4VRd7JLTlw7LY6EYJp7QbKZoc0pz1hKsW3Nn
	7rmolFCEJVw9FA2GtbTWua8DC+FwpTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA4EF40A65;
	Thu, 23 Jul 2026 00:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D881F000E9;
	Thu, 23 Jul 2026 00:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766544;
	bh=1klxc6MvqPDoBZg4y3VrtQPMZwyGIj+K0awBUjVudaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZC8q84n8D4cCcVWG3ruQNYAZ7wB4HufMgOv7fxYaxFk+zpOeHFLglfBdflUnHM4Lg
	 WUQvodDRWuxeg7x7gM2TWHfWy7jb8HLLPIfp6L86W4p+4U+O83Fm7kdg1qfkegt6Pt
	 4s4jQWkp2iE7hHlnK8LHyfBXP5q6kdr0VQe8jS28EflHpsfCQF75bnuaYXHN2Bqoj4
	 nB9QlYSyMHVv3bZJwY6TqMha/WvcJEPulzKaEiXawP4xrrVYYhqQGPZ1tStNlk+omX
	 hvsI7OOV2C6sUZwCJ0/1nZM+Q/M28/rEM7uoTsU0i8obhMw18PNZuq3ysxfUns2bic
	 mVAmeLyzSZz0w==
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
Date: Wed, 22 Jul 2026 17:28:56 -0700
Message-ID: <20260723002857.96284-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1d91aa7f-1601-4cd9-8ef5-8599983bc42f@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78CFA20003
X-Rspam-User: 
X-Stat-Signature: 63sa5m4jgw7uin9zp6bwhw8uyjsep4dj
X-Rspamd-Server: rspam04
X-HE-Tag: 1784766545-89686
X-HE-Meta: U2FsdGVkX19kL6HQlY+SgdLNtBZVUpKW1CKMf5+2O7GswSmuTYwaOC6PBw9Q7DUDvapnurmuj6R9gJdVUEgZDyayryj5/JeTxNBzGr+BYkacP0fkGLx5HWts5v/VZPeaZBSi5lPXlwKYMC+kXdt8BxyqtbTunNq0qR+ZUbLoFhrQZn5KqMT91QxOrSS0w8slv/f+o99Qt+qnbx0xdYLgx6xKHAwWIqwOlDLnVcWXd7eI965Quzv2evzs9z3pXwBMxQYS1ociFJbIqu/X+EIxfBabQ9n57qSsOhc380G2WIdLRjxazgIUtjl/7A6QkZjF7XStrBz3YNBf9bEX/xZ4j2UYkurQ5QGvPQBFDH7xzVEO40T2/O6ihc+jVxyamYu5ZTfjRdEIfM4B+9m+S5Q7P5qLo+n1lkFzL4T9+vzZ0pr1LtE79RoXthqnrLDdMPxEjkZ/9taETZcPbrw6fbTwLlEA6TlUOHth0PfoMgzAhwN2wNta23nuHlDz6i2SP6WS4rHB0YrT+gBXKrfLjlE+uCUqduMQk5jKd+wCqZxExltbb2DERH7Cdircu4sSmjKgkcgFnLEAM21MMF0VTMYkyNzd9eNh76MAPyKeQexR+bXVFVmB1Y2A+Ize2bPfe3OZmPNbwn/FFpGCKSuOXNFmrfWqvxC2TEgOARdYRzHhLr03DuYo353KqYgbV208thoY7ck3wFn+Mq7fzxKolo8uvSxbFOLQOjO3n4LA4BsXBgZ9yRg6aPkLflM/8K64GkbOo0gZ7uQaNGluQowHSnVVmxMgMzTtA4kb+9dZvpJyRQy8FcQr20smabHKyltJXIgn1mW2HSrcaNARtMuZxAU7QNeWIV2LW55tLyb9h/SuKEN1tiBeA48k4vR0Yf8H9Lbf7ieGfCgN2Jp3HGy989p0bWeTJ96ealaJIejhij7LqiPbYFtroCB0iTVXZWMdBelGeNUnuHnonNm6Mn3AwOc
 kjNREImW
 jbNZ8uoNLzF6LDWn6aBnqcTu84VRDbtUovn2W0HstaRmeHNqMlrTCDyecvSPkdhf7i9dekkxk6owHomRroB77g8QESHxexvpjlyyLcJZB5Mi21l6EK0IaIYJt3ncvaiTv7pOnoQKf2t32auw2mzSJ8NjZrXBwrTJg6toLPA17IWlIKDWwcouczMfziQY67T3sEzbQF5Nu346FIoGBVxJPFZEFrM9jeYP+ZjdgAY7hHu1bL2T3AMk/40ZrhQHCSp4xys1ySBsVOI1Au1nqoFxyF80SnGp9hDMYGcOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 16:51:22 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 7/22/2026 4:45 PM, SJ Park wrote:
[...]
> > We (mm community) now want to focus on making mm.git more stabilized and
> > therefore ready for the next merge window, rather than adding more changes that
> > are not really urgent.  I agree and want to help [1] that.  For the reason,
> > unless Andre pick this first, I will request adding this to mm.git only after
> > next -rc1 release.  Let me know if you think this is really urgent.
> > 
> > [1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> No problem at all. I am fine with it.

Thank you for confirming, Asier!


Thanks,
SJ

[...]

