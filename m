Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE42C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A238E0011; Mon, 11 Aug 2025 04:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2088E000A; Mon, 11 Aug 2025 04:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EA48E0011; Mon, 11 Aug 2025 04:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23A348E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:25:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5522BB2B2
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:27 +0000 (UTC)
X-FDA: 83763792294.01.F040E38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 55A1540005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SbFrEYmC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900726; a=rsa-sha256;
	cv=none;
	b=uWyMdYoWrwavucRhT6c3+Vm8oQJl4KT5yCztl0UWfPuL/rwwG23bRcfBb8tEd8mTlvGMlz
	JiTa7ylGS1irHP4j20XXmItO0U+eKWBhmJVMzBIiuBeO9Zx7RauGw3ulUUFaPMmUgSSXXH
	wfgqffnkQsJ2UyehM66zdKXryfdP64c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SbFrEYmC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/n8qeTi9a3W4STq8IZr8DxKUBCk9JyBjSgSQ35Nu4zE=;
	b=fe/qDOEHgd45TfWYDBTLMm8dyM2h6liSNdCLKNvN9IsyQ3e1oHRk0asXZc2dzS2N1K67q1
	q5GaCyVpVUQzq0A6X5sMMYI+zA75t988OF5F3eYMx1/Au/ePGUrRa9uXiAuCng00uDcAKw
	BD91zTh7bpsABWwBSDnaqgY890EMA+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB04861412;
	Mon, 11 Aug 2025 08:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E70C4CEED;
	Mon, 11 Aug 2025 08:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754900725;
	bh=des5gSYvIeWFIzyviF7RIfsIRBzUROyPbzK9Qkkyq3c=;
	h=From:To:Cc:Subject:Date:From;
	b=SbFrEYmCbusOxHhswX9rm/y2f8AdNC8lOL9kP3zDmjaNi+5agTA2xAyM72DL53WKH
	 cj4bYvz87PtfgeyVmW0KDnbPJN+lCH8BCui77GbcJ21FdH7rP1DaHqmZuNEFuQDQRS
	 osrufcQ/DevLWz6blbySBuhwv67VpWIrBuH/mzILKrEqrDNRt047jJabg8rrN4a21k
	 AafiEr/hQXK/yFo+9A1o35POkuJTGuECzVCt6KrLvvrOL/ieEsE+YKTTmXJRdfrNF7
	 iTWETUxTLEoUKB2ilRlp0DGd3CZMEce8LgS4pKTYBS5YdGOot8b99ER0Mo763FBzZY
	 Qi8SodNQLMZ9A==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=DFschuh?= <linux@weissschuh.net>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] kho: fixes and cleanups
Date: Mon, 11 Aug 2025 11:25:07 +0300
Message-ID: <20250811082510.4154080-1-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55A1540005
X-Stat-Signature: mtywntszoxkm8gw7178jfwi1z3wzhusc
X-HE-Tag: 1754900726-192699
X-HE-Meta: U2FsdGVkX18R1OpDPg6h1Tk2hx22raedjyYjy8dFDLph29pxR8U3t5Aw8OyVXfGGUvq9wDwJlj6WR8cW7Btcay0x8cDYpgm8/gsXTw5iIOzOK5VyJpGpFS5okPoiamnNVPnfOz9pt6gbeHsGzmrqJ50P9kWryhaSmETyFPgafpYkzJBIbuQZM8ApUQgdO2rrTxBec0RjNSmMKwMTirIVhSPwRmxlyXCBFUMwxJnWVPVspW23X4D6k/6dv5FTC2583My7GoXT+jVY5287zTCBs30LMGP2BktAzELjacH/3enz/MLOOLJgJyCnboOENY+kMBClzBKEE4xNVsiUKzkn7LTyZuKdVTVE0YKFZt9Art1BJbZ7Z6vgERNGf30xmpyw0QG1AJbqgMH/HJkDfRz96q0VBqCxGHY0Rcqt8AS2mKPyyJ1W9wnx/9H/w+KNzGWr5TxiwP8AOm0S5qr6BFLMJxkdMuz0pzrZQ5ZqOnhFlcT60X9Z3kOYNBCaG3oTql3v24lgPVCx68Mk98mWcI2M5uGIXo3oCDxGiRAkxyOcMywYabE+SnWDUtwBUOPw+V9xG4bHbso9QYEP20Jv2IKe+rts00GYxXng76Qwvt+FuXh/gzbjTA2B5e5+xGhBCMaaB7hXyL1yuJcOyFQOkkO5IkGHwVfWo1oAJ0EaSfY8OBwTpgM513MFDGPjlXQUTifGsA6eDeRaIeIEXbNYaWHxA6rWGhf7pazUEpP7f1xH1LiWJ+jeQSEtYy8R8fJ0xxvkuTxWY9zQmgvYsMDNrzd0OZsTjNBi9VRuFxbvGGIHWWYe6g3rrKwgPvPDNw+JPuh0vsqM6HeE8Mk4Iiu4PCPVnmzDd3EB/eEp4YHP4PNR6XvySz5BPYsCt8tv71K7qOHbk6uYbufGnmPtjAAkQE1Y93gOHU0/ceO0Tl8uL0YA3gSzYjv/sXlsPPohgrkjYCLnoH6nCCKNWI4ItlwusKF
 KpIwze7d
 87DYJXsyAYddUfpctXoB5LV16Ye7+0bDbGSj54Ud472bTbbacF93XPSVdT+UOmGaNk15fbvzkBP+g2lhNXJvlKrjTjo89gMeaVl2fKAB2+f0j77f/UzdaMtQjDo8O5thDWhNBnFdoGnqj+3PSSsDN9q1wqoRnD5hL2mlA71mkDO58E9Vz8ZsXEewhZXu/P+GOub2eLAwGy8TsBjCWdGbWZg/yTFv/WYyQNYMa5zEhC9Y5GKzNhSKqo/YO3+/vNcvY1Ujy8gDvJ3XtbLKaw3Mvc2ilqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These are small KHO and KHO test fixes and cleanups

Mike Rapoport (Microsoft) (3):
  kho: allow scratch areas with zero size
  lib/test_kho: fixes for error handling
  selftest/kho: update generation of initrd

 kernel/kexec_handover.c               |  7 +++-
 lib/test_kho.c                        | 52 +++++++++++++++++----------
 tools/testing/selftests/kho/init.c    | 13 +++----
 tools/testing/selftests/kho/vmtest.sh | 28 ++++++++-------
 4 files changed, 58 insertions(+), 42 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.47.2


