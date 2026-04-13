Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A977CEBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2186B6B009B; Mon, 13 Apr 2026 06:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F01C6B009D; Mon, 13 Apr 2026 06:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B846B009E; Mon, 13 Apr 2026 06:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E49F56B009B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F6DC54A53
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:19 +0000 (UTC)
X-FDA: 84653205798.29.2FF819A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id ECBB140004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ7mybbJ;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077238; a=rsa-sha256;
	cv=none;
	b=FUpHoLRsO2CHSGlAfximDrMvcqx84PumXOnr8rdtczOqQr/fGTjS0t4BRg7MRhFdeHioLS
	ZDmS7hM076uheheOxg6d7kr5d+rHn1emnjEM6C/Rg/XjNjeczv4m/1z4ziBmVqSU0BSJ+Z
	VhVvuFy5QhzcVtIsJ//F3TP4VJAPGWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/EvdIkuX+EYgMlnPOFUnkbJuoliPy5tbgBIcFo6i68=;
	b=JKByUowAXzB0i9sCG4KzwmmdHMffbADMwny2K2viatksTskr+gr0BdhLDm0RTIpG3zqVhw
	WUUUN2+UnSz7QSRa58wGKMEjq81QgYJ6zD9H+PpsX6U9sEJdQRqrNlA0xSfTJxOjxf/Iz7
	fQl4D23mRaeINoloGnbSG6cNbbKRuf0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ7mybbJ;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2347D40B72;
	Mon, 13 Apr 2026 10:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B507DC116C6;
	Mon, 13 Apr 2026 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077237;
	bh=OaaQg0yScLb6753TV7501lpQBgyvDvfMGyHT767MQ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ7mybbJu3Z0ChneXhfc64irFPezd5EHKPKyHZVyGeTgx76pN9SdlJovI50zftpLs
	 msC0OQwyy6gGjM+xV3XJavTRWII8Wo6A7EoymqRz5rtcHMCIakm+fL0MY6fkOjfFD0
	 NErgp5rvP0TvSgYglufDK0RuB7817UGmESUZY8NfMWme/A+NWqk7mq5fjo6Ex4YWjT
	 fJrp/jGW0d9BptKA38ST/lrtsDkiUTuxhsV+X2CuxZzlh/YwO4RV6sUgQidYMLK/Yv
	 /WlI4S7IQqLGb28BVkhhk/mZfDjqWId2HNziEGvLE04KJnbOawlbvcdgXJbGAuy4q/
	 siiIXiO5ks7mg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/10] sh: init: remove call the memblock_set_node()
Date: Mon, 13 Apr 2026 13:46:46 +0300
Message-ID: <20260413104649.852228-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECBB140004
X-Stat-Signature: 4d16nftx7kbjr97m791mpxw4qpa8rsit
X-HE-Tag: 1776077237-555411
X-HE-Meta: U2FsdGVkX1985Z1296EQ+MDyHaaW5UxM7HRKbPLT2LbcmEQWE6UTEOc3BVL00otZzlBFv78j7ksDmMkKDFG9RX6sjNisAsx+617qafrUkq+6Bccgl7LJcOgHuLTzRDmUcV08V3cFmOEyKRjTzjF8bD8WIGGWb0WhYyv2ESLDNA5oBvQDiWDmymPMUxNAlHoADDLS1lFqGY8BmYP8GJMaeyd0vdHAAyfNVAN1d4EBwYFcC28h4ohHDO6uRvhKtGXbMgXrOSO1zq/d0fEWX3G8CpQEEEf6Hkd7L1KRoMAkFH9aGcJacJUiLsrEUWeuF7JbEHZwiIXBCKZl/VWBpwAOVs1S2pc+kpFntum2LopWInq9ZYnZP4oqqTbg1zSGVFJ/OhcwBg2vY5qskTtKw7rgTUFwsjpcDMTG7Y3yFL+bLdB7YRGHyVr+j22r1CrrvhY5yyw89cF/bM2aQS4Zl/YlYllkbPgR3n6lCTXhXV85h70nY10UK2IDYOpl9YYdi54/eKIGRERVL01zf6GU8AoWtvtUn8EixrKlcJbtbGAs83bM0RETCcSLUvmecdPFkpTmOhKq+ZjORtysVw+ENmqb8/TpJvaB6NUFcR/XpIyy/2yoev3fjnQobZTS5jiLauHi6c5S/mck2zK5esDctiD+92/YARwoGXi7xEzF+CTmEWFZ33xmMMr7Ub/MYGk94jTKNqE/GSfaMStCO1aL/IjYY95ZiUHGUzyz904y+xqWGtAEWaPTcdYS5y1wVkpzI8eFlopNuCHY8bpKVW5bOHJyRqIdMOdg+UF1ARHEO+F/Wfy1tj72mPiz6Ulc9lEz/Mruy21EWXfqND2vZYGuxg90h35uH13lkU6Bf2qNS3lGeEg63mGq36Cjzj7RzGzIczUQFOi2ROcXjbW/oAj3/6Wr1kR34l8xA0OseTLY3Y1i6o5AfMa0wQER4KUcEjH8X9Ro6wSdcCDsBpVEeYls/f8
 mQnqQtKK
 N2hteVn495UuvomA0xtSybFaAEUD8PJcG4pAovZNxad/pehxMg0QuUH+QgqO6XTtYdyz3fft4Zv/FGE4SXoAIkAIsIwAvMTATQ9uB1q1bCd25KCPV1mMU4RRV+V5haiBv/8xAz9yHV5vNxEuZulnLG6tvN+rOZrqLUvOrY46jlW65rQ/dOzJIQCsiEN9ZWWtY+APygq/5Iw0jTAPHLS1/bMjzXDFrUYu7s3nfvA3mETf2MOhyTfAhLFPlEA488A9EsVt8YFnTdwfmjHIvnEbKM4pM+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Without CONFIG_NUMA, the call to memblock_set_node() is not needed.

Remove it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 2f2764061003..43d0f7b62b03 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -228,9 +228,6 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
-
-	memblock_set_node(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			  &memblock.memory, nid);
 }
 
 void __init __weak plat_early_device_setup(void)
-- 
2.53.0


