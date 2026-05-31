Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007C1CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1991F6B0150; Sun, 31 May 2026 12:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171116B0152; Sun, 31 May 2026 12:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE736B0153; Sun, 31 May 2026 12:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F209D6B0150
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:36:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B746A8ED2B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:36:17 +0000 (UTC)
X-FDA: 84828267594.27.9BF1DD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CCCA1C0009
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:36:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEbwjG3Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780245376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDD6tD/6kl7HLKjD6lcvgrwFf3qY0h09b+OnpA83jp0=;
	b=OlBtcgRzMKqfgKGY+jtxEoNUBMoWac2tvrh9DsgNKSAFZSQUwZMzgQQiPaxVJlOOwfTuTo
	gShQ1lK9i1sfiSUZl2XfBoMZ5bMZES/oZcO7K4tQrEZZftgSIl633MZb10JvKYUK8Iqyan
	2qqQabT2CE1kbsAipA8MXzNWhPn2A8M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEbwjG3Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780245376; a=rsa-sha256;
	cv=none;
	b=DL1HuJ3VwHMHJLUqLbMXM7Y6tJX+KS0wxVfwv0LCALjvzvRw3MO6dqa7mU2eXYUrVU+tvs
	LFFVce5hkEOwxalsPBSJVCh7wATShWysvsqHsLilz+WBJgQSr0KFdiHSCGoNi8gesJoMW1
	sB/KESZJY8XRDR7NsCoa0zq5bx96lWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7915C6008A;
	Sun, 31 May 2026 16:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D40F1F00893;
	Sun, 31 May 2026 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780245375;
	bh=SDD6tD/6kl7HLKjD6lcvgrwFf3qY0h09b+OnpA83jp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEbwjG3YtCqiGX66HJp9b9X1dSeLuVMEnPhmiHWOPmET15hr3rreAYsinTBYl+VWO
	 udjp+Rraex35LS3OSuE1jQNLQkp5DFni2CmwrMp1iwOBaQIO2XGR5Sfp8C6x5fbYp8
	 3/0ZBvI9XhdsnYkTtXS6QYEM8wmbau+tyuVf6kgi4nExomjUqXUbKkbbAn1t0YMiws
	 TtPTUi1+emVG5BtjWXC4xxGXVQEHlnrCUEE3YqnoxwgvYPrSjj/Xex9mLvRWyTlOUo
	 kfSOt/EA/PJWA9CwwrflSahxgiK4O93B55nwHZJXkg4cYCwvBvR7DWkNOXSw/YqpaB
	 ipOBmL+Vmthdw==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Cheng Nie <niecheng1@uniontech.com>
Subject: Re: [PATCH 2/5] selftests/damon: fix memcg filter path handling
Date: Sun, 31 May 2026 09:36:06 -0700
Message-ID: <20260531163607.99063-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531091724.84381-2-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kcckrxxicxitee6q83knrf8nkebnpq33
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CCCA1C0009
X-Rspam-User: 
X-HE-Tag: 1780245376-586866
X-HE-Meta: U2FsdGVkX1/HPXUhxI6bpLDhLpWoJoUIqVeQt3CkkuW5tv26K54OeraZRQIqO+foBCk8Db0OQN4yw7pHWs8BeXLPIh2Fr8QVC2w1A3Uf5Kr4bG4PBougXefPlc9US08m9j1snKhYC/XAbtVJLrqfAj3Q8LEDFz13DQ8BDL2pJZS3LWzWmLRhtT97j7VkVbuEu2CCW9J1eGljnzyK9OcrjjMDeHD1rlo+6QFIh6lOzTJMPAoRU3Exxw8cQKgnrwWBYt7TUlFrttVjwpqmXQ36CF7a7P9wyc9/0MRey1KtX1A+4a0KdSE0DzFceLW6cYqfqILVJOCy/5E07lPk/V6r6nVJ71mXYbeL1BVbMm2epocjzl08+N7Uim+3hJkARI0FJg0PMmkCBrB+ZhjlqSENpU4gS6rFhNISFPBjZ4qPkEeurYljScdmSeN/Khc4+pGTrrjJf4C9UITuhU+hEAxhynq8NH0EgCKh4emHGiQ4mIxxC6z+HY2b3xQ9J2lJp0aiJSI4ordQtzsYgghrzYDTbznEpczXgFmb+CTJRzfKSw2G0rG+RhjPxW1yBzGhROgfZLH5NqVw6IAixWB5X6tW9U737x82Ryoe5Yx8MJt/HpumM29RaUg+yrbwHDsbCa/UGQgHstUE7HOvOo/XnQ/33BLMwTjiX0ZnO65QQsnPstuCavZ47yxjnV/uOjUmB/VsaU6bAx5Ml+wXWh849Bi76RDfgCmkdESSq94iWeTftTepjnG+3n5q2VUvUWQZW+Y+c42QY+btdvYYKOISEIzriKFY4mogxinN/7l6eF9RJlbQK/0OrrxIp7xOh8O+pUFI33bYcpUE54nzdzaZIjyIUCZ4/ls19LPaYrV50GIZALFG1ZOaQG8ijyU6Sdgp5HQDE4kVZvrNdRxuv6T8VC46V4TQarW6/LqBjwwbGHWcEVFdBeNskLJrdZPgBTzPhIqfyHM58TnFjZRcSylsKRD
 U+kWbnCl
 wIaxX5QddRiAq7kIY1V56tW4401T5t0K3owC4EHUFO17cxmbPoYvAAnXO/GZ2sQmBWmM2niPTj9x6Czlf1nv3Um1hFNln/6u7Ulk0qVLdJZfwEBrH88TE4nQnLw2B4sbfcCqs96uMPEx6NeKlmA393S+WqgdK5AcIV11XJtPU2P+Hy0uMD89WnqMGcKWuh4aUWE6QcAe54LR85e4XF13b3cb5MHn6PSfR1HWMszOwufiSugHEiyTN1RKMBvCsOavk0Y7UKBDlmsu2ww2Tt9xbwh/PhuITzEg8yFr5YuaiJZVNlGo5q8T5R7MLNIQdVrrksOhN/fVEd3MGxbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Conventionally, this mail should be sent as a direct reply to the coverletter.
But somehow this was sent as a reply to the first patch of the series.  Please
send all patches of a series as a direct reply to the coverletter from the next
time.

On Sun, 31 May 2026 17:17:21 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> A trailing comma in the memcg_path assignment makes
> memcg_path a single-element tuple instead of a string.
> 
> As a result, an invalid value is written to sysfs and memcg
> filter configuration fails.
> 
> Remove the comma.

Good findinng!  But, Cheng sent [1] a same patch earlier.  I believe Cheng is
working on revisioning it.  I think we should give Cheng more time for that.

[1] https://lore.kernel.org/20260529145248.84593-1-sj@kernel.org


Thanks,
SJ

[...]

