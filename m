Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254B2606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgDoB7ON
Received: by kanga.kvack.org (Postfix)
	id 1884D6B05C7; Mon, 16 Nov 2026 13:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139C86B05C8; Mon, 16 Nov 2026 13:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029146B05C9; Mon, 16 Nov 2026 13:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA2716B05C7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 705FA4027D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:43 +0000 (UTC)
X-FDA: 85441825686.02.2C7F75A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9AAD520006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgDoB7ON;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaQX8RZ+ZLg0aNvmaH+LP+wUFJzV9EAHnDvW3aVzvPo=;
	b=tF0UKIYB4BE/awtwxxw8TQRGFW6bSWbUsCLVJU26ZwP23GHpxRx/sfQ/DjkbC9rjfZ7iWQ
	Mbo8WHzFoBB+t36Hv92xNZp10orZDuJbh4Ch2zLjunRduc3xE5fDlLXEqG5omnx+VK43xo
	QhHcn7N0R2xttmUR38Oxaa+36/d/5Cs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgDoB7ON;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853901;
	b=jJFLIY0G0kVg2gJGmHoEIOiMdFTjtuZiaz6cQimfpMbH+J3MANp7EQt1kfRg7S5/dO3BVC
	2RZRcdJ5yMTME3zervKknNTh9IP+XxpmQavHw23pE1oFCjBBcjXhmuO0d94iKhXP2JGqeQ
	OQjUQfE3AQYZGWgnGYBdnBlHx9QFnVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8DC64664F;
	Mon, 16 Nov 2026 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A06E1F000C9;
	Mon, 16 Nov 2026 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853900;
	bh=WaQX8RZ+ZLg0aNvmaH+LP+wUFJzV9EAHnDvW3aVzvPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FgDoB7ON49lGuWa7wmkJSMPHPpViSNzUIG7maj47dOtB+OMJBgbTkqhkTAcAqDERL
	 M3tq+pUwKPC/Q2xhJ+YbQkTnlstbHU9I+UO1oitPsD+4uvT8TzW7E4Ix9rEQb2ucdk
	 XYxNrNGwQ2OuAh88nhF7afjI5WS+JjxITSLTWBkQcCTSHQ9cOuaXqjZ3cHg+bEoamP
	 sTdCxbjOolHbFxEBipbFmz9EaB4h97JKm6aN7fnxpZ4DSyopI6H7gMz/BX9/8TxsOA
	 n6u/0r4fd8nhnguUjyMdswSLRUIdlQ6d081fELaOLtmBUvXBaEUHWISOOnXpd78MQQ
	 z/V7SG9tEBQxQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:33 +0100
Subject: [PATCH v2 12/15] mm/hugetlb: keep surplus folios that are reserved
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-12-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@kernel.org, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2197; i=david@kernel.org;
 h=from:subject:message-id; bh=iyGBWyxJrp1WOZLQ9hPw/96nNcEiZoLnjNT9qzvPK60=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3d+quh/K/Rr4jpmr7qbrfvuerOfXiC+pcqO63/m8
 ZVfgtkYOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIiRDDH85XNZdbjsypc2wP
 5jqq6mq3Ss/FsfLVHr9j4Y+UbukJr2T4zR4dl2B+eBeLxewSIc2Py59NdVpyN0C3rp9hi3v1L/M
 CXgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qk5t915ws3ea8fthejqxr4p7fhnwrpzt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9AAD520006
X-Rspam-User: 
X-HE-Tag: 1794853901-894955
X-HE-Meta: U2FsdGVkX1+s1+Odqyw3XoHOhkxUa0+OS0SMHBtY7IPGlg6CN7Nug0nbobC11vqWts3SdEgxaoyYyd7HX6600kUciEel+hVKU57uV1fkMZziEN6ibtW072J1NaTTV6Jlc0yw7iwnSQrZTvAnW6xpt8R9FRbxPkMBNldB3K9Xr3ZxvrvEMVRkFl1hhcyB+EW2AeyaJ2hr4mw0hzWOaNS8aZOBOctl0QnD+kHvhjsa8wDm0Or1HTEwqD8ChhntS/IBjmRB0Dnh/t+skPi/udROZE8UKG8EnO9xjhKho0Gd4oLKor1/rRSx3KqsKQrYWjr3WYrW6YdY1rdUs5GUaauDXGP4p2ydLldIrHQCTk+JScQHsVYO/KXDTW58+o1D9r47egKsPzHXeSAIg86x84W12RsxVJ/gnqAAqnFkfcCLFZ8Wyoor+aZxZTHD2PMmXp0VjgKK0a15N6B2hWG3PCZDEB0g0yg18uJErKxAFmzRPj41YL8v+IIzrFxiYN/4uPH68XvZUhxkVAYpaqvAGJXbx7Wr3su7lm9XuzIPI4um+ZJ8WrT/QUh//VDVpMKuFR/TjH8e93rH5mFq2NGhro0AcWO2LG6QMNbHSoKD1gXnSSSKwCyu91L41gGFXNQIs0BxqiYVzduWjmRQZLpwIptTQ/ysPCQVIzonzQGJtSj2qNHovM+Rs+pVSHbyMQUsQqt61WnaKsn3b4eZCESQ2i85KvN6t1yeqOUJgcgtCea2B0Lx7hEv/wV9Pj6Ny2wVtIdTFJ9ZmvQm8j+RV4Bn7h2kibz7KxwrPtT4dktuNWL3iKRIH5e7MCfWAmVjg3O4Lo0EF1rt7Dl8kBFDjKhkRyThEUPrHMScIz7kwUhEGPcM9ez/BY1BjPhwibWG+qniFzwc/L6WS2yOdVALcZuFRQpDnHIDtPS1L54acLyaZi7/dhhDZG4ZdEf1o13YiPcEUeusVpuWj7521J4HePpoOUg
 qLFe7FBq
 BU+gsJnhV1G6cC3nXBLYz/YrTtxzC9qlS0FoknekT8K5AevQot3fU34Quw4+eYgQTlGgb7xudphsTbIZsK/ZNTY46d5x+OJrlwYmce512eRREh5DSU/+Gm6YOorfICxZ/pLVtC12rHeh6mVe5xvnhPbWtGsZD1/qgioYHfjBdKmzjivY3EVrejIyfDk+5lv27ABFET6PLWSgavA13WYpZOoodjlaHq1xp3sthecPotfA1/SRrwqdXUBH/9IbOxQNIAOxsLa2cNhfQy7SXN0lViUZjIX+ko3D2YBfoZclT5bxhS1EBLu/5uLC2K0izmeywyhFpzYvpzE0sUNKrrF6bTlL0dIHlfs5gi56TEsHCc9lHILT9IrUoPcCFYshXEVFMfdVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

free_huge_folio() may restore a reservation, but still returns the folio
to the page allocator if its node has surplus huge pages.

For example, start with no hugetlb folios and allow one surplus 2 MiB
folio:

  1. Mount hugetlbfs with pagesize=2M,min_size=2M. This allocates and
     reserves one surplus folio: free=1, reserved=1.
  2. Create a 2 MiB file and write to a shared mapping of it. The fault
     consumes the folio and its reservation: free=0, reserved=0.
  3. Unmap the file and truncate it to zero. The mount's reservation is
     restored, but the surplus folio is freed: free=0, reserved=1.

Besides losing a hugetlb folio that is required for a reservation, this
can also make available_huge_pages() underflow and cause other issues.

Keep the folio in the pool if it is needed to cover reservations,
including any reservation we just restored.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 07443a85ad90 ("mm, hugetlb: return a reserved page to a reserved pool if failed")
Cc: stable@kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comment and description ]
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 112fa25f36833..2fd5a5e585ad5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1778,8 +1778,9 @@ void free_huge_folio(struct folio *folio)
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-	} else if (h->surplus_huge_pages_node[nid]) {
-		/* remove the page from active list */
+	} else if (h->surplus_huge_pages_node[nid] &&
+		   h->free_huge_pages >= h->resv_huge_pages) {
+		/* Free this surplus folio that is not required globally. */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);

-- 
2.56.1


