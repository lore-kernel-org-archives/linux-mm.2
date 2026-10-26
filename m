Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DC8606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P7qrESev
Received: by kanga.kvack.org (Postfix)
	id 8D4F16B05B0; Mon, 26 Oct 2026 02:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885E16B05B1; Mon, 26 Oct 2026 02:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774C46B05B2; Mon, 26 Oct 2026 02:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52D1E6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:09:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 507EDA04CC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:33 +0000 (UTC)
X-FDA: 85363750626.08.7BB9890
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF84F140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P7qrESev;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792994971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9/nGkbV+fUPPeLqyGNZSPjPsYCz8iycYQbfenjHMLyo=;
	b=z2MhUI5e9bcNL8yD4/gMTNrl6FWsKd2SuEBtvM/TDDARh2tn6CoB06UyZJAhb1IZNKM18E
	dyTQljKwWaq5Xu33UbXeB6cJ1dSNMoS7XwqppH4EInh2ZOVC/uQY+pOjl3aZl1ETMjxPVy
	BDY0mQf9nkCtd/98fauQTpBpvGUMd0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P7qrESev;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792994971;
	b=n3HrDHsj0HSwlq/p/q+w2oH/VmSCi3cGAo3E9nVZMXOMjBIBX81yCUjwYtNbsOeJxuqXtY
	vBUSsYOmvwnO9H7XuzgrPlG+vec/DmXDG6D1/as8prd9tm+JyWSz+dgk2GxFxDgRuLvHd3
	p/PC7kYiutbmcTsGx2A2U83bvdzhryU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2v1X/4ZNw/k4n0QQySBSm3vuF3Ioo/pID4q6JpER+64=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792994969; v=1; x=1793599769;
 b=P7qrESevDfEBLBVoUte5Tp8c4MLoxJTAP2gUDuLPLCk4+eTBxSt7B/Nk/GtbAhDIjmUp0Prl
 OHv8KjaMB81GJ5BPGofTkt5we/sMwC7oYnbf/lHbZCId/eGBflwi/OBZRUPhT12KvmSvLRaIzk9
 zwpHzemitrIez0ZxjLL0uH0k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f1f0116670f74061;
	Mon, 26 Oct 2026 06:09:29 +0000
X-Mizu-Trace-ID: f1f0116670f74061
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH 0/2] mm/vmalloc: harden remap_vmalloc_range_partial against
 NULL pages
Date: Mon, 26 Oct 2026 14:09:22 +0800
Message-Id: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJLu3moC/yXMywqAIBCF4VeJWSeoREivEhE2TTXRDS0JonfPa
 nEW3+L8F3hyTB6K5AJHgT2vS4RKE8DBLj0JbqNBS52rOBFmO00r1o5muwmpNHaZMqitgfjZHHV
 8fr2y+u2PZiTc3wjc9wPSLN5scQAAAA==
X-Change-ID: 20261026-vmalloc_remap-012cf418c2a8
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF84F140002
X-Stat-Signature: j7mw3ap9zztheuu8zjxqtcfrbdq9iehm
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792994970-366724
X-HE-Meta: U2FsdGVkX1/rms32xfwDCqyqVyPdEkr1s2fID2otG405+/byeJes1FJ36SxQcWbLHemrF3gsoJHFapCkPXVSlv6uVm9xseuPzoefMnpvuho/0nfWAgsDfgY+RSFtpHET3U4aK1vGY1fJCaSPjIfUrqsOefTfNeOUsv3Wr/c16/HqmWoM2CtJ0r4p/7lyM+gW4Js4TMUvDy4cHBS5OJti0hDEj3COl1Xkp69zxtmUc/xkePeM+p0ZkF8NEkYuBmFw9eIXqtrPBvx6gjQFExjH/joIB1f8erdYCLZffidoJnQubQ+buR9wEAvxlI88Xjl5jUWxvTyNNMkUW5El3+kuLJ27nuLRxh5+KVi8SrrClPO2/3IGxfLKG9mQY88kbAS1RFIpOnRC3GvbBvXGmlWmtVAl6DUeC/Y4eGF1Lh/RApNj3SqauQoWs75oHuXUIkwvhV/9rfnXkGw3a4YcbQY8RTX7nku4AnLP1+NOg4QCkqXf0zfaktgbAl6I/WbpUYr6BrUteTA3jysrDTdLC+QsAAFBZnfvevD3+KxJCaJN5xHde2G+ADwRL1F4lmKUebrVsvQriyESzaOEKKfZn/oAeqV+S/PyDb+0qswD1ZkODdewg6qgGAaoMc5OpNde1AD4g2t7fnoP5jg9vULxzQGO4x2lPtz3oJQxNijbTBJV31eQU7dkFSdU5M/DAeMJ7PedXJ24n2VoTgT4AVumrBLFTZ1gGu/6qP5cz17vcYYDHdt2XvaQ7bZSEjFY19D6X3+QYXV8PAddnui2SGaLOLOgyS3M5zRPjUbIXCGGnc0IngMTrkpqslRc2VGAC9GtWs8V03upQ2b/usKc9lVT9idQpsRqdjg8T7SrycNAkVDXzelKVScecxtv0eItrCjJqZFP+mxGRCwBAEXoJuYx4Yn9txb/Ifolygp98cHofvzlr9d7p555wPpyqtBB74HKlkopM8EcLJNbh2o5jX1QMWV
 MX6o4qMI
 I7hJi+YyodffSBGEmXDwf77CruLYGXXE3Z0UZuaA6kSfgowLl/LgyMmdZhF/QHNCsz+BO6RwaB/vThU2WGG+LayOIMh1btT/cVWVm29KAm21OEE3ewLDnQGPhztqC8sX2NL56H5fbDqymfdfDIUo7mpQUyHD46ovmNEuoQd0C36z4bLFGaK1hhxz5SOZ4b4XZJBR15vBgky7QVwHG7ycRH9WVtnaxte+i6X1WVLw6utJ4U+cJQ+mKuvE49atUS5gvYpjo/6gt5OFIaSkJ/zL62BpRqOwLF9uZZFBkq5ZcoroxWtP4Pjaa9wDUUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
vm_insert_page() unchecked, oopsing via page_folio() if the page is
NULL. The NULL case never happens today because VM_USERMAP areas keep
every page mapped, but that assumption is nowhere checked.

Patch 1 drops VM_DMA_COHERENT from the allow-list -- a dead entry (no
caller maps a DMA-coherent area through this path) whose presence also
opens a NULL-deref path, since VM_DMA_COHERENT is not in vrealloc's
shrink skip-list.

Patch 2 adds a WARN_ON(!page) to flag any future break at the
vmalloc_to_page() call site before the oops.

Patch 1 is a behavior change (no in-tree caller affected); Patch 2 is
dead code. The two are independent.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Ye Liu (2):
      mm/vmalloc: drop VM_DMA_COHERENT from remap_vmalloc_range_partial
      mm/vmalloc: warn on NULL page in remap_vmalloc_range_partial

 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
---
base-commit: 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
change-id: 20261026-vmalloc_remap-012cf418c2a8

Best regards,
--  
Ye Liu <ye.liu@linux.dev>


