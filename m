Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B36C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FE76B0392; Mon, 17 Aug 2026 02:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300C86B03A2; Mon, 17 Aug 2026 02:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2178B6B03A3; Mon, 17 Aug 2026 02:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0196F6B0392
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:25:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81EFC1C1A33
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:25:31 +0000 (UTC)
X-FDA: 85109774862.05.B426568
Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB5FE1C0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:25:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YoX+JG98;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786947930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KEGF23OhMC87+rYOlEfxrm4Wh1VRmmIgHqCzDaAhZFA=;
	b=5/Nwkbt83Dhy0b+a8ZW/ukrL7nJ9lldqD88h1MUfnABC+IiRlTh+iqjfO49iU43/j3+F0a
	9RAONw8RFr5LZO2gmnbbmMN0wk1AWPIXIPrvGadGX4BPmAytvA7dhMuGHedRh558XbkdD4
	s/vaic2+s6YvLCwKXIncpvTMhAHa0io=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YoX+JG98;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786947930;
	b=yhm01Xmn83tXapxgTRvcLD3YshmXvIQBVUEuVDGemIfrpi9vhACPSpG985AoI5mFqZ+/yT
	KT9tS0Ha490psd3ws/ectX39VMzIllkupO2dWaw9pE6yUF6BaVbK5xzRtnAn0rKl/MxcX7
	tXa8tccOqugQJPDtnIGWsrxDY+RCuME=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cp1D9oBcDI7MYultp2oPrdx51BLqcKdTzDrSb3vQWvc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786947928; v=1; x=1787552728;
 b=YoX+JG98liK4t9Ofiu8G839BsnNNR4l5NHUYJ9Y80GcE6MUVXTaL9Aq3pxKr9Hnn2kM6rVXr
 L+rhADpPT4fLMk1WGUJIUoCYkWgGJZtWJsR02xM5GG6g8OLGbRq3KAilIrokOgrz2jeABiHDfBc
 WNfEhzsDo+wF0ZDqyvLwHZDo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 50b8b077964e6df9;
	Mon, 17 Aug 2026 06:25:28 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around shutdown_mem_profiling()
Date: Mon, 17 Aug 2026 14:26:01 +0800
Message-Id: <20260817062603.106196-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hsfcsabdzide8e56p6j58ppszw3txesn
X-Rspamd-Queue-Id: AB5FE1C0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786947929-515916
X-HE-Meta: U2FsdGVkX1/DvQPCh//gHK6YVxZbNSnhIUj2Bwhw4XwFK5aSYyUUN+Trh8yQqmdzYKXaT2rI6UxnXiRFdOfC4eSGj5muVPF4oBW4mL3p8lSC21V7MtGWYPbx1yWOcl1knkRX9YT+avoO5I7qO3aSZGjNI5XxqzR1SNo1aOJBNHEkkxDBzCkUgzsduVjGbRcmfysbmgNmOpvh/r/43onKyLmT4zeqjmcEFCCNFCjXjrCMiPaC3hvrMT6GK5hWYVKAJ86Qzqd2Ez4Il5nC+KwCX8CXcN1o3AoJi6Mds1vJfiYrmOEnVpO+3E0RhTIEyjFHhJmNoMQXC4NQZOoBkXR7jY0gH03csuM11XaJlXtusTvm8NT4mHfEWsb5b9B+PZfpR33JGglgVSNWUmz9nMFR5uMLoY7kg9szZ+cGbXy+ZJGuThbg3i46hyu7GQMC4rMKGRLnLSnMvWiBSnVkZxOmf7sJK3S1Hwk1LUs0k7b8FZsj1NrxBnDZpN23vVCbzCHrZi26NSfdcmXwfdgMJYdz+Em4Qx4CtQ1mjBqJMWsEU9f8r//3fqfekk8GUsOJP8LQywBLRvh90YK+XnS9UvZdZ/H2LgNp/9w63puT9nFn5M7+5gWgnKHatLRQMFw7Q5/Mhj/CCTYVubW8537bmSyWEx2lVWLzS+Pz5v9jrYIJq7JOmTlKqUBylk5p16ETpeq1zyXGVL6ZLyCG2rCRFOMgq542U5I42vkXg/HiRBTPN98ZCE0jQBA0fBoXHN9zcADW/f2k7khjniHBQNLA1GuioGN95dSks7f3DKHVzwURfe1p6YZ30IUJl4FU2/P34LCjLudRhmq0aibLQrXUsDiqvUzdAiVhEIoDTIQrxruomWvCH2x5j5wbtDMiw+SK+MsuXmKPGtJLEv3tZFroaOWTkZDkMNaw1GgnXBTTqa3YxLemc8tDXBdjExYkXTsAp1TfZOWrZIiaDJzIaWlsLGE
 i2JQkcab
 xhTEYN3Lzic/9X6cOgnVJ/T977Qa/yyV0jprgJA9lepY8i3+29YQQyJLgZYt0QiV2mcfWtEq74C81JuHCOyw/JB3cbSVIVOODxUulLHiTD3E8MaEGJE2nLRn9Ui2D1Fa1ubfVFEMrkaMF4oINE7XCHibJ4VUbqBAbtM4EhG/WfoLrhb+bwFDLZLZtcEiAaIDYL0UXhmXVG0B7k/cAZkJieMsd8hu8pjPsxrsOQp4dpTK23NdxCUrHu9Ep1trq2+pWIHEIY8qyvtkD9CdYVSHNQttvO/E4UHh6IjXb33Fidyb5k8I=
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

