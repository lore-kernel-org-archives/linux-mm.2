Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF21606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB196B05B2; Fri,  6 Nov 2026 05:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84276B05C4; Fri,  6 Nov 2026 05:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99876B05C5; Fri,  6 Nov 2026 05:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 961666B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:09:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81C491A0D74
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:09:38 +0000 (UTC)
X-FDA: 85404272436.21.9A7DEF6
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7539140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:09:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8nYPHZ5sRm7H2t5xmzRj8iBg0Moiw8TSdKlr7ve9cg=;
	b=PPXwuBMckrlDzFn6G1Anbei+WQsK83XT5s3OYnt9yPO7DQY6d78q9+YyWQoZtw8JYuB1EC
	xnTzg/X+rdyHA14Oa7FioLBX2BeEJT6MPoycfr6LkmrRqHkupDLdF1shjG+P8lNuKmkE0V
	GYnjoC2qP3aKVGO/Z5EX8m1mbbK4+3I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959775;
	b=t5J903UX1sFK7U8QrUWUkeov6A/ot5g3Xywjk4sKyQZpuq6Gua9J36MdmFNGyQZ7u68on+
	uWUnNNGyX2ufZ1LqmiO+s83CbZv0SuNdvmbLrTemy3mQYIKbkqAbhwO8kktM6ssiBDNIcp
	Xfnc9xD9tNht7X02TYmI/tjJHMgEMg0=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLZfH0c5MzBpFyL;
	Fri,  6 Nov 2026 18:09:27 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLZfD3NTjzBpFyL;
	Fri,  6 Nov 2026 18:09:24 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 550BD308158A;
	Fri,  6 Nov 2026 18:08:46 +0800 (CST)
Received: from ws.local (172.25.64.90) by cncheex04.Hygon.cn (172.23.18.114)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 6 Nov
 2026 18:09:25 +0800
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
Date: Fri, 6 Nov 2026 18:09:17 +0800
Message-ID: <179395975709.1235605.1971486611419119070@hygon.cn>
In-Reply-To: <87zevmwbaj.fsf@DESKTOP-5N7EMDA>
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
 <87zevmwbaj.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7539140003
X-Stat-Signature: iqdju5ffa3kzwyec8bqye4ywes97jeya
X-Rspam-User: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793959773-735563
X-HE-Meta: U2FsdGVkX1+1TdrqdmKicXJT4vPCsy/AKaBBSkeONQw2wSArXhbmxLgcOuek7YBLwcQn5mX50dRwHGt6PUi5/ET5WfB7HNCw6XCuKguIzNkHBGMIEyzQRiD7rnur80oPGktI834xB7stqL0Q4Z2w7tyKdKZ6a0GZ+AnBvz7SGFw2MUC3MsDjFGvux54lblqMrjR8z0IF653es9s0Yz9gZ3BPKlVPWSotbeEokRXlYhY2CofeIVxD3bE4Hf5s+d9Xq/6VyhsvYFD+0D35aSXZUfo5q5A6iPFfwZ0rnIzRWWZ7bCz9pDIBn3ikKm8QrD2pUvPHuu2Cuma9h8F8UOa8+t0zu/k03Hcm2N3F0C3kOPBiGC+lFKraN0H07kznAEyWYAnsmoC1McnymSP9m4CWgWI7/NcojUjW70o7qCxjzg4nYsBstXlC9RCFwT2eOF+M6BXibPiFMn3IwdKOEbnwEFnzY0N9qAd66yf1SlZSs619mt4QP8sXx9e+S5/ndTobVtyB8Xe8gpK+C+GgewRPdoWTsxFV00hlM5HISjW9J18PP0P5zTdAjFUi+hrg2pYjmQaDRNr8yRordSoMtVMapmL12yMTvz4SdocFmKxx13XAAFQPN91nK721zpbu2AsF5QL44rM8tvIPnzPfi/bP+jRf0W3XKZx1vIxwCXE1vBn2Gec6GV2Euy9jCMAebAS8VN1M2A+Az3WpAdkbhZuvOJSTBEhSxzHH5V4dDJuz4Tq9XCfSb5cvB0zrsHWUVRMkPFJWKXEHcmivQRuYRt+x7QMv6dLF0zwGIMSu9egwT/4JFuPz3xcKYYd7YADUumLXtJEF5rfUFqmI/CliA4MPs/KLEXMroYAVXqmloyOW68MdvC8hOVGUZqgScDqgW3M6b7xYQ0z8HKJC79Zcir//d+JeNyKfd30yEktSjD/BW+GJvfmjGbrlrb0jY298tVZnOzgQ7ydkV7t09ermvWd
 i8wmqShW
 MLmuAwCouwAw2A9S3nFvl+oEF+79uOl5RE5q0HUcQTAsdyQt+Hop31dQis6J7N2zA8iCV6KEwyQVC8+iVXyndC76bxWVbJuD56ynKOAYQp99J5c4pCf+MlBkDofd/FkZRARcnzCkDqhJ+TF+hFiAbxI/1WnT+lyQDbkoVusRQe8aUUOzOEszUUU2bJeJ5iEwifPwwp+XYZ/+cFvM75NrdPuvRGlX1C2iDLIYui+bCAwNqTTYtZ+ryWrI/UGIxec5TkWsFxw/oyzNq8TF8tGSr1JIHi94DDtqzri5lDYWmevTVg3kcazek+gVBXzO3YxNkTO6vaQ5zD/+ayKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ying,

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:

> IIRC, after commit b99a342d4f11 ("NUMA balancing: reduce TLB flush via
> delaying mapping on hint page fault"), we can avoid most TLB flushing
> caused by do_numa_page().  Could you check why it does not work?

Thanks for looking.  b99a342d4f11 is in effect here: on success
do_numa_page() returns without rebuilding the PTE, so the PTE is still
PROT_NONE when try_to_migrate() runs, and both the batched and the
direct unmap path should skip the flush because pte_accessible() is
false.

The numbers disagree for the batched path.  On the same workload and
setup there are about 200 TLB shootdown interrupts per migrated page
with TTU_BATCH_FLUSH, and about 13 with this patch applied.  So
something makes the batched path flush where the direct path does not,
and I don't have the answer yet.  I'm instrumenting the unmap path and
will follow up with data.

Thanks,
Zhiteng


