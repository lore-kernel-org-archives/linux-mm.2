Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B659CC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3846B0088; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893446B0092; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1376B0095; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5236C6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB2A680156
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
X-FDA: 85161731130.24.61A188A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A04A1C0005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWF0A9jU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=paIdgif6hw8T3V3Zj2lvN5z7nl45Qgmr3NwmsBxfwpA=;
	b=fKU5sPb6qGFo+4mPeUr4h/NRkMH67AOQ9ITs7xbYXDuyxI/fT6kLvTuNxbzzy7M2gn5igd
	F8RjfEbKzV2qaV0o1Me/7ONXp7lELPDTRmF5TqhtghWpFTVr6LVqhhOYWXohbRIMGfmNBY
	KdX1tjcikAz096LAw2BL/JQlBOpd6v8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184984;
	b=bRHsiXuD28RYpLDHZaOG2JGczkCTw0ywvsYsb3ktpylhFNi7AGbrFrhZYzZuJHiQ8dC6N2
	gWheTirl1nVSo6egvk1QQ7wUFWjKbfyHr57NTiX2IlmV5MPq73uUiM1rGvL7A10F1YtlM4
	dUkEXQy7oJsvDICFKtUF95+5ey2ebRo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWF0A9jU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF33F601FD;
	Mon, 31 Aug 2026 14:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E351F00A3D;
	Mon, 31 Aug 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184982;
	bh=paIdgif6hw8T3V3Zj2lvN5z7nl45Qgmr3NwmsBxfwpA=;
	h=From:To:Cc:Subject:Date;
	b=VWF0A9jUIsDIf4RCs5BXyowwOSvrSz3CgGBYwd2l6Ijs0Ap3U25FEVv/GLHswkXgU
	 tK5JOF4gDLPa3K258uM691drUtp40UT/n3wKxRQcP7hgo7ClbsLlUW78bxF2+XuSPT
	 7xAkjrwCyejfH3CSSEosqAtFoOuWWJ0sMc6+VS2VnMgz9i+KmUaagAgLBGTbRozI0I
	 kylJpb5iEgxbHFR21rS2l7LUSZHrUxgab3XZhKE3i9DFZMrZJz5iBYV7TWR4OP5g3P
	 ylR5Z12bVJ7nPCpL1y2wPs4nygz9+LbqX/cwd+kUHLeJOcH2tsrvY2YBIUfBkst2Aw
	 ykkiRGmTbj+8A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 0/8] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Mon, 31 Aug 2026 07:02:39 -0700
Message-ID: <20260831140254.72004-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8wp7p8upjhixs6irtk7ugf5f6afrsamj
X-Rspamd-Queue-Id: 3A04A1C0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788184984-372801
X-HE-Meta: U2FsdGVkX194dqquul5k+RSCAIFV3LFQeB8TKVPE1Zo7Y4gogcnQiraoSTTXXWDred4B2AXyoSK0S1SZCa446nOIjBzECJSMtv5gkUiXRre5/8Nqu3jJJ6mfe5Pdbuoyf4K+Kq7DapFskHe4w1s6F5RqmKpT9eF6jTGvPMtGYEP8/LH7z/jwWO1lyyzeiSbfcDk2g4QyOUL4bjm0OHIdaHOzvBXOtLxBKfmJ7TwPsId7v9Eyy6fVl4MCfBVnx10s76MRrssY2RrUbP/6dIjiYhBVnYdIIEe+NjpJkGeYo+ZTdqk9px2gCDcRHOh0kA/wDDtpzqadQKHlvSsSTr5cHy7nZMxTPdBUy7QjWZeN3SKi6nQ/UdipxhPFVGE4Q3bIvdBV9gr3stAnjT319Q8D+T5JRRBy6tjFi9WEDi7lr6RgpaVDVrjikla2VLLFrx1aEMNaf4rKH+gCxUo4/xJjUFXUd+QADB4SXWN451ju81rSldCBCQeqoqS615scg4udQILBHPrI+Qk6gZ0U1KspVvUCjdCMXdhWlTHlMrxzz9YxKJjbyJl4YhCzwSFqP5NkrhdCQRSt8U9+y7dSeqcxiKhsx9U1BJpgaboMV5c4DYyj8SfoZClHxa0AfiRHmi5ZF4e+3z8AAptf3S1S4EjA53P3bZk1VaKsolR2AMhDHyngA8b8ExflJCRZHA726TSr3jCN8ETEcofBzQfgWcrUql/s//q/ZbgV3cw3RxOyT0eh9ULz5TkeZm3SrkMAc9Cu4viJgs4rZw7GSndcXV1Q53iiDOlaim9E38IEU5Lkat4N5NUnd2oYXhpB791XA972ypjfwx3LL8dY7+z9O0hxn/QmP40nNstZWJzoHOKJ+EUrBStTdUNWQbcHu/sl6Igu/aRNUZWeqmC/Ls90B5CL918+d5uLmeFlsNJCJMFPnLf3mGpsnPo3f/L8ESReX3+WfOYFFkChQrkLvaxInHM
 g50HseA8
 GA89Bef7FAnxjeor6YLWFwmwRVw3QMp54N7VaCUUVxQEOkCc24LcSbiZS2MvR3OSHdFGQS8NVmeijQOIJQg4Hyj30c/jq/QqVMVsiO/KgRm6iK/piTf3n1oZ9NcVf6W1BvvK6pWd9P/1izQuODjVJrl03AKIdrdegeajVkugEspUxb+oaCCONcoogVFupl10YVRURl8JWTWt/+l8w00uKfBrS8ZCLgphVxbq8dQeM6sd6HTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory
allocator under extreme situation.  Patches 2 and 3 fix wrong folios
walking in DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in
DAMON_VADDR.  Patches 6-8 handle extreme and unlikely memory situations
that can cause divide by zero and underflow.

All bugs are discovered by Sashiko.

The bugs are not very critical, but better to be merged sooner than
later.  Since mm.git is closed for urgent changes, I aim for 7.3-rcX.  I
will drop the RFC tag after 7.3-rc1.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260802162631.90304-1-sj@kernel.org
- Fix wrong commit message (patch 7).
- Return 100% and 0% for used and free memory (patches 7 and 8).
- Drop incomplete last_psi_total initialization (patch 2).
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260801173554.94710-1-sj@kernel.org
- Use cached pte content (patch 5 and 6).
- Handle totalram < freeram case (patch 7).
- Fix wrong function name in commit message (patch 9).

SJ Park (8):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/paddr: respect folio end for DAMOS_STAT
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/vaddr: respect folio end for DAMOS_STAT
  mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
  mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
  mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
  mm/damon/core: handle extreme memory state in get_in_active_mem_bp()

 mm/damon/core.c  | 18 ++++++++++++++++--
 mm/damon/paddr.c |  8 ++++----
 mm/damon/vaddr.c | 10 ++++++++--
 3 files changed, 28 insertions(+), 8 deletions(-)


base-commit: 59a8d789d9478797978640a7a640b086ad400b37
-- 
2.47.3

