Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E4FD59D6F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 16:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465D06B0005; Fri, 12 Dec 2025 11:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415B06B0007; Fri, 12 Dec 2025 11:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BD06B0008; Fri, 12 Dec 2025 11:18:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAD66B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:18:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F35816024F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:43 +0000 (UTC)
X-FDA: 84211327326.09.EADBE37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 700D3140016
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765556322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ZurKkOcvxSpL2HwO36F42s+qQbLArihnTDqcS9ib1mI=;
	b=XkVJ7R2HF09K8Du/tA+uL5/FfpXtXqyg/r41dAw89PILFunMi34TJx7YgJhmba6LxRBnaO
	F+WX8e8c0ZxtGRTjoye3BOr1K7wbYKGlJjOKPnin7c31muFpPeaXrabs8bQmLjaFptzWks
	SJcHhZ/dLdKeVBvg4EuQDhEmC2+QQQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765556322; a=rsa-sha256;
	cv=none;
	b=nrkrOdDubQsNdDn/NbE9r2QZaBKqrXMc2v7VqTq+pTuSbMT6VTlxx3c+e1HRc9edxrRgdj
	i4zXl1bAHtx0FkvlT5Kobw80WGcuDesTIPRjmuuWdNhqnyShmBaoifrp9xIUANTdjMm8xW
	xZOpab1ZsEiH15Tp3a1TOYiLbl7JWB8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D589B1063;
	Fri, 12 Dec 2025 08:18:32 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EC0EB3F762;
	Fri, 12 Dec 2025 08:18:34 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	kevin.brodsky@arm.com,
	dev.jain@arm.com,
	yang@os.amperecomputing.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 0/2] introduce pagetable_alloc_nolock()
Date: Fri, 12 Dec 2025 16:18:30 +0000
Message-Id: <20251212161832.2067134-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 700D3140016
X-Stat-Signature: woz31eb6x3wa9abz47kbu4t54tm1z1aq
X-Rspam-User: 
X-HE-Tag: 1765556321-850406
X-HE-Meta: U2FsdGVkX18GH2rHpza9pvS2hp55V5ZJV2cUp7Dyc9qh1/w3qsDIXNOiDiXbpni674vKhz8MGrdUk0/Fxvkhz/Wb0Hz8d33kuA50nwjuw6zi99WTtfg0ezF9a513HCexNAwPMllEVZtEzcuZXc0XCTOFgM2vsEmbM2hp7D5l1J4nA9DCA4rNn796hUO+ZXbQ3LPFOszEUusWhqJXZICRin9QZ6NONPAGvhxY/XuYV6ZPbtedQTXCVh5brxaIi9B2tldjc4us9UW0kWooabVPxs9bhvpuyr8UolVKCLhYEQfzSp9nnfFfCrz8tSwO9XD0/bofMUvqFBxrxg6QZ4ioaGN30Vn1Er1HdHdwRxDJApphXexAlCykpqOu1iT1Wgv91OBsYr/z7X9wesrRwbPZnhfkN0qjvSApLv3zKFUEhE43nyoPG1HPNTe0Isnulpo/LPaJ5CiD671Qwip3VeC2j4CAfLICovLexMR6oRqxUhtSbizBIRSWJ8iJVvShn4WvUzLrwIUgO/IdjTIf6ZcLbacpYKPoZYVu/uJ81d+t0Xz8HJI79kTRNo1/wI7irRAugQAxDWBy1h4e4DAIPmsVgHBAfz7vJqmU0VmS+gWw3bu0SCEUEm+qH6H45UftPSRC6vmQBWAHUZ1FOA/5igYt5Ur0rtNAitDgre6lziHq7lP5duo6THZY1shRTACORv5vKR7VXqgvXFmFiD1CZ91ReyiSduhr4cVjmsOSlE4qPsxKTSE1j+2g8gYTa69M1lwlKqfcMxCnysKspfnk46uQhMJzBTSkSDP2Gfz1jb71UlRUjy6SgN/y8a8BSyShjTEx5/bCqlFndY8lcw7IWoCfR4HOHWOTT/MTIARM6mby9mYpnLRp44AzcbN+E4uGw+6Gu6LgCNX7eXt+gpKJd1r81EQjARIkPZjsVcAblVLMlmOQKxLiajz8yG4iqkUKsFAi9sD1nf7iGw8kugkJYDC
 AnXZCtsE
 gJAPyOyW0+AxqqqECcs8iIKe2nzPzpky4jb49I1DzNSgO8IqCMiBibzJQ0B2AWiIKPUqVgrn2gkxvAhQrwOAvvRh4rPWUeBb0vS6Nrl+Kss8jwPTP0QFd2gib5MH3csBm48hdvP/n5+Dllx6ddomHPOwKeHPop/BkcQAIUdPeD0CEbOq9E3CtZ1knFVh7gvEIU+knkQWJiSijV9dkwpQSV6tvwUkMW5BxvbuM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some architectures invoke pagetable_alloc() or __get_free_pages()
with preemption disabled.
For example, in arm64, linear_map_split_to_ptes() calls pagetable_alloc()
while spliting block entry to ptes and __kpti_install_ng_mappings()
calls __get_free_pages() to create kpti pagetable.

Under PREEMPT_RT, calling pagetable_alloc() with
preemption disabled is not allowed, because it may acquire
a spin lock that becomes sleepable on RT, potentially
causing a sleep during page allocation.

Since above two functions is called as callback of stop_machine()
where its callback is called in preemption disabled,
They could make a potential problem. (sleeping in preemption disabled).

To address this, introduce pagetable_alloc_nolock() API.

Yeoreum Yun (2):
  mm: introduce pagetable_alloc_nolock()
  arm64: mmu: use pagetable_alloc_nolock() while stop_machine()

 arch/arm64/mm/mmu.c  | 23 ++++++++++++++++++-----
 include/linux/mm.h   | 18 ++++++++++++++++++
 kernel/bpf/stream.c  |  2 +-
 kernel/bpf/syscall.c |  2 +-
 mm/page_alloc.c      | 10 +++-------
 5 files changed, 41 insertions(+), 14 deletions(-)

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


