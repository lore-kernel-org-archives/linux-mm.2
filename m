Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A68E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=lW8l/czi
Received: by kanga.kvack.org (Postfix)
	id C39F16B05BC; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18416B05BD; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DB86B05BE; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 919E76B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC136160245
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:28 +0000 (UTC)
X-FDA: 85406083896.13.146C557
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76C614000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="lW8l/czi";
	spf=pass (imf04.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uz+vtInGrcQ5ufcAYF0ugn5aIK5xFh98eI17KrlnB4o=;
	b=DSszzt8faSNRf0KdF88hJS+n5CwewEaF5SqLKRCYVYEDUNLKPXc6tpW5Kr0wj5Pq4pexll
	PExTf1qT/T47a6gLfTSJsvdeQjtytim0tA+I8qmyMEtZqRgKTXrkhPeKB0uDNLAqSVC74C
	OlnUutvaX+sjgh0iOBJ5KepOKDp+OPA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="lW8l/czi";
	spf=pass (imf04.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002906;
	b=jJ1/OmSy3mWrhmf6MsYw2j1/dNFrz2pqyb4nruuJC2HBfbfR2FzBaSMVmz55Y+LNDgS6Qy
	0FK3aLTiHu4FiYSf13vY27sOLLt/ULz/r0VgcqFZpLj1QvnJrZBq+WUNvessNEB5NRQBqc
	Bb/0Ips3c+I3eu7ypPD3XXeRiHUJBng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002906; x=1825538906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uz+vtInGrcQ5ufcAYF0ugn5aIK5xFh98eI17KrlnB4o=;
  b=lW8l/czijmWJTwqoG9HWh8QN0pwIwphr5Xp/rLvF5HW/2ngUIs1b3vH6
   9hfGfZeJ70PP7t+E8wucKZzBcT0E5xoRH/+nnbhB+HByGIiD0txkUQypf
   yy3SUnjJY/8dmYJEwsPIrvJkSyuNARnYXu8aZoDkpLGBe3sp7Es8tD9Ru
   4fvYI1OltW3YkNOJb5UwdPB+AVeh73n+PexaznJcJbCSKVjncMcpqKuN9
   1EbGfbSDoC04NT8dQuiGYoHeYwhO2bRAUVJ5e+UjgiUt64mFcULrGg8/i
   q8mGI9YHaC668NS7lgS9nUdSTBhiNyKxIqWHD+2NIF1uQaoVMBNyALX3F
   g==;
X-CSE-ConnectionGUID: mgKKp0rlTbmXL8v49ddTjg==
X-CSE-MsgGUID: vLPUzXlXSPOn7xMQgPPTPw==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="32868760"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:08:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:30014]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.149:2525] with esmtp (Farcaster)
 id 40c12b3d-c734-4c92-b6f5-08dfb3f685a5; Fri, 6 Nov 2026 22:08:24 +0000 (UTC)
X-Farcaster-Flow-ID: 40c12b3d-c734-4c92-b6f5-08dfb3f685a5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:24 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:24 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, "Mark
 Bundschuh" <mkbund@amazon.com>
Subject: [PATCH v2 6.6 0/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:08:10 +0000
Message-ID: <20261106220812.2874571-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261105070431.3100950-1-mkbund@amazon.com>
References: <20261105070431.3100950-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: pyjxqnepcsecx7kskxbky3f4aifx64oj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 76C614000E
X-HE-Tag: 1794002906-958358
X-HE-Meta: U2FsdGVkX1/T/UyKw/AGLDclD29Fv3F4sd/rswMTfF0ej2NczpHxQzbDLoCafvPVsbjXjBPps9l/cBDNJpHu2rH9klYGEb/vj6us73/ty6AW0z4azGYaC96HXxG5J4BX9yzhwbOkvfFVUPIeQNE3lvFYjor3nqKLrFUdU188QsWqit0OKjohVC1z3wqJl8xbP7VX3OUQu0CNP/BK0J0ud+h+y0XDBEU4RsToU8Gtdq0y1Q0BbfAYgu0Yqz6D+3oyzTDvspMe5slGeHgQOw6kODZj/xpYaB5hQkh6t7kCHLYmViSP6FiL5VW50BNqenotWiu5+uKUjzgh4Q/0hOVdMFOGwOhqFG5ZYHd+x9sN1+cJrBXNgG1XJCkGSdPBk/oDPXWXP54JEXNdSqQM2f/mSJArwYdfVXEYFbfinsuXU1S4ww/s0NQNxccj72CX3iHPcUIpV6/eXy1XE8qiDkX/aY3xCfG+6ERbOYExe6f0BVmOepx1kLAPtecLiSaE9yCGPWrKzBjv5oiISUAiLwAY3d33B0ySeZ8jRRbCVq+tbzdrAGsHJ64MXiIzzyDWhaIo/iv7c20uNBWTJKsN6LqvUjQcbdk+Uw3IPIlbXlrEEcrh6qsRLrnmWSfdbNInpB7sc4PyLk667y6E24jYD8FUctxQKWKoURTbyRObzwaHxkgVmwfav1Yd3svaGQ0IfWMXGSq6dej+rys7VgadhufFFCE46rsbxVpHiwFetokwEwJ+RZAXb4UYKKYvmZVjKi29bPXYoNGRz1QVhlRx1xRdAlv/quqn9YgcKVP8gWtC//1C/IoxA54JC9eqZbvaL42ftTQZob/ovbKilBI+3kgpoGz5X06LDD/tN8uKTPl5OZoUTGYOrFqyRTiBfXjqv6/iUHQAqkpX7LvNV4Fq//lTapl05MHvhxxQv09X3/8lMpojqYk+I0De6oSgXksGWN+z/XLzJ8T0FJ0ReUytVzh
 78no98xm
 iBf52uL/ZUbLYXODIYe2Wm7vgn4Cy8L7oSyieBNEKLDXgsVR3ROReITrnb2Y0vZeGrPbEaZwjUmTWoxmILAPoR4bNFup28LADy/9CFdtDDKgSY30OxIuUhgXckMSCbc2ylX+2C+YBP6Xs877QFB08FpXL37kXMyd8BYuket7lYt0xxOZpWiJGgmptdzZjMXBlCOoOCmyXtECYcOnAc9/QtE8r6EaX4ZB11Jd+PIbGdBRB4H6z/7+GKa9rs7AiH9iJIC7mq1G2MMxZZFxAXbRQmIVqCIM093VIoMVSxyvkzqhMRiPbwmhEGYxghN5+kn9zjpcnqonuRrn01gQ7r1fvEgEL2eJ5aand7HJWiXm85mofiB1/ejblTDkYJYw/Pd5napB/GsTHJlJJ6E3Vxzw5porSgrAgdMtZ7dGeceTRptWdneiPgAldrLD0SlCpOkn/ZnueRlabAsCm00nKcPjHg68/zd3SRi1v9wAiylkd2vDarzRJyJST5nyAKEHkb24P53pXkhknfWiogPaZPpBXjG8JLzYM6hyAv+c/ogvOoK0pq/zgUjwLAvhTQdnEIA0E25FXSe/q8YoKVMsfrbCLmglYNw66sIi+1LLajWzGvvdSzzp5ZzWV3FtKljbdsegu/TxxUOm1JlblA+bT2OU7yfA+jcogaLt2Z6ZDiSFQ4MnuxNvAP3TcUWbLgfj3e927VZYhcy7YOxg4YUzE27pEK4WWGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Full backport of 04f13d241b8b ("mm: replace free hugepage folios after
migration") with its fix 113ed54ad276.

Tested in a VM on 6.6.161: memory offline of a block with mapped huge
pages no longer livelocks, and cma_alloc() over mapped huge pages now
succeeds (it failed on 6.6.161 and with v1).

v1: https://lore.kernel.org/all/20261105070431.3100950-1-mkbund@amazon.com/

Ge Yang (1):
  mm/hugetlb: fix kernel NULL pointer dereference when replacing free
    hugetlb folios

yangge (1):
  mm: replace free hugepage folios after migration

 include/linux/hugetlb.h |  7 ++++++
 mm/hugetlb.c            | 50 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.50.1


