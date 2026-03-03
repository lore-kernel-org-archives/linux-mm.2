Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F99EC0495
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43C86B00C4; Tue,  3 Mar 2026 05:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18956B00C7; Tue,  3 Mar 2026 05:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45096B00C8; Tue,  3 Mar 2026 05:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93C4D6B00C4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6054C1A03E9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:43 +0000 (UTC)
X-FDA: 84504340326.22.5E78B97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A344AA000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADpL3jIO;
	spf=pass (imf15.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPRQYmHrVvcJSbAxnJLz6xu1jGb2AmGEWR3nhNOgtpw=;
	b=4qb1XhFqo0NyJ/b9a91mxAl3JeWdCaJGwWEwxYnO/bsnw8KPCga0X0XJhW1yUf9y1vHvVO
	5D7aXBb61DUKVmIheDwDYHysieK2bTwrz79o2d7an7hcCcBDrbFIKCBaYK0OUl+isle/OQ
	X+KKVIxAEyi8Y3e4vtv/LzM+N0jHpus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532821; a=rsa-sha256;
	cv=none;
	b=lmBEoebzKuJYnxXQkCEfTAUO6JycGL6dlW5pxt4fGYhP2G035rspbUcCOPcWP+J3mluvwf
	vAVCfKLBpO6sqT0/c7AJxDs5mRzrQzCwSjbz2CuX5kRyCcJgRcIwl5zqeMgtmrohQou9JZ
	6YE0hMdqHpuh5ZYO85ZGrKErEjN3Sew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADpL3jIO;
	spf=pass (imf15.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3453A6013A;
	Tue,  3 Mar 2026 10:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86090C116C6;
	Tue,  3 Mar 2026 10:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532820;
	bh=oNUPt44D7xewgXiELSrkzONvN2UIFpJB+B1908QRT5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ADpL3jIOp1uDm7HSfLQGSaxxoDKfYlUUC08JfjkT40HIv1kDS6uscZlg/RFCc2D3i
	 vyua0nD6EbOGZLWlIbC3nGpLFAAD9kZSZODn1YsjjXKvYLt1HSQZiK3J2GmjdZ/VJt
	 u0AUVs22fHYQBvmXX+UTxO1B15J4umInL4/FFUCoWOXTCOZsN8Lh6llVp84TelzZa8
	 ZafeIsMhpE3tmLoC9PQPOY/NBEWCdu8a7lxDxfu/YO+KPLWrhd9hB/6z7/P7hrm9LT
	 vvcJBOJ1Nfq+VVBen0KRd+bRSAAlmFLTA8hkquNtNt1lMRPCipCoubmNKTWqTf2wZR
	 LO7hJLS1IUF0Q==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:11 +0100
Subject: [PATCH v3 8/8] dma-buf: heaps: system: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-8-24344812c707@kernel.org>
References: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
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
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtpjLhZrIvOCLmau/886knTHtqxv8n09Nyyx+oDj3r
 ut8JWuVjqksDMKcDLJiiixPZMJOL29fXOVgv/IHzBxWJpAhDFycAjCR9M+MDZfKNSakNHG2Pu2p
 1td90Ci2e9fvDWuKXH86fq/Yk+12TfOj9j8bR+VVB078FfeZUh1bwdjQcu2u7Sxvppnmbie/7F0
 uZi/gaby1/Lhe87FY2drnoSW6kjGxWf3566oM18xsCS2xLwEA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Stat-Signature: ph6o744ebj7mftzis4ot6ohngcdamtq8
X-Rspamd-Queue-Id: A344AA000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1772532821-345533
X-HE-Meta: U2FsdGVkX1+VB02DSOxYQOEJxYiKpOK/bReZIRMQN0DBlmgNoPGUuJqMjPE4Ve3acLWKlzACJ41+b6aYWD9aWXxNr8iwu3Zdrj6ABC3xYqd+8j5xDH6PR3+8b9gaDzHwRfQQz+ABJXtRc5ZqW0Llcwxoho6TAP03n15Hr/NB2YiC33o2MdVXwdtedS8jwJ38KTQ1pF6zecEf6IC0lCQcaYrLWk+aORgWiFX+XXcwvmPwjiatO9+xWA1TKCu99J80E8bpeDTrGwy7ewOGILwLlLNbIMEaGowG0/zo/tME8ZF1/DHR2Zfw4Wf5OqYPF7Tn8OI4wj51fbtw68X0stNgN2KabtFMFbwqkdQsD5eyTDq+wGNXomwZMOgdWKSsETUYhw3VjhO819ziCgtlqNCV13tMXumZ+pyQiKwr+MnjlRrV5MRTB0RfaBPutc/i368cBsXKWcA8K6b1+q+MwORAjDemf6734gr7M1JU8NJDHAaubtFnS9cGjse5THvMLVUzwyrmSLlJ8Rd/uKCxwA80ePXivxzVRZ35SJcHSQQAfBk6d5SznT+oow8TiS68/dyES8n+lPjPBWBBdQt3LvO8ypspPB8pi1Psq/4MKDvbF+MJ0HK47UyAchdLsegknfjMAfjM1QWpg+gn6KXRtBxdsZeYLumqVgyNFLoVKJsxcyBc28QDHd/KCPS6rQ0PoMdmN07lBXO/icFrPcVNMCyDCMgY2tJgLwQMUbNSkfnvYUrAUhLZmCNZ+cBunkUEjUCar2f+lJU/8eC/Bw/areFGB1D0FRe+pUr544gQd4ssyh5xm2Ro7UzN0UGSA0qBiZMkZJhlem+4JhYuWblDapoei2RyLjvVxqicXLePQdZAt6JwZ7kfOB3cs7ILfsQjZZ8mKAWsmDB1bU7qTQuY7nXa74tLAv48ZueTeYREXB8LaQxaw+cIZQx95fI7ixlbmzO1uUTM6P+HMfIibDiEmR+
 07gNKq6I
 KeuLBWIpiFa0U6jbeW3eCuv0fm0dsQb8vWnOUgaZ253Tfzvl/XrqeH6iwitw1ZdRQq/GofLW89gTmkna4E+8fEuLnm/S6WQrZx602EnfnO5M78E+m99YETNZAR7ChgsBXer4yIPgiAYap7qd7jxX0JD20sqFWxxHyRPECGOAykKIhIfgxSsRgNKyahucn/djw88gk1y7k3+RsPI8G1y1eXdBKMoS+KQLQj9hN6d5Zy3dhvC56PbsalDIzK7MNWeUot5bly/vTLWU7+TZlGGa5ZLD0q+S022e0V2iCAApnAR37usU3ZWpbUrnBtvBrJV3hZL5EjvUTKzo1TpLfpwPn/pVzn++Ob7SUXuheZrKepQUmeZtiFaXhGRTSZPvFpoQUDNey
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


