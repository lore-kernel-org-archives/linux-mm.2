Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F909C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDDD6B00C5; Fri, 17 Jul 2026 14:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D57D6B00C7; Fri, 17 Jul 2026 14:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0536B00C8; Fri, 17 Jul 2026 14:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C52AC6B00C5
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:22:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E3094020C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:50 +0000 (UTC)
X-FDA: 84999089700.01.938E832
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E1864000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQb0NqBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUSSGoClEIjzcszURqrS6Zg8fTue7uAoFYyLToW70HM=;
	b=5i8weZec6RQJyOqBGsMxdKcW9aFw/S3dtRY7L48AWKbG3Qr+Dg4k+7DTEJUsT7OnsmiENO
	fvgw4YYBBvUMdZUCLbxxEyRucwJ7/NQrBG/itavx/6h/14R3OzbxWuI764LZ8fKqffVqtK
	MRShuVZ34oUTFEgAZUSynd9oLmuDn1U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQb0NqBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312568;
	b=0AbNoDo7xDEPhSb+6iIVyK0t9pkO/cBBeeingvnTSDAWftmYffDqJNOcXbNPX8fzR8HTnM
	yIeWdCbEvSAC3gklzxg5dZ4HlS4TfIXNfAkjH7AW5rMREp4h+hu0xhuLGMr6X/4cJRjvha
	dah5IB1lurDJAy//t7jAVcQ8RxI5QPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE12743F75;
	Fri, 17 Jul 2026 18:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D8C1F000E9;
	Fri, 17 Jul 2026 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312567;
	bh=ZUSSGoClEIjzcszURqrS6Zg8fTue7uAoFYyLToW70HM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cQb0NqBCHQGHC1RFzL4Kq1JuN+fgnh3yxUX3z9TzKhvfgzLhXPkosagslKQGpb6ik
	 jBM648jP4hMwYdweCkXVfjisIz2NgT6YNfxYnF4kza07w4Lf0PZ+TUeW5Sk8g8Pd0u
	 2bW2+mOyJN1QFVP22fB7jI8AGzEQ2pCS8rTpVg+2udEuBzyC5Iy6+DkEx7iKPAMCZe
	 QWv5IHzNgQN6mfE5qeCXeoBpGYK5ujKOAoTCPH8wIpGSRtgU0N3EpRd2jqdVxpFxmb
	 EP/b8mAoXtCira7rFVJ0wp0C7OSakTTEj2eGUOiOtWY/R20C+KLO8wlSfu9VRRe3Y1
	 RTHy+SMU2k59Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:42 +0100
Subject: [PATCH 04/15] mm: update print_bad_page_map() to show virtual page
 index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-4-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=ljs@kernel.org;
 h=from:subject:message-id; bh=T5Gj/piAc/UlxcCiA9iiJMiRS1jgA5HHtjYX3YWMzOQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZaFhx+LXA8WfhVkt0Hq1l1+dZVuTueldzvOJmpO
 i9p03mxjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzEIJqR4cS79waejYfa5U85
 d6TaKbms1DtksyqP60vuPEkPlWlefgz/vc4vVDhzVSJViO1zmTKn5o3tHPV3ln7+U9xzdp9T09c
 yJgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ch1imtjuzastdgme51wffcexx4engczc
X-Rspamd-Queue-Id: 6E1864000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784312568-173045
X-HE-Meta: U2FsdGVkX19Y0HN88Y+k0UxzW/W9/wODXH6WYDNas67mErmgx+akMVv2fqrvT0lcosJh6X3/uAmL5cBSJt0/keKF0Et2HIKsv4IdbArt+C9ix8VdEC5DwxaS/fwozcBetktYgQ+3zEpzEwNdnroCvvhNv4zPJMbtliyB8ohxYFaElD8reJWGvGHXDJJ63fKqfoRYFj0YlwqCx2PDt1/ZKs92r6s4vayYCP5q/GAjj1WyoGpo8Dn+/lwAp6EJSWyXpt1fYe1yHWB8AdXb2moAHcZTOF3KKD8omVEys6AWX9NjWUnue4W7f7LsIt60Z6IChty3BJDcGCtqAvXxKGSK383aSscCPznZx+ponTLwtAnjMxn2MFIx9UA7pCOiPSaYqw7jReyuJiHq4JM4zkgIh/FJiNc4xmN/YXdrEleBaas0gk5IO7WJgH/BdoxKIITSj/heZVC0kJkEFTZvVi8kuChs+n7cmiu5td6uAmkbO9xDEPsQh3lWIYzzavYiTZ+i4qF1toUPprm3r0kFz/hku0uQ5+lBVYaMVGUvwcvMZld3XG4ZHjU7thkluQX2h/r1nFHEtePNeefLAiwk+dWxR9Mz1dlgJ6XXl/cWDgKdnovfHndSzUHWfvAUXHhGMA3dorjyrLgojbceImhYh1784lhjhnR6awutFuvItTzR6FSsbOOzHOWO12dx/qUOVz7Df3XGKd7FasQPdrpVNLX7TIv7GC6vdxZ/HjTzelqfdBkgmWpJnCNfocjMmUGxZNA7+B5FrXktcaAYDpOMg5E6CpSgScma02qpmF+fHYUKRK3xsOd+gqGYXTWXCYlx9acEPZ1NalEAKmdJq8Jw+Fuk5caNYYMv0xE/o9dwX7sQnFe1VepmxmBwnARezWCZ2uZID2wr2yCIy4GsjNqzgjoTAmeWu126iEpwsst6Pg+B/lhkmw/rNWw42f7fgoOxYrWE07EiWiW+UXep/sMBOzZ
 lmChh/WA
 mZ4sEFO5Im4uULVzKsS8HSWElPAiybHB//cFVDHLWWMvryAhfhV5ScmNvod4MiuB0deLEaLIWPlrXzJQ1KLvfrbxCdunyRG9RRVWVMQhvrn7maZMT8wUASYYKVi4QtWKGZRvSUpMqeYchWZ3VLl8i5ihrHYtuIBOG4nP0KrwA6wPBpckTJ7fei0XiosU3wUoGLqV7ph/dyHBktkJn8jfO6nqhbB7lnaJJk0q36+fZarO/fa/qobFgokrk9/vQvSfB5Gs/DfJD1FJZMvZqxdb/bqyTbQ1HWj2jCLkN1vsO/kQ9NxdYoW/IJazaDKwdhQFV2wW2kGmmDILr4OQtELMPJrnz16qmTb4vA5auHVZOFH8NaHFMFmpwTB9ulQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is potentially useful debugging information and matches the existing
page offset provided.

Use the raw __linear_virt_page_index() function so as to always output this
value regardless of whether the mapping is file-backed or not.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..56b244552f13 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -631,13 +631,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 {
 	struct address_space *mapping;
 	char entry_str[PTVAL_STR_MAX];
-	pgoff_t index;
+	pgoff_t index, virt_index;
 
 	if (is_bad_page_map_ratelimited())
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
+	virt_index = __linear_virt_page_index(vma, addr);
 
 	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
 	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
@@ -645,8 +646,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx virt_index:%lx\n",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index,
+		 virt_index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,

-- 
2.55.0


