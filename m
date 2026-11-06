Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87857606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADC46B05B1; Fri,  6 Nov 2026 12:51:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A860D6B05B6; Fri,  6 Nov 2026 12:51:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2BB6B05BD; Fri,  6 Nov 2026 12:51:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78AFB6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:51:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC6D212017A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:51:18 +0000 (UTC)
X-FDA: 85405435836.22.AF4525D
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id E2EB1A0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:51:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50CDwGjVnVq7EP7e9pA48xeTzp4afcqVVW+xvnsa4Qc=;
	b=up1CweSrSr23zU3pawFOQ9ck9xtGDcOdO0ea0i5bJyqDowHtvdrRFPcY+BP9nIYjzC00yX
	SaAT/ETS5qpBn0aaHaq5EenzmbBuKvhe3xyrZBauxTUMow3pwodSjgdH1AGtNDbkOZ1qRU
	SMEGJwnCk+LtdG3tJ4AOWdlJxiK+ZGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987477;
	b=xUHCAykO9pDWfxRrkFv8SLZBjFjO0IHRYOJlUhq0Mlu3fNuH5fgYh4F7xnVDn7j6FFOAJp
	24wGgOfOAZdn5j1mpAqbLjk/R3qNTSHShGnv8k/MK8LGXTg5JjWEGre9zFxfNf5P63IigQ
	z3Zqla6CTWXhjtmaVqDcu0LZiKAXmRQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLmv12V7Hz6ySgX;
	Sat,  7 Nov 2026 01:51:09 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLmtz1NLXz6ySgX;
	Sat,  7 Nov 2026 01:51:07 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 737F5308158A;
	Sat,  7 Nov 2026 01:50:27 +0800 (CST)
Received: from ws.local (172.25.64.90) by cncheex04.Hygon.cn (172.23.18.114)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 7 Nov
 2026 01:51:06 +0800
From: Zhiteng Qiu <qiuzhiteng@hygon.cn>
To: Ying Huang <ying.huang@linux.alibaba.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul
 Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Alistair Popple
	<apopple@nvidia.com>, Xin Hao <xhao@linux.alibaba.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
Date: Sat, 7 Nov 2026 01:50:57 +0800
Message-ID: <20261107015057.1328227-1-qiuzhiteng@hygon.cn>
In-Reply-To: <179395975709.1235605.1971486611419119070@hygon.cn>
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
 <87zevmwbaj.fsf@DESKTOP-5N7EMDA>
 <179395975709.1235605.1971486611419119070@hygon.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2EB1A0006
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ui6xw99ohckriik7pyuyhhxkqrwzd7z7
X-Rspam-User: 
X-HE-Tag: 1793987475-258748
X-HE-Meta: U2FsdGVkX18smZzmkanrlt+SGfmB+I+3ZhUzv02HMKwmeYS8eDweczDopRnyUg9me9Ty12szOFSoJiALkQ8al30tdFdk+FJHHq8VD25tsjeiVuimys2J2d7A0PeStTytecrTGGuhmUQfmsFVOLRmWFp6p/5/4JcJ5RsWt6kWO5QxLNwXM0onF/jbbBaaTAMTbvUrZZfr5C12I5Ic3kAu3rzzOnxJCglyUj0lHz8ZNeuxQsK+Ou4E7s6yq7sZN1n29QRmZ7AAxlqLVn3Wxdoaxx1z5xKzw+xaETKH+gu5VbabHjfui7vx/2XJOE1S/PhWOmXzOSxdZfddM95HVA9duL6aElEmAjHFEgWagEf/ipqxs3Y2jebRsNr67+lJHOPPsmzy2yYzIKf1vqVXAwfG85X4ZfQy3QkFumtlDWmHkTA3XFdmy9IFARsuDvWnzDveR33/CEVcos3KKDCD6KDjVy+TGWgOGK+q6XM5ujBXa8N0ElOsxFoK0kjIDhzy16DM0q8aUgTtqHoL1wGYW6y2u+BxZMZMS6BK4V23ViLHY9BFN0SoTWENrW4v6OZyzSReYSJ19sKRl3wGX12UD7kTxu9aB4d+6AD/jYYJyeSn4IXD5zmIHMHd13KYq0erxDdU9lVwxfBbdtU6KhoM+w6YchGmgqLcmthcZOxTqgJ998ox6f8v5ylZbeqm3VIbBtOz7tr67hc77nJuGFDaw+YgKIUg/MSU2rnbh8lhafxuQUiJxk43TUxCK9gYFoAjjzlsYPujF+Nc5e/kdgi4rHmO3/1lPM+sVtfWQwMXLU6KWmVKFtprTctC9oel91g0CLCZhiLyt0uhuupmQIyy6n45zhzXwroEGYKn8Rv7sNkMdoxq1HJSvX2pO3IRD6TKxqUgwAZQyyvV5TVjZBubOKoGOwwfjajqWSLj5uGHUQ4bYWOPBbQQKD/GLp3IHX+QFIYK+05CptxHvgos9R7z34S
 f6mmB6Mw
 2t0x4AORJTmEiUby89n2Myd/WEW0FK5TS4FRHbTH5lwzRAPfY+Ih8goKjgL5lnfJ49c9PvZ3ICZi9osHVPVzOlgJI5SWB70wIAnjti20mgJtbeGvZRsYdLy9G0hYq32A+ycvYG8gKMgNM3DnLNTfHJbZDB5MzQN5FzRe+dGubNPDOFHpNyXVaxIQZxZbHDecowGnqQC24B3z43KSAdhMsS7mchXr4ATdlmV/WxLUQntdfyGXCpH5bamaGuyj4AmXlf9gXi2agVK+pV09RcO7hu6/tyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ying,

I instrumented the unmap path on both kernels (kprobes, 55 s windows,
same workload).

b99a342d4f11 does what it should.  On the patched kernel, where the
old PTE can be read from ptep_clear_flush(), about 96% of the PTEs are
still PROT_NONE when try_to_migrate_one() clears them.  The flushes
come from pte_accessible() treating a PROT_NONE PTE as accessible while
mm->tlb_flush_pending is raised.  On the unpatched kernel that is the
case for about 42% of the migrations (3.5% with the patch), and each of
those does a full arch_tlbbatch_flush() to about 380 CPUs.

tlb_flush_pending is raised that often because of a loop.  Each batched
unmap bumps mm->tlb_flush_batched, and only flush_tlb_batched_pending()
marks it flushed.  So while migrations keep coming, change_pte_range()
in the NUMA scanner does a flush_tlb_mm() for every PTE table it walks:
about 11,600 full flushes in the window, one per 512 pages scanned,
and 99.9% of them come from that call stack.  The average mmu_gather
in task_numa_work() takes 91 ms on the unpatched kernel and 6.7 ms with
the patch.  A longer scan catches more migrations with
tlb_flush_pending set, and more migrations make the scan pay again.
With the patch, a lone order-0 folio is unmapped with
ptep_clear_flush() and never touches tlb_flush_batched, so the loop
does not start.  The remaining ~13 interrupts per page with the patch
are the same effect at a much smaller scale: the 3.5% of migrations
that still overlap a scan.

So the patch helps by not leaving a pending batch behind, not by making
a single flush cheaper.  I'll rewrite the changelog to say that in v2.

The loop could also be broken on the flush side, by letting
try_to_unmap_flush() mark the batch as flushed.  But tlb_flush_batched
is per mm while the batch is per task, so I don't see a simple and safe
way to do that.  Would you prefer that direction, or is the change in
migrate_folio_unmap() fine?

Thanks,
Zhiteng


