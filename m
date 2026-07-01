Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5FDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B766B00B5; Wed,  1 Jul 2026 12:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A436C6B00B9; Wed,  1 Jul 2026 12:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B6E6B00BA; Wed,  1 Jul 2026 12:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62C7C6B00B5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:24:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAE481C6D86
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:24:16 +0000 (UTC)
X-FDA: 84940730112.26.1EFF32D
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43C0F1C0006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:24:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=dolcini.it header.s=default header.b=jnTiTMoL;
	spf=pass (imf21.hostedemail.com: domain of francesco@dolcini.it designates 217.194.8.81 as permitted sender) smtp.mailfrom=francesco@dolcini.it;
	dmarc=pass (policy=none) header.from=dolcini.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782923055;
	b=zQdFZF/ElRW1lDMEwlYfC3It7cr+NqrWQinMqV8dgzzFQAPDkTIr6o8Zzj231QQIzfhkld
	CBQEox4OUtlAdTKMNVy1L7VdjhdELqVKgRErg2N0ZHVaqAfbiYkE1GtzFriF06iNRs8MPJ
	+fulFTCDnpkEhNzZQYpASqba9VAWxpM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782923055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9BoCiRz+jTMzZ774GPA0gBs0cqXHfYMScxVG2VZtj8=;
	b=Lf4XSFX0pkeYCL7uquILTr352hDsapFCqIMLJ59/1v6j5ji6AGafwPJ/CPTtQfp51bgoyR
	pDyeoLoB7PfknP2XtQ4L9dYbHYNLxjAgB8qDYggPQwClXeH+slz/bWUcqidZFbEXiuNzDw
	o2gPVdj7TxUNgL3+Z8IyT3TLTJl0c90=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=dolcini.it header.s=default header.b=jnTiTMoL;
	spf=pass (imf21.hostedemail.com: domain of francesco@dolcini.it designates 217.194.8.81 as permitted sender) smtp.mailfrom=francesco@dolcini.it;
	dmarc=pass (policy=none) header.from=dolcini.it
Received: from francesco-nb (2-224-25-112.ip168.fastwebnet.it [2.224.25.112])
	by mail11.truemail.it (Postfix) with ESMTPA id 893E0228E1;
	Wed,  1 Jul 2026 18:24:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1782923051;
	bh=j9BoCiRz+jTMzZ774GPA0gBs0cqXHfYMScxVG2VZtj8=; h=From:To:Subject;
	b=jnTiTMoL2sl59fl3xrOn7icJksQ1c1zAouKZ6ZN1of6J9D+7GiPp4teflbxHaMEQr
	 rMesX1MgeXn8rGclp21gk+OXT0xQE0ZTxSuFKYp5fBa1elg63QcS9skrryY7iGJNqB
	 F+VLwuUevm3RXeRI9/VGBcHWbyedu0qfQQ9Sx5J4U7Yld6SydBWwV3WoRjZEtx4lZb
	 CrAB6jB72BBRv1PxJ9GnYIQsm3pM+ZXeCz82ey1/7ArYu5oKTodRdQYIaZe/xaiJud
	 tVOhbYJ8JkyUtmNVR+VgsWRb7T8NiLxaedru0BzkmvJmWoJiVP4b/GnhrYCEXX9FT2
	 d7odGKWJv/lHg==
Date: Wed, 1 Jul 2026 18:24:05 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] mwifiex: debugfs: use kzalloc() to allocate
 formatting buffers
Message-ID: <20260701162405.GA38581@francesco-nb>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
 <20260701-b4-drivers-wireless-v1-3-60264cdf2efe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-b4-drivers-wireless-v1-3-60264cdf2efe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43C0F1C0006
X-Stat-Signature: 91sawxro5b1y3py69ykrm13xrhanad8r
X-HE-Tag: 1782923054-657155
X-HE-Meta: U2FsdGVkX1+k511x8K2GcDRxZTsKVk2rUn33ys7kPHIgLG+quDgHyjxrueSAQV9eNsCsYY1Sg/sFo9SHiQcCkQB6gLEKWPAOU62Pj7eEUjKTl6GQYnKHwpE9dA8fuDVRnjaoS34QK1iFVWTb6UyisxtfP/l4UF8e4TwHTyfuhhSb++I+E3Kcd7xhu/Rynzsu843GsnMGvdrU6+NefMzrmobR9ewR+09YwqtjuxMHtEG8IcpQ54B4pfQG6ITob69kfwe8yY3MaACb/0EX/ZCEBSjlbV0H/UKmFSvezlCwfpKiC051LE09tb1vS5evUiKFUQ8qDXppC0tYGuflYGC+9y6pHfqhO0TH0MjugXQr4RYUmkefUmFbKdAR5PWWKMwUvNJ8WoRBUFxWkVQOQEqL0uDi8Zwiu1NAtwq2CpMy1KMEcgAiEKHKyikWpEM2a6713oZHa1Ec98c9nYU4szI8X9y+vThCJi31A57st8LNodjUSYzpq60TGYOrLz856xqKlrU+ZfWUOqWWkNyO+g19zthi3/7bLDI6jZjEdi9a7w8Kr/9TPOBJQttyoo+4IshS87FaISYhdHtsP3v9ek/727XhQYhYYW6oB3Drs8nmD2sict7/Cwx7fywmbOwowXCMgi/qtNXET+ySeNButeKkSxknGdKj7T+ttKuHAGbF9d9mdHl1G17mWP/3Trd8bvYS2U3hP0MIak8bNAuJQ56w1bvxyE7AC01fHU2KXXciDPvlMDqjJp1qN/KPxjfoSn8yycQZ61l/CfreOjL7xj/uQPm+XrHeNylzfDKEEGV/3Njufq9HjLOm/r3sqY+xzhGQH1di/7F9WMm103xvNhirceCeyziEK3b+9ddPn5Vh5t8LXVlEvnVeG8PkRzbbj1LHt+JtlMuV+VGnq1YwejvRe6WXyVdL7CYay+rBDNdlz5+gon2MGp+fRdg5aMpVfHWMgVWzbwNmkIKASETgl/I
 ODo9RVIp
 MEgekKU9vNOfbmfUkYL8ACHycLp5PSNh9+mMcOU0+IkEtWwVj0A9gNCEdskdrNNTfgoA4QO3HYAkPDVRhPsunjJzsxNRSB+JzljCdiy+u/UxOCLKYQSG4rMPbpkTXdwof+QTedSORtWXBrtjEgfR/f2PbBzBAc0XgCJzotmRfenudKJ6sKa+rv+gK1aaBuYTFA7nzWJQBGgFR3WOtBslgvVdxnUsG4Sh8HFMOQQ+R5L7jpAog/Xfk7OlA5Weme/aV4SqhEc82SS7G19otmRVcY0FPmI7SKZI/u2b8GgYAI7CdLlvwHVW3EoUQipQLOPKqfkT3ycm3V3YcANfbI0HYj6S4rK7mXNuZVRRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Jeff

Jeff: this is relevant also for nxpwifi.

On Wed, Jul 01, 2026 at 04:59:12PM +0300, Mike Rapoport (Microsoft) wrote:
> mwifiex debugfs functions allocate buffers for formatting debug output
> text using get_zeroed_page().
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>


