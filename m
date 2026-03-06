Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436AFFCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4B56B00A1; Fri,  6 Mar 2026 11:06:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6196B00A6; Fri,  6 Mar 2026 11:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0D06B00A4; Fri,  6 Mar 2026 11:06:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D714C6B00A5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5A861A061A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:30 +0000 (UTC)
X-FDA: 84516115740.22.B0BBB76
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDBB5100016
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=vTrENs8w;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDE9sNwpvCyHqDBgmu8oAPHRFTOTnIBx1S/VGmZEjBI=;
	b=KJT+gbPhiCbbd+Omd4EKPqWUyirlxMNW1o49CmH9mLH8zpO81Tb84t1AfnDcDlrWRmYs5A
	8ZkZm2JG8PPi9JvvW3PBLrITr//XdZgT5AqbmcmQQy/G8gyBXMSHYUCeTap3q1U8rQGH6o
	DPFbDfEms6zw08QVmTEtMwkYRivy20g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813189; a=rsa-sha256;
	cv=none;
	b=qMcj4oaG9L9Cu7RigiCfAP0qoG9X+hQ9wTFSjb5VjjuvZgRkxMCqRgOKqGEJ2C9f4D+VYc
	xAv5lEyxl2XXBp8i+m+cwZaNPiaRX26P7EPKQdjcqs3zSiIHFhZT9np94HnNH9BfQI7Mo/
	AlmF0MFf3IvZphknUhhsfNL68lBjpjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=vTrENs8w;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1BF0FB3450;
	Fri, 06 Mar 2026 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813186;
	bh=LDE9sNwpvCyHqDBgmu8oAPHRFTOTnIBx1S/VGmZEjBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTrENs8w9kXRwhEVqSh1zTjuDl4Cj/Lj3M9bIixdpG6mDhxBorXg/9Q58IGyVlYsn
	 kzlzgs21Ol9eIA3Tq+uXIOl2z/9uKHU3mm+8cSjAuU5utPa299/oRc1QxlpkG5SX5/
	 rhuulyKbGbbS/UvCwwjBCvUzDC1mfcd0llmJ19Cc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/8] mm: use zone lock guard in free_pcppages_bulk()
Date: Fri,  6 Mar 2026 16:05:41 +0000
Message-ID: <15d66e640ad30edea62247e7bcd98ebde05be0ff.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EDBB5100016
X-Stat-Signature: obbrytkmgheykmtmy14i7easbmam89di
X-Rspam-User: 
X-HE-Tag: 1772813188-255304
X-HE-Meta: U2FsdGVkX18W1F2ADqwz1d+cZAXYAzE4ufWOoNKNP7xvsKaUDteZhPQeb7i2so9ZglodrfeRWiYOOO65S/049ZnRno/Fj8FCB8j9oaE7wr97kbgqQ6UCjl7F74eBqGqW5f6XkBxFJxS1/wsAimV2mx3LTH8+a47o3p6ISKD6Axz8sxMqxxHgujf7a453hjjj3XvekpCTNbXfURMBfXwLtKG1kI9/CW4r9Pqw1YG07hhp8141nPQI6J5i/cQgWWuNTPtdVgtgdrL3L1RJ8Vm0fRyQaTXwMMy7BjUdcvNhkgFLhGzkuXjwZqA1zkEgsZCky1hf5bXtJ2wXvUPiofWqnwOkPk3UZenzjleYhE4loBVapr6AZ4v9ROXU9JT6cIdVmOS94lU6UOluegoqqfuvpbqLje7ZoXHTMhd6iD07WIaeKTmnFFoPQJjGnF5Kvwtgcv/r1A739sU0VQFIVCMvcf06JIS1D7D+Kv/OEKXRCAmJXosX9VGTETq1GftJT6YlNkftrvS8f5Y41lJXo41sN8dSnIgVmg7orNvaLjFyg7PLBJqVH+uftzoHkae7HoaUdth91gI69bKpF9mmFPZ1D8/7FVCNHl+y13yC9F1qGk5W3Y+nghlJNmtwBG4sQu66Mj5QdeVB9Rqb6Ezw+RZ3RQ9a0Icov3cwBe6ctCRn2VvMrCacb8EwCz0biyyKL/xkXnfy+zeMNp5fX47yKQl0N9Lr6K3+TITp0ReZbB9hV6Tn7TtX4YMUL4aUcVFR5qO/yl3ihZSg80uL1NXt6Aj3nAcnNXpchlzYq/WvWrtq2nIWcuGWuE6eN/lLppgFsFwwTH+mlah9rJfWWewQJQGKzEsxQ1YzK/1SWtUeB3dsqp3H18Vs0I6PtVsJGOyE8gXGBa2J5TyTUUorG2lWJhVBopJqKAWRgL8PcB83S2W8whEJs7ZC8QaRNATn8v4Y7lo0N+d7K7gGdZeLpPAGeq2
 cxoYof3f
 ezSIfg7h9dM14QpsigKaLwrNaQyXWE3cULmNpgFFnAWo7gvPkXYYBruqsysCzxah2K7VU0N89Qt6uS9BclINM2rE6ilIeRRWLioIjZKmyMQ/gWyQEZMe1BS0txANIHVdFXvrKWzv8oDCOs8AmCpSmMT50y37UU8GCtbC4UQvI/QUWF32PFt9eXxGmSwEzPVTnYFu1GS2FIOpEKsoNSg08Ski8dySCS0oiguHYPul17OQJ4aS7NeIQ8JnU/WR6qD5lvOd8sMQ+bgmJT3XMzRUe+snQHakUfEz0M+A134lal+yCWi7Mw5wMsyYaZ3rjfZH8NurIEHmCuMU9gTiKx5BJLK6zlYosCoJHVvbbdtKdSlhNrWvEEpY+ShLjMyLftXsnUVmA4tn8kZHRaAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in free_pcppages_bulk() to replace the
explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 28b06baa4075..2759e02340fa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1455,7 +1455,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1468,7 +1467,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1500,8 +1499,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	zone_unlock_irqrestore(zone, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
-- 
2.47.3


