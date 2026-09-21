Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACDBCC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A416B00D3; Mon, 21 Sep 2026 09:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6513E6B00D5; Mon, 21 Sep 2026 09:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567CC6B00D7; Mon, 21 Sep 2026 09:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 241596B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:17:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0FB1A4713
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:44 +0000 (UTC)
X-FDA: 85237821648.11.CA53422
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 279054000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWfXz3SF;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4BUEJQCz19pxp5PmG/E8ZqIoOezpz1Df48Hvx5Opiy4=;
	b=WShQmG+bJyK2bGfkLFJmk2+NIDh/QNIAWoeS55Ic9i5tdQztxxARPgvuXcZWrt9JIjWtdY
	Dzpve4l2akmoRLUTfkDO9yHaJlHIhqmGluY+czLOacxR4MIlDBp+e6xgcVJfIizwZTu3tj
	+t0VezzoQTpBvmXmmcRpKDoVWcJ+tiE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996662;
	b=VUApLNNB61T+48ZqxyV00sszKwR+o7BWm3rfe5vP3EvJ6wJy396KHQoB6YQCc87lkwFNnJ
	gtCTtRUB7zB3tchYso6mP8ia1/0zJfULRX1UlBu+WdV4a4obw1oRdNBYekikDtpK+q+Ip3
	Itbnq0XTSak+LQPeR2Dy/N8Oq6Ide3Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWfXz3SF;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XGKeaZZkegvCape3qQBQEln+i9bC30nsXnPlSXlaifg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789996660; v=1; x=1790601460;
 b=EWfXz3SFxahkBrxnVvRXGkVXmPA/DSmsYBjLNUX5od6izbSpmcQS8L/z2W+rZxIQclFpAkU+
 8sxXxkmD+VJrP8fqPP4l33KVqQQgqIczhQZqkg01seg36/eqkgxqQuOi56MqZj+0REpHG/CU/6b
 AuUSZvEdYJGJaCufn2pxtfEI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ba4558021e9b6db7;
	Mon, 21 Sep 2026 13:17:40 +0000
X-Mizu-Trace-ID: ba4558021e9b6db7
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH v2 0/3] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Date: Mon, 21 Sep 2026 21:17:20 +0800
Message-Id: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGAusWoC/32OywqDMBREf0XuuikxDT668j+KyNVca4omktRgE
 f+9Uei2ywNzZmYDT06Th3uygaOgvbYmgrgk0A1onsS0igyCi4yXacbChONou0Yt09zY9sVUwUt
 eSJnfshKiNjvq9XpWPurILXpirUPTDUfRz3eE6ogP2r+t+5wHQnpIf7ZCyjjLESUXSgip+mrUZ
 lmvigLU+75/AWLiVEvPAAAA
X-Change-ID: 20260916-vmalloc_dump_obj-d80908447369
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Stat-Signature: r63ize9q8ip1g8nwncrrda8pofydwei6
X-Rspam-User: 
X-Rspamd-Queue-Id: 279054000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789996661-584750
X-HE-Meta: U2FsdGVkX18upxtRugDYI0Jhsu7ntDNw2R/0dXHKEEvWRvhLFwHc0WnUNBxuCkApbr/cgisGgmzjh1Q4xSFRbFUpI96P5+aLlJLNVEmVvqpVqCr+N/NfjkV4AMkxS06RhKCAuRFZoIJyNf49Sek+UgvyO8Z+lzkCMbba3ixxspjrnM+v7N5rKRETy4vaNNI2bz4cK6OvNHHY7MQ8uxRTFQNJ6nN4GQkXjegbmYPtObhjxeGK2EYBMn8BMt0TCTgwclLpDZzGA3ZhgCK9i0TwfOZoBKQhmAyxatnSgzYor0WI86bP1Ds72e2pQLMSC/p+h2GTRB7YQpUSBMWS9y/SIa2Sp0oE8rDAE2wge8PdlvufvSKgr8s5kGoxFCXG32UR5ZVfGDl1O9FfzUSqFBkoH0I7yxlzbhN+MPTM10PA4no+9+AAwJsl3RrDtIsmfWQoI5C5bkc1C4wcK5ZqvZtVlnqH0+1GP3hgEVbq9YGVgXAEvaQx2dN4FVbgCWvCnejJ0Ou/0Q58idjDxumAFzZpX857XQo58d8MKrX2SBM/JYcPBBlyG7olzhXd/P5D1pZXdJYmrkhnEg2KWwa77qemL93yDNH9QlncoTZSZf0DEZPlCnfpV2EtotRqeqT2Ux3fApIOoL1Hwi8zo3sf1M6ZusuUDK3hjlrRN226+E0w2wjjO7XvnlF0gghahC9zV7V0VgdX6sC8QwmTy8wQZ/p9/6P0hzjWySE0yzRWz0Xdl/GStPuZHRLC1TDM/xdJH6AETPf0+tP76O2+825Lc1yp/X3Ep3n/+pwwBhWOpaJ5VX4tqWxUBihDEfrjaXfUEgO313H4vfU/1x4BXwTWf7VUmUlaN0FqoLa1CUHyXXk5ABDdq15dcRVXZf5uN6UT8T3ZvjHC49LubltzT1MGilTaJ8F6OgM/YvihSkw1jHTMSk5kMHNJxvJ+FdyzIsJpRs2Yf4slWaqm0A5J77uzDOr
 YX5MJp6t
 w2PRy0IE3z1O3YZmx4GwcpF4zqZ52F2M6xqr+aOfxUEBho+t2b8BIaP4oTSXYxCJnAaRypXWa70rKpuCjt1Istg6T7kqxMeZYO95pNP3ve5Hbc/mlQ/NytEUIrTnO2wwewAGcZlXp7fwyN8EeeabRQghyGW6G8PbwTM8y8gq9nH7TOvCLGnPR277hYhRq64VI/JNo5SN3VPo8oy5kVgpxYX5FUmEg5odo/3GEnUZECikB/qr4vHMh8BwO41kLhW/l3B2/suyFgQEfbywO3rqr8TCp/76kn0aW+jEqLMB2mf/UIIgiHghZWo3stw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations, plus a minor optimization opportunity:

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search,
patch 3 adds an early is_vmalloc_or_module_addr() check to skip non-vmalloc
addresses without traversing all nodes.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v2:
- Use is_vmalloc_or_module_addr() instead of is_vmalloc_addr() to
  avoid filtering module/BPF/execmem addresses. (sashiko-bot)
- Link to v1: https://lore.kernel.org/r/20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev

---
Ye Liu (3):
      mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
      mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
      mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc addresses

 mm/vmalloc.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)
---
base-commit: e6e35979777d646fe3c7c94dca7dd32fb25d45f4
change-id: 20260916-vmalloc_dump_obj-d80908447369

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


