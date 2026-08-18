Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21591C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F24A6B0191; Tue, 18 Aug 2026 09:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA646B0195; Tue, 18 Aug 2026 09:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22806B0197; Tue, 18 Aug 2026 09:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C834B6B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:50:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4421F12022C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:50:45 +0000 (UTC)
X-FDA: 85114525650.02.49FFC07
Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E321140006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:50:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uJ4pbJvg;
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787061043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/bvVDG6LdX/c+A+excTTTIyiNpxHF90TDlVYPFZpND0=;
	b=WQSFtrto91SFT8Z8YB+7TlRyA083FmJ/sv0y2sYHvk8q34JIr0acCKl8Qx98PIA82pLn/U
	dmzolOyF2vAu49svVfQcNZ+WHJOyetJw6Z+cWy7kUtBj/4M7WgwOaUiwKKln9fyJj0fhSB
	Q8rwOrvK0+ECjy+dSFalUXED/41xssQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787061043;
	b=W7lC/uKtx/z+SQpxCnQy2cEvy8A+VSSdObfhZuhbdcRktUgg4YonyRDFFC9NckhLwRGREA
	rCs3UientP2wU4yTRLInaGc8uhALVkWvQYZNsqdSgxvG4XVmKb+F7S6unGy4PszvrBMQF4
	kJd9DRw5mbxuh2EX3UqctC/ORcai/5w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uJ4pbJvg;
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5lteGfeaZGevr99SSHzPdRpl1YSem2xNMOC+8df4tBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787061041; v=1; x=1787665841;
 b=uJ4pbJvgCeeCEPiWiTWKIpWQG7RaiqdJGAA4x8e/GrDcteHhoCKTNShxjPUiExgWN3+Z+ejW
 QUutdTaSnquicFWsiADfnPyGxf3+JLwhfdjmiGfPXoK6kLLgHT+X2zX1rlyswfYLKS6yHY8LNnk
 CCmPwniDe7+q0AV69CHSpQP8=
X-Envelope-To: linux-mm@kvack.org
Received: from .linux.dev (117.20.149.64)
	by smtp.migadu.com with ESMTPS id c8b153e7028ed696;
	Tue, 18 Aug 2026 13:50:41 +0000
X-Migadu-Flow: FLOW_OUT
From: Leon Hwang <leon.hwang@linux.dev>
To: linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Date: Tue, 18 Aug 2026 21:50:29 +0800
Message-ID: <20260818135029.93288-1-leon.hwang@linux.dev>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uok58tkaxpuafy1f6yof83ynx97x8spa
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E321140006
X-HE-Tag: 1787061042-863059
X-HE-Meta: U2FsdGVkX1+E7TvMCRE+ywsixTYUc/2kheHs5VLbfU53oj1YJQQOvkhmXiAWsr5FINCSe0Gybr3G2zvlVbzFUE2as4FN1KFbaytPtNF/1Ssdcs+gXsEBESTPMc/BR8oO0oCNSqAkmo7vEVCOMjg6PIf/VzdhbRTnTavnnOt2nrL9EJswBpBq7MPi+RWeldESLwxXKoi3mNlXcAKWK/wcLjzVYLxc6IuySsvKho0iSEcw/b1WyAYoQFlW8tAVvbciYT7ysVna7Q71nD7rbsr7xH1HwGFw7oA4D/2WsGUC93O7kmN0l+qcKUKEuxPd1a+Yz0qX79wSILDEUtnFFGjSK8VNOTRB0SOmGY6HCUEq40mn16TtC8veVKbaKZJV75upGsV5V3zTlWTI9NSak2sDi0EThd2kq6dUPn6b54/7Fygs/KFHHeLJd98C2+3KC1aVj2b1ZJ1V0/3acv2Mb5UQ5WqL8VxbHosxOtmBEXxvgqe1h96VPLALMyDHLkMPtMSIsu3opPN05tzUP6Z+23UcVADbaFFyntoMSkrptXWvAbFaq9t664Qtdx5fAo2sjlK+goCPuCsMP8g0zeqcWlDiqtVXY2zs3GQhKm6atIncohFy+oO8D1Ay3Pb6LSMvDzZp8aZ4l1i5BF86m/Ggtd7yaVRDma/YhxNYwfLklFHE0LVeRC7ddHSlto1akQ/zKPnASmieoQy39ZSazod5zEwH4LBXvaFFwysBl8JBMg+SY548Av0kKe/rLnB9z4SVCNIK/m/cDQmI7PxSv5Aj6tk0cfxKfTxunqnQ5L2KvRcQrMF10BBFwfg8ZojuDfeEgoDakuRYotVgWwCu/fo8H+CRlZvmT3fZy/QvCWYajgjVbZOY9C9UqEZLlhXyKbxM9+dXrllXitt1JNFkDE5OcFBVU0tE+Sf436SmMXJnIi6ZkT18uLM5PiJVovKOKBn8hD7i7pMHsVLw27yZoqiSSo6
 QrnrUR+O
 FBpyOoKAlOiEjOnXJvfXV/pNqLJr7JBPLrOypnp6piY1RCfl/5lAh4kUta9cD3/O7XO9JIW0l1m9pLE4aeM6rfNICVIcizNkWae3ggUAas9sQjJWc4bg/ETaqLlAN/uNVdGj1twSSF1n0cDwp0bziUnBcKwfNI9G8Oklth27QedgvWNpHEY6oGU8mZ40zlyiJKiLAClrijWAagkizxVYUbWW7DeCt/vEMsRljmtHVSVS1TwejuFrMcABhrbysOskK+dJ0W/gCPne5ROiuaoMnvNJI1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Packet receive timeouts were traced to sparse HugeTLB unmapping in
production. A task unmapping a sparse 2.5 TiB HugeTLB mapping could
remain in kernel context for over 40 ms without reaching a scheduling
point while walking empty huge PTEs. Although hard IRQs could still be
handled, the per-CPU ksoftirqd thread and other runnable tasks could not
run during that interval, delaying NET_RX softirq work queued to
ksoftirqd.

Add cond_resched() at the beginning of the hugepage loop so ksoftirqd
and other runnable tasks can run between iterations. Testing with
PREEMPT_NONE showed that the maximum interval between scheduling points
fell from over 40 ms to below 2.5 ms. Total time spent in
__unmap_hugepage_range() remained about 36 ms.

Reported-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dded1768193a..0a91aac2369f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5233,6 +5233,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
+		cond_resched();
+
 		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep) {
 			address |= last_addr_mask;
-- 
2.55.0


