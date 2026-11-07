Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEA8606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 11:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19556B05B0; Sat,  7 Nov 2026 06:08:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAFB6B05B1; Sat,  7 Nov 2026 06:08:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF166B05B6; Sat,  7 Nov 2026 06:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E47C6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:08:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17F391402F6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:08:42 +0000 (UTC)
X-FDA: 85408050084.13.718735A
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF67D160005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:08:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf08.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6dE4Qc2basO/b0AjLfl4KhmoQ0CUlCYVpAq8NuxGkU=;
	b=PQKwMzTTO07XO6MdjBKGqlQHTpmkKl3kKL0WOZAP3nCB07cfXuIGiSxf20It9jmdQ5snZK
	3AryvSsOFvhMj46/e2hk9984SwEtTDaEZwFRzu+cQ8zKg7yEJds/XO/kmu7KaR+gxRQBe5
	03hz0K+5y4TXkjAx4b4GKQjOCCJSWXU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf08.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794049719;
	b=vcB4TazRfJENRkdvex5HMAweFJ0xOmkurWybLblKpOxzl3VsaPI5wCuwNIQtZg8Iv8LeOL
	o1cfrpXm+Qco9p6JSVC2egij0pHhwySxOuXekOH+raPRjohxg4voawAfVLQdCh++zM+5mk
	ICtTZ/VX7bwTqsRfdMttXT07TUupGaE=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jMCvs55zMz22Pn0;
	Sat,  7 Nov 2026 19:08:25 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jMCvq3lVSz22Pn0;
	Sat,  7 Nov 2026 19:08:23 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 7517030A6439;
	Sat,  7 Nov 2026 19:07:43 +0800 (CST)
Received: from ws.local (172.25.64.90) by cncheex04.Hygon.cn (172.23.18.114)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 7 Nov
 2026 19:08:24 +0800
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
Date: Sat, 7 Nov 2026 19:07:37 +0800
Message-ID: <20261107190737.1538200-1-qiuzhiteng@hygon.cn>
In-Reply-To: <87qzgxw2qx.fsf@DESKTOP-5N7EMDA>
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
 <87zevmwbaj.fsf@DESKTOP-5N7EMDA>
 <179395975709.1235605.1971486611419119070@hygon.cn>
 <20261107015057.1328227-1-qiuzhiteng@hygon.cn>
 <87qzgxw2qx.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF67D160005
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: nkf9mzmj9dkzno3cuh7eqzfb3c61ynkt
X-HE-Tag: 1794049712-182819
X-HE-Meta: U2FsdGVkX1+3fIGWY5IS3S9tS6zPZIfbF3KLwCBoYnqjnbESSUJmf4KB/xa7QjtjbrlyjBzzw5NL2KtfPxGtH+e4bLFo+loxaUAK5JFE5jNd9BDuKu8BbbO7A/12bKXqra4/lvdPAafdITMCwGSwzgz0XPgTHZZNW1gzv7oTSIoNLbG7DtU3a6mqjkxH6oYWciklEIK1TtbE08G0ULnrN/UIcuWu3bSHO+NlJYUE+pIwDRJk64fjsrKyt9tX2OgB7i9899chKEQwQDjl0Sl6RyZ8oX+W3beouYiYNCfc+9CcpbqgMAw6d4sr5nqMk9TzukapEeZBH5irT6U+UL9G0I93cnQbXqYcn2Dj3+TZC6iXtI5S62RDPCZxCjcPAT8Ajev6Pt9MZr9kYqQVgiMvqU5khRlE2taDP8hq6k9s0cZCIM+8DsM/Oksh2oXwpRZ+tpaC67UN5n3aAKNrjhad/EirbHujxOGatcf6xOxHPxPm/FGJoFb4SJawUYvIpW5b4reHgj6rAuaI8Wjrr7D7kgbNYS+iM5/zOBxQfNS0hUbMFfW11CUl3xR3fvgD7FjYF/gsCDlDBBcmRcnB3Htjey29TemDLc5nyy4PwBY31iTPR6gMxBZOllBw8felBufO65KucAfOc6ufigIVA49RU4W/ylBGlRW8QIuwLwyGETKlsNgrbvWQ4XDpg71DATgMY8QI2XKNXyJuI9R33X5dCZUNp1RyhsBTcz7yzkY53oulETK0dPWT1x05cbEzatQpGu2VJeIycJlgGu/wz7Dcm9J8LuI9ZsCHCSLRqPk8FCj8alxva3LUI3+M0dTe2r7v0VZW+AS3IT4BART26VZZwpJOQpJYKMB7i5G6nMWqdsMOykl/k66YdXWtDZ2rNSio+tHX0iIIXSSpuUybiSxXL1UsBteME52oYpLOEFfUgU1fZi7YCbQ1lnYOYvFd7Cra2eQmnUH8PLPF2q4ht7n
 UyDjqAWG
 hrW2dsN60qOCCwGlwARVmFq9OSCUt4ae4IeK9vbT+idbQQOvlSN51/O0nx4viEpa270+MW/YqKLMNgJ1oARYfKqqGjiLG0QVd9ho8VjMxFe0YM75Lnc5kTkjP/vCYEzWHlGwF1+mAvqNEWqu50WUyl+b3Br6BfifzUkCdOzRdRLxmm3Ykye/Mh5dKPmXGVNyz/cFb88wkhdbX9mvGML5GxrvGCodA1VZoTWb5EkILVy1NfZ6ZuyF2VchEUyJ0tY5JD6NVFFsk1wTvGc6M3pc6sPNvGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ying,

> Have you adjusted the NUMA scanning parameters?

No.  All NUMA balancing tunables are at their defaults
(scan_delay_ms=1000, scan_period_min_ms=1000,
scan_period_max_ms=60000, scan_size_mb=256).

The scan is indeed slow: 58 passes of 256 MB in 55 s, 89 ms each,
about 9% of wall time.  But the hint faults are not spread evenly
between passes: those 9% carry 33% of all migrations.

The faults come from the scan, just not from the pass that happens
to be running at that instant.  Of the migrations that happen
during a pass, 60% are for pages in the 256 MB chunk being scanned
right now; nearly all the rest are for pages scanned one or two
chunks earlier (lower addresses, within 512 MB).  None are from
addresses the scanner has not reached yet.  So the scan makes the
pages PROT_NONE and the workload touches them again within a second
or two, while this or the next pass is running.  The collision is
not a coincidence between two independent events.

Here is the sequence, one pass on the unpatched kernel:

  CPU A (task_numa_work)          CPU B..N (workload threads)
  ----------------------          ---------------------------
  tlb_gather_mmu()
    tlb_flush_pending++
  change_pte_range(table 1)
    PTEs -> PROT_NONE
                                  access page in table 1
                                  do_numa_page()
                                   migrate_misplaced_folio()
                                    try_to_migrate_one()
                                     PROT_NONE, but pending set:
                                     pte_accessible() == true
                                     tlb_flush_batched++
                                    try_to_unmap_flush()
                                     full flush, IPI to ~380 CPUs
  change_pte_range(table 2)
    flush_tlb_batched_pending()
      pending != flushed:
      flush_tlb_mm(), IPI to ~380 CPUs
    PTEs -> PROT_NONE
                                  (same for pages in table 2)
  ... 128 PTE tables, ~0.7 ms each ...
  tlb_finish_mmu()                    pass took ~89 ms, not ~7 ms
    tlb_flush_pending--

Each table flush makes the pass longer, and a longer pass lets more
faults happen while tlb_flush_pending is set.  With the patch the
migration takes the direct path: it may still flush while the pass
is running, but it does not bump tlb_flush_batched, so the scan does
not pay per table and the pass stays at ~7 ms.

> That appear too complex.

Agreed.  I'll keep the change in migrate_folio_unmap() and put the
sequence above into the v2 changelog.

Thanks,
Zhiteng


