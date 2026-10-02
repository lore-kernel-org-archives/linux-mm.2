Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3449BCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA2E6B0099; Fri,  2 Oct 2026 15:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4922A6B009B; Fri,  2 Oct 2026 15:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D00D6B009D; Fri,  2 Oct 2026 15:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4786B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:21:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A09EB40817
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:21:13 +0000 (UTC)
X-FDA: 85278654426.03.0AA53A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A87F1C0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:21:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovNnAyh3;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/eVKtwYx7bI64sChNrMU6bYG7D2qmY2Fz9of35KQJ0=;
	b=7jLV5FDN8tGmJ1HT9sch90NgGRPjc/0pXvmhX6i2VuuDS41g5pkjbCqd2gf7c6SmxuAmpX
	xck28UN24BusPbPpRsvvpNFMbFk3dV3kQ8dNKWqMKFs/7TWZPjsaCa9ksHGhQ/Ajj9FDYq
	HmbNvFSyjs+R7f2dN58u434HArc05bM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovNnAyh3;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968872;
	b=YLDYiqL8T9snEHRDldRmCfJlDnfTSA3CuTHFuV+sc5AKqOcGiIhCMNQsJhpEJXfX4CWvNG
	fKkhRLJ7186jryF83/3fchTzXeoYm73hjsmZt8wP5ub8LxiqbXGHJ2jeHDhfnl+rw7ypAA
	DiblDdlg9OeFMnSFusca9W/Q6ZPeUzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3B764143C;
	Fri,  2 Oct 2026 19:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1AB1F000FF;
	Fri,  2 Oct 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968870;
	bh=0/eVKtwYx7bI64sChNrMU6bYG7D2qmY2Fz9of35KQJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ovNnAyh346GWrvM/Pa4D7TmP57u88mdg15Owap9hy+bR+bDXlso3az5ZkBVUPJAmY
	 n5Om3CMG2tUjOwCbGeOJ0uEmXSDHNdUcT9bVOy7n+HOO5HeSntzsH+z4YO7ZjHc5SD
	 GYZixomL1Ko3ERKHrl13WDWj9+jwrf76p7RigkANmjR11oHZeN/fgPWf+9EwzAi3iq
	 IxCEnwkhqLfqBEm5Ph8gP08PdbjpIRobw8mr0hWSwtPnLMF50I8322MKexn9mxM9Q3
	 GV4zKxYpJ+Ck2xqV2XJyiUcqF1gziFjdxsRL0zRMmqVYP6aOfYYuCcPshShD3Gzm+B
	 Gky+ebnhMrl/Q==
Date: Fri, 02 Oct 2026 09:21:09 -1000
Message-ID: <94e7126416dd6407a46a857e5eaff36b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-1-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-1-8361eb8c65c6@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A87F1C0006
X-Stat-Signature: p5wfdgtw7uka3py1hxsgnt5h5oowhtd5
X-HE-Tag: 1790968871-255673
X-HE-Meta: U2FsdGVkX1+Ou4Hl8PCZcbYck6Knii4mjMnd9O+FkEW13UDgj3xAJFXeZOduelZP1MTT0onCwl8wovgCZDPvYbQVk1rywBLHDKR1XrTOMRdiNTYxwqHxNNqv026493REOgyWECJBubn3G3//2SxtogqXqvE7K5zn9Dx+zR2tsiZV+fLXgP4NEcASkz1mXvX1+Y6DrkJYg73cGDzvf2JKblVcaYdpJcK1z6biyru4qCqQwzwU2gapd6HUJtVcSvjFBdWMWcKajyAMXberJGIdlIKY0PBF5fMxFfUZ+w2nY/l1R30Fq3uJrnGTM0Td/Ekh+Byu4sB1CuVhqqrbXvsjHcUIw8n7ECTwD16+yrwwsQg6CBkMQVmsoYGpZfTOftDkD6Yns0GRnCLV/bi0/rOMIlSOjjAs3+ZxCBKFrdItuPlUx5lpvPhFYJH5cJnQ1VEuBES6U3kphASKlU+2NrlacZhAqO8a7hHIltMflnZkNegkpOOXla0L19aQ9HQDJPfMiqQghAaRXOryPr5ssM6RWKtbJZ7t5tZOW1dBgAR0swwEy1IjjZ5i3/xA7NdmzDQZPju7bh1QSc343D8BYf9NqoYJn+PObp+v6c8WyFgRr/A4mxNB/pkg0s+Sqo1nYO9acFF9Nu2qq6ieHIOTQ1wLWEN//C6nv3StisqDNwTyxj1e5r4vkwqXM21tm1R/ZoQv+z1gkUXe6I1A4NSWJdb9I71DvsLkOJgq+1Zp0eDzX3KaycP1LS+gRlKACKnuJl/r0LM7phigP0BdXeB/iIPEOcIg/4M88VImeirY8LeuOogxQd44B24V0z8WJjMGgRFWOgTr9p+N5rfUjyHL5TsqJfY00CTCTtorgJqKk4TRZ/gHZ6FhGSpg960ZheY6OFWlr0xreQyqOl3rA5uUyyZoQKU05hwldE4gNFADfJvLRFx7nbq2OrCycSvkZZJdF3Y5S2gYqSJDD5grd2I6SOU
 XOjOHMZQ
 ZGkp0lwmIoFJZOK6BmNkwsxHKt/JavXo+WSj/8ikJgbHTzVvluclCnONFrdOAP85pEE0Ip4GTvodOsA3Jcy2U5g+J8apBTD9EWcoXUC4T+UvMy+WPf2Kh5bubzCTz5Z0Mcr2YikymCb/Y6FK4FuHdzdirNF9CSKMiF/L6KISS7f1/23+KLORXTc4lfMNsQzeT7OBMEtt3KOqVVue9E3n1eVs6gR6k8PaXl3ZjDnW2wJ3pfSCOhRbwCpGLUydtlnq/w361uoouvULarRI4+3WZNf39sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:20PM +0000, Liz Fong-Jones wrote:
> Test: a later patch in this series switches all of a replaced cgwb's
> inodes, dirty ones included, to its successor. After that, with every
> writer stopped and the filesystem synced, BdiWriteBandwidth in
> /sys/kernel/debug/bdi/*/stats stayed at 411700 and 407820 kBps with
> b_dirty, b_io and b_more_io all empty, and the replaced wb was released
> with WB_has_dirty_io set. With this patch it read 0 kBps and the wb was
> released clean, in 3 of 3 runs.

Maybe trim this to a sentence?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun

