Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FC5CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782A68E005B; Mon,  3 Nov 2025 13:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733248E0057; Mon,  3 Nov 2025 13:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FC18E005B; Mon,  3 Nov 2025 13:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 541A78E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:02:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8F161A02A7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:44 +0000 (UTC)
X-FDA: 84070066248.21.EC5ADD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 48D071C0010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cJ/rnIsG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762192963; a=rsa-sha256;
	cv=none;
	b=k0B1y/t4u99xeeTuNUuIL/U2dT3/ok/KzBAD6fmVNRG8GhqcqGiPzJGh/2ac43Ss4xced7
	iJIX/STCGCFwVLyP2frBFYOQRO/DFg3ra/rovZzQAfRGWirTVWFfGq80ZZl6J/+6Jaw1GT
	bKY3G2Fd2tfQzPCmiH8DCjvP0bvHYwc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cJ/rnIsG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762192963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pei6vbmGLhErGC3eN8KTGQTS7SSeKvTLHuMiLPn2HO0=;
	b=WKvMMNM6tI2qozkDLAmHulkmPM02lC7bvOMhHlJvmrSv2U6Qia5qhOiQERN2FFIruP+CJu
	P/7VDTWVeoz43TbDfmXAxtAzp12psv7JzVLMgjtvztYRYXzUDoDt5y2bPEj+PujLfofcXd
	y0m8DP+2z5fLHSQ7VUumfe1idXL/4jU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D433B41E48;
	Mon,  3 Nov 2025 18:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE5C4CEE7;
	Mon,  3 Nov 2025 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192961;
	bh=eG5n+gndF8e0beK2oqNvA+G9a2E4qmKoofNCVIki7n4=;
	h=From:To:Cc:Subject:Date:From;
	b=cJ/rnIsGFyt798HOUhwVpAhp5rwBCX7jIcMn8RxznG/cDU4jT+533agy4CoUEXWMC
	 qP8kyYGV4derqCSEXkw56mboX+61rvDl58m3aUTlbh6uu2rctWhg80uaIndVzvS7VL
	 jMRXtocc8Zn3SKwXsXOP2JWtD20jLWMCQyITPrqWpE9DsgEXVou0q20yjllsvZ56iX
	 VKe8wRq6PWssnv+WWmI9ZE5iVyx9KD8rbOUUCqalmWI7BzYqK8uO6EpcnpSkt6GyLx
	 sun/Jx3GFdow/+wsHZ/QQ6nYRsyE0Y6IM6srZ8nD+Vk2XLpjhc73omoji3gg7yn+z8
	 qP1hoheL45Zuw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kho: misc fixes
Date: Mon,  3 Nov 2025 19:02:30 +0100
Message-ID: <20251103180235.71409-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 48D071C0010
X-Stat-Signature: onppdn5t53yx3fy5fhf71ry9dnr9t1wy
X-Rspam-User: 
X-HE-Tag: 1762192963-296979
X-HE-Meta: U2FsdGVkX18QOzTDJjazeCq6NYUeSTTdpOD0dtY0MdjtiHMu1Jv6+W0Vd9XrrVTWxFQWvdvj2n+KdqXcWfg2Fg6vZSRdTrQ7xH/hk21PDockYgs5bX8rjQoCOpWNNPz4WgJnXUGjPCrju579XCgdUw5UtMr3ViMkrEr/PeWI5d1nEww3ncy2O0X/tt1JOOB6K17LbklxxhQ6J+myOD5vF7Z9KMHKWsVnWcoiROHEZzMrYqhUslyGYS0IvMoAIHOTbW3TJ04dBx3XuOc/vUuAp0wgjjChkf8FvkY7glsLS3clMaKnZSu6rQycV0i2sMJhz43XmQCJcRAqF0S5uvNrWB/6Ktan3MpUiuep6eHzDnokx70n5QTKsmPcYPi87Qnm1tN1vtqAHpgKbNZF6YUIzCPsqakbyOqB0gpUH823CtxrZuHG4ylNjQPQZiiV1qWASEEj5SQGXN4A0H3eU2F2WodKP27RvaisduqEsaGT5qX3FYfFVZdcBZvBrORRWVqHTNXS6VbgZWwUfu2exuunkg2llPB8G50pYSbe6FzXrHB3szLjomqH2ERKaIy+aU/lYWJxjAm4D9DWv27MVhe+Uc8USRwn5+YyQyDt1qrGdJpWIedRbqXZqYJ8JoTOjx1vBA+D6cLIykO6BeD7nHp5I8LyaoacxgQda5oCoE0uQNB0tpfuC11LBw6L2yIJYAXW5InL6vxYkHhkDcPWtWLqlOUiGvAW/hDKJYHbV6dv37nizkFFHtkfMD6+uXqrWNpJxS9Xojmkd8aRP5FDXzGbNr+140EBb2ySZHOSSxMCq4xUODQeZoEmPl6aQpd+NMpsXR0A61C16d8k80XjSRF85j8iLA24oVlHdEFVS6a9iL0GoctRh9/gkye+duMcHeUeeKGxrPnG96VT5af86Y3Ys85wy2Ps9zkM5/BQast6HHqkplGoZAZ1XHqjmy60VYUOdG6wOOci3nh8jleV3K4
 Yuy5XYMh
 rVZO9uRHmsydd3v2wfcK38odTnVcPNiXyThsC09OtesW4/nw9nduJHghvC5VbGgjEdQ+i6J8GBW2QXoryWOMEHfhJUtwA6xbAH49PZu4c2QIcMiE+MwQtXrsgHJRWu1fudqirfwDTSu1mrAxnYVN8QDUOHl+R82n42VJMoOyCkC8icJSrbB5NTpulZ2G/SWPg4eBDXERegGwTP8IrKC5TdLi3DiE736Km6Em5IWMjFxyKKt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series has a couple of misc fixes for KHO I discovered during code
review and testing.

The series is based on top of [0] which has another fix for the function
touched by patch 1. I spotted these two after sending the patch. If that
one needs a reroll, I can combine the three into a series.

[0] https://lore.kernel.org/linux-mm/20251103110159.8399-1-pratyush@kernel.org/

Pratyush Yadav (2):
  kho: fix unpreservation of higher-order vmalloc preservations
  kho: warn and exit when unpreserved page wasn't preserved

 kernel/kexec_handover.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
prerequisite-patch-id: fce7dcea45c85bac06a559d06f038e9c0cb38b17
-- 
2.47.3


