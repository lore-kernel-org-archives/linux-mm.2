Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D79FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7DF6B008C; Fri, 27 Feb 2026 08:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93AD6B0092; Fri, 27 Feb 2026 08:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5826B0093; Fri, 27 Feb 2026 08:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0666B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E4091C1FC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:31 +0000 (UTC)
X-FDA: 84490303422.25.9B05DBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 82CE580014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YZvAq134;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198609; a=rsa-sha256;
	cv=none;
	b=70TDT1peNGiuSPSKAHo2V3iNcRDIK+8RUUoPuEi6fijWq6VRSzf1Nk/98pnW8pooxoQlK5
	6PT/YQVHvS/iD6HM/sJ7bqdpbZ5+pUhOvi/n8L3MzInnphsDNO6PyCWWo6r/MRLYsXEJyt
	hFX4na2NEBcLUlI4ekFbytXEqeQDn4Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YZvAq134;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pkuGcBWjKYGnL15zvTI1bqoJdpIBzUVwGOccdbxQMI=;
	b=v/VKHS+xf19YcCZ8pjhrj+ip/QBuJJpDzwTUmEn7bhC2xtMmD5EIWuuop1U5nMyuVDmbbG
	S3tb+kjfggQe7pximPafb4nVdHk/jVKcg4ufJ9Kd+6GI+n8z8v8TBjP5YsRhXToG6pLe1L
	zXXPMBx6aXCGLTHssp+YaGG4MLhHvlg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0F034454C;
	Fri, 27 Feb 2026 13:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE84C19425;
	Fri, 27 Feb 2026 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198608;
	bh=0cHZ5LTDrjAloaUBF1Lu8YxebKzlQ2YWzvzsPNmbff4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YZvAq134uJwnMaAY6woQZgYApymFWQ52HpICh4sboDu6HTYiXk6ONB6DcURha6QTu
	 tHRqUj+pSkdB/EgKJzNmKeH8eGw9tfMgCy5zbce6qkm889RULkI9zj60dPhRTVyurq
	 KDhAaqPCciJz/eIuMQH7v9gZ3hLgLubwkBh2G4cn3nvulHZnuF4HqEQ83lTwMztHPC
	 hyec+jRMIfTP8rRMV7PbFlOTZAfJ+ccnk6I1BgjXxHP2rwqgaaiEjUmkid+yNtATm4
	 xkXzkcrEXLBjdSQqjEC7fJ46UcZ8kukWqINDNY0u5kBMPNe8HuGkvVr70nVP9CLHNN
	 Sd7mFgwRMBE3w==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:43 +0100
Subject: [PATCH v2 4/9] mm: cma: Export dev_get_cma_area()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-4-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
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
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=mripard@kernel.org;
 h=from:subject:message-id; bh=0cHZ5LTDrjAloaUBF1Lu8YxebKzlQ2YWzvzsPNmbff4=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+2UeJR1/tVVr7c6zYLWiXOe59V95i2a7fr55Up5h
 eqahwL+HVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAinAcZ60wfzHi/fs7P92uO
 1x+9FGnI5C6VeoXZVOr/n4Mn+JZ07VxnY1Thsvyd76tHzBoXJkbu/MBYzdK+a8XcnZ5rpzGf0V0
 zd+asNCvGnPz7c0Ol1x3wS10+36q/vvKro9iiZzeEUq8HqDw+AQA=
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82CE580014
X-Stat-Signature: hg56wz99z8y5geas986e1ukheicf1775
X-HE-Tag: 1772198609-268945
X-HE-Meta: U2FsdGVkX18knwLALD3zIFuohkIr4EFnsgSFGbUhRiexmbL0Q16x10qG/d3qYdMMZuJ6Zg1QnDqUsqI6VgP6jmIqwsJupv+q2mfrTiKcU9LhWreny7bHMib0qD+CjTl//OLpziVfWo2TPx9nkCLTSy2fvuqq6aeOdLYEjiFV7X86PNq4rB5jrHFATg6Q0ugj0G1OO3YGWbZ5MBO5UiuYKwIfjzdJNsZQdeDxJ9O4jLtL90dWhYyGbeffWNS/UPoUemp1nI+jaO+xzLKb3OHdwJFSQFM24Wqdkl7DXP94BHtjkTzDSrWx2XF+yHeXlAPU0iw+QXNIj5hx5Msgrnlkq3l4sO0M+W+Sbskhib5M+vXPJkKmsiL+FPkjMqqyzg6OLjWQA6pVi2BfpYu0cxWqe+RSgw8WjnQkJyHbcGF+/iRKh6voYqYJ6P4zJ0Qq7zsa+qXEUPL8Fv3Qw6geP01JCgbWvjVucaVeRn4DLGvWnQ+SYsisVsHhdbMV8sSz9U0WlezG9yjjvRKxKz64enBoU2BtJFKOp4c9AnlRtliGpC76Pey7kmjtg+tn1JLHrJ3z3xEx8IcGcaoUOZEy+thymSWyPHvIxa3ICoAoiMERZNQRtegB1EdxBxicrY9fyXvBxhJEvhX0o2YRQKtQzXf5/3B9J6dzJN1ZF0pSSX+CqcDKn5o0u/JfFWzA+uHrGQTsQt70Cl97uigPI4+1HnXG8qkV/jtDZLpvCHL+0W7nIrPxeSo+BLC/Mj4rVRDMkx8Mo0tbv6snOWdhVUZ0OA1TNL/OMgd/rj3lxS/zSD6dSDWQdmcxqA8sfEZfPIaUZrvmuvTV8daR9l99XNffwRRK4h5LMLlVKqsTASvin58R7Y9eN9qi2+zJ1ZWB3FjqR9DADzr57HXcXqn4c+BJE72rEUq2SldYuVnJpt0UZyPJL9u/11F2C6BZGtYypTnAvXV3x7qGdSDZie1pggqEB8b
 j+Oew2CG
 nEsRp50B6AG6qeIEqRK44igeX6+tCgrQYfMSTrsASn/+QS3bnuiU7af1bNS0l6iDQm1fVPHyDxFhe7K9KJ9sCUdV+Wt0K49YDkzl4UI+OfilE9fuYSa4Dpy1GX0AXjyFYbkHUG9xTaRKJmnvDLcFR+oQ7ue9y727hnsyaHnbxybvyfwyN/N/MnaOFh4OXlC/24Ze7OvTekoXqOV236ik88IG+f1fr6b2gANZMF5OAsivRnOy8O2Aplgcd++2gHcOPez+W+ApI0QqCRJdg2GSilnj7c+C9hAKlLKYY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses the dev_get_cma_area() function to retrieve
the default contiguous area.

Now that this function is no longer inlined, and since we want to turn
the CMA heap into a module, let's export it.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 kernel/dma/contiguous.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index a4279d800d4658bf1c33b9b1da100eee1367d42f..ad50512d71d3088a73e4b1ac02d6e6122374888e 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -106,10 +106,11 @@ struct cma *dev_get_cma_area(struct device *dev)
 	if (dev && dev->cma_area)
 		return dev->cma_area;
 
 	return dma_contiguous_default_area;
 }
+EXPORT_SYMBOL_GPL(dev_get_cma_area);
 
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;

-- 
2.53.0


