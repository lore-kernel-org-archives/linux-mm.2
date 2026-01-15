Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD8ED4114B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517D86B00AD; Thu, 15 Jan 2026 04:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8576B00AF; Thu, 15 Jan 2026 04:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDB56B00B0; Thu, 15 Jan 2026 04:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C69D6B00AD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE170B7310
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:09 +0000 (UTC)
X-FDA: 84333656778.30.F881C84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 48E0C4000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZdLhXG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468928; a=rsa-sha256;
	cv=none;
	b=zKSUwY/ZEBxIcVICaJbGKG3OixTIBsteWGJsvMV9zZcOqJtDe9oiRwuLgEpIJiV/Cztr21
	z95+GIm/n+jrFDKMhYS9z7Lo8PpBttUZI+YK7nF+52Ui0TXXjpX6KJrUGcQMjquM56vBb8
	oRyDrwsC0KzhJOYMQHRDkDWklZHxirI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZdLhXG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Krs6z9vYOwh9+ATnDFgY6x2j3KV8kxuQF0FGa+p9kUY=;
	b=rwM46Ih8OV2S6bODpQE16fqZjZ+OsIDyAQigF2K6lqYyEaSgNXgdk0rIIzR8E+N18vmira
	bJKh2w1sDSdJ2cwUREkxaUtTI7pcYbAQwbUe0Xz9ZhFk32W4+IIW1uivhr36na/nib5Mhn
	7VqTcTjpk6a/Yh2G+/sRFyRZ7uriZKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 737104174F;
	Thu, 15 Jan 2026 09:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4A1C116D0;
	Thu, 15 Jan 2026 09:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468927;
	bh=9RrxLDqhOcILNhAHJt+XRLUWGRQWJudLU4Xe8hhYhVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZdLhXG4JXKgdqJL7DBaf/x0yhRcWA9OMea3z22FVMpb45e1AaUr5hCLnS7f6YE70
	 De84oIOk6cku3p9sQhGMVZskL3VdEGt9Ewx80abTgrJKY4swAbL7miB0ZBVaEtBNRs
	 LL+KhZAmuO0EV3W4N4F4/bifWzXyoSFMibubLSjNT4Lvbq01o9PD5M0/KuzxxGAlRc
	 pLcCk39qQsCsTevuPxOywxBWafY5Koq0CnZqDsn1KfM3FV/RAEoo8IJbgMX6/XoKOY
	 ukV9b8vgh4FO+UTIvYaYV/n4HqHOJpoe86jRjAMqgxRCcnPJTKAtCShqEKaeucUCQU
	 rU9hb8FynZuxw==
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
Subject: [PATCH v2 15/23] mm/balloon_compaction: assert that the balloon_pages_lock is held
Date: Thu, 15 Jan 2026 10:20:05 +0100
Message-ID: <20260115092015.3928975-16-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48E0C4000F
X-Stat-Signature: fb49pz5oy5136nx7e7swf4ed64shri1g
X-Rspam-User: 
X-HE-Tag: 1768468928-941259
X-HE-Meta: U2FsdGVkX19PQSDoFBzfuPTdbNNEOkrjhg6sN3OeJrLhKtirlIoKqyioNhxO4Gpw/hig/xtJQXnT1DoANcC9MsLDjcQq1pdw3UgHNTx+3sUeVUUnsPaBwHB33tQCwVA3lcJAPp+YuZ3CFC6AOocW2KPQW4Xd1Ry6v9vRxgb8WkcNsso1i5gTgB5sX9NnVleVNOYSrXQnDtClouwYTrQokIYqKzcNObyRiV76x2edTMKbNPyxnY8PGKltmKIq3/Kly5z/JBGjmSYn+wggnZvYtQpXJ+qRh3P8NUXRBCSoc0UTRZ1xipQICwrYIAEo/y5G1rT/BMz3HliQ1x7PDLcR9IRAMSkARVaBIhA5I6wrDGKgZA1uieGv8/++BMsfjgMdAWPkJNorBE44FvVT45Xh0mqa9eLFmOvkTDO2CjXNU/IGuDej2dCd3+jn4NdumF7sIYd66/EIFpc9zEyMb+YzLMNRqiTwLIOYdPus+82k+DwujGnPLES6/zM7hzI+o+gha2/ASFIeUOD9RiDbfna8sM0xPLLD96qIfvEqEZTdiponwRZp7OhljHIdCi0VtuYFlAfA5rSbMBTkctcmvhceBb4VfhKvQh5CNAIIMLHHqxD4pkRBJp0Zxqe8Kh5rPtFAtwum9BondbQl5F+clqjHvZJ5T8s89iQpBJwwI6KID08Ko/WlGS33mdgdqyIweOXYhrePXcadrL7e3Ro5DolJmyhYz+t/EfufVveFVPwfL+CA6g0FV6pTDwaUbnvxVzN768gEH5DXsNbr+W4ystbeqP+wGvwOrVMFCoxd0J6RKvJ1aLT9C78R23UbqdMAAzGFgK2dFtp2gYbO7bgj3rR0WFhTTPnAzZFMdgrUrytlJNRuuL1eqHOnxju8EWOtjIslU9HQQwXo0DyHrH8ueXZ3twJhMU+P58rQDSJQOqVTsfhKCDOem+ffbow8OzJUB1JQvM5PF+off1bDfcKacf+
 JLwGbH/n
 HJV0tkSUU2BbmNAtlzMzg6LYqXV2RIcrKS6yDUQeEbYWsqSCzHeDA5MoK1Sf5pBg2dkQVUXSAyUaG7TTdib8lJRynNSLcpjqVc4blNGy5tQKOtzTd+KGCn1uilKDAl1ycv7ctxcQ9oBT8FAJSvSOKk4hLcrSV31qMRWq6L0jyWAR3+85M7BuKN1Nywow1f3FGgjR0Vvo3okH8zdp7HrOIrHgYUTlzNAZysvnpDmAt1ZgYGFxbTNYJfRdbvr8lYus8kisoHc0mG/35/ljQ5oDu9GFRYswsbCfWMu6e1KBejE/fJtUk1vwW/G1khVoLZNbgkW6t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's add some sanity checks for holding the balloon_pages_lock when
we're effectively inflating/deflating a page.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/balloon_compaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 717bc43732d09..f6e0582bd7ffe 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -33,6 +33,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
 static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	__SetPageOffline(page);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
 		SetPageMovableOps(page);
@@ -50,6 +51,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
  */
 static inline void balloon_page_finalize(struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
-- 
2.52.0


