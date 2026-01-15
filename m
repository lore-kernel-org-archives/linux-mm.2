Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147CCD41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDAA6B00B1; Thu, 15 Jan 2026 04:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B91A6B00B3; Thu, 15 Jan 2026 04:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB376B00B4; Thu, 15 Jan 2026 04:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8996B00B1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47ED716028C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:24 +0000 (UTC)
X-FDA: 84333657408.20.FA386EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C64A20007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bGUQs23U;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZY0xn2Me635ovey5ksmcPxpugv1NLh0yp+8ZC+NRLE=;
	b=IBteKfc05miOui4w17fmzTWryOW4LUibbLXkIUlZrmtRn0DO8FX3rqgwARGS140cRyOKtx
	VSKa9qmAl6uygxiCqcqVc/RAyFxyYhtt4IgjHT3JXQrMm9kHWNStoBlH1pGELJOxKeXJ6V
	6RY6HyDBIjmNl1OOdIjJdyMZ4X8Kpdg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bGUQs23U;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468942; a=rsa-sha256;
	cv=none;
	b=2kE+Ats/Ypg60RQ1Ucw7D8gYhfBxBwaeEs6spXTnFUXI1dfRHmw/d5Bqesy8H8E0h8UyDz
	hArTADOIs5doos/r+V0dza4vzdTPawWlFTl5IMqpElrSDTfugA40sKIqZXFTU+p5R94tGd
	NHMBt5/S45vPAaTPorv2rT810v8ufeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B6E442AB1;
	Thu, 15 Jan 2026 09:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC667C116D0;
	Thu, 15 Jan 2026 09:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468941;
	bh=Oj+us+E2nZAjD82c0L65S4QjEivMkfGsOYR3vhKdMVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGUQs23UuL0MUIaVZt7HjPch43nLsyQr8N/KNriEAjCx1ksgLfhW3wh48gTZaa+qY
	 96tnj/UUzP0PIXCipF3pzqx5dBpKsv8RRkmQpvassgvOnDD1yC83WGpuc9Tn802iSC
	 a9cN1fN0mpI9pDPh/+61Faxwx0B8M6IYupNqigL7L/7o/aZQnf8fmy2eka+e+iRqad
	 d2DobqERbxqyaFK6XuxZf8/k65wudAWKWSX8Qqu6w1yrr1CNUzKqkUMrU0y1SwVQSg
	 XF7DROKXMmmj9QotQznh5z9X3AmNma7WE8e2XDgJ4amiXBfaEc6aoY4Q3j2AMyI5mw
	 rQEuDPtwxRwvQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 17/23] mm/balloon_compaction: remove "extern" from functions
Date: Thu, 15 Jan 2026 10:20:07 +0100
Message-ID: <20260115092015.3928975-18-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4y5t39pf3rno17sbqda4uzrjf6pd65ow
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C64A20007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468942-205370
X-HE-Meta: U2FsdGVkX1+ZWQXEVK7neYiSTW7YmUJx+QHX7b49mXfjfa4DLE/G+TqkBlzH1RaLHhI/r7i/+gSBAS6BbgaO2eElbFcr1UurTvJCXq6TOU287kJSb6SOhFPS6ZHrC/A5omvb/m9lI1Cj+xqAEsuWD4Oy0w4HeSLt5bKmYCMH4c2//WIAN5jcpnc+kyryEEDIrMSD5koceumfa2Ji7VXWFGkinwzSF3LzNW3GSXUqZOGidU3yzSBzs3qpUarUG02ikerGidesWmKCKxyJ6YEmNp0MQfse3UW2xmYzUQfnNNOWmgXyX98L3gVTwYNZ1QYVpwq/v8qr/gR8ygZ5cWTowVzZGT6Tjy4g+WJvwGx6jtnUt98AnvQ2MCDlajwnrQa/EYCxcwxxcZlsgZxtieNY7wRrG74/e2g6bHdcmF1TOxZo/g6ITiHFbvV+bKFXNY69gqkWqs2EKcIbQUbQRxSWYbQaeCY5w8DYA4n9WjhmFcdx4LmmgftSAGU1IVN8inQ9qXDbnYB4eRXzJAzmXqhXfeHgf55jf1BStvQIjua1rA12xLhuyroaDArIm9xxHAZ2bDlEmvG7C3xpeeyzEazSA7wz3Km0q/jQf3Sug05TBtEAcxI3CRILhzZEAUlUujWYpjg6nYAXqnq9ds7S6YLcwuPZ7iM+aum4JHwtPXX61rkZ1G9Qm//nR9EC5xgbhfW0tnEtRKOq41g4ohQO5VGxPzIFJTnvUhMYrzynll2n9zhpJHQitNMTkMNYzy3dmhzPuc0ozf2QlKXsqjvrKmWZH0AwtABxfV4fbZZZHpJYgCKyz/WZ76/hXXcAd8eTXK7rIVmCpMLIiDTck3e9u5PqRfpk9SfenLHJiCan9t24lRi25GxSgxbozZ3ZyzkMWQtxlX+AJVTujV08AFz6FOj7RgoM6+BqGfhAuCoO+mrWg1di/J4QPgBUnBsx68QURWWCVfK4LMf1FV54x8fJDhw
 7He2yeXz
 r5FU5AFyXk1snGpugCYRl1vdj2jPZz1B7vwoS5AmafMBD3KRqYMK+8JMjFfMqmrN6mwrN7r/X5Fmq362wtdTgsnpevrot+llt70s9vmKc9O9RnBF0fdgtYnc0o72aBzmyJWoRLYYdiGY03x4Zsxco3yO50jR49Z9RQVu/GAzUp6VM/chS2gUy7THdE67MqtZ0kqufERRUQapRf7teqKkJGej1KOKw1fObu6E2UCMRWXfwl9u/G/YxddMfBCaHqxImzM/zM9Oa5Hs3reB7LOiZ4XQt0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding "extern" to functions is frowned-upon. Let's just get rid of it
for all functions here.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index eec8994056a44..7757e0e314fdb 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -59,14 +59,14 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
-extern struct page *balloon_page_alloc(void);
-extern void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
-				 struct page *page);
-extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
-extern size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
-				      struct list_head *pages);
-extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
-				     struct list_head *pages, size_t n_req_pages);
+struct page *balloon_page_alloc(void);
+void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
+		struct page *page);
+struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
+size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages);
+size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages, size_t n_req_pages);
 
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
-- 
2.52.0


