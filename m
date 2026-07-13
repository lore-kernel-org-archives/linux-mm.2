Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D24C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31AE6B008A; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08C96B0095; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71AB6B008A; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 938226B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20B22140A28
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:45 +0000 (UTC)
X-FDA: 84982742250.02.A95F6AA
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9BF740003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783923343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=9FvxE1DVaEotnAgJAkeGxoVFC2hQSrErtAzSyqqZTJM=;
	b=cke1wpSbXLk61yP44XpCingqwkqNxRIpPHPq7sBMAZw2BxEpRjlvK0Ap+CDy+BXOC+POyq
	uUfX/tOOxovePjv1r0w4Z3KzVbzs5CrlptpsCMK4VnIpGQ0JQyfUsqZQnbugvb3NLZauZ2
	LBBYjLsEu0Fq2NWISs1V9fsuOvkQf9s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783923343;
	b=1V3gj86zifpQFpY9VRWfopRXj0WK3QU5W20BQAIqc9LrwBdXtXHZl1zgNenAu6SU9i7yE0
	w98srutxxzKjmWtzOa2Xi6O2rpEJ9OSPWCgI7lplKNWStTdaYhWnz73EDtqEbe6fu4saLo
	WvaAhhIRWqKib1NMypBSMWvH74h+Jac=
Received: from [127.0.0.2] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHF86CglRqddeRFw--.29971S2;
	Mon, 13 Jul 2026 14:15:30 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: [PATCH v6 0/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
Date: Mon, 13 Jul 2026 14:15:19 +0800
Message-Id: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHeCVGoC/43Oy07DMBQE0F+pvMaVH7Edd8V/IBbX9g01kIfs1
 AJV+XecsmhRUWA50ujMnEnGFDGTw+5MEpaY4zjUoB92xB9heEEaQ81EMKGZEor2kN4odDMmWnr
 se5joNE6nd5iR6tYFY1krrbekClPCLn5c9Kfn75xP7hX9vJJr4xjzPKbPy3zha+9/S4VTTlHbN
 rTKOuD6MWYPeQ9+7weybhVx1TRrtjVBGQWnwQQmXSObe03ean98k/Ub1Brj4K3Qv2jNjSbZttZ
 UrUPnPFcBmGjvNXXVDDPbmqqaMYEHDNIDyp/asixf2vypQBICAAA=
X-Change-ID: 20260525-mark-after-vmemmap-populate-68bd790839c9
To: Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, Vivian Wang <wangruikang@iscas.ac.cn>, 
 Muchun Song <muchun.song@linux.dev>
X-Mailer: b4 0.15.2
X-CM-TRANSID:rQCowAAHF86CglRqddeRFw--.29971S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWfWw1Dtr1xCrWUCF45Wrg_yoW8CrykpF
	WY9a98ArW5ArykuFsFvw1xZr1xGF1FgryfKas0kw13Zw15tF17Jr1rK3y8uF9xJFZxX34D
	CF15ua4ru347Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VU11rW7UUUUU==
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9BF740003
X-Stat-Signature: w96835imjpprftt64n6pmojofp96x7nn
X-HE-Tag: 1783923341-81028
X-HE-Meta: U2FsdGVkX19FU7LidmnfTBSNdAEulCfQ2KciJ9ZAaGDIXbAwd+pJoRPks5/YaGK7LWU3NHdbe48WLIwwnFBuAcd0OmAeGKEm43LEh15po4TEqUpCnc5vo09eegPxI/qaaEe/IvrmrH8umzg4SQ31I4GjHyy9aDMakjN6LyOBbG0/5idJZDJlRPkoc59zkm6cOiyDnDjTSw2Z/RsJZmuiCIqRn7E5sgRWF6qQHJxPfuF1c9SopSrEVUe2sSHv99EH7UXTu6wxXO5fj5CrhMrTbo6xhPGLzlmpaKnv6HC6CUSOg2hF2sUxoZHJMWd0DS53YG3A9RItdXEb6acmUXSLqFqKWjaCPEl2jF9D6Ql2xaMfHb2arUQUBNfkUDkpgZOWNreAYHy63IptLM9OfUnuZKsUc+ivzCle5NA7nFTabktds46yvpfRXsfPlobknGZARdheZHe2iqGx+1Wd3SkQkHDpFoaKRj+MHBEB+qd/JhUBU85Q1ZmZy1DNYRi6af5uGx1tD+v9r7tMBd0MNq4A0kp77i++UqltBvUyo5yXTLv1up94PCkftmvUFI1tzl5cgKzA11tPhZ0C/AcY/QRS5FdDLGZrzL+e/XiCT0hY1KQNQZh/ui5YsAU/mjlYwOzUQRpqNaT84/R1Xm0QVFn9NIic4VtvLcIwONhNDIpQLAwm4QEjUr3aWoqG2Q9faCZpqBhml1gp55brbjsLnovYT3FZ/MPyvLue1V/s6oyb3Q2Jkyv+vxCiOT7THlWIFaYdBkctJ1iDpWYJfZtCeFF3nDnZwcAgtpjDQMDcDa1w5+sn4cBu5JI6njHlSc3QTYZZaRFnkYtQommcquFQvHMLagWFhLPRBMEEXAdc3nBDN1AxkT8FeG/36EOSCFUZz+a2YW94yzt9DPKPFzuJj89k69DDo5x7700CRsSY0rCqkAcURxgHtJsd1rByvkvbVphro3s9G3884qwOc0paVVy
 rDPTGWvC
 UNf7+CAb//9SxGKpPCcDdzlwgPFaj81ZUjyxa2Q4azFT8xZA+Dv8b9NIiR8PwGYedrwLe6mks2ZbTTCbqi1v+LGYLs3xmi8pPgQlzY/NDBMv4Nd/ndOl81QBIQ1s1R1D8HLvYXOwRml5m+5PMrLLAJR1OhAYdUAdP3tmzemjiNEXC1Ga/4MG6lqrW8vXQXD3SQdTD6AgAEyxBGl1YMYIgXvLX+0y6tAmDBOAOOfox5RBp/MYDHDjkbmqK8Avw1AZsXwOc+RpsUvrN9tJ3Xuh7clRpar8rtgb2/Jl378YjlnK/4aUQCYUPRc0z1++pCJRJB89w9ySdRHLWQqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 is a bit of clean up that fixes the compilation error with patch
2, since VMEMMAP_{START,END} is not defined when MMU=n.

The mark_new_valid_map() thing doesn't do anything useful on MMU=n
anyway, and the new_valid_maps_cpus_check code is only used on 64BIT, so
I just made it all of it conditional on 64BIT && MMU. I hope this is
acceptable.

---
Changes in v6:
- New patch 1, make all mark_new_valid_map() stuff depend on 64BIT &&
  MMU. Both cleanup and fixes build error with MMU=n. (Muchun)
- Remove extraneous change to arch/riscv/mm/init.c
- Link to v5: https://patch.msgid.link/20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn

Changes in v5:
- Remove hook, use existing flush_cache_vmap() (Muchun)
- Link to v4: https://patch.msgid.link/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn

Changes in v4:
- Rebase on v7.2-rc1, drop dependencies
- (No code changes otherwise)
- (A concurrency fix for mark_new_valid_map was sent independently)
  https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
- Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn

(See v3 link for older changes)

---
Vivian Wang (2):
      riscv: mm: Make mark_new_valid_map() stuff depend on 64BIT && MMU
      mm/sparse-vmemmap: flush_cache_vmap() after hotplugging vmemmap

 arch/riscv/include/asm/cacheflush.h | 5 +++--
 arch/riscv/kernel/entry.S           | 2 +-
 arch/riscv/mm/init.c                | 2 ++
 mm/sparse-vmemmap.c                 | 2 ++
 4 files changed, 8 insertions(+), 3 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9

Best regards,
--  
Vivian "dramforever" Wang


