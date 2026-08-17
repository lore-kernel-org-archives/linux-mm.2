Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E54C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4216B091E; Mon, 17 Aug 2026 02:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687456B091F; Mon, 17 Aug 2026 02:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D9B6B0920; Mon, 17 Aug 2026 02:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 367DC6B091E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:26:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B607D1206BB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:26:26 +0000 (UTC)
X-FDA: 85109777172.22.C95E609
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	by imf19.hostedemail.com (Postfix) with ESMTP id E4D201A000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:26:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XwBc449t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786947985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KEGF23OhMC87+rYOlEfxrm4Wh1VRmmIgHqCzDaAhZFA=;
	b=AnBzOnbktbwbEJ1REa46H7PedWyfSui8zm6u6Lan5Pv9KPF8ivB7UgmUEG9R9Ed6DK1rhx
	WHEl1AjQIqI63b1+i4d6fM0UzMlsFtkZMBMJNTL+rtD32FNf0cfwQmKdDxozFzUFnx6PVD
	Bc3I04c1lW4+yqw6qaQfxWPI7OEzc5w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XwBc449t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786947985;
	b=n4eEU0K8pSDZFk8QcucGapKZ3yxgI7vK0Ss+04SC8u1CRNgXmigsoqcSXHjXXT6Pwtidvg
	hJ04i1G4hegf9+KautRLcMGtSXsHvlPLrGkgMlR1pbDwjVWxKmmRyhgBm6ePUAJaRcutYh
	G/JHL0jqIpcmHn5EBZCSTCdqvAgZ6Ag=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cp1D9oBcDI7MYultp2oPrdx51BLqcKdTzDrSb3vQWvc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786947983; v=1; x=1787552783;
 b=XwBc449tpRkKp/LyfvHGsJXBG3TcE6YhyzhwknRPia1PHwPNqzV4eUQH7OAGzxQyQSPZ1uw8
 PXL3U67bIaGY1wEobzacnkqfXyjOy0TvGaC9ofwuOmGt8bFm4+NEQ8R0ueG1l0ViJTp42zHZsoC
 8+EskMo+yjxeNDZqslmP2YFw=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id ccceb9cb2e5afc2e;
	Mon, 17 Aug 2026 06:26:23 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around shutdown_mem_profiling()
Date: Mon, 17 Aug 2026 14:27:00 +0800
Message-Id: <20260817062702.106408-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4D201A000D
X-Stat-Signature: hsfcsabdzide8e56p6j58ppszw3txesn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786947984-508228
X-HE-Meta: U2FsdGVkX18KdpIOGOaTIvw4AWMLMbpwTC9VRu2nySHUKRlQwf66CPbMijy5AfQViuKde4MZUxi5na7j+M7rE6CvSvYzUUwy9w8h9uUrmJNO7C3HLYuqEEvi15Q4o6iJMmH6sxDbrweeRycj0rLfcKA0a3H2Iv0atc/jv8rRIpA5UOcfVc4KRtmMnIH3EefQBgXF30WfeFCK3KxzU6OMmEifvI+Rlr9DyikvMGikrKBr/5+TYlByQ8S3EjhKMTMvDt8j9zrB5BQx6/X4Qa+ie9xr9vWwqUJTP075qlVgPHOjkUrTI+DPhYHnb6LPO1ypTgUqWCCePq8ryvDs8JmnppGNwmS07XbvIC52tUEeiC2Fa0UZBnuMf6g4buCPpiuIjrhFCocsQfZf8RNHUUNnsW7KIL8NLnceOHAjhfWkVRML9JW1i51AGIlgeG78/oIP+K8vUmVvgb7dGhqxiKkeanJ5fDKRMNNmrLL8KfpmEZd0bMEiU2EWDRSMwUenxMi3fOWwMPI6+WQS01hsWu6b9XXPHbLdLI3L5d8U4TNYY2mcG7pL2JiALW87Cfi9hM27iqPsm/PhpOdz19EvWUh4asVgwvUXvbLbk4ya8+JUKf0qQ0XCN+OumGJYLF0+Re0Bf+RyaTo+KW0LivLhlbmOfy/BMrXeVatMhxVPIZut+h4+496KKVaJdvuBS6X9cVQrRThbJLWJRcqhNtw2QmcYfZeFPSzfw2gzaR0oJ64klCJ5U8Ia2EAo9u7E4h8RhfKZL2DVNLXc5JW1KM+mxN3k95ozZu2p33rm6N9UfNfdYPfGsYVndOqRqRoZxyZ5z7rbzexr/f4p+8eJ6z/sLQ/Tb/BJsJ+9VwHMqD10/4wgmLLMjwjpf9c6y+LdMzD+4HEvnB6qbmn+scu/EY2vU6aZBo2X8Lrnn4DMLWG//unwgA4HiL7hlNcM6yt0d/nfI7VtoAHK0GERZVo35gbHEQ/
 8+vWMKEY
 2Xvwbd4ueGWRW6J98Y0cHoNbG/oIwCi/EULWXn3csuF5owVyoxfY0tD2FWo1K2/Seq4ruczTzhD7BTYNWZbrEirUeRFY2LKVXlGqcYS5DfH32sVGO02241iuUK+TclcKvo56rgOxtH5WwRPwJA9kINJsLPyhjpzup+Il8NUDW0Ag3JbJE9Qw+c4BePE5USvEHb7TKTzLlPdXRho/fKEz+TPETd2H+Qvd7kH8PWn+NKX3hlTzMboRNLnSMgUcpMAqKLxM0uocp5wWJpbEVCCkSqu8jb1oSrW9CZTBj8i/oSe6eqxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two fixes for issues reported by sashiko:

  1. percpu counter leak on modules loaded after profiling is disabled.
  2. AB-BA deadlock between module load and /proc/allocinfo readers.

Changes since the RFC [2]:

  - The "move codetag section placement decision to layout_sections()"
    patch is dropped from this series. Its retry path depends on [1],
    so it will be sent as part of that patchset instead.
  - Patch 1 now returns -EOPNOTSUPP instead of introducing
    CODETAG_MODULE_LOAD/CODETAG_MODULE_EXCLUDED defines (suggested by
    Suren).
  - Reported-by tags added.

Patch 1 skips percpu counter allocation when profiling is disabled,
so the module loads without its tags instead of leaking counters.
Patch 2 defers remove_proc_entry() to a workqueue.

[1]: https://lore.kernel.org/all/20260812054105.102637-3-hao.ge@linux.dev/
[2]: https://lore.kernel.org/all/20260813093421.135230-1-hao.ge@linux.dev/

Hao Ge (2):
  alloc_tag: skip percpu counter allocation when profiling is disabled
  alloc_tag: remove /proc/allocinfo outside of mod_lock

 lib/codetag.c  | 10 ++++++++--
 mm/alloc_tag.c | 14 ++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

--
2.25.1

