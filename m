Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E4DD41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5856B00AF; Thu, 15 Jan 2026 04:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0DC6B00B1; Thu, 15 Jan 2026 04:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA316B00B2; Thu, 15 Jan 2026 04:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A53F6B00AF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 600098AB0A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:16 +0000 (UTC)
X-FDA: 84333657072.15.9DA02E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D096E4000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9KraK3N;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYhbllkrpyqFhkHvENBgOPPKCa0qoAljfS3LGPp6D8c=;
	b=C49CzgcVMKpH1KPXwA74uCU0N3d+SVfjCMj0kDiUk2HmvZrH3POqqEwB4CLEulcqN9isS9
	ZuhiTWZA+kQs5paQaJDwS0J6hT2iL6BxlNrNfjdezCpROkpfMTlTtSEWQ+nP9yxeeCPwJ6
	FaPYu6WWFTjE6Uu4RJrl8h9CZmmVaao=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9KraK3N;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468934; a=rsa-sha256;
	cv=none;
	b=V4qfY7fcI92asiwivfzpOnIhIuThGtA/fVEb6Skxt/wxTJWdGzfV80yIgclYv3jYpVzDDC
	o/DCzXK54d84ERSGRcp47SuPFKuz0LPY6vtq3Xa9r+SpqqNLJsmMD8HQjGangLJqwxWOsO
	LD/wuFMhGyJ5LVEF8+RxFvXGwur56JE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5008C601B2;
	Thu, 15 Jan 2026 09:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD2EC19423;
	Thu, 15 Jan 2026 09:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468934;
	bh=6zKbuQ678tGVdnAZlvqQEolgSvUqQzw5yEAzbIvNTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9KraK3NK478rMPNcGB2SPMKVpBD/lrCvQmN/00cJRhyaI0JynINGaMLGTCknHvx8
	 XuFSz3psTaFCfLftFZKK0z0+cggwozZicZL/vr8A/xdwbkfqZjPUoAfzvvZJHXEo/A
	 7+hEs6g8C0kTDbb4y08ZqIpJ/DarC74xjvTOAOgU9+ykYoFIQ1GUOaFZkPNDz5dX7S
	 E29MMow6YjyylwhXf6kVkAFxlPTd435UVg7ZHECFwj4mGjktBpkD9SP9SB8OIE9UFE
	 goeg92CZcbZh7uXzeWr1/uvCGGxwxM3BAdUib/iqDBUoeHdWb1StMML1t3XCtjKQpm
	 p85cX8ZTk1kJw==
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
Subject: [PATCH v2 16/23] mm/balloon_compaction: mark remaining functions for having proper kerneldoc
Date: Thu, 15 Jan 2026 10:20:06 +0100
Message-ID: <20260115092015.3928975-17-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D096E4000D
X-Stat-Signature: x3jehxkogh3355p3ejqxk49dhg8w4qxf
X-HE-Tag: 1768468934-507163
X-HE-Meta: U2FsdGVkX1+azvAVzKe6GuCxsNiL+doKFu2Do0AIr/9NX3KYgF+klcK4da0BLUKdCmWUPQPba8fKSGhCsKPqtzCsucr9tDxzA3wDKfgR1+tO/0WgfsI7TAPesNqO+tS1zkadR5ELA1eHOy2temBufcc33rzBX9o3JVEwqD8gEBAwwwoI/Mw+ouJAAhBoLGhJctD1WWQYnF/Emm8pVzNmszrKQAwjR7GlCyxoDAkEaAkHoOUHizf8CnilTbbRUy4i893tFw/KjUAIueAkkIWK+i4K5KXbncI8vIXl9JueNzWsyAG212RLtjdzZKDQCpYnsouUHaErMK2KZxy1jPVX72lPQOPZcgCmpwDd0AGCbS7MS8PNcdzSzlRaD+9h6rwcpuOxpUyLk6ibm+zUUtwDtCuM9s59+X3em4+7aHIQ5slloISq6qAsL0H/qDakBth+15VWpXyxO53ykUzaexVpIbfwIkwMw+V5GMpjwlS9ndtra/NMuKnrGpxa0MYNV2sxY0cHhmtqk7ghIYRNbtRQiZ28XjBCOhEI96fpj5qQmOL6q4pDPIZw36pLzsnTAPT91P9I/NcEZxW5KOSgPv8YsJv0JK2L6T/S70y7ThvqoicGPtxiFFIEDrymqpiovdM/PXzheAqIFiseBi1zGFubIgkl/Czq99vOBqet7Q3wlGblj4N626/MJ7M5ketKRbHLEvl/FxSetbb0mW0+LPCZWFFnZZMGfkABp+qO9v8zt9OcP354GRgK3LMt5hfm84CNEp0MFhXC+jE/UAZNKV+6oLL6jXGo6C/D1E21VP5oYfmtmtqjP+WCNoXk3KkzaVUVBKdmsFwJA+yMWjeoD5DDqmAPxOsMkq2jacbU0vPLDCJV4760fYX7DELLeJjVkunnzLqff2pL2ZnG+l4s0LE0evqVS5gvm5S4NZq0IgyR/0SbVEBP2LlgEVPsCvdI8z3UspPa9xfan2iBHjwtCnp
 ezg68n70
 eJZktpgvYgG5UhQURD4v2XZGJfRPvXUkXX7Iik3vxZ9lf6FvsFL2lEV1pXbKceJoa5VOHjucaTC1ZPW2Cz3KkZzs6HODB5DcxscpDeX8pHRbe+2m71JcymrgNcFqGTEeDFMs9xG8WI1wmysyQbGMAaIeAU53nf+dN+pbhs0nAoSRSR/xOTqiWE65KI5usWByTpBgExnJs7Fb7ULH5HqJ8+SMuO/MI8kTboGcor7AIsDYyP1+cp+towzUc4gMFvxqUxreyPahDGx/DQZwpbO/5iCDaJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks like all we are missing for proper kerneldoc is another "*".

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/balloon_compaction.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index f6e0582bd7ffe..f41e4a179a431 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -22,7 +22,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
 	return (struct balloon_dev_info *)page_private(page);
 }
 
-/*
+/**
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
  * @balloon : pointer to balloon device
@@ -42,7 +42,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-/*
+/**
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
@@ -140,7 +140,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
-/*
+/**
  * balloon_page_alloc - allocates a new page for insertion into the balloon
  *			page list.
  *
@@ -163,7 +163,7 @@ struct page *balloon_page_alloc(void)
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-/*
+/**
  * balloon_page_enqueue - inserts a new page into the balloon page list.
  *
  * @b_dev_info: balloon device descriptor where we will insert a new page
@@ -186,7 +186,7 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
-/*
+/**
  * balloon_page_dequeue - removes a page from balloon's page list and returns
  *			  its address to allow the driver to release the page.
  * @b_dev_info: balloon device descriptor where we will grab a page from.
-- 
2.52.0


