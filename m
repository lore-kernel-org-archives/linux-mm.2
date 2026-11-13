Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B6A606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4P1v5TT
Received: by kanga.kvack.org (Postfix)
	id CF9D66B05BE; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AFF6B05C7; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86546B05C8; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 782986B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04D62A75DC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:41 +0000 (UTC)
X-FDA: 85431380202.10.B509122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F047E20007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4P1v5TT;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605199;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RibFmcy43zDpCGtfntgboZ6WXlEHO0X8D9N0FndJ018=;
	b=FvDjMUSEWnTM7w0RjKMW0mT7scYkPAcS6WnZJMqu3VrnicNVLgVrHscybedVeerEI71FBS
	Vo6rw1IrqncLz38Kql/68syXlQYno34zWO+fgr9l5Vr+I/64osdMZYW8PLvQaDum7WeWBu
	MB4mQt7jdsIvDkAikJDBmVEgV5SzCNY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605199;
	b=2CVh8WFFKTk/Ad0Pc5UmI2HN5NyOhC2PY70mR37vgzJo1XtHSgwn8KlfwJ0FBpKZssvwiN
	CfCEOH+AFmHcvOMYfzoXc4eA2/Ey8npijPbglgUGJ09NFm6Fik4KeDwqltosA0kIn43LBT
	DoVNvXkT91x+DX0iYUQksp1k7fh5+Lg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4P1v5TT;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F11F61CC8;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605198;
	b=o8769zQxwdSCPFlJaeMXLxun2PYeLLc7SxPYKuZSC88BR4CelzQbK8le/fiAQQeQlUX8
	 pHb9LDu4Y1IW3YTKKavvGxBZK/a0ugsV9eDRK8be7qVIgMVDv5myu3bNrp0YD5ho3jIfA
	 v+Gx4Naq0IqSaYlg56MG1cTiwkJgnFJFngnzaeTyPMj+MLBwvW71mxVFJ/eSffKAkHS6A
	 lU9JERntwlzZ/r6uLSXI7hxX/coi3njmDqK6qh0E43CyY5yL4C2L/rsjNFWh6nbme/QUH
	 nvAK/8nu1hQm0n/6vXcwoT9hK3AtY59+dP4PQoOuRkLG55Nj9zWZe/pATftobJm9UoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605198;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RibFmcy43zDpCGtfntgboZ6WXlEHO0X8D9N0FndJ018=;
	b=dxVuMo6NVwjJr4rw6nukIQv1VzZO89R6Ovt7GVM2L/6xcPJgJNlHVjON8SBU859Ee1J6
	 UQCO8Y/O7mFBINDj1Z8bCY9A44Yqe+F9BMj41dkVaUDNGwcvgfamaVaiJyExDDHS5/guv
	 kMTAHQqzZQtfpwVzvtmFC1RtycUUQE8uS34gtILdlRz5jN3o0Ey+SnGIm2Rhv11VPAXvd
	 CzmOhDM5/qiV11K2mxxcF77D3we0fpPrJ5NCq5O5uGVtabtgxLCKS9tPBev/KBavqIzGt
	 AeuMzs/VGJn42N4D7HarIgsloV7+HB7C0uihwXuDtuLHxfnKy0VGXZ6qBBEdDGapNdw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8F4771F000C7;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605198;
	bh=RibFmcy43zDpCGtfntgboZ6WXlEHO0X8D9N0FndJ018=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=W4P1v5TT3rxVYDEHZbq1V629SuhWgkBhc5wEaVdESThR+AiZKQOke/7HJF7dTPEo2
	 MSYLc3T+TaATjoPR16y01jEtIJwpY0qrHp+1/Xiq992/sUEZWktFVd2TGXLbAEag1Q
	 TwFuX1GzgzDJ/nMqFS0rGZa0OufHO1aBhxLvmOvF0Y/8M9y8T53fdmUque5l+1DpQ/
	 QzVKbGGZRrAayt8jj7VOlBB+H73LTzv/w4p+gNXC+TWTIwiFjr8e/LsNJDaxrvK/gy
	 90Bh45/EVkzwwD742ZXFCb84ayTUwJuPLiwKvpgbqKd4YAuM+mE0ujQ6xCMHqLi3gu
	 qut0SJ+HD6XJQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1AED949B1A;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:19 +0800
Subject: [PATCH RFC 3/8] mm/huge_memory: avoid an unnecessary folio size
 reading
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-3-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=764;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LmZMW4ryeSabpn9A1T3iIoGeWriFohkqBblDlYZuq1I=;
 b=4fw0LMeSbz2l92yW9mvBPwE3Bk04f4enplJroZxhcwS0OJz+aB1OBrVwS0CwbCV0PFM4kLkng
 8P7TF3DT9z1AcN67GtLPSjSXQGar6Bv6odbdrAeZEpSgq81WlJQyTNb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F047E20007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qdn5cyxp3fcbkmkxz8mdj9mci3n1r59z
X-Rspam-User: 
X-HE-Tag: 1794605198-322678
X-HE-Meta: U2FsdGVkX1+SuCbmkZeSf4Uv5oxJBqe/kQd8vV7Pnyqc1bFe9W8jeKINrZ/VmRUl2lhudG8EgRKgnRxuuWyMBwrFeF9pHtf8T1m+aWFD28CRRMSHG8Pir3jFCyvyUngIlSNNRhZyPjDdqiXHM4l64BRDwvlBbV4yUw/jpD+nF+DCZu9WqabnJ8GepPthszrADZfCtiM+pfc2LqFYhCRX/8sI3MPlhCFWDx3vKRg5UUGUs21XPKqLoIDPQTSwsWsDQBq61eIqUyHD8t4MZweFa18a+9pPR0Lhh7vws/B00eDMg4RduWSohBvMLjQRX2nP24nFbW+vZar+zwWxUbtyqu3EwY24IMCjFa9kSB3jHaoBcvE191LVv+bNBnuls54TOeA06hCpqEZApv3ivilyiVuncfXwEY9qYUxNJJKQSA3s18jZxPG9ybNDP5AYruy0z+sgI8ztvmxuj6NkuTgzR4DPtWC7sBJ3GNMq5ywEQDXft+F2Flp18C6wE4ADbubgxPIApJrQp83pVtstQqHskoGnE7Q1bseOtQmk4YGpAAZRk+t3vgp3E15Mm+/CCghj8s7ktPCd6VW/RBb6e5c3zH7SazR5EtxvZQfQZ/7cGE6R2uQ8wXUnO7lWks+TO/cF8z8yJjvEfLdPywBbrUQ7HZFICpF73kZ2qj6D0wSEEbgITeChIA/NNMP8UuLA4HIT73wNCL9taGiOks6TrvJoxB57zDYtnDeI16IqEIw5rovk0sqiQYqS2htk6lzG0HOTdwGU5hLrAOytl2lZ5u6Xa3GmN6OtYEF4OUpKWPV51CDOzi5IBImJBrV/KcspiXgIgQrb4yRgEthcDBukuFcf6Z16QZADAdx5m9ap3J7HSBe6W9O3wQ6wcvKEa0TGj8Km2xVzWHbovG7jU3lYZz4sYqXEmPsMoX0BQPRQHr0nK5w1I5aOKJYtwjvN7xLE2PDFqjqbCxvfhuMdwgp5HHP
 k32I8DDL
 SFSUhzPisnWfkKv5YEYv81DVmtutUacGlodNoLPEjAuptA6aaBpxyKTzI40hq/of8YB29A0x9cNjP9+J70OXqBRslVWVGpFQjbC/eA3t2jjJThFkBxeLYmWZk3rnyTFQZ6/etJKSrgPGGUUe1yhrfoKyHUqeXK81c9ArpRux+NC7h6zhndFGV2XnW8SpIUzQB1XZfW1Iozrff2mx1V85loepYaAT85oGh2XI86EuCSmKCIAS9/x4nLXVuT913ZPMrDGHm/m2uWvZWd1ajBKS1GssqVSwDSPWsSfirhD203kM6ZTls4iFBIeJGqsgFHkupgp1TFxXcOR5BlvG6L2ZFilf04QSUV/ShPZggJaiGb7anC81Vjv+adKnk7Qazf6PVHa1Ag6RWulwle/AE7oc+Gt6YnoTcr3IiFsY7YpRxcYtQineqS9v28km1cJ8nyc/kTBgpAlUAxMfAV5MuDKU3x/z8r/mt5IAiYIhmwctHG4jtokOjUh/hMGbm+uAC3YJkyTuAnUL9/wzz2D0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

We already have that in the local variable, a trivial cleanup.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..b60fd73fe35c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4287,9 +4287,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		/* compute next before the folio can be freed below */
 		next = folio_next(new_folio);
 
-		folio_ref_unfreeze(new_folio,
-				   folio_nr_pages(new_folio) + 1);
-
+		folio_ref_unfreeze(new_folio, nr_pages + 1);
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */

-- 
2.56.1



