Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3DEFF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89306B00A1; Tue, 31 Mar 2026 06:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AA06B00A2; Tue, 31 Mar 2026 06:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50486B00A3; Tue, 31 Mar 2026 06:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A50656B00A1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 692D113C152
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:47 +0000 (UTC)
X-FDA: 84605914134.19.85CB44B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A36C51C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/s6p71L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951245; a=rsa-sha256;
	cv=none;
	b=syz6Fe+F8LBPTpcHc8Cr90F14p9B+IMpRP2fVZMqCbkwr2wbo1Xf05YceBYoyxZtb+49N2
	mhvM+2x63Hp7UaB1gVGA/9nXpqiKPAnNeaOjjgEKm6cml4OYgs0wW08zKNYN9eoSPCt/sY
	hcwxGVhgNlM6VEwBlWPy06COIw5s18g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/s6p71L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPRQYmHrVvcJSbAxnJLz6xu1jGb2AmGEWR3nhNOgtpw=;
	b=AI2MGhv0ab4HEfXDhNbS7hlluml/TYpEjxFy59wooBi/nSsM9zaWiTjXkk7yEruF2Y57bN
	xnijk8vJSu3d8InIZjM5MvPIfkSzyxN0gRAib2dSrM4wx78HWFB0srDZ4rJgKnQbRg6Pm3
	HXX5YKR3cYn7CobPyC+RsokmqXQ+HV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 305A460120;
	Tue, 31 Mar 2026 10:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85040C2BCB0;
	Tue, 31 Mar 2026 10:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951244;
	bh=oNUPt44D7xewgXiELSrkzONvN2UIFpJB+B1908QRT5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=s/s6p71LxMqFQbl4akadLuhcwdZW9aya2yBfpNfo+H/No5t7G1dhY9pZ4066sLYDx
	 q5mvU+6WAMCW4CsRm+5zBophaRKt7pmtDCVaK5M4hOq8oaTj+rBpWeEcz3xJxP6Ff5
	 8WmRsbGsNNVZDIhPERKDwsfcsRCpVT6bFinWEEWmnFPTDeSInt+0KOikVNdXc0epxd
	 zbyBBB9nqQyEpDoFbnshN1tdI/iudjbEXKgMATw54G2PeJQ3sjUaAHCWp6R6oEEpEN
	 c/ZDiGaHirJjyEzHO5lV8L2BLWWerUvA0a2U1H7q51T0hZDAuwAWqrjxeo8tsgpTzg
	 oqKxai1WQyI7A==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:17 +0200
Subject: [PATCH v4 8/8] dma-buf: heaps: system: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-8-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=mripard@kernel.org;
 h=from:subject:message-id; bh=oNUPt44D7xewgXiELSrkzONvN2UIFpJB+B1908QRT5k=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZxt66SQ2vj7w7OYxd5vfvxkLJORYhFqY/HbXJbDdK
 v0z90F9x1QWBmFOBlkxRZYnMmGnl7cvrnKwX/kDZg4rE8gQBi5OAZhI/C/GhrO/OBSVxPf72jHa
 mqf+O2h2+15d1FXZjJ8vGirXCGp+m7aO99LpcvaZp94m27jmScz5xljv7O6//3xn08Wbkp+Y896
 eNHlgelTtfQn/8vj63oZQx2U71J0Ox/lpHp4pkcoWf+LK8cMA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: osokyezc4wcmfd364pjq7jqt7z347wyi
X-Rspamd-Queue-Id: A36C51C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774951245-578517
X-HE-Meta: U2FsdGVkX18+C9owpcRM5l81cwLcMFqgNqmbZVaA6m17ar9QLKhLrtjddabYNBTwf1mjgRAGlcVjQAe5tiwOEEusVWJpvyUBGflU5V6Xm9WdbNYhIYEJR1Oovk6Way4R0ZsrLEyEdYo0WocFE6enn0hX1E8XI/zjoIL7Z2tpHKT7yTUpDsF5zDN/cTYsjyN45Pu7zKiDEH9YH0byLnH+2ujU7ZGPmn0OlQ3dP6ONi68YRZS2k47urrmzpwO7L9Nx6QHXFiA34SWNMYoMbU++Jb0VaPP5BKGFf6OJhJcq5r6NtI86ThOX5n+cHPHU1JDxakAHQPsNFOdJZ//ZtMdCsDSLt6LIqRlsUNi7ev+ihh7Sk42xGLLWOzErJcn9TsVXma6t9n/5H7ybfEubxdOldrVDV5izGal/4OVQ9PchAUlHN6xFd1KMDjNH4F7bEncqgVBkRAooJTXqvm+RV0tmtdmucL5uH3yrrqh/oOA9nbdLmtDT2EnexCFP5txyLmzvyAWjuDPaY9S9K64J1CMzbfEAV8QPFgjWtssLNjmUt7JO0gsafNNdVjPl4Ae53Ufyo7k6QagkPy8YVvIq9ixtMqCFX8V0qNo2mJIGsfkvy1ChI7SoRQVnw04mLkn/3wc6YT3wXEthf2rh4mMvOSEGGy5Ait4CTBXsJZIcU7fOgFjiTq5Gt6yVTPwOjpJ85eetjVirdQQD+o7hvbQujKfI2pIjIaoSFkjR8HtVMSGSeCbRensmf6c3pJq5tcS6R9tujO4wUE1PvLqfH0mhd5nhXBWudnWgW0K1KsUIArKx4VO8Zrm6leW9Rl8iCyMXdm/7FqGrpdRPusPnds98N4an/Xlw+l4vwXx+0Hcozj1ntq4X3T82dD7Igw4Vf8+DyzxVdX4vCAifSHsOXyK74PevkGSrHhDZ2lqJnUtrxW9gpe1vBDQ+B78YTRrTPvby8AI/DHOkbHe8A9/s+8rZvUn
 7G8Wl8n/
 z6Tc7OWiqBkwaopbw1dr4czqo7HiWPq1Cu6NKiCqpUHrgYssfvV84y7GcGL71vvcrAq9hV+h3OQpdX10Xm7kyNrqsHZd15tYo+C1Ln3wK58uEO8ubhoZrraZ6CgxEiTTKlxgrP+npdw4JcKP8acTFytpuHvdIbl05CFiLxEnConQYIRXDRu5UT70KQG/OWklAnN/2jiHADpaQruuFp8Tfs1awEVUHdHmA4Ad4QFw7nz0sRIGBglDETWwXrliSr+rOwVG2OeOvbfc5EPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The system heap can be easily turned into a module by adding the usual
MODULE_* macros, importing the proper namespaces and changing the
Kconfig symbol to a tristate.

This heap won't be able to unload though, since we're missing a lot of
infrastructure to make it safe.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig       | 2 +-
 drivers/dma-buf/heaps/system_heap.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index aed0b9b4febf388376cfc41be9843980d010c4e8..e273fb18feca091ccd9b406e68f86c12efb339e9 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -1,7 +1,7 @@
 config DMABUF_HEAPS_SYSTEM
-	bool "DMA-BUF System Heap"
+	tristate "DMA-BUF System Heap"
 	depends on DMABUF_HEAPS
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index b3650d8fd6511a4a755612cfe3a9d9fee796f80e..1957403b0f2ae5e82ab39f5945dfe82808e93964 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -442,5 +442,10 @@ static int __init system_heap_create(void)
 		return PTR_ERR(sys_heap);
 
 	return 0;
 }
 module_init(system_heap_create);
+
+MODULE_DESCRIPTION("DMA-BUF System Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


