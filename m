Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81740C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B149000B9; Wed, 13 Aug 2025 13:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21109900088; Wed, 13 Aug 2025 13:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DE09000B9; Wed, 13 Aug 2025 13:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06F90900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:25:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF1C0160353
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:25:49 +0000 (UTC)
X-FDA: 83772411618.21.6E9F0B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D7501A000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:25:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rBS1uXBU;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755105948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KQZ39Q3wO8GiDp6G+ziKR4q1R4qilKL7ERh0Bls7+g=;
	b=zXjDHMxyoGHPxUkfIWrG89XSLexo2M0/Wb2j24hMoC1giFM4BLODv7+ez0yXwppEMdUwBM
	9Yci0G5KD3c5cGfuT0BsHP2x3adThJls35IEtL6xAUcZ9+umZSNgSKYE+FqMl1S/rRBV4b
	jDOwR5wIVbzGuYoy2k6844CNr2Q1hGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rBS1uXBU;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755105948; a=rsa-sha256;
	cv=none;
	b=kvfEc5njr3+nQkGaGMbfxYB3197tQhjAUxw3UDzyhFhqWnXOBg96MbTtUT9TcHYJNvXBAo
	ggjAHnwhnX0PY4mB13mr29L91zBo1QU3VrFG+ZEvoisIGyylraENPZWXFsjHk4t64S/2Va
	WyTF8QqrDfxDj0gF7+mvS9Op54QOcaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28FE645519;
	Wed, 13 Aug 2025 17:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80EBC4CEEB;
	Wed, 13 Aug 2025 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755105947;
	bh=4aNIc6qJ6FVdXPxb4E9sU6AHjxI92V/pZbXVp0oNi9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBS1uXBUhu/Q49xDBRa0s1zIPcKW6a3bcsI86ceM0ZWhsIeGsFUvw4ghoyLszFEBb
	 vzLqq/qOJ6lo3TZ6XSQb4XpwA3nYunWoa1AJOmTe42c2bGDJQ5cf83uC7zsgXBbR2N
	 vG3xGXKheZhniDaqdBWQW+Cq/3SjiBM3ttF8TsN7NbX4sMLGNlGgvRJz96uKO6BYxO
	 Ojlet5X6j4Bfl8RkhAW/iK0K22nUCpqzD6SGhAja8xBkwdctyyyA8ZR5QTFu0+nUGv
	 ua5/9lFJNPaTJ5e4HK9U0mNoK3pvOG7zzuqxOGixtg431j0SfpvW0EhnfvHckmkwi7
	 HUJUvB7MUmMpw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
Date: Wed, 13 Aug 2025 10:25:44 -0700
Message-Id: <20250813172545.6637-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4hctyxhdq4jk3sc1qnoa95oo6iox1tft
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D7501A000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755105947-307392
X-HE-Meta: U2FsdGVkX18Lp7Us7VFyyBFYJ+8JtgXerxqJBujkueE7VoafraOFXuK6f1HYz6jQx900VTePJMgGQfyrPnMB2kSFzMOKtM4WzdLQDlanmXi6U33WkRFFnxVzTgCmev5a5KIgADigJKL6VcWeN0BU8F0eTeFfjpeNseS/zdkgjc9AoUhdqur46U9mirspA6ZU8b0SpdEgJVa0Zr0XNxr7QP1f0UFr+VNQ89KB7FweBbcSzeoTQNEckcX3zvcjBE/rIfBxTLH2z6GQt3GpvQ/SB8DOl1IqMz2o0tIlptIihaNKi4/qAOcAhWiVPIDwfpCRssVasuf7bUAUsuJxts7Ez+lwziU2R9PpnQQwyHAEre+YBD/2nAYxs3rb9naBbyzOSB8aJS0rtOrTu4E/mv/tN2+X05iFR1qM+Dg5ZWzGkND+yBLZJr9ng3OYDv9iLK0ZWu1SW+pPC8CnMxKhWLPC4ki/ML0IdZcLO8DgZ+a2M0D+xrxixyAzexg9Q9M8/PDnaYtj47fg9XpfzpkmW3S/4qNijK1fmAGQVhw3Xq6dp7WCW4abde/JZ0qWkR6PCfeylq7RMZqgdORGba0xrm+BsTERxD2sFPbJBNYaBnVvws8ALMa/K/ZH6E9ekvCqcxFiib3HyeXAii3EKmm24lcvNZPwEMi5Q+Anx9nQMVxnxQ38229JDLTJo2q6dK4KbtaIjQ+tRtl1qCQsEZQEL2r8MkwjcPM7z65lJ8sEQPxxtHWupIluMe8oDGPOB4pk2024WLzZZhB28VVHWZ4kM1+iGr5sLVzWduHG48Liz9mOnGfIXn6jKXkL2mxkimIL0ChDgwwOW3qigSYg01XtKawmKzPeX0W9CSSYPLv7tPbOFekRj51HvgNejo7ZfG21+E8u9VQrTl2IxJd+1eZaHr9u1ZFmXIUBmA3+mV9AoqVwCzEB0IDjZzPuQKuOPHToL17mnZO7FyiYUpi9CcJzA/o
 imz5OB2d
 IJyBgV5Ng5OseYAqt75cuJr6ZfNGvwUEPTIseh0B0RZmqBXYSRfKKo+/qUcMnsSejWiyu0mFyNNmo3SZ17NcKvB1EgJnXDCYvYgDySuAM69ldKMa4dX1gFGtKTl8IrXMGuXQ5UAokwWakkf/fveiZwhVHeoTMWnDsRUMP46q1Fj4ATph23ePSLVlxNpoVRkrp0W6Vs+DGgde6nDDBGlQoigzaek505FXCF/eWatO+J0jfJtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Quanmin,

On Wed, 13 Aug 2025 13:06:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Previously, DAMON's physical address space monitoring only supported
> memory ranges below 4GB on LPAE-enabled systems. This was due to
> the use of 'unsigned long' in 'struct damon_addr_range', which is
> 32-bit on ARM32 even with LPAE enabled.
> 
> Implements DAMON compatibility for ARM32 with LPAE enabled.

Thank you for working on this, Quanmin!

> 
> Patches 01/16 through 10/16 are from the mailing list[1], add a new core
> layer parameter called 'addr_unit'. Operations set layer can translate a
> core layer address to the real address by multiplying the parameter value
> to the core layer address.
> 
> Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
> various issues introduced by the addr_unit implementation.
> 
> Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.

Overall, looks good to me.  I have a few change requests including below major
ones, though.

First, let's squash patches for fixing problems made with patches 1-10 into
patches 1-10.  If you don't mind, I will post RFC v2 of those so that you can
pick into your series.

Second, let's keep DAMOS stats in 'unsigned long' type.  This require fixups of
patches 1-10.  If you don't mind, I will also do this in RFC v2 of those.

Please let me know what do you think.

I left a few more comments to patches, let's discuss on the replies.


Thanks,
SJ

[...]

